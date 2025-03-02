-- "gamemodes\\rp_base\\gamemode\\addons\\utf8_sh.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local UTF8 = {};

local string_byte = string.byte;
local string_find = string.find;
local string_char = string.char;
local string_sub = string.sub;

local utf8_len = utf8.len;
local utf8_codepoint = utf8.codepoint;
local utf8_force = utf8.force;
local utf8_char = utf8.char;

function UTF8.SBytes(String, Position)
    Position = Position or 1;
    if (type(Position) != 'number' or type(String) != 'string') then
        return 1
    end
    local Char = string_byte(String, Position);
    local Case = {
        {
            Filter = function(Char) 
                return (Char > 0) and (Char <= 127)
            end
        },
        {
            Filter = function(Char)
                return (Char >= 194) and (Char <= 223)
            end
        },
        {
            Filter = function(Char) 
                return (Char >= 224) and (Char <= 239)
            end
        },
        {
            Filter = function(Char) 
                return (Char >= 240) and (Char <= 244)
            end
        }
    };
    for I, Data in pairs(Case) do
        if (Data.Filter(Char)) then
            return I
        end
    end
end

----------------------------------------------------

function UTF8.Upper(String)
    if (type(String) != 'string') then return String end

    local Data = {
        Position = 1,
        Bytes = #String,
        CharByte = 1,
        UpperString = ''
    };

    local Char, CodePoint;
    while (Data.Position <= Data.Bytes) do
        Data.CharByte = UTF8.SBytes(String, Data.Position);
        Char = string_sub(String, Data.Position, Data.Position + Data.CharByte - 1);
        CodePoint = utf8_codepoint(Char, 1);
        if (CodePoint >= 1072 and CodePoint <= 1103) or (CodePoint >= 93 and CodePoint <= 122) then
            Char = utf8_char(CodePoint - 32);
        end
        Data.UpperString = Data.UpperString .. Char;
        Data.Position = Data.Position + Data.CharByte;
    end

    return Data.UpperString
end

----------------------------------------------------

function UTF8.Lower(String)
    if (type(String) != 'string') then return String end

    local Data = {
        Position = 1,
        Bytes = #String,
        CharByte = 1,
        LowerString = ''
    };

    local Char, CodePoint;
    while (Data.Position <= Data.Bytes) do
        Data.CharByte = UTF8.SBytes(String, Data.Position);
		
		if not Data.CharByte then 
			break 
		end
		
        Char = string_sub(String, Data.Position, Data.Position + Data.CharByte - 1);
        local result, CodePoint = pcall(utf8_codepoint, Char, 1);
		
		if not result or not CodePoint then
			break
		end
		
        if (CodePoint >= 1040 and CodePoint <= 1071) or (CodePoint >= 65 and CodePoint <= 90) then
            Char = utf8_char(CodePoint + 32);
        end
		
        Data.LowerString = Data.LowerString .. Char;
        Data.Position = Data.Position + Data.CharByte;
    end

    return Data.LowerString
end

----------------------------------------------------

function UTF8.Substring(String, StartPos, EndPos)
    EndPos = EndPos or #String;

    local Data = {
        Position = 1,
        Bytes = #String,
        Length = 0,
        LLength = (StartPos >= 0 and EndPos >= 0) or utf8_len(String)
    };

    local FirstChar = (StartPos >= 0) and StartPos or Data.LLength + StartPos + 1;
    local LastChar = (EndPos >= 0) and EndPos or Data.LLength + EndPos + 1;
    
    local FirstByte = 1;
    local LastByte = Data.Bytes;

    if (FirstChar > LastChar) then return '' end

    while (Data.Position <= Data.Bytes) do
        Data.Length = Data.Length + 1;

        if (Data.Length == FirstChar) then
            FirstByte = Data.Position;
        end

        Data.Position = Data.Position + UTF8.SBytes(String, Data.Position);

        if (Data.Length == LastChar) then
            LastByte = Data.Position - 1;
            break
        end
    end

    if (FirstChar > Data.Length) then FirstByte = Data.Bytes + 1; end
    if (LastChar < 1) then LastByte = 0; end

    return string_sub(String, FirstByte, LastByte)
end

----------------------------------------------------

function UTF8.Reverse(String)
    if (type(String) != 'string') then return String end

    local Data = {
        CharByte = 1,
        ReversedString = ''
    };

    local Bytes = #String;
    local Position = Bytes;

    local Char;
    while (Position > 0) do
        Char = string_byte(String, Position);
        while (Char >= 128 and Char <= 191) do
            Position = Position - 1;
            Char = string_byte(String, Position);
        end
        Data.CharByte = UTF8.SBytes(String, Position);
        Data.ReversedString = Data.ReversedString .. string_sub(String, Position, Position + Data.CharByte - 1);
        Position = Position - 1;
    end

    return Data.ReversedString;
end

----------------------------------------------------

function UTF8.Left(String, Length)
    if (type(String) != 'string' or type(Length) != 'number') then return String end
    return UTF8.Substring(String, 1, Length)
end

----------------------------------------------------

function UTF8.Right(String, Length)
    if (type(String) != 'string' or type(Length) != 'number') then return String end
    return UTF8.Substring(String, -Length)
end

----------------------------------------------------

function UTF8.StartWith(String, Start)
    if (type(String) != 'string' or type(Start) != 'string') then return false end
    return UTF8.Substring(String, 1, utf8_len(Start)) == Start
end

----------------------------------------------------

function UTF8.EndsWith(String, End)
    if (type(String) != 'string' or type(End) != 'string') then return false end
    return End == '' or UTF8.Substring(String, -utf8_len(End)) == End
end

----------------------------------------------------

function UTF8.Find(String, Substring, StartPos, NoPatterns)
    if (type(String) != 'string' or type(Substring) != 'string') then return nil end

    NoPatterns = NoPatterns or false;
    StartPos = StartPos or 1;
    local Length = utf8_len(utf8_force(String))
    local First, Last, Match = string_find(String, Substring, StartPos, NoPatterns);
    
    if (First or Last) then
        Last = utf8_len(string_sub(String, 1, Last));
        First = Last - utf8_len(Substring) + 1;
        if (First < 1) then First = 1; end
    end

    return First, Last, Match
end

----------------------------------------------------

utf8.upper = UTF8.Upper;
utf8.lower = UTF8.Lower;
utf8.sub = UTF8.Substring;
utf8.reverse = UTF8.Reverse;
utf8.left = UTF8.Left;
utf8.right = UTF8.Right;
utf8.find = UTF8.Find;
utf8.StartWith = UTF8.StartWith;
utf8.EndsWith = UTF8.EndsWith;

local utf8_len = utf8.len
function string.isutf8(s)
    return #s > (utf8_len(s) or 0)
end

function string.utfnotutflower(s)
    if string.isutf8(s) then
        return utf8.lower(s)
    else
        return s:lower()
    end
end

string.forcelower = string.utfnotutflower