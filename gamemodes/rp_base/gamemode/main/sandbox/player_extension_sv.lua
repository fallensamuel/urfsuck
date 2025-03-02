function PLAYER:CheckLimit(str)
	local c = rp.GetLimit(str)
	if (c < 0) then return true end

	if (self:GetCount(str) >= c) then
		self:LimitHit(str)

		return false
	end

	return true
end

function PLAYER:GetCount(str, minus)
	if self._Counts and self._Counts[str] then
		local c = self._Counts[str] - (minus or 0) 
		self:SetNWInt("Count."..str, c)
		return c
	end

	return 0
end

function PLAYER:AddCount(str, ent)
	if (SERVER) then
		if not self._Counts then
			self._Counts = {}
			self._CountsMap = {}
		end

		self._CountsMap[ent] = self._CountsMap[ent] or {}
		
		if self._CountsMap[ent][str] then
			return
		end
		
		self._Counts[str] = (self._Counts[str] or 0) + 1
		self._CountsMap[ent][str] = true

		self:SetNWInt("Count."..str, self._Counts[str])
		
		--PrintTable(self._CountsMap)
		
		ent._OnRemoveCount = function()
			if IsValid(self) and self._Counts then
				for k,v in pairs(self._CountsMap[ent]) do
					self._Counts[k] = self._Counts[k] - 1
				end
				
				--PrintTable(self._Counts)
				
				self._CountsMap[ent] = nil
			end
		end
	end
end

function PLAYER:LimitHit(str)
	rp.Notify(self, NOTIFY_ERROR, rp.Term('SboxXLimit'), str)
end

function PLAYER:AddCleanup(type, ent)
	cleanup.Add(self, type, ent)
end

function PLAYER:GetTool(mode)
	local wep = self:GetWeapon('gmod_tool')
	if (not wep or not wep:IsValid()) then return nil end
	local tool = wep:GetToolObject(mode)
	if (not tool) then return nil end

	return tool
end

hook('EntityRemoved', function(ent)
	if ent._OnRemoveCount then
		ent._OnRemoveCount()
	end
end)