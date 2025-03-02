util.AddNetworkString("urf.im/addons/confiscation")

local Sounds = {
    "player/footsteps/sand1.wav",
    "player/footsteps/sand2.wav",
}

local Sounds2 = {}

for i = 1, 6 do
    table.insert(Sounds2, "npc/combine_soldier/gear".. i ..".wav")
end

local function StartConfiscation(actor, target)
    local t_name = actor:SteamID64() .."_confiscation_".. target:SteamID64()
    if timer.Exists(t_name) then return end

    print("StartConfiscation", actor, target)
    local c_time = rp.GetConfiscationTime(actor)

    target.Confiscate = target.Confiscate or {}
    target.Confiscate[actor:SteamID()] = CurTime() + c_time
    net.Start("urf.im/addons/confiscation")
        net.WriteEntity(target)
    net.Send(actor)

    local stopConfiscation = false
    local timerStop = function()
        timer.Remove(t_name)
        stopConfiscation = true
    end
    timer.Create(t_name, 0, 0, function()
        if IsValid(actor) == false or IsValid(target) == false then timerStop() return end
        local trent = actor:GetEyeTrace().Entity
        if IsValid(trent) == false or trent ~= target then timerStop() end
    end)

    actor:EmitSound(Sounds2[math.random(1, 6)])
    timer.Create(t_name.."_snd", 1, c_time - 1, function()
    	if stopConfiscation then timer.Remove(t_name.."_snd") return end
    	if IsValid(actor) then 
    		actor:EmitSound(Sounds2[math.random(1, 6)])
    	end
    end)

    timer.Simple(c_time, function()
        if stopConfiscation then return end
        timer.Remove(t_name)

        actor:EmitSound(Sounds[math.random(1, 2)])

        actor.Confiscation = target
        net.Start("urf.im/addons/confiscation")
	    net.Send(actor)
    end)
end

concommand.Add("confiscation", function(ply, cmd, args)
    local target = ply:GetEyeTrace().Entity
    if IsValid(target) == false or target:IsPlayer() == false or not target:CanConfiscateBy(ply) then return end
    if ply:IsCP() or ply:GetJobTable().CanConfiscate then
        StartConfiscation(ply, target)
    end
end)

net.Receive("urf.im/addons/confiscation", function(len, ply)
	if ply.ProcessingConfiscation or not IsValid(ply.Confiscation) then return end
	local pos = net.ReadUInt(6)
	if not pos then return end

	local wep = ply.Confiscation:GetWeapons()[pos]
	if not IsValid(wep) then return end

	local class = wep:GetClass()
	local price = rp.cfg.ConfiscationWeapons[class]
	if not price or not IsValid(wep:GetOwner()) or not wep:GetOwner():IsPlayer() or not wep:GetOwner():CanConfiscateBy(ply) then return end

	ply:EmitSound(Sounds2[math.random(1, 6)])
	ply.ProcessingConfiscation = true
	timer.Simple(1, function()
		if not IsValid(ply) then return end
		ply.ProcessingConfiscation = nil
		if not IsValid(wep) or not IsValid(wep:GetOwner()) then return end

		wep:GetOwner():StripWeapon(class)
		ply:AddMoney(price)
		ply:EmitSound(Sounds[math.random(1, 2)])
	end)
end)