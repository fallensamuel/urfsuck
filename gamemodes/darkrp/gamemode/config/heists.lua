-- "gamemodes\\darkrp\\gamemode\\config\\heists.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal

rp.cfg.ArmoryHeists = {
    __Fonts = {
        EntityBig = "StalkerJobFont",
        WorldHint = "StalkerSubBarFont",
    },

    List = {
        ["rp_stalker_urfim"] = {
			[1] = {
				TermsList = {
					["NotAnAttacker"]      = "ArmHeist.NIG.NotAnAttacker",
					["InProgress"]         = "ArmHeist.NIG.InProgress",
					["Cooldown"]           = "ArmHeist.NIG.Cooldown",
					["NotEnoughAttackers"] = "ArmHeist.NIG.NotEnoughAttackers",
					["NotEnoughDefenders"] = "ArmHeist.NIG.NotEnoughDefenders",
				},

                Name         = "Ограбление Лаборатории НИГ",

                Duration     = 180, 
                Cooldown     = 600,  

                IdleDuration = 60,

                Attackers = {
                    Territory = {
                        mins = Vector(11923, -12606, -120), 
						maxs = Vector(2111, -12480, 0),
						_onstart = function( ply )
							ply:Wanted( NULL, "Ограбление Склада НИГ", 360 );
                        end
                    },

					MinLimit = 0,

					Filter = function( ply )
                        local f = ply:GetFaction();
                        return f == FACTION_REBEL or 
                        f == FACTION_SVOBODA or  
                        f == FACTION_NEBO  or
                        f == FACTION_MONOLITH or 
                        f == FACTION_RENEGADES  
					end,
                },

                Defenders = {
                    Territory = {
                        mins = Vector(11923, -12606, -120), 
                        maxs = Vector(2111, -12480, 0)
					},
					
					MinLimit = 0,

                    Reward = function( ply )
                        local DefenderReward = 3000;
                        ply:Notify( NOTIFY_GREEN, "ArmHeist.NIG.DefendersHelp", rp.FormatMoney(DefenderReward) );
                        ply:AddMoney( DefenderReward );
                    end,

                    Filter = function( ply )
                        local f = ply:GetFaction();
                         return f == FACTION_ECOLOG or
                         f == FACTION_MILITARY  or 
                         f == FACTION_MILITARYS or  
                         f == FACTION_DOLG   or  
                         f == FACTION_ORDEN 
					end,
                },
				
				MarkerPosition = Vector(2089.560547, -12546.611328, -66.524979),

                LootTable = {
					Position = Vector(2089.244629, -12545.197266, -119.176544),
					Angles   = Angle(0.865, -179.988, 0.000),
					Model    = "models/flaymi/anomaly/dynamics/box/konteyner_01.mdl",
                    Content  = {
                        ["art_ballon"] = {
                            DropRate        = 10, -- базовый шанс
                            RatePerDefender = 0,  -- бонусный шанс за 1 защитника
                            Amount          = 2,  -- максимальное количество, которое может дропнуться (каждая единица прогоняет свой шанс на дроп)
                        },
                        ["art_blood"] = {
                            DropRate        = 10,
                            RatePerDefender = 0,
                            Amount          = 2,
                        },
                        ["art_crystal"] = {
                            DropRate        = 10,
                            RatePerDefender = 0,
                            Amount          = 1,
                        },
                        ["art_crystalplant"] = {
                            DropRate        = 10,
                            RatePerDefender = 0,
                            Amount          = 1,
                        },
                        ["art_dummy"] = {
                            DropRate        = 10,
                            RatePerDefender = 0,
                            Amount          = 2,
                        },
                        ["art_dummybattary"] = {
                            DropRate        = 10,
                            RatePerDefender = 0,
                            Amount          = 2,
                        },
                        ["art_fire"] = {
                            DropRate        = 10,
                            RatePerDefender = 0,
                            Amount          = 2,
                        },
                        ["art_goldfish"] = {
                            DropRate        = 10,
                            RatePerDefender = 0,
                            Amount          = 1,
                        },
                        ["art_gravi"] = {
                            DropRate        = 10,
                            RatePerDefender = 0,
                            Amount          = 2,
                        },
                        ["art_nightstar"] = {
                            DropRate        = 10,
                            RatePerDefender = 0,
                            Amount          = 1,
                        },
                        ["art_soul"] = {
                            DropRate        = 10,
                            RatePerDefender = 0,
                            Amount          = 1,
                        },
                        ["art_kolobok"] = {
                            DropRate        = 10,
                            RatePerDefender = 0,
                            Amount          = 1,
                        },
                        ["art_control"] = {
                            DropRate        = 10,
                            RatePerDefender = 0,
                            Amount          = 2,
                        },
                        ["health_kit_best"] = {
                            DropRate        = 10,
                            RatePerDefender = 0,
                            Amount          = 2,
                        },
                    },
                },
			},
			[2] = {
				TermsList = {
					["NotAnAttacker"]      = "ArmHeist.Army.NotAnAttacker",
					["InProgress"]         = "ArmHeist.Army.InProgress",
					["Cooldown"]           = "ArmHeist.Army.Cooldown",
					["NotEnoughAttackers"] = "ArmHeist.Army.NotEnoughAttackers",
					["NotEnoughDefenders"] = "ArmHeist.Army.NotEnoughDefenders",
				},

                Name         = "Ограбление Военного Склада",

                Duration     = 180, 
                Cooldown     = 600,  

                IdleDuration = 60,

                Attackers = {
                    Territory = {
                        mins = Vector(-9705.562500, -12086.635742, -353.756470), 
						maxs = Vector(-9414.270508, -11478.294922, -238.237625),
						_onstart = function( ply )
							ply:Wanted( NULL, "Ограбление Военного Склада", 360 );
                        end
                    },

					MinLimit = 0,

					Filter = function( ply )
                        local f = ply:GetFaction();
                        return f == FACTION_REBEL or 
                        f == FACTION_SVOBODA or  
                        f == FACTION_NEBO  or
                        f == FACTION_MONOLITH or 
                        f == FACTION_RENEGADES   
					end,
                },

                Defenders = {
                    Territory = {
                        mins = Vector(-10045.642578, -12101.985352, -377.632904), 
						maxs = Vector(-9726.279297, -11470.391602, -238.197449)
					},
					
					MinLimit = 0,

                    Reward = function( ply )
                        local DefenderReward = 3000;
                        ply:Notify( NOTIFY_GREEN, "ArmHeist.Army.DefendersHelp", rp.FormatMoney(DefenderReward) );
                        ply:AddMoney( DefenderReward );
                    end,

                    Filter = function( ply )
                        local f = ply:GetFaction();
                         return f == FACTION_ECOLOG or
                         f == FACTION_MILITARY  or
                         f == FACTION_MILITARYS or  
                         f == FACTION_DOLG   or 
                         f == FACTION_ORDEN  
					end,
                },
				
				MarkerPosition = Vector(-9578.126953, -11773.474609, -334.189972),

                LootTable = {
					Position = Vector(-9441.978516, -11782.753906, -359.541229),
					Angles   = Angle(-0.000, 90.000, 0.000),
					Model    = "models/z-o-m-b-i-e/st/cover/st_cover_wood_box_02.mdl",
                    Content  = {
                        ["tfa_anomaly_ak74"] = {
                            DropRate        = 25, -- базовый шанс
                            RatePerDefender = 0,  -- бонусный шанс за 1 защитника
                            Amount          = 4,  -- максимальное количество, которое может дропнуться (каждая единица прогоняет свой шанс на дроп)
                        },
                        ["tfa_anomaly_g36"] = {
                            DropRate        = 10, -- базовый шанс
                            RatePerDefender = 0,  -- бонусный шанс за 1 защитника
                            Amount          = 3,  -- максимальное количество, которое может дропнуться (каждая единица прогоняет свой шанс на дроп)
                        },
                        ["tfa_anomaly_protecta"] = {
                            DropRate        = 10, -- базовый шанс
                            RatePerDefender = 0,  -- бонусный шанс за 1 защитника
                            Amount          = 3,  -- максимальное количество, которое может дропнуться (каждая единица прогоняет свой шанс на дроп)
                        },
                        ["tfa_anomaly_bizon"] = {
                            DropRate        = 5, -- базовый шанс
                            RatePerDefender = 0,  -- бонусный шанс за 1 защитника
                            Amount          = 2,  -- максимальное количество, которое может дропнуться (каждая единица прогоняет свой шанс на дроп)
                        },
                         ["tfa_anomaly_rpd"] = {
                            DropRate        = 5, -- базовый шанс
                            RatePerDefender = 0,  -- бонусный шанс за 1 защитника
                            Amount          = 2,  -- максимальное количество, которое может дропнуться (каждая единица прогоняет свой шанс на дроп)
                        },
                        ["tfa_anomaly_svu"] = {
                            DropRate        = 15, -- базовый шанс
                            RatePerDefender = 0,  -- бонусный шанс за 1 защитника
                            Amount          = 4,  -- максимальное количество, которое может дропнуться (каждая единица прогоняет свой шанс на дроп)
                        },
                    },
                },
			},
		},
        ["rp_st_pripyat_urfim"] = {
            [1] = {
                TermsList = {
                    ["NotAnAttacker"]      = "ArmHeist.Army.NotAnAttacker",
                    ["InProgress"]         = "ArmHeist.Army.InProgress",
                    ["Cooldown"]           = "ArmHeist.Army.Cooldown",
                    ["NotEnoughAttackers"] = "ArmHeist.Army.NotEnoughAttackers",
                    ["NotEnoughDefenders"] = "ArmHeist.Army.NotEnoughDefenders",
                },

                Name         = "Ограбление Военного Склада",

                Duration     = 180, 
                Cooldown     = 600,  

                IdleDuration = 60,
                Stealth = true,

                Attackers = {
                    Territory = {
                        mins = Vector(-1799, -6839, 0), 
                        maxs = Vector(-1570, -6104, 141),
                        _onstart = function( ply )
                            ply:Wanted( NULL, "Ограбление Военного Склада", 360 );
                        end
                    },

                    MinLimit = 0,

                    Filter = function( ply )
                        local f = ply:GetFaction();
                        return f == FACTION_REBEL or 
                        f == FACTION_SVOBODA or  
                        f == FACTION_NEBO  or
                        f == FACTION_MONOLITH or 
                        f == FACTION_RENEGADES   
                    end,
                },

                Defenders = {
                    Territory = {
                        mins = Vector(-2082, -6837, 0), 
                        maxs = Vector(-1823, -6104, 197),
                    },
                    
                    MinLimit = 0,

                    Reward = function( ply )
                        local DefenderReward = 300;
                        ply:Notify( NOTIFY_GREEN, "ArmHeist.Army.DefendersHelp", rp.FormatMoney(DefenderReward) );
                        ply:AddMoney( DefenderReward );
                    end,

                    Filter = function( ply )
                        local f = ply:GetFaction();
                         return f == FACTION_ECOLOG or
                         f == FACTION_MILITARY  or
                         f == FACTION_MILITARYS or  
                         f == FACTION_DOLG   or 
                         f == FACTION_ORDEN  
                    end,
                },
                
                MarkerPosition = Vector(-1667.558594, -6467.530273, 85.259094),

                LootTable = {
                    Position = Vector(-1680.120117, -6135.033203, 0.452086),
                    Angles   = Angle(0.007, -178.702, 0.006),
                    Model    = "models/z-o-m-b-i-e/st/cover/st_cover_wood_box_02.mdl",
                    Content  = {
                        ["swb_groza"] = {
                            DropRate        = 25, -- базовый шанс
                            RatePerDefender = 0,  -- бонусный шанс за 1 защитника
                            Amount          = 4,  -- максимальное количество, которое может дропнуться (каждая единица прогоняет свой шанс на дроп)
                        },
                        ["swb_vss_kekler"] = {
                            DropRate        = 10, -- базовый шанс
                            RatePerDefender = 0,  -- бонусный шанс за 1 защитника
                            Amount          = 3,  -- максимальное количество, которое может дропнуться (каждая единица прогоняет свой шанс на дроп)
                        },
                        ["swb_svu"] = {
                            DropRate        = 10, -- базовый шанс
                            RatePerDefender = 0,  -- бонусный шанс за 1 защитника
                            Amount          = 3,  -- максимальное количество, которое может дропнуться (каждая единица прогоняет свой шанс на дроп)
                        },
                        ["swb_asvalscoped"] = {
                            DropRate        = 5, -- базовый шанс
                            RatePerDefender = 0,  -- бонусный шанс за 1 защитника
                            Amount          = 2,  -- максимальное количество, которое может дропнуться (каждая единица прогоняет свой шанс на дроп)
                        },
                         ["swb_ksvk"] = {
                            DropRate        = 5, -- базовый шанс
                            RatePerDefender = 0,  -- бонусный шанс за 1 защитника
                            Amount          = 2,  -- максимальное количество, которое может дропнуться (каждая единица прогоняет свой шанс на дроп)
                        },
                        ["swb_abaton"] = {
                            DropRate        = 15, -- базовый шанс
                            RatePerDefender = 0,  -- бонусный шанс за 1 защитника
                            Amount          = 4,  -- максимальное количество, которое может дропнуться (каждая единица прогоняет свой шанс на дроп)
                        },
                    },
                },
            },
        },
		["rp_stalker_urfim_v3"] = {
			[1] = {
				TermsList = {
					["NotAnAttacker"]      = "ArmHeist.NIG.NotAnAttacker",
					["InProgress"]         = "ArmHeist.NIG.InProgress",
					["Cooldown"]           = "ArmHeist.NIG.Cooldown",
					["NotEnoughAttackers"] = "ArmHeist.NIG.NotEnoughAttackers",
					["NotEnoughDefenders"] = "ArmHeist.NIG.NotEnoughDefenders",
				},

                Name         = "Ограбление Лаборатории НИГ",
                Stealth = true,
                Duration     = 180, 
                Cooldown     = 600,  

                IdleDuration = 60,

                Attackers = {
                    Territory = {
                        mins = Vector(-4297.658691, -13737.593750, -3955.664062), 
						maxs = Vector(-3726.406006, -13461.974609, -3864.467529),
						_onstart = function( ply )
							ply:Wanted( NULL, "Ограбление Склада НИГ", 360 );
                        end
                    },

					MinLimit = 0,

					Filter = function( ply )
                        local f = ply:GetFaction();
                        return f == FACTION_REBEL or 
                        f == FACTION_SVOBODA or  
                        f == FACTION_HITMANSOLO or  
                        f == FACTION_NEBO  or
                        f == FACTION_MONOLITH or 
                        f == FACTION_RENEGADES  
					end,
                },

                Defenders = {
                    Territory = {
                        mins = Vector(-4233.585938, -13233.701172, -3955.713867), 
						maxs = Vector(-3934.679199, -13118.516602, -3848.524170)
					},
					
					MinLimit = 0,

                    Reward = function( ply )
                        local DefenderReward = 3000;
                        ply:Notify( NOTIFY_GREEN, "ArmHeist.NIG.DefendersHelp", rp.FormatMoney(DefenderReward) );
                        ply:AddMoney( DefenderReward );
                    end,

                    Filter = function( ply )
                        local f = ply:GetFaction();
                         return
                         f == FACTION_DOLG   or 
                         f == FACTION_ORDEN 
					end,
                },
					
				MarkerPosition = Vector(-4186.076172, -13636.000977, -3889.989014),

                LootTable = {
					Position = Vector(-3950.053467, -13678.073242, -3917.609619),
					Angles   = Angle(0.000, 90.000, 0.000),
					Model    = "models/z-o-m-b-i-e/st/equipment_cache/st_equipment_box_02.mdl",
                    Content  = {
                        ["art_ballon"] = {
                            DropRate        = 10, -- базовый шанс
                            RatePerDefender = 0,  -- бонусный шанс за 1 защитника
                            Amount          = 2,  -- максимальное количество, которое может дропнуться (каждая единица прогоняет свой шанс на дроп)
                        },
                        ["art_blood"] = {
                            DropRate        = 10,
                            RatePerDefender = 0,
                            Amount          = 2,
                        },
                        ["art_crystal"] = {
                            DropRate        = 10,
                            RatePerDefender = 0,
                            Amount          = 1,
                        },
                        ["art_crystalplant"] = {
                            DropRate        = 10,
                            RatePerDefender = 0,
                            Amount          = 1,
                        },
                        ["art_dummy"] = {
                            DropRate        = 10,
                            RatePerDefender = 0,
                            Amount          = 2,
                        },
                        ["art_dummybattary"] = {
                            DropRate        = 10,
                            RatePerDefender = 0,
                            Amount          = 2,
                        },
                        ["art_fire"] = {
                            DropRate        = 10,
                            RatePerDefender = 0,
                            Amount          = 2,
                        },
                        ["art_goldfish"] = {
                            DropRate        = 10,
                            RatePerDefender = 0,
                            Amount          = 1,
                        },
                        ["art_gravi"] = {
                            DropRate        = 10,
                            RatePerDefender = 0,
                            Amount          = 2,
                        },
                        ["art_nightstar"] = {
                            DropRate        = 10,
                            RatePerDefender = 0,
                            Amount          = 1,
                        },
                        ["art_soul"] = {
                            DropRate        = 10,
                            RatePerDefender = 0,
                            Amount          = 1,
                        },
                        ["art_kolobok"] = {
                            DropRate        = 10,
                            RatePerDefender = 0,
                            Amount          = 1,
                        },
                        ["art_control"] = {
                            DropRate        = 10,
                            RatePerDefender = 0,
                            Amount          = 2,
                        },
                        ["health_kit_best"] = {
                            DropRate        = 5,
                            RatePerDefender = 0,
                            Amount          = 2,
                        },
                        ["rpitem_printerbooster_4"] = {
                            DropRate        = 10,
                            RatePerDefender = 0,
                            Amount          = 1,
                        },
                        ["legend_jeton"] = {
                            DropRate        = 100,
                            RatePerDefender = 0,
                            Amount          = 1,
                        },
                    },
                },
			},
			[2] = {
				TermsList = {
					["NotAnAttacker"]      = "ArmHeist.Army.NotAnAttacker",
					["InProgress"]         = "ArmHeist.Army.InProgress",
					["Cooldown"]           = "ArmHeist.Army.Cooldown",
					["NotEnoughAttackers"] = "ArmHeist.Army.NotEnoughAttackers",
					["NotEnoughDefenders"] = "ArmHeist.Army.NotEnoughDefenders",
				},

                Name         = "Ограбление Военного Склада",
                Stealth = true,
                Duration     = 180, 
                Cooldown     = 600,  

                IdleDuration = 60,

                Attackers = {
                    Territory = {
                        mins = Vector(-14209.634766, -12121.653320, -3897.803711), 
						maxs = Vector(-13326.388672, -11798.408203, -3766.484863),
						_onstart = function( ply )
							ply:Wanted( NULL, "Ограбление Военного Склада", 360 );
                        end
                    },

					MinLimit = 0,

					Filter = function( ply )
                        local f = ply:GetFaction();
                        return f == FACTION_REBEL or 
                        f == FACTION_SVOBODA or 
                        f == FACTION_HITMANSOLO or 
                        f == FACTION_NEBO  or
                        f == FACTION_MONOLITH or 
                        f == FACTION_RENEGADES   
					end,
                },

                Defenders = {
                    Territory = {
                        mins = Vector(-13948.640625, -11761.694336, -4057.709717), 
						maxs = Vector(-13590.299805, -11614.399414, -3925.233398)
					},
					
					MinLimit = 0,

                    Reward = function( ply )
                        local DefenderReward = 300;
                        ply:Notify( NOTIFY_GREEN, "ArmHeist.Army.DefendersHelp", rp.FormatMoney(DefenderReward) );
                        ply:AddMoney( DefenderReward );
                    end,

                    Filter = function( ply )
                        local f = ply:GetFaction();
                         return f == FACTION_ECOLOG or
                         f == FACTION_MILITARY  or
                         f == FACTION_MILITARYS or  
                         f == FACTION_DOLG   or 
                         f == FACTION_ORDEN  
					end,
                },
					
				MarkerPosition = Vector(-13770.581055, -11996.429688, -3833.245605),

                LootTable = {
					Position = Vector(-13768.292969, -12108.228516, -3903.508545),
					Angles   = Angle(0.000, 0.000, 0.000),
					Model    = "models/z-o-m-b-i-e/st/cover/st_cover_wood_box_02.mdl",
                    Content  = {
                        ["swb_groza"] = {
                            DropRate        = 25, -- базовый шанс
                            RatePerDefender = 0,  -- бонусный шанс за 1 защитника
                            Amount          = 4,  -- максимальное количество, которое может дропнуться (каждая единица прогоняет свой шанс на дроп)
                        },
                        ["swb_vss_kekler"] = {
                            DropRate        = 10, -- базовый шанс
                            RatePerDefender = 0,  -- бонусный шанс за 1 защитника
                            Amount          = 3,  -- максимальное количество, которое может дропнуться (каждая единица прогоняет свой шанс на дроп)
                        },
                        ["swb_svu"] = {
                            DropRate        = 10, -- базовый шанс
                            RatePerDefender = 0,  -- бонусный шанс за 1 защитника
                            Amount          = 3,  -- максимальное количество, которое может дропнуться (каждая единица прогоняет свой шанс на дроп)
                        },
                        ["swb_asvalscoped"] = {
                            DropRate        = 5, -- базовый шанс
                            RatePerDefender = 0,  -- бонусный шанс за 1 защитника
                            Amount          = 2,  -- максимальное количество, которое может дропнуться (каждая единица прогоняет свой шанс на дроп)
                        },
                         ["swb_ksvk"] = {
                            DropRate        = 5, -- базовый шанс
                            RatePerDefender = 0,  -- бонусный шанс за 1 защитника
                            Amount          = 2,  -- максимальное количество, которое может дропнуться (каждая единица прогоняет свой шанс на дроп)
                        },
                        ["swb_abaton"] = {
                            DropRate        = 10, -- базовый шанс
                            RatePerDefender = 0,  -- бонусный шанс за 1 защитника
                            Amount          = 4,  -- максимальное количество, которое может дропнуться (каждая единица прогоняет свой шанс на дроп)
                        },                       
                        ["rpitem_printerbooster_3"] = {
                            DropRate        = 10, -- базовый шанс
                            RatePerDefender = 0,  -- бонусный шанс за 1 защитника
                            Amount          = 1,  -- максимальное количество, которое может дропнуться (каждая единица прогоняет свой шанс на дроп)
                        },
                        ["legend_jeton"] = {
                            DropRate        = 100,
                            RatePerDefender = 0,
                            Amount          = 1,
                        },
                    },
                },
			},
		[3] = {
				TermsList = {
					["NotAnAttacker"]      = "ArmHeist.Army.NotAnAttacker",
					["InProgress"]         = "ArmHeist.Army.InProgress",
					["Cooldown"]           = "ArmHeist.Army.Cooldown",
					["NotEnoughAttackers"] = "ArmHeist.Army.NotEnoughAttackers",
					["NotEnoughDefenders"] = "ArmHeist.Army.NotEnoughDefenders",
				},

                Name         = "Ограбление Склада ДОЛГа",

                Duration     = 180, 
                Cooldown     = 600,  

                IdleDuration = 60,

                Attackers = {
                    Territory = {
                        mins = Vector(-3534, -7558, -3704), 
						maxs = Vector(-3288, -7200, -3584),
						_onstart = function( ply )
							ply:Wanted( NULL, "Ограбление Склада ДОЛГа", 360 );
                        end
                    },

					MinLimit = 0,

					Filter = function( ply )
                        local f = ply:GetFaction();
                        return f == FACTION_REBEL or 
                        f == FACTION_HITMANSOLO or 
                        f == FACTION_SVOBODA or  
                        f == FACTION_NEBO  or
                        f == FACTION_MONOLITH or 
                        f == FACTION_RENEGADES   
					end,
                },

                Defenders = {
                    Territory = {
                        mins = Vector(-3534, -7558, -3704), 
						maxs = Vector(-3288, -7200, -3584)
					},
					
					MinLimit = 0,

                    Reward = function( ply )
                        local DefenderReward = 300;
                        ply:Notify( NOTIFY_GREEN, "ArmHeist.Army.DefendersHelp", rp.FormatMoney(DefenderReward) );
                        ply:AddMoney( DefenderReward );
                    end,

                    Filter = function( ply )
                        local f = ply:GetFaction();
                         return f == FACTION_ECOLOG or
                         f == FACTION_MILITARY  or
                         f == FACTION_MILITARYS or  
                         f == FACTION_DOLG   or 
                         f == FACTION_ORDEN  
					end,
                },
					
				MarkerPosition = Vector(-3308.187012, -7386.548340, -3660.939453),

                LootTable = {
					Position = Vector(-3309.490967, -7386.349609, -3703.568848),
					Angles   = Angle(0.006, 90.070, -0.031),
					Model    = "models/z-o-m-b-i-e/st/cover/st_cover_wood_box_02.mdl",
                    Content  = {
                        ["swb_groza"] = {
                            DropRate        = 25, -- базовый шанс
                            RatePerDefender = 0,  -- бонусный шанс за 1 защитника
                            Amount          = 4,  -- максимальное количество, которое может дропнуться (каждая единица прогоняет свой шанс на дроп)
                        },
                        ["swb_vss_kekler"] = {
                            DropRate        = 10, -- базовый шанс
                            RatePerDefender = 0,  -- бонусный шанс за 1 защитника
                            Amount          = 3,  -- максимальное количество, которое может дропнуться (каждая единица прогоняет свой шанс на дроп)
                        },
                        ["swb_svu"] = {
                            DropRate        = 10, -- базовый шанс
                            RatePerDefender = 0,  -- бонусный шанс за 1 защитника
                            Amount          = 3,  -- максимальное количество, которое может дропнуться (каждая единица прогоняет свой шанс на дроп)
                        },
                        ["swb_asvalscoped"] = {
                            DropRate        = 5, -- базовый шанс
                            RatePerDefender = 0,  -- бонусный шанс за 1 защитника
                            Amount          = 2,  -- максимальное количество, которое может дропнуться (каждая единица прогоняет свой шанс на дроп)
                        },
                         ["swb_ksvk"] = {
                            DropRate        = 5, -- базовый шанс
                            RatePerDefender = 0,  -- бонусный шанс за 1 защитника
                            Amount          = 2,  -- максимальное количество, которое может дропнуться (каждая единица прогоняет свой шанс на дроп)
                        },
                        ["swb_abaton"] = {
                            DropRate        = 15, -- базовый шанс
                            RatePerDefender = 0,  -- бонусный шанс за 1 защитника
                            Amount          = 4,  -- максимальное количество, которое может дропнуться (каждая единица прогоняет свой шанс на дроп)
                        },
                        ["legend_jeton"] = {
                            DropRate        = 100,
                            RatePerDefender = 0,
                            Amount          = 1,
                        },
                    },
                },
			},
		    [4] = {
				TermsList = {
					["NotAnAttacker"]      = "ArmHeist.Army.NotAnAttacker",
					["InProgress"]         = "ArmHeist.Army.InProgress",
					["Cooldown"]           = "ArmHeist.Army.Cooldown",
					["NotEnoughAttackers"] = "ArmHeist.Army.NotEnoughAttackers",
					["NotEnoughDefenders"] = "ArmHeist.Army.NotEnoughDefenders",
				},

                Name         = "Ограбление Секретного Груза ВСУ",

                Duration     = 180, 
                Cooldown     = 600,  

                IdleDuration = 60,

                Attackers = {
                    Territory = {
                        mins = Vector(-1236, 5330, -3837), 
						maxs = Vector(-1114, 5841, -3679),
						_onstart = function( ply )
							ply:Wanted( NULL, "Ограбление Секретного Груза ВСУ", 360 );
                        end
                    },

					MinLimit = 0,

					Filter = function( ply )
                        local f = ply:GetFaction();
                        return f == FACTION_REBEL or
                        f == FACTION_HITMANSOLO or  
                        f == FACTION_SVOBODA or  
                        f == FACTION_NEBO  or
                        f == FACTION_MONOLITH or 
                        f == FACTION_RENEGADES   
					end,
                },

                Defenders = {
                    Territory = {
                        mins = Vector(-1236, 5330, -3837), 
						maxs = Vector(-1114, 5841, -3679)
					},
					
					MinLimit = 0,

                    Reward = function( ply )
                        local DefenderReward = 300;
                        ply:Notify( NOTIFY_GREEN, "ArmHeist.Army.DefendersHelp", rp.FormatMoney(DefenderReward) );
                        ply:AddMoney( DefenderReward );
                    end,

                    Filter = function( ply )
                        local f = ply:GetFaction();
                         return f == FACTION_ECOLOG or
                         f == FACTION_MILITARY  or
                         f == FACTION_MILITARYS or  
                         f == FACTION_DOLG   or 
                         f == FACTION_ORDEN  
					end,
                },
					
				MarkerPosition = Vector(-1164.474243, 5794.153809, -3749.469238),

                LootTable = {
					Position = Vector(-1163.682251, 5800.084961, -3785.162842),
					Angles   = Angle(-0.019, -179.834, 0.032),
					Model    = "models/z-o-m-b-i-e/st/cover/st_cover_wood_box_01.mdl",
                    Content  = {
                        ["swb_groza"] = {
                            DropRate        = 25, -- базовый шанс
                            RatePerDefender = 0,  -- бонусный шанс за 1 защитника
                            Amount          = 4,  -- максимальное количество, которое может дропнуться (каждая единица прогоняет свой шанс на дроп)
                        },
                        ["swb_vss_kekler"] = {
                            DropRate        = 10, -- базовый шанс
                            RatePerDefender = 0,  -- бонусный шанс за 1 защитника
                            Amount          = 3,  -- максимальное количество, которое может дропнуться (каждая единица прогоняет свой шанс на дроп)
                        },
                        ["swb_svu"] = {
                            DropRate        = 10, -- базовый шанс
                            RatePerDefender = 0,  -- бонусный шанс за 1 защитника
                            Amount          = 3,  -- максимальное количество, которое может дропнуться (каждая единица прогоняет свой шанс на дроп)
                        },
                        ["swb_asvalscoped"] = {
                            DropRate        = 5, -- базовый шанс
                            RatePerDefender = 0,  -- бонусный шанс за 1 защитника
                            Amount          = 2,  -- максимальное количество, которое может дропнуться (каждая единица прогоняет свой шанс на дроп)
                        },
                         ["swb_ksvk"] = {
                            DropRate        = 5, -- базовый шанс
                            RatePerDefender = 0,  -- бонусный шанс за 1 защитника
                            Amount          = 2,  -- максимальное количество, которое может дропнуться (каждая единица прогоняет свой шанс на дроп)
                        },
                        ["swb_abaton"] = {
                            DropRate        = 15, -- базовый шанс
                            RatePerDefender = 0,  -- бонусный шанс за 1 защитника
                            Amount          = 4,  -- максимальное количество, которое может дропнуться (каждая единица прогоняет свой шанс на дроп)
                        },
                        ["legend_jeton"] = {
                            DropRate        = 100,
                            RatePerDefender = 0,
                            Amount          = 1,
                        },
                    },
                },
			},
			[5] = {
				TermsList = {
					["NotAnAttacker"]      = "ArmHeist.Army.NotAnAttacker",
					["InProgress"]         = "ArmHeist.Army.InProgress",
					["Cooldown"]           = "ArmHeist.Army.Cooldown",
					["NotEnoughAttackers"] = "ArmHeist.Army.NotEnoughAttackers",
					["NotEnoughDefenders"] = "ArmHeist.Army.NotEnoughDefenders",
				},

                Name         = "Ограбление Потерянного Груза ВСУ",

                Duration     = 180, 
                Cooldown     = 600,  

                IdleDuration = 60,

                Attackers = {
                    Territory = {
                        mins = Vector(-1506, -2611, -3821), 
						maxs = Vector(-870, -2039, -3683),
						_onstart = function( ply )
							ply:Wanted( NULL, "Ограбление Потерянного Груза ВСУ", 360 );
                        end
                    },

					MinLimit = 0,

					Filter = function( ply )
                        local f = ply:GetFaction();
                        return f == FACTION_REBEL or 
                        f == FACTION_HITMANSOLO or 
                        f == FACTION_SVOBODA or  
                        f == FACTION_NEBO  or
                        f == FACTION_MONOLITH or 
                        f == FACTION_RENEGADES   
					end,
                },

                Defenders = {
                    Territory = {
                        mins = Vector(-1506, -2611, -3821), 
						maxs = Vector(-870, -2039, -3683)
					},
					
					MinLimit = 0,

                    Reward = function( ply )
                        local DefenderReward = 300;
                        ply:Notify( NOTIFY_GREEN, "ArmHeist.Army.DefendersHelp", rp.FormatMoney(DefenderReward) );
                        ply:AddMoney( DefenderReward );
                    end,

                    Filter = function( ply )
                        local f = ply:GetFaction();
                         return f == FACTION_ECOLOG or
                         f == FACTION_MILITARY  or
                         f == FACTION_MILITARYS or  
                         f == FACTION_DOLG   or 
                         f == FACTION_ORDEN  
					end,
                },
					
				MarkerPosition = Vector(-1258.458618, -2293.108398, -3745.333984),

                LootTable = {
					Position = Vector(-1261.881592, -2292.896240, -3789.325195),
					Angles   = Angle(0.022, 39.419, -0.115),
					Model    = "models/z-o-m-b-i-e/st/cover/st_cover_wood_box_02.mdl",
                    Content  = {
                        ["swb_groza"] = {
                            DropRate        = 25, -- базовый шанс
                            RatePerDefender = 0,  -- бонусный шанс за 1 защитника
                            Amount          = 4,  -- максимальное количество, которое может дропнуться (каждая единица прогоняет свой шанс на дроп)
                        },
                        ["swb_vss_kekler"] = {
                            DropRate        = 10, -- базовый шанс
                            RatePerDefender = 0,  -- бонусный шанс за 1 защитника
                            Amount          = 3,  -- максимальное количество, которое может дропнуться (каждая единица прогоняет свой шанс на дроп)
                        },
                        ["swb_svu"] = {
                            DropRate        = 10, -- базовый шанс
                            RatePerDefender = 0,  -- бонусный шанс за 1 защитника
                            Amount          = 3,  -- максимальное количество, которое может дропнуться (каждая единица прогоняет свой шанс на дроп)
                        },
                        ["swb_asvalscoped"] = {
                            DropRate        = 5, -- базовый шанс
                            RatePerDefender = 0,  -- бонусный шанс за 1 защитника
                            Amount          = 2,  -- максимальное количество, которое может дропнуться (каждая единица прогоняет свой шанс на дроп)
                        },
                         ["swb_ksvk"] = {
                            DropRate        = 5, -- базовый шанс
                            RatePerDefender = 0,  -- бонусный шанс за 1 защитника
                            Amount          = 2,  -- максимальное количество, которое может дропнуться (каждая единица прогоняет свой шанс на дроп)
                        },
                        ["swb_abaton"] = {
                            DropRate        = 15, -- базовый шанс
                            RatePerDefender = 0,  -- бонусный шанс за 1 защитника
                            Amount          = 4,  -- максимальное количество, которое может дропнуться (каждая единица прогоняет свой шанс на дроп)
                        },
                        ["legend_jeton"] = {
                            DropRate        = 100,
                            RatePerDefender = 0,
                            Amount          = 1,
                        },
                    },
                },
			},
		},
		 ["rp_pripyat_urfim"] = {
			[1] = {
				TermsList = {
					["NotAnAttacker"]      = "ArmHeist.NIG.NotAnAttacker",
					["InProgress"]         = "ArmHeist.NIG.InProgress",
					["Cooldown"]           = "ArmHeist.NIG.Cooldown",
					["NotEnoughAttackers"] = "ArmHeist.NIG.NotEnoughAttackers",
					["NotEnoughDefenders"] = "ArmHeist.NIG.NotEnoughDefenders",
				},

                Name         = "Ограбление Лаборатории НИГ",

                Duration     = 180, 
                Cooldown     = 600,  

                IdleDuration = 60,

                Attackers = {
                    Territory = {
                        mins = Vector(-4969.593262, -9805.593750, 14.406052), 
						maxs = Vector(-4662.405762, -9202.322266, 105.717819),
						_onstart = function( ply )
							ply:Wanted( NULL, "Ограбление Склада НИГ", 360 );
                        end
                    },

					MinLimit = 0,

					Filter = function( ply )
   						local f = ply:GetFaction();

    					if isNoDonate then
      						local allowed = {
            					[FACTION_REBEL] = true,
            					[FACTION_SVOBODA] = true,
            					[FACTION_MONOLITH] = true,
            					[FACTION_RENEGADES] = true,
            					[FACTION_NEBO] = true,
        					}

        					return allowed[f];
						else
        					local allowed = {
            					[FACTION_REBEL] = true,
            					[FACTION_SVOBODA] = true,
            					[FACTION_MONOLITH] = true,
            					[FACTION_RENEGADES] = true,
            					[FACTION_NEBO] = true,
            					[FACTION_SUN] = true,
            					[FACTION_CONCORD] = true,
            					[FACTION_GYDRA] = true,
            					[FACTION_FANTOM] = true,
            					[FACTION_GREH] = true,
            					[FACTION_STERVATNIKI] = true,
            					[FACTION_KOCHEVNIKI] = true,
            					[FACTION_PARTIZAN] = true,
            					[FACTION_ANGELRIP] = true,
            					[FACTION_BROTHERS] = true,
            					[FACTION_NAIMCHERRIN] = true,
            					[FACTION_WINDORG] = true,
            					[FACTION_MST] = true,
            					[FACTION_OXOTNIK] = true,
            					[FACTION_BOUNTY] = true,
            					[FACTION_NEMESIS] = true,
            					[FACTION_POISK] = true,
            					[FACTION_GIS] = true,
        					}
        					return allowed[f];
    					end
					end,
                },

                Defenders = {
                    Territory = {
                        mins = Vector(-4425.581055, -9565.606445, 14.246864), 
						maxs = Vector(-4310.406250, -9266.406250, 121.594185)
					},
					
					MinLimit = 0,

                    Reward = function( ply )
                        local DefenderReward = 300;
                        ply:Notify( NOTIFY_GREEN, "ArmHeist.NIG.DefendersHelp", rp.FormatMoney(DefenderReward) );
                        ply:AddMoney( DefenderReward );
                    end,

                    Filter = function( ply )
                        local f = ply:GetFaction();
                         return f == FACTION_ECOLOG or
                         f == FACTION_MILITARY  or 
                         f == FACTION_MILITARYS or  
                         f == FACTION_DOLG   or 
                         f == FACTION_ORDEN 
					end,
                },
					
				MarkerPosition = Vector(-4878.355957, -9305.485352, 63.290188),

                LootTable = {
					Position = Vector(-4874.433105, -9555.933594, 51.317825),
					Angles   = Angle(0.000, -0.000, 0.000),
					Model    = "models/z-o-m-b-i-e/st/equipment_cache/st_equipment_box_02.mdl",
                    Content  = {
                        ["art_ballon"] = {
                            DropRate        = 10, -- базовый шанс
                            RatePerDefender = 0,  -- бонусный шанс за 1 защитника
                            Amount          = 2,  -- максимальное количество, которое может дропнуться (каждая единица прогоняет свой шанс на дроп)
                        },
                        ["art_blood"] = {
                            DropRate        = 10,
                            RatePerDefender = 0,
                            Amount          = 2,
                        },
                        ["art_crystal"] = {
                            DropRate        = 10,
                            RatePerDefender = 0,
                            Amount          = 1,
                        },
                        ["art_crystalplant"] = {
                            DropRate        = 10,
                            RatePerDefender = 0,
                            Amount          = 1,
                        },
                        ["art_dummy"] = {
                            DropRate        = 10,
                            RatePerDefender = 0,
                            Amount          = 2,
                        },
                        ["art_dummybattary"] = {
                            DropRate        = 10,
                            RatePerDefender = 0,
                            Amount          = 2,
                        },
                        ["art_fire"] = {
                            DropRate        = 10,
                            RatePerDefender = 0,
                            Amount          = 2,
                        },
                        ["art_goldfish"] = {
                            DropRate        = 10,
                            RatePerDefender = 0,
                            Amount          = 1,
                        },
                        ["art_gravi"] = {
                            DropRate        = 10,
                            RatePerDefender = 0,
                            Amount          = 2,
                        },
                        ["art_nightstar"] = {
                            DropRate        = 10,
                            RatePerDefender = 0,
                            Amount          = 1,
                        },
                        ["art_soul"] = {
                            DropRate        = 10,
                            RatePerDefender = 0,
                            Amount          = 1,
                        },
                        ["art_kolobok"] = {
                            DropRate        = 10,
                            RatePerDefender = 0,
                            Amount          = 1,
                        },
                        ["art_control"] = {
                            DropRate        = 10,
                            RatePerDefender = 0,
                            Amount          = 2,
                        },
                        ["health_kit_best"] = {
                            DropRate        = 10,
                            RatePerDefender = 0,
                            Amount          = 2,
                        },
                    },
                },
			},
			[2] = {
				TermsList = {
					["NotAnAttacker"]      = "ArmHeist.Army.NotAnAttacker",
					["InProgress"]         = "ArmHeist.Army.InProgress",
					["Cooldown"]           = "ArmHeist.Army.Cooldown",
					["NotEnoughAttackers"] = "ArmHeist.Army.NotEnoughAttackers",
					["NotEnoughDefenders"] = "ArmHeist.Army.NotEnoughDefenders",
				},

                Name         = "Ограбление Военного Склада",

                Duration     = 180, 
                Cooldown     = 600,  

                IdleDuration = 60,

                Attackers = {
                    Territory = {
                        mins = Vector(4950.381348, -6385.581543, 182.345947), 
						maxs = Vector(5225.630371, -6166.415039, 313.584015),
						_onstart = function( ply )
							ply:Wanted( NULL, "Ограбление Военного Склада", 360 );
                        end
                    },

					MinLimit = 0,

					Filter = function( ply )
   						local f = ply:GetFaction();

    					if isNoDonate then
      						local allowed = {
            					[FACTION_REBEL] = true,
            					[FACTION_SVOBODA] = true,
            					[FACTION_MONOLITH] = true,
            					[FACTION_RENEGADES] = true,
            					[FACTION_NEBO] = true,
        					}

        					return allowed[f];
						else
        					local allowed = {
            					[FACTION_REBEL] = true,
            					[FACTION_SVOBODA] = true,
            					[FACTION_MONOLITH] = true,
            					[FACTION_RENEGADES] = true,
            					[FACTION_NEBO] = true,
            					[FACTION_SUN] = true,
            					[FACTION_CONCORD] = true,
            					[FACTION_GYDRA] = true,
            					[FACTION_FANTOM] = true,
            					[FACTION_GREH] = true,
            					[FACTION_STERVATNIKI] = true,
            					[FACTION_KOCHEVNIKI] = true,
            					[FACTION_PARTIZAN] = true,
            					[FACTION_ANGELRIP] = true,
            					[FACTION_BROTHERS] = true,
            					[FACTION_NAIMCHERRIN] = true,
            					[FACTION_WINDORG] = true,
            					[FACTION_MST] = true,
            					[FACTION_OXOTNIK] = true,
            					[FACTION_BOUNTY] = true,
            					[FACTION_NEMESIS] = true,
            					[FACTION_POISK] = true,
            					[FACTION_GIS] = true,
        					}
        					return allowed[f];
    					end
					end,
                },

                Defenders = {
                    Territory = {
                        mins = Vector(4758.307617, -6889.585449, 182.406052), 
						maxs = Vector(4969.624512, -6414.319336, 288.009888)
					},
					
					MinLimit = 0,

                    Reward = function( ply )
                        local DefenderReward = 300;
                        ply:Notify( NOTIFY_GREEN, "ArmHeist.Army.DefendersHelp", rp.FormatMoney(DefenderReward) );
                        ply:AddMoney( DefenderReward );
                    end,

					Filter = function( ply )
   						local f = ply:GetFaction();

    					if isNoDonate then
      						local allowed = {
            					[FACTION_ECOLOG] = true,
            					[FACTION_MILITARY] = true,
            					[FACTION_MILITARYS] = true,
            					[FACTION_DOLG] = true,
        					}

        					return allowed[f];
						else
        					local allowed = {
            					[FACTION_ECOLOG] = true,
            					[FACTION_MILITARY] = true,
            					[FACTION_MILITARYS] = true,
            					[FACTION_DOLG] = true,
            					[FACTION_ORDEN] = true,
        					}
        					return allowed[f];
    					end
					end,
                },
					
				MarkerPosition = Vector(5092.641113, -6279.803711, 236.331757),

                LootTable = {
					Position = Vector(5210.553223, -6276.479004, 176.415024),
					Angles   = Angle(0.000, 90.000, 0.000),
					Model    = "models/z-o-m-b-i-e/st/cover/st_cover_wood_box_02.mdl",
                    Content  = {
                        ["swb_groza"] = {
                            DropRate        = 25, -- базовый шанс
                            RatePerDefender = 0,  -- бонусный шанс за 1 защитника
                            Amount          = 4,  -- максимальное количество, которое может дропнуться (каждая единица прогоняет свой шанс на дроп)
                        },
                        ["swb_vss_kekler"] = {
                            DropRate        = 10, -- базовый шанс
                            RatePerDefender = 0,  -- бонусный шанс за 1 защитника
                            Amount          = 3,  -- максимальное количество, которое может дропнуться (каждая единица прогоняет свой шанс на дроп)
                        },
                        ["swb_svu"] = {
                            DropRate        = 10, -- базовый шанс
                            RatePerDefender = 0,  -- бонусный шанс за 1 защитника
                            Amount          = 3,  -- максимальное количество, которое может дропнуться (каждая единица прогоняет свой шанс на дроп)
                        },
                        ["swb_asvalscoped"] = {
                            DropRate        = 5, -- базовый шанс
                            RatePerDefender = 0,  -- бонусный шанс за 1 защитника
                            Amount          = 2,  -- максимальное количество, которое может дропнуться (каждая единица прогоняет свой шанс на дроп)
                        },
                         ["swb_ksvk"] = {
                            DropRate        = 5, -- базовый шанс
                            RatePerDefender = 0,  -- бонусный шанс за 1 защитника
                            Amount          = 2,  -- максимальное количество, которое может дропнуться (каждая единица прогоняет свой шанс на дроп)
                        },
                        ["swb_abaton"] = {
                            DropRate        = 15, -- базовый шанс
                            RatePerDefender = 0,  -- бонусный шанс за 1 защитника
                            Amount          = 4,  -- максимальное количество, которое может дропнуться (каждая единица прогоняет свой шанс на дроп)
                        },
                    },
                },
			},
		},
	},
}
