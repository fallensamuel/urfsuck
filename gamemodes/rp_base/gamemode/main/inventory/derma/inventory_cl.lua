rp.gui = {}
-- The queue for the rendered icons.
renderdIcons = renderdIcons or {}

-- To make making inventory variant, This must be followed up.
function renderNewIcon(panel, itemTable)
    -- re-render icons
    if ((itemTable.iconCam and !renderdIcons[string.lower(itemTable.model)]) or itemTable.forceRender) then
        local iconCam = itemTable.iconCam
        iconCam = {
            cam_pos = iconCam.pos,
            cam_ang = iconCam.ang,
            cam_fov = iconCam.fov,
        }
        renderdIcons[string.lower(itemTable.model)] = true
        
        panel.Icon:RebuildSpawnIconEx(
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
end

local white_col = Color(255, 255, 255)
local piz_colrs = Color(116, 81, 61, 255)

function PANEL:PaintOver(w, h)
    local itemTable = rp.item.instances[self.itemID]

    if rp.item.icons then
        local ico = rp.item.icons[self.itemID]
        if ico then
            surface.SetMaterial(ico)
            surface.SetDrawColor(itemTable.data["pizza_col"] and piz_colrs or white_col)
            surface.DrawTexturedRect(0, 0, w, h)
        end
    end

    if (self.waiting and self.waiting > CurTime()) then
        local wait = (self.waiting - CurTime()) / self.waitingTime
        surface.SetDrawColor(255, 255, 255, 100*wait)
        surface.DrawRect(2, 2, w - 4, h - 4)
    end

    if (itemTable and itemTable.paintOver) then
        local w, h = self:GetSize()

        itemTable.paintOver(self, itemTable, w, h)
    end

    local count
    if itemTable and rp.item.instances[self.itemTable.id] then
        count = rp.item.instances[self.itemTable.id]:getCount()
    end
    if self.itemStack then
        count = self.itemStack
    end

    if count and count > 1 then
        draw.SimpleTextOutlined("x"..count, 'rp.ui.20', w-5, h-11, rp.col.White, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, 1, rp.col.Black)
    end
end

function PANEL:ExtraPaint(w, h)
    if self.isUsed then
        surface.SetDrawColor(255,255,0,20)
        surface.DrawRect(2, 4, w - 4, h - 5)
    end
end

function PANEL:Paint(w, h)
    local parent = self:GetParent()

    surface.SetDrawColor(0, 0, 0, 85)
    surface.DrawRect(2, 2, w - 4, h - 4)

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

function PANEL:SetModel( mdl, iSkin, BodyGroups )
    if ( !mdl ) then debug.Trace() return end

    self:SetModelName( mdl )
    self.setmdl_cache = {mdl, iSkin, BodyGroups}

    self:SetSkinID( iSkin or 0 )

    if ( tostring( BodyGroups ):len() != 9 ) then
        BodyGroups = "000000000"
    end

    self.m_strBodyGroups = BodyGroups

    self.Icon:SetModel(mdl, iSkin, BodyGroups)

    if ( iSkin && iSkin > 0 ) then
        self:SetTooltip( Format( "%s (Skin %i)", mdl, iSkin + 1 ) )
    else
        self:SetTooltip( Format( "%s", mdl ) )
    end
end

function PANEL:Think()
	if self.NextThnk and self.NextThnk > CurTime() then return end
	
    if self.setmdl_cache then
        if util.IsValidModel(self.setmdl_cache[1]) then --self.Icon:GetModel()) then
            self.Think = function() end
        else
            self:SetModel(unpack(self.setmdl_cache))
        end
    end

    self.NextThnk = CurTime() + 1
end

vgui.Register("ItemIcon", PANEL, "SpawnIcon")

PANEL = {}
    function PANEL:Init()
        --self:MakePopup()
        self:ShowCloseButton(true)
        self:SetDraggable(true)
        self:SetTitle(translates.Get("Инвентарь"))
        self:SetSkin('SUP')
        self.btnMaxim:Hide()
        self.btnMinim:Hide()
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
    end
        
    function PANEL:OnRemove()
        if (self.childPanels) then
            for k, v in ipairs(self.childPanels) do
                if (v != self) then
                    v:Remove()
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
        if (inventory.slots) then
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
                    --local item = rp.item.list[data.uniqueID]
                    if (item && !IsValid(self.panels[item.id])) then
                        local icon = self:addIcon(item.model or "models/props_junk/popcan01a.mdl", data.gridX, data.gridY, item.width, item.height, item.skin or 0)

                        if (IsValid(icon)) then
                            local newTooltip = hook.Run("OverrideItemTooltip", self, data, item)

                            if (newTooltip) then
                                icon:SetToolTip(newTooltip)
                            else
                                icon:SetToolTip(item:getName(), item:getDesc() or "")
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

        self:SetSize(w * self.widthFrame + 8, h * self.heightFrame + 31)

        if self.IsCentered then
            self.addX = (self.addX - (w * self.widthFrame + 8)) / 2
        else
            self.addX = 0
        end

        self:buildSlots()
    end
    
    function PANEL:buildSlots()
        self.slots = self.slots or {}

        local function PaintSlot(slot, w, h)
            surface.SetDrawColor(35, 35, 35, 85)
            surface.DrawRect(1, 1, w - 2, h - 2)
            
            surface.SetDrawColor(0, 0, 0, 250)
            surface.DrawOutlinedRect(1, 1, w - 2, h - 2)
        end
        
        for k, v in ipairs(self.slots) do
            for k2, v2 in ipairs(v) do
                v2:Remove()
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
                slot:SetPos(self.addX + (x - 1) * self.widthFrame + 4, (y - 1) * self.heightFrame + 27)
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

            for k,v in pairs(activePanels) do
                if k.invID == "craftable" then
                    gridW = 1
                    gridH = 1
                end
            end

            local mouseX, mouseY = self:LocalCursorPos()
            mouseX = mouseX - self.addX
            local dropX, dropY = math.ceil((mouseX - 4 - (gridW - 1) * 32) / self.widthFrame), math.ceil((mouseY - 27 - (gridH - 1) * 32) / self.heightFrame)

            if ((mouseX < -w*0.05 or mouseX > w*1.05) or (mouseY < h*0.05 or mouseY > h*1.05)) then
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
                    local x2, y2 = dropX + x, dropY + y
                
                    -- Is Drag and Drop icon is in the Frame?
                    if (self.slots[x2] and IsValid(self.slots[x2][y2])) then
                        local bool = self:isEmpty(x2, y2, item)
                        
                        surface.SetDrawColor(0, 0, 255, 10)

                        if (x == 0 and y == 0) then
                            item.dropPos[self] = {x = self.addX + (x2 - 1)*self.widthFrame + 4, y = (y2 - 1)*self.heightFrame + 27, x2 = x2, y2 = y2}
                        end
                            
                        if (bool) then
                            surface.SetDrawColor(0, 255, 0, 10)
                        else
                            surface.SetDrawColor(255, 255, 0, 10)
                            
                            if (self.slots[x2] and self.slots[x2][y2] and item.dropPos[self]) then
                                item.dropPos[self].item = self.slots[x2][y2].item
                            end
                        end
                                
                        surface.DrawRect(self.addX + (x2 - 1)*self.widthFrame + 4, (y2 - 1)*self.heightFrame + 27, self.widthFrame, self.heightFrame)
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
        return (!IsValid(self.slots[x][y].item) or self.slots[x][y].item == this)
    end

    function PANEL:BacklightItemUsed()
        for n,b in pairs(rp.gui.inv1.panels or {}) do
            if IsValid(b) then
                b.isUsed = false
            end
        end
        for k,v in pairs(rp.gui.craftable.itemsCrafting or {}) do
            if IsValid(v) then
                for c,d in pairs(v.items) do
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
        if IsValid(rp.gui.result.itemRecipe) then rp.gui.result.itemRecipe:Remove() end
        if rp.gui.craftable.itemsCrafting then
            for k,v in pairs(rp.gui.craftable.itemsCrafting) do
                if IsValid(v) then 
                    v.itemStack = 0
                    self:RemoveItemCrafting(nil, v)
                end
            end
            rp.gui.craftable.itemsCrafting = {}
        end
    end

    function PANEL:CheckRecipes(name)
        if IsValid(rp.gui.result.itemRecipe) then rp.gui.result.itemRecipe:Remove() end
        if timer.Exists("InventoryCraftingTimer") then timer.Destroy("InventoryCraftingTimer") end
        for k,v in pairs(rp.item.recipes) do
            if name and k ~= name then
                continue
            end

            local inventory2 = rp.item.inventories["result"]

            local isCan = true

            for c,d in pairs(v.instruments) do
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

            for c,d in pairs(v.items) do
                local count = 0
                for t,u in pairs(rp.gui.craftable.itemsCrafting) do
                    if IsValid(u) then
                        if u.itemTable.uniqueID == d.item.uniqueID then
                            count = u.itemStack
                        end
                    end
                end
                if count < d.count || count > d.count then
                    isCan = false
                end 
            end

            for t,u in pairs(rp.gui.craftable.itemsCrafting) do
                if !IsValid(u) then continue end
                local isFound = false
                for c,d in pairs(v.items) do
                    if u.itemTable.uniqueID == d.item.uniqueID then
                        isFound = true
                    end
                end
                for c,d in pairs(v.instruments) do
                    if u.itemTable.uniqueID == d.uniqueID then
                        isFound = true
                    end
                end
                if !isFound then
                    isCan = false
                end
            end

            rp.gui.craftButton:CanCraftItem(k)

            if isCan then
                local x = 1
                local y = 1
                local newItem = table.Copy(v.result)

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

                rp.gui.result.itemRecipe = rp.gui.result:addIcon(v.result.model, 1, 1, 2, 2, 0)
                rp.gui.result.itemRecipe:SetToolTip(v.result.name)
                rp.gui.result.recipe = k
                rp.gui.result.noCanMove = true

                rp.gui.craftButton:CanCraftItem(k)

                function rp.gui.result.itemRecipe:ExtraPaint(w, h)
                    local isCan, items = rp.IsCanCraftItem(LocalPlayer():getInv(), rp.item.recipes[rp.gui.result.recipe])
                    if isCan then
                        surface.SetDrawColor(0, 255, 0, 20)
                        surface.DrawRect(2, 4, w - 4, h - 5)
                    else
                        surface.SetDrawColor(255, 0, 0, 20)
                        surface.DrawRect(2, 4, w - 4, h - 5)
                    end
                end

                break
            end
        end
    end

    function PANEL:AddItemCrafting(inv, item)
        local x,y,bagInv = inv:findEmptySlot(1, 1)
        if x and y then
            if !rp.gui.craftable.itemsCrafting then
                rp.gui.craftable.itemsCrafting = {}
            end

            local newItem = table.Copy(item)
            newItem.id = item.id != 0 and item.id or math.Rand(-100, -1)

            local icon
            for k,v in pairs(rp.gui.craftable.itemsCrafting) do
                if IsValid(v) then
                    if v.itemTable.uniqueID == newItem.uniqueID then
                        icon = v
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

                icon = rp.gui.craftable:addIcon(newItem.model, x, y, 1, 1, 0)
                icon:SetToolTip(newItem.name)
                icon.itemStack = item:getCount()

                rp.gui.craftable.itemsCrafting[x] = icon
            end

            if !icon.items then
                icon.items = {}
            end
            icon.items[newItem.id] = newItem

            function icon:ExtraPaint(w, h)
                local itemCount = LocalPlayer():getInv():getItemCount(self.itemTable.uniqueID, true)

                if itemCount >= self.itemStack then
                    surface.SetDrawColor(0, 255, 0, 20)
                    surface.DrawRect(2, 4, w - 4, h - 5)
                else
                    surface.SetDrawColor(255, 0, 0, 20)
                    surface.DrawRect(2, 4, w - 4, h - 5)
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
        end

        if (item and inventory2) then
            inventory2.slots[x] = inventory2.slots[x] or {}
            inventory2.slots[x][y] = item
        end

        gui.EnableScreenClicker(true);
    end

    function PANEL:addIcon(model, x, y, w, h, skin)
        w = w or 1
        h = h or 1

        if (self.slots[x] and self.slots[x][y]) then
            local panel = self:Add("ItemIcon")
            panel:SetSize(w * self.widthFrame, h * self.heightFrame)
            panel:SetZPos(999)
            panel:InvalidateLayout(true)
            panel:SetModel(model, skin)
            panel:SetPos(self.slots[x][y]:GetPos())
            panel.gridX = x
            panel.gridY = y
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
                self.panels[itemTable:getID()]:Remove()
            end
            
            if (itemTable.exRender) then
                panel.Icon:SetVisible(false)
                panel.ExtraPaint = function(self, x, y)
                    local exIcon = ikon:getIcon(itemTable.uniqueID)
                    if (exIcon) then
                        surface.SetMaterial(exIcon)
                        surface.SetDrawColor(color_white)
                        surface.DrawTexturedRect(0, 0, x, y)
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
                -- yeah..
                renderNewIcon(panel, itemTable)
            end

            panel.move = function(this, data, inventory, noSend)
                local oldX, oldY = this.gridX, this.gridY
                local oldParent = this:GetParent()

                if (inventory:onTransfer(oldX, oldY, data.x2, data.y2, oldParent, noSend) == false) then
                    return
                end

                data.x = data.x or (data.x2 - 1)*self.widthFrame + 4
                data.y = data.y or (data.y2 - 1)*self.heightFrame + 27

                this.gridX = data.x2
                this.gridY = data.y2
                this.invID = inventory.invID
                this:SetParent(inventory)
                this:SetPos(data.x, data.y)

                if (this.slots) then
                    for k, v in ipairs(this.slots) do
                        if (IsValid(v) and v.item == this) then
                            v.item = nil
                        end
                    end
                end
                
                this.slots = {}

                for x = 1, this.gridW do
                    for y = 1, this.gridH do
                        local slot = inventory.slots[this.gridX + x-1][this.gridY + y-1]

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
                                        -- to make sure...
                                        if (targetItem.id == itemTable.id) then return end
                                        if data.item.itemTable.uniqueID != this.itemTable.uniqueID then return end

                                        if (itemTable.functions) then
                                            local combine = itemTable.functions.combine

                                            -- does the item has the combine feature?
                                            if (combine) then
                                                itemTable.player = LocalPlayer()

                                                -- canRun == can item combine into?
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

                                if code == MOUSE_RIGHT && this.itemTable:getCount() > 1 then
                                    netstream.Start("invMv", oldX, oldY, data.x2, data.y2, this:GetParent().invID, "disagreement")
                                    return
                                end

                                if (oldX != data.x2 or oldY != data.y2 or inventory != self) then                                   
                                    this:move(data, inventory)
                                end
                            end
                        end
                    end
                end
            end
            panel.OnMousePressed = function(this, code)
                if this:GetParent().noCanMove then
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

                    timer.Simple(0.1, function()
                        if not IsValid(this.actionsMenuActive) then
                            surface.PlaySound(soundclick.leftClick)
                        end
                    end)

                    rp.item.held = this
                elseif (code == MOUSE_RIGHT and this.doRightClick) then
                    this:doRightClick()
                end
            end
            panel.doRightClick = function(this)
                if self.invID == "craftable" then
                    surface.PlaySound(soundclick.removeItemCrafting)
                    self:RemoveItemCrafting(table.Random(this.items), this)
                    return
                end
                local count = this.itemTable:getCount()
                if count > 1 then
                    this:DragMousePress(MOUSE_RIGHT)
                    this:MouseCapture(true)

                    this.IsDraggingTime = CurTime()

                    rp.item.held = this

                    timer.Simple(0.1, function()
                        if not IsValid(this.actionsMenuActive) then
                            surface.PlaySound(soundclick.rightClick)
                        end
                    end)
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

                            for k, v in SortedPairs(itemTable.functions) do
                                if (k == "combine") then continue end -- we don't need combine on the menu mate. 

                                if (v.onCanRun) then
                                    if (v.onCanRun(itemTable) == false) then
                                        itemTable.player = nil

                                        continue
                                    end
                                end

                                if (v.isRequirePlayersNear) then
                                    local PlayersNear = 0;

                                    for k, v in pairs(ents.FindInSphere(LocalPlayer():GetPos(), v.isRequirePlayersNear)) do
                                        if (IsValid(v) and v:IsPlayer() and v != LocalPlayer() and !v:IsBot()) then
                                            PlayersNear = PlayersNear + 1;
                                        end
                                    end

                                    if (PlayersNear < 1) then continue end
                                end

                                -- is Multi-Option Function
                                if (v.isMulti) then
                                    local subMenu, subMenuOption = menu:AddSubMenu((v.name or k), function()
                                        itemTable.player = LocalPlayer()
                                            local send = true

                                            if (v.onClick) then
                                                send = v.onClick(itemTable)
                                            end

                                            if (v.sound) then
                                                surface.PlaySound(v.sound)
                                            end

                                            if (send != false) then
                                                netstream.Start("invAct", k, itemTable.id, self.invID)
                                            end
                                        itemTable.player = nil
                                    end)
                                    subMenuOption:SetImage(v.icon or "icon16/brick.png")

                                    if (v.multiOptions) then
                                        local options = isfunction(v.multiOptions) and v.multiOptions(itemTable, LocalPlayer()) or v.multiOptions

                                        for _, sub in pairs(options) do
                                            subMenu:AddOption((sub.name or "subOption"), function()
                                                itemTable.player = LocalPlayer()
                                                    local send = true

                                                    if (v.onClick) then
                                                        send = v.onClick(itemTable)
                                                    end

                                                    if (v.sound) then
                                                        surface.PlaySound(v.sound)
                                                    end

                                                    if (send != false) then
                                                        netstream.Start("invAct", k, itemTable.id, self.invID, sub.data)
                                                    end
                                                itemTable.player = nil
                                            end)
                                        end
                                    end
                                    if v.isSelectPlayers then
                                        for _, sub in pairs(player.GetAll()) do
                                            if !IsValid(sub) || sub == LocalPlayer() || sub:GetPos():Distance(LocalPlayer():GetPos()) > 200 then continue end
                                            subMenu:AddOption(sub:Name(), function()
                                                if (v.onClick) then
                                                    v.onClick(LocalPlayer(), sub, itemTable)
                                                end
                                            end)
                                        end
                                    end
                                else
                                    menu:AddOption((v.name or k), function()
                                        itemTable.player = LocalPlayer()
                                            local send = true

                                            if (v.confirm) then
                                                timer.Simple(0, function()
                                                    local NewMenu = DermaMenu();
                                                    NewMenu:AddOption(translates.Get('Подтвердите действие.')):SetImage('icon16/exclamation.png');
                                                    NewMenu:AddSpacer();
                                                    NewMenu:AddOption(translates.Get('Подтвердить'), function()
                                                        itemTable.player = LocalPlayer()
                                                        local send = true

                                                        if (v.onClick) then
                                                            send = v.onClick(itemTable)
                                                        end

                                                        if (v.sound) then
                                                            surface.PlaySound(v.sound)
                                                        end

                                                        if (send != false) then
                                                            netstream.Start("invAct", k, itemTable.id, self.invID)
                                                        end
                                                        itemTable.player = nil
                                                    end);
                                                    NewMenu:Open();
                                                end);
                                                return
                                            end

                                            if (v.onClientRun) then
                                                v.onClientRun(itemTable)
                                            end

                                            if (v.onClick) then
                                                send = v.onClick(itemTable)
                                            end

                                            if (v.sound) then
                                                surface.PlaySound(v.sound)
                                            end

                                            if (send != false) then
                                                netstream.Start("invAct", k, itemTable.id, self.invID)
                                            end
                                        itemTable.player = nil
                                    end):SetImage(v.icon or "icon16/brick.png")
                                end
                            end
                        menu:Open()
                    itemTable.player = nil
                end
            end
            
            panel.slots = {}
            
            for i = 0, w - 1 do
                for i2 = 0, h - 1 do
                    local slot = self.slots[x + i] and self.slots[x + i][y + i2]

                    if (IsValid(slot)) then
                        slot.item = panel
                        panel.slots[#panel.slots + 1] = slot
                    else
                        for k, v in ipairs(panel.slots) do
                            v.item = nil
                        end

                        panel:Remove()

                        return
                    end
                end
            end
            
            return panel
        end
    end
vgui.Register("Inventory", PANEL, "DFrame")

local math_Clamp = math.Clamp
local math_floor = math.floor
local math_Approach = math.Approach
local math_sin = math.sin
local surface_SetDrawColor = surface.SetDrawColor
local surface_DrawRect = surface.DrawRect
local draw_SimpleText = draw.SimpleText

local old_menu = false
local invmenu_delay = 0

rp.Inventory = rp.Inventory or {}
rp.Inventory.Panels = rp.Inventory.Panels or {}

hook.Add("rp.OpenInventory", "rp.OpenInventory", function(force)
    if hook.Run("CanPlayerViewInventory") == false then return end
    --if g_ContextMenu:IsMouseInputEnabled() then return end

    if old_menu then
        if IsValid(rp.gui.inv1) then
            rp.gui.inv1:Close()
        end

        rp.gui.inv1 = vgui.Create("Inventory")
        rp.gui.inv1.childPanels = {}
        gui.EnableScreenClicker(true)
        local count = 0

        for k, v in pairs(rp.gui) do
            if IsValid(v) then
                count = count + 1
            end
        end

        local inventory = LocalPlayer():getInv()

        if (inventory) then
            rp.gui.inv1:setInventory(inventory)
        end

        if count == 2 then
            rp.gui.inv1:SetPos(ScrW() / 2 - rp.gui.inv1:GetWide() - 15, ScrH() / 2 - rp.gui.inv1:GetTall() / 2)
        else
            rp.gui.inv1:SetPos(ScrW() / 2 - rp.gui.inv1:GetWide() / 2, ScrH() / 2 - rp.gui.inv1:GetTall() / 2)
        end

        return
    else
        if invmenu_delay > CurTime() then return end
        invmenu_delay = CurTime() + 0.1

        if IsValid(rp.Inventory.Panels.InventoryMenu) then
            rp.Inventory.Panels.InventoryMenu:Remove()
            if not force then
                return
            end
        end

        rp.Inventory.Panels.InventoryMenu = vgui.Create("DPanel")
        rp.Inventory.Panels.InventoryMenu:MakePopup()
        rp.Inventory.Panels.InventoryMenu:Center()
        --rp.Inventory.Panels.InventoryMenu:SetAlpha(0)
        --rp.Inventory.Panels.InventoryMenu:AlphaTo(255, 0.01, 0)

        --rp.Inventory.Panels.InventoryMenu.Think = function(this)
        --    if g_ContextMenu:IsMouseInputEnabled() then
        --        this:Remove()
        --        return
        --    end
        --end

        rp.Inventory.Panels.InventoryMenu.Paint = function(this, w, h)
            draw.Blur(this)
            surface.SetDrawColor(rpui.UIColors.Background) -- rpui.UIColors.Background
            surface.DrawRect(0, 0, w, h)

            if input.IsKeyDown(KEY_X) and IsValid(rp.Inventory.Panels.CloseButton) then
                rp.Inventory.Panels.CloseButton.DoClick(rp.Inventory.Panels.CloseButton)
            end

            if input.IsKeyDown(KEY_ESCAPE) then
                this:Remove()
            end
        end

        local frameW, frameH = rp.Inventory.Panels.InventoryMenu:GetSize()

        rp.Inventory.Panels.InventoryMenu.UIColors = {
            Blank       = Color(0, 0, 0, 0),
            White       = Color(255, 255, 255, 255),
            Black       = Color(0, 0, 0, 255),
            Tooltip     = Color(0, 0, 0, 228),
            Active      = Color(255, 255, 255, 255),
            Background  = Color(0, 0, 0, 127),
            Hovered     = Color(0, 0, 0, 180),
            Shading     = Color(0, 12, 24, 74)
        }

        local STYLE_SOLID, STYLE_BLANKSOLID, STYLE_TRANSPARENT_SELECTABLE, STYLE_ERROR = 0, 1, 2, 3;
        rp.Inventory.Panels.InventoryMenu.GetPaintStyle = function(element, style)
            style = style or STYLE_SOLID;

            local baseColor, textColor = Color(0,0,0,0), Color(0,0,0,0);
            local animspeed            = 768 * FrameTime();

            if style == STYLE_SOLID then
                element._grayscale = math_Approach(
                    element._grayscale or 0,
                    (element:IsHovered() and 255 or 0) * (element:GetDisabled() and 0 or 1),
                    animspeed
                );

                local invGrayscale = 255 - element._grayscale;
                baseColor = Color( element._grayscale, element._grayscale, element._grayscale );
                textColor = Color( invGrayscale, invGrayscale, invGrayscale );
            elseif style == STYLE_BLANKSOLID then
                element._grayscale = math_Approach(
                    element._alpha or 0,
                    (element:IsHovered() and 0 or 255),
                    animspeed
                );

                element._alpha = math_Approach(
                    element._alpha or 0,
                    (element:IsHovered() and 255 or 0),
                    animspeed
                );

                local invGrayscale = 255 - element._grayscale;
                baseColor = Color( element._grayscale, element._grayscale, element._grayscale, element._alpha );
                textColor = Color( invGrayscale, invGrayscale, invGrayscale );
            elseif style == STYLE_TRANSPARENT_SELECTABLE then
                element._grayscale = math_Approach(
                    element._grayscale or 0,
                    (element.Selected and 255 or 0),
                    animspeed
                );
                
                if element.Selected then
                    element._alpha = math_Approach( element._alpha or 0, 255, animspeed );
                else
                    element._alpha = math_Approach( element._alpha or 0, (element:IsHovered() and 228 or 146), animspeed );
                end

                local invGrayscale = 255 - element._grayscale;
                baseColor = Color( element._grayscale, element._grayscale, element._grayscale, element._alpha );
                textColor = Color( invGrayscale, invGrayscale, invGrayscale );
            elseif style == STYLE_ERROR then
                baseColor = Color( 150 + math_sin(CurTime() * 1.5) * 70, 0, 0 );
                textColor = rp.Inventory.Panels.InventoryMenu.UIColors.White;
            end

            return baseColor, textColor;
        end

        rp.Inventory.Panels.InventoryMenu.Title = vgui.Create("DLabel", rp.Inventory.Panels.InventoryMenu)
        rp.Inventory.Panels.InventoryMenu.Title:Dock(TOP)
        rp.Inventory.Panels.InventoryMenu.Title:InvalidateParent(true)
        rp.Inventory.Panels.InventoryMenu.Title:SetText(translates.Get("ИНВЕНТАРЬ"))

        rp.Inventory.Panels.InventoryMenu.Title.Paint = function(this, w, h)
            surface.SetDrawColor(rp.cfg.UIColor and rp.cfg.UIColor.BlockHeader or rpui.UIColors.Shading)
            surface.DrawRect(0, 0, w, h)
            draw.SimpleText(this:GetText(), this:GetFont(), w * 0.05, h * 0.5, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

            return true
        end
		
        --rp.Inventory.Panels.InventoryMenu.Content = vgui.Create("Panel", rp.Inventory.Panels.InventoryMenu)
        rp.Inventory.Panels.InventoryMenu.Content = vgui.Create("rpui.ScrollPanel", rp.Inventory.Panels.InventoryMenu)
        local frameH = ScrH() * 0.5
        local frameSpacing = frameH * 0.01

        surface.CreateFont("InventoryContext.Title", {
            font = "Montserrat",
            size = ScrH() * 0.025,
            weight = 800,
            extended = true
        })

        rp.Inventory.Panels.InventoryMenu.Title:Dock(NODOCK)
        rp.Inventory.Panels.InventoryMenu.Title:SetFont("InventoryContext.Title")
        rp.Inventory.Panels.InventoryMenu.Title:SizeToContentsX(frameSpacing * 2)
        rp.Inventory.Panels.InventoryMenu.Title:SizeToContentsY(frameSpacing * 6)
        rp.Inventory.Panels.InventoryMenu.Title:InvalidateLayout(true)
        rp.Inventory.Panels.InventoryMenu.Content:Dock(NODOCK)

        if IsValid(rp.Inventory.Panels.InventoryMenu.PlayerInventory) then
            rp.Inventory.Panels.InventoryMenu.PlayerInventory:Remove()
        end

        --rp.Inventory.Panels.InventoryMenu.PlayerInventory = vgui.Create("rpui.Inventory", rp.Inventory.Panels.InventoryMenu.Content)
        rp.Inventory.Panels.InventoryMenu.PlayerInventory = vgui.Create("rpui.Inventory")
        rp.Inventory.Panels.InventoryMenu.PlayerInventory.widthFrame = frameH * 0.1
        rp.Inventory.Panels.InventoryMenu.PlayerInventory.heightFrame = frameH * 0.1
        rp.Inventory.Panels.InventoryMenu.PlayerInventory.spacingFrame = frameSpacing
        rp.Inventory.Panels.InventoryMenu.PlayerInventory:setInventory(LocalPlayer():getInv())
		
		rp.Inventory.Panels.InventoryMenu.Content:AddItem( rp.Inventory.Panels.InventoryMenu.PlayerInventory );
		
        rp.Inventory.Panels.InventoryMenu.Content:InvalidateLayout(true)
        rp.Inventory.Panels.InventoryMenu.Content:SizeToChildren(true, true)
		
		rp.Inventory.Panels.InventoryMenu.Content:SetWide(frameH * 0.1 * 5 + frameSpacing * 7);
	
        rp.Inventory.Panels.InventoryMenu:InvalidateLayout(true)
        rp.Inventory.Panels.InventoryMenu:SizeToChildren(true, false)
        rp.Inventory.Panels.InventoryMenu.Title:Dock(TOP)
		
	if rp.Inventory.Panels.InventoryMenu:GetTall() > frameH then
		rp.Inventory.Panels.InventoryMenu.Content:SetTall( frameH - frameSpacing * 2 - rp.Inventory.Panels.InventoryMenu.Title:GetTall() );
		rp.Inventory.Panels.InventoryMenu:SetTall( frameH );
	end
	
        rp.Inventory.Panels.InventoryMenu.Content:Dock(TOP)
        rp.Inventory.Panels.InventoryMenu.Content:DockMargin(frameSpacing * 2, frameSpacing * 2, frameSpacing * 2, frameSpacing * 2)
		rp.Inventory.Panels.InventoryMenu.Content:SetScrollbarMargin( frameSpacing );
		
        rp.Inventory.Panels.InventoryMenu.Content:InvalidateParent(true)
        rp.Inventory.Panels.InventoryMenu:InvalidateLayout(true)
        rp.Inventory.Panels.InventoryMenu:SizeToChildren(false, true)
		
	rp.Inventory.Panels.InventoryMenu:SetTall(rp.Inventory.Panels.InventoryMenu.Title:GetTall() + frameSpacing * 2 + rp.Inventory.Panels.InventoryMenu.PlayerInventory:GetTall() )
	if rp.Inventory.Panels.InventoryMenu:GetTall() > frameH then
		rp.Inventory.Panels.InventoryMenu.Content:SetTall( frameH - frameSpacing * 2 - rp.Inventory.Panels.InventoryMenu.Title:GetTall() );
		rp.Inventory.Panels.InventoryMenu:SetTall( frameH );
	end
		
        rp.Inventory.Panels.InventoryMenu:SetWide(rp.Inventory.Panels.InventoryMenu:GetWide() + frameSpacing * 2 + 10)
        rp.Inventory.Panels.InventoryMenu:SetTall(rp.Inventory.Panels.InventoryMenu:GetTall() + frameSpacing * 2)
		
        rp.Inventory.Panels.InventoryMenu.x = ScrW()/2 - rp.Inventory.Panels.InventoryMenu:GetWide()/2
        rp.Inventory.Panels.InventoryMenu:CenterVertical()--CenterVertical()

        rp.Inventory.Panels.CloseButton = vgui.Create("DButton", rp.Inventory.Panels.InventoryMenu)
        rp.Inventory.Panels.CloseButton:SetFont("rpui.Fonts.AmmoPrinter.Small")
        rp.Inventory.Panels.CloseButton:SetText(translates.Get("ЗАКРЫТЬ"))
        rp.Inventory.Panels.CloseButton:SizeToContentsY(frameH * 0.03)
        rp.Inventory.Panels.CloseButton:SizeToContentsX(rp.Inventory.Panels.CloseButton:GetTall() + frameW * 0.15)
        rp.Inventory.Panels.CloseButton:SetPos( rp.Inventory.Panels.InventoryMenu:GetWide() - rp.Inventory.Panels.CloseButton:GetWide() - 6, 16)
        rp.Inventory.Panels.CloseButton.Paint = function( this, w, h )
            local baseColor, textColor = rp.Inventory.Panels.InventoryMenu.GetPaintStyle(this)
            surface.SetDrawColor(baseColor)
            surface.DrawRect(0, 0, w, h)

            surface.SetDrawColor(rp.Inventory.Panels.InventoryMenu.UIColors.White)
            surface.DrawRect(0, 0, h, h)

            surface.SetDrawColor(Color(0, 0, 0,this._grayscale or 0))
            local p = h*0.1
            surface.DrawLine(h, p, h, h - p)

            draw_SimpleText("✕", "rpui.Fonts.AmmoPrinter.Small", h/2, h/2, rp.Inventory.Panels.InventoryMenu.UIColors.Black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            draw_SimpleText(this:GetText(), this:GetFont(), w/2 + h/2, h/2, textColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
            
            return true
        end
        rp.Inventory.Panels.CloseButton.DoClick = function(self)
            if self.Closing then return end
            self.Closing = true

            rp.Inventory.Panels.InventoryMenu:AlphaTo(0, 0.25, 0, function()
                if IsValid(rp.Inventory.Panels.InventoryMenu) then rp.Inventory.Panels.InventoryMenu:Remove() end
            end)
        end
    end
end)

hook.Add("RefreshContextMenu", "Refresh_InventorySwepMenu", function()
    --if g_ContextMenu:IsMouseInputEnabled() then return end
    if rp.Inventory and not IsValid(rp.Inventory.Panels.InventoryMenu) then return end

    hook.Run("rp.OpenInventory", true)
end)

hook.Add("PostRenderVGUI", "InvHelper", function()
    local pnl = rp.gui.inv1

    hook.Run("PostDrawInventory", pnl)
end)