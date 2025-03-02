-- "gamemodes\\rp_base\\entities\\entities\\urf_keypad_advanced\\cl_init.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
include("sh_init.lua")


local X, Y, W, H = -50, -100, 100, 200;


local color_black   	   = Color(0,0,0);
local color_entry   	   = Color(50, 75, 50, 255);
local color_outline 	   = Color(255,255,255);
local color_status_none    = Color(255,255,255);
local color_status_granted = Color(0,255,0);
local color_status_denied  = Color(255,0,0);


local tr, cached = translates;

if tr then
	cached = {
		tr.Get( "ДОСТУП" ), 
		tr.Get( "РАЗРЕШЕН" ), 
		tr.Get( "ЗАПРЕЩЕН" ), 
	};
else
	cached = {
		"ДОСТУП", 
		"РАЗРЕШЕН", 
		"ЗАПРЕЩЕН", 
	};
end


function ENT:Draw()
	self:DrawModel();

	if not self.color_outline then self.color_outline = color_status_none; end

	local ply = LocalPlayer();
	if ply:EyePos():DistToSqr(self:GetPos()) <= 562500 then -- 750
		local ang = self:GetPos() - ply:EyePos();

		local pos = self:GetPos() + self:GetForward() * 1.1;
		local ang = self:GetAngles();

		ang:RotateAroundAxis( ang:Right(), -90 );
		ang:RotateAroundAxis( ang:Up(), 90 );

		surface.SetFont( "Keypad" );

		cam.Start3D2D( pos, ang, 0.05 );
			local status = self:GetStatus();
			local value  = self:GetDisplayText() or "";

			surface.SetDrawColor( color_black );
			surface.DrawRect( X-5, Y-5, W+10, H+10 );

			draw.OutlinedBox( X+5, Y+5, 90, H-10, color_entry, self.color_outline );

			surface.SetFont( "Keypad" );

			if status == self.Status_None then
				draw.SimpleText(value, "Keypad", X + W * 0.5, Y + H * 0.5, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
				
				if self.color_outline ~= color_status_none then
					self.color_outline = color_status_none;
				end
			elseif status == self.Status_Granted then
				draw.SimpleText( cached[1], "KeypadState", X + W * 0.5, Y + H * 0.5 - 10, color_status_granted, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
				draw.SimpleText( cached[2], "KeypadState", X + W * 0.5, Y + H * 0.5 + 10, color_status_granted, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
				
				if self.color_outline ~= color_status_granted then
					self.color_outline = color_status_granted;
				end
			elseif status == self.Status_Denied then
				draw.SimpleText( cached[1], "KeypadState", X + W * 0.5, Y + H * 0.5 - 10, color_status_denied, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
				draw.SimpleText( cached[3], "KeypadState", X + W * 0.5, Y + H * 0.5 + 10, color_status_denied, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
				
				if self.color_outline ~= color_status_denied then
					self.color_outline = color_status_denied;
				end
			end
		cam.End3D2D();
	end
end