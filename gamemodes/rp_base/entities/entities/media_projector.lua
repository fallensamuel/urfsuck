AddCSLuaFile()
ENT.Base = 'media_base'
ENT.PrintName = 'Projector'
ENT.Category = 'RP Media'
ENT.Spawnable = true
ENT.RemoveOnJobChange = true
ENT.Model = 'models/props_lab/reciever01b.mdl'

if (SERVER) then
	function ENT:CanUse(pl)
		return pl:IsSuperAdmin() or (pl:Team() == TEAM_CINEMAOWNER)
	end

	hook.Add('InitPostEntity', 'theater.InitPostEntity', function()
		if !rp.cfg.Theaters[game.GetMap()] or not rp.cfg.Theaters[game.GetMap()].Projector then return end
		local proj = ents.Create('media_projector')
		proj:SafeSetPos(rp.cfg.Theaters[game.GetMap()].Projector.Pos)
		proj:SetAngles(rp.cfg.Theaters[game.GetMap()].Projector.Ang)
		proj:Spawn()
		proj:SetMoveType(MOVETYPE_NONE)
	end)
else
	function ENT:Draw()
		self:DrawModel()
	end

	local proj
	
	if not rp.cfg.Theaters or not rp.cfg.Theaters[game.GetMap()] then return end
	local dat = rp.cfg.Theaters[game.GetMap()].Screen
	hook.Add('PostDrawOpaqueRenderables', 'theater.PostDrawOpaqueRenderables', function()
		--local dat = rp.cfg.Theaters[game.GetMap()].Screen
		if IsValid(proj) and IsValid(LocalPlayer()) and LocalPlayer():GetPos():Distance(proj:GetPos()) < 450 then
			cam.Start3D2D(dat.Pos, dat.Ang, dat.Scale)
			proj:DrawScreen(-360, 400, 1920, 1080)
			cam.End3D2D()
		else
			proj = ents.FindByClass('media_projector')[1]
		end
	end)
end