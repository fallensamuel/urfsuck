-- "gamemodes\\darkrp\\entities\\entities\\npc_ae_teamselect\\cl_init.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
include( "shared.lua" );

ENT.RenderGroup = RENDERGROUP_OPAQUE

function ENT:OpenMenu()
	local commands = rp.cfg.AutoEvents[self:GetAutoeventID()].commands
	
	local menu = vgui.Create('DFrame')
	menu:SetTitle("Выберите сторону")
	menu:SetSize(400, 100)
	menu:Center()
	menu:MakePopup()
	
	local btn1 = vgui.Create('DButton', menu)
	btn1:SetText(commands[1].name)
	btn1:SetPos(10, 32)
	btn1:SetSize(180, 58)
	
	btn1.DoClick = function()
		rp.autoevents.ChooseCommand(1)
		menu:Close()
	end
	
	local btn2 = vgui.Create('DButton', menu)
	btn2:SetText(commands[2].name)
	btn2:SetPos(210, 32)
	btn2:SetSize(180, 58)
	
	btn2.DoClick = function()
		rp.autoevents.ChooseCommand(2)
		menu:Close()
	end
end

net.Receive("rp.AutoeventMenu", function()
	local ent = net.ReadEntity()
	
	if IsValid(ent) and ent.IsAutoeventTeamNPC then
		local event_id = nw.GetGlobal('AutoEventId')
		
		if not event_id or event_id != ent:GetAutoeventID() then
			return
		end
		
		ent:OpenMenu()
	end
end)

function ENT:Draw()
	self:DrawModel()
end
