concommand.Add("cl_cwbase_leakcheck", function(ply)
    if IsValid(ply) and not ply:IsRoot() then return end

    local models_tab, sweps_tab, owners_tab, all_amount = {}, {}, {}, 0
    local owner_swep_count, granade_cnt = {}, {}

    for _, ent in pairs(ents.FindByClass("class C_BaseFlex")) do
        all_amount = all_amount + 1
        local mdl = ent:GetModel()

        models_tab[mdl] = (models_tab[mdl] or 0) + 1

        local swep = ent.wepParent
        if not IsValid(swep) then continue end
        local class = swep:GetClass()

        sweps_tab[class] = (sweps_tab[class] or 0) + 1

        local owner = swep.Owner
        if not IsValid(owner) then continue end
        local owner_name = owner:Nick()

        owners_tab[owner_name] = (owners_tab[owner_name] or 0) + 1

        owner_swep_count[owner_name] = owner_swep_count[owner_name] or {}
        owner_swep_count[owner_name][mdl] = (owner_swep_count[owner_name][mdl] or 0) + 1

        if mdl == "models/weapons/v_cw_fraggrenade.mdl" then
            granade_cnt[owner_name] = (granade_cnt[owner_name] or 0) + 1
        end
        --if not IsValid(ent) then SafeRemoveEntity(ent) return end
        --print(ent:GetNoDraw(), "|", ent:GetModel(), (IsValid(ent.wepParent) and ent.wepParent.Owner or "not valid .wepParent"), IsValid(ent.wepParent) and ent.wepParent:GetClass() or "not valid .wepParent")
    end

    print("Таблица моделей:")
    PrintTable(models_tab)
    print(table.Count(models_tab) .. " типов моделей")
    print("общее количество моделей: " .. all_amount)
    print("——————————————————————————————————————")
    print("Таблица классов:")
    PrintTable(sweps_tab)
    print("——————————————————————————————————————")
    print("Таблица владельцев:")
    PrintTable(owners_tab)
    print("——————————————————————————————————————")
    print("Свепы по количеству, у каждого игрока:")
    PrintTable(owner_swep_count)
    print("——————————————————————————————————————")
    print("v_cw_fraggrenade:") -- В Atow какого то хрена появляються по одной/две гранаты, когда спавнишь любое CW Atow оружие.
    PrintTable(granade_cnt)
end)