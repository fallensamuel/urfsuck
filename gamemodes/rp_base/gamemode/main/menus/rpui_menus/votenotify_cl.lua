-- "gamemodes\\rp_base\\gamemode\\main\\menus\\rpui_menus\\votenotify_cl.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local OldMaterial = Material
local Material = function(s)
    return OldMaterial(s, "smooth", "noclamp")
end

rp.cfg.VoteTypes = rp.cfg.VoteTypes or {}

rp.cfg.VoteTypes["conjunction"] = {
    title = translates and translates.Get("Дипломатия") or "Дипломатия",
    ico = Material("diplomacy/allyic64.png")
}
rp.cfg.VoteTypes["lottery"] = {
    headertitle = translates and translates.Get("Лотерея") or "Лотерея",
    title = translates and translates.Get("Купить билет?") or "Купить билет?",--translates and translates.Get("Лотерея") or "Купить билет?",
    ico = Material("shop/sell.png")--Material("rpui/bonus_menu/cash.vtf")
}
rp.cfg.VoteTypes["hire"] = {
    title = translates and translates.Get("Наём") or "Наём",
    ico = Material("ping_system/follow.png"),
    IcoSizeMult = 1.5
}
rp.cfg.VoteTypes["warrant"] = {
    title = translates and translates.Get("Обыск") or "Обыск",
    ico = Material("ping_system/police_up.png")
}
rp.cfg.VoteTypes["demote"] = {
    headertitle = translates and translates.Get("Увольнение") or "Увольнение",
    title = "",
    ico = Material("rpui/misc/flag.png")
}
rp.cfg.VoteTypes["orginvite"] = {
    headertitle = translates and translates.Get("Организация") or "Организация",
    title = translates and translates.Get("Хотели бы вы присоединиться к") or "Хотели бы вы присоединиться к",
    ico = Material("ping_system/addorg.png"),
    IcoSizeMult = 2
}
rp.cfg.VoteTypes["mount"] = {
    headertitle = translates and translates.Get("Верховая езда") or "Верховая езда",
    title = translates and translates.Get("Имя наездника: ") or "Имя наездника: ",
    ico = Material("ping_system/mount.png"),
    IcoSizeMult = 2
}

for i = 1, 120 do
    rp.cfg.VoteTypes["lottery"..i] = rp.cfg.VoteTypes["lottery"]
end

local Sw, pairs_, IsValid_ = ScrW, pairs, IsValid
local net = net
local CurTime = CurTime
local LocalPlayer = LocalPlayer
local hook = hook
local pairs = pairs
local IsValid = IsValid
local table = table
local math = math
local tostring = tostring
local timer = timer

rp.NotifyVotePanels = rp.NotifyVotePanels or {}

local Wide = 400
local Tall = 45
local Wide_2 = 0.5 * Wide
local Tall_2 = 0.5 * Tall

local posX = function()
    return 0 --Sw()*0.25 - Wide_2
end

local MoveAllNotifyPANELS = function(isforce)
    local i = 0
    local y_offset =  0

    for k, pnl in pairs_(rp.NotifyVotePanels) do
        if not IsValid_(pnl) then rp.NotifyVotePanels[k] = nil continue end

        pnl._i = i

        --local y = (pnl._pTall or Tall) * i + (y_offset and ((IsValid_(who) and who._i or 0) < i) and y_offset or 0)
        
		y_offset = y_offset + (pnl._pTall or Tall)
		local y = y_offset

        if IsValid_(pnl.popup) then
            y_offset = y_offset + pnl.popup.GetTall(pnl.popup)
        end

        if isforce then
            pnl:SetPos(posX(), y)
        else
            pnl:MoveTo(posX(), y, 0.15)
        end
        pnl:OnMoveTo(posX(), y, 0.15, isforce)

        i = i + 1
    end
end

local CreateVoteNotify = function(question, quesid, timeleft, steamid, _vote_ID)
    local OldTime = CurTime()
    local realQuesID = _vote_ID or (quesid.."") -- copy

    if timeleft == 0 then
        timeleft = 100
    end

    local st = string.find(question, "|")
    local Add2Title = ""
    if st then
        Add2Title = question:sub(1, st-1)
        question = question:sub(st+1, 999)
    end

    local st2 = string.find(quesid, "|")
    if st2 then
        quesid = quesid:sub(0, st2-1)
    end

    local is_opened
    for k, pnl in pairs_(rp.NotifyVotePanels) do
        if IsValid_(pnl) and IsValid_(pnl.popup) then
            is_opened = true
            break
        end
    end
                                 
    local voteType = rp.cfg.VoteTypes[quesid]

    if IsValid(LocalPlayer()) and cvar.GetValue("enable_notify_top") then
        LocalPlayer():EmitSound("Town.d1_town_02_elevbell1", 100, 100)
    end

    rp.NotifyVoteParent = rp.NotifyVoteParent or vgui.Create( "DPanel" );
    rp.NotifyVoteParent.SetSize( rp.NotifyVoteParent, Wide, Tall * table.Count(rp.NotifyVotePanels) + Tall * 12 + 9 );
    rp.NotifyVoteParent.CenterHorizontal( rp.NotifyVoteParent );
    rp.NotifyVoteParent.MakePopup( rp.NotifyVoteParent );
    rp.NotifyVoteParent.SetKeyboardInputEnabled( rp.NotifyVoteParent, false );
    rp.NotifyVoteParent.SetPaintBackground( rp.NotifyVoteParent, false );
    rp.NotifyVoteParent.Think = function( this )
        if this.IsMouseInputEnabled( this ) then this.SetMouseInputEnabled( this, false ); end
		
        if #this:GetChildren() > 0 then
            this.InvalidateLayout( this, true );
            this.SizeToChildren( this, false, true );

			this.SetMouseInputEnabled( this, g_ContextMenu.IsVisible(g_ContextMenu) or vgui.CursorVisible() );   

            if not g_RPUI_JobsList_HasFocus then
                this.MoveToFront( this );
            end
        end
    end
    
    --[[
    hook.Add("OnContextMenuOpen", "NotifyVote.SetParent", function()
        g_ContextMenu.NotifyVoteParent = g_ContextMenu.NotifyVoteParent or vgui.Create("Panel", g_ContextMenu)
        g_ContextMenu.NotifyVoteParent.SetSize(g_ContextMenu.NotifyVoteParent, ScrW()*0.5, ScrH()*0.5)
        CenterPos(g_ContextMenu.NotifyVoteParent)
        
        for k, pnl in pairs(rp.NotifyVoteParent.GetChildren(rp.NotifyVoteParent)) do
            pnl:SetParent(g_ContextMenu.NotifyVoteParent)
            if IsValid(pnl.popup) then
                pnl.popup.SetParent(pnl.popup, g_ContextMenu.NotifyVoteParent)
            end
        end
    end)

    hook.Add("OnContextMenuClose", "NotifyVote.SetParent", function()
        if IsValid(g_ContextMenu.NotifyVoteParent) then
            for k, pnl in pairs(g_ContextMenu.NotifyVoteParent.GetChildren(g_ContextMenu.NotifyVoteParent)) do
                pnl:SetParent(rp.NotifyVoteParent)
                if IsValid(pnl.popup) then
                    pnl.popup.SetParent(pnl.popup, rp.NotifyVoteParent)
                end
            end
        end
    end)
    ]]--

    local notifyvote = vgui.Create("urf.im/rpui/notifyvote", rp.NotifyVoteParent)
    notifyvote.questionID = quesid
    notifyvote.tab_index = table.insert(rp.NotifyVotePanels, notifyvote)
    notifyvote:SetSize(Wide, Tall)
    notifyvote:SetPos(posX(), -Tall)

    --if table.Count(rp.NotifyVotePanels) > 0 then
    --    local pnl = table.GetLastValue(rp.NotifyVotePanels)
	--	if IsValid(pnl) then 
	--		pnl.lastpanel = notifyvote
	--	end
    --end

    local pnl;

    for _, v in ipairs( rp.NotifyVoteParent.GetChildren( rp.NotifyVoteParent ) ) do
        if not pnl then pnl = v; continue end

        if (v.GetY(v) + v.GetTall(v)) > (pnl.GetY(pnl) + pnl.GetTall(pnl)) then
            pnl = v;
        end
    end

    if IsValid( pnl ) then
        pnl.lastpanel = notifyvote;
    end

    if not is_opened then
        notifyvote.btn:DoClick()
    end

    notifyvote:SetIcon(voteType and voteType.ico or "scoreboard/usergroups/ug_1.png")
    notifyvote:SetTitle(voteType and voteType.headertitle or translates and translates.Get("Голосование") or "Голосование")
    notifyvote:SetFont("rpui.playerselect.title")
    notifyvote.IcoSizeMult = voteType and voteType.IcoSizeMult or 1

    notifyvote.Think = function(this)
        local time = math.ceil(timeleft - (CurTime() - OldTime))

        this.Title = voteType and voteType.headertitle and (voteType.headertitle .. ": " .. tostring(math.abs(time))) or translates and translates.Get("Голосование: %s", tostring(math.abs(time))) or ("Голосование: "..tostring(math.abs(time)))

        local last = this:GetParent():GetChild(#this:GetParent():GetChildren() - 1)
        this.DrawGradient = IsValid_(last)
        if this.DrawGradient and (last == this or this.IsOpened) then
            this.DrawGradient = nil
        end

        if this.MoveThink then
            MoveAllNotifyPANELS(true)
        end

        if time <= 0 then
            this.NoMove = true
            this:Close()
        end
    end

    notifyvote:SetContents((voteType and voteType.title or "").." "..Add2Title, question, function()
        if steamid then
            LocalPlayer():ConCommand("vote " .. realQuesID .. " yea\n")
        else
            LocalPlayer():ConCommand("ans " .. realQuesID .. " 1\n")
        end
        notifyvote:Close()
    end)

    notifyvote.ButtonNoDoClick = function()
        if steamid then
            LocalPlayer():ConCommand("vote " .. realQuesID .. " nay\n")
        else
            LocalPlayer():ConCommand("ans " .. realQuesID .. " 2\n")
        end
        notifyvote:Close()
    end

    notifyvote.PreRemove = function(this)
        rp.NotifyVotePanels[notifyvote.tab_index] = nil
        MoveAllNotifyPANELS()
    end
    notifyvote.OnClose = function(this)
        MoveAllNotifyPANELS()
    end
    notifyvote.OnPopupSizeTo = function(this, w, h, time)
        MoveAllNotifyPANELS(true)
        this.MoveThink = true
    end
    notifyvote.OnPopupSizeToEnd = function(this, w, h, time)
        timer.Simple(0.1, function()
            if IsValid(this) then this.MoveThink = nil end
        end)
    end

	timer.Simple(0, function()
		MoveAllNotifyPANELS()
	end)
	
	return notifyvote
end

net.Receive("DoQuestion", function()
    if IsValid(LocalPlayer()) and LocalPlayer():IsBanned() then return end

    local question = net.ReadString()
    local quesid = net.ReadString()
    local timeleft = net.ReadFloat()

    CreateVoteNotify(question, quesid, timeleft)
end)

net.Receive("KillQuestionVGUI", function()
    local id = net.ReadString()

    for k, pnl in pairs(rp.NotifyVotePanels) do
        if IsValid(pnl) and pnl.questionID == id then
            pnl:Close()
        end
    end
end)


function rp.NotifyVoteClient(message, quesid, timeleft)
	return CreateVoteNotify(message, quesid, timeleft)
end


usermessage.Hook("DoVote", function(msg)
    if LocalPlayer():IsBanned() then return end

    local question = msg:ReadString()
    local voteid = msg:ReadShort()
    local timeleft = msg:ReadFloat()
    local steamid = msg:ReadString()

    CreateVoteNotify(question, "demote", timeleft, steamid, voteid)
end)

usermessage.Hook("KillVoteVGUI", function(msg)
    local id = msg:ReadShort()

    for k, pnl in pairs(rp.NotifyVotePanels) do
        if IsValid(pnl) and pnl.questionID == id then
            pnl:Close()
        end
    end
end)

concommand.Add("notifyvote_debug_menu", function()
    if not LocalPlayer():IsRoot() then return end

    if IsValid_(notifyvote_debug_menu) then notifyvote_debug_menu:Remove() return end

    notifyvote_debug_menu = vgui.Create("DFrame")
    notifyvote_debug_menu:SetSize(330, 150)
    notifyvote_debug_menu:SetPos(ScrW()*0.5 - 330*0.5, ScrH()-150)
    notifyvote_debug_menu:SetMouseInputEnabled(true)

    local btns = {
        {
            txt = "Clear",
            func = function()
                for k, v in pairs(rp.NotifyVotePanels) do
                    if not IsValid_(v) then rp.NotifyVotePanels[k] = nil continue end
                    v:Close()
                end
            end
        },
        {
            txt = "Create",
            func = function()
                CreateVoteNotify("Цена: "..rp.FormatMoney(1000), "lottery", 30, "")
            end
        },
        {
            txt = "Print",
            func = function()
                for k, v in pairs(rp.NotifyVotePanels) do
                    print(k, v.tab_index)
                end
            end
        }
    }

    for i = 1, #btns do
        local _i = i - 1
        local btn = vgui.Create("DButton", notifyvote_debug_menu)
        btn:SetSize(100, 100)
        btn:SetText(btns[i].txt)
        btn:SetPos(_i*110 + 5, 40)
        btn.DoClick = btns[i].func

        notifyvote_debug_menu["btn"..i] = btn
    end
end)
