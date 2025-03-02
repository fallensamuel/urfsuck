-- "gamemodes\\rp_base\\gamemode\\addons\\experiences\\sh_core.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
----------------------------------------------------------------
rp.Experiences = rp.Experiences or {};

----------------------------------------------------------------
function rp.Experiences:GetExperienceID( ply )
    return hook.Run( "PlayerExperienceID", ply and ply or (SERVER and ply or LocalPlayer()) );
end

----------------------------------------------------------------
ba.AddTerm( "AdminAddedExperience", "# выдал # # опыта #." );
ba.AddTerm( "AdminAddedYourExperience", "# выдал # опыта # на твой аккаунт." );

ba.cmd.Create( "Add Experience", function( ply, args )
    local steamid64 = IsValid( args.target ) and args.target:SteamID64() or util.SteamIDTo64( args.target );
    if steamid64 == "0" then
        return
    end

    local amount = tonumber( args.amount );
    if not amount then
        return
    end

    rp.Experiences:AddExperience( steamid64, args.id, amount, "Given by " .. (ply:IsValid() and (ply:GetName() .. "(" .. ply:SteamID() .. ")") or "CONSOLE"), function()
        if IsValid( args.target ) then
            ba.notify( args.target, ba.Term("AdminAddedYourExperience"), ply, amount, args.id );
        end

        ba.notify_staff( ba.Term("AdminAddedExperience"), ply, args.target, amount, args.id );
    end );
end )
:AddParam( "player_steamid", "target" )
:AddParam( "string", "id" )
:AddParam( "string", "amount" )
:SetFlag( "*" )
:SetHelp( "Gives a player experience" )
