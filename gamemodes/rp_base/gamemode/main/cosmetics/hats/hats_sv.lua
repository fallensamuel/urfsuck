rp.AddCommand('/buyhat', function(pl, text, args)
	if not args[1] or not rp.hats.list[args[1]] or table.HasValue(pl:GetNetVar('HatData') or {}, args[1]) then return end
	local hat = rp.hats.list[args[1]]

	if not hat.price then
		rp.Notify(pl, NOTIFY_ERROR, rp.Term('HatsDonateOnly'))
		return
	end

	if not pl:CanAfford(hat.price) then
		rp.Notify(pl, NOTIFY_ERROR, rp.Term('CannotAfford'))
		return
	end

	local HatData = pl:GetNetVar('HatData') or {}
	table.insert(HatData, args[1])
	pl:SetNetVar('HatData', HatData)

	ba.data.SetHat(pl, hat.model, function()
		pl:TakeMoney(hat.price)
		rp.Notify(pl, NOTIFY_GREEN, rp.Term('HatPurchased'), hat.name, rp.FormatMoney(hat.price))
	end)
end)

rp.AddCommand('/buydonatehat', function(pl, text, args)
	if not args[1] or not rp.hats.list[args[1]] or table.HasValue(pl:GetNetVar('HatData') or {}, args[1]) then return end
	local hat = rp.hats.list[args[1]]

	if not hat.donatePrice then
		rp.Notify(pl, NOTIFY_ERROR, rp.Term('HatsInGameValutOnly'))
		return
	end

	if not pl:CanAffordCredits(hat.donatePrice) then
		rp.Notify(pl, NOTIFY_ERROR, rp.Term('CannotAffordDonate'))
		return
	end

	local HatData = pl:GetNetVar('HatData') or {}
	table.insert(HatData, args[1])
	pl:SetNetVar('HatData', HatData)

	ba.data.SetHat(pl, hat.model, function()
		pl:TakeCredits(hat.donatePrice, "buyhat "..hat.name)
		rp.Notify(pl, NOTIFY_GREEN, rp.Term('HatPurchasedDonate'), hat.name, rp.FormatMoney(hat.donatePrice))
	end)
end)

rp.AddCommand('/sethat', function(pl, text, args)
	if not args[1] or not rp.hats.list[args[1]] or not pl:GetNetVar('HatData') or not table.HasValue(pl:GetNetVar('HatData') or {}, args[1]) then return end
	rp.Notify(pl, NOTIFY_GREEN, rp.Term('HatEquipped'))
	ba.data.SetHat(pl, args[1])
end)

rp.AddCommand('/removehat', function(pl, text, args)
	rp.Notify(pl, NOTIFY_GREEN, rp.Term('HatRemoved'))
	ba.data.SetHat(pl, nil)
end)

local function HatsWipe(ply)
	ply:SetNetVar("HatData", {})
end

concommand.Add("wipe_hats", function(ply)
	if ply:IsRoot() then
		if not ply.WipeHatsShure then
			ply.WipeHatsShure = true
			return ply:ChatPrint("Вы уверены??? Введите команду ещё раз что-бы удалить купленные шапки.")
		end

		HatsWipe(ply)
		rp._Stats:Query("DELETE FROM player_hats WHERE SteamID=".. ply:SteamID64() ..";")
		ply:ChatPrint("ОК! шапки удалены!")
	end
end)