-- "gamemodes\\rp_base\\gamemode\\main\\inventory\\derma\\crafting_cl.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local sounds = {"physics/metal/weapon_impact_soft1.wav", "physics/metal/weapon_impact_soft2.wav"}
local sounds_complete_craft = {"physics/wood/wood_strain3.wav", "physics/wood/wood_strain4.wav"}
local sounds_crafting = {"physics/wood/wood_strain3.wav", "physics/wood/wood_strain4.wav"}

hook.Add("rp.OpenCrafting","rp.OpenCrafting",function(parent)
	for k,v in pairs(rp.gui) do if IsValid(v) then v:Remove() end end
	if not LocalPlayer():getInv() then return end
	
	local w, h = LocalPlayer():getInv():getSize()

	local sizeRecipes = parent:GetWide()*0.45
	local sizeSlots = (parent:GetWide()*0.55-20-16)/w
	if sizeSlots > 64 then sizeSlots = 64 end
	
	local scroll = ui.Create('ui_listview', function(self, p)
		self.Paint = function() end
		self:Dock(FILL)
		self:DockMargin(2,0,2,0);
	end, parent)

	--create craftable
	local craftableInv = rp.item.createInv(5, 1, "craftable")
	rp.gui.craftable = ui.Create('Inventory', function(self, p)
		self:ShowCloseButton(false)
		self:SetDraggable(false)
		self.childPanels = {}
		self.widthFrame = sizeSlots
		self.heightFrame = sizeSlots
		self.IsCentered = true
		self.addX = parent:GetWide()-(sizeRecipes)-20
		self:setInventory(craftableInv)
		self:SetTitle(translates.Get("Стол для предметов"))
	end, scroll)
	scroll:AddItem(rp.gui.craftable)

	local invspacer = vgui.Create("Panel", scroll);
	invspacer:SetTall(4);
	invspacer.Paint = nil;
	scroll:AddItem(invspacer);

	--create result
	local resultInv = rp.item.createInv(2, 2, "result")
	rp.gui.result = ui.Create('Inventory', function(self, p)
		self:ShowCloseButton(false)
		self:SetDraggable(false)
		self.childPanels = {}
		self.widthFrame = sizeSlots
		self.heightFrame = sizeSlots
		self.IsCentered = true
		self.addX = parent:GetWide()-(sizeRecipes)-20
		self:setInventory(resultInv)
		self:SetTitle(translates.Get("Итог"))
	end, scroll)
	scroll:AddItem(rp.gui.result)

	rp.gui.craftButton = ui.Create('DButton', function(self, p)
		self:SetSize(200, 25)
		self:SetText("")
		function self:DoClick()
			if timer.Exists("InventoryCraftingTimer") then return end
			self.TimeCrafting = (rp.gui.result.recipe ~= nil and rp.item.recipes[rp.gui.result.recipe].timeCreation or rp.cfg.DefaultTimeCreation)
			self:SetDisabled(true)
			timer.Create("InventoryCraftingTimer", self.TimeCrafting, 1, function()
				if rp.gui.result.recipe != nil then
					if IsValid(self) then self:SetDisabled(false) end

					surface.PlaySound(table.Random(sounds_complete_craft))
					
					net.Start("rp.CraftItem")
						net.WriteString(rp.gui.result.recipe)
					net.SendToServer()

					rp.gui.craftable:ClearItemsCrafting()
				end
			end)
			timer.Create("InventoryCraftingSound", 0.5, 0, function()
				if not timer.Exists("InventoryCraftingTimer") then return end
				surface.PlaySound(table.Random(sounds_crafting))
			end)
		end
		local craft_txt = translates.Get("Скрафтить")
		function self:PaintOver(w, h)
			w = w - 2
			h = h - 2
			if timer.Exists("InventoryCraftingTimer") then
				local perc = 1-((timer.TimeLeft("InventoryCraftingTimer")*100/self.TimeCrafting)/100)
				draw.RoundedBox(0, 1, 1, math.Clamp((w * perc), 3, w), h, Color(255, 140, 0))
			end
			draw.SimpleTextOutlined(craft_txt, 'rp.ui.22', self:GetWide()/2, self:GetTall()/2, rp.col.White, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, rp.col.Black)
		end
		function self:CanCraftItem(k)
			local isCan, items = rp.IsCanCraftItem(LocalPlayer():getInv(), rp.item.recipes[k])
			if isCan then
				self:SetDisabled(false)
			else
				self:SetDisabled(true)
			end
		end
		function self:OnRemove()
			if timer.Exists("InventoryCraftingTimer") then timer.Destroy("InventoryCraftingTimer") end
			if timer.Exists("InventoryCraftingSound") then timer.Destroy("InventoryCraftingSound") end
		end
		self:SetDisabled(true)
	end, scroll)
	scroll:AddItem(rp.gui.craftButton)

	local invspacer = vgui.Create("Panel", scroll);
	invspacer:SetTall(4);
	invspacer.Paint = nil;
	scroll:AddItem(invspacer);

	--create inventory
	rp.gui.inv1 = ui.Create('Inventory', function(self, p)
		self:ShowCloseButton(false)
		self:SetDraggable(false)
		self.childPanels = {}
		self.widthFrame = sizeSlots
		self.heightFrame = sizeSlots
		self.IsCentered = true
		self.addX = parent:GetWide()-(sizeRecipes)-20
		self:setInventory(LocalPlayer():getInv())
	end, scroll)
	scroll:AddItem(rp.gui.inv1)

	local listRecipes = ui.Create('ui_listview', function(self, p)
		self:Dock(RIGHT)
		self:SetWide(sizeRecipes)
		self:DockMargin(0,0,5,0)
		self.Paint = function() end

		self:AddSpacer(translates.Get('Рецепты')):SetTall(23)

		for i=1,rp.item.recipeMaxId do
			for k,v in pairs(rp.item.recipes) do
				if i ~= v.id then continue end

				local btn = ui.Create('rp_buttonRecipes', self)
				btn:SetTall(50)
				btn:SetInfo(v.result.model, k, function()
					surface.PlaySound(table.Random(sounds))
					
					rp.gui.craftable:ClearItemsCrafting()
					for c,d in pairs(v.items) do
						for i=1,d.count do
							rp.gui.craftable:AddItemCrafting(craftableInv, rp.item.list[d.item.uniqueID])
						end
					end
					for c,d in pairs(v.instruments) do
						rp.gui.craftable:AddItemCrafting(craftableInv, rp.item.list[d.uniqueID])
					end
					rp.gui.craftable:CheckRecipes(k)
				end)
				self:AddItem(btn)
			end
		end
	end, parent)

end)

local PANEL = {}
function PANEL:Init()
	self:SetText('')

	self.Model = ui.Create('rp_modelicon', self)
end
function PANEL:PerformLayout()
	self.Model:SetPos(0,0)
	self.Model:SetSize(50,50)
end
function PANEL:PaintOver(w, h)
	local isCan = rp.IsCanCraftItem(LocalPlayer():getInv(), rp.item.recipes[self.Title])
	if isCan then
		draw.RoundedBox(0, self.Model:GetWide(), 1, w-self.Model:GetWide(), h-2, Color(0, 255, 0, 50))
	end

	draw.SimpleTextOutlined(self.Title, 'rp.ui.22', 60, h * .5, rp.col.White, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, rp.col.Black)
end
function PANEL:SetInfo(model, title, doclick)
	self.Model:SetModel(model)

	self.Title = title
	self.DoClick = doclick
	self.Model.DoClick = doclick
end
vgui.Register('rp_buttonRecipes', PANEL, 'DButton')