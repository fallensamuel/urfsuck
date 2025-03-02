if (CLIENT) then
	require'geoip'

	net('rp.ScoreboardStats', function()
		geoip.Get(net.ReadString(), function(dat)
			net.Start('rp.ScoreboardStats')
			net.WriteString((dat and dat.country and dat.countryCode) or 'RU')
			local o

			if system.IsWindows() then
				o = 1
			elseif system.IsOSX() then
				o = 2
			else
				o = 3
			end

			net.WriteUInt(o, 2)
			net.SendToServer()
		end)
	end)
end

local OS_Translations = {
	[1] = 'windows',
	[2] = 'osx',
	[3] = 'linux'
}

local PMETA = FindMetaTable("Player")

function PMETA:GetOS()
	return OS_Translations[self:GetNetVar('OS') or 1] or 'windows'
end

function PMETA:GetCountry()
	return self:GetNetVar('Country') or 'RU'
end

nw.Register'OS':Write(net.WriteUInt, 2):Read(net.ReadUInt, 2):SetPlayer()
nw.Register'Country':Write(net.WriteString):Read(net.ReadString):SetPlayer()
