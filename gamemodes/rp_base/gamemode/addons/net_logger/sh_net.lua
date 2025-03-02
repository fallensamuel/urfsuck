-- "gamemodes\\rp_base\\gamemode\\addons\\net_logger\\sh_net.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
NetLogger = NetLogger or {}
NetLogger.ListType = "BlackList" -- "BlackList" or "WhiteList" -- for save in sql
NetLogger.BlackList = {
    ["Example"] = true,
}

NetLogger.WhiteList = {
    ["Example"] = true,
}

NetLogger.HasAccess = function(ply)
    return ply:HasFlag('x')
end

NetLogger.NeedSave = NetLogger.NeedSave or {}
function NetLogger.Log(str,len)
    if NetLogger.dbConnected then
        if NetLogger.ListType == "WhiteList" then
            if NetLogger.WhiteList and not NetLogger.WhiteList[str] then return end
        elseif NetLogger.ListType == "BlackList" then
            if NetLogger.BlackList and NetLogger.BlackList[str] then return end
        end
    end
    if NetLogger.Data[str] then
        NetLogger.Data[str].runs = NetLogger.Data[str].runs + 1
        if NetLogger.Data[str].maxlen < len then NetLogger.Data[str].maxlen = len end
        if NetLogger.Data[str].midlen ~= len then
            if NetLogger.Data[str].midlen > len then
                NetLogger.Data[str].midlen = (NetLogger.Data[str].midlen/len)/NetLogger.Data[str].runs*len
            else
                NetLogger.Data[str].midlen = (len/NetLogger.Data[str].midlen)/NetLogger.Data[str].runs*NetLogger.Data[str].midlen
            end
        end
    else
        NetLogger.Data[str] = {
            runs = 1,
            maxlen = len,
            midlen = len,
        }
    end
    NetLogger.NeedSave[str] = true
end