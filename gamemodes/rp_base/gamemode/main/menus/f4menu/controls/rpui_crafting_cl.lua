-- "gamemodes\\rp_base\\gamemode\\main\\menus\\f4menu\\controls\\rpui_crafting_cl.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local PANEL = {};

function PANEL:Init()
    self.Title = "";
    self.ContentSpacing = 0;
    self.MdlIcon = vgui.Create( "SpawnIcon", self );
    self.MdlIcon.SetMouseInputEnabled( self.MdlIcon, false );

    self.GreenBgCol = Color(0, 150, 0)
    self.GreenCol = Color(50, 200, 50, 0)
end

function PANEL:PerformLayout()
    self.MdlIcon.Size = 0.8 * self:GetTall();
    self.MdlIcon.Offset = 0.5 * (self:GetTall() - self.MdlIcon.Size);
    self.MdlIcon.SetSize( self.MdlIcon, self.MdlIcon.Size, self.MdlIcon.Size );
    self.MdlIcon.SetPos( self.MdlIcon, self.MdlIcon.Offset, self.MdlIcon.Offset );
end

local green1 = Color(50, 200, 50)
local green2 = Color(0, 150, 0)

function PANEL:Paint( w, h )
    local baseColor = rpui.GetPaintStyle( self, STYLE_TRANSPARENT );
    surface.SetDrawColor( baseColor );
    surface.DrawRect( 0, 0, w, h );

    if self.Recipe and rp.IsCanCraftItem(LocalPlayer():getInv(), self.Recipe) then
        self.rotAngle = (self.rotAngle or 0) + 100 * FrameTime();

        self.GreenCol.a = Lerp(FrameTime()*8, self.GreenCol.a, self:IsHovered() and 255 or 0)
        self.GreenBgCol.a = self.GreenCol.a

        if self.GreenCol.a > 1 then
            local distsize  = math.sqrt( w*w + h*h );
            surface.SetDrawColor(self.GreenBgCol);
            surface.DrawRect(h, 0, w, h);

            surface.SetMaterial(rpui.GradientMat);
            surface.SetDrawColor(self.GreenCol);
            surface.DrawTexturedRectRotated(w * 0.5, h * 0.5, distsize, distsize, (self.rotAngle or 0));

            surface.SetDrawColor( rpui.UIColors.Black );
            surface.DrawRect( 0, 0, h, h );
        else
            surface.SetDrawColor( rpui.UIColors.Black );
            surface.DrawRect( 0, 0, h, h );
        end

        rpui.DrawStencilBorder(self, 0, 0, w, h, 0.04, green2, green1, self:GetAlpha()/255);
    else
        surface.SetDrawColor( rpui.UIColors.Black );
        surface.DrawRect( 0, 0, h, h );
    end

    if not self.BakedText then
        self.BakedText, self.BakedTextHeight = rpui.BakeText( self:GetText(), "rpui.Fonts.CraftingMenu.RecipeTitle", (w - h - self.ContentSpacing * 2), h );
    end

    for k, v in pairs( self.BakedText ) do
        draw.SimpleText( v.text, "rpui.Fonts.CraftingMenu.RecipeTitle", v.x + h + self.ContentSpacing, rpui.PowOfTwo(v.y + h * 0.5 - self.BakedTextHeight * 0.5), rpui.UIColors.White );
    end

    return true
end

function PANEL:SetInfo( model, func )
    self.MdlIcon.SetModel( self.MdlIcon, model );
    self.DoClick = func;
end

vgui.Register( "rpui.CraftingRecipe", PANEL, "DButton" );




local PANEL = {};


function PANEL:RebuildFonts( frameW, frameH )
    surface.CreateFont( "rpui.Fonts.CraftingMenu.Title", {
        font     = "Montserrat",
        extended = true,
        weight = 500,
        size     = frameH * 0.0325,
    } );

    surface.CreateFont( "rpui.Fonts.CraftingMenu.RecipeTitle", {
        font     = "Montserrat",
        extended = true,
        weight = 600,
        size     = frameH * 0.03325,
    } );

    surface.CreateFont( "rpui.Fonts.CraftingMenu.CraftButton", {
        font     = "Montserrat",
        extended = true,
        weight = 600,
        size     = frameH * 0.065,
    } );
end


function PANEL:SetSpacing( spacing )
    self.ContentSpacing = spacing;
end


function PANEL:Initialize()
    local craftableInv, resultInv;

    self.Parent              = self:GetParent();
    self.frameW, self.frameH = self.Parent.GetSize(self.Parent);

    self.invFrameScale = 0.1 * self.frameH;

    self:Dock( FILL );
    self:RebuildFonts( self.frameW, self.frameH );

    self.RecipesContainer = vgui.Create( "Panel", self );
    local rec_cont = self.RecipesContainer;
    
    rec_cont:Dock( RIGHT );
    rec_cont:SetWide( self.frameW * 0.4 );

    rec_cont.Content = vgui.Create( "rpui.ScrollPanel", rec_cont );
    rec_cont.Content.Dock( rec_cont.Content, FILL );
    rec_cont.Content.SetScrollbarMargin( rec_cont.Content, self.ContentSpacing * 0.8 );

    local RecipesPnl = vgui.Create( "Panel", rec_cont.Content );
    RecipesPnl:Dock( FILL );
    for i = 1, rp.item.recipeMaxId do
        for k, v in pairs( rp.item.recipes ) do
            if i ~= v.id then continue end

            local recipe = vgui.Create( "rpui.CraftingRecipe", RecipesPnl );
            recipe.Recipe = v
            recipe:Dock( TOP );
            recipe:DockMargin( 0, 0, 0, self.ContentSpacing * 0.5 );
            recipe:SetTall( self.frameH * 0.1 );
            recipe:SetFont( "rpui.Fonts.CraftingMenu.RecipeTitle" );
            recipe:SetText( string.utf8upper(k) );
            recipe.ContentSpacing = self.ContentSpacing;
            recipe:InvalidateParent( true );

            recipe:SetInfo( v.result.model, function()
                if IsValid(rp.gui.RecipesPnl) and rp.gui.RecipesPnl.CraftTimeStart then
                    local cr_time = rp.gui.RecipesPnl.CraftTime_ or 0
                    local end_time = rp.gui.RecipesPnl.CraftTimeStart + cr_time
                    if CurTime() < end_time then return end
                end

                rp.gui.craftable.ClearItemsCrafting(rp.gui.craftable);

                for c, d in pairs( v.items ) do
                    for i = 1, d.count do
                        rp.gui.craftable.AddItemCrafting( rp.gui.craftable, craftableInv, rp.item.list[d.item.uniqueID] );
                    end
                end

                for c, d in pairs( v.instruments ) do
                    rp.gui.craftable.AddItemCrafting( rp.gui.craftable, craftableInv, rp.item.list[d.uniqueID] );
                end

                rp.gui.craftable.CheckRecipes( rp.gui.craftable, k );

                if IsValid( rp.gui.craftButton ) then
                    rp.gui.craftButton:CanCraftItem( k );
                end
            end );
        end
    end
    RecipesPnl:InvalidateLayout( true );
    RecipesPnl:SizeToChildren( false, true );
    self.RecipesContainer.Content.AddItem( self.RecipesContainer.Content, RecipesPnl );

    rp.gui.RecipesPnl = RecipesPnl

    self.CraftContainer = vgui.Create( "Panel", self );
    local craft_cont = self.CraftContainer;
    
    craft_cont:Dock( TOP );
    craft_cont:SetTall( self.frameH * 0.5 );

    craft_cont.Label = vgui.Create( "DLabel", craft_cont );
    local craft_lab = craft_cont.Label;
    
    craft_lab:Dock( TOP );
    craft_lab:DockMargin( 0, 0, 0, self.ContentSpacing );
    craft_lab:SetFont( "rpui.Fonts.CraftingMenu.Title" );
    craft_lab:SetTextColor( rpui.UIColors.White );
    craft_lab:SetText( translates.Get("СТОЛ ДЛЯ ПРЕДМЕТОВ") );
    craft_lab:SizeToContentsY();
    
    craftableInv = rp.item.createInv( 5, 1, "craftable" );
    craft_cont.CraftInventory = vgui.Create( "rpui.Inventory", self.CraftContainer );
    local craft_inv = craft_cont.CraftInventory;
    
    craft_inv:Dock( TOP );
    craft_inv:DockMargin( 0, 0, 0, self.ContentSpacing );
    craft_inv.widthFrame   = self.invFrameScale;
    craft_inv.heightFrame  = self.invFrameScale;
    craft_inv.spacingFrame = self.ContentSpacing;
    craft_inv:setInventory( craftableInv );
    rp.gui.craftable = self.CraftContainer.CraftInventory;

    craft_cont.ResultsContainer = vgui.Create( "Panel", self.CraftContainer );
    local craft_res = craft_cont.ResultsContainer;
    
    craft_res:Dock( TOP );

    resultInv = rp.item.createInv( 1, 1, "result" );
    craft_res.ResultInventory = vgui.Create( "rpui.Inventory", self.CraftContainer.ResultsContainer );
    local craft_resinv = craft_res.ResultInventory;
    
    craft_resinv:Dock( LEFT );
    craft_resinv.widthFrame  = self.invFrameScale * 2;
    craft_resinv.heightFrame = self.invFrameScale * 2;
    craft_resinv:setInventory( resultInv );
    craft_res:SizeToChildren( false, true );
    rp.gui.result = self.CraftContainer.ResultsContainer.ResultInventory;

    craft_res.CraftButton = vgui.Create( "DButton", self.CraftContainer.ResultsContainer );
    local craft_btn = craft_res.CraftButton;
    
    craft_btn:SetFont( "rpui.Fonts.CraftingMenu.CraftButton" );
    craft_btn:SetText( translates.Get("СОЗДАТЬ") );
    craft_btn:SizeToContentsX( self.ContentSpacing * 4 );
    craft_btn:SizeToContentsY( self.ContentSpacing );
    craft_btn:SetPos( craft_resinv:GetWide() + self.ContentSpacing, craft_res:GetTall() * 0.5 - craft_btn:GetTall() * 0.5 );
    craft_btn:SetDisabled( true );
    
    local craftCol = Color(0, 255, 0, 125)
    craft_btn.Paint = function( this, w, h )
        local baseColor, textColor = rpui.GetPaintStyle( this, STYLE_TRANSPARENT_INVERTED );
		
        local anim = ((not this:GetDisabled() and rp.gui.result.recipe) and this._grayscale or 0) / 255;
        
        baseColor = rpui.LerpColor( anim, rp.cfg.UIColor.Background, rp.cfg.UIColor.BlockHeader or Color(0, 0, 0) );
        textColor = rpui.LerpColor( anim, rp.cfg.UIColor.White, rp.cfg.UIColor.BlockHeaderInverted or Color(255, 255, 255) );

        surface.SetDrawColor(baseColor)
        surface.DrawRect(0, 0, w, h)

        if IsValid(RecipesPnl) and RecipesPnl.CraftTimeStart then
            local cr_time = RecipesPnl.CraftTime_ or 0
            local end_time = RecipesPnl.CraftTimeStart + cr_time
            local precent = (end_time - CurTime()) / cr_time

            surface.SetDrawColor(craftCol)
            surface.DrawRect(0, 0, w - w * precent, h)
        end

        draw.SimpleText( this:GetText(), this:GetFont(), w * 0.5, h * 0.5, textColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
        
        return true
    end
    craft_btn.DoClick = function( this )
        if this:GetDisabled() then return end
        if not rp.gui.result.recipe then return end

        local canCraft = this:CanCraftItem( rp.gui.result.recipe );
        if not canCraft then return end

        local CT = CurTime()
        if (this.LastDoClick or 0) + 0.75 > CT then return end
        this.LastDoClick = CT

        this.TimeCrafting = (rp.gui.result.recipe ~= nil and rp.item.recipes[rp.gui.result.recipe].timeCreation or rp.cfg.DefaultTimeCreation)
        this:SetDisabled( true );

        RecipesPnl.CraftTimeStart = CurTime()
        RecipesPnl.CraftTime_ = this.TimeCrafting

        if IsValid( this ) then
            this:SetText(translates.Get("СОЗДАНИЕ.."))
        end

        if rp.gui.result.recipe then
            net.Start("rp.CraftItem")
                net.WriteString(rp.gui.result.recipe)
            net.SendToServer()
         end

        timer.Create("InventoryCraftingTimer", this.TimeCrafting, 1, function()
            if IsValid(this) then 
                this:CanCraftItem( rp.gui.result.recipe );
                this:SetText( translates.Get("СОЗДАТЬ") );
                RecipesPnl.CraftTimeStart = nil
            end
        end)
    end
    craft_btn.CanCraftItem = function( this, k )
        local isCan, items = rp.IsCanCraftItem( LocalPlayer():getInv(), rp.item.recipes[k] );
        this:SetDisabled( not isCan );
        return isCan
    end
    rp.gui.craftButton = self.CraftContainer.ResultsContainer.CraftButton;
    self.InventoryContainer = vgui.Create( "Panel", self );
    self.InventoryContainer.Dock( self.InventoryContainer, FILL );

    self.InventoryContainer.Label = vgui.Create( "DLabel", self.InventoryContainer );
    local inv_lab = self.InventoryContainer.Label;
    
    inv_lab:Dock( TOP );
    inv_lab:DockMargin( 0, 0, 0, self.ContentSpacing );
    inv_lab:SetFont( "rpui.Fonts.CraftingMenu.Title" );
    inv_lab:SetTextColor( rpui.UIColors.White );
    inv_lab:SetText( translates.Get("ИНВЕНТАРЬ") );
    inv_lab:SizeToContentsY();

    self.InventoryContainer.InvScroll = vgui.Create( "rpui.ScrollPanel", self.InventoryContainer );
    local inv_scr = self.InventoryContainer.InvScroll;
    
    inv_scr:Dock( LEFT );

    self.InventoryContainer.PlayerInventory = vgui.Create( "rpui.Inventory" );
    local ply_inv = self.InventoryContainer.PlayerInventory;
    
    ply_inv:Dock( LEFT );
    ply_inv.widthFrame   = self.invFrameScale;
    ply_inv.heightFrame  = self.invFrameScale;
    ply_inv.spacingFrame = self.ContentSpacing;
    ply_inv:setInventory( LocalPlayer():getInv() );
    rp.gui.inv1 = self.InventoryContainer.PlayerInventory;

    inv_scr:SetWide( ply_inv:GetWide() + self.ContentSpacing * 0.8 + self.InventoryContainer.InvScroll.VBar.Width );
    inv_scr:SetScrollbarMargin( self.ContentSpacing * 0.8 );
    inv_scr:AddItem( self.InventoryContainer.PlayerInventory );
end

vgui.Register( "rpui.CraftingMenu", PANEL, "Panel" );

net.Receive("rp.CraftedItem", function()
    if not IsValid(rp.gui.craftable) then return end

    local status = net.ReadInt(8)

    local this = rp.gui.craftButton
    if IsValid(this) then
        this:SetDisabled(false)
        this:SetText(translates.Get("СОЗДАТЬ"))
    end

    if IsValid(rp.gui.RecipesPnl) then
        rp.gui.RecipesPnl.CraftTimeStart = nil
    end

    if status == 4 then
        --rp.gui.craftable.ClearItemsCrafting(rp.gui.craftable)
    end
end)
