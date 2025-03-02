SWEP.Base                = "urf_foodsystem_ration_base";
SWEP.Category                = "[urf] Еда";
SWEP.AdminOnly               = true;


-- Настройки:
    SWEP.PrintName           = "Рацион - Минимальный";
    SWEP.Spawnable           = true;

    SWEP.ViewModel           = Model( "models/weapons/c_packati.mdl" );
    SWEP.WorldModel          = "models/weapons/w_packati.mdl";

    SWEP.EatingSound         = Sound("urf_foodsystem/nom.wav");
    SWEP.BurpSound           = Sound("urf_foodsystem/burp.wav");

    SWEP.Primary.ClipSize    = 2;
    SWEP.Primary.DefaultClip = 2;

    --SWEP.RestoreHealth       = 1;
    SWEP.RestoreHunger       = 35;

    SWEP.RewardFunc          = function() return math.Round(math.Rand(1,5)) end
--

if CLIENT then
    SWEP.WorldCSModel = ClientsideModel( SWEP.WorldModel );
    SWEP.WorldCSModel:SetNoDraw( true );
end