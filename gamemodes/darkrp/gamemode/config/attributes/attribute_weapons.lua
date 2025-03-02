-- "gamemodes\\darkrp\\gamemode\\config\\attributes\\attribute_weapons.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
/*local stalker = 1

rp.cfg.Weapons = {
};

local _weps  = rp.cfg.Weapons;

local WEAPONSKILL_ATTRIBUTES = {
--[[------------------------------------------------
		Сталкер:
	------------------------------------------------]]--
	[stalker] = {
		ID						= "stalkerskill",

		Name					= "Бывалый Сталкер",
		Desc					= "Позволяет Вам улучшить свои навыки выживания, улучшая свою скорость передвижения до 15%, и переносимость голода до %i%%, по достижении 100 уровня навыка, открывается ЛЕГЕНДАРНАЯ профессия - Охотник 'Компас', взять можно в фракции Охотников.",

		InitialAmount			= 0,
		MaxAmount				= 100,

		Stat1		= 1.15, 	-- Множитель ускорения
		Stat2		= 0.50, 	-- Множитель голода
		
		UpgradeMax				= 100,
		UpgradeConversionRate	= 5,

		Color 					= Color(102, 51, 153),
        Background = "rpui/attributes/stalker.png",
        ProgressText          = "Текущий прогресс",
		Attachments = {
			--{ "kry_metro_ak_mammo", 1 },
		}
	},
};

local function CW20_SetCallback_DetachAttachmentEx( wep )
	if wep._detach then
		if not wep._trueDetach then
			wep._trueDetach = wep._detach;
			wep._detach = function(...)
				wep._trueDetach(...);
				CustomizableWeaponry.callbacks.processCategory(wep, "postDetachAttachmentEx");
			end
		end
	end
end

local function __attribsys_weaponskill_UpgradeWeapon( self, ply, WEAPON )
	local amount = ply:GetAttributeAmount( self.ID );
	if amount <= 0 then return end
 
	if not _weps[ WEAPON:GetClass() ] then return end

	if self.AutoFireCap then
		if amount >= self.AutoFireCap and not WEAPON.Primary.Automatic then
			if WEAPON.CW20Weapon then
				if !table.HasValue(WEAPON.FireModes, "auto") then
					table.insert(WEAPON.FireModes, "auto")
				end
			else
				WEAPON.Primary.Automatic = true;
			end
		end
	end
 
	if WEAPON.CW20Weapon then   -- CW 2.0 Weapon Base:
		CW20_SetCallback_DetachAttachmentEx( WEAPON );
		local SWEP = weapons.GetStored( WEAPON:GetClass() );

		if self.ReloadSpeedMultiplier then
			local rsm = self.ReloadSpeedMultiplier.CW20 or 1;
			WEAPON.ReloadSpeed = SWEP.ReloadSpeed + (SWEP.ReloadSpeed*(rsm-1)) * ply:GetAttributeAmountMultiplier(self.ID);
		end
 
		if self.RecoilControl then
			WEAPON.Recoil = SWEP.Recoil * (1 - (self.RecoilControl.CW20 * ply:GetAttributeAmountMultiplier(self.ID)));
		end
	elseif WEAPON.SWBWeapon then  -- Sleek Weapon Base (SWB):
		local SWEP = weapons.GetStored( WEAPON:GetClass() );
 
		if self.ReloadSpeedMultiplier then
			local rsm = self.ReloadSpeedMultiplier.SWB or 1;
			WEAPON.ReloadSpeed = SWEP.ReloadSpeed + (SWEP.ReloadSpeed*(rsm-1)) * ply:GetAttributeAmountMultiplier(self.ID);
		end
 
		if self.RecoilControl then
			WEAPON.Recoil = SWEP.Recoil * (1 - (self.RecoilControl.SWB * ply:GetAttributeAmountMultiplier(self.ID)));
		end
	elseif WEAPON.IsFAS2Weapon then  -- FA:S2 Weapon Base:
		local SWEP = weapons.GetStored( WEAPON:GetClass() );
 
		if self.RecoilControl then
			WEAPON.Recoil = SWEP.Recoil * (1 - (self.RecoilControl.FAS2 * ply:GetAttributeAmountMultiplier(self.ID)));
		end
	end
end

if SERVER then
	hook.Add('PlayerLoadout', 'AttributeSystem.StalkerSkill', function(ply)
		local attribute_state = (ply:GetAttributeAmount( WEAPONSKILL_ATTRIBUTES[stalker].ID ) or 0) / 100
		
		local speed_multiplier = WEAPONSKILL_ATTRIBUTES[stalker].Stat1 - 1
		local hunger_multiplier = 1 / WEAPONSKILL_ATTRIBUTES[stalker].Stat2 - 1
		
		if attribute_state > 0 then 
			if not ply._DefPlyHungerRate then
				ply._DefPlyHungerRate = ply:GetHungerRateMultiplier() or 1
			end
			
			ply:SetRunSpeed( ply:GetRunSpeed() * (1 + attribute_state * speed_multiplier) )
			ply:SetHungerRateMultiplier( ply._DefPlyHungerRate + attribute_state * hunger_multiplier )
		end
	end)
end

for ATTRIBUTE_KEY, ATTRIBUTE in pairs( WEAPONSKILL_ATTRIBUTES ) do
	if CLIENT then
		if not ATTRIBUTE.TooltipDesc then
			ATTRIBUTE.TooltipDesc = function( value )
				local desc = string.format(ATTRIBUTE.Desc .. "\n", (ATTRIBUTE.DamageMultiplier and (ATTRIBUTE.DamageMultiplier - 1) or ATTRIBUTE.Stat1 or 0) * 100, (ATTRIBUTE.DescReloadSpeed and (ATTRIBUTE.DescReloadSpeed - 1) or ATTRIBUTE.Stat2 or 0) * 100, (ATTRIBUTE.DescRecoilControl or ATTRIBUTE.Stat3 or 0) * 100 )

				if ATTRIBUTE.Attachments then
					desc = desc .. "\nРазблокировка дополнений:\n"
				
					for k, v in pairs(ATTRIBUTE.Attachments) do
						local t = CustomizableWeaponry:findAttachment(v[1])

						if value >= v[2] then
							desc = desc .. "    [✓] " .. t.displayName .. "\n"
						else
							desc = desc .. "    [✗] " .. t.displayName .. " (".. v[2] ..")\n"
						end
					end
				end

				if ATTRIBUTE.AutoFireCap then
					if value >= ATTRIBUTE.AutoFireCap then
						desc = desc .. "    [✓] Автоматический режим стрельбы" .. "\n"
					else
						desc = desc .. "    [✗] Автоматический режим стрельбы" .. " (".. ATTRIBUTE.AutoFireCap ..")\n"
					end
				end
	
				desc = desc .. "\n"
				desc = desc .. "Прогресс: " .. value .. "/" .. ATTRIBUTE.UpgradeMax .. " (" .. (value/ATTRIBUTE.UpgradeMax)*100 .. "%" .. ")" .. (ATTRIBUTE.DamageMultiplier and (", увеличение урона: " .. ((ATTRIBUTE.DamageMultiplier - 1) * LocalPlayer():GetAttributeAmountMultiplier(ATTRIBUTE.ID)) * 100 ..'%') or '') .. (ATTRIBUTE.DescReloadSpeed and (', уменьшение перезарядки: '.. ((ATTRIBUTE.DescReloadSpeed - 1) * LocalPlayer():GetAttributeAmountMultiplier(ATTRIBUTE.ID)) * 100 .."%") or '') .. (ATTRIBUTE.DescRecoilControl and (", уменьшение отдачи: ".. ((ATTRIBUTE.DescRecoilControl) * LocalPlayer():GetAttributeAmountMultiplier(ATTRIBUTE.ID)) * 100 .."%") or "")

				return desc
			end
		end
	end

	AttributeSystem.Attributes[ ATTRIBUTE.ID ] = ATTRIBUTE;
end
*/