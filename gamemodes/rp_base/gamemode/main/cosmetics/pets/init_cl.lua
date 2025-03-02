-- "gamemodes\\rp_base\\gamemode\\main\\cosmetics\\pets\\init_cl.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal

rp.pets = rp.pets or {}

function rp.pets.GetMy()
	local pets = {}
	
	for k, v in pairs(rp.pets.All) do
		if LocalPlayer():HasUpgrade(v.uid) then
			table.insert(pets, v)
		end
	end
	
	return pets
end

-- TODO: Sync on load/deload/spawn/despawn
timer.Create("Pets::Sync", 1, 0, function()
	if not IsValid(LocalPlayer()) then return end
	
	for k, v in pairs(player.GetAll()) do
		if not IsValid(v) then continue end
		
		if v:GetPet() then
			if IsValid(v:GetPetEntity()) and v:GetPetEntity():GetPetID() != v:GetPet() then
				v:DespawnPet()
				v:SpawnPet(v:GetPet())
			end
			
			if not IsValid(v:GetPetEntity()) then
				v:SpawnPet(v:GetPet())
			end
			
		else
			if IsValid(v:GetPetEntity()) then
				v:DespawnPet()
			end
		end
	end
end)

net.Receive( "Pets::Event", function()
	local ply, ev = net.ReadEntity(), net.ReadUInt(3);

	if not IsValid( ply ) then return end

	local pet = ply:GetPetEntity();
	if not IsValid(pet) then return end

	if pet.OnEvent then
		pet:OnEvent( ev );
	end
end );