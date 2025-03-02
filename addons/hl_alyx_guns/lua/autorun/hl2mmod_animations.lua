----------------------------------------------------------------
--~~DON'T REDISTRIBUTE THIS CODE WITHOUT AUTHOR'S PERMISSION~~--
----------------------------------------------------------------

local inspectableWeapons = {
	["weapon_pistol"] = true,
	["weapon_357"] = true,
	["weapon_smg1"] = true,
	["weapon_ar2"] = true,
	["weapon_shotgun"] = true,
	["weapon_crossbow"] = true,
	["weapon_rpg"] = true,
	["weapon_crowbar"] = true
}

local sprintableWeapons = {
	["weapon_pistol"] = true,
	["weapon_357"] = true,
	["weapon_smg1"] = true,
	["weapon_shotgun"] = true,
	["weapon_crossbow"] = true,
	["weapon_rpg"] = true,
	["weapon_frag"] = true,
	["weapon_stunstick"] = true,
	["weapon_crowbar"] = true,
	["weapon_physcannon"] = true
}

if SERVER then
	hook.Add("KeyPress", "MMOD_Weapon_Inspect", function(ply, key)
		if key != IN_RELOAD then return end
		if !ply:Alive() then return end

		local wep = ply:GetActiveWeapon()
		if !IsValid(wep) then return end

		local class = wep:GetClass()
		if !inspectableWeapons[class] then return end

		local vm = ply:GetViewModel()
		if !IsValid(vm) then return end

		local seq = vm:GetSequence()
		local seqinfo = vm:GetSequenceInfo(seq)

		local vel = ply:GetVelocity():Length()
		if vel > 10 then return end

		if seqinfo.activityname == "ACT_VM_IDLE" then
			if (!wep.MMOD_NextInspectTime) or (wep.MMOD_NextInspectTime and CurTime() > wep.MMOD_NextInspectTime) then
				if wep:Clip1() == wep:GetMaxClip1() then
				local seqToPlay = vm:LookupSequence("inspect"..tostring(math.random(1,2)))
					if seqToPlay then
					local dur = vm:SequenceDuration(seqToPlay)

					wep:SetSaveValue("m_flTimeWeaponIdle", dur)
					vm:SendViewModelMatchingSequence(seqToPlay)
					wep.MMOD_NextInspectTime = CurTime() + dur

					end
				end
			end
		end
	end)
end

if CLIENT and game.SinglePlayer() then
	hook.Add("Think", "MMOD_AR2_Skin", function()
		local ply = LocalPlayer()
		if !ply:Alive() then return end

		local wep = ply:GetActiveWeapon()
		if !IsValid(wep) then return end

		local class = wep:GetClass()
		if class != "weapon_ar2" then return end

		local vm = ply:GetViewModel()
		if !IsValid(vm) then return end

		local seq = vm:GetSequence()
		local seqinfo = vm:GetSequenceInfo(seq)

		local seqName = seqinfo.label
		local cyc = vm:GetCycle()

		if (string.find(seqName, "fire") and cyc < 0.2) or string.find(seqName, "shake") or (seqName == "inspect1" and cyc > 0.1 and cyc < 0.9) or (seqName == "inspect2" and cyc > 0.4 and cyc < 0.55)then
			if vm:GetSkin() != 1 then
				vm:SetSkin(1)
			end
		else
			if vm:GetSkin() != 0 then
				vm:SetSkin(0)
			end
		end
	end)
end

if game.SinglePlayer() and CLIENT then
	hook.Add("Think", "MMOD_Weapon_Sprint_SP", function()
		local ply = LocalPlayer()
		if !ply:Alive() then return end

		local wep = ply:GetActiveWeapon()
		if !IsValid(wep) then return end

		local class = wep:GetClass()

		local vm = ply:GetViewModel()
		if !IsValid(vm) then return end
		
		local bool = ply:Crouching()

		local seq = vm:GetSequence()
		local seqinfo = vm:GetSequenceInfo(seq)

		local vel = ply:GetVelocity():Length()
		local crouchspeed = ply:GetWalkSpeed() * ply:GetCrouchedWalkSpeed() --minimum speed to play anim

		if seqinfo.activityname == "ACT_VM_IDLE" then
			if class == "weapon_ar2" and wep:Clip1() > 1 or sprintableWeapons[class] then
			if (!wep.MMOD_NextSprintTime) or (wep.MMOD_NextSprintTime and CurTime() > wep.MMOD_NextSprintTime) then
				if ply:KeyDown(IN_SPEED) and ply:OnGround() and vel >= crouchspeed and !bool then
				local seqToPlay = vm:LookupSequence("sprint")
					if seqToPlay then

						local dur = vm:SequenceDuration(seqToPlay)
						vm:SendViewModelMatchingSequence(seqToPlay)
						wep.MMOD_NextSprintTime = CurTime() + dur

						else return false

						end
					end
				end
			end
		elseif string.lower(seqinfo.label) == "sprint" then
			if !ply:KeyDown(IN_SPEED) or !ply:OnGround() or vel < crouchspeed or bool then
			local seqToPlay = vm:LookupSequence(ACT_VM_IDLE)
				if seqToPlay then

				local dur = vm:SequenceDuration(seqToPlay)
				vm:SendViewModelMatchingSequence(seqToPlay)
				wep.MMOD_NextSprintTime = CurTime() + 0.25

				else return false

				end
			end
		elseif seqinfo.activityname == "ACT_VM_IDLE_MIDEMPTY" then
			if class == "weapon_ar2" and wep:Clip1() == 1 then
			if (!wep.MMOD_NextSprintTime) or (wep.MMOD_NextSprintTime and CurTime() > wep.MMOD_NextSprintTime) then
				if ply:KeyDown(IN_SPEED) and ply:OnGround() and vel >= crouchspeed and !bool then
					local seqToPlay = vm:LookupSequence("sprint_midempty")
						if seqToPlay then

						local dur = vm:SequenceDuration(seqToPlay)
						vm:SendViewModelMatchingSequence(seqToPlay)
						wep.MMOD_NextSprintTime = CurTime() + dur

						else return false

						end
					end
				end
			end
		elseif string.lower(seqinfo.label) == "sprint_midempty" then
			if !ply:KeyDown(IN_SPEED) or !ply:OnGround() or vel < crouchspeed or bool then
			local seqToPlay = vm:LookupSequence("idle_midempty")
				if seqToPlay then
				
				local dur = vm:SequenceDuration(seqToPlay)
				vm:SendViewModelMatchingSequence(seqToPlay)
				wep.MMOD_NextSprintTime = CurTime() + 0.25

				end
			end
		elseif seqinfo.activityname == "ACT_VM_IDLE_EMPTY" then
			if class == "weapon_ar2" and wep:Clip1() == 0 then
			if (!wep.MMOD_NextSprintTime) or (wep.MMOD_NextSprintTime and CurTime() > wep.MMOD_NextSprintTime) then
				if ply:KeyDown(IN_SPEED) and ply:OnGround() and vel >= crouchspeed and !bool then
					local seqToPlay = vm:LookupSequence("sprint_empty")
						if seqToPlay then

						local dur = vm:SequenceDuration(seqToPlay)
						vm:SendViewModelMatchingSequence(seqToPlay)
						wep.MMOD_NextSprintTime = CurTime() + dur

						else return false

						end
					end
				end
			end
		elseif string.lower(seqinfo.label) == "sprint_empty" then
			if !ply:KeyDown(IN_SPEED) or !ply:OnGround() or vel < crouchspeed or bool then
			local seqToPlay = vm:LookupSequence("idle_empty")
				if seqToPlay then

				local dur = vm:SequenceDuration(seqToPlay)
				vm:SendViewModelMatchingSequence(seqToPlay)
				wep.MMOD_NextSprintTime = CurTime() + 0.25
				
				else return false

				end
			end
		end
	end)

	hook.Add("Think", "MMOD_Weapon_Walk_SP", function()
		local ply = LocalPlayer()
		if !ply:Alive() then return end

		local wep = ply:GetActiveWeapon()
		if !IsValid(wep) then return end

		local class = wep:GetClass()

		local vm = ply:GetViewModel()
		if !IsValid(vm) then return end

		local bool = ply:Crouching()

		local seq = vm:GetSequence()
		local seqinfo = vm:GetSequenceInfo(seq)

		local vel = ply:GetVelocity():Length()
		local crouchspeed = ply:GetWalkSpeed() * ply:GetCrouchedWalkSpeed() // minimum speed to play anim

		if seqinfo.activityname == "ACT_VM_IDLE" then
			if class == "weapon_ar2" and wep:Clip1() > 1 or sprintableWeapons[class] then
			if (!wep.MMOD_NextWalkTime) or (wep.MMOD_NextWalkTime and CurTime() > wep.MMOD_NextWalkTime) then
				if ply:OnGround() and vel >= crouchspeed and !bool then
				local seqToPlay = vm:LookupSequence("walk")
					if seqToPlay then

						local dur = vm:SequenceDuration(seqToPlay)
						vm:SendViewModelMatchingSequence(seqToPlay)
						wep.MMOD_NextWalkTime = CurTime() + dur

						else return false

						end
					end
				end
			end
		elseif string.lower(seqinfo.label) == "walk" then
			if bool or !ply:OnGround() or vel < crouchspeed or (ply:KeyDown(IN_SPEED) and ply:OnGround() and vel >= 50) then
			local seqToPlay = vm:LookupSequence(ACT_VM_IDLE)
				if seqToPlay then

				local dur = vm:SequenceDuration(seqToPlay)
				vm:SendViewModelMatchingSequence(seqToPlay)
				wep.MMOD_NextWalkTime = CurTime() + 0.25

				else return false

				end
			end
		elseif seqinfo.activityname == "ACT_VM_IDLE_MIDEMPTY" then
			if class == "weapon_ar2" and wep:Clip1() == 1 then
			if (!wep.MMOD_NextWalkTime) or (wep.MMOD_NextWalkTime and CurTime() > wep.MMOD_NextWalkTime) then
				if ply:OnGround() and vel >= crouchspeed and !bool then
					local seqToPlay = vm:LookupSequence("walk_midempty")
						if seqToPlay then

						local dur = vm:SequenceDuration(seqToPlay)
						vm:SendViewModelMatchingSequence(seqToPlay)
						wep.MMOD_NextWalkTime = CurTime() + dur

						else return false

						end
					end
				end
			end
		elseif string.lower(seqinfo.label) == "walk_midempty" then
			if bool or !ply:OnGround() or vel < crouchspeed or (ply:KeyDown(IN_SPEED) and ply:OnGround() and vel >= 50) then
			local seqToPlay = vm:LookupSequence("idle_midempty")
				if seqToPlay then

				local dur = vm:SequenceDuration(seqToPlay)
				vm:SendViewModelMatchingSequence(seqToPlay)
				wep.MMOD_NextWalkTime = CurTime() + 0.25

				else return false

				end
			end
		elseif seqinfo.activityname == "ACT_VM_IDLE_EMPTY" then
			if class == "weapon_ar2" and wep:Clip1() == 0 then
			if (!wep.MMOD_NextWalkTime) or (wep.MMOD_NextWalkTime and CurTime() > wep.MMOD_NextWalkTime) then
				if ply:OnGround() and vel >= crouchspeed and !bool then
					local seqToPlay = vm:LookupSequence("walk_empty")
						if seqToPlay then

						local dur = vm:SequenceDuration(seqToPlay)
						vm:SendViewModelMatchingSequence(seqToPlay)
						wep.MMOD_NextWalkTime = CurTime() + dur

						else return false

						end
					end
				end
			end
		elseif string.lower(seqinfo.label) == "walk_empty" then
			if bool or !ply:OnGround() or vel < crouchspeed or (ply:KeyDown(IN_SPEED) and ply:OnGround() and vel >= 50) then
			local seqToPlay = vm:LookupSequence("idle_empty")
				if seqToPlay then

				local dur = vm:SequenceDuration(seqToPlay)
				vm:SendViewModelMatchingSequence(seqToPlay)
				wep.MMOD_NextWalkTime = CurTime() + 0.25

				else return false

				end
			end
		end
	end)
end

if !game.SinglePlayer() and SERVER then
	local wep, class, vm, bool, seq, seqinfo, vel, crouchspeed, seqToPlay, dur, activityname, label
	
	local string_lower = string.lower
	local CurTime = CurTime
	
	local str_comarsions = {
		['ACT_VM_IDLE'] = 1,
		['sprint'] = 1,
		
		['ACT_VM_IDLE_MIDEMPTY'] = 2,
		['sprint_midempty'] = 2,
		
		['ACT_VM_IDLE_EMPTY'] = 3,
		['sprint_empty'] = 3,
		
		['weapon_ar2'] = 4,
		
		['walk'] = 5,
		['walk_midempty'] = 6,
		['walk_empty'] = 7,
	}
	
	hook.Add("PlayerPostThink", "MMOD_Weapon_Sprint_MP", function(ply)
		if !ply:Alive() then return end

		if ply.MMOD_last_check and ply.MMOD_last_check > CurTime() then return end
		ply.MMOD_last_check = CurTime() + 0.1
		
		wep = ply:GetActiveWeapon()
		if !IsValid(wep) then return end

		class = wep:GetClass()

		vm = ply:GetViewModel()
		if !IsValid(vm) then return end
		
		bool = ply:Crouching()

		seq = vm:GetSequence()
		seqinfo = vm:GetSequenceInfo(seq)

		if not seqinfo then return end
		
		vel = ply:GetVelocity():Length()
		crouchspeed = ply:GetWalkSpeed() * ply:GetCrouchedWalkSpeed() 
		
		activityname = seqinfo.activityname
		label = string_lower(seqinfo.label)
		
		if str_comarsions[activityname] == 1 then
			if str_comarsions[class] == 4 and wep:Clip1() > 1 or sprintableWeapons[class] then
			if (!wep.MMOD_NextSprintTime) or (wep.MMOD_NextSprintTime and CurTime() > wep.MMOD_NextSprintTime) then
				if ply:KeyDown(IN_SPEED) and ply:OnGround() and vel >= crouchspeed and !bool then
					seqToPlay = vm:LookupSequence("sprint")
					if seqToPlay then

						dur = vm:SequenceDuration(seqToPlay)
						wep:SetSaveValue("m_flTimeWeaponIdle", 200)
						vm:SendViewModelMatchingSequence(seqToPlay)
						wep.MMOD_NextSprintTime = CurTime() + dur

						else return false

						end
					end
				end
			end
		elseif str_comarsions[label] == 1 then
			if bool or !ply:KeyDown(IN_SPEED) or !ply:OnGround() or vel < crouchspeed then
			seqToPlay = vm:LookupSequence(ACT_VM_IDLE)
				if seqToPlay then

				dur = vm:SequenceDuration(seqToPlay)
				vm:SendViewModelMatchingSequence(seqToPlay)
				wep.MMOD_NextSprintTime = CurTime() + 0.25

				else return false

				end
			end
		elseif str_comarsions[activityname] == 2 then
			if str_comarsions[class] == 4 and wep:Clip1() == 1 then
			if (!wep.MMOD_NextSprintTime) or (wep.MMOD_NextSprintTime and CurTime() > wep.MMOD_NextSprintTime) then
				if ply:KeyDown(IN_SPEED) and ply:OnGround() and vel >= crouchspeed and !bool then
					seqToPlay = vm:LookupSequence("sprint_midempty")
						if seqToPlay then

						dur = vm:SequenceDuration(seqToPlay)
						wep:SetSaveValue("m_flTimeWeaponIdle", 200)
						vm:SendViewModelMatchingSequence(seqToPlay)
						wep.MMOD_NextSprintTime = CurTime() + dur

						else return false

						end
					end
				end
			end
		elseif str_comarsions[label] == 2 then
			if bool or !ply:KeyDown(IN_SPEED) or !ply:OnGround() or vel < crouchspeed then
			seqToPlay = vm:LookupSequence("idle_midempty")
				if seqToPlay then

				dur = vm:SequenceDuration(seqToPlay)
				vm:SendViewModelMatchingSequence(seqToPlay)
				wep.MMOD_NextSprintTime = CurTime() + 0.25

				else return false

				end
			end
		elseif str_comarsions[activityname] == 3 then
			if str_comarsions[class] == 4 and wep:Clip1() == 0 then
			if (!wep.MMOD_NextSprintTime) or (wep.MMOD_NextSprintTime and CurTime() > wep.MMOD_NextSprintTime) then
				if ply:KeyDown(IN_SPEED) and ply:OnGround() and vel >= crouchspeed and !bool then
					seqToPlay = vm:LookupSequence("sprint_empty")
						if seqToPlay then

						dur = vm:SequenceDuration(seqToPlay)
						wep:SetSaveValue("m_flTimeWeaponIdle", 200)
						vm:SendViewModelMatchingSequence(seqToPlay)
						wep.MMOD_NextSprintTime = CurTime() + dur

						else return false

						end
					end
				end
			end
		elseif str_comarsions[label] == 3 then
			if bool or !ply:KeyDown(IN_SPEED) or !ply:OnGround() or vel < crouchspeed then
			seqToPlay = vm:LookupSequence("idle_empty")
				if seqToPlay then

				dur = vm:SequenceDuration(seqToPlay)
				vm:SendViewModelMatchingSequence(seqToPlay)
				wep.MMOD_NextSprintTime = CurTime() + 0.25

				else return false

				end
			end
		end
	end)

	hook.Add("PlayerPostThink", "MMOD_Weapon_Walk_MP", function(ply)
		if !ply:Alive() then return end

		if ply.MMOD_last_check2 and ply.MMOD_last_check2 > CurTime() then return end
		ply.MMOD_last_check2 = CurTime() + 0.1
		
		wep = ply:GetActiveWeapon()
		if !IsValid(wep) then return end

		class = wep:GetClass()

		vm = ply:GetViewModel()
		if !IsValid(vm) then return end
		
		bool = ply:Crouching()

		seq = vm:GetSequence()
		seqinfo = vm:GetSequenceInfo(seq)

		if not seqinfo then return end
		
		vel = ply:GetVelocity():Length()
		crouchspeed = ply:GetWalkSpeed() * ply:GetCrouchedWalkSpeed()

		activityname = seqinfo.activityname
		label = string_lower(seqinfo.label)
		
		if str_comarsions[activityname] == 1 then
			if str_comarsions[class] == 4 and wep:Clip1() > 1 or sprintableWeapons[class] then
			if (!wep.MMOD_NextWalkTime) or (wep.MMOD_NextWalkTime and CurTime() > wep.MMOD_NextWalkTime) then
				if ply:OnGround() and vel >= crouchspeed and !bool then
					seqToPlay = vm:LookupSequence("walk")
						if seqToPlay then

						dur = vm:SequenceDuration(seqToPlay)
						wep:SetSaveValue("m_flTimeWeaponIdle", 200)
						vm:SendViewModelMatchingSequence(seqToPlay)
						wep.MMOD_NextWalkTime = CurTime() + dur

						else return false

						end
					end
				end
			end
		elseif str_comarsions[activityname] == 5 then
			if bool or !ply:OnGround() or vel < crouchspeed or (ply:KeyDown(IN_SPEED) and ply:OnGround() and vel >= 50) then
			seqToPlay = vm:LookupSequence(ACT_VM_IDLE)
				if seqToPlay then

				dur = vm:SequenceDuration(seqToPlay)
				vm:SendViewModelMatchingSequence(seqToPlay)
				wep.MMOD_NextWalkTime = CurTime() + 0.25

				else return false

				end
			end
		elseif str_comarsions[activityname] == 2 then
			if str_comarsions[class] == 4 and wep:Clip1() == 1 then
				if (!wep.MMOD_NextWalkTime) or (wep.MMOD_NextWalkTime and CurTime() > wep.MMOD_NextWalkTime) then
					if ply:OnGround() and vel >= crouchspeed and !bool then
					seqToPlay = vm:LookupSequence("walk_midempty")
						if seqToPlay then

						dur = vm:SequenceDuration(seqToPlay)
						vm:SendViewModelMatchingSequence(seqToPlay)
						wep.MMOD_NextWalkTime = CurTime() + dur

						else return false

						end
					end
				end
			end
		elseif str_comarsions[activityname] == 6 then
			if bool or !ply:OnGround() or vel < crouchspeed or (ply:KeyDown(IN_SPEED) and ply:OnGround() and vel >= 50) then
			seqToPlay = vm:LookupSequence("idle_midempty")
				if seqToPlay then

				dur = vm:SequenceDuration(seqToPlay)
				vm:SendViewModelMatchingSequence(seqToPlay)
				wep.MMOD_NextWalkTime = CurTime() + 0.25

				else return false

				end
			end
		elseif str_comarsions[activityname] == 3 then
			if str_comarsions[class] == 4 and wep:Clip1() == 0 then
				if (!wep.MMOD_NextWalkTime) or (wep.MMOD_NextWalkTime and CurTime() > wep.MMOD_NextWalkTime) then
					if ply:OnGround() and vel >= crouchspeed and !bool then
					seqToPlay = vm:LookupSequence("walk_empty")
						if seqToPlay then

						dur = vm:SequenceDuration(seqToPlay)
						vm:SendViewModelMatchingSequence(seqToPlay)
						wep.MMOD_NextWalkTime = CurTime() + dur

						else return false

						end
					end
				end
			end
		elseif str_comarsions[activityname] == 7 then
			if bool or !ply:OnGround() or vel < crouchspeed or (ply:KeyDown(IN_SPEED) and ply:OnGround() and vel >= 50) then
			seqToPlay = vm:LookupSequence("idle_empty")
				if seqToPlay then

				dur = vm:SequenceDuration(seqToPlay)
				vm:SendViewModelMatchingSequence(seqToPlay)
				wep.MMOD_NextWalkTime = CurTime() + 0.25

				else return false

				end
			end
		end
	end)
end

if CLIENT then
	CreateClientConVar("mmod_replacements_stopsway", 0, true, false) // you should disable this to support viewmodel lagger and other calcvmview scripts
	CreateClientConVar("mmod_replacements_lense", 1, true, false)
	CreateClientConVar("mmod_replacements_crossbow_overlay", 0, true, false)

	hook.Add("CalcViewModelView", "MMOD_Weapon_StopDefaultSway", function(wep, vm, oldPos, oldAng, pos, ang)
		local ply = wep:GetOwner()
		if sprintableWeapons[wep:GetClass()] and IsValid(ply) and ply:GetVelocity():Length() > 1 and GetConVar("mmod_replacements_stopsway"):GetInt() > 0 then
			local can = true
			local leaning = ply:GetNW2Int("TFALean", 0) != 0 // should work with tfa leaning

			if leaning then can = false end

			if can then
				return oldPos, oldAng
			end
		end
	end)

	local cbScope = Material("vgui/scopes/hl2mmod_scopes_crossbow")

	hook.Add("RenderScreenspaceEffects", "MMOD_Weapon_CrossbowZoomOverlay", function()
		local ply = LocalPlayer()

		local wep = ply:GetActiveWeapon()
		if !IsValid(wep) then return end

		if GetConVar("mmod_replacements_crossbow_overlay"):GetInt() > 0 then
			if ply:Alive() and wep:GetClass() == "weapon_crossbow" then
				if ply:GetFOV() < 25 then // cannot check crossbow's m_bInZoom, because something is broken, so I have to do it this way
					cam.Start2D()
						local w, h = ScrW(), ScrH()

						local start1 = w/2-h/2

						surface.SetDrawColor(255, 255, 255, 255)
						surface.SetMaterial(cbScope)
						surface.DrawTexturedRect(start1, 0, h, h)

						surface.SetDrawColor(0, 0, 0, 255)
						surface.DrawRect(0, 0, start1, h)

						surface.DrawRect(w-start1, 0, w, h)

						surface.DrawRect(-1, -1, w + 2, 2)

						surface.DrawRect(-1, -1, 2, h + 2)
					cam.End2D()
				end
			end
		end
	end)

	local cbLense = Material("models/weapons/v_crossbow/lens")

	local function mmod_replacements_lense_cvar_func(name, oldval, newval)
		if newval == "0" then
			cbLense:SetTexture("$basetexture", "vgui/black")
		elseif newval == "1" then
			cbLense:SetTexture("$basetexture", "_rt_SmallFB1")
		elseif newval == "2" then
			cbLense:SetTexture("$basetexture", "_rt_FullFrameFB")
		end
	end

	cvars.RemoveChangeCallback("mmod_replacements_lense", "mmod_replacements_lense_id")
	cvars.AddChangeCallback("mmod_replacements_lense", mmod_replacements_lense_cvar_func, "mmod_replacements_lense_id")

	hook.Add("InitPostEntity", "MMOD_Weapon_CrossbowLenseConvarInit", function()
		mmod_replacements_lense_cvar_func(nil, nil, GetConVar("mmod_replacements_lense"):GetString())
	end)
end