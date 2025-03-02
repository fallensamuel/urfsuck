-- "gamemodes\\rp_base\\gamemode\\main\\menus\\scoreboard\\config_cl.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
module( "rp.Scoreboard.Config", package.seeall );

----------------------------------------------------------------

--
-- Title = "urf.im Scoreboard";

--
Colors = {
    Shading = Color( 0, 12, 24, 74 ),
    Background = Color( 0, 0, 0, 200 ),

    White = Color( 255, 255, 255 ),
    WhiteTransparent = Color( 255, 255, 255, 127 ),
    WhiteOpaque = Color( 255, 255, 255, 32 ),

    Black = Color( 0, 0, 0 ),
    BlackTransparent = Color( 0, 0, 0, 127 ),
    DarkTransparent = Color( 0, 0, 0, 200 ),
    BlackOpaque = Color( 0, 0, 0, 64 ),

    VK = Color( 0, 119, 255 ),
    Youtube = Color( 255, 0, 0 ),
    Discord = Color( 114, 137, 218 ),
    Telegram = Color( 0, 136, 204 ),

    Golden = Color( 255, 185, 0 ),
    GoldenDark = Color( 255, 155, 0 ),

    Likes = Color( 200, 60, 95 ),
};

--
Socials = {
    ["urf_discord"] = {
        icon = "discord",
        label = "Discord",
        color = Colors.Discord,
        url = "https://urf.im/discord"
    },

    ["urf_media"] = {
        icon = "youtube",
        label = "URF Media",
        color = Colors.Youtube,
        url = "https://www.youtube.com/channel/UCrATiSPFbfR1aRV3CsTqPwQ"
    },
};

--
Columns = {
    ["rank"] = {
        order = 0,
        label = "",
        grow = -2 - 1,
        paint = function( this, w, h, data )
            local ply = data["player"];

            local r = ba.ranks.Get( ply:GetRank() ):GetID();

            if this.i_RankID ~= r then
                this.i_RankID, this.m_RankTexture = r, rp.Scoreboard.Utils.Material( "rpui/escmenu/usericons/" .. r );
            end

            surface.SetDrawColor( color_white );
            surface.SetMaterial( this.m_RankTexture );
            surface.DrawTexturedRect( 0, 0, w, h );
        end
    },

    ["avatar"] = {
        order = 10,
        label = "",
        grow = -2 - 1,
        paint = function( this, w, h, data )
            local ply = data["player"];

            if not IsValid( this.m_Avatar ) then
                this.m_Avatar = this:Add( "AvatarImage" );
                this.m_Avatar:SetPaintedManually( true );
                this.m_Avatar:SetMouseInputEnabled( false );

                this._PerformLayout = this._PerformLayout or this.PerformLayout;
                this.PerformLayout = function( me, w, h )
                    me:_PerformLayout( w, h );
                    w, h = me:GetSize();

                    me.m_Avatar:SetSize( h, h );
                    me.m_Avatar:SetPlayer( ply, h * 2 );
                end
            end

            this.m_Avatar:PaintManual();
        end
    },

    ["flag"] = { hidden = true,
        order = 20,
        label = "",
        grow = -2 - 1.5,
        paint = function( this, w, h, data )
            local ply = data["player"];

            if not this.m_Icon then
                this.m_Icon = rp.Scoreboard.Utils.Material( "flags16/" .. ply:GetCountry() .. ".png", "noclamp" );
            end

            local s = math.min( w, h );

            local iw = s * 0.65; -- 0.8;
            local ih = iw * 0.6875;

            surface.SetDrawColor( color_white );
            surface.SetMaterial( this.m_Icon );
            surface.DrawTexturedRect( w * 0.5 - iw * 0.5, h * 0.5 - ih * 0.5 + 1, iw, ih );
        end
    },

    ["name"] = {
        order = 30,
        label = translates.Get("Имя"),
        grow = 2,
        paint = function( this, w, h, data )
            local ply = data["player"];

            if rp.Scoreboard.Utils.RefreshTime() then
                local emoji = ply:GetNickEmoji();
                if emoji then
                    emoji = CHATBOX and CHATBOX.Emoticons and CHATBOX.Emoticons[emoji];

                    if emoji and emoji.url then
                        this.m_PlayerEmoji = CHATBOX.GetDownloadedImage( emoji.url );
                    end
                end

                local afk = ply:GetNetVar( "IsAFK" );
                this.b_PlayerAFK = afk;
            end

            local sp = h * 0.25;
            local x, y = sp, h * 0.5;
            local tw, th = 0, 0;

            if this.m_PlayerEmoji then
                th = h * 0.75;

                surface.SetDrawColor( color_white );
                surface.SetMaterial( this.m_PlayerEmoji );
                surface.DrawTexturedRect( x, y - th * 0.5, th, th );

                x = x + th + sp;
            end

            tw, th = draw.SimpleText( ply:GetName(), "rpui.Fonts.ScoreboardDefault", x, y, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER );

            if this.b_PlayerAFK then
                x = x + sp + tw;

                draw.SimpleText( "(AFK)", "rpui.Fonts.ScoreboardDefault", x, y, Colors.WhiteTransparent, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER );
            end
        end,
    },

    ["team"] = {
        order = 40,
        label = translates.Get("Профессия"),
        align = TEXT_ALIGN_CENTER,
        grow = 4,
        paint = function( this, w, h, data )
            local ply = data["player"];
            draw.SimpleText( ply:GetJobName(), "rpui.Fonts.ScoreboardDefault", w * 0.5, h * 0.5, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
        end,
    },

    ["ping"] = {
        order = 50,
        label = translates.Get("Пинг"),
        grow = -1,
        paint = function( this, w, h, data )
            local ply = data["player"];

            local bars, back = rp.Scoreboard.Utils.GetPing( ply:Ping() );

            local size = h * 0.55;
            local y = h * 0.5 - size * 0.5;
            local x = w - h + y;

            if back then
                surface.SetDrawColor( Colors.DarkTransparent );
                surface.SetMaterial( back );
                surface.DrawTexturedRect( x, y, size, size );
            end

            if bars then
                surface.SetDrawColor( color_white );
                surface.SetMaterial( bars );
                surface.DrawTexturedRect( x, y, size, size );
            end
        end,
    }
};

--
Generic = {
    ["name"] = function( parent, target )
        local pnl = parent:Add( "DButton" );
        pnl:SetFont( "rpui.Fonts.ScoreboardLarge" );
        pnl:SetText( target:GetName() );
        pnl:SizeToContentsY();
        pnl:SizeToContentsX( 2 );

        pnl:SetZPos( 0 );

        pnl.b_NoPadding = true;

        pnl.DoClick = function( this )
            SetClipboardText( this:GetText() );
            rp.Notify( NOTIFY_GENERIC, translates.Get("Никнейм игрока был скопирован!") );
        end

        pnl.Think = function( this )
            local old = this:GetText();
            local new = target:GetName();

            if old ~= new then
                this:SetText( new ); this:SizeToContentsY(); this:SizeToContentsX( 2 );
            end
        end

        pnl.Paint = function( this, w, h )
            draw.SimpleText( this:GetText(), this:GetFont(), 0, 0, this:GetTextColor(), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP );
            return true;
        end
    end,

    ["steamid"] = function( parent, target )
        local t_steamid = target:SteamID();

        local pnl = parent:Add( "DButton" );
        pnl:SetAlpha( 127 );
        pnl:SetFont( "rpui.Fonts.ScoreboardSmallBold" );
        pnl:SetText( t_steamid == "NULL" and "BOT" or t_steamid );
        pnl:SizeToContentsY();
        pnl:SizeToContentsX();
        pnl:SetTextColor( color_white );

        pnl:SetZPos( 10 );

        pnl.DoClick = function( this )
            SetClipboardText( this:GetText() );
            rp.Notify( NOTIFY_GENERIC, translates.Get("SteamID игрока был скопирован!") );
        end

        pnl.Paint = function( this, w, h )
            local tw = draw.SimpleText( this:GetText(), this:GetFont(), 0, 0, this:GetTextColor(), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP );

            if this:IsHovered() then
                surface.SetDrawColor( this:GetTextColor() );
                surface.DrawLine( 0, h - 1, tw, h - 1 );
            end

            return true;
        end
    end,

    ["usergroup"] = function( parent, target )
        local pnl = parent:Add( "rpui.IconLabel" );
        pnl:SetFont( "rpui.Fonts.ScoreboardDefault" );
        pnl:SetText( "User" );
        pnl:SetIcon( rp.Scoreboard.Utils.Material("rpui/escmenu/usericons/1") );
        pnl:SetIconInset( 1.5 );

        pnl:SetZPos( 20 );

        pnl.Think = function( this )
            local r = target:GetRank();
            local rank = ba.ranks.Get(r);

            local old, new = this:GetText(), (rank.NiceName or r);
            if old == new then return end

            this:SetText( new );
            this:SetIcon( rp.Scoreboard.Utils.Material("rpui/escmenu/usericons/" .. rank.ID) );

            this:SizeToContentsY();
        end
    end,

    ["playtime"] = function( parent, target )
        local pnl = parent:Add( "rpui.IconLabel" );
        pnl:SetFont( "rpui.Fonts.ScoreboardDefault" );
        pnl:SetText( "0:00:00" );
        pnl:SetIcon( rp.Scoreboard.Utils.Material("rpui/scoreboard/playtime.png", "smooth noclamp") );

        pnl:SetZPos( 30 );

        pnl.Think = function( this )
            this:SetText( rp.Scoreboard.Utils.FormattedTime(target:GetPlayTime() or 0) );
            this:SizeToContentsY();
        end
    end
};

GenericActions = {
    ["mute"] = function( parent, target )
        local size = draw.GetFontHeight( "rpui.Fonts.ScoreboardDefault" );

        local pnl = parent:Add( "DButton" );
        pnl:SetSize( size, size );
        pnl:SetZPos( 0 );

        pnl.m_Icon = rp.Scoreboard.Utils.Material( target:IsMuted() and "rpui/scoreboard/has_muted.png" or "rpui/scoreboard/not_muted.png", "smooth noclamp" );

        pnl.DoClick = function( this )
            target:SetMuted( not target:IsMuted() );
            this.m_Icon = rp.Scoreboard.Utils.Material( target:IsMuted() and "rpui/scoreboard/has_muted.png" or "rpui/scoreboard/not_muted.png", "smooth noclamp" );
        end

        pnl.Paint = function( this, w, h )
            surface.SetDrawColor( color_white );
            surface.SetMaterial( this.m_Icon );
            surface.DrawTexturedRect( 0, 0, w, h );
            return true;
        end
    end,

    ["likes"] = function( parent, target )
        local size = draw.GetFontHeight( "rpui.Fonts.ScoreboardDefault" );

        local pnl = parent:Add( "rpui.IconLabel" );
        pnl:SetFont( "rpui.Fonts.ScoreboardDefault" );
        pnl:SetText( "0" );
        pnl:SetTall( size );
        pnl:SetIcon( rp.Scoreboard.Utils.Material("rpui/scoreboard/heart.png", "smooth noclamp") );
        pnl:SetIconColor( Colors.Likes );

        pnl:SetZPos( 10 );

        pnl.Think = function( this )
            local old = this:GetText();
            local new = target:GetLikeReacts();

            if old ~= new then
                this:SetText( target:GetLikeReacts() );
                this:SizeToContentsX();
            end
        end
    end
};

Gameplay = {
    ["premium"] = function( parent, target )
        local pnl = parent:Add( "rpui.IconLabel" );
        pnl:Dock( TOP );
        pnl:SetIcon( rp.Scoreboard.Utils.Material("rpui/scoreboard/premium.png", "smooth noclamp") );
        pnl:SetIconColor( Colors.GoldenDark );
        pnl:SetFont( "rpui.Fonts.ScoreboardDefaultBold" );
        pnl:SetText( "URF Premium" );
        pnl:SetTextColor( Colors.Golden );
        pnl:SizeToContentsY();

        pnl:SetZPos( 0 );

        pnl.Access = function( this, target )
            return target:HasPremium();
        end
    end,

    ["org"] = function( parent, target )
        local pnl = parent:Add( "rpui.IconLabel" );
        pnl:Dock( TOP );
        pnl:SetIcon( rp.Scoreboard.Utils.Material("rpui/scoreboard/group.png", "smooth noclamp") );
        pnl:SetFont( "rpui.Fonts.ScoreboardDefault" );
        pnl:SetText( "Organisation" );
        pnl:SizeToContentsY();

        pnl:SetZPos( 10 );

        pnl.Think = function( this )
            this:SetText( target:GetOrg() );
            this:SetIconColor( target:GetOrgColor() );
        end

        pnl.Access = function( this, target )
            return target:GetOrg();
        end
    end
};

--
Commands = {
    -- generic:
    ["profile"] = {
        label = translates.Get( "Профиль Steam" ),
        action = function( pnl, target )
            target:ShowProfile();
        end,
        access = function( pnl, target )
            return not target:IsBot();
        end
    },

    -- roleplay:
    ["demote"] = {
        label = translates.Get( "Уволить" ),
        action = function( pnl, target )
            local t = target:IsBot() and target:GetName() or target:SteamID();

            ui.StringRequest(
                translates.Get("Увольнение") .. " " .. ply:GetName(),
                translates.Get("Введите причину увольнения") .. " " .. ply:GetName() .. ".", "",
                function( reason )
                    RunConsoleCommand( "rp", "demote", t, reason );
                end
            );
        end
    },

    ["wanted"] = {
        label = function( pnl, target )
            return translates.Get(target:IsWanted() and "Снять розыск" or "Подать в розыск");
        end,
        action = function( pnl, target )
            local t = target:IsBot() and target:GetName() or target:SteamID();

            if target:IsWanted() then
                RunConsoleCommand( "do_unwanted", t );
                return
            end

            local m;
            m = rpui.SliderRequestFree( translates.Get("Выберите кол-во звёзд"), "cmenu/order.png", 1.4, 5, function( val )
                if IsValid(m) then m:Close(); end

                ui.StringRequest(
                    translates.Get("Объявление в розыск игрока %s.", ply:GetName()),
                    translates.Get("Напишите причину розыска"), "",
                    function( reason )
                        if #reason < 1 then
                            rp.Notify( NOTIFY_RED, translates.Get("Укажите причину розыска!") );
                            return
                        end

                        RunConsoleCommand( "do_wanted", reason, t, math.Clamp(tonumber(val), 1, 5) );
                    end
                );
            end );
        end,
        access = function( pnl, target )
            return LocalPlayer():IsCP();
        end
    },

    -- administration:
    ["ban"] = {
        label = translates.Get( "Забанить" ),
        action = function( pnl, target )
            local t = target:IsBot() and target:GetName() or target:SteamID();

            local lengths = {
                { translates.Get("%i мин.", 5), "5mi" },
                { translates.Get("%i мин.", 10), "10mi" },
                { translates.Get("%i мин.", 15), "15mi" },
                { translates.Get("%i мин.", 20), "20mi" },
                { translates.Get("%i мин.", 30), "30mi" },
                { translates.Get("%i мин.", 40), "40mi" },
                { translates.Get("%i час.", 1), "1h" }
            };

            local p = draw.GetFontHeight( "rpui.slidermenu.font" );
            local m = vgui.Create( "urf.im/rpui/menus/blank" );
            m:SetSize( ScrW() * 0.3, ScrH() * 0.2 );
            m:Center();
            m:MakePopup();

            m.header:SetIcon( "bubble_hints/gift.png" );
            m.header:SetTitle( translates.Get("Бан") .. ": " .. target:GetName() );
            m.header:SetFont( "rpui.playerselect.title" );
            m.header.IcoSizeMult = 1.5;

            m.workspace:DockPadding( p, p, p, p );

            m.label = vgui.Create( "DLabel", m.workspace );
            m.label:Dock( TOP );
            m.label:DockMargin( 0, 0, 0, p * 0.5 );
            m.label:SetFont( "rpui.slidermenu.font" );
            m.label:SetText( translates.Get("Введите причину бана") );
            m.label:SizeToContentsY();

            m.options = vgui.Create( "Panel", m.workspace );
            m.options:Dock( TOP );
            m.options:SetTall( p * 2 );

            m.options.length = vgui.Create( "DButton", m.options );
            m.options.length:Dock( RIGHT );
            m.options.length:DockMargin( p * 0.5, 0, 0, 0 );
            m.options.length:SetFont( "rpui.slidermenu.font" );
            m.options.length:SetText( lengths[1][1] );
            m.options.length:SetWide( p * 4 );

            m.options.length.Paint = function( this, w, h )
                local baseColor, textColor = rpui.GetPaintStyle( this, STYLE_TRANSPARENT );
                surface.SetDrawColor( baseColor );
                surface.DrawRect( 0, 0, w, h );
                draw.SimpleText( this:GetText(), this:GetFont(), w * 0.5, h * 0.5, textColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
                return true;
            end

            m.options.length.DoClick = function( this )
                this.m_DropDown = vgui.Create( "rpui.DropMenu" );

                local drop = this.m_DropDown;
                drop:SetBase( this );
                drop:SetFont( "rpui.slidermenu.font" );
                drop.Paint = function( p ) draw.Blur( p ); end

                for k, info in ipairs( lengths ) do
                    local o = drop:AddOption( info[1], function()
                        drop:Remove();
                        this:SetText( info[1] );
                    end );

                    o.Paint = function( this, w, h )
                        local baseColor, textColor = rpui.GetPaintStyle( this, STYLE_TRANSPARENT_INVERTED );
                        surface.SetDrawColor( baseColor );
                        surface.DrawRect( 0, 0, w, h );
                        draw.SimpleText( this:GetText(), this:GetFont(), w * 0.5, h * 0.5, textColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
                        return true;
                    end
                end

                drop:Open();

                local x, y = this:LocalToScreen();
                drop:SetPos( x, y + this:GetTall() );
            end

            m.options.reason = vgui.Create( "urf.im/rpui/txtinput", m.options );
            m.options.reason:Dock( FILL );
            m.options.reason:ApplyDesign();
            m.options.reason:SetFont( "rpui.slidermenu.font" );

            m.trigger = vgui.Create( "urf.im/rpui/button", m.workspace );
            m.trigger:Dock( BOTTOM );
            m.trigger:SetText( translates.Get("ЗАБАНИТЬ") );
            m.trigger:SetFont( "rpui.createorg.font" );
            m.trigger:SizeToContentsY( p * 0.5 );
            m.trigger.DoClick = function()
                local reason, banlen = m.options.reason:GetValue(), m.options.length:GetText();

                for k, info in ipairs( lengths ) do
                    if info[1] == banlen then
                        banlen = info[2]; break;
                    end
                end

                if #reason < 1 then
                    rp.Notify( NOTIFY_RED, translates.Get("Ошибка! Причина бана не указана!") );
                    return
                end

                RunConsoleCommand( "urf", "ban", t, banlen, reason );
                m:Close();
            end
        end,
        access = function( pnl, target )
            return LocalPlayer():HasFlag("M");
        end
    },

    ["tp"] = {
        label = translates.Get( "Телепортировать" ),
        action = function( pnl, target )
            RunConsoleCommand( "urf", "tp", target:IsBot() and target:GetName() or target:SteamID() );
        end,
        access = function( pnl, target )
            return LocalPlayer():HasFlag("M");
        end
    },

    ["goto"] = {
        label = translates.Get( "Телепортироваться" ),
        action = function( pnl, target )
            RunConsoleCommand( "urf", "goto", target:IsBot() and target:GetName() or target:SteamID() );
        end,
        access = function(ply, target)
            return LocalPlayer():HasFlag("M");
        end
    },

    ["return"] = {
        label = translates.Get( "Вернуть обратно" ),
        action = function( pnl, target )
            RunConsoleCommand( "urf", "return", target:IsBot() and target:GetName() or target:SteamID() );
        end,
        access = function( ply, target )
            return LocalPlayer():HasFlag("M");
        end
    },

    ["spectate"] = {
        label = function( pnl, target )
            return LocalPlayer():GetNetVar("Spectating") and translates.Get("Прекратить следить") or translates.Get("Следить");
        end,
        action = function( pnl, target )
            if LocalPlayer():GetNetVar("Spectating") then
                RunConsoleCommand( "urf", "spectate" );
                return
            end

            RunConsoleCommand( "urf", "spectate", target:IsBot() and target:GetName() or target:SteamID() );
        end,
        access = function( pnl, target )
            return LocalPlayer():HasFlag("A") and target ~= LocalPlayer();
        end
    }
};

----------------------------------------------------------------

hook.Add( "ConfigLoaded", "rp.Scoreboard::MergeConfig", function()
    table.Merge( rp.Scoreboard.Config, rp.cfg.Scoreboard or {} );

    if rp.cfg.ScoreboardName then -- backwards compatibility
        rp.Scoreboard.Config.Title = rp.cfg.ScoreboardName;
    end
end );

hook.Add( "PopulateScoreboardColumns", "rp.Scoreboard::Columns", function( columns )
    for key, column in pairs( rp.Scoreboard.Config.Columns ) do
        if not column then continue end
        columns[key] = column;
    end
end );

hook.Add( "PopulateScoreboardGeneric", "rp.Scoreboard::Generic", function( items )
    for key, fn in pairs( rp.Scoreboard.Config.Generic ) do
        if not fn then continue end
        items[key] = fn;
    end
end );

hook.Add( "PopulateScoreboardGenericActions", "rp.Scoreboard::GenericActions", function( items )
    for key, fn in pairs( rp.Scoreboard.Config.GenericActions ) do
        if not fn then continue end
        items[key] = fn;
    end
end );

hook.Add( "PopulateScoreboardGameplay", "rp.Scoreboard::Gameplay", function( items )
    for key, fn in pairs( rp.Scoreboard.Config.Gameplay ) do
        if not fn then continue end
        items[key] = fn;
    end
end );

hook.Add( "PopulateScoreboardCommands", "rp.Scoreboard::Commands", function( items )
    for key, command in pairs( rp.Scoreboard.Config.Commands ) do
        if not command then continue end
        items[key] = command;
    end
end );