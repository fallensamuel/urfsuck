if game.GetMap() ~= "rp_city17_alyx_urfim" then return end

local morph_cooldown = 0

local morph_team
local morph_team_appearance = {}

local config = {
	morph_btn = 'creabut',
	morph_pos = {
		Vector(7578, 3661, 78),
		Vector(7615, 3771, 220),
	},
	
	morph_panel_mdl = 'models/hunter/blocks/cube1x1x1.mdl',
	morph_panel_pos = Vector(7376.498047, 3524.496338, 96.264099),
	
	morph_cooldown = 40,
}


local function CanBeMorphed(ply)
	if ply:GetJobTable().CantBeMorphed or not (rp.teams[morph_team] and ply:CanTeam(rp.teams[morph_team])) then
		return false
	end
	
	if not morph_team or ply:Team() == morph_team then
		return false
	end
	
	return not ply:IsBanned()
end

local function StartMorph(ply)
	morph_cooldown = CurTime() + config.morph_cooldown
	
	--print('Morph :: Start', ply, morph_team)
	
	config.ent_morph_btn:Fire('Press')
end

local function Morph(ply)
	local old_pos = ply:GetPos()
	local old_ang = ply:EyeAngles()
	
	ply:SetVar('Model', team.GetModel(morph_team))
	--print('Morph :: Morph!!!', ply)
	
	local result = ply:ChangeTeam(morph_team, nil, true)
	if not result then return end
	
	ply:Spawn()
	
	timer.Simple(0.25, function()
		if not IsValid(ply) then return end
		
		ply:SafeSetPos(old_pos)
		ply:SetEyeAngles(old_ang)
	end)
	
	local appearID = nil 
	
	local skin     = morph_team_appearance.AppearanceSkin
	local mdlscale = morph_team_appearance.AppearanceScale
	
	local isCustom = morph_team_appearance.IsCustomAppearanceUID
	local customUID = morph_team_appearance.CustomAppearanceUID
	
	local selAppearance = rp.teams[ply:Team()].appearance[appearID or 1] or {}
	
	if selAppearance.skins then
		if not table.HasValue(selAppearance.skins, skin) then
			skin = selAppearance.skins[1] or 0
		end
	end
	
	if selAppearance.scale then
		mdlscale = math.Clamp(mdlscale, selAppearance.scale[1] or rp.cfg.AppearanceScaleMin, selAppearance.scale[2] or rp.cfg.AppearanceScaleMax)
	else
		mdlscale = math.Clamp(mdlscale, rp.cfg.AppearanceScaleMin, rp.cfg.AppearanceScaleMax)
	end
	
	local bgroup = {};
	
	for id, v in pairs(morph_team_appearance.Bodygroups) do
		if selAppearance.bodygroups then
			if selAppearance.bodygroups[id] then
				if table.HasValue(selAppearance.bodygroups[id], v) then
					bgroup[id] = v
				end
			end
		else
			bgroup[id] = v
		end
	end
	
	ply:SetVar("SkinIndex", skin)
	ply:SetVar("ModelScale", mdlscale)
	ply:SetVar("BodygroupData", bgroup)
	
	ply:SetVar("IsCustomModel", customUID ~= '' and ply:HasUpgrade(customUID))
	
	ply:UpdateAppearance()
	
	timer.Simple(0.5, function()
		if not IsValid(ply) then return end
		if ply:GetModel() ~= ply:GetVar('Model') then
			ply:SetModel(ply:GetVar('Model'))
		end
	end)
	
	morph_team = nil
end


hook.Add('InitPostEntity', 'OtaMorph::Init', function()
	local morph_btn = ents.FindByName(config.morph_btn)[1]
	if not IsValid(morph_btn) then return end
	
	local omp = ents.Create('ota_morph_panel')
	omp:SetModel(config.morph_panel_mdl)
	omp:SetPos(config.morph_panel_pos)
	omp:Spawn()
end)

hook.Add('EntityTakeDamage', 'OtaMorph::MorphDamage', function(ply, dmg)
	if IsValid(ply) and ply:IsPlayer() and ply:Alive() and not ply.MorphStarts then
		if ply.MorphDamage and ply.MorphDamage > CurTime() then
			if dmg:GetDamageType() == DMG_DROWN then
				ply.MorphDamage = nil
				ply.MorphStarts = true
				
				timer.Simple(2, function()
					if not IsValid(ply) or not ply:Alive() then return end
					ply.MorphStarts = nil
					
					Morph(ply)
				end)
			end
		elseif dmg:GetDamageType() == DMG_DISSOLVE then
			ply.MorphDamage = CurTime() + 4
		end
	end
end)

hook.Add('PlayerDeath', 'OtaMorph::Cancel', function(ply)
	if IsValid(ply) then
		ply.MorphStarts = nil
		ply.MorphDamage = nil
	end
end)


net.Receive('OtaMorph::OpenPanel', function(_, ply)
	local job_n = net.ReadUInt(10)
	
	if not (rp.teams[job_n] and rp.teams[job_n].faction == FACTION_OTA) then
		return --print('Morph :: Invalid job!')
	end
	
	if morph_cooldown and morph_cooldown > CurTime() then
		rp.Notify(ply, NOTIFY_ERROR, rp.Term('OtaMorph.AlreadyStarted'))
		return
	end
	
	morph_team_appearance = {
		AppearanceID = net.ReadUInt(6),
		AppearanceSkin = net.ReadUInt(6),
		AppearanceScale = net.ReadFloat(),
		IsCustomAppearanceUID = net.ReadBool(),
		CustomAppearanceUID = net.ReadString(),
		Bodygroups = {},
	}
	
	local bg_count = net.ReadUInt(6)
	
	if bg_count > 0 then
		for k = 1, bg_count do
			morph_team_appearance.Bodygroups[net.ReadUInt(6)] = net.ReadUInt(6)
		end
	end
	
	--print('Morph :: Morph job?', job_n)
	--PrintTable(morph_team_appearance)
	
	rp.Notify(ply, NOTIFY_GREEN, rp.Term('OtaMorph.JobSelected'), rp.teams[job_n].name)
	
	morph_team = job_n
end)


local notify_cooldowns = {}
timer.Create('OtaMorph::Think', 2, 0, function()
	if morph_cooldown > CurTime() then
		return 
	end
	
	if not IsValid(config.ent_morph_btn) then
		local morph_btn = ents.FindByName(config.morph_btn)[1]
		
		if IsValid(morph_btn) then
			config.ent_morph_btn = morph_btn
		end
	end
	
	if not IsValid(config.ent_morph_btn) then
		return --print('Morph :: Invalid button!')
	end
	
	local current_cooldowns = {}
	for k, v in pairs(player.GetAll()) do
		if IsValid(v) and v:GetPos():WithinAABox(config.morph_pos[1], config.morph_pos[2]) then
			if not CanBeMorphed(v) then 
				if not notify_cooldowns[v:SteamID()] then
					rp.Notify(v, NOTIFY_ERROR, rp.Term('OtaMorph.CantTakeJob'))
					notify_cooldowns[v:SteamID()] = true
				end
				
				current_cooldowns[v:SteamID()] = true
				continue 
			end
			
			notify_cooldowns[v:SteamID()] = true
			
			StartMorph(v)
			break
		end
	end
	
	for k, v in pairs(notify_cooldowns) do
		if not current_cooldowns[k] then
			notify_cooldowns[k] = nil
		end
	end
end)
