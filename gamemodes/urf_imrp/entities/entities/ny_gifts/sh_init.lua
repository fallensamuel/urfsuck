DEFINE_BASECLASS( "base_anim" )

ENT.Type = "anim"
ENT.Base = "base_entity"
ENT.RenderGroup = RENDERGROUP_BOTH
ENT.Spawnable = false
ENT.AdminSpawnable = false
ENT.PrintName = "Новогодняя Ёлка"
ENT.Category = "ivent"
ENT.Model = "models/unconid/xmas/xmas_tree.mdl"
ENT.AdminOnly	= true
local GIFT_CREDITS 	= 1
local GIFT_WEAPON 	= 2
local GIFT_MONEY 	= 3

ENT.Cooldown = 24 * 60 * 60
ENT.Gifts = 
{
	[1] = {
		chance = 70, 
		gift = GIFT_MONEY, 
		min_amount = 25000, 
		max_amount = 30000
	},
	[2] = {
		chance = 25, 
		gift = GIFT_CREDITS,
		min_amount = 25, 
		max_amount = 30
	},
	[3] = {
		chance = 5, 
		gift = GIFT_CREDITS,
		min_amount = 45, 
		max_amount = 55
	},
}
