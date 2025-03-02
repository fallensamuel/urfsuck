ENT.Type 		= 'anim'
ENT.Base 		= 'base_anim'
ENT.PrintName 	= 'Capture Bonuses Box'
ENT.Author 		= 'SerGun'
ENT.Spawnable 	= true
ENT.Category 	= 'RP'

ENT.AdminOnly = true

ENT.AutomaticFrameAdvance = true

ENT.ReuseTimeout = 60 * 5


function ENT:SetupDataTables()
	self:NetworkVar('Int', 1, 'CapturePoint')
	self:NetworkVar('Int', 2, 'BoxId')
end

function ENT:HasAccess(ply)
	if not IsValid(ply) or not self:GetCapturePoint() or not rp.Capture.Points[self:GetCapturePoint()] or rp.Capture.Points[self:GetCapturePoint()].isWar then
		return false
	end
	
	local p_owner = rp.Capture.Points[self:GetCapturePoint()].owner
	
	if not p_owner then 
		return false 
	end
	
	return p_owner == ply:GetOrg() or p_owner == ply:GetAlliance() or ply:GetAlliance() and not isnumber(p_owner) and rp.ConjGet(p_owner, ply:GetAlliance()) == CONJ_UNION
end