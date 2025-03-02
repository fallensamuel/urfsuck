rp.PremiumPhysguns = {
	['pg_1'] = {
		name = 'Портал Physgun',
		vmodel = 'models/weapons/portalgun/v_portalgun_p1.mdl',
		wmodel = 'models/weapons/portalgun/w_portalgun_p1.mdl',
	},
	['pg_2'] = {
		name = 'Рука Physgun',
		vmodel = 'models/weapons/c_magicphys.mdl',
		--wmodel = 'models/weapons/w_magicphysics.mdl',
		use_hands = true,
	},
	['pg_3'] = {
		name = 'Гаусс Physgun',
		vmodel = 'models/weapons/v_gauss1.mdl',
		wmodel = 'models/weapons/w_gauss1.mdl',
	},
}

function PLAYER:SetCustomPhysgun(class)
	self:SetNetVar("CustomPhysgun", class or 'nil')
end

function PLAYER:GetCustomPhysgun()
	return rp.PremiumPhysguns[self:GetNetVar('CustomPhysgun') or 'nil']
end
--net.Start('Donate::ChoosePhysgun')net.WriteString('pg_1')net.SendToServer()