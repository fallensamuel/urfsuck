-- "gamemodes\\rp_base\\gamemode\\addons\\auctions\\sh_utilities.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
module( "auctions", package.seeall );

----------------------------------------------------------------
utils = utils or {};

utils.m_time = {
    { k = translates.Get("дн."), v = 86400, h = true },
    { k = translates.Get("ч."), v = 3600 },
    { k = translates.Get("м."), v = 60 },
    { k = translates.Get("с."), v = 1 }
};

utils.m_servernames = {
    ["darkrpurfim"] = "Пацанское РП",
    ["durka"] = "Дурка РП",
    ["fnaf"] = "FNAF RP: Аниматроники",
    ["hl2rp"] = "HL2RP: За Фримэном",
    ["hl2rp_classic"] = "HL2RP: Classic",
    ["hl2rp_alyx"] = "HLAlyx RP: Сити-17",
    ["metro"] = "Metro RP: Мертвая Москва",
    ["scp"] = "SCP:RP",
    ["stalker"] = "Stalker RP: Сердце Зоны",
    ["starwars"] = "SWRP: Закат Республики",
    ["syria"] = "Military RP: Битва за Сирию",
    ["ww2"] = "WW2 RP: Жизнь в Оккупации",

    ["ww2_france"] = "BERLIN 1945",
    ["afg_france"] = "Armée Française en Irak",
    ["alyx_france_franchise"] = "Half Life:Alyx RP",
};

utils.FormattedTime = function( t, separator )
    separator = separator or " ";

    local out = {};

    for _, timedata in ipairs( utils.m_time ) do
        local v = math.floor( t / timedata.v );
        if timedata.h and v < 1 then continue end

        t = t - timedata.v * v;
        out[#out + 1] = v .. " " .. timedata.k;
    end

    return table.concat( out, separator );
end

utils.GetServerName = function( server_id )
    return utils.m_servernames[server_id] or server_id;
end

if CLIENT then
    hook.Add( "OnAuctionTimeSynced", "auctions.utils::SyncTime", function( t )
        utils.fl_TimeInit, utils.fl_Time = SysTime(), t;
    end );

    utils.SyncedTime = function()
        return utils.fl_Time and (utils.fl_Time + (SysTime() - utils.fl_TimeInit)) or os.time();
    end

    SyncedTime = utils.SyncedTime;
end

----------------------------------------------------------------
GetServerName = utils.GetServerName;
FormattedTime = utils.FormattedTime;
