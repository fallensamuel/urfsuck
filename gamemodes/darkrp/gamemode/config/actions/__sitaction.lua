local ACTION = {}

ACTION.Name 	= "N/A";
ACTION.Desc 	= "N/A";
ACTION.Category = "N/A";

function ACTION:onCall( ply )
	local veh = ply:GetVehicle();

	if not IsValid(veh)									then return false end
	if veh:GetModel() ~= "models/nova/airboat_seat.mdl" then return false end

	local tab = {}

	if istable(simfphys) then
		if IsValid(ply:GetSimfphys()) then
			return false
		end
	end

	for seq in pairs( EmoteActions.SitActions ) do
		local seqID = ply:LookupSequence(seq);
        if seqID ~= -1 then
            table.insert( tab, seqID );
        end 
    end

	if #tab > 0 then
		return true
	else
		return false
	end
end

function ACTION:onStart( ply )
	if not ply.LastSitActionSeqName then
		ply.LastSitActionSeqName = cookie.GetString( "LastSitAction_" .. ply:SteamID64() );
	end

	if ply.LastSitActionSeqName then
		local seqID = EmoteActions:GetSharedSequenceID(ply.LastSitActionSeqName);
		if seqID ~= -1 then
			ply:SetEmoteActionSequence( seqID );
			ply:SetEmoteActionState( ACTION_STATE_RUNNING );
		else
			for seq in pairs( EmoteActions.SitActions ) do
				local seqID = EmoteActions:GetSharedSequenceID(seq);
				if seqID ~= -1 then
					ply:SetEmoteActionSequence( seqID );
					ply:SetEmoteActionState( ACTION_STATE_RUNNING );
					cookie.Set( "LastSitAction_" .. ply:SteamID64(), seq );
					break;
				end 
			end
		end
	else
		for seq in pairs( EmoteActions.SitActions ) do
			local seqID = EmoteActions:GetSharedSequenceID(seq);
			if seqID ~= -1 then
				ply:SetEmoteActionSequence( seqID );
				ply:SetEmoteActionState( ACTION_STATE_RUNNING );
				cookie.Set( "LastSitAction_" .. ply:SteamID64(), seq );
				break;
			end 
		end
	end
end

function ACTION:onRun( ply )
end

function ACTION:onEnd( ply )
end

if CLIENT then
	function ACTION:onCalcViewFirstperson( ply, origin, angles, FOV )
		local view = {};

		local headbone = ply:LookupBone("ValveBiped.Bip01_Head1");
		local bonepos = ply:GetBonePosition( headbone );

		view.origin     = bonepos;
		view.angles     = angles;
		view.fov        = FOV;

		return view;
	end

	function ACTION:onCalcViewThirdperson( ply, origin, angles, FOV )
		if not ply:GetVehicle() then return end

		local headbone = ply:LookupBone("ValveBiped.Bip01_Head1");
		local bonepos = ply:GetBonePosition( headbone );

		local Vehicle = ply:GetVehicle();

		local view = {
			origin = bonepos,
			angles = angles,
			fov    = FOV
		}

		local mn, mx = Vehicle:GetRenderBounds();
		local radius = ( mn - mx ):Length();
		local radius = radius + radius * Vehicle:GetCameraDistance();

		local TargetOrigin = view.origin + ( view.angles:Forward() * -radius );
		local WallOffset = 4;

		local tr = util.TraceHull( {
			start = view.origin,
			endpos = TargetOrigin,
			filter = function( e )
				local c = e:GetClass()
				return !c:StartWith( "prop_physics" ) &&!c:StartWith( "prop_dynamic" ) && !c:StartWith( "prop_ragdoll" ) && !e:IsVehicle() && !c:StartWith( "gmod_" )
			end,
			mins = Vector( -WallOffset, -WallOffset, -WallOffset ),
			maxs = Vector( WallOffset, WallOffset, WallOffset ),
		} );

		view.origin = tr.HitPos;
		view.drawviewer = true;

		if ( tr.Hit && !tr.StartSolid) then
			view.origin = view.origin + tr.HitNormal * WallOffset;
		end

		return view
	end

	function ACTION:onCalcView( ply, origin, angles, FOV )
		local veh = ply:GetVehicle();

		if IsValid(veh) then
			if not ply:GetVehicle():GetThirdPersonMode() then
				--return self:onCalcViewFirstperson( ply, origin, angles, FOV );
			else
				--return self:onCalcViewThirdperson( ply, origin, angles, FOV );
			end
		end
	end
end

EmoteActions:RegisterAction( "__sitaction", ACTION );