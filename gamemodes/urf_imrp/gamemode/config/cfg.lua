rp.cfg.DisableDispatcherContextMenu = true -- Вырубает авиаудар капсулами

rp.cfg.DisableTFAContextMenu = true
--rp.cfg.DisableSignalizationSound = true
rp.cfg.SpawnedMoneyModel = "models/sky/combinecard2.mdl"

rp.cfg.ScoreboardName = "HLRP:Alyx"

rp.cfg.DisableProneMod = true
--rp.cfg.DisableQEntities = true

rp.cfg.EnableGlobalChat = false

rp.cfg.HoursDbServerName = 'HL2RP ALYX'

rp.cfg.AutoGhostAllEnts = false
rp.cfg.AllowGhostingAllEntities = true

rp.cfg.ConfiscationTime = 2
rp.cfg.LockdownDelay = 20

rp.cfg.Social = {
	steam = {
		bonus_text = '30 кредитов',
		bonus_func = function(ply) ply:AddCredits(30, 'steam join') end,
		bonus_info = 'Подпишитесь на нашу группу Steam, чтобы мгновенно\nполучить награду.',
		
		link = 'http://steamcommunity.com/groups/urfimofficial',
		handler = 'http://api.urf.im/handler/steam_group.php?sv=hl2rp_alyx',
	},
	discord = {
		bonus_text = '30 кредитов',
		bonus_func = function(ply) ply:AddCredits(30, 'discord join') end,
		bonus_info = 'Подпишитесь на наш Discord и бот пришлёт вам промокод\nв личные сообщения. Если вы уже подписаны, нажмите на смайлик\nракеты в канале "Промокоды".',
		is_promo = true,
		
		link = 'https://discord.gg/6Xfhrjy',
	},
	vk = {
		bonus_text = function(ply) return (ply:GetRankTable().ID > 1) and '30 кредитов' or 'VIP на 12 часов' end,
		bonus_func = function(ply) 
			if ply:GetRankTable().ID > 1 then
				ply:AddCredits(30, 'vk join')
				
			else
				RunConsoleCommand("urf", "setgroup", ply:SteamID(), 'vip', "12h", ply:GetUserGroup()) 
			end
		end,
		bonus_info = 'Подпишитесь на нашу группу ВК и напишите "Начать" в\nсообщения сообщества, чтобы бот прислал вам промокод.',
		is_promo = true,
		
		link = 'https://vk.com/im?sel=-195823193',
	},
	vk_bday_vip = {
		bonus_text = 'Временный VIP',
		bonus_func = function(ply) 
			if ply:GetRank() == 'user' then
				RunConsoleCommand("urf", "setgroup", ply:SteamID(), 'vip', "24h", ply:GetUserGroup()) 
			end
		end,
	},
	vk_bday_credits = {
		bonus_text = '75 кредитов',
		bonus_func = function(ply)
			ply:AddCredits(75, 'vk bday promo') 
		end,
	},
	vk_bday_time = {
		bonus_text = 'x10 времени на час',
		bonus_func = function(ply)
			ply:AddTimeMultiplayerSaved('vk_bday_time', 9, 60 * 60)
		end,
	},
}

/*
rp.cfg.CustomSyncHours = {
	['HL2RP'] = {
		percent = 1,
		max = 300,
	},
}
*/

local synced_ranks = {
	[2] = true,
}

rp.cfg.SyncData = {
	get = {
		['HL2RP'] = {
			{
				id = 'hours',
				max = 300,
				percent = 1,
				setter = function(ply, val)
					ply:SetNetVar('PlayTime', val * 3600)
					ba.data.UpdatePlayTime(ply)
				end,
				getter = function(ply)
					return ply:GetPlayTime() / 3600
				end,
			},
			{
				id = 'rank',
				max = 2,
				percent = 1,
				setter = function(ply, val)
					--rp.data.SetMoney(ply, val)
					--ply:SetNetVar('Money', val)
					if val and val > 1 and (ply:GetNetVar('UserGroup') or 1) < val then
						ba.data.SetRank(ply, val, ply:GetRank(), 0)
					end
				end,
				getter = function(ply)
					return ply:GetNetVar('UserGroup') or 1
				end,
			},
		},
	},
	set = {
		{
			id = 'hours',
			getter = function(ply)
				return ply.GetPlayTime and math.floor(ply:GetPlayTime() / 3600)
			end,
		},
		{
			id = 'rank',
			getter = function(ply)
				return ply.GetRank and (synced_ranks[ply:GetNetVar('UserGroup') or 1] and not (ply:GetNetVar("UsergroupExpire") and ply:GetNetVar("UsergroupExpire") >= os.time()) and ply:GetNetVar('UserGroup') or 1)
			end,
		},
	},
}

rp.cfg.CheckTeamChange = false
rp.cfg.EnableDiplomacy = true
rp.cfg.EnableAttributes = false
rp.cfg.EnableHats = false

--rp.cfg.ServerUniqID = 'hl2' .. (isС17 and '_17' or '') .. (isWhiteForest and '_wf' or '') .. (isIndsutrial and '_ind' or '')
rp.cfg.ServerUniqID = 'hl2_alyx'

rp.cfg.WhitelistedProps = [[ [{"Model":"models/balloons/balloon_classicheart.mdl"}, {"Model":"models/balloons/balloon_dog.mdl"}, {"Model":"models/balloons/balloon_star.mdl"}, {"Model":"models/cmz/combinev1.mdl"}, {"Model":"models/cmz/combinev10.mdl"}, {"Model":"models/cmz/combinev11.mdl"}, {"Model":"models/cmz/combinev12.mdl"}, {"Model":"models/cmz/combinev13.mdl"}, {"Model":"models/cmz/combinev14.mdl"}, {"Model":"models/cmz/combinev15.mdl"}, {"Model":"models/cmz/combinev16.mdl"}, {"Model":"models/cmz/combinev17.mdl"}, {"Model":"models/cmz/combinev2.mdl"}, {"Model":"models/cmz/combinev4.mdl"}, {"Model":"models/cmz/combinev5.mdl"}, {"Model":"models/cmz/combinev6.mdl"}, {"Model":"models/cmz/combinev7.mdl"}, {"Model":"models/cmz/combinev8.mdl"}, {"Model":"models/cmz/combinev9.mdl"}, {"Model":"models/cmz/combine_big1.mdl"}, {"Model":"models/cmz/combine_big10.mdl"}, {"Model":"models/cmz/combine_big11.mdl"}, {"Model":"models/cmz/combine_big12.mdl"}, {"Model":"models/cmz/combine_big13.mdl"}, {"Model":"models/cmz/combine_big14.mdl"}, {"Model":"models/cmz/combine_big15.mdl"}, {"Model":"models/cmz/combine_big16.mdl"}, {"Model":"models/cmz/combine_big17.mdl"}, {"Model":"models/cmz/combine_big2.mdl"}, {"Model":"models/cmz/combine_big4.mdl"}, {"Model":"models/cmz/combine_big5.mdl"}, {"Model":"models/cmz/combine_big6.mdl"}, {"Model":"models/cmz/combine_big7.mdl"}, {"Model":"models/cmz/combine_big8.mdl"}, {"Model":"models/cmz/combine_big9.mdl"}, {"Model":"models/combinefortification/combinebunkerbothside1.mdl"}, {"Model":"models/combinefortification/combinebunkerfront1.mdl"}, {"Model":"models/combinefortification/combinebunkergate1.mdl"}, {"Model":"models/combinefortification/combinebunkergateshied1.mdl"}, {"Model":"models/combinefortification/combinebunkernosheild.mdl"}, {"Model":"models/combinefortification/combinecheckpointlittle.mdl"}, {"Model":"models/combinefortification/combinegatelittle.mdl"}, {"Model":"models/combinefortification/combineguardcontrol.mdl"}, {"Model":"models/combinefortification/combineguardtower.mdl"}, {"Model":"models/combinefortification/combinehouse.mdl"}, {"Model":"models/combinefortification/combinemobiledefclosev1.mdl"}, {"Model":"models/combinefortification/combinemoibledefence.mdl"}, {"Model":"models/combinefortification/combinevehiculegate.mdl"}, {"Model":"models/combinefortification/combinewallv2.mdl"}, {"Model":"models/combinefortifictaionpack/cbgate02a.mdl"}, {"Model":"models/combinefortifictaionpack/cbroof.mdl"}, {"Model":"models/combinefortifictaionpack/cbwallplate.mdl"}, {"Model":"models/combinefortifictaionpack/combineheavygate01a.mdl"}, {"Model":"models/combinefortifictaionpack/pillard01a.mdl"}, {"Model":"models/combinefortifictaionpack/plate01a.mdl"}, {"Model":"models/combinefortifictaionpack/wall01a.mdl"}, {"Model":"models/combineinteriorpack/cmbarmory02a.mdl"}, {"Model":"models/combineinteriorpack/cmbcheckpoint.mdl"}, {"Model":"models/combineinteriorpack/pillard04a.mdl"}, {"Model":"models/combine_small_tv1c.mdl"}, {"Model":"models/combine_tv1.mdl"}, {"Model":"models/combine_tv2.mdl"}, {"Model":"models/combine_tv_3_1.mdl"}, {"Model":"models/hunter/blocks/cube025x025x025.mdl"}, {"Model":"models/hunter/blocks/cube025x05x025.mdl"}, {"Model":"models/hunter/blocks/cube025x075x025.mdl"}, {"Model":"models/hunter/blocks/cube025x125x025.mdl"}, {"Model":"models/hunter/blocks/cube025x150x025.mdl"}, {"Model":"models/hunter/blocks/cube025x1x025.mdl"}, {"Model":"models/hunter/blocks/cube025x2x025.mdl"}, {"Model":"models/hunter/blocks/cube025x3x025.mdl"}, {"Model":"models/hunter/blocks/cube025x4x025.mdl"}, {"Model":"models/hunter/blocks/cube025x5x025.mdl"}, {"Model":"models/hunter/blocks/cube025x6x025.mdl"}, {"Model":"models/hunter/blocks/cube025x7x025.mdl"}, {"Model":"models/hunter/blocks/cube025x8x025.mdl"}, {"Model":"models/hunter/blocks/cube05x05x025.mdl"}, {"Model":"models/hunter/blocks/cube05x05x05.mdl"}, {"Model":"models/hunter/blocks/cube05x075x025.mdl"}, {"Model":"models/hunter/blocks/cube05x105x05.mdl"}, {"Model":"models/hunter/blocks/cube05x1x025.mdl"}, {"Model":"models/hunter/blocks/cube05x1x05.mdl"}, {"Model":"models/hunter/blocks/cube05x2x025.mdl"}, {"Model":"models/hunter/blocks/cube05x2x05.mdl"}, {"Model":"models/hunter/blocks/cube05x3x025.mdl"}, {"Model":"models/hunter/blocks/cube05x3x05.mdl"}, {"Model":"models/hunter/blocks/cube05x4x025.mdl"}, {"Model":"models/hunter/blocks/cube05x4x05.mdl"}, {"Model":"models/hunter/blocks/cube05x5x025.mdl"}, {"Model":"models/hunter/blocks/cube05x5x05.mdl"}, {"Model":"models/hunter/blocks/cube05x6x025.mdl"}, {"Model":"models/hunter/blocks/cube05x6x05.mdl"}, {"Model":"models/hunter/blocks/cube05x7x025.mdl"}, {"Model":"models/hunter/blocks/cube05x7x05.mdl"}, {"Model":"models/hunter/blocks/cube05x8x025.mdl"}, {"Model":"models/hunter/blocks/cube05x8x05.mdl"}, {"Model":"models/hunter/blocks/cube075x075x025.mdl"}, {"Model":"models/hunter/blocks/cube075x075x075.mdl"}, {"Model":"models/hunter/blocks/cube075x1x025.mdl"}, {"Model":"models/hunter/blocks/cube075x2x025.mdl"}, {"Model":"models/hunter/blocks/cube075x2x075.mdl"}, {"Model":"models/hunter/blocks/cube075x3x025.mdl"}, {"Model":"models/hunter/blocks/cube075x4x025.mdl"}, {"Model":"models/hunter/blocks/cube075x6x025.mdl"}, {"Model":"models/hunter/blocks/cube075x8x025.mdl"}, {"Model":"models/hunter/blocks/cube1x150x1.mdl"}, {"Model":"models/hunter/blocks/cube1x1x025.mdl"}, {"Model":"models/hunter/blocks/cube1x1x1.mdl"}, {"Model":"models/hunter/blocks/cube1x2x025.mdl"}, {"Model":"models/hunter/blocks/cube1x3x025.mdl"}, {"Model":"models/hunter/blocks/cube1x4x025.mdl"}, {"Model":"models/hunter/blocks/cube1x5x025.mdl"}, {"Model":"models/hunter/blocks/cube1x6x025.mdl"}, {"Model":"models/hunter/blocks/cube1x7x025.mdl"}, {"Model":"models/hunter/blocks/cube1x8x025.mdl"}, {"Model":"models/hunter/blocks/cube2x2x025.mdl"}, {"Model":"models/hunter/blocks/cube2x3x025.mdl"}, {"Model":"models/hunter/blocks/cube2x4x025.mdl"}, {"Model":"models/hunter/blocks/cube2x6x025.mdl"}, {"Model":"models/hunter/blocks/cube3x3x025.mdl"}, {"Model":"models/hunter/blocks/cube3x4x025.mdl"}, {"Model":"models/hunter/blocks/cube3x6x025.mdl"}, {"Model":"models/hunter/blocks/cube3x8x025.mdl"}, {"Model":"models/hunter/blocks/cube4x4x025.mdl"}, {"Model":"models/hunter/blocks/cube8x8x05.mdl"}, {"Model":"models/hunter/blocks/cube8x8x1.mdl"}, {"Model":"models/hunter/geometric/hex025x1.mdl"}, {"Model":"models/hunter/geometric/hex1x1.mdl"}, {"Model":"models/hunter/geometric/pent1x1.mdl"}, {"Model":"models/hunter/geometric/tri1x1eq.mdl"}, {"Model":"models/hunter/misc/lift2x2.mdl"}, {"Model":"models/hunter/misc/platehole1x1a.mdl"}, {"Model":"models/hunter/misc/platehole4x4.mdl"}, {"Model":"models/hunter/misc/shell2x2b.mdl"}, {"Model":"models/hunter/misc/shell2x2c.mdl"}, {"Model":"models/hunter/misc/shell2x2d.mdl"}, {"Model":"models/hunter/misc/stair1x1.mdl"}, {"Model":"models/hunter/plates/plate1x1.mdl"}, {"Model":"models/hunter/plates/plate1x2.mdl"}, {"Model":"models/hunter/plates/plate1x3.mdl"}, {"Model":"models/hunter/plates/plate1x4.mdl"}, {"Model":"models/hunter/plates/plate1x5.mdl"}, {"Model":"models/hunter/plates/plate1x6.mdl"}, {"Model":"models/hunter/plates/plate1x7.mdl"}, {"Model":"models/hunter/plates/plate1x8.mdl"}, {"Model":"models/hunter/plates/plate2x2.mdl"}, {"Model":"models/hunter/plates/plate2x3.mdl"}, {"Model":"models/hunter/plates/plate2x4.mdl"}, {"Model":"models/hunter/plates/plate2x5.mdl"}, {"Model":"models/hunter/plates/plate3x3.mdl"}, {"Model":"models/hunter/plates/plate3x4.mdl"}, {"Model":"models/hunter/plates/plate3x5.mdl"}, {"Model":"models/hunter/plates/plate3x6.mdl"}, {"Model":"models/hunter/plates/plate4x4.mdl"}, {"Model":"models/hunter/plates/plate5x5.mdl"}, {"Model":"models/hunter/plates/platehole1x1.mdl"}, {"Model":"models/hunter/plates/platehole1x2.mdl"}, {"Model":"models/hunter/plates/platehole2x2.mdl"}, {"Model":"models/hunter/plates/platehole3.mdl"}, {"Model":"models/hunter/triangles/025x025.mdl"}, {"Model":"models/hunter/triangles/025x025mirrored.mdl"}, {"Model":"models/hunter/triangles/05x05.mdl"}, {"Model":"models/hunter/triangles/05x05mirrored.mdl"}, {"Model":"models/hunter/triangles/075x075.mdl"}, {"Model":"models/hunter/triangles/075x075mirrored.mdl"}, {"Model":"models/hunter/triangles/1x05x1.mdl"}, {"Model":"models/hunter/triangles/1x1.mdl"}, {"Model":"models/hunter/triangles/1x1mirrored.mdl"}, {"Model":"models/hunter/triangles/1x1x1.mdl"}, {"Model":"models/hunter/triangles/1x1x5.mdl"}, {"Model":"models/hunter/triangles/2x2.mdl"}, {"Model":"models/hunter/triangles/2x2mirrored.mdl"}, {"Model":"models/hunter/triangles/3x3.mdl"}, {"Model":"models/hunter/triangles/3x3mirrored.mdl"}, {"Model":"models/hunter/triangles/4x4.mdl"}, {"Model":"models/hunter/triangles/4x4mirrored.mdl"}, {"Model":"models/hunter/triangles/5x5.mdl"}, {"Model":"models/hunter/tubes/circle2x2.mdl"}, {"Model":"models/hunter/tubes/circle2x2b.mdl"}, {"Model":"models/hunter/tubes/circle2x2c.mdl"}, {"Model":"models/hunter/tubes/circle2x2d.mdl"}, {"Model":"models/hunter/tubes/circle4x4.mdl"}, {"Model":"models/hunter/tubes/tube1x1x1.mdl"}, {"Model":"models/hunter/tubes/tube1x1x1b.mdl"}, {"Model":"models/hunter/tubes/tube1x1x1c.mdl"}, {"Model":"models/hunter/tubes/tube1x1x2.mdl"}, {"Model":"models/hunter/tubes/tube1x1x2b.mdl"}, {"Model":"models/hunter/tubes/tube1x1x2c.mdl"}, {"Model":"models/hunter/tubes/tube1x1x3.mdl"}, {"Model":"models/hunter/tubes/tube1x1x3c.mdl"}, {"Model":"models/hunter/tubes/tube1x1x4.mdl"}, {"Model":"models/hunter/tubes/tube1x1x4c.mdl"}, {"Model":"models/hunter/tubes/tube1x1x4d.mdl"}, {"Model":"models/hunter/tubes/tube1x1x5.mdl"}, {"Model":"models/hunter/tubes/tube1x1x5b.mdl"}, {"Model":"models/hunter/tubes/tube1x1x5c.mdl"}, {"Model":"models/hunter/tubes/tube1x1x5d.mdl"}, {"Model":"models/hunter/tubes/tube1x1x6.mdl"}, {"Model":"models/hunter/tubes/tube1x1x6b.mdl"}, {"Model":"models/hunter/tubes/tube1x1x6c.mdl"}, {"Model":"models/hunter/tubes/tube1x1x6d.mdl"}, {"Model":"models/hunter/tubes/tube1x1x8.mdl"}, {"Model":"models/hunter/tubes/tube1x1x8b.mdl"}, {"Model":"models/hunter/tubes/tube1x1x8c.mdl"}, {"Model":"models/hunter/tubes/tube1x1x8d.mdl"}, {"Model":"models/hunter/tubes/tube2x2x+.mdl"}, {"Model":"models/hunter/tubes/tube2x2x025.mdl"}, {"Model":"models/hunter/tubes/tube2x2x025c.mdl"}, {"Model":"models/hunter/tubes/tube2x2x05.mdl"}, {"Model":"models/hunter/tubes/tube2x2x05b.mdl"}, {"Model":"models/hunter/tubes/tube2x2x05c.mdl"}, {"Model":"models/hunter/tubes/tube2x2x05d.mdl"}, {"Model":"models/hunter/tubes/tube2x2x1.mdl"}, {"Model":"models/hunter/tubes/tube2x2x1b.mdl"}, {"Model":"models/hunter/tubes/tube2x2x1c.mdl"}, {"Model":"models/hunter/tubes/tube2x2x1d.mdl"}, {"Model":"models/hunter/tubes/tube2x2x2.mdl"}, {"Model":"models/hunter/tubes/tube2x2x2b.mdl"}, {"Model":"models/hunter/tubes/tube2x2x2c.mdl"}, {"Model":"models/hunter/tubes/tube2x2x2d.mdl"}, {"Model":"models/hunter/tubes/tube2x2x4.mdl"}, {"Model":"models/hunter/tubes/tube2x2x4b.mdl"}, {"Model":"models/hunter/tubes/tube2x2x4c.mdl"}, {"Model":"models/hunter/tubes/tube2x2x4d.mdl"}, {"Model":"models/hunter/tubes/tube2x2x8.mdl"}, {"Model":"models/hunter/tubes/tube2x2x8b.mdl"}, {"Model":"models/hunter/tubes/tube2x2x8c.mdl"}, {"Model":"models/hunter/tubes/tube2x2x8d.mdl"}, {"Model":"models/hunter/tubes/tube2x2xt.mdl"}, {"Model":"models/hunter/tubes/tube2x2xta.mdl"}, {"Model":"models/hunter/tubes/tube2x2xtb.mdl"}, {"Model":"models/hunter/tubes/tube4x4x05.mdl"}, {"Model":"models/hunter/tubes/tube4x4x05b.mdl"}, {"Model":"models/hunter/tubes/tube4x4x05c.mdl"}, {"Model":"models/hunter/tubes/tube4x4x1.mdl"}, {"Model":"models/hunter/tubes/tube4x4x1b.mdl"}, {"Model":"models/hunter/tubes/tube4x4x1c.mdl"}, {"Model":"models/hunter/tubes/tube4x4x1d.mdl"}, {"Model":"models/hunter/tubes/tube4x4x1to2x2.mdl"}, {"Model":"models/hunter/tubes/tube4x4x2b.mdl"}, {"Model":"models/hunter/tubes/tube4x4x2c.mdl"}, {"Model":"models/hunter/tubes/tube4x4x2d.mdl"}, {"Model":"models/hunter/tubes/tubebend1x1x90.mdl"}, {"Model":"models/hunter/tubes/tubebend1x2x90b.mdl"}, {"Model":"models/hunter/tubes/tubebend2x2x90.mdl"}, {"Model":"models/hunter/tubes/tubebend2x2x90outer.mdl"}, {"Model":"models/hunter/tubes/tubebend2x2x90square.mdl"}, {"Model":"models/hunter/tubes/tubebendinsidesquare2.mdl"}, {"Model":"models/hunter/tubes/tubebendoutsidesquare.mdl"}, {"Model":"models/hunter/tubes/tubebendoutsidesquare2.mdl"}, {"Model":"models/items/357ammo.mdl"}, {"Model":"models/items/ammocrate_ar2.mdl"}, {"Model":"models/items/ammocrate_grenade.mdl"}, {"Model":"models/items/ammocrate_rockets.mdl"}, {"Model":"models/items/boxmrounds.mdl"}, {"Model":"models/mechanics/gears2/pinion_20t1.mdl"}, {"Model":"models/mechanics/gears2/pinion_20t2.mdl"}, {"Model":"models/mechanics/gears2/pinion_20t3.mdl"}, {"Model":"models/mechanics/solid_steel/box_beam_4.mdl"}, {"Model":"models/mechanics/solid_steel/i_beam_4.mdl"}, {"Model":"models/military/boothwindow.mdl"}, {"Model":"models/military/doorframe.mdl"}, {"Model":"models/military/glasspane.mdl"}, {"Model":"models/military/metalcover.mdl"}, {"Model":"models/military/metalstairs.mdl"}, {"Model":"models/military/platform1.mdl"}, {"Model":"models/military/platform2.mdl"}, {"Model":"models/military/platform3.mdl"}, {"Model":"models/military/platform4.mdl"}, {"Model":"models/military/platform5.mdl"}, {"Model":"models/military/railing128.mdl"}, {"Model":"models/military/stairset.mdl"}, {"Model":"models/military/windowbig.mdl"}, {"Model":"models/nova/chair_wood01.mdl"}, {"Model":"models/phxtended/tri1x1x1solid.mdl"}, {"Model":"models/phxtended/tri2x1x2solid.mdl"}, {"Model":"models/phxtended/tri2x2x2solid.mdl"}, {"Model":"models/props/door1.mdl"}, {"Model":"models/props/door2.mdl"}, {"Model":"models/props/door4.mdl"}, {"Model":"models/props/door5.mdl"}, {"Model":"models/props/fence1.mdl"}, {"Model":"models/props/fence2.mdl"}, {"Model":"models/props/fence3.mdl"}, {"Model":"models/props/fence5.mdl"}, {"Model":"models/props/fence6.mdl"}, {"Model":"models/props/fence7.mdl"}, {"Model":"models/props/fence8.mdl"}, {"Model":"models/props/fence9.mdl"}, {"Model":"models/props/floor3.mdl"}, {"Model":"models/props/floor3_quarter.mdl"}, {"Model":"models/props/foundation01.mdl"}, {"Model":"models/props/platform3.mdl"}, {"Model":"models/props/roof1.mdl"}, {"Model":"models/props/roof3.mdl"}, {"Model":"models/props/roof_grate1.mdl"}, {"Model":"models/props/stairhalf.mdl"}, {"Model":"models/props/stair_pref1.mdl"}, {"Model":"models/props/stair_pref2.mdl"}, {"Model":"models/props/storefront.mdl"}, {"Model":"models/props/wall10.mdl"}, {"Model":"models/props/wall3.mdl"}, {"Model":"models/props/wall4.mdl"}, {"Model":"models/props/wall5.mdl"}, {"Model":"models/props/wall6.mdl"}, {"Model":"models/props/wall7.mdl"}, {"Model":"models/props/wall8.mdl"}, {"Model":"models/props/wallcap4.mdl"}, {"Model":"models/props/wallcap5.mdl"}, {"Model":"models/props/wallcap6.mdl"}, {"Model":"models/props/wallcap7.mdl"}, {"Model":"models/props/wallcap8.mdl"}, {"Model":"models/props/wallcap9.mdl"}, {"Model":"models/props/window1.mdl"}, {"Model":"models/props/window2.mdl"}, {"Model":"models/props/window3.mdl"}, {"Model":"models/props/window4.mdl"}, {"Model":"models/props/window5.mdl"}, {"Model":"models/props_borealis/bluebarrel001.mdl"}, {"Model":"models/props_borealis/borealis_door001a.mdl"}, {"Model":"models/props_borealis/mooring_cleat01.mdl"}, {"Model":"models/props_c17/bench01a.mdl"}, {"Model":"models/props_c17/briefcase001a.mdl"}, {"Model":"models/props_c17/cashregister01a.mdl"}, {"Model":"models/props_c17/chair02a.mdl"}, {"Model":"models/props_c17/chair_kleiner03a.mdl"}, {"Model":"models/props_c17/chair_office01a.mdl"}, {"Model":"models/props_c17/chair_stool01a.mdl"}, {"Model":"models/props_c17/computer01_keyboard.mdl"}, {"Model":"models/props_c17/display_cooler01a.mdl"}, {"Model":"models/props_c17/door01_left.mdl"}, {"Model":"models/props_c17/door02_double.mdl"}, {"Model":"models/props_c17/fence01a.mdl"}, {"Model":"models/props_c17/fence01b.mdl"}, {"Model":"models/props_c17/fence02a.mdl"}, {"Model":"models/props_c17/fence02b.mdl"}, {"Model":"models/props_c17/fence03a.mdl"}, {"Model":"models/props_c17/furniturebed001a.mdl"}, {"Model":"models/props_c17/furniturechair001a.mdl"}, {"Model":"models/props_c17/furniturecouch001a.mdl"}, {"Model":"models/props_c17/furniturecouch002a.mdl"}, {"Model":"models/props_c17/furniturecupboard001a.mdl"}, {"Model":"models/props_c17/furnituredrawer001a.mdl"}, {"Model":"models/props_c17/furnituredrawer001a_chunk01.mdl"}, {"Model":"models/props_c17/furnituredrawer001a_chunk02.mdl"}, {"Model":"models/props_c17/furnituredrawer001a_chunk03.mdl"}, {"Model":"models/props_c17/furnituredrawer001a_chunk05.mdl"}, {"Model":"models/props_c17/furnituredrawer001a_chunk06.mdl"}, {"Model":"models/props_c17/furnituredrawer002a.mdl"}, {"Model":"models/props_c17/furnituredrawer003a.mdl"}, {"Model":"models/props_c17/furnituredresser001a.mdl"}, {"Model":"models/props_c17/furniturefridge001a.mdl"}, {"Model":"models/props_c17/furnituremattress001a.mdl"}, {"Model":"models/props_c17/furnitureradiator001a.mdl"}, {"Model":"models/props_c17/furnitureshelf001a.mdl"}, {"Model":"models/props_c17/furnitureshelf001b.mdl"}, {"Model":"models/props_c17/furnitureshelf002a.mdl"}, {"Model":"models/props_c17/furnituresink001a.mdl"}, {"Model":"models/props_c17/furniturestove001a.mdl"}, {"Model":"models/props_c17/furnituretable001a.mdl"}, {"Model":"models/props_c17/furnituretable002a.mdl"}, {"Model":"models/props_c17/furnituretable003a.mdl"}, {"Model":"models/props_c17/furnituretoilet001a.mdl"}, {"Model":"models/props_c17/furniturewashingmachine001a.mdl"}, {"Model":"models/props_c17/gaspipes006a.mdl"}, {"Model":"models/props_c17/gate_door01a.mdl"}, {"Model":"models/props_c17/gravestone001a.mdl"}, {"Model":"models/props_c17/gravestone002a.mdl"}, {"Model":"models/props_c17/gravestone003a.mdl"}, {"Model":"models/props_c17/gravestone004a.mdl"}, {"Model":"models/props_c17/gravestone_coffinpiece001a.mdl"}, {"Model":"models/props_c17/gravestone_coffinpiece002a.mdl"}, {"Model":"models/props_c17/gravestone_cross001b.mdl"}, {"Model":"models/props_c17/lamp001a.mdl"}, {"Model":"models/props_c17/lampshade001a.mdl"}, {"Model":"models/props_c17/lockers001a.mdl"}, {"Model":"models/props_c17/metalladder001.mdl"}, {"Model":"models/props_c17/oildrum001.mdl"}, {"Model":"models/props_c17/playgroundtick-tack-toe_block01a.mdl"}, {"Model":"models/props_c17/playground_teetertoter_seat.mdl"}, {"Model":"models/props_c17/playground_teetertoter_stan.mdl"}, {"Model":"models/props_c17/pottery02a.mdl"}, {"Model":"models/props_c17/pottery03a.mdl"}, {"Model":"models/props_c17/pottery05a.mdl"}, {"Model":"models/props_c17/pottery07a.mdl"}, {"Model":"models/props_c17/pottery08a.mdl"}, {"Model":"models/props_c17/pottery09a.mdl"}, {"Model":"models/props_c17/shelfunit01a.mdl"}, {"Model":"models/props_c17/streetsign001c.mdl"}, {"Model":"models/props_c17/streetsign002b.mdl"}, {"Model":"models/props_c17/streetsign003b.mdl"}, {"Model":"models/props_c17/streetsign004e.mdl"}, {"Model":"models/props_c17/streetsign004f.mdl"}, {"Model":"models/props_c17/streetsign005b.mdl"}, {"Model":"models/props_c17/streetsign005c.mdl"}, {"Model":"models/props_c17/streetsign005d.mdl"}, {"Model":"models/props_c17/suitcase_passenger_physics.mdl"}, {"Model":"models/props_c17/tv_monitor01.mdl"}, {"Model":"models/props_combine/breenbust.mdl"}, {"Model":"models/props_combine/breenchair.mdl"}, {"Model":"models/props_combine/breenclock.mdl"}, {"Model":"models/props_combine/breenconsole.mdl"}, {"Model":"models/props_combine/breendesk.mdl"}, {"Model":"models/props_combine/breenglobe.mdl"}, {"Model":"models/props_combine/breenpod.mdl"}, {"Model":"models/props_combine/breenpod_inner.mdl"}, {"Model":"models/props_combine/cell_01_pod.mdl"}, {"Model":"models/props_combine/cell_01_pod_cheap.mdl"}, {"Model":"models/props_combine/combinebutton.mdl"}, {"Model":"models/props_combine/combine_barricade_bracket01a.mdl"}, {"Model":"models/props_combine/combine_barricade_bracket01b.mdl"}, {"Model":"models/props_combine/combine_barricade_bracket02a.mdl"}, {"Model":"models/props_combine/combine_barricade_bracket02b.mdl"}, {"Model":"models/props_combine/combine_barricade_med01a.mdl"}, {"Model":"models/props_combine/combine_barricade_med01b.mdl"}, {"Model":"models/props_combine/combine_barricade_med02a.mdl"}, {"Model":"models/props_combine/combine_barricade_med02b.mdl"}, {"Model":"models/props_combine/combine_barricade_med02c.mdl"}, {"Model":"models/props_combine/combine_barricade_med03b.mdl"}, {"Model":"models/props_combine/combine_barricade_med04b.mdl"}, {"Model":"models/props_combine/combine_barricade_short01a.mdl"}, {"Model":"models/props_combine/combine_barricade_short02a.mdl"}, {"Model":"models/props_combine/combine_barricade_short03a.mdl"}, {"Model":"models/props_combine/combine_barricade_tall01a.mdl"}, {"Model":"models/props_combine/combine_barricade_tall01b.mdl"}, {"Model":"models/props_combine/combine_barricade_tall03a.mdl"}, {"Model":"models/props_combine/combine_barricade_tall03b.mdl"}, {"Model":"models/props_combine/combine_barricade_tall04a.mdl"}, {"Model":"models/props_combine/combine_barricade_tall04b.mdl"}, {"Model":"models/props_combine/combine_booth_med01a.mdl"}, {"Model":"models/props_combine/combine_booth_short01a.mdl"}, {"Model":"models/props_combine/combine_emitter01.mdl"}, {"Model":"models/props_combine/combine_fence01a.mdl"}, {"Model":"models/props_combine/combine_fence01b.mdl"}, {"Model":"models/props_combine/combine_interface001.mdl"}, {"Model":"models/props_combine/combine_interface002.mdl"}, {"Model":"models/props_combine/combine_interface003.mdl"}, {"Model":"models/props_combine/combine_intmonitor001.mdl"}, {"Model":"models/props_combine/combine_intmonitor003.mdl"}, {"Model":"models/props_combine/combine_intwallunit.mdl"}, {"Model":"models/props_combine/combine_light001a.mdl"}, {"Model":"models/props_combine/combine_light002a.mdl"}, {"Model":"models/props_combine/combine_window001.mdl"}, {"Model":"models/props_combine/headcrabcannister01a.mdl"}, {"Model":"models/props_combine/masterinterface.mdl"}, {"Model":"models/props_combine/railing_128.mdl"}, {"Model":"models/props_combine/railing_256.mdl"}, {"Model":"models/props_combine/railing_512.mdl"}, {"Model":"models/props_combine/railing_corner_inside.mdl"}, {"Model":"models/props_combine/railing_corner_outside.mdl"}, {"Model":"models/props_debris/metal_panel01a.mdl"}, {"Model":"models/props_debris/metal_panel02a.mdl"}, {"Model":"models/props_debris/wall001a_base.mdl"}, {"Model":"models/props_docks/dock01_pole01a_128.mdl"}, {"Model":"models/props_docks/dock01_pole01a_256.mdl"}, {"Model":"models/props_doors/door03_slotted_left.mdl"}, {"Model":"models/props_forest/bunkbed.mdl"}, {"Model":"models/props_forest/bunkbed2.mdl"}, {"Model":"models/props_interiors/bathtub01a.mdl"}, {"Model":"models/props_interiors/furniture_chair03a.mdl"}, {"Model":"models/props_interiors/furniture_couch01a.mdl"}, {"Model":"models/props_interiors/furniture_couch02a.mdl"}, {"Model":"models/props_interiors/furniture_desk01a.mdl"}, {"Model":"models/props_interiors/furniture_lamp01a.mdl"}, {"Model":"models/props_interiors/furniture_shelf01a.mdl"}, {"Model":"models/props_interiors/furniture_vanity01a.mdl"}, {"Model":"models/props_interiors/pot01a.mdl"}, {"Model":"models/props_interiors/pot02a.mdl"}, {"Model":"models/props_interiors/radiator01a.mdl"}, {"Model":"models/props_interiors/refrigerator01a.mdl"}, {"Model":"models/props_interiors/refrigeratordoor01a.mdl"}, {"Model":"models/props_interiors/refrigeratordoor02a.mdl"}, {"Model":"models/props_interiors/sinkkitchen01a.mdl"}, {"Model":"models/props_interiors/vendingmachinesoda01a.mdl"}, {"Model":"models/props_interiors/vendingmachinesoda01a_door.mdl"}, {"Model":"models/props_junk/cardboard_box001a.mdl"}, {"Model":"models/props_junk/cardboard_box001a_gib01.mdl"}, {"Model":"models/props_junk/cardboard_box001b.mdl"}, {"Model":"models/props_junk/cardboard_box002a.mdl"}, {"Model":"models/props_junk/cardboard_box002a_gib01.mdl"}, {"Model":"models/props_junk/cardboard_box002b.mdl"}, {"Model":"models/props_junk/cinderblock01a.mdl"}, {"Model":"models/props_junk/garbage128_composite001b.mdl"}, {"Model":"models/props_junk/garbage128_composite001c.mdl"}, {"Model":"models/props_junk/garbage_milkcarton002a.mdl"}, {"Model":"models/props_junk/glassbottle01a.mdl"}, {"Model":"models/props_junk/glassjug01.mdl"}, {"Model":"models/props_junk/harpoon002a.mdl"}, {"Model":"models/props_junk/metalbucket01a.mdl"}, {"Model":"models/props_junk/metalbucket02a.mdl"}, {"Model":"models/props_junk/metalgascan.mdl"}, {"Model":"models/props_junk/plasticbucket001a.mdl"}, {"Model":"models/props_junk/plasticcrate01a.mdl"}, {"Model":"models/props_junk/popcan01a.mdl"}, {"Model":"models/props_junk/pushcart01a.mdl"}, {"Model":"models/props_junk/ravenholmsign.mdl"}, {"Model":"models/props_junk/shovel01a.mdl"}, {"Model":"models/props_junk/trafficcone001a.mdl"}, {"Model":"models/props_junk/trashbin01a.mdl"}, {"Model":"models/props_junk/trashdumpster02b.mdl"}, {"Model":"models/props_junk/wood_crate001a.mdl"}, {"Model":"models/props_junk/wood_crate001a_damaged.mdl"}, {"Model":"models/props_junk/wood_crate002a.mdl"}, {"Model":"models/props_junk/wood_pallet001a.mdl"}, {"Model":"models/props_lab/bewaredog.mdl"}, {"Model":"models/props_lab/blastdoor001a.mdl"}, {"Model":"models/props_lab/blastdoor001b.mdl"}, {"Model":"models/props_lab/blastdoor001c.mdl"}, {"Model":"models/props_lab/cactus.mdl"}, {"Model":"models/props_lab/desklamp01.mdl"}, {"Model":"models/props_lab/filecabinet02.mdl"}, {"Model":"models/props_lab/frame002a.mdl"}, {"Model":"models/props_lab/harddrive01.mdl"}, {"Model":"models/props_lab/harddrive02.mdl"}, {"Model":"models/props_lab/huladoll.mdl"}, {"Model":"models/props_lab/kennel_physics.mdl"}, {"Model":"models/props_lab/monitor01a.mdl"}, {"Model":"models/props_lab/monitor01b.mdl"}, {"Model":"models/props_lab/monitor02.mdl"}, {"Model":"models/props_lab/reciever01a.mdl"}, {"Model":"models/props_lab/workspace003.mdl"}, {"Model":"models/props_phx/construct/concrete_barrier00.mdl"}, {"Model":"models/props_phx/construct/concrete_barrier01.mdl"}, {"Model":"models/props_phx/construct/glass/glass_angle180.mdl"}, {"Model":"models/props_phx/construct/glass/glass_angle360.mdl"}, {"Model":"models/props_phx/construct/glass/glass_angle90.mdl"}, {"Model":"models/props_phx/construct/glass/glass_curve180x1.mdl"}, {"Model":"models/props_phx/construct/glass/glass_curve180x2.mdl"}, {"Model":"models/props_phx/construct/glass/glass_curve360x1.mdl"}, {"Model":"models/props_phx/construct/glass/glass_curve360x2.mdl"}, {"Model":"models/props_phx/construct/glass/glass_curve90x1.mdl"}, {"Model":"models/props_phx/construct/glass/glass_curve90x2.mdl"}, {"Model":"models/props_phx/construct/glass/glass_dome180.mdl"}, {"Model":"models/props_phx/construct/glass/glass_dome90.mdl"}, {"Model":"models/props_phx/construct/glass/glass_plate1x1.mdl"}, {"Model":"models/props_phx/construct/glass/glass_plate1x2.mdl"}, {"Model":"models/props_phx/construct/glass/glass_plate2x2.mdl"}, {"Model":"models/props_phx/construct/glass/glass_plate2x4.mdl"}, {"Model":"models/props_phx/construct/glass/glass_plate4x4.mdl"}, {"Model":"models/props_phx/construct/metal_angle180.mdl"}, {"Model":"models/props_phx/construct/metal_angle360.mdl"}, {"Model":"models/props_phx/construct/metal_angle90.mdl"}, {"Model":"models/props_phx/construct/metal_dome180.mdl"}, {"Model":"models/props_phx/construct/metal_dome90.mdl"}, {"Model":"models/props_phx/construct/metal_plate1.mdl"}, {"Model":"models/props_phx/construct/metal_plate1x2.mdl"}, {"Model":"models/props_phx/construct/metal_plate1x2_tri.mdl"}, {"Model":"models/props_phx/construct/metal_plate1_tri.mdl"}, {"Model":"models/props_phx/construct/metal_plate2x2.mdl"}, {"Model":"models/props_phx/construct/metal_plate2x2_tri.mdl"}, {"Model":"models/props_phx/construct/metal_plate2x4.mdl"}, {"Model":"models/props_phx/construct/metal_plate2x4_tri.mdl"}, {"Model":"models/props_phx/construct/metal_plate4x4.mdl"}, {"Model":"models/props_phx/construct/metal_plate4x4_tri.mdl"}, {"Model":"models/props_phx/construct/metal_plate_curve.mdl"}, {"Model":"models/props_phx/construct/metal_plate_curve180.mdl"}, {"Model":"models/props_phx/construct/metal_plate_curve180x2.mdl"}, {"Model":"models/props_phx/construct/metal_plate_curve2.mdl"}, {"Model":"models/props_phx/construct/metal_plate_curve2x2.mdl"}, {"Model":"models/props_phx/construct/metal_plate_curve360.mdl"}, {"Model":"models/props_phx/construct/metal_plate_curve360x2.mdl"}, {"Model":"models/props_phx/construct/metal_plate_pipe.mdl"}, {"Model":"models/props_phx/construct/metal_tube.mdl"}, {"Model":"models/props_phx/construct/metal_tubex2.mdl"}, {"Model":"models/props_phx/construct/metal_wire1x1.mdl"}, {"Model":"models/props_phx/construct/metal_wire1x1x1.mdl"}, {"Model":"models/props_phx/construct/metal_wire1x1x2.mdl"}, {"Model":"models/props_phx/construct/metal_wire1x1x2b.mdl"}, {"Model":"models/props_phx/construct/metal_wire1x2.mdl"}, {"Model":"models/props_phx/construct/metal_wire1x2b.mdl"}, {"Model":"models/props_phx/construct/metal_wire1x2x2b.mdl"}, {"Model":"models/props_phx/construct/metal_wire2x2.mdl"}, {"Model":"models/props_phx/construct/metal_wire2x2b.mdl"}, {"Model":"models/props_phx/construct/metal_wire2x2x2b.mdl"}, {"Model":"models/props_phx/construct/metal_wire_angle180x1.mdl"}, {"Model":"models/props_phx/construct/metal_wire_angle180x2.mdl"}, {"Model":"models/props_phx/construct/metal_wire_angle360x1.mdl"}, {"Model":"models/props_phx/construct/metal_wire_angle90x1.mdl"}, {"Model":"models/props_phx/construct/metal_wire_angle90x2.mdl"}, {"Model":"models/props_phx/construct/plastic/plastic_angle_360.mdl"}, {"Model":"models/props_phx/construct/windows/window1x1.mdl"}, {"Model":"models/props_phx/construct/windows/window1x2.mdl"}, {"Model":"models/props_phx/construct/windows/window2x4.mdl"}, {"Model":"models/props_phx/construct/windows/window4x4.mdl"}, {"Model":"models/props_phx/construct/windows/window_angle180.mdl"}, {"Model":"models/props_phx/construct/windows/window_angle360.mdl"}, {"Model":"models/props_phx/construct/windows/window_angle90.mdl"}, {"Model":"models/props_phx/construct/windows/window_curve180x1.mdl"}, {"Model":"models/props_phx/construct/windows/window_curve180x2.mdl"}, {"Model":"models/props_phx/construct/windows/window_curve360x1.mdl"}, {"Model":"models/props_phx/construct/windows/window_curve90x1.mdl"}, {"Model":"models/props_phx/construct/windows/window_curve90x2.mdl"}, {"Model":"models/props_phx/construct/wood/wood_boardx1.mdl"}, {"Model":"models/props_phx/games/chess/black_bishop.mdl"}, {"Model":"models/props_phx/games/chess/black_dama.mdl"}, {"Model":"models/props_phx/games/chess/black_king.mdl"}, {"Model":"models/props_phx/games/chess/black_knight.mdl"}, {"Model":"models/props_phx/games/chess/black_pawn.mdl"}, {"Model":"models/props_phx/games/chess/black_queen.mdl"}, {"Model":"models/props_phx/games/chess/black_rook.mdl"}, {"Model":"models/props_phx/games/chess/white_bishop.mdl"}, {"Model":"models/props_phx/games/chess/white_dama.mdl"}, {"Model":"models/props_phx/games/chess/white_king.mdl"}, {"Model":"models/props_phx/games/chess/white_knight.mdl"}, {"Model":"models/props_phx/games/chess/white_pawn.mdl"}, {"Model":"models/props_phx/games/chess/white_queen.mdl"}, {"Model":"models/props_phx/games/chess/white_rook.mdl"}, {"Model":"models/props_phx/rt_screen.mdl"}, {"Model":"models/props_rooftop/satellitedish02.mdl"}, {"Model":"models/props_trainstation/bench_indoor001a.mdl"}, {"Model":"models/props_trainstation/payphone001a.mdl"}, {"Model":"models/props_trainstation/tracksign02.mdl"}, {"Model":"models/props_trainstation/tracksign07.mdl"}, {"Model":"models/props_trainstation/tracksign08.mdl"}, {"Model":"models/props_trainstation/tracksign09.mdl"}, {"Model":"models/props_trainstation/tracksign10.mdl"}, {"Model":"models/props_trainstation/traincar_seats001.mdl"}, {"Model":"models/props_trainstation/trainstation_clock001.mdl"}, {"Model":"models/props_trainstation/trainstation_post001.mdl"}, {"Model":"models/props_trainstation/trashcan_indoor001a.mdl"}, {"Model":"models/props_trainstation/trashcan_indoor001b.mdl"}, {"Model":"models/props_wasteland/barricade001a.mdl"}, {"Model":"models/props_wasteland/barricade002a.mdl"}, {"Model":"models/props_wasteland/cafeteria_bench001a.mdl"}, {"Model":"models/props_wasteland/cafeteria_table001a.mdl"}, {"Model":"models/props_wasteland/controlroom_chair001a.mdl"}, {"Model":"models/props_wasteland/controlroom_desk001a.mdl"}, {"Model":"models/props_wasteland/controlroom_desk001b.mdl"}, {"Model":"models/props_wasteland/controlroom_filecabinet001a.mdl"}, {"Model":"models/props_wasteland/controlroom_filecabinet002a.mdl"}, {"Model":"models/props_wasteland/controlroom_storagecloset001a.mdl"}, {"Model":"models/props_wasteland/exterior_fence001a.mdl"}, {"Model":"models/props_wasteland/exterior_fence001b.mdl"}, {"Model":"models/props_wasteland/exterior_fence002a.mdl"}, {"Model":"models/props_wasteland/exterior_fence002b.mdl"}, {"Model":"models/props_wasteland/exterior_fence002c.mdl"}, {"Model":"models/props_wasteland/exterior_fence002d.mdl"}, {"Model":"models/props_wasteland/exterior_fence003a.mdl"}, {"Model":"models/props_wasteland/exterior_fence003b.mdl"}, {"Model":"models/props_wasteland/interior_fence001a.mdl"}, {"Model":"models/props_wasteland/interior_fence001b.mdl"}, {"Model":"models/props_wasteland/interior_fence001c.mdl"}, {"Model":"models/props_wasteland/interior_fence001d.mdl"}, {"Model":"models/props_wasteland/interior_fence001e.mdl"}, {"Model":"models/props_wasteland/interior_fence001g.mdl"}, {"Model":"models/props_wasteland/interior_fence002a.mdl"}, {"Model":"models/props_wasteland/interior_fence002b.mdl"}, {"Model":"models/props_wasteland/interior_fence002c.mdl"}, {"Model":"models/props_wasteland/interior_fence002e.mdl"}, {"Model":"models/props_wasteland/interior_fence002f.mdl"}, {"Model":"models/props_wasteland/interior_fence003a.mdl"}, {"Model":"models/props_wasteland/interior_fence003b.mdl"}, {"Model":"models/props_wasteland/interior_fence003d.mdl"}, {"Model":"models/props_wasteland/interior_fence003e.mdl"}, {"Model":"models/props_wasteland/kitchen_counter001a.mdl"}, {"Model":"models/props_wasteland/kitchen_counter001b.mdl"}, {"Model":"models/props_wasteland/kitchen_counter001c.mdl"}, {"Model":"models/props_wasteland/kitchen_fridge001a.mdl"}, {"Model":"models/props_wasteland/kitchen_shelf001a.mdl"}, {"Model":"models/props_wasteland/kitchen_shelf002a.mdl"}, {"Model":"models/props_wasteland/laundry_cart001.mdl"}, {"Model":"models/props_wasteland/laundry_cart002.mdl"}, {"Model":"models/props_wasteland/light_spotlight01_lamp.mdl"}, {"Model":"models/props_wasteland/prison_bedframe001b.mdl"}, {"Model":"models/props_wasteland/prison_celldoor001b.mdl"}, {"Model":"models/props_wasteland/prison_cellwindow002a.mdl"}, {"Model":"models/props_wasteland/prison_heater001a.mdl"}, {"Model":"models/props_wasteland/prison_shelf002a.mdl"}, {"Model":"models/props_wasteland/wood_fence02a.mdl"}, {"Model":"models/rt screens/computer_monitor.mdl"}, {"Model":"models/rt screens/monitor01a.mdl"}, {"Model":"models/rt screens/monitor01b.mdl"}, {"Model":"models/rt screens/monitor02.mdl"}, {"Model":"models/rt screens/tv_monitor01.mdl"}, {"Model":"models/weapons/w_c4_planted.mdl"}] ]]

rp.cfg.MaxArmor = 500

rp.cfg.TimeMultiplayer = 0

rp.cfg.RewardRelations = {}
rp.cfg.TeamSpawns = {}
rp.cfg.TeamSpawns[game.GetMap()] = {}

noDonate = isIndsutrial

rp.cfg.PimpRandomNames = {'Вортигонт'}

rp.cfg.ConsultUrl = 'https://vk.com/consultanturfim'

rp.cfg.MoTD = {
	{"Правила", "https://docs.google.com/document/d/16w_tCbPiufLrEMLU1ykHP8486R142z8me0He0kd7YR4/preview"},
	{"Группа ВК", "https://vk.com/halfliferoleplayalyx"},
	{"Группа Steam", "http://steamcommunity.com/groups/urfimofficial"},
	{"Контент", "https://steamcommunity.com/sharedfiles/filedetails/?id=2092637718"},
}

rp.cfg.DoorsSignaling = {
	--["combine_forcefield"] = true,
	--["combine_forcefield_reversed"] = true,
	--["combine_forcefield_big"] = true,
	--["combine_forcefield_cwu"] = true,
}

rp.cfg.AdminBase = {
	['rp_city17_alyx_urfim'] = Vector(3884, 5750, 2512),
}

rp.cfg.PremiumConfig = {
	{
		job = function() return TEAM_HEVMK2 end,
		sequence = 'd1_t01_breakroom_watchbreen',
	},
	{
		job = function() return TEAM_GMAN end,
		sequence = 'idle_all_01',
	},
	{
		job = function() return TEAM_CWU_LARRY end,
		sequence = 'pose_standing_02',
	},
	{
		job = function() return TEAM_PILOTGRID end,
		sequence = 'pose_standing_01',
	},
}

rp.cfg.MeleeWeapons = {
	"weapon_hl2brokenbottle",
	"weapon_hl2pot",
	"weapon_hl2shovel",
	"weapon_hl2axe",
	"weapon_hl2pipe",
	"weapon_hl2hook",
}

rp.cfg.MaxRenderDistance = 4100
rp.cfg.timeJobRecovery = 600

rp.cfg.saveProps = {
	timeSave = 60,
	timeRecovery = 600,
	timeFileDelete = 86400,
	ents = {
		["ent_picture"] = {
			save = function(ent) return util.TableToJSON({url = ent:GetURL(), color = ent:GetColor()}) end,
            load = function(ent, arg) args = util.JSONToTable(args) if istable(args) then ent:SetURL(args[1]) ent:SetColor(args[2]) end end,
		},
		["armor_lab"] = {},
		["microwave"] = {},
		["media_radio"] = {},
		["media_projector"] = {},
		["media_tv"] = {},
		["money_printer"] = {},
	},
}

rp.cfg.ZombieMRadius = 2000;
rp.cfg.ZombieMDelay1 = 30;
rp.cfg.ZombieMDelay2 = 10;

rp.cfg.AllianceDispatcherCooldown = 210;
rp.cfg.AllianceDispatcher = {
	['rp_city17_urfim'] = {
		['D4 Сектор'] = {
			Camera = {
				Pos = Vector(394, 3614, 360),
				Ang = Angle(0, 127, 0)
			},
			Deploy = {
				Vector(-102, 4034, 78),
				Vector(195, 4553, 84),
				Vector(797, 3952, 82)
			}
		},
		
		['Жилой Район'] = {
			Camera = {
				Pos = Vector(-2531, -2280, 344),
				Ang = Angle(0, 145, 0)
			},
			Deploy = {
				Vector(-3019, -1915, 93),
				Vector(-2449, -2210, 84),
				Vector(-3282, -2344, 82)
			}
		},

		['D6 Сектор'] = {
			Camera = {
				Pos = Vector(-2211, -3360, 399),
				Ang = Angle(0, -123, 0)
			},
			Deploy = {
				Vector(-2478.006836, -3668.503174, 104.031250),
				Vector(-2369, -3420, 126),
				Vector(-2693, -3841, 88)
			}
		},
	},
}

rp.cfg.DrawMultiplayer = 6400

rp.cfg.Fog = {
	Day = {
		fogStart = 800,
		fogEnd = 1000,
		col = Color(184, 201, 220),
		fogDensity = 1
	},
	Night = {
		fogStart = 800,
		fogEnd = 1000,
		col = Color(184, 201, 220),
		fogDensity = 1
	}
}

/*
rp.cfg.Skybox = {
    Day = 'skybox/sky_ep02_05_hdr',
    Night = 'skybox/sky_day01_09_hdr',
    Default = 'skybox/sky_ep02_05_hdr',
}
*/

rp.cfg.NightDuration = 10 * 60
rp.cfg.DayDuration = 50 * 60

rp.cfg.AppearanceScaleMin = 0.9
rp.cfg.AppearanceScaleMax = 1.1

rp.cfg.SurviveTimeMultiplayer = {
	{duration = 10 * 60, multiplayer = 0.1},
	{duration = 25 * 60, multiplayer = 0.25},
	{duration = 50 * 60, multiplayer = 0.5},
	{duration = 80 * 60, multiplayer = 0.7},
	{duration = 120 * 60, multiplayer = 1},
}

rp.cfg.RespawnTime = isSerious && 30 || 1


//EmoteActions.GmodActs = {
//    { "cheer",    "Радость",          "Эмоции"   },
//    { "laugh",    "Смех",             "Эмоции"   },
//    { "muscle",   "Бицуха",           "Насмешки" },
//    { "zombie",   "Зомби",            "Насмешки" },
//    { "robot",    "Робот",            "Насмешки" },
//    { "dance",    "Танец",            "Насмешки" },
//    { "agree",    "Согласиться",      "Эмоции"   },
//    { "becon",    "сюда иди",         "Эмоции"   },
//    { "disagree", "Не согласиться",   "Эмоции"   },
//    { "salute",   "Платить респекты", "Эмоции"   },
//    { "wave",     "Помахать",         "Эмоции"   },
//    { "forward",  "Указать",          "Эмоции"   },
//    { "pers",     "Журавль",          "Насмешки" }
//};

-- Stamina
rp.cfg.MaxStamina = isSerious && 70 || 50
rp.cfg.StaminaRestoreTime = 30

rp.cfg.InitialAttributePoints = 100

rp.cfg.ZombieReward = 50

rp.cfg.RewardCooldown = 2 * 60
rp.cfg.DemoteCooldown = isSerious && 5 || 2 * 60

rp.cfg.MaxPrinters = 3

rp.cfg.MayorKillReward = 2500
rp.cfg.MayorDelay = 300

rp.cfg.StartMoney 		= 1000
rp.cfg.StartKarma		= 50

rp.cfg.OrgCost 			= 10000

rp.cfg.HungerRate 		= 1200

rp.cfg.DoorCostMin		= 50
rp.cfg.DoorCostMax 		= 100
rp.cfg.PropertyTax		= 10

rp.cfg.PropLimit 		= 30

rp.cfg.RagdollDelete	= 60

-- Speed
rp.cfg.WalkSpeed 		= 120
rp.cfg.RunSpeed 		= 280

-- Printers
rp.cfg.PrintDelay 		= 60
rp.cfg.PrintAmount = 25
rp.cfg.InkCost 			= 15

-- Hits
rp.cfg.HitExpire		= 600
rp.cfg.HitCoolDown 		= 300
rp.cfg.HitMinCost 		= 50
rp.cfg.HitMaxCost 		= 1000

-- Afk
rp.cfg.AfkDemote 		= (60 * 15) * 1
rp.cfg.AfkPropRemove 	= (60 * 25) * 1
rp.cfg.AfkDoorSell 		= (60 * 30) * 1
rp.cfg.AfkKick			= (60 * 90) * 1

-- Nigh time
rp.cfg.StartNightTimeMultiplier	= 23
rp.cfg.EndNightTimeMultiplier	= 9
rp.cfg.NightTimeMultiplier 		= 1 -- 100%

-- Gabrage
rp.cfg.GabrageModels = {'models/props_lab/jar01a.mdl', 'models/props_junk/plasticbucket001a.mdl', 'models/props_junk/cardboard_box004a.mdl', 'models/props_c17/FurnitureDrawer001a_Chunk02.mdl',  'models/props_lab/reciever01b.mdl', 'models/props_lab/reciever01a.mdl', 'models/props_lab/bindergreen.mdl', 'models/props_lab/bindergreenlabel.mdl', 'models/props_lab/binderblue.mdl', 'models/props_lab/clipboard.mdl'}
rp.cfg.GabrageSpawnPos = {

}
rp.cfg.GabrageBox = {

}


rp.cfg.StashContent = {

}

rp.cfg.Stashes = {

}

rp.cfg.DialogueNPCs = {
	rp_city17_alyx_urfim = {
		{Vector(8189.465820, 2549.145264, 6984.714355), Angle(0.000, 90.000, 0.000), "terminal"}, 
    	{Vector(-3341, 249, 150), Angle(0, 0, 0), "rassel"}, 
    }
}  

rp.cfg.SurviveTimeMultiplayer = {
	{duration = 10 * 60, multiplayer = 0.1},
	{duration = 25 * 60, multiplayer = 0.25},
	{duration = 50 * 60, multiplayer = 0.5},
	{duration = 80 * 60, multiplayer = 0.7},
	{duration = 120 * 60, multiplayer = 1},
}

rp.cfg.FactoryMoney = 30
rp.cfg.FactoryBoxMoney = 10

rp.cfg.RationFactory = {
/*
	rp_city17_urfim = { 
		spawners = {
			{
				spawner_1 = Vector(-1257.467163, 2817.330078, 174.467163),
				spawner_2 = Vector(-1214.028076, 2817.286621, 174.466095),
				buttonVec = Vector(-1187.952515, 2849.863770, 112.345039),
				buttonAng = Angle(0.000, 90.000, 0.000),
			},
			{
				spawner_1 = Vector(-1164.479004, 2817.237061, 174.464874),
				spawner_2 = Vector(-1120.169922, 2817.193115, 174.463776),
				buttonVec = Vector(-1096.727173, 2849.863525, 112.345039),
				buttonAng = Angle(0.000, 90.000, 0.000),
			},
			{
				spawner_1 = Vector(-1070.530762, 2817.143555, 174.462540),
				spawner_2 = Vector(-1024.061646, 2817.097168, 174.461395),
				buttonVec = Vector(-1000.481873, 2849.863525, 112.345039),
				buttonAng = Angle(0.000, 90.000, 0.000),
			},
			{
				spawner_1 = Vector(-976.252502, 2817.049316, 174.460205),
				spawner_2 = Vector(-930.683411, 2817.003662, 174.459076),
				buttonVec = Vector(-906.256592, 2849.863525, 112.345039),
				buttonAng = Angle(0.000, 90.000, 0.000),
			},
			{
				spawner_1 = Vector(-881.084290, 2816.954102, 174.457855),
				spawner_2 = Vector(-835.965210, 2816.908936, 174.456726),
				buttonVec = Vector(-807.561279, 2849.863525, 112.345039),
				buttonAng = Angle(0.000, 90.000, 0.000),
			},

		},
		boxes = {
			{Vector(-756.694641, 2971.791016, 122.930222), Angle(0.000, 0.000, 0.000)},
			{Vector(-757.751648, 2893.784424, 122.755905), Angle(0.000, 0.000, 0.000)},
			{Vector(-759.961792, 2894.384521, 101.042664), Angle(0.000, 0.000, 0.000)},
			{Vector(-757.628967, 2972.185547, 101.158676), Angle(0.000, 0.000, 0.000)},
			{Vector(-756.672241, 2970.583984, 162.945694), Angle(0.000, 0.000, 0.000)},
			{Vector(-756.490356, 2894.073975, 161.649063), Angle(0.000, 0.000, 0.000)},
		},
		FactoryZone = {Vector(-1454, 2792, -11), Vector(-93, 3711, 550),} -- Зона фабрики
	},
*/
}

rp.cfg.Lockdowns = {
	{uid = 'Nabor_go', name = 'Набор в ГО', desc = 'Внимание! Объявлен Набор в Гражданскую Оборону! Всем желающим подойти ко двору Нексус Надзора!', color = Color(72, 255, 255), sound = "ambient/alarms/apc_alarm_pass1.wav", length = 12},
    {uid = 'Nabor_ota', name = 'Чипировка в ОТА', desc = 'Внимание! Объявлена Чипировка в ОТА! Всем желающим подойти ко двору Нексус Надзора!', color = Color(58, 95, 205), sound = "ambient/alarms/apc_alarm_pass1.wav", length = 12},
	{uid = 'Nabor_vseob', name = 'Всеобщая Мобилизация', desc = 'Внимание! Объявлена всеобщая мобилизация в Альянс! Всем желающим подойти ко двору Нексус Надзора!', color = Color(78, 238, 148), sound = "ambient/alarms/apc_alarm_pass1.wav", length = 12},
	{uid = 'Postroenie_go', name = 'Код Построения ГО', desc = 'Внимание! Объявлен Код Построения! Всем сотрудникам ГО прибыть в Нексус Надзор!', color = Color(72, 255, 255), sound = "ambient/alarms/apc_alarm_pass1.wav", length = 12},
	{uid = 'Postroenie_ota', name = 'Код Построения ОТА', desc = 'Внимание! Объявлен Код Построения! Всем сотрудникам ОТА прибыть в Нексус Надзор!', color = Color(58, 95, 205), sound = "ambient/alarms/apc_alarm_pass1.wav", length = 12},
	{uid = 'Postroenie_vseob', name = 'Всеобщий Код Построения', desc = 'Внимание! Объявлен Код Построения! Всем сотрудникам Альянса прибыть в Нексус Надзор!', color = Color(78, 238, 148), sound = "ambient/alarms/apc_alarm_pass1.wav", length = 12},
	{uid = 'Lockdown_A', name = 'Комендантский час', desc = 'Внимание! Объявлен Комендантский час! Займите назначенные для инспекции места.', color = Color(148, 0, 211), sound = "ambient/alarms/scanner_alert_pass1.wav", length = 12},
	{uid = 'vilazka', name = 'Вылазка в запретные сектора', desc = 'Внимание! Альянс проводит вылазку в запретные сектора! ', color = Color(255, 64, 64), sound = "ambient/alarms/scanner_alert_pass1.wav", length = 14},
	{uid = 'Zheltiikod', name = 'Желтый Код', desc = 'Внимание! Объявлен Желтый Код! Гражданским лицам, пройти в здания. В ином случае вас арестуют!', color = Color(255, 250, 0), sound = "ambient/alarms/scanner_alert_pass1.wav", length = 14},
	{uid = 'Agwar', name = 'Нападение на Администратора Города', desc = 'Внимание! Нападение на Администратора Города! Гражданским лицам, пройти в здания. В ином случае вас арестуют!', color = Color(255, 250, 0), sound = "ambient/alarms/scanner_alert_pass1.wav", length = 14},
	{uid = 'Krasnikod', name = 'Красный Код', desc = 'Внимание! Объявлен Красный Код! Гражданским лицам, пройти в здания. В ином случае вас ампутируют!', color = Color(255, 0, 0), sound = "ambient/alarms/scanner_alert_pass1.wav", length = 12},
	{uid = 'Necrotic', name = 'Нападение Некротиков', desc = 'Внимание! Нападение Некротиков! Гражданским лицам, пройти в здания. В ином случае вас ампутируют!', color = Color(255, 0, 0), sound = "ambient/alarms/scanner_alert_pass1.wav", length = 12},
	{uid = 'F_besporadki', name = 'Беспорядки в Городе', desc = 'Внимание! Беспорядки в Городе! Гражданским лицам, пройти в здания. В ином случае вас ампутируют!', color = Color(255, 0, 0), sound = "ambient/alarms/scanner_alert_pass1.wav", length = 12},
	{uid = 'Vostanie', name = 'Восстание в Городе', desc = 'Внимание! Восстание в Городе! Гражданским лицам, пройти в здания. В ином случае вас ампутируют!', color = Color(255, 0, 0), sound = "ambient/alarms/scanner_alert_pass1.wav", length = 12},
	{uid = 'V_raid', name = 'Рейд Альянса', desc = 'Внимание! Объявлен Рейд! Гражданским лицам, пройти в здания. В ином случае вас ампутируют!', color = Color(255, 0, 0), sound = "ambient/alarms/scanner_alert_pass1.wav", length = 14},
}

rp.AtmosphericSounds = { -- todo
	rp_city17_alyx_urfim = {
		{  
			sound = 'music/HL2_song26_trainstation1.mp3',
			pos = {Vector(2722.366943, 1798.420166, 38.406067), Vector(5685, 5126, 1102)}, -- ГП
			soundLevel = 40,
		},
		{  
			sound = 'music/HL2_song19.mp3',
			pos = {Vector(396.151154, 2726.339600, 38.290874), Vector(2499, 5220, 427)}, -- Вокзал
			soundLevel = 40,
		},
		{  
			sound = 'music/HL2_song1.mp3',
			pos = {Vector(-1992.933472, -2025.624878, 38.359623), Vector(4082.585938, -251.320801, 764.278809)}, -- D6
			soundLevel = 40,
		},
		{  
			sound = 'music/HL2_song2.mp3',
			pos = {Vector(2750.378906, 5922.312012, 38.329319), Vector(5862, 9207, 1043)}, -- D4
			soundLevel = 40,
		},
		{  
			sound = 'music/HL2_song23_SuitSong3.mp3',
			pos = {Vector(-5350, -1788, -275), Vector(-2232, 660, 1015)}, -- Повстанцы
			soundLevel = 40,
		},
		{  
			sound = 'music/HL2_song27_trainstation2.mp3',
			pos = {Vector(1868, 3885, -1098), Vector(4029, 8931, -302)}, -- Убежище
			soundLevel = 40,
		},
		{  
			sound = 'music/HL2_song25_Teleporter.mp3',
			pos = {Vector(7914, 2062, 2214), Vector(8073.741699, 2213.726074, 7193.854492),}, -- кабинет АГ
			soundLevel = 40,
		},
	},
}
rp.cfg.DefaultVoices = {
	{
		label = 'Привет', // кнопка в меню
		sound = 'vo/npc/male01/hi01.wav', 
		text = 'Привет.' // текст в чате
	},
	{
		label = 'Да',
		sound = 'vo/npc/male01/yeah02.wav',
		text = 'Да!',
	},
	{
		label = 'Нет',
		sound = 'vo/npc/male01/no01.wav',
		text = 'Нет!',
	},
	{
		label = 'Хорошо',
		sound = 'vo/npc/male01/ok01.wav',
		text = 'Хорошо.'
	},
	{
		label = 'Отлично',
		sound = 'vo/npc/male01/nice.wav',
		text = 'Отлично.'
	},
	{
		label = 'Вперёд',
		sound = 'vo/npc/male01/letsgo01.wav',
		text = 'Вперёд!'
	},
	{
		label = 'Я ранен',
		sound = 'vo/npc/male01/imhurt01.wav',
		text = 'Я ранен!'
	},
	{
		label = 'Извини',
		sound = 'vo/npc/male01/sorry01.wav',
		text = 'Извини.'
	},
	{
		label = 'В укрытие',
		sound = 'vo/npc/male01/takecover02.wav',
		text = 'В укрытие!'
	},
	{
		label = 'Осторожно',
		sound = 'vo/npc/male01/watchout.wav',
		text = 'Осторожно!',
	},
	{
		label = 'Убирайся',
		sound = 'vo/npc/male01/gethellout.wav',
		text = 'Убирайся!'
	},
	{
		label = 'Есть один',
		sound = 'vo/npc/male01/gotone01.wav',
		text = 'Есть один!',
	},
	{
		label = 'Помогите',
		sound = 'vo/npc/male01/help01.wav',
		text = 'Помогите!',
	},
	{
		label = 'Воина не кончится',
		sound = 'cit/question01.wav',
		text = 'Эта война вообще, похоже, не кончится.',
	},
	{
		label = 'Свобода',
		sound = 'cit/question07.wav',
		text = 'Чувствуешь? Это свобода!',
	},
	{
		label = 'Мало шансов',
		sound = 'cit/question21.wav',
		text = 'Я конечно не игрок, но шансов у нас мало...',
	},
	{
		label = 'Хуже и хуже',
		sound = 'cit/question12.wav',
		text = 'Мне сдается, что все идет только хуже и хуже!',
	},
	{
		label = 'Смысл был',
		sound = 'cit/vanswer09.wav',
		text = 'В этом почти был смысл...',
	},
	{
		label = 'Женюсь',
		sound = 'cit/question29.wav',
		text = 'Когда все кончится, я женюсь!',
	},
	{
		label = 'Альянс лучше',
		sound = 'cit/cit_remarks20.wav',
		text = 'Верите или нет, но при Альянсе мне было лучше...',
	},
	{
		label = 'Не крабы',
		sound = 'cit/cit_remarks19.wav',
		text = 'Хоть они и зовутся крабами, но на вкус совсем не похожи.',
	},
}


rp.cfg.TrashDestroyReward = 10
rp.cfg.MaxQuery = 10
-- NPC
rp.cfg.CampNPCBounty = 100
rp.cfg.CampNPCRespawnTime = 60

rp.cfg.NPCs = {
	rp_whiteforest_urfim = {
		{npcs = "npc_poisonzombie", pos = Vector(-881, -464, -1152), rewardAll = true, health = 1700, respawnTime = rp.cfg.CampNPCRespawnTime * 10, bounty = rp.cfg.CampNPCBounty * 5}, -- mine
		{npcs = "npc_poisonzombie", pos = Vector(-2390, -942, -1151), rewardAll = true, health = 1700, respawnTime = rp.cfg.CampNPCRespawnTime * 10, bounty = rp.cfg.CampNPCBounty * 5}, -- mine
		{npcs = "npc_zombie", pos = Vector(-1152, -1095, -1152), rewardAll = true, health = 650, respawnTime = rp.cfg.CampNPCRespawnTime * 2, bounty = rp.cfg.CampNPCBounty * 0.6}, --mine
		{npcs = "npc_zombie", pos = Vector(-1109, -861, -1152), rewardAll = true, health = 700, respawnTime = rp.cfg.CampNPCRespawnTime * 2, bounty = rp.cfg.CampNPCBounty * 0.6}, --mine
		{npcs = "npc_zombie", pos = Vector(-1601, -596, -1152), rewardAll = true, health = 700, respawnTime = rp.cfg.CampNPCRespawnTime * 2, bounty = rp.cfg.CampNPCBounty * 0.7}, --mine
		{npcs = "npc_zombie", pos = Vector(-1339, -1381, -1152), rewardAll = true, health = 750, respawnTime = rp.cfg.CampNPCRespawnTime * 2, bounty = rp.cfg.CampNPCBounty * 0.8}, --mine
		{npcs = "npc_zombie", pos = Vector(-239, -805, -1152), rewardAll = true, health = 700, respawnTime = rp.cfg.CampNPCRespawnTime * 2, bounty = rp.cfg.CampNPCBounty * 0.6}, --mine
		{npcs = "npc_zombie", pos = Vector(-1624, -809, -1152), rewardAll = true, health = 700, respawnTime = rp.cfg.CampNPCRespawnTime * 2, bounty = rp.cfg.CampNPCBounty * 0.7}, --mine
		{npcs = "npc_zombie", pos = Vector(-1147, -615, -1152), rewardAll = true, health = 720, respawnTime = rp.cfg.CampNPCRespawnTime * 5, bounty = rp.cfg.CampNPCBounty * 0.5}, --mine
		{npcs = "npc_fastzombie", pos = Vector(-3516, -919, -1146), rewardAll = true, health = 810, respawnTime = rp.cfg.CampNPCRespawnTime * 5, bounty = rp.cfg.CampNPCBounty * 1}, --mine
		{npcs = "npc_fastzombie", pos = Vector(-1319, 1302, -1143), rewardAll = true, health = 850, respawnTime = rp.cfg.CampNPCRespawnTime * 5, bounty = rp.cfg.CampNPCBounty * 1}, --mine
		{npcs = "npc_fastzombie", pos = Vector(-1539, -1261, -1088), rewardAll = true, health = 870, respawnTime = rp.cfg.CampNPCRespawnTime * 5, bounty = rp.cfg.CampNPCBounty * 1}, --mine
		{npcs = "npc_fastzombie", pos = Vector(273, -1362, -1152), rewardAll = true, health = 840, respawnTime = rp.cfg.CampNPCRespawnTime * 5, bounty = rp.cfg.CampNPCBounty * 1}, --mine
		{npcs = "npc_poisonzombie", pos = Vector(-1678, -1096, -1152), rewardAll = true, health = 1500, respawnTime = rp.cfg.CampNPCRespawnTime * 5, bounty = rp.cfg.CampNPCBounty * 5}, --mine 
		--
        {npcs = "npc_headcrab_black", pos = Vector(-1544.515015, -1817.906494, -1081.812500), rewardAll = true, health = 700, respawnTime = rp.cfg.CampNPCRespawnTime * 0.5, bounty = rp.cfg.CampNPCBounty * 2}, 
		{npcs = "npc_headcrab_black", pos = Vector(-3064.349365, -1296.635254, -1145.812500), rewardAll = true, health = 450, respawnTime = rp.cfg.CampNPCRespawnTime * 0.5, bounty = rp.cfg.CampNPCBounty * 0.5}, 
        {npcs = "npc_headcrab_fast", pos = Vector(-1087.560791, 10138.983398, -1145.812500), rewardAll = true, health = 500, respawnTime = rp.cfg.CampNPCRespawnTime * 0.5, bounty = rp.cfg.CampNPCBounty * 0.5},
        {npcs = "npc_headcrab_fast", pos = Vector(1121.538452, 411.163513, -1465.812500), rewardAll = true, health = 600, respawnTime = rp.cfg.CampNPCRespawnTime * 0.5, bounty = rp.cfg.CampNPCBounty * 0.5},  
 	},
 	rp_industrial17_urfim = {},
}

-- Lotto
rp.cfg.MinLotto 		= 100
rp.cfg.MaxLotto 		= 5000

rp.cfg.DefaultLaws 		= [[Законы City 17

- Ампутация: Убийство, проникновение на территорию Нексус Надзора, D6 или D7, нахождение на строительных лесах, сотрудничество с Анти Коллаборационистами, анти общественная деятельность, оружие, прооявление эмоций или инстинктов.
- Карцер: Повторное нарушение "Перевоспитания", вандализм, помеха работе сотрудникам Альянса, лозунги против Альянса, контрабанда, нелегальные вещи, скрытие лица, отказ от работы в ГСР для граждан с низкой и средней лояльностью.
- Перевоспитание: Непослушание, бег, прыжки, курение в общественных местах, оскорбление сотрудников Альянса.
]] 

rp.cfg.DisallowDrop = {
	arrest_stick 	= true,
	door_ram 		= true,
	gmod_camera 	= true,
	gmod_tool 		= true,
	keys 			= true,
	med_kit 		= true,
	pocket 			= true,
	stunstick 		= true,
	unarrest_stick 	= true,
	weapon_keypadchecker = true,
	weapon_physcannon = true,
	weapon_physgun 	= true,
	weaponchecker 	= true,
	weapon_fists 	= true
}

rp.cfg.GreenZones = {
	rp_c18_divrp = {
		--{Vector(638, 2854, 1094), Vector(1581, 3906, 1693),},
	},
	rp_city17_build210 = {
	--	{Vector(2373, -3141, -573), Vector(3055, -2131, 500),}
	},
	rp_industrial17_urfim = {
	--	{Vector(5104, 4720, 328), Vector(6372, 5535, 466),}
	},
	rp_city17_urfim = {
	},
	rp_mk_city17_urfim = {
	},
	rp_city17_alyx_urfim = {
	},
}


rp.cfg.SpawnPoints = {}

function rp.AddSpawnPoint(name, t)
	t = t[game.GetMap()]
	if t then
		local id = #rp.cfg.SpawnPoints+1
		rp.cfg.SpawnPoints[id] = {
			Name = name,
			Spawns = t.Spawns,
			Model = t.Model,
			Pos = t.Pos,
			Ang = t.Ang,
			ID = id
		}
		return id
	end
	return 0
end

rp.cfg.DefaultSpawnPoints = {

}

rp.cfg.DefaultWeapons = {
	'weapon_hands',
	'weapon_physgun',
	'gmod_tool',
	'keys',
}

rp.cfg.ScannerSpawns = {
	rp_city17_alyx_urfim = {
		{Vector(4776, 3418, 681), Angle(0, -180, 0)},
		{Vector(4755, 3730, 681), Angle(0, -180, 0)}
	},
}

rp.cfg.Scenes = {
	rp_city17_alyx_urfim = {
		{
			Model = 'models/breen.mdl',
			Pos = Vector(1290.500122, 3803.964355, 47.433594),
			Ang = Angle(0.000, 180.000, 0.000),
			Scene = "scenes/breencast/collaboration.vcd",
			Delay = 15
		},
	},	
}

rp.cfg.Forcefields = {
	rp_city17_alyx_urfim = {}
}

rp.cfg.VendingMachinesNPC = {
	rp_city8_urfim = {
		{
			Pos = Vector(-2271.734131, 874.188477, 48.267384),
			Ang = Angle(0.000, -90.000, 0.000),
			NPCPos = Vector(-2204.442139, 857.604004, 0.031250),
			NPCAng = Angle(0.000, 237.447, 0.000),
		}
	}
}
rp.cfg.VendingMachines = {
	rp_mk_city17_urfim = {}
}
rp.cfg.RationDispenser = {
	rp_city17_alyx_urfim = {}
}
rp.cfg.CombineLocks = {
	rp_city17_alyx_urfim = {}
}

rp.cfg.VendingPopcanPrice = 6
rp.cfg.SpaycanRefill = 50

rp.cfg.Static = {
	rp_city17_alyx_urfim = {},
}

rp.cfg.MaterialOverride = {

}

-- Cop shops
rp.cfg.CopShops = {
	rp_city17_alyx_urfim = {},
}
-- Drug buyers
rp.cfg.DrugBuyers = {
	rp_city17_alyx_urfim = {},
}
-- Arcade
rp.cfg.Arcades = {
    rp_city17_alyx_urfim = {},
}

-- Spawn
rp.cfg.SpawnDisallow = {
	prop_physics		= true,
	media_radio 		= true,
	media_tv 			= true,
	ent_textscreen 		= true,
	ent_picture 		= true,
	gmod_rtcameraprop	= true,
	metal_detector		= true,
	flag 				= true,
}

rp.cfg.DisableCores = {
	attributes = true
	--inventory = true
}

rp.cfg.DisableModules = {
	daynight = true
}

rp.cfg.Spawns = {
	rp_city17_alyx_urfim = {
		Vector(326.282562, 2750.306396, 38.249310),
		Vector(1337.654907, 4601.646973, 261.721558),
	}
}


rp.cfg.TeamSpawns = rp.cfg.TeamSpawns or {
	rp_city17_alyx_urfim = {

	}
}


rp.cfg.SpawnPos = rp.cfg.SpawnPos or {
	rp_city17_alyx_urfim = {
		Vector(-218, 3785, 32),
		Vector(-100, 3785, 32),
		Vector(0, 3785, 32),
		Vector(100, 3785, 32),
		Vector(200, 3785, 32),
		Vector(300, 3785, 32),
		Vector(400, 3785, 32),
		Vector(500, 3785, 32),
		Vector(600, 3785, 32),
		Vector(700, 3785, 32),
		Vector(800, 3785, 32),
		Vector(900, 3785, 32),
		Vector(1005, 3785, 32),
		Vector(-218, 3727, 32),
		Vector(-100, 3727, 32),
		Vector(0, 3727, 32),
		Vector(100, 3727, 32),
		Vector(200, 3727, 32),
		Vector(300, 3727, 32),
		Vector(400, 3727, 32),
		Vector(500, 3727, 32),
		Vector(600, 3727, 32),
		Vector(700, 3727, 32),
		Vector(800, 3727, 32),
		Vector(900, 3727, 32),
		Vector(1005, 3727, 32),
		Vector(-218, 3649, 32),
		Vector(-100, 3649, 32),
		Vector(0, 3649, 32),
		Vector(100, 3649, 32),
		Vector(200, 3649, 32),
		Vector(300, 3649, 32),
		Vector(400, 3649, 32),
		Vector(500, 3649, 32),
		Vector(600, 3649, 32),
		Vector(700, 3649, 32),
		Vector(800, 3649, 32),
		Vector(900, 3649, 32),
		Vector(1005, 3649, 32),
		Vector(500, 3007, 32),
		Vector(600, 3007, 32),
		Vector(700, 3007, 32),
		Vector(800, 3007, 32),
		Vector(900, 3007, 32),
		Vector(1000, 3007, 32),
		Vector(1100, 3007, 32),
		Vector(1200, 3007, 32),
		Vector(500, 2943, 32),
		Vector(600, 2943, 32),
		Vector(700, 2943, 32),
		Vector(800, 2943, 32),
		Vector(900, 2943, 32),
		Vector(1000, 2943, 32),
		Vector(1100, 2943, 32),
		Vector(1200, 2943, 32),
		Vector(500, 2804, 32),
		Vector(600, 2804, 32),
		Vector(700, 2804, 32),
		Vector(800, 2804, 32),
		Vector(900, 2804, 32),
		Vector(1000, 2804, 32),
		Vector(1100, 2804, 32),
		Vector(1200, 2804, 32),
		Vector(1100, 3669, 32),
		Vector(1100, 3800, 32),
		Vector(1100, 3900, 32),
		Vector(1100, 4000, 32),
		Vector(1100, 4100, 32),
		Vector(1100, 4218, 32),
		Vector(1221, 3669, 32),
		Vector(1221, 3800, 32),
		Vector(1221, 3900, 32),
		Vector(1221, 4000, 32),
		Vector(1221, 4100, 32),
		Vector(1221, 4218, 32),
	},
}

-- Jail
rp.cfg.WantedTime		= 600
rp.cfg.WarrantTime		= 600
rp.cfg.ArrestTimeMin 	= 30
rp.cfg.ArrestTimeMax 	= 600

rp.cfg.Jails = {
	rp_city17_alyx_urfim = {
		Vector(5865, 2978, -411),
		Vector(7628, 4238, 429),
	}
}

rp.cfg.JailPos = {
	rp_city17_alyx_urfim = {
		Vector(7108, 3341, -272),
		Vector(6970, 3340, -272),
		Vector(6813, 3340, -272),
	}
}

-- Theater

rp.cfg.Theaters = {
	/*
	rp_city17_alyx_urfim = {
		Screen = {
		},
		Projector = {
		},
	},
	*/
}


rp.RadioChanels = {}

-- Automated announcements
rp.cfg.AnnouncementDelay = 360
rp.cfg.Announcements = {
	'Радио слишком громкое? Лагает из-за дыма? Все эти проблемы и многое другое можно решить в настройках (F4->Настройки).',
	'garry\'s mod — значит urf.im',
	'Чтобы не пропустить важные новости об обновлениях, акциях, мероприятиях и т.п., подпишись на нашу ВК группу - https://vk.com/halfliferoleplayalyx',
	'Кто-то ДМит? Блочит? Летает на пропах? Напиши @ <текст обращения> в чат, чтобы вызвать админа.',
	'Есть какие-то вопросы? Наша команда администраторов с радостью тебе поможет! Напиши @ <текст обращения> в чат, чтобы вызвать админа.',
	'Ознакомиться с правилами, подписаться на наши группы ВК и Steam, а также скачать контент сервера можно нажав F1.',
	'Подпишись на наш контент сервера, чтобы ускорить время загрузки (F1->Контент).',
	'Ждём вас в нашем Discord сервере, введи в браузере www.urf.im/discord/ чтобы подключиться.',
	'Если вы устали можно присесть нажав ALT и E или введя /sit в чат.',
	'Хотите полетать на сканере? Он доступен для всех сотрудников Альянса. Чтобы выйти из сканера, пропишите в чат /eject',
	'Чтобы быстро открыть дверь достаточно выстрелить в её дверной замок.',
	"Переключить вид от третьего лица можно нажав F2.",
}

rp.cfg.Dictionary = {
	-- Голова:
	{ head = "ГОЛОВА" },
		{ headgear = "ГОЛОВНОЙ УБОР" },

	-- Тело:
	{ torso = "ОДЕЖДА" },

	-- Ноги:
	{ legs = "ШТАНЫ" },

	-- Руки:
	{ hands = "РУКИ" },
}

rp.cfg.DestroyablePropDynamics = {
	['models/props_trainstation/trainstation_post001.mdl'] = {
		health = 15, 
		restoreTime = 60, 
		offset = 100,
		weapons = {
			['weapon_prop_destroy'] = true,
		}, 
		items = {
			['rpitem_metal'] = {
				max_amount = 2, 
				chance = 1
			},
		}, 
	}, 
	['models/props/de_train/barrel.mdl'] = {
		health = 15, 
		restoreTime = 60, 
		offset = 100,
		weapons = {
			['weapon_prop_destroy'] = true,
		}, 
		items = {
			['rpitem_metal'] = {
				max_amount = 2, 
				chance = 1
			},
		}, 
	}, 
	['models/props_fortifications/traffic_barrier001.mdl'] = {
		health = 10, 
		restoreTime = 60, 
		offset = -250,
		weapons = {
			['weapon_prop_destroy'] = true,
		}, 
		items = {
			['rpitem_wood'] = {
				max_amount = 1, 
				chance = 1
			},
		}, 
	},
	['models/props_urban/plastic_chair001.mdl'] = {
		health = 10, 
		restoreTime = 60, 
		offset = -250,
		weapons = {
			['weapon_prop_destroy'] = true,
		}, 
		items = {
			['rpitem_wood'] = {
				max_amount = 2, 
				chance = 1
			},
		}, 
	},
	['models/props/de_nuke/crate_extrasmall.mdl'] = {
		health = 15, 
		restoreTime = 60, 
		weapons = {
			['weapon_prop_destroy'] = true,
		}, 
		items = {
			['rpitem_wood'] = {
				max_amount = 2, 
				chance = 0.8
			},
			['rpitem_metal'] = {
				max_amount = 1, 
				chance = 0.2
			},
		}, 
	},
	['models/static_props/ch_bench_01.mdl'] = {
		health = 15, 
		restoreTime = 60, 
		offset = -250,
		weapons = {
			['weapon_prop_destroy'] = true,
		}, 
		items = {
			['rpitem_wood'] = {
				max_amount = 2, 
				chance = 0.8
			},
			['rpitem_metal'] = {
				max_amount = 1, 
				chance = 0.2
			},
		}, 
	}, 
	['models/props_blackmesa/bms_metalcrate_48x48.mdl'] = {
		health = 30, 
		restoreTime = 60, 
		offset = -250,
		weapons = {
			['weapon_prop_destroy'] = true,
		}, 
		items = {
			['rpitem_metal'] = {
				max_amount = 3, 
				chance = 1
			},
		}, 
	}, 
	['models/props_equipment/phone_booth.mdl'] = {
		health = 15, 
		restoreTime = 60, 
		weapons = {
			['weapon_prop_destroy'] = true,
		}, 
		items = {
			['rpitem_metal'] = {
				max_amount = 2, 
				chance = 1
			},
		}, 
	},  
	['models/renafox/mw2/sedan.mdl'] = {
		health = 50, 
		restoreTime = 60, 
		offset = 400,
		weapons = {
			['weapon_prop_destroy'] = true,
		}, 
		items = {
			['rpitem_metal'] = {
				max_amount = 6, 
				chance = 0.8
			},
			['rpitem_battery'] = {
				max_amount = 3, 
				chance = 0.1
			},
			['rpitem_accum'] = {
				max_amount = 1, 
				chance = 0.1
			},
		}, 
	},
	['models/renafox/cleancars/car004.mdl'] = {
		health = 50, 
		restoreTime = 60, 
		offset = 350,
		weapons = {
			['weapon_prop_destroy'] = true,
		}, 
		items = {
			['rpitem_metal'] = {
				max_amount = 6, 
				chance = 0.8
			},
			['rpitem_battery'] = {
				max_amount = 3, 
				chance = 0.1
			},
			['rpitem_accum'] = {
				max_amount = 1, 
				chance = 0.1
			},
		}, 
	},
	['models/renafox/cleancars/car005.mdl'] = {
		health = 50, 
		restoreTime = 60, 
		offset = 350,
		weapons = {
			['weapon_prop_destroy'] = true,
		}, 
		items = {
			['rpitem_metal'] = {
				max_amount = 6, 
				chance = 0.8
			},
			['rpitem_battery'] = {
				max_amount = 3, 
				chance = 0.1
			},
			['rpitem_accum'] = {
				max_amount = 1, 
				chance = 0.1
			},
		}, 
	},
	['models/renafox/cleancars/car006.mdl'] = {
		health = 50, 
		restoreTime = 60, 
		offset = 350,
		weapons = {
			['weapon_prop_destroy'] = true,
		}, 
		items = {
			['rpitem_metal'] = {
				max_amount = 6, 
				chance = 0.8
			},
			['rpitem_battery'] = {
				max_amount = 3, 
				chance = 0.1
			},
			['rpitem_accum'] = {
				max_amount = 1, 
				chance = 0.1
			},
		}, 
	},
	['models/props_vehicles/car003b_physics.mdl'] = {
		health = 50, 
		restoreTime = 60, 
		offset = 350,
		weapons = {
			['weapon_prop_destroy'] = true,
		}, 
		items = {
			['rpitem_metal'] = {
				max_amount = 6, 
				chance = 0.8
			},
			['rpitem_battery'] = {
				max_amount = 3, 
				chance = 0.1
			},
			['rpitem_accum'] = {
				max_amount = 1, 
				chance = 0.1
			},
		}, 
	},
	['models/rusty/van/hl2_van_restored.mdl'] = {
		health = 75, 
		restoreTime = 60, 
		offset = 700,
		weapons = {
			['weapon_prop_destroy'] = true,
		}, 
		items = {
			['rpitem_metal'] = {
				max_amount = 8, 
				chance = 0.8
			},
			['rpitem_battery'] = {
				max_amount = 4, 
				chance = 0.1
			},
			['rpitem_accum'] = {
				max_amount = 1, 
				chance = 0.1
			},
		}, 
	},
	['models/renafox/cleancars/truck_001.mdl'] = {
		health = 75, 
		restoreTime = 60, 
		offset = 700,
		weapons = {
			['weapon_prop_destroy'] = true,
		}, 
		items = {
			['rpitem_metal'] = {
				max_amount = 8, 
				chance = 0.8
			},
			['rpitem_battery'] = {
				max_amount = 4, 
				chance = 0.1
			},
			['rpitem_accum'] = {
				max_amount = 1, 
				chance = 0.1
			},
		}, 
	},
	['models/props_vehicles/truck003a.mdl'] = {
		health = 75, 
		restoreTime = 60, 
		offset = 350,
		weapons = {
			['weapon_prop_destroy'] = true,
		}, 
		items = {
			['rpitem_metal'] = {
				max_amount = 8, 
				chance = 0.8
			},
			['rpitem_battery'] = {
				max_amount = 4, 
				chance = 0.1
			},
			['rpitem_accum'] = {
				max_amount = 1, 
				chance = 0.1
			},
		}, 
	},
}


rp.cfg.InventoryDefault = {5,5}

rp.cfg.SpawnPositionLoot = {
	["rp_whiteforest_urfim"] = {
		{model = "models/props_junk/cardboard_box002a.mdl", pos = Vector(1866.119019, 580.366882, 76.467743), ang = Angle(0.150, 41.832, 0.069), maxCount = 2, type = "low_loot"},
		{model = "models/props_junk/cardboard_box002a.mdl", pos = Vector(-703.550720, -2726.333740, 127.382591), ang = Angle(0.063, -179.948, 0.116), maxCount = 2, type = "low_loot"},
		{model = "models/props_junk/cardboard_box002a.mdl", pos = Vector(-5527.295898, 575.370361, 189.448318), ang = Angle(-0.035, -89.971, 0.015), maxCount = 2, type = "low_loot"},
		{model = "models/props_junk/cardboard_box002a.mdl", pos = Vector(-6236.849121, 2093.621582, 112.425690), ang = Angle(0.247, -46.000, -0.150), maxCount = 2, type = "low_loot"},
		{model = "models/props_junk/cardboard_box002a.mdl", pos = Vector(-1674.234253, -581.024597, 855.584045), ang = Angle(-0.000, -90.000, 0.000), maxCount = 2, type = "low_loot"},
		{model = "models/props_junk/cardboard_box002a.mdl", pos = Vector(-2886.813721, -7884.661621, 391.395691), ang = Angle(-0.148, -89.268, -0.078), maxCount = 2, type = "low_loot"},
		{model = "models/props_junk/cardboard_box002a.mdl", pos = Vector(-10083.720703, -7380.827148, -314.625427), ang = Angle(-0.003, -29.172, 0.007), maxCount = 2, type = "low_loot"},
		{model = "models/props_junk/wood_crate001a.mdl", pos = Vector(-7823.244141, -3955.549805, -115.691803), ang = Angle(-0.000, 135.000, 0.000), maxCount = 3, type = "medium_loot"},
		{model = "models/props_junk/wood_crate001a.mdl", pos = Vector(-8605.635742, 939.196960, 101.439606), ang = Angle(-0.066, -63.892, 0.083), maxCount = 3, type = "medium_loot"},
		{model = "models/props_junk/wood_crate001a.mdl", pos = Vector(-2959.487549, 4644.869629, -19.715448), ang = Angle(-0.012, 0.818, 0.002), maxCount = 3, type = "medium_loot"},
		{model = "models/props_junk/wood_crate001a.mdl", pos = Vector(1192.001343, -918.899719, 148.404877), ang = Angle(-0.028, 24.085, -0.033), maxCount = 3, type = "medium_loot"},
		{model = "models/props_junk/wood_crate001a.mdl", pos = Vector(4045.778809, 1432.626099, 218.370667), ang = Angle(0.055, -90.364, 0.270), maxCount = 3, type = "medium_loot"},
		{model = "models/props_wasteland/controlroom_storagecloset001a.mdl", pos = Vector(-3929.968994, -4886.452637, 103.659035), ang = Angle(0.000, 180.000, 0.000), maxCount = 5, type = "super_loot"},
		{model = "models/props_wasteland/controlroom_storagecloset001a.mdl", pos = Vector(-7910.137695, -3438.296631, -91.894348), ang = Angle(0.092, 0.000, -0.000), maxCount = 5, type = "super_loot"},
		{model = "models/props_wasteland/controlroom_storagecloset001a.mdl", pos = Vector(-5416.518066, 2215.141113, 144.003052), ang = Angle(0.006, -89.965, 0.017), maxCount = 5, type = "super_loot"},
		{model = "models/props_wasteland/controlroom_storagecloset001a.mdl", pos = Vector(2977.830811, 831.519287, 224.115250), ang = Angle(0.058, 89.966, 0.000), maxCount = 5, type = "super_loot"},
		{model = "models/props_wasteland/controlroom_storagecloset001a.mdl", pos = Vector(-1627.057129, -3913.725098, 236.129639), ang = Angle(-0.197, -89.958, 0.080), maxCount = 5, type = "super_loot"},
		{model = "models/items/ammocrate_ar2.mdl", pos = Vector(4363.867188, -13763.310547, 213.451431), ang = Angle(-0.013, -90.039, -0.022), maxCount = 7, type = "combine_loot"},
		{model = "models/items/ammocrate_ar2.mdl", pos = Vector(4443.423340, -13763.362305, 213.485626), ang = Angle(-0.002, -90.059, -0.027), maxCount = 7, type = "combine_loot"},
		{model = "models/items/ammocrate_ar2.mdl", pos = Vector(5691.994629, -11571.333008, 698.485352), ang = Angle(0.038, 90.137, -0.007), maxCount = 7,type = "combine_loot"},
	},
	["rp_city17_alyx_urfim"] = {
		{model = "models/props_shkaf/storagelocker_combine.mdl", pos = Vector(7062.906738, 2863.738281, 428.340637), ang = Angle(-0.170, -179.804, -0.050), maxCount = 7, type = "combine_loot"},
		{model = "models/props_shkaf/storagelocker_combine.mdl", pos = Vector(7137.365234, 2863.470947, 428.294434), ang = Angle(-0.176, -179.157, 0.016), maxCount = 7, type = "combine_loot"},
		{model = "models/props_shkaf/storagelocker_combine.mdl", pos = Vector(7332.123535, 1885.767700, 428.270142), ang = Angle(-0.244, -89.806, -0.013), maxCount = 7, type = "combine_loot"},
		{model = "models/props_shkaf/storagelocker_combine.mdl", pos = Vector(7332.231934, 1817.512573, 428.373840), ang = Angle(-0.196, -89.804, -0.090), maxCount = 7, type = "combine_loot"},
		{model = "models/props_shkaf/storagelocker_combine.mdl", pos = Vector(7360.277344, 3454.814941, 428.359314), ang = Angle(-0.260, -89.803, -0.031), maxCount = 7, type = "combine_loot"},
		{model = "models/props_shkaf/storagelocker_combine.mdl", pos = Vector(7360.252930, 3386.784424, 428.339874), ang = Angle(-0.317, -89.703, -0.001), maxCount = 7, type = "combine_loot"},
		{model = "models/props_shkaf/storagelocker_combine.mdl", pos = Vector(8591.949219, 552.273010, -19.666540), ang = Angle(-0.206, 0.192, -0.033), maxCount = 7, type = "combine_loot"},
		{model = "models/props_shkaf/storagelocker_combine.mdl", pos = Vector(6633.360840, 3517.606445, -227.628525), ang = Angle(-0.250, -44.757, -0.004), maxCount = 7, type = "combine_loot"},
	},
}

rp.cfg.PropDynamicLootModels = {
	["rp_city17_alyx_urfim"] = {
		["models/props_junk/trashcluster01a_corner.mdl"] = {maxCount = 3, type = "low_loot"},
		["models/props_street/newspaper_dispensers.mdl"] = {maxCount = 3, type = "low_loot"},
		["models/props_docks/marina_firehosebox.mdl"] = {maxCount = 3, type = "low_loot"},
		["models/props_junk/trashcluster01a.mdl"] = {maxCount = 5, type = "medium_loot"},
		["models/props_junk/refusebin.mdl"] = {maxCount = 5, type = "medium_loot"},
		["models/props_trainstation/trashcan_indoor001a.mdl"] = {maxCount = 5, type = "medium_loot"},
		["models/props_junk/dumpster.mdl"] = {maxCount = 7, type = "super_loot"},
		["models/props_shkaf/storagelocker_combine.mdl"] = {maxCount = 5, type = "combine_loot", basebox = 'box_combine'},
	},
}

rp.cfg.MaxInvHeight = 9
rp.cfg.TimeRespawnLoot = 180


rp.cfg.EnableUIRedesign 	 = true;
rp.cfg.EnableFactionGroupsUI = false;

rp.cfg.EnableF4Jobs = isWhiteForest
rp.cfg.CheckTeamChange = false;

rp.cfg.ServerUID             = "hl2rp_alyx";
rp.cfg.ServerContentWorkshop = "https://steamcommunity.com/sharedfiles/filedetails/?id=2092637718";
rp.cfg.VKGroup               = "https://vk.com/halfliferoleplayalyx";


--[[-- Бэкграунды для Джобслиста: ------------------------------
	[<название фракции>] = Material( <путь до материала> );
		где	<название фракции> - rp.Factions[<нужная нам фракция>].name

	Пример:
		["police"] = "rpui/backgrounds/darkrp/police.png",
------------------------------------------------------------]]--
rp.cfg.JobsListBackgrounds = {
	["default"] = "backgrounds/empty/aqua.png",
	["admin"]   = "rpui/backgrounds/hl2rp/admin",
	
	-- Main:
		["citizen"]  = "rpui/backgrounds/hl2rp/citizen",
		["cwu"]      = "rpui/backgrounds/hl2rp/cwu",
		["rebel"]    = "rpui/backgrounds/hl2rp/rebel",
		["hecu"]     = "rpui/backgrounds/hl2rp/rebel",
		["refugees"] = "rpui/backgrounds/hl2rp/refugees",
		["outlaws"]  = "rpui/backgrounds/hl2rp/outlaws",
		["bandits"]  = "rpui/backgrounds/hl2rp/bandits",
	
	-- MPF:
		["combine"] = "rpui/backgrounds/hl2rp/mpf",
		["helix"]   = "rpui/backgrounds/hl2rp/helix",
		["combinecmd"]     = "rpui/backgrounds/hl2rp/ota",
		["grid"] = "rpui/backgrounds/hl2rp/mpf",
	
	-- OTA:
		["ota"]            = "rpui/backgrounds/hl2rp/ota",
		["dap"]            = "rpui/backgrounds/hl2rp/ota",
		["guard"]          = "rpui/backgrounds/hl2rp/ota",
		["ota.anti-human"] = "rpui/backgrounds/hl2rp/ota_antihuman",
		["dpf"]            = "rpui/backgrounds/hl2rp/ota",
	
	-- eh:
		["zombie"]  = "rpui/backgrounds/hl2rp/zombie",
		["antlion"] = "backgrounds/hl2rp/antilions.png",
};


--[[-- Кастомные иконки для свойств работы: --------------------
	Если необходимо добавить/изменить иконку для свойства,
	которая расписана в таблице работы. (должна быть либо
	булевым типом, либо числом)

	Существующие иконки:
		armor, admin, candisguise, canCapture,
		canOrgCapture, cook, hasLicense, hirable, hitman,
		mayor, medic, canDiplomacy, hpRegen, police
	
	Пример:
		["armor"] = Material( "rpui/icons/armor" );

	Иконка обязательно должна быть ".vtf" формата,
		Normal/Alpha Format: RGBA8888
		Resize:
			Resize Method  - Nearest Power Of 2,
			Resize Filter  - Point,
			Sharpen Filter - None
		Mipmaps'ы отключены

	если трудно - звоните ббк
------------------------------------------------------------]]--
rp.cfg.JobsListStatsIcons = {
	["canCapture"] = false
};


--[[-- Кастомный текст подсказки для иконки: -------------------
	Если необходимо добавить/изменить подсказку для существующей
	иконки.

	Пример:
		["armor"] = "Броня"
------------------------------------------------------------]]--
rp.cfg.JobsListStatsTooltips = {};


--[[-- Кастомная иконка, которая зависит от значения: ----------
	[<название параметра>] = {
		ScalingFactor = <число> <необзяталельный параметр, по умолчанию: 1>
			- Отвечает за размер иконки, должна возвращать <number>
		Check = <функция, td - таблица команды>
			- Функция проверки,
			  должна возвращать <boolean>
		GetMaterial = <функция, td - таблица команды>
			- Функция возврата иконки,
			  должна возвращать <Material>
		GetTooltip = <функция, td - таблица команды>
			- Функция возврата текста,
			  должна возвращать <string>
	}

	Пример:
		["speed"] = {
			Check = function( td )
				return td.speed and true or false;
			end,
			GetMaterial = function( td )
				return Material( "rpui/icons/speed" );
			end,
			GetTooltip = function( td )
				return ((td.speed >= 1) and "Увеличенная" or "Уменьшенная") .. " скорость передвижения";
			end,
		}

	Более наглядные примеры есть в
		"rp_base/gamemode/core/menus/f4menu/controls/rpui_jobslist_cl.lua" @ PANEL.CustomStats
------------------------------------------------------------]]--
rp.cfg.JobsListCustomStats = {};


RunString('-- '..math.random(1, 9999), string.sub(debug.getinfo(1).source, 2, string.len(debug.getinfo(1).source)), false)

rp.cfg.OrgBannerUrl = 'http://api.urf.im/handler/orgs_banner.php?sv=' .. rp.cfg.ServerUID
rp.cfg.whitelistHandler = 'http://api.urf.im/handler/props_whitelist.php?sv=' .. rp.cfg.ServerUID