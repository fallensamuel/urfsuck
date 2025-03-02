-- "gamemodes\\rp_base\\entities\\entities\\urf_craftable\\cl_init.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
include( "shared.lua" );

include( "cl_menu.lua" );
include( "cl_help.lua" );

net.Receive( "ent_craftingtable", function()
    local ent = net.ReadEntity();

    if not ent.IsCraftingTable then
        return
    end

    local act = net.ReadUInt( 2 );

    if act == ent.Enums.USE then
        return ent:OpenMenu();
    end

    if act == ent.Enums.INFO then
        local recipe = rp.CraftTableItems[ net.ReadUInt(7) ];

        local valid = net.ReadBool();
        if not valid then
            ent:OnCraftInformation( recipe, nil );
            return
        end

        local data = {
            recipe = recipe,
            completed = net.ReadBool(),
            ts = net.ReadFloat(),
        };

        ent:OnCraftInformation( recipe, data );
        return
    end

    if act == ent.Enums.HELP then
        local lootables = {};
        local count = net.ReadUInt( 7 );

        for i = 1, count do
            lootables[i] = { net.ReadUInt(13), net.ReadVector() };
        end

        hook.Call( "OnLootablesReceived", ent, lootables );
    end
end );

function ENT:GetCraftCache()
    return self.m_CraftCache or {};
end

function ENT:OnCraftInformation( recipe, data )
    self.m_CraftCache = self.m_CraftCache or {};
    self.m_CraftCache[recipe.index] = data;

    self.i_CraftingCount = 0;
    self.i_CompletedCount = 0;

    for idx, cache in pairs( self:GetCraftCache() ) do
        if cache.completed then
            self.i_CompletedCount = self.i_CompletedCount + 1;
        else
            if cache.ts > 0 then
                self.i_CraftingCount = self.i_CraftingCount + 1;
            end
        end
    end

    self:SetSequence( self.i_CraftingCount > 0 and 1 or 0 );

    hook.Run( "CraftingTable::InfoUpdate" );
end

function ENT:RefreshInventoryItemsCount()
    local inv, count = LocalPlayer():getInv(), {};

    if inv then
        count = {};

        for k, item in pairs( inv:getItems() or {} ) do
            count[item.uniqueID] = (count[item.uniqueID] or 0) + item:getCount();
        end
    end

    return count;
end

function ENT:DrawBoxCrates( count, flags )
    count = count or 0;

    if count < 1 then
        if self.m_BoxCrate then
            if IsValid( self.m_BoxCrate ) then self.m_BoxCrate:Remove() end;
            self.m_BoxCrate = nil;
        end

        return
    end

    if not IsValid( self.m_BoxCrate ) then
        self.m_BoxCrate = ClientsideModel( "models/items/item_item_crate_dynamic.mdl", RENDERGROUP_BOTH );
        self.m_BoxCrate:SetNoDraw( true );
    end

    local origin, angles = self:GetPos(), self:GetAngles();

    for i = 1, count do
        local instance = self.m_BoxesInstances[i];
        if not instance then break; end

        local pos, ang = LocalToWorld( instance.pos or vector_origin, instance.ang or angle_zero, origin, angles );

        self.m_BoxCrate:SetRenderOrigin( pos );
        self.m_BoxCrate:SetRenderAngles( ang );
        self.m_BoxCrate:SetModelScale( instance.scale or 1, 0 );

        self.m_BoxCrate:SetupBones();
        self.m_BoxCrate:DrawModel( flags );
    end
end

function ENT:DrawCraftingItem( craft, flags )
    if not IsValid( self.m_CraftingItem ) then
        self.m_CraftingItem = ClientsideModel( "models/maxofs2d/cube_tool.mdl", RENDERGROUP_BOTH );
        self.m_CraftingItem:SetNoDraw( true );

        self.m_CraftingItem.i_CraftIdx = -1;
    end

    local csent = self.m_CraftingItem;

    if csent.i_CraftIdx ~= craft.index then
        csent:SetModel( craft.model );
    end

    local origin, angles = LocalToWorld( self.v_CraftingOffset + (craft.PosOffset or vector_origin), craft.customAng or angle_zero, self:GetPos(), self:GetAngles() );

    csent:SetPos( origin );
    csent:SetAngles( angles );

    csent:SetRenderOrigin( origin );
    csent:SetupBones();

    local cache = self:GetCraftCache()[craft.index] or {};
    local dt = (CurTime() - (cache.ts or 0)) / (craft.crafttime or 0);

    if dt < 1 then
        self.b_ShouldDrawEffects = true;

        local normal = -vector_up;
        local position = normal:Dot( csent:LocalToWorld( LerpVector(dt, csent:OBBMins(), csent:OBBMaxs()) ) );

        render.SetColorModulation( 0.3, 0.425, 0.5 );
        render.MaterialOverride( self.m_CraftingMaterial );
            render.CullMode( MATERIAL_CULLMODE_CW );
            csent:DrawModel( flags );
        render.MaterialOverride();
        render.SetColorModulation( 1, 1, 1 );

        render.SuppressEngineLighting( true );

        local r_clip = render.EnableClipping( true );
        render.PushCustomClipPlane( normal, position );
            render.CullMode( MATERIAL_CULLMODE_CCW );
            csent:DrawModel( flags );
        render.PopCustomClipPlane();
        render.EnableClipping( r_clip );

        render.SuppressEngineLighting( false );
        self:FrameAdvance();
    else
        csent:DrawModel( flags );
    end
end

function ENT:DrawCraftingItemEffects( flags )
    local t = SysTime();

    if not self.m_ParticleEmitter then
        self.m_ParticleEmitter = ParticleEmitter( self:GetPos(), false );
    end

    if (self.fl_NextDustParticle or 0) < t then
        self.fl_NextDustParticle = t + math.Rand( 0.1, 0.2 );

        for i = 1, 3 do
            local p = self.m_ParticleEmitter:Add( string.format("particle/smokesprites_00%02i", math.random(1,15)), self:LocalToWorld(self.v_CraftingOffset) );
            if p then
                p:SetDieTime( 2 );
                p:SetStartAlpha( 32 );
                p:SetEndAlpha( 0 );
                p:SetStartSize( 16 );
                p:SetEndSize( 32 );
                p:SetVelocity( VectorRand() * 8 );
                p:SetRollDelta( math.random() );
                p:SetColor( 125, 120, 115 );
            end
        end
    end

    if (self.fl_NextSparkParticle or 0) < t then
        self.fl_NextSparkParticle = t + math.Rand( 0.5, 1 );

        local ef = EffectData();
        ef:SetOrigin( self:LocalToWorld(self.v_CraftingOffset) );
        ef:SetNormal( vector_up );
        util.Effect( "StunstickImpact", ef );

        self:EmitSound( "ambient/energy/spark" .. math.random(1,6) .. ".wav", 45, 100, 1, CHAN_STATIC );
    end
end

function ENT:Draw( flags )
    self:DrawModel( flags );

    -- self:DrawBoxCrates( (self.i_CompletedCount or 0), flags );

    for idx, cache in pairs( self:GetCraftCache() ) do
        self:DrawCraftingItem( rp.CraftTableItems[idx], flags );
        break;
    end
end

function ENT:DrawTranslucent( flags )
    if not self.b_ShouldDrawEffects then return end
    self.b_ShouldDrawEffects = nil;

    self:DrawCraftingItemEffects( flags );
end

rp.AddBubble( "entity", "ent_craftingtable", {
	as_texture = true,
    ico        = Material( "bubble_hints/craftable.png", "smooth noclamp" ),
    name       = function( ent ) return ent.PrintName; end,
    desc       = translates.Get( "[E] Начать взаимодействие" ),
    scale      = 0.6,
    centered   = true,
} );