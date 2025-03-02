-- "gamemodes\\rp_base\\gamemode\\addons\\donate_refunds\\sh_init.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal

local last_donates_opened = 0

ba.cmd.Create('donates', function(pl, args)
	if last_donates_opened > CurTime() then 
		return rp.Notify(pl, NOTIFY_ERROR, rp.Term('PleaseWaitX'), math.ceil(last_donates_opened - CurTime()))
	end
	
	local target = ba.InfoTo32(args.target)
	last_donates_opened = CurTime() + 5
	
	rp.GetDonates(target, pl, function(donates)
		if not IsValid(pl) then return end
		
		if not donates then 
			return rp.Notify(pl, NOTIFY_ERROR, rp.Term('DonatesEmpty'))
		end
		
		net.Start('rp.Donates.SendToPlayer')
		net.WriteString(target)
		net.WriteUInt(table.Count(donates), 12)
		for k, v in pairs(donates) do
			local shop_item = rp.shop.GetByUID(v.upg)
			
			net.WriteUInt(v.time1, 32)
			net.WriteString(v.upg)
			net.WriteUInt(-v.cost, 13)
			net.WriteUInt(shop_item:GetPrice(isentity(args.target) and args.target or pl), 13)
		end
		net.Send(pl)
	end)
end)
:AddParam('player_steamid', 'target')
:SetFlag('X')
:SetHelp('Opens player donates panel')