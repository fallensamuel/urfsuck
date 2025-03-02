local PLAYER = FindMetaTable( "Player" );

function PLAYER:SetEmoteAction( actID )
	net.Start( "PlayerAnimAction" );
		net.WriteEntity( self )
		net.WriteString( actID );

		if actID ~= "" then
			EmoteActions.PlayerAnims[self]        = EmoteActions.PlayerAnims[self] or {}
			EmoteActions.PlayerAnims[self].Action = actID;
		else
			EmoteActions.PlayerAnims[self] = nil;
		end
	net.Broadcast();
end


function PLAYER:SetEmoteActionSequence( sharedSeqID )
	if not EmoteActions.PlayerAnims[self] then return end

	self:SetNetVar( "EmoteActions.Sequence", sharedSeqID );
	EmoteActions.PlayerAnims[self].Sequence = sharedSeqID;

	local actionID  = EmoteActions.PlayerAnims[self].Action
	local rawAction = EmoteActions:GetRawAction( actionID );
	
	timer.Create( "EmoteAction_run_"..self:UniqueID(), 0, 0, function()
		local shouldHeal = rawAction.ShouldHeal or false;

		if actionID == "__sitaction" then
			local seqSharedName = EmoteActions:GetSharedSequenceName(self:GetEmoteActionSequence());

			if seqSharedName then
				local seq = EmoteActions.SitActions[seqSharedName] or {};
				shouldHeal = seq.ShouldHeal or false;
			end
		end

		if shouldHeal then
			if (self:Health() < self:GetMaxHealth()) and (self.EA_HealCooldown <= CurTime()) then
				self:SetHealth( self:Health() + 1 );
				self.EA_HealCooldown = CurTime() + 5;
			end
		end

		if self:GetEmoteActionState() == ACTION_STATE_RUNNING then
			rawAction:onRun(self);
		end
	end );
end


function PLAYER:SetEmoteActionState( stt )
	if not EmoteActions.PlayerAnims[self] then return end

	net.Start( "PlayerAnimState" );
		net.WriteInt( (stt or ACTION_STATE_UNDEFINED), 3 );
		
		EmoteActions.PlayerAnims[self].State = stt;
	net.Send( self );
end


function PLAYER:SetEmoteActionSequences( sharedSeqID, length, startCallback, endCallback )
	local actionID  = EmoteActions.PlayerAnims[self].Action
	local rawAction = EmoteActions:GetRawAction( actionID );

	local seq   = EmoteActions:GetSharedSequenceID(sharedSeqID);
	local seqID = self:LookupSequence( sharedSeqID );

	length = length or self:SequenceDuration( seqID );

	self:SetEmoteActionSequence( seq );

	if length > 0 then
		if startCallback and length >= self:SequenceDuration( seqID ) then
			timer.Create( "EmoteAction_start_"..self:UniqueID(), self:SequenceDuration( seqID ), 1, startCallback );
		end

		if endCallback then
			timer.Create( "EmoteAction_end_"..self:UniqueID(), length, 1, endCallback );
		end

		timer.Create( "EmoteAction_run_"..self:UniqueID(), 0, 0, function()
			local shouldHeal = rawAction.ShouldHeal or false;

			if actionID == "__sitaction" then
				local seqSharedName = EmoteActions:GetSharedSequenceName(self:GetEmoteActionSequence());

				if seqSharedName then
					local seq = EmoteActions.SitActions[seqSharedName] or {};
					shouldHeal = seq.ShouldHeal or false;
				end
			end

			if shouldHeal then
				if (self:Health() < self:GetMaxHealth()) and (self.EA_HealCooldown <= CurTime()) then
					self:SetHealth( self:Health() + 1 );
					self.EA_HealCooldown = CurTime() + 5;
				end
			end

			if self:GetEmoteActionState() == ACTION_STATE_RUNNING then
				rawAction:onRun(self);
			end
		end );
	else
		if startCallback then
			timer.Create( "EmoteAction_start_"..self:UniqueID(), self:SequenceDuration( seqID ), 1, startCallback );
		end

		timer.Create( "EmoteAction_run_"..self:UniqueID(), 0, 0, function()
			local shouldHeal = rawAction.ShouldHeal or false;

			if actionID == "__sitaction" then
				local seqSharedName = EmoteActions:GetSharedSequenceName(self:GetEmoteActionSequence());

				if seqSharedName then
					local seq = EmoteActions.SitActions[seqSharedName] or {};
					shouldHeal = seq.ShouldHeal or false;
				end
			end

			if shouldHeal then
				if (self:Health() < self:GetMaxHealth()) and (self.EA_HealCooldown <= CurTime()) then
					self:SetHealth( self:Health() + 1 );
					self.EA_HealCooldown = CurTime() + 5;
				end
			end

			if self:GetEmoteActionState() == ACTION_STATE_RUNNING then
				rawAction:onRun(self);
			end
		end );
	end
end



util.AddNetworkString('CheckAnim')
net.Receive('CheckAnim', function()
	--print('DanceLog ' .. net.ReadString() or '')
end)


function PLAYER:StartEmoteAction( actID, args )
	local rawAction = EmoteActions:GetRawAction( actID );

	if rawAction == {} then return end

	if self:GetEmoteAction() == "__sitaction" then return end

	--print('DanceLog ' .. actID)
	self:SetEmoteAction( actID );

	if rawAction:onCall( self ) then
		if rawAction.SwitchToKeys and self:HasWeapon("keys") then
			self:SelectWeapon( "keys" );
		end

		self.EA_HealCooldown = CurTime() + 5;
		rawAction:onStart( self, args );
	else
		self:DropEmoteAction();
	end
end

function PLAYER:ForceStartEmoteAction(actID, args)
	local rawAction = EmoteActions:GetRawAction( actID );

	if rawAction == {} then return end

	--print('DanceLog ' .. actID)
	self:SetEmoteAction( actID );

	self.EA_HealCooldown = CurTime() + 5;
	rawAction:onStart( self, args );
end


function PLAYER:ForceEmoteAction()
	if EmoteActions.PlayerAnims[ self ] then
		local rawAction = EmoteActions:GetRawAction( EmoteActions.PlayerAnims[ self ].Action );
		
		if timer.Exists( "EmoteAction_start_"..self:UniqueID() ) then timer.Remove( "EmoteAction_start_"..self:UniqueID() ) end
		if timer.Exists( "EmoteAction_end_"..self:UniqueID() )   then timer.Remove( "EmoteAction_end_"..self:UniqueID() )   end
		if timer.Exists( "EmoteAction_run_"..self:UniqueID() )   then timer.Remove( "EmoteAction_run_"..self:UniqueID() )   end

		rawAction:onEnd( self );

		if EmoteActions.MemWeapons[self] then
			self:SelectWeapon( EmoteActions.MemWeapons[self]:GetClass() );
			EmoteActions.MemWeapons[self] = nil;
		end
	end
end


function PLAYER:DropEmoteAction()
	if EmoteActions.PlayerAnims[ self ] then
		self:SetEmoteActionSequence( 0 );

		if timer.Exists( "EmoteAction_start_"..self:UniqueID() ) then timer.Remove( "EmoteAction_start_"..self:UniqueID() ) end
		if timer.Exists( "EmoteAction_end_"..self:UniqueID() )   then timer.Remove( "EmoteAction_end_"..self:UniqueID() )   end
		if timer.Exists( "EmoteAction_run_"..self:UniqueID() )   then timer.Remove( "EmoteAction_run_"..self:UniqueID() )   end

		self:SetEmoteAction( "" );

		if EmoteActions.MemWeapons[self] then
			self:SelectWeapon( EmoteActions.MemWeapons[self]:GetClass() );
			EmoteActions.MemWeapons[self] = nil;
		end
	end
end