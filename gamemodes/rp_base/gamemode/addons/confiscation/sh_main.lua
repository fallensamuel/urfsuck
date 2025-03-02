-- "gamemodes\\rp_base\\gamemode\\addons\\confiscation\\sh_main.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local confiscation_blacklist = {}

function PLAYER:CanConfiscateBy(ply)
	if rp.cfg.DisableConfiscation then return false end
	self.Confiscate = self.Confiscate or {}

	return self:IsHandcuffed() and (self.Confiscate[ply:SteamID64()] or 0) < CurTime() and not (confiscation_blacklist[ply:GetFaction() or -1] and confiscation_blacklist[ply:GetFaction() or -1][self:GetFaction() or -1])
end

function rp.SetConfiscateBlacklist(faction, blacklist)
	confiscation_blacklist[faction] = blacklist
end

function rp.GetConfiscationTime(actor)
	return (rp.cfg.ConfiscationTime or 5)
end

rp.cfg.ConfiscationWeapons = {}
function rp.AddConfiscationWeapon(class, price)
	if istable(class) then
		for k, v in pairs(class) do
			rp.cfg.ConfiscationWeapons[v] = price
		end
	else
		rp.cfg.ConfiscationWeapons[class] = price
	end
end

--rp.AddConfiscationWeapon("swb_honeybadger", 111)
--rp.AddConfiscationWeapon("swb_m9ak47", 222)
--rp.AddConfiscationWeapon("swb_ak74", 333)
--rp.AddConfiscationWeapon("swb_amd65", 444)
--rp.AddConfiscationWeapon("swb_an94", 555)
