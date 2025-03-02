-- "gamemodes\\rp_base\\gamemode\\main\\menus\\rpui_elements\\inventorytooltip_cl.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local tr = translates.Get;

local BackgroundColor = Color(0, 0, 0, 255 * 0.87)
local DefaultRarityCol = Color(255, 255, 255)
local DescCol = Color(175, 175, 175)
local WhiteCol = Color(255, 255, 255)
local GrayCol = Color(96, 96, 96)
local DrawText = draw.DrawText

local trUsedInCrafts = tr( "Используется для крафта" );
local trIsSellable = tr( "Можно продать" );

local MarginHorizontal, MarginVertical = 15, 8

local PANEL = {}

function PANEL:Init()
    self:SetFont("rpui.InventoryTooltip")
    self:SetAlpha(0)

    self._Text = ""

    self.Think = function(self)
        if IsValid(self.TargetPanel) then
            if self.TargetPanel.OnTooltipInit then
                self.TargetPanel:OnTooltipInit(self)
            end
            self.Think = nil
        end
    end
end

function PANEL:PositionTooltip()
    if not IsValid(self.TargetPanel) then
        self:Close()
        return
    end

    local x, y = input.GetCursorPos()
    local w, h = self:GetSize()

    local lx, ly = self.TargetPanel:LocalToScreen(0, 0)

    x = math.Clamp(x, lx, lx + self.TargetPanel:GetWide()) - w
    y = ly - h - 8

    self:SetPos(x, y)
end

function PANEL:PaintOver(w, h)
    draw.Blur(self)
    surface.SetDrawColor(BackgroundColor)
    surface.DrawRect(0, 0, w, h)

    if self.item == nil then return end

    local margin_horizontal = self.Model and (MarginHorizontal + h) or MarginHorizontal

    if self.Model then
        surface.DrawRect(0, 0, h, h)
    end

    if (not self.Desc) and (not self.Stats) then
        DrawText(self._Text, self:GetFont(), margin_horizontal, self.titleH * 0.5 + MarginVertical * 0.25, self:GetTextColor(), TEXT_ALIGN_LEFT )
        DrawText(self.Rarity, self:GetFont(), w - MarginHorizontal, self.titleH * 0.5 + MarginVertical * 0.25, self:GetTextColor(), TEXT_ALIGN_RIGHT )
    else
        DrawText(self._Text, self:GetFont(), margin_horizontal, MarginVertical, self:GetTextColor(), TEXT_ALIGN_LEFT )
        DrawText(self.Rarity, self:GetFont(), w - MarginHorizontal, MarginVertical, self:GetTextColor(), TEXT_ALIGN_RIGHT )

        if self.Desc then
            DrawText(self.Desc, "rpui.InventoryTooltipDesc", margin_horizontal, MarginVertical*2 + self.titleH, DescCol)
        end
    end

    local CurX, CurY = margin_horizontal, MarginVertical*2 + self.titleH + MarginVertical + (self.DescH > 0 and self.DescH + MarginVertical * 0.5 or -MarginVertical * 0.5)
    
    if self.Stats then
        for k, v in pairs(self.Stats) do
            DrawText(k, "rpui.InventoryTooltipDesc", CurX, CurY, WhiteCol)
            DrawText(v, "rpui.InventoryTooltipDesc700", CurX + self.StatsW + MarginHorizontal, CurY, self:GetTextColor(), TEXT_ALIGN_RIGHT)
            CurY = CurY + MarginVertical * 2.25
        end

        CurY = CurY + MarginVertical * 0.5;
    else
        if self.Desc then
            CurY = CurY - MarginVertical * 0.5;
        end
    end

    if self.IsUsedInCrafts then
        DrawText( trUsedInCrafts, "rpui.InventoryTooltipDescItalic", CurX, CurY, GrayCol );
        CurY = CurY + MarginVertical * 2.25
    end

    if self.IsSellable then
        DrawText( trIsSellable, "rpui.InventoryTooltipDescItalic", CurX, CurY, GrayCol );
        CurY = CurY + MarginVertical * 2.25
    end

    if self.Icon then
        surface.SetDrawColor(255, 255, 255)
        surface.SetMaterial(self.Icon)
        surface.DrawTexturedRect(w - 45 - MarginHorizontal, h - 45 - MarginHorizontal, 45, 45)
    end
end


local tEntityStats = {
    ["money_printer_fix"] = {
        [tr("Восполняет")] = "100%" .. tr("прочности"),
    },

    ["ent_medpack"] = {
        [tr("Восполняет")] = "100%" .. tr("здоровья"),
    },

    ["armor_piece_full"] = {
        [tr("Восполняет")] = "100%" .. tr("брони"),
    },

    ["ENTs"] = { -- Entities:
        ["base_simpleprinter_money"] = function( ent )
            return {
                [tr("Количество денег")]  = ent.Rate,
                [tr("Скорость печати")]   = ent.PrinterSpeed,
                [tr("Вместимость денег")] = ent.MaxMoney,
            };
        end,
    },
	
    ["Items"] = { -- Inv items:
        ["base_loyalty"] = function( item )
            if item.loyalty and item.loyalty > 0 then
				return {
					[tr("Макс. лояльность")]  = rp.GetTerm('loyalty')[item.loyalty],
				};
			end
			
			return {
                [tr("Лояльность")]  = 'Макс.',
            };
        end,
    },

    ["SWEPs"] = { -- SWEPs:
        -- Weapon Bases: ----------------------------------------------------------------------------------------------------
        ["tfa_gun_base"] = function( swep ) -- TFA
            return {
                [tr("Урон")] = math.Round( swep.Primary.Damage, 2 ),
                [tr("Темп стрельбы")] = math.Round( swep.Primary.RPM, 2 ),
                [tr("Точность")] = math.Round( 4 - swep.Primary.Recoil - swep.Primary.Spread, 2 ),
            }, true;
        end,

        ["tfa_knife_base"] = function( swep ) -- TFA:Knife
            return {
                [tr("Урон")] = math.Round( swep.Primary.Damage or swep.Secondary.Damage, 2 ),
            }, true;
        end,

        ["swb_base"] = function( swep ) -- SWB
            return {
                [tr("Урон")] = math.Round( swep.Damage, 2 ),
                [tr("Темп стрельбы")] = math.Round( 60 / swep.FireDelay, 2 ),
                [tr("Точность")] = math.Round( 4 - swep.Recoil - swep.HipSpread - swep.AimSpread - swep.SpreadPerShot, 2 ),
            }, true;
        end,

        ["weapon_hl2axe"] = function( swep ) -- SWB:Melee
            return {
                [tr("Урон")] = math.Round( swep.DamageMin .. " - " .. swep.DamageMax, 2 ),
            }, true;
        end,
        ---------------------------------------------------------------------------------------------------------------------
        ["lockpick"] = function( swep )
            return {
                [tr("Время взлома")] = math.Round( swep.LockPickTime * (LocalPlayer():GetTeamTable().lockpicktime or 1), 2 ) .. tr(" сек"),
            };
        end,

        ["keypad_cracker"] = function( swep )
            return {
                [tr("Время взлома")] = math.Round( swep.KeyCrackTime * (LocalPlayer():GetTeamTable().keypadcracktime or 1), 2 ) .. tr(" сек"),
            };
        end,

        ["base_foodswep"] = function( swep )
            return {
                [tr("Восполняет голода")]   = swep.Hunger,
                [tr("Восполняет здоровья")] = swep.Heal,
            };
        end,
    },
};

tEntityStats.SWEPs["cw_base"]   = tEntityStats.SWEPs["swb_base"];
tEntityStats.SWEPs["fas2_base"] = tEntityStats.SWEPs["swb_base"];

rp.cfg.InventoryTooltips = rp.cfg.InventoryTooltips or {};
table.Merge( rp.cfg.InventoryTooltips, tEntityStats );


local function CalcEntityStats( class )
    local stats = rp.cfg.InventoryTooltips[class];
    if stats then return stats; end
    
    local ent = scripted_ents.Get( class );
    if ent then
        if ent.TooltipStats then
            return ent.TooltipStats;
        end

        stats = rp.cfg.InventoryTooltips.ENTs[class] or rp.cfg.InventoryTooltips.ENTs[ent.Base];

        if stats then
            local data, cache = stats(ent);

            if cache then
                scripted_ents.GetStored(class).TooltipStats = data;
            end

            return data;
        end
    end

    local swep = weapons.Get( class );
    if swep then
        if swep.TooltipStats then
            return swep.TooltipStats;
        end

        stats = rp.cfg.InventoryTooltips.SWEPs[class] or rp.cfg.InventoryTooltips.SWEPs[swep.Base];

        if stats then
            local data, cache = stats(swep);

            if cache then
                weapons.GetStored(class).TooltipStats = data;
            end

            return data;
        end
    end
end

local usual = {
	['Обычный'] = true,
}

function PANEL:SetItem(uid)
    self.item = rp.item.list[uid]
    self.uid = uid

    local newW, newH = MarginHorizontal * 2, MarginVertical * 2
    local TextColor = DefaultRarityCol
    self.Rarity = table.GetKeys(rp.cfg.RarityColors)[1];
    --self.Desc = "" --translates.Get("У предмета нет описания")

    if self.item then
        if self.item.rarity then
            self.Rarity = self.item.rarity
        end

        if self.item.desc and self.item.desc ~= "noDesc" then
            self.Desc = self.item.desc
        end

        if rp.item.list[uid].baseTable and rp.cfg.InventoryTooltips['Items'][ rp.item.list[uid].baseTable.uniqueID ] then
			self.Stats = rp.cfg.InventoryTooltips['Items'][ rp.item.list[uid].baseTable.uniqueID ](rp.item.list[uid])
			
        elseif self.item.tooltip_stats and table.Count(self.item.tooltip_stats) > 0 then
            self.Stats = self.item.tooltip_stats
			
        else
            if scripted_ents.GetStored(uid) or weapons.GetStored(uid) then
                self.Stats = CalcEntityStats(uid)
            end
        end

        if self.item.tooltip_icon then
            self.Icon = Material(self.item.tooltip_icon, "smooth noclamp")
        end

        if self.item.model and not self.item.tooltip_hide_model then
            self.Model = self.item.model

            if IsValid(self.ModelPanel) == false then
                self.ModelPanel = self:Add("SpawnIcon")
                self.ModelPanel:SetAlpha( 0 );
                self.ModelPanel:AlphaTo( 255, 0, RealFrameTime() );
            end

            self.ModelPanel:SetModel(self.Model)
            self.ModelPanel:SetDrawOnTop(true)
        else
            self.Model = nil
            if IsValid(self.ModelPanel) then
                self.ModelPanel:Remove()
            end
        end

        self._Text = self.item.name or "unknown"

        if rp.item.usedincraft[uid] then
            self.IsUsedInCrafts = true;
        end

        local sellVendors = rp.VendorsNPCsWhatSells[uid]; 
        if rp.VendorsNPCsWhatSells[uid] then
            self.IsSellable = true; --table.concat( sellVendors, ", " );
        end
    else
        self._Text = "unknown"
    end

    self:SetText("")

    self:SetTextColor((rp.cfg.RarityColors or {})[self.Rarity] or TextColor)
    self.Rarity = usual[self.Rarity] and "" or translates.Get(self.Rarity)

    surface.SetFont(self:GetFont())
    local tw, th = surface.GetTextSize(self._Text)
    newW = newW + tw
    newH = newH + th

    self.titleH = th

    local tw, th = surface.GetTextSize(self.Rarity)
    newW = newW + tw + 55

    surface.SetFont("rpui.InventoryTooltipDesc")
    local tw, th = surface.GetTextSize(self.Desc or "")
    self.DescH = self.Desc and th or 0
    newH = newH + self.DescH + (self.Desc and MarginVertical * 1.25 or (self.Stats and MarginVertical * 0.25 or MarginVertical))

    local StatsW, StatsH = 0, 0

    if self.Stats then
        for k, v in pairs(self.Stats) do
            local thisW, thisH = surface.GetTextSize(k)
            local thisW2, thisH2 = surface.GetTextSize(v)

            StatsH = StatsH + math.max(thisH, thisH2) + MarginVertical*0.5
            StatsW = math.max(StatsW, thisW + thisW2)
        end

        StatsH = StatsH + MarginVertical
    end

    surface.SetFont( "rpui.InventoryTooltipDescItalic" );
    if self.IsUsedInCrafts or self.IsSellable then
        if self.Stats then
            StatsH = StatsH + MarginVertical * 0.5;
        elseif self.Desc then
            StatsH = StatsH + MarginVertical * 0.25;
        end
    end

    if self.IsUsedInCrafts then
        local thisW, thisH = surface.GetTextSize( trUsedInCrafts );

        StatsH = StatsH + thisH + MarginVertical * 0.5;
        StatsW = math.max( StatsW, thisW );
    end

    if self.IsSellable then
        local thisW, thisH = surface.GetTextSize( trIsSellable );

        StatsH = StatsH + thisH + MarginVertical * 0.5;
        StatsW = math.max( StatsW, thisW );
    end

    self.StatsW, self.StatsH = StatsW, StatsH
    StatsW = StatsW + MarginHorizontal

    newW = math.max(newW, tw + MarginHorizontal*2, StatsW + MarginHorizontal*2)
    newH = newH + StatsH
	
    if IsValid(self.ModelPanel) then
        self.ModelPanel:SetSize(newH, newH)
        self.ModelPanel:InvalidateLayout(true)
        self.ModelPanel:SetModel(self.Model)

        newW = newW + newH
    end

    self:SetSize(newW, newH)
end

function PANEL:PerformLayout(w, h) end

vgui.Register("urf.im/inventory/tooltip", PANEL, "rpui.Tooltip")

surface.CreateFont("rpui.InventoryTooltip", {
    font = "Roboto",
    extended = true,
    size = 21,
    weight = 500,
})

surface.CreateFont("rpui.InventoryTooltipDesc", {
    font = "Roboto",
    extended = true,
    size = 14,
    weight = 400,
})

surface.CreateFont("rpui.InventoryTooltipDescItalic", {
    font = "Roboto",
    extended = true,
    size = 14,
    weight = 400,
    italic = true,
})

surface.CreateFont("rpui.InventoryTooltipDesc700", {
    font = "Roboto",
    extended = true,
    size = 14,
    weight = 700,
})

local Panel = FindMetaTable("Panel")

function Panel:SetInventoryTooltip(uid)
    local obj = rp.item.list[uid]
    if obj == nil then
        return false
    end

    self.OnTooltipInit = function(self, tooltip)
        tooltip:SetItem(uid)
    end
    self:SetTooltipPanelOverride("urf.im/inventory/tooltip")

    if rp.cfg.RarityColors == nil then
        rp.cfg.RarityColors = {
            ["Обычный"]     = Color(255, 255, 255),
            ["Редкий"]      = Color(49, 152, 209),
            ["Легендарный"] = Color(220, 168, 34)
        }
    end

    return true
end

function InventoryTooltipDebug(uid)
    local menu = vgui.Create("DFrame")
    menu:SetTitle("InventoryTooltipDebug")
    menu:SetSize(256, 256)
    menu:Center()
    menu:MakePopup()

    local item = menu:Add("DButton")
    item._Text = "Test item"
    item:Dock(FILL)
    item:SetInventoryTooltip(uid)
end