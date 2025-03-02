-- "gamemodes\\darkrp\\gamemode\\addons\\stalker\\sh_foot.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
--Def
util.PrecacheSound("stalker_footstep/default1.wav")
util.PrecacheSound("stalker_footstep/default2.wav")
util.PrecacheSound("stalker_footstep/default3.wav")
util.PrecacheSound("stalker_footstep/default4.wav")
--Earth
util.PrecacheSound("stalker_footstep/earth1.wav")
util.PrecacheSound("stalker_footstep/earth2.wav")
util.PrecacheSound("stalker_footstep/earth3.wav")
util.PrecacheSound("stalker_footstep/earth4.wav")
--Grass
util.PrecacheSound("stalker_footstep/grass1.wav")
util.PrecacheSound("stalker_footstep/grass2.wav")
util.PrecacheSound("stalker_footstep/grass3.wav")
util.PrecacheSound("stalker_footstep/grass4.wav")
--Gravel
util.PrecacheSound("stalker_footstep/gravel1.wav")
util.PrecacheSound("stalker_footstep/gravel2.wav")
util.PrecacheSound("stalker_footstep/gravel3.wav")
util.PrecacheSound("stalker_footstep/gravel4.wav")
--Metal
util.PrecacheSound("stalker_footstep/metal_plate1.wav")
util.PrecacheSound("stalker_footstep/metal_plate2.wav")
util.PrecacheSound("stalker_footstep/metal_plate3.wav")
util.PrecacheSound("stalker_footstep/metal_plate4.wav")
util.PrecacheSound("stalker_footstep/metalgrate1.wav")
util.PrecacheSound("stalker_footstep/metalgrate2.wav")
util.PrecacheSound("stalker_footstep/metalgrate3.wav")
util.PrecacheSound("stalker_footstep/metalgrate4.wav")
--Sand
util.PrecacheSound("stalker_footstep/sand1.wav")
util.PrecacheSound("stalker_footstep/sand2.wav")
util.PrecacheSound("stalker_footstep/sand3.wav")
util.PrecacheSound("stalker_footstep/sand4.wav")
--Slosh
util.PrecacheSound("stalker_footstep/slosh1.wav")
util.PrecacheSound("stalker_footstep/slosh2.wav")
util.PrecacheSound("stalker_footstep/slosh3.wav")
util.PrecacheSound("stalker_footstep/slosh4.wav")
--Tile
util.PrecacheSound("stalker_footstep/tile1.wav")
util.PrecacheSound("stalker_footstep/tile2.wav")
util.PrecacheSound("stalker_footstep/tile3.wav")
util.PrecacheSound("stalker_footstep/tile4.wav")
--Wade
util.PrecacheSound("stalker_footstep/wade1.wav")
util.PrecacheSound("stalker_footstep/wade2.wav")
util.PrecacheSound("stalker_footstep/wade3.wav")
util.PrecacheSound("stalker_footstep/wade4.wav")
--Wood
util.PrecacheSound("stalker_footstep/wood1.wav")
util.PrecacheSound("stalker_footstep/wood2.wav")
util.PrecacheSound("stalker_footstep/wood3.wav")
util.PrecacheSound("stalker_footstep/wood4.wav")
--WoodPanel
util.PrecacheSound("stalker_footstep/woodpanel1.wav")
util.PrecacheSound("stalker_footstep/woodpanel2.wav")
util.PrecacheSound("stalker_footstep/woodpanel3.wav")
util.PrecacheSound("stalker_footstep/woodpanel4.wav")

sound.Add( {
    name 		= "Default.StepLeft",
	channel 	= CHAN_BODY,
	volume		= 1.0,
	level		= 75,
	pitch		= { 90, 110 },
	sound		= { 
		"stalker_footstep/default1.wav",
		"stalker_footstep/default2.wav",
		"stalker_footstep/default3.wav",
		"stalker_footstep/default4.wav",
	}
} )

sound.Add( {
	name 		= "Default.StepRight",
	channel 	= CHAN_BODY,
	volume		= 1.0,
	level		= 75,
	pitch		= { 90, 110 },
	sound		= { 
		"stalker_footstep/default1.wav",
		"stalker_footstep/default2.wav",
		"stalker_footstep/default3.wav",
		"stalker_footstep/default4.wav",
	}
} )

sound.Add( {
	name 		= "Concrete.StepLeft",
	channel 	= CHAN_BODY,
	volume		= 1.0,
	level		= 75,
	pitch		= { 95, 105 },
	sound		= { 
		"stalker_footstep/default1.wav",
		"stalker_footstep/default2.wav",
		"stalker_footstep/default3.wav",
		"stalker_footstep/default4.wav",
	}
} )

sound.Add( {
	name 		= "Concrete.StepRight",
	channel 	= CHAN_BODY,
	volume		= 1.0,
	level		= 75,
	pitch		= { 90, 110 },
	sound		= { 
		"stalker_footstep/default1.wav",
		"stalker_footstep/default2.wav",
		"stalker_footstep/default3.wav",
		"stalker_footstep/default4.wav",
	}
} )

sound.Add( {
	name 		= "SolidMetal.StepLeft",
	channel 	= CHAN_BODY,
	volume		= 1.0,
	level		= 75,
	pitch		= { 90, 110 },
	sound		= { 
		"stalker_footstep/metal_plate1.wav",
		"stalker_footstep/metal_plate2.wav",
		"stalker_footstep/metal_plate3.wav",
		"stalker_footstep/metal_plate4.wav",
	}
} )

sound.Add( {
	name 		= "SolidMetal.StepRight",
	channel 	= CHAN_BODY,
	volume		= 1.0,
	level		= 75,
	pitch		= { 90, 110 },
	sound		= { 
		"stalker_footstep/metal_plate1.wav",
		"stalker_footstep/metal_plate2.wav",
		"stalker_footstep/metal_plate3.wav",
		"stalker_footstep/metal_plate4.wav",
	}
} )

sound.Add( {
	name 		= "MetalGrate.StepLeft",
	channel 	= CHAN_BODY,
	volume		= 1.0,
	level		= 75,
	pitch		= { 90, 110 },
	sound		= { 
		"stalker_footstep/metalgrate1.wav",
		"stalker_footstep/metalgrate2.wav",
		"stalker_footstep/metalgrate3.wav",
		"stalker_footstep/metalgrate4.wav",
	}
} )

sound.Add( {
	name 		= "MetalGrate.StepRight",
	channel 	= CHAN_BODY,
	volume		= 1.0,
	level		= 75,
	pitch		= { 90, 110 },
	sound		= { 
		"stalker_footstep/metalgrate1.wav",
		"stalker_footstep/metalgrate2.wav",
		"stalker_footstep/metalgrate3.wav",
		"stalker_footstep/metalgrate4.wav",
	}
} )

sound.Add( {
	name 		= "Dirt.StepLeft",
	channel 	= CHAN_BODY,
	volume		= 1.0,
	level		= 75,
	pitch		= { 90, 110 },
	sound		= { 
		"stalker_footstep/earth1.wav",
		"stalker_footstep/earth2.wav",
		"stalker_footstep/earth3.wav",
		"stalker_footstep/earth4.wav",
	}
} )

sound.Add( {
	name 		= "Dirt.StepRight",
	channel 	= CHAN_BODY,
	volume		= 1.0,
	level		= 75,
	pitch		= { 90, 110 },
	sound		= { 
		"stalker_footstep/earth1.wav",
		"stalker_footstep/earth2.wav",
		"stalker_footstep/earth3.wav",
		"stalker_footstep/earth4.wav",
	}
} )

sound.Add( {
	name 		= "Mud.StepLeft",
	channel 	= CHAN_BODY,
	volume		= 1.0,
	level		= 75,
	pitch		= { 90, 110 },
	sound		= { 
		"stalker_footstep/earth1.wav",
		"stalker_footstep/earth2.wav",
		"stalker_footstep/earth3.wav",
		"stalker_footstep/earth4.wav",
	}
} )
sound.Add( {
	name 		= "Mud.StepRight",
	channel 	= CHAN_BODY,
	volume		= 1.0,
	level		= 75,
	pitch		= { 90, 110 },
	sound		= { 
		"stalker_footstep/earth1.wav",
		"stalker_footstep/earth2.wav",
		"stalker_footstep/earth3.wav",
		"stalker_footstep/earth4.wav",
	}
} )

sound.Add( {
	name 		= "SlipperySlime.StepLeft",
	channel 	= CHAN_BODY,
	volume		= 1.0,
	level		= 75,
	pitch		= { 90, 110 },
	sound		= { 
		"stalker_footstep/slosh1.wav",
		"stalker_footstep/slosh2.wav",
		"stalker_footstep/slosh3.wav",
		"stalker_footstep/slosh4.wav",
	}
} )

sound.Add( {
	name 		= "SlipperySlime.StepRight",
	channel 	= CHAN_BODY,
	volume		= 1.0,
	level		= 75,
	pitch		= { 90, 110 },
	pitch		= { 90, 110 },
	sound		= { 
		"stalker_footstep/slosh1.wav",
		"stalker_footstep/slosh2.wav",
		"stalker_footstep/slosh3.wav",
		"stalker_footstep/slosh4.wav",
	}
} )

sound.Add( {
	name 		= "Grass.StepLeft",
	channel 	= CHAN_BODY,
	volume		= 1.0,
	level		= 75,
	pitch		= { 90, 110 },
	sound		= { 
		"stalker_footstep/grass1.wav",
		"stalker_footstep/grass2.wav",
		"stalker_footstep/grass3.wav",
		"stalker_footstep/grass4.wav",
	}
} )

sound.Add( {
	name 		= "Grass.StepRight",
	channel 	= CHAN_BODY,
	volume		= 1.0,
	level		= 75,
	pitch		= { 90, 110 },
	sound		= { 
		"stalker_footstep/grass1.wav",
		"stalker_footstep/grass2.wav",
		"stalker_footstep/grass3.wav",
		"stalker_footstep/grass4.wav",
	}
} )

sound.Add( {
	name 		= "Wade.StepLeft",
	channel 	= CHAN_BODY,
	volume		= 1.0,
	level		= 75,
	pitch		= { 90, 110 },
	sound		= { 
		"stalker_footstep/wade1.wav",
		"stalker_footstep/wade2.wav",
		"stalker_footstep/wade3.wav",
		"stalker_footstep/wade4.wav",
	}
} )

sound.Add( {
	name 		= "Wade.StepRight",
	channel 	= CHAN_BODY,
	volume		= 1.0,
	level		= 75,
	pitch		= { 90, 110 },
	sound		= { 
		"stalker_footstep/wade1.wav",
		"stalker_footstep/wade2.wav",
		"stalker_footstep/wade3.wav",
		"stalker_footstep/wade4.wav",
	}
} )

sound.Add( {
	name 		= "Water.StepLeft",
	channel 	= CHAN_BODY,
	volume		= 1.0,
	level		= 75,
	pitch		= { 90, 110 },
	sound		= { 
		"stalker_footstep/wade1.wav",
		"stalker_footstep/wade2.wav",
	}
} )

sound.Add( {
	name 		= "Water.StepRight",
	channel 	= CHAN_BODY,
	volume		= 1.0,
	level		= 75,
	pitch		= { 90, 110 },
	sound		= { 
		"stalker_footstep/wade1.wav",
		"stalker_footstep/wade2.wav",
	}
} )

sound.Add( {
	name 		= "Ladder.StepLeft",
	channel 	= CHAN_BODY,
	volume		= 1.0,
	level		= 75,
	pitch		= { 90, 110 },
	sound		= { 
		"stalker_footstep/metal_plate1.wav",
		"stalker_footstep/metal_plate2.wav",
		"stalker_footstep/metal_plate3.wav",
		"stalker_footstep/metal_plate4.wav",
	}
} )

sound.Add( {
	name 		= "Ladder.StepRight",
	channel 	= CHAN_BODY,
	volume		= 1.0,
	level		= 75,
	pitch		= { 90, 110 },
	sound		= { 
		"stalker_footstep/metal_plate1.wav",
		"stalker_footstep/metal_plate2.wav",
		"stalker_footstep/metal_plate3.wav",
		"stalker_footstep/metal_plate4.wav",
	}
} )

sound.Add( {
	name 		= "MetalVent.StepLeft",
	channel 	= CHAN_BODY,
	volume		= 1.0,
	level		= 75,
	pitch		= { 90, 110 },
	sound		= { 
		"stalker_footstep/metal_plate1.wav",
		"stalker_footstep/metal_plate2.wav",
		"stalker_footstep/metal_plate3.wav",
		"stalker_footstep/metal_plate4.wav",
	}
} )

sound.Add( {
	name 		= "MetalVent.StepRight",
	channel 	= CHAN_BODY,
	volume		= 1.0,
	level		= 75,
	pitch		= { 90, 110 },
	sound		= { 
		"stalker_footstep/metal_plate1.wav",
		"stalker_footstep/metal_plate2.wav",
		"stalker_footstep/metal_plate3.wav",
		"stalker_footstep/metal_plate4.wav",
	}
} )

sound.Add( {
	name 		= "Tile.StepLeft",
	channel 	= CHAN_BODY,
	volume		= 1.0,
	level		= 75,
	pitch		= { 90, 110 },
	sound		= { 
		"stalker_footstep/tile1.wav",
		"stalker_footstep/tile2.wav",
		"stalker_footstep/tile3.wav",
		"stalker_footstep/tile4.wav",
	}
} )

sound.Add( {
	name 		= "Tile.StepRight",
	channel 	= CHAN_BODY,
	volume		= 1.0,
	level		= 75,
	pitch		= { 90, 110 },
	sound		= { 
		"stalker_footstep/tile1.wav",
		"stalker_footstep/tile2.wav",
		"stalker_footstep/tile3.wav",
		"stalker_footstep/tile4.wav",
	}
} )

sound.Add( {
	name 		= "Ladder.WoodStepLeft",
	channel 	= CHAN_BODY,
	volume		= 1.0,
	level		= 75,
	pitch		= { 90, 110 },
	sound		= { 
		"stalker_footstep/wood1.wav",
		"stalker_footstep/wood2.wav",
		"stalker_footstep/wood3.wav",
		"stalker_footstep/wood4.wav",
	}
} )

sound.Add( {
	name 		= "Ladder.WoodStepRight",
	channel 	= CHAN_BODY,
	volume		= 1.0,
	level		= 75,
	pitch		= { 90, 110 },
	sound		= { 
		"stalker_footstep/wood1.wav",
		"stalker_footstep/wood2.wav",
		"stalker_footstep/wood3.wav",
		"stalker_footstep/wood4.wav",
	}
} )

sound.Add( {
	name 		= "Gravel.StepLeft",
	channel 	= CHAN_BODY,
	volume		= 1.0,
	level		= 75,
	pitch		= { 90, 110 },
	sound		= { 
		"stalker_footstep/gravel1.wav",
		"stalker_footstep/gravel2.wav",
		"stalker_footstep/gravel3.wav",
		"stalker_footstep/gravel4.wav",
	}
} )

sound.Add( {
	name 		= "Gravel.StepRight",
	channel 	= CHAN_BODY,
	volume		= 1.0,
	level		= 75,
	pitch		= { 90, 110 },
	sound		= { 
		"stalker_footstep/gravel1.wav",
		"stalker_footstep/gravel2.wav",
		"stalker_footstep/gravel3.wav",
		"stalker_footstep/gravel4.wav",
	}
} )

sound.Add( {
	name 		= "Sand.StepLeft",
	channel 	= CHAN_BODY,
	volume		= 1.0,
	level		= 75,
	pitch		= { 90, 110 },
	sound		= { 
		"stalker_footstep/sand1.wav",
		"stalker_footstep/sand2.wav",
		"stalker_footstep/sand3.wav",
		"stalker_footstep/sand4.wav",
	}
} )

sound.Add( {
	name 		= "Sand.StepRight",
	channel 	= CHAN_BODY,
	volume		= 1.0,
	level		= 75,
	pitch		= { 90, 110 },
	pitch		= { 90, 110 },
	sound		= { 
		"stalker_footstep/sand1.wav",
		"stalker_footstep/sand2.wav",
		"stalker_footstep/sand3.wav",
		"stalker_footstep/sand4.wav",
	}
} )

sound.Add( {
	name 		= "Wood.StepLeft",
	channel 	= CHAN_BODY,
	volume		= 1.0,
	level		= 75,
	pitch		= { 90, 110 },
	sound		= { 
		"stalker_footstep/wood1.wav",
		"stalker_footstep/wood2.wav",
		"stalker_footstep/wood3.wav",
		"stalker_footstep/wood4.wav",
	}
} )

sound.Add( {
	name 		= "Wood.StepRight",
	channel 	= CHAN_BODY,
	volume		= 1.0,
	level		= 75,
	pitch		= { 90, 110 },
	sound		= { 
		"stalker_footstep/wood1.wav",
		"stalker_footstep/wood2.wav",
		"stalker_footstep/wood3.wav",
		"stalker_footstep/wood4.wav",
	}
} )

sound.Add( {
	name 		= "ceiling_tile.StepLeft",
	channel 	= CHAN_BODY,
	volume		= 1.0,
	level		= 75,
	pitch		= { 90, 110 },
	sound		= { 
		"stalker_footstep/default1.wav",
		"stalker_footstep/default2.wav",
		"stalker_footstep/default3.wav",
		"stalker_footstep/default4.wav",
	}
} )

sound.Add( {
	name 		= "ceiling_tile.StepRight",
	channel 	= CHAN_BODY,
	volume		= 1.0,
	level		= 75,
	pitch		= { 90, 110 },
	sound		= { 
		"stalker_footstep/default1.wav",
		"stalker_footstep/default2.wav",
		"stalker_footstep/default3.wav",
		"stalker_footstep/default4.wav",
	}
} )

sound.Add( {
	name 		= "drywall.StepLeft",
	channel 	= CHAN_BODY,
	volume		= 1.0,
	level		= 75,
	pitch		= { 90, 110 },
	sound		= { 
		"stalker_footstep/earth1.wav",
		"stalker_footstep/earth2.wav",
		"stalker_footstep/earth3.wav",
		"stalker_footstep/earth4.wav",
	}
} )

sound.Add( {
	name 		= "drywall.StepRight",
	channel 	= CHAN_BODY,
	volume		= 1.0,
	level		= 75,
	pitch		= { 90, 110 },
	sound		= { 
		"stalker_footstep/earth1.wav",
		"stalker_footstep/earth2.wav",
		"stalker_footstep/earth3.wav",
		"stalker_footstep/earth4.wav",
	}
} )

sound.Add( {
	name 		= "Rubber.StepLeft",
	channel 	= CHAN_BODY,
	volume		= 1.0,
	level		= 75,
	pitch		= { 90, 110 },
	sound		= { 
		"stalker_footstep/earth1.wav",
		"stalker_footstep/earth2.wav",
		"stalker_footstep/earth3.wav",
		"stalker_footstep/earth4.wav",
	}
} )

sound.Add( {
	name 		= "Rubber.StepRight",
	channel 	= CHAN_BODY,
	volume		= 1.0,
	level		= 75,
	pitch		= { 90, 110 },
	sound		= { 
		"stalker_footstep/earth1.wav",
		"stalker_footstep/earth2.wav",
		"stalker_footstep/earth3.wav",
		"stalker_footstep/earth4.wav",
	}
} )

sound.Add( {
	name 		= "Wood_Box.StepLeft",
	channel 	= CHAN_BODY,
	volume		= 1.0,
	level		= 75,
	pitch		= { 90, 95 },
	sound		= { 
		"stalker_footstep/wood1.wav",
		"stalker_footstep/wood2.wav",
		"stalker_footstep/wood3.wav",
		"stalker_footstep/wood4.wav",
	}
} )

sound.Add( {
	name 		= "Wood_Box.StepRight",
	channel 	= CHAN_BODY,
	volume		= 1.0,
	level		= 75,
	pitch		= { 90, 95 },
	sound		= { 
		"stalker_footstep/wood1.wav",
		"stalker_footstep/wood2.wav",
		"stalker_footstep/wood3.wav",
		"stalker_footstep/wood4.wav",
	}
} )

sound.Add( {
	name 		= "Wood_Crate.StepLeft",
	channel 	= CHAN_BODY,
	volume		= 1.0,
	level		= 75,
	pitch		= { 90, 115 },
	sound		= { 
		"stalker_footstep/wood1.wav",
		"stalker_footstep/wood2.wav",
		"stalker_footstep/wood3.wav",
		"stalker_footstep/wood4.wav",
	}
} )

sound.Add( {
	name 		= "Wood_Crate.StepRight",
	channel 	= CHAN_BODY,
	volume		= 1.0,
	level		= 75,
	pitch		= { 90, 115 },
	sound		= { 
		"stalker_footstep/wood1.wav",
		"stalker_footstep/wood2.wav",
		"stalker_footstep/wood3.wav",
		"stalker_footstep/wood4.wav",
	}
} )

sound.Add( {
	name 		= "Wood_Panel.StepLeft",
	channel 	= CHAN_BODY,
	volume		= 1.0,
	level		= 75,
	pitch		= { 90, 115 },
	sound		= { 
		"stalker_footstep/woodpanel1.wav",
		"stalker_footstep/woodpanel2.wav",
		"stalker_footstep/woodpanel3.wav",
		"stalker_footstep/woodpanel4.wav",
	}
} )

sound.Add( {
	name 		= "Wood_Panel.StepRight",
	channel 	= CHAN_BODY,
	volume		= 1.0,
	level		= 75,
	pitch		= { 90, 115 },
	sound		= { 
		"stalker_footstep/woodpanel1.wav",
		"stalker_footstep/woodpanel2.wav",
		"stalker_footstep/woodpanel3.wav",
		"stalker_footstep/woodpanel4.wav",
	}
} )

sound.Add( {
	name 		= "Metal_Box.StepLeft",
	channel 	= CHAN_BODY,
	volume		= 1.0,
	level		= 75,
	pitch		= { 90, 110 },
	sound		= { 
		"stalker_footstep/metal_plate1.wav",
		"stalker_footstep/metal_plate2.wav",
		"stalker_footstep/metal_plate3.wav",
		"stalker_footstep/metal_plate4.wav",
	}
} )

sound.Add( {
	name 		= "Metal_Box.StepRight",
	channel 	= CHAN_BODY,
	volume		= 1.0,
	level		= 75,
	pitch		= { 90, 110 },
	sound		= { 
		"stalker_footstep/metal_plate1.wav",
		"stalker_footstep/metal_plate2.wav",
		"stalker_footstep/metal_plate3.wav",
		"stalker_footstep/metal_plate4.wav",
	}
} )