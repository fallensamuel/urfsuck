-- "gamemodes\\rp_base\\gamemode\\main\\orgs\\painter_cl.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
rp.orgs = rp.orgs or {}
local sdr = surface.DrawRect
local ssdc = surface.SetDrawColor
local sdor = surface.DrawOutlinedRect
local sdtr = surface.DrawTexturedRect
local sdl = surface.DrawLine
local mf = math.floor
local iimd = input.IsMouseDown
local colg = Color(150, 150, 150, 200)
local coldg = Color(100, 100, 100, 200)
local colTrans = Color(0, 0, 0, 0)
local padding = 0
local dim = 64
local outline = 512 / dim
local cursorSize = 1
local cursorShape = "Square"
local fr

local all_patterns = {"^https?://.*%.jpg", "^https?://.*%.png", "^https?://.*%.jpeg"}

local function IsValidURL(url)
	for _, pattern in ipairs(all_patterns) do
		if string.match(url, pattern) then return true end
	end
end

local set
local text
local ava

local function editorPrem()
	fr = ui.Create('ui_frame', function(self)
		self:SetSize(520, 155)
		self:SetTitle(translates.Get('Изменить флаг организации'))
		self:MakePopup()
		self:Center()

		function self:Think()
			if IsValid(set) and IsValid(text) and IsValidURL(text:GetValue()) then
				set:SetDisabled(false)
			else
				set:SetDisabled(true)
			end
		end
	end)

	text = ui.Create('DTextEntry', function(self, p)
		self:SetPos(5, 90)
		self:SetSize(p:GetWide() - 10, 25)

		self.OnEnter = function(s)
			set:DoClick()
		end
	end, fr)

	ui.Create('DLabel', function(self, p)
		self:SetText(translates.Get("Расширения .jpg и .png! За нецензуру бан.\nФормат ссылки: http://yourdomain.com/image.png"))
		self:SetFont('rp.ui.24')
		self:SetTextColor(rp.col.Close)
		self:SizeToContents()
		self:SetPos((p:GetWide() - self:GetWide()) / 2, 35)
	end, fr)

	set = ui.Create('DButton', function(self, p)
		self:SetText(translates.Get('Изменить'))
		self:SetPos(5, p:GetTall() - 32)
		self:SetSize(p:GetWide() / 2 - 7.5, 25)

		function self:DoClick()
			net.Start('rp.SetOrgBanner')
				net.WriteString(text:GetValue())
			net.SendToServer()
			
			p:Close()
		end
	end, fr)
end

local function editor()
	fr = ui.Create('ui_frame', function(self)
		self:SetSize(600, 400)
		self:SetTitle(translates.Get('Выбрать флаг организации'))
		self:MakePopup()
		self:Center()
	end)
	
	ui.Create('DLabel', function(self, p)
		self:SetText(translates.Get("Купите \'Крутую Организацию\', чтобы устанавливать собственные уникальные баннеры!"))
		self:SetFont('rp.ui.15')
		self:SetTextColor(rp.col.Close)
		self:SizeToContents()
		self:SetPos((p:GetWide() - self:GetWide()) / 2, p:GetTall() - 23)
	end, fr)
	
	set = ui.Create('ui_listview', fr)
	set.Paint = function() end
	
	set:SetPos(5, 32)
	set:SetSize(590, 340)
	
	ava = ui.Create('DPanel', function(self, p) self:SetSize(590, 13 + 96 * math.ceil(#rp.cfg.DefaultOrgBanners / 6)) end, set)
	set:AddItem(ava)
	
	for k, v in pairs(rp.cfg.DefaultOrgBanners) do
		img = ui.Create('DImageButton', function(self, p)
			
			self:SetPos(7 + ((k - 1) % 6) * 96, 7 + math.floor((k - 1) / 6) * 96)
			self:SetSize(94, 94)
			
			if wmat.Get("rp.DefaultOrgBanner." .. k) then
				self:SetMaterial(wmat.Get("rp.DefaultOrgBanner." .. k))
			else
				wmat.Create("rp.DefaultOrgBanner." .. k, {
					URL = v,
					W = 100,
					H = 100
				}, function(material)
					if (IsValid(fr) and IsValid(self)) then
						self:SetMaterial(wmat.Get("rp.DefaultOrgBanner." .. k))
					end
				end, function() end)
			end

			function self:DoClick()
				net.Start('rp.SetOrgBannerDefault')
					net.WriteUInt(k, 8)
				net.SendToServer()
				
				fr:Close()
			end
			
		end, ava)
	end
end

function rp.orgs.OpenOrgBannerEditor()
	if IsValid(fr) then
		fr:Close()
	end
	
	if LocalPlayer():HasUpgrade('org_prem') then
		editorPrem()
	else
		editor()
	end
end

--[[
concommand.Add('convd3banners', function()
	local files = file.Find('d3/banners/*.txt', "DATA")

	for k, v in pairs(files) do
		local data = util.JSONToTable(file.Read('d3/banners/' .. v))

		for i = 0, 63 do
			for k = 0, 63 do
				local px = data[i][k]

				if (px.trans) then
					data[i][k] = 0
				else
					data[i][k] = pcolor.EncodeRGB(px.col)
				end
			end
		end

		file.Write('sup/banners/' .. v, util.TableToJSON(data))
		print("Converted " .. v)
	end
end)
]]
