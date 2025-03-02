local SimpleTimer = timer.Simple
local WriteUInt = net.WriteUInt
local GetKeys = table.GetKeys
local Copy = table.Copy
local Insert = table.insert

local CustomPlayTimeKeys = GetKeys(rp.CustomPlayTime)

local function Sync(Player, DataTable)
    Player:SetNetVar('CustomPlayTime', DataTable)

    Player.CustomPlayTime = Player.CustomPlayTime or {}
    for Key, Value in pairs(DataTable) do
        Player.CustomPlayTime[Value.id] = Value.time
    end
end

local ValidTable, CreatePattern, SID64, Played, ReallyNeed
local function TryToSync(Player)
	if table.Count(rp.CustomPlayTime) == 0 then return end
    SID64 = Player:SteamID64()
    rp._Stats:Query('SELECT * FROM `custom_playtime` WHERE steamid=?;', SID64, function(DataTable)
		if not IsValid(Player) then return end
		
        ValidTable = Copy(rp.CustomPlayTime)
        CreatePattern = 'INSERT INTO `custom_playtime` VALUES '
        for Index, Row in pairs(DataTable) do
            ValidTable[Row.id or '?'] = nil
        end
        Played = Player:GetPlayTime() or 0
        ReallyNeed = false
        for Key, Value in pairs(ValidTable) do
            ReallyNeed = true
            CreatePattern = CreatePattern .. '(?, ' .. SID64 .. ', ' .. Played .. '),'
            Insert(DataTable, {id = Key, time = Played})
        end
        CreatePattern = CreatePattern:TrimRight(',') .. ';'
        if (ReallyNeed) then
            rp._Stats:Query(CreatePattern, unpack(GetKeys(ValidTable)))
        end
        Sync(Player, DataTable)
    end)
end

hook.Add('PlayerInitialSpawn', 'CustomPlayTime.OnConnect', function(Player)
    SimpleTimer(3, function()
        if (IsValid(Player)) then TryToSync(Player) end
    end)
end)

hook.Add('Initialize', 'CustomPlayTime.Table', function()
    SimpleTimer(1, function()
        local Database = ba.data.GetDB()
        Database:query_ex(
            [[CREATE TABLE IF NOT EXISTS `custom_playtime` (
            `id` varchar(32) COLLATE utf8_unicode_ci NOT NULL,
            `steamid` bigint(20) NOT NULL,
            `time` int(11) NOT NULL,
			PRIMARY KEY(`id`, `steamid`)
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;]]
        )
    end)
end)