-- "gamemodes\\darkrp\\gamemode\\addons\\quest\\cl_vgui.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local PANEL = {}

AddMethod(PANEL, "Quest")

function PANEL:Init()
	self:SetText('')
	self:SetTall(50)
	--self.Model = ui.Create('rp_modelicon', self)
--
	--self.Model.DoClick = function(s)
	--	s.DoClick(self)
	--end
end

function PANEL:Paint(w, h)
	draw.OutlinedBox(0, 0, w, h, self.color, ui.col.Outline)

	if self:IsHovered() then
		draw.OutlinedBox(0, 0, w, h, self.color, ui.col.Hover)
	end

	local x = 10

	if self.Quest:GetVIP() then
		x = x + draw.SimpleTextOutlined('[VIP]', 'rp.ui.22', x, h * 0.5, ui.col.Orange, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, ui.col.Black) + 5
	end

	draw.SimpleTextOutlined(self.Quest:GetName(), 'rp.ui.22', x, h * 0.5, ui.col.White, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, ui.col.Black)
	--print(self.Quest:HasRemainingCooldown(LocalPlayer()) && self.Quest:GetRemainingCooldown(LocalPlayer()))
	if self.Quest:GetUnlockTime() > LocalPlayer():GetPlayTime() then
		draw.SimpleTextOutlined(ba.str.FormatTime(self.Quest:GetUnlockTime(LocalPlayer())-LocalPlayer():GetPlayTime()), 'rp.ui.22', w - 10, h * 0.5, ui.col.White, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, 1, ui.col.Black)
	--elseif self.Quest:CalculateCooldown(LocalPlayer()) == 0 then
	--	draw.SimpleTextOutlined("Not available", 'rp.ui.22', w - 10, h * 0.5, ui.col.White, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, 1, ui.col.Black)

	elseif self.Quest:HasRemainingCooldown(LocalPlayer()) && self.Quest:GetRemainingCooldown(LocalPlayer()) > 0 then
		draw.SimpleTextOutlined(ba.str.FormatTime(self.Quest:GetRemainingCooldown(LocalPlayer())), 'rp.ui.22', w - 10, h * 0.5, ui.col.White, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, 1, ui.col.Black)
	end
end

function PANEL:PerformLayout()
	--self.Model:SetPos(0, 0)
	--self.Model:SetSize(50, 50)
end

function PANEL:DoClick()
	self.Parent.Quest = self.Quest
	self.Parent.btnPurchase.Quest = self.Quest

	self.Parent.btnPurchase:SetVisible(true)
end

function PANEL:SetQuest(Quest)
	self.Quest = Quest
	self.color = Color(Quest:GetColor().r, Quest:GetColor().g, Quest:GetColor().b, 125)
--	self.Model:SetModel(Quest:GetModel())
end

vgui.Register('rp_quest', PANEL, 'Button')

PANEL = {}

function PANEL:Init()
	self:BaseInit()
end

function PANEL:GetQuestNPC()
	return self.QuestNPCID
end

function PANEL:SetQuestNPC(id)
	for k, v in ipairs(rp.Quest.GetNPCQuests(id)) do
		local btn = ui.Create('rp_quest')
		btn:SetQuest(v)
		btn.Parent = self
		self.QuestList:AddItem(btn)
	end

	self.QuestNPCID = id
	self.QuestNPC = rp.Quest.GetNPC(id)


end

function PANEL:BaseInit()
	self.QuestList = ui.Create('ui_scrollpanel', self)

	self.InfoPanel = ui.Create('ui_scrollpanel', self)

	self.btnPurchase = ui.Create("DButton", function(self)
		self:SetText("Начать квест")
		self:SetSize(0, 25)
		self:DockMargin(5, 5, 5, 5)
		self:Dock(BOTTOM)
		self:SetVisible(false)

		function self:Think()
			if !self.Quest then return end
			if rp.Quest.NextThink > CurTime() then return end

		
			self:SetVisible(true)

			self:SetDisabled(false)
			self:SetText("Начать квест")

			self.DoClick = function(s)
				if !self.Quest:GetAutoComplete() && LocalPlayer():IsQuestCompleted(self.Quest) then
					rp.Quest.CompleteQuest(self.Quest:GetID())
				elseif LocalPlayer():GetQuest(self.Quest) then
					rp.Quest.Reject(self.Quest:GetID())
				else
					rp.Quest.Start(self.Quest:GetID())
				end

				self:SetDisabled(true)
				self:SetText("...")

				rp.Quest.NextThink = CurTime() + 3
			end

			if !self.Quest:GetAutoComplete() && LocalPlayer():IsQuestCompleted(self.Quest) then
				self:SetText("Забрать награду")
				return
			end

			if LocalPlayer():GetQuest(self.Quest) then
				self:SetText("Отменить квест")
				return
			end

			if LocalPlayer():GetQuestCooldown(self.Quest) && LocalPlayer():GetQuestCooldown(self.Quest) == 0 then
				self:SetDisabled(true)
				self:SetText("Этот квест можно выполнить только один раз")
				return
			end

			if self.Quest:HasRemainingCooldown(LocalPlayer()) then
				self:SetDisabled(true)
				self:SetText("Квест не доступен в данный момент")
				return
			end

			if self.Quest:GetUnlockTime() > LocalPlayer():GetPlayTime() then
				self:SetDisabled(true)
				self:SetText("Вы отыграли недостаточно времени")
				return
			end

			if self.Quest:GetVIP() && !LocalPlayer():IsVIP() then
				self:SetDisabled(true)
				self:SetText("Этот квест доступен только для VIP игроков")
				return
			end

			if !self.Quest:IsAllowed(LocalPlayer()) then
				self:SetDisabled(true)
				self:SetText("У вас не подходящая профессия")
				return
			end

			for k, v in pairs(self.Quest:GetRequireCompletion()) do
				if !ply:GetQuestCooldown(v) then
					self:SetDisabled(true)
					self:SetText("Предыдущие квесты не выполнены")
					return
				end
			end
		end
	end, self.InfoPanel)


	self.Info = ui.Create('ui_panel', self.InfoPanel)
	self.Info.Paint = function(s, w, h)
		if self.Quest then
			--print(self.Quest:GetID(), self.last)
			if self.last != self.Quest:GetID() then
				self.last = self.Quest:GetID()
				--print(1, self.Quest:BuildDesc())
				self.text = string.Wrap('rp.ui.20', self.Quest:BuildDesc(), w - 10)
				s:SetTall(#self.text * 30 + 50)
				self.InfoPanel:ScrollTo(0)
			end
			draw.OutlinedBox(0, 0, w, 50, self.Quest:GetColor(), ui.col.Outline)
			draw.SimpleTextOutlined(self.Quest:GetName(), 'rp.ui.24', w * 0.5, 25, ui.col.White, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, ui.col.Black)
		
			for k, v in ipairs(self.text) do
				draw.SimpleTextOutlined(v, 'rp.ui.20', 5, 35 + (k * 26), ui.col.White, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, ui.col.Black)
			end
		else	
			self.text = string.Wrap('rp.ui.20', self.QuestNPC.desc, w - 10)
			s:SetTall(#self.text * 30 + 50)
			draw.OutlinedBox(0, 0, w, 50, self.QuestNPC.color, ui.col.Outline)
			draw.SimpleTextOutlined(self.QuestNPC.name, 'rp.ui.24', w * 0.5, 25, ui.col.White, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, ui.col.Black)

			for k, v in ipairs(self.text) do
				draw.SimpleTextOutlined(v, 'rp.ui.20', 5, 35 + (k * 26), ui.col.White, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, ui.col.Black)
			end
		end
	end
	self.InfoPanel:AddItem(self.Info)
end

function PANEL:PerformLayout()
	self.QuestList:SetPos(5, 5)
	self.QuestList:SetSize(self:GetWide() * 0.4 - 7.5, self:GetTall() - 10)
	self.QuestList:SetSpacing(1)
	self.InfoPanel:SetPos(self:GetWide() * 0.4 + 2.5, 5)
	self.InfoPanel:SetSize(self:GetWide() * 0.6 - 7.5, self:GetTall() - 10)
	self.InfoPanel:SetSpacing(1)
end

vgui.Register('rp_questlist', PANEL, 'Panel')