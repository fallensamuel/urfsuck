rp.ArmoryHeists = rp.ArmoryHeists or { List = {} };

rp.ArmoryHeists.GetHeistCfg = function( id )
    return rp.cfg.ArmoryHeists and rp.cfg.ArmoryHeists.List[game.GetMap()][id];
end

hook.Add("InitPostEntity", "LoadHeists", function()
	for id, HeistData in pairs( rp.cfg.ArmoryHeists and rp.cfg.ArmoryHeists.List[game.GetMap()] or {} ) do
	    rp.ArmoryHeists.List[id] = rp.ArmoryHeists.List[id] or {
	        ID           = id,
	        IsInProgress = false,
	        Timestamp    = 0,
	    };

	    if SERVER then
	        rp.ArmoryHeists.List[id].Defenders = rp.ArmoryHeists.List[id].Defenders or {};
	    end
	end
end)