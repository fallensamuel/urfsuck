-- "gamemodes\\rp_base\\gamemode\\main\\inventory\\items\\bags\\sh_storage_org.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
ITEM.name          = "Склад";
ITEM.desc          = "Склад организации.";
ITEM.model         = "models/maxofs2d/cube_tool.mdl";
ITEM.invWidth      = 5;
ITEM.invHeight     = 5;
ITEM.category      = "Storage";
ITEM.permit        = "misc";
ITEM.noTake        = true;
ITEM.useCooldowns  = {};

ITEM.onSpawn = function( ent, pl, item )
    ent.NoDamage = true;
end

ITEM.functions.Open = {
    name = translates.Get( "Открыть" ),
    icon = "icon16/cup.png",
    sound = "buttons/lever8.wav",
    onRun = function( item )
        local index = item:getData( "id" );
        netstream.Start( item.player, "rpOpenBag", index );

        return false
    end,
    onCanRun = function( item )
        if SERVER then
            if
                IsValid( item.entity )
                and IsValid( item.player )
                and item:getData( "id" )
                and item:getData( "org" )
            then
                local t = CurTime();
                if (item.useCooldowns[item.player] or 0) > t then return false end
                item.useCooldowns[item.player] = t + 1;

                local org = item.player:GetOrg() or "";

                local forced = hook.Run( "OnOrgStorageOpen", item.player, org, item:getData("org") );
                if not forced then
                    local inv_org = item:getData("org") or "";

                    if org ~= inv_org then
                        rp.Notify( item.player, NOTIFY_ERROR, translates.Get("Вы не состоите в этой организации!") );
                        return false
                    end
                end

                local index = item:getData( "id" );
                if index then
                    local inv = rp.item.inventories[index];
                    if inv then inv:sync( item.player ); end
                end

                return true
            end
        end

        return true
    end
};

function ITEM:onRegistered()
    if CLIENT then
        rp.AddBubble( "item", self.uniqueID, {
            ico = Material( "bubble_hints/lootbox.png", "smooth" ),
            name = translates.Get( "Склад Организации" ),
            desc = translates.Get( "[E] Открыть склад" ),
            ico_col = color_white,
            title_colr = color_white,
            customCheck = function( ent )
                local org = ent:GetNWString( "org", nil );
                if not org then return false end
                return org == (LocalPlayer():GetOrg() or "")
            end
        } );
    end
end

function ITEM:onInstanced()
end

function ITEM:onSendData()
end

function ITEM:onRemoved()
end

function ITEM:onCanBeTransfered( old, new )
end

if CLIENT then
    hook.Add( "ShouldCloseEmptyInventoryUI", "storage_org::PreventClosing", function( inv )
        if inv and inv.vars and inv.vars.isBag and inv.vars.isBag == "storage_org" then
            return false
        end
    end );
end