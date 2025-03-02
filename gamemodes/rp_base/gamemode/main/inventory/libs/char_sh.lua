-- "gamemodes\\rp_base\\gamemode\\main\\inventory\\libs\\char_sh.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local playerMeta = FindMetaTable("Player")

function playerMeta:getID()
	return self:SteamID64()
end

function playerMeta:getInv()
	return rp.item.inventories[self:getInvID()]
end

function playerMeta:getInvID()
	return self:GetNWInt("InventoryID")
end

function playerMeta:getItemDropPos()
	if not IsValid(self) then 
		return Vector(0, 0, 0)
	end
	
	local data = {}
		data.start = self:GetShootPos()
		data.endpos = self:GetShootPos() + self:GetAimVector()*86
		data.filter = self
	local trace = util.TraceLine(data)
		data.start = trace.HitPos
		data.endpos = data.start + trace.HitNormal*46
		data.filter = {}
	trace = util.TraceLine(data)

	return trace.HitPos
end

if SERVER then
	function playerMeta:addInvSlots(quantity)
		local inv = self:getInv()
		quantity = quantity or 1

		if inv == nil then return false end

		for i=1,quantity do
			inv.h = inv.h + 1
			rp._Inventory:Query("UPDATE inventories SET _height = ? WHERE _invID = ?;", inv.h, inv.id)
		end

		inv:sync(self)

		return true
	end

	function playerMeta:isCanInvUpgrade()
		local inv = self:getInv()
		
		if not inv or not inv.h then 
			return false 
		end
		
		if (inv.h+1) > rp.cfg.MaxInvHeight then
			return false
		end
		
		return true
	end
end