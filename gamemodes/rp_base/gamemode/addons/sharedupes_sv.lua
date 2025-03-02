--~ Duplicator Sharing & Saving System
DSS = DSS or {};

DSS.MaxSlotsPerPlayer = 50;
DSS.Cooldown = 20;

if (SERVER) then
    DSS.TempDupes = DSS.TempDupes or {};
    DSS.ActiveDupes = DSS.ActiveDupes or {};
end

if (CLIENT) then return end

--~ Emergency recovery table
function DSS.RecoveryTable()
    rp._Stats:Query('CREATE TABLE IF NOT EXISTS dupes(steamid VARCHAR(64), name VARCHAR(255), dupe TEXT, original_pos TEXT);');
    --rp._Stats:Query("ALTER TABLE dupes ADD COLUMN IF NOT EXISTS `original_pos` TEXT AFTER dupe;")
    rp._Stats:Query("ALTER TABLE dupes ADD original_pos TEXT NULL;")
end

--~ Check avaible slots
function DSS.HasAvailableSlot(Dupes)
    return #Dupes < DSS.MaxSlotsPerPlayer
end

--~ Get table of dupes
function DSS.GetDupes(Player)
    rp._Stats:Query('SELECT * FROM dupes WHERE steamid = ? LIMIT ' .. DSS.MaxSlotsPerPlayer .. ';', Player:SteamID64(), function(Result)
        if (!Result) then 
            DSS.TempDupes[Player:SteamID64()] = {}; 
        else
            DSS.TempDupes[Player:SteamID64()] = {};

            for Index, Dupe in pairs(Result) do
                if (!Dupe.name or !Dupe.dupe) then continue end
                table.insert(DSS.TempDupes[Player:SteamID64()], {Dupe.name, Dupe.dupe});
            end

            DSS.SendUpdateINFOSPECIAL(Player);
        end
    end);
end

--~ Get table for player
function DSS.GiveMeMyTableDamnIt(Player)
    return DSS.TempDupes[Player:SteamID64()] or {}
end

function DSS.SendUpdateINFOSPECIAL(Client)
    local Dupes = DSS.GiveMeMyTableDamnIt(Client);
    local Table = {};

    local T;
    for Index, Value in pairs(Dupes) do
        if (!Value[1]) then continue end
        T = string.Explode('_', Value[1]);
        if (#T < 7) then continue end
        table.insert(Table, T[1] .. '.' .. T[2] .. '.' .. T[3] .. ' ' .. T[4] .. ':' .. T[5] .. ':' .. T[6] .. '=' .. T[7]);
    end

    local Data1 = util.TableToJSON(Table);
    Data1 = util.Compress(Data1);

    net.Start('DupeInfo');
        net.WriteUInt(0, 4);
        -- Data1
        net.WriteUInt(string.len(Data1), 16);
        net.WriteData(Data1, string.len(Data1));
    net.Send(Client);
end

--~ Delete dupe
function DSS.DeleteDupe(Player, Name, After)
    if (!IsValid(Player) or !Name) then return end

    rp._Stats:Query('DELETE FROM dupes WHERE steamid = ? AND name = ?;', Player:SteamID64(), Name, function(Result)
        After(Result);
        DSS.GetDupes(Player);
        rp.Notify(Player, NOTIFY_GENERIC, rp.Term('DupeDeleted'));
    end);
end

--~ Saving dupe
function DSS.SaveDupe(Player, Name, Data, PosData, After)
    if (!IsValid(Player) or !Name or !Data) then return end

    Data.Constraints = nil;

    for Index, Key in pairs(table.GetKeys(Data.Entities)) do

        if (Data.Entities[Key].Constraints and #Data.Entities[Key].Constraints > 1) then
            for IIndex, KKey in pairs(table.GetKeys(Data.Entities[Key].Constraints)) do
                Data.Entities[Key].Constraints[tostring(KKey)] = Data.Entities[Key].Constraints[KKey];
                Data.Entities[Key].Constraints[KKey] = nil;
            end
        end

        Data.Entities[Key].PhysicsObjects['0'] = Data.Entities[Key].PhysicsObjects[0];
        Data.Entities[Key].PhysicsObjects[0] = nil;

        Data.Entities[tostring(Key)] = table.Copy(Data.Entities[Key]);
        Data.Entities[Key] = nil;
    end

    local Compressed = pon.encode(Data);
    if (!Compressed) then return end

    local CompressedPos = pon.encode(PosData)

    rp._Stats:Query('INSERT INTO dupes(steamid, name, dupe, original_pos) VALUES (?, ?, ?, ?);', Player:SteamID64(), Name, Compressed, CompressedPos, function(Result)
    --local query = 'INSERT INTO `dupes` (`steamid`, `name`, `dupe`, `original_pos`) VALUES ("'.. Player:SteamID64() ..'", "'.. Name ..'", "'.. Compressed ..'", "'.. CompressedPos ..'");'
    --file.Write("dupetests.txt", query)
    --rp._Stats:Query(query, function(Result)
        After(Result);
        DSS.GetDupes(Player);
        rp.Notify(Player, NOTIFY_GENERIC, rp.Term('DupeSaved'));
    end);
end

--~ Load dupe
function DSS.LoadDupe(Player, Name)
    if (!IsValid(Player) or !Name) then return end

    rp._Stats:Query('SELECT * FROM dupes WHERE steamid = ? AND name = ? LIMIT 1;', Player:SteamID64(), Name, function(Result)
        if (Result[1]) then
            local SID64 = Player:SteamID64();
            local Data = pon.decode(Result[1].dupe);

            for Index, Key in pairs(table.GetKeys(Data.Entities)) do
                if (Data.Entities[Key].Constraints and #Data.Entities[Key].Constraints > 1) then
                    for IIndex, KKey in pairs(table.GetKeys(Data.Entities[Key].Constraints)) do
                        Data.Entities[Key].Constraints[tonumber(KKey)] = Data.Entities[Key].Constraints[KKey];
                        Data.Entities[Key].Constraints[KKey] = nil;
                    end
                end
        
                Data.Entities[Key].PhysicsObjects[0] = Data.Entities[Key].PhysicsObjects['0'];
                Data.Entities[Key].PhysicsObjects['0'] = nil;
        
                Data.Entities[tonumber(Key)] = table.Copy(Data.Entities[Key]);
                Data.Entities[Key] = nil;
            end

            DSS.ActiveDupes[SID64] = Data;

            if (!DSS.ActiveDupes[SID64]) then return end

            Player.DupedConstruction = DSS.ActiveDupes[SID64];
            Player.DupedConstructionPos = Result[1].original_pos and #Result[1].original_pos > 0 and pon.decode(Result[1].original_pos)
            DUSendForPreview(Player, DSS.ActiveDupes[SID64], Player.DupedConstructionPos);

            rp.Notify(Player, NOTIFY_GENERIC, rp.Term('DupeLoaded'));
        end
    end);
end

--~ Share dupe
function DSS.ShareDupe(Player, Name, ToPlayer, After)
    if (!IsValid(Player) or !IsValid(ToPlayer) or !Name) then return end

    rp._Stats:Query('SELECT * FROM dupes WHERE steamid = ? AND name = ? LIMIT 1;', ToPlayer:SteamID64(), Name, function(Answer)
        if (!Answer or #Answer < 1) then
            rp.Notify(Player, NOTIFY_GENERIC, rp.Term('DupeSendTask'));
            rp._Stats:Query('INSERT INTO dupes SELECT ?, name, dupe, original_pos FROM dupes WHERE steamid = ? AND name = ?;', ToPlayer:SteamID64(), Player:SteamID64(), Name, function(Result)
                After(RRResult);
                DSS.GetDupes(Player);
                DSS.GetDupes(ToPlayer);
                rp.Notify(ToPlayer, NOTIFY_GREEN, rp.Term('GetNewDupe'), Player:Nick());
                rp.Notify(Player, NOTIFY_GREEN, rp.Term('DupeSended'), ToPlayer:Nick());
            end);
        else
            rp.Notify(Player, NOTIFY_ERROR, rp.Term('DupeExists'));
        end
    end);
end

--~ Initialize auto-recovery function
--hook.Add('Initialize', 'DSS.RecoveryMYSQL', DSS.RecoveryTable);
hook.Add('InitPostEntity', 'DSS.RecoveryMYSQL', DSS.RecoveryTable);