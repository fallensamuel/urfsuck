-- "gamemodes\\darkrp\\gamemode\\config\\items\\bags\\sh_box_heist.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
ITEM.name          = "Ящик для ограблений";
ITEM.desc          = "n/a";

ITEM.model         = "models/props_junk/watermelon01.mdl";

ITEM.invWidth      = 5;
ITEM.invHeight     = 5;

ITEM.price         = -1;

ITEM.category      = "Storage";
ITEM.permit        = "misc";

ITEM.noTake        = true;
ITEM.notTransfered = true;

ITEM.onSpawn = function( ent, pl, item )
    ent.NoDamage = true;
end

ITEM.functions.StartHeist = {
	name = "Начать ограбление",
	icon = "icon16/cup.png",
	sound = "buttons/lever8.wav",
    onRun = function( item )
        local ent = item.entity;

        print( "running??" );

        rp.ArmoryHeists.StartHeist( ent:GetNWInt("HeistID"), item.player );
        return false
	end,
    onCanRun = function(item)
        local id = item.entity:GetNWInt("HeistID");
        if not rp.ArmoryHeists.List[id] then return false end

        return not rp.ArmoryHeists.List[id].IsInProgress and (rp.ArmoryHeists.List[id].Timestamp <= CurTime())
    end
}

ITEM.functions.Open.onCanRun = function( item )
    local id = item.entity:GetNWInt("HeistID");
    if not rp.ArmoryHeists.List[id] then return false end

	if item.StillLoading then
		rp.Notify(item.player, NOTIFY_GENERIC, "Предметы в этом ящике ещё не загрузились")
		return false
	end
	
    return not rp.ArmoryHeists.List[id].IsInProgress and (rp.ArmoryHeists.List[id].Timestamp > CurTime()) and item:getData("id")
end