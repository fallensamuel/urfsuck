-- "gamemodes\\rp_base\\gamemode\\main\\cosmetics\\belts\\belts_cl.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
hook.Add( "PopulateContextMenuAdditionals", "InventoryContext_PopulateBelts", function( gContextMenu )
    rp.ContextMenu.Panels.InventoryBeltMenu = vgui.Create( "DPanel", gContextMenu );
    rp.ContextMenu.Panels.InventoryBeltMenu.Paint = function( this, w, h )
        draw.Blur( this );
        surface.SetDrawColor( rpui.UIColors.Background ); // rpui.UIColors.Background
        surface.DrawRect( 0, 0, w, h );
    end

    rp.ContextMenu.Panels.InventoryBeltMenu.Title = vgui.Create( "DLabel", rp.ContextMenu.Panels.InventoryBeltMenu );
    rp.ContextMenu.Panels.InventoryBeltMenu.Title:Dock( TOP );
    rp.ContextMenu.Panels.InventoryBeltMenu.Title:InvalidateParent( true );
    rp.ContextMenu.Panels.InventoryBeltMenu.Title:SetText( translates.Get("ПОЯС") );
    rp.ContextMenu.Panels.InventoryBeltMenu.Title.Paint = function( this, w, h )
        surface.SetDrawColor(rp.cfg.UIColor.BlockHeader or rp.cfg.UIColor.SubHeader);
        surface.DrawRect( 0, 0, w, h );
        draw.SimpleText( this:GetText(), this:GetFont(), w * 0.5, h * 0.5, rp.cfg.UIColor.BlockHeaderInverted or rpui.UIColors.Black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
        return true
    end

    rp.ContextMenu.Panels.InventoryBeltMenu.Content = vgui.Create( "rpui.ScrollPanel", rp.ContextMenu.Panels.InventoryBeltMenu );
end );


hook.Add( "RefreshContextMenuAdditionals", "InventoryContext_RefreshBelts", function( frameH, frameSpacing )
    if LocalPlayer().getBeltInv and LocalPlayer():getBeltInv() then
        rp.ContextMenu.Panels.InventoryBeltMenu:SetVisible( true );
        rp.ContextMenu.Panels.InventoryBeltMenu:SetMouseInputEnabled( true );

        rp.ContextMenu.Panels.InventoryBeltMenu.Title:Dock( NODOCK );
        rp.ContextMenu.Panels.InventoryBeltMenu.Title:SetFont( "InventoryContext.Title" );
        rp.ContextMenu.Panels.InventoryBeltMenu.Title:SizeToContentsX( frameSpacing * 2 );
        rp.ContextMenu.Panels.InventoryBeltMenu.Title:SizeToContentsY( frameSpacing * 6 );
        rp.ContextMenu.Panels.InventoryBeltMenu.Title:InvalidateLayout( true );

        rp.ContextMenu.Panels.InventoryBeltMenu.Content:Dock( NODOCK );
        
        if IsValid( rp.ContextMenu.Panels.InventoryBeltMenu.Inventory ) then
            rp.ContextMenu.Panels.InventoryBeltMenu.Inventory:Remove();
        end

        rp.ContextMenu.Panels.InventoryBeltMenu.Inventory = vgui.Create( "rpui.Inventory" );
        rp.ContextMenu.Panels.InventoryBeltMenu.Inventory.widthFrame = frameH * 0.1;
        rp.ContextMenu.Panels.InventoryBeltMenu.Inventory.heightFrame = frameH * 0.1;
        rp.ContextMenu.Panels.InventoryBeltMenu.Inventory.spacingFrame = frameSpacing;
        rp.ContextMenu.Panels.InventoryBeltMenu.Inventory:setInventory( LocalPlayer():getBeltInv() );
        
        rp.ContextMenu.Panels.InventoryBeltMenu.Content:AddItem( rp.ContextMenu.Panels.InventoryBeltMenu.Inventory );
        
        rp.ContextMenu.Panels.InventoryBeltMenu.Content:InvalidateLayout( true );
        rp.ContextMenu.Panels.InventoryBeltMenu.Content:SizeToChildren( true, true );
        rp.ContextMenu.Panels.InventoryBeltMenu.Content:SetWide(frameH * 0.1 * 5 + frameSpacing * 7);
        
        rp.ContextMenu.Panels.InventoryBeltMenu:InvalidateLayout( true );
        rp.ContextMenu.Panels.InventoryBeltMenu:SizeToChildren( true, false );

        rp.ContextMenu.Panels.InventoryBeltMenu:SetTall(rp.ContextMenu.Panels.InventoryBeltMenu.Title:GetTall() + frameSpacing * 2 + rp.ContextMenu.Panels.InventoryBeltMenu.Inventory:GetTall() )
        if rp.ContextMenu.Panels.InventoryBeltMenu:GetTall() > frameH then
            rp.ContextMenu.Panels.InventoryBeltMenu.Content:SetTall( frameH - frameSpacing * 2 - rp.ContextMenu.Panels.InventoryBeltMenu.Title:GetTall() );
            rp.ContextMenu.Panels.InventoryBeltMenu:SetTall( frameH );
        end
        
        rp.ContextMenu.Panels.InventoryBeltMenu.Title:Dock( TOP );
        
        rp.ContextMenu.Panels.InventoryBeltMenu.Content:Dock( TOP );
        rp.ContextMenu.Panels.InventoryBeltMenu.Content:DockMargin( frameSpacing * 2, frameSpacing * 2, frameSpacing * 2, frameSpacing * 2 );
        rp.ContextMenu.Panels.InventoryBeltMenu.Content:InvalidateParent( true );
        rp.ContextMenu.Panels.InventoryBeltMenu.Content:SetScrollbarMargin( frameSpacing );
        
        rp.ContextMenu.Panels.InventoryBeltMenu:InvalidateLayout( true );
        rp.ContextMenu.Panels.InventoryBeltMenu:SizeToChildren( false, true );

        rp.ContextMenu.Panels.InventoryBeltMenu:SetTall(rp.ContextMenu.Panels.InventoryBeltMenu.Title:GetTall() + frameSpacing * 2 + rp.ContextMenu.Panels.InventoryBeltMenu.Inventory:GetTall() )
        if rp.ContextMenu.Panels.InventoryBeltMenu:GetTall() > frameH then
            rp.ContextMenu.Panels.InventoryBeltMenu.Content:SetTall( frameH - frameSpacing * 2 - rp.ContextMenu.Panels.InventoryBeltMenu.Title:GetTall() );
            rp.ContextMenu.Panels.InventoryBeltMenu:SetTall( frameH );
        end
        
        rp.ContextMenu.Panels.InventoryBeltMenu:SetWide( rp.ContextMenu.Panels.InventoryBeltMenu:GetWide() + frameSpacing * 2 );
        rp.ContextMenu.Panels.InventoryBeltMenu:SetTall( rp.ContextMenu.Panels.InventoryBeltMenu:GetTall() + frameSpacing * 2 );

        rp.ContextMenu.Panels.InventoryBeltMenu.x = ScrW() - rp.ContextMenu.Panels.InventoryBeltMenu:GetWide();
        rp.ContextMenu.Panels.InventoryBeltMenu:CenterVertical();
    else
        rp.ContextMenu.Panels.InventoryBeltMenu:SetVisible( false );
        rp.ContextMenu.Panels.InventoryBeltMenu:SetMouseInputEnabled( false );
    end
end );


hook.Add( "ContextMenuAdditionalsVisibility", "InventoryContext_VisibilityBelts", function( vis )
    if IsValid( rp.ContextMenu.Panels.InventoryBeltMenu ) and (LocalPlayer().getBeltInv and LocalPlayer():getBeltInv()) and rp.ContextMenu.Panels.InventoryBeltMenu:IsVisible() then
        rp.ContextMenu.Panels.InventoryBeltMenu:SetVisible( vis );
    end
end );