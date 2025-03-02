
-- META
function PLAYER:SetNickEmoji(id)
	rp._Stats:Query("REPLACE INTO `player_emoji`(`steamid`, `emoji_id`) VALUES(?, ?);", self:SteamID64(), id, function(data)
		self:SetNetVar('NickEmoji', id)
		rp.Notify(self, NOTIFY_GREEN, rp.Term('EmojiSetup'))
	end)
end

-- HOOKS
hook.Add('InitPostEntity', 'Emoji::Initialize', function()
	rp._Stats:Query("CREATE TABLE IF NOT EXISTS `player_emoji` (`steamid` bigint(20) NOT NULL,`emoji_id` text NOT NULL,PRIMARY KEY (`steamid`)) ENGINE=InnoDB DEFAULT CHARSET=utf8;")
end)

hook.Add('playerRankLoaded', 'Emoji::LoadPlayer', function(ply)
	rp._Stats:Query("SELECT `emoji_id` FROM `player_emoji` WHERE `steamid` = ?;", ply:SteamID64(), function(data)
		--PrintTable(data or {})
		if not IsValid(ply) or not data or not data[1] then return end
		ply:SetNetVar('NickEmoji', data[1].emoji_id)
	end)
end)