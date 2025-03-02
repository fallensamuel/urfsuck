DEFINE_BASECLASS( "base_anim" )

ENT.Type = "anim"
ENT.Base = "base_entity"
ENT.RenderGroup = RENDERGROUP_BOTH
ENT.PrintName = "Новогодний подарок"
ENT.Category = "ivent"
ENT.Model = "models/hunter/blocks/cube05x05x05.mdl"

local GIFT_CREDITS 	= 1
local GIFT_WEAPON 	= 2
local GIFT_MONEY 	= 3

ENT.Cooldown = 24 * 60 * 60
ENT.Gifts = 
{
	[1] = {
		chance = 60, 
		gift = GIFT_CREDITS,
		min_amount = 20, 
		max_amount = 50
	},
	[2] = {
		chance = 30, 
		gift = GIFT_WEAPON, 
		weapons = {"weapon_pistol", "weapon_smg1"}
	},
	[3] = {
		chance = 7, 
		gift = GIFT_MONEY, 
		min_amount = 500, 
		max_amount = 1000
	},
	[4] = {
		chance = 3, 
		gift = GIFT_CREDITS,
		min_amount = 100, 
		max_amount = 150
	},
}
