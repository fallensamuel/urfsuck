local baseclass_Get = baseclass.Get

hook.Add("PlayerSpawnSENT", "AdminOnlyForRoot_ENT", function(ply, Class)
	local baseC = baseclass_Get(Class)
    if (baseC.AdminOnly or baseC.Spawnable == false) and not rp.QObjects[Class] then
        return (ply:IsRoot() or ply:HasFlag("e") or ply:HasFlag("f")) or rp.IsEntSpawnAcceptable(ply, baseC.ClassName) or false
    end
end)

hook.Add("PlayerSpawnSWEP", "AdminOnlyForRoot_SWEP", function(ply, Class)
	local baseC = baseclass_Get(Class)
    if baseC.AdminOnly or baseC.Spawnable == false then
        return (ply:IsRoot() or ply:HasFlag("e") or ply:HasFlag("f")) or rp.IsSwepSpawnAcceptable(ply, baseC.ClassName) or false
    end
end)

hook.Add("PlayerGiveSWEP", "AdminOnlyForRoot_giveSWEP", function(ply, swep, struct)
	if struct.AdminOnly or struct.Spawnable == false then
        return (ply:IsRoot() or ply:HasFlag("e") or ply:HasFlag("f")) or rp.IsSwepSpawnAcceptable(ply, struct.ClassName) or false
    end
end)