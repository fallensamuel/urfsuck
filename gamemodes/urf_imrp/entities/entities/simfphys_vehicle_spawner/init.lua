AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include('shared.lua')

function ENT:Initialize()
	self:AddEFlags( EFL_FORCE_CHECK_TRANSMIT )
end

function ENT:SpawnVehicle(vname, ply, skin)
	local v = simfphys.SpawnVehicleSimple( vname, self:GetPos(), self:GetAngles() )
	v.ItemOwner = ply
	v.RemoveOnJobChange = true
	--local f = {}
	--for k, v in pairs(facs) do
	--	f[v] = true
	--end
	--v.Faction  = f
	ply:_AddCount("simfphys_vehicle_spawner", v)

	if skin then
		v:SetSkin(skin)
	end
	
	timer.Simple( 0.2, function()
		if simfphys.RegisterEquipment then
			simfphys.RegisterEquipment( v )
		end
	end)

	v:DoorOwn(ply)

	self:Remove()
end

function ENT:UpdateTransmitState()
	return TRANSMIT_NEVER
end
