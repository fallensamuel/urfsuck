-- "gamemodes\\rp_base\\gamemode\\main\\menus\\f4menu\\controls\\rpui_accessories_cl.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local PANEL = {};

function PANEL:CreateWearable( accessory )
    local ih = self.FrameSpacing * 6;

    local Item = vgui.Create( "DButton" );
    self.Content:AddItem( Item );
    
    Item.data = accessory;

    Item:Dock( TOP );
    Item:SetTall( ih );
    Item:SetZPos( (LocalPlayer():GetAccessories()[Item.data.ACCESSORY_UID] ~= nil) and -1 or 0 );

    if not accessory.icon then
        Item.Icon = vgui.Create( "SpawnIcon", Item );
        Item.Icon:SetSize( ih, ih );
        Item.Icon:SetModel( accessory.__r_model, tonumber(accessory.__r_skin or 0) );
        Item.Icon:SetMouseInputEnabled( false );
    end

    Item.Poly = {
        { x = ih - ih * 0.375, y = 0 },
        { x = ih, y = 0 },
        { x = ih, y = ih * 0.375 },
    };

    Item.NameFont = "rpui.Fonts.Accessories.LargeBold";
    Item.DescFont = "rpui.Fonts.Accessories.Small";

    Item.Think = function( this )
        this.isWearing = LocalPlayer():GetAccessories()[Item.data.ACCESSORY_UID];
        this.isOwned = this.isWearing ~= nil;
    end

    Item.Paint = function( this, w, h )
        Item:SetZPos( this.isOwned and -1 or 0 );

        local baseColor, textColor = rpui.GetPaintStyle( this, STYLE_TRANSPARENT_SELECTABLE_INVERTED );

        surface.SetDrawColor( baseColor );
        surface.DrawRect( 0, 0, w, h );

        surface.SetDrawColor( color_black );
        surface.DrawRect( 0, 0, h, h );

        if accessory.icon then
            local icon_size = h * 0.8;
            surface.SetDrawColor( color_white );
            surface.SetMaterial( accessory.icon );
            surface.DrawTexturedRect( h * 0.5 - icon_size * 0.5, h * 0.5 - icon_size * 0.5, icon_size, icon_size );
        end

        -- title:
        if #accessory.desc > 0 then
            if (not this.DescWrapped) or (this.DescWrappedWidth ~= w) then
                surface.SetFont( this.NameFont );
                this.NameHeight = select( 2, surface.GetTextSize(" ") );

                this.DescWrapped = string.Wrap( this.DescFont, accessory.desc, w - h * 1.5 - self.FrameSpacing );
                this.DescWrappedWidth = w;

                surface.SetFont( this.DescFont );
                this.DescWrappedHeight = select(2, surface.GetTextSize(" ")) * 0.75;
                
                this.TextHeight = this.NameHeight + #this.DescWrapped * this.DescWrappedHeight;
            end

            local offset = h * 0.5 - this.TextHeight * 0.5;
            
            draw.SimpleText( accessory.name, this.NameFont, h + self.FrameSpacing + this.DescWrappedHeight * 0.1, offset, textColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP );

            for k, v in ipairs( this.DescWrapped ) do
                draw.SimpleText( v, this.DescFont, h + self.FrameSpacing, offset + this.NameHeight + (k - 1) * this.DescWrappedHeight );
            end
        else
            draw.SimpleText( accessory.name, this.NameFont, h + self.FrameSpacing, h * 0.5, textColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER );
        end

        -- price:
        local price = "N/A";
        local px, py = w - self.FrameSpacing, h - self.FrameSpacing;

        if accessory.price then
            price = rp.FormatMoney( accessory.price );

            if accessory.donatePrice then
                price = price .. "  /  " .. string.Comma( accessory.donatePrice ) .. "₽";
            end
        elseif accessory.donatePrice then
            price = string.Comma( accessory.donatePrice ) .. "₽";
        end

        local txt = this.isOwned and --[[translates.Get("Доступно")]] "" or price .. (accessory.discount and " (-" .. (accessory.discount * 100) .. "%)" or "");
        local tx_w, tx_h = draw.SimpleText( txt, "rpui.Fonts.Accessories.Default", px, py, textColor, TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM );
        py = py - tx_h;

        if not this.isOwned and accessory.discount and accessory.cfgPrice then
            local txt = accessory.cfgPrice and rp.FormatMoney( accessory.cfgPrice );

            if accessory.cfgDonatePrice then
                txt = txt and (txt .. "  /  " .. accessory.cfgDonatePrice .. "₽") or (accessory.cfgDonatePrice .. "₽");
            end

            txt = " " .. txt .. " ";

            local surf_alpha = surface.GetAlphaMultiplier();
            surface.SetAlphaMultiplier( surf_alpha * 0.5 );
                local tx_w2, tx_h2 = draw.SimpleText( txt or "N/A", "rpui.Fonts.Accessories.Default", px, py, textColor, TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM );
                surface.SetDrawColor( textColor );
                surface.DrawRect( px - tx_w2, py - tx_h2 * 0.5, tx_w2, 1 );
            surface.SetAlphaMultiplier( surf_alpha );
        end

        return true
    end

    Item.PaintOver = function( this, w, h )
        if this.isWearing then
            draw.NoTexture();
            surface.SetDrawColor( Color(0,200,0) );
            surface.DrawPoly( this.Poly );
            draw.SimpleText( "✔", "rpui.Fonts.Accessories.Small", h - h * 0.75 * 0.125, h * 0.125, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
        end
    end

    Item.DoClick = function( this )
        self.Action:SetupPayment( false );

        for k, v in ipairs( this:GetParent():GetChildren() ) do
            if v == this then continue end
            v.Selected = false;
        end

        self.RenderMode = "wearable";

        self.Selected = (self.Selected ~= this) and this or nil;
        this.Selected = not this.Selected;
    end
end

function PANEL:CreatePet( pet )
    local ih = self.FrameSpacing * 6;

    local Item = vgui.Create( "DButton" );
    self.Content:AddItem( Item );
    
    Item.data = pet;

    Item:Dock( TOP );
    Item:SetTall( ih );

    Item.Icon = vgui.Create( "SpawnIcon", Item );
    Item.Icon:SetSize( ih, ih );
    Item.Icon:SetModel( pet.model, tonumber(pet.skin or 0) );
    Item.Icon:SetMouseInputEnabled( false );

    Item.Poly = {
        { x = ih - ih * 0.375, y = 0 },
        { x = ih, y = 0 },
        { x = ih, y = ih * 0.375 },
    };

    Item.NameFont = "rpui.Fonts.Accessories.LargeBold";
    Item.DescFont = "rpui.Fonts.Accessories.Small";

    Item.Think = function( this )
        this.isWearing = (LocalPlayer():GetPet() or -1) == Item.data.id;
    end

    Item.Paint = function( this, w, h )
        Item:SetZPos( this.isOwned and -1 or 0 );

        local baseColor, textColor = rpui.GetPaintStyle( this, STYLE_TRANSPARENT_SELECTABLE_INVERTED );

        surface.SetDrawColor( baseColor );
        surface.DrawRect( 0, 0, w, h );

        surface.SetDrawColor( color_black );
        surface.DrawRect( 0, 0, h, h );

        -- title:
        if #(pet.desc or "") > 0 then
            if (not this.DescWrapped) or (this.DescWrappedWidth ~= w) then
                surface.SetFont( this.NameFont );
                this.NameHeight = select( 2, surface.GetTextSize(" ") );

                this.DescWrapped = string.Wrap( this.DescFont, pet.desc, w - h * 1.5 - self.FrameSpacing );
                this.DescWrappedWidth = w;

                surface.SetFont( this.DescFont );
                this.DescWrappedHeight = select(2, surface.GetTextSize(" ")) * 0.75;
                
                this.TextHeight = this.NameHeight + #this.DescWrapped * this.DescWrappedHeight;
            end

            local offset = h * 0.5 - this.TextHeight * 0.5;
            
            draw.SimpleText( pet.name, this.NameFont, h + self.FrameSpacing + this.DescWrappedHeight * 0.1, offset, textColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP );

            for k, v in ipairs( this.DescWrapped ) do
                draw.SimpleText( v, this.DescFont, h + self.FrameSpacing, offset + this.NameHeight + (k - 1) * this.DescWrappedHeight );
            end
        else
            draw.SimpleText( pet.name, this.NameFont, h + self.FrameSpacing, h * 0.5, textColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER );
        end

        return true
    end

    Item.PaintOver = function( this, w, h )
        if this.isWearing then
            draw.NoTexture();
            surface.SetDrawColor( Color(0,200,0) );
            surface.DrawPoly( this.Poly );
            draw.SimpleText( "✔", "rpui.Fonts.Accessories.Small", h - h * 0.75 * 0.125, h * 0.125, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
        end
    end

    Item.DoClick = function( this )
        if this.Selected then return end

        for k, v in ipairs( this:GetParent():GetChildren() ) do
            if v == this then continue end
            v.Selected = false;
        end
        
        self.RenderMode = "pet";

        self.Selected = (self.Selected ~= this) and this or nil;
        this.Selected = not this.Selected;
    end
end

function PANEL:SetSpacing( spacing )
    self.FrameSpacing = spacing;
end

function PANEL:RebuildFonts( w, h )
    surface.CreateFont( "rpui.Fonts.Accessories.LargeBold", {
        font = "Montserrat",
        size = h * 0.035,
        weight = 1000,
        extended = true,
    } );

    surface.CreateFont( "rpui.Fonts.Accessories.Default", {
        font = "Montserrat",
        size = h * 0.0275,
        weight = 400,
        extended = true,
    } );

    surface.CreateFont( "rpui.Fonts.Accessories.Small", {
        font = "Montserrat",
        size = h * 0.025,
        weight = 400,
        extended = true,
    } );
end

function PANEL:Init()
    self.Left = vgui.Create( "Panel", self );
    self.Left:Dock( LEFT );
    
    self.Right = vgui.Create( "Panel", self );
    self.Right:Dock( RIGHT );
    
    self.Categories = vgui.Create( "Panel", self.Left );
    self.Categories:Dock( TOP );
    self.Categories.Types = {};

    self.Content = vgui.Create( "rpui.ScrollPanel", self.Left );
    self.Content:Dock( FILL );
    self.Content:AlwaysLayout( true );

    self.Action = vgui.Create( "DButton", self.Right );
    self.Action:Dock( BOTTOM );
    self.Action.Status = -1;

    self.Action.StatusMessage = {
        ["default"] = {
            [-1] = "undefined",
            [0] = "НАДЕТЬ",
            [1] = "СНЯТЬ",
            [2] = "КУПИТЬ",
            [3] = "ПОДОЖДИТЕ...",
        },

        ["pet"] = {
            [0] = "ВЫЗВАТЬ",
            [1] = "ОТОЗВАТЬ",
        },
    };

    self.Action.StatusFuncs = {
        ["default"] = {
            [-1] = function( self, this )
                -- nothing
            end,
            [0] = function( self, this )
                rp.RunCommand( "setwearable", self.Selected.data.ACCESSORY_UID );
            end,
            [1] = function( self, this )
                rp.RunCommand( "removewearable", self.Selected.data.ACCESSORY_UID );
            end,
            [2] = function( self, this )
                -- confirmation
                this.Status = 3;
                this:SetupPayment( true );

                timer.Create( "rpui.Accessories.Payment", 5, 1, function()
                    if not IsValid( self ) then return end

                    if this.Confirmation then
                        this:SetupPayment( false );
                    end
                end );
            end,
        },

        ["pet"] = {
            [-1] = function( self, this )
                -- nothing
            end,
            [0] = function( self, this )
                net.Start( "Pets::Spawn" );
                    net.WriteUInt( self.Selected.data.id, 8 );
                net.SendToServer();
            end,
            [1] = function( self, this )
                net.Start( "Pets::Despawn" );
			    net.SendToServer();
            end,
            [2] = function( self, this )
                -- nothing
            end,
        }
    }

    self.Action.SetupPayment = function( this, b )
        if not b then
            if IsValid(this.Money) then
                this.Money:Remove();
                this.Money = nil;
            end

            if IsValid(this.Donate) then
                this.Donate:Remove();
                this.Donate = nil;
            end

            this.Confirmation = false;
            timer.Remove( "rpui.Accessories.Payment" );

            return
        end

        this.Confirmation = true;

        local data = self.Selected and self.Selected.data or nil;
        if not data then return end
        if (not data.price) and (not data.donatePrice) then return end

        local function Paint( me, w, h )
            local baseColor, textColor = rpui.GetPaintStyle( me, STYLE_SOLID );

            surface.SetDrawColor( baseColor );
            surface.DrawRect( 0, 0, w, h );

            draw.SimpleText( me:Title(), "rpui.Fonts.Accessories.LargeBold", w * 0.5, h * 0.55, textColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM );
            draw.SimpleText( me:Text(), "rpui.Fonts.Accessories.Small", w * 0.5, h * 0.55, textColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP );
        
            return true
        end

        local function Purchase( isDonate )
            LocalPlayer():GetAccessories()[data.ACCESSORY_UID] = false;
            rp.RunCommand( isDonate and "buydonatewearable" or "buywearable", data.ACCESSORY_UID );
            this:SetupPayment( false );
        end

        this.Money = vgui.Create( "DButton", this );
        this.Money:Dock( LEFT );
        this.Money:SetWide( this:GetWide() * 0.5 );
        this.Money.Paint = Paint;
        this.Money.DoClick = function( me ) Purchase( false ); end
        this.Money.Title = function( me ) return translates.Get("За деньги"); end
        this.Money.Text = function( me )
            local money, price = LocalPlayer():GetMoney(), (data.price or "N/A");
            if not price then return "N/A" end
            
            if money >= price then
                return rp.FormatMoney(price);
            end

            return translates.Get("Не хватает") .. " " .. rp.FormatMoney(price - money);
        end
        
        this.Donate = vgui.Create( "DButton", this );
        this.Donate:Dock( RIGHT );
        this.Donate:SetWide( this:GetWide() * 0.5 );
        this.Donate.Paint = Paint;
        this.Donate.DoClick = function( me ) Purchase( true ); end
        this.Donate.Title = function( me ) return translates.Get("За донат"); end
        this.Donate.Text = function( me )
            local money, price = LocalPlayer():GetCredits(), (data.donatePrice or "N/A");
            if not price then return "N/A" end
            
            if money >= price then
                return string.Comma(price) .. "₽";
            end
            
            return translates.Get("Не хватает") .. " " .. string.Comma(price - money) .. "₽";
        end

        if not data.price then
            this.Money:Remove();
            this.Donate:Dock( FILL );
        end

        if not data.donatePrice then
            this.Donate:Remove();
            this.Money:Dock( FILL );
        end
    end

    self.Action.Think = function( this )
        if self.Selected then
            if self.Selected.data then
                if self.Selected.data.type ~= rp.Accessories.Enums["TYPE_PET"] then
                    local isWearing = LocalPlayer():GetAccessories()[self.Selected.data.ACCESSORY_UID];
                    local isOwned = isWearing ~= nil;

                    this.Status = isOwned and (isWearing and 1 or 0) or 2;
                else
                    local isWearing = (LocalPlayer():GetPet() or -1) == self.Selected.data.id;

                    this.Status = (isWearing and 1 or 0);
                end
            end
        else
            if this.Status ~= -1 then
                this.Status = -1;
            end
        end

        this:SetMouseInputEnabled( this.Status ~= -1 );

        if this.Status == -1 then
            if this:GetTall() > 0 then
                this.InitialTall = this:GetTall();
                this:SetTall( 0 );
            end
        else
            if this:GetTall() == 0 then
                this:SetTall( this.InitialTall );
            end
        end
    end

    self.Action.Paint = function( this, w, h )
        local baseColor, textColor = rpui.GetPaintStyle( this, STYLE_SOLID );

        if this.Confirmation then return true end
        if this.Status == -1 then return true end

        surface.SetDrawColor( baseColor );
        surface.DrawRect( 0, 0, w, h );

        local msg = (this.StatusMessage[self.RenderMode] or {})[this.Status] or this.StatusMessage["default"][this.Status];
        if msg then
            draw.SimpleText( translates.Get(msg), "rpui.Fonts.Accessories.LargeBold", w * 0.5, h * 0.5, textColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
        end
        
        return true
    end

    self.Action.DoClick = function( this )
        if this.Status and this.StatusFuncs then
            local f = (this.StatusFuncs[self.RenderMode] or {})[this.Status] or this.StatusFuncs["default"][this.Status];
            if f then f( self, this ); end
        end
    end

    self.Model = vgui.Create( "DModelPanel", self.Right );
    self.Model:Dock( FILL );
    self.Model:SetModel( LocalPlayer():GetModel() );
    self.Model:SetFOV( 25 );

    self.Model.tLookatPos = vector_origin;
    self.Model.tCamPos = vector_origin;
    self.Model.tDirection = angle_zero;
    self.Model.aDirection = angle_zero;
    self.Model.flDistance = 64;
    self.Model.flLifetime = 0;

    self.Model.DrawAccessories = function( this )
        local slot, rendered = -1, {};

        if self.Selected and self.Selected.data and self.Selected.data.slot then
            slot = self.Selected.data.slot;
        end

        for uid, active in pairs( LocalPlayer():GetAccessories() ) do
            if not active then continue end

            local accessory = rp.Accessories.List[uid];
            if not accessory then continue end

            if accessory.slot and accessory.slot == slot then continue end

            rendered[uid] = true;
            accessory.__renderer( this.Entity, uid );
        end

        if self.Selected and self.Selected.data and self.Selected.data.__renderer then
            local uid = self.Selected.data.ACCESSORY_UID;

            if not rendered[uid] then
                self.Selected.data.__renderer( this.Entity, uid );
            end
        end
    end

    self.Model.LayoutEntity = function( this )
        return
    end

    self.Model.RenderModes = {
        ["wearable"] = function( this, w, h )
            local ent = this.Entity;

            local x, y = this:LocalToScreen( 0, 0 );
            this:LayoutEntity( this.Entity );
            
            local ang = this.aLookAngle;
            if not ang then
                ang = (this.vLookatPos - this.vCamPos):Angle();
            end
            
            if self.Selected and self.Selected.data then
                local data = self.Selected.data;

                if ent:GetModel() ~= LocalPlayer():GetModel() then
                    ent:SetModel( LocalPlayer():GetModel() );
                    ent:SetSkin( LocalPlayer():GetSkin() or 0 );
                    ent:ResetSequence( ent:LookupSequence("walk_all") );
                end
            end

            cam.Start3D( this.vCamPos, ang, this.fFOV, x, y, w, h, 5, this.FarZ );
                render.SuppressEngineLighting( true );
                render.SetLightingOrigin( ent:GetPos() );
                render.ResetModelLighting( this.colAmbientLight.r / 255, this.colAmbientLight.g / 255, this.colAmbientLight.b / 255 );
                render.SetColorModulation( this.colColor.r / 255, this.colColor.g / 255, this.colColor.b / 255 );
                render.SetBlend( (this:GetAlpha() / 255) * (this.colColor.a / 255) );
        
                for i = 0, 6 do
                    local col = this.DirectionalLight[i];
                    if col then
                        render.SetModelLighting( i, col.r / 255, col.g / 255, col.b / 255 );
                    end
                end
        
                this:DrawModel();
                this:DrawAccessories();
        
                render.SuppressEngineLighting( false );
            cam.End3D();

            if self.Selected and self.Selected.data then
                this.flLifetime = 0;
                this.flDistance = this.Entity:GetModelRadius() * 1.25;

                local data = self.Selected.data;

                if data.attachment then
                    local attach_id = ent:LookupAttachment( data.attachment );
                    if not attach_id then return end

                    local attach = ent:GetAttachment( attach_id );
                    if not attach then return end

                    this.tLookatPos, this.tDirection = attach.Pos, attach.Ang;
                else
                    local bone_id = ent:LookupBone( data.bone );
                    if not bone_id then return end
                    
                    this.tLookatPos, this.tDirection = ent:GetBonePosition( bone_id );
                end

                local dir = math.atan2(this.tLookatPos.y, this.tLookatPos.x);
                this.tDirection = Angle( 10, 145 + (dir < -1 and 180 or 0), 25 );

                -- this.tDirection:RotateAroundAxis( this.tDirection:Up(), 90 );
                -- this.tDirection:RotateAroundAxis( this.tDirection:Up(), 10 );
                -- this.tDirection:RotateAroundAxis( this.tDirection:Right(), 25 );
            else
                this.flLifetime = this.flLifetime + RealFrameTime() * 32;

                local mins, maxs = ent:GetModelRenderBounds();
                this.tLookatPos = LerpVector( 0.5, ent:GetModelRenderBounds() );
                this.tLookatPos.z = Lerp( 0.65, mins.z, maxs.z );
                this.tDirection = Angle( 0, 180 + this.flLifetime, 0 );
                this.flDistance = ent:GetModelRadius() * 0.85 * 3;
            end
        end,

        ["pet"] = function( this, w, h )
            local ent = this.Entity;

            local x, y = this:LocalToScreen( 0, 0 );
            this:LayoutEntity( this.Entity );
            
            local ang = this.aLookAngle;
            if not ang then
                ang = (this.vLookatPos - this.vCamPos):Angle();
            end

            if self.Selected and self.Selected.data then
                if this.__lastSelected ~= self.Selected then
                    this.__lastSelected, this.flLifetime = self.Selected, 0;
                end

                local data = self.Selected.data;

                if ent:GetModel() ~= data.model then
                    ent:SetModel( data.model );
                    ent:SetSkin( data.skin or 0 );
                end
            end

            cam.Start3D( this.vCamPos, ang, this.fFOV, x, y, w, h, 5, this.FarZ );
                render.SuppressEngineLighting( true );
                render.SetLightingOrigin( ent:GetPos() );
                render.ResetModelLighting( this.colAmbientLight.r / 255, this.colAmbientLight.g / 255, this.colAmbientLight.b / 255 );
                render.SetColorModulation( this.colColor.r / 255, this.colColor.g / 255, this.colColor.b / 255 );
                render.SetBlend( (this:GetAlpha() / 255) * (this.colColor.a / 255) );
        
                for i = 0, 6 do
                    local col = this.DirectionalLight[i];
                    if col then
                        render.SetModelLighting( i, col.r / 255, col.g / 255, col.b / 255 );
                    end
                end
        
                this:DrawModel();
        
                render.SuppressEngineLighting( false );
            cam.End3D();

            this.flLifetime = this.flLifetime + RealFrameTime() * 32;

            local mins, maxs = ent:GetModelRenderBounds();
            this.tLookatPos = LerpVector( 0.5, ent:GetModelRenderBounds() );
            this.tLookatPos.z = Lerp( 0.65, mins.z, maxs.z );
            this.tDirection = Angle( 0, 180 + this.flLifetime, 0 );
            this.flDistance = ent:GetModelRadius() * 0.85 * 4;
        end
    }

    local color_warn, material_warn = Color(255,200,0), Material("rpui/notify/1.png", "smooth noclamp");

    self.Model.Paint = function( this, w, h )
        if not IsValid( this.Entity ) then return end

        this.RenderModes[self.RenderMode or "wearable"]( this, w, h );

        this.aDirection = LerpAngle( RealFrameTime() * 6, this.aDirection, this.tDirection or this.aDirection );
        this.vLookatPos = Lerp( RealFrameTime() * 6, this.vLookatPos, this.tLookatPos or this.vLookatPos );
        
        this.tCamPos = this.vLookatPos - this.aDirection:Forward() * this.flDistance;
        this.vCamPos = Lerp( RealFrameTime() * 6, this.vCamPos, this.tCamPos or this.vCamPos);

        if (self.RenderMode == "wearable") and self.Selected and self.Selected.data then
            local accessory = self.Selected.data;

            if accessory and accessory.can_wear and (not accessory.can_wear(LocalPlayer())) then
                local th, th = draw.SimpleTextOutlined( translates.Get("Аксессуар отключен на данной профессии"), "rpui.Fonts.Accessories.Default", w * 0.5, h - self.FrameSpacing, color_warn, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, 2, color_black );
                local s = h * 0.035;
            
                surface.SetDrawColor( color_warn );
                surface.SetMaterial( material_warn );
                surface.DrawTexturedRect( w * 0.5 - s * 0.5, h - self.FrameSpacing - th - s, s, s );
            end
        end

        this.LastPaint = RealTime();
    end
end

function PANEL:SetupContent( filter )
    self.Selected = nil;
    
    self.Content:SetAlpha( 0 );
    self.Content:ClearItems();
    
    local myHats, myPets = LocalPlayer():GetNetVar("Accessories") or {}, rp.pets.GetMy() or {};
    
    local items, pets = {}, {};
    
    for k, petdata in ipairs( myPets ) do
        petdata.type = rp.Accessories.Enums["TYPE_PET"];
        pets[petdata.uid or "pet_" .. k] = petdata;
    end

    table.Merge( items, rp.Accessories.List or {} );
    table.Merge( items, pets );

    for uid, accessory in SortedPairsByMemberValue( items, "price", false ) do
        if (not accessory.price) and (not accessory.donatePrice) and (myHats[uid] == nil) and (accessory.type ~= rp.Accessories.Enums["TYPE_PET"]) then continue end

        local allowed = true;

        if filter then
            if not table.HasValue( filter, true ) then
                goto create;
            end

            allowed = false;

            local changed = false;
            for f, b in pairs( filter ) do
                if not b then continue end

                if isnumber(f) then
                    changed = true;

                    if accessory.type == f then
                        allowed = true;
                        continue
                    end 
                end
            end

            if filter["owned"] then
                if changed then
                    allowed = allowed and ((ply:GetAccessories()[uid] ~= nil) or (accessory.type == rp.Accessories.Enums["TYPE_PET"])) or false;
                else
                    allowed = (ply:GetAccessories()[uid] ~= nil) or (accessory.type == rp.Accessories.Enums["TYPE_PET"]);
                end
            end
        end

        ::create::
        if allowed then
            if accessory.type == rp.Accessories.Enums["TYPE_PET"] then
                self:CreatePet( accessory );
            else
                self:CreateWearable( accessory );
            end
        end
    end

    self.Content:AlphaTo( 255, 0.25 );
end

function PANEL:SetupFilter()
    for _, child in ipairs( self.Categories:GetChildren() ) do
        child:Remove();
    end

    self.Categories.Filter = {};
    self.Categories.Filter["owned"] = false;

    for _, child in ipairs( self.Content:GetItems() ) do
        if not child.data then continue end
        self.Categories.Filter[child.data.type or rp.Accessories.Enums["TYPE_WEARABLE"]] = false;
    end

    local iw = self.Categories:GetWide() / table.Count(self.Categories.Filter);

    for f in pairs( self.Categories.Filter ) do
        local FilterButton = vgui.Create( "DButton", self.Categories );
        FilterButton:Dock( LEFT );
        FilterButton:SetWide( iw );
        FilterButton:SetZPos( tonumber(f) and tonumber(f) or -1 );
        FilterButton.Material = Material( "rpui/accessories/filters/" .. f .. ".png", "smooth noclamp" );
        FilterButton.Paint = function( this, w, h )
            local baseColor, textColor = rpui.GetPaintStyle( this, STYLE_TRANSPARENT_SELECTABLE );
            surface.SetDrawColor( baseColor );
            surface.DrawRect( 0, 0, w, h );

            local size = ((w < h) and w or h) * 0.7;
            surface.SetDrawColor( textColor );
            surface.SetMaterial( this.Material );
            surface.DrawTexturedRect( w * 0.5 - size * 0.5, h * 0.5 - size * 0.5, size, size );

            return true
        end

        FilterButton.DoClick = function( this )
            this.Selected = not this.Selected;
            self.Categories.Filter[f] = this.Selected;

            self:SetupContent( self.Categories.Filter );
        end
    end
end

function PANEL:PerformLayout( w, h )
    if not self.Initialized then
        self.FrameSpacing = self.FrameSpacing or (h * 0.01);

        self:RebuildFonts( w, h );

        self.Initialized = true;
        return
    end

    self.Left:SetWide( w * 0.5 );
    self.Right:SetWide( w * 0.5 - self.FrameSpacing );
    
    self.Categories:SetTall( self.FrameSpacing * 4 );
    self.Categories:DockMargin( 0, 0, 0, self.FrameSpacing );

    self.Content:SetScrollbarMargin( self.FrameSpacing );
    self.Content:SetSpacingY( self.FrameSpacing );

    self.Action:SetTall( self.FrameSpacing * 3 );

    self:SetupFilter();
    self:SetupContent();
end

vgui.Register( "rpui.AccessoriesMenu", PANEL, "EditablePanel" );