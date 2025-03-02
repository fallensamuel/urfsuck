
local IsValid = IsValid

local inside = false
local x1, x2, y1, y2, ply_x, ply_y
local ply

function LocalPlayerInsideGreenZone()
	return inside
end

local zones = rp.cfg.GreenZones[game.GetMap()]
if !zones then return end

timer.Create('GreenZone', 1, 0, function()
	ply = LocalPlayer()

	if !IsValid(ply) then return end

	pos = ply:GetPos()
	ply_x = pos.x
	ply_y = pos.y


	for i=1, #zones do
		x1, y1 = zones[i][1].x, zones[i][1].y
		x2, y2 = zones[i][2].x, zones[i][2].y
		if x1 < ply_x && x2 > ply_x && y1 < ply_y && y2 > ply_y then
			inside = true
			return
		end
	end

	inside = false
end)

