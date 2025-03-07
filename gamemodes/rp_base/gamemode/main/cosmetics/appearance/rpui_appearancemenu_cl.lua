-- "gamemodes\\rp_base\\gamemode\\main\\cosmetics\\appearance\\rpui_appearancemenu_cl.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local PANEL = {}

function PANEL:Init()
	self:Dock( FILL );
	self:InvalidateParent( true );

	self.DAppearancePanel = vgui.Create( "DAppearancePanel", self );

	self.DAppearancePanel:SetJobData( rp.teams[LocalPlayer():Team()] );
	self.DAppearancePanel:SetAppearanceData( rp.teams[LocalPlayer():Team()].appearance );

	self.DAppearancePanel.ControlPanel.Content.ModelSelector.Panels[1]:DoClick();
end

vgui.Register( "rp_appearancemenu", PANEL, "Panel" );