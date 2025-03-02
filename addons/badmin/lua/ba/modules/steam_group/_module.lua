local disabled = true

ba.Module('Steam Group Request')
	:Author('KingOfBeast Updated by aStonedPenguin')
	:Include(disabled and {} or {
		'init_cl.lua',
		'init_sh.lua',
		'init_sv.lua',
	})