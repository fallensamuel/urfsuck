local IsValid = IsValid

--——————————————————————————————————————————————————————————————————————————————————————————————————————————> Drop from vehicle

local drop_players_from = { prop_vehicle_prisoner_pod = true, }
hook.Add('PlayerPhysgunEntity', 'PickupChair', function(_, ent)
	if drop_players_from[ent:GetClass()] and IsValid(ent:GetDriver()) and ent:GetDriver():IsPlayer() then
		ent:GetDriver():ExitVehicle()
	end
end)

hook.Add("CanPlayerEnterVehicle", "PickupChair", function(ply, ent)
    if ent.BeingPhysed then
		return false
	end
end)

--——————————————————————————————————————————————————————————————————————————————————————————————————————————> Meta things

function PLAYER:SetTempJobName(name)
    self.HasHaveTempJobName = true
    self:SetNetVar("job", name)
end

hook.Add("PlayerSpawn", "PMETA_SetTempJobName", function(ply)
    if ply.HasHaveTempJobName then
        ply:SetNetVar("job", ply:GetJobTable().name)
        ply.HasHaveTempJobName = nil
    end
end)

function PLAYER:GiveWeapons(...)
    local t = {...}
    for key, class in pairs_(t) do
        self:Give(class)
    end
end

function PLAYER:SetWeaponTakeBlock(b)
    self.CantTakeWeapons = tobool(b)
end

local timer_Simple = timer.Simple

hook.Add("WeaponEquip", "PMETA_SetWeaponTakeBlock", function(wep, ply)
    --print('Wep', ply, wep, rp.cfg.DisallowDrop[wep:GetClass()])
    if IsValid(wep) and ply:GetJobTable().CantTakeWeapons or ply.CantTakeWeapons then
        local __a = wep:GetClass()
        if ply:GetJobTable().AllowedTakeSWEPS and not table.HasValue(ply:GetJobTable().AllowedTakeSWEPS, __a) then
            timer_Simple(0, function()
                ply:DropWeapon(wep)
            end)
            return false
        end        
    end
end)

--——————————————————————————————————————————————————————————————————————————————————————————————————————————> Unbreackable
hook.Add("PlayerSpawnedProp", function(ply, mdl, ent)
	ent:Fire('SetDamageFilter', 'FilterDamage', 0)
end)

--——————————————————————————————————————————————————————————————————————————————————————————————————————————> Health regen
function PLAYER:SetHealthRegen(num)
    self.hpRegen = num
end

local maxHealth, health, regen
timer.Create("HPRegen", 5, 0, function()
	for k, ply in pairs(player.GetAll()) do
		if ply:Alive() then
			regen = ply:GetTeamTable().hpRegen or ply.hpRegen
			if regen then
				maxHealth = ply:GetMaxHealth()
				health = ply:Health()
				if health >= maxHealth - regen then
					ply:SetHealth(maxHealth)
				elseif health + regen < maxHealth then
					ply:SetHealth(health + regen)
				end
				
				if ply:Health() <= 0 then
					ply:Kill()
				end
			end
		end
	end
end)

--——————————————————————————————————————————————————————————————————————————————————————————————————————————> Disable sprays
game.ConsoleCommand("sv_allowupload 0\n");

hook.Add("PlayerSpray", "rp.DisablePlayerSprays", function()
    return true
end)

--——————————————————————————————————————————————————————————————————————————————————————————————————————————> Death Sounds
--[[
local deathSongsCP={Sound("npc/metropolice/die1.wav"),Sound("npc/metropolice/die2.wav"),Sound("npc/metropolice/die3.wav"),Sound("npc/metropolice/die4.wav")}
local deathSongsOTA={Sound("npc/metropolice/die1.wav"),Sound("npc/metropolice/die2.wav"),Sound("npc/metropolice/die3.wav"),Sound("npc/metropolice/die4.wav")}
local deathSongsZombie={Sound("npc/zombie/zombie_die1.wav"),Sound("npc/zombie/zombie_die2.wav"),Sound("npc/zombie/zombie_die3.wav")}
]]--


local table_Random = table.Random
local death_sound

hook.Add("PlayerDeath", function(ply)
	death_sound = nil
	
	if ply:IsDisguised() then
		death_sound = ply:GetDisguiseJobTable().deathSound
	else 
		death_sound = ply:GetJobTable().deathSound
	end
	
	if death_sound == nil then
		death_sound = rp.cfg.DeathSound
	end
	
	if death_sound ~= false then 
		ply:EmitSound(table_Random(istable(death_sound) and death_sound or {death_sound}), 75)
		
		--[[
		if ply:IsCombineOrDisguised() then
			ply:EmitSound(table_Random(ply:GetFaction() == FACTION_COMBINE && deathSongsCP || deathSongsOTA), 75)
		elseif ply:IsZombie() then
			ply:EmitSound(table_Random(deathSongsZombie), 75)
		end
		]]--
	end
end)

hook.Add("EntityTakeDamage", "DeathSoundsFromSWEP", function(ply, dmg)
    if not ply:IsPlayer() then return end
    local att = dmg:GetAttacker()
    if not IsValid(att) or not att:IsPlayer() then return end
    local swep = att:GetActiveWeapon()
    if not IsValid(swep) then return end
    if swep.OnKillSound then
        ply:EmitSound(istable(swep.OnKillSound) and table_Random(swep.OnKillSound) or swep.OnKillSound)
    end
end)

--——————————————————————————————————————————————————————————————————————————————————————————————————————————> Damage in vehicle

/*
hook.Add("PlayerShouldTakeDamage", "DamagePlayerInvehicle", function(ent, dmg)
	print(ent, dmg)
end)
*/

hook.Add("EntityTakeDamage", "DamagePlayerInVehicle", function(ent, dmg)
    if drop_players_from[ent:GetClass()] and IsValid(ent:GetDriver()) and ent:GetDriver():IsPlayer() then
		ent:GetDriver():TakeDamageInfo(dmg)
	end
end)

--——————————————————————————————————————————————————————————————————————————————————————————————————————————> Auto Freezer
rp.AutoFreezer = {};

local VehicleDistance = rp.cfg.AutoFreezer_VehicleDistance or 300;
local VehicleDistanceSqr = VehicleDistance * VehicleDistance;

local valid_classes = {
	prop_physics = true,
	prop_physics_multiplayer = true,
	prop_vehicle_prisoner_pod = true,
}

function rp.AutoFreezer.ValidClass(Entity)
    return IsValid(Entity) and valid_classes[Entity:GetClass()]
end

--function rp.AutoFreezer.SpecialCollision(a)local b=ents.FindByClass('gmod_sent_vehicle_fphysics_base')if#b<1 then return end;if not IsValid(a)then return end;timer.Create('autofreezer_'..a:GetCreationID()..'_specialcollision',1,0,function()if not IsValid(a)then timer.Remove('autofreezer_'..a:GetCreationID()..'_specialcollision')return end;for c,d in pairs(ents.FindByClass('gmod_sent_vehicle_fphysics_base'))do if IsValid(d)and a:GetPos():DistToSqr(d:GetPos())<=VehicleDistance then a:SetCollisionGroup(COLLISION_GROUP_WORLD)end end end)end

function rp.AutoFreezer.AntiPlayerBlock(Entity)
	--print(Entity, 'AntiPlayerBlock')
	
    if (not IsValid(Entity)) then return end
    local EntPos = Entity:GetPos()
--[[
    for k, v in pairs(ents.FindByClass('gmod_sent_vehicle_fphysics_base')) do
        if (IsValid(v) and EntPos:DistToSqr(v:GetPos()) <= VehicleDistance) then
            timer.Simple(1, function()
                rp.AutoFreezer.AntiPlayerBlock(Entity)
            end)

            return
        end
    end
]]--

	local ModelRadius = Entity:GetModelRadius()
	local ModelRadiusSqr = ModelRadius * ModelRadius * (valid_classes[Entity:GetClass()] and 1 or 3)
	
    --for k, v in pairs(ents.FindInSphere(Entity:GetPos(), math.max(ModelRadius, VehicleDistance))) do
    for k, v in pairs(ents.FindInSphere(Entity:GetPos(), ModelRadius)) do
        if IsValid(v) and v ~= Entity and v:GetParent() ~= Entity and not (v:IsPlayer() and IsValid(v:GetVehicle()) and (v:GetVehicle() == Entity or v:GetVehicle():GetParent() == Entity)) then
            --if v:IsVehicle() and EntPos:DistToSqr(v:GetPos()) <= VehicleDistanceSqr or not v:IsVehicle() and EntPos:DistToSqr(v:GetPos()) <= ModelRadiusSqr and (v:IsPlayer() or v:IsNPC() or v:GetClass() == "prop_door_rotating") then
            if --[[EntPos:DistToSqr(v:GetPos()) <= ModelRadiusSqr and]] (v:IsVehicle() or v:IsPlayer() or v:IsNPC() or v:IsDoor()) then
                timer.Simple(1, function()
                    rp.AutoFreezer.AntiPlayerBlock(Entity)
                end)

                return 
            end
        end
    end

    Entity:SetCollisionGroup(Entity.CollisionParam or COLLISION_GROUP_NONE)
    Entity:SetColor(Entity.ColorParam or Color(255, 255, 255))
    Entity:SetRenderMode(Entity.RenderModeParam or RENDERMODE_NORMAL)
    Entity.CollisionParam = nil
    Entity.RenderModeParam = nil
    Entity.ColorParam = nil
end

function rp.AutoFreezer.Block(Entity, RemainAlpha)
    Entity.CollisionParam = Entity:GetCollisionGroup()
    Entity.RenderModeParam = Entity:GetRenderMode()
    Entity.ColorParam = Entity:GetColor()
	
	if not RemainAlpha then
		Entity:SetColor(Color(255, 255, 255, 200))
	end
	
    Entity:SetRenderMode(RENDERMODE_TRANSCOLOR)
    Entity:SetCollisionGroup(COLLISION_GROUP_WORLD)
end

hook.Add('OnPhysgunPickup', 'Freezer_PhysgunPickup', function(Player, Entity)
	if (rp.cfg.AllowGhostingAllEntities or rp.AutoFreezer.ValidClass(Entity)) then
		--rp.AutoFreezer.SpecialCollision(Entity);
		rp.AutoFreezer.Block(Entity, rp.QObjects[Entity:GetClass()])
	end
end)

hook.Add('OnPhysgunReload', 'Freezer_PhysgunReload', function(Physgun, Player) return false end)

hook.Add('PhysgunDrop', 'Freezer_PhysgunDrop', function(Player, Entity)
	--timer.Remove('autofreezer_' .. Entity:GetCreationID() .. '_specialcollision');
	local valid_class = rp.AutoFreezer.ValidClass(Entity)
	
	if (valid_class or rp.cfg.AllowGhostingAllEntities) then
		rp.AutoFreezer.AntiPlayerBlock(Entity)
		
		if not rp.cfg.DisableAutoFreeze and valid_class or (rp.cfg.AllowGhostingAllEntities and not Entity:IsNPC() and rp.QObjects[Entity:GetClass()] and not rp.QObjects[Entity:GetClass()].no_freeze) then
			Entity:GetPhysicsObject():EnableMotion(false)
		end
	end
end)

--——————————————————————————————————————————————————————————————————————————————————————————————————————————> Anti Steal File
/*
local read = file.Read
local open = file.Open

function file.Read(name, path)
    if path == nil or path == "DATA" then 
        return read(name, path)
    else
        return ""
    end
end

function file.Open(name, mode, path)
    if path == nil or path == "DATA" then 
        return open(name, mode, path)
    else
        return ""
    end
end
*/
--——————————————————————————————————————————————————————————————————————————————————————————————————————————> Build
hook("PlayerCanPickupWeapon", function(ply, wep)
    if ply:GetTeamTable().build == false && !table.HasValue(ply:GetTeamTable().weapons, wep:GetClass()) then
        return hook.Run("CustomWeaponCheck", ply, wep)
    end
end)

hook("PlayerSpawnProp", function(ply)
    if !ply:GetTeamTable().build then
        return false
    end
end)

hook("PlayerSwitchFlashlight", function(ply)
    if !ply:GetTeamTable().build then
        return false
    end
end)

--——————————————————————————————————————————————————————————————————————————————————————————————————————————> Zombies
local attacker_zombie
local victim_zombie
local attacker_cooldowns
hook('PlayerDeath', function(victim, inflictor, attacker)
    if IsValid(attacker) && attacker:IsPlayer() then
        attacker_zombie = attacker.IsZombie and attacker:IsZombie()
        victim_zombie = victim.IsZombie and victim:IsZombie()

        if attacker_zombie && !victim_zombie then
            attacker:AddMoney(rp.cfg.ZombieReward)
            attacker:Notify(NOTIFY_GENERIC, rp.Term('ZombieKillReward'))
        elseif !attacker_zombie && victim_zombie then
            attacker:AddMoney(rp.cfg.ZombieReward)
            attacker:Notify(NOTIFY_GENERIC, rp.Term('ZombieKillReward'))
        end
		
		if rp.cfg.FactionKillRewards and attacker:GetFaction() and (not attacker_cooldowns[attacker:SteamID()] or attacker_cooldowns[attacker:SteamID()] < CurTime()) and rp.cfg.FactionKillRewards[attacker:GetFaction()] and IsValid(victim) and victim:GetFaction() and rp.cfg.FactionKillRewards[attacker:GetFaction()][victim:GetFaction()] then
			attacker_cooldowns[attacker:SteamID()] = CurTime() + 5 * 60
            attacker:AddMoney(rp.cfg.FactionKillRewards[attacker:GetFaction()][victim:GetFaction()])
            attacker:Notify(NOTIFY_GENERIC, rp.Term('FactionKillReward'), rp.cfg.FactionKillRewards[attacker:GetFaction()][victim:GetFaction()])
		end
    end
end)

--——————————————————————————————————————————————————————————————————————————————————————————————————————————> Food System
util.AddNetworkString( "net.foodsystem.InterpolateArm" );

rp.FoodSystem = rp.FoodSystem or {};

rp.FoodSystem.SpawnFood = function( class, pos, ang )
    local me = weapons.GetStored(class);
    if not istable(me) then return end

    local ent = ents.Create( "spawned_weapon" );
    ent:SetPos( pos );
    ent:SetAngles( ang );
    ent:SetModel( me.WorldModel );
    ent.weaponclass = class;
    ent:Spawn();
end

--[[
rp.cfg.FoodSystem = rp.cfg.FoodSystem or {
    Faction = {
        [FACTION_COMBINE]   = "urf_foodsystem_ration_mpf",
        [FACTION_HELIX]     = "urf_foodsystem_ration_mpf",
        [FACTION_DAP]       = "urf_foodsystem_ration_mpf",
        [FACTION_DPF]       = "urf_foodsystem_ration_mpf",
        [FACTION_ANTIHUMAN] = "urf_foodsystem_ration_mpf",
        [FACTION_OTA]       = "urf_foodsystem_ration_mpf",

        [FACTION_CWU]       = "urf_foodsystem_ration_cwu",
    },
    Loyalty = {
        "urf_foodsystem_ration_minimal",
        "urf_foodsystem_ration_normal",
        "urf_foodsystem_ration_normal",
        "urf_foodsystem_ration_expanded",
    },
};
]]--