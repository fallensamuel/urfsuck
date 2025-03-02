function ENTITY:SetOutfit()
	if (self.LastOutfitMaterialID and self.LastOutfitRevertionSubMaterial) then
		self:SetSubMaterial(self.LastOutfitMaterialID, self.LastOutfitRevertionSubMaterial)
	end

	local id = 1

	for k, v in ipairs(self:GetMaterials()) do
		if string.find(v, 'players_sheet') then
			id = (k - 1)
			break
		end
	end

	self.LastOutfitMaterialID = id
	self.LastOutfitRevertionSubMaterial = self:GetSubMaterial(id)
	self:SetSubMaterial(id, self:GetOutfit())
	self.LastOutfit = self:GetOutfit()

	-- Handle our clientside legs also :)
	if (self == LocalPlayer() and IsValid(self.Legs) and IsValid(self.Legs.Entity)) then
		local id = 1

		for k, v in ipairs(self.Legs.Entity:GetMaterials()) do
			if string.find(v, 'players_sheet') then
				id = (k - 1)
				break
			end
		end

		self.Legs.Entity:SetSubMaterial(id, self:GetOutfit())
	end
end

timer.Create('Submaterials', 2, 0, function()
	for k, v in ipairs(player.GetAll()) do
		if IsValid(v) and (v:Team() == 1) and (v:GetOutfit() ~= nil) and ((not v.LastOutfit) or (v:GetOutfit() ~= v.LastOutfit)) then
			v:SetOutfit()
		end
	end
end)

net('rp.InvalidateOutfit', function(len)
	local pl = net.ReadEntity()

	if (IsValid(pl)) then
		pl.LastOutfit = nil
	end
end)