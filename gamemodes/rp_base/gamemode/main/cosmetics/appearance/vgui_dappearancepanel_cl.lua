-- "gamemodes\\rp_base\\gamemode\\main\\cosmetics\\appearance\\vgui_dappearancepanel_cl.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
function InverseLerp( pos, p1, p2 )

	local range = 0
	range = p2-p1

	if range == 0 then return 1 end

	return ((pos - p1)/range)

end

local PANEL = {}

rp.cfg.Dictionary = rp.cfg.Dictionary or {};

function PANEL:GetTranslation( str )
	local KeyTranslations = table.GetKeys( rp.cfg.Dictionary );
	local out             = str;

	for k, v in pairs( rp.cfg.Dictionary ) do
		local key = table.GetKeys( v )[1];

		if string.find( string.lower(str), string.lower(key) ) then
			out = v[key]
		end
	end

	return out;
end

PANEL.SliderSkin = function( this, w, h, values )
	local parent = this:GetParent();

	draw.RoundedBox( 2, 8, h/2-3, w-16, 6, Color(0,0,0,150) );

	local fillPercentage = (parent:GetValue() - parent:GetMin()) / (parent:GetMax() - parent:GetMin());

	draw.RoundedBox( 2, 8, h/2-3, (w-16) * fillPercentage, 6, Color(0,108,255,150) );

	surface.SetDrawColor( Color(0,0,0,150) );

	if not values then
		draw.SimpleText( math.Round(parent:GetValue(), parent:GetDecimals()), "DermaDefault", (w-16) * fillPercentage + 8, h/2+5, Color(0,108,255,150), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP );
	end

	for i = 0, parent:GetRange() do
		local s = (w-16)/parent:GetRange();

		if values then
			if i == parent:GetValue()-1 then
				draw.SimpleText( values[i+1], "DermaDefault", (i*s), h/2+5, Color(0,108,255,150), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP );
			end
		end
	end
end

PANEL._appearance = {
	selected = 1,
	mdl  	= "",
	mdlscale = 1,
	skin 	= 0,
	bgroups = {}
};
PANEL.AppearanceData = {};
PANEL.JobData        = {};


function PANEL:SelectAppearance( n, data )
	if not data then
		if not self.AppearanceData[n] then return end

		self._appearance.selected = n;
		self._appearance.mdl      = self.AppearanceData[n].mdl;
		self._appearance.mdlscale = 1;
		self._appearance.skin     = 0;
		self._appearance.bgroups  = {};
	else

		if data.bgroups && self.AppearanceData[n].bodygroups then
			for k, v in pairs(data.bgroups) do
				if !(self.AppearanceData[n].bodygroups[k] && table.HasValue(self.AppearanceData[n].bodygroups[k], v)) then
					data.bgroups[k] = nil
				end
			end
		end

		if data.skin && self.AppearanceData[n].skins then
			if !table.HasValue(self.AppearanceData[n].skins) then
				data.skin = 0
			end
		end

		self._appearance = data;
		n = self._appearance.selected

		if not self.AppearanceData[n] then 
			cookie.Delete("urf" .. "-" .. util.CRC(game.GetIPAddress()) .. "-" ..  self.JobData.command .. "-" .. util.CRC(string.lower(self._appearance.mdl)))
			return 
		end

	end

	self.ModelViewer:SetModel( self._appearance.mdl );



	if self.ModelViewer.Entity:SkinCount() > 1 then
		if self.AppearanceData[n].skins && #self.AppearanceData[n].skins == 1 then 
			self._appearance.skin = 1
			self:UpdateAppearanceModel(); 
			if IsValid(self.ControlPanel.Content.SkinSelectorTitle) and IsValid(self.ControlPanel.Content.SkinSelector) then
				self.ControlPanel.Content.SkinSelectorTitle:Remove()
				self.ControlPanel.Content.SkinSelector:Remove()
			end 
		else
			if !IsValid(self.ControlPanel.Content.SkinSelectorTitle) and !IsValid(self.ControlPanel.Content.SkinSelector) then
				self.ControlPanel.Content.SkinSelectorTitle = vgui.Create( "DLabel", self.ControlPanel.Content );
					local ctrlSkinSelectorTitleLabel = self.ControlPanel.Content.SkinSelectorTitle;
					ctrlSkinSelectorTitleLabel:SetText( "Скин" );
					ctrlSkinSelectorTitleLabel:SetFont( "Trebuchet24" );
					ctrlSkinSelectorTitleLabel:SetContentAlignment( 4 );
					ctrlSkinSelectorTitleLabel:SizeToContentsY();
				self.ControlPanel.Content:AddItem( ctrlSkinSelectorTitleLabel );

				self.ControlPanel.Content.SkinSelector = vgui.Create( "DNumSlider", self.ControlPanel.Content );
					local ctrlSkinSelector = self.ControlPanel.Content.SkinSelector;
					ctrlSkinSelector.Label:Hide();
					ctrlSkinSelector.TextArea:Hide();
					ctrlSkinSelector:DockMargin( 0, 0, 0, 5 );
					ctrlSkinSelector:SetDecimals( 0 );
					ctrlSkinSelector.OnValueChanged = function( this, val )
					val = math.Round(val);
					this:SetValue( val );
					self._appearance.skin = val;
					self:UpdateAppearanceModel();
					end
				self.ControlPanel.Content:AddItem( ctrlSkinSelector );
			end

			if self.AppearanceData[n].skins then
				self.ControlPanel.Content.SkinSelector:SetMin( 1 );
				self.ControlPanel.Content.SkinSelector:SetMax( #self.AppearanceData[n].skins );
				self.ControlPanel.Content.SkinSelector.Slider.Paint = function( this, w, h ) self.SliderSkin( this, w, h, self.AppearanceData[n].skins ); end
			else
				self.ControlPanel.Content.SkinSelector:SetMin( 0 );
				self.ControlPanel.Content.SkinSelector:SetMax( self.ModelViewer.Entity:SkinCount()-1 );
				self.ControlPanel.Content.SkinSelector.Slider.Paint = function( this, w, h ) self.SliderSkin( this, w, h, self.AppearanceData[n].skins ); end
			end

			self.ControlPanel.Content.SkinSelector:SetValue( math.max(self._appearance.skin, self.ControlPanel.Content.SkinSelector:GetMin()) );
		end
	else
		if IsValid(self.ControlPanel.Content.SkinSelectorTitle) and IsValid(self.ControlPanel.Content.SkinSelector) then
			self.ControlPanel.Content.SkinSelectorTitle:Remove();
			self.ControlPanel.Content.SkinSelector:Remove();
		end
	end

	if self.AppearanceData[n].scale ~= nil then
		if --> mdlScale == false or number
			(self.AppearanceData[n].scale == false) or (isnumber(self.AppearanceData[n].scale))
		then
			if IsValid(self.ControlPanel.Content.MdlScaleSelectorTitle) and IsValid(self.ControlPanel.Content.MdlScaleSelector) then
				self.ControlPanel.Content.MdlScaleSelectorTitle:Remove();
				self.ControlPanel.Content.MdlScaleSelector:Remove();
			end

			self._appearance.mdlscale = self.AppearanceData[n].scale and self.AppearanceData[n].scale or 1;
		elseif --> mdlScale == {min,max}
			istable(self.AppearanceData[n].scale)
		then
			if !IsValid(self.ControlPanel.Content.MdlScaleSelectorTitle) and !IsValid(self.ControlPanel.Content.MdlScaleSelector) then
				self.ControlPanel.Content.MdlScaleSelectorTitle = vgui.Create( "DLabel", self.ControlPanel.Content );
					local ctrlMdlScaleSelectorLabel = self.ControlPanel.Content.MdlScaleSelectorTitle;
					ctrlMdlScaleSelectorLabel:SetText( "Рост" );
					ctrlMdlScaleSelectorLabel:SetFont( "Trebuchet24" );
					ctrlMdlScaleSelectorLabel:SetContentAlignment( 4 );
					ctrlMdlScaleSelectorLabel:SizeToContentsY();
				self.ControlPanel.Content:AddItem( ctrlMdlScaleSelectorLabel );

				self.ControlPanel.Content.MdlScaleSelector = vgui.Create( "DNumSlider", self.ControlPanel.Content );
					local ctrlMdlScaleSelector = self.ControlPanel.Content.MdlScaleSelector;
					ctrlMdlScaleSelector.Label:Hide();
					ctrlMdlScaleSelector.TextArea:Hide();
					ctrlMdlScaleSelector:DockMargin( 0, 0, 0, 5 );
					ctrlMdlScaleSelector:SetDecimals( 2 );
					ctrlMdlScaleSelector.OnValueChanged = function( this, val )
						self._appearance.mdlscale = math.Round( val, 2 );
						self:UpdateAppearanceModel();
					end
					ctrlMdlScaleSelector.Slider.Paint = function( this, w, h ) self.SliderSkin( this, w, h ); end
				self.ControlPanel.Content:AddItem( ctrlMdlScaleSelector );
			end

			local ctrlMdlScaleSelector = self.ControlPanel.Content.MdlScaleSelector;
			ctrlMdlScaleSelector:SetMinMax( self.AppearanceData[n].scale[1], self.AppearanceData[n].scale[2] );
			ctrlMdlScaleSelector:SetValue( (ctrlMdlScaleSelector:GetMax() + ctrlMdlScaleSelector:GetMin()) / 2 );
			self._appearance.mdlscale = ctrlMdlScaleSelector:GetValue();
		end
	else
		if !IsValid(self.ControlPanel.Content.MdlScaleSelectorTitle) and !IsValid(self.ControlPanel.Content.MdlScaleSelector) then
			self.ControlPanel.Content.MdlScaleSelectorTitle = vgui.Create( "DLabel", self.ControlPanel.Content );
				local ctrlMdlScaleSelectorLabel = self.ControlPanel.Content.MdlScaleSelectorTitle;
				ctrlMdlScaleSelectorLabel:SetText( "Рост" );
				ctrlMdlScaleSelectorLabel:SetFont( "Trebuchet24" );
				ctrlMdlScaleSelectorLabel:SetContentAlignment( 4 );
				ctrlMdlScaleSelectorLabel:SizeToContentsY();
			self.ControlPanel.Content:AddItem( ctrlMdlScaleSelectorLabel );

			self.ControlPanel.Content.MdlScaleSelector = vgui.Create( "DNumSlider", self.ControlPanel.Content );
				local ctrlMdlScaleSelector = self.ControlPanel.Content.MdlScaleSelector;
				ctrlMdlScaleSelector.Label:Hide();
				ctrlMdlScaleSelector.TextArea:Hide();
				ctrlMdlScaleSelector:DockMargin( 0, 0, 0, 5 );
				ctrlMdlScaleSelector:SetDecimals( 2 );
				ctrlMdlScaleSelector.OnValueChanged = function( this, val )
					self._appearance.mdlscale = math.Round( val, 2 );
					self:UpdateAppearanceModel();
				end
				ctrlMdlScaleSelector.Slider.Paint = function( this, w, h ) self.SliderSkin( this, w, h ); end
			self.ControlPanel.Content:AddItem( ctrlMdlScaleSelector );
		end

		local ctrlMdlScaleSelector = self.ControlPanel.Content.MdlScaleSelector;
		ctrlMdlScaleSelector:SetMinMax( rp.cfg.AppearanceScaleMin, rp.cfg.AppearanceScaleMax );
		ctrlMdlScaleSelector:SetValue( (ctrlMdlScaleSelector:GetMax() + ctrlMdlScaleSelector:GetMin()) / 2 );
		self._appearance.mdlscale = ctrlMdlScaleSelector:GetValue();
	end

	local selfBodygroup = self.ControlPanel.Content.Bodygroups;
	local mdlBodygroups = self.ModelViewer.Entity:GetBodyGroups();

	for k, v in pairs( selfBodygroup ) do
		if IsValid(v) then
			v:Remove();
			selfBodygroup[k] = nil;
		end
	end

	if not self.AppearanceData[n].bodygroups then
		for id, BodyGroupData in pairs( mdlBodygroups ) do
			if id <= 1 then continue end -- *studio* bodygroup
			if (BodyGroupData.num-1) == 0 then continue end

			local bgLabel = table.insert( selfBodygroup, vgui.Create( "DLabel", self.ControlPanel.Content ) );
				selfBodygroup[bgLabel]:SetText( self:GetTranslation(BodyGroupData.name) );
				selfBodygroup[bgLabel]:SetFont( "Trebuchet24" );
				selfBodygroup[bgLabel]:SetContentAlignment( 4 );
				selfBodygroup[bgLabel]:SizeToContentsY();
			self.ControlPanel.Content:AddItem( selfBodygroup[bgLabel] ); 

			local bgSlider = table.insert( selfBodygroup, vgui.Create( "DNumSlider", self.ControlPanel.Content ) );
				selfBodygroup[bgSlider].Label:Hide();
				selfBodygroup[bgSlider].TextArea:Hide();
				selfBodygroup[bgSlider]:DockMargin( 0, 0, 0, 5 );
				selfBodygroup[bgSlider]:SetDecimals( 0 );
				selfBodygroup[bgSlider]:SetMin( 0 );
				selfBodygroup[bgSlider]:SetMax( BodyGroupData.num-1 );
				selfBodygroup[bgSlider]:SetValue( self._appearance.bgroups[id-1] and math.max(self._appearance.bgroups[id-1],selfBodygroup[bgSlider]:GetMin()) or selfBodygroup[bgSlider]:GetMin() );
				selfBodygroup[bgSlider].OnValueChanged = function( this, val )
					val = math.Round(val);
					this:SetValue( val );

					self._appearance.bgroups[id-1] = val;
					self:UpdateAppearanceModel();
				end
				selfBodygroup[bgSlider].Slider.Paint = function( this, w, h ) self.SliderSkin( this, w, h ); end
			self.ControlPanel.Content:AddItem( selfBodygroup[bgSlider] ); 
		end
	else
		for id, AllowedBodyGroups in pairs( self.AppearanceData[n].bodygroups ) do
			if not self.ModelViewer.Entity:GetBodygroup(id) then continue end

			if #AllowedBodyGroups == 0 then for i = 0, mdlBodygroups[id+1].num-1 do table.insert( AllowedBodyGroups, i ) end end
			if #AllowedBodyGroups == 1 then 
				self._appearance.bgroups[id] = AllowedBodyGroups[1]; 
				self:UpdateAppearanceModel(); 
				continue 
			end

			if not data then
				self._appearance.bgroups[id] = self.AppearanceData[n].bodygroups[id][AllowedBodyGroups[1]];
			end

			local bgLabel = table.insert( selfBodygroup, vgui.Create( "DLabel", self.ControlPanel.Content ) );
				selfBodygroup[bgLabel]:SetText( self:GetTranslation(self.ModelViewer.Entity:GetBodygroupName(id)) );
				selfBodygroup[bgLabel]:SetFont( "Trebuchet24" );
				selfBodygroup[bgLabel]:SetContentAlignment( 4 );
				selfBodygroup[bgLabel]:SizeToContentsY();
			self.ControlPanel.Content:AddItem( selfBodygroup[bgLabel] ); 

			local bgSlider = table.insert( selfBodygroup, vgui.Create( "DNumSlider", self.ControlPanel.Content ) );
				selfBodygroup[bgSlider].Label:Hide();
				selfBodygroup[bgSlider].TextArea:Hide();
				selfBodygroup[bgSlider]:DockMargin( 0, 0, 0, 5 );
				selfBodygroup[bgSlider]:SetDecimals( 0 );
				selfBodygroup[bgSlider]:SetMin( 1 );
				selfBodygroup[bgSlider]:SetMax( #AllowedBodyGroups );
				selfBodygroup[bgSlider]:SetValue( self._appearance.bgroups[id] and math.max(self._appearance.bgroups[id]+1,selfBodygroup[bgSlider]:GetMin()) or selfBodygroup[bgSlider]:GetMin() );
				selfBodygroup[bgSlider].OnValueChanged = function( this, val )
					val = math.Round(val);
					this:SetValue( val );

					self._appearance.bgroups[id] = self.AppearanceData[n].bodygroups[id][val] or 0;
					self:UpdateAppearanceModel();
				end
				selfBodygroup[bgSlider].Slider.Paint = function( this, w, h ) self.SliderSkin( this, w, h, AllowedBodyGroups ); end
			self.ControlPanel.Content:AddItem( selfBodygroup[bgSlider] ); 
		end
	end

	self:UpdateAppearanceModel();
end


function PANEL:RebuildAppearanceMenu()
	self.ControlPanel.Content.ModelSelector:Clear();

	local PseudoKey = 1;

	for __key, appearance in pairs( self.AppearanceData ) do
		if (appearance.isCustom) then continue end

		local SpawnIcon = vgui.Create( "SpawnIcon", self.ControlPanel.Content.ModelSelector );
		SpawnIcon:SetModel( appearance.mdl );

		SpawnIcon.DoClick = function()
			local json = cookie.GetString( "urf" .. "-" .. util.CRC(game.GetIPAddress()) .. "-" ..  self.JobData.command .. "-" .. util.CRC(string.lower(appearance.mdl)) );

			if json then
				self:SelectAppearance( __key, util.JSONToTable(json) )
			else
				self:SelectAppearance( __key );
			end
		end

		self.ControlPanel.Content.ModelSelector:AddPanel( SpawnIcon );
		PseudoKey = PseudoKey + 1;
	end

	local can_use = true
	
	for Index, ModelUID in pairs(table.GetKeys(rp.shop.ModelsMap)) do
		
		can_use = not (rp.shop.ModelsMap[ModelUID][2][self.JobData.team] or self.JobData.faction and rp.shop.ModelsMap[ModelUID][3][self.JobData.faction])
		
		if can_use and rp.shop.ModelsMap[ModelUID][4] then
			can_use = rp.shop.ModelsMap[ModelUID][4][self.JobData.team] and true or false
		end
		if can_use and rp.shop.ModelsMap[ModelUID][5] then
			can_use = self.JobData.faction and rp.shop.ModelsMap[ModelUID][5][self.JobData.faction] and true or false
		end
		
		if (!LocalPlayer():HasUpgrade(ModelUID) or not can_use) then continue end

		for IIndex, MData in pairs(rp.shop.ModelsMap[ModelUID][1]) do
			local SpawnIcon = vgui.Create('SpawnIcon', self.ControlPanel.Content.ModelSelector);
			SpawnIcon:SetModel(MData);

			SpawnIcon.TempModelID = PseudoKey
			SpawnIcon.DoClick = function(slf)
				self:SelectAppearance(slf.TempModelID);
			end
			
			PseudoKey = PseudoKey + 1;

			self.ControlPanel.Content.ModelSelector:AddPanel(SpawnIcon);
		end
	end

	timer.Simple( 0, function()
		self.ControlPanel.RandBtn:SetVisible( (self.ControlPanel.Content.contentContainer:ChildCount() > 3) and true or false );
	end );
end


function PANEL:UpdateAppearanceModel()
	if IsValid(self.ModelViewer.Entity) then
		self.ModelViewer.Entity:SetEyeTarget( self.ModelViewer.Entity:GetPos() + Vector(200,0,64) );
		self.ModelViewer.Entity:SetModelScale( self._appearance.mdlscale or 1 );

		if self.AppearanceData[self._appearance.selected] then
			if self.AppearanceData[self._appearance.selected].skins then
				self.ModelViewer.Entity:SetSkin( self.AppearanceData[self._appearance.selected].skins[ self._appearance.skin ] or 0 );
			else
				self.ModelViewer.Entity:SetSkin( self._appearance.skin );
			end
		end

		for bodygroup, value in pairs( self._appearance.bgroups ) do
			self.ModelViewer.Entity:SetBodygroup( bodygroup, value );
		end
	end
end


function PANEL:SetJobData( data )
	self.JobData = data;
	if (self.ControlPanel.SaveBtn._customtext ~= nil) and (self.ControlPanel.SaveBtn._customtext ~= "") then
		self.ControlPanel.SaveBtn:SetText( self.ControlPanel.SaveBtn._customtext );
	else
		self.ControlPanel.SaveBtn:SetText( (data.team == LocalPlayer():Team()) and "Переодеться" or "Сменить профессию" );
	end
	self.ModelViewer.DescLabel:SetText( data.description or "" );
end

function PANEL:SetAppearanceData( data )
	local oldAppearanceData = self.AppearanceData;
	self.AppearanceData = data;

	local AdditionalTable = {};
	local can_use = true;

	for Index, ModelUID in pairs(table.GetKeys(rp.shop.ModelsMap)) do
	
		can_use = not (rp.shop.ModelsMap[ModelUID][2][self.JobData.team] or self.JobData.faction and rp.shop.ModelsMap[ModelUID][3][self.JobData.faction])
		
		if can_use and rp.shop.ModelsMap[ModelUID][4] then
			can_use = rp.shop.ModelsMap[ModelUID][4][self.JobData.team] and true or false
		end
		if can_use and rp.shop.ModelsMap[ModelUID][5] then
			can_use = self.JobData.faction and rp.shop.ModelsMap[ModelUID][5][self.JobData.faction] and true or false
		end
		
		if (!LocalPlayer():HasUpgrade(ModelUID) or not can_use) then continue end

		if !LocalPlayer():HasUpgrade(ModelUID) or ((rp.shop.ModelsMap[ModelUID][2][self.JobData.team] or self.JobData.faction and rp.shop.ModelsMap[ModelUID][3][self.JobData.faction]) and not (rp.shop.ModelsMap[ModelUID][4][self.JobData.team] or self.JobData.faction and rp.shop.ModelsMap[ModelUID][5][self.JobData.faction])) then continue end

		for IIndex, MData in pairs(rp.shop.ModelsMap[ModelUID][1]) do
			table.insert(AdditionalTable, {
				bodygroups = {{0}},
				mdl = MData,
				skins = {0},
				isCustom = true, 
				UID = ModelUID
			});
		end
	end

	table.Add(self.AppearanceData, AdditionalTable);
	
	if self.AppearanceData ~= oldAppearanceData then
		self:RebuildAppearanceMenu();
		self:SelectAppearance( 1 );
	end
end


function PANEL:Init()
    if self:GetParent():GetClassName() == "CGModBase" then return end

    self:InvalidateParent( true );
	self:Dock( FILL );

	self.ControlPanel = vgui.Create( "DPanel", self );
	self.ControlPanel:SetWide( self:GetParent():GetWide()*0.25 );
	self.ControlPanel:Dock( RIGHT );
	self.ControlPanel.Paint = function( this, w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color(0,0,0,16) );
	end

	self.ControlPanel.Content = vgui.Create( "ui_scrollpanel", self.ControlPanel );
	self.ControlPanel.Content:Dock( FILL );
	self.ControlPanel.Content:DockMargin( 5, 5, 5, 0 );

	self.ControlPanel.SaveBtn = vgui.Create( "DButton", self.ControlPanel );
	self.ControlPanel.SaveBtn:Dock( BOTTOM );
	self.ControlPanel.SaveBtn:DockMargin( 0, 5, 0, 0 );
	self.ControlPanel.SaveBtn:SetHeight( 28 );
	self.ControlPanel.SaveBtn:SetText( "" );
	self.ControlPanel.SaveBtn:SetColor( Color(240,240,240) );
	self.ControlPanel.SaveBtn:SetFont('rp.ui.20');
	self.ControlPanel.SaveBtn:SetPaintBackground( false );
	self.ControlPanel.SaveBtn.SetCustomText = function( this, msg )
		this._customtext = msg;
		self.ControlPanel.SaveBtn:SetText( msg );
	end
	self.ControlPanel.SaveBtn.Paint = function( this, w, h )
		surface.SetDrawColor( self.JobData.color );
		surface.DrawRect( 0, 0, w, h );

		if this:IsHovered() then
			surface.SetDrawColor( Color(255,255,255,10) );
			surface.DrawRect( 0, 0, w, h );
		end

		surface.SetDrawColor( Color(100,100,100) );
		surface.DrawOutlinedRect( 0, 0, w, h );
	end

	self.ControlPanel.SaveBtn.DoClick = function( this )
		if !LocalPlayer():CanTeam(self.JobData) then
			if self.JobData.unlockTime && self.JobData.unlockTime > LocalPlayer():GetPlayTime() then
				return rp.NotifyTerm(NOTIFY_ERROR, 'NotEnoughTime')
			end

			if !LocalPlayer():TeamUnlocked(self.JobData) then
				local SkillBonus = 0;

				if (LocalPlayer().GetAttributeAmount and LocalPlayer():GetAttributeAmount('pro') and self.JobData.unlockPrice) then
					SkillBonus = math.ceil(self.JobData.unlockPrice * LocalPlayer():GetAttributeAmount('pro') / 500);
				end

				if (LocalPlayer().GetAttributeAmount and LocalPlayer():GetAttributeAmount('jew') and self.JobData.unlockPrice) then
					SkillBonus = math.ceil(self.JobData.unlockPrice * LocalPlayer():GetAttributeAmount('jew') / 250);
				end

				if !LocalPlayer():CanAfford(self.JobData.unlockPrice - SkillBonus) then
					return rp.NotifyTerm(NOTIFY_ERROR, 'CannotAfford')
				else
					ui.Request(rp.GetTerm('ConfirmAction'), rp.GetTerm('UnlockTeam', self.JobData.name, rp.FormatMoney(self.JobData.unlockPrice - SkillBonus)), function(b)
						if b then
							--self.Parent:GetParent():Remove()
							rp.UnlockTeam(self.JobData.team)
						end
					end)
					return
				end
			end
		end

		if LocalPlayer():IsBanned() or rp.teams[self.JobData.team].faction and not rp.IsValidFactionChange(LocalPlayer(), rp.teams[self.JobData.team].faction) then return end

		cookie.Set(
			"urf" .. "-" .. util.CRC(game.GetIPAddress()) .. "-" ..  self.JobData.command .. "-" .. util.CRC(string.lower(self._appearance.mdl)),
			util.TableToJSON( self._appearance )
		);

		--print(self._appearance.mdl)
		rp.RunCommand( 'model', self._appearance.mdl );

		--
		if self.JobData.team ~= LocalPlayer():Team() then
			rp.ChangeTeam( self.JobData.team );
		else
			--self:GetParent():GetParent():Close();
			--!!rp.NotifyTerm( NOTIFY_GENERIC, 'AppearanceSaved' );
		end

		net.Start( "net.appearance.BodygroupData" );
			net.WriteUInt( self._appearance.selected, 6 );

			if self.AppearanceData[self._appearance.selected] and self.AppearanceData[self._appearance.selected].skins then
				net.WriteUInt( self.AppearanceData[self._appearance.selected].skins[ self._appearance.skin ] or 0, 6 )
			else
				net.WriteUInt( self._appearance.skin, 6 );
			end

			if LocalPlayer():CanTeam(self.JobData) then
				net.WriteFloat( self._appearance.mdlscale or 1 );
			else
				net.WriteFloat( LocalPlayer():GetNetVar("nw_ModelScale") or 1 );
			end

			-- is custom donate model? (mud code style)
			net.WriteBool(self.AppearanceData[self._appearance.selected].isCustom or false);
			net.WriteString(self.AppearanceData[self._appearance.selected].UID or '');
			
			local bgroups = self._appearance.bgroups;
			local c 	  = table.Count(bgroups);

			net.WriteUInt( c, 6 );

			for i = 1, c do
				local id = table.GetKeys(bgroups)[i];
				net.WriteUInt( id, 6 );
				net.WriteUInt( bgroups[id], 6 )
			end
		net.SendToServer();
	end

	self.ControlPanel.RandBtn = vgui.Create( "DButton", self.ControlPanel );
	self.ControlPanel.RandBtn:Dock( BOTTOM );
	self.ControlPanel.RandBtn:DockMargin( 0, 5, 0, 0 );
	self.ControlPanel.RandBtn:SetHeight( 28 );
	self.ControlPanel.RandBtn:SetText( "Случайно" );
	self.ControlPanel.RandBtn.DoClick = function( this )
		local items = self.ControlPanel.Content.ModelSelector.Panels
		items[ math.random(1,#items) ]:DoClick();

		if IsValid(self.ControlPanel.Content.SkinSelector) then
			local skin = self.ControlPanel.Content.SkinSelector;
			skin:OnValueChanged( math.random(skin:GetMin(),skin:GetMax()) );
		end

		for _, bgroup in pairs( self.ControlPanel.Content.Bodygroups ) do
			if bgroup:GetName() == "DNumSlider" then
				bgroup:OnValueChanged( math.random(bgroup:GetMin(),bgroup:GetMax()) );
			end
		end
	end

	--[[-------------------------------------------------------------------------
		ControlPanel -> Content:
	---------------------------------------------------------------------------]]
		-- Title:
		self.ControlPanel.Content.Title = vgui.Create( "DPanel", self.ControlPanel.Content );
			local ctrlTitleLabel = self.ControlPanel.Content.Title;
			ctrlTitleLabel:DockMargin( 0, 0, 0, 5 );
			ctrlTitleLabel:SetHeight( 48 );
			ctrlTitleLabel.Paint = function( this, w, h )
				surface.SetDrawColor( self.JobData.color );
				surface.DrawRect( 0, 0, w, h );

				draw.SimpleTextOutlined( self.JobData.name, "rp.ui.24", w/2, h/2, ui.col.White, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, ui.col.Black );

				surface.SetDrawColor( Color(100,100,100) );
				surface.DrawOutlinedRect( 0, 0, w, h );
			end
		self.ControlPanel.Content:AddItem( self.ControlPanel.Content.Title );

		-- ModelSelector:
		self.ControlPanel.Content.ModelSelectorTitle = vgui.Create( "DLabel", self.ControlPanel.Content );
			local ctrlModelSelectorTitleLabel = self.ControlPanel.Content.ModelSelectorTitle;
			ctrlModelSelectorTitleLabel:SetText( "Модель" );
			ctrlModelSelectorTitleLabel:SetFont( "Trebuchet24" );
			ctrlModelSelectorTitleLabel:SetContentAlignment( 4 );
			ctrlModelSelectorTitleLabel:SizeToContentsY();
		self.ControlPanel.Content:AddItem( ctrlModelSelectorTitleLabel );

		self.ControlPanel.Content.ModelSelector = vgui.Create( "DHorizontalScroller", self.ControlPanel.Content );
			local ctrlModelSelector = self.ControlPanel.Content.ModelSelector;
			ctrlModelSelector:SetSize( 64, 64 );
			ctrlModelSelector.btnLeft.Paint = function( this, w, h )
				derma.SkinHook( "Paint", "Button", this, w, h );
			end
			ctrlModelSelector.btnRight.Paint = function( this, w, h )
				derma.SkinHook( "Paint", "Button", this, w, h );
			end
		self.ControlPanel.Content:AddItem( ctrlModelSelector );

		-- SkinSelector:
		self.ControlPanel.Content.SkinSelectorTitle = vgui.Create( "DLabel", self.ControlPanel.Content );
			local ctrlSkinSelectorTitleLabel = self.ControlPanel.Content.SkinSelectorTitle;
			ctrlSkinSelectorTitleLabel:SetText( "Скин" );
			ctrlSkinSelectorTitleLabel:SetFont( "Trebuchet24" );
			ctrlSkinSelectorTitleLabel:SetContentAlignment( 4 );
			ctrlSkinSelectorTitleLabel:SizeToContentsY();
		self.ControlPanel.Content:AddItem( ctrlSkinSelectorTitleLabel );

		self.ControlPanel.Content.SkinSelector = vgui.Create( "DNumSlider", self.ControlPanel.Content );
			local ctrlSkinSelector = self.ControlPanel.Content.SkinSelector;
			ctrlSkinSelector.Label:Hide();
			ctrlSkinSelector.TextArea:Hide();
			ctrlSkinSelector:DockMargin( 0, 0, 0, 5 );
			ctrlSkinSelector:SetDecimals( 0 );
			ctrlSkinSelector.OnValueChanged = function( this, val )
				val = math.Round(val);
				this:SetValue( val );

				self._appearance.skin = val;
				self:UpdateAppearanceModel();
			end
		self.ControlPanel.Content:AddItem( ctrlSkinSelector ); 

		-- MdlScaleSelector:
		self.ControlPanel.Content.MdlScaleSelectorTitle = vgui.Create( "DLabel", self.ControlPanel.Content );
			local ctrlMdlScaleSelectorLabel = self.ControlPanel.Content.MdlScaleSelectorTitle;
			ctrlMdlScaleSelectorLabel:SetText( "Рост" );
			ctrlMdlScaleSelectorLabel:SetFont( "Trebuchet24" );
			ctrlMdlScaleSelectorLabel:SetContentAlignment( 4 );
			ctrlMdlScaleSelectorLabel:SizeToContentsY();
		self.ControlPanel.Content:AddItem( ctrlMdlScaleSelectorLabel );

		self.ControlPanel.Content.MdlScaleSelector = vgui.Create( "DNumSlider", self.ControlPanel.Content );
			local ctrlMdlScaleSelector = self.ControlPanel.Content.MdlScaleSelector;
			ctrlMdlScaleSelector.Label:Hide();
			ctrlMdlScaleSelector.TextArea:Hide();
			ctrlMdlScaleSelector:DockMargin( 0, 0, 0, 5 );
			ctrlMdlScaleSelector:SetDecimals( 2 );
			ctrlMdlScaleSelector.OnValueChanged = function( this, val )
				self._appearance.mdlscale = math.Round( val, 2 );
				self:UpdateAppearanceModel();
			end
			ctrlMdlScaleSelector.Slider.Paint = function( this, w, h ) self.SliderSkin( this, w, h ); end
		self.ControlPanel.Content:AddItem( ctrlMdlScaleSelector );

		self.ControlPanel.Content.Bodygroups = {}
	--[[---------------------------------------------------------------------]]--

	self.ModelViewer = vgui.Create( "DModelPanel", self );
	self.ModelViewer:Dock( FILL );

	self.ModelViewer.DescLabel = vgui.Create( "DLabel", self.ModelViewer );
	self.ModelViewer.DescLabel:Dock( TOP );
	self.ModelViewer.DescLabel:DockMargin( 10, 10, 10, 10 );
	self.ModelViewer.DescLabel:SetWrap(true)
	self.ModelViewer.DescLabel:SetAutoStretchVertical( true );
	self.ModelViewer.DescLabel:SetText( "" );

	--
		self.ModelViewer.fov = 20;
		self.ModelViewer.ang = 110;

		self.ModelViewer.ux = 0;
		self.ModelViewer.uy = 0;
		
		self.ModelViewer.xmod = 0;
		self.ModelViewer.ymod = 0;

		self.ModelViewer.spinmul = 0.5;
		self.ModelViewer.zoommul = 0.1;

		self.ModelViewer.lmb = false;
		self.ModelViewer.rmb = false;
	--
	self.ModelViewer:SetFOV( self.ModelViewer.fov );
	self.ModelViewer.LayoutEntity = function( this, ent )

		local newang = this.ang
		local newfov = this:GetFOV()

		if this.lmb == true then
			newang = this.ang + (gui.MouseX() - this.ux)*this.spinmul
			newfov = this.fov + (this.uy - gui.MouseY()) * this.zoommul
			if newfov < 20 then newfov = 20 end
			if newfov > 75 then newfov = 75 end
		end

		local newxmod, newymod = this.xmod, this.ymod

		if this.rmb == true then
			newxmod = this.xmod + (this.ux - gui.MouseX())*0.02
			newymod = this.ymod + (this.uy - gui.MouseY())*0.02
		end

		newxmod = math.Clamp( newxmod, -16, 16 )
		newymod = math.Clamp( newymod, -16, 16 )

		ent:SetAngles( Angle(0,0,0) )
		this:SetFOV( newfov )

		local height = 72/2
		local frac = InverseLerp( newfov, 75, 20 )
		height = Lerp( frac, 72/2, 64 )

		local norm = (this:GetCamPos() - Vector(0,0,64))
		norm:Normalize()
		local lookAng = norm:Angle()

		this:SetLookAt( Vector(0,0,height-(2*frac) ) - Vector( 0, 0, newymod*2*(1-frac) ) - lookAng:Right()*newxmod*2*(1-frac) )
		this:SetCamPos( Vector( 64*math.sin( newang * (math.pi/180)), 64*math.cos( newang * (math.pi/180)), height + 4*(1-frac)) - Vector( 0, 0, newymod*2*(1-frac) ) - lookAng:Right()*newxmod*2*(1-frac) )

	end

	self.ModelViewer.OnMousePressed = function( this, k )
		this.ux = gui.MouseX()
		this.uy = gui.MouseY()
		this.lmb = (k == MOUSE_LEFT) or false 
		this.rmb = (k == MOUSE_RIGHT) or false 
	end

	self.ModelViewer.OnMouseReleased = function( this, k )
		if this.lmb == true then
			this.ang = this.ang + (gui.MouseX() - this.ux)*this.spinmul
			this.fov = this.fov + (this.uy - gui.MouseY()) * this.zoommul
			this.fov = math.Clamp( this.fov, 20, 75 )
		end

		if this.rmb == true then
			this.xmod = this.xmod + (this.ux - gui.MouseX())*0.02
			this.ymod = this.ymod + (this.uy - gui.MouseY())*0.02

			this.xmod = math.Clamp( this.xmod, -16, 16 )
			this.ymod = math.Clamp( this.ymod, -16, 16 )
		end

		this.lmb = false 
		this.rmb = false
	end

	self.ModelViewer.OnCursorExited = function( this )
		if this.lmb == true or this.rmb == true then
			this:OnMouseReleased()
		end
	end

	local selectedJob = rp.teams[ LocalPlayer():Team() ];
	
	self:SetJobData( selectedJob );
	self:SetAppearanceData( selectedJob.appearance );
	self:RebuildAppearanceMenu();

end

vgui.Register( "DAppearancePanel", PANEL, "DPanel" );