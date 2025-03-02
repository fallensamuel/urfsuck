-- "gamemodes\\darkrp\\gamemode\\addons\\quest\\sh_addmethod.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
function AddMethod(tab, varname, default, name)
	if ( !tab ) then debug.Trace() end

	if !name then
		name = varname
	end

	tab[ varname ] = default

	tab[ "Get" .. name ] = function( self ) return self[ varname ] end
	tab[ "Set" .. name ] = function( self, v ) self[ varname ] = v return self end
end