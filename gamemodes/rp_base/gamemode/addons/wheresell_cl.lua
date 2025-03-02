rp.WhereSellHighlight = rp.WhereSellHighlight or {};
rp.WhatWeSell = rp.WhatWeSell;

local Enabled = Enabled or false;
local Highlighted = rp.WhereSellHighlight;

local tinsert, tempty = table.insert, table.Empty;
local AddHalo, tkeys = halo.Add, table.GetKeys;
local NPC;

local TimerID = 'WhereICanSellIt.Timer';
local tcreate, tremove = timer.Create, timer.Remove;

function rp.WhereICanSellThis(UniqueID)
    rp.IFoundWhereICanSell();
    for k, v in pairs(ents.FindByClass('vendor_npc') or {}) do
        for j, u in pairs(rp.VendorsNPCsWhatSells[UniqueID] or {}) do
            if (v:GetPos() == rp.VendorsNPCs[u].pos) then
                if (!IsValid(v)) then continue end
                Highlighted[v] = true;
            end
        end
    end

    rp.WhatWeSell = UniqueID;
    Enabled = true;

    tremove(TimerID);
    tcreate(TimerID, 300, 1, rp.IFoundWhereICanSell);
end

function rp.IFoundWhereICanSell()
    tempty(Highlighted);
    Enabled = false;
end

hook.Add('PreDrawHalos', 'NPCSellHalos', function()
    if (Enabled) then
        AddHalo(tkeys(Highlighted), Color(153, 255, 153), 3, 3, 1, true, true);
    end
end);