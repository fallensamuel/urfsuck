-- "gamemodes\\rp_base\\gamemode\\addons\\urf_factory\\meta\\storage_sh.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal

local _meta_storage = {}
_meta_storage.__index = _meta_storage

function _meta_storage:SetPos(map, pos, ang)
	if map == game.GetMap() then 
		self.Pos = pos
		self.Ang = ang
	end
	
	return self
end

function _meta_storage:SetModel(model)
	self.Model = model
	return self
end

function _meta_storage:AddVendor(vendor_name)
	self.Vendors[vendor_name] = true
	return self
end

function _meta_storage:SetBuySound(buy_sound)
	self.BuySound = buy_sound
	return self
end

function _meta_storage:SetMaxAmount(max_amount)
	self.MaxAmount = max_amount
	return self
end

function _meta_storage:SetAllowFunction(check_func)
	self.CustomCheck = check_func
	return self
end

function _meta_storage:AddStoragedItem(item_data)
	self.StorageItems[item_data.id] = item_data
	return self
end

function _meta_storage:AddBenefit(benefit_data)
	benefit_data.ID = table.insert(self.StorageBenefits, benefit_data)
	return self
end


function rp.factory.AddStorage(name)
	local t = {
		Name = name,
		StorageItems = {},
		StorageBenefits = {},
		Vendors = {},
	}
	
	t.ID = table.insert(rp.factory.Storages, t)
	
	setmetatable(t, _meta_storage)
	return t
end
