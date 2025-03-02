-- "gamemodes\\rp_base\\gamemode\\main\\menus\\f4menu\\controls\\rpui_inventory_cl.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local PANEL = {};
renderdIcons = renderdIcons or {}

function renderNewIcon(panel, itemTable)
    if ((itemTable.iconCam and !renderdIcons[string.lower(itemTable.model)]) or itemTable.forceRender) then
        local iconCam = itemTable.iconCam
        iconCam = {
            cam_pos = iconCam.pos,
            cam_ang = iconCam.ang,
            cam_fov = iconCam.fov,
        }
        renderdIcons[string.lower(itemTable.model)] = true

        panel.Icon.RebuildSpawnIconEx(
            panel.Icon,
            iconCam
        )
    end
end

local soundclick = {
    leftClick = "physics/body/body_medium_impact_soft4.wav",
    clickMenu = "physics/body/body_medium_impact_soft4.wav",
    movedItem = "physics/body/body_medium_impact_soft2.wav",
    rightClick = "physics/body/body_medium_impact_soft4.wav",
    addItemCrafting = "physics/body/body_medium_impact_soft3.wav",
    removeItemCrafting = "physics/body/body_medium_impact_soft7.wav",
}

local PANEL = {}

function PANEL:Init()
    self:Droppable("inv")

    surface.CreateFont( "rpui.Fonts.ItemIcon", {
        font     = "Montserrat",
        extended = true,
        weight = 600,
        size     = rpui.PowOfTwo(self:GetTall() * 0.3),
    } );
end

function PANEL:PaintOver(w, h)
    local itemTable = rp.item.instances[self.itemID]

    if (self.waiting and self.waiting > CurTime()) then
        local wait = (self.waiting - CurTime()) / self.waitingTime
        surface.SetDrawColor(255, 255, 255, 100*wait)
        surface.DrawRect( 0, 0, w, h );
    end

    if (itemTable and itemTable.paintOver) then
        local w1, h1 = self:GetSize()
        itemTable.paintOver(self, itemTable, w1, h1)
    end

    local count
    if itemTable and rp.item.instances[self.itemTable.id] then
        count = rp.item.instances[self.itemTable.id].getCount(rp.item.instances[self.itemTable.id])
    end
    if self.itemStack then
        count = self.itemStack
    end

    if count and count > 1 then
        draw.SimpleText( "X"..count, "rpui.Fonts.ItemIcon", w - h*0.05, h*0.025, rp.col.White, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP );
    end
end

function PANEL:ExtraPaint(w, h)
    if self.isUsed then
        surface.SetDrawColor(255,255,0,20)
        surface.DrawRect( 0, 0, w, h );
    end
end

function PANEL:Paint(w, h)
    local parent = self:GetParent()

    surface.SetDrawColor( rpui.UIColors.Background );
    surface.DrawRect( 0, 0, w, h );

    self:ExtraPaint(w, h)
end

function PANEL:wait(time)
    time = math.abs(time) or .2
    self.waiting = CurTime() + time
    self.waitingTime = time
end

function PANEL:isWaiting()
    if (self.waiting and self.waitingTime) then
        return (self.waiting and self.waiting > CurTime())
    end
end

vgui.Register("rpui.ItemIcon", PANEL, "SpawnIcon")




PANEL = {};

function PANEL:Init()
    self.panels = {}

    self.OnClose = function()
        if !IsValid(rp.gui.craftable) and !IsValid(rp.gui.result) then
            for k,v in pairs(rp.gui) do
                if IsValid(v) then
                    v:Close()
                end
            end
        end
        local usedEnt = LocalPlayer().usedEntity;
        if IsValid(usedEnt) and not usedEnt.NoAnimatons then
            usedEnt:ResetSequence("open")
        end
        gui.EnableScreenClicker(false)
    end

    self.widthFrame = 64
    self.heightFrame = 64
    self.spacingFrame = 0
end

function PANEL:OnRemove()
    if (self.childPanels) then
        for k1, v1 in ipairs(self.childPanels) do
            if (v1 != self) then
                v1:Remove()
            end
        end
    end
end

function PANEL:viewOnly()
    self.viewOnly = true

    for id, icon in pairs(self.panels) do
        icon.OnMousePressed = nil
        icon.OnMouseReleased = nil
        icon.doRightClick = nil
        icon.actionsMenu = nil
    end
end

function PANEL:setInventory(inventory)
    if (inventory and inventory.slots) then
        if (IsValid(rp.gui.inv1) and rp.gui.inv1.childPanels and inventory != rp.item.getInv(LocalPlayer():getInvID())) then
            table.insert(rp.gui.inv1.childPanels, self)
        end

        self.invID = inventory:getID()
        self:SetSize(self.widthFrame, self.heightFrame)
        self:setGridSize(inventory:getSize())

        for x, items in pairs(inventory.slots) do
            for y, data in pairs(items) do
                local item = rp.item.instances[data.id]
                item.model = item:getModel()
                if (item && !IsValid(self.panels[item.id])) then
                    local icon = self:addIcon(item.model or "models/props_junk/popcan01a.mdl", data.gridX, data.gridY, item.width, item.height, item.skin or 0, item.icon_override)

                    if (IsValid(icon)) then
                        if icon:SetInventoryTooltip(data.uniqueID) == false then
                            local newTooltip = hook.Run("OverrideItemTooltip", self, data, item)

                            local additional = inventory.vars and inventory.vars.isBag == 'ent_shop' and item:getData('price')

                            if (newTooltip) then
                                icon:SetToolTip(newTooltip, additional)
                            else
                                icon:SetToolTip(item:getName() .. (additional and ('\nЦена: ' .. rp.FormatMoney(additional)) or ''), item:getDesc() or "")
                            end
                        end

                        icon.itemID = data.id

                        self.panels[data.id] = icon
                    end
                end
            end
        end
    end
end

function PANEL:setGridSize(w, h)
    self.gridW = w
    self.gridH = h

    self:SetSize(w * self.widthFrame + self.spacingFrame * (w - 1), h * self.heightFrame + self.spacingFrame * (h - 1))

    if self.IsCentered then
        self.addX = ((self.addX or 0) - (w * self.widthFrame)) / 2
    else
        self.addX = 0
    end

    self:buildSlots()
end

function PANEL:buildSlots()
    self.slots = self.slots or {}

    local function PaintSlot(slot, w, h)
        surface.SetDrawColor( rpui.UIColors.Background );
        surface.DrawRect( 0, 0, w, h );
    end

    for k3, v3 in ipairs(self.slots) do
        for k4, v4 in ipairs(v3) do
            v4:Remove()
        end
    end

    self.slots = {}

    for x = 1, self.gridW do
        self.slots[x] = {}

        for y = 1, self.gridH do
            local slot = self:Add("DPanel")
            slot:SetZPos(-999)
            slot.gridX = x
            slot.gridY = y
            slot:SetPos((self.addX or 0) + self.widthFrame * (x - 1) + self.spacingFrame * (x - 1), self.heightFrame * (y - 1) + self.spacingFrame * (y - 1))
            slot:SetSize(self.widthFrame, self.heightFrame)
            slot.Paint = PaintSlot

            self.slots[x][y] = slot
        end
    end
end

local activePanels = {}
function PANEL:PaintOver(w, h)
    local item = rp.item.held

    if (IsValid(item)) then
        local gridW = item.gridW
        local gridH = item.gridH

        for k5,v5 in pairs(activePanels) do
            if k5.invID == "craftable" then
                gridW = 1
                gridH = 1
            end
        end

        local mouseX, mouseY = self:LocalCursorPos()
        mouseX = mouseX - (self.addX or 0) + self.spacingFrame * 0.5 - (gridW - 1) * self.widthFrame * 0.5
        mouseY = mouseY + self.spacingFrame * 0.5 - (gridH - 1) * self.heightFrame * 0.5

        local widthF  = self.widthFrame  + self.spacingFrame
        local heightF = self.heightFrame + self.spacingFrame

        local dropX = math.ceil(mouseX / widthF)
        local dropY = math.ceil(mouseY / heightF)

        if ((mouseX < -w*0.05 or mouseX > w*1.05) or (mouseY < -h*0.05 or mouseY > h*1.05)) then
            activePanels[self] = nil
        else
            activePanels[self] = true
        end

        item.dropPos = item.dropPos or {}
        if (item.dropPos[self]) then
            item.dropPos[self].item = nil
        end

        for x = 0, gridW - 1 do
            for y = 0, gridH - 1 do
                local x2 = dropX + x;
                local y2 = dropY + y;

                if (self.slots and self.slots[x2] and IsValid(self.slots[x2][y2])) then
                    local bool = self:isEmpty(x2, y2, item)

                    surface.SetDrawColor(0, 0, 255, 10)

                    if (x == 0 and y == 0) then
                        item.dropPos[self] = {
                            x = (self.addX or 0) + self.widthFrame * (x2 - 1) + self.spacingFrame * (x2 - 1),
                            y = self.heightFrame * (y2 - 1)  + self.spacingFrame * (y2 - 1),
                            x2 = x2, y2 = y2
                        }
                    end

                    if (bool) then
                        surface.SetDrawColor(0, 255, 0, 255)
                    else
                        surface.SetDrawColor(255, 255, 0, 255)

                        if (self.slots[x2] and self.slots[x2][y2] and item.dropPos[self]) then
                            item.dropPos[self].item = self.slots[x2][y2].item
                        end
                    end

                    surface.DrawRect(
                        (self.addX or 0) + self.widthFrame * (x2 - 1) + self.spacingFrame * (x2 - 1),
                        self.heightFrame * (y2 - 1)  + self.spacingFrame * (y2 - 1),
                        self.widthFrame,
                        self.heightFrame
                    )
                else
                    if (item.dropPos) then
                        item.dropPos[self] = nil
                    end
                end
            end
        end
    end
end

function PANEL:isEmpty(x, y, this)
    return self.slots and self.slots[x] and self.slots[x][y] and (!IsValid(self.slots[x][y].item) or self.slots[x][y].item == this)
end

function PANEL:BacklightItemUsed()
    for n,b in pairs(rp.gui.inv1.panels) do
        if IsValid(b) then
            b.isUsed = false
        end
    end
    for k6,v6 in pairs(rp.gui.craftable.itemsCrafting) do
        if IsValid(v6) then
            for c,d in pairs(v6.items) do
                for n,b in pairs(rp.gui.inv1.panels) do
                    if IsValid(b) && !b.isUsed && b.itemTable.id == d.id then
                        b.isUsed = true
                        break
                    end
                end
            end
        end
    end
end

function PANEL:RemoveItemCrafting(item, icon)
    if item then
        icon.itemStack = icon.itemStack - item:getCount()
    end
    if icon.itemStack < 1 then
        local inventory = rp.item.inventories["craftable"]
        for x = 1, inventory.w do
            if (inventory.slots[x]) then
                for y = 1, inventory.h do
                    local itemInv = inventory.slots[x][y]

                    if (itemInv and itemInv.id == icon.itemTable.id) then
                        inventory.slots[x][y] = nil
                    end
                end
            end
        end
        icon:Remove()
    else
        icon.items[item.id] = nil
    end
    self:CheckRecipes()
    self:BacklightItemUsed()
end

function PANEL:ClearItemsCrafting()
    if IsValid(rp.gui.result.itemRecipe) then rp.gui.result.itemRecipe.Remove(rp.gui.result.itemRecipe) end
    if rp.gui.craftable.itemsCrafting then
        for k7,v7 in pairs(rp.gui.craftable.itemsCrafting) do
            if IsValid(v7) then
                v7.itemStack = 0
                self:RemoveItemCrafting(nil, v7)
            end
        end
        rp.gui.craftable.itemsCrafting = {}
    end
end

function PANEL:CheckRecipes(name)
    if IsValid(rp.gui.result.itemRecipe) then rp.gui.result.itemRecipe.Remove(rp.gui.result.itemRecipe) end
    if timer.Exists("InventoryCraftingTimer") then timer.Destroy("InventoryCraftingTimer") end
    for k8,v8 in pairs(rp.item.recipes) do
        if name and k8 ~= name then
            continue
        end

        local inventory2 = rp.item.inventories["result"]

        local isCan = true

        for c,d in pairs(v8.instruments) do
            local isFound = false
            local count = 0
            for t,u in pairs(rp.gui.craftable.itemsCrafting) do
                if IsValid(u) then
                    if u.itemTable.uniqueID == d.uniqueID then
                        isFound = true
                        count = u.itemStack
                    end
                end
            end
            if !isFound || count > 1 then
                isCan = false
            end
        end

        for c1,d1 in pairs(v8.items) do
            local count = 0
            for t1,u1 in pairs(rp.gui.craftable.itemsCrafting) do
                if IsValid(u1) then
                    if u1.itemTable.uniqueID == d1.item.uniqueID then
                        count = u1.itemStack
                    end
                end
            end
            if count < d1.count || count > d1.count then
                isCan = false
            end
        end

        for t2,u2 in pairs(rp.gui.craftable.itemsCrafting) do
            if !IsValid(u2) then continue end
            local isFound = false
            for c2,d2 in pairs(v8.items) do
                if u2.itemTable.uniqueID == d2.item.uniqueID then
                    isFound = true
                end
            end
            for c3,d3 in pairs(v8.instruments) do
                if u2.itemTable.uniqueID == d3.uniqueID then
                    isFound = true
                end
            end
            if !isFound then
                isCan = false
            end
        end

        rp.gui.craftButton.CanCraftItem(rp.gui.craftButton, k8)

        if isCan then
            local x = 1
            local y = 1
            local newItem = table.Copy(v8.result)

            inventory2.slots[x] = inventory2.slots[x] or {}
            inventory2.slots[x][y] = true

            newItem.gridX = x
            newItem.gridY = y
            newItem.invID = inventory2:getID()

            for x2 = 0, 1 - 1 do
                for y2 = 0, 1 - 1 do
                    inventory2.slots[x + x2] = inventory2.slots[x + x2] or {}
                    inventory2.slots[x + x2][y + y2] = newItem
                end
            end

            rp.gui.result.itemRecipe = rp.gui.result.addIcon(rp.gui.result, v8.result.model, 1, 1, 1, 1, 0)
            rp.gui.result.itemRecipe.SetToolTip(rp.gui.result.itemRecipe, v8.result.name)
            rp.gui.result.recipe = k8
            rp.gui.result.noCanMove = true

            local irec = rp.gui.result.itemRecipe;

            function irec:ExtraPaint(w, h)
                local isCan, items = rp.IsCanCraftItem(LocalPlayer():getInv(), rp.item.recipes[rp.gui.result.recipe])
                if isCan then
                    surface.SetDrawColor( Color(0, 255, 0, 20) );
                    surface.DrawRect( 0, 0, w, h );
                else
                    surface.SetDrawColor( Color(255, 0, 0, 20) );
                    surface.DrawRect( 0, 0, w, h );
                end
            end

            rp.gui.craftButton.CanCraftItem(rp.gui.craftButton, k8)

            break
        end
    end
end

function PANEL:AddItemCrafting(inv, item)
    local x,y = inv:findEmptySlot(1, 1)
    if x and y then
        if !rp.gui.craftable.itemsCrafting then
            rp.gui.craftable.itemsCrafting = {}
        end

        local newItem = table.Copy(item)
        newItem.id = item.id != 0 and item.id or math.Rand(-100, -1)

        local icon
        for k9,v9 in pairs(rp.gui.craftable.itemsCrafting) do
            if IsValid(v9) then
                if v9.itemTable.uniqueID == newItem.uniqueID then
                    icon = v9
                end
            end
        end

        if icon then
            if !icon.items[newItem.id] then
                icon.itemStack = icon.itemStack + item:getCount()
            else
                return
            end
        else
            inv.slots[x] = inv.slots[x] or {}
            inv.slots[x][y] = true

            newItem.gridX = x
            newItem.gridY = y
            newItem.invID = inv:getID()

            for x2 = 0, 1 - 1 do
                for y2 = 0, 1 - 1 do
                    inv.slots[x + x2] = inv.slots[x + x2] or {}
                    inv.slots[x + x2][y + y2] = newItem
                end
            end

            icon = rp.gui.craftable.addIcon(rp.gui.craftable, newItem.model, x, y, 1, 1, 0)
            icon:SetToolTip(newItem.name)
            icon.itemStack = item:getCount()

            rp.gui.craftable.itemsCrafting[x] = icon
        end

        if !icon.items then
            icon.items = {}
        end
        icon.items[newItem.id] = newItem

        icon.ExtraPaint = function(this_ic, w, h)
            local invv = LocalPlayer():getInv();
            local itemCount = invv:getItemCount(this_ic.itemTable.uniqueID, true)

            if itemCount >= this_ic.itemStack then
                surface.SetDrawColor(0, 255, 0, 20)
                surface.DrawRect( 0, 0, w, h );
            else
                surface.SetDrawColor(255, 0, 0, 20)
                surface.DrawRect( 0, 0, w, h );
            end
        end

        self:CheckRecipes()
        self:BacklightItemUsed()
    end
end

function PANEL:onTransfer(oldX, oldY, x, y, oldInventory, noSend)
    local inventory = rp.item.inventories[oldInventory.invID]
    local inventory2 = rp.item.inventories[self.invID]
    local item

    if (inventory) then
        item = inventory:getItemAt(oldX, oldY)

        if (!item) then
            return false
        end

        if item.notCanGive and oldInventory.invID == LocalPlayer():getInv():getID() and self.invID != oldInventory.invID then return false end

        if inventory2.id == "craftable" && inventory.id != "result" then
            if IsValid(rp.gui.craftable) then
                surface.PlaySound(soundclick.addItemCrafting)
                self:AddItemCrafting(inventory2, item)
            end
            return false
        elseif inventory2.id == "result" then
            return false
        end

        surface.PlaySound(soundclick.movedItem)

        if (hook.Run("CanItemBeTransfered", item, rp.item.inventories[oldInventory.invID], rp.item.inventories[self.invID]) == false) then
            return false, "notAllowed"
        end

        if (item.onCanBeTransfered and item:onCanBeTransfered(inventory, inventory != inventory2 and inventory2 or nil) == false) then
            return false
        end

        if inventory ~= inventory2 then
            if rp.item.list[inventory2.vars.isBag] then
                if rp.item.list[inventory2.vars.isBag].notTransfered then
                    rp.Notify(1, translates.Get("В эту сумку нельзя ничего положить!"))
                    return false
                end
            end
        end
    end

    if (!noSend) then
        if (self != oldInventory) then
            netstream.Start("invMv", oldX, oldY, x, y, oldInventory.invID, self.invID)
        else
            netstream.Start("invMv", oldX, oldY, x, y, oldInventory.invID)
        end
    end

    if (inventory) then
        inventory.slots[oldX][oldY] = nil

        if inventory:IsEmpty() and oldInventory.invID ~= LocalPlayer():getInv():getID() then
            local status = hook.Run( "ShouldCloseEmptyInventoryUI", inventory );
            if status == false then return end

            if IsValid(rp.LootInventory.Panels.InventoryMenu) then
                rp.LootInventory.Panels.InventoryMenu.Remove(rp.LootInventory.Panels.InventoryMenu)
            end

            if IsValid(rp.Inventory.Panels.InventoryMenu) then
                rp.Inventory.Panels.InventoryMenu.Remove(rp.Inventory.Panels.InventoryMenu)
            end
        end
    end

    if (item and inventory2) then
        inventory2.slots[x] = inventory2.slots[x] or {}
        inventory2.slots[x][y] = item
    end
end

function PANEL:addIcon(model, xf, yf, w, h, skin, icon_override)
    w = w or 1
    h = h or 1

    if (self.slots[xf] and self.slots[xf][yf]) then
        local panel = self:Add("rpui.ItemIcon")
        panel:SetSize(w * self.widthFrame + (self.spacingFrame * (w - 1)), h * self.heightFrame + (self.spacingFrame * (h - 1)))
        panel:SetZPos(999)
        panel:InvalidateLayout(true)

		if icon_override then
			panel.Icon.SetVisible(panel.Icon, false)
			--panel:SetImage(icon_override)
			local my_mat = Material(icon_override)
			panel.ExtraPaint = function(self111, xvv, yvv)
                surface.SetMaterial(my_mat)
                surface.SetDrawColor(color_white)
                surface.DrawTexturedRect(0, 0, xvv, yvv)
			end
		else
			panel:SetModel(model, skin)
		end

        panel:SetPos(self.slots[xf][yf].GetPos(self.slots[xf][yf]))
        panel.gridX = xf
        panel.gridY = yf
        panel.gridW = w
        panel.gridH = h

        local inventory = rp.item.inventories[self.invID]

        if (!inventory) then
            return
        end

        panel.inv = inventory

        local itemTable = inventory:getItemAt(panel.gridX, panel.gridY)
        panel.itemTable = itemTable

        if !itemTable then return end

        if (self.panels[itemTable:getID()]) then
            self.panels[itemTable:getID()].Remove(self.panels[itemTable:getID()])
        end

        if (itemTable.exRender) then
            panel.Icon.SetVisible(panel.Icon, false)
            panel.ExtraPaint = function(self1, xv, yv)
                local exIcon = ikon:getIcon(itemTable.uniqueID)
                if (exIcon) then
                    surface.SetMaterial(exIcon)
                    surface.SetDrawColor(color_white)
                    surface.DrawTexturedRect(0, 0, xv, yv)
                else
                    ikon:renderIcon(
                        itemTable.uniqueID,
                        itemTable.width,
                        itemTable.height,
                        itemTable.model,
                        itemTable.iconCam
                    )
                end
            end
        else
            renderNewIcon(panel, itemTable)
        end

        panel.move = function(this, data, inventory, noSend)
            local oldX, oldY = this.gridX, this.gridY
            local oldParent = this:GetParent()

            if (inventory:onTransfer(oldX, oldY, data.x2, data.y2, oldParent, noSend) == false) then
                return
            end

            data.x = data.x or (data.x2 - 1)*self.widthFrame
            data.y = data.y or (data.y2 - 1)*self.heightFrame

            this.gridX = data.x2
            this.gridY = data.y2
            this.invID = inventory.invID
            this:SetParent(inventory)
            this:SetPos(data.x, data.y)

            if (this.slots) then
                for k10, v10 in ipairs(this.slots) do
                    if (IsValid(v10) and v10.item == this) then
                        v10.item = nil
                    end
                end
            end

            this.slots = {}

            for xa = 1, this.gridW do
                for ya = 1, this.gridH do
                    local slot = inventory.slots[this.gridX + xa-1][this.gridY + ya-1]

                    slot.item = this
                    this.slots[#this.slots + 1] = slot
                end
            end
        end
        panel.OnMouseReleased = function(this, code)
            if ((code == MOUSE_LEFT or code == MOUSE_RIGHT) and rp.item.held == this) then
                local data = this.dropPos

                if (CurTime()-this.IsDraggingTime) < 0.1 then
                    this:actionsMenu()
                end

                this:DragMouseRelease(code)
                this:MouseCapture(false)
                this:SetZPos(99)

                rp.item.held = nil

                if (table.Count(activePanels) == 0) then
                    local item = this.itemTable
                    local inv = this.inv

                    if (item and inv) then
                        netstream.Start("invAct", "drop", item.id, inv:getID(), item.id)
                    end

                    return false
                end
                activePanels = {}

                if (data) then
                    local inventory = table.GetFirstKey(data)

                    if (IsValid(inventory)) then
                        data = data[inventory]

                        if (IsValid(data.item)) then
                            inventory = panel.inv

                            if (inventory) then
                                local targetItem = data.item.itemTable

                                if (targetItem) then
                                    if (targetItem.id == itemTable.id) then return end
                                    if data.item.itemTable.uniqueID != this.itemTable.uniqueID then return end

                                    if (itemTable.functions) then
                                        local combine = itemTable.functions.combine

                                        if (combine) then
                                            itemTable.player = LocalPlayer()

                                            if (combine.onCanRun and (combine.onCanRun(itemTable, targetItem.id) != false)) then
                                                netstream.Start("invAct", "combine", itemTable.id, inventory:getID(), targetItem.id)
                                            end

                                            itemTable.player = nil
                                        end
                                    end
                                end
                            end
                        else
                            local oldX, oldY = this.gridX, this.gridY

                            if code == MOUSE_RIGHT && this.itemTable.getCount(this.itemTable) > 1 then
                                local par = this:GetParent();
                                netstream.Start("invMv", oldX, oldY, data.x2, data.y2, par.invID, "disagreement")
                                return
                            end

                            if (oldX != data.x2 or oldY != data.y2 or inventory != self) then
                                if inventory != self and rp.item.inventories[inventory.invID] and rp.item.inventories[inventory.invID].vars and rp.item.inventories[inventory.invID].vars.isBag == 'ent_shop' then
                                    --data.item.itemTable.moveCallback(data, self, inventory, function()

                                    local menu1, menu2
                                    menu1 = rpui.SliderRequestFree("Назначьте цену за предмет", "rpui/donatemenu/money", 1.5, rp.cfg.StartMoney * 100, function(val1)
                                        menu1:Remove()

                                        local items_count = this.itemTable.getCount(this.itemTable)

                                        if items_count > 1 then
                                            menu2 = rpui.SliderRequestFree("Выберите количество предметов на продажу", "rpui/donatemenu/money", 1.5, items_count, function(val2)
                                                val2 = math.min(val2, items_count)

                                                menu2:Remove()

                                                netstream.Start("invShopAdd", oldX, oldY, data.x2, data.y2, this:GetParent().invID, inventory.invID, val1, val2)
                                            end)
                                        else
                                            netstream.Start("invShopAdd", oldX, oldY, data.x2, data.y2, this:GetParent().invID, inventory.invID, val1, 1)
                                        end
                                    end)

                                    --end)
                                else
                                    this:move(data, inventory)
                                end
                            end
                        end
                    end
                end
            end
        end
        panel.OnMousePressed = function(this, code)
            local part = this:GetParent();
            if part.noCanMove then
                return
            end

            if self.invID == "craftable" then
                surface.PlaySound(soundclick.removeItemCrafting)
                self:RemoveItemCrafting(table.Random(this.items), this)
                return
            end
            if (code == MOUSE_LEFT) then
                this:DragMousePress(code)
                this:MouseCapture(true)

                this.IsDraggingTime = CurTime()

                local local_func6 = function()
                    if not IsValid(this.actionsMenuActive) then
                        surface.PlaySound(soundclick.leftClick)
                    end
                end

                timer.Simple(0.1, local_func6)

                rp.item.held = this
            elseif (code == MOUSE_RIGHT and this.doRightClick) then
                if rp.item.inventories[self.invID] and rp.item.inventories[self.invID].vars and rp.item.inventories[self.invID].vars.isBag == 'ent_shop' then
                    return
                end

                this:doRightClick()
            end
        end
        panel.doRightClick = function(this)
            if self.invID == "craftable" then
                surface.PlaySound(soundclick.removeItemCrafting)
                self:RemoveItemCrafting(table.Random(this.items), this)
                return
            end
            local count = this.itemTable.getCount(this.itemTable)
            if count > 1 then
                this:DragMousePress(MOUSE_RIGHT)
                this:MouseCapture(true)

                this.IsDraggingTime = CurTime()

                rp.item.held = this

                local local_func7 = function()
                    if not IsValid(this.actionsMenuActive) then
                        surface.PlaySound(soundclick.rightClick)
                    end
                end

                timer.Simple(0.1, local_func7)
            else
                this:actionsMenu()
            end
        end
        panel.actionsMenu = function(this)
            if (itemTable) then
                surface.PlaySound(soundclick.clickMenu)
                itemTable.player = LocalPlayer()
                    local menu = DermaMenu()
                    this.actionsMenuActive = menu
                    local override = hook.Run("OnCreateItemInteractionMenu", panel, menu, itemTable)

                    if (override == true) then if (menu.Remove) then menu:Remove() end return end

                        for k11, v11 in SortedPairs(itemTable.functions) do
                            if (k11 == "combine") then continue end

                            if (v11.onCanRun) then
                                if (v11.onCanRun(itemTable) == false) then
                                    itemTable.player = nil

                                    continue
                                end
                            end

                            if (v11.isRequirePlayersNear) then
                                local PlayersNear = 0;

                                for k12, v12 in pairs(ents.FindInSphere(LocalPlayer():GetPos(), v11.isRequirePlayersNear)) do
                                    if (IsValid(v12) and v12:IsPlayer() and v12 != LocalPlayer() and !v12:IsBot()) then
                                        PlayersNear = PlayersNear + 1;
                                    end
                                end

                                if (PlayersNear < 1) then continue end
                            end

                            if (v11.isMulti) then
                                local local_func8 = function()
                                    itemTable.player = LocalPlayer()
                                        local send = true

                                        if (v11.onClick) then
                                            send = v11.onClick(itemTable)
                                        end

                                        if (v11.sound) then
                                            surface.PlaySound(v11.sound)
                                        end

                                        if (send != false) then
                                            netstream.Start("invAct", k11, itemTable.id, self.invID)
                                        end
                                    itemTable.player = nil
                                end

                                local subMenu, subMenuOption = menu:AddSubMenu((v11.name or k11), local_func8)
                                subMenuOption:SetImage(v11.icon or "icon16/brick.png")

                                if (v11.multiOptions) then
                                    local options = isfunction(v11.multiOptions) and v11.multiOptions(itemTable, LocalPlayer()) or v11.multiOptions

                                    for _, sub in pairs(options) do
                                        local local_func4 = function()
                                            itemTable.player = LocalPlayer()
                                                local send = true

                                                if (v11.onClick) then
                                                    send = v11.onClick(itemTable)
                                                end

                                                if (v11.sound) then
                                                    surface.PlaySound(v11.sound)
                                                end

                                                if (send != false) then
                                                    netstream.Start("invAct", k11, itemTable.id, self.invID, sub.data)
                                                end
                                            itemTable.player = nil
                                        end

                                        subMenu:AddOption((sub.name or "subOption"), local_func4)
                                    end
                                end
                                if v11.isSelectPlayers then
                                    for _, subt in pairs(player.GetAll()) do
                                        local ppos = subt:GetPos();
                                        if !IsValid(subt) || subt == LocalPlayer() || ppos:Distance(LocalPlayer():GetPos()) > 200 then continue end

                                        local local_func3 = function()
                                            if (v11.onClick) then
                                                v11.onClick(LocalPlayer(), subt, itemTable)
                                            end
                                        end

                                        subMenu:AddOption(subt:Name(), local_func3)
                                    end
                                end
                            else
                            local local_func1 = function()
                                itemTable.player = LocalPlayer()
                                local send = true

                                if (v11.confirm) then
                                    local local_func5 = function()
                                        local NewMenu = DermaMenu();
                                        local opt = NewMenu:AddOption(translates.Get('Подтвердите действие.'));
                                        opt:SetImage('icon16/exclamation.png');
                                        NewMenu:AddSpacer();

                                        local local_func2 = function()
                                            itemTable.player = LocalPlayer()
                                            local send = true

                                            if (v11.onClick) then
                                                send = v11.onClick(itemTable)
                                            end

                                            if (v11.sound) then
                                                surface.PlaySound(v11.sound)
                                            end

                                            if (send != false) then
                                                netstream.Start("invAct", k11, itemTable.id, self.invID)
                                            end

                                            itemTable.player = nil
                                        end

                                        NewMenu:AddOption(translates.Get('Подтвердить'), local_func2);
                                        NewMenu:Open();
                                    end

                                    timer.Simple(0, local_func5);
                                    return
                                end

                                if (v11.onClick) then
                                    send = v11.onClick(itemTable)
                                end

                                if (v11.sound) then
                                    surface.PlaySound(v11.sound)
                                end

                                if (send != false) then
                                    netstream.Start("invAct", k11, itemTable.id, self.invID)
                                end

                                itemTable.player = nil
                            end

                            local popt = menu:AddOption((v11.name or k11), local_func1)
                            popt:SetImage(v11.icon or "icon16/brick.png")
                        end
                    end

                    menu:Open()
                itemTable.player = nil
            end
        end

        panel.slots = {}

        for i = 0, w - 1 do
            for i2 = 0, h - 1 do
                local slot = self.slots[xf + i] and self.slots[xf + i][yf + i2]

                if (IsValid(slot)) then
                    slot.item = panel
                    panel.slots[#panel.slots + 1] = slot
                else
                    for k15, v15 in ipairs(panel.slots) do
                        v15.item = nil
                    end

                    panel:Remove()

                    return
                end
            end
        end

        return panel
    end
end

vgui.Register( "rpui.Inventory", PANEL, "Panel" );
