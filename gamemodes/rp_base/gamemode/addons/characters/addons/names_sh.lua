-- "gamemodes\\rp_base\\gamemode\\addons\\characters\\addons\\names_sh.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local cfg_prefix = rp.cfg.CharactersPrefix or {};
local cfg_suffix = rp.cfg.CharactersSuffix or {};
local PLAYER = FindMetaTable( "Player" );


----------------------------------------------------------------
nw.Register( "NamePrefix" )
	:Write( net.WriteString )
	:Read( net.ReadString )
	:SetPlayer()

nw.Register( "NameSuffix" )
	:Write( net.WriteString )
	:Read( net.ReadString )
	:SetPlayer()


----------------------------------------------------------------
function PLAYER:GetNamePrefix()
    return self:GetNetVar( "NamePrefix" );
end

function PLAYER:GetNameSuffix()
    return self:GetNetVar( "NameSuffix" );
end


----------------------------------------------------------------
if (not cfg_prefix.disabled) or (not cfg_suffix.disabled) then
    function PLAYER:Name()
        if not IsValid( self ) then
            return "NOT LOADED"
        end

        local prefix = self:GetNamePrefix();
        local suffix = self:GetNameSuffix();
        local name   = self:GetNetVar( "Name" ) or self:SteamName();

        return (prefix and prefix .. " " or "") .. name .. (suffix and " " .. suffix or "")
    end

    PLAYER.Nick = PLAYER.Name;
    PLAYER.GetName = PLAYER.Name;
end


----------------------------------------------------------------
if rp.cfg.EnableCharacters then
    local cat = translates.Get("Roleplay");

    if not cfg_prefix.disabled then
        ba.AddTerm( "AdminResetPlayerPrefix", "# сбросил префикс #." );
        ba.AddTerm( "AdminResetYourPrefix", "# сбросил ваш префикс." );
    
        ba.cmd.Create( "Reset Prefix", function( pl, args )
            local target = args.target;
            if not IsValid( target ) then return end
    
            ba.notify_staff( ba.Term("AdminResetPlayerPrefix"), pl, target );
            target:SetNamePrefix();
            ba.notify( target, ba.Term("AdminResetYourPrefix"), pl );
        end )
        :AddParam( "player_entity", "target" )
        :SetFlag( "A" )
        :SetHelp( "Clears players' name prefix" )
        :AddAlias( "clearprefix" )

        if CLIENT then
            rp.AddMenuCommand( cat, translates.Get("Сменить префикс"),
                function()
                    rp.CloseF4Menu();
                    
                    local cfg, desc = (rp.cfg.CharactersPrefix or {}), translates.Get("Введите новый префикс:");
                    local req = cfg.pretty or cfg.pattern;
                    desc = req and string.format( "%s (" .. translates.Get("шаблон") .. ": \"%s\")", desc, req ) or string.format( "%s (" .. translates.Get("макс. длина") .. ": 8)", desc );

                    rpui.StringRequest( translates.Get("СМЕНА ПРЕФИКСА"), desc, "scoreboard/usergroups/admin.png", 1.6, function( self, str )
                        RunConsoleCommand( "rp", "prefix", str );
                    end );
                end,

                function()
                    return LocalPlayer().GetNamePrefix and true or false
                end,
            "2722001034" );
        end
    end

    if not cfg_suffix.disabled then
        ba.AddTerm( "AdminResetPlayerSuffix", "# сбросил постфикс #." );
        ba.AddTerm( "AdminResetYourSuffix", "# сбросил ваш постфикс." );

        ba.cmd.Create( "Reset Postfix", function( pl, args )
            local target = args.target;
            if not IsValid( target ) then return end

            ba.notify_staff( ba.Term("AdminResetPlayerSuffix"), pl, target );
            target:SetNameSuffix();
            ba.notify( target, ba.Term("AdminResetYourSuffix"), pl );
        end )
        :AddParam( "player_entity", "target" )
        :SetFlag( "A" )
        :SetHelp( "Clears players' name postfix" )
        :AddAlias( "clearpostfix" )

        if CLIENT then
            rp.AddMenuCommand( cat, translates.Get("Сменить постфикс"),
                function()
                    rp.CloseF4Menu();
                    
                    local cfg, desc = (rp.cfg.CharactersSuffix or {}), translates.Get("Введите новый постфикс:");
                    local req = cfg.pretty or cfg.pattern;
                    desc = req and string.format( "%s (" .. translates.Get("шаблон") .. ": \"%s\")", desc, req ) or string.format( "%s (" .. translates.Get("макс. длина") .. ": 8)", desc );

                    rpui.StringRequest( translates.Get("СМЕНА ПОСТФИКСА"), desc, "scoreboard/usergroups/admin.png", 1.6, function( self, str )
                        RunConsoleCommand( "rp", "suffix", str );
                    end );
                end,

                function()
                    return LocalPlayer().GetNameSuffix and true or false
                end,
            "2722001034" );
        end
    end
end