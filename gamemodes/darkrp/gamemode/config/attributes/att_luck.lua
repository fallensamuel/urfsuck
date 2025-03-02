-- "gamemodes\\darkrp\\gamemode\\config\\attributes\\att_luck.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
LUCK_TYPE_SALARY    = 0;
LUCK_TYPE_ENTITY    = 1;
LUCK_TYPE_AMMO      = 2;
LUCK_TYPE_ATTRIBUTE = 3;
LUCK_TYPE_LOOTABLE  = 4;
LUCK_TYPE_CRAFT     = 5;

local ATTRIBUTE = {};

ATTRIBUTE.ID                    = "lucko";
ATTRIBUTE.Name                  = "Удача";
ATTRIBUTE.Desc                  = "Навык настоящего счастливчика! Дает шанс на удвоение всего, что можно удвоить, а также получить неожиданные сюрпризы!";
ATTRIBUTE.Background            = "rpui/attributes/stalker2pro.png";
ATTRIBUTE.Color                 = Color( 102, 255, 0 );
ATTRIBUTE.InitialAmount         = 0;
ATTRIBUTE.MaxAmount             = 100;
ATTRIBUTE.UpgradeMax            = 100;
ATTRIBUTE.UpgradeConversionRate = 2;
ATTRIBUTE.Chance                = 0.25; -- 100% на фулл прокачке
ATTRIBUTE.LootableType          = "luck_loot";
ATTRIBUTE.LootableCooldown      = 180;
ATTRIBUTE.NotifySound           = "garrysmod/save_load4.wav";
ATTRIBUTE.Notifies              = {
    ["generic"]           = { "Вам подмигнула удача!", "Вы чувствуете себя удачливее, чем обычно..." },
    [LUCK_TYPE_SALARY]    = {"Ого! Вам улыбнулась удача и вы получили двойную заработную плату!"},
    [LUCK_TYPE_ENTITY]    = {"Сегодня точно твой день! Предмет достался тебе совершенно бесплатно!"},
    [LUCK_TYPE_AMMO]      = {"Фортуна на твой стороне! Боеприпасы достались тебе совершенно бесплатно!"},
    [LUCK_TYPE_ATTRIBUTE] = {"Кто счастливчик? ТЫ! 1 очко навыка превратилось в 2!"},
    [LUCK_TYPE_LOOTABLE]  = {"Ты настоящий лакер! Быстрее забирай дополнительный лут из ящика!"},
    [LUCK_TYPE_CRAFT]     = {"Фортуна улыбнулась тебе, ведь ты скрафтил в 2 раза больше предметов!"},
};

AttributeSystem.Attributes[ATTRIBUTE.ID] = ATTRIBUTE;

if CLIENT then
    net.Receive( "lucksound", function()
        surface.PlaySound( ATTRIBUTE.NotifySound );
    end );
end

if SERVER then
    util.AddNetworkString( "lucksound" );

    hook.Add( "attribute.Luck::Notify", "attribute.Luck::Core", function( ply, t, data )
        local t_msg = ATTRIBUTE.Notifies[t] or {};
        local msg = t_msg[math.random(#t_msg)];

        if not msg then
            t_msg = ATTRIBUTE.Notifies["generic"] or {};
            msg = t_msg[math.random(#t_msg)] or "Удача!";
        end

        net.Start( "lucksound" ); net.Send( ply );

        rp.Notify( ply, NOTIFY_GENERIC, translates.Get(msg) );
    end );

    hook.Add( "PlayerTestLuck", "attribute.Luck::Core", function( ply, t, data )
        local amount = ply:GetAttributeAmount( ATTRIBUTE.ID ) or 0;
        if amount <= 0 then
            return false
        end

        local dt = amount / ATTRIBUTE.MaxAmount;
        if math.random() > ATTRIBUTE.Chance * dt then
            return false
        end

        hook.Run( "attribute.Luck::Notify", ply, t, data );
        return true
    end );

    hook.Add( "PlayerPayDay", "attribute.Luck::CalculateSalary", function( ply, salary )
        local status = hook.Run( "PlayerTestLuck", ply, LUCK_TYPE_SALARY, salary );
        if not status then return end

        return salary * 2;
    end );

    hook.Add( "OnAttributeUpgrade", "attribute.Luck::CalculateAttribute", function( ply, att, num )
        local status = hook.Run( "PlayerTestLuck", ply, LUCK_TYPE_ATTRIBUTE, att );
        if not status then return end

        return num * 2;
    end );

    local lootable_cds = {};

    hook.Add( "Inv::GenerateAdditionalLoot", "attribute.Luck::CalculateLoot", function( item )
        local lt = ATTRIBUTE.LootableType;
        if not rp.item.loot[lt] then return end

        local ply = item.player;
        if not IsValid( ply ) then return end

        local t = CurTime();
        if (lootable_cds[ply] or 0) > t then return end

        local ent = item.entity;
        if not IsValid( ent ) then return end

        if ent.LootType and (ent.uniqueID and ent.uniqueID == "box_loot") then
            lootable_cds[ply] = t + ATTRIBUTE.LootableCooldown;

            if hook.Run( "PlayerTestLuck", ply, LUCK_TYPE_LOOTABLE, item ) then
                for k, drop in ipairs( rp.GenerateLoot(1, lt) ) do
                    item:getInv():add( drop.uniqueID );
                end
            end
        end
    end );
end