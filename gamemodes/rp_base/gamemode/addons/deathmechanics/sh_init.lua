nw.Register 'deathmech_t'
	:Write(net.WriteFloat)
	:Read(net.ReadFloat)
	:SetLocalPlayer()

function PLAYER:IsInDeathMechanics()
    return SERVER and self.DeathAction or CLIENT and EmoteActions:GetSharedSequenceName(self:GetNetVar("EmoteActions.Sequence")) == "incap_new"
end