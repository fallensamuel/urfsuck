-- "gamemodes\\rp_base\\gamemode\\main\\sandbox\\spawnmenu\\controls\\ropematerial_cl.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
--
--  ___  ___   _   _   _    __   _   ___ ___ __ __
-- |_ _|| __| / \ | \_/ |  / _| / \ | o \ o \\ V /
--  | | | _| | o || \_/ | ( |_n| o ||   /   / \ / 
--  |_| |___||_n_||_| |_|  \__/|_n_||_|\\_|\\ |_|  2009
--										 
--
list.Set("RopeMaterials", "#ropematerial.rope", "cable/rope")
list.Set("RopeMaterials", "#ropematerial.cable", "cable/cable2")
list.Set("RopeMaterials", "#ropematerial.xbeam", "cable/xbeam")
list.Set("RopeMaterials", "#ropematerial.laser", "cable/redlaser")
list.Set("RopeMaterials", "#ropematerial.electric", "cable/blue_elec")
list.Set("RopeMaterials", "#ropematerial.physbeam", "cable/physbeam")
list.Set("RopeMaterials", "#ropematerial.hydra", "cable/hydra")
local PANEL = {}

--[[---------------------------------------------------------
   Name: Paint
-----------------------------------------------------------]]
function PANEL:Init()
	self:SetItemWidth(0.14)
	self:SetItemHeight(0.3)
	self:SetAutoHeight(true)
	local mats = list.Get("RopeMaterials")

	for k, v in pairs(mats) do
		self:AddMaterial(k, v)
	end
end

function PANEL:Paint(w, h)
	draw.RoundedBox(4, 0, 0, w, h, Color(128, 128, 128, 255))
end

vgui.Register("RopeMaterial", PANEL, "MatSelect")