
hook.Add('LoadTerms', function()
	rp.AddTerm('ShopSaleStart', 'Акция донат-магазина `-#%` активирована на # часов')
	rp.AddTerm('ShopSaleEnd', 'Акция донат-магазина прекращена')
	rp.AddTerm('ShopSaleCantCreate', 'Скидки не могут быть меньше 10% или больше 70%')
end)

ba.cmd.Create('Discount set', function(pl, args)
	local discount 	= tonumber(args.discount)
	local time 		= args.time
	
	if discount < 10 or discount > 70 then
		rp.Notify(pl, NOTIFY_ERROR, rp.Term('ShopSaleCantCreate'))
		return
	end
	
	rp.SetDiscount(discount, time, true)
	rp.NotifyAll(NOTIFY_GENERIC, rp.Term('ShopSaleStart'), discount, math.floor(time / 3600))
	
	ba.logAction(pl, tostring(discount), 'discount set', tostring(time))
end)
:AddParam('string', 'discount')
:AddParam('time', 'time')
:SetFlag('e')
:SetHelp('Sets a global discount')

ba.cmd.Create('Discount reset', function(pl, args)
	rp.SetDiscount(0, 0)
	rp.NotifyAll(NOTIFY_GENERIC, rp.Term('ShopSaleEnd'))
	
	ba.logAction(pl, '', 'discount reset', '')
end)
:SetFlag('e')
:SetHelp('Removes a global discount')