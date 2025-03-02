-- "gamemodes\\rp_base\\gamemode\\main\\capture\\bonusbox_mt_sh.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal

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

function rp.meta.capture_bbox:SetCustomCheck(func, force)
	self.customCheck = func

	if force then
		for _, item_tbl in ipairs( self.items ) do
			local f = item_tbl.check;
			item_tbl.check = f and (function(ply) return self.customCheck(ply) and f(ply) end) or self.customCheck;
		end	
	end

	return self
end

function rp.meta.capture_bbox:AddDrop(item_tbl)
	self.items = self.items or {};

	if self.customCheck then
		local f = item_tbl.check;
		item_tbl.check = f and (function(ply) return self.customCheck(ply) and f(ply) end) or self.customCheck;
	end

	table.insert( self.items, item_tbl );
	
	return self
end

function rp.meta.capture_bbox:SetAddMoney(money)
	self.payment = money

	self:AddDrop( {
		type   = "money",
		icon   = Material( "rpui/bonus_menu/cash" ),
		v      = money,
		rarity = 0,
        weight = 1,
	} );

	return self
end

function rp.meta.capture_bbox:SetGiveAmmo(ammo_type, amount)
	self.add_ammo = { ammo = ammo_type, amount = amount }

	self:AddDrop( {
		type   = "ammo",
		icon   = Material( "rpui/bonus_menu/ammo" ),
		v      = { ammo_type, amount },
		rarity = 0,
        weight = 1,
	} );

	return self
end

function rp.meta.capture_bbox:SetGiveAmmos(multiplier)
	self.add_ammos = multiplier

	self:AddDrop( {
		type   = "ammos",
		icon   = Material( "rpui/bonus_menu/ammo" ),
		v      = multiplier,
		rarity = 0,
        weight = 1,
	} );

	return self
end

function rp.meta.capture_bbox:SetGiveArmor(amount)
	self.add_armor = amount

	self:AddDrop( {
		type   = "armor",
		icon   = Material( "rpui/icons/armor" ),
		v      = amount,
		rarity = 0,
        weight = 1,
	} );

	return self
end

function rp.meta.capture_bbox:SetWeaponAlliance(alliance, ...)
	self.spWeapons = self.spWeapons or {}
	self.spWeapons[alliance] = {...}
	
	self:AddDrop( {
		type   = "custom",
		icon   = Material( "rpui/icons/haslicense" ),
		rarity = 0,
		weight = 1,
		v = function( ply )
			local cur_weps = self.spWeapons[ply:GetAlliance()] or self.spWeapons[0];
			
			if cur_weps then
				for i = 1, #cur_weps do
					ply:Give( cur_weps[i] );
				end
				
				rp.Notify( ply, NOTIFY_GREEN, rp.Term("CaptureRewardsBox.GiveWeapon"), table.concat(cur_weps, ", ") );
			end
		end,
		check = function( ply )
			local point = rp.Capture.Points[self.point_id or -1]
			return point and not point.isOrg and IsValid( self.spWeapons[ply:GetAlliance()] ) or IsValid( self.spWeapons[0] );
		end
	} );
	
	return self
end

function rp.meta.capture_bbox:SetWeaponDefault(...)
	return self:SetWeaponAlliance(0, ...) 
end