util.AddNetworkString('Jukebox.Songs')
util.AddNetworkString('Jukebox.Play')

ba.Jukebox._db = ba.Jukebox._db or pmysql.newdb('mysql.lastpenguin.com', 'jukebox', 'xtmhzy45wzdbEb2b', 'jukebox', 3306)

local db = ba.Jukebox._db

local function loadSongs()
	return db:query('SELECT * FROM songs;', function(data)
		if not data then return end

		table.foreach(data, function(k, v)
			ba.Jukebox.Songs[v.name] = {
				hash = v.hash,
				name = v.name,
				artist = v.artist,
				seconds = v.seconds
			}
		end)

		ba.Jukebox.Encoded_Songs = pon2.encode(ba.Jukebox.Songs)
	end)
end
loadSongs()

ba.Jukebox.RefreshSongs = function()
	ba.Jukebox.Songs = {}
	loadSongs()
end

function ba.Jukebox.OpenMenu(pl)
	net.Start('Jukebox.Songs')
		net.WriteStream(ba.Jukebox.Encoded_Songs, pl)
	net.Send(pl)
end

function ba.Jukebox.PlayGlobalSong(song)
	if not ba.Jukebox.Songs[song] then return end
	net.Start('Jukebox.Play')
		net.WriteString(song)
		net.WriteString(ba.Jukebox.Songs[song].hash)
	net.Broadcast()
end