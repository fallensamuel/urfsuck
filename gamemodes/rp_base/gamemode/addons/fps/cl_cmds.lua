cvar.Register'render_multicore_new':SetDefault(true):AddMetadata('State', 'RPMenu'):AddMetadata('Menu', 'Многоядерный рендеринг (повышает FPS, но иногда вызывает краши)')

local cvar_Get = cvar.GetValue
local GetConVar = GetConVar
local i = 0
local new = false

local cmds =
{
	['mat_queue_mode'] = 2,
	['cl_threaded_bone_setup'] = 1,
	['cl_threaded_client_leaf_system'] = 1,
	['r_threaded_client_shadow_manager'] = 1,
	['r_threaded_particles'] = 1,
	['r_threaded_renderables'] = 0,
	['r_queued_ropes'] = 1,
	['studio_queue_mode'] = 1,
	['gmod_mcore_test'] = 1,
}

local function addCmd(cmd,num,i)
	timer.Simple(i,function()
		//print(cmd,'set on',num)
		RunConsoleCommand(cmd,num)
	end)
end

local function change(value)
	for v,k in pairs(cmds) do
		new = value && k || 0
		if what then tab[GetConVar(v):GetName()] = GetConVar(v):GetInt() end
		if GetConVar(v):GetInt() == new then print(v,'is already',k) continue end
		i = i + 0.1
		addCmd(v,new,i)
	end
end

hook.Add('cvar.render_multicore_new', function(old, value)
	//print('CVAR CHANGED', old, value)
	change(value)

end)

hook.Add("InitPostEntity", function()
	timer.Simple(20, function()
		change(cvar_Get('render_multicore_new'))
	end)
	--[[
	timer.Create('rp.FixMap', 0.1, 0, function()
		RunConsoleCommand('overview_mode', 0)
	end)
	]]
end)