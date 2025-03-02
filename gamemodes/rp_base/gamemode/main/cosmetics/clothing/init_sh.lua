rp.Clothes 			= rp.Clothes 		or {}
rp.ClothesMapping 	= rp.ClothesMapping or {}

local c = 1
function rp.AddClothing(name, inf)
	/*
	rp.Clothes[name] = inf
	rp.Clothes[name].ID = c
	rp.ClothesMapping[c] = name

	if (CLIENT) then
		wmat.Create(name, {
			URL 	= 'http://cdn.superiorservers.co/rp/sub_materials/' .. inf.URL .. '.png',
			W 		= inf.W or 1024,
			H 		= inf.H or 1024,
			Cache 	= true,
			MaterialData = {
				['$translucent'] = 0,
				['$model'] = 1
			}
		}, function(mat)
			print(name, mat)
			rp.Clothes[name].Material = '!' .. mat:GetName()
		end, function()
			print(name, 'FAILED')
		end)
	end
	c = c + 1*/
end

function PLAYER:GetOutfit()
	if self:GetNetVar('Outfit') then
		return rp.Clothes[rp.ClothesMapping[self:GetNetVar('Outfit')]].Material
	end
end