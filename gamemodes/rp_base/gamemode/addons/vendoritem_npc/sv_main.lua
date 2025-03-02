function rp.RespawnItemVendor(index, data)
    if IsValid(data.ent) then
        data.ent:Remove()
        data.ent = nil
    end

    local npc = ents.Create("vendoritem_npc")
    npc:SetPos(data.Pos)
    npc:SetAngles(data.Angles)
    npc:Spawn()

    npc:SetVendorIndex(index)
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
    print("[ItemVendorNPC's]", index, "has been spawned!")
end

local function SpawnItemVendorNPC()
    for index, data in pairs(rp.VendorItemsNPCS) do
        rp.RespawnItemVendor(index, data)
    end
end

concommand.Add("respawn_itemvendors", function(ply)
    if IsValid(ply) and not ply:IsRoot() then return end

    for i, ent in pairs( ents.FindByClass("vendoritem_npc") ) do
        ent:Remove()
    end

    SpawnItemVendorNPC()
end)

concommand.Add("tp2itemvendor", function(ply, cmd, args)
    if not IsValid(ply) or not ply:IsRoot() then return end
    
    local vendor = rp.VendorItemsNPCS[args[1] or 1]
    if not vendor then rp.Notify(ply, NOTIFY_RED, rp.Term('Vendor_invind')) return end
    
    ply:SetPos(vendor.ent:GetPos())
    rp.Notify(ply, NOTIFY_GREEN, rp.Term('Vendor_tele'), ent:GetVendorName())
end)

hook.Add("InitPostEntity", "SpawnItemVendorNPC", function()
    rp.AlreadyInitPostEntity = true
    SpawnItemVendorNPC()
end)