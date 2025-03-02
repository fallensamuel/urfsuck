-- "gamemodes\\darkrp\\gamemode\\config\\customization.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local Vector = Vector
local Angle = Angle

local function hats_cant_wear( ply )
    return not (
        ply:GetFaction() == FACTION_ZOMBIE1 or 
        ply:GetFaction() == FACTION_ZOMBIE or 
        ply:GetFaction() == FACTION_MUTANTS)
end

rp.cfg.HatsDiscountSettings = {
    interval = 24, -- часы
    count = 2
}

rp.AddBag({
    name = "Охотничий Рюкзак",
    model = "models/vex/seventysix/backpacks/backpack_01.mdl",
    price = 105 * 125,
    bag = 1,
    can_wear = hats_cant_wear,
    desc = "Расширит твой инвентарь на 5 ячеек.",
    bone = "ValveBiped.Bip01_Spine2",
    modifyClientsideModel = function(self, ply, model, pos, ang)
    local Size = Vector(1,1,1)
    local mat = Matrix()
    mat:Scale(Size)
    model:EnableMatrix('RenderMultiply', mat)
        local MAngle = Angle(-90,0,270)
        local MPos = Vector(0,-1,0)
        pos = pos + (ang:Forward() * MPos.x) + (ang:Up() * MPos.z) + (ang:Right() * MPos.y)
        ang:RotateAroundAxis(ang:Forward(), MAngle.p)
        ang:RotateAroundAxis(ang:Up(), MAngle.y)
        ang:RotateAroundAxis(ang:Right(), MAngle.r) 
        return model, pos, ang
    end
})

rp.AddBag({
    name = "Походный Рюкзак",
    model = "models/vex/seventysix/backpacks/backpack_deepcavehunter.mdl",
    price = 325 * 125,
    bag = 2,
    can_wear = hats_cant_wear,
    desc = "Расширит твой инвентарь на 10 ячеек.",
    bone = "ValveBiped.Bip01_Spine2",
    modifyClientsideModel = function(self, ply, model, pos, ang)
    local Size = Vector(1,1,1)
    local mat = Matrix()
    mat:Scale(Size)
    model:EnableMatrix('RenderMultiply', mat)
        local MAngle = Angle(-90,0,270)
        local MPos = Vector(0,-1,0)
        pos = pos + (ang:Forward() * MPos.x) + (ang:Up() * MPos.z) + (ang:Right() * MPos.y)
        ang:RotateAroundAxis(ang:Forward(), MAngle.p)
        ang:RotateAroundAxis(ang:Up(), MAngle.y)
        ang:RotateAroundAxis(ang:Right(), MAngle.r) 
        return model, pos, ang
    end
})

rp.AddBag({
    name = "Боевой Рюкзак",
    model = "models/vex/seventysix/backpacks/backpack_settler.mdl",
    price = 625 * 125,
    bag = 3,
    can_wear = hats_cant_wear,
    desc = "Расширит твой инвентарь на 15 ячеек.",
    bone = "ValveBiped.Bip01_Spine2",
    modifyClientsideModel = function(self, ply, model, pos, ang)
    local Size = Vector(1,1,1)
    local mat = Matrix()
    mat:Scale(Size)
    model:EnableMatrix('RenderMultiply', mat)
        local MAngle = Angle(-90,0,270)
        local MPos = Vector(0,-1,0)
        pos = pos + (ang:Forward() * MPos.x) + (ang:Up() * MPos.z) + (ang:Right() * MPos.y)
        ang:RotateAroundAxis(ang:Forward(), MAngle.p)
        ang:RotateAroundAxis(ang:Up(), MAngle.y)
        ang:RotateAroundAxis(ang:Right(), MAngle.r) 
        return model, pos, ang
    end
})

rp.AddBelt( {
    name = "Простой пояс для артефактов",
    model = "models/stalker/item/handhelds/datachik2.mdl",
    price = 100 * 125,
    inv_type = "artifact",
    space = 3,
    can_wear = hats_cant_wear,
    desc = "Будет куда цеплять артефакты",
    bone = "ValveBiped.Bip01_Spine2",
} )

rp.AddBelt( {
    name = "Профессиональный пояс для артефактов",
    model = "models/stalker/item/handhelds/datachik1.mdl",
    price = 250 * 125,
    inv_type = "artifact",
    space = 4,
    can_wear = hats_cant_wear,
    desc = "Будет куда цеплять артефакты",
    bone = "ValveBiped.Bip01_Spine2",
} )

rp.AddBelt( {
    name = "Научный пояс для артефактов",
    model = "models/stalker/item/handhelds/decoder.mdl",
    price = 400 * 125,
    inv_type = "artifact",
    space = 5,
    can_wear = hats_cant_wear,
    desc = "Будет куда цеплять артефакты",
    bone = "ValveBiped.Bip01_Spine2",
} )

/*
rp.AddWearable({
    name = "Зеленый Шарф",
    model = "5:models/sal/acc/fix/scarf01.mdl",
    price = 65 * 125,
    slot = 2,
    can_wear = hats_cant_wear,
    bone = "ValveBiped.Bip01_Head1",
    modifyClientsideModel = function(self, ply, model, pos, ang)
    local Size = Vector(1,1,1)
    local mat = Matrix()
    mat:Scale(Size)
    model:EnableMatrix('RenderMultiply', mat)
        local MAngle = Angle(270,-3,280)
        local MPos = Vector(-25.5,6,-1.5)
        pos = pos + (ang:Forward() * MPos.x) + (ang:Up() * MPos.z) + (ang:Right() * MPos.y)
        ang:RotateAroundAxis(ang:Forward(), MAngle.p)
        ang:RotateAroundAxis(ang:Up(), MAngle.y)
        ang:RotateAroundAxis(ang:Right(), MAngle.r) 
        return model, pos, ang
    end
})

rp.AddWearable({
    name = "Белый Шарф",
    model = "models/sal/acc/fix/scarf01.mdl",
    price = 80 * 125,
    slot = 2,
    can_wear = hats_cant_wear,
    bone = "ValveBiped.Bip01_Head1",
    modifyClientsideModel = function(self, ply, model, pos, ang)
    local Size = Vector(1,1,1)
    local mat = Matrix()
    mat:Scale(Size)
    model:EnableMatrix('RenderMultiply', mat)
        local MAngle = Angle(270,-3,280)
        local MPos = Vector(-25.5,6,-1.5)
        pos = pos + (ang:Forward() * MPos.x) + (ang:Up() * MPos.z) + (ang:Right() * MPos.y)
        ang:RotateAroundAxis(ang:Forward(), MAngle.p)
        ang:RotateAroundAxis(ang:Up(), MAngle.y)
        ang:RotateAroundAxis(ang:Right(), MAngle.r) 
        return model, pos, ang
    end
})

rp.AddWearable({
    name = "Черный Шарф",
    model = "2:models/sal/acc/fix/scarf01.mdl",
    price = 80 * 125,
    slot = 2,
    can_wear = hats_cant_wear,
    bone = "ValveBiped.Bip01_Head1",
    modifyClientsideModel = function(self, ply, model, pos, ang)
    local Size = Vector(1,1,1)
    local mat = Matrix()
    mat:Scale(Size)
    model:EnableMatrix('RenderMultiply', mat)
        local MAngle = Angle(270,-3,280)
        local MPos = Vector(-25.5,6,-1.5)
        pos = pos + (ang:Forward() * MPos.x) + (ang:Up() * MPos.z) + (ang:Right() * MPos.y)
        ang:RotateAroundAxis(ang:Forward(), MAngle.p)
        ang:RotateAroundAxis(ang:Up(), MAngle.y)
        ang:RotateAroundAxis(ang:Right(), MAngle.r) 
        return model, pos, ang
    end
})

rp.AddWearable({
    name = "Гламурный Шарф",
    model = "6:models/sal/acc/fix/scarf01.mdl",
    price = 180 * 125,
    slot = 2,
    can_wear = hats_cant_wear,
    bone = "ValveBiped.Bip01_Head1",
    modifyClientsideModel = function(self, ply, model, pos, ang)
    local Size = Vector(1,1,1)
    local mat = Matrix()
    mat:Scale(Size)
    model:EnableMatrix('RenderMultiply', mat)
        local MAngle = Angle(270,-3,280)
        local MPos = Vector(-25.5,6,-1.5)
        pos = pos + (ang:Forward() * MPos.x) + (ang:Up() * MPos.z) + (ang:Right() * MPos.y)
        ang:RotateAroundAxis(ang:Forward(), MAngle.p)
        ang:RotateAroundAxis(ang:Up(), MAngle.y)
        ang:RotateAroundAxis(ang:Right(), MAngle.r) 
        return model, pos, ang
    end
})
*/
-- Сизон Пасс Хэллуин
rp.AddHat({
    name = "Шляпа Волшебника",
    model = "models/devinity/accessories/regular_content/01_unique/07_head/01_hat/point_and_shoot_01/point_and_shoot_01.mdl",
    can_wear = hats_cant_wear,
    bone = "ValveBiped.Bip01_Head1",
    modifyClientsideModel = function(self, ply, model, pos, ang)
    local Size = Vector(0.8,0.8,0.8)
    local mat = Matrix()
    mat:Scale(Size)
    model:EnableMatrix('RenderMultiply', mat)
        local MAngle = Angle(280,0,280)
        local MPos = Vector(2.5,-0.7,0.3)
        pos = pos + (ang:Forward() * MPos.x) + (ang:Up() * MPos.z) + (ang:Right() * MPos.y)
        ang:RotateAroundAxis(ang:Forward(), MAngle.p)
        ang:RotateAroundAxis(ang:Up(), MAngle.y)
        ang:RotateAroundAxis(ang:Right(), MAngle.r) 
        return model, pos, ang
    end
})

rp.AddHat({
    name = "Призрачная Обезьяна",
    model = "models/player/items/all_class/hwn_ghost_pj.mdl",
    can_wear = hats_cant_wear,
    bone = "ValveBiped.Bip01_Head1",
    modifyClientsideModel = function(self, ply, model, pos, ang)
    local Size = Vector(0.8,0.8,0.8)
    local mat = Matrix()
    mat:Scale(Size)
    model:EnableMatrix('RenderMultiply', mat)
        local MAngle = Angle(280,0,280)
        local MPos = Vector(-5,-10,-10)
        pos = pos + (ang:Forward() * MPos.x) + (ang:Up() * MPos.z) + (ang:Right() * MPos.y)
        ang:RotateAroundAxis(ang:Forward(), MAngle.p)
        ang:RotateAroundAxis(ang:Up(), MAngle.y)
        ang:RotateAroundAxis(ang:Right(), MAngle.r) 
        return model, pos, ang
    end
})

rp.AddHat({
    name = "Голова Призрачного Всадника",
    model = "models/devinity/accessories/regular_content/01_unique/07_head/02_helmet/hhhs_head_01/hhhs_head_01.mdl",
    can_wear = hats_cant_wear,
    bone = "ValveBiped.Bip01_Head1",
    modifyClientsideModel = function(self, ply, model, pos, ang)
    local Size = Vector(0.9,0.9,0.9)
    local mat = Matrix()
    mat:Scale(Size)
    model:EnableMatrix('RenderMultiply', mat)
        local MAngle = Angle(280,0,280)
        local MPos = Vector(-67,11.5,-2)
        pos = pos + (ang:Forward() * MPos.x) + (ang:Up() * MPos.z) + (ang:Right() * MPos.y)
        ang:RotateAroundAxis(ang:Forward(), MAngle.p)
        ang:RotateAroundAxis(ang:Up(), MAngle.y)
        ang:RotateAroundAxis(ang:Right(), MAngle.r) 
        return model, pos, ang
    end
})

rp.AddHat({
    name = "Шляпа Ведьмы",
    model = "models/helmets/witch_hat.mdl",
    can_wear = hats_cant_wear,
    bone = "ValveBiped.Bip01_Head1",
    modifyClientsideModel = function(self, ply, model, pos, ang)
    local Size = Vector(1,1,1)
    local mat = Matrix()
    mat:Scale(Size)
    model:EnableMatrix('RenderMultiply', mat)
        local MAngle = Angle(280,0,280)
        local MPos = Vector(4.2,-0.7,0.3)
        pos = pos + (ang:Forward() * MPos.x) + (ang:Up() * MPos.z) + (ang:Right() * MPos.y)
        ang:RotateAroundAxis(ang:Forward(), MAngle.p)
        ang:RotateAroundAxis(ang:Up(), MAngle.y)
        ang:RotateAroundAxis(ang:Right(), MAngle.r) 
        return model, pos, ang
    end
})

-- Сизонпасс Новый Год 2022
rp.AddBag({
    name = "Сумка Плохого Парня",
    model = "models/workshop/player/coaly/pyro/xms2013_pyro_wood/xms2013_pyro_wood.mdl",
    bag = 3,
    can_wear = hats_cant_wear,
    desc = "Расширит твой инвентарь на 15 ячеек.",
    bone = "ValveBiped.Bip01_Spine2",
    modifyClientsideModel = function(self, ply, model, pos, ang)
    local Size = Vector(0.8,0.8,0.8)
    local mat = Matrix()
    mat:Scale(Size)
    model:EnableMatrix('RenderMultiply', mat)
        local MAngle = Angle(90,0,90)
        local MPos = Vector(-45,-3,0)
        pos = pos + (ang:Forward() * MPos.x) + (ang:Up() * MPos.z) + (ang:Right() * MPos.y)
        ang:RotateAroundAxis(ang:Forward(), MAngle.p)
        ang:RotateAroundAxis(ang:Up(), MAngle.y)
        ang:RotateAroundAxis(ang:Right(), MAngle.r) 
        return model, pos, ang
    end
})

rp.AddHat({
    name = "Шляпа Санты",
    model = "models/devinity/accessories/regular_content/01_unique/07_head/01_hat/the_bmoc_01/the_bmoc_01.mdl",
    can_wear = hats_cant_wear,
    bone = "ValveBiped.Bip01_Head1",
    modifyClientsideModel = function(self, ply, model, pos, ang)
    local Size = Vector(0.95,0.95,0.95)
    local mat = Matrix()
    mat:Scale(Size)
    model:EnableMatrix('RenderMultiply', mat)
        local MAngle = Angle(270,-3,280)
        local MPos = Vector(0,-0.6,0)
        pos = pos + (ang:Forward() * MPos.x) + (ang:Up() * MPos.z) + (ang:Right() * MPos.y)
        ang:RotateAroundAxis(ang:Forward(), MAngle.p)
        ang:RotateAroundAxis(ang:Up(), MAngle.y)
        ang:RotateAroundAxis(ang:Right(), MAngle.r) 
        return model, pos, ang
    end
})

rp.AddWearable({
    name = "Шарф Санты",
    model = "4:models/sal/acc/fix/scarf01.mdl",
    can_wear = hats_cant_wear,
    bone = "ValveBiped.Bip01_Head1",
    modifyClientsideModel = function(self, ply, model, pos, ang)
    local Size = Vector(1,1,1)
    local mat = Matrix()
    mat:Scale(Size)
    model:EnableMatrix('RenderMultiply', mat)
        local MAngle = Angle(270,-3,280)
        local MPos = Vector(-25.5,6,-1.5)
        pos = pos + (ang:Forward() * MPos.x) + (ang:Up() * MPos.z) + (ang:Right() * MPos.y)
        ang:RotateAroundAxis(ang:Forward(), MAngle.p)
        ang:RotateAroundAxis(ang:Up(), MAngle.y)
        ang:RotateAroundAxis(ang:Right(), MAngle.r) 
        return model, pos, ang
    end
})

rp.AddHat({
    name = "Венок Гирлянда",
    model = "models/defcon/banks/2020christmas/cosmetics/light_bando/light_bando.mdl",
    can_wear = hats_cant_wear,
    bone = "ValveBiped.Bip01_Head1",
    modifyClientsideModel = function(self, ply, model, pos, ang)
    local Size = Vector(0.46,0.46,0.46)
    local mat = Matrix()
    mat:Scale(Size)
    model:EnableMatrix('RenderMultiply', mat)
        local MAngle = Angle(90,180,260)
        local MPos = Vector(30,3.5,0.25)
        pos = pos + (ang:Forward() * MPos.x) + (ang:Up() * MPos.z) + (ang:Right() * MPos.y)
        ang:RotateAroundAxis(ang:Forward(), MAngle.p)
        ang:RotateAroundAxis(ang:Up(), MAngle.y)
        ang:RotateAroundAxis(ang:Right(), MAngle.r) 
        return model, pos, ang
    end
})

rp.AddWearable({
    name = "Плащ Санты",
    model = "models/defcon/mack/kijechristmascape/kijechristmascape.mdl",
    can_wear = hats_cant_wear,
    bone = "ValveBiped.Bip01_Spine2",
    modifyClientsideModel = function(self, ply, model, pos, ang)
    local Size = Vector(0.8,0.8,0.8)
    local mat = Matrix()
    mat:Scale(Size)
    model:EnableMatrix('RenderMultiply', mat)
        local MAngle = Angle(270,180,90)
        local MPos = Vector(-40,-2.5,0)
        pos = pos + (ang:Forward() * MPos.x) + (ang:Up() * MPos.z) + (ang:Right() * MPos.y)
        ang:RotateAroundAxis(ang:Forward(), MAngle.p)
        ang:RotateAroundAxis(ang:Up(), MAngle.y)
        ang:RotateAroundAxis(ang:Right(), MAngle.r) 
        return model, pos, ang
    end
})

rp.AddHat({
    name = "Маска Пингвина",
    model = "models/sal/penguin.mdl",
    can_wear = hats_cant_wear,
    bone = "ValveBiped.Bip01_Head1",
    modifyClientsideModel = function(self, ply, model, pos, ang)
    local Size = Vector(1,1,1)
    local mat = Matrix()
    mat:Scale(Size)
    model:EnableMatrix('RenderMultiply', mat)
        local MAngle = Angle(270,-3,280)
        local MPos = Vector(0,0,0)
        pos = pos + (ang:Forward() * MPos.x) + (ang:Up() * MPos.z) + (ang:Right() * MPos.y)
        ang:RotateAroundAxis(ang:Forward(), MAngle.p)
        ang:RotateAroundAxis(ang:Up(), MAngle.y)
        ang:RotateAroundAxis(ang:Right(), MAngle.r) 
        return model, pos, ang
    end
})

-- НГ Кейс
rp.AddHat({
    name = "Маска Пряни",
    model = "models/sal/gingerbread.mdl",
    can_wear = hats_cant_wear,
    bone = "ValveBiped.Bip01_Head1",
    modifyClientsideModel = function(self, ply, model, pos, ang)
    local Size = Vector(0.9,0.9,0.9)
    local mat = Matrix()
    mat:Scale(Size)
    model:EnableMatrix('RenderMultiply', mat)
        local MAngle = Angle(270,-3,280)
        local MPos = Vector(1,1.5,0)
        pos = pos + (ang:Forward() * MPos.x) + (ang:Up() * MPos.z) + (ang:Right() * MPos.y)
        ang:RotateAroundAxis(ang:Forward(), MAngle.p)
        ang:RotateAroundAxis(ang:Up(), MAngle.y)
        ang:RotateAroundAxis(ang:Right(), MAngle.r) 
        return model, pos, ang
    end
})

rp.AddHat({
    name = "Маска Снежного Человека",
    model = "3:models/sal/halloween/monkey.mdl",
    can_wear = hats_cant_wear,
    bone = "ValveBiped.Bip01_Head1",
    modifyClientsideModel = function(self, ply, model, pos, ang)
    local Size = Vector(1.1,1.1,1.1)
    local mat = Matrix()
    mat:Scale(Size)
    model:EnableMatrix('RenderMultiply', mat)
        local MAngle = Angle(270,-3,280)
        local MPos = Vector(0.5,0.5,0)
        pos = pos + (ang:Forward() * MPos.x) + (ang:Up() * MPos.z) + (ang:Right() * MPos.y)
        ang:RotateAroundAxis(ang:Forward(), MAngle.p)
        ang:RotateAroundAxis(ang:Up(), MAngle.y)
        ang:RotateAroundAxis(ang:Right(), MAngle.r) 
        return model, pos, ang
    end
})

-- Лето-Лето Кейс 2022
rp.AddBag({
    name = "Рюкзак URF.IM",
    model = "models/urfmodels/backpack/urfredbackpack.mdl",
    bag = 4,
    can_wear = hats_cant_wear,
    desc = "Уникальны рюкзак! Расширит твой инвентарь на 20 ячеек.",
    bone = "ValveBiped.Bip01_Spine2",
    modifyClientsideModel = function(self, ply, model, pos, ang)
    local Size = Vector(1,1,1)
    local mat = Matrix()
    mat:Scale(Size)
    model:EnableMatrix('RenderMultiply', mat)
        local MAngle = Angle(90,0,-90)
        local MPos = Vector(4.5,4,0)
        pos = pos + (ang:Forward() * MPos.x) + (ang:Up() * MPos.z) + (ang:Right() * MPos.y)
        ang:RotateAroundAxis(ang:Forward(), MAngle.p)
        ang:RotateAroundAxis(ang:Up(), MAngle.y)
        ang:RotateAroundAxis(ang:Right(), MAngle.r) 
        return model, pos, ang
    end
})

-- Хелоуин 2022
rp.AddHat({
    name = "Маска Чумного Доктора",
    model = "models/facecover_pestily/facecover_pestily.mdl",
    slot = 1,
    can_wear = hats_can_wear,
    bone = "ValveBiped.Bip01_Head1",
    attachment = "eyes",
    modifyClientsideModel = function(self, ply, model, pos, ang)
    local Size = Vector(1.05,1.07,1)
    local mat = Matrix()
    mat:Scale(Size)
    model:EnableMatrix('RenderMultiply', mat)
        local MAngle = Angle(0,0,0)
        local MPos = Vector(-3.76,0,-2.17)
        pos = pos + (ang:Forward() * MPos.x) + (ang:Up() * MPos.z) + (ang:Right() * MPos.y)
        ang:RotateAroundAxis(ang:Forward(), MAngle.p)
        ang:RotateAroundAxis(ang:Up(), MAngle.y)
        ang:RotateAroundAxis(ang:Right(), MAngle.r) 
        return model, pos, ang
    end
})

rp.AddHat({
    name = "Маска Каонаси",
    model = "models/facecover_halloween/facecover_halloween_kaonasi.mdl",
    slot = 1,
    can_wear = hats_can_wear,
    bone = "ValveBiped.Bip01_Head1",
    attachment = "eyes",
    modifyClientsideModel = function(self, ply, model, pos, ang)
    local Size = Vector(1.12, 1.15, 1.10)
    local mat = Matrix()
    mat:Scale(Size)
    model:EnableMatrix('RenderMultiply', mat)
        local MAngle = Angle(0,0,0)
        local MPos = Vector(-3.18,0,-2.77)
        pos = pos + (ang:Forward() * MPos.x) + (ang:Up() * MPos.z) + (ang:Right() * MPos.y)
        ang:RotateAroundAxis(ang:Forward(), MAngle.p)
        ang:RotateAroundAxis(ang:Up(), MAngle.y)
        ang:RotateAroundAxis(ang:Right(), MAngle.r) 
        return model, pos, ang
    end
})

rp.AddHat({
    name = "Маска Карателя",
    model = "models/facecover_welding/facecover_tagilla_kill.mdl",
    slot = 1,
    can_wear = hats_can_wear,
    bone = "ValveBiped.Bip01_Head1",
    attachment = "eyes",
    modifyClientsideModel = function(self, ply, model, pos, ang)
    local Size = Vector(1.00, 1.00, 1.00)
    local mat = Matrix()
    mat:Scale(Size)
    model:EnableMatrix('RenderMultiply', mat)
        local MAngle = Angle(0,0,6.16)
        local MPos = Vector(-2.72,0,-5.41)
        pos = pos + (ang:Forward() * MPos.x) + (ang:Up() * MPos.z) + (ang:Right() * MPos.y)
        ang:RotateAroundAxis(ang:Forward(), MAngle.p)
        ang:RotateAroundAxis(ang:Up(), MAngle.y)
        ang:RotateAroundAxis(ang:Right(), MAngle.r) 
        return model, pos, ang
    end
})

rp.AddHat({
    name = "Маска Зомби",
    model = "7:models/sal/acc/fix/mask_2.mdl",
    slot = 1,
    can_wear = hats_can_wear,
    bone = "ValveBiped.Bip01_Head1",
    attachment = "eyes",
    modifyClientsideModel = function(self, ply, model, pos, ang)
    local Size = Vector(1.00, 1.00, 1.00)
    local mat = Matrix()
    mat:Scale(Size)
    model:EnableMatrix('RenderMultiply', mat)
        local MAngle = Angle(0,0,0)
        local MPos = Vector(-3.43,0,-1.93)
        pos = pos + (ang:Forward() * MPos.x) + (ang:Up() * MPos.z) + (ang:Right() * MPos.y)
        ang:RotateAroundAxis(ang:Forward(), MAngle.p)
        ang:RotateAroundAxis(ang:Up(), MAngle.y)
        ang:RotateAroundAxis(ang:Right(), MAngle.r) 
        return model, pos, ang
    end
})

rp.AddBag({
    name = "Хэллоуинский Рюкзак",
    model = "models/backpack_pilgrim/backpack_pilgrim.mdl",
    bag = 3,
    can_wear = hats_can_wear,
    desc = "Уникальный рюкзак с ХЕЛЛУИНА-2022. Расширит твой инвентарь на 15 ячеек.",
    bone = "ValveBiped.Bip01_Spine2",
    modifyClientsideModel = function(self, ply, model, pos, ang)
    local Size = Vector(1.00, 1.00, 1.00)
    local mat = Matrix()
    mat:Scale(Size)
    model:EnableMatrix('RenderMultiply', mat)
        local MAngle = Angle(90,0,270)
        local MPos = Vector(-12,-2,0)
        pos = pos + (ang:Forward() * MPos.x) + (ang:Up() * MPos.z) + (ang:Right() * MPos.y)
        ang:RotateAroundAxis(ang:Forward(), MAngle.p)
        ang:RotateAroundAxis(ang:Up(), MAngle.y)
        ang:RotateAroundAxis(ang:Right(), MAngle.r) 
        return model, pos, ang
    end
})    

-- БП Зима 22/23
rp.AddHat({
    name = "Маска Тихони",
    model = "models/facecover_hockey/facecover_hockey_quiet.mdl",
    slot = 1,
    can_wear = hats_can_wear,
    bone = "ValveBiped.Bip01_Head1",
    attachment = "eyes",
    modifyClientsideModel = function(self, ply, model, pos, ang)
    local Size = Vector(1.1, 1.1, 1.1)
    local mat = Matrix()
    mat:Scale(Size)
    model:EnableMatrix('RenderMultiply', mat)
        local MAngle = Angle(0,0,0)
        local MPos = Vector(-4.15,0,-2.22)
        pos = pos + (ang:Forward() * MPos.x) + (ang:Up() * MPos.z) + (ang:Right() * MPos.y)
        ang:RotateAroundAxis(ang:Forward(), MAngle.p)
        ang:RotateAroundAxis(ang:Up(), MAngle.y)
        ang:RotateAroundAxis(ang:Right(), MAngle.r) 
        return model, pos, ang
    end
})

rp.AddHat({
    name = "Маска Задиры",
    model = "models/facecover_hockey/facecover_hockey_brawler.mdl",
    slot = 1,
    can_wear = hats_can_wear,
    bone = "ValveBiped.Bip01_Head1",
    attachment = "eyes",
    modifyClientsideModel = function(self, ply, model, pos, ang)
    local Size = Vector(1.1, 1.1, 1.1)
    local mat = Matrix()
    mat:Scale(Size)
    model:EnableMatrix('RenderMultiply', mat)
        local MAngle = Angle(0,0,0)
        local MPos = Vector(-4.15,0,-2.22)
        pos = pos + (ang:Forward() * MPos.x) + (ang:Up() * MPos.z) + (ang:Right() * MPos.y)
        ang:RotateAroundAxis(ang:Forward(), MAngle.p)
        ang:RotateAroundAxis(ang:Up(), MAngle.y)
        ang:RotateAroundAxis(ang:Right(), MAngle.r) 
        return model, pos, ang
    end
})

rp.AddHat({
    name = "Маска Капитана",
    model = "models/facecover_hockey/facecover_hockey_captain.mdl",
    slot = 1,
    can_wear = hats_can_wear,
    bone = "ValveBiped.Bip01_Head1",
    attachment = "eyes",
    modifyClientsideModel = function(self, ply, model, pos, ang)
    local Size = Vector(1.1, 1.1, 1.1)
    local mat = Matrix()
    mat:Scale(Size)
    model:EnableMatrix('RenderMultiply', mat)
        local MAngle = Angle(0,0,0)
        local MPos = Vector(-4.15,0,-2.22)
        pos = pos + (ang:Forward() * MPos.x) + (ang:Up() * MPos.z) + (ang:Right() * MPos.y)
        ang:RotateAroundAxis(ang:Forward(), MAngle.p)
        ang:RotateAroundAxis(ang:Up(), MAngle.y)
        ang:RotateAroundAxis(ang:Right(), MAngle.r) 
        return model, pos, ang
    end
})

rp.AddHat({
    name = "Шляпа Оленя - Новогодняя",
    model = "models/head_pompon/head_pompon.mdl",
    slot = 1,
    can_wear = hats_can_wear,
    bone = "ValveBiped.Bip01_Head1",
    attachment = "eyes",
    modifyClientsideModel = function(self, ply, model, pos, ang)
    local Size = Vector(1.1,1.1,1.1)
    local mat = Matrix()
    mat:Scale(Size)
    model:EnableMatrix('RenderMultiply', mat)
        local MAngle = Angle(0,0,0)
        local MPos = Vector(-4.88,0,-1.30)
        pos = pos + (ang:Forward() * MPos.x) + (ang:Up() * MPos.z) + (ang:Right() * MPos.y)
        ang:RotateAroundAxis(ang:Forward(), MAngle.p)
        ang:RotateAroundAxis(ang:Up(), MAngle.y)
        ang:RotateAroundAxis(ang:Right(), MAngle.r) 
        return model, pos, ang
    end
})

rp.AddHat({
    name = "Шляпа Оленя - Спортивная",
    model = "models/head_pompon/head_pompon_2.mdl",
    slot = 1,
    can_wear = hats_can_wear,
    bone = "ValveBiped.Bip01_Head1",
    attachment = "eyes",
    modifyClientsideModel = function(self, ply, model, pos, ang)
    local Size = Vector(1.1,1.1,1.1)
    local mat = Matrix()
    mat:Scale(Size)
    model:EnableMatrix('RenderMultiply', mat)
        local MAngle = Angle(0,0,0)
        local MPos = Vector(-4.88,0,-1.30)
        pos = pos + (ang:Forward() * MPos.x) + (ang:Up() * MPos.z) + (ang:Right() * MPos.y)
        ang:RotateAroundAxis(ang:Forward(), MAngle.p)
        ang:RotateAroundAxis(ang:Up(), MAngle.y)
        ang:RotateAroundAxis(ang:Right(), MAngle.r) 
        return model, pos, ang
    end
})

rp.AddHat({
    name = "Шляпа Оленя - Элитная",
    model = "models/head_pompon/head_pompon_3.mdl",
    slot = 1,
    can_wear = hats_can_wear,
    bone = "ValveBiped.Bip01_Head1",
    attachment = "eyes",
    modifyClientsideModel = function(self, ply, model, pos, ang)
    local Size = Vector(1.1,1.1,1.1)
    local mat = Matrix()
    mat:Scale(Size)
    model:EnableMatrix('RenderMultiply', mat)
        local MAngle = Angle(0,0,0)
        local MPos = Vector(-4.88,0,-1.30)
        pos = pos + (ang:Forward() * MPos.x) + (ang:Up() * MPos.z) + (ang:Right() * MPos.y)
        ang:RotateAroundAxis(ang:Forward(), MAngle.p)
        ang:RotateAroundAxis(ang:Up(), MAngle.y)
        ang:RotateAroundAxis(ang:Right(), MAngle.r) 
        return model, pos, ang
    end
})

rp.AddHat({
    name = "Ушаночка",
    model = "models/head_ushanka/head_ushanka.mdl",
    slot = 1,
    can_wear = hats_can_wear,
    bone = "ValveBiped.Bip01_Head1",
    attachment = "eyes",
    modifyClientsideModel = function(self, ply, model, pos, ang)
    local Size = Vector(1.1,1.1,1.1)
    local mat = Matrix()
    mat:Scale(Size)
    model:EnableMatrix('RenderMultiply', mat)
        local MAngle = Angle(0,0,0)
        local MPos = Vector(-4.68,0,-1.90)
        pos = pos + (ang:Forward() * MPos.x) + (ang:Up() * MPos.z) + (ang:Right() * MPos.y)
        ang:RotateAroundAxis(ang:Forward(), MAngle.p)
        ang:RotateAroundAxis(ang:Up(), MAngle.y)
        ang:RotateAroundAxis(ang:Right(), MAngle.r) 
        return model, pos, ang
    end
})

rp.AddHat({
    name = "Новогодний Чудо Рюкзак",
    model = "models/backpack_redfox/backpack_redfox.mdl",
    bag = 3,
    can_wear = hats_can_wear,
    desc = "Расширит твой инвентарь на 15 ячеек.",
    bone = "ValveBiped.Bip01_Spine2",
    modifyClientsideModel = function(self, ply, model, pos, ang)
    local Size = Vector(1,1,1)
    local mat = Matrix()
    mat:Scale(Size)
    model:EnableMatrix('RenderMultiply', mat)
        local MAngle = Angle(90,0,270)
        local MPos = Vector(-6.05,-4.79,0)
        pos = pos + (ang:Forward() * MPos.x) + (ang:Up() * MPos.z) + (ang:Right() * MPos.y)
        ang:RotateAroundAxis(ang:Forward(), MAngle.p)
        ang:RotateAroundAxis(ang:Up(), MAngle.y)
        ang:RotateAroundAxis(ang:Right(), MAngle.r) 
        return model, pos, ang
    end
})

hook.Run("rp.AddHatsDiscount")
hook.Run("rp.AddHatsToDonate")

