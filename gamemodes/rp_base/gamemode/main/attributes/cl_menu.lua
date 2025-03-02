local playerUpgradeData = {};

local function ShowСonfirmationWindow()
	local amount = 0;

	for AttributeID, PointsAmount in pairs( playerUpgradeData ) do
		amount = amount + PointsAmount;
	end

	if amount < 10 then
		LocalPlayer():RequestUpgradeAttributes( playerUpgradeData );
		playerUpgradeData = {};
		return
	end

	local TEXT_CONFIRMATION_TITLE = "Вы уверены, что хотите распределить " .. amount .. " очков на следующие атрибуты?" .. "\n";
	local TEXT_SPACES 		      = "        ";
	local TEXT_ATTRIBUTES		  = "";

	for AttributeID, PointsAmount in pairs( playerUpgradeData ) do
		local rawAttribute = AttributeSystem.getAttribute( AttributeID );

		TEXT_ATTRIBUTES = TEXT_ATTRIBUTES ..
			TEXT_SPACES .. "-" .. " (" .. PointsAmount .. " очк.) " .. rawAttribute.Name .. "\n";
	end

	local MainWindow = vgui.Create( "DFrame" );
		MainWindow:SetWide( math.Round(ScrW()*0.65) );
		MainWindow:SetTitle( "??" );
		MainWindow:Center();
		MainWindow:SetDraggable( false );
		MainWindow:SetBackgroundBlur( true );
		MainWindow:MakePopup();

	MainWindow.Title = vgui.Create( "DLabel", MainWindow );
		MainWindow.Title:SetText( TEXT_CONFIRMATION_TITLE .. TEXT_ATTRIBUTES );
		MainWindow.Title:Dock( TOP );
		MainWindow.Title:SizeToContents();

	MainWindow.Controls = vgui.Create( "DPanel", MainWindow );
		MainWindow.Controls:SetTall( 32 );
		MainWindow.Controls:Dock( TOP );
		MainWindow.Controls:SetPaintBackground( false );

	MainWindow.Controls.Decline = vgui.Create( "DButton", MainWindow.Controls );
		MainWindow.Controls.Decline:DockMargin( 4, 0, 0, 0 );
		MainWindow.Controls.Decline:SetText( " Вернуться " );
		MainWindow.Controls.Decline:SizeToContents();
		MainWindow.Controls.Decline:Dock( RIGHT );
		MainWindow.Controls.Decline.DoClick = function()
			MainWindow:Close();
		end;
		MainWindow.Controls.Decline.Paint = function(btn, w, h)
			derma.SkinHook('Paint', 'TabButton', btn, w, h)
		end

	MainWindow.Controls.Accept = vgui.Create( "DButton", MainWindow.Controls );
		MainWindow.Controls.Accept:SetText( " Подтвердить " );
		MainWindow.Controls.Accept:SizeToContents();
		MainWindow.Controls.Accept:Dock( RIGHT );
		MainWindow.Controls.Accept.DoClick = function()
			LocalPlayer():RequestUpgradeAttributes( playerUpgradeData );
			playerUpgradeData = {};

			MainWindow:Close();
		end;
		MainWindow.Controls.Accept.Paint = function(btn, w, h)
			derma.SkinHook('Paint', 'TabButton', btn, w, h)
		end

	MainWindow:InvalidateLayout( true );
	MainWindow:SizeToChildren( false, true );
end


local PANEL = {}

function PANEL:PerformLayout()
	if IsValid(self.ControlPnl) and IsValid(self.ControlPnl.PointsBonusBtn) then
		self.ControlPnl.PointsBonusBtn:SetText("Получить 1 очко")
		self.ControlPnl.PointsBonusBtn:SetDisabled(false)
	end
end

function PANEL:Init()
	playerUpgradeData = {};


	local MainWindow = self

	MainWindow.ControlPnl = vgui.Create( "DPanel", MainWindow );
	    MainWindow.ControlPnl:Dock( BOTTOM );
	    MainWindow.ControlPnl:SetPaintBackground( false );
	    MainWindow.ControlPnl.Think = function( self )
	        if IsValid(MainWindow.ControlPnl.ButtonPnl) then
	            if table.Count(playerUpgradeData) ~= 0 and !MainWindow.ControlPnl.ButtonPnl.__visible and !MainWindow.ControlPnl.ButtonPnl.__changed then
	                MainWindow.ControlPnl.ButtonPnl.__visible = true;
	                MainWindow.ControlPnl.ButtonPnl.__changed = true;
	            end

	            if table.Count(playerUpgradeData) == 0 and MainWindow.ControlPnl.ButtonPnl.__visible and !MainWindow.ControlPnl.ButtonPnl.__changed then
	                MainWindow.ControlPnl.ButtonPnl.__visible = false;
	                MainWindow.ControlPnl.ButtonPnl.__changed = true;
	            end

	            if MainWindow.ControlPnl.ButtonPnl.__changed then
	                if MainWindow.ControlPnl.ButtonPnl.__visible then
	                    MainWindow.ControlPnl.ButtonPnl:AlphaTo( 255, 0.25, 0 );
	                else
	                    MainWindow.ControlPnl.ButtonPnl:AlphaTo( 0, 0.25, 0 );
	                end
	                MainWindow.ControlPnl.ButtonPnl.__changed = false;
	            end
	        end
	    end


	MainWindow.ControlPnl.PointsAmount = vgui.Create( "DLabel", MainWindow.ControlPnl );
	    MainWindow.ControlPnl.PointsAmount:SetContentAlignment( 5 );
	    MainWindow.ControlPnl.PointsAmount:DockMargin( 0, 0, 0, 4 );
	    MainWindow.ControlPnl.PointsAmount:Dock( TOP );
	    MainWindow.ControlPnl.PointsAmount:SetFont('AttributeFontBig')
	    MainWindow.ControlPnl.PointsAmount:SetText( "Доступно очков атрибутов: Загрузка" );
	    MainWindow.ControlPnl.PointsAmount:SizeToContentsY();
	    MainWindow.ControlPnl.PointsAmount.uPoints = 0;
	    MainWindow.ControlPnl.PointsAmount.Think = function( self )
	        self:SetText( "Доступно очков атрибутов: " .. (LocalPlayer():GetAttributeSystemPoints() - self.uPoints) );
	    end

	local ability = rp.abilities.GetByName('1skillpts')
	local ab_text
	
	if ability then
		MainWindow.ControlPnl.PointsBonusBtn = vgui.Create("DButton", MainWindow.ControlPnl);
		MainWindow.ControlPnl.PointsBonusBtn:SetContentAlignment( 5 );
		MainWindow.ControlPnl.PointsBonusBtn:DockMargin( 10, 0, 10, 10 );
		MainWindow.ControlPnl.PointsBonusBtn:Dock( TOP );
		MainWindow.ControlPnl.PointsBonusBtn:SetHeight(18);
		MainWindow.ControlPnl.PointsBonusBtn:SetText("Получить 1 очко");
		MainWindow.ControlPnl.PointsBonusBtn.Paint = function(btn, w, h)
			derma.SkinHook('Paint', 'TabButton', btn, w, h)
		end
		MainWindow.ControlPnl.PointsBonusBtn.DoClick = function()
			if ability:InCooldown(LocalPlayer()) then
				MainWindow.ControlPnl.PointsBonusBtn:SetDisabled(true)
				MainWindow.ControlPnl.PointsBonusBtn:SetText("Чтобы снова получить очко, нужно подождать")
				return
			end

			if ability:GetPlayTime(LocalPlayer()) > LocalPlayer():GetPlayTime() then
				MainWindow.ControlPnl.PointsBonusBtn:SetDisabled(true)
				MainWindow.ControlPnl.PointsBonusBtn:SetText("Отыграно недостаточно времени")
				return
			end
			
			--if ability:IsVIP() && !LocalPlayer():IsVIP() then
			--	MainWindow.ControlPnl.PointsBonusBtn:SetDisabled(true)
			--	MainWindow.ControlPnl.PointsBonusBtn:SetText("Бонус доступен только для VIP")
			--	return
			--end
			
			net.Start('AbilityUse')
				net.WriteInt(ability:GetID(), 6)
			net.SendToServer()
			
			MainWindow.ControlPnl.PointsBonusBtn:SetDisabled(true)
			MainWindow.ControlPnl.PointsBonusBtn:SetText("Чтобы снова получить очко, нужно подождать")
		end
		MainWindow.ControlPnl.PointsBonusBtn.Think = function( self )
			if ability:InCooldown(LocalPlayer()) then
				MainWindow.ControlPnl.PointsBonusBtn:SetText("Через " .. ba.str.FormatTime(ability:GetRemainingCooldown(LocalPlayer())) .. " вы сможете получить ещё 1 очко!")
			end
		end
	end

	MainWindow.ControlPnl.ButtonPnl = vgui.Create( "DPanel", MainWindow.ControlPnl );
	    MainWindow.ControlPnl.ButtonPnl:Dock( TOP );
	    MainWindow.ControlPnl.ButtonPnl:SetPaintBackground( false );
	    MainWindow.ControlPnl.ButtonPnl:SetAlpha( 0 );
	    MainWindow.ControlPnl.ButtonPnl.__changed = false;
	    MainWindow.ControlPnl.ButtonPnl.__visible = false;

	MainWindow.ControlPnl.ButtonPnl.ClearBtn = vgui.Create( "DButton", MainWindow.ControlPnl.ButtonPnl );
	    MainWindow.ControlPnl.ButtonPnl.ClearBtn:Dock( RIGHT );
	    MainWindow.ControlPnl.ButtonPnl.ClearBtn:SetText( " Очистить распределение очков " );
	    MainWindow.ControlPnl.ButtonPnl.ClearBtn:SizeToContents();
	    MainWindow.ControlPnl.ButtonPnl.ClearBtn:SetEnabled( false );
	    MainWindow.ControlPnl.ButtonPnl.ClearBtn.DoClick = function()
	        playerUpgradeData = {};
	    end
	    MainWindow.ControlPnl.ButtonPnl.ClearBtn.Think = function( self )
	        self:SetEnabled( table.Count(playerUpgradeData) ~= 0 )
	    end
	    MainWindow.ControlPnl.ButtonPnl.ClearBtn.Paint = function(btn, w, h)
			derma.SkinHook('Paint', 'TabButton', btn, w, h)
		end

	MainWindow.ControlPnl.ButtonPnl.UpgradeBtn = vgui.Create( "DButton", MainWindow.ControlPnl.ButtonPnl );
		MainWindow.ControlPnl.ButtonPnl.UpgradeBtn:DockMargin( 0, 0, 4, 0 );
		MainWindow.ControlPnl.ButtonPnl.UpgradeBtn:Dock( FILL );
		MainWindow.ControlPnl.ButtonPnl.UpgradeBtn:SetText( "Потратить очки атрибутов" );
		MainWindow.ControlPnl.ButtonPnl.UpgradeBtn:SizeToContents();
		MainWindow.ControlPnl.ButtonPnl.UpgradeBtn:SetEnabled( false );
		MainWindow.ControlPnl.ButtonPnl.UpgradeBtn.DoClick = function()
			ShowСonfirmationWindow();
		end
		MainWindow.ControlPnl.ButtonPnl.UpgradeBtn.Paint = function(btn, w, h)
			derma.SkinHook('Paint', 'TabButton', btn, w, h)
		end

		MainWindow.ControlPnl.ButtonPnl:InvalidateLayout( true );
		MainWindow.ControlPnl.ButtonPnl:SizeToChildren( false, true );

		MainWindow.ControlPnl:InvalidateLayout( true );
		MainWindow.ControlPnl:SizeToChildren( false, true );

	MainWindow.ContentPnl = vgui.Create( "ui_scrollpanel", MainWindow );
		MainWindow.ContentPnl:Dock( FILL );


	local MyAttributes = LocalPlayer():GetAttributes();
	for AttributeID, AttributeAmount in pairs( MyAttributes ) do
		local rawAttribute = AttributeSystem.getAttribute( AttributeID );

		local AttributePanel = MainWindow.ContentPnl:Add( "DPanel" );
			AttributePanel:DockPadding( 16, 8, 16, 8 );
			AttributePanel:Dock( TOP );
			AttributePanel:SetDrawBackground( false );
			AttributePanel.Paint = function() end

		AttributePanel.Name = vgui.Create( "DLabel", AttributePanel );
			AttributePanel.Name:SetText( rawAttribute.Name );
			AttributePanel.Name:SetFont( 'AttributeFontBig' );
			AttributePanel.Name:DockMargin( 0, 0, 0, 4 );
			AttributePanel.Name:SetColor(Color(255,255,255))
			AttributePanel.Name:Dock( TOP );
			AttributePanel.Name:SizeToContents();

		//AttributePanel.Desc = vgui.Create( "DLabel", AttributePanel );
		//	AttributePanel.Desc:SetText( 'Алё хуле' );
		//	AttributePanel.Desc:SetFont( 'Default' );
		//	AttributePanel.Desc:SizeToContents()
		//	local posX, posY = AttributePanel.Name:GetPos()
		//	print(posX,  AttributePanel.Name:GetWide(), AttributePanel.Desc:GetTall())
		//	AttributePanel.Desc:SetPos(posX + AttributePanel.Name:GetWide() + 16, posY + AttributePanel.Name:GetTall() - AttributePanel.Desc:GetTall())

		AttributePanel.Controls = vgui.Create( "DPanel", AttributePanel );
			AttributePanel.Controls:SetTall( 32 );
			AttributePanel.Controls:Dock( TOP );
			AttributePanel.Controls.Paint = function() end

		AttributePanel.ProgressBar = vgui.Create( "DAttributeProgressBar", AttributePanel.Controls );
			AttributePanel.ProgressBar:DockMargin( 8, 0, 8, 0 );
			AttributePanel.ProgressBar:Dock( FILL );
			AttributePanel.ProgressBar:SetAttributeData( rawAttribute );
			AttributePanel.ProgressBar:SetColor(rawAttribute.Color or Color(255, 255, 255))
			AttributePanel.ProgressBar.Recalculate = function()
			    AttributeAmount = LocalPlayer():GetAttributeAmount( AttributeID )

			    MainWindow.ControlPnl.PointsAmount.uPoints = 0;

			    for _, v in pairs( playerUpgradeData ) do MainWindow.ControlPnl.PointsAmount.uPoints = MainWindow.ControlPnl.PointsAmount.uPoints+v end

			    if MainWindow.ControlPnl.PointsAmount.uPoints <= 0 then
			        if MainWindow.ControlPnl.ButtonPnl.UpgradeBtn:IsEnabled() then MainWindow.ControlPnl.ButtonPnl.UpgradeBtn:SetEnabled( false ); end
			        AttributePanel.Controls.PointsSub:SetEnabled( false );
			    else
			        if not MainWindow.ControlPnl.ButtonPnl.UpgradeBtn:IsEnabled() then MainWindow.ControlPnl.ButtonPnl.UpgradeBtn:SetEnabled( true ); end
			        if (playerUpgradeData[AttributeID] or 0) == 0 then
			            AttributePanel.Controls.PointsSub:SetEnabled( false );
			        else
			            AttributePanel.Controls.PointsSub:SetEnabled( true );
			        end
			    end

			    if MainWindow.ControlPnl.PointsAmount.uPoints <= 0 then
			        MainWindow.ControlPnl.ButtonPnl.UpgradeBtn:SetText( "Потратить очки атрибутов" );
			    elseif MainWindow.ControlPnl.PointsAmount.uPoints == 1 then
			        MainWindow.ControlPnl.ButtonPnl.UpgradeBtn:SetText( "Потратить 1 очко атрибутов" );
			    elseif 2 <= MainWindow.ControlPnl.PointsAmount.uPoints and MainWindow.ControlPnl.PointsAmount.uPoints <= 4 then
			        MainWindow.ControlPnl.ButtonPnl.UpgradeBtn:SetText( "Потратить "..MainWindow.ControlPnl.PointsAmount.uPoints.." очка атрибутов" );
			    else
			        MainWindow.ControlPnl.ButtonPnl.UpgradeBtn:SetText( "Потратить "..MainWindow.ControlPnl.PointsAmount.uPoints.." очков атрибутов" );
			    end
			    if
			        LocalPlayer():GetAttributeSystemPoints() - MainWindow.ControlPnl.PointsAmount.uPoints <= 0 or
			        AttributeAmount + (playerUpgradeData[AttributeID] or 0)*rawAttribute.UpgradeConversionRate == rawAttribute.UpgradeMax
			    then
			        AttributePanel.Controls.PointsAdd:SetEnabled( false );
			    else
			        AttributePanel.Controls.PointsAdd:SetEnabled( true );
			    end

			    local Tooltip_BoostInfo = "";
			    for BoostID, Boost in pairs( LocalPlayer():GetAttributeBoosts(AttributeID) ) do
			        Tooltip_BoostInfo = Tooltip_BoostInfo .. "\n" .. "        " .. "- " .. "[" .. Boost.Stacks .. "x] " .. AttributeSystem.getBoost(BoostID).Name;
			    end

			    AttributePanel.ProgressBar:SetTooltip( rawAttribute.TooltipDesc(AttributeAmount) );
			end
			AttributePanel.ProgressBar.Think = function()
				local BoostValue = 0;

				for BoostID, Boost in pairs( LocalPlayer():GetAttributeBoosts(AttributeID) ) do
					BoostValue = BoostValue + Boost.Amount;
				end

				AttributePanel.ProgressBar:SetAmountValue( LocalPlayer():GetAttributeAmount(AttributeID) );
				AttributePanel.ProgressBar:SetUpgradeValue( (playerUpgradeData[AttributeID] or 0) ); -- ??
				AttributePanel.ProgressBar:SetBoostValue( BoostValue );

				if IsValid(AttributePanel.Controls.PointsAdd) and IsValid(AttributePanel.Controls.PointsSub) then
					AttributePanel.ProgressBar.Recalculate();
				end
			end

		AttributePanel.Controls.PointsSub = vgui.Create( "DButton", AttributePanel.Controls );
			AttributePanel.Controls.PointsSub:SetSize( 32, 32 );
			AttributePanel.Controls.PointsSub:Dock( LEFT );
			AttributePanel.Controls.PointsSub:SetText( "-" );
			AttributePanel.Controls.PointsSub.Paint = function(btn, w, h)
				derma.SkinHook('Paint', 'TabButton', btn, w, h)
			end
			AttributePanel.Controls.PointsSub.DoClick = function( self )
				playerUpgradeData[AttributeID] = math.max( (playerUpgradeData[AttributeID] or 0) - 1, 0 );
				AttributePanel.ProgressBar:SetUpgradeValue( playerUpgradeData[AttributeID] );

				if playerUpgradeData[AttributeID] == 0 then playerUpgradeData[AttributeID] = nil end

				AttributePanel.ProgressBar.Recalculate();

				if playerUpgradeData ~= {} then MainWindow.ControlPnl.ButtonPnl.ClearBtn:SetEnabled( true ); else MainWindow.ControlPnl.ButtonPnl.ClearBtn:SetEnabled( false ); end
			end

		AttributePanel.Controls.PointsAdd = vgui.Create( "DButton", AttributePanel.Controls );
			AttributePanel.Controls.PointsAdd:SetSize( 32, 32 );
			AttributePanel.Controls.PointsAdd:Dock( RIGHT );
			AttributePanel.Controls.PointsAdd:SetText( "+" );
			AttributePanel.Controls.PointsAdd.Paint = function(btn, w, h)
				derma.SkinHook('Paint', 'TabButton', btn, w, h)
			end
			AttributePanel.Controls.PointsAdd.DoClick = function( self )
				MainWindow.ControlPnl.ButtonPnl.UpgradeBtn:SetText( "Потратить очки атрибутов" );

				if AttributeAmount + ((playerUpgradeData[AttributeID] or 0)+1)*rawAttribute.UpgradeConversionRate <= rawAttribute.UpgradeMax then
					playerUpgradeData[AttributeID] = (playerUpgradeData[AttributeID] or 0) + 1;
					AttributePanel.ProgressBar:SetUpgradeValue( playerUpgradeData[AttributeID] );
				end

				AttributePanel.ProgressBar.Recalculate();

				if playerUpgradeData ~= {} then MainWindow.ControlPnl.ButtonPnl.ClearBtn:SetEnabled( true ); else MainWindow.ControlPnl.ButtonPnl.ClearBtn:SetEnabled( false ); end
			end

			AttributePanel:InvalidateLayout( true );
			AttributePanel:SizeToChildren( false, true );
	end
end

vgui.Register('rp_attributes', PANEL, 'Panel')

hook.Add('PopulateF4Tabs', function(tabs) 
	tabs:AddTab('Навыки', ui.Create('rp_attributes'))
end)