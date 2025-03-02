-- "gamemodes\\rp_base\\entities\\entities\\ent_lootbox_shared\\cl_init.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
include( "shared.lua" );


net.Receive( "ent_lootbox_shared", function()
    LocalPlayer().donateLastCatName = translates.Get( "КЕЙСЫ" );
    RunConsoleCommand( "say", "/upgrades" );
end );


local math_sqrt = math.sqrt;
local math_max = math.max;


local function CalculateRoulette( self )
	self.rt = self:GetRouletteTime() or 0
	
	if not self.box_data and self.GetBoxUID and self:GetBoxUID() then
		self.box_data = rp.lootbox.Get(self:GetBoxUID())
	end
	
	if not self.box_data then return end
	
	self.DrawTrans = math.Approach(self.DrawTrans or 0, (self.rt == 0 or self:GetEnding()) and 0 or 1, 0.04)
	
	if (self.DrawTrans <= 0.01) and self.Abort then
        self.Abort    = nil;
        self.Boxes    = nil;
        self.Selected = nil;
	end

	self.r_speed = ((self.rt - CurTime() > 10) and (self.rt - CurTime() - 9) * (3.6) or math_sqrt(math_max(self.rt - CurTime(), 0))) * (self.Abort and 0.6 or 1) * (RealTime() - (self.last_time or RealTime())) * 100
	
	self.last_time = RealTime()
end


function ENT:CalculateRoulette()
	CalculateRoulette( self );
end


local ENT_BubbleIcons = {
    ["default"] = Material( "bubble_hints/lootbox.png", "smooth noclamp" ),
    [2]         = Material( "bubble_hints/gift.png", "smooth noclamp" ),
};

local oldUID = "";
local CachedLB;

rp.AddBubble( "entity", "ent_lootbox_shared", {
	ico = function( ent )
        return ENT_BubbleIcons[ent:GetBoxMode()] or ENT_BubbleIcons["default"];
    end,

	name = function( ent )
        if oldUID ~= ent:GetBoxUID() then
            CachedLB = nil;    
        end

        if not CachedLB then
            CachedLB = rp.lootbox.Map[ent:GetBoxUID()]; 
        end

        return ((ent:GetBoxMode() == ent.BOXMODE_DEMO) and translates.Get("Пробный") .. " " or "") .. (CachedLB and CachedLB.name or translates.Get("Кейс"));
	end,

	desc = function( ent )
        if CachedLB then
            local time_t;

            if ent:GetBoxMode() == ent.BOXMODE_DEMO then
                return translates.Get("[E] Откройте кейс и узнайте что может Вам выпасть!")
            end

            if ent:GetBoxMode() == ent.BOXMODE_SHARED then
                for uid, case in pairs( LocalPlayer():GetLootboxes() ) do
                    if (not case.spawned) and (case.id == ent:GetBoxUID())  then
                        return translates.Get("[E] Открыть кейс")
                    end
                end
            end

            if CachedLB.cooldown_time then
                local cds = LocalPlayer():GetNetVar("LootboxCooldowns") or {};
                
                local CachedLB_CD = cds[CachedLB.NID];
                if CachedLB_CD and (tonumber(CachedLB_CD) > os.time()) then
                    time_t = tonumber( CachedLB_CD ) - os.time();
                end

                if CachedLB.needed_time and LocalPlayer():GetTodayPlaytime() < CachedLB.needed_time and (not time_t or (time_t < CachedLB.needed_time - LocalPlayer():GetTodayPlaytime())) then
                    time_t = CachedLB.needed_time - LocalPlayer():GetTodayPlaytime();
                end
    
                if (time_t or 0) > 0 then
                    time_t = string.FormattedTime( time_t );
                    return string.format( "%s %s %s: %02i:%02i:%02i!", translates.Get("Получите свой"), CachedLB.name, translates.Get("через"), time_t.h, time_t.m, time_t.s );
                else
                    return translates.Get("[E] Получить кейс (F4 -> Донат -> Кейсы)")
                end
            end
        end
        
        return translates.Get("[E] Купить кейс (F4 -> Донат -> Кейсы)")
    end,

    ico_col = function( ent )
        if CachedLB and CachedLB.color then
            return CachedLB.color
        end

        return color_white
    end,

	title_colr = function( ent )
        if CachedLB and CachedLB.color then
            return CachedLB.color
        end

        return color_white
    end,

    customCheck = function( ent )
    	return (ent.DrawTrans or 0) < 0.01
    end,
} );