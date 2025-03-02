-- "gamemodes\\rp_base\\gamemode\\addons\\urf_factory\\meta\\component_sh.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal

local _meta_component = {}
_meta_component.__index = _meta_component

function _meta_component:SetModel(model)
	self.Model = model
	return self
end

function _meta_component:SetLifetime(lifetime)
	self.Lifetime = lifetime
	return self
end

function _meta_component:SetCollideSound(collide_sound)
	self.Sound = Sound(collide_sound)
	return self
end


function rp.factory.AddComponent(name)
	local t = {
		Name = name,
		Lifetime = 30,
	}
	
	t.ID = table.insert(rp.factory.Components, t)
	
	setmetatable(t, _meta_component)
	return t
end
