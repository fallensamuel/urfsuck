--[[
	Chessnut's NPC System
	Do not re-distribute without author's permission.

	Revision f9eac7b3ccc04d7a7834987aea7bd2f9cb70c8e0a58637a332f20d1b3d2ad790
--]]

ENT.Type = "anim"
ENT.PhysgunDisable = true
ENT.PhysgunDisabled = true

function ENT:setAnim()
    local uniqueID = self:GetQuest()
    local custom = uniqueID and cnQuests[uniqueID] and cnQuests[uniqueID].sequence

    if (custom) then
        custom = custom:lower()

        for k, v in ipairs(self:GetSequenceList()) do
            if (v:lower():find(custom)) then
                return self:ResetSequence(k)
            end
        end
    end

	for k, v in ipairs(self:GetSequenceList()) do
		if (v:lower():find("idle") and v != "idlenoise") then
			return self:ResetSequence(k)
		end
	end

	self:ResetSequence(4)
end

function ENT:SetupDataTables()
	self:NetworkVar("String", 0, "Quest")
end