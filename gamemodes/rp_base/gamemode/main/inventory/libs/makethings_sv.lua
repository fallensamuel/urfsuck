rp.VendorsNPCs_EntsTab = rp.VendorsNPCs_EntsTab or {}

local function SpawnAllVendorNpcs()
    if not rp.VendorsNPCs then return end
    for npcname, npctab in pairs(rp.VendorsNPCs) do
		if not npctab.pos then continue end
		
        local npc = ents.Create("vendor_npc")
		
        npc:SetPos(npctab.pos)
        npc:SetAngles(npctab.ang)
        npc:SetVendorName(npcname)
        npc:Spawn()

        npc:SetModel(npctab.model)
		
		if npctab.skin then
			npc:SetSkin(npctab.skin)
		end
		
		if npctab.bodygroups then
			for k, v in pairs(npctab.bodygroups) do
				npc:SetBodygroup(k, v)
			end
		end
		
        --npc.AnimationSequence = npctab.sequence
		--npc:SetSequence(npc:LookupSequence(npc.AnimationSequence))
		
        timer.Simple(0, function() -- next tick
			npc:PhysicsInit(SOLID_VPHYSICS)
			npc:SetMoveType(MOVETYPE_NONE)
			npc:SetSolid(SOLID_BBOX)
	
        	npc.AnimationSequence = npctab.sequence
        	npc.Think = function(self)
				self:SetSequence(self.AnimationSequence)
			end
        end)
		
        npctab.npc_ent = npc
        table.insert(rp.VendorsNPCs_EntsTab, npc)

        MsgC(Color(40, 149, 220), "[VendorNpc's] ", color_white, npcname.." has been spawned! \n")
    end
end

hook.Add("InitPostEntity", "SpawnVendorNpcs", SpawnAllVendorNpcs)

concommand.Add("respawn_vendor_npcs", function(ply)
    if IsValid(ply) and not ply:IsRoot() then return end

    for _, ent in pairs(rp.VendorsNPCs_EntsTab) do
        if IsValid(ent) then
        	SafeRemoveEntity(ent)
        else
        	ent = nil -- чистка таблицы от невалидного мусора
        end
    end

    timer.Simple(0.1, function() -- Что-бы был виден обратный отклик. Иначе ply может подумать что ничего не произошло
        SpawnAllVendorNpcs()
    end)
end)