util.AddNetworkString('RapeFinish')

local RapistVoices = {
	"vo/npc/male01/likethat.wav",
	"vo/coast/odessa/male01/nlo_cheer02.wav",
	"vo/coast/odessa/male01/nlo_cheer03.wav",
	"vo/coast/odessa/male01/nlo_cheer04.wav",
	"player/crit_death1.wav",
	"player/crit_death2.wav",
	"player/crit_death3.wav",
	"player/crit_death4.wav",
	"player/crit_death5.wav",
	"bot/come_to_papa.wav",
	"bot/im_pinned_down.wav",
	"bot/oh_man.wav",
	"bot/yesss.wav",
	"bot/pain4",
	"bot/pain5",
	"bot/pain8",
	"bot/pain9",
	"bot/pain10",
	"bot/stop_it.wav",
	"bot/help.wav",
	"bot/i_could_use_some_help.wav",
	"bot/i_could_use_some_help_over_here.wav",
	"bot/they_got_me_pinned_down_here.wav",
	"bot/this_is_my_house.wav",
	"bot/need_help.wav",
	"bot/i_am_dangerous.wav",
	"bot/yikes.wav",
	"noo.wav",
	"bot/whos_the_man.wav",
	"bot/hang_on_im_coming.wav",
	"hostage/hpain/hpain1.wav",
	"hostage/hpain/hpain2.wav",
	"hostage/hpain/hpain3.wav",
	"hostage/hpain/hpain4.wav",
	"hostage/hpain/hpain5.wav",
	"hostage/hpain/hpain6.wav",
	"vo/k_lab/al_youcoming.wav",
	"vo/k_lab/kl_ahhhh.wav",
}

local TargetVoices = {
	"vo/npc/male01/moan04.wav",
	"vo/npc/male01/moan05.wav"
}

function GiveSTD(player)
	if !IsValid(player) then return end
	player:Timer("PlayerHasSTD", 2, 0, function()
		player:SetHealth(math.max(player:Health() - 5, 5))
		player:EmitSound(TargetVoices[math.random(1, #TargetVoices)], 500, 100)
		if player:Health() <= 5 then 
			--player:Kill()
			player:DestroyTimer("PlayerHasSTD")
		end
	end)
end

hook.Add("PlayerDeath", "CureSTD", function(ply)
	ply:DestroyTimer("PlayerHasSTD")
end)

function CureSTD(player)
	if !IsValid(player) then return end
	player:DestroyTimer("PlayerHasSTD")
end

local function RapePlayer(pl)
	local Target = pl:GetEyeTrace().Entity

	if !IsValid(pl) then return "" end
	if !IsValid(Target) then return "" end
	if !pl:Alive() then return "" end
	if pl.isInRape then return "" end

	if pl:EyePos():DistToSqr(Target:GetPos()) > 19600 or !Target:IsPlayer() then 
		rp.Notify(pl, NOTIFY_ERROR, rp.Term('GetCloser'))
		return ""
	end

	if !pl:Alive() then 
			rp.Notify(pl, NOTIFY_ERROR, rp.Term('YouAreDead'))
		return "" 
	end

	if !ba.IsSuperAdmin(pl) && !pl:IsArrested() then
		if pl:Team() != TEAM_RAPIST and not pl:GetJobTable().rapist then
			rp.Notify(pl, NOTIFY_ERROR, rp.Term('NotARapist'))
			return ""
		end
	end

	if Target:IsNPC() then
		rp.Notify(pl, NOTIFY_ERROR, rp.Term('RapeNPC'))
		return "" 
	end

	if Target:IsFrozen() then
		rp.Notify(pl, NOTIFY_ERROR, rp.Term('TargetFrozen'))
		return "" 
	end

	if (Target:IsCP() or Target:Team() == TEAM_MAYOR) and not pl:IsWanted(Target:GetFaction()) then
		pl:Wanted(Target, translates and translates.Get('Изнасилование') or 'Изнасилование')
	end

	if pl.NextRape != nil && pl.NextRape >= CurTime() && !pl:IsArrested() then
		rp.Notify(pl, NOTIFY_ERROR, rp.Term('NeedToWait'), math.ceil(pl.NextRape - CurTime()))
		return "" 
	end

	rp.Notify(pl, NOTIFY_ERROR, rp.Term('LostKarmaNR'), 2)
	pl:AddKarma(-2)

	if !ba.IsSuperAdmin(pl) && !pl:IsArrested() then 
		pl.NextRape = 180 + CurTime()
	elseif pl:IsArrested() then
		pl.NextRape = 2 + CurTime()
	end

	for k,v in pairs(ents.FindInSphere(pl:GetPos(),200)) do 
		if v:IsPlayer() && v:IsCP() && !pl:IsWanted(v:GetFaction()) then
			if pl.IsWantedAnyFaction then
				pl:Wanted(nil, translates and translates.Get('Изнасилование') or 'Изнасилование', v:GetFaction())
			else
				pl:Wanted(nil, translates and translates.Get('Изнасилование') or 'Изнасилование')
			end
			
			break
		end
	end

	if math.random(1, 5) == 1 then
		rp.Notify(pl, NOTIFY_ERROR, rp.Term('RapeFailed'))
		rp.Notify(Target, NOTIFY_ERROR, rp.Term('RapeAttempted'))
		return ""
	end
	
	local RapeTime = math.random(5,10)
	local Chance = math.random(1, 8)

	pl.isInRape = true

	pl:Freeze(true)
	rp.Notify(pl, NOTIFY_GREEN, rp.Term('Raped'), Target)
	pl:Timer("RapistSounds", 1.5, 0, function()
		pl:EmitSound(RapistVoices[math.random(1, #RapistVoices)], 500, 100)
		pl:ViewPunch(Angle(math.random(-1, 1), math.random(-1, 1), math.random(-10, 10)))
	end)

	Target:Freeze(true)
	rp.Notify(Target, NOTIFY_ERROR, rp.Term('YouAreRaped'))
	Target:Timer("TargetSounds", 1.5, 0, function()
		Target:EmitSound(TargetVoices[math.random(1, #TargetVoices)], 500, 100)
		Target:ViewPunch(Angle(math.random(-1, 1), math.random(-1, 1), math.random(-10, 10)))
	end)

	pl:Timer("RapeUnFreeze", RapeTime, 1, function()
		if pl:Health() <= 450 then
			pl:SetHealth(pl:Health() + 50)
		elseif pl:Health() >= 450 && pl:Health() <= 500 then
			pl:SetHealth(500)
		end
		pl:TakeHunger(10)
		pl:Freeze(false)
		
		if IsValid(Target) then
			Target:EmitSound("bot/hang_on_im_coming.wav")
			Target:EmitSound("ambient/voices/m_scream1.wav")
			Target:Freeze(false)
			
			net.Start('RapeFinish')
			net.Send(Target)
			
			if Chance == 3 and not rp.cfg.DisableSTD then	
				rp.Notify(Target, NOTIFY_ERROR, rp.Term('YouGotAIDS'))
				GiveSTD(Target)
				
			elseif Chance == 4 then	
				rp.Notify(Target, NOTIFY_ERROR, rp.Term('AnalProlapseShort'))
				--Target:Kill()
			end
			
			Target:DestroyTimer("TargetSounds")
		end
		
		pl.isInRape = nil

		if Chance == 5 then
			rp.Notify(pl, NOTIFY_ERROR, rp.Term('DickFellOff'))
			--pl:Kill()
		end
		
		pl:DestroyTimer("RapistSounds")
		
	end, function()
		if IsValid(Target) then
			Target:Freeze(false)
			Target:DestroyTimer("TargetSounds")
		end
	end)

	return ""
end
rp.AddCommand("/rape", RapePlayer)