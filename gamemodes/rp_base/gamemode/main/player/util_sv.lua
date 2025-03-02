rp.cfg.TransferWeaponBlackList = rp.cfg.TransferWeaponBlackList or {}
function Add2TransferWeaponBlackList(var)
	if isstring(var) then
		rp.cfg.TransferWeaponBlackList[var] = true
	elseif istable(var) then
		for i = 1, #var do
			rp.cfg.TransferWeaponBlackList[var[i]] = true
		end
	end
end

local function IsBlackListed(class)
	if rp.cfg.TransferWeaponEnableBlackList then
		return rp.cfg.TransferWeaponBlackList[class]
	else
		return not rp.cfg.TransferWeaponBlackList[class]
	end
end

concommand.Add("transferweapon", function(ply, cmd, args)
	if not rp.cfg.TransferWeaponEnable then
		rp.Notify(ply, NOTIFY_RED, rp.Term("OptionDisabled"))
		return
	end

	local target = ply:GetEyeTrace().Entity
	--print(target)
	if not IsValid(target) or not target:IsPlayer() then return end

	local active = ply:GetActiveWeapon()
	--print(active)
	if not IsValid(active) then return end
	local wep_name = active:GetPrintName()
	local class = active:GetClass()

	if IsBlackListed(class) then
		rp.Notify(ply, NOTIFY_RED, rp.Term("CantWeaponTransfer"), wep_name)
		return
	end

	local ammotype = active:GetPrimaryAmmoType() or active:GetSecondaryAmmoType()

	ply:StripWeapon(class)
	target:Give(class, false)
	
	if ammotype and rp.cfg.TransferWeapon_TransferAmmoToo then
		local cnt = ply:GetAmmoCount(ammotype)
		if cnt and cnt > 0 then
			ply:RemoveAmmo(cnt, ammotype)
			target:GiveAmmo(cnt, ammotype)
		end
	end

	rp.Notify(ply, NOTIFY_GREEN, rp.Term("OnWeaponTransfer"), wep_name, target:Name())
	rp.Notify(target, NOTIFY_GREEN, rp.Term("OnWeaponTransferReceiver"), ply:Name(), wep_name)
end)

util.AddNetworkString("GivePlayerMoney")

local maxGiveMoneyDIST = 250*250
net.Receive("GivePlayerMoney", function(len, ply)
	local target = net.ReadEntity()
	if not IsValid(target) or not target:IsPlayer() then return end

	local myPos, hisPos = ply:GetPos(), target:GetPos()
	if myPos:DistToSqr(hisPos) > maxGiveMoneyDIST then
		rp.Notify(ply, NOTIFY_ERROR, rp.Term('TransferInvalidDistance'))
		return
	end

	local amount = net.ReadUInt(32)

	if amount < 1 then
		rp.Notify(ply, NOTIFY_ERROR, rp.Term('GiveMoneyLimit'))
		return
	end

	if not ply:CanAfford(amount) then
		rp.Notify(ply, NOTIFY_ERROR, rp.Term('CannotAfford'))
		return
	end

	if not ply:CanAfford(amount) then
		rp.Notify(ply, NOTIFY_ERROR, rp.Term('CannotAfford'))
		return
	end
	
	hook.Run("CheckValidMoneyTransfer", ply, target, amount, function(result, ...)
		if result == false then 
			rp.Notify(ply, NOTIFY_ERROR, ...)
			return 
		end
		
		rp.data.PayPlayer(ply, target, amount)
		rp.Notify(target, NOTIFY_GREEN, rp.Term('PlayerGaveCash'), ply, rp.FormatMoney(amount))
		rp.Notify(ply, NOTIFY_GREEN, rp.Term('YouGaveCash'), target, rp.FormatMoney(amount))

		net.Start('SendAnimToClientNet');
			net.WriteUInt(ACT_GMOD_GESTURE_ITEM_GIVE, 12);
		net.Send(ply);
	end)
end)