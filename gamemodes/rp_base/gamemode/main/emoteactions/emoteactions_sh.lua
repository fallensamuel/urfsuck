if SERVER then
	util.AddNetworkString( "PlayerAnimAction" );
	util.AddNetworkString( "PlayerAnimSequence" );
	util.AddNetworkString( "PlayerAnimState" );
	util.AddNetworkString( "PlayerAnimSync" );
	util.AddNetworkString( "PlayerAnimRun" );
end

EmoteActions 			 = EmoteActions 			or {};
EmoteActions.PlayerAnims = EmoteActions.PlayerAnims or {};
EmoteActions.Actions     = EmoteActions.Actions     or {};
EmoteActions.ChatAliases = EmoteActions.ChatAliases or {};

EmoteActions.SharedSequences    = EmoteActions.SharedSequences or {};
EmoteActions.SharedSequencesMap = EmoteActions.SharedSequencesMap or {};

if SERVER then
	EmoteActions.MemWeapons = EmoteActions.MemWeapons or {};
end

ACTION_STATE_UNDEFINED = -1;

ACTION_STATE_STARTING  = 0;
ACTION_STATE_RUNNING   = 1;
ACTION_STATE_ENDING    = 2;
ACTION_STATE_ENDED     = 3;

function EmoteActions:GetSharedSequenceName( sharedSeqID )
	return EmoteActions.SharedSequencesMap[sharedSeqID] or "";
end

function EmoteActions:GetSharedSequenceID( sharedSeqName )
	return EmoteActions.SharedSequences[sharedSeqName] or -1;
end

function EmoteActions:RegisterAction( actID, actData )
	if !actData.ChatAliases then
		actData.ChatAliases = {actID}
	end
	if actData.ChatAliases then
		for _, alias in pairs( actData.ChatAliases ) do
			EmoteActions.ChatAliases[alias] = actID;
		end
		actData.ChatAliases = nil;
	end

	actData.SequenceCheck = actData.SequenceCheck or actData.Sequences;

	if actData.Sequences then
		for _, seq in pairs( actData.Sequences ) do
			if not EmoteActions.SharedSequences[seq] then
				local sharedSeqID = #EmoteActions.SharedSequencesMap + 1;

				EmoteActions.SharedSequences[seq]            = sharedSeqID;
				EmoteActions.SharedSequencesMap[sharedSeqID] = seq;
			end
		end
	end

	if actData.Org then
		rp.orgs.EmoteActs 					  = rp.orgs.EmoteActs or {};
		rp.orgs.EmoteActs[actData.Org]        = rp.orgs.EmoteActs[actData.Org] or {};
		rp.orgs.EmoteActs[actData.Org][actID] = true;
	end

	EmoteActions.Actions[ actID ] = actData;
end

function EmoteActions:GetRawAction( actID )
	return EmoteActions.Actions[ actID ] or {}; 
end

hook.Add( "Initialize", "EmoteActions.Initialize.OverrideCalcMainActivity", function( ply, vel )
	rp.RegisterCalcMainActivityFunction( "EmoteActions", function( ply, vel )
		local act, seq;

		if EmoteActions.PlayerAnims[ply] ~= nil then
			if ply:Alive() then
				act = ACT_INVALID;
				seq = ply:LookupSequence( EmoteActions:GetSharedSequenceName(EmoteActions.PlayerAnims[ply].Sequence) ) or -1;
			end		

			if seq ~= ply.LastSequence then
				if seq == -1 then
					ply:ResetSequenceInfo();
					ply:ResetSequence( -1 );
				end
				ply:SetCycle( 0 );
			end
			
			ply.LastSequence = seq;
		end

		return act, seq
	end );
end );

hook.Add( "Think", "EmoteActions.Think.PlayerChecks", function()
	for ply, _ in pairs( EmoteActions.PlayerAnims ) do
		if isnumber(ply) or not IsValid(ply) then
			EmoteActions.PlayerAnims[ply] = nil;
		else
			if not ply:Alive() then
				-- some weird ragdoll fix
				if CLIENT then
					if ply == LocalPlayer() and IsValid(LocalPlayer()) then
						if not EmoteActions.LocalPlayer.__ragdollFixed and IsValid(LocalPlayer():GetRagdollEntity()) then
							local ragdollPhysObj = LocalPlayer():GetRagdollEntity():GetPhysicsObject();
							if (IsValid(ragdollPhysObj)) then
								ragdollPhysObj:EnableMotion( false );

								ragdollPhysObj:SetVelocity( Vector(0,0,0) );

								EmoteActions.LocalPlayer.__ragdollFixed = true;
								timer.Simple( 0, function()
									ragdollPhysObj:EnableMotion( true );
								end );
							end
						end
					end
				end
				EmoteActions.PlayerAnims[ply] = nil;
			end
		end
	end
end );


hook.Add( "StartCommand", "EmoteActions.StartCommand", function( ply, CUserCmd )
	if EmoteActions.PlayerAnims[ply] then
		local rawAction = EmoteActions:GetRawAction( ply:GetEmoteAction() );

		if not rawAction.onStartCommand then return end
		rawAction:onStartCommand( ply, CUserCmd );
	end
end );


hook.Add( "PlayerSwitchWeapon", "EmoteActions.PlayerSwitchWeapon", function( ply, oldWeapon, newWeapon )
	if EmoteActions.PlayerAnims[ply] then
		if IsValid(oldWeapon) and IsValid(newWeapon) then
			if (oldWeapon:GetClass() == "weapon_handcuffed") or (newWeapon:GetClass() == "weapon_handcuffed") then
				return false
			end
		end
		
		local rawAction = EmoteActions:GetRawAction( ply:GetEmoteAction() );

		if rawAction.SwitchToKeys and newWeapon:GetClass() == "keys" then
			if SERVER then
				EmoteActions.MemWeapons[ply] = oldWeapon;
			end

			return false
		end

		if not rawAction.WepSwitchAllowed then
			return true
		end
	end
end );

EmoteActions.nwSync = nw.Register( "EmoteActions.Sequence" );
EmoteActions.nwSync:Write( net.WriteUInt, 14 );
EmoteActions.nwSync:Read( net.ReadUInt, 14 );
EmoteActions.nwSync:SetPlayer();
EmoteActions.nwSync:SetHook( "EmoteActions:SequenceSync" );