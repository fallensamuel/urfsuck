-- "gamemodes\\darkrp\\entities\\weapons\\weapon_radiation_controller.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
SWEP.PrintName			= "Контроллер"
SWEP.Author				= "urf.im"
SWEP.Instructions		= ""
SWEP.Spawnable = true
SWEP.AdminOnly = true

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "none"
SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false
SWEP.DrawAmmo			= false
SWEP.DrawCrosshair		= true
SWEP.Slot			= 1
SWEP.SlotPos		= 2

SWEP.IsControllerWeapon = true

SWEP.ViewModel			= ""--"models/weapons/v_pistol.mdl"
SWEP.WorldModel			= ""--"models/weapons/w_pistol.mdl"

SWEP.AttackCFG = {
	Cooldown = 2.5,
	Damage = {35, 50}, -- случайный урон
	HitDistance = 200,
	RadiationPrecent = {.9, 1}, -- случайное количество радиации (процент от нанесённого урона)
	EffectTime = {8, 12} -- время действия эффекта
}

function SWEP:PrimaryAttack()
	self:DoAttack()
end

function SWEP:SecondaryAttack()
	self:DoAttack()
end

SWEP.AnimationDuration = 2

function SWEP:Initialize()
	self:SetHoldType('normal')
end

function SWEP:DoAttack()
	local CT = CurTime()
	if (self.NextAttack or 0) > CT then return end

	local owner = self:GetOwner()
	if not IsValid(owner) then return end
	if SERVER and owner.InSafeZone and owner:InSafeZone() or CLIENT and LocalPlayerInsideGreenZone() then return end
	if SERVER and (owner.DeathAction or IsValid(owner.HealPlayer)) then return end
	
	self.NextAttack = CT + self.AttackCFG.Cooldown
	
	if SERVER then
		if rp.BaseFoodSwepArmAnim then 
			rp.BaseFoodSwepArmAnim(self, true)
		end
		
		owner:EmitSound("stalker/kontroler/crikcontrolerer.mp3")
		owner:forceSequence('idle_magic', nil, 1, false)
	end
	
	owner:LagCompensation(true)
		local tr = util.TraceLine({
			start = owner:GetShootPos(),
			endpos = owner:GetShootPos() + owner:GetAimVector() * self.AttackCFG.HitDistance,
			filter = owner,
			mask = MASK_SHOT_HULL
		})
		if not IsValid(tr.Entity) then
			tr = util.TraceHull({
				start = owner:GetShootPos(),
				endpos = owner:GetShootPos() + owner:GetAimVector() * self.AttackCFG.HitDistance,
				filter = owner,
				mins = Vector(-25, -25, -15),
				maxs = Vector(25, 25, 15),
				mask = MASK_SHOT_HULL
			})
		end
	owner:LagCompensation(false)

	local dmg = math.random(self.AttackCFG.Damage[1], self.AttackCFG.Damage[2])
	self:FireBullets({
		Damage = dmg,
		Distance = self.AttackCFG.HitDistance * 2, 
		Force = 100,
		HullSize = 1,
		Tracer = 0,
		Num = 1,
		Dir = owner:GetAimVector(), 
		Spread = Vector(0, 0), 
		Src = tr.StartPos,
		IgnoreEntity = owner,
		Callback = function(attacker, struct, dmginfo)
			if IsValid(self) and SERVER then
				self.RadiationDMG = dmg * math.random(self.AttackCFG.RadiationPrecent[1], self.AttackCFG.RadiationPrecent[2])
				
				--self.OnRadiationDamage = function(victim)
					local victim = struct.Entity
					
					if IsValid(victim) then
						if victim.GetRadiation and (victim:GetRadiation() + self.RadiationDMG >= 95 and not victim:IsRadiationZombie() and not victim:HasRadiationImunnity()) then
							timer.Simple(0.2, function()
								if not IsValid(victim) then return end
								victim:InfectHuman()
							end)
						end
						
						victim:SetNWFloat("radiationAffect", CurTime() + math.random(self.AttackCFG.EffectTime[1], self.AttackCFG.EffectTime[2]))
						net.Start("RariationAffectSound")
						net.Send(victim)
					end
				--end
			end
		end
	})
end

if SERVER then
	util.AddNetworkString("RariationAffectSound")
else
	net.Receive("RariationAffectSound", function()
		LocalPlayer():EmitSound("stalker/kontroler/golosvgolovecontrol.mp3")
	end)

	function SWEP:DrawWorldModel() end

	--local render_SetBlend = render.SetBlend
	--function SWEP:PreDrawViewModel()
	--	render_SetBlend(0)
	--end
	
	function SWEP:Deploy()
		self.NextAttack = CurTime() + self.AttackCFG.Cooldown
	end

	local RED = Color(255, 40, 40)
	local READY = Color(255, 210, 210)
	local x, y, cTime, value
	
	function SWEP:DrawHUD()
		x, y = ScrW() / 2 - 60, ScrH() / 2 + 40
		
		cTime = CurTime()
		
		if (self.NextAttack or 0) > cTime then
			value = (self.NextAttack - cTime) / self.AttackCFG.Cooldown * 120
			draw.RoundedBoxEx(4, x + value, y, 120 - value, 14, READY, false, true, false, true)
			draw.RoundedBoxEx(4, x, y, value, 14, RED, true, false, true, false)
		end
	end

	hook.Add("RenderScreenspaceEffects", "RadiationAfftect.Draw", function()
		local pl = LocalPlayer()
		if pl:GetNWFloat("radiationAffect", 0) >= CurTime() then 

			pl.cdw2 = -1;
			
			local tab = {};
			tab[ "$pp_colour_addr" ] = 0;
			tab[ "$pp_colour_addg" ] = 0;
			tab[ "$pp_colour_addb" ] = 0;
			tab[ "$pp_colour_brightness" ] = 0;
			tab[ "$pp_colour_contrast" ] = 1;
			tab[ "$pp_colour_mulr" ] = 0;
			tab[ "$pp_colour_mulg" ] = 0;
			tab[ "$pp_colour_mulb" ] = 0;
				
			if (!pl.cdw or pl.cdw < CurTime()) then
				pl.cdw = CurTime() + 1;
				pl.cdw2 = pl.cdw2*-1;
			end
			
			if (pl.cdw2 == -1) then
				pl.cdw3 = 2;
			else
				pl.cdw3 = 0;
			end
			
			local ich = (pl.cdw2*((pl.cdw - CurTime())*(2)))+pl.cdw3 - 1;
			
			--DrawMaterialOverlay("highs/shader3", 1*ich*0.05);
			--DrawSharpen(1*ich*5, 2) ;

		-- borrow this from shrooms and call it meth
			local shroom_tab = {};
			shroom_tab[ "$pp_colour_addr" ] = 0;
			shroom_tab[ "$pp_colour_addg" ] = 0;
			shroom_tab[ "$pp_colour_addb" ] = 0;
			shroom_tab[ "$pp_colour_mulr" ] = 0;
			shroom_tab[ "$pp_colour_mulg" ] = 0;
			shroom_tab[ "$pp_colour_mulb" ] = 0;
			
			shroom_tab[ "$pp_colour_colour" ] = 0.63;
			shroom_tab[ "$pp_colour_brightness" ] = -0.15;
			shroom_tab[ "$pp_colour_contrast" ] = 2.57;
			--DrawMotionBlur( 0.82, 1, 0);
			DrawColorModify(shroom_tab);
			--DrawSharpen(8.32, 1.03);
			
			
			DrawSharpen(-1 * ich, 2)
			DrawMaterialOverlay('models/props_lab/Tank_Glass001', 0)
			DrawMotionBlur(0.13, 1, 0.00)
		end
	end)
end