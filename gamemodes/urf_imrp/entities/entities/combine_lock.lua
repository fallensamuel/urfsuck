AddCSLuaFile()

local PLUGIN = PLUGIN

ENT.Type = "anim"
ENT.PrintName = "Combine Lock"
ENT.Category = "Half-Life Alyx RP"
ENT.Author = "Chessnut"
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.PhysgunDisable = true
ENT.RemoveOnJobChange = true
ENT.RemoveDelay = 300
ENT.AdminOnly	= true
ENT.defaultState = true

function ENT:SetupDataTables()
	self:NetworkVar("Bool", 0, "Locked")
	self:NetworkVar("Bool", 1, "Erroring")
end

function ENT:SpawnFunction(client, trace)
	local door = trace.Entity
	local entity = ents.Create("combine_lock")
	entity:SetPos(trace.HitPos)
	entity:Spawn()
	entity:Activate()
	if (IsValid(door) and door:IsDoor() and !IsValid(door.lock)) then
		local position, angles = self:getLockPos(client, door)
		entity:setDoor(door, position, angles)
	end

	return entity
end

if (SERVER) then
	hook("InitPostEntity", function()
		local doors = ents.FindByClass("prop_door_rotating")

		for k, v in ipairs(doors) do
			local parent = v:GetOwner()

			if (IsValid(parent)) then
				v.partner = parent
				parent.partner = v
			else
				for k2, v2 in ipairs(doors) do
					if (v2:GetOwner() == v) then
						v2.partner = v
						v.partner = v2

						break
					end
				end
			end
		end

		//{
		//	door_id,
		//	pos,
		//	angles,
		//	unlocked,
		//}

		for k, v in pairs(rp.cfg.CombineLocks[game.GetMap()] or {}) do
			local door = ents.GetMapCreatedEntity(v[1])

			if (IsValid(door) and door:IsDoor()) then
				local entity = ents.Create("combine_lock")
				entity:SetPos(door:GetPos())
				entity:Spawn()
				entity:setDoor(door, v[2], v[3])

				if (!v[4]) then
					entity:toggle(true)
				end
			end
		end
	end)
	
	hook('GravGunOnPickedUp', function(pl, ent)
		if ent.isCombineLock then
			ent.holder = pl
		end
	end)

	hook('GravGunOnDropped', function(pl, ent)
		if ent.isCombineLock then
			ent.holder = nil
		end
	end)

	function ENT:Initialize()
		self:SetModel("models/props_combine/combine_lock01.mdl")
		self:SetSolid(SOLID_VPHYSICS)
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
		self:SetUseType(SIMPLE_USE)
		self.isCombineLock = true
	end

	function ENT:OnRemove()
		if (IsValid(self.door)) then
			self.door:DoorLock(false)
		end
	end

	function ENT:StartTouch(ent)
		if !self.door then
			if ent:IsDoor() && IsValid(self.holder) && !IsValid(ent.lock) then
				local pos, ang = self:getLockPos(self.holder, ent)
				self:setDoor(ent, pos, ang)
			end
		end
	end

	function ENT:Use(activator)
		if !self.door then
			activator:Notify(NOTIFY_ERROR, rp.Term('PlaceLockOnDoor'))
			return 
		end
		if (self:GetErroring()) then
			return
		end

		if ((self.nutNextLockUse or 0) < CurTime()) then
			self.nutNextLockUse = CurTime() + 1
		else
			return
		end

		if !(activator:IsCombine() or activator:IsSOD()) then
			self:error()

			return
		end

		if (hook.Run("PlayerCanUseLock", activator) != false) then
			self:toggle()
		end
	end

	function ENT:error()
		self:EmitSound("buttons/combine_button_locked.wav")
		self:SetErroring(true)

		timer.Create("nut_CombineLockErroring"..self:EntIndex(), 1, 2, function()
			if (IsValid(self)) then
				self:SetErroring(false)
			end
		end)
	end

	function ENT:toggle(override)
		if (override != nil) then
			self:SetLocked(override)
		elseif ((self.nextToggle or 0) < CurTime()) then
			self.nextToggle = CurTime() + 1
			self:SetLocked(!self:GetLocked())
		else
			return
		end

		local partner = self.door.partner

		if (!self:GetLocked()) then
			self:EmitSound("buttons/combine_button7.wav")
			self.door:DoorLock(false)

			if (IsValid(partner)) then
				partner:DoorLock(false)
			end
		else
			self:EmitSound("buttons/combine_button2.wav")

			self.door:Fire("close")
			self.door:DoorLock(true)

			if (IsValid(partner)) then
				partner:Fire("close")
				partner:DoorLock(true)
			end
		end

		self:NextThink(CurTime() + 120)
	end

	function ENT:Think()
		self:toggle(self.defaultState)

		return true
	end

	function ENT:getLockPos(client, door)
		local vStart = client:EyePos()
		local vForward = client:GetAimVector()
	
		local trace = {}
		trace.start = vStart
		trace.endpos = vStart + ( vForward * 4096 )
		trace.filter = {client, self}

		tr = util.TraceLine( trace )


		local index, index2 = door:LookupBone("handle")
		local normal = tr.HitNormal:Angle()
		local position = client:GetEyeTrace().HitPos


		if (index and index >= 1) then
			position = door:GetBonePosition(index)
		end

		position = position + normal:Forward()*3.5 + normal:Up()*10
		
		normal:RotateAroundAxis(normal:Up(), 90)
		normal:RotateAroundAxis(normal:Forward(), 180)
		normal:RotateAroundAxis(normal:Right(), 180)
		
		return position, normal
	end

	function ENT:setDoor(door, position, angles)
		if (!IsValid(door)) then
			return
		end
		if IsValid(self.holder) then
			self.holder:DropObject()
		end

		self.door = door
		door.lock = self

		self:SetPos(position)
		self:SetAngles(angles)
		self:SetParent(door)
	end
else
	local render = render
	local glowMaterial = Material("sprites/glow04_noz")
	local color_orange = Color(255, 125, 0)
	local color_green = Color(0, 255, 0)
	local color_red = Color(255, 0, 0)

	function ENT:Draw()
		self:DrawModel()

		local position = self:GetPos() + self:GetUp()*-8.7 + self:GetForward()*-3.85 + self:GetRight()*-6
		local color = color_green

		if (self:GetErroring()) then
			color = color_red
		elseif self:GetLocked() then
			color =  color_orange
		end

		render.SetMaterial(glowMaterial)
		render.DrawSprite(position, 14, 14, color)
	end
end