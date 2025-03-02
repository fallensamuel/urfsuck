-- "gamemodes\\darkrp\\gamemode\\addons\\artifactmod\\cl_core.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
if true then return end

ArtifactMod = ArtifactMod or {};


local vector_hidden = Vector( 0, 0, -32768 );


hook.Add( "PostPlayerDraw", "ArtifactMod::RenderModels", function( ply )
    local inv = ArtifactMod:GetArtifactInventory( ply );
    if not inv then return end

    local b = ply:LookupBone( "ValveBiped.Bip01_Pelvis" );
    if not b then return end

    local origin, angles = ply:GetBonePosition( b );
    angles:RotateAroundAxis( angles:Up(), 180 );
    angles:RotateAroundAxis( angles:Forward(), 90 );
    
    local mins, maxs = ply:GetModelRenderBounds();
    mins.z, maxs.z = 0, 0;

    local r = mins:Distance( maxs ) * 0.25;

    local items = ply:GetNetVar( "Artifacts" ) or {};

    local c = #items;
    if c == 0 then return end

    if not ArtifactMod.ClientsideModel then
        ArtifactMod.ClientsideModel = ClientsideModel( "models/props_lab/huladoll.mdl", RENDERGROUP_BOTH );
    end

    local q = math.max(c - 1, 4);

    for i = 0, q do
        local artifact = rp.item.artifacts.Map[items[i + 1]];

        if artifact and artifact.model then
            if ArtifactMod.ClientsideModel:GetModel() ~= artifact.model then
                ArtifactMod.ClientsideModel:SetModel( artifact.model );
                ArtifactMod.ClientsideModel:SetModelScale( 4 / ArtifactMod.ClientsideModel:GetModelRadius(), 0 );
            end

            local deg = (115 / q) * i;
            local d = math.rad( deg + 75 );

            local position, angles = LocalToWorld( Vector( math.sin(d) * r * 0.95, math.cos(d) * r * 0.785, 0 ), Angle( 0, -deg + 16, 0 ), origin, angles );

            ArtifactMod.ClientsideModel:SetRenderOrigin( position );
            ArtifactMod.ClientsideModel:SetRenderAngles( angles );
            ArtifactMod.ClientsideModel:SetupBones();
            ArtifactMod.ClientsideModel:DrawModel();
        end
    end

    ArtifactMod.ClientsideModel:SetRenderOrigin( vector_hidden );
end );