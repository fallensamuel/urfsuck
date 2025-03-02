AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:UseFunc(ply)
	if self:GetCurAmount() < 0 then return end

	ply:AddMoney(self:GetCurAmount())
	rp.Notify(ply, NOTIFY_GREEN, rp.Term('PlayerTookMoneyBasket'), rp.FormatMoney(self:GetCurAmount()))
			
	self:SetCurAmount(0)
end