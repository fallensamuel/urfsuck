-- "gamemodes\\darkrp\\gamemode\\addons\\hud\\cl_menu_map.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal

rp.Map = rp.Map or { NPCIcons = {}, EntIcons = {}, CustomPoints = {} }

local custom_point_icon = Material("stalker/icons/custom_map_mark.png", "alphatest")
local player_pos_icon     = Material("stalker/icons/player_pos_mark.png", "alphatest") 

local unit_center		= Material("stalker/icons/ally_logo.png", "alphatest")

local custom_point_player_time 	= 600
local custom_point_player_color = Color(255, 0, 0)

local custom_icon_colors 		= {
	Color(255, 0, 0), 
	Color(255, 127, 0), 
	Color(255, 255, 0), 
	Color(0, 255, 0), 
	Color(0, 0, 255), 
	Color(75, 0, 130), 
	Color(143, 0, 255)
}

local min_zoom_distance = 4000
local max_zoom_distance = 14000

local unit_size 		= 21
local unit_offset		= -unit_size / 2

local minimap_power 	= rp.cfg.MinimapSettings[game.GetMap()] and rp.cfg.MinimapSettings[game.GetMap()].power or 1
local minimap_offset_x 	= rp.cfg.MinimapSettings[game.GetMap()] and rp.cfg.MinimapSettings[game.GetMap()].off_x or 0
local minimap_offset_y	= rp.cfg.MinimapSettings[game.GetMap()] and rp.cfg.MinimapSettings[game.GetMap()].off_y or 0


local custom_icons_max = #custom_icon_colors

local map_image = Material(rp.cfg.MinimapSettings[game.GetMap()] and rp.cfg.MinimapSettings[game.GetMap()].map or "stalker/minimap.png", "alphatest") 

local current_zoom_dist = (max_zoom_distance + min_zoom_distance) / 2
local current_zoom_real = current_zoom_dist

local minimap_texture_x = map_image:Width()
local minimap_texture_y = map_image:Height()

local minimap_realmap_offset = Vector(minimap_offset_x / minimap_texture_x, minimap_offset_y / minimap_texture_y, 0)

local minimap_texture_multiplier_x, minimap_texture_multiplier_y


local sf_SDC 	= surface.SetDrawColor
local sf_SM 	= surface.SetMaterial
local sf_STR	= surface.DrawTexturedRectUV
local sf_DTR	= surface.DrawTexturedRect


local function customPointRemove(point_id)
	table.insert(custom_icon_colors, rp.Map.CustomPoints[point_id].color)
	rp.Map.CustomPoints[point_id] = nil
end

function getCustomPointByName(name)
	for k, v in pairs(rp.Map.CustomPoints) do 
		if v.name == name then
			return k
		end
	end
end

local function customPointNameDialog(pos)
	
	rpui.StringRequest("НАЗВАНИЕ МЕТКИ", "Введите имя метки:", "shop/filters/list.png", 1.4, function(self, str)
		--RunConsoleCommand("say", "/demote "..plyID.." "..str)
		
		table.insert(rp.Map.CustomPoints, { pos = pos, icon = custom_point_icon, color = table.remove(custom_icon_colors, 1), name = str })
	end)
	
	/*
	local btn
	local fr = ui.Create('ui_frame', function(self)
		self:SetTitle("Название метки")
		self:SetSize(400, 150)
		self:Center()
		self:MakePopup()
	end)
	
	local name = ui.Create('DTextEntry', function(self)
		self:SetSize(360, 30)
		self:SetText("Имя метки")
		self:SetPos(20, 45)
		
		self.OnEnter = function()
			btn.DoClick()
		end
	end, fr)
	
	btn = ui.Create('DButton', function(self)
		self:SetSize(360, 40)
		self:SetText("Поставить метку")
		self:SetPos(20, 90)
		
		self.Paint = function(btn, w, h)
			derma.SkinHook('Paint', 'TabButton', btn, w, h)
		end
		
		self.DoClick = function()
			table.insert(rp.Map.CustomPoints, { pos = pos, icon = custom_point_icon, color = table.remove(custom_icon_colors, 1), name = name:GetValue() })
			fr:Close()
		end
	end, fr)
	
	fr:Focus()
	*/
end

local function openContextPointMenu(point, is_player)
	local m = ui.DermaMenu()
	local show = false
	
	if #player.GetAll() > 1 then
		local send_pos = is_player and LocalPlayer():GetPos() or rp.Map.CustomPoints[point].pos
		
		m:AddOption(is_player and 'Показать свою позицию' or 'Показать игроку', function()
			timer.Simple(0, function()
				local n = ui.DermaMenu()
				
				for _, v in ipairs(player.GetAll()) do
					if v ~= LocalPlayer() then 
						n:AddOption(v:Name(), function()
							
							net.Start('rp.Map.SendCustomPoint')
								net.WriteEntity(v)
								net.WriteVector(send_pos)
							net.SendToServer()
							
						end)
					end
				end
						
				n:Open()
			end)
		end)
		
		if LocalPlayer():GetOrg() then
			m:AddOption('Показать игрокам своей организации', function()
				net.Start('rp.Map.BroadcastCustomPoint')
					net.WriteBool(false)
					net.WriteVector(send_pos)
				net.SendToServer()
			end)
		end
		
		if LocalPlayer():GetFaction() then
			m:AddOption('Показать игрокам своей фракции', function()
				net.Start('rp.Map.BroadcastCustomPoint')
					net.WriteBool(true)
					net.WriteVector(send_pos)
				net.SendToServer()
			end)
		end
		
		show = true
	end
	
	if not is_player then
		m:AddOption('Удалить', function()
			customPointRemove(point)
		end)
		
		show = true
	end
		
	if show then
		m:Open()
	else
		m:Remove()
	end
end


local PANEL = {}

function PANEL:GetCursorCustomPoint(pos)
	local dist = (unit_size / 2) * current_zoom_real / (self.map_w / 2)
	dist = dist * dist
	
	for k, v in pairs(rp.Map.CustomPoints) do 
		if v.pos:DistToSqr(pos) <= dist then
			return k
		end
	end
end

function PANEL:WorldToMap(pos)
	local r_x = (pos.x - self.map_current_pos.x) / current_zoom_real * self.map_w / 2
	local r_y = (pos.y - self.map_current_pos.y) / current_zoom_real * self.map_h / 2
	
	return Vector(self.map_w / 2 + r_x, self.map_h / 2 - r_y)
end

function PANEL:MapToWorld(pos)
	pos = Vector(pos.x - self.map_w / 2, self.map_h / 2 - pos.y)
	
	local r_x = pos.x * 2 * current_zoom_real / self.map_w + self.map_current_pos.x
	local r_y = pos.y * 2 * current_zoom_real / self.map_h + self.map_current_pos.y
	
	return Vector(r_x, r_y)
end

local AirdropIcon = Material('stalker/icons/info_logo.png')
local AirdropColor = Color(150, 250, 150, 255)

local pos, current_pos
function PANEL:Init()
	self.map_current_pos = LocalPlayer():GetPos()
	
	local AirdropFactions = {
		[FACTION_MILITARY] = true,
		[FACTION_MILITARYS] = true,
	}
	
	self.Map = ui.Create('DLabel', function(map)
		map:SetText('')
		map:Dock(FILL)
		
		map.Paint = function(map, w, h) 
			minimap_texture_multiplier_x = current_zoom_real / minimap_power / minimap_texture_x
			minimap_texture_multiplier_y = current_zoom_real / minimap_power / minimap_texture_y
			
			current_pos = minimap_realmap_offset + Vector(self.map_current_pos.x / minimap_texture_x, -self.map_current_pos.y / minimap_texture_y, 0) / minimap_power
			
			if current_pos.x - minimap_texture_multiplier_x < -0.5 then
				self.map_current_pos = Vector(self.map_current_pos.x - (current_pos.x - minimap_texture_multiplier_x + 0.5) * minimap_power * minimap_texture_x, self.map_current_pos.y)
			end
			
			if current_pos.x + minimap_texture_multiplier_x > 0.5 then
				self.map_current_pos = Vector(self.map_current_pos.x - (current_pos.x + minimap_texture_multiplier_x - 0.5) * minimap_power * minimap_texture_x, self.map_current_pos.y)
			end
			
			if current_pos.y - minimap_texture_multiplier_y < -0.5 then
				self.map_current_pos = Vector(self.map_current_pos.x, self.map_current_pos.y + (current_pos.y - minimap_texture_multiplier_y + 0.5) * minimap_power * minimap_texture_y)
			end
			
			if current_pos.y + minimap_texture_multiplier_y > 0.5 then
				self.map_current_pos = Vector(self.map_current_pos.x, self.map_current_pos.y + (current_pos.y + minimap_texture_multiplier_y - 0.5) * minimap_power * minimap_texture_y)
			end
			
			current_pos = minimap_realmap_offset + Vector(self.map_current_pos.x / minimap_texture_x, -self.map_current_pos.y / minimap_texture_y, 0) / minimap_power
			
			self.map_w = w
			self.map_h = h
			
			sf_SDC(Color(255, 255, 255))
			sf_SM(map_image)
			sf_STR(0, 0, w, h, current_pos.x + 0.5 - minimap_texture_multiplier_x, current_pos.y + 0.5 - minimap_texture_multiplier_y, current_pos.x + 0.5 + minimap_texture_multiplier_x, current_pos.y + 0.5 + minimap_texture_multiplier_y)
			
			
				-- Entities and Factions
			for _, v in ipairs(rp.Map.EntIcons) do
				sf_SM(v.icon)
				pos = self:WorldToMap(v.pos)
				sf_DTR(pos.x + unit_offset, pos.y + unit_offset, unit_size, unit_size)
			end
				
				-- NPCs
			for _, v in ipairs(rp.Map.NPCIcons) do
				sf_SM(v.icon)
				pos = self:WorldToMap(v.pos)
				sf_DTR(pos.x + unit_offset, pos.y + unit_offset, unit_size, unit_size)
			end
			
			if AirdropFactions[LocalPlayer():GetFaction()] then
				-- Airdrops
				for _, v in ipairs(rp.AirDropEnts) do 
					if not IsValid(Entity(v.entIndex)) then continue end
					
					sf_SM(AirdropIcon)
					sf_SDC(AirdropColor)
					pos = self:WorldToMap(v.pos)
					sf_DTR(pos.x + unit_offset, pos.y + unit_offset, unit_size, unit_size)
				end
			end
				
				-- Custom map points
			for _, v in pairs(rp.Map.CustomPoints) do
				sf_SM(v.icon)
				sf_SDC(v.color)
				
				pos = self:WorldToMap(v.pos)
				sf_DTR(pos.x + unit_offset, pos.y + unit_offset, unit_size, unit_size)
				
				draw.SimpleText(v.name, 'StalkerSubBarFont', pos.x, pos.y - 22, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			end
			
			
			-- Center 
			sf_SDC(Color(255, 255, 255))
			sf_SM(unit_center)
			pos = self:WorldToMap(LocalPlayer():GetPos())
			sf_DTR(pos.x - 5, pos.y - 5, 10, 10)
		end
	end, self)
	
	self.ZoomPlus = ui.Create('DButton', function(btn)
		btn:SetText('+')
		btn:SetSize(40, 40)
		
		btn:AlignLeft(10)
		btn:AlignTop(10)
		
		btn.Paint = function(this, w, h)
			--derma.SkinHook('Paint', 'TabButton', btn, w, h)
			local baseColor, textColor = rpui.GetPaintStyle( this, STYLE_TRANSPARENT_INVERTED );
			surface.SetDrawColor( baseColor );
			surface.DrawRect( 0, 0, w, h );

			draw.SimpleText( this:GetText(), this:GetFont(), w * 0.5, h * 0.5, textColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
			
			return true
		end
		
		btn.DoClick = function()
			current_zoom_dist = math.Clamp(current_zoom_dist - 1000, min_zoom_distance, max_zoom_distance)
		end
	end, self)
	
	self.ZoomMinus = ui.Create('DButton', function(btn)
		btn:SetText('-')
		btn:SetSize(40, 40)
		
		btn:AlignLeft(10)
		btn:AlignTop(60)
		
		btn.Paint = function(this, w, h)
			--derma.SkinHook('Paint', 'TabButton', btn, w, h)
			local baseColor, textColor = rpui.GetPaintStyle( this, STYLE_TRANSPARENT_INVERTED );
			surface.SetDrawColor( baseColor );
			surface.DrawRect( 0, 0, w, h );

			draw.SimpleText( this:GetText(), this:GetFont(), w * 0.5, h * 0.5, textColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
			
			return true
		end
		
		btn.DoClick = function()
			current_zoom_dist = math.Clamp(current_zoom_dist + 1000, min_zoom_distance, max_zoom_distance)
		end
	end, self)
	
	self.ZoomMe = ui.Create('DButton', function(btn)
		btn:SetText('Я')
		btn:SetSize(40, 40)
		
		btn:AlignLeft(10)
		btn:AlignTop(110)
		
		btn.Paint = function(this, w, h)
			--derma.SkinHook('Paint', 'TabButton', btn, w, h)
			local baseColor, textColor = rpui.GetPaintStyle( this, STYLE_TRANSPARENT_INVERTED );
			surface.SetDrawColor( baseColor );
			surface.DrawRect( 0, 0, w, h );

			draw.SimpleText( this:GetText(), this:GetFont(), w * 0.5, h * 0.5, textColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
			
			return true
		end
		
		btn.DoClick = function()
			self.map_current_pos = LocalPlayer():GetPos()
		end
	end, self)
end

function PANEL:OnMousePressed(key)
	if key == MOUSE_LEFT then
		
		self.move_map = true
		self.move_pos_x, self.move_pos_y = gui.MousePos()
		
	elseif key == MOUSE_RIGHT then
		local my_pos = LocalPlayer():GetPos()
		
		local point_pos = self:MapToWorld(Vector(self:ScreenToLocal(gui.MousePos())))
		local point = self:GetCursorCustomPoint(point_pos)
		
		if point then
			openContextPointMenu(point)
			
		elseif Vector(point_pos.x, point_pos.y):DistToSqr(Vector(my_pos.x, my_pos.y)) < 50000 then
			openContextPointMenu(nil, true)
			
		elseif table.Count(rp.Map.CustomPoints) < custom_icons_max then 
			customPointNameDialog(point_pos)
		end
	end
end

function PANEL:OnMouseWheeled(n)
	self.move_map = false
	current_zoom_dist = math.Clamp(current_zoom_dist + (n > 0 and -500 or 500), min_zoom_distance, max_zoom_distance)
end

local pos_delta_x, pos_delta_y
function PANEL:Think()
	current_zoom_real = current_zoom_real + (current_zoom_dist - current_zoom_real) * 0.3
	
	if self.move_map then
		if not input.IsMouseDown(MOUSE_LEFT) then
			self.move_map = false
			return
		end
		
		pos_delta_x, pos_delta_y = gui.MousePos()
		
		pos_delta_x = pos_delta_x - self.move_pos_x
		pos_delta_y = pos_delta_y - self.move_pos_y
		
		if pos_delta_x ~= 0 or pos_delta_y ~= 0 then
			self.move_pos_x, self.move_pos_y = gui.MousePos()
			self.map_current_pos = self:MapToWorld(Vector(self.map_w / 2 - pos_delta_x, self.map_h / 2 - pos_delta_y))
		end
	end
end

vgui.Register('rp_map', PANEL, 'Panel')
hook.Add('PopulateNewF4Tabs', function(tabs)
	if not rp.cfg.DisableMinimap then
		local MapTab = tabs:AddTab( "Карта", vgui.Create("rp_map") );
	
		if MapTab.SetSpacing and tabs.innerPadding then
			MapTab:SetSpacing( tabs.innerPadding );
		end
	end
end)


local ents_data

rp.Map.NPCIcons = {}

for _, v in ipairs(rp.cfg.DialogueNPCs[game.GetMap()] or {}) do 
	if v.icon then 
		table.insert(rp.Map.NPCIcons, { icon = Material(v.icon), pos = v[1], dist = v.iconDistance and (v.iconDistance * v.iconDistance) })
	end
end

for _, v in pairs(rp.VendorsNPCs or {}) do 
	if v.icon then 
		table.insert(rp.Map.NPCIcons, { icon = Material(v.icon), pos = v.pos, dist = v.iconDistance and (v.iconDistance * v.iconDistance) })
	end
end

for _, v in pairs(rp.cfg.CustomMapPoints and rp.cfg.CustomMapPoints[game.GetMap()] or {}) do 
	if v.icon then 
		table.insert(rp.Map.NPCIcons, { icon = Material(v.icon), pos = v.pos, dist = v.iconDistance and (v.iconDistance * v.iconDistance) })
	end
end

for _, v in ipairs(rp.Factions or {}) do 
	if not v.npcs or not v.npcs[game.GetMap()] then continue end
	
	for __, npc in pairs(v.npcs[game.GetMap()]) do
		if npc[4] then 
			table.insert(rp.Map.NPCIcons, { icon = Material(npc[4]), pos = npc[1], dist = npc[5] and (npc[5] * npc[5]) })
		end
	end
	
end

timer.Create("rp.Map.GetEntityData", 2, 0, function()
	if not ents_data or not IsValid(LocalPlayer()) then return end
	rp.Map.EntityData = {}
	
	for _, v in ipairs(ents.GetAll()) do 
		if ents_data[v:GetClass()] then
			table.insert(rp.Map.EntityData, { ent = v, icon = ents_data[v:GetClass()].icon, dist = ents_data[v:GetClass()].dist })
		end
		
		if v:IsPlayer() and v ~= LocalPlayer() and v:GetJobTable() and v:GetJobTable().minimapIcon then 
			table.insert(rp.Map.EntityData, { ent = v, icon = v:GetJobTable().minimapIcon })
		end
	end
	
	
	local my_pos = LocalPlayer():GetPos()
	
	for _, v in pairs(rp.Map.CustomPoints) do 
		if v.time and CurTime() > v.time or Vector(v.pos.x, v.pos.y):DistToSqr(Vector(my_pos.x, my_pos.y)) < 50000 then
			rp.Map.CustomPoints[_] = nil
		end
	end
end)

hook.Add('Tick', 'rp.Map.ProcessEntityPositions', function()
	rp.Map.EntIcons = {}
	
	if not ents_data and rp.cfg.MinimapIcons then
		ents_data = {}
		
		for k, v in pairs(rp.cfg.MinimapIcons) do
			ents_data[k] = { icon = Material(v.icon), dist = v.distance and (v.distance * v.distance) }
		end
		
	elseif rp.Map.EntityData then
		for _, v in ipairs(rp.Map.EntityData) do 
			if not IsValid(v.ent) then
				rp.Map.EntityData[_] = nil
			else
				table.insert(rp.Map.EntIcons, { icon = v.icon, pos = v.ent:GetPos(), dist = v.dist })
			end
		end
	end
	
	for _, v in ipairs(rp.Factions) do
		if v.npcs and v.npcs.minimapIcon then
			table.insert(rp.Map.EntIcons, { icon = v.npcs.minimapIcon, pos = v.npcs[game.GetMap()][1][1], dist = v.npcs.minimapIconDist })
		end
	end
end)

net.Receive('rp.Map.SendCustomPoint', function()
	local name 	= net.ReadString()
	local point = getCustomPointByName(name)
	
	if point then
		rp.Map.CustomPoints[point].pos = net.ReadVector()
		rp.Map.CustomPoints[point].time = CurTime() + custom_point_player_time
	else
		table.insert(rp.Map.CustomPoints, { pos = net.ReadVector(), icon = player_pos_icon, color = custom_point_player_color, name = name, time = CurTime() + custom_point_player_time })
	end
end)