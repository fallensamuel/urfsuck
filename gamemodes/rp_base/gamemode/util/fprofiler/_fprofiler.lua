-- "gamemodes\\rp_base\\gamemode\\util\\fprofiler\\_fprofiler.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
FProfiler = {};
FProfiler.Internal = {};
FProfiler.UI = {};

CAMI.RegisterPrivilege( {
    Name = "FProfiler",
    MinAccess = "superadmin"
} );