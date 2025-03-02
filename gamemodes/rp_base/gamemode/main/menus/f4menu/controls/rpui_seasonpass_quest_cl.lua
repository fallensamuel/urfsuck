-- "gamemodes\\rp_base\\gamemode\\main\\menus\\f4menu\\controls\\rpui_seasonpass_quest_cl.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal

local seasonpass_done_check 	= Color(45, 175, 60, 255)

local check_mark_material 		= Material("rpui/seasonpass/tab_received.png", 'smooth noclamp')
local circle_material 			= Material('rpui/seasonpass/circle.png', 'smooth noclamp')
local circle_empty_material 	= Material('rpui/seasonpass/circle_empty.png', 'smooth noclamp')
local pin_on_material 			= Material('rpui/seasonpass/pin_on', 'smooth noclamp')
local pin_off_material 			= Material('rpui/seasonpass/pin_off', 'smooth noclamp')

local cvar_pin_name = 'spass_pin'
local cvar_nohud_name = 'hidehud_' .. game.GetMap()

local cvar_Get = cvar.GetValue


local PANEL = {}

function PANEL:Init()
end

function PANEL:SetQuest(quest_id, appearance_id, only_progress)
	local real_quest_id = LocalPlayer():SeasonGetQuests()[quest_id]
	local quest_data = rp.seasonpass.Quests[real_quest_id]
	
	local innerPadding = rp.seasonpass.Menu and rp.seasonpass.Menu.innerPadding or (0.02 * ScrH() * 0.75)
	
	if not quest_data then 
		if appearance_id == 1 then
			self:DockMargin(0, innerPadding * 3, 0, 0)
			
			local done_txt_1 = vgui.Create("DLabel", self)
			done_txt_1.Dock(done_txt_1, TOP)
			done_txt_1.DockMargin(done_txt_1, 0, 0, 0, 0)
			done_txt_1.SetFont(done_txt_1, "rpui.Fonts.Seasonpass.HeadTitleUsual")
			done_txt_1.SetTextColor(done_txt_1, ColorAlpha(self.UIColors.White or rpui.UIColors.White, 255))
			done_txt_1.SetText(done_txt_1, translates.Get("Вы выполнили все задания!"))
			done_txt_1.SetContentAlignment(done_txt_1, 5)
			
			local done_txt_2 = vgui.Create("DLabel", self)
			done_txt_2.Dock(done_txt_2, TOP)
			done_txt_2.DockMargin(done_txt_2, 0, 0, 0, 0)
			done_txt_2.SetFont(done_txt_2, "rpui.Fonts.Seasonpass.QuestText")
			done_txt_2.SetTextColor(done_txt_2, ColorAlpha(self.UIColors.White or rpui.UIColors.White, 255))
			done_txt_2.SetText(done_txt_2, translates.Get("Осталось забрать награду"))
			done_txt_2.SetContentAlignment(done_txt_2, 5)
			
			self:InvalidateLayout()
	
			local time_dist = 0.25 --+ FrameTime() * 3
			
			timer.Simple(time_dist, function()
				if not IsValid(self) then return end
				self:SizeToChildren(false, true)
			end)
			
			self:SetAlpha(0)
			
			timer.Simple(appearance_id * time_dist, function()
				if not IsValid(self) then return end
				self:AlphaTo(255, 0.25)
			end)
		end
		
		return 
	end
	
	local is_done = LocalPlayer():SeasonCompletedQuest(real_quest_id)
	local progress = (LocalPlayer():GetNetVar("SeasonpassQuests") or {})[quest_id] or 0
	local max_progress = quest_data.MaxProgress or 1
	
	local frameW = 0.75 * ScrW()
	local innerSize = frameW * 0.24 - innerPadding * 8
	
	self:SetTall(ScrH() * 0.1)
	
	self.WrappedText = string.Wrap("rpui.Fonts.Seasonpass.QuestText", isstring(quest_data.Name) and quest_data.Name or quest_data.Name(), innerSize)
	
	for k, v in pairs(self.Titles or {}) do
		if IsValid(v) then
			v:Remove()
		end
		
		if IsValid(self.TitleLines[k]) then
			self.TitleLines[k].Remove(self.TitleLines[k])
		end
	end
	
	self.Titles = {}
	self.TitleLines = {}
	
	for k, v in pairs(self.WrappedText) do
		local title = vgui.Create("DLabel", self)
		title.Dock(title, TOP)
		title.DockMargin(title, innerPadding * 2, (k > 1) and -innerPadding * 0.6 * 1 or 0, 0, 0)
		title.SetFont(title, "rpui.Fonts.Seasonpass.QuestText")
		title.SetTextColor(title, ColorAlpha(self.UIColors.White or rpui.UIColors.White, is_done and 128 or 255))
		title.SetText(title, v)
		
		local title_line = vgui.Create("DPanel", title)
		title_line.Dock(title_line, FILL)
		title_line.Paint = function(stl, stl_w, stl_h) 
			if stl.TextWide and is_done then
				surface.SetDrawColor(255, 255, 255, 90)
				surface.DrawRect(0, stl_h * 0.5, stl.TextWide, 2)
			end
		end
		title.SetTall(title, innerPadding * 1.8)
		
		table.insert(self.Titles, title)
		table.insert(self.TitleLines, title_line)
	end
	
	if IsValid(self.StatsBlock) then
		self.StatsBlock.Remove(self.StatsBlock)
	end
	
	self.StatsBlock = vgui.Create("DPanel", self)
	self.StatsBlock.Dock(self.StatsBlock, TOP)
	self.StatsBlock.DockMargin(self.StatsBlock, innerPadding * 2, innerPadding * 0.5, innerPadding * 2, 0)
	self.StatsBlock.Paint = function() end
	
	self.DotBlock = vgui.Create("DPanel", self)
	self.DotBlock.Paint = function(dt, dt_w, dt_h)
		surface.SetDrawColor(255, 255, 255, 255)
		surface.SetMaterial(is_done and circle_material or circle_empty_material)
		surface.DrawTexturedRect(dt_w * 0.35 - dt_w * 0.26, dt_h * 0.6 - dt_w * 0.2, dt_w * 0.26 * 2, dt_w * 0.26 * 2)
		
		if is_done then
			surface.SetDrawColor(seasonpass_done_check)
			surface.SetMaterial(check_mark_material)
			surface.DrawTexturedRect(0, 0, dt_w, dt_h)
		end
	end
	self.DotBlock.SetAlpha(self.DotBlock, 0)
	
	self.StatsBlock.Left = vgui.Create("DPanel", self.StatsBlock)
	self.StatsBlock.Left.Dock(self.StatsBlock.Left, LEFT)
	self.StatsBlock.Left.SetWide(self.StatsBlock.Left, innerSize)
	self.StatsBlock.Left.Paint = function() end
	
	if not only_progress then
		self.StatsBlock.Left.Difficulty = vgui.Create("DLabel", self.StatsBlock.Left)
		self.StatsBlock.Left.Difficulty.Dock(self.StatsBlock.Left.Difficulty, TOP)
		self.StatsBlock.Left.Difficulty.SetFont(self.StatsBlock.Left.Difficulty, "rpui.Fonts.Seasonpass.QuestText")
		self.StatsBlock.Left.Difficulty.SetText(self.StatsBlock.Left.Difficulty, translates.Get("Сложность:"))
		self.StatsBlock.Left.Difficulty.SetTextColor(self.StatsBlock.Left.Difficulty, ColorAlpha(self.UIColors.White or rpui.UIColors.White, is_done and 128 or 255))
		self.StatsBlock.Left.Difficulty.SizeToContentsY(self.StatsBlock.Left.Difficulty)
		
		self.StatsBlock.Left.Experience = vgui.Create("DLabel", self.StatsBlock.Left)
		self.StatsBlock.Left.Experience.Dock(self.StatsBlock.Left.Experience, TOP)
		self.StatsBlock.Left.Experience.SetFont(self.StatsBlock.Left.Experience, "rpui.Fonts.Seasonpass.QuestText")
		self.StatsBlock.Left.Experience.SetText(self.StatsBlock.Left.Experience, translates.Get("Опыт:"))
		self.StatsBlock.Left.Experience.SetTextColor(self.StatsBlock.Left.Experience, ColorAlpha(self.UIColors.White or rpui.UIColors.White, is_done and 128 or 255))
		self.StatsBlock.Left.Experience.SizeToContentsY(self.StatsBlock.Left.Experience)
	end
	
	self.StatsBlock.Left.Progress = vgui.Create("DLabel", self.StatsBlock.Left)
	self.StatsBlock.Left.Progress.Dock(self.StatsBlock.Left.Progress, TOP)
	self.StatsBlock.Left.Progress.SetFont(self.StatsBlock.Left.Progress, "rpui.Fonts.Seasonpass.QuestText")
	self.StatsBlock.Left.Progress.SetText(self.StatsBlock.Left.Progress, translates.Get("Прогресс:"))
	self.StatsBlock.Left.Progress.SetTextColor(self.StatsBlock.Left.Progress, ColorAlpha(self.UIColors.White or rpui.UIColors.White, is_done and 128 or 255))
	self.StatsBlock.Left.Progress.SizeToContentsY(self.StatsBlock.Left.Progress)
	
	
	self.StatsBlock.Right = vgui.Create("DPanel", self.StatsBlock)
	self.StatsBlock.Right.Dock(self.StatsBlock.Right, RIGHT)
	self.StatsBlock.Right.SetWide(self.StatsBlock.Right, innerSize)
	self.StatsBlock.Right.Paint = function() end
	self.StatsBlock.Right.Stars = {}
	
	if not only_progress then
		self.StatsBlock.Right.Difficulty = vgui.Create("DPanel", self.StatsBlock.Right)
		self.StatsBlock.Right.Difficulty.Dock(self.StatsBlock.Right.Difficulty, TOP)
		self.StatsBlock.Right.Difficulty.Paint = function() end
		
		self.StatsBlock.Right.Progress = vgui.Create("DLabel", self.StatsBlock.Right)
		self.StatsBlock.Right.Progress.Dock(self.StatsBlock.Right.Progress, TOP)
		self.StatsBlock.Right.Progress.SetFont(self.StatsBlock.Right.Progress, "rpui.Fonts.Seasonpass.QuestText")
		self.StatsBlock.Right.Progress.SetText(self.StatsBlock.Right.Progress, quest_data.Scores)
		self.StatsBlock.Right.Progress.SetTextColor(self.StatsBlock.Right.Progress, ColorAlpha(self.UIColors.White or rpui.UIColors.White, is_done and 128 or 255))
		self.StatsBlock.Right.Progress.SetContentAlignment(self.StatsBlock.Right.Progress, 6)
		self.StatsBlock.Right.Progress.SizeToContentsY(self.StatsBlock.Right.Progress)
	end
	
	self.StatsBlock.Right.Experience = vgui.Create("DLabel", self.StatsBlock.Right)
	self.StatsBlock.Right.Experience.Dock(self.StatsBlock.Right.Experience, TOP)
	self.StatsBlock.Right.Experience.SetFont(self.StatsBlock.Right.Experience, "rpui.Fonts.Seasonpass.QuestText")
	self.StatsBlock.Right.Experience.SetText(self.StatsBlock.Right.Experience, progress .. ' / ' .. max_progress)
	self.StatsBlock.Right.Experience.SetTextColor(self.StatsBlock.Right.Experience, ColorAlpha(self.UIColors.White or rpui.UIColors.White, is_done and 128 or 255))
	self.StatsBlock.Right.Experience.SetContentAlignment(self.StatsBlock.Right.Experience, 6)
	self.StatsBlock.Right.Experience.SizeToContentsY(self.StatsBlock.Right.Experience)
	self.StatsBlock.Right.Experience.QuestID = quest_id
	self.StatsBlock.Right.Experience.Think = function(strex)
		strex:SetText((LocalPlayer():SeasonQuestFakedProgress(strex.QuestID) or 0) .. ' / ' .. max_progress)
	end
	
	for k = 1, 3 do
		local star = vgui.Create("DPanel", self.StatsBlock.Right.Difficulty)
		star.Dock(star, RIGHT)
		star.DockMargin(star, innerPadding, 0, 0, 0)
		star.Paint = function(st, st_w, st_h)
			surface.SetDrawColor(255, 255, 255, is_done and 90 or 255)
			surface.SetMaterial(st.Mat)
			surface.DrawTexturedRect(0, 0, st_w, st_h)
		end
		
		star.SetAlpha(star, 0)
		star.Mat = Material((quest_data.Difficulty >= k) and "rpui/seasonpass/star_on.png" or "rpui/seasonpass/star_off.png")
		
		table.insert(self.StatsBlock.Right.Stars, star)
	end
	
	self.StatsBlock.Left.InvalidateLayout(self.StatsBlock.Left)
	self.StatsBlock.Right.InvalidateLayout(self.StatsBlock.Right)
	self.StatsBlock.InvalidateLayout(self.StatsBlock)
	self:InvalidateLayout()
	
	local time_dist = 0.25 --+ FrameTime() * 3
	
	timer.Simple(time_dist, function()
		if not IsValid(self) or not IsValid(self.StatsBlock) then return end
		local font_tall = self.StatsBlock.Right.Experience.GetTall(self.StatsBlock.Right.Experience)
		
		if IsValid(self.StatsBlock.Right.Difficulty) then
			self.StatsBlock.Right.Difficulty.SetTall(self.StatsBlock.Right.Difficulty, font_tall * 0.8)
			self.StatsBlock.Right.Difficulty.DockMargin(self.StatsBlock.Right.Difficulty, 0, font_tall * 0.1, 0, font_tall * 0.1)
			
			for k, v in pairs(self.StatsBlock.Right.Stars) do
				v.SetSize(v, font_tall * 0.8, font_tall * 0.6)
				v.AlphaTo(v, 255, 0.25)
			end
		end
		
		surface.SetFont("rpui.Fonts.Seasonpass.QuestText")
		
		for k, v in pairs(self.TitleLines) do
			local text_wide = surface.GetTextSize(self.Titles[k].GetText(self.Titles[k]))
			v.TextWide = text_wide
		end
		
		local pos_x, pos_y = self.Titles[1].GetPos(self.Titles[1])
		
		self.DotBlock.SetPos(self.DotBlock, pos_x - innerPadding * 1.2, pos_y + font_tall * 0.5 - font_tall * 0.5)
		self.DotBlock.SetSize(self.DotBlock, font_tall * 1.1, font_tall * 1.1)
		self.DotBlock.AlphaTo(self.DotBlock, 255, 0.15)
		
		--timer.Simple(0.1 * FrameTime() * 5, function()
			self.StatsBlock.Left.SizeToChildren(self.StatsBlock.Left, false, true)
			self.StatsBlock.Right.SizeToChildren(self.StatsBlock.Right, false, true)
			
			self.StatsBlock.SizeToChildren(self.StatsBlock, false, true)
			
			self:SizeToChildren(false, true)
			self:InvalidateLayout()
			self:GetParent():InvalidateLayout()
		--end)
	end)
	
	self:SetAlpha(0)
	
	timer.Simple(appearance_id * time_dist, function()
		if not IsValid(self) then return end
		
		self:SizeToChildren(false, true)
		self:InvalidateLayout()
		self:GetParent():InvalidateLayout()
		
		self:AlphaTo(255, 0.25)
	end)
end

function PANEL:Paint()
end

vgui.Register("rpui.Seasonpass.QuestPanel", PANEL, "DPanel")


local function update_fonts(frameW, frameH)
	local season = rp.seasonpass.GetSeason()
	
    surface.CreateFont("rpui.Fonts.Seasonpass.Title", {
        font     = "Montserrat",
        extended = true,
        weight 	 = 400,
        size     = math.ceil(frameH * 0.102 * (season and season.LogoNameMult or 1)),
    })
    surface.CreateFont("rpui.Fonts.Seasonpass.SubTitle", {
        font     = "Montserrat",
        extended = true,
        weight 	 = 400,
        size     = math.ceil(frameH * 0.084 * (season and season.LogoNameMult or 1)),
    })
    surface.CreateFont("rpui.Fonts.Seasonpass.TimeTitle", {
        font     = "Montserrat",
        extended = true,
        weight   = 500,
        size     = math.max(math.ceil(frameH * 0.026), 16),
    })
    surface.CreateFont("rpui.Fonts.Seasonpass.QuestText", {
        font     = "Montserrat",
        extended = true,
        weight   = 500,
        size     = math.max(math.ceil(frameH * 0.026), 15),
    })
    surface.CreateFont("rpui.Fonts.Seasonpass.QuestTitle", {
        font     = "Montserrat",
        extended = true,
        weight   = 700,
        size     = math.ceil(frameH * 0.038),
    })
    surface.CreateFont("rpui.Fonts.Seasonpass.QuestTitle2", {
        font     = "Montserrat",
        extended = true,
        weight   = 550,
        size     = math.ceil(frameH * 0.03),
    })
    surface.CreateFont("rpui.Fonts.Seasonpass.PremiumButton", {
        font     = "Montserrat",
        extended = true,
        weight   = 900,
        size     = math.ceil(frameH * 0.038),
    })
    surface.CreateFont("rpui.Fonts.Seasonpass.MainLevel", {
        font     = "Montserrat",
        extended = true,
        weight   = 500,
        size     = math.ceil(frameH * 0.068),
    })
    surface.CreateFont("rpui.Fonts.Seasonpass.SubLevel", {
        font     = "Montserrat",
        extended = true,
        weight   = 700,
        size     = math.ceil(frameH * 0.027),
    })
    surface.CreateFont("rpui.Fonts.Seasonpass.TitlePremium", {
        font     = "Montserrat",
        extended = true,
        weight   = 700,
        size     = math.ceil(frameH * 0.054),
    })
    surface.CreateFont("rpui.Fonts.Seasonpass.Progress", {
        font     = "Montserrat",
        extended = true,
        weight   = 500,
        size     = math.ceil(frameH * 0.027),
    })
    surface.CreateFont("rpui.Fonts.Seasonpass.HeadTitleUsual", {
        font     = "Montserrat",
        extended = true,
        weight   = 700,
        size     = math.ceil(frameH * 0.03),
    })
    surface.CreateFont("rpui.Fonts.Seasonpass.HeadTitlePremium", {
        font     = "Montserrat",
        extended = true,
        weight   = 700,
        size     = math.max(math.ceil(frameH * 0.019 * (season and season.RPPassNameMult or 1)), 11),
    })
    surface.CreateFont("rpui.Fonts.Seasonpass.HeadTitlePremium2", {
        font     = "Montserrat",
        extended = true,
        weight   = 700,
        size     = math.max(math.ceil(frameH * 0.022 * (season and season.RPPassNameMult or 1)), 12),
    })
    surface.CreateFont("rpui.Fonts.Seasonpass.HeadSeason", {
        font     = "Montserrat",
        extended = true,
        weight   = 400,
        size     = math.ceil(frameH * 0.03),
    })
    surface.CreateFont("rpui.Fonts.Seasonpass.HeadSeasonNamel", {
        font     = "Montserrat",
        extended = true,
        weight   = 400,
        size     = math.max(math.ceil(frameH * 0.02), 11),
    })
    surface.CreateFont( "rpui.Fonts.Seasonpass.Small", {
        font     = "Montserrat",
        extended = true,
        weight 	 = 500,
        size     = math.ceil(frameH * 0.025),
    })
    surface.CreateFont( "rpui.Fonts.Seasonpass.Tooltip", {
        font     = "Montserrat",
        extended = true,
        weight = 500,
        size     = math.max(math.ceil(frameH * 0.0175), 14),
    } );
end

local hud_frameW, hud_frameH, ply, innerPadding

cvar.Register(cvar_pin_name)
	:SetDefault(true)
	:AddMetadata('State', 'RPMenu')
	:AddMetadata('Menu', 'Показывать задачи Season Pass в худе')

local hud_quests_panel, cur_quests_data
local saved_quests_data
local last_quests_check
local head_tall, head_color

local white_color = Color(255, 255, 255, 80)

hook.Add("InitPostEntity", "Seasonpass::LoadQuests", function()
	hook.Remove("InitPostEntity", "Seasonpass::LoadQuests")
	
	timer.Simple(3, function()
		update_fonts(ScrW() * 0.75, ScrH() * 0.75)
		
		hook.Add("HUDPaint", "Seasonpass::PinnedQuests", function()
			local season = LocalPlayer().GetSeason and LocalPlayer():GetSeason() or rp.seasonpass.GetSeason()
			
			if not season or not LocalPlayer():GetNetVar('SeasonpassQuests') or IsValid(rp.MOTD) then return end
			
			ply = LocalPlayer()
			hud_quests_panel = rp.seasonpass.HudPanel
			
			if not IsValid(ply) or not ply:Alive() then return end
			
			if not cvar_Get(cvar_pin_name) or cvar_Get(cvar_nohud_name) then 
				if IsValid(hud_quests_panel) then
					hud_quests_panel:Remove()
				end
				
				return 
			end
			
			local quests_needed = false
			
			for k = 1, 3 do
				if not LocalPlayer():SeasonCompletedQuest(LocalPlayer():SeasonGetQuests()[k]) then
					quests_needed = true
					break
				end
			end
			
			if not quests_needed then 
				if IsValid(hud_quests_panel) then
					hud_quests_panel:Remove()
				end
				
				return 
			end
			
			innerPadding = 0.015 * ScrH()
			
			hud_frameW = ScrW()
			hud_frameH = ScrH()
			
			if not IsValid(hud_quests_panel) then
				hud_quests_panel = vgui.Create("DPanel")
				rp.seasonpass.HudPanel = hud_quests_panel
				
				hud_quests_panel.SetSize(hud_quests_panel, math.ceil(hud_frameW * 0.17), math.ceil(hud_frameH * 0.07))
				hud_quests_panel.SetPos(hud_quests_panel, hud_frameW - math.floor(hud_frameW * 0.17) - innerPadding * 1, (hud_frameH - math.floor(hud_frameH * 0.3)) * 0.3 + (season.QuestHudMenuOffsetY or 0))
				hud_quests_panel.Paint = function(a1, a1_w, a1_h) 
					surface.SetDrawColor(Color(0, 0, 0, 100))
					surface.DrawRect(0, 0, a1_w, a1_h)
					
					if IsValid(hud_quests_panel.Title) then
						local head_tall = hud_quests_panel.Title.GetTall(hud_quests_panel.Title) + innerPadding * 1
						
						if not head_color then
							head_color = rp.cfg.UIColor.BlockHeader or Color(0, 0, 0, 255)
						end
						
						surface.SetDrawColor(head_color)
						surface.DrawRect(0, 0, a1_w, head_tall)
						
						surface.SetDrawColor(white_color)
						surface.SetMaterial(rpui.GradientMat)
						surface.DrawTexturedRectRotated(a1_w * 0.5, 0, head_tall * 2, a1_w, -90)
					end
				end
				hud_quests_panel.Quests = {}
				
				hud_quests_panel.Title = vgui.Create("DLabel", hud_quests_panel)
				hud_quests_panel.Title.Dock(hud_quests_panel.Title, TOP)
				hud_quests_panel.Title.DockMargin(hud_quests_panel.Title, 0, innerPadding * 0.5 - 1, 0, innerPadding * 0.5)
				hud_quests_panel.Title.SetTextColor(hud_quests_panel.Title, Color(255, 255, 255, 255))
				hud_quests_panel.Title.SetFont(hud_quests_panel.Title, "rpui.Fonts.Seasonpass.QuestTitle2")
				hud_quests_panel.Title.SetText(hud_quests_panel.Title, season.QuestsCustomText or translates.Get("Задания на день"))
				hud_quests_panel.Title.SetContentAlignment(hud_quests_panel.Title, 5)
				
				surface.SetFont("rpui.Fonts.Seasonpass.QuestTitle2")
				local sq_off_x = surface.GetTextSize(season.QuestsCustomText or translates.Get("Задания на день"))
				local sq_off_sx = 0.017 * hud_frameH
				
				local par_p_x, par_p_y = hud_quests_panel.GetPos(hud_quests_panel)
				
				hud_quests_panel.PinButton = vgui.Create("DButton")
				hud_quests_panel.PinButton.SetSize(hud_quests_panel.PinButton, hud_frameH * 0.056, hud_frameH * 0.056)
				hud_quests_panel.PinButton.SetText(hud_quests_panel.PinButton, "")
				hud_quests_panel.PinButton.SetPos(hud_quests_panel.PinButton, par_p_x + hud_frameW * 0.12 * 0.54 + sq_off_x * 0.5 + innerPadding * 2, par_p_y - innerPadding * 0.5)
				hud_quests_panel.PinButton.Paint = function(sqpb, sqpb_w, sqpb_h)
					if IsValid(hud_quests_panel) then
						surface.SetDrawColor(Color(255, 255, 255, hud_quests_panel.GetAlpha(hud_quests_panel)))
						surface.SetMaterial(cvar_Get(cvar_pin_name) and pin_on_material or pin_off_material)
						surface.DrawTexturedRect(sq_off_sx, sq_off_sx, sqpb_w - sq_off_sx * 2, sqpb_h - sq_off_sx * 2)
					end
				end
				hud_quests_panel.PinButton.DoClick = function()
					cvar.SetValue(cvar_pin_name, not cvar_Get(cvar_pin_name))
				end
				hud_quests_panel.PinButton.Think = function(a2)
					if not IsValid(hud_quests_panel) then
						a2.Remove(a2)
						return
					end
					
					if a2.IsMouseInputEnabled( a2 ) then a2.SetMouseInputEnabled( a2, false ); end
					
					if g_ContextMenu.IsVisible(g_ContextMenu) or IsValid(rp.F4MenuPanel) then
						a2.SetMouseInputEnabled( a2, true );   
						a2.MoveToFront( a2 );
					end
				end
				hud_quests_panel.PinButton.MakePopup(hud_quests_panel.PinButton)
				hud_quests_panel.PinButton.SetKeyboardInputEnabled( hud_quests_panel.PinButton, false );
				hud_quests_panel.PinButton.SetMouseInputEnabled( hud_quests_panel.PinButton, false );
				
				hud_quests_panel.Questbar = vgui.Create("DPanel", hud_quests_panel)
				hud_quests_panel.Questbar.Dock(hud_quests_panel.Questbar, BOTTOM)
				hud_quests_panel.Questbar.DockMargin(hud_quests_panel.Questbar, 0, 0, 0, innerPadding * 1)
				hud_quests_panel.Questbar.Paint = function() end
				hud_quests_panel.Questbar.DoQuests = function()
					for k, v in pairs(hud_quests_panel.Quests) do
						if IsValid(v) then
							v:Remove()
						end
					end
					
					hud_quests_panel.Quests = {}
					
					local temp_id		= 0
					local quests 		= {}
					
					for k = 1, 3 do
						if not LocalPlayer():SeasonCompletedQuest(LocalPlayer():SeasonGetQuests()[k]) then
							table.insert(quests, k)
						end
					end
					
					for k = 1, #quests do
						local quest = vgui.Create("rpui.Seasonpass.QuestPanel", hud_quests_panel.Questbar)
						quest.DockMargin(quest, innerPadding, innerPadding * ((k == 1) and 0 or 0.6), innerPadding, 0)
						quest.Dock(quest, TOP)
						
						quest.SetQuest(quest, quests[k], k, true)
						
						hud_quests_panel.Quests[#hud_quests_panel.Quests + 1] = quest
					end
				end
				hud_quests_panel.Questbar.DoQuests()
				
				hud_quests_panel.Questbar.InvalidateLayout(hud_quests_panel.Questbar)
				hud_quests_panel.SetAlpha(hud_quests_panel, 0)
				
				timer.Remove("Seasonpass::UpdateHudStage1")
				timer.Remove("Seasonpass::UpdateHudStage2")
				
				timer.Create("Seasonpass::UpdateHudStage1", 0.5, 1, function()
					if not IsValid(hud_quests_panel) then return end
					
					hud_quests_panel.Questbar.SetTall(hud_quests_panel.Questbar, innerPadding * 0.6 + (IsValid(hud_quests_panel.Quests[1]) and hud_quests_panel.Quests[1].GetTall(hud_quests_panel.Quests[1]) + innerPadding * 0.4 * 1 or 0) + (IsValid(hud_quests_panel.Quests[2]) and hud_quests_panel.Quests[2].GetTall(hud_quests_panel.Quests[2]) + innerPadding * 0.6 * 1 or 0) + (IsValid(hud_quests_panel.Quests[3]) and hud_quests_panel.Quests[3].GetTall(hud_quests_panel.Quests[3]) + innerPadding * 0.6 * 1 or 0))
					
					timer.Create("Seasonpass::UpdateHudStage2", 0.3, 1, function()
						if not IsValid(hud_quests_panel) then return end
						
						hud_quests_panel.AlphaTo(hud_quests_panel, 255, 0.2)
						
						hud_quests_panel.SetTall(hud_quests_panel, hud_quests_panel.Questbar.GetTall(hud_quests_panel.Questbar) + hud_quests_panel.GetTall(hud_quests_panel))
					end)
				end)
			end
		end)
	end)
end)