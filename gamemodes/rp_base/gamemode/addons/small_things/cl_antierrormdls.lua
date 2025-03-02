-- "gamemodes\\rp_base\\gamemode\\addons\\small_things\\cl_antierrormdls.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local color_text = Color( 200, 200, 200 );
local color_error = Color( 200, 200, 200, 127 );

surface.CreateFont( "urf.im/errormodels", {
	font = "Montserrat",
	size = ScrH() * 0.015,
	extended = true,
} );

local queue = {};

local radius = 384;
local radius_sqr = math.pow( radius, 2 );

local messages = {
	[1] = translates.Get( "Пожалуйста подпишитесь на контент в ESC меню!" ),
	[2] = translates.Get( "Памятка с информацией по решению проблем: urf.im/page/tech" ),
};

local classes = {
	["prop_detail"] = true,
	["prop_static"] = true,
	["prop_physics"] = true,
	["prop_ragdoll"] = true,
	["prop_dynamic"] = true,
	["prop_physics_multiplayer"] = true,
	["prop_physics_override"] = true,
	["prop_dynamic_override"] = true,
};

local co_thread;
local co_thread_timeout = 0;

local thread = function()
	while true do
		local t = SysTime();

		if co_thread_timeout > t then
			coroutine.yield();
			continue
		end

		for k, ent in ipairs( ents.FindInSphere(LocalPlayer():GetPos(), radius) ) do
			coroutine.yield();

			if not ent:IsValid() then
				continue
			end

			if not classes[ent:GetClass()] then
				continue
			end

			local mdl = ent:GetModel();

			if not queue[ent] and not util.IsValidModel( mdl ) then
				queue[ent] = { m = mdl, r = t + 5 };
			end
		end

		co_thread_timeout = SysTime() + 1;
	end
end

hook.Add( "HUDPaint", "rp.AntiErrorModels::Render", function()
	local view = LocalPlayer():GetShootPos();
	local t = SysTime();

	if not co_thread or not coroutine.resume( co_thread ) then
		co_thread = coroutine.create( thread );
		coroutine.resume( co_thread );
	end

	for ent, data in pairs( queue ) do
		if data.r < t then
			queue[ent] = nil;
			continue
		end

		if ent:IsValid() then
			data.v = ent:GetPos();
			data.r = t + 5;

			ent:SetModel( "models/props_junk/cardboard_box004a.mdl" );
		end

		if data.v:DistToSqr( view ) > radius_sqr then
			continue
		end

		local tw, th = 0, 0;
		local screen = data.v:ToScreen();
		local x, y = screen.x, screen.y;

		tw, th = draw.SimpleText( messages[1], "urf.im/errormodels", x, y, color_text, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP );
		y = y + th;

		tw, th = draw.SimpleText( messages[2], "urf.im/errormodels", x, y, color_text, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP );
		y = y + th;

		draw.SimpleText( data.m, "urf.im/errormodels", x, y, color_error, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP );
	end
end );

hook.Add( "FixErrorItemShowEntityMenu", "AntiErrorMdls", function( ply )
	if ply.HasBlockedInventory and ply:HasBlockedInventory() then return true end

	for k, ent in pairs( ents.FindInSphere(ply:GetEyeTrace().HitPos, 8) ) do
		if ent.badents_index and ent:GetNWBool("isInvItem") then
            hook.Run( "ItemShowEntityMenu", ent );
			return true
		end
	end
end );