-- "gamemodes\\rp_base\\entities\\entities\\ent_loot_roulette\\cl_init.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
include( "shared.lua" );

local BaseClass = baseclass.Get( "base_urf_itemroulette" );


function ENT:PostInitialize()
	self:SetPrintName( translates.Get("ОБЫСК") );
end


function ENT:Finish()
    if self:GetHideEmpty() then
        if self.Activator ~= LocalPlayer() then return end

        local CooldownTime = ((self.LastUse or 0) + (self:GetCooldown() or 0)) - CurTime();

        if CooldownTime > 0 then
            self:SetNoDraw( true );
            self.Hidden = true;

            timer.Simple( CooldownTime, function()
                if not IsValid( self ) then return end
                self:SetNoDraw( false );
                self.Hidden = false;
            end );
        end
    end
end


function ENT:Draw( ... )
    if not self.Hidden then
        BaseClass.Draw( self, ... );
    end
end


local cachedmats = {
    [false] = Material( "bubble_hints/lootbox.png", "smooth" ),
    [true]  = Material( "bubble_hints/refresh.png", "smooth" )
};

rp.AddBubble( "entity", "ent_loot_roulette", {
    ico = function( ent )
        ent.bubblestatus = ((ent.LastUse and ent.LastUse + (ent:GetCooldown() or 0) or 0)) > CurTime();
        return cachedmats[ent.bubblestatus];
    end,

    --ico_rotate = function( ent )
    --    return ent.bubblestatus;
    --end,

    name = function( ent )
        if ent.bubblestatus then
            return ent:GetPrintName() or "ent_loot_roulette";
        else
            return "";
        end
    end,

    desc = function( ent )
        if ent.bubblestatus then
            local t = string.FormattedTime( ((ent.LastUse and ent.LastUse + (ent:GetCooldown() or 0) or 0)) - CurTime() );
            if t.h > 0 then
                return string.format( "%02i:%02i:%02i", t.h, t.m, t.s );
            else
                return string.format( "%02i:%02i", t.m, t.s );
            end
        else
            return "";
        end
    end,

    offset = Vector( 0, 0, 14 ),

    customCheck = function( ent )
        if ent:GetHideEmpty() then
            return (not ent.Hidden) and (not ent.Initialized3D2D);
        else
            return not ent.Initialized3D2D;
        end
    end,
} );