----------------------------------------------------------------
--~~DON'T REDISTRIBUTE THIS CODE WITHOUT AUTHOR'S PERMISSION~~--
----------------------------------------------------------------

util.PrecacheModel("models/weapons/w_irifle_magazine.mdl")
util.PrecacheModel("models/weapons/w_pistol_magazine.mdl")
util.PrecacheModel("models/weapons/w_smg1_magazine.mdl")
util.PrecacheSound("sound/weapons/lowammo_01.wav")

--------------------------------
--Dynamic Clientside Magazines--
--------------------------------

if CLIENT and game.SinglePlayer() then
	CreateClientConVar("mmod_mags", 1, true, false)

		hook.Add("Think", "MMOD_Mags", function()
			local ply = LocalPlayer()
			if !ply:Alive() then return end

			local wep = ply:GetActiveWeapon()
			if !IsValid(wep) then return end

			local vm = ply:GetViewModel()
			if !IsValid(vm) then return end

			local bool = ply:ShouldDrawLocalPlayer()
			bool = !bool

			local seq = vm:GetSequence()
			local seqinfo = vm:GetSequenceInfo(seq)

			if not seqinfo then return end

			local seqName = seqinfo.label
			local cyc = vm:GetCycle()

			if GetConVar("mmod_mags"):GetInt() > 0 then
				if wep:GetClass() == "weapon_ar2" and (string.find(seqName, "reload") and cyc < 0.005) then
					if (!wep.MMOD_Reload) or (wep.MMOD_Reload and CurTime() > wep.MMOD_Reload) then
						if bool then

						local ent = ply:GetShootPos()

						local pos = ent
						pos = pos + ply:GetForward() * 5
						pos = pos + ply:GetRight() * 20
						pos = pos + ply:GetUp() * -25

						local prop = ents.CreateClientProp()
						prop:SetModel("models/weapons/w_irifle_magazine.mdl")
						prop:SetPos(pos)
						prop:SetAngles(prop:GetAngles())
						prop:Spawn()
						prop:Activate()
						prop:PhysicsInit(SOLID_VPHYSICS)
						prop:SetSolid(SOLID_VPHYSICS)

						local phys = prop:GetPhysicsObject()
						if IsValid(phys) and IsValid(prop) then
						phys:Wake()
						prop:SetMoveType(MOVETYPE_VPHYSICS)
						prop:SetRenderMode(RENDERMODE_TRANSALPHA)
						prop:SetColor(Color(255,255,255,255))
						
						wep.MMOD_Reload = CurTime() + 2.35

						timer.Simple(60,function() if IsValid(prop) then prop:Remove() end end)

						else
						return false
						end

						end
					end
				end

				if wep:GetClass() == "weapon_pistol" and (string.find(seqName, "reload") and cyc < 0.005) then
					if (!wep.MMOD_Reload) or (wep.MMOD_Reload and CurTime() > wep.MMOD_Reload) then
						if bool then

						local ent = ply:GetShootPos()

						local pos = ent
						pos = pos + ply:GetForward() * 5
						pos = pos + ply:GetRight() * 5
						pos = pos + ply:GetUp() * -25

						local prop = ents.CreateClientProp()
						prop:SetModel("models/weapons/w_pistol_magazine.mdl")
						prop:SetPos(pos)
						prop:SetAngles(prop:GetAngles())
						prop:Spawn()
						prop:Activate()
						prop:PhysicsInit(SOLID_VPHYSICS)
						prop:SetSolid(SOLID_VPHYSICS)

						local phys = prop:GetPhysicsObject()
						if IsValid(phys) and IsValid(prop) then
						phys:Wake()
						prop:SetMoveType(MOVETYPE_VPHYSICS)
						prop:SetRenderMode(RENDERMODE_TRANSALPHA)
						prop:SetColor(Color(255,255,255,255))
						
						wep.MMOD_Reload = CurTime() + 1.80

						timer.Simple(60,function() if IsValid(prop) then prop:Remove() end end)

						else
						return false
						end

						end
					end
				end

				if wep:GetClass() == "weapon_smg1" and (string.find(seqName, "reload") and cyc < 0.005) then
					if (!wep.MMOD_Reload) or (wep.MMOD_Reload and CurTime() > wep.MMOD_Reload) then
						if bool then

						local ent = ply:GetShootPos()

						local pos = ent
						pos = pos + ply:GetForward() * 15
						pos = pos + ply:GetRight() * 15
						pos = pos + ply:GetUp() * -30

						local prop = ents.CreateClientProp()
						prop:SetModel("models/weapons/w_smg1_magazine.mdl")
						prop:SetPos(pos)
						prop:SetAngles(prop:GetAngles())
						prop:Spawn()
						prop:Activate()
						prop:PhysicsInit(SOLID_VPHYSICS)
						prop:SetSolid(SOLID_VPHYSICS)

						local phys = prop:GetPhysicsObject()
						if IsValid(phys) and IsValid(prop) then
						phys:Wake()
						prop:SetMoveType(MOVETYPE_VPHYSICS)
						prop:SetRenderMode(RENDERMODE_TRANSALPHA)
						prop:SetColor(Color(255,255,255,255))
						
						wep.MMOD_Reload = CurTime() + 2.35

						timer.Simple(60,function() if IsValid(prop) then prop:Remove() end end)

						else
						return false
						end
					end
				end
			end
		end
	end)
end

-----------------------------
--Thrown Grenade Worldmodel--
-----------------------------

local last_think = 0
hook.Add("Think","MMOD_ReplaceGrenade",function()
	if last_think < CurTime() then
		last_think = CurTime() + 0.5
		for k, v in pairs(ents.FindByClass("npc_grenade_frag")) do
			if IsValid(v) then

			local attachment = v:LookupAttachment( "fuse" )
			local model = ("models/weapons/w_grenade_thrown.mdl")

			v:SetModel(model)
			v:Activate()

			end
		end
	end
end)

------------------------
--Muzzleflash Lighting--
------------------------

function GetAmmoForCurrentWeapon(ply)
	for k, v in pairs(player.GetAll()) do
		if IsValid(v) and IsValid(v:GetActiveWeapon()) then

		local wep = v:GetActiveWeapon()

		return v:GetAmmoCount( wep:GetPrimaryAmmoType() )

		end
	end
end

if CLIENT and game.SinglePlayer() then
	hook.Add("Think","MMOD_MuzzleflashLighting",function()
		CreateConVar("mmod_muzzlelight", 1, true, false)
		CreateClientConVar("mmod_lowammo", 1, true, false)

		if GetConVar("mmod_muzzlelight"):GetInt() > 0 then
			for k, v in pairs(player.GetAll()) do
				if IsValid(v) and IsValid(v:GetViewModel()) and IsValid(v:GetActiveWeapon()) then
					local vm = v:GetViewModel()

					local seq = vm:GetSequence()
					local seqinfo = vm:GetSequenceInfo(seq)

					if not seqinfo then return end

					local seqName = seqinfo.label
					local cyc = vm:GetCycle()

					local bool = v:ShouldDrawLocalPlayer()
					bool = !bool

					local wep = v:GetActiveWeapon()
					local click = ("weapons/lowammo_01.wav")

					if v:GetActiveWeapon():Clip1() == 0 and GetAmmoForCurrentWeapon == 0 then return end

					if (v:GetActiveWeapon():GetClass() == "weapon_pistol") then
						if seqinfo.activityname == "ACT_VM_DRYFIRE" then return end
							if (string.find(seqName, "fire") and cyc < 0.005) or (seqinfo.activityname == "ACT_VM_SHOOTLAST" and cyc < 0.005) then

							local ent = v:GetShootPos()

							local pos = ent
							pos = pos + v:GetForward() * 41
							pos = pos + v:GetRight() * 4
							pos = pos + v:GetUp() * -5

							local dlight = CLIENT and DynamicLight( v:EntIndex() )
							if ( dlight ) then

							dlight.Pos = pos
							dlight.r = 255
							dlight.g = 140
							dlight.b = 0
							dlight.brightness = 2
							dlight.Decay = 256
							dlight.Size = 256
							dlight.DieTime = CurTime() + 0.05
							dlight.Style = 12

							if GetConVar("mmod_lowammo"):GetInt() > 0 then
								if (!wep.MMOD_Tick) or (wep.MMOD_Tick and CurTime() > wep.MMOD_Tick) then
									if wep:Clip1() < 6 then
										if (string.find(seqName, "fire") and cyc < 0.005) or (seqinfo.activityname == "ACT_VM_SHOOTLAST" and cyc < 0.005) then
											if bool then

											local dur = vm:SequenceDuration(seqinfo)
											v:EmitSound(click)
											wep.MMOD_Tick = CurTime() + 0.05
											
											return true

											else
											return false
											end

											end
										end
									end
								end
							end
						end
					end

					if (v:GetActiveWeapon():GetClass() == "weapon_smg1") then
						if (string.find(seqName, "fire") and cyc < 0.003) or (string.find(seqName, "alt") and cyc < 0.005) then

							local ent = v:GetShootPos()

							local pos = ent
							pos = pos + v:GetForward() * 42
							pos = pos + v:GetRight() * 4
							pos = pos + v:GetUp() * -5

							local dlight = CLIENT and DynamicLight( v:EntIndex() )
							if ( dlight ) then
							
							dlight.Pos = pos
							dlight.r = 255
							dlight.g = 140
							dlight.b = 0
							dlight.brightness = 2
							dlight.Decay = 256
							dlight.Size = 256
							dlight.DieTime = CurTime() + 0.045
							dlight.Style = 13

							if GetConVar("mmod_lowammo"):GetInt() > 0 then
								if (!wep.MMOD_Tick) or (wep.MMOD_Tick and CurTime() > wep.MMOD_Tick) then
									if wep:Clip1() < 10 then
										if (string.find(seqName, "fire") and cyc < 0.001) then
											if bool then

											local dur = vm:SequenceDuration(seqinfo)
											v:EmitSound(click)
											wep.MMOD_Tick = CurTime() + 0.05

											return true

											else
											return false
											end

											end
										end
									end
								end
							end
						end
					end

					if (v:GetActiveWeapon():GetClass() == "weapon_357") then
						if (string.find(seqName, "fire") and cyc < 0.005) then

							local ent = v:GetShootPos()

							local pos = ent
							pos = pos + v:GetForward() * 42
							pos = pos + v:GetRight() * 1
							pos = pos + v:GetUp() * -5

							local dlight = CLIENT and DynamicLight( v:EntIndex() )
							if ( dlight ) then

							dlight.Pos = pos
							dlight.r = 255
							dlight.g = 140
							dlight.b = 0
							dlight.brightness = 2.50
							dlight.Decay = 256
							dlight.Size = 256
							dlight.DieTime = CurTime() + 0.05
							dlight.Style = 13
							
							if GetConVar("mmod_lowammo"):GetInt() > 0 then
								if (!wep.MMOD_Tick) or (wep.MMOD_Tick and CurTime() > wep.MMOD_Tick) then
									if wep:Clip1() < 3 then
										if (string.find(seqName, "fire") and cyc < 0.001) then
											if bool then

											local dur = vm:SequenceDuration(seqinfo)
											v:EmitSound(click)
											wep.MMOD_Tick = CurTime() + 0.125

											return true

											else
											return false
											end

											end
										end
									end
								end
							end
						end
					end

					if (v:GetActiveWeapon():GetClass() == "weapon_shotgun") then
						if (string.find(seqName, "fire") and cyc < 0.005) then

							local ent = v:GetShootPos()

							local pos = ent
							pos = pos + v:GetForward() * 35
							pos = pos + v:GetRight() * 1
							pos = pos + v:GetUp() * -5

							local dlight = CLIENT and DynamicLight( v:EntIndex() )
							if ( dlight ) then

							dlight.Pos = pos
							dlight.r = 255
							dlight.g = 140
							dlight.b = 0
							dlight.brightness = 2.5
							dlight.Decay = 256
							dlight.Size = 256
							dlight.DieTime = CurTime() + 0.04
							dlight.Style = 13
							
							if GetConVar("mmod_lowammo"):GetInt() > 0 then
								if (!wep.MMOD_Tick) or (wep.MMOD_Tick and CurTime() > wep.MMOD_Tick) then
									if wep:Clip1() < 3 then
										if (string.find(seqName, "fire") and cyc < 0.001) then
											if bool then

											local dur = vm:SequenceDuration(seqinfo)
											v:EmitSound(click)
											wep.MMOD_Tick = CurTime() + 0.125

											return true

											else
											return false
											end

											end
										end
									end
								end
							end
						end
					end

					if (v:GetActiveWeapon():GetClass() == "weapon_ar2") then
						if (string.find(seqName, "fire") and cyc < 0.005) or (string.find(seqName, "alt") and cyc < 0.005) then

							local ent = v:GetShootPos()

							local pos = ent
							pos = pos + v:GetForward() * 10
							pos = pos + v:GetRight() * 10
							pos = pos + v:GetUp() * -30

							local dlight = CLIENT and DynamicLight( v:EntIndex() )
							if ( dlight ) then

							dlight.Pos = pos
							dlight.r = 102
							dlight.g = 255
							dlight.b = 180
							dlight.brightness = 3
							dlight.Decay = 256
							dlight.Size = 256
							dlight.DieTime = CurTime() + 0.09
							dlight.Style = 13

							if GetConVar("mmod_lowammo"):GetInt() > 0 then
								if (!wep.MMOD_Tick) or (wep.MMOD_Tick and CurTime() > wep.MMOD_Tick) then
									if wep:Clip1() < 10 then
										if (string.find(seqName, "fire") and cyc < 0.001) then
											if bool then

											local dur = vm:SequenceDuration(seqinfo)
											v:EmitSound(click)
											wep.MMOD_Tick = CurTime() + 0.050

											return true

											else
											return false
											end

											end
										end
									end
								end
							end
						end
					end

					if (v:GetActiveWeapon():GetClass() == "weapon_stunstick") then
						if (seqinfo.activityname == "ACT_VM_MISSCENTER" and cyc > 0.2 and cyc < 0.5) or (seqinfo.activityname == "ACT_VM_HITCENTER" and cyc > 0.2 and cyc < 0.4) then

							local ent = v:GetShootPos()

							local pos = ent
							pos = pos + v:GetForward() * 10
							pos = pos + v:GetRight() * 10
							pos = pos + v:GetUp() * -30

							local dlight = CLIENT and DynamicLight( v:EntIndex() )
							if ( dlight ) then

							dlight.Pos = pos
							dlight.r = 255
							dlight.g = 255
							dlight.b = 255
							dlight.brightness = 3
							dlight.Decay = 256
							dlight.Size = 256
							dlight.DieTime = CurTime() + 0.5
							dlight.Style = 13

							end
						end
					end
				end
			end
		end
	end)
end

-------------------------------
--Stunstick Underwater Damage--
-------------------------------
	
if SERVER then
	local randomsounds = {
		"/ambient/energy/zap1.wav",
		"/ambient/energy/zap2.wav",
		"/ambient/energy/zap3.wav"
	}
	
	local wep, vm, seq, seq_info
	
	local string_assoc = {
		['ACT_VM_MISSCENTER'] = 1,
		['ACT_VM_HITCENTER'] = 1,
		['weapon_stunstick'] = 2,
	}
	
	hook.Add("PlayerPostThink", "MMOD_StunstickWater_SP", function(ply, pos, sound, volume)
	if !ply:Alive() then return end

	if ply.MMOD_last_check5 and ply.MMOD_last_check5 > CurTime() then return end
	ply.MMOD_last_check5 = CurTime() + 0.1
	
	wep = ply:GetActiveWeapon()
	if !IsValid(wep) then return end

	vm = ply:GetViewModel()
	if !IsValid(vm) then return end

	seq = vm:GetSequence()
	seqinfo = vm:GetSequenceInfo(seq)

	if not seqinfo then return end
	
	if string_assoc[seqinfo.activityname] == 1 then
		if (!wep.MMOD_Stunstick) or (wep.MMOD_Stunstick and CurTime() > wep.MMOD_Stunstick) then
			if string_assoc[wep:GetClass()] == 2 and ply:WaterLevel() > 2 then
			
				ply:TakeDamage(40, ply, ply)
				ply:EmitSound(randomsounds[math.floor(math.random(3))])

				wep.MMOD_Stunstick = CurTime() + vm:SequenceDuration(seqinfo)

				return true

				end
			end
		end
	end)
end

--------------------------------------
--Pulse Rifle Animations Multiplayer--
--------------------------------------

if SERVER then
	local str_comparsing = {
		['weapon_ar2'] = 0,
		
		['ACT_VM_IDLE'] = 1,
		['ACT_VM_DRAW'] = 2,
		['ACT_VM_PRIMARYATTACK'] = 3,
		['ACT_VM_RECOIL1'] = 3,
		['ACT_VM_RECOIL2'] = 3,
		['ACT_VM_RECOIL3'] = 3,
		['fire_midempty'] = 3,
		['ACT_VM_RELOAD'] = 4,
		['ACT_VM_FIDGET'] = 5,
		['ACT_VM_SECONDARYATTACK'] = 6,
	}
	
	local secs_assocs = {
		[1] = { 'idle_midempty', 'idle_empty' },
		[2] = { 'draw_midempty', 'draw_empty' },
		[3] = { 'fire_midempty', 'fire_last_ironsight' },
		[4] = { 'reload_midempty', 'reloadempty' },
		[5] = { 'shake_midempty', 'shake_empty' },
		[6] = { 'fire_altmidempty', 'fire_altempty' },
	}
	
	local wep, vm, seq, seqinfo, clip, seqToPlay, assoced
	local string_lower = string.lower
	
	hook.Add("PlayerPostThink", "MMOD_PulseRifleIdleMidEmpty_MP", function(ply)
		if !ply:Alive() then return end

		if ply.MMOD_last_check7 and ply.MMOD_last_check7 > CurTime() then return end
		ply.MMOD_last_check7 = CurTime() + 0.1
		
		wep = ply:GetActiveWeapon()
		if !IsValid(wep) then return end

		vm = ply:GetViewModel()
		if !IsValid(vm) then return end

		seq = vm:GetSequence()
		seqinfo = vm:GetSequenceInfo(seq)

		if not seqinfo then return end

		clip = wep:Clip1()
		
		if str_comparsing[wep:GetClass()] == 0 then
			assoced = str_comparsing[seqinfo.activityname]
			
			if assoced == 1 or assoced == 2 or assoced == 3 then
				if clip == 1 then
					seqToPlay = vm:LookupSequence(secs_assocs[assoced][1])
					
					if seqToPlay then
						vm:SendViewModelMatchingSequence(seqToPlay)
					end
					
				elseif clip == 0 then
					seqToPlay = vm:LookupSequence(secs_assocs[assoced][2])
					
					if seqToPlay then
						vm:SendViewModelMatchingSequence(seqToPlay)
					end
				end
			end
			
		elseif str_comparsing[seqinfo.activityname] ~= 3 and str_comparsing[string_lower(seqinfo.label)] == 3 then
			if clip == 0 then
				seqToPlay = vm:LookupSequence("fire_last_ironsight")
				
				if seqToPlay then
					vm:SendViewModelMatchingSequence(seqToPlay)
				end
			end
		end
	end)

	local assoc_strings = {
		['weapon_ar2'] = 1,
		['ACT_VM_RELOADEMPTY'] = 2,
	}
	
	hook.Add("PlayerPostThink", "MMOD_PulseRifleReloadEmptyReserve_MP", function(ply)
		if !ply:Alive() then return end

		if ply.MMOD_last_check3 and ply.MMOD_last_check3 > CurTime() then return end
		ply.MMOD_last_check3 = CurTime() + 0.1
		
		wep = ply:GetActiveWeapon()
		if !IsValid(wep) or assoc_strings[wep:GetClass()] ~= 1 then return end

		vm = ply:GetViewModel()
		if !IsValid(vm) then return end

		seq = vm:GetSequence()
		seqinfo = vm:GetSequenceInfo(seq)

		if not seqinfo then return end

		if assoc_strings[seqinfo.activityname] == 2 then
			if wep:Clip1() < 1 and (ply:GetAmmoCount( "AR2" )) == 1 then
			seqToPlay = vm:LookupSequence("reloadempty_reserve")
				if seqToPlay then

				vm:SendViewModelMatchingSequence(seqToPlay)

				end
			end
		end
	end)
end

---------------------------
--Crossbow Zoom Animation--
---------------------------

if game.SinglePlayer() and CLIENT then
	hook.Add("Think", "MMOD_CrossbowReloadZoom_SP", function()
		local ply = LocalPlayer()
		if !ply:Alive() then return end

		local wep = ply:GetActiveWeapon()
		if !IsValid(wep) then return end

		local vm = ply:GetViewModel()
		if !IsValid(vm) then return end

		local seq = vm:GetSequence()
		local seqinfo = vm:GetSequenceInfo(seq)

		if not seqinfo then return end
		
		local cyc = vm:GetCycle()

		if wep:GetClass() == "weapon_crossbow" then
			if ply:GetFOV() < 25 and seqinfo.activityname == "ACT_VM_RELOAD" and cyc < 0.005 then 
			local seqToPlay = vm:LookupSequence("reload_zoomed")
				if seqToPlay then

				vm:SendViewModelMatchingSequence(seqToPlay)

				end
			end
		end
	end)
end

if !game.SinglePlayer() and SERVER then
	local wep, vm, seq, seqinfo, cyc, seqToPlay
	
	local assoc_str = { 
		weapon_crossbow = true,
		ACT_VM_RELOAD = true,
	}
	
	hook.Add("PlayerPostThink", "MMOD_CrossbowReloadZoom_MP", function(ply)
		if !ply:Alive() then return end

		if ply.MMOD_last_check9 and ply.MMOD_last_check9 > CurTime() then return end
		ply.MMOD_last_check9 = CurTime() + 0.1
		
		wep = ply:GetActiveWeapon()
		if !IsValid(wep) or not assoc_str[wep:GetClass()] then return end

		vm = ply:GetViewModel()
		if !IsValid(vm) then return end

		seq = vm:GetSequence()
		seqinfo = vm:GetSequenceInfo(seq)

		if not seqinfo then return end
		
		cyc = vm:GetCycle()

			if ply:GetFOV() < 25 and assoc_str[seqinfo.activityname] and cyc < 0.005 then 
			seqToPlay = vm:LookupSequence("reload_zoomed")
				if seqToPlay then

				vm:SendViewModelMatchingSequence(seqToPlay)

				end
			end
	end)
end

-----------------------------
--Shotgun Altfire Animation--
-----------------------------

if game.SinglePlayer() and CLIENT then
	hook.Add("Think", "MMOD_ShotgunAltFire_SP", function()
		local ply = LocalPlayer()
		if !ply:Alive() then return end

		local wep = ply:GetActiveWeapon()
		if !IsValid(wep) then return end

		local class = wep:GetClass()
		if class != "weapon_shotgun" then return end

		local vm = ply:GetViewModel()
		if !IsValid(vm) then return end

		local seq = vm:GetSequence()
		local seqinfo = vm:GetSequenceInfo(seq)

		if not seqinfo then return end

		if wep:GetClass() == "weapon_shotgun" and seqinfo.activityname == "ACT_VM_SECONDARYATTACK" then
			wep.MMOD_ShotgunNormalShot = true
		end

	if wep.MMOD_ShotgunNormalShot and seqinfo.activityname == "ACT_VM_PRIMARYATTACK" then
		local seqToPlay = vm:LookupSequence("pump")
			if seqToPlay then

			vm:SendViewModelMatchingSequence(seqToPlay)
			wep.MMOD_ShotgunNormalShot = false

		end
	elseif wep.MMOD_ShotgunNormalShot and string.lower(seqinfo.label) == "pump" then
		local seqToPlay = vm:LookupSequence("pump2_sighted")
			if seqToPlay then

			vm:SendViewModelMatchingSequence(seqToPlay)
			wep.MMOD_ShotgunNormalShot = false

			end
		end
	end)
end

if !game.SinglePlayer() and SERVER then
	local wep, vm, seq, seqinfo, seqToPlay, cyc
	
	local string_lower = string.lower
	
	local strs_assoc = {
		weapon_shotgun = true,
		ACT_VM_SECONDARYATTACK = 1,
		ACT_VM_PRIMARYATTACK = 2,
		pump = true,
	}
	
	hook.Add("PlayerPostThink", "MMOD_ShotgunAltFire_MP", function(ply)
		if !ply:Alive() then return end

		if ply.MMOD_last_check10 and ply.MMOD_last_check10 > CurTime() then return end
		ply.MMOD_last_check10 = CurTime() + 0.1
		
		wep = ply:GetActiveWeapon()
		if !IsValid(wep) then return end

		if not strs_assoc[wep:GetClass()] then return end

		vm = ply:GetViewModel()
		if !IsValid(vm) then return end

		seq = vm:GetSequence()
		seqinfo = vm:GetSequenceInfo(seq)

		if not seqinfo then return end
		
		cyc = vm:GetCycle()

		if strs_assoc[seqinfo.activityname] == 1 then
			wep.MMOD_ShotgunNormalShot = true
		end

	if wep.MMOD_ShotgunNormalShot and strs_assoc[seqinfo.activityname] == 2 then
		seqToPlay = vm:LookupSequence("pump")
			if seqToPlay then

			vm:SendViewModelMatchingSequence(seqToPlay)
			wep.MMOD_ShotgunNormalShot = false

		end
	elseif wep.MMOD_ShotgunNormalShot and strs_assoc[string_lower(seqinfo.label)] then
		seqToPlay = vm:LookupSequence("pump2_sighted")
			if seqToPlay then

			vm:SendViewModelMatchingSequence(seqToPlay)
			wep.MMOD_ShotgunNormalShot = false

			end
		end
	end)
end

------------------------------
--Pistol Last Shot Animation--
------------------------------

if game.SinglePlayer() and CLIENT then
	hook.Add("Think", "MMOD_PistolFireLast_SP", function()
		local ply = LocalPlayer()
		if !ply:Alive() then return end

		local wep = ply:GetActiveWeapon()
		if !IsValid(wep) then return end
		
		local class = wep:GetClass()
		if class != "weapon_pistol" then return end

		local vm = ply:GetViewModel()
		if !IsValid(vm) then return end

		local seq = vm:GetSequence()
		local seqinfo = vm:GetSequenceInfo(seq)

		if not seqinfo then return end

		if class == "weapon_pistol" and seqinfo.activityname == "ACT_VM_RECOIL2" or seqinfo.activityname == "ACT_VM_RECOIL3" then
			if wep:Clip1() == 1 then
			local seqToPlay = vm:LookupSequence("fire3_is")
				if seqToPlay then

				vm:SendViewModelMatchingSequence(seqToPlay)

				end
			end
		elseif string.lower(seqinfo.label) == "fire3_is" then
			if wep:Clip1() == 0 then
			local seqToPlay = vm:LookupSequence("shoot_last")
				if seqToPlay then

				vm:SendViewModelMatchingSequence(seqToPlay)

				end
			end
		end
	end)
end


if !game.SinglePlayer() and SERVER then
	local wep, vm, seq, seqinfo, seqToPlay
	
	local string_lower = string.lower
	
	local strs_assoc = {
		weapon_pistol = true,
		ACT_VM_RECOIL2 = true,
		ACT_VM_RECOIL3 = true,
		fire3_is = true,
	}
	
	hook.Add("PlayerPostThink", "MMOD_PistolFireLast_MP", function(ply)
		if !ply:Alive() then return end

		if ply.MMOD_last_check11 and ply.MMOD_last_check11 > CurTime() then return end
		ply.MMOD_last_check11 = CurTime() + 0.1
		
		wep = ply:GetActiveWeapon()
		if !IsValid(wep) then return end
		
		if not strs_assoc[wep:GetClass()] then return end

		vm = ply:GetViewModel()
		if !IsValid(vm) then return end

		seq = vm:GetSequence()
		seqinfo = vm:GetSequenceInfo(seq)

		if not seqinfo then return end

		if strs_assoc[seqinfo.activityname] then
			if wep:Clip1() == 1 then
			seqToPlay = vm:LookupSequence("fire3_is")
				if seqToPlay then

				vm:SendViewModelMatchingSequence(seqToPlay)

				end
			end
		elseif strs_assoc[string_lower(seqinfo.label)] then
			if wep:Clip1() == 0 then
			seqToPlay = vm:LookupSequence("shoot_last")
				if seqToPlay then

				vm:SendViewModelMatchingSequence(seqToPlay)

				end
			end
		end
	end)
end