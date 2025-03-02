-- "gamemodes\\darkrp\\gamemode\\addons\\radiation\\sh_meta.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
--——————————————————P L A Y E R —▬— M E T A——————————————————--

nw.Register"Radiation":Write(net.WriteFloat):Read(net.ReadFloat):SetPlayer()
function PLAYER:GetRadiation()
	return self:GetNetVar("Radiation") or 0
end

function PLAYER:GetRadZombieJob()
	return rp.Radiation.ZombieJobs[self:Team()] or rp.Radiation.ZombieFactions[self:GetFaction()] or rp.Radiation.DefaultJob
end

function PLAYER:IsRadiationZombie()
	return self:GetFaction() == rp.Radiation.ZombieFaction
end

function PLAYER:HasRadiationImunnity()
	return rp.Radiation.ImmunityJobs[self:Team()] or rp.Radiation.ImmunityFactions[self:GetFaction()]
end