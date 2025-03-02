-- "gamemodes\\darkrp\\entities\\weapons\\hacktool\\cl_init.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
include("settings.lua")
include("shared.lua")
include("cl_hackanim1.lua")
include("cl_hackanim2.lua")
include("cl_hackanim3.lua")
include("cl_screen.lua")

local settings = {
    reloadingTime = GetConVar("hacktool_reloadingtime"),
    overheatTime = GetConVar("hacktool_overheattime"),
    hackingTime = GetConVar("hacktool_hackingtime"),
    ropeLength = GetConVar("hacktool_ropelength"),
    showPanel = CreateConVar("hacktool_showpanel", "0", FCVAR_ARCHIVE)
}

SWEP.WepSelectIcon = surface.GetTextureID( "models/weapons/hacktool/hacktool_select" )

local tr = translates.Get

local function doBeep(n,vol)
	vol = vol or 1
	if n == "beep" then
		LocalPlayer():EmitSound("buttons/button17.wav", 75, 200, vol, CHAN_AUTO)
	elseif n == "tick" then
		LocalPlayer():EmitSound("buttons/button14.wav", 75, 200, vol, CHAN_AUTO)
	elseif n == "bebeep" then
		LocalPlayer():EmitSound("buttons/button24.wav", 75, 50, vol, CHAN_AUTO)
	elseif n == "deny" then
		LocalPlayer():EmitSound("buttons/button10.wav", 75, 100, vol, CHAN_AUTO)
	elseif n == "bzz" then
		LocalPlayer():EmitSound("buttons/button10.wav", 75, 200, vol, CHAN_AUTO)
	end
end

hacktoolMats = {}
local mcnt = 0

local function recreateMaterials()
	local dim = 1024
	mcnt = mcnt + 1

	local hh = 1080
	local ww = 1920
	local pw,ph = hh*1.5, hh
	if pw > ww then
		pw,ph = ww, ww/1.5
	end

	hacktoolMats.font11 = "HackPanel1_font1_"..mcnt
	hacktoolMats.font12 = "HackPanel1_font2_"..mcnt
	hacktoolMats.font21 = "HackPanel2_font1_"..mcnt

	hacktoolMats.panelRt = GetRenderTarget("panelrt0"..mcnt, pw, ph)
	hacktoolMats.panelMat = CreateMaterial("panelrtmat0"..mcnt,"UnlitGeneric",{['$basetexture'] = hacktoolMats.panelRt})
	hacktoolMats.vmatrt = GetRenderTargetEx("vmrt0"..mcnt, dim, dim, RT_SIZE_NO_CHANGE, MATERIAL_RT_DEPTH_NONE, 8192, 0, IMAGE_FORMAT_BGRA8888)
	hacktoolMats.vmmat = Material("models/weapons/hacktool/hacktool_mon_active")

	local fontTable = {
		font = "Arial",
		extended = true,
		size = hh*0.0786,
		weight = 0,
		blursize = 0,
		scanlines = 0,
		antialias = true,
		underline = false,
		italic = false,
		strikeout = false,
		symbol = false,
		rotary = false,
		shadow = false,
		additive = false,
		outline = false,
	}

	surface.CreateFont( hacktoolMats.font11, fontTable)
	fontTable.size = hh*0.04
	surface.CreateFont( hacktoolMats.font12, fontTable)

	fontTable.size = hh*0.0671
	surface.CreateFont( hacktoolMats.font21, fontTable)

end

recreateMaterials()

local function GetRandom(seed)
	local next = seed 
	return function()
		next = (next * 22695477 + 1) % 2147483648
		return next / 2147483648
	end
end

local allowed_minigames = { 2, 3 };

net.Receive('hack_tool.gui', function()
	local swep = net.ReadEntity()
	local ent = net.ReadEntity()
	local startTime = net.ReadFloat()

	if swep.panel and swep.panel.Remove then
		swep.panel:Remove()
		swep.panel = nil
	end

	if not IsValid(ent) or ent:IsWorld() then
		return
	end

--	local panel = vgui.Create("HackPanel"..math.ceil(math.random()*3))
--  local panel = vgui.Create((ent:GetClass() == "hacktool_server" and ent.GetIsOpen and ent:GetIsOpen()) and "HackMenu0" or "HackPanel"..math.ceil(math.random()*3))
	local panel
	-- if ent:GetClass() == "hacktool_server" and ent.GetIsOpen and ent:GetIsOpen() then
	-- 	panel = vgui.Create("HackMenu0")
	-- else
		local seed = net.ReadUInt(32)
		-- panel = vgui.Create("HackPanel"..(seed % 3 + 1))
		panel = vgui.Create( "HackPanel" .. allowed_minigames[seed % #allowed_minigames + 1] );
		panel.random = GetRandom(seed)
		panel:SetUp()
	-- end

--	local panel = vgui.Create("HackMenu0")
	swep.everyPanel = swep.everyPanel or {}
	swep.everyPanel[#swep.everyPanel + 1] = panel

	panel.doBeep = doBeep

	panel.swep = swep

	panel.drawToScreen = settings.showPanel:GetBool()

	panel:SetTimeout(startTime, startTime + settings.hackingTime:GetFloat())

	swep.panel = panel
	panel.OnFail = function ()
		net.Start("hack_tool.gui")
			net.WriteEntity(swep)
			net.WriteEntity(ent)
			net.WriteUInt(0, 2)
		net.SendToServer()
	end
	panel.OnSuccess = function (self, data)
		net.Start("hack_tool.gui")
			net.WriteEntity(swep)
			net.WriteEntity(ent)
			net.WriteUInt(1, 2)
			net.WriteTable(data)
		net.SendToServer()
		panel:Remove()
	end
	panel.OnTimeOut = function() end
end)

function SWEP:Think()
    if self:GetIsHacking() and CurTime() > (self.nextBeep or 0) then
        self.nextBeep = CurTime() + (math.random() < 0.5 and 0.2 or 0.1)
        self:EmitSound("buttons/button15.wav", 100, util.SharedRandom("HackingToolSnd",220,250,CurTime()),0.4)  
    end
    if not self.mainPanel then
    	self.everyPanel = self.everyPanel or {}
        self.mainPanel = vgui.Create("HackDisplay1")
        self.everyPanel[#self.everyPanel + 1] = self.mainPanel
        self.mainPanel.swep = self
    end
    if self:GetNextUseTime() > CurTime() and self.panel and self.panel.Remove then
    	self.panel:Remove()
		self.panel = nil
    end
end

function SWEP:Initialize()
	if self:GetOwner() ~= LocalPlayer() then return end
    self:SetNextUseTime(CurTime())
	self:ClearAllPanels()
end

function SWEP:ClearAllPanels()
	if self.everyPanel then
		for k,v in pairs(self.everyPanel) do
			if v and v.Remove then
				v:Remove()
			end
		end
	end
	self.everyPanel = {}
	self.mainPanel = nil
	self.panel = nil
end

function SWEP:OnRemove()
	self:ClearAllPanels()
end

function SWEP:OwnerChanged()
	self:Initialize()
end

function SWEP:PrimaryAttack()
end

function SWEP:SecondaryAttack()
end

function SWEP:Holster()
	self:ClearAllPanels()
	return true
end

function SWEP:CustomAmmoDisplay()
	self.AmmoDisplay = self.AmmoDisplay or {}
	self.AmmoDisplay.Draw = false
	self.AmmoDisplay.PrimaryClip = self:Clip1()

	return self.AmmoDisplay

end

function SWEP:PreDrawViewModel(vm)
	if self.panel or self.mainPanel then
		vm:SetSubMaterial(1, hacktoolMats.vmmat:GetName(), true)
	end
end

function SWEP:PostDrawViewModel(vm)
	vm:SetSubMaterial()
end

local CfgOverlayPath = rp and rp.cfg.NewHackTool or {};
CfgOverlayPath = CfgOverlayPath.OverlayPath or 'overwatch/overlays/lowhealth';

local OverlayMaterial = Material(CfgOverlayPath);
local SetDrawColor = surface.SetDrawColor;
local SetMaterial = surface.SetMaterial;
local DrawTexturedRect = surface.DrawTexturedRect;

function SWEP:DrawHUD()
	if (self:GetIsOwnerFailedHack()) then
		-- _DrawMaterialOverlay(CfgOverlayPath, 0);
		SetDrawColor(255, 255, 255);
		SetMaterial(OverlayMaterial);
		DrawTexturedRect(0, 0, ScrW(), ScrH());
	end
end