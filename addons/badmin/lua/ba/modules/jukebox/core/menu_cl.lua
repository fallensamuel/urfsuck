local function CreateMusicList(parent, tbl, options)
	return ui.Create('DListView', function(self, p)
		self:SetPos(0, 0)
		self:SetSize(p:GetWide(), p:GetTall())
		self:SetMultiSelect(false)
		self:AddColumn('Song')
		self:AddColumn('Artist')
		self:AddColumn('Length'):SetFixedWidth(75)
		self.OnRowSelected = function(panel, line)
			options(self, panel, line)
		end

		for k, v in pairs(tbl) do 
			self:AddLine(v.name, v.artist, math.Round(v.seconds/60, 2))
		end
	end, parent)
end

local JukeboxMenu
local FavsList
function ba.Jukebox.OpenMenu()
	local w, h = ScrW() * .5, ScrH() * .5

	JukeboxMenu = ui.Create('ui_frame', function(self)
		self:SetSize(w, h)
		self:SetTitle('Jukebox')
		self:MakePopup()
		self:Center()
	end)

	local tabs = ui.Create('ui_tablist', function(self)
		self:SetPos(0, 34)
		self:SetSize(w, h - 34)
	end, JukeboxMenu)

	local Songs = ui.Create('ui_panel')
	tabs:AddTab('Songs', Songs, true)

	CreateMusicList(Songs, ba.Jukebox.Songs, function(self, panel, line)
		local song = self:GetLine(line):GetValue(1)
		local artist = self:GetLine(line):GetValue(2)
		local seconds = self:GetLine(line):GetValue(3)

		local menu = DermaMenu(self)
		menu:AddOption('Copy Song', function() 
			SetClipboardText(artist) 
			LocalPlayer():ChatPrint('Copied artist: ' .. artist)
		end):SetIcon('icon16/page_white_copy.png')

		menu:AddOption('Copy Artist', function() 
			SetClipboardText(song) 
			LocalPlayer():ChatPrint('Copied song: ' .. song)
		end):SetIcon('icon16/page_white_copy.png')

		menu:AddSpacer()

		menu:AddOption('Play Song', function() 
			ba.Jukebox.PlaySong(song, ba.Jukebox.Songs[song].hash) 
		end):SetIcon('icon16/sound.png')

		menu:AddSpacer()

		menu:AddOption('Add to favorites', function() 
			if ba.Jukebox.Favs[song] then
				LocalPlayer():ChatPrint('Song: ' .. song .. ' is already in your favorites!')
				return 
			end

			ba.Jukebox.AddFav(song)
			
			FavsList:AddLine(song, artist, seconds)
			FavsList:InvalidateLayout()
		end):SetIcon('icon16/heart.png')

		if LocalPlayer():IsSuperAdmin() then
			menu:AddSpacer()

			menu:AddOption('Play for all', function() 
				RunConsoleCommand('urf', 'broadcastsong', song)
			end):SetIcon('icon16/sound_add.png')
		end

		menu:Open()
	end)

	local Favs = ui.Create('ui_panel')
	tabs:AddTab('Favorites', Favs)

	FavsList = CreateMusicList(Favs, ba.Jukebox.Favs, function(self, panel, line)
		local song = self:GetLine(line):GetValue(1)
		local artist = self:GetLine(line):GetValue(2)
		local seconds = self:GetLine(line):GetValue(3)

		local menu = DermaMenu(self)
		menu:AddOption('Copy Song', function() 
			SetClipboardText(artist) 
			LocalPlayer():ChatPrint('Copied artist: ' .. artist)
		end):SetIcon('icon16/page_white_copy.png')

		menu:AddOption('Copy Artist', function() 
			SetClipboardText(song) 
			LocalPlayer():ChatPrint('Copied song: ' .. song)
		end):SetIcon('icon16/page_white_copy.png')

		menu:AddSpacer()

		menu:AddOption('Play Song', function() 
			ba.Jukebox.PlaySong(song, ba.Jukebox.Songs[song].hash) 
		end):SetIcon('icon16/sound.png')

		menu:AddSpacer()

		menu:AddOption('Remove from favorites', function()
			ba.Jukebox.RemoveFav(song)

			self:RemoveLine(line)
			self:InvalidateLayout()
		end):SetIcon('icon16/heart.png')

		if LocalPlayer():IsSuperAdmin() then
			menu:AddSpacer()

			menu:AddOption('Play for all', function() 
				RunConsoleCommand('urf', 'broadcastsong', song)
			end):SetIcon('icon16/sound_add.png')
		end

		menu:Open()
	end)

	local Settings = ui.Create('ui_panel')
	tabs:AddTab('Settings', Settings)

	ui.Create('ba_checkboxlabel', function(self)
		self:SetPos(5, 5)
		self:SetText('Enable Music')
		self:SetConVar('jukebox_enable')
		self:SizeToContents()
	end, Settings)

	ui.Create('ba_checkboxlabel', function(self)
		self:SetPos(5, 25)
		self:SetText('Enable Visualizer')
		self:SetConVar('jukebox_vis')
		self:SizeToContents()
	end, Settings)
end

hook.Add('Tick', 'Jukebox.Keybind.Tick', function()
	if IsValid(JukeboxMenu) then
		return 
	end
	if input.IsKeyDown(KEY_F10) then
		ba.Jukebox.OpenMenu()
		return
	end
end)


