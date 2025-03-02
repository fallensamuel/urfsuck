-- "gamemodes\\rp_base\\gamemode\\main\\menus\\qmenu_cl.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
----------------------------------------------------------------
language.Add( "qmenu", translates.Get("QMenu") );

QMenu = QMenu or {};
QMenu.Categories = QMenu.Categories or {};

QMenu.AddCategory = function( name, panelfunc, checkfunc, icon, order )
    QMenu.Categories[name] = {};

    QMenu.Categories[name].Function = panelfunc;
    QMenu.Categories[name].Check    = (type(checkfunc) == "function") and checkfunc or function() return true end;
    QMenu.Categories[name].Icon     = icon;
    QMenu.Categories[name].Order    = order or 500;
end


----------------------------------------------------------------
local spawnmenu = spawnmenu;
spawnmenu.CategoriesAccess = {};

spawnmenu.GetCategoryAccess = function( name )
    return spawnmenu.CategoriesAccess[name];
end

spawnmenu.SetCategoryAccess = function( name, func )
    spawnmenu.CategoriesAccess[name] = func;
end


----------------------------------------------------------------
local function IsSuperAdmin( ply ) return ply:GetRankTable():IsSuperAdmin(); end

spawnmenu.SetCategoryAccess( "#spawnmenu.content_tab", IsSuperAdmin );
spawnmenu.SetCategoryAccess( "#spawnmenu.category.weapons", IsSuperAdmin );
spawnmenu.SetCategoryAccess( "#spawnmenu.category.npcs", IsSuperAdmin );
spawnmenu.SetCategoryAccess( "#spawnmenu.category.entities", IsSuperAdmin );
spawnmenu.SetCategoryAccess( "#spawnmenu.category.vehicles", IsSuperAdmin );
spawnmenu.SetCategoryAccess( "#spawnmenu.category.postprocess", IsSuperAdmin );
spawnmenu.SetCategoryAccess( "#spawnmenu.category.saves", IsSuperAdmin );
spawnmenu.SetCategoryAccess( "#spawnmenu.category.dupes", IsSuperAdmin );
spawnmenu.SetCategoryAccess( "Pills", IsSuperAdmin );
spawnmenu.SetCategoryAccess( "simfphys", IsSuperAdmin );

----------------------------------------------------------------
local function InitializeQMenu()
    QMenu.ContentPanel = vgui.Create( "SpawnmenuContentPanel" );
    local Content = QMenu.ContentPanel;

    local Tree = Content.ContentNavBar.Tree;
    local SelectedDefault = false;

    for Name, Category in SortedPairsByMemberValue( QMenu.Categories, "Order" ) do
        local ContentPnl, IsDefault = Category.Function();

        if type(ContentPnl) ~= "Panel" then
            error( string.format("Tried to create a category (%s) with invalid panel!\n", Name) );
        end

        local Node = Tree:AddNode( Name, Category.Icon );

        Node.ContentPnl = ContentPnl;
        Node.ContentPnl:SetParent( Content );
        Node.ContentPnl:SetVisible( false );

        Node.Check = Category.Check;

        Node.DoClick = function( self )
            if self.ContentPnl.DoPopulate then
                self:DoPopulate();
            end

            Content:SwitchPanel( self.ContentPnl );
        end

        if IsDefault and not SelectedDefault then
            Node:InternalDoClick();
            SelectedDefault = true
        end
    end

    if not SelectedDefault then
        local FirstNode = Tree:Root():GetChildNode( 0 );
        if IsValid( FirstNode ) then
            FirstNode:InternalDoClick();
        end
    end

    return Content;
end


----------------------------------------------------------------
local qmenu_spawnmenu_label = translates.Get( "Доступное" );
spawnmenu.AddCreationTab( qmenu_spawnmenu_label, InitializeQMenu, "icon16/brick.png", -100 );


----------------------------------------------------------------
hook.Add( "QMenuOpened", "QMenu::NodeCheck", function( Content, Tree )
    local ply = LocalPlayer();

    for _, node in ipairs( Tree:Root():GetChildNodes() ) do
        local bActive = node.Check( ply );

        if not bActive then
            if Tree:GetSelectedItem() == node then
                Content:SwitchPanel();
            end
        end

        node:SetVisible( bActive );
        node:GetParent():InvalidateLayout( true );
    end
end );

----------------------------------------------------------------
hook.Add( "SpawnMenuOpen", "QMenu::SpawnMenuOpened", function()
    local menu = g_SpawnMenu;

    if not IsValid( menu ) then return end
    if not IsValid( menu.CreateMenu ) then return end

    local ply = LocalPlayer();

    -- SpawnMenu:
    for _, item in pairs( menu.CreateMenu:GetItems() ) do
        local Tab = item.Tab;

        local AccessFunc = spawnmenu.CategoriesAccess[item.Name];
        if AccessFunc then
            local b = AccessFunc( ply );

            Tab:SetVisible( b );
            Tab.QMenu_Hidden = (b == false) and true or nil;

            continue
        end

        if (not Tab:IsVisible()) and Tab.QMenu_Hidden then
            Tab:SetVisible( true );
            Tab.QMenu_Hidden = nil;
        end
    end

    menu.CreateMenu.tabScroller:InvalidateLayout( true );

    -- QMenu:
    timer.Simple( RealFrameTime(), function()
        if not IsValid( QMenu.TabPanel ) then
            for _, item in ipairs( menu.CreateMenu:GetItems() ) do
                if item.Name ~= qmenu_spawnmenu_label then continue end
                QMenu.TabPanel = item.Tab;
                break
            end
        end

        -- Trigger -> OnActiveTabChanged:
        if not menu.CreateMenu.QMenuInjection then
            local __OnActiveTabChanged = menu.CreateMenu.OnActiveTabChanged;

            menu.CreateMenu.OnActiveTabChanged = function( self, old, new )
                if __OnActiveTabChanged then
                    __OnActiveTabChanged( self, old, new );
                end

                if IsValid( QMenu.TabPanel ) and IsValid( QMenu.ContentPanel ) then
                    if new == QMenu.TabPanel then
                        hook.Run( "QMenuOpened", QMenu.ContentPanel, QMenu.ContentPanel.ContentNavBar.Tree );
                    end
                end
            end

            menu.CreateMenu.QMenuInjection = true;
        end

        -- Trigger -> ActiveTab:
        if IsValid( QMenu.TabPanel ) and IsValid( QMenu.ContentPanel ) then
            if menu.CreateMenu:GetActiveTab() == QMenu.TabPanel then
                hook.Run( "QMenuOpened", QMenu.ContentPanel, QMenu.ContentPanel.ContentNavBar.Tree );
            end
        end
    end );
end );