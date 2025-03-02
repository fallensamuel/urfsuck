-- "gamemodes\\rp_base\\entities\\entities\\factory_button\\cl_init.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
include('shared.lua')

function ENT:Draw()
	self:DrawModel()
end

rp.AddBubble("entity", "factory_button", {
	ico = rp.cfg.FactoryButtonBubbleIcon or Material("bubble_hints/lootbox.png", "smooth", "noclamp"),
	offset = Vector(0, 0, 15),
	name = function(ent)
		return rp.factory.Buttons[ent:GetButtonID()] and rp.factory.Buttons[ent:GetButtonID()].Name or translates.Get('Завод')
	end,
	desc = translates.Get("[Е] Получить компоненты"),
	as_texture = true,
	scale = 0.6,
	ico_col = rp.cfg.FactoryButtonBubbleColor or Color(181, 257, 282),
	title_colr = rp.cfg.FactoryButtonBubbleColor or Color(181, 257, 282),
	customCheck = function(ent)
		local custom_check = rp.factory.Buttons[ent:GetButtonID()] and rp.factory.Buttons[ent:GetButtonID()].CustomCheck
		return (not custom_check or custom_check(LocalPlayer())) and not ent:GetIsBusy() and not IsValid(ent:GetResultEnt())
	end,
})
