-- "gamemodes\\rp_base\\gamemode\\main\\player\\job_armory\\main_cl.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
net.Receive("urf.im/job_armory_info", function()
	local j_index = net.ReadUInt(10)

	local jtab = rp.teams[j_index]
	if not jtab then return end

	local one_ar = net.ReadBool()

	if one_ar then
		one_ar = net.ReadUInt(4)
		--print("Получена инфа о Снаряжении #".. one_ar)
		jtab.Armory[one_ar].IsBuyed = true
		return
	end

	--print("Получена инфа о всех Арсеналах!!!")

	for i = 1, #jtab.Armory do
		jtab.Armory[i].IsBuyed = net.ReadBool()
	end

	jtab.ArmoryReceived = true
	hook.Run("urf.im/job_armory_info", j_index, jtab.Armory)
end)

net.Receive("urf.im/job_armory", function()
	local j_index = net.ReadUInt(10)

	local jtab = rp.teams[j_index]
	if not jtab then return end

	local act = net.ReadUInt(4)

	for k, v in pairs(jtab.Armory) do
		jtab.Armory[k].IsActive = k == act
	end

	--print(jtab.Armory[act].name .." купленно!")
end)

net.Receive("urf.im/jobarmory/load", function()
	--print("> Job Armory Loading!")
	for i = 1, net.ReadUInt(32) do
		local jindex = net.ReadUInt(32)
		local jtab = rp.teams[jindex]

		--print(i ..". ".. jtab.name ..":")

		for i = 1, net.ReadUInt(8) do
			local index = net.ReadUInt(8)
			jtab.Armory[index].IsBuyed = true
			--print(i ..". ".. jtab.Armory[index].name)
		end
	end
end)

local keys = { ["price"] = true };

hook.Add( "OnJobArmoryValueNotify", "test", function( key, value )
	if keys[key] then
		return rp.CalculateArmoryPrice( LocalPlayer(), value );
	end
end );