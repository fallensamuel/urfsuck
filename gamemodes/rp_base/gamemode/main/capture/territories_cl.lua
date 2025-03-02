
local function getOwnerName(location)
	return location.isOrg and location.owner or rp.Capture.Alliances[location.owner] and rp.Capture.Alliances[location.owner].printName or 'Неизвестно'
end

PANEL = {}

function PANEL:Init()
	self:SetSize(0, 66)
	
	self.bonuses = ui.Create('DLabel', self)
		self.bonuses:SetPos(15, 28)
		self.bonuses:SetSize(0, 50)
		self.bonuses:SetFont("rp.ui.15")
		self.bonuses:SetText("")
end

function PANEL:RedoOwner()
	local owner = self.owner_btn or self.owner_str
	owner:SetText(getOwnerName(self.assigned))
end

function PANEL:Preproccess(location, parent)
	self.assigned = location
	self.parent = parent
	
	if location.isOrg then 
		self.owner_str = ui.Create('DLabel', self)
			self.owner_str:SetSize(400, 50)
			self.owner_str:SetFont("rp.ui.22")
			self.owner_str:SetContentAlignment(6)
			self.owner_str:SetText("")
	else
		self.owner_btn = ui.Create('DButton', self)
			self.owner_btn:SetSize(200, 30)
			self.owner_btn.DoClick = function()
				parent:GetParent():SetActiveTab(parent.diplomacy_tab.ID)
				parent.diplomacy_tab.Tab.preselect = location.owner
			end
			self.owner_btn:SetText("")
			self.owner_btn.Paint = function(btn, w, h)
				derma.SkinHook('Paint', 'TabButton', btn, w, h)
			end
	end
	
	if not location.isWar and (location.isOrg and LocalPlayer():GetOrg() and LocalPlayer():GetOrg() == location.owner and LocalPlayer():GetOrgData().CanDiplomacy or not location.isOrg and LocalPlayer():GetAlliance() == location.owner and LocalPlayer():GetJobTable().canDiplomacy) then
		self.location = ui.Create('DButton', self)
		
		self.location.DoClick = function()
			local m = ui.DermaMenu(parent)
			
			for _, v in pairs(location.isOrg and parent.orgs or parent.alliances) do
				m:AddOption(location.isOrg and v or rp.Capture.Alliances[v].printName, function()
					rp.RunCommand('givepoint', location.id, v)
					
					if location.isOrg then 
						self.owner_str:SetText(v)
					else
						self.owner_btn:SetText(rp.Capture.Alliances[v].printName)
					end
					
					self.location:Remove()
					self.location = ui.Create('DLabel', self)
					self.location:SetSize(200, 30)
					self.location:SetPos(15, 10)
					
					self.location:SetText(location.printName)
				end)
			end
			
			m:Open()
		end
		
		self.location.Paint = function(btn, w, h)
			derma.SkinHook('Paint', 'TabButton', btn, w, h)
		end
	else
		self.location = ui.Create('DLabel', self)
	end
	
	self.location:SetSize(200, 30)
	self.location:SetPos(15, 10)
	
	self.location:SetText(location.printName)
	self.bonuses:SetText(rp.Capture.GetPointBonuses(location))
end

function PANEL:PerformLayout()
	if self.owner_str then
		self.owner_str:SetPos(self:GetWide() - 420)
	else
		self.owner_btn:SetPos(self:GetWide() - 220, 10)
	end
	
	self.bonuses:SetWidth(self:GetWide() - 20)
end

vgui.Register('rp_territory_line', PANEL, 'DPanel')


PANEL = {}

function PANEL:Init()
	self.draw_alliances = #rp.Capture.Alliances ~= 0
	
	if self.draw_alliances then
		self.title1 = ui.Create('DLabel', self)
			self.title1:SetSize(0, 50)
			self.title1:SetText("Стратегические обьекты")
			self.title1:SetFont("rp.ui.28")
			self.title1:SetContentAlignment(5)
		
		self.list1 = ui.Create('ui_listview', self)
		self.list1.Paint = function() end
	end
	
	self.title2 = ui.Create('DLabel', self)
		self.title2:SetSize(0, 50)
		self.title2:SetText("Локальные обьекты")
		self.title2:SetFont("rp.ui.28")
		self.title2:SetContentAlignment(5)
		
	self.list2 = ui.Create('ui_listview', self)
	self.list2.Paint = function() end
	
	self.info = ui.Create('DLabel', self)
		self.info:SetSize(600, 35)
		self.info:SetText(((#rp.Capture.Alliances ~= 0) and "Передать стратегический обьект могут только уполномоченные лица фракции" or "") .. "\nПередать локальный обьект могут только уполномоченные члены организации")
		self.info:SetFont("rp.ui.15")
		
	
	self.locs = {}
	
	self.alliances = {}
	self.orgs = {}
	
	if LocalPlayer():GetAlliance() then
		for _, v in pairs(rp.Capture.Alliances) do
			if LocalPlayer():GetAlliance() ~= v.id --[[and rp.ConjGet(v, LocalPlayer():GetAlliance()) ~= CONJ_WAR]] then
				self.alliances[#self.alliances + 1] = v.id
			end
		end
	end
	
	if LocalPlayer():GetOrg() then
		for _, v in pairs(player.GetAll()) do
			if v:GetOrg() and v:GetOrg() ~= LocalPlayer():GetOrg() then
				self.orgs[#self.orgs + 1] = v:GetOrg()
			end
		end
	end
	
	for _, v in pairs(rp.Capture.Points) do
		local item = ui.Create('rp_territory_line')
		item:Preproccess(v, self)
		
		table.insert(self.locs, item)
		
		if v.isOrg then 
			self.list2:AddItem(item)
		elseif self.draw_alliances then
			self.list1:AddItem(item)
		end
	end
end

function PANEL:PerformLayout()
	if self.list2:GetPos() ~= 0 then return end
	
	for _, v in ipairs(self:GetParent().Buttons) do
		if v:GetText() == 'Дипломатия' then
			self.diplomacy_tab = v
			break
		end
	end
	
	if self.draw_alliances then
		self.title1:SetPos(5, 5)
		self.list1:SetPos(5, 50)
		self.title1:SetSize(self:GetWide() - 10, 40)
		self.list1:SetSize(self:GetWide() - 10, self:GetTall() / 2 - 90)
		
		self.title2:SetPos(5, self:GetTall() / 2 - 20)
		self.list2:SetPos(5, self:GetTall() / 2 + 25)
		self.title2:SetSize(self:GetWide() - 10, 40)
		self.list2:SetSize(self:GetWide() - 10, self:GetTall() / 2 - 90)
	else
		self.title2:SetPos(5, 5)
		self.list2:SetPos(5, 50)
		self.title2:SetSize(self:GetWide() - 10, 40)
		self.list2:SetSize(self:GetWide() - 10, self:GetTall() - 90)
	end
	
	self.info:SetPos(15, self:GetTall() - 45)
	
	for _, v in ipairs(self.locs) do
		v:RedoOwner()
	end
end

vgui.Register('rp_territory', PANEL, 'Panel')
hook.Add('PopulateF4Tabs', function(tabs)
	tabs:AddTab('Территории', ui.Create('rp_territory'))
end)
