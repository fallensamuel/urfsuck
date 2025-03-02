util.AddNetworkString( "net.rp.mood" );

function rp.SetMood(ply, mood, nosave)
	if ply.IsProne and ply:IsProne() then return end
	
    if not nosave then
        if rp.Mood.HoldTypes[mood] then
            ply:SetNetVar( "rp.mood", mood );
        else
            ply:SetNetVar( "rp.mood", PLAYER_MOOD_NORMAL );
        end
    end

    if ply:HasWeapon("keys") then
        ply:GetWeapon("keys"):SetHoldType( rp.Mood.HoldTypes[ply:GetNetVar("rp.mood") or PLAYER_MOOD_NORMAL][1] );
    end

    if ply:HasWeapon("weapon_hands") then
        ply:GetWeapon("weapon_hands"):SetHoldType( rp.Mood.HoldTypes[ply:GetNetVar("rp.mood") or PLAYER_MOOD_NORMAL][1] );
    end
end

net.Receive( "net.rp.mood", function( len, ply )
    if ply.IsProne and ply:IsProne() then return end

    local mood = net.ReadUInt(4);

    rp.SetMood(ply, mood)
end );