function PLAYER:SetPropSpawnBlock(b)
	self.PropSpawnBlock = tobool(b)
end

function PLAYER:HasPropSpawnBlock()
	return self.PropSpawnBlock or self:GetJobTable().PropSpawnBlock
end

hook.Add("PlayerSpawnProp", "PMETA_SetPropSpawnBlock", function(ply)
	if ply:HasPropSpawnBlock() then
		return false
	end
end)