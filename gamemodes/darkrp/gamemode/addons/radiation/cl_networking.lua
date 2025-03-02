-- "gamemodes\\darkrp\\gamemode\\addons\\radiation\\cl_networking.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
--——————————————————▬— N E T W O R K I N G —▬——————————————————--

local int2key = {
	[1] = "OnZombieInfect",
	[2] = "OnZombieDeInfect"
}
net.Receive("Radiation.JobTable.Callbacks", function()
	local int = net.ReadInt(3)
	local key = int2key[int]
	if key and LocalPlayer():GetJobTable()[key] then
		LocalPlayer():GetJobTable()[key](LocalPlayer())
	end
end)