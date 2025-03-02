-- "gamemodes\\rp_base\\gamemode\\main\\menus\\dev\\awesomefont_viewer_cl.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local surface_CreateFont = surface.CreateFont
local TEXT_ALIGN_CENTER, TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM = TEXT_ALIGN_CENTER, TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM
local SimpleText = draw.SimpleText
local RoundedBox, IsValid, pairs = draw.RoundedBox, IsValid, pairs
local math_Clamp = math.Clamp
local math_Round = math.Round

local AwesomeFonts = {
	Regular = "Font Awesome 5 Free Regular",
	Solid	= "Font Awesome 5 Free Solid",
	Brands = "Font Awesome 5 Brands Regular"
}

local builded_fonts = {}
local BuildFont = function(type, size, weight)
	if not type or not AwesomeFonts[type] then return end
	local fontname = "FontAwesome."..type.."."..size

	local fontData = {
		font = AwesomeFonts[type],
	    extended = true,
	    antialias = true,
	    size = size,
	    type = type
	}
	--if weight then Бесполезный парметр для AwesomeFont's
	--	fontData["weight"] = weight
	--end

    if builded_fonts[fontname] then
        return fontname, fontData
    end

	surface_CreateFont(fontname, fontData)
    builded_fonts[fontname] = true
	return fontname, fontData
end

local titleIconFont = BuildFont("Regular", 18)
local defaultPreviewFont, dafaultFontData = BuildFont("Regular", 64)
local columnFont = BuildFont("Regular", 16)

local FontTables = {}
	--Regular = util.JSONToTable(file.Read("awesomefont/regularfree_min.json", "DATA")),
	--Solid = util.JSONToTable(file.Read("awesomefont/solidfree_min.json", "DATA")),
	--Brands = util.JSONToTable(file.Read("awesomefont/brands_min.json", "DATA"))
--}
FontTables.Regular 	= {['file-archive']='',['laugh-wink']='',['dot-circle']='',['address-book']='',['thumbs-up']='',['square']='',['registered']='',['list-alt']='',['comment']='',['angry']='',['laugh-squint']='',['copy']='',['check-circle']='',['images']='',['grin-tongue-wink']='',['sun']='',['hand-spock']='',['hand-peace']='',['hand-scissors']='',['meh']='',['comments']='',['star']='',['hourglass']='',['grimace']='',['circle']='',['arrow-alt-circle-up']='',['calendar']='',['grin-tears']='',['sad-tear']='',['grin-wink']='',['arrow-alt-circle-left']='',['grin']='',['kiss-beam']='',['play-circle']='',['file-alt']='',['folder']='',['smile-beam']='',['envelope-open']='',['bell-slash']='',['times-circle']='',['snowflake']='',['pause-circle']='',['minus-square']='',['hand-lizard']='',['image']='',['frown-open']='',['comment-alt']='',['trash-alt']='',['hand-point-down']='',['id-card']='',['arrow-alt-circle-down']='',['calendar-minus']='',['arrow-alt-circle-right']='',['check-square']='',['star-half']='',['plus-square']='',['object-ungroup']='',['clock']='',['hand-paper']='',['credit-card']='',['calendar-check']='',['grin-squint-tears']='',['meh-blank']='',['kiss']='',['grin-alt']='',['calendar-alt']='',['newspaper']='',['file-word']='',['file']='',['grin-beam']='',['paper-plane']='',['eye-slash']='',['window-close']='',['caret-square-left']='',['eye']='',['id-badge']='',['caret-square-up']='',['window-maximize']='',['thumbs-down']='',['user-circle']='',['hand-point-right']='',['stop-circle']='',['moon']='',['closed-captioning']='',['chart-bar']='',['clipboard']='',['flag']='',['window-minimize']='',['grin-tongue-squint']='',['frown']='',['file-pdf']='',['smile-wink']='',['question-circle']='',['object-group']='',['money-bill-alt']='',['sticky-note']='',['map']='',['smile']='',['futbol']='',['life-ring']='',['lemon']='',['clone']='',['flushed']='',['save']='',['address-card']='',['keyboard']='',['hdd']='',['grin-squint']='',['heart']='',['tired']='',['meh-rolling-eyes']='',['calendar-plus']='',['laugh-beam']='',['building']='',['calendar-times']='',['grin-stars']='',['hand-rock']='',['handshake']='',['caret-square-right']='',['kiss-wink-heart']='',['copyright']='',['envelope']='',['edit']='',['file-code']='',['grin-tongue']='',['hospital']='',['caret-square-down']='',['folder-open']='',['grin-beam-sweat']='',['grin-hearts']='',['bell']='',['bookmark']='',['dizzy']='',['file-audio']='',['file-image']='',['file-excel']='',['gem']='',['hand-pointer']='',['user']='',['hand-point-up']='',['compass']='',['sad-cry']='',['lightbulb']='',['surprise']='',['share-square']='',['file-video']='',['comment-dots']='',['file-powerpoint']='',['window-restore']='',['hand-point-left']='',['laugh']=''}
FontTables.Solid 	= {['file-archive']='',['laugh-wink']='',['dot-circle']='',['address-book']='',['thumbs-up']='',['square']='',['registered']='',['list-alt']='',['comment']='',['angry']='',['laugh-squint']='',['copy']='',['check-circle']='',['images']='',['grin-tongue-wink']='',['sun']='',['hand-spock']='',['hand-peace']='',['hand-scissors']='',['meh']='',['comments']='',['star']='',['hourglass']='',['grimace']='',['circle']='',['arrow-alt-circle-up']='',['calendar']='',['grin-tears']='',['sad-tear']='',['grin-wink']='',['arrow-alt-circle-left']='',['grin']='',['kiss-beam']='',['play-circle']='',['file-alt']='',['folder']='',['smile-beam']='',['envelope-open']='',['bell-slash']='',['times-circle']='',['envelope']='',['pause-circle']='',['minus-square']='',['hand-lizard']='',['image']='',['frown-open']='',['comment-alt']='',['trash-alt']='',['hand-point-down']='',['id-card']='',['arrow-alt-circle-down']='',['calendar-minus']='',['arrow-alt-circle-right']='',['check-square']='',['star-half']='',['plus-square']='',['object-ungroup']='',['clock']='',['hand-paper']='',['credit-card']='',['calendar-check']='',['grin-squint-tears']='',['meh-blank']='',['kiss']='',['grin-alt']='',['calendar-alt']='',['newspaper']='',['file-word']='',['file']='',['grin-beam']='',['paper-plane']='',['eye-slash']='',['window-close']='',['handshake']='',['eye']='',['id-badge']='',['caret-square-up']='',['window-maximize']='',['thumbs-down']='',['user-circle']='',['hand-point-right']='',['grin-stars']='',['moon']='',['building']='',['chart-bar']='',['clipboard']='',['grin-tongue-squint']='',['window-minimize']='',['hand-point-left']='',['frown']='',['window-restore']='',['smile-wink']='',['question-circle']='',['object-group']='',['file-powerpoint']='',['sticky-note']='',['comment-dots']='',['smile']='',['heart']='',['share-square']='',['surprise']='',['lightbulb']='',['grin-tongue']='',['sad-cry']='',['address-card']='',['compass']='',['hand-point-up']='',['grin-squint']='',['user']='',['tired']='',['meh-rolling-eyes']='',['calendar-plus']='',['futbol']='',['snowflake']='',['calendar-times']='',['kiss-wink-heart']='',['hand-rock']='',['flag']='',['file-audio']='',['hospital']='',['dizzy']='',['bookmark']='',['bell']='',['file-code']='',['grin-hearts']='',['grin-beam-sweat']='',['caret-square-down']='',['folder-open']='',['laugh-beam']='',['caret-square-left']='',['edit']='',['stop-circle']='',['copyright']='',['closed-captioning']='',['file-image']='',['file-excel']='',['gem']='',['hand-pointer']='',['life-ring']='',['hdd']='',['lemon']='',['clone']='',['flushed']='',['save']='',['keyboard']='',['file-video']='',['map']='',['money-bill-alt']='',['file-pdf']='',['caret-square-right']='',['laugh']=''}
FontTables.Brands = {['palfed']='',['d-and-d-beyond']='',['xing-square']='',['asymmetrik']='',['sass']='',['bity']='',['ubuntu']='',['tencent-weibo']='',['hackerrank']='',['centercode']='',['git-alt']='',['dailymotion']='勒',['supple']='',['creative-commons-pd-alt']='',['empire']='',['aws']='',['hooli']='',['ns8']='',['gofore']='',['free-code-camp']='',['markdown']='',['grav']='',['cc-paypal']='',['microsoft']='',['old-republic']='',['sellcast']='',['discourse']='',['windows']='',['bimobject']='',['affiliatetheme']='',['itch-io']='',['airbnb']='',['css3']='',['ussunnah']='',['itunes']='',['squarespace']='',['adversal']='',['snapchat-square']='',['quinscape']='',['reddit-alien']='',['cc-apple-pay']='',['fonticons']='',['y-combinator']='',['instagram']='',['google']='',['twitch']='',['ioxhost']='',['dhl']='',['jenkins']='',['mix']='',['facebook']='',['drupal']='',['adn']='',['github']='',['kickstarter']='',['pinterest-p']='',['expeditedssl']='',['cpanel']='',['keycdn']='',['deskpro']='',['google-drive']='',['git']='',['diaspora']='',['autoprefixer']='',['ethereum']='',['weixin']='',['zhihu']='',['envira']='',['less']='',['wordpress']='',['vuejs']='',['stripe-s']='',['evernote']='',['creative-commons']='',['cc-stripe']='',['viber']='',['pushed']='',['flickr']='',['sketch']='',['wpexplorer']='',['stripe']='',['page4']='',['microblog']='駱',['gratipay']='',['mixcloud']='',['sourcetree']='',['font-awesome-flag']='',['atlassian']='',['red-river']='',['steam-symbol']='',['blogger-b']='',['qq']='',['lastfm']='',['paypal']='',['researchgate']='',['fort-awesome']='',['amazon-pay']='',['deploydog']='',['gitter']='',['flipboard']='',['stumbleupon']='',['dropbox']='',['git-square']='',['wpressr']='',['superpowers']='',['cotton-bureau']='',['vnv']='',['mandalorian']='',['creative-commons-share']='',['linkedin-in']='',['hubspot']='',['discord']='',['simplybuilt']='',['pied-piper-alt']='',['stack-exchange']='',['buy-n-large']='',['linode']='',['creative-commons-nc']='',['salesforce']='',['figma']='',['keybase']='',['goodreads-g']='',['laravel']='',['codepen']='',['cc-mastercard']='',['usb']='',['linux']='',['audible']='',['google-plus-g']='',['medium-m']='',['telegram']='',['fantasy-flight-games']='',['snapchat']='',['angrycreative']='',['bitbucket']='',['dashcube']='',['aviato']='',['rebel']='',['uikit']='',['behance']='',['usps']='',['gitkraken']='',['buffer']='',['creative-commons-nc-eu']='',['bluetooth']='',['tumblr-square']='',['itunes-note']='',['vimeo-v']='',['vaadin']='',['lyft']='',['gulp']='',['nimblr']='',['internet-explorer']='',['delicious']='',['hips']='',['fonticons-fi']='',['youtube-square']='',['creative-commons-nc-jp']='',['steam']='',['galactic-senate']='',['nutritionix']='',['twitter-square']='',['ello']='',['joomla']='',['gitlab']='',['korvue']='',['deviantart']='',['firefox']='',['buromobelexperte']='',['css3-alt']='',['kickstarter-k']='',['goodreads']='',['github-alt']='',['google-play']='',['canadian-maple-leaf']='',['weebly']='',['pied-piper-pp']='',['creative-commons-sampling-plus']='',['avianex']='',['codiepie']='',['trade-federation']='',['sticker-mule']='',['cc-amazon-pay']='',['imdb']='',['themeisle']='',['confluence']='',['whatsapp']='',['meetup']='',['dribbble']='',['artstation']='',['yahoo']='',['facebook-square']='',['hacker-news']='',['wizards-of-the-coast']='',['ember']='',['angellist']='',['xing']='',['google-plus']='',['connectdevelop']='',['erlang']='',['digg']='',['critical-role']='',['first-order-alt']='',['firstdraft']='',['sellsy']='',['galactic-republic']='',['medapps']='',['amilia']='',['renren']='',['cloudscale']='',['dribbble-square']='',['adobe']='',['wolf-pack-battalion']='',['freebsd']='',['shopware']='',['shopify']='綾',['shirtsinbulk']='',['earlybirds']='',['creative-commons-sampling']='',['telegram-plane']='',['rocketchat']='',['searchengin']='',['github-square']='',['buysellads']='',['hornbill']='',['umbraco']='',['chrome']='',['sith']='',['medium']='',['angular']='',['dyalog']='',['spotify']='',['bootstrap']='',['wpforms']='',['app-store-ios']='',['twitter']='',['glide-g']='',['suse']='',['rev']='',['btc']='',['cc-discover']='',['algolia']='',['html5']='',['optin-monster']='',['cc-jcb']='',['magento']='',['creative-commons-remix']='',['apple']='',['maxcdn']='',['foursquare']='',['leanpub']='',['phoenix-squadron']='',['trello']='',['pied-piper']='',['instagram-square']='凌',['ebay']='',['grunt']='',['unity']='雷',['the-red-yeti']='',['symfony']='',['amazon']='',['blogger']='',['jira']='',['creative-commons-sa']='',['contao']='',['snapchat-ghost']='',['d-and-d']='',['google-plus-square']='',['megaport']='',['lastfm-square']='',['raspberry-pi']='',['acquisitions-incorporated']='',['500px']='',['medrt']='',['behance-square']='',['xbox']='',['reddit']='',['r-project']='',['ideal']='邏',['yandex']='',['dev']='',['tripadvisor']='',['mendeley']='',['tumblr']='',['accessible-icon']='',['gg-circle']='',['hotjar']='',['fly']='',['whatsapp-square']='',['mastodon']='',['swift']='',['gg']='',['wpbeginner']='',['linkedin']='',['wix']='',['draft2digital']='',['studiovinari']='',['vimeo']='',['odnoklassniki-square']='',['bitcoin']='',['phoenix-framework']='',['neos']='',['docker']='',['invision']='',['skyatlas']='',['yandex-international']='',['creative-commons-pd']='',['fort-awesome-alt']='',['forumbee']='',['jedi-order']='',['digital-ocean']='',['dochub']='',['font-awesome-alt']='',['jsfiddle']='',['black-tie']='',['facebook-f']='',['node']='',['waze']='',['mdb']='',['fedex']='',['ravelry']='',['viadeo']='',['line']='',['pinterest-square']='',['python']='',['yoast']='',['centos']='',['cc-visa']='',['stackpath']='',['cloudsmith']='',['google-wallet']='',['app-store']='',['resolving']='',['vk']='',['hire-a-helper']='',['first-order']='',['staylinked']='',['napster']='',['penny-arcade']='',['wordpress-simple']='',['php']='',['yammer']='',['creative-commons-nd']='',['youtube']='',['osi']='',['patreon']='',['uniregistry']='',['monero']='',['periscope']='',['quora']='',['vimeo-square']='',['uber']='',['mizuni']='',['kaggle']='',['modx']='',['pied-piper-hat']='',['think-peaks']='',['pied-piper-square']='爛',['slack']='',['opencart']='',['redhat']='',['reacteurope']='',['apple-pay']='',['js']='',['hacker-news-square']='',['product-hunt']='',['strava']='',['creative-commons-by']='',['intercom']='',['opera']='',['slideshare']='',['node-js']='',['cc-amex']='',['edge']='',['reddit-square']='',['themeco']='',['replyd']='',['odnoklassniki']='',['rockrms']='',['safari']='',['schlix']='',['steam-square']='',['cc-diners-club']='',['accusoft']='',['openid']='',['gripfire']='',['pinterest']='',['bandcamp']='',['skype']='',['blackberry']='',['npm']='',['slack-hash']='',['cloudversify']='',['fedora']='',['speakap']='',['elementor']='',['firefox-browser']='龜',['wikipedia-w']='',['alipay']='',['whmcs']='',['pagelines']='',['apper']='',['weibo']='',['servicestack']='',['get-pocket']='',['viadeo-square']='',['yelp']='',['facebook-messenger']='',['fulcrum']='',['sistrix']='',['vine']='',['etsy']='',['viacoin']='',['android']='',['battle-net']='',['untappd']='',['playstation']='',['cuttlefish']='',['phabricator']='',['java']='',['orcid']='',['houzz']='',['typo3']='',['joget']='',['chromecast']='',['soundcloud']='',['stack-overflow']='',['yarn']='',['ups']='',['mailchimp']='',['stumbleupon-circle']='',['js-square']='',['mixer']='稜',['scribd']='',['creative-commons-zero']='',['bluetooth-b']='',['glide']='',['teamspeak']='',['speaker-deck']='',['react']='',['font-awesome']='',['readme']=''}

local color_white = Color(255, 255, 255)
function draw.AwesomeFont(style, charname, size, weight, colr, x, y, xalign, yalign)
    if FontTables[style] == nil then return false end
    local char = FontTables[style][charname]
    if char == nil then return false end
    colr = colr or color_white
    x = x or 0
    y = y or 0
    SimpleText(char, (BuildFont(style, size, weight)), x, y, colr, xalign, yalign)
end

concommand.Add("awesomefont_viewer", function()
    if not LocalPlayer():IsRoot() then return end

    local menu = vgui.Create("DFrame")
    menu:SetTitle("       AwesomeFont Viewver")
    menu:SetSize(600, 500)
    menu:Center()
    menu:MakePopup()
    menu.headerTall = 25

    menu.active = {
        icon = "",
        iconname = "eye",
        font = defaultPreviewFont,
        color = color_white
    }

    menu.PaintOver = function(menu, w, h)
        SimpleText("", titleIconFont, menu.headerTall * 0.5, menu.headerTall * 0.5, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    menu.FontData = dafaultFontData
    menu.Controls = vgui.Create("DScrollPanel", menu)
    menu.Controls:SetSize(220, menu:GetTall() - menu.headerTall)
    menu.Controls:SetPos(0, menu.headerTall)
    menu.Controls.Panels = {}
    menu.Preview = vgui.Create("Panel", menu)
    menu.Preview:SetSize(menu:GetWide() - menu.Controls:GetWide(), menu.Controls:GetTall())
    menu.Preview:SetPos(menu.Controls:GetWide(), menu.headerTall)
    menu.Preview.bgcol = Color(0, 0, 20, 35)
    menu.Preview.linecol = Color(0, 0, 20, 100)

    menu.Preview.Paint = function(this, w, h)
        RoundedBox(0, 0, 0, w, h, this.bgcol)
        RoundedBox(0, 0, h * 0.5 - 1, w, 2, this.linecol)
        RoundedBox(0, w * 0.5 - 1, 0, 2, h, this.linecol)
        SimpleText(menu.active.icon, menu.active.font, w * 0.5, h * 0.5, menu.active.color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        SimpleText(menu.FontData.size, "rpui.Fonts.VendorNpc_Title", w - 4, h - 4, menu.active.color, TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM)
    end

    menu.Preview:SetMouseInputEnabled(true)

    menu.Preview.OnMouseWheeled = function(this, delta)
        menu.FontData.size = math_Clamp(menu.FontData.size + delta * 5, 4, 240)
        menu.active.font, menu.FontData = BuildFont(menu.FontData.type, menu.FontData.size)
    end

    local CreateControl = function(name, values, callback)
        local btnwang = vgui.Create("rpui.ButtonWang", menu.Controls)
        btnwang:SetFont("rpui.disguise.font.big")
        btnwang:SetText(name)
        btnwang.txt = name
        btnwang:Dock(TOP)
        btnwang:SetTall(32)
        btnwang:SetValues(values)
        btnwang:SetPosition(1)

        btnwang.OnValueChanged = function(this, value)
            if callback then
                callback(this, value)
            end
        end

        menu.Controls.Panels[name] = btnwang

        return btnwang
    end

    menu.FontController = CreateControl("FontType", {"Regular", "Solid", "Brands"}, function(this, val)
        --menu.FontType = val
        menu.active.font, menu.FontData = BuildFont(val, menu.FontData.size)
        menu.iconslist.ReloadFont(val)
        this:SetText(menu.FontData.type)
    end)

    menu.FontController:SetText(menu.FontData.type)
    menu.FontController:SetZPos(1)
    local string_find = string.find
    local table_insert = table.insert
    menu.serach = vgui.Create("DTextEntry", menu.Controls)
    menu.serach:SetZPos(2)
    menu.serach:Dock(TOP)
    menu.serach:SetTall(24)
    menu.serach:SetPlaceholderText("Поиск..")

    menu.serach.OnChange = function(this)
        local txt = this:GetText():lower()
        local visible = {}

        for k, pnl in pairs(menu.iconslist.Lines) do
            if not IsValid(pnl) then continue end
            local vis

            if string_find(pnl.name:lower(), txt) then
                vis = true
            end

            pnl:SetVisible(vis)
            pnl:SetTall(vis and 17 or 0)

            if vis then
                table_insert(visible, pnl)
            else
                pnl:SetZPos(99999)
            end
        end

        local i = 0

        for k, pnl in pairs(visible) do
            i = i + 1
            pnl:SetZPos(i)
        end
    end

    menu.iconslist = vgui.Create("DScrollPanel", menu.Controls)
    menu.iconslist:Dock(TOP)
    menu.iconslist:SetTall(300)
    menu.iconslist.Lines = {}
    menu.iconslist:SetZPos(3)

    local colors = {
        bg = Color(255, 255, 255),
        hover = Color(200, 200, 255),
        txt = Color(0, 0, 0)
    }

    menu.iconslist.ReloadFont = function(val)
        columnFont = BuildFont(val, 16)
        menu.iconslist:Clear()

        table.sort(FontTables[val], function(a, b) return a < b end)
        for k, v in SortedPairs(FontTables[val]) do
            local pan = vgui.Create("DButton", menu.iconslist)
            pan:SetText("")
            pan:Dock(TOP)
            pan:SetTall(17)
            pan.name = k
            pan.icon = v

            pan.Paint = function(this, w, h)
                RoundedBox(0, 0, 0, w, h, this:IsHovered() and colors.hover or colors.bg)
                SimpleText(this.name, columnFont, 4, h * 0.5, colors.txt, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
                SimpleText(this.icon, columnFont, w - 4, h * 0.5, colors.txt, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
            end

            pan.DoClick = function(this)
                menu.iconslist:OnRowSelected(this)
            end

            table_insert(menu.iconslist.Lines, pan)
        end
    end

    menu.iconslist.ReloadFont(menu.FontData.type)

    menu.iconslist.OnRowSelected = function(this, pnl)
        menu.active.icon = pnl.icon
        menu.active.iconname = pnl.name
    end

    menu.copy = vgui.Create("DButton", menu.Controls)
    menu.copy:SetTall(32)
    menu.copy:Dock(TOP)
    menu.copy:SetText("Copy Name")

    menu.copy.DoClick = function(this)
        SetClipboardText(menu.active.iconname)
    end

    menu.copy:SetZPos(4)
    menu.copy2 = vgui.Create("DButton", menu.Controls)
    menu.copy2:SetTall(32)
    menu.copy2:Dock(TOP)
    menu.copy2:SetText("Copy Icon")

    menu.copy2.DoClick = function(this)
        SetClipboardText(menu.active.icon)
    end

    menu.copy2:SetZPos(5)
end)
--[[ Параметр wide оказался хуйнёй бесполезной. Это лишниЙ элемент в меню.
	menu.slider = vgui.Create("urf.im/rpui/numslider", menu.Controls)
	menu.slider:SetZPos(6)
	menu.slider:SetTall(48)
	menu.slider:Dock(TOP)
	menu.slider:DockMargin(0, 6, 0, 0)

	menu.slider.OnSliderMove = function(this)
		--self:SetInputVal( mathRound(this:GetPseudoKnobPos()) )
		if not menu.FontData.type then return end
		menu.active.font, menu.FontData = BuildFont(menu.FontData.type, menu.FontData.size, math_Round(this:GetPseudoKnobPos()))
		--menu.iconslist.ReloadFont(val)
	end
	menu.slider.MaxValue = 1000
	menu.slider.ShowMax = true
]]
--