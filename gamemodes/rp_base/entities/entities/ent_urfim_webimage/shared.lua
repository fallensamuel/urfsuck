-- "gamemodes\\rp_base\\entities\\entities\\ent_urfim_webimage\\shared.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
ENT.PrintName       = "WebImage";
ENT.Author          = "urf.im";
ENT.Category        = "RP";

ENT.Spawnable       = true;
ENT.AdminOnly       = true;

ENT.IsWebImage      = true;
ENT.PixelsPerUnit   = 512 / 23 * 0.5;

WEBIMAGE_RENDERFLAG_ALPHATEST  = 1;
WEBIMAGE_RENDERFLAG_ADDITIVE   = 2;
WEBIMAGE_RENDERFLAG_NOCULL     = 4;
WEBIMAGE_RENDERFLAG_MIRRORBACK = 8;


function ENT:HasRenderFlag( f )
    return bit.band( self:GetRenderFlags(), f ) == f;
end


function ENT:SetupDataTables()
    self:NetworkVar( "String", 0, "URL" );

    self:NetworkVar( "Float", 0, "ScaleWidth" );
    self:NetworkVar( "Float", 1, "ScaleHeight" );

    self:NetworkVar( "Int", 0, "RenderFlags" );
    self:NetworkVar( "Bool", 0, "Update" );
end


function ENT:Think()
    if self:GetUpdate() then
        if CLIENT then
            self:InitializeImage();
        end

        self:SetUpdate( false );
    end
end