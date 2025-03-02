-- "gamemodes\\rp_base\\gamemode\\addons\\animationpacks\\sh_init.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
AnimationPacks = AnimationPacks or {};


----------------------------------------------------------------
AnimationPacks.Map = {};
AnimationPacks.List = {};

AnimationPacks.IgnoredWeapons = {
    ["keys"] = true,
};


----------------------------------------------------------------
nw.Register( "animpack" )
    :Write( net.WriteUInt, 5 )
    :Read( net.ReadUInt, 5 )
    :SetPlayer()
    --:SetHook( "AnimationPackChanged" )

nw.Register( "animpack-holdtype" )
    :Write( net.WriteString )
    :Read( net.ReadString )
    :SetPlayer()
    :SetHook( "PlayerAnimPackHoldType" )


----------------------------------------------------------------
AnimationPacks.GetTable = function()
    return AnimationPacks.List;
end


----------------------------------------------------------------
AnimationPacks.Get = function( id )
    id = isnumber(id) and AnimationPacks.Map[id] or id;
    return AnimationPacks.List[id];
end


----------------------------------------------------------------
AnimationPacks.Register = function( id, animpack, name, desc, check )
    if table.Count(animpack) == 0 then
        error( string.format("Trying to register an empty AnimationPack! (%s)", id) ); 
    end

    if AnimationPacks.Get(id) then
        error( string.format("Trying to register already existing AnimationPack! (%s)", id) );
    end

    local C_AnimationPack = {};

    C_AnimationPack.UID          = table.insert( AnimationPacks.Map, id );
    C_AnimationPack.HoldType     = "animpack-" .. id;
    C_AnimationPack.Name         = name or id;
    C_AnimationPack.Desc         = desc or "N/A";
    C_AnimationPack.Animations   = animpack;
    C_AnimationPack.Translations = {};
    C_AnimationPack.CustomCheck  = isfunction(check) and check or function() return true end;

    local DefaultSequences = C_AnimationPack.Animations["default"] or {};

    --[[
    for TargetHoldType, TargetSequences in pairs( C_AnimationPack.Animations ) do
        if not wOS.AnimExtension.ActIndex[TargetHoldType] then continue end

        local DATA = {};

        DATA.Name         = C_AnimationPack.Name .. ": " .. TargetHoldType;
        DATA.HoldType     = C_AnimationPack.HoldType .. "." .. TargetHoldType;
        DATA.BaseHoldType = TargetHoldType;
        DATA.Translations = {};

        DATA.Translations[ACT_MP_STAND_IDLE] = TargetSequences[ACT_MP_STAND_IDLE] or DefaultSequences[ACT_MP_STAND_IDLE];
        DATA.Translations[ACT_MP_WALK] = TargetSequences[ACT_MP_WALK] or DefaultSequences[ACT_MP_WALK];
        DATA.Translations[ACT_MP_RUN] = TargetSequences[ACT_MP_RUN] or DefaultSequences[ACT_MP_RUN];
        DATA.Translations[ACT_MP_CROUCH_IDLE] = TargetSequences[ACT_MP_CROUCH_IDLE] or DefaultSequences[ACT_MP_CROUCH_IDLE];
        DATA.Translations[ACT_MP_CROUCHWALK] = TargetSequences[ACT_MP_CROUCHWALK] or DefaultSequences[ACT_MP_CROUCHWALK];
        DATA.Translations[ACT_MP_ATTACK_STAND_PRIMARYFIRE] = TargetSequences[ACT_MP_ATTACK_STAND_PRIMARYFIRE] or DefaultSequences[ACT_MP_ATTACK_STAND_PRIMARYFIRE];
        DATA.Translations[ACT_MP_ATTACK_CROUCH_PRIMARYFIRE] = TargetSequences[ACT_MP_ATTACK_CROUCH_PRIMARYFIRE] or DefaultSequences[ACT_MP_ATTACK_CROUCH_PRIMARYFIRE];
        DATA.Translations[ACT_MP_RELOAD_STAND] = TargetSequences[ACT_MP_RELOAD_STAND] or DefaultSequences[ACT_MP_RELOAD_STAND];
        DATA.Translations[ACT_MP_RELOAD_CROUCH] = TargetSequences[ACT_MP_RELOAD_CROUCH] or DefaultSequences[ACT_MP_RELOAD_CROUCH];
        DATA.Translations[ACT_MP_JUMP] = TargetSequences[ACT_MP_JUMP] or DefaultSequences[ACT_MP_JUMP];
        DATA.Translations[ACT_MP_SWIM] = TargetSequences[ACT_MP_SWIM] or DefaultSequences[ACT_MP_SWIM];
        DATA.Translations[ACT_LAND] = TargetSequences[ACT_LAND] or DefaultSequences[ACT_LAND];
        
        wOS.AnimExtension:RegisterHoldtype( DATA );
        C_AnimationPack.Translations[TargetHoldType] = DATA.HoldType;
    end
    ]]--

    for TargetHoldType in pairs( wOS.AnimExtension.ActIndex ) do
        local TargetSequences = C_AnimationPack.Animations[TargetHoldType] or {};

        local DATA = {};
        DATA.Translations = {};

        DATA.Translations[ACT_MP_STAND_IDLE] = TargetSequences[ACT_MP_STAND_IDLE] or DefaultSequences[ACT_MP_STAND_IDLE];
        DATA.Translations[ACT_MP_WALK] = TargetSequences[ACT_MP_WALK] or DefaultSequences[ACT_MP_WALK];
        DATA.Translations[ACT_MP_RUN] = TargetSequences[ACT_MP_RUN] or DefaultSequences[ACT_MP_RUN];
        DATA.Translations[ACT_MP_CROUCH_IDLE] = TargetSequences[ACT_MP_CROUCH_IDLE] or DefaultSequences[ACT_MP_CROUCH_IDLE];
        DATA.Translations[ACT_MP_CROUCHWALK] = TargetSequences[ACT_MP_CROUCHWALK] or DefaultSequences[ACT_MP_CROUCHWALK];
        DATA.Translations[ACT_MP_ATTACK_STAND_PRIMARYFIRE] = TargetSequences[ACT_MP_ATTACK_STAND_PRIMARYFIRE] or DefaultSequences[ACT_MP_ATTACK_STAND_PRIMARYFIRE];
        DATA.Translations[ACT_MP_ATTACK_CROUCH_PRIMARYFIRE] = TargetSequences[ACT_MP_ATTACK_CROUCH_PRIMARYFIRE] or DefaultSequences[ACT_MP_ATTACK_CROUCH_PRIMARYFIRE];
        DATA.Translations[ACT_MP_RELOAD_STAND] = TargetSequences[ACT_MP_RELOAD_STAND] or DefaultSequences[ACT_MP_RELOAD_STAND];
        DATA.Translations[ACT_MP_RELOAD_CROUCH] = TargetSequences[ACT_MP_RELOAD_CROUCH] or DefaultSequences[ACT_MP_RELOAD_CROUCH];
        DATA.Translations[ACT_MP_JUMP] = TargetSequences[ACT_MP_JUMP] or DefaultSequences[ACT_MP_JUMP];
        DATA.Translations[ACT_MP_SWIM] = TargetSequences[ACT_MP_SWIM] or DefaultSequences[ACT_MP_SWIM];
        DATA.Translations[ACT_LAND] = TargetSequences[ACT_LAND] or DefaultSequences[ACT_LAND];
        
        if table.Count( DATA.Translations ) > 0 then
            DATA.Name         = C_AnimationPack.Name .. " (" .. TargetHoldType .. ")";
            DATA.HoldType     = C_AnimationPack.HoldType .. "." .. TargetHoldType;
            DATA.BaseHoldType = TargetHoldType;
            
            wOS.AnimExtension:RegisterHoldtype( DATA );
            C_AnimationPack.Translations[TargetHoldType] = DATA.HoldType;
        end
    end

    C_AnimationPack.Animations = nil;

    AnimationPacks.List[id] = C_AnimationPack;
end


----------------------------------------------------------------
local PLAYER = FindMetaTable( "Player" );

function PLAYER:GetAnimationPack()
    return self:GetNetVar( "animpack" ) or 0;
end

function PLAYER:GetAnimPack()
    return self:GetAnimationPack();
end