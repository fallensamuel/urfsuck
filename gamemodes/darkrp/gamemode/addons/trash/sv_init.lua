
local max = rp.cfg.MaxQuery
local query = max
function addTrashToQuery()
	query = math.min(query + 1, max)
end

local ent
local function reload()
	local pos = rp.cfg.GabrageSpawnPos[game.GetMap()]
	if !pos then return end
	local garbageModels = rp.cfg.GabrageModels

	timer.Create('SpawnTrash', 3, 0, function()
		if query > 0 then
			query = query - 1
			ent = ents.Create('trash')
			ent:SetModel(table.Random(garbageModels))
			ent:SetPos(pos + Vector(0,0, math.random(-20, 20)))
			ent:Spawn()
		end
	end)
end

hook.Add("InitPostEntity", reload)
hook.Add('OnReloaded', reload)

local npc_bullseye = {["npc_bullseye"] = true}
hook.Add("OnEntityCreated", "BullsEyeCollision", function(ent)
	if IsValid(ent) and npc_bullseye[ent:GetClass()] then
		ent:SetCollisionGroup(COLLISION_GROUP_WORLD)
	end
end)

hook.Add("EntityTakeDamage", "AlyxDoorDestruction", function(ent, dmg)
	if not (IsValid(ent) and ent:IsDoor() and dmg:IsBulletDamage()) then return end

	ent.DoorDestruction = (ent.DoorDestruction or 0) + dmg:GetDamage()
	if ent.DoorDestruction >= (rp.cfg.DoorDestructionHP or 500) then
		ent.DoorDestruction = 0

		ent:Fire("unlock")
        ent:Fire("open")
	end
end)