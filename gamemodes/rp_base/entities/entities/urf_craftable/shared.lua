-- "gamemodes\\rp_base\\entities\\entities\\urf_craftable\\shared.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
ENT.Base = "base_anim";

ENT.IsCraftingTable = true;

ENT.PrintName = "Верстак";
ENT.Author = "urf.im @ bbqmeow";
ENT.Category = "[!] Development";

ENT.Spawnable = true;
ENT.AdminOnly = true;

ENT.RenderGroup = RENDERGROUP_BOTH;
ENT.Model = "models/props_rp/crafting_table/weapon_crafting_table_anim.mdl";
ENT.InteractDistance = math.pow( 300, 2 );

ENT.Enums = {};
ENT.Enums.USE = 0;
ENT.Enums.INFO = 1;
ENT.Enums.HELP = 2;

ENT.m_BoxesInstances = {
    { pos = Vector(-55, -12, 39), ang = Angle(0, 205, 0), scale = 0.8 },
    { pos = Vector(-56, -10, 58), ang = Angle(0, 175, 0), scale = 0.6 },
    { pos = Vector(-36, 6, 39), ang = Angle(0, 250, 0), scale = 0.5 },
};

ENT.v_CraftingOffset = Vector( -13.5, -14, 39 );
ENT.m_CraftingMaterial = Material( "models/wireframe" );

function ENT:HasItemsToCraft( ply, craft )
    if not craft.recipe then
        return true;
    end

    local inv = ply:getInv();
    if not inv then return false; end

    local items, items_count = {}, {};

    for id, item in pairs( inv:getItems() ) do
        local uid = item.uniqueID;

        items[uid] = items[uid] or {};
        items[uid][#items[uid] + 1] = item;

        items_count[uid] = (items_count[uid] or 0) + item:getCount();
    end

    for k, item in ipairs( craft.recipe ) do
        if (items_count[item.uid] or 0) < item.count then
            return false;
        end
    end

    return true, items;
end