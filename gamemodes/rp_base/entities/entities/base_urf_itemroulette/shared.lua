-- "gamemodes\\rp_base\\entities\\entities\\base_urf_itemroulette\\shared.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
DEFINE_BASECLASS( "base_anim" );

ENT.PrintName		= "Item Roulette Base";
ENT.Category        = "RP Item Roulettes";
ENT.Spawnable       = true;
ENT.AdminOnly       = true;


ENT.ItemAnimationDuration = 12;


function ENT:GetItemPool()
    return self.ItemPool or {};
end


function ENT:SetItemPool( pool )
    self.ItemPool = pool;

    if #self.ItemPool < 2 then
        self.AnimationDuration = 0;
    else
        self.AnimationDuration = self.ItemAnimationDuration;
    end
end


function ENT:DistanceCheck( ply )
    return ply:GetPos():DistToSqr( self:GetPos() ) <= 65536; -- 256 units
end


function ENT:GetWeightedRandom( ply )
    local weights = 0;
    
    local pool = {};
    for k, v in pairs( self:GetItemPool() ) do
        if not IsValid( ply ) then
            table.insert( pool, v );
            continue
        end

        if v.check then
            if v.check( ply ) then table.insert( pool, v ); end
        else
            table.insert( pool, v );
        end
    end

    for _, item in pairs( pool ) do
        weights = weights + (item.weight or 0);
    end

    local selection = math.random( 0, weights );

    for id, item in pairs( pool ) do
        selection = selection - (item.weight or 0);
        if selection <= 0 then return item, id; end
    end
end


ENT:SetItemPool( {
    {
        type = "weapon",
        name = "Crowbar",
        mdl = "models/weapons/w_crowbar.mdl",
        rarity = 0,
        weight = 1,
        v = "weapon_crowbar"
    },
--[[
    {
        type = "weapon",
        name = "9mm Pistol",
        mdl = "models/weapons/w_pistol.mdl",
        rarity = 1,
        weight = 1,
        v = "weapon_pistol"
    },

    {
        type = "weapon",
        name = "AR2",
        mdl = "models/weapons/w_irifle.mdl",
        rarity = 2,
        weight = 1,
        v = "weapon_ar2"
    },

    {
        type = "weapon",
        name = "RPG",
        mdl = "models/weapons/w_c4_planted.mdl",
        rarity = 3,
        weight = 1,
        v = "weapon_rpg"
    },

    {
        type = "weapon",
        name = "shit",
        icon = function( self, iw, ih, w, h, i )
            if not self.precached then
                ModelIcons.Get( "models/weapons/w_bugbait.mdl", Angle(35,220,0), 1, function( m ) self.iconmat = m; end );
                self.precached = true;
            end

            if self.iconmat then
                surface.SetDrawColor( HSVToColor( (CurTime() * 50) % 360, 1, 1 ) );
                surface.SetMaterial( self.iconmat );
                surface.DrawTexturedRect(
                    iw * 0.5 - w * 0.5,
                    ih * 0.5 - h * 0.5 + math.sin((CurTime()+i*50)*5) * (h * 0.125),
                    w, h
                );
            end
        end,
        rarity = 4,
        weight = 5,
        v = "weapon_bugbait"
    },
]]--
} );