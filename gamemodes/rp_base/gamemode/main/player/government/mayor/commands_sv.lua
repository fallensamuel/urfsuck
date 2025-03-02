-- laws
util.AddNetworkString('rp.SendLaws')

rp.AddCommand('/laws', function(pl)
	if not pl:IsMayor() then
		rp.Notify(pl, NOTIFY_ERROR, rp.Term('MustBeMayorSetLaws'))

		return ''
	end

	pl:ConCommand('LawEditor')

	return ''
end)

function rp.resetLaws(pl)
	if (pl ~= nil) and not pl:IsMayor() then
		rp.Notify(pl, NOTIFY_ERROR, rp.Term('MustBeMayorResetLaws'))

		return ''
	end

	nw.SetGlobal('TheLaws', nil)
	hook.Call('mayorResetLaws', GAMEMODE, pl)

	return ''
end

rp.AddCommand('/resetlaws', rp.resetLaws)

net('rp.SendLaws', function(len, pl)
	if not pl:IsMayor() then return end
	local str = net.ReadString()

	if utf8.len(str) >= 26 * 30 then
		pl:ChatPrint(translates.Get('Слишком длинные законы!'))

		return
	end

	hook.Call('mayorSetLaws', GAMEMODE, pl)
	nw.SetGlobal('TheLaws', str)
end)

local LotteryPeople = {}
local LotteryON = false
local LotteryAmount = 0
local CanLottery = CurTime()
local lottoStarter

local function EnterLottery(answer, ent, initiator, target, TimeIsUp)
	if tobool(answer) and not table.HasValue(LotteryPeople, target) then
		if not target:CanAfford(LotteryAmount) then
			rp.Notify(target, NOTIFY_ERROR, rp.Term('CannotAfford'))

			return
		end

		table.insert(LotteryPeople, target)
		target:AddMoney(-LotteryAmount)
		rp.Notify(target, NOTIFY_GREEN, rp.Term('InLottery'), rp.FormatMoney(LotteryAmount))
	elseif answer ~= nil and not table.HasValue(LotteryPeople, target) then
		rp.Notify(target, NOTIFY_GENERIC, rp.Term('NotInLottery'))
	end

	if TimeIsUp then
		LotteryON = false
		CanLottery = CurTime() + 300

		if table.Count(LotteryPeople) == 0 then
			rp.NotifyAll(NOTIFY_GENERIC, rp.Term('NoLotteryAll'))

			return
		end

		if (#LotteryPeople > 1) then
			local chosen = LotteryPeople[math.random(1, #LotteryPeople)]
			local amount = (#LotteryPeople * LotteryAmount)
			local tax = amount * 0.05
			chosen:AddMoney(amount - tax)

			if IsValid(lottoStarter) then
				lottoStarter:AddMoney(tax)
				rp.Notify(lottoStarter, NOTIFY_GREEN, rp.Term('LotteryTax'), rp.FormatMoney(tax))
			end

			rp.NotifyAll(NOTIFY_GREEN, rp.Term('LotteryWinner'), chosen, rp.FormatMoney(amount - tax))
		else
			local ret = LotteryPeople[1]

			if IsValid(ret) then
				ret:AddMoney(LotteryAmount)
				rp.Notify(ret, NOTIFY_ERROR, rp.Term('NoLottery'))
			end

			if IsValid(lottoStarter) then
				rp.Notify(lottoStarter, NOTIFY_ERROR, rp.Term('NoLotteryTax'))
			end
		end
	end
end

local function DoLottery(ply, amount)
	if not ply:IsMayor() then
		rp.Notify(ply, NOTIFY_ERROR, rp.Term('IncorrectJob'))

		return ""
	end

	if #player.GetAll() <= 2 or LotteryON then
		rp.Notify(ply, NOTIFY_ERROR, rp.Term('CannotLottery'))

		return ""
	end

	if CanLottery > CurTime() then
		rp.Notify(ply, NOTIFY_ERROR, rp.Term('LottoCooldown'), math.Round(CanLottery - CurTime()))

		return ""
	end

	amount = tonumber(amount)

	if not amount then
		rp.Notify(ply, NOTIFY_GENERIC, rp.Term('LottoCost'), rp.cfg.MinLotto, rp.cfg.MaxLotto)

		return ""
	end

	lottoStarter = ply
	LotteryAmount = math.Clamp(math.floor(amount), rp.cfg.MinLotto, rp.cfg.MaxLotto)
	hook.Call('lotteryStarted', GAMEMODE, ply)
	rp.NotifyAll(NOTIFY_GENERIC, rp.Term('LotteryStarted'))
	LotteryON = true
	LotteryPeople = {}

	table.foreach(player.GetAll(), function(k, v)
		if v ~= ply then
			GAMEMODE.ques:Create(translates.Get(" Лотерея!\n Купить билет?\n Цена билета: %s.", rp.FormatMoney(LotteryAmount)), "lottery" .. tostring(k), v, 30, EnterLottery, ply, v)
		end
	end)

	timer.Create("Lottery", 30, 1, function()
		EnterLottery(nil, nil, nil, nil, true)
	end)

	return ""
end

rp.AddCommand("/lottery", DoLottery)

local last = 0

function GM:CanLockdown(ply, checkonly)
	if last > CurTime() then
		if not checkonly then
			if IsValid(ply) then
				rp.Notify(ply, NOTIFY_ERROR, rp.Term('CannotLockdown'))
			end
		end
		
		return false
	end
	return true
end

function GM:LockdownStarted(pl, id)
end

function GM:Lockdown(ply, id)
	id = id or 1
	if id > #rp.cfg.Lockdowns || id < 1 then return end
	last = CurTime() + 20
	nw.SetGlobal('lockdown', id)
	--nw.SetGlobal('mayorGrace', nil)
	rp.NotifyAll(NOTIFY_ERROR, rp.Term('LockdownStarted'), rp.cfg.Lockdowns[id].name)
	hook.Call('LockdownStarted', GAMEMODE, ply, id)

	timer.Create('StopLock', 600, 1, function()
		GAMEMODE:UnLockdown()
	end)


	return ""
end

function GM:UnLockdown(ply)
	//if ply then
	//	if last > CurTime() then
	//		rp.Notify(ply, NOTIFY_ERROR, rp.Term('CannotUnlockdown'))
//
	//		return ""
	//	end
	//end

	last = CurTime() + 30

	rp.NotifyAll(NOTIFY_GREEN, rp.Term('LockdownEnded'), rp.cfg.Lockdowns[nw.GetGlobal('lockdown')].name)
	hook.Call('LockdownEnded', GAMEMODE, ply, nw.GetGlobal('lockdown'))
	nw.SetGlobal('lockdown', nil)

	timer.Destroy('StopLock')


	return ""
end

--hook("OnPlayerChangedTeam", "mayorgrace.OnPlayerChangedTeam", function(pl, before, after)
--	if (rp.teams[after].mayor == true) then
--		nw.SetGlobal('mayorGrace', CurTime() + 300)
--	elseif (rp.teams[before].mayor == true) then
--		nw.SetGlobal('mayorGrace', nil)
--	end
--end)

-- Demote classes upon death
--hook("PlayerDeath", "DemoteOnDeath", function(v, k)
--	if (v:Team() == TEAM_MAYOR) then
--		GAMEMODE:UnLockdown(v)
--		nw.SetGlobal('mayorGrace', nil)
--		rp.resetLaws()
--		v:ChangeTeam(1, true)
--		v:TeamBan(TEAM_MAYOR, 180)
--		rp.FlashNotifyAll("Городские Новости", rp.Term('MayorHasDied'))
--	end
--end)