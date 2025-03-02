-- "gamemodes\\rp_base\\gamemode\\main\\chatbox\\default_config.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
-- Стандартный конфиг (используйте кфг в darkrp для перезаписи параметров!)

CHATBOX.ConsoleName = "Console"

CHATBOX.TimestampFormat = "%c" -- https://msdn.microsoft.com/en-us/library/fe06s4ak.aspx

CHATBOX.ImageDownloadFolder = "urfim_chatemotes" -- Папка в которую будут сохраняться эмоуты скачанные по ссылке (garrysmod/%CHATBOX.ImageDownloadFolder%/%urlhash%.png)

CHATBOX.UseUTF8 = true -- Использовать Utf8? Можно офать на европейских серверах.

CHATBOX.MaxMessages = 50 -- Максимум доступных сообщений. После этого старые сообщения начнут удаляться.

CHATBOX.SplitLineByChars = false -- Включить по-буквенный автоперенос? При значении false будет переносить только цельные слова.

CHATBOX.Size = { -- Размер чатбокса
	w = 400,
	h = 200
}

CHATBOX.PosY = 675 -- Размер и позиция абсолютны только для FullHD разрешения! Для остальных разрешений размер и позиция подстраиваеться скриптом.
--CHATBOX.PosX = 0 -- опциональная штука, вряд-ли пригодиться - но пущай будет :)

CHATBOX.FontName = "Montserrat"
CHATBOX.FontNameBold = "Roboto"
CHATBOX.FontScale = 1.25 -- Скалирование шрифтов чатбокса, влияет на размер всех шрифтов чат-бокса.
CHATBOX.DrawMsgShadows = true -- тени для текста (иначе букафки не будут видны на фоне светлых поверхностей)

CHATBOX.TagTeam = "(TEAM) "
CHATBOX.TagTeamConsole = {"(TEAM) "}

CHATBOX.scrollSpeeedMult = 2 -- мультиплайр скорости скроллбаров

CHATBOX.DrawBlur = true -- включить отрисовку размытия?
CHATBOX.HideEmotesMenuWhenSelect = false -- закрывать меню выбора эмоутов после клика на один из эмоутов?

CHATBOX.Anims = { -- Скорость анимаций
	ScroolDown = 0.35,
	FadeInTime = 0.15,
	FadeOutTime = 0.1,
	TextFadeOutTime = 1,
}

CHATBOX.ColorScheme = { -- Цветовая схема чат-бокса, может кастомизироваться для тематических серверов (не меняйте ничего в этом конфиге, делайте подмену оригинального конфига из под darkrp/gamemode/config/configname.lua)
	header = Color(0, 0, 0, 200),
	bg = Color(0, 0, 0, 255*0.5),
	inbg = Color(200, 200, 200, 255*0.06),
	inbghover = Color(200, 200, 200, 255*0.1),

	close_hover = Color(231, 76, 60),
	hover = Color(255, 255, 255, 10),
	hover2 = Color(255, 255, 255, 5),

	text = Color(255, 255, 255),
	text_down = Color(0, 0, 0),

	url = Color(52, 152, 219),
	url_hover = Color(62, 206, 255),
	timestamp = Color(166, 166, 166),

	menu = Color(51, 51, 51, 255*0.5),

	msg = Color(255, 255, 255),
	mode_name = Color(255, 255, 255)
}

--——————————————————————————————————————————— M O D E S ———————————————————————————————————————————--
-- Режимы чата, не предназначены для настройки силами кураторов! Эти настройки только для девелоперов
-- function CHATBOX:AddMode(name, NickKey, col, cmd, pattern, howto, hidden, skipnext, realcmd, msgkey, dontclick, additionalcmds)
CHATBOX.LocalChat = CHATBOX:AddMode(translates.Get("Рядом"), 2, Color(226, 167, 13, 150), nil, translates.Get("<Текст для игроков рядом>"), nil, nil, nil, nil, 5)
CHATBOX:AddMode(translates.Get("Локальный"), 4, Color(16, 107, 33, 150), "/looc", "[LOOC]", translates.Get("<Текст для локального нон-рп чата>"), nil, nil, nil, 7, nil, "[[")
CHATBOX:AddMode(translates.Get("Шёпот"), 4, Color(55, 150, 95, 150), "/w", "[" .. translates.Get("Шёпот") .. "]", translates.Get("<Текст для шёпота>"), nil, nil, nil, 7)
CHATBOX:AddMode(translates.Get("Крик"), 4, Color(226, 25, 13, 150), "/y", "[" .. translates.Get("Крик") .. "]", translates.Get("<Текст для крика>"), nil, nil, nil, 7, nil, "/yell")
CHATBOX:AddMode(translates.Get("Общий"), 4, Color(69, 205, 35, 150), "/ooc", "[" .. translates.Get("Общий") .. "]", translates.Get("<Текст который увидят все игроки>"), nil, nil, nil, 7, nil, "//")
CHATBOX:AddMode(translates.Get("Объявление"), 4, Color(210, 97, 15, 150), "/ad", "[" .. translates.Get("Объявление") .. "]", translates.Get("<Текст объявления>"), nil, nil, nil, 7, nil, "/advert")
--CHATBOX:AddMode(translates.Get("Фракция"), Color(218, 102, 171, 150), "/fr", "[Фракция]", nil, nil, nil, nil, 7)
CHATBOX.GroupChat = CHATBOX:AddMode(translates.Get("Групповой"), 4, Color(45, 200, 60, 150), "/gr", "[Group", translates.Get("<Текст который увидит ваша группа>"), function()
	return rp.groupChats[LocalPlayer():GetJob()] == nil
end, nil, nil, 7, nil, "/group")
CHATBOX:AddMode(translates.Get("Организация"), 4, Color(102, 197, 218, 150), "/org", "[ORG]", nil, function() -- TTTTTTTTTTTTTTTTTTTTTTTTTTTEST
	return LocalPlayer():GetOrg() == nil
end, nil, nil, nil, 7, nil, "/o")
CHATBOX:AddMode(function()
	return LocalPlayer():IsAdmin() and translates.Get("Админ Чат") or translates.Get("Репорт")
end, 3, Color(205, 35, 35, 150), "@", "[" .. translates.Get("Админ Чат") .. "]", function()
	return translates.Get( LocalPlayer():IsAdmin() and "<Текст который увидят все админы>" or "<Текст жалобы>" )
end, nil, nil, nil, 6)
CHATBOX.PMChat = CHATBOX:AddMode(function(m, i, content)
	local l = translates.Get("Личный")

	if m then
		local txt = m == "pm_to " and " > "-- or m == "pm_from " and " < "
		return txt and (l..txt..content[i+1]) or l
	else
		return l
	end
end, 5, Color(168, 18, 238), "/pm", {"pm_from", "pm_to"}, translates.Get("<Ник игрока> <текст>"), nil, true, nil, 8)
CHATBOX:AddMode("URF", nil, Color(249, 48, 40, 150 ), nil, "[URF]", nil, true, nil, nil, nil, true)
CHATBOX:AddMode("Торговец", nil, Color(139, 255, 38, 150), nil, "[Торговец]", nil, true, nil, nil, nil, true)

CHATBOX:AddMode(
	translates.Get("Рейд"),
	4,
	Color(255,100,0,150),
	"/raid",
	"[" .. translates.Get("Рейд") .. "]",
	translates.Get("<Текст для объявления рейда>"),
	nil, nil, nil, 7, nil,
	"/rd"
);

CHATBOX:AddMode(
	translates.Get("Слухи"),
	4,
	Color(255,238,0,150),
	"/rumor",
	"[" .. translates.Get("Слухи") .. "]",
	translates.Get("<Текст для объявления слуха>"),
	nil, nil, nil, 7, nil,
	"/rm"
);

CHATBOX.EmergencyChat = CHATBOX:AddMode(translates.Get("Экстренный"), 4, Color(205, 0, 0, 150), "/em", "[" .. translates.Get("Экстренный") .. "]", nil, true, nil, nil, 7);


--——————————————————————————————————————————— P R E V I E W - E M O T E S ———————————————————————————————————————————--

for i = 1, 10 do
	CHATBOX:AddPreviewEmote("chatbox/emote_preview/"..i..".vtf") -- Икокни которые будут отображаться на кнопке которая открывает меню эмоутов (при наведении эмоут меняеться на следующий) так же поддерживает подгрузку картинок по URL!
end

--——————————————————————————————————————————— E M O T E S ———————————————————————————————————————————--

-- Регистрация эмоутов (<emotename>, <path>, <url> <wide>, <tall>, <access table>)
--CHATBOX:RegisterEmote("awesomeface", nil, "http://i.imgur.com/YBUpyZg.png", 32, 32) -- Можно подгружать эмоуты по ссылке
--CHATBOX:RegisterEmote("grin", "vgui/face/grin", nil, 64, 32) -- Или указав путь до материала
--CHATBOX:RegisterEmote("animated", "models/spawn_effect", nil, 256, 32, { -- Пример эмоута который доступен только определённым юзергруппам или стимайди
--	usergroups 	= {"root", "developer"},
--	steamids 	= {"76561198086005321", "STEAM_0:1:62869796"}
--})

CHATBOX:RegisterEmotesViaAPI("https://urf.im/content/emotes/", 25, 25) -- используйте https://urf.im/content/emotes/view.php для просмотра или скачивания
CHATBOX:RegisterEmotesViaAPI("https://urf.im/content/emotes/elite/", 48, 48, function(ply) -- кастом чек может быть таблицей с usergroups или steamids, либо функцией
	return ply:IsRoot() or ply:HasPremium() -- Элитная коллекция эмоутов только для :Root
end)
--? МБ Сделать вип эмоуты ?--