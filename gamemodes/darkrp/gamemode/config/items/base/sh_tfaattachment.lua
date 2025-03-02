-- "gamemodes\\darkrp\\gamemode\\config\\items\\base\\sh_tfaattachment.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
ITEM.name = "TFA Attachment Base"
ITEM.model = "models/items/boxmrounds.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.desc = ""
ITEM.category = "TFAAttachment"

ITEM.BubbleHint = {
	ico = Material("filters/object.png", "smooth noclamp"),
	offset = Vector(0, 0, 8),
	scale = 0.5
}

ITEM.functions.useAttachment = {
	name = translates.Get("Установить"),
	tip = "useTip",
	icon = "icon16/plugin.png",
	radial = false,
	onRun = function(item)
		local client = item.player

		for k, att_uid in ipairs(item.attachments) do
			local uid = "tfaatt_" .. att_uid

			if client:HasUpgrade(uid) then continue end

			local upg = rp.shop.GetByUID(uid)
			if not upg then return false end

			rp._Stats:Query("REPLACE INTO `kshop_purchases` VALUES (?, ?, ?, 1)", os.time(), client:SteamID(), upg:GetUID(), function(data)
				local upgrades = client:GetVar("Upgrades") or {}
				upgrades[upg:GetUID()] = (upgrades[upg:GetUID()] or 0) + 1
				client:SetVar("Upgrades", upgrades)

				upg:OnBuy(client)

				if k == 1 then
					rp.Notify(client, NOTIFY_GENERIC, translates.Get("Вы установили обвесы на оружие: %s", upg:GetName()))
				end
			end)
		end

		return true
	end,
	onCanRun = function(item)
		return true
	end
}