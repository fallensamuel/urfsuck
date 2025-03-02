-- "gamemodes\\darkrp\\gamemode\\addons\\airdrop\\cl_init.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
rp.AirDropEnts = {}

hook.Add("HUDPaint","AirDropTimeOpen",function()
	local dontDrawDouble = {}
	for k,v in pairs(rp.AirDropEnts) do
		local ent = Entity(v.entIndex)
		if not IsValid(ent) then continue end
		if dontDrawDouble[ent] then continue end
		dontDrawDouble[ent] = true
		if ent:GetPos():Distance(LocalPlayer():GetPos()) > 500 or not ent:GetNWBool("IsAirDrop") then continue end
		local pos = (ent:GetPos()+Vector(0,0,80)):ToScreen()
		if ent:GetNWBool("IsCanOpen") then
			draw.SimpleText("Открыто!","PlayerInfo",pos.x, pos.y,Color(255,255,255),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
		else
			local timeOpen = math.ceil(v.timeCanOpen - CurTime())
			draw.SimpleText("До распаковки: "..timeOpen.." сек.","PlayerInfo",pos.x, pos.y,Color(255,255,255),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
		end
	end
end)

local function Circle(x, y, radius, seg)
	local cir = {}

	table.insert(cir, {x = x, y = y, u = 0.5, v = 0.5})
	for i = 0, seg do
		local a = math.rad((i / seg)*-360)
		table.insert(cir, {x = x + math.sin( a ) * radius, y = y + math.cos( a ) * radius, u = math.sin( a ) / 2 + 0.5, v = math.cos( a ) / 2 + 0.5})
	end

	local a = math.rad(0)
	table.insert(cir, {x = x + math.sin( a ) * radius, y = y + math.cos( a ) * radius, u = math.sin( a ) / 2 + 0.5, v = math.cos( a ) / 2 + 0.5})

	surface.DrawPoly(cir)
end

hook.Add("PostDrawOpaqueRenderables", "AirDropColorZone", function()
	for k,v in pairs(rp.AirDropEnts) do
		local ent = Entity(v.entIndex)
		if not IsValid(ent) then continue end
		if ent:GetPos():Distance(LocalPlayer():GetPos()) > 1500 or not ent:GetNWBool("IsAirDrop") then continue end
		cam.Start3D2D(v.pos+Vector(0,0,1), Angle(0,0,0), 1)
			surface.SetDrawColor(255, 0, 0, 100)
			draw.NoTexture()
			Circle(0, 0, 200 + math.sin(CurTime()) * 50, 100)
		cam.End3D2D()
	end
end)

net.Receive("AirDrop",function()
	table.insert(rp.AirDropEnts, {
		entIndex = net.ReadUInt(16),
		timeCanOpen = net.ReadUInt(32),
		pos = net.ReadVector()
	})
end)