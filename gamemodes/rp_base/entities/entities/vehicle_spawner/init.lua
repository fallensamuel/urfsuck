AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include('shared.lua')

function ENT:SpawnVehicle(vname, ply)

	local vehicle = list.Get( "Vehicles" )[vname]
	local model = vehicle.Model
	local class = vehicle.Class

	local ent = ents.Create( class )
	if ( !ent ) then return NULL end

	ent:SetModel( model )
	ent:SetPos(self:GetPos())
	ent:SetAngles(self:GetAngles())

	if ( vehicle && vehicle.KeyValues ) then
		for k, v in pairs( vehicle.KeyValues ) do

			local kLower = string.lower( k )

			if ( kLower == "vehiclescript" ||
			     kLower == "limitview"     ||
			     kLower == "vehiclelocked" ||
			     kLower == "cargovisible"  ||
			     kLower == "enablegun" )
			then
				ent:SetKeyValue( k, v )
			end

		end
	end

	if ( ent.SetVehicleClass && vname ) then ent:SetVehicleClass( vname ) end
	ent.ClassOverride = class	
	ent.VehicleName = vname
	ent.VehicleTable = vehicle	

	ent:Spawn()
	ent:Activate()


	ply:_AddCount("vehicle_spawner", ent)

	self:Remove()

	timer.Simple(0, function()
		self:CPPISetOwner(ply)
	end)
end