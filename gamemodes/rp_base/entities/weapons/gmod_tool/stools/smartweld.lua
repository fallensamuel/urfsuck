TOOL.AllowedClasses = {
	prop_physics 				= true,
	prop_ragdoll 				= true,
	prop_vehicle 				= true,
	prop_vehicle_jeep 			= true,
	prop_vehicle_airboat 		= true,
	prop_vehicle_apc 			= true,
	prop_vehicle_crane 			= true,
	prop_vehicle_prisoner_pod	= true,
	prop_physics_multiplayer 	= true
}

TOOL.SelectedProps = {}

TOOL.Category 						= 'Constraints'
TOOL.Name 							= 'Weld - Smart'
TOOL.ClientConVar['selectradius'] 	= 100
TOOL.ClientConVar['nocollide'] 		= 1
TOOL.ClientConVar['freeze'] 		= 0
TOOL.ClientConVar['clearwelds']		= 1
TOOL.ClientConVar['strength'] 		= 0
TOOL.ClientConVar['world'] 			= 0
TOOL.ClientConVar['color_r'] 		= 0
TOOL.ClientConVar['color_g'] 		= 255
TOOL.ClientConVar['color_b'] 		= 0
TOOL.ClientConVar['color_a'] 		= 255

if CLIENT then
	language.Add('tool.smartweld.name', 'Weld - Smart')
	language.Add('tool.smartweld.desc', translates.Get('Автоматически сваривает выбранные пропы') or 'Автоматически сваривает выбранные пропы')
	language.Add('tool.smartweld.0', translates.Get('ЛКМ: Выбор пропов и его отмена') or 'ЛКМ: Выбор пропов и его отмена')
	language.Add('tool.smartweld.1', translates.Get('ПКМ: сварить выбранные пропы; R: отменить выбор пропов; Зажмите "использовать" и нажмите на ПКМ чтобы приварить все к пропу на который Вы смотрите') or 'ПКМ: сварить выбранные пропы; R: отменить выбор пропов; Зажмите "использовать" и нажмите на ПКМ чтобы приварить все к пропу на который Вы смотрите')
	language.Add('tool.smartweld.selectoutsideradius', translates.Get('Радиус авто-выбора') or 'Радиус авто-выбора')
	language.Add('tool.smartweld.selectoutsideradius.help', translates.Get('Все что не входит в указаный радиус не будет выбрано') or 'Все что не входит в указаный радиус не будет выбрано')
	language.Add('tool.smartweld.strength', translates.Get('Лимит силы') or 'Лимит силы')
	language.Add('tool.smartweld.strength.help', translates.Get('Сила созданных сварок, используйте 0 для неразрушаемой сварки') or 'Сила созданных сварок, используйте 0 для неразрушаемой сварки')
	language.Add('tool.smartweld.world', translates.Get('Приварить все к миру') or 'Приварить все к миру')
	language.Add('tool.smartweld.world.help', translates.Get('Включение этой функции будет приваривать все к карте') or 'Включение этой функции будет приваривать все к карте')
	language.Add('tool.smartweld.nocollide', translates.Get('Отключение соприкосновения') or 'Отключение соприкосновения')
	language.Add('tool.smartweld.nocollide.help', translates.Get('Все пропы не будут соприкасаться с друг-другом после сварки') or 'Все пропы не будут соприкасаться с друг-другом после сварки')
	language.Add('tool.smartweld.freeze', translates.Get('Авто-заморозка') or 'Авто-заморозка')
	language.Add('tool.smartweld.freeze.help', translates.Get('Заморозка всех выбранных пропов после сварки') or 'Заморозка всех выбранных пропов после сварки')
	language.Add('tool.smartweld.clearwelds', translates.Get('Убрать старые сварки') or 'Убрать старые сварки')
	language.Add('tool.smartweld.clearwelds.help', translates.Get('Если выбранный объект имеет активные сварки то они будут удалены') or 'Если выбранный объект имеет активные сварки то они будут удалены')
	language.Add('tool.smartweld.color', translates.Get('Цвет') or 'Цвет')
	language.Add('tool.smartweld.color.help', translates.Get('Модифицируйте цвет выбранных объектов') or 'Модифицируйте цвет выбранных объектов')
	language.Add('Undone_smartweld', translates.Get('Убрана умная сварка.') or 'Убрана умная сварка.')
end

function TOOL.BuildCPanel(panel)
	panel:SetName('Smart Weld')

	panel:AddControl('Header', {
		Text = '',
		Description = translates.Get('Автоматически сваривает выбранные пропы.') or 'Автоматически сваривает выбранные пропы.'
	})

	-- Outside Radius
	panel:AddControl('Slider', {
		Label = '#tool.smartweld.selectoutsideradius',
		Help = '#tool.smartweld.selectoutsideradius',
		Type = 'float',
		Min = '0',
		Max = '500',
		Command = 'smartweld_selectradius'
	})

	-- Force Limit
	panel:AddControl('Slider', {
		Label = '#tool.smartweld.strength',
		Help = '#tool.smartweld.strength',
		Type = 'float',
		Min = '0',
		Max = '10000',
		Command = 'smartweld_strength'
	})

	-- Weld to each other or all to world
	panel:AddControl('Checkbox', {
		Label = '#tool.smartweld.world',
		Help = '#tool.smartweld.world',
		Command = 'smartweld_world'
	})

	-- No-Collide Props While Welding
	panel:AddControl('Checkbox', {
		Label = '#tool.smartweld.nocollide',
		Help = '#tool.smartweld.nocollide',
		Command = 'smartweld_nocollide'
	})

	-- Freeze Props When Welded
	panel:AddControl('Checkbox', {
		Label = '#tool.smartweld.freeze',
		Help = '#tool.smartweld.freeze',
		Command = 'smartweld_freeze'
	})

	-- Clear Previous Welds Before Welding
	panel:AddControl('Checkbox', {
		Label = '#tool.smartweld.clearwelds',
		Help = '#tool.smartweld.clearwelds',
		Command = 'smartweld_clearwelds'
	})

	-- Color
	panel:AddControl('Color', {
		Label = '#tool.smartweld.color',
		Help = '#tool.smartweld.color',
		Red = 'smartweld_color_r',
		Green = 'smartweld_color_g',
		Blue = 'smartweld_color_b',
		Alpha = 'smartweld_color_a'
	})
end
 
function TOOL:Deploy()
end

--Clear selected props when you die or holster the tool
function TOOL:Holster()
	if CLIENT then
		for k, v in ipairs(self.SelectedProps) do
			if IsValid(v.ent) then
				v.ent:SetColor(v.col)
			end
		end
	end
	self.SelectedProps = {}
	self:SetStage(1)
end

-- Does some validity checks then either selects or deselects the prop
function TOOL:LeftClick(tr)
	if IsFirstTimePredicted() and IsValid(tr.Entity) and not tr.Entity:IsPlayer() then
		if SERVER and not util.IsValidPhysicsObject(tr.Entity, tr.PhysicsBone) then
			return false 
		end

		if self:GetOwner():KeyDown(IN_USE) then
			return self:AutoSelect(tr.Entity)
		end

		return self:HandleProp(tr)
	end
	return false
end

-- Auto-selects props
function TOOL:AutoSelect(ent)
	if not IsValid(ent) then return false end
	local preAutoSelect = #self.SelectedProps
	
	if preAutoSelect >= 20 then
		self:Notify('Too many props (20) already selected.', NOTIFY_GENERIC)
	end

	local selectRadius = self:GetClientNumber('selectradius')
	local radiusProps = ents.FindInSphere(ent:GetPos(), selectRadius)
	if #radiusProps < 1 then return false end

	local numNearProps = 0

	for i = 1, #radiusProps do
		if #self.SelectedProps >= 20 then
			break
		end
		
		if self:IsAllowedEnt(ent) and not self:PropHasBeenSelected(radiusProps[i]) then
			self:SelectProp(radiusProps[i])

			numNearProps = numNearProps + 1
		end
	end

	self:Notify((#self.SelectedProps-preAutoSelect)..' prop(s) have been auto-selected.', NOTIFY_GENERIC)
end

-- Decides if we should select it or deselect the specified entity
function TOOL:HandleProp(tr)
	if #self.SelectedProps == 0 then
		self:SelectProp(tr.Entity, tr.PhysicsBone)
	else
		for k, v in ipairs(self.SelectedProps) do
			if v.ent == tr.Entity then
				self:DeselectProp(tr.Entity)

				return true
			end
		end
		self:SelectProp(tr.Entity, tr.PhysicsBone)
	end

	return true
end

-- Deselectes the chosen prop
function TOOL:DeselectProp(ent)
	for k, v in ipairs(self.SelectedProps) do
		if v.ent == ent then
			if CLIENT then
				ent:SetColor(v.col)
			end
			table.remove(self.SelectedProps, k)
		end
	end

	return true
end

-- Adds prop to props table and sets its color
function TOOL:SelectProp(entity, hitBoneNum)
	if self:IsAllowedEnt(entity) then
		if #self.SelectedProps == 0 then
			self:SetStage(1)
		end

		local boneNum = entity:IsRagdoll() and hitBoneNum or 0

		table.insert(self.SelectedProps, {
			ent = entity,
			col = entity:GetColor(),
			bone = boneNum
		})

		if CLIENT then
			entity:SetColor(Color(self:GetClientNumber('color_r', 0), self:GetClientNumber('color_g', 0), self:GetClientNumber('color_b', 0), self:GetClientNumber('color_a', 255)))
		end
		return true
	end
	return false
end

-- Pretty much deselects all
function TOOL:Reload()
	if IsFirstTimePredicted() and self.SelectedProps then
		self:SetStage(1)

		if CLIENT then
			for k, v in ipairs(self.SelectedProps) do
				v.ent:SetColor(v.col)
			end
		end
		
		self.SelectedProps = {}
		self:Notify('Prop Selection Cleared', NOTIFY_CLEANUP)
	end
end

-- Handles the welding
function TOOL:RightClick(tr)
	if (#self.SelectedProps <= 1) then
		self:Notify((#self.SelectedProps == 1 and 'Select at least one more prop to weld.' or 'No props selected!'), NOTIFY_GENERIC)
		return false
	end

	if SERVER then
		local weldForceLimit = math.floor(self:GetClientNumber('strength'))
		local weldToWorld = self:GetClientNumber('world')
		local freezeProps = self:GetClientNumber('freeze')
		local removeOldWelds = self:GetClientNumber('clearwelds')
		local nocollide = tobool(self:GetClientNumber('nocollide'))

		undo.Create('smartweld')

		-- Any code in this loop runs before the actual welding, like removing old welds or freezing the props.
		for k, v in ipairs(self.SelectedProps) do
			-- Refresh welds, it removed pre-existing welds on the selected entities before making the smartweld.
			if (removeOldWelds == 1) then
				constraint.RemoveConstraints(v.ent, 'Weld') 
			end

			-- Will freeze all the props if that option is enabled
			if (freezeProps == 1) then
				if IsValid(v.ent) then
					local physobj = v.ent:GetPhysicsObject()
					if IsValid(physobj) then
						physobj:EnableMotion(false)
						self:GetOwner():AddFrozenPhysicsObject(v.ent, physobj)
					end
				end
			end
		end

		if (weldToWorld == 1) then
			for k, v in ipairs(self.SelectedProps) do
				local weld = constraint.Weld(v.ent, game.GetWorld(), 0, 0, weldForceLimit, nocollide, false)
				undo.AddEntity(weld)
			end
		elseif self:GetOwner():KeyDown(IN_USE) then 	-- Weld all to one
			for k, v in ipairs(self.SelectedProps) do
				local weld = constraint.Weld(v.ent, tr.Entity, v.bone, tr.PhysicsBone, weldForceLimit, nocollide, false)
				undo.AddEntity(weld)
			end
		elseif (#self.SelectedProps < 128) then 	-- They want to do a normal weld but if it's more than 127 props we have to chunk it
			for k, v in ipairs(self.SelectedProps) do	-- Normal Weld
				for otherProps = 1, #self.SelectedProps do
					if (i ~= otherProps) and (i ~= #self.SelectedProps) then
						if not IsValid(v.ent) or not IsValid(self.SelectedProps[otherProps].ent) then continue end
						local weld = constraint.Weld(v.ent, self.SelectedProps[otherProps].ent, v.bone, self.SelectedProps[otherProps].bone, weldForceLimit, nocollide, false)
						undo.AddEntity(weld)
					end
				end
			end
		else 	-- A normal weld that is done in a different way since it is with more than 127 props
			for i = 1, #self.selectedProps do
				local weld = constraint.Weld(v.ent, self.SelectedProps[i+1].ent, v.bone, self.SelectedProps[i+1].bone, weldForceLimit, nocollide, false)
				undo.AddEntity(weld)
			end
		end

		undo.SetPlayer(self:GetOwner())
		undo.Finish()
	end

	self:FinishWelding(tr.Entity)
	return false
end

function TOOL:FinishWelding(entity)
	if CLIENT then
		local numProps = 0

		for k, v in ipairs(self.SelectedProps) do
			if IsValid(v.ent) then
				v.ent:SetColor(v.col)
				numProps = numProps + 1
			end
		end

		if self:GetOwner():KeyDown(IN_USE) then	-- If they chose to weld all to one prop this will correct the count
			for k, v in ipairs(self.SelectedProps) do
				if (v.ent == entity) then
					numProps = numProps + 1
					break
				end
			end
			self:Notify('Weld complete! '..numProps..' props have been welded to a single prop.', NOTIFY_GENERIC)
		elseif tobool(self:GetClientNumber('world')) then
			self:Notify('Weld complete! '..numProps..' props have been welded to the world.', NOTIFY_GENERIC)
		else
			self:Notify('Weld complete! '..numProps..' props have been welded to each other.', NOTIFY_GENERIC)
		end
	end
	self.SelectedProps = {}
	self:SetStage(1)
end

-- Checks if a prop has already been selected
function TOOL:PropHasBeenSelected(ent)
	for k, v in ipairs(self.SelectedProps) do
		if (ent == v.ent) then
			return true
		end
	end

	return false
end

-- Decides if we can we want to weld that ent or not
function TOOL:IsAllowedEnt(ent)
	if IsValid(ent) then
		local pl = SERVER and self:GetOwner() or self.Owner
		local tr = pl:GetEyeTrace()
		tr.Entity = ent

		if (not hook.Run('CanTool', pl, tr, 'smartweld')) or (not self.AllowedClasses[ent:GetClass()]) then
			return false
		end
		
		return true
	end
	
	return false
end

-- Puts one of those annoying notifications to the lower right of the screen
function TOOL:Notify(text, notifyType)
	if CLIENT and IsFirstTimePredicted() and IsValid(self.Owner) then
		notification.AddLegacy(text, notifyType, 5)
		surface.PlaySound('buttons/button15.wav')
	end
end
