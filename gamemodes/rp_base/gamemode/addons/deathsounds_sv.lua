
--[[
local deathSongsCP = {
	Sound("npc/metropolice/die1.wav"),
	Sound("npc/metropolice/die2.wav"),
	Sound("npc/metropolice/die3.wav"),
	Sound("npc/metropolice/die4.wav")
}

local deathSongsOTA = {
	Sound("npc/metropolice/die1.wav"),
	Sound("npc/metropolice/die2.wav"),
	Sound("npc/metropolice/die3.wav"),
	Sound("npc/metropolice/die4.wav")
}

local deathSongsZombie = {
	Sound("npc/zombie/zombie_die1.wav"),
	Sound("npc/zombie/zombie_die2.wav"),
	Sound("npc/zombie/zombie_die3.wav"),
}
]]

local table_Random = table.Random
local death_sound

hook.Add("PlayerDeath", function(ply)
	death_sound = nil
	
	if ply:IsDisguised() then
		death_sound = ply:GetDisguiseJobTable().deathSound
	else 
		death_sound = ply:GetJobTable().deathSound
	end
	
	if death_sound == nil then
		death_sound = rp.cfg.DeathSound
	end
	
	if death_sound ~= false then 
		ply:EmitSound(table_Random(istable(death_sound) and death_sound or {death_sound}), 75)
		
		--[[
		if ply:IsCombineOrDisguised() then
			ply:EmitSound(table_Random(ply:GetFaction() == FACTION_COMBINE && deathSongsCP || deathSongsOTA), 75)
			
		elseif ply:IsZombie() then
			ply:EmitSound(table_Random(deathSongsZombie), 75)
		end
		]]
	end
end)
