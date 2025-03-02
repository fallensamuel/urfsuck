local ScreenCapture = ScreenCapture or {
    Settings = {}, Networking = {}, Screens = {}
};


ScreenCapture.Settings.ImgurAPI         = "f7b6485884c49ce";
ScreenCapture.Settings.ScreenCapTimeout = 60;

ScreenCapture.Networking.NetworkString  = "net.ScreenCapture";
ScreenCapture.Networking.RequestScreen  = 0;
ScreenCapture.Networking.ScreenCapMeta  = 1;
ScreenCapture.Networking.ScreenChunk    = 2;
ScreenCapture.Networking.ShowCapture    = 3;


util.AddNetworkString( ScreenCapture.Networking.NetworkString );


ScreenCapture.SendCapture = function( capture_uid, ply )
    local ScreenCap = ScreenCapture.Screens[capture_uid];

    if not ScreenCap                then return end
    if not ScreenCap.meta.ImageLink then return end

    net.Start( ScreenCapture.Networking.NetworkString );
        net.WriteUInt( ScreenCapture.Networking.ShowCapture, 3 );
        net.WriteString( ScreenCap.meta.Title );
        net.WriteString( ScreenCap.meta.ImageLink );
    net.Send( ply );
end


ScreenCapture.UploadToImgur = function( capture_uid )
    local ScreenCap = ScreenCapture.Screens[capture_uid];

    if not ScreenCap                 then return end
    if not ScreenCap.meta.IsCaptured then return end

    http.Post(
        "https://api.imgur.com/3/upload",
        {
            name  = ScreenCap.meta.Title,
            image = ScreenCap.meta.Image,
            type  = "base64",
        },
        function( responseText )
            responseText = util.JSONToTable( responseText );

            ScreenCap.meta.ImageLink = responseText.data.link;

            if ScreenCap.meta.Caller then
                ScreenCapture.SendCapture( capture_uid, ScreenCap.meta.Caller );
                ScreenCap.meta.Caller = nil;
            end
        end,
        function( errorMessage )
        end,
        {
            Authorization = "Client-ID " .. ScreenCapture.Settings.ImgurAPI
        }
    );
end


ScreenCapture.RequestScreen = function( ply, caller, quality )
    if not IsValid(ply)   then return end
    if not ply:IsPlayer() then return end

    quality = quality or 70;

    local capture_uid = util.CRC(ply:SteamID64()..SysTime());

    ScreenCapture.Screens[capture_uid] = {
        meta = {
            IsCaptured = false,
            ChunkNum   = -1,
            SteamID64  = ply:SteamID64(),
            Heartbeat  = SysTime() + ScreenCapture.Settings.ScreenCapTimeout,
        },

        CapturedData = {}
    }

    if IsValid(caller) then
        if caller:IsPlayer() then
            ScreenCapture.Screens[capture_uid].meta.Caller = caller;
        end
    end

    net.Start( ScreenCapture.Networking.NetworkString );
        net.WriteUInt( ScreenCapture.Networking.RequestScreen, 3 );
        net.WriteString( capture_uid );
        net.WriteUInt( quality, 7 );
    net.Send( ply );
end
ScreenCapture_RequestScreen = ScreenCapture.RequestScreen;

net.Receive( ScreenCapture.Networking.NetworkString, function( len, ply )
    local cmd = net.ReadUInt(3);

    if cmd == ScreenCapture.Networking.ScreenCapMeta then
        local capture_uid = net.ReadString();

        local ScreenCap = ScreenCapture.Screens[capture_uid];

        if not ScreenCap then return end
        if ScreenCap.meta.SteamID64 ~= ply:SteamID64() then return end
        
        local chunk_num = net.ReadUInt( 11 );
        ScreenCap.meta.ChunkNum = chunk_num;
        
        local checksum = net.ReadString();
        ScreenCap.meta.Checksum = checksum;

        ScreenCap.meta.Title = "[" .. game.GetIPAddress() .. " | ".. util.DateStamp() .. "] >>" .. " Player: " .. ply:GetName() ..  " (" .. ply:SteamID64() .. ")" .. " (" .. team.GetName(ply:Team()) .. ")" .. " (" .. ply:GetRank() .. ")";
        
        if IsValid(ScreenCap.meta.Caller) then
            ba.notify( ScreenCap.meta.Caller, ba.Term("ScreenCapture.Processing"), ply, ScreenCap.meta.ChunkNum );
        end
        return
    end

    if cmd == ScreenCapture.Networking.ScreenChunk then
        local capture_uid = net.ReadString();

        local ScreenCap = ScreenCapture.Screens[capture_uid];

        if not ScreenCap then return end
        if ScreenCap.meta.SteamID64 ~= ply:SteamID64() then return end

        local chunk_num       = net.ReadUInt(11);
        local chunk_data_size = net.ReadUInt(16);
        local chunk_data      = net.ReadData(chunk_data_size);

        ScreenCap.CapturedData[chunk_num] = chunk_data;

        ScreenCap.meta.Heartbeat = SysTime() + ScreenCapture.Settings.ScreenCapTimeout;
        return
    end
end );


hook.Add( "Think", "ScreenCapture::ProcessScreens", function()
    for CaptureID, ScreenCap in pairs( ScreenCapture.Screens ) do
        if ScreenCap.meta.IsCaptured then continue end

        if ScreenCap.meta.Heartbeat < SysTime() then
            -- Игрок не отправлял данные скринкапа
            ScreenCapture.Screens[CaptureID] = nil;
        end

        if ScreenCap.meta.ChunkNum == table.Count(ScreenCap.CapturedData) then
            ScreenCap.meta.IsCaptured = true;
            
            ScreenCap.meta.Image = util.Decompress( table.concat(ScreenCap.CapturedData) );
            
            if util.CRC(ScreenCap.meta.Image) ~= ScreenCap.meta.Checksum then
                -- Скринкап поврежден?
            end

            ScreenCap.meta.ChunkNum  = nil;
            ScreenCap.meta.Heartbeat = nil;

            ScreenCap.CapturedData = nil;

            ScreenCapture.UploadToImgur(CaptureID);
        end
    end
end );