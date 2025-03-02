AddCSLuaFile()

SWEP.PrintName = "Телепорт G-Man"
SWEP.Author = "urf.im"
SWEP.Purpose = ""
SWEP.Category = "Root"
SWEP.Slot = 0
SWEP.SlotPos = 4
SWEP.Spawnable = true
SWEP.AdminOnly = true
SWEP.ViewModel = ""
SWEP.WorldModel = ""
SWEP.ViewModelFOV = 54
SWEP.HoldType		= "normal"
SWEP.UseHands = true
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "none"
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo = "none"
SWEP.DrawAmmo = false
local CurTime = CurTime

SWEP.Settings = {
    Cooldown = 50, -- задержка после использования (в секундах)
    Sound = "ambient/machines/teleport3.wav",
    zOffset = 0.5
}

function SWEP:Initialize()
    self:SetHoldType("normal")
end

function SWEP:PrimaryAttack()
    self:SetNextPrimaryFire(CurTime() + 1)
    self:SetNextSecondaryFire(CurTime() + 1)

    if CLIENT then return end

    net.Start("_net_oldmanteleport")
    net.Send(self:GetOwner())
end

function SWEP:SecondaryAttack()
    self:PrimaryAttack()
end

SWEP.TeleportPositions = {}
function SWEP:AddTeleportPos(vec, name, imgurl)
    if SERVER then
        self.TeleportPositions[name] = vec
    else
        self.TeleportPositions[name] = imgurl
    end
end

SWEP:AddTeleportPos(Vector(3977, 3541, 256), "Площадь", "https://i.imgur.com/TJ9ENrO.png")
SWEP:AddTeleportPos(Vector(7959, 3813, 384), "НН", "https://i.imgur.com/JYIjXzu.png")
SWEP:AddTeleportPos(Vector(-3262, -1240, 328), "D6", "https://i.imgur.com/F21FqpG.png")
SWEP:AddTeleportPos(Vector(5832, 9641, -224), "D7", "https://i.imgur.com/FJ1UkCR.png")
SWEP:AddTeleportPos(Vector(8723, 2810, 6944), "Кабинет АГ", "https://i.imgur.com/GEYCkLP.png")
--SWEP:AddTeleportPos(Vector(1435, -636, -1343), "Тяжелая", "https://i.imgur.com/rhkKXzs.jpg")
--SWEP:AddTeleportPos(Vector(-1750, -994, -496), "SCP-354", "https://i.imgur.com/kDVjtMO.jpg")
--SWEP:AddTeleportPos(Vector(-4174, -2391, -1216), "Блок D", "https://i.imgur.com/zIH37yv.jpg")

nw.Register'OldManTeleport':Write(net.WriteUInt, 32):Read(net.ReadUInt, 32):SetLocalPlayer()

if SERVER then
    util.AddNetworkString("_net_oldmanteleport")

    net.Receive("_net_oldmanteleport", function(len, ply)
        if (ply:GetNetVar("OldManTeleport") or 0) > CurTime() then return end

        local swep = ply:GetActiveWeapon()
        if not IsValid(swep) then return end
        local settings = swep.TeleportPositions
        if not settings or not swep.Settings then return end

        local name = net.ReadString()
        if not settings[name] then return end

        local pos = settings[name]

        local OldGold = ply:HasGodMode()

        ply:SetNetVar("OldManTeleport", CurTime() + swep.Settings.Cooldown)

        ply:SetPos(pos - Vector(0, 0, ply:OBBMaxs().z * swep.Settings.zOffset))
        ply:EmitSound(swep.Settings.Sound)

        ply:Lock()
        timer.Simple(2, function()
            if not IsValid(ply) then return end

            ply:SetPos(pos)
            ply:UnLock(false)
            if OldGold then
                ply:GodEnable()
            else
                ply:GodDisable()
            end
        end)
    end)

    return
end

local surface = surface
local colorwhite, whiteHover = Color(255, 255, 255), Color(240, 240, 255, 210)
local colorProgress, colorProgressBG = Color(40, 149, 220), Color(40, 69, 79, 100)

net.Receive("_net_oldmanteleport", function()
    local swep = LocalPlayer():GetActiveWeapon()
    local settings = swep.TeleportPositions
    if not settings then return end

    local menu = vgui.Create("urf.im/rpui/menus/blank&scroll")
    menu:SetSize(500, 265)
    menu:Center()
    menu:MakePopup()

    menu.header.SetIcon(menu.header, "rpui/misc/flag.png")
    menu.header.SetTitle(menu.header, "Телепортация")
    menu.header.SetFont(menu.header, "rpui.playerselect.title")

    menu.header:SetTall(32)
    function menu:PerformLayout(w, h)
        self.header.SetSize(self.header, self:GetWide(), 32)

        local ScrollContainer = self.ScrollContainer
        
        ScrollContainer:SetPos(0, self.header.GetTall(self.header))
        ScrollContainer:SetSize(self:GetWide(), self:GetTall() - self.header.GetTall(self.header))

        if self.NoAutomaticItemSize then
            if self.PostPerformLayout then
                self:PostPerformLayout()
            end
            return
        end

        if self.CustomItemsSize then
            local Sw, Sh = ScrollContainer:GetSize()
            for k, pnl in pairs(self.scroll_items) do
                if not IsVALID(pnl) then self.scroll_items[k] = nil continue end
                pnl:SetSize(self:CustomItemsSize(Sw, Sh))
            end
        else
            local wide = ScrollContainer:GetWide() * (self.itemWideM or 0.85)
            local tall = self.itemTall or 30

            for k, pnl in pairs(self.scroll_items) do
                if not IsVALID(pnl) then self.scroll_items[k] = nil continue end
                pnl:SetSize(wide, tall)
            end
        end

        if self.PostPerformLayout then
            self:PostPerformLayout()
        end
    end

    menu.header.IcoSizeMult = 1.25

    menu.progress = vgui.Create("EditablePanel", menu)
    menu.progress:SetSize(menu:GetWide(), 28)
    menu.progress:SetPos(0, menu:GetTall() - menu.progress:GetTall())
    menu.progress.Paint = function(me, w, h)
        local CT = CurTime()
        local delay = (LocalPlayer():GetNetVar("OldManTeleport", CT) or CT) - CT
        local mult = delay / swep.Settings.Cooldown

        menu.cur_progress = delay

        if mult < 0.01 then
            return
        end

        surface.SetDrawColor(colorProgressBG)
        surface.DrawRect(0, 0, w, h)

        surface.SetDrawColor(colorProgress)
        surface.DrawRect(0, 0, w*mult, h)

        draw.SimpleText("Перезарядка "..math.ceil(delay).." сек", "HUDBarFont", w*0.5, h*0.5, colorwhite, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    menu.DIconLayout = vgui.Create("DIconLayout")
    menu.DIconLayout:Dock(FILL)
    menu.DIconLayout:DockMargin(12, 12, 0, 8)
    menu.DIconLayout:SetSpaceY(8)
    menu.DIconLayout:SetSpaceX(8)
    menu.scroll:AddItem(menu.DIconLayout)

    local pnlSize = (menu:GetWide() - 12*5) / 5

    for name, img in pairs(settings) do
        local web_mat
        wmat.Create(img, {URL = img, UseHTTP = true, }, function(mat)
            web_mat = mat
        end)

        local pnl = menu.DIconLayout:Add("DButton")
        pnl:SetText("")
        pnl:SetSize(pnlSize, pnlSize)
        pnl.Paint = function(me, w, h)
            if web_mat then
                surface.SetDrawColor(me:IsHovered() and whiteHover or colorwhite)
                surface.SetMaterial(web_mat)
                surface.DrawTexturedRect(0, 0, w, h)
            end

            draw.SimpleText(name, "HUDBarFont", w*0.5, h*0.5, colorwhite, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end
        pnl.DoClick = function(me)
            if menu and menu.cur_progress and menu.cur_progress >= 1 then return end
            net.Start("_net_oldmanteleport")
            net.WriteString(name)
            net.SendToServer()
        end
    end
end)