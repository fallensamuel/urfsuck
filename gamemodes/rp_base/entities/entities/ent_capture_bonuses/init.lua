AddCSLuaFile('cl_init.lua')
AddCSLuaFile('shared.lua')
include('shared.lua')

util.AddNetworkString('Capture.Rewards.BoxUse')

function ENT:Initialize()
	self:SetModel("models/items/ammocrate_smg1.mdl") 
	self:SetMoveType(MOVETYPE_NONE)
	self:SetSolid(SOLID_VPHYSICS)
	self:DropToFloor()
	self:SetUseType(SIMPLE_USE)
	
	self.PlayersUseTime = {}
	
	local phys = self:GetPhysicsObject()
	if IsValid(phys) then
		phys:EnableMotion(false)
	end
	
	self:SetCapturePoint(1)
end

local math_ceil = math.ceil

function ENT:Use(ply)
	if self:HasAccess(ply) then
		if self.PlayersUseTime[ply:SteamID64()] and self.PlayersUseTime[ply:SteamID64()] > CurTime() then
			rp.Notify(ply, NOTIFY_ERROR, rp.Term('CaptureRewardsBox.Wait'), math_ceil(self.PlayersUseTime[ply:SteamID64()] - CurTime()))
			return
		end
		
		local point = rp.Capture.Points[self:GetCapturePoint()]
		local box_data = point.Boxes[self:GetBoxId()]
		
		
		-- GIVE REWARDS --
		if box_data.add_ammo then
			ply:GiveAmmo(box_data.add_ammo.amount, box_data.add_ammo.ammo)
			rp.Notify(ply, NOTIFY_GREEN, rp.Term('CaptureRewardsBox.GiveAmmos'), box_data.add_ammo.amount)
		end
		
		if box_data.add_ammos then
			ply:GiveAmmos(box_data.add_ammos) 
			rp.Notify(ply, NOTIFY_GREEN, rp.Term('CaptureRewardsBox.GiveAmmos'), box_data.add_ammos)
		end
		
		if box_data.spWeapons then
			local cur_weps = (not point.isOrg) and box_data.spWeapons[ply:GetAlliance()] or box_data.spWeapons[0]
			
			if cur_weps then
				for j = 1, #cur_weps do
					ply:Give(cur_weps[j])
				end
				
				rp.Notify(ply, NOTIFY_GREEN, rp.Term('CaptureRewardsBox.GiveWeapon'), table.concat(cur_weps, ', '))
			end
		end
		
		if box_data.payment then
			ply:AddMoney(box_data.payment)
			rp.Notify(ply, NOTIFY_GREEN, rp.Term('CaptureRewardsBox.GiveMoney'), rp.FormatMoney(box_data.payment))
		end
		
		if box_data.add_armor then
			ply:SetArmor(math.min(ply:Armor() + box_data.add_armor, rp.cfg.MaxArmor))
			rp.Notify(ply, NOTIFY_GREEN, rp.Term('CaptureRewardsBox.GiveArmor'), box_data.add_armor)
		end
		------------------
		
		
		self.PlayersUseTime[ply:SteamID64()] = CurTime() + self.ReuseTimeout
		
		net.Start('Capture.Rewards.BoxUse')
			net.WriteEntity(self)
			net.WriteFloat(self.PlayersUseTime[ply:SteamID64()])
		net.Send(ply)
		
		--rp.Notify(ply, NOTIFY_GREEN, rp.Term('CaptureRewardsBox.Success'))
	else
		rp.Notify(ply, NOTIFY_ERROR, rp.Term('CaptureRewardsBox.Fail'))
	end
end