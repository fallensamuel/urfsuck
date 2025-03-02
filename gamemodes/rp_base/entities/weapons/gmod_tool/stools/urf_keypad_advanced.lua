-- "gamemodes\\rp_base\\entities\\weapons\\gmod_tool\\stools\\urf_keypad_advanced.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
TOOL.Category = "Roleplay";
TOOL.Name 	  = translates.Get( "Улучшенный Кейпад" );
TOOL.Command  = nil;


TOOL.ClientConVar["weld"]   = "1";
TOOL.ClientConVar["freeze"] = "1";

TOOL.ClientConVar["factions"] = "";
TOOL.ClientConVar["orgs"]     = "";

TOOL.ClientConVar["repeats_granted"] = "0";
TOOL.ClientConVar["repeats_denied"]  = "0";

TOOL.ClientConVar["length_granted"] = "4";
TOOL.ClientConVar["length_denied"]  = "0.1";

TOOL.ClientConVar["delay_granted"] = "0";
TOOL.ClientConVar["delay_denied"]  = "0";

TOOL.ClientConVar["init_delay_granted"] = "0";
TOOL.ClientConVar["init_delay_denied"]  = "0";

TOOL.ClientConVar["key_granted"]        = "0";
TOOL.ClientConVar["key_denied"]         = "0";


cleanup.Register( "keypads" );


if CLIENT then
	language.Add( "tool.urf_keypad_advanced.name", translates.Get("Улучшенный Кейпад") );
	language.Add( "tool.urf_keypad_advanced.0", translates.Get("ЛКМ: Создать, ПКМ: Обновить") );
	language.Add( "tool.urf_keypad_advanced.desc", translates.Get("Создает улучшенный кейпад") );

	language.Add( "Undone_AdvKeypad", translates.Get("Убран улучшенный кейпад") );
	language.Add( "Cleanup_AdvKeypads", translates.Get("Улучшенные кейпады") );
	language.Add( "Cleaned_AdvKeypads", translates.Get("Очищены все улучшенные кейпады") );

	language.Add( "SBoxLimit_keypads", translates.Get("Вы достигли лимита улучшенных кейпадов!") );
end


function TOOL:SetupKeypad( ent, pass )
	ent:SetData( {
		Owner = self:GetOwner(),

		RepeatsGranted = self:GetClientNumber("repeats_granted"),
		RepeatsDenied  = self:GetClientNumber("repeats_denied"),

		LengthGranted = math.Clamp(self:GetClientNumber("length_granted"), 4, 10),
		LengthDenied  = self:GetClientNumber("length_denied"),

		DelayGranted = math.Clamp(self:GetClientNumber("delay_granted"), 4, 10),
		DelayDenied  = self:GetClientNumber("delay_denied"),

		InitDelayGranted = self:GetClientNumber("init_delay_granted"),
		InitDelayDenied  = self:GetClientNumber("init_delay_denied"),

		KeyGranted = self:GetClientNumber("key_granted"),
		KeyDenied  = self:GetClientNumber("key_denied"),

		factions = self:GetClientInfo("factions"),
		orgs     = self:GetClientInfo("orgs"),
	} );
end


function TOOL:LeftClick( tr )
	local trace_ent = tr.Entity;

	if IsValid(trace_ent) and (trace_ent:GetClass() == "player") then return false end
	if CLIENT then return true end

	local ply       = self:GetOwner();
	local spawn_pos = tr.HitPos + tr.HitNormal;
	local spawn_ang = tr.HitNormal:Angle();
	
	if (not ply:IsRoot()) and (not self:GetWeapon():CheckLimit("AdvKeypads")) then return false end
	
	local ent = ents.Create("urf_keypad_advanced");
	if not IsValid(ent) then return end
	
	ent:SetPos( spawn_pos );
	ent:SetAngles( spawn_ang );
	ent:Spawn();
	ent:SetPlayer( ply );
	ent:Activate();

	self:SetupKeypad( ent );
	
	undo.Create( "AdvKeypad" );
		local phys = ent:GetPhysicsObject();

		phys:EnableCollisions( false );
		phys:EnableMotion( false );

		if tobool( self:GetClientNumber("weld") ) then
			timer.Simple( FrameTime(), function()
				if IsValid(ent) and IsValid(trace_ent) then
					local weld = constraint.Weld( ent, trace_ent, 0, tr.PhysicsBone, 0, true, true );

					if weld then
						ent:SetMoveType( MOVETYPE_VPHYSICS );
						phys:EnableMotion( true );
					end
				end
			end );
		end

		undo.AddEntity( ent );
		undo.SetPlayer( ply );
	undo.Finish();

	ply:AddCount( "AdvKeypads", ent );
	ply:AddCleanup( "AdvKeypads", ent );

	return true
end


function TOOL:RightClick( tr )
	local trace_ent = tr.Entity;

	if IsValid(trace_ent) and (trace_ent:GetClass() ~= "urf_keypad_advanced") then return false end
	if CLIENT then return true end

	local ply       = self:GetOwner();
	local password  = tonumber( ply:GetInfo("keypad_password") );

	if (trace_ent:GetClass() == "urf_keypad_advanced") and (trace_ent.KeypadData.Owner == ply) then
		self:SetupKeypad( trace_ent, password ); -- validated password
		return true
	end
end


if CLIENT then
	function TOOL:GetAssocCvar( name )
		return table.ToAssoc( self:GetClientInfo(name):Split(",") );
	end


	function TOOL:SetClientInfo( key, val )
		RunConsoleCommand( self.Mode .."_".. key, val );
	end


	local function ResetSettings( ply )
		RunConsoleCommand( "urf_keypad_advanced_repeats_granted",    "0" );
		RunConsoleCommand( "urf_keypad_advanced_repeats_denied",     "0" );
		RunConsoleCommand( "urf_keypad_advanced_length_granted",     "4" );
		RunConsoleCommand( "urf_keypad_advanced_length_denied",      "0.1" );
		RunConsoleCommand( "urf_keypad_advanced_delay_granted",      "0" );
		RunConsoleCommand( "urf_keypad_advanced_delay_denied",       "0" );
		RunConsoleCommand( "urf_keypad_advanced_init_delay_granted", "0" );
		RunConsoleCommand( "urf_keypad_advanced_init_delay_denied",  "0" );
		RunConsoleCommand( "urf_keypad_advanced_factions",           "" );
		RunConsoleCommand( "urf_keypad_advanced_orgs",               "" );
	end

	concommand.Add( "urf_keypad_advanced_reset", ResetSettings );


	function TOOL.BuildCPanel( CPanel )
		CPanel:CheckBox( translates.Get("Сварить и заморозить кейпад"), "urf_keypad_advanced_weld" );
		//CPanel:CheckBox( translates.Get("Заморозить кейпад"), "urf_keypad_advanced_freeze" );

		local ctrl = vgui.Create( "CtrlNumPad" );
		ctrl:SetConVar1( "urf_keypad_advanced_key_granted" );
		ctrl:SetConVar2( "urf_keypad_advanced_key_denied" );
		ctrl:SetLabel1( translates.Get("Доступ разрешен") );
		ctrl:SetLabel2( translates.Get("Доступ запрещен") );
		CPanel:AddPanel( ctrl );

		local reset = CPanel:Button( translates.Get("Сбросить настройки") );

		CPanel:Help( "" );

		local Text = vgui.Create( "DLabel", CPanel );
		Text:Dock( TOP );
		Text:SetText( translates.Get("Настройки доступа") );
		Text:SetColor( Color(0, 128, 0) );
		Text:SetContentAlignment( 5 );
		CPanel:AddPanel( Text );

		local refresh = CPanel:Button( translates.Get("Обновить списки") );
        
		local fac_list = vgui.Create( "DListView", CPanel );
		fac_list:SetMultiSelect( true );
		fac_list:AddColumn( translates.Get("Фракции") );
		fac_list:SetSortable( false );
		fac_list:SetSize( CPanel:GetWide(), 220 );
		CPanel:AddPanel( fac_list );
        
		local org_list = vgui.Create( "DListView", CPanel );
		org_list:SetMultiSelect( true );
		org_list:AddColumn( translates.Get("Организации") );
		org_list:SetSortable( false );
		org_list:SetSize( CPanel:GetWide(), 220 );
		CPanel:AddPanel( org_list );
        
		Text = vgui.Create( "DLabel", CPanel );
		Text:Dock( TOP );
		Text:SetText( translates.Get("Настройки при предоставлении доступа") );
		Text:SetColor( Color(0, 128, 0) );
		Text:SetContentAlignment( 5 );
		CPanel:AddPanel( Text );
        
		CPanel:NumSlider( translates.Get("Длина задержки"), "urf_keypad_advanced_length_granted", 4, 10, 2 );
		CPanel:NumSlider( translates.Get("Начальная задержка"), "urf_keypad_advanced_init_delay_granted", 0, 10, 2 );
		CPanel:NumSlider( translates.Get("Задержка многократного нажатия"), "urf_keypad_advanced_delay_granted", 0, 10, 2 );
		CPanel:NumSlider( translates.Get("Дополнительные повторы"), "urf_keypad_advanced_repeats_granted", 0, 5, 0 );
        
		CPanel:Help("");
        
		Text = vgui.Create( "DLabel", CPanel );
		Text:Dock( TOP );
		Text:SetText( translates.Get("Настройки при отказе доступа") );
		Text:SetColor( Color(128, 0, 0) );
		Text:SetContentAlignment( 5 );
		CPanel:AddPanel( Text );
        
		CPanel:NumSlider( translates.Get("Длина задержки"), "urf_keypad_advanced_length_denied", 0.1, 10, 2 );
		CPanel:NumSlider( translates.Get("Начальная задержка"), "urf_keypad_advanced_init_delay_denied", 0, 10, 2 );
		CPanel:NumSlider( translates.Get("Задержка многократного нажатия"), "urf_keypad_advanced_delay_denied", 0, 10, 2 );
		CPanel:NumSlider( translates.Get("Дополнительные повторы"), "urf_keypad_advanced_repeats_denied", 0, 5, 0 );

		local function DoOnSelected( pnl, cvar )
			pnl.OnClickLine = function( me, row )
				row:SetSelected( not row:IsSelected() );
				row.m_fClickTime = SysTime();
                
				local val = GetConVar("urf_keypad_advanced_"..cvar):GetString() or "";
                
				if #val == 0 then
					val = row:IsSelected() and row.uid or val;
				else
					local data = table.ToAssoc( val:Split(",") );
					data[row.uid] = row:IsSelected() or nil;
					val = table.concatKeys( data, "," );
				end
                
				RunConsoleCommand( "urf_keypad_advanced_"..cvar, val );
			end
		end
                
		local function RefreshListViews()
            local cvar_factions = GetConVar("urf_keypad_advanced_factions"):GetString():Trim():Split(",") or {};
			local cvar_orgs     = GetConVar("urf_keypad_advanced_orgs"):GetString():Trim():Split(",") or {};

			local factions_d = table.ToAssoc( cvar_factions ) or {};
			local orgs_d     = table.ToAssoc( cvar_orgs )     or {};
            
			local orgs = {};
            
			for k, ply in ipairs( player.GetAll() ) do
				local org = ply:GetOrg();
				if org then orgs[org] = true; end
			end

			fac_list:Clear();
			for k, v in ipairs( rp.Factions ) do
				local fac_l = fac_list:AddLine( v.printName );
				fac_l.uid   = tostring( k );

				if factions_d[fac_l.uid] then
					fac_list:SelectItem( fac_l );
				end
			end

			org_list:Clear();
			for org in pairs( orgs ) do
				local org_l = org_list:AddLine( org );
				org_l.uid = tostring( org );

				if orgs_d[org_l.uid.uid] then
					org_list:SelectItem( org_l );
				end
			end

			DoOnSelected( org_list, "orgs" );
			DoOnSelected( fac_list, "factions" );
		end

		reset.DoClick = function()
			RunConsoleCommand( "urf_keypad_advanced_reset" );

			timer.Simple( FrameTime(), function()
				RefreshListViews();
			end );
		end

		refresh.DoClick = function()
			RefreshListViews();
		end

		RefreshListViews();

		--[[
		local __upd = vgui.Create( "Panel", CPanel );
		__upd:SetTall( 1 );
		__upd:Dock( TOP );
		__upd.Think = function( this )
			if (this.DoRefresh or 0) < SysTime() then
				RefreshListViews();
				this.DoRefresh = SysTime() + 30;
			end
		end
		CPanel:AddPanel( __upd );
		]]--
	end
end
