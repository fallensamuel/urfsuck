hook.Add("DeathMechanics.OnEndHeal", "MedicAwards", function(doctor, patient)
    local jtab = doctor:GetJobTable()
    if not jtab.IsMedic then return end
    if jtab.RescueFactions and not jtab.RescueFactions[patient:GetFaction()] then return end
    if not jtab.RescueReward then return end
    if not doctor.MedicAwards then doctor.MedicAwards = {} end

    local sid = patient:SteamID64()
    if doctor.MedicAwards[sid] then return end
    doctor.MedicAwards[sid] = true
    timer.Simple(60, function() doctor.MedicAwards[sid] = nil end)

    doctor:AddMoney(jtab.RescueReward)
end)

hook.Add("DeathMechanics.StartHealGetTime", "MedicFastHeal", function(doctor)
    local t = doctor:GetJobTable().DmHealTime
    if t then return t end
end)