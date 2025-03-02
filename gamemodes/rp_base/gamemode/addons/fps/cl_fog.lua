local render, GetRenderDist, math_sqrt = render, GetRenderDistance, math.sqrt;


local fog_settings = rp.cfg.Fog;
if not fog_settings then return end


local fogStart     = fog_settings.Day.fogStart;
local fogEnd       = fog_settings.Day.fogEnd;
local fogColor     = fog_settings.Day.col;
local fogDensity   = fog_settings.Day.fogDensity;
local fogThickness = fogEnd - fogStart;


local function changeFog()
	if nw.GetGlobal("IsDay") then
		fogStart     = fog_settings.Day.fogStart;
		fogEnd       = fog_settings.Day.fogEnd;
		fogColor     = fog_settings.Day.col;
		fogDensity   = fog_settings.Day.fogDensity;
		fogThickness = fogEnd - fogStart;
	else
		fogStart     = fog_settings.Night.fogStart;
		fogEnd       = fog_settings.Night.fogEnd;
		fogColor     = fog_settings.Night.col;
		fogDensity   = fog_settings.Night.fogDensity;
		fogThickness = fogEnd - fogStart;
	end

	if GetRenderDist then
		rp.cfg.MaxRenderDistance = rp.cfg.DrawMultiplayer or (fogEnd + 512);
		SetRenderDistance( rp.cfg.MaxRenderDistance * rp.cfg.MaxRenderDistance );
	end
end
changeFog();
hook.Add( "DayNightChanged", changeFog );


hook.Add( "SetupWorldFog", function()
	render.FogMode( MATERIAL_FOG_LINEAR );

	if not GetRenderDist then
		render.FogStart( fogStart );
		render.FogEnd( fogEnd );
	else
		local d = math_sqrt( GetRenderDist() );

		--render.FogStart( d - 128 - fogThickness );
		--render.FogEnd( d - 128 );

		render.FogStart( (d > fogStart) and fogStart or (d - 32 - fogThickness)  );
		render.FogEnd( d - 32 );
	end

	render.FogMaxDensity( fogDensity );
	render.FogColor( fogColor.r, fogColor.g, fogColor.b );
	
	return true
end );


hook.Add( "SetupSkyboxFog", function( skyboxscale )
	if isWhiteForest then return end

	render.FogMode( MATERIAL_FOG_LINEAR );

	-- print(fogEnd * cvar_Get('draw_distance'))
	
	render.FogStart( 0 ); -- fogStart * skyboxscale )
	render.FogEnd( fogEnd * skyboxscale );
	render.FogMaxDensity( fogDensity );
	render.FogColor( fogColor.r, fogColor.g, fogColor.b );
	
	return true
end );