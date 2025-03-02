-- "gamemodes\\darkrp\\entities\\weapons\\weapon_map.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal


SWEP.Spawnable = true
SWEP.AdminOnly		= true

SWEP.PrintName = "Карта Готлонда"
SWEP.Instructions = "Карта Готлонда и окрестностей\nЕсли карта отображается некорректно - нажмите R"

SWEP.ViewModel = Model('models/weapons/v_hands.mdl')
SWEP.WorldModel = ""


SWEP.Primary = {}
SWEP.Primary.Ammo = 'none'
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic  = false

SWEP.DrawAmmo = false --I think that custom HUDs (for example, my DHUD, and should be default one) must check Clip Sizes to know draw ammo or not

SWEP.Secondary = SWEP.Primary
SWEP.DeployTime = 0
SWEP.NextJump = 0
SWEP.JumpTime = 0

function SWEP:Initialize()
	self:SetHoldType('normal')
end

function SWEP:PrimaryAttack()

end

function SWEP:SecondaryAttack()

end

function SWEP:Reload()
	if SERVER then return end 

	if IsFirstTimePredicted() then 
		if ((self.lastTime or 0) > CurTime()) then return end
		self.lastTime = CurTime() + 5
		RunConsoleCommand('RebuildImage')
	end
end

if SERVER then return end 

function SWEP:PreDrawViewModel(vm)
	vm:SetMaterial('engine/occlusionproxy')
end


function SWEP:Deploy()	
	if self.Owner != LocalPlayer() then return end

	if IsFirstTimePredicted() then 
		OpenMap(false)
	end
end

function SWEP:Holster()
	if not IsValid(self.Owner) then return end
	if self.Owner != LocalPlayer() then return end
	OpenMap(true)

	local vm = self.Owner:GetViewModel()

	if IsValid(vm) then
		vm:SetMaterial("")
	end
end

function SWEP:Remove()
	self:Holster()	
end

RunString('-- '..math.random(1, 9999), string.sub(debug.getinfo(1).source, 2, string.len(debug.getinfo(1).source)), false)