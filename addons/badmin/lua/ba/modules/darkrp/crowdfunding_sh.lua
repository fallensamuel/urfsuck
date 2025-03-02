
if SERVER then
	ba.svar.Create('crowdfund', '', true, nil, true)
	
	hook.Add('SuccessfulPayment', 'Donate::Crowdfund', function(ply, credits)
		local crowdfund_var = ba.svar.Get('crowdfund')
		if crowdfund_var and crowdfund_var ~= '' then
			local crowdfund_data = util.JSONToTable(crowdfund_var)
			crowdfund_data.funded = tonumber(crowdfund_data.funded) + credits
			ba.svar.Set('crowdfund', util.TableToJSON(crowdfund_data))
		end
	end)
end

ba.cmd.Create('Cf set', function(pl, args)
	local amount 	= tonumber(args.amount)
	local name 		= args.name
	local link 		= args.link
	local time 		= args.time
	
	local cf_current = ba.svar.Get('crowdfund')
	
	if cf_current and cf_current ~= '' then
		return rp.Notify(pl, NOTIFY_ERROR, rp.Term('CfCant'))
	end
	
	if amount < 0 then
		return rp.Notify(pl, NOTIFY_ERROR, rp.Term('CfInvalid'))
	end
	
	ba.svar.Set('crowdfund', util.TableToJSON({
		name = name,
		link = link,
		amount = amount,
		funded = 0,
		time = os.time() + time,
	}))
	
	rp.NotifyAll(NOTIFY_GENERIC, rp.Term('CfStart'), amount, math.floor(time / 3600))
	ba.logAction(pl, tostring(amount), 'cf set', tostring(time))
end)
:AddParam('string', 'name')
:AddParam('string', 'link')
:AddParam('string', 'amount')
:AddParam('time', 'time')
:SetFlag('x')
:SetHelp('Starts new crowdfunding')

ba.cmd.Create('Cf Unset', function(pl, args)
	ba.svar.Set('crowdfund', '')
	
	rp.NotifyAll(NOTIFY_GENERIC, rp.Term('CfStop'))
	ba.logAction(pl, '', 'cf unset', '')
end)
:SetFlag('x')
:SetHelp('Stops current crowdfunding')
