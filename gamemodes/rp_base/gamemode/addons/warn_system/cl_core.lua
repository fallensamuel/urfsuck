-- "gamemodes\\rp_base\\gamemode\\addons\\warn_system\\cl_core.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
net.Receive( "WarnSystem", function()
    local steamid64 = net.ReadString();

    local menu;

    menu = rpui.SliderRequest( translates.Get("На сколько минут баним?"), "scoreboard/usergroups/admin.png", 1.6, function( val )
        menu:Remove();

        rpui.StringRequest( translates.Get("ПРИЧИНА БАНА"), translates.Get("Введите причину бана:"), "scoreboard/usergroups/admin.png", 1.6, function( this, reason )
            RunConsoleCommand( "urf", "warnban", steamid64, math.Round(val) .. "mi", reason );
        end );
    end );

    menu.slider.MaxValue = 120;
    menu.slider:SetPseudoKnobPos( 60 );
    menu:SetInputVal( 60 );
end );