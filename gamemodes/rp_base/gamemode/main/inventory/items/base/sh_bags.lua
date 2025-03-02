-- "gamemodes\\rp_base\\gamemode\\main\\inventory\\items\\base\\sh_bags.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
ITEM.name = "Bag"
ITEM.desc = "A bag to hold items."
ITEM.model = "models/props_c17/suitcase001a.mdl"
ITEM.category = "Storage"
ITEM.width = 2
ITEM.height = 2
ITEM.invWidth = 4
ITEM.invHeight = 2
ITEM.isBag = true
ITEM.notCanGive = true
ITEM.functions.View = {
    name = translates.Get("Открыть"),
    icon = "icon16/briefcase.png",
    onClick = function(item)
        local index = item:getData("id")

        if (index) then
            local panel = rp.gui["inv"..index]
            local parent = item.invID and rp.gui["inv"..item.invID] or nil
            local inventory = rp.item.inventories[index]

            if (IsValid(panel)) then
                panel:Remove()
            end

            if (inventory and inventory.slots) then
                panel = vgui.Create("Inventory", parent)
                panel:setInventory(inventory)
                panel:SetTitle(item.getName and item:getName())
                panel:MakePopup()
                panel:SetPos(15, ScrH()/2-panel:GetTall()/2)

                rp.gui["inv"..index] = panel
            else
                ErrorNoHalt("Attempt to view an uninitialized inventory 1 '"..index.."'\n")
            end
        end

        return false
    end,
    onCanRun = function(item)
        return !IsValid(item.entity) and item:getData("id")
    end
}

ITEM.functions.Open = {
    name = translates.Get("Открыть"),
    icon = "icon16/cup.png",
    sound = "buttons/lever8.wav",
    onRun = function(item)
        hook.Run( "Inv::GenerateAdditionalLoot", item );

        local index = item:getData("id")
        netstream.Start(item.player, "rpOpenBag", index)
        --net.Start("rp.OpenInventory")
        --net.Send(item.player)

		hook.Run("Inv::OpenBag", item.player)

        return false
    end,
    onCanRun = function(item)
        return IsValid(item.entity) and item:getData("id") and IsValid(item.player) and not item.player:CantDoAfterNoclip(true)
    end
}

-- Called when a new instance of this item has been made.
function ITEM:onInstanced(invID, x, y)
    if self.isCreatedInv then return end
    local inventory = rp.item.inventories[invID]

    rp.item.newInv(0, self.uniqueID, self.invWidth, self.invHeight, function(inventory)
        inventory.vars.isBag = self.uniqueID
        self:setData("id", inventory:getID())

        if self.accessCallback then
            self:accessCallback()
        end

		if not IsValid(self.entity) then return end

        inventory.entity = self.entity
		self.entity.inventory = inventory
    end)

    self.isCreatedInv = true
end

function ITEM:getInv()
    local index = self:getData("id")
    if (index) then
        return rp.item.inventories[index]
    end
end

-- Called when the item first appears for a client.
function ITEM:onSendData()
    local index = self:getData("id")

    if (index) then
        local inventory = rp.item.inventories[index]

        if (inventory) then
            inventory.vars.isBag = self.uniqueID
            inventory:sync(self.player)
            inventory:setOwner(self.player, true)
        elseif IsValid(self.player) then
            local owner = self.player:getID()

            rp.item.restoreInv(self:getData("id"), self.invWidth, self.invHeight, function(inventory)
                inventory.vars.isBag = self.uniqueID
                inventory:setOwner(owner, true)
            end)
        else
            return
        end
    elseif !self.isCreatedInv then
        --local inventory = rp.item.inventories[self.invID]
        --local oldInvID = self:getData("id")
        local owner = self.player

		--print('Creating new inv!', owner)

        rp.item.newInv(owner:getID(), self.uniqueID, self.invWidth, self.invHeight, function(inv1)
			--print('Inv created!', inv1:getID())

            self:setData("id", inv1:getID())
            inv1:setOwner(owner, true)
            --if oldInvID == nil then return end
            -- rp._Inventory:Query("UPDATE items SET _invID = "..inv1:getID().." WHERE _invID = "..oldInvID..";", function()
            --  rp.item.restoreInv(inv1:getID(), self.invWidth, self.invHeight, function(inv2)
            --      inv2:setOwner(owner, true)
            --  end)
            -- end)
        end)

        self.isCreatedInv = true
    end
end

ITEM.postHooks.drop = function(item, result)
    local index = item:getData("id")

    rp._Inventory:Query("UPDATE inventories SET _charID = 0 WHERE _invID = "..index..";")
    netstream.Start(item.player, "rpBagDrop", index)
end

if CLIENT then
    local math_Clamp = math.Clamp
    local math_floor = math.floor
    local math_Approach = math.Approach
    local math_sin = math.sin
    local surface_SetDrawColor = surface.SetDrawColor
    local surface_DrawRect = surface.DrawRect
    local draw_SimpleText = draw.SimpleText

    rp.LootInventory = rp.LootInventory or {}
    rp.LootInventory.Panels = rp.LootInventory.Panels or {}
    local old_menu = false

    function rp.item.CreateInventory(force, inventory, index, customData)
        if old_menu then
            panel = vgui.Create("Inventory")
            panel:setInventory(inventory)
            panel:ShowCloseButton(true)
            panel:SetTitle(customData.name or translates.Get("Ящик"))
            panel.btnMaxim:Hide()
            panel.btnMinim:Hide()
            panel:SetPos(ScrW() / 2 + 15, ScrH() / 2 - panel:GetTall() / 2)
            panel:MakePopup()

			if not customData.disableTakeAll then
				ui.Create('DButton', function(self, p)
					self:SetSize(150, 24)
					self:SetPos(panel:GetWide() - self:GetWide() - 38)
					self:SetText(translates.Get("Взять всё"))

					self.Paint = function(btn, w, h)
						derma.SkinHook('Paint', 'TabButton', btn, w, h)
					end

					self.DoClick = function()
						net.Start("rp.TakeAllItems")
						net.WriteUInt(index, 32)
						net.SendToServer()

						--if (#table.GetKeys((inventory and inventory:getItems()) or {}) > 0) then
						--    LocalPlayer():AnimRestartGesture(GESTURE_SLOT_ATTACK_AND_RELOAD, ACT_GMOD_GESTURE_ITEM_GIVE, true)
						--end

						panel:Close()
					end
				end, panel)
			end

            rp.gui["inv" .. index] = panel

            return
        end

        if IsValid(rp.LootInventory.Panels.InventoryMenu) then
            rp.LootInventory.Panels.InventoryMenu:Remove()
            if IsValid(rp.Inventory.Panels.InventoryMenu) then
                rp.Inventory.Panels.InventoryMenu:Remove()
            end
            if IsValid(rp.LootInventory.Panels.MoveAllBtn) then
                rp.LootInventory.Panels.MoveAllBtn:Remove()
            end
            if IsValid(rp.LootInventory.Panels.MoveAllLbl) then
                rp.LootInventory.Panels.MoveAllLbl:Remove()
            end
            if not force then return end
        end

        rp.LootInventory.Panels.InventoryMenu = vgui.Create("DPanel")
        rp.LootInventory.Panels.InventoryMenu:MakePopup()
        rp.LootInventory.Panels.InventoryMenu:Center()

        rp.LootInventory.Panels.InventoryMenu.Paint = function(this, w, h)
            if not IsValid(rp.Inventory.Panels.InventoryMenu) and not rp.FakeInventoryOpened then
                this:Remove()
                if IsValid(rp.LootInventory.Panels.MoveAllBtn) then
                    rp.LootInventory.Panels.MoveAllBtn:Remove()
                end
                if IsValid(rp.LootInventory.Panels.MoveAllLbl) then
                    rp.LootInventory.Panels.MoveAllLbl:Remove()
                end
                return
            end

            draw.Blur(this)
            surface.SetDrawColor(rpui.UIColors.Background) -- rpui.UIColors.Background
            surface.DrawRect(0, 0, w, h)

            if input.IsKeyDown(KEY_X) and IsValid(rp.LootInventory.Panels.CloseButton) then
                rp.LootInventory.Panels.CloseButton.DoClick(rp.LootInventory.Panels.CloseButton)
            end

            if input.IsKeyDown(KEY_ESCAPE) then
                this:Remove()
                if IsValid(rp.LootInventory.Panels.MoveAllBtn) then
                    rp.LootInventory.Panels.MoveAllBtn:Remove()
                end
                if IsValid(rp.LootInventory.Panels.MoveAllLbl) then
                    rp.LootInventory.Panels.MoveAllLbl:Remove()
                end
            end
        end

        local frameW, frameH = rp.LootInventory.Panels.InventoryMenu:GetSize()

        rp.LootInventory.Panels.InventoryMenu.UIColors = {
            Blank = Color(0, 0, 0, 0),
            White = Color(255, 255, 255, 255),
            Black = Color(0, 0, 0, 255),
            Tooltip = Color(0, 0, 0, 228),
            Active = Color(255, 255, 255, 255),
            Background = Color(0, 0, 0, 127),
            Hovered = Color(0, 0, 0, 180),
            Shading = Color(0, 12, 24, 74)
        }

        local STYLE_SOLID, STYLE_BLANKSOLID, STYLE_TRANSPARENT_SELECTABLE, STYLE_ERROR = 0, 1, 2, 3

        rp.LootInventory.Panels.InventoryMenu.GetPaintStyle = function(element, style)
            style = style or STYLE_SOLID
            local baseColor, textColor = Color(0, 0, 0, 0), Color(0, 0, 0, 0)
            local animspeed = 768 * FrameTime()

            if style == STYLE_SOLID then
                element._grayscale = math_Approach(element._grayscale or 0, (element:IsHovered() and 255 or 0) * (element:GetDisabled() and 0 or 1), animspeed)
                local invGrayscale = 255 - element._grayscale
                baseColor = Color(element._grayscale, element._grayscale, element._grayscale)
                textColor = Color(invGrayscale, invGrayscale, invGrayscale)
            elseif style == STYLE_BLANKSOLID then
                element._grayscale = math_Approach(element._alpha or 0, (element:IsHovered() and 0 or 255), animspeed)
                element._alpha = math_Approach(element._alpha or 0, (element:IsHovered() and 255 or 0), animspeed)
                local invGrayscale = 255 - element._grayscale
                baseColor = Color(element._grayscale, element._grayscale, element._grayscale, element._alpha)
                textColor = Color(invGrayscale, invGrayscale, invGrayscale)
            elseif style == STYLE_TRANSPARENT_SELECTABLE then
                element._grayscale = math_Approach(element._grayscale or 0, (element.Selected and 255 or 0), animspeed)

                if element.Selected then
                    element._alpha = math_Approach(element._alpha or 0, 255, animspeed)
                else
                    element._alpha = math_Approach(element._alpha or 0, (element:IsHovered() and 228 or 146), animspeed)
                end

                local invGrayscale = 255 - element._grayscale
                baseColor = Color(element._grayscale, element._grayscale, element._grayscale, element._alpha)
                textColor = Color(invGrayscale, invGrayscale, invGrayscale)
            elseif style == STYLE_ERROR then
                baseColor = Color(150 + math_sin(CurTime() * 1.5) * 70, 0, 0)
                textColor = rp.LootInventory.Panels.InventoryMenu.UIColors.White
            end

            return baseColor, textColor
        end

        rp.LootInventory.Panels.InventoryMenu.Title = vgui.Create("DLabel", rp.LootInventory.Panels.InventoryMenu)
        rp.LootInventory.Panels.InventoryMenu.Title:Dock(TOP)
        rp.LootInventory.Panels.InventoryMenu.Title:InvalidateParent(true)
        rp.LootInventory.Panels.InventoryMenu.Title:SetText(customData.name or translates.Get("ЯЩИК"))

        rp.LootInventory.Panels.InventoryMenu.Title.Paint = function(this, w, h)
            surface.SetDrawColor(rpui.UIColors.Shading)
            surface.DrawRect(0, 0, w, h)
            draw.SimpleText(this:GetText(), this:GetFont(), h * 0.275, h * 0.5, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

            return true
        end

        rp.LootInventory.Panels.InventoryMenu.Content = vgui.Create("Panel", rp.LootInventory.Panels.InventoryMenu)
        local frameH = ScrH() * 0.5
        local frameSpacing = frameH * 0.01

        surface.CreateFont("InventoryContext.Title", {
            font = "Montserrat",
            size = ScrH() * 0.025,
            weight = 800,
            extended = true
        })

        rp.LootInventory.Panels.InventoryMenu.Title:Dock(NODOCK)
        rp.LootInventory.Panels.InventoryMenu.Title:SetFont("InventoryContext.Title")
        rp.LootInventory.Panels.InventoryMenu.Title:SizeToContentsX(frameSpacing * 2)
        rp.LootInventory.Panels.InventoryMenu.Title:SizeToContentsY(frameSpacing * 6)
        rp.LootInventory.Panels.InventoryMenu.Title:InvalidateLayout(true)
        rp.LootInventory.Panels.InventoryMenu.Content:Dock(NODOCK)

        if IsValid(rp.LootInventory.Panels.InventoryMenu.PlayerInventory) then
            rp.LootInventory.Panels.InventoryMenu.PlayerInventory:Remove()
        end

        rp.LootInventory.Panels.InventoryMenu.PlayerInventory = vgui.Create("rpui.Inventory", rp.LootInventory.Panels.InventoryMenu.Content)
        rp.LootInventory.Panels.InventoryMenu.PlayerInventory.widthFrame = frameH * 0.1
        rp.LootInventory.Panels.InventoryMenu.PlayerInventory.heightFrame = frameH * 0.1
        rp.LootInventory.Panels.InventoryMenu.PlayerInventory.spacingFrame = frameSpacing
        rp.LootInventory.Panels.InventoryMenu.PlayerInventory:setInventory(inventory)
        rp.LootInventory.Panels.InventoryMenu.Content:InvalidateLayout(true)
        rp.LootInventory.Panels.InventoryMenu.Content:SizeToChildren(true, true)
        rp.LootInventory.Panels.InventoryMenu:InvalidateLayout(true)
        rp.LootInventory.Panels.InventoryMenu:SizeToChildren(true, false)
        rp.LootInventory.Panels.InventoryMenu.Title:Dock(TOP)
        rp.LootInventory.Panels.InventoryMenu.Content:Dock(TOP)
        rp.LootInventory.Panels.InventoryMenu.Content:DockMargin(frameSpacing * 2, frameSpacing * 2, frameSpacing * 2, frameSpacing * 2)
        rp.LootInventory.Panels.InventoryMenu.Content:InvalidateParent(true)
        rp.LootInventory.Panels.InventoryMenu:InvalidateLayout(true)
        rp.LootInventory.Panels.InventoryMenu:SizeToChildren(false, true)
        rp.LootInventory.Panels.InventoryMenu:SetWide(rp.LootInventory.Panels.InventoryMenu:GetWide() + frameSpacing * 2 + 10)
        rp.LootInventory.Panels.InventoryMenu:SetTall(rp.LootInventory.Panels.InventoryMenu:GetTall() + frameSpacing * 2)
        rp.LootInventory.Panels.InventoryMenu.x = ScrW() / 2 - rp.LootInventory.Panels.InventoryMenu:GetWide() / 2
        rp.LootInventory.Panels.InventoryMenu:CenterVertical()


        hook.Add("Inventory_OnInvAct_Combine", "ForceUpdateLootBAGInv", function(item_id, inv_id, target_item_id)
            local that = rp.LootInventory.Panels.InventoryMenu.PlayerInventory
            if not IsValid(that) then return end

            if that.invID ~= inv_id or that.invID == target_item_id then return end
            --print(item_id, inv_id, target_item_id)



            --if item_id == target_item_id then
                if that.panels then--and that.panels[item_id] then
                    local ico = that.panels[item_id]
                    if IsValid(ico) then
                        surface.PlaySound("physics/body/body_medium_impact_soft2.wav")
                        ico:Remove()
                    end
                    --that.panels[item_id]:Remove()
                end
            --end
        end)

        if IsValid(rp.Inventory.Panels.CloseButton) then
            rp.Inventory.Panels.CloseButton.DoClick = function(self)
                if self.Closing then return end
                self.Closing = true

                if IsValid(rp.LootInventory.Panels.InventoryMenu) then
                    rp.LootInventory.Panels.InventoryMenu:AlphaTo(0, 0.25)
                end
                if IsValid(rp.Inventory.Panels.InventoryMenu) then
                    rp.Inventory.Panels.InventoryMenu:AlphaTo(0, 0.25)
                end
                if IsValid(rp.LootInventory.Panels.MoveAllBtn) then
                    rp.LootInventory.Panels.MoveAllBtn:AlphaTo(0, 0.25)
                end
                if IsValid(rp.LootInventory.Panels.MoveAllLbl) then
                    rp.LootInventory.Panels.MoveAllLbl:AlphaTo(0, 0.25)
                end

                timer.Simple(0.25, function()
                    if IsValid(rp.Inventory.Panels.InventoryMenu) then rp.Inventory.Panels.InventoryMenu:Remove() end
                    if IsValid(rp.LootInventory.Panels.InventoryMenu) then rp.LootInventory.Panels.InventoryMenu:Remove() end
                    if IsValid(rp.LootInventory.Panels.MoveAllBtn) then rp.LootInventory.Panels.MoveAllBtn:Remove() end
                    if IsValid(rp.LootInventory.Panels.MoveAllLbl) then rp.LootInventory.Panels.MoveAllLbl:Remove() end
                end)
            end
--[[
            rp.LootInventory.Panels.GetAllBtn = vgui.Create("DButton", rp.LootInventory.Panels.InventoryMenu)
            rp.LootInventory.Panels.GetAllBtn:SetFont("rpui.Fonts.AmmoPrinter.Small")
            rp.LootInventory.Panels.GetAllBtn:SetText("ВЗЯТЬ ВСЁ")
            rp.LootInventory.Panels.GetAllBtn:SizeToContentsY(frameH * 0.03)
            rp.LootInventory.Panels.GetAllBtn:SizeToContentsX(rp.LootInventory.Panels.GetAllBtn:GetTall() + frameW * 0.15)
            rp.LootInventory.Panels.GetAllBtn:SetPos(rp.LootInventory.Panels.InventoryMenu:GetWide() - rp.LootInventory.Panels.GetAllBtn:GetWide() - 6, 16)
            rp.LootInventory.Panels.GetAllBtn.DoClick = function(self)
                net.Start("rp.TakeAllItems")
                    net.WriteUInt(index, 32)
                net.SendToServer()

                if (#table.GetKeys((inventory and inventory:getItems()) or {}) > 0) then
                    LocalPlayer():AnimRestartGesture(GESTURE_SLOT_ATTACK_AND_RELOAD, ACT_GMOD_GESTURE_ITEM_GIVE, true)
                end

                surface.PlaySound("physics/body/body_medium_impact_soft2.wav")
                rp.Inventory.Panels.CloseButton.DoClick(rp.Inventory.Panels.CloseButton)
            end
            rp.LootInventory.Panels.GetAllBtn.Paint = function(this, w, h)
                local baseColor, textColor = rp.LootInventory.Panels.InventoryMenu.GetPaintStyle(this)
                surface.SetDrawColor(baseColor)
                surface.DrawRect(0, 0, w, h)
                draw_SimpleText(this:GetText(), this:GetFont(), w/2, h/2, textColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

                return true
            end
]]--
        else
            rp.LootInventory.Panels.CloseButton = vgui.Create("DButton", rp.LootInventory.Panels.InventoryMenu)
            rp.LootInventory.Panels.CloseButton:SetFont("rpui.Fonts.AmmoPrinter.Small")
            rp.LootInventory.Panels.CloseButton:SetText(translates.Get("ЗАКРЫТЬ"))
            rp.LootInventory.Panels.CloseButton:SizeToContentsY(frameH * 0.03)
            rp.LootInventory.Panels.CloseButton:SizeToContentsX(rp.LootInventory.Panels.CloseButton:GetTall() + frameW * 0.15)
            rp.LootInventory.Panels.CloseButton:SetPos(rp.LootInventory.Panels.InventoryMenu:GetWide() - rp.LootInventory.Panels.CloseButton:GetWide() - 6, 16)

            rp.LootInventory.Panels.CloseButton.Paint = function(this, w, h)
                local baseColor, textColor = rp.LootInventory.Panels.InventoryMenu.GetPaintStyle(this)
                surface.SetDrawColor(baseColor)
                surface.DrawRect(0, 0, w, h)
                surface.SetDrawColor(rp.LootInventory.Panels.InventoryMenu.UIColors.White)
                surface.DrawRect(0, 0, h, h)
                surface.SetDrawColor(Color(0, 0, 0, this._grayscale or 0))
                local p = h * 0.1
                surface.DrawLine(h, p, h, h - p)
                draw_SimpleText("✕", "rpui.Fonts.AmmoPrinter.Small", h / 2, h / 2, rp.LootInventory.Panels.InventoryMenu.UIColors.Black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                draw_SimpleText(this:GetText(), this:GetFont(), w / 2 + h / 2, h / 2, textColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

                return true
            end

            rp.LootInventory.Panels.CloseButton.DoClick = function(self)
                if self.Closing then return end
                self.Closing = true

                if IsValid(rp.LootInventory.Panels.InventoryMenu) then
                    rp.LootInventory.Panels.InventoryMenu:AlphaTo(0, 0.25)
                end
                if IsValid(rp.Inventory.Panels.InventoryMenu) then
                    rp.Inventory.Panels.InventoryMenu:AlphaTo(0, 0.25)
                end
                if IsValid(rp.LootInventory.Panels.MoveAllBtn) then
                    rp.LootInventory.Panels.MoveAllBtn:AlphaTo(0, 0.25)
                end
                if IsValid(rp.LootInventory.Panels.MoveAllLbl) then
                    rp.LootInventory.Panels.MoveAllLbl:AlphaTo(0, 0.25)
                end

                timer.Simple(0.25, function()
                    if IsValid(rp.Inventory.Panels.InventoryMenu) then rp.Inventory.Panels.InventoryMenu:Remove() end
                    if IsValid(rp.LootInventory.Panels.InventoryMenu) then rp.LootInventory.Panels.InventoryMenu:Remove() end
                    if IsValid(rp.LootInventory.Panels.MoveAllBtn) then rp.LootInventory.Panels.MoveAllBtn:Remove() end
                    if IsValid(rp.LootInventory.Panels.MoveAllLbl) then rp.LootInventory.Panels.MoveAllLbl:Remove() end
                end)
            end
        end

        if IsValid(rp.LootInventory.Panels.MoveAllBtn) then rp.LootInventory.Panels.MoveAllBtn:Remove() end
        if IsValid(rp.LootInventory.Panels.MoveAllLbl) then rp.LootInventory.Panels.MoveAllLbl:Remove() end

		if not customData.disableTakeAll and rp.cfg.TakeAllFromBags then
			local btn = vgui.Create("DButton")
			btn:SetText("")
			btn:SetSize(64, 64)
			btn:Center()
			btn:MakePopup()
			btn.DrawAlpha = 0
			local circle_mat = Material("circle_button/circle.png", "smooth", "noclamp")
			local circle_hover = Material("circle_button/circle_hover.png", "smooth", "noclamp")
			local circle_arrow = Material("circle_button/arrow.png", "smooth", "noclamp")
			btn.Paint = function(self, w, h)
				self.DrawAlpha = math_Approach(self.DrawAlpha, self.CircleHover and 200 or 0, FrameTime()*850)

				surface.SetDrawColor(Color(0, 0, 0, 175 - self.DrawAlpha))
				surface.SetMaterial(circle_mat)
				surface.DrawTexturedRect(0, 0, w, h)

				surface.SetDrawColor(ColorAlpha(color_white, self.DrawAlpha))
				surface.SetMaterial(circle_hover)
				surface.DrawTexturedRect(0, 0, w, h)

				surface.SetDrawColor(color_white)
				surface.SetMaterial(circle_arrow)
				surface.DrawTexturedRect(w/4, h/4, w*0.5, h*0.5)
			end
			local radius = btn:GetWide()/2
			btn.Think = function(self)
				local curx, cury = self:CursorPos()
				self.CircleHover = math.Distance(curx, cury, radius, radius) < radius

				self:SetCursor(self.CircleHover and "hand" or "arrow")
			end
			btn.DoClick = function(this)
				if not this.CircleHover then return end

				net.Start("rp.TakeAllItems")
					net.WriteUInt(index, 32)
				net.SendToServer()

				--if (#table.GetKeys((inventory and inventory:getItems()) or {}) > 0) then
				--    LocalPlayer():AnimRestartGesture(GESTURE_SLOT_ATTACK_AND_RELOAD, ACT_GMOD_GESTURE_ITEM_GIVE, true)
				--end

				local that = rp.LootInventory.Panels.InventoryMenu.PlayerInventory
				if that.panels then
					for id, ico in pairs(that.panels) do
						if IsValid(ico) then
							ico:Remove()
						end
					end
				end

				surface.PlaySound("physics/body/body_medium_impact_soft2.wav")
				--timer.Simple(0.1, function()
				--    rp.LootInventory.Panels.InventoryMenu.PlayerInventory:setInventory(rp.item.inventories[index])
				--end)
				if IsValid(rp.Inventory.Panels.CloseButton) then
					rp.Inventory.Panels.CloseButton.DoClick(rp.Inventory.Panels.CloseButton)
				else
					if IsValid(rp.LootInventory.Panels.MoveAllBtn) then
						rp.LootInventory.Panels.MoveAllBtn:Remove()
					end
					if IsValid(rp.LootInventory.Panels.MoveAllLbl) then
						rp.LootInventory.Panels.MoveAllLbl:Remove()
					end
				end
			end
			rp.LootInventory.Panels.MoveAllBtn = btn

			local lbl = vgui.Create("DLabel")
			lbl:SetText(translates.Get("Взять всё"))
			lbl:SetFont("InventoryContext.Title")
			lbl:SetTextColor(color_white)
			lbl:SizeToContents()
			lbl:SetPos(ScrW()/2 - lbl:GetWide()/2, ScrH()/2 + btn:GetTall()/2 + 4)
			rp.LootInventory.Panels.MoveAllLbl = lbl

			if IsValid(rp.Inventory.Panels.InventoryMenu) then
				rp.Inventory.Panels.InventoryMenu:SetPos(ScrW()/2 - rp.Inventory.Panels.InventoryMenu:GetWide() - 16 - lbl:GetWide()/2, ScrH()/2 - rp.Inventory.Panels.InventoryMenu:GetTall()/2)
			end
			rp.LootInventory.Panels.InventoryMenu:SetPos(ScrW()/2 + 16 + lbl:GetWide()/2, ScrH()/2 - rp.LootInventory.Panels.InventoryMenu:GetTall()/2)
		else
			if IsValid(rp.Inventory.Panels.InventoryMenu) then
				rp.Inventory.Panels.InventoryMenu:SetPos(ScrW()/2 - rp.Inventory.Panels.InventoryMenu:GetWide() - 32, ScrH()/2 - rp.Inventory.Panels.InventoryMenu:GetTall()/2)
			end

			rp.LootInventory.Panels.InventoryMenu:SetPos(ScrW()/2 + 32, ScrH()/2 - rp.LootInventory.Panels.InventoryMenu:GetTall()/2)

			--local px, py = rp.LootInventory.Panels.InventoryMenu:GetPos()

			--rp.LootInventory.Panels.InventoryMenu:SetPos(px - rp.LootInventory.Panels.InventoryMenu:GetWide() / 2 - 48, py)
		end
    end

    hook.Add("RefreshContextMenu", "Refresh_InventorySwepMenu", function()
        --if g_ContextMenu:IsMouseInputEnabled() then return end
        if not rp.Inventory or not IsValid(rp.Inventory.Panels.InventoryMenu) or not IsValid(rp.LootInventory.Panels.MoveAllLbl) then return end

        rp.Inventory.Panels.InventoryMenu:SetPos(ScrW()/2 - rp.Inventory.Panels.InventoryMenu:GetWide() - 16 - rp.LootInventory.Panels.MoveAllLbl:GetWide()/2, ScrH()/2 - rp.Inventory.Panels.InventoryMenu:GetTall()/2)

        if IsValid(rp.Inventory.Panels.CloseButton) then
            rp.Inventory.Panels.CloseButton.DoClick = function(self)
                if self.Closing then return end
                self.Closing = true

                if IsValid(rp.LootInventory.Panels.InventoryMenu) then
                    rp.LootInventory.Panels.InventoryMenu:AlphaTo(0, 0.25)
                end
                if IsValid(rp.Inventory.Panels.InventoryMenu) then
                    rp.Inventory.Panels.InventoryMenu:AlphaTo(0, 0.25)
                end
                if IsValid(rp.LootInventory.Panels.MoveAllBtn) then
                    rp.LootInventory.Panels.MoveAllBtn:AlphaTo(0, 0.25)
                end
                if IsValid(rp.LootInventory.Panels.MoveAllLbl) then
                    rp.LootInventory.Panels.MoveAllLbl:AlphaTo(0, 0.25)
                end

                timer.Simple(0.25, function()
                    if IsValid(rp.Inventory.Panels.InventoryMenu) then rp.Inventory.Panels.InventoryMenu:Remove() end
                    if IsValid(rp.LootInventory.Panels.InventoryMenu) then rp.LootInventory.Panels.InventoryMenu:Remove() end
                    if IsValid(rp.LootInventory.Panels.MoveAllBtn) then rp.LootInventory.Panels.MoveAllBtn:Remove() end
                    if IsValid(rp.LootInventory.Panels.MoveAllLbl) then rp.LootInventory.Panels.MoveAllLbl:Remove() end
                end)
            end
        end
    end)

    netstream.Hook("rpBagDrop", function(index)
        local panel = rp.gui["inv"..index]

        if IsValid(panel) and panel:IsVisible() then
            panel:Close()
        end
    end)

    netstream.Hook( "rpOpenBag", function( index, isShop )
        if LocalPlayer():CantDoAfterNoclip( true ) then return end

        if index then
            local inventory = rp.item.inventories[index];

            if inventory and inventory.slots then
                hook.Run( "rp.OpenInventory" );

                local customData = {};

                if isShop then
                    customData.name = "Ваш магазин";
                    customData.disableTakeAll = true;
                else
                    if inventory.vars then
                        -- maybe generate in hook?

                        if inventory.vars.UI_Name then
                            customData.name = inventory.vars.UI_Name;
                        end

                        if inventory.vars.UI_DisableTakeAll then
                            customData.disableTakeAll = true;
                        end
                    end
                end

                rp.item.CreateInventory( nil, inventory, index, customData );

				hook.Run( "Inventory::OpenBag" )
            else
                --ErrorNoHalt("Attempt to view an uninitialized inventory 2 '"..index.."'\n")
            end
        end
    end );
else
    util.AddNetworkString( "rp.TakeAllItems" );
    net.Receive( "rp.TakeAllItems", function( len, ply )
        if ply:CantDoAfterNoclip(true) then return end
		if not rp.cfg.TakeAllFromBags then return end

        local index            = net.ReadUInt(32);
        local inventory        = rp.item.inventories[index];
        local inventory_entity = inventory.entity;

        if inventory and IsValid(inventory_entity) then
            if ply:GetPos():DistToSqr(inventory_entity:GetPos()) > 250000 then return end

			rp.item.RunGesture(ply, ACT_GMOD_GESTURE_ITEM_GIVE)

			local moved = {} --table.Copy(inventory:getItems() or {});

			local playerinventory = ply:getInv():getID();
			local item_before_cleanup

            for k, v in pairs( inventory:getItems() ) do
				item_before_cleanup = table.Copy(v)
                local result = v:transfer( playerinventory, nil, nil, nil, nil, nil, true );

				if result then
					table.insert(moved, item_before_cleanup)
				end
            end

			hook.Call('Bag.OnTakeAllItems', nil, ply, inventory, inventory_entity, moved);
        end
    end );
end

-- Called before the item is permanently deleted.
function ITEM:onRemoved()
    local index = self:getData("id")

    if index then
        rp._Inventory:Query("DELETE FROM inventories WHERE _invID = "..index..";")
    end
end

-- Called when the item should tell whether or not it can be transfered between inventories.
function ITEM:onCanBeTransfered(oldInventory, newInventory)
    local index = self:getData("id")

    if (newInventory) then
        if (newInventory.vars and newInventory.vars.isBag) then
            return false
        end

        local index2 = newInventory:getID()

        if (index == index2) then
            return false
        end

        for k, v in pairs(self:getInv():getItems()) do
            if (v:getData("id") == index2) then
                return false
            end
        end
    end

    return !newInventory or newInventory:getID() != oldInventory:getID() or newInventory.vars.isBag
end

-- Called after the item is registered into the item tables.
function ITEM:onRegistered()
    rp.item.registerInv(self.uniqueID, self.invWidth, self.invHeight, true)
end