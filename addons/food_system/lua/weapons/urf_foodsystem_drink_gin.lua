SWEP.Base                  = "urf_foodsystem_drink_base";

SWEP.UrfFood               = true;
SWEP.Category              = "[urf] Еда";

SWEP.AdminOnly             = true;
SWEP.DrawWeaponInfoBox     = false;

SWEP.ViewModelFOV          = 54;
SWEP.UseHands              = true;

SWEP.Slot                  = 1;
SWEP.SlotPos               = 1;

SWEP.Primary.ClipSize      = 3;
SWEP.Primary.DefaultClip   = 5;
SWEP.Primary.Automatic     = false;
SWEP.Primary.Ammo          = "none";

SWEP.Secondary.ClipSize    = -1;
SWEP.Secondary.DefaultClip = -1;
SWEP.Secondary.Automatic   = false;
SWEP.Secondary.Ammo        = "none";


-- Настройки:
    SWEP.PrintName             = "Джин Победа";
    SWEP.Spawnable             = true;

    SWEP.ViewModel             = Model("models/bioshockinfinite/gin_bottle.mdl");
    SWEP.WorldModel            = Model("models/bioshockinfinite/jin_bottle.mdl");

    SWEP.OpenSound             = Sound("urf_foodsystem/soda_open.wav");
    SWEP.DrinkSound            = Sound("urf_foodsystem/soda_drink.wav");
    SWEP.BurpSound             = Sound("urf_foodsystem/burp.wav");

    SWEP.RestoreHealth         = 20;
    SWEP.RestoreHunger         = 20;
--

if SERVER then
	function SWEP:OnUse()
		timer.Simple(self:SequenceDuration() - 0.6, function()
			if self and IsValid(self.Owner) then
				self.Owner:AddHigh('Alcohol')
			end
		end)
	end
end

if CLIENT then
    function SWEP:WorldModelRenderOffset()
        return Vector(3.5,-1.75,9), Angle(180,180,0);
    end
end