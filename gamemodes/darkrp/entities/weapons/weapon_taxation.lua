AddCSLuaFile();

SWEP.PrintName      = 'Сбор налогов'
SWEP.Category       = 'Half-Life Alyx RP'
SWEP.Slot           = 0
SWEP.SlotPos        = 1
SWEP.DrawAmmo       = false

SWEP.Spawnable      = true
SWEP.AdminOnly      = true

SWEP.DrawCrosshair  = true
SWEP.UseHands       = true

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo		    = 'none'

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo		    = 'none'

SWEP.Weight			        = 5
SWEP.AutoSwitchTo		    = false
SWEP.AutoSwitchFrom		    = false

SWEP.ViewModel              = Model('')
SWEP.WorldModel             = Model('')

function SWEP:Initialize()
    self:SetHoldType('normal');
end

if (SERVER) then
    function SWEP:Deploy()
        local Owner = self.Owner;
        if (!Owner.TaxCooldown or !istable(Owner.TaxCooldown)) then
            Owner.TaxCooldown = {};
        end
        return true
    end

    function SWEP:PrimaryAttack()
        local Owner = self.Owner;
        if (!IsValid(Owner)) then return end

        local Entity = Owner:GetEyeTrace().Entity;
        if (!IsValid(Entity) or !Entity:IsPlayer()) then return end

        if (Owner:GetPos():DistToSqr(Entity:GetPos()) >= 22500) then return end
        if ((Owner.TaxCooldown[Entity] or 0) > CurTime()) then
            rp.Notify(Owner, NOTIFY_GENERIC, rp.Term('PleaseWaitX'), math.ceil(Owner.TaxCooldown[Entity] - CurTime()));
            return
        end

        if (Entity:GetFaction() == FACTION_CWU) then
            local Pay = math.ceil((Owner:GetSalary() or 0) * .8);
            if (Entity:CanAfford(Pay)) then
                Entity:TakeMoney(Pay);
                Owner:AddMoney(75);
                rp.Notify(Owner, NOTIFY_GENERIC, rp.Term('TaxWeapon_Take'), rp.FormatMoney(20), Entity);
                rp.Notify(Entity, NOTIFY_GENERIC, rp.Term('TaxWeapon_Give'), Owner, rp.FormatMoney(Pay));

                Owner.TaxCooldown[Entity] = CurTime() + 180;
            else
                rp.Notify(Owner, NOTIFY_GENERIC, rp.Term('TaxWeapon_CantTake'), Entity);
                rp.Notify(Entity, NOTIFY_GENERIC, rp.Term('TaxWeapon_CantGive'), rp.FormatMoney(Pay - Entity:GetMoney()));
            end
        else
            rp.Notify(Owner, NOTIFY_GENERIC, rp.Term('TaxWeapon_CWU'));
        end
    end

    function SWEP:SecondaryAttack()
        self.PrimaryAttack(self);
    end
else
    function SWEP:PrimaryAttack() return true end
    function SWEP:SecondaryAttack() return true end
end