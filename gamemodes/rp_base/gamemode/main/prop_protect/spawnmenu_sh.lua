if rp.cfg.DisableQEntities then return end

local Split = string.Split
local Right = string.Right
local Sub = string.sub

rp.QObjects = rp.QObjects or {}
rp.QAmmo = rp.QAmmo or {}

rp.RegisterCustomPlayTime('QEntities')

function rp.AddQEntity(Data)
    if (!Data.ent) then return end

    local data = {
        time = Data.time or 0,
        limit = Data.limit or rp.cfg.LocalObjectLimit,
        worldlimit = Data.worldlimit or rp.cfg.WorldObjectLimit,
        name = Data.name,
        is_item = Data.is_item,
        on_spawn = Data.on_spawn,
        is_npc = Data.is_npc,
        no_freeze = Data.no_freeze,
        also_check = Data.also_check,
        model = Data.model,
        category = Data.category,
        price = Data.price,
        ListIcon = Data.ListIcon,
        access = Data.Access,
        icoMinusScale = Data.icoMinusScale,
    }
    if data.ListIcon then
        data.model = nil
    end
    rp.QObjects[Data.ent] = data
    return data
end

function rp.AddQCategory() end

function rp.AddQChair(class, Data)
    Data = Data or {}
    Data.ent = class
    Data.ListIcon = Data.ListIcon
    Data.on_spawn = function(ent)
        ent.IsQMenuChair = true
    end
	
    return rp.AddQEntity(Data)
end

function rp.AddQAmmo(class, Data)
    local data = {
        category = Data.category,
        name = Data.name,
        price = Data.price,
        amout = Data.amout,
        hidepopup = Data.hidepopup,
        model = Data.model,
        ListIcon = Data.ListIcon,
        access = Data.Access,
        icoMinusScale = Data.icoMinusScale
    }
    if data.ListIcon then
        data.model = nil
    end
    rp.QAmmo[class] = data
    return data
end

function rp.IsFactionAccess(ply, ...)
    if IsValid(ply) == false then return false end

    local cur = ply:GetFaction()
    for k, fac in pairs({...}) do
        if fac ~= cur then return false end
    end

    return true
end

function rp.IsJobAccess(ply, ...)
    if IsValid(ply) == false then return false end

    local cur = ply:GetJob()
    for k, job in pairs({...}) do
        if job ~= cur then return false end
    end

    return true
end