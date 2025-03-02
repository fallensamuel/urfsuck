
translates = translates or {
	cur_lang = 'ru',
	text = {},
	cached = {},
	crcs = {},
}

local tr = translates


-- Interface functions
function tr.Set( lang )
	tr.cur_lang = lang
end

function tr.Add( id, lang, text )
	tr.text[lang] = tr.text[lang] or {}
	tr.text[lang][id] = text
end

function tr.Get( id, ... )
	if not tr.text[tr.cur_lang] or not tr.text[tr.cur_lang][id] then 
		return string.format(id, ...)
	end
	
	if ( ({...})[1] ) then
		return string.format( tr.text[tr.cur_lang][id], ... )
	else
		return tr.text[tr.cur_lang][id]
	end
end


-- Language includes
local LangsInclude = function()
	local fol = 'rp_base/gamemode/translations/'
	local files, _ = file.Find(fol .. '*', 'LUA')

	for _, f in ipairs(files) do
		include(fol .. f)
		
		if SERVER then
			AddCSLuaFile(fol .. f)
		end
	end
end

hook.Add("rpBase.Loaded", "Refresh.Translations.After.RpBase.luarefresh", function()
	LangsInclude()
end)

LangsInclude()


-- Language setup & Renaming
hook.Add('PreGamemodeLoaded', 'Translations.Apply', function()
	hook.Run('SetupLanguageTranslation')
	
	local need_to_register
	
	for k, v in pairs( scripted_ents.GetList() ) do
		if v.t then
			need_to_register = false
			
			if v.t.PrintName and tr.Get( v.t.PrintName ) then
				v.t.PrintName = tr.Get( v.t.PrintName )
				need_to_register = true
			end
			
			if v.t.Category and tr.Get( v.t.Category ) then
				v.t.Category = tr.Get( v.t.Category )
				need_to_register = true
			end
			
			if need_to_register then
				scripted_ents.Register( v.t, v.t.ClassName )
			end
		end
	end
	
	scripted_ents.OnLoaded()
	
	for k, v in pairs( weapons.GetList() ) do
		local weapon = weapons.GetStored( v.ClassName )
		
		if weapon then
			need_to_register = false
			
			if weapon.PrintName and tr.Get( weapon.PrintName ) then
				weapon.PrintName = tr.Get( weapon.PrintName )
				need_to_register = true
			end
			
			if weapon.Category and tr.Get( weapon.Category ) then
				weapon.Category = tr.Get( weapon.Category )
				need_to_register = true
			end
			
			if weapon.Instructions and tr.Get( weapon.Instructions ) then
				weapon.Instructions = tr.Get( weapon.Instructions )
				need_to_register = true
			end
			
			if weapon.Purpose and tr.Get( weapon.Purpose ) then
				weapon.Purpose = tr.Get( weapon.Purpose )
				need_to_register = true
			end
			
			if need_to_register then
				weapons.Register( weapon, weapon.ClassName )
			end
		end
	end
	
	weapons.OnLoaded()
	
	if CLIENT and cvar then
		for k, v in pairs(cvar.GetTable) do
			for i, str in pairs(v.Metadata or {}) do
				if tr.Get( str ) then
					v.Metadata[i] = tr.Get( str )
				end
			end
		end
	end
end)
