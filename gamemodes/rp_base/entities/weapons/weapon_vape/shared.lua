-- "gamemodes\\rp_base\\entities\\weapons\\weapon_vape\\shared.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal

SWEP.Author = "Swamp Onions"

SWEP.Instructions = "ПОДЫМИМ БЛЯТЬ!\nПравая конпка - менять цвет."

SWEP.IconLetter	= "V"
SWEP.Category = "Vape"

SWEP.ViewModel = "models/vape_pen.mdl"
SWEP.WorldModel = "models/vape_pen.mdl"
SWEP.Spawnable			= true
SWEP.AdminOnly			= false

SWEP.Primary.Clipsize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "none"

SWEP.Secondary.Clipsize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

SWEP.DrawAmmo = false
SWEP.Slot				= 1
SWEP.SlotPos			= 1
SWEP.HoldType 			= "slam"

SWEP.color = 1

SWEP.ColorTable = {
	Color(255, 255, 255), 
	Color(255, 248, 220),
	Color(240, 248, 255),
	Color(135, 206, 235),
	Color(152, 251, 152),
	Color(221, 160, 221),
	Color(238, 213, 183),
	Color(218, 112, 214),
    Color(255, 0, 0),
    Color(255, 20, 147),
    Color(127, 255, 212),
    Color(75, 0, 130),
    Color(0, 255, 0),
}

SWEP.SecondarySound = {Sound('ambient/voices/cough1.wav'), Sound('ambient/voices/cough2.wav'), Sound('ambient/voices/cough3.wav'), Sound('ambient/voices/cough4.wav')}

function SWEP:Deploy()
	self:SetHoldType("slam")
end

function SWEP:PrimaryAttack()
	self.Weapon:SetNextPrimaryFire(CurTime() + 2 )
end

function SWEP:SecondaryAttack()
	self.Weapon:SetNextSecondaryFire(CurTime() + 0.3 )
	if not IsFirstTimePredicted() then return end
	if self.canChangeColor then
		self.color = self.color + 1
		if self.color > #self.ColorTable then
			self.color = 1
		end
		if SERVER then
			self.Owner:SetNWInt('vapeColor', self.color)
		else
			local vm = self.Owner:GetViewModel()

			if IsValid(vm) then
				vm:SetColor(self.ColorTable[self.color])
			end
		end
	elseif CLIENT then
		chat.AddText(translates and translates.Get( 'Вам нужно улучшить Электронную Сигарету, чтобы иметь возможность менять цвет дыма.' ) or 'Вам нужно улучшить Электронную Сигарету, чтобы иметь возможность менять цвет дыма.')
	end
end