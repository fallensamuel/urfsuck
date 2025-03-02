AddCSLuaFile("cl_init.lua")
AddCSLuaFile("sh_init.lua")
include("sh_init.lua")

function ENT:Initialize()
	self:SetModel( self.Model )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:DrawShadow(false)
	
	local phys = self:GetPhysicsObject()
	phys:EnableMotion(false)
	
	--print('GETTING COOLDOWNS')
	timer.Simple(3, function()
		rp._Stats:Query("SELECT * FROM ny_gift_cooldowns;", function(data)
			--print('COOLDOWNS GOTTEN')
			if not data then return end
			
			self.ply_cooldowns = {}
			
			for k,v in pairs(data) do 
				self.ply_cooldowns[v.steamid] = v.cooldown
			end
		end)
	end)
	
	self.next_use = {}
	self.PhysgunDisabled = true
end

local gift_handler = 
{
	[1] = function(ply, data)
		local credits = math.ceil(math.random(data.min_amount, data.max_amount))
		ply:AddCredits(credits, 'NY Gift')
		ply:Notify(NOTIFY_GREEN, rp.Term('NewNyGift'), credits .. ' кредитов')
	end, 
	[2] = function(ply, data)
		local weps = istable(data.weapons) and data.weapons or {data.weapons}
		local weapon = weps[math.random(#weps)]
		
		ply:Give(weapon)
		ply:Notify(NOTIFY_GREEN, rp.Term('NewNyGift'), 'оружие ' .. (ply:GetWeapon(weapon) and ply:GetWeapon(weapon):GetPrintName() or weapon))
	end, 
	[3] = function(ply, data)
		local money = math.ceil(math.random(data.min_amount, data.max_amount))
		ply:AddMoney(money)
		ply:Notify(NOTIFY_GREEN, rp.Term('NewNyGift'), rp.FormatMoney(money))
	end
}

function ENT:Use( ply )
	if not self.ply_cooldowns then return end
	if self.next_use[ply:SteamID64()] and self.next_use[ply:SteamID64()] > CurTime() then return end
	
	self.next_use[ply:SteamID64()] = CurTime() + 0.5
	
	if self.ply_cooldowns[ply:SteamID64()] and self.ply_cooldowns[ply:SteamID64()] > os.time() then
		local time_left = self.ply_cooldowns[ply:SteamID64()] - os.time()
		
		local hours 	= math.floor(time_left / 3600)
		time_left = time_left - hours * 3600
		
		local minutes 	= math.floor(time_left / 60)
		time_left = time_left - minutes * 60
		
		ply:Notify(NOTIFY_ERROR, rp.Term('NewNyGiftCooldown'), hours .. ':' .. (minutes < 10 and '0' .. minutes or minutes) .. ':' .. (time_left < 10 and '0' .. time_left or time_left))
		return
	end
	
	local chance 	= math.random(100)
	local tiers 	= #self.Gifts
	
	for k = 1, tiers do
		if chance > self.Gifts[k].chance then
			chance = chance - self.Gifts[k].chance
		else
			--print('nygift', k)
			
			local ply_sid 	= ply:SteamID64()
			local cooldown 	= os.time() + self.Cooldown
			
			rp._Stats:Query("REPLACE INTO ny_gift_cooldowns SET steamid = ?, cooldown = ?;", ply_sid, cooldown, function(data)
				gift_handler[self.Gifts[k].gift](ply, self.Gifts[k])
				self.ply_cooldowns[ply:SteamID64()] = cooldown
			end)
			
			break
		end
	end
end

hook.Add("InitPostEntity", "rp.NYGift.Spawner", function()
	--print('CREATING TABLE FOR NY GIFTS')
	rp._Stats:Query("CREATE TABLE IF NOT EXISTS `ny_gift_cooldowns` (`steamid` bigint(20) NOT NULL,`cooldown` int(12) NOT NULL, PRIMARY KEY (`steamid`));")
end)
