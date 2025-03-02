nw.Register"InventoryBlocked":Write(net.WriteBool):Read(net.ReadBool):SetPlayer()
function PLAYER:HasBlockedInventory()
	return self:GetNetVar("InventoryBlocked") or self:GetJobTable().InventoryBlock
end

if SERVER then

	function PLAYER:SetInventoryBlock(b)
		self:SetNetVar("InventoryBlocked", tobool(b))
	end
	
end