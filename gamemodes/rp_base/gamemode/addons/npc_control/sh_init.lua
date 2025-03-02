
rp.npc = rp.npc or {
	Templates = {},
	Entities = {},
}

rp.npc.RegisterClass = function(npc_data)
	rp.npc.Templates[npc_data.class] = npc_data
end
