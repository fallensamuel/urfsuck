local color_pink = rp.chatcolors.Pink
local color_red = rp.chatcolors.Red
local color_white = rp.chatcolors.White

local cards = {
	"Туз Пик",
	"Двойка Пик",
	"Тройка Пик",
	"Четвёрка Пик",
	"Пятёрка Пик",
	"Шерстёрка Пик",
	"Семёрка Пик",
	"Восьмёрка Пик",
	"Девятка Пик",
	"Десятка Пик",
	"Валет Пик",
	"Дама Пик",
	"Король Пик",
	"Туз Бубей",
	"Двойка Бубей",
	"Тройка Бубей",
	"Четвёрка Бубей",
	"Пятёрка Бубей",
	"Шерстёрка Бубей",
	"Семёрка Бубей",
	"Восьмёрка Бубей",
	"Девятка Бубей",
	"Десятка Бубей",
	"Валет Бубей",
	"Дама Бубей",
	"Король Бубей",
	"Туз Черви",
	"Двойка Черви",
	"Тройка Черви",
	"Четвёрка Черви",
	"Пятёрка Черви",
	"Шерстёрка Черви",
	"Семёрка Черви",
	"Восьмёрка Черви",
	"Девятка Черви",
	"Десятка Черви",
	"Валет Черви",
	"Дама Черви",
	"Король Черви",
	"Туз Крести",
	"Двойка Крести",
	"Тройка Крести",
	"Четвёрка Крести",
	"Пятёрка Крести",
	"Шерстёрка Крести",
	"Семёрка Крести",
	"Восьмёрка Крести",
	"Девятка Крести",
	"Десятка Крести",
	"Валет Крести",
	"Дама Крести",
	"Король Крести"
}

local tr = translates
local cached
for k, v in pairs(cards) do
	if tr and tr.Get( v ) then
		v = tr.Get( v )
	end
end

local function RollTheDice(pl, text, args)
	local val = 0
	if pl:GetJobTable().CasinoHack then
		val = math.random(80, 100)
	else
		val = math.random(100)
	end
	rp.LocalChat(CHAT_NONE, pl, 250, color_red, '[', color_pink, tr and tr.Get('Числа') or 'Числа', color_red, '] ', pl:GetJobColor(), pl:Name(), color_white, ' ' .. (tr and tr.Get('выпало') or 'выпало') .. ' ', color_pink, tostring(val), color_white, ' ' .. (tr and tr.Get('из 100') or 'из 100'))
end
rp.AddCommand("/roll", RollTheDice)

local function DoubleDice(pl, text, args)
	rp.LocalChat(CHAT_NONE, pl, 250, color_red, '[', color_pink, tr and tr.Get('Кубик') or 'Кубик', color_red, '] ', pl:GetJobColor(), pl:Name(), color_white, ' ' .. (tr and tr.Get('выпало') or 'выпало') .. ' ', color_pink, tostring(math.random(1, 6)), color_white, ', ', color_pink, tostring(math.random(1, 6)), color_white, '.')
end
rp.AddCommand("/dice", DoubleDice)

local function RandomCard(pl, text, args)
	rp.LocalChat(CHAT_NONE, pl, 250, color_red, '[', color_pink, tr and tr.Get('Карта') or 'Карта', color_red, '] ', pl:GetJobColor(), pl:Name(), color_white, ' ' .. (tr and tr.Get('вытянул') or 'вытянул') .. ' ', color_pink, table.Random(cards), color_white, '.')
end
rp.AddCommand("/cards", RandomCard)