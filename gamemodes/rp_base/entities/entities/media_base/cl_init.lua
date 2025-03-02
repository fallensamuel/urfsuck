-- "gamemodes\\rp_base\\entities\\entities\\media_base\\cl_init.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
include'shared.lua'
cvar.Register'media_enable':SetDefault(true):AddMetadata('State', 'RPMenu'):AddMetadata('Menu', 'Медиа-Плеер')
cvar.Register'media_mute_when_unfocused':SetDefault(true):AddMetadata('State', 'RPMenu'):AddMetadata('Menu', 'Заглушить Медиа-Плеер при сворачивании игры')
cvar.Register'media_volume':SetDefault(0.75):AddMetadata('State', 'RPMenu'):AddMetadata('Menu', 'Медиа-Плеер звук'):AddMetadata('Type', 'number')
cvar.Register'media_quality':SetDefault('low')
cvar.Register'media_favs':SetDefault({})

function ENT:Think()
	local link = self:GetURL()
	local shouldplay = cvar.GetValue('media_enable') and (LocalPlayer():EyePos():Distance(self:GetPos()) < 1024)

	if IsValid(self.Media) and (not link or not shouldplay) then
		self.Media:stop()
		self.Media = nil
	elseif shouldplay and (not IsValid(self.Media) or self.Media:getUrl() ~= link) then
		if IsValid(self.Media) then
			self.Media:stop()
			self.Media = nil
		end

		if (link ~= '') then
			local service = medialib.load('media').guessService(link)

			if service then
				local mediaclip = service:load(link, {
					use3D = true,
					ent3D = self
				})

				mediaclip:setVolume((system.HasFocus() and cvar.GetValue('media_volume') or ((not cvar.GetValue('media_mute_when_unfocused')) and cvar.GetValue('media_volume') or 0)))
				mediaclip:setQuality(cvar.GetValue('media_quality'))

				if (self:GetTime() ~= 0) then
					mediaclip:seek(CurTime() - self:GetStart())
				end

				mediaclip:play()
				self.Media = mediaclip
			end
		end
	end
end

local tr = translates
local cached
	if tr then
		cached = {
			tr.Get( "Включите видео нажав на 'E'." ), 
			tr.Get( "Ссылку с YouTube" ), 
		}
	else
		cached = {
			"Включите видео нажав на 'E'.", 
			"Ссылку с YouTube", 
		}
	end

local color_bg = rp.col.Black
local color_text = rp.col.White

function ENT:DrawScreen(x, y, w, h)
	if IsValid(self.Media) then
		self.Media:draw(x, y, w, h)
	else
		draw.Box(x, y, w, h, color_bg)
		draw.SimpleText(cached[1], 'DermaLarge', x + (w * .5), y + (h * .5), color_text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end
end

local fr
local song
local ent
local text
local favs = cvar.GetValue('media_favs')

local function AddRow(p, l, n)
	if (not IsValid(p)) then return end -- menu got closed before the link info loaded
	local media = p:AddRow(n)

	media.DoClick = function(s)
		local m = ui.DermaMenu(self)

		m:AddOption('Play', function()
			if IsValid(ent) then
				rp.RunCommand('playsong', ent:EntIndex(), song.Link)
				song = nil
			end
		end)

		m:AddOption('Remove', function()
			favs[song.Link] = nil
			song:Remove()
			cvar.SetValue('media_favs', favs)
		end)

		m:Open()
		song = s
	end

	media.Link = l
	media.Name = n

	return media
end

net.Receive('rp.MediaMenu', function()
	if IsValid(fr) then
		fr:Close()
	end

	ent = net.ReadEntity()
	local w, h = ScrW() * .45, ScrH() * .6
	local play
	local save

	fr = ui.Create('ui_frame', function(self)
		self:SetTitle(cached[2])
		self:SetSize(w, h)
		self:MakePopup()
		self:Center()
	end)

	local row = ui.Create('ui_listview', function(self, p)
		self:DockToFrame()
		self:SetSize(p:GetWide() - 10, p:GetTall() - 65)

		for k, v in pairs(favs) do
			AddRow(self, k, v)
		end
	end, fr)

	text = ui.Create('DTextEntry', function(self, p)
		self:SetSize(p:GetWide() - 120, 25)
		self:SetPos(5, p:GetTall() - 30)
	end, fr)

	play = ui.Create('DButton', function(self, p)
		self:SetText('Play')
		self:SetSize(50, 25)
		self:SetPos(p:GetWide() - 110, p:GetTall() - 30)

		self.DoClick = function()
			if IsValid(ent) then
				rp.RunCommand('playsong', ent:EntIndex(), text:GetValue() or song.Link)
				song = nil
			end
		end

		self.Think = function(self)
			if (medialib and (not medialib.load('media').guessService(text:GetValue()))) then
				self:SetDisabled(true)
			else
				self:SetDisabled(false)
			end
		end
	end, fr)

	save = ui.Create('DButton', function(self, p)
		self:SetText('Save')
		self:SetSize(50, 25)
		self:SetPos(p:GetWide() - 55, p:GetTall() - 30)

		self.DoClick = function()
			local link = text:GetValue()
			local service = medialib.load('media').guessService(link)

			if service then
				service:query(link, function(err, data)
					favs[link] = data.title
					cvar.SetValue('media_favs', favs)
					AddRow(row, link, data.title)
				end)
			end
		end

		self.Think = function(self)
			if favs[text:GetValue()] or (medialib and (not medialib.load('media').guessService(text:GetValue()))) then
				self:SetDisabled(true)
			else
				self:SetDisabled(false)
			end
		end
	end, fr)
end)