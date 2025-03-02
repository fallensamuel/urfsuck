-- "gamemodes\\darkrp\\entities\\weapons\\hacktool\\settings.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
-- Reloading time
CreateConVar("hacktool_reloadingtime", "5", FCVAR_ARCHIVE+FCVAR_REPLICATED+FCVAR_SERVER_CAN_EXECUTE)

-- Error reloading time
CreateConVar("hacktool_overheattime", "10", FCVAR_ARCHIVE+FCVAR_REPLICATED+FCVAR_SERVER_CAN_EXECUTE)

-- Hacking time
CreateConVar("hacktool_hackingtime", "30", FCVAR_ARCHIVE+FCVAR_REPLICATED+FCVAR_SERVER_CAN_EXECUTE)

-- Cable length
CreateConVar("hacktool_ropelength", "150", FCVAR_ARCHIVE+FCVAR_REPLICATED+FCVAR_SERVER_CAN_EXECUTE)

-- REMOVE
CreateConVar("hacktool_hackmoney", "3000", FCVAR_ARCHIVE+FCVAR_REPLICATED+FCVAR_SERVER_CAN_EXECUTE)

-- Server alert time
CreateConVar("hacktool_server_alerttime", "120", FCVAR_ARCHIVE+FCVAR_REPLICATED+FCVAR_SERVER_CAN_EXECUTE)

-- REMOVE
CreateConVar("hacktool_minpolice", "1", FCVAR_ARCHIVE+FCVAR_REPLICATED+FCVAR_SERVER_CAN_EXECUTE)

-- Initial hack chance
CreateConVar("hacktool_server_initialhackchance", "1", FCVAR_ARCHIVE+FCVAR_REPLICATED+FCVAR_SERVER_CAN_EXECUTE)

-- REMOVE
CreateConVar("hacktool_canhack_doors", "1", FCVAR_ARCHIVE+FCVAR_REPLICATED+FCVAR_SERVER_CAN_EXECUTE)

-- REMOVE
CreateConVar("hacktool_canhack_keypads", "1", FCVAR_ARCHIVE+FCVAR_REPLICATED+FCVAR_SERVER_CAN_EXECUTE)

-- REMOVE
CreateConVar("hacktool_canhack_vehicles", "1", FCVAR_ARCHIVE+FCVAR_REPLICATED+FCVAR_SERVER_CAN_EXECUTE)

-- Additional server-side check
CreateConVar("hacktool_serversidecheck", "1", FCVAR_ARCHIVE+FCVAR_REPLICATED+FCVAR_SERVER_CAN_EXECUTE)