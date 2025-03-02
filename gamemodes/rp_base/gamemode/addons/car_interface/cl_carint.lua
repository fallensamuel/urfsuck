local v
local IsValid = IsValid
local draw = draw

local tr = translates
local cached
if tr then
	cached = {
		tr.Get( 'Транспортное средство' ), 
		tr.Get( 'Владелец:' ), 
		tr.Get( 'Со-владельцы:' ), 
		tr.Get( 'и ещё' ), 
	}
else
	cached = {
		'Транспортное средство', 
		'Владелец:', 
		'Со-владельцы:', 
		'и ещё', 
	}
end

hook('HUDPaint', 'simfphys.DrawInterface', function()
	v = LocalPlayer():GetEyeTrace().Entity
	if !IsValid(v) then return end
	if(v:GetClass() ~= 'gmod_sent_vehicle_fphysics_base' or !IsValid(v:DoorGetOwner()) or 
	   v:GetPos():Distance(LocalPlayer():GetPos()) > 200 or LocalPlayer():InVehicle()) then return end
	
	draw.SimpleTextOutlined(v:DoorGetTitle() or cached[1], 'VehicleFontBig', ScrW() / 2, ScrH() / 2 + 80, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, 1, Color(0, 0, 0))
	draw.SimpleTextOutlined(cached[2] .. ' ' .. v:DoorGetOwner():Name(), 'VehicleFontSmall', ScrW() / 2, ScrH() / 2 + 110, LocalPlayer():GetJobColor(), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, 1, Color(0, 0, 0))
	
	if(v:DoorOrgOwned()) then
		draw.SimpleTextOutlined(v:DoorGetOwner():GetOrg(), 'VehicleFontSmall', ScrW() / 2, ScrH() / 2 + 35, v:DoorGetOwner():GetOrgColor(), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, 1, Color(0, 0, 0))
	end
	
	if(v:DoorGetCoOwners()) then
		draw.SimpleTextOutlined(cached[3], 'VehicleFontSmall', ScrW() / 2, ScrH() / 2 + 145, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, 1, Color(0, 0, 0))
		
		for k, co in ipairs(v:DoorGetCoOwners()) do
			if IsValid(co) then
				draw.SimpleTextOutlined(co:Name(), 'VehicleFontSmall', ScrW() / 2, ScrH() / 2 + 145 + k * 45, co:GetJobColor(), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, 1, Color(0, 0, 0))
			end
			if (k > 4) then
				draw.SimpleTextOutlined(cached[4] .. ' ' .. (#v:DoorGetCoOwners() - 4), 'VehicleFontSmall', ScrW() / 2, ScrH() / 2 + 132 + k * 20, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, 1, Color(0, 0, 0))
				break
			end
		end
	end
end)
