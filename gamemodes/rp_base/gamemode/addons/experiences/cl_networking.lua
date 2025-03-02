-- "gamemodes\\rp_base\\gamemode\\addons\\experiences\\cl_networking.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
----------------------------------------------------------------
rp.Experiences = rp.Experiences or {};

----------------------------------------------------------------
function rp.Experiences:ReadExperience()
    return net.ReadString(), net.ReadUInt( 32 );
end

----------------------------------------------------------------
net.Receive( "rp.Experiences", function()
    local multiple, count = net.ReadBool(), 1;

    if multiple then
        count = net.ReadUInt( 8 );
    end

    for k = 1, count do
        rp.Experiences:SetExperience( rp.Experiences:ReadExperience() );
    end
end );