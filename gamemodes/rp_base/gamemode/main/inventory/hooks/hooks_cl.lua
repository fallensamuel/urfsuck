-- "gamemodes\\rp_base\\gamemode\\main\\inventory\\hooks\\hooks_cl.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local isPressedRMB, timeStartRMB, setPopup

local CL_PLAYER_BufferedEnts = CL_PLAYER_BufferedEnts or {};

hook.Add("Think","rp.SmartTapInv",function()
	if IsValid(rp.gui.inv1) && rp.gui.inv1.Close && isPressedRMB && !input.IsMouseDown(MOUSE_RIGHT) then
		if (CurTime()-timeStartRMB) > 0.3 then
			rp.gui.inv1:Close()
			isPressedRMB = false
		else
			rp.gui.inv1:MakePopup()
			setPopup = true
			isPressedRMB = false
		end
	end
	if IsValid(rp.gui.inv1) and setPopup then gui.EnableScreenClicker(true) end
	if not IsValid(rp.gui.inv1) then setPopup = false end
end)

hook.Add("PlayerBindPress","rp.TakeInventory",function(client, bind, pressed)
    bind = bind:lower()
    if ((bind:find("use") or bind:find("attack")) and pressed) then
        local menu, callback = rp.menu.getActiveMenu()
        if not IsValid(client:GetActiveWeapon()) then return end
        if bind:find("attack") && client:Alive() && client:GetActiveWeapon():GetClass() != "inventory" then return end
        --if (menu and rp.menu.list[menu] and rp.menu.list[menu].options and #rp.menu.list[menu].options == 0) then return end
        if (menu and rp.menu.onButtonPressed(menu, callback)) then
            return true
        elseif ((bind:find("use") or bind:find("attack")) and pressed) then
--[[
            local data = {}
                data.start = client:GetShootPos()
                data.endpos = data.start + client:GetAimVector()*96
                data.filter = client
            local trace = util.TraceLine(data)
            local entity = trace.Entity
]]--

            local entity = client:GetEyeTrace().Entity

            --chat.AddText(color_white, (IsValid(entity) and "" or "not").."Valid", Color(200, 200, 200), " ", entity:GetNWBool("isInvItem") and "TRUE" or "FALSE")

            if IsValid(entity) and entity:GetNWBool("isInvItem") then
                if client.HasBlockedInventory and client:HasBlockedInventory() then return true end

                hook.Run("ItemShowEntityMenu", entity)
                CL_PLAYER_BufferedEnts[entity] = nil;

                return true
            elseif hook.Run("FixErrorItemShowEntityMenu", client) then
                --return true
            end
        end
    end
    if bind:find("attack2") and pressed then
        isPressedRMB = true 
        timeStartRMB = CurTime()
    end
end)

local Empty = table.Empty;
local FTime = FrameTime;
local GetKeys = table.GetKeys;
local Abs = math.abs;

local function NearScreenBorder()
    local Pos;
    local W, H = ScrW(), ScrH();
    for k, v in pairs(rp.menu.list) do
        if (#GetKeys(v.options) == 0) then
            Pos = v.position;
            if (!isvector(Pos)) then continue end
            Pos = Pos:ToScreen();
            //print(Abs(Pos.x), Abs(Pos.y));
            /*
            if (!(Pos.x >= W * .1 and Pos.x <= W * .9 and Pos.y >= H * .1 and Pos.y <= H * .9)) then
                //v.toClose = true;
            end
            */
        end
    end
end
/* заменено на радиальное интеракт меню
hook.Add("HUDPaintBackground","rp.HUDPaintBackground",function()
    rp.menu.drawAll()
    
    if rp.cfg.DisableContextRedisign then return end
    
    local Ent = util.TraceHull({
        start = LocalPlayer():GetShootPos(),
        endpos = LocalPlayer():GetShootPos() + (LocalPlayer():GetAimVector() * 1000),
        //filter = LP,
        mins = Vector(-15, -15, -15),
        maxs = Vector(15, 15, 15)
    }).Entity;

    NearScreenBorder();
    //if (rp.menu.list and #rp.menu.list > 0) then return end
    if (rp.menu.HasActiveMenu) then 
        CL_PLAYER_BufferedEnts = {};
        return 
    end

    if (IsValid(Ent)) then
        if (LocalPlayer():GetPos():DistToSqr(Ent:GetPos()) <= 9216) then
            if (Ent:GetNWBool("isInvItem") and !CL_PLAYER_BufferedEnts[Ent]) then
                if (Ent:GetClass() and Ent:GetClass() == 'rp_item') then
                    if (!Ent.getItemTable) then
                        rp.makeItem(Ent);
                    end

                    if rp.DrawInfoBubble then return end

                    rp.menu.add({}, Ent, function()
                        CL_PLAYER_BufferedEnts[Ent] = nil;
                    end);
                    CL_PLAYER_BufferedEnts[Ent] = true;
                end
            end
        end
    end
end)

hook.Add("ItemShowEntityMenu","rp.ItemShowEntityMenu",function(entity)
    for k, v in ipairs(rp.menu.list) do
        if (v.entity == entity) then
            table.remove(rp.menu.list, k)
        end
    end

    if not entity.getItemTable then
        rp.makeItem(entity)
    end

    local options = {}
    local itemTable = entity:getItemTable()

    if (!itemTable) then
        rp.Notify(1, translates.Get("Такого предмета не существует!"))
        return false
    end

    local function callback(index)
        if (IsValid(entity) and not entity.NoAnimatons) then
            entity:ResetSequence("close")
        end

        LocalPlayer().usedEntity = entity
        netstream.Start("invAct", index, entity)
    end

    itemTable.player = LocalPlayer()
    itemTable.entity = entity

    for k, v in SortedPairs(itemTable.functions) do
        if (k == "combine") then continue end -- yeah, noob protection

        if (v.onCanRun) then
            if (v.onCanRun(itemTable) == false) then
                continue
            end
        end

        options[v.name or k] = function()
            local send = true

            if (v.onClientRun) then
                local AltTable = table.Copy(itemTable);
                AltTable.player = LocalPlayer();
                v.onClientRun(AltTable);
            end

            if (v.onClick) then
                send = v.onClick(itemTable)
            end

            if (v.sound) then
                if (IsValid(entity) and entity:GetPos():DistToSqr(LocalPlayer():GetPos() or Vector(0, 0, 0)) <= 9216) then
                    surface.PlaySound(v.sound)
                end
            end

            if (send != false) then
                callback(k)
            end
        end
    end

    --PrintTable(itemTable)
    --print(itemTable.onlyEntity)
    
    if (table.Count(options) == 1) and not itemTable.onlyEntity then
        options[table.GetKeys(options)[1]]();
        return
    end

    if (table.Count(options) > 0) and not itemTable.onlyEntity then
        entity.nutMenuIndex = rp.menu.add(options, entity, function() rp.menu.HasActiveMenu = false; end)
    end

    itemTable.player = nil
    itemTable.entity = nil
end)
*/