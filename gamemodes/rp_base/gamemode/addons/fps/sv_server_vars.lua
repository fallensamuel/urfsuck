local vars = {
	["net_queued_packet_thread"]    = 1,
	["net_maxpacketdrop"]           = 4000,
	["net_compresspackets"]         = 1,
	["net_compresspackets_minsize"] = 128,
	["net_splitrate"]               = 4,

	["ai_frametime_limit"] = 0.015,

	["filesystem_max_stdio_read"] = 64,
	["filesystem_buffer_size"]    = 32768,
	["filesystem_unbuffered_io"]  = 0,

	["sv_forcepreload"]          = 1,
	["sv_hibernate_drop_bots"]   = 0,
	["sv_alternateticks"]        = 1,
	["sv_hibernate_when_empty"]  = 0,
	["sv_hibernate_think"]       = 1,
	["sv_parallel_sendsnapshot"] = 1,
	
	["mem_max_heapsize_dedicated"] = 2048,
	["mem_max_heapsize"] = 2048,
	["datacachesize"] = 512,
	["mem_min_heapsize"] = 512,
};

hook.Add( "InitPostEntity", function()
	for k, v in pairs( vars ) do
		RunConsoleCommand( k, v );
	end
end );