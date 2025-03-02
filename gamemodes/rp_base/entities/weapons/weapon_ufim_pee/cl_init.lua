-- "gamemodes\\rp_base\\entities\\weapons\\weapon_ufim_pee\\cl_init.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
----------------------------------------------------------------
include( "shared.lua" );
----------------------------------------------------------------


----------------------------------------------------------------
language.Add( "pee_ammo", translates.Get("Моча") );
language.Add( "poo_ammo", translates.Get("Говно") );


----------------------------------------------------------------
net.Receive( "weapon_urfim_pee", function()
    local self = net.ReadEntity();
    if not IsValid( self ) then return end

    if not self.Pee then return end

    local TimerID = self.TimerIDPrimary;
    if not TimerID then return end
    
    self.b_IsPeeing = net.ReadBool();
    
    if self.b_IsPeeing then
        timer.Create( TimerID, self.Pee.Delay or self.Primary.Delay, 0, function()
            if (not IsValid( self )) or (not self:GetIsPeeing()) then
                timer.Remove( TimerID );
                return
            end

            self:RenderPee();
        end );
    else
        timer.Remove( TimerID );
    end
end );


----------------------------------------------------------------
function SWEP:RenderPee()
    local CT = CurTime();

    if not IsValid( self.Owner ) then
        return
    end

    local render_origin;
    local isThirdperson = (self.Owner == LocalPlayer()) and (not LocalPlayer():ShouldDrawLocalPlayer());

    if isThirdperson then
        render_origin = self.Owner:EyePos() - self.Owner:EyeAngles():Up() * 15;
    else
        local id = self.Owner:LookupBone( "ValveBiped.Bip01_Pelvis" );
        if not id then return end

        local matrix = self.Owner:GetBoneMatrix( id );
        if not matrix then return end

        local bone_origin, bone_angles = matrix:GetTranslation(), matrix:GetAngles();
        render_origin = bone_origin + self.Owner:EyeAngles():Forward() * 10;
    end

    if not IsValid( self.PeeEmitter ) then
        self.PeeEmitter = ParticleEmitter( vector_origin, false );
    end
    
    self.PeeEmitter:SetPos( render_origin );

    local dir = self.Owner:EyeAngles();
    dir.Pitch = isThirdperson and (dir.Pitch - 15) or math.max( -89, dir.Pitch - 15 );

    local particle = self.PeeEmitter:Add( self.Pee.Particle, render_origin );
    particle:SetCollide( true );

    particle:SetGravity( self.Pee.Gravity );
    particle:SetVelocity( self.Owner:GetVelocity() + dir:Forward() * 380 );
    particle:SetAirResistance( 400 );

    particle:SetDieTime( 0.5 );
    particle:SetStartSize( 1 );
    particle:SetEndSize( 2 );
    particle:SetStartAlpha( 100 );
    particle:SetColor( 240, 200, 0, 255 );

    if (self.NextSplash or 0) < CT then
        self.NextSplash = CT + math.Rand( 0.05, 0.2 );

        local particleid = "piss" .. SysTime();

        particle:SetNextThink( CurTime() );
        particle:SetThinkFunction( function( me )
            local vel = me:GetVelocity();

            if vel ~= vector_origin then
                me.v_LastVelocity = vel;
            else
                me:SetDieTime( 0 );
                if timer.Exists( particleid ) then
                    timer.Adjust( particleid, 0, nil );
                end
            end

            me:SetNextThink( CurTime() );
        end );

        timer.Create( particleid, particle:GetDieTime(), 1, function()
            local tr = util.QuickTrace( particle:GetPos(), (particle.v_LastVelocity or vector_origin) * 1024 );

            for i = 0, 4 do
                local effectdata, sc = EffectData(), math.Rand( 0.07, 0.24 );

                effectdata:SetOrigin( tr.HitPos );
                effectdata:SetNormal( tr.HitNormal );

                effectdata:SetMagnitude( sc );
                effectdata:SetScale( sc );
                effectdata:SetRadius( sc );

                util.Effect( "StriderBlood", effectdata );
            end

            sound.Play( "ambient/water/water_spray" .. math.random(1, 3) .. ".wav", tr.HitPos, 55 );
        end );
    end

    self.PeeEmitter:Finish();
end


----------------------------------------------------------------
function SWEP:PrimaryAttack()
    return
end

function SWEP:SecondaryAttack()
    return
end