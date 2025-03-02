-- "gamemodes\\rp_base\\entities\\weapons\\gmod_tool\\stools\\urf_duplicator.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
TOOL.Name = '#Tool.urf_duplicator.name'
TOOL.Description = '#tool.urf.duplicator.desc'
TOOL.Information = {'left', 'right', 'reload'}
TOOL.Category = 'Roleplay'
TOOL.Delay = .5
TOOL.PropsLimit = 40
TOOL.Cooldown = 5

DSS = DSS or {}
DSS.MaxPasteDistance = 228*228

cleanup.Register('construction');
DSS = DSS or {};

local propclasses = {
    ["prop_physics_multiplayer"] = true,
    ["prop_physics"] = true
}

local isprop = function(ent)
    return IsValid(ent) and propclasses[ent:GetClass()]
end

function ENTITY:IsProp()
    return isprop(self)
end

local zeroVec, zeroAng, IsValid = Vector(0, 0, 0), Angle(0, 0, 0), IsValid

if (CLIENT) then
    language.Add('Tool.urf_duplicator.name', translates.Get('Дубликатор'));
    language.Add('Tool.urf_duplicator.desc', translates.Get('Копируйте и вставляйте постройки!'));

    language.Add('Tool.urf_duplicator.left', translates.Get('ЛКМ - Воссоздать дубликат.'));
    language.Add('Tool.urf_duplicator.right', translates.Get('ПКМ - Скопировать постройку.'));
    language.Add('Tool.urf_duplicator.reload', translates.Get('Очистить буфер.'));

    language.Add('Undone_urf.duplicator.construction', translates.Get('Постройка убрана'));

	net.Receive('DupePasting', function()
		DSS.PastingConstruction = net.ReadBool()
	end)

    DSS.VGUI = DSS.VGUI or {};
    DSS.Preview = DSS.Preview or {};
    DSS.PreviewModels = DSS.PreviewModels or {};

    DSS.AngleModifier = DSS.AngleModifier or zeroAng;
    DSS.ClosedSlots = DSS.ClosedSlots or 0;

    DSS.LastAction = DSS.LastAction or CurTime();

    local LocalPlayer, render_DrawSphere, render_SetColorMaterial = LocalPlayer, render.DrawSphere, render.SetColorMaterial

    local sphere_col, props_col = Color(0, 70, 0, 125), Color(25, 255, 25)

    local IsValidToolgun = function()
        local actw = LocalPlayer():GetActiveWeapon()
         if not IsValid(actw) or not actw.IsGModTool or GetConVar("gmod_toolmode"):GetString() ~= "urf_duplicator" then return false end
         return true, swep
    end

    CreateConVar("dds_pastebyorigin_ang", "0", FCVAR_USERINFO)
    CreateConVar("dds_pastebyorigin_vec", "0", FCVAR_USERINFO)
    CreateConVar("dds_ang45", "0", FCVAR_USERINFO)

    local cvar = CreateConVar("dds_saveradius", "64", FCVAR_USERINFO)

    DSS.HighlightsProps = {}

    hook.Add("PostDrawTranslucentRenderables", "Duplicator.Draw", function()
        local IsValidToolgun, toolgun = IsValidToolgun()
        if IsValidToolgun then
            local pos, rad = LocalPlayer():GetEyeTrace().HitPos, math.min(cvar:GetInt(), 128)
            rad = rad*3

            render_SetColorMaterial()
            render_DrawSphere(pos, rad, 30, 30, sphere_col)
            render.DrawWireframeSphere(pos, rad, 30, 30, sphere_col)

            for k, ent in pairs(ents.GetAll()) do
                if not isprop(ent) then continue end

                local dist = pos:Distance(ent:GetPos())
                if dist <= rad then
                    ent.OriginalDDSColr = ent.OriginalDDSColr or ent:GetColor()
                    ent:SetColor(props_col)
                    DSS.HighlightsProps[ent] = true
                elseif ent.OriginalDDSColr then
                    ent:SetColor(ent.OriginalDDSColr)
                    ent.OriginalDDSColr = nil
                    DSS.HighlightsProps[ent] = nil
                    --continue
                end
            end
        end
    end)
else
    util.AddNetworkString('DupeInfo');
    util.AddNetworkString('DupePasting');

    if (DSS) then
		function DSS.CooldownAction(Player, Cooldown)
			local SID64 = Player:SteamID64();
			if (!IsValid(Player) or !SID64 or !Cooldown) then return false end
			if (timer.Exists('urf_dup_cd_' .. SID64)) then
				rp.Notify(Player, NOTIFY_ERROR, rp.Term('FadeDoorCooldown'), math.ceil(timer.TimeLeft('urf_dup_cd_' .. SID64)) or Cooldown);
				return false
			end

            timer.Create('urf_dup_cd_' .. SID64, (Cooldown or 5) * (Player:IsRoot() and 0.1 or 1), 1, function() end);

			return true
		end
    end

    function DUSendForPreview(Client, Data, OriginalOrigin)
        local JSON = util.TableToJSON(Data);
        local Compressed = util.Compress(JSON);
        local Length = Compressed:len();
        local SendSize = 60000;
        local Parts = math.ceil(Length / SendSize);

        local Endbyte, Size;
        local Start = 0;
        for I = 1, Parts do
            Endbyte = math.min(Start  + SendSize, Length);
            Size = Endbyte - Start;

            net.Start('DupeInfo');
                net.WriteUInt(1, 4);

                net.WriteUInt(I, 8);
                net.WriteUInt(Parts, 8);

                net.WriteUInt(Size, 32);
                net.WriteData(Compressed:sub(Start + 1, Endbyte + 1), Size);
		    net.Send(Client);
        end

        if OriginalOrigin and isvector(OriginalOrigin.vec) and isangle(OriginalOrigin.ang) then
            net.Start("DupeInfo")
                net.WriteUInt(3, 4);
                net.WriteVector(OriginalOrigin.vec)
                net.WriteAngle(OriginalOrigin.ang)
            net.Send(Client)
        else
            net.Start("DupeInfo")
                net.WriteUInt(4, 4);
            net.Send(Client)
        end
    end
end

local function GarbageCollector()
    if SERVER then return end

    for Index, Object in pairs(DSS.PreviewModels) do
        if (!IsValid(Object)) then continue end
        Object:Remove();
    end
    table.Empty(DSS.PreviewModels);
    hook.Remove('PreRender', 'DSS_preview');
end

function TOOL:ClearBuffer()
    if SERVER then
        self:GetOwner().DupedConstruction = nil
    else
        GarbageCollector()
    end
end

if CLIENT then
    function TOOL:ClearHighlights()
        for ent in pairs(DSS.HighlightsProps) do
            if IsValid(ent) and ent.OriginalDDSColr then
               ent:SetColor(ent.OriginalDDSColr)
                ent.OriginalDDSColr = nil
            end
        end

        DSS.HighlightsProps = {}
    end
end

function TOOL:Holster()
    self:ClearBuffer()
    if CLIENT then
        self:ClearHighlights()
    end
    return true
end

function TOOL:Reload()
    self:ClearBuffer()
end

function TOOL:Refresh()
    duplicator.SetLocalPos(zeroVec);
    duplicator.SetLocalAng(zeroAng);
end

function TOOL:ValidClass(Class)
    return Class == 'prop_physics' or Class == 'prop_physics_multiplayer'
end

function TOOL:CreateEntityViaEntData(Player, Index, EntityList)
    local Entity, Object, Protected;
    local KeyTable = table.GetKeys(EntityList);

    Object = EntityList[KeyTable[Index]];
    Protected = ProtectedCall(function() Entity = duplicator.CreateEntityFromTable(Player, Object); end);
    if (!Protected) then return nil end

    if (IsValid(Entity)) then
        if (!self:ValidClass(Entity:GetClass())) then
            Entity:Remove();
            return nil
        end

        if (Entity.RestoreNetworkVars) then
            Entity:RestoreNetworkVars(Object.DT);
        end

        if (Entity.OnDuplicated) then
            Entity:OnDuplicated(Object);
        end

        Entity.BoneMods = table.Copy(Object.BoneMods);
        Entity.EntityMods = table.Copy(Object.EntityMods);
        Entity.PhysicsObjects = table.Copy(Object.PhysicsObjects);

        duplicator.ApplyEntityModifiers(Player, Entity);
        duplicator.ApplyBoneModifiers(Player, Entity);

        if (Entity.PostEntityPaste) then
            Entity:PostEntityPaste(Player, Entity, EntityList);
        end

        if (Object.FadingDoor) then
            Entity.FadeKey = Object.FadeKey;
            Entity.FadingDoor = Object.FadingDoor;
            Entity.FadeInversed = Object.FadeInversed;
            Entity.FadeToggle = Object.FadeToggle;
            Entity.FadeCooldown = Object.FadeCooldown;

            Entity.NumpadFadeUp = numpad.OnUp(Player, Object.FadeKey, 'FadeDoor', Entity, false);
	        Entity.NumpadFadeDown = numpad.OnDown(Player, Object.FadeKey, 'FadeDoor', Entity, true);
        end

        if IsValid(Entity:GetPhysicsObject()) then
            Entity:GetPhysicsObject():EnableMotion(false);
        end

        rp.AutoFreezer.Block(Entity);
        rp.AutoFreezer.AntiPlayerBlock(Entity);
    end

    return Entity
end

function TOOL:LeftClick(Trace)
    local Owner = self:GetOwner();

    if (SERVER and Owner.DupedConstruction and !DSS.CooldownAction(Owner, self.Cooldown)) then return false end

    local Construction = Owner.DupedConstruction;
    if (!Construction) then return false end

    if (Owner.PastingConstruction or DSS.PastingConstruction) then
        if (SERVER) then rp.Notify(Owner, NOTIFY_ERROR, rp.Term(DSS.PastingConstruction and "DupeWaitAnotherPly" or 'DupeWait')); end
        return false
    end

	if not Construction.Mins or not Construction.Mins.z then
		return false
	end

    local pos = Owner:GetInfoNum("dds_pastebyorigin_vec", 0) > 0 and Owner.DupedConstructionPos and Owner.DupedConstructionPos.vec or Vector(Trace.HitPos.x, Trace.HitPos.y, Trace.HitPos.z - Construction.Mins.z)
    local ang = Owner:GetInfoNum("dds_pastebyorigin_ang", 0) > 0 and Owner.DupedConstructionPos and Owner.DupedConstructionPos.ang or Angle(0, Owner:EyeAngles().y, 0) + (Construction.AngleModifier or zeroAng)

    if Owner:GetInfoNum("dds_ang45", 0) > 0 then
        ang.y = 45 * math.ceil(ang.y / 45)
    end

    if Owner:GetInfoNum("dds_pastebyorigin_vec", 0) > 0 and Owner:GetPos():DistToSqr(pos) > DSS.MaxPasteDistance then
        if (SERVER) then rp.Notify(Owner, NOTIFY_ERROR, rp.Term('DupeDistanceLimit')); end
        return false
    end

    self:SetOperation(1); self:SetStage(1);
    Owner.PastingConstruction = true;
	DSS.PastingConstruction = true;

	net.Start('DupePasting')
		net.WriteBool(true)
	net.Broadcast()

    duplicator.SetLocalPos(pos);
	duplicator.SetLocalAng(ang);

    local Entities = {};
    local FixedSize = #table.GetKeys(Construction.Entities);

    self:SetOperation(2);
    self:SetStage(FixedSize + 1);

    for Index = 1, FixedSize do
        timer.Simple((Index - 1) * self.Delay, function()
            if (!IsValid(self:GetOwner())) then return end
            if (!Owner.PastingConstruction) then return end
            local Entity = self:CreateEntityViaEntData(Owner, Index, Construction.Entities);
            table.ForceInsert(Entities, Entity);
            if (IsValid(Entity)) then
                self:SetOperation(self:GetOperation() + 1);
            else
                self:SetStage(self:GetStage() - 1);
            end
        end);
    end

    timer.Create("DSS.Paste" .. Owner:SteamID64(), FixedSize * self.Delay + .1, 1, function()
		DSS.PastingConstruction = false

		local Owner = IsValid(Owner) and Owner or IsValid(self) and self:GetOwner()

        self:Refresh();

        undo.Create('urf.duplicator.construction');
            for _, Entity in pairs(Entities) do
				if IsValid(Entity) then
					undo.AddEntity(Entity);
					Owner:AddCleanup('construction', Entity);
				end
            end
            undo.SetPlayer(Owner);
        undo.Finish();

        if (SERVER) then rp.Notify(Owner, NOTIFY_GREEN, rp.Term('DupePasted')); end

		if IsValid(Owner) then
			Owner.PastingConstruction = false;
		end

		net.Start('DupePasting')
			net.WriteBool(false)
		net.Broadcast()

		if IsValid(self:GetWeapon()) then
			self:SetOperation(1);
			self:SetStage(1);
		end
    end);

    if SERVER then
        self:ClearBuffer()
        net.Start("DupeInfo")
            net.WriteUInt(5, 4)
        net.Send(Owner)
    end

    return true
end

local GetKeys = table.GetKeys;
local pairs, table_insert = pairs, table.insert

function TOOL:RightClick(Trace)
    local Owner = self:GetOwner();

    if (SERVER and !DSS.CooldownAction(Owner, self.Cooldown)) then return false end

    if CLIENT then return true end
    --if (IsValid(Trace.Entity) and Trace.Entity:IsWorld()) then return false end
    --if (CLIENT and IsValid(Trace.Entity) and IsValid(Owner)) then return true end
    --if (!IsValid(Trace.Entity) or (Trace.Entity:IsWorld()) or !self:ValidClass(Trace.Entity:GetClass())) then
    --    if (SERVER) then rp.Notify(Owner, NOTIFY_ERROR, rp.Term('DupeRestrictedEnts')); end
    --    return false
    --end
    if (Owner.PastingConstruction or DSS.PastingConstruction) then
        if (SERVER) then rp.Notify(Owner, NOTIFY_ERROR, rp.Term('DupeWait')); end
        return false
    end

    --local Construction = duplicator.Copy(Trace.Entity);
    local duplicatorEnts = {}
    local pos, rad = Owner:GetEyeTrace().HitPos, math.min(Owner:GetInfoNum("dds_saveradius", 0), 128)
    rad = rad*3

    local entitys = ents.FindInSphere(pos, rad)

    if #entitys < 1 then
        Owner.DupedConstruction = {};
        Owner.DupedConstructionPos = {
            vec = zeroVec,
            ang = zeroAng
        }
        DUSendForPreview(Owner, duplicator.CopyEnts(entitys), Owner.DupedConstructionPos);

        return
    end

    for k, ent in pairs(entitys) do
        if not isprop(ent) then continue end

        if pos:Distance(ent:GetPos()) <= rad and rp.pp.PlayerCanManipulate(Owner, ent) then
            local phys = ent:GetPhysicsObject()
            if IsValid(phys) and not phys:IsMotionEnabled() then
                constraint.RemoveAll(ent)
            end
            table_insert(duplicatorEnts, ent)
        end
    end

    local duplicatorAng, duplicatorPos = Angle(0, Owner:EyeAngles().y, 0), Trace.HitPos
    duplicator.SetLocalPos(duplicatorPos);
    duplicator.SetLocalAng(duplicatorAng);

    local Construction = duplicator.CopyEnts(duplicatorEnts)

    self:Refresh();

    local Keys = GetKeys(Construction.Entities);

    if (#Keys > self.PropsLimit) then
        rp.Notify(Owner, NOTIFY_ERROR, rp.Term('LimitDupeProps'), #Keys .. ' / ' .. self.PropsLimit);
        return false
    end

    for Index = 1, #Keys do
        if (!self:ValidClass(Construction.Entities[Keys[Index]].Class)) then
            Construction.Entities[Keys[Index]] = nil;
        end
    end

    if (!Construction) then return false end
    if (#Construction.Entities > 100) then return false end

    Owner.DupedConstruction = Construction;
    Owner.DupedConstructionPos = {
        vec = duplicatorPos,
        ang = duplicatorAng
    }
    DUSendForPreview(Owner, Construction, Owner.DupedConstructionPos);

    if (SERVER) then rp.Notify(Owner, NOTIFY_GREEN, rp.Term('DupeCopied')); end
    return true
end

function TOOL:DrawHUD()
    if (self:GetOperation() > 1 and self:GetStage() > 1) then
        draw.RoundedBox(10, ScrW() / 2 - 150, ScrH() / 2 + 200, 300, 32, Color(0, 0, 0, 180));
        draw.RoundedBox(5, ScrW() / 2 - 145, ScrH() / 2 + 205, 290 * ((self:GetOperation() - 2) / (self:GetStage() - 1)), 22, Color(135, 206, 235, 100));

        local Text = string.Replace(string.Replace(translates.Get('Воссоздание постройки... (#/@)'), '#', self:GetOperation() - 2), '@', self:GetStage() - 1);
        draw.SimpleText(Text, 'DermaDefaultBold', ScrW() / 2, ScrH() / 2 + 216, Color(255, 255, 255, 200), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER);
    end
end

function TOOL.BuildCPanel(CPanel)
    CPanel:Clear();

    DSS.VGUI.List = vgui.Create('DListView');
    DSS.VGUI.List:SetMultiSelect(false);
    DSS.VGUI.List:AddColumn(translates.Get('Сохраненные постройки'));
    DSS.VGUI.List:SetSortable(false);
    CPanel:AddItem(DSS.VGUI.List);
    DSS.VGUI.List:SetSize(CPanel:GetWide(), 220);

    DSS.VGUI.TextAngle = vgui.Create('DLabel');
    DSS.VGUI.TextAngle:SetDark(true);
    DSS.VGUI.TextAngle:SetText(translates.Get('Настройка поворота позиции постройки:'));
    DSS.VGUI.TextAngle:SetContentAlignment(5);
    CPanel:AddItem(DSS.VGUI.TextAngle);

    DSS.VGUI.X = vgui.Create('DNumSlider');
    DSS.VGUI.X:SetText(translates.Get('Относительно X:'));
    DSS.VGUI.X:SetDark(true);
    DSS.VGUI.X:SetMin(0); DSS.VGUI.X:SetMax(360);
    DSS.VGUI.X:SetValue(0);
    CPanel:AddItem(DSS.VGUI.X);

    DSS.VGUI.Y = vgui.Create('DNumSlider');
    DSS.VGUI.Y:SetText(translates.Get('Относительно Y:'));
    DSS.VGUI.Y:SetDark(true);
    DSS.VGUI.Y:SetMin(0); DSS.VGUI.Y:SetMax(360);
    DSS.VGUI.Y:SetValue(0);
    CPanel:AddItem(DSS.VGUI.Y);

    DSS.VGUI.Z = vgui.Create('DNumSlider');
    DSS.VGUI.Z:SetText(translates.Get('Относительно Z:'));
    DSS.VGUI.Z:SetDark(true);
    DSS.VGUI.Z:SetMin(0); DSS.VGUI.Z:SetMax(360);
    DSS.VGUI.Z:SetValue(0);
    CPanel:AddItem(DSS.VGUI.Z);

    DSS.VGUI.TextRelative = vgui.Create('DLabel');
    DSS.VGUI.TextRelative:SetDark(true);
    DSS.VGUI.TextRelative:SetText(translates.Get('Настройка сохранения:'));
    DSS.VGUI.TextRelative:SetContentAlignment(5);
    CPanel:AddItem(DSS.VGUI.TextRelative);

    DSS.VGUI.SaveRadius = vgui.Create('DNumSlider');
    DSS.VGUI.SaveRadius:SetText(translates.Get('Радиус сохранения:'));
    DSS.VGUI.SaveRadius:SetDark(true);
    DSS.VGUI.SaveRadius:SetMin(0);
    DSS.VGUI.SaveRadius:SetMax(128);
    DSS.VGUI.SaveRadius:SetValue(0);
    CPanel:AddItem(DSS.VGUI.SaveRadius);

    local SaveRadius = GetConVar("dds_saveradius"):GetInt()
    DSS.VGUI.SaveRadius:SetValue(SaveRadius)

    function DSS.VGUI.SaveRadius:OnValueChanged(Value)
        SaveRadius = math.Clamp(math.ceil(Value), 0, 128);
        RunConsoleCommand("dds_saveradius", SaveRadius)
    end

    DSS.VGUI.TextActions = vgui.Create('DLabel');
    DSS.VGUI.TextActions:SetDark(true);
    DSS.VGUI.TextActions:SetText(translates.Get('Действия с дубликатом постройки:'));
    DSS.VGUI.TextActions:SetContentAlignment(5);
    CPanel:AddItem(DSS.VGUI.TextActions);

    local VecCheckBox = vgui.Create("DCheckBoxLabel")
    VecCheckBox:SetValue( GetConVar("dds_pastebyorigin_vec"):GetInt() > 0 )
    function VecCheckBox:OnChange(val)
        RunConsoleCommand("dds_pastebyorigin_vec", val and 1 or 0)
    end
    VecCheckBox:SetText(translates.Get("Восстановить позицию"))
    VecCheckBox:SetDark(true)
    DSS.VGUI.VecCheckBox = VecCheckBox
    CPanel:AddItem(DSS.VGUI.VecCheckBox);

    local AngCheckBox = vgui.Create("DCheckBoxLabel")
    AngCheckBox:SetValue( GetConVar("dds_pastebyorigin_ang"):GetInt() > 0 )
    function AngCheckBox:OnChange(val)
        RunConsoleCommand("dds_pastebyorigin_ang", val and 1 or 0)
    end
    AngCheckBox:SetText(translates.Get("Восстановить угол"))
    AngCheckBox:SetDark(true)
    DSS.VGUI.AngCheckBox = AngCheckBox
    CPanel:AddItem(DSS.VGUI.AngCheckBox);

    local dds_ang45 = vgui.Create("DCheckBoxLabel")
    dds_ang45:SetValue( GetConVar("dds_ang45"):GetInt() > 0 )
    function dds_ang45:OnChange(val)
        RunConsoleCommand("dds_ang45", val and 1 or 0)
    end
    dds_ang45:SetText( translates.Get("Привязка угла") )
    dds_ang45:SetDark(true)
    DSS.VGUI.dds_ang45 = dds_ang45
    CPanel:AddItem(DSS.VGUI.dds_ang45);

    DSS.VGUI.Save = vgui.Create('DButton');
    DSS.VGUI.Save:SetText(translates.Get('Сохранить'));
    CPanel:AddItem(DSS.VGUI.Save);

    DSS.VGUI.Hint = vgui.Create('DLabel');
    DSS.VGUI.Hint:SetDark(true);
    DSS.VGUI.Hint:SetWrap(true);
    DSS.VGUI.Hint:SetColor(Color(51, 51, 255));
    DSS.VGUI.Hint:SetText(translates.Get('Подсказка: чтобы сохранить постройку, нажмите пкм рядом с вашими пропами (которые подсвеченны зелёным).'));
    DSS.VGUI.Hint:SetContentAlignment(5);
    DSS.VGUI.Hint:SetSize(CPanel:GetWide(), 50);
    CPanel:AddItem(DSS.VGUI.Hint);

    local function ApplyChanges()
        net.Start('DupeInfo');
            net.WriteUInt(4, 4);
            net.WriteAngle(DSS.AngleModifier);
        net.SendToServer();
    end

    function DSS.VGUI.X:OnValueChanged(Value)
        DSS.AngleModifier.roll = Value;
        ApplyChanges();
    end

    function DSS.VGUI.Y:OnValueChanged(Value)
        DSS.AngleModifier.pitch = Value;
        ApplyChanges();
    end

    function DSS.VGUI.Z:OnValueChanged(Value)
        DSS.AngleModifier.yaw = Value;
        ApplyChanges();
    end

    function DSS.VGUI.List:OnRowRightClick(LineID, Line)
        if (LineID > DSS.ClosedSlots) then
            return
        end

        local Menu = DermaMenu();

        local Delete = Menu:AddOption(translates.Get('Удалить сохранение'), function()
            if (!LineID) then return end
            net.Start('DupeInfo');
                net.WriteUInt(2, 4);
                net.WriteUInt(LineID, 4);
            net.SendToServer();
        end);
        Delete:SetIcon('icon16/cross.png');

        local Share, PShare = Menu:AddSubMenu(translates.Get('Передать сохранение'));
        PShare:SetIcon('icon16/user.png');

        local PlayersN = 0;

        local Button, PButton;
        for Index, Player in pairs(player.GetAll()) do
            if (!IsValid(Player) or Player:IsBot() or LocalPlayer():SteamID64() == Player:SteamID64()) then continue end
            Button, PButton = Share:AddOption(Player:Nick(), function()
                net.Start('DupeInfo');
                    net.WriteUInt(5, 4);
                    net.WriteUInt(LineID, 4);
                    net.WriteString(Player:SteamID64() or '0');
                net.SendToServer();
            end);
            PShare:SetIcon('icon16/user.png');
            PlayersN = PlayersN + 1;
        end

        if (PlayersN < 1) then
            PShare:Remove();
        end

        Menu:Open();
    end

    function DSS.VGUI.List:OnRowSelected(RowIndex, Row)
        if (!IsValid(Row)) then return end
        local Selected = self:GetSelectedLine();

        if GetGmodTool(LocalPlayer()) then
            RunConsoleCommand('gmod_tool', 'urf_duplicator');
        end

        DSS.VGUI.X:SetValue(0);
        DSS.VGUI.Y:SetValue(0);
        DSS.VGUI.Z:SetValue(0);

        net.Start('DupeInfo');
            net.WriteUInt(3, 4);
            net.WriteUInt(Selected, 4);
        net.SendToServer();
    end

    function DSS.VGUI.Save:DoClick()
        if (#DSS.PreviewModels < 1) then return end
        if (DSS.VGUI.Saver) then return end

        local Window = vgui.Create('DFrame');
        Window:SetSize(400, 100);
        Window:Center();
        Window:SetTitle(translates.Get('Сохранение дубликата'));
        Window:SetDraggable(false);
        Window:MakePopup();

        local Name = vgui.Create('DTextEntry', Window);
        Name:SetSize(260, 25);
        Name:SetPos(10, Window:GetTall() / 2 - Name:GetTall() / 2);
        Name:RequestFocus();

        local Save = vgui.Create('DButton', Window);
        Save:SetSize(110, 25);
        Save:SetPos(280, Window:GetTall() / 2 - Name:GetTall() / 2);
        Save:SetText(translates.Get('Сохранить'));

        local Info = vgui.Create('DLabel', Window);
        local PosX, PosY = Name:GetPos();
        Info:SetSize(Window:GetWide(), Window:GetTall() - PosY + 20);
        Info:SetPos(0, PosY);
        Info:SetContentAlignment(5);
        Info:SetText(translates.Get('Доступное количество символов: %s / 32', 0));

        function Window:OnClose()
            DSS.VGUI.Saver = nil;
        end

        local utf8_len = utf8.len;
        local OldValue, Length = '', 0;
        function Name:OnChange()
            Length = utf8_len(Name:GetText());
            Info:SetText(translates.Get('Доступное количество символов: %s / 32', Length));
            if (Length >= 32) then
                Name:SetText(OldValue);
            else
                OldValue = Name:GetText();
            end
        end

        local utf8_code = utf8.codepoint;
        function Save:DoClick()
            local Text = Name:GetText();
            local Valid = true;
            local C = 0;
            for Char = 1, utf8_len(Text) do
                C = string.byte(Text[Char], 1);
                if not ((C >= 97 and C <= 122) or (C >= 65 and C <= 90) or (C >= 48 and C <= 57) or (C == 32)) then
                    Valid = false;
                end
            end

            if (!Valid) then
                Info:SetText(translates.Get('[A-Z, a-z, 0-9] Внимание, в названии допустима только латиница.'));
                timer.Simple(1, function()
                    if (IsValid(Info)) then
                        Info:SetText(translates.Get('Доступное количество символов: %s / 32', utf8_len(Name:GetText())));
                    end
                end);
                return
            end

            net.Start('DupeInfo');
                net.WriteUInt(1, 4);
                net.WriteString(Name:GetText());
            net.SendToServer();
            Window:Close();
        end

        DSS.VGUI.Saver = Window;
    end

    net.Start('DupeInfo');
        net.WriteUInt(0, 4);
    net.SendToServer();
end

if (CLIENT) then
    function DSS.UpdateInfo(Table)
        if (!Table) then return end

        DSS.ClosedSlots = #Table;
        if (!IsValid(DSS.VGUI.List)) then return end

        DSS.VGUI.List:Clear();
        local Temp = {};
        for Index, Line in pairs(Table) do
            Temp = string.Explode('=', Line);
            Temp[2] = string.upper(string.sub(Temp[2], 1, 1)) .. string.sub(Temp[2], 2, utf8.len(Temp[2]));
            DSS.VGUI.List:AddLine('[' .. Temp[1] .. '] ' .. string.Replace(Temp[2], '%', ' '));
        end
    end
end

hook.Add('PlayerSwitchWeapon', 'urf_dupe_paste', function(Player, OldWeapon, Weapon)
    if (!SERVER) then return end
    if (Player.PastingConstruction) then
        local tid = "DSS.Paste" .. Player:SteamID64();

        if timer.Exists(tid) then
            timer.Adjust(tid, 0);
        end

        -- return true
    end
end);

if (CLIENT) then
    local function UpdatePreview()
        local Owner = LocalPlayer()
        local Trace = Owner:GetEyeTrace();

        local CenterPos = Owner:GetInfoNum("dds_pastebyorigin_vec", 0) > 0 and Owner.DupedConstructionPos and Owner.DupedConstructionPos.vec or Vector(Trace.HitPos.x, Trace.HitPos.y, Trace.HitPos.z - (DSS.Preview.Mins and DSS.Preview.Mins.z or 0));
        local CenterAng = Owner:GetInfoNum("dds_pastebyorigin_ang", 0) > 0 and Owner.DupedConstructionPos and Owner.DupedConstructionPos.ang or Angle(0, Owner:EyeAngles().y, 0);

        CenterAng = CenterAng + (DSS.AngleModifier or zeroAng);

        if Owner:GetInfoNum("dds_ang45", 0) > 0 then
            CenterAng.y = 45 * math.ceil(CenterAng.y / 45)
        end

        local LV, LA;
        for Index, Object in pairs(DSS.PreviewModels) do
            if (!IsValid(Object)) then continue end

            LV, LA = LocalToWorld(Object.DataPos, Object.DataAngle, CenterPos, CenterAng);

            Object:SetAngles(LA);
            Object:SetPos(LV);
        end
    end

    local function StartPreview()
        if (!DSS.Preview) then return end
        if not GetGmodTool(LocalPlayer()) then return end
        if (DSS.PreviewModels) then GarbageCollector(); end

        -- DSS.VGUI.X/Y/Z can be nil if tool panel doesnt exist (player dont open q menu since connect)
        if (IsValid(DSS.VGUI.X)) then
            DSS.VGUI.X:SetValue(0);
            DSS.VGUI.Y:SetValue(0);
            DSS.VGUI.Z:SetValue(0);
        end

        DSS.AngleModifier = DSS.Preview.AngleModifier or zeroAng;

        for Index, Object in pairs(DSS.Preview.Entities) do
            local Entity = ents.CreateClientProp();
            Entity:SetModel(Object.Model);
            Entity:SetRenderMode(RENDERMODE_TRANSCOLOR);
            Entity:SetColor(Color(255, 255, 255, 200));

            Entity.DataAngle = Object.PhysicsObjects[0] and Object.PhysicsObjects[0].Angle or Angle(0, 0, 0);
            Entity.DataPos = Object.PhysicsObjects[0] and Object.PhysicsObjects[0].Pos or Vector(0, 0, 0);

            if (IsValid(Entity)) then
                table.ForceInsert(DSS.PreviewModels, Entity);
                local Index = #DSS.PreviewModels;
                DSS.PreviewModels[Index]:Spawn();
            end
        end

        hook.Add('PreRender', 'DSS_preview', function()
            UpdatePreview();
        end);
    end

    function TOOL:Deploy()
        --~ WTF
    end

    local PreviewBuffer = '';
    net.Receive('DupeInfo', function(Length)
        local Command = net.ReadUInt(4);

        local Case = {
            [0] = function()
                local Length1 = net.ReadUInt(16);
                local Data1 = net.ReadData(Length1);

                Data1 = util.Decompress(Data1);
                Data1 = util.JSONToTable(Data1);

                DSS.UpdateInfo(Data1);
            end,

            [1] = function()
                local Part = net.ReadUInt(8);
                local Total = net.ReadUInt(8);

                local Length = net.ReadUInt(32);
                local Data = net.ReadData(Length);

                PreviewBuffer = PreviewBuffer .. Data;
                if (Part != Total) then return end

                local Uncompressed = util.Decompress(PreviewBuffer);
                PreviewBuffer = '';

                if (!Uncompressed) then return end
                DSS.Preview = util.JSONToTable(Uncompressed);

                StartPreview();
            end,

            [2] = function()
                local Length = net.ReadUInt(16);
                local Data = net.ReadData(Length);

                Data = util.Decompress(Data);
                Data = util.JSONToTable(Data);

                DSS.TempDataShareSystem = Data;
            end,
            [3] = function()
                LocalPlayer().DupedConstructionPos = {
                    vec = net.ReadVector(),
                    ang = net.ReadAngle()
                }
            end,
            [4] = function()
                LocalPlayer().DupedConstructionPos = {
                    vec = zeroVec,
                    ang = zeroAng
                }
            end,
            [5] = function()
                local toolgun = LocalPlayer():GetActiveWeapon()
                if IsValid(toolgun) and toolgun.GetToolObject then
                    local tool = toolgun:GetToolObject()
                    if tool.ClearBuffer then
                        tool:ClearBuffer()
                    end
                end
            end
        };

        Case[Command]();
    end);
end

if (SERVER) then
    local function SendUpdatedInfo(Client)
        local Dupes = DSS.GiveMeMyTableDamnIt(Client);
        local Table = {};

        local T;
        for Index, Value in pairs(Dupes) do
            if (!Value[1]) then continue end
            T = string.Explode('_', Value[1]);
            if (#T < 7) then continue end
            table.insert(Table, T[1] .. '.' .. T[2] .. '.' .. T[3] .. ' ' .. T[4] .. ':' .. T[5] .. ':' .. T[6] .. '=' .. T[7]);
        end

        local Data1 = util.TableToJSON(Table);
        Data1 = util.Compress(Data1);

        net.Start('DupeInfo');
            net.WriteUInt(0, 4);
            -- Data1
            net.WriteUInt(string.len(Data1), 16);
            net.WriteData(Data1, string.len(Data1));
        net.Send(Client);
    end

    net.Receive('DupeInfo', function(Length, Client)
        if (!IsValid(Client)) then return end
        local Command = net.ReadUInt(4);

        local Case = {
            -- get info about own dupes
            [0] = SendUpdatedInfo,

            -- save dupe
            [1] = function(Client)
                local Name = net.ReadString();

                local Dupes = #(DSS.GiveMeMyTableDamnIt(Client) or {});
                if (Dupes >= DSS.MaxSlotsPerPlayer) then
                    rp.Notify(Client, NOTIFY_ERROR, rp.Term('EndDupeSlots'), DSS.MaxSlotsPerPlayer);
                    return
                end
                if (utf8.len(Name) > 32) then return end

                Name = string.Replace(Name, ' ', '%');

                local DupedConstruction = Client.DupedConstruction;
                if (!DupedConstruction) then return end

                local Date = string.Replace(tostring(os.date("%d.%m.%Y")), '.', '_');
                Date = Date .. '_' .. string.Replace(tostring(os.date("%X",os.time())), ':', '_');

                DSS.SaveDupe(Client, Date .. '_' .. Name, DupedConstruction, (Client.DupedConstructionPos or {}), function(Result)
                    SendUpdatedInfo(Client);
                end);
            end,

            -- remove saved dupe
            [2] = function(Client)
                local Selected = net.ReadUInt(4);

                local Dupes = DSS.GiveMeMyTableDamnIt(Client);
                if not Dupes or (Selected > #Dupes) or not Dupes[Selected] or not Dupes[Selected][1] then return end
                DSS.DeleteDupe(Client, Dupes[Selected][1], function(Result)
                    SendUpdatedInfo(Client);
                end);
            end,

            -- load dupe
            [3] = function(Client)
                local Selected = net.ReadUInt(4);
                local Dupes = DSS.GiveMeMyTableDamnIt(Client);

                if (!Dupes or !Selected or !Dupes[Selected] or !Dupes[Selected][1]) then return end
                if (Selected > #Dupes) then return end
                DSS.LoadDupe(Client, Dupes[Selected][1]);
            end,

            -- change angles
            [4] = function(Client)
                if (!Client.DupedConstruction) then return end
                local Angle = net.ReadAngle();
                Client.DupedConstruction.AngleModifier = Angle;
            end,

            --~ Share
            [5] = function(Client)
                local Selected = net.ReadUInt(4);
                local SID64 = net.ReadString();

                local TimerID = 'dupe_cdshare_' .. Client:SteamID64();

                if (timer.Exists(TimerID)) then
                    rp.Notify(Client, NOTIFY_ERROR, rp.Term('PleaseWaitX'), math.ceil(timer.TimeLeft(TimerID)));
                    return
                end

                if (!Selected or !SID64) then return end
                local Dupes = DSS.GiveMeMyTableDamnIt(Client);
                if not Dupes or (Selected > #Dupes) or not Dupes[Selected] or not Dupes[Selected][1] then return end
                if (Selected > #Dupes) then return end
                local Dupe = Dupes[Selected][1];

                DSS.ShareDupe(Client, Dupe, player.GetBySteamID64(SID64), function(Result)
                    SendUpdatedInfo(Client);
                    SendUpdatedInfo(player.GetBySteamID64(SID64));
                end);

                timer.Create(TimerID, DSS.Cooldown or 20, 1, function() end);
            end
        };

        DSS.GetDupes(Client);
        Case[Command](Client);
    end);
end
