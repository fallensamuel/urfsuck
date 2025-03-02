ba.Module('Jukebox')
	:Author('aStonedPenguin')
	:Include({
		'core/core_sv.lua',
		'core/core_cl.lua',
		'core/commands_sh.lua',
		'core/menu_cl.lua',
	})
	:CustomCheck(function() -- disabled
		return false
	end)