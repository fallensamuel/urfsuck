rp.hats = rp.hats or {}
rp.hats.list = rp.hats.list or {}
rp.hats.mappings = rp.hats.mappings or {}
local c = 0

function rp.AddHat(data)
	c = c + 1
	data.model = string.lower(data.model or "")
	data.model = string.Replace(data.model, "\\", "/")
	data.model = string.gsub(data.model, "[\\/]+", "/")

	--local Discount = istable(data.Discount) and table.Random(data.Discount) or data.Discount or 0
	--local disc = 1 - Discount

	rp.hats.list[data.model] = {
		name = data.name or 'unknown',
		model = data.model,
		price = data.price,-- * disc,
		ID = c,
		attachment = data.attachment,
		scale = data.scale or 1,
		bone = (!data.attachment && nil) || data.bone || 'ValveBiped.Bip01_Head1',
		modifyClientsideModel = data.modifyClientsideModel or function(self, ply, model, pos, ang) return model, pos, ang end,
		--discount = Discount ~= 0 and Discount
		cfgDiscount = data.Discount,
		cfgPrice = data.Discount and data.price,
		donatePrice = data.donatePrice,
		cfgDonatePrice = data.donatePrice,
	}

	rp.hats.mappings[c] = data.model
end

function PLAYER:SetHat(mdl)
	if (mdl == nil) then
		self:SetNetVar('Hat', nil)
	elseif rp.hats.list[mdl] then
		self:SetNetVar('Hat', rp.hats.list[mdl].ID)
	end
end

function PLAYER:GetHat()
	return self:GetNetVar('Hat') and rp.hats.mappings[self:GetNetVar('Hat')]
end

hook.Add("rp.AddHatsDiscount", "rp.Hats.Discount", function()
	if not rp.cfg.HatsDiscountSettings or not rp.cfg.HatsDiscountSettings.interval then return end
	
	math.randomseed(math.floor(os.time() / rp.cfg.HatsDiscountSettings.interval / 3600))

	local HasAltPrice = {}

	for k, v in pairs(rp.hats.list) do
		if v.cfgDiscount then
			v = table.Copy(v)
			v.key = k
			table.insert(HasAltPrice, v)
		end
	end

	local G = {};
	local AltPriceItems = table.GetKeys(HasAltPrice);

	rp.HatsDiscount = {}

	for i = 1, (rp.cfg.HatsDiscountSettings.count or 1) do
		local hat, key = table.Random(HasAltPrice)
		while G[key] do
			if #table.GetKeys(G) == #table.GetKeys(AltPriceItems) then break end
			hat, key = table.Random(HasAltPrice)
		end

		if not hat then return end
		G[key] = true

		rp.HatsDiscount[key] = hat
	end

	for k, v in pairs(rp.HatsDiscount) do
		local Discount = istable(v.cfgDiscount) and table.Random(v.cfgDiscount) or v.cfgDiscount or 0
		local disc = 1 - Discount

		if rp.hats.list[v.key].cfgPrice then
			local price = v.cfgPrice * disc
			rp.hats.list[v.key].price = price
		end
		if rp.hats.list[v.key].cfgDonatePrice then
			local price = v.cfgDonatePrice * disc
			rp.hats.list[v.key].donatePrice = price
		end
		rp.hats.list[v.key].discount = Discount ~= 0 and Discount
	end

	math.randomseed(os.time())
end)

--hook.Add("rp.AddHatsToDonate", "rp.Hats.Donate", function()
--	for k, v in SortedPairsByMemberValue(rp.hats.list, 'price', false) do
--		if not v.donatePrice and v.price then
--			rp.hats.list[k].donatePrice = v.price < 1000000 and math.floor(v.price / 500) or math.floor(v.price / 2500)
--		end
--	end
--end)

hook.Add("rp.AddHatsToDonate", "rp.Hats.Donate", function()
	for k, v in SortedPairsByMemberValue(rp.hats.list, 'donatePrice', false) do
		if not v.donatePrice then continue end

		rp.shop.Add(v.name, 'hat_' .. v.name):SetCat(translates.Get('Шапки')):SetDesc(translates.Get("Купить %s навсегда", v.name)):SetPrice(v.donatePrice):SetCanBuy(function(self, pl)
			if (pl:HasUpgrade(pl, 'hat_' .. v.name)) or table.HasValue(pl:GetNetVar('HatData') or {}, v.model) then return false, translates.Get('Она у вас уже есть.') end

			return true
		end):SetOnBuy(function(self, pl)
			ba.data.SetHat(pl, v.model)
			local HatData = pl:GetNetVar('HatData') or {}
			table.insert(HatData, v.model)
			pl:SetNetVar('HatData', HatData)
		end):SetHat(v.model)
	end
end)
--[[
hook.Add('rp.AddUpgrades', 'rp.Cosmetics.Hats', function()
	for k, v in SortedPairsByMemberValue(rp.hats.list, 'price', false) do
		if v.createDonate then
			rp.shop.Add(v.name, 'hat_' .. v.name):SetCat(translates.Get('Шапки')):SetDesc(translates.Get("Купить %s навсегда", v.name)):SetPrice(v.price < 1000000 and math.floor(v.price / 500) or math.floor(v.price / 2500)):SetCanBuy(function(self, pl)
				if (pl:HasUpgrade(pl, 'hat_' .. v.name)) or table.HasValue(pl:GetNetVar('HatData') or {}, v.model) then return false, translates.Get('Она у вас уже есть.') end

				return true
			end):SetOnBuy(function(self, pl)
				ba.data.SetHat(pl, v.model)
				local HatData = pl:GetNetVar('HatData') or {}
				table.insert(HatData, v.model)
				pl:SetNetVar('HatData', HatData)
			end):SetHat(v.model)
		end
	end
end)
]]--