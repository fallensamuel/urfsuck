-- "gamemodes\\rp_base\\gamemode\\addons\\stream_banners\\sh_stream_banners.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
ba.cmd.Create("streambanner", function( pl, args )
	args.banner_id = args[2];
	args.showtext  = args[3];

	rp.StreamBanners.Enable( args.target_streamer, args.banner_id, args.showtext );
end )
:AddParam( "player_steamid", "target_streamer" )
:SetFlag( "e" )
:SetHelp( "Включает баннер для стримера" )


ba.cmd.Create("streambanner_disable", function(pl, args)
	rp.StreamBanners.Enable( args.target_streamer );
end )
:AddParam( "player_steamid", "target_streamer" )
:SetFlag( "e" )
:SetHelp( "Выключает баннер для стримера" )


ba.cmd.Create( "streambanner_text", function( pl, args )
	rp.StreamBanners.Enable( args.target_streamer, 0, args.showtext );
end )
:AddParam( "player_steamid", "target_streamer" )
:AddParam( "string", "showtext" )
:SetFlag( "e" )
:SetHelp( "Переключает отображение текста у баннера для стримера" )


ba.cmd.Create( "streambanner_preview" )
:RunOnClient( function()
	BannersPreview();
end )
:SetFlag( "e" )
:SetHelp( "Предпросмотр баннеров для стримеров" )


--urf streambanner STEAM_0:0:500577012 4
--urf streambanner_text STEAM_0:0:500577012 0