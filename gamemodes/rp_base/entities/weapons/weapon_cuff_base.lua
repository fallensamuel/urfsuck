-- "gamemodes\\rp_base\\entities\\weapons\\weapon_cuff_base.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
-------------------------------------
---------------- Cuffs --------------
-------------------------------------
-- Copyright (c) 2015 Nathan Healy --
-------- All rights reserved --------
-------------------------------------
-- weapon_cuff_base.lua     SHARED --
--                                 --
-- Base swep for handcuffs.        --
-------------------------------------

AddCSLuaFile()

SWEP.Base = "weapon_base"

SWEP.Category = "Handcuffs"
SWEP.Author = "my_hat_stinks"
SWEP.Instructions = ""

SWEP.SelectorCategory = translates.Get("РОЛЕПЛЕЙ")

SWEP.Spawnable = false
SWEP.AdminOnly = false
SWEP.AdminSpawnable = false

SWEP.Slot = 3
SWEP.PrintName = "UnnamedHandcuff"

SWEP.ViewModelFOV = 60
SWEP.Weight = 5
SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false

SWEP.WorldModel = "models/weapons/w_toolgun.mdl"
SWEP.ViewModel = "models/weapons/c_bugbait.mdl"
SWEP.UseHands = true

SWEP.Primary.Recoil = 1
SWEP.Primary.Damage = 5
SWEP.Primary.NumShots = 1
SWEP.Primary.Cone = 0
SWEP.Primary.Delay = 0.25

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "none"
SWEP.Primary.ClipMax = -1

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"
SWEP.Secondary.ClipMax = -1

SWEP.DeploySpeed = 1.5

SWEP.Spawnable = false
SWEP.AdminSpawnable = false
SWEP.AdminOnly = false

SWEP.PrimaryAnim = ACT_VM_PRIMARYATTACK
SWEP.ReloadAnim = ACT_VM_RELOAD
SWEP.HoldType = "slam"

SWEP.Spawnable = false
SWEP.AdminSpawnable = false
SWEP.AdminOnly = false

//
// Handcuff Vars
SWEP.CuffTime = 1.0 // Seconds to handcuff
SWEP.CuffSound = Sound( "buttons/lever7.wav" )

SWEP.CuffMaterial = "phoenix_storms/metalfloor_2-3"
SWEP.CuffRope = "cable/cable2"

SWEP.CuffStrength = 1
SWEP.CuffRegen = 1
SWEP.RopeLength = 0

SWEP.CuffReusable = false // Can reuse (ie, not removed on use)
SWEP.CuffRecharge = 30 // Time before re-use

SWEP.CuffBlindfold = false
SWEP.CuffGag = false

SWEP.CuffStrengthVariance = 0 // Randomise strangth
SWEP.CuffRegenVariance = 0 // Randomise regen

//
// Network Vars
function SWEP:SetupDataTables()
	self:NetworkVar( "Bool", 0, "IsCuffing" )
	self:NetworkVar( "Entity", 0, "Cuffing" )
	self:NetworkVar( "Float", 0, "CuffTime" )
end

function SWEP:PreDrawViewModel( vm )
    vm:SetMaterial( "engine/occlusionproxy" );
end

if SERVER then
	util.AddNetworkString("DoPrimaryAttack")
	net.Receive("DoPrimaryAttack", function(len, ply)
		local swep = ply:GetActiveWeapon()
		if not IsValid(swep) or swep:GetNextPrimaryFire() > CurTime() or swep.CanPrimaryAttack and not swep:CanPrimaryAttack() then return end
		swep:PrimaryAttack()
	end)
end

//
// Standard SWEP functions
function SWEP:PrimaryAttack()
	if self:GetIsCuffing() then return end
	
	self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
	self:SetNextSecondaryFire( CurTime() + self.Primary.Delay )
	
	if CLIENT then return end
	if self:GetCuffTime()>CurTime() then return end // On cooldown
	
	local tr = self:TargetTrace()
	if not tr then return end
	
	self:SetCuffTime( CurTime() + (rp.cfg.InstantHandcuffs and 0.1 or self.CuffTime) )
	self:SetIsCuffing( true )
	self:SetCuffing( tr.Entity )
	
	sound.Play( self.CuffSound, self.Owner:GetShootPos(), 75, 100, 1 )
end
function SWEP:SecondaryAttack()
end
function SWEP:Reload()
end

function SWEP:Initialize()
	self:SetHoldType( self.HoldType )
	
	if engine.ActiveGamemode()=="dayz" then self.CuffReusable = false end
end
function SWEP:Holster()
	if CLIENT and IsValid(self.Owner) and self.Owner==LocalPlayer() then
		local vm = self.Owner:GetViewModel()
		if not IsValid(vm) then return end
		
		vm:SetMaterial( "" )
	end
	if IsValid(self.cmdl_RightCuff) then self.cmdl_RightCuff:Remove() end
	if IsValid(self.cmdl_LeftCuff) then self.cmdl_LeftCuff:Remove() end
	
	return true
end
SWEP.OnRemove = SWEP.Holster

if SERVER then
	hook.Add("CustomWeaponCheck", "Hancuffs::ForceNoBuild", function(ply, wep)
		if ply.ForceGivenCuff then
			ply.ForceGivenCuff = nil
			return true
		end
	end)
end

//
// Handcuff
function SWEP:DoHandcuff( target )
	if not (target and IsValid(target)) then return end
	if target:IsHandcuffed() then return end
	if not IsValid(self.Owner) then return end

	self.CuffedPlayers = self.CuffedPlayers or {}
	
	target:DropObject()
	
	if self.CuffNoBuild then
		target.ForceGivenCuff = true
	end
	
	local cuff = target:Give("weapon_handcuffed")
	if not IsValid(cuff) or not cuff.SetCuffStrength then return end
	
	cuff:SetCuffStrength( self.CuffStrength + (math.Rand(-self.CuffStrengthVariance,self.CuffStrengthVariance)) )
	cuff:SetCuffRegen( self.CuffRegen + (math.Rand(-self.CuffRegenVariance,self.CuffRegenVariance)) )
	
	cuff:SetCuffMaterial( self.CuffMaterial )
	cuff:SetRopeMaterial( self.CuffRope )
	
	cuff:SetKidnapper( self.Owner )
	cuff:SetRopeLength( self.RopeLength )
	
	cuff:SetCanBlind( self.CuffBlindfold )
	cuff:SetCanGag( self.CuffGag )
	
	cuff.CuffType = self:GetClass() or ""
	
	if self.ChangeModel then
		target:SetModel(self.ChangeModel)
	end
	
	hook.Call( "OnHandcuffed", GAMEMODE, self.Owner, target, cuff )
	
	if not self.CuffReusable then
		if IsValid(self.Owner) then self.Owner:ConCommand( "lastinv" ) end
		self:Remove()
	end
end

//
// Think
function SWEP:Think()
	if SERVER then
		if self:GetIsCuffing() then
			local tr = self:TargetTrace()
			if (not tr) or tr.Entity~=self:GetCuffing() then
				self:SetIsCuffing(false)
				self:SetCuffTime( 0 )
				return
			end
			
			if CurTime()>self:GetCuffTime() then
				self:SetIsCuffing( false )
				self:SetCuffTime( CurTime() + self.CuffRecharge )
				self:DoHandcuff( self:GetCuffing() )
			end
		end
	end
end

//
// Get Target
function SWEP:TargetTrace()
	if not IsValid(self.Owner) then return end
	
	local tr = util.TraceLine( {start=self.Owner:GetShootPos(), endpos=(self.Owner:GetShootPos() + (self.Owner:GetAimVector()*50)), filter={self, self.Owner}} )
	if IsValid(tr.Entity) and tr.Entity:IsPlayer() and tr.Entity~=self.Owner and not tr.Entity:IsHandcuffed() then
		if hook.Run( "CuffsCanHandcuff", self.Owner, tr.Entity )==false then return end
		return tr
	end
end

//
// UI
if CLIENT then
	local UIMat = {
		Cuffs = Material( "rpui/weapons/handcuffs" ),
	};

	local UICol = {
		White      = color_white,
		WhiteAlpha = Color( 255, 255, 255, 8 ),
		Black      = color_black,
		Background = Color( 0, 0, 0, 200 ),
		Blind      = Color( 0, 0, 0, 253 )
	};

	local UIText = (translates and translates.Get("Связывание...")) or "Связывание...";

	local CircleCache = {};

	local function GenerateCircle( x, y, radius, quality, startang, endang )
		startang  = startang  or 0;
		endang    = endang    or 360;
		quality   = quality   or 16;

		local crc = util.CRC( x .. y .. radius .. quality .. startang .. endang );
		local cached = CircleCache[crc];
		if cached then
			return cached;
		end

		local vertices = { { x = x, y = y } };

		quality = quality - 1;

		local diffang = endang - startang;

		local v = {};
		for i = 0, quality do
			v = {};

			local step = i / quality;
			local a = math.rad( startang + diffang * step );

			v.x = x + math.sin( a ) * radius;
			v.y = y - math.cos( a ) * radius;

			table.insert( vertices, v );
		end

		CircleCache[crc] = vertices;
		return vertices;
	end

	local function RichCircle( x, y, radius, quality, thickness, startang, endang )
		thickness = thickness or radius;

		local isHollow = ( radius > thickness );
		local distance = radius * 2;

		if isHollow then
			local drawColor = surface.GetDrawColor();
			surface.SetDrawColor( color_white );

			render.SetStencilWriteMask( 0xFF );
			render.SetStencilTestMask( 0xFF );
			render.SetStencilReferenceValue( 0 );
			render.SetStencilPassOperation( STENCIL_KEEP );
			render.SetStencilZFailOperation( STENCIL_KEEP );
			render.ClearStencil();

			render.SetStencilEnable( true );
				render.SetStencilReferenceValue( 1 );
				render.SetStencilCompareFunction( STENCIL_NEVER );
				render.SetStencilFailOperation( STENCIL_REPLACE );
				-- Outer Circle:
					surface.DrawPoly(
						GenerateCircle( x, y, radius, quality, startang, endang )
					);
				--

				render.SetStencilReferenceValue( 0 );
				render.SetStencilCompareFunction( STENCIL_NEVER );
				render.SetStencilFailOperation( STENCIL_REPLACE );
				-- Inner Circle:
					surface.DrawPoly(
						GenerateCircle( x, y, radius - thickness, quality, startang, endang )
					);
				--
				
				render.SetStencilReferenceValue( 1 );
				render.SetStencilCompareFunction( STENCIL_EQUAL );
				render.SetStencilFailOperation( STENCIL_KEEP );
				-- Main Render:
					surface.SetDrawColor( drawColor );
					surface.DrawRect( x - radius, y - radius, distance, distance );
				--
			render.SetStencilEnable( false );
			
			return
		end

		surface.DrawPoly(
			GenerateCircle( x, y, radius, quality, startang, endang )
		);
	end

	local scr_w, scr_h = ScrW(), ScrH();
	local cir_radius, cir_thickness, lay_margin = scr_h * 0.05, scr_h * 0.01, scr_h * 0.0075;
	local cir_radiushalf = cir_radius * 0.5;

	surface.CreateFont( "Cuffs.Default", {
		font     = "Montserrat",
		size     = scr_h * 0.02,
		extended = true,
	} );

	function SWEP:DrawHUD()
		local x, y = scr_w * 0.5, scr_h * 0.5;

		if not self:GetIsCuffing() then
--			if self:GetCuffTime() <= CurTime() then return end
--
--			-- Delta:
--			-- self.hud_dt = Lerp(
--			-- 	RealFrameTime() * 4,
--			-- 	self.hud_dt or 0,
--			-- 	math.Clamp( ((self:GetCuffTime() - CurTime()) / self.CuffRecharge), 0, 1 )
--			-- );
--			-- 
--			-- local dt = self.hud_dt;
--
--			-- Progress Bar:
--			-- surface.SetDrawColor( UICol.Background );
--    		-- RichCircle( x, y, cir_radius, 32, cir_thickness, -90, 90 );
--
--			-- Icon:
--			surface.SetDrawColor( UICol.White );
--			surface.SetMaterial( UIMat.Cuffs );
--			surface.DrawTexturedRect( x - cir_radiushalf, y - cir_radiushalf, cir_radius, cir_radius );	
--
--			-- Progress Bar (Fill):
--			-- surface.SetDrawColor( HSVToColor( 120 * dt, 1, 1 ) );
--			-- RichCircle( x, y, cir_radius, 32, cir_thickness, -125, -125 + 250 * dt );
--
			return
		end

		-- Delta:
		self.hud_dt = Lerp(
			RealFrameTime() * 4,
			self.hud_dt or 0,
			math.Clamp( 1 - ((self:GetCuffTime() - CurTime()) / (rp.cfg.InstantHandcuffs and 0.1 or self.CuffTime)), 0, 1 )
		);

		local dt = self.hud_dt;

		-- Progress Bar:
		surface.SetDrawColor( UICol.Background );
		RichCircle( x, y, cir_radius, 32, cir_thickness, -90, 90 );

		-- Icon:
		surface.SetDrawColor( UICol.WhiteAlpha );
		surface.SetMaterial( UIMat.Cuffs );
		surface.DrawTexturedRect( x - cir_radiushalf, y - cir_radiushalf, cir_radius, cir_radius );	

		-- Progress Bar (Fill):
		surface.SetDrawColor( HSVToColor( 120 * dt, 1, 1 ) );
		RichCircle( x, y, cir_radius, 32, cir_thickness, -90, -90 + 180 * dt );

		-- Text:
		y = y + cir_radiushalf + lay_margin;
		local _, th = draw.SimpleTextOutlined( UIText, "Cuffs.Default", x, y, UICol.White, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 2, UICol.Black );
	end
end

--[[
//
// Old UI
local Col = {
	Text = Color(255,255,255), TextShadow = Color(0,0,0),
	
	BoxOutline = Color(0,0,0), BoxBackground = Color(255,255,255,20), BoxLeft = Color(255,0,0), BoxRight = Color(0,255,0),
}
local matGrad = Material( "gui/gradient" )

--local cached

local Text = (translates and translates.Get('Связывание...')) or 'Связывание...';

function SWEP:DrawHUD()
	if not self:GetIsCuffing() then
		if self:GetCuffTime()<=CurTime() then return end
		
		local w,h = (ScrW()/2), (ScrH()/2)
		
		surface.SetDrawColor( Col.BoxOutline )
		surface.DrawOutlinedRect( w-101, h+54, 202, 22 )
		surface.SetDrawColor( Col.BoxBackground )
		surface.DrawRect( w-100, h+55, 200, 20 )
		
		local CuffingPercent = math.Clamp( ((self:GetCuffTime()-CurTime())/self.CuffRecharge), 0, 1 )
		render.SetScissorRect( w-100, h+55, (w-100)+(CuffingPercent*200), h+75, true )
			surface.SetDrawColor( Col.BoxRight )
			surface.DrawRect( w-100,h+55, 200,20 )
			
			surface.SetMaterial( matGrad )
			surface.SetDrawColor( Col.BoxLeft )
			surface.DrawTexturedRect( w-100,h+55, 200,20 )
		render.SetScissorRect( 0,0,0,0, false )
		
		return
	end
	
	local w,h = (ScrW()/2), (ScrH()/2)
	
	--if not cached then
	--	cached = translates and translates.Get( 'Надеваю наручники...' ) or 'Надеваю наручники...'
	--end
	
	draw.SimpleText( Text, "HandcuffsText", w+1, h+31, Col.TextShadow, TEXT_ALIGN_CENTER )
	draw.SimpleText( Text, "HandcuffsText", w, h+30, Col.Text, TEXT_ALIGN_CENTER )
	
	surface.SetDrawColor( Col.BoxOutline )
	surface.DrawOutlinedRect( w-101, h+54, 202, 22 )
	surface.SetDrawColor( Col.BoxBackground )
	surface.DrawRect( w-100, h+55, 200, 20 )
	
	local CuffingPercent = math.Clamp( 1-((self:GetCuffTime()-CurTime())/(rp.cfg.InstantHandcuffs and 0.1 or self.CuffTime)), 0, 1 )
	
	render.SetScissorRect( w-100, h+55, (w-100)+(CuffingPercent*200), h+75, true )
		surface.SetDrawColor( Col.BoxRight )
		surface.DrawRect( w-100,h+55, 200,20 )
		
		surface.SetMaterial( matGrad )
		surface.SetDrawColor( Col.BoxLeft )
		surface.DrawTexturedRect( w-100,h+55, 200,20 )
	render.SetScissorRect( 0,0,0,0, false )
end
]]--

function SWEP:PostDrawViewModel( vm )
    vm:SetMaterial( "" );
end

//
// Rendering
local renderpos = {
	left = {pos=Vector(0,0,0), vel=Vector(0,0,0), gravity=1, ang=Angle(0,30,90)},
	right = {bone = "ValveBiped.Bip01_R_Hand", pos=Vector(3.2,2.1,0.4), ang=Angle(-2,0,80), scale = Vector(0.045,0.045,0.03)},
	rope = {l = Vector(0,0,2.0), r = Vector(2.3,-1.9,2.7)},
}
local CuffMdl = "models/hunter/tubes/tube2x2x1.mdl"
local RopeCol = Color(255,255,255)
function SWEP:ViewModelDrawn( vm )
	if not IsValid(vm) then return end
	
	--vm:SetMaterial( "engine/occlusionproxy" )
	vm:SetColor(Color(255, 255, 255, 1))
	--vm:SetMaterial("Debug/hsv")
	
	if not IsValid(self.cmdl_LeftCuff) then
		self.cmdl_LeftCuff = ClientsideModel( CuffMdl, RENDER_GROUP_VIEW_MODEL_OPAQUE )
		self.cmdl_LeftCuff:SetNoDraw( true )
		self.cmdl_LeftCuff:SetParent( vm )
		
		renderpos.left.pos = self.Owner:GetPos()
	end
	if not IsValid(self.cmdl_RightCuff) then
		self.cmdl_RightCuff = ClientsideModel( CuffMdl, RENDER_GROUP_VIEW_MODEL_OPAQUE )
		self.cmdl_RightCuff:SetNoDraw( true )
		self.cmdl_RightCuff:SetParent( vm )
	end
	
	-- local lpos, lang = self:GetBonePos( renderpos.left.bone, vm )
	local rpos, rang = self:GetBonePos( renderpos.right.bone, vm )
	if not (rpos and rang) then return end
	
	// Right
	local fixed_rpos = rpos + (rang:Forward()*renderpos.right.pos.x) + (rang:Right()*renderpos.right.pos.y) + (rang:Up()*renderpos.right.pos.z)
	self.cmdl_RightCuff:SetPos( fixed_rpos )
	local u,r,f = rang:Up(), rang:Right(), rang:Forward() // Prevents moving axes
	rang:RotateAroundAxis( u, renderpos.right.ang.y )
	rang:RotateAroundAxis( r, renderpos.right.ang.p )
	rang:RotateAroundAxis( f, renderpos.right.ang.r )
	self.cmdl_RightCuff:SetAngles( rang )
	
	local matrix = Matrix()
	matrix:Scale( renderpos.right.scale )
	self.cmdl_RightCuff:EnableMatrix( "RenderMultiply", matrix )
	
	self.cmdl_RightCuff:SetMaterial( self.CuffMaterial )
	self.cmdl_RightCuff:DrawModel()
	
	// Left
	if CurTime()>(renderpos.left.NextThink or 0) then
		local dist = renderpos.left.pos:Distance( fixed_rpos )
		if dist>100 then
			renderpos.left.pos = fixed_rpos
			renderpos.left.vel = Vector(0,0,0)
		elseif dist > 10 then
			local target = (fixed_rpos - renderpos.left.pos)*0.3
			renderpos.left.vel.x = math.Approach( renderpos.left.vel.x, target.x, 1 )
			renderpos.left.vel.y = math.Approach( renderpos.left.vel.y, target.y, 1 )
			renderpos.left.vel.z = math.Approach( renderpos.left.vel.z, target.z, 3 )
		end
		
		renderpos.left.vel.x = math.Approach( renderpos.left.vel.x, 0, 0.5 )
		renderpos.left.vel.y = math.Approach( renderpos.left.vel.y, 0, 0.5 )
		renderpos.left.vel.z = math.Approach( renderpos.left.vel.z, 0, 0.5 )
		-- if renderpos.left.vel:Length()>10 then renderpos.left.vel:Mul(0.1) end
		
		local targetZ = ((fixed_rpos.z - 10) - renderpos.left.pos.z) * renderpos.left.gravity
		renderpos.left.vel.z = math.Approach( renderpos.left.vel.z, targetZ, 3 )
		
		renderpos.left.pos:Add( renderpos.left.vel )
		
		-- renderpos.left.NextThink = CurTime()+0.01
	end
	
	self.cmdl_LeftCuff:SetPos( renderpos.left.pos )
	self.cmdl_LeftCuff:SetAngles( renderpos.left.ang )
	
	-- self.cmdl_LeftCuff:SetAngles( rang )
	local matrix = Matrix()
	matrix:Scale( renderpos.right.scale )
	self.cmdl_LeftCuff:EnableMatrix( "RenderMultiply", matrix )
	
	self.cmdl_LeftCuff:SetMaterial( self.CuffMaterial )
	self.cmdl_LeftCuff:DrawModel()
	
	// Rope
	if not self.RopeMat then self.RopeMat = Material(self.CuffRope) end
	
	render.SetMaterial( self.RopeMat )
	render.DrawBeam( renderpos.left.pos + renderpos.rope.l,
		rpos + (rang:Forward()*renderpos.rope.r.x) + (rang:Right()*renderpos.rope.r.y) + (rang:Up()*renderpos.rope.r.z),
		0.7, 0, 5, RopeCol )
end

SWEP.wrender = {
	left = {pos=Vector(0,0,0), vel=Vector(0,0,0), gravity=1, ang=Angle(0,30,90)},
	right = {bone = "ValveBiped.Bip01_R_Hand", pos=Vector(2.95,2.5,-0.2), ang=Angle(30,0,90), scale = Vector(0.044,0.044,0.044)},
	rope = {l = Vector(0,0,2), r = Vector(3,-1.65,1)},
}
function SWEP:DrawWorldModel()
	if not IsValid(self.Owner) then return end
	local wrender = self.wrender
	
	if not IsValid(self.cmdl_LeftCuff) then
		self.cmdl_LeftCuff = ClientsideModel( CuffMdl, RENDER_GROUP_VIEW_MODEL_OPAQUE )
		self.cmdl_LeftCuff:SetNoDraw( true )
	end
	if not IsValid(self.cmdl_RightCuff) then
		self.cmdl_RightCuff = ClientsideModel( CuffMdl, RENDER_GROUP_VIEW_MODEL_OPAQUE )
		self.cmdl_RightCuff:SetNoDraw( true )
	end
	
	local rpos, rang = self:GetBonePos( wrender.right.bone, self.Owner )
	if not (rpos and rang) then return end
	
	// Right
	local fixed_rpos = rpos + (rang:Forward()*wrender.right.pos.x) + (rang:Right()*wrender.right.pos.y) + (rang:Up()*wrender.right.pos.z)
	self.cmdl_RightCuff:SetPos( fixed_rpos )
	local u,r,f = rang:Up(), rang:Right(), rang:Forward() // Prevents moving axes
	rang:RotateAroundAxis( u, wrender.right.ang.y )
	rang:RotateAroundAxis( r, wrender.right.ang.p )
	rang:RotateAroundAxis( f, wrender.right.ang.r )
	self.cmdl_RightCuff:SetAngles( rang )
	
	local matrix = Matrix()
	matrix:Scale( wrender.right.scale )
	self.cmdl_RightCuff:EnableMatrix( "RenderMultiply", matrix )
	
	self.cmdl_RightCuff:SetMaterial( self.CuffMaterial )
	self.cmdl_RightCuff:DrawModel()
	
	// Left
	if CurTime()>(wrender.left.NextThink or 0) then
		local dist = wrender.left.pos:Distance( fixed_rpos )
		if dist>100 then
			wrender.left.pos = fixed_rpos
			wrender.left.vel = Vector(0,0,0)
		elseif dist > 10 then
			local target = (fixed_rpos - wrender.left.pos)*0.3
			wrender.left.vel.x = math.Approach( wrender.left.vel.x, target.x, 1 )
			wrender.left.vel.y = math.Approach( wrender.left.vel.y, target.y, 1 )
			wrender.left.vel.z = math.Approach( wrender.left.vel.z, target.z, 3 )
		end
		
		wrender.left.vel.x = math.Approach( wrender.left.vel.x, 0, 0.5 )
		wrender.left.vel.y = math.Approach( wrender.left.vel.y, 0, 0.5 )
		wrender.left.vel.z = math.Approach( wrender.left.vel.z, 0, 0.5 )
		-- if wrender.left.vel:Length()>10 then wrender.left.vel:Mul(0.1) end
		
		local targetZ = ((fixed_rpos.z - 10) - wrender.left.pos.z) * wrender.left.gravity
		wrender.left.vel.z = math.Approach( wrender.left.vel.z, targetZ, 3 )
		
		wrender.left.pos:Add( wrender.left.vel )
		
		-- wrender.left.NextThink = CurTime()+0
	end
	
	self.cmdl_LeftCuff:SetPos( wrender.left.pos )
	self.cmdl_LeftCuff:SetAngles( wrender.left.ang )
	
	local matrix = Matrix()
	matrix:Scale( wrender.right.scale )
	self.cmdl_LeftCuff:EnableMatrix( "RenderMultiply", matrix )
	
	self.cmdl_LeftCuff:SetMaterial( self.CuffMaterial )
	self.cmdl_LeftCuff:DrawModel()
	
	// Rope
	if not self.RopeMat then self.RopeMat = Material(self.CuffRope) end
	
	render.SetMaterial( self.RopeMat )
	render.DrawBeam( wrender.left.pos + wrender.rope.l,
		rpos + (rang:Forward()*wrender.rope.r.x) + (rang:Right()*wrender.rope.r.y) + (rang:Up()*wrender.rope.r.z),
		0.7, 0, 5, RopeCol )
end

//
// Bones
function SWEP:GetBonePos( bonename, vm )
	local bone = vm:LookupBone( bonename )
	if not bone then return end
	
	local pos,ang = Vector(0,0,0),Angle(0,0,0)
	local matrix = vm:GetBoneMatrix( bone )
	if matrix then
		pos = matrix:GetTranslation()
		ang = matrix:GetAngles()
	end
	
	if self.ViewModelFlip then ang.r = -ang.r end
	
	-- if pos.x==0 and pos.y==0 and pos.z==0 then print( bonename, vm ) end
	return pos, ang
end

for _, ent in pairs( ents.FindByClass("func_ladder") ) do
	ent:SetCustomCollisionCheck(true)
end

hook.Add("PlayerPostThink", "HandCuffsThink", function(ply)
	if (ply.NextHandCuffsThink or 0) > CurTime() then return end
	ply.NextHandCuffsThink = CurTime() + 1
	if ply.IsHandcuffed and not ply:IsHandcuffed() then return end

	if ply:GetMoveType() == MOVETYPE_LADDER then
		ply:SetMoveType(MOVETYPE_WALK)
	end
end)