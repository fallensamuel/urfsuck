-- "gamemodes\\rp_base\\gamemode\\main\\menus\\rpui_menus\\disguise_cl.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local IsVALID, SetDrawColor, DrawRect, SetMaterial, UpdateScreenEffectTexture, DrawTexturedRect = IsValid, surface.SetDrawColor, surface.DrawRect, surface.SetMaterial, render.UpdateScreenEffectTexture, surface.DrawTexturedRect
local newyork = pairs
local SimpleText, mathRound = draw.SimpleText, math.Round
local DrawBlur = draw and draw.Blur or function(...) draw.Blur(...) end


--
net.Receive( "DisguiseMenu", rp.DisguiseMenu );

net.Receive( "PlayerDisguiseSync", function()
	if IsValid( LocalPlayer() ) then 
		LocalPlayer().DisguiseCount = net.ReadUInt(8);
	end
end );


--
local PANEL = {};

PANEL.Colors = {
	White      = Color(255, 255, 255),
	Black      = Color(0, 0, 0, 153),
	BlackHover = Color(30, 30, 30, 180),
};

local Align = {
	Top    = TEXT_ALIGN_TOP,
	Left   = TEXT_ALIGN_LEFT,
	Center = TEXT_ALIGN_CENTER,
};

surface.CreateFont( "rpui.disguise.title", {
    font = "Roboto", 
    extended = true,
    size = 27 * (ScrH()/1080),
    weight = 550
} );

surface.CreateFont("rpui.disguise.font", {
    font = "Montserrat", 
    extended = true,
    size = 22 * (ScrH()/1080)
})

surface.CreateFont("rpui.disguise.font.big", {
    font = "Montserrat", 
    extended = true,
    size = 28 * (ScrH()/1080)
})

function PANEL:Init()
	self.scroll.SetSpacingY(self.scroll, 10)
	self.NoAutomaticItemSize = true
end

function PANEL:AddElement(jobindex, teamdata)
	if IsVALID(self.scroll_items[jobindex]) then return end

	local pnl = vgui.Create("DButton")
	pnl:SetText("")
	pnl:Dock(TOP)
	pnl.job = jobindex
	pnl.jobname = team.GetName(pnl.job)
	pnl.Paint = function(this, w, h)
		SetDrawColor(this:IsHovered() and self.Colors.BlackHover or self.Colors.Black)
		DrawRect(0, 0, w, h)
		SimpleText(this.jobname, "rpui.disguise.font", w*0.075, h*0.5, self.Colors.White, Align.Left, Align.Center)
	end
	pnl.DoClick = function()
		self:JobSelect(jobindex, pnl.jobname, teamdata)
	end

	self.scroll_items[jobindex] = pnl
	self.scroll.AddItem(self.scroll, pnl)
end

function PANEL:PostPerformLayout()
	self.ScrollContainer.SetSize(self.ScrollContainer, self:GetWide()*0.875, self:GetTall() - self.header.GetTall(self.header))
	self.ScrollContainer.SetPos(self.ScrollContainer, self:GetWide()*0.0625, self.header.GetTall(self.header) + 10)

	for k, pnl in newyork(self.scroll_items) do
		if not IsVALID(pnl) then self.scroll_items[k] = nil continue end
		pnl:SetTall(55)
	end
end

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

    return string.utf8upper(out);
end

local GetAdaptSize = function(def, cur)
	local result = (def * cur) / 1080
	return (result < def * .5) and def * .5 or result
end

function PANEL:JobSelect(jobindex, jobname)
    self.header.EnableAutoCloseOnX = true;
    
	if IsVALID(self.JobCustomizeMenu) then return end

	self.SelectedJob = rp.teams[jobindex]

	self.header.PreviousTitle = jobname

	self.header.ActivatePrevious(self.header)
	self.header.prev_btn.DoClick = function()
        self.header.EnableAutoCloseOnX = nil;
		self.header.ActivatePrevious(self.header)

		if IsVALID(self.JobCustomizeMenu) then
			self.JobCustomizeMenu.AlphaTo(self.JobCustomizeMenu, 0, 0.2, 0, function()
				if IsVALID(self.JobCustomizeMenu) then
					self.JobCustomizeMenu.Remove(self.JobCustomizeMenu)
				end
			end)
		end
	end

	local bg_col = rpui.UIColors.Shading;

	self.JobCustomizeMenu = vgui.Create("Panel", self)
	local JobCustomizeMenu = self.JobCustomizeMenu
	
	JobCustomizeMenu:SetSize( self:GetWide(), self:GetTall() - self.header.GetTall(self.header) )
	JobCustomizeMenu:SetPos( 0, self.header.GetTall(self.header) )
	JobCustomizeMenu:SetAlpha(0)
	JobCustomizeMenu:AlphaTo(255, 0.2)	
	JobCustomizeMenu.Paint = function(this, w, h)
        DrawBlur( this )
        SetDrawColor( bg_col )
        DrawRect( 0, 0, w, h );
	end

	local JobIconsz = JobCustomizeMenu:GetWide()*0.85
    local padding = GetAdaptSize(20, ScrH());

	JobCustomizeMenu.JobIcon = vgui.Create("Panel", JobCustomizeMenu)
	local JobIcon = JobCustomizeMenu.JobIcon
    JobIcon:Dock( TOP );
    JobIcon:DockMargin( 0, 0, 0, padding * 0.5 );
    JobIcon:InvalidateParent( true );
	JobIcon:SetTall( JobIcon:GetWide() );

	self.JobCustomizeMenu.JobIcon.mdl = vgui.Create( "DModelPanel", self.JobCustomizeMenu.JobIcon );
	self.ModelViewer = self.JobCustomizeMenu.JobIcon.mdl;
	self.AppearanceModel = istable(self.SelectedJob.model) and table.Random(self.SelectedJob.model) or self.SelectedJob.model;

	local mdl = self.JobCustomizeMenu.JobIcon.mdl;
	mdl:Dock( FILL );
	mdl:SetModel( self.AppearanceModel );
	mdl:SetFOV( 55 );

	mdl.xVelocity     = 0
    mdl.xOffset       = 0
    mdl.yVelocity     = 0
    mdl.ZoomingVector = Vector(0,0,0)
    mdl.LayoutEntity = function() end
    mdl.OnMousePressed = function(this, keycode)
        if keycode == MOUSE_LEFT then
            this._MousePosition = {input.GetCursorPos()}
            this.Pressed = true
        end
    end
    self.JobCustomizeMenu.JobIcon.mdl.Think = function( this )
        if not input.IsMouseDown(MOUSE_LEFT) then
            this.Pressed = false
        end

        this.xVelocity = this.xVelocity * 0.9
        this.yVelocity = this.yVelocity * 0.9

        if this.Pressed then
            local mp = {input.GetCursorPos()}
            local _mp = this._MousePosition
            local dx = mp[1] - _mp[1]
            local dy = mp[2] - _mp[2]

            this.yVelocity = this.yVelocity + (dx * 0.03)
        end
                
        this._MousePosition = {input.GetCursorPos()};

        this.Entity.SetAngles( this.Entity, this.Entity.GetAngles(this.Entity) + Angle( 0, this.yVelocity, 0 ) )

        this.xOffset = math.Clamp( this.xOffset + this.xVelocity, -16, 32 )
        this.Entity.SetPos( this.Entity, this.ZoomingVector * this.xOffset )
    end

    mdl.OnMouseWheeled = function(thth, dlta)
	    local scale = thth:GetFOV() / 180
	    thth.fFOV = math.Clamp(thth.fFOV + dlta * -10.0 * scale, 30, 70)

	    return true
	end

	self.acceptbtn = vgui.Create("urf.im/rpui/button", JobCustomizeMenu)
	local acceptbtn = self.acceptbtn
    acceptbtn:Dock( BOTTOM );
    acceptbtn:SetTall( GetAdaptSize(55, ScrH()) );
	acceptbtn:SetFont( "rpui.slidermenu.font" );
	acceptbtn:SetText( translates.Get("Маскироваться") );
    acceptbtn:SetText( utf8.upper(acceptbtn:GetText()) );
	acceptbtn.DoClick = function()
		if IsValid( self.AcceptItPls ) then return end
		self:AcceptClick( self.SelectedJob, jobindex );
	end

	local slider_bg = Color(166, 166, 166)
	
	--self.AppearanceModel      = ""
    self.AppearanceSkin       = 0
    self.AppearanceScale      = 1
    self.AppearanceBodygroups = {}

	local bg_col = rpui.UIColors.Background
	local white_col = rpui.UIColors.White
	local STYLE_BLANKSOLID = STYLE_BLANKSOLID

	local slider_count = 0

	local CreateSettingSlider = function(name, values, callback)
		if not values or #values < 2 then return end
		if slider_count >= 4 then return end

		local btnwang = vgui.Create( "rpui.ButtonWang", JobCustomizeMenu );
        btnwang:Dock( TOP );
        btnwang:DockMargin( padding, 0, padding, padding * 0.5 );
        btnwang:SetFont( "rpui.disguise.font.big" );
        btnwang:SetText( name );
        btnwang:SetTall( GetAdaptSize(45, ScrH()) );
        btnwang.Paint = function(this, w, h)
            SetDrawColor(bg_col)
            DrawRect(0, 0, w, h)
            SimpleText(this.Text, this.Font, w*0.5, h*0.5, white_col, Align.Center, Align.Center)
        end
        btnwang.Prev.Paint = function( this, w, h )
            local baseColor = rpui.GetPaintStyle(this, STYLE_BLANKSOLID)
            SetDrawColor(baseColor)
            DrawRect(0, 0, w, h)
            SimpleText(this:GetText(), this:GetFont(), w*0.5, h*0.5, white_col, Align.Center, Align.Center)
            return true
        end
        btnwang.Next.Paint = function( this, w, h )
            local baseColor = rpui.GetPaintStyle(this, STYLE_BLANKSOLID)
            SetDrawColor(baseColor)
            DrawRect(0, 0, w, h)
            SimpleText(this:GetText(), this:GetFont(), w*0.5, h*0.5, white_col, Align.Center, Align.Center)
            return true
        end
        btnwang.OnValueChanged = function( this, value )
            if callback then
            	callback(value)
            end
            self:RefreshAppearanceVisuals()
        end

        btnwang:SetValues( values );
        btnwang:SetPosition( math.ceil(#btnwang:GetValues()*0.5) );

        slider_count = slider_count + 1
        return btnwang
	end

	local mdlScales = {}

	local appearance = self.SelectedJob.appearance

    if appearance.scale ~= nil then
        if (appearance.scale == false) or isnumber(appearance.scale) then
            self.AppearanceScale = self.AppearanceScale and self.AppearanceScale or 1
        else
            if istable(appearance.scale) then
                local smin = appearance.scale[1]
                local smax = appearance.scale[2]
                local step = (smax - smin) / 5
                for i = smin, smax, step do
                    table.insert( mdlScales, math.Round(i,2) )
                end
            end
        end
    else
        local smin = rp.cfg.AppearanceScaleMin
        local smax = rp.cfg.AppearanceScaleMax
        local step = (smax - smin) / 5
        for i = smin, smax, step do
            table.insert( mdlScales, math.Round(i,2) )
        end
    end

    local can_use = true

    self.AppearanceCustom = {}
    
    local teamData = self.SelectedJob
    self.AppearanceModels   = istable(teamData.model) and teamData.model or {teamData.model};

    local mdlslist = {};
    for k, v in pairs( self.AppearanceModels ) do
        if mdlslist[v] then self.AppearanceModels[k] = nil end
        mdlslist[v] = true;
    end
	
    for _, uid in pairs( table.GetKeys(rp.shop.ModelsMap) ) do
		can_use = not (rp.shop.ModelsMap[uid][2][teamData.team] or rp.shop.ModelsMap[uid][3][teamData.faction or 0])
		
		if can_use and rp.shop.ModelsMap[uid][4] then
			can_use = rp.shop.ModelsMap[uid][4][teamData.team] and true or false
		end
		if can_use and rp.shop.ModelsMap[uid][5] then
			can_use = rp.shop.ModelsMap[uid][5][teamData.faction or 0] and true or false
		end
		
        if
            (not LocalPlayer():HasUpgrade(uid)) or
            (not can_use) 
        then
            continue
        end

        for IIndex, MData in pairs(rp.shop.ModelsMap[uid][1]) do
            local mdl = MData;
            table.insert(self.AppearanceModels, mdl)
            --self.AppearancePointers[mdl] = 0;
            self.AppearanceCustom[mdl] = uid;
        end
    end

    local appearance_skins = {}
    if not self.AppearanceCustom[self.AppearanceModel] then
		local key = table.GetKeys(appearance)[1]
		
        if appearance[key] and appearance[key].skins then
            if #appearance[key].skins > 1 then
				appearance_skins = appearance[key].skins
			else
                self.AppearanceSkin = appearance[key].skins[1] or 0;
            end
		else
            local appearance_skincount = self.JobCustomizeMenu.JobIcon.mdl.Entity.SkinCount(self.JobCustomizeMenu.JobIcon.mdl.Entity)

            if appearance_skincount > 1 then
                for skin_id = 0, appearance_skincount - 1 do
                    table.insert(appearance_skins, skin_id)
                end
            else
                self.AppearanceSkin = 0;
            end
       	end
    end
	
    if rp.cfg.AllowDisguiseName and (not self.DisableNameChanger) then
        self.JobCustomizeMenu.NameChanger = vgui.Create( "DTextEntry", JobCustomizeMenu );
        local NameChanger = self.JobCustomizeMenu.NameChanger;
        NameChanger:Dock( TOP );
        NameChanger:DockMargin( padding, 0, padding, padding * 0.5 );
        NameChanger:SetFont( "rpui.disguise.font.big" );
        NameChanger:SetTall( GetAdaptSize(45, ScrH()) );
        NameChanger:SetPlaceholderText( translates and translates.Get("Введите имя") or "Введите имя" );
        NameChanger.Paint = function( this, w, h )
            SetDrawColor( rpui.UIColors.White );
            DrawRect( 0, 0, w, h );

            if (#this:GetValue() == 0) and this:GetPlaceholderText() then
                SimpleText( this:GetPlaceholderText(), this:GetFont(), w * 0.5, h * 0.5, rpui.UIColors.Background, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
            else
                this:DrawTextEntryText( rpui.UIColors.Black, rpui.UIColors.Black, rpui.UIColors.Black );
            end
        end
    end

    CreateSettingSlider( translates and translates.Get("МОДЕЛЬ") or "МОДЕЛЬ", self.AppearanceModels, function( val )
		self.AppearanceModel = val or "";
	end );

	CreateSettingSlider( translates and translates.Get("РОСТ") or "РОСТ", mdlScales, function( val )
		self.AppearanceScale = val or 1;
	end );

	CreateSettingSlider( translates and translates.Get("СКИН") or "СКИН", appearance_skins, function( val )
		self.AppearanceSkin = val or 1;
	end );
	
	if slider_count < 4 then
		self.JobCustomizeMenu.Random = vgui.Create( "DButton", JobCustomizeMenu );
		local Random = self.JobCustomizeMenu.Random;
		Random:Dock( TOP );
        Random:DockMargin( padding, 0, padding, padding * 0.5 );
       	Random:SetFont( "rpui.disguise.font.big" );
       	Random:SetText( translates and translates.Get("СЛУЧАЙНЫЙ ВЫБОР") or "СЛУЧАЙНЫЙ ВЫБОР" );
       	Random:SetTall( GetAdaptSize(45, ScrH()) );
      	Random.DoClick = function( this )
           for k, v in pairs( JobCustomizeMenu:GetChildren() ) do
               if (v:GetName() == "rpui.ButtonWang") and (v:GetTall() > 0) then v:SelectRandom(); end
           end
       	end
       	Random.Paint = function( this, w, h )
            SetDrawColor( rpui.UIColors.Background );
            DrawRect( 0, 0, w, h );
            local baseColor, textColor = rpui.GetPaintStyle( this, STYLE_BLANKSOLID );
            SetDrawColor( baseColor );
            DrawRect( 0, 0, w, h );
            SimpleText( this:GetText(), this:GetFont(), w/2, h/2, textColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
            return true
        end
	end
end

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

	return string.utf8upper(out);
end

function PANEL:RefreshAppearanceVisuals()
	if not IsValid(self.JobCustomizeMenu) then return end

	local mdlent = self.JobCustomizeMenu.JobIcon.mdl
	if not IsValid(mdlent) then return end
	local ModelViewer = mdlent
	mdlent = mdlent.Entity

	mdlent:SetModel(self.AppearanceModel)

    mdlent:ResetSequence( mdlent:LookupSequence("idle_all_02") )

    local mins, maxs = mdlent:GetModelBounds()
    local _mdlOrigin = Vector( 16, -20, maxs.z * 0.7 )
    local _camOrigin = _mdlOrigin - Vector( -100, 0, 0 )
	
    mdlent:SetEyeTarget( _camOrigin )

    mdlent:SetSkin( self.AppearanceSkin or 0 )
    mdlent:SetModelScale( self.AppearanceScale or 1 )

    for k, v in pairs( mdlent:GetBodyGroups() ) do
        mdlent:SetBodygroup( k, 0 );
    end
    
	local appearance = self.SelectedJob.appearance

	if appearance then
		for k, v in pairs(appearance) do
			if isnumber(k) and istable(v) and v.mdl and v.mdl == self.AppearanceModel then
				self.AppearanceBodygroups = v.bodygroups or {}
			end
		end
	end
	
    for bgroup_id, bgroup in pairs( self.AppearanceBodygroups or {} ) do
        mdlent:SetBodygroup( bgroup_id, istable(bgroup) and bgroup[1] or bgroup );
    end
end

function PANEL:AcceptClick( job, jobindex )
    local name;

    if IsValid( self.JobCustomizeMenu.NameChanger ) then
        name = self.JobCustomizeMenu.NameChanger:GetValue();
    end

	self:SendNet( job, jobindex, name );

	timer.Simple( 0.25, function()
		if not IsValid(self) then return end
		self:Disguise( job, jobindex );
	end );
end

function PANEL:Disguise(job, jobindex)
	local mdlindex = 1
	if istable(self.SelectedJob.model) then
		for k, v in pairs(self.SelectedJob.model) do
			if v == self.AppearanceModel then
				mdlindex = k
				break
			end
		end
	end

	--net.Start("disguisemodel")
	--	net.WriteInt(mdlindex, 8)
	--net.SendToServer()

    self.AppearanceID = 0
        
    net.Start( "net.appearance.BodygroupData" );
        net.WriteUInt( self.AppearanceID, 6 );
        net.WriteUInt( self.AppearanceSkin or 0, 6 );
        net.WriteFloat( self.AppearanceScale );
                    
        local CustomAppearanceUID = self.AppearanceCustom[self.AppearanceModel];
        net.WriteBool( CustomAppearanceUID and true or false );
		net.WriteString( CustomAppearanceUID or "" );

        local bgroups = self.AppearanceBodygroups;
        local bgroups_keys  = table.GetKeys(bgroups);
        local bgroups_count = table.Count(bgroups);
        
        net.WriteUInt( bgroups_count, 6 );
        for i = 1, bgroups_count do
            local id = bgroups_keys[i];
            net.WriteUInt( id, 6 );
            net.WriteUInt( istable(bgroups[id]) and bgroups[id][1] or bgroups[id], 6 );
        end
    net.SendToServer();

    self:Close();
end

vgui.Register( "urf.im/rpui/menus/disguise", PANEL, "urf.im/rpui/menus/blank&scroll" );

--
function rp.DisguiseMenuF4()
    local ScrScale = ScrH() / 1080;

    local menu = vgui.Create( "urf.im/rpui/menus/disguise" );
    menu:SetSize( 400 * ScrScale, 800 * ScrScale );
    menu:Center()
    menu:MakePopup()

    menu.header.IcoSizeMult = 1.5;
    menu.header:SetIcon( "rpui/misc/disguise.png" );
    menu.header:SetTitle( translates and translates.Get("МАСКИРОВКА") or "МАСКИРОВКА" );
    menu.header:SetFont( "rpui.disguise.title" );

    local faction = LocalPlayer():GetTeamTable().disguise_faction;
    local faction_nice_name = rp.Factions[LocalPlayer():GetFaction()].printName

    if not faction then
        rp.Notify(NOTIFY_ERROR, translates.Get("Вы не можете маскироваться"))
        menu:Remove()
        return
    end

    local disguise_teams = rp.Factions[faction] and rp.Factions[faction].jobsMap or false

    if not disguise_teams or #disguise_teams == 0 then
        rp.Notify(NOTIFY_ERROR, translates.Get("Вы не можете маскироваться"))
        menu:Remove()
        return
    end

    local disguise_count = 0

    for k, v in newyork( disguise_teams ) do
        if LocalPlayer():CanTeam( rp.TeamByID(v) ) then
            if rp.TeamByID(v).disableDisguise then continue end
            menu:AddElement(v)
            disguise_count = disguise_count + 1
        end
    end

    if disguise_count == 0 then
        rp.Notify(NOTIFY_ERROR, translates.Get("У вас нет открытых профессий во фракции %s", faction_nice_name))
        menu:Remove()
        return
    end

    function menu:SendNet( job, jobindex, name )
        net.Start( "PlayerDisguise" );
            net.WriteUInt( jobindex, 9 );

            if name then
                net.WriteString( name );
            end
        net.SendToServer();
    end
end


function rp.DisguiseMenu()
	local ent     = net.ReadEntity();
	local faction = net.ReadInt(8);

	local ScrScale = ScrH() / 1080;

	local menu = vgui.Create( "urf.im/rpui/menus/disguise" );
	menu:SetSize( 400 * ScrScale, 800 * ScrScale );
	menu:Center();
	menu:MakePopup();

    menu.header.IcoSizeMult = 1.5;
	menu.header:SetIcon( "rpui/misc/disguise.png" );
	menu.header:SetTitle( translates and translates.Get("МАСКИРОВКА") or "МАСКИРОВКА" );
	menu.header:SetFont( "rpui.disguise.title" );

	for k, v in newyork( rp.Factions[faction] and rp.Factions[faction].jobsMap or {} ) do
		if LocalPlayer():CanTeam( rp.TeamByID(v) ) then
			if rp.TeamByID(v).disableDisguise then continue end
			menu:AddElement(v);
		end
	end

    function menu:SendNet( job, jobindex, name )
		net.Start( "DisguiseToServer" );
            net.WriteEntity( ent );
			net.WriteUInt( jobindex, 9 );
            
            if name then
                net.WriteString( name );
            end
		net.SendToServer();
	end
end