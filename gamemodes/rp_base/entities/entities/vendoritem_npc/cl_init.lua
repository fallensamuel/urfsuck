-- "gamemodes\\rp_base\\entities\\entities\\vendoritem_npc\\cl_init.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
include("shared.lua")

local draw_SimpleText = draw.SimpleText
local surface_SetDrawColor = surface.SetDrawColor
local surface_DrawRect = surface.DrawRect
local math_Approach = math.Approach
local draw_Blur = draw.Blur
local surface_GetTextSize = surface.GetTextSize
local draw_RoundedBox = draw.RoundedBox
local surface_DrawLine = surface.DrawLine
local color_green = Color(127, 255, 127, 255)
local str_sub = string.sub
local white_col = Color(255, 255, 255)
local burned_col = Color(116, 81, 61, 255)

local UIColors = {
    Blank = Color(0, 0, 0, 0),
    White = Color(255, 255, 255, 255),
    Black = Color(0, 0, 0, 255),
    Tooltip = Color(0, 0, 0, 228),
    Active = Color(255, 255, 255, 255),
    Background = Color(0, 0, 0, 127),
    Hovered = Color(0, 0, 0, 180),
    Shading = Color(0, 12, 24, 74)
}

local function GetItemCategory_(item_uid)
    for key, tab in pairs(GetShopByCategories_()) do
        if tab.items[item_uid] then return tab.category, key end -- название и индекс категории
    end
end

local function SortItemsByCategory_(items4sort)
    local sorted = {}

    for uid, item_tab in pairs(items4sort) do
        local cat, key = GetItemCategory_(uid)

        if not cat then
            for name, vendor in pairs(rp.VendorsNPCs) do
                if cat then break end
                cat = vendor.items[uid] and vendor.items[uid].category
            end
        end

        if not cat then
            cat = "entities"
        end

        if not key then
            local i = 0
            for _cat, tab in pairs(rp.item.shop) do
                i = i + 1

                if _cat == cat then
                    key = i
                    break
                end
            end
        end

        sorted[key] = sorted[key] or {
            ["category"] = cat,
            ["items"] = {}
        }

        local insert_key = table.insert(sorted[key].items, item_tab)
        sorted[key].items[insert_key].uid = uid
    end

    return sorted
end

local function IsItemLimit(ply, item_uid, max)
    local itemCount = ply:getInv():getItemCount(item_uid) + ply:GetCount(item_uid)

    if not max or max == 0 then
        max = rp.cfg.DroppedItemsLimit or 5
    end

    if itemCount >= max then return true end
    max = rp.cfg.DroppedItemsLimit and (rp.cfg.DroppedItemsLimit * 2) or 10
    if ply:GetCount("rp_item") >= max then return true end
end

local MenuSize = {
    w = 580,
    h = 800
}

local buy_pnl, sell_pnl
function rp.item.openItemVendorMenu(vendor_ent)
    if IsValid(buy_pnl) then buy_pnl:Remove() end
    if IsValid(sell_pnl) then sell_pnl:Remove() end

    local obj = vendor_ent:GetObject()
    --local price_itemtab = rp.item.list[obj.PriceItem] or rp.item.instances[obj.PriceItem]

    local W, H = ScrW(), ScrH()
    local scale = math.Clamp(H / 1080, 0.7, 1)
    local wi, he = 290, 400
    wi = math.max(wi, MenuSize.w * scale)
    he = math.max(he, MenuSize.h * scale)
    
    buy_pnl = vgui.Create("Urf_VendorNpc_Menu")
    buy_pnl:SetSize2(wi, he)
    buy_pnl:SetPos(ScrW()*0.9 - buy_pnl:GetWide(), ScrH() / 2 - buy_pnl:GetTall() / 2)
    buy_pnl:SetText(translates and translates.Get("КУПИТЬ") or "КУПИТЬ")
    buy_pnl.titleico = Material("buy.png", "smooth", "noclamp")
    buy_pnl:SetVendor(vendor_ent)
    buy_pnl.VendorIndex = vendor_ent:EntIndex()
    buy_pnl.is_vendor_iventory = true

    local _CurItemCount = 0
    sell_pnl = vgui.Create("EditablePanel")
    sell_pnl:SetSize(wi, he)
    sell_pnl:SetPos(ScrW()*0.1, ScrH() / 2 - sell_pnl:GetTall() / 2)
    sell_pnl.Paint = function(me, w, h)
        draw_Blur(me)
        surface_SetDrawColor(UIColors.Shading)
        surface_DrawRect(0, 0, w, h)

        if not IsValid(me.icon) then return end

        _CurItemCount = 0
        if obj._GetAnyCount then
            _CurItemCount = obj._GetAnyCount(LocalPlayer())
        elseif obj.PriceItem then
			local items = LocalPlayer():getInv():getItemsByUniqueID(obj.PriceItem)
			for k, item in pairs(items) do
				_CurItemCount = _CurItemCount + item:getCount() * (item.ammoAmount or 1)
			end
		end

        me.icon.SetContentText(me.icon, translates.Get("У вас имеется %s %s", _CurItemCount, obj.PriceName or ":SetPriceName"))
    end

    sell_pnl.icon = sell_pnl:Add("rpui.SocialMenuButton")
    sell_pnl.icon:Dock(FILL)
    sell_pnl.icon.SetColors(sell_pnl.icon, Color(0, 0, 0, 75), Color(23, 26, 33, 255))
    sell_pnl.icon.SetContentIcon(sell_pnl.icon, Material(obj.PriceItemIcon or 'rpui/misc/3d.png', "smooth", "noclamp"))
    sell_pnl.icon.SetContentText(sell_pnl.icon, translates.Get("У вас имеется %s %s", 0, obj.PriceName or ":SetPriceName"))
    sell_pnl.icon.DoClick = function(me) end
    surface.CreateFont("rpui.VendorItem.PriceTxt", {
        font = "Montserrat",
        extended = true,
        weight = 500,
        size = 32 * scale
    })
    surface.CreateFont("rpui.VendorItem.FindInfo", {
        font = "Montserrat",
        extended = true,
        weight = 500,
        size = 20 * scale
    })
    sell_pnl.icon.CustomFont = "rpui.VendorItem.PriceTxt"

    local function get_derived_color(color, value)
        return Color(color.r * value, color.g * value, color.b * value, 112 + value * 143)
    end
    function sell_pnl.icon:Paint(w, h)
        height_bottom = math.floor(h * (self.ContentPercent or .135))
        
        baseColor, textColor = rpui.GetPaintStyle(self, STYLE_BLANKSOLID);
        --a = self.SocialID and social_info[self.SocialID] and 255 or baseColor.a
        a = baseColor.a
        
        surface.SetDrawColor(self.BgColor or Color(255, 255, 255, 255))
        surface.DrawRect(0, 0, w, h)
        surface.SetDrawColor(get_derived_color(self.OutlineColor, a / 255))
        surface.DrawRect(0, h - height_bottom, w, height_bottom)
        
        --draw.RoundedBox(8, 0, 0, w, h, self.BgColor or Color(255, 255, 255, 255))
        --draw.RoundedBoxEx(8, 0, h * (1 - (self.ContentPercent or 0.135)), w, height_bottom, get_derived_color(self.OutlineColor, a / 255), false, false, true, true)
        
        surface.SetDrawColor(self.OutlineColor and Color(self.OutlineColor.r, self.OutlineColor.g, self.OutlineColor.b, a) or Color(0, 0, 0, 255))
        self:DrawOutlinedRect()
        
        draw.SimpleText(self.SocialID and (social_info[self.SocialID] and 'Получено') or self.ContentText or 'бонус', self.CustomFont or (self.Bonus and 'rpui.Fonts.Social.SubButtonText' or 'rpui.Fonts.Social.ButtonText'), w * 0.5, h - height_bottom * 0.5, self.Bonus and Color(textColor.r, textColor.g, textColor.b, 127 + a * .5) or Color(255, 255, 255, 127 + a * .5), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        
        if obj.FindInfo then
            draw.SimpleText(obj.FindInfo, "rpui.VendorItem.FindInfo", w*0.5, h - height_bottom - 12*scale, Color(255, 255, 255, 127 + a * .5), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
        end

        if self.ContentIcon then
            size = w * 0.35 --h * .2
            
            if self.Bonus then
                time_left = self.Bonus.GetPlayTime(self.Bonus) > LocalPlayer():GetPlayTime() and self.Bonus.GetPlayTime(self.Bonus) - LocalPlayer():GetPlayTime() or self.Bonus.InCooldown(self.Bonus, LocalPlayer()) and self.Bonus.GetRemainingCooldown(self.Bonus, LocalPlayer())
                
                if time_left then
                    blocked_text = ba.str.FormatTime(time_left)
                    
                    btx, bty = surface.GetTextSize(blocked_text)
                    
                    surface.SetDrawColor(255, 255, 255, 76 + a * .7)
                    surface.SetMaterial(blocked_icon)
                    surface.DrawTexturedRect(w * .5 - size * .6 - 6 - btx / 2, (h - height_bottom) * .5 - size * .3, size * .6, size * .6)
                    
                    draw.SimpleText(blocked_text, 'rpui.Fonts.Social.BlockedText', w * .5 - btx / 2, (h - height_bottom) * .5, Color(255, 255, 255, 76 + a * .7), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
                    
                    return
                end
            end
            
            surface.SetDrawColor(255, 255, 255, 76 + a * .7)
            surface.SetMaterial(self.ContentIcon)
            surface.DrawTexturedRect(w * .5 - size * .5, (h - height_bottom) * .5 - size * .5, size, size)
        end
    end

    buy_pnl.buyframe = sell_pnl
    sell_pnl.sellframe = buy_pnl

    local x1, y1 = buy_pnl:GetPos()
    local x2, y2 = sell_pnl:GetPos()
    local abc = x1 + buy_pnl:GetWide() + 16
    if abc > ScrW()*0.5 then
        buy_pnl:SetPos(ScrW()*0.5 + 16, y1)
        sell_pnl:SetPos(ScrW()*0.5 - sell_pnl:GetWide() - 16, y2)
    end

    for item, price in pairs(obj.Items) do
        local is_tab = istable(price)
        local real_price = is_tab and price.price or price
		
        local itemtab = is_tab and price or rp.item.list[item] or rp.item.instances[item]
        if not itemtab then continue end
        local pnl = buy_pnl.tabsshop:AddItem(category, item, (itemtab.name or "unknown"), real_price, (itemtab.model or "models/props_borealis/bluebarrel001.mdl"), 0, nil, false, itemtab.icon_override)

        local tr = "за %s %s"
        pnl.CustomText = translates.Get(tr, real_price, obj.PriceSmall or ":SetPriceSmall")
        pnl.CustomTextHover = translates.Get(tr, real_price, obj.PriceName or ":SetPriceName")
        pnl._ItemTable = itemtab
        pnl.CustomRedCheck = function()
            return _CurItemCount < real_price
        end
    end
	
    for case_id, price in pairs(obj.Cases) do
        local itemtab = rp.lootbox.Map[case_id]
        if not itemtab then continue end
        local pnl = buy_pnl.tabsshop:AddItem(category, case_id, (itemtab.name or "unknown"), price, (itemtab.model or "models/props_borealis/bluebarrel001.mdl"), 0, nil, false, itemtab.icon_override)

        local tr = "за %s %s"
        pnl.CustomText = translates.Get(tr, price, obj.PriceSmall or ":SetPriceSmall")
        pnl.CustomTextHover = translates.Get(tr, price, obj.PriceName or ":SetPriceName")
        pnl._ItemTable = itemtab
        pnl.CustomRedCheck = function()
            return _CurItemCount < price
        end
    end

    hook.Add("VendorNPC_TradeHook", "_hi_", function(pnl, uid, amount, item_btn, dt)
		if rp.lootbox.Map[uid] then
			net.Start("VendorCaseNPC")
				net.WriteInt(vendor_ent:EntIndex(), 32)
				net.WriteString(uid)
			net.SendToServer()
			
		else
			net.Start("VendorItemNPC")
				net.WriteInt(vendor_ent:EntIndex(), 32)
				net.WriteString(uid)
			net.SendToServer()
		end
    end)
end

net.Receive("VendorItemNPC", function()
    local net_index = net.ReadInt(32)
	local ent = Entity(net_index)
    if not IsValid(ent) then return end
	
    rp.item.openItemVendorMenu(ent)
end)

--————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————
if not ENT then return end -- Что-бы я мог подгружать код с помощью lua_openscript_cl без удаления куска кода связанного с энтитёй.
-- Спасибо, ёбаный lua_refresh - который никогда не работает :( :( :(
-- На работоспособность скрипта ни как не влияет, по этому просьба не убирать это для удобства дальнейших правок и обновлений.

ENT.RenderGroup = RENDERGROUP_BOTH

function ENT:Draw()
    self:DrawModel()
end

function ENT:SetRagdollBones(bIn)
    self.m_bRagdollSetup = bIn
end

--if rp.DrawInfoBubble then return end

local tr = translates
local cached
local function check_cached_string()
    if cached then return end
    
    if tr then
        cached = tr.Get( "[E] Открыть Магазин" )
    else
        cached = "[E] Открыть Магазин"
    end
end

function ENT:DrawTranslucent()
    local obb = self:OBBMaxs()
    local pos = (self:LookupBone("ValveBiped.Bip01_Head1") and self:GetBonePosition(self:LookupBone("ValveBiped.Bip01_Head1")) or IsValid(self) and self:GetPos() + Vector(0, 0, 64) or Vector(0, 0, 0)) + Vector(0, 0, 16)
    if LocalPlayer():GetPos():DistToSqr(pos) > (800 * 800) then return end
    local ang = LocalPlayer():EyeAngles()
    ang:RotateAroundAxis(ang:Forward(), 90)
    ang:RotateAroundAxis(ang:Right(), 90)
    cam.Start3D2D(pos, Angle(0, ang.y, 90), 0.1)
    local _, tall = draw_SimpleText(self:GetObject().Name, "VendorNpc_Name", 0, 0, color_white, TEXT_ALIGN_CENTER)
    check_cached_string()
    draw_SimpleText(cached, "VendorNpc_Text", 0, tall, color_green, TEXT_ALIGN_CENTER)
    cam.End3D2D()
end

function ENT:Initialize()
    local index = self:EntIndex()

    hook.Add("PostDrawTranslucentRenderables", "DrawNpc_" .. index, function()
        if not IsValid(self) then
            hook.Remove("PostDrawTranslucentRenderables", "DrawNpc_" .. index)

            return
        end

        self:DrawTranslucent()
    end)
end