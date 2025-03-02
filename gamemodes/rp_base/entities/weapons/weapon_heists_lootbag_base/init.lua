AddCSLuaFile( "cl_init.lua" );
AddCSLuaFile( "shared.lua" );

include( "shared.lua" );


function SWEP:SetMainOwner( ply )
    if not IsValid(ply)   then return end
    if not ply:IsPlayer() then return end

    self.MainOwner = ply;
end

function SWEP:GetMainOwner()
    return self.MainOwner;
end


function SWEP:AddValue( amount )
    self:SetNWInt(
        "value",
        math.min( self:GetValue() + amount, self:GetValueCapacity() )
    );
end


function SWEP:SetValue( amount )
    self:SetNWInt(
        "value",
        math.Clamp( amount, 0, self:GetValueCapacity() )
    );
end


function SWEP:PrimaryAttack()
    local ent = self.Owner:GetEyeTraceNoCursor().Entity;
    if not IsValid(ent) then return end
    
    self:SetNextPrimaryFire( CurTime() + 1 );
    
    if ent:GetClass() == "ent_heists_moneypallet" then
        if not rp.Heists.IsHeistRunning then
            self.Owner:Notify( NOTIFY_ERROR, rp.Term("HeistIsntStarted") );
            return
        end

        if ent:GetMoney() > 0 then
            local takeamount = self:GetValueCapacity() - self:GetValue();

            if takeamount > 0 then
                local moneytaken = ent:TakeMoney( math.min( takeamount, self.TakeAmount ) );
                self:AddValue( moneytaken );
                self.Owner:ViewPunch( Angle( 2, 0, 0 ) );
                self.Owner:EmitSound( "physics/cardboard/cardboard_box_break3.wav", 75, math.random(90, 115), 1, CHAN_AUTO );
            else
                self.Owner:Notify( NOTIFY_ERROR, rp.Term("LootbagIsFull") );
            end
        end
    end
end


function SWEP:SecondaryAttack()
    self.Owner:SetAnimation( PLAYER_RELOAD );

    self:SetNextSecondaryFire( CurTime() + self:SequenceDuration() );
    
    timer.Simple( self:SequenceDuration()*0.5, function()
        if IsValid( self.Owner ) then
            local item = ents.Create( "spawned_weapon" );
            item:SetModel( self:GetModel() );
            item.weaponclass = self:GetClass();
            item.nodupe      = true;
            item.ValueAmount = self:GetValue();
            item.MainOwner   = self:GetMainOwner();
            item.Owner = self.Owner
            item.IsHeistLootbagEnt = true
            item.PlayerUse   = function( wep, ply )
                local f = ply:GetFaction();
                
                if rp.cfg.Heists.IsGoodGuy(f) then
                    local moneyAmt = math.Round(item.ValueAmount * 0.25);

                    if moneyAmt > 0 then
                        ply:AddMoney( moneyAmt );
                        ply:Notify( NOTIFY_GREEN, rp.Term("LootbagReturned"), rp.FormatMoney(moneyAmt) );

                        if IsValid(item.MainOwner) then
                            if rp.Heists.BagIssues[item.MainOwner] then
                                rp.Heists.BagIssues[item.MainOwner] = rp.Heists.BagIssues[item.MainOwner] + 1;
                            end
                        end
                    end

                    item:Remove();
                    return false
                end

                if ply:GetNWBool( "HasLootbag" ) then
                    ply:Notify( NOTIFY_ERROR, rp.Term("AlreadyGotLootbag") );
                    return false
                end

                timer.Simple( 0, function()
                    if ply:HasWeapon( item.weaponclass ) then
                        local wep = ply:GetWeapon( item.weaponclass );
            
                        if IsValid(wep) then
                            wep:SetValue( item.ValueAmount );
                            wep:SetMainOwner( item.MainOwner );
                        end
                    end
                end );
            end
            item:SetPos( self.Owner:GetShootPos() + self.Owner:GetAimVector() * 32 );
            item:Spawn();
            
            local phys = item:GetPhysicsObject();
            if IsValid(phys) then
                phys:Wake();
                phys:ApplyForceCenter( self.Owner:GetAimVector() * phys:GetMass() * 512 + self.Owner:GetVelocity() );
            end

            self.Owner:ViewPunch( Angle( -10, 0, 0 ) );

            self.Owner:SetNWBool( "HasLootbag", false );
            self.Owner:StripWeapon( self:GetClass() );
        end
    end );
end


hook.Add( "DoPlayerDeath", "rp.Heists.DropBag", function( ply )
    if ply:GetNWBool( "HasLootbag" ) then
        local wep;

        for k, v in pairs( ply:GetWeapons() ) do
            if string.StartWith( v:GetClass(), "weapon_heists_lootbag" ) then
                wep = v;
            end
        end

        if not IsValid( wep ) then return end

        local item = ents.Create( "spawned_weapon" );
        item:SetModel( wep:GetModel() );
        item.weaponclass = wep:GetClass();
        item.nodupe      = true;
        item.ValueAmount = wep:GetValue();
        item.MainOwner   = wep:GetMainOwner();
        item.PlayerUse   = function( wep, ply )
            local f = ply:GetFaction();
            
            if rp.cfg.Heists.IsGoodGuy(f) then
                local moneyAmt = math.Round(item.ValueAmount * 0.25);

                if moneyAmt > 0 then
                    ply:AddMoney( moneyAmt );
                    ply:Notify( NOTIFY_GREEN, rp.Term("LootbagReturned"), rp.FormatMoney(moneyAmt) );

                    if IsValid(item.MainOwner) then
                        if rp.Heists.BagIssues[item.MainOwner] then
                            rp.Heists.BagIssues[item.MainOwner] = rp.Heists.BagIssues[item.MainOwner] + 1;
                        end
                    end
                end

                item:Remove();
                return false
            end

            if ply:GetNWBool( "HasLootbag" ) then
                ply:Notify( NOTIFY_ERROR, rp.Term("AlreadyGotLootbag") );
                return false
            end

            timer.Simple( 0, function()
                if ply:HasWeapon( item.weaponclass ) then
                    local wep = ply:GetWeapon( item.weaponclass );
        
                    if IsValid(wep) then
                        wep:SetValue( item.ValueAmount );
                        wep:SetMainOwner( item.MainOwner );
                    end
                end
            end );
        end
        item:SetPos( wep.Owner:GetShootPos() + wep.Owner:GetAimVector() * 32 );
        item:Spawn();
        
        local phys = item:GetPhysicsObject();
        if IsValid(phys) then
            phys:Wake();
        end
    end
end );


hook.Add( "PostPlayerDeath", "rp.Heists.VoidBag", function( ply )
    if ply:GetNWBool( "HasLootbag" ) then
        ply:SetNWBool( "HasLootbag", false );
    end
end );


function SWEP:Equip( ply )
    if IsValid( ply ) then
        ply:SetNWBool( "HasLootbag", true );
    end
end


function SWEP:Initialize()
    self:SetHoldType( "knife" );
    
    timer.Simple( 0, function()
        if not IsValid(self.Owner) then
            local item = ents.Create( "spawned_weapon" );
            item:SetModel( self:GetModel() );
            item.weaponclass = self:GetClass();
            item.nodupe      = true;
            item.ValueAmount = self:GetValue();
            item.MainOwner   = self:GetMainOwner();
            item.PlayerUse   = function( wep, ply )
                local f = ply:GetFaction();
                
                if rp.cfg.Heists.IsGoodGuy(f) then
                    local moneyAmt = math.Round(item.ValueAmount * 0.25);

                    if moneyAmt > 0 then
                        ply:AddMoney( moneyAmt );
                        ply:Notify( NOTIFY_GREEN, rp.Term("LootbagReturned"), rp.FormatMoney(moneyAmt) );

                        if IsValid(item.MainOwner) then
                            if rp.Heists.BagIssues[item.MainOwner] then
                                rp.Heists.BagIssues[item.MainOwner] = rp.Heists.BagIssues[item.MainOwner] + 1;
                            end
                        end
                    end

                    item:Remove();
                    return false
                end

                if ply:GetNWBool( "HasLootbag" ) then
                    ply:Notify( NOTIFY_ERROR, rp.Term("AlreadyGotLootbag") );
                    return false
                end

                timer.Simple( 0, function()
                    if ply:HasWeapon( item.weaponclass ) then
                        local wep = ply:GetWeapon( item.weaponclass );
            
                        if IsValid(wep) then
                            wep:SetValue( item.ValueAmount );
                            wep:SetMainOwner( item.MainOwner );
                        end
                    end
                end );
            end
            item:SetPos( self.Owner:GetShootPos() + self.Owner:GetAimVector() * 32 );
            item:Spawn();
            
            self:Remove();
        else
            if not self.MainOwner then
                self:SetMainOwner( self.Owner );
            end
        end
    end );
end