-- "gamemodes\\rp_base\\gamemode\\addons\\urf_factory\\meta\\button_sh.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal

local _meta_button = {}
_meta_button.__index = _meta_button

function _meta_button:SetPressSound(sound_path)
	self.Sound = Sound(sound_path)
	return self
end

function _meta_button:SetAllowFunction(check_func)
	self.CustomCheck = check_func
	return self
end

function _meta_button:SetName(btn_name)
	self.Name = btn_name
	return self
end


function rp.factory.AddButton(model)
	local t = {
		Model = model,
	}
	
	t.ID = table.insert(rp.factory.Buttons, t)
	
	setmetatable(t, _meta_button)
	return t
end
