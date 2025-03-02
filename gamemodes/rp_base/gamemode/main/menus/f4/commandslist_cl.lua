-- "gamemodes\\rp_base\\gamemode\\main\\menus\\f4\\commandslist_cl.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local commands = {}

function getcmds() return commands end

function rp.AddMenuCommand(cat, name, cback, custom, icon_crc)
	if (not commands[cat]) then
		commands[cat] = {}
	end

	table.insert(commands[cat], {
		name = name,
		cback = cback,
		custom = custom or function() return true end,
		icon = icon_crc
	})
end

local PANEL = {}

function PANEL:Init()
	self.Cats = {}
	self.Rows = {}
	self.List = ui.Create('ui_listview', self)
	self.List.Paint = function() end
	self:AddCat(rp.cfg.MenuCategoryMoney, commands[rp.cfg.MenuCategoryMoney])
	self:AddCat(rp.cfg.MenuCategoryActions, commands[rp.cfg.MenuCategoryActions])
	self:AddCat(rp.cfg.MenuCategoryRoleplay, commands[rp.cfg.MenuCategoryRoleplay])

	if LocalPlayer():IsMayor() then
		self:AddCat(rp.cfg.MenuCategoryMayor, commands[rp.cfg.MenuCategoryMayor])
	end

	if LocalPlayer():IsCP() or LocalPlayer():IsMayor() then
		self:AddCat(rp.cfg.MenuCategoryPolice, commands[rp.cfg.MenuCategoryPolice])
	end

	self.Cats[rp.cfg.MenuCategoryMayor] = true
	self.Cats[rp.cfg.MenuCategoryPolice] = true

	for k, v in pairs(commands) do
		self:AddCat(k, v)
	end
end

function PANEL:PerformLayout()
	self.List:SetPos(5, 5)
	self.List:SetSize(self:GetWide() - 10, self:GetTall() - 10)
end

function PANEL:AddCat(cat, tab)
	tab = table.FilterCopy(tab or {}, function(v) return v.custom() end)

	if (#tab > 0) then
		if (not self.Cats[cat]) then
			self.List:AddSpacer(cat):SetSize(self.List:GetWide(), 25)

			for k, v in ipairs(tab) do
				local row = self.List:AddRow(v.name)
				row:SetSize(self.List:GetWide(), 25)

				row.DoClick = isstring(v.cback) and function()
					rp.RunCommand(v.cback)
				end or v.cback

				table.insert(self.Rows, row)
			end

			self.Cats[cat] = true
		end
	end
end

vgui.Register('rp_commandlist', PANEL, 'Panel')