-- "gamemodes\\rp_base\\gamemode\\main\\inventory\\items\\base\\sh_ammo.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
ITEM.name = "Ammo Base"
ITEM.model = "models/Items/BoxSRounds.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.ammo = "pistol" // type of the ammo
ITEM.ammoAmount = 30 // amount of the ammo
ITEM.desc = "A Box that contains %s of Pistol Ammo"
ITEM.category = "Ammunition"

function ITEM:getDesc()
	return Format(self.desc, self.ammoAmount)
end

ITEM.BubbleHint = {
	ico = Material("filters/ammo.png", "smooth", "noclamp"),
	offset = Vector(0, 0, 8),
	scale = 0.5
}

if (CLIENT) then
	function ITEM:paintOver(item, w, h)
		-- draw.SimpleText(item.ammoAmount, "DermaDefault", w , h - 5, color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM, 1, color_black)
		draw.SimpleText( "X"..item.ammoAmount, "rpui.Fonts.ItemIcon", w - h*0.05, h*0.025, rp.col.White, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP )
	end
end

// On player uneqipped the item, Removes a weapon from the player and keep the ammo in the item.
ITEM.functions.use = { -- sorry, for name order.
	name = translates.Get("Зарядить"),
	tip = "useTip",
	icon = "icon16/add.png",
	radial = false,
	onRun = function(item)
		item.player:GiveAmmo(item.ammoAmount, item.ammo)
		item.player:EmitSound("items/ammo_pickup.wav", 110)

		return true
	end,
}
