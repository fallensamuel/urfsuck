rp.abilities = {}
rp.abilities.player_cooldowns = {}
rp.abilities.list = {}
rp.abilities.listByName = {}

function rp.abilities.GetByName(name)
	return rp.abilities.listByName[name]
end

function rp.abilities.Get(id)
	return rp.abilities.list[id]
end

nw.Register'AbilitiesCooldown':Write(function(data)
	net.WriteUInt(table.Count(data), 6)
	for k, v in pairs(data) do
		net.WriteInt(k, 6)
		net.WriteInt(v, 32)
	end
end):Read(function()
	local tbl = {}
	
	local count = net.ReadUInt(6)
	for i = 1, count do
		local k , v = net.ReadInt(6), net.ReadInt(32)
		tbl[k] = v
	end


	return tbl
end):SetLocalPlayer():SetHook('AbilitiesCooldownReceived')

ability_mt = {}
ability_mt.__index = ability_mt

function ability_mt:GetName()
	return self.Name
end

function ability_mt:GetUID()
	return self.UID
end

function ability_mt:GetID()
	return self.ID
end

function ability_mt:SetVIP(vip)
	self.VIP = vip
	return self
end

function ability_mt:IsVIP()
	return self.VIP
end

function ability_mt:SetCantUseReason(f)
	self.CantUseReasonFunc = f
	return self
end

function ability_mt:CantUseReason(ply)
	return self.CantUseReasonFunc(ply)
end

function ability_mt:SetCooldown(time)
	self.Cooldown = time
	return self
end

function ability_mt:GetCooldown(ply)
	return os.time() + self.Cooldown
end

function ability_mt:SetSound(s)
	self.Sound = s
	return self
end

function ability_mt:PlaySound(p)
	if self.Sound then
		p:EmitSound(self.Sound)
	end
end

function ability_mt:OnUse(func)
	self.Use = func
	return self
end

function ability_mt:Use()
	return
end

function ability_mt:SetDescription(desc)
	self.Desc = desc
	return self
end

function ability_mt:GetDescription()
	return self.Desc
end

function ability_mt:SetCanUse(func)
	self.CanUse = func
	return self
end

function ability_mt:SetPlayTime(time)
	self.PlayTime = time
	return self
end

function ability_mt:GetPlayTime(ply)
	return self.PlayTime
end

function ability_mt:SetModel(mdl)
	self.Model = mdl
	return self
end

function ability_mt:GetModel(mdl)
	return self.Model
end

function ability_mt:SetIcon(icon)
	self.Icon = Material(icon, "smooth", "noclamp")
	return self
end

function ability_mt:GetIcon()
	return self.Icon
end

function ability_mt:CanUse(self, ply)
	return true
end

function ability_mt:SetColor(col, alpha)
	self.Color = col
	self.AlphaBg = alpha
	return self
end

function ability_mt:SetContentColor(col)
	self.ContentColor = col
	return self
end

function ability_mt:GetColor()
	return self.Color
end
function ability_mt:GetAlphaBg()
	return self.AlphaBg
end

function ability_mt:GetContentColor()
	return self.ContentColor
end

function ability_mt:GetRemainingCooldown(ply)
	return (ply:GetNetVar('AbilitiesCooldown') or {})[self:GetID()] - os.time()
end

function ability_mt:InCooldown(ply)
	return ((ply:GetNetVar('AbilitiesCooldown') or {})[self:GetID()] or 0) > os.time()
end

function ability_mt:UpdateCooldown(ply)
	rp._Stats:Query("REPLACE INTO player_cooldowns(SteamID, Name, Cooldown) VALUES("..ply:SteamID64()..", '"..self:GetUID().."', "..self:GetCooldown(ply)..")")
	local t = ply:GetNetVar('AbilitiesCooldown') or {}
	t[self:GetID()] = self:GetCooldown(ply)
	ply:SetNetVar('AbilitiesCooldown', t)
end

function ability_mt:SetSteamNameRequire()
	self.NickCustomCheck = function(ply)
		local name = ply:SteamName():lower()
		return tobool(name:find("urf.im", 1, true))
	end
	return self
end

local count = 1
function rp.abilities.Add(UID, printName)
	local t = {
		UID = UID,
		Name = printName,
		ID = count,
		PlayTime = 0,
		Color = Color(255, 0, 0)
	}

	setmetatable(t, ability_mt)

	rp.abilities.list[t.ID] = t
	rp.abilities.listByName[t.UID] = t

	count = count + 1

	return t
end
