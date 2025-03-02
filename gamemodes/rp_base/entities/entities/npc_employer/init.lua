AddCSLuaFile( "cl_init.lua" );
AddCSLuaFile( "shared.lua" );
include( "shared.lua" );


util.AddNetworkString( "rp.EmployerMenu" );


function ENT:Initialize()
	self:SetModel("models/AntLion.mdl")
	--self:PhysicsInit(SOLID_VPHYSICS)
	--self:SetMoveType(MOVETYPE_NONE)
	--self:SetSolid(SOLID_BBOX)
	--self:SetCollisionGroup(COLLISION_GROUP_DEBRIS_TRIGGER)
	--self:SetUseType(SIMPLE_USE)
	--self:DropToFloor()
	
	--self:SetHullType(HULL_HUMAN)
    --self:SetHullSizeNormal()
    --self:SetNPCState(NPC_STATE_SCRIPT)
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_NONE)
    self:SetSolid(SOLID_BBOX)
    --self:CapabilitiesAdd(CAP_ANIMATEDFACE)
    self:SetUseType(SIMPLE_USE)
    --self:DropToFloor()
    self:SetCollisionGroup(COLLISION_GROUP_DEBRIS_TRIGGER)

    self:SetFaction( 1 );

	--timer.Simple(0, function()
		self:ResetSequence( self:LookupSequence("idle_all_01") );
	--end)
	
    self.NextUse = 0;
end


function ENT:AcceptInput( input, activator )
    if input == "Use" and activator:IsPlayer() and self.NextUse <= CurTime() then
        if self:IsHidden(activator) then return end
        
        net.Start( "rp.EmployerMenu" );
            net.WriteEntity( self );
        net.Send( activator );

        self.NextUse = CurTime() + 0.5;
    end
end


local function SpawnEmployerNPCs()
    timer.Simple( 5, function()
        local npcWeaponLoadout = {
            ["models/combine_soldier.mdl"]                     = "weapon_ar2",
            ["models/player/ct_urban.mdl"]                     = "weapon_ar2",
            ["models/combine_super_soldier.mdl"]               = "weapon_ar2",
            ["models/jessev92/hl2/characters/kurt_npccmb.mdl"] = "weapon_ar2",
            ["models/police.mdl"]                              = "weapon_stunstick",
            ["models/dpfilms/metropolice/rtb_police.mdl"]      = "weapon_smg1",
        }
    
        for k, v in pairs( ents.FindByClass("npc_employer") ) do v:Remove(); end

        for id, f in pairs( rp.Factions ) do
            if not f.npcs then continue end
    
            for _, v in pairs( f.npcs[game.GetMap()] or {} ) do
                local npc = ents.Create( "npc_employer" );
                npc:SetPos( v[1] );
                npc:SetAngles( v[2] );
                npc:Spawn();
                
                npc:SetFaction( id );
                
                npc:SetModel( v[3] );
                if npcWeaponLoadout[v[3]] then
                    npc:Give( npcWeaponLoadout[v[3]] );
                end
    
                --timer.Simple( 0, function()
                    npc:SetSequence( npc:LookupSequence("idle_all_01") );
                --end );
                
                if f.OnSpawn then
                    f.OnSpawn( npc );
                end
            end
        end
    end );
end

hook.Add( "InitPostEntity", "rp.EmployerNPC.Spawner", SpawnEmployerNPCs );
hook.Add( "OnReloaded",     "rp.EmployerNPC.Reload",  SpawnEmployerNPCs );