-- "gamemodes\\darkrp\\entities\\weapons\\weapon_wep_buyer.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
AddCSLuaFile();

----------------------------------------------------------------
SWEP.PrintName                  = "Скупщик оружия";
SWEP.Author                     = "urf.im @ bbqmeowcat";
SWEP.Purpose                    = "Принимай оружие у игроков и получай деньги. Прибыль игрока увеличивается на 20%. Чтобы принять товар, игрок должен держать его в руках.";
SWEP.Category                   = "Personal weapons";

SWEP.Spawnable                  = true;
SWEP.AdminOnly                  = true;

SWEP.WorldModel                 = "";
SWEP.ViewModel                  = "models/weapons/c_arms_citizen.mdl";
SWEP.HoldType                   = "normal";
SWEP.UseHands                   = true;

SWEP.Primary.ClipSize           = -1;
SWEP.Primary.DefaultClip        = -1;
SWEP.Primary.Automatic          = true;
SWEP.Primary.Ammo               = "none";

SWEP.Secondary.ClipSize         = -1;
SWEP.Secondary.DefaultClip      = -1;
SWEP.Secondary.Automatic        = true;
SWEP.Secondary.Ammo             = "none";

SWEP.Slot                       = 0;
SWEP.SlotPos                    = 4;
SWEP.DrawAmmo                   = false;

SWEP.BuyerProfitRatio           = 0.2;
SWEP.SellerProfitRatio          = 0.7;


----------------------------------------------------------------
function SWEP:Initialize()
    self:SetHoldType( self.HoldType );
end

function SWEP:IsValidTradableEntity( ent )
    if not IsValid( ent ) then return false end

    local c = ent.uniqueID;
    if not c then return false end

    return rp.item.shop.weapons_assoc[c]
end

function SWEP:Attack()
    local CT = CurTime();

    self:SetNextPrimaryFire( CT + 2 );
    self:SetNextSecondaryFire( CT + 2 );

    if CLIENT then return end

    local buyer = self:GetOwner();
    
    local tr = util.TraceLine( {
        start  = buyer:EyePos(),
        endpos = buyer:EyePos() + buyer:EyeAngles():Forward() * 100,
        filter = buyer
    } );

    local wepitem = self:IsValidTradableEntity( tr.Entity );
    if not wepitem then return end

    local price = wepitem.unit_price and wepitem.unit_price or wepitem.price;
    if not price then return end

    local seller = tr.Entity.holder;
    if not IsValid(seller) then return end

    if buyer == seller then return end

    local buyer_profit, seller_profit = math.Round(price * self.BuyerProfitRatio), math.Round(price * self.SellerProfitRatio);

    buyer:AddMoney( buyer_profit );
    rp.Notify( buyer, NOTIFY_GREEN, rp.Term("BuyerPurchasedWeaponFromPly"), rp.FormatMoney(buyer_profit) );

    seller:AddMoney( seller_profit );
    rp.Notify( seller, NOTIFY_GREEN, rp.Term("PlySoldWeaponToBuyer"), rp.FormatMoney(seller_profit) );

    tr.Entity:Remove();
end
 
function SWEP:PrimaryAttack()
    self:Attack();
end

function SWEP:SecondaryAttack()
    self:Attack();
end

function SWEP:ShouldDrawViewModel()
    return false
end