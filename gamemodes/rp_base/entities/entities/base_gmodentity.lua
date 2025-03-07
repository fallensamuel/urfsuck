-- "gamemodes\\rp_base\\entities\\entities\\base_gmodentity.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
AddCSLuaFile()
DEFINE_BASECLASS("base_anim")
ENT.PrintName = ""
ENT.Author = ""
ENT.Contact = ""
ENT.Purpose = ""
ENT.Instructions = ""
ENT.Spawnable = false

if (CLIENT) then
	ENT.LabelColor = Color(255, 255, 255, 255)

	function ENT:BeingLookedAtByLocalPlayer()
		if (LocalPlayer():GetEyeTrace().Entity ~= self) then return false end
		if (EyePos():Distance(self:GetPos()) > 256) then return false end

		return true
	end
end

function ENT:Think()
end

function ENT:SetOverlayText(text)
	self:SetNetworkedString("GModOverlayText", text)
end

function ENT:GetOverlayText()
	local txt = self:GetNetworkedString("GModOverlayText")
	if (txt == "") then return "" end
	if (game.SinglePlayer()) then return txt end
	local PlayerName = self:GetPlayerName()

	return txt .. "\n(" .. PlayerName .. ")"
end

function ENT:SetPlayer(ply)
	if (IsValid(ply)) then
		self:SetVar("Founder", ply)
		self:SetVar("FounderIndex", ply:UniqueID())
		self:SetNetworkedString("FounderName", ply:Nick())
	end
end

function ENT:GetPlayer()
	return self:GetVar("Founder", NULL)
end

function ENT:GetPlayerIndex()
	return self:GetVar("FounderIndex", 0)
end

function ENT:GetPlayerName()
	local ply = self:GetPlayer()
	if (IsValid(ply)) then return ply:Nick() end

	return self:GetNetworkedString("FounderName")
end