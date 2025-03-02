-- "gamemodes\\darkrp\\entities\\entities\\ny_giftpart\\sh_init.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
DEFINE_BASECLASS( "base_anim" )

game.AddParticles("particles/zpn_candy_vfx.pcf")
PrecacheParticleSystem("zpn_candy01_fx")
PrecacheParticleSystem("zpn_candy02_fx")
PrecacheParticleSystem("zpn_candy03_fx")

ENT.Type = "anim"
ENT.Base = "base_entity"
ENT.RenderGroup = RENDERGROUP_BOTH
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.PrintName = "Часть Подарка"
ENT.Category = "Ивенты URF"
ENT.Model = "models/gift/christmas_gift.mdl"

ENT.Cooldown = 5 * 60
ENT.MinPumpkins = 1
ENT.MaxPumpkins = 3
ENT.PumpkinItem = 'ny_item'

rp.AddTerm( 'GiftpartGot', "Вы нашли # частей подарков!" ); 

function ENT:SetupDataTables()
	self:NetworkVar('Float', 0, 'TimeHidden')
end