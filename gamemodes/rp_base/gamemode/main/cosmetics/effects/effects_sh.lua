-- "gamemodes\\rp_base\\gamemode\\main\\cosmetics\\effects\\effects_sh.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
-- rp.AddHat: --------------------------------------------------
function rp.AddWearableEffect( data )
    data.type = rp.Accessories.Enums["TYPE_EFFECT"];
    data.uid = data.uid or (data.effect .. (data.static and "_static" or ""));
    data.__renderer = rp.Accessories.EffectRenderer;
    return rp.AddWearable( data );
end

if CLIENT then
    local vector_hidden = Vector( 0, 0, -32768 );
    local matrix_effect = Matrix();

    rp.Accessories.EffectRenderer = function( ent, uid )
        local data = rp.Accessories.List[uid];
        if not data then return end
        
        if not data.effect then return end

        local csmdl = rp.Accessories.GetClientsideModel(ent);
        if not IsValid( csmdl ) then return end
    
        if ent:IsPlayer() then
            if data.can_wear and (not data.can_wear(ent)) then
                csmdl:SetNoDraw( true );
                return
            end
        end
    
        csmdl:SetNoDraw( false );

        if (not ent[data.uid]) or (not ent[data.uid]:IsValid()) then
            ent[data.uid] = CreateParticleSystem( ent, data.effect, PATTACH_CUSTOMORIGIN, 0, vector_origin );
            ent[data.uid]:SetShouldDraw( false );
        end

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
            
            pos = ent:GetBonePosition( bone_id );
        end
    
        csmdl, pos, ang = data:modifyClientsideModel( ent, csmdl, pos, ang );
    
        if csmdl:GetModel() ~= "models/editor/axis_helper.mdl" then
            csmdl:SetModel( "models/editor/axis_helper.mdl" );
        end
    
        if csmdl:GetModelScale() ~= 0 then
            csmdl:SetModelScale( 0, 0 );
        end

        csmdl:SetPos( pos );
        csmdl:SetAngles( ang );
        csmdl:SetRenderOrigin( pos );
        csmdl:SetRenderAngles( ang );
        csmdl:SetupBones();
        csmdl:DrawModel();
        csmdl:SetRenderOrigin( vector_hidden );

        if data.static then
            -- find a way to optimize this:
            ent[data.uid]:SetControlPoint( 0, vector_origin );
            ent[data.uid]:Restart();

            matrix_effect:SetTranslation( pos );

            cam.PushModelMatrix( matrix_effect );
                ent[data.uid]:Render();
            cam.PopModelMatrix();
        else
            ent[data.uid]:SetControlPoint( 0, pos );
            ent[data.uid]:Restart();
            ent[data.uid]:Render();
        end
    end
end