-- "gamemodes\\darkrp\\gamemode\\addons\\tfa_sellableattachments.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
function rp.AddAttachment(tblEnt)
	tblEnt.type = tblEnt.type or "item"
	tblEnt.base = "tfaattachment"
	tblEnt.model = "models/items/boxmrounds.mdl"
	tblEnt.attachments = istable(tblEnt.attachments) and tblEnt.attachments or {tblEnt.attachments}
	tblEnt.ent = "tfa_att_" .. util.CRC(table.concat(tblEnt.attachments))

	local ITEM = rp.item.createItem(tblEnt)
	ITEM.attachments = tblEnt.attachments
	ITEM.noDrop = true

	for k, att_uid in ipairs(ITEM.attachments) do
		local uid = "tfaatt_" .. att_uid

		if not rp.shop.GetByUID(uid) then
			rp.shop.Add(tblEnt.name, uid)
				:SetHidden(true)
				:SetNetworked(true)
				:SetCat(translates.Get("Обвесы"))
		end
	end

	rp.item.icons[tblEnt.ent] = tblEnt.icon

	if tblEnt.vendor then
		for vendor_name, price_tab in pairs(tblEnt.vendor) do
			price_tab.BuyCustomCheck = function(ply, item)
				local b, c = true, 0

				for k, att_uid in ipairs(ITEM.attachments) do
					c = c + (ply:HasTFAAttachment(att_uid, true) and 1 or 0)
				end

				if c == #ITEM.attachments then
					b = false
				end

				if b then
					b = #ply:getInv():getItemsByUniqueID(ITEM.uniqueID) == 0
				end

				return b, translates.Get("У вас уже есть эти обвесы!")
			end

			rp.AddVendorItem(vendor_name, tblEnt.category, tblEnt, price_tab)
		end
	end
end