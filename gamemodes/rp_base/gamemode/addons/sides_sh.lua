-- "gamemodes\\rp_base\\gamemode\\addons\\sides_sh.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
----------------------------------------------------------------
nw.Register( "side" )
    :Write(net.WriteUInt, 6)
    :Read(net.ReadUInt, 6)
    :SetPlayer()


----------------------------------------------------------------
local PLAYER = FindMetaTable( "Player" );

function PLAYER:SetSide( s )
    self:SetNetVar( "side", s );
end

function PLAYER:GetSide()
    return self:GetNetVar( "side" ) or 0
end

function PLAYER:GetSideTable()
    return rp.Sides[self:GetSide()]
end


----------------------------------------------------------------
rp.Sides = {};

function rp.AddSide( tbl )
    tbl.side = #rp.Sides + 1;

    rp.Sides[tbl.side] = tbl;
    return tbl.side
end


----------------------------------------------------------------
hook.Add( "playerCanChangeTeam", "rp.Sides::CanChangeTeam", function( ply, tid, force )
    if force then return end

    local t = rp.teams[tid];

    if t.side and ply:GetSide() and (ply:GetSide() ~= t.side) then
        --rp.Notify( ply, NOTIFY_ERROR, translates.Get("Вы не можете выбрать профессию другой стороны") );
        return false
    end
end );