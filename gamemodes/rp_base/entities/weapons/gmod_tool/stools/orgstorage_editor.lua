-- "gamemodes\\rp_base\\entities\\weapons\\gmod_tool\\stools\\orgstorage_editor.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
--
if CLIENT then
    m_searchlist = {};

    function m_searchlist:DoCoroutineBreak()
        self.co_break = (self.co_break or 0) + 1;
        if self.co_break % 64 == 0 then coroutine.yield(); end
    end

    function m_searchlist:SetHeader( name )
        if not IsValid( self.List ) then return end
        local column = (self.List.Columns or {})[1];
        if not IsValid( column ) then return end
        column:SetName( name );
    end

    function m_searchlist:SetActionText( val )
        if not IsValid( self.Action ) then return end
        self.Action:SetText( val );
    end

    function m_searchlist:SetConVar( cvar )
        self.ConVar = GetConVar( cvar );
    end

    function m_searchlist:DoSearch( needle )
        if not IsValid( self.List ) then return end

        self.co_Search = coroutine.create( function()
            needle = utf8.lower( string.Trim(needle) );

            local result = {};
            local empty = #needle == 0;
            local c, haystack = 1, "";

            -- Search:
            self.List.b_Searching = true;

            for k, line in ipairs( self.List:GetLines() ) do
                line.i_SearchPos = k;
                line:Show();

                if not empty then
                    haystack = utf8.lower( line:GetValue(1) );

                    line.i_SearchPos = string.find( haystack, needle );
                    line[line.i_SearchPos and "Show" or "Hide"]( line );
                end

                result[c] = line;
                c = c + 1;

                self:DoCoroutineBreak();
            end

            -- Sort:
            table.sort( result, function( a, b )
                return (a.i_SearchPos or c) < (b.i_SearchPos or c)
            end );

            self.List.b_Searching = false;
            self.List.Sorted = result;

            self.List:SetDirty( true );
            self.List:InvalidateLayout();

            if IsValid( self.List.VBar ) then
                self.List.VBar:SetScroll( 0 );
            end
        end );
    end

    function m_searchlist:Init()
        local color_transparent = Color( 0, 0, 0, 200 );

        -- Layout:
        self.Search = vgui.Create( "DTextEntry", self );
        self.Search:Dock( TOP );
        self.Search:SetUpdateOnType( true );
        self.Search:SetPlaceholderText( translates.Get("Поиск:") );

        self.Action = vgui.Create( "DButton", self );
        self.Action:Dock( BOTTOM );

        self.List = vgui.Create( "DListView", self );
        self.List:Dock( FILL );
        self.List:DockMargin( 0, 4, 0, 4 );
        self.List:SetSortable( false );
        self.List:SetMultiSelect( false );
        self.List:AddColumn( "Values" );

        -- Hooks:
        self.List.PaintOver = function( this, w, h )
            if this.b_Searching then
                surface.SetDrawColor( color_transparent );
                surface.DrawRect( 0, 0, w, h );
            end
        end

        self.Search.OnValueChange = function( this, value )
            self:OnSearchValueChanged( value );
        end

        self.List.OnRowSelected = function( this, idx, pnl )
            self:OnRowSelected( pnl:GetValue(1), pnl );
        end

        self.Action.DoClick = function( this )
            self:OnActionClick( this );
        end
    end

    function m_searchlist:Think()
        if self.co_Search then
            coroutine.resume( self.co_Search );
        end
    end

    function m_searchlist:OnSearchValueChanged( val )
        self:DoSearch( val );
    end

    function m_searchlist:OnActionClick( pnl )
    end

    function m_searchlist:OnRowSelected( val, pnl )
        if self.ConVar then
            self.ConVar:SetString( val );
        end
    end

    m_searchlist = vgui.RegisterTable( m_searchlist, "EditablePanel" );
end

--
local m_propclasses = { ["prop_physics_multiplayer"] = true, ["prop_physics"] = true };
local color_green = Color( 125, 255, 125, 75 );
local color_red = Color( 255, 125, 125, 75 );

local function IsProp( ent )
    return m_propclasses[ent:GetClass()] or false;
end

local function IsStorage( ent )
    return ent:GetNWBool( "isorgstorage", false );
end

local function CanUse( ply )
    return ply:IsRoot() or ply:HasFlag("e")
end

--
TOOL.Name = "Org Storage editor";
TOOL.Category = "Staff";

TOOL.Information = {
	{ name = "left" },
	{ name = "right" },
};

TOOL.ClientConVar = {
    ["org"] = "",
    ["width"] = 5,
    ["height"] = 5,
};

if CLIENT then
    language.Add( "tool.orgstorage_editor.name", translates.Get("Organisation storage editor") );
    language.Add( "tool.orgstorage_editor.desc", translates.Get("Инструмент для создания складов организаций") );
    language.Add( "tool.orgstorage_editor.left", translates.Get("Создать склад") );
    language.Add( "tool.orgstorage_editor.right", translates.Get("Удалить склад") );
    language.Add( "tool.orgstorage_editor.values_header", translates.Get("Организации:") );
    language.Add( "tool.orgstorage_editor.action", translates.Get("Обновить") );
    language.Add( "tool.orgstorage_editor.width", translates.Get("Ширина:") );
    language.Add( "tool.orgstorage_editor.height", translates.Get("Высота:") );
    language.Add( "tool.orgstorage_editor.prop", translates.Get("Это обычный проп") );
    language.Add( "tool.orgstorage_editor.storage", translates.Get("Это склад организации") );
    language.Add( "tool.orgstorage_editor.confirm", translates.Get("Подтвердите удаление склада организации") );
end

if SERVER then
    TOOL.Confirmations = {};

    hook.Add( "rp.pp.PlayerCanManipulate", "OrgStorageEditor", function( ply, ent )
		local wep = ply:GetActiveWeapon();
		if CanUse( ply ) and (ent.AllowRootManipulate or (wep.IsGModTool == true and wep:GetMode() == "orgstorage_editor")) then
			return true
		end
	end );
end

--
function TOOL:DoCooldown( time )
    local ply = self:GetOwner();
    time = time or 3;

	if ply:IsCooldownAction( "OrgStorageEditorTool", time ) then
		if SERVER then
            rp.Notify( ply, NOTIFY_ERROR, rp.Term("CooldownAction"), math.Round(ply:GetCooldownActionTIme("OrgStorageEditorTool"), 1) );
        end

		return true
	end
end

function TOOL:DrawHUD()
    if not CanUse( LocalPlayer() ) then return end

    local tr = LocalPlayer():GetEyeTrace();

    local ent = tr.Entity;
    if not IsProp( ent ) and not IsStorage( ent ) then return end

    local origin, angles = ent:GetPos(), ent:GetAngles();
    local mins, maxs = ent:GetRenderBounds();

    local col = IsStorage( ent ) and color_green or color_red;

    cam.Start3D( EyePos(), EyeAngles() );
        render.SetColorMaterial();
        render.SetBlend( 0.2 );
        render.DrawBox( origin, angles, mins, maxs, col );
        render.DrawWireframeBox( origin, angles, mins, maxs, col );
    cam.End3D();

    draw.SimpleText( IsStorage( ent ) and "#tool.orgstorage_editor.storage" or "#tool.orgstorage_editor.prop", "HudFont", ScrW() * 0.5, ScrH() - 16, col, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM );
end

function TOOL:LeftClick( tr )
    if not CanUse( self:GetOwner() ) then return end

    local ent = tr.Entity;

    if not IsValid( ent ) then return false end
    if not IsProp( ent ) then return false end

    if self:DoCooldown( 10 ) then
        return false
    end

    if SERVER then
        rp.orgs.CreateStorage( self:GetClientInfo("org"),
            ent:GetModel(),
            ent:GetPos(),
            ent:GetAngles(),
            math.Clamp( self:GetClientNumber("width", 5), 5, 15 ),
            math.Clamp( self:GetClientNumber("height", 5), 5, 15 ),
            function( status )
                if not status then return end
                SafeRemoveEntity( ent );
            end
        );
    end

	return true
end

function TOOL:RightClick( tr )
    if not CanUse( self:GetOwner() ) then return end

    local ent = tr.Entity;

    if not IsValid( ent ) then return false end
    if not IsStorage( ent ) then return false end

    if SERVER then
        if ent.b_MarkedForDeletion then
            return false
        end

        local ply = self:GetOwner();

        if not self.Confirmations[ply] then
            if self:DoCooldown( 0.5 ) then
                return false
            end

            self.Confirmations[ply] = true;
            rp.Notify( ply, NOTIFY_GENERIC, "#tool.orgstorage_editor.confirm" );

            timer.Simple( 3, function()
                if not IsValid( self ) then return end
                self.Confirmations[ply] = nil;
            end );

            return
        end

        if self:DoCooldown( 5 ) then
            return false
        end

        rp.orgs.RemoveStorage( ent, ply, function( status, e, p )
            if not status then return end

            local prop = ents.Create( "prop_physics_multiplayer" );
            prop:SetModel( e:GetModel() );
            prop:SetPos( e:GetPos() );
            prop:SetAngles( e:GetAngles() );
            prop:Spawn();
            prop.AllowRootManipulate = true;

            if IsValid( p ) then
                prop:CPPISetOwner( p );
            end

            local physObj = prop:GetPhysicsObject();
            if IsValid( physObj ) then
                physObj:Sleep();
                physObj:EnableMotion( false );
            end
        end );

        ent.b_MarkedForDeletion = true;
        self.Confirmations[ply] = nil;
    end

	return true
end

function TOOL.BuildCPanel( CPanel )
    local SearchList = vgui.CreateFromTable( m_searchlist, nil, "SearchList" );
    SearchList:SetTall( 300 );
    SearchList:SetHeader( "#tool.orgstorage_editor.values_header" );
    SearchList:SetActionText( "#tool.orgstorage_editor.action" );
    SearchList:SetConVar( "orgstorage_editor_org" );
    SearchList.OnActionClick = function( this )
        if not IsValid( this.List ) then return end

        net.Start( "rp.orgs.GetList" ); net.SendToServer();
        this.List:Clear();

        hook.Add( "OnOrgListReceived", this, function( pnl, orgs )
            if not IsValid( this ) then return end
            hook.Remove( "OnOrgListReceived", this );

            if not IsValid( this.List ) then return end

            for k, org in ipairs( orgs or {} ) do
                this.List:AddLine( org );
            end
        end );
    end

    CPanel:Help( "#tool.orgstorage_editor.desc" );
    CPanel:AddItem( SearchList );

    CPanel:NumSlider( "#tool.orgstorage_editor.width", "orgstorage_editor_width", 5, 15, 0 );
    CPanel:NumSlider( "#tool.orgstorage_editor.height", "orgstorage_editor_height", 5, 15, 0 );
end
