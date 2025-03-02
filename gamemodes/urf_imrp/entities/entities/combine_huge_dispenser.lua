AddCSLuaFile()

ENT.Type = "anim"
ENT.PrintName = "Мега Раздатчик"
ENT.Author = "Chessnut"
ENT.Category = "Half-Life Alyx RP"
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.PhysgunDisable = true
ENT.PhysgunAllowAdmin = true
ENT.AdminOnly	= true
local COLOR_RED = 1
local COLOR_ORANGE = 2
local COLOR_BLUE = 3
local COLOR_GREEN = 4

local text = {[1] = "ОЖИДАНИЕ", [2] = "ЗАРЯДКА", [3] = "ПРОВЕРКА", [4] = "УСПЕШНО", [5] = 'ОШИБКА', [6] = "ЛИМИТ", [7] = "ВЫДАЧА"}

local colors = {
	[COLOR_RED] = Color(255, 50, 50),
	[COLOR_ORANGE] = Color(255, 80, 20),
	[COLOR_BLUE] = Color(50, 80, 230),
	[COLOR_GREEN] = Color(50, 240, 50)
}

function ENT:SetupDataTables()
	self:NetworkVar("Int", 0, "DispColor")
	self:NetworkVar("Int", 1, "Text")
	self:NetworkVar("Bool", 0, "Disabled")
end

if (CLIENT) then
	local cam, render, surface, draw, math = cam, render, surface, draw, math
	function ENT:Draw()

		local position, angles = self:GetPos(), self:GetAngles()

		angles:RotateAroundAxis(angles:Forward(), 90)
		angles:RotateAroundAxis(angles:Right(), 270)

		cam.Start3D2D(position + self:GetForward()*5.6 + self:GetRight()*8.5 + self:GetUp()*3, angles, 0.1)
			render.PushFilterMin(TEXFILTER.NONE)
			render.PushFilterMag(TEXFILTER.NONE)

			surface.SetDrawColor(40, 40, 40)
			surface.DrawRect(0, 0, 66, 28)

			draw.SimpleText((self:GetDisabled() and "ОТКЛЮЧЕН" or (text[self:GetText()] or "")), "Default", 33, 0, Color(255, 255, 255, math.abs(math.cos(RealTime() * 1.5) * 255)), 1, 0)

			surface.SetDrawColor(colors[self:GetDisabled() and COLOR_RED or self:GetDispColor()] or color_white)
			surface.DrawRect(4, 14, 58, 10)

			surface.SetDrawColor(60, 60, 60)
			surface.DrawOutlinedRect(4, 14, 58, 10)

			render.PopFilterMin()
			render.PopFilterMag()
		cam.End3D2D()
	end
else
	function ENT:Initialize()
		self:SetModel("models/props_junk/gascan001a.mdl")
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetUseType(SIMPLE_USE)
		self:SetText(1)
		self:DrawShadow(false)
		self:SetDispColor(COLOR_GREEN)
		self.canUse = true

		-- Use prop_dynamic so we can use entity:Fire("SetAnimation")
		self.dummy = ents.Create("prop_dynamic")
		self.dummy:SetModel("models/props_combine/combine_dispenser.mdl")
		self.dummy:SetPos(self:LocalToWorld(Vector(-2,0,0)))
		self.dummy:SetAngles(self:GetAngles())
		self.dummy:SetParent(self)
		self.dummy:Spawn()
		self.dummy:DrawShadow(false)
		self.dummy:Activate()

		self:DeleteOnRemove(self.dummy)

		local physObj = self:GetPhysicsObject()

		if (IsValid(physObj)) then
			physObj:EnableMotion(false)
			physObj:Sleep()
		end
	end

	hook('InitPostEntity', function()
		for k, v in pairs(rp.cfg.RationDispenser[game.GetMap()] or {}) do
			local ent = ents.Create('combine_dispenser')
			ent:SetPos(v.Pos)
			ent:SetAngles(v.Ang)
			ent:Spawn()
		end
	end)

	function ENT:setUseAllowed(state)
		if state then
			self:SetText(1)
			self:SetDispColor(COLOR_GREEN)
		end
		self.canUse = state
	end

	function ENT:error(text)
		self:EmitSound("buttons/combine_button_locked.wav")
		self:SetText(text)
		self:SetDispColor(COLOR_RED)

		timer.Create("nut_DispenserError"..self:EntIndex(), 1.5, 1, function()
			if (IsValid(self)) then
				self:SetText(1)
				self:SetDispColor(COLOR_GREEN)

				timer.Simple(0.5, function()
					if (!IsValid(self)) then return end

					self:setUseAllowed(true)
				end)
			end
		end)
	end

	function ENT:createRation(activator)
		local entity = ents.Create("prop_physics")
		entity:SetAngles(self:GetAngles())
		entity:SetModel("models/weapons/w_packate.mdl")
		entity:SafeSetPos(self:GetPos())
		entity:Spawn()
		entity:SetNotSolid(true)
		entity:SetParent(self.dummy)
		entity:Fire("SetParentAttachment", "package_attachment")

		timer.Simple(1.9, function()
			if (IsValid(self) and IsValid(entity)) then
				entity:Remove()
				--rp.SpawnFood(activator, "Ration", entity:GetPos(), entity:GetAngles());
				--activator:Give("foodration_default");

				local ent_ration = rp.cfg.FoodSystem.Faction[activator:GetFaction()] or rp.cfg.FoodSystem.Loyalty[math.Clamp(activator:GetJobTable().loyalty,1,4)];
				rp.FoodSystem.SpawnFood( ent_ration, entity:GetPos(), entity:GetAngles() );
			end
		end)
	end

	function ENT:dispense(amount, activator)
		if (amount < 1 || !IsValid(activator)) then
			self:setUseAllowed(true)
			return 
		end

		self:setUseAllowed(false)
		self:SetText(7)
		self:EmitSound("ambient/machines/combine_terminal_idle4.wav")
		self:createRation(activator)
		self.dummy:Fire("SetAnimation", "dispense_package", 0)

		timer.Simple(3.5, function()
			if (amount > 1) && IsValid(activator) then
				self:dispense(amount - 1, activator)
			else
				self:SetText(2)
				self:SetDispColor(COLOR_ORANGE)
				self:EmitSound("buttons/combine_button7.wav")

				timer.Simple(7, function()

					self:SetText(1)
					self:SetDispColor(COLOR_GREEN)
					self:EmitSound("buttons/combine_button1.wav")

					timer.Simple(0.75, function()
						self:setUseAllowed(true)
					end)
				end)
			end
		end)
	end

	function ENT:Use(activator)
		if ((self.nextUse or 0) >= CurTime()) then
			return
		end

		--if (!activator:IsCP()) then
		if (!self.canUse or self:GetDisabled()) then
			return
		end

		self:setUseAllowed(false)
		self:SetText(3)
		self:SetDispColor(COLOR_BLUE)
		self:EmitSound("ambient/machines/combine_terminal_idle2.wav")

		timer.Simple(1, function()
			if IsValid(activator) then
				local amount = (activator:GetJobTable().rationCount or 0) * 2

				if (amount < 0) then
					return self:error(5)
				elseif (activator.hugeNextUse or 0 > CurTime()) then
					return self:error(6)
				else
					activator:AddMoney(activator:GetSalary() * 2)
					activator:Notify(NOTIFY_GENERIC, rp.Term('RationReward'), activator:GetSalary() * 2)
					activator.hugeNextUse = CurTime() + 300

					self:SetText(4)
					self:EmitSound("buttons/button14.wav", 100, 50)

					timer.Simple(1, function()
						if IsValid(activator) then
							self:dispense(amount, activator)
						else
							self:setUseAllowed(true)
						end
					end)
				end
			else
				self:setUseAllowed(true)
			end
		end)
		--elseif (activator:IsCP()) then // TO DO RANG
		--	self:SetDisabled(!self:GetDisabled())
		--	self:EmitSound(self:GetDisabled() and "buttons/combine_button1.wav" or "buttons/combine_button2.wav")
		--	self.nextUse = CurTime() + 1
		--end
	end
end