-- "gamemodes\\rp_base\\gamemode\\addons\\experiences\\sh_hooks.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
hook.Add( "PlayerExperienceID", "GetJobExperienceID", function( ply )
    local jt = ply:GetJobTable();
    if not (jt and jt.experience) then return end

    if jt.experience.id then
        return jt.experience.id;
    end
end );

hook.Add( "PlayerCanTeam", "Experiences::PlayerCanTeam", function( ply, t )
    if t.experience and t.customCheck and not t.customCheck( ply ) then
        if t.CustomCheckFailMsg then
            rp.Notify( ply, NOTIFY_ERROR, rp.Term(t.CustomCheckFailMsg or "BannedFromJob") );
        end

        return false;
    end
end );