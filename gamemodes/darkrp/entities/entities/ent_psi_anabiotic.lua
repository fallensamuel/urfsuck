-- "gamemodes\\darkrp\\entities\\entities\\ent_psi_anabiotic.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
AddCSLuaFile();
DEFINE_BASECLASS( "base_entity" );


----------------------------------------------------------------
ENT.PrintName           = "Пси-Блокада";
ENT.Author              = "urf.im @ bbqmeowcat";
ENT.Category            = "Other";

ENT.Model               = "models/stalker/item/medical/antibotic.mdl";

ENT.Spawnable           = true;
ENT.AdminOnly           = true;


----------------------------------------------------------------
if SERVER then
    -- util.AddNetworkString( "ent_psiemittion_helm" );

    local function Equip( ply )
        ply.b_PsiEmittion_Ignore = true;

        local f = RecipientFilter(); f:AddPlayer( ply );
        local snd = CreateSound( ply, "hgn/stalker/player/pl_pills.mp3", f );
        snd:SetSoundLevel( 0 );
        snd:Play();

        -- net.Start( "ent_psiemittion_helm" ); net.WriteBool( true ); net.Send( ply );
    end

    local function UnEquip( ply )
        ply.b_PsiEmittion_Ignore = nil;

        -- net.Start( "ent_psiemittion_helm" ); net.WriteBool( false ); net.Send( ply );
    end

    function ENT:Initialize()
        self:SetUseType( SIMPLE_USE );

        self:SetModel( self.Model );
        self:PhysicsInit( SOLID_VPHYSICS );
        self:SetMoveType( MOVETYPE_VPHYSICS );
        self:PhysWake();
    end

    function ENT:Use( ply )
        if ply.b_PsiEmittion_Ignore then return end
        Equip( ply );
        self:Remove();
    end

    hook.Add( "PlayerDeath", "PsiEmittion-Helmet::Reset", function( ply )
        if ply.b_PsiEmittion_Ignore then
            UnEquip( ply );
        end
    end );

    hook.Add( "OnPlayerChangedTeam", "PsiEmittion-Helmet::Reset", function( ply, old, new )
        if ply.b_PsiEmittion_Ignore then
            if old == new then return end
            UnEquip( ply );
        end

        if rp.teams[new].ignorePsiEmittion then
            ply.b_PsiEmittion_Ignore = true;
        end
    end );
end

if CLIENT then
    -- local mat = Material( "hud/vgui/hud_exo1.png" );

    -- local function DrawHUD()
    --     local w, h = ScrW(), ScrH();
    --     surface.SetDrawColor( color_white );
    --     surface.SetMaterial( mat );
    --     surface.DrawTexturedRect( 0, 0, w, h );
    -- end

    -- net.Receive( "ent_psiemittion_helm", function()
    --     local b = net.ReadBool();
    --     hook[b and "Add" or "Remove"]( "HUDPaint", "ent_psiemittion_helm", DrawHUD );
    -- end );

    function ENT:Draw()
        self:DrawModel();
    end
end