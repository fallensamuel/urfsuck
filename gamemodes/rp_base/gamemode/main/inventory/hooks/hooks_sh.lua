hook.Add("CanItemBeTransfered","CanItemBeTransfered", function(itemObject, curInv, inventory)
	if (itemObject and itemObject.isBag) then
		if (inventory.id != 0 and curInv.id != inventory.id) then
			if (inventory.vars and inventory.vars.isBag) then
				return false 
			end
		end

		local inventory = rp.item.inventories[itemObject:getData("id")]

		if (inventory) then
			for k, v in pairs(inventory:getItems()) do
				if (v:getData("equip") == true) then
					local owner = itemObject:getOwner()

					return false
				end
			end
		end
	end
end)

hook.Add("CanPlayerInteractItem","CanPlayerInteractItem", function(client, action, item)
	if client.HasBlockedInventory and client:HasBlockedInventory() then return false end
	-- if (client:getNetVar("restricted")) then
	-- 	return false
	-- end

	if (action == "drop" and hook.Run("CanPlayerDropItem", client, item) == false) then
		return false
	end

	if (action == "take" and hook.Run("CanPlayerTakeItem", client, item) == false) then
		return false
	end

	return client:Alive()
end)

ba.cmd.Create('Giveitem', function(pl, args)
	if not IsValid(args.target) then return end
	local inv = args.target:getInv()
	if not inv then return end
	local count = tonumber(args.count)

	local result, msg = inv:add(args.uniqueID, count)

	if result then
		ba.notify(pl, translates.Get("Игроку %s выдан предмет %s в количестве %i штук", args.target:GetName(), args.uniqueID, count))
		ba.notify(args.target, translates.Get("Вам был выдан предмет: %s в количестве %i штук", args.uniqueID, count))
	else
		ba.notify(pl, translates.Get("Предмет не был выдан по причине: %s", msg))
	end
end)
:AddParam('player_entity', 'target')
:AddParam('string', 'uniqueID')
:AddParam('string', 'count')
:SetFlag('e')
:SetHelp('Gives an item to the player inventory.')

ba.cmd.Create('Itemlist')
:RunOnClient(function()
	local fr = ui.Create( "ui_frame", function( self )
		self:SetTitle( translates.Get("Список предметов") );

		self:SetSize( ScrW() * 0.4, ScrH() * 0.6 );
		self:Center();
		self:MakePopup();
	end );

	fr.searchBar = ui.Create( "DTextEntry", function( self )
		self:Dock( TOP );
		self:SetTall( 24 );
		self:DockMargin( 0, 4, 0, 4 );
		self:SetUpdateOnType( true );

		self.OnValueChange = function( this, value )
			fr.listItems:SearchForItems( value );
		end
	end, fr );

	fr.listItems = ui.Create( "ui_listview", function( self )
		self:Dock( FILL );
		self.Paint = nil;

		self.ItemPanels = {};
		
		self.SearchForItems = function( this, needle )
			for k, v in pairs( this.ItemPanels ) do
				if IsValid( v ) then
					v:Remove();
					this.ItemPanels[k] = nil;
				end
			end

			needle = string.lower( string.Trim(needle or "") );

			for k, v in pairs( rp.item.list ) do
				local name, uniqueID = string.lower( v.name ), string.lower( v.uniqueID );
				
				if string.StartWith( name, needle ) or string.StartWith( uniqueID, needle ) or needle == "" then
					local itemPnl = ui.Create( "DButton", self );
					itemPnl.Title = "[" .. v.uniqueID .. "] " .. v.name;

					itemPnl.Model = ui.Create( "rp_modelicon", itemPnl );
					itemPnl.Model:SetPos( 0, 0 );
					itemPnl.Model:SetSize( 50, 50 );
					itemPnl.Model:SetModel( v.model );

					itemPnl:SetTall( 50 );
					itemPnl:SetText( "" );
					itemPnl.DoClick = function( this )
						rp.Notify( NOTIFY_WARN, translates.Get("Уникальный айди предмета '%s' был скопирован. (%s)", v.name, v.uniqueID) );
						SetClipboardText( v.uniqueID );
						fr:Close();
					end

					itemPnl.Model.DoClick = itemPnl.DoClick;

					itemPnl.PaintOver = function( this, w, h )
						draw.SimpleTextOutlined(
							itemPnl.Title,
							"rp.ui.22",
							60,
							h * 0.5,
							rp.col.White,
							TEXT_ALIGN_LEFT,
							TEXT_ALIGN_CENTER,
							1,
							rp.col.Black
						);
					end

					self:AddItem( itemPnl );
					table.insert( self.ItemPanels, itemPnl );
				end
			end
		end

		self:SearchForItems( "" );
	end, fr );

	for k, v in pairs( rp.item.list ) do
		MsgC( Color(67,193,67), v.name .. "\n" );
		MsgC( Color(212,122,37), "uniqueID: " .. v.uniqueID .. "\n" );
		MsgC( Color(67,185,193), "desc: " .. v.desc .. "\n" );
		MsgC( Color(255,255,255), "--------------------------------------------------------\n" );
	end
end)
:SetFlag('*')
:SetHelp('Displays a list of all items inventory in the console.')

ba.cmd.Create('Deleteinv', function(pl, args)
	if not IsValid(args.target) then return end
	rp._Inventory:Query("DELETE FROM inventories WHERE _charID = "..args.target:SteamID64()..";")

	ba.notify(pl, translates.Get("Инвентарь игрока %s был удален!", args.target:GetName()))
	ba.notify(args.target, translates.Get("Ваш инвентарь был удален!"))
end)
:AddParam('player_entity', 'target')
:SetFlag('*')
:SetHelp('Delete player inventory.')