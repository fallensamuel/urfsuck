-- "gamemodes\\rp_base\\gamemode\\main\\menus\\rpui_elements\\notifyvote_cl.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local IsVALID, SetDrawColor, DrawRect, SetMaterial, DrawTexturedRect, SimpleText = IsValid, surface.SetDrawColor, surface.DrawRect, surface.SetMaterial, surface.DrawTexturedRect, draw.SimpleText
local isfunc = isfunction
local DrawBlur = draw and draw.Blur or function(...) draw.Blur(...) end

local color = {
	background = Color(0, 0, 0, 89.25),
}

local Align = {
	Center = TEXT_ALIGN_CENTER,
	Left = TEXT_ALIGN_LEFT,
	Top = TEXT_ALIGN_TOP
}

surface.CreateFont("rpui.notifyvote.font", {
    font = "Montserrat",
    extended = true,
    antialias = true,
    size = 24,
    --weight = 550
})

local PANEL = {}

PANEL.Colors = {
	Background = Color(255, 255, 255),
	Inside = Color(0, 0, 0),
	InsideHover = Color(0, 0, 15, 200)
}

function PANEL:SetColor(name, col)
	if self.Colors[name] and IsColor(col) then
		self.Colors[name] = col
		return true
	end

	return false
end

PANEL.Icon = Material("ping_system/rec_fill.png", "smooth", "noclamp")

function PANEL:SetIcon(mat)
	if isstring(mat) then
		self.Icon = Material(mat, "smooth", "noclamp")
		return true
	elseif type(mat) == "IMaterial" then
		self.Icon = mat
		return true
	end

	return false
end

PANEL.Title = "Unknown Title"

function PANEL:SetTitle(str)
	if isstring(str) then
		self.Title = str
		return true
	elseif tostring(str) then
		self.Title = tostring(str)
		return true
	end

	return false
end

function PANEL:SetFont(name)
	if isstring(name) then
		self.Font = name
		return true
	end

	return false
end

local colors = {
	title = Color(210, 210, 210),
	desc = Color(255, 255, 255)
}

local GradiMat = Material("vgui/gradient_up", "smooth", "noclamp")

function PANEL:Init()
	self.GradiAlpha = 0

	self.btn = vgui.Create("DButton", self)
	local btn = self.btn
	btn:SetText("")
	btn.DoClick = function(this)
		if self.InAnimation then return end
		self.InAnimation = true

		if IsVALID(self.popup) then
			self.IsOpened = false

			local a, b, c = self:GetWide(), 0, 0.15
			self:OnPopupSizeTo(a, b, c)
			self.popup.SizeTo(self.popup, a, b, c, 0, -1, function()
				self.popup.Remove(self.popup)
				self:OnPopupSizeToEnd(a, b, c)

				timer.Simple(0.2, function()
					if IsValid(self) then
						self.InAnimation = nil
					end
				end)
			end)
			return
		else
			self.IsOpened = true
			self.popup = vgui.Create("Panel", self:GetParent())
			local popup = self.popup
			
			popup.PseudoParent = self
			popup:SetSize(self:GetWide(), 0)

			if g_ContextMenu:IsVisible() and IsValid(g_ContextMenu.NotifyVoteParent) then
				popup:SetParent(g_ContextMenu.NotifyVoteParent)
			end

			popup.Paint = function(this1, w, h)
				DrawBlur(this1)
				SetDrawColor(color.background)
				DrawRect(0, 0, w, h)

				if self.contents then
					local txw, txh = SimpleText(isfunc(self.contents.title) and self.contents.title() or self.contents.title or "title", "rpui.notifyvote.font", 25, 16, colors.title, Align.Left, Align.Top)
					SimpleText(self.contents.desc or "description", "rpui.notifyvote.font", 25, 19 + txh, colors.desc, Align.Left, Align.Top)
				end
			end

			popup.ok = vgui.Create("urf.im/rpui/button", popup)
			local ok = popup.ok
			
			ok:SetText(translates and translates.Get("ЗА") or "ЗА")
			ok:SetFont("rpui.slidermenu.font")
			ok.DoClick = function()
				if self.contents and self.contents.callback then
					self.contents.callback()
				end
			end

			popup.cancel = vgui.Create("urf.im/rpui/button", popup)
			local cancel = popup.cancel
			
			cancel:SetText(translates and translates.Get("ПРОТИВ") or "ПРОТИВ")
			cancel:SetFont("rpui.slidermenu.font")
			cancel.DoClick = self.ButtonNoDoClick or function()
				self:Close()
			end

			local btn_w, btn_h = popup:GetWide()*0.45, 45

			ok:SetSize(btn_w, btn_h)
			cancel:SetSize(btn_w, btn_h)

			local pos_y = self:GetTall()*3 - btn_h - 9 -- 18
			ok:SetPos(popup:GetWide()*0.025, pos_y)
			cancel:SetPos(popup:GetWide() - popup:GetWide()*0.025 - btn_w, pos_y)

			local sx, sy = self:GetPos()
			popup:SetPos(sx, sy + self:GetTall())

			timer.Simple(0, function()
				if (!IsValid(self)) then return end
				local a, b, c = self:GetWide(), self:GetTall()*3 + 9, 0.15
				self:OnPopupSizeTo(a, b, c)
				popup:SizeTo(a, b, c, 0, -1, function()
					self:OnPopupSizeToEnd(a, b, c)
					
					timer.Simple(0.2, function()
						if IsValid(self) then
							self.InAnimation = nil
						end
					end)
				end)
			end)
		end
	end
	self.btn.Icon = Material("rpui/misc/arrow_down.png", "smooth", "noclamp")
	self.btn.Paint = function(this3, w, h)
		SetDrawColor(this3:IsHovered() and self.Colors.InsideHover or self.Colors.Inside)
		SetMaterial(this3.Icon)
		DrawTexturedRect(0, 0, w, h)
	end
end

function PANEL:OnPopupSizeTo() end -- for override
function PANEL:OnPopupSizeToEnd() end -- for override

function PANEL:PerformLayout()
	local sz = self:GetTall()/3
	self.btn.SetSize(self.btn, sz, sz)
	self.btn.SetPos(self.btn, self:GetWide() - sz*2, sz)
end

local Lerp_, FrameTime_, ColorAlpha_ = Lerp, FrameTime, ColorAlpha

function PANEL:Paint(w, h)
	SetDrawColor(self.Colors.Background)
	DrawRect(0, 0, w, h)

	self.GradiAlpha = Lerp_(FrameTime_()*4, self.GradiAlpha, self.DrawGradient and 120 or 0)

	SetDrawColor(ColorAlpha_(self.Colors.InsideHover, self.GradiAlpha))
	SetMaterial(GradiMat)
	DrawTexturedRect(0, 0, w, h)

	-- Icon
	SetDrawColor(self.Colors.Inside)
	SetMaterial(self.Icon)
	local h_3 = h/3 * (self.IcoSizeMult or 1)
	local offset_ = (h - h_3)*0.5
	DrawTexturedRect(offset_, offset_, h_3, h_3)

	-- Title
	SimpleText(self.Title, self.Font or "DermaDefault", h_3 + h/3 + h/6, (h*0.5) + (self.TitleYOffset or 0), self.Colors.Inside, Align.Left, Align.Center)
end

function PANEL:Close()
	if self.ClosingNow then return end
	self.ClosingNow = true

	if self.OnClose then
		self:OnClose()
	end

	local pos_x = self:GetPos()

	if IsVALID(self.popup) then
		self.popup.SizeTo(self.popup, self:GetWide(), 0, 0.15, 0, -1, function()
			self.popup.Remove(self.popup)
			self.InAnimation = nil
		end)

		self.popup.MoveTo(self.popup, pos_x, -45, 0.15)
	end

	self:MoveTo(pos_x, -45, 0.15, 0, -1, function()
		self:Remove()
	end)
end

function PANEL:OnRemove()
	if self.PreRemove then
		self:PreRemove()
	end

	if IsValid(self.popup) then
		self.popup.Remove(self.popup)
	end
end

function PANEL:OnMoveTo(x, y, time, force)
	if IsValid(self.popup) then
		if force then
			self.popup.SetPos(self.popup, x, y + self:GetTall())
		else
			self.popup.MoveTo(self.popup, x, y + self:GetTall(), time)
		end
	end
end

function PANEL:SetContents(title, desc, callback)
	self.contents = {
		["title"] = title,
		["desc"] = desc,
		["callback"] = callback
	}
end

vgui.Register("urf.im/rpui/notifyvote", PANEL, "EditablePanel")

concommand.Add("notifyvote_debug", function(ply, cmd, args)
	if not LocalPlayer():IsRoot() then return end

	local notify = vgui.Create("urf.im/rpui/notifyvote", menu)
	notify:SetSize(400, 45)
	local pos_x = ScrW()*0.5 - notify:GetWide()*0.5
	notify:SetPos(pos_x, -45)
	notify:MoveTo(pos_x, 0, 0.15)

	notify:SetIcon("scoreboard/usergroups/ug_1.png")
	notify:SetTitle(args and args[1] and args[1] or "Голосование")
	notify:SetFont("rpui.playerselect.title")

	notify:SetContents("Событие: Уволить мэра", "Причина: NonRP", function()
		--RunConsoleCommand("demote", ...)
	end)

	timer.Simple(5, function()
		if IsValid(notify) then
			notify:Close()
		end
	end)
end)