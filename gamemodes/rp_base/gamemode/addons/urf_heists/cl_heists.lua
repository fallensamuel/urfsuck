rp.Heists.LootbagMdlRenderOffset = { pos = Vector(-2,-6,0), ang = Angle(-90,5,90) };


rp.Heists.LootbagMdl = rp.Heists.LootbagMdl or ClientsideModel( "models/jessev92/payday2/item_bag_loot_jb.mdl", RENDERGROUP_OPAQUE );
rp.Heists.LootbagMdl:SetModelScale( 1 );
rp.Heists.LootbagMdl:SetNoDraw( true );


hook.Add( "PostDrawTranslucentRenderables", "rp.Heists.RenderLootbags", function()
    if not IsValid( rp.Heists.LootbagMdl ) then return end
    if not rp.Heists.IsHeistRunning        then return end
    
    for _, ply in pairs( player.GetAll() ) do
        if not IsValid( ply )                                        then continue end
        if not ply:GetNWBool( "HasLootbag" )                         then continue end
        if ply == LocalPlayer() and not ply:ShouldDrawLocalPlayer()  then continue end
        if LocalPlayer():GetPos():DistToSqr(ply:GetPos()) >= 4194304 then continue end
        if not IsValid( ply:GetActiveWeapon() )                      then continue end

        if ply:Alive() and !string.StartWith( ply:GetActiveWeapon():GetClass(), "weapon_heists_lootbag" ) then
            local b = ply:LookupBone( "ValveBiped.Bip01_Spine1" );
            if not b then continue end

            local m = ply:GetBoneMatrix( b );
            if not m then continue end
            
            local renderPos, renderAng = LocalToWorld(
                rp.Heists.LootbagMdlRenderOffset.pos, rp.Heists.LootbagMdlRenderOffset.ang,
                m:GetTranslation(), m:GetAngles()
            );

            rp.Heists.LootbagMdl:SetPos( renderPos );
            rp.Heists.LootbagMdl:SetAngles( renderAng );

            --rp.Heists.LootbagMdl:SetupBones(); ? not needed? jigglebones???

            render.SetBlend( 1 );
            render.SetColorModulation( 1, 1, 1 );
            rp.Heists.LootbagMdl:DrawModel();
        end
    end
end );


hook.Add( "InitPostEntity", "rp.Heists.GetStatus", function()
    net.Start( "rp.Heists.NetworkMsg" ); net.SendToServer();
end );

local heist_txt = translates and translates.Get("Ограбление банка") or "Ограбление банка"

hook.Add( "HUDPaint", "rp.Heists.HUD", function()
    if rp.Heists.IsHeistRunning then
        if LocalPlayer():GetNWBool( "HasLootbag" ) then
            for k, v in pairs( ents.FindByClass("ent_heists_escape*") ) do
                local scrPos = v:GetPos():ToScreen();
                
                local wep;
                for k, v in pairs( LocalPlayer():GetWeapons() ) do
                    if string.StartWith( v:GetClass(), "weapon_heists_lootbag" ) then
                        wep = v;
                        break
                    end
                end

                if IsValid(wep) then
                    if wep:GetValue() > 0 then
                        scrPos.x = math.Clamp( scrPos.x, ScrW()*0.05, ScrW()*0.95 );
                        scrPos.y = math.Clamp( scrPos.y, ScrH()*0.05, ScrH()*0.95 );
                        draw.DrawText( translates and translates.Get("Точка сброса\n(%iм.)", math.Round(v:GetPos():Distance(LocalPlayer():GetPos())/58)) or ("Точка сброса\n(" .. math.Round(v:GetPos():Distance(LocalPlayer():GetPos())/58) .. "м.)"), rp.cfg.Heists.Fonts.WorldHint, scrPos.x, scrPos.y, Color(255,255,255,255), TEXT_ALIGN_CENTER );
                    end
                end
            end
        end

        local f = LocalPlayer():GetFaction();

        if f == FACTION_POLICE or f == FACTION_SPEC then
            local mp = rp.cfg.Heists.MarkerPos[game.GetMap()];
            
            mp = mp:ToScreen();
            if mp.visible then
                local b = math.cos(CurTime()*3)*155;
                draw.SimpleText( heist_txt, rp.cfg.Heists.Fonts.WorldHint, mp.x, mp.y, Color(255,100+b,100+b,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
            end
        end
    end
end )


net.Receive( "rp.Heists.NetworkMsg", function()
    rp.Heists.IsHeistRunning = net.ReadBool();
end );