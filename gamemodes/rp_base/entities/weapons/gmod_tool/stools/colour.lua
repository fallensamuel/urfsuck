-- "gamemodes\\rp_base\\entities\\weapons\\gmod_tool\\stools\\colour.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
TOOL.Category = "Render"
TOOL.Name = "#tool.colour.name"

TOOL.ClientConVar[ "r" ] = 255
TOOL.ClientConVar[ "g" ] = 0
TOOL.ClientConVar[ "b" ] = 255
TOOL.ClientConVar[ "a" ] = 255

local bad_materials = {
	["models/wireframe"] 							= true,
	["Models/effects/comball_sphere"] 				= true,
	["Models/effects/comball_tape"] 				= true,
	["Models/effects/splodearc_sheet"] 				= true,
	["models/props_combine/portalball001_sheet"]	= true,
	["models/props_combine/stasisfield_beam"]		= true,
}

local function SetColour( Player, Entity, Data )

	if bad_materials[Entity:GetMaterial()] then Player:PrintMessage(HUD_PRINTTALK, "Смена цвета для пропов с этим материалом заблокированна!") return end

	if ( Data.Color ) then Entity:SetColor( Color( Data.Color.r, Data.Color.g, Data.Color.b, math.Clamp(Data.Color.a, 5, 255)) ) end

	if ( SERVER ) then
		duplicator.StoreEntityModifier( Entity, "colour", Data )
	end

end
duplicator.RegisterEntityModifier( "colour", SetColour )

function TOOL:LeftClick( trace )

	local ent = trace.Entity
	if ( IsValid( ent.AttachedEntity ) ) then ent = ent.AttachedEntity end

	if IsValid( ent ) then -- The entity is valid and isn't worldspawn

		if ( CLIENT ) then return true end

		local r = self:GetClientNumber( "r", 0 )
		local g = self:GetClientNumber( "g", 0 )
		local b = self:GetClientNumber( "b", 0 )
		local a = self:GetClientNumber( "a", 0 )

		SetColour( self:GetOwner(), ent, { Color = Color( r, g, b, a )})

		return true

	end

end

function TOOL:RightClick( trace )

	local ent = trace.Entity
	if ( IsValid( ent.AttachedEntity ) ) then ent = ent.AttachedEntity end

	if IsValid( ent ) then -- The entity is valid and isn't worldspawn

		if ( CLIENT ) then return true end

		SetColour( self:GetOwner(), ent, { Color = Color( 255, 255, 255, 255 ), RenderMode = 0, RenderFX = 0 } )
		return true

	end

end

local ConVarsDefault = TOOL:BuildConVarList()

function TOOL.BuildCPanel( CPanel )
	CPanel:AddControl( "Header", { Description	= "#tool.colour.desc" } )

	CPanel:AddControl( "ComboBox", { MenuButton = 1, Folder = "colour", Options = { [ "#preset.default" ] = ConVarsDefault }, CVars = table.GetKeys( ConVarsDefault ) } )

	CPanel:AddControl( "Color", { Label = "#tool.colour.color", Red = "colour_r", Green = "colour_g", Blue = "colour_b", Alpha = "colour_a" } )
end

--[[
concommand.Add('transparent',function(ply)
	if ply:GetEyeTrace() then
		ply:GetEyeTrace().Entity:SetColor( Color( 0, 255, 0, 0 ) )
		ply:GetEyeTrace().Entity:SetRenderMode( RENDERMODE_TRANSALPHA )
	end
end)
]]--