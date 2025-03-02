-- "gamemodes\\rp_base\\gamemode\\main\\ui\\main_cl.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local surface = surface
local render = render
rp.ui = rp.ui or {}

local vguiFucs = { -- TODO: FIX
	['DListView'] = function(self, p)
		for k, v in ipairs(self.Columns) do
			v:SetTextColor(rp.col.Close)
		end
	end,
	['DCollapsibleCategory'] = function(self, p)
		self.Header:SetFont('rp.ui.20')
		self.Header:SetTextColor(rp.col.ButtonText)
	end,
	['DTextEntry'] = function(self, p)
		self:SetFont('rp.ui.20')
	end,
	['DLabel'] = function(self, p)
		self:SetFont('rp.ui.22')
		self:SetColor(rp.col.ButtonText)
	end,
	['DButton'] = function(self, p)
		self:SetFont('rp.ui.20')
	end
}

function rp.ui.Label(txt, font, x, y, parent)
	return ui.Create('DLabel', function(self, p)
		self:SetText(txt)
		self:SetFont(font)
		self:SetTextColor(rp.col.White)
		self:SetPos(x, y)
		self:SizeToContents()
		self:SetWrap(true)
		self:SetAutoStretchVertical(true)
	end, parent)
end

function ui.DermaMenu(p)
	local m = DermaMenu(p)
	m:SetSkin('Roleplay')

	return m
end

--
-- Draw Shit
--
local color_bg = Color(0, 0, 0)
local color_outline = Color(245, 245, 245)
local math_clamp = math.Clamp
local Color = Color

function rp.ui.DrawBar(x, y, w, h, perc)
	local color = Color(255 - (perc * 255), perc * 255, 0, 255)
	draw.OutlinedBox(x, y, math_clamp((w * perc), 3, w), h, color, color_outline)
end

function rp.ui.DrawProgress(x, y, w, h, perc)
	local color = Color(255 - (perc * 255), perc * 255, 0, 255)
	draw.OutlinedBox(x, y, w, h, color_bg, color_outline)
	draw.OutlinedBox(x + 5, y + 5, math_clamp((w * perc) - 10, 3, w), h - 10, color, color_outline)
end