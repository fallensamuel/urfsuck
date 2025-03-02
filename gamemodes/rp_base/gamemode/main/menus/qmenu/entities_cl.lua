-- "gamemodes\\rp_base\\gamemode\\main\\menus\\qmenu\\entities_cl.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local trCache = {
    Ents        = translates.Get( "Энтити" ),
    Before      = translates.Get( "ДОСТУПНО ЧЕРЕЗ" ),
    NoAccess    = translates.Get( "НЕДОСТУПНО" ),
    NoAccessSub = translates.Get( "ДЛЯ ВАС" ),
};

QMenu.AddCategory( trCache.Ents,
    function()
        local TimeStamp = {
            ["Seconds"] = {
                [0] = translates.Get("СЕКУНД"),
                [1] = translates.Get("СЕКУНДУ"),
                [2] = translates.Get("СЕКУНДЫ"),
                [3] = translates.Get("СЕКУНДЫ"),
                [4] = translates.Get("СЕКУНДЫ"),
            },
            ["Minutes"] = {
                [0] = translates.Get("МИНУТ"),
                [1] = translates.Get("МИНУТУ"),
                [2] = translates.Get("МИНУТЫ"),
                [3] = translates.Get("МИНУТЫ"),
                [4] = translates.Get("МИНУТЫ"),
            },
            ["Hours"] = {
                [0] = translates.Get("ЧАСОВ"),
                [1] = translates.Get("ЧАС"),
                [2] = translates.Get("ЧАСА"),
                [3] = translates.Get("ЧАСА"),
                [4] = translates.Get("ЧАСА"),
            },
            ["Days"] = {
                [0] = translates.Get("ДНЕЙ"),
                [1] = translates.Get("ДЕНЬ"),
                [2] = translates.Get("ДНЯ"),
                [3] = translates.Get("ДНЯ"),
                [4] = translates.Get("ДНЯ"),
            }
        }
        
        local function GetFormattedTime( Time )
            local Days    = math.floor(Time / 86400);
            local Hours   = math.floor((Time - Days * 86400) / 3600);
            local Minutes = math.floor((Time - Days * 86400 - Hours * 3600) / 60);
            local Seconds = math.floor((Time - Days * 86400 - Hours * 3600) % 60);
        
            if Days > 0 then
                return Days .. " " .. (TimeStamp["Days"][Days % 10] or TimeStamp["Days"][0]);
            end
        
            if Hours > 0 then
                return Hours .. " " .. (TimeStamp["Hours"][Hours % 10] or TimeStamp["Hours"][0]);
            end
        
            if (Minutes > 0) and (Time >= 60) then
                return Minutes .. " " .. (TimeStamp["Minutes"][Minutes % 10] or TimeStamp["Minutes"][0]);
            end
        
            if Seconds > 0 then
                return Seconds .. " " .. (TimeStamp["Seconds"][Seconds % 10] or TimeStamp["Seconds"][0]);
            end
        end
        
        local matCache = {
            Normal = Material( "gui/ContentIcon-normal.png" ),
            Hovered = Material( "gui/ContentIcon-hovered.png" ),
            CanAccess = {
                [true]  = Material( "rpui/backgrounds/blank/aqua" ),
                [false] = Material( "rpui/backgrounds/blank/red" ),
            }
        };

        local EntityPanel = vgui.Create( "ContentContainer" );
        EntityPanel:SetTriggerSpawnlistChange( false );

        EntityPanel.Populate = function( self, data )
            for Key, Entity in SortedPairsByMemberValue( data, "Time" ) do
                Unlock = (Entity.Time or 0) - LocalPlayer():GetCustomPlayTime( "QEntities" );
                
                if Entity.type and (not Entity.Time) then
                    local CType = spawnmenu.GetContentType( Entity.type );

                    if CType then
                        CType( self, Entity );
                    end

                    continue
                end

                Entity.Background = "rpui/backgrounds/blank/aqua";
                Entity.NiceName   = Entity.PrintName or Entity.Name or Entity.ClassName;
                
                if Entity.Price then
                    Entity.NiceName = string.format( "%s (%s)", Entity.NiceName, Entity.Price );
                end

                local Object = spawnmenu.CreateContentIcon( Entity.ScriptedEntityType or "entity", self, {
                    nicename  = Entity.NiceName,
                    spawnname = Entity.SpawnName,
                    material  = Entity.Background,
                    admin     = false,
                } );

                if not Object then
                    ErrorNoHalt( string.format("[QMenu]: Bad Entity! (%s)", Key) );
                    continue
                end
                
                if Entity.CustomClick then
                    Object.DoClick       = Entity.CustomClick;
                    Object.DoMiddleClick = Entity.CustomClick;
                    Object.OpenMenu      = Entity.CustomClick;
                    Object.OpenMenuExtra = Entity.CustomClick;
                end

                Object.Paint = function( this, w, h )    
                    if this.Depressed and (not this.Dragging) then
                        if this.Border ~= 8 then
                            this.Border = 8;
                            this:OnDepressionChanged( true );
                        end
                    else
                        if this.Border ~= 0 then
                            this.Border = 0;
                            this:OnDepressionChanged (false );
                        end
                    end
    
                    render.PushFilterMag( TEXFILTER.ANISOTROPIC ); render.PushFilterMin( TEXFILTER.ANISOTROPIC );
                    local offset, size = 4 + this.Border, 128 - 8 - this.Border * 2;
                    this.Image:PaintAt( offset, offset, size, size );
                    render.PopFilterMin(); render.PopFilterMag();
                end

                Object.VGUI = Object:GetChildren()[2];
                local parent = Object.VGUI:GetParent();

                -- IconViewer:
                if Entity.ListModel then
                    Object.IconViewer = vgui.Create( "SpawnIcon", parent );
                    Object.IconViewer:SetModel( Entity.ListModel );
                    Object.IconViewer.Paint = nil;
                elseif Entity.ListIcon then
                    Object.IconViewer = vgui.Create( "DImage", parent );
                    Object.IconViewer:SetImage( Entity.ListIcon );
                end

                if IsValid( Object.IconViewer ) then
                    Object.IconViewer:SetTooltip( Object.VGUI:GetText() );

                    local offset = 10 * (Entity.icoMinusScale or 1) * 2;
                    Object.IconViewer:SetSize( parent:GetWide() - offset, parent:GetTall() - offset );
                    Object.IconViewer:Center();

                    Object.IconViewer.LocalObject = Object;
                    Object.IconViewer.OverlayFade = 0;
                    Object.IconViewer.DoClick     = Object.DoClick;
                end

                -- Foreground:
                Object.FakeForeground = vgui.Create( "DButton", Object );
                Object.FakeForeground:SetSize( Object:GetSize() );
                Object.FakeForeground:Center();

                Object.FakeForeground.LocalObject = Object;
                Object.FakeForeground.Image       = Object.FakeForeground.LocalObject.Image;
                Object.FakeForeground.Border      = 0;

                Object.FakeForeground.Label = Object.FakeForeground.LocalObject.Label;
                Object.FakeForeground.Label:SetParent( Object.FakeForeground );

                Object.FakeForeground.DoClick      = Object.FakeForeground.LocalObject.DoClick;
                Object.FakeForeground.DoRightCLick = Object.FakeForeground.LocalObject.DoRightClick;

                Object.FakeForeground.Paint = function( this, w, h )
                    if (not dragndrop.IsDragging()) and (this:IsHovered() or this.Depressed or this:IsChildHovered()) then
                        surface.SetMaterial( matCache.Hovered );
                        this.Label:Hide();
                    else
                        surface.SetMaterial( matCache.Normal );
                        this.Label:Show();
                    end

                    surface.DrawTexturedRect( this.Border, this.Border, w - this.Border * 2, h - this.Border * 2 );
                    return true
                end

                -- Panel:
                local Panel = vgui.Create( "DPanel", parent );
                Panel:SetSize( parent:GetWide(), parent:GetTall() );
                Panel:Center();

                Panel.UnlockTime = Entity.Time;

                Panel.Paint = function( this, w, h )
                    local cw, ch = w * 0.5, h * 0.5;
                    draw.SimpleText( this.title    or "", "rpui.Fonts.Spawnmenu.Title",    cw, ch, rpui.UIColors.White, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM );
                    draw.SimpleText( this.subtitle or "", "rpui.Fonts.Spawnmenu.SubTitle", cw, ch, rpui.UIColors.White, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP );
                end

                Panel.NextObject = Object;
                if IsValid( Panel.NextObject.IconViewer ) then
                    Panel.NextObject.IconViewer:SetVisible( false );
                end

                local untime;
                Panel.title = "";
                Panel.Think = function( this )
                    if (this.CD or 0) > SysTime() then return end

                    Object.IsAccess = this.title == "";
                    Object.Image:SetMaterial( matCache.CanAccess[Object.IsAccess] or matCache.CanAccess[false] );
                    if IsValid( this.NextObject.IconViewer ) then
                        this.NextObject.IconViewer:SetVisible( Object.IsAccess );
                    end
                    this:SetAlpha( Object.IsAccess and 0 or 255 );
                    this:SetMouseInputEnabled( not Object.IsAccess );

                    this.CD = SysTime() + 1;

                    local noaccess;
                    if Entity.access and (not Entity.access(LocalPlayer(), Entity)) then
                        noaccess = true;
                    end

                    untime        = (this.UnlockTime or 0) - LocalPlayer():GetCustomPlayTime("QEntities");
                    this.unlocked = untime <= 0;

                    if this.unlocked and not noaccess then
                        this.title = "";
                        return
                    end

                    if noaccess then
                        this.title, this.subtitle = trCache.NoAccess, trCache.NoAccessSub;
                    end

                    this.title, this.subtitle = trCache.Before, GetFormattedTime( untime );

                    if Entity.access then
                        this.title, this.subtitle = trCache.NoAccess, trCache.NoAccessSub;
                    end
                end
            end
        end

        --
        local Categories = {};
        hook.Run( "PopulateQMenuEntities", Categories );

        for Category, Data in SortedPairs( Categories ) do
            local Header = spawnmenu.CreateContentIcon( "header", EntityPanel, {
                text = Category
            } );

            EntityPanel:Populate( Data );
        end
        --

        return EntityPanel;
    end,
nil, "icon16/bricks.png", 300 );


hook.Add( "PopulateQMenuEntities", "qmenu-entities", function( c )
    local sents = list.Get( "SpawnableEntities" );
    if sents then
        for Key, Value in pairs( sents ) do
            local obj = rp.QObjects[Value.ClassName];
            if obj == nil then continue end

            Value.Name = obj.name;

            Value.SpawnName = Key;
            Value.Time      = obj.time;
            Value.Limit     = obj.limit;
            Value.PrintName = Value.Name;
            Value.ListModel = obj.model;
            Value.ListIcon  = obj.ListIcon;

            if obj.price then
                Value.Price = rp.FormatMoney( obj.price );
            end
            
            local cat = obj.category or trCache.Ents;
            c[cat] = c[cat] or {};
            table.insert( c[cat], Value );
        end
    end
end );

hook.Add( "PopulateQMenuEntities", "qmenu-npcs", function( c )
    local npcs = list.Get( "NPC" );
    if npcs then
        for Key, Value in pairs( npcs ) do
            local obj = rp.QObjects[Value.Class];
            if obj == nil then continue end

            Value.ScriptedEntityType = "npc";
            Value.Name = obj.name;

            Value.SpawnName = Key;
            Value.ClassName = Value.Class;
            Value.Time      = obj.time;
            Value.Limit     = obj.limit;
            Value.PrintName = Value.Name;
            Value.ListModel = obj.model;
            Value.ListIcon  = obj.ListIcon;

            if obj.price then
                Value.Price = rp.FormatMoney( obj.price );
            end
            
            local cat = obj.category or trCache.Ents;
            c[cat] = c[cat] or {};
            table.insert( c[cat], Value );
        end
    end
end );

hook.Add( "PopulateQMenuEntities", "qmenu-vehicles", function( c )
    local vehicles = list.Get( "Vehicles" );
    if vehicles then
        for Key, Value in pairs( vehicles ) do
            local obj = rp.QObjects[Key];
            if obj == nil then continue end

            Value.ScriptedEntityType = "vehicle";
            Value.Name = obj.name;

            Value.SpawnName = Key;
            Value.ClassName = Key; --Value.Class
            Value.Time      = obj.time;
            Value.Limit     = obj.limit;
            Value.PrintName = Value.Name;
            Value.ListModel = obj.model;
            Value.ListIcon  = obj.ListIcon;

            if obj.price then
                Value.Price = rp.FormatMoney( obj.price );
            end
            
            local cat = obj.category or trCache.Ents;
            c[cat] = c[cat] or {};
            table.insert( c[cat], Value );
        end
    end
end );

hook.Add( "PopulateQMenuEntities", "qmenu-ammunition", function( c )
    for class, obj in pairs( rp.QAmmo ) do
        obj.ScriptedEntityType = "entity";

        obj.Name = obj.name or class;

        obj.SpawnName = obj.Name;
        obj.ClassName = class; --obj.Class
        obj.Time      = obj.time;
        obj.Limit     = obj.limit;
        obj.PrintName = obj.Name;
        obj.ListModel = obj.model;
        
        if obj.price then
            obj.PrintName = string.format( "%s (%s)", obj.PrintName, rp.FormatMoney(obj.price) );
        end
    
        obj.CustomClick = function()
            RunConsoleCommand( "gm_buyammo", class );
        end
            
        local cat = obj.category or trCache.Ents;
        c[cat] = c[cat] or {};
        table.insert( c[cat], obj );
    end
end );