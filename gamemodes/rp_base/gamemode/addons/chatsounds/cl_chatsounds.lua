-- "gamemodes\\rp_base\\gamemode\\addons\\chatsounds\\cl_chatsounds.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
--[[
local function ClientDoVoice(id)
	net.Start('rp.DoVoice')
		net.WriteInt(id, 8)
	net.SendToServer()
end

chatsound_fr = chatsound_fr or nil
chatsound_scroll = chatsound_scroll or nil
local cur_team = cur_team or nil
local c = c or 0
buttons = buttons or {}

hook('ContextMenuCreated', function(cont)
	chatsound_fr = ui.Create('ui_frame', function(self, p)
		self:SetPos(ScrW() - self:GetWide() - 5 , ScrH() / 2 - self:GetTall() / 2)
		self:ShowCloseButton(false)
		self:SetTitle("Речь")
		self:SetSize(150, ScrH() * 0.8)
		self:SetPos(ScrW() - self:GetWide() - 5, ScrH() / 2 - self:GetTall() / 2)
	end, cont)

	chatsound_scroll = ui.Create('ui_scrollpanel', function(self)
		self:DockMargin(0, 3, 0, 0)
		self:Dock(FILL)
	end, chatsound_fr)
	c = 0

end)

hook('OnContextMenuOpen', function()
	if cur_team != (LocalPlayer():DisguiseTeam() or LocalPlayer():Team()) and IsValid(chatsound_fr) and IsValid(chatsound_scroll) then
	
		for k,v in pairs(buttons) do
			v:Remove()
		end
		
		c = 0
		cur_team = (LocalPlayer():DisguiseTeam() or LocalPlayer():Team())
		
		for k, v in ipairs(rp.Voices[cur_team] || rp.Voices[0]) do

			if v.label then
				buttons[c] = ui.Create('DButton', function(self)
					self:SetSize(90, 30)
					self:SetText(v.label)
					self.DoClick = function() ClientDoVoice(k) end
					chatsound_scroll:AddItem(self)
					--	print(v.label)
					if v.broadcast then
					--	print(1)
						self:SetBackgroundColor(Color(200, 0, 0))
					end
				end)

				c = c + 1
			end
		end
	end
end)
]]--

if rp.cfg.DisableContextRedisign then
	local speach_txt = translates and translates.Get("Речь") or "Речь"
	
	rp.AddContextCategory( speach_txt, nil, RIGHT );

	local function chatsounds_ClientDoVoice( id )
		net.Start( "rp.DoVoice" );
			net.WriteInt( id, 8 );
		net.SendToServer();
	end

	local chatsounds_CurrentTeam = chatsounds_CurrentTeam or nil;
	local chatsounds_MemGroups   = {};

	hook( "OnContextMenuOpen", function()
		if chatsounds_CurrentTeam ~= (LocalPlayer():DisguiseTeam() or LocalPlayer():Team()) then
			chatsounds_CurrentTeam = (LocalPlayer():DisguiseTeam() or LocalPlayer():Team());

			rp.FlushContextCommands( speach_txt );
			chatsounds_MemGroups = {};

			local chatsounds_Categories = {};

			for k, v in pairs( rp.Voices[chatsounds_CurrentTeam] or rp.Voices[0] ) do
				v.category = v.category or (translates and translates.Get("Общее") or "Общее");
				chatsounds_Categories[v.category]    = chatsounds_Categories[v.category] or {};
				chatsounds_Categories[v.category][k] = true;

				chatsounds_MemGroups[v.category] = false;
			end

			for csCategoryName, csSoundIDs in pairs( chatsounds_Categories ) do
				rp.AddContextCommandGroup(
					speach_txt,
					csCategoryName,
					function( p )
						p.OnToggle = function( self )
							timer.Simple(0, function()
								self:GetParent():SetTall(20);
								self:GetParent():GetParent():PerformLayout();
							end );

							chatsounds_MemGroups[csCategoryName] = self:GetExpanded();
						end

						for csSoundID in pairs( csSoundIDs ) do
							local csSound = (rp.Voices[chatsounds_CurrentTeam] or rp.Voices[0])[csSoundID];
							
							local btn = ui.Create("DButton", function( self )
								self:Dock( TOP );
								self:SetText( csSound.label or '...' );
								self.DoClick = function()
									chatsounds_ClientDoVoice( csSoundID );
								end
							end, p );
						end

						p:SetExpanded( chatsounds_MemGroups[csCategoryName] or true );
					end
				);
			end

			rp.RefreshContextMenu();
		end
	end );
else
	local function chatsounds_ClientDoVoice( id )
		net.Start( "rp.DoVoice" );
			net.WriteInt( id, 8 );
		net.SendToServer();
	end


	local chatsounds_CurrentTeam = chatsounds_CurrentTeam or nil;
	local chatsounds_MemGroups   = {};


	hook( "PopulateContextMenu", function( gContextMenu )
		rp.ContextMenu.Panels.ChatSounds = vgui.Create( "Panel", gContextMenu );
		rp.ContextMenu.Panels.ChatSounds.Paint = function( this, w, h )
			draw.Blur( this );
			surface.SetDrawColor( rpui.UIColors.Background );
			surface.DrawRect( 0, 0, w, h );
		end

		rp.ContextMenu.Panels.ChatSounds.Title = vgui.Create( "DLabel", rp.ContextMenu.Panels.ChatSounds );
		rp.ContextMenu.Panels.ChatSounds.Title:Dock( TOP );
		rp.ContextMenu.Panels.ChatSounds.Title:InvalidateParent( true );
		rp.ContextMenu.Panels.ChatSounds.Title:SetText( translates and translates.Get("ГОЛОСОВЫЕ КОМАНДЫ") or "ГОЛОСОВЫЕ КОМАНДЫ" );
		rp.ContextMenu.Panels.ChatSounds.Title.Paint = function( this, w, h )
			surface.SetDrawColor(rp.cfg.UIColor.BlockHeader);
			surface.DrawRect( 0, 0, w, h );
			draw.SimpleText( this:GetText(), this:GetFont(), w * 0.5, h * 0.5, rpui.UIColors.White, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
			return true
		end

		rp.ContextMenu.Panels.ChatSounds.Content = vgui.Create( "rpui.ScrollPanel", rp.ContextMenu.Panels.ChatSounds );
		rp.ContextMenu.Panels.ChatSounds.Content:Dock( FILL );
		rp.ContextMenu.Panels.ChatSounds.Content:InvalidateParent( true );
		rp.ContextMenu.Panels.ChatSounds.Content:AlwaysLayout( true );
	end );


	hook( "RefreshContextMenu", function()
		local frameW, frameH = ScrW() * 0.175, ScrH() * 0.5;
		local frameSpacing   = frameH * 0.01;

		surface.CreateFont( "ChatSound.Title", {
			font = "Montserrat",
			size = ScrH() * 0.025,
			weight = 800,
			extended = true,
		} );

		surface.CreateFont( "ChatSound.Drawer", {
			font = "Montserrat",
			--font = "Montserrat ExtraBold",
			size = frameH * 0.05,
			weight = 600,
			extended = true,
		} );

		surface.CreateFont( "ChatSound.SoundName", {
			font = "Montserrat",
			--font = "Montserrat SemiBold",
			size = frameH * 0.045,
			weight = 400,
			extended = true,
		} );
		
		rp.ContextMenu.Panels.ChatSounds:SetSize( frameW, frameH * 1.5 );
		rp.ContextMenu.Panels.ChatSounds:CenterVertical();
		rp.ContextMenu.Panels.ChatSounds.x = 0;

		rp.ContextMenu.Panels.ChatSounds.Title:SetFont( "ChatSound.Title" );
		rp.ContextMenu.Panels.ChatSounds.Title:SizeToContentsY( frameSpacing * 6 );

		rp.ContextMenu.Panels.ChatSounds.Content:SetScrollbarMargin( frameSpacing );
		rp.ContextMenu.Panels.ChatSounds.Content:DockMargin( frameSpacing * 2, frameSpacing * 2, frameSpacing * 2, frameSpacing * 2 );
		rp.ContextMenu.Panels.ChatSounds.Content:InvalidateParent( true );

		if chatsounds_CurrentTeam ~= (LocalPlayer():DisguiseTeam() or LocalPlayer():Team()) then
			chatsounds_CurrentTeam = (LocalPlayer():DisguiseTeam() or LocalPlayer():Team());

			rp.ContextMenu.Panels.ChatSounds.Content:ClearItems();
			chatsounds_MemGroups   = {};

			local chatsounds_Categories = {};

			for k, v in pairs( rp.Voices[chatsounds_CurrentTeam] or rp.Voices[0] ) do
				v.category = v.category or (translates and translates.Get("Общее") or "Общее");

				chatsounds_Categories[v.category]    = chatsounds_Categories[v.category] or {};
				chatsounds_Categories[v.category][k] = true;

				chatsounds_MemGroups[v.category] = false;
			end

			for csCategoryName, csSoundIDs in pairs( chatsounds_Categories ) do
				local CategoryDrawer = vgui.Create( "rpui.VerticalDrawer" );
				CategoryDrawer:SetExpanded( chatsounds_MemGroups[csCategoryName] or true );
				CategoryDrawer:Dock( TOP );
				CategoryDrawer.Drawer:SetFont( "ChatSound.Drawer" );
				CategoryDrawer.Drawer:SetText( string.utf8upper(csCategoryName) );
				CategoryDrawer.Drawer:SizeToContentsY( frameSpacing * 4 );
				CategoryDrawer.Drawer.Paint = function( this, w, h )
					this.Selected = this:GetParent():GetExpanded();
					local baseColor, textColor = rpui.GetPaintStyle( this, STYLE_TRANSPARENT_SELECTABLE );
					surface.SetDrawColor( baseColor );
					surface.DrawRect( 0, 0, w, h );
					local tW, tH = draw.SimpleText( this:GetText(), this:GetFont(), w * 0.5, h * 0.5, textColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
					--draw.SimpleText( (this.Selected and " ⯅" or " ⯆" ), this:GetFont(), w * 0.5 + tW * 0.5 + frameSpacing * 2, h * 0.5, textColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
					return true
				end
				CategoryDrawer.OnToggle = function( this )
					chatsounds_MemGroups[csCategoryName] = this:GetExpanded();
					CategoryDrawer.Drawer:SetText( string.utf8upper(csCategoryName) );
				end
				CategoryDrawer.Content.Paint = function( this, w, h )
					surface.SetDrawColor( rpui.UIColors.Background );
					surface.DrawRect( 0, 0, w, h );
				end

				rp.ContextMenu.Panels.ChatSounds.Content:AddItem( CategoryDrawer );

				for csSoundID in pairs( csSoundIDs ) do
					local csSound = (rp.Voices[chatsounds_CurrentTeam] or rp.Voices[0])[csSoundID];
					
					local btn = vgui.Create( "DButton" );
					btn:Dock( TOP );
					btn:DockMargin( 0, 0, 0, frameSpacing );
					btn:SetFont( "ChatSound.SoundName" );
					btn:SetText( csSound.label or '...' );
					btn:SizeToContentsY( frameSpacing );
					btn.Paint = function( this, w, h )
						local baseColor, textColor = rpui.GetPaintStyle( this, STYLE_TRANSPARENT_INVERTED );
						surface.SetDrawColor( baseColor );
						surface.DrawRect( 0, 0, w, h );
						draw.SimpleText( this:GetText(), this:GetFont(), w * 0.5 --[[frameSpacing * 2]], h * 0.5, textColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
						return true
					end
					btn.DoClick = function( this )
						chatsounds_ClientDoVoice( csSoundID );
					end

					CategoryDrawer:AddItem( btn );
				end
			end
		end
	end );
end