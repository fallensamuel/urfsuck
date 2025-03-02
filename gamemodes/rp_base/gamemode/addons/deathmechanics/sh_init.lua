-- "gamemodes\\rp_base\\gamemode\\addons\\deathmechanics\\sh_init.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
DEATHMECHANICS_NONE = 0;
DEATHMECHANICS_HEAL = 1;
DEATHMECHANICS_FALL = 2;

nw.Register 'deathmech_t'
	:Write(net.WriteFloat)
	:Read(net.ReadFloat)
	:SetLocalPlayer()

nw.Register 'deathmech_s'
	:Write(net.WriteUInt, 2)
	:Read(net.ReadUInt, 2)
	:SetLocalPlayer()

nw.Register 'deathmech_b'
	:Write(net.WriteBool)
	:Read(net.ReadBool)

if CLIENT then
	local sequence_name = {
		['incap_new'] = true
	}

	function PLAYER:IsInDeathMechanics()
		return sequence_name[EmoteActions:GetSharedSequenceName(self:GetNetVar("EmoteActions.Sequence"))]
	end
else
	function PLAYER:IsInDeathMechanics()
		return self.DeathAction
	end
end

function PLAYER:IsInDeathMechanics()
	return tobool( self:GetNetVar("deathmech_b") )
end

function PLAYER:GetDeathMechanicsState()
	return self:GetNetVar("deathmech_s") or 0;
end