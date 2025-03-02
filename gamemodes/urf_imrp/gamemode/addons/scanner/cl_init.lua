surface.CreateFont("nutScannerFont", {
	font = "Lucida Sans Typewriter",
	antialias = false,
	outline = true,
	weight = 800,
	size = 18
})

local PICTURE_DELAY = 5

local PICTURE_WIDTH, PICTURE_HEIGHT = 580, 420
local PICTURE_WIDTH2, PICTURE_HEIGHT2 = PICTURE_WIDTH * 0.5, PICTURE_HEIGHT * 0.5

local view = {}
local zoom = 0
local deltaZoom = zoom
local nextClick = 0

local hidden = false
local first_view = false
local last_toggle = 0
local selectedEntity
local lastAction = 0

local function takePicture(selectedEntity)
	lastAction = CurTime() + PICTURE_DELAY

	local m = ui.Create('ui_frame', function(self)
		self:SetTitle((selectedEntity:IsPlayer() && selectedEntity:Nick()) || (selectedEntity:IsDoor() && selectedEntity:DoorGetOwner():Nick()) || 'Выберите причину')
		self:SetSize(.2, .2)
		self:Center()
		self:MakePopup()
	end)
	local x, y = m:GetDockPos()
	local scr = ui.Create('ui_scrollpanel', function(self, p)
		self:SetPos(x, y)
		self:SetSize(p:GetWide() - 10, p:GetTall() - y - 5)

		for k, v in pairs(rp.GetTerm('WantedReasons')) do
			local p = ui.Create('DButton', function(self, p)
				self:SetTall(30)
				self:SetText(v)
				function self:DoClick()
					net.Start('wanted_scanner')
						net.WriteEntity(selectedEntity)
						net.WriteInt(k, 4)
					net.SendToServer()
					m:Close()
				end
			end)
			self:AddItem(p)
		end
	end, m)
	m:Focus()
end


hook.Add("CalcView", "ScannerCalcView", function(client, origin, angles, fov)
	local entity = client:GetNWEntity("scanner")

	if (IsValid(entity)) then
		hidden = true
		if entity:GetClass():find("scanner") then
			view.origin = origin
			if input.IsKeyDown(KEY_LALT) && last_toggle < CurTime() then
				last_toggle = CurTime() + 1
				first_view = !first_view
				entity:SetNoDraw(first_view)
			end

			if input.IsMouseDown(MOUSE_LEFT) && selectedEntity && lastAction < CurTime() then
				takePicture(selectedEntity)
			end

			if first_view then
				view.origin = entity:GetPos()
			end
			view.angles = client:GetAimVector():Angle()
			view.fov = fov - deltaZoom
	
			if (math.abs(deltaZoom - zoom) > 5 and nextClick < RealTime()) then
				nextClick = RealTime() + 0.05
				client:EmitSound("common/talk.wav", 100, 180)
			end
	
			return view
		end
	else
		first_view = false
		hidden = false
	end
end)



local data = {}
hook.Add("HUDPaint", "ScannerHUDPaint", function()
	if (first_view) then
		local scrW, scrH = surface.ScreenWidth() * 0.5, surface.ScreenHeight() * 0.5
		local x, y = scrW - PICTURE_WIDTH2, scrH - PICTURE_HEIGHT2

		if (lastAction >= CurTime()) then
			local percent = math.Round(math.TimeFraction(lastAction - PICTURE_DELAY, lastAction, CurTime()), 2) * 100
			local glow = math.sin(RealTime() * 15)*25

			draw.SimpleText("RE-CHARGING: "..percent.."%", "nutScannerFont", x, y - 24, Color(255 + glow, 100 + glow, 25, 250))
		end

		local position = LocalPlayer():GetPos()
		local angle = LocalPlayer():GetAimVector():Angle()

		draw.SimpleText("POS ("..math.floor(position[1])..", "..math.floor(position[2])..", "..math.floor(position[3])..")", "nutScannerFont", x + 8, y + 8, color_white)
		draw.SimpleText("ANG ("..math.floor(angle[1])..", "..math.floor(angle[2])..", "..math.floor(angle[3])..")", "nutScannerFont", x + 8, y + 24, color_white)
		draw.SimpleText("ID  ("..LocalPlayer():Name()..")", "nutScannerFont", x + 8, y + 40, color_white)
		draw.SimpleText("ZM  ("..(math.Round(zoom / 40, 2) * 100).."%)", "nutScannerFont", x + 8, y + 56, color_white)

		if (IsValid(LocalPlayer():GetNWEntity("scanner"))) then
			data.start = LocalPlayer():GetNWEntity("scanner"):GetPos()
			data.endpos = data.start + LocalPlayer():GetAimVector() * 1500
			data.filter = LocalPlayer():GetNWEntity("scanner")

			local entity = util.TraceLine(data).Entity

			if (IsValid(entity) && entity:IsPlayer()) then
				selectedEntity = entity
				entity = entity:GetName()
			else
				selectedEntity = nil
				entity = "NULL"
			end

			draw.SimpleText("TRG ("..entity..")", "nutScannerFont", x + 8, y + 72, color_white)
		end

		surface.SetDrawColor(235, 235, 235, 230)

		surface.DrawLine(0, scrH, x - 128, scrH)
		surface.DrawLine(scrW + PICTURE_WIDTH2 + 128, scrH, ScrW(), scrH)
		surface.DrawLine(scrW, 0, scrW, y - 128)
		surface.DrawLine(scrW, scrH + PICTURE_HEIGHT2 + 128, scrW, ScrH())

		surface.DrawLine(x, y, x + 128, y)
		surface.DrawLine(x, y, x, y + 128)

		x = scrW + PICTURE_WIDTH2

		surface.DrawLine(x, y, x - 128, y)
		surface.DrawLine(x, y, x, y + 128)

		x = scrW - PICTURE_WIDTH2
		y = scrH + PICTURE_HEIGHT2

		surface.DrawLine(x, y, x + 128, y)
		surface.DrawLine(x, y, x, y - 128)

		x = scrW + PICTURE_WIDTH2

		surface.DrawLine(x, y, x - 128, y)
		surface.DrawLine(x, y, x, y - 128)

		surface.DrawLine(scrW - 48, scrH, scrW - 8, scrH)
		surface.DrawLine(scrW + 48, scrH, scrW + 8, scrH)
		surface.DrawLine(scrW, scrH - 48, scrW, scrH - 8)
		surface.DrawLine(scrW, scrH + 48, scrW, scrH + 8)
	end
end)


hook.Add("InputMouseApply", "ScannerInputMouseApply", function(command, x, y, angle)
	zoom = math.Clamp(zoom + command:GetMouseWheel()*1.5, 0, 60)
	deltaZoom = Lerp(FrameTime() * 2, deltaZoom, zoom)
end)


hook.Add("HUDShouldDraw", "ScannerShouldDrawCrosshair", function(name)
	if (hidden && name == 'CHudCrosshair') then
		return false
	end
end)

hook.Add("AdjustMouseSensitivity", "ScannerAdjustMouseSensitivity", function()
	if (first_view) then
		return 0.3
	end
end)

local data = {}


local blackAndWhite = {
	["$pp_colour_addr"] = 0, 
	["$pp_colour_addg"] = 0, 
	["$pp_colour_addb"] = 0, 
	["$pp_colour_brightness"] = 0, 
	["$pp_colour_contrast"] = 1.5, 
	["$pp_colour_colour"] = 0, 
	["$pp_colour_mulr"] = 0, 
	["$pp_colour_mulg"] = 0, 
	["$pp_colour_mulb"] = 0
}

hook.Add("RenderScreenspaceEffects", "ScannerRenderScreenspaceEffects", function()
	if (first_view) then
		blackAndWhite["$pp_colour_brightness"] = 0.05 + math.sin(RealTime() * 10)*0.01
		DrawColorModify(blackAndWhite)
	end
end)