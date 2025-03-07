-- "gamemodes\\rp_base\\entities\\effects\\entity_remove.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal

--[[---------------------------------------------------------
   Initializes the effect. The data is a table of data 
   which was passed from the server.
-----------------------------------------------------------]]
function EFFECT:Init( data )
	
	local TargetEntity = data:GetEntity()
	if ( !TargetEntity || !TargetEntity:IsValid() ) then return end
	
	local vOffset = TargetEntity:GetPos()
	local Low, High = TargetEntity:WorldSpaceAABB()

	local NumParticles = TargetEntity:BoundingRadius()
	NumParticles = NumParticles * 4
	
	NumParticles = math.Clamp( NumParticles, 32, 256 )
		
	local emitter = ParticleEmitter( vOffset )
	
		for i=0, NumParticles do
		
			local vPos = Vector( math.Rand(Low.x,High.x), math.Rand(Low.y,High.y), math.Rand(Low.z,High.z) )
			local particle = emitter:Add( "effects/spark", vPos )
			if (particle) then
			
				particle:SetVelocity( (vPos - vOffset) * 5 )
				particle:SetLifeTime( 0 )
				particle:SetDieTime( math.Rand( 0.5, 1.0 ) )
				particle:SetStartAlpha( math.Rand( 200, 255 ) )
				particle:SetEndAlpha( 0 )
				particle:SetStartSize( 2 )
				particle:SetEndSize( 0 )
				particle:SetRoll( math.Rand(0, 360) )
				particle:SetRollDelta( 0 )
				
				particle:SetAirResistance( 100 )
				particle:SetGravity( Vector( 0, 0, -700 ) )
				particle:SetCollide( true )
				particle:SetBounce( 0.3 )
				
			end
			
		end
		
	emitter:Finish()
	
end


--[[---------------------------------------------------------
   THINK
-----------------------------------------------------------]]
function EFFECT:Think( )
	return false
end

--[[---------------------------------------------------------
   Draw the effect
-----------------------------------------------------------]]
function EFFECT:Render()
end
