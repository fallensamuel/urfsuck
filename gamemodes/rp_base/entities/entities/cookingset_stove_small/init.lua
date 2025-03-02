AddCSLuaFile('cl_init.lua');
AddCSLuaFile('shared.lua');

include('shared.lua');

util.AddNetworkString('CookingsetFoodNet2');
local NetCooldown = 1;

function ENT:Initialize()
    self.Model = 'models/props_rp/stove.mdl';

    self:SetModel(self.Model);

    self:PhysicsInit(SOLID_VPHYSICS);
    self:SetMoveType(MOVETYPE_VPHYSICS);
    self:SetSolid(SOLID_VPHYSICS);

    self:SetCollisionGroup(COLLISION_GROUP_WEAPON);

    local Physics = self:GetPhysicsObject();
    if (IsValid(Physics)) then Physics:Wake(); end

    self.Recipes = rp.cfg.CookFoodRecipes or {};
    self.NetCooldown = CurTime();

    self:SetPercentage(-1);
    self:SetRecipe('None');
end

function ENT:Use(Activator, Caller)
    if (self.NetCooldown > CurTime()) then return end

    if (IsValid(Activator) and Activator:IsPlayer()) then
        net.Start('CookingsetFoodNet2');
            net.WriteString(self:GetCreationID());
            net.WriteEntity(self);
        net.Send(Activator);

        self.NetCooldown = CurTime() + NetCooldown;
    end
end

function ENT:Think()

end

local MCeil = math.ceil;
local TRepsLeft = timer.RepsLeft;

function ENT:StartCooking(Recipe)
    if ((self:GetPercentage() or 0) != -1) then return end
    if (!self.Recipes[Recipe]) then return end

    self:EmitSound('buttons/button4.wav');

    Recipe = self.Recipes[Recipe];
    self._Recipe = Recipe;
    local Timer = 'cookingset_' .. self:GetCreationID();
    local Left;

    self:SetRecipe(Recipe.Name or 'Invalid Name');

    self:SetBodygroup(0, Recipe.Bodygroup or 1);
    self:SetPercentage(0);

    timer.Remove(Timer);
    timer.Create(Timer, 1, Recipe.Time or 1, function()
        Left = TRepsLeft(Timer);

        if (!IsValid(self)) then timer.Remove(Timer); return end
        self:SetPercentage(MCeil(100 - (100 * Left / (Recipe.Time or 1))));

        if (Left == 0) then
            self:EndCooking();
        end
    end);
end

function ENT:EndCooking()
    self:EmitSound('buttons/button6.wav');
    self:SetPercentage(-2);
end

function ENT:TakeFood(Player)
    if (!IsValid(Player)) then return end

    local UItem, Count = self._Recipe.Item, self._Recipe.Count;

    local targetPlyInv = Player:getInv();
    local itemBase = rp.item.list[UItem];
    local item = rp.item.instances[UItem];

    local x, y, bagInv = targetPlyInv:findEmptySlot(itemBase.width, itemBase.height);
    if !x and !y then return Player:Notify(1, "У Вас нет места в инвентаре!"); end
    
    targetPlyInv:add(UItem, Count);
    Player:Notify(2, "Вы забрали " .. Count .. " шт. " .. self._Recipe.Name .. ' из ' .. self.PrintName .. '.');

    self:SetPercentage(-1);
    self:SetRecipe('None');

    self:SetBodygroup(0, 0);
    self:EmitSound('buttons/button4.wav');
end

net.Receive('CookingsetFoodNet2', function(Length, Player)
    if (!IsValid(Player) or !Player:IsPlayer()) then return end

    local CreationID = net.ReadString();
    local Recipe = net.ReadUInt(8);

    CreationID = tonumber(CreationID);

    for Index, Entity in pairs(ents.FindByClass('cookingset_stove_small')) do 
        if (IsValid(Entity) and Entity:GetCreationID() == CreationID) then
            if (rp.pp.PlayerCanManipulate(Player, Entity)) then
                if (Recipe == 231) then
                    timer.Remove('cookingset_' .. Entity:GetCreationID());
                    Entity:SetRecipe('None');
                    Entity:SetPercentage(-1);
                    return
                end

                if (Recipe == 230) then
                    timer.Remove('cookingset_' .. Entity:GetCreationID());
                    Entity:TakeFood(Player);
                    return
                end

                Entity:StartCooking(Recipe);
                return
            end
        end
    end
end);