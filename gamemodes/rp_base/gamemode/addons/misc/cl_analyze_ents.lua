-- "gamemodes\\rp_base\\gamemode\\addons\\misc\\cl_analyze_ents.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local csents_classes = {
    "class C_PhysPropClientside",
    "class C_BaseFlex",
    "class C_SceneEntity",
    "class C_ClientRagdoll"
}

local csents_classes__ = {}
for k, v in pairs(csents_classes) do
    csents_classes__[v] = true
end

local getCsEnts = function()
    local output = {}

    for _, class in pairs(csents_classes) do
        output[class] = ents.FindByClass(class)
    end

    return output
end

local colrs = {
    red = Color(200, 35, 35),
    red2 = Color(175, 25, 25),
    white = Color(255, 255, 255),
    white_d = Color(175, 175, 175)
}

concommand.Add("analyze_cl_ents", function(ply)
    if ply:IsRoot() == false then return end

    local _ents = getCsEnts()
    local ents_cnt = 0
    local count_by_class = {}

    for class, entitys in pairs(_ents) do
        local cnt = table.Count(entitys)

        ents_cnt = ents_cnt + cnt
        count_by_class[class] = cnt
    end

    MsgC(colrs.red, "Анализ клиент сайд энтити: \n")
    MsgC(colrs.red2, "————————————————————————————— \n")
    MsgC(colrs.white, "Список классов движковых клиент сайд энтити: \n")
    MsgC(colrs.white_d, table.concat(csents_classes), "\n")
    MsgC(colrs.red2, "————————————————————————————— \n")
    MsgC(colrs.white_d, "Общее количество клиент сайд энтити: ", colrs.white, ents_cnt.." шт. \n")
    MsgC(colrs.red2, "————————————————————————————— \n")
    MsgC(colrs.white, "Количество клиент сайд по классам: \n")
    for class, cnt in pairs(count_by_class) do
        MsgC(" ", colrs.white_d, class..": ", colrs.white, cnt.." шт. \n")
    end

    for class, entitys in pairs(_ents) do
        if table.Count(entitys) <= 0 then continue end
        MsgC(colrs.red2, "————————————————————————————— \n")
        MsgC(colrs.white, "Список моделей клиент сайд энтити с классом "..class..": \n")

        local _classes_ = {}

        for _, ent in pairs(entitys) do
            if IsValid(ent) then
                _classes_[ent:GetModel() or "uknown_model_"..ent:GetClass()] = (_classes_[ent:GetModel() or "uknown_model_"..ent:GetClass()] or 0) + 1
            end
        end

        for mdl, count in pairs(_classes_) do
            MsgC(" ", colrs.white_d, mdl..": ", colrs.white, count.." шт. \n")
        end
    end
end)

net.Receive("urf.im/analyze/ents_sv", function()
    local report = net.ReadTable()

    MsgC(colrs.red, "Анализ сервер сайд энтити: \n")
    MsgC(colrs.red2, "————————————————————————————— \n")
    MsgC(colrs.white_d, "Общее количество классов: ", colrs.white, report.classes_count .." шт. \n")
    MsgC(colrs.white_d, "Общее количество энтити: ", colrs.white, report.all_count .." шт. \n")
    MsgC(colrs.red2, "————————————————————————————— \n")

    MsgC(colrs.white, "Количество энтити по классам: \n")
    local i = 1
    for i, tab in pairs(report.count_by_class) do
        MsgC(" ", colrs.white_d, i..". "..tab.class..": ", colrs.white, tab.count.." шт. \n")
        i = i + 1
    end

    MsgC(colrs.red2, "————————————————————————————— \n")
    MsgC(colrs.white, "Количество энтити по моделям: \n")
    local i = 1
    for i, tab in pairs(report.count_by_model) do
        MsgC(" ", colrs.white_d, i ..". ".. tab.mdl ..": ", colrs.white, tab.count.." шт. \n")
        i = i + 1
    end
end)
