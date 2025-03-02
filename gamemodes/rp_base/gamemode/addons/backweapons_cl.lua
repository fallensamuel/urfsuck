-- "gamemodes\\rp_base\\gamemode\\addons\\backweapons_cl.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal

if !(rp.cfg.Backweapons) then return end

rp.RealtimeInventory = rp.RealtimeInventory or {};
local RealtimeInventory = rp.RealtimeInventory

RealtimeInventory.Config = {
    DrawDistance = 1024, -- Default value: 1024 (most optimized)
    DeathRenderTicks = 100, -- Default value: 100 (most optimized),
    WeaponTag = (rp.cfg.Backweapons and rp.cfg.Backweapons.WeaponTag) or {
        ['cw'] = true,
        ['fas'] = true,
        ['fas2'] = true,
    }
};

RealtimeInventory.Buffer = RealtimeInventory.Buffer or {};

RealtimeInventory.Data = RealtimeInventory.Data or {
    LeftLeg = 0,
    RightLeg = 0,
    Spine = 0,
    MaxHolsted = 2,
    MaxDraw = 2,
    PlayerModelScale = 1,
    Timer = 'RealtimeInventory',
    AdditionalTimer = 'RealtimeInventory_DeathHandler',
    PlayersNear = {}
};

RealtimeInventory.JBlacklist = {};
RealtimeInventory.FBlacklist = {};
RealtimeInventory.IBlacklist = {};
RealtimeInventory.CPos = {};

hook.Add( "ConfigLoaded", "SetupRealtimeInventory", function()
    RealtimeInventory.Data.MaxHolsted = (rp.cfg.Backweapons and rp.cfg.Backweapons.MaxHolsted) or 2;
    RealtimeInventory.Data.MaxDraw = (rp.cfg.Backweapons and rp.cfg.Backweapons.MaxDraw) or 2;
    RealtimeInventory.JBlacklist = rp.cfg.RT_JobBlacklist or {};
    RealtimeInventory.FBlacklist = rp.cfg.RT_FactionBlacklist or {};
    RealtimeInventory.IBlacklist = rp.cfg.RT_WeaponBlacklist or {};
    RealtimeInventory.CPos = rp.cfg.RT_WeaponPos or {};
end );

-- Feature used to work without :Distance (^2)!
RealtimeInventory.Config.DrawDistance = RealtimeInventory.Config.DrawDistance * RealtimeInventory.Config.DrawDistance;

-- C menu
cvar.Register'enable_rtinventory':SetDefault(true);
rp.AddContextCommand(translates and translates.Get('Действия') or 'Действия', translates and translates.Get('Оружие за спиной') or 'Оружие за спиной', function()
    local Value = !cvar.GetValue('enable_rtinventory');
    cvar.SetValue('enable_rtinventory', Value);
    if (Value) then
        rp.Notify(NOTIFY_GENERIC, translates and translates.Get("Отображение оружия за спиной включено.") or "Отображение оружия за спиной включено.");
    else
        rp.Notify(NOTIFY_GENERIC, translates and translates.Get("Отображение оружия за спиной выключено.") or "Отображение оружия за спиной выключено.");
    end
end, nil, 'cmenu/weapon.png');

function RealtimeInventory.ComputeBounds(Entity)
    if (!IsValid(Entity) or !Entity:GetModel() or !Entity:GetModelBounds()) then return 0 end

    local BoundsMin, BoundsMax = Entity:GetModelBounds();
    return (BoundsMax.z - BoundsMin.z) * (BoundsMax.x - BoundsMin.x) * (BoundsMax.y - BoundsMin.y)
end

function RealtimeInventory.ComputeMerge(Default, Entity)
    return Default * (RealtimeInventory.ComputeBounds(Entity) * 0.0001)
end

function RealtimeInventory.ComputePlayerModelScale(Player)
    RealtimeInventory.Data.PlayerModelScale = RealtimeInventory.ComputeBounds(Player) / 30000;
end

function RealtimeInventory.SetupBone(Player, Entity, Size)
    local Class = Entity.TWeaponClass or '?';
    if (RealtimeInventory.CPos[Class]) then
        return {
            Bone = RealtimeInventory.CPos[Class].Bone or 'ValveBiped.Bip01_Spine',
            AxScale = RealtimeInventory.CPos[Class].AxScale or Angle(0, 0, -8),
            TfScale = RealtimeInventory.CPos[Class].TfScale or Vector(5, 0, 1 + RealtimeInventory.ComputeMerge(RealtimeInventory.Data.Spine, Entity))
        }
    end

    if (Size < 768 and RealtimeInventory.Data.LeftLeg < RealtimeInventory.Data.MaxHolsted) then
        RealtimeInventory.Data.LeftLeg = RealtimeInventory.Data.LeftLeg + 1;
        return {
            Bone = 'ValveBiped.Bip01_L_Thigh',
            AxScale = Angle(90, 0, 0),
            TfScale = Vector(-1.05 * RealtimeInventory.Data.PlayerModelScale - RealtimeInventory.ComputeMerge(RealtimeInventory.Data.LeftLeg, Entity), 2, 0)
        }
    elseif (Size < 768 and RealtimeInventory.Data.LeftLeg >= RealtimeInventory.Data.MaxHolsted) then
        RealtimeInventory.Data.RightLeg = RealtimeInventory.Data.RightLeg + 1;
        return {
            Bone = 'ValveBiped.Bip01_R_Thigh',
            AxScale = Angle(90, 0, 0),
            TfScale = Vector(1.05 * RealtimeInventory.Data.PlayerModelScale + RealtimeInventory.ComputeMerge(RealtimeInventory.Data.RightLeg, Entity), 2, 0)
        }
    elseif (Size > 768) then
        RealtimeInventory.Data.Spine = RealtimeInventory.Data.Spine + 1;

        return {
            Bone = 'ValveBiped.Bip01_Spine',
            AxScale = Angle(0, 0, -8),
            TfScale = Vector(5, 0, 1 + RealtimeInventory.ComputeMerge(RealtimeInventory.Data.Spine, Entity))
        }
    end
end

local Floor = math.floor;
local cvar_get = cvar.GetValue;
local table_getKeys = table.GetKeys;
local fmod = math.fmod;

function RealtimeInventory.ComputeTransform(Player)
    RealtimeInventory.Data.LeftLeg = 0;
    RealtimeInventory.Data.RightLeg = 0;
    RealtimeInventory.Data.Spine = 0;

    if (!IsValid(Player) or !Player:IsPlayer() or Player:IsBot() or !RealtimeInventory.Buffer[Player:SteamID()]) then return end

    local N = 1;
    local Active = Player:GetActiveWeapon();
    Active = IsValid(Active) and Active:GetClass() or '?';

    for _, Weapon in pairs(RealtimeInventory.Buffer[Player:SteamID()]) do
        if (!IsValid(Weapon)) then continue end

        local Size = Floor(RealtimeInventory.ComputeBounds(Weapon));
        local Params = RealtimeInventory.SetupBone(Player, Weapon, Size);

        local FBone = Player:LookupBone(Params.Bone);
        local Ragdoll = Player:GetRagdollEntity();
        local RBone = (IsValid(Ragdoll) and Ragdoll:LookupBone(Params.Bone)) or nil;

        local gClss;
        if (!FBone or (!RBone and !Player:Alive() and IsValid(Ragdoll)) or Weapon.TWeaponClass == Active) then
            gClss = Weapon.TWeaponClass or Weapon:GetClass();
            if (!gClss) then continue end
            if (IsValid(RealtimeInventory.Buffer[Player:SteamID()][gClss])) then
                RealtimeInventory.Buffer[Player:SteamID()][gClss]:Remove();
            end
            RealtimeInventory.Buffer[Player:SteamID()][gClss] = nil;
            continue
        end

        local Position, Angles = Player:GetBonePosition(FBone);
        if (!Player:Alive() and IsValid(Ragdoll)) then
            Position, Angles = Ragdoll:GetBonePosition(RBone);
        end

        Angles:RotateAroundAxis(Angles:Forward(), Params.AxScale.p);
        Angles:RotateAroundAxis(Angles:Up(), Params.AxScale.y);
        Angles:RotateAroundAxis(Angles:Right(), Params.AxScale.r);

        if (rp.cfg.Backweapons.IsFallout) then
            Params.TfScale.z = -10 + 8.5 * N;
            Angles:RotateAroundAxis(Angles:Up(), -90);
		    Angles:RotateAroundAxis(Angles:Right(), 90);
            Weapon:SetPos(Position - Angles:Up() * Params.TfScale.x + Angles:Forward() * Params.TfScale.y + Angles:Forward() * Params.TfScale.z);
        elseif (rp.cfg.Backweapons.IsStalker or rp.cfg.Backweapons.IsMetro) then
            if (fmod(N, 2) == 0) then Params.TfScale.z = 4; else Params.TfScale.z = -4; end
            Weapon:SetPos(Position + Angles:Right() * Params.TfScale.x + Angles:Forward() * Params.TfScale.y + Angles:Up() * Params.TfScale.z);
        elseif (rp.cfg.Backweapons.IsWW2) then
            local a1;
            if (fmod(N, 2) == 0) then a1 = 1; else a1 = -5; end
            Weapon:SetPos(Position + Angles:Right() * Params.TfScale.x * .8 + Angles:Forward() * (5 + Params.TfScale.y) + Angles:Up() * (a1 + Params.TfScale.z));
        end

        Weapon:SetAngles(Angles);

        if (IsValid(Weapon) and IsValid(Player:GetActiveWeapon()) and Player:GetActiveWeapon():GetModel()) then
            if (Player:Alive()) then Weapon:SetNoDraw(IsValid(Player:GetActiveWeapon()) and Weapon:GetModel() == Player:GetActiveWeapon():GetModel()); end
        end

        N = N + 1;
    end
end

local WeaponTag = RealtimeInventory.Config.WeaponTag;
local string_find = string.find

function RealtimeInventory.RecomputeWeapon(Player)
    local SteamID = Player:SteamID();
    local Class;

    for _, Weapon in pairs(Player:GetWeapons()) do
        Class = Weapon:GetClass() or "?";
			--print(Player, Class, WeaponTag[string.Split(Class, '_')[1]])
        if (!WeaponTag[string.Split(Class, '_')[1]] or !Weapon:GetModel() or RealtimeInventory.IBlacklist[Class]) then continue end
        if (IsValid(RealtimeInventory.Buffer[SteamID][Class]) or !RealtimeInventory.Data.PlayersNear[Player]) then continue end

        if (#table_getKeys(RealtimeInventory.Buffer[SteamID]) >= RealtimeInventory.Data.MaxDraw) then break end

        if not RealtimeInventory.Buffer[SteamID][Class] then
            local mdl;

            if RealtimeInventory.CPos[Class] and RealtimeInventory.CPos[Class].Model then
                mdl = RealtimeInventory.CPos[Class].Model;
            else
                mdl = Weapon:GetModel();
            end

            RealtimeInventory.Buffer[SteamID][Class] = ClientsideModel( mdl );
        end

        if (RealtimeInventory.Buffer[SteamID][Class]) then
            RealtimeInventory.Buffer[SteamID][Class].TWeaponClass = (IsValid(Weapon) and Class) or '?';
        end

        --RealtimeInventory.Buffer[SteamID][Class]:Spawn();
    end
end

function RealtimeInventory.ComputeWeapons(Player)
    if not IsValid(Player) then return end
    if (!RealtimeInventory.Buffer[Player:SteamID()]) then RealtimeInventory.Buffer[Player:SteamID()] = {}; end

    RealtimeInventory.RecomputeWeapon(Player);
end

function RealtimeInventory.ComputeDistance(Player)
    RealtimeInventory.Data.PlayersNear[Player] = LocalPlayer():GetPos():DistToSqr(Player:GetPos()) <= RealtimeInventory.Config.DrawDistance;
end

function RealtimeInventory.GarbageCollector(Player)
    if IsValid(Player) then
        if not Player:Alive() and RealtimeInventory.Buffer[Player:SteamID()] then
            for Class, CSMdl in pairs( RealtimeInventory.Buffer[Player:SteamID()] ) do
                if IsValid(CSMdl) then CSMdl:Remove(); end
            end

            RealtimeInventory.Buffer[Player:SteamID()] = nil;
            return
        end
    else
        -- to-do someting
    end

    if not RealtimeInventory.Buffer[Player:SteamID()] then return end

    local Keys = table_getKeys(RealtimeInventory.Buffer[Player:SteamID()]) or {};

    if Player == LocalPlayer() then
        if LocalPlayer():ShouldDrawLocalPlayer() then
            if Keys[1] and !IsValid( RealtimeInventory.Buffer[Player:SteamID()][Keys[1]] ) then
                for Index, Class in pairs(Keys) do
                    if IsValid( RealtimeInventory.Buffer[Player:SteamID()][Class] ) then continue end

                    local wep = weapons.Get(Class);

                    RealtimeInventory.Buffer[Player:SteamID()][Class]              = ClientsideModel( wep.WorldModel or "models/editor/axis_helper_thick.mdl" );
                    RealtimeInventory.Buffer[Player:SteamID()][Class].TWeaponClass = wep.ClassName or '?';
                end
            end
        else
            if #Keys > 0 or !Player:Alive() then
                for Index, Class in pairs( Keys ) do
                    if IsValid( RealtimeInventory.Buffer[Player:SteamID()][Class] ) then
                        RealtimeInventory.Buffer[Player:SteamID()][Class]:Remove();
                    end
                end

                RealtimeInventory.Buffer[Player:SteamID()] = {};
            end
        end
    end

    for Index, Class in pairs( Keys ) do
        if not Player:HasWeapon(Class) then
            if IsValid( RealtimeInventory.Buffer[Player:SteamID()][Class] ) then
                RealtimeInventory.Buffer[Player:SteamID()][Class]:Remove();
            end

            RealtimeInventory.Buffer[Player:SteamID()][Class] = nil;
        end
    end

    if not RealtimeInventory.Data.PlayersNear[Player] then
        for Class, CSMdl in pairs(RealtimeInventory.Buffer[Player:SteamID()]) do
            if IsValid(CSMdl) then CSMdl:Remove(); end
        end

        RealtimeInventory.Buffer[Player:SteamID()] = {};
    end
end

function RealtimeInventory.CollapseUniverse()
    for IPlayer, Player in pairs(table_getKeys(RealtimeInventory.Buffer)) do
        for IClass, Class in pairs(table_getKeys(RealtimeInventory.Buffer[Player])) do
            if (IsValid(RealtimeInventory.Buffer[Player][Class])) then
                RealtimeInventory.Buffer[Player][Class]:Remove();
            end
            RealtimeInventory.Buffer[Player][Class] = nil;
        end
    end

    if (#RealtimeInventory.Data.PlayersNear > 0) then
        table.Empty(RealtimeInventory.Data.PlayersNear);
    end
end

function RealtimeInventory.Blacklisted(Player)
    local Faction = Player:GetFaction();
    local Job = Player:GetJob();
    if (RealtimeInventory.FBlacklist[Faction]) then return true end
    if (RealtimeInventory.JBlacklist[Job]) then return true end
    return false
end

function RealtimeInventory.DeathHandler(Player)
    if (!Player:Alive()) then
        timer.Remove(RealtimeInventory.Data.AdditionalTimer);
        timer.Create(RealtimeInventory.Data.AdditionalTimer, 1 / RealtimeInventory.Config.DeathRenderTicks, 0, function()
            if (IsValid(Player) and Player:Alive()) then
                timer.Remove(RealtimeInventory.Data.AdditionalTimer);
            else
                RealtimeInventory.ComputeTransform(Player);
            end
        end);
    end
end

function RealtimeInventory.FixedUpdate()
    if (!cvar_get('enable_rtinventory')) then
        hook.Add('Move', 'RealtimeInventory_Reserve', function(Player)
            if (cvar_get('enable_rtinventory') and !timer.Exists(RealtimeInventory.Data.Timer)) then
                RealtimeInventory.FixedUpdate();
                timer.Create(RealtimeInventory.Data.Timer, .25, 0, RealtimeInventory.FixedUpdate);
                hook.Add('PostPlayerDraw', 'RealtimeInventory', RealtimeInventory.ComputeTransform);

                --hook.Remove('ShouldDrawLocalPlayer', 'RealtimeInventory_Reserve');
                hook.Remove('Move', 'RealtimeInventory_Reserve');
            end
		end);

        RealtimeInventory.CollapseUniverse();
        hook.Remove('PostPlayerDraw', 'RealtimeInventory');
        timer.Remove(RealtimeInventory.Data.Timer);
        return
    end

    for _, Player in pairs(player.GetAll()) do
        if IsValid(Player) and !Player:IsBot() then
            if
                RealtimeInventory.Blacklisted(Player)                           or
                ((Player == LocalPlayer()) and !Player:ShouldDrawLocalPlayer()) or
                ((Player ~= LocalPlayer()) and Player.ShouldNoDraw)
            then
                RealtimeInventory.GarbageCollector(Player);
                continue
            end

            RealtimeInventory.GarbageCollector(Player);
            RealtimeInventory.ComputeDistance(Player);
            RealtimeInventory.ComputeWeapons(Player);
            RealtimeInventory.ComputePlayerModelScale(Player);
            RealtimeInventory.DeathHandler(Player);
        end
    end
end

timer.Remove(RealtimeInventory.Data.Timer);
timer.Create(RealtimeInventory.Data.Timer, .25, 0, RealtimeInventory.FixedUpdate);

timer.Create('rp.RealtimeInventory.ClearDisconnected', 1, 0, function()
	for k, v in pairs(RealtimeInventory.Buffer) do
		if not player.GetBySteamID(k) then
			for Class, CSMdl in pairs(v) do
				if IsValid(CSMdl) then
					CSMdl:Remove()
				end
			end

			RealtimeInventory.Buffer[k] = nil;
		end
	end
end)

hook.Add('PostPlayerDraw', 'RealtimeInventory', RealtimeInventory.ComputeTransform);

hook.Add('PlayerSwitchWeapon', 'RealtimeInventory', function(Player, OldWeapon, NewWeapon)
    local SteamID = Player:SteamID();

    if (!RealtimeInventory.Buffer[SteamID]) then return end
    if (!IsValid(OldWeapon) or !OldWeapon:GetClass() or !OldWeapon:GetModel()) then return end

    local Class = OldWeapon:GetClass();
    local Keys = table_getKeys(RealtimeInventory.Buffer[SteamID]);
    local Active = Player:GetActiveWeapon();

    local NWeapClass = IsValid(NewWeapon) and NewWeapon:GetClass() or '?';
    Active = IsValid(Active) and Active:GetClass() or '?';

    if (!WeaponTag[string.Split(Class, '_')[1]] or RealtimeInventory.IBlacklist[Class]) then return end

    if (!RealtimeInventory.Buffer[SteamID][Class] and NWeapClass != Active) then
        for Index = RealtimeInventory.Data.MaxDraw - 1, #Keys do
            if not Keys[Index] then continue end

            if (IsValid(RealtimeInventory.Buffer[SteamID][Keys[Index]])) then
                RealtimeInventory.Buffer[SteamID][Keys[Index]]:Remove();
            end

            RealtimeInventory.Buffer[SteamID][Keys[Index]] = nil;
        end

        if not RealtimeInventory.Buffer[SteamID][Class] then
            local mdl;

            if RealtimeInventory.CPos[Class] and RealtimeInventory.CPos[Class].Model then
                mdl = RealtimeInventory.CPos[Class].Model;
            else
                mdl = OldWeapon:GetModel();
            end

            RealtimeInventory.Buffer[SteamID][Class] = ClientsideModel( mdl ); --ents.CreateClientProp(OldWeapon:GetModel());
            RealtimeInventory.Buffer[SteamID][Class].TWeaponClass = (IsValid(OldWeapon) and Class) or '?';
        end

        --RealtimeInventory.Buffer[SteamID][Class]:Spawn();
    end
end);