SWEP.Base                    = "urf_foodsystem_ration_base";
SWEP.Category                = "[urf] Еда";
SWEP.AdminOnly               = true;

-- Настройки:
    SWEP.PrintName           = "Рацион - Увеличенный";
    SWEP.Spawnable           = true;

    SWEP.ViewModel           = Model( "models/weapons/c_packatl.mdl" );
    SWEP.WorldModel          = "models/weapons/w_packatl.mdl";

    SWEP.EatingSound         = Sound("urf_foodsystem/nom.wav");
    SWEP.BurpSound           = Sound("urf_foodsystem/burp.wav");

    SWEP.Primary.ClipSize    = 4;
    SWEP.Primary.DefaultClip = 4;

    SWEP.RestoreHealth       = 25;
    SWEP.RestoreHunger       = 40;

    SWEP.RewardFunc          = function() return math.Round(math.Rand(30,50)) end
--

if CLIENT then
    SWEP.WorldCSModel = ClientsideModel( SWEP.WorldModel );
    SWEP.WorldCSModel:SetNoDraw( true );
end