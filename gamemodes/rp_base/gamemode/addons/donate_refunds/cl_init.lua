-- "gamemodes\\rp_base\\gamemode\\addons\\donate_refunds\\cl_init.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
﻿
local cur_donator
local cur_donates

local frame

local not_return_cats = {
	['Время'] = true,
	['Валюта'] = true,
	['Привелегии'] = true,
	['Ивенты'] = true,
}

local refund_time = 2 * 24 * 60 * 60
local refund_maxtime = 7 * 24 * 60 * 60
local disabled_color = Color(222, 0, 0, 150)
local overdued_color = Color(0, 0, 222, 120)

net.Receive('rp.Donates.SendToPlayer', function()
	local w, h = ScrW() * 0.7, ScrH() * 0.5
	
	if IsValid(frame) then
		frame:Close()
	end
	
	cur_donator = net.ReadString()
	cur_donates = {}
	
	frame = vgui.Create('ui_frame')
	frame:SetTitle('Донат-покупки игрока ' .. cur_donator)
	frame:SetSize(w, h)
	frame:MakePopup()
	frame:Center()
	
	local list = ui.Create('DListView', frame)
	list:Dock(FILL)
	list:SetMultiSelect(false)
	
	list:AddColumn("Дата")
	list:AddColumn("Покупка")
	list:AddColumn("Стоимость тогда")
	list:AddColumn("Стоимость сейчас")
	
	local now = os.time()
	
	for k = 1, net.ReadUInt(12) do
		local donate = {
			time_bought = net.ReadUInt(32),
			upg_id = net.ReadString(),
			cost = net.ReadUInt(13),
			cost_now = net.ReadUInt(13),
		}
		
		local shop_item = rp.shop.GetByUID(donate.upg_id)
		
		if shop_item --[[and not not_return_cats[shop_item.Cat] ]] then
			donate.name = shop_item.Name
			donate.id = k
			
			local line = list:AddLine(os.date("%H:%M:%S - %d/%m/%Y", donate.time_bought), donate.name, donate.cost, donate.cost_now)
			table.insert(cur_donates, donate)
			
			local time_bought = now - donate.time_bought
			local is_disabled = not_return_cats[shop_item.Cat] and 1 or time_bought > refund_maxtime and 2 or false
			
			if is_disabled then
				donate.disabled = is_disabled
			end
			
			line._Paint = line.Paint
			line.Paint = function(this, w, h)
				line._Paint(this, w, h)
				
				if is_disabled then
					surface.SetDrawColor(disabled_color)
					surface.DrawRect(0, 0, w, h)
					
				elseif time_bought > refund_time then 
					surface.SetDrawColor(overdued_color)
					surface.DrawRect(0, 0, w, h)
				end
			end
		end
	end
	
	list.OnRowSelected = function(lst, index, pnl)
		local item = cur_donates[index]
		if not item then return end
		
		list:ClearSelection()
		
		if item.disabled then
			return rp.Notify(NOTIFY_ERROR, item.disabled == 1 and "Вы не можете возвращать покупку из этой категории!" or "Чтобы вернуть донат, купленный более 7 дней назад, обратитесь к кодеру!")
		end
		
		local accept_fr = ui.Create('ui_frame')
		accept_fr:SetTitle('Подтверждение')
		accept_fr:SetSize(420, 140)
		accept_fr:SetPos(ScrW() / 2 - 210, 100)
		accept_fr:MakePopup()
		accept_fr:Focus()
		
		local descript = vgui.Create('DLabel', accept_fr)
		descript:SetText('Подтвердите возврат ' .. item.cost .. ' кредитов за ' .. item.name .. '.\nЭто действие логируется.')
		descript:SetContentAlignment(5)
		descript:SizeToContents()
		descript:Dock(TOP)
		descript:DockMargin(0, 10, 0, 0)
		
		local b2 = vgui.Create('DButton', accept_fr)
		b2:SetText('Отмена')
		b2:Dock(BOTTOM)
		b2:DockPadding(0, 9, 0, 9)
		
		b2.DoClick = function()
			accept_fr:Close()
		end
		
		local b1 = vgui.Create('DButton', accept_fr)
		b1:SetText('Подтверждаю')
		b1:Dock(BOTTOM)
		b1:DockPadding(0, 9, 0, 9)
		
		b1.DoClick = function()
			net.Start('rp.Donates.Return')
				net.WriteUInt(item.id, 12)
			net.SendToServer()
			
			list:RemoveLine(index)
			
			accept_fr:Close()
		end
	end
	
	local descript = vgui.Create('DLabel', frame)
	descript:SetText(' Кликните по донату, который хотите вернуть\n Красные строки не возвращаемы, синие - были куплены более 48 часов назад\n Не возвращаем: Наборы, ' .. table.concat(table.GetKeys(not_return_cats), ', ') .. '\n Возвращаем в том случае, если первое сообщение о возврате в ЛС группы консультанты было написано в течение 48 часов с момента покупки!')
	descript:SizeToContents()
	descript:Dock(BOTTOM)
end)
