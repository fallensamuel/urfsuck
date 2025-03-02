ENT.Type 		= 'anim'
ENT.Base 		= "ent_picture"
ENT.PrintName 	= 'Capture Point Flag'
ENT.Author 		= 'SerGun'
ENT.Spawnable 	= true
ENT.Category 	= 'RP'

ENT.AutomaticFrameAdvance = true
ENT.AdminOnly = true

function ENT:SetupDataTables()
	self:NetworkVar('String', 1, 'URL')
	self:NetworkVar('String', 2, 'FlagMaterial')
	self:NetworkVar('Int', 1, 'CapturePoint')
end
