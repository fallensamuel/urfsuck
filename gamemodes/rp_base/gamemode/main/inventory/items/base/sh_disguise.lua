-- "gamemodes\\rp_base\\gamemode\\main\\inventory\\items\\base\\sh_disguise.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
ITEM.name = "Disguise"
ITEM.desc = "Briefcase to disguise to jobs."
ITEM.model = "models/props_c17/suitcase001a.mdl"
ITEM.width = 2
ITEM.height = 2

--[[ITEM.functions.View = {
	name = "Открыть",
	icon = "icon16/briefcase.png",
	onClick = function(item)
		
		print('OPEN 2')
		
		return false
	end,
	onCanRun = function(item)
		return !IsValid(item.entity)
	end
}]]

ITEM.BubbleHint = {
	ico = Material("rpui/misc/disguise.png", "smooth", "noclamp"),
	offset = Vector(0, 0, 8),
	scale = 0.7
}

ITEM.functions.use = {
	name = translates.Get("Замаскироваться"),
	icon = "icon16/cup.png",
	sound = "buttons/lever8.wav",
	tip = "useTip",
	InteractMaterial = "ping_system/mask.png",
	onRun = function(item)
		local pl = item.player

		if not IsValid(item.entity) or not IsValid(pl) then return false end
		if pl:GetJobTable().CantUseDisguise then 
			rp.Notify(pl, NOTIFY_ERROR, rp.Term('YouCantDisguise'))
			return false
		end
		
		if pl:IsDisguised() then
			rp.Notify(pl, NOTIFY_ERROR, rp.Term("AlreadyDisguised"))
			return false
		end

		if (item.OpenDelay or 0) > CurTime() then
			rp.Notify(pl, NOTIFY_ERROR, rp.Term("PleaseWaitX"), math.ceil(item.OpenDelay - CurTime()))
			
			return false
		end
		item.OpenDelay = CurTime() + 7.5

		--netstream.Start(item.player, "rpDisguiseTC", item.entity, item.faction)

		item.entity.Faction = item.faction
		pl.ValidDisguiseEnt = item.entity
		
		net.Start('DisguiseMenu')
			net.WriteEntity(item.entity)
			net.WriteInt(item.faction, 8)
		net.Send(pl)

		return false
	end, 
	onCanRun = function(item)
		return IsValid(item.entity)
	end
}

if CLIENT then
	netstream.Hook("rpDisguiseTC", function(ent, faction)
		if not IsValid(ent) then return end

		local fr = ui.Create('ui_frame', function(self, p)
			self:SetSize(ScrW() * 0.65, ScrH() * 0.6)
			self:SetTitle('Disguise')
			self:Center()
			self:MakePopup()
		end)

		ui.Create('rp_jobslist', function(self, p)
			self.DAppearancePanel.ControlPanel.SaveBtn:SetCustomText( translates.Get("Замаскироваться") );

			self:SetPos(5, 25)
			self:SetSize(p:GetWide() - 10, p:GetTall() - 30)

			self.DAppearancePanel.ControlPanel.SaveBtn.DoClick = function()
				netstream.Start("rpDisguiseTS", ent, self.DAppearancePanel.JobData.team)
				fr:Close()
			end

			for k, v in pairs(rp.Factions[faction] and rp.Factions[faction].jobsMap or {}) do
				if LocalPlayer():CanTeam(rp.TeamByID(v)) then
					if rp.TeamByID(v).disableDisguise then continue end
					self:AddJob(v)
				end
			end
		end, fr)
	end)
else
	local maxdist = 125*125

	netstream.Hook("rpDisguiseTS", function(pl, ent, team)
		if pl:GetJobTable().CantUseDisguise then 
			rp.Notify(pl, NOTIFY_ERROR, rp.Term('YouCantDisguise'))
			return 
		end
		
		if !pl:CanTeam(rp.TeamByID(team)) or rp.TeamByID(team).disableDisguise then return end
		if (pl:Team() == TEAM_ADMIN) then return end
		
		if not IsEntity(ent) then ent = ent["entity"] end
		if not IsValid(ent) or not ent.getItemTable or ent:getItemTable().base ~= "base_disguise" then return end

		local dist = pl:GetPos():DistToSqr(ent:GetPos())
		if dist > maxdist then
			rp.Notify(pl, NOTIFY_ERROR, rp.Term("TargetTooFar"))
			return
		end

		pl:Disguise(team)
		SafeRemoveEntity(ent)
		rp.Notify(pl, NOTIFY_GREEN, rp.Term("NowDisguised"), rp.teams[team].name)
	end)
end

-- Called when a new instance of this item has been made.
--function ITEM:onInstanced(invID, x, y)
--	if self:getData("faction") then return end
--	self:setData("faction", self.faction)
--end
