-- "gamemodes\\darkrp\\gamemode\\addons\\artifactmod\\sh_item_artifact.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local ITEM = rp.item.register( "base_artifact", nil, true, nil, true );

ITEM.isArtifact         = true;

ITEM.name               = "Artifact";
ITEM.desc               = "noDesc";

ITEM.category           = "Artifacts";
ITEM.model              = "models/maxofs2d/cube_tool.mdl";

ITEM.width              = 1;
ITEM.height             = 1;
ITEM.maxStack           = 1;
ITEM.NoDamage           = true;

ITEM.charges            = 1;
ITEM.modifiers          = {};

ITEM.functions.tele = ITEM.functions.tele or {
    name = translates.Get("Телепортироваться"),
    icon = "icon16/lightning_go.png",
    radial = false,
    onRun = function( item )
        local ply = item.player;

        if IsValid(ply) and ply:IsPlayer() then
            local repeats, tp = 0, ply:GetPos();

            repeat
                repeats = repeats + 1;
                tp = table.Random( rp.cfg.ArtTpPos[game.GetMap()] );
            until repeats < 5 and ply:GetPos():DistToSqr( tp ) >= 1048576 -- 1024

            ply:SetPos( tp );
		    rp.Notify( ply, NOTIFY_GREEN, rp.Term("ArtTp") );
        end

        item:setData( "charges", (item:getData("charges") or 0) - 1 );
        item:handleCharges();

        return false
    end,
    onClick = function( item )

    end,
    onCanRun = function( item )
        return (not IsValid(item.entity) and (item:getData("equip") or false) and tobool(item.modifiers.teleport))
    end
}

function ITEM:canTake( ply )
    if ply:CantDoAfterNoclip( true ) then return false end
end

function ITEM:onInstanced( invID, x, y )
    if not self:getData( "equip" ) then
        self:setData( "equip", false );
    end

    if not self:getData( "charges" ) then
        self:setData( "charges", self.charges );
    end
end

if CLIENT then
    rp.cfg.InventoryTooltips = rp.cfg.InventoryTooltips or {};
    rp.cfg.InventoryTooltips["Items"] = rp.cfg.InventoryTooltips["Items"] or {};

    rp.cfg.InventoryTooltips["Items"]["base_artifact"] = function( item )
        local b, mods = false, {};

        for uid, value in pairs( item.modifiers ) do
            if not ArtifactMod.Modifiers[uid] then continue end

            local fmt, v = ArtifactMod.Formats[uid] or FORMAT_NUMBER, value;
            b = true;

            if fmt == FORMAT_NUMBER then
                mods[ArtifactMod.Translations[uid] or uid] = (value >= 0 and "▴ +" or "▾ -") .. math.abs(value);
                continue
            end

            if fmt == FORMAT_PERCENT then
                mods[ArtifactMod.Translations[uid] or uid] = (value >= 0 and "▴ +" or "▾ -") .. math.abs(value * 100) .. "%";
                continue
            end

            if fmt == FORMAT_BOOLEAN then
                mods[ArtifactMod.Translations[uid] or uid] = tobool(value) and "✓" or "";
                continue
            end

            mods[ArtifactMod.Translations[uid] or uid] = v;
        end

        return b and mods or nil
    end

    function ITEM:paintOver( item, w, h )
        local c = item:getData( "charges" );

        if c then
            local dt = c / item.charges;
            surface.SetDrawColor( Color(0,255,0,100) );
            surface.DrawRect( 4, h - 8, (w - 8) * dt, 4 );
        end
    end

    function ITEM:onRegistered()
        rp.AddBubble( "item", self.uniqueID, {
            ico = Material( "raddetect/stalkerrad.png", "smooth noclamp" ),
            offset = Vector(0, 0, 0),
            scale = 0.8,
            ico_col = color_white,
        } );
    end

    hook.Add( "NetworkEntityCreated", "base_artifact::FixClientsideAnimations", function( ent )
        if ent:GetClass() ~= "rp_item" then return end

        timer.Simple( 0.25, function()
            if not IsValid( ent ) then return end

            local item = rp.item.list[ent:GetNWString("uniqueID")];
            if not item then return end

            if item.isArtifact then
                ent.Draw = function( e )
                    if not e.fl_StartLife then
                        e.fl_StartLife = SysTime();
                    end

                    local d = e:SequenceDuration();
                    e:SetCycle( ((SysTime() - e.fl_StartLife) % d) / d );

                    e:DrawModel();
                end
            end
        end );
    end );
end


if SERVER then
    function ITEM:handleCharges()
        if self:getData( "charges" ) <= 0 then
            local ply = self:getOwner();

            if IsValid(ply) and ply:IsPlayer() then
                rp.Notify( self:getOwner(), NOTIFY_GENERIC, ArtifactMod.Translations["ArtifactBroken"]( self.name ) );
            end

            self:remove();
        end
    end

    function ITEM:handleTransfer( from, to )
        local ply, dt = self:getOwner(), self:getData( "charges" ) / self.charges;
        local valid = IsValid( ply ) and ply:IsPlayer();

        if to then
            self:setData( "equip", to.vars and (to.vars.type or "") == ArtifactMod.Config.invType );
        else
            self:setData( "equip", false );
        end

        if (dt < 0.5) and (math.random() < 0.5) then
            if TypeID( from ) == TYPE_ENTITY then
                if valid then
                    rp.Notify( ply, NOTIFY_GENERIC, ArtifactMod.Translations["ArtifactBroken"]( self.name ) );
                end

                if IsValid( from ) then
                    from:Remove();
                end
            else
                if from and from.vars and (from.vars.type or "") == ArtifactMod.Config.invType then
                    if valid then
                        rp.Notify( ply, NOTIFY_GENERIC, ArtifactMod.Translations["ArtifactBroken"]( self.name ) );
                    end

                    self:remove();
                end
            end
        end

        if valid then
            ArtifactMod:RecalculatePlayer( ply );
        end
    end

    function ITEM:onCanBeTransfered( from, to )
        local ply, status = self:getOwner(), true;

        if IsValid( ply ) and ply:IsPlayer() then
            if ply:IsInDeathMechanics() then
                status = false;
            end
        end

        if not status then
            if from.owner then from:sync( from.owner ) end;
            if to.owner then to:sync( to.owner ) end;
        end

        return status
    end

    function ITEM:onTransfered( from, to )
        self:handleTransfer( from, to );
    end

    hook.Add( "Inventory.OnItemDrop", "base_artifact::ProcessWorldTransfer", function( item, ply, entity )
        if item.isArtifact then
            item:handleTransfer( entity );
        end
    end );
end

rp.item.artifacts = { Map = {}, List = {} };

function rp.AddArtifact( tblEnt )
    tblEnt.type = tblEnt.type or "item";
    tblEnt.base = "artifact";
    tblEnt.BuyPrice = tblEnt.price;

	local ITEM = rp.item.createItem( tblEnt );
    ITEM.charges = tblEnt.charges or 1;
    ITEM.modifiers = tblEnt.modifiers or {};

	if tblEnt.icon then
		rp.item.icons[tblEnt.ent] = tblEnt.icon;
	end

	local SHIPMENT = {};
	SHIPMENT.name = tblEnt.name;
	SHIPMENT.model = tblEnt.model;
	SHIPMENT.uniqueID = "box_shop";
	SHIPMENT.price = tblEnt.price;
	SHIPMENT.max = tblEnt.max or 0;

	SHIPMENT.allowed = SHIPMENT.allowed or {};
	tblEnt.allowed = tblEnt.allowed or {};
	for k, v in pairs( tblEnt.allowed ) do
		if v and not isbool(v) then
			tblEnt.allowed[v] = true;
		end
	end
	SHIPMENT.allowed = tblEnt.allowed;

	SHIPMENT.customCheck = tblEnt.customCheck;
	SHIPMENT.unlockTime = tblEnt.unlockTime;

	SHIPMENT.count = tblEnt.count;
	SHIPMENT.content = tblEnt.ent;

	if tblEnt.price and (tblEnt.count and (tblEnt.count > 1)) then
		SHIPMENT.unit_price = (tblEnt.price or 0) / tblEnt.count;
	end

	table.insert( rp.item.shop.shipments, SHIPMENT );

	if tblEnt.vendor then
		for vendor_name, price_tab in pairs( tblEnt.vendor ) do
			rp.AddVendorItem( vendor_name, tblEnt.category or "shipments", tblEnt, price_tab );
		end
	end

    rp.item.artifacts.List[tblEnt.ent] = tblEnt;
end
