-- "gamemodes\\darkrp\\entities\\weapons\\hacktool\\cl_hackanim2.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local Length = string.len;
local ToString = tostring;
local Ceil = math.ceil;
local Abs = math.abs;
local LookupBinding = input.LookupBinding;
local Insert = table.insert;
local Round = math.Round;

local function fixLen(s,l)
	s = ToString(s)
	while Length(s) < l do
		s='0'..s
	end
	return s
end

local PANEL = {}

function PANEL:CreateLetters()
	self.letters = {}
	local words = {"increase","hospital","generate","medieval","material"}
	local alp = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'

	local word = words[Ceil(self.random() * #words)]:upper()
	for i=0,7 do
		self.letters[i] = {}
		self.letters[i][0] = word[i+1]
		for j=1,7 do
			self.letters[i][j] = alp[Ceil(self.random()*26)]
		end
		self.letters[i].offset = self.random()
	end
	self.pos = 0
end

function PANEL:SetUp()
	self.timings = {}
	self.fails = 0
	self:CreateLetters()
end

function PANEL:Init()
	self.drawToScreen = true

	self.h = ScrH()*0.6
	self.w = self.h*1.5
	self.speed = 0.5
	self.difficulty = 0.05

	self:SetSize(self.w, self.h)
	self:SetPos((ScrW()-self.w)/2,(ScrH() - self.h)/2)

	self:NoClipping(true)
	self:SetUpBindings()
end

function PANEL:SetTimeout(timeStart, timeEnd)
	self.timeStart = timeStart
	self.timeEnd = timeEnd
	timer.Create('hackingPanel_timeout', self.timeEnd - self.timeStart, 1, function() 
		self.OnTimeOut()
	end)
end

function PANEL:SetUpBindings()
	local nextTime = SysTime()+0.4
	local lastKey = nil
	hook.Add("PlayerButtonDown", "aaa.Hacking1", function(ply, key)
		if SysTime() < nextTime or not IsFirstTimePredicted() then return end
		nextTime = SysTime()+0.4
		local flag = true
		if key == KEY_ENTER or key == MOUSE_LEFT then
			if Abs(0.485 - ((SysTime() - self.timeStart)*self.speed+self.letters[self.pos].offset)%1) < self.difficulty then
				Insert(self.timings, SysTime())
				self.letters[self.pos].selected = true
				local flag = true
				for i=0,7 do
					flag = flag and self.letters[i].selected
				end
				if flag and self.OnSuccess then
					self.doBeep('bebeep',1)
					self:OnSuccess({self.timings, self.fails})
					return
				end
			else
				self.fails = self.fails + 1
				self.doBeep('deny',1)
				self:CreateLetters()
				return
			end
			self.pos = (self.pos + 1) % 8
			self.doBeep('beep',0.5)
		elseif key == KEY_RIGHT then
			self.pos = (self.pos + 1) % 8
		elseif key == KEY_LEFT then
			self.pos = self.pos == 0 and 7 or self.pos - 1
		else
			flag = false
		end
		if flag then
			lastKey = key
		end
	end)

	hook.Add("PlayerButtonUp", "aaa.Hacking1", function(ply, key)
		if lastKey == key and SysTime() < nextTime then
			nextTime = SysTime()+0.02
			lastKey = nil
		end
	end)

	local bbind = {"RIGHTARROW","LEFTARROW","MOUSE1","MWHEELDOWN","MWHEELUP"}

	hook.Add("PlayerBindPress","aaa.Hacking2", function(ply, bind, pressed)
		bind = LookupBinding(bind)
		if pressed then
			if bind == "MWHEELDOWN" then
				self.pos = (self.pos + 1) % 8
				self.doBeep('tick',0.2)
			elseif bind == "MWHEELUP" then
				self.pos = self.pos == 0 and 7 or self.pos - 1
				self.doBeep('tick',0.2)
			end
			for i=1,#bbind do
				if bbind[i] == bind then
					return true
				end
			end
		end
	end,-1)
end

local gradient_u = Material("vgui/gradient-u")
local gradient_d = Material("vgui/gradient-d")

function PANEL:OnRemove()
	timer.Remove('hackingPanel_timeout')
	hook.Remove("PlayerBindPress","aaa.Hacking2")
	hook.Remove("PlayerButtonDown", "aaa.Hacking1")
	hook.Remove("PlayerButtonUp", "aaa.Hacking1")
end

local PushRenderTarget = render.PushRenderTarget;
local Start2D = cam.Start2D;
local SetDrawColor = surface.SetDrawColor;
local DrawRect = surface.DrawRect;
local SetFont = surface.SetFont;
local GetTextSize = surface.GetTextSize;
local SetTextPos = surface.SetTextPos;
local SetTextColor = surface.SetTextColor;
local DrawText = surface.DrawText;
local End2D = cam.End2D;
local PopRenderTarget = render.PopRenderTarget;
local DrawLine = surface.DrawLine;
local RoundedBox = draw.RoundedBox;
local SetMaterial = surface.SetMaterial;
local DrawTexturedRect = surface.DrawTexturedRect;
local ClearDepth = render.ClearDepth;
local OverrideBlend = render.OverrideBlend;
local DrawTexturedRectRotated = surface.DrawTexturedRectRotated;
local PCall = pcall;

function PANEL:DrawOnRt(rt)
	local w, h = rt:Width(), rt:Height()

	PushRenderTarget(rt, 0, 0, w, h)
	Start2D()

	SetDrawColor(0,0,0,255)
	DrawRect( 0, 0, w, h )

	SetFont(hacktoolMats.font21)

	for i=0,7 do
		for j=0,15 do
			jj = j % 8
			local text = self.letters[i][jj]

			local ofs = self.letters[i].selected and 0.485 or ((SysTime() - self.timeStart)*self.speed+self.letters[i].offset)%1

			local top = 0.065*j + 0.557 + 0.065*(8*ofs-12)
			if top < 0.20 or top > 0.83 then
				continue
			end

			local tw,th = GetTextSize(text)
			SetTextPos(w*(0.23 + 0.077*i)-tw/2,h*  top )
			if jj == 0 then
				if self.letters[i].selected then
					SetTextColor(0,255,0)
				else
					SetTextColor(255,0,0)
				end
			else
				SetTextColor(255, 255, 255)
			end

			
			DrawText(text)
		end
	end

	SetDrawColor(28,67,176,69)
	DrawRect(w*0.2, h*(0.58-0.03), w*0.6, h*(0.06))

	SetDrawColor(50,130,189)
	DrawLine( w*0.2, h*(0.58-0.03), w*0.8-1, h*(0.58-0.03))
	DrawLine( w*0.2, h*(0.58+0.03), w*0.8-1, h*(0.58+0.03))

	local pos = self.pos

	SetDrawColor(87,174,59,30)
	DrawRect(w*(0.23 + 0.077*pos-0.025), h*(0.1), w*0.05, h*(0.8))
	SetDrawColor(87,174,59)
	DrawLine(w*(0.23 + 0.077*pos-0.025), h*(0.1), w*(0.23 + 0.077*pos-0.025), h*(0.8))
	DrawLine(w*(0.23 + 0.077*pos+0.025)-1, h*(0.1), w*(0.23 + 0.077*pos+0.025)-1, h*(0.8))

	--draw gradients
	SetDrawColor(0,0,0)
	DrawRect(w*0.1, h*0.08, w*0.8, h*(0.58-0.2-0.08)+1)
	SetMaterial(gradient_u)
	DrawTexturedRect(w*0.1,h*(0.58-0.2),w*0.8,h*0.07)

	DrawRect(w*0.1, h*(0.58+0.2)-1, w*0.8, h*(0.2)+1)
	SetMaterial(gradient_d)
	DrawTexturedRect(w*0.1,h*(0.58+0.2-0.07),w*0.8,h*0.07)

	--Draw time
	local timeLeft = (self.timeEnd - CurTime())
	text = '00:'..fixLen(Round(timeLeft),2)..':'..fixLen((Round(timeLeft%1*1000)),3)
	SetFont(hacktoolMats.font12)
	local tw,th = GetTextSize(text)
	SetTextPos(w/2 - tw/2,h*0.294)
	SetTextColor(48,163,47,255)
	DrawText(text)

	End2D()
	PopRenderTarget()

	return rt
end

local bgMatUnilit = Material("models/weapons/hacktool/hacktool_mon_unilit")
local col_panelBorder = Color(28,67,176)

function PANEL:Paint()
	local noerr, text = PCall(self.DrawOnRt, self, hacktoolMats.panelRt)

	if not noerr then
		End2D()
		PopRenderTarget()
		print("Render error:",text)
	end

	hacktoolMats.panelMat:SetTexture('$basetexture', hacktoolMats.panelRt)

	if self.drawToScreen then
		RoundedBox( 8, 0, 0, self.w, self.h, col_panelBorder)
		SetMaterial(hacktoolMats.panelMat)
		DrawTexturedRect( self.w*0.013, self.h*0.075, self.w*0.974, self.h*0.912 )		
	end

	local w,h = hacktoolMats.vmatrt:Width(),hacktoolMats.vmatrt:Height()

	PushRenderTarget(hacktoolMats.vmatrt)
	Start2D()
		ClearDepth()
		OverrideBlend( true, BLEND_ONE, BLEND_ZERO, BLENDFUNC_ADD, BLEND_ONE, BLEND_ZERO, BLENDFUNC_ADD )

		SetDrawColor( 255, 255, 255, 255 )

		SetMaterial(bgMatUnilit)
		DrawTexturedRect(0,0,w,h)


		SetMaterial(hacktoolMats.panelMat)
		OverrideBlend( true, BLEND_ONE, BLEND_ZERO, BLENDFUNC_ADD, BLEND_ZERO, BLEND_ONE, BLENDFUNC_ADD )

		DrawTexturedRectRotated(w/2,h/2,996*1.3/1024*w,650*1.3/1024*h,180)
		OverrideBlend( false )

	End2D()
	PopRenderTarget()

	hacktoolMats.vmmat:SetTexture('$basetexture', hacktoolMats.vmatrt)
end

vgui.Register("HackPanel2", PANEL, "DPanel")