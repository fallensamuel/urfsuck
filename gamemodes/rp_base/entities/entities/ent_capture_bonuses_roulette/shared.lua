-- "gamemodes\\rp_base\\entities\\entities\\ent_capture_bonuses_roulette\\shared.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local BaseClass = baseclass.Get( "base_urf_itemroulette" );

ENT.PrintName       = "Capture Bonuses Box";
ENT.Category        = "RP Item Roulettes";
ENT.Spawnable       = true;
ENT.AdminOnly       = true;

ENT.IsCaptureBonus 	= true

function ENT:SetupDataTables()
	self:NetworkVar( "Int", 0, "CapturePoint" );
	self:NetworkVar( "Int", 1, "BoxId" );
end


function ENT:Setup()
	local data = rp.Capture.Points[self:GetCapturePoint()].Boxes[self:GetBoxId()];

	if data.items then
		self:SetItemPool( data.items );
	end

	if CLIENT then
		self:SetPrintName( data.printName );
	end
end


function ENT:HasAccess( ply )
	if
        not IsValid( ply ) or
        not self:GetCapturePoint() or
        not rp.Capture.Points[self:GetCapturePoint()] or
        rp.Capture.Points[self:GetCapturePoint()].isWar
    then
		return false
	end
	
	local p_owner = rp.Capture.Points[self:GetCapturePoint()].owner;
	
	if not p_owner then
		return false
	end
	
	return p_owner == ply:GetOrg() or
           p_owner == ply:GetAlliance() or
           ply:GetAlliance() and
           not isnumber( p_owner ) and
           rp.ConjGet( p_owner, ply:GetAlliance() ) == CONJ_UNION
end