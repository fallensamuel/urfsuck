
rp.cfg.AdditionalIteractButtons = {
	{
        text = "Показать ID-карту",
        material = Material("ping_system/idcard.png", "smooth", "noclamp"),
        color = Color(255, 255, 255),
        func = function(ply)
            RunConsoleCommand("showidcard");
        end,
        access = function(self, target) return target:Alive() and not target:IsInDeathMechanics() end
    },
}