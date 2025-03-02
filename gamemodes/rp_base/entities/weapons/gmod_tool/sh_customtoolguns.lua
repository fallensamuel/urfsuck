local GetSWEPClass = function(self)
  local str = self.Folder
  return str:match("^.*/(.*)") or str
end

function rp.MakeCustomToolGun(self, name, world, view, price, donateprice, renderVec, renderAng)
	self.Base = "gmod_tool"
	self.IsGModTool = true
	self.Spawnable = true
	self.PrintName = name

	self.Author = "urf.im"
	self.Contact = ""
	self.Purpose = ""
	self.Instructions = ""

	self.WorldModel = world
	util.PrecacheModel(self.WorldModel)

	self.ViewModel = view
	util.PrecacheModel(self.ViewModel)

	rp.AddCustomToolGun(GetSWEPClass(self), name, world, price, donateprice)
end

rp.ToolGunSWEPS = rp.ToolGunSWEPS or {
	[999] = "gmod_tool"
}

rp.ToolGunSWEPS_k = rp.ToolGunSWEPS_k or {
	["gmod_tool"] = true
}

function rp.AddCustomToolGun(class, name, mdl, price, donate_price, renderVec, renderAng)

	for k, v in pairs(rp.ToolGunSWEPS) do
		if istable(v) and v["class"] == class then
			rp.ToolGunSWEPS[k] = nil
			break
		end
	end

	local index = table.insert(rp.ToolGunSWEPS, {
		["class"] 			= class,
		["price"] 			= price,
		["donatePrice"] 	= donate_price,
		["model"] 			= mdl,
		["name"] 			= name
	})
	rp.ToolGunSWEPS[index].index = index
	rp.ToolGunSWEPS_k[class] = index
end

function GetGmodTool(ply)
	for k, tab in pairs(rp.ToolGunSWEPS) do
		local class = istable(tab) and tab.class or tab
		local swep = ply:GetWeapon(class)
		if IsValid(swep) then return swep, class end
	end
end