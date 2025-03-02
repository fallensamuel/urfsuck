-- "gamemodes\\rp_base\\gamemode\\addons\\ents\\cl_bubblehints.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local Vec = Vector;

hook.Add("ConfigLoaded", "AddEmployerBubble", function()
	local defaultCol = Color(255, 255, 255)
	local function GetBubbleColr(ent)
		local fac = rp.Factions[ent:GetFaction()]
		return fac.BubbleColor or defaultCol
	end

	local defaultMat = CahceMaterial("rpui/standart.png")
	rp.AddBubble("entity", "npc_employer", {
	    ico = function(ent)
	    	local fac = rp.Factions[ent:GetFaction()]
	    	return (fac.BubbleIcon and CahceMaterial(fac.BubbleIcon)) or defaultMat
	    end,
	    name = function(ent)
	        return rp.Factions[ent:GetFaction()].printName
	    end,
		as_texture = true,
	    ico_col = GetBubbleColr,
	    title_colr = GetBubbleColr,
	    desc = translates.Get("[E] Взять профессию"),
	    offset = Vec(0, 0, 11),
	    scale = 0.6,
	    customCheck = function(ent)
	    	return not ent:IsHidden(LocalPlayer())
	    end
	})

	rp.AddBubble("entity", "vendor_npc", {
	    ico = Material("bubble_hints/cart.png", "smooth"),
	    name = function(ent)
	        return ent:GetVendorName()
	    end,
		as_texture = true,
	    desc = translates.Get("[E] Открыть магазин"),
	    offset = Vec(0, 0, 11),
	    scale = 0.6,
	})

	rp.AddBubble("entity", "universal_npc", {
	    ico = Material("bubble_hints/chat.png", "smooth"),
	    name = function(ent)
	        return ent:GetObject().Name
	    end,
		as_texture = true,
	    desc = function(ent)
	    	if ent._AllowedActs == nil then
	    		ent._AllowedActs = ent:GetAllowedActions()
	    		ent._AllowedActsCount = table.Count(ent._AllowedActs)
	    		local _, v = next(ent._AllowedActs)
	    		ent._AllowedAct = v
	    	end

	    	if ent._AllowedActsCount < 2 then
	    		if ent._AllowedAct then
	    			return ent._AllowedAct.text
	    		end
	    		return ""
	    	end

	    	return translates.Get("Поговорить")
	    end,
	    offset = Vec(0, 0, 11),
	    scale = 0.6,
	})
end)

hook.Add("ConfigLoaded", "AddHeistsBubble", function()
	local CurrentTime = CurTime
	local rp_ArmoryHeists_GetHeistCfg = rp.ArmoryHeists.GetHeistCfg

	local heist_materials = {
	    blue = Material("bubble_hints/heist_blue.png", "smooth noclamp"),
	    red = Material("bubble_hints/heist_red.png", "smooth noclamp"),
	    white = Material("bubble_hints/heist_white.png", "smooth noclamp"),

		blue_stealth = Material("bubble_hints/heist_stealth_blue.png", "smooth noclamp"),
	    red_stealth = Material("bubble_hints/heist_stealth_red.png", "smooth noclamp"),
	    white_stealth = Material("bubble_hints/heist_stealth_white.png", "smooth noclamp"),

	    --outline = Material("bubble_hints/heist_outline.png", "smooth noclamp"),
	    refresh = Material("bubble_hints/refresh.png", "smooth noclamp")
	}

	local GetHeistObject = function(ent)
	    if ent.heist_obj then return ent.heist_obj end

	    local heist_id = ent:GetNWInt("HeistID")
	    if not heist_id then return end
	    local heist_obj = rp.ArmoryHeists.List[heist_id]
	    if not heist_obj then return end

	    ent.heist_obj = heist_obj
	    return heist_obj
	end

	local GetHeistCfg = function(ent)
	    if ent.heist_cfg then return ent.heist_cfg end

	    local heist_id = ent:GetNWInt("HeistID")
	    if not heist_id then return end

	    local heist_cfg = rp.cfg.ArmoryHeists.List[game.GetMap()] and rp.cfg.ArmoryHeists.List[game.GetMap()][heist_id]
	    if not heist_cfg then return end

	    ent.heist_cfg = heist_cfg
	    return heist_cfg
	end

	local function HeistInProcess(ent)
	    local heist_obj = GetHeistObject(ent)
	    if not heist_obj then return end
	    return LocalPlayer():IsCP() and heist_obj.IsInProgress
	end

	rp.AddBubble("item", "box_heist", {
	    InsideScreenPos = HeistInProcess,
	    ico = function(ent)
	        local heist_obj = GetHeistObject(ent)
	        if not heist_obj then return end

	        local CT = CurrentTime()
			local is_stealth = (heist_obj.StealthBreak ~= nil) and (not heist_obj.StealthBreak) or false;

	        if heist_obj.IsInProgress then
	            if (ent.NextIcoChange or 0) < CT then
	                ent.NextIcoChange = CT + 1.5

					if is_stealth then
	                	ent.ActiveHeitsIco = ent.ActiveHeitsIco == heist_materials.blue_stealth and heist_materials.red_stealth or heist_materials.blue_stealth
					else
	                	ent.ActiveHeitsIco = ent.ActiveHeitsIco == heist_materials.blue and heist_materials.red or heist_materials.blue
					end

					return ent.ActiveHeitsIco
	            else
	                return ent.ActiveHeitsIco or (is_stealth and heist_materials.blue_stealth or heist_materials.blue)
	            end
	        elseif heist_obj.Timestamp > CT then
	            return heist_materials.refresh
	        else
	            return is_stealth and heist_materials.white_stealth or heist_materials.white
	        end
	    end,
	    PreAdd = function(ent)
	        if HeistInProcess(ent) then
	            return true
	        end
	    end,
	    --NodrawTrigon = function(ent)
	    --    return HeistInProcess(ent)
	    --end,
	    ShouldMinusY = function(ent)
	        return HeistInProcess(ent)
	    end,
	    --PreDraw = function(ent)
	    --    local heist_obj = GetHeistObject(ent)
	    --    if LocalPlayer():IsCP() and heist_obj.IsInProgress then
	    --
	    --    end
	    --end,
	    IgnoreDistanceLimit = function(ent)
	        return HeistInProcess(ent)
	    end,
	    ignoreZ = function(ent)
	        return HeistInProcess(ent)
	    end,
	    name = function(ent)
	        local heist_obj = GetHeistObject(ent)
	        if not heist_obj then return end
	        if HeistInProcess(ent) and LocalPlayer():GetPos():DistToSqr(ent:GetPos()) > rp.cfg.BubbleRadius*rp.cfg.BubbleRadius then return end

	        if heist_obj.IsInProgress then
				if (heist_obj.StealthBreak ~= nil) then
					return translates.Get(((not heist_obj.StealthBreak) and "Скрытое ограбление: %s" or "Ограбление: %s"), ba.str.FormatTime(heist_obj.Timestamp - CurrentTime()), true)
				end

	            return translates.Get("Ограбление: %s", ba.str.FormatTime(heist_obj.Timestamp - CurrentTime()), true)
	        elseif heist_obj.Timestamp > CurrentTime() then
	            return translates.Get("Перезарядка: %s", ba.str.FormatTime(heist_obj.Timestamp - CurrentTime()), true)
	        else
	            --local hcfg = rp_ArmoryHeists_GetHeistCfg(heist_obj.ID)
	            --return hcfg and hcfg.Name or "Ограбление"
	            return translates.Get((heist_obj.StealthBreak == nil) and "Ограбление" or "Скрытое ограбление")
	        end
	    end,
	    desc = function(ent)
	        local heist_obj = GetHeistObject(ent)
	        if not heist_obj then return end
	        if HeistInProcess(ent) and LocalPlayer():GetPos():DistToSqr(ent:GetPos()) > rp.cfg.BubbleRadius*rp.cfg.BubbleRadius then return end

	        if heist_obj.IsInProgress then
	            return translates.Get("%s в процессе ограбления", GetHeistCfg(ent) and GetHeistCfg(ent).BubbleName or "ERROR")
	        elseif heist_obj.Timestamp > CurrentTime() then
	            return translates.Get("Подождите чтобы начать ограбление")
	        else
	            return translates.Get("Нажмите [E] чтобы начать ограбление")
	        end
	    end,
	    offset = Vec(0, 0, 16),
	    ico_rotate = function(ent)
	        local heist_obj = GetHeistObject(ent)
	        if not heist_obj then return end

	        if heist_obj.IsInProgress then
	            return false
	        elseif heist_obj.Timestamp > CurrentTime() then
	            return true
	        else
	            return false
	        end
	    end,
	    rotate_offset = function()
	        return (rp.cfg.BubbleRended3D2D and not ent.InternalBubbleHideTxt) and Vec(-110, 0, 0) or Vec(-55, 0, 0)
	    end,
	    scale = 0.75
	})
end)