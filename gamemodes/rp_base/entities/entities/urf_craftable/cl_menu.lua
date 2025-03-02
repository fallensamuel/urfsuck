-- "gamemodes\\rp_base\\entities\\entities\\urf_craftable\\cl_menu.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local color_notavailable = Color( 205, 0, 0, 16 );
local color_highlight = rpui.UIColors.Gold;

local mat_fn_BoxHighlight = GWEN.CreateTextureBorder( 0, 0, 96, 96, 64, 64, 64, 64, Material("rpui/gradients/box-small-96.png", "smooth") );

function ENT:OpenMenu()
    if IsValid( self.VGUI ) then self.VGUI:Remove(); end

    local w, h = ScrW(), ScrH();
    local vmin = math.min( w, h );

    surface.CreateFont( "rpui.CraftingTable.Large", {
        font = "Montserrat",
        size = vmin * 0.0215,
        weight = 500,
        extended = true,
    } );

    surface.CreateFont( "rpui.CraftingTable.Default", {
        font = "Montserrat",
        size = vmin * 0.015,
        weight = 400,
        extended = true,
    } );

    self.VGUI = vgui.Create( "urf.im/rpui/menus/blank" );
    self.VGUI:SetSize( h * 0.6, h * 0.75 );
    self.VGUI:Center();
    self.VGUI:MakePopup();

    local p = self.VGUI:GetTall() * 0.025;
    self.VGUI.workspace:DockPadding( p, p, p, p );

    self.VGUI.header:SetIcon( Material("rpui/misc/3d.png", "smooth noclamp") );
    self.VGUI.header:SetTitle( translates.Get("Крафтинг") );
    self.VGUI.header:SetFont( "rpui.playerselect.title" );
    self.VGUI.header.IcoSizeMult = 1.5;

    self.VGUI.Helper = self.VGUI.header:Add( "DButton" );

    local Helper = self.VGUI.Helper;
    Helper:SetFont( "rpui.CraftingTable.Large" );
    Helper:SetText( translates.Get("Где найти ресурсы?") );
    Helper:SizeToContentsX( p * 2 );
    Helper:SizeToContentsY( p * 0.5 );

    Helper.DoClick = function( this )
        self:OnHelpRequest();
        self.VGUI.Interface:Close();
    end

    Helper.Paint = function( this, w, h )
        local baseColor, textColor = rpui.GetPaintStyle( this, STYLE_TRANSPARENT );
        surface.SetDrawColor( baseColor );
        surface.DrawRect( 0, 0, w, h );
        draw.SimpleText( this:GetText(), this:GetFont(), w * 0.5, h * 0.5, textColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
        return true;
    end

    self.VGUI.header.btn.PerformLayout = function( this, w, h )
        local ph = self.VGUI.header:GetTall();
        Helper:SetPos( this:GetX() - (ph - h) - Helper:GetWide(), ph * 0.5 - Helper:GetTall() * 0.5 );
    end

    self.VGUI.Interface = self.VGUI.workspace:Add( "EditablePanel" );
    local Interface = self.VGUI.Interface;

    Interface:Dock( FILL );
    Interface.m_Categories = {};
    Interface.m_Items = {};
    Interface.fl_Padding = draw.GetFontHeight( "rpui.CraftingTable.Large" ) * 0.5;
    Interface.m_Inventory = self:RefreshInventoryItemsCount();

    Interface.Close = function( this )
        this:GetParent():GetParent():Close();
    end

    Interface.CategoriesWrapper = Interface:Add( "Panel" );
    Interface.CategoriesWrapper:Dock( TOP );
    Interface.CategoriesWrapper:SetTall( draw.GetFontHeight("rpui.CraftingTable.Large") + Interface.fl_Padding * 1.5 );
    Interface.CategoriesWrapper:DockMargin( 0, 0, 0, Interface.fl_Padding );
    Interface.CategoriesWrapper:Hide();

    Interface.CategoriesWrapper.Left = Interface.CategoriesWrapper:Add( "DButton" );
    Interface.CategoriesWrapper.Left:Dock( LEFT );
    Interface.CategoriesWrapper.Left:DockMargin( 0, 0, Interface.fl_Padding * 0.5, 0 );
    Interface.CategoriesWrapper.Left:SetFont( "rpui.CraftingTable.Large" );
    Interface.CategoriesWrapper.Left:SetText( "◀" );
    Interface.CategoriesWrapper.Left:SizeToContentsX( Interface.fl_Padding * 1.5 );
    Interface.CategoriesWrapper.Left:Hide();

    Interface.CategoriesWrapper.Left.OnMousePressed = function( this, code )
        this.m_MousePressed = code;
    end

    Interface.CategoriesWrapper.Left.Think = function( this )
        if not this.m_MousePressed then return end

        if not input.IsMouseDown( this.m_MousePressed ) then
            this.m_MousePressed = nil;
            return
        end

        Interface.Categories.fl_ScrollVel = 4;
        Interface.Categories:InvalidateLayout();
    end

    Interface.CategoriesWrapper.Left.Paint = function( this, w, h )
        local baseColor, textColor = rpui.GetPaintStyle( this, STYLE_TRANSPARENT_INVERTED );
        surface.SetDrawColor( baseColor );
        surface.DrawRect( 0, 0, w, h );
        draw.SimpleText( this:GetText(), this:GetFont(), w * 0.5, h * 0.5, textColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
        return true;
    end

    Interface.CategoriesWrapper.Right = Interface.CategoriesWrapper:Add( "DButton" );
    Interface.CategoriesWrapper.Right:Dock( RIGHT );
    Interface.CategoriesWrapper.Right:DockMargin( Interface.fl_Padding * 0.5, 0, 0, 0 );
    Interface.CategoriesWrapper.Right:SetFont( "rpui.CraftingTable.Large" );
    Interface.CategoriesWrapper.Right:SetText( "▶" );
    Interface.CategoriesWrapper.Right:SizeToContentsX( Interface.fl_Padding * 1.5 );
    Interface.CategoriesWrapper.Right:Hide();

    Interface.CategoriesWrapper.Right.OnMousePressed = function( this, code )
        this.m_MousePressed = code;
    end

    Interface.CategoriesWrapper.Right.Think = function( this )
        if not this.m_MousePressed then return end

        if not input.IsMouseDown( this.m_MousePressed ) then
            this.m_MousePressed = nil;
            return
        end

        Interface.Categories.fl_ScrollVel = -4;
        Interface.Categories:InvalidateLayout();
    end

    Interface.CategoriesWrapper.Right.Paint = function( this, w, h )
        local baseColor, textColor = rpui.GetPaintStyle( this, STYLE_TRANSPARENT_INVERTED );
        surface.SetDrawColor( baseColor );
        surface.DrawRect( 0, 0, w, h );
        draw.SimpleText( this:GetText(), this:GetFont(), w * 0.5, h * 0.5, textColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
        return true;
    end

    Interface.Categories = Interface.CategoriesWrapper:Add( "Panel" );
    Interface.Categories:Dock( FILL );

    Interface.Categories.OnMouseWheeled = function( this, dt )
        this.fl_ScrollVel = (this.fl_ScrollVel or 0) + dt * 2;
        this:InvalidateLayout();
    end

    Interface.Categories.Think = function( this )
        if math.abs(this.fl_ScrollVel or 0) > 0.01 then
            this:InvalidateLayout();
        end
    end

    Interface.Categories.PerformLayout = function( this, w, h )
        this.Canvas:SetTall( h );

        local canvas = this.Canvas;
        local cw, scroll = canvas:GetWide(), this.fl_Scroll or 0;

        local wrapper = Interface.CategoriesWrapper;
        local lb, rb = wrapper.Left, wrapper.Right;

        canvas:SetX( scroll );

        local lb_w = lb:GetWide() + select( 3, lb:GetDockMargin() );
        local rb_w = rb:GetWide() + select( 1, rb:GetDockMargin() );

        if cw > w then
            local scroll_vel = this.fl_ScrollVel or 0;

            this.fl_Scroll = scroll + scroll_vel;
            this.fl_ScrollVel = Lerp( RealFrameTime() * 6, scroll_vel, 0 );

            if not this.b_LeftArrow then
                this.b_LeftArrow = true;
            end

            if not this.b_RightArrow then
                this.b_RightArrow = true;
            end

            if this.fl_Scroll >= (lb:IsVisible() and -lb_w or 0) then
                this.fl_Scroll, this.fl_ScrollVel = 0, 0;
                this.b_LeftArrow = nil;
            elseif (this.fl_Scroll + cw) <= (rb:IsVisible() and w + rb_w or w) then
                this.fl_Scroll, this.fl_ScrollVel = w - cw, 0;
                this.b_RightArrow = nil;
            end
        else
            this.fl_ScrollVel = 0;
        end

        if lb:IsVisible() then
            if not this.b_LeftArrow then
                lb.m_MousePressed = nil;
                lb:Hide();
                wrapper:InvalidateLayout( true );
                this:InvalidateLayout( true );
            end
        else
            if this.b_LeftArrow then
                lb:Show();
                wrapper:InvalidateLayout( true );
                this.fl_Scroll = this.fl_Scroll - lb_w;
                this:InvalidateLayout( true );
            end
        end

        if rb:IsVisible() then
            if not this.b_RightArrow then
                rb.m_MousePressed = nil;
                rb:Hide();
                wrapper:InvalidateLayout( true );
                this.fl_Scroll = this.fl_Scroll + rb_w;
                this:InvalidateLayout( true );
            end
        else
            if this.b_RightArrow then
                rb:Show();
                wrapper:InvalidateLayout( true );
                this:InvalidateLayout( true );
            end
        end
    end

    Interface.Categories.Canvas = Interface.Categories:Add( "Panel" );

    Interface.Categories.Canvas.PerformLayout = function( this, w, h )
        local cw = 0;
        local childrens = this:GetChildren();
        local len = #childrens;

        for k, child in ipairs( childrens ) do
            child:SetX( cw );
            child:SetTall( h );

            cw = cw + child:GetWide();

            if k < len then
                cw = cw + Interface.fl_Padding * 0.5;
            end
        end

        this:SetWide( cw );

        local pw = this:GetParent():GetWide();
        if cw < pw then
            local add = (pw - cw) / len;

            for k, child in ipairs( childrens ) do
                child:SetWide( child:GetWide() + add );
            end
        end
    end

    Interface.Scroll = Interface:Add( "rpui.ScoreboardScroll" );
    Interface.Scroll:Dock( FILL );
    Interface.Scroll.m_VerticalBar:SetWide( Interface.fl_Padding * 0.75 );
    Interface.Scroll.m_VerticalBar:DockMargin( Interface.fl_Padding, 0, 0, 0 );

    Interface.Scroll.m_VerticalBar.PaintTrack = function( this, w, h )
        surface.SetDrawColor( rpui.UIColors.Hovered );
        surface.DrawRect( 0, 0, w, h );
    end

    Interface.Scroll.m_VerticalBar.PaintGrip = function( this, w, h )
        surface.SetDrawColor( color_white );
        surface.DrawRect( 0, 0, w, h );
    end

    Interface.GetCategories = function( this )
        return this.m_Categories or {};
    end

    Interface.GetSelectedCategories = function( this )
        local out = {};

        for name, btn in pairs( this:GetCategories() ) do
            if not btn.Selected then continue end
            out[name] = true;
        end

        return out;
    end

    Interface.HasCategory = function( this, name )
        return tobool( this:GetCategories()[name] );
    end

    Interface.AddCategory = function( this, name )
        this.m_Categories[name] = this.Categories.Canvas:Add( "DButton" );

        local category = this.m_Categories[name];

        category:SetFont( "rpui.CraftingTable.Large" );
        category:SetText( name );
        category:SizeToContentsX( this.fl_Padding * 4 );

        category.DoClick = function( cat )
            cat.Selected = not cat.Selected;
            this:InvalidateItems();
        end

        category.Paint = function( cat, w, h )
            local baseColor, textColor = rpui.GetPaintStyle( cat, STYLE_TRANSPARENT_SELECTABLE );
            surface.SetDrawColor( baseColor );
            surface.DrawRect( 0, 0, w, h );
            draw.SimpleText( cat:GetText(), cat:GetFont(), w * 0.5, h * 0.5, textColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
            return true;
        end

        if not this.CategoriesWrapper:IsVisible() and table.Count( this.m_Categories ) > 1 then
            this.CategoriesWrapper:Show();
        end
    end

    Interface.GetItems = function( this )
        return this.Scroll:GetCanvas():GetChildren();
    end

    Interface.AddItem = function( this, data )
        data = data or {};

        if self.CustomID and not data.customID then
            return
        end

        if data.customID and (data.customID ~= (self.CustomID or "")) then
            return
        end

        local name = data.printname or data.result or "?";
        local cat = data.category or translates.Get( "Разное" );
        if cat and not this:HasCategory( cat ) then this:AddCategory( cat ); end

        local item = this.Scroll:Add( "DButton" );
        item.m_Data = data;
        item.m_Category = cat;

        item:Dock( TOP );
        item:DockMargin( 0, 0, 0, this.fl_Padding * 0.75 );

        item.DoClick = function( pnl )
            net.Start( "ent_craftingtable" );
                net.WriteEntity( self );
                net.WriteUInt( self.Enums.USE, 2 );
                net.WriteUInt( data.index, 7 );
            net.SendToServer();

            if pnl.b_Craftable then
                this:Close();
            end
        end

        item.IsHovered = function( pnl )
            return DPanel.IsHovered( pnl ) or pnl:IsChildHovered();
        end

        item.Paint = function( pnl, w, h )
            local baseColor = color_notavailable;

            if item.b_Crafting or item.b_Craftable then
                baseColor = rpui.GetPaintStyle( pnl, STYLE_TRANSPARENT_SELECTABLE );
            end

            surface.SetDrawColor( baseColor );
            surface.DrawRect( 0, 0, w, h );

            return true;
        end

        item.PaintOver = function( pnl, w, h )
            if not pnl.b_Highlighted then
                return
            end

            local t = SysTime();
            local num = isnumber( pnl.b_Highlighted );

            if not num and pnl:IsHovered() then
                pnl.b_Highlighted = t + 0.45;
            end

            local dt = 1;

            if num then
                dt = (pnl.b_Highlighted - t) / 0.45;

                if dt < 0 then
                    pnl.b_Highlighted = nil;
                    return
                end
            end

            mat_fn_BoxHighlight( 0, 0, w, h, ColorAlpha(color_highlight, (127 + math.sin(t * 4) * 127) * dt) );
        end

        item.PerformLayout = function( pnl, w, h )
            pnl:SetTall( pnl.Icon:GetWide() );
        end

        item.Icon = item:Add( "Panel" );
        item.Icon:Dock( LEFT );
        item.Icon:SetWide( this.fl_Padding * 10 );
        item.Icon:SetCursor( "hand" );
        item.Icon:SetInventoryTooltip( data.result );
        item.Icon.OnTooltipInit = function( pnl, tooltip )
            tooltip:SetItem( data.result );

            tooltip.PositionTooltip = function( t )
                local target = t.TargetPanel;
                if not IsValid( target ) then t:Close(); return end
                local x, y = input.GetCursorPos();
                local lx, ly = target:LocalToScreen();
                t:SetPos( lx + target:GetWide() + this.fl_Padding * 0.5, y - t:GetTall() * 0.5 );
            end
        end

        item.Icon.PerformLayout = function( pnl, w, h )
            local vmin = math.min( w, h ) * 0.75;
            pnl.Texture:SetPos( w * 0.5 - vmin * 0.5, h * 0.5 - vmin * 0.5 );
            pnl.Texture:SetSize( vmin, vmin );
        end

        item.Icon.Paint = function( pnl, w, h )
            surface.SetDrawColor( color_black );
            surface.DrawRect( 0, 0, w, h );
        end

        item.Icon.Texture = item.Icon:Add( "SpawnIcon" );
        item.Icon.Texture:SetModel( data.model or "models/error.mdl" );
        item.Icon.Texture:SetMouseInputEnabled( false );

        item.Content = item:Add( "Panel" );
        item.Content:Dock( FILL );
        item.Content:DockPadding( this.fl_Padding, this.fl_Padding, this.fl_Padding, this.fl_Padding );
        item.Content:SetCursor( "hand" );

        item.Content.Label = item.Content:Add( "DLabel" );
        item.Content.Label:Dock( TOP );
        item.Content.Label:DockMargin( 0, 0, 0, this.fl_Padding );
        item.Content.Label:SetTextColor( rpui.UIColors.White );
        item.Content.Label:SetFont( "rpui.CraftingTable.Large" );
        item.Content.Label:SetText( name );
        item.Content.Label:SizeToContentsY();
        item.Content.Label:SetMouseInputEnabled( false );

        item.Content.Requirement = item.Content:Add( "Panel" );
        item.Content.Requirement:Dock( FILL );
        item.Content.Requirement:DockPadding( this.fl_Padding * 0.5, this.fl_Padding * 0.5, this.fl_Padding * 0.5, this.fl_Padding * 0.5 );
        item.Content.Requirement.b_BlockClick = true;

        item.Content.Requirement.Paint = function( pnl, w, h )
            surface.SetDrawColor( Color(255, 255, 255, 6) );
            surface.DrawRect( 0, 0, w, h );
        end

        item.Content.Requirement.Tip = item.Content.Requirement:Add( "DLabel" );
        item.Content.Requirement.Tip:Dock( LEFT );
        item.Content.Requirement.Tip:SetTextColor( rpui.UIColors.White );
        item.Content.Requirement.Tip:SetFont( "rpui.CraftingTable.Default" );
        item.Content.Requirement.Tip:SetText( translates.Get("Необходимые\nматериалы:") );
        item.Content.Requirement.Tip:SizeToContentsX();

        item.Content.Requirement.Items = item.Content.Requirement:Add( "Panel" );
        item.Content.Requirement.Items:Dock( FILL );
        item.Content.Requirement.Items.b_BlockClick = true;

        item.Content.Requirement.Items.PerformLayout = function( pnl, w, h )
            local x, cw = 0, w / 5;

            for k, child in ipairs( pnl:GetChildren() ) do
                child:SetPos( x, 0 ); child:SetSize( cw, h );
                x = x + cw;
            end
        end

        for k, recipe in ipairs( data.recipe or {} ) do
            local req = item.Content.Requirement.Items:Add( "DButton" );
            req:SetTooltip( (rp.item.list[recipe.uid] or {}).name or "?" );
            req.b_BlockClick = true;

            req.Icon = req:Add( "SpawnIcon" );
            req.Icon:SetModel( recipe.mdl );
            req.Icon:SetMouseInputEnabled( false );
            req.Icon:SetPaintedManually( true );

            req.DoClick = function( pnl )
                self:OnHelpRequest( data, k );
            end

            req.PerformLayout = function( pnl, w, h )
                local vmin = math.min( w, h );
                vmin = vmin - draw.GetFontHeight( "rpui.CraftingTable.Default" );

                pnl.Icon:SetPos( w * 0.5 - vmin * 0.5, 0 );
                pnl.Icon:SetSize( vmin, vmin );
            end

            req.Paint = function( pnl, w, h )
                local has, need = this.m_Inventory[recipe.uid] or 0, recipe.count;
                local available = (has >= need);

                local surf_alpha = surface.GetAlphaMultiplier();
                surface.SetAlphaMultiplier( surf_alpha * (available and 1 or 0.35) );
                    pnl.Icon:PaintManual();
                surface.SetAlphaMultiplier( surf_alpha );

                local textColor = available and color_white or Color(255, 125, 125);
                draw.SimpleText( translates.Get("%i из %i", has, need), "rpui.CraftingTable.Default", w * 0.5, h, textColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM );

                return true;
            end
        end
    end

    Interface.InvalidateItems = function( this )
        local selected = this:GetSelectedCategories();
        local all = next( selected ) == nil;

        local craftcache = self:GetCraftCache();

        for k, item in ipairs( this:GetItems() ) do
            local data = item.m_Data;
            local cache = craftcache[data.index];

            item.b_Crafting = cache and (cache.completed or tobool(cache.ts)) or false;
            item.b_Craftable = true;

            for k, recipe in ipairs( data.recipe ) do
                if (this.m_Inventory[recipe.uid] or 0) < recipe.count then
                    item.b_Craftable = false;
                    break
                end
            end

            item:SetZPos( data.index + ((item.b_Crafting or item.b_Craftable) and -1 or 0) * 255 );

            item[(all or selected[item.m_Category]) and "Show" or "Hide"]( item );
        end

        this.Scroll:InvalidateChildren( true );
    end

    for k, data in pairs( rp.CraftTableItems or {} ) do
        Interface:AddItem( data );
    end

    Interface:InvalidateItems();

    hook.Add( "VGUIMousePressed", "CraftingTable::MouseOverride", function( target, code )
        if code ~= MOUSE_FIRST then return end

        local pnl = Interface;
        if not IsValid( pnl ) then
            hook.Remove( "VGUIMousePressed", "CraftingTable::MouseOverride" );
            return
        end

        if target.b_BlockClick then return end
        if not pnl:HasChildren( target ) then return end

        local item = target;

        repeat
            item = item:GetParent();
        until not IsValid( item ) or item.m_Data;

        if IsValid( item ) and item.DoClick then
            item:DoClick();
        end
    end );

    hook.Add( "CraftingTable::InfoUpdate", "CraftingTable::InfoUpdate", function()
        local pnl = Interface;
        if not IsValid( pnl ) then
            hook.Remove( "CraftingTable::InfoUpdate", "CraftingTable::InfoUpdate" );
            return
        end

        pnl.m_Inventory = self:RefreshInventoryItemsCount();
        pnl:InvalidateItems();
    end );
end