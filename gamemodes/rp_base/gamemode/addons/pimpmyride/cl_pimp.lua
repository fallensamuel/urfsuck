-- "gamemodes\\rp_base\\gamemode\\addons\\pimpmyride\\cl_pimp.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
PIMP = PIMP or {}

local meh --cl scene
local oldvars --cl cache
local metadata

--[[UI]]

local font, fontbig, fontsmall = "GlassUIFont", "GlassUIFontBIG", "GlassUIFontSMALL"
local color_white = Color(255, 255, 255)

surface.CreateFont(font, {
	font = "Roboto Lt",
	weight = 250,
	size = 24,
	antialias = true,
	extended = true
})

surface.CreateFont(fontbig, {
	font = "Roboto",
	weight = 250,
	size = 46,
	antialias = true,
	extended = true
})

surface.CreateFont(fontsmall, {
	font = "Roboto Lt",
	weight = 250,
	size = 16,
	antialias = true,
	extended = true
})

--[[UI Func]]

local function __dontpaint() end

local function __onremovemenu(self)
	hook.Remove("CalcView", "pview")
	hook.Remove("CalcViewModelView", "phidewpn")
	hook.Remove("HUDShouldDraw", "phidehud")

	self.slider:Remove()

	local ent = PIMP.CurrentEntity
	if !PIMP.Success and oldvars then
		for id, b in pairs(oldvars[2]) do
			ent:SetBodygroup(id, b)
		end
		ent:SetSkin(oldvars[3])
		ent:SetColor(oldvars[4])
		ent.CachedTireSmokeColor = oldvars[5]
		ent.CachedBooletproof = oldvars[6]
		ent.CachedWheels = oldvars[7]
		ent.CachedSuspension = oldvars[8]
	end

	if meh then
		local f = meh.StopScene
		if f then f(meh) end
	end

	oldvars = nil
	meh = nil
end

local function __sendrawdata(data)
	local raw = pon.encode(data)
	local out = util.Compress(raw)
	local l = out:len()

	net.Start("pimp_my_ride_request")
	net.WriteUInt(l, 8)
	net.WriteData(out, l)
	net.SendToServer()
end

local function __sendrawdatacall(data)
	local out = util.Compress(data)
	local l = out:len()

	net.Start("pimp_my_ride_call")
	net.WriteUInt(l, 8)
	net.WriteData(out, l)
	net.SendToServer()
end

local function __getprice()
	local price = 0
	local ent = PIMP.CurrentEntity

	for id, b in pairs(oldvars[2]) do
		if ent:GetBodygroup(id) ~= b then price = price + 100 end
	end

	local t = metadata

	if ent:GetSkin() ~= oldvars[3] then price = price + 100 end
	if ent.CachedColor and ent.CachedColor ~= ent:GetNWInt("Color", -1) then price = price + 100 end
	if ent.CachedBooletproof and ent.CachedBooletproof ~= ent:GetBulletProofTires() then price = price + 100 end
	if ent.CachedWheels and ent.CachedWheels ~= ent:GetNWInt("Wheels") then price = price + 100 end
	if ent.CachedSuspension and ent.CachedSuspension ~= ent:GetNWInt("Suspension") then price = price + 100 end
	if ent.CachedArmor and ent.CachedArmor ~= ent:GetNWInt("Armor") then price = price + metadata.healthboost[ent.CachedArmor].price end

	return price
end


local function __applybuttonthink(self)
	self.nthink = self.nthink or 0
	if SysTime() < self.nthink then return end
	self.nthink = SysTime() + 1

	local price = __getprice() or 0
	self:SetText(translates and translates.Get("Купить: %i$", price) or ("Купить: " .. price .. "$"))
end

local function __accept(self)
	local ent = PIMP.CurrentEntity

	local vars = {}
	vars[1] = ent
	vars[2] = {}
	vars[3] = ent:GetSkin()
	vars[4] = ent.CachedColor
	vars[5] = ent.CachedBooletproof
	vars[6] = ent.CachedWheels
	vars[7] = ent.CachedSuspension
	vars[8] = ent.CachedArmor

	for k, data in pairs(ent:GetBodyGroups()) do
		local id = data.id
		vars[2][id] = ent:GetBodygroup(id)
	end

	--PrintTable(vars)

	__sendrawdata(vars)

	local wait_txt = translates and translates.Get("Подождите") or "Подождите"
	
	self:SetText(wait_txt)
	self.DoClick = __dontpaint
	PIMP.Success = true

	function self:Think()
		local v = ("..."):sub(1, (RealTime() * 2) % 4)
		self:SetText(wait_txt .. v)
	end

	timer.Simple(3.33, function()
		if IsValid(ent) then
			oldvars = {}
			oldvars[1] = ent:GetNWString("VehicleName")
			oldvars[2] = {}
			oldvars[3] = ent:GetSkin()
			oldvars[4] = ent:GetNWInt("Color")
			oldvars[5] = ent:GetBulletProofTires()
			oldvars[6] = ent:GetNWInt("Wheels")
			oldvars[7] = ent:GetNWInt("Suspension")
			oldvars[8] = ent:GetNWInt("Armor")
		end
		
		PIMP.SaveCar(ent)

		if !IsValid(self) then return end
		self.Think = __dontpaint
		self.DoClick = __accept
		self:SetText(translates and translates.Get("Купить") or "Купить")
		self.Think = __applybuttonthink
	end)
end

--[[]]

local pui = {}

pui.bodygroups = {text = translates and translates.Get("Кузовные работы") or "Кузовные работы", func = function(self, t)
	local ent = PIMP.CurrentEntity

	local price = vgui.Create("DLabel", self.Header)
	price:SetFont(fontsmall)
	price:SetText("0$")
	price:Dock(BOTTOM)
	price:SetContentAlignment(6)

	function price:ReCount()
		local val = 0
		for id, b in pairs(oldvars[2]) do
			if ent:GetBodygroup(id) ~= b then val = val + 100 end
		end
		price:SetText(val .. "$")
	end

	for k, bgs in pairs(t) do
		local p = vgui.Create("DLabel", self)
		p:SetFont(font)
		p:SetText(ent:GetBodygroupName(k) or ((translates and translates.Get('Часть') or 'Часть') .. "-" .. k))
		p:Dock(TOP)
		--p:SetDrawBackground(false)
		--l:SetDrawBackground(false)
		for n, g in pairs(bgs) do
			local b = vgui.Create("GButton", self)
			b:SetText((g == 0) and (translates and translates.Get('Нет') or 'Нет') or ((translates and translates.Get('Вариант') or 'Вариант') .. " " .. g))
			b:SetTextInset(10, 1)
			b:Dock(TOP)

			function b:DoClick() 
				ent:SetBodygroup(k, g) 
				price:ReCount()
			end
		end
	end
end}

pui.skins = {text = translates and translates.Get("Покрасочные работы/Скин") or "Покрасочные работы/Скин", func = function(self, t)
	local ent = PIMP.CurrentEntity
	local l = vgui.Create("DListLayout")
	l:SetDrawBackground(false)
	self:SetContents(l)

	local price = vgui.Create("DLabel", self.Header)
	price:SetFont(fontsmall)
	price:SetText("0$")
	price:Dock(BOTTOM)
	price:SetContentAlignment(6)

	function price:ReCount()
		local val = (oldvars[3] == ent:GetSkin()) and 0 or 100
		self:SetText(val .. "$")
	end

	for n, v in pairs(t) do
		local b = vgui.Create("GButton")
		b:SetMouseInputEnabled(true)
		b:SetText(v.name)
		b:SetCursor("hand")
		l:Add(b)
		function b:DoClick()
			ent:SetSkin(v.var)
			price:ReCount()
		end
		l:Dock(TOP)
	end
end}

pui.booletproof = {text = translates and translates.Get("Колёса/Пулестойкие покрышки") or "Колёса/Пулестойкие покрышки", func= function(self, t)
	
	local add = translates and translates.Get("Установить") or "Установить"
	local rem = translates and translates.Get("Удалить") or "Удалить"
	
	local ent = PIMP.CurrentEntity
	local l = vgui.Create("DListLayout")
	l:SetDrawBackground(false)
	self:SetContents(l)
	local p = vgui.Create("GButton")
	p:SetText(ent:GetBulletProofTires() and rem or add)
	l:Add(p)

	local price = vgui.Create("DLabel", self.Header)
	price:SetFont(fontsmall)
	price:SetText("0$")
	price:Dock(BOTTOM)
	price:SetContentAlignment(6)

	function price:ReCount()
		local val = (ent:GetBulletProofTires() == ent.CachedBooletproof) and 0 or metadata.booletproofprice
		self:SetText(val .. "$")
	end

	function p:DoClick()
		ent.CachedBooletproof = !ent:GetBulletProofTires()
		ent:SetBulletProofTires(ent.CachedBooletproof)
		self:SetText(ent:GetBulletProofTires() and rem or add)
		price:ReCount()
	end
end}

pui.colors = {text = translates and translates.Get("Покрасочные работы/Цвет") or "Покрасочные работы/Цвет", func= function(self, t)
	local ent = PIMP.CurrentEntity
	local p = vgui.Create("DGrid", self)
	p:SetCols(20)
	p:SetColWide(22)
	self:SetContents(p)

	local price = vgui.Create("DLabel", self.Header)
	price:SetFont(fontsmall)
	price:SetText("0$")
	price:Dock(BOTTOM)
	price:SetContentAlignment(6)

	function price:ReCount()
		local val = (ent:GetNWInt("Color") ~= ent.CachedColor) and 100 or 0
		self:SetText(val .. "$")
	end

	for id, col in pairs(t) do
		local c = vgui.Create("DColorButton")
		c:SetMouseInputEnabled(true)
		c:SetCursor("hand")
		c:SetColor(col)
		c:SetSize(22, 22)
		p:AddItem(c)

		function c:DoClick()
			ent:SetColor(col)
			ent.CachedColor = id
			price:ReCount()
		end
	end
	p:SizeToContents()
end}

pui.wheels = {text = translates and translates.Get("Колёса") or "Колёса", func= function(self, t)
	local ent = PIMP.CurrentEntity
	local p = vgui.Create("DGrid", self)
	p:SetCols(10)
	p:SetColWide(44)
	p:SetRowHeight(44)
	self:SetContents(p)

	local price = vgui.Create("DLabel", self.Header)
	price:SetFont(fontsmall)
	price:SetText("0$")
	price:Dock(BOTTOM)
	price:SetContentAlignment(6)

	function price:ReCount()
		local val = (ent:GetNWInt("Wheels") == ent.CachedWheels) and 0 or 100
		self:SetText(val .. "$")
	end

	for id, v in pairs(t) do
		local c = vgui.Create("SpawnIcon")
		local md = v.model
		c:SetModel(md)
		c:SetMouseInputEnabled(true)
		c:SetCursor("hand")
		c:SetSize(44, 44)

		function c:DoClick()
			ent.CachedWheels = id
			price:ReCount()
		end

		p:AddItem(c)
	end
	p:SizeToContents()
end}

pui.suspension = {text = translates and translates.Get("Подвеска") or "Подвеска", func= function(self, t)
	local ent = PIMP.CurrentEntity

	local price = vgui.Create("DLabel", self.Header)
	price:SetFont(fontsmall)
	price:SetText("0$")
	price:Dock(BOTTOM)
	price:SetContentAlignment(6)

	function price:ReCount()
		local val = (ent.CachedSuspension ~= ent:GetNWInt("Suspension")) and 100 or 0
		self:SetText(val .. "$")
	end

	for i, v in pairs(t) do
		local b = vgui.Create("GButton", self)
		b:SetText(v.name)
		b:Dock(TOP)

		function b:DoClick()
			ent.CachedSuspension = i
			price:ReCount()
		end
	end
end}

pui.healthboost = {text = translates and translates.Get("Усиления корпуса") or "Усиления корпуса", func= function(self, t)
	local ent = PIMP.CurrentEntity

	local price = vgui.Create("DLabel", self.Header)
	price:SetFont(fontsmall)
	price:SetText("0$")
	price:Dock(BOTTOM)
	price:SetContentAlignment(6)

	function price:ReCount()
		local val = (ent.CachedArmor ~= ent:GetNWInt("Armor")) and t[ent.CachedArmor].price or 0
		self:SetText(val .. "$")
	end

	for i, v in pairs(t) do
		local b = vgui.Create("GButton", self)
		b:SetText(v.name .. "(" .. v.price .. ")")
		b:Dock(TOP)

		function b:DoClick()
			ent.CachedArmor = i
			price:ReCount()
		end
	end
end}

local angvar, rangevar = Angle(0, 0, 0), 100

local function __sliderthink(self)
	if !self.MouseX or !self.MouseY then 
		if self.LastClick and self.LastClick < RealTime() then
				angvar.y = (angvar.y + 0.033) % 360
				angvar.p = math.ApproachAngle(angvar.p, 0, 0.033)
		end
		return 
	end
	if !self:IsHovered() then return end
	local w, h, x, y = self:GetWide() - 440, self:GetTall(), gui.MouseX(), gui.MouseY()
	local oldy = self.BufferVar.y
	angvar.y = self.BufferVar.y + ((self.MouseX - x) / w) * 180
	angvar.p = math.Clamp(self.BufferVar.p + ((y - self.MouseY) / h) * 180, -15, 60)
end

local function __sliderpressed(self, mb)
	self.MouseX = gui.MouseX()
	self.MouseY = gui.MouseY()
	self.BufferVar = Angle(angvar.p, angvar.y, 0)
	self.LastClick = nil
end

local function __sliderreleased(self, mb)
	self.BufferVar = nil
	self.MouseX = nil
	self.MouseY = nil
	self.LastClick = RealTime() + 5
end

local function __sliderwheel(self, delta)
	rangevar = math.Clamp(rangevar - delta * 7.5, 40, 150)
end

--[[HOOKS]]

local function __dview(pl, origin, angles, fov, znear, zfar)
	local ent = PIMP.CurrentEntity
	if !IsValid(ent) then return end

	local r = ent:BoundingRadius() + rangevar
	local ang = ent:GetAngles() + Angle(15, 135, 0) + angvar
	local pos = ent:WorldSpaceCenter() - ang:Forward() * r + ang:Right() * r * (440 / ScrW())
	local view = {}
	view.origin = pos
	view.angles = ang
	view.fov = fov
	view.znear = 5
	view.zfar = zfar
	view.drawviewer = true

	return view
end

local function __dhidehud(n)
	return n == "CHudMenu"
end

local function __dhidewpn()
	return Vector(math.huge, math.huge, math.huge), angle_zero 
end

--[[Global]]

function PIMP.DropMenu(ent, npc)
	if IsValid(PIMP.Panel) then return end
	local t = PIMP.Get(ent:GetNWString("VehicleName"))
	if !t then return end
	local f = npc.StartScene
	if f then 
		meh = npc
		local pos, ang = t.MechanicPos, t.MechanicAng
		if pos and ang then
			local pos, ang = LocalToWorld(pos, ang, ent:GetPos(), ent:GetAngles())
			f(npc, pos, ang)
		end
	end

	PIMP.CurrentEntity = ent
	metadata = t

	local ent = PIMP.CurrentEntity
	oldvars = {}
	oldvars[1] = name
	oldvars[2] = {}
	oldvars[3] = ent:GetSkin()
	oldvars[4] = ent:GetColor()
	oldvars[5] = ent:GetBulletProofTires() or ent.CachedBooletproof
	oldvars[6] = ent:GetNWInt("Wheels") or ent.CachedWheels
	oldvars[7] = ent:GetNWInt("Suspension") or ent.CachedSuspension
	oldvars[8] = ent:GetNWInt("Armor") or ent.CachedArmor

	--ent.CachedBGs = {}
	for k, bg in pairs(ent:GetBodyGroups()) do
		local id = bg.id
		--ent.CachedBGs[id] = var
		oldvars[2][id] = ent:GetBodygroup(id)
	end

	local frame = vgui.Create("GPanel")
	--frame:SetTitle(t.Name)
	frame:SetWidth(440)
	frame:MakePopup()
	frame:Dock(RIGHT)
	frame:ParentToHUD()
	frame.OnRemove = __onremovemenu

	local scroll = vgui.Create("DScrollPanel", frame)
	scroll:Dock(FILL)

	for k, v in pairs(t) do
		if !pui[k] then continue end
		local text, func = pui[k].text, pui[k].func
		local p = vgui.Create("GCollapsibleCategory")
		scroll:AddItem(p)
		p:SetLabel(text)
		func(p, v)
		p:Dock(TOP)
	end

	local w, h = frame:GetSize()

	local buttonholder = vgui.Create("Panel", frame)
	buttonholder.Paint = __dontpaint
	buttonholder:SetSize(w, 28)
	buttonholder:SetPos(ScrW() - w, ScrH() - 28)
	buttonholder:Dock(BOTTOM)

	local buttonl = vgui.Create("GButton", buttonholder)
	buttonl:SetText(translates and translates.Get("Купить: %i$", 0) or "Купить: 0$")
	buttonl:SetSize(150, 25)
	buttonl.DoClick = __accept
	buttonl:SetPos(w / 2 - 155, 0)
	buttonl.nthink = 0
	buttonl.Think = __applybuttonthink
	buttonl:SetMouseInputEnabled(true)

	local buttonr = vgui.Create("GButton", buttonholder)
	buttonr:SetText(translates and translates.Get("Закрыть", 0) or "Закрыть")
	buttonr:SetSize(150, 25)
	buttonr.DoClick = function(self) frame:Remove() end
	buttonr:SetPos(w / 2 + 5, 0)
	buttonr:SetMouseInputEnabled(true)

	local slider = vgui.Create("DPanel")
	slider:MakePopup()
	slider:SetWidth(ScrW() - 440)
	slider:Dock(LEFT)
	slider:ParentToHUD()
	slider.Paint = __dontpaint
	slider.OnMousePressed = __sliderpressed
	slider.OnMouseReleased = __sliderreleased
	slider.OnMouseWheeled = __sliderwheel
	slider.Think = __sliderthink

	frame.slider = slider

	hook.Add("CalcView", "pview", __dview)
	hook.Add("CalcViewModelView", "phidewpn", __dhidewpn)
	hook.Add("HUDShouldDraw", "phidehud", __dhidehud)

	PIMP.Panel = frame
end

function PIMP.SaveCar(ent)
	local name = ent:GetNWString("VehicleName")
	local t = PIMP.Get(name)

	if t then
		local vars = {}
		vars[1] = name
		vars[2] = {}
		vars[3] = ent:GetSkin() or -1
		vars[4] = ent.CachedColor or ent:GetNWInt("Color") or -1
		vars[5] = ent.CachedBooletproof or ent:GetBulletProofTires() or -1
		vars[6] = ent.CachedWheels or ent:GetNWInt("Wheels") or -1
		vars[7] = ent.CachedSuspension or ent:GetNWInt("Suspension") or -1
		vars[8] = ent.CachedArmor or ent:GetNWInt("Armor") or -1

		for k, data in pairs(ent:GetBodyGroups()) do
			local id = data.id
			vars[2][id] = ent:GetBodygroup(id) or -1
		end

		local out = pon.encode(vars)
		cookie.Set(name, out)
	end
end

function PIMP.CallCar(data, name)
	local data = data or pon.encode({name})
	__sendrawdatacall(data)
end 

local fontb = "PIMPMenuFont"
surface.CreateFont(fontb, {
	font = "Roboto Lt",
	weight = 250,
	size = 16,
	antialias = true,
	extended = true
})

function PIMP.DropCallMenu()
	if IsValid(PIMP.Panel) then return end
	local frame = vgui.Create("GFrame")
	frame:SetTitle(translates and translates.Get('Ваши автомобили') or "Ваши автомобили")
	frame:SetSize(640, 800)
	frame:MakePopup()
	frame:Center()
	local lst = vgui.Create("DScrollPanel", frame)
	lst:Dock(FILL)

	local names = PIMP.GetNames()
	for _, name in pairs(names) do
		local p = vgui.Create("DPanel", lst)
		p:SetBackgroundColor(Color(0, 0, 0, 0))
		p:Dock(TOP)
		local data = PIMP.Get(name)
		local f = data.CanSpawn
		if f and !f(LocalPlayer()) then continue end

		local l = vgui.Create("DLabel", p)
		local t = PIMP.Get(name)
		l:SetText(t.Name)
		l:SetFont(font)
		l:SizeToContents()
		l:Dock(LEFT)

		local cook = cookie.GetString(name)
		local b = vgui.Create("GButton", p)
		b:SetText(translates and translates.Get("Вызвать %i$", t.Price or 0) or ("Вызвать " .. (t.Price or 0) .. "$"))
		b:Dock(RIGHT)
		b:SizeToContents()

		if !cook then b:SetColor(Color(100, 100, 100)) end

		function b:DoClick()
			PIMP.CallCar(cook, name)
			frame:Close()
		end
	end

	PIMP.Panel = frame
end