-- "gamemodes\\rp_base\\entities\\entities\\urfim_video\\shared.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName		= "Video"
ENT.Author			= "urf.im & Beelzebub"
ENT.Contact			= "urf.im/page/legal"
ENT.Category        = "Media"
ENT.Spawnable       = true
ENT.IsUrfVideo 		= true
ENT.MaxUseDistance  = 350^2

ENT.Services = {
	[0] = "Youtube",
	[1] = "Twitch"
}

function ENT:SetupDataTables()
	self:NetworkVar("String", 0, "VideoID")
	self:NetworkVar("String", 1, "WhoStart")
	self:NetworkVar("Int", 0, "StartTime")
	self:NetworkVar("Int", 1, "PlayerType")
	self:NetworkVar("Int", 2, "Service")
end

function ENT:GetType()
	return self.Types[ self:GetPlayerType() ]
end