-- Подгрузка модуля отключена! Ищи новый чатбокс в rp_base!
local disabled = true

ba.Module('Chatbox')
	:Author('KingOfBeast, Updated by aStonedPenguin')
	:Include(disabled and {} or {
		'vgui_cl.lua',
		'init_cl.lua',
		'init_sh.lua',
		'detour_sv.lua'
	}) 