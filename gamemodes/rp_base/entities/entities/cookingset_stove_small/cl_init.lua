-- "gamemodes\\rp_base\\entities\\entities\\cookingset_stove_small\\cl_init.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
include('shared.lua');

local Ang, Pos, MyPos, Dist, TextAng;
local CWhite = Color(255, 255, 255);
local CBlack = Color(0, 0, 0);

local Data = Data or {};

function ENT:Draw()
    self:DrawModel();

    Pos = self:GetPos()+Vector(0,0,25);
    Ang = self:GetAngles();
    MyPos = LocalPlayer():GetPos();
    Dist = Pos:Distance(MyPos);

    if Dist > 500 or (MyPos - MyPos):DotProduct(LocalPlayer():GetAimVector()) < 0 then 
        return 
    end

    Ang:RotateAroundAxis(Ang:Forward(), 90);
    Ang:RotateAroundAxis(Ang:Right(), 90);
    TextAng = Ang;
    CWhite.a = 500 - Dist;
    CBlack.a = 500 - Dist;
    TextAng:RotateAroundAxis(TextAng:Right(), math.sin(CurTime() * math.pi) * -45);

    if ((self:GetPercentage() or -1) > -1) then
        Data.Pr = math.ceil(self:GetPercentage() or 0) .. ' %';
    elseif ((self:GetPercentage() or -1) == -2) then
        Data.Pr = self:GetRecipe() or 'Что-то';
    else
        Data.Pr = nil;
    end

    cam.Start3D2D(Pos, Ang, 0.070);
        draw.SimpleTextOutlined(self.PrintName or '-', '3d2d', 0, -450, CWhite, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, 1, CBlack);
        if (Data.Pr) then
            draw.SimpleTextOutlined('Приготовлено: ' .. Data.Pr, '3d2d', 0, -350, CWhite, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, 1, CBlack);
        end
    cam.End3D2D();

    Ang:RotateAroundAxis(Ang:Right(), 180);
    cam.Start3D2D(Pos, Ang, 0.070);
        draw.SimpleTextOutlined(self.PrintName or '-', '3d2d', 0, -450, CWhite, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, 1, CBlack);
        if (Data.Pr) then
            draw.SimpleTextOutlined('Приготовлено: ' .. Data.Pr, '3d2d', 0, -350, CWhite, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, 1, CBlack);
        end
	cam.End3D2D();
end

function ENT:Initialize()
    Data.Name = self.PrintName or '-';
    Data.Model = self:GetModel() or 'models/props_junk/TrafficCone001a.mdl';
    Data.Link = nil;
end

local Frame = Frame or nil;

local function OpenMenu(CreationID, Ent)
    if (IsValid(Frame)) then Frame:Close(); end

    surface.PlaySound('items/ammocrate_open.wav');
    Data.Link = Ent or Data.Link;

    Frame = ui.Create('ui_frame', function(self)
		self:SetSize(400, 500);
		self:SetTitle(Data.Name or '-');
		self:MakePopup();
		self:Center();
        self:RequestFocus();
        
        function self:OnClose()
            surface.PlaySound('items/ammocrate_close.wav');
        end
    end);
    
    ui.Create('DModelPanel', function(self, parent)
        self:Dock(TOP);
        self:SetSize(parent:GetWide(), 150);
        self:SetModel(Data.Model or 'models/props_junk/TrafficCone001a.mdl');
        self:GetEntity():SetPos(Vector(0, 0, 32));
        self:GetEntity():SetBodygroup(0, Data.Link:GetBodygroup(0) or 0);
        self:SetFOV(100);
    end, Frame);

    ui.Create('DPanel', function(self, parent)
        self:Dock(TOP);
        self:SetSize(parent:GetWide(), 30);

        if (IsValid(Data.Link) and (Data.Link:GetPercentage() or -1) == -2) then
            ui.Create('DButton', function(sself, pparent)
                sself:Dock(FILL);
                sself:SetSize(pparent:GetWide(), pparent:GetTall());
                sself:SetText('Забрать приготовленную еду');

                if (IsValid(parent)) then
                    parent:SetTitle((Data.Name or '-') .. ': Приготовлен ' .. (Data.Link:GetRecipe() or 'Что-то'));
                end

                sself.DoClick = function()
                    net.Start('CookingsetFoodNet2');
                        net.WriteString(CreationID);
                        net.WriteUInt(230, 8);
                    net.SendToServer();

                    if (IsValid(Frame)) then Frame:Close(); end
                end
            end, self);

            return
        end

        if (IsValid(Data.Link) and (Data.Link:GetPercentage() or -1) != -1) then
            ui.Create('DButton', function(sself, pparent)
                sself:Dock(RIGHT);
                sself:SetSize(100, pparent:GetTall());
                sself:SetText('Прервать');

                sself.DoClick = function()
                    net.Start('CookingsetFoodNet2');
                        net.WriteString(CreationID);
                        net.WriteUInt(231, 8);
                    net.SendToServer();

                    if (IsValid(Frame)) then Frame:Close(); end
                end
            end, self);

            ui.Create('DProgress', function(sself, pparent)
                sself:Dock(FILL);

                local Timer = 'cookingset_vgui' .. Data.Link:EntIndex();
                timer.Remove(Timer);
                timer.Create(Timer, .25, 0, function()
                    if (!IsValid(sself)) then return end
                    local Progress = (Data.Link:GetPercentage() or 0);
                    sself:SetFraction(Progress * .01);

                    if (Progress == -2) then
                        if (IsValid(Frame)) then Frame:Close(); end
                        timer.Remove(Timer);
                        OpenMenu(CreationID, Data.Link);
                    end
                end);
            end, self);
        else
            ui.Create('DLabel', function(sself, pparent) 
                sself:SetText('Выберите рецепт из списка');
                sself:SetTextColor(Color(255, 255, 255));
                sself:SizeToContents();
                sself:SetPos((pparent:GetWide() - sself:GetWide()) / 2, 5);
            end, self);
        end
    end, Frame);

    ui.Create('DScrollPanel', function(self, parent)
        self:Dock(FILL);

        local Progress = (Data.Link:GetPercentage() or 0);
        for Index, Receipe in pairs(rp.cfg.CookFoodRecipes or {}) do
            ui.Create('DPanel', function(sself, pparent)
                sself:SetSize(self:GetWide(), 30);
                sself:Dock(TOP);

                ui.Create('DButton', function(button, panel) 
                    button:SetText('Готовить');
                    button:SetEnabled(Progress == -1);
                    button:Dock(RIGHT);
                    button:SetSize(120, panel:GetTall());

                    button.DoClick = function()
                        if (IsValid(Data.Link) and (Data.Link:GetPercentage() or 0) == -1) then
                            net.Start('CookingsetFoodNet2');
                                net.WriteString(CreationID);
                                net.WriteUInt(Index, 8);
                            net.SendToServer();

                            if (IsValid(panel:GetParent():GetParent():GetParent())) then panel:GetParent():GetParent():GetParent():Close(); end
                        end
                    end
                end, sself);

                ui.Create('DLabel', function(label, panel) 
                    label:SetText(' ' .. (Receipe.Name .. ' [' .. Receipe.Time .. ' сек]') or '?');
                    label:SetFont('DermaDefault');
                    label:SetTextColor(Color(255, 255, 255));
                    label:SetSize(panel:GetWide() - 120, panel:GetTall());
                    label:Dock(FILL);
                end, sself);
            end, self);
        end
    end, Frame);
end

net.Receive('CookingsetFoodNet2', function(Length)
    local CreationID = net.ReadString();
    local Ent = net.ReadEntity();
    print(CreationID, Ent);
    OpenMenu(CreationID, Ent);
end);