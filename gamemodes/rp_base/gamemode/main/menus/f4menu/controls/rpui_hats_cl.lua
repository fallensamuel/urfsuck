-- "gamemodes\\rp_base\\gamemode\\main\\menus\\f4menu\\controls\\rpui_hats_cl.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local PANEL = {}

local Vector_, Angle_, GetConVarString_ = Vector, Angle, GetConVarString
local LocalPlayer, string_Comma = LocalPlayer, string.Comma

function PANEL:Init()
    self.active_hats = LocalPlayer():GetNetVar("HatData", {}) or {}
    self.ThisData = {}

    self:SetModel(LocalPlayer():GetModel())
    self.Entity.GetPlayerColor = function() return Vector_(GetConVarString_("cl_playercolor")) end
    self:SetFOV(55)
    self:SetDirectionalLight(BOX_RIGHT, Color(255, 160, 80, 255))
    self:SetDirectionalLight(BOX_LEFT, Color(80, 160, 255, 255))
    self:SetAmbientLight(Vector_(-64, -64, -64))
    self:SetAnimated(true)
    self.Angles = Angle_(0, 0, 0)

    if LocalPlayer():GetHat() then
        self:RenderHat(LocalPlayer():GetHat())
    end

    self.SwepWMdl = ClientsideModel("models/hunter/blocks/cube025x025x025.mdl")

    self.button = vgui.Create("DButton", self)
    self.button:SetZPos(99)
    self.button:SetFont("rpui.Fonts.Hats.CategoryTitle")
    self.button:SetTextColor(color_white)
    self.button:SetText(translates.Get("Купить"))
    --self.button:SetPos(self:GetWide()/2 - self.button:GetWide()/2, self:GetTall() - self.button:GetTall())
    --self.button:SetVisible(LocalPlayer():GetHat() and true or false)
    self.button:SizeToContents()
    local btn_tall = self.button:GetTall()*1.25
    self.button:SetTall(btn_tall)
    --self.button:Dock(BOTTOM)
    self.button:SetSize(self.button:GetWide()*0.975, self.button:GetTall())
    self.button:SetPos(self.button:GetWide()*0.025, self:GetTall() - self.button:GetTall())


    surface.CreateFont("rpui.Fonts.Hats.Buy1", {
        font = "Montserrat",
        extended = true,
        weight = 535,
        size = btn_tall*0.65
    })
    surface.CreateFont("rpui.Fonts.Hats.Buy2", {
        font = "Montserrat",
        extended = true,
        weight = 500,
        size = btn_tall*0.325
    })


    self.button.Paint = function(this, w, h)
        --if not self.HatMdl then return end
        if IsValid(this.currency_select) then return end
        --if this:GetText() == "" then return end

        local baseColor = rpui.GetPaintStyle(this, STYLE_SOLID)
        surface.SetDrawColor(baseColor)
        surface.DrawRect(0, 0, w, h)
        this:SetTextColor(this:IsHovered() and rpui.UIColors.Black or rpui.UIColors.White)
    end
    self.button.Think = function(this)
        local ishat = self.RenderMode == "hat"
        if (not ishat or not self.HatMdl) and not self.ActiveRenderSWEP then return end

        local preview = ishat and self.HatMdl or self.ActiveRenderSWEP.index
        local active = ishat and LocalPlayer():GetHat() or LocalPlayer():GetCustomToolgun()
        local owned = ishat and (self.active_hats or {}) or (ply:GetNetVar("ToolgunData") or {})

        local hashat = ishat and table.HasValue(owned, preview) or owned[preview]

        if hashat and preview == active then
            if IsValid(this.currency_select) then this.currency_select:Remove() end
            this:SetText(translates.Get("Снять"))
        elseif hashat then
            if IsValid(this.currency_select) then this.currency_select:Remove() end
            this:SetText(translates.Get("Надеть"))
        elseif preview then
            --local money, price = LocalPlayer():GetMoney(), self.ThisData.price
            --if money > price then
                this:SetText(translates.Get("Купить"))
                if IsValid(this.currency_select) then
                    if this.currency_select.hat_parent ~= self.HatMdl then
                        this.currency_select:Remove()
                    else
                        this:SetText("")
                    end
                end
            --else
            --    this:SetText("Не хватает ".. string_Comma(price - money).."$")
            --end
        else
            if IsValid(this.currency_select) then this.currency_select:Remove() end
            this:SetText("")
        end
    end
    self.button.DoClick = function(this)
		if this.NextAction and this.NextAction > CurTime() then
			return
		end
		
		this.NextAction = CurTime() + 0.5
		
        local mdl = self.HatMdl
        local ishat = self.RenderMode == "hat"

        if this:GetText() == translates.Get("Надеть") then
            if ishat then
                rp.RunCommand("sethat", mdl)
                self:RenderHat(mdl)
            else
                rp.RunCommand("setcustomtoolgun", self.ActiveRenderSWEP.class)
            end
			
        elseif this:GetText() == translates.Get("Снять") then
            if ishat then
                rp.RunCommand("removehat")
                timer.Simple(0.1, function()
                    self:RenderHat(LocalPlayer():GetHat())
                end)
                self.HatMdl = nil
            else
                rp.RunCommand("removecustomtoolgun")
            end
			
        elseif this:GetText() == translates.Get("Вызвать") then
			net.Start("Pets::Spawn")
				net.WriteUInt(self.previewPet.id, 8)
			net.SendToServer()
			
			self.button:SetText(translates.Get("Отозвать"))
			
        elseif this:GetText() == translates.Get("Отозвать") then
			net.Start("Pets::Despawn")
			net.SendToServer()
			
			self.button:SetText(translates.Get("Вызвать"))
			
        elseif this:GetText() == translates.Get("Купить") or this:GetText() == "" then
            if IsValid(this.currency_select) then this.currency_select:Remove() end

            this.currency_select = vgui.Create("Panel", this)
            this.currency_select:SetSize(this:GetWide(), this:GetTall())
            this.currency_select.hat_parent = self.HatMdl

            local link = this.currency_select

            link.left = vgui.Create("DButton", link)
            link.left:SetSize(link:GetWide()*0.4875, link:GetTall())
            link.left:SetFont("rpui.Fonts.Hats.Buy1")

            link.left.PriceTitle = translates.Get("За деньги")
            link.left.PriceFont = "rpui.Fonts.Hats.Buy2"
            link.left.PriceText = function()
                local money, price = LocalPlayer():GetMoney(), self.ThisData and self.ThisData.price
                if not price then return "N/A" end
                if money >= price then
                    return string_Comma(price).."$"
                else
                    return translates.Get("Не хватает") .. " ".. string_Comma(price - money).."$"
                end
            end

            local BuyBtnPaint = function(thisis, w, h)
                local baseColor = rpui.GetPaintStyle(thisis, STYLE_SOLID)
                local txt_col = thisis:IsHovered() and rpui.UIColors.Black or rpui.UIColors.White

                surface.SetDrawColor(baseColor)
                surface.DrawRect(0, 0, w, h)

                draw.SimpleText(thisis.PriceTitle, thisis:GetFont(), w*0.5, h*0.58, txt_col, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
                draw.SimpleText(thisis.PriceText(), thisis.PriceFont, w*0.5, h*0.58, txt_col, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
            end

            -----------
            local BuyHat = function(donate)
                rp.RunCommand((donate and "buydonatehat" or "buyhat"), mdl)
                self.active_hats = LocalPlayer():GetNetVar("HatData", {})
                --RunConsoleCommand("say", "/buyhat "..mdl)

                local refresh = function()
                    if IsValid(self) then
                        self.active_hats = LocalPlayer():GetNetVar("HatData", {})
                    end
                end
                timer.Simple(0.1, refresh)
                timer.Simple(0.5, refresh) -- when networking lags

                if IsValid(this.currency_select) then
                    this.currency_select:Remove()
                end
            end

            local BuySwep = function(isdonate)
                if not self.ThisData or not self.ThisData.class then return end
                local cmd = donate and "buycustomtoolgundonate" or "buycustomtoolgun"
                rp.RunCommand(cmd, self.ThisData.class)

                if IsValid(this.currency_select) then
                    this.currency_select:Remove()
                end
            end
            --------

            link.left:SetTextColor(color_white)
            link.left:SetText("")
            link.left.Paint = BuyBtnPaint

            link.left.DoClick = function()
                if self.RenderMode == "hat" then
                    BuyHat()
                elseif self.RenderMode == "swep" then
                    BuySwep()
                end
            end

            local donateOnly
            if not self.ThisData.donatePrice then
                link.left:SetSize(link:GetWide(), link:GetTall())
                return
            elseif not self.ThisData.price then
                donateOnly = true
                link.left:Remove()
            end

            if self.ThisData and self.ThisData.donatePrice then
                link.right = vgui.Create("DButton", link)
                if donateOnly then
                    link.right:SetSize(link:GetWide(), link:GetTall())
                else
                    link.right:SetSize(link:GetWide()*0.4875, link:GetTall())
                    link.right:SetPos(link:GetWide()*0.5125, 0)
                end
                link.right:SetFont("rpui.Fonts.Hats.Buy1")
                link.right:SetTextColor(color_white)
                link.right:SetText("")

                link.right.PriceTitle = translates.Get("За донат")
                link.right.PriceFont = "rpui.Fonts.Hats.Buy2"
                link.right.PriceText = function()
                    local money, price = LocalPlayer():GetCredits(), self.ThisData and self.ThisData.donatePrice
                    if not price then return "N/A" end
                    if money >= price then
                        return string_Comma(price).."₽"
                    else
                        return translates.Get("Не хватает") .. " ".. string_Comma(price - money).."₽"
                    end
                end

                link.right.Paint = BuyBtnPaint

                link.right.DoClick = function()
                    if self.RenderMode == "hat" then
                        BuyHat(true)
                    elseif self.RenderMode == "swep" then
                        BuySwep(true)
                    end
                end
            end
        end
    end
end

function PANEL:SizeRebuild()
    --self.button:SetPos(self:GetWide()/2 - self.button:GetWide()/2, self:GetTall() - self.button:GetTall())
    self.button:SizeToContents()
    local btn_tall = self.button:GetTall()*1.25
    --self.button:Dock(BOTTOM)
    self.button:SetSize(self:GetWide()*0.975, btn_tall)
    self.button:SetPos(self.button:GetWide()*0.025, self:GetTall() - btn_tall)
end

local color_warn, material_warn = Color(255,200,0), Material("rpui/notify/1.png", "smooth");

function PANEL:Paint(w, h)
    if not IsValid(self.Entity) then return end
    local x, y = self:LocalToScreen(0, 0)
    self:LayoutEntity(self.Entity)
    local ang = self.aLookAngle

    if not ang then
        ang = (self.vLookatPos - self.vCamPos):Angle()
    end

    cam.Start3D(self.vCamPos, ang, self.fFOV, x, y, w, h, 5, self.FarZ)
        render.SuppressEngineLighting(true)
        render.SetLightingOrigin(self.Entity:GetPos())
        render.ResetModelLighting(self.colAmbientLight.r / 255, self.colAmbientLight.g / 255, self.colAmbientLight.b / 255)
        render.SetColorModulation(self.colColor.r / 255, self.colColor.g / 255, self.colColor.b / 255)
        render.SetBlend((self:GetAlpha() / 255) * (self.colColor.a / 255))

        for i = 0, 6 do
            local col = self.DirectionalLight[i]

            if (col) then
                render.SetModelLighting(i, col.r / 255, col.g / 255, col.b / 255)
            end
        end

        self:DrawModel()
        self:DrawOtherModels()

        render.SuppressEngineLighting(false)
    cam.End3D()

    if (self.RenderMode == "hat") and self.HatMdl then
        local cfg = rp.hats.list[self.HatMdl];

        if cfg and cfg.can_wear and (not cfg.can_wear(LocalPlayer())) then
            local th, th = draw.SimpleTextOutlined( translates.Get("Шапка отключена на данной профессии"), "rpui.Fonts.Hats.HatPrint_Warn", w * 0.5, h * 0.9, color_warn, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, 2, color_black );
            local s = h * 0.035;
        
            surface.SetDrawColor( color_warn );
            surface.SetMaterial( material_warn );
            surface.DrawTexturedRect( w * 0.5 - s * 0.5, h * 0.9 - th - s, s, s );
        end
    end

    self.LastPaint = RealTime()
end

function PANEL:DrawOtherModels()
    if self.RenderMode == "hat" and self.HatMdl then
        rp.hats.Render(self.Entity, self.HatMdl)
    else
        self:DoRenderSWEP(self.Entity)
    end
end

function PANEL:OnRemove()
    if IsValid(self.Entity) then
        self.Entity:Remove()
    end

    if IsValid(self.SwepWMdl) then
        self.SwepWMdl:Remove()
    end
end

local zeroVec, zeroAng = Vector(0, 0, 0), Angle(0, 0, 180)
function PANEL:DoRenderSWEP(ent)--PostDrawModel(ent)
    if not IsValid(ent) then return end

    local sweptab = self.ActiveRenderSWEP
    if not sweptab or not IsValid(self.SwepWMdl) then return end

    local boneid = ent:LookupBone("ValveBiped.Bip01_R_Hand")
    if not boneid then return end

    local matrix = ent:GetBoneMatrix(boneid)
    if not matrix then return end

    self.SwepWMdl:SetModel(sweptab.model)

    local newPos, newAng = LocalToWorld(sweptab.renderVec or zeroVec, sweptab.renderAng or zeroAng, matrix:GetTranslation(), matrix:GetAngles())

    self.SwepWMdl:SetPos(newPos)
    self.SwepWMdl:SetAngles(newAng)
    self.SwepWMdl:SetRenderOrigin(newPos)
    self.SwepWMdl:SetRenderAngles(newAng)
    self.SwepWMdl:SetupBones()
    self.SwepWMdl:DrawModel()
    self.SwepWMdl:SetRenderOrigin()
    self.SwepWMdl:SetRenderAngles()
end

function PANEL:RenderHat(mdl, data)
    --if self.HatMdl == mdl then
    --    self.HatMdl = nil
    --    return
    --end

    self.ThisData = data or {}

    self.OldHatMdl = self.HatMdl

    self.HatMdl = mdl
    if data then
        self.HatData = data
    end

    self.RenderMode = "hat"
end

function PANEL:RenderSWEP(sweptab)
    self.ActiveRenderSWEP = sweptab
    self.ThisData = sweptab or {}
    self.RenderMode = "swep"
    self.HatMdl = nil
end

function PANEL:RenderPet(pettab)
    if pettab then
		self:SetModel(pettab.model)
		self.Entity.GetPlayerColor = function() return Vector_(255, 255, 255, 255) end
		
		if pettab.skin then
			self.Entity:SetSkin(pettab.skin)
		end
		
		self.button:SetText(translates.Get((LocalPlayer():GetPet() == pettab.id) and "Отозвать" or "Вызвать"))
		self.RenderMode = "pet"
		self.previewPet = pettab
		
		if IsValid(self.button.currency_select) then
			self.button.currency_select:Remove()
		end
		
	else
		self:SetModel(LocalPlayer():GetModel())
		self.Entity.GetPlayerColor = function() return Vector_(GetConVarString_("cl_playercolor")) end
	end
end

function PANEL:OnMouseWheeled(dlta)
    local scale = self:GetFOV() / 180
    self.fFOV = math.Clamp(self.fFOV + dlta * -10.0 * scale, 25, 100)

    return true
end

local gui_MousePos = gui.MousePos

function PANEL:DragMousePress()
    self.PressX, self.PressY = gui_MousePos()
    self.Pressed = true
end

function PANEL:DragMouseRelease()
    self.Pressed = false
end

function PANEL:LayoutEntity(ent)
    if self.bAnimated then
        self:RunAnimation()
    end

    if self.Pressed then
        local mx, my = gui_MousePos()
        self.Angles = self.Angles - Angle_(0, ((self.PressX or mx) - mx) / 2, 0)
        self.PressX, self.PressY = gui_MousePos()
    end

    ent:SetAngles(self.Angles)
end

vgui.Register("rpui.HatsMenu.Mdl", PANEL, "DModelPanel")

--————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————

local PANEL = {}

function PANEL:Init()
    self.Parent = self:GetParent()
    self.frameW, self.frameH = self.Parent:GetSize()
    --self.ContentHeight = self.frameH * 0.065
    --self:Dock(FILL)

    timer.Simple(0, function()
        self:OnInit()
    end)
end

function PANEL:OnInit()
    self.frameW, self.frameH = self.Parent:GetSize()
    self.ContentSpacing = self.frameH * 0.01
    self.ContentHeight = self.frameH * 0.065

    self:RebuildFonts(self.frameW, self.frameH)

    local wide, tall = self:GetWide() * 0.5,  self:GetTall()
    self.shop = vgui.Create("rpui.ScrollPanel", self)
    self.shop:SetSize(wide, tall)
    self.shop:SetSpacingY(self.ContentSpacing)

    self.preview = vgui.Create("rpui.HatsMenu.Mdl", self)
    self.preview:SetSize(wide, tall)
    self.preview:SetPos(wide, 0)
    self.preview:SizeRebuild()

    self:InitHats()
end

function PANEL:InitHats()
    self.active_hats = LocalPlayer():GetNetVar("HatData") or {};
	
	local my_pets = rp.pets.GetMy()
	
    if #my_pets > 0 then
        self.ContainerPets = vgui.Create( "rpui._shopcategory" );
        self.ContainerPets.Dock( self.ContainerPets, TOP );
        self.ContainerPets.Title.SetFont( self.ContainerPets.Title, "rpui.Fonts.ShopList.CategoryTitle" );
        self.ContainerPets.Title.SetText( self.ContainerPets.Title, translates.Get("ПИТОМЦЫ") );
        self.ContainerPets.SetContentHeight( self.ContainerPets, self.ContentHeight );
        for k, tbl in pairs(my_pets) do
            if not istable(tbl) then continue end
            self:CreatePetBtn(tbl, self.ContainerPets)
        end
        self.shop.AddItem(self.shop, self.ContainerPets);
    end
	
    --if not rp.cfg.DisableToolgunSkins then
        --self.ContainerToolGunSkins = vgui.Create( "rpui._shopcategory" );
        --self.ContainerToolGunSkins.Dock( self.ContainerToolGunSkins, TOP );
        --self.ContainerToolGunSkins.Title.SetFont( self.ContainerToolGunSkins.Title, "rpui.Fonts.ShopList.CategoryTitle" );
        --self.ContainerToolGunSkins.Title.SetText( self.ContainerToolGunSkins.Title, translates.Get("СКИНЫ") );
        --self.ContainerToolGunSkins.SetContentHeight( self.ContainerToolGunSkins, self.ContentHeight );
        --for k, tbl in pairs(rp.ToolGunSWEPS) do
            --if not istable(tbl) then continue end
            --self:CreateToolgunBtn(tbl, self.ContainerToolGunSkins)
        --end
        --self.shop.AddItem(self.shop, self.ContainerToolGunSkins);
    --end

    local myHats = 0;
    for mdl, data in pairs( rp.hats.list or {} ) do
        if table.HasValue(self.active_hats, mdl) or data.price or data.donatePrice then myHats = myHats + 1; end
    end

    if myHats > 0 then
        self.ContainerHATS = vgui.Create( "rpui._shopcategory" );
        self.ContainerHATS.Dock( self.ContainerHATS, TOP );
        self.ContainerHATS.Title.SetFont( self.ContainerHATS.Title, "rpui.Fonts.ShopList.CategoryTitle" );
        self.ContainerHATS.Title.SetText( self.ContainerHATS.Title, translates.Get("ШАПКИ") );
        self.ContainerHATS.SetContentHeight( self.ContainerHATS, self.ContentHeight );
        self.shop.AddItem(self.shop, self.ContainerHATS);

        --
        local createdhats = {};
        
        for k, mdl in ipairs( self.active_hats ) do
            local data = rp.hats.list[mdl];
            if not data then continue end

            createdhats[mdl] = true;
            self:CreateHatBtn(mdl, data);
        end

        for mdl, data in SortedPairsByMemberValue(rp.hats.list, "price", false) do
            if createdhats[mdl] or ((not data.price) and (not data.donatePrice)) then continue end
            self:CreateHatBtn(mdl, data);
        end
    end
end

function PANEL:CreatePetBtn(pettab)
    local btn = vgui.Create("DButton", self.ContainerPets)
    btn:Dock(TOP)
    btn:DockMargin(0, self.ContentSpacing, 0, 0)
    btn:SetTall(self.ContentHeight)
    btn:SetText("")
    btn.Paint = function(this, w, h)
        local cur, active = LocalPlayer():GetPet()
        if self.previewPet then
            active = self.previewPet == pettab
        else
            active = cur == pettab.id
        end
        local baseColor, textColor = rpui.GetPaintStyle(this, (not self.previewMDL and active) and STYLE_SOLID or STYLE_TRANSPARENT_INVERTED)

        surface.SetDrawColor(baseColor)
        surface.DrawRect(0, 0, w, h)

        surface.SetDrawColor(rpui.UIColors.Black)
        surface.DrawRect(0, 0, h, h)

        draw.SimpleText(pettab.name or "N/A", "rpui.Fonts.Hats.HatName", h + self.ContentSpacing, h/2, textColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		draw.SimpleText(pettab.id == LocalPlayer():GetPet() and translates.Get("Вызван") or "", "rpui.Fonts.Hats.HatPrint", w - self.ContentSpacing, h/2, textColor, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
    end

    btn.DoClick = function(this)
        self.preview:RenderHat("")
        self.preview:RenderSWEP()
		
        self.previewMDL = nil
        self.previewToolgun = nil

        self.preview:RenderPet(pettab)
        self.previewPet = pettab
    end

    btn.Mdl = vgui.Create("SpawnIcon", btn)
    local size = btn:GetTall() * 0.8
    local offset = (btn:GetTall() - size) / 2
    btn.Mdl:SetSize(size, size)
    btn.Mdl:SetPos(offset, offset)
    btn.Mdl:SetModel(pettab.model or "models/props_borealis/bluebarrel001.mdl", pettab.skin)
    btn.Mdl:SetMouseInputEnabled(false)
    btn.Mdl:InvalidateParent(true)
	
    self:InvalidateLayout(true)
    self:SizeToChildren(false, true)


    btn.IsEquiped = vgui.Create("Panel", btn)
    local sz = btn:GetTall()
    btn.IsEquiped:SetSize(sz, sz)
    local c_green = Color(140, 240, 90)
    btn.IsEquiped.Paint = function(this, w, h)
        local active = LocalPlayer():GetPet()
        if not active or active ~= pettab.id then return end
        draw.SimpleText("✔", "rpui.Fonts.Hats.HatName", h*0.95, h*0.95, c_green, TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM)
    end
    btn.IsEquiped:SetMouseInputEnabled(false)
    btn.IsEquiped:InvalidateParent(true)

    btn:InvalidateParent(true);

    self.ContainerPets:InvalidateLayout(true);
    self.ContainerPets:SizeToChildren(false, true); 
end

function PANEL:CreateToolgunBtn(tooltab)
    local btn = vgui.Create("DButton", self.ContainerToolGunSkins)
    btn:Dock(TOP)
    btn:DockMargin(0, self.ContentSpacing, 0, 0)
    btn:SetTall(self.ContentHeight)
    btn:SetText("")
    btn.Paint = function(this, w, h)
        local cur, active = LocalPlayer():GetCustomToolgun()
        if self.previewToolgun then
            active = self.previewToolgun == tooltab
        else
            active = cur == tooltab.index
        end
        local baseColor, textColor = rpui.GetPaintStyle(this, (not self.previewMDL and active) and STYLE_SOLID or STYLE_TRANSPARENT_INVERTED)

        surface.SetDrawColor(baseColor)
        surface.DrawRect(0, 0, w, h)

        surface.SetDrawColor(rpui.UIColors.Black)
        surface.DrawRect(0, 0, h, h)

        draw.SimpleText(tooltab.name or "N/A", "rpui.Fonts.Hats.HatName", h + self.ContentSpacing, h/2, textColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

        local SwepPrice = "N/A"
        if tooltab.price then
            SwepPrice = rp.FormatMoney(tooltab.price)
            if tooltab.donatePrice then
                SwepPrice = SwepPrice .. "  /  " .. string_Comma(tooltab.donatePrice).."₽"
            end
        elseif tooltab.donatePrice then
            SwepPrice = string_Comma(tooltab.donatePrice).."₽"
        end

        local ToolgunData = ply:GetNetVar("ToolgunData") or {}
        local owned = ToolgunData[cur]

        local txt = owned and translates.Get("Куплено") or ( SwepPrice .. ( tooltab.discount and " (-"..(tooltab.discount*100).."%)" or "" ) ) --this:IsHovered() and (self.active_hats[mdl] and "Экипировать" or "Купить") or rp.FormatMoney(tooltab.price)
        local tx_w, tx_h = draw.SimpleText(txt, "rpui.Fonts.Hats.HatPrint", w - self.ContentSpacing, h/2, textColor, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
    end

    btn.DoClick = function(this)
        self.preview:RenderPet()
        self.preview:RenderHat("")
        self.previewMDL = nil

        self.previewToolgun = tooltab
        self.preview:RenderSWEP(tooltab)
    end

    btn.Mdl = vgui.Create("SpawnIcon", btn)
    local size = btn:GetTall() * 0.8
    local offset = (btn:GetTall() - size) / 2
    btn.Mdl:SetSize(size, size)
    btn.Mdl:SetPos(offset, offset)
    btn.Mdl:SetModel(tooltab.model or "models/props_borealis/bluebarrel001.mdl")
    btn.Mdl:SetMouseInputEnabled(false)
    btn.Mdl:InvalidateParent(true)

    self:InvalidateLayout(true)
    self:SizeToChildren(false, true)


    btn.IsEquiped = vgui.Create("Panel", btn)
    local sz = btn:GetTall()
    btn.IsEquiped:SetSize(sz, sz)
    local c_green = Color(140, 240, 90)
    btn.IsEquiped.Paint = function(this, w, h)
        local active = LocalPlayer():GetCustomToolgun()
        if not active or active ~= tooltab.index then return end
        draw.SimpleText("✔", "rpui.Fonts.Hats.HatName", h*0.95, h*0.95, c_green, TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM)
    end
    btn.IsEquiped:SetMouseInputEnabled(false)
    btn.IsEquiped:InvalidateParent(true)

    btn:InvalidateParent(true);

    self.ContainerToolGunSkins:InvalidateLayout(true);
    self.ContainerToolGunSkins:SizeToChildren(false, true); 
end

function PANEL:CreateHatBtn(mdl, data)
    local HatBtn = vgui.Create("DButton", self.ContainerHATS)
    HatBtn:Dock(TOP)
    HatBtn:DockMargin(0, self.ContentSpacing, 0, 0)
    HatBtn:SetTall(self.ContentHeight)
    HatBtn:SetText("")
    HatBtn["data"] = data
    self.ActiveData = data
    HatBtn.Paint = function(this, w, h)
        local active
        if self.previewMDL then
            active = self.previewMDL == mdl
        else
            active = LocalPlayer():GetHat() == mdl
        end
        local baseColor, textColor = rpui.GetPaintStyle(this, (not self.previewToolgun and active) and STYLE_SOLID or STYLE_TRANSPARENT_INVERTED)

        local owned
        self.active_hats = LocalPlayer():GetNetVar("HatData", {})
        if self.active_hats then
            for i = 1, #self.active_hats do
                if self.active_hats[i] == mdl then
                    owned = true
                    break
                end
            end
        end

        surface.SetDrawColor(baseColor)--owned and ColorAlpha(Color(30, 80, 35), baseColor.a) or baseColor)
        surface.DrawRect(0, 0, w, h)

        surface.SetDrawColor(rpui.UIColors.Black)
        surface.DrawRect(0, 0, h, h)

        if #(this["data"].desc or "") == 0 then
            draw.SimpleText( this["data"].name, "rpui.Fonts.Hats.HatName", h + self.ContentSpacing, h * 0.5, textColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER );
        else
            surface.SetFont( "rpui.Fonts.Hats.HatName" );
            local nw, nh = surface.GetTextSize( " " ); nh = nh * 0.8;

            surface.SetFont( "rpui.Fonts.Hats.HatPrint_Warn" );
            local dw, dh = surface.GetTextSize( " " ); dh = dh * 0.8;

            local descs = string.Wrap( "rpui.Fonts.Hats.HatPrint_Warn", this["data"].desc, w - h * 3 );
            local label_h = nh + dh * #descs;
            local c = h * 0.5 - label_h * 0.5;

            draw.SimpleText( this["data"].name, "rpui.Fonts.Hats.HatName", h + self.ContentSpacing - nw * 0.3, c - nh * 0.25, textColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP );
            for k, v in ipairs( descs ) do
                draw.SimpleText( v, "rpui.Fonts.Hats.HatPrint_Warn", h + self.ContentSpacing, c + nh + dh * (k-1) - nh * 0.1, textColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP );
            end
        end

        local HatPrice = "N/A"
        if this["data"].price then
            HatPrice = rp.FormatMoney(this["data"].price)
            if this["data"].donatePrice then
                HatPrice = HatPrice .. "  /  " .. string_Comma(this["data"].donatePrice).."₽"
            end
        elseif this["data"].donatePrice then
            HatPrice = string_Comma(this["data"].donatePrice).."₽"
        end

        local txt = owned and translates.Get("Куплено") or ( HatPrice .. ( this["data"].discount and " (-"..(this["data"].discount*100).."%)" or "" ) ) --this:IsHovered() and (self.active_hats[mdl] and "Экипировать" or "Купить") or rp.FormatMoney(this["data"].price)
        local tx_w, tx_h = draw.SimpleText(txt, "rpui.Fonts.Hats.HatPrint", w - self.ContentSpacing, h/2, textColor, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)

        if not owned and this["data"].discount and this["data"].cfgPrice then
            local txt = this["data"].cfgPrice and rp.FormatMoney(this["data"].cfgPrice)

            if this["data"].cfgDonatePrice then
                txt = txt and (txt .. "  /  " .. this["data"].cfgDonatePrice .. "₽") or (this["data"].cfgDonatePrice.."₽")
            end

            local x, y = w - self.ContentSpacing, h/2 - tx_h
            local tx_w2, tx_h2 = draw.SimpleText(txt or "N/A", "rpui.Fonts.Hats.HatPrint_2", x, y, textColor, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)

            surface.SetDrawColor(textColor)
            surface.DrawRect(x - tx_w2, y + tx_h2*0.5 - 1, tx_w2, 2)
        end
    end

    HatBtn.DoClick = function(this)
        self.previewToolgun = nil
        self.preview:RenderPet()
        self.preview:RenderSWEP()

        self.preview:RenderHat(mdl, data)
        self.previewMDL = mdl
    end

    HatBtn.Mdl = vgui.Create("SpawnIcon", HatBtn)
    local size = HatBtn:GetTall() * 0.8
    local offset = (HatBtn:GetTall() - size) / 2
    HatBtn.Mdl:SetSize(size, size)
    HatBtn.Mdl:SetPos(offset, offset)
    
    local sk = string.match(mdl, "^(%d+):");
    if sk then
        local cmdl = string.sub(mdl, #sk+2);
        HatBtn.Mdl:SetModel(cmdl or "models/props_borealis/bluebarrel001.mdl", tonumber(sk))
        HatBtn.Mdl:RebuildSpawnIcon();
    else
        HatBtn.Mdl:SetModel(mdl or "models/props_borealis/bluebarrel001.mdl")
    end
    
    HatBtn.Mdl:SetMouseInputEnabled(false)
    HatBtn.Mdl:InvalidateParent(true)

    self:InvalidateLayout(true)
    self:SizeToChildren(false, true)

    HatBtn.IsEquiped = vgui.Create("Panel", HatBtn)
    local sz = HatBtn:GetTall()
    HatBtn.IsEquiped:SetSize(sz, sz)
    local c_green = Color(140, 240, 90)
    HatBtn.IsEquiped.Paint = function(this, w, h)
        local active = LocalPlayer():GetHat()
        if not active or active ~= mdl then return end
        draw.SimpleText("✔", "rpui.Fonts.Hats.HatName", h*0.95, h*0.95, c_green, TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM)
    end
    HatBtn.IsEquiped:SetMouseInputEnabled(false)
    HatBtn.IsEquiped:InvalidateParent(true)

    HatBtn:InvalidateParent(true);

    self.ContainerHATS:InvalidateLayout(true);
    self.ContainerHATS:SizeToChildren(false, true); 
end

function PANEL:RebuildFonts(frameW, frameH)
    surface.CreateFont("rpui.Fonts.Hats.CategoryTitle", {
        font = "Montserrat",
        extended = true,
        weight = 600,
        size = frameH * 0.035
    })

    surface.CreateFont("rpui.Fonts.Hats.HatName", {
        font = "Montserrat",
        extended = true,
        weight = 535,
        size = frameH * 0.032
    })

    surface.CreateFont("rpui.Fonts.Hats.HatPrint", {
        font = "Montserrat",
        extended = true,
        weight = 500,
        size = frameH * 0.0225
    })

    surface.CreateFont("rpui.Fonts.Hats.HatPrint_2", {
        font = "Montserrat",
        extended = true,
        weight = 500,
        size = frameH * 0.019
    })

    surface.CreateFont("rpui.Fonts.Hats.HatPrint_Warn", {
        font = "Montserrat",
        extended = true,
        weight = 500,
        size = frameH * 0.0175
    })
--[[
    surface.CreateFont("rpui.Fonts.Hats.SmallDesc", {
        font = "Montserrat",
        extended = true,
        weight = 500,
        size = frameH * 0.0175
    })
]]--
end
vgui.Register("rpui.HatsMenu", PANEL, "EditablePanel")