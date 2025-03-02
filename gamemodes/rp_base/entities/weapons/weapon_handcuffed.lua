-- "gamemodes\\rp_base\\entities\\weapons\\weapon_handcuffed.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
-------------------------------------
---------------- Cuffs --------------
-------------------------------------
-- Copyright (c) 2015 Nathan Healy --
-------- All rights reserved --------
-------------------------------------
-- weapon_handcuffed.lua    SHARED --
--                                 --
-- Handcuffed. Limits what         --
-- equipping player can do.        --
-------------------------------------

AddCSLuaFile()

SWEP.Base = "weapon_base"

SWEP.Category = "Handcuffs"
SWEP.Author = "my_hat_stinks"
SWEP.Instructions = ""

SWEP.Spawnable = false
SWEP.AdminSpawnable = false
SWEP.AdminOnly = false

SWEP.Slot = 4
SWEP.PrintName = "Handcuffed"

SWEP.ViewModelFOV = 60
SWEP.Weight = 5
SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false

SWEP.WorldModel = "models/weapons/w_toolgun.mdl"
SWEP.ViewModel = "models/weapons/c_arms_citizen.mdl"
SWEP.UseHands = true

SWEP.Primary.Recoil = 1
SWEP.Primary.Damage = 5
SWEP.Primary.NumShots = 1
SWEP.Primary.Cone = 0
SWEP.Primary.Delay = 1

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"
SWEP.Primary.ClipMax = -1

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"
SWEP.Secondary.ClipMax = -1

SWEP.DeploySpeed = 1.5

SWEP.PrimaryAnim = ACT_VM_PRIMARYATTACK
SWEP.ReloadAnim = ACT_VM_RELOAD
SWEP.HoldType = "duel"

SWEP.IsHandcuffs = true
SWEP.CuffType = ""

CreateConVar( "cuffs_allowbreakout", 1, {FCVAR_ARCHIVE,FCVAR_SERVER_CAN_EXECUTE,FCVAR_REPLICATED,FCVAR_NOTIFY} )


-- For anything that might try to drop this
SWEP.CanDrop = false
SWEP.PreventDrop = true
-- Missing anything?


-- DataTables
function SWEP:SetupDataTables()
	self:NetworkVar( "Entity", 0, "Kidnapper" );
	self:NetworkVar( "Entity", 1, "FriendBreaking" );

	self:NetworkVar( "Float", 0, "RopeLength" );
	self:NetworkVar( "Float", 1, "CuffBroken" );
	self:NetworkVar( "Float", 2, "CuffStrength" );
	self:NetworkVar( "Float", 3, "CuffRegen" );

	self:NetworkVar( "String", 0, "RopeMaterial" );
	self:NetworkVar( "String", 1, "CuffMaterial" );

	self:NetworkVar( "Bool", 0, "CanBreakout" );

	self:NetworkVar( "Bool", 1, "CanGag" );
	self:NetworkVar( "Bool", 2, "IsGagged" );

	self:NetworkVar( "Bool", 3, "CanBlind" );
	self:NetworkVar( "Bool", 4, "IsBlind" );
end


-- Initialize
function SWEP:Initialize()
	hook.Add( "canDropWeapon", self, function( wep, ply )
		if wep == self then return false end
	end ); -- Thank you DarkRP, your code is terrible

	if self:GetCuffStrength() <= 0 then self:SetCuffStrength( 1 ); end
	if self:GetCuffRegen() <= 0 then self:SetCuffRegen( 1 ); end

	self:SetCuffBroken( 0 );
	self:SetHoldType( self.HoldType );
end


-- Equip and Holster
function SWEP:Equip( newOwner )
	newOwner:SelectWeapon( self:GetClass() );

	timer.Simple( 0.1, function() -- Fucking FA:S
		if IsValid( self ) and IsValid( newOwner ) and newOwner:GetActiveWeapon() ~= self then
			local wep = newOwner:GetActiveWeapon();
			if not IsValid( wep ) then return end

			local oHolster = wep.Holster;
			wep.Holster = function() return true end
			newOwner:SelectWeapon( self:GetClass() );
			wep.Holster = oHolster;
		end
	end );

	self:Cuff();

	return true
end

function SWEP:Holster()
	return false
end


-- Deploy
function SWEP:Deploy()
	local viewModel = self.Owner:GetViewModel();
	viewModel:SendViewModelMatchingSequence( viewModel:LookupSequence("fists_idle_01") );

	return true
end

function SWEP:PreDrawViewModel( viewModel ) -- Fixes visible base hands
	viewModel:SetMaterial( "engine/occlusionproxy" );
end

function SWEP:OnRemove() -- Fixes invisible other weapons
	if self.hook_uid then
		hook.Remove( "PostEntityTakeDamage", self.hook_uid );
		hook.Remove( "PlayerPushed", self.hook_uid );
		hook.Remove( "Tick", self.hook_uid );
	end

	if IsValid( self.Owner ) then
		local viewModel = self.Owner:GetViewModel();

		if IsValid( viewModel ) then
			viewModel:SetMaterial( "" );
		end
	end

	if IsValid( self.cmdl_LeftCuff ) then self.cmdl_LeftCuff:Remove(); end
	if IsValid( self.cmdl_RightCuff ) then self.cmdl_RightCuff:Remove(); end

	return true
end


-- Cuff / Uncuff
function SWEP:Cuff()
	self.NextBreakout = CurTime() + (rp.cfg.CuffsBreakoutStay or 5);

	self.hook_uid = self:GetClass() .. self:EntIndex();

	hook.Add( "PostEntityTakeDamage", self.hook_uid, function( ply, dmg, took )
		if not took then return end

		if not IsValid( ply ) then return end
		if not IsValid( self.Owner ) then return end

		if ply == self.Owner then
			local nb = CurTime() + (rp.cfg.CuffsBreakoutDelay or 5);
			if nb > self.NextBreakout then self.NextBreakout = nb; end
		end
	end );

	hook.Add( "PlayerPushed", self.hook_uid, function( ply, pusher )
		if not IsValid( ply ) then return end
		if not IsValid( self.Owner ) then return end

		if ply == self.Owner then
			local nb = CurTime() + (rp.cfg.CuffsBreakoutDelay or 5);
			if nb > self.NextBreakout then self.NextBreakout = nb; end
		end
	end );

	hook.Add( "Tick", self.hook_uid, function()
		if (self.NextTick or 0) > CurTime() then return end

		if not IsValid( self.Owner ) then return end
		if type(self:GetKidnapper()) == "Entity" then return end

		if self.prevOwnerVel and (self.prevOwnerVel ~= self.Owner:GetVelocity()) then
			local nb = CurTime() + (rp.cfg.CuffsBreakoutDelay or 5);
			if nb > self.NextBreakout then self.NextBreakout = nb; end
		end

		self.prevOwnerVel, self.NextTick = self.Owner:GetVelocity(), CurTime() + 0.25;
	end );
end

function SWEP:Uncuff()
	local ply = IsValid( self.Owner ) and self.Owner;

	if ply then
		ply:ConCommand( "lastinv" );
	end

	self:Remove();
end


-- Standard SWEP functions
function SWEP:PrimaryAttack()
	if SERVER then self:AttemptBreak(); end
end

function SWEP:SecondaryAttack()
end

function SWEP:Reload()
end


-- Breakout
if SERVER then
	local BreakSound = Sound( "physics/metal/metal_barrel_impact_soft4.wav" );
	local IsValid = FindMetaTable("Entity").IsValid

	function SWEP:AttemptBreak()
		if not cvars.Bool( "cuffs_allowbreakout" ) then
			return
		end

		if not self:GetCanBreakout() then
			return
		end

		local CT = CurTime();

		if self.NextBreakout and (self.NextBreakout < CT) then
			if self:GetCuffBroken() >= 65 then
				if IsValid( self:GetOwner() ) and self:GetOwner().IsCooldownAction and self:GetOwner():IsCooldownAction( "CuffBreaker", 0.04 ) then
					return
				end
			end

			if (CT - (self.CPSTimestamp or 0)) > 1 then
				self.CPSTimestamp = CT;
				self.CPS = 0;
			end

			if self.CPS > 8 then return	end

			self.CPS = self.CPS + 1;

			self:SetCuffBroken( self:GetCuffBroken() + math.abs(4 / self:GetCuffStrength()) );

			if self:GetCuffBroken() >= 100 then
				self:Breakout();
			end
		end
	end

	local function GetTrace( ply )
		local eyePos = ply:EyePos();

		local tr = util.TraceLine( {
			start  = eyePos,
			endpos = eyePos + ply:GetAimVector() * 100,
			filter = ply
		} );

		if IsValid( tr.Entity ) and tr.Entity:IsPlayer() then
			local cuffed, wep = tr.Entity:IsHandcuffed();
			if cuffed then
				return tr, wep
			end
		end
	end

	function SWEP:Think()
		local CT = CurTime();

		if (self.NextRegen or 0) <= CT then
			if self.NextBreakout > CT then
				if self:GetCanBreakout() then
					self:SetCanBreakout( false );
				end
			else
				if not self:GetCanBreakout() then
					self:SetCanBreakout( true );
				end
			end

			local regen, friend = self:GetCuffRegen(), self:GetFriendBreaking();

			if IsValid( friend ) and friend:IsPlayer() then
				local tr = GetTrace( friend );
				if tr and tr.Entity == self.Owner then
					regen = (regen * 0.5) - (2 / self:GetCuffStrength());
				else
					self:SetFriendBreaking( nil );
				end
			end

			self:SetCuffBroken(
				math.Approach( self:GetCuffBroken(), regen < 0 and 100 or 0, math.abs(regen) )
			);

			if self:GetCuffBroken() >= 100 then
				self:Breakout();
				return
			end

			self.NextRegen = CT + 0.05;
		end

		if IsValid( self:GetKidnapper() ) and (self:GetKidnapper():IsPlayer() and (not self:GetKidnapper():Alive())) then
			self:SetKidnapper( nil );
		end

		if IsValid( self.Owner ) then
			self.Owner.KnockoutTimer = CT + 10; -- Fucking DarkRP
		end
	end

	function SWEP:Breakout()
		if IsValid( self.Owner ) then
			sound.Play( BreakSound, self.Owner:GetShootPos(), 75, 100, 1 );
			hook.Call( "OnHandcuffBreak", GAMEMODE, self.Owner, self, IsValid(self:GetFriendBreaking()) and self:GetFriendBreaking() or nil );
		end

		self:Uncuff();
	end
end


-- UI
if CLIENT then
	local UIText = ( translates and {
		"", -- translates.Get( "Ваши руки %sсвязаны" ),
		translates.Get( "крепко" ),
		translates.Get( "слабо" ),
		"", -- translates.Get( "%s материалом" ),
		translates.Get( "прочным" ),
		translates.Get( "тонким" ),
		translates.Get( "Вам завязали глаза" ),
		translates.Get( "Вам заткнули рот" ),
		"", -- translates.Get( "[%s] Сопротивляться" ),
		translates.Get( "ЛКМ" ),
	} ) or {
		"Ваши руки %sсвязаны",
		"крепко ",
		"слабо ",
		"%s материалом",
		" прочным",
		" тонким",
		"Вам завязали глаза",
		"Вам заткнули рот",
		"[%s] Сопротивляться",
		"ЛКМ",
	};

	local UIMat = {
		Cuffs = Material( "rpui/weapons/handcuffs" ),
	};

	local UICol = {
		White      = color_white,
		Black      = color_black,
		Background = Color( 0, 0, 0, 200 ),
		Blind      = Color( 0, 0, 0, 254 )
	};

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
	local cir_radius, cir_thickness, lay_margin = scr_h * 0.075, scr_h * 0.0125, scr_h * 0.0125;
	local cir_radiushalf = cir_radius * 0.5;

	surface.CreateFont( "Cuffs.Large", {
		font     = "Montserrat",
		size     = scr_h * 0.03,
		extended = true,
	} );

	surface.CreateFont( "Cuffs.Default", {
		font     = "Montserrat",
		size     = scr_h * 0.02,
		extended = true,
	} );

	function SWEP:DrawHUD()
		local x, y = scr_w * 0.5, scr_h * 0.8;

		-- Delta:
		self.hud_dt = Lerp(
			RealFrameTime() * 4,
			self.hud_dt or 0,
			math.min( self:GetCuffBroken() * 0.01, 1 )
		);

		local dt = self.hud_dt;

		-- Progress Bar:
		surface.SetDrawColor( UICol.Background );
    	RichCircle( x, y, cir_radius, 32, cir_thickness, -125, 125 );

		-- Icon:
		if self:GetCanBreakout() then
			if math.Round( dt, 2 ) == 0 then
				surface.SetDrawColor( Color( 255, 255, 255,
					128 + math.sin( SysTime() * 3 ) * 127
				) );
			else
				surface.SetDrawColor( UICol.White );
			end
		end

		surface.SetMaterial( UIMat.Cuffs );
    	surface.DrawTexturedRect( x - cir_radiushalf, y - cir_radiushalf, cir_radius, cir_radius );

		-- Progress Bar (Fill):
		surface.SetDrawColor( HSVToColor( 120 * dt, 1, 1 ) );
    	RichCircle( x, y, cir_radius, 32, cir_thickness, -125, -125 + 250 * dt );

		-- Text:
		local str = translates.Get( "Ваши руки %sсвязаны",
			((self:GetCuffStrength() > 1.2) and UIText[2]) or ((self:GetCuffStrength() < 0.8) and UIText[3]) or ""
		);

		if (self:GetCuffRegen() > 1.2) or (self:GetCuffRegen() < 0.8) then
			str = str .. translates.Get( "%s материалом", (self:GetCuffRegen() > 1.2) and UIText[5] or UIText[6] );
		end

		y = y + cir_radiushalf + lay_margin;
		local _, th = draw.SimpleTextOutlined( str, "Cuffs.Large", x, y, UICol.White, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 2, UICol.Black );

		if cvars.Bool( "cuffs_allowbreakout" ) and self:GetCanBreakout() then
			y = y + th * 1.25;
			str = translates.Get( "[%s] Сопротивляться", UIText[10] );
			local _, th = draw.SimpleTextOutlined( str, "Cuffs.Default", x, y, UICol.White, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, UICol.Black );
		end

		if self:GetIsBlind() then
			y = y + th * 1.25;
			local _, th = draw.SimpleTextOutlined( UIText[7], "Cuffs.Default", x, y, UICol.White, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, UICol.Black );
		end

		if self:GetIsGagged() then
			y = y + th * 1.25;
			local _, th = draw.SimpleTextOutlined( UIText[8], "Cuffs.Default", x, y, UICol.White, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, UICol.Black );
		end
	end

	function SWEP:DrawHUDBackground()
		if self:GetIsBlind() then
			surface.SetDrawColor( UICol.Blind );
			surface.DrawRect( 0, 0, scr_w, scr_h );
		end
	end
end


-- Rendering
local renderpos = {
	left = {bone = "ValveBiped.Bip01_L_Wrist", pos=Vector(0.4,-0.15,-0.45), ang=Angle(90,0,0), scale = Vector(0.035,0.035,0.015)},
	right = {bone = "ValveBiped.Bip01_R_Wrist", pos=Vector(0.2,-0.15,0.35), ang=Angle(100,0,0), scale = Vector(0.035,0.035,0.015)},
	rope = {l = Vector(-0.2,1.3,-0.25), r = Vector(0.4,1.4,-0.2)},
}
local CuffMdl = "models/hunter/tubes/tube2x2x1.mdl"
local DefaultRope = "cable/cable2"
local RopeCol = Color(255,255,255)
function SWEP:ViewModelDrawn( vm )
	if not IsValid(vm) then return end

	if not IsValid(self.cmdl_LeftCuff) then
		self.cmdl_LeftCuff = ClientsideModel( CuffMdl, RENDER_GROUP_VIEW_MODEL_OPAQUE )
		self.cmdl_LeftCuff:SetNoDraw( true )
		self.cmdl_LeftCuff:SetParent( vm )
	end
	if not IsValid(self.cmdl_RightCuff) then
		self.cmdl_RightCuff = ClientsideModel( CuffMdl, RENDER_GROUP_VIEW_MODEL_OPAQUE )
		self.cmdl_RightCuff:SetNoDraw( true )
		self.cmdl_RightCuff:SetParent( vm )
	end

	local lpos, lang = self:GetBonePos( renderpos.left.bone, vm )
	local rpos, rang = self:GetBonePos( renderpos.right.bone, vm )
	if not (lpos and rpos and lang and rang) then return end

	-- Left
	self.cmdl_LeftCuff:SetPos( lpos + (lang:Forward()*renderpos.left.pos.x) + (lang:Right()*renderpos.left.pos.y) + (lang:Up()*renderpos.left.pos.z) )
	local u,r,f = lang:Up(), lang:Right(), lang:Forward() -- Prevents moving axes
	lang:RotateAroundAxis( u, renderpos.left.ang.y )
	lang:RotateAroundAxis( r, renderpos.left.ang.p )
	lang:RotateAroundAxis( f, renderpos.left.ang.r )
	self.cmdl_LeftCuff:SetAngles( lang )

	local matrix = Matrix()
	matrix:Scale( renderpos.left.scale )
	self.cmdl_LeftCuff:EnableMatrix( "RenderMultiply", matrix )

	self.cmdl_LeftCuff:SetMaterial( self:GetCuffMaterial() or "" )
	self.cmdl_LeftCuff:DrawModel()

	-- Right
	self.cmdl_RightCuff:SetPos( rpos + (rang:Forward()*renderpos.right.pos.x) + (rang:Right()*renderpos.right.pos.y) + (rang:Up()*renderpos.right.pos.z) )
	local u,r,f = rang:Up(), rang:Right(), rang:Forward() -- Prevents moving axes
	rang:RotateAroundAxis( u, renderpos.right.ang.y )
	rang:RotateAroundAxis( r, renderpos.right.ang.p )
	rang:RotateAroundAxis( f, renderpos.right.ang.r )
	self.cmdl_RightCuff:SetAngles( rang )

	local matrix = Matrix()
	matrix:Scale( renderpos.right.scale )
	self.cmdl_RightCuff:EnableMatrix( "RenderMultiply", matrix )

	self.cmdl_RightCuff:SetMaterial( self:GetCuffMaterial() or "" )
	self.cmdl_RightCuff:DrawModel()

	-- Rope
	if self:GetRopeMaterial()~=self.LastMatStr then
		self.RopeMat = Material( self:GetRopeMaterial() )
		self.LastMatStr = self:GetRopeMaterial()
	end
	if not self.RopeMat then self.RopeMat = Material(DefaultRope) end

	render.SetMaterial( self.RopeMat )
	render.DrawBeam( lpos + (lang:Forward()*renderpos.rope.l.x) + (lang:Right()*renderpos.rope.l.y) + (lang:Up()*renderpos.rope.l.z),
		rpos + (rang:Forward()*renderpos.rope.r.x) + (rang:Right()*renderpos.rope.r.y) + (rang:Up()*renderpos.rope.r.z),
		0.7, 0, 5, RopeCol )
end

local wrender = {
	left = {bone = "ValveBiped.Bip01_L_Hand", pos=Vector(0,0,0), ang=Angle(90,0,0), scale = Vector(0.035,0.035,0.035)},
	right = {bone = "ValveBiped.Bip01_R_Hand", pos=Vector(0.2,0,0), ang=Angle(90,0,0), scale = Vector(0.035,0.035,0.035)},
	rope = {l = Vector(-0.2,1.3,-0.25), r = Vector(0.4,1.4,-0.2)},
}
function SWEP:DrawWorldModel()
	if not IsValid(self.Owner) then return end

	if not IsValid(self.cmdl_LeftCuff) then
		self.cmdl_LeftCuff = ClientsideModel( CuffMdl, RENDER_GROUP_VIEW_MODEL_OPAQUE )
		if IsValid(self.cmdl_LeftCuff) then
			self.cmdl_LeftCuff:SetNoDraw( true )
		end
		-- self.cmdl_LeftCuff:SetParent( vm )
	end
	if not IsValid(self.cmdl_RightCuff) then
		self.cmdl_RightCuff = ClientsideModel( CuffMdl, RENDER_GROUP_VIEW_MODEL_OPAQUE )
		if IsValid(self.cmdl_RightCuff) then
			self.cmdl_RightCuff:SetNoDraw( true )
		end
		-- self.cmdl_RightCuff:SetParent( vm )
	end

	local lpos, lang = self:GetBonePos( wrender.left.bone, self.Owner )
	local rpos, rang = self:GetBonePos( wrender.right.bone, self.Owner )
	if not (lpos and rpos and lang and rang) then return end

	-- Left
	self.cmdl_LeftCuff:SetPos( lpos + (lang:Forward()*wrender.left.pos.x) + (lang:Right()*wrender.left.pos.y) + (lang:Up()*wrender.left.pos.z) )
	local u,r,f = lang:Up(), lang:Right(), lang:Forward() -- Prevents moving axes
	lang:RotateAroundAxis( u, wrender.left.ang.y )
	lang:RotateAroundAxis( r, wrender.left.ang.p )
	lang:RotateAroundAxis( f, wrender.left.ang.r )
	self.cmdl_LeftCuff:SetAngles( lang )

	local matrix = Matrix()
	matrix:Scale( wrender.left.scale )
	self.cmdl_LeftCuff:EnableMatrix( "RenderMultiply", matrix )

	self.cmdl_LeftCuff:SetMaterial( self:GetCuffMaterial() or "" )
	self.cmdl_LeftCuff:DrawModel()

	-- Right
	self.cmdl_RightCuff:SetPos( rpos + (rang:Forward()*wrender.right.pos.x) + (rang:Right()*wrender.right.pos.y) + (rang:Up()*wrender.right.pos.z) )
	local u,r,f = rang:Up(), rang:Right(), rang:Forward() -- Prevents moving axes
	rang:RotateAroundAxis( u, wrender.right.ang.y )
	rang:RotateAroundAxis( r, wrender.right.ang.p )
	rang:RotateAroundAxis( f, wrender.right.ang.r )
	self.cmdl_RightCuff:SetAngles( rang )

	local matrix = Matrix()
	matrix:Scale( wrender.right.scale )
	self.cmdl_RightCuff:EnableMatrix( "RenderMultiply", matrix )

	self.cmdl_RightCuff:SetMaterial( self:GetCuffMaterial() or "" )
	self.cmdl_RightCuff:DrawModel()

	-- Rope
	if (lpos.x==0 and lpos.y==0 and lpos.z==0) or (rpos.x==0 and rpos.y==0 and rpos.z==0) then return end -- Rope accross half the map...

	if self:GetRopeMaterial()~=self.LastMatStr then
		self.RopeMat = Material( self:GetRopeMaterial() )
		self.LastMatStr = self:GetRopeMaterial()
	end
	if not self.RopeMat then self.RopeMat = Material(DefaultRope) end

	render.SetMaterial( self.RopeMat )
	render.DrawBeam( lpos + (lang:Forward()*wrender.rope.l.x) + (lang:Right()*wrender.rope.l.y) + (lang:Up()*wrender.rope.l.z),
		rpos + (rang:Forward()*wrender.rope.r.x) + (rang:Right()*wrender.rope.r.y) + (rang:Up()*wrender.rope.r.z),
		0.7, 0, 5, RopeCol )
end


-- Bones
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
