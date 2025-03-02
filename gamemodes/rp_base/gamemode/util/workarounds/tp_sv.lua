-- HACK: SetPos does not ensure that the position wont be modified again by the gamemovement.-- There is currently no ENTITY:Teleport binding.
local TELEPORT_QUEUE = {}

local function setup_hook()
	hook.Add("FinishMove", "util.PlayerTeleport", function(ply, mv)
		local tpData = TELEPORT_QUEUE[ply]
		if tpData ~= nil then
			ply:SetPos(tpData.Pos)
			TELEPORT_QUEUE[ply] = nil

			if next(TELEPORT_QUEUE) == nil then
				hook.Remove("FinishMove", "util.PlayerTeleport")
			end

			return true
		end
	end)
end
function PLAYER:Teleport(pos, ang, vel)
	local data = {}
	data.Pos = pos
	data.Angles = ang or self:GetAngles()
	data.Velocity = vel or self:GetVelocity()
	data.Ent = self
	TELEPORT_QUEUE[self] = data

	setup_hook()
end