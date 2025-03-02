SWEP.Base                  = "urf_foodsystem_food_sodacan";

SWEP.UrfFood               = true;
SWEP.Category              = "[urf] Еда";

SWEP.AdminOnly             = true;
SWEP.DrawWeaponInfoBox     = false;

SWEP.ViewModelFOV          = 54;
SWEP.UseHands              = true;

SWEP.Slot                  = 1;
SWEP.SlotPos               = 1;

SWEP.Primary.ClipSize      = 2;
SWEP.Primary.DefaultClip   = 5;
SWEP.Primary.Automatic     = false;
SWEP.Primary.Ammo          = "none";

SWEP.Secondary.ClipSize    = -1;
SWEP.Secondary.DefaultClip = -1;
SWEP.Secondary.Automatic   = false;
SWEP.Secondary.Ammo        = "none";

SWEP.SodacanSkin           = 2;
SWEP.SodacanMats           = {
    [0] = "models/johnmason/food/combine_cola_can",
    [1] = "models/johnmason/food/combine_cola_can2",
    [2] = "models/johnmason/food/combine_cola_can3"
}

-- Настройки:
    SWEP.PrintName             = "Банка пива";
    SWEP.Spawnable             = true;

    SWEP.ViewModel             = Model("models/johnmason/food/c_combine_cola_can.mdl");
    SWEP.WorldModel            = Model("models/johnmason/food/w_combine_cola_can.mdl");

    SWEP.OpenSound             = Sound("urf_foodsystem/soda_open.wav");
    SWEP.DrinkSound            = Sound("urf_foodsystem/soda_drink.wav");
    SWEP.BurpSound             = Sound("urf_foodsystem/burp.wav");

    SWEP.RestoreHealth         = 0;
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
