if istable(simfphys) then
	---
	local meta = FindMetaTable( "Player" )
	function meta:IsDrivingSimfphys()
		local Car = self:GetSimfphys()
		local Pod = self:GetVehicle()
		
		if not IsValid( Pod ) or not IsValid( Car ) then return false end
		if not Car.GetDriverSeat or not isfunction( Car.GetDriverSeat ) then return false end
		
		return Pod == Car:GetDriverSeat()
	end

	function meta:GetSimfphys()
		if not self:InVehicle() then return NULL end
		
		local Pod = self:GetVehicle()
		
		if not IsValid( Pod ) then return NULL end
		
		if Pod.SPHYSchecked == true then
			
			return Pod.SPHYSBaseEnt
			
		elseif Pod.SPHYSchecked == nil then

			local Parent = Pod:GetParent()
			
			if not IsValid( Parent ) then Pod.SPHYSchecked = false return NULL end
			
			if not simfphys.IsCar( Parent ) then Pod.SPHYSchecked = false return NULL end
			
			Pod.SPHYSchecked = true
			Pod.SPHYSBaseEnt = Parent
			Pod.vehiclebase = Parent -- compatibility for old addons
			
			return Parent
		else
			
			return NULL
		end
	end
	---
	
    if SERVER then
        util.AddNetworkString( "simfphys_ctxactions_lock" );
        util.AddNetworkString( "simfphys_ctxactions_kick" );

        net.Receive( "simfphys_ctxactions_lock", function( len, ply )
            local car = net.ReadEntity();

            if not IsValid(car)        then return end
            if not simfphys.IsCar(car) then return end
            if car.EntityOwner ~= ply and car.ItemOwner ~= ply then
                rp.Notify( ply, NOTIFY_ERROR, rp.Term("NotYourCar") );
                return
            end
            if ply:GetPos():Distance(car:GetPos()) >= 256 then
                rp.Notify( ply, NOTIFY_ERROR, rp.Term("FarAwayFromCar") );
                return
            end

            local lock = net.ReadBool();
            if lock then car:Lock() else car:UnLock() end
        end );

        net.Receive( "simfphys_ctxactions_kick", function( len, ply )
            if not ply:IsDrivingSimfphys() then return end
            
            local car = ply:GetSimfphys();
            if not IsValid(car) then return end
            if car.EntityOwner ~= ply and car.ItemOwner ~= ply then
                rp.Notify( ply, NOTIFY_ERROR, rp.Term("NotYourCar") );
                return
            end

            if len == 0 then
                local passengers = {};

                if car.pSeat then
                    for i = 1, table.Count( car.pSeat ) do
                        if IsValid( car.pSeat[i] ) then
                            local driver = car.pSeat[i]:GetDriver()
                            print( car.pSeat[i] );
                            if IsValid( driver ) then
                                table.insert( passengers, driver );
                            end
                        end
                    end
                end

                local c = #passengers;
                if c > 0 then
                    net.Start( "simfphys_ctxactions_kick" );
                        net.WriteUInt( c, 4 );
                        for i = 1, c do
                            net.WriteEntity(passengers[i]);
                        end
                    net.Send( ply );
                end
            else
                local pl = net.ReadEntity();

                if car.pSeat then
                    for i = 1, table.Count( car.pSeat ) do
                        if IsValid( car.pSeat[i] ) then
                            local driver = car.pSeat[i]:GetDriver()
                            if IsValid( driver ) then
                                if (driver == pl) and (driver:GetSimfphys() == car) then
                                    driver:ExitVehicle();
                                    break;
                                end
                            end
                        end
                    end
                end
            end
        end );
    end

    if CLIENT then
        net.Receive( "simfphys_ctxactions_kick", function()
            local n          = net.ReadUInt(4);
            local passengers = {};

            for i = 1, n do
                table.insert( passengers, net.ReadEntity() );
            end

            ui.PlayerReuqest( passengers, function(pl)
                net.Start( "simfphys_ctxactions_kick" );
                    net.WriteEntity( pl );
                net.SendToServer();
            end );
        end );

		local cat_name = translates and translates.Get("Транспорт") or "Транспорт"
		
        rp.AddContextCategory( cat_name );

        rp.AddContextCommand( cat_name, translates and translates.Get("Открыть транспорт") or "Открыть транспорт", function()
            local car = LocalPlayer():GetEyeTraceNoCursor().Entity;

            if simfphys.IsCar(car) then
                net.Start( "simfphys_ctxactions_lock" );
                    net.WriteEntity( car );
                    net.WriteBool( false );
                net.SendToServer();
            end
        end, function()
            if LocalPlayer():IsDrivingSimfphys() then return false end

            local car = LocalPlayer():GetEyeTraceNoCursor().Entity;
            if not simfphys.IsCar(car)                              then return false end
            if LocalPlayer():GetPos():Distance(car:GetPos()) >= 256 then return false end

            return true
        end, nil, 'cmenu/unlock' );

        rp.AddContextCommand( cat_name, translates and translates.Get("Закрыть транспорт") or "Закрыть транспорт", function()
            local car = LocalPlayer():GetEyeTraceNoCursor().Entity;

            if simfphys.IsCar(car) then
                net.Start( "simfphys_ctxactions_lock" );
                    net.WriteEntity( car );
                    net.WriteBool( true );
                net.SendToServer();
            end
        end, function()
            if LocalPlayer():IsDrivingSimfphys() then return false end

            local car = LocalPlayer():GetEyeTraceNoCursor().Entity;
            if not simfphys.IsCar(car)                              then return false end
            if LocalPlayer():GetPos():Distance(car:GetPos()) >= 256 then return false end

            return true
        end, 'cmenu/lock' );

        rp.AddContextCommand( cat_name, translates and translates.Get("Выкинуть пассажира") or "Выкинуть пассажира", function()
            if not LocalPlayer():IsDrivingSimfphys() then return end
            net.Start( "simfphys_ctxactions_kick" ); net.SendToServer();
        end, function()
            if LocalPlayer():IsDrivingSimfphys() then return true end
            return false
        end, 'cmenu/passenger' );
    end
end