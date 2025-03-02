if rp.cfg.DisableQEntities then return end

local Insert = table.insert
local Date = os.date
local Floor = math.floor
local Text = draw.SimpleText
local Exists = file.Exists
local BaseClass = baseclass.Get
local Center = TEXT_ALIGN_CENTER

local matOverlay_Normal = Material( "gui/ContentIcon-normal.png" )
local matOverlay_Hovered = Material( "gui/ContentIcon-hovered.png" )
local matOverlay_AdminOnly = Material( "icon16/shield.png" )

surface.CreateFont('rpui.Fonts.Spawnmenu.Title', {
    font = 'Montserrat',
    extended = true,
    weight = 500,
    size = 14
})

surface.CreateFont('rpui.Fonts.Spawnmenu.SubTitle', {
    font = 'Montserrat',
    extended = true,
    weight = 1000,
    size = 18
})

local AllowedProps = {}

local function GetLangString(String)
    return translates and translates.Get(String) or String
end

local TimeStamp = {
    ['Seconds'] = {
        [0] = translates.Get('СЕКУНД'),
        [1] = translates.Get('СЕКУНДУ'),
        [2] = translates.Get('СЕКУНДЫ'),
        [3] = translates.Get('СЕКУНДЫ'),
        [4] = translates.Get('СЕКУНДЫ'),
    },
    ['Minutes'] = {
        [0] = translates.Get('МИНУТ'),
        [1] = translates.Get('МИНУТУ'),
        [2] = translates.Get('МИНУТЫ'),
        [3] = translates.Get('МИНУТЫ'),
        [4] = translates.Get('МИНУТЫ'),
    },
    ['Hours'] = {
        [0] = translates.Get('ЧАСОВ'),
        [1] = translates.Get('ЧАС'),
        [2] = translates.Get('ЧАСА'),
        [3] = translates.Get('ЧАСА'),
        [4] = translates.Get('ЧАСА'),
    },
    ['Days'] = {
        [0] = translates.Get('ДНЕЙ'),
        [1] = translates.Get('ДЕНЬ'),
        [2] = translates.Get('ДНЯ'),
        [3] = translates.Get('ДНЯ'),
        [4] = translates.Get('ДНЯ'),
    }
}

local Days, Hours, Minutes, Seconds
local function GetFormattedTime(Time)
    Days = Floor(Time / 86400)
    Hours = Floor((Time - Days * 86400) / 3600)
    Minutes = Floor((Time - Days * 86400 - Hours * 3600) / 60)
    Seconds = Floor((Time - Days * 86400 - Hours * 3600) % 60)

    if (Days > 0) then return Days .. ' ' .. (TimeStamp['Days'][Days % 10] or TimeStamp['Days'][0]) end
    if (Hours > 0) then return Hours .. ' ' .. (TimeStamp['Hours'][Hours % 10] or TimeStamp['Hours'][0]) end
    if (Minutes > 0 and Time >= 60) then return Minutes .. ' ' .. (TimeStamp['Minutes'][Minutes % 10] or TimeStamp['Minutes'][0]) end
    if (Seconds > 0) then return Seconds .. ' ' .. (TimeStamp['Seconds'][Seconds % 10] or TimeStamp['Seconds'][0]) end
end

local LProps = GetLangString('Пропы')
local LEnts = GetLangString('Энтити')
local LBefore = GetLangString('ДОСТУПНО ЧЕРЕЗ')
local NoAccess = GetLangString("НЕДОСТУПНО")
local NoAccess_sub = GetLangString("ДЛЯ ВАС")

local Icons = {
    [LProps] = 'icon16/brick.png',
    [LEnts] = 'icon16/bricks.png'
}

local Categories = {
    [LProps] = {},
    [LEnts] = {}
}

local DefaultCategories = {
    [LProps] = true,
    [LEnts] = true,
}

function rp.SetQCategoryIcon(name, mat)
    if Icons[name] then
        Icons[name] = mat
    end
end

hook.Add('PopulateFreeEntities', 'AddFreeEntityContent', function(Content, Tree, Node)
    local Entities = list.Get('SpawnableEntities')

    if (Entities) then
        for Key, Value in pairs(Entities) do
            local obj = rp.QObjects[Value.ClassName]
            if obj == nil then continue end
            Value.SpawnName = Key
            Value.Time = obj.time
            Value.Limit = obj.limit
            Value.Name = obj.name
            Value.ListModel = obj.model
            Value.PrintName = Value.Name
            Value.ListIcon = obj.ListIcon

            if obj.price then
                Value.Price = rp.FormatMoney(obj.price)
            end
            
            local cat = obj.category or LEnts
            Categories[cat] = Categories[cat] or {}
            Insert(Categories[cat], Value)
        end
    end
    
    local NPCs = list.Get('NPC')

    if (NPCs) then
        for Key, Value in pairs(NPCs) do
            local obj = rp.QObjects[Value.Class]
            if obj == nil then continue end
            Value.SpawnName = Key
            Value.ClassName = Value.Class
            Value.Time = obj.time
            Value.Limit = obj.limit
            Value.Name = obj.name
            Value.ListModel = obj.model
            Value.ScriptedEntityType = 'npc'
            Value.ListIcon = obj.ListIcon

            Value.PrintName = Value.Name
            if obj.price then
                Value.Price = rp.FormatMoney(obj.price)
            end
            
            local cat = obj.category or LEnts
            Categories[cat] = Categories[cat] or {}
            Insert(Categories[cat], Value)
        end
    end

    local Vehicles = list.Get('Vehicles')

    if (Vehicles) then
        for Key, Value in pairs(Vehicles) do
            local obj = rp.QObjects[Key]
            if obj == nil then continue end
            Value.SpawnName = Key
            Value.ClassName = Key--Value.Class
            Value.Time = obj.time
            Value.Limit = obj.limit
            Value.PrintName = obj.name or Value.Name
            if obj.price then
                Value.Price = rp.FormatMoney(obj.price)
            end
            Value.Name = obj.name
            Value.ListModel = obj.model
            Value.ScriptedEntityType = 'vehicle'
            Value.ListIcon = obj.ListIcon
            
            local cat = obj.category or LEnts
            Categories[cat] = Categories[cat] or {}
            Insert(Categories[cat], Value)
        end
    end

    for class, obj in pairs(rp.QAmmo) do
        obj.Name = obj.name or class
        obj.SpawnName = obj.Name
        obj.ClassName = class--obj.Class
        obj.Time = obj.time
        obj.Limit = obj.limit
        obj.PrintName = obj.Name
        if obj.price then
            obj.PrintName = obj.PrintName .." (".. rp.FormatMoney(obj.price) ..")"
        end
        obj.ListModel = obj.model
        obj.ScriptedEntityType = 'entity'

        obj.CustomClick = function(me)
            RunConsoleCommand("gm_buyammo", class)
        end
            
        local cat = obj.category or LEnts
        Categories[cat] = Categories[cat] or {}
        Insert(Categories[cat], obj)
    end

    Categories[LProps] = AllowedProps

    local CreateNodeContents = function(self, Category, Data)
        self.ContentsCreated = true

        --PrintTable(Data)
            
        local Object, Unlock, Label, Mat
        for Key, Entity in SortedPairsByMemberValue(Data, (Category == LEnts and 'Time') or 'model') do
            Unlock = (Entity.Time or 0) - (LocalPlayer():GetCustomPlayTime('QEntities'))
            --Mat = 'entities/' .. (Entity.SpawnName or '') .. '.png'
                
            if (!Entity.Time) and Entity.type then
                local CP = spawnmenu.GetContentType(Entity.type)
                if (CP) then CP(self.PropPanel, Entity) end
                continue
            end

            Mat = 'rpui/backgrounds/blank/aqua' --if (!Exists('materials/' .. Mat, 'GAME')) then Mat = 'rpui/backgrounds/blank/aqua' end
            --if (Unlock > 0) then Mat = 'rpui/backgrounds/blank/red' end

            local printname = Entity.PrintName or Entity.Name or Entity.ClassName
            if Entity.Price then printname = printname .." (".. Entity.Price ..")" end
            Object = spawnmenu.CreateContentIcon(Entity.ScriptedEntityType or 'entity', self.PropPanel, {
                nicename = printname,
                spawnname = Entity.SpawnName,
                material = Mat,
                admin = false
            })

            Mat = Material(Mat)
            self._ChildParentPnl = Object:GetParent()
            Object._Data = Entity

            if Entity.CustomClick then
                Object.DoClick = Entity.CustomClick
                Object.DoMiddleClick = Entity.CustomClick
                Object.OpenMenuExtra = Entity.CustomClick
                Object.OpenMenu = Entity.CustomClick
            end

            local NewMat = Material('rpui/backgrounds/blank/red')
                
            Object.Paint = function(this, w, h)
                --local _Bool = (Entity.Time or 0) - (LocalPlayer():GetCustomPlayTime('QEntities')) > 0
                --local _Bool2 = not Entity.access or Entity.access(LocalPlayer(), Entity)
                --this.IsAccess = _Bool2 or not _Bool
                --this.Image:SetMaterial(this.IsAccess and Mat or NewMat)

                if (this.Depressed && !this.Dragging) then
                    if (this.Border != 8) then
                        this.Border = 8
                        this:OnDepressionChanged(true)
                    end
                else
                    if (this.Border != 0) then
                        this.Border = 0
                        this:OnDepressionChanged(false)
                    end
                end

                render.PushFilterMag(TEXFILTER.ANISOTROPIC)
                render.PushFilterMin(TEXFILTER.ANISOTROPIC)

                this.Image:PaintAt(3 + this.Border, 3 + this.Border, 128 - 8 - this.Border * 2, 128 - 8 - this.Border * 2)

                render.PopFilterMin()
                render.PopFilterMag()
            end

            if Entity.ListModel then
                Object.IconViewer = ui.Create('SpawnIcon', function(this, parent)
                    this.LocalObject = Object
                    this:SetPos(10, 10)
                    this:SetSize(parent:GetWide() - 20, parent:GetTall() - 20)
                    this:SetModel(Entity.ListModel)
                    this:SetTooltip(Object:GetChildren()[2]:GetText())
                    this.OverlayFade = 0
                    this.Paint = nil
                    this.DoClick = Object.DoClick
                    --this.Think = function(me)
                    --    me:SetVisible(Object.IsAccess == true)
                    --end
                end, Object:GetChildren()[2]:GetParent())
            elseif Entity.ListIcon then
                Object.IconViewer = ui.Create('DImage', function(this, parent)
                    this.LocalObject = Object
                    local offset = 10 * (Entity.icoMinusScale or 1)
                    this:SetPos(offset, offset)
                    this:SetSize(parent:GetWide() - offset*2, parent:GetTall() - offset*2)
                    this:SetImage(Entity.ListIcon)
                    this:SetTooltip(Object:GetChildren()[2]:GetText())
                    this.OverlayFade = 0
                    this.DoClick = Object.DoClick
                    --this.Think = function(me)
                    --    me:SetVisible(Object.IsAccess == true)
                    --end
                end, Object:GetChildren()[2]:GetParent())
            end

            Object.FakeForeground = ui.Create('DButton', function(this, parent)
                this.LocalObject = Object
                this:SetPos(0, 0)
                this:SetSize(parent:GetWide(), parent:GetTall())
                this.Image = this.LocalObject.Image
                this.Label = this.LocalObject.Label
                this.Label:SetParent(this)
                this.Border = 0
                this.DoClick = this.LocalObject.DoClick
                this.DoRightCLick = this.LocalObject.DoRightClick
                --this:SetMouseInputEnabled(false)
                this.Paint = function(s, w, h)
                    if (!dragndrop.IsDragging() && (this:IsHovered() || this.Depressed || this:IsChildHovered())) then
                        surface.SetMaterial(matOverlay_Hovered)
                        this.Label:Hide()
                    else
                        surface.SetMaterial(matOverlay_Normal)
                        this.Label:Show()
                    end

                    surface.DrawTexturedRect(this.Border, this.Border, w - this.Border * 2, h - this.Border * 2)
                    return true
                end
            end, Object)

            if true then --(Unlock > 0 or Object.IsAccess == false) then
                ui.Create('DPanel', function(s, parent)
                    s:SetPos(0, 0)
                    s:SetSize(parent:GetWide(), parent:GetTall())

                    s.UnlockTime = Entity.Time

                    s.Paint = function(e, w, h)
                        --s:SetMouseInputEnabled(e.title and true or false)
                        Text(e.title or '', 'rpui.Fonts.Spawnmenu.Title', w * .5, h * .45, Color(255, 255, 255, 255), Center, Center)
                        Text(e.subtitle or '', 'rpui.Fonts.Spawnmenu.SubTitle', w * .5, h * .55, Color(255, 255, 255, 255), Center, Center)
                    end

                    s.NextObject = Object
                    if IsValid(s.NextObject.IconViewer) then
                        s.NextObject.IconViewer:SetVisible(false)
                    end
                    //s.NextObject.FakeForeground:SetVisible(false)

                    local untime
                    s.title = ""
                    s.Think = function(obj)
                        if (obj.CD or 0) > CurTime() then return end
                        Object.IsAccess = obj.title == ""
                        Object.Image:SetMaterial(Object.IsAccess and Mat or NewMat)
                        if IsValid(obj.NextObject.IconViewer) then obj.NextObject.IconViewer:SetVisible(Object.IsAccess) end
                        obj:SetAlpha(Object.IsAccess and 0 or 255)
                        obj:SetMouseInputEnabled(not Object.IsAccess)

                        obj.CD = CurTime() + 1
                        --if obj.unlocked then
                        local noaccess
                            if Entity.access and not Entity.access(LocalPlayer(), Entity) then
                                --obj.title = NoAccess
                                --obj.subtitle = NoAccess_sub
                                noaccess = true
                                --s.NextObject.IconViewer:SetVisible(false)
                                --s:SetAlpha(255)
                                --s:SetMouseInputEnabled(true)
                            end
                        --    return
                        --end

                        untime = (obj.UnlockTime or 0) - LocalPlayer():GetCustomPlayTime('QEntities')

                        --print(obj, untime)
                            
                        obj.unlocked = untime <= 0
                        if obj.unlocked and not noaccess then
                            --if IsValid(s.NextObject.IconViewer) then
                                --s.NextObject.IconViewer:SetVisible(true)
                                --s:SetAlpha(0)
                                --s:SetMouseInputEnabled(false)
                                obj.title = ""
                            --end
                            //s.NextObject.FakeForeground:SetVisible(true)
                            --obj:Remove()
                            return
                        end

                        if noaccess then
                            obj.title = NoAccess
                            obj.subtitle = NoAccess_sub
                        end

                        --s:SetAlpha(255)
                        --s:SetMouseInputEnabled(true)
                        obj.title = LBefore
                        obj.subtitle = GetFormattedTime(untime)

                        --if Entity.Price then
                        --  obj.title = "Цена: "..Entity.Price
                        --end

                        if Entity.access and not bool then
                            obj.title = NoAccess
                            obj.subtitle = NoAccess_sub
                        end
                    end
                end, Object:GetChildren()[2]:GetParent())
            end
        end
    end

    local CreateNode = function(Category, Data, CustomTree)
        local Node = (CustomTree or Tree):AddNode(Category, Icons[Category])
        Node:SetExpanded(true, true)

        Node.PropPanel = vgui.Create('ContentContainer', Content)
        Node.PropPanel:SetVisible(false)
        Node.PropPanel:SetTriggerSpawnlistChange(false)

        Node.DoPopulate = function(self)
            if self.ContentsCreated then return end
            if Data then CreateNodeContents(self, Category, Data) end
        end

        Node.DoClick = function(self)
            self:DoPopulate()
            Content:SwitchPanel(self.PropPanel)
        end

        return Node
    end


    CreateNode(LProps, Categories[LProps])
    local ENTsTree = CreateNode(LEnts)
    for Category, Data in SortedPairs(Categories) do
        if Category == LProps then continue end
        spawnmenu.CreateContentIcon("header", ENTsTree.PropPanel, {
            text = Category
        })

        CreateNodeContents(ENTsTree, Category, Data)
    end

    local FirstNode = Tree:Root():GetChildNode(0)
    if (IsValid(FirstNode)) then
        FirstNode:InternalDoClick()
    end
end)

http.Fetch(rp.cfg.whitelistHandler, function(Body)
    local Props = util.JSONToTable(Body)
    
    if !(Props and #Props > 0) then
        Props = util.JSONToTable(rp.cfg.WhitelistedProps or 'nil')
    end
    
    for k, v in ipairs(Props or {}) do
        Insert(AllowedProps, {
            type = 'model',
            model = v.Model
        })
    end
end)

spawnmenu.AddCreationTab(GetLangString('Доступное'), function()
    local Control = vgui.Create('SpawnmenuContentPanel')
    Control:CallPopulateHook('PopulateFreeEntities')
    return Control
end, 'icon16/brick.png', -20)