-- "gamemodes\\rp_base\\entities\\entities\\urf_craftable\\cl_help.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
ENT.fl_HelpMinDistance = math.pow( 250, 2 );
ENT.fl_HelpFadeDistance = math.pow( 250, 2 );

ENT.m_HelpIconMaterial = Material( "bubble_hints/hints/item.png", "smooth" );
ENT.m_HelpHaloColor = Color( 128, 210, 35 );

function ENT:OnHelpRequest( data, idx )
    if not data then
        net.Start( "ent_craftingtable" );
            net.WriteEntity( self );
            net.WriteUInt( self.Enums.HELP, 2 );
            net.WriteUInt( 0, 7 );
        net.SendToServer();

        return
    end

    local recipe = data.recipe[idx];
    if not recipe then return end

    local uid = recipe.uid;
    local lut_uid = { [uid] = true };

    local valid_ui = IsValid( self.VGUI );
    if valid_ui then
        local passed, interface = false, self.VGUI.Interface;

        for k, item in ipairs( interface:GetItems() ) do
            item.b_Highlighted = nil;

            if passed then
                continue
            end

            local data = item.m_Data;

            if not lut_uid[data.result] then continue end
            passed = true;

            for name, btn in pairs( interface:GetCategories() ) do btn.Selected = nil; end
            interface:InvalidateItems();

            item.b_Highlighted = true;

            local tall = interface.Scroll:GetTall();
            local canvas = interface.Scroll:GetCanvas()
            local diff = canvas:GetY() + item:GetY();

            if diff < 0 then
                canvas:SetY( -item:GetY() );
                continue
            end

            if diff > tall then
                canvas:SetY( (-item:GetY() - item:GetTall()) + tall );
                continue
            end
        end

        if passed then return end
    end

    if valid_ui then
        self.VGUI:Close();
    end

    local item = rp.item.list[uid];
    if not item then return end

    if rp.item.recipes[item.name] then
        GAMEMODE:ShowSpare2();

        timer.Simple( RealFrameTime() * 5, function()
            local m = rp.F4MenuPanel;
            if not IsValid( m ) then return end

            local c = rp.gui.RecipesPnl;
            if not IsValid( c ) then return end

            for k, craft in ipairs( c:GetChildren() ) do
                if not lut_uid[craft.Recipe.result.uniqueID] then continue end
                craft:DoClick();
            end

            local tabname = string.utf8upper( string.Trim(translates.Get("Крафтинг")) ); -- it is what it is
            local tabbutton = m.Sidebar.Tabs[tabname];

            if IsValid( tabbutton ) then
                tabbutton:DoClick();
            end
        end );

        return
    end

    net.Start( "ent_craftingtable" );
        net.WriteEntity( self );
        net.WriteUInt( self.Enums.HELP, 2 );
        net.WriteUInt( data.index, 7 );
        net.WriteUInt( idx, 5 );
    net.SendToServer();
end

function ENT:OnLootablesReceived( lootables )
    self.fl_HelpReset = SysTime() + 60 * 1;

    hook.Add( "HUDPaint", self, function( ent )
        local t, ply = SysTime(), LocalPlayer();

        if (ent.fl_HelpReset or 0) < t or not ply:Alive() then
            hook.Remove( "HUDPaint", self );
            hook.Remove( "PreDrawHalos", self );
            return
        end

        local origin = ply:GetPos();

        for k, lootable in ipairs( lootables ) do
            local e, v = lootable[1], lootable[2];

            if not IsEntity( e ) then
                local ent = Entity( e );

                if IsValid( ent ) then
                    lootable[1] = ent;
                end
            end

            local screen = v:ToScreen();

            local dist = v:DistToSqr( origin );
            if dist < ent.fl_HelpMinDistance then
                table.remove( lootables, k );
                continue
            end

            local alpha = math.min( (dist - ent.fl_HelpMinDistance) / ent.fl_HelpFadeDistance, 1 ) * 255;
            rp.DrawInfoBubble( alpha, ent.m_HelpIconMaterial, nil, nil, color_white, nil, nil, nil, screen, nil, nil, true, true );
        end

        if #lootables < 1 then
            hook.Remove( "HUDPaint", self );
            hook.Remove( "PreDrawHalos", self );
        end
    end );

    hook.Add( "PreDrawHalos", self, function()
        local halos = {};

        for k, lootable in ipairs( lootables ) do
            local ent = lootable[1];
            if not IsEntity( ent ) then continue end
            halos[#halos + 1] = ent;
        end

        halo.Add( halos, self.m_HelpHaloColor, 2, 2, 1, 1, true, true );
    end );
end