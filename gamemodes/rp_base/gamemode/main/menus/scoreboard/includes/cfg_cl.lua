if SERVER then return end

local Color_ = Color
local colr_trans = Color_(0, 0, 0, 0)

local function StrRequest(title, text, func)
	return ui and function()
		ui.StringRequest(title, text, "", function(s)
	       	func(s)
	    end)
	end
	or function()
		Derma_StringRequest(title, text, nil, function(s)
			func(s)
		end)
	end
end

return { -- Как вариант можно сделать return rp.cfg.scoreboard ради переноса самых главных конфигурируемых частей скоборда вроде Title, Description, Branding, BrandingScale, FontName e.t.c
    Title = rp.cfg.ScoreboardName, --"Incredible Scoreboard v2",
    Description = translates.Get("Наш Discord сервер - www.urf.im/discord"), --"Обезопасить, удалить, сохранить",
    Branding = Material("scoreboard/logo4scoreboard.png", "smooth", "noclamp"),
    BrandingScale = 0.6, -- Уменьшение / Увеличение логотипа (1 = оригинальный размер)
    scrollSpeeedMult = 2,
    colors = {
        white = Color_(255, 255, 255),
        white2 = Color_(225, 225, 225),
        white_t = Color_(255, 255, 255, 200),
        white_t2 = Color_(255, 255, 255, 175),
        black_t = Color_(0, 0, 0, 100),
        dark = Color_(10, 10, 15),
        background = Color_(20, 20, 25, 200),
        cyan = Color_(40, 149, 220),
        orange = Color_(255, 200, 0),
        pink = Color_(215, 90, 75, 200)
    },
    FontName = "Montserrat",
    fonts = {
        small = 15, -- размер шрифта
        semismall = 16,
        semimedium = 18,
        medium = 22,
        large = {
            size = 36,
            weight = 600
        }
    },
    expandedButtons = {
        col = function(bg, hover)
        	local _c_ = hover and 25 or 35
            local m = function(c) return c - _c_ end

            return bg and Color_(m(bg.r), m(bg.g), m(bg.b)) or colr_trans
        end,
        text_col = Color_(255, 255, 255),
        build = {
            {
                name = function(ply) return translates.Get("Забанить") end,
                func = function(ply)
                    local banlen = {{translates.Get("%i мин.", 5), "5mi"}, {translates.Get("%i мин.", 10), "10mi"}, {translates.Get("%i мин.", 15), "15mi"}, {translates.Get("%i мин.", 20), "20mi"}, {translates.Get("%i мин.", 30), "30mi"}, {translates.Get("%i мин.", 40), "40mi"}, {translates.Get("%i час.", 1), "1h"}}

                    local m = ui.Create('ui_frame', function(self)
                        self:SetTitle(translates.Get("Бан") .. " " .. ply:Nick())
                        self:ShowCloseButton(true)
                        self:SetWide(ScrW() * .3)
                        self:MakePopup()
                    end)

                    local txt = string.Wrap('ui.18', translates.Get("Введите причину бана") .. " " .. ply:Name(), m:GetWide() - 10)
                    local y = m:GetTitleHeight()

                    for k, v in ipairs(txt) do
                        local lbl = ui.Create('DLabel', function(self, p)
                            self:SetText(v)
                            self:SetFont('ui.18')
                            self:SizeToContents()
                            self:SetPos((p:GetWide() - self:GetWide()) / 2, y)
                            y = y + self:GetTall()
                        end, m)
                    end

                    local tb = ui.Create('DTextEntry', function(self, p)
                        self:SetPos(5, y + 5)
                        self:SetSize(p:GetWide() - 10, 25)
                        self:SetValue("")
                        y = y + self:GetTall() + 10

                        self.OnEnter = function(s)
                            m:Close()
                        end
                    end, m)

                    y = y + 24
                    local offset = 0

                    local lbl = ui.Create('DLabel', function(self, p)
                        self:SetText(translates.Get("Забанить на:"))
                        self:SetFont('ui.18')
                        self:SizeToContents()
                        self:SetPos(4, y - 4)
                        y = y + self:GetTall()
                    end, m)

                    for key, tbl in pairs(banlen) do
                        local btnOK = ui.Create('DButton', function(self, p)
                            self:SetText(tbl[1])
                            self:SetPos(lbl:GetWide() + 12 + offset, y - 24)
                            self:SizeToContents()

                            self.DoClick = function(s)
                                local banreason = tb:GetValue()
                                local str_banlen = tbl[1]
                                local banlen_ = tbl[2]

                                if self:GetText() == "OK" then
                                    if string.len(banreason) < 1 then
                                        ErrorSound()
                                        m:Close()
                                        rp.Notify(NOTIFY_RED, translates.Get("Ошибка! Причина бана не указана!"))

                                        return
                                    end

                                    RunConsoleCommand('urf', 'ban', ply:SteamID(), banlen_, banreason)
                                    m:Close()
                                end

                                self:SetText("OK")
                            end
                        end, m)

                        offset = offset + btnOK:GetWide() + 2
                    end

                    y = y + 4
                    m:SetTall(y)
                    m:Center()
                    m:Focus()
                end,
                acess = function(ply, target)
                    return LocalPlayer():HasFlag("M")
                end
            },
            {
                name = function(ply) return translates.Get("Профиль Steam") end,
                func = function(ply)
                    ply:ShowProfile()
                end,
                acess = function(ply, target)
                	return IsValid(target) and not target:IsBot()
                end
            },
            {
                name = function(ply) return translates.Get("Телепортировать") end,
                func = function(ply)
                    RunConsoleCommand("urf", "tp", (ply:IsBot() and ply:Nick() or ply:SteamID()))
                end,
                acess = function(ply, target)
                    return LocalPlayer():HasFlag("M")
                end
            },
            {
                name = function(ply) return translates.Get("Уволить") end,
                func = function(ply)
                    ui.StringRequest(translates.Get("Увольнение") .. " " .. ply:Nick(), translates.Get("Введите причину увольнения") .. " " .. ply:Name() .. ".", "", function(s)
                        RunConsoleCommand("rp", "demote", (ply:IsBot() and ply:Nick() or ply:SteamID()), s)
                    end)
                end
            },
            {
                name = function(ply) return translates.Get("Телепортироваться") end,
                func = function(ply)
                    RunConsoleCommand("urf", "goto", (ply:IsBot() and ply:Nick() or ply:SteamID()))
                end,
                acess = function(ply, target)
                    return LocalPlayer():HasFlag("M")
                end
            },
            {
                name = function(ply) return ply.SteamIDCopied and (ply.SteamIDCopied > CurTime()) and translates.Get("Скопировано") or ply:SteamID() end,
                func = function(ply)
					ply.SteamIDCopied = CurTime() + 1
                    SetClipboardText(ply:SteamID())
                end,
                acess = function(ply, target)
                	return not target:IsBot()
                end
            }, 
            {
                name = function(ply) return ply:IsWanted() and translates.Get("Снять розыск") or translates.Get("Подать в розыск") end,
                func = function(ply)
                    if ply:IsWanted() then
						RunConsoleCommand("do_unwanted", ply:SteamID())
						return
					end
					StrRequest(translates.Get("Объявление в розыск игрока %s.", ply:Nick()), translates.Get("Напишите причину розыска"), function(s)
						if string.len(s) < 1 then
							rp.Notify(NOTIFY_RED, translates.Get("Укажите причину розыска!"))
							return
						end

						RunConsoleCommand("do_wanted", s, ply:SteamID())
					end)()
                end,
                acess = function(ply, target)
                	return ply:IsCP() --and not target:IsCP()
                end
            }, 
            {
                name = function(ply) return translates.Get("Вернуть обратно") end,
                func = function(ply)
					RunConsoleCommand("urf", "return", ply:IsBot() and ply:Nick() or ply:SteamID())
                end,
                acess = function(ply, target)
                	return LocalPlayer():HasFlag("M")
                end
            }, 
            {
                name = function(ply) return LocalPlayer():GetNetVar('Spectating') and translates.Get("Прекратить следить") or translates.Get("Следить") end,
                func = function(ply)
					if LocalPlayer():GetNetVar('Spectating') then
						RunConsoleCommand("urf", "spectate")
						
					else
						RunConsoleCommand("urf", "spectate", ply:IsBot() and ply:Nick() or ply:SteamID())
					end
                end,
                acess = function(ply, target)
                	return LocalPlayer():HasFlag("A") and target ~= LocalPlayer()
                end
            }, 
        }
    }
}