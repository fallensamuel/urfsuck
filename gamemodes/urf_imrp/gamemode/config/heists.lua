 
rp.cfg.ArmoryHeists = {
    __Fonts = {
        EntityBig = "HUDInfoFont",
        WorldHint = "HUDBarFont",
    },

    List = {
        ["rp_city17_alyx_urfim"] = {
            [1] = {
				TermsList = {
					["NotAnAttacker"] = "ArmHeist.AllianceStorage.NotAnAttacker",
					["InProgress"]    = "ArmHeist.AllianceStorage.InProgress",
					["Cooldown"]      = "ArmHeist.AllianceStorage.Cooldown",
				},

                Name         = "Ограбление Склада Альянса",

                Duration     = 180, 
                Cooldown     = 400,  

                IdleDuration = 60,
                Stealth = true,

                Attackers = {
                    Territory = {
                        mins = Vector(8424, 1016, -64), 
                        maxs = Vector(7741, 464, 152),
						_onstart = function( ply )
							ply:Wanted( NULL, "Ограбление Склада Альянса", 360 ); 
                        end
                    },

					Filter = function( ply )
                        local f = ply:GetFaction();
                        return f == FACTION_REBEL
                    end,
                },

                Defenders = {
                    Territory = {
                        mins = Vector(8424, 1016, -64), 
                        maxs = Vector(7741, 464, 152),
                    },

                    Reward = function( ply )
                        local DefenderReward = 3000;
                        ply:Notify( NOTIFY_GREEN, rp.Term("ArmHeist.AllianceStorage.DefendersHelp"), rp.FormatMoney(DefenderReward) );
                        ply:AddMoney( DefenderReward );
                    end,

                    Filter = function( ply )
                        local f = ply:GetFaction();
                        return f == FACTION_MPF or f == FACTION_CMD or f == FACTION_OTA or f == FACTION_HELIX or f == FACTION_GRID
					end,
                },
				
				MarkerPosition = Vector(7874, 757, 42),

                LootTable = {
                    Position = Vector(7935.725098, 686.533691, -47.646225), 
					Angles = Angle(0, -180, 0), 
					Model = "models/Items/ammocrate_smg1.mdl",
                    Content = {
                        ["swb_pistol"] = {
                            DropRate        = 55, -- базовый шанс
                            RatePerDefender = 2, -- бонусный шанс за 1 защитника
                            Amount          = 5, -- максимальное количество, которое может дропнуться (каждая единица прогоняет свой шанс на дроп)
                        },
                        ["swb_357"] = {
                            DropRate        = 50,
                            RatePerDefender = 2,
                            Amount          = 5,
                        },
                        ["swb_ar2"] = {
                            DropRate        = 50,
                            RatePerDefender = 3,
                            Amount          = 5,
                        },
                        ["swb_ar3"] = {
                            DropRate        = 35,
                            RatePerDefender = 3,
                            Amount          = 3,
                        },
                        ["swb_shotgun"] = {
                            DropRate        = 35,
                            RatePerDefender = 0,
                            Amount          = 3,
                        },
                        ["tfa_suppressor"] = {
                            DropRate        = 10,
                            RatePerDefender = 1,
                            Amount          = 3,
                        },
                    },
                },
			},

            [2] = {
                TermsList = {
                    ["NotAnAttacker"] = "ArmHeist.AllianceStorage.NotAnAttacker",
                    ["InProgress"]    = "ArmHeist.AllianceStorage.InProgress",
                    ["Cooldown"]      = "ArmHeist.AllianceStorage.Cooldown",
                },

                Name         = "Саботаж Склада Сопротивления",

                Duration     = 120, 
                Cooldown     = 400,
                Stealth = true,  

                IdleDuration = 60,

                Attackers = {
                    Territory = {
                        mins = Vector(-2294, -2359, 64), 
                        maxs = Vector(-1416, -1963, 188),
                        _onstart = function( ply )
                            --ply:Wanted( NULL, "Саботаж Склада Сопротивления", 1 ); 
                        end
                    },

                    Filter = function( ply )
                        local f = ply:GetFaction();
                        return f == FACTION_MPF or f == FACTION_CMD or f == FACTION_OTA or f == FACTION_HELIX or f == FACTION_GRID
                    end,
                },

                Defenders = {
                    Territory = {
                        mins = Vector(-1917, -1947, 32), 
                        maxs = Vector(-1417, -1776, 72),
                    },

                    Reward = function( ply )
                        local DefenderReward = 3000;
                        ply:Notify( NOTIFY_GREEN, rp.Term("ArmHeist.AllianceStorage.DefendersHelp"), rp.FormatMoney(DefenderReward) );
                        ply:AddMoney( DefenderReward );
                    end,

                    Filter = function( ply )
                        local f = ply:GetFaction();
                        return f == FACTION_REBEL
                    end,
                },
                
                MarkerPosition = Vector(-1699.742554, -2180.031494, 138.247055),

                LootTable = {
                    Position = Vector(-1707.764771, -2312.608887, 80.400482), 
                    Angles = Angle(0, 90, 0), 
                    Model = "models/items/ammocrate_smg1.mdl",
                    Content = {
                        ["swb_pistol"] = {
                            DropRate        = 50, -- базовый шанс
                            RatePerDefender = 1,  -- бонусный шанс за 1 защитника
                            Amount          = 8,  -- максимальное количество, которое может дропнуться (каждая единица прогоняет свой шанс на дроп)
                        },
                        ["swb_357"] = {
                            DropRate        = 50,
                            RatePerDefender = 0.5,
                            Amount          = 4,
                        },
                        ["swb_smg"] = {
                            DropRate        = 50,
                            RatePerDefender = 0,
                            Amount          = 4,
                        },
                        ["swb_shotgun"] = {
                            DropRate        = 50,
                            RatePerDefender = 0,
                            Amount          = 4,
                        },
                    },
                },
            },

			[3] = {
				TermsList = {
					["NotAnAttacker"] = "ArmHeist.RebelBase.NotAnAttacker",
					["InProgress"]    = "ArmHeist.RebelBase.InProgress",
					["Cooldown"]      = "ArmHeist.RebelBase.Cooldown",
				},

                Name         = "Склад Повстанцев",

                Duration     = 180,
                Cooldown     = 400,

                IdleDuration = 60,

                Attackers = {
                    Territory = {
                        mins = Vector(-4408, -63, 81),
                        maxs = Vector(-4168, 287, 223)
                    },

					Filter = function( ply )
                        local f = ply:GetFaction();
                        return f == FACTION_MPF or f == FACTION_CMD or f == FACTION_OTA or f == FACTION_HELIX or f == FACTION_GRID
                    end,
                },

                Defenders = {
                    Territory = {
                        mins = Vector(-4408, -63, 81),
                        maxs = Vector(-4168, 287, 223),
                    },

                    Reward = function( ply )
                        local DefenderReward = 2000;
                        ply:Notify( NOTIFY_GREEN, rp.Term("ArmHeist.RebelBase.DefendersHelp"), rp.FormatMoney(DefenderReward) );
                        ply:AddMoney( DefenderReward );
                    end,

                    Filter = function( ply )
                        local f = ply:GetFaction();
                        return f == FACTION_REBEL 
					end,
                },
					
				MarkerPosition = Vector(-4312, 118, 165),

                LootTable = {
                    Position = Vector(-4295.599609, 271.724792, 96.390694), 
					Angles = Angle(0, -90, 0), 
					Model = "models/Items/ammocrate_smg1.mdl",
                	Content = {
                        ["swb_357"] = {
                            DropRate        = 70, -- базовый шанс
                            RatePerDefender = 0, -- бонусный шанс за 1 защитника
                            Amount          = 6, -- максимальное количество, которое может дропнуться (каждая единица прогоняет свой шанс на дроп)
                        },
                        ["swb_oicw_v2"] = {
                            DropRate        = 50,
                            RatePerDefender = 3,
                            Amount          = 4,
                        },
                        ["swb_ar3"] = {
                            DropRate        = 25,
                            RatePerDefender = 0,
                            Amount          = 4,
                        },
                        ["swb_bow"] = {
                            DropRate        = 10,
                            RatePerDefender = 1,
                            Amount          = 2,
                        },
                        ["swb_shotgun"] = {
                            DropRate        = 50,
                            RatePerDefender = 0,
                            Amount          = 4,
                        },
                        ["swb_smg"] = {
                            DropRate        = 50,
                            RatePerDefender = 0,
                            Amount          = 4,
                        },
                    },
                },
            },

             
            [4] = {
                TermsList = {
                    ["NotAnAttacker"] = "ArmHeist.AllianceStorage.NotAnAttacker",
                    ["InProgress"]    = "ArmHeist.AllianceStorage.InProgress",
                    ["Cooldown"]      = "ArmHeist.AllianceStorage.Cooldown",
                },

                Name         = "Ограбление Опорного Пункта 35",

                Duration     = 180, 
                Cooldown     = 400,  

                IdleDuration = 60,
                Stealth = true,

                Attackers = {
                    Territory = {
                        mins = Vector(3446, -907, 32), 
                        maxs = Vector(2432, -1764, 381),
                        _onstart = function( ply )
                            ply:Wanted( NULL, "Ограбление Опорного Пункта 35", 360 ); 
                        end
                    },

                    Filter = function( ply )
                        local f = ply:GetFaction();
                        return f == FACTION_REBEL
                    end,
                },

                Defenders = {
                    Territory = {
                        mins = Vector(3446, -907, 32), 
                        maxs = Vector(2432, -1764, 381)
                    },

                    Reward = function( ply )
                        local DefenderReward = 3000;
                        ply:Notify( NOTIFY_GREEN, rp.Term("ArmHeist.AllianceStorage.DefendersHelp"), rp.FormatMoney(DefenderReward) );
                        ply:AddMoney( DefenderReward );
                    end,

                    Filter = function( ply )
                        local f = ply:GetFaction();
                        return f == FACTION_MPF or f == FACTION_CMD or f == FACTION_OTA or f == FACTION_HELIX or f == FACTION_GRID
                    end,
                },
                
                MarkerPosition = Vector(7874, 757, 42),

                LootTable = {
                    Position = Vector(2952.365723, -1444.212158, 112.441315), 
                    Angles = Angle(1.426, -0.014, -0.021), 
                    Model = "models/props_combine/combine_intmonitor001.mdl",
                    Content = {
                        ["swb_pistol"] = {
                            DropRate        = 55, -- базовый шанс
                            RatePerDefender = 2, -- бонусный шанс за 1 защитника
                            Amount          = 3, -- максимальное количество, которое может дропнуться (каждая единица прогоняет свой шанс на дроп)
                        },
                        ["swb_357"] = {
                            DropRate        = 50,
                            RatePerDefender = 2,
                            Amount          = 3,
                        },
                        ["swb_ar2"] = {
                            DropRate        = 50,
                            RatePerDefender = 3,
                            Amount          = 3,
                        },
                        ["swb_shotgun"] = {
                            DropRate        = 35,
                            RatePerDefender = 0,
                            Amount          = 3,
                        },
                    },
                },
            },

			[5] = {
				TermsList = {
                    ["NotAnAttacker"] = "ArmHeist.AllianceStorage.NotAnAttacker",
                    ["InProgress"]    = "ArmHeist.AllianceStorage.InProgress",
                    ["Cooldown"]      = "ArmHeist.AllianceStorage.Cooldown",
                },

                Name         = "Ограбление Склада D4",

                Duration     = 180, 
                Cooldown     = 400,  

                IdleDuration = 60,

                Attackers = {
                    Territory = {
                        mins = Vector(6096, 6968, 32), 
                        maxs = Vector(5283, 6464, 312),
						_onstart = function( ply )
							ply:Wanted( NULL, "Ограбление Склада D4", 600 );
                        end
                    },

					Filter = function( ply )
                        local f = ply:GetFaction();
                        return f == FACTION_REBEL
                    end,
                },

                Defenders = {
                    Territory = {
                        mins = Vector(6096, 6968, 32), 
                        maxs = Vector(5283, 6464, 312)
                    },

                     Reward = function( ply )
                        local DefenderReward = 2000;
                        ply:Notify( NOTIFY_GREEN, rp.Term("ArmHeist.RebelBase.DefendersHelp"), rp.FormatMoney(DefenderReward) );
                        ply:AddMoney( DefenderReward );
                    end,

                    Filter = function( ply )
                        local f = ply:GetFaction();
                        return f == FACTION_MPF or f == FACTION_CMD or f == FACTION_OTA or f == FACTION_HELIX or f == FACTION_GRID
					end,
                },
					
				MarkerPosition = Vector(5560, 6821, 150),

                LootTable = {
                    Position = Vector(5672.719238, 6752.257812, 48.436523),
					Angles = Angle(-0.000, 90.002, -0.000),
					Model = "models/items/ammocrate_smg1.mdl",
                    Content = {
                        ["swb_pistol"] = {
                            DropRate        = 55, -- базовый шанс
                            RatePerDefender = 0, -- бонусный шанс за 1 защитника
                            Amount          = 5, -- максимальное количество, которое может дропнуться (каждая единица прогоняет свой шанс на дроп)
                        },
                        ["swb_357"] = {
                            DropRate        = 55,
                            RatePerDefender = 0.5,
                            Amount          = 3,
                        },
                        ["swb_ar2"] = {
                            DropRate        = 50,
                            RatePerDefender = 3,
                            Amount          = 5,
                        },
                        ["swb_ar3"] = {
                            DropRate        = 55,
                            RatePerDefender = 0,
                            Amount          = 3,
                        },
                    },
                },
			},
        },
    }
}

