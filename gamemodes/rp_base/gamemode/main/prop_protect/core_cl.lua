-- "gamemodes\\rp_base\\gamemode\\main\\prop_protect\\core_cl.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
rp.pp = rp.pp or {}

--
-- Hooks
--
hook('CanTool', 'pp.CanTool', function(pl, trace, tool)
	local ent = trace.Entity

	return (IsValid(ent) and (ent:GetNetVar('PropIsOwned') == true))
end)

hook('PhysgunPickup', 'pp.PhysgunPickup', function(pl, ent) return false end)

function GM:GravGunPunt(pl, ent)
	return pl:IsRoot()
end

--
-- Spawnlist
--
net.Receive( "rp.pp.Whitelist", function()
	local l = net.ReadUInt( 16 );
	local d = net.ReadData( l );

	local props = util.JSONToTable( util.Decompress(d or "") ) or {};

	if #props > 0 then
		rp.pp.Whitelist = {};

		for k, v in ipairs( props ) do
			table.insert( rp.pp.Whitelist, {["Model"] = v} );
		end

		hook.Run( "ppWhitelistLoaded", rp.pp.Whitelist );
		return
	end

	rp.pp.Whitelist = util.JSONToTable( rp.cfg.WhitelistedProps or "" ) or {};
	hook.Run( "ppWhitelistLoaded", rp.pp.Whitelist );
end );

hook.Add( "StartCommand", "pp.GetWhitelist", function()
	hook.Remove( "StartCommand", "pp.GetWhitelist" );

	http.Fetch( rp.cfg.whitelistHandler, function( body )
		rp.pp.Whitelist = util.JSONToTable( body or "" ) or {};

		if #rp.pp.Whitelist == 0 then
			net.Start( "rp.pp.Whitelist" ); net.SendToServer();
			return
		end

		hook.Run( "ppWhitelistLoaded", rp.pp.Whitelist );
	end, function()
		net.Start( "rp.pp.Whitelist" ); net.SendToServer();
	end );
end );

hook.Add( "ppWhitelistLoaded", "AddSpawnlistAllowedTab", function( props )
	local spawnlist = {
		name = translates.Get("Разрешённые пропы"),
		id = math.random(1000, 9999),
		icon = "icon16/cog.png",
		parentid = 0,
		version = 3,
		contents = {}
	};

	hook.Run( "rp.spawnlist.whitelist", spawnlist );

	for k, v in ipairs( props or {} ) do
		table.insert( spawnlist.contents, {
			type = "model",
			model = v.Model
		} );
	end

	if #spawnlist.contents > 0 then
		spawnmenu.AddPropCategory( "allowed", spawnlist.name, spawnlist.contents, spawnlist.icon, spawnlist.id, 0 );
	end
end );

--[[
http.Fetch(rp.cfg.whitelistHandler, function(body)
	local spawnlist = {}
	spawnlist.name = translates.Get('Разрешённые пропы')
	spawnlist.id = math.random(1000, 9999)
	spawnlist.icon = 'icon16/cog.png'
	spawnlist.parentid = 0
	spawnlist.version = 3
	spawnlist.contents = {}

	hook.Run('rp.spawnlist.whitelist', spawnlist)
	
	local props = util.JSONToTable(body)
	
	if not (props and #props > 0) then
		props = util.JSONToTable(rp.cfg.WhitelistedProps or 'nil')
	end
	
	for k, v in ipairs(props or {}) do
		if (mdl ~= '') then
			spawnlist.contents[#spawnlist.contents + 1] = {
				type = 'model',
				model = v.Model
			}
		end
	end

	-- for i=1, 2 do
		-- table.insert(spawnlist.contents, {
			-- type = "model",
			-- model = "models/combinebanner/combinebanner.mdl",
			-- skin = i
		-- })
	-- end

	spawnmenu.AddPropCategory('allowed', spawnlist.name, spawnlist.contents, spawnlist.icon, spawnlist.id, 0)
end)
]]--

--
-- Menus
--
local ranks = {
	[0] = 'user',
	[1] = 'VIP',
	[2] = 'Admin',
	[3] = 'Globaladmin',
	[4] = "Root",
	[5] = "Premium",
}

function rp.pp.ToolEditor()
	local tools = net.ReadTable()

	local fr = ui.Create('ui_frame', function(self)
		self:SetSize(600, 400)
		self:SetTitle('Tool editor')
		self:Center()
		self:MakePopup()
	end)

	local targ

	local list = ui.Create('DListView', function(self, p) -- TODO: FIX
		self:SetPos(5, 30)
		self:SetSize(p:GetWide() - 10, p:GetTall() - 65)
		self:SetMultiSelect(false)
		self:AddColumn('Tool')
		self:AddColumn('Rank')

		self.OnRowSelected = function(parent, line)
			targ = self:GetLine(line):GetColumnText(1)
		end

		for a, b in ipairs(spawnmenu.GetTools()) do
			for c, d in ipairs(spawnmenu.GetTools()[a].Items) do
				for e, f in ipairs(spawnmenu.GetTools()[a].Items[c]) do
					if (type(f) == 'table') and string.find(f.Command, 'gmod_tool') then
						self:AddLine(f.ItemName, tools[f.ItemName] and ranks[tools[f.ItemName]] or 'user')
					end
				end
			end
		end
	end, fr)

	for i = 1, 6 do
		ui.Create('DButton', function(self, p)
			self:SetSize(p:GetWide() / 6 - 6, 25)
			self:SetPos((i - 1) * (p:GetWide() / 6 - 6) + (6 * i), p:GetTall() - 30)
			self:SetText(ranks[i - 1])

			self.DoClick = function()
				rp.RunCommand('settoolgroup', targ, (i - 1))
			end
		end, fr)
	end
end

net('rp.toolEditor', rp.pp.ToolEditor)

function rp.pp.SharePropMenu()
	local fr = ui.Create('ui_frame', function(self)
		self:SetSize(500, 400)
		self:SetTitle('Share Props')
		self:Center()
		self:MakePopup()
	end)

	local targ

	local list = ui.Create('DListView', function(self, p)
		self:SetPos(5, 30)
		self:SetSize(250 - 5, p:GetTall() - 65)
		self:SetMultiSelect(false)
		self:AddColumn('Player')

		self.OnRowSelected = function(parent, line)
			targ = self:GetLine(line):GetColumnText(1)
		end

		for k, v in ipairs(player.GetAll()) do
			if (v == LocalPlayer()) then continue end
			self:AddLine(v:Name())
		end
	end, fr)

	ui.Create('DButton', function(self, p)
		self:SetSize(250 - 5, 25)
		self:SetPos(5, p:GetTall() - 30)
		self:SetText('Share')

		self.DoClick = function()
			rp.RunCommand('shareprops', targ)
		end
	end, fr)

	local targ

	local list = ui.Create('DListView', function(self, p)
		self:SetPos(252.5, 30)
		self:SetSize(250 - 5, p:GetTall() - 65)
		self:SetMultiSelect(false)
		self:AddColumn('Player')

		self.OnRowSelected = function(parent, line)
			targ = self:GetLine(line):GetColumnText(1)
		end

		for k, v in pairs(LocalPlayer():GetNetVar('ShareProps') or {}) do
			self:AddLine(k and (k.Name and k:Name() or '?') or '?')
		end
	end, fr)

	ui.Create('DButton', function(self, p)
		self:SetSize(250 - 5, 25)
		self:SetPos(252.5, p:GetTall() - 30)
		self:SetText('Unshare')

		self.DoClick = function()
			rp.RunCommand('shareprops', targ)
		end
	end, fr)
end

--
-- Context menus
--
properties.Add('ppWhitelist', {
	MenuLabel = 'Add/Remove from whitelist',
	Order = 2001,
	MenuIcon = 'icon16/arrow_refresh.png',
	Filter = function(self, ent, pl)
		if not IsValid(ent) or ent:IsPlayer() then return false end

		return ba.IsSuperAdmin(pl)
	end,
	Action = function(self, ent)
		if not IsValid(ent) then return end
		rp.RunCommand('whitelist', ent:GetModel())
	end
})

properties.Add('ppShareProp', {
	MenuLabel = 'Share props',
	Order = 2002,
	MenuIcon = 'icon16/user.png',
	Filter = function(self, ent, pl)
		if not IsValid(ent) or ent:IsPlayer() then return false end

		return true
	end,
	Action = function(self, ent)
		rp.pp.SharePropMenu()
	end
})