local function PowOfTwo(n)
    n = math.floor(n); return (n % 2 == 0) and n or n + 1;  
end

local left = string.Left;
local right = string.Right;
local crc = util.CRC;

local TSort = table.sort;
local RenderedAndSortedPlayers = {};

local ValidTable = {
    [FACTION_OTA] = true
};

timer.Remove('hl2hecu-rsp-cached2');
timer.Create('hl2hecu-rsp-cached2', .5, 0, function()
    local LP = LocalPlayer();
    if (!IsValid(LP)) then return end
    if (!ValidTable[LP:GetFaction()]) then return end

    local plys = player.GetAll();
    TSort( plys, function(a,b) return a:GetPos():DistToSqr(LP:GetPos()) > b:GetPos():DistToSqr(LP:GetPos()) end );
    RenderedAndSortedPlayers = plys;
end);

hook.Add( "PostDrawTranslucentRenderables", "rp.HUD.OTA", function()
    if (!ValidTable[LocalPlayer():GetFaction()]) then return end

    local scale      = 10;
    local scale_3d2d = 1 / scale;

    local thickness    = PowOfTwo(0.5 * scale);
    local playerscales = Vector(24,24,68) * scale;

	local fact;
	
    for _, ply in ipairs( RenderedAndSortedPlayers ) do
        if not IsValid(ply) or ply == LocalPlayer() or IsValid(ply:GetObserverTarget()) then continue end
        if (ply:GetRenderMode() == 4) then continue end
		
		fact = rp.Factions[ply:GetDisguiseJobTable() and ply:GetDisguiseJobTable().faction or ply:GetFaction() or 1];
		if not fact then continue end

        --local yaw = (LocalPlayer():GetPos() - ply:GetPos()):Angle().yaw;
        local yaw = EyeAngles().yaw - 180;

        local data = left(crc(ply:SteamID()), 5)

        cam.Start3D2D( ply:GetPos(), Angle(0,yaw + 90,90), scale_3d2d );
            surface.SetDrawColor( fact and fact.OTARelations or Color(150, 170, 200, 255) );
            surface.DrawRect(
                -playerscales.x, -thickness,
                playerscales.x * 0.5, thickness
            );

            surface.DrawRect(
                -playerscales.x, -playerscales.z + thickness,
                thickness, playerscales.z - thickness * 2
            );

            surface.DrawRect(
                -playerscales.x, -playerscales.z,
                playerscales.x * 0.5, thickness
            );

            surface.DrawRect(
                playerscales.x * 0.5, -thickness,
                playerscales.x * 0.5, thickness
            );

            surface.DrawRect(
                playerscales.x - thickness, -playerscales.z + thickness,
                thickness, playerscales.z - thickness * 2
            );

            surface.DrawRect(
                playerscales.x * 0.5, -playerscales.z,
                playerscales.x * 0.5, thickness
            );

            if (LocalPlayer():CanSeeEnt(ply)) then
				local JobTable = ply:GetDisguiseJobTable() or ply:GetJobTable()
                local _TEMP = (JobTable.loyalty and rp.GetTerm('loyalty')[JobTable.loyalty]) or 'Неизвестно';
                cam.IgnoreZ( true );
                    draw.SimpleText( 'CID: ' .. left(data, 3) .. ':' .. right(data, 2), "DermaLarge", 0, -playerscales.z + 50 + 525, Color(255,255,255), TEXT_ALIGN_CENTER);
                    draw.SimpleText( 'Лояльность: ' .. _TEMP, "DermaLarge", 0, -playerscales.z + 70 + 525, Color(255,255,255), TEXT_ALIGN_CENTER);
                cam.IgnoreZ( false );
            end

            --cam.IgnoreZ( true );
                --draw.SimpleText( JobTable.name, "DermaLarge", playerscales.x + scale, -playerscales.z, Color(255,255,255) );
                --draw.SimpleText( ply:GetName(), "DermaLarge", playerscales.x + scale, -playerscales.z + 30, Color(255,255,255) );
            --cam.IgnoreZ( false );
        cam.End3D2D();
    end
end );