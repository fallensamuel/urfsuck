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
	    ico_col = GetBubbleColr,
	    title_colr = GetBubbleColr,
	    desc = "[E] Взять профессию",
	    offset = Vector(0, 0, 11),
	    scale = 0.6,
	    customCheck = function(ent)
	    	return not ent:IsHidden(LocalPlayer())
	    end
	})
end)

hook.Add("ConfigLoaded", "AddHeistsBubble", function()
	local CurrentTime = CurTime
	local Vec = Vector
	local rp_ArmoryHeists_GetHeistCfg = rp.ArmoryHeists.GetHeistCfg

	local heist_materials = {
	    blue = Material("bubble_hints/heist_blue.png", "smooth", "noclamp"),
	    red = Material("bubble_hints/heist_red.png", "smooth", "noclamp"),
	    white = Material("bubble_hints/heist_white.png", "smooth", "noclamp"),
	    --outline = Material("bubble_hints/heist_outline.png", "smooth", "noclamp"),
	    refresh = Material("bubble_hints/refresh.png", "smooth", "noclamp")
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

	        if heist_obj.IsInProgress then
	            if (ent.NextIcoChange or 0) < CT then
	                ent.NextIcoChange = CT + 1.5

	                ent.ActiveHeitsIco = ent.ActiveHeitsIco == heist_materials.blue and heist_materials.red or heist_materials.blue
	                return ent.ActiveHeitsIco
	            else
	                return ent.ActiveHeitsIco or heist_materials.blue
	            end
	        elseif heist_obj.Timestamp > CT then
	            return heist_materials.refresh
	        else
	            return heist_materials.white
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
	            return "Ограбление: "..ba.str.FormatTime(heist_obj.Timestamp - CurrentTime(), true) 
	        elseif heist_obj.Timestamp > CurrentTime() then
	            return "Перезарядка: "..ba.str.FormatTime(heist_obj.Timestamp - CurrentTime(), true)            
	        else
	            --local hcfg = rp_ArmoryHeists_GetHeistCfg(heist_obj.ID)
	            --return hcfg and hcfg.Name or "Ограбление"
	            return "Ограбление"
	        end
	    end,
	    desc = function(ent)
	        local heist_obj = GetHeistObject(ent)
	        if not heist_obj then return end
	        if HeistInProcess(ent) and LocalPlayer():GetPos():DistToSqr(ent:GetPos()) > rp.cfg.BubbleRadius*rp.cfg.BubbleRadius then return end

	        if heist_obj.IsInProgress then
	            return ( GetHeistCfg(ent) and GetHeistCfg(ent).BubbleName or "%Ошибка%" ).." в процессе ограбления"
	        elseif heist_obj.Timestamp > CurrentTime() then
	            return "Подождите что-бы начать ограбление"
	        else
	            return "Нажмите [E] что-бы начать ограбление"
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