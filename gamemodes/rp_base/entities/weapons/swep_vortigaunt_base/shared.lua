-- "gamemodes\\rp_base\\entities\\weapons\\swep_vortigaunt_base\\shared.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal

if (SERVER) then
	AddCSLuaFile( "shared.lua" )
	
	SWEP.AutoSwitchTo		= true
	SWEP.AutoSwitchFrom		= true
	
    resource.AddFile( "materials/vgui/weapons/zen_healing_m.vmt" )
end

if ( CLIENT ) then
	SWEP.DrawAmmo			= true
	SWEP.PrintName			= "Vortigaunt Beam Base"
	SWEP.Author				= ""
	SWEP.DrawCrosshair		= true
	SWEP.ViewModelFOV		= 54

	SWEP.Contact		= "urf.im"
	SWEP.Purpose		= "Zap everything! Vortigaunt Style"
	SWEP.Instructions	= "Primary: Vortigaunt zap.\nSecondary: Self battery healing."

	killicon.Add("swep_vortigaunt_beam","VGUI/killicons/swep_vortigaunt_beam", Color(255,255,255));
end

SWEP.Category				= "Vortigaunt Sweps" 
SWEP.Slot					= 3
SWEP.SlotPos				= 5
SWEP.Weight					= 5
--SWEP.Spawnable     			= true
SWEP.AdminSpawnable  		= true
 
SWEP.ViewModel 				= "models/weapons/v_vortbeamvm.mdl"
SWEP.WorldModel 			= ""
SWEP.AdminOnly 				= true
SWEP.Range					= 2 * GetConVarNumber( "sk_vortigaunt_zap_range", 100) * 12
SWEP.DamageForce			= 48000	
SWEP.AmmoPerUse				= 15	
SWEP.HealSound				= Sound("NPC_Vortigaunt.SuitOn")
SWEP.HealLoop				= Sound("NPC_Vortigaunt.StartHealLoop")
SWEP.AttackLoop				= Sound("NPC_Vortigaunt.ZapPowerup" )
SWEP.AttackSound			= Sound("NPC_Vortigaunt.ClawBeam")
SWEP.HealDelay				= 1		
SWEP.MaxArmor				= 18	
SWEP.MinArmor				= 12	
SWEP.ArmorLimit				= 100	
SWEP.BeamDamage				= 180	
SWEP.BeamChargeTime			= 1.25
SWEP.Deny					= Sound("Buttons.snd19")			

game.AddAmmoType({
	name = "VortigontFire",
	dmgtype = DMG_BULLET,
	tracer = TRACER_LINE,
	plydmg = 0,
	npcdmg = 0,
	force = 2000,
	minsplash = 10,
	maxsplash = 5
})

SWEP.EnergyRestore = 0.3
 
SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= 50
SWEP.Primary.Ammo 			= "VortigontFire"
SWEP.Primary.Automatic		= true

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Ammo 		= false
SWEP.Secondary.Automatic 	= true

SWEP.NextAmmo = 0

function SWEP:SetupDataTables()
	self:NetworkVar("Int", 0, "SkillMode")
	self:NetworkVar("Bool", 0, "AuraEnabled")
end

local area_emoteaction = {
	['myidol'] = true,
}

SWEP.Types = {
	['damage'] = {
		use = function(self, tracer)
			if IsValid(tracer.Entity) then
				local DMG = DamageInfo()
				DMG:SetDamageType(DMG_SHOCK)
				DMG:SetDamage(self:GetSkillData().damage or self.BeamDamage)
				DMG:SetAttacker(self.Owner)
				DMG:SetInflictor(self)
				DMG:SetDamagePosition(tracer.HitPos)
				DMG:SetDamageForce(self.Owner:GetAimVector() * self.DamageForce)
				tracer.Entity:TakeDamageInfo(DMG)
			end
		end,
	},
	['health'] = {
		use = function(self, tracer)
			tracer.Entity:SetHealth(math.min(tracer.Entity:Health() + (self:GetSkillData().health or 1), tracer.Entity:GetMaxHealth()))
			-- Notify?
		end,
		impact_effect_amount = 3,
		impact_effect = "z_regeneration",
		impact_time = 2,
		custom_anim = "heal_cycle",
		custom_anim_time = 5,
		no_beam = true,
		check = function(self, tracer)
			return tracer.Entity:Health() < tracer.Entity:GetMaxHealth(), "Vort::MaxHealthAlready"
		end,
	},
	['armor'] = {
		use = function(self, tracer)
			tracer.Entity:SetArmor(math.min(tracer.Entity:Armor() + (self:GetSkillData().armor or 1), self.ArmorLimit))
			-- Notify?
		end,
		impact_effect = "z_h_shield",
		impact_time = 1,
		custom_anim = "heal_cycle",
		custom_anim_time = 5,
		no_beam = true,
		check = function(self, tracer)
			return tracer.Entity:Armor() < self.ArmorLimit, "Vort::MaxArmorAlready"
		end,
	},
	['speed'] = {
		use = function(self, tracer)
			local skill_data = self:GetSkillData()
			
			tracer.Entity.b_syringedMoveSpeed    = true;
            tracer.Entity.f_syringedMoveSpeedAmt = skill_data.speed or 50;
			
            tracer.Entity:SetRunSpeed( tracer.Entity:GetRunSpeed() + tracer.Entity.f_syringedMoveSpeedAmt );
			
			rp.Notify(tracer.Entity, NOTIFY_GENERIC, rp.Term("Vort::SpeededUpStarted"), skill_data.time or 10)
			
			timer.Simple(skill_data.time or 10, function()
				if not IsValid(tracer.Entity) or not tracer.Entity.b_syringedMoveSpeed then
					return
				end
				
				tracer.Entity:SetRunSpeed( tracer.Entity:GetRunSpeed() - tracer.Entity.f_syringedMoveSpeedAmt );

				tracer.Entity.f_syringedMoveSpeedAmt = nil;
				tracer.Entity.b_syringedMoveSpeed    = nil;
				
				rp.Notify(tracer.Entity, NOTIFY_GENERIC, rp.Term("Vort::SpeededUpEnded"))
			end)
		end,
		impact_effect = "zen_magic_missile_blast",
		impact_time = 1,
		custom_anim = "heal_cycle",
		custom_anim_time = 5,
		no_beam = true,
		check = function(self, tracer)
			return not tracer.Entity.b_syringedMoveSpeed, "Vort::SpeededUpAlready"
		end,
	},
	['stun'] = {
		use = function(self, tracer)
			tracer.Entity:Freeze(true)
			
			local time = self:GetSkillData().time or 10
			
			rp.Notify(tracer.Entity, NOTIFY_GENERIC, rp.Term("Vort::StunStarted"), time)
			
			timer.Simple(time, function()
				if not IsValid(tracer.Entity) or not tracer.Entity:IsFlagSet(FL_FROZEN) then
					return
				end
				
				tracer.Entity:Freeze(false)
				
				rp.Notify(tracer.Entity, NOTIFY_GENERIC, rp.Term("Vort::StunEnded"))
			end)
		end,
		impact_effect = false,
		check = function(self, tracer)
			return not tracer.Entity:IsFlagSet(FL_FROZEN), "Vort::StunnedAlready"
		end,
	},
	
	['self-health'] = {
		use = function(self, ply)
			ply:SetHealth(math.min(ply:Health() + self:GetSkillData().health, ply:GetMaxHealth()))
		end,
		impact_effect_amount = 3,
		impact_effect = "z_regeneration",
		impact_time = 2,
		check = function(self, ply)
			return IsValid(ply) and (ply:Health() < ply:GetMaxHealth()), "Vort::MaxHealthAlready"
		end,
	},
	['self-armor'] = {
		use = function(self, ply)
			ply:SetArmor(math.min(ply:Armor() + self:GetSkillData().armor, self.ArmorLimit))
		end,
		impact_effect = "z_h_shield",
		impact_time = 1,
		check = function(self, ply)
			return IsValid(ply) and (ply:Armor() < self.ArmorLimit), "Vort::MaxArmorAlready"
		end,
	},
	['self-speed'] = {
		use = function(self, ply)
			local skill_data = self:GetSkillData()
			
			ply.b_syringedMoveSpeed    = true;
            ply.f_syringedMoveSpeedAmt = skill_data.speed or 50;
			
            ply:SetRunSpeed( ply:GetRunSpeed() + ply.f_syringedMoveSpeedAmt );
			
			timer.Simple(skill_data.time or 10, function()
				if not IsValid(ply) or not ply.b_syringedMoveSpeed then
					return
				end
				
				ply:SetRunSpeed( ply:GetRunSpeed() - ply.f_syringedMoveSpeedAmt );

				ply.f_syringedMoveSpeedAmt = nil;
				ply.b_syringedMoveSpeed    = nil;
				
				rp.Notify(ply, NOTIFY_GENERIC, rp.Term("Vort::SpeededUpEnded"))
			end)
		end,
		impact_effect = "zen_magic_missile_blast",
		impact_time = 1,
		check = function(self, ply)
			return not ply.b_syringedMoveSpeed, "Vort::SpeededUpAlready"
		end,
	},
	['self-health_aura'] = {
		pre_use = function(self, ply, callback)
			--if SERVER then
				--ply:SetVelocity(-ply:GetVelocity())
				--ply:DropToFloor()
			--end
			
			if not ply:IsOnGround() and !IsValid(ply:GetGroundEntity()) then
				if SERVER then
					rp.Notify( ply, NOTIFY_ERROR, rp.Term("EmoteActions.CannotAir") );
				end
				
				return callback(false)
			
			elseif ply:GetVelocity():Length() > 4 then
				if SERVER then
					rp.Notify( ply, NOTIFY_ERROR, rp.Term("EmoteActions.CannotVelocity") );
				end
				
				return callback(false)
			end
			
			--timer.Simple(0, function()
				if SERVER then
					--ply:StartEmoteAction("myidol")
					ply:SetMoveType(MOVETYPE_WALK)
					ply:forceSequence("defend", nil, 9999999, true)
				end
				
				--timer.Simple(0.2, function()
					--callback(area_emoteaction[ply:GetEmoteAction()])
					callback(true)
				--end)
			--end)
		end,
		use = function(self, ply)
			local timer_name = "Vort::UseAreaSpell" .. ply:SteamID()
			local timer_check_name = "Vort::CheckAreaSpell" .. ply:SteamID()
			
			local skill_data = self:GetSkillData()
			
			local function do_default_checks()
				if not IsValid(ply) or not IsValid(self) then
					timer.Remove(timer_check_name)
					timer.Remove(timer_name)
					
					return false
				end
				
				--if not area_emoteaction[ply:GetEmoteAction()] or not ply:Alive() or ply:IsInDeathMechanics() then
				if not ply:Alive() or ply:IsInDeathMechanics() or ply:GetVelocity():Length() > 4 then
					--ply:Freeze(false)
					
					ply:leaveSequence()
					
					self:SetAuraEnabled(false)
					self.Weapon:EmitSound(self.Deny)
					
					timer.Remove(timer_check_name)
					timer.Remove(timer_name)
					
					return false
				end
				
				return true
			end
			
			timer.Create(timer_check_name, 0.2, 0, do_default_checks)
			timer.Create(timer_name, 1, 0, function()
				if not do_default_checks() then
					return
				end
				
				ply:RemoveAmmo(skill_data.energy_drain or self.AmmoPerUse, self.Primary.Ammo);
				
				if self.EnergyRestoreCooldown then
					self.NextAmmo = CurTime() + self.EnergyRestoreCooldown
				end
				
				for k, v in pairs(ents.FindInSphere(ply:GetPos(), skill_data.radius or 300)) do
					if IsValid(v) and v:IsPlayer() and v:Alive() then
						v:SetHealth(math.min(v:Health() + skill_data.health or 1, v:GetMaxHealth()))
						
						if v ~= self.Owner then
							self:CreateBlast(1.5, v:GetPos() + Vector(0, 0, 6), "z_regeneration", v, 2)
						end
					end
				end
				
				if ply:GetAmmoCount(self.Primary.Ammo) < (skill_data.energy_drain or self.AmmoPerUse) then
					--ply:Freeze(false)
					--ply:SetEmoteAction("")
					
					ply:leaveSequence()
					
					self:SetAuraEnabled(false)
					self.Weapon:EmitSound(self.Deny)
					
					timer.Remove(timer_check_name)
					return timer.Remove(timer_name)
				end
			end)
			
			--ply:Freeze(true)
			self:SetAuraEnabled(true)
		end,
		--draw_effect = function(self)
			--local ply = self.Owner
			--local skill_data = self:GetSkillData()
			
			--print("Draw?")
			
			--for k, v in pairs(ents.FindInSphere(ply:GetPos(), skill_data.radius or 300)) do
				--if IsValid(v) and v:IsPlayer() and v:Alive() and not v:IsInDeathMechanics() then
					--if v ~= ply then
						--v:StopParticles()
					
						--for k = 1, 3 do
							--self:CreateBlast(1.5, v:GetPos() + Vector(0, 0, 6), "z_regeneration", v, 5)
						--end
					--end
				--end
			--end
		--end,
		impact_effect = "z_group_healer_zombie_radius",
		impact_time = function(self)
			local effect_time = self:GetSkillData().time or 10
			local effect_length = 1
			
			return effect_length, 0 -- effect_time / effect_length - effect_length
		end,
		check = function(self, ply)
			return not self:GetAuraEnabled(), "Vort::SpellAreaAlready"
		end,
	},
	['self-armor_aura'] = {
		pre_use = function(self, ply, callback)
			--if SERVER then
				--ply:SetVelocity(-ply:GetVelocity())
				--ply:DropToFloor()
			--end
			
			if not ply:IsOnGround() and !IsValid(ply:GetGroundEntity()) then
				if SERVER then
					rp.Notify( ply, NOTIFY_ERROR, rp.Term("EmoteActions.CannotAir") );
				end
				
				return callback(false)
			
			elseif ply:GetVelocity():Length() > 4 then
				if SERVER then
					rp.Notify( ply, NOTIFY_ERROR, rp.Term("EmoteActions.CannotVelocity") );
				end
				
				return callback(false)
			end
			
			--timer.Simple(0, function()
				if SERVER then
					--ply:StartEmoteAction("myidol")
					ply:SetMoveType(MOVETYPE_WALK)
					ply:forceSequence("defend", nil, 9999999, true)
				end
				
				--timer.Simple(0.2, function()
					--callback(area_emoteaction[ply:GetEmoteAction()])
					callback(true)
				--end)
			--end)
		end,
		use = function(self, ply)
			local timer_name = "Vort::UseAreaSpell" .. ply:SteamID()
			local timer_check_name = "Vort::CheckAreaSpell" .. ply:SteamID()
			
			local skill_data = self:GetSkillData()
			
			local function do_default_checks()
				if not IsValid(ply) or not IsValid(self) then
					timer.Remove(timer_check_name)
					timer.Remove(timer_name)
					
					return false
				end
				
				--if not area_emoteaction[ply:GetEmoteAction()] or not ply:Alive() or ply:IsInDeathMechanics() then
				if not ply:Alive() or ply:IsInDeathMechanics() or ply:GetVelocity():Length() > 4 then
					--ply:Freeze(false)
					
					ply:leaveSequence()
					
					self:SetAuraEnabled(false)
					self.Weapon:EmitSound(self.Deny)
					
					timer.Remove(timer_check_name)
					timer.Remove(timer_name)
					
					return false
				end
				
				return true
			end
			
			timer.Create(timer_check_name, 0.2, 0, do_default_checks)
			timer.Create(timer_name, 1, 0, function()
				if not do_default_checks() then
					return
				end
				
				ply:RemoveAmmo(skill_data.energy_drain or self.AmmoPerUse, self.Primary.Ammo);
				
				if self.EnergyRestoreCooldown then
					self.NextAmmo = CurTime() + self.EnergyRestoreCooldown
				end
				
				for k, v in pairs(ents.FindInSphere(ply:GetPos(), skill_data.radius or 300)) do
					if IsValid(v) and v:IsPlayer() and v:Alive() and v:Armor() < self.ArmorLimit then
						v:SetArmor(math.min(v:Armor() + skill_data.armor or 1, self.ArmorLimit))
						
						if v ~= self.Owner then
							self:CreateBlast(1.5, v:GetPos() + Vector(0, 0, 6), "z_h_shield", v, 1)
						end
					end
				end
				
				if ply:GetAmmoCount(self.Primary.Ammo) < (skill_data.energy_drain or self.AmmoPerUse) then
					--ply:Freeze(false)
					--ply:SetEmoteAction("")
					
					ply:leaveSequence()
					
					self:SetAuraEnabled(false)
					self.Weapon:EmitSound(self.Deny)
					
					timer.Remove(timer_check_name)
					return timer.Remove(timer_name)
				end
			end)
			
			--ply:Freeze(true)
			self:SetAuraEnabled(true)
		end,
		--draw_effect = function(self)
			--local ply = self.Owner
			--local skill_data = self:GetSkillData()
			
			--for k, v in pairs(ents.FindInSphere(ply:GetPos(), skill_data.radius or 300)) do
				--if IsValid(v) and v:IsPlayer() and v:Alive() and not v:IsInDeathMechanics() then
					--if v ~= ply then --or not self.OwnerParticles then
						--v:StopParticles()
					--end
					
					--self:CreateBlast(1.5, v:GetPos() + Vector(0, 0, 6), "z_h_shield", v)
						
					--if v == ply then
						--self.OwnerParticles = true
					--end
				--end
			--end
		--end,
		impact_effect = "z_shield_radius",
		impact_time = function(self)
			local effect_time = self:GetSkillData().time or 10
			local effect_length = 1
			
			return effect_length, 0 -- effect_time / effect_length - effect_length
		end,
		check = function(self, ply)
			return not self:GetAuraEnabled(), "Vort::SpellAreaAlready"
		end,
	},
}

function SWEP:Shoot(dmg, effect)
	local pPlayer = self.Owner
	local skill_data = self:GetSkillData()
	
	if not pPlayer or not skill_data or not self.Types[skill_data.skill_type] then
		return
	end
	
	local skill_settings = self.Types[skill_data.skill_type]
	local tracer = util.QuickTrace(self.Owner:EyePos(), self.Owner:GetAimVector() * self.Range, self.Owner)
	
	if not skill_settings.no_beam then
		self:ShootEffect(effect or "vortigaunt_beam", pPlayer:EyePos(), tracer.HitPos)
	end
	
	self.Owner:GetViewModel():EmitSound(self.AttackSound)
	self:ImpactEffect( tracer, skill_settings.impact_effect, skill_settings.impact_time, skill_settings.impact_effect_amount )
	
	if not IsValid(tracer.Entity) or not tracer.Entity:IsPlayer() then
		return
	end
	
	if skill_settings.check then
		local check_result, term = skill_settings.check(self, tracer)
		
		if not check_result then
			--if SERVER then
				--rp.Notify(self.Owner, NOTIFY_ERROR, rp.Term(term))
			--end
			
			return
		end
	end
	
	if SERVER then
		skill_settings.use(self, tracer)
		
		if self.EnergyRestoreCooldown then
			self.NextAmmo = CurTime() + self.EnergyRestoreCooldown
		end
	end
end

function SWEP:GiveArmor()
	local skill_data = self:GetSkillData()
	
	if not skill_data or not self.Types['self-' .. skill_data.skill_type] then
		return
	end
	
	local skill_settings = self.Types['self-' .. skill_data.skill_type]
	
	if CLIENT then 
		--if skill_settings.impact_effect then
			--self:ImpactEffect( nil, skill_settings.impact_effect, skill_settings.impact_time, skill_settings.impact_effect_amount )
		--end
		
		return 
	end
	
	self:ImpactEffect( nil, skill_settings.impact_effect, skill_settings.impact_time, skill_settings.impact_effect_amount )
	
	if self.EnergyRestoreCooldown then
		self.NextAmmo = CurTime() + self.EnergyRestoreCooldown
	end
	
	if skill_settings.check then
		local check_result, term = skill_settings.check(self, self.Owner)
		
		if not check_result then
			self.Weapon:EmitSound(self.Deny)
			return rp.Notify(self.Owner, NOTIFY_ERROR, rp.Term(term))
		end
	end
	
	skill_settings.use(self, self.Owner)
end

function SWEP:GetSkillData()
	return self.Skills[self:GetSkillMode() or 1]
end

function SWEP:Initialize()
	self.Charging = false;
	self.Healing = false;	
	
	self.HealTime = CurTime();
	self.ChargeTime = CurTime();
	
	self:SetSkillMode(1)
	
	self:SetWeaponHoldType("slam")
	
	if (CLIENT) then return end
	self:CreateSounds()	
end 

game.AddParticles( "particles/zen_magic_effects.pcf" )
game.AddParticles( "particles/zen_healing_effects.pcf" )
game.AddParticles( "particles/zen_health_gun.pcf" )
game.AddParticles( "particles/z_zombie_effects.pcf" )
game.AddParticles( "particles/z_zombies.pcf" )
game.AddParticles( "particles/z_regeneration_effects.pcf" )

PrecacheParticleSystem( "z_regeneration" )

PrecacheParticleSystem( "z_group_healer_zombie_radius" )
PrecacheParticleSystem( "z_group_healer_zombie_spinning_effects" )
PrecacheParticleSystem( "z_group_healer_zombie_buff" )
PrecacheParticleSystem( "z_entity_healing_effects" )

PrecacheParticleSystem( "z_h_shield" )
PrecacheParticleSystem( "z_shield_radius" )
PrecacheParticleSystem( "z_shield_heal" )
PrecacheParticleSystem( "z_shield_buff" )

PrecacheParticleSystem( "zen_life_steal" )
PrecacheParticleSystem( "zen_magic_missile_blast" )

PrecacheParticleSystem( "Zen_Ring_Buff" )

PrecacheParticleSystem( "vortigaunt_beam" );
PrecacheParticleSystem( "vortigaunt_beam_charge" );	

PrecacheParticleSystem( "vortigaunt_charge_token" );	
PrecacheParticleSystem( "vortigaunt_charge_token_b" );	
PrecacheParticleSystem( "vortigaunt_charge_token_c" );	

function SWEP:Precache()
	util.PrecacheModel(self.ViewModel)	
end

function SWEP:CreateSounds()
	if (!self.ChargeSound) then
		self.ChargeSound = CreateSound( self.Weapon, self.AttackLoop );
	end
	if (!self.HealingSound) then
		self.HealingSound = CreateSound( self.Weapon, self.HealLoop );
	end
end

function SWEP:DispatchEffect(EFFECTSTR)
	local pPlayer = self.Owner;
	if !pPlayer then return end
	
	local view;
	
	if CLIENT then 
		view = GetViewEntity() 
	else 
		view = pPlayer:GetViewEntity() 
	end
		
	--if ( !pPlayer:IsNPC() && view:IsPlayer() ) then
		--ParticleEffectAttach( EFFECTSTR, PATTACH_POINT_FOLLOW, pPlayer:GetViewModel(), pPlayer:GetViewModel():LookupAttachment( "muzzle" ) );
	--else
		ParticleEffectAttach( EFFECTSTR, PATTACH_POINT_FOLLOW, pPlayer, pPlayer:LookupAttachment( "rightclaw" ) );
		ParticleEffectAttach( EFFECTSTR, PATTACH_POINT_FOLLOW, pPlayer, pPlayer:LookupAttachment( "leftclaw" ) );
	--end
end

function SWEP:ShootEffect(EFFECTSTR, startpos, endpos)
	local pPlayer=self.Owner;
	if !pPlayer then return end
	
	local view;
	
	if CLIENT then 
		view = GetViewEntity() 
	else 
		view = pPlayer:GetViewEntity() 
	end
	
	if ( !pPlayer:IsNPC() && view:IsPlayer() and self.Weapon:GetAttachment( self.Weapon:LookupAttachment( "muzzle" ) ) ) then
		util.ParticleTracerEx( EFFECTSTR, self.Weapon:GetAttachment( self.Weapon:LookupAttachment( "muzzle" ) ).Pos,endpos, true, pPlayer:GetViewModel():EntIndex(), pPlayer:GetViewModel():LookupAttachment( "muzzle" ) );
	else
		util.ParticleTracerEx( EFFECTSTR, pPlayer:GetAttachment( pPlayer:LookupAttachment( "rightclaw" ) ).Pos,endpos, true,pPlayer:EntIndex(), pPlayer:LookupAttachment( "rightclaw" ) );
		util.ParticleTracerEx( EFFECTSTR, pPlayer:GetAttachment( pPlayer:LookupAttachment( "leftclaw" ) ).Pos,endpos, true,pPlayer:EntIndex(), pPlayer:LookupAttachment( "leftclaw" ) );
	end
end
	
function SWEP:ImpactEffect( traceHit, impact_effect, impact_time, impact_effect_amount )
	if traceHit then
		local data = EffectData();
		data:SetOrigin(traceHit.HitPos)
		data:SetNormal(traceHit.HitNormal)
		data:SetScale(20)
		util.Effect( "StunstickImpact", data );
	end
	
	local rand = math.random(1,1.5);
	
	if impact_effect ~= nil then
		if impact_effect then
			if traceHit then
				for k = 1, impact_effect_amount or 1 do
					self:CreateBlast(rand, traceHit.HitPos, impact_effect, traceHit.Entity, impact_time)
				end
				
			else
				for k = 1, impact_effect_amount or 1 do
					self:CreateBlast(rand, self.Owner:GetPos() + Vector(0, 0, 6), impact_effect, self.Owner, impact_time)
				end
			end
		end
		
	else
		self:CreateBlast(rand, traceHit.HitPos)
		self:CreateBlast(rand, traceHit.HitPos)
	end
	
	if SERVER && traceHit && traceHit.Entity && IsValid(traceHit.Entity) && string.find(traceHit.Entity:GetClass(),"ragdoll") then
		traceHit.Entity:Fire("StartRagdollBoogie");
	end
end

function SWEP:CreateBlast(scale, pos, impact_effect, impact_entity, impact_time)
	if impact_effect then
		if CLIENT then return end
		
		if not impact_time then
			self:BroadcastEffect(impact_effect, impact_entity, pos, 0, 1)
			
		elseif isnumber(impact_time) then
			self:BroadcastEffect(impact_effect, impact_entity, pos, impact_time, 1)
		
		else
			local sp_time, sp_repeats = impact_time(self)
			self:BroadcastEffect(impact_effect, impact_entity, pos, sp_time, sp_repeats)
		end
		
		/*
		if CLIENT then 
			ParticleEffectAttach(impact_effect, 1, impact_entity, 0)
			
			if impact_time then
				if isnumber(impact_time) then
					timer.Simple(impact_time, function()
						if not IsValid(impact_entity) then return end
						impact_entity:StopParticles()
					end)
					
				else
					local sp_time, sp_repeats = impact_time(self)
					local timer_name = "Vort::CustomEffect" .. self:EntIndex()
					
					timer.Create(timer_name, sp_time, sp_repeats, function()
						if not IsValid(impact_entity) or not IsValid(self) or not self:GetAuraEnabled() then 
							return timer.Remove(timer_name)
						end
						
						ParticleEffectAttach(impact_effect, 1, impact_entity, 0)
					end)
					
					if sp_repeats > 0 then
						timer.Simple(sp_time * sp_repeats, function()
							if not IsValid(impact_entity) then return end
							impact_entity:StopParticles()
						end)
					end
				end
			end
		end
		*/
		
	else
		if CLIENT then return end
		
		local blastspr = ents.Create("env_sprite");	
		blastspr:SetPos( pos );	
		blastspr:SetKeyValue( "model", "sprites/vortring1.vmt")
		blastspr:SetKeyValue( "scale", tostring(scale))
		blastspr:SetKeyValue( "framerate", 60)
		blastspr:SetKeyValue( "spawnflags", "1")
		blastspr:SetKeyValue( "brightness", "255")
		blastspr:SetKeyValue( "angles", "0 0 0")
		blastspr:SetKeyValue( "rendermode", "9")
		blastspr:SetKeyValue( "renderamt", "255")
		blastspr:Spawn()
		blastspr:Fire("kill", "", 0.45)
	end
end	

function SWEP:Holster( wep )
	self:StopEveryThing()
	return true
end

function SWEP:OnRemove()
	self:StopEveryThing(true)
end

function SWEP:StopEveryThing(dont_set_model)
	self.Charging=false;
	
	if SERVER && self.ChargeSound then
		self.ChargeSound:Stop();
	end
	
	hook.Remove("SetupMove", "Vort::JumpBlock::" .. self:EntIndex())
	
	self.Healing=false;
	
	if SERVER && self.HealingSound then
		self.HealingSound:Stop();
	end
	
	local pPlayer = self.LastOwner;
	if (!pPlayer) then
		return;
	end
	
	local Weapon = self.Weapon
	
	if !IsValid(pPlayer) then return end
	
	if CLIENT then
		pPlayer.Blocked3dPerson = nil
	end
	
	if not dont_set_model and self.SavedLastModel then
		pPlayer:SetModel(self.SavedLastModel)
	end
	
	if dont_set_model then
		pPlayer:SetModel("")
	end
	
	if pPlayer.b_lastJumpPower then
		pPlayer:SetJumpPower(pPlayer.b_lastJumpPower);
		pPlayer.b_lastJumpPower = nil
	end
	
	if (!pPlayer:GetViewModel()) then return end
	
	if ( CLIENT ) then 
		if ( pPlayer == LocalPlayer() ) then 
			pPlayer:GetViewModel():StopParticles();
		end	
	end
	
	pPlayer:StopParticles();
end

function SWEP:Deploy()
	self.Weapon:SendWeaponAnim( ACT_VM_DRAW )
	self:SetDeploySpeed( 1 )
	
	--print("Deploy?")
	
	self:Precache()
	
	if self.OwnerModel then
		if CLIENT then
			--print("Enable 3d person?")
			cvar.SetValue('enable_thirdperson', true)
			self.Owner.Blocked3dPerson = true
		end
		
		timer.Simple(0, function()
			if not IsValid(self) or not IsValid(self.Owner) then return end
			
			hook.Add("SetupMove", "Vort::JumpBlock::" .. self:EntIndex(), function(ply, mvd, cmd)
				if ply ~= self.Owner then return end
				
				if mvd:KeyDown(IN_JUMP) then
					mvd:SetButtons(bit.band(mvd:GetButtons(), bit.bnot(IN_JUMP)))
				end
			end)
			
			self.Owner.b_lastJumpPower = self.Owner:GetJumpPower()
            self.Owner:SetJumpPower(0);
			
			self.SavedLastModel = self.Owner:GetModel()
			self.Owner:SetModel(self.OwnerModel)
		end)
	end
	
	return true
end

function SWEP:Think()
	if self.Owner && IsValid(self.Owner) then 
		self.LastOwner = self.Owner 
	end
	
	local skill_data = self:GetSkillData() or {}
	local skill_settings = self.Types["self-" .. (skill_data.skill_type or '')]
	
	if CLIENT then
		if self:GetAuraEnabled() and not (self.NextCThink and self.NextCThink > CurTime()) then
			self.NextCThink = CurTime() + 5
			self.AuraEnabled = true
			
			--print(skill_settings.draw_effect)
			
			if skill_settings.draw_effect then
				skill_settings.draw_effect(self)
			end
		
		elseif not self:GetAuraEnabled() and (self.AuraEnabled or self.OwnerParticles) then
			--print("Stopping particles")
			
			self.Owner:StopParticles()
			
			self.OwnerParticles = nil
			self.AuraEnabled = nil
		end
	end
	
	if self.Charging && self.ChargeTime - 0.25 < CurTime() && !self.attack then
		if self.Owner:GetAmmoCount(self.Primary.Ammo) >= (skill_data.energy or self.AmmoPerUse) then
			--self.Weapon:SendWeaponAnim(ACT_VM_SECONDARYATTACK)
			self:DispatchEffect("vortigaunt_charge_token")
			
			timer.Simple(0.75, function()
				if !IsValid(self.Owner) || self.Owner:GetActiveWeapon() != self || !IsValid(self) then return end 
				--self.Weapon:SendWeaponAnim(ACT_VM_IDLE)
				
				if SERVER then
					self.Owner:forceSequence("")
				end
				
				self.Owner:ResetSequenceInfo()
			end)
		end
		
		self.attack = true;
	end
	
	if self.Charging && self.ChargeTime < CurTime() then
		if self.Owner:GetAmmoCount(self.Primary.Ammo) < (skill_data.energy or self.AmmoPerUse) then 
			self.Weapon:EmitSound(self.Deny)
			
			self.Weapon:SetNextPrimaryFire(CurTime() + SoundDuration(self.Deny))
			self.Weapon:SetNextSecondaryFire(CurTime() + SoundDuration(self.Deny))
			
			if IsValid(self.Owner:GetViewModel()) then 
				self.Owner:GetViewModel():StopParticles() 
			end
			
			self.Owner:StopParticles()
			self.Charging = false;
			--self.Weapon:SendWeaponAnim(ACT_VM_IDLE)
			
			if SERVER then
				self.Owner:forceSequence("")
				
				if self.ChargeSound then
					self.ChargeSound:Stop();
				end
			end
			
			return
		end
		
		self.Owner:RemoveAmmo(skill_data.energy or self.AmmoPerUse, self.Primary.Ammo);
		
		if IsValid(self.Owner:GetViewModel()) then 
			self.Owner:GetViewModel():StopParticles() 
		end
		
		self.Owner:StopParticles()
		
		self:Shoot()
		
		self.Charging = false;
		self.attack = false;
		
		if SERVER && self.ChargeSound then	
			self.ChargeSound:Stop();
		end
		
		self.Weapon:SetNextPrimaryFire(CurTime() + 1)
		self.Weapon:SetNextSecondaryFire(CurTime() + 1)
		
		return
	end
	
	if self.Healing && self.HealTime < CurTime() then
		if self.Owner:GetAmmoCount(self.Primary.Ammo) < (skill_data.energy or self.AmmoPerUse) then 
			self.Weapon:EmitSound(self.Deny)
			self.Weapon:SetNextPrimaryFire(CurTime() + SoundDuration(self.Deny))
			self.Weapon:SetNextSecondaryFire(CurTime() + SoundDuration(self.Deny))
			
			if IsValid(self.Owner:GetViewModel()) then 
				self.Owner:GetViewModel():StopParticles() 
			end
			
			self.Owner:StopParticles()
			self.Healing=false;
			--self.Weapon:SendWeaponAnim(ACT_VM_IDLE)
			
			if SERVER then
				self.Owner:forceSequence("")
				
				if self.HealingSound then
					self.HealingSound:Stop();
				end
			end
			
			return
		end
		
		if IsValid(self.Owner:GetViewModel()) then 
			self.Owner:GetViewModel():StopParticles() 
		end
		
		self.Owner:StopParticles()
		--self.Weapon:SendWeaponAnim(ACT_VM_IDLE)
		self.Healing = false;
		self.Owner:EmitSound(self.HealSound)
		
		if SERVER && self.HealingSound then	
			self.HealingSound:Stop();
		end
		
		local start_action = function(success)
			if not success then
				self.Weapon:EmitSound(self.Deny)
				return
			end
			
			self.Owner:RemoveAmmo(skill_data.energy or self.AmmoPerUse, self.Primary.Ammo);
			self:GiveArmor()
		end
		
		if skill_settings.pre_use then
			skill_settings.pre_use(self, self.Owner, start_action)
			
		else
			start_action(true)
		end
		
		self.Weapon:SetNextPrimaryFire(CurTime() + 1)
		self.Weapon:SetNextSecondaryFire(CurTime() + 1)
		return
	end

	if SERVER && self.NextAmmo < CurTime() && self.Owner:GetAmmoCount("VortigontFire") < 99 then
		self.Owner:GiveAmmo(1, "VortigontFire", true)
		self.NextAmmo = CurTime() + 1 / self.EnergyRestore
	end
end


function SWEP:PrimaryAttack()
	if self.Charging || self.Healing then return end
	
	local skill_data = self:GetSkillData()
	
	if not skill_data or not self.Types[skill_data.skill_type] then
		self.Weapon:EmitSound(self.Deny)
		self.Weapon:SetNextPrimaryFire(CurTime() + SoundDuration(self.Deny))
		self.Weapon:SetNextSecondaryFire(CurTime() + SoundDuration(self.Deny))
		return
	end
	
	local skill_settings = self.Types[skill_data.skill_type]
	
	if self.Owner:GetAmmoCount(self.Primary.Ammo) < (skill_data.energy or self.AmmoPerUse) then 
		self.Weapon:EmitSound(self.Deny)
		self.Weapon:SetNextPrimaryFire(CurTime() + SoundDuration(self.Deny))
		self.Weapon:SetNextSecondaryFire(CurTime() + SoundDuration(self.Deny))
		
		return 
	end
	
	self:DispatchEffect("vortigaunt_charge_token_b")
	self:DispatchEffect("vortigaunt_charge_token_c")
	
	self.ChargeTime = CurTime() + (skill_data.charge_shot or self.BeamChargeTime);
	self.attack = false;
	self.Charging = true
	
	if SERVER then
		self.Owner:forceSequence(skill_settings.custom_anim or "zapattack1", nil, skill_settings.custom_anim_time, true, 1.6 / (skill_data.charge_shot or 1.6)) -- self.Weapon:SendWeaponAnim(ACT_VM_RELOAD)
		
		if self.ChargeSound then
			self.ChargeSound:PlayEx(100, 150);
		end
	end
	
	--self.Owner:SetPlaybackRate(1.6 / (skill_data.charge_shot or 1.6))
	
	self.Weapon:SetNextPrimaryFire(CurTime() + 3)
	self.Weapon:SetNextSecondaryFire(CurTime() + 3)
end


function SWEP:SecondaryAttack()
	if self.Charging || self.Healing then return end
	
	local skill_data = self:GetSkillData()
	
	if not skill_data or not self.Types['self-' .. skill_data.skill_type] then
		self.Weapon:EmitSound(self.Deny)
		self.Weapon:SetNextPrimaryFire(CurTime() + SoundDuration(self.Deny))
		self.Weapon:SetNextSecondaryFire(CurTime() + SoundDuration(self.Deny))
		return
	end
	
	local skill_settings = self.Types['self-' .. skill_data.skill_type]
	
	if skill_settings.check then
		local check_result, term = skill_settings.check(self, self.Owner)
		
		if not check_result then
			self.Weapon:EmitSound(self.Deny)
			self.Weapon:SetNextPrimaryFire(CurTime() + SoundDuration(self.Deny))
			self.Weapon:SetNextSecondaryFire(CurTime() + SoundDuration(self.Deny))
			return
		end
	end
	
	if self.Owner:GetAmmoCount(self.Primary.Ammo) < (skill_data.energy or self.AmmoPerUse) then 
		self.Weapon:EmitSound(self.Deny)
		self.Weapon:SetNextPrimaryFire(CurTime() + SoundDuration(self.Deny))
		self.Weapon:SetNextSecondaryFire(CurTime() + SoundDuration(self.Deny))
		
		return 
	end
	
	self.HealTime = CurTime() + (skill_data.charge_self or self.HealDelay);
	self.Healing = true;
	
	self:DispatchEffect("vortigaunt_charge_token")
	
	if SERVER then
		self.Owner:forceSequence(skill_settings.custom_anim or "heal_cycle", nil, skill_settings.custom_anim_time, true) -- self.Weapon:SendWeaponAnim(ACT_VM_RELOAD)
		
		if self.HealingSound then
			self.HealingSound:PlayEx(100, 150);
		end
	end

	self.Weapon:SetNextPrimaryFire(CurTime() + 1)
	self.Weapon:SetNextSecondaryFire(CurTime() + 1)
end

function SWEP:Reload()
	if self.NextModeChange and self.NextModeChange > CurTime() then return end
	self.NextModeChange = CurTime() + 1
	
	if self.Charging or self.Healing or self:GetAuraEnabled() then return end
	
	if SERVER then
		self:SetSkillMode(self:GetSkillMode() % (#self.Skills) + 1)
		print(self, "Skill mode now: " .. self:GetSkillMode())
	end
end

if SERVER then
	util.AddNetworkString("Vort::Effects")
	
	function SWEP:BroadcastEffect(effect_name, effect_entity, effect_pos, effect_time, effect_repeats)
		net.Start("Vort::Effects")
			net.WriteString(effect_name)
			net.WriteEntity(effect_entity)
			net.WriteVector(effect_pos)
			net.WriteFloat(effect_time)
			net.WriteUInt(effect_repeats, 6)
			net.WriteEntity(self)
		net.Broadcast()
	end
end

if CLIENT then
	local vort_filled = Material("vorticons/vort_down")
	local vort_filled_color = Color(240, 180, 55, 215)

	local vort_lined = Material("vorticons/vort_up")
	local vort_lined_color = Color(255, 255, 255, 255)

	local spell_back = Material("vorticons/container")

	local white_color = Color(255, 255, 255, 255)
	local white_trans_color = Color(255, 255, 255, 120)

	local scrW, scrH
	local vort_scale, self_scale
	local center_x, center_y
	local cont_pos_x, cont_pos_y

	local last_selected = 0
	local last_selected_time = 0
	local last_selected_alpha = 0
	local scales = {}

	local selected

	surface.CreateFont('Vort::Font', {
		font = 'Open Sans Light',
		size = 24,
		weight = 700,
		extended = true,
		shadow = true
	})

	local cur_energy_level = 0
	
	function SWEP:DrawHUD()
		scrW, scrH = ScrW(), ScrH()
		
		selected = self:GetSkillMode()
		vort_scale = scrH / 7
		
		surface.SetMaterial(vort_filled)
		surface.SetDrawColor(Color(0, 0, 0, 70))
		surface.DrawTexturedRect((scrW - vort_scale) * 0.5, scrH - vort_scale * 1.8, vort_scale, vort_scale)
		
		cur_energy_level = cur_energy_level + (math.min(1, LocalPlayer():GetAmmoCount("VortigontFire") / 99) - cur_energy_level) * 0.3
		
		render.SetScissorRect((scrW - vort_scale) * 0.5, scrH - vort_scale * 1.8 + vort_scale * (1 - cur_energy_level), (scrW + vort_scale) * 0.5, scrH - vort_scale * 0.8, true)
			surface.SetDrawColor(vort_filled_color)
			surface.DrawTexturedRect((scrW - vort_scale) * 0.5, scrH - vort_scale * 1.8, vort_scale, vort_scale)
		render.SetScissorRect(0, 0, 0, 0, false)
		
		surface.SetMaterial(vort_lined)
		surface.SetDrawColor(vort_lined_color)
		surface.DrawTexturedRect((scrW - vort_scale) * 0.5, scrH - vort_scale * 1.8, vort_scale, vort_scale)
		
		if selected ~= last_selected then
			last_selected = selected
			last_selected_time = CurTime() + 1.5
			last_selected_alpha = 255
		end
		
		if CurTime() > last_selected_time then
			last_selected_alpha = math.Approach(last_selected_alpha, 0, 7)
		end
		
		center_x, center_y = scrW * 0.5, scrH - vort_scale * 1.3
		
		for k, v in pairs(self.Skills) do
			cont_pos_x, cont_pos_y = center_x + vort_scale * v.hud_image_offset_radius * math.cos(math.rad(v.hud_image_offset_angle)), center_y - vort_scale * v.hud_image_offset_radius * math.sin(math.rad(v.hud_image_offset_angle))
			
			scales[k] = math.Approach(scales[k] or 0.28, (selected == k) and 0.32 or 0.28, 0.004)
			
			surface.SetMaterial(spell_back)
			surface.SetDrawColor(ColorAlpha(white_color, selected == k and 210 or 190))
			surface.DrawTexturedRectRotated(cont_pos_x, cont_pos_y, vort_scale * scales[k], vort_scale * scales[k], CurTime() * 8 + k * 222)
			
			self_scale = (selected == k) and (vort_scale * 0.22) or (vort_scale * 0.2)
			
			surface.SetMaterial(v.hud_image)
			surface.SetDrawColor(selected == k and vort_filled_color or white_trans_color)
			surface.DrawTexturedRect(cont_pos_x - self_scale * 0.5, cont_pos_y - self_scale * 0.5, self_scale, self_scale)
			
			if last_selected_alpha > 1 and selected == k then
				draw.SimpleText(v.name, "Vort::Font", cont_pos_x + self_scale * math.cos(math.rad(v.hud_image_offset_angle)), cont_pos_y - self_scale * math.sin(math.rad(v.hud_image_offset_angle)), ColorAlpha(white_color, last_selected_alpha), v.hud_text_align[1], v.hud_text_align[2])
			end
		end
	end
	
	net.Receive("Vort::Effects", function()
		local effect_name = net.ReadString()
		local effect_entity = net.ReadEntity()
		local effect_pos = net.ReadVector()
		local effect_time = net.ReadFloat()
		local effect_repeats = net.ReadUInt(6)
		local swep = net.ReadEntity()
		
		ParticleEffectAttach(effect_name, 1, effect_entity, 0)
		
		if effect_time == 0 then
			return 
		end
		
		if effect_repeats == 1 then
			timer.Simple(effect_time, function()
				if not IsValid(effect_entity) then return end
				effect_entity:StopParticles()
			end)
			
		else
			local timer_name = "Vort::CustomEffect" .. swep:EntIndex()
			
			timer.Create(timer_name, effect_time, effect_repeats, function()
				if not IsValid(effect_entity) or not IsValid(swep) or not swep.GetAuraEnabled or not swep:GetAuraEnabled() then 
					return timer.Remove(timer_name)
				end
				
				ParticleEffectAttach(effect_name, 1, effect_entity, 0)
			end)
			
			if effect_repeats > 0 then
				timer.Simple(effect_time * effect_repeats, function()
					if not IsValid(effect_entity) then return end
					effect_entity:StopParticles()
				end)
			end
		end
	end)
	
	local stun_halos = {}
	local emty_emote = { [""] = true, }
	
	if not rp.cfg.NoFreezeHalos then
		timer.Create("Vort::DrawStunnedHalos", 0.5, 0, function()
			stun_halos = {}
			
			for k, v in pairs(player.GetAll()) do
				if IsValid(v) and v:IsFlagSet(FL_FROZEN) and not v.NoHalo and emty_emote[v:GetEmoteAction()] then
					table.insert(stun_halos, v)
				end
			end
		end)
		
		hook.Add( "PreDrawHalos" , "Vort::DrawStunHalos" , function()
			if not table.IsEmpty(stun_halos) then
				halo.Add(stun_halos, Color(80, 110, 225), 2, 2, 1, true, false) 
			end
		end)
	end
end


SWEP.IdleTranslate = { }
SWEP.IdleTranslate[ ACT_MP_STAND_IDLE ]                     = ACT_IDLE;
SWEP.IdleTranslate[ ACT_MP_WALK ]                           = ACT_WALK;
SWEP.IdleTranslate[ ACT_MP_RUN ]                            = ACT_RUN;
SWEP.IdleTranslate[ ACT_MP_CROUCH_IDLE ]                    = ACT_WALK;
SWEP.IdleTranslate[ ACT_MP_CROUCHWALK ]                     = ACT_WALK ;
SWEP.IdleTranslate[ ACT_MP_ATTACK_STAND_PRIMARYFIRE ]       = ACT_MELEE_ATTACK1;
SWEP.IdleTranslate[ ACT_MP_ATTACK_CROUCH_PRIMARYFIRE ]      = ACT_MELEE_ATTACK_SWING;
SWEP.IdleTranslate[ ACT_MP_RELOAD_STAND ]                   = ACT_RELOAD;
SWEP.IdleTranslate[ ACT_MP_RELOAD_CROUCH ]                  = ACT_RELOAD;
SWEP.IdleTranslate[ ACT_MP_JUMP ]                           = ACT_IDLE;
SWEP.IdleTranslate[ ACT_MP_SWIM_IDLE ]                      = ACT_IDLE;
SWEP.IdleTranslate[ ACT_MP_SWIM ]                           = ACT_IDLE;
SWEP.IdleTranslate[ ACT_GMOD_NOCLIP_LAYER]                  = ACT_GLIDE;
SWEP.IdleTranslate[ ACT_MP_STAND_IDLE ]                     = ACT_IDLE;

--local prev = 0
function SWEP:TranslateActivity( act )
	--if act != prev then
	--	prev = act
	--	print(act)
	--end
	
	if ( self.IdleTranslate[ act ] != nil ) then
 		return self.IdleTranslate[ act ]
	end
	return -1
end