NetLogger = NetLogger or {}
util.AddNetworkString("NetLogger.GetData")
util.AddNetworkString("NetLogger.Clear")
util.AddNetworkString("NetLogger.SetStatus")
util.AddNetworkString("NetLogger.UseMySQL")
util.AddNetworkString("NetLogger.GetInfo")
util.AddNetworkString("NetLogger.SetAutoRun")

--[[
NetLogger.MySQL = {
    address = "127.0.0.1",
    user = "root",
    password = "feedbackKing234",
    db = "server",
    port = 3306
}
]]

NetLogger.Data = NetLogger.Data or {}
NetLogger.NeedSave = {}



local function printN(...)
    print("[NetLogger] " .. ...)
end

local log_net = NetLogger.Log

require("mysqloo")

local CONNECTNOT = mysqloo.DATABASE_NOT_CONNECTED
local CONNECTING = mysqloo.DATABASE_CONNECTING
local CONNECTED = mysqloo.DATABASE_CONNECTED



local function dbConnected()
    --[[
	if NetLogger.db then
        if NetLogger.db:status() == CONNECTED then
            return true 
        else
            return false
        end
    else
        return false
    end
	]]
	return true
end

local function dbConnecting()
	--[[
    if NetLogger.db then
        if NetLogger.db:status() == CONNECTING then
            return true 
        else
            return false
        end
    else
        return false
    end
	]]
	return false
end

function NetLogger.Connect()
	NetLogger.db = rp._Stats
	
	NetLogger.db:Query("CREATE TABLE IF NOT EXISTS net_logger ( net VARCHAR(255) UNIQUE PRIMARY KEY, runs INT(255), maxlen FLOAT(255, 2), midlen FLOAT(255, 2) ); ", function()
		NetLogger.db:Query("SELECT * FROM net_logger;", function(data)
            if data then
                if not NetLogger.Data then 
					NetLogger.Data = {} 
				end
				
                for k,tbl in pairs(data) do
                    NetLogger.Data[tbl.net] = {
						runs=tbl.runs,
						maxlen=tbl.maxlen,
						midlen=tbl.midlen
					}
                end
            end
		end)
	end)
	
    --[[
	if dbConnecting() then printN("Подключение к MySQL уже происходит") return end
    NetLogger.db = mysqloo.connect(NetLogger.MySQL.address, NetLogger.MySQL.user, NetLogger.MySQL.password, NetLogger.MySQL.db, NetLogger.MySQL.port)
    NetLogger.db.onConnected = function(q, data)
        printN("SQL подключен")
        local qe = NetLogger.db:query("CREATE TABLE IF NOT EXISTS net_logger ( net VARCHAR(255) UNIQUE PRIMARY KEY, runs INT(255), maxlen FLOAT(255, 2), midlen FLOAT(255, 2) ); ")
        qe.onSuccess = function(q,data)
            printN("Таблица успешно создана/загружена")
            local getqe = NetLogger.db:query("SELECT * FROM net_logger;")
            getqe.onSuccess = function(q,data)
                if data then
                    if not NetLogger.Data then 
						NetLogger.Data = {} 
					end
                    for k,tbl in pairs(data) do
                        NetLogger.Data[tbl.net] = {runs=tbl.runs,maxlen=tbl.maxlen,midlen=tbl.midlen}
                    end
                end
                printN("Данные подгружены")
            end
            getqe.onError = function(q,data) 
				printN("Ошибка задгрузки данных: " .. tostring(data)) 
			end
            getqe:start()
        end
        qe.onError = function(q,data) 
			printN("Ошибка при создании таблицы: " .. tostring(data)) 
		end
        qe:start()
    end
    NetLogger.db.onConnectionFailed = function(q, data) 
		printN("Ошибка при подключение SQL Базы: " .. tostring(data)) 
	end
	
    NetLogger.db:connect()
	]]
end



function NetLogger.Save()
    --if not dbConnected() then printN("Ошибка при сохранении: База данных не подлючена") return end
    if NetLogger.NeedSave then
        for name,_ in pairs(NetLogger.NeedSave) do
            local data = NetLogger.Data[name]
            if data then
                --local qe = NetLogger.db:query("INSERT INTO net_logger (net, runs, maxlen, midlen) VALUES ('" .. name .. "', " .. data.runs .. ", " .. data.maxlen .. ", " .. data.midlen .. ") ON DUPLICATE KEY UPDATE runs=" .. data.runs .. ", maxlen = " .. data.maxlen .. ", midlen=" .. data.midlen)
                --qe.onError = function(q,data) printN("Ошибка при сохранение (" .. name .. "): " .. tostring(data)) end
                --qe:start()
				
				NetLogger.db:Query("INSERT INTO net_logger (net, runs, maxlen, midlen) VALUES ('" .. name .. "', " .. data.runs .. ", " .. data.maxlen .. ", " .. data.midlen .. ") ON DUPLICATE KEY UPDATE runs=" .. data.runs .. ", maxlen = " .. data.maxlen .. ", midlen=" .. data.midlen)
            end
        end
        printN("База данных сохранена")
        NetLogger.NeedSave = {}
    end
end



function NetLogger.ClearTable()
    
    NetLogger.Data = {}
    printN("Таблица очищена")
    if NetLogger.MySQLActive then
        if not dbConnected() then printN("Ошибка при очистке: База данных не подлючена") return end
        if NetLogger.MySQLActive and dbConnected() then
            --[[
			local qe = NetLogger.db:query("DELETE FROM net_logger;")
            qe.onSuccess = function(q,data) printN("База данных очищена") end
            qe.onError = function(q,data) 
                printN("Ошибка при очистке данных: " .. tostring(data))
            end
            qe:start()
			]]
			NetLogger.db:Query("DELETE FROM net_logger;")
        end
    end
end






function NetLogger.SetStatus(status)
    if status then
        if NetLogger.netRealoaded then printN("Логирование уже включено!") return end
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
        end
        printN("Логирование включено")
    else
        if not NetLogger.netRealoaded then printN("Логирование уже выключено!") return end
        if NetLogger.netRealoaded then
            net.Incoming = _net_Incoming
            NetLogger.netRealoaded = false
        end
        printN("Логирование выключено")
    end
end

function NetLogger.UseMySQL(status)
    if status then
        cookie.Set("net_logget_mysql","true")
        if dbConnecting() then printN("Ожидайте, сейчас происходит подключение к базе данных!") return end
        if not dbConnected() then NetLogger.Connect() printN("Попытка подключения к MySQL (Ожидайте)") end
        if NetLogger.MySQLActive and dbConnected() then printN("Уже включенно использование MySQL!") return end
        NetLogger.MySQLActive = true
        timer.Create("net_logger_mysqlsave",60,0,NetLogger.Save)
        printN("Использование MySQL включено")
    else
        cookie.Set("net_logget_mysql","false")
        if not NetLogger.MySQLActive then printN("Уже выключенно использование MySQL") return end
        NetLogger.MySQLActive = false
        --if dbConnected() or dbConnecting() then NetLogger.db:disconnect() end
        timer.Remove("net_logger_mysqlsave")
        printN("Использование MySQL выключено")
    end
end

function NetLogger.SetAutoRun(status)
    if status then
        cookie.Set("net_logget_autorun","true")
        if NetLogger.AutoRun then printN("АвтоВключение уже включено!") return end
        NetLogger.AutoRun = true
        printN("АвтоВключение включено")
    else
        cookie.Set("net_logget_autorun","false")
        if not NetLogger.AutoRun then printN("АвтоВключение уже выключено!") return end
        NetLogger.AutoRun = false
        printN("АвтоВключение выключено")
    end
end

net.Receive("NetLogger.GetData",function(len,ply)
    if not NetLogger.HasAccess(ply) then return end
    net.Start("NetLogger.GetData")
        net.WriteTable(NetLogger.Data)
    net.Send(ply)
end)


net.Receive("NetLogger.Clear",function(len,ply)
    if not NetLogger.HasAccess(ply) then return end
    NetLogger.ClearTable()
end)

net.Receive("NetLogger.SetStatus", function(len,ply)
    if not NetLogger.HasAccess(ply) then return end
    local status = net.ReadBool()
    NetLogger.SetStatus(status)

end)

net.Receive("NetLogger.UseMySQL", function(len,ply)
    if not NetLogger.HasAccess(ply) then return end
    local status = net.ReadBool()
    NetLogger.UseMySQL(status)
end)




net.Receive("NetLogger.GetInfo",function(len,ply)
    if not NetLogger.HasAccess(ply) then return end
    local tbl = {MySQL=NetLogger.MySQLActive,AutoRun=cookie.GetString("net_logget_autorun", "false"),Active=NetLogger.netRealoaded}
    net.Start("NetLogger.GetInfo")
        net.WriteTable(tbl)
    net.Send(ply)
end)

net.Receive("NetLogger.SetAutoRun",function(len,ply)
    if not NetLogger.HasAccess(ply) then return end
    local status = net.ReadBool()
    NetLogger.SetAutoRun(status)
end)


---------------------------------- AutoRun ---------------
if cookie.GetString("net_logget_autorun", "false") == "true" then
    NetLogger.SetStatus(true)
    if cookie.GetString("net_logget_mysql", "false") == "true" then NetLogger.UseMySQL(true) end
end