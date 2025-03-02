SWEP.Base                    = "urf_foodsystem_ration_base";
SWEP.Category                = "[urf] Еда";
SWEP.AdminOnly               = true;

-- Настройки:
    SWEP.PrintName           = "Рацион - ГО";
    SWEP.Spawnable           = true;

    SWEP.ViewModel           = Model( "models/weapons/c_packatm.mdl" );
    SWEP.WorldModel          = "models/weapons/w_packatm.mdl";

    SWEP.EatingSound         = Sound("urf_foodsystem/nom.wav");
    SWEP.BurpSound           = Sound("urf_foodsystem/burp.wav");

    SWEP.Primary.ClipSize    = 5;
    SWEP.Primary.DefaultClip = 5;

    SWEP.RestoreHealth       = 30;
    SWEP.RestoreHunger       = 40;

    SWEP.RewardFunc          = function() return math.Round(math.Rand(40,60)) end
--

if CLIENT then
    SWEP.WorldCSModel = ClientsideModel( SWEP.WorldModel );
    SWEP.WorldCSModel:SetNoDraw( true );
end