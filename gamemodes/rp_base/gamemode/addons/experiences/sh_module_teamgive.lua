-- "gamemodes\\rp_base\\gamemode\\addons\\experiences\\sh_module_teamgive.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local PLAYER = FindMetaTable( "Player" );

function PLAYER:GetGiveExperienceCooldown( radius )
    return self[radius and "fl_expGiveCooldown" or "fl_expGiveCooldownSolo"] or 0;
end

function PLAYER:SetGiveExperienceCooldown( t, radius )
    radius = tobool( radius );

    local cd = radius and "fl_expGiveCooldown" or "fl_expGiveCooldownSolo";
    self[cd] = t;

    if SERVER then
        net.Start( "rp.Experiences::GiveExperienceTeamed" );
            net.WriteFloat( self[cd] );
            net.WriteBool( radius );
        net.Send( self );
    end
end

function PLAYER:CanGiveExperience( target )
    local jt = self:GetJobTable() or {};

    if not isnumber( jt.expGiveAmount or jt.expGiveAmountSolo ) then
        return false;
    end

    if not IsValid( target ) then
        return true;
    end

    if not target:IsPlayer() then
        return false;
    end

    if not istable( jt.expGiveFaction ) and not istable( jt.expGiveFactionSolo ) then
        return true;
    end

    return tobool( jt.expGiveFaction[target:GetFaction()] or jt.expGiveFactionSolo[target:GetFaction()] );
end

if SERVER then
    util.AddNetworkString( "rp.Experiences::GiveExperienceTeamed" );

    net.Receive( "rp.Experiences::GiveExperienceTeamed", function( len, ply )
        local t = CurTime();
        if (ply.fl_net_ExperienceTeamed or 0) > t then return end
        ply.fl_net_ExperienceTeamed = t + 0.5;

        local target = net.ReadEntity();
        local radius = not target:IsValid();

        local cd = ply:GetGiveExperienceCooldown( radius );
        if cd > t then
            rp.Notify( ply, NOTIFY_GENERIC, translates.Get("Вы сможете выдать опыт через %i секунд", math.ceil(cd - t)) );
            return
        end

        local jt = ply:GetJobTable();
        local amount, cooldown = jt.expGiveAmount or 0, jt.expGiveCooldown or 1;
        local reason = "TeamGiven by " .. ply:GetName() .. "(" .. ply:SteamID() .. ")";
        local filter = jt.expGiveFaction;

        if not radius then
            local exp_id = rp.Experiences:GetExperienceID( target );
            if not exp_id then return end

            if ply:GetPos():DistToSqr( target:GetPos() ) > math.pow( 256, 2 ) then
                rp.Notify( ply, NOTIFY_ERROR, translates.Get("Игрок слишком далеко!") );
                return
            end

            if isnumber( jt.expGiveAmountSolo ) then
                amount = jt.expGiveAmountSolo;
            end

            if isnumber( jt.expGiveCooldownSolo ) then
                cooldown = jt.expGiveCooldownSolo;
            end

            if istable( jt.expGiveFactionSolo ) then
                filter = jt.expGiveFactionSolo;
            end

            local mul = filter and tonumber( filter[target:GetFaction()] or 0 ) or 1;
            local amt = math.Round( amount * mul );

            if amt > 0 then
                rp.Experiences:AddExperience( target:SteamID64(), exp_id, amt, reason );
                rp.Notify( target, NOTIFY_GENERIC, translates.Get("Вам выдали %i опыта", amt) );

                rp.Notify( ply, NOTIFY_GENERIC, translates.Get("Вы выдали %i опыта игроку %s", amt, target:GetName()) );
            end
        else
            for k, target in ipairs( ents.FindInSphere(ply:GetPos(), 512) ) do
                if not target:IsPlayer() then continue end
                if target == ply then continue end

                local exp_id = rp.Experiences:GetExperienceID( target );
                if not exp_id then continue end

                local mul = filter and tonumber( filter[target:GetFaction()] or 0 ) or 1;
                local amt = math.Round( amount * mul );

                if amt > 0 then
                    rp.Experiences:AddExperience( target:SteamID64(), exp_id, amt, reason );
                    rp.Notify( target, NOTIFY_GENERIC, translates.Get("Вам выдали %i опыта", amt) );
                end
            end

            rp.Notify( ply, NOTIFY_GENERIC, translates.Get("Вы выдали опыт игрокам возле себя") );
        end

        ply:SetGiveExperienceCooldown( t + cooldown, radius );
    end );
end

if CLIENT then
    net.Receive( "rp.Experiences::GiveExperienceTeamed", function()
        LocalPlayer():SetGiveExperienceCooldown( net.ReadFloat(), net.ReadBool() );
    end );

    hook.Add( "ConfigLoaded", "rp.Experiences::GiveExperienceTeamed", function()
        rp.cfg.AdditionalIteractButtons = rp.cfg.AdditionalIteractButtons or {};

        table.insert( rp.cfg.AdditionalIteractButtons, {
            color = color_white,

            text = function( ply )
                local jt = LocalPlayer():GetJobTable();

                local filter = jt.expGiveFaction;
                local mul = filter and tonumber( filter[ply:GetFaction()] or 0 ) or 1;
                local amt = math.Round( jt.expGiveAmount * mul );

                return translates.Get( "Выдать %i опыта", amt );
            end,

            material = Material( "ping_system/giveexp.png", "smooth noclamp" ),

            func = function( ply, pnl )
                net.Start( "rp.Experiences::GiveExperienceTeamed" );
                    net.WriteEntity( pnl.SelectedPlayer );
                net.SendToServer();
            end,

            access = function( initiator, target )
                return initiator:CanGiveExperience( target ) and rp.Experiences:GetExperienceID( target );
            end
        } );

        rp.AddContextCommand( translates.Get( "Действия" ), translates.Get( "Выдать опыт" ),
            function( p )
                net.Start( "rp.Experiences::GiveExperienceTeamed" );
                    net.WriteEntity( NULL );
                net.SendToServer();
            end,
            function()
                return LocalPlayer():CanGiveExperience();
            end,
        "cmenu/addexp.png");
    end );
end