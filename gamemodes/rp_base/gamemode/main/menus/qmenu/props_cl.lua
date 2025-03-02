-- "gamemodes\\rp_base\\gamemode\\main\\menus\\qmenu\\props_cl.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local PropPanel;
local AllowedProps = {};

hook.Add( "ppWhitelistLoaded", "QMenu.Props::Populate", function( props )
    AllowedProps = {};

    for k, v in ipairs( props or {} ) do
        AllowedProps[v.Model] = true;
    end

    if IsValid( PropPanel ) then
        PropPanel:Clear();
        PropPanel:Populate( AllowedProps );
    end
end );


QMenu.AddCategory( translates.Get("Пропы"),
    function()
        PropPanel = vgui.Create( "ContentContainer" );
        PropPanel:SetTriggerSpawnlistChange( false );

        PropPanel.Populate = function( self, data )
            local CType = spawnmenu.GetContentType( "model" );
            if not CType then return end

            for PropMdl in SortedPairs( data ) do
                CType( self, { model = PropMdl } );
            end
        end

        PropPanel:Clear();
        PropPanel:Populate( AllowedProps );

        --[[
        http.Fetch( rp.cfg.whitelistHandler, function( body )
            local Props = util.JSONToTable( body );

            if not (Props and #Props > 0) then
                Props = util.JSONToTable( rp.cfg.WhitelistedProps or "nil" );
            end

            local AllowedProps = {};
            for k, v in ipairs( Props or {} ) do
                AllowedProps[v.Model] = true;
            end

            PropPanel:Populate( AllowedProps );
        end );
        ]]--

        return PropPanel, true;
    end,
nil, "icon16/brick.png", 250 );