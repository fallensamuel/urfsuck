-- "gamemodes\\rp_base\\entities\\entities\\fake_loyality_base.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
AddCSLuaFile()
DEFINE_BASECLASS( "base_anim" )

ENT.Type			= "anim"
ENT.Base			= "base_entity"
ENT.RenderGroup		= RENDERGROUP_BOTH
ENT.PrintName		= "Fake Licnese Base"
ENT.Author			= "urf.im"
ENT.Category		= "Other"
ENT.Model			= "models/props_lab/clipboard.mdl"

ENT.AdminOnly		= true
ENT.AdminSpawnable	= false
ENT.Spawnable		= false

if SERVER then
	
	
	function ENT:Initialize()
		self:SetModel( self.Model )
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetMoveType( MOVETYPE_VPHYSICS )
		self:SetSolid( SOLID_VPHYSICS )
		self:DrawShadow(false)
		
		local phys = self:GetPhysicsObject()
		phys:EnableMotion(false)

		self.PhysgunDisabled = true
	end

	function ENT:Use(ply)
		if self.Used then return end
		
		if not IsValid(ply) or not ply:IsPlayer() then
			return
		end
		
		if self.NextUse and self.NextUse > CurTime() then
			return
		end
		
		self.NextUse = CurTime() + 1
		
		net.Start("FakeLoyalty::OpenMenu")
			net.WriteEntity(self)
		net.Send(ply)
		
		rp.Notify(ply, NOTIFY_GREEN, rp.Term("FakeLoyalty::Choose"))
	end
	
	hook.Add("PlayerDeath", "FakeLoyalty::Reset", function(ply)
		ply:SetNetVar("FakedLoyalty", nil)
	end)
	
else
	function ENT:Draw()
		self:DrawModel()
		if(self:GetPos():Distance(LocalPlayer():GetPos()) > 300) then return end
	end
	
	local menu
	function ENT:OpenMenu()
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
        menu.header.SetTitle(menu.header, translates.Get(self.Title or "Поддельная лояльность"))
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
		
		local loyalties = self.Loyality or #rp.GetTerm('loyalty')
		
		for k = 1, loyalties do
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
					net.WriteEntity(self)
					net.WriteUInt(k, 8)
				net.SendToServer()
				
				menu:Close()
            end
			menu.scroll:AddItem(pnl)
		end
		
		/*
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
		*/
	end
	
end
