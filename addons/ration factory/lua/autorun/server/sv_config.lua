

hook.Add("InitPostEntity", function()
    if !rp.cfg.RationFactory[game.GetMap()] then return end

    local box = rp.cfg.RationFactory[game.GetMap()].FactoryZone
    OrderVectors(box[1], box[2])

    for k, v in ipairs(rp.cfg.RationFactory[game.GetMap()].boxes) do
        local ent = ents.Create("eml_box")
        ent:SetPos(v[1])
        ent:SetAngles(v[2])
        ent:Spawn()
        ent.posbox = v
        ent:Activate()
    end

    for k, v in ipairs(rp.cfg.RationFactory[game.GetMap()].spawners) do
        local ent = ents.Create("eml_button")
        ent:SetPos(v.buttonVec)
        ent:SetAngles(v.buttonAng)
        ent:Spawn()
        ent.poscomp1 = v.spawner_1
        ent.poscomp2 = v.spawner_2
        ent:Activate()
        ent:GetPhysicsObject():EnableMotion(false)
    end
end)