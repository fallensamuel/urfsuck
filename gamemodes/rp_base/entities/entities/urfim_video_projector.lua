-- "gamemodes\\rp_base\\entities\\entities\\urfim_video_projector.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
AddCSLuaFile();


local BaseClass = baseclass.Get( "urfim_video" );

ENT.PrintName = "Projector";
ENT.Category  = "Media";
ENT.Spawnable = false;

ENT.Model     = "models/props_lab/reciever01b.mdl";


function ENT:CanUse( ply )
	return rp.cfg.Theaters[game.GetMap()] and rp.cfg.Theaters[game.GetMap()].AllCanUse or 
		   (ply:Team() == TEAM_KINOMECHANIC or ply:GetJobTable().cinema) or
		   ply:IsSuperAdmin() or
		   ply:IsRoot()
end


if SERVER then
	function ENT:Use( ply )
		if
			self:CanUse( ply )
		then
			BaseClass.Use( self, ply );
		end
	end

	hook.Add( "InitPostEntity", "urfTheater.InitPostEntity", function()
		if not rp.cfg.Theaters[game.GetMap()]           then return end
        if not rp.cfg.Theaters[game.GetMap()].Projector then return end

		local cfg = rp.cfg.Theaters[game.GetMap()].Projector;

		local ent = ents.Create( "urfim_video_projector" );
        ent:SafeSetPos( cfg.Pos );
        ent:SetAngles( cfg.Ang );
        ent:Spawn();
		
		if cfg.Model then
			ent:SetModel(cfg.Model)
		end
		
        ent:SetMoveType( MOVETYPE_NONE );
	end );
end


if CLIENT then
	rp.AddBubble( "entity", "urfim_video_projector", {
		ico      = rp.WebMat:Get( "https://i.imgur.com/OYM5vgZ.png" ),
		name     = translates.Get("Кинотеатр"),
		desc     = translates.Get("[E] Начать взаимодействие"),
		scale    = 0.5,
		customCheck = function( ent )
			if not IsValid(ent) then return end
			return ent:CanUse( LocalPlayer() );
		end
	} );
	
	local cvar_volume  = GetConVar( "volume" );
	local js_SetVolume = [[
        var ytplayer = document.getElementById("movie_player");
        var twplayer = document.getElementsByTagName("video")[0];

        if (ytplayer) {
            ytplayer.setVolume(%s);
        } else if (twplayer) {
            twplayer.volume = %s;
        }
    ]];
	
	function ENT:Initialize()
		BaseClass.Initialize( self );
		hook.Remove( "PostDrawOpaqueRenderables", "urf.im/video/" .. self:EntIndex() );
	end

	function ENT:GetVideoPanel( w, h )
		BaseClass.GetVideoPanel( self, w, h );

		self.ScreenPanel.Imitate3DSound = function( this )
			if not system.HasFocus() then
				this:RunJavascript( string.format( js_SetVolume, 0, 0 ) );
				return
			end
	
			local v;

			if self.Enable3DSound then
				v = (100 - self:GetPos():DistToSqr(LocalPlayer():GetPos()) * 0.0005) * cvar_volume:GetFloat();
			else
				v = 100 * cvar_volume:GetFloat();
			end

			this:RunJavascript( string.format( js_SetVolume, v, v / 100 ) );
		end

		return self.ScreenPanel
	end

	function ENT:DrawScreen() end

    --

	if not rp.cfg.Theaters                then return end
    if not rp.cfg.Theaters[game.GetMap()] then return end

    local cfg = rp.cfg.Theaters[game.GetMap()];

	local ent;
	local CinemaScreen = cfg.Screen;

	if not CinemaScreen then return end
	
	if not CinemaScreen.TopLeft then
		CinemaScreen.Pos = LocalToWorld(
			Vector( -820 * 0.5, 485 * 0.5, 0 ) * CinemaScreen.Scale,
			Angle( 0, 0, 0 ),
			CinemaScreen.Pos,
			CinemaScreen.Ang
		);
	end

	hook.Add( "PostDrawOpaqueRenderables", "urfTheater.PostDrawOpaqueRenderables", function()
		if IsValid( ent ) then
			if ent.Enable3DSound == nil then
				ent.Enable3DSound = (not cfg.Area) and true or false;
			end

			if cfg.Area then
				if not EyePos():WithinAABox( cfg.Area[1], cfg.Area[2] ) then
					if IsValid(ent.ScreenPanel) then ent.ScreenPanel:Remove(); end
					return
				end
			else
				if EyePos():DistToSqr( ent:GetPos() ) > 202500 then -- 450
					if IsValid(ent.ScreenPanel) then ent.ScreenPanel:Remove(); end
					return
				end
			end

			cam.Start3D2D( CinemaScreen.Pos, CinemaScreen.Ang, CinemaScreen.Scale );
				ent:__DrawScreen( 820, 485 );
			cam.End3D2D();
		else
			ent = ents.FindByClass( "urfim_video_projector" )[1];
		end
	end );
end
