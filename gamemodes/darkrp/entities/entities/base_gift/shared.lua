-- "gamemodes\\darkrp\\entities\\entities\\base_gift\\shared.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
ENT.IsGift      = true;
ENT.Base        = "base_anim";
ENT.PrintName   = "Gift (base)";
ENT.Author      = "urf.im @ bbqmeowcat";
ENT.Category    = "Gifts";
ENT.Spawnable   = false;
ENT.AdminOnly   = true;
ENT.RenderGroup = RENDERGROUP_TRANSLUCENT;

ENT.Models = {
    Model( "models/balloons/balloon_classicheart.mdl" )
};

ENT.Sounds = {
    ["pickup"]  = Sound( "items/gift_pickup.wav" ),
    ["respawn"] = Sound( "items/gift_drop.wav" )
};

ENT.NoclipProtect = 60;
ENT.Cooldown = 60;

function ENT:GetGiftModel()
    local mdls = istable( self.Models ) and self.Models or { self.Models };
    return mdls[math.random(#mdls)];
end

function ENT:GetGiftSound( t )
    local snds = (self.Sounds or {})[t];
    if not snds then return snd_null; end
    snds = istable( snds ) and snds or { snds };
    return snds[math.random(#snds)];
end

function ENT:SetupDataTables()
    self:NetworkVar( "Bool", 0, "Active" );

    self:NetworkVarNotify( "Active", function( ent, name, old, new )
        if old ~= new then ent:OnActiveChanged( old, new ); end
    end );
end

function ENT:OnActiveChanged( old, new )
    if new then self:OnRespawn(); end
end

function ENT:OnTouched( ply )
end

function ENT:OnRespawn()
end