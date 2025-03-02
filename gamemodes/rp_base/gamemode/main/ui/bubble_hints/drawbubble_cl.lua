-- "gamemodes\\rp_base\\gamemode\\main\\ui\\bubble_hints\\drawbubble_cl.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local DrawTexturedRect, SetDrawColor, DrawRect, SetMaterial, isstr = surface.DrawTexturedRect, surface.SetDrawColor, surface.DrawRect, surface.SetMaterial, isstring
local surface_SetFont, surface_GetTextSize, SimpleText = surface.SetFont, surface.GetTextSize, draw.SimpleText
local ColrAlpha, math_Clamp = ColorAlpha, math.Clamp
local DrawTexturedRectRotated = surface.DrawTexturedRectRotated
local math_max = math.max

local ents_GetAll, pairs_, LocalPlayer, ISValid = ents.GetAll, pairs, LocalPlayer, IsValid
local cam_Start3D2D, cam_End3D2D, isfunc, Vec = cam.Start3D2D, cam.End3D2D, isfunction, Vector
local zeroVec = Vec(0, 0, 0)
local ents_FindInSphere = ents.FindInSphere
local Angle_ = Angle
local util_TraceLine = util.TraceLine

local bubble_mat = Material("bubble_hints/rectangle_down.png", "smooth", "noclamp")
local cvar_Get = cvar.GetValue

local white_col = Color(255, 255, 255)
local bubbe_col = Color(0, 0, 0, 180)

surface.CreateFont("rpui.bubble_hint.title", {
    font = "Montserrat",
    extended = true,
    antialias = true,
    size = 64,
    weight = 600
})
surface.CreateFont("rpui.bubble_hint.description", {
    font = "Montserrat",
    extended = true,
    antialias = true,
    size = 32,
})

surface.CreateFont("rpui.bubble_hint.title.toscreen", {
    font = "Montserrat",
    extended = true,
    antialias = true,
    size = 32,
    weight = 600
})
surface.CreateFont("rpui.bubble_hint.description.toscreen", {
    font = "Montserrat",
    extended = true,
    antialias = true,
    size = 16,
})

local bubble_fonts = {
    [1] = { -- 3d2d
        title = "rpui.bubble_hint.title",
        desc = "rpui.bubble_hint.description"
    },
    [2] = { -- to screen
        title = "rpui.bubble_hint.title.toscreen",
        desc = "rpui.bubble_hint.description.toscreen"
    }
}

function PLAYER:CanSeeEnt(ent)
    local tr = util_TraceLine({
        start   = self:EyePos(),
        endpos  = ent:GetPos() + Vector(0, 0, ent:OBBMaxs().z),
        filter = self
    })
    return not tr.HitWorld and (not IsValid(tr.Entity) or (not tr.Entity:IsDoor() and not tr.Entity:IsProp()) ), tr.Entity--tr.Entity == ent
end

local local_rp_DrawInfoBubble = function(alpha, ico, text, desc, custom_ico_col, ico_rotate, rotate_speed, rotate_offset, ToScreenPos, postDraw, title_colr, no_draw_trigon, InsideScreenPos)
    if not ico then return end

    local posX = ToScreenPos and ToScreenPos.x or 0
    local posY = ToScreenPos and ToScreenPos.y or 0

    local fonts = bubble_fonts[ToScreenPos and 2 or 1]

    alpha = math_Clamp(alpha, 0, 180)

    local size_mult = ToScreenPos and 0.5 or 1
    local rect_wide = 128 * size_mult
    local ico_wide = 128 * size_mult
    local txt_wide = 0
    local desc_tall = 0

    local is_txt, is_txt2 = isstr(text), isstr(desc)
    if is_txt then
        surface_SetFont(fonts.title)
        local w, h = surface_GetTextSize(text)
        txt_wide = w
        desc_tall = h
    end

    if is_txt2 then
        surface_SetFont(fonts.desc)
        local w, h = surface_GetTextSize(desc)

        txt_wide = math_max(txt_wide, w)
    end

    local _abc = txt_wide > 0 and rect_wide*0.25 or 0
    local __some1 = -rect_wide*0.5 - txt_wide*0.25
    local __some2 = rect_wide + _abc + txt_wide

    if ToScreenPos and InsideScreenPos then
        posX = math.Clamp(posX, -__some1, ScrW() - __some2 - __some1)
        posY = math.Clamp(posY, 0, ScrH() - ico_wide*1.5)
    end
    
    posY = posY - ico_wide * 1.25
    posX = posX - (__some1 + __some2 * 0.5)
    local tr_x, tr_y, tr_w = (ToScreenPos.x or 0)-ico_wide*0.25, posY + ico_wide, ico_wide*0.5
    
    SetDrawColor(ColrAlpha(bubbe_col, alpha))
    if not no_draw_trigon then
        SetMaterial(bubble_mat)
        DrawTexturedRect(tr_x, tr_y, tr_w, ico_wide*0.25)
    end

    DrawRect(posX + __some1, posY, __some2, ico_wide)

    local _a = -rect_wide*0.25 - ico_wide*0.125 - txt_wide*0.25

    alpha = alpha * 1.25

    if ico_rotate == true then
        local t = RealTime() * 50 * (rotate_speed or 1)

        local _x, _y = 0, 0

        if rotate_offset then
            _x = rotate_offset.x or _x
            _y = rotate_offset.y or _y
        end
        
        SetDrawColor(ColrAlpha(custom_ico_col or white_col, alpha))
        SetMaterial(ico)
        DrawTexturedRectRotated(posX + _x, posY + _y + ico_wide*0.5, ico_wide*0.75, ico_wide*0.75, t)
    else
        SetDrawColor(ColrAlpha(custom_ico_col or white_col, alpha))
        if type(ico) == "IMaterial" then SetMaterial(ico) end
        DrawTexturedRect(posX + _a + ico_wide*0.05, posY + ico_wide*0.175, ico_wide*0.65, ico_wide*0.65)
    end

    local name_tall = 0
    if is_txt then
        local w, h = SimpleText(text, fonts.title, posX + _a + ico_wide * 0.93, posY + ico_wide*0.11, ColrAlpha(title_colr or white_col, alpha))
        name_tall = h
    end
    if is_txt2 then
        SimpleText(desc, fonts.desc, posX + _a + ico_wide * 0.93, posY + ico_wide*0.11 + name_tall - desc_tall*0.125, ColrAlpha(white_col, alpha))
    end

    if postDraw then
        postDraw(posX + _a, posY + ico_wide*0.125, ico_wide*0.75, ico_wide*0.75)
    end
end

local function renderBubble(alpha, ico, text, desc, custom_ico_col, ico_rotate, rotate_speed, rotate_offset, ToScreenPos, postDraw, title_colr, no_draw_trigon, InsideScreenPos)
	local fonts = bubble_fonts[ToScreenPos and 2 or 1]
	
	local posX = 0
    local posY = 0
	
    alpha = 180 --math_Clamp(alpha, 0, 180)

    local size_mult = ToScreenPos and 0.5 or 1
    local rect_wide = 128 * size_mult
    local ico_wide = 128 * size_mult
    local txt_wide = 0
    local desc_tall = 0

    local is_txt, is_txt2 = isstr(text), isstr(desc)
    if is_txt then
        surface_SetFont(fonts.title)
        local w, h = surface_GetTextSize(text)
        txt_wide = w
        desc_tall = h
    end

    if is_txt2 then
        surface_SetFont(fonts.desc)
        local w, h = surface_GetTextSize(desc)

        txt_wide = math_max(txt_wide, w)
    end

    local _abc = txt_wide > 0 and rect_wide*0.25 or 0
    local __some1 = -rect_wide*0.5 - txt_wide*0.25
    local __some2 = rect_wide + _abc + txt_wide

    --if ToScreenPos and InsideScreenPos then
        --posX = math.Clamp(posX, -__some1, ScrW() - __some2 - __some1)
        --posY = math.Clamp(posY, 0, ScrH() - ico_wide*1.5)
    --end
	
	posX = -__some1
	posY = 0
	
    local tr_x, tr_y, tr_w = ico_wide*0.25, posY + ico_wide, ico_wide*0.5
    
    SetDrawColor(ColrAlpha(bubbe_col, alpha))
    if not no_draw_trigon then
        SetMaterial(bubble_mat)
        DrawTexturedRect(tr_x, tr_y, tr_w, ico_wide*0.25)
    end

    DrawRect(posX + __some1, posY, __some2, ico_wide)
    --DrawRect(0, 0, __some2, ico_wide)

    local _a = -rect_wide*0.25 - ico_wide*0.125 - txt_wide*0.25

    alpha = alpha * 1.25

	--print(posX, posY, _a, ico_wide)
	
    if ico_rotate == true then
        local t = RealTime() * 50 * (rotate_speed or 1)

        local _x, _y = 0, 0

        if rotate_offset then
            _x = rotate_offset.x or _x
            _y = rotate_offset.y or _y
        end
        
        SetDrawColor(ColrAlpha(custom_ico_col or white_col, alpha))
        SetMaterial(ico)
        DrawTexturedRectRotated(posX + _x, posY + _y + ico_wide*0.5, ico_wide*0.75, ico_wide*0.75, t)
		
    else
        SetDrawColor(ColrAlpha(custom_ico_col or white_col, alpha))
        if type(ico) == "IMaterial" then SetMaterial(ico) end
        DrawTexturedRect(posX + _a + ico_wide*0.05, posY + ico_wide*0.175, ico_wide*0.65, ico_wide*0.65)
    end

    local name_tall = 0
    if is_txt then
        local wa, ha = SimpleText(text, fonts.title, posX + _a + ico_wide * 0.93, posY + ico_wide*0.11, ColrAlpha(title_colr or white_col, alpha))
        name_tall = ha
    end
    if is_txt2 then
        SimpleText(desc, fonts.desc, posX + _a + ico_wide * 0.93, posY + ico_wide*0.11 + name_tall - desc_tall*0.125, ColrAlpha(white_col, alpha))
    end
	
	--print(__some2, ico_wide)
	
	return __some2, ico_wide + (no_draw_trigon and 0 or ico_wide*0.25)
end

local bubble_cache = {}

local posX, posY, name, w, h

local local_rp_DrawInfoBubbleTexture = function(alpha, ico, text, desc, custom_ico_col, ico_rotate, rotate_speed, rotate_offset, ToScreenPos, postDraw, title_colr, no_draw_trigon, InsideScreenPos)
    if not ico or isfunction(ico) or not ico.GetName then return end

    alpha = math_Clamp(alpha, 0, 180)
	
    posX = ToScreenPos and ToScreenPos.x or 0
    posY = ToScreenPos and ToScreenPos.y or 0

	name = ico:GetName() .. (isstr(text) and text or isstr(desc) and desc or "") .. (custom_ico_col and custom_ico_col.r .. custom_ico_col.g .. custom_ico_col.b or '')
	
	if bubble_cache[name] then
		posX = posX - 32
		posY = posY - bubble_cache[name][2]
		
		if InsideScreenPos then
			posX = math_Clamp(posX, 0, ScrW() - bubble_cache[name][1])
			posY = math_Clamp(posY, 0, ScrH() - bubble_cache[name][2])
		end
    end
	
	w, h = draw.CustomTexture(name, posX, posY, ColorAlpha(white_col, alpha), function()
		return renderBubble(alpha, ico, text, desc, custom_ico_col, ico_rotate, rotate_speed, rotate_offset, ToScreenPos, postDraw, title_colr, no_draw_trigon, InsideScreenPos)
	end)
	
	if w and h then
		bubble_cache[name] = {w, h}
	end
	
    if postDraw then
        postDraw(posX - w * 0.5, posY - h * 0.5, w, h)
    end
end

rp.DrawInfoBubble = local_rp_DrawInfoBubble
rp.DrawInfoBubbleTexture = local_rp_DrawInfoBubbleTexture

local bubble_matLeft, bubble_matRight = Material("bubble_hints/rectangle_left.png", "smooth", "noclamp"), Material("bubble_hints/rectangle_right.png", "smooth", "noclamp")
local math_ceil = math.ceil

rp.DrawInfoBubbleLeft = function(alpha, ico, ToScreenPos, postDraw, drawRight, scale) -- not extended
    local posX = math_ceil(ToScreenPos and ToScreenPos.x or 0)
    local posY = math_ceil(ToScreenPos and ToScreenPos.y or 0)

    if not ico then return end
    alpha = math_Clamp(alpha, 0, 180)

    local size_mult = ToScreenPos and 0.5 or 4
    local rect_wide = 128 * size_mult * (scale or 1)

    local rw075, rw05, rw025, rw0125 = rect_wide*0.75, rect_wide*0.5, rect_wide*0.25, rect_wide*0.125
    local x, y, w, h = posX + rw025 + rw0125, posY - rw05 + rw0125, rw075, rw075

    SetDrawColor(ColrAlpha(bubbe_col, alpha))

    alpha = alpha * 1.25

    if drawRight then
        SetMaterial(bubble_matRight)
        DrawTexturedRect(posX + w + rw05, posY - rw025, rw025, rw05)
    else
        SetMaterial(bubble_matLeft)
        DrawTexturedRect(posX, posY - rw025, rw025, rw05)
    end

    DrawRect(posX + rw025, posY - rw05, rect_wide, rect_wide)

    SetDrawColor(ColrAlpha(custom_ico_col or white_col, alpha))
    SetMaterial(ico)
    DrawTexturedRect(x, y, w, h)

    if postDraw then
        postDraw(x, y, w, h)
    end
end

local rp_DrawInfoBubbleLeft = rp.DrawInfoBubbleLeft
function rp.DrawInfoBubbleRight(alpha, ico, ToScreenPos, postDraw, _, scale)
    rp_DrawInfoBubbleLeft(alpha, ico, ToScreenPos, postDraw, true, scale)
end

rp.cfg.BubbleRadius = rp.cfg.BubbleRadius or 228
local curtime = CurTime

local ToDrawTable = {}

local tinsert = table.insert
local tremove = table.remove
local entsIgnoreZ = {}

local entsQueue = {}
local entsSaved = {}

hook.Add( "NetworkEntityCreated", "SaveBubbleHints", function( ent )
    if ent:GetNWBool("isInvItem") or ent:GetClass() == "rp_item" then
        local ent_cfg = rp.cfg.BubbleHints["item"] and rp.cfg.BubbleHints["item"][ent:GetNWString("uniqueID")];
        if not ent_cfg then return end
        
        if ent_cfg.IgnoreDistanceLimit then
            ent.BubbleSaved = true
            table.insert( entsSaved, ent );
        end
    end
end );

-- hook.Add( "PostRender", "SaveBubbleHints", function()
--     print( SysTime(), "POSTRENDER REG" );
--
--     timer.Simple( 10, function()
--         print( SysTime(), "!!!" );
--         local config = rp.cfg.BubbleHints;
--         local ent_cfg;
--
--         for k, v in pairs( ents.GetAll() ) do
--             if IsValid(v) and v:GetNWBool("isInvItem") or v:GetClass() == "rp_item" then
--                 print( "found item:", v, "uid:", v:GetNWString("uniqueID") );
--
--                 ent_cfg = config.items and config.items[v:GetNWString("uniqueID")]
--                 if not ent_cfg then continue end
--
--                 if ent_cfg.IgnoreDistanceLimit then
--                     print( "saved" );
--                     v.BubbleSaved = true
--                     table.insert( entsSaved, v );
--                 end
--             end
--         end
--     end );
--
--     hook.Remove( "PostRender", "SaveBubbleHints" );
-- end );

hook.Add("HUDPaint", "InitUrfimBubbleHints", function() -- создание таймера только после загрузки игрока
    hook.Remove("HUDPaint", "InitUrfimBubbleHints")

    for k, v in pairs(rp.cfg.BubbleHints or {}) do
        if isfunction(v) then continue end
        for j, f in pairs(v) do
            if (f.ignoreZ) then
                entsIgnoreZ[j] = f.ignoreZ
            end
        end
    end

    local config = {
        items   = rp.cfg.BubbleHints["item"],
        ents    = rp.cfg.BubbleHints["entity"],
        custom  = rp.cfg.BubbleHints["CustomENTs"]
    }
    
    local LP, ply_pos, ent_cfg, ent, remain, remain_all
    local by_trace = rp.cfg.BubbleRenderByTrace
    local MaxDist = rp.cfg.BubbleRadius * rp.cfg.BubbleRadius
    local m_min = math.min
	
    --hook.Add('Think', 'UrfimBubbleHintsQueue', function()
	timer.Create("UrfimBubbleQueue", 0.1, 0, function()
        remain = remain_all or 0
        if remain <= 0 then return end
        
        if not ply_pos then 
            entsQueue = {}
            return 
        end
        
        remain = (remain > 20) and math.max(20, math.ceil(remain * 0.05)) or remain
        remain_all = remain_all - remain
		
        for i = 1, remain do
            ent = table.remove(entsQueue)
            if ToDrawTable[ent] or not IsValid(ent) then continue end
            
            ent_cfg = isfunc(config.custom) and config.custom(ent)

            if not ent_cfg then
                if ent:GetNWBool("isInvItem") then
                    ent_cfg = config.items and config.items[ent:GetNWString("uniqueID")]
                else
                    ent_cfg = config.ents and config.ents[ent:GetClass()]
                end
            end

            if not ent_cfg then continue end

            local res
            if ent_cfg.PreAdd then
                res = ent_cfg.PreAdd(ent)
                if res == false then continue end
            end

            if res ~= true then
                if ( not ent.isIgnoreZ and not LP:CanSeeEnt(ent)) then continue end
                if ply_pos:DistToSqr(ent:GetPos()) > MaxDist then continue end
            end

			if ent_cfg.IgnoreDistanceLimit and not ent.BubbleSaved then
				ent.BubbleSaved = true
				table.insert(entsSaved, ent)
			end
			
            ToDrawTable[ent] = {
                alpha = 0,
                StartTime = curtime() + 0.5,
                bubblehint_cfg = ent_cfg
            }
        end
    end)
    
    timer.Create("UrfimBubbleHints", 1, 0, function()
        if remain_all and remain_all > 0 then return end
        
        LP = LocalPlayer()

        if by_trace then
            ply_pos = LP:GetEyeTrace().HitPos
        else
            ply_pos = LP:GetPos()
        end
        
        for k, v in pairs(entsIgnoreZ) do
            for i, e in pairs(ents.FindByClass(k)) do
                if isfunction(v) and not v(e) then
                    e.isIgnoreZ = nil
                    continue
                end
                e.isIgnoreZ = true
            end
        end

        entsQueue = ents_FindInSphere(LP:GetPos(), 600) 
		table.Add(entsQueue, entsSaved)
		remain_all = #entsQueue
        
        --[[
        for key, ent in pairs_(ents_GetAll()) do
            if ToDrawTable[ent] then continue end
            
            ent_cfg = isfunc(config.custom) and config.custom(ent)

            if not ent_cfg then
                if ent:GetNWBool("isInvItem") then
                    ent_cfg = config.items and config.items[ent:GetNWString("uniqueID")]
                else
                    ent_cfg = config.ents and config.ents[ent:GetClass()]
                end
            end

            if not ent_cfg then continue end

            local res
            if ent_cfg.PreAdd then
                res = ent_cfg.PreAdd(ent)
                if res == false then continue end
            end

            if res ~= true then
                if ( not ent.isIgnoreZ and not LP:CanSeeEnt(ent)) then continue end
                if ply_pos:DistToSqr(ent:GetPos()) > MaxDist then continue end
            end

            ToDrawTable[ent] = {
                alpha = 0,
                StartTime = curtime() + 0.5,
                bubblehint_cfg = ent_cfg
            }
        end
        ]]
    end)
end)

local drawEntsBubble = function()
    local LocalPlayer = LocalPlayer()

    local ply_pos
    if rp.cfg.BubbleRenderByTrace then
        ply_pos = LocalPlayer:GetEyeTrace().HitPos
    else
        ply_pos = LocalPlayer:GetPos()
    end

    if not ply_pos then return end

    local Dist = rp.cfg.BubbleRadius
    local MaxDist = Dist*Dist

    local ang
    if rp.cfg.BubbleRended3D2D then
        ang = LocalPlayer:EyeAngles()
        ang:RotateAroundAxis(ang:Forward(), 90)
        ang:RotateAroundAxis(ang:Right(), 90)
    end

    for ent, data in pairs_(ToDrawTable) do
        if not ISValid(ent) or ent:GetNoDraw() then continue end
        
        local ent_cfg = data.bubblehint_cfg
        if not ent_cfg then continue end

        if ent_cfg.PreDraw then
            if ent_cfg.PreDraw(ent) == false then continue end
        end

        if ent_cfg.customCheck and ent_cfg.customCheck(ent) == false then continue end

        local maxs = ent:OBBMaxs()
        local ent_pos = ent:GetPos()
        local dist = ply_pos:DistToSqr(ent_pos)

        local alpha = data.alpha
        local CT = curtime()
        if not data.Show then
            if CT > data.StartTime then
                data.AlphaToEnd = data.AlphaToEnd or CT + 0.5
                alpha = 180 * math.min(0.5 - (data.AlphaToEnd - CT), 1)
                if alpha >= 180 then
                    data.Show = true
                end
            end
            if not data.HideStart then
                data.HideStart = CT + 1
            end
        elseif (not ent_cfg.IgnoreDistanceLimit or not ent_cfg.IgnoreDistanceLimit(ent)) and (dist > MaxDist or (not ent.isIgnoreZ and not LocalPlayer:CanSeeEnt(ent)) ) then--LocalPlayer:IsLineOfSightClear(ent:GetPos() + Vector(0, 0, maxs.z)) ) then
            if data.HideStart then
                if data.HideStart - CT <= 0 then
                    data.HideEnd = data.HideEnd or CT + 0.3
                    local mult = (data.HideEnd - CT)
                    alpha = 600 * mult
                    if alpha < 1 then
                        ToDrawTable[ent] = nil
                        continue
                    end
                end
            else
                data.HideStart = CT + 0.5
            end
        end
        alpha = math_Clamp(alpha, 0, 180)
        data.alpha = alpha

        --local pos = (ent_cfg.localoffset and ent:LocalToWorld( ent:OBBCenter() + Vec(0, 0, maxs.z*0.5) + ent_cfg.localoffset) or ent_pos)
        local pos = ent:LocalToWorld( ent:OBBCenter() + ((ent_cfg.localoffset) and ent_cfg.localoffset or Vec()) );
        
        if not ent_cfg.centered then
            pos = pos + Vec( 0, 0, maxs.z * 0.5 );
        end
        
        if ent_cfg.offset then
            --pos = pos + (isfunc(ent_cfg.offset) and ent_cfg.offset(ent) or ent_cfg.offset)
        end
        
        local ico = isfunc(ent_cfg.ico) and ent_cfg.ico(ent) or ent_cfg.ico
        local txt = not ent.InternalBubbleHideTxt and (isfunc(ent_cfg.name) and ent_cfg.name(ent) or ent_cfg.name)
        local desc = not ent.InternalBubbleHideTxt and (isfunc(ent_cfg.desc) and ent_cfg.desc(ent) or ent_cfg.desc)
        local ico_col = isfunc(ent_cfg.ico_col) and ent_cfg.ico_col(ent) or ent_cfg.ico_col
        local ico_rotate = (isfunc(ent_cfg.ico_rotate) and ent_cfg.ico_rotate(ent) or ent_cfg.ico_rotate) == true
        local rotate_offset = isfunc(ent_cfg.rotate_offset) and ent_cfg.rotate_offset(ent) or ent_cfg.rotate_offset
        local title_col = isfunc(ent_cfg.title_colr) and ent_cfg.title_colr(ent) or ent_cfg.title_colr
        local nodraw_trigon = (ent_cfg.NodrawTrigon and ent_cfg.NodrawTrigon(ent)) == true
        local InsideScreenPos = (ent_cfg.InsideScreenPos and (isfunc(ent_cfg.InsideScreenPos) and ent_cfg.InsideScreenPos(ent) or ent_cfg.InsideScreenPos)) == true

		if ent_cfg.as_texture and cvar_Get('text_texture_render') then
			local screenPos = pos:ToScreen()
			
			if not (isfunction(ent_cfg.ShouldMinusY) and ent_cfg.ShouldMinusY(ent)) then
				screenPos.y = screenPos.y - dist/(Dist*32)
			end
			
			local_rp_DrawInfoBubbleTexture(alpha * 1.5, ico, txt, desc, ico_col, ico_rotate, ent_cfg.ico_rotate_speed, rotate_offset, screenPos, ent_cfg.PostDraw, title_col, nodraw_trigon, InsideScreenPos)
			
		else
			if rp.cfg.BubbleRended3D2D then
				cam_Start3D2D(pos, Angle_(0, ang.y, ang.z), 0.1 * (isfunc(ent_cfg.scale) and ent_cfg.scale(ent) or ent_cfg.scale or 1))
					local_rp_DrawInfoBubble(alpha*1.5, ico, txt, desc, ico_col, ico_rotate, ent_cfg.ico_rotate_speed, rotate_offset, nil, ent_cfg.PostDraw, title_col, nodraw_trigon)
				cam_End3D2D()
			else
				local screenPos = pos:ToScreen()
				if not (isfunction(ent_cfg.ShouldMinusY) and ent_cfg.ShouldMinusY(ent)) then
					screenPos.y = screenPos.y - dist/(Dist*32)
				end
				local_rp_DrawInfoBubble(alpha * 1.5, ico, txt, desc, ico_col, ico_rotate, ent_cfg.ico_rotate_speed, rotate_offset, screenPos, ent_cfg.PostDraw, title_col, nodraw_trigon, InsideScreenPos)
			end
        end
    end
end

hook.Add("PreDrawEffects", "BubbleHints.Draw", function()
    if not rp.cfg.BubbleRended3D2D then return end
    if not rp or not rp.cfg or not rp.cfg.BubbleHints then return end
    drawEntsBubble()
end) 
hook.Add("HUDPaint", "BubbleHints.Draw", function()
    if rp.cfg.BubbleRended3D2D then return end
    if not rp or not rp.cfg or not rp.cfg.BubbleHints then return end
    drawEntsBubble()
end) 

rp.cfg.BubbleHints = rp.cfg.BubbleHints or {
    ["entity"] = {},
    ["item"] = {}
}

local base_tab, item_tab
rp.cfg.BubbleHints["CustomENTs"] = function(ent)
    item_tab = ent.getItemTable and ent:getItemTable()

    if item_tab then
        if item_tab.BubbleHint then
            return item_tab.BubbleHint
        end
    else
        return
    end
    
    base_tab = item_tab.baseTable
    if base_tab and base_tab.BubbleHint then
        return base_tab.BubbleHint
    end
end

function rp.AddBubble(type, uid, tab)
    if rp.cfg.BubbleHints[type] then
        rp.cfg.BubbleHints[type][uid] = tab
    end
end

-- DEBUG:

local debug_bubble = {
    ico = Material("sprites/sent_ball", "smooth", "noclamp"),
    text = "Hello world!",
    desc = "Bubble hints here!",
    custom_ico_col = Color(40, 149, 220)
}

local MaxDist = 350*350
local hue_wheel = 0

local debug_drawfunc = function()
    local pos = LocalPlayer():GetEyeTrace().HitPos + Vector(0, 0, 16)

    local dist = LocalPlayer():GetPos():DistToSqr(pos)
    if dist > MaxDist then return end
    local alpha = 255 - (math.Clamp( (dist / MaxDist) * 255, 0, 255) )
    if alpha < 1 then return end

    local ang = LocalPlayer():EyeAngles()
    ang:RotateAroundAxis(ang:Forward(), 90)
    ang:RotateAroundAxis(ang:Right(), 90)

    hue_wheel = math.Approach(hue_wheel, 361, FrameTime()*25)
    debug_bubble.custom_ico_col = HSVToColor(math.min(hue_wheel, 360), 1, 1)
    if hue_wheel >= 360 then
        hue_wheel = 0
    end

    cam.Start3D2D(pos, ang, 0.1)
        local_rp_DrawInfoBubble(alpha, debug_bubble.ico, debug_bubble.text, debug_bubble.desc, debug_bubble.custom_ico_col, true, 1, Vector(-75, 0, 0))
    cam.End3D2D()
end

concommand.Add("bubble_debug", function()
    if not LocalPlayer():IsRoot() then return end

    if DebugDrawBubbleHUD then
        DebugDrawBubbleHUD = nil
        hook.Remove("PreDrawEffects", "DebugDrawBubble")
        return
    end

    DebugDrawBubbleHUD = true
    hook.Add("PreDrawEffects", "DebugDrawBubble", debug_drawfunc)
end)

if DebugDrawBubbleHUD then
    hook.Add("PreDrawEffects", "DebugDrawBubble", debug_drawfunc) -- lua_refresh
end