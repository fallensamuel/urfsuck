SWEP.Base                    = "urf_foodsystem_food_base";
SWEP.Category                = "[urf] Еда";
SWEP.AdminOnly               = true;


-- Настройки:
    SWEP.PrintName           = "Хлеб";
    SWEP.Spawnable           = true;

    SWEP.ViewModel           = Model( "models/bioshockinfinite/c_loaf_bread.mdl" );
    SWEP.WorldModel          = "models/bioshockinfinite/dread_loaf.mdl";

    SWEP.EatingSound         = Sound("urf_foodsystem/nom.wav");
    SWEP.BurpSound           = Sound("urf_foodsystem/burp.wav");

    SWEP.Primary.ClipSize    = 3;
    SWEP.Primary.DefaultClip = 3;

    SWEP.RestoreHealth       = 10;
    SWEP.RestoreHunger       = 35;

    SWEP.RewardFunc          = nil;
--

if CLIENT then
    SWEP.WorldCSModel = ClientsideModel( SWEP.WorldModel );
    SWEP.WorldCSModel:SetNoDraw( true );

    function SWEP:WorldModelRenderOffset()
        return Vector(-1.5,-4.25,4), Angle(80,0,180);
    end
end