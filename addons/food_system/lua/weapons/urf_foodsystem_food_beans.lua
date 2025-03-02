SWEP.Base                    = "urf_foodsystem_food_base";
SWEP.Category                = "[urf] Еда";
SWEP.AdminOnly               = true;


-- Настройки:
    SWEP.PrintName           = "Бобы";
    SWEP.Spawnable           = true;

    SWEP.ViewModel           = Model( "models/bioshockinfinite/c_peanuts_bag.mdl" );
    SWEP.WorldModel          = "models/bioshockinfinite/rag_of_peanuts.mdl";

    SWEP.EatingSound         = Sound("urf_foodsystem/nom.wav");
    SWEP.BurpSound           = Sound("urf_foodsystem/burp.wav");

    SWEP.Primary.ClipSize    = 4;
    SWEP.Primary.DefaultClip = 4;

    SWEP.RestoreHealth       = 10;
    SWEP.RestoreHunger       = 35;

    SWEP.RewardFunc          = nil;
--

if CLIENT then
    SWEP.WorldCSModel = ClientsideModel( SWEP.WorldModel );
    SWEP.WorldCSModel:SetNoDraw( true );

    function SWEP:WorldModelRenderOffset()
        return Vector(6,-4,-0.5), Angle(0,90,-120);
    end
end