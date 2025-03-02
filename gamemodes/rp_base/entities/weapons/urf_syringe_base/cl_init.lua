-- "gamemodes\\rp_base\\entities\\weapons\\urf_syringe_base\\cl_init.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
include( "shared.lua" );


net.Receive( "urf.weapon_syringe", function()
    local classname = WEAPON_SYRINGE_IDX[net.ReadUInt(5)];
    if not classname then return end

    local wep = weapons.Get( classname );

    if wep.UseSyringe then
        wep:UseSyringe( LocalPlayer() );
    end

    if wep.OnSyringedEffectStart then
        wep.OnSyringedEffectStart( LocalPlayer() );
    end

    if wep.OnSyringedEffectEnd then
        hook.Add( "Tick", wep.ClassName, function()
            if LocalPlayer():Health() < 1 then
                if wep.EffectLength then
                    timer.Adjust( classname .. "EffectHandler", 0 );
                else
                    hook.Remove( "Tick", wep.ClassName );
                    wep.OnSyringedEffectEnd( LocalPlayer() );
                end
            end
        end );

        timer.Create( classname .. "EffectHandler", wep.EffectLength or 0, 1, function()
            hook.Remove( "Tick", classname );
            wep.OnSyringedEffectEnd( LocalPlayer() );
        end );
    end
end );


function SWEP:Deploy() return false end    -- managed on serverside
function SWEP:Holster() return false end    -- managed on serverside

function SWEP:PrimaryAttack()   end         -- "ебучее кликанье"
function SWEP:SecondaryAttack() end         -- "ебучее кликанье"


function SWEP:PreDrawViewModel( vm )
    vm:SetSkin( self.SkinID or 0 );
end

function SWEP:PostDrawViewModel( vm )
    vm:SetSkin( 0 );
end