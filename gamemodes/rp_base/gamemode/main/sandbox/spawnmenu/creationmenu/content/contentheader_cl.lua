-- "gamemodes\\rp_base\\gamemode\\main\\sandbox\\spawnmenu\\creationmenu\\content\\contentheader_cl.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local PANEL = {}

--[[--------------------------------------------------------
   Name: Init
---------------------------------------------------------]]
function PANEL:Init()
	self:SetFont("ContentHeader")
	self:SetBright(true)
	self:SetExpensiveShadow(2, Color(0, 0, 0, 130))
	self:SetSize(64, 64)
	self.OwnLine = true
end

function PANEL:PerformLayout()
	self:SizeToContents()
	self:SetTall(64)
end

function PANEL:ToTable(bigtable)
	local tab = {}
	tab.type = "header"
	tab.text = self:GetText()
	table.insert(bigtable, tab)
end

function PANEL:Copy()
	local copy = vgui.Create("ContentHeader", self:GetParent())
	copy:SetText(self:GetText())
	copy:CopyBounds(self)

	return copy
end

function PANEL:PaintOver(w, h)
	self:DrawSelections()
end

function PANEL:DoRightClick()
	local pCanvas = self:GetSelectionCanvas()
	if (IsValid(pCanvas) and pCanvas:NumSelectedChildren() > 0) then return hook.Run("SpawnlistOpenGenericMenu", pCanvas) end
	self:OpenMenu()
end

function PANEL:OpenMenu()
	local menu = DermaMenu()

	menu:AddOption("Delete", function()
		self:Remove()
		hook.Run("SpawnlistContentChanged", self)
	end)

	menu:Open()
end

vgui.Register("ContentHeader", PANEL, "DLabelEditable")

spawnmenu.AddContentType("header", function(container, obj)
	if (not obj.text or type(obj.text) ~= "string") then return end
	local label = vgui.Create("ContentHeader", container)
	label:SetText(obj.text)
	container:Add(label)
end)