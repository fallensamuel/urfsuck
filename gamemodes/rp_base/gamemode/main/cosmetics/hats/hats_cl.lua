--cvar.Create('enable_hats', true)
rp.hats = rp.hats or {}
rp.hats.stored = rp.hats.stored or {}
rp.hats.skinmap = rp.hats.skinmap or {}
local vecneg = Vector(0, 0, -32000)

local string_find = string.find
local string_sub = string.sub

local skin, tmp, saved

local cvar_Get = cvar.Get
cvar.Register'enable_hats_render':SetDefault(true):AddMetadata('State', 'RPMenu'):AddMetadata('Menu', 'Включить отображение шапок')

function rp.hats.Render(ent, model)
	local cfg = rp.hats.list[model]
	
	if cfg then
		if rp.hats.skinmap[model] then
			skin = rp.hats.skinmap[model].skin
			model = rp.hats.skinmap[model].model
		else
			tmp = string_find(model, ':')
			skin = nil
			
			if tmp then
				saved = model
				
				skin = tonumber(string_sub(model, 1, tmp - 1))
				model = string_sub(model, tmp + 1)
				
				rp.hats.skinmap[saved] = 
				{
					model = model,
					skin = skin
				}
			end
		end

		local cvar = cvar_Get("enable_hats_render")
		if not cvar or not cvar.Value then
			if IsValid(rp.hats.stored[ent]) then
				rp.hats.stored[ent]:SetNoDraw(true)
			end
			return
		else
			if IsValid(rp.hats.stored[ent]) then
				rp.hats.stored[ent]:SetNoDraw(false)
			end
		end
		
		rp.hats.stored[ent] = rp.hats.stored[ent] or ClientsideModel(model, RENDERGROUP_BOTH)
		local hat = rp.hats.stored[ent]

		if !IsValid(hat) then return end
		
		hat:SetSkin(skin or 0)
		
		local pos, ang = Vector(), Angle()
		if cfg.attachment then
			local attach_id = ent:LookupAttachment(cfg.attachment)
			if not attach_id then return end

			local attach = ent:GetAttachment(attach_id)
			
			if not attach then return end

			pos = attach.Pos
			ang = attach.Ang
		else
			local bone_id = ent:LookupBone(cfg.bone)
			if not bone_id then return end
			
			pos, ang = ent:GetBonePosition(bone_id)
		end
		
		local hat, pos, ang = cfg:modifyClientsideModel(ent, hat, pos, ang)

		if (model ~= hat:GetModel()) then
			hat:SetModel(model)
		end
		
		hat:SetModelScale(cfg.scale, 0)
		hat:SetPos(pos)
		hat:SetAngles(ang)
		hat:SetRenderOrigin(pos)
		hat:SetRenderAngles(ang)
		hat:SetupBones()
		hat:DrawModel()
		hat:SetRenderOrigin()
		hat:SetRenderAngles()

	end
end

hook('PostPlayerDraw', 'hats.PostPlayerDraw', function(pl)
	if pl:GetHat() and pl:Alive() then
		if pl:IsDormant() or ((pl ~= LocalPlayer()) and (not pl.IsCurrentlyVisible)) or (pl == LocalPlayer()) and (cvar.GetValue('enable_thirdperson') ~= true) and not pl:IsPlayingTaunt() and not pl:InVehicle() then return end
		rp.hats.Render(pl, pl:GetHat())
	end
end)

hook('Think', 'hats.Think', function()
/*
	if (not IsMounted('tf')) then
		hook.Remove('PostPlayerDraw', 'hats.PostPlayerDraw')
		hook.Remove('Think', 'hats.Think')

		for k, v in pairs(rp.hats.stored) do
			if IsValid(v) then
				v:Remove()
			end
		end
	end
*/
	for k, v in pairs(rp.hats.stored) do
		if (not IsValid(k)) or (k:IsPlayer() and ((not k:Alive()) or (not k:GetHat()) or (v:GetModel() ~= (string_find(k:GetHat(), ':') and string_sub(k:GetHat(), string_find(k:GetHat(), ':') + 1) or k:GetHat())) or ((cvar.GetValue('enable_thirdperson') ~= true) and (k == LocalPlayer())) or ((k ~= LocalPlayer()) and (not k.IsCurrentlyVisible)))) then
			v:Remove()
			rp.hats.stored[k] = nil
		end
	end
end)

-- Menu
hook('PopulateF4Tabs', 'hats.PopulateF4Tabs', function(tabs)
	local cont = ui.Create('ui_panel')
	cont:SetSize(tabs:GetParent():GetWide() - 165, tabs:GetParent():GetTall() - 35)
	tabs:AddTab('Шапки', cont)

	local tab = ui.Create('ui_scrollpanel', function(self, p)
		self:SetPos(0, 0)
		self:SetSize(p:GetWide() * .5 - 2.5, p:GetTall())
		self:SetSpacing(2)
	end, cont)
/*
	if (not IsMounted('tf')) then
		ui.Create('DLabel', function(self, p)
			self:SetText('You need tf2 in order to use hats!')
			self:SetFont('rp.ui.22')
			self:SetPos(10, 10)
			self:SizeToContents()
		end, tab)

		return
	end
*/
	local prev = ui.Create('rp_playerpreview', function(self, p)
		self:SetPos(p:GetWide() * .5 + 2.5, 5)
		self:SetSize(p:GetWide() * .5 - 7.5, p:GetTall() - 40)
	end, cont)

	local skin
	
	for k, v in SortedPairsByMemberValue(rp.hats.list, 'price', false) do
		local pnl = ui.Create('ui_panel', function(self, p)
			self:SetTall(65)
		end)

		tab:AddItem(pnl)

		ui.Create('rp_modelicon', function(self, p)
			self:SetSize(65, 65)
			self:SetPos(0, 0)
			
			tmp = string_find(v.model, ':')
			
			if tmp then
				self:SetModel(string_sub(v.model, tmp + 1), tonumber(string_sub(v.model, 1, tmp - 1)))
			else
				self:SetModel(v.model)
			end
			
			self.DoClick = function() end
		end, pnl)

		ui.Create('DLabel', function(self, p)
			self:SetText(v.name)
			self:SetFont('rp.ui.22')
			self:SetPos(p:GetWide() / 2 - self:GetWide() - 2, 5)
			self:SizeToContents()
		end, pnl)

		ui.Create('DLabel', function(self, p)
			self:SetText(rp.FormatMoney(v.price))
			self:SetFont('rp.ui.22')
			self:SetPos(p:GetWide() / 2 - self:GetWide() - 2, p:GetTall() - self:GetTall() - 5)
			self:SizeToContents()
		end, pnl)

		ui.Create('DButton', function(self, p)
			self:SetText('Примерить')
			self:SetSize(105, 25)
			self:SetPos(p:GetWide() - 110, 5)

			self.DoClick = function()
				prev:SetHat(v.model)
			end
			
			self.Paint = function(btn, w, h)
				derma.SkinHook('Paint', 'TabButton', btn, w, h)
			end
		end, pnl)

		local hashat = table.HasValue(LocalPlayer():GetNetVar('HatData') or {}, v.model)

		if hashat then
			ui.Create('DButton', function(self, p)
				self:SetText('Надеть')
				self:SetSize(105, 25)
				self:SetPos(p:GetWide() - 110, 35)

				self.DoClick = function()
					rp.RunCommand('sethat', v.model)
					prev:SetHat(v.model)
				end
				
				self.Paint = function(btn, w, h)
					derma.SkinHook('Paint', 'TabButton', btn, w, h)
				end
			end, pnl)
		else
			ui.Create('DButton', function(self, p)
				self:SetText('Купить')
				self:SetSize(105, 25)
				self:SetPos(p:GetWide() - 110, 35)
				self.Confirm = hashat

				self.DoClick = function()
					if self.Confirm then
						rp.RunCommand('buyhat', v.model)
						prev:SetHat(v.model)
						self:SetText('Надеть')

						self.DoClick = function()
							rp.RunCommand('sethat', v.model)
							prev:SetHat(v.model)
						end
					else
						self.Confirm = true
						self:SetText('Подтверди')
					end
				end
				
				self.Paint = function(btn, w, h)
					derma.SkinHook('Paint', 'TabButton', btn, w, h)
				end
			end, pnl)
		end
	end

	ui.Create('DButton', function(self, p)
		self:SetText('Снять текущую шапку')
		self:SetPos(p:GetWide() * .5 + 2.5, p:GetTall() - 30)
		self:SetSize(p:GetWide() * .5 - 7.5, 25)

		function self:DoClick()
			rp.RunCommand('removehat')
			prev:SetHat(nil)
		end

		function self:Think()
			if LocalPlayer():GetHat() then
				self:SetDisabled(false)
			else
				self:SetDisabled(true)
			end
		end
		
		self.Paint = function(btn, w, h)
			derma.SkinHook('Paint', 'TabButton', btn, w, h)
		end
	end, cont)
end)
