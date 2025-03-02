
local maxHealth, health, regen
timer.Create("HPRegen", 5, 0, function()
	for k, ply in pairs(player.GetAll()) do
		if ply:Alive() then
			regen = ply:GetTeamTable().hpRegen or ply.hpRegen
			if regen then
				maxHealth = ply:GetMaxHealth()
				health = ply:Health()
				if health >= maxHealth - regen then
					if health < maxHealth then
						ply:SetHealth(maxHealth)
					end
				elseif health + regen < maxHealth then
					ply:SetHealth(health + regen)
				end
			end
		end
	end
end)