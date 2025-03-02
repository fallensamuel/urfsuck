-- "gamemodes\\rp_base\\entities\\entities\\ent_loot_roulette\\shared.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local BaseClass = baseclass.Get( "base_urf_itemroulette" );

ENT.PrintName       = "Trash Lootbox";
ENT.Category        = "RP Item Roulettes";
ENT.Spawnable       = true;
ENT.AdminOnly       = true;


function ENT:SetupDataTables()
	self:NetworkVar( "String", 0, "LootType" );
	self:NetworkVar( "Float", 0, "Cooldown" );
	self:NetworkVar( "Bool", 0, "HideEmpty" );
end


function ENT:Setup()
	if CLIENT then
		self:Set3D2DScaling( (self:GetActivator() == LocalPlayer()) and 1 or 0.75 );
	end

	if not self.ItemPoolInitialized then
		local ItemPool = {};

		for k, v in pairs( rp.item.loot[self:GetLootType()].items or {} ) do
			local ItemData = {};
			
			ItemData.type   = "invitem";
			ItemData.name   = v.item.name;
			ItemData.mdl    = v.item.model;
			ItemData.weight = v.procent;
			ItemData.rarity = math.min( math.floor( ((100 - v.procent) / 100) * 4 ), 4 );
			ItemData.v      = v.item.uniqueID;

			table.insert( ItemPool, ItemData );
		end

		self:SetItemPool( ItemPool );
		self.ItemPoolInitialized = true;
	end
end