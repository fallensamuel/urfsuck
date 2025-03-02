-- "gamemodes\\darkrp\\entities\\weapons\\hacktool\\cl_screen.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local ToString = tostring;
local Length = string.len;

local function fixLen(s,l)
	s=ToString(s)
	while Length(s) < l do
		s='0'..s
	end
	return s
end

local errorList = {'LOADING...', 'RELOADING...', 'CPU OVERHEAT!', 'SYSTEM ERROR!'}

local Panel = {}

function Panel:Init()
	self.drawToScreen = false

	self.h = ScrH()*0.6
	self.w = self.h*1.5

	self:SetUpError()

	self:SetSize(self.w, self.h)
	self:SetPos((ScrW()-self.w)/2,(ScrH() - self.h)/2)
	self:NoClipping(true)
end

function Panel:GetReadyStatus()
	return (CurTime() - self.startTime) / (self.endTime - self.startTime) >= 1
end

function Panel:SetUpError(text, time)
	time = time or 1
	self.text = text or ''
	self.startTime = CurTime()
	self.endTime = CurTime() + time
end

local gradient_u = Material("vgui/gradient-u")
local gradient_d = Material("vgui/gradient-d")

function Panel:OnRemove()
	hook.Remove("PlayerBindPress","aaa.Hacking2")
	hook.Remove("PlayerButtonDown", "aaa.Hacking1")
end

local function drawOutlinedBox( x, y, w, h, thickness)
	for i=0, thickness - 1 do
		surface.DrawOutlinedRect( x + i, y + i, w - i * 2, h - i * 2 )
	end
end

local tr = translates.Get
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

function Panel:DrawOnRt(rt)
	local w, h = rt:Width(), rt:Height()

	PushRenderTarget(rt, 0, 0, w, h)
	Start2D()

	local progress = IsValid(self.swep) and (CurTime() - self.swep:GetLastErrorTime()) / (self.swep:GetNextUseTime() - self.swep:GetLastErrorTime()) or 0

	progress = progress > 1 and 1 or (progress < 0 and 0 or progress)

	SetDrawColor(0,0,0)
	DrawRect(0,0,w,h)

	local color = progress < 0.8 and HSVToColor( 0, 1, 0.6 ) or HSVToColor( (progress - 0.8)/0.2 * 120, 1, 0.6 )
	local text = IsValid(self.swep) and (progress >= 1 and tr("READY") or tr(errorList[self.swep:GetErrorId()])) or ""

	SetDrawColor(color)
	local sx,sy = w*0.7, h*0.15
	local px,py,th = w / 2 - sx / 2, h / 2 - sy / 2, h * 0.01
	drawOutlinedBox(px, py, sx, sy, th)

	DrawRect(px + th*2, py + th * 2, (sx - th*4) * progress, sy - th*4)

	SetFont(hacktoolMats.font11)
	local tw,th = GetTextSize(text)
	SetTextPos(px, h * 0.3)
	SetTextColor(color)
	DrawText(text)

	End2D()
	PopRenderTarget()

	return rt
end

local bgMatUnilit = Material("models/weapons/hacktool/hacktool_mon_unilit")
local PCall = pcall;
local Clear = render.Clear;
local ClearDepth = render.ClearDepth;
local OverrideBlend = render.OverrideBlend;
local SetMaterial = surface.SetMaterial;
local DrawTexturedRect = surface.DrawTexturedRect;
local DrawTexturedRectRotated = surface.DrawTexturedRectRotated;

function Panel:Paint()
	local noerr, text = PCall(self.DrawOnRt, self, hacktoolMats.panelRt)

	if not noerr then
		End2D()
		PopRenderTarget()
		print("Render error:",text)
		self:Remove()
	end

	hacktoolMats.panelMat:SetTexture('$basetexture', hacktoolMats.panelRt)

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

vgui.Register("HackDisplay1", Panel, "DPanel")