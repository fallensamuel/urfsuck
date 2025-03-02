-- "gamemodes\\rp_base\\gamemode\\addons\\small_things\\cl_bannerimprovements.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local classes = { ["weapon_banner_new"] = true };

local bannermenu;

local function drawworldmodel( wep )
    wep:DrawModel();

    if cvar.GetValue("enable_pictureframes") == false or not wep:InSight() then return end

    if (not wep:GetTexture() and not wep.Rendering) or (wep:GetURLt() ~= wep.LastURL and not wep.Rendering) then
        wep:RenderTexture();
    elseif wep:GetTexture() then
        local pos, ang = Vector(0, 0, 0), Angle(0, 0, 0);

        local ent = wep:GetOwner();

        if IsValid( ent ) then
            local bone = ent:LookupBone( "ValveBiped.Bip01_R_Hand" ) or 0;
            local m = ent:GetBoneMatrix( bone );

            if m then
                pos, ang = m:GetTranslation(), m:GetAngles();
            end
        end

        ang:RotateAroundAxis( ang:Up(), -45 );
        ang:RotateAroundAxis( ang:Forward(), -96 );
        ang:RotateAroundAxis( ang:Right(), -34 );

        cam.Start3D2D( pos + ang:Forward() * -23.4 + ang:Right() * -47.9 + ang:Up() * 4.9, ang, 0.0462 );
            surface.SetDrawColor( color_white );
            surface.SetMaterial( wep:GetTexture() );
            surface.DrawTexturedRect( 0, 0, 1100, 589 );
        cam.End3D2D();
    end
end

local function reload( wep )
    if not IsFirstTimePredicted() then return end

    if not IsValid( bannermenu ) then
        bannermenu = rpui.StringRequest( translates.Get("Установка изображения"), translates.Get("Доступные сервисы: %s. За нецензуру бан.", table.concat(rp.WebMat.WhitelistPretty or {"?"}, ", ")), "shop/filters/list.png", 1.4, function( this, val )
            if not rp.WebMat:IsValidURL( val ) then
                rp.Notify( NOTIFY_ERROR, translates.Get("Недопустимая ссылка") );
                return
            end

            rp.RunCommand( "setimagebanner", val );
        end );

        bannermenu:SetWide( ScrW() * 0.425 );
        bannermenu:Center();
    end
end

hook.Add( "PreRegisterSWEP", "weapon_banner", function( wep, class )
    if not classes[class] then return end

    wep.Reload = reload;
    wep.DrawWorldModel = drawworldmodel;
end );