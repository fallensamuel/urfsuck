-- "gamemodes\\rp_base\\gamemode\\main\\emoteactions\\emoteactions_cl.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
EmoteActions 			 = EmoteActions 			or {};
EmoteActions.LocalPlayer = EmoteActions.LocalPlayer or {};

EmoteActions.LocalPlayer.ActCameraAngles   = Angle();
EmoteActions.LocalPlayer.PlayerAngles      = Angle();
EmoteActions.LocalPlayer.IsFirstperson     = false;
EmoteActions.LocalPlayer.__pCanChange      = true;
EmoteActions.LocalPlayer.__ragdollFixed    = false;

EmoteActions.LocalPlayer.SyncData = {};

local emotions_txt = translates.Get( "Эмоции" )
local laughs_txt = translates.Get( "Насмешки" )

EmoteActions.GmodActs = {
	{ "cheer",    translates.Get("Радость"),          emotions_txt   },
	{ "laugh",    translates.Get("Смех"),             emotions_txt   },
	{ "muscle",   translates.Get("Бицуха"),           laughs_txt 	 },
	{ "zombie",   translates.Get("Зомби"),            laughs_txt 	 },
	{ "robot",    translates.Get("Робот"),            laughs_txt 	 },
	{ "dance",    translates.Get("Танец"),            laughs_txt 	 },
	{ "agree",    translates.Get("Согласиться"),      emotions_txt   },
	{ "becon",    translates.Get("сюда иди"),         emotions_txt   },
	{ "disagree", translates.Get("Не согласиться"),   emotions_txt   },
	{ "salute",   translates.Get("Платить респекты"), emotions_txt   },
	{ "wave",     translates.Get("Помахать"),         emotions_txt   },
	{ "forward",  translates.Get("Указать"),          emotions_txt   },
	{ "pers",     translates.Get("Журавль"),          laughs_txt 	 }
};

hook.Add( "EmoteActions:SequenceSync", "PlayerAnimSync", function( ply, seq )	
	if seq == 0 then
		EmoteActions.PlayerAnims[ply] = nil;
	else
		EmoteActions.PlayerAnims[ply] = EmoteActions.PlayerAnims[ply] or {};
		EmoteActions.PlayerAnims[ply].Sequence = seq;
		EmoteActions.PlayerAnims[ply].Start = SysTime();
	end
end );

net.Receive( "PlayerAnimAction", function()
	local pl = net.ReadEntity();
	local act = net.ReadString();

	if not IsValid(pl) then return end
	
	if act ~= "" then
		EmoteActions.PlayerAnims[pl]        = EmoteActions.PlayerAnims[pl] or {}
		EmoteActions.PlayerAnims[pl].Action = act;
		EmoteActions.PlayerAnims[pl].Start = SysTime();
	else
		EmoteActions.PlayerAnims[pl] = nil;
	end
end );

net.Receive( "PlayerAnimState", function()
	local stt = net.ReadInt(3);

	if EmoteActions.PlayerAnims[LocalPlayer()] then
		EmoteActions.PlayerAnims[LocalPlayer()].State = stt;
	end
end );

net.Receive( "PlayerAnimReset", function()
	local ply = net.ReadEntity()
	local seq = ply.LastSequence
	
	if seq then
		ply:ResetSequenceInfo()
		ply:ResetSequence( -1 )
		ply:SetCycle( 0 )
	end
end );


hook.Add( "Think", "EmoteActions.Think.UpdateAngles", function()
	if LocalPlayer():GetEmoteAction() == "" then
		EmoteActions.LocalPlayer.PlayerAngles = LocalPlayer():GetAngles();
	end
end );


hook.Add( "CreateMove", "EmoteActions.CreateMove.MainCreateMove", function( CUserCmd )
    if LocalPlayer():Alive() then
        if EmoteActions.PlayerAnims[LocalPlayer()] then
            local rawAction = EmoteActions:GetRawAction( EmoteActions.PlayerAnims[LocalPlayer()].Action );

            if not rawAction.onCreateMove then return end
            return rawAction:onCreateMove( CUserCmd );
        end
    end
end );


hook.Add( "CalcView", "EmoteActions.CalcView.MainCalcView", function( ply, origin, angles, FOV )
    if LocalPlayer():Alive() then
        if EmoteActions.PlayerAnims[LocalPlayer()] then
            local rawAction = EmoteActions:GetRawAction( EmoteActions.PlayerAnims[LocalPlayer()].Action );

            if not rawAction.onCalcView then return end
            return rawAction:onCalcView( ply, origin, angles, FOV );
        end
    end
end );

hook.Add( "Think", "EmoteActions.Think.RagdollFix", function()
	if LocalPlayer():Alive() and EmoteActions.LocalPlayer.__ragdollFixed then
		EmoteActions.LocalPlayer.__ragdollFixed = false;
	end
end );

-- / VGUI: / --

function EmoteActions:ShowGUI()
	local Base = vgui.Create( "DFrame" );
		Base:SetTitle( "Меню анимаций:" );
		Base:SetSize( math.floor(ScrW()*0.2), math.floor(ScrH()*0.6) );
		Base:SetPos( ScrW() - Base:GetWide()*1.5, ScrH()/2 - Base:GetTall()/2 );
		Base:SetSizable( true );

	Base.ScrollPnl = vgui.Create( "DScrollPanel", Base );
		Base.ScrollPnl:Dock( FILL );

	for _, actID in pairs( LocalPlayer():GetAvalibleActions() ) do
		local rawAction = EmoteActions:GetRawAction( actID );

		local ActionBtn = Base.ScrollPnl:Add( "DButton" );
			ActionBtn:DockPadding( 16, 8, 16, 8 );
			ActionBtn:SetHeight( 32 );
			ActionBtn:Dock( TOP );
			ActionBtn:SetText( rawAction.Name );
			ActionBtn:SetTooltip( rawAction.Desc );
			ActionBtn.DoClick = function()
				--LocalPlayer():RunEmoteAction( actID );
			end
	end

end

concommand.Add( "ShowActions", EmoteActions.ShowGUI );

-- / --

concommand.Add(
	"emote",

	function( ply, cmd, args )
		local emoteAct = args[1];
		local actID    = EmoteActions.ChatAliases[emoteAct];

		if (table.HasValue(rp.cfg.DonateEmotions_BlockedForEmoteCmd or {}, actID)) then
			if not (ply:HasUpgrade('shopacts_extra') or ply:HasPremium()) then return end
		end

		if actID then
			LocalPlayer():RunEmoteAction( actID );
		end
	end,

	function( cmd, stringargs )
		stringargs = string.Trim( stringargs );
		stringargs = string.lower( stringargs );


		local out = {}
		
		for _, actID in pairs( LocalPlayer():GetAvalibleActions() ) do
			if string.StartWith( actID, stringargs ) then
				table.insert( out, "emote " .. actID );
			end
		end

		if #out == 0 then
			out = table.GetKeys( LocalPlayer():GetAvalibleActions() );
		end

		return out;
	end
);