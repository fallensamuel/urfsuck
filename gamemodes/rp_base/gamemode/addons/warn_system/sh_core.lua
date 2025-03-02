-- "gamemodes\\rp_base\\gamemode\\addons\\warn_system\\sh_core.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
ba.AddTerm( "WarnSystem.Success", "Вы выдали предупреждение игроку с ником #!" );
ba.AddTerm( "WarnSystem.NewCount", "Теперь у него # предупреждений!" );
ba.AddTerm( "WarnSystem.CurCount", "У него # предупреждений!" );
ba.AddTerm( "WarnSystem.ItsTime2Ban", "Время забанить проказника, у него 3 или более предупреждений!" );
ba.AddTerm( "WarnSystem.New", "Вы получили предупреждение от #!" );
ba.AddTerm( "WarnSystem.NewPly", "# получил предупреждение от # по причине #!" );
ba.AddTerm( "WarnSystem.UnPly", "# снял предупреждение с #!" );

ba.cmd.Create( "warn", function( ply, args )
    ba.bans.IsAllowedBan( ply, args.target, function( status )
        if not status then
            ba.notify( initiator, ba.Term("SameWeight") );
            return;
        end

		local initiator, target, reason, steamid64 = ply:GetName(), args.target:GetName(), args.reason, args.target:SteamID64();

		args.target:AddWarn( function( count )
			if count >= 3 then
				ba.notify( ply, ba.Term("WarnSystem.ItsTime2Ban") );

				net.Start( "WarnSystem" );
					net.WriteString( steamid64 );
				net.Send( ply );
			else
				ba.notify( ply, ba.Term("WarnSystem.CurCount"), count );
			end

			if IsValid( args.target ) then
				ba.notify( args.target, ba.Term("WarnSystem.New"), initiator );
			end

			ba.notify_staff( ba.Term("WarnSystem.NewPly"), initiator, target, args.reason );
		end );
	end );
end )
:AddParam( "player_entity", "target" )
:AddParam( "string", "reason" )
:SetFlag( "M" )
:SetHelp( "Gives warn to a target" )

ba.cmd.Create( "unwarn", function( ply, args )
	ba.bans.IsAllowedBan( ply, args.target, function( status )
        if not status then
            ba.notify( initiator, ba.Term("SameWeight") );
            return;
        end

		local initiator, target, reason = ply:GetName(), args.target:GetName(), args.reason;

		args.target:TakeWarn( function( count )
			if IsValid( ply ) then
				ba.notify( ply, ba.Term("WarnSystem.Success"), target );
				ba.notify( ply, ba.Term("WarnSystem.CurCount"), count );
			end

			if IsValid( args.target ) then
				ba.notify( args.target, ba.Term("WarnSystem.New"), initiator );
			end

			ba.notify_staff( ba.Term("WarnSystem.UnPly"), initiator, target );
		end );
	end );
end )
:AddParam( "player_entity", "target" )
:AddParam( "string", "reason" )
:SetFlag( "M" )
:SetHelp( "Removes warn from a target" )

ba.cmd.Create( "getwarns", function( ply, args )
	ba.bans.IsAllowedBan( ply, args.target, function( status )
        if not status then
            ba.notify( initiator, ba.Term("SameWeight") );
            return;
        end

		args.target:GetWarns( function( count )
			ba.notify( ply, ba.Term("WarnSystem.CurCount"), count );
		end );
	end );
end )
:AddParam( "player_entity", "target" )
:SetFlag( "M" )
:SetHelp( "Shows warns of a target" )

ba.cmd.Create( "warnban", function( initiator, args )
    ba.bans.IsAllowedBan( ply, args.target, function( status )
        if not status then
            ba.notify( initiator, ba.Term("SameWeight") );
            return;
        end

        args.target:GetWarns( function( count )
            if not IsValid( initiator ) then return end
            if count < 3 then return end
            ba.bans.commands["ban"]( initiator, args );
        end );
    end );
end )
:AddParam( "player_entity", "target" )
:AddParam( "time", "length" )
:AddParam( "string", "reason" )
:SetFlag( "M" )
:SetHelp( "Bans your target from the server after 3 warns" )
