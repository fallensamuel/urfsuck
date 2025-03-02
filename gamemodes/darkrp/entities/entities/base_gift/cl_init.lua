-- "gamemodes\\darkrp\\entities\\entities\\base_gift\\cl_init.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
include( "shared.lua" );

net.Receive( "base_gift", function()
    local ent = net.ReadEntity();
    if IsValid( ent ) and ent.IsGift then
        local ply = net.ReadEntity();
        if not IsValid( ply ) then return end

        ent:OnTouched( ply );
    end
end );

function ENT:DrawTranslucent( flags )
    local t = SysTime();
    local origin, angles = self:GetNetworkOrigin(), self:GetNetworkAngles();

    local s = math.sin(t);

    self:SetRenderOrigin( origin + vector_up * (16 + s * 8) );
    self:SetRenderAngles( angles + Angle(0, t * 60, s * 15) );

    self:DrawModel( flags );
end