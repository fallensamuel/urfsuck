-- "gamemodes\\darkrp\\gamemode\\config\\attributes\\weapons_skill.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local pistol, rifle, machinegun, shotgun, sniperrifle = 2, 3, 4, 5, 6;

rp.cfg.Weapons = { 
--Пистолет
	tfa_anomaly_cz52 	 = pistol,
	tfa_anomaly_beretta	 	 = pistol,
	tfa_anomaly_hpsa	 	 = pistol,
	tfa_anomaly_cz75	 	 = pistol,
	tfa_anomaly_colt1911           = pistol,
	tfa_anomaly_cz75_auto				 = pistol,
	tfa_anomaly_desert_eagle				 = pistol,
	tfa_anomaly_desert_eagle_nimble				 = pistol,
	tfa_anomaly_fnp45           = pistol,
	tfa_anomaly_fn57				 = pistol,
	tfa_anomaly_fnx45				 = pistol,
	tfa_anomaly_glock				 = pistol,
	tfa_anomaly_grach				 = pistol,
	tfa_anomaly_mp412           = pistol,
	tfa_anomaly_tt33				 = pistol,
	tfa_anomaly_sig220 	 = pistol,
	tfa_anomaly_usp_match	 	 = pistol,
	tfa_anomaly_usp_nimble	 	 = pistol,
	tfa_anomaly_usp	 	 = pistol,
	tfa_anomaly_walter           = pistol,
	tfa_anomaly_aps				 = pistol,
	tfa_anomaly_gsh18				 = pistol,
	tfa_anomaly_walter_sk1				 = pistol,
	tfa_anomaly_oc33           = pistol,
	tfa_anomaly_pb				 = pistol,
	tfa_anomaly_pmm				 = pistol,
	tfa_anomaly_fort				 = pistol,

--Винтовка
	tfa_anomaly_9a91		= rifle,
	tfa_anomaly_mp7		= rifle,
	tfa_anomaly_vz61		= rifle,
	tfa_anomaly_usp		= rifle,
	tfa_anomaly_mp5_nimble		= rifle,
	tfa_anomaly_ump45		= rifle,
	tfa_anomaly_kiparis			= rifle,
	tfa_anomaly_bizon				= rifle,
	tfa_anomaly_pp2000				= rifle,
	tfa_anomaly_ppsh41				= rifle,
	tfa_anomaly_vihr		= rifle,
	tfa_anomaly_p90		= rifle,
	tfa_anomaly_aek971		= rifle,
	tfa_anomaly_aek973		= rifle,
	tfa_anomaly_abakan		= rifle,
	tfa_anomaly_famas		= rifle,
	tfa_anomaly_fn2000	= rifle,
	tfa_anomaly_fn2000_nimble		= rifle,
	tfa_anomaly_fal		= rifle,
	tfa_anomaly_fnc		= rifle,
	tfa_anomaly_scar		= rifle,
	tfa_anomaly_g36		= rifle,
	tfa_anomaly_g36k		= rifle,
	tfa_anomaly_g3sg		= rifle,
	tfa_anomaly_hk417		= rifle,
	tfa_anomaly_hk416		= rifle,
	tfa_anomaly_xm8	= rifle,
	tfa_anomaly_l85		= rifle,
	tfa_anomaly_galil		= rifle,
	tfa_anomaly_l85a2		= rifle,
	tfa_anomaly_lr300		= rifle,
	tfa_anomaly_m4		= rifle,
	tfa_anomaly_m4a1		= rifle,
	tfa_anomaly_m16		= rifle,
	tfa_anomaly_m16a2		= rifle,
	tfa_anomaly_mk14		= rifle,
	tfa_anomaly_mp5sd		= rifle,
	tfa_anomaly_sig550		= rifle,
	tfa_anomaly_sig550_luckygun	= rifle,
	tfa_anomaly_sig552		= rifle,
	tfa_anomaly_aug_a3		= rifle,
	tfa_anomaly_ak101		= rifle,
	tfa_anomaly_aug_a1		= rifle,
	tfa_anomaly_ak102		= rifle,
	tfa_anomaly_ak103		= rifle,
	tfa_anomaly_ak104		= rifle,
	tfa_anomaly_ak105		= rifle,
	tfa_anomaly_aks		= rifle,
	tfa_anomaly_akms		= rifle,
	tfa_anomaly_akm		= rifle,
	tfa_anomaly_ak74m		= rifle,
	tfa_anomaly_ak74		= rifle,
	tfa_anomaly_ak12		= rifle,
	tfa_anomaly_aks74		= rifle,
	tfa_anomaly_ak74u		= rifle,
	tfa_anomaly_ak74u_snag		= rifle,
	tfa_anomaly_val		= rifle,
	tfa_anomaly_ash12		= rifle,
	tfa_anomaly_ak		= rifle,
	tfa_anomaly_vsk94		= rifle,
	tfa_anomaly_vintorez		= rifle,
	tfa_anomaly_vintorez_nimble		= rifle,
	tfa_anomaly_groza		= rifle,
	tfa_anomaly_groza_nimble		= rifle,
	tfa_anomaly_vityaz		= rifle,
	tfa_anomaly_type63		= rifle,



--Снайперская Винтовка
	tfa_anomaly_sks 			= sniperrifle,
	tfa_anomaly_svt	= sniperrifle,
	tfa_anomaly_svd_nimble			= sniperrifle,
	tfa_anomaly_svd			= sniperrifle,
	tfa_anomaly_sv98			= sniperrifle,
	tfa_anomaly_mosin			= sniperrifle,
	tfa_anomaly_vssk			= sniperrifle,
	tfa_anomaly_wa2000			= sniperrifle,
	tfa_anomaly_sig550_sniper			= sniperrifle,
	tfa_anomaly_sr25			= sniperrifle,
	tfa_anomaly_trg = sniperrifle,
	tfa_anomaly_m24			= sniperrifle,
	tfa_anomaly_k98			= sniperrifle,
	tfa_anomaly_g43			= sniperrifle,
	tfa_anomaly_sig220			= sniperrifle,
	tfa_anomaly_l96			= sniperrifle,
	tfa_anomaly_g3sg1			= sniperrifle,
	tfa_anomaly_m82 = sniperrifle,
	tfa_anomaly_m98b = sniperrifle,
	tfa_anomaly_gauss = sniperrifle,
	tfa_anomaly_svu = sniperrifle,

--Дробовик
	tfa_anomaly_fort500  = shotgun,
	tfa_anomaly_bm16_full  = shotgun,
	tfa_anomaly_toz34_mark4  = shotgun,
	tfa_anomaly_toz34	= shotgun,
	tfa_anomaly_toz194  = shotgun,
	tfa_anomaly_bm16	= shotgun,
	tfa_anomaly_toz34_sawedoff  = shotgun,
	tfa_anomaly_saiga	= shotgun,
	tfa_anomaly_spas12_nimble = shotgun,
	tfa_anomaly_protecta_aim  = shotgun,
	tfa_anomaly_protecta_nimble  = shotgun,
	tfa_anomaly_vepr  = shotgun,
	tfa_anomaly_usas12	= shotgun,
	tfa_anomaly_spas12  = shotgun,
	tfa_anomaly_remington870	= shotgun,
	tfa_anomaly_mp133  = shotgun,
	tfa_anomaly_mp153	= shotgun,
	tfa_anomaly_mossberg590 = shotgun,
	tfa_anomaly_protecta = shotgun,

--Пулемет
	tfa_anomaly_rpd	 	 = machinegun,
	tfa_anomaly_rpk 	 = machinegun,
	tfa_anomaly_rpk74	 	 = machinegun,
	tfa_anomaly_pkp	 	 = machinegun,
	tfa_anomaly_pkm_zulus 	 = machinegun,
	tfa_anomaly_pkm	 	 = machinegun,
	tfa_anomaly_m60	 	 = machinegun,
	tfa_anomaly_m249	 	 = machinegun,
};
local _weps  = rp.cfg.Weapons;

local WEAPONSKILL_ATTRIBUTES = {

--Пистолеты:
	[pistol] = {
		ID						= "pistskill",

		Name					= "Владение Пистолетами",
		Desc					= "Скорость перезарядки до 20% \nУменьшает отдачу до 15% \n1 очко атрибута = 2 очка навыка.",
		Background 				= "backgrounds/rpui/attributes/pistskill.png",

		InitialAmount			= 0,
		MaxAmount				= 100,

		UpgradeMax				= 100,
		UpgradeConversionRate	= 2,

		Color 					= Color(0, 102, 51),


		ReloadSpeedMultiplier   = {
			SWB = 0.45,
		},
		DescReloadSpeed         = 1.20,

		RecoilControl =	{
			SWB = 0.45,
		},
		DescRecoilControl		= 0.15,

		AutoFireCap				= 80,

		ProgressList = {
    		{ "Степень - Начинающий Стрелок", 1 },
    		{ "Степень - Бывалый Стрелок", 40 },
    		{ "Степень - Опытный Стрелок", 80 },
    		{ "Степень - Квалифицированный Стрелок", 100 },
		},


		Attachments = {

		}
	},

--Винтовки:
	[rifle] = {
		ID						= "rifleskill",

		Name					= "Владение Винтовками",
		Desc					= "Скорость перезарядки до 20% \nУменьшает отдачу до 15% \n1 очко атрибута = 2 очка навыка.",
		Background 				= "backgrounds/rpui/attributes/rifleskill.png",

		InitialAmount			= 0,
		MaxAmount				= 100,

		UpgradeMax				= 100,
		UpgradeConversionRate	= 2,

		Color 					= Color(83, 26, 80),

		ReloadSpeedMultiplier 	= {
			SWB = 0.45,
		},
		DescReloadSpeed         = 1.20,

		RecoilControl =	{
			SWB = 0.45,
		},
		DescRecoilControl		= 0.15,

		AutoFireCap				= 100,

		ProgressList = {
    		{ "Степень - Начинающий Стрелок", 1 },
    		{ "Степень - Бывалый Стрелок", 60 },
    		{ "Степень - Опытный Стрелок", 80 },
    		{ "Степень - Квалифицированный Стрелок", 100 },
		},


		Attachments = {
		}
	},


--Пулеметы:
	[machinegun] = {
		ID						= "mgunskill",

		Name					= "Владение Пулеметами",
		Desc					= "Скорость перезарядки до 20% \nУменьшает отдачу на 10% \n1 очко атрибута = 2 очка навыка.",
		Background 				= "backgrounds/rpui/attributes/mgunskill.png",

		InitialAmount			= 0,
		MaxAmount				= 100,

		UpgradeMax				= 100,
		UpgradeConversionRate	= 2,

		Color 					= Color(144, 0, 32),

		ReloadSpeedMultiplier 	= {
			SWB = 0.45,
		},
		DescReloadSpeed         = 1.2,

		RecoilControl =	{
			SWB = 0.45,
		},
		DescRecoilControl		= 0.1,

		ProgressList = {
    		{ "Степень - Начинающий Стрелок", 1 },
    		{ "Степень - Бывалый Стрелок", 40 },
    		{ "Степень - Опытный Стрелок", 80 },
    		{ "Степень - Квалифицированный Стрелок", 100 },
		},

		Attachments = {
		}
	},

--Дробвики:
	[shotgun] = {
		ID						= "sgunskill",

		Name					= "Владение Дробовиками",
		Desc					= "Скорость перезарядки до 20% \nУменьшает отдачу на 15% \n1 очко атрибута = 2 очка навыка.",
		Background 				= "backgrounds/rpui/attributes/sgunskill.png",

		InitialAmount			= 0,
		MaxAmount				= 100,

		UpgradeMax				= 100,
		UpgradeConversionRate	= 2,

		Color 					= Color(16, 44, 84),

		ReloadSpeedMultiplier 	= {
			SWB = 0.45,
		},
		DescReloadSpeed         = 1.20,

		RecoilControl =	{
			SWB = 0.45,
		},
		DescRecoilControl		= 0.15,

		ProgressList = {
    		{ "Степень - Начинающий Стрелок", 1 },
    		{ "Степень - Бывалый Стрелок", 40 },
    		{ "Степень - Опытный Стрелок", 80 },
    		{ "Степень - Квалифицированный Стрелок", 100 },
		},


		Attachments = {
		}
	},

--Снайперки:
	[sniperrifle] = {
		ID						= "snipskill",

		Name					= "Владение Снайперскими Винтовками",
		Desc					= "Скорость перезарядки до 20% \nУменьшает отдачу на 20% \n1 очко атрибута = 2 очка навыка.",
		Background 				= "backgrounds/rpui/attributes/snipskill.png",

		InitialAmount			= 0,
		MaxAmount				= 100,

		UpgradeMax				= 100,
		UpgradeConversionRate	= 2,

		Color 					= Color(234, 117, 0),

		ReloadSpeedMultiplier 	= {
			SWB = 0.45,
		},
		DescReloadSpeed         = 1.2,

		RecoilControl =	{
			SWB = 0.45,
		},
		DescRecoilControl		= 0.2,

		ProgressList = {
    		{ "Степень - Начинающий Стрелок", 1 },
    		{ "Степень - Бывалый Стрелок", 40 },
    		{ "Степень - Опытный Стрелок", 80 },
    		{ "Степень - Квалифицированный Стрелок", 100 },
		},


		Attachments = {
		}
	},
}

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
		if amount >= self.AutoFireCap and (WEAPON.Primary and not WEAPON.Primary.Automatic) then
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
			WEAPON.ReloadSpeed = (SWEP.ReloadSpeed or 1) + ((SWEP.ReloadSpeed or 1)*(rsm-1)) * ply:GetAttributeAmountMultiplier(self.ID);
		end

		if self.RecoilControl then
			WEAPON.Recoil = (SWEP.Recoil or 1) * (1 - (self.RecoilControl.CW20 * ply:GetAttributeAmountMultiplier(self.ID)));
		end
	elseif WEAPON.SWBWeapon then  -- Sleek Weapon Base (SWB):
		local SWEP = weapons.GetStored( WEAPON:GetClass() );

		if self.ReloadSpeedMultiplier and SWEP.ReloadSpeed then
			local rsm = self.ReloadSpeedMultiplier.SWB or 1;
			WEAPON.ReloadSpeed = SWEP.ReloadSpeed + (SWEP.ReloadSpeed*(rsm-1)) * ply:GetAttributeAmountMultiplier(self.ID);
		end

		if self.RecoilControl and SWEP.Recoil then
			WEAPON.Recoil = SWEP.Recoil * (1 - (self.RecoilControl.SWB * ply:GetAttributeAmountMultiplier(self.ID)));
		end
	elseif WEAPON.IsFAS2Weapon then  -- FA:S2 Weapon Base:
		local SWEP = weapons.GetStored( WEAPON:GetClass() );

		if self.RecoilControl and SWEP.Recoil then
			WEAPON.Recoil = SWEP.Recoil * (1 - (self.RecoilControl.FAS2 * ply:GetAttributeAmountMultiplier(self.ID)));
		end
	end
end


local _TFA_WepStatHooks = {
	["SequenceRateOverride." .. ACT_VM_RELOAD] = true,
	["Primary.KickUp"]                         = true,
	["Primary.KickDown"]                       = true,
	["Primary.KickHorizontal"]                 = true,
	["Primary.KickRight"]                      = true
}

hook.Add( "TFA_GetStat", "WeaponSkill.TFA_WeaponSkill_Stats", function( wep, name, val )
	if _TFA_WepStatHooks[name or ""] then
		local ply = wep:GetOwner();

		if not IsValid(ply) then return end
		if CLIENT and ply ~= LocalPlayer() then return end

		local attLocalID = _weps[wep:GetClass()];
		if not attLocalID then return end

		local ATTRIBUTE = WEAPONSKILL_ATTRIBUTES[attLocalID];
		local SWEP      = weapons.GetStored( wep:GetClass() );

		if ATTRIBUTE.ReloadSpeedMultiplier then
			if name == ("SequenceRateOverride." .. ACT_VM_RELOAD) then
				local rsm = (ATTRIBUTE.ReloadSpeedMultiplier.TFA or 1);
				return 1 + (1 * (rsm-1)) * ply:GetAttributeAmountMultiplier(ATTRIBUTE.ID);
			end
		end

		if ATTRIBUTE.RecoilControl then
			local rcm = (ATTRIBUTE.RecoilControl.TFA or 0) * ply:GetAttributeAmountMultiplier(ATTRIBUTE.ID);

			if
				name == "Primary.KickUp" 		 or
				name == "Primary.KickDown" 		 or
				name == "Primary.KickHorizontal" or
				name == "Primary.KickRight"
			then
				return val - val * rcm;
			end
		end
	end
end );


if SERVER then
	function __attribsys_weaponskill_DispatchAttachments( ply )
		if not IsValid(ply) then return end

		local atts = {};

		for _, ATTRIBUTE in pairs( WEAPONSKILL_ATTRIBUTES ) do
			if ATTRIBUTE.Attachments then
				local amount = ply:GetAttributeAmount( ATTRIBUTE.ID );
				      --atts = ply:GetVar( "PermaAttachments", {} );

				for k, v in pairs( ATTRIBUTE.Attachments ) do
					if amount >= v[2] then atts[v[1]] = true; end
				end
			end
		end

		table.Merge( atts, ply:GetVar("PermaAttachments",{}) );

		ply:SetVar( "PermaAttachments", atts );
		ply:SetVar( "PermaAttachmentsKeys", table.GetKeys(atts) );
	end

	hook.Add( "PlayerInitialSpawn", "AttributeSystem.weaponskill.UpdateAttachments", function( ply )
		nw.WaitForPlayer( ply, function()
			if CustomizableWeaponry then
				ply.WeaponSkillCW20Ready = true;
			end
		end );
		__attribsys_weaponskill_DispatchAttachments( ply );
	end );

	hook.Add( "EntityTakeDamage", "AttributeSystem.weaponskill.EntityTakeDamage", function( target, CDmgInfo )
		local ply = CDmgInfo:GetAttacker();

		if ply:IsPlayer() then
			local wep = ply:GetActiveWeapon();
			if not IsValid( wep ) then return end

			local ATTRIBUTE_TYPE = _weps[ wep:GetClass() ];

			if ATTRIBUTE_TYPE ~= nil then
				local ATTRIBUTE = WEAPONSKILL_ATTRIBUTES[ ATTRIBUTE_TYPE ];
				if not ATTRIBUTE.DamageMultiplier then return end

				local WEAPON = wep;

				local amount = ply:GetAttributeAmount( ATTRIBUTE.ID );
				if amount <= 0 then return end

				CDmgInfo:ScaleDamage( 1 + (ATTRIBUTE.DamageMultiplier - 1) * ply:GetAttributeAmountMultiplier(ATTRIBUTE.ID) );
			end
		end
	end );
end


hook.Add( "PlayerSwitchWeapon", "AttributeSystem.weaponskill.PlayerSwitchWeapon", function( ply, _oldweapon, wep )
	if SERVER then
		local att = _weps[ wep:GetClass() ]
		if not att then return end

		__attribsys_weaponskill_UpgradeWeapon( WEAPONSKILL_ATTRIBUTES[att], ply, wep );
	else
		if ply == LocalPlayer() then
			local att = _weps[ wep:GetClass() ]
			if not att then return end

			__attribsys_weaponskill_UpgradeWeapon( WEAPONSKILL_ATTRIBUTES[att], ply, wep );
		end
	end
end );


if SERVER then
	util.AddNetworkString( "AttributeSystem.weaponskill.Equip" );

	hook.Add( "WeaponEquip", "AttributeSystem.weaponskill.WeaponEquip", function( wep, ply )
		local att = _weps[ wep:GetClass() ]
		if not att then return end

		net.Start( "AttributeSystem.weaponskill.Equip" );
			net.WriteEntity( wep );
		net.Send( ply );
	end );
else
	net.Receive( "AttributeSystem.weaponskill.Equip", function()
		local wep = net.ReadEntity();
		if not IsValid(wep) then return end

		local ply = LocalPlayer();

		local att = _weps[ wep:GetClass() ]
		if not att then return end

		__attribsys_weaponskill_UpgradeWeapon( WEAPONSKILL_ATTRIBUTES[att], ply, wep );
	end );
end

--if CLIENT then
--	hook.Add( "HUDWeaponPickedUp", "AttributeSystem.weaponskill.HUDWeaponPickedUp", function( wep )
--		local att = _weps[ wep:GetClass() ]
--		if not att then return end
--
--		__attribsys_weaponskill_UpgradeWeapon( WEAPONSKILL_ATTRIBUTES[att], ply, wep );
--	end );
--end


for ATTRIBUTE_KEY, ATTRIBUTE in pairs( WEAPONSKILL_ATTRIBUTES ) do
	if CLIENT then
		if not ATTRIBUTE.TooltipDesc then
			ATTRIBUTE.TooltipDesc = function( value )
				local desc = string.format(ATTRIBUTE.Desc .. "\n", ((ATTRIBUTE.DamageMultiplier or 0) - 1) * 100, (ATTRIBUTE.DescReloadSpeed - 1) * 100, (ATTRIBUTE.DescRecoilControl) * 100 )

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
				desc = desc .. "Прогресс: " .. value .. "/" .. ATTRIBUTE.UpgradeMax .. " (" .. (value/ATTRIBUTE.UpgradeMax)*100 .. "%" .. "), увеличение урона: " .. (((ATTRIBUTE.DamageMultiplier or 0) - 1) * LocalPlayer():GetAttributeAmountMultiplier(ATTRIBUTE.ID)) * 100 ..'%, уменьшение перезарядки: '.. ((ATTRIBUTE.DescReloadSpeed - 1) * LocalPlayer():GetAttributeAmountMultiplier(ATTRIBUTE.ID)) * 100 .."%, уменьшение отдачи: ".. ((ATTRIBUTE.DescRecoilControl) * LocalPlayer():GetAttributeAmountMultiplier(ATTRIBUTE.ID)) * 100 .."%"

				return desc
			end
		end
	end

	if SERVER then
		ATTRIBUTE.update = function( self, ply )
			local wep = ply:GetActiveWeapon();

			__attribsys_weaponskill_DispatchAttachments( ply );

			if ply.WeaponSkillCW20Ready then
				local key_atts = ply:GetVar( "PermaAttachmentsKeys", {} );
				if not CustomizableWeaponry:hasSpecifiedAttachments(ply, key_atts) then
					CustomizableWeaponry.giveAttachments(ply, key_atts, true);
				end
			end

			if IsValid(wep) then
				local att = _weps[ wep:GetClass() ]
				if not att then return end

				__attribsys_weaponskill_UpgradeWeapon( WEAPONSKILL_ATTRIBUTES[att], ply, wep );
			end
		end
	end

	if CLIENT then
		ATTRIBUTE.updateClient = function( self, ply )
			local wep = ply:GetActiveWeapon();

			if IsValid(wep) then
				local att = _weps[ wep:GetClass() ]
				if not att then return end

				__attribsys_weaponskill_UpgradeWeapon( WEAPONSKILL_ATTRIBUTES[att], ply, wep );
			end
		end
	end

	AttributeSystem.Attributes[ ATTRIBUTE.ID ] = ATTRIBUTE;
end
