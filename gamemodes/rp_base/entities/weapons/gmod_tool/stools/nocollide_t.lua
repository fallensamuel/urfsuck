-- "gamemodes\\rp_base\\entities\\weapons\\gmod_tool\\stools\\nocollide_t.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
TOOL.Category = "Construction"
TOOL.Name = "#tool.nocollide_t.name"

if CLIENT then
	local language_Add = language.Add

	language_Add("tool.nocollide_t.desc", translates.Get("Выключает столкновения объекта со всем кроме мира"))
	language_Add("tool.nocollide_t.0", translates.Get("Выключает столкновения объекта со всем кроме мира"))
	language_Add("tool.nocollide_t.name", translates.Get("Отключить столкновения"))

	language_Add("tool.nocollide_t.right", translates.Get("Отключить столкновения"))
	language_Add("tool.nocollide_t.left", translates.Get("Отключить столкновения"))

	language_Add("tool.nocollide_t.reload", translates.Get("Включить столкновения"))
end

TOOL.Information = {
	{name = "left", stage = 0},
	{name = "left_1", stage = 1},
	{name = "right"},
	{name = "reload"}
}

cleanup.Register("nocollide_t")

function TOOL:LeftClick(tr)
	self:RightClick(tr)
	return true
end

function TOOL:RightClick(tr)
	local ent = tr.Entity
	if not IsValid(ent) or ent:IsPlayer() then return end

	if CLIENT then return true end

	--if tr.Entity:GetCollisionGroup() == COLLISION_GROUP_WORLD then
	--	tr.Entity:SetCollisionGroup(COLLISION_GROUP_NONE)
	--else
		tr.Entity:SetCollisionGroup(COLLISION_GROUP_WORLD)
	--end

	return true
end

function TOOL:Reload(tr)
	local ent = tr.Entity
	if not IsValid(ent) or ent:IsPlayer() then return false end
	if CLIENT then return true end

	ent:SetCollisionGroup(COLLISION_GROUP_NONE)
	return true
end

function TOOL:Holster()
	self:ClearObjects()
end

-- This is unreliable
hook.Add("EntityRemoved", "nocollide_fix", function(ent)
	if ent:GetClass() == "logic_collision_pair" then
		ent:Fire("EnableCollisions")
	end
end)

function TOOL.BuildCPanel(CPanel)
	CPanel:AddControl("Header", {Description = "#tool.nocollide_t.desc"})
end
