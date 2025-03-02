nw.Register('IsBanned', {
    Read     = net.ReadBool,
    Write    = net.WriteBool,
    LocalVar = true
})

function PLAYER:IsBanned()
	return (self:GetNetVar('IsBanned') == true)
end

if (CLIENT) then

    local MyUnbanTime = MyUnbanTime or -1;

    function PLAYER:UnbanTime()
        local Time = MyUnbanTime;
        if (!Time or Time <= 0) then return '?' end
        Time = string.FormattedTime(Time);
        return ((Time.h <= 9 and ('0' .. Time.h)) or Time.h) .. ':' .. ((Time.m <= 9 and ('0' .. Time.m)) or Time.m) .. ':' .. ((Time.s <= 9 and ('0' .. Time.s)) or Time.s)
    end

    net.Receive('UnbanTime', function(Length)
        MyUnbanTime = net.ReadUInt(32);
    end);

end