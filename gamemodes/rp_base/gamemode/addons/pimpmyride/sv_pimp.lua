util.AddNetworkString("pimp_my_ride_request")
util.AddNetworkString("pimp_my_ride_call")

--[[copypaste]]

local function ApplyWheel(ent, wm, wa)
	ent.CustomWheelAngleOffset = wa
	ent.CustomWheelAngleOffset_R = wa
		
	for i, Wheel in pairs( ent.GhostWheels ) do
		local isfrontwheel = (i == 1 or i == 2)
		local swap_y = (i == 2 or i == 4 or i == 6)
		
		local angleoffset = isfrontwheel and ent.CustomWheelAngleOffset or ent.CustomWheelAngleOffset_R
		
		local fAng = ent:LocalToWorldAngles( ent.VehicleData.LocalAngForward )
		local rAng = ent:LocalToWorldAngles( ent.VehicleData.LocalAngRight )
		
		local Forward = fAng:Forward() 
		local Right = swap_y and -rAng:Forward() or rAng:Forward()
		local Up = ent:GetUp()
		
		local ghostAng = Right:Angle()
		local mirAng = swap_y and 1 or -1
		ghostAng:RotateAroundAxis(Forward,angleoffset.p * mirAng)
		ghostAng:RotateAroundAxis(Right,angleoffset.r * mirAng)
		ghostAng:RotateAroundAxis(Up,-angleoffset.y)
		
		Wheel:SetModel( wm )
		Wheel:SetModelScale(1)
		Wheel:SetAngles( ghostAng )

		local wheelsize = Wheel:OBBMaxs() - Wheel:OBBMins()
		local radius = isfrontwheel and ent.FrontWheelRadius or ent.RearWheelRadius
		local size = (radius * 2) / math.max(wheelsize.x,wheelsize.y,wheelsize.z)
			
		Wheel:SetModelScale( size )
	end
end

--[[]]

local function __apply(ent, t, data)
	if !ent or !t or !data then return end
	
	local bg, sk, c, bp, wh, sh, hb = t[2], t[3], t[4], t[5], t[6], t[7], t[8]
	--PrintTable(t)
	
	if bg and bg ~= 0 and data.bodygroups then
		for _, v in pairs(ent:GetBodyGroups()) do
			local id = v.id
			local b = bg[id]
			if !b then continue end
			ent:SetBodygroup(id, b)
		end
	end

	if sk and sk ~= 0 and data.skins then ent:SetSkin(sk) end

	if c and c ~= 0 and data.colors then 
		ent:SetColor(data.colors[c]) 
		ent:SetNWInt("Color", c)
	end

	if bp and bp ~= 0 and data.booletproof then ent:SetBulletProofTires(data.booletproof[bp]) end

	if hb and hb ~= 0 and data.healthboost then
		local hdata = data.healthboost[hb]
		if hdata then
			ent:SetNWInt("Health", hb)
			ent:SetNWFloat("Health", ent:GetMaxHealth() * hdata.multiplier)
			ent:SetHealth(ent:GetMaxHealth() * data.healthboost[hb].multiplier)
		end
	end

	timer.Simple(0.5, function()
		if !IsValid(ent) then return end

		if wh and wh ~= 0 and data.wheels then
			local w = data.wheels[wh]
			if w then
				ApplyWheel(ent, w.model, w.angle)
				ent:SetNWInt("Wheels", wh)
			end
		end

		if sh and sh ~= 0 and data.suspension then
			local h = data.suspension[sh].var
			if h then
				ent:SetFrontSuspensionHeight(h)
				ent:SetRearSuspensionHeight(h)
				ent:SetNWInt("Suspension", sh)
			end
		end
	end)
end

local function __getprice(ent, t, data)
	local price = 0
	local bg, sk, c, bp, wh, sh, hb = t[2], t[3], t[4], t[5], t[6], t[7], t[8]

	for id, b in pairs(bg) do
		if ent:GetBodygroup(id) ~= b then price = price + 100 end
	end

	if sk and sk ~= 0 and sk ~= ent:GetSkin() then price = price + 100 end
	if c and c ~= 0 and c ~= ent:GetNWInt("Color") and data.colors then price = price + 100 end
	if bp and bp ~= 0 and bp ~= ent:GetBulletProofTires() and data.booletproof then price = price + data.booletproofprice end
	if wh and wh ~= 0 and wh ~= ent:GetNWInt("Wheels") and data.wheels then price = price + 100 end
	if sh and sh ~= 0 and sh ~= ent:GetNWInt("Suspension") and data.suspension then price = price + 100 end
	if hb and hb ~= 0 and hb ~= ent:GetNWInt("Armor") and data.healthboost then price = price + data.healthboost[hb].price end

	return price
end

local function test_pos(pos, ply)
	for _, v in pairs(ents.FindInBox(pos - Vector(100, 100, 100), pos + Vector(100, 100, 100))) do
		if IsValid(v) and (v:IsPlayer() and v ~= ply or v:IsVehicle()) then 
			return false 
		end
	end
	
	return true
end

net.Receive("pimp_my_ride_call",function(l, pl)

	local l = net.ReadUInt(8)
	local data = net.ReadData(l)
	local raw = util.Decompress(data)
	local t = pon.decode(raw)

	local name = t[1]
	local data = PIMP.Get(name)
	local price = data.Price or 0

	if pl:GetMoney() < price then pl:ChatPrint(translates and translates.Get("Недостаточно денег") or "Недостаточно денег") return end

	for _, e in pairs(ents.FindByClass("gmod_sent_vehicle_fphysics_base")) do
		if PIMP.IsCarOwned(e, pl) then
			e:Remove()
		end
	end

	if !data then return end
	local f = data.CanSpawn
	if f and !f(pl) then pl:Kick("А кто у нас такой наглый?") return end
	
	local pos, ang, dir
	local custom_pos = false
	
	if data.CustomPoses and data.CustomPoses[game.GetMap()] then
		for k, v in pairs(data.CustomPoses[game.GetMap()]) do
			if v.pos:DistToSqr(pl:GetPos()) > 250000 then continue end
			if not v.pos or not test_pos(v.pos, pl) then continue end
			
			pos = v.pos
			ang = v.ang
			
			--print("Found good pos!")
			
			break
		end
	end
	
	/*
	if !pos then
		--print("Generate view pos plz")
		
		pos, dir = pl:GetPos() + Vector(0, 0, 50), pl:GetAimVector()
		dir.z = 0
		dir:Normalize()
		pos = util.QuickTrace(pos, -dir * 400, pl).HitPos + dir * 100
	end
	*/
	
	if not pos or not test_pos(pos, pl) then
		--print("Wow, no space!")
		pl:ChatPrint(translates and translates.Get("Нет места для транспорта!") or "Нет места для транспорта!")
		return
	end
	
	pl:AddMoney(-price)
	pl:ChatPrint(translates and translates.Get("Попрощайтесь со своими кровными %i$", price) or ("Попрощайтесь со своими кровными " .. price .. "$"))
	
	--for _, v in pairs(ents.FindInBox(pos - Vector(-100, -100, -100), pos + Vector(100, 100, 100))) do
	--	if !(v:IsPlayer() or v:IsVehicle()) then continue end
	--	local dir = pos - v:GetPos()
	--	pos = pos + dir:GetNormalized() * (200 - dir:GetLength())
	--end

	ent = simfphys.SpawnVehicleSimple(name, pos, ang or angle_zero)
	ent:DoorOwn(pl)

	timer.Simple(0.25, function() __apply(ent, t, data) ent:CPPISetOwner(pl) end)
end)

net.Receive("pimp_my_ride_request",function(l, pl)
	local l = net.ReadUInt(8)
	local data = net.ReadData(l)
	local raw = util.Decompress(data)
	local t = pon.decode(raw)

	local ent = t[1]

	if !IsValid(ent) or !simfphys.IsCar(ent) or !PIMP.IsCarOwned(ent, pl) then return end

	local data = PIMP.GetByEntity(ent)
	local price = __getprice(ent, t, data)

	if pl:GetMoney() < price then pl:ChatPrint(translates and translates.Get("Недостаточно денег") or "Недостаточно денег") return end
	pl:AddMoney(-price)
	pl:ChatPrint(translates and translates.Get("Попрощайтесь со своими кровными %i$", price) or ("Попрощайтесь со своими кровными " .. price .. "$"))
	__apply(ent, t, data)
end)

local function __catch()
	if !simfphys then timer.Simple(0.1, __catch) return end

	function simfphys.SpawnVehicle( Player, Pos, Ang, Model, Class, VName, VTable, bNoOwner )
			
		if not bNoOwner then
			if not gamemode.Call( "PlayerSpawnVehicle", Player, Model, VName, VTable ) then return end
		end

		if not file.Exists( Model, "GAME" ) then 
			Player:PrintMessage( HUD_PRINTTALK, "ERROR: \""..Model.."\" does not exist! (Class: "..VName..")")
			return
		end
		
		local Ent = ents.Create( "gmod_sent_vehicle_fphysics_base" )
		if not Ent then return NULL end
		
		Ent:SetModel( Model )
		Ent:SetAngles( Ang )
		Ent:SetPos( Pos )
		Ent.WeaponsIsNotAllowed = true

		Ent:Spawn()
		Ent:Activate()

		Ent.VehicleName = VName
		Ent:SetNWString("VehicleName", VName)
		Ent.VehicleTable = VTable
		Ent.EntityOwner = Player
		Ent:SetSpawn_List( VName )
		
		if VTable.Members then
			table.Merge( Ent, VTable.Members )
			
			if Ent.ModelInfo then
				if Ent.ModelInfo.Color then
					Ent:SetColor( Ent.ModelInfo.Color )
					
					local Color = Ent.ModelInfo.Color
					local dot = Color.r * Color.g * Color.b * Color.a
					Ent.OldColor = dot
					
					local data = {
						Color = Color,
						RenderMode = 0,
						RenderFX = 0
					}
					duplicator.StoreEntityModifier( Ent, "colour", data )
				end
			end
			
			Ent:SetTireSmokeColor(Vector(180,180,180) / 255)
			
			Ent.Turbocharged = Ent.Turbocharged or false
			Ent.Supercharged = Ent.Supercharged or false
			
			Ent:SetEngineSoundPreset( Ent.EngineSoundPreset )
			Ent:SetMaxTorque( Ent.PeakTorque )

			Ent:SetDifferentialGear( Ent.DifferentialGear )
			
			Ent:SetSteerSpeed( Ent.TurnSpeed )
			Ent:SetFastSteerConeFadeSpeed( Ent.SteeringFadeFastSpeed )
			Ent:SetFastSteerAngle( Ent.FastSteeringAngle )
			
			Ent:SetEfficiency( Ent.Efficiency )
			Ent:SetMaxTraction( Ent.MaxGrip )
			Ent:SetTractionBias( Ent.GripOffset / Ent.MaxGrip )
			Ent:SetPowerDistribution( Ent.PowerBias )
			
			Ent:SetBackFire( Ent.Backfire or false )
			Ent:SetDoNotStall( Ent.DoNotStall or false )
			
			Ent:SetIdleRPM( Ent.IdleRPM )
			Ent:SetLimitRPM( Ent.LimitRPM )
			Ent:SetRevlimiter( Ent.Revlimiter or false )
			Ent:SetPowerBandEnd( Ent.PowerbandEnd )
			Ent:SetPowerBandStart( Ent.PowerbandStart )
			
			Ent:SetTurboCharged( Ent.Turbocharged )
			Ent:SetSuperCharged( Ent.Supercharged )
			Ent:SetBrakePower( Ent.BrakePower )
			
			Ent:SetLights_List( Ent.LightsTable or "no_lights" )
			
			Ent:SetBulletProofTires( Ent.BulletProofTires or false )
			
			Ent:SetBackfireSound( Ent.snd_backfire or "" )
			
			if simfphys.armedAutoRegister then
				timer.Simple( 0.2, function()
					simfphys.armedAutoRegister( Ent )
				end)
			end
			
			duplicator.StoreEntityModifier( Ent, "VehicleMemDupe", VTable.Members )
		end
		
		if IsValid( Player ) then
			gamemode.Call( "PlayerSpawnedVehicle", Player, Ent )
			
			return Ent
		end
		
		return Ent
	end
end

__catch()