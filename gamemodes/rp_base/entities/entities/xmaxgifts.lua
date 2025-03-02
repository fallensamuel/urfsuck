AddCSLuaFile()
DEFINE_BASECLASS( "base_anim" )
ENT.Type = "anim"
ENT.Base = "base_entity"
ENT.RenderGroup = RENDERGROUP_BOTH
ENT.PrintName = "Новогодний подарок"
ENT.Author = "ClemensProduction aka Zerochain"
ENT.Information = "info"
ENT.Category = "ivent"
ENT.Model = "models/hunter/blocks/cube025x025x025.mdl"

ENT.Cooldown = 30 * 60

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

if SERVER then
	local tr = translates
	local cached
		if tr then
			cached = {
				tr.Get( 'кредитов' ), 
				tr.Get( 'оружие' ), 
			}
		else
			cached = {
				'кредитов', 
				'оружие', 
			}
		end

	local gift_handler = 
	{
		[GIFT_CREDITS] = function(ply, data)
			local credits = math.ceil(math.random(data.min_amount, data.max_amount))
			ply:AddCredits(credits, 'NY Gift')
			ply:Notify(NOTIFY_GREEN, rp.Term('NewNyGift'), credits .. ' ' .. cached[1])
		end, 
		[GIFT_WEAPON] = function(ply, data)
			local weps = istable(data.weapons) and data.weapons or {data.weapons}
			local weapon = weps[math.random(#weps)]
			
			ply:Give(weapon)
			ply:Notify(NOTIFY_GREEN, rp.Term('NewNyGift'), cached[2] .. ' ' .. (ply:GetWeapon(weapon) and ply:GetWeapon(weapon):GetPrintName() or weapon))
		end, 
		[GIFT_MONEY] = function(ply, data)
			local money = math.ceil(math.random(data.min_amount, data.max_amount))
			ply:AddMoney(money)
			ply:Notify(NOTIFY_GREEN, rp.Term('NewNyGift'), rp.FormatMoney(money))
		end
	}

	function ENT:Initialize()
		self:SetModel( self.Model )
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetMoveType( MOVETYPE_VPHYSICS )
		self:SetSolid( SOLID_VPHYSICS )
		self:DrawShadow(false)
		
		local phys = self:GetPhysicsObject()
		phys:EnableMotion(false)

		self.PhysgunDisabled = true
	end

	function ENT:Use( ply,caller )
		if self.disabled then return end
		
		--[[
		local credits = math.ceil(math.random(self.CreditsMin, self.CreditsMax))
		
		ply:AddCredits(credits, 'NY Gift')
		ply:Notify(NOTIFY_GENERIC, rp.Term('NewNyGift'), credits)
		]]
		
		local chance 	= math.random(100)
		local tiers 	= #self.Gifts
		
		--print(chance)
		
		for k = 1, tiers do
			if chance > self.Gifts[k].chance then
				chance = chance - self.Gifts[k].chance
			else
				--print('nygift', k, self.Gifts[k].gift)
				
				local ply_sid 	= ply:SteamID64()
				local cooldown 	= os.time() + self.Cooldown
				
				gift_handler[self.Gifts[k].gift](ply, self.Gifts[k])
				break
			end
		end
		
		self:Disable()

		self.disabled = CurTime() + self.Cooldown
	end

	function ENT:Think()
		if self.disabled && self.disabled < CurTime() then
			self:Enable()
		end
	end

	function ENT:Enable()
		self:SetNotSolid(false)
		self:SetNoDraw(false)
		self.disabled = false
	end

	function ENT:Disable()
		self:SetNotSolid(true)
		self:SetNoDraw(true)
		self.disabled = true
	end
else
	function ENT:Draw()
		self:DrawModel()
		if(self:GetPos():Distance(LocalPlayer():GetPos()) > 300) then return end
	end
end