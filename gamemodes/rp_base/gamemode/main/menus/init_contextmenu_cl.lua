-- "gamemodes\\rp_base\\gamemode\\main\\menus\\init_contextmenu_cl.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal

if rp.cfg.DisableContextRedisign then return end

rp.ContextMenu = rp.ContextMenu or {
    Panels = {}
};

rp.ContextMenu.Categories = {};


rp.AddContextCategory = function( category, check )
    if rp.ContextMenu.Categories[category] then return end

    check = isfunction(check) and check or function() return true end

    rp.ContextMenu.Categories[category] = {
        Commands = {},
        Check    = check,
    };

    return rp.ContextMenu.Categories[category];
end


rp.AddContextCommand = function( category, name, func, check, icon )    
    if not rp.ContextMenu.Categories[category] then
        rp.AddContextCategory( category );
    end

    check = isfunction(check) and check or function() return true end

    table.insert( rp.ContextMenu.Categories[category].Commands, {
        Name   = name,
        Action = func,
        Check  = check,
		Icon   = icon and Material(icon)
    } );
end


rp.AddContextCommandGroup = function( category, name, func, check, icon )
    if not rp.ContextMenu.Categories[category] then
        local cat = rp.AddContextCategory( category );
        cat.IsGroup = true;
    end

    check = isfunction(check) and check or function() return true end
    
    table.insert( rp.ContextMenu.Categories[category].Commands, {
        Name   = name,
        Action = func,
        Check  = check,
		Icon   = icon and Material(icon)
    } );
end


rp.FlushContextCategory = function( category )
    if rp.ContextMenu.Categories[category] then
        rp.ContextMenu.Categories[category] = nil;
    end
end


rp.OpenContextMenu = function( forced )
    if forced then
        g_ContextMenu.Forced = true;
        g_ContextMenu:SetHangOpen( true );
        hook.Run( "OnContextMenuOpen" );
    end

    if g_ContextMenu.Forced then
        g_ContextMenu:SetMouseInputEnabled( true );
    end
end


rp.CloseContextMenu = function( forced )
    if forced then
        g_ContextMenu.Forced = false;
        hook.Run( "OnContextMenuClose" );
    end

    g_ContextMenu:SetHangOpen( g_ContextMenu.Forced );    
    g_ContextMenu:SetMouseInputEnabled( false );
end


rp.RefreshContextMenu = function()
	if not (IsValid(LocalPlayer()) and LocalPlayer():GetJobTable()) then return end
    hook.Run( "RefreshContextMenu" );
end


rp.RefreshContextCommands = function()
    local frameW, frameH = ScrW(), ScrH();
    local frameSpacing   = frameH * 0.01;
    local cmdMinWidth    = frameW * 0.085;
	
    surface.CreateFont( "CommandCategory", {
        font     = "Montserrat",
        size     = math.max(math.ceil(frameH * 0.015), 13),
        extended = true,
    } );

    surface.CreateFont( "CommandButton", {
        font     = "Montserrat",
        size     = frameH * 0.02,
        extended = true,
    } );

    rp.ContextMenu.Panels.CommandsView:SetCategoryTitleFont( "CommandCategory" );
    rp.ContextMenu.Panels.CommandsView.PaintCategoryTitle = function( this, w, h )
        local x, y = this:GetTextInset();
        draw.SimpleTextOutlined( this:GetText(), this:GetFont(), x, y, rpui.UIColors.White, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color(0,0,0,128) );
        return true
    end

    rp.ContextMenu.Panels.CommandsView:DockMargin( frameW * 0.3, 0, frameW * 0.3, frameSpacing * 3 );
    rp.ContextMenu.Panels.CommandsView:InvalidateParent( true );

    rp.ContextMenu.Panels.CommandsView:SetSpacingX( frameSpacing );
    rp.ContextMenu.Panels.CommandsView:SetSpacingY( frameSpacing );

    rp.ContextMenu.Panels.CommandsView:Clear();

    for cat, category in pairs( rp.ContextMenu.Categories ) do
        if not category.Check() then continue end
        if category.IsGroup     then continue end

        for _, cmd in ipairs( category.Commands ) do
            if not cmd.Check() then continue end

            local CommandButton = vgui.Create( "DButton" );

            CommandButton:SetFont( "CommandButton" );
            CommandButton:SetText( string.utf8upper(cmd.Name) );

            CommandButton:SizeToContentsY( frameSpacing );
            CommandButton:SizeToContentsX( CommandButton:GetTall() + frameSpacing * 2 );
            CommandButton:SetWide( math.max( CommandButton:GetWide(), cmdMinWidth ) );

            CommandButton.Paint = function( this, w, h )
                if not cmd.Check() then
                    this:Remove();

                    timer.Simple( RealFrameTime(), function()
                        if not IsValid(rp.ContextMenu.Panels.CommandsView) then return end
                        rp.ContextMenu.Panels.CommandsView:RebuildRowLayout();
                    end );
                end

                local baseColor, textColor = rpui.GetPaintStyle( this, STYLE_SOLID );
                surface.SetDrawColor( rp.cfg.UIColor.SubHeader );
                surface.DrawRect( 0, 0, w, h );

				surface.SetDrawColor( rp.cfg.UIColor.BlockHeader );
				surface.DrawRect( 0, 0, h, h );
				
				if cmd.Icon then
					surface.SetDrawColor( rpui.UIColors.White );
					surface.SetMaterial(cmd.Icon)
					surface.DrawTexturedRect( h * 0.1, h * 0.1, h * 0.8, h * 0.8 );
				end
				
                surface.SetDrawColor( Color(0,0,0,this._grayscale or 0) );
                local p = h * 0.1;
                surface.DrawLine( h, p, h, h - p );

                draw.SimpleText( this:GetText(), this:GetFont(), h + (w-h) * 0.5, h * 0.5, rpui.UIColors.Black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
                return true
            end

            CommandButton.PerformLayout = function( this )
                this:SizeToContentsY( frameSpacing );
                this:SizeToContentsX( this:GetTall() + frameSpacing * 2 );
                this:SetWide( math.max( this:GetWide(), cmdMinWidth ) );
            end

            CommandButton.DoClick = cmd.Action;

            rp.ContextMenu.Panels.CommandsView:AddItem( CommandButton, string.utf8upper(cat) );
        end
    end
end


hook.Add( "PopulateContextMenu", "InventoryContext_Populate", function( gContextMenu )
    rp.ContextMenu.Panels.InventoryMenu = vgui.Create( "DPanel", gContextMenu );
    rp.ContextMenu.Panels.InventoryMenu.Paint = function( this, w, h )
		draw.Blur( this );
		surface.SetDrawColor( rpui.UIColors.Background ); // rpui.UIColors.Background
		surface.DrawRect( 0, 0, w, h );
    end

    rp.ContextMenu.Panels.InventoryMenu.Title = vgui.Create( "DLabel", rp.ContextMenu.Panels.InventoryMenu );
	rp.ContextMenu.Panels.InventoryMenu.Title:Dock( TOP );
	rp.ContextMenu.Panels.InventoryMenu.Title:InvalidateParent( true );
	rp.ContextMenu.Panels.InventoryMenu.Title:SetText( translates.Get("ИНВЕНТАРЬ") );
	rp.ContextMenu.Panels.InventoryMenu.Title.Paint = function( this, w, h )
		surface.SetDrawColor(rp.cfg.UIColor.BlockHeader or rp.cfg.UIColor.SubHeader);
		surface.DrawRect( 0, 0, w, h );
		draw.SimpleText( this:GetText(), this:GetFont(), w * 0.5, h * 0.5, rp.cfg.UIColor.BlockHeaderInverted or rpui.UIColors.Black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
		return true
    end

    rp.ContextMenu.Panels.InventoryMenu.Content = vgui.Create( "rpui.ScrollPanel", rp.ContextMenu.Panels.InventoryMenu );

    hook.Run( "PopulateContextMenuAdditionals", gContextMenu );
end );


hook.Add( "RefreshContextMenu", "InventoryContext_Refresh", function()
    local frameH       = ScrH() * 0.5;
    local frameSpacing = frameH * 0.01;

    surface.CreateFont( "InventoryContext.Title", {
		font = "Montserrat",
        size = ScrH() * 0.025,
        weight = 800,
		extended = true,
    } );
    
    rp.ContextMenu.Panels.InventoryMenu.Title:Dock( NODOCK );
    rp.ContextMenu.Panels.InventoryMenu.Title:SetFont( "InventoryContext.Title" );
    rp.ContextMenu.Panels.InventoryMenu.Title:SizeToContentsX( frameSpacing * 2 );
    rp.ContextMenu.Panels.InventoryMenu.Title:SizeToContentsY( frameSpacing * 6 );
    rp.ContextMenu.Panels.InventoryMenu.Title:InvalidateLayout( true );

    rp.ContextMenu.Panels.InventoryMenu.Content:Dock( NODOCK );
    
    if IsValid( rp.ContextMenu.Panels.InventoryMenu.PlayerInventory ) then
        rp.ContextMenu.Panels.InventoryMenu.PlayerInventory:Remove();
    end

    rp.ContextMenu.Panels.InventoryMenu.PlayerInventory = vgui.Create( "rpui.Inventory" );
    rp.ContextMenu.Panels.InventoryMenu.PlayerInventory.widthFrame = frameH * 0.1;
    rp.ContextMenu.Panels.InventoryMenu.PlayerInventory.heightFrame = frameH * 0.1;
    rp.ContextMenu.Panels.InventoryMenu.PlayerInventory.spacingFrame = frameSpacing;
	
	if LocalPlayer().getInv and LocalPlayer():getInv() then
		rp.ContextMenu.Panels.InventoryMenu.PlayerInventory:setInventory( LocalPlayer():getInv() );
    end
	
	rp.ContextMenu.Panels.InventoryMenu.Content:AddItem( rp.ContextMenu.Panels.InventoryMenu.PlayerInventory );
	
    rp.ContextMenu.Panels.InventoryMenu.Content:InvalidateLayout( true );
    rp.ContextMenu.Panels.InventoryMenu.Content:SizeToChildren( true, true );
    rp.ContextMenu.Panels.InventoryMenu.Content:SetWide(frameH * 0.1 * 5 + frameSpacing * 7);
	
    rp.ContextMenu.Panels.InventoryMenu:InvalidateLayout( true );
    rp.ContextMenu.Panels.InventoryMenu:SizeToChildren( true, false );

	rp.ContextMenu.Panels.InventoryMenu:SetTall(rp.ContextMenu.Panels.InventoryMenu.Title:GetTall() + frameSpacing * 2 + rp.ContextMenu.Panels.InventoryMenu.PlayerInventory:GetTall() )
	if rp.ContextMenu.Panels.InventoryMenu:GetTall() > frameH then
		rp.ContextMenu.Panels.InventoryMenu.Content:SetTall( frameH - frameSpacing * 2 - rp.ContextMenu.Panels.InventoryMenu.Title:GetTall() );
		rp.ContextMenu.Panels.InventoryMenu:SetTall( frameH );
	end
	
    rp.ContextMenu.Panels.InventoryMenu.Title:Dock( TOP );
	
    rp.ContextMenu.Panels.InventoryMenu.Content:Dock( TOP );
    rp.ContextMenu.Panels.InventoryMenu.Content:DockMargin( frameSpacing * 2, frameSpacing * 2, frameSpacing * 2, frameSpacing * 2 );
    rp.ContextMenu.Panels.InventoryMenu.Content:InvalidateParent( true );
	rp.ContextMenu.Panels.InventoryMenu.Content:SetScrollbarMargin( frameSpacing );
	
    rp.ContextMenu.Panels.InventoryMenu:InvalidateLayout( true );
    rp.ContextMenu.Panels.InventoryMenu:SizeToChildren( false, true );

	rp.ContextMenu.Panels.InventoryMenu:SetTall(rp.ContextMenu.Panels.InventoryMenu.Title:GetTall() + frameSpacing * 2 + rp.ContextMenu.Panels.InventoryMenu.PlayerInventory:GetTall() )
	if rp.ContextMenu.Panels.InventoryMenu:GetTall() > frameH then
		rp.ContextMenu.Panels.InventoryMenu.Content:SetTall( frameH - frameSpacing * 2 - rp.ContextMenu.Panels.InventoryMenu.Title:GetTall() );
		rp.ContextMenu.Panels.InventoryMenu:SetTall( frameH );
	end
	
    rp.ContextMenu.Panels.InventoryMenu:SetWide( rp.ContextMenu.Panels.InventoryMenu:GetWide() + frameSpacing * 2 );
    rp.ContextMenu.Panels.InventoryMenu:SetTall( rp.ContextMenu.Panels.InventoryMenu:GetTall() + frameSpacing * 2 );

    rp.ContextMenu.Panels.InventoryMenu.x = ScrW() - rp.ContextMenu.Panels.InventoryMenu:GetWide();
    rp.ContextMenu.Panels.InventoryMenu:CenterVertical();

    rp.ContextMenu.Panels.InventoryMenu:SetZPos( -1 );

    hook.Run( "RefreshContextMenuAdditionals", frameH, frameSpacing );

    local right_panels = {};
    local total_tall = 0;

    for k, pnl in pairs( rp.ContextMenu.Panels ) do
        if (not pnl:IsVisible()) or (pnl:GetX() < ScrW() * 0.5) then continue end
        table.insert( right_panels, pnl );
        pnl.zpos = pnl:GetZPos();
        total_tall = total_tall + pnl:GetTall() + frameSpacing * 4;
    end

    local cur_y = ScrH() * 0.5 - total_tall * 0.5;
    for k, pnl in SortedPairsByMemberValue( right_panels, "zpos" ) do
        pnl.y = cur_y;
        cur_y = cur_y + pnl:GetTall() + frameSpacing * 4;
    end

    --
    local L = LocalPlayer();
    local C = IsValid(L) and IsValid(L:GetActiveWeapon()) and L:GetActiveWeapon():GetClass() == "gmod_tool";

    local toolpnl = spawnmenu and spawnmenu.ActiveControlPanel() and spawnmenu.ActiveControlPanel():GetParent();
    local vis = not C or not IsValid(toolpnl) or (toolpnl:GetTall() < 170);

    if IsValid( rp.ContextMenu.Panels.InventoryMenu ) then
        rp.ContextMenu.Panels.InventoryMenu:SetVisible(vis);
    end

    hook.Run( "ContextMenuAdditionalsVisibility", vis );

    if IsValid( toolpnl ) then
        toolpnl:SetVisible( true );
    end
end );


hook.Add( "RefreshContextMenu", "MenuContext", rp.RefreshContextCommands );


hook( "ContextMenuCreated", function( gContextMenu )
    rp.ContextMenu.Panels.CommandsView = vgui.Create( "rpui.RowView", gContextMenu );
    rp.ContextMenu.Panels.CommandsView:Dock( BOTTOM );
    rp.ContextMenu.Panels.CommandsView:InvalidateParent( true );

    hook.Run( "PopulateContextMenu", gContextMenu );
end );


hook( "OnContextMenuOpen", function()
    rp.RefreshContextMenu();
    rp.OpenContextMenu();
end );


hook( "OnContextMenuClose", function()
    rp.CloseContextMenu();
end );




-- Default menus:
surface.CreateFont( "Context.DermaMenu.Label", {
    font = "Montserrat",
    size = math.ceil(ScrH() * 0.0175),
    extended = true,
} );

if not rp.cfg.Serious and not rp.cfg.DisableSuicide then
	rp.AddContextCommand( translates.Get("Действия"), translates.Get("Возродиться"), function()
		RunConsoleCommand( "kill" );
	end, nil, 'cmenu/death' );
end

rp.AddContextCommand( translates.Get("Действия"), translates.Get("Чаты"), function()
    RunConsoleCommand( "rp_chats" );
end, nil, 'cmenu/chat' );

rp.AddContextCommand( translates.Get("Действия"), translates.Get("Вид от 3го лица"), function()
    cvar.SetValue( 'enable_thirdperson', not cvar.GetValue('enable_thirdperson') );
end, nil, 'cmenu/order' );

timer.Simple(0, function()
    rp.AddContextCommand( translates.Get("Действия"), translates.Get("Остановить звуки"), function()
        RunConsoleCommand( "stopsound" );
    end, nil, 'cmenu/order' );
end);

rp.AddContextCommand( translates.Get("Анимации"), translates.Get("Прервать анимацию"),
    function()
        LocalPlayer():RequestEmoteActionInterrupt();
    end,
    function()
        if LocalPlayer():IsPlayingTaunt() then return true end
        
        local actID = LocalPlayer():GetEmoteAction();
        if actID == "" then return false end

        local rawAction = EmoteActions:GetRawAction( rawAction );
        return (not rawAction.InteruptDisabled);
    end,
"cmenu/emotes" );

rp.AddContextCommand( translates.Get("Анимации"), translates.Get("Насмешки"), function( parent )
	local m = vgui.Create( "rpui.DropMenu" );
    m:SetBase( parent );
    m:SetFont( "Context.DermaMenu.Label" );
    m:SetSpacing( ScrH() * 0.01 );
    m.Paint = function( this, w, h ) draw.Blur( this ); end

	if #LocalPlayer():GetAvalibleActions() > 0 then
		for _, v in ipairs( LocalPlayer():GetAvalibleActions() ) do
			local raw = EmoteActions:GetRawAction( v );

            if raw.IsHidden               then continue end
			if raw.Category ~= translates.Get("Насмешки") then continue end

			local option = m:AddOption( raw.Name, function()
				RunConsoleCommand( "emote", v );
            end );
            
            option.Paint = function( this, w, h )
                local baseColor, textColor = rpui.GetPaintStyle( this, STYLE_TRANSPARENT_SELECTABLE );
                surface.SetDrawColor( baseColor );
                surface.DrawRect( 0, 0, w, h );
                draw.SimpleText( this:GetText(), this:GetFont(), this.Spacing, h * 0.5, textColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER );
                return true
            end
		end
	end

	for _, actData in pairs( EmoteActions.GmodActs ) do
		if actData[3] ~= translates.Get("Насмешки") then continue end

		local option = m:AddOption( actData[2], function()
			net.Start('Emoteactions::CheckAnim')
			net.SendToServer()
			
			RunConsoleCommand( "act", actData[1] );
        end );
        
        option.Paint = function( this, w, h )
            local baseColor, textColor = rpui.GetPaintStyle( this, STYLE_TRANSPARENT_SELECTABLE );
            surface.SetDrawColor( baseColor );
            surface.DrawRect( 0, 0, w, h );
            draw.SimpleText( this:GetText(), this:GetFont(), this.Spacing, h * 0.5, textColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER );
            return true
        end
	end

	if m:ChildCount() == 0 then
        local option = m:AddOption( translates.Get("Нет доступных насмешек! :(") );
        
        option.Paint = function( this, w, h )
            local baseColor, textColor = rpui.GetPaintStyle( this, STYLE_TRANSPARENT_SELECTABLE );
            surface.SetDrawColor( baseColor );
            surface.DrawRect( 0, 0, w, h );
            draw.SimpleText( this:GetText(), this:GetFont(), this.Spacing, h * 0.5, textColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER );
            return true
        end
	end

	m:Open();
end, 
function()
    local result = hook.Run( "EmoteActions::GetCanUseActions" )
    return result != false
end,
'cmenu/sneers' );

rp.AddContextCommand( translates.Get("Анимации"), translates.Get("Эмоции"), function( parent )
    local m = vgui.Create( "rpui.DropMenu" );
    m:SetBase( parent );
    m:SetFont( "Context.DermaMenu.Label" );
    m:SetSpacing( ScrH() * 0.01 );
    m.Paint = function( this, w, h ) draw.Blur( this ); end

	if #LocalPlayer():GetAvalibleActions() > 0 then
		for _, v in ipairs( LocalPlayer():GetAvalibleActions() ) do
			local raw = EmoteActions:GetRawAction( v );

            if raw.IsHidden             then continue end
			if raw.Category ~= translates.Get("Эмоции") then continue end

			local option = m:AddOption( raw.Name, function()
				--print(2, v)
				RunConsoleCommand( "emote", v );
            end );
            
            option.Paint = function( this, w, h )
                local baseColor, textColor = rpui.GetPaintStyle( this, STYLE_TRANSPARENT_SELECTABLE );
                surface.SetDrawColor( baseColor );
                surface.DrawRect( 0, 0, w, h );
                draw.SimpleText( this:GetText(), this:GetFont(), this.Spacing, h * 0.5, textColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER );
                return true
            end
		end
	end

	for _, actData in pairs( EmoteActions.GmodActs ) do
		if actData[3] ~= translates.Get("Эмоции") then continue end

		local option = m:AddOption( actData[2], function()
			net.Start('CheckAnim')
			net.WriteString(actData[1])
			net.SendToServer()
			
			RunConsoleCommand( "act", actData[1] );
        end );
        
        option.Paint = function( this, w, h )
            local baseColor, textColor = rpui.GetPaintStyle( this, STYLE_TRANSPARENT_SELECTABLE );
            surface.SetDrawColor( baseColor );
            surface.DrawRect( 0, 0, w, h );
            draw.SimpleText( this:GetText(), this:GetFont(), this.Spacing, h * 0.5, textColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER );
            return true
        end
	end

	if m:ChildCount() == 0 then
        local option = m:AddOption( translates.Get("Отпишитесь от всех дополнений"), function()
			gui.OpenURL( 'urf.im/page/tech' );
		end );
        
        option.Paint = function( this, w, h )
            local baseColor, textColor = rpui.GetPaintStyle( this, STYLE_TRANSPARENT_SELECTABLE );
            surface.SetDrawColor( baseColor );
            surface.DrawRect( 0, 0, w, h );
            draw.SimpleText( this:GetText(), this:GetFont(), this.Spacing, h * 0.5, textColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER );
            return true
        end
	end

	m:Open();
end, 
function()
    local result = hook.Run( "EmoteActions::GetCanUseActions" )
    return result != false
end,
'cmenu/emotes' );

-- rp.AddContextCommand( translates.Get("Анимации"), translates.Get("Групповые"), function( parent )
--     local m = vgui.Create( "rpui.DropMenu" );
--     m:SetBase( parent );
--     m:SetFont( "Context.DermaMenu.Label" );
--     m:SetSpacing( ScrH() * 0.01 );
--     m.Paint = function( this, w, h ) draw.Blur( this ); end

-- 	if #LocalPlayer():GetAvalibleActions() > 0 then
-- 		for _, v in ipairs( LocalPlayer():GetAvalibleActions() ) do
-- 			local raw = EmoteActions:GetRawAction( v );

--             if raw.IsHidden             then continue end
-- 			if raw.Category ~= translates.Get("Групповые") then continue end

-- 			local option = m:AddOption( raw.Name, function()
-- 				--print(2, v)
-- 				RunConsoleCommand( "emote", v );
--             end );
            
--             option.Paint = function( this, w, h )
--                 local baseColor, textColor = rpui.GetPaintStyle( this, STYLE_TRANSPARENT_SELECTABLE );
--                 surface.SetDrawColor( baseColor );
--                 surface.DrawRect( 0, 0, w, h );
--                 draw.SimpleText( this:GetText(), this:GetFont(), this.Spacing, h * 0.5, textColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER );
--                 return true
--             end
-- 		end
-- 	end

-- 	if m:ChildCount() == 0 then
--         local option = m:AddOption( translates.Get("Отпишитесь от всех дополнений"), function()
-- 			gui.OpenURL( 'urf.im/page/tech' );
-- 		end );
        
--         option.Paint = function( this, w, h )
--             local baseColor, textColor = rpui.GetPaintStyle( this, STYLE_TRANSPARENT_SELECTABLE );
--             surface.SetDrawColor( baseColor );
--             surface.DrawRect( 0, 0, w, h );
--             draw.SimpleText( this:GetText(), this:GetFont(), this.Spacing, h * 0.5, textColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER );
--             return true
--         end
-- 	end

-- 	m:Open();
-- end, nil, 'cmenu/emotes_shared' );

rp.AddContextCommand( translates.Get("Анимации"), translates.Get("Боевые"), function( parent )
	local m = vgui.Create( "rpui.DropMenu" );
    m:SetBase( parent );
    m:SetFont( "Context.DermaMenu.Label" );
    m:SetSpacing( ScrH() * 0.01 );
    m.Paint = function( this, w, h ) draw.Blur( this ); end

	if #LocalPlayer():GetAvalibleActions() > 0 then
		for _, v in ipairs( LocalPlayer():GetAvalibleActions() ) do
			local raw = EmoteActions:GetRawAction( v );

            if raw.IsHidden             then continue end
			if raw.Category ~= translates.Get("Боевые") then continue end

			local option = m:AddOption( raw.Name, function()
				--print(2, v)
				RunConsoleCommand( "emote", v );
            end );
            
            option.Paint = function( this, w, h )
                local baseColor, textColor = rpui.GetPaintStyle( this, STYLE_TRANSPARENT_SELECTABLE );
                surface.SetDrawColor( baseColor );
                surface.DrawRect( 0, 0, w, h );
                draw.SimpleText( this:GetText(), this:GetFont(), this.Spacing, h * 0.5, textColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER );
                return true
            end
		end
	end

	for _, actData in pairs( EmoteActions.GmodActs ) do
		if actData[3] ~= translates.Get("Боевые") then continue end

		local option = m:AddOption( actData[2], function()
			net.Start('CheckAnim')
			net.WriteString(actData[1])
			net.SendToServer()
			
			RunConsoleCommand( "act", actData[1] );
        end );
        
        option.Paint = function( this, w, h )
            local baseColor, textColor = rpui.GetPaintStyle( this, STYLE_TRANSPARENT_SELECTABLE );
            surface.SetDrawColor( baseColor );
            surface.DrawRect( 0, 0, w, h );
            draw.SimpleText( this:GetText(), this:GetFont(), this.Spacing, h * 0.5, textColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER );
            return true
        end
	end

	if m:ChildCount() == 0 then
        local option = m:AddOption( translates.Get("Отпишитесь от всех дополнений"), function()
			gui.OpenURL( 'urf.im/page/tech' );
		end );
        
        option.Paint = function( this, w, h )
            local baseColor, textColor = rpui.GetPaintStyle( this, STYLE_TRANSPARENT_SELECTABLE );
            surface.SetDrawColor( baseColor );
            surface.DrawRect( 0, 0, w, h );
            draw.SimpleText( this:GetText(), this:GetFont(), this.Spacing, h * 0.5, textColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER );
            return true
        end
	end

	m:Open();
	
	
end,
function()
    local result = hook.Run( "EmoteActions::GetCanUseActions" )
    return result != false
end,
'cmenu/emotes')

rp.AddContextCommand( translates.Get("Анимации"), translates.Get("Анимации сидения"),
    function( parent )
        local m = vgui.Create( "rpui.DropMenu" );
        m:SetBase( parent );
        m:SetFont( "Context.DermaMenu.Label" );
        m:SetSpacing( ScrH() * 0.01 );
        m.Paint = function( this, w, h ) draw.Blur( this ); end

        local a = LocalPlayer():GetAvalibleSitActions();

        if table.Count(a) > 0 then
            for seq, SitAction in pairs( a ) do
                local option = m:AddOption( SitAction[1] or seq, function( this )
                    if not this.Selected then
                        net.Start( "PlayerSitAction" );
                            net.WriteString( seq );
                        net.SendToServer();

                        for k, v in ipairs( m:GetChildren() ) do v.Selected = false; end
                        this.Selected = true;
                    end
                end );

                option.Paint = function( this, w, h )
                    local baseColor, textColor = rpui.GetPaintStyle( this, STYLE_TRANSPARENT_SELECTABLE );
                    surface.SetDrawColor( baseColor );
                    surface.DrawRect( 0, 0, w, h );
                    draw.SimpleText( this:GetText(), this:GetFont(), this.Spacing, h * 0.5, textColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER );
                    return true
                end

                if EmoteActions.PlayerAnims[LocalPlayer()] then
                    local plSeq = EmoteActions:GetSharedSequenceName(EmoteActions.PlayerAnims[LocalPlayer()].Sequence) or nil;
                    if plSeq then
                        if plSeq == seq then
                            option.Selected = true;
                        end
                    end
                end
            end
        else
            local option = m:AddOption( translates.Get("Нет доступных анимаций сидения! :(") );

            option.Paint = function( this, w, h )
                local baseColor, textColor = rpui.GetPaintStyle( this, STYLE_TRANSPARENT_SELECTABLE );
                surface.SetDrawColor( baseColor );
                surface.DrawRect( 0, 0, w, h );
                draw.SimpleText( this:GetText(), this:GetFont(), this.Spacing, h * 0.5, textColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER );
                return true
            end
        end

        m:Open();
    end,
    function()
        if LocalPlayer():InVehicle() then
            --[[
            local veh = LocalPlayer():GetVehicle();
            
            if istable(simfphys) then
                if IsValid(LocalPlayer():GetSimfphys()) then return false else return true end
            else
                return (veh:GetClass() == "prop_vehicle_prisoner_pod") and true or false
            end
            ]]--

            if LocalPlayer():GetEmoteAction() == "__sitaction" then
                return true
            end
        end

        return false
    end, 
	'cmenu/sneers'
);


rp.AddContextCommand( translates.Get("Действия"), translates.Get("Настроение"), function( parent )
    local m = vgui.Create( "rpui.DropMenu" );
    m:SetBase( parent );
    m:SetFont( "Context.DermaMenu.Label" );
    m:SetSpacing( ScrH() * 0.01 );
    m.Paint = function( this, w, h ) draw.Blur( this ); end

    local plmood = LocalPlayer():GetMood();
    for key, MoodData in pairs( rp.Mood.HoldTypes ) do
        local option = m:AddOption( MoodData[2] or "...", function( this )
            if not this.Selected then
                LocalPlayer():SetMood( key );
                for k, v in ipairs( m:GetChildren() ) do v.Selected = false; end
                this.Selected = true;
            end
        end );

        option.Selected = (tostring(key) == plmood);

        option.Paint = function( this, w, h )
            local baseColor, textColor = rpui.GetPaintStyle( this, STYLE_TRANSPARENT_SELECTABLE );
            surface.SetDrawColor( baseColor );
            surface.DrawRect( 0, 0, w, h );
            draw.SimpleText( this:GetText(), this:GetFont(), this.Spacing, h * 0.5, textColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER );
            return true
        end
    end
    
    m:Open();
end, 
function()
    local result = hook.Run( "EmoteActions::GetCanUseActions" )
    return result != false
end,
'cmenu/mood' );

rp.AddContextCommand( translates.Get("Действия"), translates.Get("Маска"),
    -- DoClick:
    function( parent )
        local m = vgui.Create( "rpui.DropMenu" );
        m:SetBase( parent );
        m:SetFont( "Context.DermaMenu.Label" );
        m:SetSpacing( ScrH() * 0.01 );
        m.Paint = function( this, w, h ) draw.Blur( this ); end

        if LocalPlayer():GetBodygroup(4) != 1 && LocalPlayer():GetBodygroup(4) != 2 then
            local option = m:AddOption( translates.Get("Надеть"), function()
                net.Start("Mask.Equip") net.SendToServer()
            end);

            option.Paint = function( this, w, h )
                local baseColor, textColor = rpui.GetPaintStyle( this, STYLE_TRANSPARENT_SELECTABLE );
                surface.SetDrawColor( baseColor );
                surface.DrawRect( 0, 0, w, h );
                draw.SimpleText( this:GetText(), this:GetFont(), this.Spacing, h * 0.5, textColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER );
                return true
            end
        elseif LocalPlayer():GetBodygroup(4) == 1 || LocalPlayer():GetBodygroup(4) == 2 then
            local option = m:AddOption( translates.Get("Снять"), function()
                net.Start("Mask.Unequip") net.SendToServer()
            end);

            option.Paint = function( this, w, h )
                local baseColor, textColor = rpui.GetPaintStyle( this, STYLE_TRANSPARENT_SELECTABLE );
                surface.SetDrawColor( baseColor );
                surface.DrawRect( 0, 0, w, h );
                draw.SimpleText( this:GetText(), this:GetFont(), this.Spacing, h * 0.5, textColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER );
                return true
            end
        end

        m:Open();
    end,

    -- Check func:
    function()
        if LocalPlayer():GetJobTable().canWear then return true end
        return false
    end, 
	
	'cmenu/mask'
);


-- ГО:
rp.AddContextCategory( translates.Get("Правопорядок"), function()
    return LocalPlayer():IsCP() or LocalPlayer():IsMayor();
end );

rp.AddContextCommand( translates.Get("Правопорядок"), translates.Get('Подать в розыск'), function()
	ui.PlayerReuqest(function(Player)
		-- ui.StringRequest(translates.Get('Подать в розыск'), translates.Get('Причина розыска?'), '', function(a)
		-- 	if IsValid(v) then
		-- 		rp.RunCommand('want', v:SteamID(), a)
		-- 	end
		-- end)
        if (IsValid(Player)) then
            local Menu;
            Menu = rpui.SliderRequestFree(translates.Get('Выберите кол-во звёзд'), 'cmenu/order.png', 1.4, 5, function(Value)
                local Value = math.Clamp(tonumber(Value), 1, 5);
                
                if IsValid(Menu) then
                    Menu:Close();
                end

                ui.StringRequest(translates.Get('Объявление в розыск игрока %s.', Player:Nick()), translates.Get('Напишите причину розыска'), '', function(Reason)
                    if (string.len(Reason) < 1) then
                        rp.Notify(NOTIFY_RED, translates.Get('Укажите причину розыска!'));
                        return
                    end

                    RunConsoleCommand('do_wanted', Reason, Player:SteamID(), Value);
                end);
            end);
        else
            rp.Notify(NOTIFY_ERROR, translates.Get('игрок не найден'));
        end
	end)
end, nil, 'cmenu/want')

rp.AddContextCommand( translates.Get("Правопорядок"), translates.Get('Снять розыск'), function()
	local wantedplayers = table.Filter(player.GetAll(), function(v) return v:IsWanted() end)

	ui.PlayerReuqest(wantedplayers, function(v)
		rp.RunCommand('unwant', v:SteamID())
	end)
end, nil, 'cmenu/unwant')

rp.AddContextCommand( translates.Get("Правопорядок"), translates.Get('Ордер'), function()
	ui.PlayerReuqest(function(v)
		ui.StringRequest(translates.Get('Ордер'), translates.Get('Причина для ордера?'), '', function(a)
			if IsValid(v) then
				rp.RunCommand('warrant', v:SteamID(), a)
			end
		end)
	end)
end, nil, 'cmenu/order')