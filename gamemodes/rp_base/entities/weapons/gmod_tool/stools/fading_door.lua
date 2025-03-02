-- "gamemodes\\rp_base\\entities\\weapons\\gmod_tool\\stools\\fading_door.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
-- First off, make meta functions for entities fading
local ent = FindMetaTable("Entity")

function ent:Fade()
	if self.FadeBlocked then return end

	self.Faded = true
	self.FadedMaterial = self:GetMaterial()
	self.fCollision = self:GetCollisionGroup()
	
	self:SetMaterial("sprites/heatwave")
	self:DrawShadow(false)
	self:SetNotSolid(true)
	
	local obj = self:GetPhysicsObject()
	if (IsValid(obj)) then
		self.FadedMotion = obj:IsMoveable()
		obj:EnableMotion(false)
	end
end

function ent:UnFade()
	if not IsValid( self ) then return end
	if self.FadeBlocked then return end

	self.Faded = nil
	
	self:SetMaterial(self.FadedMaterial or "")
	self:DrawShadow(true)
	self:SetNotSolid(false)
	
	local obj = self:GetPhysicsObject()
	if (IsValid(obj)) then
		obj:EnableMotion(false)
	end
end


function ent:MakeFadingDoor(pl, key, inversed, toggleactive)
	local makeundo = true
	if (self.FadingDoor) then
		self:UnFade()
		numpad.Remove(self.NumpadFadeUp)
		numpad.Remove(self.NumpadFadeDown)
		makeundo = false
	end
	
	self.FadeKey = key
	self.FadingDoor = true
	self.FadeInversed = inversed
	self.FadeToggle = toggleactive
	self.FadeCooldown = false
	
	self:CallOnRemove("Fading Door", self.UndoFadingDoor)
	
	self.NumpadFadeUp = numpad.OnUp(pl, key, "FadeDoor", self, false)
	self.NumpadFadeDown = numpad.OnDown(pl, key, "FadeDoor", self, true)
	
	if (inversed) then self:Fade() end
	return makeundo
end

-- Utility Functions
local function ValidTrace(tr)
	return ((tr.Entity) and (tr.Entity:IsValid())) and !((tr.Entity:IsPlayer()) or (tr.Entity:IsNPC()) or (tr.Entity:IsVehicle()) or (tr.HitWorld))
end

local function ChangeState(pl, ent, state)
	if !(ent:IsValid()) then return end
	
	local TimerID = "fc_" .. tostring( ent:GetCreationID() );

	if (ent.FadeToggle) then
		if (state == false) then return end

		if (ent.FadeCooldown and timer.Exists(TimerID)) then
			rp.Notify(pl, NOTIFY_ERROR, rp.Term('PleaseWaitX'), math.ceil(timer.TimeLeft(TimerID)));
			return
		else
			if (timer.Exists(TimerID)) then timer.Remove(TimerID); end
			timer.Create(TimerID, 4, 1, function()
				ent.FadeCooldown = false;
			end);
			ent.FadeCooldown = true;
		end

		if (ent.Faded) then ent:UnFade() else ent:Fade() end
		return
	end
	
	if state then
		if ent.FadeCooldown then
			rp.Notify( pl, NOTIFY_ERROR, rp.Term("PleaseWaitX"), math.ceil( timer.TimeLeft(TimerID) ) );
			return
		else
			if ent.FadeInversed then ent:UnFade(); else ent:Fade(); end
		end
	else
		if (!ent.FadeInversed and ent.Faded) or (ent.FadeInversed and !ent.Faded) then
			if not ent.FadeCooldown then
				if timer.Exists(TimerID) then timer.Remove(TimerID); end

				timer.Create( TimerID, 4, 1, function()
					if not IsValid(ent) then return end
					
					if ent.FadeInversed then ent:Fade(); else ent:UnFade(); end
					ent.FadeCooldown = false;
				end );

				ent.FadeCooldown = true;
			end
		end
	end

	--[[
	if ((ent.FadeInversed) and (state == false)) or ((!ent.FadeInversed) and (state == true)) then
		ent:Fade()
	else
		ent:UnFade()
	end
	]]--
end
if (SERVER) then numpad.Register("FadeDoor", ChangeState) end

TOOL.Category	= "Roleplay"
TOOL.Name		= "#tool.fading_door.name"
TOOL.Stage = 1

TOOL.ClientConVar["key"] = "5"
TOOL.ClientConVar["toggle"] = "0"
TOOL.ClientConVar["reversed"] = "0"
TOOL.ClientConVar["length"] = "4"
TOOL.ClientConVar["password"] = ""

if (CLIENT) then
	language.Add("Tool.fading_door.name", "Fading Door")
	language.Add("Tool.fading_door.desc", translates.Get("Создает из пропов переключаюмую дверь.") or "Создает из пропов переключаюмую дверь.")
	language.Add("Tool_fading_door_desc", translates.Get("Создает из пропов переключаюмую дверь.") or "Создает из пропов переключаюмую дверь.")
	language.Add("Tool.fading_door.0", translates.Get("Кликните на проп чтобы сделать его переключаемым. Правая кнопка мыши для простой установки.") or "Кликните на проп чтобы сделать его переключаемым. Правая кнопка мыши для простой установки.")
	language.Add("Undone_fading_door", translates.Get("Переключаемая дверь убрана.") or "Переключаемая дверь убрана.")
	
	function TOOL:BuildCPanel()
		self:AddControl("Header",   {Text = "#Tool_fading_door_name", Description = "#Tool_fading_door_desc"})
		self:AddControl("CheckBox", {Label = translates.Get("Инверсия") or "Инверсия", Command = "fading_door_reversed"})
		self:AddControl("CheckBox", {Label = translates.Get("Режим переключения") or "Режим переключения", Command = "fading_door_toggle"})
		self:AddControl("Numpad",   {Label = translates.Get("Кнопка") or "Кнопка", ButtonSize = "22", Command = "fading_door_key"})
		
		self:AddControl( "Slider", {	Label 	= translates.Get("Время удержания") or "Время удержания",
									Type	= "Float",
									Min		= "4",
									Max		= "10",
									Command	= "fading_door_length" } )
		self:AddControl( "TextBox", {	Label		= translates.Get("Пароль") or "Пароль",
									MaxLength	= "4",
									Command		= "fading_door_password" })
	end
	
	TOOL.LeftClick = ValidTrace
	return
end	

function TOOL:LeftClick(tr)
	if (!ValidTrace(tr)) then return false end

	local ent = tr.Entity
	
	if IsValid(ent) == false or not ent:IsProp() then return false end

	local pl = self:GetOwner()
	if (ent:MakeFadingDoor(pl, self:GetClientNumber("key"), self:GetClientNumber("reversed") == 1, self:GetClientNumber("toggle") == 1)) then
		self.key = self:GetClientNumber("key")
		self.key2 = -1
		undo.Create("fading_door")
			undo.AddFunction(function()
				ent:UnFade()
				ent.FadingDoor = nil
				numpad.Remove(ent.NumpadFadeUp)
				numpad.Remove(ent.NumpadFadeDown)
			end)
			undo.SetPlayer(pl)
		undo.Finish()
	end
	rp.Notify(pl, NOTIFY_GREEN, rp.Term('FadeDoorCreated'))
	return true
end

function TOOL:LinkKeypad(Ent, Key, Password, HoldLength)
	local data = {
	    ['Owner']            = self:GetOwner(),
	    ['InitDelayGranted'] = 0,
	    ['DelayGranted']     = 0,
	    ['LengthGranted']    = HoldLength - 4,
	    ['RepeatsGranted']   = 0,
	    ['InitDelayDenied']  = 0,
	    ['DelayDenied']      = 0,
	    ['LengthDenied']     = 0.1,
	    ['RepeatsDenied']    = 0,
	    ['KeyGranted']       = Key,
	    ['KeyDenied']        = 0,
	    ['Password']         = Password,
	    ['Secure']           = false,
	}

	Ent:SetData(data)
	Ent:GetPhysicsObject():EnableMotion(false)
	Ent:CPPISetOwner(self:GetOwner())
	self:GetOwner():AddCount("keypads", Ent)
	self:GetOwner():AddCleanup("keypads", Ent)
	
	Ent.keypad_keygroup1 = self:GetClientNumber("key")
	Ent.keypad_keygroup2 = -1
	Ent.keypad_length1 = self:GetClientNumber("length") or 4
	Ent.keypad_length2 = -1
end

function TOOL:RightClick(tr)
	if not SERVER then return end
	
	local pl = self:GetOwner()

	local ent = tr.Entity
	if IsValid(ent) and not ent:IsProp() then return false end

	if not self.Stage or self.Stage == 1 then
		if (!ValidTrace(tr)) then return false end
		local ent = tr.Entity
	
		if (ent:MakeFadingDoor(pl, self:GetClientNumber("key"), self:GetClientNumber("reversed") == 1, self:GetClientNumber("toggle") == 1)) then
			undo.Create("fading_door")
				undo.AddFunction(function()
					ent:UnFade()
					ent.FadingDoor = nil
					numpad.Remove(ent.NumpadFadeUp)
					numpad.Remove(ent.NumpadFadeDown)
				end)
				undo.SetPlayer(pl)
			undo.Finish()
		end
		rp.Notify(pl, NOTIFY_GREEN, rp.Term('FadeDoorCreatedExtra'))
		self.Stage = 2
	else
		if not (pl:CheckLimit("keypads")) then return false end
		
		local Password = tonumber(self:GetClientNumber("password"))
		
		if (Password == nil) or (string.len(tostring(Password)) > 4) or (string.find(tostring(Password), "0")) or Password < 0 then
			rp.Notify(pl, NOTIFY_ERROR, rp.Term('InvalidPassword'))
			return false
		end
		
		if tonumber(self:GetClientNumber("length")) < 4 then
			rp.Notify(pl, NOTIFY_ERROR, rp.Term('KeypadHoldLength'), 4)
			return false
		end
		
		local SpawnPos = tr.HitPos
		
		local Keypad = ents.Create("keypad")
		Keypad:SetPos(SpawnPos)
		Keypad:SetAngles(tr.HitNormal:Angle())
		Keypad:Spawn()
		Keypad:Activate()

		self:LinkKeypad(Keypad, self:GetClientNumber("key"), self:GetClientNumber("password"), self:GetClientNumber("length"))
		
		undo.Create("Keypad")
			undo.AddEntity(Keypad)
			undo.SetPlayer(pl)
		undo.Finish()

		rp.Notify(pl, NOTIFY_GREEN, rp.Term('KeypadCreated'))
		self.Stage = 1
	end
	
	return true
end
