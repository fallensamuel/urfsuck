-- "gamemodes\\darkrp\\gamemode\\config\\quests.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local REWARD_MONEY = rp.Quest.AddRewardType{
	give = function(ply, data)
		ply:AddMoney(data)
	end,
	format = function(data)
		return rp.FormatMoney(data)
	end,
}

local REWARD_WEAPON = rp.Quest.AddRewardType{
	give = function(ply, data)
		ply:Give(data)
	end,
	format = function(data)
		local weapon = weapons.Get(data)
		return weapon && weapon.PrintName || data
	end,
}

local REWARD_TIME = rp.Quest.AddRewardType{
	give = function(ply, data)
		ply:AddPlayTime(data)
	end,
	format = function(data)
		return data / 3600 .. " часов игры"
	end,
}

local REWARD_ARMOR = rp.Quest.AddRewardType{
	give = function(ply, data)
		ply:GiveArmor(data)
	end,
	format = function(data)
		return data .. " брони"
	end,
}

local REWARD_HEALTH = rp.Quest.AddRewardType{
	give = function(ply, data)
		ply:SetHealth(ply:Health() + data)
	end,
	format = function(data)
		return data .. " здоровья"
	end,
}

local REWARD_HEAL = rp.Quest.AddRewardType{
	give = function(ply, data)
		ply:SetHealth(ply:GetMaxHealth())
	end,
	format = function(data)
		return "Лечение"
	end,
}

local REWARD_TIME_MULTIPLAYER = rp.Quest.AddRewardType{
	give = function(ply, data, quest)
		ply:AddTimeMultiplayer("quest_"..quest:GetUID(), data[1], data[2])
		timer.Simple(data[2], function()
			if IsValid(ply) then
				ply:RemoveTimeMultiplayer("quest_"..quest:GetUID())
			end
		end)
	end,
	format = function(data)
		return "x"..data[1] + 1 .. " множитель времени на "..math.floor(data[2] / 60).." минут"
	end,
}

local REWARD_SKILL_POINTS = rp.Quest.AddRewardType{
	give = function(ply, data, quest)
		ply:AddAttributeSystemPoints(data)
	end,
	format = function(data)
		return data.. " очков навыков"
	end,
}

local REWARD_SKILL_BOOST = rp.Quest.AddRewardType{
	give = function(ply, data, quest)
		ply:BoostAttribute(data)
	end,
	format = function(data)
		return AttributeSystem.Boosts[data].QuestDesc
	end,
}

NPC_UNKNOWN = rp.Quest.AddNPC({
	name = 'Свободовец Мерк',
	model = 'models/legends/lesnik.mdl',
	desc = [[Эй! Эй ты! Помоги мне! Я хорошо заплачу!]],
	pos = {Vector(2024, -4885, -3840),Angle(0, -100, 0)},
	color = Color(139, 0, 0)
})

QUEST_BROTHERHOOD_START = rp.Quest.Add("Первая Кровь", 'quest_brotherhood_start') 
	:SetDesc([[Эй, незнакомец, не хочешь заработать грязных, но больших денег? 
У меня случилось большое несчастье, мой брат... они убили его! Проклятые легионеры схватили его и избили досмерти в темнице!
Помогите мне в отомщении и я озолочу тебя! Вот, возьми это.  *Незнакомец Вам запечатаный конверт* В конверте лист с именем убийцы моего брата. Найди и убей эту тварь! Я надеюсь на тебя!
*Помимо имени жертвы, на листе еле разборчиво виднелось еще слово "Тишина", значение которого остается загадкой. Может быть это шифр к чему нибудь? Вам стоит об этом подумать*
]])
	:SetObjective([[Убейте человека, виновного в смерти брата незнакомца.]])
	:SetCooldown(0)
	:SetRejectCooldown(1)
	:SetUnlockTime(20*3600)
	:SetDisallowed(rp.GetFactionTeams({FACTION_DOLG, FACTION_DOLGVIP}))
	:SetRewards({[REWARD_MONEY] = 5000})
	:SetNPC(NPC_UNKNOWN)
	:SetColor(Color(139, 0, 0))
	:AddAssasinateTargetByFaction({FACTION_DOLG, FACTION_DOLGVIP})

