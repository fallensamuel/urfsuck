hook.Add("OnPlayerNoclip", "Block.AfterNoclipping", function(ply, enable)
	ply.AfterNoclippingCooldown = CurTime() + (rp.cfg.AfterNoclipUseCooldown or 30)
end)

local accepted_qmenu_tools = {
	['remover'] = true,
	['colour'] = true,
	['material'] = true,
}

hook.Add("CanTool", "Block.Tools", function(ply, tr, tool)
	if not ply:IsRoot() and IsValid(tr.Entity) and rp.QObjects[tr.Entity:GetClass()] and not accepted_qmenu_tools[tool or ''] then
		return false
	end
end)

function PLAYER:CantDoAfterNoclip(notify)
	if not self:IsAdmin() or self:IsRoot() then return false end
--[[
	if self:GetMoveType() == MOVETYPE_NOCLIP then
		if SERVER then
			rp.Notify(self, NOTIFY_ERROR, rp.Term("CantDoThis"))
		else
			rp.Notify(NOTIFY_ERROR, rp.Term("CantDoThis"))
		end

		return true
	end
]]--
	local CT = CurTime()
	local b = (self.AfterNoclippingCooldown or 0) > CT

	if notify and b then 
		local t = math.floor(self.AfterNoclippingCooldown - CT)
		if SERVER then
			rp.Notify(self, NOTIFY_ERROR, rp.Term("PleaseWaitX"), t)
		else
			rp.Notify(NOTIFY_ERROR, rp.Term("PleaseWaitX"), t)
		end
	end

	return b
end

hook.Add('InitPostEntity', 'AR2::BlockOrbs', function()
	if list.HasEntry('SpawnableEntities', 'item_ammo_ar2_altfire') then
		list.Set('SpawnableEntities', 'item_ammo_ar2_altfire', nil)
	end
end)
