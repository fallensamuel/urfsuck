include("rp_base/gamemode/main/interact_menu/ping_system/config/config.lua")

local framework = Nexus:ClassManager("Framework")
local _draw = framework:Class("Draw")
local anim = framework:Class("Animations")
local panels = framework:Class("Panels")

_NexusPanelsFramework = panels

-- Register panel
local PANEL = {}

local rightClick = Material("ping_system/rmb.png", "smooth")
local leftClick = Material("ping_system/lmb.png", "smooth")

local soundHover = Sound("ping_system/hover.wav")
local soundSelect = Sound("ping_system/accept.wav")
local yellow = Color(253, 177, 3)
local red = Color(223, 70, 24)
local green = Color(129, 163, 19)

hook.Add("DeathMechanics.CanUse", "Interactmenu.Handcuffs", function()
    local self = LocalPlayer()
    local b = not self:IsHandcuffed() and IsValid(self:GetWeapon("weapon_cuff_elastic"))

    local tr = self:GetEyeTrace()
    local ply = tr.Entity
    if IsValid(ply) and ply:IsPlayer() and ply:IsHandcuffed() then return end

    return not b
end)


local think_time, ply_on_trace = CurTime()

hook.Add("Think", "InteractMenu_CheckTrace", function()
    if think_time > CurTime() then return end
    think_time = CurTime() + 0.5

    local tr_ent = LocalPlayer():GetEyeTrace().Entity
    ply_on_trace = IsValid(tr_ent) and tr_ent:IsPlayer()
end)

function IsPlayerOnTrace(force)
    if force then
        local tr_ent = LocalPlayer():GetEyeTrace().Entity
        return IsValid(tr_ent) and tr_ent:IsPlayer(), tr_ent
    else
        return ply_on_trace or false
    end
end

local errorMat = Material("error", "smooth", "noclamp")
function PANEL:SetContents()
    local settings = PIS:GetSettings(LocalPlayer())

    for _, v in pairs(self.SectionsTbl) do
        if not ispanel(v) or not IsValid(v) then continue end

        v:Remove()
    end

    self.SectionsTbl = {}
--
    if self.SelectedPlayer then
		if self.SelectedPlayer:IsPlayer() then
			if PIS.Config.PlayerIteractButtons then
				for i, btn in ipairs(PIS.Config.PlayerIteractButtons) do
					if not btn.access or btn.access(LocalPlayer(), self.SelectedPlayer) then
						self:AddSection(btn.text, btn.material or errorMat, btn.color, btn.func, btn.access, i)
					end
				end
			end
		else
			if PIS.Config.EntityIteractButtons and PIS.Config.EntityIteractButtons[self.SelectedPlayer:GetClass()] then
				for i, btn in ipairs(PIS.Config.EntityIteractButtons[self.SelectedPlayer:GetClass()]) do
					if not btn.access or btn.access(LocalPlayer(), self.SelectedPlayer) then
						self:AddSection(btn.text, btn.material, btn.color, btn.func, btn.access, i)
					end
				end
			end
        end
    elseif PIS.Config.WorldInteractButtons then
        for i, btn in ipairs(PIS.Config.WorldInteractButtons) do
            if not btn.access or btn.access(LocalPlayer(), self.SelectedPlayer) then
                self:AddSection(btn.text, btn.material or errorMat, btn.color, btn.func, btn.access, i)
            end
        end
    end

    self.Sections = #self.SectionsTbl
	
	if self.Sections == 0 then
		PIS.BlockUseDelay = CurTime() + 0.25
		self:Remove()
	end
end

function PANEL:SetCustomContents(contents)
    local settings = PIS:GetSettings(LocalPlayer())

    for _, v in pairs(self.SectionsTbl) do
        if not ispanel(v) or not IsValid(v) then continue end

        v:Remove()
    end

    self.SectionsTbl = {}

    for i, btn in ipairs(contents) do
        if not btn.access or btn.access(LocalPlayer(), self.SelectedPlayer) then
            self:AddSection(btn.text, btn.material, btn.color, btn.func, btn.access, i)
        end
    end

    self.Sections = #self.SectionsTbl
	
	if self.Sections == 0 then
		PIS.BlockUseDelay = CurTime() + 0.25
		self:Remove()
	end
end

function PANEL:AddPlayer(ply)
    local panel = self:Add("Nexus.CircleAvatar")
    panel:SetPlayer(ply, 128)
    panel:SetVertices(90)
    panel.player = ply

    table.insert(self.SectionsTbl, panel)
end

function PANEL:PerformLayout(w, h)
    local sectionSize = 360 / self.Sections
    local rad = self.Radius * 0.4
    for i, v in pairs(self.SectionsTbl) do
        if (!ispanel(v)) then continue end

        local ang = (i - 1) * sectionSize
        ang = math.rad(ang)
        local size = self.Sections > 12 and self.Radius * 2 / self.Sections or (56 * self.Settings.WheelScale)
        if (self.selectedArea and self.selectedArea + 1 == i) then
            size = size * 1.285
        end
        local r = self.Radius - rad / 2
        local sin = math.sin(ang) * r
        local cos = math.cos(ang) * r
        local x = self.Center.X - size / 2 + sin
        local y = self.Center.Y - size / 2 - cos
        
        v:SetSize(size, size)
        v:SetPos(x, y)
    end
end

function PANEL:Init()
    PIS.RadialMenu = self

    self.Settings = PIS:GetSettings(LocalPlayer())

    surface.CreateFont("Nexus.PingSystem.Ping", {
        font = "Montserrat",
        size = math.Round(46 * self.Settings.WheelScale),
        weight = 800,
        extended  = true
    })

    surface.CreateFont("Nexus.PingSystem.Name", {
        font = "Montserrat",
        size = math.Round(30 * self.Settings.WheelScale),
        weight = 800,
        extended  = true
    })

    surface.CreateFont("Nexus.PingSystem.Info", {
        font = "Montserrat",
        size = math.Round(26 * self.Settings.WheelScale),
        extended  = true
    })

    self.Radius = 325 * self.Settings.WheelScale

    self.Center = {
        X = ScrW() / 2,
        Y = ScrH() / 2
    }

    self.SectionsTbl = {}

    self.CircleColor = Color(0, 0, 0, 0)
    self:SetAlpha(0)
    self:AlphaTo(255, 0.2)

    --self:SetCursor("blank")
    self:MakePopup()
    self:SetKeyboardInputEnabled(false)

    local lastClick = 0

    hook.Add("Nexus.PingSystem.RightClick", self, function(self)
        if (!self.selectedArea and self.HasMovedSlightly) then return end

        local CT = CurTime()
        if lastClick > CT then return end
        lastClick = CT + 0.2

        self:Close()
    end)

    hook.Add("Nexus.PingSystem.LeftClick", self, function(self)
        if (!self.selectedArea) then return end

        local CT = CurTime()
        if lastClick > CT then return end
        lastClick = CT + 0.2

        self:Select(self.selectedArea, self.HasMovedSlightly)
    end)
end

function PANEL:Select(id)
    if (self.FadingOut) then return end

    local tbl = self.SectionsTbl[id + 1]
    if tbl then
        if IsValid(self.SelectedPlayer) and self.SelectedPlayer:GetPos():Distance(LocalPlayer():GetPos()) > PIS.Config.MaxInteractDistance then
            if rp and rp.scoreboard then
                rp.scoreboard.funcs.ErrorSound()
            elseif Incredible_DsLogs then
                Incredible_DsLogs.ErrorSound()
            else
                surface.PlaySound("buttons/button10.wav")
            end

            chat.AddText(Color(40, 149, 220), "[#] ", color_white, translates.Get("Игрок слишком далеко!"))
            self:Close()
            return
        end

        if tbl.access then
            if tbl.access(LocalPlayer(), self.SelectedPlayer) then
                if tbl.func then
                    if tbl.func(self.SelectedPlayer, self) == false then
                        surface.PlaySound(soundSelect)
                        return
                    end
                end
            else
                if rp and rp.scoreboard then
                    rp.scoreboard.funcs.ErrorSound()
                elseif Incredible_DsLogs then
                    Incredible_DsLogs.ErrorSound()
                else
                    surface.PlaySound("buttons/button10.wav")
                end
                self:Close()
                return
            end
        else
            if tbl.func then
                if tbl.func(self.SelectedPlayer, self) == false then
                    surface.PlaySound(soundSelect)
                    return
                end
            end
        end
    end

    surface.PlaySound(soundSelect)
    self:Close()
end

function PANEL:AddSection(name, mat, col, func, access, id)
    table.insert(self.SectionsTbl, {
        ["name"] = name,
        ["mat"] = mat,
        ["col"] = col,
        ["func"] = func,
        ["access"] = access,
        ["id"] = id
    })
end

function PANEL:Think()
    --if IsValid(self.SelectedPlayer) and self.SelectedPlayer:IsPlayer() and self.SelectedPlayer:IsInDeathMechanics() then
    --  self:Remove()
    --  return
    --end

    if LocalPlayer():GetEmoteAction() == 'dm_heal' then
        self:Remove()
    end


    if input.IsMouseDown(MOUSE_RIGHT) or (self.KeyCode and not input.IsKeyDown(self.KeyCode)) then
        self:Close()
        PIS.BlockUseDelay = CurTime() + 0.25
        return
    end
end

function PANEL:Close()
    if (self.FadingOut) then return end

    self.FadingOut = true
    self:AlphaTo(0, 0.2, nil, function()
        self:Remove()
    end)
end

function PANEL:Paint(w, h)
    local rad = self.Radius * 0.4
    local settings = PIS:GetSettings(LocalPlayer())

    if (settings.WheelBlur == 1) then
        _draw:Call("MaskInclude", function()
            _draw:Call("Arc", self.Center.X, self.Center.Y, self.Radius, rad, 0, 360, 1, Color(0, 0, 0, 150))
        end, function()
            _draw:Call("Blur", self, 6, 4)

            draw.NoTexture()
            _draw:Call("Circle", self.Center.X, self.Center.Y, self.Radius, 90, Color(0, 0, 0, 150))
        end)
    else
        _draw:Call("Arc", self.Center.X, self.Center.Y, self.Radius, rad, 0, 360, 1, Color(0, 0, 0, 245))
    end

    _draw:Call("Arc", self.Center.X, self.Center.Y, self.Radius - rad, 3, 0, 360, 1, Color(188, 188, 188))

    -- Found somewhere else, don't remember where but it's a workshop addon
    local cursorAng = 180 - (
        math.deg(
            math.atan2(
                gui.MouseX() - self.Center.X, 
                gui.MouseY() - self.Center.Y
            )
        )
    )

    if not self.Sections then return end

    if (self.HasMovedSlightly) then
        _draw:Call("Circle", self.Center.X, self.Center.Y, self.Radius - rad - 3, 90, self.CircleColor)
        local sectionSize = 360 / self.Sections
        
        local selectedArea = math.abs(cursorAng + sectionSize / 2) / sectionSize
        selectedArea = math.floor(selectedArea)
        if (selectedArea >= self.Sections) then
            selectedArea = 0
        end

        if (self.selectedArea != selectedArea) then
            if (#self.SectionsTbl > 0) then
                surface.PlaySound(soundHover)
            end

            self.selectedTbl = self.SectionsTbl[selectedArea + 1]

            self:InvalidateLayout()
        end
        self.selectedArea = selectedArea
        local selectedAng = selectedArea * sectionSize
        local outerArcScale = math.Round(4 * self.Settings.WheelScale)
        _draw:Call("Arc", self.Center.X, self.Center.Y, self.Radius + outerArcScale, outerArcScale, 90 - selectedAng - sectionSize / 2, 90 - selectedAng + sectionSize / 2, 1, color_white)
        _draw:Call("Arc", self.Center.X, self.Center.Y, self.Radius, rad, 90 - selectedAng - sectionSize / 2, 90 - selectedAng + sectionSize / 2, 1, Color(0, 0, 0, 180))

        local innerArcScale = math.Round(6 * self.Settings.WheelScale)
        _draw:Call("Arc", self.Center.X, self.Center.Y, self.Radius - rad + innerArcScale * 2, innerArcScale, -cursorAng - 21 + 90 - 0, -cursorAng + 90 + 21, 1, color_white)

        if (self.selectedTbl) then
            _draw:Call("ShadowText", isfunction(self.selectedTbl.name) and self.selectedTbl.name(self.SelectedPlayer) or self.selectedTbl.name, "Nexus.PingSystem.Name", w / 2, h / 2 - 24, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)

            local str = translates.Get("Отменить")
            surface.SetFont("Nexus.PingSystem.Info")
            local tw, th = surface.GetTextSize(str)

            local iconSize = th
            local x = w / 2 - iconSize / 2 - tw / 2 - 4
            local y = h / 2 + (56 * self.Settings.WheelScale) + th / 2
            surface.SetDrawColor(color_white)
            surface.SetMaterial(rightClick)
            surface.DrawTexturedRect(x, y, iconSize, iconSize)



            _draw:Call("ShadowText", str, "Nexus.PingSystem.Info", x + iconSize + 8, y + 1, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)

            local str = translates.Get("Выбрать")
            surface.SetFont("Nexus.PingSystem.Info")
            local tw, th = surface.GetTextSize(str)
            local x = w / 2 - iconSize / 2 - tw / 2 - 4
            local y = h / 2 + 20 + th / 2

            surface.SetDrawColor(color_white)
            surface.SetMaterial(leftClick)
            surface.DrawTexturedRect(x, y, iconSize, iconSize)

            _draw:Call("ShadowText", str, "Nexus.PingSystem.Info", x + iconSize + 8, y + 1, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
        end
    else    
        local xDist = math.abs(self.Center.X - gui.MouseX())
        local yDist = math.abs(self.Center.Y - gui.MouseY())
        -- Euclidean distance
        local dist = math.sqrt(xDist ^ 2 + yDist ^ 2)
        if (dist > 20) then
            self.HasMovedSlightly = true
            self:Anim():Call("AnimateColor", self, "CircleColor", Color(0, 0, 0, 200))
        end

        local str = translates.Get("Отменить")
            surface.SetFont("Nexus.PingSystem.Info")
            local tw, th = surface.GetTextSize(str)
            local iconSize = th
            local x = w / 2 - iconSize / 2 - tw / 2 - 4
            local y = h / 2 - th / 2

            surface.SetDrawColor(color_white)
            surface.SetMaterial(rightClick)
            surface.DrawTexturedRect(x, y, iconSize, iconSize)

            _draw:Call("ShadowText", str, "Nexus.PingSystem.Info", x + iconSize + 8, y + 1, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)

            if self.SelectedPlayer then
                _draw:Call("ShadowText", translates.Get("Взаимодействие с %s", (self.SelectedPlayer:IsPlayer() and self.SelectedPlayer:Nick() or self.SelectedPlayer.Name or self.SelectedPlayer.PrintName or 'обьектом')), "Nexus.PingSystem.Info", w/2, y + 1 + th, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
            end
    end

    local sectionSize = 360 / self.Sections
    for i, v in pairs(self.SectionsTbl) do
        if (ispanel(v)) then continue end
        
        local ang = (i - 1) * sectionSize
        ang = math.rad(ang)
        local size = (56 * self.Settings.WheelScale)
        if (self.selectedArea and self.selectedArea + 1 == i) then
            size = (72 * self.Settings.WheelScale)
        end
        local r = self.Radius - rad / 2
        local sin = math.sin(ang) * r
        local cos = math.cos(ang) * r
        local x = self.Center.X - size / 2 + sin
        local y = self.Center.Y - size / 2 - cos
        
        local mat = v.mat
        if isfunction(mat) then
            mat = mat(LocalPlayer(), self.SelectedPlayer)
        end 

        if mat then
            surface.SetMaterial(mat)
            surface.SetDrawColor(v.col or color_white)
            surface.DrawTexturedRect(x, y, size, size)
        end
    end
end

vgui.Register("PIS.Radial", PANEL)

local function IsInDeathMechanic(ply)
    --return table.HasValue(DeathMechanicsPublic, player.GetBySteamID(ply:SteamID()))
    return DeathMechanicsPublic and DeathMechanicsPublic[ply:SteamID()] or false
end

function PIS:OpenRadialMenu(keycode, target, custom_btns)
    --if IsValid(target) and IsInDeathMechanic(target) then return end
    
    local frame = panels:Call("Create", "PIS.Radial")
    frame:SetSize(ScrW(), ScrH())
    frame:SetPos(0, 0)
    frame.SelectedPlayer = target
    if custom_btns then
        frame:SetCustomContents(custom_btns)
    else
        frame:SetContents()
    end
    frame.KeyCode = keycode
end

local function canOpenMenu()
    if IsValid(CHATBOX) and CHATBOX._Open then 
        return false
    end
    
    if IsValid(vgui.GetHoveredPanel()) then 
        return false
    end
    
    if rpSupervisor and rpSupervisor.ID > 0 then 
        return false
    end
    
    return true
end

canOpenInteractMenu = canOpenMenu

local IsMouseDown, whiteCol = input.IsMouseDown, Color(255, 255, 255)

hook.Add("ItemShowEntityMenu", "RpItemsCircleMenu", function(ent)
    local LocalPlayer = LocalPlayer()

    if LocalPlayer:GetActiveWeapon():GetClass() == "weapon_physgun" and input.IsMouseDown(MOUSE_LEFT) then return end

    if not canOpenMenu() or (LocalPlayer:GetActiveWeapon():GetClass() == "weapon_physgun" and IsMouseDown(MOUSE_LEFT)) then return end

    if not ent.getItemTable then
        rp.makeItem(ent)
    end

    local itemTable = ent:getItemTable()
    if not itemTable then return end

    local funcs = itemTable.functions
    if not funcs then return end

    itemTable.player = LocalPlayer
    itemTable.entity = ent

    local function callback(ent, index)
        if IsValid(ent) and not ent.NoAnimatons then
            ent:ResetSequence("close")
        end

        LocalPlayer.usedEntity = ent
        netstream.Start("invAct", index, ent)
    end

    local customContents = {}

    for index, f in SortedPairs(funcs) do
        --if not f.InteractMaterial then continue end
        if index == "combine" or (f.onCanRun and f.onCanRun(itemTable) == false) then continue end

        local AltTable
        if f.onClientRun then
            AltTable = table.Copy(itemTable)
            AltTable.player = LocalPlayer
        end

        table.insert(customContents, {
            text = f.name,
            material = Material((f.InteractMaterial or "error"), "smooth", "noclamp"),
            color = f.InteractColor or whiteCol,
            func = function()
                if AltTable then
                    f.onClientRun(AltTable)
                end

                if f.sound then
                    if IsValid(ent) and ent:GetPos():DistToSqr(LocalPlayer:GetPos() or Vector(0, 0, 0)) <= 9216 then
                        surface.PlaySound(f.sound)
                    end
                end

                callback(ent, index)
            end,
            access = function()
                return not f.onCanRun or f.onCanRun(itemTable) ~= false
            end
        })
    end

    local acessed
    local access_count = 0
    for k, v in pairs(customContents) do
        if v.access() then
            access_count = access_count + 1
            acessed = v
        end
    end
	
    if access_count < 1 then
        return
    elseif access_count < 2 then
        acessed.func()
        return
    end
    
    local frame = panels:Call("Create", "PIS.Radial")
    frame:SetSize(ScrW(), ScrH())
    frame:SetPos(0, 0)
    --ent.Name = ent.Name or itemTable.name
    --frame.SelectedPlayer = ent
    frame.KeyCode = KEY_E
    frame:SetCustomContents(customContents)
end)

hook.Add("HUDPaint", "InteractMenu_Switcher", function()
    local LocalPlayer = LocalPlayer()
    if LocalPlayer:IsTyping() then return end
    
    local code = KEY_E
    local target = LocalPlayer:GetEyeTrace().Entity

    if input.IsKeyDown(code) and canOpenMenu() then
        if (PIS.BlockUseDelay or 0) > CurTime() then return end
        --if IsInDeathMechanic(LocalPlayer) and (target:IsPlayer() and IsInDeathMechanic(target)) then return end
        
        if (!IsValid(focus) and !IsValid(PIS.RadialMenu)) then
            local valid = IsValid(target)
            if not valid then return end

            local isply = target:IsPlayer()
            if not isply then
                if target:IsWorld() then
                    if table.Count(PIS.Config.WorldInteractButtons) < 1 then return end
                    PIS:OpenRadialMenu(code)
                else
                    local result = hook.Run("IntractMenu", target)
                    
					--print(result)
					
					if not result and PIS.Config.EntityIteractButtons and PIS.Config.EntityIteractButtons[target:GetClass()] and target:GetPos():Distance(LocalPlayer:GetPos()) < PIS.Config.MaxInteractDistance then 
						PIS:OpenRadialMenu(code, target)
					end
                end

                return
            end

            if IsValid(LocalPlayer:GetActiveWeapon()) and LocalPlayer:GetActiveWeapon():GetClass() == "weapon_physgun" and input.IsMouseDown(MOUSE_LEFT) then return end

            --if isply and target:IsInDeathMechanics() then

            --elseif isply and target:IsHandcuffed() then
            --  PIS:OpenRadialMenu(code, target, PIS.Config.HandCussfedBtns)
            --elseif target:IsWorld() then
            if LocalPlayer:GetEmoteAction() == 'dm_heal' then

            elseif target:IsInDeathMechanics() and not LocalPlayer:IsHandcuffed() and target:IsHandcuffed() then

            elseif isply and target:GetPos():Distance(LocalPlayer:GetPos()) < PIS.Config.MaxInteractDistance and (not target:IsInDeathMechanics() or (not LocalPlayer:IsHandcuffed() and IsValid(LocalPlayer:GetWeapon("weapon_cuff_elastic")))) then
                PIS:OpenRadialMenu(code, target)
            else
                PIS.BlockUseDelay = CurTime() + 0.25
            end
        end
    end
end)

hook.Add("VGUIMousePressed", "PIS.PressMouse", function(pnl, code)
    if IsValid(PIS.RadialMenu) and pnl == PIS.RadialMenu then
        if code == MOUSE_LEFT then
            hook.Run("Nexus.PingSystem.LeftClick")
        elseif code == MOUSE_RIGHT then
            hook.Run("Nexus.PingSystem.RightClick")
        end
    end
end)


hook.Add("CreateMove", "PIS.CircleMenu", function()

    if IsValid(PIS.RadialMenu) then
        local leftClick = input.WasMouseReleased(MOUSE_LEFT)
        local rightClick = input.WasMouseReleased(MOUSE_RIGHT)

        if leftClick then
            hook.Run("Nexus.PingSystem.LeftClick")
        end
        if rightClick then
            hook.Run("Nexus.PingSystem.RightClick")
        end
    end
end)
