-- "gamemodes\\rp_base\\gamemode\\main\\cosmetics\\bags\\bags_cl.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
hook.Add( "PopulateContextMenuAdditionals", "InventoryContext_PopulateBags", function( gContextMenu )
    rp.ContextMenu.Panels.InventoryBagMenu = vgui.Create( "DPanel", gContextMenu );
    rp.ContextMenu.Panels.InventoryBagMenu.Paint = function( this, w, h )
        draw.Blur( this );
        surface.SetDrawColor( rpui.UIColors.Background ); // rpui.UIColors.Background
        surface.DrawRect( 0, 0, w, h );
    end

    rp.ContextMenu.Panels.InventoryBagMenu.Title = vgui.Create( "DLabel", rp.ContextMenu.Panels.InventoryBagMenu );
    rp.ContextMenu.Panels.InventoryBagMenu.Title:Dock( TOP );
    rp.ContextMenu.Panels.InventoryBagMenu.Title:InvalidateParent( true );
    rp.ContextMenu.Panels.InventoryBagMenu.Title:SetText( translates.Get("СУМКА") );
    rp.ContextMenu.Panels.InventoryBagMenu.Title.Paint = function( this, w, h )
        surface.SetDrawColor(rp.cfg.UIColor.BlockHeader or rp.cfg.UIColor.SubHeader);
        surface.DrawRect( 0, 0, w, h );
        draw.SimpleText( this:GetText(), this:GetFont(), w * 0.5, h * 0.5, rp.cfg.UIColor.BlockHeaderInverted or rpui.UIColors.Black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
        return true
    end

    rp.ContextMenu.Panels.InventoryBagMenu.Content = vgui.Create( "rpui.ScrollPanel", rp.ContextMenu.Panels.InventoryBagMenu );
end );


hook.Add( "RefreshContextMenuAdditionals", "InventoryContext_RefreshBags", function( frameH, frameSpacing )
    if LocalPlayer().getBagInv and LocalPlayer():getBagInv() then
        rp.ContextMenu.Panels.InventoryBagMenu:SetVisible( true );
        rp.ContextMenu.Panels.InventoryBagMenu:SetMouseInputEnabled( true );

        rp.ContextMenu.Panels.InventoryBagMenu.Title:Dock( NODOCK );
        rp.ContextMenu.Panels.InventoryBagMenu.Title:SetFont( "InventoryContext.Title" );
        rp.ContextMenu.Panels.InventoryBagMenu.Title:SizeToContentsX( frameSpacing * 2 );
        rp.ContextMenu.Panels.InventoryBagMenu.Title:SizeToContentsY( frameSpacing * 6 );
        rp.ContextMenu.Panels.InventoryBagMenu.Title:InvalidateLayout( true );

        rp.ContextMenu.Panels.InventoryBagMenu.Content:Dock( NODOCK );
        
        if IsValid( rp.ContextMenu.Panels.InventoryBagMenu.Inventory ) then
            rp.ContextMenu.Panels.InventoryBagMenu.Inventory:Remove();
        end

        rp.ContextMenu.Panels.InventoryBagMenu.Inventory = vgui.Create( "rpui.Inventory" );
        rp.ContextMenu.Panels.InventoryBagMenu.Inventory.widthFrame = frameH * 0.1;
        rp.ContextMenu.Panels.InventoryBagMenu.Inventory.heightFrame = frameH * 0.1;
        rp.ContextMenu.Panels.InventoryBagMenu.Inventory.spacingFrame = frameSpacing;
        rp.ContextMenu.Panels.InventoryBagMenu.Inventory:setInventory( LocalPlayer():getBagInv() );
        
        rp.ContextMenu.Panels.InventoryBagMenu.Content:AddItem( rp.ContextMenu.Panels.InventoryBagMenu.Inventory );
        
        rp.ContextMenu.Panels.InventoryBagMenu.Content:InvalidateLayout( true );
        rp.ContextMenu.Panels.InventoryBagMenu.Content:SizeToChildren( true, true );
        rp.ContextMenu.Panels.InventoryBagMenu.Content:SetWide(frameH * 0.1 * 5 + frameSpacing * 7);
        
        rp.ContextMenu.Panels.InventoryBagMenu:InvalidateLayout( true );
        rp.ContextMenu.Panels.InventoryBagMenu:SizeToChildren( true, false );

        rp.ContextMenu.Panels.InventoryBagMenu:SetTall(rp.ContextMenu.Panels.InventoryBagMenu.Title:GetTall() + frameSpacing * 2 + rp.ContextMenu.Panels.InventoryBagMenu.Inventory:GetTall() )
        if rp.ContextMenu.Panels.InventoryBagMenu:GetTall() > frameH then
            rp.ContextMenu.Panels.InventoryBagMenu.Content:SetTall( frameH - frameSpacing * 2 - rp.ContextMenu.Panels.InventoryBagMenu.Title:GetTall() );
            rp.ContextMenu.Panels.InventoryBagMenu:SetTall( frameH );
        end
        
        rp.ContextMenu.Panels.InventoryBagMenu.Title:Dock( TOP );
        
        rp.ContextMenu.Panels.InventoryBagMenu.Content:Dock( TOP );
        rp.ContextMenu.Panels.InventoryBagMenu.Content:DockMargin( frameSpacing * 2, frameSpacing * 2, frameSpacing * 2, frameSpacing * 2 );
        rp.ContextMenu.Panels.InventoryBagMenu.Content:InvalidateParent( true );
        rp.ContextMenu.Panels.InventoryBagMenu.Content:SetScrollbarMargin( frameSpacing );
        
        rp.ContextMenu.Panels.InventoryBagMenu:InvalidateLayout( true );
        rp.ContextMenu.Panels.InventoryBagMenu:SizeToChildren( false, true );

        rp.ContextMenu.Panels.InventoryBagMenu:SetTall(rp.ContextMenu.Panels.InventoryBagMenu.Title:GetTall() + frameSpacing * 2 + rp.ContextMenu.Panels.InventoryBagMenu.Inventory:GetTall() )
        if rp.ContextMenu.Panels.InventoryBagMenu:GetTall() > frameH then
            rp.ContextMenu.Panels.InventoryBagMenu.Content:SetTall( frameH - frameSpacing * 2 - rp.ContextMenu.Panels.InventoryBagMenu.Title:GetTall() );
            rp.ContextMenu.Panels.InventoryBagMenu:SetTall( frameH );
        end
        
        rp.ContextMenu.Panels.InventoryBagMenu:SetWide( rp.ContextMenu.Panels.InventoryBagMenu:GetWide() + frameSpacing * 2 );
        rp.ContextMenu.Panels.InventoryBagMenu:SetTall( rp.ContextMenu.Panels.InventoryBagMenu:GetTall() + frameSpacing * 2 );

        rp.ContextMenu.Panels.InventoryBagMenu.x = ScrW() - rp.ContextMenu.Panels.InventoryBagMenu:GetWide();
        rp.ContextMenu.Panels.InventoryBagMenu:CenterVertical();
    else
        rp.ContextMenu.Panels.InventoryBagMenu:SetVisible( false );
        rp.ContextMenu.Panels.InventoryBagMenu:SetMouseInputEnabled( false );
    end
end );


hook.Add( "ContextMenuAdditionalsVisibility", "InventoryContext_VisibilityBags", function( vis )
    if IsValid( rp.ContextMenu.Panels.InventoryBagMenu ) and (LocalPlayer().getBagInv and LocalPlayer():getBagInv()) and rp.ContextMenu.Panels.InventoryBagMenu:IsVisible() then
        rp.ContextMenu.Panels.InventoryBagMenu:SetVisible( vis );
    end
end );