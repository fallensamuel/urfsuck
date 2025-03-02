-- "gamemodes\\rp_base\\gamemode\\main\\credits\\init_cl.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
rp.AddContextCommand( translates.Get("Анимации"), translates.Get("Эмоции+"), function(parent)
	local m;
	
	if rp.cfg.DisableContextRedisign then
	    m = ui.DermaMenu();
		
		local AActs = LocalPlayer():GetAvalibleActions();
		
		for UpgradeID, EmoteActs in pairs( rp.shop.EmoteActs ) do
			if !rp.cfg.FreeDances and !LocalPlayer():HasUpgrade(UpgradeID) and !rp.EventIsRunning("DanceEvent") then 
				if UpgradeID ~= 'shopacts_extra' or !LocalPlayer():HasPremium() then
					continue 
				end
			end
			
			for _, actID in pairs( EmoteActs ) do
				if not table.HasValue(AActs, actID) then continue end

				local rawAction = EmoteActions:GetRawAction(actID);
				local o = m:AddOption( rawAction.Name, function()
					LocalPlayer():RunEmoteAction( actID );
				end );
			end
		end
	else
		m = vgui.Create( "rpui.DropMenu" );
		m:SetBase( parent );
		m:SetFont( "Context.DermaMenu.Label" );
		m:SetSpacing( ScrH() * 0.01 );
		m.Paint = function( this, w, h ) draw.Blur( this ); end
		
		local AActs = LocalPlayer():GetAvalibleActions();
		
		for UpgradeID, EmoteActs in pairs( rp.shop.EmoteActs ) do
			if !rp.cfg.FreeDances and !LocalPlayer():HasUpgrade(UpgradeID) and !rp.EventIsRunning("DanceEvent") then 
				if UpgradeID ~= 'shopacts_extra' or !LocalPlayer():HasPremium() then
					continue 
				end
			end
			
			for _, actID in pairs( EmoteActs ) do
				if not table.HasValue(AActs, actID) then continue end

				local rawAction = EmoteActions:GetRawAction(actID);
				local o = m:AddOption( rawAction.Name, function()
					LocalPlayer():RunEmoteAction( actID );
				end );
				
				o.Paint = function( this, w, h )
					local baseColor, textColor = rpui.GetPaintStyle( this, STYLE_TRANSPARENT_SELECTABLE );
					surface.SetDrawColor( baseColor );
					surface.DrawRect( 0, 0, w, h );
					draw.SimpleText( this:GetText(), this:GetFont(), this.Spacing, h * 0.5, textColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER );
					return true
				end
			end
		end
	end

    if m:ChildCount() == 0 then
        m:AddOption( translates.Get("Отпишитесь от всех дополнений"), function()
			gui.OpenURL( 'urf.im/page/tech' );
		end );
    end	
	
    m:Open();
end, function() 
    local result = hook.Run( "EmoteActions::GetCanUseActions" )
    
    if result == false then
        return false
    end

    for UpgradeID in pairs( rp.shop.EmoteActs ) do
        if rp.cfg.FreeDances or LocalPlayer():HasUpgrade(UpgradeID) or rp.EventIsRunning("DanceEvent") or LocalPlayer():HasPremium() then
            return true
        end
    end

    return false
end, 'cmenu/emotes_plus');

rp.AddContextCommand( translates.Get("Анимации"), translates.Get("Премиальные"), function(parent)
	local m;
	
		m = vgui.Create( "rpui.DropMenu" );
		m:SetBase( parent );
		m:SetFont( "Context.DermaMenu.Label" );
		m:SetSpacing( ScrH() * 0.01 );
		m.Paint = function( this, w, h ) draw.Blur( this ); end
		
		local AActs = LocalPlayer():GetAvalibleActions();
		
		--for UpgradeID, EmoteActs in pairs( rp.shop.EmoteActs ) do
			--if !rp.cfg.FreeDances and !LocalPlayer():HasUpgrade(UpgradeID) and !rp.EventIsRunning("DanceEvent") and !LocalPlayer():HasPremium() then continue end
			
			for _, actID in pairs( AActs ) do
				--if not table.HasValue(AActs, actID) then continue end

				local rawAction = EmoteActions:GetRawAction(actID);
				
				if rawAction.Category ~= 'Премиальные' then continue end
				
				local o = m:AddOption( rawAction.Name, function()
					LocalPlayer():RunEmoteAction( actID );
				end );
				
				o.Paint = function( this, w, h )
					local baseColor, textColor = rpui.GetPaintStyle( this, STYLE_TRANSPARENT_SELECTABLE );
					surface.SetDrawColor( baseColor );
					surface.DrawRect( 0, 0, w, h );
					draw.SimpleText( this:GetText(), this:GetFont(), this.Spacing, h * 0.5, textColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER );
					return true
				end
			end
		--end

    if m:ChildCount() == 0 then
        m:AddOption( translates.Get("Отпишитесь от всех дополнений"), function()
			gui.OpenURL( 'urf.im/page/tech' );
		end );
    end	
	
    m:Open();
end, function()
    local result = hook.Run( "EmoteActions::GetCanUseActions" )
    
    if result == false then
        return false
    end

    return LocalPlayer():HasPremium()
end, 'cmenu/emotes_plus');

rp.AddContextCommand( translates.Get("Анимации"), translates.Get("Групповые"), function( parent )
    local m = vgui.Create( "rpui.DropMenu" );
    m:SetBase( parent );
    m:SetFont( "Context.DermaMenu.Label" );
    m:SetSpacing( ScrH() * 0.01 );
    m.Paint = function( this, w, h ) draw.Blur( this ); end

	if #LocalPlayer():GetAvalibleActions() > 0 then
		for _, actID in ipairs( LocalPlayer():GetAvalibleActions() ) do
			local raw = EmoteActions:GetRawAction( actID );

            if raw.IsHidden                then continue end
			if raw.Category ~= "Групповые" then continue end

			local option = m:AddOption( raw.Name, function()
				LocalPlayer():RunEmoteAction( actID );
            end );
            
            option.Paint = function( this, w, h )
                local baseColor, textColor = rpui.GetPaintStyle( this, STYLE_TRANSPARENT_SELECTABLE );
                surface.SetDrawColor( baseColor );
                surface.DrawRect( 0, 0, w, h );
                draw.SimpleText( this:GetText(), this:GetFont(), this.Spacing, h * 0.5, textColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER );
                return true
            end
		end
	end

	if m:ChildCount() == 0 then
        local option = m:AddOption( translates.Get("Отпишитесь от всех дополнений"), function()
			gui.OpenURL( 'urf.im/page/tech' );
		end );
        
        option.Paint = function( this, w, h )
            local baseColor, textColor = rpui.GetPaintStyle( this, STYLE_TRANSPARENT_SELECTABLE );
            surface.SetDrawColor( baseColor );
            surface.DrawRect( 0, 0, w, h );
            draw.SimpleText( this:GetText(), this:GetFont(), this.Spacing, h * 0.5, textColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER );
            return true
        end
	end

	m:Open();
end, function()
    local result = hook.Run( "EmoteActions::GetCanUseActions" )
    
    if result == false then
        return false
    end

    return LocalPlayer():HasPremium()
end, 'cmenu/emotes_shared' );

net.Receive('rp.sales.SendToClient', function()
	for k,v in pairs(net.ReadTable()) do
		rp.shop.Mapping[k]:SetDiscount(v)
    end
    
    for k, v in pairs(net.ReadTable()) do
        rp.shop.Mapping[k]:SetAltPrice(v);
    end
end)
