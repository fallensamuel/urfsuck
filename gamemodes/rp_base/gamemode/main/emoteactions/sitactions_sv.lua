util.AddNetworkString( "PlayerSitAction" );

SitActions_VehicleOffset = {};

hook.Add( "PlayerEnteredVehicle", "hook.EmoteActions_SitActions.PlayerEnteredVehicle", function( ply, vehicle )
    if vehicle:GetClass() == "prop_vehicle_prisoner_pod" then
        if vehicle:GetModel() ~= "models/nova/airboat_seat.mdl" then return end
		if IsValid(vehicle:GetParent()) and vehicle:GetParent().NoSitActions then return end
		
        if istable(simfphys) and (vehicle:GetParent() ~= NULL) then
            if simfphys.IsCar( vehicle:GetParent() ) then return end
        end

        ply:StartEmoteAction( "__sitaction" );

        net.Start( "PlayerSitAction" );
            net.WriteBool( true );
        net.Send( ply );

        if EmoteActions.PlayerAnims[ply] then
            local r = EmoteActions.SitActions[ string.lower(EmoteActions:GetSharedSequenceName(EmoteActions.PlayerAnims[ply].Sequence)) ];
            if r then
                SitActions_VehicleOffset[vehicle:EntIndex()] = r[2];

                local physObj = vehicle:GetPhysicsObject();
                if IsValid(physObj) then
                    physObj:EnableMotion(false);
                end
                
                vehicle:SetPos(
                    vehicle:GetPos() +
                    vehicle:GetForward() * SitActions_VehicleOffset[vehicle:EntIndex()][1] +
                    vehicle:GetRight()   * SitActions_VehicleOffset[vehicle:EntIndex()][2] +
                    vehicle:GetUp()      * SitActions_VehicleOffset[vehicle:EntIndex()][3]
                );
            end
        end
    end
end );

hook.Add( "PlayerLeaveVehicle", "hook.EmoteActions_SitActions.PlayerLeaveVehicle", function( ply, vehicle )
    net.Start( "PlayerSitAction" );
        net.WriteBool( false );
    net.Send( ply );

    if ply:GetEmoteAction() == "__sitaction" then
        ply:DropEmoteAction();
    end

    if SitActions_VehicleOffset[vehicle:EntIndex()] then
        vehicle:SetPos(
                    vehicle:GetPos() + Vector(0,0,2) +
                    -vehicle:GetForward() * SitActions_VehicleOffset[vehicle:EntIndex()][1] +
                    -vehicle:GetRight()   * SitActions_VehicleOffset[vehicle:EntIndex()][2] +
                    -vehicle:GetUp()      * SitActions_VehicleOffset[vehicle:EntIndex()][3]
        );
        SitActions_VehicleOffset[vehicle:EntIndex()] = nil;
    end
end );

net.Receive( "PlayerSitAction", function( len, ply )
    if ply:GetEmoteAction() == "__sitaction" then
        local seq = net.ReadString();

        if EmoteActions.SitActions[seq] then
            local r     = EmoteActions.SitActions[seq];
            local seqID = EmoteActions:GetSharedSequenceID(seq);

            if seqID ~= -1 then
                ply:SetEmoteActionSequence( seqID );
                cookie.Set( "LastSitAction_" .. ply:SteamID64(), seq );
                ply.LastSitActionSeqName = seq;
            end

            local vehicle = ply:GetVehicle();
            if not SitActions_VehicleOffset[vehicle:EntIndex()] then
                SitActions_VehicleOffset[vehicle:EntIndex()] = r[2];
                vehicle:SetPos(
                    vehicle:GetPos() +
                    vehicle:GetForward() * SitActions_VehicleOffset[vehicle:EntIndex()][1] +
                    vehicle:GetRight()   * SitActions_VehicleOffset[vehicle:EntIndex()][2] +
                    vehicle:GetUp()      * SitActions_VehicleOffset[vehicle:EntIndex()][3]
                );
            else
                local offset = SitActions_VehicleOffset[vehicle:EntIndex()];

                SitActions_VehicleOffset[vehicle:EntIndex()] = r[2];
                vehicle:SetPos(
                    vehicle:GetPos() +
                    vehicle:GetForward() * (-offset[1] + SitActions_VehicleOffset[vehicle:EntIndex()][1]) +
                    vehicle:GetRight()   * (-offset[2] + SitActions_VehicleOffset[vehicle:EntIndex()][2]) +
                    vehicle:GetUp()      * (-offset[3] + SitActions_VehicleOffset[vehicle:EntIndex()][3])
                );
            end
        end
    end
end );

function PLAYER:SetSitAction(seq)
    if not EmoteActions.SitActions[seq] then return end

    local r     = EmoteActions.SitActions[seq];
    local seqID = EmoteActions:GetSharedSequenceID(seq);

    if seqID == -1 then return end
        
    self:SetEmoteActionSequence(seqID);
    cookie.Set("LastSitAction_" .. self:SteamID64(), seq);
    self.LastSitActionSeqName = seq;
end