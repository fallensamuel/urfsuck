-- "gamemodes\\rp_base\\entities\\entities\\factory_item\\cl_init.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
include('shared.lua')

function ENT:Draw()
	self:DrawModel()
	
	if not self.ComponentName and self:GetComponentUID() then
		self.ComponentName = rp.factory.Components[self:GetComponentUID()] and rp.factory.Components[self:GetComponentUID()].Name or translates.Get('Компонент')
	end
	
	if self.GetPickedPlayer and self:GetPickedPlayer() == LocalPlayer() then
		LocalPlayer().PickedUpFactoryItem = self
	
	elseif LocalPlayer().PickedUpFactoryItem == self then
		LocalPlayer().PickedUpFactoryItem = nil
	end
end

rp.AddBubble("entity", "factory_item", {
	ico = rp.cfg.FactoryItemBubbleIcon or Material("bubble_hints/lootbox.png", "smooth", "noclamp"),
	offset = Vector(0, 0, 15),
	name = function(ent)
		return ent.ComponentName or translates.Get('Компонент')
	end,
	as_texture = true,
	desc = function(ent)
		if ent:GetCurMerges() and ent:GetCurMerges() > 0 then
			return translates.Get("%s / %s компонентов", ent:GetCurMerges() + 1, ent:GetMaxMerges() + 1)
		end
		
		if IsValid(LocalPlayer().PickedUpFactoryItem) and LocalPlayer().PickedUpFactoryItem ~= ent then
			return translates.Get("Поднеси компонент для объединения")
		end
		
		return translates.Get("[Е] Поднять")
	end,
	scale = 0.6,
	ico_col = rp.cfg.FactoryItemBubbleColor or Color(110, 160, 175),
	title_colr = rp.cfg.FactoryItemBubbleColor or Color(110, 160, 175),
	customCheck = function(ent)
		return ent.GetPickedPlayer and LocalPlayer() ~= ent:GetPickedPlayer()
	end,
})
