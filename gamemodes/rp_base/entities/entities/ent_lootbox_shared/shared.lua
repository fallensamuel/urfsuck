-- "gamemodes\\rp_base\\entities\\entities\\ent_lootbox_shared\\shared.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
ENT.Base            = "ent_lootbox";
ENT.PrintName       = "Lootbox (Shared)";
ENT.Category        = "RP";
ENT.Spawnable       = true;
ENT.AdminOnly       = true;


ENT.TimeToRemove = 15;

ENT.DemoSwapDelay   = 60 * 60; -- Меняем раз в час при деморежиме
ENT.DemoUseCooldown = 60 * 60 * 24; -- Игрок может открыть уникальный демокейс раз в 1 день

ENT.BOXMODE_SHARED   = 0;
ENT.BOXMODE_DEMO     = 1;
ENT.BOXMODE_REDIRECT = 2;


function ENT:SetupDataTables()
    self:NetworkVar( "Float", 0, "RouletteLength" );
    self:NetworkVar( "Float", 1, "RouletteTime" );

    self:NetworkVar( "Int", 0, "Reward" );
    self:NetworkVar( "Int", 1, "BoxMode" );

    self:NetworkVar( "String", 0, "BoxUID" );

    self:NetworkVar( "Bool", 0, "Ending" );
end