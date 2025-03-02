-- "gamemodes\\rp_base\\gamemode\\addons\\supervisor\\cl_job_supervisor.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
/* ---- Variables: -------------------------- */
rp.SupervisorStatus = rp.SupervisorStatus or {};

rpSupervisor = rpSupervisor or {
    ID           = 0,

    ObserverMode = false,
    CMDCooldown  = 0,

    Slave        = NULL,
    SlaveID      = 1,
    SlaveList    = {},
    
    Cooldowns    = {},

    UI = {
        Panels   = {},
        DeadIcon = Material("icon16/exclamation.png");
    }
};

local tr = translates
local cached
if tr then
	cached = {
		tr.Get( 'Диспетчер' ), 
		tr.Get( 'Связь с объектом потеряна.' ), 
		tr.Get( 'Ожидание возобновления трансляции.' ), 
		tr.Get( 'Выберите объект наблюдения.' ), 
	}
else
	cached = {
		'Диспетчер', 
		'Связь с объектом потеряна.', 
		'Ожидание возобновления трансляции.', 
		'Выберите объект наблюдения.', 
	}
end

local ShowDeadPeople_List = {};
local function rpSupervisor_ShowDeadPeople()
    if not rp.cfg.Supervisors.DisplayDeadPeople then return end

    if rpSupervisor.ID ~= 0 then
        for _, ply in pairs( player.GetAll() ) do
            if not IsValid(ply) or ply:Alive() then continue end

            if rp.cfg.Supervisors.List[rpSupervisor.ID].Filter(ply) then
                if !ShowDeadPeople_List[ply] then
                    ShowDeadPeople_List[ply] = { pos = ply:GetPos(), ts = CurTime()+10 };
                else
                    ShowDeadPeople_List[ply].ts = CurTime()+10;
                end
            end
        end
    else
        for SupervisorID, SupervisorData in pairs( rp.cfg.Supervisors.List ) do
            if !SupervisorData.Filter(LocalPlayer()) then continue end

            local isActive = rp.SupervisorStatus[SupervisorID] or false;
            if not isActive then continue end

            for _, ply in pairs( player.GetAll() ) do
                if not IsValid(ply) or ply:Alive() then continue end

                if SupervisorData.Filter(ply) then
                    if !ShowDeadPeople_List[ply] then
                        ShowDeadPeople_List[ply] = { pos = ply:GetPos(), ts = CurTime()+10 };
                    else
                        ShowDeadPeople_List[ply].ts = CurTime()+10;
                    end
                end
            end
        end
    end

    for ply, v in pairs( ShowDeadPeople_List ) do
        if not IsValid(ply) or v.ts < CurTime() then 
            ShowDeadPeople_List[ply] = nil;
        else
            local ScreenPos = (v.pos + Vector(0,0,32)):ToScreen();

            if ScreenPos.visible then
                surface.SetDrawColor( Color(255,255,255,255) );
                surface.SetMaterial( rpSupervisor.UI.DeadIcon );
                surface.DrawTexturedRect( ScreenPos.x-8, ScreenPos.y-18, 16, 16 );

                local statusinfo = ply:GetJobName() .. "\n" .. (translates and translates.Get("supervisor_1", math.Round(LocalPlayer():GetPos():Distance(ply:GetPos())/53)) or ("Потеря био-сигнала, дистанция " .. math.Round(LocalPlayer():GetPos():Distance(ply:GetPos())/53) .. " м."));
                draw.DrawText( statusinfo, "rpSupervisor.DeadNotify", ScreenPos.x, ScreenPos.y, Color(255,45,45), TEXT_ALIGN_CENTER );
            end
        end
    end
end

local function rpSupervisor_RenderOverlay()
    if rpSupervisor.ID ~= 0 then
        if !IsValid(rpSupervisor.Slave) or !rpSupervisor.Slave:Alive() then
            surface.SetDrawColor( Color(0,0,0,255) );
            surface.DrawRect( 0, 0, ScrW(), ScrH() );
        end
    end
end

local function rpSupervisor_HidePlayerDisplay( name )
    if rpSupervisor.ID == 0 then return end

    if name == "PlayerDisplay" then
        if !IsValid(rpSupervisor.Slave) or !rpSupervisor.Slave:Alive() then
            return false
        end
    end

    if name == "CHudCrosshair" then return false end
end

local function rpSupervisor_Controls( cmd )
    if rpSupervisor.ID == 0                 then return end
    if rpSupervisor.CMDCooldown > CurTime() then return end

    if IsValid(rpSupervisor.UI.Panels.Base) and LocalPlayer():KeyPressed(IN_MOVELEFT) then
        rpSupervisor.UI.Panels.Base.NextSelect:DoClick();
        rpSupervisor.CMDCooldown = CurTime() + 0.1;
    elseif IsValid(rpSupervisor.UI.Panels.Base) and LocalPlayer():KeyPressed(IN_MOVERIGHT) then
        rpSupervisor.UI.Panels.Base.PrevSelect:DoClick();
        rpSupervisor.CMDCooldown = CurTime() + 0.1;
    elseif LocalPlayer():KeyPressed(IN_DUCK) then
        rpSupervisor.ObserverMode = !rpSupervisor.ObserverMode;
        LocalPlayer():SetObserverMode( rpSupervisor.ObserverMode and OBS_MODE_IN_EYE or OBS_MODE_CHASE );
        rpSupervisor.CMDCooldown = CurTime() + 0.1;
    end
end


/* --- Actions: ----------------------------- */
rp.AddContextCategory( cached[1], function()
    if rpSupervisor.ID == 0 then return false end
    return true
end );

--[[
if rpSupervisor.ID ~= 0 then
    for ActionID, Action in pairs( rp.cfg.Supervisors.List[rpSupervisor.ID].Actions ) do
        rp.AddContextCommand( cached[1], Action.Name, function()
            rpSupervisor.sendAction( ActionID );
        end, Action.Check, "cmenu/dispatch" );
    end
end
]]--


/* ---- Networking: ------------------------- */
net.Receive( "rp.job.supervisor", function()
    local cmd = net.ReadUInt(2);

    if cmd == SUPERVISOR_CMD_DISABLE then
        rpSupervisor.ID        = 0;
        rpSupervisor.Slave     = NULL;
        rpSupervisor.SlaveID   = 0;
        rpSupervisor.SlaveList = {};

        hook.Remove( "CreateMove",               "rpSupervisor::Controls" );
        hook.Remove( "RenderScreenspaceEffects", "rpSupervisor::RenderOverlay" );
        hook.Remove( "HUDShouldDraw",            "rpSupervisor::HidePlayerDisplay" );

        rp.FlushContextCategory( cached[1] );
		
        rpSupervisor.removeInterface();

        LocalPlayer():DrawViewModel( true );
    elseif cmd == SUPERVISOR_CMD_ENABLE then
        local id = net.ReadUInt(3);

        rpSupervisor.ID = id;
        rpSupervisor.ObserverMode = false;
        rpSupervisor.updateSlaveList();

        hook.Add( "CreateMove", "rpSupervisor::Controls",                    rpSupervisor_Controls );
        hook.Add( "RenderScreenspaceEffects", "rpSupervisor::RenderOverlay", rpSupervisor_RenderOverlay );
        hook.Add( "HUDShouldDraw", "rpSupervisor::HidePlayerDisplay",        rpSupervisor_HidePlayerDisplay );

        for ActionID in pairs(rp.cfg.Supervisors.List[id].Actions) do
            local Action = rp.cfg.Supervisors.Actions[ActionID];
            if not Action then continue end
            
            rp.AddContextCommand( cached[1], Action.Name, function()
                rpSupervisor.sendAction( ActionID );
            end, Action.Check, "cmenu/dispatch" );
        end

        rpSupervisor.createInterface();

        timer.Simple( 1, function()
            LocalPlayer():DrawViewModel( false );
        end );
    elseif cmd == SUPERVISOR_CMD_SPECTATE then
        local slave = net.ReadEntity();
        
        rpSupervisor.Slave = slave;

        rp.RefreshContextCommands();
    elseif cmd == SUPERVISOR_CMD_ACTION then
        local action_id = net.ReadUInt(6);
        local cd        = net.ReadFloat();

        rpSupervisor.Cooldowns[action_id] = cd;
    end
end );


/* ---- Functions: -------------------------- */
rpSupervisor.updateSlaveList = function()
    rpSupervisor.SlaveList = {};

    for _, v in pairs( player.GetAll() ) do
        if v == LocalPlayer() then continue end

        if rp.cfg.Supervisors.List[rpSupervisor.ID].Filter(v) then
            local k = table.insert( rpSupervisor.SlaveList, v );

            if rpSupervisor.Slave == v then
                rpSupervisor.SlaveID = k;
            end
        end
    end
end

rpSupervisor.selectNextSlave = function()
    rpSupervisor.SlaveID = 1 + rpSupervisor.SlaveID % #rpSupervisor.SlaveList;
end

rpSupervisor.selectPrevSlave = function()
    rpSupervisor.SlaveID = 1 + (rpSupervisor.SlaveID - 2) % #rpSupervisor.SlaveList;
end

rpSupervisor.sendSlave = function()
    if rpSupervisor.SlaveList[rpSupervisor.SlaveID] then
        if !IsValid(rpSupervisor.SlaveList[rpSupervisor.SlaveID]) then return end

        net.Start( "rp.job.supervisor" );
            net.WriteUInt( SUPERVISOR_CMD_SPECTATE, 2 );
            net.WriteEntity( rpSupervisor.SlaveList[rpSupervisor.SlaveID] );
        net.SendToServer();
    end
end

rpSupervisor.sendAction = function( action_id )
    local SupervisorData = rp.cfg.Supervisors.List[rpSupervisor.ID];

    if not SupervisorData then return end

    if SupervisorData.Actions[action_id] then
        local ActionData = rp.cfg.Supervisors.Actions[action_id];
        
        if ActionData.Cooldown then
            if (rpSupervisor.Cooldowns[action_id] or 0) > CurTime() then
                rp.Notify(
                    NOTIFY_ERROR,
                    translates and translates.Get("supervisor_2", math.ceil(rpSupervisor.Cooldowns[action_id]-CurTime())) or ("Действие ещё перезаряжается (осталось " .. math.ceil(rpSupervisor.Cooldowns[action_id]-CurTime()) .. " сек.)")
                );
                return
            end
        end

        net.Start( "rp.job.supervisor" );
            net.WriteUInt( SUPERVISOR_CMD_ACTION, 2 );
            net.WriteUInt( action_id, 6 );
        net.SendToServer();
    end
end


/* --- User Interface: ---------------------- */
surface.CreateFont( "rpSupervisor.Small",       { font = "Tahoma", extended = true, size = 16, weight = 500  } );
surface.CreateFont( "rpSupervisor.DefaultBold", { font = "Tahoma", extended = true, size = 18, weight = 1000 } );
surface.CreateFont( "rpSupervisor.Bold",        { font = "Tahoma", extended = true, size = 18, weight = 1000 } );
surface.CreateFont( "rpSupervisor.SuperBold",   { font = "Tahoma", extended = true, size = 22, weight = 1000 } );
surface.CreateFont( "rpSupervisor.DeadNotify",  { font = "Tahoma", extended = true, size = 16, weight = 400, antialias = false, outline = true } );


rpSupervisor.UI.PaintPanel = function( self, w, h )
    surface.SetDrawColor( rp.col.Background );
    surface.DrawRect( 0, 0, w, h );

    surface.SetDrawColor( self:IsHovered() and Color(0,55,255,255) or rp.col.Outline );
    surface.DrawOutlinedRect( 0, 0, w, h );
end


rpSupervisor.removeInterface = function()
    for k, Pnl in pairs( rpSupervisor.UI.Panels ) do
        if IsValid(Pnl) then
            Pnl:Remove();
        end

        rpSupervisor.UI.Panels[k] = nil;
    end
end


rpSupervisor.createInterface = function()
    rpSupervisor.removeInterface();

    rpSupervisor.UI.Panels.Base = vgui.Create( "Panel", vgui.GetWorldPanel() );
    local BasePnl = rpSupervisor.UI.Panels.Base;

    BasePnl:SetSize( ScrW()*0.4, ScrH()*0.1 );
    BasePnl:CenterHorizontal();
    BasePnl:CenterVertical( 0.8 );

    BasePnl.PrevSelect = vgui.Create( "DButton", BasePnl )
    BasePnl.PrevSelect:Dock( LEFT );
    BasePnl.PrevSelect:SetWide( BasePnl:GetWide()*0.075 );
    BasePnl.PrevSelect:SetText( "" );
    BasePnl.PrevSelect.Paint = function( self, w, h )
        rpSupervisor.UI.PaintPanel( self, w, h );
        draw.SimpleText( "<<", "rpSupervisor.Bold", w/2, h/2, (self:IsHovered() and Color(255,255,255,255) or rp.col.Outline), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
    end
    BasePnl.PrevSelect.DoClick = function()
        rpSupervisor.updateSlaveList();
        rpSupervisor.selectPrevSlave();
        rpSupervisor.sendSlave();
    end

    BasePnl.NextSelect = vgui.Create( "DButton", BasePnl )
    BasePnl.NextSelect:Dock( RIGHT );
    BasePnl.NextSelect:SetWide( BasePnl:GetWide()*0.075 );
    BasePnl.NextSelect:SetText( "" );
    BasePnl.NextSelect.Paint = function( self, w, h )
        rpSupervisor.UI.PaintPanel( self, w, h );
        draw.SimpleText( ">>", "rpSupervisor.Bold", w/2, h/2, (self:IsHovered() and Color(255,255,255,255) or rp.col.Outline), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
    end
    BasePnl.NextSelect.DoClick = function()
        rpSupervisor.updateSlaveList();
        rpSupervisor.selectNextSlave();
        rpSupervisor.sendSlave();
    end

    BasePnl.SlaveSelect = vgui.Create( "DButton", BasePnl )
    BasePnl.SlaveSelect:Dock( FILL );
    BasePnl.SlaveSelect:DockMargin( 4, 12, 4, 12 );
    BasePnl.SlaveSelect:SetText( "" );
    BasePnl.SlaveSelect.Paint     = rpSupervisor.UI.PaintPanel;
    BasePnl.SlaveSelect.PaintOver = function( self, w, h )
        local slave = rpSupervisor.Slave;

        if IsValid(slave) then
            if not slave:Alive() then
                draw.SimpleText( cached[2],         "rpSupervisor.Bold",  16, h/2, rp.col.Outline, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM );
                draw.SimpleText( cached[3], "rpSupervisor.Small", 16, h/2, rp.col.Outline, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP );
            else
                draw.SimpleText( slave:GetName(), "rpSupervisor.DefaultBold", 16, h/2, rp.col.Outline, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM );
                draw.SimpleText( "(" .. team.GetName(slave:Team()) .. ")", "rpSupervisor.Small", 16, h/2, team.GetColor(slave:Team()), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP );

                draw.SimpleText( "HP: " .. slave:Health(), "rpSupervisor.SuperBold", w-16, h/2, Color(255,25,25,255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM );
                draw.SimpleText( "AP: " .. slave:Armor(),  "rpSupervisor.SuperBold", w-16, h/2, Color(0,64,255,255),  TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP );
            end
        else
            draw.SimpleText( cached[4], "rpSupervisor.Bold", 16, h/2, (self:IsHovered() and Color(255,255,255,255) or rp.col.Outline), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER );
        end
    end
    BasePnl.SlaveSelect.DoClick = function()
        rpSupervisor.updateSlaveList();
        local m = DermaMenu();

        for k, v in pairs( rpSupervisor.SlaveList ) do
            local o = m:AddOption( v:GetName() .. "\n(" .. team.GetName(v:Team()) .. ")",
                function()
                    if IsValid( rpSupervisor.SlaveList[k] ) then
                        net.Start( "rp.job.supervisor" );
                            net.WriteUInt( SUPERVISOR_CMD_SPECTATE, 2 );
                            net.WriteEntity( v );
                        net.SendToServer();
                    end
                end
            );

            -- fuckin idiot gary
            o.m_Image = vgui.Create( "AvatarImage", o );
            o.m_Image:SetPlayer( v, 16 );
            o.m_Image:SetSize( 16, 16 );
            o:InvalidateLayout();

            o.PerformLayout = function( self, width, height )
                self:SizeToContents()
                self:SetWide( self:GetWide() + 30 )
                local w = math.max( self:GetParent():GetWide(), self:GetWide() )
                self:SetWide( w ) -- fuckd up here
                DButton.PerformLayout( self )
            end
        end

        m:InvalidateChildren( true );
        m:InvalidateLayout( true );

        m:SizeToChildren( false, true );

        m:Open();
    end

    -- context menu

    local ctxcategories = {
        [cached[1]]                 = true,
        [rp.cfg.MenuCategoryPolice] = true,
        [tr.Get("Управление")]      = true,
        ["Командование"]            = true,
    };

    rpSupervisor.UI.Panels.SupervisorCtx = vgui.Create( "Panel", vgui.GetWorldPanel() );
    local SupervisorCtx = rpSupervisor.UI.Panels.SupervisorCtx;

    SupervisorCtx:SetWide( ScrW() * 0.4 );
    SupervisorCtx.frameSpacing = ScrH() * 0.5 * 0.01;
    SupervisorCtx.cmdMinWidth  = SupervisorCtx:GetWide() * 0.085;
    SupervisorCtx.Think = function( this )
        if rpSupervisor.ID == 0 then this:Remove(); end

        if this.CommandsView then
            if rpSupervisor.Slave ~= this.Slave then
                this.CommandsView:Rebuild();
                this.Slave = rpSupervisor.Slave;
            end
        end
            
        if g_ContextMenu:IsVisible() and not this.IsHiding then
            this:SetAlpha( 0 );
            this.IsHiding = true;
        end
        
        if not g_ContextMenu:IsVisible() and this.IsHiding then
            this:SetAlpha( 255 );
            this.IsHiding = false;
        end
    end

    SupervisorCtx.CommandsView = vgui.Create( "rpui.RowView", SupervisorCtx );
    SupervisorCtx.CommandsView:Dock( TOP );
    SupervisorCtx.CommandsView:SetCategoryTitleFont( "CommandCategory" );
    SupervisorCtx.CommandsView:InvalidateParent( true );
    SupervisorCtx.CommandsView:SetSpacingX( SupervisorCtx.frameSpacing );
    SupervisorCtx.CommandsView:SetSpacingY( SupervisorCtx.frameSpacing );
    SupervisorCtx.CommandsView.PaintCategoryTitle = function( this, w, h )
        local x, y = this:GetTextInset();
        draw.SimpleTextOutlined( this:GetText(), this:GetFont(), x, y, rpui.UIColors.White, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color(0,0,0,128) );
        return true
    end

    SupervisorCtx.CommandsView.Rebuild = function( this )
        this:Clear();

        for c in pairs( ctxcategories ) do
            local category = rp.ContextMenu.Categories[c];
            if not category then continue end

            if category.Check then
                if not category.Check() then continue end
            end

            for _, cmd in ipairs( category.Commands ) do
                if not cmd.Check() then continue end

                local CommandButton = vgui.Create( "DButton" );
                CommandButton:SetFont( "CommandButton" );
                CommandButton:SetText( string.utf8upper(cmd.Name) );
                CommandButton:SizeToContentsY( SupervisorCtx.frameSpacing );
                CommandButton:SizeToContentsX( CommandButton:GetTall() + SupervisorCtx.frameSpacing * 2 );
                CommandButton:SetWide( math.max( CommandButton:GetWide(), SupervisorCtx.cmdMinWidth ) );
                CommandButton.Paint = function( me, w, h )
                    local baseColor, textColor = rpui.GetPaintStyle( me, STYLE_SOLID );
                    surface.SetDrawColor( rp.cfg.UIColor.SubHeader );
                    surface.DrawRect( 0, 0, w, h );

                    surface.SetDrawColor( rp.cfg.UIColor.BlockHeader );
                    surface.DrawRect( 0, 0, h, h );
                    
                    if cmd.Icon then
                        surface.SetDrawColor( rpui.UIColors.White );
                        surface.SetMaterial(cmd.Icon)
                        surface.DrawTexturedRect( h * 0.1, h * 0.1, h * 0.8, h * 0.8 );
                    end
                    
                    surface.SetDrawColor( Color(0,0,0,me._grayscale or 0) );
                    local p = h * 0.1;
                    surface.DrawLine( h, p, h, h - p );

                    draw.SimpleText( me:GetText(), me:GetFont(), h + (w-h) * 0.5, h * 0.5, rpui.UIColors.Black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
                    return true
                end

                CommandButton.PerformLayout = function( me )
                    me:SizeToContentsY( SupervisorCtx.frameSpacing );
                    me:SizeToContentsX( me:GetTall() + SupervisorCtx.frameSpacing * 2 );
                    me:SetWide( math.max( me:GetWide(), SupervisorCtx.cmdMinWidth ) );
                end

                CommandButton.DoClick = cmd.Action;

                this:AddItem( CommandButton, string.utf8upper(c) );
            end
        end

        SupervisorCtx:InvalidateLayout( true );
        SupervisorCtx:SizeToChildren( false, true );

        SupervisorCtx:CenterHorizontal();
        SupervisorCtx.y = ScrH() * 0.01;
    end
end

hook.Add( "HUDPaint", "rpSupervisor::ShowDeadPeople", rpSupervisor_ShowDeadPeople );