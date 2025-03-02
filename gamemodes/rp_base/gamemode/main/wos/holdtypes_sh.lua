-- "gamemodes\\rp_base\\gamemode\\main\\wos\\holdtypes_sh.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
--[[-------------------------------------------------------------------
	wiltOS Hold Type Register:
		The core files needed to make your own hold types
			Powered by
						  _ _ _    ___  ____  
				__      _(_) | |_ / _ \/ ___| 
				\ \ /\ / / | | __| | | \___ \ 
				 \ V  V /| | | |_| |_| |___) |
				  \_/\_/ |_|_|\__|\___/|____/ 
											  
 _____         _                 _             _           
|_   _|__  ___| |__  _ __   ___ | | ___   __ _(_) ___  ___ 
  | |/ _ \/ __| '_ \| '_ \ / _ \| |/ _ \ / _` | |/ _ \/ __|
  | |  __/ (__| | | | | | | (_) | | (_) | (_| | |  __/\__ \
  |_|\___|\___|_| |_|_| |_|\___/|_|\___/ \__, |_|\___||___/
                                         |___/             
-------------------------------------------------------------------]]--[[
							  
	Lua Developer: King David
	Contact: http://steamcommunity.com/groups/wiltostech
		
----------------------------------------]]--

wOS.AnimExtension.HoldTypes = wOS.AnimExtension.HoldTypes or {}
wOS.AnimExtension.TranslateHoldType = wOS.AnimExtension.TranslateHoldType or {}

wOS.AnimExtension.ActIndex = {
	[ "pistol" ] 			= ACT_HL2MP_IDLE_PISTOL,
	[ "smg" ] 				= ACT_HL2MP_IDLE_SMG1,
	[ "grenade" ] 			= ACT_HL2MP_IDLE_GRENADE,
	[ "ar2" ] 				= ACT_HL2MP_IDLE_AR2,
	[ "shotgun" ] 			= ACT_HL2MP_IDLE_SHOTGUN,
	[ "rpg" ]	 			= ACT_HL2MP_IDLE_RPG,
	[ "physgun" ] 			= ACT_HL2MP_IDLE_PHYSGUN,
	[ "crossbow" ] 			= ACT_HL2MP_IDLE_CROSSBOW,
	[ "melee" ] 			= ACT_HL2MP_IDLE_MELEE,
	[ "slam" ] 				= ACT_HL2MP_IDLE_SLAM,
	[ "normal" ]			= ACT_HL2MP_IDLE,
	[ "fist" ]				= ACT_HL2MP_IDLE_FIST,
	[ "melee2" ]			= ACT_HL2MP_IDLE_MELEE2,
	[ "passive" ]			= ACT_HL2MP_IDLE_PASSIVE,
	[ "knife" ]				= ACT_HL2MP_IDLE_KNIFE,
	[ "duel" ]				= ACT_HL2MP_IDLE_DUEL,
	[ "camera" ]			= ACT_HL2MP_IDLE_CAMERA,
	[ "magic" ]				= ACT_HL2MP_IDLE_MAGIC,
	[ "revolver" ]			= ACT_HL2MP_IDLE_REVOLVER,

	[ "safety" ]			= ACT_HL2MP_IDLE,
	[ "safety-pistol" ] 	= ACT_HL2MP_IDLE_PISTOL,
	[ "safety-smg" ] 		= ACT_HL2MP_IDLE_SMG1,
	[ "safety-grenade" ] 	= ACT_HL2MP_IDLE_GRENADE,
	[ "safety-ar2" ] 		= ACT_HL2MP_IDLE_AR2,
	[ "safety-shotgun" ] 	= ACT_HL2MP_IDLE_SHOTGUN,
	[ "safety-rpg" ]	 	= ACT_HL2MP_IDLE_RPG,
	[ "safety-physgun" ] 	= ACT_HL2MP_IDLE_PHYSGUN,
	[ "safety-crossbow" ] 	= ACT_HL2MP_IDLE_CROSSBOW,
	[ "safety-melee" ] 		= ACT_HL2MP_IDLE_MELEE,
	[ "safety-slam" ] 		= ACT_HL2MP_IDLE_SLAM,
	[ "safety-normal" ]		= ACT_HL2MP_IDLE,
	[ "safety-fist" ]		= ACT_HL2MP_IDLE_FIST,
	[ "safety-melee2" ]		= ACT_HL2MP_IDLE_MELEE2,
	[ "safety-passive" ]	= ACT_HL2MP_IDLE_PASSIVE,
	[ "safety-knife" ]		= ACT_HL2MP_IDLE_KNIFE,
	[ "safety-duel" ]		= ACT_HL2MP_IDLE_DUEL,
	[ "safety-camera" ]		= ACT_HL2MP_IDLE_CAMERA,
	[ "safety-magic" ]		= ACT_HL2MP_IDLE_MAGIC,
	[ "safety-revolver" ]	= ACT_HL2MP_IDLE_REVOLVER,
}

function wOS.AnimExtension:RegisterHoldtype( data )

	self.TranslateHoldType[ data.HoldType ] = data
    self.HoldTypeMeta:CreateMetaType( self.TranslateHoldType[ data.HoldType ] )
	
	if data.BaseHoldType then
		if prone then
			if prone.animations then
				if prone.animations.WeaponAnims then
					prone.animations.WeaponAnims.moving[ data.HoldType ] = prone.animations.WeaponAnims.moving[ data.BaseHoldType ]
					prone.animations.WeaponAnims.idle[ data.HoldType ] = prone.animations.WeaponAnims.idle[ data.BaseHoldType ]
				end
			end
		end
	end

	print( "[wOS] Registered new Hold Type: " .. data.Name )
	
end

local meta = FindMetaTable( "Player" )
local ENTITY = FindMetaTable( "Entity" )

local AttackTable = {
[ ACT_MP_ATTACK_STAND_PRIMARYFIRE  ] = true,
[ ACT_MP_ATTACK_CROUCH_PRIMARYFIRE  ] = true,
[ ACT_MP_ATTACK_STAND_SECONDARYFIRE  ] = true,
[ ACT_MP_ATTACK_CROUCH_SECONDARYFIRE  ] = true,
}

local _TranslateWeaponActivity = meta.TranslateWeaponActivity
function meta:TranslateWeaponActivity( act )

	if AttackTable[ act ] then
		local wep = self:GetActiveWeapon()
		if IsValid( wep ) then  
			local holdtype = wep:GetHoldType()
			if wOS.AnimExtension.TranslateHoldType[ holdtype ] then
				local ATTACK_DATA = wOS.AnimExtension.TranslateHoldType[ holdtype ]:GetActData( act )
				if ATTACK_DATA then
					local anim = self:LookupSequence( ATTACK_DATA.Sequence )
					self:AddVCDSequenceToGestureSlot( GESTURE_SLOT_VCD, anim, 0, true ) //Figure out weight to make it balanced!
					self:AnimSetGestureWeight( GESTURE_SLOT_VCD, ATTACK_DATA.Weight or 1 )
				end
			end
		end
	end
	
	return _TranslateWeaponActivity( self, act )

end

--[[
local _DoAnimationEvent = meta.DoAnimationEvent
function meta:DoAnimationEvent( ply, event, data )

	local act = _DoAnimationEvent( self, ply, event, data )
	print( act )
	local wep = self:GetActiveWeapon()
	if IsValid( wep ) then  
		local holdtype = wep:GetHoldType()
		if wOS.AnimExtension.TranslateHoldType[ holdtype ] then
			local result = wOS.AnimExtension.TranslateHoldType[ holdtype ][ act ]
			if result then
				if istable( result ) then
					result = table.Random( result )
				end
				if isstring( result ) then
					local anim = ply:LookupSequence( result )	
					ply.ActOverrider = act
					ply.SequenceTime = CurTime() + ply:SequenceDuration( anim )
				end
			end
		end
	end
	
	return act
end
]]--


--[[
hook.Add( "Initialize", "wOS.AnimExtension.CustomSequenceHoldtypes", function()
	print( "wOS anim >> CustomSequenceHoldtypes" );

	wOS.AnimExtension.CalcMainActivity = wOS.AnimExtension.CalcMainActivity or GAMEMODE.CalcMainActivity;

	--local _CalcMainActivity = GAMEMODE.CalcMainActivity
	function GAMEMODE:CalcMainActivity( ply, vel )
	
		--local act, seq = _CalcMainActivity( self, ply, vel )

		local act, seq = wOS.AnimExtension.CalcMainActivity( self, ply, vel )

		local wep = ply:GetActiveWeapon()
		if IsValid( wep ) then  
			local holdtype = wep:GetHoldType()
			if wOS.AnimExtension.TranslateHoldType[ holdtype ] then
				local ATTACK_DATA = wOS.AnimExtension.TranslateHoldType[ holdtype ]:GetActData( act )
				if ATTACK_DATA then
					seq = ply:LookupSequence( ATTACK_DATA.Sequence )
				end
			end
		end

		
		if act != ply.LastAct then
			ply:SetCycle( 0 )
		end
		
		ply.LastAct = act
		
		return act, seq
		
	end
	
end )
]]--

local IsWeaponInSafetyMode = function( wep )
	if wep.dt and wep.dt.Safe then -- swb
		return true
	end

	if wep.IsSafety and wep:IsSafety() then -- tfa
		return true
	end

	return false
end

hook.Add( "Initialize", "wOS.AnimExtension.CustomSequenceHoldtypes", function()	
	wOS.AnimExtension.CalcMainActivity = function( ply, vel, calcIdeal, calcSeqOverride )
		local act, seq = calcIdeal, calcSeqOverride
		local wep = ply:GetActiveWeapon()

		if IsValid( wep ) and wep.GetHoldType then
			local holdtype = wep:GetHoldType();

			if ply.animpack_HoldType then
				if IsWeaponInSafetyMode( wep ) then
					local animpack = AnimationPacks.Get( ply:GetAnimPack() );
					holdtype = animpack and (animpack.Translations["safety-"..holdtype] or animpack.Translations["safety"]) or wep:GetHoldType();
				else
					holdtype = ply.animpack_HoldType;
				end
			end

			if wOS.AnimExtension.TranslateHoldType[holdtype] then
				local ATTACK_DATA = wOS.AnimExtension.TranslateHoldType[holdtype]:GetActData( act );
				if ATTACK_DATA then
					seq = ply:LookupSequence( ATTACK_DATA.Sequence )
				end
			end
		end

		
		if act != ply.LastAct then
			ply:SetCycle( 0 )
		end
		
		ply.LastAct = act
		
		return act, seq
	end

	rp.RegisterCalcMainActivityFunction( "wOS", wOS.AnimExtension.CalcMainActivity );
end );