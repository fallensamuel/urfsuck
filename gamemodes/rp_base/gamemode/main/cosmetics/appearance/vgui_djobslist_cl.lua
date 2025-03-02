local PANEL = {};

PANEL._appearancepnl = nil;
PANEL._gradienttex   = surface.GetTextureID( "gui/gradient" );
PANEL._activeBtn 	 = nil;

function PANEL:Init()
	if self:GetParent():GetClassName() == "CGModBase" then return end

	self:Dock( FILL );
end

function PANEL:SetAppearancePanel( pnl )
	self._appearancepnl = pnl;
end

function PANEL:AddJob( JobData )
	if isnumber(JobData) then
		JobData = rp.teams[JobData]
	end
	if JobData.customCheck and !JobData.customCheck(LocalPlayer()) then return end

	local JobButton = vgui.Create( "DButton", self );
	JobButton:SetHeight( 64 );
	JobButton:SetText( "" );
	JobButton:Dock( TOP );

	JobButton.Paint = function( this, w, h )
		if this:IsHovered() then
			draw.OutlinedBox( 0, 0, w, h, JobData.color, ui.col.Hover );
		end

		surface.SetDrawColor( ColorAlpha(JobData.color, 50) );
		surface.SetTexture( self._gradienttex );
		surface.DrawTexturedRect( 0, 0, w, h );

		local __TextLength = 10;
		if JobData.vip then
			__TextLength = __TextLength + draw.SimpleTextOutlined( "[VIP]", "rp.ui.22", 10, h * 0.5, ui.col.Orange, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, ui.col.Black) + 10;
		end
		draw.SimpleTextOutlined(JobData.name, "rp.ui.22", __TextLength, h * 0.5, ui.col.White, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, ui.col.Black);
		--draw.SimpleTextOutlined(#team.GetPlayers(JobData.team) .. '/' .. ((JobData.max == 0) and '∞' or JobData.max), 'rp.ui.22', w - 10, h * 0.5, ui.col.White, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, 1, ui.col.Black);

		if JobData.unlockTime && JobData.unlockTime > LocalPlayer():GetPlayTime() then
			draw.SimpleTextOutlined(ba.str.FormatTime(JobData.unlockTime-LocalPlayer():GetPlayTime()), 'rp.ui.22', w - 10, h * 0.5, ui.col.White, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, 1, ui.col.Black)
		elseif !LocalPlayer():TeamUnlocked(JobData) then
			local SkillBonus = 0;

			if (LocalPlayer().GetAttributeAmount and LocalPlayer():GetAttributeAmount('pro') and JobData.unlockPrice) then
				SkillBonus = math.ceil(JobData.unlockPrice * LocalPlayer():GetAttributeAmount('pro') / 500);
			end

			if (LocalPlayer().GetAttributeAmount and LocalPlayer():GetAttributeAmount('jew') and JobData.unlockPrice) then
				SkillBonus = math.ceil(JobData.unlockPrice * LocalPlayer():GetAttributeAmount('jew') / 250);
			end

			draw.SimpleTextOutlined(rp.FormatMoney(JobData.unlockPrice - SkillBonus), 'rp.ui.22', w - 10, h * 0.5, ui.col.White, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, 1, ui.col.Black)
		elseif JobData.max ~= 0 then
			draw.SimpleTextOutlined(#team.GetPlayers(JobData.team) .. '/' .. ((JobData.max == 0) and 'Unlimited' or JobData.max), 'rp.ui.22', w - 10, h * 0.5, ui.col.White, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, 1, ui.col.Black)
		end

	end

	JobButton.DoClick = function( this, w, h )
		if IsValid( self._appearancepnl ) and self._activeBtn ~= this then
			self._appearancepnl:SetJobData( JobData );
			self._appearancepnl:SetAppearanceData( JobData.appearance );

			self._appearancepnl.ControlPanel.Content.ModelSelector.Panels[1]:DoClick();
			self._appearancepnl.ControlPanel.RandBtn:DoClick();

			self._activeBtn = this;
		end
	end

	if JobData.team == LocalPlayer():Team() then
		JobButton:DoClick()
	end

	self:AddItem( JobButton );
end

vgui.Register( "DJobsList", PANEL, "ui_scrollpanel" );