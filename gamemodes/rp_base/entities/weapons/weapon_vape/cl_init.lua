cvar.Register'smoke_disable':SetDefault(false):AddMetadata('State', 'RPMenu'):AddMetadata('Menu', 'Выключить дым от электронный сигареты (повышает FPS)')


--VAPE SWEP \//\ by Swamp Onions - http://steamcommunity.com/id/swamponions/

include('shared.lua')

SWEP.PrintName          = "Vape"
SWEP.Slot               = 1
SWEP.SlotPos            = 1
SWEP.DrawAmmo           = false
SWEP.DrawCrosshair      = false

local colorTable = SWEP.ColorTable

local cough = {Sound('ambient/voices/cough1.wav'), Sound('ambient/voices/cough2.wav'), Sound('ambient/voices/cough3.wav'), Sound('ambient/voices/cough4.wav')}

local emitter = ParticleEmitter(Vector(0,0,0))

function SWEP:DrawWorldModel()
	local ply = self:GetOwner()

	if IsValid(ply) then
		local bn = ply:GetModel():sub(1,17)=="models/ppm/player" and "LrigScull" or "ValveBiped.Bip01_R_Hand"
		if ply.vapeArmFullyUp then bn ="ValveBiped.Bip01_Head1" end
		local bon = ply:LookupBone(bn) or 0

		local opos = self:GetPos()
		local oang = self:GetAngles()
		local bp,ba = ply:GetBonePosition(bon)
		if bp then opos = bp end
		if ba then oang = ba end

		--pony compatibility
		if ply:GetModel():sub(1,17)=="models/ppm/player" then
			opos = opos + (oang:Forward()*17.2) + (oang:Right()*-4) + (oang:Up()*-2.5)
			oang:RotateAroundAxis(oang:Right(),80)
			oang:RotateAroundAxis(oang:Forward(),12)
		else
			if ply.vapeArmFullyUp then
				opos = opos + (oang:Forward()*0.7) + (oang:Right()*15) + (oang:Up()*2)
				oang:RotateAroundAxis(oang:Forward(),-100)
				oang:RotateAroundAxis(oang:Up(),90)
			else
			oang:RotateAroundAxis(oang:Forward(),90)
			oang:RotateAroundAxis(oang:Right(),90)
			opos = opos + oang:Forward()*2 + oang:Up()*-4.5 + oang:Right()*-2
			oang:RotateAroundAxis(oang:Forward(),69)
			end
		end
		self:SetupBones()

		self:SetModelScale(0.8,0)
		local mrt = self:GetBoneMatrix(0)
		if mrt then
		mrt:SetTranslation(opos)
		mrt:SetAngles(oang)

		self:SetBoneMatrix(0, mrt )
		end
		self:SetColor(colorTable[ply:GetNWInt('vapeColor', 1)])
	end
	self:DrawModel()
end

function SWEP:GetViewModelPosition(pos, ang)
	if not LocalPlayer().vapeArmTime then LocalPlayer().vapeArmTime=0 end
	local lerp = math.Clamp((os.clock()-LocalPlayer().vapeArmTime)*3,0,1)
	if LocalPlayer().vapeArm then lerp = 1-lerp end
	pos,ang = LocalToWorld(LerpVector(lerp,Vector(22,-4.5,-3),Vector(30,-10,-12)),LerpAngle(lerp,Angle(200,-100,80),Angle(200,-100,120)),pos,ang)
	return pos, ang
end

local function vapecloud_init(particle, vel, color)
	particle:SetColor(color.r, color.g, color.b, 255)

	--uncomment for rainbow clouds
	--local c = HSVToColor( math.random(0,359),1,1 )
	--particle:SetColor(c.r,c.g,c.b,255)
	
	particle:SetVelocity( vel )
	particle:SetGravity( Vector(0,0,1.5) )
	particle:SetLifeTime(0)
	particle:SetDieTime(math.Rand(80,100)*0.11)
	particle:SetStartSize(2)
	particle:SetEndSize(40)
	particle:SetStartAlpha(150)
	particle:SetEndAlpha(0)
	particle:SetCollide(true)
	particle:SetBounce(0.25)
	particle:SetRoll(math.Rand(0,360))
	particle:SetRollDelta(0.01*math.Rand(-40,40))
	particle:SetAirResistance(50)
end

--I dont actually know what a vape sounds like lol
sound.Add({
	name = "vapein",
	channel = CHAN_WEAPON,
	volume = 0.7,
	level = 60,
	pitch = { 170 },
	sound = "npc/ichthyosaur/water_breath.wav"
})


local function interpolateVapeArm(ply,b1,b2, mult)
	if !IsValid(ply) then return end

	ply:ManipulateBoneAngles(b1,Angle(20*mult,-62*mult,10*mult))
	ply:ManipulateBoneAngles(b2,Angle(-5*mult,-10*mult,0))

	ply.vapeArmFullyUp= mult == 1
end

net.Receive("VapeStart", function()
	local ply = net.ReadEntity()
	if !IsValid(ply) then return end 

	timer.Simple(0.3, function() 
		if !IsValid(ply) then return end 
		ply:EmitSound("vapein")
	end)

	if ply == LocalPlayer() then
		ply.vapeArm = true
		ply.vapeArmTime = os.clock()
	end

	for i=0,9 do
		local b1 = ply:LookupBone("ValveBiped.Bip01_R_Upperarm")
		local b2 = ply:LookupBone("ValveBiped.Bip01_R_Forearm")
		if (not b1) or (not b2) then return end
		timer.Simple(i/30,function() interpolateVapeArm(ply,b1,b2,math.abs(1-((9-i)/10))) end)
	end
end)

local function vape_pulse(ply,amt,spreadadd)
	if !IsValid(ply) then return end

	if not spreadadd then spreadadd=0 end

	local attachid = ply:LookupAttachment("eyes")
	emitter:SetPos(LocalPlayer():GetPos())
	
	local angpos = ply:GetAttachment(attachid) or {Pos = ply:GetPos() + Vector(0, 0, 64), Ang = Angle(0,0,0)}
	local fwd
	local pos
	
	if (ply != LocalPlayer()) then
		fwd = (angpos.Ang:Forward()-angpos.Ang:Up()):GetNormalized()
		pos = angpos.Pos + (fwd*3.5)
	else
		fwd = ply:GetAimVector():GetNormalized()
		pos = ply:GetShootPos() + fwd*1.5 + gui.ScreenToVector( ScrW()/2, ScrH() )*5
	end

	fwd = ply:GetAimVector():GetNormalized()

	for i = 1,amt do
		if !IsValid(ply) then return end
		local color = colorTable[ply:GetNWInt('vapeColor', 1)]
		local particle = emitter:Add( string.format("particle/smokesprites_00%02d",math.random(7,16)), pos )
		if particle then
			local dir = VectorRand():GetNormalized() * ((amt+5)/10)
			vapecloud_init(particle, (ply:GetVelocity()*0.25)+(((fwd*9)+dir):GetNormalized() * math.Rand(50,80) * (amt + 1) * 0.2), color)
		end
	end
end

net.Receive("VapeEnd", function()
	local ply = net.ReadEntity()
	local amt = net.ReadInt(8)

	if !IsValid(ply) then return end
	ply:StopSound("vapein")

	if ply == LocalPlayer() then
		ply.vapeArm = false
		ply.vapeArmTime = os.clock()
	end
	
	for i=0,9 do
		local b1 = ply:LookupBone("ValveBiped.Bip01_R_Upperarm")
		local b2 = ply:LookupBone("ValveBiped.Bip01_R_Forearm")
		if (not b1) or (not b2) then return end
		timer.Simple(i/30,function() interpolateVapeArm(ply,b1,b2,math.abs(0-((9-i)/10))) end)
	end

	if !cvar.GetValue('smoke_disable') then
		if amt>=50 then
			ply:EmitSound(table.Random(cough),90)

			for i=1,200 do
				local d=i+10
				if i>140 then d=d+150 end
				timer.Simple((d-1)*0.003,function() vape_pulse(ply, 1, 100) end)
			end

			return
		elseif amt>=35 then
			ply:EmitSound("vapebreath2.wav",75,100,0.7)
		elseif amt>=10 then
			ply:EmitSound("vapebreath1.wav",70,130-math.min(100,amt*2),0.4+(amt*0.005))
		end

		for i=1,amt*2 do
			timer.Simple((i-1)*0.02,function() vape_pulse(ply,math.floor(((amt*2)-i)/10)) end)
		end
	end
end)

function SWEP:Holster()
	if !IsValid(self.Owner) then return end
	local vm = self.Owner:GetViewModel()
	if IsValid(vm) then
		vm:SetColor(Color(255, 255, 255, 255))
	end
end

function SWEP:OnRemove()
	self:Holster()
end

function SWEP:SetCanChangeColor()
	self.canChangeColor = true
end