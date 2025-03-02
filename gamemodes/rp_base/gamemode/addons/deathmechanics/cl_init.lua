-- "gamemodes\\rp_base\\gamemode\\addons\\deathmechanics\\cl_init.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local DeathMechanics = {};

-----------------------------------

local SetColor = surface.SetDrawColor;
local SetMaterial = surface.SetMaterial;
local Texture = surface.DrawTexturedRect;
local Alpha = surface.SetAlphaMultiplier;
local DrawPoly = surface.DrawPoly;

local RoundedBox = draw.RoundedBox;
local SimpleText = draw.SimpleText;

local Insert = table.insert;
local Rad = math.rad;
local Sin, Cos = math.sin, math.cos;
local Floor = math.floor;

local NoTexture = draw.NoTexture;
local CurTime = CurTime

-----------------------------------

local Width, Height, Radius;
local StartX, StartY, Poly;
local VarA, VarB, VarC, VarD, VarE, VarF;

local KCD = 0;
local LastBuffered = {};

-----------------------------------

local content_folder = "deathmechanics"

local Skull = Material(content_folder..'/skull');
local Circle = Material(content_folder..'/circle');

local GrayCircle = Material(content_folder..'/cline');
local GoldCircle = Material(content_folder..'/gline');

local LeftButton = Material(content_folder..'/lmb');
local RightButton = Material(content_folder..'/rmb');

local Pulse = Material(content_folder..'/pulse');
local PulseCircle = Material(content_folder..'/white');
local PulseCircleLine = Material(content_folder..'/wline');

local Fangs = Material(content_folder .. '/fangs');

-----------------------------------

surface.CreateFont('DM.Font', {
    font = 'Montserrat',
    size = ScrH() * .019,
    extended = true,
    antialias = true,
    shadow = true,
    weight = 600
});

-----------------------------------

DeathMechanics.State = DeathMechanics.State or 0;
DeathMechanics.DTime = DeathMechanics.DTime or 0;
DeathMechanics.QTime = DeathMechanics.QTime or 0;
DeathMechanics.Time = DeathMechanics.Time or 0;
DeathMechanics.CanRevive = DeathMechanics.CanRevive or false;
DeathMechanics.IsMonster = DeathMechanics.IsMonster or false;

-----------------------------------

function GetDeathMechanicsState()
    return DeathMechanics.State
end

function DeathMechanics.Request(Action)
    if hook.Run("Can.DeathMechanics.Request", Action) == false then return end

    net.Start('DeathMechanics');
        net.WriteUInt(Action, 3);
    net.SendToServer();
end

-----------------------------------

function DeathMechanics.Network()
    DeathMechanics.State = net.ReadUInt(3);
    DeathMechanics.DTime = net.ReadUInt(8);
    DeathMechanics.QTime = net.ReadUInt(8);
    DeathMechanics.Time = CurTime() + DeathMechanics.DTime;
    DeathMechanics.CanRevive = LocalPlayer():GetJobTable() and LocalPlayer():GetJobTable().CanSelfRevive or LocalPlayer():GetFactionTable() and LocalPlayer():GetFactionTable().CanSelfRevive or false;
    DeathMechanics.IsMonster = (LocalPlayer():GetJobTable().monster and DeathMechanics.State == 4) or false;
end

-----------------------------------
DeathMechanics.EatingPlayer = nil

function DeathMechanics.KeyPress(Player, Key)
    if KCD > CurTime() then return end
    if rpSupervisor and rpSupervisor.ID > 0 then return end

    if Key == IN_ATTACK then
		--if Player:GetJobTable() and Player:GetJobTable().CanSelfRevive or Player:GetFactionTable() and Player:GetFactionTable().CanSelfRevive or hook.Call('ShouldDMRevive', nil, Player) then
			--print(Player:GetJobTable() and Player:GetJobTable().CanSelfRevive, Player:GetFactionTable() and Player:GetFactionTable().CanSelfRevive, hook.Call('ShouldDMRevive', nil, Player))
			--DeathMechanics.Request(1)
		--end

    elseif Key == IN_ATTACK2 then
        --DeathMechanics.Request(2)
    elseif Key == IN_USE then

		local result = hook.Run("DeathMechanics.CanUse", Player, Key)
        if result ~= false and Player:Alive() and not IsValid(DeathMechanics.EatingPlayer) then
			local Trace = Player:GetEyeTrace();
			local Ents = ents.FindInSphere(Trace.HitPos, rp.cfg.dm_ReviveDistance or 60);
			local HasPlayer;
			for Index, Ent in pairs(Ents) do
				if (IsValid(Ent) and Ent:IsPlayer() and Ent != LocalPlayer() and Ent:Alive()) then
					if (Player:GetPos():Distance(Ent:GetPos()) <= (rp.cfg.dm_ReviveDistance or 60)) then
						HasPlayer = Ent;
					end
				end
			end

			if IsValid(HasPlayer) then
				DeathMechanics.EatingPlayer = HasPlayer
			end
        end
    else
        return
    end

    KCD = CurTime() + 1;
end

-----------------------------------

function DeathMechanics.KeyRelease(Player, Key)
    if rpSupervisor and rpSupervisor.ID > 0 then return end

    hook.Run( "DeathMechanics.KeyReleased", ply, key );

    --[[
    if (Key == IN_ATTACK) then
	--DeathMechanics.Request(4);
    --elseif (Key == IN_ATTACK2) then --DeathMechanics.Request(5);
    elseif (Key == IN_USE) then
        --DeathMechanics.Request(6);
        DeathMechanics.EatingPlayer = nil
    end
    ]]--
end

-----------------------------------

function DeathMechanics.PlayerButtonUp(Player, Key)
    if Key == KEY_SPACE then
        DeathMechanics.EatingPlayer = nil
    end
end

-----------------------------------

local LERP, FrameTIME = Lerp, FrameTime
local DrawAlpha = 0
local TxtAlpha_1, TxtAlpha_2, MatAlpha = 0.35, 0.35, 0
local whiteCol = Color(255, 255, 255)
local goldCol = Color(255, 175, 0)
local LocalPlayer = LocalPlayer
local ColorAlpha = ColorAlpha
local render = render
local TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, STENCIL_EQUAL, STENCIL_KEEP = TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, STENCIL_EQUAL, STENCIL_KEEP
local redCol = Color(255, 64, 64)

local die_text = translates and translates.Get("УДЕРЖИВАЙТЕ, ЧТОБЫ ПОГИБНУТЬ") or "УДЕРЖИВАЙТЕ, ЧТОБЫ ПОГИБНУТЬ"
local rev_text = translates and translates.Get("УДЕРЖИВАЙТЕ, ЧТОБЫ ВОЗРОДИТЬСЯ") or "УДЕРЖИВАЙТЕ, ЧТОБЫ ВОЗРОДИТЬСЯ"
local monster_text = translates and translates.Get("КД НА ПРЕВРАЩЕНИЕ") or "КД НА ПРЕВРАЩЕНИЕ"
local stop_text = translates and translates.Get("НАЖМИТЕ # ЧТОБЫ ПРЕКРАТИТЬ ПОДНЯТИЕ") or "НАЖМИТЕ %s ЧТОБЫ ПРЕКРАТИТЬ ПОДНЯТИЕ"
local stop_keys = {[1] = translates and translates.Get("[Пробел]") or "[Пробел]"}
stop_text = string.Explode( "#", stop_text );

function DeathMechanics.HUD()
    --draw.SimpleText(DrawAlpha, "DM.Font", ScrW()/2, ScrH()/2 + 120, whiteCol, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

    local FrTime = FrameTIME()

    if DeathMechanics.State == 0 then
        DrawAlpha = LERP(FrTime * 3, DrawAlpha, 0)
        return
    end

    local LocalPlayer = LocalPlayer()
    local EmoteAction = LocalPlayer:GetEmoteAction();

    Width, Height = ScrW(), ScrH();
    Radius = Height * .1;
    StartX = (Width - Radius) * .5;
    StartY = Height - Height * .12 - Radius;

    if (DeathMechanics.State == 4) then
        Radius = Height * .05;
        StartX = (Width - Radius) * .5;
        StartY = (Height - Radius) * .5;
    end

    --SetColor(whiteCol);
    Poly = {};
    VarA = Radius * .5;
    VarB = StartX + VarA;
    VarC = StartY + VarA;

    Insert(Poly, {x = VarB, y = VarC});
    VarD = Rad(0);
    Insert(Poly, {x = VarB - Sin(VarD) * VarA, y = VarC - Cos(VarD) * VarA});

    VarF = (DeathMechanics.QTime != 0) and DeathMechanics.QTime or DeathMechanics.DTime;

    local state = LocalPlayer:GetDeathMechanicsState();
    local bool_a, bool_b = DeathMechanics.State != 4 and (state == DEATHMECHANICS_FALL), (state == DEATHMECHANICS_HEAL) --EmoteAction == 'dm_fall', EmoteAction == 'dm_heal'

    local time_ = not bool_a and bool_b and DeathMechanics.Time or LocalPlayer:GetNetVar("deathmech_t", CurTime())

    if not time_ then return end

    VarE = Floor(90 * (time_ - CurTime()) / VarF);
    for Segment = 0, VarE do
        VarD = Rad((Segment / 90) * -360);
        Insert(Poly, {x = VarB - Sin(VarD) * VarA, y = VarC - Cos(VarD) * VarA});
    end


    DrawAlpha = LERP(FrTime * 5, DrawAlpha, (bool_a or bool_b or VarE > 0) and 255 or 0)
    if DrawAlpha <= 0 then return end

    local is_eating = DeathMechanics.IsMonster and (IsValid(DeathMechanics.EatingPlayer) and DeathMechanics.EatingPlayer:GetFaction() ~= LocalPlayer:GetFaction())

    SetColor(ColorAlpha(is_eating and redCol or whiteCol, DrawAlpha));

    if bool_a then
        if bool_b then
            SetMaterial(PulseCircleLine);
            Texture(StartX, StartY + 1, Radius, Radius - 1);

            SetMaterial(Pulse);
            Texture((Width - Radius) * .5 + 8, (Height - Radius * .7) * .5 + 5, Radius - 16, Radius * .7 - 10);
        else
            SetMaterial(Circle);
            Texture(StartX + 5, StartY + 5, Radius - 10, Radius - 10);

            SetMaterial(GrayCircle);
            Texture(StartX + 3, StartY + 3, Radius - 6, Radius - 6);
        end

        NoTexture();
        rpui.ExperimentalStencil(function()
            DrawPoly(Poly);
            render.SetStencilCompareFunction(STENCIL_EQUAL);
            render.SetStencilFailOperation(STENCIL_KEEP);
            SetMaterial(GoldCircle);

            if bool_b then
                Texture(StartX, StartY + 1, Radius, Radius - 1);
            else
                Texture(StartX + 3, StartY + 3, Radius - 6, Radius - 6);
            end
        end);

        --SetColor(MatAlpha, MatAlpha, MatAlpha)
        SetMaterial(bool_b and Pulse or Skull);
        VarA = Radius * .6;
        VarB = VarA * .8;
        VarC = Radius * .5;
        Texture(StartX + VarC - VarB * .5, StartY + VarC - VarA * .5, VarB, VarA);

        if (DeathMechanics.CanRevive) then
            TxtAlpha_1 = LERP(FrTime * 3, TxtAlpha_1, (DeathMechanics.State == 2) and .35 or 1)
            Alpha(TxtAlpha_1);
                SetMaterial(LeftButton);
                Texture(StartX - Radius * .25 - 10, StartY + Radius * .5 - Radius * .35 * .5, Radius * .25, Radius * .35);
                SimpleText(rev_text, 'DM.Font', StartX - Radius * .25 - 20, StartY + Radius * .5, whiteCol, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER);
            Alpha(1);
        end

        TxtAlpha_2 = LERP(FrTime * 3, TxtAlpha_2, LocalPlayer:KeyDown(IN_ATTACK2) and .35 or 1)--DeathMechanics.State == 3 and .35 or 1)
        Alpha(TxtAlpha_2);
            SetMaterial(RightButton);
            Texture(StartX + Radius + 10, StartY + Radius * .5 - Radius * .35 * .5, Radius * .25, Radius * .35);
            SimpleText(die_text, 'DM.Font', StartX + Radius + Radius * .25 + 20, StartY + Radius * .5, whiteCol, nil, TEXT_ALIGN_CENTER);
        Alpha(1);
    elseif bool_b then
        SetMaterial(PulseCircleLine);
        Texture(StartX, StartY + 1, Radius, Radius - 1);

        SetMaterial(is_eating and Fangs or Pulse);
        Texture((Width - Radius) * .5 + 8, (Height - Radius * .7) * .5 + 5, Radius - 16, Radius * .7 - 10);

        local tx, ty = StartX + Radius * 1.25, StartY + Radius * .5;
        for k, text in ipairs( stop_text ) do
            local tw = SimpleText(text, "DM.Font", tx, ty, whiteCol, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER);
            tx = tx + tw;

            if stop_keys[k] then
                local tw = SimpleText(stop_keys[k], "DM.Font", tx, ty, goldCol, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER);
                tx = tx + tw;
            end
        end

        NoTexture();
        rpui.ExperimentalStencil(function()
            DrawPoly(Poly);
            render.SetStencilCompareFunction(STENCIL_EQUAL);
            render.SetStencilFailOperation(STENCIL_KEEP);
            SetMaterial(PulseCircle);
            Texture(StartX, StartY + 1, Radius, Radius - 1);
        end);
    end

    local CT, Time = CurTime(), (LocalPlayer:GetNetVar("NextMonsterEat") or 0)
    if is_eating and Time > CT then
        SimpleText(monster_text ..": ".. ba.str.FormatTime(Time - CT), "DM.Font", StartX + Radius*0.5, StartY + Radius + 4, whiteCol, TEXT_ALIGN_CENTER);
    end
end

-----------------------------------

net.Receive('DeathMechanics', DeathMechanics.Network);

-----------------------------------

hook.Add('KeyPress', 'DeathMechanics.KeyPress', DeathMechanics.KeyPress);

-----------------------------------

hook.Add('KeyRelease', 'DeathMechanics.KeyRelease', DeathMechanics.KeyRelease);

-----------------------------------

hook.Add('HUDPaint', 'DeathMechanics.HUDPaint', DeathMechanics.HUD);

-----------------------------------

hook.Add("PlayerButtonUp", "DeathMechanics.PlayerButtonUp", DeathMechanics.PlayerButtonUp);

-----------------------------------

hook.Add( "PrePlayerDraw", "DeathMechanics.RenderOffset", function( ply, flags )
    if not ply.m_dm_originmanipulated and ply:IsInDeathMechanics() then
        local jt = ply:GetJobTable() or {};

        if jt.dm_offset then
            ply.m_dm_originmanipulated = ply:GetManipulateBonePosition( 0 ) or vector_origin;
            ply:ManipulateBonePosition( 0, jt.dm_offset );
        end
    end
end );

hook.Add( "PostPlayerDraw", "DeathMechanics.RenderOffset", function( ply, flags )
    if ply.m_dm_originmanipulated and not ply:IsInDeathMechanics() then
        ply:ManipulateBonePosition( 0, ply.m_dm_originmanipulated );
        ply.m_dm_originmanipulated = nil;
    end
end );

-----------------------------------


DeathMechanicsPublic = DeathMechanicsPublic or {};

net.Receive('DeathMechanics.Broadcast', function(Length)
    local Operation = net.ReadBool();
    local Entity = net.ReadEntity();

    if not (IsValid(Entity) and Entity:IsPlayer()) then return end

    --print("DM: ", Operation, Entity)

    if (Operation) then
        --table.insert(DeathMechanicsPublic, Entity);
        DeathMechanicsPublic[Entity:SteamID()] = true
    else
        --table.RemoveByValue(DeathMechanicsPublic, Entity);
        DeathMechanicsPublic[Entity:SteamID()] = nil
    end
end);

timer.Create('DeathMechanics.CheckInvalidAnimation', 2, 0, function()
    local emote
    local jt
    for k, v in pairs(player.GetAll()) do
        if isfunction(v) or not IsValid(v) then continue end

        emote = v:GetEmoteAction()
        jt = v:GetJobTable() or {}

        if not DeathMechanicsPublic[v:SteamID()] and (emote == 'dm_fall' or emote == 'dm_getup' or (emote == (jt.fall_animation or "?"))) then
            EmoteActions.PlayerAnims[v] = nil
        end
    end
end)
