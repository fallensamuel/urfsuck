ENT.Type = "anim"
ENT.Base = 'combine_forcefield'
ENT.Spawnable = true
ENT.RenderGroup = RENDERGROUP_BOTH
ENT.PhysgunDisabled = true
ENT.Category = "Half-Life Alyx RP"

local combine_fields = {
    combine_forcefield = function(pl) return pl:IsCombineOrDisguised() or pl:GetJob() == TEAM_MAYOR1 end,
    combine_forcefield_big = function(pl) return pl:IsCombineOrDisguised() or pl:GetJob() == TEAM_MAYOR1 end,
    combine_forcefield_reversed = function(pl) return pl:IsCombineOrDisguised() or pl:GetJob() == TEAM_MAYOR1 end,
    
    combine_forcefield_cwu = function(pl) return pl:IsCombineOrDisguised() or pl:IsCWU() or pl:GetJob() == TEAM_REFERENT or pl:GetJob() == TEAM_MAYOR1 end,
}

local check_combine_apc = function(ent)
    local valid = IsValid(ent)
    local wheel_parent = valid and ent.IsWheelOf

    if valid and ent.IsSpCombineApc then
        return true
    elseif IsValid(wheel_parent) and wheel_parent.IsSpCombineApc then
        return true
    end
end

local npc_hunter = {["npc_hunter"] = true}

hook.Add('ShouldCollide', 'ForcefieldCollide', function(ent1, ent2)
    local ply = IsValid(ent1) and ent1:IsPlayer() and ent1 or IsValid(ent2) and ent2:IsPlayer() and ent2 or false
    local field = IsValid(ent1) and combine_fields[ent1:GetClass()] or IsValid(ent2) and combine_fields[ent2:GetClass()] or false
    
    if ply and field and field(ply) then
        return false
    elseif combine_fields and (check_combine_apc(ent1) or check_combine_apc(ent2)) then
        return false
    elseif combine_fields and (npc_hunter[ent1:GetClass()] or npc_hunter[ent2:GetClass()]) then
        return false
    end
end)


ENT.isForceField = true