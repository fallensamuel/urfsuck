-- "gamemodes\\rp_base\\entities\\weapons\\gmod_tool\\stools\\material.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal

TOOL.Category = "Render"
TOOL.Name = "#tool.material.name"

TOOL.ClientConVar[ "override" ] = "debug/env_cubemap_model"

--
-- Duplicator function
--

local bad_materials = {
	["models/wireframe"] 							= true,
	["Models/effects/comball_sphere"] 				= true,
	["Models/effects/comball_tape"] 				= true,
	["Models/effects/splodearc_sheet"] 				= true,
	["models/props_combine/portalball001_sheet"]	= true,
	["models/props_combine/stasisfield_beam"]		= true,
}

local function SetMaterial( Player, Entity, Data )
	
	if ( SERVER ) then

		--
		-- Make sure this is in the 'allowed' list in multiplayer - to stop people using exploits
		--
		if ( !game.SinglePlayer() && !list.Contains( "OverrideMaterials", Data.MaterialOverride ) && Data.MaterialOverride != "" ) then return end

		Entity:SetMaterial( Data.MaterialOverride )
		duplicator.StoreEntityModifier( Entity, "material", Data )
	end

	return true

end
duplicator.RegisterEntityModifier( "material", SetMaterial )

--
-- Left click applies the current material
--

local CompareColors = function(c1, c2) 
   return (c1.r == c2.r and c1.g == c2.g and c1.b == c2.b and c1.a == c2.a)
end

function TOOL:LeftClick( trace )

	if ( !IsValid( trace.Entity ) ) then return end

	if ( CLIENT ) then return true end
	
	local ent = trace.Entity
	if ( IsValid( ent.AttachedEntity ) ) then ent = ent.AttachedEntity end

	local mat = self:GetClientInfo( "override" )

	if bad_materials[mat] and not CompareColors(ent:GetColor(), Color(255, 255, 255, 255)) then
		self:GetOwner():PrintMessage(HUD_PRINTTALK, "Смена цвета для пропов с этим материалом заблокированна! Проп автоматически перекрашен в белый цвет!")
		//self:GetOwner():CCPrint("Смена цвета для пропов с этим материалом заблокированна! Проп автоматически перекрашен в белый цвет!", true)
		ent:SetColor(Color(255, 255, 255, 255))
	end

	SetMaterial( self:GetOwner(), ent, { MaterialOverride = mat } )
	return true

end

--
-- Right click reverts the material
--
function TOOL:RightClick( trace )

	if ( !IsValid( trace.Entity ) ) then return end

	if ( CLIENT ) then return true end
	
	local ent = trace.Entity
	if ( IsValid( ent.AttachedEntity ) ) then ent = ent.AttachedEntity end

	SetMaterial( self:GetOwner(), ent, { MaterialOverride = "" } )
	return true

end

if ( IsMounted( "tf" ) ) then
	list.Add( "OverrideMaterials", "models/player/shared/gold_player" )
	list.Add( "OverrideMaterials", "models/player/shared/ice_player" )
end

list.Add( "OverrideMaterials", "models/wireframe" )
list.Add( "OverrideMaterials", "debug/env_cubemap_model" )
list.Add( "OverrideMaterials", "models/shadertest/shader3" )
list.Add( "OverrideMaterials", "models/shadertest/shader4" )
list.Add( "OverrideMaterials", "models/shadertest/shader5" )
list.Add( "OverrideMaterials", "models/shiny" )
list.Add( "OverrideMaterials", "models/debug/debugwhite" )
list.Add( "OverrideMaterials", "Models/effects/comball_sphere" )
list.Add( "OverrideMaterials", "Models/effects/comball_tape" )
list.Add( "OverrideMaterials", "Models/effects/splodearc_sheet" )
--list.Add( "OverrideMaterials", "Models/effects/vol_light001" )
list.Add( "OverrideMaterials", "models/props_combine/stasisshield_sheet" )
list.Add( "OverrideMaterials", "models/props_combine/portalball001_sheet" )
list.Add( "OverrideMaterials", "models/props_combine/com_shield001a" )
list.Add( "OverrideMaterials", "models/props_c17/frostedglass_01a" )
list.Add( "OverrideMaterials", "models/props_lab/Tank_Glass001" )
list.Add( "OverrideMaterials", "models/props_combine/tprings_globe" )
list.Add( "OverrideMaterials", "models/rendertarget" )
list.Add( "OverrideMaterials", "models/screenspace" )
list.Add( "OverrideMaterials", "brick/brick_model" )
list.Add( "OverrideMaterials", "models/props_pipes/GutterMetal01a" )
list.Add( "OverrideMaterials", "models/props_pipes/Pipesystem01a_skin3" )
list.Add( "OverrideMaterials", "models/props_wasteland/wood_fence01a" )
list.Add( "OverrideMaterials", "models/props_foliage/tree_deciduous_01a_trunk" )
list.Add( "OverrideMaterials", "models/props_c17/FurnitureFabric003a" )
list.Add( "OverrideMaterials", "models/props_c17/FurnitureMetal001a" )
list.Add( "OverrideMaterials", "models/props_c17/paper01" )
list.Add( "OverrideMaterials", "models/flesh" )

-- phx
list.Add( "OverrideMaterials", "phoenix_storms/metalset_1-2" )
list.Add( "OverrideMaterials", "phoenix_storms/metalfloor_2-3" )
list.Add( "OverrideMaterials", "phoenix_storms/plastic" )
list.Add( "OverrideMaterials", "phoenix_storms/wood" )
list.Add( "OverrideMaterials", "phoenix_storms/bluemetal" )
list.Add( "OverrideMaterials", "phoenix_storms/cube" )
list.Add( "OverrideMaterials", "phoenix_storms/dome" )
list.Add( "OverrideMaterials", "phoenix_storms/gear" )
list.Add( "OverrideMaterials", "phoenix_storms/stripes" )
list.Add( "OverrideMaterials", "phoenix_storms/wire/pcb_green" )
list.Add( "OverrideMaterials", "phoenix_storms/wire/pcb_red" )
list.Add( "OverrideMaterials", "phoenix_storms/wire/pcb_blue" )

list.Add( "OverrideMaterials", "hunter/myplastic" )
list.Add( "OverrideMaterials", "models/XQM/LightLinesRed_tool" )

-- extra
list.Add( "OverrideMaterials", "models/XQM//Deg360" )
list.Add( "OverrideMaterials", "models/XQM//LightLinesGB" )
list.Add( "OverrideMaterials", "models/XQM//LightLinesRed" )
list.Add( "OverrideMaterials", "models/XQM//SquaredMat" )
list.Add( "OverrideMaterials", "models/XQM//WoodTexture_1" )
--list.Add( "OverrideMaterials", "models/airboat/airboat_blur02" )
list.Add( "OverrideMaterials", "models/antlion/antlion_innards" )
list.Add( "OverrideMaterials", "models/barnacle/roots" )
list.Add( "OverrideMaterials", "models/combine_advisor/body9" )
list.Add( "OverrideMaterials", "models/combine_advisor/mask" )
list.Add( "OverrideMaterials", "models/combine_scanner/scanner_eye" )
list.Add( "OverrideMaterials", "models/debug/debugwhite" )
list.Add( "OverrideMaterials", "models/dog/eyeglass" )
--list.Add( "OverrideMaterials", "models/effects/portalrift_sheet" )
list.Add( "OverrideMaterials", "models/effects/slimebubble_sheet" )
list.Add( "OverrideMaterials", "models/effects/splode1_sheet" )
list.Add( "OverrideMaterials", "models/effects/splode_sheet" )
list.Add( "OverrideMaterials", "models/gibs/metalgibs/metal_gibs" )
list.Add( "OverrideMaterials", "models/gibs/woodgibs/woodgibs01" )
list.Add( "OverrideMaterials", "models/gibs/woodgibs/woodgibs02" )
list.Add( "OverrideMaterials", "models/gibs/woodgibs/woodgibs03" )
list.Add( "OverrideMaterials", "models/player/player_chrome1" )
list.Add( "OverrideMaterials", "models/props_animated_breakable/smokestack/brickwall002a" )
list.Add( "OverrideMaterials", "models/props_building_details/courtyard_template001c_bars" )
list.Add( "OverrideMaterials", "models/props_building_details/courtyard_template001c_bars" )
list.Add( "OverrideMaterials", "models/props_buildings/destroyedbuilldingwall01a" )
list.Add( "OverrideMaterials", "models/props_buildings/plasterwall021a" )
list.Add( "OverrideMaterials", "models/props_c17/frostedglass_01a" )
list.Add( "OverrideMaterials", "models/props_c17/furniturefabric001a" )
list.Add( "OverrideMaterials", "models/props_c17/furniturefabric002a" )
list.Add( "OverrideMaterials", "models/props_c17/furnituremetal001a" )
list.Add( "OverrideMaterials", "models/props_c17/gate_door02a" )
list.Add( "OverrideMaterials", "models/props_c17/metalladder001" )
list.Add( "OverrideMaterials", "models/props_c17/metalladder002" )
list.Add( "OverrideMaterials", "models/props_c17/metalladder003" )
list.Add( "OverrideMaterials", "models/props_canal/canal_bridge_railing_01a" )
list.Add( "OverrideMaterials", "models/props_canal/canal_bridge_railing_01b" )
list.Add( "OverrideMaterials", "models/props_canal/canal_bridge_railing_01c" )
list.Add( "OverrideMaterials", "models/props_canal/canalmap_sheet" )
list.Add( "OverrideMaterials", "models/props_canal/coastmap_sheet" )
list.Add( "OverrideMaterials", "models/props_canal/metalcrate001d" )
list.Add( "OverrideMaterials", "models/props_canal/metalwall005b" )
list.Add( "OverrideMaterials", "models/props_canal/rock_riverbed01a" )
list.Add( "OverrideMaterials", "models/props_combine/citadel_cable" )
list.Add( "OverrideMaterials", "models/props_combine/citadel_cable_b" )
list.Add( "OverrideMaterials", "models/props_combine/com_shield001a" )
list.Add( "OverrideMaterials", "models/props_combine/combine_interface_disp" )
list.Add( "OverrideMaterials", "models/props_combine/combine_monitorbay_disp" )
list.Add( "OverrideMaterials", "models/props_combine/metal_combinebridge001" )
list.Add( "OverrideMaterials", "models/props_combine/pipes01" )
list.Add( "OverrideMaterials", "models/props_combine/pipes03" )
list.Add( "OverrideMaterials", "models/props_combine/prtl_sky_sheet" )
list.Add( "OverrideMaterials", "models/props_combine/stasisfield_beam" )
list.Add( "OverrideMaterials", "models/props_debris/building_template010a" )
list.Add( "OverrideMaterials", "models/props_debris/building_template022j" )
list.Add( "OverrideMaterials", "models/props_debris/composite_debris" )
list.Add( "OverrideMaterials", "models/props_debris/concretefloor013a" )
list.Add( "OverrideMaterials", "models/props_debris/concretefloor020a" )
list.Add( "OverrideMaterials", "models/props_debris/concretewall019a" )
list.Add( "OverrideMaterials", "models/props_debris/metalwall001a" )
list.Add( "OverrideMaterials", "models/props_debris/plasterceiling008a" )
list.Add( "OverrideMaterials", "models/props_debris/plasterwall009d" )
list.Add( "OverrideMaterials", "models/props_debris/plasterwall021a" )
list.Add( "OverrideMaterials", "models/props_debris/plasterwall034a" )
list.Add( "OverrideMaterials", "models/props_debris/plasterwall034d" )
list.Add( "OverrideMaterials", "models/props_debris/plasterwall039c" )
list.Add( "OverrideMaterials", "models/props_debris/plasterwall040c" )
list.Add( "OverrideMaterials", "models/props_debris/tilefloor001c" )
list.Add( "OverrideMaterials", "models/props_foliage/driftwood_01a" )
list.Add( "OverrideMaterials", "models/props_foliage/oak_tree01" )
list.Add( "OverrideMaterials", "models/props_foliage/tree_deciduous_01a_trunk" )
list.Add( "OverrideMaterials", "models/props_interiors/metalfence007a" )
list.Add( "OverrideMaterials", "models/props_junk/plasticcrate01a" )
list.Add( "OverrideMaterials", "models/props_junk/plasticcrate01b" )
list.Add( "OverrideMaterials", "models/props_junk/plasticcrate01c" )
list.Add( "OverrideMaterials", "models/props_junk/plasticcrate01d" )
list.Add( "OverrideMaterials", "models/props_junk/plasticcrate01e" )
list.Add( "OverrideMaterials", "models/props_lab/Tank_Glass001" )
list.Add( "OverrideMaterials", "models/props_lab/cornerunit_cloud" )
list.Add( "OverrideMaterials", "models/props_lab/door_klab01" )
list.Add( "OverrideMaterials", "models/props_lab/security_screens" )
list.Add( "OverrideMaterials", "models/props_lab/security_screens2" )
list.Add( "OverrideMaterials", "models/props_lab/warp_sheet" )
list.Add( "OverrideMaterials", "models/props_lab/xencrystal_sheet" )
list.Add( "OverrideMaterials", "models/props_pipes/GutterMetal01a")
list.Add( "OverrideMaterials", "models/props_pipes/destroyedpipes01a" )
list.Add( "OverrideMaterials", "models/props_pipes/pipemetal001a" )
list.Add( "OverrideMaterials", "models/props_pipes/pipeset_metal02" )
list.Add( "OverrideMaterials", "models/props_pipes/pipesystem01a_skin1" )
list.Add( "OverrideMaterials", "models/props_pipes/pipesystem01a_skin2" )
list.Add( "OverrideMaterials", "models/props_vents/borealis_vent001" )
list.Add( "OverrideMaterials", "models/props_vents/borealis_vent001b" )
list.Add( "OverrideMaterials", "models/props_vents/borealis_vent001c" )
list.Add( "OverrideMaterials", "models/props_wasteland/concretefloor010a" )
list.Add( "OverrideMaterials", "models/props_wasteland/concretewall064b" )
list.Add( "OverrideMaterials", "models/props_wasteland/concretewall066a" )
list.Add( "OverrideMaterials", "models/props_wasteland/dirtwall001a" )
list.Add( "OverrideMaterials", "models/props_wasteland/metal_tram001a" )
list.Add( "OverrideMaterials", "models/props_wasteland/quarryobjects01" )
list.Add( "OverrideMaterials", "models/props_wasteland/rockcliff02a" )
list.Add( "OverrideMaterials", "models/props_wasteland/rockcliff02b" )
list.Add( "OverrideMaterials", "models/props_wasteland/rockcliff02c" )
list.Add( "OverrideMaterials", "models/props_wasteland/rockcliff04a" )
list.Add( "OverrideMaterials", "models/props_wasteland/rockgranite02a" )
list.Add( "OverrideMaterials", "models/props_wasteland/tugboat01" )
list.Add( "OverrideMaterials", "models/props_wasteland/tugboat02" )
list.Add( "OverrideMaterials", "models/props_wasteland/wood_fence01a" )
list.Add( "OverrideMaterials", "models/props_wasteland/wood_fence01a_skin2" )
list.Add( "OverrideMaterials", "models/shadertest/predator" )
list.Add( "OverrideMaterials", "models/weapons/v_crossbow/rebar_glow" )
list.Add( "OverrideMaterials", "models/weapons/v_crowbar/crowbar_cyl" )
list.Add( "OverrideMaterials", "models/weapons/v_grenade/grenade body" )
--list.Add( "OverrideMaterials", "models/weapons/v_smg1/texture5" )
list.Add( "OverrideMaterials", "models/XQM/BoxFull_diffuse" )
list.Add( "OverrideMaterials", "models/XQM/CellShadedCamo_diffuse" )
list.Add( "OverrideMaterials", "models/XQM/CinderBlock_Tex" )
list.Add( "OverrideMaterials", "models/XQM/JetBody2TailPiece_diffuse" )
list.Add( "OverrideMaterials", "models/XQM/PoleX1_diffuse" )
list.Add( "OverrideMaterials", "models/XQM/Rails/gumball_1" )
list.Add( "OverrideMaterials", "models/XQM/SquaredMatInverted" )
list.Add( "OverrideMaterials", "models/XQM/WoodPlankTexture" )
list.Add( "OverrideMaterials", "models/XQM/boxfull_diffuse" )
list.Add( "OverrideMaterials", "models/dav0r/hoverball" )
list.Add( "OverrideMaterials", "models/spawn_effect" )
list.Add( "OverrideMaterials", "phoenix_storms/Fender_chrome" )
list.Add( "OverrideMaterials", "phoenix_storms/Fender_white" )
list.Add( "OverrideMaterials", "phoenix_storms/Fender_wood" )
list.Add( "OverrideMaterials", "phoenix_storms/Future_vents" )
list.Add( "OverrideMaterials", "phoenix_storms/FuturisticTrackRamp_1-2" )
list.Add( "OverrideMaterials", "phoenix_storms/OfficeWindow_1-1" )
list.Add( "OverrideMaterials", "phoenix_storms/Pro_gear_side" )
list.Add( "OverrideMaterials", "phoenix_storms/black_brushes" )
list.Add( "OverrideMaterials", "phoenix_storms/black_chrome" )
list.Add( "OverrideMaterials", "phoenix_storms/blue_steel" )
list.Add( "OverrideMaterials", "phoenix_storms/camera" )
list.Add( "OverrideMaterials", "phoenix_storms/car_tire" )
list.Add( "OverrideMaterials", "phoenix_storms/checkers_map" )
list.Add( "OverrideMaterials", "phoenix_storms/cigar" )
list.Add( "OverrideMaterials", "phoenix_storms/concrete0" )
list.Add( "OverrideMaterials", "phoenix_storms/concrete1" )
list.Add( "OverrideMaterials", "phoenix_storms/concrete2" )
list.Add( "OverrideMaterials", "phoenix_storms/concrete3" )
list.Add( "OverrideMaterials", "phoenix_storms/construct/concrete_barrier00" )
list.Add( "OverrideMaterials", "phoenix_storms/construct/concrete_barrier2_00" )
list.Add( "OverrideMaterials", "phoenix_storms/construct/concrete_pipe_00" )
list.Add( "OverrideMaterials", "phoenix_storms/egg" )
list.Add( "OverrideMaterials", "phoenix_storms/gear" )
list.Add( "OverrideMaterials", "phoenix_storms/gear_top" )
list.Add( "OverrideMaterials", "phoenix_storms/grey_chrome" )
list.Add( "OverrideMaterials", "phoenix_storms/grey_steel" )
list.Add( "OverrideMaterials", "phoenix_storms/heli" )
list.Add( "OverrideMaterials", "phoenix_storms/indentTiles2" )
list.Add( "OverrideMaterials", "phoenix_storms/iron_rails" )
list.Add( "OverrideMaterials", "phoenix_storms/mat/mat_phx_carbonfiber" )
list.Add( "OverrideMaterials", "phoenix_storms/mat/mat_phx_carbonfiber2" )
list.Add( "OverrideMaterials", "phoenix_storms/mat/mat_phx_metallic" )
list.Add( "OverrideMaterials", "phoenix_storms/mat/mat_phx_metallic2" )
list.Add( "OverrideMaterials", "phoenix_storms/mat/mat_phx_plastic" )
list.Add( "OverrideMaterials", "phoenix_storms/mat/mat_phx_plastic2" )
list.Add( "OverrideMaterials", "phoenix_storms/metal_plate" )
list.Add( "OverrideMaterials", "phoenix_storms/metal_wheel" )
list.Add( "OverrideMaterials", "phoenix_storms/metalbox" )
list.Add( "OverrideMaterials", "phoenix_storms/metalbox2" )
list.Add( "OverrideMaterials", "phoenix_storms/metalfence004a" )
list.Add( "OverrideMaterials", "phoenix_storms/middle" )
list.Add( "OverrideMaterials", "phoenix_storms/mrref2" )
list.Add( "OverrideMaterials", "phoenix_storms/output_jack" )
list.Add( "OverrideMaterials", "phoenix_storms/pack2/chrome" )
list.Add( "OverrideMaterials", "phoenix_storms/pack2/interior_sides" )
list.Add( "OverrideMaterials", "phoenix_storms/pack2/train_floor" )
list.Add( "OverrideMaterials", "phoenix_storms/potato" )
list.Add( "OverrideMaterials", "phoenix_storms/pro_gear_top2" )
list.Add( "OverrideMaterials", "phoenix_storms/ps_grass" )
list.Add( "OverrideMaterials", "phoenix_storms/road" )
list.Add( "OverrideMaterials", "phoenix_storms/roadside" )
list.Add( "OverrideMaterials", "phoenix_storms/scrnspace" )
list.Add( "OverrideMaterials", "phoenix_storms/side" )
list.Add( "OverrideMaterials", "phoenix_storms/simplyMetallic1" )
list.Add( "OverrideMaterials", "phoenix_storms/simplyMetallic2" )
list.Add( "OverrideMaterials", "phoenix_storms/smallwheel" )
list.Add( "OverrideMaterials", "phoenix_storms/spheremappy" )
list.Add( "OverrideMaterials", "phoenix_storms/t_light" )
list.Add( "OverrideMaterials", "phoenix_storms/thruster" )
list.Add( "OverrideMaterials", "phoenix_storms/tiles2" )
list.Add( "OverrideMaterials", "phoenix_storms/top" )
list.Add( "OverrideMaterials", "phoenix_storms/torpedo" )
list.Add( "OverrideMaterials", "phoenix_storms/trains/track_beamside" )
list.Add( "OverrideMaterials", "phoenix_storms/trains/track_beamtop" )
list.Add( "OverrideMaterials", "phoenix_storms/trains/track_plate" )
list.Add( "OverrideMaterials", "phoenix_storms/trains/track_plateside" )
list.Add( "OverrideMaterials", "phoenix_storms/white_brushes" )
list.Add( "OverrideMaterials", "phoenix_storms/white_fps" )
list.Add( "OverrideMaterials", "phoenix_storms/window" )
list.Add( "OverrideMaterials", "phoenix_storms/wire/pcb_blue" )
list.Add( "OverrideMaterials", "phoenix_storms/wire/pcb_green" )
list.Add( "OverrideMaterials", "phoenix_storms/wire/pcb_red" )
list.Add( "OverrideMaterials", "phoenix_storms/wood_dome" )
list.Add( "OverrideMaterials", "phoenix_storms/wood_side" )

-- CSS
list.Add( "OverrideMaterials", "models/cs_havana/wndb" )
list.Add( "OverrideMaterials", "models/cs_havana/wndd" )
list.Add( "OverrideMaterials", "models/cs_italy/light_orange" )
list.Add( "OverrideMaterials", "models/cs_italy/plaster" )
list.Add( "OverrideMaterials", "models/cs_italy/pwtrim2" )
list.Add( "OverrideMaterials", "models/de_cbble/wndarch" )
list.Add( "OverrideMaterials", "models/de_chateau/ch_arch_b1" )
list.Add( "OverrideMaterials", "models/pi_window/plaster" )
list.Add( "OverrideMaterials", "models/pi_window/trim128" )
list.Add( "OverrideMaterials", "models/props/cs_assault/dollar" )
list.Add( "OverrideMaterials", "models/props/cs_assault/fireescapefloor" )
list.Add( "OverrideMaterials", "models/props/cs_assault/metal_stairs1" )
list.Add( "OverrideMaterials", "models/props/cs_assault/moneywrap" )
list.Add( "OverrideMaterials", "models/props/cs_assault/moneywrap02" )
list.Add( "OverrideMaterials", "models/props/cs_assault/moneytop" )
list.Add( "OverrideMaterials", "models/props/cs_assault/pylon" )
list.Add( "OverrideMaterials", "models/props/CS_militia/boulder01" )
list.Add( "OverrideMaterials", "models/props/CS_militia/milceil001" )
list.Add( "OverrideMaterials", "models/props/CS_militia/militiarock" )
list.Add( "OverrideMaterials", "models/props/CS_militia/militiarockb" )
list.Add( "OverrideMaterials", "models/props/CS_militia/milwall006" )
list.Add( "OverrideMaterials", "models/props/CS_militia/rocks01" )
list.Add( "OverrideMaterials", "models/props/CS_militia/roofbeams01" )
list.Add( "OverrideMaterials", "models/props/CS_militia/roofbeams02" )
list.Add( "OverrideMaterials", "models/props/CS_militia/roofbeams03" )
list.Add( "OverrideMaterials", "models/props/CS_militia/RoofEdges" )
list.Add( "OverrideMaterials", "models/props/cs_office/clouds" )
list.Add( "OverrideMaterials", "models/props/cs_office/file_cabinet2" )
list.Add( "OverrideMaterials", "models/props/cs_office/file_cabinet3" )
list.Add( "OverrideMaterials", "models/props/cs_office/screen" )
list.Add( "OverrideMaterials", "models/props/cs_office/snowmana" )
list.Add( "OverrideMaterials", "models/props/de_inferno/de_inferno_boulder_03" )
list.Add( "OverrideMaterials", "models/props/de_inferno/infflra" )
list.Add( "OverrideMaterials", "models/props/de_inferno/infflrd" )
list.Add( "OverrideMaterials", "models/props/de_inferno/inftowertop" )
list.Add( "OverrideMaterials", "models/props/de_inferno/offwndwb_break" )
list.Add( "OverrideMaterials", "models/props/de_inferno/roofbits" )
list.Add( "OverrideMaterials", "models/props/de_inferno/tileroof01" )
list.Add( "OverrideMaterials", "models/props/de_inferno/woodfloor008a" )
list.Add( "OverrideMaterials", "models/props/de_nuke/nukconcretewalla" )
list.Add( "OverrideMaterials", "models/props/de_nuke/nukecardboard" )
list.Add( "OverrideMaterials", "models/props/de_nuke/pipeset_metal" )

list.Add( "OverrideMaterials", "models/combinefortifictaionpack/wall01a/metalwall077a" )
list.Add( "OverrideMaterials", "models/combinefortifictaionpack/wall01a/citadel_metalwall090a" )

function TOOL.BuildCPanel( CPanel )

	CPanel:AddControl( "Header", { Description = "#tool.material.help" } )

	CPanel:MatSelect( "material_override", list.Get( "OverrideMaterials" ), true, 64, 64 )

end
