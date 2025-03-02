-- "gamemodes\\darkrp\\gamemode\\config\\factions.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal


FACTION_CITIZEN = rp.AddFaction({name = 'Citizens', printName = 'Одиночки', npcs = {
    /*    	
	rp_stalker_urfim_v3 = {
		{Vector(-2098, -12313, -640), Angle(0, 178, 0), 'models/stalkertnb/sunrise_bandit2.mdl'}
	},
	rp_pripyat_urfim = {
		{Vector(-1294, -11441, 20), Angle(0.000, 125.000, 0.000), 'models/stalkertnb/sunrise_bandit2.mdl'}
	},
	rp_stalker_urfim = {
		{Vector(-1934, -11607, -384), Angle(0.000, 0.000, 0.000), 'models/stalkertnb/sunrise_bandit2.mdl'}
	},
    */		
}})

FACTION_NETRAL = rp.AddFaction({name = 'netral', printName = 'Нейтралы', npcs = {
}})

FACTION_ADMINS = rp.AddFaction({name = 'Staff', printName = 'Администрация', npcs = {
	rp_stalker_urfim = {
		{Vector(9794, 1, 11264), Angle(0, -180, 0), 'models/oso.mdl'}
	},
},
	BubbleColor = Color(51, 128, 255), BubbleIcon = "stalker/icons/loners_logo.png"
})

FACTION_SVOBODA = rp.AddFaction({name = 'SVOBODA', printName = 'Свобода', npcs = {
	rp_stalker_urfim = {
		{Vector(8776, -774, -122), Angle(0, 90, 0), 'models/player/stalker_freedom/freedom_noexo/freedom_noexo.mdl', "stalker/icons/freedom_logo.png", 5000}
	},
  		
},
	BubbleColor = Color(233, 150, 122), BubbleIcon = "stalker/icons/freedom_logo.png"
})

FACTION_DOLG = rp.AddFaction({name = 'DOLG', printName = 'ДОЛГ', npcs = {
    	    
	rp_stalker_urfim = {
		{Vector(345, -4210, 128), Angle(0.000, -180.000, 0.000), 'models/player/stalker_dolg/dolg_exo/dolg_exo.mdl', "stalker/icons/duty_logo.png", 5000}
	},
},
	BubbleColor = Color(128, 0, 0), BubbleIcon = "stalker/icons/duty_logo.png"
})

FACTION_MILITARY = rp.AddFaction({name = 'Military', printName = 'Армия Украины', npcs = {
	rp_stalker_urfim = {
		{Vector(-11432, -12326, -384), Angle(0, 0, 0), 'models/player/stalker_soldier/soldier_exo/soldier_exo.mdl', "stalker/icons/army_logo.png", 5000}
	},    	
},
	BubbleColor = Color(0, 72, 255), BubbleIcon = "stalker/icons/army_logo.png"
})

FACTION_MILITARYT = rp.AddFaction({name = 'MT', printName = 'Спецназ', npcs = {
	/*rp_stalker_urfim_v3 = {
		{Vector(-13780, -10321, -4080), Angle(0, -93, 0), 'models/muravey/beri_tyson.mdl'}
	},
	rp_pripyat_urfim = {
		{Vector(4690, -6880, 16), Angle(0, 90, 0), 'models/muravey/beri_tyson.mdl'}
	},
	rp_stalker_urfim = {
		{Vector(-10036, -11665, -384), Angle(0, -3, 0), 'models/muravey/beri_tyson.mdl'}
	},*/
}})

FACTION_MILITARYS = rp.AddFaction({name = 'MS', printName = 'Военные Сталкеры', npcs = {	
	rp_stalker_urfim_v3 = {
		{Vector(-8416, -13400, -4084), Angle(0, -14, 0), 'models/stalkertnb/skat_merc.mdl'}
	},
	rp_pripyat_urfim = {
		{Vector(4690, -6880, 16), Angle(0, 90, 0), 'models/stalkertnb/skat_merc.mdl'}
	},
	rp_stalker_urfim = {
		{Vector(-2248, -12636, -384), Angle(0, -93, 0), 'models/player/stalker_soldier/soldier_exo/soldier_exo.mdl'}
	},
}})


FACTION_MONOLITH = rp.AddFaction({name = 'Monolith', printName = 'Монолит', npcs = {
    	   
	rp_stalker_urfim = {
		{Vector(627, 2991, -896), Angle(0, -87, 0), 'models/player/stalker_monolith/monolith_exo/monolith_exo.mdl', "stalker/icons/monolith_logo.png", 5000}
	},	    
},
	BubbleColor = Color(23, 130, 130), BubbleIcon = "stalker/icons/monolith_logo.png"
})

FACTION_REBEL = rp.AddFaction({name = 'bandit', printName = 'Бандиты', npcs = {
    	    
	rp_stalker_urfim = {
		{Vector(-8112, -5660, -36), Angle(0, -2, 0), 'models/player/stalker_bandit/bandit_jacket/bandit_jacket.mdl',"stalker/icons/bandit_logo.png", 5000}
	},		
},
	BubbleColor = Color(100, 117, 109), BubbleIcon = "stalker/icons/bandit_logo.png"
})

FACTION_REFUGEES = rp.AddFaction({name = 'Barman', printName = 'Бармены', npcs = {	    	
	rp_stalker_urfim = {
		{Vector(-948, -12368, -384), Angle(0, 90, 0), 'models/player/stalker/compiled 0.34/wolf.mdl',"stalker/icons/info_logo.png", 5000}
	},
},
	BubbleColor = Color(189, 183, 107), BubbleIcon = "stalker/icons/barmens_logo.png"
})
FACTION_ZOMBIE1 = rp.AddFaction({name = 'Zombie1', printName = 'Зомбированные', npcs = {}})
FACTION_ZOMBIE = rp.AddFaction({name = 'Zombie', printName = 'Зомбированные', npcs = {
/*   	
	rp_stalker_urfim_v3 = {
		{Vector(9801, 7021, -685), Angle(0, -88, 0), 'models/stalkertnb/bandit7.mdl'}
	},
	rp_pripyat_urfim = {
		{Vector(-3962, 6833, 10),  Angle(0.000, 180.000, 0.000), 'models/stalkertnb/bandit7.mdl'}
	},
	rp_stalker_urfim = {
		{Vector(1552, 3018, 384), Angle(0, 180, 0), 'models/stalkertnb/bandit7.mdl'}
	},
*/		
},
	BubbleColor = Color(255, 255, 255), BubbleIcon = "faction_icons/stalkers.png"
})

FACTION_MUTANTS = rp.AddFaction({name = 'Mutants', printName = 'Мутанты', npcs = {
	/*rp_stalker_urfim_v3 = {
		{Vector(-5925, 1431, -3840), Angle(0.000, -45.000, 0.000), 'models/stalkertnb/kontroler1.mdl',"stalker/icons/psi.png", 5000}
	}, 
	rp_pripyat_urfim = {
		{Vector(-3967, 6864, 0), Angle(0.000, 180.000, 0.000), 'models/stalkertnb/kontroler1.mdl',"stalker/icons/psi.png", 5000} 
	},
	rp_stalker_urfim = {
		{Vector(1527, 3513, 384),Angle(0, -145, 0), 'models/stalkertnb/baldry_priest.mdl',"stalker/icons/psi.png", 5000}
	}, 
	rp_st_pripyat_urfim = {
		{Vector(-793, 10160, 50), Angle(0, -87, 0), 'models/stalkertnb/kontroler1.mdl',"stalker/icons/psi.png", 5000} 
	},*/
},
	BubbleColor = Color(178, 34, 34), BubbleIcon = "stalker/icons/zombies_logo.png"
})

FACTION_HITMANSOLO = rp.AddFaction({name = 'Hitmansolo', printName = 'Наемники', npcs = {
    	    	
	rp_stalker_urfim = {
		{Vector(-2302, -7240, 136), Angle(0, 89, 0), 'models/player/stalker_merc/merc_exo/merc_exo.mdl', "stalker/icons/merc_logo.png", 5000}
	},	    	
},
	BubbleColor = Color(0, 51, 102), BubbleIcon = "stalker/icons/merc_logo.png"
})

FACTION_NEBO = rp.AddFaction({name = 'Nebo', printName = 'Чистое Небо', npcs = {
    	
	/*rp_stalker_urfim_v3 = {
		{Vector(6180, 2428, -4251), Angle(0, -88, 0), 'models/stalker_nebo/nebo_middle/nebo_middle.mdl',"stalker/icons/clearsky_logo.png", 5000}
	},
	rp_pripyat_urfim = {
		{Vector(11551, 7632, -124), Angle(0, 90, 0), 'models/stalker_nebo/nebo_middle/nebo_middle.mdl',"stalker/icons/clearsky_logo.png", 5000}
	},
	rp_stalker_urfim = {
		{Vector(10833, 4001, -534), Angle(0, -45, 0), 'models/stalker_nebo/nebo_middle/nebo_middle.mdl',"stalker/icons/clearsky_logo.png", 5000}
	},	
	rp_st_pripyat_urfim = {
		{Vector(12648, 2553, 0), Angle(0, 178, 0), 'models/stalker_nebo/nebo_middle/nebo_middle.mdl',"stalker/icons/clearsky_logo.png", 5000}
	},*/
},
	BubbleColor = Color(0, 191, 255), BubbleIcon = "stalker/icons/clearsky_logo.png"
})

FACTION_ECOLOG = rp.AddFaction({name = 'Ecolog', printName = 'НИГ', npcs = {	    
	rp_stalker_urfim = {
		{Vector(2151, -11838, -128), Angle(0, 90, 0), 'models/player/stalker_ecologist/ecologist_seva/ecologist_seva.mdl',"stalker/icons/scientis_logo.png", 5000}
	},		
},
	BubbleColor = Color(0, 186, 15), BubbleIcon = "stalker/icons/scientis_logo.png"
})

/*FACTION_TOPOL = rp.AddFaction({name = 'topol', printName = 'Группа Тополя', npcs = { 	    
}})*/

FACTION_LP = rp.AddFaction({name = 'lp', printName = 'Личные профессии', npcs = { 	    
}})

FACTION_RENEGADES = rp.AddFaction({name = 'Renegades', printName = 'Ренегаты', npcs = {
/*    	    
	rp_stalker_urfim_v3 = {
		{Vector(3822, 6441, -3955), Angle(0.000, 180, 0.000), 'models/stalker_renegade/renegade_exo/renegade_exo.mdl',"stalker/icons/renegats_logo.png", 5000}
	},
	rp_pripyat_urfim = {
		{Vector(-460, -4368, 12), Angle(0.000, -125.000, 0.000), 'models/stalker_renegade/renegade_exo/renegade_exo.mdl',"stalker/icons/renegats_logo.png", 5000}
	},
	rp_stalker_urfim = {
		{Vector(3996, 6721, -364), Angle(0, 0, 0), 'models/stalker_renegade/renegade_exo/renegade_exo.mdl',"stalker/icons/renegats_logo.png", 5000}
	},
	rp_st_pripyat_urfim = {
		{Vector(-9429, 13796, 8), Angle(0, -89, 0), 'models/stalker_renegade/renegade_exo/renegade_exo.mdl',"stalker/icons/renegats_logo.png", 5000}
	},
},
	BubbleColor = Color(100, 117, 109), BubbleIcon = "stalker/icons/renegats_logo.png"*/
}})

FACTION_EVENTNEBO = rp.AddFaction({name = 'eventnebo', printName = 'Отряд Чистого Неба', npcs = {
    	
	rp_limanskhospital_urfim = {
		{Vector(939, 11454, 80), Angle(0, -124, 0), 'models/player/stalker_nebo/nebo_gp5/nebo_gp5.mdl'}
	},
},
})

FACTION_EVENTMONOLITH = rp.AddFaction({name = 'eventmonolith', printName = 'Отряд Монолита', npcs = {
    	   
	rp_limanskhospital_urfim = {
		{Vector(-605, -1115, 78), Angle(0, 60, 0), 'models/player/stalker_monolith/monolith_exo/monolith_exo.mdl'}
	},	    
},
})

rp.CombineFactionTeammates( FACTION_REFUGEES, FACTION_LP );
rp.CombineFactionTeammates( FACTION_MUTANTS, FACTION_ZOMBIE );

--if game.GetMap() == "rp_st_pripyat_urfim" then
FACTIONGROUP_1 = rp.RegisterFactionGroup( "Жители Зоны" );
FACTIONGROUP_2 = rp.RegisterFactionGroup( "Группировки" );
FACTIONGROUP_3 = rp.RegisterFactionGroup( "Военные" );
--FACTIONGROUP_4 = rp.RegisterFactionGroup( "Дети Зоны" );
FACTIONGROUP_5 = rp.RegisterFactionGroup( "Администрация" );
FACTIONGROUP_6 = rp.RegisterFactionGroup( "Фракции Игроков" );

rp.SetFactionGroup( FACTIONGROUP_1,  {FACTION_CITIZEN, FACTION_REFUGEES, FACTION_NETRAL, FACTION_ECOLOG, FACTION_LP});
rp.SetFactionGroup( FACTIONGROUP_2,  {FACTION_DOLG, FACTION_SVOBODA, FACTION_REBEL, FACTION_HITMANSOLO, FACTION_MONOLITH} );
rp.SetFactionGroup( FACTIONGROUP_3,  {FACTION_MILITARY, FACTION_MILITARYS} );
--rp.SetFactionGroup( FACTIONGROUP_4,  {FACTION_MONOLITH, FACTION_ZOMBIE, FACTION_MUTANTS} );
rp.SetFactionGroup( FACTIONGROUP_5,  {FACTION_ADMINS} );
rp.SetFactionGroup( FACTIONGROUP_6,  { } );
--end

function PLAYER:IsZombie()
	return self:GetFaction() == FACTION_ZOMBIE
end

function PLAYER:IsArmy()
	return self:GetFaction() == FACTION_MILITARY || self:GetFaction() == FACTION_MILITARYS || self:GetFaction() == FACTION_MILITARYT
end

function PLAYER:IsMonolit()
	return self:GetFaction() == FACTION_MONOLITH
end


		function PLAYER:IsCombine()
			return self:IsArmy() --self:GetFaction() == FACTION_COMBINE || self:GetFaction() == FACTION_DPF || self:GetFaction() == FACTION_ANGELDARK || self:GetFaction() == FACTION_FANTOM || self:GetFaction() == FACTION_ANTIHUMAN || self:GetFaction() == FACTION_OTA || self:GetFaction() == FACTION_HELIX || self:Team() == TEAM_KAEF || self:Team() == TEAM_MOSSM || self:Team() == TEAM_OTA_GUARD || self:Team() == TEAM_OTA_GUARD_HEAVY || self:GetFaction() == FACTION_DAP || self:GetFaction() == FACTION_LEGION || self:Team() == TEAM_RSOLD || self:Team() == TEAM_СSOLD || self:Team() == TEAM_VASIL || self:GetFaction() == FACTION_VIPERS 
		end

		function PLAYER:IsCWU()
			return false --self:GetFaction() == FACTION_CWU
		end

		function PLAYER:IsOTA()
			return false --self:GetFaction() == FACTION_OTA
		end

		function PLAYER:IsRebel()
			return false --self:GetFaction() == FACTION_REBEL || self:GetFaction() == FACTION_HECU
		end

		function PLAYER:IsCombinePilot()
			return false --self:Team() == TEAM_APCCAP || self:Team() == TEAM_APCPILOT || self:GetFaction() == FACTION_ANTIHUMAN
		end

		function PLAYER:IsCombineOrDisguised()
			return false
			
			--[[
			if self:IsDisguised() then
				local faction = rp.teams && rp.teams[self:DisguiseTeam() or 1].faction
				return faction == FACTION_COMBINE || faction == FACTION_DPF || faction == FACTION_ANGELDARK || faction == FACTION_FANTOM || faction == FACTION_ANTIHUMAN || faction == FACTION_OTA || faction == FACTION_HELIX || self:DisguiseTeam() == TEAM_KAEF || self:DisguiseTeam() == TEAM_MOSSM || self:DisguiseTeam() == TEAM_OTA_GUARD || self:DisguiseTeam() == TEAM_OTA_GUARD_HEAVY || faction == FACTION_DAP || faction == FACTION_LEGION || self:DisguiseTeam() == TEAM_RSOLD || self:DisguiseTeam() == TEAM_СSOLD || self:DisguiseTeam() == TEAM_VASIL || faction == FACTION_VIPERS 
			else
				return self:IsCombine()
			end
			]]
		end