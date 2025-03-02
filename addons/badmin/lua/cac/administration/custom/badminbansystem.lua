local self = {}
CAC.BadminBanSystem = CAC.MakeConstructor (self, CAC.BanSystem)

function self:ctor ()
end

-- IReadOnlyBanSystem
function self:GetId ()
	return "BadminBanSystem"
end

function self:GetName ()
	return "Badmin"
end

function self:IsAvailable ()
	return istable(ba)
end

-- IBanSystem
function self:Ban (userId, duration, reason, bannerId)
	RunConsoleCommand('urf', 'ban', userId, '1d', reason)
end

function self:CanBanOfflineUsers ()
	return true
end

CAC.SystemRegistry:RegisterSystem ("BanSystem", CAC.BadminBanSystem ())