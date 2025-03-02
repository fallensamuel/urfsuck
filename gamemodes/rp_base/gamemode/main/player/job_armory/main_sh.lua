-- "gamemodes\\rp_base\\gamemode\\main\\player\\job_armory\\main_sh.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
function rp.AddJobArmory(jindex, equip_name, price, weapons)
	local job = rp.teams[jindex]
	if not job then return end

	job.Armory = job.Armory or {}
	job.ArmoryLinks = job.ArmoryLinks or {}

	local armory = {};

	local data = {
		free = price == 0,
		price = price,
		weapons = weapons,
		name = equip_name,
	};

	if CLIENT then
		setmetatable( armory, {
			__index = function( this, key )
				local val = data[key];
				return hook.Run("OnJobArmoryValueNotify", key, val) or val;
			end
		} );
	else
		armory = data;
	end

	job.ArmoryLinks[equip_name] = table.insert(job.Armory, armory);
end

function rp.CalculateArmoryPrice( ply, price )
	price = hook.Run( "CalculateArmoryPrice", ply, price ) or price;
	return price;
end