-- "gamemodes\\rp_base\\entities\\weapons\\gmod_tool\\object.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
nw.Register'ToolStage':Write(net.WriteUInt, 16):Read(net.ReadUInt, 16):Filter(function(self) return self.Owner end):SetNoSync()
nw.Register'ToolOp':Write(net.WriteUInt, 16):Read(net.ReadUInt, 16):Filter(function(self) return self.Owner end):SetNoSync()

--[[---------------------------------------------------------
   Sets which stage a tool is at
-----------------------------------------------------------]]
function ToolObj:UpdateData()
	self:SetStage(self:NumObjects())
end

--[[---------------------------------------------------------
   Sets which stage a tool is at
-----------------------------------------------------------]]
function ToolObj:SetStage(i)
	if (SERVER) then
		self:GetWeapon():SetNetVar("ToolStage", i)
	end
end

--[[---------------------------------------------------------
   Gets which stage a tool is at
-----------------------------------------------------------]]
function ToolObj:GetStage()
	return self:GetWeapon():GetNetVar("ToolStage") or 0
end

--[[---------------------------------------------------------
-----------------------------------------------------------]]
function ToolObj:GetOperation()
	return self:GetWeapon():GetNetVar("ToolOp") or 0
end

--[[---------------------------------------------------------
-----------------------------------------------------------]]
function ToolObj:SetOperation(i)
	if (SERVER) then
		self:GetWeapon():SetNetVar("ToolOp", i)
	end
end

--[[---------------------------------------------------------
   ClearObjects - clear the selected objects
-----------------------------------------------------------]]
function ToolObj:ClearObjects()
	self:ReleaseGhostEntity()
	self.Objects = {}
	self:SetStage(0)
	self:SetOperation(0)
end

--[[---------------------------------------------------------
	Since we're going to be expanding this a lot I've tried
	to add accessors for all of this crap to make it harder
	for us to mess everything up.
-----------------------------------------------------------]]
function ToolObj:GetEnt(i)
	if (not self.Objects[i]) then return NULL end

	return self.Objects[i].Ent
end

--[[---------------------------------------------------------
	Returns the world position of the numbered object hit
	We store it as a local vector then convert it to world
	That way even if the object moves it's still valid
-----------------------------------------------------------]]
function ToolObj:GetPos(i)
	if (self.Objects[i].Ent:EntIndex() == 0) then
		return self.Objects[i].Pos
	else
		if (self.Objects[i].Phys ~= nil and self.Objects[i].Phys:IsValid()) then
			return self.Objects[i].Phys:LocalToWorld(self.Objects[i].Pos)
		else
			return self.Objects[i].Ent:LocalToWorld(self.Objects[i].Pos)
		end
	end
end

--[[---------------------------------------------------------
	Returns the local position of the numbered hit
-----------------------------------------------------------]]
function ToolObj:GetLocalPos(i)
	return self.Objects[i].Pos
end

--[[---------------------------------------------------------
	Returns the physics bone number of the hit (ragdolls)
-----------------------------------------------------------]]
function ToolObj:GetBone(i)
	return self.Objects[i].Bone
end

function ToolObj:GetNormal(i)
	if not self.Objects or not self.Objects[i] then 
		return Vector(0, 0, 1)
	end
	
	if IsValid(self.Objects[i].Ent) and (self.Objects[i].Ent:EntIndex() == 0) then
		return self.Objects[i].Normal
		
	else
		local norm

		if (self.Objects[i].Phys ~= nil and self.Objects[i].Phys:IsValid()) then
			norm = self.Objects[i].Phys:LocalToWorld(self.Objects[i].Normal)
		elseif IsValid(self.Objects[i].Ent) then
			norm = self.Objects[i].Ent:LocalToWorld(self.Objects[i].Normal)
		end

		return norm and (norm - self:GetPos(i)) or Vector(0, 0, 1)
	end
end

--[[---------------------------------------------------------
	Returns the physics object for the numbered hit
-----------------------------------------------------------]]
function ToolObj:GetPhys(i)
	if not self.Objects or not self.Objects[i] then
		return NULL
	end
	
	if self.Objects[i].Phys == nil then 
		return self:GetEnt(i):GetPhysicsObject() 
	end

	return self.Objects[i].Phys
end

--[[---------------------------------------------------------
	Sets a selected object
-----------------------------------------------------------]]
function ToolObj:SetObject(i, ent, pos, phys, bone, norm)
	self.Objects[i] = {}
	self.Objects[i].Ent = ent
	self.Objects[i].Phys = phys
	self.Objects[i].Bone = bone
	self.Objects[i].Normal = norm

	-- Worldspawn is a special case
	if (ent:EntIndex() == 0) then
		self.Objects[i].Phys = nil
		self.Objects[i].Pos = pos
	else
		norm = norm + pos

		-- Convert the position to a local position - so it's still valid when the object moves
		if (IsValid(phys)) then
			self.Objects[i].Normal = self.Objects[i].Phys:WorldToLocal(norm)
			self.Objects[i].Pos = self.Objects[i].Phys:WorldToLocal(pos)
		else
			self.Objects[i].Normal = self.Objects[i].Ent:WorldToLocal(norm)
			self.Objects[i].Pos = self.Objects[i].Ent:WorldToLocal(pos)
		end
	end

	if (SERVER) then end
end

-- Todo: Make sure the client got the same info
--[[---------------------------------------------------------
	Returns the number of objects in the list
-----------------------------------------------------------]]
function ToolObj:NumObjects()
	if (CLIENT) then return self:GetStage() end

	return #self.Objects
end

--[[---------------------------------------------------------
	Returns the number of objects in the list
-----------------------------------------------------------]]
function ToolObj:GetHelpText()
	return "#tool." .. GetConVarString("gmod_toolmode") .. "." .. self:GetStage()
end