ba.cmd.Create("showinvisible", function(pl, args)
	net.Start("ba.ToggleAdminVis")
	net.Send(pl)
end)
:SetFlag('*')
:SetHelp("Toggles visibility of invisible admins")

if SERVER then
	util.AddNetworkString("ba.ToggleAdminVis")
	return
end

net.Receive("ba.ToggleAdminVis", function()
	ba["ToggleShowInvisible"] = not ba["ToggleShowInvisible"]
	local st = ba["ToggleShowInvisible"]

	rp.Notify(st and NOTIFY_GREEN or NOTIFY_RED, translates and translates.Get("Вы %s режим подсветки невидимых", st and translates.Get("включили") or translates.Get("выключили")) or ("Вы " .. (st and "включили" or "выключили") .. " режим подсветки невидимых"))
end)

surface.CreateFont("Font.Montserrat.16", {
	font 		= "Montserrat",
	size 		= 16,
	weight 		= 500,
	extended  	= true
})

local ThroughWalls = false
local ThroughRange = 0--1024 * 1024

local LocalPlayer_ = LocalPlayer
local render = render
local cam = cam
local Angle_ = Angle

hook.Add("PostDrawOpaqueRenderables", "Ba.AdminVisibleCloack", function()
	if not ba["ToggleShowInvisible"] then return end

	local Lply = LocalPlayer_()
	
	local cur_pos_player = Lply:GetPos()
	local cur_pos_eyes = Lply:EyePos()+Lply:EyeAngles():Forward()*4.5
	local cur_ang_eyes = Lply:EyeAngles()
	cur_ang_eyes = Angle_(cur_ang_eyes.p+90, cur_ang_eyes.y, 0)
	
	render.ClearStencil()
	render.SetStencilEnable(true)
		render.SetStencilWriteMask(255)
		render.SetStencilTestMask(255)
		render.SetStencilReferenceValue(1)
		
		for _, ent in pairs(player.GetAll()) do
			if ent:IsPlayer() then
				if ent ~= Lply and ent:GetNoDraw() then
					if ThroughRange ~= 0 then
						if (ent:GetPos():DistToSqr(cur_pos_player) > ThroughRange) then continue end
					end
					
					render.SetStencilCompareFunction(STENCIL_ALWAYS)
					if ThroughWalls then
						render.SetStencilZFailOperation(STENCIL_REPLACE)
					else
						render.SetStencilZFailOperation(STENCIL_KEEP)
					end
					
					render.SetStencilPassOperation(STENCIL_REPLACE)
					render.SetStencilFailOperation(STENCIL_KEEP)
					ent:DrawModel()
					
					render.SetStencilCompareFunction(STENCIL_EQUAL)
					render.SetStencilZFailOperation(STENCIL_KEEP)
					render.SetStencilPassOperation(STENCIL_KEEP)
					render.SetStencilFailOperation(STENCIL_KEEP)
					
					--cam.Start3D2D(cur_pos_eyes, cur_ang_eyes, 1)
					--	surface.SetDrawColor(225, 225, 255, 50)
					--	surface.DrawRect(-ScrW(), -ScrH(), ScrW()*2, ScrH()*2)
					--cam.End3D2D()
				end
			end
		end
	render.SetStencilEnable(false)
end)