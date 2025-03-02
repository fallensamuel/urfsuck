AddCSLuaFile()

ENT.Base = "use_to_hide"
ENT.Spawnable = true
ENT.AdminSpawnable = true
ENT.AdminOnly = true

ENT.PrintName = "Test Use To Hide"
ENT.Model = "models/props_lab/filecabinet02.mdl"

function ENT:CanUse(ply)
	return ply:IsRoot()
end

ENT.UseCooldown = 5

--ENT.GiveMoney = 100
--ENT.GiveItem = "pickle"
--ENT.SpawnItem = "pickle"
ENT.SpawnEntity = "sent_ball"

ENT.SuccessUseTerm = "TestUseToHide"
rp.AddTerm("TestUseToHide", "Вы нашли подарок и получили #!"); 