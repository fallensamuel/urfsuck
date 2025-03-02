AddCSLuaFile("cl_init.lua")
AddCSLuaFile("sh_init.lua")
include("sh_init.lua")

local EMETA = FindMetaTable("Entity")
function EMETA:DistToSky()
    local tr = {}
    tr.start = self:GetPos()
    tr.endpos = tr.start + Vector(0, 0, 999999999) 
    tr.filter = function(ent) return false end
    local tr_line = util.TraceLine(tr)
    local dist = tr_line.HitPos:Distance(self:GetPos())

    return dist
end

function ENT:Initialize()
	self:SetModel(self.Model)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:DrawShadow(false)

	self:SetKeyValue("gmod_allowphysgun", 0)
	
	local phys = self:GetPhysicsObject()
	phys:EnableMotion(false)
end

function ENT:OnUse(ply)
	if self.GiveMoney then
		ply:AddMoney(self.GiveMoney)
		if self.SuccessUseTerm then rp.Notify(ply, NOTIFY_GREEN, rp.Term(self.SuccessUseTerm), rp.FormatMoney(self.GiveMoney)) end
	elseif self.GiveItem then
		local status, result = ply:getInv():add(self.GiveItem)
    	if status == false then
    	    rp.Notify(ply, NOTIFY_RED, rp.Term("Vendor_noplace"))
    	    return false
    	end

    	if self.SuccessUseTerm then
    		local itemTab = rp.item.list[self.GiveItem] or rp.item.instances[self.GiveItem]
    		rp.Notify(ply, NOTIFY_GREEN, rp.Term(self.SuccessUseTerm), itemTab.name or "unknown")
    	end
	elseif self.SpawnItem then
		local pos = self:GetPos()
		rp.item.spawn(self.SpawnItem, pos, function(item, ent)
			if not IsValid(ent) then return end
			ent:SetPos(pos)
		end)
	elseif self.SpawnEntity then
		local ent = ents.Create(self.SpawnEntity)
		ent:SetPos(self:GetPos())
		ent:Spawn()
	end
end -- мона перезаписывать для расширения функционала

function ENT:Use(ply)
	if self:GetCollisionGroup() == COLLISION_GROUP_DEBRIS_TRIGGER then return end
	if (self.CanUse and self:CanUse(ply) == false) or self:OnUse(ply) == false then return end

	self:SetCollisionGroup(COLLISION_GROUP_DEBRIS_TRIGGER)

	local offset = Vector(0, 0, 256)
	local dist = self:DistToSky()
	if dist < offset.z then offset.z = dist - self:OBBMaxs().z - 4 end
	self:SetPos(self:GetPos() + offset)

	if self.SingleUse then
		self:Remove()
	else
		timer.Simple(self.UseCooldown or 600, function()
			if IsValid(self) then
				self:SetCollisionGroup(COLLISION_GROUP_NONE)
				self:SetPos(self:GetPos() - offset)
			end
		end)
	end
end