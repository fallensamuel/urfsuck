util.AddNetworkString("nutScannerData")

local PICTURE_DELAY = 15

local vector = Vector(0, 0, 64)
local Vector = Vector
local IsValid = IsValid
local timer = timer

local lastRemove = ENTITY.Remove

local spawns = rp.cfg.ScannerSpawns[game.GetMap()]

function createScanner(client, class)
	class = class or "npc_clawscanner"

	if (IsValid(client.nutScn)) then
		return
	end

	local entity = ents.Create(class)

	if (!IsValid(entity)) then
		return
	end
	
	local pos = table.Random(spawns)
	entity:SafeSetPos(pos[1])
	entity:SetAngles(pos[2])
	entity:Spawn()
	entity:Activate()
	entity.player = client
	entity.spawn = client:GetPos()

	client:SetNWEntity("scanner", entity) -- Draw the player info when looking at the scanner.
	
	entity:CallOnRemove("nutRestore", function()
		if (IsValid(client)) then
			client:UnSpectate()
			client:SetViewEntity(NULL)

			client:KillSilent()
		end
	end)

	local name = "nutScn"..os.clock()
	entity.name = name

	local target = ents.Create("path_track")
	target:SafeSetPos(entity:GetPos())
	target:Spawn()
	target:SetName(name)


	entity:Fire("setfollowtarget", name)
	entity:Fire("inputshouldinspect", false)
	entity:Fire("setdistanceoverride", "48")
	entity:SetKeyValue("spawnflags", 8208)

	client.nutScn = entity
	client:StripWeapons()
	client:Spectate(OBS_MODE_CHASE)
	client:SpectateEntity(entity)

	client:ChatPrint( "W, D - вперёд, назад; SPACE, CTRL - вверх, вниз; Колесы мыши - приблизить / отдалить; ALT - изменить вид; ЛКМ - повесить розыск; E, R - издать звук; /eject - покинуть сканнер" )

	local uniqueID = "nut_Scanner"..client:UniqueID()

	timer.Create(uniqueID, 0.33, 0, function()
		if (!IsValid(client) or !IsValid(entity) or !IsValid(target)) then
			if (IsValid(entity)) then
				entity:Remove()
			end
			
			return timer.Remove(uniqueID)
		end

		local factor = 300

		if (client:KeyDown(IN_SPEED)) then
			factor = 64
		end

		if (client:KeyDown(IN_FORWARD)) then
			target:SafeSetPos((entity:GetPos() + client:GetAimVector()*factor) - vector)
			entity:Fire("setfollowtarget", name)
		elseif (client:KeyDown(IN_BACK)) then
			target:SafeSetPos((entity:GetPos() + client:GetAimVector()*-factor) - vector)
			entity:Fire("setfollowtarget", name)
		elseif (client:KeyDown(IN_JUMP)) then
			target:SafeSetPos(entity:GetPos() + Vector(0, 0, factor))
			entity:Fire("setfollowtarget", name)	
		elseif (client:KeyDown(IN_DUCK)) then
			target:SafeSetPos(entity:GetPos() - Vector(0, 0, factor))
			entity:Fire("setfollowtarget", name)				
		end

		client:SafeSetPos(entity:GetPos())
	end)

	return entity
end

rp.AddCommand("/eject", function(pl)
	if IsValid(pl.nutScn) then
		pl:KillSilent()
	end
end)

hook.Add("PlayerSpawn", "ScannerPlayerSpawn", function(client)
	if (IsValid(client.nutScn)) then
		client.nutScn.spawn = client:GetPos()
		client.nutScn:Remove()
	end
end)

hook.Add("PlayerDeath", "ScannerPlayerDeath", function(client)
	if (IsValid(client.nutScn)) then
		client.nutScn:TakeDamage(999)
	end
end)

local SCANNER_SOUNDS = {
	"npc/scanner/scanner_blip1.wav",
	"npc/scanner/scanner_scan1.wav",
	"npc/scanner/scanner_scan2.wav",
	"npc/scanner/scanner_scan4.wav",
	"npc/scanner/scanner_scan5.wav",
	"npc/scanner/combat_scan1.wav",
	"npc/scanner/combat_scan2.wav",
	"npc/scanner/combat_scan3.wav",
	"npc/scanner/combat_scan4.wav",
	"npc/scanner/combat_scan5.wav",
	"npc/scanner/cbot_servoscared.wav",
	"npc/scanner/cbot_servochatter.wav"
}

hook.Add("KeyPress", "ScannerKeyPress", function(client, key)
	if (IsValid(client.nutScn) and (client.nutScnDelay or 0) < CurTime()) then
		local source

		if (key == IN_USE) then
			source = table.Random(SCANNER_SOUNDS)
			client.nutScnDelay = CurTime() + 1.75
		elseif (key == IN_RELOAD) then
			source = "npc/scanner/scanner_talk"..math.random(1, 2)..".wav"
			client.nutScnDelay = CurTime() + 10
		elseif (key == IN_WALK) then
		--	if (client:GetViewEntity() == client.nutScn) then
		--		client:SetViewEntity(NULL)
		--	else
		--		client:SetViewEntity(client.nutScn)
		--	end
		end

		if (source) then
			client.nutScn:EmitSound(source)
		end
	end
end)

hook.Add("CanPlayerReceiveScan", function()
	return true
end)


net.Receive("nutScannerData", function(length, client)
	if (IsValid(client.nutScn) and client:GetViewEntity() == client.nutScn and (client.nutNextPic or 0) < CurTime()) then
		client.nutNextPic = CurTime() + (PICTURE_DELAY - 1)
		client:GetViewEntity():EmitSound("npc/scanner/scanner_photo1.wav", 140)
		client:EmitSound("npc/scanner/combat_scan5.wav")

		local length = net.ReadUInt(16)
		local data = net.ReadData(length)

		if (length != #data) then
			return
		end

		local receivers = {}

		for k, v in ipairs(player.GetAll()) do
			if (hook.Run("CanPlayerReceiveScan", v, client)) then
				receivers[#receivers + 1] = v
				v:EmitSound("npc/overwatch/radiovoice/preparevisualdownload.wav")
			end
		end

		if (#receivers > 0) then
			net.Start("nutScannerData")
				net.WriteUInt(#data, 16)
				net.WriteData(data, #data)
			net.Send(receivers)

			if (SCHEMA.addDisplay) then
				SCHEMA:addDisplay("Prepare to receive visual download...")
			end
		end
	end
end)

local f = function(ply, cmd, v, r)
	timer.Simple(2, function()
		ply.nutScn:EmitSound('npc/overwatch/radiovoice/preparevisualdownload.wav', 140)
	end)
	ply.nutScn:EmitSound('npc/scanner/scanner_photo1.wav', 140)
	ply:EmitSound("npc/scanner/combat_scan5.wav")
	hook.Call('PlayerRunRPCommand', nil, ply, cmd, {v, r}, nil)
	rp.commands[cmd](ply, nil, {v, r})
end

util.AddNetworkString("wanted_scanner")
net.Receive('wanted_scanner', function(len, ply)
	local ent = net.ReadEntity()
	local reason = rp.GetTerm('WantedReasons')[net.ReadInt(4)]
	if !(IsValid(ent) && reason && IsValid(ply.nutScn)) then return end

	if ent:IsPlayer() then
		f(ply, '/want', ent:SteamID(), reason)
	end
end)

timer.Create('clean_gibs', 30, 0, function()
	for k,v in pairs(ents.FindByClass( "gib" )) do v:Remove() end
	for k,v in pairs(ents.FindByClass('class C_ClientRagdoll')) do v:Remove() end
end)