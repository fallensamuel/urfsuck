-- "gamemodes\\rp_base\\gamemode\\addons\\vendornpc_highlight_cl.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
--[[------------------------------------------------------------
    -> rp.FindNPCVendor( VendorID )      : table
    -> rp.FindNPCVendorForItem( ItemID ) : table
    -> rp.FindTeamNPCVendors( TeamID ) : table
------------------------------------------------------------]]--
local ENTS_VENDORS;


function rp.FindNPCVendor( VendorID )
    local vendor = rp.VendorsNPCs[VendorID];

    if vendor then
        if vendor.ent then
            if not IsValid(vendor.ent) then
                vendor.ent = nil;
            end
        end
        
        if not vendor.ent then -- Precache VendorsNPCs's entities:
            for _, v in ipairs( ents.FindByClass("vendor_npc") ) do
                local vendor_tbl = rp.VendorsNPCs[v:GetVendorName()];
                if vendor_tbl then vendor_tbl.ent = v; end
            end
        end
    end

    return vendor;
end


function rp.FindNPCVendorsForItem( ItemID )
    local vendors = rp.VendorsNPCsWhatSells[ItemID];

    local npcs = {};
    for _, VendorID in ipairs( vendors or {} ) do
        local vendor = rp.VendorsNPCs[VendorID];

        if vendor then
            if vendor.ent then
                if not IsValid(vendor.ent) then
                    vendor.ent = nil;
                end
            end

            if not vendor.ent then -- Precache VendorsNPCs's entities:
                ENTS_VENDORS = ENTS_VENDORS or ents.FindByClass("vendor_npc");
                
                for _, v in ipairs( ENTS_VENDORS or {} ) do
                    local vendor_tbl = rp.VendorsNPCs[v:GetVendorName()];
                    if vendor_tbl then vendor_tbl.ent = v; end
                end
            end

            npcs[VendorID] = vendor;
        end
    end

    ENTS_VENDORS = nil;

    return npcs;
end


rp.VendorsNPCsTeams = rp.VendorsNPCsTeams or {};
rp.VendorsNPCsTeamsItems = {};

hook.Add( "ConfigLoaded", "rp.HighlightNPCVendors::TeamNPCVendors", function()
    for VendorID, Vendor in pairs( rp.VendorsNPCs ) do
        if Vendor.allowed and (not Vendor.reversed) then
            for team in pairs( Vendor.allowed ) do
                rp.VendorsNPCsTeams[team] = rp.VendorsNPCsTeams[team] or {};
                rp.VendorsNPCsTeams[team][VendorID] = true;
            end

            
            for item in pairs( Vendor.items ) do
                rp.VendorsNPCsTeamsItems[item] = rp.VendorsNPCsTeamsItems[item] or {};
                rp.VendorsNPCsTeamsItems[item][VendorID] = true;
            end
        end
    end
end );

hook.Run( "ConfigLoaded" );

function rp.FindTeamNPCVendors( TeamID )
    return rp.VendorsNPCsTeams[TeamID];
end




--[[------------------------------------------------------------
    VendorNPCs Halo Highlight:
    - rp.HighlightNPCVendor( VendorID, Time = 5 )
    - rp.HighlightItemNPCVendors( ItemID, Time = 5 )
------------------------------------------------------------]]--
local hVendorColor = rp.cfg.UIColor.VendorHighlight or Color( 153, 255, 153 );


local hVendorEntities = {};
local hVendorTimelife = {};

local HighlightNPCVendors_ItemGroup = {};


local HighlightNPCVendors_hook_hudpaint, HighlightNPCVendors_hook_predrawhalos;

local function HighlightNPCVendors_createhooks()
    hook.Add( "HUDPaint", "rp.NPCVendorHighlight::Renderer", HighlightNPCVendors_hook_hudpaint );
    hook.Add( "PreDrawHalos", "rp.NPCVendorHighlight::HaloRenderer", HighlightNPCVendors_hook_predrawhalos );
end

local function HighlightNPCVendors_flushhooks()
    hook.Remove( "HUDPaint", "rp.NPCVendorHighlight::Renderer" );
    hook.Remove( "PreDrawHalos", "rp.NPCVendorHighlight::HaloRenderer" );
end


rp.HighlightNPCVendor = {};

rp.HighlightNPCVendor.Add = function( VendorID, Time )
    local vendor     = rp.FindNPCVendor( VendorID );
    local vendor_ent = vendor.ent;
    local vendor_mdl = vendor.model;

    if (not vendor_ent) and (not vendor_mdl) then
        return false;
    end

    local highlight_id = table.insert( hVendorTimelife, Time and CurTime() + Time or 0 );

    if vendor_ent then
        if IsValid(vendor.csent) then
            vendor.csent:Remove();
            vendor.csent = nil;
        end

        table.insert( hVendorEntities, highlight_id, vendor_ent );
    else
        vendor.csent = ClientsideModel( vendor_mdl ); -- VendorNPC entity isn't networked to a client yet, lets make clientside one:
        vendor.csent.AutomaticFrameAdvance = true;
        vendor.csent.isClientside = true;
        vendor.csent:SetPos( vendor.pos or Vector(0,0,0) );
        vendor.csent:SetAngles( vendor.ang or Angle(0,0,0) );
        vendor.csent:SetRenderMode( RENDERMODE_TRANSCOLOR );
        vendor.csent:SetColor( Color(0,0,0,0) );
        vendor.csent:ResetSequence( vendor.sequence or "idle_all_01" );
        vendor.csent:Spawn();

        table.insert( hVendorEntities, highlight_id, vendor.csent );
    end

    if table.Count( hVendorEntities ) == 1 then
        HighlightNPCVendors_createhooks();
    end

    return highlight_id;
end

rp.HighlightNPCVendor.Remove = function( HighlightID )
    local e = hVendorEntities[HighlightID];

    if IsValid( e ) then
        if e.isClientside then e:Remove(); end
    end
    
    hVendorEntities[HighlightID] = nil;
    hVendorTimelife[HighlightID] = nil;
end


HighlightNPCVendors_hook_hudpaint = function()
    if LocalPlayer():Health() <= 0 then
        for k, t in pairs( hVendorTimelife ) do
            if t == 0 then continue end

            local e = hVendorEntities[k];
            if IsValid( e ) then
                if e.isClientside then e:Remove(); end
            end

            hVendorEntities[k] = nil;
        end

        if table.Count( hVendorEntities ) == 0 then
            HighlightNPCVendors_ItemGroup = {};
            HighlightNPCVendors_flushhooks();
            return
        end
    end

    for k, e in pairs( hVendorEntities ) do
        if not IsValid(e) then
            rp.HighlightNPCVendor.Remove( k );
            continue
        end

        local dist = LocalPlayer():GetPos():DistToSqr( e:GetPos() );

        if hVendorTimelife[k] ~= 0 then
            if (hVendorTimelife[k] < CurTime()) or (dist < 16384) then -- 128
                if HighlightNPCVendors_ItemGroup[k] then
                    for k in SortedPairs( HighlightNPCVendors_ItemGroup, true ) do
                        rp.HighlightNPCVendor.Remove( k );
                    end
                
                    HighlightNPCVendors_ItemGroup = {};
                    continue
                end

                rp.HighlightNPCVendor.Remove( k );
                continue
            end
        end
                
        if not e.offsetz then
            e.offset_z = select( 2, e:GetModelRenderBounds() ).z;
        end
        
        if dist > 16384 then
            --rp.DrawInfoBubble(alpha, ico, text, desc, custom_ico_col, ico_rotate, rotate_speed, rotate_offset, ToScreenPos, postDraw, title_colr, no_draw_trigon, InsideScreenPos)
            rp.DrawInfoBubble(
                100,
                Material( "bubble_hints/cart.png", "smooth noclamp" ),
                nil,
                nil,
                hVendorColor,
                false,
                nil,
                nil,
                e:LocalToWorld( e:GetUp() * e.offset_z ):ToScreen(),
                nil,
                nil,
                false,
                true
            );
        end
    end

    if table.Count( hVendorEntities ) < 1 then
        HighlightNPCVendors_flushhooks();
        return
    end
end


HighlightNPCVendors_hook_predrawhalos = function()
    halo.Add(
        hVendorEntities,
        hVendorColor,
        3, 3,
        2,
        true,
        true
    );
end


function rp.HighlightItemNPCVendors( ItemID, Time )
    for k in SortedPairs( HighlightNPCVendors_ItemGroup, true ) do
        rp.HighlightNPCVendor.Remove( k );
    end

    HighlightNPCVendors_ItemGroup = {};

    local vendors = rp.FindNPCVendorsForItem( ItemID );
    local found = false;

    for VendorID in pairs( vendors ) do
        local id = rp.HighlightNPCVendor.Add( VendorID, Time );

        if id then
            if not found then found = true; end
            HighlightNPCVendors_ItemGroup[id] = true;
        end
    end

    if found then
        rp.Notify( NOTIFY_SUCCESS, translates.Get("Торговцы подсвечены на экране!") );
    else
        rp.Notify( NOTIFY_ERROR, translates.Get("Торговцы не продают данный предмет") );
    end
end


local lp_vendorhighlight_oldteam = 0;
local lp_vendorhighlight_vendors = {};

function rp.ProccessVendorsRm(id, invID, owner)
	if #lp_vendorhighlight_vendors < 1 then return end

	local lp = LocalPlayer();

	if invID ~= lp:getInv().id then return end

	local uniqueID = rp.item.instances[id].uniqueID;
	if not uniqueID then return end

	local SellerID = rp.VendorsNPCsTeamsItems[uniqueID];
	if not SellerID then return end

	timer.Simple( 1, function()
		lp_vendorhighlight_oldteam = nil; -- Hard reset?
	end );
end

function rp.ProccessVendorsSet(invID, x, y, uniqueID, id, owner, data, a)
	if #lp_vendorhighlight_vendors < 1 then return end
		
	if invID ~= LocalPlayer():getInv().id then return end
	
	local BuyersNPCs = rp.VendorsNPCsWhatSells[uniqueID];
	if not BuyersNPCs then return end

	local SellerID = rp.VendorsNPCsTeamsItems[uniqueID];
	if not SellerID then return end

	timer.Simple( 1, function()
		lp_vendorhighlight_oldteam = nil; -- Hard reset?
	end );
end

hook.Add( "Think", "rp.VendorNPCs::HighlightTeamVendors", function()
    local lp = LocalPlayer();
    if not lp:Alive() then return end

    local lp_team = lp:Team();
    if lp_vendorhighlight_oldteam ~= lp_team then
        lp_vendorhighlight_oldteam = lp_team;

        local highlightable_vendors = {};

        -- Search for sellable items:
        local TeamVendors = rp.FindTeamNPCVendors( lp_team );
        if TeamVendors then
			if not lp:getInv() or not lp:getInv().slots then return end
            for _, slot in ipairs( lp:getInv().slots ) do
                for _, item in ipairs( slot ) do
                    -- Do we need to buy this item?
                    if not rp.VendorsNPCsTeamsItems[item.uniqueID] then
                        continue
                    end

                    -- Anybody buying this?
                    local BuyersNPCs = rp.VendorsNPCsWhatSells[item.uniqueID];
                    if not BuyersNPCs then
                        continue
                    end

                    -- Display buyers then:
                    for _, VendorID in ipairs( BuyersNPCs ) do
                        highlightable_vendors[VendorID] = true;
                    end
                end
            end
        end

        -- Sellable item hasn't been found: 
        if table.Count( highlightable_vendors ) == 0 then
            for VendorID in pairs( TeamVendors or {} ) do
                local Vendor = rp.VendorsNPCs[VendorID];
                if not Vendor then continue end

                for ItemID in pairs( Vendor.items or {} ) do
                    -- Does buyer for this item exist?
                    if not rp.VendorsNPCsWhatSells[ItemID] then continue end
                    highlightable_vendors[VendorID] = true;
                end
            end
        end

        -- Clear old vendors:
        for k, v in ipairs( lp_vendorhighlight_vendors ) do
            rp.HighlightNPCVendor.Remove( v );
        end
        lp_vendorhighlight_vendors = {};

        -- Display new vendors:
        for VendorID in pairs( highlightable_vendors ) do
            table.insert( lp_vendorhighlight_vendors, rp.HighlightNPCVendor.Add(VendorID, 5) );
        end
    end
end );