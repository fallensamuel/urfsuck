AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:UseFunc(ply)
	if self:GetCurAmount() < 0 then return end

	local old_ar = ply:Armor()
	if old_ar == ply:GetMaxArmor() then
		rp.Notify(ply, NOTIFY_RED, rp.Term('SPP_MaxArmor'))
		return
	end

	local new_ar = math.Clamp(ply:Armor() + self:GetCurAmount(), 0, ply:GetMaxArmor())
	if new_ar > old_ar then
		ply:SetArmor(new_ar)
		self:SetCurAmount(self:GetCurAmount() - (new_ar-old_ar))
		
		rp.Notify(ply, NOTIFY_GREEN, rp.Term('PlayerTookSomeFromPrinter'), translates and translates.Get( "броню на %i", new_ar - old_ar ) or ("броню на `"..(new_ar-old_ar).."`"))
	end
end