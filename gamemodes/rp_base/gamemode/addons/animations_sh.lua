// stolen from chessnut

if SERVER then
	util.AddNetworkString('seqSet')
	function PLAYER:forceSequence(sequence, callback, time, noFreeze)
		if (!sequence) then
			net.Start('seqSet')
				net.WriteEntity(self)
				net.WriteInt(-1, 8)
			net.Broadcast()
			return
		end

		local sequence = self:LookupSequence(sequence)

		if (sequence and sequence > 0) then
			time = time or self:SequenceDuration(sequence)

			self.nutSeqCallback = callback
			self.nutSeq = sequence

			if (!noFreeze) then
				self:SetMoveType(MOVETYPE_NONE)
			end

			if (time > 0) then
				timer.Create("nutSeq"..self:EntIndex(), time, 1, function()
					if (IsValid(self)) then
						self:leaveSequence()
					end
				end)
			end
			net.Start('seqSet')
				net.WriteEntity(self)
				net.WriteInt(sequence, 10)
			net.Broadcast()

			return time
		end

		return false
	end

	function PLAYER:leaveSequence()
		net.Start('seqSet')
			net.WriteEntity(self)
			net.WriteInt(-1, 10)
		net.Broadcast()

		self:SetMoveType(MOVETYPE_WALK)
		self.nutSeq = nil

		if (self.nutSeqCallback) then
			self:nutSeqCallback()
		end
	end
else
	net.Receive('seqSet', function()
		local entity = net.ReadEntity()
		local sequence = net.ReadInt(10)
		if (IsValid(entity)) then
			if (sequence == -1) then
				entity.nutForceSeq = nil
				return
			end

			entity:SetCycle(0)
			entity:SetPlaybackRate(1)
			entity.nutForceSeq = sequence
		end
	end)

	--[[
	function GM:CalcMainActivity(client, velocity)
		local seqIdeal, seqOverride = self.BaseClass.CalcMainActivity(self.BaseClass, client, velocity)
		return seqIdeal, client.nutForceSeq or seqOverride
	end
	]]--

	rp.RegisterCalcMainActivityFunction( "nut-animations", function( ply, velocity )
		return nil, ply.nutForceSeq or nil;
	end );
end
