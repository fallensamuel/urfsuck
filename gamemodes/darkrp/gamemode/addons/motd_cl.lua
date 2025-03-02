-- "gamemodes\\darkrp\\gamemode\\addons\\motd_cl.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal

	--local bg = Material('stalker/stalker_bg.jpg')
	local bg = Material('bg/stalker_bg.png', 'noclamp smooth')
	local rocket = Material('bg/rocket.png', 'noclamp smooth')
	
	surface.CreateFont( 'ba.loadscreen', {
		font = "AmazS.T.A.L.K.E.R.v.3.0",
		extended = true,
		size = 55,
		weight = 500,
		blursize = 0,
		scanlines = 0,
		antialias = true,
		underline = false,
		italic = false,
		strikeout = false,
		symbol = false,
		rotary = false,
		shadow = true,
		additive = false,
		outline = false,
	} )
	
	local load_screen
	local PANEL = {};
	function PANEL:Init( )
		self:Dock( FILL );
		self:InvalidateLayout( true );
		self.text = {};
		self:MakePopup( );
		self:SetZPos( 100000 );
		
		local sounds = {
			"player_meet/1.mp3", 
			"player_meet/2.mp3",
			"player_meet/3.mp3",
			"player_meet/4.mp3",
			"player_meet/5.mp3",
			"player_meet/6.mp3",
			"player_meet/7.mp3",
			"player_meet/8.mp3",
			"player_meet/9.mp3",
		}
		
		local messages = {
			{1,'Загрузка'},
			{1,'Загрузка данных игрока'},
			{1,'Соединение с базой данных'},
			{1,'Получение пакета данных'},
			{1,'Проверка данных'},
			{2,'Готово'}
		}
		
		load_screen = true ;
		local function message( )
			if not IsValid( self )then return end

			if (#messages == 0) then 
				self:Remove() 
				load_screen = false
				return 
				
			elseif (#messages == 4) then 
				surface.PlaySound(sounds[math.random(#sounds)])
			end

			local m = table.remove( messages, 1 );
			table.insert( self.text, 1, m[2] );
			timer.Simple( (math.random()*m[1]+m[1])*1/2.5, message );
		end
		timer.Simple( 2, message );
	end

	local rotation = 0
	
	function PANEL:Paint( w, h )
		surface.SetDrawColor(0,0,0)
		surface.DrawRect( 0, 0, w, h );
		
		local x, y = w*0.5, h*0.65;
		for k,v in pairs( self.text )do
			local c = 255-k*255/10;

			draw.SimpleText( v, 'ba.loadscreen', x, y, Color(255, 255, 255, c), TEXT_ALIGN_CENTER );
			y = y + 50;
		end
		table.remove( self.text, 10 );
		
		local t = CurTime();
		surface.SetDrawColor(255,255,255);

		local image_w, image_h = w*.7, w*.7*.562
		surface.SetMaterial(bg)
		surface.DrawTexturedRect(ScrW() / 2 - image_w / 2, ScrH() / 2 - image_h * 0.7, image_w, image_h)
		
		rotation = rotation + RealFrameTime() * 40
		
		local r_x = ScrW() / 2 + math.sin((-rotation - 90) / 360 * math.pi * 2) * image_w * 0.182
		local r_y = ScrH() / 2 - image_h * 0.28 + math.cos((-rotation - 90) / 360 * math.pi * 2) * image_w * 0.182
		
		surface.SetMaterial(rocket)
		surface.DrawTexturedRectRotated(r_x, r_y, image_h * 0.57 * 0.1, image_h * 0.1, -rotation)
	end

	concommand.Add('t',function() ui.Create('ba_loadscreen') end)

	vgui.Register( 'ba_loadscreen', PANEL )

	hook.Add('InitPostEntity', function()
		rp.MOTD = ui.Create('ba_loadscreen')
	end)
