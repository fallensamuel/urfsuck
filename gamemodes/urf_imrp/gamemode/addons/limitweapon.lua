hook.Add('PlayerCanPickupWeapon', 'CantPickUpGman', function(Player, Weapon)
    if IsValid(Player) and Player:Team() == TEAM_GMAN then 
		local WeaponList = Player:GetJobTable().weapons;
		Weapon = (IsValid(Weapon) and Weapon:GetClass()) or '?';
		return WeaponList[Weapon]
	end
end);