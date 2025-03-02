-- "gamemodes\\rp_base\\entities\\entities\\ent_lootbox\\cl_init.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
include 'shared.lua'

ENT.ClickSound = 'voidcases/item_drop1_common.wav'
ENT.ResultSound = 'voidcases/item_drop3_rare.wav'

function ENT:Initialize()
	table.insert(rp.client.lootboxes, self)

	self:PrecacheSoundChannel()

	self.m_bInitialized = true
end

function ENT:Think()
	if not self.m_bInitialized then
		self:Initialize()
	end
		
	self:NextThink(CurTime())
	return true
end
 
function ENT:Draw()
	self:DrawModel()
end

surface.CreateFont("rpui.Fonts.Case", {
    font     = "Montserrat",
    extended = true,
    weight 	 = 600,
    size     = 20,
})

local box_size_x = 150
local box_size_y = box_size_x * 1.54

local inner_x = math.ceil(box_size_x * 0.04)
local inner_y = box_size_y * 0.27
local side_inner = 10 * inner_x

local panel_size_x = box_size_x * 1.04 * 4.5 + side_inner * 2 - inner_x
local panel_size_y = math.ceil(1.54 * box_size_y)

local left_side = math.floor(side_inner + -panel_size_x * 0.5 - box_size_x)
local all_step = 6 * (box_size_x + inner_x)
local y_multed = math.ceil(box_size_y * 1.29)

local offset_y = -panel_size_y * 0.5
local result_size_x = box_size_x + side_inner * 4

local center_left = side_inner - panel_size_x * 0.5 + box_size_x * 2 + inner_x - box_size_x * 0.75 + 0.5 * inner_x
local center_right = center_left + box_size_x + inner_x

local triangle = {
	{ x = center_right - box_size_x * 0.2, y = offset_y + panel_size_y },
	{ x = center_right + box_size_x * 0.2, y = offset_y + panel_size_y },
	{ x = center_right, y = offset_y + panel_size_y + box_size_x * 0.2 },
}

local triangle_selector = {
	{ x = center_right - box_size_x * 0.2, y = offset_y + panel_size_y - box_size_x * 0.25 },
	{ x = center_right, y = offset_y + panel_size_y - box_size_x * 0.47 },
	{ x = center_right + box_size_x * 0.2, y = offset_y + panel_size_y - box_size_x * 0.25 },
}

local triangle_selector_inner = {
	{ x = center_right - box_size_x * 0.2 + 4, y = offset_y + panel_size_y - box_size_x * 0.25 - 2 },
	{ x = center_right, y = offset_y + panel_size_y - box_size_x * 0.47 + 3 },
	{ x = center_right + box_size_x * 0.2 - 4, y = offset_y + panel_size_y - box_size_x * 0.25 - 2 },
}

local math_sqrt = math.sqrt
local math_max = math.max

local default_color = Color(180, 180, 195, 70)
local selector_mat = Material('premium/new_selector')

local sel_items = { 1, 14, 20, 60 }
local sel_colors = {
	[60] 	= Color(170, 200, 235, 242),
	[20] 	= Color(46, 174, 59, 242),
	[14] 	= Color(111, 38, 170, 242),
	[1] 	= Color(254, 121, 4, 242),
}

local function get_color(chance)
	for _, rc_data in pairs(sel_items) do
		chance = chance - rc_data
		
		if chance <= 0 then
			return sel_colors[rc_data]
		end
	end
	
	return sel_colors[60]
end

local function get_baked(text)
	local size_x = 0
	
	surface.SetFont("rpui.Fonts.Case")
	local _, size_y = surface.GetTextSize(" ")
	
	local splitted = string.Split(text, " ")
	local returned = {}
	local cur_i = 0
	local cur_x
	
	for _k, _v in pairs(splitted) do
		cur_x = surface.GetTextSize(_v)
		
		if size_x + cur_x > box_size_x * 0.8 and size_x > 0 then
			cur_i = cur_i + 1
			returned[cur_i + 1] = _v
			size_x = 0
			
		else
			returned[cur_i + 1] = (returned[cur_i + 1] or '') .. ' ' .. _v
			size_x = size_x + cur_x
		end
	end
	
	return returned
end

local function CalculateRoulette(self)
	self.rt = self:GetRouletteTime() or 0
	
	if not self.box_data and self.GetBoxUID and self:GetBoxUID() then
		self.box_data = rp.lootbox.Get(self:GetBoxUID())
	end
	
	if not self.box_data then return end
	
	self.DrawTrans = math.Approach(self.DrawTrans or 0, (self.rt == 0 or self:GetEnding()) and 0 or 1, 0.04)
	
	self.r_speed = ((self.rt - CurTime() > 10) and (self.rt - CurTime() - 9) * (3.6) or math_sqrt(math_max(self.rt - CurTime(), 0))) * (self.Abort and 0.6 or 1) * (RealTime() - (self.last_time or RealTime())) * 100
	
	self.last_time = RealTime()
end

local function DrawRoulette(self)
	if not self.box_data or not self.r_speed then return end
	
	if self.DrawTrans > 0.01 then
		cam.Start3D2D(self:GetPos() + Vector(0, 0, 60), Angle(0, LocalPlayer():EyeAngles().yaw - 90, 90), 0.15)
			if self.rt > CurTime() or not self.Boxes then
				if not self.Boxes then
					self.Boxes = {}
					
					self.TransSize = panel_size_x
					
					self.items_count = table.Count(self.box_data.items)
					
					local loot = math.random(1, self.items_count)
					
					for i = 1, 6 do
						table.insert(self.Boxes, {
							x = side_inner + -panel_size_x * 0.5 + (i - 1) * (box_size_x + inner_x) - box_size_x * 0.25,
							loot = loot,
							baked = get_baked(self.box_data.items[loot].name),
							color = self.box_data.items[loot].colors and ColorAlpha(self.box_data.items[loot].colors[1], 242) or get_color(self.box_data.items[loot].chance),
							icon = self.box_data.items[loot].icon,
						})
					end
				end
				
			elseif self.rt + 1 < CurTime() then
				self.TransSize = math.Approach(self.TransSize or panel_size_x, result_size_x, FrameTime() * 222)
				
				if not self.SoundPlayed then
					self:EmitSound(self.ResultSound, 60)
					self.SoundPlayed = true
				end
			end
			
			surface.SetDrawColor(0, 0, 0, 170 * self.DrawTrans)
			surface.DrawRect(-panel_size_x * 0.5 + (panel_size_x - self.TransSize) * 0.5, offset_y, self.TransSize, panel_size_y)
			
			draw.NoTexture()
			surface.DrawPoly(triangle)
			
			if self.rt + 1 > CurTime() then
				local speed = self.r_speed or 0
				
				render.SetStencilWriteMask( 255 );
				render.SetStencilTestMask( 255 );
				render.SetStencilReferenceValue( 0 );
				render.SetStencilPassOperation( STENCIL_KEEP );
				render.SetStencilZFailOperation( STENCIL_KEEP );
				render.ClearStencil();
				render.SetStencilEnable( true );
				render.SetStencilReferenceValue( 1 );
				render.SetStencilCompareFunction( STENCIL_NEVER );
				render.SetStencilFailOperation( STENCIL_REPLACE );
				
				draw.NoTexture();
				surface.SetDrawColor(rpui.UIColors.White)
				surface.DrawRect(-panel_size_x * 0.5 + side_inner * 1.25, offset_y, panel_size_x - side_inner * 2.5, panel_size_y)
				
				render.SetStencilCompareFunction( STENCIL_EQUAL );
				render.SetStencilFailOperation( STENCIL_KEEP );
				
				local i = 0
				local cur_data
				
				for k, v in pairs(self.Boxes) do
					v.x = v.x - speed
					
					if v.x < left_side then
						v.x = v.x + all_step
						
						if not self.Selected and self.rt - CurTime() < 4.4 then
							self.Selected = v
							
							v.selected = true
							v.loot = self:GetReward()
							
						else
							v.loot = math.random(1, self.items_count)
						end
						
						v.baked = get_baked(self.box_data.items[v.loot].name)
						v.color = self.box_data.items[v.loot].colors and ColorAlpha(self.box_data.items[v.loot].colors[1], 242) or get_color(self.box_data.items[v.loot].chance)
						v.icon = self.box_data.items[v.loot].icon
						
					elseif v.x > center_left and v.x < center_right then
						if self.cur_sel ~= v then
							self.cur_sel = v
							self:EmitSound(self.ClickSound, 60)
							
							if v.selected then
								self.Abort = true
							end
						end
					end
					
					if self.cur_sel == v then
						surface.SetDrawColor(ColorAlpha(v.color, self.DrawTrans * v.color.a))
						surface.SetMaterial(selector_mat)
						surface.DrawTexturedRect(v.x, offset_y + inner_y - (y_multed - box_size_y) * 0.5, box_size_x, y_multed)
						
						surface.SetDrawColor(255, 255, 255, 222 * self.DrawTrans)
						surface.SetMaterial(v.icon)
						surface.DrawTexturedRect(v.x + box_size_x * 0.25, offset_y + inner_y + box_size_y * 0.5 - box_size_x * 0.5, box_size_x * 0.5, box_size_x * 0.5)
						
					else
						surface.SetDrawColor(ColorAlpha(default_color, default_color.a * self.DrawTrans))
						surface.SetMaterial(selector_mat)
						surface.DrawTexturedRect(v.x, offset_y + inner_y, box_size_x, box_size_y)
						
						surface.SetDrawColor(255, 255, 255, 70 * self.DrawTrans)
						surface.SetMaterial(v.icon)
						surface.DrawTexturedRect(v.x + box_size_x * 0.25, offset_y + inner_y + box_size_y * 0.5 - box_size_x * 0.5, box_size_x * 0.5, box_size_x * 0.5)
					end
					
					for strid, str in pairs(v.baked) do
						draw.DrawText(str, "rpui.Fonts.Case", v.x + box_size_x * 0.49, offset_y + inner_y + box_size_y * 0.7 + strid * 20 - 20 - (#v.baked - 1) * 10, Color(255, 255, 255, 255 * self.DrawTrans), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
					end
					
					i = i + 1
				end
				
				render.SetStencilEnable( false );
				
				surface.SetDrawColor(254, 121, 4, 255 * self.DrawTrans)
				draw.NoTexture()
				surface.DrawPoly(triangle_selector)
				
				surface.SetDrawColor(0, 0, 0, 255 * self.DrawTrans)
				surface.DrawPoly(triangle_selector_inner)
			
			elseif self.rt + 1 < CurTime() then
				if not self.Selected then
					cam.End3D2D()
					return
				end
				
				self.Selected.x = math.Approach(self.Selected.x, side_inner + -panel_size_x * 0.5 + 2 * (box_size_x + inner_x) - box_size_x * 0.25, FrameTime() * 22)
				self.Selected.y = math.Approach(self.Selected.y or (offset_y + inner_y - (y_multed - box_size_y) * 0.5), offset_y + inner_y +  - (y_multed - box_size_y) * 0.5 + box_size_y * 0.1, FrameTime() * 22)
				
				surface.SetDrawColor(ColorAlpha(self.Selected.color, self.Selected.color.a * self.DrawTrans))
				surface.SetMaterial(selector_mat)
				surface.DrawTexturedRect(self.Selected.x, self.Selected.y, box_size_x, y_multed)
				
				surface.SetDrawColor(255, 255, 255, 222 * self.DrawTrans)
				surface.SetMaterial(self.Selected.icon)
				surface.DrawTexturedRect(self.Selected.x + box_size_x * 0.25, self.Selected.y + y_multed * 0.5 - box_size_x * 0.5, box_size_x * 0.5, box_size_x * 0.5)
				
				for strid, str in pairs(self.Selected.baked) do
					draw.DrawText(str, "rpui.Fonts.Case", self.Selected.x + box_size_x * 0.49, self.Selected.y - (offset_y + inner_y - (y_multed - box_size_y) * 0.5) + offset_y + inner_y + box_size_y * 0.7 + strid * 20 - 20 - (#self.Selected.baked - 1) * 10, Color(255, 255, 255, 255 * self.DrawTrans), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				end
				
				surface.SetAlphaMultiplier((panel_size_x - self.TransSize) / (panel_size_x - result_size_x))
					draw.DrawText(translates.Get("ПОЗДРАВЛЯЮ!"), "rpui.Fonts.Case", 0, offset_y + inner_y * 0.3, Color(255, 255, 255, self.DrawTrans * 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
					draw.DrawText(translates.Get("ВЫ ПОЛУЧИЛИ:"), "rpui.Fonts.Case", 0, offset_y + inner_y * 0.62, Color(255, 255, 255, self.DrawTrans * 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				surface.SetAlphaMultiplier(1)
			end
		cam.End3D2D()
	end
end

function ENT:CalculateRoulette()
	CalculateRoulette(self)
end

function ENT:DrawRoulette()
	DrawRoulette(self)
end


-- Sound Management:
local ENT_SND_CHANNELS = {};
local fading_length = 0.5;

function ENT:PrecacheSoundChannel()
	local self_uid = self:GetBoxUID() or "nil";

	local cfg = rp.lootbox.Get( self_uid );
	if not cfg then return end

	local SoundPath = "sound/" .. cfg.back_sound;

	if SoundPath and (not ENT_SND_CHANNELS[self_uid]) then
		sound.PlayFile( SoundPath, "3d noplay noblock", function( station, errCode )
			if IsValid( station ) then
				ENT_SND_CHANNELS[self_uid] = {
					station = station,
					entity  = NULL,
					fade    = 0,
				};
			end
		end );
	end

	if timer.Exists( "ent_lootbox::SoundManager" ) then return end

	timer.Create( "ent_lootbox::SoundManager", 0.25, 0, function()
		if IsValid(self) and self:GetEnding() and not self.PreventSpam then
			timer.Simple(1, function()
				if ENT_SND_CHANNELS[self_uid] and IsValid(ENT_SND_CHANNELS[self_uid].station) then
					ENT_SND_CHANNELS[self_uid].station:Stop()
					ENT_SND_CHANNELS[self_uid] = nil
				end
			end)
			
			self.PreventSpam = true
		end
		
		if #rp.client.lootboxes == 0 then
			timer.Remove( "ent_lootbox::SoundManager" );
			return
		end
	
		-- Entity Filter:
		local distances = {};
		for _, ent in ipairs( rp.client.lootboxes ) do
			if not IsValid( ent ) then 
				continue 
			end

			if not ent.RouletteSpawnTime then
				ent.RouletteSpawnTime = CurTime();
			end

			if (CurTime() - ent.RouletteSpawnTime) < 3 then
				continue
			end

			if ent:GetRouletteTime() == 0 then
				continue
			elseif not ent.SndRouletteTime then
				ent.SndRouletteTime   = ent:GetRouletteTime() + ent.TimeToRemove;
				ent.SndRouletteLength = ent:GetRouletteLength() + ent.TimeToRemove;
			end

			ent.snd_dt = 1 - (ent.SndRouletteTime - (CurTime()+3)) / ent.SndRouletteLength;
			if ent.snd_dt > 1 then
				continue
			end

			local uid = ent:GetBoxUID() or "nil";
			
			if not distances[uid] then
				distances[uid] = {};
			end

			table.insert( distances[uid], ent );
		end

		-- Sort closest:
		local EarPos = EyePos();
		for uid in pairs( distances ) do
			if #distances[uid] < 2 then continue end
			
			table.sort( distances[uid], function( ent_a, ent_b )
				return ent_a:GetPos():DistToSqr( EarPos ) < ent_b:GetPos():DistToSqr( EarPos );
			end );
		end

		-- Manage Channels:
		for uid, SoundChannel in pairs( ENT_SND_CHANNELS ) do
			if not IsValid( SoundChannel.station ) then
				ENT_SND_CHANNELS[uid] = nil;
				continue
			end

			if not distances[uid] then
				SoundChannel.station:Pause();
				continue
			end

			local ActiveEntity = distances[uid][1];
			if SoundChannel.entity ~= ActiveEntity then
				SoundChannel.entity = ActiveEntity;
				SoundChannel.fade = CurTime() + fading_length;

				SoundChannel.station:SetPos( SoundChannel.entity:GetPos(), vector_up );
				SoundChannel.station:SetTime( SoundChannel.station:GetLength() * SoundChannel.entity.snd_dt );
				SoundChannel.station:SetVolume( 0 );

				SoundChannel.station:Play();

				local sndfading_timer = "ent_lootbox::SoundManager_fading" .. uid;
				timer.Create( sndfading_timer, 0, 0, function()
					if IsValid(SoundChannel.entity) and IsValid(SoundChannel.station) and (SoundChannel.station:GetVolume() < 1) then
						SoundChannel.station:SetVolume(
							math.min( 0.25 + (1 - (SoundChannel.fade - CurTime()) / fading_length) * 0.75, 1 )
						);
						return
					end

					timer.Remove( sndfading_timer );
				end );
			end
		end
	end );
end