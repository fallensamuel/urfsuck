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

local var_cahce = {}
var_cahce["pairs"] = pairs
var_cahce["ents.FindByClass"] = ents.FindByClass
var_cahce["table.Count"] = table.Count
var_cahce["MsgC"] = MsgC
var_cahce["IsValid"] = IsValid
var_cahce["ents.GetAll"] = ents.GetAll
var_cahce["table.insert"] = table.insert
var_cahce["table.sort"] = table.sort

local getCsEnts = function()
    local output = {}

    for _, class in var_cahce["pairs"](csents_classes) do
        output[class] = var_cahce["ents.FindByClass"](class)
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
    if var_cahce["IsValid"](ply) and not ply:IsRoot() then return end

    local _ents = getCsEnts()
    local ents_cnt = 0
    local count_by_class = {}

    for class, entitys in var_cahce["pairs"](_ents) do
        local cnt = var_cahce["table.Count"](entitys)

        ents_cnt = ents_cnt + cnt
        count_by_class[class] = cnt
    end

    var_cahce["MsgC"](colrs.red, "Анализ клиент сайд энтити: \n")
    var_cahce["MsgC"](colrs.red2, "————————————————————————————— \n")
    var_cahce["MsgC"](colrs.white, "Список классов движковых клиент сайд энтити: \n")
     var_cahce["MsgC"](colrs.white_d, table.concat(csents_classes), "\n")
    var_cahce["MsgC"](colrs.red2, "————————————————————————————— \n")
    var_cahce["MsgC"](colrs.white_d, "Общее количество клиент сайд энтити: ", colrs.white, ents_cnt.." шт. \n")
    var_cahce["MsgC"](colrs.red2, "————————————————————————————— \n")
    var_cahce["MsgC"](colrs.white, "Количество клиент сайд по классам: \n")
    for class, cnt in var_cahce["pairs"](count_by_class) do
        var_cahce["MsgC"](colrs.white_d, class..": ", colrs.white, cnt.." шт. \n")
    end
    for class, entitys in var_cahce["pairs"](_ents) do
        if var_cahce["table.Count"](entitys) <= 0 then continue end
        var_cahce["MsgC"](colrs.red2, "————————————————————————————— \n")
        var_cahce["MsgC"](colrs.white, "Список моделей клиент сайд энтити с классом "..class..": \n")

        local _classes_ = {}

        for _, ent in var_cahce["pairs"](entitys) do
            if var_cahce["IsValid"](ent) then
                _classes_[ent:GetModel()] = _classes_[ent:GetModel()] and _classes_[ent:GetModel()] + 1 or 1
            end
        end

        for mdl, count in var_cahce["pairs"](_classes_) do
            var_cahce["MsgC"](colrs.white_d, mdl..": ", colrs.white, count.." шт. \n")
        end
    end
end)

concommand.Add("analyze_sv_ents", function(ply)
    if var_cahce["IsValid"](ply) and not ply:IsRoot() then return end

    local _ents = {}

    for _, ent in var_cahce["pairs"](var_cahce["ents.GetAll"]()) do
        local class = ent:GetClass()
        _ents[class] = _ents[class] or {}
        var_cahce["table.insert"](_ents[class], ent)
    end

    local ents_cnt = 0

    local count_by_class, count_by_mdl = {}, {}
    local cntbymdl = {}
    for class, entitys in var_cahce["pairs"](_ents) do
        if csents_classes__[class] then
            _ents[class] = nil
        else
            count_by_class[class] = var_cahce["table.Count"](entitys)

            for i, _v in var_cahce["pairs"](entitys) do
                if not var_cahce["IsValid"](_v) then continue end
                local mdl = _v:GetModel()
                if not mdl or mdl == "" then continue end
                if count_by_mdl[mdl] then
                    cntbymdl[count_by_mdl[mdl]].count = cntbymdl[count_by_mdl[mdl]].count + 1
                else
                    count_by_mdl[mdl] = var_cahce["table.insert"](cntbymdl, {["mdl"] = mdl, ["count"] = 1})
                end
            end
        end
    end
    local cntbyclass = {}
    for class, entitys in var_cahce["pairs"](_ents) do
        local cnt = var_cahce["table.Count"](entitys)
        
        var_cahce["table.insert"](cntbyclass, {
            ["class"] = class,
            ["count"] = cnt
        })

        ents_cnt = ents_cnt + cnt
    end
    var_cahce["table.sort"](cntbyclass, function(a, b) return a["count"] > b["count"] end)
    var_cahce["table.sort"](cntbymdl, function(a, b) return a["count"] > b["count"] end)

    local ents_classes_cnt = var_cahce["table.Count"](_ents)

    var_cahce["MsgC"](colrs.red, "Анализ сервер сайд энтити: \n")
    var_cahce["MsgC"](colrs.red2, "————————————————————————————— \n")
    var_cahce["MsgC"](colrs.white_d, "Общее количество классов сервер сайд энтити: ", colrs.white, ents_classes_cnt.." шт. \n")
    var_cahce["MsgC"](colrs.white_d, "Общее количество сервер сайд энтити: ", colrs.white, ents_cnt.." шт. \n")

    var_cahce["MsgC"](colrs.white, "Количество сервер сайд энтити по классам: \n")
    local i = 1
    for i, tab in var_cahce["pairs"](cntbyclass) do
        var_cahce["MsgC"](colrs.white_d, i..". "..tab.class..": ", colrs.white, tab.count.." шт. \n")
        i = i + 1
    end

    var_cahce["MsgC"](colrs.white, "Количество сервер сайд энтити по моделям: \n")
    local i = 1
    for i, tab in var_cahce["pairs"](cntbymdl) do
        var_cahce["MsgC"](colrs.white_d, i..". "..tab.mdl..": ", colrs.white, tab.count.." шт. \n")
        i = i + 1
    end
end)