-- "gamemodes\\darkrp\\entities\\weapons\\nut_stunstick.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
AddCSLuaFile()

local DRUG = {};
DRUG.Name = "Stunstick";
DRUG.Duration = 1;

DRUG.NoKarmaLoss = true;

local math = math

function DRUG:StartHighServer(pl)
	pl.StunstickOldWalkSpeed = pl.StunstickOldRunSpeed or pl:GetWalkSpeed();
	pl.StunstickOldRunSpeed = pl.StunstickOldRunSpeed or pl:GetRunSpeed();

	pl:SetWalkSpeed(pl.StunstickOldRunSpeed * 0.5);
	pl:SetRunSpeed(pl.StunstickOldWalkSpeed * 0.5);

	pl.stunStacks = 1
end

function DRUG:CalculateDuration(pl, stacks)
	return math.min(stacks * 3, 15)
end

--function DRUG:TickServer(pl, stacks, startTime, endTime)
--end

function DRUG:AddStack(pl, stacks)
	pl:SetWalkSpeed(pl:GetRunSpeed() * 0.7);
	pl:SetRunSpeed(pl:GetRunSpeed() * 0.7);
	pl.stunStacks = math.max((pl.stunStacks or 0) + 1, 5)
end

function DRUG:EndHighServer(pl)
	if (pl.StunstickOldWalkSpeed) then
		pl:SetWalkSpeed(pl.StunstickOldWalkSpeed);
		pl.StunstickOldWalkSpeed = nil;
	end
	
	if (pl.StunstickOldRunSpeed) then
		pl:SetRunSpeed(pl.StunstickOldRunSpeed);
		pl.StunstickOldRunSpeed = nil;
	end

	if !pl:Alive() && pl.stunStacks > 2 then
		pl:Arrest()
	end
	pl.stunStacks = nil
end

--function DRUG:StartHighClient(pl)
--end

--function DRUG:TickClient(pl, stacks, startTime, endTime)
--end

--function DRUG:EndHighClient(pl)
--end

function DRUG:HUDPaint(pl, stacks, startTime, endTime)
--print(startTime, endTime, (CurTime() - startTime)/ endTime)
	--local duration = endTime - startTime
	--local passed = CurTime() - startTime
	--print(CurTime() , startTime , CurTime() - startTime)
	--print(passed / duration)
	--local alpha
	--if passed < 0.9 then
	--	alpha = (passed  / duration) * math.min(stacks * 50, 255)
	--else
	--	alpha = (1 - (passed / duration)) * math.min(stacks * 50, 255)
	--end
	alpha = math.min(stacks * 75, 255)

	surface.SetDrawColor(255,255,255, alpha)
	surface.DrawRect(0,0,ScrW(), ScrH())
end

--function DRUG:RenderSSEffects(pl, stacks, startTime, endTime)
--end

RegisterDrug(DRUG);

local CurTime = CurTime

if (CLIENT) then
	SWEP.PrintName = "Stunstick"
	SWEP.Slot = 1
	SWEP.SlotPos = 2
	SWEP.DrawAmmo = false
	SWEP.DrawCrosshair = false
end

SWEP.Category = "HL2 RP"
SWEP.Author = "Chessnut"
SWEP.Instructions = "Primary Fire: [RAISED] Strike\nALT + Primary Fire: [RAISED] Toggle stun\nSecondary Fire: Push/Knock"
SWEP.Purpose = "Hitting things and knocking on doors."
SWEP.Drop = false

SWEP.HoldType = "melee"

SWEP.Spawnable = true
SWEP.AdminOnly = true

SWEP.ViewModelFOV = 47
SWEP.ViewModelFlip = false
SWEP.AnimPrefix	 = "melee"

SWEP.ViewTranslation = 4

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = ""
SWEP.Primary.Damage = 8
SWEP.Primary.Delay = 0.7

SWEP.StunDamage = 15

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = ""

SWEP.ViewModel = Model("models/weapons/c_stunstick.mdl")
SWEP.WorldModel = Model("models/weapons/w_stunbaton.mdl")

SWEP.UseHands = true

SWEP.replaceModels = {}
SWEP.IdleTranslate = { }
SWEP.IdleTranslate[ ACT_MP_STAND_IDLE ]                     = ACT_IDLE;
SWEP.IdleTranslate[ ACT_MP_WALK ]                           = ACT_WALK;
SWEP.IdleTranslate[ ACT_MP_RUN ]                            = ACT_RUN;
SWEP.IdleTranslate[ ACT_MP_CROUCH_IDLE ]                    = ACT_COVER_PISTOL_LOW;
SWEP.IdleTranslate[ ACT_MP_CROUCHWALK ]                     = ACT_WALK_CROUCH ;
SWEP.IdleTranslate[ ACT_MP_ATTACK_STAND_PRIMARYFIRE ]       = ACT_MELEE_ATTACK_SWING;
SWEP.IdleTranslate[ ACT_MP_ATTACK_CROUCH_PRIMARYFIRE ]      = ACT_MELEE_ATTACK_SWING;
SWEP.IdleTranslate[ ACT_MP_RELOAD_STAND ]                   = ACT_RELOAD;
SWEP.IdleTranslate[ ACT_MP_RELOAD_CROUCH ]                  = ACT_RELOAD;
SWEP.IdleTranslate[ ACT_MP_JUMP ]                           = ACT_JUMP;
SWEP.IdleTranslate[ ACT_MP_SWIM_IDLE ]                      = ACT_JUMP;
SWEP.IdleTranslate[ ACT_MP_SWIM ]                           = ACT_JUMP;
 
SWEP.AngryTranslate = { }
SWEP.AngryTranslate[ ACT_MP_STAND_IDLE ]                    = ACT_IDLE_ANGRY_MELEE;
SWEP.AngryTranslate[ ACT_MP_WALK ]                          = ACT_WALK_ANGRY;
SWEP.AngryTranslate[ ACT_MP_RUN ]                           = ACT_RUN;
SWEP.AngryTranslate[ ACT_MP_CROUCH_IDLE ]                   = ACT_COVER_PISTOL_LOW;
SWEP.AngryTranslate[ ACT_MP_CROUCHWALK ]                    = ACT_WALK_CROUCH ;
SWEP.AngryTranslate[ ACT_MP_ATTACK_STAND_PRIMARYFIRE ]      = ACT_MELEE_ATTACK_SWING;
SWEP.AngryTranslate[ ACT_MP_ATTACK_CROUCH_PRIMARYFIRE ]     = ACT_MELEE_ATTACK_SWING;
SWEP.AngryTranslate[ ACT_MP_RELOAD_STAND ]                  = ACT_RELOAD;
SWEP.AngryTranslate[ ACT_MP_RELOAD_CROUCH ]                 = ACT_RELOAD;
SWEP.AngryTranslate[ ACT_MP_JUMP ]                          = ACT_JUMP;
SWEP.AngryTranslate[ ACT_MP_SWIM_IDLE ]                     = ACT_JUMP;
SWEP.AngryTranslate[ ACT_MP_SWIM ]                          = ACT_JUMP;


if SERVER then

	SWEP.replaceModels["models/dpfilms/metropolice/playermodels/pm_arctic_police.mdl"] = "models/dpfilms/metropolice/arctic_police.mdl"
	SWEP.replaceModels["models/dpfilms/metropolice/playermodels/pm_badass_police.mdl"] = "models/dpfilms/metropolice/badass_police.mdl"
	SWEP.replaceModels["models/dpfilms/metropolice/playermodels/pm_biopolice.mdl"] = "models/dpfilms/metropolice/biopolice.mdl"
	SWEP.replaceModels["models/dpfilms/metropolice/playermodels/pm_blacop.mdl"] = "models/dpfilms/metropolice/blacop.mdl"
	SWEP.replaceModels["models/dpfilms/metropolice/playermodels/pm_c08cop.mdl"] = "models/dpfilms/metropolice/c08cop.mdl"
	SWEP.replaceModels["models/dpfilms/metropolice/playermodels/pm_civil_medic.mdl"] = "models/dpfilms/metropolice/civil_medic.mdl"
	SWEP.replaceModels["models/dpfilms/metropolice/playermodels/pm_elite_police.mdl"] = "models/dpfilms/metropolice/elite_police.mdl"
	SWEP.replaceModels["models/dpfilms/metropolice/playermodels/pm_female_police.mdl"] = "models/dpfilms/metropolice/female_police.mdl"
	SWEP.replaceModels["models/dpfilms/metropolice/playermodels/pm_hd_barney.mdl"] = "models/dpfilms/metropolice/hd_barney.mdl"
	SWEP.replaceModels["models/dpfilms/metropolice/playermodels/pm_hdpolice.mdl"] = "models/dpfilms/metropolice/hdpolice.mdl"
	SWEP.replaceModels["models/dpfilms/metropolice/playermodels/pm_hl2beta_police.mdl"] = "models/dpfilms/metropolice/hl2beta_police.mdl"
	SWEP.replaceModels["models/dpfilms/metropolice/playermodels/pm_hl2concept.mdl"] = "models/dpfilms/metropolice/hl2concept.mdl"
	SWEP.replaceModels["models/dpfilms/metropolice/playermodels/pm_hunter_police.mdl"] = "models/dpfilms/metropolice/hunter_police.mdl"
	SWEP.replaceModels["models/dpfilms/metropolice/playermodels/pm_phoenix_police.mdl"] = "models/dpfilms/metropolice/phoenix_police.mdl"
	SWEP.replaceModels["models/dpfilms/metropolice/playermodels/pm_police_bt.mdl"] = "models/dpfilms/metropolice/police_bt.mdl"
	SWEP.replaceModels["models/dpfilms/metropolice/playermodels/pm_police_fragger.mdl"] = "models/dpfilms/metropolice/police_fragger.mdl"
	SWEP.replaceModels["models/dpfilms/metropolice/playermodels/pm_policetrench.mdl"] = "models/dpfilms/metropolice/policetrench.mdl"
	SWEP.replaceModels["models/dpfilms/metropolice/playermodels/pm_resistance_police.mdl"] = "models/dpfilms/metropolice/resistance_police.mdl"
	SWEP.replaceModels["models/dpfilms/metropolice/playermodels/pm_retrocop.mdl"] = "models/dpfilms/metropolice/retrocop.mdl"
	SWEP.replaceModels["models/dpfilms/metropolice/playermodels/pm_rogue_police.mdl"] = "models/dpfilms/metropolice/rogue_police.mdl"
	SWEP.replaceModels["models/dpfilms/metropolice/playermodels/pm_rtb_police.mdl"] = "models/dpfilms/metropolice/rtb_police.mdl"
	SWEP.replaceModels["models/dpfilms/metropolice/playermodels/pm_steampunk_police.mdl"] = "models/dpfilms/metropolice/steampunk_police.mdl"
	SWEP.replaceModels["models/dpfilms/metropolice/playermodels/pm_tf2_metrocop.mdl"] = "models/dpfilms/metropolice/tf2_metrocop.mdl"
	SWEP.replaceModels["models/dpfilms/metropolice/playermodels/pm_tribal_police.mdl"] = "models/dpfilms/metropolice/tribal_police.mdl"
	SWEP.replaceModels["models/dpfilms/metropolice/playermodels/pm_tron_police.mdl"] = "models/dpfilms/metropolice/tron_police.mdl"
	SWEP.replaceModels["models/dpfilms/metropolice/playermodels/pm_urban_police.mdl"] = "models/dpfilms/metropolice/urban_police.mdl"
	SWEP.replaceModels["models/dpfilms/metropolice/playermodels/pm_zombie_police.mdl"] = "models/dpfilms/metropolice/zombie_police.mdl"
	SWEP.replaceModels["models/dpfilms/metropolice/playermodels/pm_tron_police_or.mdl"] = "models/dpfilms/metropolice/tron_police_or.mdl"
	SWEP.replaceModels["models/dpfilms/metropolice/playermodels/pm_tron_police_cn.mdl"] = "models/dpfilms/metropolice/tron_police_cn.mdl"
	SWEP.replaceModels["models/dpfilms/metropolice/playermodels/pm_black_police.mdl"] = "models/dpfilms/metropolice/blacop.mdl"
	

	SWEP.replaceModels["models/player/police.mdl"] = "models/Police.mdl"
	SWEP.replaceModels["models/player/police_fem.mdl"] = "models/Police.mdl"


	function SWEP:Deploy()
		if self.replaceModels[self.Owner:GetModel()] then
			self.PrevModel = self.Owner:GetModel()
			self.Owner:SetModel(self.replaceModels[self.Owner:GetModel()])
		elseif !self.replaceModels[self.PrevModel] then
			self.Owner:StripWeapon(self:GetClass())
		end
	end
end

function SWEP:TranslateActivity( act )
	if self:GetActivated() then
		if ( self.AngryTranslate[ act ] != nil ) then
			return self.AngryTranslate[ act ]
		end
	 	return -1
	else
	 	if ( self.IdleTranslate[ act ] != nil ) then
		 	return self.IdleTranslate[ act ]
	 	end
	 	return -1
	end
end

function SWEP:SetupDataTables()
	self:NetworkVar("Bool", 0, "Activated")
end

function SWEP:Precache()
	util.PrecacheSound("weapons/stunstick/stunstick_swing1.wav")
	util.PrecacheSound("weapons/stunstick/stunstick_swing2.wav")
	util.PrecacheSound("weapons/stunstick/stunstick_impact1.wav")	
	util.PrecacheSound("weapons/stunstick/stunstick_impact2.wav")
	util.PrecacheSound("weapons/stunstick/spark1.wav")
	util.PrecacheSound("weapons/stunstick/spark2.wav")
	util.PrecacheSound("weapons/stunstick/spark3.wav")
end

function SWEP:Initialize()
	self:SetHoldType(self.HoldType)
end

function SWEP:PrimaryAttack()	
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)

//if (!self.Owner:isWepRaised()) then
//	return
//end

	if (self.Owner:KeyDown(IN_WALK)) then
		if (SERVER) then
			self:SetActivated(!self:GetActivated())
			if !self:GetActivated() then
				self:SetHoldType("normal")
			else
				self:SetHoldType("melee")
			end

			local sequence = "deactivatebaton"

			if (self:GetActivated()) then
				self.Owner:EmitSound("weapons/stunstick/spark3.wav", 100, math.random(90, 110))
				sequence = "activatebaton"
			else
				self.Owner:EmitSound("weapons/stunstick/spark"..math.random(1, 2)..".wav", 100, math.random(90, 110))
			end

			local vel = self.Owner:GetVelocity()
			if vel.x == 0 && vel.y == 0 && vel.z == 0 then
				self.Owner:forceSequence(sequence)
			end
		end

		return
	end

	self:EmitSound("weapons/stunstick/stunstick_swing"..math.random(1, 2)..".wav", 70)
	self:SendWeaponAnim(ACT_VM_HITCENTER)

	self.Owner:SetAnimation(PLAYER_ATTACK1)
	self.Owner:ViewPunch(Angle(1, 0, 0.125))

	self.Owner:LagCompensation(true)
		local data = {}
		data.start = self.Owner:GetShootPos()
		data.endpos = data.start + self.Owner:GetAimVector()*72
		data.filter = self.Owner
		local trace = util.TraceLine(data)
	self.Owner:LagCompensation(false)

	if (SERVER and trace.Hit) then
		if (self:GetActivated()) then
			local effect = EffectData()
				effect:SetStart(trace.HitPos)
				effect:SetNormal(trace.HitNormal)
				effect:SetOrigin(trace.HitPos)
			util.Effect("StunstickImpact", effect, true, true)
		end

		self.Owner:EmitSound("weapons/stunstick/stunstick_impact"..math.random(1, 2)..".wav")

		local entity = trace.Entity

		local damage = self.Primary.Damage
		if (IsValid(entity)) then
			if (entity:IsPlayer()) then
				if self:GetActivated() then
					entity:AddHigh('Stunstick')
					damage = self.StunDamage
					if (entity.stunStacks || 0) > 4 then
						if entity:IsWanted() then
							entity:Arrest(self.Owner)
						else
							rp.Notify(self.Owner, NOTIFY_ERROR, rp.Term('PlayerNotWanted'))
						end
					end
				end
				entity:ViewPunch(Angle(-20, math.random(-15, 15), math.random(-10, 10)))
			elseif entity.SeizeReward and entity.WantReason then
				local owner = entity.ItemOwner

				if IsValid(owner) and not entity.ItemOwner:IsWanted() then
					entity.ItemOwner:Wanted(self.Owner, entity.WantReason)
				end

				entity:Remove()
				self.Owner:AddMoney(entity.SeizeReward)
				rp.Notify(self.Owner, NOTIFY_GREEN, rp.Term('ArrestBatonBonus'), rp.FormatMoney(entity.SeizeReward))
				return
			end
		end

		local damageInfo = DamageInfo()
			damageInfo:SetAttacker(self.Owner)
			damageInfo:SetInflictor(self)
			damageInfo:SetDamage(damage)
			damageInfo:SetDamageType(DMG_CLUB)
			damageInfo:SetDamagePosition(trace.HitPos)
			damageInfo:SetDamageForce(self.Owner:GetAimVector()*10000)
		entity:DispatchTraceAttack(damageInfo, data.start, data.endpos)
	end
end

function SWEP:Holster(nextWep)
	self:SetActivated(false)
	if SERVER and self.PrevModel then
		self.Owner:SetModel(self.PrevModel)
	end

	return true
end

function SWEP:OnRemove()
	self:Holster()
end

function SWEP:SecondaryAttack()
	self.Owner:LagCompensation(true)
		local data = {}
			data.start = self.Owner:GetShootPos()
			data.endpos = data.start + self.Owner:GetAimVector()*72
			data.filter = self.Owner
			data.mins = Vector(-8, -8, -30)
			data.maxs = Vector(8, 8, 10)
		local trace = util.TraceHull(data)
		local entity = trace.Entity
	self.Owner:LagCompensation(false)

	if (SERVER) && IsValid(entity) then
		local pushed

		if (entity:IsPlayer()) then
			local direction = self.Owner:GetAimVector() * (400 * ((entity.stunStacks && math.max(entity.stunStacks, 2) * 0.8) || 1))
			direction.z = 0

			entity:SetVelocity(direction)

			pushed = true
		else
			local physObj = entity:GetPhysicsObject()

			if (IsValid(physObj)) then
				physObj:SetVelocity(self.Owner:GetAimVector() * 180)
			end

			pushed = true
		end

		if (pushed) then
			self:SetNextSecondaryFire(CurTime() + 1.5)
			self:SetNextPrimaryFire(CurTime() + 1.5)
			self.Owner:EmitSound("weapons/crossbow/hitbod"..math.random(1, 2)..".wav")

			local model = string.lower(self.Owner:GetModel())
			local owner = self.Owner

			self.Owner:forceSequence("pushplayer")

		end
	end
end

function SWEP:Reload()
	self:SetNextPrimaryFire(CurTime() + 2.5)
	self:SetNextSecondaryFire(CurTime() + 2.5)
	if SERVER then
		self.Owner:forceSequence("luggagewarn")
	end
end

local STUNSTICK_GLOW_MATERIAL = Material("effects/stunstick")
local STUNSTICK_GLOW_MATERIAL2 = Material("effects/blueflare1")
local STUNSTICK_GLOW_MATERIAL_NOZ = Material("sprites/light_glow02_add_noz")

local color_glow = Color(128, 128, 128)

function SWEP:DrawWorldModel()
	self:DrawModel()

	if (self:GetActivated()) then
		local size = math.Rand(4.0, 6.0)
		local glow = math.Rand(0.6, 0.8) * 255
		local color = Color(glow, glow, glow)
		local attachment = self:GetAttachment(1)

		if (attachment) then
			local position = attachment.Pos

			render.SetMaterial(STUNSTICK_GLOW_MATERIAL2)
			render.DrawSprite(position, size * 2, size * 2, color)

			render.SetMaterial(STUNSTICK_GLOW_MATERIAL)
			render.DrawSprite(position, size, size + 3, color_glow)
		end
	end
end

local NUM_BEAM_ATTACHEMENTS = 9
local BEAM_ATTACH_CORE_NAME	= "sparkrear"

function SWEP:PostDrawViewModel()
	if (!self:GetActivated()) then
		return
	end

	local viewModel = LocalPlayer():GetViewModel()

	if (!IsValid(viewModel)) then
		return
	end

	cam.Start3D(EyePos(), EyeAngles())
		local size = math.Rand(3.0, 4.0)
		local color = Color(255, 255, 255, 50 + math.sin(RealTime() * 2)*20)

		STUNSTICK_GLOW_MATERIAL_NOZ:SetFloat("$alpha", color.a / 255)

		render.SetMaterial(STUNSTICK_GLOW_MATERIAL_NOZ)

		local attachment = viewModel:GetAttachment(viewModel:LookupAttachment(BEAM_ATTACH_CORE_NAME))

		if (attachment) then
			render.DrawSprite(attachment.Pos, size * 10, size * 15, color)
		end

		for i = 1, NUM_BEAM_ATTACHEMENTS do
			local attachment = viewModel:GetAttachment(viewModel:LookupAttachment("spark"..i.."a"))

			size = math.Rand(2.5, 5.0)

			if (attachment and attachment.Pos) then
				render.DrawSprite(attachment.Pos, size, size, color)
			end

			local attachment = viewModel:GetAttachment(viewModel:LookupAttachment("spark"..i.."b"))

			size = math.Rand(2.5, 5.0)

			if (attachment and attachment.Pos) then
				render.DrawSprite(attachment.Pos, size, size, color)
			end
		end
	cam.End3D()
end
