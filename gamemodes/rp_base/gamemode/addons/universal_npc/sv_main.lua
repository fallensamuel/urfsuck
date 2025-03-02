local function SpawnUniversalNPCs()
    for index, data in pairs(rp.UniversalNPCs) do
        if IsValid(data.ent) then
            data.ent:Remove()
            data.ent = nil
        end

        local npc = ents.Create("universal_npc")
        npc:SetPos(data.Pos)
        npc:SetAngles(data.Angles)
        npc:Spawn()

        npc:SetUniversalIndex(index)
        npc:SetModel(data.Model)
        
        if data.Skin then
            npc:SetSkin(data.Skin)
        end
        
        if data.Bodygroups then
            for k, v in pairs(data.Bodygroups) do
                npc:SetBodygroup(k, v)
            end
        end

        timer.Simple(0, function()
            npc:PhysicsInit(SOLID_VPHYSICS)
            npc:SetMoveType(MOVETYPE_NONE)
            npc:SetSolid(SOLID_BBOX)
    
            npc.AnimationSequence = data.Sequence--self:LookupSequence(data.Sequence)
            if npc.AnimationSequence then
                npc:SetSequence(npc.AnimationSequence)
                npc.Think = function(self)
                    self:SetSequence(self.AnimationSequence)
                end
            end
        end)

        data.ent = npc
        print("[UniversalNPC's]", index, "has been spawned!")
    end
end

concommand.Add("respawn_universalnpcs", function(ply)
    if IsValid(ply) and not ply:IsRoot() then return end

    SpawnUniversalNPCs()
end)

hook.Add("InitPostEntity", "SpawnUniversalNPCs", SpawnUniversalNPCs)