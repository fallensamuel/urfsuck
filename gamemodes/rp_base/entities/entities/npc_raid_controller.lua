-- "gamemodes\\rp_base\\entities\\entities\\npc_raid_controller.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
AddCSLuaFile()

ENT.Type 		= "point"
ENT.Base 		= "base_point"
ENT.Spawnable 	= false
ENT.AdminOnly 	= true
ENT.NpcAmount = 0

if SERVER then
	util.AddNetworkString('Raid::MakeNotifyPanel')
else
	local raid_panel
	
	local color_red = Color(255, 180, 0)
	local color_black = Color(0, 0, 0)
	
	function show_panel(name, start_time)
		if IsValid(raid_panel) then raid_panel:Remove() end
		
		raid_panel = vgui.Create("urf.im/rpui/menus/blank")
		local pnl = raid_panel
		pnl:SetSize(350, 100)
		pnl:SetPos(ScrW() - pnl:GetWide(), 0)
		pnl.header.btn:SetVisible(false)

		pnl.header:SetIcon("rpui/misc/alarm.png")
		pnl.header:SetTitle("Событие-рейд")
		pnl.header:SetFont("rpui.playerselect.title")
		pnl.header.IcoSizeMult = 1.35
		pnl.header.FlashCol = color_black

		local reconnect_text = "'" .. name .. "'"
		local reconnect_text2 = 'начнётся через '
		local sec = ' сек'

		local white = Color(255, 255, 255)
		pnl.PaintOver = function(me, w, h)
			if start_time - CurTime() < 0 then
				pnl:Close()
			end
			
			local delta = math.Clamp(start_time - CurTime(), 1, 60)

			local headerH = me.header:GetTall()
			local y = h - headerH
			y = h - y*0.5
			
			draw.SimpleText(reconnect_text, "RestartNotify", w*0.5, y, white, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
			draw.SimpleText(reconnect_text2 .. math.ceil(delta) .. sec, "RestartNotify", w*0.5, y, white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)

			me.header.FlashCol = ((delta % 1 < 0.2) and color_red or color_black)
		end

		function pnl.header:Paint(w, h)
			surface.SetDrawColor(self.Colors.Background)
			surface.DrawRect(0, 0, w, h)

			if self.prev_btn.IsVisible(self.prev_btn) then
				if self.PreviousTitle then
					local pos_x = self.prev_btn.GetPos(self.prev_btn)
					draw.SimpleText(self.PreviousTitle, self.Font or "DermaDefault", pos_x + self.prev_btn.GetWide(self.prev_btn) + h/3, (h*0.5) + (self.TitleYOffset or 0), self.Colors.Inside, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
				end
				return
			end

			if self.NoDrawInfo then return end

			-- Icon
			surface.SetDrawColor(self.FlashCol)
			surface.SetMaterial(self.Icon)
			local h_3 = h/3 * (self.IcoSizeMult or 1)
			local offset_ = (h - h_3)*0.5
			surface.DrawTexturedRect(offset_ + 10, offset_ + 1, h_3, h_3)
			-- Title
			draw.SimpleText(utf8.upper(self.Title), self.Font or "DermaDefault", h_3 + 10 + h/3 + h/6, (h*0.5) + (self.TitleYOffset or 0) + 1, self.FlashCol, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		end
	end
	
	net.Receive('Raid::MakeNotifyPanel', function()
		show_panel(net.ReadString(), net.ReadFloat())
	end)
end

local function make_notify_panel(raid)
	net.Start('Raid::MakeNotifyPanel')
		net.WriteString(raid.name)
		net.WriteFloat(CurTime() + 60) --raid.notify_before_raid_time)
	net.Broadcast()
end

local raid_ent
local function start_raid(id)
	if not rp.cfg.Raids[id] then return print('RaidController::Error', 'Raid with id ' .. id .. ' doesn\'t exist!') end
	if raid_ent.CurrentRaid then return print('RaidController::Error', 'Raid Already Started!') end
	
	raid_ent.NextRaid = rp.cfg.Raids[id]
	make_notify_panel(rp.cfg.Raids[id])
	
	timer.Simple(1, function()
		raid_ent:StartRaid(rp.cfg.Raids[id], true)
	end)
end

local function end_raid()
	if not raid_ent.CurrentRaid then return print('RaidController::Error', 'No raid running!') end
	
	for k, v in pairs(rp.npc.Entities or {}) do
		v:TakeDamage(v:Health() * 10, Entity(0), Entity(0))
	end
end

if SERVER then
	rp.AddCommand('/start_raid', function(ply, _, args)
		if ply:IsRoot() or ply:HasFlag("e") then
			start_raid(tonumber(args[1]))
		end
	end)
	rp.AddCommand('/end_raid', function(ply)
		if ply:IsRoot() or ply:HasFlag("e") then
			end_raid()
		end
	end)
end

function ENT:Initialize()
	if not SERVER then return end
	raid_ent = self
	
	for k, v in pairs(rp.cfg.Raids or {}) do
		timer.Simple(v.first_raid, function()
			if not IsValid(self) then return end
			self:StartRaid(v)
			
			timer.Create('Raid' .. k, v.interval, 0, function()
				if not IsValid(self) then return end
				self:StartRaid(v)
			end)
		end)
		
		--if v.notify_before_raid_time then
			--timer.Simple(math.max(v.first_raid - v.notify_before_raid_time, 1), function()
			timer.Simple(math.max(v.first_raid - 1, 1), function()
				if not IsValid(self) then return end
				if self.NextRaid then return end
				if v.min_players and player.GetCount() < v.min_players then return end
				
				self.NextRaid = v
				
				make_notify_panel(v)
				
				timer.Create('RaidNotify' .. k, v.interval, 0, function()
					if not IsValid(self) then return end
					if self.NextRaid then return end
					if v.min_players and player.GetCount() < v.min_players then return end
					
					self.NextRaid = v
					
					make_notify_panel(v)
				end)
			end)
		--end
	end
end

function ENT:StartRaid(raid, forced)
	if self.CurrentRaid or (self.NpcAmount or 0) > 0 then return print('RaidController::Error', 'Raid Already Started!') end
	if not forced and raid.min_players and player.GetCount() < raid.min_players then return print('RaidController::Error', 'Not enough players!') end
	
	local raid_btn = ents.FindByName(raid.btn_name or 'invalid entity')[1]
	
	if not IsValid(raid_btn) then 
		if raid.raid_types then
			local sum = 0
			
			for k, v in pairs(raid.raid_types) do
				sum = sum + v.chance
			end
			
			local rand = math.random(1, sum)
			
			for k, v in pairs(raid.raid_types) do
				rand = rand - v.chance
				
				if rand <= 0 then
					self.RaidType = k
					break
				end
			end
			
			if not self.RaidType then
				self.RaidType = table.GetKeys(raid.raid_types)[1]
			end
		end
		
		if raid.npc_custom_spawn then
			for k, v in pairs(raid.npc_custom_spawn) do
				timer.Simple(60, function()
					local npc = ents.Create(v.class)
					npc:SetPos(v.pos)
					npc:SetAngles(v.ang)
					npc:Spawn()
					
					timer.Simple(1, function()
						if not IsValid(npc) then return end
						
						self.NpcAmount = (self.NpcAmount or 0) + 1
						
						rp.npc.RegisterEntity(npc, function()
							self:NPCKilled()
						end, self.RaidType)
					end)
				end)
			end
		else
			return print('RaidController::Error', 'Invalid raid button!')
		end
	else
		raid_btn:Fire('Press')
	end
	
	self.NextRaid = nil
	self.CurrentRaid = raid
	self.NpcAmount = 0
	
	timer.Simple(60, function()
		local text = rp.GetTerm('Raid::Start')
		net.Start('ba.TellAll')
			net.WriteString(string.Replace(text, "#", raid.name .. (self.RaidType and raid.raid_types[self.RaidType] and ' (' .. raid.raid_types[self.RaidType].name .. ')' or '')))
		net.Broadcast()
	end)
	
	timer.Simple(80, function()
		if IsValid(self) and self.CurrentRaid and self.NpcAmount == 0 then
			self:NPCKilled()
		end
	end)
end

function ENT:NPCKilled()
	if not self.CurrentRaid then return end
	
	self.NpcAmount = self.NpcAmount - 1
	
	if self.NpcAmount <= 0 then
		local text = rp.GetTerm('Raid::End')
		net.Start('ba.TellAll')
			net.WriteString(string.Replace(text, "#", self.CurrentRaid.name))
		net.Broadcast()
		
		self.CurrentRaid = nil
		self.NpcAmount = nil
	end
end

function ENT:AcceptInput(name, activator, called, data)
	if IsValid(activator) and activator:IsNPC() then
		print("RaidController::NewNPC", activator)
		
		self.NpcAmount = (self.NpcAmount or 0) + 1
		rp.npc.RegisterEntity(activator, function(npc)
			self:NPCKilled()
		end)
	end
end

hook.Add('InitPostEntity', 'RaidController::SpawnController', function()
	if SERVER then
		timer.Simple(0, function()
			if not IsValid(ents.FindByClass('npc_raid_controller')[1]) then
				local nrc = ents.Create('npc_raid_controller')
				nrc:Spawn()
				
				print('RaidController::SpawnController')
			end
		end)
	end
end)