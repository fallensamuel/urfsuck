-- "gamemodes\\rp_base\\gamemode\\main\\menus\\f4menu\\controls\\rpui_scrollpanel_cl.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local PANEL = {};

function PANEL:Init()
    self.Parent = self:GetParent();

    self.Width    = 8;
    self.Height   = 0;
    self.Margin   = 0;

    self.ScrollBtn = vgui.Create( "Panel", self );

    self.ScrollBtn.OnMousePressed = function( this, mousebutton )
        if mousebutton == MOUSE_LEFT then
            local mx, my = this:CursorPos();

            this.IsScrolling  = true;
            this.MouseOffset  = my;
        end
    end

    self.ScrollBtn.OnMouseReleased = function( this, mousebutton )
        if mousebutton == MOUSE_LEFT then
            this.IsScrolling = false;
            this.MouseOffset = nil;
        end
    end

    self.ScrollBtn.Paint = function( this, w, h )
        surface.SetDrawColor( Color(255,255,255,255) );
        surface.DrawRect( 0, 0, w, h );
    end
end

function PANEL:SetScrollbarWidth( w )
    self.Width = w;
    self:PerformLayout();
end

function PANEL:SetScrollbarMargin( m )
    self.Margin = m;
    self:PerformLayout();
end

function PANEL:Think()
    if self.ScrollBtn.IsScrolling then
        if not input.IsMouseDown(MOUSE_LEFT) then
            self.ScrollBtn.OnMouseReleased( self.ScrollBtn, MOUSE_LEFT );
            return
        end

        local mx, my = self.ScrollBtn.CursorPos(self.ScrollBtn);
        local diff   = my - self.ScrollBtn.MouseOffset;

		local par_can = self.Parent.GetCanvas(self.Parent);
        local maxOffset = par_can:GetTall() - self.Parent.GetTall(self.Parent);
        local perc      = (self.ScrollBtn.y + diff) / (self:GetTall() - self.Height);

        self.Parent.yOffset = math.Clamp( perc * maxOffset, 0, maxOffset );
        self.Parent.InvalidateLayout(self.Parent);
    end
end

function PANEL:PerformLayout()
	local par_can = self.Parent.GetCanvas(self.Parent);
    local maxOffset = par_can:GetTall() - self.Parent.GetTall(self.Parent);

    self:SetSize( self.Width, self.Parent.GetTall(self.Parent) );
    self:SetPos( self.Parent.GetWide(self.Parent) - self:GetWide(), 0 );

    self.HeightRatio = self.Parent.GetTall(self.Parent) / par_can:GetTall();
    self.Height      = math.max( 20, math.ceil(self.HeightRatio * self.Parent.GetTall(self.Parent)) );

    self.ScrollBtn.SetSize( self.ScrollBtn, self:GetWide(), self.Height );
    self.ScrollBtn.SetPos( self.ScrollBtn, 0, math.Clamp((self.Parent.yOffset / maxOffset), 0, 1) * (self:GetTall() - self.Height) );
end

function PANEL:Paint( w, h )
    surface.SetDrawColor( Color(0,0,0,200) );
    surface.DrawRect( 0, 0, w, h );
end

function PANEL:OnMouseWheeled( dt )
    self.Parent.OnMouseWheeled( self.Parent, dt );
end

vgui.Register( "rpui._scrollbar", PANEL, "Panel" );



local PANEL = {};

function PANEL:Init()
    self.b_ForcedLayouts = false; 

    self.Canvas = vgui.Create( "Panel", self );
    self.VBar   = vgui.Create( "rpui._scrollbar", self );

    self.yOffset = 0;
    self.ySpeed  = 0;

    self.ySpacing = 0;

    self.Canvas.OnChildRemoved = function( this, child )
		local par = this:GetParent();
        par:PerformLayout();
    end
end

function PANEL:AddItem( child )
    child:SetParent( self:GetCanvas() );
end

function PANEL:GetItems()
	local can = self:GetCanvas();
    return can:GetChildren()
end

function PANEL:ClearItems()
    self.Canvas.Clear(self.Canvas);
end

function PANEL:AlwaysLayout( force )        self.b_ForcedLayouts = force;           end 
function PANEL:GetCanvas()                  return self.Canvas;                     end
function PANEL:SetSpacingY( ySpacing )      self.ySpacing = ySpacing;               end
function PANEL:GetSpacingY()                return self.ySpacing                    end
function PANEL:SetScrollbarWidth( width )   self.VBar.SetScrollbarWidth( self.VBar, width );   end
function PANEL:GetScrollbarWidth()          return self.VBar.Width;                 end
function PANEL:SetScrollbarMargin( margin ) self.VBar.SetScrollbarMargin( self.VBar, margin ); end
function PANEL:GetScrollbarMargin()         return self.VBar.Margin                 end

function PANEL:OnMouseWheeled( dt )
    if
        (dt > 0 and self.ySpeed < 0) or
        (dt < 0 and self.ySpeed > 0)
    then
        self.ySpeed = 0;
    else
        self.ySpeed = self.ySpeed + dt * 2;
    end
end

function PANEL:SetOffset( offset )
	local can = self:GetCanvas();
    local maxOffset = math.max( 0, can:GetTall() - self:GetTall() );

    self.yOffset = math.Clamp( offset, 0, maxOffset );
    self:PerformLayout();

    return (self.yOffset == 0 or self.yOffset == maxOffset) and true or false;
end

function PANEL:Think()
    if self.ySpeed ~= 0 then
        if self:SetOffset( self.yOffset - self.ySpeed ) then
            self.ySpeed = 0;
        else
            if self.ySpeed < 0 then
                self.ySpeed = math.Clamp( self.ySpeed + (FrameTime() * 15), self.ySpeed, 0 );
            else
                self.ySpeed = math.Clamp( self.ySpeed - (FrameTime() * 15), 0, self.ySpeed );
            end
        end
    end

    if self.b_ForcedLayouts then
        self:PerformLayout();
        if self.VBar.IsVisible(self.VBar) then self.VBar.PerformLayout(self.VBar); end
    end
end

function PANEL:IsVBarVisible()
    return self.VBar.IsVisible(self.VBar)
end

function PANEL:PerformLayout()
    if self.VBar.IsVisible(self.VBar) then
		local can = self:GetCanvas();
        if can:GetWide() ~= (self:GetWide() - self.VBar.Width - self.VBar.Margin) then
            can:SetWide( self:GetWide() - self.VBar.Width - self.VBar.Margin );
        end
    else
		local can = self:GetCanvas();
        if can:GetWide() ~= self:GetWide() then
            can:SetWide( self:GetWide() );
        end
    end

    local y = 0;
    local lastChild;
	local can = self:GetCanvas();
	
    for _, c in pairs( can:GetChildren() ) do
        if c:GetDock() == NODOCK then
            if c.y ~= (y + self.ySpacing) then
                c:SetPos( 0, y + self.ySpacing );
            end
        else
            local ml, mt, mr, mb = c:GetDockMargin();
            c:DockMargin( ml, mt, mr, self.ySpacing );
        end
        
        y = c.y + c:GetTall() + self.ySpacing;
        lastChild = c;
    end

    y = lastChild and (lastChild.y + lastChild:GetTall()) or y;

    if can:GetTall() ~= y then
        can:SetTall( y );
    end

    if can:GetTall() <= self:GetTall() and self.VBar.IsVisible(self.VBar) then
        can:SetTall( self:GetTall() );
        self.VBar.SetVisible( self.VBar, false );
    elseif can:GetTall() > self:GetTall() and !self.VBar.IsVisible(self.VBar) then
        self.VBar.SetVisible( self.VBar, true );
    end

    local maxOffset = can:GetTall() - self:GetTall();

    if self.yOffset > maxOffset then self.yOffset = maxOffset; end
    if self.yOffset < 0         then self.yOffset = 0;         end

    if can.x ~= 0 or can.y ~= -self.yOffset then
        can:SetPos( 0, -self.yOffset );
        self.VBar.InvalidateLayout(self.VBar);
    end
end

function PANEL:Paint( w, h )
end

vgui.Register( "rpui.ScrollPanel", PANEL, "Panel" );
