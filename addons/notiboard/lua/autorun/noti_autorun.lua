AddCSLuaFile()

	if SERVER then
		util.AddNetworkString("NotiOwnerMenu")
		util.AddNetworkString("NotiOwnerSimple")
		util.AddNetworkString("NotiOwnerUse")
		
		net.Receive("NotiOwnerUse", function(_, client)
			local com = net.ReadUInt(1)
			if client and client:IsValid() and client.tBoard and client.tBoard:IsValid() then
				local dist = client:GetPos():Distance(client.tBoard:GetPos())
				if (!client.tBoard.vBoard and client == client.tBoard.Owner and dist > 256) then return end
				if com == 0 then
					local string = net.ReadString()
					
					client.tBoard:SetNWString("title", string)
				elseif com == 1 then
					local string = net.ReadString()
					
					client.tBoard:SetNWString("text", string)
				else
					print('INVALID COMMAND')
				end
			end
		end)
	else
		local ftbl = {
			font = mainFont,
			size = 27,
			weight = 500,
			antialias = true,
		}
		surface.CreateFont("NotiBoardFont", ftbl)
		ftbl.blursize = 2
		surface.CreateFont("NotiBoardFont2", ftbl)
		
		local ftbl = {
			font = mainFont,
			size = 33,
			weight = 1000,
			antialias = true
		}
		surface.CreateFont("NotiBoardTitle", ftbl)
		ftbl.blursize = 2
		surface.CreateFont("NotiBoardTitle2", ftbl)	
	
		net.Receive("NotiOwnerSimple", function()
			Derma_StringRequest("Enter the text of the board", "Set Text", "",
				function(txt)
					net.Start("NotiOwnerUse")
						net.WriteUInt(1, 1)
						net.WriteString(txt)
					net.SendToServer()
				end
			)
		end)
	
		net.Receive("NotiOwnerMenu", function()
			Derma_Query("Choose the action", "Confirm", 
				"Change Title",
				function()
					Derma_StringRequest("Enter the title of the product", "Set Title", "",
						function(txt)
							net.Start("NotiOwnerUse")
								net.WriteUInt(0, 1)
								net.WriteString(txt)
							net.SendToServer()
						end
					)
				end,
				
				"Change Text",	
				function()
					Derma_StringRequest("Enter the text of the board", "Set Text", "",
						function(txt)
							net.Start("NotiOwnerUse")
								net.WriteUInt(1, 1)
								net.WriteString(txt)
							net.SendToServer()
						end
					)
				end,
			
				"Cancel"
			)
		end)
	end

	local function notiinit()
		if !DarkRP then return end
		print('ohwow')
		AddEntity("Notiboard Big", {
			ent = "bt_notiboard_big",
			model = "models/hunter/plates/plate1x4.mdl",
			price = 500,
			max = 2,
			cmd = "/buynotiboardbig"
		})
		AddEntity("Notiboard Small", {
			ent = "bt_notiboard_small",
			model = "models/props_trainstation/tracksign08.mdl",
			price = 100,
			max = 2,
			cmd = "/buynotiboardsmall"
		})
		AddEntity("Notiboard Medium", {
			ent = "bt_notiboard_medium",
			model = "models/hunter/plates/plate1x3.mdl",
			price = 250,
			max = 2,
			cmd = "/buynotiboardmedium"
		})
		AddEntity("Notiboard CSS", {
			ent = "bt_notiboard_css",
			model = "models/props/cs_assault/ChainTrainStationSign.mdl",
			price = 300,
			max = 2,
			cmd = "/buynotiboardcss"
		})
	end

	hook.Add("PostGamemodeLoaded", "InitNotiboard", notiinit)