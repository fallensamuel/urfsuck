-- "gamemodes\\rp_base\\gamemode\\main\\ui\\login_popups_cl.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
rp.LoginPopups = {};

function rp.RegisterLoginPopup(weight, show, customcheck)
    table.insert( rp.LoginPopups, {
        weight  = weight,
        show    = show,
        customcheck = customcheck,
    } );

    table.sort( rp.LoginPopups, function(a, b)
        return a.weight > b.weight
    end );
end

--local function ShowNext()
--    if #rp.LoginPopups < 1 then return end
--
--    if vgui.GetKeyboardFocus() or gui.IsGameUIVisible() then return end
--    local val = table.remove(rp.LoginPopups, select(next(rp.LoginPopups), 1))
--    if not val then return end
--    if val.customcheck and val.customcheck() == false then return ShowNext() end
--
--    val.show()
--    return true
--end

local cv_loginpopups = cvar.Register('enable_loginpopups'):SetDefault(true):AddMetadata('State', 'RPMenu'):AddMetadata('Menu', 'Включить отображение уведомлений о доступных бонусах');

local function CoroutineFunc_LoginPopups()
    local wasAlive = LocalPlayer():Alive();

    while true do
        local popups = rp.LoginPopups or {};
        coroutine.yield();

        if LocalPlayer():Alive() then
            if wasAlive then
                local somethingShown = false;

                for key, val in ipairs( popups ) do
                    wasAlive = LocalPlayer():Alive();
                    if not wasAlive then break end

                    coroutine.yield();

                    if vgui.GetKeyboardFocus() or gui.IsGameUIVisible() then continue end
                    if val.customcheck and val.customcheck() == false then continue end

                    if not somethingShown then
                        somethingShown = true;
                    end

                    if cv_loginpopups:GetValue() then
                        val.show();
                    end
                end

                if somethingShown then
                    wasAlive = false;
                end
            end
        else
            if not wasAlive then
                wasAlive = true;
            end
        end
    end
end

hook.Add( "CreateMove", "rp.LoginPopups", function( cmd )
    if cmd:GetButtons() < 1 then return end
    hook.Remove( "CreateMove", "rp.LoginPopups" );

    local CoroutineThread_LoginPopups;
    hook.Add( "PreDrawHUD", "rp.LoginPopups", function()
        hook.Remove( "PreDrawHUD", "rp.LoginPopups" );

        timer.Create( "LoginPopup.Carousel", 0.25, 0, function()
            if (not CoroutineThread_LoginPopups) or (not coroutine.resume(CoroutineThread_LoginPopups) ) then
                CoroutineThread_LoginPopups = coroutine.create( CoroutineFunc_LoginPopups );
                coroutine.resume( CoroutineThread_LoginPopups );
            end
        end );
    end );
end );

--[[
hook.Add("PreDrawHUD", "LoginPopups", function()
    hook.Remove("PreDrawHUD", "LoginPopups")

	timer.Simple(5, function()
		ShowNext()

		local LocalPlayer = LocalPlayer()

		local alive = true
		hook.Add("PreDrawHUD", "LoginPopups", function()
			local now = LocalPlayer:Alive()

			if alive == false and now then
				if not ShowNext() then
					hook.Remove("PreDrawHUD", "LoginPopups")
				end
			end

			alive = now
		end)
    end)
end)
]--

--[[ Дропает попапы по очерёдно, при первом спавне. (1 окно в фокусе, как только игрок его закроет - откроется второе и так пока не кончатся)
hook.Add("PreDrawHUD", "LoginPopups", function()
    if #rp.LoginPopups < 1 then
        return hook.Remove("PreDrawHUD", "LoginPopups")
    end

    if vgui.GetKeyboardFocus() or gui.IsGameUIVisible() then return end

    local val = table.remove(rp.LoginPopups, select(next(rp.LoginPopups), 1))
    if val.customcheck and val.customcheck() == false then return end
    val.show()
end)
]]--

local articlePattern = "<a href=\"/(@.-)%?.-article__title\">(.-)</span>.-article__description\">(.-)</p>.-article__info\">(.-)</span>.-url%((.-)%)";
local content3

for k, v in pairs(rp.cfg.MoTD or {}) do
    if v[1] == translates.Get('Группа ВК') then
        content3 = v[2]
        break
    end
end

rp.cfg.VKGroup = (content3 ~= rp.cfg.VKGroup and rp.cfg.VKGroup) or content3

local month_to_number = {
    ["янв"] = 1,
    ["фев"] = 2,
    ["мар"] = 3,
    ["апр"] = 4,
    ["май"] = 5,
    ["июн"] = 6,
    ["июл"] = 7,
    ["авг"] = 8,
    ["сен"] = 9,
    ["окт"] = 10,
    ["ноя"] = 11,
    ["дек"] = 12,
}

local CurrentYear = 1970
local year_secs = 31536000
CurrentYear = CurrentYear + math.floor(os.time() / year_secs)

local function ParseTextDate(txt_date) -- example input: 22 ноя в 16:20
    local i = 0
    local data = {}

    txt_date:gsub("%S+", function(w)
        i = i + 1
        data[i] = w
    end)

	if not data[4] or not month_to_number[ string.lower(data[2]) ] then
		return os.time()

	else
		local time = data[4]:Split(":")
		return os.time({day = data[1], month = month_to_number[ string.lower(data[2]) ], year = CurrentYear, hour = time[1], min = time[2], sec = 0}) or 0
	end
end

local function GetServerUpdates(callback)
    http.Fetch(rp.cfg.VKGroup:Replace("vk.com/", "vk.com/@"), function(body)
        local articles = {}

        for href, title, desc, stats, image in string.gmatch(body, articlePattern) do
            local article = {}

            article.hash = util.CRC(href)
            article.href = "https://vk.com/".. href
            article.title = title
            article.desc  = desc

            article.stats = {}
            stats = string.Explode(" · ", stats)
            article.stats.date = stats[1] or translates.Get("1 янв в 12:34")
            article.stats.viewercount = stats[2] or translates.Get("0 просмотров")

            article.image = image
            article.time = ParseTextDate(article.stats.date)

            table.insert(articles, article)
        end

        callback(articles)
    end)
end

local surface_SetDrawColor, surface_DrawRect, draw_SimpleText = surface.SetDrawColor, surface.DrawRect, draw.SimpleText

local function CreateUpdatePanel(article)
    local scrScale = ScrH()/1080

    local menu = vgui.Create("urf.im/rpui/menus/blank")
    menu:SetSize(831*scrScale, 293*scrScale)
    menu:Center()
    menu:MakePopup()

    surface.CreateFont("rpui.Fonts.UpdatePanel.Popup.Title", {
        font = "Montserrat",
        extended = true,
        weight = 600,
        size = 32 * scrScale,
    })

    menu.header:SetTitle(translates.Get("ОБНОВЛЕНИЕ"))
    menu.header:SetFont("rpui.Fonts.UpdatePanel.Popup.Title")
    menu.header:SetIcon(Material("rpui/misc/alarm.png", "smooth", "noclamp"))
    menu.header.IcoSizeMult = 1.75

    local padding = 13*scrScale

    local htall = rpui.AdaptToScreen(0, 44, {0, .7})[2]
    local UpdatePanel = menu:Add("EditablePanel")
    UpdatePanel:SetSize(menu:GetWide() - padding*2, menu:GetTall() - padding*2 - htall)
    UpdatePanel:SetPos(padding, padding + htall)

    if not pcall(surface.SetFont, "rpui.Fonts.UpdatePanel.Title") then
        local frameH = UpdatePanel:GetTall()

        surface.CreateFont("rpui.Fonts.UpdatePanel.Title", {
            font = "Montserrat",
            extended = true,
            weight = 600,
            size = frameH * 0.125,
        })

        surface.CreateFont("rpui.Fonts.UpdatePanel.Description", {
            font = "Montserrat",
            extended = true,
            weight = 400,
            size = frameH * 0.09,
        })

        surface.CreateFont("rpui.Fonts.UpdatePanel.Stats", {
            font = "Montserrat",
            extended = true,
            weight = 500,
            size = frameH * 0.065,
        })
    end

    UpdatePanel.HTML = vgui.Create("DHTML", UpdatePanel)
    UpdatePanel.HTML.Dock(UpdatePanel.HTML, LEFT)
    UpdatePanel.HTML.DockMargin(UpdatePanel.HTML, 0, 0, padding * 0.25, 0)
    UpdatePanel.HTML.SetWide(UpdatePanel.HTML, UpdatePanel:GetWide() * 0.45)
    UpdatePanel.HTML.SetMouseInputEnabled(UpdatePanel.HTML, false)
    UpdatePanel.HTML.SetHTML(UpdatePanel.HTML, '<html><head><style>body { margin: 0; } body::after { content: ""; position: absolute; left: 0; top: 0; right: 0; bottom: 0; background-size: 100% 100%; background-image: url(' .. article.image .. ');box-shadow: inset 0px 0px 16px 0px rgba(0,0,0,0.75);}</style></head></html>')
    UpdatePanel.HTML.InvalidateParent(UpdatePanel.HTML, true)

    UpdatePanel.Stats = vgui.Create("DLabel", UpdatePanel)
    UpdatePanel.Stats.SetFont(UpdatePanel.Stats, "rpui.Fonts.UpdatePanel.Stats")
    UpdatePanel.Stats.SetTextColor(UpdatePanel.Stats, Color(255, 255, 255, 200))
    UpdatePanel.Stats.SetText(UpdatePanel.Stats, article.stats.date .. " · " .. article.stats.viewercount)
    UpdatePanel.Stats.SetPos(UpdatePanel.Stats, UpdatePanel.HTML.x, UpdatePanel.HTML.y)
    UpdatePanel.Stats.SetWide(UpdatePanel.Stats, UpdatePanel.HTML.GetWide(UpdatePanel.HTML))
    UpdatePanel.Stats.SetContentAlignment(UpdatePanel.Stats, 5)
    UpdatePanel.Stats.SizeToContentsY(UpdatePanel.Stats, padding * 0.1)
    UpdatePanel.Stats.Paint = function(_______, w23, h23)
        surface_SetDrawColor(Color(0, 0, 0, 200))
        surface_DrawRect(0, 0, w23, h23)
    end

    UpdatePanel.Title = vgui.Create("DLabel", UpdatePanel)
    UpdatePanel.Title.SetWrap(UpdatePanel.Title, true)
    UpdatePanel.Title.SetAutoStretchVertical(UpdatePanel.Title, true)
    UpdatePanel.Title.SetFont(UpdatePanel.Title, "rpui.Fonts.UpdatePanel.Title")
    UpdatePanel.Title.SetTextColor(UpdatePanel.Title, rpui.UIColors.White)
    UpdatePanel.Title.SetText(UpdatePanel.Title, article.title)
    UpdatePanel.Title.Dock(UpdatePanel.Title, TOP)
    UpdatePanel.Title.DockMargin(UpdatePanel.Title, padding * 0.5, 0, 0, padding * 0.25)

    UpdatePanel.Read = vgui.Create("DButton", UpdatePanel)
    UpdatePanel.Read.SetFont(UpdatePanel.Read, "rpui.Fonts.UpdatePanel.Title")
    UpdatePanel.Read.SetText(UpdatePanel.Read, translates.Get("ЧИТАТЬ"))
    UpdatePanel.Read.SizeToContentsY(UpdatePanel.Read, padding * 0.5)
    UpdatePanel.Read:SetWide(UpdatePanel:GetWide() * 0.55 - padding*0.5)
    UpdatePanel.Read:SetPos(UpdatePanel:GetWide() - UpdatePanel.Read:GetWide() + padding*0.5, UpdatePanel:GetTall() - UpdatePanel.Read:GetTall())

    UpdatePanel.Read.Paint = function(this31, w24, h24)
        local baseColor, textColor = rpui.GetPaintStyle(this31, STYLE_TRANSPARENT_INVERTED)
        surface_SetDrawColor(baseColor)
        surface_DrawRect(0, 0, w24, h24)
        draw_SimpleText(this31:GetText(), this31:GetFont(), w24 * 0.5, h24 * 0.5, textColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

        return true
    end

    UpdatePanel.Read.DoClick = function()
        gui.OpenURL(article.href)
    end

    UpdatePanel.Desc = vgui.Create("DLabel", UpdatePanel)
    UpdatePanel.Desc.Dock(UpdatePanel.Desc, FILL)
    UpdatePanel.Desc.SetWrap(UpdatePanel.Desc, true)
    UpdatePanel.Desc.SetFont(UpdatePanel.Desc, "rpui.Fonts.UpdatePanel.Description")
    UpdatePanel.Desc.SetTextColor(UpdatePanel.Desc, Color(255, 255, 255, 200))
    UpdatePanel.Desc.SetText(UpdatePanel.Desc, article.desc)
    UpdatePanel.Desc.SetContentAlignment(UpdatePanel.Desc, 7)
    UpdatePanel.Desc.DockMargin(UpdatePanel.Desc, padding * 0.5, 0, 0, 0)

    return UpdatePanel
end

local maxTime = os.time() + 60*60*24*7

GetServerUpdates(function(articles)
    local k, article = next(articles)
    if not article or article.time > maxTime then return end

    rp.RegisterLoginPopup(100, function()
        cookie.Set(article.hash, 1)

        CreateUpdatePanel(article)
    end, function()
        return not cookie.GetNumber(article.hash)
    end)
end)
