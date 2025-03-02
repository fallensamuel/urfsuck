/*
local read = file.Read
local open = file.Open

function file.Read(name, path)
	if path == nil or path == "DATA" then 
		return read(name, path)
	else
		return ""
	end
end

function file.Open(name, mode, path)
	if path == nil or path == "DATA" then 
		return open(name, mode, path)
	else
		return ""
	end
end
*/