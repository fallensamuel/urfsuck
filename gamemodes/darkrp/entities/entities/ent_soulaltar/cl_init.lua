-- "gamemodes\\darkrp\\entities\\entities\\ent_soulaltar\\cl_init.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
----------------------------------------------------------------
include( "shared.lua" );
include( "cl_menu.lua" );

----------------------------------------------------------------
net.Receive( "SoulAltar", function()
    local e = net.ReadEntity();
    if not IsValid( e ) then return end

    if e.IsSoulAltar then
        e:OpenMenu();
    end
end );

net.Receive( "SoulAltarDeath", function()
    local e = net.ReadEntity();
    if not IsValid( e ) then return end

    if e.IsSoulAltar then
        table.insert( e.BloodTrails, {net.ReadVector(), 0, 0} );
    end
end );

----------------------------------------------------------------
function ENT:OpenMenu()
    if IsValid( g_SoulAltarMenu ) then
        g_SoulAltarMenu:Remove();
    end

    g_SoulAltarMenu = vgui.Create( "SoulAltarMenu" );
    g_SoulAltarMenu:SetSize( ScrH() * 0.6, ScrH() * 0.75 );
    g_SoulAltarMenu:Center();
    g_SoulAltarMenu:MakePopup();
    g_SoulAltarMenu:SetControllerEntity( self );
end

function ENT:Initialize()
    self.BloodTrails = {};
    ParticleEffectAttach( "fire_small_02", PATTACH_ABSORIGIN_FOLLOW, self, 0 );
end

function ENT:Draw( flags )
    local timestamp = SysTime();
    
    local rate = 0.5;
    local time = timestamp * rate;

    if not self.m_Emitter then
        self.m_Emitter = ParticleEmitter( self:GetPos() );
    end

    if self.m_Emitter then
        if (self.fl_NextFlare or 0) < timestamp then
            self.fl_NextFlare = timestamp + math.random(0.25, 1);
            local flare = self.m_Emitter:Add( "effects/yellowflare", self:GetPos() );
            if flare then
                flare:SetDieTime( 1 );
                flare:SetStartSize( 32 );
                flare:SetEndSize( 0 );
                flare:SetStartAlpha( 0 );
                flare:SetEndAlpha( 255 );
                flare:SetGravity( VectorRand() * self:GetModelRadius() * 2 );
            end
        end
    end

    self.m_eLight = DynamicLight( self:EntIndex() );
    if self.m_eLight then
        self.m_eLight.pos = self:GetPos();
		self.m_eLight.r = 255;
		self.m_eLight.g = 150;
		self.m_eLight.b = 25;
		self.m_eLight.brightness = 1;
		self.m_eLight.Size = 128;
		self.m_eLight.Decay = 1000;
		self.m_eLight.DieTime = timestamp + 1;
    end

    local ef = EffectData();
    for k, data in ipairs( self.BloodTrails ) do
        -- data[1] - origin
        -- data[2] - last
        -- data[3] - step

        if data[2] > timestamp then continue end
        data[2] = timestamp + 0.075;

        data[3] = data[3] + 0.05;
        if data[3] >= 1 then
            self:EmitSound( Sound("physics/flesh/flesh_squishy_impact_hard3.wav") );
            table.remove( self.BloodTrails, k );
        end

        ef:SetOrigin( LerpVector(data[3], data[1], self:GetPos()) );
        util.Effect( "BloodImpact", ef );
    end

    self:SetRenderAngles( Angle(math.sin(time * 1.25) * 180, math.sin(time) * 360, math.cos(time) * 90) );
    self:DrawModel( flags );
end