SWEP.Base = "weapon_heists_lootbag_base";


-- Настройки:  
    SWEP.PrintName     = "Сумка (обычная)";
    SWEP.Category      = "[urf] Ограбления";

    SWEP.Spawnable     = true;
    SWEP.AdminOnly     = true;

    SWEP.ValueCapacity = rp.cfg.Heists and rp.cfg.Heists.BagCapacity or 3000;
    SWEP.TakeAmount    = rp.cfg.Heists and rp.cfg.Heists.BagAmountPerUse or 300;
