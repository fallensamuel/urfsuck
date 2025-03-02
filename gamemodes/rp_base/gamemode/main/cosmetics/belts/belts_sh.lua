-- "gamemodes\\rp_base\\gamemode\\main\\cosmetics\\belts\\belts_sh.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
-- rp.AddBag: --------------------------------------------------
function rp.AddBelt( data )
    data.type = rp.Accessories.Enums["TYPE_BELT"];
    data.__renderer = rp.Accessories.BeltRenderer;
    return rp.AddWearable( data );
end

if CLIENT then
    local vector_hidden, cache_radius = Vector( 0, 0, -32768 ), {};

    rp.Accessories.BeltRenderer = function( ent, uid )
        local data = rp.Accessories.List[uid];
        if not data then return end

        local items = ent:GetNetVar( "BeltItems" ) or {};
        local c = #items;
        if c == 0 then return end

        local q = math.max(c - 1, 4);

        local b = ent:LookupBone( "ValveBiped.Bip01_Pelvis" );
        if not b then return end

        local csmdl = rp.Accessories.GetClientsideModel( ent );
        if not IsValid( csmdl ) then return end

        local origin, angles = ent:GetBonePosition( b );
        angles:RotateAroundAxis( angles:Up(), 180 );
        angles:RotateAroundAxis( angles:Forward(), 90 );

        if not cache_radius[ent:GetModel()] then
            for hbox = 0, ent:GetHitBoxCount(0) - 1 do
                local b = ent:GetHitBoxBone( hbox, 0 );
                
                if ent:GetBoneName( b ) ~= "ValveBiped.Bip01_Pelvis" then
                    continue
                end

                local mins, maxs = ent:GetHitBoxBounds( hbox, 0 );
                cache_radius[ent:GetModel()] = (maxs.x - mins.x) * 0.5;

                break
            end

            cache_radius[ent:GetModel()] = cache_radius[ent:GetModel()] or 0;
        end

        local r, offset, curve = cache_radius[ent:GetModel()], 45, 180;

        for i = 0, q do
            local item = rp.item.list[items[i + 1]];

            if item and item.model then
                if csmdl:GetModel() ~= item.model then
                    csmdl:SetModel( item.model );
                    csmdl:SetModelScale( 6 / csmdl:GetModelRadius(), 0 );
                end

                local deg = (curve / q) * i;
                local d = math.rad( offset + deg );

                -- you should cache results per model :/
                local mins, maxs = csmdl:GetCollisionBounds();
                local axis = Vector( maxs.x - mins.x, maxs.y - mins.y, maxs.z - mins.z );

                local rotangle = Angle( 0, 0, 0 );

                if axis.y < axis.x and axis.y < axis.z then
                    rotangle = Angle( -90, 180, 0 );
                    goto placement
                end

                if axis.z < axis.x and axis.z < axis.y then
                    rotangle = Angle( 90, 0, 0 );
                    goto placement
                end

                ::placement::
                rotangle.y = rotangle.y - deg + offset;
                local position, angles = LocalToWorld( Vector( math.sin(d) * r * 0.95, math.cos(d) * r * 0.785, 0 ), rotangle, origin, angles );

                local animLen = csmdl:SequenceDuration();
                csmdl:SetCycle( SysTime() % animLen / animLen );
                csmdl:SetRenderOrigin( position );
                csmdl:SetRenderAngles( angles );
                csmdl:SetupBones();
                csmdl:DrawModel();
            end
        end

        csmdl:SetRenderOrigin( vector_hidden );
    end
end

-- PLAYER: -----------------------------------------------------
local playerMeta = FindMetaTable( "Player" );

function playerMeta:getBeltInv()
	return rp.item.inventories[self:getBeltInvID()]
end

function playerMeta:getBeltInvID()
	return self:GetNWInt( "InventoryBeltID", -1 );
end

nw.Register( "BeltItems" )
    :Write( function( v )
        local c = #v;
        net.WriteUInt( c, 3 );
        for i = 1, c do net.WriteString( v[i] ); end
    end )
    :Read( function()
        local t, c = {}, net.ReadUInt( 3 );
        for i = 1, c do table.insert( t, net.ReadString() ); end
        return t
    end )
    :SetPlayer()