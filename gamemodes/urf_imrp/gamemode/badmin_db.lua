ba.data = ba.data or {}

ba.data.IP 		= '37.230.228.132'
ba.data.User 	= 'hl2rp_alyx'
ba.data.Pass 	= '3uc94rEI00kOMgdZ'
ba.data.Table 	= 'hl2rp_alyx'
ba.data.Port 	= 3306
ba.data._uid 	= util.CRC(GetConVarString('ip') .. ':' .. GetConVarString('hostport'))

ba.data._db = ba.data._db or ptmysql.newdb(ba.data.IP, ba.data.User, ba.data.Pass, ba.data.Table, ba.data.Port)
