-- "gamemodes\\rp_base\\gamemode\\addons\\lootboxes\\cl_lootboxes.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal

rp.client = rp.client or {}
rp.client.lootboxes = rp.client.lootboxes or {}

local ent, lp
hook.Add('PostDrawTranslucentRenderables', 'Lootboxes::DrawRoulette', function()
	lp = LocalPlayer():GetPos()
	
	for i = 1, #(rp.client.lootboxes or {}) do
		ent = rp.client.lootboxes[i]
		
		if not IsValid(ent) then
			table.remove(rp.client.lootboxes, i)
			break
		end
		
		ent:CalculateRoulette()
		
		if ent:GetPos():DistToSqr(lp) > 200000 then
			continue
		end
		
		ent:DrawRoulette()
	end
end)

net.Receive('Donate::OpenMenu', function()
	timer.Simple(0.5, function()
		if IsValid(rpui.DonateMenu) then
			RunConsoleCommand('say', '/upgrades')
		end
	end)
end)
