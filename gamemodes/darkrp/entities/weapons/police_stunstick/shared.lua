AddCSLuaFile()
if SERVER then
    AddCSLuaFile("cl_init.lua")
end

local DRUG = {};
DRUG.Name = "Дубинка";
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
	return math.min(stacks * 3, 30)
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
		pl:Arrest(pl, '')
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
	--alpha = math.min(stacks * 75, 255)

	surface.SetDrawColor(255,255,255, math.min(stacks * 75, 255))
	surface.DrawRect(0,0,ScrW(), ScrH())
end

--function DRUG:RenderSSEffects(pl, stacks, startTime, endTime)
--end

RegisterDrug(DRUG);

local CurTime = CurTime

if (CLIENT) then
	SWEP.PrintName = "Станстик"
	SWEP.Slot = 1
	SWEP.SlotPos = 2
	SWEP.DrawAmmo = false
	SWEP.DrawCrosshair = false
end

SWEP.hitRequireForStun = 2;
SWEP.stunTime = 10;
SWEP.primaryFireDamage = 10;

SWEP.primaryFireDelay = 0.5;
SWEP.secondaryFireDelay = 2;

SWEP.Category = "Half-Life Alyx RP"
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
SWEP.Primary.Damage = 5
SWEP.Primary.Delay = 0.7

SWEP.StunDamage = 5

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

local SwingSound = Sound( "WeaponFrag.Throw" );
local HitSound = Sound( "Flesh.ImpactHard" );

hook.Add("canDropWeapon", "NoDropPoliceBaton",function(ply, ent)
	if ent:GetClass() == "police_stunstick" then
		return false;
	end
end)

/* 
---------------------------------------------------------------------------------------------------------------------------------------------
				Some functions
---------------------------------------------------------------------------------------------------------------------------------------------
*/

SWEP.menuButtons = {};
SWEP.menuButtons[1] = {}
SWEP.menuButtons[1].buttonText = "Освободить";
SWEP.menuButtons[1].left = true;
SWEP.menuButtons[1].func = function(owner,ent)
	if owner:GetPos():Distance(ent:GetPos()) > 250 then return end;
--	if not ent.stunnedBaton then return end;
	if not ent:IsArrested() then rp.Notify(owner, NOTIFY_ERROR, "Этот игрок не арестован!", ent) return end;
	ent:UnArrest(owner);
end


SWEP.menuButtons[2] = {}
SWEP.menuButtons[2].buttonText = "Арестовать";
SWEP.menuButtons[2].left = false;
SWEP.menuButtons[2].func = function(owner,ent)
	if owner:GetPos():Distance(ent:GetPos()) > 250 then return end;

	if !ent:IsArrested() then
		if ent:GetWantedReason() == "Перевоспитание" then
			owner:Notify(1, "Вы должны именно избить вашу цель!")
			return
		end
		if ent:GetWantedReason() == "Ампутация" then
			owner:Notify(1, "Вы должны расстрелять вашу цель!")
			return
		end
	end
	
	if not ent.stunnedBaton then owner:Notify(1, "Избейте вашу цель!") return end;
	if ent:IsArrested() then ent:Arrest(owner) return end;
	if ent:IsCP() then return end

	if not ent:IsWanted() then return rp.Notify(owner, NOTIFY_ERROR, rp.Term('PlayerNotWanted'), ent:Nick()) end
	
	ent:Arrest(owner)

	rp.Notify(ent, NOTIFY_ERROR, rp.Term('ArrestBatonArrested'), owner)
	owner:AddKarma(2)
	rp.Notify(owner, NOTIFY_GREEN, rp.Term('ArrestBatonYouArrested'), ent)
end


SWEP.menuButtons[3] = {}
SWEP.menuButtons[3].buttonText = "Розыск";
SWEP.menuButtons[3].left = true;
SWEP.menuButtons[3].func = function(owner,ent) end
SWEP.menuButtons[3].subcategories = {}
for k, v in pairs({'Ампутация', 'Перевоспитание', 'Карцер'}) do
	local isleft = true
	if k == 2 then
		isleft = false
	end
	SWEP.menuButtons[3].subcategories[k] = {
		buttonText = v,
		left = isleft,
		issubcategory = true
	}
end

SWEP.menuButtons[4] = {}
SWEP.menuButtons[4].buttonText = "Снять розыск";
SWEP.menuButtons[4].left = true;
SWEP.menuButtons[4].func = function(owner,ent)
	if owner:GetPos():Distance(ent:GetPos()) > 250 then return end;
	if ent:IsWanted() then
		ent:UnWanted()
		rp.Notify(owner, NOTIFY_GREEN, "Вы сняли розыск с игрока!")
	end
end

if SERVER then

	SWEP.replaceModels["models/rrp/metropolice/pm/rctmetropolicepm.mdl"] = "models/rrp/metropolice/rctmetropolice.mdl"
	SWEP.replaceModels["models/rrp/metropolice/pm/umetropolicepm.mdl"] = "models/rrp/metropolice/umetropolice.mdl"
	SWEP.replaceModels["models/rrp/metropolice/pm/ofcmetropolicepm.mdl"] = "models/rrp/metropolice/ofcmetropolice.mdl"
	SWEP.replaceModels["models/rrp/metropolice/pm/zdvlmetropolicepm.mdl"] = "models/rrp/metropolice/zdvlmetropolice.mdl"
	SWEP.replaceModels["models/rrp/metropolice/pm/secmetropolicepm.mdl"] = "models/rrp/metropolice/secmetropolice.mdl"
	SWEP.replaceModels["models/rrp/metropolice/pm/hmetropolicepm.mdl"] = "models/rrp/metropolice/hmetropolice.mdl"
	SWEP.replaceModels["models/rrp/metropolice/pm/hofcmetropolicepm.mdl"] = "models/rrp/metropolice/hofcmetropolice.mdl"
	SWEP.replaceModels["models/rrp/metropolice/pm/jepumetropolicepm.mdl"] = "models/rrp/metropolice/jepumetropolice.mdl"


	function SWEP:Deploy()
		if self.replaceModels[self.Owner:GetModel()] then
			self.PrevModel = self.Owner:GetModel()
			self.Owner:SetModel(self.replaceModels[self.Owner:GetModel()])
		--elseif !self.replaceModels[self.PrevModel] then
			--self.Owner:StripWeapon(self:GetClass())
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

function SWEP:Stun(ply)
	if !self:GetActivated() then return end
	local ang = ply:GetAngles();
	ply:SetEyeAngles(Angle(60,ang.y,ang.r));
	ply:Freeze(true);
	ply.stunnedBaton = true;
	ply:SetNWInt('batonstuntime',CurTime());
	net.Start("batonstunanim") net.WriteEntity(ply) net.WriteBool(true) net.Broadcast();
	timer.Create("unstunbatonstun"..tostring(ply:EntIndex()),self.stunTime,1,function()
		if IsValid(ply) then 
			ply:Freeze(false);
			ply.stunnedBaton = false;
			net.Start("batonstunanim") net.WriteEntity(ply) net.WriteBool(false) net.Broadcast();
		end
	end)
end

function SWEP:AttackPlayer(ply)
	if not IsValid(ply) then return end;
	ply:SetVelocity((ply:GetPos() - self:GetOwner():GetPos()) * 2);
	if ply.stunnedBaton == true then return end;
	local hits = ply.hitByBaton or 0;
	local lTime = ply.lastBatonHit or CurTime();
	if CurTime() > lTime + 3 then 
		hits = 0; 
	end
	local numb = 1;
	if ply:IsArrested() then numb = 1000 end;
	ply.hitByBaton = hits + numb;
	ply.lastBatonHit = CurTime();
	if hits + numb >= self.hitRequireForStun then
		self:Stun(ply);
	end
end

function SWEP:MakeHit()
	self:GetOwner():SetAnimation(PLAYER_ATTACK1);
    if CLIENT then return end;
    self.Owner:EmitSound("weapons/stunstick/stunstick_impact"..math.random(1, 2)..".wav")
    local trace = util.QuickTrace(self:GetOwner():EyePos(), self:GetOwner():GetAimVector() * 90, {self:GetOwner()});
    if IsValid(trace.Entity) and trace.Entity:GetClass() == "func_breakable_surf" then
        trace.Entity:Fire("Shatter"); 
        return;
    end

	local ent = trace.Entity
    if not IsValid(ent) then return end;
    if not ent:IsPlayer() or not ent:Alive() then return end;
    if ent.stunStacks == nil or ent.stunStacks >= 5 then ent.stunStacks = 0 end

	if ent:GetWantedReason() == "Перевоспитание" then
		ent.stunStacks = ent.stunStacks + 1
		if ent.stunStacks >= 5 then
			ent.stunStacks = 0
			ent:UnWanted()
			self.Owner:Notify(1, "Этот человек перевоспитан!")
		else
			self.Owner:Notify(1, "Будет перевоспитан через "..(5-ent.stunStacks).." удар(а)")
		end
	else
		ent.stunStacks = 0
	end
	self:AttackPlayer(ent);
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
				sequence = "activatebaton"
				self.Owner:EmitSound("weapons/stunstick/spark3.wav", 100, math.random(90, 110))
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

	self:SendWeaponAnim(ACT_VM_HITCENTER)

	self.Owner:SetAnimation(PLAYER_ATTACK1)
	self.Owner:ViewPunch(Angle(1, 0, 0.125))

	if self:GetActivated() then
		self:MakeHit()
	end

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

		self.Owner:EmitSound(Sound("Flesh.ImpactHard"));

		local entity = trace.Entity

		local damage = self.Primary.Damage
		if (IsValid(entity)) then
			if (entity:IsPlayer()) then
				if self:GetActivated() then
					-- entity:AddHigh('Stunstick')
					-- damage = self.StunDamage
					-- if (entity.stunStacks || 0) > 4 then
					-- 	if entity:IsWanted() && entity:GetWantedReason() != "Перевоспитание" then
					-- 		entity:Arrest(self.Owner)
					-- 	elseif entity:IsWanted() && entity:GetWantedReason() == "Перевоспитание" then
					-- 		entity:UnWanted()
					-- 	else
					-- 		rp.Notify(self.Owner, NOTIFY_ERROR, rp.Term('PlayerNotWanted'))
					-- 	end
					-- end
				end
				entity:ViewPunch(Angle(-20, math.random(-15, 15), math.random(-10, 10)))
			elseif entity.SeizeReward and entity.WantReason and entity.WantReason then
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
	self:SetNextSecondaryFire(CurTime() + 1.5)
	self:SetNextPrimaryFire(CurTime() + 1.5)
	
	if self:GetActivated() then
		self:MakeHit();
	end

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
			local direction = self.Owner:GetAimVector() * (400 * ((entity.stunStacks && entity.stunStacks * 0.8) || 1))
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

if SERVER then
	util.AddNetworkString("batonstunanim");
	util.AddNetworkString("batonsendfunc");
	-- util.AddNetworkString("batonwantedfunc");
	-- net.Receive("batonwantedfunc",function(leng,ply)
	-- 	local reason = net.ReadInt(4);
	-- 	local enemy = net.ReadEntity();
	-- 	if not IsValid(enemy) or not enemy:IsPlayer() or not enemy:Alive() then return end;
	-- 	if ply:GetActiveWeapon():GetClass() != "police_stunstick" then return end;
	-- 	net.Start('wanted_radio')
	-- 		net.WriteEntity(enemy)
	-- 		net.WriteInt(reason, 4)
	-- 	net.SendToServer()
	-- end)

	net.Receive("batonsendfunc",function(len,ply)
		local enemy = net.ReadEntity();
		local id = net.ReadInt(4);

		if not IsValid(enemy) or not enemy:Alive() then return end;
		if ply:GetActiveWeapon():GetClass() != "police_stunstick" then return end;
		ply:GetActiveWeapon().menuButtons[id].func(ply,enemy);
	end)

	hook.Add("PlayerDeath","WantedReasonPlayer",function(victim, inflictor, attacker )
		if victim:GetWantedReason() == "Ампутация" then
			victim:Arrest()
		end
	end)
end

if CLIENT then
	net.Receive("batonstunanim",function()
		local ply = net.ReadEntity();
		local enable = net.ReadBool();
		if IsValid(ply) and ply:IsPlayer() and ply:Alive() then
			if enable then
				ply:AnimRestartGesture( GESTURE_SLOT_CUSTOM,ACT_HL2MP_IDLE_SLAM, false);   
			else
				ply:AnimResetGestureSlot(GESTURE_SLOT_CUSTOM );
			end
		end	
	end)	
end