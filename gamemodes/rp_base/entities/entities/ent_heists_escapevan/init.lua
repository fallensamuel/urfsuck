AddCSLuaFile( "shared.lua" );
AddCSLuaFile( "cl_init.lua" );

include( "shared.lua" );


function ENT:Initialize()
    self:SetModel( rp.cfg.Heists and rp.cfg.Heists.VanModel or "models/lonewolfie/mer_g65.mdl" );
    
	self:PhysicsInit( SOLID_VPHYSICS );
	self:SetUseType( SIMPLE_USE );
    self:SetMoveType( MOVETYPE_VPHYSICS );

    local phys = self:GetPhysicsObject();
	if IsValid( phys ) then
		phys:Wake();
	end
end


function ENT:Use( ply )
	if IsValid( ply ) then
		local wep = ply:GetActiveWeapon();

		if IsValid( wep ) then
			if string.StartWith( wep:GetClass(), "weapon_heists_lootbag" ) then
				local moneyAmt = wep:GetValue();

				if moneyAmt <= 0 then
					ply:Notify( NOTIFY_ERROR, rp.Term("LootbagIsEmpty") );
				else
					ply:AddMoney( wep:GetValue() );
					ply:Notify( NOTIFY_GREEN, "+" .. rp.FormatMoney(wep:GetValue()) );

					if IsValid(wep:GetMainOwner()) then
						if rp.Heists.BagIssues[wep:GetMainOwner()] then
							rp.Heists.BagIssues[wep:GetMainOwner()] = rp.Heists.BagIssues[wep:GetMainOwner()] + 1;
						end
					end

					ply:SetNWBool( "HasLootbag", false );
					ply:StripWeapon( wep:GetClass() );

					ply:EmitSound( "physics/cardboard/cardboard_box_break1.wav", 75, math.random(90, 115), 1, CHAN_AUTO );
				end
			end
		end
	end
end

function ENT:PhysicsCollide(data, phys)
	timer.Simple(0, function() -- Отделяю функцию от потока связанного с коллизией — что-бы не вызвать возможный краш физики.
		local ent = data.HitEntity
		if not IsValid(ent) or ent.AlreadyCollidedVan then return end
		if ent.IsHeistLootbagEnt and IsValid(ent.Owner) and ent.Owner:IsPlayer() then
			ent.AlreadyCollidedVan = true
			ent:EmitSound("physics/cardboard/cardboard_box_break3.wav", 75, math.random(90, 115), 1, CHAN_AUTO)
			ent.Owner:AddMoney(ent.ValueAmount)
			ent:Remove()
			return
		end
	end)
end