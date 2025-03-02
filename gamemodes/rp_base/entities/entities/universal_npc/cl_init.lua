include("shared.lua")

ENT.RenderGroup = RENDERGROUP_BOTH

function ENT:Draw()
    self:DrawModel()
end

local frame
net.Receive("universal_npc", function()
    if IsValid(frame) then
        frame:Remove()
    end

    local ent = ents.GetByIndex( net.ReadUInt(32) )
    local LocalPlayer = LocalPlayer()

    frame = _NexusPanelsFramework:Call("Create", "PIS.Radial")
    frame:SetSize(ScrW(), ScrH())
    frame:SetPos(0, 0)
    frame.SelectedPlayer = ent
    frame.KeyCode = KEY_E
    frame:SetCustomContents({
        {
            text = translates.Get("Торговать"),
            material = Material("ping_system/u_trade.png"),
            color = Color(255, 255, 255),
            func = function(ply, pnl)
                rp.OpenVendorNpcMenu(ent)
            end,
            access = function() return isstring(ent:GetObject().Vendor) end
        },
        {
            text = translates.Get("Сменить работу"),
            material = Material("ping_system/u_job.png"),
            color = Color(255, 255, 255),
            func = function(ply, pnl)
                local f       = ent:GetObject().EmployerFaction
                local faction = rp.Factions[f];

                if (rpui and rpui.EnableUIRedesign or rpui.DebugMode) and faction.teammates and not rp.cfg.ForceFaction then
                    rp.OpenEmployerMenu({f, unpack(faction.teammates)}, f);
                else
                    rp.OpenEmployerMenu(f, nil, rp.cfg.ForceFaction);
                end
            end,
            access = function() return isnumber(ent:GetObject().EmployerFaction) end
        },
        {
            text = translates.Get("Переехать"),
            material = Material("ping_system/u_cspawn.png"),
            color = Color(255, 255, 255),
            func = function(ply, pnl)
                rp.SelectSpawn(ent:GetObject().Spawnpoint)
            end,
            access = function() return isnumber(ent:GetObject().Spawnpoint) end
        },
    })
end)


local _txt = (translates and translates.Get("[E] Поговорить")) or "[E] Поговорить"

local color_green, color_white, maxDist = Color(127, 255, 127, 255), Color(245, 245, 245), 800^2
function ENT:DrawTranslucent()
    local obb = self:OBBMaxs()
    local pos = (self:LookupBone("ValveBiped.Bip01_Head1") and self:GetBonePosition(self:LookupBone("ValveBiped.Bip01_Head1")) or IsValid(self) and self:GetPos() + Vector(0, 0, 64) or Vector(0, 0, 0)) + Vector(0, 0, 16)
    if LocalPlayer():GetPos():DistToSqr(pos) > maxDist then return end

    local ang = LocalPlayer():EyeAngles()
    ang:RotateAroundAxis(ang:Forward(), 90)
    ang:RotateAroundAxis(ang:Right(), 90)
    cam.Start3D2D(pos, Angle(0, ang.y, 90), 0.1)
        local _, tall = draw.SimpleText(self:GetObject().Name, "VendorNpc_Name", 0, 0, color_white, TEXT_ALIGN_CENTER)
        draw.SimpleText(_txt, "VendorNpc_Text", 0, tall, color_green, TEXT_ALIGN_CENTER)
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