local render_Capture, Scr_W, Scr_H, Sys_Time, util_Base64Encode, util_Compress, math_ceil, string_sub, net_Start, net_Receive, net_WriteString, net_WriteUInt, net_WriteInt, net_WriteData, net_ReadString, net_ReadUInt, net_SendToServer, hook_Add, hook_Remove, table_insert, table_remove = render.Capture, ScrW, ScrH, SysTime, util.Base64Encode, util.Compress, math.ceil, string.sub, net.Start, net.Receive, net.WriteString, net.WriteUInt, net.WriteInt, net.WriteData, net.ReadString, net.ReadUInt, net.SendToServer, hook.Add, hook.Remove, table.insert, table.remove;


local ScreenCapture = ScreenCapture or {
    Settings = {}, Networking = {}, DataQueue = {}
};


ScreenCapture.Settings.ScreenChunkSize      = 4096;

ScreenCapture.Networking.NetworkString      = "net.ScreenCapture";
ScreenCapture.Networking.RequestScreen      = 0;
ScreenCapture.Networking.ScreenCapMeta      = 1;
ScreenCapture.Networking.ScreenChunk        = 2;
ScreenCapture.Networking.ShowCapture        = 3;
ScreenCapture.Networking.Cooldown           = ScreenCapture.Networking.Cooldown or Sys_Time();


ScreenCapture.ShowCapture = function( imgur_link, title )
    title = title or "";

    local fr = ui.Create( "ui_frame" );
    fr:SetTitle( title ~= "" and title or imgur_link );
    fr:SetSize( ScrW()*0.85, ScrH()*0.85 );
    fr:Center();
    fr:MakePopup();
    
    fr.HTML = vgui.Create( "DHTML", fr );
    fr.HTML:Dock( FILL );
    fr.HTML:InvalidateParent( true );
    fr.HTML:SetHTML(
        string.format( [[
            <style type="text/css"> * { margin: 0px; padding: 0px; overflow:hidden; } </style>
            <center>
                <img src="%s" width="%d" height="%d"/>
            </center>
        ]], imgur_link, fr.HTML:GetWide(), fr.HTML:GetTall() )
    );

    print( "[urf-screencapture]:" );
    print( "  - " .. (title == "" and "Unnamed screen capture" or title) );
    print( "  - " .. imgur_link );
end


ScreenCapture.DoCapture = function( capture_uid, q )
    hook_Add( "PostRender", "ScreenCapture::PostRender", function()
        hook_Remove( "PostRender", "ScreenCapture::PostRender" );

        q = q or 70;

        local renderData = render_Capture( {
            format = "jpeg", quality = q, w = ScrW(), h = ScrH(), x = 0, y = 0
        } );

        local b64  = util_Base64Encode( renderData );
        renderData = util_Compress( b64 );

        local ChunkNum = math_ceil( #renderData / ScreenCapture.Settings.ScreenChunkSize );
        for i = 1, ChunkNum do
            local offset      = (i-1) * ScreenCapture.Settings.ScreenChunkSize + 1;
            local ScreenChunk = string_sub( renderData, offset, offset + ScreenCapture.Settings.ScreenChunkSize - 1 );

            table_insert( ScreenCapture.DataQueue, { uid = capture_uid, cid = i, chunk = ScreenChunk } );
        end

        net_Start( ScreenCapture.Networking.NetworkString );
            net_WriteUInt( ScreenCapture.Networking.ScreenCapMeta, 3 );
            net_WriteString( capture_uid );
            net_WriteUInt( ChunkNum, 11 );
            net_WriteString( util.CRC(b64) );
        net_SendToServer();

        ScreenCapture.Networking.Cooldown = Sys_Time() + 1;
    end );
end


net_Receive( ScreenCapture.Networking.NetworkString, function()
    local cmd = net_ReadUInt(3);

    if cmd == ScreenCapture.Networking.RequestScreen then
        local capture_uid = net_ReadString();
        local quality     = net_ReadUInt(7);

        ScreenCapture.DoCapture( capture_uid, quality );

        return
    end

    if cmd == ScreenCapture.Networking.ShowCapture then
        local title      = net_ReadString();
        local imgur_link = net_ReadString();

        ScreenCapture.ShowCapture( imgur_link, title );

        return
    end
end );


hook.Add( "Think", "ScreenCapture::ProcessQueue", function()
    if Sys_Time() > ScreenCapture.Networking.Cooldown then
        if #ScreenCapture.DataQueue > 0 then
            local capture_uid = ScreenCapture.DataQueue[1].uid;

            local chunk_id    = ScreenCapture.DataQueue[1].cid;
            local chunk_data  = ScreenCapture.DataQueue[1].chunk;

            net_Start( ScreenCapture.Networking.NetworkString );
                net_WriteUInt( ScreenCapture.Networking.ScreenChunk, 3 );
                net_WriteString( capture_uid );
                net_WriteUInt( chunk_id, 11 );
                net_WriteUInt( #chunk_data, 16 );
                net_WriteData( chunk_data, #chunk_data );
            net_SendToServer();

            table_remove( ScreenCapture.DataQueue, 1 );

            ScreenCapture.Networking.Cooldown = Sys_Time() + 1;
        end
    end
end );