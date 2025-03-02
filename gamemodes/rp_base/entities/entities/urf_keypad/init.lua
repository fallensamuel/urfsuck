AddCSLuaFile("cl_init.lua")
AddCSLuaFile("sh_init.lua")
include("sh_init.lua")

util.PrecacheSound("buttons/button14.wav")
util.PrecacheSound("buttons/button9.wav")
util.PrecacheSound("buttons/button11.wav")
util.PrecacheSound("buttons/button15.wav")
AccessorFunc(ENT, "var_Input", "Input", FORCE_STRING)

function ENT:Initialize()
	self:SetModel("models/props_lab/keypad.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	self:SetCollisionGroup(COLLISION_GROUP_WORLD)
	self:PhysWake()

	if (not self.KeypadData) then
		self.KeypadData = {
			Password = false,
			RepeatsGranted = 0,
			RepeatsDenied = 0,
			LengthGranted = 0,
			LengthDenied = 0,
			DelayGranted = 0,
			DelayDenied = 0,
			InitDelayGranted = 0,
			InitDelayDenied = 0,
			KeyGranted = 0,
			KeyDenied = 0,
			Secure = false,
			ForFactions = false,
			ForOrgs = false,
			FF_Faction = nil,
			FF_Org = nil,
			Owner = NULL
		}
	end

	self:Reset()
end

function ENT:SetData(data)
	self.KeypadData = data
	self:Reset()
end

function ENT:Submit(Player)
	if (self:GetStatus() == self.Status_None) then
		local success = false;
		if (self.KeypadData.ForOrgs and IsValid(Player) and Player:GetOrg()) then success = (Player:GetOrg() == self.KeypadData.FF_Org); end
		if (self.KeypadData.ForFactions and IsValid(Player) and Player:GetFaction()) then
			success = (Player:GetFaction() == self.KeypadData.FF_Faction);
			if success == false then
				local fac_keypadgroup = rp.FactionKeypadGroups[self.KeypadData.FF_Faction]
				if fac_keypadgroup and fac_keypadgroup[Player:GetFaction()] then
					success = true
				end	
			end
		end
		self:Process(success)
	end
end

function ENT:Use(Activator)
	if (!IsValid(Activator) or !Activator:IsPlayer()) then return end
	self:Submit(Activator);
end

function ENT:Reset()
	self:SetDisplayText("")
	self:SetInput("")
	self:SetStatus(self.Status_None)
end

function ENT:Process(granted)
	local length, repeats, delay, initdelay, owner, key

	if (granted) then
		self:SetStatus(self.Status_Granted)
		length = self.KeypadData.LengthGranted
		repeats = math.min(self.KeypadData.RepeatsGranted, 50)
		delay = self.KeypadData.DelayGranted
		initdelay = self.KeypadData.InitDelayGranted
		owner = self.KeypadData.Owner
		key = tonumber(self.KeypadData.KeyGranted) or 0
	else
		self:SetStatus(self.Status_Denied)
		length = self.KeypadData.LengthDenied
		repeats = math.min(self.KeypadData.RepeatsDenied, 50)
		delay = self.KeypadData.DelayDenied
		initdelay = self.KeypadData.InitDelayDenied
		owner = self.KeypadData.Owner
		key = tonumber(self.KeypadData.KeyDenied) or 0
	end

	timer.Simple(math.max(initdelay + length * (repeats + 1) + delay * repeats + 0.25, 2), function()
		if (IsValid(self)) then
			self:Reset()
		end
	end) -- 0.25 after last timer

	timer.Simple(initdelay, function()
		if (IsValid(self)) then
			for i = 0, repeats do
				timer.Simple(length * i + delay * i, function()
					if (IsValid(self) and IsValid(owner)) then
						numpad.Activate(owner, key)
					end
				end)

				timer.Simple(length * (i + 1) + delay * i, function()
					if (IsValid(self) and IsValid(owner)) then
						numpad.Deactivate(owner, key)
					end
				end)
			end
		end
	end)

	if (granted) then
		self:EmitSound("buttons/button9.wav")
	else
		self:EmitSound("buttons/button11.wav")
	end
end

local function HandleDuplication(ply, data, dupedata)
	local ent = ents.Create("urf_keypad")
	duplicator.DoGeneric(ent, dupedata)
	ent:Spawn()
	duplicator.DoGenericPhysics(ent, ply, dupedata)
	data['Owner'] = ply
	ent:SetData(data)

	if (IsValid(ply)) then
		ply:AddCount("keypads", ent)
	end

	return ent
end

duplicator.RegisterEntityClass("urf_keypad", HandleDuplication, "KeypadData", "Data")