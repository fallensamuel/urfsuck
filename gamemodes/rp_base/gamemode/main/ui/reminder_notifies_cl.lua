-- "gamemodes\\rp_base\\gamemode\\main\\ui\\reminder_notifies_cl.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
----------------------------------------------------------------
--  Награды боевого пропуска:
----------------------------------------------------------------
local rewardmsgcases = {
    default = translates.Get("новых наград"),
        [1] = translates.Get("новая награда"),
        [2] = translates.Get("новые награды"),
};

rp.NotifyReminder(
    function( ply, rewardCounter )
        local str_u_have    = translates.Get("У вас есть");
        local str_n_rewards = (rewardmsgcases[rewardCounter] and rewardmsgcases[rewardCounter] or rewardmsgcases.default) .. " " .. translates.Get("РП Пропуска") .. "!";

        -- Popup:
        local popup = rp.NotifyVoteClient( "", 0, 15 );
        popup.Initialize = function( self )
            self.PopupTitle  = translates.Get("Награды");
            self.GradientMat = rpui.GradientMat;

            self.ActionColor   = (rp.seasonpass.GetSeason() or {}).F4ButtonColor or rpui.UIColors.White;
            self.ActionColorBG = rpui.UIColors.Background;

            local fontData = table.Copy( surface.RegistredFonts["rpui.notifyvote.font"] );
            fontData.size = fontData.size * 2;
            fontData.weight = 1000;
            surface.CreateFont( "rpui.notifyvote.fontlarge-bold", fontData );

            self.Base_OnPopupSizeTo = self.OnPopupSizeTo; 
            self.OnPopupSizeTo = function( this, _w, _h )
                this:Base_OnPopupSizeTo( _w, _h );
                if _h == 0 then return end

                local p = self.popup;

                for _, child in ipairs( IsValid(p) and p:GetChildren() or {} ) do
                    child:Remove();
                end

                local fl_Padding = self:GetWide() * 0.025;
                p:DockPadding( fl_Padding, fl_Padding, fl_Padding, fl_Padding );
            
                local Action = vgui.Create( "DButton", p );
                Action:Dock( BOTTOM );
                Action:SetTall( p:GetWide() * 0.075 );
                Action:SetText( utf8.upper( translates.Get("ЗАБРАТЬ") ) );
                Action:SetFont( "rpui.notifyvote.font" );
                Action.DoClick = function( me )
                    me:SetMouseInputEnabled( false );
                    this:Close();

                    local SeasonpassMenu = vgui.Create( "rpui.Seasonpass" );
                    SeasonpassMenu:SetSize( ScrW() * 0.75, ScrH() * 0.75 );
                    SeasonpassMenu:Center();
                    SeasonpassMenu:MakePopup();
                end
                Action.Paint = function( me, w, h )
                    local textColor = rpui.GetPaintStyle( me );
                    me.rotAngle = (me.rotAngle or 0) + 100 * FrameTime();
                    local distsize  = math.sqrt( w*w + h*h );   
                    --surface.SetDrawColor( self.ActionColor );
                    --surface.DrawRect( 0, 0, w, h );
                    --surface.SetDrawColor( self.ActionColorBG );
                    --surface.SetMaterial( this.GradientMat );
                    surface.SetDrawColor( rpui.UIColors.BackgroundGold );
                    surface.DrawRect( 0, 0, w, h );
                    surface.SetDrawColor( rpui.UIColors.Gold );
                    surface.SetMaterial( this.GradientMat );
                    surface.DrawTexturedRectRotated( w * 0.5, h * 0.5, distsize, distsize, (me.rotAngle or 0) );
                    draw.SimpleText( me:GetText(), me:GetFont(), w * 0.5, h * 0.5, textColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
                    return true
                end

                local Content = vgui.Create( "Panel", p );
                Content:Dock( FILL );
                Content.Paint = function( me, w, h )
                    local c_w, c_h = w * 0.5, h * 0.5;
                    local tw, th = draw.SimpleText( rewardCounter, "rpui.notifyvote.fontlarge-bold", c_w, c_h - h * 0.025, rpui.UIColors.White, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
                    draw.SimpleText( str_u_have, "rpui.notifyvote.font", c_w, c_h - th * 0.35, rpui.UIColors.White, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM );
                    draw.SimpleText( str_n_rewards, "rpui.notifyvote.font", c_w, c_h + th * 0.325, rpui.UIColors.White, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP );
                end
            end
        end

        popup.Base_Think = popup.Think;
        popup.Think = function( self )
            self:Base_Think();
            self.Title = self.PopupTitle;
        end

        -- Notify:
        popup:Initialize();

        return string.format( "%s %d %s",
            str_u_have, rewardCounter, str_n_rewards
        );
    end,
    NOTIFY_GREEN,
    10,
    60 * 2,
    0,
    function( ply )
        local isDonated, seasonRewards = ply:SeasonIsDonated(), ply:SeasonGetRewards();
        local rewardCounter = 0;

        for idx = 1, (isDonated and 2 or 1) do
            local rewards = seasonRewards[idx] or {};

            for _, act in pairs( rewards ) do
                if act then
                    rewardCounter = rewardCounter + 1;
                end
            end
        end

        return rewardCounter > 0, rewardCounter;
    end
);


----------------------------------------------------------------
--  Оповещение о ежедневном кейсе:
----------------------------------------------------------------
rp.NotifyReminder(
    function( ply, CachedLB )
        local message = translates.Get("Ежедневный кейс доступен!");

        -- Popup:
        local popup = rp.NotifyVoteClient( "", 0, 15 );
        popup.Initialize = function( self )
            self.PopupTitle  = message;
            self.GradientMat = rpui.GradientMat;

            self.Base_OnPopupSizeTo = self.OnPopupSizeTo; 
            self.OnPopupSizeTo = function( this, _w, _h )
                this:Base_OnPopupSizeTo( _w, _h );
                if _h == 0 then return end

                local p = self.popup;

                for _, child in ipairs( p:GetChildren() or {} ) do
                    child:Remove();
                end

                local fl_Padding = self:GetWide() * 0.025;
                p:DockPadding( fl_Padding, fl_Padding, fl_Padding, fl_Padding );

                local ModelViewer = vgui.Create( "DModelPanel", p );
                ModelViewer:Dock( LEFT );
                ModelViewer:DockMargin( 0, 0, fl_Padding, 0 );
                ModelViewer:SetWide( _h - fl_Padding * 2 );
                ModelViewer:SetModel( CachedLB.model ); -- TODO!
                ModelViewer:SetMouseInputEnabled( false );
                ModelViewer.LayoutEntity = function( me, ent )
                    if not IsValid(ent) then return end
                    local mins, maxs = ent:GetModelRenderBounds();
                    ent:SetPos( Vector( 0, 0, -(mins.z+maxs.z) * 0.5 ) );
                    local size = mins:Distance( maxs );
                    me:SetLookAng( Angle(35,CurTime()*2,0) );
                    me:SetCamPos( -me:GetLookAng():Forward() * size );
                end
                ModelViewer.Base_Paint = ModelViewer.Paint;
                ModelViewer.Paint = function( me, w, h )
                    surface.SetDrawColor( rpui.UIColors.Background );
                    surface.DrawRect( 0, 0, w, h );
                    ModelViewer.Base_Paint( me, w, h );
                end

                local Action = vgui.Create( "DButton", p );
                Action:Dock( FILL );
                Action:DockMargin( 0, fl_Padding * 4, 0, fl_Padding * 4 );
                Action:SetTall( p:GetWide() * 0.075 );
                Action:SetText( utf8.upper( translates.Get("ЗАБРАТЬ") ) );
                Action:SetFont( "rpui.notifyvote.font" );
                Action.DoClick = function( me )
                    me:SetMouseInputEnabled( false );
                    this:Close();
                    LocalPlayer().donateLastCatName = translates.Get( "КЕЙСЫ" );
                    RunConsoleCommand( "say", "/upgrades" );
                end
                Action.Paint = function( me, w, h )
                    local textColor = rpui.GetPaintStyle( me );
                    me.rotAngle = (me.rotAngle or 0) + 100 * FrameTime();
                    local distsize  = math.sqrt( w*w + h*h );   
                    surface.SetDrawColor( rpui.UIColors.BackgroundGold );
                    surface.DrawRect( 0, 0, w, h );
                    surface.SetDrawColor( rpui.UIColors.Gold );
                    surface.SetMaterial( this.GradientMat );
                    surface.DrawTexturedRectRotated( w * 0.5, h * 0.5, distsize, distsize, (me.rotAngle or 0) );
                    draw.SimpleText( me:GetText(), me:GetFont(), w * 0.5, h * 0.5, textColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
                    return true
                end
            end
        end

        popup.Base_Think = popup.Think;
        popup.Think = function( self )
            self:Base_Think();
            self.Title = self.PopupTitle;
        end

        -- Notify:
        popup:Initialize();
        return message;
    end,
    NOTIFY_GREEN,
    10,
    60,
    0,
    function( ply )
        local CachedLB = {};

        if rp.lootbox and rp.lootbox.All then
            for k, v in pairs( rp.lootbox.All ) do
                if v.cooldown_time and (v.price or 0) == 0 then
                    CachedLB = v;
                    break
                end
            end
        end

        local time_t;

        if CachedLB.cooldown_time then
			local cds = LocalPlayer():GetNetVar( "LootboxCooldowns" ) or {}
			
			if cds[CachedLB.NID] and tonumber( cds[CachedLB.NID] ) > os.time() then
				time_t = tonumber( cds[CachedLB.NID] ) - os.time();
			end
		end
		
		if CachedLB.needed_time and LocalPlayer():GetTodayPlaytime() < CachedLB.needed_time and (not time_t or (time_t < CachedLB.needed_time - LocalPlayer():GetTodayPlaytime())) then
			time_t = CachedLB.needed_time - LocalPlayer():GetTodayPlaytime();
		end

        return (time_t or 0) <= 0, CachedLB;
    end
);