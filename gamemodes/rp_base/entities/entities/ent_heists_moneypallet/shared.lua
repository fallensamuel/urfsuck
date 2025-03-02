-- "gamemodes\\rp_base\\entities\\entities\\ent_heists_moneypallet\\shared.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
ENT.Type           = "anim";
ENT.Base           = "base_gmodentity";
 
ENT.PrintName      = "Поддон с деньгами";
ENT.Category       = "[urf] Ограбления";

ENT.Spawnable      = false;
ENT.AdminSpawnable = false;

ENT.MoneyLimit = 0;

function ENT:GetMoney()
    return self:GetNWInt( "money" );
end