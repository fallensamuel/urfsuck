AddCSLuaFile('cl_init.lua')
AddCSLuaFile('shared.lua')
include('shared.lua')
util.AddNetworkString('rp.OpenImageWindow')

function ENT:Initialize()
	self:SetModel('models/hunter/plates/plate1x1.mdl')
	self:SetMaterial('models/debug/debugwhite')
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	self:PhysWake()
	self:SetURL('http://urf.im/urflogo.png')

	timer.Simple(0, function()
		if IsValid(self.ItemOwner) then
			self:CPPISetOwner(self.ItemOwner)
		end
	end)
end

function ENT:Use(pl)
	if (not IsValid(self.ItemOwner) or (self.ItemOwner == pl)) and ((not pl.LastImageUSe) or (pl.LastImageUSe <= CurTime())) and (self:GetPos():Distance(pl:GetPos()) < 110) then
		net.Start('rp.OpenImageWindow')
		net.Send(pl)
		pl.LastImageUSe = CurTime() + 2
	end
end


rp.AddCommand('/setimage', function(pl, text, args)
	local ent = pl:GetEyeTrace().Entity

	if (not args[1]) then
		pl:Notify(NOTIFY_ERROR, rp.Term('InvalidURL'))
	elseif IsValid(ent) and (not IsValid(ent.ItemOwner) or ent.ItemOwner == pl) then
		ent:SetURL(args[1])
	end
end)

rp.AddCommand('/setimageavatar', function(pl, text, args)
	local ent = pl:GetEyeTrace().Entity

	if IsValid(ent) and (not IsValid(ent.ItemOwner) or ent.ItemOwner == pl) then
		ent:SetURL('http://funmania.myarena.ru/rp/static/cache/avatars/' .. pl:SteamID64() .. '.jpg')
	end
end)

rp.AddCommand('/setimageorg', function(pl, text, args)
	local ent = pl:GetEyeTrace().Entity

	if IsValid(ent) and (not IsValid(ent.ItemOwner) or ent.ItemOwner == pl) and pl:GetOrg() then
		ent:SetURL('ORG:' .. pl:GetOrg())
	end
end)