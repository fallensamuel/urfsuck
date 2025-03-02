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
ENT.PrintName = "Тыква"
ENT.Category = "Ivent"
ENT.Model = "models/kemot44/models/overwatch/lootboxes/halloween.mdl"

ENT.Cooldown = 5 * 60
ENT.MinPumpkins = 1
ENT.MaxPumpkins = 3
ENT.PumpkinItem = 'rpitem_pumpkin'

rp.AddTerm( 'PumpkinsGot', "Вы нашли # тыкв!" ); 

function ENT:SetupDataTables()
	self:NetworkVar('Float', 0, 'TimeHidden')
end