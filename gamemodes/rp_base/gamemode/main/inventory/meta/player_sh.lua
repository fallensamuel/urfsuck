-- "gamemodes\\rp_base\\gamemode\\main\\inventory\\meta\\player_sh.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
nw.Register"InventoryBlocked":Write(net.WriteBool):Read(net.ReadBool):SetPlayer()
function PLAYER:HasBlockedInventory()
	return IsValid(self) and self:GetNetVar("InventoryBlocked") or (self:GetJobTable() and self:GetJobTable().InventoryBlock)
end

if SERVER then

	function PLAYER:SetInventoryBlock(b)
		self:SetNetVar("InventoryBlocked", tobool(b))
	end
	
end