include("shared.lua")

--[[---------------------------------------------------------
   Name: ENT:Draw()
---------------------------------------------------------]]
function ENT:Draw()
	self:DrawModel()
end

net.Receive('rp.LockdownMenu', function()
	local fr = ui.Create('ui_frame', function(self, p)
		self:SetTitle("Статус-Коды")
		self:SetSize(.2, .3)
		self:Center()
		self:MakePopup()
	end, cont)

	local scroll = ui.Create('ui_scrollpanel', function(self)
		self:DockMargin(0, 3, 0, 0)
		self:Dock(FILL)
	end, fr)

	for k, v in pairs(rp.cfg.Lockdowns) do
		ui.Create('DButton', function(self)
			self:SetSize(90, 30)
			self:SetText(v.name)
			self.DoClick = function() fr:Close() net.Start('rp.LockdownMenu') net.WriteUInt(k, 4) net.SendToServer() end
			scroll:AddItem(self)
		end)
	end
end)

local glowMaterial = Material("sprites/glow04_noz");

-- Called when the entity should draw.

local cam,render = cam, render
function ENT:Draw()
	self:DrawModel();
	
	local glowColor = nw.GetGlobal('lockdown') && rp.cfg.Lockdowns[nw.GetGlobal('lockdown')].color || Color(0, 250, 0)
	glowColor.a = 100
	local position = self:GetPos();
	local forward = self:GetForward() * 4;
	local right = self:GetRight() * 1;
	local up = self:GetUp() * 2;
	
	cam.Start3D( EyePos(), EyeAngles() );
		render.SetMaterial(glowMaterial);
		render.DrawSprite(position + forward + right + up, 20, 20, glowColor);
	cam.End3D();
end;