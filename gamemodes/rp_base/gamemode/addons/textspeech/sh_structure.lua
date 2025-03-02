-- "gamemodes\\rp_base\\gamemode\\addons\\textspeech\\sh_structure.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
rp.TextSpeech = rp.TextSpeech or {};

rp.TextSpeech.Voices = {
    List = {}, Map = {}
};

----------------------------------------------------------------
hook.Add( "ConfigLoaded", "rp.TextSpeech.Config", function()
    rp.TextSpeech.Disabled = tobool( rp.cfg.DisableTextSpeech );
end );

----------------------------------------------------------------
local function encode( link )
    return string.gsub( string.gsub(link, "[^%w _~%.%-]", function( str )
        str = string.format( "%X", string.byte(str) );
        return "%" .. ((#str == 1) and "0" or "") .. str;
    end), " ", "+" );
end

----------------------------------------------------------------
local VOICE = {};

VOICE.__APIHandlers = {
    ["default"] = function( api, args )
        local link = string.gsub( api, "{$([%w_]+)}", function( match )
            return args[match] and encode(args[match]) or "";
        end );

        return false, link;
    end
};

function VOICE:GetID()
    return self.id;
end

function VOICE:GetName()
    return self.name;
end

function VOICE:GetAPI()
    return self.api;
end

function VOICE:SetAPI( api )
    self.api = api;
    return self;
end

function VOICE:GetCheck()
    return self.check;
end

function VOICE:SetCheck( fn )
    self.check = fn;
    return self;
end

function VOICE:GetDefault()
    return self.default;
end

function VOICE:SetDefault( status )
    self.default = status;
    return self;
end

function VOICE:API( args )
    local handler = self.__APIHandlers[TypeID(self.api)] or self.__APIHandlers["default"];
    return handler( self.api, args );
end

function VOICE:Check( ply )
    if not self.check then
        return true
    end

    local status, message = self.check( ply );
    return tobool( status ), message;
end

----------------------------------------------------------------
function rp.TextSpeech:GetVoices()
    return self.Voices.List;
end

function rp.TextSpeech:GetAvailableVoices( ply )
    ply = CLIENT and LocalPlayer() or ply;

    local available = {};

    for name, voice in pairs( self.Voices.List ) do
        if not voice:Check( ply ) then continue end
        available[name] = voice;
    end

    return available;
end

function rp.TextSpeech:GetVoice( name )
    return self.Voices.List[name];
end

function rp.TextSpeech:GetVoiceByID( id )
    return self.Voices.Map[id];
end

function rp.TextSpeech:RegisterVoice( name )
    if self.Voices.List[name] then
        return self.Voices.List[name];
    end

    local voice = setmetatable( {}, {__index = VOICE} );
    voice.id = table.insert( self.Voices.Map, voice );
    voice.name = name;

    self.Voices.List[name] = voice;

    return self.Voices.List[name];
end

----------------------------------------------------------------
rp.TextSpeech:RegisterVoice( translates.Get("Мужской (стандартный)") )
    :SetAPI( "https://tts.voicetech.yandex.net/tts?speaker=ermil&text={$message}" )
    :SetDefault( true )

rp.TextSpeech:RegisterVoice( translates.Get("Женский (стандартный)") )
    :SetAPI( "https://tts.voicetech.yandex.net/tts?speaker=alyss&text={$message}" )

rp.TextSpeech:RegisterVoice( translates.Get("Мужской (Захар)") )
    :SetAPI( "https://tts.voicetech.yandex.net/tts?speaker=zahar&text={$message}" )
    :SetCheck( function( ply )
        return ply:HasUpgrade( "voicepack" );
    end )

rp.TextSpeech:RegisterVoice( translates.Get("Женский (Оксана)") )
    :SetAPI( "https://tts.voicetech.yandex.net/tts?speaker=oksana&text={$message}" )
    :SetCheck( function( ply )
        return ply:HasUpgrade( "voicepack" );
    end )

rp.TextSpeech:RegisterVoice( translates.Get("Женский (Джейн)") )
    :SetAPI( "https://tts.voicetech.yandex.net/tts?speaker=jane&text={$message}" )
    :SetCheck( function( ply )
        return ply:HasUpgrade( "voicepack" );
    end )

rp.TextSpeech:RegisterVoice( translates.Get("Женский (Омаж)") )
    :SetAPI( "https://tts.voicetech.yandex.net/tts?speaker=jane&text={$message}" )
    :SetCheck( function( ply )
        return ply:HasUpgrade( "voicepack" );
    end )