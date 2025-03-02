-- "gamemodes\\darkrp\\entities\\entities\\ent_soulaltar\\shared.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
ENT.Base            = "base_anim";
ENT.PrintName       = "Алтарь Греха";
ENT.Author          = "bbqmeowcat @ urf.im";
ENT.Category        = "S.T.A.L.K.E.R.";
ENT.Spawnable       = false;
ENT.AdminOnly       = true;
ENT.RenderGroup     = RENDERGROUP_TRANSLUCENT;

ENT.IsSoulAltar     = true;
ENT.ThinkRate       = 1 / 2;
ENT.KillCooldown    = 60 * 10;

ENT.CollisionBounds = {
    Vector(-1, -1, -2), Vector(1, 1, 2)
};

ENT.TriggerBoundsWS = {
    ["rp_stalker_urfim"] = {
        Vector(-4718.455078, 13249.564453, -528.471863),
        Vector(-4210.039063, 13565.965820, -367.093109)
    }
};

game.AddParticles( "particles/fire_01.pcf" );
PrecacheParticleSystem( "fire_small_02" );

function ENT:SetupDataTables()
    self:NetworkVar( "Int", 0, "Souls" );
end