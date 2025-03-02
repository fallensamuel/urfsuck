local GetKeys = table.GetKeys
local ReadUInt = net.ReadUInt
local WriteUInt = net.WriteUInt

rp.CustomPlayTime = rp.CustomPlayTime or {}

/*
    Я не совсем уверен в крутости этой реализации, но мы
    разделяем rp.CustomPlayTime на 2 разновидности таблицы:
    SERVER -> Ключ = Порядок Ключа
    CLIENT -> Порядок Ключа = Ключ
    Экономим на передаче string-содержащей таблицы
*/

function rp.RegisterCustomPlayTime(Key)
    rp.CustomPlayTime[CLIENT and (#rp.CustomPlayTime + 1) or Key] = CLIENT and Key or (#GetKeys(rp.CustomPlayTime) + 1)
end

// Кастомные функции чтения/записи для обхода WriteTable
nw.Register 'CustomPlayTime'
	:Write(function(DataTable)
        WriteUInt(#DataTable, 8)
        for Key, Value in pairs(DataTable) do
            WriteUInt(rp.CustomPlayTime[Value.id] or 0, 8)
            WriteUInt(Value.time, 32)
        end
    end)
	:Read(function()
        local CheckSum, Key, Value = ReadUInt(8)
        local DataTable = {}
        for Iteration = 1, CheckSum do
            Key = ReadUInt(8)
            Value = ReadUInt(32)
            DataTable[(rp.CustomPlayTime or {})[Key] or '?'] = Value
        end
        return DataTable
    end)
	:SetLocalPlayer()

local PLAYER = FindMetaTable('Player')

function PLAYER:GetCustomPlayTime(Key)
    local Source = (CLIENT and self:GetNetVar('CustomPlayTime')) or self.CustomPlayTime
    if (!self:GetPlayTime() or !Source or !Source[Key]) then return 0 end
    return self:GetPlayTime() - Source[Key]
end