-- "gamemodes\\rp_base\\gamemode\\addons\\textspeech\\cl_core.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
rp.TextSpeech = rp.TextSpeech or {};

rp.TextSpeech.Channels = {};

----------------------------------------------------------------
local cv_enabled = CreateConVar( "textspeech_enabled", 1, bit.bor(FCVAR_ARCHIVE,  FCVAR_USERINFO), "Enables TextSpeech module" );

local cv_textspeech_enabled = cvar.Register("textspeech_enabled"):SetDefault(true):AddMetadata("State", "RPMenu"):AddMetadata("Menu", "Озвучивать мои сообщения в чате"):AddCallback( function( old, new )
    cv_enabled:SetBool( new );
end );

cv_textspeech_enabled:SetValue( cv_enabled:GetBool() );

local cv_textspeech_vol = cvar.Register("textspeech_vol"):SetDefault(0.75):AddMetadata("State", "RPMenu"):AddMetadata("Menu", "Громкость озвучивания сообщений чата"):AddMetadata("Type", "number");

----------------------------------------------------------------
function rp.TextSpeech:GetCookieID()
    return "TextSpeech-" .. rp.cfg.ServerUID;
end

function rp.TextSpeech:SelectVoice( voice )
    if not (voice and voice.id) then return end

    net.Start( "TextSpeech" );
        net.WriteUInt( voice:GetID(), 6 );
    net.SendToServer();

    cookie.Set( self:GetCookieID(), voice:GetName() );
end

function rp.TextSpeech:Play( ent, link, volume )
    if self.Channels[ent] then
        return
    end

    sound.PlayURL( link, "3d noblock", function( ch, err, err_name )
        if err or not IsValid( ch ) then
            return
        end

        local fade_min, fade_max = 512, 1024;
        local fade_amp = fade_min * volume;

        ch:SetVolume( volume * cv_textspeech_vol:GetValue() );
        ch:Set3DFadeDistance( fade_min + fade_amp, fade_max + fade_amp );

        self.Channels[ent] = ch;
    end );
end

----------------------------------------------------------------
net.Receive( "TextSpeech", function()
    local ply = net.ReadEntity();
    if not IsValid( ply ) then return end

    local link = net.ReadString();
    local volume = net.ReadFloat();

    rp.TextSpeech:Play( ply, link, volume );
end );

----------------------------------------------------------------
hook.Add( "PreRender", "rp.TextSpeech::HandleSounds", function()
    if rp.TextSpeech.Disabled then return end

    for ply, ch in pairs( rp.TextSpeech.Channels ) do
        if not IsValid( ply ) or not IsValid( ch ) then
            rp.TextSpeech.Channels[ply] = nil;
            continue
        end

        if ch:GetState() < 1 then
            rp.TextSpeech.Channels[ply] = nil;
            continue
        end

        ch:Set3DFadeDistance( 256, 512 );
        ch:SetPos( ply:GetShootPos() );
    end
end );

hook.Add( "InitPostEntity", "rp.TextSpeech::Initialize", function()
    if rp.TextSpeech.Disabled then return end

    local name = cookie.GetString( rp.TextSpeech:GetCookieID() );

    if not name then
        for n, voice in pairs( rp.TextSpeech:GetAvailableVoices(LocalPlayer()) ) do
            if not voice:GetDefault() then continue end
            name = n; break
        end
    end

    if not name then return end

    local voice = rp.TextSpeech:GetVoice( name );
    if not voice then return end

    rp.TextSpeech:SelectVoice( voice );
end );

----------------------------------------------------------------
print( SysTime(), translates.Get("Действия"), translates.Get("Голос") );

rp.AddContextCommand( translates.Get("Действия"), translates.Get("Голос"),
    function( parent )
        local m = vgui.Create( "rpui.DropMenu" );
        m:SetBase( parent );
        m:SetFont( "Context.DermaMenu.Label" );
        m:SetSpacing( ScrH() * 0.01 );
        m.Paint = function( this, w, h ) draw.Blur( this ); end

        for name, voice in pairs( rp.TextSpeech:GetAvailableVoices() ) do
            local option = m:AddOption( name, function( this )
                if this.Selected then return end
                rp.TextSpeech:SelectVoice( voice );
            end );

            option.Paint = function( this, w, h )
                this.Selected = (LocalPlayer():GetNetVar("TextSpeech") or -1) == voice:GetID();

                local baseColor, textColor = rpui.GetPaintStyle( this, STYLE_TRANSPARENT_SELECTABLE );
                surface.SetDrawColor( baseColor );
                surface.DrawRect( 0, 0, w, h );
                draw.SimpleText( this:GetText(), this:GetFont(), this.Spacing, h * 0.5, textColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER );
                return true;
            end
        end

        m:Open();
    end,

    function()
        if rp.TextSpeech.Disabled then
            return false;
        end

        local voices = rp.TextSpeech:GetAvailableVoices();

        if not next( voices ) then
            return false;
        end

        return true;
    end,

    "cmenu/chat"
);