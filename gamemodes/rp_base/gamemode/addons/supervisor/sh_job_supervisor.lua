rp.cfg.Supervisors = rp.cfg.Supervisors or {
	Actions = {}, 
	List = {}, 
	CanUse = {}
}

/* ---- ENUMs: ------------------------------ */
SUPERVISOR_CMD_DISABLE  = 0;
SUPERVISOR_CMD_ENABLE   = 1;
SUPERVISOR_CMD_SPECTATE = 2;
SUPERVISOR_CMD_ACTION   = 3;


/* ---- nw: --------------------------------- */
nw.Register( "nw.rp.SupervisorStatus" )
:Write( function( data )
    net.WriteUInt( data[1], 3 );
    net.WriteBool( data[2] );
end )
:Read( function()
    rp.SupervisorStatus = rp.SupervisorStatus or {};

    local id     = net.ReadUInt(3);
    local status = net.ReadBool();

    rp.SupervisorStatus[id] = status;
end )
:SetGlobal();