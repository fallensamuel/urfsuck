local colors = {
	["background"] 	= Color(25, 25, 25, 125),
	["fill"] 		= Color(255, 255, 255, 75)
}

local Handle = {
	Progress = function(target)
		local actor = LocalPlayer()
		local background = vgui.Create("EditablePanel")
		background:SetSize(200, 12)
		background:Center()
		background.Y = background.Y - background:GetTall()
		background.Paint = function(me, w, h)
			surface.SetDrawColor(colors.background)
			surface.DrawRect(0, 0, w, h)
		end
		background.Think = function(me)
			local tr_ent = actor:GetEyeTrace().Entity
			if IsValid(target) == false or IsValid(tr_ent) == false or tr_ent ~= target or not target:CanConfiscateBy(actor) then
				me:Remove()
				return false
			end
		end

		local end_wide = background:GetWide()
		background.fill = background:Add("EditablePanel")
		background.fill:Dock(LEFT)
		background.fill:SetSize(0, background:GetTall())
		background.fill.Paint = function(me, w, h)
			colors.fill.a = 50 + w/end_wide*100
			surface.SetDrawColor(colors.fill)
			surface.DrawRect(0, 0, w, h)
		end
		background.fill:SizeTo(background:GetWide(), background:GetTall(), rp.GetConfiscationTime(actor), 0, -1, function()
			if IsValid(background) then
				background:AlphaTo(0, 0.3, 0, function()
					if IsValid(background) then background:Remove() end
				end)
			end
		end)

		local Text = translates.Get("Обыскиваю") or "Обыскиваю"
		local Dots = ""
		local Cooldown, NextChange = 0.65, 0

		
		surface.CreateFont("ConfiscationTxt", {
	        font = "Montserrat",
	        size = 24,
	        extended  = true
	    })

		background.txt = vgui.Create("EditablePanel")
		background.txt:SetSize(background:GetWide(), 30)
		background.txt:Center()
		background.txt.Y = background.txt.Y + 16
		background.txt.Paint = function(me, w, h)
			draw.SimpleText(Text .. Dots, "ConfiscationTxt", w*0.5, 0, colors.fill, TEXT_ALIGN_CENTER)
		end
		background.txt.Think = function(me)
			if IsValid(background) == false then
				me:Remove()
				return
			end

			local CT = CurTime()
			if NextChange <= CT then
				NextChange = CT + Cooldown
				Dots = Dots:len() >= 3 and "" or (Dots .. ".")
			end
		end
	end,
	Menu = function(target)
		rp.FakeInventoryOpened = true
		local inv = LocalPlayer():getInv()
		rp.item.CreateInventory(nil, inv, target:SteamID64(), {
			name = translates.Get("КОНФИСКАЦИЯ"), 
			disableTakeAll = true,
		});

		rp.LootInventory.Panels.InventoryMenu.OnRemove = function()
			rp.FakeInventoryOpened = nil
		end
		rp.LootInventory.Panels.InventoryMenu:Center()
		for k, v in pairs(rp.LootInventory.Panels.InventoryMenu.PlayerInventory.panels) do
			v:Remove()
		end
		rp.LootInventory.Panels.InventoryMenu.PlayerInventory.panels = {}

		local xCounter, yCounter = 0, 1

		local forGridSize = 0
		local inRelease
		local weapons = target:GetWeapons()
		for i, wep in pairs(weapons) do
			local price = rp.cfg.ConfiscationWeapons[wep:GetClass()]
			if not price then continue end
			xCounter = xCounter + 1
			if xCounter > 5 then
				xCounter = 1
				yCounter = yCounter + 1
			end

			forGridSize = forGridSize + 1
			local icon = rp.LootInventory.Panels.InventoryMenu.PlayerInventory:addIcon(wep:GetModel() or "models/props_junk/popcan01a.mdl", xCounter, yCounter, 1, 1)
			if not IsValid(icon) then continue end

			local printName = wep:GetPrintName() or wep:GetClass()
			icon:SetToolTip(printName)
			icon.OnMouseReleased = function(me)
				if inRelease then return end
				inRelease = true
				timer.Simple((rp.cfg.ConfiscationTime or 5) + 0.5, function() inRelease = nil end)
				me.ReleaseEnd = CurTime() + (rp.cfg.ConfiscationTime or 5)

				net.Start("urf.im/addons/confiscation")
					net.WriteUInt(i, 6)
				net.SendToServer()
				timer.Simple((rp.cfg.ConfiscationTime or 5), function()
					rp.Notify(NOTIFY_GREEN, "Вы конфисковали `".. printName .."`! Награда: ".. rp.FormatMoney(price))
				end)
			end
			icon.OnMousePressed, icon.doRightClick, icon.actionsMenu, icon.move = nil, nil, nil, nil
			icon.ExtraPaint = function(me, w, h)
				if me.ReleaseEnd then
					if CurTime() >= me.ReleaseEnd then
						me:Remove()
						return
					end

					surface.SetDrawColor(225, 50, 0, 125)
					surface.DrawRect(0, 0, w - w * (me.ReleaseEnd - CurTime()), h);
				end

				if me.isUsed then
					surface.SetDrawColor(255,255,0,20)
					surface.DrawRect( 0, 0, w, h );
				end
			end
		end

		forGridSize = math.max(math.floor(forGridSize/5), 5)
		local parent = rp.LootInventory.Panels.InventoryMenu.PlayerInventory:GetParent():GetParent()
		parent:SetTall(50 + 64*forGridSize)
		parent:Center()
		rp.LootInventory.Panels.InventoryMenu.PlayerInventory:setGridSize(5, forGridSize)
	end
}

local LastTarget
net.Receive("urf.im/addons/confiscation", function()
	local target = net.ReadEntity()
	if IsValid(target) then
		LastTarget = target
		Handle.Progress(target)
	elseif IsValid(LastTarget) then
		Handle.Menu(LastTarget)
	end
end)