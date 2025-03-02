-- "gamemodes\\rp_base\\gamemode\\main\\cosmetics\\accessories_cl.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
rp.Accessories = rp.Accessories or {};

rp.Accessories.RenderCache = {};

-- cvar: -------------------------------------------------------
cvar.Register( "enable_accessories_render" )
    :SetDefault( true )
    :AddMetadata( "State", "RPMenu" )
    :AddMetadata( "Menu", "Включить отображение аксессуаров" )

-- DefaultRenderer: --------------------------------------------
-- TODO: Find a better way to handle :SetNoDraw() and one-time functions, maybe some initialization step?
local vector_hidden = Vector( 0, 0, -32768 );

rp.Accessories.GetClientsideModel = function( ent )
    local cache = rp.Accessories.RenderCache;

    local cv = cvar.Get( "enable_accessories_render" );
    if not cv or not cv.Value then
        if IsValid( cache[ent] ) then
            cache[ent]:SetNoDraw( true );
        end

        return
    end

    cache[ent] = cache[ent] or ClientsideModel( "models/error.mdl", RENDERGROUP_BOTH );
    return cache[ent];
end

rp.Accessories.NoRenderer = function( ent, uid )
end

rp.Accessories.DefaultRenderer = function( ent, uid )
    local data = rp.Accessories.List[uid];
    if not data then return end
    
    local csmdl = rp.Accessories.GetClientsideModel(ent);
    if not IsValid(csmdl) then return end

    if ent:IsPlayer() then
        if data.can_wear and (not data.can_wear(ent)) then
            csmdl:SetNoDraw( true );
            return
        end
    end

    csmdl:SetNoDraw( false );

    local pos, ang = vector_origin, angle_zero;

    if data.attachment then
        local attach_id = ent:LookupAttachment( data.attachment );
        if not attach_id then return end

        local attach = ent:GetAttachment( attach_id );
        if not attach then return end

        pos, ang = attach.Pos, attach.Ang;
    else
        local bone_id = ent:LookupBone( data.bone );
        if not bone_id then return end
        
        pos, ang = ent:GetBonePosition( bone_id );
    end

    csmdl, pos, ang = data:modifyClientsideModel( ent, csmdl, pos, ang );

    if csmdl:GetModel() ~= data.__r_model then
        csmdl:SetModel( data.__r_model );
    end

    if csmdl:GetSkin() ~= data.__r_model then
        csmdl:SetSkin( data.__r_skin or 0 );
    end

    if csmdl:GetModelScale() ~= data.scale then
        csmdl:SetModelScale( data.scale, 0 );
    end

    csmdl:SetPos( pos );
    csmdl:SetAngles( ang );
    csmdl:SetRenderOrigin( pos );
    csmdl:SetRenderAngles( ang );
    csmdl:SetupBones();
    csmdl:DrawModel();
    csmdl:SetRenderOrigin( vector_hidden );
end

-- Hooks: ------------------------------------------------------
hook.Add( "PostPlayerDraw", "rp.Accessories::PostPlayerDraw", function( ply )
    if not ply:Alive() then return end
    if ply:IsDormant() then return end

    if ply == LocalPlayer() then
        if not ply:ShouldDrawLocalPlayer() then return end
    else
        if not ply.IsCurrentlyVisible then return end
    end

    for uid, active in pairs( ply:GetAccessories() ) do
        if not active then continue end
        (rp.Accessories.List[uid].__renderer or rp.Accessories.DefaultRenderer)( ply, uid );
    end
end );

hook.Add( "Think", "rp.Accessories::GarbageCollection", function()
    for k, v in pairs( rp.Accessories.RenderCache ) do
        if IsValid( k ) then
            if k:IsPlayer() then
                if k:Alive() and k:IsWearingAccessories() then
                    if k == LocalPlayer() then
                        if k:ShouldDrawLocalPlayer() then continue end
                    else
                        if k.IsCurrentlyVisible then continue end
                    end
                end
            else return end
        end

        v:Remove();
        rp.Accessories.RenderCache[k] = nil;
    end
end );