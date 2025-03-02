AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

util.AddNetworkString("urf_craftable")
util.AddNetworkString("urf_craftable_recipe")
util.AddNetworkString("urf_craftable_finish")
util.AddNetworkString("urf_craftable_finish2")

function ENT:Initialize()
	self:SetModel("models/props_rp/crafting_table/weapon_crafting_table_anim.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)

	self.nodupe = true

	local phys = self:GetPhysicsObject()
	if IsValid(phys) then
		phys:SetMass(500)
		phys:Wake()
	end
end

function ENT:Use(activator, caller)
	if activator:IsBanned() then return end

	net.Start("urf_craftable")
		net.WriteEntity(self)
	net.Send(activator)
	activator.CraftTableEnt = self
end

function ENT:OnItemSelected(ply, ItemIndex)
	local tab = rp.CraftTableItems[ItemIndex]
	if not tab then return end

	if tab.customCheck and tab.customCheck(ply, self) == false then return end

	ply.ActiveRecipeIndex = ItemIndex
	ply.ReceptRequire = {}

	for i, item in pairs(tab.recipe) do
		ply.ReceptRequire[item.uid] = {
			["count"] = item.count,
			["index"] = i
		}
	end

	ply.ItemsInWorkbench = {}
end

function ENT:ClearRecipe(ply)
	ply.ActiveRecipeIndex = nil
	ply.ReceptRequire = nil
	ply.ItemsInWorkbench = {}
end

net.Receive("urf_craftable", function(len, ply)
	if not IsValid(ply.CraftTableEnt) or not ply.CraftTableEnt.IsCraftTable then return end

	local act = net.ReadUInt(2)
	if act == 1 then
		ply.CraftTableEnt:OnItemSelected(ply, net.ReadUInt(8))
	elseif act == 2 then
		local inv = ply:getInv()

		for k, v in pairs(ply.ItemsInWorkbench) do
			if v > 0 then
				inv:add(k, v)
			end
		end

		timer.Simple(0.1, function()
			if IsValid(ply) and inv then
            	inv:sync(ply, true)
            end
        end)

        ply.CraftTableEnt:ClearRecipe(ply)
	end
end)

local zeroVec = Vector(0, 0, 0)

function ENT:TryToFinishCraft(ply, index, uid)
	if table.Count(ply.ReceptRequire) < 1 then
		local recipeID = ply.ActiveRecipeIndex

		local itemTab = rp.CraftTableItems[ply.ActiveRecipeIndex]
		local time, customAng = itemTab.crafttime, itemTab.customAng

		local item_uid = rp.CraftTableItems[recipeID].result
		local inv = ply:getInv()
		if inv:IsItemLimit(ply, item_uid) then
			rp.Notify(ply, NOTIFY_RED, rp.Term("Vendor_max"))

			for k, v in pairs(ply.ItemsInWorkbench) do
				if v > 0 then
					inv:add(k, v)
				end
			end
			timer.Simple(0.1, function()
				if IsValid(ply) and inv then
	            	inv:sync(ply, true)
	            end
	        end)

			ply.CraftTableEnt:ClearRecipe(ply)
			net.Start("urf_craftable_finish2")
				net.WriteEntity(self)
			net.Send(ply)

	        return
		end

		ply.CraftTableEnt:ClearRecipe(ply)
		net.Start("urf_craftable_finish")
			net.WriteEntity(self)
		net.Send(ply)

		timer.Simple(time, function()
			local pos = self:LocalToWorld(self.ResultOffset + (itemTab.PosOffset or zeroVec))
			rp.item.spawn(item_uid, ply, function(item, ent)
				if not IsValid(ent) then return end

				ent:SetPos(pos)

				local ang = customAng and self:LocalToWorldAngles(customAng) or self:GetAngles()
				ent:SetAngles(ang)

				-- Сомнительная штука. Хз нужна ли.
				--ent:SetPos(ent:GetPos() + Vector(0, 0, 2 + ent:OBBMaxs().z))
				--local phys = ent:GetPhysicsObject()
				--if phys then
				--	phys:EnableMotion(true)
				--	phys:Wake()
				--end

				ent:EmitSound("doors/doormove2.wav")
			end)
		end)
		return
	end
end

function ENT:PhysicsCollide(data, phys)
	if self.DisableCollide then return end
	self.DisableCollide = true

	timer.Simple(0, function() -- осторожнее с физикой, выведя функцию в короутин или таймер можно избежать краша физики при возникновении ошибок скрипта
		local ent = data.HitEntity
		if IsValid(ent) and IsValid(ent.ItemOwner) and ent.ItemOwner:IsPlayer() and IsValid(ent.ItemOwner.CraftTableEnt) and ent.getItemTable then
			local ply = ent.ItemOwner
			if not ply.ReceptRequire then return end

			local uid = ent:getItemTable().uniqueID
			if not ply.ReceptRequire[uid] then return end

			local index = ply.ReceptRequire[uid].index

			ply.ItemsInWorkbench[uid] = (ply.ItemsInWorkbench[uid] or 0) + 1

			ply.ReceptRequire[uid].count = ply.ReceptRequire[uid].count - 1

			net.Start("urf_craftable_recipe")
				net.WriteUInt(ply.ReceptRequire[uid].index, 8)
			net.Send(ply)

			if ply.ReceptRequire[uid].count < 1 then
				ply.ReceptRequire[uid] = nil
			end
			SafeRemoveEntity(ent)

			ply.CraftTableEnt:TryToFinishCraft(ply, index, uid)
		end
	end)

	timer.Simple(0, function() -- два таймера на случай краха первого. в этом таймере можно быть на все 100% увереным
		if IsValid(self) then
			self.DisableCollide = nil
		end
	end)
end