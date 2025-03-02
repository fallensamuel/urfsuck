local RapistVoices = {"vo/npc/female01/moan01.wav", "vo/npc/female01/moan02.wav", "vo/npc/female01/moan03.wav", "vo/npc/female01/moan04.wav", "vo/npc/female01/moan05.wav"}
local TargetVoices = {"vo/npc/male01/moan01.wav", "vo/npc/male01/moan02.wav", "vo/npc/male01/moan03.wav", "vo/npc/male01/moan04.wav", "vo/npc/male01/moan05.wav"}

local function IsPimp()
	for k, v in pairs(player.GetAll()) do
		if v:Team() == rp.PimpTeam then return true end

		return false
	end
end

local function PimpsCut()
	for k, v in pairs(player.GetAll()) do
		if v:Team() == rp.PimpTeam then
			v:AddMoney(100)
			rp.Notify(v, NOTIFY_GREEN, rp.Term('HoesProfit'))
		end
	end
end

local function DoFuck(pl, Target)
	if Target:Team() ~= rp.PimpTeam then
		if (not Target:CanAfford(250)) then
			rp.Notify(pl, NOTIFY_ERROR, rp.Term('CannotAffordHoe'), Target)
			rp.Notify(Target, NOTIFY_ERROR, rp.Term('YouCannotAffordHoe'), pl)

			return
		end

		pl:AddMoney(150)
		Target:AddMoney(-250)
		PimpsCut()
	end

	for k, v in pairs(ents.FindInSphere(pl:GetPos(), 200)) do
		if v:IsPlayer() and v:IsCP() and not pl:IsWanted(v:GetFaction()) then
			pl:Wanted(v, "Prostitution")
			break
		end
	end

	rp.Notify(pl, NOTIFY_ERROR, rp.Term('LostKarmaNR'), 2)
	pl:AddKarma(-2)
	rp.Notify(Target, NOTIFY_ERROR, rp.Term('LostKarmaNR'), 2)
	Target:AddKarma(-2)
	local FuckTime = math.random(5, 10)
	local Chance = math.random(1, 8)
	pl:Freeze(true)

	timer.Create("FuckSounds", 1.5, 0, function()
		pl:EmitSound(table.Random(RapistVoices), 500, 100)
		pl:ViewPunch(Angle(math.random(-1, 1), math.random(-1, 1), math.random(-10, 10)))
	end)

	Target:Freeze(true)

	timer.Create("TargetSounds", 1.5, 0, function()
		Target:EmitSound(table.Random(TargetVoices), 500, 100)
		Target:ViewPunch(Angle(math.random(-1, 1), math.random(-1, 1), math.random(-10, 10)))
	end)

	timer.Create("FuckUnFreeze", FuckTime, 1, function()
		pl:TakeHunger(10)
		Target:EmitSound("bot/hang_on_im_coming.wav")
		pl:Freeze(false)
		Target:TakeHunger(10)
		Target:EmitSound("ambient/voices/m_scream1.wav")
		Target:Freeze(false)

		if Chance == 3 then
			rp.Notify(Target, NOTIFY_ERROR, rp.Term('YouGotAIDS'))
			GiveSTD(Target)
		end

		if Chance == 4 then
			rp.Notify(pl, NOTIFY_ERROR, rp.Term('YouGotAIDS'))
			GiveSTD(pl)
		end

		timer.Remove("FuckSounds")
		timer.Remove("TargetSounds")
	end)
end

local function FuckPlayer(pl)
	local Target = pl:GetEyeTrace().Entity
	if not IsValid(pl) then return "" end
	if not IsValid(Target) then return "" end
	if not pl:Alive() then return "" end

	if pl:EyePos():DistToSqr(Target:GetPos()) > 19600 or not Target:IsPlayer() then
		rp.Notify(pl, NOTIFY_ERROR, rp.Term('GetCloser'))

		return ""
	end

	if not pl:Alive() then
		rp.Notify(pl, NOTIFY_ERROR, rp.Term('YouAreDead'))

		return ""
	end

	if not ba.IsSuperAdmin(pl) then
		if !pl:GetJobTable().hoe then
			rp.Notify(pl, NOTIFY_ERROR, rp.Term('NotAHoe'))

			return ""
		end
	end

	if Target:IsNPC() then
		rp.Notify(pl, NOTIFY_ERROR, rp.Term('NPCsDontFuck'))

		return ""
	end

	if Target:IsFrozen() then
		rp.Notify(pl, NOTIFY_ERROR, rp.Term('TargetFrozen'))

		return ""
	end

	if (Target:IsCP() or Target:Team() == TEAM_MAYOR) and not pl:IsWanted(Target:GetFaction()) then
		if pl.IsWantedAnyFaction then
			pl:Wanted(nil, "Prostitution", Target:GetFaction())
		else
			pl:Wanted(nil, "Prostitution")
		end
	end

	rp.Notify(pl, NOTIFY_GENERIC, rp.Term('WaitingForAnswer'))
	local FuckCost = 250

	if Target:Team() == rp.PimpTeam then
		FuckCost = 0
	end

	GAMEMODE.ques:Create(translates and translates.Get("Хотите заняться сексом с \n%s за $%i?", pl:Name(), FuckCost) or ("Хотите заняться сексом с \n" .. pl:Name() .. " за $" .. FuckCost .. "?"), "fuckyfucky" .. pl:UserID(), Target, 30, function(answer, ent, initiator, target)
		if tobool(answer) == false then
			rp.Notify(pl, NOTIFY_ERROR, rp.Term('TargetWontFuck'))

			return ""
		elseif tobool(answer) and pl:EyePos():DistToSqr(Target:GetPos()) > 19600 or not Target:IsPlayer() then
			rp.Notify(pl, NOTIFY_ERROR, rp.Term('TargetTooFar'))
			rp.Notify(Target, NOTIFY_ERROR, rp.Term('HoeTooFar'))

			return ""
		elseif tobool(answer) then
			DoFuck(pl, Target)

			if IsPimp() then
				rp.Notify(pl, NOTIFY_GREEN, rp.Term('+FuckCostPimp'), FuckCost)
			else
				rp.Notify(pl, NOTIFY_GREEN, rp.Term('+Money'), FuckCost)
				rp.Notify(Target, NOTIFY_ERROR, rp.Term('-Money'), FuckCost)

				return ""
			end

			rp.Notify(Target, NOTIFY_ERROR, rp.Term('-Money'), FuckCost)

			return ""
		end
	end)
end

rp.AddCommand("/sex", FuckPlayer)
rp.AddCommand("/fuck", FuckPlayer)