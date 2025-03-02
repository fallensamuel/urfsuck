function PIS:SetSettings(ply, tbl)
	ply.pingsSettings = tbl
end

function PIS:SetSetting(ply, setting, value, ignoreSave)
	ply.pingsSettings[setting] = value

	if (ignoreSave) then return end

	PIS:SaveSettings(ply)	
end

function PIS:GetSettings(ply)
	if (!ply.pingsSettings) then
		ply.pingsSettings = PIS.Config.DefaultSettings
	end

	return ply.pingsSettings
end

PING_STATUS_DEFAULT = 0
PING_STATUS_CONFIRMED = 1
PING_STATUS_REJECTED = 2

PING_COMMAND_CONFIRM = 0

PIS.Pings = PIS.Pings or {}

function PIS:AddPing(ply, ping, pos, directedAt)
	self.Pings[isstring(ply) and ply or ply:SteamID64() or "BOT"] = {
		ping = ping, 
		pos = pos,
		directedAt = directedAt,
		author = ply,
		status = PING_STATUS_DEFAULT
	}
end

function PIS:GetPing(ply)
	return self.Pings[isstring(ply) and ply or (ply:IsBot() and "BOT" or ply:SteamID64())]
end

function PIS:RemovePing(ply)
	self.Pings[isstring(ply) and ply or ply:SteamID64() or "BOT"] = nil
end

function PIS:GetKeyName(key)
	if (!isnumber(key)) then return "UNKNOWN KEY" end

	if (key >= MOUSE_MIDDLE) then
		if (key == MOUSE_MIDDLE) then
			return "MIDDLE MOUSE"
		elseif (key == MOUSE_4) then
			return "MOUSE 4"
		elseif (key == MOUSE_5) then
			return "MOUSE 5"
		elseif (key == MOUSE_WHEEL_UP) then
			return "MOUSE WHEEL UP"
		elseif (key == MOUSE_WHEEL_DOWN) then
			return "MOUSE WHEEL DOWN"
		else
			return "UNKNOWN MOUSE"
		end
	else
		return input.GetKeyName(key) and input.GetKeyName(key):upper() or "UNKNOWN KEY"
	end
end

function PIS:GetMuted(ply)
	if (!ply.pingsMuted) then
		ply.pingsMuted = {}
	end

	return ply.pingsMuted
end

function PIS:IsMuted(ply, target)
	return self:GetMuted(ply)[target]
end

function PIS:SetMuted(ply, target, muted)
	self:GetMuted(ply)[target] = muted
end

if (SERVER) then
	hook.Add("PlayerDeath", "PIS.HandleDeathConditions", function(victim)
		PIS.Gamemode:GetOnDeath()(victim)
	end)
end

PIS.PingCache = {}
function PIS:GetPingIcon(id)
	local settings = self:GetSettings(LocalPlayer())
	local pingSet = settings.PingIconSet or 1
	self.PingCache[pingSet] = self.PingCache[pingSet] or {}
	local tbl = self.Config.PingSets[pingSet]
	if (!self.PingCache[pingSet][id]) then
		local mat = self.Config.Pings[isstring(id) and id or self.Config.PingsSorted[id]].mat
		self.PingCache[pingSet][id] = Material("ping_system/" .. tbl.id .. "/" .. mat.. ".png", "smooth")
	end

	return self.PingCache[pingSet][id]
end

function PIS:Get2DDistance(a, b)
	-- Euclidean length
	local dist = math.sqrt(
		(a.x - b.x) ^ 2 + 
		(a.y - b.y) ^ 2
	)
	-- Meter conversion
	dist = dist * (0.0254 / (4/3))

	return dist
end