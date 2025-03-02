util.AddNetworkString( "net.appearance.BodygroupData" );

local PLAYER = FindMetaTable( "Player" );

function PLAYER:UpdateAppearance()
	self:SetSkin( self:GetVar("SkinIndex") or 0 );

	local mdlScale = self:GetVar("ModelScale") or 1;

	//self:SetModelScale( mdlScale );

    self:SetViewOffset( Appearance_mdlScaleDefaults.ViewOffset * mdlScale );
    self:SetViewOffsetDucked( Appearance_mdlScaleDefaults.ViewOffsetDuck * mdlScale );

	//self:SetHull(
	//	Appearance_mdlScaleDefaults.Hull.min * mdlScale,
	//	Appearance_mdlScaleDefaults.Hull.max * mdlScale
	//);

	//self:SetHullDuck(
	//	Appearance_mdlScaleDefaults.HullDuck.min * mdlScale,
	//	Appearance_mdlScaleDefaults.HullDuck.max * mdlScale
	//);

	self:SetNetVar( "nw_ModelScale", mdlScale );

	-- Reset Bodygroups:
	for i = 1, table.Count(self:GetBodyGroups()) do
		self:SetBodygroup( i, 0 );
	end

	if self:GetVar( "BodygroupData" ) then
		for k, v in pairs( self:GetVar("BodygroupData") ) do
			self:SetBodygroup( k, v );
		end
	end
end

net.Receive( "net.appearance.BodygroupData", function( len, ply )
	if ply:IsCooldownAction("Appearance", 5) then return end

	local appearID = net.ReadUInt( 6 );

	local skin     = net.ReadUInt( 6 );
	local mdlscale = net.ReadFloat();

	local isCustom = net.ReadBool();
	local customUID = net.ReadString();

	local selAppearance = rp.teams[ply:Team()].appearance[appearID or 1] or {};

	if selAppearance.skins then
		if not table.HasValue( selAppearance.skins, skin ) then
			skin = selAppearance.skins[1] or 0;
		end
	end

	if selAppearance.scale then
		mdlscale = math.Clamp( mdlscale, selAppearance.scale[1] or rp.cfg.AppearanceScaleMin, selAppearance.scale[2] or rp.cfg.AppearanceScaleMax );
	else
		mdlscale = math.Clamp( mdlscale, rp.cfg.AppearanceScaleMin, rp.cfg.AppearanceScaleMax );
	end

	local bgroup = {};

	local c = net.ReadUInt( 6 );
	for i = 1, c do
		local id = net.ReadUInt( 6 );
		local v  = net.ReadUInt( 6 );

		if selAppearance.bodygroups then
			if selAppearance.bodygroups[id] then
				if table.HasValue(selAppearance.bodygroups[id], v) then
					bgroup[id] = v;
				end
			end
		else
			bgroup[id] = v;
		end
	end

	ply:SetVar( "SkinIndex", skin );
	ply:SetVar( "ModelScale", mdlscale );
	ply:SetVar( "BodygroupData", bgroup );

	ply:SetVar( "IsCustomModel", customUID ~= '' and ply:HasUpgrade(customUID) )
	
	--if (!isCustom) then
	--	gamemode.Call( "PlayerSetModel", ply );
	--else
	--	if (!ply:GetVar('Model')) then return end
	--	ply:SetModel(ply:GetVar('Model'));
	--end
	ply:UpdateAppearance();

end );