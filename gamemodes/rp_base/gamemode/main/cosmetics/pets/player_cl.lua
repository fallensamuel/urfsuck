-- "gamemodes\\rp_base\\gamemode\\main\\cosmetics\\pets\\player_cl.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal

function PLAYER:GetPetEntity()
	return self.Pet
end

function PLAYER:SpawnPet(id)
	local pos = self:getItemDropPos()
	local ang = self:EyeAngles()
	ang.p = 0
	ang.y = ang.y + 180

	local ent = ents.CreateClientside("urfim_pet")
	ent:SetPos(pos)
	ent:SetAngles(ang)
	ent:Spawn()
	ent:Activate()

	ent.Owner = self
	self.Pet = ent
	
	ent:LoadPet(rp.pets.GetById(id))
end

function PLAYER:DespawnPet()
	self.Pet:Remove()
end
