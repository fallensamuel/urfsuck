-- "gamemodes\\rp_base\\entities\\entities\\factory_storage\\cl_init.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
include('shared.lua')

local MenuSize = {
    w = 680,
    h = 800
}

function ENT:Draw()
	self:DrawModel()
end

function ENT:OpenMenu()
	local W, H = ScrW(), ScrH()
    local scale = math.Clamp(H / 1080, 0.7, 1)
    local wi, he = 290, 400
    wi = math.max(wi, MenuSize.w * scale)
    he = math.max(he, MenuSize.h * scale)
	
    main_pnl = vgui.Create("FactoryStorage_Menu")
    main_pnl:SetSize2(wi, he)
    main_pnl:SetPos(ScrW() * 0.5 - main_pnl:GetWide() * 0.5, ScrH() * 0.5 - main_pnl:GetTall() / 2)
    --main_pnl:SetText(utf8.upper(rp.factory.Storages[self:GetStorageID()].Name or translates.Get("ХРАНИЛИЩЕ")))
	main_pnl:SetStorage(self)
    main_pnl:SetText(translates.Get("ХРАНИЛИЩЕ"))
    main_pnl.titleico = Material("bubble_hints/lootbox.png", "smooth", "noclamp")
end

rp.AddBubble("entity", "factory_storage", {
	ico = rp.cfg.FactoryStorageBubbleIcon or Material("bubble_hints/lootbox.png", "smooth", "noclamp"),
	offset = Vector(0, 0, 25),
	name = function(ent) 
		local amount = ent:GetAmount()
		local max_amount = rp.factory.Storages[ent:GetStorageID()].MaxAmount
		
		return (rp.factory.Storages[ent:GetStorageID()].Name or translates.Get('Хранилище')) .. ' ' .. amount .. ' / ' .. max_amount
	end,
	desc = translates.Get("[Е] Открыть хранилище"),
	scale = 0.6,
	ico_col = rp.cfg.FactoryStorageBubbleColor or Color(181, 257, 282),
	title_colr = rp.cfg.FactoryStorageBubbleColor or Color(181, 257, 282),
	customCheck = function(ent)
		local custom_check = rp.factory.Storages[ent:GetStorageID()] and rp.factory.Storages[ent:GetStorageID()].CustomCheck
		return not IsValid(rp.factory.Menu) and (not custom_check or custom_check(LocalPlayer()))
	end,
})

net.Receive('Factory::OpenStorageMenu', function()
	local ent = net.ReadEntity()
	
	if IsValid(ent) and ent.OpenMenu then
		ent:OpenMenu()
	end
end)
