-- "gamemodes\\rp_base\\gamemode\\main\\menus\\scoreboard\\data_sh.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
nw.Register( "OS" )
    :Write( net.WriteUInt, 2 )
    :Read( net.ReadUInt, 2 )
    :SetPlayer()

nw.Register( "Country" )
    :Write( net.WriteString )
    :Read( net.ReadString )
    :SetPlayer()

local OS_Translations = {
    [1] = "windows", [2] = "osx", [3] = "linux"
};

if CLIENT then
    require( "geoip" );

    net.Receive( "rp.ScoreboardStats", function()
        geoip.Get( net.ReadString(), function( info )
            net.Start( "rp.ScoreboardStats" );
                net.WriteString( (info and info.countryCode) or "RU" );

                local o = 1;

                if system.IsWindows() then
                    o = 1;
                elseif system.IsLinux() then
                    o = 2;
                else
                    o = 3;
                end

                net.WriteUInt( o, 2 );
            net.SendToServer();
        end );
    end );
end

local PLAYER = FindMetaTable( "Player" );

function PLAYER:GetOS()
    return OS_Translations[self:GetNetVar("OS") or 1] or "windows";
end

function PLAYER:GetCountry()
    return self:GetNetVar("Country") or "RU";
end
