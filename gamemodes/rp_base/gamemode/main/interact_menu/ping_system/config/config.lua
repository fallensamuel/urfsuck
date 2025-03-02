-- SCROLL DOWN FOR THE IMPORTANT PART OF CONFIG
PIS.Config = {}
PIS.Config.Pings = {}
PIS.Config.PingsSorted = {}
PIS.Config.PingSets = {}

local material_cache = {}
function CahceMaterial(path)
    if material_cache[path] then return material_cache[path] end

    material_cache[path] = Material(path, "smooth", "noclamp")
end


local function StrRequest(title, text, func)
	return ui and function()
		ui.StringRequest(title, text, "", function(s)
	       	func(s)
	    end)
	end
	or function()
		Derma_StringRequest(title, text, nil, function(s)
			func(s)
		end)
	end
end

PIS.Config.MaxInteractDistance = 300 -- Макс дистанция взаимодействия с игроком

-- Оставьте пустым если хотите отключить появление меню при нажатии [E] на world entity
PIS.Config.WorldInteractButtons = { }
--[[
	{
		text 	 = "Открыть инвентарь",
		material = Material("nykez/settings.png"),
		color 	 = Color(255, 255, 255),
		func 	 = function()
			DarkRP.openPocketMenu()
		end
	},
	{
		text 	 = "Выбросить деньги",
		material = Material("nykez/settings.png"),
		color 	 = Color(175, 255, 175),
		func 	 = function()
			StrRequest("Выбросить деньги.", "Сколько вы хотите бросить на землю?", function(s)
				s = tonumber(s)
				if s < 0 then return end
				RunConsoleCommand("say", "/dropmoney "..s)
			end)()
		end
	},
	{
		text 	 = "Выбросить оружие",
		material = Material("nykez/settings.png"),
		color 	 = Color(175, 255, 175),
		func 	 = function()
			RunConsoleCommand("say", "/drop")
		end
	},
	{
		text 	 = "Продать все двери",
		material = Material("nykez/settings.png"),
		color 	 = Color(175, 255, 175),
		func 	 = function()
			RunConsoleCommand("sellall")
		end
	},
]]--

local IsLiked = function(ply) 
    local reactt = ply:GetReactsTable()
    return reactt.reacted == 1 
end

local GetCuffsTrace = function(ply)
    local tr = util.TraceLine({
        start = ply:EyePos(),
        endpos = ply:EyePos() + ply:GetAimVector()*100,
        filter = ply
    })
    if IsValid(tr.Entity) and tr.Entity:IsPlayer() then
        local cuffed, wep = tr.Entity:IsHandcuffed()
        if cuffed then return tr, wep end
    end
end

PIS.Config.EntityIteractButtons = {}

PIS.Config.PlayerIteractButtons = {
--[[
    {
        text = "Поставить метку",
        material = Material("ping_system/apex/ping.png"),
        color = Color(175, 255, 175),
        func = function()
            local id = "go"
            PIS:AddPing(LocalPlayer(), id, LocalPlayer():GetEyeTrace().HitPos)
            net.Start("PIS.PlacePing")

            net.WriteTable({
                id = id,
                pos = LocalPlayer():GetEyeTrace().HitPos,
                directedAt = LocalPlayer()
            })

            net.SendToServer()
        end
    },
]]--
    
    {
        text = translates.Get("Оседлать") or "Оседлать",
        material = CahceMaterial("ping_system/mount.png"),
        color = Color(255, 255, 255),
        func = function(ply, pnl)
            local trent = LocalPlayer():GetEyeTrace().Entity
            if trent ~= ply then
                rp.Notify(NOTIFY_RED, "Вы должны смотреть на животное!")
                return
            end
            RunConsoleCommand("say", "/sit")
        end,
        access = function(self, target) return target:GetJobTable().PlayersCanSeat or false end
    },
    {
        text = function(ply)
            return ply:HasLikeReact() and (translates.Get("Отнять лайк") or "Отнять лайк") or (translates.Get("Поставить лайк") or "Поставить лайк")
        end,
        material = function(self, ply)
            return ply:HasLikeReact() and Material("ping_system/dislike.png", "smooth", "noclamp") or Material("ping_system/like.png", "smooth", "noclamp")
        end,
        color = Color(255, 255, 255),
        func = function(ply, pnl)
            ply:ToggleLikeReaction()
        end,
        access = function(self, target) return not target:IsBot() end
    },

    {
        text = translates.Get("Обыскать") or "Обыскать",
        material = Material("ping_system/give_gun.png", "smooth", "noclamp"),
        color = Color(255, 255, 255),
        func = function(ply, pnl)
            RunConsoleCommand("confiscation")
        end,
        access = function(self, target) return (self:IsCP() or self:IsCombine() or self:IsMayor()) and target:CanConfiscateBy(self) end
    },
    {
        text = translates.Get("Поднять с земли") or "Поднять с земли",
        material = Material("ping_system/follow.png", "smooth", "noclamp"),
        color = Color(255, 255, 255),
        func = function(ply, pnl)
            net.Start('DeathMechanics');
                net.WriteUInt(3, 3);
            net.SendToServer();
        end,
        access = function(self, target) return target:IsInDeathMechanics() and not self:IsHandcuffed() and IsValid(self:GetWeapon("weapon_cuff_elastic")) end
    },
    {
        text = translates.Get("Надеть наручники"),
        material = Material("ping_system/addcuffs.png", "smooth", "noclamp"),
        color = Color(255, 255, 255),
        func = function(ply, pnl)
            local swep = LocalPlayer():GetWeapon("weapon_cuff_elastic")
            if not IsValid(swep) then return end
            PIS.BlockUseDelay = CurTime() + 0.75

            input.SelectWeapon(swep)
            
            timer.Simple(0.15, function()
                if not LocalPlayer():GetActiveWeapon("weapon_cuff_elastic") then return end
                net.Start("DoPrimaryAttack")
                net.SendToServer()
            end)
        end,
        access = function(self, target) return not self:IsHandcuffed() and not target:IsHandcuffed() and IsValid(self:GetWeapon("weapon_cuff_elastic")) end
    },
    {
        text = translates.Get("Снять наручники"),
        material = Material("ping_system/offcuffs.png", "smooth", "noclamp"),
        color = Color(255, 255, 255),
        func = function(ply, pnl)
            PIS.BlockUseDelay = CurTime() + 0.75

            net.Start("Cuffs_FreePlayer")
                net.WriteEntity(ply)
            net.SendToServer()
        end,
        access = function(self, target) return target:IsHandcuffed() and not self:IsHandcuffed() end
    },
    {
        text = function(ply)
            local tr, cuff = GetCuffsTrace(LocalPlayer())
            if not cuff or cuff:GetRopeLength() < 0 or not IsValid(cuff:GetKidnapper()) then return "" end
            
            return cuff:GetKidnapper() == LocalPlayer() and translates.Get("Закончить перетаскивание") or translates.Get("Тащить за собой")
        end,
        material = Material("ping_system/follow.png", "smooth", "noclamp"),
        color = Color(255, 255, 255),
        func = function(ply, pnl)
            local tr, cuffs = GetCuffsTrace(LocalPlayer())

            if tr and cuffs:GetRopeLength() > 0 then
                PIS.BlockUseDelay = CurTime() + 0.75

                net.Start("Cuffs_DragPlayer")
                    net.WriteEntity( tr.Entity )
                    net.WriteBit(LocalPlayer() ~= cuffs:GetKidnapper())
                net.SendToServer()
            end
        end,
        access = function(self, target)
            local tr, cuff = GetCuffsTrace(LocalPlayer())
            if cuff and IsValid(cuff:GetKidnapper()) and cuff:GetKidnapper() ~= LocalPlayer() then
                return false
            end
            return target:IsHandcuffed() and not self:IsHandcuffed()
        end
    },
    {
        text = function(ply)
            local tr, cuffs = GetCuffsTrace(LocalPlayer())
            if not tr then return "" end

            return translates.Get(cuffs:GetIsGagged() and "Вынуть кляп" or "Вставить кляп")
        end,
        material = Material("ping_system/unmuted.png", "smooth", "noclamp"),
        color = Color(255, 255, 255),
        func = function(ply, pnl)
            local tr,cuffs = GetCuffsTrace(ply)

            if tr and cuffs:GetCanGag() then
                PIS.BlockUseDelay = CurTime() + 0.75

                net.Start("Cuffs_GagPlayer")
                    net.WriteEntity(tr.Entity)
                    net.WriteBit(not cuffs:GetIsGagged())
                net.SendToServer()
            end
        end,
        access = function(self, target)
            local tr, cuffs = GetCuffsTrace(LocalPlayer())
            if not tr then return false end

            return target:IsHandcuffed() and not self:IsHandcuffed() and cuffs:GetCanGag()
        end
    },
    {
        text = function(ply)
            local tr, cuffs = GetCuffsTrace(LocalPlayer())
            if not tr then return "" end

            return translates.Get(cuff:GetIsBlind() and "Снять повязку" or "Надеть повязку")
        end,
        material = Material("ping_system/give_money.png", "smooth", "noclamp"),
        color = Color(255, 255, 255),
        func = function(ply, pnl)
           local tr,cuffs = GetCuffsTrace(ply)

            if tr and cuffs:GetCanBlind() then
                PIS.BlockUseDelay = CurTime() + 0.75

                net.Start( "Cuffs_BlindPlayer" )
                    net.WriteEntity( tr.Entity )
                    net.WriteBit( not cuffs:GetIsBlind() )
                net.SendToServer()
                return true
            end
        end,
        access = function(self, target)
            local tr, cuffs = GetCuffsTrace(LocalPlayer())
            if not tr then return false end

            return target:IsHandcuffed() and not self:IsHandcuffed() and cuffs:GetCanBlind()
        end
    },
--[[
    {
        text = "Привязать к точке",
        material = CahceMaterial("ping_system/give_money.png"),
        color = Color(255, 255, 255),
        func = function(ply, pnl)
            PIS.BlockUseDelay = CurTime() + 0.75
            net.Start("Cuffs_TiePlayers")
            net.SendToServer()
        end,
        access = function(self, target)
            local tr, cuffs = GetCuffsTrace(LocalPlayer())
            if not tr then return false end

            return not self:IsHandcuffed() and cuffs
        end
    },
]]--
    {   
        text = function(ply)
            return translates.Get(ply:GetOrg() and ply:GetOrg() == LocalPlayer():GetOrg() and "Выгнать из организации" or "Пригласить в организацию")
        end,
        material = function(self, ply)
            return ply:GetOrg() and ply:GetOrg() == LocalPlayer():GetOrg() and Material("ping_system/deleteorg.png", "smooth", "noclamp") or Material("ping_system/addorg.png", "smooth", "noclamp")
        end,
        color = Color(255, 255, 255),
        func = function(ply, pnl)
            if not ply:GetOrg() or ply:GetOrg() ~= LocalPlayer():GetOrg() then
                rp.RunCommand("orginvite", ply:SteamID64())
                return
            end

            pnl:SetCustomContents({
                {
                    text = translates.Get("Подтвердить"),
                    material = Material("ping_system/accept.png", "smooth", "noclamp"),
                    color = Color(255, 255, 255),
                    func = function(ply, pnl)
                        rp.RunCommand("orgkick", ply:SteamID64())
                    end
                },
                {
                    text = translates.Get("Вернуться назад"),
                    material = Material("ping_system/cancel.png", "smooth", "noclamp"),
                    color = Color(255, 255, 255),
                    func = function(ply, pnl)
                        pnl:SetContents()
                        return false
                    end
                }
            })
            return false
        end,
        access = function(self, target)
            local __a = self:GetOrg()
            local orgdata   = self:GetOrgData()
			
			if not orgdata then return false end
			
            local perms     = orgdata.Perms
            return __a and (not target:GetOrg() or target:GetOrg() == __a) and perms.Invite
        end
    },
    {
        text = translates.Get("Передать деньги"),
        material = Material("ping_system/give_money.png", "smooth", "noclamp"),
        color = Color(255, 255, 255),
        func = function(ply, pnl)
            pnl:SetCustomContents({
                {
                    text = translates.Get("Передать %s", rp.cfg.StartMoney/20),
                    material = Material("ping_system/give_money.png", "smooth", "noclamp"),
                    color = Color(255, 255, 255),
                    func = function(ply, pnl)
                        rp.SendMoney(ply, rp.cfg.StartMoney/20)
                        --RunConsoleCommand("say", "/give " .. rp.cfg.StartMoney/20)
                    end
                },
                {
                    text = translates.Get("Передать %s", rp.cfg.StartMoney/5),
                    material = Material("ping_system/give_money.png", "smooth", "noclamp"),
                    color = Color(255, 255, 255),
                    func = function(ply, pnl)
                        rp.SendMoney(ply, rp.cfg.StartMoney/5)
                        --RunConsoleCommand("say", "/give " .. rp.cfg.StartMoney/5)
                    end
                },
                {
                    text = translates.Get("Передать %s", rp.cfg.StartMoney/2),
                    material = Material("ping_system/give_money.png", "smooth", "noclamp"),
                    color = Color(255, 255, 255),
                    func = function(ply, pnl)
                        rp.SendMoney(ply, rp.cfg.StartMoney/2)
                        --RunConsoleCommand("say", "/give " .. rp.cfg.StartMoney/2)
                    end
                },
                {
                    text = translates.Get("Ввести своё число"),
                    material = Material("ping_system/give_money.png", "smooth", "noclamp"),
                    color = Color(255, 255, 255),
                    func = function(ply)
                        rpui.SliderRequest(translates.Get("Передача денег игроку %s.", ply:Nick()), "rpui/donatemenu/money", 1.5, function(s)
                            rp.SendMoney(ply, tonumber(s))
                        end)
                        --StrRequest(translates.Get("Передача денег игроку %s.", ply:Nick()), translates.Get("Сколько вы хотите передать?"), function(s)
                        --    s = tonumber(s)
                        --    if not s or s < 0 then return end
                        --    rp.SendMoney(ply, tonumber(s))
                        --    --RunConsoleCommand("say", "/give " .. s)
                        --end)()
                        --RunConsoleCommand("givemoney_menu")
                    end
                },
                {
                    text = translates.Get("Вернуться назад"),
                    material = Material("ping_system/cancel.png", "smooth", "noclamp"),
                    color = Color(255, 255, 255),
                    func = function(ply, pnl)
                        pnl:SetContents()
                        return false
                    end
                }
            })
            return false
        end
    },
    {
        text = translates.Get("Передать оружие"),
        material = Material("filters/give_gun.png", "smooth", "noclamp"),
        color = Color(255, 255, 255),
        func = function(ply)
            RunConsoleCommand("transferweapon")
        end,
        access = function() return IsValid(LocalPlayer():GetActiveWeapon()) and rp.cfg.TransferWeaponEnable end
    },
    {
        text = translates.Get("Толкнуть"),
        material = Material("ping_system/follow.png", "smooth", "noclamp"),
        color = Color(255, 255, 255),
        func = function(ply)
            RunConsoleCommand("pushplayer")
        end,
        access = function(self, target) return target:Alive() and not target:IsInDeathMechanics() end
    },
	/*
    {
        text = "Показать ID-карту",
        material = CahceMaterial("ping_system/idcard.png"),
        color = Color(255, 255, 255),
        func = function(ply)
            RunConsoleCommand("showidcard");
        end,
        access = function(self, target) return target:Alive() and not target:IsInDeathMechanics() end
    },
    {
        text = function(ply) return IsLiked(ply) and "Убрать лайк" or "Поставить лайк" end,
        material = CahceMaterial("scoreboard/icons/like.png"),
        color = Color(255, 255, 255),
        func = function(ply)
            if ply:IsBot() then
                rp.Notify(NOTIFY_RED, "Бот не принимает лайки :(")
                return
            end
            if ply == LocalPlayer() then return end

            local id64 = ply:SteamID64()
            if not id64 or string.len(id64) < 5 then return end
            RunConsoleCommand("like_react", id64)

            ply.reacts_data = ply.reacts_data or {
                count = 0,
                reacted = 0
            }

            ply.reacts_data.count = ply.reacts_data.count + (ply.reacts_data.reacted == 1 and -1 or 1)
            ply.reacts_data.reacted = 1 - ply.reacts_data.reacted
        end
    },
	*/
    {
        text = translates.Get("Выдать лицензию"),
        material = Material("ping_system/license.png", "smooth", "noclamp"),
        color = Color(255, 255, 255),
        func = function(ply)
            RunConsoleCommand("givelicense")
        end,
        access = function(self, target) return self:IsMayor() end
    },
    {
        text = function(target)
        	return translates.Get(target:IsWanted() and "Снять розыск" or "Подать в розыск")
        end,
        material = function(self, target)
        	return target:IsWanted() and Material("ping_system/police_down.png", "smooth", "noclamp") or Material("ping_system/police_up.png", "smooth", "noclamp")
        end,
        color = Color(255, 255, 255),
        func = function(ply)
            if ply:IsWanted() then
                RunConsoleCommand("do_unwanted", ply:SteamID())
                return
            end

            local sid64 = ply:SteamID()

            StrRequest(translates.Get("Объявление в розыск игрока %s.", ply:Nick()), translates.Get("Напишите причину розыска"), function(s)
                if string.len(s) < 1 then
                    rp.Notify(NOTIFY_RED, translates.Get("Укажите причину розыска!"))

                    return
                end

                RunConsoleCommand("do_wanted", s, sid64)
            end)()
        end,
        access = function(self, target) return self:IsCP() and not target:IsCP() end
    },
    {
        text = function(ply) return translates.Get(ply:IsArrested() and "Выпустить из тюрьмы" or "Арестовать") end,
        material = function(self, target)
        	return target:IsArrested() and Material("ping_system/freedom.png", "smooth", "noclamp") or Material("ping_system/arrest.png", "smooth", "noclamp")
        end,
        color = Color(255, 255, 255),
        func = function(ply)
            RunConsoleCommand("do_arrest")
        end,
        access = function(self, target) return self:IsCP() and not target:IsCP() and (target:IsWanted() or target:IsArrested()) end
    }
}

timer.Simple(0, function()
    for k, v in pairs(rp.cfg.AdditionalIteractButtons or {}) do
        table.insert(PIS.Config.PlayerIteractButtons, v);
    end
	
    for k, v in pairs(rp.cfg.AdditionalEntIteractButtons or {}) do
		if PIS.Config.EntityIteractButtons[k] then
			for i, j in pairs(v) do
				table.insert(PIS.Config.EntityIteractButtons[k], j)
			end
		else
			PIS.Config.EntityIteractButtons[k] = v
		end
    end
	
    rp.cfg.AdditionalIteractButtons = nil;
    rp.cfg.AdditionalEntIteractButtons = nil;
end);

--[[ Важная тема:
	Which jobs can ping each other? If left empty everyone can see each other
	If you want to make a new group, simply add { } on another line and put the job names in there
	Example:
	{ "Thief", "Mob Boss", "Gangster" },
	{ "Civil Protection", "Civil Protection Chief", "Mayor" }
]]--
PIS.Config.RPTeamViews = {
	{"Бандит", "Глава Банды"},
	{"Полицейский", "SWAT", "FBI"},
}

if SERVER then
	local GetTracedPlayer = function(ply)
		local tr = util.TraceLine({ 
			start = ply:GetShootPos(),
			endpos = ply:GetShootPos() + ply:GetAimVector() * 100,
			filter = ply,
			mask = MASK_SHOT_HULL
		})
		
		if ( !IsValid( tr.Entity ) ) then
			tr = util.TraceHull({
				start = ply:GetShootPos(),
				endpos = ply:GetShootPos() + ply:GetAimVector() * 100,
				filter = ply,
				mins = Vector( -1,-1,0 ),
				maxs = Vector( 1,1,0 ),
				mask = MASK_SHOT_HULL
			})
		end
		
		if IsValid(tr.Entity) and tr.Entity:IsPlayer() then
			return tr.Entity
		end
	end
	
	concommand.Add('pushplayer', function(ply, _, args)
		local target = GetTracedPlayer(ply)
		
		if not IsValid(target) then
			return rp.Notify(ply, NOTIFY_ERROR, rp.Term('MustLookAtPlayer'))
		end
		
		if ply.CantPushPlayer then
			return rp.Notify(ply, NOTIFY_ERROR, rp.Term('FadeDoorCooldown'), 3)
		end
		
		local shiftstraight = ply:GetAngles():Forward() * 1500
		shiftstraight.z = 0
		
		target:SetVelocity(shiftstraight)
        ply:EmitSound("physics/body/body_medium_impact_soft2.wav")
		
		ply.CantPushPlayer = true
		
		timer.Simple(3, function()
			if not IsValid(ply) then return end
			ply.CantPushPlayer = nil
		end)
	end)

    local Left, Right, Format = string.Left, string.Right, string.format;
    local CRC, TColor = util.CRC, team.GetColor;
	
    concommand.Add('showidcard', function(ply, _, args)
        if (!IsValid(ply) or !ply:Alive() or ply:IsInDeathMechanics()) then return end
		
		if (!IsValid(GetTracedPlayer(ply))) then
			return rp.Notify(ply, NOTIFY_ERROR, rp.Term('Vendor_far'));
		end

        local statuses = (rp.cfg.IDCard and rp.cfg.IDCard.statuses) or {};
        local saved = 0;
        local status;

		if rp.cfg.IDCard and rp.cfg.IDCard.custom_get_status then
			status = tostring(rp.cfg.IDCard.custom_get_status(ply))
			
		else
			for k, v in pairs(statuses) do
				if (ply:GetMoney() >= k && saved <= k) then
					status, saved = v, k;
				end
			end
        end

        local id = Left(CRC(ply:SteamID()), 5);
        local loyality = ply:GetJobTable().loyalty or 1;
        id = Left(id, 3) .. ":" .. Right(id, 2);
        rp.LocalChat(CHAT_NONE, ply, 250, TColor(ply:DisguiseTeam() or ply:Team()), Format((rp.cfg.IDCard and rp.cfg.IDCard.text) or "", ply:Name(), id, rp.GetTerm('loyalty')[loyality], status));
    end);
end










-- Оригинальный конфиг:

local yellow = Color(253, 177, 3)
local red = Color(223, 70, 24)
local blue = Color(10, 177, 181)

function PIS.Config:AddPing(id, mat, text, col, command)
	self.Pings[id] = {
		mat = mat,
		text = text,
		color = col,
		command = command,
		id = id
	}

	table.insert(self.PingsSorted, id)
end

function PIS.Config:AddPingSet(id, name)
	table.insert(self.PingSets, { id = id, name = name })
end

-- Colors used. Should explain themselfes
PIS.Config.Colors = {
	Green = Color(46, 204, 113),
	Red = Color(230, 58, 64)
}
PIS.Config.BackgroundColor = Color(44, 44, 44)
PIS.Config.HighlightTabColor = Color(200, 25, 35)
PIS.Config.HighlightColor = Color(193, 70, 40)

PIS.Config.DefaultSettings = {
	PingSound = 1,
	PingOffscreen = 1,
	PingPulsating = 2,
	PingOverhead = 1,
	PingIconSet = 1, -- Change this to 2 if you want Sci-Fi to be default
	Scale = 1,
	DetectionScale = 1,
	PingAvatarVertices = 30,
	WheelDelay = 0.1,
	WheelKey = KEY_E,
	InteractionKey = KEY_F,
	WheelBlur = 1,
	WheelScale = 1,
	WheelMonochrome = 1
}
--
-- IMPORTANT PART OF CONFIG BELOW
--

-- Chat commands to open the ping settings menu
PIS.Config.ChatCommands = {
	//["!pings"] = true,
	//["/pings"] = true,
	//["!ping"] = true,
	//["/ping"] = true
}

-- What authority level does each job have?
-- The higher the number, the more authority.
-- If a job has 5 authority, it can ping anyone thats 4 or below, but not 5 or above.
-- If a job isn't listed here it'll have 1 authority by default
PIS.Config.RPTeamAuthority = {
	["Citizen"] = 1,
	["Thief"] = 2
}

-- This is the settings for the wheel monochrome option.
-- { name, color }
PIS.Config.WheelColors = {
	[1] = { "Disabled", "none" },
	[2] = { "White", color_white },
	[3] = { "Blue", blue },
	[4] = { "Red", red },
	[5] = { "Green", Color(128, 177, 11) }
}

-- Add a ping icon set
-- The number in the options is this order
-- So if there's Apex and Sci-Fi by default, Apex is 1 and Sci-Fi is 2.
-- Adding another ping set without removing any other would make that be 3 assuming you add it after
-- PIS.Config:AddPingSet("path_in_materials_folder", "display_name")
PIS.Config:AddPingSet("apex", "Apex Legends")
PIS.Config:AddPingSet("starwars", "Sci-Fi")

-- This are the pings in the wheel. Adding/deleting some will make the wheel rescale automatically, but I don't recommend going past 12 pings at max.
-- Syntax:
-- PIS.Config:AddPing("ping_unique_id", "ping_material_name", "ping_display_name", "color", [OPTIONAL - command_ping_text. If this is enabled it'll automatically be a command ping])
PIS.Config:AddPing("go", "ping", "GO", yellow, "Сюда!")
PIS.Config:AddPing("enemy", "enemy", "ENEMY", red)
PIS.Config:AddPing("scouting_here", "box", "SCOUTING HERE", blue, "SCOUT HERE")
PIS.Config:AddPing("attacking_here", "attack_here", "ATTACKING HERE", blue, "ATTACK HERE")
PIS.Config:AddPing("going_here", "ping", "GOING HERE", blue)
PIS.Config:AddPing("defending_this_area", "defending_this_area", "DEFENDING THIS AREA", blue, "DEFEND THIS AREA")
PIS.Config:AddPing("watching_here", "eye", "WATCHING HERE", blue, "WATCH HERE")
PIS.Config:AddPing("someones_been_here", "run", "SOMEONE'S BEEN HERE", red)
 