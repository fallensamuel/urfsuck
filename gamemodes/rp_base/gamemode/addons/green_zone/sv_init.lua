
local inside = {}

local player_GetAll = player.GetAll

local zones = rp.cfg.GreenZones[game.GetMap()]

function PLAYER:InSafeZone()
	return inside[self]
end

if !zones then return end

local players, ply, pos, find
local x1, x2, y1, y2, ply_x, ply_y
timer.Create('GreenZone', 2, 0, function()
	inside = {}
	players = player_GetAll()
	for i=1, #players do
		ply = players[i]

		pos = ply:GetPos()
		ply_x = pos.x
		ply_y = pos.y


		for i=1, #zones do
			x1, y1 = zones[i][1].x, zones[i][1].y
			x2, y2 = zones[i][2].x, zones[i][2].y
			if x1 < ply_x && x2 > ply_x && y1 < ply_y && y2 > ply_y then
				inside[ply] = true
				break
			end
		end
	end
end)


hook.Add("PlayerShouldTakeDamage", function(ply, attacker)
	if inside[ply] || inside[attacker] then return false end
end)