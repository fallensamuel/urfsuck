-- "gamemodes\\rp_base\\gamemode\\main\\menus\\scoreboard\\elements\\scoreboard_scroll_cl.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local PANEL = {};

function PANEL:Init()
    self:SetMouseInputEnabled( true );

    self:InitVerticalBar();
    self:InitCanvas();

    self.OnChildAdded = function( this, child )
        child:SetParent( this.m_Canvas );
    end
end

function PANEL:InitVerticalBar()
    self.m_VerticalBar = vgui.Create( "Panel", self );
    self.m_VerticalBar:Dock( RIGHT );
    self.m_VerticalBar:SetWide( 12 );
    self.m_VerticalBar:SetMouseInputEnabled( true );
    self.m_VerticalBar:SetCursor( "hand" );
    self.m_VerticalBar.fl_Velocity = 0;

    self.m_VerticalBar.GetViewport = function( this )
        local parent = this:GetParent();
        return math.min( parent:GetTall() / parent.m_Canvas:GetTall(), 1 );
    end

    self.m_VerticalBar.GetViewportOffset = function( this )
        local parent = this:GetParent();
        return parent.m_Canvas:GetY() / (parent:GetTall() - parent.m_Canvas:GetTall());
    end

    self.m_VerticalBar.OnMousePressed = function( this, key, external )
        if key ~= MOUSE_FIRST then return end

        local h = this:GetTall();

        local mx, my = this:ScreenToLocal( input.GetCursorPos() );
        my = my / h;

        local view, offset = this:GetViewport(), this:GetViewportOffset();
        local y = offset * (1 - view);

        this.fl_DragOffset = (my >= y and my <= (y + view)) and (my - y) / view or 0.5;
        this.fl_Velocity, this.Depressed = 0, true;
        this.fl_MouseY = my;
    end

    self.m_VerticalBar.OnMouseWheeled = function( this, dt )
        this.fl_Velocity = this.fl_Velocity + dt * 2;
    end

    self.m_VerticalBar.Think = function( this )
        if this.Depressed then
            local mx, my = this:ScreenToLocal( input.GetCursorPos() );

            if not input.IsMouseDown( MOUSE_FIRST ) then
                this.Depressed = false;
                this:OnMouseWheeled( this.fl_MouseY - my );
                return
            end

            local parent = this:GetParent();
            local h = this:GetTall();
            local view = this:GetViewport();

            local pos = view * this.fl_DragOffset - my / h;
            pos = math.Clamp( pos, view - 1, 0 );

            parent.m_Canvas:SetY( pos * parent.m_Canvas:GetTall() );
            this.fl_MouseY = my;

            return
        end

        if this.fl_Velocity ~= 0 then
            this:PerformScroll();
        end
    end

    self.m_VerticalBar.PerformScroll = function( this )
        local parent = this:GetParent();
        local ft = RealFrameTime();

        local old = parent.m_Canvas:GetY();

        local new = old + this.fl_Velocity;
        new = math.Clamp( new, parent:GetTall() - parent.m_Canvas:GetTall(), 0 );

        parent.m_Canvas:SetY( new );

        if old == new then
            this.fl_Velocity = 0;
            return
        end

        this.fl_Velocity = math.Approach( this.fl_Velocity, 0, 15 * ft );
    end

    self.m_VerticalBar.PaintTrack = function( this, w, h )
        derma.SkinHook( "Paint", "VScrollBar", self, w, h );
    end

    self.m_VerticalBar.SetDisabled = function( this, disabled )
        this.Disabled = disabled;
    end

    self.m_VerticalBar.GetDisabled = function( this )
        return this.Disabled;
    end

    self.m_VerticalBar.PaintGrip = function( this, w, h )
        derma.SkinHook( "Paint", "ScrollBarGrip", this, w, h );
    end

    self.m_VerticalBar.m_GripMatrix = Matrix();

    self.m_VerticalBar.Paint = function( this, w, h )
        local parent = this:GetParent();

        local view = this:GetViewport();
        local real = h * view;
        local offset = this:GetViewportOffset() * (h - real);

        local x, y = this:LocalToScreen( 0, 0 );
        render.SetScissorRect( x, y, x + w, y + h, true );
            this:PaintTrack( w, h );

            this.m_GripMatrix:SetTranslation( Vector(0, offset) );
            cam.PushModelMatrix( this.m_GripMatrix, true );
                this:PaintGrip( w, real );
            cam.PopModelMatrix();
        render.SetScissorRect( 0, 0, 0, 0, false );
    end
end

function PANEL:InitCanvas()
    self.m_Canvas = vgui.Create( "Panel", self );

    self.m_Canvas.PerformLayout = function( this, w, h )
        this:GetParent():PerformLayoutInternal();
        this:InvalidateParent();
    end
end

function PANEL:GetCanvas()
    return self.m_Canvas;
end

function PANEL:GetVerticalBar()
    return self.m_VerticalBar;
end

function PANEL:OnMouseWheeled( ... )
    self.m_VerticalBar:OnMouseWheeled( ... );
end

function PANEL:PerformLayoutInternal()
    local canvas, bar = self:GetCanvas(), self:GetVerticalBar();

    canvas:SizeToChildren( false, true );
    bar[bar:GetViewport() < 1 and "Show" or "Hide"]( bar );

    local w = self:GetWide();

    if bar:IsVisible() then
        local ml, mt, mr, mb = bar:GetDockMargin();
        canvas:SetWide( w - bar:GetWide() - (ml + mr) );
    else
        canvas:SetWide( w );
    end

    canvas:SizeToChildren( false, true );
    bar:PerformScroll();
end

function PANEL:PerformLayout()
    self:PerformLayoutInternal();
end

function PANEL:InnerWidth()
    return self.m_Canvas:GetWide();
end

function PANEL:Clear()
    self.m_Canvas:Clear();
end

function PANEL:AddItem( child )
    self:OnChildAdded( child );
end

vgui.Register( "rpui.ScoreboardScroll", PANEL, "EditablePanel" );