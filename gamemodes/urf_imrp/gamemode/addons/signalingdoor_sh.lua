nw.Register'IsAlarming':Write(net.WriteBool):Read(net.ReadBool):SetHook("ToggleAlarm")

if CLIENT then
	surface.CreateFont('rp.ui.20.outline', {font = 'roboto', size = 20, weight = 400, outline = true})
	
	local AlarmingDoors = {}

	hook.Add("ToggleAlarm","rp.ToggleAlarm", function(ent, value) 
		if value then 
			AlarmingDoors[ent:EntIndex()] = ent
			timer.Create("AlarmSound"..ent:EntIndex(),2,0,function()
				if !IsValid(ent) then return end
				if !ent:GetNetVar("IsAlarming") then return end
				ent:EmitSound("ambient/alarms/klaxon1.wav")
			end)
			if timer.Exists("AutoDisableDoorSignaling"..ent:EntIndex()) then timer.Destroy("AutoDisableDoorSignaling"..ent:EntIndex()) end
			timer.Create("AutoDisableDoorSignaling"..ent:EntIndex(),30,0,function()
				if !IsValid(ent) then return end
				AlarmingDoors[ent:EntIndex()] = nil
			end)
		end 
	end)

	hook.Add("HUDPaint","rp.SignalingDoorHUD",function()
		if !LocalPlayer():IsCP() then return end
		for k,v in pairs(AlarmingDoors) do
			if !IsValid(v) then continue end
			if !v:GetNetVar("IsAlarming") then continue end
			local distance = math.ceil(LocalPlayer():GetPos():Distance(v:GetPos()) / 60)
			local doorPos = v:GetPos() + Vector(17,0,0)
			local x, y = doorPos:ToScreen().x, doorPos:ToScreen().y

			draw.SimpleText("Сработала сигнализация!", "rp.ui.20.outline", x, y, Color(255,0,0,255))
			draw.SimpleText("дистанция: "..distance.." м", "rp.ui.20.outline", x, y+20, Color(255,255,255,255))

			surface.SetMaterial( Material( "icon16/exclamation.png" ) )
			surface.SetDrawColor( 255, 255, 255, 255 )
			surface.DrawTexturedRect(x-22, y+13, 18, 18 )
		end
	end)
end