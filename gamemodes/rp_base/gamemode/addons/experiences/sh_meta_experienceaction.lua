-- "gamemodes\\rp_base\\gamemode\\addons\\experiences\\sh_meta_experienceaction.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
----------------------------------------------------------------
rp.Experiences = rp.Experiences or {};
rp.Experiences.Actions = {};

----------------------------------------------------------------
local META = {};

function META:GetPrintName()
    return self.PrintName or self.ID or "N/A";
end

function META:SetPrintName( printname )
    self.PrintName = printname;
    return self;
end

function META:AddHook( hookname, player_index, fn )
    if CLIENT then return self; end

    self.Hooks = self.Hooks or {
        Functions = {},
        PlayerIdx = {},
    };

    self.Hooks.Functions[hookname] = fn;
    self.Hooks.PlayerIdx[hookname] = player_index;

    rp.Experiences:SetupHook( hookname );

    return self;
end

----------------------------------------------------------------
function rp.Experiences:GetExperienceAction( id )
    if self.Actions[id] then
        return self.Actions[id];
    end

    local action = {};
    action["ID"] = id;

    self.Actions[id] = setmetatable( action, { __index = META } );
    return self.Actions[id];
end

----------------------------------------------------------------
hook.Add( "Initialize", "rp.Experiences::DefaultActions", function()
    rp.Experiences:GetExperienceAction( "broom" )
        :SetPrintName( translates.Get("Уборка") )
        :AddHook( "OnBroomCleanedReward", 1, function() return true; end )

    rp.Experiences:GetExperienceAction( "factory" )
        :SetPrintName( translates.Get("Работа на фабрике") )
        :AddHook( "Factory::CombinedItem", 1, function() return true; end )

    local ReviveCooldown = {};
    rp.Experiences:GetExperienceAction( "revive" )
        :SetPrintName( translates.Get("Поднятие") )
        :AddHook( "DeathMechanics.OnEndHeal", 1, function( ply, target )
            ReviveCooldown[ply] = ReviveCooldown[ply] or {};

            local t = CurTime();

            if (ReviveCooldown[ply][target] or 0) <= t then
                ReviveCooldown[ply][target] = t + 60 * 5;
                return true;
            end
        end )

    local HealCooldown = {};
    rp.Experiences:GetExperienceAction( "healing" )
        :SetPrintName( translates.Get("Лечение") )
        :AddHook( "OnPlayerHealed", 1, function( ply, target )
            HealCooldown[ply] = HealCooldown[ply] or {};

            local t = CurTime();

            if (HealCooldown[ply][target] or 0) <= t then
                HealCooldown[ply][target] = t + 60 * 5;
                return true;
            end
        end )

    rp.Experiences:GetExperienceAction( "mining" )
        :SetPrintName( translates.Get("Шахтерство") )
        :AddHook( "PlayerMinedOreNode", 1, function() return true; end )

    rp.Experiences:GetExperienceAction( "stashing" )
        :SetPrintName( translates.Get("Кладменство") )
        :AddHook( "OnStashingChallengeReward", 1, function() return true; end )

    rp.Experiences:GetExperienceAction( "cooking" )
        :SetPrintName( translates.Get("Готовка еды") )
        :AddHook( "zpiz_OnPizzaReady", 2, function() return true; end )

    rp.Experiences:GetExperienceAction( "sell_item" )
        :SetPrintName( translates.Get("Продажа предмета") )
        :AddHook( "Vendor::SoldItem", 1, function( ply, item_uid, item_count, vendor, price )
            local exp_table = (ply:GetJobTable().experience or {})["actions"] or {};
            local sell_item = exp_table["sell_item"];

            if isnumber( sell_item ) then
                return true;
            end

            if istable( sell_item ) then
                local exp = sell_item[item_uid];
                if exp and isnumber( exp ) then
                    return exp * item_count;
                end
            end
        end );

    rp.Experiences:GetExperienceAction( "sell_vendor" )
        :SetPrintName( translates.Get("Продажа предмета торговцу") )
        :AddHook( "Vendor::SoldItem", 1, function( ply, item_uid, item_count, vendor, price )
            local exp_table = (ply:GetJobTable().experience or {})["actions"] or {};
            local sell_vendor = exp_table["sell_vendor"];

            if isnumber( sell_vendor ) then
                return true;
            end

            if istable( sell_vendor ) then
                local exp = sell_vendor[vendor:GetVendorName()];
                if exp and isnumber( exp ) then
                    return exp * item_count;
                end
            end
        end );

    rp.Experiences:GetExperienceAction( "sell_slave" )
        :SetPrintName( translates.Get("Продажа разыскиваемых") )
        :AddHook( "OnSlaveSold", 1, function( initiator, slave )
            local bonus = (slave:GetJobTable() or {}).slaveExperience;
            if not isnumber( bonus ) then return true; end

            return bonus;
        end );

    rp.Experiences:GetExperienceAction( "destroyable" )
        :SetPrintName( translates.Get("Ломание пропа") )
        :AddHook( "DestroyableProps::Destroyed", 1, function() return true; end )

    rp.Experiences:GetExperienceAction( "crafting" )
        :SetPrintName( translates.Get("Создание предмета") )
        :AddHook( "urf.im/crafttable/FinishCraft", 2, function( ent, ply, uid, item_uid )
            return true;
        end )
        :AddHook( "OnItemCrafted", 1, function( ply, state, item_uid )
            return (state or 0) == 4;
        end )

    local KnockedCooldown = {};
    rp.Experiences:GetExperienceAction( "knockdown" )
        :SetPrintName( translates.Get("Нокаут") )
        :AddHook( "DeathMechanics.StartDeath", 2, function( target, ply )
            KnockedCooldown[ply] = KnockedCooldown[ply] or {};

            local t = CurTime();

            if (KnockedCooldown[ply][target] or 0) <= t then
                KnockedCooldown[ply][target] = t + 60 * 5;
                return true;
            end
        end )

    rp.Experiences:GetExperienceAction( "killing_npc" )
        :SetPrintName( translates.Get("Убийство НПС") )
        :AddHook( "OnNPCKilled", 2, function( npc, attacker, inflictor )
            local exp_table = (attacker:GetJobTable().experience or {})["actions"] or {};
            local data = exp_table["killing_npc"];

            if isnumber( data ) then
                return true;
            end

            if istable( data ) then
                local amount = tonumber( data[npc:GetClass()] or data["all"] or 0 );
                if amount and amount > 0 then
                    return amount;
                end
            end
        end )

    rp.Experiences:GetExperienceAction( "killing_alliance" )
        :SetPrintName( translates.Get("Убийство противника") )
        :AddHook( "PlayerDeath", 3, function( victim, inflictor, attacker )
            local exp_table = (attacker:GetJobTable().experience or {})["actions"] or {};
            local data = exp_table["killing_alliance"];

            if isnumber( data ) then
                return rp.ConjGet( attacker:GetAlliance(), victim:GetAlliance() ) == CONJ_WAR;
            end

            if istable( data ) then
                local a = victim:GetAllianceTable();
                if a and data[a.name] then
                    return data[a.name];
                end

                local conj = rp.ConjGet( attacker:GetAlliance(), victim:GetAlliance() );
                if data[conj] then
                    return data[conj];
                end
            end
        end )

    rp.Experiences:GetExperienceAction( "capture_atk" )
        :SetPrintName( translates.Get("Захват контрольной точки") )
        :AddHook( "Capture::PlayerOwnHook", 2, function( point, ply, isAttacker )
            return isAttacker;
        end )

    rp.Experiences:GetExperienceAction( "capture_def" )
        :SetPrintName( translates.Get("Защита контрольной точки") )
        :AddHook( "Capture::PlayerOwnHook", 2, function( point, ply, isAttacker )
            return not isAttacker;
        end )

    rp.Experiences:GetExperienceAction( "heist_atk" )
        :SetPrintName( translates.Get("Участие в ограблении") )
        :AddHook( "ArmoryHeists::PointAttacked", 1, function( ply, id )
            return true;
        end )

    rp.Experiences:GetExperienceAction( "heist_def" )
        :SetPrintName( translates.Get("Предотвращение ограбления") )
        :AddHook( "ArmoryHeists::PointDefended", 1, function( ply, id )
            return true;
        end )

    local ArrestedCooldown = {};
    rp.Experiences:GetExperienceAction( "arrest" )
        :SetPrintName( translates.Get("Арест игрока") )
        :AddHook( "PlayerArrested", 2, function( target, ply )
            ArrestedCooldown[ply] = ArrestedCooldown[ply] or {};

            local t = CurTime();

            if (ArrestedCooldown[ply][target] or 0) <= t then
                ArrestedCooldown[ply][target] = t + (rp.cfg.ExperienceArrestCooldown or (60 * 5));
                return true;
            end
        end )
end );