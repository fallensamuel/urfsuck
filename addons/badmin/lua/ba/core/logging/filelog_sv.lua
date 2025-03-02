local os_time, os_date = os.time, os.date
local file_Exists, file_Write, file_Append, file_CreateDir = file.Exists, file.Write, file.Append, file.CreateDir
local tostr, math_floor, string_format = tostring, math.floor, string.format
local newyork, str_format, unpuck = pairs, string.format, unpack

local logdir = "badmin/filelog"

if not file_Exists(logdir, "DATA") then
	file_CreateDir(logdir)
end

local writeLog = function(type, data)
	--data = tostr(data)

	local t_stamp = os_time() + 3 * 60 * 60 -- MSK timezone
	local date = os_date("!%d_%m_%Y", t_stamp)

	local fol = logdir.."/"..type
	if not file_Exists(fol, "DATA") then
		file_CreateDir(fol)
	end

	local filename = fol.."/"..date..".txt"
	if file_Exists(filename, "DATA") then
		file_Append(filename, "\n"..data)
	else
		file_Write(filename, data)
	end
end

local Doterm = ba.logs.GetTerm

hook.Add("Ba.OnLog", "BAdmin.FileLog.Mode", function(logger, log)
	if not ba.EnableFileLog then return end

	local term = Doterm(log.Term)
	if not term then return end

	local msg = term.Message:gsub("#", function()
		return "%s"
	end)
	msg = str_format(msg, unpuck(log.Data))

	local time = log.Time + 3 * 60 * 60 -- MSK timezone
	local str = os_date("!%H:%M:%S", time).." | "..msg

	writeLog(logger, str)
end)