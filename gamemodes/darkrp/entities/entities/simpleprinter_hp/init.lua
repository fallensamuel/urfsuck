AddCSLuaFile("shared.lua")
include("shared.lua")


function ENT:UseFunc(ply)
	if self:GetCurAmount() < 0 then return end

	local old_hp = ply:Health()
	if old_hp == ply:GetMaxHealth() then
		rp.Notify(ply, NOTIFY_RED, "Вы не нуждаетесь в лечении.")
		return
	end

	local new_hp = math.Clamp(ply:Health() + self:GetCurAmount(), 0, ply:GetMaxHealth())
	if new_hp > old_hp then
		ply:SetHealth(new_hp)
		self:SetCurAmount(self:GetCurAmount() - (new_hp-old_hp))
		rp.Notify(ply, NOTIFY_GREEN, rp.Term('PlayerTookSomeFromPrinter'), "здоровье на "..(new_hp-old_hp).." едениц")
	end
end