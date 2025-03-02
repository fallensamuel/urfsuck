-- "gamemodes\\rp_base\\gamemode\\addons\\destructibles\\cl_destructibles_core.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
if not rp.cfg.EnableDestructibles then return end

----------------------------------------------------------------
-- Includes:
----------------------------------------------------------------
include( "meta/sh_entity_destructible.lua" );
include( "meta/cl_entity_destructible.lua" );


----------------------------------------------------------------
-- rp.Destructibles:
----------------------------------------------------------------
rp.Destructibles = {};


----------------------------------------------------------------
-- rp.Destructibles.Rendering:
----------------------------------------------------------------
rp.Destructibles.Rendering = {
    Enabled  = true,
    Material = CreateMaterial( "_destructibles_mathandler", "VertexLitGeneric", {
        ["$alphatest"] = 1,
        ["$decal"] = 1,
        ["$model"] = 1,
        ["$basetexturetransform"] = "center .5 .5 scale 1.25 1.25 rotate 45 translate 0 0",
    } ),
};

rp.Destructibles.Rendering.SetDestructibleRendering = function( ent, bEnable )
    if bEnable then
        ent._RenderOverride = ent._RenderOverride and ent._RenderOverride or ent.RenderOverride;

        ent.fDestructibleDt = 1;

        ent.RenderOverride = function()
            if ent._RenderOverride then ent:_RenderOverride(); else ent:DrawModel(); end
            rp.Destructibles.Rendering.DrawDestructibleModel( ent );
        end

        ent.bDestructibleRendering = true;
    else
        ent.RenderOverride = ent._RenderOverride;

        ent.bDestructibleRendering = false;
    end
end


rp.Destructibles.Rendering.DrawDestructibleModel = function( ent )
    if not rp.Destructibles.Rendering.Enabled then return end

    ent.fDestructibleDt = Lerp(
        5 * RealFrameTime(),
        ent.fDestructibleDt,
        ent:GetDestructibleStatus() / 7
    );

    ent.fDestructibleDt = math.max( 0.1, ent.fDestructibleDt );

    rp.Destructibles.Rendering.Material:SetTexture( "$basetexture", Material("cracks/default"):GetTexture("$basetexture") );

    local fDestructibleDtRounded     = math.Round( ent.fDestructibleDt, 2 ); 
    local fAlphaTestReferenceRounded = math.Round( rp.Destructibles.Rendering.Material:GetFloat( "$alphatestreference" ), 2 );
    
    if fAlphaTestReferenceRounded ~= fDestructibleDtRounded then
        rp.Destructibles.Rendering.Material:SetFloat( "$alphatestreference", ent.fDestructibleDt );
        rp.Destructibles.Rendering.Material:Recompute();
    end

    local bIsBrush = ent:IsFlagSet( FL_WORLDBRUSH );
    (bIsBrush and render.BrushMaterialOverride or render.ModelMaterialOverride)( rp.Destructibles.Rendering.Material );
        ent:DrawModel();
    (bIsBrush and render.BrushMaterialOverride or render.ModelMaterialOverride)();
end


----------------------------------------------------------------
-- Hooks:
----------------------------------------------------------------
hook.Add( "EntityDestructibleStatus", "Destructibles.Core::EnableDestructibleRendering", function( ent, status )
    if not IsValid( ent ) then return end -- this is synced after NetworkEntityCreated anyway

    if not ent.bDestructibleRendering then
        timer.Simple( 1, function()
            if not IsValid( ent ) then return end
            rp.Destructibles.Rendering.SetDestructibleRendering( ent, true );
        end );

        ent.bDestructibleRendering = true;
    end
end );