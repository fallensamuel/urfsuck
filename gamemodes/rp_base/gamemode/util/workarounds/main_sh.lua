function GetPly(num)
	return player.GetAll()[num]
end

/*---------------------------------------------------------------------------
Unused hooks
---------------------------------------------------------------------------*/
local badhooks = {
	RenderScreenspaceEffects = {
		'RenderBloom',
		'RenderBokeh',
		--'RenderColorModify',
		--'RenderMotionBlur',
		'RenderMaterialOverlay',
		'RenderSharpen',
		'RenderSobel',
		'RenderStereoscopy',
		'RenderSunbeams',
		'RenderTexturize',
		'RenderToyTown',
	},
	PreDrawHalos = {
		'PropertiesHover'
	},
	RenderScene = {
		'RenderSuperDoF',
		'RenderStereoscopy',
	},
	PreRender = {
		'PreRenderFlameBlend',
	},
	PostRender = {
		'RenderFrameBlend',
		'PreRenderFrameBlend',
	},
	PostDrawEffects = {
		'RenderWidgets',
		--'RenderHalos',
	},
	GUIMousePressed = {
		'SuperDOFMouseDown',
		'SuperDOFMouseUp'
	},
	Think = {
		'DOFThink',
	},
	PlayerTick = {
		'TickWidgets',
	},
	PlayerBindPress = {
		'PlayerOptionInput'
	},
	NeedsDepthPass = {
		'NeedsDepthPass_Bokeh',
	},
	OnGamemodeLoaded = {
		'CreateMenuBar',
	}
}

local function RemoveHooks()
	for k, v in pairs(badhooks) do
		for _, h in ipairs(v) do
			hook.Remove(k, h)
		end
	end
end

hook('InitPostEntity', 'RemoveHooks', RemoveHooks)
RemoveHooks()

/*---------------------------------------------------------------------------
Sound crash glitch
---------------------------------------------------------------------------*/
local EmitSound = ENTITY.EmitSound
function ENTITY:EmitSound(sound, ...)
	if string.find(sound, '??', 0, true) then return end
	return EmitSound(self, sound, ...)
end

/*---------------------------------------------------------------------------
Anti crash exploit
---------------------------------------------------------------------------*/
if constraint.RemoveAll then
	hook('PropBreak', 'drp_fix', function(attacker, ent)
		if IsValid(ent) and IsValid(ent:GetPhysicsObject()) then
			constraint.RemoveAll(ent)
		end
	end)
end

local allowedDoors = {
	['prop_dynamic'] = true,
	['prop_door_rotating'] = true,
	[''] = true
}

hook('CanTool', 'Doorfix', function(ply, trace, tool)
	if not IsValid(ply:GetActiveWeapon()) or not ply:GetActiveWeapon().GetToolObject or not ply:GetActiveWeapon():GetToolObject() then return end

	local tool = ply:GetActiveWeapon():GetToolObject()
	if not allowedDoors[string.lower(tool:GetClientInfo('door_class') or '')] then
		return false
	end
end)


local function noop(...) /*print(...) debug.Trace()*/ end
/*
_R.Entity.SetNWAngle 	= noop
_R.Entity.SetNWBool 	= noop
_R.Entity.SetNWEntity 	= noop
_R.Entity.SetNWFloat 	= noop
_R.Entity.SetNWInt 		= noop
_R.Entity.SetNWString 	= noop
_R.Entity.SetNWVarProxy = noop
_R.Entity.SetNWVector 	= noop
local ent = Entity(1)
for i = 1, 100 do
	ent:SetNWAngle('test'..i, Angle())
	ent:SetNWBool('test'..i, false)
	ent:SetNWEntity('test'..i, ent)
	ent:SetNWFloat('test'..i, 1000000000)
	ent:SetNWInt('test'..i, 1000)
	ent:SetNWString('test'..i, 'Hello')
	ent:SetNWVector('test'..i, Vector())
end
*/

SetGlobalVector = noop
SetGlobalBool 	= noop
SetGlobalEntity = noop
SetGlobalFloat 	= noop
SetGlobalInt 	= noop
SetGlobalString = noop
SetGlobalVector = noop

if CLIENT then
	local mVec 					   			   = FindMetaTable( "Vector" );
	local GetNormalized, DistToSqr, Dot		   = mVec.GetNormalized, mVec.DistToSqr, mVec.Dot;

	local eyepos, eyeangles, eyefov, eyevector = Vector(), Angle(), 90, Vector();
	local vec_pl_offset 					   = Vector(0,0,32);

	function EyePos()    return eyepos    end
	function EyeAngles() return eyeangles end
	function EyeFov()    return eyefov    end
	function EyeVector() return eyevector end
	
	hook.Add( "RenderScene", "", function( origin, angles, fov )
		eyepos = origin; eyeangles = angles; eyefov = fov; eyevector = angles:Forward();
	end );

	hook.Add( "PostGamemodeLoaded", "", function()
		local _GM = GAMEMODE;

		local PrePlayerDraw     = _GM.PrePlayerDraw;
		local TranslateActivity = _GM.TranslateActivity;
		local CalcMainActivity  = _GM.CalcMainActivity;
		local UpdateAnimation   = _GM.UpdateAnimation;
		local DoAnimationEvent  = _GM.DoAnimationEvent;

		function _GM:PrePlayerDraw( pl, ... )
			if pl ~= LocalPlayer() then
				local pos     = pl:GetPos();
				local sqrdist = DistToSqr( pos, eyepos );

				if sqrdist < 62500 then
					pl.ShouldNoDraw = false;
				else
					pl.ShouldNoDraw = (sqrdist > GetRenderDistance()) or (Dot( eyevector, GetNormalized(pos - eyepos) ) < 0.45);
				end
			end

			if pl.ShouldNoDraw then return true end
			return PrePlayerDraw( self, pl, ... )
		end

		function _GM:TranslateActivity( pl, ... )
			if pl.ShouldNoDraw then return end
			return TranslateActivity( self, pl, ... );
		end

		function _GM:CalcMainActivity( pl, ... )
			if pl.ShouldNoDraw then return end
			return CalcMainActivity( self, pl, ... )
		end

		function _GM:UpdateAnimation( pl, ... )
			if pl.ShouldNoDraw then return end
			return UpdateAnimation( self, pl, ... )
		end

		function _GM:DoAnimationEvent( pl, ... )
			if pl.ShouldNoDraw then return -1 end
			return DoAnimationEvent( self, pl, ... )
		end
	end );
end