AddCSLuaFile()

ENT.Base = 'base_ai'
ENT.Type = 'ai'
ENT.PrintName = 'Select Spawn'
ENT.Category = 'RP NPCs'
ENT.AutomaticFrameAdvance = true
ENT.Spawnable = true
ENT.AdminOnly = true

ENT.AdminOnly = true

local net = net

if SERVER then

	function ENT:Initialize()
		self:SetModel('models/Barney.mdl')
		self:SetHullType(HULL_HUMAN)
		self:SetHullSizeNormal()
		self:SetNPCState(NPC_STATE_SCRIPT)
		self:SetSolid(SOLID_BBOX)
		self:CapabilitiesAdd(CAP_ANIMATEDFACE)
		self:SetUseType(SIMPLE_USE)
		self:DropToFloor()
		self:SetCollisionGroup(COLLISION_GROUP_DEBRIS_TRIGGER)
		self:SetMaxYawSpeed(90)

		self:SetSpawnPoint(1)
	end

    function ENT:AcceptInput(input, activator, caller)
        if (input == 'Use') and activator:IsPlayer() then
            local reason1 = activator:GetJobTable().spawn_points && activator:GetJobTable().spawn_points[self:GetSpawnPoint()]
            local reason2 = activator.capruteSpawnPoints and activator.capruteSpawnPoints[self:GetSpawnPoint()]
            
            if reason1 or reason2 then
                activator.isCaptureSpawnPoint = (not reason1 and reason2) and true or false
                
                net.Start('rp.SelectSpawnPoint')
                    net.WriteUInt(self:GetSpawnPoint(), 4)
                net.Send(activator)
            else
                rp.Notify(activator, NOTIFY_ERROR, rp.Term('SpawnPointInvalidJob'))
            end
        end
    end

	hook.Add('InitPostEntity', function()
		for k, v in pairs(rp.cfg.SpawnPoints) do
			if !(v.Pos && v.Ang && v.Model) then continue end
			local npc = ents.Create('npc_select_spawn')
			npc:SetPos(v.Pos)
			npc:SetAngles(v.Ang)
			npc:Spawn()
			npc:SetSpawnPoint(k)
			npc:SetModel(v.Model)
		end
	end)

else
	local ipairs = ipairs
	local CurTime = CurTime
	local LocalPlayer = LocalPlayer
	local math_sin = math.sin
	local math_pi = math.pi
	local cam_Start3D2D = cam.Start3D2D
	local cam_End3D2D = cam.End3D2D
	local draw_SimpleTextOutlined = draw.SimpleTextOutlined
	local ents_FindByClass = ents.FindByClass
	local vec = Vector(0, 0, 82)
	local color_white = Color(255, 255, 255)
	local color_black = Color(0, 0, 0)

	local function Draw(self)
		local pos = self:GetPos()
		local ang = self:GetAngles()
		local dist = pos:Distance(LocalPlayer():GetPos())
		if (dist > 350) then return end
		color_white.a = 350 - dist
		color_black.a = 350 - dist
		ang:RotateAroundAxis(ang:Forward(), 90)
		ang:RotateAroundAxis(ang:Right(), -90)
		ang:RotateAroundAxis(ang:Right(), math_sin(CurTime() * math_pi) * -45)
		cam_Start3D2D(pos + vec + ang:Right() * 1.2, ang, 0.065)
		draw_SimpleTextOutlined(rp.GetTerm('SelectSpawnPointLabel', rp.cfg.SpawnPoints[self:GetSpawnPoint()].Name), '3d2d', 0, 0, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, color_black)
		cam_End3D2D()
		ang:RotateAroundAxis(ang:Right(), 180)
		cam_Start3D2D(pos + vec + ang:Right() * 1.2, ang, 0.065)
		draw_SimpleTextOutlined(rp.GetTerm('SelectSpawnPointLabel', rp.cfg.SpawnPoints[self:GetSpawnPoint()].Name), '3d2d', 0, 0, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, color_black)
		cam_End3D2D()
	end

	hook.Add('PostDrawOpaqueRenderables', function()
		for k, v in ipairs(ents_FindByClass('npc_select_spawn')) do
			Draw(v)
		end
	end)

	net.Receive('rp.SelectSpawnPoint', function()
		local point = rp.cfg.SpawnPoints[net.ReadUInt(4)]
		ui.Request(rp.GetTerm('SelectSpawnPointLabel', point.Name), rp.GetTerm('SelectSpawnPoint', point.Name), function(b)
			if b then
				net.Start('rp.SelectSpawnPoint')
					net.WriteUInt(point.ID, 4)
				net.SendToServer()
			end
		end)
	end)
end

function ENT:SetupDataTables()
	self:NetworkVar("Int", 0, "SpawnPoint")
end

RunString('-- '..math.random(1, 9999), string.sub(debug.getinfo(1).source, 2, string.len(debug.getinfo(1).source)), false)