AddCSLuaFile ("cl_init.lua")
AddCSLuaFile ("shared.lua")
include ("shared.lua")

function SWEP:Reload()
end

rp.AddCommand('/setimagebanner', function(pl, text, args)
	local wep = pl:GetActiveWeapon()
	if not IsValid(wep) or wep:GetClass() ~= 'weapon_banner_new' then return end
	
	if (not args) then
		pl:Notify(NOTIFY_ERROR, rp.Term('InvalidURL'))
	elseif IsValid(wep) then
		print(wep, wep.SetURLt)

		wep:SetURLt(args[1])
	end
end)