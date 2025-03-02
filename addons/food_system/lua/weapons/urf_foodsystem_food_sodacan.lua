SWEP.UrfFood               = true;
SWEP.Category              = "[urf] Еда";

SWEP.AdminOnly             = true;
SWEP.DrawWeaponInfoBox     = false;

SWEP.ViewModelFOV          = 54;
SWEP.UseHands              = true;

SWEP.Slot                  = 1;
SWEP.SlotPos               = 1;

SWEP.Primary.ClipSize      = 5;
SWEP.Primary.DefaultClip   = 5;
SWEP.Primary.Automatic     = false;
SWEP.Primary.Ammo          = "none";

SWEP.Secondary.ClipSize    = -1;
SWEP.Secondary.DefaultClip = -1;
SWEP.Secondary.Automatic   = false;
SWEP.Secondary.Ammo        = "none";

SWEP.Opened                = false;

SWEP.SodacanSkin           = 0;
SWEP.SodacanMats           = {
    [0] = "models/johnmason/food/combine_cola_can",
    [1] = "models/johnmason/food/combine_cola_can2",
    [2] = "models/johnmason/food/combine_cola_can3"
}

-- Настройки:
    SWEP.PrintName             = "Банка Воды";
    SWEP.Spawnable             = true;

    SWEP.ViewModel             = Model("models/johnmason/food/c_combine_cola_can.mdl");
    SWEP.WorldModel            = Model("models/johnmason/food/w_combine_cola_can.mdl");

    SWEP.OpenSound             = Sound("urf_foodsystem/soda_open.wav");
    SWEP.DrinkSound            = Sound("urf_foodsystem/soda_drink.wav");
    SWEP.BurpSound             = Sound("urf_foodsystem/burp.wav");

    SWEP.RestoreHealth         = 0;
    SWEP.RestoreHunger         = 5;
--

if SERVER then
    function SWEP:StartArmAnimation()
		net.Start( "net.foodsystem.InterpolateArm" );
			net.WriteEntity( self );
		net.Broadcast();
	end
end

local InterpolateArm;
if CLIENT then
	InterpolateArm = function( ply, mult )
        if not IsValid(ply) then return end

		local b1 = ply:LookupBone( "ValveBiped.Bip01_R_Upperarm" );
        local b2 = ply:LookupBone( "ValveBiped.Bip01_R_Forearm" );
        
		if (not b1) or (not b2) then return end
        
		ply:ManipulateBoneAngles( b1, Angle(20*mult,-62*mult,10*mult) );
        ply:ManipulateBoneAngles( b2, Angle(-5*mult,-10*mult,0) );
	end

	net.Receive( "net.foodsystem.InterpolateArm", function()
		local wep = net.ReadEntity();

		if IsValid(wep) then
			local ply = wep.Owner;

			if IsValid(ply) and ply:IsPlayer() then
				ply.ArmAnim_StartTime = CurTime();
				ply.ArmAnim_Length    = 3;

				timer.Create( "weapon_armanim" .. ply:EntIndex(), 0, 0, function()
                    if !IsValid(ply) or !IsValid(wep) then
						timer.Remove( "weapon_armanim" .. ply:EntIndex() );
                        InterpolateArm( ply, 0 );
                        return
					end

					if CurTime() > ply.ArmAnim_StartTime + ply.ArmAnim_Length then
						timer.Remove( "weapon_armanim" .. ply:EntIndex() );
                        InterpolateArm( ply, 0 );
                        return
					end

					if ply:GetActiveWeapon() ~= wep then
						timer.Remove( "weapon_armanim" .. ply:EntIndex() );
                        InterpolateArm( ply, 0 );
                        return
					end

					local d = (CurTime() - ply.ArmAnim_StartTime) / ply.ArmAnim_Length;
					InterpolateArm( ply, math.min(math.sin(math.pi*d)*2,1) );
				end );
			end
		end
	end );
end

function SWEP:SetupDataTables()
    self:NetworkVar( "Int", 0, "SodacanSkin" );
end

function SWEP:Initialize()
    self:SetHoldType( "slam" );

    if SERVER then
        if self.SodacanSkin < 0 then
            self:SetSodacanSkin( math.floor(math.Rand(0,2)) );
        else
            self:SetSodacanSkin( self.SodacanSkin );
        end
    end

    self.SodacanSkin = self:GetSodacanSkin();
    self:SetSkin( self.SodacanSkin );
    self:SetSubMaterial( 1, self.SodacanMats[self.SodacanSkin] );
end

function SWEP:PrimaryAttack()
    if SERVER then
        local nHealth, nHunger = self.RestoreHealth, self.RestoreHunger;

        if nHealth then
            nHealth = math.min( self.Owner:GetMaxHealth() - self.Owner:Health(), self.RestoreHealth );
            self.Owner:SetHealth( math.min( self.Owner:GetMaxHealth(), self.Owner:Health() + nHealth ) );
        end

        if nHunger then
            nHunger = math.min( 100 - self.Owner:GetHunger(), self.RestoreHunger );
        
            if IsValid(self.Owner) and self.Owner:GetHunger() < 100 then
                self.Owner:AddHunger( nHunger );
            end
        end
		
        self:StartArmAnimation();
        self:SetClip1( self:Clip1() - 1 );
    end

    if self.Opened then
        if SERVER then
            self.Owner:EmitSound( self.DrinkSound, SNDLVL_60dB );
        end
        self:SendWeaponAnim( ACT_VM_PRIMARYATTACK );
    else
        if SERVER then
            self.Owner:EmitSound( self.OpenSound, SNDLVL_60dB );
        end
        self:SendWeaponAnim( ACT_VM_RELEASE );
        
        self.Opened = true;
    end	
        
    self:SetNextPrimaryFire( CurTime() + self:SequenceDuration() + 0.5 );
    self:SetNextSecondaryFire( CurTime() + self:SequenceDuration() + 0.5 );

	if self.OnUse then
		self:OnUse()
	end
	
    timer.Create( "weapon_idle" .. self:EntIndex(), self:SequenceDuration(), 1, function()
        if IsValid(self) then
            if self:Clip1() > 0 then
                self:SendWeaponAnim( ACT_VM_IDLE );
            else
                self:SendWeaponAnim( ACT_VM_HOLSTER );

                timer.Create( "weapon_holster" .. self:EntIndex(), self:SequenceDuration(), 1, function()
                    if SERVER then
                        self.Owner:EmitSound( self.BurpSound, SNDLVL_60dB );
                    end
                    self:Holster();
                end );
            end
        end
    end );
end

function SWEP:SecondaryAttack()
    self:PrimaryAttack();
end

function SWEP:Holster()
    if CLIENT and self.Owner == LocalPlayer() then
        local vm = LocalPlayer():GetViewModel();
        
        vm:SetSubMaterial(1);
        self.SkinApplied = false;
    end

    if SERVER and self:Clip1() <= 0 and IsValid(self.Owner) then
        self.Owner:StripWeapon( self:GetClass() );
    end

    timer.Stop( "weapon_idle"    .. self:EntIndex() );
    timer.Stop( "weapon_holster" .. self:EntIndex() );

    return true
end

function SWEP:OnRemove()
    timer.Stop( "weapon_idle"    .. self:EntIndex() );
    timer.Stop( "weapon_holster" .. self:EntIndex() );
end

if CLIENT then
    function SWEP:PreDrawViewModel( vm )
        if !self.SkinApplied and self.SodacanSkin >= 0 then
            vm:SetSubMaterial( 1, self.SodacanMats[self.SodacanSkin] );
            
            local entIdx = self:EntIndex();
            timer.Create( "weapon_revertskin" .. entIdx, 0, 0, function()
                if IsValid(self) then
                    if self.Owner:GetActiveWeapon() ~= self then
                        vm:SetSubMaterial( 1 );
                        self.SkinApplied = false;
                        timer.Remove( "weapon_revertskin" .. entIdx );
                    end
                else
                    timer.Remove( "weapon_revertskin" .. entIdx );
                end
            end );

            self.SkinApplied = true;
        end
    end

    function SWEP:DrawWorldModel()
        local owner = self.Owner;
		if IsValid(owner) then
			local offsetVec = Vector( 3, 0.4, -2 );
			local offsetAng = Angle( 0, 90, 160 );

			local b = owner:LookupBone( "ValveBiped.Bip01_R_Hand" );
			if !b then return end

			local m = owner:GetBoneMatrix(b);
			if !m then return end

			local newPos, newAng = LocalToWorld( offsetVec, offsetAng, m:GetTranslation(), m:GetAngles() );

			self:SetRenderOrigin( newPos );
			self:SetRenderAngles( newAng );

			self:SetupBones();
		else
			self:SetRenderOrigin( self:GetPos() );
			self:SetRenderAngles( self:GetAngles() );
		end

		self:DrawModel();
    end

    function SWEP:CustomAmmoDisplay()
        self.AmmoDisplay             = self.AmmoDisplay or {};
        self.AmmoDisplay.Draw        = true;
        self.AmmoDisplay.PrimaryClip = self:Clip1();

        return self.AmmoDisplay
    end
end