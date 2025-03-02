-- "gamemodes\\rp_base\\gamemode\\addons\\relations\\cl_init.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal

local ACTION_KICK = 1
local ACTION_FIRE = 2
local ACTION_DEMOTE = 2
local ACTION_REWARD = 3
local ACTION_REPRESS = 4

local tr = translates
local cached
if tr then
	cached = {
		tr.Get( 'Управление' ), 
		tr.Get( 'Выдать премию' ), 
		tr.Get( 'За что вы хотите выдать премию?' ), 
		tr.Get( 'Выдать премию в радиусе' ), 
		tr.Get( 'Понизить в должности' ), 
		tr.Get( 'За что вы хотите понизить?' ), 
		tr.Get( 'Выгнать из фракции' ), 
		tr.Get( 'За что вы хотите выгнать?' ), 
		tr.Get( 'Выселить в нежилое пространство' ), 
		tr.Get( 'цель должна быть в наручниках' ), 
		tr.Get( 'За что вы хотите выселить?' ), 
	}
else
	cached = {
		'Управление', 
		'Выдать премию', 
		'За что вы хотите выдать премию?', 
		'Выдать премию в радиусе', 
		'Понизить в должности', 
		'За что вы хотите понизить?', 
		'Выгнать из фракции', 
		'За что вы хотите выгнать?', 
		'Выселить в нежилое пространство', 
		'цель должна быть в наручниках', 
		'За что вы хотите выселить?', 
	}
end

rp.AddContextCommand(cached[1], cached[2], function()
	local relationFilter = LocalPlayer():GetJobTable().relationFilter

	local cps = table.Filter(player.GetAll(), function(v) 
		local r = (relationFilter == nil) and true or relationFilter(v)
		return r && rp.IsHigherRank(LocalPlayer(), v)
	end)

	rpui.PlayerReuqest(cached[2], "rpui/donatemenu/money", 1.5, function(v) --ui.PlayerReuqest(cps, function(v)
		rpui.StringRequest(cached[2], cached[3], "shop/filters/list.png", 1.4, function(self, a) --ui.StringRequest(cached[2], cached[3], '', function(a)
			if IsValid(v) then
				net.Start('rp.Relations.Actions')
					net.WriteUInt(ACTION_REWARD, 3)
					net.WriteEntity(v)
					net.WriteString(a)
				net.SendToServer()
			end
		end)
		
	end, cps)
end, function() return LocalPlayer():GetFactionRank() >= RANK_TRAINER end, 'cmenu/premia')

rp.AddContextCommand(cached[1], cached[4], function()
	rpui.StringRequest(cached[2], cached[3], "shop/filters/list.png", 1.4, function(self, a) --ui.StringRequest(cached[2], cached[3], '', function(a)
		net.Start('rp.Relations.Actions')
			net.WriteUInt(ACTION_REWARD, 3)
			net.WriteEntity(LocalPlayer())
			net.WriteString(a)
		net.SendToServer()
	end)
end, function() return LocalPlayer():GetFactionRank() >= RANK_TRAINER end, 'cmenu/premia')

--rp.AddContextCommand('Управление', 'Уволить', function()
--	local cps = table.Filter(player.GetAll(), function(v) 
--		return rp.IsHigherRank(LocalPlayer(), v)
--	end)
--
--	ui.PlayerReuqest(cps, function(v)
--		ui.StringRequest('Уволить подчиненного', 'За что вы хотите уволить?', '', function(a)
--			if IsValid(v) then
--				net.Start('rp.Relations.Actions')
--					net.WriteUInt(ACTION_FIRE, 3)
--					net.WriteEntity(v)
--					net.WriteString(a)
--				net.SendToServer()
--			end
--		end)
--	end)
--end, function() return LocalPlayer():GetFactionRank() >= RANK_OFFICER end)

rp.AddContextCommand(cached[1], cached[5], function()
	local relationFilter = LocalPlayer():GetJobTable().relationFilter

	local cps = table.Filter(player.GetAll(), function(v) 
		local r = (relationFilter == nil) and true or relationFilter(v)
		return r && rp.IsHigherRank(LocalPlayer(), v)
	end)

	rpui.PlayerReuqest(cached[5], "rpui/donatemenu/money", 1.5, function(v) --ui.PlayerReuqest(cps, function(v)
		rpui.StringRequest(cached[5], cached[6], "shop/filters/list.png", 1.4, function(self, a) --ui.StringRequest(cached[5], cached[6], '', function(a)
			if IsValid(v) then
				net.Start('rp.Relations.Actions')
					net.WriteUInt(ACTION_DEMOTE, 3)
					net.WriteEntity(v)
					net.WriteString(a)
				net.SendToServer()
			end
		end)
	end, cps)
end, function() return LocalPlayer():GetFactionRank() >= RANK_OFFICER end, 'cmenu/promote')

rp.AddContextCommand(cached[1], cached[7], function()
	local relationFilter = LocalPlayer():GetJobTable().relationFilter

	local cps = table.Filter(player.GetAll(), function(v) 
		local r = (relationFilter == nil) and true or relationFilter(v)
		return r && rp.IsHigherRank(LocalPlayer(), v)
	end)

	rpui.PlayerReuqest(cached[7], "rpui/donatemenu/money", 1.5, function(v) --ui.PlayerReuqest(cps, function(v)
		rpui.StringRequest(cached[7], cached[8], "shop/filters/list.png", 1.4, function(self, a) --ui.StringRequest(cached[7], cached[8], '', function(a)
			if IsValid(v) then
				net.Start('rp.Relations.Actions')
					net.WriteUInt(ACTION_KICK, 3)
					net.WriteEntity(v)
					net.WriteString(a)
				net.SendToServer()
			end
		end)
	end, cps)
end, function() return LocalPlayer():GetFactionRank() >= RANK_LEADER end, 'cmenu/demote')

local radius = 2000 ^ 1000
rp.AddContextCommand(cached[1], cached[9], function()
	local relationFilter = LocalPlayer():GetJobTable().relationFilter

	local cps = table.Filter(player.GetAll(), function(v)
		local r = (relationFilter == nil) and true or relationFilter(v)
		return r && rp.CanRepress(LocalPlayer(), v) && v:GetPos():DistToSqr(LocalPlayer():GetPos()) < radius && v:IsHandcuffed()
	end)

	rpui.PlayerReuqest(cached[9], "rpui/donatemenu/money", 1.5, function(v) --ui.PlayerReuqest(cps, function(v)
		rpui.StringRequest(cached[9] .. ' (' .. cached[10] .. ')', cached[11], "shop/filters/list.png", 1.4, function(self, a) --ui.StringRequest(cached[9] .. ' (' .. cached[10] .. ')', cached[11], '', function(a)
			if IsValid(v) then
				net.Start('rp.Relations.Actions')
					net.WriteUInt(ACTION_REPRESS, 3)
					net.WriteEntity(v)
					net.WriteString(a)
				net.SendToServer()
			end
		end)
	end, cps)
end, function() return rp.CanRepress(LocalPlayer()) && !rp.cfg.DisableContextRepress end, 'cmenu/unhouse')
