
rp.meta.capture_bbox = {}
rp.meta.capture_bbox.__index = rp.meta.capture_bbox

function rp.meta.capture_bbox:SetPos(pos, ang) 
	self.pos = pos
	self.ang = ang
	
	return self
end

function rp.meta.capture_bbox:SetPrintName(printName) 
	self.printName = printName
	return self
end

function rp.meta.capture_bbox:SetAddMoney(money) 
	self.payment = money
	return self
end

function rp.meta.capture_bbox:SetGiveAmmo(ammo_type, amount) 
	self.add_ammo = { ammo = ammo_type, amount = amount }
	return self
end

function rp.meta.capture_bbox:SetGiveAmmos(multiplier) 
	self.add_ammos = multiplier
	return self
end

function rp.meta.capture_bbox:SetGiveArmor(amount) 
	self.add_armor = amount
	return self
end

function rp.meta.capture_bbox:SetWeaponAlliance(alliance, ...)
	self.spWeapons = self.spWeapons or {}
	self.spWeapons[alliance] = {...}
	
	return self
end

function rp.meta.capture_bbox:SetWeaponDefault(...)
	return self:SetWeaponAlliance(0, ...) 
end
