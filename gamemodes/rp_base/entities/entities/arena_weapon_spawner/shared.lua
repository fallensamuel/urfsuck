-- "gamemodes\\rp_base\\entities\\entities\\arena_weapon_spawner\\shared.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal

ENT.PrintName = "Arena Weapon"
ENT.Type = "anim"
ENT.RenderGroup = RENDERGROUP_BOTH
ENT.LazyFreeze = true

ENT.IsArenaWeapon = true

function ENT:SetupDataTables()
	self:NetworkVar('Int', 0, 'UsedUntil')
	self:NetworkVar('Int', 1, 'WeaponID')
end

/*
hook.Add('ShouldCollide', 'rp.Arena.WeaponGet', function(ent1, ent2)
	local ply = IsValid(ent1) and ent1:IsPlayer() and ent1 or IsValid(ent2) and ent2:IsPlayer() and ent2
	local ent = IsValid(ent1) and ent1.IsArenaWeapon and ent1 or IsValid(ent2) and ent2.IsArenaWeapon and ent2
	
	if IsValid(ply) and IsValid(ent) then
		if SERVER and rp.Arena and rp.Arena.players and rp.Arena.players[ply:SteamID()] then
			ent:GiveArenaWeapon(ply)
		end
		
		return false
	end
end)
*/
