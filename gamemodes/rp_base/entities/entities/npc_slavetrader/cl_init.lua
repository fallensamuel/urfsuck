-- "gamemodes\\rp_base\\entities\\entities\\npc_slavetrader\\cl_init.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
include( "shared.lua" );

ENT.RenderGroup = RENDERGROUP_OPAQUE;

function ENT:OpenMenu()
	local cuffed_plys = {}

	for k, cuff in pairs(ents.FindByClass( "weapon_handcuffed" )) do
		if IsValid(cuff) and IsValid(cuff.Owner) and cuff.GetRopeLength and cuff:GetRopeLength() > 0 and cuff.GetKidnapper and IsValid(cuff:GetKidnapper()) and cuff:GetKidnapper() == LocalPlayer() and self:CheckSlave(cuff.Owner) then
			table.insert(cuffed_plys, cuff.Owner)
		end
	end

	if #cuffed_plys == 0 then
		local faction_data = rp.police.Factions[self:GetPoliceFaction()]
		local self_data = faction_data.supervisors[game.GetMap()]

		return rp.Notify(activator, NOTIFY_ERROR, rp.Term(self_data.need_wanted_stars and "Jail::SupervisorNoWantedPlys" or "Jail::SupervisorNoPlys"))
	end

	local W, H = ScrW(), ScrH()
	local scale = math.Clamp(H / 1080, 0.7, 1)
	local wi, he = 290, 400

	wi = math.max(wi, 580 * scale)
	he = math.max(he, 800 * scale)

	local main_pnl = vgui.Create("Urf_VendorNpc_Menu")
		main_pnl:SetSize2(wi, he)
		main_pnl:SetPos(ScrW()*0.9 - main_pnl:GetWide(), ScrH() / 2 - main_pnl:GetTall() / 2)
		main_pnl:SetText(translates.Get("СДАТЬ"))
		main_pnl.titleico = Material("sell.png", "smooth", "noclamp")

	local sell_items = {}

	local exp_status, exp_value = pcall( function() return LocalPlayer():GetJobTable().experience.actions["sell_slave"] end )

	for k, v in pairs(cuffed_plys) do
		local sell_price = self:GetSlavePrice(v)

		sell_items[v:SteamID()] = {}
		sell_items[v:SteamID()].price = sell_price
		sell_items[v:SteamID()].sellPrice = sell_price
		sell_items[v:SteamID()].amount = 1
		sell_items[v:SteamID()].name = v:Name()
		sell_items[v:SteamID()].mdl = v:GetModel()
		sell_items[v:SteamID()].count = 1
		sell_items[v:SteamID()].is_vendor = false
		sell_items[v:SteamID()].override_count = true

		if exp_status then
			sell_items[v:SteamID()].experience = exp_value + ((v:GetJobTable() or {}).slaveExperience or 0);
		end
	end

	main_pnl:InsertItems(sell_items)

    hook.Add("VendorNPC_TradeHook", "_hi_", function(pnl, uid, amount, item_btn, dt)
		local ply = player.GetBySteamID(uid)
		item_btn:Remove()

		if IsValid(ply) then
			net.Start("rp.Jail.OpenSellMenu")
				net.WriteEntity(self)
				net.WriteEntity(ply)
			net.SendToServer()
		end
    end)
end

net.Receive( "rp.Jail.OpenSellMenu", function()
	local ent = net.ReadEntity();

	if ent.OpenMenu then
		ent:OpenMenu()
	end
end );

function ENT:Draw()
	self:DrawModel()
end

rp.AddBubble("entity", "npc_slavetrader", {
	ico = rp.cfg.SlaveTraderIcon or Material("bubble_hints/lootbox.png", "smooth noclamp"),
	offset = Vector(0, 0, 25),
	as_texture = true,
	name = function(ent)
		local faction = rp.police.Factions[ent:GetPoliceFaction() or -1]
		return faction and faction.supervisors and faction.supervisors[game.GetMap()] and faction.supervisors[game.GetMap()].name or translates.Get("Работорговец")
	end,
	desc = translates.Get("[Е] Открыть меню"),
	scale = 0.6,
	ico_col = Color(255, 81, 81),
	title_colr = Color(255, 81, 81),
	customCheck = function(ent)
		return true
	end,
})