-- "gamemodes\\rp_base\\entities\\entities\\ent_heists_moneypallet\\cl_init.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
include( "shared.lua" );

local tr = translates
local cached
	if tr then
		cached = {
			tr.Get( 'Ограбление в процессе' ), 
			tr.Get( 'Ограбление не в процессе' ), 
			tr.Get( 'Нажмите [E] чтобы начать ограбление' ), 
		}
	else
		cached = {
			'Ограбление в процессе', 
			'Ограбление не в процессе', 
			'Нажмите [E] чтобы начать ограбление', 
		}
	end

function ENT:Draw()
    self:DrawModel();

    local plypos = LocalPlayer():GetPos();
    local pos    = self:LocalToWorld( Vector(0,0,self:GetModelRadius()*1.2) );

    local atan2  = math.atan2(plypos.y - pos.y, plypos.x - pos.x);
    local ang    = Angle( 0, math.deg(atan2) + 90, 90 );

    local s      = 0.1;

    cam.Start3D2D( pos, ang, s );
        local status = "";

        if rp.cfg.Heists.IsBadLeader(LocalPlayer():Team()) then
            status = "(" .. (rp.Heists.IsHeistRunning and cached[1] or cached[3]) .. ")";
        else
            status = "(" .. (rp.Heists.IsHeistRunning and cached[1] or cached[2]) .. ")";
        end

        draw.SimpleText( status, rp.cfg.Heists.Fonts.EntityMedium, 0, -70, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM );
        --draw.SimpleText( rp.FormatMoney(self:GetMoney()) .. " (" .. math.Round((self:GetMoney()/self.MoneyLimit)*100) .. "%)", rp.cfg.Heists.Fonts.EntityBig, 0, 0, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
        draw.SimpleText( self.PrintName, rp.cfg.Heists.Fonts.EntityBig, 0, -48, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
        draw.SimpleText( rp.FormatMoney(self:GetMoney()), rp.cfg.Heists.Fonts.EntityBig, 0, 0, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
    cam.End3D2D();
end