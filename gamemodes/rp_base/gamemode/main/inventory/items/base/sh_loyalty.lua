-- "gamemodes\\rp_base\\gamemode\\main\\inventory\\items\\base\\sh_loyalty.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
ITEM.name = "Фейк лояльность"
ITEM.model = "models/props_lab/clipboard.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.desc = ""
ITEM.category = "Storage"
ITEM.permit = "misc"
ITEM.noDrop = true
ITEM.notCanGive = true
ITEM.noUseFunc = true

/*
ITEM.functions.Open = {
    name = translates.Get("Использовать"),
    icon = "icon16/add.png",
    onRun = function(item)
		PrintTable(item)
		
        return false
    end,
    onCanRun = function(item)
        return IsValid(item.entity) and IsValid(item.player)
    end
}
*/

if CLIENT then
	local menu
	local function openMenu(item_id, loyalty)
		if IsValid(menu) then 
			return 
		end
		
		surface.CreateFont( "rpui.MOTD.Font", {
			font     = "Montserrat",
			extended = true,
			weight = 500,
			size     = 21,
		} );
		
		menu = vgui.Create("urf.im/rpui/menus/blank&scroll")
        menu:SetSize(320, 52 + 32 * loyalty)
        menu:Center()
        menu:MakePopup()

        menu.header.SetIcon(menu.header, "rpui/misc/flag.png")
        menu.header.SetTitle(menu.header, translates.Get("Поддельная лояльность"))
        menu.header.SetFont(menu.header, "rpui.playerselect.title")

        menu.header:SetTall(32)
        
		function menu:PerformLayout(w, h)
            self.header.SetSize(self.header, self:GetWide(), 32)

            local ScrollContainer = self.ScrollContainer
            
            ScrollContainer:SetPos(0, self.header.GetTall(self.header))
            ScrollContainer:SetSize(self:GetWide(), self:GetTall() - self.header.GetTall(self.header))

            if self.NoAutomaticItemSize then
                if self.PostPerformLayout then
                    self:PostPerformLayout()
                end
                return
            end

            if self.CustomItemsSize then
                local Sw, Sh = ScrollContainer:GetSize()
                for k, pnl in pairs(self.scroll_items) do
                    if not IsValid(pnl) then self.scroll_items[k] = nil continue end
                    pnl:SetSize(self:CustomItemsSize(Sw, Sh))
                end
            else
                local wide = ScrollContainer:GetWide() * (self.itemWideM or 0.85)
                local tall = self.itemTall or 30

                for k, pnl in pairs(self.scroll_items) do
                    if not IsValid(pnl) then self.scroll_items[k] = nil continue end
                    pnl:SetSize(wide, tall)
                end
            end

            if self.PostPerformLayout then
                self:PostPerformLayout()
            end
        end
		
        menu.header.IcoSizeMult = 1.25

		menu.scroll:DockMargin(5, 10, 5, 10)
		
		for k = 1, loyalty do
			local v = rp.GetTerm('loyalty')[k]
			
			local pnl = vgui.Create("DButton")
            pnl:SetText("")
            pnl:SetSize(menu:GetWide(), 32)
            pnl.Paint = function(me, w, h)
                local baseColor, textColor = rpui.GetPaintStyle( me, STYLE_TRANSPARENT );
                surface.SetDrawColor( baseColor );
                surface.DrawRect( 5, 1, w - 20, h - 1 );

                draw.SimpleText( v, "rpui.MOTD.Font", w*0.5, h*0.5, textColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );

                return true;
            end
            pnl.DoClick = function(me)
				net.Start("FakeLoyalty::OpenMenu")
					net.WriteUInt(item_id, 32)
					net.WriteUInt(k, 8)
				net.SendToServer()
				
				menu:Close()
            end
			menu.scroll:AddItem(pnl)
		end
	end
	
	
	ITEM.functions.Loyalty = {
		name = translates.Get("Использовать"),
		icon = "icon16/add.png",
		onClick = function(item)
			if item.player:GetNetVar("FakedLoyalty") and item.player:GetNetVar("FakedLoyalty") > 0 then
				rp.Notify(NOTIFY_GREEN, rp.Term('FakeLoyalty::Invalid'))
				return
			end
			
			local item_id = item.id
			local loyalty = rp.item.list[item.uniqueID].loyalty
			
			openMenu(item_id, loyalty)
			
			rp.Notify(NOTIFY_GREEN, rp.Term("FakeLoyalty::Choose"))
		end,
		onRun = function(item)
			return false
		end,
		onCanRun = function(item)
			return not IsValid(item.entity) and IsValid(item.player)
		end,
	}
	
else
	util.AddNetworkString("FakeLoyalty::OpenMenu")
	
	net.Receive("FakeLoyalty::OpenMenu", function(_, ply)
		local item_id = net.ReadUInt(32)
		local loyalty = net.ReadUInt(8)
		
		local item = rp.item.instances[item_id]
		
		if not item then
			return
		end
		
		local base_item = rp.item.list[item.uniqueID]
		
		if not base_item or not base_item.loyalty or base_item.loyalty < loyalty or loyalty > #rp.GetTerm('loyalty') then
			return
		end
		
		rp.Notify(ply, NOTIFY_GREEN, rp.Term("FakeLoyalty::Selected"), rp.GetTerm('loyalty')[loyalty])
		
		ply:SetNetVar("FakedLoyalty", loyalty)
		item:remove()
	end)
end

nw.Register('FakedLoyalty')
	:Write(net.WriteUInt, 8)
	:Read(net.ReadUInt, 8)
	:SetPlayer()
