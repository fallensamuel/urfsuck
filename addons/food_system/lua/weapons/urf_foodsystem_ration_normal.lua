SWEP.Base                    = "urf_foodsystem_ration_base";
SWEP.Category                = "[urf] Еда";
SWEP.AdminOnly               = true;

-- Настройки:
    SWEP.PrintName           = "Рацион - Стандартный";
    SWEP.Spawnable           = true;

    SWEP.ViewModel           = Model( "models/weapons/c_packatc.mdl" );
    SWEP.WorldModel          = "models/weapons/w_packatc.mdl";

    SWEP.EatingSound         = Sound("urf_foodsystem/nom.wav");
    SWEP.BurpSound           = Sound("urf_foodsystem/burp.wav");

    SWEP.Primary.ClipSize    = 3;
    SWEP.Primary.DefaultClip = 3;

    SWEP.RestoreHealth       = 10;
    SWEP.RestoreHunger       = 35;

    SWEP.RewardFunc          = function() return math.Round(math.Rand(10,25)) end
--

if CLIENT then
    SWEP.WorldCSModel = ClientsideModel( SWEP.WorldModel );
    SWEP.WorldCSModel:SetNoDraw( true );
end