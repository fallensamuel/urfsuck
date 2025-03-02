
rp.cfg.Raids = {
	{
		name = 'Атака Страйдера на D6',
		btn_name = 'striderbutent',
		min_players = 50,
		
		first_raid = .5 * 3600,
		interval = 4 * 3600,
		
		notify_before_raid_time = 1,
	},
	{
		name = 'Атака Улья на D4',
		btn_name = 'lionbutent',
		min_players = 25,
		
		first_raid = 1 * 3600 - 5 * 60,
		interval = 3 * 3600,
		
		notify_before_raid_time = 1,
	},
}


rp.npc.RegisterClass({
	class = 'npc_strider',
	name = 'Страйдер',
	--health = 700000,
	--damage_multiplier = 5,
	
	hud_offset = 0, -- отрицательное чтобы сместить вниз
	draw_radius = 1000,
	
	health_custom = function(ply_count) 
		return 50000 + ply_count * 3000
	end,
	
	damage_multiplier_custom = function(ply_count) 
		return 2 + ply_count * 0.03
	end,
	
	relation_filter = function(ply)
		return ply:IsCombineOrDisguised() || ply:GetFaction() == FACTION_ADMINS || ply:Team() == TEAM_GMAN || ply:Team() == TEAM_PIGEON || ply:Team() == TEAM_CROW || ply:Team() == TEAM_SEAGULL
	end,
	
	damage_filter = function(npc, dmginfo)
		if not dmginfo:IsExplosionDamage() then
			npc:SetHealth(npc:Health() - dmginfo:GetDamage())
		end
	end,
	
	loot = 'strider_loot',
	loot_count = 15,  -- Кол-во предметов из указанного лута в итоговой награде
	loot_time = 120,
	
	reward_radius = 1000,  -- Если не указать, деньги выдадутся убившему
	reward_money = 500,
})

rp.npc.RegisterClass({
	class = 'npc_hunter',
	name = 'Охотник',
	health = 25000,
	
	hud_offset = 900,
	draw_radius = 1000,
	
	relation_filter = function(ply)
		return ply:IsCombineOrDisguised() || ply:GetFaction() == FACTION_ADMINS || ply:Team() == TEAM_GMAN || ply:Team() == TEAM_PIGEON || ply:Team() == TEAM_CROW || ply:Team() == TEAM_SEAGULL
	end,
	
	loot = 'strider_loot',
	loot_count = 10,  -- Кол-во предметов из указанного лута в итоговой награде
	loot_time = 120,

	reward_radius = 500,  -- Если не указать, деньги выдадутся убившему
	reward_money = 250,
})


rp.npc.RegisterClass({
	class = 'npc_antlion',
	name = 'Муравьиный лев',
	health = 1000,
	
	hud_offset = 0,
	draw_radius = 1000,
	
	relation_filter = function(ply)
		return ply:GetFaction() == FACTION_ADMINS || ply:Team() == TEAM_GMAN
	end,
	
	loot_count = 5,  -- Кол-во предметов из указанного лута в итоговой награде
	loot_time = 60,

	reward_radius = 500,  -- Если не указать, деньги выдадутся убившему
	reward_money = 100,
})

rp.npc.RegisterClass({
	class = 'npc_antlionguard',
	name = 'Страж муравьиных львов',
	health = 65000,
	
	hud_offset = 0,
	draw_radius = 1000,
	
	relation_filter = function(ply)
		return ply:GetFaction() == FACTION_ADMINS || ply:Team() == TEAM_GMAN
	end,
	
	loot = 'strider_loot',
	loot_count = 20,  -- Кол-во предметов из указанного лута в итоговой награде
	loot_time = 120,
})
