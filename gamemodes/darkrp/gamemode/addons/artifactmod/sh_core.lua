-- "gamemodes\\darkrp\\gamemode\\addons\\artifactmod\\sh_core.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
ArtifactMod = ArtifactMod or {};

ArtifactMod.Config = {
    invType = "artifact"
};

FORMAT_NUMBER  = 0;
FORMAT_PERCENT = 1;
FORMAT_BOOLEAN = 2;

ArtifactMod.Translations = {
    ["WrongInventory"] = translates.Get( "В этот аксессуар можно положить только артефакты!" ),
    ["ArtifactBroken"] = function( ... ) return translates.Get( "У артефакта \"%s\" закончились заряды.", ... ) end;

    ["maxhealth"] = translates.Get( "Здоровье" ),
    ["movespeed"] = translates.Get( "Ловкость" ),
    ["jumppower"] = translates.Get( "Выносливость" ),
    ["hungerrate"] = translates.Get( "Сытость" ),
    ["damagemult"] = translates.Get( "Стойкость" ),
    ["regeneration"] = translates.Get( "Регенерация" ),
    ["radiation"] = translates.Get( "Облучение" ),
    ["teleport"] = translates.Get( "Телепорт" )
};

ArtifactMod.Formats = {
    ["maxhealth"] = FORMAT_NUMBER,
    ["movespeed"] = FORMAT_PERCENT,
    ["jumppower"] = FORMAT_PERCENT,
    ["hungerrate"] = FORMAT_PERCENT,
    ["damagemult"] = FORMAT_PERCENT,
    ["regeneration"] = FORMAT_NUMBER,
    ["radiation"] = FORMAT_NUMBER,
    ["teleport"] = FORMAT_BOOLEAN,
};

ArtifactMod.GetArtifactInventory = function( self, ply )
    local inv = ply:getBeltInv();
    if not inv then return end
    if inv.vars and (inv.vars.type or "") ~= (self.Config.invType or "") then return end
    return inv
end