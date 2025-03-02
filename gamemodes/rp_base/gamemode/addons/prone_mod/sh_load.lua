wOS.AnimExtension.Mounted[ "Prone Mod" ] = true
MsgC( Color( 255, 255, 255 ), "[wOS] Successfully mounted animation extension: Prone Mod\n" )

local whereami = "rp_base/gamemode/addons/prone_mod/"

local include_realm = {
	sv = (SERVER) and include or function() end,
	cl = (SERVER) and AddCSLuaFile or include
}

include_realm.sh = function(f)
    include_realm.sv(f)
    include_realm.cl(f)
end

local load = function(realm, path)
	include_realm[realm](whereami..path)
end

-- Copyright 2016, George "Stalker" Petrou. Enjoy!

--[[	DOCUMENTATION	
HOOKS:
	prone.Initialized
		- Called after the Prone Mod has finished loading.

	Note: These hooks are predicted.
	
	prone.OnPlayerEntered
		- Called when a player is getting down to go prone.
		- Arg One:	Player entering prone.
		- Arg Two:	The length of their get down animation.
	prone.OnPlayerExitted
		- Called when a player just completely exitted prone.
		- Arg One:	The player that exitted prone.
	prone.CanEnter
		- Called to see if a player can enter prone.
		- Arg One:	The player that wants to go prone.
		- Return:	A boolean determining if they can enter prone or not.
	prone.CanExit
		- Called to see if a player can exit prone.
		- Arg One:	The player that wants to exit prone.
		- Return:	A boolean determining if they can exit prone or not.
FUNCTIONS:
	NOTE: None of these functions exist till after the initialize hook is called.
	
	PLAYER:IsProne()
		- Shared
		- Returns true if the player is prone.
	PLAYER:GetProneAnimationState()
		- Shared
		- Returns one of the PRONE_ enums mentionned below.
	prone.Handle(Player)
		- Shared
		- If the player is prone this will make them exit, otherwise it will make them enter prone.
		- For prediction try to call this shared if you can.
	prone.Enter(Player)
		- Shared
		- Will make the player go prone, doesn't check to see if they should or if they are already in prone.
		- You should probably check with ply:IsProne() and prone.CanEnter(Player) before using this function.
		- For prediction try to call this shared if you can.
	prone.End(Player)
		- Shared
		- Will make the given player exit prone, doesn't check to see if they should or if they are already out of prone.
		- You should probably check with ply:IsProne() and prone.CanExit(Player) before using this function.
		- For prediction try to call this shared if you can.
	prone.Exit(Player)
		- Shared
		- Will make the player immediately exit prone, skipping the get up animation. Doesn't check to see if a player is already prone.
	prone.Request()
		- Client
		- Will ask the server to exit prone if they are prone or to enter prone if they aren't.
	RunConsoleCommand("prone_config")
		- Client
		- Will open up the in-game prone configuration menu.


	NOTE: These functions below MUST be called in or after the prone.Initialzed hook has been called.
	prone.AddNewHoldTypeAnimation(holdtype, movingSequenceName, idleSequenceName)
		- Shared
		- Registers a new hold type animation. Requires a sequence name for the moving animation and idle animation for that holdtype.
		- Can be used to override pre-existing holdtypes. Must be called shared.
	prone.GetIdleAnimation(holdtype)
		- Shared
		- Returns the name of the sequence corresponding the idle stance of the given holdtype.
	prone.GetMovingAnimation(holdtype)
		- Shared
		- Returns the name of the sequence corresponding the moving stance of the given holdtype.

ENUMERATIONS:
	PRONE_GETTINGDOWN	= 0
		-- Set when the player is getting down into prone.
	PRONE_INPRONE		= 1
		-- Set when the player is down in prone.
	PRONE_GETTINGUP		= 2
		-- Set when the player is getting up.
	PRONE_NOTINPRONE	= 3
		-- Set when a player is not prone.
]]
-- Create tables to store almost everything
prone = prone or {}
prone.animations = prone.animations or {}
prone.config = prone.config or {}

-- YearMonthDay
prone.Version = 20170505

-- States
PRONE_GETTINGDOWN	= 0
PRONE_INPRONE		= 1
PRONE_GETTINGUP		= 2
PRONE_NOTINPRONE	= 3

-- The impulse number to be used for toggling prone.
-- If anybody steals my number there will be hell to pay.
PRONE_IMPULSE = 127

-- If this is true then the prone mod will try to add compatibility for addons and gamemodes which it doesn't work well with.
prone.AddonCompatibility = true

function prone.WritePlayer(ply)
	if IsValid(ply) then
		net.WriteUInt(ply:EntIndex(), 7)
	else
		net.WriteUInt(0, 7)
	end
end

function prone.ReadPlayer()
	local i = net.ReadUInt(7)
	if not i then
		return
	end
	return Entity(i)
end

rp.cfg.DisableProneMod = true
hook.Remove("SetupMove", "prone.Handle")
hook.Remove("UpdateAnimation", "prone.Animations")
hook.Remove("CalcMainActivity", "prone.Animations")
hook.Remove("PlayerNoClip", "prone.ExitOnNoclip")
hook.Remove("VehicleMove", "prone.ExitOnVehicleEnter")

local DoLoad = function()
	if rp.cfg.DisableProneMod then return end

	load("sh", "prone/config.lua")
	load("sh", "prone/sh_prone.lua")
	load("cl", "prone/cl_prone.lua")
	load("sv", "prone/sv_prone.lua")
	if prone.AddonCompatibility then
		load("sh", "prone/sh_compatibility.lua")
	end

	if SERVER then
		resource.AddWorkshop("775573383")
	end

	hook.Call("prone.Initialized")
	MsgC(Color(40, 149, 220), "prone.Initialized")
end

if rp.AlreadyInitializeD then
	DoLoad()
else
	hook.Add("Initialize", "prone.Initialize", function()
		rp.AlreadyInitializeD = true
		DoLoad()
	end)
end
-- Sandbox C-Menu
--[[
if CLIENT then
	hook.Add("PopulateToolMenu", "prone.SandboxOptionsMenu", function()
		spawnmenu.AddToolMenuOption("Utilities", "User", "prone_options", "Prone Options", "", "", function(panel)
			panel:SetName("Prone Mod")
			panel:AddControl("Header", {
				Text = "",
				Description = "Configuration menu for the Prone Mod."
			})

			panel:AddControl("Checkbox", {
				Label = "Enable the bind key",
				Command = "prone_bindkey_enabled"
			})

			panel:AddControl("Checkbox", {
				Label = "Double-tap the bind key",
				Command = "prone_bindkey_doubletap"
			})

			panel:AddControl("Checkbox", {
				Label = "Can press jump to get up",
				Command = "prone_jumptogetup"
			})

			panel:AddControl("Checkbox", {
				Label = "Double-tap jump to get up",
				Command = "prone_jumptogetup"
			})

			panel:AddControl("Numpad", {
				Label = "Set the Bind-Key",
				Command = "prone_bindkey_key"
			})
		end)
	end)
end
]]--