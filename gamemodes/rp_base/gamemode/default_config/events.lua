-- "gamemodes\\rp_base\\gamemode\\default_config\\events.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
-- Printer
rp.RegisterEvent('Printer', {
	NiceName = 'Printer',
	Hooks = {
		['calcPrintAmount'] = function(amt) return (amt * 2) end
	}
})

-- vape wave
rp.RegisterEvent('SmokingPipes', {
	NiceName = 'Крутильные Трубки',
	Hooks = {
		['PlayerLoadout'] = function(pl)
			pl:Give('weapon_vape')
		end
	},
	OnStart = function()
		for k, v in ipairs(player.GetAll()) do
			v:Give('weapon_vape')
		end
	end
})

rp.RegisterEvent('VapeWave', {
	NiceName = 'Vape Wave',
	Hooks = {
		['PlayerLoadout'] = function(pl)
			pl:Give('weapon_vape')
		end
	},
	OnStart = function()
		for k, v in ipairs(player.GetAll()) do
			v:Give('weapon_vape')
		end
	end
})

-- vape wave
rp.RegisterEvent('SpinnerEvent', {
	NiceName = 'Spinner Event',
	Hooks = {
		['PlayerLoadout'] = function(pl)
			pl:Give('fidgetspinner_new')
		end
	},
	OnStart = function()
		for k, v in ipairs(player.GetAll()) do
			v:Give('fidgetspinner_new')
		end
	end
})

-- guitar event
rp.RegisterEvent('GuitarTime', {
	NiceName = 'Guitar Time',
	Hooks = {
		['PlayerLoadout'] = function(pl)
			pl:Give('guitar_sw')
		end
	},
	OnStart = function()
		for k, v in ipairs(player.GetAll()) do
			v:Give('guitar_sw')
		end
	end
})

-- VIP
rp.RegisterEvent('VIP', {
	NiceName = 'VIP',
	Hooks = {
		['PlayerVIPCheck'] = function(pl) return true end
	}
})

-- Salary
rp.RegisterEvent('Salary', {
	NiceName = 'Salary',
	Hooks = {
		['PlayerPayDay'] = function(pl, salary) return (salary * 2) end
	}
})

-- Double time
rp.RegisterEvent('DoubleTime', {
	NiceName = 'Double Time',
	OnStart = function()
		rp.SetTimeMultiplier('event', 1, rp.EventsRunning['Double Time'].EndTime - CurTime(), 'SetGlobalTimeMultiplayer')
	end,
})

-- Free Runner
rp.RegisterEvent('Parkour', {
	NiceName = 'Parkour',
	Hooks = {
		['PlayerLoadout'] = function(pl)
			pl:Give('climb_swep')
		end
	},
	OnStart = function()
		for k, v in ipairs(player.GetAll()) do
			v:Give('climb_swep')
		end
	end
})

-- Salary
rp.RegisterEvent('TimeBoost', {
	NiceName = 'Time Boost',
	OnEnd = function()
		local events = nw.GetGlobal('EventsRunning') or {}
		events['timeboost'] = true
		nw.SetGlobal('EventsRunning', events)

		for k, v in pairs(player.GetAll()) do
			ba.data.UpdatePlayTime(v)
		end
		
		timer.Simple(5, function()
			RunConsoleCommand('ba', 'reload')
		end)
	end
})

-- BURGATRON
rp.RegisterEvent('BURGATRON', {
	NiceName = 'BURGATRON',
	Hooks = {
		['PlayerHasHunger'] = function(pl)
			if (pl.HungerImmune) then return false end
		end,
		['PlayerLoadout'] = function(pl)
			pl:Give('weapon_hl2bottle')
		end,
		['PlayerDeath'] = function(pl)
			pl.HungerImmune = nil
		end,
		['KeyPress'] = function(pl, key)
			if (key == IN_USE) then
				local tr = pl:GetEyeTrace()

				if (tr.Entity and tr.Entity:IsPlayer() and tr.Entity.IsBurger) then
					tr.Entity:Kill()
					pl.HungerImmune = true
					pl:EmitSound('vo/sandwicheat09.wav', 100, 100)
					pl:Notify(NOTIFY_GREEN, rp.Term('BURGHungerImmune'))
					tr.Entity:Notify(NOTIFY_GREEN, rp.Term('BURGNotPeople'))
				end
			end
		end
	},
	OnStart = function()
		for k, v in ipairs(player.GetAll()) do
			v:Give('weapon_hl2bottle')
		end
	end,
	OnEnd = function()
		for k, v in ipairs(player.GetAll()) do
			if (v:GetActiveWeapon():IsValid() and v:GetActiveWeapon():GetClass() == 'weapon_hl2bottle') then
				v:SelectWeapon('weapon_physgun')
			end

			v.HungerImmune = nil

			if (not v:IsRoot()) then
				v:StripWeapon('weapon_hl2bottle')
			end
		end
	end
})

-- FREE JOBS
local function OnStartFunc(seconds)
	rp.EventSavedJobsPriceYeah = {};

	for Index, Job in pairs(table.GetKeys(rp.teams)) do
		rp.EventSavedJobsPriceYeah[Job] = {
			rp.teams[Job].unlockTime,
			rp.teams[Job].unlockPrice
		};
		rp.teams[Job].unlockTime = 0;
		rp.teams[Job].unlockPrice = nil;
	end
	
	if SERVER then
		ba.svar.Set('job_event', tostring(os.time() + seconds))
	end
end

local function OnEndFunc()
	for Index, Job in pairs(table.GetKeys(rp.EventSavedJobsPriceYeah or {})) do
		rp.teams[Job].unlockTime = rp.EventSavedJobsPriceYeah[Job][1];
		rp.teams[Job].unlockPrice = rp.EventSavedJobsPriceYeah[Job][2];
	end

	rp.EventSavedJobsPriceYeah = nil;
	
	if SERVER then
		ba.svar.Set('job_event', '-1')
	end
end

rp.RegisterEvent('JobsFree', {
	NiceName = 'Бесплатные профессии',
	OnStart = OnStartFunc,
	OnStartClient = OnStartFunc,
	OnEnd = OnEndFunc,
	OnEndClient = OnEndFunc
});

if SERVER then
	timer.Simple(5, function()
		local jobs_event_until = ba.svar.Get('job_event') and tonumber(ba.svar.Get('job_event')) > 0 and tonumber(ba.svar.Get('job_event')) or false
		ba.svar.Create('job_event', nil, false)
		
		if jobs_event_until and jobs_event_until > os.time() then
			rp.StartEvent('jobsfree', jobs_event_until - os.time())
		end
	end)
end

-- Ивент флекса:
rp.RegisterEvent( "DanceEvent", {
	NiceName = "Dance Event"
} );