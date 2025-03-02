-- "gamemodes\\rp_base\\entities\\entities\\urfim_radio_giga.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
AddCSLuaFile();

----------------------------------------------------------------
ENT.Base                = "base_urf_radio";
ENT.PrintName           = "Giga Radio";
ENT.Spawnable           = true;
ENT.AdminOnly           = true;

ENT.Model               = "models/props_club/speaker/speaker_system.mdl";

ENT.SegmentColor        = Color(255,155,0);
ENT.SoundRange          = 768;

ENT.GigaMode            = true;
ENT.GigaLowColor        = Vector(0,0,1);
ENT.GigaHighColor       = Vector(1,0,0);
----------------------------------------------------------------