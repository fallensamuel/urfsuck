TOOL.Category = "Staff"
TOOL.Name = "Lootables editor"

TOOL.Information = {
	{name = "left", stage = 0},
	{name = "left_1", stage = 1},
	{name = "right"},
	{name = "reload"}
}

rp.AddTerm('UnknownLootType', 'Ошибка! Выбран не существуюший тип-лута!')
rp.AddTerm('CooldownAction', 'Не так быстро! Подождите ещё # сек.')

local PropClasses = {
	["prop_physics_multiplayer"] = true,
    ["prop_physics"] = true
}

local function IsProp(ent)
	return PropClasses[ent:GetClass()] or false
end

if CLIENT then
	language.Add("tool.lootable_editor.desc", translates.Get("Инструмент для создания и редактирования лутабельных объектов"))
	language.Add("tool.lootable_editor.noaccess", translates.Get("У вас нет доступа!"))

	language.Add("tool.lootable_editor.0", translates.Get("Инструмент для создания и редактирования лутабельных объектов"))
	language.Add("tool.lootable_editor.name", translates.Get("Lootables editor"))

	language.Add("tool.lootable_editor.left", translates.Get("Создать ящик / Изменить тип лута"))
	language.Add("tool.lootable_editor.right", translates.Get("Удалить ящик"))
	language.Add("tool.lootable_editor.reload", translates.Get("Узнать тип лута"))

	CreateConVar("looteditor_mode", "low_loot", FCVAR_USERINFO, FCVAR_ARCHIVE)
	CreateConVar("looteditor_maxcount", "1", FCVAR_USERINFO, FCVAR_ARCHIVE)
	CreateConVar("looteditor_hidewhenempty", "0", FCVAR_USERINFO, FCVAR_ARCHIVE)

	local IsValidToolgun = function()
        local actw = LocalPlayer():GetActiveWeapon()
         if not IsValid(actw) or not actw.IsGModTool or GetConVar("gmod_toolmode"):GetString() ~= "lootable_editor" then return false end
         return true, swep
    end

	local col1, col2 = Color(125, 255, 125, 75), Color(255, 125, 125, 75)
	hook.Add("HUDPaint", "lootable_editor_DrawTraceInfo", function()
		local ply = LocalPlayer()
		if not (ply:IsRoot() or ply:HasFlag("e")) then return end

		if not IsValidToolgun() then return end

		local tr = ply:GetEyeTrace()
		local ent = tr.Entity

		if not IsValid(ent) or (not ent:GetNWBool("islootentity") and not IsProp(ent)) then return end

		local pos, ang = ent:GetPos(), ent:GetAngles()
		local min, max = ent:OBBMins(), ent:OBBMaxs()
        if not min or not max then return end

        local col = ent:GetNWBool("islootentity") and col1 or col2
        col.a = 25

		cam.Start3D(EyePos(), EyeAngles())
            render.SetColorMaterial()

            render.SetBlend(0.2)
            render.DrawBox(pos, ang, min, max, col)
            render.DrawWireframeBox(pos, ang, min, max, col)
		cam.End3D()

		col.a = 150

		local txt = ent:GetNWBool("islootentity") and "Это лутейбл" or "Это обычный проп"
		draw.SimpleText(translates.Get(txt), "HudFont", ScrW()*0.5, ScrH() - 16, col, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
	end)
end

function TOOL:DoCooldown(ply, time)
	if ply:IsCooldownAction("LootableEditorTool", time or 3) then
		if SERVER then rp.Notify(ply, NOTIFY_ERROR, rp.Term("CooldownAction"), math.Round(ply:GetCooldownActionTIme("LootableEditorTool"), 1)) end
		return true
	end
end

function TOOL:LeftClick(tr)
	local ply = self:GetOwner()
	if not (ply:IsRoot() or ply:HasFlag("e")) then return false end

	local ent = tr.Entity
	if not IsValid(ent) or (not IsProp(ent) and not ent:GetNWBool("islootentity")) then return false end

	local mode = SERVER and ply:GetInfo("looteditor_mode") or GetConVar("looteditor_maxcount"):GetInt()
	local selected_type = rp.item.loot[mode]
	if not selected_type then
		if SERVER then rp.Notify(ply, NOTIFY_ERROR, rp.Term("UnknownLootType")) end
		return false
	end

	if self:DoCooldown(ply) then return false end
	if CLIENT then return true end

	local mdl, pos, ang, count, type = ent:GetModel(), ent:GetPos(), ent:GetAngles(), math.Clamp(ply:GetInfoNum("looteditor_maxcount", 1), 1, 10), mode
	
	local hide_when_empty = tobool(ply:GetInfo("looteditor_hidewhenempty"))

	rp.AddLootable(mdl, pos, ang, count, type, function(resultcode)
		SpawnLootEntity("box_loot", mdl, pos, ang, count, type, nil, nil, hide_when_empty)
		SafeRemoveEntity(ent)
	end, hide_when_empty)
	
	return true
end

function TOOL:RightClick(tr, effect_request)
	if effect_request then return true end

	local ply = self:GetOwner()
	if not (ply:IsRoot() or ply:HasFlag("e")) then return false end

	local ent = tr.Entity
	if not IsValid(ent) or not ent:GetNWBool("islootentity") then return false end

	if self:DoCooldown(ply) then return false end
	if CLIENT then return true end

	local pos = ent:GetPos()
	rp.RemoveLootable(pos, function()
		local prop = ents.Create("prop_physics")
		prop:SetModel( ent:GetModel() )
		prop:SetPos(pos)
		prop:SetAngles( ent:GetAngles() )
		prop:Spawn()

		prop.AllowRootManipulate = true

		local phys = prop:GetPhysicsObject()
		if IsValid(phys) then
			phys:Sleep()
			phys:EnableMotion(false)
		end

		SafeRemoveEntity(ent)
	end)

	return true
end

function TOOL:Reload(tr)
	local ply = self:GetOwner()
	if not (ply:IsRoot() or ply:HasFlag("e")) then return false end

	local ent = tr.Entity
	if not IsValid(ent) or not ent:GetNWBool("islootentity") then return false end

	if self:DoCooldown(ply, 1) then return false end
	self:RightClick(nil, true)
	if CLIENT then return true end

	rp.Notify(ply, NOTIFY_GREEN, ent.LootType)

	return true
end

if SERVER then
	hook.Add("rp.pp.PlayerCanManipulate", "LootableEditor", function(ply, ent)
		local actw = ply:GetActiveWeapon()
		if (ply:IsRoot() or ply:HasFlag("e")) and (ent.AllowRootManipulate or (IsValid(actw) and actw.IsGModTool == true and actw:GetMode() == "lootable_editor") ) then
			return true
		end
	end)
	return
end

function TOOL.BuildCPanel(CPanel)
	local ply = LocalPlayer()
	if IsValid(ply) and not (ply:IsRoot() or ply:HasFlag("e")) then
		CPanel:AddControl("Header", {Description = "#tool.lootable_editor.noaccess"})
		return
	end

	local List = vgui.Create('DListView');
    List:SetMultiSelect(false);
    List:AddColumn( translates.Get('Типы лута') );
    List:SetSortable(false);
    CPanel:AddItem(List);
    List:SetSize(CPanel:GetWide(), 220);

    local selected = GetConVar("looteditor_mode"):GetString()
    for typ in pairs(rp.item.loot) do
    	local line = List:AddLine(typ)
    	if typ == selected then line:SetSelected(true) end
    	line.OnMousePressed = function(me)
    		for k, v in ipairs(List:GetLines()) do
    			v:SetSelected(false)
    		end
    		me:SetSelected(true)

    		RunConsoleCommand("looteditor_mode", typ)
    	end
    end

    local slider = vgui.Create('DNumSlider');
    slider:SetText( translates.Get('Макс лута в ящике:') );
    slider:SetDecimals(0)
    slider:SetDark(true);
    slider:SetMin(1);
    slider:SetMax(10);
    CPanel:AddItem(slider);
    slider:SetValue(
    	math.Clamp( GetConVar("looteditor_maxcount"):GetInt(), 1, 10)
    );

    function slider:OnValueChanged(val)
        RunConsoleCommand("looteditor_maxcount", val)
    end

    CPanel:AddControl("CheckBox", {Label = translates.Get("Скрывать когда пуст"), Command = "looteditor_hidewhenempty"})

	CPanel:AddControl("Header", {Description = "#tool.lootable_editor.desc"})
end
