-- "gamemodes\\rp_base\\gamemode\\addons\\wheresell_cl.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
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
    local seller_count = 0
    rp.IFoundWhereICanSell();

    for k, v in pairs(ents.FindByClass('vendor_npc') or {}) do
        for j, u in pairs(rp.VendorsNPCsWhatSells[UniqueID] or {}) do
            if (v:GetPos() == rp.VendorsNPCs[u].pos) then
                if (!IsValid(v)) then continue end
                Highlighted[v] = true;
                seller_count = seller_count + 1
            end
        end
    end

    if seller_count < 1 then
        rp.Notify(NOTIFY_ERROR, translates.Get("Торговцы не продают данный предмет :("))
        return
    end

    rp.WhatWeSell = UniqueID;
    Enabled = true;

    tremove(TimerID);
    tcreate(TimerID, 300, 1, rp.IFoundWhereICanSell);

    rp.Notify(NOTIFY_SUCCESS, translates.Get("Торговец подсвечен на экране!"))
end

function rp.IFoundWhereICanSell()
    tempty(Highlighted);
    Enabled = false;
end

local col = Color(153, 255, 153)
hook.Add('PreDrawHalos', 'NPCSellHalos', function()
    if Enabled then
        AddHalo(tkeys(Highlighted), col, 3, 3, 1, true, true);
    end
end);