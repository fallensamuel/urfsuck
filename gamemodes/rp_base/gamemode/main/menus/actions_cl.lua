
if not rp.cfg.DisableContextRedisign then return end

rp.ContextMenu = rp.ContextMenu or {
    Panels = {}
};

rp.ContextMenu.Categories = {
    Map = {}, List = {}
};


rp.AddContextCategory = function( category, check, dock )
    if rp.ContextMenu.Categories.List[category] then return end

    check = isfunction(check) and check or function() return true end
    dock  = dock and dock or LEFT;

    table.insert( rp.ContextMenu.Categories.Map, category );
    rp.ContextMenu.Categories.List[category] = {
        Items   = {},
        Check   = check,
        PnlDock = dock
    };
end


rp.AddContextCommand = function( category, name, func, check )
    if not rp.ContextMenu.Categories.List[category] then
        rp.AddContextCategory( category );
    end
    
    check = check or function() return true end
    table.insert( rp.ContextMenu.Categories.List[category].Items, {_Class = "DButton", Name = name, Action = func, Check = check} );
end

rp.AddContextCommandGroup = function( category, name, func, check )
    if not rp.ContextMenu.Categories.List[category] then
        rp.AddContextCategory( category );
    end
    
    check = check or function() return true end
    table.insert( rp.ContextMenu.Categories.List[category].Items, {_Class = "DCollapsibleCategory", Name = name, Action = func, Check = check} );
end

rp.FlushContextCommands = function( category )
    if rp.ContextMenu.Categories.List[category] then
        rp.ContextMenu.Categories.List[category].Items = {};
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
    for _, CtxBasePnl in pairs( rp.ContextMenu.Panels ) do
        for k, Menu in pairs( CtxBasePnl:GetChildren() ) do
            if IsValid(Menu) then Menu:Remove() end
        end
        CtxBasePnl.Menus = {};

        for _, CtxCategoryName in pairs( rp.ContextMenu.Categories.Map ) do
            local CtxCategory = rp.ContextMenu.Categories.List[CtxCategoryName];

            if CtxBasePnl.PnlDock ~= CtxCategory.PnlDock then continue end
            if not CtxCategory.Check() then continue end

            CtxBasePnl.Menus[CtxCategoryName] = ui.Create( "ui_frame", function( self, p )
                self:Dock( TOP );
				self:DockMargin( 0, 0, 0, 5 );
				self:SetTitle( CtxCategoryName );
                self:ShowCloseButton( false );
                
                self.Canvas = ui.Create( "ui_scrollpanel", function( this )
                    this:DockMargin( 0, 1, 0, 0 );
                    this:SetSpacing( 1 );
                    this:Dock( FILL );
                    this.Items = {};
                end );
                
                self:Add( self.Canvas );
            end, CtxBasePnl );

            for Item, ItemData in pairs(rp.ContextMenu.Categories.List[CtxCategoryName].Items) do
                if not ItemData.Check() then continue end

                CtxBasePnl.Menus[CtxCategoryName].Canvas.Items[Item] = ui.Create( ItemData._Class or "DButton", function( self )
                    --self:Dock( TOP );
                    --self:DockMargin( 0, 2, 0, 0 );
                    self:SetHeight( 30 );

                    if ItemData._Class == "DCollapsibleCategory" then
                        self.Header:SetTall(30);
                        self.Header:SetFont("ui.20");
                        self.Header:GetParent().Paint = function( self, w, h )
                            draw.OutlinedBox( 0, 0, w, h, ui.col.Background, ui.col.Outline );
                        end
                        self:SetLabel( ItemData.Name );
                        ItemData.Action( self );
                    else
                        self:SetText( " " .. ItemData.Name );
                        self.DoClick = ItemData.Action;
                    end

                    self:InvalidateLayout( true );
                    CtxBasePnl.Menus[CtxCategoryName].Canvas:AddItem( self );
                end, CtxBasePnl.Menus[CtxCategoryName].Canvas );
            end

            if table.Count(CtxBasePnl.Menus[CtxCategoryName].Canvas.Items) == 0 then
                CtxBasePnl.Menus[CtxCategoryName]:Remove();
                CtxBasePnl.Menus[CtxCategoryName] = nil;
            else
                CtxBasePnl.Menus[CtxCategoryName].Canvas:SizeToChildren( true, true );

                if CtxBasePnl.PnlDock == LEFT then
                    CtxBasePnl.Menus[CtxCategoryName].Canvas:SetTall( CtxBasePnl.Menus[CtxCategoryName].Canvas:GetTall()+30 );
                else
                    CtxBasePnl.Menus[CtxCategoryName].Canvas:SetTall( ScrH()*0.75 );
                end

                CtxBasePnl.Menus[CtxCategoryName]:SizeToChildren( true, true );
            end
        end

        --timer.Simple( FrameTime()*30, function()  -- fixed?
            CtxBasePnl:InvalidateLayout( true );
            CtxBasePnl:SizeToChildren( false, true );

            if CtxBasePnl.PnlDock == LEFT then
                CtxBasePnl:SetPos( 5, ScrH() / 2 - CtxBasePnl:GetTall() / 2 );
            else
                CtxBasePnl:SetPos( ScrW() - CtxBasePnl:GetWide() - 5, ScrH() / 2 - CtxBasePnl:GetTall() / 2 );
            end
        --end );
    end
end


hook( "ContextMenuCreated", function( gContextMenu )
    rp.ContextMenu.Panels.ContextMenuL = vgui.Create( "Panel", gContextMenu );
    rp.ContextMenu.Panels.ContextMenuL:SetWidth( ScrW()*0.125 );
    rp.ContextMenu.Panels.ContextMenuL.PnlDock = LEFT;
    rp.ContextMenu.Panels.ContextMenuL.Menus   = {};
    rp.ContextMenu.Panels.ContextMenuL.Forced  = false;

    rp.ContextMenu.Panels.ContextMenuR = vgui.Create( "Panel", gContextMenu );
    rp.ContextMenu.Panels.ContextMenuR:SetWidth( ScrW()*0.125 );
    rp.ContextMenu.Panels.ContextMenuR.PnlDock = RIGHT;
    rp.ContextMenu.Panels.ContextMenuR.Menus   = {};
    rp.ContextMenu.Panels.ContextMenuR.Forced  = false;
end );


hook( "OnContextMenuOpen", function()
    rp.RefreshContextMenu();
    rp.OpenContextMenu();
end );


hook( "OnContextMenuClose", function()
    rp.CloseContextMenu();
end );


-- Default menus:
rp.AddContextCommand( translates.Get("Действия"), translates.Get("Возродиться"), function()
    RunConsoleCommand( "kill" );
end );

rp.AddContextCommand( translates.Get("Действия"), translates.Get("Чаты"), function()
    RunConsoleCommand( "rp_chats" );
end );

rp.AddContextCommand( translates.Get("Действия"), translates.Get("Насмешки"), function()
	local m = ui.DermaMenu(p)

	if #LocalPlayer():GetAvalibleActions() > 0 then
		for _, v in ipairs( LocalPlayer():GetAvalibleActions() ) do
			local raw = EmoteActions:GetRawAction( v );

            if raw.IsHidden               then continue end
			if raw.Category ~= translates.Get("Насмешки") then continue end

			m:AddOption( raw.Name, function()
				print(2, v)
				RunConsoleCommand( "emote", v );
			end );
		end
	end

	for _, actData in pairs( EmoteActions.GmodActs ) do
		if actData[3] ~= translates.Get("Насмешки") then continue end

		m:AddOption( actData[2], function()
			net.Start('CheckAnim')
			net.WriteString(actData[1])
			net.SendToServer()
			
			RunConsoleCommand( "act", actData[1] );
		end );
	end

	if m:ChildCount() == 0 then
		m:AddOption( translates.Get("Нет доступных насмешек! :(") );
	end

	m:Open();
end );

rp.AddContextCommand( translates.Get("Действия"), translates.Get("Эмоции"), function()
	local m = ui.DermaMenu(p)

	if #LocalPlayer():GetAvalibleActions() > 0 then
		for _, v in ipairs( LocalPlayer():GetAvalibleActions() ) do
			local raw = EmoteActions:GetRawAction( v );

            if raw.IsHidden             then continue end
			if raw.Category ~= translates.Get("Эмоции") then continue end

			m:AddOption( raw.Name, function()
				RunConsoleCommand( "emote", v );
			end );
		end
	end

	for _, actData in pairs( EmoteActions.GmodActs ) do
		if actData[3] ~= translates.Get("Эмоции") then continue end

		m:AddOption( actData[2], function()
			net.Start('CheckAnim')
			net.WriteString(actData[1])
			net.SendToServer()
			
			RunConsoleCommand( "act", actData[1] );
		end );
	end

	if m:ChildCount() == 0 then
		m:AddOption( translates.Get("Отпишитесь от всех дополнений") );
	end

	m:Open();
end );

rp.AddContextCommand( translates.Get("Действия"), translates.Get("Анимации сидения"),
    function()
        local m = ui.DermaMenu();
        local a = LocalPlayer():GetAvalibleSitActions();

        if table.Count(a) > 0 then
            for seq, SitAction in pairs( a ) do
                local i = m:AddOption( SitAction[1] or seq, function()
                    net.Start( "PlayerSitAction" );
                        net.WriteString( seq );
                    net.SendToServer();
                end );

                if EmoteActions.PlayerAnims[LocalPlayer()] then
                    local plSeq = EmoteActions:GetSharedSequenceName(EmoteActions.PlayerAnims[LocalPlayer()].Sequence) or nil;
                    if plSeq then
                        if plSeq == seq then
                            i:SetIcon( "icon16/tick.png" );
                        end
                    end
                end
            end
        else
            m:AddOption( translates.Get("Нет доступных анимаций сидения! :(") );
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

            if LocalPlayer():GetEmoteAction() == "__sitaction" then return true end
        end

        return false
    end
);

rp.AddContextCommand( translates.Get("Действия"), translates.Get("Настроение"), function()
    local m       = ui.DermaMenu();
    local plmood = LocalPlayer():GetMood();

    for key, MoodData in pairs( rp.Mood.HoldTypes ) do
        local eq = (tostring(key) == plmood);

        local i = m:AddOption( MoodData[2] or "...", function()
            if not eq then
                LocalPlayer():SetMood( key );
            end
        end );

        if eq then
            i:SetIcon( "icon16/tick.png" );
        end
    end

    m:Open();
end );

rp.AddContextCommand( translates.Get("Действия"), translates.Get("Маска"),
    -- DoClick:
    function()
        local m = ui.DermaMenu(p);

        if LocalPlayer():GetBodygroup(4) != 1 && LocalPlayer():GetBodygroup(4) != 2 then
            m:AddOption( translates.Get("Надеть"), function()
                net.Start("Mask.Equip") net.SendToServer()
            end);
        elseif LocalPlayer():GetBodygroup(4) == 1 || LocalPlayer():GetBodygroup(4) == 2 then
            m:AddOption( translates.Get("Снять"), function()
                net.Start("Mask.Unequip") net.SendToServer()
            end);
        end

        m:Open();
    end,

    -- Check func:
    function()
        if LocalPlayer():GetJobTable().canWear then return true end
        return false
    end
);


-- ГО:
rp.AddContextCategory( translates.Get("Правопорядок"), function()
    return LocalPlayer():IsCP() or LocalPlayer():IsMayor();
end );

rp.AddContextCommand( translates.Get("Правопорядок"), translates.Get('Подать в розыск'), function()
	ui.PlayerReuqest(function(v)
		ui.StringRequest(translates.Get('Подать в розыск'), translates.Get('Причина розыска?'), '', function(a)
			if IsValid(v) then
				rp.RunCommand('want', v:SteamID(), a)
			end
		end)
	end)
end)

rp.AddContextCommand( translates.Get("Правопорядок"), translates.Get('Снять розыск'), function()
	local wantedplayers = table.Filter(player.GetAll(), function(v) return v:IsWanted() end)

	ui.PlayerReuqest(wantedplayers, function(v)
		rp.RunCommand('unwant', v:SteamID())
	end)
end)

rp.AddContextCommand( translates.Get("Правопорядок"), translates.Get('Ордер'), function()
	ui.PlayerReuqest(function(v)
		ui.StringRequest(translates.Get('Ордер'), translates.Get('Причина для ордера?'), '', function(a)
			if IsValid(v) then
				rp.RunCommand('warrant', v:SteamID(), a)
			end
		end)
	end)
end)