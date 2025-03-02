local adminMenu
local ent

oldMaterial = oldMaterial or Material
local function Material(path, ...)
    return oldMaterial(path, "smooth", "noclamp", ...)
end

local return_to
local adminOptions, doorOptions, unowned_menu 
adminOptions  = {
    {
        text = translates.Get('Toggle Ownable') or 'Toggle Ownable',
        func = function()
            rp.RunCommand('setownable')
        end,
        material = Material("ping_system/update_door.png")
    },
    {
        text = translates.Get('Toggle Locked') or 'Toggle Locked',
        func = function()
            rp.RunCommand('setlocked')
        end,
        material = Material("ping_system/update_door.png")
    },
    {
        text = translates.Get('Set Team Own') or 'Set Team Own',
        func = function()
            local m = ui.DermaMenu()

            for k, v in ipairs(rp.teams) do
                m:AddOption(v.name, function()
                    rp.RunCommand('setteamown', k)
                end)
            end

            m:Open()
        end,
        material = Material("ping_system/update_door.png")
    },
    {
        text = translates.Get('Set Group Own') or 'Set Group Own',
        func = function()
            local m = ui.DermaMenu()

            for k, v in pairs(rp.teamDoors) do
                m:AddOption(k, function()
                    rp.RunCommand('setgroupown', k)
                end)
            end

            m:Open()
        end,
        material = Material("ping_system/update_door.png")
    },
    {
        text = translates.Get("Вернуться назад") or "Вернуться назад",
        material = Material("ping_system/cancel.png"),
        color = Color(255, 255, 255),
        func = function(ply, pnl)
            pnl:SetCustomContents(return_to)
            return false
        end,
        access = function()
            return return_to ~= nil
        end
    }
}

doorOptions = {
    {
        text = translates.Get('Продать') or 'Продать',
        func = function()
            rp.RunCommand('selldoor')
            --fr:Close()
        end,
        material = Material("ping_system/sell_item.png"),
    },
    {
        text = translates.Get('Дать ключи') or 'Дать ключи',
        access = function() return (#player.GetAll() > 1) end,
        func = function()
            ui.PlayerReuqest(function(pl)
                rp.RunCommand('addcoowner', pl:SteamID())
            end)
        end,
        material = Material("ping_system/give_permison_door.png"),
    },
    {
        text = translates.Get('Забрать ключи') or 'Забрать ключи',
        access = function() return (ent:DoorGetCoOwners() ~= nil) and (#ent:DoorGetCoOwners() > 0) end,
        func = function()
            ui.PlayerReuqest(ent:DoorGetCoOwners(), function(pl)
                rp.RunCommand('removecoowner', pl:SteamID())
            end)
        end,
        material = Material("ping_system/give_permison_door.png"),
    },
    {
        text = translates.Get('Улучшить') or 'Улучшить',
        access = function(self, ent) 
            ent.Name = (translates.Get("Улучшить") or 'Улучшить') .. ' (' .. (LocalPlayer():Wealth(rp.cfg.DoorCostMin, rp.cfg.DoorCostMax) * 2) .. ')'
            return not ent:DoorIsUpgraded() and not ent:IsVehicle() and not string.find(string.lower(ent:GetClass()), "vehicle") 
        end,
        func = function()
            rp.RunCommand('doorgrade')
        end,
        material = Material("ping_system/update_door.png"),
    },
    {
        text = translates.Get('Дать ключи Организации') or 'Дать ключи Организации',
        access = function() return (#player.GetAll() > 1) and (LocalPlayer():GetOrg() ~= nil) end,
        func = function()
            rp.RunCommand('orgown')
        end,
        material = Material("ping_system/give_permison_door.png"),
    },
    {
        text = translates.Get('Надпись') or 'Надпись',
        func = function()
            ui.StringRequest(translates.Get('Надпись') or 'Надпись', translates.Get('Напишите текст который будет на двери') or 'Напишите текст который будет на двери', '', function(a)
                rp.RunCommand('settitle', tostring(a))
            end)
        end,
        material = Material("ping_system/change_door_name.png"),
    },
    {
        text = translates.Get('Admin options') or 'Admin options',
        access = function() return ba.IsSuperAdmin(LocalPlayer()) end,
        func = function(self, pnl)
            return_to = doorOptions
            pnl:SetCustomContents(adminOptions)
            return false
        end,
        material = Material("ping_system/cfgorg.png"),
    },
}

unowned_menu = {
    {
        text = translates.Get('Арендовать') or 'Арендовать',
        material = Material("ping_system/give_money.png"),
        func = function()
            rp.RunCommand('buydoor')
        end
    },
    {
        text = translates.Get("Постучать") or "Постучать",
        material = Material("ping_system/punch_door.png"),
        func = function()
            net.Start("DoorsKnock")
            net.SendToServer()
        end
    },
    {
        text = translates.Get("Взломать") or "Взломать",
        material = Material("ping_system/lock_picking_door.png"),
        --color = Color(255, 255, 255),
        func = function(ply, pnl)
            local swep = LocalPlayer():GetWeapon("lockpick")
            if not IsValid(swep) then return end
            PIS.BlockUseDelay = CurTime() + 0.75

            input.SelectWeapon(swep)
            
            timer.Simple(0.15, function()
                if LocalPlayer():GetActiveWeapon():GetClass() ~= "lockpick" then return end
                net.Start("DoPrimaryAttack")
                net.SendToServer()
                LocalPlayer():GetActiveWeapon():PrimaryAttack()
            end)
        end,
        access = function()
            return IsValid( LocalPlayer():GetWeapon("lockpick") )
        end
    },
    {
        text = translates.Get('Admin options') or 'Admin options',
        access = function() return ba.IsSuperAdmin(LocalPlayer()) end,
        func = function(self, pnl)
            return_to = unowned_menu
            pnl:SetCustomContents(adminOptions)
            return false
        end,
        material = Material("ping_system/cfgorg.png"),
    },
}

local owned_someone_else = {
    {
        text = translates.Get("Постучать") or "Постучать",
        material = Material("ping_system/punch_door.png"),
        func = function()
            net.Start("DoorsKnock")
            net.SendToServer()
        end
    }
}

local frame
local function keysMenu(bool, bool2)
    if IsValid(frame) then
        frame:Remove()
    end

    local LocalPlayer = LocalPlayer()

    if not canOpenInteractMenu() then return end

    ent = LocalPlayer:GetEyeTrace().Entity
    local self_pos = LocalPlayer:GetPos()
    if not IsValid(ent) or not ent:IsDoor() or ent:GetPos():DistToSqr(self_pos) > 13225 then return end

    local interactcircle_content

    if ent:DoorOwnedBy(LocalPlayer) then
        interactcircle_content = doorOptions
    elseif ent:DoorIsOwnable() then
        interactcircle_content = unowned_menu
    elseif ba.IsSuperAdmin(LocalPlayer) and not ent:DoorIsOwnable() then
        interactcircle_content = adminOptions
    else
        interactcircle_content = owned_someone_else
    end

    if not interactcircle_content or #interactcircle_content < 1 then return end

    frame = _NexusPanelsFramework:Call("Create", "PIS.Radial")
    frame:SetSize(ScrW(), ScrH())
    frame:SetPos(0, 0)
    frame.SelectedPlayer = ent
    frame.KeyCode = bool2 and KEY_R or (bool and KEY_E or KEY_F2)
    frame:SetCustomContents(interactcircle_content)
end

net('rp.keysMenu', function()
    keysMenu(true, true)
end)
GM.ShowTeam = function() end

local processing, processingTime, disableprocessing
hook.Add("CreateMove", "rp.Doors::CreateMove.KeyHandler", function(cmd)
    if IsValid(frame) then cmd:ClearButtons(IN_USE) return end

    if input.WasKeyPressed(KEY_F2) then keysMenu(); end

    if input.IsKeyDown(KEY_E) then
        if IsValid(LocalPlayer():GetActiveWeapon()) and LocalPlayer():GetActiveWeapon():GetClass() == "weapon_physgun" and input.IsMouseDown(MOUSE_LEFT) then return end
        local ent = LocalPlayer():GetEyeTrace().Entity
        if not IsValid(ent) or not ent:IsDoor() then return end

        if disableprocessing then return end

        if processing then cmd:ClearButtons(IN_USE) return end
        processing = true
        processingTime = CurTime() + 0.25
        cmd:ClearButtons(IN_USE)

        hook.Add("CreateMove", "rp.Doors.Use", function(cmd2)
            if input.IsKeyDown(KEY_E) then
                if CurTime() >= processingTime then
                    keysMenu(true)
                    hook.Remove("CreateMove", "rp.Doors.Use")
                    processing, processingTime = nil, nil
                    cmd2:ClearButtons(IN_USE)
                else
                    cmd2:ClearButtons(IN_USE)
                end
            else
                hook.Remove("CreateMove", "rp.Doors.Use")
                disableprocessing = true

                if CurTime() < processingTime then
                    hook.Add("StartCommand", "SimulateIN_USE", function(ply, ucmd)
                        ucmd:SetButtons(IN_USE)
                    end)
                    timer.Simple(0, function()
                        hook.Remove("StartCommand", "SimulateIN_USE")
                    end)
                end

                timer.Simple(0.1, function()
                    processing, processingTime, disableprocessing = nil, nil, nil
                end)
            end
        end)
    else
    end
end)