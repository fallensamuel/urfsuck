-- "gamemodes\\darkrp\\gamemode\\addons\\stalker\\cl_overlay.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
cvar.Register'draw_overlay':SetDefault(true):AddMetadata('State', 'RPMenu'):AddMetadata('Menu', 'Включить оверлей (отрисовка противогаза от первого лица)')

local materials = {
	{80,Material('hud/vgui/hud_exo1.png')},
	{50, Material('hud/vgui/hud_exo2.png')},
	{25, Material('hud/vgui/hud_exo3.png')},
	{0, Material('hud/vgui/hud_exo4.png')},
}

hook("HUDPaintBackground", function()
	if !(IsValid(LocalPlayer()) && LocalPlayer():IsInExoskeleton() && cvar.GetValue('draw_overlay')) then return end

	surface.SetDrawColor(0, 0, 0, 255)
	for k, v in ipairs(materials) do
		if LocalPlayer():Health() >= v[1] then
			surface.SetMaterial(v[2])
			break
		end
	end
	surface.DrawTexturedRect(0, 0, ScrW(), ScrH())
end)
