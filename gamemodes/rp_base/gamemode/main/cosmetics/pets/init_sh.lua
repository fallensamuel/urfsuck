-- "gamemodes\\rp_base\\gamemode\\main\\cosmetics\\pets\\init_sh.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal

rp.pets = rp.pets or {}

rp.pets.All = rp.pets.All or {}
rp.pets.Map = rp.pets.Map or {}

rp.pets.Events = { -- uint(3)
	KILL = 0,
};

function rp.pets.GetById(id)
	return rp.pets.All[id] or false
end

function rp.pets.Get(uid)
	return rp.pets.Map[uid] or false
end

function rp.pets.Add(uid, data)
	data.id = table.insert(rp.pets.All, data)
	data.uid = uid
	
	rp.pets.Map[uid] = data
	
	util.PrecacheModel(data.model)
	
	local upg = rp.shop.Add(data.name, uid)
		:SetCat(translates.Get('Питомцы'))
		:SetPrice(data.donate_price or 1000)
		:SetHidden(data.donate_price == nil)
		:SetDesc(data.donate_desc or [['']])
		:SetIcon(data.model)
		:SetStackable(false)
		:SetNetworked(true)
	
	if data.skin then
		upg:SetSkin(data.skin)
	end
	
	return data
end

nw.Register('Pet')
	:Write(net.WriteUInt, 8)
	:Read(net.ReadUInt, 8)
	:SetPlayer()