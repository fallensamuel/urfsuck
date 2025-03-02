-- "gamemodes\\darkrp\\entities\\weapons\\hacktool\\cl_hackanim3.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local Length = string.len;
local ToString = tostring;
local Sin = math.sin;
local Insert = table.insert;
local Abs = math.abs;
local LookupBinding = input.LookupBinding;

local function fixLen(s,l)
	s = ToString(s)
	while Length(s) < l do
		s='0'..s
	end
	return s
end

local Panel = {}

function Panel:SetUp()
	self.somerandomness = self.random() * 200
	self.timings = {}
end

function Panel:Init()

	self.drawToScreen = true

	self.h = ScrH()*0.6
	self.w = self.h*1.5
	self.speed = 0.5
	self.difficulty = 0.05

	self:SetSize(self.w, self.h)
	self:SetPos((ScrW()-self.w)/2,(ScrH() - self.h)/2)

	self.pos = 1
	self:NoClipping(true)
	self:SetUpBindings()
end

function Panel:SetTimeout(timeStart, timeEnd)
	self.timeStart = timeStart
	self.timeEnd = timeEnd
	timer.Create('hackingPanel_timeout', self.timeEnd - self.timeStart, 1, function() 
		self.OnTimeOut()
	end)
end

function Panel:SetUpBindings()
	local nextTime = SysTime()+0.4
	local lastKey = nil
	hook.Add("PlayerButtonDown", "aaa.Hacking1", function(ply, key)
		if SysTime() < nextTime or not IsFirstTimePredicted() then return end
		nextTime = SysTime()+0.4
		local flag = true
		if key == KEY_ENTER or key == MOUSE_LEFT then
			local val = Sin(self.pos + (1+0.1*self.pos)*(self.somerandomness + SysTime()-self.timeStart))
			Insert(self.timings, SysTime())
			if Abs(val)<0.12 then
				if self.pos == 8 then
					self.doBeep('bebeep',0.5)
					self:OnSuccess({self.timings})
					return
				end
				self.doBeep('beep',0.5)
				self.pos = self.pos + 1
			else
				self.doBeep('bzz',0.8)
				self.pos = self.pos == 1 and 1 or self.pos - 1
			end
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

	hook.Add("PlayerBindPress","aaa.Hacking2", function(ply, bind, pressed)
		bind = LookupBinding(bind)
		if bind == "MWHEELDOWN" or bind == "MWHEELUP" then return true end
		if pressed and "MOUSE1" == bind then
			return true
		end
	end,-1)
end

local gradient_u = Material("vgui/gradient-u")
local gradient_d = Material("vgui/gradient-d")

function Panel:OnRemove()
	timer.Remove('hackingPanel_timeout')
	hook.Remove("PlayerBindPress","aaa.Hacking2")
	hook.Remove("PlayerButtonDown", "aaa.Hacking1")
	hook.Remove("PlayerButtonUp", "aaa.Hacking1")
end

local DrawOutlinedRect = surface.DrawOutlinedRect;

local function drawOutlinedBox( x, y, w, h, thickness)
	for i=0, thickness - 1 do
		DrawOutlinedRect( x + i, y + i, w - i * 2, h - i * 2 )
	end
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
local Clear = render.Clear;

function Panel:DrawOnRt(rt)
	local w, h = rt:Width(), rt:Height()

	local function drawStick(pos, sel)
		local sx, sy = w * 0.031, h * 0.163
		local ad = 0
		if sel then
			SetDrawColor(229,208,53)
			ad = sx*0.13
		else
			SetDrawColor(255,255,255,255)
		end
		local val = pos < self.pos and 0 or math.sin(pos + (1+0.1*pos)*(self.somerandomness + SysTime()-self.timeStart))
		local px,py = w*(0.5 + (pos - 4.5)*0.06), h * (0.573 + 0.16 * val)
		DrawRect(px - sx/2-ad, py - sy - h*0.025 - ad, sx + ad*2, sy + ad*2)
		DrawRect(px - sx/2-ad, py + h*0.025 - ad, sx + ad*2, sy + ad*2)
	end

	PushRenderTarget(rt, 0, 0, w, h)
	Start2D()

	SetDrawColor(0,0,0,255)
	DrawRect( 0, 0, w, h )

	SetDrawColor(255,0,0,255)
	local px,py,sx,sy = w/2, h*0.573, w*0.62, h*0.8
	drawOutlinedBox(px-sx/2, py - sy/2,sx,sy,h*0.006)
	sy = h*0.04
	DrawRect(px-sx/2, py - sy/2, sx, sy)

	drawStick(self.pos, true)
	for i=1,8 do
		drawStick(i, false)
	end

	--Draw time
	local timeLeft = (self.timeEnd - CurTime())
	text = '00:'..fixLen(math.Round(timeLeft),2)..':'..fixLen((math.Round(timeLeft%1*1000)),3)
	SetFont(hacktoolMats.font12)
	local tw,th = GetTextSize(text)
	SetTextPos(w/2 - tw/2,h*0.1)
	SetTextColor(48,163,47,255)
	DrawText(text)

	End2D()
	PopRenderTarget()

	return rt
end

local bgMatUnilit = Material("models/weapons/hacktool/hacktool_mon_unilit")
local col_panelBorder = Color(28,67,176)

function Panel:Paint()
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
	Clear(0,0,0,255,true)
		ClearDepth()
		OverrideBlend( true, BLEND_ONE, BLEND_ZERO, BLENDFUNC_ADD, BLEND_ONE, BLEND_ZERO, BLENDFUNC_ADD )

		SetDrawColor( 255, 255, 255, 255 )

		SetMaterial(bgMatUnilit)
		DrawTexturedRect(0,0,w,h)

		SetMaterial(hacktoolMats.panelMat)
		OverrideBlend( true, BLEND_ONE, BLEND_ZERO, BLENDFUNC_ADD, BLEND_ZERO, BLEND_ONE, BLENDFUNC_ADD )

		DrawTexturedRectRotated(w/2,h/2,996/1024*w,656/1024*h,180)
		OverrideBlend( false )
	End2D()
	PopRenderTarget()

	hacktoolMats.vmmat:SetTexture('$basetexture', hacktoolMats.vmatrt)
end

vgui.Register("HackPanel3", Panel, "DPanel")