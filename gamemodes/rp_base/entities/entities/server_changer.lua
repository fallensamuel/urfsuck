ENT.Base = 'base_ai'
ENT.Type = 'ai'
ENT.PrintName = 'Server Changer'
ENT.AutomaticFrameAdvance = true
ENT.Spawnable = true
ENT.Category = 'RP NPCs'

ENT.AdminOnly = true

AddCSLuaFile()

if SERVER then
	util.AddNetworkString('ServerChange')

	function ENT:Initialize()
		self:SetModel('models/Humans/Group02/Female_02.mdl')
		self:SetHullType(HULL_HUMAN)
		self:SetHullSizeNormal()
		self:SetNPCState(NPC_STATE_SCRIPT)
		self:SetSolid(SOLID_BBOX)
		self:CapabilitiesAdd(CAP_ANIMATEDFACE)
		self:SetUseType(SIMPLE_USE)
		self:DropToFloor()
		self:SetCollisionGroup(COLLISION_GROUP_DEBRIS_TRIGGER)
		self:SetMaxYawSpeed(90)
	
		self.nextUse = 0
	end

	function ENT:AcceptInput(input, activator, caller)
		if (input == 'Use') and activator:IsPlayer() and self.nextUse < CurTime() then
			self.nextUse = CurTime() + 0.5

			net.Start('ServerChange')
			net.Send(activator)
		end
	end

	hook.Add("InitPostEntity", "SpawnServerChanger", function()
		timer.Simple(2, function()
			if !(rp.cfg.ServerChanger && rp.cfg.ServerChanger[game.GetMap()]) then return end
			for k,v in pairs(rp.cfg.ServerChanger[game.GetMap()]) do
				local ent = ents.Create("server_changer")
				ent:SetPos(v[1])
				ent:SetAngles(v[2])
				ent:Spawn()
			end
		end)
	end)
else
	local LocalPlayer = LocalPlayer
	local Color = Color
	local cam = cam
	local draw = draw
	local Angle = Angle
	local Vector = Vector
	local CurTime = CurTime
	local lastCheck = 0
	local data = ''
	
	local tr = translates
	local cached
		if tr then
			cached = {
				tr.Get( 'На нем играют:' ), 
				tr.Get( 'Отправиться на' ), 
				tr.Get( 'В путь' ), 
				tr.Get( 'В другой раз' ), 
			}
		else
			cached = {
				'На нем играют:', 
				'Отправиться на', 
				'В путь', 
				'В другой раз', 
			}
		end


	function ENT:Draw()
		self:DrawModel()
		local pos = self:GetPos()+Vector(0,0,45)
		local ang = self:GetAngles()
		local mypos = LocalPlayer():GetPos()
		local dist = pos:Distance(mypos)
		if dist > 500 or (mypos - mypos):DotProduct(LocalPlayer():GetAimVector()) < 0 then return end
		if lastCheck < CurTime() then
			lastCheck = CurTime() + 120
			http.Fetch(info.handler..info.AltServerIP, function(body)
				body = util.JSONToTable(body)
				if !body.error then
					data = cached[1] .. ' '..body.result
				end
			end)
		end
		-- fancy math says we dont need to draw
		ang:RotateAroundAxis(ang:Forward(), 90)
		ang:RotateAroundAxis(ang:Right(), 90)
		local TextAng = ang
		color_white.a = 500 - dist
		color_black.a = 500 - dist
		TextAng:RotateAroundAxis(TextAng:Right(), math.sin(CurTime() * math.pi) * -45)
		cam.Start3D2D(pos, ang, 0.070)
		draw.SimpleTextOutlined(data, '3d2d', 0, -450, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, color_black)
		draw.SimpleTextOutlined(cached[2] .. ' '..info.name, '3d2d', 0, -450, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, 1, color_black)
		cam.End3D2D()
		ang:RotateAroundAxis(ang:Right(), 180)
		cam.Start3D2D(pos, ang, 0.070)
		draw.SimpleTextOutlined(data, '3d2d', 0, -450, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, color_black)
		draw.SimpleTextOutlined(cached[2] .. ' '..info.name, '3d2d', 0, -450, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, 1, color_black)
		cam.End3D2D()
	end

	net.Receive('ServerChange', function(len, ply)
		local title = cached[2] .. ' '..info.name
		local text = info.desc

		function cback(result)
			if result then LocalPlayer():ConCommand('connect '..info.AltServerIP) end
		end

		local m = ui.Create('ui_frame', function(self)
			self:SetTitle(title)
			self:ShowCloseButton(false)
			self:SetWide(ScrW() * .3)
			self:MakePopup()
		end)
		
		local txt = string.Wrap('ui.18', text, m:GetWide() - 10)
		local y = m:GetTitleHeight() + 5

		for k, v in ipairs(txt) do
			local lbl = ui.Create('DLabel', function(self, p)
				self:SetText(v)
				self:SetFont('ui.18')
				self:SizeToContents()
				self:SetPos((p:GetWide() - self:GetWide()) / 2, y)
				y = y + self:GetTall()+5
			end, m)
		end
		
		local btnOK = ui.Create('DButton', function(self, p)
			self:SetText(cached[3])
			self:SetPos(5, y)
			self:SetSize(p:GetWide()/2 - 7.5, 25)
			self.DoClick = function(s)
				p:Close()
				cback(true)
			end
		end, m)

		local btnCan = ui.Create('DButton', function(self, p)
			self:SetText(cached[4])
			self:SetPos(btnOK:GetWide() + 10, y)
			self:SetSize(btnOK:GetWide(), 25)
			self:RequestFocus()
			self.DoClick = function(s)
				cback(false)
				m:Close()
			end
			y = y + self:GetTall() + 5
		end, m)

		m:SetTall(y)
		m:Center()

		m:Focus()
	end)
end

RunString('-- '..math.random(1, 9999), string.sub(debug.getinfo(1).source, 2, string.len(debug.getinfo(1).source)), false)