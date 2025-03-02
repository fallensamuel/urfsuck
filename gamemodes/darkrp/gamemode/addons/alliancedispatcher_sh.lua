if rp.cfg.DisableDispatcherContextMenu then return end

if (CLIENT) then
    local Map = game.GetMap();

    local Frame = nil;
    local SelectedPos = nil;

    local SetDrawColor = surface.SetDrawColor;
    local DrawBorder = surface.DrawOutlinedRect;
    local DrawRectangle = draw.RoundedBox;
    local SetMaterial = surface.SetMaterial;
    local DrawTexture = surface.DrawTexturedRect;

    local Ceil = math.ceil;
    local DrawString = draw.SimpleText;

    local Cooldown = false;
    local NoImage = Material('effects/tvscreen_noise003a');

    local HintText = (!Cooldown and 'Выберите точку обстрела.') or 'Дождитесь восстановления связи:';
    local TimerText = '00:00';

    surface.CreateFont('HudFont18pxShadowed', {
        font = 'Open Sans Light',
        size = 18,
        weight = 480,
        shadow = true,
        antialias = true,
        extended = true
    });

    surface.CreateFont('HudFont14pxTimer', {
        font = 'Open Sans Light',
        size = 14,
        weight = 300,
        antialias = true,
        extended = true
    });

    local function CreateFrame()
        if (IsValid(Frame)) then Frame:Close(); end

        Frame = ui.Create('ui_frame', function(self)
            self:SetSize(ScrW() * .5, ScrH() * .4);
            self:Center();
            self:SetTitle('Авиаудар капсулами с хедкрабами');
            self:SetDraggable(false);

            if (!SelectedPos) then SelectedPos = table.GetKeys(rp.cfg.AllianceDispatcher[game.GetMap()])[1]; end

            ui.Create('DPanel', function(viewer, parent)
                viewer:SetSize(parent:GetWide() * .6 - 9, parent:GetTall() * .5);
                viewer:SetPos(10, 37);

                local x, y, x1, y1 = 0, 0, 0, 0;
                local LPos;
                local LName;

                function viewer:Paint(w, h)
                    x, y = parent:GetPos();
                    x1, y1 = viewer:GetPos();

                    LPos = rp.cfg.AllianceDispatcher[Map][SelectedPos].Camera.Pos;
                    LName = SelectedPos or 'Неизвестная локация';

                    SetDrawColor(255, 255, 255);

                    if (!Cooldown) then
                        render.RenderView({
                            origin = (rp.cfg.AllianceDispatcher[Map][SelectedPos] or {Camera = {Pos = Vector(0, 0, 0)}}).Camera.Pos,
                            angles = (rp.cfg.AllianceDispatcher[Map][SelectedPos] or {Camera = {Ang = Angle(0, 0, 0)}}).Camera.Ang,
                            x = x + x1, y = y + y1,
                            w = w, h = h
                        });
                    else
                        DrawRectangle(0, 0, 0, w, h, Color(0, 0, 0));
                        SetDrawColor(255, 255, 255);

                        SetMaterial(NoImage);
                        DrawTexture(0, 0, w, h);

                        LName = 'Нет сигнала';
                        LPos = Vector(0, 0, 0);
                    end

                    DrawString('ЛОКАЦИЯ: ' .. (LName or 'Неизвестная локация'), 'HudFont18pxShadowed', 10, h - 50, Color(255, 255, 255));
                    DrawString('ДАННЫЕ РАСПОЛОЖЕНИЯ: ' .. ((Ceil(LPos.x) .. ' : ' .. Ceil(LPos.y) .. ' : ' .. Ceil(LPos.z)) or 'X : Y : Z'), 'HudFont18pxShadowed', 10, h - 30, Color(255, 255, 255));

                    SetDrawColor(100, 100, 100);
                    DrawBorder(0, 0, w, h);
                end
            end, self);

            local JPanel = ui.Create('DPanel', function(panel, parent)
                panel:SetSize(parent:GetWide() * .4 - 20, parent:GetTall() * .5);
                panel:SetPos(parent:GetWide() * .6 + 10, 37);

                function panel:Paint(w, h)
                    DrawString(HintText, 'PlayerInfo', w * .5, h * .5 - 25.5, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER);
                    if (!Cooldown) then return end
                    DrawString(os.date("%M:%S", Cooldown - CurTime()), 'HudFont14pxTimer', w * .5, h * .5 - 5, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER);
                end

                ui.Create('DButton', function(button, _parent)
                    button:SetSize(_parent:GetWide() * .6, 25);
                    button:SetPos((_parent:GetWide() - button:GetWide()) * .5, _parent:GetTall() * .5 + 7.5);
                    button:SetText('НАЧАТЬ ОБСТРЕЛ');
                    button:SetEnabled(!Cooldown and SelectedPos);

                    function button:DoClick()
                        if (Cooldown or !rp.cfg.AllianceDispatcherCooldown) then return end
                        
                        if (LocalPlayer():Team() != TEAM_DISPATCH) then
                            rp.Notify(NOTIFY_ERROR, 'У вас неподходящая профессия.');
                            return
                        end

                        surface.PlaySound('npc/metropolice/vo/clearno647no10-107.wav');
                        
                        net.Start('AllianceDispatcherNet');
                            net.WriteString(SelectedPos);
                        net.SendToServer();

                        Cooldown = CurTime() + rp.cfg.AllianceDispatcherCooldown;
                        HintText = 'Восстановление связи:';

                        timer.Simple(rp.cfg.AllianceDispatcherCooldown, function()
                            Cooldown = nil;
                            HintText = 'Выберите точку обстрела.';
                            if (IsValid(Frame)) then CreateFrame(); end
                        end);

                        if (IsValid(Frame)) then
                            CreateFrame();
                        end
                    end
                end, panel);
            end, self);

            ui.Create('DScrollPanel', function(list, parent)
                list:SetSize(parent:GetWide() - 20, parent:GetTall() - 37 - JPanel:GetTall() - 19);
                list:SetPos(10, 37 + parent:GetTall() * .5 + 9);

                if (Cooldown) then return end

                for Index, Key in pairs(table.GetKeys(rp.cfg.AllianceDispatcher[Map] or {})) do
                    local select = list:Add('DButton');
                    select:SetSize(list:GetWide(), 30);
                    select:Dock(TOP);
                    select:SetText(Key);
                    select:SetColor(Color(255, 255, 255));

                    select.LKey = Key;

                    function select:Paint(w, h)
                        if (self.LKey == SelectedPos) then
                            DrawRectangle(0, 0, 0, w, h, Color(0, 200, 0, 120));
                        else
                            DrawRectangle(0, 0, 0, w, h, Color(0, 0, 0, 120));
                        end
                    end

                    function select:DoClick()
                        SelectedPos = self.LKey;
                    end
                end
            end, self);

            self:MakePopup();
        end);
    end

    rp.AddContextCommand('Командование', 'Авиаудар капсулами', CreateFrame, function()
        return LocalPlayer():Team() == TEAM_DISPATCH
    end);
end

rp.AddTerm('CapsuleSended', 'Был инициализирован обстрел капсулами.');

if (SERVER) then
    util.AddNetworkString('AllianceDispatcherNet');

    local Cooldown = Cooldown or {};
    local Delay = rp.cfg.AllianceDispatcherCooldown;

    local Map = game.GetMap();
    local HDeploy;

    net.Receive('AllianceDispatcherNet', function(Length, Player)
        --if (!IsValid(Player)) then return end

        if (Player:Team() != TEAM_DISPATCH) then
            rp.Notify(Player, NOTIFY_ERROR, rp.Term('CantWear'));
            return
        end

        local SID64 = Player:SteamID64();
        if (Cooldown[Player]) then 
            rp.Notify(Player, NOTIFY_GREEN, rp.Term('PleaseWaitX'), math.ceil(timer.TimeLeft(SID64 .. '_dispatcher') or 0));
            return
        end

        local Key = net.ReadString();

        if (!Key or !rp.cfg.AllianceDispatcher[Map][Key] or !rp.cfg.AllianceDispatcher[Map][Key].Deploy) then return end
        HDeploy = rp.cfg.AllianceDispatcher[Map][Key].Deploy;

        for k, v in pairs(HDeploy) do
            MakeHeadcrabcanister(v, Angle(0, 0, 0), 0, 3);
        end

        rp.Notify(Player, NOTIFY_GREEN, rp.Term('CapsuleSended'));

        timer.Remove(SID64 .. '_dispatcher');
        Cooldown[Player] = 0;

        timer.Create(SID64 .. '_dispatcher', Delay, 1, function()
            if (!IsValid(Player)) then return end
            Cooldown[Player] = nil;
        end);
    end);
end