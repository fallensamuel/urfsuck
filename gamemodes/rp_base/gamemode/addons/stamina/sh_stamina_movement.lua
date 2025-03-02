-- "gamemodes\\rp_base\\gamemode\\addons\\stamina\\sh_stamina_movement.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
if STAMINA_DISABLED then return end

----------------------------------------------------------------
local VECTOR, CUSERCMD = FindMetaTable( "Vector" ), FindMetaTable( "CUserCmd" );
local GetButtons, SetButtons, KeyDown = CUSERCMD.GetButtons, CUSERCMD.SetButtons, CUSERCMD.KeyDown;
local Length2DSqr = VECTOR.Length2DSqr;
local bit_band, bit_bnot, bit_bor, IsFirstTimePredicted, engine_TickInterval, CurTime, FrameTime, hook_Add = bit.band, bit.bnot, bit.bor, IsFirstTimePredicted, engine.TickInterval, CurTime, FrameTime, hook.Add;

----------------------------------------------------------------
hook_Add( "StartCommand", "Stamina::SetupCommand", function( ply, cmd )
    if not ply:Alive() then return end

    if ply:IsStaminaRestoring() then return end

    local stamina = ply:Stamina();
    if stamina <= 5 then
        local keys = bit_band( GetButtons(cmd), bit_bnot(IN_JUMP) );

        if stamina <= 0 then
            keys = bit_band( keys, bit_bnot(IN_SPEED) );
        end

        SetButtons( cmd, keys );
    end
end );

hook_Add( "SetupMove", "Stamina::SetupMove", function( ply, mv, cmd )
    if CLIENT and not IsFirstTimePredicted() then return end

    if not ply:Alive() then return end

    local time = CurTime();
    local rate = STAMINA_RATE * engine_TickInterval();

    if ply:IsStaminaDraining() then
        if ply:IsOnGround() then
            -- Running handler:
            if KeyDown( cmd, IN_SPEED ) then
                ply.fl_Stamina_NextRegen = time + 1.25;

                if Length2DSqr( ply:GetVelocity() ) > 10000 then
                    rate = rate * 2;
                    ply:TakeStamina( rate, true );
                end
            end

            -- Jumping handler:
            if KeyDown( cmd, IN_JUMP ) then
                if not ply.b_Stamina_IN_JUMP then
                    ply.b_Stamina_IN_JUMP, ply.fl_Stamina_NextRegen = true, time + 1.25;

                    ply:TakeStamina( rate * 33, true );
                end
            else
                if ply.b_Stamina_IN_JUMP then ply.b_Stamina_IN_JUMP = false; end
            end
        end
    end

    local movement = KeyDown( cmd, bit_bor(IN_FORWARD, IN_BACK, IN_MOVELEFT, IN_MOVERIGHT) );

    if (ply:Stamina() < ply:GetMaxStamina()) and ((ply.fl_Stamina_NextRegen or 0) < time) then
        ply:AddStamina( rate * (movement and 0.3 or 0.5), true );
    end
end );
