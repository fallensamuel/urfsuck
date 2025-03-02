AddCSLuaFile()
	ENT.Type = "anim"
	ENT.PrintName = "Маленькое информ табло"
	ENT.Author = "Black Tea"
	ENT.Spawnable = true
	ENT.AdminOnly = true
	ENT.Category = "Black Tea"
	ENT.RenderGroup 		= RENDERGROUP_BOTH

	if CLIENT then
		function ENT:Initialize()
		end
	
		function ENT:Draw()
			self:DrawModel()
		end
	
		local scale = .5
		local sx, sy = 90, 90
		local distance = 1000
		function ENT:DrawTranslucent()
			local pos, ang = self:GetPos(), self:GetAngles()
			pos = pos + self:GetUp()*-1.8
			pos = pos + self:GetForward()*10.6
			
			if not self.gear_pixvis then self.gear_pixvis = util.GetPixelVisibleHandle() end
			local alpha = util.PixelVisible(pos, self:BoundingRadius()*.1, self.gear_pixvis)
			if alpha <= 0 then return end
			local rt = RealTime()
			ang:RotateAroundAxis( self:GetUp(), 90 )
			ang:RotateAroundAxis( self:GetRight(), -90 )
	
			local up = self:GetUp()
			local right = self:GetRight()
			local forward = self:GetForward()
	
			local ch = up*sy*0.5*scale
			local cw = right*sx*0.5*scale
			local dist = LocalPlayer():GetPos():Distance(pos)
			local distalpha = math.Clamp(distance-dist, 0, 255)*alpha
			
			local text = self:GetNWString("text", "This Noti-Board is not assigned yet.")
			local title = self:GetNWString("title", "A Noti-Board")
	
			if dist <= distance then
				render.PushCustomClipPlane(up, up:Dot( pos-ch ))
				render.PushCustomClipPlane(-up, (-up):Dot( pos+ch ))
				render.PushCustomClipPlane(right, right:Dot( pos-cw ))
				render.PushCustomClipPlane(-right, (-right):Dot( pos+cw ))
				render.EnableClipping( true )
	
					cam.Start3D2D(pos, ang, scale)
						surface.SetDrawColor(22, 22, 22, 255)
						surface.DrawRect(-sx/2, -sy/2, sx, sy)
					
						surface.SetTextColor(self:GetColor().r, self:GetColor().g, self:GetColor().b, distalpha)
						surface.SetFont("NotiBoardTitle")
						local tx, ty = surface.GetTextSize(text)
						local tposx, tposy = sx/2-((RealTime()*100)%(tx+sx)),-ty/2
						surface.SetTextPos(tposx, tposy)
						surface.DrawText(text)
						surface.SetFont("NotiBoardTitle2")
						surface.SetTextPos(tposx, tposy)
						surface.DrawText(text)
				cam.End3D2D()
	
				render.PopCustomClipPlane()
				render.PopCustomClipPlane()
				render.PopCustomClipPlane()
				render.PopCustomClipPlane()
				render.EnableClipping( false )
			end
		end
	
	else
		
		function ENT:Initialize()
			self:SetModel("models/props_trainstation/tracksign08.mdl")
			self:PhysicsInit(SOLID_VPHYSICS)
			self:SetMoveType(MOVETYPE_VPHYSICS)
			self:SetUseType(SIMPLE_USE)
			self:SetColor(Color(200,200,200))
				
			local physicsObject = self:GetPhysicsObject()
			if (IsValid(physicsObject)) then
				physicsObject:Wake()
			end
		end
	
		function ENT:OnRemove()
		end
		
		function ENT:Setowning_ent(client)
			if self.CPPISetOwner then
				self:CPPISetOwner(client)
			end
			self.Owner = client
		end

		function ENT:GetNotiOwner(activator)
			if (!self.Owner:IsValid()) then
				if self.CPPIGetOwner then
					local a, b = self:CPPIGetOwner()
					self.Owner = a
					return self.Owner
				end

				if (engine.ActiveGamemode() == "sandbox") then
					self.Owner = activator
				else
					if (activator:IsAdmin()) then
						self.Owner = activator
					end
				end
			end
		
			return self.Owner
		end
		
		function ENT:Use(client)
			if (self:GetNotiOwner(client) == client) then
				net.Start("NotiOwnerSimple")
				net.Send(client)
				client.tBoard = self
			end
		end
	
	end