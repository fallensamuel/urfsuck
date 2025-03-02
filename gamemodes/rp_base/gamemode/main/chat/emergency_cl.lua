-- "gamemodes\\rp_base\\gamemode\\main\\chat\\emergency_cl.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local color_white = Color(235, 235, 235);
local color_prefix = Color(205, 0, 0, 150);

local EmergencyChat = EmergencyChat or {};
EmergencyChat.URL = "http://bot.urf.im:3131/";
EmergencyChat.DisconnectTimeout = 10;

hook.Add( "HUDPaint", "EmergencyChat::Initialize", function()
    hook.Remove( "HUDPaint", "EmergencyChat::Initialize" );
    
    timer.Simple( 30, function()
        hook.Add( "OnConnectionLost", "EmergencyChat::OnConnectionLost", function()
            if timer.Exists( "EmergencyChat::Disconnect" ) then
                timer.Remove( "EmergencyChat::Disconnect" );
            end

            if not IsValid( EmergencyChat.Popup ) then
                EmergencyChat.Popup = vgui.Create( "urf.im/rpui/header" );
                EmergencyChat.Popup:SetTall( rpui.AdaptToScreen(0, 44, {0, .7})[2] );
                EmergencyChat.Popup:SetTitle( translates.Get("Подключение к экстренному чату...") )
                EmergencyChat.Popup:SetIcon( "rpui/misc/alarm.png" );
                EmergencyChat.Popup:SetFont( "rpui.playerselect.title" );
                EmergencyChat.Popup.btn:SetVisible( false );
                EmergencyChat.Popup.IcoSizeMult = 1.35;
                EmergencyChat.Popup:SetAlpha( 0 );

                EmergencyChat.Popup.PerformLayout = function( this, w, h )
                    w, h = w or this:GetWide(), h or this:GetTall();

                    surface.SetFont( this.Font or "DermaDefault" );
                    local tw, th = surface.GetTextSize( this.Title );
                    
                    local border = h / 3;
                    local icon = border * this.IcoSizeMult;

                    if CHATBOX and IsValid( CHATBOX.frame ) then
                        this:SetPos( CHATBOX.frame:GetX(), CHATBOX.frame:GetY() + CHATBOX.frame:GetTall() );
                        this:SetWide( math.max(CHATBOX.frame:GetWide(), tw + icon + border * 3) );
                        this:SetAlpha( CHATBOX.ChatboxOpen and 255 or 0 );
                    end
                end

                EmergencyChat.Popup.Think = function( this )
                    if CHATBOX and IsValid( CHATBOX.frame ) then
                        this:PerformLayout();
                    end
                end
            end

            if not IsValid( EmergencyChat.Handler ) then
                EmergencyChat.Handler = vgui.Create( "DHTML" );
                EmergencyChat.Handler:Hide();
                EmergencyChat.Handler:OpenURL( EmergencyChat.URL );

                EmergencyChat.Handler:AddFunction( "console", "socketchat_message", function( steamid, message )
                    local ply = player.GetBySteamID64( steamid );

                    if IsValid( ply ) then
                        -- CHATBOX:OnPlayerChat( ply, message );

                        local emoji = ply.GetNickEmoji and ply:GetNickEmoji();
                        chat.AddText( color_prefix, "[Экстренный] ", ply:GetJobColor(), emoji and (":" .. emoji .. ": " .. ply:Name()) or ply:Name(), color_white, ": ", message );
                    end
                end );

                EmergencyChat.Handler:AddFunction( "console", "socketchat_connected", function()
                    if IsValid( EmergencyChat.Popup ) and not EmergencyChat.Popup.Connected then
                        EmergencyChat.Popup.Connected = true;
                        EmergencyChat.Popup:SetPos( ScrW(), EmergencyChat.Popup:GetY() );
                        EmergencyChat.Popup:SetTitle( translates.Get("Вы подключены к экстренному чату") );
                        EmergencyChat.Popup:PerformLayout();
                        
                        if CHATBOX and CHATBOX.OpenChatbox then
                            CHATBOX:OpenChatbox();
                        end
                    end
                end );
            end

            hook.Add( "ChatTextSend", "EmergencyChat::ChatHook", function( val )
                if IsValid( EmergencyChat.Handler ) then
                    val = string.JavascriptSafe( val ) or "nil";

                    EmergencyChat.Handler:QueueJavascript( "if (window.SocketChat) { " ..
                        string.format("window.SocketChat.SendMessage('%s');", val) ..
                    " };" );
                end
            end );

            hook.Add( "PlayerBindPress", "EmergencyChat::DisableSayBinds", function( ply, command )
                local alias = input.TranslateAlias( command );
                if alias then command = alias; end

                command = string.lower( command );

                if string.find( command, "say" ) then
                    return true
                end
            end );
        end );

        hook.Add( "OnConnectionRestored", "EmergencyChat::OnConnectionRestored", function()
            hook.Remove( "ChatTextSend", "EmergencyChat::ChatHook" );
            hook.Remove( "PlayerBindPress", "EmergencyChat::DisableSayBinds" );

            if IsValid( EmergencyChat.Popup ) then
                EmergencyChat.Popup:MoveTo( ScrW(), EmergencyChat.Popup:GetY(), 0.25 );
                
                timer.Simple( 0.25, function()
                    if IsValid( EmergencyChat.Popup ) then
                        EmergencyChat.Popup:Remove();
                        EmergencyChat.Popup = nil;
                    end
                end );
            end

            timer.Create( "EmergencyChat::Disconnect", EmergencyChat.DisconnectTimeout, 1, function()
                if IsValid( EmergencyChat.Handler ) then
                    EmergencyChat.Handler:Remove();
                    EmergencyChat.Handler = nil;
                end
            end );
        end );
    end );
end );