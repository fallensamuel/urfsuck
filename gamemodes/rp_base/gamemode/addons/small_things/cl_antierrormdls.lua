local pairs, insert, entsGetAll, LocalPlayer, IsValid, ColorAlpha, SimpleText, FindInSphere = pairs, table.insert, ents.GetAll, LocalPlayer, IsValid, ColorAlpha,draw.SimpleText, ents.FindInSphere
local TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, TEXT_ALIGN_TOP = TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, TEXT_ALIGN_TOP

surface.CreateFont("urf.im/errormodels", {
	font = "Montserrat", 
    extended = true,
    antialias = true,
    size = 14
})

local badEnts = {}
local MaxDist = 125*125
local txtCol = Color(200, 200, 200)

local text1 = translates.Get("Пожалуйста подпишитесь на контент в ESC меню!")
local text2 = translates.Get("Памятка с информацией по решению проблем: urf.im/page/tech")

local iserror = {["models/error.mdl"] = true}

timer.Create("AntiErrorMdls", 5, 0, function()
	badEnts = {}

	for k, ent in pairs(entsGetAll()) do
		if iserror[ent:GetModel()] then
			ent:SetModel("models/props_junk/cardboard_box004a.mdl")

			if ent.badents_index then
				badEnts[ent.badents_index] = nil
			end

			local index = insert(badEnts, ent)
			ent.badents_index = index
		end
	end
end)

hook.Add("HUDPaint", "AntiErrorMdls", function()
	local lpPos = LocalPlayer():GetPos()

	for k, ent in pairs(badEnts) do
		if IsValid(ent) == false then
			badEnts[k] = nil
			continue
		end

		local pos = ent:GetPos()
		local dist = pos:DistToSqr(lpPos)
		if dist >= MaxDist then continue end

		local pos2d = pos:ToScreen()

		local col = ColorAlpha(txtCol, 255 - (dist/MaxDist * 255))
		SimpleText(text1, "urf.im/errormodels", pos2d.x, pos2d.y, col, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
		SimpleText(text2, "urf.im/errormodels", pos2d.x, pos2d.y, col, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
	end
end)

hook.Add("FixErrorItemShowEntityMenu", "AntiErrorMdls", function(LocalPlayer)
	if LocalPlayer.HasBlockedInventory and LocalPlayer:HasBlockedInventory() then return true end

	for k, ent in pairs(FindInSphere(LocalPlayer:GetEyeTrace().HitPos, 8)) do
		if ent.badents_index and ent:GetNWBool("isInvItem") then
            hook.Run("ItemShowEntityMenu", ent)
			return true
		end
	end
end)