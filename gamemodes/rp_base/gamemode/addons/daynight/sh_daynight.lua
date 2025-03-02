nw.Register'IsDay':Write(net.WriteBool):Read(net.ReadBool):SetGlobal():SetHook("DayNightChanged")

if SERVER then
	nw.SetGlobal('IsDay', true)
end

function rp.IsDay()
	return nw.GetGlobal('IsDay')
end