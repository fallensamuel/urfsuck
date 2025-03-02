
util.AddNetworkString( "StaminaDrowninG" )
util.AddNetworkString( "ResetStamina" )
util.AddNetworkString( "TakeStamina" )


--CreateConVar("sv_bur_maxstamina", "100", FCVAR_REPLICATED + FCVAR_ARCHIVE , "" )
--CreateConVar("sv_bur_regenmul", "1", FCVAR_REPLICATED + FCVAR_ARCHIVE , "" )
--CreateConVar("sv_bur_decaymul", "0.5", FCVAR_REPLICATED + FCVAR_ARCHIVE , "" )

net.Receive("StaminaDrowninG", function(len, ply)
	if ply:IsCooldownAction("StaminaDrowninG") then return end

	local dmg = DamageInfo()
	dmg:AddDamage(10)
	dmg:SetDamageType(DMG_DROWN)
	dmg:SetAttacker(ply)
	dmg:SetInflictor(ply)
	
	ply:TakeDamageInfo(dmg)
end)


function PLAYER:TakeStamina(amount)
	if not IsValid(self) then return end
	
	net.Start('TakeStamina')
		net.WriteUInt(amount, 10)
	net.Send(self)
end

function StaminaResetVariables(ply)
	net.Start("ResetStamina")
	net.Send(ply)
	
	ply:SetNetVar('LastDamageTime', 0)
end

hook.Add("PlayerSpawn","Stamina Reset Variables",StaminaResetVariables)
hook.Add("PlayerInitialSpawn","Stamina Reset Variables",StaminaResetVariables)

hook.Add('EntityTakeDamage', 'Stamina Damage Enabling', function(ply)
	if not rp.cfg.DisableStamina and IsValid(ply) and ply:IsPlayer() and ply:Alive() then 
		local cur_time = CurTime()
		
		ply:SetNetVar('LastDamageTime', cur_time)
		
		timer.Create('Stamina disabling ' .. ply:SteamID(), rp.cfg.StaminaRestoreTime, 1, function()
			if !IsValid(ply) then return end
			if ply:Health() < 20 then
				ply:AddHealth(20 - ply:Health())
			end
		end)
	end
end)


