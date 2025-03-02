-- "gamemodes\\rp_base\\gamemode\\addons\\npc_control\\cl_init.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local sf_SetDrawColor 		= surface.SetDrawColor
local sf_SetMat 			= surface.SetMaterial
local sf_DrawTexturedRect	= surface.DrawTexturedRect
local sf_DrawRect			= surface.DrawRect

local r_UpdateScreenEffectTexture = render.UpdateScreenEffectTexture;
local r_SetScissorRect            = render.SetScissorRect;

local m_min 				= math.min
local m_Approach 			= math.Approach
local d_SimpleText 			= draw.SimpleText
local d_SimpleTextOutlined 	= draw.SimpleTextOutlined
local Lerp 					= Lerp

local cam_Start3D2D 		= cam.Start3D2D
local cam_End3D2D 			= cam.End3D2D

local lp, data, need_to_render
local npc_loot_warn
local npcs_around = {}
local destroyable_data = {}

timer.Create('rp.Raids.CheckNpcsAround', 0.5, 0, function()
	if not rp.cfg.Raids then 
		timer.Remove('rp.Raids.CheckNpcsAround')
		return 
	end
	
	lp = LocalPlayer()
	
	if not (IsValid(lp) and lp:Alive()) then 
		return 
	end
	
	for k, v in pairs(ents.FindInSphere(lp:GetPos(), 3000)) do
		if IsValid(v) and v:IsNPC() and rp.npc.Templates[v:GetClass()] and v:Health() > 0 then
			npcs_around[v:EntIndex()] = v
			
			if not destroyable_data[v:EntIndex()] then
				data = rp.npc.Templates[v:GetClass()]
					
				destroyable_data[v:EntIndex()] = {
					alpha = 0,
					ent = v,
					z_offset = data.hud_offset or 0,
					draw_radius = data.draw_radius or 1000,
				}
			end
		end
	end
end)

local function render_prop_interface(data)
	ent = data.ent
	
	cam_Start3D2D(ent:GetPos(), Angle(0, LocalPlayer():EyeAngles().yaw - 90, 90) , 0.065)
		sf_SetDrawColor(0, 0, 0, data.alpha * 80)
		sf_DrawRect(-300, -900 - data.z_offset, 600, 35)
				
		sf_SetDrawColor(255, 255, 255, data.alpha * 255)
		sf_DrawRect(-299, -899 - data.z_offset, 598 * (data.approach_hp / ent:GetMaxHealth()), 33)
				
		d_SimpleTextOutlined(math.max(0, ent:Health()) .. ' / ' .. ent:GetMaxHealth(), 'DestoyableProps.Font', 280, -935 - data.z_offset, Color(255, 255, 255, data.alpha * 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, data.alpha * 160))
	cam_End3D2D()
end

local function open_test_menu(time_until, time_max)
	if IsValid(npc_loot_warn) or not time_until or not time_max then return end
	
	local ScrScale = ScrH() / 1080
	
	surface.CreateFont("rpui.npcwarn.title", {
		font = "Montserrat", 
		extended = true,
		antialias = true,
		size = 30 * ScrScale,
		weight = 550
	})
	
	surface.CreateFont("rpui.npcwarn.content", {
		font = "Montserrat", 
		extended = true,
		antialias = true,
		size = 34 * ScrScale,
		weight = 600
	})
	
	npc_loot_warn = vgui.Create("urf.im/rpui/menus/blank")
	npc_loot_warn:SetSize(600 * ScrScale, 170 * ScrScale)
	npc_loot_warn:Center()
	npc_loot_warn:MakePopup()
	
	npc_loot_warn.header.IcoSizeMult = 1.5
	npc_loot_warn.header:SetIcon("bubble_hints/gift.png")
	npc_loot_warn.header:SetTitle("Награда")
	npc_loot_warn.header:SetFont("rpui.npcwarn.title")
	
	local color_black = Color(0, 0, 0, 180)
	local color_white = Color(255, 255, 255, 255)
	
	local progress_panel = vgui.Create("DPanel", npc_loot_warn.workspace)
	progress_panel:Dock(BOTTOM)
	progress_panel.Paint = function(this, w, h)
		surface.SetDrawColor(color_black)
		surface.DrawRect(0, 0, w, h)
		
		local wide = w - w / time_max * (time_until - CurTime())
		surface.SetDrawColor(color_white)
		surface.DrawRect(0, 0, wide, h)
		if wide >= w then
			npc_loot_warn:Remove()
		end
	end
	
	local label = vgui.Create("DLabel", npc_loot_warn.workspace)
	label:SetFont("rpui.npcwarn.content")
	label:SetText("Подождите, предметы загружаются...")
	label:SetColor(color_white)
	label:SetContentAlignment(5)
	label:Dock(FILL)
end

net.Receive('NpcController::WaitForLoot', function()
	open_test_menu(net.ReadFloat(), net.ReadFloat())
end)

hook.Add("Inventory::OpenBag", "NpcController::CloseWarn", function()
	if IsValid(npc_loot_warn) then
		npc_loot_warn:Close()
	end
end)

hook.Add('PostDrawTranslucentRenderables', 'rp.NpcController.Interface', function()
	if not IsValid(LocalPlayer()) or not rp.cfg.Raids then return end
	
	lp = LocalPlayer():GetPos()
	
	for k, v in pairs(destroyable_data) do
		if not IsValid(v.ent) then 
			destroyable_data[k] = nil
			break
		end
		
		need_to_render = npcs_around[k] and true
		
		v.alpha = m_Approach(v.alpha, need_to_render and 1 or 0, FrameTime() * 5)
		v.approach_hp = Lerp(8 * FrameTime(), v.approach_hp or 0, v.ent:Health())
		
		if v.alpha > 0.05 then
			render_prop_interface(v)
			
		elseif not need_to_render then 
			destroyable_data[k] = nil
			break
		end
	end
end)

local names = {
	['models/combine_strider.mdl'] = 'Страйдер',
	['models/antlion_guard.mdl'] = 'Страж муравьиных львов',
	['models/hunter.mdl'] = 'Охотник',
	['models/mi24/body.mdl'] = 'Вертолёт',
}

rp.AddBubble("entity", "prop_ragdoll", {
	ico = Material("bubble_hints/gift.png", "smooth", "noclamp"),
	name = function(ent)
		return (names[ent:GetModel()] or 'Труп') .. ' (' .. (ba.str.FormatTime(ent:GetNetworkedInt('TimeLeft') - CurTime(), true)) .. ')'
	end,
	desc = "[E] Открыть лут",
	offset = Vector(0, 0, 11),
	scale = 0.6,
	customCheck = function(ent)
		return ent:GetNetworkedInt('TimeLeft') and ent:GetNetworkedInt('TimeLeft') > CurTime()
	end
})

rp.AddBubble("entity", "prop_physics", {
	ico = Material("bubble_hints/gift.png", "smooth", "noclamp"),
	name = function(ent)
		return (names[ent:GetModel()] or 'Труп') .. ' (' .. (ba.str.FormatTime(ent:GetNetworkedInt('TimeLeft') - CurTime(), true)) .. ')'
	end,
	desc = "[E] Открыть лут",
	offset = Vector(0, 0, 11),
	scale = 0.6,
	customCheck = function(ent)
		return ent:GetNetworkedInt('TimeLeft') and ent:GetNetworkedInt('TimeLeft') > CurTime()
	end
})
