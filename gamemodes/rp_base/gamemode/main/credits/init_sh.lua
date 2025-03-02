-- "gamemodes\\rp_base\\gamemode\\main\\credits\\init_sh.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
rp.shop = rp.shop or {
	Stored = {},
	Weapons = {},
	EmoteActs = {},
	EmoteActsMap = {},
	Emojis = {},
	EmojisMap = {},
	Mapping = {},
	WeaponsMap = {},
	ModelsMap = {}, 
	DonatesHistory = {}
}

local upgrade_mt = {}
upgrade_mt.__index = upgrade_mt
local count = 1

function rp.shop.CalculateAmount(amount)
	return (amount * rp.cfg.CreditsValue)
end

function rp.shop.Add(name, uid)
	local t = {
		Name = name,
		UID = uid:lower(),
		ID = count,
		Stackable = true
	}

	setmetatable(t, upgrade_mt)
	rp.shop.Stored[t.ID] = t
	rp.shop.Mapping[t.UID] = t
	count = count + 1

	return t
end

function rp.shop.Get(id)
	return rp.shop.Stored[id]
end

function rp.shop.GetByUID(uid)
	return rp.shop.Mapping[uid]
end

function rp.shop.GetTable()
	return rp.shop.Stored
end

upgrade_mt.Discount = 0

-- Set

function upgrade_mt:SetStackable(stackable)
	self.Stackable = stackable

	return self
end

function upgrade_mt:SetIgnoreDisallow(ignoredisallow)
	self.IgnoreDisallow = ignoredisallow

	return self
end

function upgrade_mt:SetCat(cat)
	self.Cat = cat

	return self
end

function upgrade_mt:SetDesc(desc)
	self.Desc = desc

	return self
end

function upgrade_mt:SetMaterial(mat)
	self.PaintMaterial = mat

	return self
end

function upgrade_mt:SetSkin(id)
	self.Skin = id

	return self
end

function upgrade_mt:SetIcon(icon)
	self.Icon = icon

	return self
end

function upgrade_mt:SetHat(hat)
	self.Hat = hat

	return self
end

function upgrade_mt:SetPrice(price)
	self.Price = price

	return self
end

function upgrade_mt:SetAltPrice(price)
	self.AltPrice = price;

	return self
end

rp.shop.altrotate = rp.shop.altrotate or {};

function upgrade_mt:CanAltPrice(price)
	rp.shop.altrotate[self.UID] = price;

	return self
end

function upgrade_mt:SetGetPrice(func)
	self._GetPrice = func

	return self
end

function upgrade_mt:SetDiscount(value)
	value = math.max(rp.GetDiscount(), value or 0, self.Discount or 0)
	
	local free = string.find(self.Name, " (-", 1, true)
	if free then
		self.Name = string.sub(self.Name, 1, free - 1)
	end
	
	self.Discount = value

	self.Name = self.Name .. " (-" .. (value * 100) .. "%)"
	
	return self
end

function upgrade_mt:SetCanBuy(func)
	self._CanBuy = func

	return self
end

function upgrade_mt:SetOnBuy(func) 
    self._OnBuy = self._OnBuy or {}
    self._OnBuy[#self._OnBuy + 1] = func
    
    return self
end

function upgrade_mt:SetWeapon(wep)
	rp.shop.Weapons[self:GetUID()] = wep
	rp.shop.WeaponsMap[wep] = self:GetUID()
	self.Weapon = wep
	self:SetDesc(translates.Get("Вам будет даваться %s при возрождении.", self:GetName()))
	self:SetStackable(false)

	self:SetOnBuy(function(self, pl)
		local weps = pl:GetVar('PermaWeapons')
		weps[#weps + 1] = wep
		pl:SetVar('PermaWeapons', weps)
	end)

	return self
end -- We don't need 20 PlayerLoadout hooks

function upgrade_mt:SetEmojis(tbl_emojis)
	rp.shop.Emojis[self:GetUID()] = tbl_emojis
	
	self.Emojis = tbl_emojis

	local emojis = {};
	for k, v in pairs(tbl_emojis) do
		rp.shop.EmojisMap[v] = self:GetUID()
		emojis[k] = "  - " .. v
	end
	emojis = table.concat( emojis, "\n" )

	self:SetDesc(translates.Get("Данный набор включает в себя следующие emoji:") .. "\n" .. emojis)
	self:SetStackable(false)
	self:SetNetworked(true)
	
	timer.Simple(10, function()
		if CHATBOX and CHATBOX.RegisterEmotesViaAPI then
			CHATBOX:RegisterEmotesViaAPI("https://urf.im/content/emotes/" .. self:GetUID() .. "/", 48, 48, function(ply)
				return ply:HasUpgrade(self:GetUID()) or false
			end)
		end
	end)
	
	return self
end

function upgrade_mt:SetEmoteActs( tbl_acts )
	rp.shop.EmoteActs[self:GetUID()] = tbl_acts
	
	self.EmoteActs = tbl_acts

	local acts = {};
	for k, v in pairs(tbl_acts) do
		local rawAction = EmoteActions:GetRawAction(v);
		
		rp.shop.EmoteActsMap[v] = self:GetUID()
		
		if rawAction and rawAction.Name then
			acts[k] = "  - " .. rawAction.Name;
			rawAction.IsHidden = true;
		end
	end
	acts = table.concat( acts, "\n" )

	self:SetDesc( translates.Get("Данный набор включает в себя следующие анимации:") .. "\n" .. acts )
	self:SetStackable( false )
	self:SetNetworked( true )

	return self
end

function upgrade_mt:SetTeam(team)
	local CustomTeam = rp.teams[team]
	if not CustomTeam then return self end
	
	self.Team = team
	
	timer.Simple(0, function()
		local AddToDesc
		if CustomTeam.weapons && #CustomTeam.weapons > 0 then
			for k,v in ipairs(CustomTeam.weapons) do
				--print(v, weapons.GetStored(v) and weapons.GetStored(v).PrintName or 'not found!')
				AddToDesc = (AddToDesc or "\n" .. translates.Get("Оружие") .. ":").." "..(weapons.GetStored(v) and weapons.GetStored(v).PrintName or v)
				AddToDesc = next(CustomTeam.weapons, k) and (AddToDesc..",") or (AddToDesc..".\n")
			end
		end
		local description = ''
		if CustomTeam.armor && CustomTeam.armor > 0 then
			description = translates.Get("Броня") .. ": "..CustomTeam.armor.."\n"
		end
		if CustomTeam.health && CustomTeam.health > 0 then
			description = translates.Get("Здоровье") .. ": "..CustomTeam.health.."\n"
		end
		AddToDesc = AddToDesc or ''

		self:SetDesc(self:GetDesc()..AddToDesc..description)
		self:SetIcon(CustomTeam.model[1])

		self:SetStackable(false)
		self:SetNetworked(true)
	end)
	
	return self
end

function upgrade_mt:SetWhitelistedTeam(team)
	local CustomTeam = rp.teams[team]
	if not CustomTeam or not CustomTeam.whitelisted then return self end

	self.WhitelistedTeam = team

	timer.Simple(0, function()
		local AddToDesc
		if CustomTeam.weapons && #CustomTeam.weapons > 0 then
			for k,v in ipairs(CustomTeam.weapons) do
				--print(v, weapons.GetStored(v) and weapons.GetStored(v).PrintName or 'not found!')
				AddToDesc = (AddToDesc or "\n" .. translates.Get("Оружие") .. ":").." "..(weapons.GetStored(v) and weapons.GetStored(v).PrintName or v)
				AddToDesc = next(CustomTeam.weapons, k) and (AddToDesc..",") or (AddToDesc..".\n")
			end
		end
		local description = ''
		if CustomTeam.armor && CustomTeam.armor > 0 then
			description = translates.Get("Броня") .. ": "..CustomTeam.armor.."\n"
		end
		if CustomTeam.health && CustomTeam.health > 0 then
			description = translates.Get("Здоровье") .. ": "..CustomTeam.health.."\n"
		end
		AddToDesc = AddToDesc or ''

		self:SetDesc(self:GetDesc()..AddToDesc..description)
		self:SetIcon(CustomTeam.model[1])

		self:SetStackable(false)
		self:SetNetworked(true)

		self:SetOnBuy(function(self, ply)
			if SERVER and CustomTeam.whitelisted then
				rp.JobsWhitelist.GiveAccess(ply, CustomTeam.command)
			end
		end)
	end)
	
	return self
end

function upgrade_mt:SetOnRefund(cback)
	self._OnRefund = cback
end

rp.shop.Spells = {}
function upgrade_mt:SetSpell(spellName)
	local spell = HpwRewrite:GetSpell(spellName)
	if !spell then error('Wrong spell name', spellName) return end
	self:SetDesc(translates.Get("Вы выучите заклинание") .. ' ' .. self:GetName() .. '.\n'..spell.Description)
	self:SetStackable(false)

	--self:SetCanBuy(function(self, pl)
		--return pl:HasUpgrade('weapon_hpwr_stick'), translates.Get("Вам необходимо купить способность к изучению магии!")
	--end)

	self:SetOnBuy(function(self, pl)
		rp.GiveSpell(pl, spellName)
	end)
	
	self:SetOnRefund(function(id)
		HpwRewrite:EraseSpellByID(id, spellName)
	end)

	self:SetIcon(HpwRewrite:GetSpellIcon(spellName):GetName())

	return self
end

function upgrade_mt:SetAttribute(attrib_id)
	self:SetOnBuy(function(self, ply) 
		local Attribute = attrib_id;
		if (!ply:GetAttribute(Attribute)) then return end

		ply:SetAttributeAmount(Attribute, AttributeSystem.getAttribute(Attribute).MaxAmount);
		ply:SaveAttributeSystem();
		ply:SyncAttributeSystem();
	end)
	
	self:SetCanBuy(function(self, ply)
		local Attribute = attrib_id;
		
		if (!ply:GetAttributeAmount(Attribute)) then return false, translates.Get('Прокачка навыка недоступна!') end
		if (ply:GetAttributeAmount(Attribute) == AttributeSystem.getAttribute(Attribute).MaxAmount) then 
			return false, translates.Get('Навык уже прокачан на 100%!') 
		end

		return true
	end)
	
	return self
end

function upgrade_mt:SetAttributePoints( num )
	self:SetDesc( translates.Get("Добавляет %s очков навыков на твой аккаунт.", num) );
	self:SetOnBuy( function(upgrade, ply)
		ply:AddAttributeSystemPoints( num );
	end );

	return self
end

function upgrade_mt:AddHook(name, func)
	local uid = self:GetUID()

	hook(name, 'rp.upgrade.' .. name, function(pl, ...)
		if pl:HasUpgrade(uid) then
			func(pl, ...)
		end
	end)

	return self
end

function upgrade_mt:SetNetworked(networked)
	self.Networked = networked

	return self
end

function upgrade_mt:SetTimeStamps(ts1, ts2)
	self.TimeStamps = {ts1, ts2}

	return self
end

function upgrade_mt:SetHidden(hidden)
	self.Hidden = hidden

	return self
end

function upgrade_mt:CustomModel(List)
	if (!self.Icon) then return self end

	self.CustomModels = List.Models or {self.Icon};
	rp.shop.ModelsMap[self.UID] = {
		List.Models or {self.Icon},
		List.Blacklist or {}, 
		List.BlacklistFactions or {},
		List.Whitelist,
		List.WhitelistFactions,
	};

	return self
end

function upgrade_mt:SetHPRegenAmount( amt )
	self.HPRegenAmount = amt;

	return self
end


-- Get
function upgrade_mt:GetName()
	return self.Name
end

function upgrade_mt:GetCat()
	return self.Cat
end

function upgrade_mt:GetDesc()
	return self.Desc
end

function upgrade_mt:GetIcon()
	return self.Icon
end

function upgrade_mt:GetSkin()
	return self.Skin
end

function upgrade_mt:GetMaterial()
	return self.PaintMaterial
end

function upgrade_mt:GetUID()
	return self.UID
end

function upgrade_mt:GetID()
	return self.ID
end

function upgrade_mt:GetDiscount()
	if CLIENT then
		local discount = math.max(rp.GetDiscount(), LocalPlayer():GetPersonalDiscount())
		
		if discount > 0 or self.Discount and self.Discount > 0 then
			discount = math.max(discount, self.Discount or 0)
			
			local free = string.find(self.Name, " (-", 1, true)
			if free then
				self.Name = string.sub(self.Name, 1, free - 1)
			end
			self.Name = self.Name .. " (-" .. (discount * 100) .. "%)"
		end
	end
	
	return self.Discount
end

function upgrade_mt:GetWeapon()
	return self.Weapon
end

function upgrade_mt:GetEmoteActs()
	return self.EmoteActs
end

function upgrade_mt:GetEmojis()
	return self.Emojis
end

function upgrade_mt:GetPrice(pl)
	local discount = math.max(self.Discount, rp.GetDiscount(), pl:GetPersonalDiscount())

	if self._GetPrice then return math.ceil(self:_GetPrice(pl) * (1 - discount)) end
	return math.ceil(self.Price * (1 - discount))
end

function upgrade_mt:GetAltPrice()
	return self.AltPrice
end

function upgrade_mt:GetHPRegenAmount()
	return self.HPRegenAmount;
end

function upgrade_mt:IsIgnoreDisallow()
	return (self.IgnoreDisallow == true)
end

function upgrade_mt:IsStackable()
	return (self.Stackable == true)
end

function upgrade_mt:IsNetworked()
	return (self.Networked == true)
end

function upgrade_mt:IsHidden()
	return (self.Hidden == true)
end

function upgrade_mt:IsInTimeLimit()
	if (self.TimeStamps) then
		local ostime = os.time()

		return (ostime >= self.TimeStamps[1] and ostime <= self.TimeStamps[2])
	end

	return true
end

function upgrade_mt:SetBuildInCategory(b)
	self.BuildInCategory = b
	return self
end

function upgrade_mt:SetCustomCanSee(f)
	self.CustomCanSee = f
	return self
end

function upgrade_mt:GetBuildInCategory()
	return self.BuildInCategory
end

function upgrade_mt:CanSee(pl)
	if (self:IsHidden() or not self:IsInTimeLimit()) then return false end
	
	if SERVER and self.CustomCanSee then 
		return self:CustomCanSee(pl) 
	end
	
	return true
end

function upgrade_mt:CanBuy(pl)
	if (not self:CanSee(pl)) then
		return false, 'How can you even see this?'
	elseif (not self:IsStackable()) and pl:HasUpgrade(self:GetUID()) then
		return false, translates.Get('Это у вас уже куплено!')
	elseif (self:GetAltPrice() and not pl:CanAffordCredits(self:GetPrice(pl)) and not (pl:GetMoney() >= self:GetAltPrice())) then
		return false, translates.Get("Вы не можете купить это. (Цена: %i Кредитов / %s)", self:GetPrice(pl), rp.FormatMoney(self:GetAltPrice()))
	elseif (not pl:CanAffordCredits(self:GetPrice(pl)) and not self.AltPrice) then
		return false, translates.Get("Вы не можете купить это. (Цена: %i Кредитов)", self:GetPrice(pl))
	elseif self._CanBuy then
		return self:_CanBuy(pl)
	end

	return true
end

function upgrade_mt:OnBuy(pl)
    if self._OnBuy then
        for k, v in ipairs(self._OnBuy) do
            v(self, pl)
        end
    end

	if self:IsNetworked() then
		local tab = pl:GetNetVar('Upgrades') or {}
		tab[#tab + 1] = self:GetID()
		pl:SetNetVar('Upgrades', tab)
	end

	if (self:GetWeapon() ~= nil) then
		pl:Give(self:GetWeapon())
	end
end

rp.shop.Attachments = rp.shop.Attachments or {}

function upgrade_mt:SetAttachment(attachment)
	local att = isstring(attachment) and {attachment} or attachment
	rp.shop.Attachments[self:GetUID()] = att
	
	if not self:GetName() then
		self.Name = CustomizableWeaponry.registeredAttachmentsSKey[att[1]].displayName
	end
	
	local desc = ''
	
	if(#att > 1) then
		for k, v in ipairs(att) do
			desc = desc .. CustomizableWeaponry.registeredAttachmentsSKey[v].displayName .. ' ' .. translates.Get("покупается навсегда") .. '.\n'
		end
	else 
		desc = self:GetName() .. ' ' .. translates.Get("покупается навсегда") .. '.'
	end
	
	self.Attachment = att
	self:SetDesc(desc)
	self:SetStackable(false)
	self:SetOnBuy(function(self, pl)
		local atts = pl:GetVar('PermaAttachments')
		table.Add(atts, att)
		pl:SetVar('PermaAttachments', atts)
		
		if not CustomizableWeaponry:hasSpecifiedAttachments(pl, att) then
			CustomizableWeaponry.giveAttachments(pl, att)
		end
	end)
	return self
end

-- Daily sale
rp.shop.sales = rp.shop.sales or {}

function rp.GetDiscountTime()
	return nw.GetGlobal('rp.shop.settings') and nw.GetGlobal('rp.shop.settings').duntil or 0
end

function rp.GetDiscount()
	return nw.GetGlobal('rp.shop.settings') and rp.GetDiscountTime() > os.time() and nw.GetGlobal('rp.shop.settings').global / 100 or 0
end

nw.Register 'rp.shop.settings'
	:Write(function(v)
		net.WriteUInt(v.global, 7)
		net.WriteUInt(v.duntil, 32)
	end)
	:Read(function()
		return { 
			global 	= net.ReadUInt(7), 
			duntil 	= net.ReadUInt(32)
		}
	end)
	:SetHook('rp.shop.daily')
	:SetGlobal()

function upgrade_mt:SetSales(...)
	self.sales = {...}
	rp.shop.sales[self.UID] = #self.sales and self.sales or nil
	return self
end

function upgrade_mt:GetSales()
	return self.sales
end

-- Player
function PLAYER:GetCredits()
	return math.max(self:GetNetVar('Credits') or 0, 0)
end

function PLAYER:CanAffordCredits(amount)
	return (self:GetCredits() >= amount)
end

if (CLIENT) then
	function PLAYER:HasUpgrade(uid)
		return (self:GetNetVar('Upgrades') or {})[uid]
	end
else
	function PLAYER:HasUpgrade(uid)
		return (self:GetVar('Upgrades', {})[uid] ~= nil)
	end
end


nw.Register'FirstJoinTime':Write(net.WriteUInt, 32):Read(net.ReadUInt, 32):SetLocalPlayer()

local newbie_discount_time = 60*60*24*2
local discount_precent = 30
--ba.AddTerm("PersonalDiscount", "Для вас доступна персональная скидка #%! Проверьте F4 — Донат")

function PLAYER:GetPersonalDiscount()
	local first = self:GetNetVar("FirstJoinTime")
	if not first then return 0 end

	return os.time() - first <= newbie_discount_time and (discount_precent/100) or 0
end

function PLAYER:GetPersonalDiscountTime()
	local first = self:GetNetVar("FirstJoinTime")
	if not first then return 0 end
	return first + newbie_discount_time - os.time()
end