EmoteActions.SitActions = {
    ["d1_t02_plaza_sit01_idle"] = {
        translates.Get("Нога на ногу 1"),
        Vector(0,0,-22)
    },
    ["plazaidle4"] = {
        translates.Get("На корточках"),
        Vector(24,0,-8)
    },

    ["sitccouchtv1"] = {
        translates.Get("Нога на ногу 2"),
        Vector(20,0,-22)
    },

    ["sitchairtable1"] = {
        translates.Get("За столом"),
        Vector(0,0,-28),
        ShouldHeal = true
    },

    ["sitcouch1"] = {
        translates.Get("Медитация"),
        Vector(20,0,-22),
        ShouldHeal = true
    },

    ["sitcouchknees1"] = {
        translates.Get("Грусть"),
        Vector(20,0,-22)
    },

    ["d1_t02_plaza_sit02"] = {
        translates.Get("Нога на ногу 3"),
        Vector(0,0,-22)
    },

    ["d1_t03_sit_bed"] = {
        translates.Get("Прямая спина"),
        Vector(0,0,-25)
    },

    ["d1_t03_sit_couch"] = {
        translates.Get("За столом (Грусть)"),
        Vector(0,0,-20)
    }
}

for seq in pairs( EmoteActions.SitActions ) do
    if not EmoteActions.SharedSequences[seq] then
        local sharedSeqID = #EmoteActions.SharedSequencesMap + 1;

        EmoteActions.SharedSequences[seq]            = sharedSeqID;
        EmoteActions.SharedSequencesMap[sharedSeqID] = seq;
    end
end

local PLAYER = FindMetaTable( "Player" );

function PLAYER:GetAvalibleSitActions()
	local tab = {}

    for seq, SitAction in pairs( EmoteActions.SitActions ) do
        if self:LookupSequence(seq) ~= -1 then
            tab[seq] = SitAction;
        end 
    end

    return tab
end