local blockTypes = {"Physgun1", "Spawning1", "Toolgun1"}
local checkModel = function(model) return model ~= nil and (CLIENT or util.IsValidModel(model)) end
local requiredTeamItems = {"color", "model", "description"}

local validShipment = {
	model = checkModel,
	"entity", "price", "amount", "seperate", "allowed"
}

local validVehicle = {
	model = checkModel,
	"name", "price"
}

local validEntity = {
	"ent",
	model = checkModel,
"price", "max", "cmd", "name"
}

local function checkValid(tbl, requiredItems)
	for k, v in pairs(requiredItems) do
		local isFunction = type(v) == "function"
		if (isFunction and not v(tbl[k])) or (not isFunction and tbl[v] == nil) then return isFunction and k or v end
	end
end


if CLIENT then
	rp.TeamsToHandle = rp.TeamsToHandle or {}
	
	-- --> teamDescriptionHandler:
		local function teamDescHandler()
			if not rp.cfg.EnableUIRedesign then
				local CustomTeam
				
				for t = 1, table.Count(rp.TeamsToHandle) do
					CustomTeam = rp.teams[t]
					
					if CustomTeam then 
						if CustomTeam.unlockPrice then
							CustomTeam.description = translates.Get("Стоимость разблокировки") .. ": "..rp.FormatMoney(CustomTeam.unlockPrice)..'\n\n'..CustomTeam.description
						end
						CustomTeam.description = CustomTeam.description.."\n\n" .. translates.Get("Зарплата") .. ": "..rp.FormatMoney(CustomTeam.salary).."\n"
						if CustomTeam.armor and CustomTeam.armor > 0 then
							CustomTeam.description = CustomTeam.description..translates.Get("Броня")..": "..CustomTeam.armor.."\n"
						end
						local AddToDesc
						if #CustomTeam.weapons > 0 then
							for k,v in ipairs(CustomTeam.weapons) do
								AddToDesc = (AddToDesc or (translates.Get("Оружие") .. ":")).." "..(weapons.GetStored(v) and weapons.GetStored(v).PrintName or v)
								AddToDesc = next(CustomTeam.weapons, k) and (AddToDesc..",") or (AddToDesc..".\n")
							end
						end
						CustomTeam.description = CustomTeam.description..(AddToDesc or '')
					end
				end
			end
		end

		hook('OnReloaded', 'TeamsInitialize.Reload', teamDescHandler)
		hook('Initialize', 'TeamsInitialize.LoadDescInfo', teamDescHandler)
	--]]
end

rp.teams = {}
rp.teamscmd = {}
rp.AutoGiveWhitelist = {}

function rp.addTeam(Name, CustomTeam)
	CustomTeam.name = Name
	local corrupt = checkValid(CustomTeam, requiredTeamItems)

	if corrupt then
		ErrorNoHalt("Corrupt team \"" .. (CustomTeam.name or "") .. "\": element " .. corrupt .. " is incorrect.\n")
	end

	table.insert(rp.teams, CustomTeam)
	team.SetUp(#rp.teams, Name, CustomTeam.color)
	local t = #rp.teams
	if CustomTeam.command then
		if rp.teamscmd[CustomTeam.command] then
			ErrorNoHalt("Corrupt team \"" .. (CustomTeam.name or "") .. "\": этот command уже используется в профессии " .. rp.teams[ rp.teamscmd[CustomTeam.command] ].name .. "!\n")
		end
		
		rp.teamscmd[CustomTeam.command] = t
	end
	CustomTeam.loyalty = CustomTeam.loyalty or 1
	CustomTeam.team = t
	CustomTeam.unlockTime = CustomTeam.unlockTime || 0
	CustomTeam.salary = CustomTeam.salary || 0
	CustomTeam.max = CustomTeam.max || 0
	CustomTeam.admin = CustomTeam.admin || 0
	CustomTeam.vote = CustomTeam.vote || false
	CustomTeam.hasLicense = CustomTeam.hasLicense || false
	CustomTeam.max = CustomTeam.max || 0
	CustomTeam.weapons = CustomTeam.weapons || {}
	CustomTeam.armor = CustomTeam.armor || 0
	CustomTeam.spawn_points = CustomTeam.spawn_points || rp.cfg.DefaultSpawnPoints
	CustomTeam.build = CustomTeam.build == nil && true || false
	CustomTeam.canOrgCapture = (CustomTeam.canOrgCapture == nil) and true or CustomTeam.canOrgCapture

	if CustomTeam.minUnlockTime then
		CustomTeam.minUnlockTimeTag = CustomTeam.minUnlockTimeTag or ('j:' .. (CustomTeam.command or CustomTeam.team))
		rp.RegisterCustomPlayTime(CustomTeam.minUnlockTimeTag)
	end
	
	if CustomTeam.whitelisted and not CustomTeam.customCheck then
		CustomTeam.customCheck = function(ply)
			return CustomTeam.command and rp.PlayerHasAccessToJob(CustomTeam.command, ply)
		end
	end

	if CustomTeam.likeReactions and not CustomTeam.customCheck then
		CustomTeam.customCheck = function(ply)
			return ply:GetLikeReacts() >= CustomTeam.likeReactions
		end
	end

	if CustomTeam.autoGiveByAddSponsor then
		rp.AutoGiveWhitelist[CustomTeam.autoGiveByAddSponsor] = rp.AutoGiveWhitelist[CustomTeam.autoGiveByAddSponsor] or {}
		table.insert(rp.AutoGiveWhitelist[CustomTeam.autoGiveByAddSponsor], CustomTeam.command)
	end
	
	if rp.cfg.JobTimeAndPriceMultiplier and rp.cfg.JobTimeAndPriceMultiplier > 0 then
		CustomTeam.unlockTime = math.ceil(CustomTeam.unlockTime * rp.cfg.JobTimeAndPriceMultiplier)
		
		if CustomTeam.unlockPrice then
			CustomTeam.unlockPrice = math.ceil(CustomTeam.unlockPrice * rp.cfg.JobTimeAndPriceMultiplier)
		end
	end

	if CustomTeam.vip then
		CustomTeam.unlockPrice = nil
	end
	
	--CustomTeam.unlockTime = 0
	--CustomTeam.unlockPrice = nil
	
    CustomTeam.model      = type(CustomTeam.model) == 'string' && {CustomTeam.model} or CustomTeam.model or {};
    CustomTeam.appearance = CustomTeam.appearance or {};

    local DefinedMdls = {};

    for k, v in pairs( CustomTeam.appearance ) do
        if type(v.mdl) == "table" then
            for _, mdlPath in pairs( v.mdl ) do
                local AppearanceData = table.Copy(v);
                AppearanceData.mdl = mdlPath;

                table.insert( CustomTeam.appearance, AppearanceData );
                DefinedMdls[mdlPath] = true;

                util.PrecacheModel( mdlPath );
            end
            CustomTeam.appearance[k] = nil;
        else
            table.insert( CustomTeam.model, v.mdl );
            DefinedMdls[v.mdl] = true;

            util.PrecacheModel( v.mdl );
        end
    end

    for k, v in pairs( CustomTeam.model ) do
        if not DefinedMdls[v] then
            table.insert( CustomTeam.appearance, { mdl = v } );
            util.PrecacheModel( v );
        end
    end

	for k, v in pairs(CustomTeam.spawns or {}) do
		rp.cfg.TeamSpawns[k] = rp.cfg.TeamSpawns[k] or {}
		rp.cfg.TeamSpawns[k][t] = v
	end	

	if CLIENT then
		--[[
		local f = function()
			if CustomTeam.unlockPrice then
				CustomTeam.description = "Стоимость разблокировки: "..rp.FormatMoney(CustomTeam.unlockPrice)..'\n\n'..CustomTeam.description
			end
			CustomTeam.description = CustomTeam.description.."\n\nЗарплата: "..rp.FormatMoney(CustomTeam.salary).."\n"
			if CustomTeam.armor > 0 then
				CustomTeam.description = CustomTeam.description.."Броня: "..CustomTeam.armor.."\n"
			end
			local AddToDesc
			if #CustomTeam.weapons > 0 then
				for k,v in ipairs(CustomTeam.weapons) do
					AddToDesc = (AddToDesc or "Оружие:").." "..(weapons.GetStored(v) and weapons.GetStored(v).PrintName or v)
					AddToDesc = next(CustomTeam.weapons, k) and (AddToDesc..",") or (AddToDesc..".\n")
				end
			end
			CustomTeam.description = CustomTeam.description..(AddToDesc or '')
		end
		hook('OnReloaded', 'Initialize.Reload'..t, f)
		hook('Initialize', 'Initialize.LoadDescInfo'..t, f)
		]]
		
		rp.TeamsToHandle[t] = true
	end

	if CustomTeam.faction then
		rp.AddFactionTeam(t, CustomTeam.faction)
	end

	if CustomTeam.whitelisted and CustomTeam.WhiteListDonatePrice then -- Авто создания донат итемов для вайтлистед профессий
		rp.shop.Add(Name, "dw_"..CustomTeam.command)
		:SetCat("Вайтлист")
		:SetPrice(CustomTeam.WhiteListDonatePrice)
		:SetDesc(CustomTeam.description)
		:SetWhitelistedTeam(t)
		:SetIcon(CustomTeam.model[1])
		:SetCanBuy(function(self, ply)
			if not CustomTeam.WhiteListParentOrg then print("Y1") return true end

			if ply:GetOrg() ~= CustomTeam.WhiteListParentOrg then print("N1") return false end

			if not CustomTeam.WhiteListNeededRank then print("Y2") return true end

			if not ply:GetOrgData().Rank or ply:GetOrgData().Rank ~= CustomTeam.WhiteListNeededRank then print("N2") return false end

			print("Y3")
			return true
		end)
	end

	return t
end

rp.teamDoors = {}

function rp.AddDoorGroup(name, t)
	rp.teamDoors[name] = rp.teamDoors[name] or {}

	for k, v in ipairs(t) do
		rp.teamDoors[name][v] = true
	end
end

rp.shipments = {}

function rp.AddShipment(name, model, entity, price, Amount_of_guns_in_one_shipment, Sold_seperately, price_seperately, noshipment, classes, shipmodel, CustomCheck)
	local tableSyntaxUsed = type(model) == "table"
	local AllowedClasses = classes or {}

	if not classes then
		for k, v in ipairs(team.GetAllTeams()) do
			table.insert(AllowedClasses, k)
		end
	end

	local price = tonumber(price)
	local shipmentmodel = shipmodel or "models/Items/item_item_crate.mdl"

	local customShipment = tableSyntaxUsed and model or {
		model = model,
		entity = entity,
		price = price,
		amount = Amount_of_guns_in_one_shipment,
		seperate = Sold_seperately,
		pricesep = price_seperately,
		noship = noshipment,
		allowed = table.Copy(AllowedClasses or {}),
		shipmodel = shipmentmodel,
		customCheck = CustomCheck,
		weight = 5
	}

	customShipment.seperate = customShipment.separate or customShipment.seperate
	customShipment.name = name

	for k, v in pairs(AllowedClasses or {}) do
		customShipment.allowed[v] = true
	end

	local corrupt = checkValid(customShipment, validShipment)

	if corrupt then
		ErrorNoHalt("Corrupt shipment \"" .. (name or "") .. "\": element " .. corrupt .. " is corrupt.\n")
	end

	if SERVER then
		rp.nodamage[entity] = true
	end

	rp.inv.Wl[entity] = name
	table.insert(rp.shipments, customShipment)
	util.PrecacheModel(customShipment.model)
end

--[[---------------------------------------------------------------------------
Decides whether a custom job or shipmet or whatever can be used in a certain map
---------------------------------------------------------------------------]]
function GM:CustomObjFitsMap(obj)
	if not obj or not obj.maps then return true end
	local map = string.lower(game.GetMap())

	for k, v in pairs(obj.maps) do
		if string.lower(v) == map then return true end
	end

	return false
end

rp.entities = {}

function rp.AddEntity(name, entity, model, price, max, command, classes, pocket)
	local tableSyntaxUsed = type(entity) == "table"

	local tblEnt = tableSyntaxUsed and entity or {
		ent = entity,
		model = model,
		price = price,
		max = max,
		cmd = command,
		allowed = classes,
		pocket = pocket
	}

	tblEnt.name = name
	tblEnt.allowed = tblEnt.allowed or {}

	if type(tblEnt.allowed) == "number" then
		tblEnt.allowed = {tblEnt.allowed}
	end

	if #tblEnt.allowed == 0 then
		for k, v in ipairs(team.GetAllTeams()) do
			table.insert(tblEnt.allowed, k)
		end
	end

	local corrupt = checkValid(tblEnt, validEntity)

	if corrupt then
		ErrorNoHalt("Corrupt Entity \"" .. (name or "") .. "\": element " .. corrupt .. " is corrupt.\n")
	end

	if SERVER then
		rp.nodamage[entity] = true
	end

	local newTable = {}

	for k, v in ipairs(tblEnt.allowed) do
		newTable[v] = true
	end

	tblEnt.allowed = newTable

	table.insert(rp.entities, tblEnt)

	timer.Simple(0, function()
		GAMEMODE:AddEntityCommands(tblEnt)
	end)

	if (tblEnt.pocket ~= false) then
		rp.inv.Wl[tblEnt.ent] = name
	end
end

rp.CopItems = {}

function rp.AddCopItem(name, price, model, weapon, callback)
	if istable(price) then
		rp.CopItems[name] = {
			Name = name,
			Price = price.Price,
			Model = price.Model,
			Weapon = price.Weapon,
			Callback = price.Callback
		}
	else
		rp.CopItems[name] = {
			Name = name,
			Price = price,
			Model = model,
			Weapon = weapon,
			Callback = callback
		}
	end
end

rp.Drugs = {}

function rp.AddDrug(name, ent, model, cost, class)
	local tab = {
		Name = name,
		Class = ent,
		Model = model,
		BuyPrice = math.ceil(cost * .50)
	}

	rp.Drugs[#rp.Drugs + 1] = tab
	rp.Drugs[ent] = tab
	rp.AddShipment(name, model, ent, math.ceil(cost * 10), 10, true, math.ceil(cost * 1.1), true, {class})
end

function rp.AddWeapon(name, model, entity, price, Amount_of_guns_in_one_shipment, Sold_seperately, price_seperately, noshipment, classes)
	rp.AddShipment(name, model, entity, price, Amount_of_guns_in_one_shipment, Sold_seperately, price_seperately, noshipment, classes)
	rp.AddCopItem(name, price_seperately, model, entity)
end

rp.agendas = {}

function rp.AddAgenda(title, manager, listeners)
	for k, v in ipairs(listeners) do
		rp.agendas[v] = {
			title = title,
			manager = manager
		}
	end

	rp.agendas[manager] = {
		title = title,
		manager = manager
	}

	nw.Register('Agenda;' .. manager, {
		Read = net.ReadString,
		Write = net.WriteString,
		GlobalVar = true
	})
end

rp.groupChats = {}

function rp.addGroupChat(...)
	local classes = {...}

	table.foreach(classes, function(k, class)
		rp.groupChats[class] = {}

		table.foreach(classes, function(k, class2)
			rp.groupChats[class][class2] = true
		end)
	end)
end

rp.ammoTypes = {}

function rp.AddAmmoType(ammoType, name, model, price, amountGiven, customCheck)
	table.insert(rp.ammoTypes, {
		ammoType = ammoType,
		name = name,
		model = model,
		price = price,
		amountGiven = amountGiven,
		customCheck = customCheck
	})
end