local Tr = {collisiongroup = COLLISION_GROUP_WORLD};
local TrLn = util.TraceLine;
local InWorld = function(Pos)
    Tr.start = Pos;
    Tr.endpos = Pos;
    return TrLn(Tr).HitWorld
end

local Insert = table.insert;
local Hull = util.TraceHull;

local Map, Pos, StrPos, Desc;
local Conflicts, Inside, Trace = 0;

local function ObjectsInside(Pos, Height, Rad)
    Trace = Hull({
        start = Pos + Vector(0, 0, .5),
        endpos = Pos + Vector(0, 0, Height),
        mins = Vector(-Rad, -Rad, 0),
        maxs = Vector(Rad, Rad, 0),
        mask = MASK_PLAYERSOLID
    });
    return Trace.Hit or false
end

local function Check(Pos, Name)
    if (!isvector(Pos)) then return end
    Inside = ObjectsInside(Pos, 8, 8);
    if (!InWorld(Pos) or Inside) then
        Desc = (!InWorld(Pos) and 'Out of map') or 'Obstacle detected';
        StrPos = 'Vector(' .. Pos.x .. ', ' .. Pos.y .. ', ' .. Pos.z .. ')';
        print('[Position Conflict] Pos: ' .. StrPos .. ' Where: ' .. Name .. ' Desc: ' .. Desc);
        Conflicts = Conflicts + 1;
    end
end

local function CheckPositions()
    Map = game.GetMap();
    timer.Simple(1, function()
        print('[PositionDebugger] Verification of all positions...');

        for ID, Pos in pairs(rp.cfg.SpawnPos[Map]) do
            Check(Pos, 'rp.cfg.SpawnPos');
        end

        for Num, Row in pairs(rp.cfg.SpawnPoints) do
            for ID, Pos in pairs(Row['Spawns']) do
                Check(Pos, 'rp.cfg.SpawnPoints');
            end
        end

        for JobID, Positions in pairs(rp.cfg.TeamSpawns[Map]) do
            for ID, Pos in pairs(Positions) do
                Check(Pos, 'Job <' .. rp.teams[JobID].name .. '>');
            end
        end

        print('[PositionDebugger] ' .. ((Conflicts == 0) and 'No position conflicts found.' or (Conflicts .. ' conflicting positions found!')));
        Checked = nil;
    end);
end

concommand.Add('check_spawns', function(Player)
    if (IsValid(Player) and Player:HasFlag('x')) then
        CheckPositions();
    end
end);