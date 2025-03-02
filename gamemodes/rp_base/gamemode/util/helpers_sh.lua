-- "gamemodes\\rp_base\\gamemode\\util\\helpers_sh.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
-- Интервальная итерация таблиц.
-- Позволяет сэкономить на циклах при помощи распределения нагрузки на временной промежуток.
-- Актуально в местах где не требуется мгновенный результат.

local lnum = 0

function IntervalLoop(time, tab, callback, notsequential)
    lnum = lnum + 1
    if notsequential then -- table.IsSequential это клёво, но хардкодинг не требует лишних циклов.
        timer.Create("IntervalLoop"..lnum, time, table.Count(tab), function()
            local k, v = next(tab)
            callback(v, k)
            tab[k] = nil
        end)
    else
        local i = 0
        timer.Create("IntervalLoop"..lnum, time, #tab, function()
            i = i + 1
            callback(tab[i], i)
        end)
    end
    
    return {
        Stop = function()
            timer.Remove("IntervalLoop"..lnum)
        end
    }
end

-- полезная функция для net.WriteUint (например можно считать кол-во битов для таблицы професии что-бы отсылать нэт в пределах нужных битов)

function math.BitCount(num)
    if num == 0 then
        return 0
    end
    
    return math.floor( math.log(num, 2) ) + 1
end

-- что-то вроде new функции в js.

function New(self, tab)
    tab = tab or {}

    setmetatable(tab, self)
    self.__index = self

    if self.constructor then
        self.constructor(tab)
    end

    return tab
end

--Конвертация hex цветов в rgb
--#754fd6 > Color(117, 79, 214)

function ColorFromHex(hex, alpha)
    hex = hex:gsub("#", "")
    return Color(tonumber("0x".. hex:sub(1, 2)), tonumber("0x".. hex:sub(3, 4)), tonumber("0x".. hex:sub(5, 6)), alpha or 255)
end

-- фильтрация таблиц

function table.filter(table, handle)
    for k, v in pairs(table) do
        if not handle(v, k) then
            table[k] = nil
        end
    end

    return table
end

-- в основном для конфигов (что-бы конвертить более понятную в настройке - последовательную таблицу в ассоциативную)

function table.ToAssoc(t)
    local out = {}
    for _, v in pairs(t) do out[v] = true end
    return out
end

-- Конкатенация ассоц таблиц

function table.concatKeys(tbl, concatenator, startPos, endPos)
    return table.concat(table.GetKeys(tbl), concatenator, startPos, endPos)
end

-- для отладки скриптов

local red, white = Color(255, 0, 0), Color(255, 255, 255)

function debug.print(script, msg)
    MsgC(red, "[Debug: ".. script .."] ", white, msg, "\n")
end

-- sv_allowcslua = 0

if SERVER then
    concommand.Add("runstring", function(ply, cmd, args, code)
        if ply:IsDeveloper() == false then return end

        ply:ChatPrint("executing...")
        ply:SendLua(code)
    end, nil, nil, FCVAR_UNREGISTERED)
else
    concommand.Add("include", function(ply, cmd, args, path)
        if ply:IsDeveloper() == false then return end

        print("including...")
        include(path)
    end, nil, nil, FCVAR_UNREGISTERED)
end