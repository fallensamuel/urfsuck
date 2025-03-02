-- "gamemodes\\rp_base\\gamemode\\addons\\auctions\\cl_hooks.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
--local color_prefix = Color( 60, 200, 135 );
local color_prefix = Color( 255, 80, 0);
local color_player = Color( 151, 171, 201 );
local color_chat = Color( 235, 235, 235 );
local color_gray = Color( 156, 156, 156 );

hook.Add( "AuctionLoaded", "auctions::Initialize", function()
    local cv_auction_chat = cvar.Register( "enable_auctionchat" )
        :SetDefault( true )
        :AddMetadata( "State", "RPMenu" )
        :AddMetadata( "Menu", "Включить текстовые оповещения и чат аукциона" )

    local cv_auction_snd = cvar.Register( "enable_auctionsounds" )
        :SetDefault( true )
        :AddMetadata( "State", "RPMenu" )
        :AddMetadata( "Menu", "Включить звуковые оповещения аукциона" )

    CHATBOX:AddMode( translates.Get("Аукцион"), 4, ColorAlpha(color_prefix, 225), "/auc", "[" .. translates.Get("Аукцион") .. "]", translates.Get("<Текст для чата аукциона>"), nil, nil, nil, 6 );

    hook.Add( "PopulateNewF4Tabs", "auctions::F4Tab", function( F4Menu )
        local lot = auctions.lots:GetActive();

        if lot then
            local AuctionPanel = F4Menu:AddTab( translates.Get("Аукцион"), vgui.Create("AuctionPanel"), nil, function( tab )
                local p = tab:GetParent();

                tab:SetFont( "rpui.Fonts.F4Menu.GoldTabButton" );

                tab.Paint = function( this, w, h )
                    local t = SysTime();

                    local baseColor, textColor = rpui.GetPaintStyle( this, STYLE_TRANSPARENT );

                    surface.SetDrawColor( baseColor );
                    surface.DrawRect( 0, 0, w, h );

                    local alpha = 6 + 24 + math.sin(t * 2) * 24;
                    draw.SimpleTextOutlined( this:GetText(), this:GetFont(), w * 0.5, h * 0.5, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 3, ColorAlpha(rpui.UIColors.TextGold, alpha) );

                    return true;
                end

                tab.PaintOver = function( this, w, h )
                    rpui.DrawStencilBorder( this, 0, 0, w, h, 0.06, rpui.UIColors.Gold, rpui.UIColors.BackgroundGold, 255 );
                end

                timer.Simple( 0, function()
                    if not IsValid( p ) then return end

                    local l;

                    for k, t in ipairs( p:GetChildren() ) do
                        t:SetZPos( k ); l = k;
                    end

                    tab:SetZPos( l );
                end );
            end );

            AuctionPanel:SetAuctionLot( lot.id );
        end
    end );

    hook.Add( "OnAuctionBeep", "auctions::Beep", function()
        if not cv_auction_snd:GetValue() then return end
        surface.PlaySound( "buttons/bell1.wav" );
    end );

    hook.Add( "OnAuctionChatMessage", "auctions.chat::Handler", function( message )
        if not cv_auction_chat:GetValue() then return end
        local tbl = { color_prefix, "[" .. translates.Get("Аукцион") .. "] ", color_chat };

        if message.steamid then
            tbl[#tbl + 1] = ":" .. message.server_id .. ": ";
            tbl[#tbl + 1] = color_player;
            tbl[#tbl + 1] = message.name or message.steamid;
            tbl[#tbl + 1] = color_chat;
            tbl[#tbl + 1] = ": ";
        end

        local msg = string.Explode( "$", message.text );
        local args = message.args or {};
        local arg_c = #msg;

        for k = 1, arg_c do
            local v = msg[k];
            local a = args[k];

            tbl[#tbl + 1] = v;

            if a then
                tbl[#tbl + 1] = color_prefix;
                tbl[#tbl + 1] = tostring( a );
                tbl[#tbl + 1] = color_chat;
                continue
            end

            if k < arg_c then
                tbl[#tbl + 1] = "$";
            end
        end

        if LocalPlayer():IsAdmin() and message.steamid and message.steamid ~= "0" then
            MsgC( color_gray, "[" .. util.SteamIDFrom64(message.steamid) .. "] " );
        end

        chat.AddText( unpack(tbl) );
    end );

    hook.Add( "InitPostEntity", "auctions.utils::SyncTime", function()
        auctions.networking:RequestTime();
    end );
end );