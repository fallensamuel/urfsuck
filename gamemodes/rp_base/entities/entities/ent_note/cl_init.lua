include('shared.lua')

function ENT:Draw3D2D()
	self:DrawModel()
end

local tr = translates
local cached
	if tr then
		cached = {
			tr.Get( 'Записка' ), 
			tr.Get( 'Записка не может быть длинее чем 2000 символов!' ), 
			tr.Get( 'Сохранить' ), 
			tr.Get( 'Искренне ваш' ), 
		}
	else
		cached = {
			'Записка', 
			'Записка не может быть длинее чем 2000 символов!', 
			'Сохранить', 
			'Искренне ваш', 
		}
	end

local fr

net.Receive('rp.Note.Text', function(len)
	if (IsValid(fr)) then
		fr:Remove()
	end

	local ent = net.ReadEntity()
	local text = net.ReadString()
	local ownerexists = net.ReadBool()
	local ownername
	local isowner
	if ownerexists then
		ownername = net.ReadString()
		isowner = net.ReadBool()
	end
	fr = ui.Create('ui_frame', function(self)
		self:SetSize(ScrW() * 0.5, ScrH() * 0.7)
		self:SetTitle(cached[1])
		self:Center()
		self:MakePopup()
	end)

	if (isowner) then
		local txt = ui.Create('DTextEntry', function(self)
			self:Dock(FILL)
			self:SetFont('rp.ui.22')
			self:SetText(text)
			self:SetMultiline(true)
		end, fr)

		txt.OnTextChanged = function(self)
			if (#self:GetValue() > 2000) then
				self:SetText(string.sub(self:GetValue(), 1, 2000))
				chat.AddText(cached[2])
			end
		end

		ui.Create('DButton', function(self)
			self:SetTall(30)
			self:DockMargin(0, 5, 0, 0)
			self:Dock(BOTTOM)
			self:SetText(cached[3])

			self.DoClick = function(self)
				fr:Close()
				net.Start('rp.Note.Text')
				net.WriteEntity(ent)
				net.WriteString(txt:GetValue())
				net.SendToServer()
			end
		end, fr)
	else
		local lines
		if ownerexists then
			lines = string.Wrap('rp.ui.22', text .. '\n\n' .. cached[4] .. ',\n' .. ownername, fr:GetWide() - 10)
		else
			lines = string.Wrap('rp.ui.22', text, fr:GetWide() - 10)
		end
		ui.Create('ui_scrollpanel', function(scr)
			scr:Dock(FILL)

			for k, v in ipairs(lines) do
				ui.Create('DLabel', function(self)
					self:SetFont('rp.ui.22')
					self:SetText(v)
					self:SizeToContents()
					scr:AddItem(self)
				end)
			end
		end, fr)
	end
end)