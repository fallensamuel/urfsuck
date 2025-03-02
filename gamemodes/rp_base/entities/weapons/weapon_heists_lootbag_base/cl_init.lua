-- "gamemodes\\rp_base\\entities\\weapons\\weapon_heists_lootbag_base\\cl_init.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
include( "shared.lua" );


--SWEP.CSWorldModel = ClientsideModel( "models/jessev92/payday2/item_bag_loot_jb.mdl" );
--SWEP.CSWorldModel:SetNoDraw( true );

SWEP.OffsetBone = "ValveBiped.Bip01_R_Hand";
SWEP.OffsetVec  = Vector( 0, -6, -3 );
SWEP.OffsetAng  = Angle( 0, 0, -120 );


function SWEP:Inititalize()
    self:SetHoldType( "knife" );
end


function SWEP:GetViewModelPosition( EyePos, EyeAng )
    EyePos = EyePos + EyeAng:Forward() * 30;
    EyePos = EyePos - EyeAng:Right()   * 5;
    EyePos = EyePos - EyeAng:Up()      * 15;

    EyeAng:RotateAroundAxis( EyeAng:Up(), 5 );
    EyeAng:RotateAroundAxis( EyeAng:Forward(), -10 );

    return EyePos, EyeAng
end


function SWEP:DrawWorldModel()
    if not IsValid( rp.Heists.LootbagMdl ) then return end

    if IsValid( self.Owner ) then
		local b = self.Owner:LookupBone( self.OffsetBone );
		if not b then return end

		local m = self.Owner:GetBoneMatrix( b )
		if not m then return end

		local renderPos, renderAng = LocalToWorld(
            self.OffsetVec, self.OffsetAng,
            m:GetTranslation(), m:GetAngles()
        );

        rp.Heists.LootbagMdl:SetPos( renderPos );
        rp.Heists.LootbagMdl:SetAngles( renderAng );
        
        rp.Heists.LootbagMdl:DrawModel();
    end
end


function SWEP:PrimaryAttack()
    if IsFirstTimePredicted() then
        -- most obscure way to prevent "clicking" sound
        self:EmitSound( "" );
	end
end


function SWEP:SecondaryAttack()
    self.Owner:SetAnimation( PLAYER_RELOAD );
end


local tr = translates
local cached

	if tr then
		cached = {
			tr.Get( 'Денег в сумке:' ), 
			tr.Get( 'Нажмите [E] чтобы сдать сумку' ), 
			tr.Get( 'Нажмите [ЛКМ] чтобы украсть деньги' ), 
			tr.Get( 'Нажмите [ПКМ] чтобы бросить сумку' ), 
		}
	else
		cached = {
			'Денег в сумке:', 
			'Нажмите [E] чтобы сдать сумку', 
			'Нажмите [ЛКМ] чтобы украсть деньги', 
			'Нажмите [ПКМ] чтобы бросить сумку', 
		}
	end

function SWEP:DrawHUD()
    draw.DrawText( cached[1] .. "\n" .. rp.FormatMoney(self:GetValue()) .. " / " .. rp.FormatMoney(self:GetValueCapacity()), rp.cfg.Heists.Fonts.HUD, ScrW()*0.5, ScrH()*0.6, Color(255,255,255,255), TEXT_ALIGN_CENTER );

    local tr  = LocalPlayer():GetEyeTraceNoCursor();
    local ent = tr.Entity;
    local ply = LocalPlayer();

    local actiontext = ""

    if IsValid( ent ) then
        if ent:GetClass() == "ent_heists_escapevan" and ent:GetPos():Distance( ply:GetPos() ) <= 192 then
            --draw.SimpleText( "Нажмите [E] чтобы сдать сумку", rp.cfg.Heists.Fonts.HUD, ScrW()/2, ScrH()*0.8, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
            actiontext = cached[2] .. "\n";
        end

        if rp.Heists.IsHeistRunning then
            if ent:GetClass() == "ent_heists_moneypallet" and ent:GetPos():Distance( ply:GetPos() ) <= 192 then
                --draw.SimpleText( "Нажмите [ЛКМ] чтобы украсть деньги", rp.cfg.Heists.Fonts.HUD, ScrW()/2, ScrH()*0.8, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
                actiontext = cached[3] .. "\n";
            end
        end
    end

    actiontext = actiontext .. cached[4];

    draw.DrawText( actiontext, rp.cfg.Heists.Fonts.HUD, ScrW()/2, ScrH()*0.8, Color(255,255,255,255), TEXT_ALIGN_CENTER );
end