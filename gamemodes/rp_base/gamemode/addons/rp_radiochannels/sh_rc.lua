-- "gamemodes\\rp_base\\gamemode\\addons\\rp_radiochannels\\sh_rc.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
﻿local nw_Register = nw.Register
local table_Copy = table.Copy
local table_Add = table.Add

rp.RadioSpeakers = {}
rp.RadioTitles = {}
rp.RadioFrequencyAccess = {}

nw_Register("RC_RadioOnSpeak")
    :Write(net.WriteBool)
    :Read(net.ReadBool)
    :SetPlayer()

nw_Register("RC_RadioOnHear")
    :Write(net.WriteBool)
    :Read(net.ReadBool)
    :SetPlayer()

nw_Register("RC_RadioChannel")
    :Write(net.WriteUInt, 7)
    :Read(net.ReadUInt, 7)
    :SetPlayer()

nw_Register("RC_RadioFrequency")
    :Write(net.WriteUInt, 14)
    :Read(net.ReadUInt, 14)
    :SetPlayer()

function rp.AddToRadioFrequency(teams)
    if not teams then return end
    if not istable(teams) then return end

    for _, team in ipairs(teams) do
        rp.RadioFrequencyAccess[team] = true
    end
end

function rp.AddToRadioChannel(chan_id, chan_name, can_speak, can_hear)
    if not chan_id or not isnumber(chan_id) then return end
    if not chan_name or not isstring(chan_name) then return end
    if not can_speak or #can_speak == 0 then return end
    can_hear = table_Copy(can_hear or {})

    local speakers = table_Copy(can_speak)
    table_Add(can_hear, can_speak)

    if not rp.RadioTitles[chan_id] then
        rp.RadioTitles[chan_id] = chan_name
    end

    for i = 1, #can_hear do
        for j = 1, #speakers do
            rp.RadioSpeakers[speakers[j]] = rp.RadioSpeakers[speakers[j]] or {}
            rp.RadioSpeakers[speakers[j]][chan_id] = true

            rp.RadioChanels[can_hear[i]] = rp.RadioChanels[can_hear[i]] or {}
            rp.RadioChanels[can_hear[i]][chan_id] = rp.RadioChanels[can_hear[i]][chan_id] or {}
            rp.RadioChanels[can_hear[i]][chan_id][speakers[j]] = true
        end
    end
end