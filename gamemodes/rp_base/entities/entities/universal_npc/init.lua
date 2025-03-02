AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

util.AddNetworkString("universal_npc")
--[[
function ENT:Initialize()
    self:SetModel("models/Barney.mdl")

        --self:SetHullType(HULL_HUMAN)
        --self:SetHullSizeNormal()
    
        self:PhysicsInit(SOLID_VPHYSICS)
        self:SetMoveType(MOVETYPE_NONE)
        self:SetSolid(SOLID_BBOX)

    self:SetCollisionGroup(COLLISION_GROUP_DEBRIS_TRIGGER)
    self:SetUseType(SIMPLE_USE) 
end
]]--
function ENT:Use(ply)
    if ply.CantUse then return end
    ply.CantUse = true
    timer.Simple(1, function() ply.CantUse = nil end)

    if ply:CantDoAfterNoclip(true) then return end

    local vendor_obj = rp.VendorsNPCs[self:GetVendorName()]
    if vendor_obj and vendor_obj.allowed and not vendor_obj.allowed[ply:Team()] then
        return rp.Notify(ply, NOTIFY_RED, rp.Term(vendor_obj.notAllowedTerm))
    end
    
    net.Start("universal_npc")
        net.WriteUInt(self:EntIndex(), 32)
    net.Send(ply)
end