-- "gamemodes\\rp_base\\gamemode\\main\\inventory\\items\\base\\sh_present.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
ITEM.name = "Present Base";
ITEM.model = "models/props_junk/cardboard_box001a.mdl";
ITEM.width = 1;
ITEM.height = 1;
ITEM.desc = "Base for present entities";
ITEM.category = "Presents";

ITEM.BubbleHint = {
	ico = Material( "bubble_hints/hints/present.png", "smooth noclamp" ),
	offset = Vector( 0, 0, 8 ),
	scale = 0.5
};

ITEM.awards = {};

ITEM.functions.usePresent = { 
	name = translates.Get( "Открыть подарок" ),
	tip = "useTip",
	icon = "icon16/package_go.png",
	InteractMaterial = "ping_system/use.png", 
	onRun = function( item )
        local client = item.player;
        if not IsValid( client ) then return false end

        for _, a in ipairs( item.awards or {} ) do
            if not rp.awards.Data[a.award_type] then
                continue
            end

            local t = table.Copy( a );
            t.award_type = nil;

            rp.awards.Give( client, a.award_type, unpack(t) );
        end

		return true
	end,
	onCanRun = function( item )
		return true
	end
}

function rp.AddPresent( tblEnt )
    tblEnt.type = tblEnt.type or "item";
    tblEnt.base = "present";

	local ITEM = rp.item.createItem( tblEnt );
    ITEM.awards = tblEnt.awards;

	if tblEnt.icon then
		rp.item.icons[tblEnt.ent] = tblEnt.icon;
	end

	if tblEnt.vendor then
		for vendor_name, price_tab in pairs(tblEnt.vendor) do
			rp.AddVendorItem( vendor_name, tblEnt.category, tblEnt, price_tab );
		end
	end
end