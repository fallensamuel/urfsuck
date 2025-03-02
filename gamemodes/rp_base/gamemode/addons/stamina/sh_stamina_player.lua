-- "gamemodes\\rp_base\\gamemode\\addons\\stamina\\sh_stamina_player.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local PLAYER = FindMetaTable( "Player" );
local CurTime = CurTime;

----------------------------------------------------------------
function PLAYER:GetStaminaLastDamagedTime()
    return self.fl_StaminaLastDamaged or 0
end

function PLAYER:GetMaxStamina()
    return self.fl_MaxStamina or 100;
end

function PLAYER:GetStamina()
    return self.fl_Stamina or 0;
end

function PLAYER:Stamina()
    return self.fl_Stamina or 0;
end

function PLAYER:HasStamina( amt )
    return self:Stamina() >= amt;
end

function PLAYER:IsStaminaRestoring()
    return (CurTime() - self:GetStaminaLastDamagedTime()) > STAMINA_RESTORE_TIME;
end

function PLAYER:IsStaminaDraining()
    return (CurTime() - self:GetStaminaLastDamagedTime()) <= STAMINA_RESTORE_TIME;
end


if STAMINA_DISABLED then
    function PLAYER:IsStaminaRestoring() return true; end
    function PLAYER:IsStaminaDraining() return false; end
    function PLAYER:GetMaxStamina() return 100; end
    function PLAYER:GetStamina() return 100; end
    function PLAYER:Stamina() return 100; end
end