local PANEL = {}

function PANEL:Init()
	self:SetText('')
	self.Model = ui.Create('rp_modelicon', self)
end

function PANEL:PerformLayout()
	self.Model:SetPos(0, 0)
	self.Model:SetSize(50, 50)
end

function PANEL:PaintOver(w, h)
	draw.SimpleTextOutlined(self.Title, 'rp.ui.22', 60, h * .5, rp.col.White, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, rp.col.Black)

	if self.unlockTime &&  self.unlockTime > LocalPlayer():GetPlayTime() then
		draw.SimpleTextOutlined(ba.str.FormatTime(self.unlockTime-LocalPlayer():GetPlayTime()), 'rp.ui.22', w - 10, h * .5, rp.col.White, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, 1, rp.col.Black)
	else
		draw.SimpleTextOutlined(self.Price, 'rp.ui.22', w - 10, h * .5, rp.col.White, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, 1, rp.col.Black)
	end
end

function PANEL:SetInfo(model, title, price, doclick, time)
	local discounted_price;

	discounted_price = LocalPlayer().GetAttributeAmount and (LocalPlayer():GetAttributeAmount('trader') and math.ceil(price * (1 - LocalPlayer():GetAttributeAmount('trader') / 100)) or LocalPlayer():GetAttributeAmount('italiane') and math.ceil(price * (1 - (0.25 * LocalPlayer():GetAttributeAmount('italiane') / 100)))) or price
	
	self.Model:SetModel(model)
	self.Title = title
	self.Price = rp.FormatMoney(discounted_price)
	self.DoClick = doclick
	self.Model.DoClick = doclick
	if time then
		self:SetunlockTime(time)
	end
end

function PANEL:SetunlockTime(time)
	self.unlockTime = time
end

vgui.Register('rp_shopbutton', PANEL, 'DButton')
PANEL = {}

function PANEL:PerformLayout()
	local c = 0
	local even = false

	for k, v in ipairs(self:GetChildren()) do
		v:SetPos(even and (self:GetWide() * .5) or 0, c * 49)
		v:SetSize(self:GetWide() * .5 + 1, 50)

		if even then
			c = c + 1
		end

		even = (not even)
	end
end

function PANEL:AddItem(model, title, price, doclick, time)
	local btn = ui.Create('rp_shopbutton', self)
	btn:SetInfo(model, title, price, doclick)
	if time then
		btn:SetunlockTime(time)
	end
	self:SetTall(math.ceil(#self:GetChildren() * .5) * 49 + 1)
end

vgui.Register('rp_shopcatagory', PANEL, 'Panel')
PANEL = {}

function PANEL:Init()
	local cat
	self.Cats = {}
	self.List = ui.Create('ui_listview', self)
	self.List.Paint = function() end
	self.List:AddSpacer('Патроны'):SetTall(25)
	cat = ui.Create('rp_shopcatagory')

	for k, v in ipairs(rp.ammoTypes) do
		if not v.price then continue end
		cat:AddItem(v.model, v.name, v.price, function()
			rp.RunCommand('buyammo', v.ammoType)
		end)
	end

	self.List:AddItem(cat)

	local foods = {}

	for k, v in ipairs(rp.Foods) do
		if v.price and v.allowed[LocalPlayer():Team()] then
			table.insert(foods, v)
		end
	end

	if next(foods) then
		self.List:AddSpacer('Еда'):SetTall(25)
		local cat = ui.Create('rp_shopcatagory') -- TODO: FIX

		for k, v in ipairs(foods) do
			cat:AddItem(v.model, v.name, v.price, function()
				rp.RunCommand('buyfood', v.name)
			end)
		end

		self.List:AddItem(cat)
	end

	for k, v in ipairs(rp.shipments) do
		if v.price and (v.allowed[LocalPlayer():Team()] == true) && !v.noship then
			if (not self.Cats['Ящики']) then
				self.List:AddSpacer('Ящики'):SetTall(25)
				self.Cats['Ящики'] = true
				cat = ui.Create('rp_shopcatagory')
			end

			cat:AddItem(v.model, v.name, v.price, function()
				rp.RunCommand('buyshipment', v.name)
			end)
		end
	end

	self.List:AddItem(cat)

	for k, v in ipairs(rp.entities) do
		local show = v.allowed[LocalPlayer():Team()] == true

		if (show and v.customCheck) then
			show = v.customCheck(LocalPlayer())
		end

		if v.price and (show) then
			if (not self.Cats['Предметы']) then
				self.List:AddSpacer('Предметы'):SetTall(25)
				self.Cats['Предметы'] = true
				cat = ui.Create('rp_shopcatagory')
			end
			cat:AddItem(v.model, v.name, v.pricesep or v.price, function()
				rp.RunCommand(v.cmd:sub(2))
			end, v.unlockTime)
		end
	end

	for k, v in ipairs(rp.shipments) do
		if v.price and (v.allowed[LocalPlayer():Team()] == true) && v.seperate then
			if (not self.Cats['Предметы']) then
				self.List:AddSpacer('Предметы'):SetTall(25)
				self.Cats['Предметы'] = true
				cat = ui.Create('rp_shopcatagory')
			end

			cat:AddItem(v.model, v.name, v.pricesep, function()
				rp.RunCommand('buy', v.name)
			end)
		end
	end

	self.List:AddItem(cat)
end

function PANEL:PerformLayout()
	self.List:SetPos(5, 5)
	self.List:SetSize(self:GetWide() - 10, self:GetTall() - 10)
end

vgui.Register('rp_shoplist', PANEL, 'Panel')