-- "gamemodes\\rp_base\\gamemode\\main\\inventory\\derma\\derma_sh.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
if CLIENT then
	net.Receive("rp.OpenInventory",function()
		hook.Run("rp.OpenInventory")
	end)

	rp.AddContextCommand(translates.Get("Действия"), translates.Get("Убрать оружие"), function()
		local ply = LocalPlayer()
		if not IsValid(ply:GetActiveWeapon()) then return end
		local items = ply:getInv():getItemsByUniqueID(ply:GetActiveWeapon():GetClass())
		for k,v in pairs(items) do
			if v:getData("equip") then
				netstream.Start("invAct", "EquipUn", v.id, ply:getInv():getID(), v.id)
			end
		end
	end, nil, 'cmenu/weapon')
elseif SERVER then
	util.AddNetworkString("rp.OpenInventory")
	util.AddNetworkString("rp.ClientLoadInventory")
end