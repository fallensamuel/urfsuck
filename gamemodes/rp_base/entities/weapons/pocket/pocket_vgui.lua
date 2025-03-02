local iconWidth = 200;

local PANEL = {};

function PANEL:Init()
  self.Contents = rp.inv.Data;
  self.Created = SysTime();
  self.Closed = nil;
  self.Alpha = 0;
  self.Icons = {};

  self:SetSize(ScrW(), ScrH());

  self:MakePopup();
  self:SetKeyBoardInputEnabled(false);
end

function PANEL:InitLocal()
	self.Contents = rp.inv.Data
	
	self:Finalize()
end

function PANEL:InitInspect(pl, contents)
	self.Contents = contents
	self.Inspecting = pl:Name()
	self.InspectingPlayer = pl
	
	self:Finalize()
end

function PANEL:Finalize()
	for k, v in pairs(self.Contents) do
		local ico = self:Add("PocketItem");
		ico:SetItem(v);

		table.insert(self.Icons, ico);
	end
	
	self:LayoutIcons()
	
	
	if (self.Inspecting) then
		local y = self.Icons[1] and self.Icons[1].y or ScrW() * 0.25
		self.InspLbl = ui.Create("DLabel", function(lbl)
			lbl:SetText("Inspecting " .. self.Inspecting .. "'s Pocket")
			lbl:SizeToContents()
			
			lbl:CenterHorizontal()
			lbl:SetPos(lbl.x, y - (lbl:GetTall() * 2) - 6)
		end, self)
		y = y - self.InspLbl:GetTall() - 3
		self.btnClose = ui.Create("DButton", function(btn)
			btn:SetText("Закрыть")
			btn:SizeToContents()
			btn:SetWide(self.InspLbl:GetWide())
			btn:CenterHorizontal()
			btn:SetPos(btn.x, y)
			btn.DoClick = rp.inv.DisableMenu
		end, self)
	end
end

function PANEL:LayoutIcons()
  if (#self.Icons == 0) then return; end

  local perRow = math.floor((ScrW() * 0.75) / (iconWidth + 10));
  local numRows = math.ceil(#self.Icons / perRow);

  if (numRows > 1) then
    local totalWidth = perRow * iconWidth + (perRow - 1) * 10;
    local totalHeight = numRows * 74 + (numRows - 1) * 10;
    local x = (ScrW() - totalWidth) * 0.5;
    local y = (ScrH() - totalHeight) * 0.5;
    self.YPos = y

    for k, v in ipairs(self.Icons) do
      v:SetPos(x, y);

      if (k % perRow == 0) then
        x = (ScrW() - totalWidth) * 0.5;
        y = y + 84;
      else
        x = x + iconWidth + 10;
      end
    end
  else
    local totalWidth = #self.Icons * iconWidth + (#self.Icons - 1) * 10;
    local x = (ScrW() - totalWidth) * 0.5;
    local y = (ScrH() - 74) * 0.5;

    for k, v in ipairs(self.Icons) do
      v:SetPos(x, y);

      x = x + iconWidth + 10;
    end
  end
end

function PANEL:Close()
  self.Closed = SysTime();
end

function PANEL:Think()
  self.Alpha = (math.Clamp(SysTime() - self.Created, 0, 0.1) - math.Clamp(SysTime() - (self.Closed or math.huge), 0, 0.1)) / 0.1;

  if (self.Closed and self.Alpha == 0) then
    self:Remove();
    return;
  end

  if (!self.Inspecting and !input.IsMouseDown(MOUSE_RIGHT) and !self.Closed) then
    rp.inv.DisableMenu();
  end
end

function PANEL:Paint(w, h)
  surface.SetDrawColor(0, 0, 0, self.Alpha * 70);
  surface.DrawRect(0, 0, w, h);

  draw.SimpleText(table.Count(self.Contents) .. /*'/' .. (LocalPlayer():GetUpgradeCount('pocket_space_2') * 2) + 8 ..*/ ' Items', 'rp.ui.22', ScrW()/2, (self.YPos or -20) - 5, rp.col.White, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)

  surface.SetAlphaMultiplier(self.Alpha);
end

function PANEL:PaintOver(w, h)
  surface.SetAlphaMultiplier(1);
end

vgui.Register("Pocket", PANEL, "EditablePanel");

local ITEM = {};

function ITEM:Init()
  self.Icon = self:Add("ModelImage");
  self.Icon:SetMouseInputEnabled(false);

  self.Title = "ITEM";
  self.SubTitle = '';

  self:SetSize(iconWidth, 74);
  self.Icon:SetPos(5, 5);
end

function ITEM:SetItem(itemData)
  self.ID = itemData.ID;
  self.Title = itemData.Title;
  self.SubTitle = itemData.SubTitle;
  self.Model = itemData.Model;

  self.Icon:SetModel(self.Model or "models/error.mdl");
end

function ITEM:OnMousePressed(mb)
	if (!self:GetParent().Inspecting) then  
		rp.inv.DisableMenu();
		rp.RunCommand('invdrop', tostring(self.ID))
	elseif (mb == MOUSE_RIGHT and LocalPlayer():IsSuperAdmin()) then
		local m = ui.DermaMenu()
		m:AddOption("Delete Item", function()
			net.Start("Pocket.AdminDelete")
				net.WriteEntity(self:GetParent().InspectingPlayer)
				net.WriteUInt(self.ID, 32)
			net.SendToServer()
			
			self:Remove()
		end)
		m:Open()
	end
end

function ITEM:Paint(w, h)
	draw.Blur(self)
	draw.OutlinedBox(0, 0, w, h, self:IsHovered() and rp.col.SUP or rp.col.Background, rp.col.Outline)

	surface.SetFont("rp.ui.20");
	surface.SetTextColor(255, 255, 255);
  
	local title = self.Title or "ITEM"

	local tw, th = surface.GetTextSize(title);
	if (!self.SubTitle or self.SubTitle == "") then
		surface.SetTextPos(74, (h - th) * 0.5);

		surface.DrawText(title);
	else
		local stw, sth = surface.GetTextSize(self.SubTitle);

		surface.SetTextPos(74, (h * 0.25) - (th * 0.5));
		surface.DrawText(title);

		surface.SetTextPos(74, (h * 0.75) - (sth * 0.5));
		surface.DrawText(self.SubTitle);
	end
end

vgui.Register("PocketItem", ITEM, "Panel");
