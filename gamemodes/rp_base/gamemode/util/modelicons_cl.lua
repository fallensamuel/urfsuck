-- "gamemodes\\rp_base\\gamemode\\util\\modelicons_cl.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
ModelIcons       = ModelIcons or {};
ModelIcons.Cache = ModelIcons.Cache or {};

ModelIcons.PATH_CACHE = "modelicons/";


if not file.IsDir( ModelIcons.PATH_CACHE, "DATA" ) then
    file.CreateDir( ModelIcons.PATH_CACHE );
end


local renderTarget = GetRenderTargetEx(
    "urf_mdlicons_renderer",
    512, 512,
    RT_SIZE_OFFSCREEN,
    MATERIAL_RT_DEPTH_SHARED,
    bit.bor(16),
    0,
    IMAGE_FORMAT_RGBA8888
);


local renderThread;
local renderQueue = {};


local function ProcessRenderQueue()
    local k, v = next( renderQueue );

    coroutine.yield();

    if not k then
        hook.Remove( "HUDPaint", "ModelIcons::RenderThread" );
    else
        table.remove( renderQueue, k );
        
        local m = ModelIcons.Render( v.mdl, v.ang, v.scale );

        if v.callback then
            v.callback( m );
        end
    end
end


local function InitializeRenderQueue()
    hook.Add( "HUDPaint", "ModelIcons::RenderThread", function()
        if
            not renderThread or
            not coroutine.resume(renderThread)
        then
            renderThread = coroutine.create( ProcessRenderQueue );
            coroutine.resume( renderThread );        
        end
    end );
end


ModelIcons.GetFilePath = function( mdl, ang, scale )
    return ModelIcons.PATH_CACHE .. util.CRC( mdl .. tostring(ang) .. scale ) .. ".png";
end


ModelIcons.Add = function( mdl, ang, scale, callback )
    local filepath = ModelIcons.GetFilePath( mdl, ang, scale );

    table.insert( renderQueue, {
        mdl      = mdl,
        ang      = ang,
        scale    = scale,
        callback = callback
    } );

    if #renderQueue == 1 then
        InitializeRenderQueue();
    end
end


ModelIcons.Get = function( mdl, ang, scale, callback, forced )
    local filepath = ModelIcons.GetFilePath( mdl, ang, scale );

    if not forced and callback then
        if ModelIcons.Cache[filepath] then
            callback( ModelIcons.Cache[filepath] );
            return
        end

        if file.Exists( filepath, "DATA" ) then
            ModelIcons.Cache[filepath] = Material( "data/" .. filepath, "smooth" );
            callback( ModelIcons.Cache[filepath] );
            return
        end
    end

    ModelIcons.Add( mdl, ang, scale, callback );
end


ModelIcons.Render = function( mdl, ang, scale )
    local filepath = ModelIcons.GetFilePath( mdl, ang, scale );

    ang   = ang   or Angle(0,0,0);
    scale = scale or 1;

    local CSMdlEntity = ClientsideModel( mdl, RENDERGROUP_BOTH );

    CSMdlEntity.renderFOV                          = 24;
    CSMdlEntity.renderMins, CSMdlEntity.renderMaxs = CSMdlEntity:GetModelRenderBounds();
    CSMdlEntity.renderBoundsDistanceRadius         = CSMdlEntity.renderMins:Distance( CSMdlEntity.renderMaxs );

    CSMdlEntity:SetModelScale( 128 / CSMdlEntity.renderBoundsDistanceRadius ); -- bruh this is fucked up

    CSMdlEntity.renderBoundsDistanceRadius = CSMdlEntity.renderBoundsDistanceRadius* CSMdlEntity:GetModelScale() * (90 / CSMdlEntity.renderFOV) * 0.75 / scale;
    CSMdlEntity.renderCenter               = LerpVector( 0.5, CSMdlEntity.renderMins, CSMdlEntity.renderMaxs ) * CSMdlEntity:GetModelScale();

    render.PushRenderTarget( renderTarget );
        render.Clear( 0, 0, 0, 0 );
        render.ClearDepth();

        cam.Start( {
            type = "3D",

            x = 0,
            y = 0,
            w = 512,
            h = 512,

            origin = CSMdlEntity.renderCenter - ang:Forward() * CSMdlEntity.renderBoundsDistanceRadius,
            angles = ang,

            fov    = CSMdlEntity.renderFOV,
            aspect = 1,

            znear = 0.01,
            zfar  = 2147483646,

            --ortho = {
            --    left   = -CSMdlEntity.renderBoundsDistanceRadius * scale,
            --    right  =  CSMdlEntity.renderBoundsDistanceRadius * scale,
            --    top    = -CSMdlEntity.renderBoundsDistanceRadius * scale,
            --    bottom =  CSMdlEntity.renderBoundsDistanceRadius * scale
            --},
        } );

            render.SuppressEngineLighting( true );
            render.SetLightingMode( 1 );
                -- retarded approach, but hey, it kinda works

                -- Setup lighting:
                render.ResetModelLighting( 0.2, 0.2, 0.2 );
                render.SetModelLighting( BOX_TOP, 1, 1, 1 );
	            render.SetModelLighting( BOX_FRONT, 1, 1, 1 );

                -- Reset color/light settings:
                render.SetColorModulation( 1, 1, 1 );
                render.SetAmbientLight( 1, 1, 1 );
                render.SetBlend( 1 );

                -- Render model to the texture
                render.SetWriteDepthToDestAlpha( false );
                    CSMdlEntity:DrawModel();
                render.SetWriteDepthToDestAlpha( true );

                render.OverrideAlphaWriteEnable( true, true );
                    CSMdlEntity:DrawModel();
                render.OverrideAlphaWriteEnable( false );

                CSMdlEntity:DrawModel();
            render.SetLightingMode( 0 );
            render.SuppressEngineLighting( false );    

        cam.End();

        --

        file.Write(
            filepath,
            render.Capture( {
                format = "png", x = 0, y = 0, w = 512, h = 512
            } )
        );

    render.PopRenderTarget();
    
    --
    CSMdlEntity:Remove();

    --
    ModelIcons.Cache[filepath] = Material( "data/" .. filepath, "smooth" );
    
    return ModelIcons.Cache[filepath];
end