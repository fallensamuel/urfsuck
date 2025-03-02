-- "gamemodes\\rp_base\\entities\\entities\\base_urf_radio\\shared.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
if SERVER then AddCSLuaFile( "sh_vkplayer.lua" ); end
include( "sh_vkplayer.lua" );


----------------------------------------------------------------
ENT.Type                = "anim";
ENT.PrintName           = "Radio";
ENT.Author              = "urf.im @ bbqmeowcat";
ENT.Spawnable           = false;
ENT.AdminOnly           = true;

ENT.Model               = "models/props_lab/citizenradio.mdl"; -- "models/props_club/speaker/speaker_system.mdl";

ENT.SegmentColor        = Color(255,155,0);

ENT.GigaMode            = false;
ENT.GigaLowColor        = Vector(0,0,1);
ENT.GigaHighColor       = Vector(1,0,0);
----------------------------------------------------------------


ENT.Network = {};
ENT.Network.OPEN_MENU = 0;
ENT.Network.SEND_TRACK = 1;

function ENT:SetupDataTables()
    self:NetworkVar( "String", 0, "TrackID" );
    self:NetworkVar( "String", 1, "TrackArtist" );
    self:NetworkVar( "String", 2, "TrackTitle" );
    
    self:NetworkVar( "Int", 0, "TrackStart" );
    self:NetworkVar( "Int", 1, "TrackLength" );
end
