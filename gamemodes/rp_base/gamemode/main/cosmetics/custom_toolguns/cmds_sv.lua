rp.AddCommand('/buycustomtoolgun', function(ply, text, args)
	if rp.cfg.DisableToolgunSkins then return end

	local class = args[1]
	if not class then return end
	local index = rp.ToolGunSWEPS_k[class]
	if not index then return end
	local sweptab = rp.ToolGunSWEPS[index]
	if not sweptab or sweptab["class"] ~= class then return end

	local ToolgunData = ply:GetNetVar("ToolgunData") or {}
	if table.HasValue(ToolgunData, class) then return end

	if not sweptab.price then
		rp.Notify(ply, NOTIFY_ERROR, rp.Term('ToolgunMdlDonateOnly'))
		return
	end

	if not ply:CanAfford(sweptab.price) then
		rp.Notify(ply, NOTIFY_ERROR, rp.Term('CannotAfford'))
		return
	end

	table.insert(ToolgunData, class)
	ply:SetNetVar("ToolgunData", ToolgunData)

	ba.data.SetCustomToolgun(ply, class, function()
		ply:TakeMoney(sweptab.price)
		rp.Notify(ply, NOTIFY_GREEN, rp.Term('ToolgunMdlPurchasedDonate'), sweptab.name, rp.FormatMoney(sweptab.price))
	end)
end)

rp.AddCommand('/buycustomtoolgundonate', function(ply, text, args)
	if rp.cfg.DisableToolgunSkins then return end

	local class = args[1]
	if not class then return end
	local index = rp.ToolGunSWEPS_k[class]
	if not index then return end
	local sweptab = rp.ToolGunSWEPS[index]
	if not sweptab or sweptab["class"] ~= class then return end

	local ToolgunData = ply:GetNetVar('ToolgunData') or {}
	if table.HasValue(ToolgunData, class) then return end
	
	if not sweptab.donatePrice then
		rp.Notify(ply, NOTIFY_ERROR, rp.Term('ToolgunMdlInGameValutOnly'))
		return
	end

	if not ply:CanAffordCredits(sweptab.donatePrice) then
		rp.Notify(ply, NOTIFY_ERROR, rp.Term('CannotAffordDonate'))
		return
	end

	table.insert(ToolgunData, class)
	ply:SetNetVar("ToolgunData", ToolgunData)

	ba.data.SetCustomToolgun(ply, class, function()
		ply:TakeCredits(sweptab.donatePrice, "buycustomToolgunMdl "..class)
		rp.Notify(ply, NOTIFY_GREEN, rp.Term('ToolgunMdlPurchasedDonate'), sweptab.name, rp.FormatMoney(sweptab.donatePrice))
	end)
end)

rp.AddCommand('/setcustomtoolgun', function(ply, text, args)
	if rp.cfg.DisableToolgunSkins then return end

	local class = args[1]
	if not class then return end
	local index = rp.ToolGunSWEPS_k[class]
	if not index then return end
	local sweptab = rp.ToolGunSWEPS[index]
	if not sweptab or sweptab["class"] ~= class then return end


	local ToolgunData = ply:GetNetVar("ToolgunData")
	if not ToolgunData or not table.HasValue(ToolgunData, class) then return end

	rp.Notify(ply, NOTIFY_GREEN, rp.Term('ToolgunMdlEquipped'), sweptab.name)
	ba.data.SetCustomToolgun(ply, class)
end)

rp.AddCommand('/removecustomtoolgun', function(ply, text, args)
	if rp.cfg.DisableToolgunSkins then return end
	
	rp.Notify(ply, NOTIFY_GREEN, rp.Term('ToolgunMdlRemoved'))
	ba.data.SetCustomToolgun(ply, nil)
end)


local istable = istable
local IsToolGun = {
	["gmod_tool"] = true
}

PLAYER.OldGive = PLAYER.Old or PLAYER.Give
function PLAYER:Give(class, noammo)
	local custom = self:GetNetVar("Toolgun")
	if custom and IsToolGun[class] and istable(rp.ToolGunSWEPS[custom]) then
		class = rp.ToolGunSWEPS[custom].class
	end
	return self:OldGive(class, noammo)
end