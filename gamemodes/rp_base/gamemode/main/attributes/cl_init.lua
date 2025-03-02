-- "gamemodes\\rp_base\\gamemode\\main\\attributes\\cl_init.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
AttributeSystem.Players.LocalPlayer = AttributeSystem.Players.LocalPlayer or {};

hook.Add( "InitPostEntity", "AttributeSystem::Setup", function()
    timer.Create( "AttributeSystem.Notify", 300, 0, function()
        if AttributeSystem.Players.LocalPlayer.Points and AttributeSystem.Players.LocalPlayer.Points > 0 then
            rp.Notify( NOTIFY_GENERIC, translates.Get("Вам доступно %i очков навыков! Прокачайся в F4 - Навыки!", AttributeSystem.Players.LocalPlayer.Points) );
        end
    end );
end );