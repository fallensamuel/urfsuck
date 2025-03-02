Appearance_mdlScaleDefaults = {
	Hull = {
		min = Vector( -16, -16,  0 ),
		max = Vector(  16,  16, 72 )
	},

	HullDuck = {
		min = Vector( -16, -16,  0 ),
		max = Vector(  16,  16, 36 )
	},

	ViewOffset     = Vector( 0, 0, 64 );
	ViewOffsetDuck = Vector( 0, 0, 28 );
};

--include( "plib/libraries/nw.lua" );

nw_mdlScaleVar = nw.Register( "nw_ModelScale" );
nw_mdlScaleVar:SetPlayer();

nw_mdlScaleVar:Write( function( var )
    net.WriteFloat( var )
end );

nw_mdlScaleVar:Read( function()
    return net.ReadFloat();
end );

nw_mdlScaleVar:SetHook("ApplyScale")

if CLIENT then
    hook.Add( "ApplyScale", function( ply, mdlScale )
		--[[
        local mat = Matrix();

        local scale = Vector( 1, 1, 1 ) * mdlScale;
        mat:Scale( scale );
        
        ply:EnableMatrix( "RenderMultiply", mat );
		]]--
		
		if isnumber(ply) or not IsValid(ply) or not isnumber(mdlScale) then return end
		
		ply:SetModelScale( mdlScale );
		hook.Run( "OnAppearanceUpdated", ply );
    end );
end