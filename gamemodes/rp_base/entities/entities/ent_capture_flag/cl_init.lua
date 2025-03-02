include 'shared.lua'

ENT.WindAngle = 10
ENT.WindStrength = 1
ENT.SavedMaterials = {}

local temp
ENT.DrawLeftBubble = function(self)
	temp = rp.Capture.CurrentPoint
	if not temp then return false end
	
	local attacker = temp.isOrg and LocalPlayer():GetOrg() or LocalPlayer():GetAlliance()
	if not attacker or (temp.isOrg and not LocalPlayer():OrgCanCapture() or not temp.isOrg and not LocalPlayer():CanCapture()) then return false end
	
	if not self.StoredBusy or self.StoredBusyTime > CurTime() then
		self.StoredBusy = not rp.Capture.IsPointBusy(temp) and temp.owner ~= attacker and (temp.isOrg or (rp.ConjGet(attacker, temp.owner) ~= CONJ_UNION)) and not rp.Capture.IsBusy(attacker) and not rp.Capture.IsBusy(temp.owner)
		self.StoredBusyTime = CurTime() + 3
	end
	
	if self.StoredBusy then
		return self:GetPos() + Vector(0, 0, 90)
	end
end

local cam_Start3D2D 			= cam.Start3D2D
local cam_End3D2D 				= cam.End3D2D
local draw_SimpleTextOutlined 	= draw.SimpleTextOutlined
local LocalPlayer 				= LocalPlayer
local CurTime 					= CurTime

local color_white 				= Color(245, 245, 245)
local color_black 				= Color(0, 0, 0)

local mesh = mesh
local Vector = Vector
local Color = Color
local m_sin = math.sin
local m_max = math.max
local CurTime = CurTime

local ribbonlen = 2 -- How large each subsection is
local ribbonam = 20 -- How many subsections the flag is split into
local flagwide = 40 -- How wide the flag is
local d_wavespeed = 5 -- How fast it waves
local wavemul = 1.5 -- How big the waves are
local waveam = 0.3  -- How many waves
local umul = 1/ribbonam

local scale_mult = 1.5


local function Vert( pos, normal, u, v )
	mesh.Position( pos )
	mesh.Normal( normal )
	mesh.Color(255,255,255,255)
	mesh.TexCoord( 0, u, v )
	mesh.AdvanceVertex( )
end

local material, wavespeed, mat, ang, wave, wave2, p1, p2, p3, p4

function ENT:ProcessAnimation()
	local progress = 1
	
	if self.Progress then
		if self.TimeRemain > 0 then 
			if self.CurState then
				progress = self.Progress * m_max(0, (self.TimeRemain - CurTime()) / self.TimeDone)
			else 
				progress = 1 - self.Progress * m_max(0, (self.TimeRemain - CurTime()) / self.TimeDone)
			end
		else
			if self.CurState then
				progress = self.Progress
			else 
				progress = 1 - self.Progress
			end
		end
	end
	
	--local cur_seq = 'idle_up' --progress == 0 and 'idle_low' or progress == 1 and 'idle_up' or self.CurState and 'up_to_low' or 'low_to_up'
	
	--if progress > 0 and progress < 1 then
	--	self:SetCycle(self.CurState and (1 - progress) or progress)
	--end
	
	--progress = (1 + math.sin(CurTime() / 2)) / 2
	
	--[[
	if progress > 0.5 then
		cur_seq = 'idle_up'
	else
		cur_seq = 'idle_low'
	end
	
	print(progress)
	
	if self.CurrentSequence ~= cur_seq then
		self.CurrentSequence = cur_seq
		self:ResetSequence(cur_seq)
	end
	
	if progress > 0.5 then
		self:ManipulateBonePosition(1, Vector(0, -200 + progress * 200, 0))
	else
		self:ManipulateBonePosition(1, Vector(0, progress * 200, 0))
	end
	]]
	
	self:ManipulateBonePosition(1, Vector(0, progress * 200 - 100, 0))
	
	--self:ManipulateBonePosition(1, Vector(0, -100 + math.sin(CurTime()) * 100, 0))
	--self:ManipulateBonePosition(1, Vector(0, -100, 0))
	--print(self:GetBonePosition(1))
end

-- LOW:
-- 227.338989 stops
-- 100

-- UP:
-- 173.213989 stops
-- 300

function ENT:DrawFlag()
	material = self.material
	if not material then return end
	
	if self.forced_texture and self.forced_texture ~= material:GetName() then
		self.forced_mat = nil
		self.forced_texture = nil
		
		--print('Resetting forced material', self)
	end
	
	if not self.last_rerender then
		self.last_rerender = CurTime() + 0.1
		
	elseif self.last_rerender < CurTime() and not self.forced_mat then
		self.forced_texture = material:GetName()
		
		self.forced_mat = CreateMaterial('flagmat_' .. self:EntIndex() .. (self.mat_counter or 0), 'VertexLitGeneric', { 
			['$basetexture'] = material:GetName(), 
			['$alphatest'] = 1,
			['$detail'] = material:GetName(), 
			['$detailscale'] = '1', 
			['$detailblendmode'] = '5', 
			['$detailblendfactor'] = 0.1,
		})
		
		self.mat_counter = (self.mat_counter or 0) + 1
	end
	
	if material ~= self.LastMaterial or not self.next_set or self.next_set < CurTime() then
		self.LastMaterial = material
		self.next_set = CurTime() + 2
		self:SetSubMaterial(0, self.IsMaterial and material:GetName() or (self.forced_mat and ('!' .. self.forced_mat:GetName()) or ('!' .. material:GetName())))
	end
end

function ENT:WriteInfo()
	if not rp.Capture.Points[self:GetCapturePoint()] then return end
	rp.Capture.Points[self:GetCapturePoint()].flag_ent = self
end

function ENT:Initialize()
	self.WindAngle 	= math.random(360)
	
	timer.Simple(0, function() 
		self:WriteInfo()
	end)
end

hook.Add("OnReloaded", "rp.Capture.Reloaded", function()
	for k,v in pairs(ents.GetAll()) do
		if v:GetClass() == 'ent_capture_flag' then
			v:WriteInfo()
		end
	end
end)

function ENT:Draw()
	self:DrawModel()
	pos = self:GetPos()
	
	--[[
	if not self.FlagHeight then
		self.FlagHeight = (rp.Capture.Points[self:GetCapturePoint()] and rp.Capture.Points[self:GetCapturePoint()].flag_height or 278) / 278
	end
	]]
	
	if pos:DistToSqr(LocalPlayer():GetPos()) > 5000000 then
		return
	end
	
	self.IsMaterial = false
	
	if self:GetFlagMaterial() and self:GetFlagMaterial() ~= '' then
		if not self.SavedMaterials[self:GetFlagMaterial()] then
			self.SavedMaterials[self:GetFlagMaterial()] = Material(self:GetFlagMaterial())
		end
		
		material = self.SavedMaterials[self:GetFlagMaterial()]
		self.IsMaterial = true
		
	elseif self:GetURL() ~= '' and not self.Rendering and (not self:GetTexture() or self:GetURL() ~= self.LastURL) then
		self:RenderTexture({
			Shader = 'VertexLitGeneric',
			MaterialData = {
				['$model'] = 1,
				['$alphatest'] = 1,
				--['$halflambert'] = 1,
				--['$emissiveBlendEnabled'] = 1,
				--['$detail'] = 1,
				--['$detailblendmode'] = 5,
			}
		}) 
		
	elseif self:GetTexture() then
		material = self:GetTexture()
	end
	
	self.material = material
	
	self:ProcessAnimation() 
	self:DrawFlag() 
end

function ENT:GetTexture()
	if not self.IsOrg then
		return wmat.Get(self:EntIndex())
		
	else
		local mat = rp.orgs.GetBanner(self.OrgName, {
			Shader = 'VertexLitGeneric',
			MaterialData = {
				['$model'] = 1,
				['$alphatest'] = 1,
				--['$halflambert'] = 1,
				--['$emissiveBlendEnabled'] = 1,
				--['$detail'] = 'phoenix_storms/wood',
				--['$detailblendmode'] = 5,
			}
		})

		if mat and self.Rendering then
			self.Rendering = false
			self.last_rerender = nil
		end

		return mat
	end
end

local mVec 					   			   	= FindMetaTable( "Vector" );
local GetNormalized, DistToSqr, Dot		   	= mVec.GetNormalized, mVec.DistToSqr, mVec.Dot;
local EyeVector, EyePos 					= EyeVector, EyePos
local lp

hook.Add('PostDrawTranslucentRenderables', 'rp.Capture.DrawFlags', function()
	if not IsValid(LocalPlayer()) then return end
	
	lp = LocalPlayer():GetPos()
	
	--for k,v in pairs(rp.Capture.Points) do
		--if IsValid(v.flag_ent) and v.flag_ent.material then
			--if not (Dot(EyeVector(), GetNormalized(lp - EyePos())) < 0.3 and DistToSqr(v.flag_ent:GetPos(), lp) <= 3000000) then
			--	continue
			--end
			
			--v.flag_ent:ProcessAnimation()
		--end
	--end
	
	for k,v in pairs(rp.Capture.ClientBoxes or {}) do
		if IsValid(v) then
			if not (Dot(EyeVector(), GetNormalized(lp - EyePos())) < 0.3 and DistToSqr(v:GetPos(), lp) <= 3000000) then
				continue
			end
			
			v:DrawBox() 
		end
	end
end)

net.Receive('Capture.FlagUse', function()
	rp.RunCommand('capture', net.ReadUInt(7)) 
end)
