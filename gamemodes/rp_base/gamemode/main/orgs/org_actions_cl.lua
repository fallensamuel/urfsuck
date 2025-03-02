rp.orgs.EmoteActs = {};

rp.AddContextCommand( translates.Get("Действия"), translates.Get("Эмоции огранизации"), function()
    local m = ui.DermaMenu();

    local AActs = LocalPlayer():GetAvalibleActions();

    for actID in pairs( rp.orgs.EmoteActs[LocalPlayer():GetOrg()] ) do
        if not table.HasValue(AActs, actID) then continue end

        local rawAction = EmoteActions:GetRawAction(actID);
        local o = m:AddOption( rawAction.Name, function()
            LocalPlayer():RunEmoteAction( actID );
        end );
    end

    if m:ChildCount() == 0 then
        m:AddOption( translates.Get("Отпишитесь от всех дополнений"), function()
			gui.OpenURL( 'urf.im/page/tech' );
		end );
    end

    m:Open();
end, function()
    local org = rp.orgs.EmoteActs[LocalPlayer():GetOrg()];
    
    if org then
        if table.Count(org) > 0 then
            return true
        end
    end

    return false
end, 

'cmenu/emotes');