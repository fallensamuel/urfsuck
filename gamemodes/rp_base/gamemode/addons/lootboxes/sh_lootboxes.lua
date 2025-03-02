-- "gamemodes\\rp_base\\gamemode\\addons\\lootboxes\\sh_lootboxes.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal

nw.Register('donate_case_present')
	:Write(net.WriteString)
	:Read(net.ReadString)
	:SetGlobal()

rp.lootbox = rp.lootbox or {
	Map = {},
	All = {},
}

--[[ LIB ]]--
function rp.lootbox.Add(id, data)
	if data.items then
		table.SortByMember( data.items, "chance" );
	end

	data.ID = id
	data.NID = table.insert(rp.lootbox.All, data)

	rp.lootbox.Map[id] = data
end

function rp.lootbox.Get(id)
	return rp.lootbox.Map[id] or false
end


--[[ PLAYER META ]]--
function PLAYER:GetLootboxes()
	return IsValid(self) and self:GetNetVar('Lootboxes') or {}
end

function PLAYER:GetTodayPlaytime()
	return os.time() - (self:GetNetVar('TodayTimePlayed') or os.time())
end


--[[ TERMS ]]--
ba.AddTerm("Lootbox::Rewarded", "# получил # из #!")
ba.AddTerm("Lootbox::PresentSet", "Подарочный кейс установлен!")
ba.AddTerm("Lootbox::PresentUnset", "Подарочный кейс сброшен!")
ba.AddTerm("Lootbox::PresentGot", "Вы получили подарочный кейс! Он помещён в F4 -> Донат -> Кейсы.")
ba.AddTerm("Lootbox::PresentInvalidAmount", "Минимальная сумма доната не может быть меньше 1 кредита!")
ba.AddTerm("Lootbox::PresentInvalidId", "Такого кейса не существует!")
ba.AddTerm("Lootboxes.GiveCase::InvalidCase", "Такого кейса не существует!");
ba.AddTerm("Lootboxes.GiveCase::InvalidAmount", "Количество выдаваемых кейсов должно быть больше 0!");
ba.AddTerm("Lootboxes.GiveCase", "# выдал кейс # игроку # #");

--[[ NET VARS ]]--
nw.Register('Lootboxes')
	:Write(function(data)
		net.WriteUInt(table.Count(data), 16)

		for k, lootbox in pairs(data) do
			net.WriteUInt(k, 32)
			net.WriteString(lootbox.id)
			net.WriteString(lootbox.data)
			net.WriteBool(lootbox.spawned or false)
		end
	end)
	:Read(function()
		local data = {}

		for i = 1, net.ReadUInt(16) do
			data[net.ReadUInt(32)] = {
				id = net.ReadString(),
				data = net.ReadString(),
				spawned = net.ReadBool(),
			}
		end

		return data
	end)
	:SetLocalPlayer()

nw.Register('TodayTimePlayed')
	:Write(net.WriteUInt, 32)
	:Read(net.ReadUInt, 32)
	:SetLocalPlayer()

nw.Register('LootboxCooldowns')
	:Write(function(data)
		net.WriteUInt(table.Count(data), 16)

		for lb_id, timestamp in pairs(data) do
			net.WriteUInt(lb_id, 32)
			net.WriteUInt(timestamp, 32)
		end
	end)
	:Read(function()
		local data = {}

		for i = 1, net.ReadUInt(16) do
			data[net.ReadUInt(32)] = net.ReadUInt(32)
		end

		return data
	end)
	:SetLocalPlayer()


--[[ COMMANDS ]]--
ba.cmd.Create('Present Donate Case', function(pl, args)
	local present_id = args.case_id
	local time_until = tonumber(args.time) or 0
	local amount_until = tonumber(args.min_donation) or 0

	if amount_until <= 0 and IsValid(pl) then
		ba.notify_err(pl, ba.Term('Lootbox::PresentInvalidAmount'))
		return
	end

	if not rp.lootbox.Map[present_id] and IsValid(pl) then
		ba.notify_err(pl, ba.Term('Lootbox::PresentInvalidId'))
		return
	end

	rp.lootbox.SetDonatePresent(os.time() + time_until, amount_until, present_id, pl)
end)
:AddParam('string', 'case_id')
:AddParam('time', 'time')
:AddParam('string', 'min_donation')
:SetFlag('*')
:SetHelp('Sets present case for donation')

ba.cmd.Create('Unset Donate Case', function(pl, args)
	rp.lootbox.UnsetDonatePresent(time_until, amount_until, present_id, pl)
end)
:AddParam('string', 'case_id')
:AddParam('time', 'time')
:AddParam('string', 'min_donation')
:SetFlag('*')
:SetHelp('Unsets present case for donation')

ba.cmd.Create( "Case List", function( ply, args )
	local valid, tab = IsValid( ply ), {};

	for case_id, case in pairs( rp.lootbox.Map ) do
		local out = string.format( "%s - %s", case_id, case.name );
		if valid then ply:PrintMessage( HUD_PRINTCONSOLE, out ); else print( out ); end
	end
end )
:SetFlag('*')
:SetHelp('Unsets present case for donation')

ba.cmd.Create( "Give Case", function( ply, args )
	if ply:IsPlayer() then return end

	local steamid = ba.InfoTo64( args.target );

	local case = rp.lootbox.Get( args.case_id );
	if not case then
		ba.notify_err( ply, ba.Term("Lootboxes.GiveCase::InvalidCase") );
		return
	end

	local amount = tonumber( args.amount or 0 );
	if amount < 1 then
		ba.notify_err( ply, ba.Term("Lootboxes.GiveCase::InvalidAmount") );
		return
	end

	local uid = os.time();
	local target = player.GetBySteamID64( steamid );
	local target_valid = IsValid( target );
	local lootboxes = target_valid and (target:GetLootboxes() or {}) or {};

	for i = 1, amount do
		if target_valid then
			while lootboxes[uid] do
				uid = uid + 1;
			end

			lootboxes[uid] = { id = case.ID, data = "[]", spawned = false };
		else
			uid = uid + 1;
		end

		rp._Stats:Query( "INSERT INTO `lootboxes` (`id`, `steamid`, `box_id`) VALUES (?, ?, ?);", uid, steamid, case.ID );
	end

	if target_valid then
		target:SetNetVar( "Lootboxes", lootboxes );
	end

	ba.logAction( ply, steamid, "givecase", string.format("%s;%i", case.ID, amount) );
	ba.notify_staff( ba.Term("Lootboxes.GiveCase"), ply, (amount > 1) and (case.name .. " (x" .. amount .. ")") or case.name, args.target );
end )
:AddParam( "player_steamid", "target" )
:AddParam( "string", "case_id" )
:AddParam( "string", "amount", "optional" )
:SetFlag( "*" )
:SetHelp( "Gives donate cases to a specified player" )