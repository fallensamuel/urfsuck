if SERVER then return end

local config = include("cfg_cl.lua")

local Material_, surface_CreateFont = Material, surface.CreateFont
local math_floor, string_format = math.floor, string.format
local string_upper = string.upper
local math_abs, math_sin, CurTime_ = math.abs, math.sin, CurTime
local net_ReadBool, net_ReadEntity, IsValid_ = net.ReadBool, net.ReadEntity, IsValid

scoreboard_cache = scoreboard_cache or {}
scoreboard_cache.materials = scoreboard_cache.materials or {}
scoreboard_cache.fonts = scoreboard_cache.fonts or {}

local function load_reacts(steamids)
    --[[
	http_Post("https://urf.im/api/api_reacts_get.php", {steamid = Lply():SteamID64(), steamids = util_TableToJSON(steamids)}, function(result)
        if result and string_len(result) > 0 then
            for k,v in pairs_(util_JSONToTable(result) or {}) do
                local ply = player_GetBySteamID64(string_sub(k, 2, -1))
                
                if IsValid_(ply) then 
                    ply.reacts_data = v
                end
            end
        end
    end)
	]]
end

local function proccess_reacts()
    --[[
    if not IsValid_(Lply()) then return end
    
    local steamids = {}
    
    for k,v in pairs_(player_GetAll()) do
        if v.SteamID64 and not (IsValid_(v) and v:IsBot()) then
            table_insert(steamids, '' .. v:SteamID64())
        end
    end
    
    load_reacts(steamids)
	]]
end


--hook.Add("InitPostEntity", "rp.scoreboard.init_load_reacts", proccess_reacts)
--timer.Create("rp.scoreboard.reload_reacts", 60 * 5, 0, proccess_reacts)
--proccess_reacts()

net.Receive("rp.ScoreboardReact", function()
    local react_set = net_ReadBool()
    local player = net_ReadEntity()
    
    if not IsValid_(player) then return end
    local Lply = LocalPlayer()
    
    if Lply.reacts_data then
        Lply.reacts_data.count = Lply.reacts_data.count + (react_set and 1 or -1)
    else
        Lply.reacts_data = { count = 1, reacted = 0 }
    end
end)

local PMETA = FindMetaTable("Player")
function PMETA:GetReactsTable()
    if IsValid_(self) and not self.reacts_data and not self:IsBot() then
        load_reacts({ self:SteamID64() })
    end
    
    return self.reacts_data or { count = 0, reacted = 0 }
end

local __CahceMaterial = function(path)
	if scoreboard_cache.materials[path] then return scoreboard_cache.materials[path] end

    scoreboard_cache.materials[path] = Material_(path, "smooth", "noclamp")
    return scoreboard_cache.materials[path]
end

return {
	CahceMaterial = __CahceMaterial,
	BuildFont = function(data, cachetab)
	    surface.CreateFont("rpui.incscoreboard.font."..data["name"], {
	        font = config["FontName"],
	        extended = true,
	        antialias = true,
	        size = data["size"],
	        weight = data["weight"] or 500
	    })

	    scoreboard_cache.fonts[data["name"]] = "rpui.incscoreboard.font."..data["name"]
	    cachetab[data["name"]] = "rpui.incscoreboard.font."..data["name"]
	end,
	time2Str = function(time)
		local tmp = time
	    local s = tmp % 60
	    tmp = math_floor(tmp / 60)
	    local m = tmp % 60
	    tmp = math_floor(tmp / 60)
	    local h = tmp % 24
	    tmp = math_floor(tmp / 24)
	    local d = tmp % 7
	    local w = math_floor(tmp / 7)

	    return string_format("%02i:%02i:%02i", h, m, s)
	end,
	GetCountryCode = function(ply)
		return ply.GetCountry and ply:GetCountry() or "ru"
	end,
	GetRankID = function(ply)
		return IsValid(ply) and ply.GetRankTable and ply:GetRankTable():GetID() or 1
	end,
	GetJobName = function(ply)
		return ply.GetJobName and ply:GetJobName() or "ply:GetJobName()"
	end,
	GetOnline = function(ply)
		return ply.GetPlayTime and ba.str.FormatTime(ply:GetPlayTime()) or "24:00:00"
	end,
	GetOs = function(ply)
		return __CahceMaterial("scoreboard/os/"..(ply.GetOS and ply:GetOS() or "win")..".png")
	end,
	GetMuted = function(ply)
		return __CahceMaterial("scoreboard/icons/"..(ply:IsMuted() and "has_muted.png" or "not_muted.png"))
	end,
	first2Upper = function(str)
		return (str:gsub("^%l", string_upper))
	end,
	GetOrgName = function(ply)
		return ply.GetOrg and ply:GetOrg()
	end,
	GetOrgColor = function(ply)
		return ply.GetOrgColor and ply:GetOrgColor()
	end,
	Pulsate = function(c) 
	    return math_abs( math_sin(CurTime_()*c) )
	end,
	IsLiked = function(ply) 
	    return ply:HasLikeReact()
	end,
	GetLikeCount = function(ply) 
	    return ply:GetLikeReacts()
	end
}