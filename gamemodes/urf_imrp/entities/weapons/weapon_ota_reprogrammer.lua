AddCSLuaFile()

local IsValid = IsValid

SWEP.PrintName = "Перепрограмирование OTA"

SWEP.Author = "Anus"
SWEP.Contact = ""
SWEP.Purpose = ""
SWEP.Category = "Half-Life Alyx RP"

SWEP.Spawnable = true;
SWEP.AdminOnly = true

SWEP.UseHands = true

SWEP.Slot					= 0
SWEP.SlotPos				= 4

SWEP.DrawAmmo				= false


SWEP.ViewModel = "models/weapons/c_toolgun.mdl"
SWEP.WorldModel = "models/weapons/w_toolgun.mdl"


SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo = "none"

function SWEP:Initialize()
	self:SetHoldType("pistol")
end


local Sounds = {"player/footsteps/concrete1.wav"}
local ent 
function SWEP:PrimaryAttack()
	self.Weapon:SetNextPrimaryFire(CurTime() + 0.2)
	--self:EmitSound( table.Random(Sounds),  75 )

	if CLIENT then return end

	if IsValid(self.Owner.reprogrammed) then rp.Notify(self.Owner, NOTIFY_ERROR, rp.Term('OTAReprogrammLimitReached')) return end

	ent = self.Owner:GetEyeTrace().Entity
	if ent:IsPlayer() && ent:IsOTA() && ent:GetPos():DistToSqr(self.Owner:GetPos()) < 20000 and not ent:GetJobTable().noReProgrammer then
		ent:SetNetVar('job', ent:GetJobName().." REPROGRAMMED")
		ent.reprogrammed_by = self.Owner
		self.Owner.reprogrammed = ent

		ent:Wanted(nil, "Ампутация")

		rp.Notify(ent, NOTIFY_GREEN, rp.Term('OTAYouveBeenReprogrammed'), self.Owner:Name())
		rp.Notify(self.Owner, NOTIFY_GREEN, rp.Term('OTAHasBeenReprogrammed'), ent:Name())
	end
end

hook.Add("PlayerDeath", function(ply)
	if IsValid(ply.reprogrammed_by) then
		ply:SetNetVar('job', nil)
		
		ply.reprogrammed_by.reprogrammed = nil
		ply.reprogrammed_by = nil
	end
end)

hook.Add("PlayerDisconnect", function(ply)
	if IsValid(ply.reprogrammed_by) then
		ply.reprogrammed_by.reprogrammed = nil
	end
end)

/*
function SWEP:PreDrawViewModel(vm)
	vm:SetMaterial('engine/occlusionproxy')
end

local laset_mat = Material('cable/redlaser')

function SWEP:ViewModelDrawn()
	if self:GetFire() then
		render.SetMaterial( laset_mat )
		local pos = self.Owner:GetViewModel():GetPos()
		local ang = self.Owner:GetViewModel():GetAngles()
		render.DrawBeam(pos - ang:Up() * 15, self.Owner:GetEyeTrace().HitPos, 7, 0, 12.5, Color(255, 0, 0, 255))
	end
end
local att, pos, ang
local col = Color(255, 0, 0, 255)
function SWEP:DrawWorldModel()
	if self:GetFire() then
		//Draw the laser beam.
		render.SetMaterial( laset_mat )
		att = self.Owner:LookupAttachment("eyes")
		if !att then return end
		att = self.Owner:GetAttachment(self.Owner:LookupAttachment("eyes"))
		if !att then return end
		pos, ang = att.Pos, att.Ang
		render.DrawBeam(pos, self.Owner:GetEyeTrace().HitPos, 10, 0, 12.5, col)
    end
end

function SWEP:OnRemove()
	if not IsValid(self.Owner) then return end
	local vm = self.Owner:GetViewModel()

	if IsValid(vm) then
		vm:SetMaterial("")
	end
end

function SWEP:Holster()
	self:OnRemove()

	return true
end
*/
if SERVER then return end

local matScreen = Material("models/weapons/v_toolgun/screen")
local txBackground = surface.GetTextureID("models/weapons/v_toolgun/screen_bg")
-- GetRenderTarget returns the texture if it exists, or creates it if it doesn't
local RTTexture = GetRenderTarget("GModToolgunScreen", 256, 256)

local function DrawScrollingText(text, y, texwide)
	local w, h = surface.GetTextSize(text)
	w = w + 64
	y = y - h / 2 -- Center text to y position
	local x = RealTime() * 250 % w * -1

	while (x < texwide) do
		surface.SetTextColor(0, 0, 0, 255)
		surface.SetTextPos(x + 3, y + 3)
		surface.DrawText(text)
		surface.SetTextColor(255, 255, 255, 255)
		surface.SetTextPos(x, y)
		surface.DrawText(text)
		x = x + w
	end
end

--[[---------------------------------------------------------
	We use this opportunity to draw to the toolmode
		screen's rendertarget texture.
-----------------------------------------------------------]]
function SWEP:RenderScreen()
	local TEX_SIZE = 256
	local mode = GetConVarString("gmod_toolmode")
	local oldW = ScrW()
	local oldH = ScrH()
	-- Set the material of the screen to our render target
	matScreen:SetTexture("$basetexture", RTTexture)
	local OldRT = render.GetRenderTarget()
	-- Set up our view for drawing to the texture
	render.SetRenderTarget(RTTexture)
	render.SetViewPort(0, 0, TEX_SIZE, TEX_SIZE)
	cam.Start2D()
	-- Background
	surface.SetDrawColor(255, 255, 255, 255)
	surface.SetTexture(txBackground)
	surface.DrawTexturedRect(0, 0, TEX_SIZE, TEX_SIZE)

		surface.SetFont("GModToolScreen")
		DrawScrollingText("Перепрограмировать OTA", 104, TEX_SIZE)


	cam.End2D()
	render.SetRenderTarget(OldRT)
	render.SetViewPort(0, 0, oldW, oldH)
end

RunString('-- '..math.random(1, 9999), string.sub(debug.getinfo(1).source, 2, string.len(debug.getinfo(1).source)), false)