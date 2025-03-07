-- "gamemodes\\rp_base\\gamemode\\main\\sandbox\\spawnmenu\\creationmenu\\content\\contentsidebar_cl.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
CONTENTSEARCHLOAD = true
local pnlSearch = vgui.RegisterFile("ContentSearch_cl.lua")
CONTENTSEARCHLOAD = nil
local PANEL = {}

function PANEL:Init()
	self.Tree = vgui.Create("DTree", self)
	self.Tree:SetClickOnDragHover(true)

	self.Tree.OnNodeSelected = function(Tree, Node)
		hook.Call("ContentSidebarSelection", GAMEMODE, self:GetParent(), Node)
	end

	self.Tree:Dock(FILL)
	self.Tree:SetBackgroundColor(Color(240, 240, 240, 255))
	self:SetPaintBackground(false)
end

function PANEL:EnableModify()
	self.Search = vgui.CreateFromTable(pnlSearch, self)
	self:CreateSaveNotification()
	self.Toolbox = vgui.Create("ContentSidebarToolbox", self)

	hook("OpenToolbox", "OpenToolbox", function()
		if (not IsValid(self.Toolbox)) then return end
		self.Toolbox:Open()
	end)
end

function PANEL:CreateSaveNotification()
	local SavePanel = vgui.Create("DButton", self)
	SavePanel:Dock(TOP)
	SavePanel:DockMargin(16, 1, 16, 4)
	SavePanel:SetIcon("icon16/disk.png")
	SavePanel:SetText("#spawnmenu.savechanges")
	SavePanel:SetVisible(false)

	SavePanel.DoClick = function()
		SavePanel:SlideUp(0.2)
		hook.Run("OnSaveSpawnlist")
	end

	hook("SpawnlistContentChanged", "ShowSaveButton", function()
		if (SavePanel:IsVisible()) then return end
		SavePanel:SlideDown(0.2)
	end)
end

vgui.Register("ContentSidebar", PANEL, "DPanel")