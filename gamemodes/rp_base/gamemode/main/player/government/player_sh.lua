function PLAYER:IsMayor()
	return rp.teams[self:Team()] and rp.teams[self:Team()].mayor or false
end


if (SERVER) then
	function PLAYER:IsArrested()
		return (rp.ArrestedPlayers[self:SteamID64()] == true)
	end
else
	function PLAYER:IsArrested()
		return (self:GetNetVar('ArrestedInfo') ~= nil)
	end
end

function PLAYER:GetArrestInfo()
	return self:GetNetVar('ArrestedInfo')
end

nw.Register('ArrestedInfo', {
	Read = function()
		return {
			Reason = net.ReadString(),
			Release = net.ReadUInt(32)
		}
	end,
	Write = function(v)
		net.WriteString(v.Reason)
		net.WriteUInt(v.Release, 32)
	end,
	LocalVar = true
})


if rp.cfg.NewWanted then return end


function PLAYER:IsCP()
	return IsValid(self) and self:IsCombine()
end

function PLAYER:IsWanted()
	return (self:GetNetVar('IsWanted') == true)
end

function PLAYER:GetWantedReason()
	return self:GetNetVar('WantedReason')
end

nw.Register'IsWanted':Write(net.WriteBool):Read(net.ReadBool):SetPlayer()

nw.Register'WantedReason':Read(net.ReadString):Write(net.WriteString):SetPlayer()
