include( "shared.lua" );

ENT.RenderGroup = RENDERGROUP_OPAQUE;

net.Receive( "rp.EmployerMenu", function()
	local ent = net.ReadEntity();

	local f       = ent:GetFaction();
	local faction = rp.Factions[f];

	if (rpui and rpui.EnableUIRedesign or rpui.DebugMode) and faction.teammates and not rp.cfg.ForceFaction then
		rp.OpenEmployerMenu( {f, unpack(faction.teammates)}, f );
	else
		rp.OpenEmployerMenu( f, nil, rp.cfg.ForceFaction );
	end
end );

local LocalPlayer = LocalPlayer
function ENT:Draw()
	if self:IsHidden(LocalPlayer()) then return end
	self:DrawModel()
end

-- Бабл в addons/small_things/cl_smallthings.lua

--[[
function ENT:Initialize()
	timer.Simple(1, function()
		self:ResetSequence( self:LookupSequence("idle_all_01") );
	end)
end

local ipairs                       = ipairs;
local CurTime                      = CurTime;
local LocalPlayer                  = LocalPlayer;
local math_sin, math_pi, math_sqrt = math.sin, math.pi, math.sqrt;
local cam_Start3D2D, cam_End3D2D   = cam.Start3D2D, cam.End3D2D;
local draw_SimpleTextOutlined      = draw.SimpleTextOutlined;
local ents_FindByClass             = ents.FindByClass;
local vec                          = Vector(0, 0, 82);
local color_white, color_black     = Color(255, 255, 255), Color(0, 0, 0);

local function Draw(self)
	local pos, ang = self:GetPos(), self:GetAngles();
    local dist     = pos:DistToSqr( LocalPlayer():GetPos() );
	
    if dist > 122500 then return end
	dist = math_sqrt( dist );
    
	color_white.a = 350 - dist;
    color_black.a = 350 - dist;
    
	ang:RotateAroundAxis( ang:Forward(), 90 );
	ang:RotateAroundAxis( ang:Right(), -90 );
    ang:RotateAroundAxis( ang:Right(), math_sin(CurTime() * math_pi) * -45 );

	local t = rp.Factions[self:GetFaction()].printName;

	cam_Start3D2D( pos + vec + ang:Right() * 1.2, ang, 0.065 );
	    draw_SimpleTextOutlined( t, '3d2d', 0, 0, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, color_black );
    cam_End3D2D();
    
    ang:RotateAroundAxis( ang:Right(), 180 );
    
	cam_Start3D2D( pos + vec + ang:Right() * 1.2, ang, 0.065 );
	    draw_SimpleTextOutlined( t, '3d2d', 0, 0, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, color_black );
	cam_End3D2D();
end

hook.Add( "PostDrawTranslucentRenderables", "rp.EmployerNPC.Render", function()
	for _, ent in ipairs( ents_FindByClass("npc_employer") ) do
		if not ent:ScreenVisible() then continue end
		Draw( ent );
	end
end );
]]--