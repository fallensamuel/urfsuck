local PANEL = {}

function PANEL:Init()
	self:SetText('')
	self:SetTall(50)
	self.Model = ui.Create('rp_modelicon', self)

	self.Model.DoClick = function(s)
		s.DoClick(self)
	end
end

function PANEL:Paint(w, h)
	draw.OutlinedBox(0, 0, w, h, self.job.color, ui.col.Outline)

	if self:IsHovered() then
		draw.OutlinedBox(0, 0, w, h, self.job.color, ui.col.Hover)
	end

	local x = 60

	if self.job.vip then
		x = x + draw.SimpleTextOutlined('[VIP]', 'rp.ui.22', x, h * 0.5, ui.col.Orange, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, ui.col.Black) + 5
	end

	draw.SimpleTextOutlined(self.job.name, 'rp.ui.22', x, h * 0.5, ui.col.White, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, ui.col.Black)

	if self.job.unlockTime && self.job.unlockTime > LocalPlayer():GetPlayTime() then
		draw.SimpleTextOutlined(ba.str.FormatTime(self.job.unlockTime-LocalPlayer():GetPlayTime()), 'rp.ui.22', w - 10, h * 0.5, ui.col.White, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, 1, ui.col.Black)
	elseif !LocalPlayer():TeamUnlocked(self.job) then
		local SkillBonus = 0;

		if (LocalPlayer().GetAttributeAmount and LocalPlayer():GetAttributeAmount('pro') and self.job.unlockPrice) then
			SkillBonus = math.ceil(self.job.unlockPrice * LocalPlayer():GetAttributeAmount('pro') / 500);
		end

		if (LocalPlayer().GetAttributeAmount and LocalPlayer():GetAttributeAmount('jew') and self.job.unlockPrice) then
			SkillBonus = math.ceil(self.job.unlockPrice * (0.25 * LocalPlayer():GetAttributeAmount('jew') / 100));
		end

		draw.SimpleTextOutlined(rp.FormatMoney(self.job.unlockPrice - SkillBonus), 'rp.ui.22', w - 10, h * 0.5, ui.col.White, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, 1, ui.col.Black)
	elseif self.job.max ~= 0 then
		draw.SimpleTextOutlined(#team.GetPlayers(self.job.team) .. '/' .. ((self.job.max == 0) and 'Unlimited' or self.job.max), 'rp.ui.22', w - 10, h * 0.5, ui.col.White, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, 1, ui.col.Black)
	end
end

function PANEL:PerformLayout()
	self.Model:SetPos(0, 0)
	self.Model:SetSize(50, 50)
end

function PANEL:OnCursorEntered()
	self.Parent.job = self.job
	self.Parent.ModelKey = cvar.GetValue('TeamModel' .. self.job.name) or 1
	self.Preview:SetModel(istable(self.job.model) and self.job.model[self.Parent.ModelKey] or self.job.model)
	if self.job.SetBodygroups then
		self.job.SetBodygroups(self.Preview.Entity)
	end
	self.Preview:FindSequence()
end

function PANEL:DoClick()

	if self.Parent.DoClick then
		self.Parent.DoClick(self)

		return
	end

	if !LocalPlayer():CanTeam(self.job) then
		if self.job.unlockTime && self.job.unlockTime > LocalPlayer():GetPlayTime() then
			return rp.NotifyTerm(NOTIFY_ERROR, 'NotEnoughTime')
		end

		if !LocalPlayer():TeamUnlocked(self.job) then
			local SkillBonus = 0;

			if (LocalPlayer().GetAttributeAmount and LocalPlayer():GetAttributeAmount('pro') and self.job.unlockPrice) then
				--SkillBonus = math.ceil(self.job.unlockPrice * (1 - LocalPlayer():GetAttributeAmount('pro') / 500));
				SkillBonus = math.ceil(self.job.unlockPrice * LocalPlayer():GetAttributeAmount('pro') / 500);
			end

			if (LocalPlayer().GetAttributeAmount and LocalPlayer():GetAttributeAmount('jew') and self.job.unlockPrice) then
				--SkillBonus = math.ceil(self.job.unlockPrice * (1 - LocalPlayer():GetAttributeAmount('jew') / 250));
				--math.ceil(tblEnt.price * (1 - (0.25 * ply:GetAttributeAmount('italiane') / 100)))
				SkillBonus = math.ceil(self.job.unlockPrice * (0.25 * LocalPlayer():GetAttributeAmount('jew') / 100));
			end

			if !LocalPlayer():CanAfford(self.job.unlockPrice - SkillBonus) then
				return rp.NotifyTerm(NOTIFY_ERROR, 'CannotAfford')
			else
				ui.Request(rp.GetTerm('ConfirmAction'), rp.GetTerm('UnlockTeam', self.job.name, rp.FormatMoney(self.job.unlockPrice - SkillBonus)), function(b)
					if b then
						self.Parent:GetParent():Remove()
						rp.UnlockTeam(self.job.team)
					end
				end)
				return
			end
		end
	end

	--if self.job.vote then
	rp.RunCommand('model', self.job.model[self.Parent.ModelKey])
	rp.ChangeTeam(self.job.team)
	--	rp.RunCommand('vote' .. self.job.command)
	--else
	--	rp.RunCommand(self.job.command)
	--end
end

function PANEL:SetJob(job)
	self.job = job
	self.job.color = Color(job.color.r, job.color.g, job.color.b, 125)
	self.ModelPath = istable(job.model) and job.model[1] or job.model
	self.Model:SetModel(self.ModelPath)
end

vgui.Register('rp_jobbutton', PANEL, 'Button')
PANEL = {}

function PANEL:Init()
	self:BaseInit()

	for k, v in ipairs(rp.teams) do
		if ((not v.customCheck) or v.customCheck(LocalPlayer())) and (k ~= LocalPlayer():Team()) then
			local btn = ui.Create('rp_jobbutton')
			btn:SetJob(v)
			btn.Parent = self
			btn.Preview = self.Model
			self.JobList:AddItem(btn)
		end
	end
end

function PANEL:BaseInit()
	self.job = rp.teams[1]
	self.job.color = Color(self.job.color.r, self.job.color.g, self.job.color.b, 125)
	self.ModelKey = cvar.GetValue('TeamModel' .. self.job.name) or 1
	rp.RunCommand('model', self.job.model[self.ModelKey])
	self.JobList = ui.Create('ui_scrollpanel', self)

	self.InfoPanel = ui.Create('ui_scrollpanel', self)

	self.Info = ui.Create('ui_panel', self.InfoPanel)
	self.Info.Paint = function(s, w, h)
		if self.last != self.job.team then
			self.last = self.job.team
			self.text = string.Wrap('rp.ui.20', self.job.description, w - 10)
			s:SetTall(#self.text * 30 + 50)
			self.InfoPanel:ScrollTo(0)
		end
		draw.OutlinedBox(0, 0, w, 50, self.job.color, ui.col.Outline)
		draw.SimpleTextOutlined(self.job.name, 'rp.ui.24', w * 0.5, 25, ui.col.White, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, ui.col.Black)

		for k, v in ipairs(self.text) do
			draw.SimpleTextOutlined(v, 'rp.ui.20', 5, 35 + (k * 26), ui.col.White, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, ui.col.Black)
		end
	end
	self.InfoPanel:AddItem(self.Info)

	self.Model = ui.Create('rp_playerpreview', self)
	self.Model:SetFOV(50)
	self.Model:SetModel(istable(self.job.model) and self.job.model[self.ModelKey] or self.job.model)
	
	self.BackModel = ui.Create('DButton', self)
	self.BackModel:SetText('<')

	self.BackModel.Think = function(s)
		if (not istable(self.job.model)) or (#self.job.model == 1) or (self.ModelKey <= 1) then
			s:SetDisabled(true)
		else
			s:SetDisabled(false)
		end
	end

	self.BackModel.DoClick = function()
		self.ModelKey = self.ModelKey - 1
		self.Model:SetModel(self.job.model[self.ModelKey])
		if self.job.SetBodygroups then
			self.job.SetBodygroups(self.Model.Entity)
		end
		cvar.SetValue('TeamModel' .. self.job.name, self.ModelKey)
	end

	self.NextModel = ui.Create('DButton', self)
	self.NextModel:SetText('>')

	self.NextModel.Think = function(s)
		if (not istable(self.job.model)) or (#self.job.model == 1) or (self.ModelKey >= #self.job.model) then
			s:SetDisabled(true)
		else
			s:SetDisabled(false)
		end
	end

	self.NextModel.DoClick = function()
		self.ModelKey = self.ModelKey + 1
		self.Model:SetModel(self.job.model[self.ModelKey])
		if self.job.SetBodygroups then
			self.job.SetBodygroups(self.Model.Entity)
		end
		cvar.SetValue('TeamModel' .. self.job.name, self.ModelKey)
	end
end

function PANEL:PerformLayout()
	self.JobList:SetPos(5, 5)
	self.JobList:SetSize(self:GetWide() * 0.5 - 7.5, self:GetTall() - 10)
	self.JobList:SetSpacing(1)
	self.InfoPanel:SetPos(self:GetWide() * 0.5 + 2.5, 5)
	self.InfoPanel:SetSize(self:GetWide() * 0.5 - 7.5, self:GetTall() * .5 - 10)
	self.InfoPanel:SetSpacing(1)
	--self.Info:SetPos(self:GetWide() * 0.5 + 2.5, 5)
	--self.Info:SetSize(self:GetWide() * 0.5 - 7.5, self:GetTall())
	self.Model:SetPos(self:GetWide() * 0.5 + 2.5, self:GetTall() * 0.5)
	self.Model:SetSize(self:GetWide() * 0.5 - 7.5, self:GetTall() * 0.5 - 35)
	self.BackModel:SetPos(self:GetWide() * 0.75 - 27.5, self:GetTall() - 30)
	self.BackModel:SetSize(25, 25)
	self.NextModel:SetPos(self:GetWide() * 0.75 + 2.5, self:GetTall() - 30)
	self.NextModel:SetSize(25, 25)
end

--vgui.Register('rp_jobslist', PANEL, 'Panel')

local PANEL = PANEL // fuck parenting without override

function PANEL:Init()
	self:BaseInit()
end

function PANEL:AddJob(k)
	v = rp.teams[k]
	if ((not v.customCheck) or v.customCheck(LocalPlayer())) then
		local btn = ui.Create('rp_jobbutton')
		btn:SetJob(v)
		btn.Parent = self
		btn.Preview = self.Model
		btn:SetSize(self:GetWide() * 0.5 - 7.5, 50)
		self.JobList:AddItem(btn)
	end
end

function PANEL:SetFaction(i)
	if i != 1 then
		self:AddJob(rp.GetDefaultTeam(LocalPlayer()))
	end
	for k, v in ipairs(rp.Factions[i].jobsMap) do
		self:AddJob(v)
	end
end

--vgui.Register('rp_faction_jobslist', PANEL, 'Panel')