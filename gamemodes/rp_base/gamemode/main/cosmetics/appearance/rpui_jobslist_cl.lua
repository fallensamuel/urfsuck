-- "gamemodes\\rp_base\\gamemode\\main\\cosmetics\\appearance\\rpui_jobslist_cl.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local PANEL = {}

function PANEL:BaseInit()
	self:Dock( FILL );
	self:InvalidateParent( true );

	--self.JobButtons = vgui.Create( "DPanel", self );

	local timeBonus = LocalPlayer():GetTimeMultiplayer() + rp.GetTimeMultiplier();
	if timeBonus > 0 then
		self.TimeBonusText = ui.Create( "DButton", self );
		self.TimeBonusText:Dock( BOTTOM );
		self.TimeBonusText:DockMargin( 0, 3, 0, 0 );
		self.TimeBonusText:SetTall( 30 );
		self.TimeBonusText:SetMouseInputEnabled( false );

		self.TimeBonusText.text       = 'Получение времени увеличено на ' .. math.floor(timeBonus * 100) .. '%!'
		self.TimeBonusText.time_until = rp.GetTimeMultiplierRemain()
		
		self.TimeBonusText.Paint = function(_, w, h)
			self.TimeBonusText:SetColor( rp.col.White )
			surface.SetDrawColor( HSVToColor(360, 0.8 - math.sin(CurTime()*2) * 0.1, 1) )
			surface.DrawRect( 0, 0, w, h )
		end
		
		self.TimeBonusText.Think = function()
			local lasts = self.TimeBonusText.time_until - os.time();
			local tb    = string.FormattedTime( (lasts > 0) and lasts or 0 );
			
			self.TimeBonusText:SetText(
				self.TimeBonusText.text .. " Осталось " .. string.format("%02i:%02i:%02i", tb["h"], tb["m"], tb["s"])
			);
			
			if lasts <= 0 then 
				self.TimeBonusText:SetText( self.TimeBonusText.text );
			end
		end
	end

	self.DAppearancePanel = vgui.Create( "DAppearancePanel", self );

	self.DJobsList = vgui.Create( "DJobsList", self );
	self.DJobsList:Dock( LEFT );
	self.DJobsList:SetWide( self:GetWide()*0.35 );
	self.DJobsList:SetAppearancePanel( self.DAppearancePanel );
end

function PANEL:Init()
	self:BaseInit()

	--for k, v in pairs( rp.teams ) do
	--	self:AddJob( v );
	--end
end

function PANEL:ClearJobs()
	self.DJobsList:Reset();
end

function PANEL:AddJob( JobData )
	self.DJobsList:AddJob( JobData );
end

function PANEL:SetFaction( factionID )
	self:ClearJobs();

	timer.Simple( 0, function()
		if factionID != 1 then
			self:AddJob(rp.teams[rp.GetDefaultTeam(LocalPlayer())])
		end

		for k, v in pairs( rp.teams ) do
			if v.faction ~= factionID then continue end

			self:AddJob( v );

			if #self.DJobsList:GetCanvas():GetChildren() == 1 then
				self.DJobsList:GetCanvas():GetChildren()[1]:DoClick();
			end
		end
	end );
end

vgui.Register( "rp_jobslist", PANEL, "Panel" );
vgui.Register( "rp_faction_jobslist", PANEL, "Panel" );

--[[
function rp.OpenEmployerMenu(f)
    local fr = ui.Create('ui_frame', function(self, p)
        self:SetSize(ScrW() * 0.65, ScrH() * 0.6)
        self:SetTitle(rp.Factions[f].printName)
        self:Center()
        self:MakePopup()
		self:InvalidateLayout(true)
    end)

    ui.Create('rp_faction_jobslist', function(self, p)
        self:SetFaction( f )
       	--self:SetPos(5, 5)
       	--self:SetSize(p:GetWide() - 10, p:GetTall() - 30)
    end, fr)
end
]]