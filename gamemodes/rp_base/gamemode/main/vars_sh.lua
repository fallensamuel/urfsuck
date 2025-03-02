-- "gamemodes\\rp_base\\gamemode\\main\\vars_sh.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
-- Global vars
nw.Register'TheLaws':Write(net.WriteString):Read(net.ReadString):SetGlobal()
nw.Register'lockdown':Write(net.WriteUInt, 4):Read(net.ReadUInt, 4):SetGlobal()
nw.Register'mayorGrace':Write(net.WriteUInt, 32):Read(net.ReadUInt, 32):SetGlobal()
-- Player Vars
nw.Register'Carma':Write(net.WriteUInt, 32):Read(net.ReadUInt, 32):SetLocalPlayer()
nw.Register'HasGunlicense':Write(net.WriteBool):Read(net.ReadBool):SetPlayer()
nw.Register'IsAFK':Write(net.WriteBool):Read(net.ReadBool):SetPlayer()
nw.Register'Name':Write(net.WriteString):Read(net.ReadString):SetPlayer()
nw.Register'Money':Write(net.WriteUInt, 32):Read(net.ReadUInt, 32):SetLocalPlayer()
nw.Register'Karma':Write(net.WriteUInt, 7):Read(net.ReadUInt, 7):SetLocalPlayer()
nw.Register'job':Write(net.WriteString):Read(net.ReadString):SetPlayer()
nw.Register'Hat':Write(net.WriteUInt, 8):Read(net.ReadUInt, 8):SetPlayer()
nw.Register'Toolgun':Write(net.WriteUInt, 8):Read(net.ReadUInt, 8):SetLocalPlayer()

nw.Register'LikeReacts':Write(net.WriteUInt, 14):Read(net.ReadUInt, 14):SetPlayer()

nw.Register'UsergroupExpire':Write(net.WriteUInt, 32):Read(net.ReadUInt, 32):SetLocalPlayer()

nw.Register'NextMonsterEat':Write(net.WriteUInt, 32):Read(net.ReadUInt, 32):SetLocalPlayer()

nw.Register"Whitelist":Write(function(tbl)
	net.WriteUInt(table.Count(tbl), 16)

	for k, v in pairs(tbl) do
		net.WriteString(k)
	end
end):Read(function()
	local tbl = {}

	for i = 1, net.ReadUInt(16) do
		tbl[net.ReadString()] = true
	end

	return tbl
end):SetLocalPlayer()

nw.Register'HatData':Write(function(v)
	net.WriteUInt(#v, 6)

	for k, v in ipairs(v) do
		net.WriteString(v)
	end -- TODO: FIX
end):Read(function()
	local tbl = {}

	for i = 1, net.ReadUInt(6) do
		tbl[i] = net.ReadString()
	end

	return tbl
end):SetLocalPlayer()

nw.Register'ToolgunData':Write(function(v)
	net.WriteUInt(#v, 6)

	for k, v in ipairs(v) do
		net.WriteString(v)
	end -- TODO: FIX
end):Read(function()
	local tbl = {}

	for i = 1, net.ReadUInt(6) do
		tbl[i] = net.ReadString()
	end

	return tbl
end):SetLocalPlayer()

nw.Register'CustomPhysgun'
	:Write(net.WriteString)
	:Read(net.ReadString)
	:SetPlayer()

nw.Register'GlobalRank'
	:Write(net.WriteString)
	:Read(net.ReadString)
	:SetPlayer()

nw.Register'GlobalRankData'
	:Write(net.WriteString)
	:Read(net.ReadString)
	:SetLocalPlayer()
	
nw.Register'GlobalRankUntil'
	:Write(net.WriteFloat)
	:Read(net.ReadFloat)
	:SetLocalPlayer()
	
nw.Register'Employee':Write(net.WritePlayer):Read(net.ReadPlayer):SetLocalPlayer()
nw.Register'Employer':Write(net.WritePlayer):Read(net.ReadPlayer):SetPlayer()
nw.Register'DisguiseTeam':Write(net.WriteUInt, 9):Read(net.ReadUInt, 9):SetPlayer()
nw.Register'DisguiseTime':Write(net.WriteUInt, 32):Read(net.ReadUInt, 32):SetLocalPlayer()
nw.Register'ShareProps':Write(net.WriteTable):Read(net.ReadTable):SetLocalPlayer()
nw.Register'PropIsOwned':Write(net.WriteBool):Read(net.ReadBool):Filter(function(self) return self:CPPIGetOwner() end):SetNoSync()
nw.Register'Credits':Write(net.WriteUInt, 32):Read(net.ReadUInt, 32):SetLocalPlayer()

nw.Register'Timemultipliers':Write(function(t)
	net.WriteUInt(table.Count(t), 8)

	for k, v in pairs(t) do
		net.WriteString(k)
	end
	
end):Read(function()
	local tbl = {}

	for i = 1, net.ReadUInt(8) do
		tbl[net.ReadString()] = true
	end

	return tbl
	
end):SetLocalPlayer()

nw.Register'Upgrades':Write(function(v)
	net.WriteUInt(#v, 8)

	for k, upgid in ipairs(v) do
		net.WriteUInt(upgid, 8)
	end
end):Read(function()
	local ret = {}

	for i = 1, net.ReadUInt(8) do
		local obj = rp.shop.Get(net.ReadUInt(8))
		ret[obj:GetUID()] = true
	end

	return ret
end):SetLocalPlayer()

nw.Register'Outfit':Write(net.WriteUInt, 6):Read(net.ReadUInt, 6):SetPlayer()

nw.Register'JobUnlocks':Write(net.WriteTable):Read(net.ReadTable):SetLocalPlayer()