local Material = Material('color');

local Players = {};
local Sounds = {
    'npc/zombie/zombie_pain1.wav',
    'npc/zombie/zombie_pain2.wav',
    'npc/zombie/zombie_pain3.wav',
    'npc/zombie/zombie_pain4.wav',
    'npc/zombie/zombie_pain5.wav',
    'npc/zombie/zombie_pain6.wav'
};

local Cooldown = false;
local Radius = rp.cfg.ZombieMRadius or 4096;
local Delay1 = rp.cfg.ZombieMDelay1 or 30;
local Delay2 = rp.cfg.ZombieMDelay2 or 10;

local Multiply = 1;
hook.Add('PlayerBindPress', 'ZombieWallViewBind', function(Player, Bind, Pressed)
    if (Player != LocalPlayer()) then return end
    if ((LocalPlayer():GetFaction() or 1) != FACTION_ZOMBIE) then return end

    if (Bind == '+reload' and Pressed and !Cooldown) then
        table.Empty(Players);
        for k, v in pairs(ents.FindInSphere(LocalPlayer():GetPos(), Radius)) do
            if (IsValid(v) and v:IsPlayer() and v != LocalPlayer()) then
                table.insert(Players, v);
            end
        end

        Multiply = 1;
        surface.PlaySound(table.Random(Sounds));

        if (#Players == 0) then
            rp.Notify(NOTIFY_GENERIC, 'Вы не учуяли след ни одного игрока.');
            Multiply = .5;
        else

        end

        rp.Notify(NOTIFY_GREEN, 'Вы учуяли ' .. #Players .. ' игроков рядом с собой.');

        Cooldown = CurTime() + (Delay1 * Multiply);

        if (Multiply == 1) then
            timer.Simple(Delay2, function() 
                table.Empty(Players);
                rp.Notify(NOTIFY_GENERIC, 'Вы потеряли след игроков.');
            end);
        end

        timer.Simple(Delay1 * Multiply, function()
            Cooldown = false;
        end);
    elseif (Bind == '+reload' and Pressed and Cooldown) then
        rp.Notify(NOTIFY_ERROR, 'Подождите ' .. math.ceil(Cooldown - CurTime()) .. ' сек, чтобы это сделать!');
    end
end);

local L;
hook.Add('PostDrawOpaqueRenderables', 'ZombieWallView', function() 
    if (Cooldown and #Players == 0) then return end
    if ((LocalPlayer():GetFaction() or 1) != FACTION_ZOMBIE) then return end

    L = LocalPlayer();

    render.ClearStencil();
    render.SetStencilEnable(true);
    render.SetStencilFailOperation(STENCILOPERATION_INCR);
    render.SetStencilZFailOperation(STENCILOPERATION_INCR);
    render.SetStencilPassOperation(STENCILOPERATION_KEEP);
    render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_ALWAYS);
    
    for _, Player in pairs(Players) do
        //if (L:IsLineOfSightClear(Player)) then continue end
		if not IsValid(Player) then continue end
        Player:DrawModel();
    end 
    
    render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_EQUAL);
    render.SetStencilReferenceValue(1);
    render.SetMaterial(Material);
    render.DrawScreenQuad();
    render.SetStencilEnable(false);
end )