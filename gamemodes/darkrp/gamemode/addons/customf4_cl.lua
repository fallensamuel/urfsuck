-- "gamemodes\\darkrp\\gamemode\\addons\\customf4_cl.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
﻿
local size_w, size_h = 1221, 837
local matFrame = Material( "stalker_pda_frame.png") -- background png
local w, h = math.min(1221, ScrW() * 0.8), math.min(837, ScrW() * 0.8 * size_h / size_w) -- background size
local offsetX, offsetY = w * 123 / size_w, h * 100 / size_h -- panel-content offset
local panelW, panelH = w * 922 / size_w, h * 635 / size_h -- panel-content size
local btnCloseX, btnCloseY = w * 1022 / size_w, h * 42 / size_h

function rp.DrawF4Content()
	local time_bonus = LocalPlayer():GetTimeMultiplayer() + rp.GetTimeMultiplier()
	
	return ui.Create('ui_frame', function(self)
		self:SetTitle('')
		self:SetSize(w, h)
		self:MakePopup()
		self:Center()

		local keydown = false

		function self:Think()
			if input.IsKeyDown(KEY_F4) and keydown then
				self:Remove()
			elseif (not input.IsKeyDown(KEY_F4)) then
				keydown = true
			end
		end

		function self:Paint(x, y)
			surface.SetDrawColor( 255, 255, 255, 255 )
			surface.SetMaterial( matFrame )
			surface.DrawTexturedRect( 0,0,x,y )

		end

		function self:PerformLayout()
			self.lblTitle:SizeToContents()
			self.lblTitle:SetPos(5, 3)
			
			self.btnClose:SetPos(btnCloseX, btnCloseY)
			self.btnClose:SetSize(50, 28)
		end

	end), offsetX, offsetY, panelW, panelH + 30
end
