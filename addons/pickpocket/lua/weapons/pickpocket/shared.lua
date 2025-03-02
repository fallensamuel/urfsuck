SWEP.Base = "progressweapon_base_v1"
if CLIENT then
	SWEP.PrintName = "Карманная кража"
	SWEP.Instructions = "Воруй деньги из карманов у тех, кто плохо за ними следит."
else
	AddCSLuaFile("shared.lua")
end

/*
	Configuration
*/
SWEP.CheckTime = 2 // pickpocket time
SWEP.StealDetection = 15 // time required to detect the loss of money (victim will receive a notify about his loss right after this time passed)
SWEP.MoneyToSteal = {20, 40} // you will earn from 20 to 40 $ for every pickpocket

/*
	Do not edit the code below unless you know what you are doing
*/
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.AdminOnly = true
SWEP.Category = "Half-Life Alyx RP"

function SWEP:PlaySound()
end

function SWEP:Deploy()
	self.MoneyToSteal = self.Owner:GetJobTable().pickpocketAmount or self.MoneyToSteal
	self.CheckTime = self.Owner:GetJobTable().pickpocketSpeed or self.CheckTime
end

function SWEP:Done(victim)
	local money_to_steal = math.random(self.MoneyToSteal[1], self.MoneyToSteal[2])
	if not victim:CanAfford(money_to_steal) or (victim.nextSteal and victim.nextSteal > CurTime()) or !victim:CanAfford(rp.cfg.StartMoney) then 
		rp.Notify(self.Owner, NOTIFY_GREEN, rp.Term('NotEnoughToSteal'))
		return 
	end
	
	victim.nextSteal = CurTime() + 30

	rp.Notify(self.Owner, NOTIFY_GREEN, rp.Term('MoneyFound'), money_to_steal)
	
	local time = self.StealDetection
	timer.Simple(time, function() if IsValid(victim) then rp.Notify(victim, NOTIFY_GREEN, rp.Term('SomeoneStoulenMoneyFromYou'), money_to_steal) end end)
	
	victim:TakeMoney(money_to_steal)
	self.Owner:AddMoney(money_to_steal)
end

if SERVER then
	hook.Add("PlayerInitialSpawn", "PickpocketDelay", function(ply)
		ply.nextSteal = CurTime() + 200 // Prevent recently connected players from pickpocket
	end)
end