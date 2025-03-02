PANEL = {}
function PANEL:Init()
	self:SetSize(0, 50)
	
	self.abutton = ui.Create('DButton', self)
		self.abutton:SetSize(200, 30)
		self.abutton:SetPos(15, 10)
		self.abutton.DoClick = function()
			self:GetParent():GetParent():GetParent():RedoList(self.abutton.alliance)
		end
		self.abutton.Paint = function(btn, w, h)
			derma.SkinHook('Paint', 'TabButton', btn, w, h)
		end
end

function PANEL:SetAlliance(alliance, current)
	local allc = rp.Capture.Alliances[alliance]
	if not allc then return end
	
	self.abutton.alliance = alliance
	self.abutton:SetText(allc.printName)
	
	local state = rp.ConjGet(alliance, current)
	local color = rp.ConjGetColor(state)
	local sname = rp.ConjGetName(state)
	
	if LocalPlayer():GetAlliance() == current and LocalPlayer():GetJobTable().canDiplomacy then
		self.sbutton = ui.Create('DButton', self)
			self.sbutton:SetSize(200, 30)
			self.sbutton.DoClick = function()
				local m 	= ui.DermaMenu(p)
				local state	= rp.ConjGet(alliance, current)
				
				local valid_states = (state == CONJ_NEUTRAL) and {CONJ_WAR, CONJ_UNION} or {CONJ_NEUTRAL}
				
				for k, v in ipairs(valid_states) do
					if not rp.ConjIsInvalid(alliance, current, v) then
						m:AddOption(rp.ConjGetName(v), function()
							rp.RunCommand('conjunction', alliance, v)
							self:GetParent():GetParent():GetParent():GetParent():GetParent():Close()
						end)
					end
				end
				m:Open()
			end
			self.sbutton:SetText(sname)
			self.sbutton.Paint = function(btn, w, h)
				derma.SkinHook('Paint', 'TabButton', btn, w, h)
				self.sbutton:SetTextColor(color)
			end
	else
		self.sname = ui.Create('DLabel', self)
			self.sname:SetSize(400, 50)
			self.sname:SetFont("rp.ui.22")
			self.sname:SetContentAlignment(6)
			self.sname:SetTextColor(color)
			self.sname:SetText(sname)
	end
end

function PANEL:PerformLayout()
	if self.sname then
		self.sname:SetPos(self:GetWide() - 420)
	else
		self.sbutton:SetPos(self:GetWide() - 220, 10)
	end
end

vgui.Register('rp_diplomacy_line', PANEL, 'DPanel')


PANEL = {}
function PANEL:Init()
	self.List = ui.Create('ui_listview', self)
	self.List.Paint = function() end
	
	self.info1 = ui.Create('DLabel', self)
		self.info1:SetSize(600, 50)
		self.info1:SetFont("rp.ui.30")
		self.info1:SetContentAlignment(5)
		
	self.info2 = ui.Create('DLabel', self)
		self.info2:SetSize(600, 30)
		self.info2:SetText("Инициализировать смену отношений может только дипломатически уполномоченное лицо")
		self.info2:SetFont("rp.ui.15")
		
	self.info3 = ui.Create('DLabel', self)
		self.info3:SetSize(600, 30)
		self.info3:SetFont("rp.ui.18")
		
	self.info4 = ui.Create('DLabel', self)
		self.info4:SetSize(560, 100)
		self.info4:SetFont("rp.ui.22")
		self.info4:SetContentAlignment(5)
		self.info4:SetAutoStretchVertical(true)
		self.info4:SetWrap(true)
	
end

function PANEL:RedoList(alliance) 
	alliance = alliance or math.random(1, #rp.Capture.Alliances)
	local allc = rp.Capture.Alliances[alliance]
	
	self.alliance = alliance
	
	for k, v in ipairs(self.List.lines or {}) do
		v:Remove()
	end
	
	self.info1:SetText("Отношения " .. allc.printName .. (alliance == LocalPlayer():GetAlliance() and ' (вы)' or ''))
	self.List.lines = {}
	
	for i = 1, #rp.Capture.Alliances do
		if i == alliance then continue end
		
		local citem = ui.Create('rp_diplomacy_line')
		citem:SetAlliance(i, alliance)
		
		table.insert(self.List.lines, citem)
		self.List:AddItem(citem)
	end
	
	--self:DrawWarButton()
	self.List:SetSize(self:GetWide() - 10, self:GetTall() - 200)
	
	self.info3:SetText(allc.printName .. " контролируют:")
	
	local ps = ''
	
	for k, v in ipairs(rp.Capture.Points) do
		if not v.isOrg and v.owner == alliance then
			local bonuses = rp.Capture.GetPointBonuses(v)
			ps = ps .. (string.len(ps) > 0 and ', ' or '') .. v.printName .. ' (' .. bonuses .. ')'
		end
	end
	
	self.info4:SetText(ps == '' and "Подконтрольных точек нет" or ps)
end

function PANEL:PerformLayout()
	local redone
	
	if self.preselect then
		self:RedoList(self.preselect)
		self.preselect = nil
		
		redone = true
	end
	
	if self.List:GetPos() ~= 0 then return end
	
	if not redone then
		self:RedoList(LocalPlayer():GetJobTable().canDiplomacy and LocalPlayer():GetAlliance())
	end
	
	self.List:SetPos(5, 50)
	
	--self:DrawWarButton()
	self.List:SetSize(self:GetWide() - 10, self:GetTall() - 200)
	
	self.info1:SetPos(5, 5)
	self.info1:SetSize(self:GetWide() - 10, 40)
	
	self.info2:SetPos(15, self:GetTall() - 35)
	
	self.info3:SetPos(45, self:GetTall() - 135)
	
	self.info4:SetPos(33, self:GetTall() - 105)
end

vgui.Register('rp_diplomacy', PANEL, 'Panel')
hook.Add('PopulateF4Tabs', function(tabs)
	if #rp.Capture.Alliances ~= 0 then
		tabs:AddTab('Дипломатия', ui.Create('rp_diplomacy'))
	end
end)


net.Receive('rp.ConjSendAll', function()
	for i = 1, #rp.Capture.Alliances - 1 do
		rp.Capture.Alliances[i].conjes = rp.Capture.Alliances[i].conjes or {}
		
		for j = i + 1, #rp.Capture.Alliances do
			rp.Capture.Alliances[j].conjes = rp.Capture.Alliances[j].conjes or {}
			
			local state = net.ReadUInt(2)
			
			rp.Capture.Alliances[i].conjes[j] = state
			rp.Capture.Alliances[j].conjes[i] = state
		end
	end
end)
net.Start('rp.ConjSendAll')
net.SendToServer()


net.Receive('rp.ConjChange', function()
	local alliance1 = net.ReadUInt(8)
	local alliance2 = net.ReadUInt(8)
	
	local allc1 = rp.Capture.Alliances[alliance1]
	local allc2 = rp.Capture.Alliances[alliance2]
	local state = net.ReadUInt(2)
	
	if not allc1 or not allc2 then return end
	--print('Setting', allc1.printName, allc2.printName, state)
	
	allc1.conjes = allc1.conjes or {}
	allc2.conjes = allc2.conjes or {}
	
	allc1.conjes[allc2.id] = state
	allc2.conjes[allc1.id] = state
end)