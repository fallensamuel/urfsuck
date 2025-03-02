PLAYER = FindMetaTable'Player'
ENTITY = FindMetaTable'Entity'
VECTOR = FindMetaTable'Vector'

local INCLUDE_SH = 0
local INCLUDE_SV = 1
local INCLUDE_CL = 2

translates = translates or {
	Get = function(str, ...)
		if ( ({...})[1] ) then
			return string.format( str, ... )
		else
			return str
		end
	end
}

local CoreIncludes = {
	npcs 		 = true, 
	emoteactions = false,
	wos = {
		{'core_sh.lua', 				 	rp.include_sh},
		{'metatable_sh.lua', 			 	rp.include_sh},
		{'holdtypes_sh.lua', 			 	rp.include_sh},
		{'holdtypes_melee-combo_sh.lua', 	rp.include_sh}
	},
	attributes = {
		{'sh_init.lua', 					rp.include_sh}, 
		{'sv_init.lua', 					rp.include_sv}, 
		{'sv_player_meta.lua', 				rp.include_sv}, 
		{'cl_player_meta.lua', 				rp.include_cl}, 
		{'cl_menu.lua', 					rp.include_cl}, 
		{'cl_init.lua', 					rp.include_cl}, 
		{'derma/dattributeprogressbar.lua',	rp.include_cl}
	}, 
	capture = {
		{'init_sh.lua', 					rp.include_sh}, 
		{'territories_cl.lua', 				rp.include_cl}, 
		{'hud_cl.lua', 						rp.include_cl}
	},
	inventory = {
		{'init_sh.lua', 					rp.include_sh}
	},
	interact_menu = {
		{"nexus_load.lua", rp.include_sh},
		{"ping_system_load.lua", rp.include_sh},
	},
	chatbox = {
		{"sh_init.lua", rp.include_sh}
	},
	donations = {
		{"load_sh.lua", rp.include_sh}
	}
}


if (SERVER) then
	require'mysql'
else
	require'cvar'
	require'wmat'
	wmat.SetHandler'http://urf.im/wmathandler.php?url='
end

require'nw'
require'pon'
require'pcolor'
require'xfn'

GM.Name = 'rp_base'
GM.Author = 'band0'
GM.Website = 'urf.im'

rp.include_dir'util'

rp.include_dir('main', false)

rp.include_sh'terms.lua'
rp.include_sh'cfg_default.lua'

rp.include_dir'main/sandbox'
rp.include_dir('main/chat', false)
rp.include_dir'main/customtime'
rp.include_dir'main/menus'
rp.include_dir'main/player'
rp.include_dir'main/credits'
rp.include_dir('main/doors', false)
rp.include_dir'main/ui'
rp.include_dir('main/prop_protect', false)
rp.include_dir'main/cosmetics'
rp.include_dir('main/orgs', false)
rp.include_dir('main/makethings', false)
rp.include_dir('main/events', false)

for k, v in pairs(CoreIncludes) do
	if not (rp.cfg.DisableCores and rp.cfg.DisableCores[k]) then
		if istable(v) then
			for _, t in ipairs(v) do
				t[2]('main/' .. k .. '/' .. t[1])
			end
		else
			rp.include_dir('main/' .. k, v)
		end
	end
end

--[[
rp.include_dir'main/npcs'

rp.include_dir('main/emoteactions', false)

rp.include_sh'main/attributes/sh_init.lua'
rp.include_sv'main/attributes/sv_init.lua'
rp.include_sv'main/attributes/sv_player_meta.lua'
rp.include_cl'main/attributes/cl_player_meta.lua'
rp.include_cl'main/attributes/cl_menu.lua'
rp.include_cl'main/attributes/cl_init.lua'
rp.include_cl'main/attributes/derma/DAttributeProgressBar.lua'

rp.include('main/capture/init_sh.lua')
rp.include('main/capture/territories_cl.lua')
rp.include('main/capture/hud_cl.lua')
]]

rp.LoadModules('addons') --Depricated

/*
rp.include_sh'util/medialib/medialib.lua'
rp.include_sh'util/medialib/volume3d.lua'
rp.include_sh'util/medialib/services/youtube.lua'
rp.include_sh'util/medialib/services/webradio.lua'
--rp.include_sh 'util/medialib/services/webm.lua'
rp.include_sh'util/medialib/services/vimeo.lua'
rp.include_sh'util/medialib/services/twitch.lua'
rp.include_sh'util/medialib/services/soundcloud.lua'
rp.include_sh'util/medialib/services/mp4.lua'
*/

local msg = {
"                                        ffffffffffffffff                 iiii                          ",
"                                       f::::::::::::::::f               i::::i                         ",
"                                      f::::::::::::::::::f               iiii                          ",
"                                      f::::::fffffff:::::f                                             ",
"uuuuuu    uuuuuu rrrrr   rrrrrrrrr    f:::::f       ffffff             iiiiiii    mmmmmmm    mmmmmmm   ",
"u::::u    u::::u r::::rrr:::::::::r   f:::::f                          i:::::i  mm:::::::m  m:::::::mm ",
"u::::u    u::::u r:::::::::::::::::r f:::::::ffffff                     i::::i m::::::::::mm::::::::::m",
"u::::u    u::::u rr::::::rrrrr::::::rf::::::::::::f                     i::::i m::::::::::::::::::::::m",
"u::::u    u::::u  r:::::r     r:::::rf::::::::::::f                     i::::i m:::::mmm::::::mmm:::::m",
"u::::u    u::::u  r:::::r     rrrrrrrf:::::::ffffff                     i::::i m::::m   m::::m   m::::m",
"u::::u    u::::u  r:::::r             f:::::f                           i::::i m::::m   m::::m   m::::m",
"u:::::uuuu:::::u  r:::::r             f:::::f                           i::::i m::::m   m::::m   m::::m",
"u:::::::::::::::uur:::::r            f:::::::f                         i::::::im::::m   m::::m   m::::m",
" u:::::::::::::::ur:::::r            f:::::::f             ......      i::::::im::::m   m::::m   m::::m",
"  uu::::::::uu:::ur:::::r            f:::::::f             .::::.      i::::::im::::m   m::::m   m::::m",
"    uuuuuuuu  uuuurrrrrrr            fffffffff             ......      iiiiiiiimmmmmm   mmmmmm   mmmmmm"
}

for _, v in ipairs(msg) do
	MsgC(rp.col.White, v .. '\n')
end


hook.Run("rpBase.Loaded")