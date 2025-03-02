-- "gamemodes\\darkrp\\entities\\entities\\cw_vendingmachine\\cl_init.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
--[[
	� 2013 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

include("shared.lua");

ENT.Author = "kurozael";
ENT.PrintName = "Vending Machine";
ENT.Category = 'HL2 RP'

local glowMaterial = Material("sprites/glow04_noz");

-- Called when the entity should draw.

local states = {Color(0, 0, 255), Color(255, 150, 0), Color(255, 0, 0)}
local cam,render = cam, render
function ENT:Draw()
	self:DrawModel();
	
	local glowColor = states[self:GetState()];
	local position = self:GetPos();
	local forward = self:GetForward() * 18;
	local right = self:GetRight() * -24;
	local up = self:GetUp() * 6;
	
	cam.Start3D( EyePos(), EyeAngles() );
		render.SetMaterial(glowMaterial);
		render.DrawSprite(position + forward + right + up, 20, 20, glowColor);
	cam.End3D();
end;