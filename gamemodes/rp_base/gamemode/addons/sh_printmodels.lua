
if SERVER then
	util.AddNetworkString('rp.PrintModels')
	
	rp.AddCommand('/printmodels', function(ply)
		net.Start('rp.PrintModels')
		net.Send(ply)
	end)
else
	
	net.Receive('rp.PrintModels', function()
		local ply = LocalPlayer()
		for _, v in ipairs(ents.FindInSphere(ply:GetPos(), 600)) do 
			chat.AddText(rp.col.Green, v:GetClass(), rp.col.Grey, ': ' .. (v:GetModel() or '') .. ', [', rp.col.White, tostring(v:GetPos()), rp.col.Grey, '], [', rp.col.White, tostring(v:GetAngles()), rp.col.Grey, ']')
		end
	end)
end
