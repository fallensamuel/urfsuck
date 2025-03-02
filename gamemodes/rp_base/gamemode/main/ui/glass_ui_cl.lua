-- "gamemodes\\rp_base\\gamemode\\main\\ui\\glass_ui_cl.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local blur = Material("pp/blurscreen")
local scrw, scrh = ScrW(), ScrH()

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

local function __dontpaint() end
local function __blur(self)
	render.UpdateScreenEffectTexture()
	local x, y = self:LocalToScreen(1, 1)
	surface.SetDrawColor(color_white)
	surface.SetMaterial(blur)
	for i = 1, 5 do
		blur:SetFloat("$blur", (i / 3) * 2)
		blur:Recompute()
		surface.DrawTexturedRect(-x, -y, scrw, scrh)
	end
end

local PANEL = {}

function PANEL:Init()
	self:SetName("GPanel")
	return true
end

function PANEL:Paint(w, h)
	__blur(self)
	surface.SetDrawColor(0, 0, 0, 150)
	surface.DrawRect(0, 0, w, h)
	if self:IsHovered() then
		surface.SetDrawColor(120, 120, 130, 150)
	else
		surface.SetDrawColor(60, 60, 66, 150)
	end
	surface.DrawOutlinedRect(0, 0, w, h)
end

function PANEL:GetClassName() return "GPanel" end

vgui.Register("GPanel", PANEL, "DPanel")

local PANEL = {}

local function __paintclosebutton(self, w, h)
	local c = Color(255, 255, 255)
	if self:IsHovered() then
		surface.SetDrawColor(255, 255, 255, 100)
		surface.DrawRect(0, 0, w, h)
		surface.SetDrawColor(255, 255, 255)
		surface.DrawOutlinedRect(0, 0, w, h)
	else
		surface.SetDrawColor(30, 30, 30, 100)
		surface.DrawRect(0, 0, w, h)
		surface.SetDrawColor(123, 123, 123)
		surface.DrawOutlinedRect(0, 0, w, h)
		c = Color(255, 255, 255, 150)
	end
	draw.SimpleText("x", font, 11, 0, c)
	return true
end

local function __paintmaxbutton(self, w, h)
	local c = Color(255, 255, 255)
	if self:IsHovered() then
		surface.SetDrawColor(255, 255, 255, 100)
		surface.DrawRect(0, 0, w, h)
		surface.SetDrawColor(255, 255, 255)
		surface.DrawOutlinedRect(0, 0, w, h)
	else
		surface.SetDrawColor(30, 30, 30, 100)
		surface.DrawRect(0, 0, w, h)
		surface.SetDrawColor(123, 123, 123)
		surface.DrawOutlinedRect(0, 0, w, h)
		c = Color(255, 255, 255, 150)
	end
	draw.SimpleText("□", font, 11, 0, c)
	return true
end

local function __paintminbutton(self, w, h)
	local c = Color(255, 255, 255)
	if self:IsHovered() then
		surface.SetDrawColor(255, 255, 255, 100)
		surface.DrawRect(0, 0, w, h)
		surface.SetDrawColor(255, 255, 255)
		surface.DrawOutlinedRect(0, 0, w, h)
	else
		surface.SetDrawColor(30, 30, 30, 100)
		surface.DrawRect(0, 0, w, h)
		surface.SetDrawColor(123, 123, 123)
		surface.DrawOutlinedRect(0, 0, w, h)
		c = Color(255, 255, 255, 150)
	end
	draw.SimpleText("_", font, 11, 0, c)
	return true
end

function PANEL:Init()
	self:SetFocusTopLevel( true )

	self.btnClose = self.btnClose or vgui.Create( "DButton", self )
	self.btnClose:SetText( "" )
	self.btnClose.DoClick = function ( button ) self:Close() end
	self.btnClose.Paint = __paintclosebutton
	self.btnClose:SetImage()

	self.btnMaxim = self.btnMaxim or vgui.Create( "DButton", self )
	self.btnMaxim:SetText( "" )
	self.btnMaxim.DoClick = function ( button ) self:Close() end
	self.btnMaxim.Paint = __paintmaxbutton
	self.btnMaxim:SetDisabled( true )
	self.btnMaxim:SetImage()

	self.btnMinim = self.btnMinim or vgui.Create( "DButton", self )
	self.btnMinim:SetText( "" )
	self.btnMinim.DoClick = function ( button ) self:Close() end
	self.btnMinim.Paint = __paintminbutton
	self.btnMinim:SetDisabled( true )
	self.btnMinim:SetImage()

	self.lblTitle = self.lblTitle or vgui.Create( "DLabel", self )
	self.lblTitle:SetFont(font)
	self.lblTitle:SetColor(color_white)

	self:SetDraggable( true )
	self:SetSizable( false )
	self:SetScreenLock( false )
	self:SetDeleteOnClose( true )
	self:SetTitle( "" )

	self:SetMinWidth( 25 )
	self:SetMinHeight( 25 )

	self.m_fCreateTime = SysTime()

	self:DockPadding( 5, 29, 5, 5 )
	self:PerformLayout()
	self:SetName("GFrame")

	return true
end

function PANEL:GetClassName() return "GFrame" end

function PANEL:Paint(w, h)
	__blur(self)
	surface.SetDrawColor(160, 160, 160, 150)
	surface.DrawRect(0, 0, w, 25)
	surface.SetDrawColor(200, 200, 200, 150)
	surface.DrawOutlinedRect(0, 0, w, 25)
	surface.SetDrawColor(0, 0, 0, 150)
	surface.DrawRect(0, 25, w, h - 25)
	if self:IsHovered() then
		surface.SetDrawColor(120, 120, 130, 150)
	else
		surface.SetDrawColor(60, 60, 66, 150)
	end
	surface.DrawOutlinedRect(0, 0, w, h)

	return true
end

vgui.Register("GFrame", PANEL, "DFrame")


local PANEL = {}

function PANEL:Init()

	self:SetContentAlignment( 5 )

	self:SetDrawBorder( false )
	self:SetPaintBackground( false )

	self:SetTall( 26 )
	self:SetMouseInputEnabled( true )
	self:SetKeyboardInputEnabled( true )

	self:SetCursor( "hand" )
	self:SetFont(font)
	self:SetColor(color_white)

	return true
end

function PANEL:Paint(w, h)
	if self:IsHovered() then
		surface.SetDrawColor(255, 255, 255, 100)
		surface.DrawRect(0, 0, w, h)
		surface.SetDrawColor(255, 255, 255)
		surface.DrawOutlinedRect(0, 0, w, h)
	else
		surface.SetDrawColor(255, 255, 255, 50)
		surface.DrawRect(0, 0, w, h)
		surface.SetDrawColor(123, 123, 123)
		surface.DrawOutlinedRect(0, 0, w, h)
	end
end

vgui.Register("GButton", PANEL, "DButton")


local PANEL = {}

function PANEL:Init()
	self:SetContentAlignment(4)
	self:SetTextInset(5, 0)
	self:SetFont(font)

	return false
end

function PANEL:Paint(w, h)
	if self:IsHovered() then
		surface.SetDrawColor(255, 255, 255, 100)
		surface.DrawRect(0, 0, w, h)
		surface.SetDrawColor(255, 255, 255)
		surface.DrawOutlinedRect(0, 0, w, h)
	else
		surface.SetDrawColor(30, 30, 30, 100)
		surface.DrawRect(0, 0, w, h)
		surface.SetDrawColor(123, 123, 123)
		surface.DrawOutlinedRect(0, 0, w, h)
	end
	return false
end

function PANEL:UpdateColours()
	return true
end

vgui.Register("GCategoryHeader", PANEL, "DCategoryHeader")


local PANEL = {}

function PANEL:Init(w, h)
	if self.Header then self.Header:Remove() end
	self.Header = vgui.Create("GCategoryHeader", self)
	self.Header:Dock(TOP)
	self.Header:SetSize(25, 25)

	self:SetSize(25, 25)
	self:SetExpanded(true)
	self:SetMouseInputEnabled(true)

	self:SetAnimTime(0.1)
	self.animSlide = Derma_Anim("Anim", self, self.AnimSlide)

	self:SetPaintBackground(true)
	self:DockMargin(0, 0, 0, 2)
	self:DockPadding(0, 0, 0, 0)

	return false
end

function PANEL:PerformLayout()

	if ( IsValid( self.Contents ) ) then

		if ( self:GetExpanded() ) then
			self.Contents:InvalidateLayout( true )
			self.Contents:SetVisible( true )
		else
			self.Contents:SetVisible( false )
		end

	end

	if ( self:GetExpanded() ) then

		if ( IsValid( self.Contents ) && #self.Contents:GetChildren() > 0 ) then self.Contents:SizeToChildren( false, true ) end
		self:SizeToChildren( false, true )

	else

		if ( IsValid( self.Contents ) && !self.OldHeight ) then self.OldHeight = self.Contents:GetTall() end
		self:SetTall(25)

	end

	-- Make sure the color of header text is set
	self.Header:ApplySchemeSettings()

	self.animSlide:Run()
	self:UpdateAltLines()

end


function PANEL:Paint(w, h)
	return false
end

vgui.Register("GCollapsibleCategory", PANEL, "DCollapsibleCategory")

local PANEL = {}

function PANEL:Init(w, h)
	self:SetFont(font)
end

vgui.Register("GLabel", PANEL, "DLabel")

local rt = GetRenderTarget("compizz", ScrW(), ScrH(), false)
local cmat = CreateMaterial("compizz", "UnlitGeneric", {["$basetexture"] = "compizz", ["$translucent"] = 1})
cmat:SetTexture("$basetexture", rt)
cmat:Recompute()

local todrawpanels = {
	GFrame = true
}

local ins = table.insert
local function __drawchildren(self, done)
	local done = done or {}
	local v = Vector(ScrW() / 2, ScrH() / 2, 0)
	local r = 30
	done[self] = true
	for _, PANEL in pairs(self:GetChildren()) do
		if done[PANEL] then continue end
		if !PANEL:IsVisible() then continue end
		if todrawpanels[PANEL:GetClassName()] then
			local x, y = PANEL:LocalToScreen(1, 1)
			local w, h = PANEL:GetSize()
			local poly = {}
			ins(poly, {x = x + w, y = y})
			ins(poly, {x = x + w, y = y + h})
			ins(poly, {x = x + w - r, y = y + h + r})
			ins(poly, {x = x - r, y = y + h + r})
			ins(poly, {x = x - r, y = y + r})
			ins(poly, {x = x, y = y})
			surface.DrawPoly(poly)
		end

		done[PANEL] = true
		__drawchildren(PANEL, done)
		done[PANEL] = nil
	end
end
