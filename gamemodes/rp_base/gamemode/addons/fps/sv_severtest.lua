--sv_perftest props/bots количество время_в_секундах

local now, tickrate, tickcount, min, max, floor = SysTime, FrameTime, engine.TickCount(), math.min, math.max, math.floor
local cmds = {}
local bots, props = {}, {}
local mean, mincap, maxcap, start, last, shouldstop

local function perfclc()
	local t = now()
	local delta = t - last
	last = t
	mean = (delta + mean) / 2
	mincap = min(mincap, delta)
	maxcap = max(maxcap, delta)
	if t > shouldstop then
		cmds.stop()
	end
	--MsgN(1 / delta)
end

local function perfteststart()
	mean = tickrate()
	mincap = 0xFFFFFF
	maxcap = 0
	last = now()
	timer.Create('PerformanceTest', 0., 0, perfclc)
end

function cmds.stop()
	if not start then return end
	local tick = tickrate()
	local rate = 1 / tick
	local meanticks = 1 / mean
	local lost = mean - tick

	for k, b in pairs(bots) do 
		b:Kick('Test stopped')
		bots[k] = nil
	end

	for k, e in pairs(props) do 
		e:Remove()
		props[k] = nil
	end

	timer.Remove('PerformanceTest')

	MsgN('Необходимо тиков в секунду ', rate)
	MsgN('Среднее количество тиков в секунду ', meanticks)
	MsgN('Среедняя задержка ', floor(lost * 1000), 'мс')
	MsgN('Минимальная задержка ', floor(mincap * 1000), 'мс')
	MsgN('Максимальная задержка ', floor(maxcap * 1000), 'мс')
	MsgN('Общая производительность ', floor(meanticks / rate * 100), '%')

	mean = nil
	mincap = nil
	maxcap = nil
	start = nil
end

function cmds.bots(n, s)
	if start then return end
	local last = now()
	local c = 0
	for i = 1, n do
		local b = player.CreateNextBot('Bot')
		if not IsValid(b) then break end
		c = c + 1
		b:Lock()
		bots[#bots + 1] = b
	end

	MsgN('Создано ', c, ' ботов за ', floor(1000 * (now() - last)), 'мс')
	shouldstop = last + s
	start = true
	perfteststart()
end

function cmds.props(n, s)
	if start then return end
	local last = now()
	local c = 0
	for i = 1, n do
		local e = ents.Create('prop_physics')
		if not IsValid(e) then break end
		c = c + 1
		e:SetModel('models/props_wasteland/kitchen_shelf001a.mdl')
		e:Spawn()
		e:DropToFloor()
		props[#props + 1] = e
	end

	MsgN('Создано ', c, ' пропов за ', floor(1000 * (now() - last)), 'мс')
	shouldstop = last + s
	start = true
	perfteststart()
end

concommand.Add('sv_perftest', function(pl, cmd, args, str)
	if IsValid(pl) && !pl:IsRoot() then return end
	local cmd = args[1]
	local n = args[2] and tonumber(args[2]) or 0
	local s = args[3] and tonumber(args[3]) or 60

	local f = cmds[cmd]
	if f and n then f(n, s) end
end)