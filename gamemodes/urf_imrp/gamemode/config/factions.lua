
FACTION_CITIZEN = rp.AddFaction({name = 'Citizen', printName = 'Гражданские', npcs = {
	rp_city17_alyx_urfim = {
		{Vector(2504, 4801, 96), Angle(0, 180, 0), 'models/teslacloud/cityadmin/female01.mdl'}
	},
},
OnSpawn = function(ent)
		ent:SetSkin(0)
		ent:SetBodygroup(1, 1)
		ent:SetBodygroup(2, 0)
		ent:SetBodygroup(3, 0)
		ent:SetBodygroup(4, 0)
		ent:SetBodygroup(5, 0)
		ent:SetBodygroup(6, 11) 
		ent:SetBodygroup(7, 0)
		ent:SetBodygroup(8, 3)
	end,
	BubbleColor = Color(115, 146, 255), BubbleIcon = "rpui/standart.png"
})

FACTION_CWU = rp.AddFaction({name = 'CWU', printName = 'ГСР', npcs = {
	rp_city17_alyx_urfim = {
		{Vector(3168, 5148, 64), Angle(0, -45, 0), 'models/daemon_alyx/players/male_citizen_02.mdl'}
	},
},
OnSpawn = function(ent)
		ent:SetSkin(0)
		ent:SetBodygroup(1, 1)
		ent:SetBodygroup(2, 0)
		ent:SetBodygroup(3, 0)
		ent:SetBodygroup(4, 0)
		ent:SetBodygroup(5, 0)
		ent:SetBodygroup(6, 11) 
		ent:SetBodygroup(7, 0)
		ent:SetBodygroup(8, 3)
	end,
	BubbleColor = Color(255, 140, 0), BubbleIcon = "org_icons/hl2/cwu.png"
})

FACTION_REBEL = rp.AddFaction({name = 'Rebel', printName = 'Сопротивление', npcs = {
	rp_city17_alyx_urfim = {
		{Vector(-4648, -1187, 0), Angle(0.000, 0.000, 0.000), 'models/daemon_alyx/players/male_citizen_01.mdl'},
	},
}, 
	OTARelations = Color(255, 0, 0),
	OnSpawn = function(ent)
		ent:SetSkin(0)
		ent:SetBodygroup(1, 1)
		ent:SetBodygroup(2, 1)
		ent:SetBodygroup(3, 2)
		ent:SetBodygroup(4, 0)
		ent:SetBodygroup(5, 0)
		ent:SetBodygroup(6, 1) 
		ent:SetBodygroup(7, 1)
		ent:SetBodygroup(8, 0)
	end,
BubbleColor = Color(34, 139, 34), BubbleIcon = "org_icons/hl2/rebels.png"})

FACTION_MPF = rp.AddFaction({name = 'Combine', printName = 'MPF', npcs = {
	rp_city17_alyx_urfim = {
		{Vector(5346, 3956, 64), Angle(0, -90, 0), 'models/rrp/metropolice/pm/umetropolicepm.mdl'}
	},
}, footstepSound = {
    Sound("npc/metropolice/gear1.wav"),
    Sound("npc/metropolice/gear2.wav"),
    Sound("npc/metropolice/gear3.wav"),
    Sound("npc/metropolice/gear4.wav"),
    Sound("npc/metropolice/gear5.wav"),
    Sound("npc/metropolice/gear6.wav"),
}, 
	OTARelations = Color(51, 204, 0),
	BubbleColor = Color(72, 255, 255), BubbleIcon = "org_icons/hl2/combine.png"
})

FACTION_OTA = rp.AddFaction({name = 'OTA', printName = 'OTA', npcs = {
	rp_city17_alyx_urfim = {
		{Vector(5525, 3956, 64), Angle(0, -90, 0), 'models/hlvr/characters/combine_captain/combine_captain_hlvr_player.mdl'}
	},
}, footstepSound = {
	Sound("npc/combine_soldier/gear1.wav"),
	Sound("npc/combine_soldier/gear2.wav"),
	Sound("npc/combine_soldier/gear3.wav"),
	Sound("npc/combine_soldier/gear4.wav"),
	Sound("npc/combine_soldier/gear5.wav"),
	Sound("npc/combine_soldier/gear6.wav"),
}, 
	OTARelations = Color(51, 204, 0),
	BubbleColor = Color(58, 95, 205), BubbleIcon = "org_icons/hl2/combine.png"
})

FACTION_HELIX = rp.AddFaction({name = 'HELIX', printName = 'Helix', npcs = {

}, footstepSound = {
    Sound("npc/metropolice/gear1.wav"),
    Sound("npc/metropolice/gear2.wav"),
    Sound("npc/metropolice/gear3.wav"),
    Sound("npc/metropolice/gear4.wav"),
    Sound("npc/metropolice/gear5.wav"),
    Sound("npc/metropolice/gear6.wav"),
}, 
	OTARelations = Color(51, 204, 0),
})

FACTION_CMD = rp.AddFaction({name = 'CombineCMD', printName = 'CMD', npcs = {

}, footstepSound = {
    Sound("npc/metropolice/gear1.wav"),
    Sound("npc/metropolice/gear2.wav"),
    Sound("npc/metropolice/gear3.wav"),
    Sound("npc/metropolice/gear4.wav"),
    Sound("npc/metropolice/gear5.wav"),
    Sound("npc/metropolice/gear6.wav"),
}, 
	OTARelations = Color(51, 204, 0),
})


FACTION_GRID = rp.AddFaction({name = 'GRID', printName = 'GRID', npcs = {

}, footstepSound = {
    Sound("npc/metropolice/gear1.wav"),
    Sound("npc/metropolice/gear2.wav"),
    Sound("npc/metropolice/gear3.wav"),
    Sound("npc/metropolice/gear4.wav"),
    Sound("npc/metropolice/gear5.wav"),
    Sound("npc/metropolice/gear6.wav"),
}, 
	OTARelations = Color(51, 204, 0),
})

FACTION_ADMINS = rp.AddFaction({name = 'Admin', printName = 'Администрация Сервера', npcs = {
	rp_city17_alyx_urfim = {
		{Vector(3690, 4253, 2512), Angle(0.000, 90.000, 0.000), 'models/player/skeleton.mdl'}
	},
},
	BubbleColor = Color(138, 43, 226), BubbleIcon = "rpui/standart.png"
})

FACTION_DPF = rp.AddFaction({name = 'DPF', printName = 'Дивизион Blade', npcs = {

}, footstepSound = {
    Sound("npc/metropolice/gear1.wav"),
    Sound("npc/metropolice/gear2.wav"),
    Sound("npc/metropolice/gear3.wav"),
    Sound("npc/metropolice/gear4.wav"),
    Sound("npc/metropolice/gear5.wav"),
    Sound("npc/metropolice/gear6.wav"),
}, 
	OTARelations = Color(51, 204, 0),
})

FACTION_ZOMBIE = rp.AddFaction({name = 'Zombie', printName = 'Зомби', npcs = {
	rp_city17_alyx_urfim = {
		{Vector(3340, 9670, -416), Angle(0.000, 90.000, 0.000), 'models/hlvr/human/corpse/zombie/zombie_common_2_player.mdl'},
	},
}, 
	OTARelations = Color(255, 0, 0),
	BubbleColor = Color(255, 0, 0), BubbleIcon = "org_icons/hl2/zombie.png",
	CustomJobRows = {
		InventoryBlock = true
	}
})

FACTION_REFUGEES = rp.AddFaction({name = 'Refugees', printName = 'Беженцы', npcs = {
	rp_city17_alyx_urfim = {
		{Vector(3073, 5760, -384), Angle(0, -122, 0), 'models/daemon_alyx/players/male_citizen_01.mdl'},
	},
},
	OnSpawn = function(ent)
		ent:SetSkin(0)
		ent:SetBodygroup(1, 2)
		ent:SetBodygroup(2, 0)
		ent:SetBodygroup(3, 0)
		ent:SetBodygroup(4, 0)
		ent:SetBodygroup(5, 0)
		ent:SetBodygroup(6, 7) 
		ent:SetBodygroup(7, 0)
		ent:SetBodygroup(8, 1)
	end,
	BubbleColor = Color(46, 139, 87), BubbleIcon = "rpui/standart.png"
})


FACTIONGROUP_CITIZENS  	= rp.RegisterFactionGroup( "Мирные жители" );
FACTIONGROUP_MPF 		= rp.RegisterFactionGroup( "Гражданская Оборона" );
FACTIONGROUP_СMD  		= rp.RegisterFactionGroup( "CMD" );
FACTIONGROUP_OTA  		= rp.RegisterFactionGroup( "OTA" );
FACTIONGROUP_REBELS    	= rp.RegisterFactionGroup( "Сопротивление" );
FACTIONGROUP_CRIMINALS 	= rp.RegisterFactionGroup( "Преступники" );
FACTIONGROUP_MONSTERS  	= rp.RegisterFactionGroup( "Монстры" );
FACTIONGROUP_ADMINS    	= rp.RegisterFactionGroup( "Администрация" );
FACTIONGROUP_DONAT    	= rp.RegisterFactionGroup( "Фракции Игроков" );

rp.SetFactionGroup( FACTIONGROUP_CITIZENS,  {FACTION_CITIZEN, FACTION_CWU} );
rp.SetFactionGroup( FACTIONGROUP_MPF,  {FACTION_MPF, FACTION_HELIX, FACTION_GRID} );
rp.SetFactionGroup( FACTIONGROUP_СMD ,  {FACTION_CMD } );
rp.SetFactionGroup( FACTIONGROUP_OTA,  {FACTION_OTA} );
rp.SetFactionGroup( FACTIONGROUP_REBELS,    {FACTION_REBEL} );
rp.SetFactionGroup( FACTIONGROUP_MONSTERS,  {FACTION_ZOMBIE} );
rp.SetFactionGroup( FACTIONGROUP_ADMINS,    {FACTION_ADMINS} );

function PLAYER:IsZombie()
	return self:GetFaction() == FACTION_ZOMBIE   
end

function PLAYER:IsCombine(fac)
	fac = fac or self:GetFaction()
	return 	(FACTION_MPF and fac == FACTION_MPF) || 
			(FACTION_OTA and fac == FACTION_OTA) || 
			(FACTION_HELIX and fac == FACTION_HELIX) || 
			(FACTION_CMD and fac == FACTION_CMD) ||
			(FACTION_GRID and fac == FACTION_GRID) ||
			(TEAM_MAYOR1 and self:DisguiseTeam() == TEAM_MAYOR1)
end

function PLAYER:IsCWU()
	return self:GetFaction() == FACTION_CWU || self:DisguiseTeam() == TEAM_REFERENT
end

function PLAYER:IsOTA()
	return self:GetFaction() == FACTION_OTA
end

function PLAYER:IsRebel()
	return self:GetFaction() == FACTION_REBEL
end

function PLAYER:IsCombineOrDisguised()
	if self:IsDisguised() then
		local faction = rp.teams && rp.teams[self:DisguiseTeam() or 1].faction
		return self:IsCombine(faction)
	else
		return self:IsCombine()
	end
end

rp.CombineFactionTeammates(FACTION_MPF, FACTION_HELIX, FACTION_GRID)
rp.CombineFactionTeammates(FACTION_CMD, FACTION_OTA)

rp.RegisterFactionKeypadGroup(FACTION_MPF, FACTION_HELIX, FACTION_GRID, FACTION_CMD, FACTION_OTA)