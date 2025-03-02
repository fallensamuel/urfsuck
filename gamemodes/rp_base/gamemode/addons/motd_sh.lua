-- "gamemodes\\rp_base\\gamemode\\addons\\motd_sh.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
if SERVER then
	util.AddNetworkString('rp.Motd')
	
	rp.AddCommand('/motd', function(pl, text, args)
		net.Start('rp.Motd')
		net.Send(pl)
	end, true)
	
	net.Receive("rp.Motd", function(_, ply)
		hook.Run("MOTD::OpenedURL", ply, net.ReadUInt(4))
	end)
	
else
	net('rp.Motd', function()
		rp.Motd()
	end)
	
	local menu
	local net_btn = {
		['Правила'] = true,
	}
	
	function rp.Motd()
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
        menu:SetSize(320, 52 + 32 * table.Count(rp.cfg.MoTD))
        menu:Center()
        menu:MakePopup()

        menu.header.SetIcon(menu.header, "rpui/misc/flag.png")
        menu.header.SetTitle(menu.header, translates.Get("Справочник"))
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
		
        for k, v in pairs(rp.cfg.MoTD) do
            local pnl = vgui.Create("DButton")
            pnl:SetText("")
            pnl:SetSize(menu:GetWide(), 32)
            pnl.Paint = function(me, w, h)
                local baseColor, textColor = rpui.GetPaintStyle( me, STYLE_TRANSPARENT );
                surface.SetDrawColor( baseColor );
                surface.DrawRect( 5, 1, w - 20, h - 1 );

                draw.SimpleText( v[1], "rpui.MOTD.Font", w*0.5, h*0.5, textColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );

                return true;
            end
            pnl.DoClick = function(me)
				if net_btn[ v[1] ] then
					net.Start("rp.Motd")
						net.WriteUInt(k, 4)
					net.SendToServer()
				end
				
				gui.OpenURL(v[2])
				menu:Close()
            end
			menu.scroll:AddItem(pnl)
        end
	end
end