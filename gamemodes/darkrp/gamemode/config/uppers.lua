-- "gamemodes\\darkrp\\gamemode\\config\\uppers.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
-- Воспрянуть духом:
local ABILITY_RISEUP = CTeamUpgraderAbility( "rise_up", translates.Get("Воспрянуть духом"), "spell/spell_attack" );
ABILITY_RISEUP.MovementModifier = 125;
ABILITY_RISEUP.DamageMultiplier = 1.35;

if CLIENT then
    ABILITY_RISEUP.Overlay = rp.overlays.Overlay( "Ability-RiseUp" )
        :SetFadeIn( 0.5 )
        :SetFadeOut( 0.5 )
        :AddLayer(
            rp.overlays.OverlayLayer("Ability-RiseUp.Vignette")
                :SetMaterial( Material("overlays/vignette_w") )
                :SetOpacity( 0.25 )
                :SetColor( Color(255, 255, 102) )
                :SetPulsation( 3, 0.25 )
        )
end

ABILITY_RISEUP:SetKeybindings( KEY_G, KEY_B, KEY_H, KEY_N, KEY_J, KEY_T );
ABILITY_RISEUP:SetDuration( 15 );
ABILITY_RISEUP:SetRadius( 384 );

ABILITY_RISEUP:SetFilter( function( ability, caller, target )
    return caller:GetAlliance() == target:GetAlliance()
end );

ABILITY_RISEUP:SetOnStart( function( ability, target, caller )
    if target.m_RiseUp then return end
    target.m_RiseUp = true;

    if target == caller then
        target.m_RiseUp_speed = true;
        target:SetRunSpeed( target:GetRunSpeed() + ability.MovementModifier );
        target:SetWalkSpeed( target:GetWalkSpeed() + ability.MovementModifier );
    end
end );

ABILITY_RISEUP:SetOnEnd( function( ability, target, caller )
    target.m_RiseUp = nil;

    if target.m_RiseUp_speed then
        target:SetRunSpeed( target:GetRunSpeed() - ability.MovementModifier );
        target:SetWalkSpeed( target:GetWalkSpeed() - ability.MovementModifier );

        target.m_RiseUp_speed = nil;
    end
end );

ABILITY_RISEUP:SetOnEffectStart( function( ability )
    ABILITY_RISEUP.Overlay:Enable();
end );

ABILITY_RISEUP:SetOnEffectEnd( function( ability )
    ABILITY_RISEUP.Overlay:Disable();
end );

-- Глухая оборона:
local ABILITY_BLINDDEF = CTeamUpgraderAbility( "blind_def", translates.Get("Глухая оборона"), "spell/spell_shield" );
ABILITY_BLINDDEF.MovementModifier = -50;
ABILITY_BLINDDEF.DamageMultiplier = 0.5;

if CLIENT then
    ABILITY_BLINDDEF.Overlay = rp.overlays.Overlay( "Ability-BlindDef" )
        :SetFadeIn( 0.5 )
        :SetFadeOut( 0.5 )
        :AddLayer(
            rp.overlays.OverlayLayer("Ability-BlindDef.Vignette")
                :SetMaterial( Material("overlays/vignette_w") )
                :SetOpacity( 0.25 )
                :SetColor( Color(51, 102, 255) )
                :SetPulsation( 3, 0.25 )
        )
end

ABILITY_BLINDDEF:SetKeybindings( KEY_H, KEY_N, KEY_J, KEY_T );
ABILITY_BLINDDEF:SetDuration( 15 );
ABILITY_BLINDDEF:SetRadius( 512 );

ABILITY_BLINDDEF:SetFilter( function( ability, caller, target )
    return caller:GetAlliance() == target:GetAlliance()
end );

ABILITY_BLINDDEF:SetOnStart( function( ability, target, caller )
    if target.m_BlindDef then return end
    target.m_BlindDef = true;

    target:SetRunSpeed( target:GetRunSpeed() + ability.MovementModifier );
    target:SetWalkSpeed( target:GetWalkSpeed() + ability.MovementModifier );
end );

ABILITY_BLINDDEF:SetOnEnd( function( ability, target, caller )
    if target.m_BlindDef then
        target:SetRunSpeed( target:GetRunSpeed() - ability.MovementModifier );
        target:SetWalkSpeed( target:GetWalkSpeed() - ability.MovementModifier );

        target.m_BlindDef = nil;
    end
end );

ABILITY_BLINDDEF:SetOnEffectStart( function( ability )
    ABILITY_BLINDDEF.Overlay:Enable();
end );

ABILITY_BLINDDEF:SetOnEffectEnd( function( ability )
    ABILITY_BLINDDEF.Overlay:Disable();
end );

--
hook.Add( "EntityTakeDamage", "abilities::EntityTakeDamage", function( target, dmginfo )
    local attacker = dmginfo:GetAttacker();

    if IsValid( attacker ) and attacker.m_RiseUp then
        dmginfo:ScaleDamage( ABILITY_RISEUP.DamageMultiplier );
    end

    if target.m_BlindDef then
        dmginfo:ScaleDamage( ABILITY_BLINDDEF.DamageMultiplier );
    end
end );

local rarity = {
    [1] = "★",
    [2] = "★★",
    [3] = "★★★"
}

if SERVER then
    util.AddNetworkString( "UpdatePointBoxPrintName" );
end

if CLIENT then
    net.Receive( "UpdatePointBoxPrintName", function()
        local point_id = net.ReadUInt( 6 );
        local point = rp.Capture.Points[point_id];
        if not point then return end

        local box_id = net.ReadUInt( 6 );
        local box = point.Boxes and point.Boxes[box_id] or false;
        if not box then return end

        local printName = net.ReadString();
        box:SetPrintName( printName );
    end );
end

hook.Add( "PostTerritoryOwnerChanged", "abilities::ModifySupply", function( point, attackers, defenders, capturers )
    local count = 0;

    for k, ply in ipairs( capturers ) do
        local upgrader = ply:GetUpgraderTable();

        if upgrader and upgrader["officer_supply"] then
            count = count + 1;
        end
    end

    local value = 1 + math.min( count, #rarity );

    for _, box in pairs( point.Boxes or {} ) do
        local changed = false;

        -- Money:
        if box.payment then
            if not box.old_payment then
                box.old_payment = 0 + box.payment;
            end

            changed, box.payment = true, box.old_payment * value;
        end

        -- Ammo:
        if box.add_ammo then
            if not box.old_add_ammo then
                box.old_add_ammo = table.Copy( box.add_ammo );
            end

            changed, box.add_ammo.amount = true, box.old_add_ammo.amount * value;
        end

        -- Ammos:
        if box.add_ammos then
            if not box.old_add_ammos then
                box.old_add_ammos = 0 + box.add_ammos;
            end

            changed, box.add_ammos = true, box.old_add_ammos * value;
        end

        -- Ammos:
        if box.add_armor then
            if not box.old_add_armor then
                box.old_add_armor = 0 + box.add_armor;
            end

            changed, box.add_armor = true, box.old_add_armor * value;
        end

        if changed then
            if not box.old_printName then
                box.old_printName = box.printName;
            end

            box:SetPrintName( rarity[value - 1] and string.format("%s %s", rarity[value - 1], box.old_printName) or box.old_printName );
            net.Start( "UpdatePointBoxPrintName" );
                net.WriteUInt( box.point_id, 6 );
                net.WriteUInt( box.id, 6 );
                net.WriteString( box.printName );
            net.Broadcast();
        end
    end
end );

--
CTeamUpgrader( "officer_support", translates.Get("Офицер поддержки") )
    :AddAbility( ABILITY_RISEUP )
    :AddAbility( ABILITY_BLINDDEF )
    :SetGlobalCooldown( 60 )

CTeamUpgrader( "officer_supply", translates.Get("Офицер снабжения") )