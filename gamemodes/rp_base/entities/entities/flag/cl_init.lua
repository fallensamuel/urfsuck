include("shared.lua")

ENT.WindAngle = 10
ENT.WindStrength = 1

local mesh = mesh
local math = math
local Vector = Vector

local function Vert( pos, normal, u, v )
	mesh.Position( pos )
	mesh.Normal( normal )
	mesh.Color(255,255,255,255)
	mesh.TexCoord( 0, u, v )
	mesh.AdvanceVertex( )
end

local function Norm( p1, p2, p3 )
	local a = Vector(
		p3.x - p2.x,
		p3.y - p2.y,
		p3.z - p2.z
	)

	local b = Vector(
		p1.x - p2.x,
		p1.y - p2.y,
		p1.z - p2.z
	)

	local norm = Vector(
		(a.y * b.z) - (a.z * b.y),
		(a.z * b.x) - (a.x * b.z),
		(a.x * b.y) - (a.y * b.x)
	)
	norm:Normalize()

	return norm
end

local function AddNorms( n1, n2 )
	return (n1 + n2):GetNormal()
end

local ribbonlen = 2 -- How large each subsection is
local ribbonam = 20 -- How many subsections the flag is split into
local flagwide = 40 -- How wide the flag is
local d_wavespeed = 5 -- How fast it waves
local wavemul = 1.5 -- How big the waves are
local waveam = 0.3  -- How many waves
local umul = 1/ribbonam


function ENT:DrawFlag()
	local material = self:GetTexture()

	local wavespeed = d_wavespeed * self.WindStrength

	local mat = Matrix()
	mat:SetTranslation(self:GetPos() + self:GetUp() * 108)
	mat:SetScale(Vector(1,1,1))

	local ang = self:GetAngles()
	ang:RotateAroundAxis(ang:Right(), 90)
	ang:RotateAroundAxis(ang:Up(), 90)
	ang:RotateAroundAxis(ang:Right(), self.WindAngle - self:GetAngles().y)
	mat:SetAngles(ang)

	render.SuppressEngineLighting(true)
	render.SetMaterial(material)

	cam.PushModelMatrix(mat)
		mesh.Begin(MATERIAL_TRIANGLES, ribbonam * 2 * 2)
			for i=0,ribbonam-1 do
				local wave = math.sin(-CurTime() * wavespeed + i * waveam) * wavemul
				if i == 0 then
					wave = 0
				end

				local wave2 = math.sin(-CurTime() * wavespeed + (i + 1) * waveam) * wavemul

				local p1 = Vector(i * ribbonlen, 0, wave)
				local p2 = Vector((i + 1) * ribbonlen, 0, wave2)
				local p3 = Vector((i + 1) * ribbonlen, flagwide, wave2)
				local p4 = Vector(i * ribbonlen, flagwide, wave)

				--Normal shit
				--[[local wave3 = math.sin(-CurTime() * wavespeed + (i-1) * waveam) * wavemul
				local wave4 = math.sin(-CurTime() * wavespeed + (i + 2) * waveam) * wavemul

				local normprev = vector_up
				if i > 0 then
					normprev = Norm( p1, p4, Vector((i-1) * ribbonlen, 0, wave3) )
				end
				local norm = Norm( p1, p2, p3 )
				local normnext = Norm( p2, p3, Vector((i + 2) * ribbonlen, 0, wave4) )

				--Front
				Vert(p1, -AddNorms(normprev, norm), umul * i,     0)
				Vert(p2, -AddNorms(norm, normnext), umul * (i + 1), 0)
				Vert(p3, -AddNorms(norm, normnext), umul * (i + 1), 1)

				Vert(p3, -AddNorms(norm, normnext), umul * (i + 1), 1)
				Vert(p4, -AddNorms(normprev, norm), umul * i,     1)
				Vert(p1, -AddNorms(normprev, norm), umul * i,     0)--]]
				Vert(p1, -vector_up, umul * i,       0)
				Vert(p2, -vector_up, umul * (i + 1), 0)
				Vert(p3, -vector_up, umul * (i + 1), 1)

				Vert(p3, -vector_up, umul * (i + 1), 1)
				Vert(p4, -vector_up, umul * i,       1)
				Vert(p1, -vector_up, umul * i,       0)

				--Back
				Vert(p3, vector_up,  1 - umul * (i + 1), 1)
				Vert(p2, vector_up,  1 - umul * (i + 1), 0)
				Vert(p1, vector_up,  1 - umul * i,       0)

				Vert(p1, vector_up,  1 - umul * i,       0)
				Vert(p4, vector_up,  1 - umul * i,       1)
				Vert(p3, vector_up,  1 - umul * (i + 1), 1)
			end
		mesh.End()
	cam.PopModelMatrix()
	render.SuppressEngineLighting(false)
end

local function ColVecToCol(vec)
	return Color(vec.x, vec.y, vec.z)
end


function ENT:Draw()
	self:SetRenderBounds(Vector(-50,-50,0),Vector(50,50,120))
	self:DrawModel()
	if (cvar.GetValue('enable_pictureframes') == false) then return end

	if (not self:GetTexture() and not self.Rendering) or (self:GetURL() ~= self.LastURL and not self.Rendering) then
		self:RenderTexture()
	elseif self:GetTexture() then
		self:DrawFlag()
	end
	
end

function ENT:Initialize()
	
end
