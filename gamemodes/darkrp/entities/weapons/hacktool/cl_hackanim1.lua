-- "gamemodes\\darkrp\\entities\\weapons\\hacktool\\cl_hackanim1.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal

local Length = string.len;
local ToString = tostring;
local Floor = math.floor;
local Ceil = math.ceil;
local Round = math.Round;
local LookupBinding = input.LookupBinding;

local function fixLen(s,l)
	s = ToString(s)
	while Length(s) < l do
		s='0'..s
	end
	return s
end

local PANEL = {};

function PANEL:SetUp()
	local IPs = {};

	for Index = 1, 80 do
		IPs[Index] = fixLen(Floor(self.random() * 99 + 1), 2);
	end

	local ID = Ceil(self.random() * 80);
	local RightIP = '';

	for Index = -1, 2 do
		RightIP = RightIP .. IPs[(ID + Index) % 80 + 1] .. '.';
	end

	RightIP = RightIP:sub(1, #RightIP - 1);

	self.ips = IPs;
	self.rightip = RightIP;

	timer.Create('hackingPanel_shift', 2, 0, function()
		if (IsValid(self)) then
			local fst = self.ips[1];

			for i = 2, #self.ips do
				self.ips[i-1] = self.ips[i];
			end

			self.ips[#self.ips] = fst;
		end
	end)

	self.pos = Ceil(self.random() * 80);
end

function PANEL:Init()
	self.h = ScrH() * 0.6
	self.w = self.h * 1.5

	self.drawToScreen = false

	self.pos = 1
	self.attempts = 5

	self:SetSize(self.w, self.h)
	self:SetPos((ScrW() - self.w) / 2, (ScrH() - self.h) / 2)

	self:NoClipping(true)
	self:SetUpBindings()
end

function PANEL:SetTimeout(timeStart, timeEnd)
	self.timeStart = timeStart
	self.timeEnd = timeEnd

	timer.Create('hackingPanel_timeout', self.timeEnd - self.timeStart, 1, function() 
		self.OnTimeOut();
	end)
end

function PANEL:CheckIp()
	local id = self.pos
	return self.rightip == (ToString(self.ips[(id-1)%80+1])..'.'..self.ips[(id-0)%80+1]..'.'..self.ips[(id+1)%80+1]..'.'..self.ips[(id+2)%80+1])
end

function PANEL:SetUpBindings()
	local nextTime = SysTime()+0.4
	local lastKey = nil

	hook.Add("PlayerButtonDown", "aaa.Hacking1", function(ply, key)
		if SysTime() < nextTime or not IsFirstTimePredicted() then return end
		nextTime = SysTime()+0.4
		local flag = true
		if key == KEY_ENTER or key == MOUSE_LEFT then
			if self:CheckIp() then
				self.doBeep('bebeep',1)
				self:OnSuccess({CurTime(), self.pos})
			else
				self.attempts = self.attempts - 1
				if self.attempts == 0 then
					self.doBeep('deny',0.8)
					self.OnFail()
					return
				end
				self.doBeep('bzz',0.6)
			end
		elseif key == KEY_RIGHT then
			self.pos = self.pos % 80 + 1
		elseif key == KEY_LEFT then
			self.pos = self.pos == 1 and 80 or self.pos - 1
		elseif key == KEY_UP then
			self.pos = self.pos > 10 and self.pos - 10 or self.pos + 70
		elseif key == KEY_DOWN then
			self.pos = (((self.pos + 10) - 1) % 80) + 1
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
				self.pos = self.pos % 80 + 1
				self.doBeep('tick',0.2)
			elseif bind == "MWHEELUP" then
				self.pos = self.pos == 1 and 80 or self.pos - 1
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

function PANEL:OnRemove()
	timer.Remove('hackingPanel_timeout')
	timer.Remove('hackingPanel_shift')
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
		SetDrawColor(0, 0, 0)
		DrawRect( 0, 0, w, h )

		SetFont(hacktoolMats.font11)
		local tw,th = GetTextSize(self.rightip)
		SetTextPos(w/2 - tw/2,h*0.175)
		SetTextColor(241,22,11,255)
		DrawText(self.rightip)

		for i=1,80 do
			text = self.ips[i]
			local px,py = (i-1)%10, Floor((i-1)/10)

			local ii = (self.pos > 76 and i < 4) and i + 80 or i

			if ii >= self.pos and ii < (self.pos + 4) then
				SetTextColor(218,0,0,255)
			else
				SetTextColor(218,218,218,255)
			end 
		
			SetTextPos(w*0.14 + px*w*0.074,h*0.36 + py*0.067*h)
			DrawText(text)
		end

		SetDrawColor(48,163,47,255)
	
		for i=1,self.attempts do
			DrawRect(w*(0.8+i*0.02), h*0.1, w*0.01, h*0.05)		
		end

		local timeLeft = (self.timeEnd - CurTime())
		text = '00:'..fixLen(Round(timeLeft),2)..':'..fixLen((Round(timeLeft%1*1000)),3)
		SetFont(hacktoolMats.font12)
		tw,th = GetTextSize(text)
		SetTextPos(w/2 - tw/2,h*0.294)
		SetTextColor(48,163,47,255)
		DrawText(text)
	End2D()
	PopRenderTarget()

	return rt
end

local bgMatUnilit = Material("models/weapons/hacktool/hacktool_mon_unilit")
local col_panelBorder = Color(28, 67, 176)

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
		DrawTexturedRect( self.w*0.013, self.h*0.075, self.w*0.974, self.h*0.912)		
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

		DrawTexturedRectRotated(w/2,h/2,996*1.1/1024*w,650*1.1/1024*h,180)
		OverrideBlend( false )
	End2D()
	PopRenderTarget()

	hacktoolMats.vmmat:SetTexture('$basetexture', hacktoolMats.vmatrt)
end

vgui.Register("HackPanel1", PANEL, "DPanel")