-- "gamemodes\\rp_base\\gamemode\\addons\\experiences\\sh_meta_experiencetype.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
----------------------------------------------------------------
rp.Experiences = rp.Experiences or {};
rp.Experiences.Types = {};

----------------------------------------------------------------
local META = {};

function META:SetPrintName( printname )
    self.PrintName = printname;
    return self;
end

function META:GetPrintName()
    return self.PrintName or self.ID or "N/A";
end

function META:SetDescription( desc )
    self.Description = desc;
    return self;
end

function META:GetDescription()
    return self.Description;
end

function META:SetLevelFormula( fn )
    self.LevelFormula = fn;
    return self;
end

function META:ExperienceToLevel( exp )
    local lv = 0;

    if isfunction( self.LevelFormula ) then
        lv = math.floor( self.LevelFormula(exp, false) or 0 );
    end

    return lv;
end

function META:LevelToExperience( lv )
    local exp = 0;

    if isfunction( self.LevelFormula ) then
        exp = self.LevelFormula( lv, true ) or 0;
    end

    return exp;
end

function META:SetLevelRewards( lv, ... )
    self.LevelRewards = self.LevelRewards or {};

    self.LevelRewards[lv] = {};

    for k, v in ipairs( {...} ) do
        v = tostring( v );

        if not isstring( v ) then
            continue
        end

        self.LevelRewards[lv][k] = v;
    end

    return self;
end

function META:GetNextLevelReward( lv )
    if self.LevelRewards then
        local keys = table.GetKeys( self.LevelRewards );
        table.sort( keys );

        for k, level in ipairs( keys ) do
            if lv > level then continue end
            return level, self.LevelRewards[level];
        end
    end

    return false;
end

----------------------------------------------------------------
function rp.Experiences:GetExperienceType( id )
    if self.Types[id] then
        return self.Types[id];
    end

    local t = {};
    t["ID"] = id;

    self.Types[id] = setmetatable( t, { __index = META } );
    return self.Types[id];
end

----------------------------------------------------------------
local LUT_GTAOnline_Experiences = {
    [0]      = 1,
    [800]    = 2,
    [2100]   = 3,
    [3800]   = 4,
    [6100]   = 5,
    [9500]   = 6,
    [12500]  = 7,
    [16000]  = 8,
    [19800]  = 9,
    [24000] = 10,
};

local LUT_GTAOnline_Levels = {
    [1]  = 0,
    [2]  = 800,
    [3]  = 2100,
    [4]  = 3800,
    [5]  = 6100,
    [6]  = 9500,
    [7]  = 12500,
    [8]  = 16000,
    [9]  = 19800,
    [10] = 24000,
};

hook.Add( "ConfigLoaded", "experiencestest-type", function()
    rp.Experiences:GetExperienceType( "generic" )
        :SetPrintName( "Generic Experience" )
        :SetDescription( "Placeholder Description" )
        :SetLevelRewards( 5, "- #1: ayo", "- #2: lmao" )
        :SetLevelFormula( function( v, reverse )
            if reverse then
                local keys = table.GetKeys( LUT_GTAOnline_Levels );
                table.sort( keys );

                local exp = 0;

                for k, level in ipairs( keys ) do
                    if level > v then break end
                    exp = LUT_GTAOnline_Levels[level];
                end

                return exp;
            end

            --

            local keys = table.GetKeys( LUT_GTAOnline_Experiences );
            table.sort( keys );

            local lv = 0;

            for k, experience in ipairs( keys ) do
                if experience > v then break end
                lv = LUT_GTAOnline_Experiences[experience];
            end

            return lv;
        end )
end );