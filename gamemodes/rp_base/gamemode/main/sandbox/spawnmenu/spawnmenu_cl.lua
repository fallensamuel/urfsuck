-- "gamemodes\\rp_base\\gamemode\\main\\sandbox\\spawnmenu\\spawnmenu_cl.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local spawnmenu_border = CreateConVar("spawnmenu_border", "0.1", {FCVAR_ARCHIVE})
local PANEL = {}

--[[---------------------------------------------------------
   Name: Paint
-----------------------------------------------------------]]
function PANEL:Init()
	self.ToolMenu = vgui.Create("ToolMenu", self)
	self.ToolMenu:Dock(RIGHT)
	self.ToolMenu:DockMargin(0, 20, 3, 10)
	self.CreateMenu = vgui.Create("CreationMenu", self)
	self.CreateMenu:Dock(FILL)
	self.CreateMenu:DockMargin(3, 20, 3, 10)
	self.m_bHangOpen = false
	self:SetMouseInputEnabled(true)
	self.ToolToggle = vgui.Create("DImageButton", self)
	self.ToolToggle:SetMaterial("gui/spawnmenu_toggle")
	self.ToolToggle:SetSize(16, 16)

	self.ToolToggle.DoClick = function()
		self.ToolMenu:SetVisible(not self.ToolMenu:IsVisible())
		self:InvalidateLayout()

		if (self.ToolMenu:IsVisible()) then
			self.ToolToggle:SetMaterial("gui/spawnmenu_toggle")
		else
			self.ToolToggle:SetMaterial("gui/spawnmenu_toggle_back")
		end
	end
end

function PANEL:OpenCreationMenuTab(name)
	self.CreateMenu:SwitchToName(name)
end

function PANEL:GetToolMenu()
	return self.ToolMenu
end

--[[---------------------------------------------------------
   Name: OnClick
-----------------------------------------------------------]]
function PANEL:OnMousePressed()
	self:Close()
end

--[[---------------------------------------------------------
   Name: HangOpen
-----------------------------------------------------------]]
function PANEL:HangOpen(bHang)
	self.m_bHangOpen = bHang
end

--[[---------------------------------------------------------
   Name: HangingOpen
-----------------------------------------------------------]]
function PANEL:HangingOpen()
	return self.m_bHangOpen
end

--[[---------------------------------------------------------
   Name: Paint
-----------------------------------------------------------]]
function PANEL:Open()
	RestoreCursorPosition()
	self.m_bHangOpen = false

	-- If the context menu is open, try to close it..
	if (g_ContextMenu:IsVisible()) then
		g_ContextMenu:Close(true)
	end

	if (self:IsVisible()) then return end
	CloseDermaMenus()
	self:MakePopup()
	self:SetVisible(true)
	self:SetKeyboardInputEnabled(false)
	self:SetMouseInputEnabled(true)
	self:SetAlpha(255)
	achievements.SpawnMenuOpen()
end

--[[---------------------------------------------------------
   Name: Paint
-----------------------------------------------------------]]
function PANEL:Close(bSkipAnim)
	if (self.m_bHangOpen) then
		self.m_bHangOpen = false

		return
	end

	RememberCursorPosition()
	CloseDermaMenus()
	self:SetKeyboardInputEnabled(false)
	self:SetMouseInputEnabled(false)
	self:SetVisible(false)
end

--[[---------------------------------------------------------
   Name: PerformLayout
-----------------------------------------------------------]]
function PANEL:PerformLayout()
	self:SetSize(ScrW(), ScrH())
	self:SetPos(0, 0)
	local MarginX = math.Clamp((ScrW() - 1024) * spawnmenu_border:GetFloat(), 25, 256)
	local MarginY = math.Clamp((ScrH() - 768) * spawnmenu_border:GetFloat(), 25, 256)
	self:DockPadding(0, 0, 0, 0)
	self.CreateMenu:DockMargin(MarginX, MarginY, 1, MarginY)
	self.ToolMenu:DockMargin(0, MarginY, MarginX, MarginY)
	self.ToolToggle:AlignRight(6)
	self.ToolToggle:AlignTop(6)
end

--[[---------------------------------------------------------
   Name: StartKeyFocus
-----------------------------------------------------------]]
function PANEL:StartKeyFocus(pPanel)
	self.m_pKeyFocus = pPanel
	self:SetKeyboardInputEnabled(true)
	self:HangOpen(true)
end

--[[---------------------------------------------------------
   Name: EndKeyFocus
-----------------------------------------------------------]]
function PANEL:EndKeyFocus(pPanel)
	if (self.m_pKeyFocus ~= pPanel) then return end
	self:SetKeyboardInputEnabled(false)
end

vgui.Register("SpawnMenu", PANEL, "EditablePanel")

--[[---------------------------------------------------------
   Called to create the spawn menu..
-----------------------------------------------------------]]
local function CreateSpawnMenu()
	-- If we have an old spawn menu remove it.
	if (IsValid(g_SpawnMenu)) then
		g_SpawnMenu:Remove()
		g_SpawnMenu = nil
	end

	-- Start Fresh
	spawnmenu.ClearToolMenus()
	-- Add defaults for the gamemode. In sandbox these defaults
	-- are the Main/Postprocessing/Options tabs.
	-- They're added first in sandbox so they're always first
	hook.Run("AddGamemodeToolMenuTabs")
	-- Use this hook to add your custom tools
	-- This ensures that the default tabs are always
	-- first.
	hook.Run("AddToolMenuTabs")
	-- Use this hook to add your custom tools
	-- We add the gamemode tool menu categories first
	-- to ensure they're always at the top.
	hook.Run("AddGamemodeToolMenuCategories")
	hook.Run("AddToolMenuCategories")
	-- Add the tabs to the tool menu before trying
	-- to populate them with tools.
	hook.Run("PopulateToolMenu")
	g_SpawnMenu = vgui.Create("SpawnMenu")
	g_SpawnMenu:SetVisible(false)
	CreateContextMenu()
	hook.Run("PostReloadToolsMenu")
end

-- Hook to create the spawnmenu at the appropriate time (when all sents and sweps are loaded)
hook("OnGamemodeLoaded", "CreateSpawnMenu", CreateSpawnMenu)
concommand.Add("spawnmenu_reload", CreateSpawnMenu)

function GM:OnSpawnMenuOpen()
	-- Let the gamemode decide whether we should open or not..
	if (not hook.Call("SpawnMenuOpen", GAMEMODE)) then return end

	if (IsValid(g_SpawnMenu)) then
		g_SpawnMenu:Open()
	end
end

function GM:OnSpawnMenuClose()
	if (IsValid(g_SpawnMenu)) then
		g_SpawnMenu:Close()
	end

	-- We're dragging from the spawnmenu but the spawnmenu is closed
	-- so keep the dragging going using the screen clicker
	if (dragndrop.IsDragging()) then
		gui.EnableScreenClicker(true)
	end
end

--[[---------------------------------------------------------
   Name: HOOK SpawnMenuKeyboardFocusOn
		Called when text entry needs keyboard focus
-----------------------------------------------------------]]
local function SpawnMenuKeyboardFocusOn(pnl)
	if (IsValid(g_SpawnMenu) and IsValid(pnl) and pnl:HasParent(g_SpawnMenu)) then
		g_SpawnMenu:StartKeyFocus(pnl)
	end

	if (IsValid(g_ContextMenu) and IsValid(pnl) and pnl:HasParent(g_ContextMenu)) then
		g_ContextMenu:StartKeyFocus(pnl)
	end
end

hook("OnTextEntryGetFocus", "SpawnMenuKeyboardFocusOn", SpawnMenuKeyboardFocusOn)

--[[---------------------------------------------------------
   Name: HOOK SpawnMenuKeyboardFocusOff
		Called when text entry stops needing keyboard focus
-----------------------------------------------------------]]
local function SpawnMenuKeyboardFocusOff(pnl)
	if (IsValid(g_SpawnMenu) and IsValid(pnl) and pnl:HasParent(g_SpawnMenu)) then
		g_SpawnMenu:EndKeyFocus(pnl)
	end

	if (IsValid(g_ContextMenu) and IsValid(pnl) and pnl:HasParent(g_ContextMenu)) then
		g_ContextMenu:EndKeyFocus(pnl)
	end
end

hook("OnTextEntryLoseFocus", "SpawnMenuKeyboardFocusOff", SpawnMenuKeyboardFocusOff)

--[[---------------------------------------------------------
   Name: HOOK SpawnMenuOpenGUIMousePressed
		Don't do context screen clicking if spawnmenu is open
-----------------------------------------------------------]]
local function SpawnMenuOpenGUIMousePressed()
	if (not IsValid(g_SpawnMenu)) then return end
	if (not g_SpawnMenu:IsVisible()) then return end

	return true
end

hook("GUIMousePressed", "SpawnMenuOpenGUIMousePressed", SpawnMenuOpenGUIMousePressed)

--[[---------------------------------------------------------
   Name: HOOK SpawnMenuOpenGUIMousePressed
		Close spawnmenu if it's open
-----------------------------------------------------------]]
local function SpawnMenuOpenGUIMouseReleased()
	if (not IsValid(g_SpawnMenu)) then return end
	if (not g_SpawnMenu:IsVisible()) then return end
	g_SpawnMenu:Close()

	return true
end

hook("GUIMouseReleased", "SpawnMenuOpenGUIMouseReleased", SpawnMenuOpenGUIMouseReleased)