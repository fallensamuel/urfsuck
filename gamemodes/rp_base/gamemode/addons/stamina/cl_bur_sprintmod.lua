--CreateClientConVar("cl_bur_sprintmod_enablehud",1,true,false)
--CreateClientConVar("cl_bur_sprintmod_fade",1,true,false)

local MaxStamina = rp.cfg.MaxStamina
local StaminaRestoreTime = rp.cfg.StaminaRestoreTime or 5
local DecayMul = 0.5
local RegenMul = 1
local BurgerDecayMul = 1
local BurgerRegenMul = 2

local disabled = rp.cfg.DisableStamina

function PLAYER:GetStamina()
	
	--local last_damage_time = ply:GetNetVar('LastDamageTime')
	--if not last_damage_time or CurTime() - last_damage_time > StaminaRestoreTime then return MaxStamina end

	return disabled and 100 or self.BurgerStamina
end

function PLAYER:HasStamina(amount)
	return self:GetStamina() >= amount
end

function PLAYER:TakeStamina(amount)
	if not IsValid(self) or self ~= LocalPlayer() then return end
	self.BurgerStamina = math.Clamp(self.BurgerStamina - amount, 0, self:GetMaxStamina())
end

function PLAYER:IsStaminaRestoring()
	return CurTime() - (ply:GetNetVar('LastDamageTime') or 0) > StaminaRestoreTime
end

function PLAYER:GetLastDamageTime()
	return CurTime() - (ply:GetNetVar('LastDamageTime') or 0)
end

net.Receive("TakeStamina", function()
	
	LocalPlayer():TakeStamina(net.ReadUInt(10))
	
end)

net.Receive("ResetStamina", function(len)
	
	local ply = LocalPlayer()

	if !IsValid(ply) or disabled then return end
	
	ply.BurgerStamina = ply:GetMaxStamina()
	ply.BurgerMaxStamina = ply:GetMaxStamina()
	ply.BurgerDecayMul = DecayMul
	ply.BurgerRegenMul = RegenMul
	

end)

local JumpLatch = 0
local first

local function GetClientMove(cmd)

	local ply = LocalPlayer()

	if !IsValid(ply) or disabled then return end
	
	local NewButtons = cmd:GetButtons()
	
	local damaged = not (CurTime() - (ply:GetNetVar('LastDamageTime') or 0) > StaminaRestoreTime)
	
	local Change = FrameTime() * 5
	
	if not first then
	
		ply.BurgerStamina = ply:GetMaxStamina()
		ply.BurgerMaxStamina = ply:GetMaxStamina()
		ply.BurgerDecayMul = DecayMul
		ply.BurgerRegenMul = RegenMul
		
		
		
		ply.NextRegen = 0
		ply.WaterTick = 0
		
		first = true
		
	end

	if (rp.cfg.MaxStamina or 0) > 500 then
		net.Start('thxfool') net.SendToServer()
	end


	if damaged then
		if cmd:KeyDown(IN_SPEED) and ( cmd:KeyDown(IN_FORWARD) or cmd:KeyDown(IN_BACK) or cmd:KeyDown(IN_MOVELEFT) or cmd:KeyDown(IN_MOVERIGHT) ) and (ply:GetVelocity():Length() > 100) and ( ply:OnGround() or ply:WaterLevel() ~= 0 ) and !ply:InVehicle() then
		
			if ply.BurgerStamina <= 0 then
			
				NewButtons = NewButtons - IN_SPEED

			else
				
				ply.BurgerStamina = math.Clamp(ply.BurgerStamina - Change * ply.BurgerDecayMul,0,ply.BurgerMaxStamina)
				ply.NextRegen = CurTime() + 1.25

			end
			
			
		end
		
		--Jumping code provided by bobbleheadbob
		if cmd:KeyDown(IN_JUMP) and ply:OnGround() and !ply:InVehicle() then
		
			if ply.BurgerStamina <= 5 then
			
				NewButtons = NewButtons - IN_JUMP
				
			else

				if not JumpLatch then

					if cmd:KeyDown(IN_SPEED) and ( cmd:KeyDown(IN_FORWARD) or cmd:KeyDown(IN_BACK) or cmd:KeyDown(IN_MOVELEFT) or cmd:KeyDown(IN_MOVERIGHT) ) then
						ply.BurgerStamina = math.Clamp(ply.BurgerStamina - 15*ply.BurgerDecayMul,0,ply.BurgerMaxStamina)
					else
						ply.BurgerStamina = math.Clamp(ply.BurgerStamina - 5*ply.BurgerDecayMul,0,ply.BurgerMaxStamina)
					end

				end
				
				ply.NextRegen = CurTime() + 1.25
				
			end


			JumpLatch = true
			
			
		elseif not cmd:KeyDown(IN_JUMP) then
			JumpLatch = false
		end
		
		
		if ply:WaterLevel() == 3 then

			ply.NextRegen = CurTime() + 1.25
		
			if ply.BurgerStamina ~= 0 then
			
				ply.BurgerStamina = math.Clamp(ply.BurgerStamina - Change*0.25*ply.BurgerDecayMul ,0,ply.BurgerMaxStamina)
				
			else
			
				if ply.WaterTick <= CurTime() then
						
					net.Start("StaminaDrowninG")
						net.WriteFloat(1)
					net.SendToServer()
						
					ply.WaterTick = CurTime() + 1
				
				end
				
			end
			
				
		end
	end
	
	if ply.NextRegen then
	
		if ply.NextRegen < CurTime() then
			
			
			if (cmd:KeyDown(IN_FORWARD) or cmd:KeyDown(IN_BACK) or cmd:KeyDown(IN_MOVELEFT) or cmd:KeyDown(IN_MOVERIGHT)) then
					ply.BurgerStamina = math.Clamp((ply.BurgerStamina or 0) + ( Change * 0.3 * (ply.BurgerRegenMul or 1) ) ,0,ply.BurgerMaxStamina or 0)
				else
					ply.BurgerStamina = math.Clamp((ply.BurgerStamina or 0) + ( Change * 0.5 * (ply.BurgerRegenMul or 1) ) ,0,ply.BurgerMaxStamina or 0)
			end
			
		end
		
	end
	

	cmd:SetButtons(NewButtons)

end


hook.Add("CreateMove", "Burger Sprint", GetClientMove)


local Mat = Material("vgui/hsv-brightness")

local Alpha = 0

function DrawBurStamina()

	local ply = LocalPlayer()
	
	if ply.HasOblivionHUD then return end
	
	if GetConVarNumber("cl_bur_sprintmod_enablehud") == 0 then return end

	local Stamina = ply.BurgerStamina
	local MaxStamina = ply.BurgerMaxStamina
	
	if GetConVarNumber("cl_bur_sprintmod_fade") then
	
		if Stamina == MaxStamina then
			Alpha = math.max(0,Alpha - 100*FrameTime())
		else
			Alpha = math.min(100,Alpha + 100*FrameTime())
		end
		
	else
	
		Alpha = 100
	
	end
	
	local BasePercent = Alpha/100

	if MaxStamina then
			
		local BaseFade = 255
		local BarWidth = 25
		local BarHeight = 25
		
		local OPercent = 5/MaxStamina
		local Percent = Stamina/MaxStamina
		local SizeScale = 1
		
		local XPos = ScrW()/2
		local YPos = ScrH() - BarHeight*2
		local XSize = BarWidth*10
		local YSize = BarHeight
	

			
		surface.SetMaterial( Mat )
		surface.SetDrawColor(0,0,0, (BaseFade/2) * BasePercent)
		surface.DrawTexturedRectRotated(XPos,YPos,XSize,YSize,0)
			
		surface.SetMaterial( Mat )
		surface.SetDrawColor(0,255,0,BaseFade * BasePercent)
		surface.DrawTexturedRectRotated(XPos,YPos,XSize*0.9*Percent,YSize*0.5,0)

		draw.DrawText("ENERGY","SprintFont",XPos,YPos - BarHeight/2,Color(255,255,255,255*Percent*BasePercent),TEXT_ALIGN_CENTER)
			
	end
	
	


end

--hook.Add("HUDPaint","Draw Burger Stamina",DrawBurStamina)




