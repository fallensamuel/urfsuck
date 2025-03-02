-- "gamemodes\\darkrp\\gamemode\\addons\\quest\\sh_entities.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local item_count = 1

rp.Quest.StoredEntitiesMT = {}

base_entity_mt = {}
base_entity_mt.__index = base_entity_mt

function rp.Quest.AddEntityMT()
	local t = {}
	t.__index = t
	setmetatable(t, base_entity_mt)

	t:SetID(item_count)

	rp.Quest.StoredEntitiesMT[item_count] = t

	item_count = item_count + 1


	return t
end

function rp.Quest.GetItem(id)
	return rp.Quest.StoredEntitiesMT[id]
end

function rp.Quest.GetItemTable()
	return quest_entities
end

// BASE QUEST ENTITY

AddMethod(base_entity_mt, 'ID')
AddMethod(base_entity_mt, 'Class', 'base_quest_entity')
AddMethod(base_entity_mt, 'Quest')
AddMethod(base_entity_mt, 'Model')
AddMethod(base_entity_mt, 'Name')
AddMethod(base_entity_mt, 'OnSpawn')
AddMethod(base_entity_mt, 'OnStart')
AddMethod(base_entity_mt, 'OnEnd')
AddMethod(base_entity_mt, 'OnUse')
AddMethod(base_entity_mt, 'End')
AddMethod(base_entity_mt, 'NameOnMap')
AddMethod(base_entity_mt, 'TransmitStart')
AddMethod(base_entity_mt, 'ReadTransmitStart')
AddMethod(base_entity_mt, 'Entity')

function base_entity_mt:SetPos(pos, ang)
	if pos[game.GetMap()] then
		if isvector(pos[game.GetMap()][1]) then
			self.Pos = {{pos[game.GetMap()][1], pos[game.GetMap()][2]}}
		else
			self.Pos = pos[game.GetMap()]
		end
	else
		Error('Unable to find pos for item ('..self:GetQuest():GetName()..' quest)!')
	end
	return self
end

function base_entity_mt:GetPos()
	return table.Random(self.Pos)
end

function base_entity_mt:GetPoses()
	return self.Pos
end

function base_entity_mt:Start()
end

function base_entity_mt:End()
end

function base_entity_mt:TransmitStart(ent)
	net.WriteEntity(ent)
end

function base_entity_mt:ReadTransmitStart(t)
	t[self:GetQuest():GetID()] = net.ReadEntity()
end
--function base_entity_mt:Start(ply)
--	--self:Spawn(ply)
--end

--function base_entity_mt:Spawn(ply)
--	local ent = ents.Create(self:GetClass())
--	ent:SetPos(table.Random(self:GetPos()))
--	ent.ItemOwner = ply
--	self:OnSpawn(ent, ply)
--
--	quest_entities[ply][self:GetQuest():GetID()] = ent
--	
--end

--function base_entity_mt:OnEnd()
--	self:Remove()
--end



// BASE REUSABLE ENTITY
ITEM_REUSABLE = rp.Quest.AddEntityMT()
AddMethod(ITEM_REUSABLE, 'Visible', false)
ITEM_REUSABLE:SetClass('base_quest_reusable_entity')
--ITEM_REUSABLE:SetRemoveOnEnd(false)

// BASE USABLE ENTITY
ITEM_USABLE = rp.Quest.AddEntityMT()
ITEM_USABLE:SetClass('base_quest_entity')
