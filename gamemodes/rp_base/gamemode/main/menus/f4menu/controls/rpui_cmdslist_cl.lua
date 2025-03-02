-- "gamemodes\\rp_base\\gamemode\\main\\menus\\f4menu\\controls\\rpui_cmdslist_cl.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal

local PANEL = {};

function PANEL:RebuildFonts( frameW, frameH )
    surface.CreateFont( "rpui.Fonts.CommandsList.CategoryTitle", {
        font     = "Montserrat",
        extended = true,
        weight = 600,
        size     = frameH * 0.035,
    } );

    surface.CreateFont( "rpui.Fonts.CommandsList.CmdButton", {
        font     = "Montserrat",
        extended = true,
        weight = 500,
        size     = frameH * 0.02,
    } );
end

local CustomCats = {
	[rp.cfg.MenuCategoryMayor] = true,
	[rp.cfg.MenuCategoryPolice] = true,
	[rp.cfg.MenuCategoryMoney] = true,
	[rp.cfg.MenuCategoryActions] = true,
	[rp.cfg.MenuCategoryRoleplay] = true,
}

function PANEL:Init()
    self.Parent              = self:GetParent();
    self.frameW, self.frameH = self.Parent.GetSize(self.Parent);

    self:Dock( FILL );
    self:SetScrollbarWidth( self.frameH * 0.0085 );

    self:RebuildFonts( self.frameW, self.frameH );

    self.Container = vgui.Create( "rpui.ColumnView" );
	local cont = self.Container;
	
    cont:Dock( TOP );
    cont:SetColumns( 2 );
    self:AddItem( cont );

    self.AllowedCats = {};

    self.AllowedCats[rp.cfg.MenuCategoryMoney]    = true;
	self.AllowedCats[rp.cfg.MenuCategoryActions]  = true;
	self.AllowedCats[rp.cfg.MenuCategoryRoleplay] = true;

	if LocalPlayer():IsMayor() then
		self.AllowedCats[rp.cfg.MenuCategoryMayor] = true;
	end

	if LocalPlayer():IsCP() or LocalPlayer():IsMayor() then
		self.AllowedCats[rp.cfg.MenuCategoryPolice] = true;
	end

	local can_draw_cat
    for cat, cmds in pairs( getcmds() ) do
		can_draw_cat = false
		
		if not CustomCats[cat] then
			for _, cmd in pairs( cmds ) do
				if cmd.custom() then
					can_draw_cat = true
					break
				end
			end
		end
		
        if not self.AllowedCats[cat] and not can_draw_cat then continue end

        local CategoryPnl = vgui.Create( "Panel" );
        CategoryPnl:Dock( TOP );

        CategoryPnl.Title = vgui.Create( "DLabel", CategoryPnl );
		local title = CategoryPnl.Title;
		
        title:Dock( TOP );
        title:SetTall( self.frameH * 0.065 );
        title:SetContentAlignment( 5 );
        title:SetFont( "rpui.Fonts.CommandsList.CategoryTitle" );
        title:SetTextColor( rpui.UIColors.White );
        title:SetText( string.utf8upper(cat) );
        title.Paint = function( this, w, h )
            surface.SetDrawColor( rp.cfg.UIColor and rp.cfg.UIColor.BlockHeader or rpui.UIColors.Black );
            surface.DrawRect( 0, 0, w, h );
        end

        CategoryPnl.Container = vgui.Create( "rpui.ColumnView", CategoryPnl );
		local container = CategoryPnl.Container;
		
        container:Dock( TOP );
        container:SetColumns( 2 );
        
        for _, cmd in pairs( cmds ) do
            if not cmd.custom() then continue end

			local id = util.CRC(string.utf8lower(cmd.name))
			id = rp.cfg.CommandIconReplacement and rp.cfg.CommandIconReplacement[id] or id
			
            local CmdButton = vgui.Create( "DButton" );
            CmdButton:Dock( TOP );
            CmdButton:SetTall( self.frameH * 0.065 );
            CmdButton:SetFont( "rpui.Fonts.CommandsList.CmdButton" );
            CmdButton:SetText( string.utf8upper(cmd.name) );

            if cmd.icon then
                CmdButton.Material = Material( cmd.icon );

                if CmdButton.Material:IsError() then -- first pass:
                    CmdButton.Material = Material( "rpui/commands/" .. cmd.icon );
                end

                if CmdButton.Material:IsError() then -- replacement pass:
                    local rid = rp.cfg.CommandIconReplacement and rp.cfg.CommandIconReplacement[cmd.icon] or cmd.icon;
                    CmdButton.Material = Material( "rpui/commands/" .. rid );
                end
            end

            if CmdButton.Material then
                if CmdButton.Material:IsError() then
                    CmdButton.Material = Material( "rpui/commands/" .. id );
                end
            else
                CmdButton.Material = Material( "rpui/commands/" .. id );
            end

			--print(cmd.name, "rpui/commands/" .. util.CRC(string.utf8lower(cmd.name)))
            CmdButton.IconSize = 0.65;
            CmdButton.Padding = self.frameW * 0.005;
            CmdButton.Paint = function( this, w, h )
                if not this.BakedText then
                    this.BakedText, this.BakedTextHeight = rpui.BakeText( this:GetText(), this:GetFont(), w - h - this.Padding * 3, h );
                end

                local baseColor, textColor = rpui.GetPaintStyle( this, STYLE_TRANSPARENT );
                surface.SetDrawColor( baseColor );
                surface.DrawRect( 0, 0, w, h );

                surface.SetDrawColor( rpui.UIColors.White );
                surface.DrawRect( 0, 0, h, h );

                if this.Material then
                    surface.SetMaterial( this.Material );
                    surface.SetDrawColor( rpui.UIColors.Black );
                    local offset = (h - h * CmdButton.IconSize) * 0.5;
                    surface.DrawTexturedRect( offset, offset, h * CmdButton.IconSize, h * CmdButton.IconSize );
                end

                for k, v in pairs( this.BakedText ) do
                    draw.SimpleText( v.text, this:GetFont(), v.x + h + this.Padding, rpui.PowOfTwo((h * 0.5 - this.BakedTextHeight * 0.5) + v.y), textColor );
                end

                return true;
            end
            CmdButton.DoClick = isstring(cmd.cback) and function()
                rp.RunCommand(cmd.cback);
            end or cmd.cback;
            
            container:AddItem( CmdButton );
            CmdButton:InvalidateParent( true );
        end

        CategoryPnl:InvalidateLayout( true );
        CategoryPnl:SizeToChildren( false, true );

        cont:AddItem( CategoryPnl );
    end

    cont:InvalidateParent( true );
    cont:PerformLayout();
end


function PANEL:SetSpacing( spacing )
	local cont = self.Container;
    cont:SetSpacingX( spacing );
    cont:SetSpacingY( spacing );
    self:SetScrollbarMargin( spacing * 0.8 );

    for _, column in pairs( cont:GetChildren() ) do
        for _, CategoryPnl in pairs( column:GetChildren() ) do
            CategoryPnl.Title.DockMargin( CategoryPnl.Title, 0, 0, 0, spacing );

            CategoryPnl.Container.SetSpacingX( CategoryPnl.Container, spacing );
            CategoryPnl.Container.SetSpacingY( CategoryPnl.Container, spacing );

            CategoryPnl:InvalidateLayout( true );
            CategoryPnl:SizeToChildren( false, true );
        end
    end
end


vgui.Register( "rpui.CommandsList", PANEL, "rpui.ScrollPanel" );
