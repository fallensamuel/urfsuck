-- "gamemodes\\rp_base\\entities\\weapons\\engine_bodylooting\\cl_init.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
include( "shared.lua" );

----------------------------------------------------------------
local NET_FN = {
    [BODYLOOTING_ID_STATE] = function( wep )
        wep:SetState( net.ReadUInt(3) );
    end,

    [BODYLOOTING_ID_TARGET] = function( wep )
        wep:SetTarget( net.ReadEntity() );
    end,

    [BODYLOOTING_ID_INFO] = function( wep )
        wep:SetInformation( net.ReadString() );
    end,

    [BODYLOOTING_ID_ANIM] = function( ply )
        ply:AnimRestartGesture( GESTURE_SLOT_ATTACK_AND_RELOAD, ACT_PICKUP_GROUND, true );
    end,
};

net.Receive( "BodyLooting::Network", function()
    local ent, id = net.ReadEntity(), net.ReadUInt(2);
    if not IsValid( ent ) then return end

    local fn = NET_FN[id];
    if not fn then return end

    fn( ent );
end );

----------------------------------------------------------------
function SWEP:SetState( st )
    local owner = self:GetOwner();
    if not IsValid( owner ) then return end

    if owner:GetActiveWeapon() ~= self then
        timer.Simple( engine.TickInterval(), function()
            if not IsValid( self ) then return end
            self:SetState( st );
        end );

        return
    end

    self.i_State = st;
    self:OnStateChanged( self.i_State );
end

function SWEP:SetTarget( ent )
    self.m_Target = ent;
end

function SWEP:SetInformation( str )
    self.s_Information = str;

    if SERVER then
        self:NetworkToOwner( function()
            net.WriteUInt( BODYLOOTING_ID_INFO, 2 );
            net.WriteString( self.s_Information );
        end );
    end
end

----------------------------------------------------------------
function SWEP:ControlPlayerCamera()
    local owner = self:GetOwner();
    local viewpos = self:LookupPosition();

    local viewang = LerpAngle( RealFrameTime() * 16, owner:GetAimVector():Angle(), (viewpos - owner:EyePos()):Angle() );
    viewang.r = 0;

    return viewang, viewpos;
end

function SWEP:SetupViewmodelLootEntity( model )
    if SERVER then return end

    if self.b_ViewModelInitialized or (self:GetState() ~= BODYLOOTING_STATE_CROUCH) then return end

    local owner = self:GetOwner();
    if not IsValid( owner ) then return end

    local vm = owner:GetViewModel();
    if not IsValid( vm ) then return end

    if not self.m_ViewModelCSEnt then
        vm:SetupBones();

        local r_hand = vm:LookupBone( "ValveBiped.Bip01_R_Hand" );
        if r_hand then
            local data = {
                mdl = model or "models/props_lab/box01a.mdl",
                origin = Vector(0, 0, 0),
                angles = Angle(0, 0, 0),
                scale = 1
            };

            table.Merge( data, hook.Run("BodyLooting::PrepareModel", self:GetInformation(), data.mdl, data.origin, data.angles, data.scale) or {} );

            self.m_ViewModelCSEnt = ClientsideModel( data.mdl, RENDERGROUP_VIEWMODEL_TRANSLUCENT );
            self.m_ViewModelCSEnt:SetNoDraw( true );
            self.m_ViewModelCSEnt:SetModelScale( (2.5 / self.m_ViewModelCSEnt:GetModelRadius()) * data.scale, 0 );
            self.m_ViewModelCSEnt.v_ModOrigin = data.origin;
            self.m_ViewModelCSEnt.v_ModAngles = data.angles;

            self.b_ViewModelInitialized = true;
        end
    end
end

function SWEP:ShouldDrawViewModel()
    return (self:GetState() or 0) >= BODYLOOTING_STATE_CROUCH;
end

function SWEP:ViewModelDrawn()
    local vm = self:GetOwner():GetViewModel();

    if IsValid( self.m_ViewModelCSEnt ) then
        local r_hand = vm:LookupBone( "ValveBiped.Bip01_R_Hand" );

        local bonematrix = vm:GetBoneMatrix( r_hand );

        local mins, maxs = self.m_ViewModelCSEnt:GetModelRenderBounds();
        local bounds = (maxs - mins);

        local center = LerpVector(0.5, mins, maxs) + (vector_up * self.m_ViewModelCSEnt:GetModelRadius() * 0.5)
        center = center * self.m_ViewModelCSEnt:GetModelScale();

        local bone_origin, bone_angles = bonematrix:GetTranslation(), bonematrix:GetAngles();
        bone_angles:RotateAroundAxis( bone_angles:Forward(), 90 );

        local origin, angles = LocalToWorld( center + Vector(4, 0, 1.25) + self.m_ViewModelCSEnt.v_ModOrigin, Angle(-90, 0, 90) + self.m_ViewModelCSEnt.v_ModAngles, bone_origin, bone_angles );

        self.m_ViewModelCSEnt:SetPos( origin );
        self.m_ViewModelCSEnt:SetAngles( angles );

        self.m_ViewModelCSEnt:SetupBones();
        self.m_ViewModelCSEnt:DrawModel();
    end
end

----------------------------------------------------------------
function SWEP:OnRemove()
    local owner = self:GetOwner();

    if owner and owner == LocalPlayer() then
        hook.Run( "PlayerBindPress", LocalPlayer(), "lastinv", true );
        RunConsoleCommand( "lastinv" );
    end
end

function SWEP:OnStateChanged( st )
    hook.Remove( "CreateMove", self );
    hook.Remove( "CalcViewOverride", self );

    if st == BODYLOOTING_STATE_WALKUP then
        hook.Add( "CreateMove", self, function( wep, cmd )
            local target = wep:GetTarget();

            if not IsValid( target ) then
                hook.Remove( "CreateMove", wep );
                return
            end

            local viewang, viewpos = wep:ControlPlayerCamera();
            local dist, reach = (viewpos - LocalPlayer():GetPos()):Length2DSqr(), BODYLOOTING_DIST_REACH_SQR;

            if dist > reach then
                cmd:SetForwardMove( cmd:GetForwardMove() + LocalPlayer():GetWalkSpeed() );
            end

            cmd:SetViewAngles( viewang );
        end );
    end

    if st == BODYLOOTING_STATE_CROUCH then
        local sitting = true;
        local owner = self:GetOwner();
        local vm = owner:GetViewModel();

        if IsValid( vm ) then
            vm:SendViewModelMatchingSequence( 0 );

            timer.Simple( 0, function()
                vm:SendViewModelMatchingSequence( vm:LookupSequence("slowgrabinspect") );

                owner:EmitSound( Sound("ventrische/slowgrab_foley.mp3") );

                timer.Simple( 1, function()
                    if not IsValid( self ) then return end
                    self:SetupViewmodelLootEntity();
                end );

                timer.Simple( vm:SequenceDuration() * 0.8, function()
                    sitting = false;
                end );
            end );
        end

        local m_dt, viewang = Vector(0, 0), Angle(0, 0);

        hook.Add( "CalcViewOverride", self, function( wep, view )
            local ply, origin, angles = LocalPlayer(), view.origin, view.angles;

            if not ply:ShouldDrawLocalPlayer() then
                local vm = owner:GetViewModel();

                if IsValid( vm ) then
                    local att = vm:LookupAttachment( "camera" );

                    if att then
                        local camang = (vm:GetAttachment( att ) or {});
                        camang = camang.Ang;

                        if camang then
                            camang = select( 2, WorldToLocal(vector_origin, camang, vector_origin, vm:GetAngles()) );
                            camang = Angle( camang.p * 2, camang.y - 90, (camang.r - 90) * 0.5 );

                            view.angles = view.angles + camang;
                        end
                    end
                end

                viewang = sitting and Angle(
                    math.Clamp(viewang.p + m_dt.y, -25, 15),
                    math.Clamp(viewang.y + m_dt.x, -35, 35)
                ) or viewang * RealFrameTime();

                m_dt = m_dt * RealFrameTime();

                view.angles = select( 2, LocalToWorld(vector_origin, viewang, vector_origin, view.angles) );
            end
        end );

        hook.Add( "CreateMove", self, function( wep, cmd )
            local target = wep:GetTarget();

            if not IsValid( target ) then
                hook.Remove( "CreateMove", wep );
                return
            end

            m_dt = Vector( m_dt.x - cmd:GetMouseX() * RealFrameTime(), m_dt.y + cmd:GetMouseY() * RealFrameTime() );
            local viewang, viewpos = wep:ControlPlayerCamera();

            cmd:ClearMovement();
            cmd:SetViewAngles( viewang );

            if sitting then
                cmd:SetButtons( IN_DUCK );
            end

            return true
        end );
    end
end