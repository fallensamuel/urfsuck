-- "gamemodes\\rp_base\\gamemode\\addons\\urf_factory\\meta\\place_sh.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal

local _meta_place = {}
_meta_place.__index = _meta_place

function _meta_place:SetZone(map, pos_1, pos_2)
	if map == game.GetMap() then 
		self.Zone = { pos_1, pos_2 }
	end
	
	return self
end

function _meta_place:SetButton(button)
	self.Button = button
	return self
end

function _meta_place:AddComponent(component)
	table.insert(self.Components, component)
	return self
end

function _meta_place:SetResultItem(item_id)
	self.ItemID = item_id
	return self
end

function _meta_place:AddWorkplace(map, data)
	if map == game.GetMap() then 
		data.Place = self
		data.WorkplaceID = table.insert(self.Workplaces, data)
	end
	
	return self
end


function rp.factory.AddPlace(name)
	local t = {
		Name = name,
		Components = {},
		Workplaces = {},
	}
	
	t.ID = table.insert(rp.factory.Places, t)
	
	setmetatable(t, _meta_place)
	return t
end
