-- "gamemodes\\darkrp\\gamemode\\config\\attributes\\professional.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local ATTRIBUTE = {};

ATTRIBUTE.ID                    = "pro";
ATTRIBUTE.Name                  = "Профессионал";
ATTRIBUTE.Desc                  = "Увеличивает получаемую заработную плату до 100% \nУменьшает стоимость профессии до 50% \nУменьшает стоимость оружейных наборов до 50% \n1 очко атрибута = 2 очка навыка.";
ATTRIBUTE.Background 			= "backgrounds/rpui/attributes/master.png";
ATTRIBUTE.Color                 = Color( 0, 102, 255 );
ATTRIBUTE.InitialAmount         = 0;
ATTRIBUTE.MaxAmount             = 100;
ATTRIBUTE.UpgradeMax            = 100;
ATTRIBUTE.UpgradeConversionRate = 2;

ATTRIBUTE.Multipliers = {
    PayDay     = 1.0, -- +100% от З/П
    JobArmory  = 0.5, -- -50% от фулл стоимости снаряги
    TeamUnlock = 0.5, -- -50% от фулл стоимости профы
};

AttributeSystem.Attributes[ATTRIBUTE.ID] = ATTRIBUTE;

if SERVER then
    hook.Add( "PlayerPayDay", "attribute.Professional::CalculateSalary", function( ply, salary )
        local amount = ply:GetAttributeAmount( ATTRIBUTE.ID ) or 0;
        if amount <= 0 then return end

        return salary + (salary * ATTRIBUTE.Multipliers.PayDay * (amount / ATTRIBUTE.MaxAmount));
    end );
end

hook.Add( "CalculateJobUnlockPrice", "attribute.Professional::CalculateJobUnlockPrice", function( ply, price )
    local amount = ply:GetAttributeAmount( ATTRIBUTE.ID ) or 0;
    if amount <= 0 then return end

    return price - (price * ATTRIBUTE.Multipliers.TeamUnlock * (amount / ATTRIBUTE.MaxAmount));
end );

hook.Add( "CalculateJobArmoryPrice", "attribute.Professional::CalculateJobArmoryPrice", function( ply, price )
    local amount = ply:GetAttributeAmount( ATTRIBUTE.ID ) or 0;
    if amount <= 0 then return end

    return price - (price * ATTRIBUTE.Multipliers.JobArmory * (amount / ATTRIBUTE.MaxAmount));
end );