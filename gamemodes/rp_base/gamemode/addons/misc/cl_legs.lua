local _R = debug.getregistry();

--[[ Console Variables: ]]--
--local cvar_legs = CreateConVar( "cl_legs", "0", {FCVAR_ARCHIVE}, "" );
cvar.Register'fp_legs':SetDefault(false):AddMetadata('State', 'RPMenu'):AddMetadata('Menu', 'Включить отображение ног от первого лица')

Legs = {
    BreathScale = 0.25,

    Settings = {
        ["default"] = {
            ForwardOffset = -22,
            Bones = {
                "ValveBiped.Bip01_Head1",
                "ValveBiped.Bip01_Neck1",
                "ValveBiped.Bip01_Spine2",
                "ValveBiped.Bip01_Spine4",
                "ValveBiped.Bip01_L_Hand",
                "ValveBiped.Bip01_L_Forearm",
                "ValveBiped.Bip01_L_Upperarm",
                "ValveBiped.Bip01_L_Clavicle",
                "ValveBiped.Bip01_R_Hand",
                "ValveBiped.Bip01_R_Forearm",
                "ValveBiped.Bip01_R_Upperarm",
                "ValveBiped.Bip01_R_Clavicle",
                "ValveBiped.Bip01_L_Finger4",
                "ValveBiped.Bip01_L_Finger41",
                "ValveBiped.Bip01_L_Finger42",
                "ValveBiped.Bip01_L_Finger3",
                "ValveBiped.Bip01_L_Finger31",
                "ValveBiped.Bip01_L_Finger32",
                "ValveBiped.Bip01_L_Finger2",
                "ValveBiped.Bip01_L_Finger21",
                "ValveBiped.Bip01_L_Finger22",
                "ValveBiped.Bip01_L_Finger1",
                "ValveBiped.Bip01_L_Finger11",
                "ValveBiped.Bip01_L_Finger12",
                "ValveBiped.Bip01_L_Finger0",
                "ValveBiped.Bip01_L_Finger01",
                "ValveBiped.Bip01_L_Finger02",
                "ValveBiped.Bip01_R_Finger4",
                "ValveBiped.Bip01_R_Finger41",
                "ValveBiped.Bip01_R_Finger42",
                "ValveBiped.Bip01_R_Finger3",
                "ValveBiped.Bip01_R_Finger31",
                "ValveBiped.Bip01_R_Finger32",
                "ValveBiped.Bip01_R_Finger2",
                "ValveBiped.Bip01_R_Finger21",
                "ValveBiped.Bip01_R_Finger22",
                "ValveBiped.Bip01_R_Finger1",
                "ValveBiped.Bip01_R_Finger11",
                "ValveBiped.Bip01_R_Finger12",
                "ValveBiped.Bip01_R_Finger0",
                "ValveBiped.Bip01_R_Finger01",
                "ValveBiped.Bip01_R_Finger02",
            }
        },

        ["mood-normal"] = {
            ForwardOffset = -12,
            Bones = {
                "ValveBiped.Bip01_Head1",
                "ValveBiped.Bip01_Neck1",
            }
        },

        ["mood-gopnik"] = {
            ForwardOffset = -12,
            Bones = {
                "ValveBiped.Bip01_Head1",
                "ValveBiped.Bip01_Neck1",
            }
        },

        ["mood-serious"] = {
            ForwardOffset = -12,
            Bones = {
                "ValveBiped.Bip01_Head1",
                "ValveBiped.Bip01_Neck1",
            }
        },

        ["mood-gloomy"] = {
            ForwardOffset = -12,
            Bones = {
                "ValveBiped.Bip01_Head1",
                "ValveBiped.Bip01_Neck1",
            }
        },

        ["mood-pace"] = {
            ForwardOffset = -20,
            Bones = {
                "ValveBiped.Bip01_Head1",
                "ValveBiped.Bip01_Neck1",
            }
        }
    }
}

--[[ <metatable> Legs: ]]--
_R.Legs         = {};
_R.Legs.__index = _R.Legs;


_R.Legs.ClipVector = vector_up * -1;


local function CreateLegs()
    local CSLegsEntity = ClientsideModel( LocalPlayer():GetModel(), RENDERGROUP_OPAQUE );
    CSLegsEntity:SetNoDraw( true );
    CSLegsEntity:SetIK( false );

    return setmetatable( {
        Entity        = CSLegsEntity,
        LastTick      = CurTime(),
        LastSeq       = nil,
        LastWeapon    = nil,
        LastHoldType  = "default",
        NextBreath    = CurTime(),
        RequestUpdate = true,
        SettingData   = Legs.Settings["default"],
        IsCrouching   = false,
        ForwardOffset = 0
    }, _R.Legs );
end

function _R.Legs:UpdateBones()
    if IsValid( self.Entity ) then
        local bonesToUpdate = {};

        for k, v in pairs( self.SettingData.Bones ) do
            local bone = self.Entity:LookupBone( v );

            if bone then
                bonesToUpdate[bone] = true;
            end
        end

        for i = 0, self.Entity:GetBoneCount() do
            self.Entity:ManipulateBoneScale( i, bonesToUpdate[i] and vector_origin or Vector(1,1,1) );
            self.Entity:ManipulateBonePosition( i, bonesToUpdate[i] and Vector(0,-100,0) or vector_origin );
            self.Entity:ManipulateBoneAngles( i, angle_zero );
        end
    end
end

function _R.Legs:UpdateVisual()
    if IsValid( self.Entity ) then
        self.Entity:SetModelScale( LocalPlayer():GetModelScale() );

        self.Entity:SetModel( LocalPlayer():GetModel() );
        self.Entity:SetSkin( LocalPlayer():GetSkin() );
        self.Entity:SetColor( LocalPlayer():GetColor() );

        self.Entity:SetMaterial( LocalPlayer():GetMaterial() );
        for k, v in pairs( LocalPlayer():GetMaterials() ) do
            self.Entity:SetSubMaterial( k-1, LocalPlayer():GetSubMaterial(k-1) );
        end

        for k, v in pairs( LocalPlayer():GetBodyGroups() ) do
            local bodygroup = LocalPlayer():GetBodygroup( v.id );
            self.Entity:SetBodygroup( v.id, bodygroup );
        end
    end
end

function _R.Legs:UpdateLegs()
    self:UpdateVisual();
    self:UpdateBones();
end


function _R.Legs:IsValid()
    return self.Entity and true or false;
end


function _R.Legs:ShouldRender()
    return self:IsValid()                                       and
		   not rp.cfg.DisableLegsForAll							and
           LocalPlayer():Alive()                                and
           GetViewEntity() == LocalPlayer()                     and
           not LocalPlayer():InVehicle()                        and
           not LocalPlayer():ShouldDrawLocalPlayer()            and
           not IsValid( LocalPlayer():GetObserverTarget() )     and
           LocalPlayer():WaterLevel() == 0                      and
           not LocalPlayer():GetNoDraw()
end


function _R.Legs:OnWeaponChanged( wep )
    if IsValid(self.Entity) and IsValid(wep) then
        self.SettingData   = Legs.Settings[string.lower(wep:GetHoldType())] or Legs.Settings["default"];
        self.RequestUpdate = true;
    end
end


function _R.Legs:Think( maxSeqGroundSpeed )
	if not cvar.GetValue('fp_legs') then return end
	
    if IsValid( self.Entity ) then
        if (not self.RequestUpdate) and (not LocalPlayer():Alive()) then
            self.RequestUpdate = true;
        end

        if self.RequestUpdate and LocalPlayer():Alive() then
            self:UpdateLegs();
            self.RequestUpdate = false;
        end

        if self.LastWeapon ~= LocalPlayer():GetActiveWeapon() then
            if not LocalPlayer():Crouching() then
                self:OnWeaponChanged( LocalPlayer():GetActiveWeapon() );
            else
                self.LastHoldType = string.lower(LocalPlayer():GetActiveWeapon() and LocalPlayer():GetActiveWeapon().GetHoldType and LocalPlayer():GetActiveWeapon():GetHoldType() or '');
            end
            self.LastWeapon = LocalPlayer():GetActiveWeapon();
        end

        if LocalPlayer():Crouching() and !self.IsCrouching then
        	local wep = LocalPlayer():GetActiveWeapon()
            self.LastHoldType = string.lower(wep and wep.GetHoldType and wep:GetHoldType() or '');
            self.SettingData  = Legs.Settings["default"];
            self:UpdateBones();
            self.IsCrouching = true;
        end

        if !LocalPlayer():Crouching() and self.IsCrouching then
            self.SettingData = Legs.Settings[self.LastHoldType] or Legs.Settings["default"];
            --self.SettingData = Legs.Settings[string.lower(self.LastWeapon:GetHoldType())] or Legs.Settings["default"];
            self:UpdateBones();
            self.IsCrouching = false;
        end

        self.Velocity     = LocalPlayer():GetVelocity():Length2D();
        self.PlaybackRate = 1;

        if self.Velocity > 0.5 then
            if maxSeqGroundSpeed < 0.001 then
                self.PlaybackRate = 0.01;
            else
                self.PlaybackRate = self.Velocity / maxSeqGroundSpeed;
                self.PlaybackRate = math.Clamp( self.PlaybackRate, 0.01, 10 );
            end
        end

        self.Entity:SetPlaybackRate( self.PlaybackRate );

        self.Sequence = LocalPlayer():GetSequence();
        if self.LastSeq ~= self.Sequence then
            self.Entity:ResetSequence( self.Sequence );
            self.LastSeq = self.Sequence;
        end

        self.Entity:FrameAdvance( CurTime() - self.LastTick );
        self.LastTick = CurTime();

        if self.NextBreath <= CurTime() then
            self.NextBreath = CurTime() + 1.95 / Legs.BreathScale;
            self.Entity:SetPoseParameter( "breathing", Legs.BreathScale );
        end

        self.Entity:SetPoseParameter( "move_x",    (LocalPlayer():GetPoseParameter("move_x")    * 2)   - 1 );
        self.Entity:SetPoseParameter( "move_y",    (LocalPlayer():GetPoseParameter("move_y")    * 2)   - 1 );
        self.Entity:SetPoseParameter( "move_yaw",  (LocalPlayer():GetPoseParameter("move_yaw")  * 360) - 180 );
        self.Entity:SetPoseParameter( "body_yaw",  (LocalPlayer():GetPoseParameter("body_yaw")  * 180) - 90 );
        self.Entity:SetPoseParameter( "spine_yaw", (LocalPlayer():GetPoseParameter("spine_yaw") * 180) - 90 );
    end
end


function _R.Legs:Render()
	if not cvar.GetValue('fp_legs') then return end
	
    cam.Start3D( EyePos(), EyeAngles() );
        self.RenderOrigin   = EyePos() - LocalPlayer():GetCurrentViewOffset() + Vector(0,0,5);
        self.BiaisAngles    = LocalPlayer():EyeAngles();
        self.RenderAngle    = Angle( 0, self.BiaisAngles.y, 0 );
        self.RadAngle       = math.rad( self.BiaisAngles.y );
        self.ForwardOffset  = Lerp( 0.05, self.ForwardOffset, self.SettingData.ForwardOffset * LocalPlayer():GetModelScale() );
        self.RenderOrigin.x = self.RenderOrigin.x + math.cos( self.RadAngle ) * self.ForwardOffset;
        self.RenderOrigin.y = self.RenderOrigin.y + math.sin( self.RadAngle ) * self.ForwardOffset;
        self.RenderColor    = LocalPlayer():GetColor();

        local render_clipping = render.EnableClipping( true );
            render.PushCustomClipPlane( self.ClipVector, self.ClipVector:Dot(EyePos()+Vector(0,0,16)) );
                render.SetColorModulation( self.RenderColor.r/255, self.RenderColor.g/255, self.RenderColor.b/255 );
                    render.SetBlend( self.RenderColor.a/255 );
                        self.Entity:SetRenderOrigin( self.RenderOrigin );
                        self.Entity:SetRenderAngles( self.RenderAngle );
                        self.Entity:SetupBones();
                            render.CullMode( MATERIAL_CULLMODE_CW);
                            self.Entity:DrawModel();
                            render.CullMode( MATERIAL_CULLMODE_CCW );
                            self.Entity:DrawModel();
                        self.Entity:SetRenderOrigin();
                        self.Entity:SetRenderAngles();
                    render.SetBlend( 1 );
                render.SetColorModulation( 1, 1, 1 );
            render.PopCustomClipPlane();
        render.EnableClipping( render_clipping );
    cam.End3D();
end


hook( "PostDrawTranslucentRenderables", "hook.PlayerLegs:PostDrawTranslucentRenderables", function()
    if not LocalPlayer().Legs then return end

    if LocalPlayer().Legs:ShouldRender() then
        LocalPlayer().Legs:Render();
    end
end );


hook( "UpdateAnimation", "hook.PlayerLegs:UpdateAnimation", function( ply, vel, maxSeqGroundSpeed )
    if ply ~= LocalPlayer()   then return end
    if not LocalPlayer().Legs then return end

    if LocalPlayer().Legs:IsValid() then
        LocalPlayer().Legs:Think( maxSeqGroundSpeed );
    end
end );


hook( "OnAppearanceUpdated", "hook.PlayerLegs:OnAppearanceUpdated", function( ply )
    if ply ~= LocalPlayer()   then return end
    if not LocalPlayer().Legs then return end

    if LocalPlayer().Legs:IsValid() then
        LocalPlayer().Legs.RequestUpdate = true;
    end
end );

--[[
hook( "PlayerBindPress", "hook.PlayerLegs:CreateLegs", function( ply )
    print( "PlayerBindPress, ", ply:GetName() );
    if ply == LocalPlayer() then
        LocalPlayer().Legs = CreateLegs();
        LocalPlayer().Legs:UpdateLegs();
        --hook.Remove( "PlayerBindPress", "hook.PlayerLegs:CreateLegs" );
    end
end );
]]--

hook( "InitPostEntity", "hook.PlayerLegs:CreateLegs", function()
	if not rp.cfg.DisableLegsForAll then 
		LocalPlayer().Legs = CreateLegs();
		LocalPlayer().Legs:UpdateLegs();
	end
end );
