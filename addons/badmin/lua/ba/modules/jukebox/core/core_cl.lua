local file = file
local Color = Color
local IsValid = IsValid
local LocalPlayer = LocalPlayer
local http = http
local sound = sound
local pairs = pairs
local ScrW = ScrW
local ScrH = ScrH
local draw = draw
local math = math
local FFT = FFT
local ipairs = ipairs 
local GetTime = GetTime
local GetEndLength = GetEndLength

local sw = ScrW()
local sh = ScrH()

local color_white = Color(240,240,240)
local color_black = Color(0,0,0)
local color_green = Color(0,200,0)
local color_yellow = Color(255,255,0)
local color_orange = Color(255,150,0)
local color_red = Color(200,50,0)

cvar.Create('jukebox_enable', true, function(cvar, old_value, new_value)
	if (new_value == false) then
		ba.Jukebox.StopMusic()
	end
end)
cvar.Create('jukebox_vis', true)
cvar.Create('jukebox_favs', {})

ba.Jukebox.Favs = (cvar.GetValue('jukebox_favs') or {})

function ba.Jukebox.AddFav(song)
	if not ba.Jukebox.Songs[song] then
		LocalPlayer():ChatPrint('Song: ' .. song .. ' does not exist!')
		return 
	end

	if ba.Jukebox.Favs[song] then
		LocalPlayer():ChatPrint('Song: ' .. song .. ' is already in your favorites!')
		return 
	end

	local index = ba.Jukebox.Songs[song]

	ba.Jukebox.Favs[song] = {
		hash = index.hash,
		name = index.name,
		artist = index.artist,
		seconds = index.seconds
	}
	PrintTable(ba.Jukebox.Favs)
	cvar.SetValue('jukebox_favs', ba.Jukebox.Favs)

	LocalPlayer():ChatPrint('Song: ' .. song .. ' added to favorites.')
end

function ba.Jukebox.RemoveFav(song)
	if not ba.Jukebox.Favs[song] then
		LocalPlayer():ChatPrint('Song: ' .. song .. ' is not in your favorites!')
		return 
	end

	ba.Jukebox.Favs[song] = nil

	cvar.SetValue('jukebox_favs', ba.Jukebox.Favs)

	LocalPlayer():ChatPrint('Song: ' .. song .. ' removed from favorites.')
end

function ba.Jukebox.PlaySong(song, hash)
	if not cvar.GetValue('jukebox_enable') then return end

	RunConsoleCommand('stopsound')

	if IsValid(ba.Jukebox.CurrentSong) then
		ba.Jukebox.CurrentSong:Stop()
	end

	sound.PlayURL('http://superiorservers.co/apps/jukebox/songs/' .. hash .. '.mp3', '', function(stream)
		if IsValid(stream) then
			stream:SetVolume(1)
			stream:Play()

			ba.Jukebox.CurrentSong = stream

			ba.Jukebox.SongName = song

			LocalPlayer():ChatPrint('Playing song: ' .. song)
		else
			LocalPlayer():ChatPrint('Uh oh there was an error playing ' .. song)
		end
	end)
end

net.Receive('Jukebox.Play', function()
	local song = net.ReadString()
	local hash = net.ReadString()

	ba.Jukebox.PlaySong(song, hash)
end)

net.Receive('Jukebox.Songs', function()
	net.ReadStream(function(data)
		ba.Jukebox.Songs = pon2.decode(data)
		
		ba.Jukebox.OpenMenu()
	end)
end)

function ba.Jukebox.StopMusic()
	if IsValid(ba.Jukebox.CurrentSong) then
		ba.Jukebox.CurrentSong:Stop()
	end
end


// Visualizer
local VisH = sh * .2
local function variableCol(val)
	if val <= (VisH)/3 then
		return color_green
	elseif val > (VisH)/3 and val < (VisH)/2 then
		return color_yellow
	elseif val > (VisH)/2 and val < (VisH)/1.3 then
		return color_orange
	elseif val >= (VisH)/1.3 then
		return color_red
	end
end

hook.Add('HUDPaint', 'Jukebox.Visualizer.HUDPaint', function()
	if not cvar.GetValue('jukebox_vis') then return end
	if not IsValid(ba.Jukebox.CurrentSong) then return end

	local time = ba.Jukebox.CurrentSong:GetTime()
	local len = ba.Jukebox.CurrentSong:GetLength()

	if time >= len then return end

	local fft = {}
	local stream = ba.Jukebox.CurrentSong:FFT(fft, 6)

	for k, v in ipairs(fft) do
		if k * 3 > sw/2 then break end
		local h = math.Clamp(v * (sh * 1.25), 2, VisH)
		draw.Box(sw/2 + sw * .25 - k * 3, (sh - 5) - h, 2, h,  variableCol(h))
	end

	if time < 20 then
		draw.SimpleTextOutlined(ba.Jukebox.SongName, 'ba.ui.22', sw/2,  sh - 5 - VisH/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, color_black)
	end

	draw.Box(sw/2 - sw * .25, sh - 5, sw * .5, 5, color_black)
	draw.Box(sw/2 - sw * .25, sh - 5, (sw * .5) * (time/len), 5, color_red)
end)
