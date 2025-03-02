AddCSLuaFile( "shared.lua" );
AddCSLuaFile( "cl_init.lua" );

include( "shared.lua" );


function ENT:GetMoney()
    return self:GetNWInt("money");
end


function ENT:AddMoney( amount )
    --self:SetNWInt(
    --    "money",
    --    math.Clamp( self:GetNWInt("money") + amount, 0, self.MoneyLimit )
    --);

    self:SetNWInt( "money", self:GetNWInt("money") + amount );
end


function ENT:SetMoney( amount )
    --self:SetNWInt(
    --    "money",
    --    math.Clamp( amount, 0, self.MoneyLimit )
    --);

    self:SetNWInt( "money", amount );
end


function ENT:TakeMoney( amount )
    amount = math.min( self:GetNWInt("money"), amount ); 
    
    --self:SetNWInt(
    --    "money",
    --    math.Clamp( self:GetNWInt("money") - amount, 0, self.MoneyLimit )
    --);

    self:SetNWInt( "money", self:GetNWInt("money") - amount );

    return amount
end


function ENT:CalculateMoneyLimit()
    local PoliceCount = 0;
    for k, ply in pairs( player.GetAll() ) do
        local f = ply:GetFaction();

        if rp.cfg.Heists.IsGoodGuy(f) then
            PoliceCount = PoliceCount + 1;
        end
    end

    self.MoneyLimit = rp.cfg.Heists.MinBankMoneyAmount + rp.cfg.Heists.MoneyBonusPerPolice * PoliceCount;
end


function ENT:Replenish()
    if not rp.Heists.IsHeistRunning then
        self:CalculateMoneyLimit();

        if self:GetMoney() < self.MoneyLimit then
            local m = self.MoneyLimit - self:GetMoney();
            self:AddMoney(
                math.min( m, rp.cfg.Heists.MoneyReplenishAmount )
            );
        elseif self:GetMoney() > self.MoneyLimit then
            local m = self:GetMoney() - self.MoneyLimit;

            self:AddMoney(
                -math.min( m, rp.cfg.Heists.MoneyReplenishAmount )
            );
        end
    end
end


function ENT:Initialize()
    self.Identifier = self:GetClass() .. self:EntIndex();

    self:SetModel( "models/props/cs_assault/MoneyPallet.mdl" );

	self:PhysicsInit( SOLID_VPHYSICS );
    self:SetMoveType( MOVETYPE_VPHYSICS );
    self:SetUseType( SIMPLE_USE );

    local phys = self:GetPhysicsObject();
	if IsValid( phys ) then
		phys:Wake();
    end
    
    timer.Create( self.Identifier, rp.cfg.Heists.MoneyReplenishInterval, 0, function()
        if IsValid( self ) then
            self:Replenish();
        end
    end );
end


function ENT:Use( caller )
    if not IsValid( caller ) then return end
    if not caller:IsPlayer() then return end

    if not rp.cfg.Heists.IsBadLeader(caller:Team()) then
        caller:Notify( NOTIFY_ERROR, rp.Term("NotBadLeader") );
        return false
    end

    if self:GetMoney() <= 0 then
        return false
    end

    rp.Heists.StartHeist( caller );
end


function ENT:OnRemove()
    timer.Remove( self.Identifier );
end