-- "gamemodes\\rp_base\\gamemode\\addons\\stamina\\cl_stamina_player.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local PLAYER = FindMetaTable( "Player" );
local isnumber, math_max, math_Clamp, hook_Run = isnumber, math.max, math.Clamp, hook.Run;

----------------------------------------------------------------
function PLAYER:SetStaminaLastDamagedTime( t )
    self.fl_StaminaLastDamaged = t;
end

function PLAYER:SetMaxStamina( amt )
    self.fl_MaxStamina = math_max( 0, amt );
end

function PLAYER:SetStamina( amt )
    self.fl_Stamina = math_Clamp( amt, 0, self:GetMaxStamina() );
end

function PLAYER:AddStamina( amt )
    local mod = hook_Run( "OnStaminaAdded", ply, amt, true );
    if isnumber( mod ) then amt = mod; end

    self:SetStamina( self:Stamina() + amt );
end

function PLAYER:TakeStamina( amt )
    local mod = hook_Run( "OnStaminaTaken", ply, amt, true );
    if isnumber( mod ) then amt = mod; end

    self:SetStamina( self:Stamina() - amt );
end