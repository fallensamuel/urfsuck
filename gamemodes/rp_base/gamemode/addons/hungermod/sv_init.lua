local CurTime = CurTime
local math_abs = math.abs
local math_clamp = math.Clamp
local math_max = math.max
local timer_Simple = timer.Simple
local IsValid = IsValid

local player_moans = {}

if not rp.cfg.DisableHunger then
	local CooldownHungerUPD = {}

	local MoansSounds = {}

	for i = 1, 5 do
		MoansSounds[i] = Sound("vo/npc/male01/moan0"..i..".wav")
	end

	hook.Add("PlayerPostThink", "HungerUpdate", function(ply)
		if not ply:Alive() or ply:GetHunger() > 0 or ply:GetJobTable().noHunger then 
			if ply.hungered then
				hook.Run("PlayerHungerEnded", ply)
				ply.hungered = nil
			end
			
			return 
		end
		
		if CooldownHungerUPD[ply] then return end
		CooldownHungerUPD[ply] = true
		timer_Simple(5, function()
			if IsValid(ply) then CooldownHungerUPD[ply] = nil end
		end)

		local shouldHunger = ply:GetJobTable().patient or hook.Run("PlayerHasHunger", ply)

		if shouldHunger ~= false and not ply.hungered then
			ply.hungered = true
			hook.Run("PlayerHungerStarted", ply)
		end
		
		if not hook.Run("PlayerCustomHunger", ply) then
			if shouldHunger && ply:Health() > 30 then
					ply:SetHealth(ply:Health() - 7.5)
						
				if not player_moans[ply:SteamID()] then
					ply:EmitSound(MoansSounds[math.random(1, 5)], SNDLVL_30dB)
					player_moans[ply:SteamID()] = true
				else
					player_moans[ply:SteamID()] = nil
				end
			end
		end
	end)
--[[
	timer.Create("HungerUpdate", 5, 0, function()
		for k, v in ipairs(player.GetAll()) do
			if IsValid(v) and v:Alive() and (v:GetHunger() <= 0) and not v:GetJobTable().noHunger then
				local shouldHunger = hook.Call("PlayerHasHunger", nil, v)

				if (shouldHunger == nil) then
					shouldHunger = true
				end

				if (shouldHunger) && v:Health() > 30 then
					v:SetHealth(v:Health() - 7.5)
					
					if not player_moans[v:SteamID()] then
						v:EmitSound(Sound("vo/npc/male01/moan0" .. math.random(1, 5) .. ".wav"), SNDLVL_30dB)
						player_moans[v:SteamID()] = true
					else
						player_moans[v:SteamID()] = nil
					end
				end
			end
		end
	end)
]]--
end

hook("PlayerDisconnected", function(pl)
	player_moans[pl:SteamID()] = nil
end)

hook("PlayerSpawn", function(pl)
	player_moans[pl:SteamID()] = nil
	if pl:GetNetVar('Energy') then
		pl:SetNetVar("Energy", CurTime() + pl:GetHungerRate())
	end
end)

hook("PlayerEntityCreated", function(pl)
	pl:SetNetVar("Energy", CurTime() + pl:GetHungerRate())
	pl:SetHungerRateMultiplier(pl:GetNetVar('EnergyRate'))
end)

function PLAYER:SetHungerRateMultiplier(rate)
	local old_hunger = self:GetHunger() or 100
	self:SetNetVar('EnergyRate', rate or 1)
	self:SetHunger(old_hunger)
end

function PLAYER:SetHunger(amount, noclamp)
	if noclamp then
		amount = math_max(0, (amount / 100 * self:GetHungerRate()))
	else
		amount = math_clamp((amount / 100 * self:GetHungerRate()), 0, self:GetHungerRate())
	end

	self:SetNetVar('Energy', CurTime() + amount)
end

function PLAYER:AddHunger(amount)
	if rp.cfg.DisableHunger then return end
	self:SetHunger(self:GetHunger() + amount * self:GetHungerRateMultiplier())
end

function PLAYER:TakeHunger(amount)
	if rp.cfg.DisableHunger then return end
	self:AddHunger(-math_abs(amount))
end

local function BuyFood(pl, args)
	if args == "" then return "" end
	if not rp.Foods[args] then return "" end

	if pl:GetCount('Food') >= 15 then
		pl:Notify(NOTIFY_ERROR, rp.Term('FoodLimitReached'))

		return
	end

	local trace = {}
	trace.start = pl:EyePos()
	trace.endpos = trace.start + pl:GetAimVector() * 85
	trace.filter = pl
	local tr = util.TraceLine(trace)


	if not rp.Foods[args] then return end
	local cost = rp.Foods[args].price

	if !rp.Foods[args].allowed[pl:Team()] then
		pl:Notify(NOTIFY_ERROR, rp.Term('ThereIsACook'))

		return ""
	end

	if pl:CanAfford(cost) then
		pl:AddMoney(-cost)
	else
		pl:Notify(NOTIFY_ERROR, rp.Term('CannotAfford'))

		return ""
	end

	rp.Notify(pl, NOTIFY_GREEN, rp.Term('RPItemBought'), args, rp.FormatMoney(cost))
	local SpawnedFood = ents.Create("spawned_food")
	SpawnedFood:SetPos(tr.HitPos)
	SpawnedFood:SetModel(rp.Foods[args].model)
	SpawnedFood.ItemOwner = pl
	SpawnedFood:Spawn()
	SpawnedFood.FoodEnergy = rp.Foods[args].amount
	pl:_AddCount('Food', SpawnedFood)

	return ""
end

rp.AddCommand("/buyfood", BuyFood)

function rp.SpawnFood(owner, food, pos, ang)
	local SpawnedFood = ents.Create("spawned_food")
	SpawnedFood:SetPos(pos)
	if ang then
		SpawnedFood:SetAngles(ang)
	end
	SpawnedFood:SetModel(rp.Foods[food].model)
	SpawnedFood.ItemOwner = owner
	SpawnedFood:Spawn()
	SpawnedFood.FoodEnergy = rp.Foods[food].amount
	owner:_AddCount('Food', SpawnedFood)

end