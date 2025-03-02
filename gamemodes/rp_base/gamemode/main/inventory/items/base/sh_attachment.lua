-- "gamemodes\\rp_base\\gamemode\\main\\inventory\\items\\base\\sh_attachment.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
ITEM.name = "Attachment Base"
ITEM.model = "models/Items/BoxSRounds.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.desc = ""
ITEM.category = "Attachment"

ITEM.BubbleHint = {
	ico = Material("filters/object.png", "smooth", "noclamp"),
	offset = Vector(0, 0, 8),
	scale = 0.5
}

/*
ITEM.functions.runAttach = { 
	name = translates.Get("Установить"),
	tip = "useTip",
	icon = "icon16/plugin.png",
	onRun = function(item)
		local client = item.player
		CustomizableWeaponry:giveAttachments({item.uniqueID}, false, false, client)
	end, 
	onCanRun = function(item)
		return not item.attachment
	end
}
*/

ITEM:hook("drop", function(item)
	if item.attachment then
		local client = item.player

		local foundAtt = CustomizableWeaponry:findAttachment(item.attachment)
		if foundAtt.detachFunc then
			for k,v in pairs(client:GetWeapons()) do
				if !v._detach then continue end
				foundAtt.detachFunc(v)
			end
		end
		
		CustomizableWeaponry:removeAttachment(client, item.attachment)
	end
end)

ITEM:hook("take", function(item)
	local client = item.player
	CustomizableWeaponry:giveAttachments(istable(item.attachment) and item.attachment or isstring(item.attachment) and {item.attachment} or {item.uniqueID}, false, false, client)
end)

function ITEM:onInstanced(invID, x, y, item)
	timer.Simple(0, function()
		if item and invID > 0 and rp.item.inventories[invID] and rp.item.inventories[invID].owner then
			CustomizableWeaponry:giveAttachments(istable(item.attachment) and item.attachment or isstring(item.attachment) and {item.attachment} or {item.uniqueID}, false, false, rp.item.inventories[invID].owner)
		end
	end)
end

function ITEM:onRemoved()
	local attachments = istable(self.attachment) and self.attachment or isstring(self.attachment) and {self.attachment} or {self.uniqueID}
	
	--local attachment = self.attachment or self.uniqueID
	
	local client = self.player
	
	for k, attachment in pairs(attachments or {}) do
		if attachment then
			if not IsValid(client) then return end
			
			local foundAtt = CustomizableWeaponry:findAttachment(attachment)
			if foundAtt.detachFunc then
				local removed = false
				
				for k, v in pairs(client:GetWeapons()) do
					if v.ActiveAttachments and v.ActiveAttachments[attachment] then
						
						for l, m in pairs(v.Attachments) do
							if removed then 
								removed = false
								break
							end
							
							for i, j in pairs(m.atts) do
								if j == attachment then
									v:_detach(l, i)
									
									net.Start('inv.AttachmentDetached')
										net.WriteEntity(v)
										net.WriteString('' .. l)
										net.WriteUInt(i, 8)
									net.Send(client)
									
									break
								end
							end
						end
					end
				end
			end
			
			CustomizableWeaponry:removeAttachment(client, attachment)
		end
	end
end

function ITEM:onTransfered()
	self:onRemoved()
end

if SERVER then
	util.AddNetworkString('inv.AttachmentDetached')
	
	local function give_attachments(ply)
		if not ply:getInv() or not ply:getInv().getItems then return end
		
		local atts = {}
		
		for k, v in pairs(ply:getInv():getItems()) do
			if v.base == 'base_attachment' or v.attachment then
				for i, j in pairs(istable(v.attachment) and v.attachment or isstring(v.attachment) and {v.attachment} or {v.uniqueID}) do
					table.insert(atts, j)
				end
			end
		end
		
		if #atts > 0 then
			CustomizableWeaponry:giveAttachments(atts, false, false, ply)
		end
	end
	
	hook.Add('PlayerSpawn', 'inv.AddAttachmentOnRespawn', give_attachments)
	hook.Add('PlayerDataLoaded', 'inv.AddAttachmentOnSpawn', function(ply)
		timer.Simple(5, function()
			if not IsValid(ply) then return end
			give_attachments(ply)
		end)
	end)
else
	net.Receive('inv.AttachmentDetached', function()
		local wep = net.ReadEntity()
		local cat = net.ReadString()
		
		wep:_detach(tonumber(cat) or cat, net.ReadUInt(8))
	end)
end
