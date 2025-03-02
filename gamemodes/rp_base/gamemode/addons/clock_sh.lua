local TIME_REAL_MINS_IN_GAME_HR = 4

function rp.GetTime()
    local time_all = string.FormattedTime(CurTime() * 60 / TIME_REAL_MINS_IN_GAME_HR)
    return time_all.h % 24, time_all.m
end

function rp.GetTimeFormat()
    return string.format("%02i:%02i", rp.GetTime())
end