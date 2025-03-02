-- "gamemodes\\rp_base\\gamemode\\main\\doors\\propdynamic_sh.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local nw_IsDoor = nw.Register( "IsDoor" )
    :Write( net.WriteBool )
    :Read( net.ReadBool )


if SERVER then
    local function SetupDoor( ent )
        ent:SetNetVar( "IsDoor", true );
        ent:SetNetVar( "DoorData", false );
    end

    local KV_CACHED = {};

    hook.Add( "EntityKeyValue", "rp.Doors::func_button", function( ent, key, value )
        if ent:GetClass() ~= "func_button" then return end
        if key ~= "OnIn" then return end

        local values = string.Explode( ",", value );
        
        local input = values[2];
        if input ~= "SetAnimationNoReset" then return end
        
        local targetname = values[1];
        KV_CACHED[targetname] = ent;
    end );

    hook.Add( "InitPostEntity", "rp.Doors::SetupPropDynamicDoors", function()
        local __mapdoors;

        if DOOR then
            __mapdoors = {};

            for _, v in ipairs( DOOR ) do
                local k = v.pos;

                if string.sub( k, 1, 1 ) == "*" then
                    k = string.sub( k, 2, 1 );
                end

                __mapdoors[k] = v.r and 100 or 10;
            end
        end

        for _, ent in ipairs( ents.GetAll() ) do
            if __mapdoors then
                local cID, r = ent:GetCreationID();
                r = __mapdoors[cID];
                if r then
                    SetupDoor( ent );
                    ent.m_iSearchRadius = r;
                    continue
                end

                local mdl = ent:GetModel();
                r = __mapdoors[mdl];
                if r then
                    SetupDoor( ent );
                    ent.m_iSearchRadius = r;
                    continue
                end
            end

            local targetname = ent:GetName();
            local activator = KV_CACHED[targetname];
            if activator then
                SetupDoor( ent );
                ent.m_eActivator = activator;
            end
        end

        KV_CACHED = nil;
    end );
end