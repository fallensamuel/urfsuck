-- "gamemodes\\rp_base\\gamemode\\main\\menus\\scoreboard\\elements\\scoreboard_list_cl.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local PANEL = {};

function PANEL:GetColumnBounds( id )
    local col = self.m_Columns[id];

    if col then
        local panel = col["panel"];

        if IsValid( panel ) then
            return panel:GetBounds();
        end
    end

    return 0, 0, 0, 0;
end

function PANEL:RowCategoryThink( row )
    local data = row.m_Data;
    local ply = data["player"];

    if rp.Scoreboard.Config.CustomRowCategoryThink then
        return rp.Scoreboard.Config.CustomRowCategoryThink( ply )
    end

    local f = rp.Factions[ply:GetDisguiseFaction() or ply:GetFaction()];
    if f and f.printName then
        return f.printName, f.faction;
    end

    local t = ply:GetJobTable() or {};
    return t.name or "N/A", t.team or -1;
end

function PANEL:Init()
    self.fl_Padding = draw.GetFontHeight( "rpui.Fonts.ScoreboardDefault" ) * 0.5;

    self.m_Columns = {};
    self.m_Categories = {};
    self.m_RenderMatrix = Matrix();

    self.m_Players = {};

    self.fn_PlayerThink = function()
        while true do
            for ply, row in pairs( self.m_Players ) do
                coroutine.yield();

                if IsValid( ply ) then continue end
                row:Remove();
            end

            for k, ply in ipairs( player.GetAll() ) do
                coroutine.yield();

                if IsValid( self.m_Players[ply] ) then
                    continue
                end

                self.m_Players[ply] = self:AddRow( { ["player"] = ply } );
            end

            coroutine.yield();
        end
    end

    hook.Add( "Think", self, function( pnl )
        if not pnl.co_PlayerThink or not coroutine.resume( pnl.co_PlayerThink ) then
            pnl.co_PlayerThink = coroutine.create( pnl.fn_PlayerThink );
            coroutine.resume( pnl.co_PlayerThink );
        end
    end );

    self.Header = self:Add( "Panel" );
    self.Header:Dock( TOP );

    self.Header.PerformLayout = function( this, w, h )
        local gw, gc = self.Content:InnerWidth(), 0;

        for col_id, options in pairs( self.m_Columns ) do
            if options["disabled"] then continue end

            local pnl = options["panel"];
            if not pnl then continue end

            pnl:SetContentAlignment( 4 + (options["align"] or 0) );
            pnl:SetFont( "rpui.Fonts.ScoreboardMedium" );
            pnl:SetText( options["label"] or col_id );

            pnl:SizeToContentsX();
            pnl:SizeToContentsY( 12 );

            if options["grow"] > 0 then
                gc = gc + options["grow"];
            else
                if options["grow"] < -1 then
                    pnl:SetWide( pnl:GetTall() * -(options["grow"] - -2) );
                end

                gw = gw - pnl:GetWide();
            end
        end

        local x = 0;

        gw = gw / gc;

        for k, child in ipairs( this:GetChildren() ) do
            local options = child.m_Options;

            child:SetX( x );

            if options["grow"] > 0 then
                child:SetWide( gw * options["grow"] );
            end

            x = x + child:GetWide();
        end

        this:SizeToChildren( false, true );
    end

    self.Content = self:Add( "rpui.ScoreboardScroll" );
    self.Content:Dock( FILL );

    local vbar = self.Content:GetVerticalBar();
    vbar:DockMargin( self.fl_Padding, 0, 0, 0 );
    vbar:SetWide( self.fl_Padding );

    vbar.PaintGrip = function( this, w, h )
        surface.SetDrawColor( rp.Scoreboard.Config.Colors.White );
        surface.DrawRect( 0, 0, w, h );
    end

    vbar.PaintTrack = function( this, w, h )
        surface.SetDrawColor( rp.Scoreboard.Config.Colors.Background );
        surface.DrawRect( 0, 0, w, h );
    end
end

function PANEL:InvalidateColumns( layoutNow )
    self.Header:InvalidateLayout( layoutNow );
end

function PANEL:AddColumn( id, options )
    local col = self.m_Columns[id] or {};

    if IsValid( col["panel"] ) then
        col["panel"]:Remove();
    end

    col["panel"] = self.Header:Add( "DLabel" );
    col["panel"].m_Options = col;

    col["paint"] = options["paint"];
    col["label"] = options["label"];
    col["align"] = options["align"];
    col["grow"] = options["grow"] or 1;

    self.m_Columns[id] = col;
    self:InvalidateColumns();
end

function PANEL:AddRow( data )
    local row = vgui.Create( "Panel" );
    row:Dock( TOP );
    row:DockMargin( 0, 0, 0, self.fl_Padding );

    row.m_Data = data;
    row.b_Expanded = false;

    row.Paint = function( this, w, h )
        local ply = this.m_Data["player"];
        if not IsValid( ply ) then return end

        local t = this.Header:GetTall();

        surface.SetDrawColor( rp.Scoreboard.Config.Colors.BlackTransparent );
        surface.DrawRect( 0, 0, t, t );

        surface.SetDrawColor( rp.Scoreboard.Utils.ColorAlpha(team.GetColor(ply:GetJob()), 127) );
        surface.DrawRect( t, 0, w - t, t );
        surface.DrawRect( 0, t, w, h - t );
    end

    row.Think = function( this )
        local ply = this.m_Data["player"];

        if not IsValid( ply ) then
            this:Remove();
            return
        end

        local t = SysTime();

        if (this.fl_NextThink or 0) > t then
            return
        end

        this.fl_NextThink = t + (1 / 3);

        local cat_id, cat_order = self:RowCategoryThink( this );

        if this.m_Category ~= cat_id then
            if not IsValid( self.m_Categories[cat_id] ) then
                self.m_Categories[cat_id] = self:AddCategory( cat_id );
                self.m_Categories[cat_id]:SetZPos( cat_order or 0 );
            end

            this.m_Category = cat_id;
            this:SetParent( self.m_Categories[cat_id] );
        end

        this:SetZPos( -(ply:GetJob() * 128 + ply:EntIndex()) );
    end

    row.Header = row:Add( "DButton" );
    row.Header:Dock( TOP );

    row.Header.PerformLayout = function( this, w, h )
        local parent = this:GetParent();
        this:SetTall( self.Header:GetTall() );
        parent:SetTall( this:GetTall() + (parent.b_Expanded and parent.Content:GetTall() or 0) );
    end

    row.Header.Paint = function( this, w, h )
        if this:IsHovered() then
            surface.SetDrawColor( rp.Scoreboard.Config.Colors.BlackOpaque );
            surface.DrawRect( 0, 0, w, h );
        end

        for k, column in ipairs( self.Header:GetChildren() ) do
            local options = column.m_Options or {};

            if options["paint"] then
                local ox, oy = column:GetPos();
                local lw, lh = column:GetWide(), h;

                local lx, ly = this:LocalToScreen( ox, oy );

                render.SetScissorRect( lx, ly, lx + lw, ly + lh, true );
                self.m_RenderMatrix:SetTranslation( Vector(ox, oy) );
                cam.PushModelMatrix( self.m_RenderMatrix, true );
                    local status, err = pcall( options["paint"], this, lw, lh, row.m_Data );
                cam.PopModelMatrix();
                render.SetScissorRect( 0, 0, 0, 0, false );
            end
        end

        local ply = row.m_Data["player"];
        if IsValid( ply ) and ply:HasPremium() then
            surface.SetDrawColor( rp.Scoreboard.Config.Colors.Golden );
            surface.DrawOutlinedRect( 0, 0, w, h, 1 );
        end

        return true;
    end

    row.Header.DoClick = function( this )
        local parent = this:GetParent();
        parent.b_Expanded = not parent.b_Expanded;
        parent:SizeTo(
            -1,
            parent.b_Expanded
                and row.Header:GetTall() + row.Content:GetTall()
                or row.Header:GetTall(),
            0.1
        );
    end

    row.Content = row:Add( "rpui.ScoreboardRow" );
    row.Content:Dock( TOP );
    row.Content:DockPadding( self.fl_Padding, self.fl_Padding, self.fl_Padding, self.fl_Padding );
    row.Content:SetPlayer( data["player"] );

    row.Content.PerformLayout = function( this, w, h )
        this:SizeToChildren( false, true );
    end

    row.Content.Paint = function( this, w, h )
        surface.SetDrawColor( rp.Scoreboard.Config.Colors.BlackTransparent );
        surface.SetMaterial( rp.Scoreboard.Utils.Material("gui/gradient_up") );
        surface.DrawTexturedRect( 0, 0, w, h );
    end

    row.Header:InvalidateLayout( true );
    row:SetTall( row.Header:GetTall() );

    self:OnRowAdded( row );

    return row;
end

function PANEL:OnRowAdded( row )
    self.Content:AddItem( row );
end

function PANEL:AddCategory( name )
    local cat = vgui.Create( "Panel" );
    cat:Dock( TOP );
    cat:DockMargin( 0, 0, 0, self.fl_Padding );
    cat.b_Expanded = true;

    cat.PerformLayout = function( this, w, h )
        if this.b_Expanded then
            if this.m_AnimList then
                local t = SysTime() + RealFrameTime();
                if this:AnimTail() > t then
                    return
                end
            end

            this:SizeToChildren( false, true );
        end
    end

    cat.Header = cat:Add( "DButton" );
    cat.Header:SetFont( "rpui.Fonts.ScoreboardDefault" );
    cat.Header:SetText( name );
    cat.Header:Dock( TOP );

    cat.Header.PerformLayout = function( this, w, h )
        local c = cat.Content.i_ChildrenAmount or 0;

        if not rp.Scoreboard.Config.IsMilitary and c < 4 then
            this:SetTall( 0 );
            this:DockMargin( 0, 0, 0, 0 );
        else
            this:SetTall( self.Header:GetTall() );
            this:DockMargin( 0, 0, 0, self.fl_Padding );
        end
    end

    cat.Header.Paint = function( this, w, h )
        local parent = this:GetParent();

        surface.SetDrawColor( rp.Scoreboard.Config.Colors.Background );
        surface.DrawRect( 0, 0, w, h );

        draw.SimpleText( parent.b_Expanded and "▾" or "▸", this:GetFont(), h * 0.5, h * 0.5, rp.Scoreboard.Config.Colors.White, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
        draw.SimpleText( this:GetText(), this:GetFont(), h, h * 0.5, rp.Scoreboard.Config.Colors.White, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER );

        local cx, cy, cw, ch = self:GetColumnBounds( "team" );
        draw.SimpleText( translates.Get("Игроки: %d", #parent.Content:GetChildren()), this:GetFont(), cx + cw * 0.5, h * 0.5, rp.Scoreboard.Config.Colors.White, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );

        return true;
    end

    cat.Header.DoClick = function( this )
        local parent = this:GetParent();
        parent.b_Expanded = not parent.b_Expanded;
        parent:SizeTo(
            -1,
            parent.b_Expanded
                and cat.Header:GetTall() + cat.Content:GetTall()
                or cat.Header:GetTall(),
            0.1
        );
    end

    cat.Content = cat:Add( "Panel" );
    cat.Content:Dock( TOP );

    cat.Content.i_ChildrenAmount = 0;

    cat.Content.OnChildAdded = function( this, child )
        this.i_ChildrenAmount = this.i_ChildrenAmount + 1;
        this:InvalidateLayout( true );

        cat.Header:InvalidateLayout( true );
    end

    cat.Content.OnChildRemoved = function( this, child )
        this.i_ChildrenAmount = this.i_ChildrenAmount - 1;

        if this.i_ChildrenAmount < 1 then
            this:GetParent():Remove();
            return
        end

        this:InvalidateLayout( true );

        cat.Header:InvalidateLayout( true );
    end

    cat.Content.PerformLayout = function( this, w, h )
        this:SizeToChildren( false, true );
    end

    cat.OnChildAdded = function( this, child )
        child:SetParent( this.Content );
    end

    cat.Header:InvalidateLayout( true );
    cat:SetTall( cat.Header:GetTall() );

    self.Content:AddItem( cat );
    return cat;
end

vgui.Register( "rpui.ScoreboardList", PANEL, "EditablePanel" );