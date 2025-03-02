-- "gamemodes\\rp_base\\entities\\entities\\base_urf_radio\\sh_vkplayer.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
----------------------------------------------------------------
VKPlayer = VKPlayer or {};

VKPlayer.Settings = {};
VKPlayer.Settings.Service = "http://api.urf.im/handler/player/";
VKPlayer.Settings.Muted   = false;
VKPlayer.Settings.Debug   = GetConVar( "developer" );
VKPlayer.Settings.Folder  = "vkplayer";
----------------------------------------------------------------

if CLIENT then
    file.CreateDir( VKPlayer.Settings.Folder );
end

VKPlayer.DebugMessage = function( self, ... )
    if SERVER then return end
    if not VKPlayer.Settings.Debug:GetBool() then return end
    
    MsgC( 
        Color(153,153,153), "[",
        Color(0,119,255), "VKPlayer",
        Color(153,153,153), "] ",
        Color(255,255,255), ...
    .. "\n" );
end

VKPlayer.SolveCaptcha = function( self, sid, img, query, callback )
    if SERVER then return end

    if IsValid( self.CaptchaFrame ) then
        self.CaptchaFrame:Remove();
    end

    self.CaptchaFrame = vgui.Create( "rpui.VKPlayer_CaptchaSolver" );
    self.CaptchaFrame:SetCaptchaURL( img );
    self.CaptchaFrame:SetCallback( function( solve )
        self:Query( query .. ("&c_sid=" .. sid) .. ("&c_key=" .. solve), callback );
    end );
end

VKPlayer.Query = function( self, query, callback )
    self:DebugMessage( "Querying: " .. query );

    http.Fetch( self.Settings.Service .. query,
        function( res )
            self:DebugMessage( "Query successful!" );

            local out = self:Parse( res, query, callback );

            if table.Count( out ) > 0 then
                callback( out );
            end
        end,
        
        function( err )
            self:DebugMessage( "Query error: " .. err );
        end
    );
end

VKPlayer.Parse = function( self, data, query, callback )
    local out = util.JSONToTable( data or "" ) or {};

    if out[1] and (out[1].id == "captcha") then
        local captcha = out[1];
        self:SolveCaptcha( captcha.sid, captcha.img, query, callback );
        out = {};
    end

    return out;
end

VKPlayer.Search = function( self, query, callback )
    self:Query( "?q=".. query, callback );
end

VKPlayer.Play = function( self, id, callback )
    if (VKPlayer.PlaybackID or "") ~= id then
        VKPlayer.PlaybackID = id;
        VKPlayer.PlaybackTries = 3;
    end

    local snd_path = VKPlayer.Settings.Folder .. "/" .. id .. ".mp3";
    local snd = file.Exists( snd_path, "DATA" );

    if not snd then
        self:DebugMessage( "Downloading!: id: " .. id );

        http.Fetch( self.Settings.Service .. "?p=" .. id, function( res )
            self:DebugMessage( "Downloaded!: .mp3:", snd_path, "length:", #res );

            file.Write( snd_path, res );
            VKPlayer:Play( id, callback );
        end );

        return
    end

    self:DebugMessage( "Playing id: " .. id );
    sound.PlayFile( "data/" .. snd_path, "3d noplay noblock", function( station, code, err )
        if not IsValid( station ) then
            file.Delete( snd_path );

            if VKPlayer.PlaybackTries > 0 then
                VKPlayer.PlaybackTries = VKPlayer.PlaybackTries - 1;
                self:DebugMessage( "Download failed! Tries left: " .. VKPlayer.PlaybackTries );

                VKPlayer:Play( id, callback );

                return
            end

            self:DebugMessage( "Error!: NotValidStation " .. id );
            return
        end

        if callback then
            callback( station, id );
        end
    end );
end
