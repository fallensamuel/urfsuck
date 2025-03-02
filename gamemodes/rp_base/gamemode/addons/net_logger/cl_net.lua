-- "gamemodes\\rp_base\\gamemode\\addons\\net_logger\\cl_net.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
AddCSLuaFile()
NetLogger = NetLogger or {}
local log_net = NetLogger.Log
local function printN(...)
    notification.AddLegacy( ..., 0, 2 )

end

local function open_menu()
    local w,h = ScrW(),ScrH()
    if IsValid( NetLogger.frame ) then NetLogger.frame:Remove() end
    local frame = vgui.Create("DFrame")
    NetLogger.frame = frame
    frame:SetSize(w*0.7,h*0.6)
    frame:Center()
    frame:SetTitle("Net Logger")
    frame:MakePopup()

    
    local sheet = vgui.Create("DPropertySheet",frame)
    sheet:Dock(FILL)

    local client = vgui.Create("DPanel",sheet)
    sheet:AddSheet( "Client", client, "icon16/computer.png" )
    frame.client = client
    
    local server = vgui.Create("DPanel",sheet)
    sheet:AddSheet( "Server", server, "icon16/server.png" )
    frame.server = server

	local x,y = frame:GetSize()
	local x1,y1 = x*0.001,y*0.001
	local x2,y2 = x*0.01,y*0.01
	local x3,y3 = x*0.1,y*0.1


    ------------- CLIENT --------------------------
        local ClAppList = vgui.Create( "DListView", client )
        ClAppList:Dock( FILL )
        ClAppList:SetMultiSelect( true )
        ClAppList:AddColumn( "Имя нета" )
        ClAppList:AddColumn( "Запусков(всего)" )
        ClAppList:AddColumn( "Максимальный вес" )
        ClAppList:AddColumn( "Средний вес" )
        

        function frame.client.loaddata(tbl)
            ClAppList:Clear()
            for name,tbl in pairs(tbl) do
                ClAppList:AddLine( name, tbl.runs,tbl.maxlen,tbl.midlen )
            end
        end


        local ClRPnl = vgui.Create("DPanel",client)
        ClRPnl:SetSize(x3*2,1)
        ClRPnl:Dock(RIGHT)

        local ClLoadData
        local ClLogging = vgui.Create("DButton",ClRPnl)
        ClLogging:Dock(TOP)
        ClLogging:SetTooltip("Статус логирования.\nПри включеном режиме поднимается нагрузка на клиент")
        local function update_text()
            if NetLogger.netRealoaded then
                ClLogging:SetText("Выключить")
            else
                ClLogging:SetText("Включить")
            end
        end
        update_text()
        ClLogging.DoClick = function(self)
            local status = not NetLogger.netRealoaded
            if status then
                ClLoadData:Show()
                ClRPnl:InvalidateChildren()
                NetLogger.Data = NetLogger.Data or {}
                if not NetLogger.netRealoaded then
                    NetLogger.netRealoaded = true
                    
                    _net_Incoming = net.Incoming
                    function net.Incoming( len, client )

                        local i = net.ReadHeader()
                        local strName = util.NetworkIDToString( i )
                        
                        if ( !strName ) then return end

                        log_net(strName,len)
                        
                        local func = net.Receivers[ strName:lower() ]
                        if ( !func ) then return end

                        --
                        -- len includes the 16 bit int which told us the message name
                        --
                        len = len - 16
                        
                        func( len, client )

                    end
                    printN("Логирование включено")
                end

            else
                ClLoadData:Hide()
                ClRPnl:InvalidateChildren()
                if NetLogger.netRealoaded then
                    net.Incoming = _net_Incoming
                    NetLogger.netRealoaded = false
                end
                printN("Логирование выключено")
                if NetLogger.Data then frame.client.loaddata(NetLogger.Data) end
            end
            update_text()
        end


        ClLoadData = vgui.Create("DButton",ClRPnl)
        ClLoadData:SetSize(1,y2*5)
        ClLoadData:Dock(TOP)
        ClLoadData:SetText("Обновить данные")
        ClLoadData.DoClick = function(self)
            frame.client.loaddata(NetLogger.Data or {})
            printN("Таблица загружена!")
        end
        if NetLogger.Data then frame.client.loaddata(NetLogger.Data) end
        if not NetLogger.netRealoaded then ClLoadData:Hide() ClRPnl:InvalidateChildren() end

        local ClearData = vgui.Create("DButton",ClRPnl)
        ClearData:SetSize(1,y2*5)
        ClearData:Dock(TOP)
        ClearData:SetText("Почистить")
        ClearData:SetTooltip("Чистит таблицу на вашем клиенте.")
        ClearData.DoClick = function(self)
            NetLogger.Data = {}
            printN("Таблица очищена!")
            if NetLogger.Data then frame.client.loaddata(NetLogger.Data) end
        end


    ------------------------- SERVER -----------------------------------{

        local SrAppList = vgui.Create( "DListView", server )
        SrAppList:Dock( FILL )
        SrAppList:SetMultiSelect( true )
        SrAppList:AddColumn( "Имя нета" )
        SrAppList:AddColumn( "Запусков(всего)" )
        SrAppList:AddColumn( "Максимальный вес" )
        SrAppList:AddColumn( "Средний вес" )
        

        function frame.server.loaddata(tbl)
            SrAppList:Clear()
            for name,tbl in pairs(tbl) do
                SrAppList:AddLine( name, tbl.runs,tbl.maxlen,tbl.midlen )
            end
        end


        local SrRPnl = vgui.Create("DPanel",server)
        SrRPnl:SetSize(x3*2,1)
        SrRPnl:Dock(RIGHT)

        local ServerLoad = vgui.Create("DButton",SrRPnl)
        ServerLoad:SetSize(1,y2*4)
        ServerLoad:Dock(TOP)
        ServerLoad:SetText("Обновить настройки")
        ServerLoad:SetTooltip("Загружает серверные настройки.")
        ServerLoad.DoClick = function(self)
            net.Start("NetLogger.GetInfo")
            net.SendToServer()
        end

        


        net.Start("NetLogger.GetInfo")
        net.SendToServer()
        ------------------------------------------------------------------
        
        local function upd_info()
            net.Start("NetLogger.GetInfo") net.SendToServer()
        end
        frame.LoadServerInfo = function(tbl)
            if IsValid( frame.SrRNPanel ) then frame.SrRNPanel:Remove() end
            local SrRNPanel = vgui.Create("DPanel",SrRPnl)
            frame.SrRNPanel = SrRNPanel
            SrRNPanel:Dock(FILL)
            SrRNPanel:DockPadding(5, 5, 5, 5)
            -- SrRNPanel.Paint = function(self,x,y)
            --     surface.SetDrawColor(Color(50,50,255,100))
            --     surface.DrawRect(0,0,x,y)
            -- end

            local ClLogging = vgui.Create("DButton",SrRNPanel)
            ClLogging:Dock(TOP)
            ClLogging:SetTooltip("Статус логирования.\nПри включеном режиме поднимается нагрузка на сервер")
            if tbl.Active then
                ClLogging:SetText("Выключить")
            else
                ClLogging:SetText("Включить")
            end
            ClLogging.DoClick = function(self)
                net.Start("NetLogger.SetStatus")
                    net.WriteBool(not tbl.Active)
                net.SendToServer()
                upd_info()
                if tbl.Active then
                    net.Start("NetLogger.GetData")
                    net.SendToServer()
                end
                
            end


            if tbl.Active then
                local SvLoadData = vgui.Create("DButton",SrRNPanel)
                SvLoadData:SetSize(1,y2*5)
                SvLoadData:Dock(TOP)
                SvLoadData:SetText("Обновить данные")
                SvLoadData.DoClick = function(self)
                    net.Start("NetLogger.GetData")
                    net.SendToServer()
                    upd_info()
                end
            end
            
            local UseMySQL = vgui.Create("DCheckBoxLabel",SrRNPanel)
            UseMySQL:Dock(TOP)
            UseMySQL:SetText("Использование MySQL")
            UseMySQL:SetTooltip("Все сервые данные будет сохраняться в MySQL таблицу")
            if tbl.MySQL then UseMySQL:SetValue(1) end
            UseMySQL.OnChange = function(self,status)
                net.Start("NetLogger.UseMySQL")
                    net.WriteBool(status)
                net.SendToServer()
                upd_info()
            end
            UseMySQL:SetTextColor(Color(60,60,60))

            local AutoRun = vgui.Create("DCheckBoxLabel",SrRNPanel)
            AutoRun:Dock(TOP)
            AutoRun:SetText("АвтоВключение")
            AutoRun:SetTooltip("Автовключение логирования при запуске аддона")
            if tbl.AutoRun == "true" then AutoRun:SetValue(1) end
            AutoRun.OnChange = function(self,status)
                net.Start("NetLogger.SetAutoRun")
                    net.WriteBool(status)
                net.SendToServer()
                upd_info()
            end
            AutoRun:SetTextColor(Color(60,60,60))
            

            local ClearData = vgui.Create("DButton",SrRNPanel)
            ClearData:SetSize(1,y2*5)
            ClearData:Dock(TOP)
            ClearData:SetText("Почистить")
            ClearData:SetTooltip("Чистит таблицу на сервере.\nЕсли будет использоваться MySQL, то MySQL таблица тоже почиститься")
            ClearData.DoClick = function(self)
                net.Start("NetLogger.Clear")
                net.SendToServer()
                upd_info()
                net.Start("NetLogger.GetData")
                net.SendToServer()
            end
        

			if NetLogger.ServerData then frame.server.loaddata(NetLogger.ServerData) end
        end
    -------}

    
end


net.Receive("NetLogger.GetData",function(len,ply)
    NetLogger.ServerData = net.ReadTable()
    if NetLogger.frame then
        NetLogger.frame.server.loaddata(NetLogger.ServerData)
    end
end)


concommand.Add("netlogger", function(ply,cmd,args)
    if NetLogger.HasAccess(ply) then
        open_menu()
    else
        print("У вас нету прав!")
    end
end)

net.Receive("NetLogger.GetInfo",function(len,ply)
    local tbl = net.ReadTable()
    if NetLogger.frame then
        NetLogger.frame.LoadServerInfo(tbl or {})
    end
end)