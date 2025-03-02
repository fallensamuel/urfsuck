AddCSLuaFile()

ENT.Type = "anim"
ENT.PrintName = "Item"
ENT.Category = "RP"
ENT.RenderGroup = RENDERGROUP_BOTH
ENT.LazyFreeze = true

if (SERVER) then
	function ENT:Initialize()
		self:SetModel("models/props_junk/watermelon01.mdl")
		self:SetSolid(SOLID_VPHYSICS)
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
		self.health = 50

		local physObj = self:GetPhysicsObject()

		//if (IsValid(physObj)) then
		//	physObj:EnableMotion(true)
		//	physObj:Wake()
		//end
		
		hook.Run("OnItemSpawned", self)
	end

	function ENT:setHealth(amount)
		self.health = amount
	end
	
	function ENT:OnTakeDamage(dmginfo)
		if not (self.getItemTable(self) and self.getItemTable(self).NoDamage) then 
			local damage = dmginfo:GetDamage()
			self:setHealth(self.health - damage)

			if (self.health < 0 and !self.onbreak) then
				self.onbreak = true
				self:Remove()
			end
		end
	end
else
	ENT.DrawEntityInfo = true

	local toScreen = FindMetaTable("Vector").ToScreen
	local colorAlpha = ColorAlpha

	function ENT:onDrawEntityInfo(alpha)
		local itemTable = self.getItemTable(self)

		if (itemTable) then
			local oldData = itemTable.data
			itemTable.data = self.getNetVar(self, "data", {})
			itemTable.entity = self

			local position = toScreen(self.LocalToWorld(self, self.OBBCenter(self)))
			local x, y = position.x, position.y
			local description = itemTable.getDesc(itemTable)

			if (description != self.desc) then
				self.desc = description
				self.markup = rp.markup.parse("<font=nutItemDescFont>" .. description .. "</font>", ScrW() * 0.7)
			end
			
			rp.util.drawText(itemTable.getName and itemTable:getName() or L(itemTable.name), x, y, colorAlpha(rp.config.get("color"), alpha), 1, 1, nil, alpha * 0.65)

			y = y + 12
			if (self.markup) then
				self.markup:draw(x, y, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
			end

			x, y = hook.Run("DrawItemDescription", self, x, y, colorAlpha(color_white, alpha), alpha * 0.65)

			itemTable.entity = nil
			itemTable.data = oldData
		end		
	end

	function ENT:Draw()
		self:DrawModel()
	end
end