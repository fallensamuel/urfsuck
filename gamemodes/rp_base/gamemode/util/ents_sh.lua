function PLAYER:IsCooldownAction(uid, delay)
	local CT = CurTime()
	if (self["CD_"..uid] or 0) > CT then return true end
	self["CD_"..uid] = CT + (delay or 1)
end

function PLAYER:GetCooldownActionTIme(uid)
	return self["CD_"..uid] - CurTime()
end

function ENTITY:InBox(p1, p2)
	return self:GetPos():WithinAABox(p1, p2)
end

local s = rp.cfg.Spawns[game.GetMap()]
function ENTITY:InSpawn()
	if not s or #s == 0 then return false end
	if self.IsInSpawn and (self.IsInSpawn >= CurTime()) then return true end
	return self:InBox(s[1], s[2])
end

local wep_classes = {
	weapon_crowbar 		= true,
	weapon_stunstick 	= true,
	weapon_c4 			= true
}
function ENTITY:IsIllegalWeapon()
	return wep_classes[self:GetClass()] and wep_classes[self:GetClass()] or (string.sub(self:GetClass(), 0, 3) == 'swb')
end

-- Sight checks
if (SERVER) then return end

-- I try too hard
local LocalPlayer 			= LocalPlayer
local GetPos 				= ENTITY.GetPos
local EyePos 				= ENTITY.EyePos
local DistToSqr 			= VECTOR.DistToSqr
local GetNormalized         = VECTOR.GetNormalized
local Dot                   = VECTOR.Dot
local IsLineOfSightClear 	= ENTITY.IsLineOfSightClear
local util_TraceLine 		= util.TraceLine


local lp
local trace = {
	mask 	= -1,
	filter 	= {},
}

function ENTITY:InSight() return false end
function PLAYER:InSight() return false end

function ENTITY:InTrace() return false end
function PLAYER:InTrace() return false end

function ENTITY:ScreenVisible() return false end
function PLAYER:ScreenVisible() return false end

hook('Think', 'VisChecks', function()
	if IsValid(LocalPlayer()) then
		lp = LocalPlayer()
		trace.filter[1] = LocalPlayer()

		function ENTITY:InSight()
			if not self:ScreenVisible() then return false end

			if DistToSqr(GetPos(self), GetPos(lp)) < 250000 then
				return IsLineOfSightClear(lp, self)
			end

			return false
		end

		function PLAYER:InSight()
			if self.ShouldNoDraw then return false end

			if DistToSqr(EyePos(self), EyePos(lp)) < 250000 then
				return IsLineOfSightClear(lp, self)
			end

			return false
		end

		function ENTITY:InTrace()
			trace.start 	= EyePos(lp)
			trace.endpos 	= GetPos(self)
			trace.filter[2] = self

			return not util_TraceLine(trace).Hit
		end

		function PLAYER:InTrace()
			trace.start 	= EyePos(lp)
			trace.endpos 	= EyePos(self)
			trace.filter[2] = self

			return not util_TraceLine(trace).Hit
		end

		function ENTITY:ScreenVisible()
			local pos     = GetPos(self);
			local sqrdist = DistToSqr( pos, EyePos(lp) );

			return (sqrdist < 16384) or (sqrdist < GetRenderDistance()) and Dot(EyeVector(), GetNormalized(pos - EyePos(lp))) > 0.3;
		end

		function PLAYER:ScreenVisible()
			return !self.ShouldNoDraw;
		end

		hook.Remove('Think', 'VisChecks')
	end
end)