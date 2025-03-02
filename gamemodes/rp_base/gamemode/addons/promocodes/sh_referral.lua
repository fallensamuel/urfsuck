-- "gamemodes\\rp_base\\gamemode\\addons\\promocodes\\sh_referral.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local PLAYER = FindMetaTable( "Player" );

function PLAYER:GetReferralCode()
    return self.m_Referral_Code or "?";
end

function PLAYER:GetRefereeCount()
    return self.m_Referee_Count or 0;
end

function PLAYER:IsReferredBy()
    return (LocalPlayer().m_Referral_Clients or {})[self] == true;
end

function PLAYER:IsReferee()
    return (LocalPlayer().m_Referral_Clients or {})[self] == false;
end

if SERVER then
    util.AddNetworkString( "rp.Referrals::Code" );
    util.AddNetworkString( "rp.Referrals::Client" );
    util.AddNetworkString( "rp.Referrals::Count" );

    net.Receive( "rp.Referrals::Client", function( len, ply )
        if ply.m_Referral_Initialized then return end
        ply.m_Referral_Initialized = true;

        ply:SendReferralCode( ply.m_Referral_Code or "?" );

        for client, status in pairs( ply.m_Referral_Clients or {} ) do
            ply[status and "SendReferrer" or "SendReferee"]( ply, client );
        end

        ply:SendRefereeCount();
    end );

    function PLAYER:SendReferrer( ply )
        if self.m_Referral_Initialized then
            net.Start( "rp.Referrals::Client", true );
                net.WriteEntity( ply );
                net.WriteBool( true );
            net.Send( self );
        end

        self.m_Referral_Clients = self.m_Referral_Clients or {};
        self.m_Referral_Clients[ply] = true;
    end

    function PLAYER:SendReferee( ply )
        if self.m_Referral_Initialized then
            net.Start( "rp.Referrals::Client", true );
                net.WriteEntity( ply );
            net.Send( self );
        end

        self.m_Referral_Clients = self.m_Referral_Clients or {};
        self.m_Referral_Clients[ply] = false;
    end

    function PLAYER:SendReferralCode( code )
        if self.m_Referral_Initialized then
            net.Start( "rp.Referrals::Code" );
                net.WriteString( code );
            net.Send( self );
        end

        self.m_Referral_Code = code;
    end

    function PLAYER:SendRefereeCount()
        local steamid = self:OwnerSteamID64();

        local client = rp.Referrals.Clients[steamid];
        if client then
            self.m_Referee_Count = #table.GetKeys( client["Referees"] or {} );
        end

        if (self.m_Referee_Count or 0) == 0 then return end

        if self.m_Referral_Initialized then
            net.Start( "rp.Referrals::Count" );
                net.WriteUInt( self.m_Referee_Count, 10 );
            net.Send( self );
        end
    end
end

if CLIENT then
    net.Receive( "rp.Referrals::Code", function()
        LocalPlayer().m_Referral_Code = net.ReadString();
        hook.Run( "OnReferralPromocodeUpdate", LocalPlayer().m_Referral_Code );
    end );

    net.Receive( "rp.Referrals::Client", function()
        local ply, isReferral = net.ReadEntity(), net.ReadBool();

        LocalPlayer().m_Referral_Clients = LocalPlayer().m_Referral_Clients or {};
        LocalPlayer().m_Referral_Clients[ply] = isReferral;
    end );

    net.Receive( "rp.Referrals::Count", function()
        LocalPlayer().m_Referee_Count = net.ReadUInt( 10 );
    end );

    hook.Add( "StartCommand", "rp.Referrals::Sync", function()
        net.Start( "rp.Referrals::Client" ); net.SendToServer();
        hook.Remove( "StartCommand", "rp.Referrals::Sync" );
    end );
end

ba.AddTerm( "SetReferralCode", "# has set #'s refferal code to # #" );

ba.cmd.Create( "Set Ref Code", function( initiator, args )
    local steamid = ba.InfoTo64( args.target );
    if not steamid then return end

    local code = string.Trim( args.code );
    if #code == 0 then return end

    rp.Referrals.SetCode( steamid, code, function( target )
        ba.notify_staff( ba.Term("SetReferralCode"), initiator, target, code );
    end );
end )
:AddParam( "player_steamid", "target" )
:AddParam( "string", "code" )
:SetFlag( "*" )
:SetHelp( "Changes players' referral promocode" )