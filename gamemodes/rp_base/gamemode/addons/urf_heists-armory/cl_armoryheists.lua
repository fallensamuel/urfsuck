rp.ArmoryHeists.ReadHeistSync = function()
    return net.ReadUInt(4), net.ReadBool(), net.ReadFloat();
end

net.Receive( "rp.ArmoryHeists.NetworkMsg", function()
    local id, inprogress, ts = rp.ArmoryHeists.ReadHeistSync();

    rp.ArmoryHeists.List[id].IsInProgress = inprogress;
    rp.ArmoryHeists.List[id].Timestamp    = ts;
	
	if rp.ArmoryHeists.GetHeistCfg( id ).Stealth then
		rp.ArmoryHeists.List[id].StealthBreak = net.ReadBool()
	end
end );


local function beautifyTime( t )
    t = math.max( t, 0 );
    local mins = math.floor( t / 60 );
    local secs = math.floor( t % 60 );
    return (mins < 10 and ("0"..mins) or mins) .. ":" .. (secs < 10 and ("0"..secs) or secs);
end


local function render_DrawZone( mins, maxs, height, rendercolor )
    local x1, x2 = mins.x, maxs.x;
    local y1, y2 = mins.y, maxs.y;
    local z, h   = mins.z, mins.z + height;

    -- left
    render.DrawQuad( Vector( x1, y2, z ), Vector( x1, y2, h ), Vector( x2, y2, h ), Vector( x2, y2, z ), rendercolor );
    render.DrawQuad( Vector( x2, y2, z ), Vector( x2, y2, h ), Vector( x1, y2, h ), Vector( x1, y2, z ), rendercolor );

    -- top
    render.DrawQuad( Vector( x1, y1, z ), Vector( x1, y1, h ), Vector( x1, y2, h ), Vector( x1, y2, z ), rendercolor );
    render.DrawQuad( Vector( x1, y2, z ), Vector( x1, y2, h ), Vector( x1, y1, h ), Vector( x1, y1, z ), rendercolor );

    -- right
    render.DrawQuad( Vector( x2, y1, z ), Vector( x2, y1, h ), Vector( x1, y1, h ), Vector( x1, y1, z ), rendercolor );
    render.DrawQuad( Vector( x1, y1, z ), Vector( x1, y1, h ), Vector( x2, y1, h ), Vector( x2, y1, z ), rendercolor );

    -- bottom
    render.DrawQuad( Vector( x2, y2, z ), Vector( x2, y2, h ), Vector( x2, y1, h ), Vector( x2, y1, z ), rendercolor );
    render.DrawQuad( Vector( x2, y1, z ), Vector( x2, y1, h ), Vector( x2, y2, h ), Vector( x2, y2, z ), rendercolor );
end


local __tGradientMat = CreateMaterial( "armhstgradient", "UnlitGeneric", {
    ["$basetexture"] = "gui/gradient",
    ["$translucent"] = 1,
    ["$vertexalpha"] = 1,
    ["$vertexcolor"] = 1,
} );


hook.Add( "InitPostEntity", "rp.ArmoryHeists.Init", function()
    net.Start( "rp.ArmoryHeists.NetworkMsg" ); net.SendToServer();
end );


hook.Add( "PreDrawTranslucentRenderables", "rp.ArmoryHeists.RenderCaptureZone", function()
    for id, Heist in pairs( rp.ArmoryHeists.List ) do
        if Heist.IsInProgress then
            local HeistData = rp.ArmoryHeists.GetHeistCfg( id );

            local IsAttacker, IsDefender = HeistData.Attackers.Filter( LocalPlayer() ), HeistData.Defenders.Filter( LocalPlayer() );

			
			if not HeistData.TerritoriesTraced then
				local AttackerTerritory = HeistData.Attackers.Territory;
				local DefenderTerritory = HeistData.Defenders.Territory;
				
				local x1, x2 = AttackerTerritory.mins.x, AttackerTerritory.maxs.x;
				local y1, y2 = AttackerTerritory.mins.y, AttackerTerritory.maxs.y;
				local z = AttackerTerritory.mins.z
				
				local tr1 = util.TraceLine({start = Vector(x1, y1, z), endpos = Vector(x1, y1, z) - Vector(0, 0, 100)})
				local tr2 = util.TraceLine({start = Vector(x1, y2, z), endpos = Vector(x1, y2 , z) - Vector(0, 0, 100)})
				local tr3 = util.TraceLine({start = Vector(x2, y1, z), endpos = Vector(x2, y1, z) - Vector(0, 0, 100)})
				local tr4 = util.TraceLine({start = Vector(x2, y2, z), endpos = Vector(x2, y2, z) - Vector(0, 0, 100)})
				
				AttackerTerritory.mins.z = math.min(tr1.FractionLeftSolid == 0 and tr1.HitPos.z or AttackerTerritory.mins.z, tr2.FractionLeftSolid == 0 and tr2.HitPos.z or AttackerTerritory.mins.z, tr3.FractionLeftSolid == 0 and tr3.HitPos.z or AttackerTerritory.mins.z, tr4.FractionLeftSolid == 0 and tr4.HitPos.z or AttackerTerritory.mins.z, AttackerTerritory.mins.z)
				
				
				x1, x2 = DefenderTerritory.mins.x, DefenderTerritory.maxs.x;
				y1, y2 = DefenderTerritory.mins.y, DefenderTerritory.maxs.y;
				z = DefenderTerritory.mins.z
				
				local tr1 = util.TraceLine({start = Vector(x1, y1, z), endpos = Vector(x1, y1, z) - Vector(0, 0, 100)})
				local tr2 = util.TraceLine({start = Vector(x1, y2, z), endpos = Vector(x1, y2 , z) - Vector(0, 0, 100)})
				local tr3 = util.TraceLine({start = Vector(x2, y1, z), endpos = Vector(x2, y1, z) - Vector(0, 0, 100)})
				local tr4 = util.TraceLine({start = Vector(x2, y2, z), endpos = Vector(x2, y2, z) - Vector(0, 0, 100)})
				
				DefenderTerritory.mins.z = math.min(tr1.FractionLeftSolid == 0 and tr1.HitPos.z or DefenderTerritory.mins.z, tr2.FractionLeftSolid == 0 and tr2.HitPos.z or DefenderTerritory.mins.z, tr3.FractionLeftSolid == 0 and tr3.HitPos.z or DefenderTerritory.mins.z, tr4.FractionLeftSolid == 0 and tr4.HitPos.z or DefenderTerritory.mins.z, DefenderTerritory.mins.z)
				
				HeistData.TerritoriesTraced = true
			end
			
            local AttackerTerritory = HeistData.Attackers.Territory;
			
            render.SetMaterial( __tGradientMat );
            render_DrawZone( AttackerTerritory.mins, AttackerTerritory.maxs, 16, Color(255,0,0,32) );

            if IsDefender then
				local DefenderTerritory = HeistData.Defenders.Territory;
                render.SetMaterial( __tGradientMat );
                render_DrawZone( DefenderTerritory.mins, DefenderTerritory.maxs, 16, Color(0,0,255,32) );
            end
        end
    end
end );

--[[ ПЕРЕНЕСЕНО НА БАЗУ BUBBLE HINTS!
boxHeistEnts = boxHeistEnts or {};

timer.Create( "updateboxheistents", 1, 0, function()
    for _, ent in pairs( ents.FindByClass("rp_item") ) do
        if boxHeistEnts[ent] then continue end

        local id = ent:GetNWInt( "HeistID", -1 );

        if id ~= -1 then
            boxHeistEnts[ent] = id;
            ent.NoAnimatons   = true;
        end
    end
end );

local press_e_txt = translates and translates.Get("Нажмите [E] чтобы начать ограбление") or "Нажмите [E] чтобы начать ограбление"
local cooldown_txt = translates and translates.Get("Перезарядка") or "Перезарядка"

hook.Add("PostDrawTranslucentRenderables", "rp.ArmoryHeists.boxHeistEnts", function()
    if rp.DrawInfoBubble then return end
    
    for ent, id in pairs( boxHeistEnts or {} ) do
        if not IsValid( ent ) then
            boxHeistEnts[ent] = nil;
			break
        end

        local plypos = LocalPlayer():GetPos();
        local pos    = ent:LocalToWorld( Vector(0,0,ent:GetModelRadius()*1.25) );
        
        if plypos:DistToSqr( pos ) > 122500 then continue end
        
        local HeistData = rp.ArmoryHeists.GetHeistCfg(id);
        
        local atan2  = math.atan2(plypos.y - pos.y, plypos.x - pos.x);
        local ang    = Angle( 0, math.deg(atan2) + 90, 90 );
    
        local s      = 0.1;
    
        cam.Start3D2D( pos, ang, s );
            local status = HeistData.Name .. "\n";
    
            if rp.ArmoryHeists.List and rp.ArmoryHeists.List[id] then
                if rp.ArmoryHeists.List[id].IsInProgress then
                    local t = rp.ArmoryHeists.List[id].Timestamp - CurTime();
                    status = status .. beautifyTime(t);
                else
                    if rp.ArmoryHeists.List[id].Timestamp > CurTime() then
                        local cd = rp.ArmoryHeists.List[id].Timestamp - CurTime();
                        status = status .. cooldown_txt .. " (" .. beautifyTime(cd) .. ")";
                    else
                        status = status .. press_e_txt;
                    end
                end
            end
    
            draw.DrawText( status, rp.cfg.ArmoryHeists.__Fonts.EntityBig, 0, 0, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM );
        cam.End3D2D();
    end
end)


hook.Add( "HUDPaint", "rp.ArmoryHeists.HUD", function()    
    for id, Heist in pairs( rp.ArmoryHeists.List ) do
        if Heist.IsInProgress then
            local HeistData = rp.ArmoryHeists.GetHeistCfg( id );

            if (not HeistData.Stealth or Heist.StealthBreak) and HeistData.Defenders.Filter( LocalPlayer() ) then
                local mp = HeistData.MarkerPosition;
                
                mp = mp:ToScreen();
                if mp.visible then
                    local b = math.cos(CurTime()*3)*155;
                    draw.SimpleText( HeistData.Name, rp.cfg.ArmoryHeists.__Fonts.WorldHint, mp.x, mp.y, Color(255,100+b,100+b,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
                end
            end
        end
    end
end );
]]--