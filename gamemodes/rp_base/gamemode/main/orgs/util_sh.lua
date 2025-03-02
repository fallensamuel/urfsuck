-- "gamemodes\\rp_base\\gamemode\\main\\orgs\\util_sh.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
if SERVER then
    util.AddNetworkString( "rp.orgs.GetList" );

    net.Receive( "rp.orgs.GetList", function( len, ply )
        if not (ply:IsRoot() or ply:HasFlag("e")) then return end

        rp._Stats:Query( "SELECT `Name` from `orgs`;", function( data )
            local out = {};

            for k, row in ipairs( data ) do
                if not row["Name"] then continue end
                out[#out + 1] = row["Name"];
            end

            if #out == 0 then return end

            local data = util.Compress( table.concat(out, ";") );

            net.Start( "rp.orgs.GetList" );
                net.WriteStream( data, ply );
            net.Send( ply );
        end );
    end );
end

if CLIENT then
    net.Receive( "rp.orgs.GetList", function()
        net.ReadStream( function( data )
            local orgs = string.Explode( ";", util.Decompress(data) );
            hook.Run( "OnOrgListReceived", orgs );
        end );
    end );
end