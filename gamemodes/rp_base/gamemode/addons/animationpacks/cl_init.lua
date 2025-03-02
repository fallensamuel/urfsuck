-- "gamemodes\\rp_base\\gamemode\\addons\\animationpacks\\cl_init.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
----------------------------------------------------------------
hook.Add( "PlayerAnimPackHoldType", "AnimationPacks::OverrideHoldType", function( ply, value )
    ply.animpack_HoldType = value;
end );


----------------------------------------------------------------
local PLAYER = FindMetaTable( "Player" );

function PLAYER:SetAnimationPack( id )
    net.Start( "net.rp.animpack" );
        net.WriteUInt( id, 5 );
    net.SendToServer();
end

function PLAYER:SetAnimPack( id )
    self:SetAnimationPack( id );
end


----------------------------------------------------------------
rp.AddContextCommand( translates.Get("Анимации"), translates.Get("Паки анимаций"),
    function( parent )
        -- Base:
        local m = vgui.Create( "rpui.DropMenu" );
        m:SetBase( parent );
        m:SetFont( "Context.DermaMenu.Label" );
        m:SetSpacing( ScrH() * 0.01 );
        m.Paint = function( this, w, h ) draw.Blur( this ); end

        -- Default option:
        local default_option = m:AddOption( translates.Get("Стандартные"), function( this )
            if not this.Selected then
                LocalPlayer():SetAnimationPack( this.UID );
                for k, v in ipairs( m:GetChildren() ) do v.Selected = false; end
                this.Selected = true;
            end
        end );

        local AnimPackID = LocalPlayer():GetJobTable().animationPack;
        if AnimPackID then
            local AnimPack = AnimationPacks.Get( AnimPackID );

            if AnimPack then
                if AnimPack.CustomCheck then        
                    if AnimPack.CustomCheck(LocalPlayer()) then
                        default_option.UID = AnimPack.UID;
                        default_option:SetText( AnimPack.Name );
                    end
                else
                    default_option.UID = AnimPack.UID;
                    default_option:SetText( AnimPack.Name );
                end
            end
        end

        default_option.UID = default_option.UID or 0;

        -- Animation Packs:
        for id, AnimPack in pairs( AnimationPacks.GetTable() ) do
            if AnimPack.UID == default_option.UID then continue end
            if AnimPack.CustomCheck and (not AnimPack.CustomCheck(LocalPlayer())) then continue end

            local option = m:AddOption( AnimPack.Name or id, function( this )
                if not this.Selected then
                    LocalPlayer():SetAnimationPack( this.UID );
                    for k, v in ipairs( m:GetChildren() ) do v.Selected = false; end
                    this.Selected = true;
                end
            end );

            option.UID = AnimPack.UID;
        end

        --
        local ply_animpack = LocalPlayer():GetAnimationPack() or 0;
        for k, option in ipairs( m:GetChildren() ) do
            option.Selected = (option.UID == ply_animpack);

            option.Paint = function( this, w, h )
                local baseColor, textColor = rpui.GetPaintStyle( this, STYLE_TRANSPARENT_SELECTABLE );
                surface.SetDrawColor( baseColor );
                surface.DrawRect( 0, 0, w, h );
                draw.SimpleText( this:GetText(), this:GetFont(), this.Spacing, h * 0.5, textColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER );
                return true
            end

            option.BaseDoClick = option.DoClick;
            option.DoClick = function( this )
                m:SetMouseInputEnabled( false );

                timer.Simple( 1, function()
                    if not IsValid( m ) then return end
                    m:SetMouseInputEnabled( true );
                end );

                option:BaseDoClick();
            end
        end
        
        m:Open();
    end,

    function()
        for id, AnimPack in pairs( AnimationPacks.GetTable() ) do
            if AnimPack.CustomCheck then
                if AnimPack.CustomCheck( LocalPlayer() ) then
                    return true
                end
            else
                return true
            end
        end

        return false
    end,
"cmenu/chat" );