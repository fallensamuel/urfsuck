local lockdownAction = {}

lockdownAction['rp_city17_build210'] = {
	enable = function(id)
		if id == 2 then
			ents.FindByName('logic_relay_auto_enable')[1]:Fire('Trigger')
		elseif id == 3 then
			ents.FindByName('logic_relay_judge_enable')[1]:Fire('Trigger')
		else
			table.foreach(player.GetAll(), function(k, v)
				v:ConCommand("play "..rp.cfg.Lockdowns[id].sound.."\n")
			end)
		end
	end,
	disable = function(id)
		if id == 2 then
			ents.FindByName('logic_relay_auto_disable')[1]:Fire('Trigger')
		elseif id == 3 then
			ents.FindByName('logic_relay_judge_disable')[1]:Fire('Trigger')
		end
	end,
}

lockdownAction['rp_industrial17_v1'] = {
	enable = function(id)
		if id == 2 then
			ents.FindByName('nexus_lockdownactivate')[1]:Fire('Use')
		elseif id == 3 then
			ents.FindByName('nexus_judactivate')[1]:Fire('Use')
		else
			table.foreach(player.GetAll(), function(k, v)
				v:ConCommand("play "..rp.cfg.Lockdowns[id].sound.."\n")
			end)
		end
	end,
	disable = function(id)
		if id == 2 then
			ents.FindByName('nexus_lockdowndeactivate')[1]:Fire('Use')
		elseif id == 3 then
			ents.FindByName('nexus_judeactivate')[1]:Fire('Use')
		end
	end,
}

lockdownAction['rp_c18_divrp'] = {
	enable = function(id)
		table.foreach(player.GetAll(), function(k, v)
			v:ConCommand("play "..rp.cfg.Lockdowns[id].sound.."\n")
		end)
	end,
	disable = function(id)
	end,
}

lockdownAction['rp_city8_urfim'] = {
	enable = function(id)
		if id == 3 or id == 2 then
			ents.FindByName('jwtimer')[1]:Fire('Enable')
		end
	end,
	disable = function(id)
		if id == 3 or id == 2 then
			ents.FindByName('jwtimer')[1]:Fire('Enable')
		end
	end,
}


lockdownAction['rp_city17_urfim'] = {
	enable = function(id)
		--if id == 2 then
			--ents.FindByName('logic_relay_auto_enable')[1]:Fire('Trigger')
		--elseif id == 3 then
			--ents.FindByName('logic_relay_judge_enable')[1]:Fire('Trigger')
		--else
			table.foreach(player.GetAll(), function(k, v)
				v:ConCommand("play "..rp.cfg.Lockdowns[id].sound.."\n")
			end)
			
			if rp.cfg.Lockdowns[id].next_sound then
				timer.Create('LockdownControlSound', rp.cfg.Lockdowns[id].length, 1, function()
					table.foreach(player.GetAll(), function(k, v)
						--v:ConCommand("play ambient/alarms/combine_bank_alarm_loop4.wav\n")
						v:ConCommand("play "..rp.cfg.Lockdowns[id].next_sound.."\n")
					end)
				end)
			end
		--end
	end,
	disable = function(id)
		--if id == 2 then
			--ents.FindByName('logic_relay_auto_disable')[1]:Fire('Trigger')
		--elseif id == 3 then
			--ents.FindByName('logic_relay_judge_disable')[1]:Fire('Trigger')
		--end
		timer.Remove('LockdownControlSound')
		
		table.foreach(player.GetAll(), function(k, v)
			v:ConCommand("stopsound\n")
		end)
	end,
}

lockdownAction['rp_city17_alyx_urfim'] = {
	enable = function(id)
		--if id == 2 then
			--ents.FindByName('logic_relay_auto_enable')[1]:Fire('Trigger')
		--elseif id == 3 then
			--ents.FindByName('logic_relay_judge_enable')[1]:Fire('Trigger')
		--else
			table.foreach(player.GetAll(), function(k, v)
				v:ConCommand("play "..rp.cfg.Lockdowns[id].sound.."\n")
			end)
			
			if rp.cfg.Lockdowns[id].next_sound then
				timer.Create('LockdownControlSound', rp.cfg.Lockdowns[id].length, 1, function()
					table.foreach(player.GetAll(), function(k, v)
						--v:ConCommand("play ambient/alarms/combine_bank_alarm_loop4.wav\n")
						v:ConCommand("play "..rp.cfg.Lockdowns[id].next_sound.."\n")
					end)
				end)
			end
		--end
	end,
	disable = function(id)
		--if id == 2 then
			--ents.FindByName('logic_relay_auto_disable')[1]:Fire('Trigger')
		--elseif id == 3 then
			--ents.FindByName('logic_relay_judge_disable')[1]:Fire('Trigger')
		--end
		timer.Remove('LockdownControlSound')
		
		table.foreach(player.GetAll(), function(k, v)
			v:ConCommand("stopsound\n")
		end)
	end,
}

lockdownAction['rp_mk_city17_urfim'] = {
	enable = function(id)
		if id == 2 then
			ents.FindByName('logic_relay_auto_enable')[1]:Fire('Trigger')
		elseif id == 3 then
			ents.FindByName('logic_relay_judge_enable')[1]:Fire('Trigger')
		else
			table.foreach(player.GetAll(), function(k, v)
				v:ConCommand("play "..rp.cfg.Lockdowns[id].sound.."\n")
			end)
		end
	end,
	disable = function(id)
		if id == 2 then
			ents.FindByName('logic_relay_auto_disable')[1]:Fire('Trigger')
		elseif id == 3 then
			ents.FindByName('logic_relay_judge_disable')[1]:Fire('Trigger')
		end
	end,
}

lockdownAction = lockdownAction[game.GetMap()]

if lockdownAction then
	hook.Add('LockdownStarted', function(ply, id)
		lockdownAction.enable(id)
	end)

	hook.Add('LockdownEnded', function(ply, id)
		lockdownAction.disable(id)
	end)
end

local remove = {
	rp_city17_build210 = {
		[5643] = true, -- rocket button
		[5712] = true,

		[3224] = true, -- spawn combines button
		[3225] = true,

		[1920] = true, -- shitty rocket
		[1919] = true,
		[1918] = true,

		--[4072] = true, -- shield
		--[4099] = true,
		--[4071] = true,

		[3634] = true, -- spawn shit 

		[3136] = true,
		[3137] = true,

		[2061] = true, -- lockdown button 
		[2062] = true,

		[2066] = true, -- judg button mdl
		[2067] = true,
	},
	rp_c18_divrp = {
		[2253] = true, -- jail doors
		[2254] = true,
	},
	rp_industrial17_v1 = {
		[5501] = true,
		[5502] = true,
		[3234] = true,
		[3271] = true,
		[3031] = true,
		[2454] = true,
		[2455] = true,
		[3742] = true,
		[2223] = true,
		[2263] = true,
		[2264] = true,
		[4290] = true,
		[4289] = true,
		[4392] = true,
		[4720] = true,
		[4721] = true,
		[2584] = true,
		[2583] = true,
		[2685] = true,
		[2686] = true,
		[4426] = true,
		[4424] = true,
		[4425] = true,
		[4394] = true,
		[4821] = true,
		[4879] = true,
		[4413] = true,
		[4414] = true,
		[2925] = true,
		[3731] = true,
		[2062] = true,
		[2063] = true,
		[6531] = true,
		[6532] = true,
		[3543] = true,
		[2372] = true,
		[5398] = true,
		[5397] = true,
		[5396] = true,
		[5400] = true,
		[5401] = true,
		[5399] = true,
		[5712] = true, -- point circle 1
		[1380] = true,
		[1375] = true,
		[1385] = true,
		[1332] = true,
		[1331] = true,
		[1330] = true,
		[1329] = true,
		[1333] = true,
		[4463] = true,
		[4466] = true,
		[4469] = true,
		[4465] = true,
		[4464] = true,
		[4457] = true,
		[4459] = true,
		[4455] = true,
		[4454] = true,
		[4456] = true,
		[4453] = true,
		[4456] = true,
		[1373] = true,
		[1374] = true,
		[5967] = true,
		[5968] = true,
		[2318] = true,
		[2317] = true,
		[2316] = true,
		[1772] = true,
		[2458] = true,
		[3568] = true, 
		[5340] = true,
		[2373] = true,
		[2375] = true,
		[2377] = true,
		[2374] = true,
		[4111] = true,
		[4112] = true,
		[5589] = true,
		[1447] = true,
		[1439] = true,
		[1458] = true,
		[1457] = true,
		[1455] = true,
		[6509] = true,
		[6510] = true,
		[3541] = true,
		[3549] = true,
		[3549] = true,
		[3540] = true,
		[3500] = true,
		[3004] = true,
		[3003] = true,
		[1776] = true,
		[1776] = true,
		[5674] = true,
		[5674] = true,
		[4712] = true,
		[1539] = true,
		[1683] = true,
		[5673] = true,
		[3732] = true,
		[3124] = true,
		[1456] = true,
		[1445] = true,
		[1441] = true,
		[5205] = true,
		[3499] = true,
		[3507] = true,
		[3542] = true,
		[4892] = true,
		[4832] = true,
		[4833] = true,
		[2907] = true,
		[2906] = true,
		[2905] = true,
		[4458] = true,
		[5951] = true,
		[5952] = true,
		[4614] = true,
		[4812] = true,
		[1717] = true,
		[6309] = true,
		[6310] = true,
		[6304] = true,
		[2368] = true,
		[5938] = true,
		[5937] = true,
		[6276] = true,
		[5936] = true,
		[2262] = true,
		[2308] = true,
		[2307] = true,
		[2309] = true,
		[2310] = true,
		[2651] = true,
		[4846] = true,
		[4958] = true,
		[4959] = true,
		[4961] = true,
		[4960] = true,
		[2067] = true,
		[2068] = true,
		[3914] = true,
		[2069] = true,
		[2070] = true,
		[5543] = true,
		[5500] = true,
		[5564] = true,
		[5565] = true,
		[2093] = true,
		[3915] = true,
		[3916] = true,
		[3529] = true,
		[6504] = true,
		[3531] = true,
		[6537] = true,
		[6523] = true,
		[6507] = true,
		[6506] = true,
		[4395] = true,
		[4393] = true,
		[1785] = true,
		[2513] = true,
		[2513] = true,

	},
	rp_city8_urfim = {
		[2561] = true,
		[2562] = true
	},
	rp_city17_urfim = {
		[1821] = true,
		[1822] = true,
		[1826] = true,
		--[3061] = true,
		[1827] = true,
	}
}

remove = remove[game.GetMap()]

hook.Add("InitPostEntity", function()
	if !remove then return end
	for k, v in pairs(ents.GetAll()) do
		if remove[v:MapCreationID()] then
			v:Remove()
		end
	end

	if game.GetMap() == "rp_c18_divrp" then
		local doors = {}
		for k, v in pairs(ents.GetAll()) do
			if v:MapCreationID() == 2153 or v:MapCreationID() == 2146 then
				table.insert(doors, v)
			end
		end
		timer.Create('fuck_doors', 60, 0, function()
			for k, v in pairs(doors) do
				v:Fire('close', '')
				v:Fire('setanimation', 'close')
			end
		end)
	elseif isIndsutrial then
		for k, v in pairs(ents.GetAll()) do
			if v:MapCreationID() == 1969 then
				v:SetKeyValue('speed', 100)
			elseif v:MapCreationID() == 6288 then
				v:Fire('Use')
			end
		end
		timer.Create('fuck_tv', 1, 0, function()
			for k, v in pairs({'nexus_lockdownactivate','nexus_judactivate','nexus_lockdowndeactivate','nexus_judeactivate'}) do
				local list = ents.FindByName(v)
				if list && IsValid(list[1]) then
					ents.FindByName(v)[1]:SetPos(Vector(2896, 3247, 3752))
				end
			end
		end)
	end

	if game.GetMap() == 'rp_industrial17_v1' then
	end

	remove = nil
end)