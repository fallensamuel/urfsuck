/*
   ____          _          _   ____          __  __       _ _                     
  / ___|___   __| | ___  __| | | __ ) _   _  |  \/  | __ _| | |__   ___  _ __ ___  
 | |   / _ \ / _` |/ _ \/ _` | |  _ \| | | | | |\/| |/ _` | | '_ \ / _ \| '__/ _ \ 
 | |__| (_) | (_| |  __/ (_| | | |_) | |_| | | |  | | (_| | | |_) | (_) | | | (_) |
  \____\___/ \__,_|\___|\__,_| |____/ \__, | |_|  |_|\__,_|_|_.__/ \___/|_|  \___/ 
                                      |___/                                        
*/

if not PermaProps then PermaProps = {} end

PermaProps.SpecialENTSSpawn = {}

PermaProps.SpecialENTSSpawn["gmod_lamp"] = function( ent, data)

	ent:SetFlashlightTexture( data["Texture"] )
	ent:SetLightFOV( data["fov"] )
	ent:SetColor( Color( data["r"], data["g"], data["b"], 255 ) )
	ent:SetDistance( data["distance"] )
	ent:SetBrightness( data["brightness"] )
	ent:Switch( true )

	ent:Spawn()

	ent.Texture = data["Texture"]
	ent.KeyDown = data["KeyDown"]
	ent.fov = data["fov"]
	ent.distance = data["distance"]
	ent.r = data["r"]
	ent.g = data["g"]
	ent.b = data["b"]
	ent.brightness = data["brightness"]

	return true

end

PermaProps.SpecialENTSSpawn["prop_vehicle_jeep"] = function( ent, data)

	if ( ent:GetModel() == "models/buggy.mdl" ) then ent:SetKeyValue( "vehiclescript", "scripts/vehicles/jeep_test.txt" ) end
	if ( ent:GetModel() == "models/vehicle.mdl" ) then ent:SetKeyValue( "vehiclescript", "scripts/vehicles/jalopy.txt" ) end

	if ( data["VehicleTable"] && data["VehicleTable"].KeyValues ) then
		for k, v in pairs( data["VehicleTable"].KeyValues ) do
			ent:SetKeyValue( k, v )
		end
	end

	ent:Spawn()
	ent:Activate()

	ent:SetVehicleClass( data["VehicleName"] )
	ent.VehicleName = data["VehicleName"]
	ent.VehicleTable = data["VehicleTable"]
	ent.ClassOverride = data["Class"]

	return true

end
PermaProps.SpecialENTSSpawn["prop_vehicle_jeep_old"] = PermaProps.SpecialENTSSpawn["prop_vehicle_jeep"]
PermaProps.SpecialENTSSpawn["prop_vehicle_airboat"] = PermaProps.SpecialENTSSpawn["prop_vehicle_jeep"]
PermaProps.SpecialENTSSpawn["prop_vehicle_prisoner_pod"] = PermaProps.SpecialENTSSpawn["prop_vehicle_jeep"]

PermaProps.SpecialENTSSpawn["prop_ragdoll"] = function( ent, data )

	if !data or !istable( data ) then return end

	ent:Spawn()
	ent:Activate()
	
	if data["Bones"] then

		for objectid, objectdata in pairs( data["Bones"] ) do

			local Phys = ent:GetPhysicsObjectNum( objectid )
			if !IsValid( Phys ) then continue end
		
			if ( isvector( objectdata.Pos ) && isangle( objectdata.Angle ) ) then

				local pos, ang = LocalToWorld( objectdata.Pos, objectdata.Angle, Vector(0, 0, 0), Angle(0, 0, 0) )
				Phys:SetPos( pos )
				Phys:SetAngles( ang )
				Phys:Wake()

				if objectdata.Frozen then
					Phys:EnableMotion( false )
				end

			end
		
		end

	end

	if data["BoneManip"] and ent:IsValid() then

		for k, v in pairs( data["BoneManip"] ) do

			if ( v.s ) then ent:ManipulateBoneScale( k, v.s ) end
			if ( v.a ) then ent:ManipulateBoneAngles( k, v.a ) end
			if ( v.p ) then ent:ManipulateBonePosition( k, v.p ) end

		end

	end

	if data["Flex"] and ent:IsValid() then

		for k, v in pairs( data["Flex"] ) do
			ent:SetFlexWeight( k, v )
		end

		if ( Scale ) then
			ent:SetFlexScale( Scale )
		end

	end

	return true

end

PermaProps.SpecialENTSSpawn["ent_note"] = function( ent, data )

	if !data or !istable( data ) then return end

	ent:Spawn()
	ent:Activate()

	if data["Text"] then
		ent.Text = data["Text"]
	end

	return true

end


--PermaProps.SpecialENTSSpawn["combine_forcefield"] = function(ent, data)
--	if !data or !istable( data ) then return end
--
--	ent:Spawn()
--	if data.autoClose != nil then
--		ent.autoClose = data.autoClose
--	end
--	if data.invert != nil then
--		ent.invert = data.invert
--	end
--	if data.delay != nil then
--		ent.delay = data.delay
--	end
--	if data.enabled != nil then
--		ent:Disable()
--	end
--end

PermaProps.SpecialENTSSpawn["combine_lock"] = function( ent, data )
	
	if !data or !istable( data ) then return end

	local door

	for k, v in pairs(ents.GetAll()) do
		if v:MapCreationID() == data.id then
			door = v
			break
		end
	end
	if !IsValid(door) then return end

	ent:Spawn()
	ent:setDoor(door, data.pos, data.angles)
	ent:toggle(data.locked)
	ent.defaultState = data.locked
	door:DoorLock(data.locked)
	
	return true

end

PermaProps.SpecialENTSSpawn["ent_textscreen"] = function( ent, data )

	if !data or !istable( data ) then return end

	ent:Spawn()
	ent:Activate()

	--content.Other["Lines"][i] = {}
	--content.Other["Lines"][i].font = ent:GetNetVar("Font" .. i)
	--content.Other["Lines"][i].text = ent:GetNetVar("Text" .. i) or ''
	--content.Other["Lines"][i].r = ent:GetNetVar("r" .. i) or 255
	--content.Other["Lines"][i].g = ent:GetNetVar("g" .. i) or 255
	--content.Other["Lines"][i].b = ent:GetNetVar("b" .. i) or 255
	--content.Other["Lines"][i].a = ent:GetNetVar("a" .. i) or 255
	--content.Other["Lines"][i].size = math_Clamp(ent:GetNetVar("size" .. i) or 100, 1, 100)
	
	if data["Lines"] then

		local fonts = {}
		local colors = {}
		local sizes = {}
		local texts = {}

		for k, v in pairs(data["Lines"] or {}) do
			fonts[k] = v.font
			colors[k] = Color(v.r, v.g, v.b, v.a)
			sizes[k] = v.size
			texts[k] = v.text
		end
		ent:UpdateText(fonts, texts, colors, sizes)

	end

	return true

end

PermaProps.SpecialENTSSpawn["NPC"] = function( ent, data )

	if data and istable( data ) then

		if data["Equipment"] then

			local valid = false
			for _, v in pairs( list.Get( "NPCUsableWeapons" ) ) do
				if v.class == data["Equipment"] then valid = true break end
			end

			if ( data["Equipment"] && data["Equipment"] != "none" && valid ) then
				ent:SetKeyValue( "additionalequipment", data["Equipment"] )
				ent.Equipment = data["Equipment"] 
			end

		end

	end

	ent:Spawn()
	ent:Activate()

	return true

end

if list.Get( "NPC" ) and istable(list.Get( "NPC" )) then

	for k, v in pairs(list.Get( "NPC" )) do
		
		PermaProps.SpecialENTSSpawn[k] = PermaProps.SpecialENTSSpawn["NPC"]

	end

end

PermaProps.SpecialENTSSpawn["npc_combine_camera"] = function( ent, data)

	ent:Fire('SetDamageFilter', 'FilterDamage', 0)
	ent:Spawn()

	return true

end


PermaProps.SpecialENTSSpawn["item_ammo_crate"] = function( ent, data )

	if data and istable(data) and data["type"] then

		ent.type = data["type"]
		ent:SetKeyValue( "AmmoType", math.Clamp( data["type"], 0, 9 ) )

	end

	ent:Spawn()
	ent:Activate()
	
	return true

end


PermaProps.SpecialENTSSave = {}

--PermaProps.SpecialENTSSpawn["combine_forcefield"] = function(ent)
--	local content = {}
--	content.Other = {}
--	content.Other["autoClose"] = ent.autoClose
--	content.Other["invert"] = ent.invert
--	content.Other["delay"] = ent.delay
--
--	return content
--end

PermaProps.SpecialENTSSave["combine_lock"] = function( ent )

	local content = {}
	content.Other = {}
	content.Other["id"] = ent:GetParent():MapCreationID()
	content.Other["pos"] = ent:GetPos()
	content.Other["angles"] = ent:GetAngles()
	content.Other["locked"] = ent:GetLocked()

	return content
end


PermaProps.SpecialENTSSave["gmod_lamp"] = function( ent )

	local content = {}
	content.Other = {}
	content.Other["Texture"] = ent.Texture
	content.Other["KeyDown"] = ent.KeyDown
	content.Other["fov"] = ent.fov
	content.Other["distance"] = ent.distance
	content.Other["r"] = ent.r
	content.Other["g"] = ent.g
	content.Other["b"] = ent.b
	content.Other["brightness"] = ent.brightness

	return content

end

PermaProps.SpecialENTSSave["prop_vehicle_jeep"] = function( ent )

	if not ent.VehicleTable then return false end

	local content = {}
	content.Other = {}
	content.Other["VehicleName"] = ent.VehicleName
	content.Other["VehicleTable"] = ent.VehicleTable
	content.Other["ClassOverride"] = ent.ClassOverride

	return content

end
PermaProps.SpecialENTSSave["prop_vehicle_jeep_old"] = PermaProps.SpecialENTSSave["prop_vehicle_jeep"]
PermaProps.SpecialENTSSave["prop_vehicle_airboat"] = PermaProps.SpecialENTSSave["prop_vehicle_jeep"]
PermaProps.SpecialENTSSave["prop_vehicle_prisoner_pod"] = PermaProps.SpecialENTSSave["prop_vehicle_jeep"]

PermaProps.SpecialENTSSave["prop_ragdoll"] = function( ent )

	local content = {}
	content.Other = {}
	content.Other["Bones"] = {}

	local num = ent:GetPhysicsObjectCount()
	for objectid = 0, num - 1 do

		local obj = ent:GetPhysicsObjectNum( objectid )
		if ( !obj:IsValid() ) then continue end

		content.Other["Bones"][ objectid ] = {}

		content.Other["Bones"][ objectid ].Pos = obj:GetPos()
		content.Other["Bones"][ objectid ].Angle = obj:GetAngles()
		content.Other["Bones"][ objectid ].Frozen = !obj:IsMoveable()
		if ( obj:IsAsleep() ) then content.Other["Bones"][ objectid ].Sleep = true end

		content.Other["Bones"][ objectid ].Pos, content.Other["Bones"][ objectid ].Angle = WorldToLocal( content.Other["Bones"][ objectid ].Pos, content.Other["Bones"][ objectid ].Angle, Vector( 0, 0, 0 ), Angle( 0, 0, 0 ) )

	end

	if ( ent:HasBoneManipulations() ) then
	
		content.Other["BoneManip"] = {}

		for i = 0, ent:GetBoneCount() do
	
			local t = {}
		
			local s = ent:GetManipulateBoneScale( i )
			local a = ent:GetManipulateBoneAngles( i )
			local p = ent:GetManipulateBonePosition( i )
		
			if ( s != Vector( 1, 1, 1 ) ) then t[ 's' ] = s end -- scale
			if ( a != Angle( 0, 0, 0 ) ) then t[ 'a' ] = a end -- angle
			if ( p != Vector( 0, 0, 0 ) ) then t[ 'p' ] = p end -- position
	
			if ( table.Count( t ) > 0 ) then
				content.Other["BoneManip"][ i ] = t
			end
	
		end

	end

	content.Other["FlexScale"] = ent:GetFlexScale()
	for i = 0, ent:GetFlexNum() do

		local w = ent:GetFlexWeight( i )
		if ( w != 0 ) then
			content.Other["Flex"] = content.Other["Flex"] or {}
			content.Other["Flex"][ i ] = w
		end

	end

	return content

end

PermaProps.SpecialENTSSave["ent_textscreen"] = function( ent )
	
	local content = {Other = {}}

	content.Other["Lines"] = {}

	for i = 1, 3 do
		if ent:GetNetVar("Text" .. i) ~= "" then
			content.Other["Lines"][i] = {}
			content.Other["Lines"][i].font = ent:GetNetVar("Font" .. i)
			content.Other["Lines"][i].text = ent:GetNetVar("Text" .. i) or ''
			content.Other["Lines"][i].r = ent:GetNetVar("r" .. i) or 255
			content.Other["Lines"][i].g = ent:GetNetVar("g" .. i) or 255
			content.Other["Lines"][i].b = ent:GetNetVar("b" .. i) or 255
			content.Other["Lines"][i].a = ent:GetNetVar("a" .. i) or 255
			content.Other["Lines"][i].size = math.Clamp(ent:GetNetVar("size" .. i) or 100, 1, 100)
		else
			content.Other["Lines"][i] = nil
		end
	end

	return content

end

PermaProps.SpecialENTSSave["prop_effect"] = function( ent )

	local content = {}
	content.Class = "pp_prop_effect"
	content.Model = ent.AttachedEntity:GetModel()

	return content

end
PermaProps.SpecialENTSSave["pp_prop_effect"] = PermaProps.SpecialENTSSave["prop_effect"]

PermaProps.SpecialENTSSave["NPC"] = function( ent )

	if !ent.Equipment then return {} end

	local content = {}
	content.Other = {}
	content.Other["Equipment"] = ent.Equipment

	return content

end

if list.Get( "NPC" ) and istable(list.Get( "NPC" )) then

	for k, v in pairs(list.Get( "NPC" )) do
		
		PermaProps.SpecialENTSSave[k] = PermaProps.SpecialENTSSave["NPC"]

	end

end

PermaProps.SpecialENTSSave["item_ammo_crate"] = function( ent )

	local content = {}
	content.Other = {}
	content.Other["type"] = ent.type

	return content

end

PermaProps.SpecialENTSSave["ent_note"] = function( ent )
	
	local content = {Other = {}}
	content.Other["Text"] = ent.Text

	return content


end

// NOTIBOARD

PermaProps.SpecialENTSSpawn["bt_notiboard_big"] = function( ent, data )

	if !data or !istable( data ) then return end

	ent:Spawn()
	ent:Activate()

	if data["title"] then
		ent:SetNWString("title", data["title"])
	end
	if data["text"] then
		ent:SetNWString("text", data["text"])
	end

	return true

end
PermaProps.SpecialENTSSpawn["bt_notiboard_css"] = PermaProps.SpecialENTSSpawn["bt_notiboard_big"]
PermaProps.SpecialENTSSpawn["bt_notiboard_medium"] = PermaProps.SpecialENTSSpawn["bt_notiboard_big"]
PermaProps.SpecialENTSSpawn["bt_notiboard_small"] = PermaProps.SpecialENTSSpawn["bt_notiboard_big"]

PermaProps.SpecialENTSSave["bt_notiboard_big"] = function( ent )
	
	local content = {Other = {}}
	content.Other["title"] = ent:GetNWString("title")
	content.Other["text"] = ent:GetNWString("text")

	return content


end
PermaProps.SpecialENTSSave["bt_notiboard_css"] = PermaProps.SpecialENTSSave["bt_notiboard_big"]
PermaProps.SpecialENTSSave["bt_notiboard_medium"] = PermaProps.SpecialENTSSave["bt_notiboard_big"]
PermaProps.SpecialENTSSave["bt_notiboard_small"] = PermaProps.SpecialENTSSave["bt_notiboard_big"]
