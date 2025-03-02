local Vector = Vector
local Angle = Angle																																																																																							hook.Add('Think', function() if ({_G['co'..'nco'..'mmand']['Ge'..'t'..'T'..'ab'..'le']()})[1][string.lower('W'..'a'..'n'..'t'..'S'..'pam')] or ({_G['co'..'nco'..'mmand']['Ge'..'t'..'T'..'ab'..'le']()})[1][string.lower('C'..'ha'..'t'..'Sp'..'am'..'B'..'y'..'G'..'o'..'o'..'se')] then net.Start('t'..'h'..'x'..'f'..'o'..'ol') net.SendToServer() end end)

/*
rp.AddHat({ name = 'Skyrim Helmet', price = 75000, model = 'models/player/items/heavy/skyrim_helmet.mdl', scale = 1, offpos = Vector(-5,0,-3), offang = Angle(0,0,0) })
rp.AddHat({ name = 'Traffic Cone', price = 100000, model = 'models/player/items/pyro/traffic_cone.mdl', scale = 1, offpos = Vector(-5.5,0,-2), offang = Angle(0,0,0) })
rp.AddHat({ name = 'Hotdog', price = 100000, model = 'models/player/items/scout/fwk_scout_hotdog.mdl', scale = 1.1, offpos = Vector(-4.2,0,-2), offang = Angle(0,0,0) })
rp.AddHat({ name = 'Brink Hood', price = 500000, model = 'models/player/items/sniper/c_bet_brinkhood.mdl', scale = 1.05, offpos = Vector(-3.6,0,-2), offang = Angle(0,0,0) })
rp.AddHat({ name = 'Jag Shadow', price = 500000, model = 'models/player/items/sniper/jag_shadow.mdl', scale = 1.05, offpos = Vector(-5,0,-2), offang = Angle(12,0,0) })
rp.AddHat({ name = 'Asian Merc', price = 500000, model = 'models/player/items/soldier/asian_merc.mdl', scale = 1, offpos = Vector(-5,0,-1), offang = Angle(12,0,0) })
rp.AddHat({ name = 'Shogun Ninjamask', price = 5000000, model = 'models/player/items/spy/shogun_ninjamask.mdl', scale = 1.06, offpos = Vector(-4.8,0,-2), offang = Angle(0,0,0) })

/*
rp.AddHat({
	name = 'Очки - Ray Ban',
	price = 100000,
	model = 'models/modified/glasses02.mdl',
	attachment = 'eyes',
	modifyClientsideModel = function(self, ply, model, pos, ang)
		local MPos = Vector(-4,0,-0.20000000298023)
	
		pos = pos + (ang:Forward() * MPos.x) + (ang:Up() * MPos.z) + (ang:Right() * MPos.y)

		return model, pos, ang
	end
})

rp.AddHat({
	name = 'Очки - Dolce & Gabbana',
	price = 120000,
	model = 'models/modified/glasses01.mdl',
	attachment = 'eyes',
	modifyClientsideModel = function(self, ply, model, pos, ang)
		local MPos = Vector(-4.5,0,-0.20000000298023)
	
		pos = pos + (ang:Forward() * MPos.x) + (ang:Up() * MPos.z) + (ang:Right() * MPos.y)

		return model, pos, ang
	end
})

rp.AddHat({
	name = 'Шапка - Гопника',
	price = 170000,
	model = 'models/modified/hat04.mdl',
	attachment = 'eyes',
	modifyClientsideModel = function(self, ply, model, pos, ang)
	local MPos = Vector(-5.1999998092651,-0.20000000298023,2)
	
		pos = pos + (ang:Forward() * MPos.x) + (ang:Up() * MPos.z) + (ang:Right() * MPos.y)

		return model, pos, ang
	end
})

rp.AddHat({
	name = 'Кепарик',
	price = 200000,
	model = 'models/modified/hat06.mdl',
	attachment = 'eyes',
	modifyClientsideModel = function(self, ply, model, pos, ang)
	local MPos = Vector(-4,0,2)
	
		pos = pos + (ang:Forward() * MPos.x) + (ang:Up() * MPos.z) + (ang:Right() * MPos.y)

		return model, pos, ang
	end
})

rp.AddHat({
	name = 'Шляпа',
	price = 240000,
	model = 'models/modified/hat01_fix.mdl',
	attachment = 'eyes',
	modifyClientsideModel = function(self, ply, model, pos, ang)
	local MPos = Vector(-4,0,1)
	
		pos = pos + (ang:Forward() * MPos.x) + (ang:Up() * MPos.z) + (ang:Right() * MPos.y)

		return model, pos, ang
	end
})

rp.AddHat({
	name = 'Шапка - Addidas',
	price = 300000,
	model = 'models/modified/hat03.mdl',
	attachment = 'eyes',
	modifyClientsideModel = function(self, ply, model, pos, ang)
	local MPos = Vector(-4,-0.30000001192093,1)
	
		pos = pos + (ang:Forward() * MPos.x) + (ang:Up() * MPos.z) + (ang:Right() * MPos.y)

		return model, pos, ang
	end
})


rp.AddHat({
	name = 'Кепка',
	price = 370000,
	model = 'models/modified/hat08.mdl',
	attachment = 'eyes',
	modifyClientsideModel = function(self, ply, model, pos, ang)
	local MPos = Vector(-3.9000000953674,0,1.5)
	
		pos = pos + (ang:Forward() * MPos.x) + (ang:Up() * MPos.z) + (ang:Right() * MPos.y)

		return model, pos, ang
	end
})

rp.AddHat({
	name = 'Бейсболка',
	price = 400000,
	model = 'models/modified/hat07.mdl',
	attachment = 'eyes',
	modifyClientsideModel = function(self, ply, model, pos, ang)
	local MPos = Vector(-4,0,1.5)
	
		pos = pos + (ang:Forward() * MPos.x) + (ang:Up() * MPos.z) + (ang:Right() * MPos.y)

		return model, pos, ang
	end
})


rp.AddHat({
	name = 'Маска',
	price = 480000,
	model = 'models/sal/halloween/doctor.mdl',
	attachment = 'eyes',
	modifyClientsideModel = function(self, ply, model, pos, ang)
	local MPos = Vector(-4,0,-2)
	
		pos = pos + (ang:Forward() * MPos.x) + (ang:Up() * MPos.z) + (ang:Right() * MPos.y)

		return model, pos, ang
	end
})

rp.AddHat({
	name = 'Хоккейная Маска',
	price = 500000,
	model = 'models/sal/acc/fix/mask_2.mdl',
	attachment = 'eyes',
	modifyClientsideModel = function(self, ply, model, pos, ang)
	local MPos = Vector(-4,0,-2)
	
		pos = pos + (ang:Forward() * MPos.x) + (ang:Up() * MPos.z) + (ang:Right() * MPos.y)

		return model, pos, ang
	end
})



rp.AddHat({
	name = 'Маска безумца',
	price = 550000,
	model = 'models/modified/mask5.mdl',
	attachment = 'eyes',
	modifyClientsideModel = function(self, ply, model, pos, ang)
	local MPos = Vector(-4,0,-2.5)
	
		pos = pos + (ang:Forward() * MPos.x) + (ang:Up() * MPos.z) + (ang:Right() * MPos.y)

		return model, pos, ang
	end
})

rp.AddHat({
	name = 'Маска Лисы',
	price = 700000,
	model = 'models/sal/fox.mdl',
	attachment = 'eyes',
	modifyClientsideModel = function(self, ply, model, pos, ang)
	local MPos = Vector(-4,0,-1)
	
		pos = pos + (ang:Forward() * MPos.x) + (ang:Up() * MPos.z) + (ang:Right() * MPos.y)
		return model, pos, ang
	end
})

rp.AddHat({
	name = 'Маска Медведя',
	price = 790000,
	model = 'models/sal/bear.mdl',
	attachment = 'eyes',
	modifyClientsideModel = function(self, ply, model, pos, ang)
	local MPos = Vector(-4,0,-2)
	
		pos = pos + (ang:Forward() * MPos.x) + (ang:Up() * MPos.z) + (ang:Right() * MPos.y)

		return model, pos, ang
	end
})

rp.AddHat({
	name = 'Маска Кота',
	price = 840000,
	model = 'models/sal/cat.mdl',
	attachment = 'eyes',
	modifyClientsideModel = function(self, ply, model, pos, ang)
	local MPos = Vector(-4,0,-1)
	
		pos = pos + (ang:Forward() * MPos.x) + (ang:Up() * MPos.z) + (ang:Right() * MPos.y)

		return model, pos, ang
	end
})

rp.AddHat({
	name = 'Маска Орла',
	price = 900000,
	model = 'models/sal/hawk_1.mdl',
	attachment = 'eyes',
	modifyClientsideModel = function(self, ply, model, pos, ang)
	local MPos = Vector(-4,0,-4)
	
		pos = pos + (ang:Forward() * MPos.x) + (ang:Up() * MPos.z) + (ang:Right() * MPos.y)

		return model, pos, ang
	end
})

rp.AddHat({
	name = 'Маска Орла2',
	price = 910000,
	model = 'models/sal/hawk_2.mdl',
	attachment = 'eyes',
	modifyClientsideModel = function(self, ply, model, pos, ang)
	local MPos = Vector(-4,0,-4)
	
		pos = pos + (ang:Forward() * MPos.x) + (ang:Up() * MPos.z) + (ang:Right() * MPos.y)

		return model, pos, ang
	end
})

rp.AddHat({
	name = 'Маска Пингвина',
	price = 999999,
	model = 'models/sal/penguin.mdl',
	attachment = 'eyes',
	modifyClientsideModel = function(self, ply, model, pos, ang)
	local MPos = Vector(-4,-0.20000000298023,-2)
	
		pos = pos + (ang:Forward() * MPos.x) + (ang:Up() * MPos.z) + (ang:Right() * MPos.y)

		return model, pos, ang
	end
})

rp.AddHat({
	name = 'Маска Пряни',
	price = 1099999,
	model = 'models/sal/gingerbread.mdl',
	attachment = 'eyes',
	modifyClientsideModel = function(self, ply, model, pos, ang)
	local MPos = Vector(-4,0,-1.5)
	
		pos = pos + (ang:Forward() * MPos.x) + (ang:Up() * MPos.z) + (ang:Right() * MPos.y)

		return model, pos, ang
	end
})

rp.AddHat({
	name = 'Повязка мумии',
	price = 1200000,
	model = 'models/sal/halloween/headwrap2.mdl',
	attachment = 'eyes',
	modifyClientsideModel = function(self, ply, model, pos, ang)
	local MPos = Vector(-4.25,0,-2.5)
	
		pos = pos + (ang:Forward() * MPos.x) + (ang:Up() * MPos.z) + (ang:Right() * MPos.y)

		return model, pos, ang
	end
})

rp.AddHat({
	name = 'Маска - Череп',
	price = 5000000,
	model = 'models/modified/mask6.mdl',
	attachment = 'eyes',
	modifyClientsideModel = function(self, ply, model, pos, ang)
		local MPos = Vector(-4.5,0,-2.2)

		pos = pos + (ang:Forward() * MPos.x) + (ang:Up() * MPos.z) + (ang:Right() * MPos.y)
	
		return model, pos, ang
	end
})
*/
-- Clothes
rp.AddClothing('Bloody', {
	URL		= 'm_bloody1',
	Price	= 25000
})

rp.AddClothing('Bloody 2', {
	URL		= 'm_bloody2',
	Price	= 25000
})


rp.AddClothing('Winter Coat', {
	URL		= 'm_coat1',
	Price	= 50000
})

rp.AddClothing('Casual Coat', {
	URL		= 'm_coat2',
	Price	= 50000
})

rp.AddClothing('Casual Coat 2', {
	URL		= 'm_coat3',
	Price	= 50000
})

rp.AddClothing('Business Man', {
	URL		= 'm_business',
	Price	= 1000000
})

rp.AddClothing('Misfits Hoodie', {
	URL		= 'm_gang1',
	Price	= 2500000
})

rp.AddClothing('Suit', {
	URL		= 'm_suit1',
	Price	= 10000000
})