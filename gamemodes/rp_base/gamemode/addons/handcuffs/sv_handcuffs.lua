-------------------------------------
---------------- Cuffs --------------
-------------------------------------
-- Copyright (c) 2015 Nathan Healy --
-------- All rights reserved --------
-------------------------------------
-- sv_handcuffs.lua         SERVER --
--                                 --
-- Server-side handcuff stuff.     --
-------------------------------------

if CLIENT then return end

util.AddNetworkString( "Cuffs_GagPlayer" )
util.AddNetworkString( "Cuffs_BlindPlayer" )
util.AddNetworkString( "Cuffs_FreePlayer" )
util.AddNetworkString( "Cuffs_DragPlayer" )

util.AddNetworkString( "Cuffs_TiePlayers" )
util.AddNetworkString( "Cuffs_UntiePlayers" )

local function GetTrace( ply )
	local tr = util.TraceLine( {start=ply:EyePos(), endpos=ply:EyePos()+(ply:GetAimVector()*100), filter=ply} )
	if IsValid(tr.Entity) and tr.Entity:IsPlayer() then
		local cuffed,wep = tr.Entity:IsHandcuffed()
		if cuffed then return tr,wep end
	end
end

//
// Standard hooks
--CreateConVar( "cuffs_Yourictsuicide", 1, {FCVAR_ARCHIVE,FCVAR_SERVER_CAN_EXECUTE} )
--hook.Add( "CanPlayerSuicide", "Cuffs RestrictSuicide", function( ply )
--	if ply:IsHandcuffed() and cvars.Bool("cuffs_restrictarrest") then return false end
--end)
--CreateConVar( "cuffs_restrictteams", 1, {FCVAR_ARCHIVE,FCVAR_SERVER_CAN_EXECUTE} )
--hook.Add( "PlayerCanJoinTeam", "Cuffs RestrictTeam", function( ply )
--	if ply:IsHandcuffed() and cvars.Bool("cuffs_restrictteams") then return false end
--end)
--hook.Add( "PlayerCanSeePlayersChat", "Cuffs ChatGag", function( _,_,_, ply )
--	if not IsValid(ply) then return end
--	
--	local cuffed,wep = ply:IsHandcuffed()
--	if cuffed and wep:GetIsGagged() then return false end
--end)
--hook.Add( "PlayerCanHearPlayersVoice", "Cuffs VoiceGag", function( _, ply )
--	if not IsValid(ply) then return end
--	
--	local cuffed,wep = ply:IsHandcuffed()
--	if cuffed and wep:GetIsGagged() then return false end
--end)

// 
// DarkRP

hook.Add( "playerCanChangeTeam", "Cuffs RestrictTeam", function( ply, tm, force )
	if ply:IsHandcuffed() and not force then
		ply:Notify(NOTIFY_ERROR, rp.Term('CannotChangeJob'), translates and translates.Get('Наручники') or 'Наручники')
		return false 
	end
end)

//
// Cuffed player interaction
net.Receive( "Cuffs_GagPlayer", function(_,ply)
	if (not IsValid(ply)) or ply:IsHandcuffed() then return end
	
	local target = net.ReadEntity()
	if (not IsValid(target)) or target==ply then return end
	
	local cuffed, cuffs = target:IsHandcuffed()
	if not (cuffed and IsValid(cuffs) and cuffs:GetCanGag()) then return end
	
	local tr = GetTrace(ply)
	if not (tr and tr.Entity==target) then return end
	
	local shouldGag = net.ReadBit()==1
	cuffs:SetIsGagged( shouldGag )
	hook.Call( shouldGag and "OnHandcuffGag" or "OnHandcuffUnGag", GAMEMODE, ply, target, cuffs )
end)
net.Receive( "Cuffs_BlindPlayer", function(_,ply)
	if (not IsValid(ply)) or ply:IsHandcuffed() then return end
	
	local target = net.ReadEntity()
	if (not IsValid(target)) or target==ply then return end
	
	local cuffed, cuffs = target:IsHandcuffed()
	if not (cuffed and IsValid(cuffs) and cuffs:GetCanBlind()) then return end
	
	local tr = GetTrace(ply)
	if not (tr and tr.Entity==target) then return end
	
	local shouldBlind = net.ReadBit()==1
	cuffs:SetIsBlind( shouldBlind )
	hook.Call( shouldBlind and "OnHandcuffBlindfold" or "OnHandcuffUnBlindfold", GAMEMODE, ply, target, cuffs )
end)
net.Receive( "Cuffs_FreePlayer", function(_,ply)
	if (not IsValid(ply)) or ply:IsHandcuffed() then return end
	
	local target = net.ReadEntity()
	if (not IsValid(target)) or target==ply then return end
	
	local cuffed, cuffs = target:IsHandcuffed()
	if not (cuffed and IsValid(cuffs)) then return end
	if IsValid(cuffs:GetFriendBreaking()) then return end
	
	local tr = GetTrace(ply)
	if not (tr and tr.Entity==target) then return end
	
	cuffs:SetFriendBreaking( ply )
end)
net.Receive( "Cuffs_DragPlayer", function(_,ply)
	if (not IsValid(ply)) or ply:IsHandcuffed() then return end
	
	local target = net.ReadEntity()
	if (not IsValid(target)) or target==ply then return end
	
	local cuffed, cuffs = target:IsHandcuffed()
	if not (cuffed and IsValid(cuffs) and cuffs:GetRopeLength()>0) then return end
	
	local tr = GetTrace(ply)
	if not (tr and tr.Entity==target) then return end
	
	local shouldDrag = net.ReadBit()==1
	if shouldDrag then
		if not (IsValid(cuffs:GetKidnapper())) then
			cuffs:SetKidnapper( ply )
			hook.Call( "OnHandcuffStartDragging", GAMEMODE, ply, target, cuffs )
		end
	else
		if ply==cuffs:GetKidnapper() then
			cuffs:SetKidnapper( nil )
			hook.Call( "OnHandcuffStopDragging", GAMEMODE, ply, target, cuffs )
		end
	end
end)

local HookModel = Model("models/props_c17/TrapPropeller_Lever.mdl")
net.Receive( "Cuffs_TiePlayers", function(_,ply)
	if (not IsValid(ply)) or ply:IsHandcuffed() then return end
	
	local CuffOwner;

	local DraggedCuffs = {}
	for _,c in pairs(ents.FindByClass("weapon_handcuffed")) do
		if c:GetRopeLength()>0 and c:GetKidnapper()==ply then
			table.insert( DraggedCuffs, c )
			CuffOwner = c:GetOwner() or c.Owner;
		end
	end
	if #DraggedCuffs<=0 then return end
	
	local tr = util.TraceLine( {start=ply:EyePos(), endpos=ply:EyePos()+(ply:GetAimVector()*100), filter=ply} )
	if not tr.Hit then return end
	
	if IsValid(tr.Entity) then // Pass to another player
		if tr.Entity:IsPlayer() then
			for i=1,#DraggedCuffs do
				if DraggedCuffs[i].Owner==tr.Entity then
					DraggedCuffs[i]:SetKidnapper(nil)
					hook.Call( "OnHandcuffStopDragging", GAMEMODE, ply, DraggedCuffs[i].Owner, DraggedCuffs[i] )
				else
					DraggedCuffs[i]:SetKidnapper(tr.Entity)
					hook.Call( "OnHandcuffStopDragging", GAMEMODE, ply, DraggedCuffs[i].Owner, DraggedCuffs[i] )
					hook.Call( "OnHandcuffStartDragging", GAMEMODE, tr.Entity, DraggedCuffs[i].Owner, DraggedCuffs[i] )
				end
			end
			return
		elseif tr.Entity.IsHandcuffHook and tr.Entity.TiedHandcuffs then
			for i=1,#DraggedCuffs do
				DraggedCuffs[i]:SetKidnapper(tr.Entity)
				table.insert( tr.Entity.TiedHandcuffs, DraggedCuffs[i] )
				hook.Call( "OnHandcuffStopDragging", GAMEMODE, ply, DraggedCuffs[i].Owner, DraggedCuffs[i] )
				hook.Call( "OnHandcuffTied", GAMEMODE, ply, DraggedCuffs[i].Owner, DraggedCuffs[i], tr.Entity )
			end
			return
		end
	end
	
	local hk = ents.Create("prop_physics")
	hk:SetPos( tr.HitPos + tr.HitNormal )
	local ang = tr.HitNormal:Angle()
	ang:RotateAroundAxis( ang:Up(), -90 )
	hk:SetAngles( ang )
	hk:SetModel( HookModel )
	hk:Spawn()
	
	-- hk:SetMoveType( MOVETYPE_NONE )
	if IsValid(tr.Entity) then
		hk:SetParent( tr.Entity )
		hk:SetMoveType( MOVETYPE_VPHYSICS )
	else
		hk:SetMoveType( MOVETYPE_NONE )
	end
	hk:SetCollisionGroup( COLLISION_GROUP_WEAPON )
	
	hk:SetNWBool("Cuffs_TieHook", true)
	hk.IsHandcuffHook = true
	hk.TiedHandcuffs = {}
	hk.TiedPlayer = CuffOwner;
	
	local Timer = 'CuffsTieHook' .. hk:EntIndex();

	timer.Remove(Timer);
	timer.Create(Timer, 1, 0, function()
		if (!IsValid(hk) or !IsValid(hk.TiedPlayer) or !hk.TiedPlayer:Alive()) then
			if (IsValid(hk)) then hk:Remove(); end
			timer.Remove(Timer);
		end
	end);
	
	local Timer = 'CuffsTieHook' .. hk:EntIndex();

	timer.Remove(Timer);
	timer.Create(Timer, 1, 0, function()
		if (!IsValid(hk) or !IsValid(hk.TiedPlayer) or !hk.TiedPlayer:Alive()) then
			if (IsValid(hk)) then hk:Remove(); end
			timer.Remove(Timer);
		end
	end);

	for i=1,#DraggedCuffs do
		DraggedCuffs[i]:SetKidnapper( hk )
		table.insert( hk.TiedHandcuffs, DraggedCuffs[i] )
		hook.Call( "OnHandcuffStopDragging", GAMEMODE, ply, DraggedCuffs[i].Owner, DraggedCuffs[i] )
		hook.Call( "OnHandcuffTied", GAMEMODE, ply, DraggedCuffs[i].Owner, DraggedCuffs[i], hk )
	end
end)

local function DoUntie( ply, ent )
	for i=1,#ent.TiedHandcuffs do
		if not IsValid(ent.TiedHandcuffs[i]) then continue end
		
		ent.TiedHandcuffs[i]:SetKidnapper( ply )
		hook.Call( "OnHandcuffUnTied", GAMEMODE, ply, ent.TiedHandcuffs[i].Owner, ent.TiedHandcuffs[i], ent )
		hook.Call( "OnHandcuffStartDragging", GAMEMODE, ply, ent.TiedHandcuffs[i].Owner, ent.TiedHandcuffs[i] )
	end
	
	ent:Remove()
end
net.Receive( "Cuffs_UntiePlayers", function(_,ply)
	if (not IsValid(ply)) or ply:IsHandcuffed() then return end
	
	local tr = util.TraceLine( {start=ply:EyePos(), endpos=ply:EyePos()+(ply:GetAimVector()*100), filter=ply} )
	if IsValid(tr.Entity) and tr.Entity.IsHandcuffHook and tr.Entity.TiedHandcuffs then
		DoUntie( ply, tr.Entity )
	end
end)
hook.Add( "AllowPlayerPickup", "Cuffs UntieHook", function(ply,ent)
	if IsValid(ent) and ent.IsHandcuffHook and ent.TiedHandcuffs then
		if (not IsValid(ply)) or ply:IsHandcuffed() then return end
		
		DoUntie( ply, ent )
		return false
	end
end)

hook.Add("PlayerLeaveVehicle", "DropHandcuffed", function(ply, veh)
	timer.Simple(0.25, function()
		if not IsValid(ply) or not IsValid(veh) or ply:InVehicle() then return end

		for k, v in pairs(player.GetAll()) do
			if v == ply then continue end


			local b, w = v:IsHandcuffed()
			if b and IsValid(w:GetKidnapper()) and w:GetKidnapper() == ply then
				v._AllowVehExit = true
				v:ExitVehicle()
			end
		end
	end)
end)

hook.Add("PlayerEnteredVehicle", "EnterHandcuffed", function(ply, veh)
	timer.Simple(0.25, function()
		if not IsValid(ply) or not IsValid(veh) or not ply:InVehicle() then return end

		local par = veh:GetParent()
		local sbool = IsValid(par) and par.SetPassenger
		for k, v in pairs(player.GetAll()) do
			if v == ply then continue end


			local b, w = v:IsHandcuffed()
			if b and IsValid(w:GetKidnapper()) and w:GetKidnapper() == ply then
				v.AllowEnterVehNow = true
				if sbool then
					par:SetPassenger(v)
				else
					v:EnterVehicle(veh)
				end
			end
		end
	end)
end)

hook.Add("CanExitVehicle", "HandcuffsDisallowExit", function(veh, ply)
	if ply:IsHandcuffed() then
		if ply._AllowVehExit then
			ply._AllowVehExit = nil
			return true
		else
			return false
		end
	end
end)