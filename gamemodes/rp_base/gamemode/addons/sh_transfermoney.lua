
if SERVER then
    local function TransferMoney( ply, args )
        local args = string.Explode( " ", args );

        local steamid   = args[1] or "nil";
        local stramount = args[2] or "nil";

        local target = player.GetBySteamID( steamid );

        if not IsValid(target) then
            rp.Notify( ply, NOTIFY_ERROR, rp.Term("InvalidArg") );
            return ""
        end

        if not tonumber(stramount) then
            rp.Notify( ply, NOTIFY_ERROR, rp.Term("InvalidArg") );
            return ""
        end

        if ply:GetPos():Distance(target:GetPos()) > 512 then
            rp.Notify( ply, NOTIFY_ERROR, rp.Term("TransferInvalidDistance") );
            return ""
        end

        local amount = math.floor( tonumber(stramount) );

        if amount < 1 then
            rp.Notify( ply, NOTIFY_ERROR, rp.Term("GiveMoneyLimit") );
            return ""
        end

        if not ply:CanAfford(amount) then
            rp.Notify( ply, NOTIFY_ERROR, rp.Term("CannotAfford") );
            return ""
        end

		hook.Run("CheckValidMoneyTransfer", ply, target, amount, function(result, ...)
			if result == false then 
				rp.Notify(ply, NOTIFY_ERROR, ...)
				return 
			end
			
			rp.data.PayPlayer( ply, target, amount );

			local formattedMoney = rp.FormatMoney( amount );
			rp.Notify( target, NOTIFY_GREEN, rp.Term('PlayerGaveCash'), ply,    formattedMoney );
			rp.Notify( ply,    NOTIFY_GREEN, rp.Term('YouGaveCash'),    target, formattedMoney );
		end)
		
        return ""
    end

    rp.AddCommand( "/transfermoney", TransferMoney );
end