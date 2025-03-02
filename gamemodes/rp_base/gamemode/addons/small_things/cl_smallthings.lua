-- "gamemodes\\rp_base\\gamemode\\addons\\small_things\\cl_smallthings.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local pos, update, LocalPlayer = Vector(0, 0, 0), false, LocalPlayer
local mVec = FindMetaTable("Vector")
local DistToSqr = mVec.DistToSqr
function ENTITY:IsNotNeed2Draw(maxdist)
	update = true
	return DistToSqr(self:GetPos(), pos) > maxdist^2
end

hook.Add("Think", "IsNotNeed2Draw", function()
	if update then
		update = false
		pos = LocalPlayer():GetPos()
	end
end)

--——————————————————————————————————————————————————————————————————————————————————————————————————————————> Print Models
if SERVER then
	util.AddNetworkString('rp.PrintModels')
	
	rp.AddCommand('/printmodels', function(ply)
		net.Start('rp.PrintModels')
		net.Send(ply)
	end)
else
	net.Receive('rp.PrintModels', function()
		local ply = LocalPlayer()
		for _, v in ipairs(ents.FindInSphere(ply:GetPos(), 600)) do 
			chat.AddText(rp.col.Green, v:GetClass(), rp.col.Grey, ': ' .. (v:GetModel() or '') .. ', [', rp.col.White, tostring(v:GetPos()), rp.col.Grey, '], [', rp.col.White, tostring(v:GetAngles()), rp.col.Grey, ']')
		end
	end)
end

--——————————————————————————————————————————————————————————————————————————————————————————————————————————> Color Modify
cvar.Register'color_modification':SetDefault(true):AddMetadata('State', 'RPMenu'):AddMetadata('Menu', 'Улучшение цветов')

local tab = {
	[ "$pp_colour_addr" ] = 0,
	[ "$pp_colour_addg" ] = 0,
	[ "$pp_colour_addb" ] = 0,
	[ "$pp_colour_brightness" ] = -0.02,
	[ "$pp_colour_contrast" ] = 1.1,
	[ "$pp_colour_colour" ] = 1.05,
	[ "$pp_colour_mulr" ] = 0,
	[ "$pp_colour_mulg" ] = 0,
	[ "$pp_colour_mulb" ] = 0
}

hook.Add('RenderScreenspaceEffects', function()
	if cvar.GetValue('color_modification') then
		DrawColorModify( tab )
	end
end)

--——————————————————————————————————————————————————————————————————————————————————————————————————————————> First Person Death
cvar.Register'enable_firstpersondeath':SetDefault(true):AddMetadata('State', 'RPMenu'):AddMetadata('Menu', 'Смерть от первого лица')

hook("CalcView", "FirstPersonDeath", function(pl, pos, ang, fov, nearz, farz)
	if cvar.GetValue('enable_firstpersondeath') and not pl:Alive() and IsValid(pl:GetRagdollEntity()) then 
		local rag = pl:GetRagdollEntity()
		local eyeattach = rag:LookupAttachment('eyes')
		
		if eyeattach then 
			local eyes = rag:GetAttachment(eyeattach)
			
			if eyes then
				return {
					origin = eyes.Pos,
					angles = eyes.Ang,
					fov = fov
				}
			end
		end
	end
end)

--——————————————————————————————————————————————————————————————————————————————————————————————————————————> Footsteps
--[[
local foot_sounds_ota = local a={Sound("npc/combine_soldier/gear1.wav"),Sound("npc/combine_soldier/gear2.wav"),Sound("npc/combine_soldier/gear3.wav"),Sound("npc/combine_soldier/gear4.wav"),Sound("npc/combine_soldier/gear5.wav"),Sound("npc/combine_soldier/gear6.wav")}
local foot_sounds_cp = {Sound("npc/metropolice/gear1.wav"),Sound("npc/metropolice/gear2.wav"),Sound("npc/metropolice/gear3.wav"),Sound("npc/metropolice/gear4.wav"),Sound("npc/metropolice/gear5.wav"),Sound("npc/metropolice/gear6.wav")}
local zombie_sounds = {Sound("npc/zombie/foot1.wav"),Sound("npc/zombie/foot2.wav"),Sound("npc/zombie/foot3.wav")}
]]--

local math_Round = math.Round
local table_Random = table.Random
local step_sound, jtab, ftab

hook('PlayerFootstep', function(client, position, foot, soundName, volume)
	
	if IsValid(client) then
		step_sound = nil

		if client:GetJobTable() and client:GetJobTable().silentsteps then
			if math_Round(client:GetVelocity():Length()) >= client:GetRunSpeed() then
				return true
			end
		end
		
		if client:IsDisguised() then
			jtab = client:GetDisguiseJobTable()
			--step_sound = jtab and (jtab.footstepSound or (rp.Factions[jtab.faction] and rp.Factions[jtab.faction].footstepSound))
			
			if jtab then
				if jtab.footstepSound ~= nil then
					step_sound = jtab.footstepSound
					
				elseif rp.Factions[jtab.faction] and rp.Factions[jtab.faction].footstepSound ~= nil then
					step_sound = rp.Factions[jtab.faction].footstepSound
				end
			end
		else 
			jtab = client:GetJobTable()
			
			--step_sound = client:GetJobTable() and client:GetJobTable().footstepSound or client:GetFactionTable() and client:GetFactionTable().footstepSound
			
			if jtab and jtab.footstepSound ~= nil then
				step_sound = jtab.footstepSound
				
			else
				ftab = client:GetFactionTable()
				
				if ftab and ftab.footstepSound ~= nil then
					step_sound = ftab.footstepSound
				end
			end
		end
		
		if step_sound == nil then
			step_sound = rp.cfg.FootstepSound
		end
		
		if not isbool(step_sound) then 
			client:EmitSound(table_Random(istable(step_sound) and step_sound or {step_sound}), 75, 100, volume)
		end
		
		if step_sound ~= true then 
			return true
		end
	end
end)
