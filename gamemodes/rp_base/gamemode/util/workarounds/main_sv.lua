local IsValid = IsValid
local ipairs = ipairs

timer.Remove('HostnameThink')

ENTITY._SetHealth = ENTITY._SetHealth or ENTITY.SetHealth
ENTITY.SetHealth = function(self, amt)
	if IsValid(self) and self:IsPlayer() and (amt > rp.cfg.MaxHealth) then
		return self:_SetHealth(rp.cfg.MaxHealth)
	end
	return self:_SetHealth(amt)
end

ENTITY._SetMaxHealth = ENTITY._SetMaxHealth or ENTITY.SetMaxHealth
ENTITY.SetMaxHealth = function(self, amt)
	if IsValid(self) and self:IsPlayer() and (amt > rp.cfg.MaxHealth) then
		return self:_SetMaxHealth(rp.cfg.MaxHealth)
	end
	return self:_SetMaxHealth(amt)
end

ENTITY._SetArmor = ENTITY._SetArmor or ENTITY.SetArmor
ENTITY.SetArmor = function(self, amt)
	if IsValid(self) and self:IsPlayer() and (amt > rp.cfg.MaxArmor) then
		return self:_SetArmor(rp.cfg.MaxArmor)
	end
	return self:_SetArmor(amt)
end

PLAYER._SetTeam = PLAYER._SetTeam or PLAYER.SetTeam
function PLAYER:SetTeam(team)
	if not self:IsBanned() or team == TEAM_BANNED then
		self:_SetTeam(team)
	end
end

function ENTITY:IsConstrained()
	local c = self.Constraints
	if c then
		for k, v in ipairs(c) do
			if v:IsValid() then
				return true
			end
			c[k] = nil
		end
	end
	return false
end

_G.RunString 		= function() end -- We dont use these.
_G.RunStringEx 		= function() end
_G.CompileString 	= function() end
_G.CompileFile 		= function() end 