-- "gamemodes\\rp_base\\entities\\weapons\\gmod_tool\\stools\\igniter.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
TOOL.Category       = "Construction";
TOOL.Name           = "#tool.igniter.name";

TOOL.Information = {
    { name = "left" },
    { name = "reload" }
};

local Time = 60 * 60 * 24;
local Radius = math.pow(512, 2);
local Whitelist = {
    ["prop_physics"] = false,
    ["prop_physics_multiplayer"] = true,
};

if CLIENT then
    language.Add( "tool.igniter.name", translates.Get("Поджигатель") );
    language.Add( "tool.igniter.desc", translates.Get("Позволяет поджигать пропы") );
    language.Add( "tool.igniter.left", translates.Get("Поджечь проп") );
    language.Add( "tool.igniter.reload", translates.Get("Потушить проп") );
end

nw.Register( "stool_ignited" )
    :Write( function( v )
        net.WriteBool( tobool(v[1]) );
        net.WriteUInt( v[2] or 0, 17 );
    end )
    :Read( function()
        local status = net.ReadBool();
        return {status, status and net.ReadUInt(17) or 0}
    end )
    :SetHook( "OnToolIgnited" )

function TOOL:LeftClick( tr )
    local owner = self:GetOwner();
    if not IsValid( owner ) then return false end

    local ent = tr.Entity;

    if not IsValid( ent ) or not Whitelist[ent:GetClass()] then return false end
    if ent:GetPos():DistToSqr( owner:GetPos() ) > Radius then return false end
    if ent:IsOnFire() then return false end

    if CLIENT then return true end

    if ent == owner.m_igniter_prev then return false end
    if IsValid( owner.m_igniter_prev ) then
        owner.m_igniter_prev:SetNetVar( "stool_ignited", {false, 0} ); -- :Extinguish();
    end

    ent:SetNetVar( "stool_ignited", {true, Time} );
    owner.m_igniter_prev = ent;

    return true
end

function TOOL:Reload( tr )
    local owner = self:GetOwner();
    if not IsValid( owner ) then return false end

    local ent = tr.Entity;

    if not IsValid( ent ) or not Whitelist[ent:GetClass()] then return false end
    if ent:GetPos():DistToSqr( owner:GetPos() ) > Radius then return false end

    if CLIENT then return true end

    if ent ~= owner.m_igniter_prev then return false end

    ent:SetNetVar( "stool_ignited", {false, 0} );
    owner.m_igniter_prev = nil;

    return true
end

if CLIENT then
    hook.Add( "OnToolIgnited", "stool_igniter::ApplyEffects", function( ent, data )
        local status, len = data[1] or false, data[2] or 0;

        local ef = EffectData();
        ef:SetEntity( ent );
        ef:SetMagnitude( status and ((len > 1023) and 0 or len) or 0.0001 );
        util.Effect( "flamepuffs", ef );
    end );

    hook.Add( "NetworkEntityCreated", "stool_igniter::LoadEffects", function( ent )
        timer.Simple( engine.TickInterval() * 5, function()
            if not IsValid( ent ) then return end

            local data = ent:GetNetVar( "stool_ignited" ) or {};
            local status, len = data[1] or false, data[2] or 0;

            if status then
                local ef = EffectData();
                ef:SetEntity( ent );
                ef:SetMagnitude( status and ((len > 1023) and 0 or len) or 0.0001 );
                util.Effect( "flamepuffs", ef );
            end
        end );
    end );
end

--[[
function TOOL:LeftClick(Trace)
    local Owner = self:GetOwner();
    if (!IsValid(Owner)) then return false end

    local Prop = Trace.Entity;
    if (!IsValid(Prop) or !Whitelist[Prop:GetClass()]) then return false end
    if (Prop:GetPos():DistToSqr(Owner:GetPos()) > Radius) then return false end
    if (Prop:IsOnFire()) then return false end

    if (CLIENT) then return true end
    if (Prop == Owner._LastIgnitedProp) then return false end

    if (IsValid(Owner._LastIgnitedProp)) then
        Owner._LastIgnitedProp:Extinguish();
    end

    Owner._LastIgnitedProp = Prop;
    Prop._IgnitedByUser = Owner;
    Prop:Ignite(Time);

    return true
end

function TOOL:Reload(Trace)
    local Owner = self:GetOwner();
    if (!IsValid(Owner)) then return false end

    local Prop = Trace.Entity;
    if (!IsValid(Prop) or !Whitelist[Prop:GetClass()]) then return false end
    if (Prop:GetPos():DistToSqr(Owner:GetPos()) > Radius) then return false end

    if (CLIENT) then return true end
    if (Prop != Owner._LastIgnitedProp) then return false end

    Owner._LastIgnitedProp = nil;
    Prop._IgnitedByUser = nil;
    Prop:Extinguish();

    return true
end
]]--