do return end -- ПЕРЕНЕСЕНО В РП БАЗУ! gamemode/addons/server_restart

if (SERVER) then
	util.AddNetworkString('_AntiCrash')

	timer.Create('AntiCrash', 5, 0, function()
		net.Start('_AntiCrash')
		net.Broadcast()
	end) 
elseif (CLIENT) then
	surface.CreateFont ('AntiCrash.Font', {
		font = 'Tahoma',
		size = 30,
		weight = 300
	})

	local color_white = Color(255,255,255)
	local color_red = Color(255,0,0)
	local color_black = Color(0,0,0)

	local NextReTry = false
	local IsCrashed = false
	local ReconnectTime = 0
	local Crash_Frame

	local function StartAutoconect()
		ReconnectTime = CurTime() + 65

		if IsValid(Crash_Frame) then Crash_Frame:Remove() end

		Crash_Frame = ui.Create('DFrame')
		Crash_Frame:SetSize(475, 125)
		Crash_Frame:SetPos(ScrW(), 0)
		Crash_Frame:MoveTo(ScrW() - 475, 0, 0.3, 0, 1)
		Crash_Frame:SetTitle('')
		Crash_Frame:ShowCloseButton(false)
		Crash_Frame.btnMinim:SetVisible(false)
		Crash_Frame.btnMaxim:SetVisible(false)
		
		local reconnect_text = translates and translates.Get('Восстановление соединения через ') or 'Восстановление соединения через '
		
		function Crash_Frame:Paint(w, h)
			local delta = math.Clamp(ReconnectTime - CurTime(), 1, 40)

			draw.OutlinedBox(0, 0,w, h , color_black, (delta % 1 < 0.2 and color_red or color_white))

			draw.SimpleText(reconnect_text, 'AntiCrash.Font', w/2, 10, color_white, TEXT_ALIGN_CENTER)
			draw.SimpleText(math.ceil(delta), 'AntiCrash.Font', w*0.5, 75, delta % 1 < 0.2 and color_red or color_white, TEXT_ALIGN_CENTER)
		end
	end

	net.Receive('_AntiCrash', function()
		NextReTry = CurTime() + 10
		IsCrashed = false
		if IsValid(Crash_Frame) then
			Crash_Frame:Remove()
		end
	end)

	hook.Add('Think', 'AntiCrash.Think', function()
		if NextReTry and (not IsCrashed) and (NextReTry < CurTime()) then
			IsCrashed = true
			StartAutoconect()
		elseif IsCrashed and (ReconnectTime <= CurTime()) then
			RunConsoleCommand('retry')
		end
	end)

	hook.Add('InitPostEntity', 'AntiCrash.InitPostEntity', function()
		RunConsoleCommand('cl_timeout', 9999)
	end)
end