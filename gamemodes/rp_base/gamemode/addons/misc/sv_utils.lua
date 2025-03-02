timer.Create("Useful_Console.log_Info", 60, math.huge, function()
	MsgC(Color(40, 149, 220), "[ServerInfo] Time: ", Color(255, 255, 255), os.date("!%R", os.time() + 3*60*60), "(MSK) | Uptime: ", os.date("!%R", CurTime()), " | Online: ", table.Count(player.GetAll()), " | RealFrameTime: ", (engine.RealFrameTime and engine.RealFrameTime() or "???"), "\n")
end)


concommand.Add("trace_entmove", function(ply, cmd, args)
    if not ply:IsRoot() then return end
    local ent = ply:GetEyeTrace().Entity
    if not IsValid(ent) then return end
    ent:SetPos(ent:GetPos() + Vector(tonumber(args[1]), tonumber(args[2]), tonumber(args[3])))
end)