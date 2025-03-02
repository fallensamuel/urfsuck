-- "gamemodes\\darkrp\\gamemode\\config\\emoteactions\\__base.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local ACTION = {}

ACTION.Name     = "N/A";
ACTION.Desc     = "N/A";
ACTION.Category = "Эмоции";

ACTION.ChatAliases   = {};
ACTION.Sequences     = {};
ACTION.WeaponCheck   = {};

ACTION.WepSwitchAllowed = false;
ACTION.SwitchToKeys     = false;

function ACTION:GetAvalibleSequences( ply )
	local tab = {}

	for _, seqID in pairs( self.Sequences ) do
		if ply:LookupSequence( seqID ) ~= -1 then
			table.insert( tab, seqID );
		end
	end

	return tab
end

function ACTION:onCall( ply )
	self.SequenceCheck = self.SequenceCheck or self.Sequences;

	for _, seqID in pairs( self.SequenceCheck ) do
		if ply:LookupSequence( seqID ) == -1 then
			rp.Notify( ply, NOTIFY_ERROR, rp.Term("EmoteActions.CannotDo") );
			return false
		end
	end

	if ply:InVehicle() then
		rp.Notify( ply, NOTIFY_ERROR, rp.Term("EmoteActions.CannotVehicle") );
		return false
	elseif ply:WaterLevel() > 1 then
		rp.Notify( ply, NOTIFY_ERROR, rp.Term("EmoteActions.CannotUnderwater") );
		return false
	elseif ply:GetMoveType() == MOVETYPE_NOCLIP then
		rp.Notify( ply, NOTIFY_ERROR, rp.Term("EmoteActions.CannotNoclip") );
		return false
	elseif ply:GetMoveType() == MOVETYPE_LADDER then
		rp.Notify( ply, NOTIFY_ERROR, rp.Term("EmoteActions.CannotLadder") );
		return false
	elseif not ply:IsOnGround() or IsValid(ply:GetGroundEntity()) then
		rp.Notify( ply, NOTIFY_ERROR, rp.Term("EmoteActions.CannotAir") );
		return false
	elseif ply:Crouching() then
		rp.Notify( ply, NOTIFY_ERROR, rp.Term("EmoteActions.CannotCrouch") );
		return false
	elseif ply:GetVelocity():Length() > 4 then
		rp.Notify( ply, NOTIFY_ERROR, rp.Term("EmoteActions.CannotVelocity") );
		return false
	end

	if table.Count(self.WeaponCheck) > 0 then
		local wpnPass = false;
		for _, wpnClass in pairs( self.WeaponCheck ) do
			if ply:GetActiveWeapon():GetClass() == wpnClass then
				wpnPass = true
			end
		end
		if not wpnPass then
			rp.Notify( ply, NOTIFY_ERROR, "EmoteActions.CannotItems", table.concat(self.WeaponCheck, ", ") );
			return false
		end
	end

	return true
end

function ACTION:onStart( ply )
end

function ACTION:onRun( ply )
	if ply:GetVelocity():Length() >= 8 then
		ply:ForceEmoteAction();
	end
end

function ACTION:onEnd( ply )
end

function ACTION:onStartCommand( ply, cmd )
	if CLIENT then
		if cmd:KeyDown(IN_DUCK) and EmoteActions.LocalPlayer.__pCanChange then
			local headbone = LocalPlayer():LookupBone("ValveBiped.Bip01_Head1");
			local neckbone = LocalPlayer():LookupBone("ValveBiped.Bip01_Neck1");

			EmoteActions.LocalPlayer.IsFirstperson = not EmoteActions.LocalPlayer.IsFirstperson;

			if EmoteActions.LocalPlayer.IsFirstperson then
				LocalPlayer():ManipulateBoneScale( headbone, Vector(0,0,0) );
				LocalPlayer():ManipulateBoneScale( neckbone, Vector(0,0,0) );

				EmoteActions.LocalPlayer.ActCameraAngles.yaw = EmoteActions.LocalPlayer.PlayerAngles.yaw;
			else
				LocalPlayer():ManipulateBoneScale( headbone, Vector(1,1,1) );
				LocalPlayer():ManipulateBoneScale( neckbone, Vector(1,1,1) );
			end

			EmoteActions.LocalPlayer.__pCanChange = false;
		else
			if not cmd:KeyDown(IN_DUCK) then EmoteActions.LocalPlayer.__pCanChange = true;	end
		end
	end

	local keys = { IN_JUMP, IN_USE, IN_ATTACK, IN_ATTACK2, IN_RELOAD, IN_DUCK, IN_WALK, IN_SPRINT };

	for _, KEY_BITFLAG in pairs( keys ) do
		cmd:RemoveKey( KEY_BITFLAG );
	end

	if cmd:GetButtons() ~= 0 and ply:GetEmoteActionState() == ACTION_STATE_RUNNING then
		self:onEnd( ply );

		local headbone = ply:LookupBone("ValveBiped.Bip01_Head1");
		local neckbone = ply:LookupBone("ValveBiped.Bip01_Neck1");

		if headbone then
			ply:ManipulateBoneScale( headbone, Vector(1,1,1) );
		end
		
		if neckbone then
			ply:ManipulateBoneScale( neckbone, Vector(1,1,1) );
		end
	end

	cmd:ClearMovement();
end


if CLIENT then
	function ACTION:onCalcViewFirstperson( ply, origin, angles, FOV )
		local camView = {};

		local headbone = ply:LookupBone("ValveBiped.Bip01_Head1");
		origin = headbone and ply:GetBonePosition( headbone ) or origin;

		local tr = util.TraceHull( {
			start  = origin,
			endpos = origin,
			mask   = MASK_SHOT,
			filter = player.GetAll(),
			mins   = Vector( -8, -8, -8 ),
			maxs   = Vector( 8, 8, 8 ),
		} );

		camView.angles     = EmoteActions.LocalPlayer.ActCameraAngles * 1;
		camView.origin     = origin + Angle( 0, ply:GetAngles().y, 0 ):Forward()*4;
		camView.fov        = FOV;
		camView.drawviewer = true;
		camView.znear 	   = 1;

		return camView;
	end

	function ACTION:onCalcViewThirdperson( ply, origin, angles, FOV )
		local camView = {};

		origin = ply:GetPos();

		local pelvisbone = ply:LookupBone( "ValveBiped.Bip01_Spine2" );

		origin = ( (pelvisbone and ply:GetBonePosition( pelvisbone ) or (ply:GetPos() + Vector(0, 0, 20))) + Angle(0,ply:EyeAngles().y,0):Forward()*8 ) or origin;
		local tgOrigin = origin - EmoteActions.LocalPlayer.ActCameraAngles:Forward() * 100

		local tr = util.TraceHull( {
			start  = origin,
			endpos = tgOrigin,
			mask   = MASK_SHOT,
			filter = player.GetAll(),
			mins   = Vector( -8, -8, -8 ),
			maxs   = Vector( 8, 8, 8 )
		} );

		if tr.FractionLeftSolid >= 0.1 then
			origin = ( (pelvisbone and ply:GetBonePosition( pelvisbone ) or (ply:GetPos() + Vector(0, 0, 20))) - Angle(0,ply:EyeAngles().y,0):Forward()*8 ) or origin;
		    tgOrigin = origin - EmoteActions.LocalPlayer.ActCameraAngles:Forward() * 100

		    tr = util.TraceHull( {
				start  = origin,
				endpos = tgOrigin,
				mask   = MASK_SHOT,
				filter = player.GetAll(),
				mins   = Vector( -8, -8, -8 ),
				maxs   = Vector( 8, 8, 8 )
			} );
		end 

		tgOrigin = tr.HitPos + tr.HitNormal*4;

		camView.angles     = EmoteActions.LocalPlayer.ActCameraAngles * 1;
		camView.origin     = tgOrigin;
		camView.fov        = FOV;
		camView.drawviewer = true;

		return camView;
	end

	function ACTION:onCalcView( ply, origin, angles, FOV )
		if EmoteActions.LocalPlayer.IsFirstperson then
			return self:onCalcViewFirstperson( ply, origin, angles, FOV );
		else
			return self:onCalcViewThirdperson( ply, origin, angles, FOV );
		end
	end

	function ACTION:onCreateMove( CUserCmd )
		if EmoteActions.LocalPlayer.IsFirstperson then
			local lc = EmoteActions.LocalPlayer.PlayerAngles.yaw - 65;
			local rc = EmoteActions.LocalPlayer.PlayerAngles.yaw + 65;

			EmoteActions.LocalPlayer.ActCameraAngles.pitch = math.Clamp( EmoteActions.LocalPlayer.ActCameraAngles.pitch + CUserCmd:GetMouseY() * 0.025, -89, 50 );
			EmoteActions.LocalPlayer.ActCameraAngles.yaw   = math.Clamp( EmoteActions.LocalPlayer.ActCameraAngles.yaw   - CUserCmd:GetMouseX() * 0.025, math.min(lc,rc), math.max(lc,rc) );
		else
			EmoteActions.LocalPlayer.ActCameraAngles.pitch = math.Clamp( EmoteActions.LocalPlayer.ActCameraAngles.pitch + CUserCmd:GetMouseY() * 0.025, -89, 89 );
			EmoteActions.LocalPlayer.ActCameraAngles.yaw   = EmoteActions.LocalPlayer.ActCameraAngles.yaw - CUserCmd:GetMouseX() * 0.025;
		end

		CUserCmd:SetViewAngles( EmoteActions.LocalPlayer.PlayerAngles );

		return true -- shitty fix
	end
end


EmoteActions:RegisterAction( "__base", ACTION );