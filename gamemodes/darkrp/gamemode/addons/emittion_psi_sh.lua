-- "gamemodes\\darkrp\\gamemode\\addons\\emittion_psi_sh.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
PsiEmittion = {};

PsiEmittion.Enums = {
    STATUS_COOLDOWN = 0,
    STATUS_ACTIVE = 1,
};

PsiEmittion.Sounds = {
    [1] = "blowout/psi_begin.wav",
    [2] = "blowout/psi_end.wav",
    [3] = "blowout/blowout_flare_01.wav",
    [4] = "blowout/blowout_flare_02.wav",
    [5] = "blowout/blowout_flare_03.wav",
    [6] = "blowout/blowout_flare_04.wav",
};

PsiEmittion.ExternalConfig = rp.cfg.PsiEmittion or {};
PsiEmittion.Config = {};

-- Настройки: --------------------------------------------------
    -- Урон/сек. от Пси-Излучения
    PsiEmittion.Config.Damage = 5;

    -- Через сколько запускается Пси-Излучение: (сек.)
    PsiEmittion.Config.Delay = 30;

    -- Длительность Пси-Излучения: (сек.)
    PsiEmittion.Config.Length = 60;

    -- Фразы для чата: (рандомная)
    PsiEmittion.Config.Phrases = {
        -- Начало Пси-Излучения: (оставить пустым если не нужно)
        OnStart = {
            -- {"Какой-то микропенис", "Начинается Пси-излучение."},
        },
        
        -- Конец Пси-Излучения: (оставить пустым если не нужно)
        OnEnd = {
            -- {"Какой-то микропенис", "Пси-излучение заканчивается."},
        }
    };

    -- Фильтр по игроку Пси-Излучения:
    PsiEmittion.Config.Filter = function( ply )
        return true
    end

    -- Условие для заражения игрока от Пси-Излучения:
    PsiEmittion.Config.Trigger = function( self, ply )
        return ((ply:Health() - self.Damage) / ply:GetMaxHealth()) <= 0.05;
    end

    -- Функция заражения:
    PsiEmittion.Config.OnPlayerInfected = function( ply )

    end

    table.Merge( PsiEmittion.Config, PsiEmittion.ExternalConfig );
----------------------------------------------------------------

-- Настройки оверлеев: -----------------------------------------
if CLIENT then
    rp.overlays.OverlayLayer( "PsiEmittion-Pee.MainLayer" )
        :SetMotionBlur( 0.03, 0.25, 0 )
        :SetColorModify( 0.80, 0.66, 0, -0.5, 1.05, 0.225, 0, 0, 0 )

    local ov = rp.overlays.Overlay( "PsiEmittion-Pee" )
        :AddLayer( "PsiEmittion-Pee.MainLayer" )
        :SetFadeIn( 2 )
        :SetFadeOut( 2 )

    net.Receive( "PsiEmittion.Overlay", function()
        ov:Enable();

        timer.Create( "PsiEmittion.OverlayDisable", 2, 1, function()
            ov:Disable();
        end );
    end );
end
----------------------------------------------------------------


if CLIENT then
    net.Receive( "PsiEmittion.Sound", function()
        local snd = PsiEmittion.Sounds[net.ReadUInt(3)];

        if snd then
            surface.PlaySound( snd );
        end
    end );

    return
end

util.AddNetworkString( "PsiEmittion.Sound" );

local function PlaySound( id )
    net.Start( "PsiEmittion.Sound" );
        net.WriteUInt( id, 3 );
    net.Broadcast();
end

util.AddNetworkString( "PsiEmittion.Overlay" );

PsiEmittion.ApplyDamage = function( self, ply )
    -- local dmg = DamageInfo();
    -- local worldspawn = game.GetWorld();

    -- dmg:SetAttacker( worldspawn );
    -- dmg:SetInflictor( worldspawn );
    -- dmg:SetDamage( self.Config.Damage );
    -- dmg:SetDamageType( DMG_DIRECT );
    -- dmg:SetDamagePosition( ply:GetPos() );
    -- dmg:SetDamageForce( vector_up );

    -- ply:TakeDamageInfo( dmg );

    local CT = CurTime();

    if (ply.PsiEmittion_LastViewPunch or 0) <= CT then
        ply.PsiEmittion_LastViewPunch = CT + 2;
        
        ply:ViewPunch(
            Angle( math.Rand(-1,1), math.Rand(-1,1), 0 ) * 5 
        );
    end

    ply:SetHealth( math.max(ply:Health() - self.Config.Damage, 1) );

    net.Start( "PsiEmittion.Overlay" ); net.Send( ply );
end

PsiEmittion.ApplyInfection = function( self, ply )
    ply:InfectHuman();
    ply.b_PsiEmittion_Locked = true;
    self.Config.OnPlayerInfected( ply );
end

PsiEmittion.Start = function( self )
    self.Status = self.Enums.STATUS_ACTIVE;

    PlaySound( 1 );
    util.ScreenShake( vector_origin, 2, 5000, 5, 32768 );

    if self.Config.Phrases and self.Config.Phrases.OnStart then
        local phrase = self.Config.Phrases.OnStart[math.random(1,#self.Config.Phrases.OnStart)];
        if phrase and #phrase == 2 then
            rp.GlobalChat( CHAT_NONE,
                Color(227, 132, 36), "[Общий PDA] ",
                Color(218, 165, 32), phrase[1],
                Color(255, 255, 255), ': ' .. phrase[2]
            );
        end
    end

    timer.Create( "PsiEmittion.Handlers::Status", 15, 1, function()
        timer.Create( "PsiEmittion.Handlers::Damage", 1, 0, function()
            if math.random() < 0.1 then
                PlaySound( math.random(3,7) );
            end
    
            for _, ply in ipairs( player.GetAll() ) do
                if
                    not ply:Alive()
                    or ply:HasGodMode()
                    or ply.b_PsiEmittion_Ignore
                    or ply:InSafeZone()
                then
                    continue
                end
                
                if not self.Config.Filter( ply ) then
                    continue
                end
    
                local tr_WorldCeiling = util.TraceLine( {
                    start = ply:GetPos(),
                    endpos = ply:GetPos() + vector_up * 72 * 14,
                    collisiongroup = COLLISION_GROUP_WORLD
                } );
    
                if tr_WorldCeiling.Hit and (not tr_WorldCeiling.HitSky) then
                    continue
                end
    
                if self.Config:Trigger( ply ) then
                    self:ApplyInfection( ply );
                    continue
                end
    
                self:ApplyDamage( ply );
            end
        end );

        timer.Create( "PsiEmittion.Handlers::Status", self.Config.Length, 1, function()
            self:End();
        end );
    end );
end

PsiEmittion.End = function( self )
    self.Status = self.Enums.STATUS_COOLDOWN;

    PlaySound( 2 );

    if self.Config.Phrases and self.Config.Phrases.OnEnd then
        local phrase = self.Config.Phrases.OnEnd[math.random(1,#self.Config.Phrases.OnEnd)];
        if phrase and #phrase == 2 then
            rp.GlobalChat( CHAT_NONE,
                Color(227, 132, 36), "[Общий PDA] ",
                Color(218, 165, 32), phrase[1],
                Color(255, 255, 255), ': ' .. phrase[2]
            );
        end
    end

    timer.Create( "PsiEmittion.Handlers::Status", self.Config.Delay - 15, 1, function()
        self:Start();
    end );

    timer.Remove( "PsiEmittion.Handlers::Damage" );
end


--
hook.Add( "playerCanChangeTeam", "PsiEmittion::JobLock", function( ply, team, force )
    if force then
        ply.b_PsiEmittion_Locked = nil;
    end

    if ply.b_PsiEmittion_Locked then
        rp.Notify( ply, NOTIFY_ERROR, "Вы не можете сменить профессию когда были зомбированы от Пси-излучения." );
        return false
    end
end );

hook.Add( "DoPlayerDeath", "PsiEmittion::JobUnlock", function( ply )
    ply.b_PsiEmittion_Locked = nil;
end );

hook.Add( "InitPostEntity", "PsiEmittion::Initialize", function()
    PsiEmittion:End();
end );