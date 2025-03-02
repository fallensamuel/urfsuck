hook.Add("PlayerChangedTeam", "Player.SpawnTimestamp", function(ply)
	ply.TeamChangeTimestamp = CurTime()
end)

hook.Add("ScalePlayerDamage", "UrfIm.Player.Mayor.Immunity", function(ply, hitgroup, dmgobj)
	local att = dmgobj:GetAttacker()
	if ply:IsMayor() and IsValid(att) and att:IsPlayer() then
		local CT = CurTime()
		local t = ((ply.TeamChangeTimestamp or 0) + (rp.cfg.MayorImunnity or 300))
		if t < CT then return end

		dmgobj:ScaleDamage(0)

		if (att.LastMayorImmunityNotify or 0 ) < CT then
			att.LastMayorImmunityNotify = CT + 2
			rp.Notify(att, NOTIFY_RED, rp.Term("ThisIsMayorImunnity"), t - CT)
		end
	end
end)