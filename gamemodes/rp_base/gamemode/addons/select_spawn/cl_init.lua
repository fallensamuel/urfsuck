-- "gamemodes\\rp_base\\gamemode\\addons\\select_spawn\\cl_init.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
function rp.SelectSpawn( id )
    net.Start( "rp.SelectSpawnPoint" );
        net.WriteUInt( id, 4 );
    net.SendToServer();
end


function rp.OpenTeleportMenu( ids )
    if (not rp.cfg.TeleportNPC) then return end

    local data = rp.cfg.TeleportNPC[game.GetMap()][id];

    local m = ui.Create( "ui_frame", function( self )
        self:SetTitle( translates.Get("Проводник") );
        self:SetSize( 0.2, 0.2 );
        self:Center();
        self:MakePopup();
    end );

    local x, y = m:GetDockPos();
    local scr = ui.Create( "ui_scrollpanel", function( self, p )
        self:SetPos( x, y );
        self:SetSize( p:GetWide() - 10, p:GetTall() - y - 5 );

        for k, v in pairs( ids ) do
            local point = rp.cfg.SpawnPoints[v];
			if not point then continue end

            local p = ui.Create( "DButton", function( self, p )
                self:SetTall( 30 );
                self:SetText( point.Price and (point.Name.." - "..rp.FormatMoney(point.Price)) or point.Name );

                function self:DoClick()
                    net.Start( "rp.SelectTeleportPoint" );
                        net.WriteUInt( v, 4 );
                    net.SendToServer();

                    m:Close();
                end
            end );

            self:AddItem( p );
        end
    end, m );

    m:Focus();
end


function rp.OpenTeleportSvitokMenu()
	if (not rp.cfg.TeleportNPC) or (not rp.cfg.SvitkiTeleportacii) then return end

    local data = rp.cfg.TeleportNPC[game.GetMap()][id];

    local m = ui.Create( "ui_frame", function( self )
        self:SetTitle( translates.Get("Покупка свитков телепортации") );
        self:SetSize( 0.2, 0.2 );
        self:Center();
        self:MakePopup();
    end );

    local x, y = m:GetDockPos();
    local scr = ui.Create( "ui_scrollpanel", function( self, p )
        self:SetPos( x, y );
        self:SetSize( p:GetWide() - 10, p:GetTall() - y - 5 );

        for k, v in pairs( rp.cfg.SvitkiTeleportacii ) do
            local p = ui.Create( "DButton", function( self, p )
                self:SetTall( 30 );
                self:SetText( k .. " - " .. rp.FormatMoney(v.Price) );

                function self:DoClick()
                    local finded = false;

                    for _k, _v in ipairs( table.GetKeys(rp.cfg.SvitkiTeleportacii) ) do
                        if (_v == k) then finded = _k; end
                    end

                    if not finded then return end

                    net.Start( "rp.SelectTeleportSvitokPoint" );
                        net.WriteUInt( finded, 4 );
                    net.SendToServer();

                    m:Close();
                end
            end );

            self:AddItem( p );
        end
    end, m );

    m:Focus();
end