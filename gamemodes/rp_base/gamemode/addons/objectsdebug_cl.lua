-- "gamemodes\\rp_base\\gamemode\\addons\\objectsdebug_cl.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local Find = ents.FindByClass;
local Print = chat.AddText;
local GetAll = ents.GetAll;

local Red = Color(255, 0, 0);
local Green = Color(0, 255, 0);
local Blue = Color(0, 0, 255);
local Pink = Color(255, 192, 203);
local White = Color(255, 255, 255);
local DevTexture = 'models/wireframe';

local Timer = 'DebugObjects';
local Insert = table.insert;
local Simple = timer.Simple;

local Classes = {};

local Props = {
    ['prop_dynamic'] = Red,
    ['prop_physics'] = Blue,
    ['prop_physics_multiplayer'] = Pink,
};

local function Equals(Color1, Color2)
    return Color1.r == Color2.r and Color1.g == Color2.g and Color1.b == Color2.b
end

local C, M, V;
local function CallHandler(Stage, Table, ReadyData)
    if (!Stage) then 
        timer.Remove(Timer);
    else
        timer.Create(Timer, 1, 0, function()
            for id, obj in pairs(GetAll()) do
                if (!IsValid(obj)) then continue end
                C = obj:GetClass();
                V = obj:GetColor();
                if (Table[C]) then
                    if (!obj.DbgDefaultColor and !obj.DbgSettingColor) or !Equals(V, Table[C]) then
                        if (!obj.DbgDefaultColor) then
                            obj.DbgDefaultColor = V;
                            obj.DbgDefaultMaterial = obj:GetMaterial();
                            obj.DbgSettingColor = true;
                        end
                        obj:SetColor(Table[C]);
                        obj:SetMaterial(DevTexture);
                        obj.DbgSettingColor = nil;
                    end
                end
            end
        end);
    end
end

local function ChangeColor(Stage, Class, Color)
    for ID, Entity in pairs((Class != 'all' and Find(Class)) or GetAll()) do
        if (!Stage) then
            Entity:SetMaterial(Entity.DbgDefaultMaterial or Entity:GetMaterial());
            Entity:SetColor(Entity.DbgDefaultColor or White);
            Entity.DbgDefaultColor = nil;
            Entity.DbgDefaultMaterial = nil;
        else
            Entity.DbgDefaultColor = Entity:GetColor();
            Entity.DbgDefaultMaterial = Entity:GetMaterial();
            Entity.DbgSettingColor = true;
            Simple(0, function()
                Entity:SetColor(Color);
                Entity:SetMaterial(DevTexture);
                Entity.DbgSettingColor = nil;
            end);
        end
    end
end

local PropDebug = false;

concommand.Add('debug_prop', function(Ply, Cmd, Arguments)
    if (!IsValid(Ply) or !Ply:HasFlag('x')) then return end
    Classes = {};

    PropDebug = !PropDebug;

    if (!PropDebug) then timer.Remove(Timer); end

    Print(White, 'Prop Debugger: ', (PropDebug and Green or Red), (PropDebug and 'Enabled' or 'Disabled'));
    if (PropDebug) then
        Print(White, '---------- [ Colors & Props Hint ] ----------');
        for k, v in pairs(Props) do
            Print(v, '[' .. k .. ']');
        end
    end

    for k, v in pairs(Props) do
        Classes[k] = v;
        ChangeColor(PropDebug, k, v);
    end

    CallHandler(PropDebug, Classes);
end);

local EntityDebug = false;
local Class, N;

concommand.Add('debug_ent', function(Ply, Cmd, Arguments)
    if (!IsValid(Ply) or !Ply:HasFlag('x')) then return end
    Classes = {};

    EntityDebug = !EntityDebug;

    if (!EntityDebug) then timer.Remove(Timer); end

    Print(White, 'Entity Debugger: ', (EntityDebug and Green or Red), (EntityDebug and 'Enabled' or 'Disabled'));
    Arguments = (#Arguments > 0 and Arguments) or {'all'};

    if (Arguments and Arguments[1] == 'all') then
        N = 0;
        for k, v in pairs(GetAll()) do
            if (!IsValid(v)) then continue end
            Class = v:GetClass();
            if (!Classes[Class]) then
                Classes[Class] = HSVToColor(30 + 30 * N % 330, 1, 1);
                N = N + 1;
            end
        end
    end

    for k, v in pairs((EntityDebug and Arguments) or {'all'}) do
        Classes[v] = Classes[v] or HSVToColor(30 + 30 * k % 330, 1, 1);
        ChangeColor(EntityDebug, v, Classes[v]);
    end

    if (EntityDebug) then
        Print(White, '---------- [ Entity Class Selected ] ----------');
        Print(Classes[v], table.concat(Arguments, ', '));
        for k, v in pairs(Arguments) do
            Print(Classes[v], '[' .. v .. ']');
        end
    end

    CallHandler(EntityDebug, Classes, (Arguments[1] == 'all' and {'all'}));
end);