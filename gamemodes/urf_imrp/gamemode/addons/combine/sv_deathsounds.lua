
local radioDeathSong 	= Sound("npc/overwatch/radiovoice/lostbiosignalforunit.wav")
local timer_Simple 		= timer.Simple

hook.Add("PlayerDeath", function(ply)
	if ply:IsCombineOrDisguised() then
		timer_Simple(2, function()
			ply:EmitSound(radioDeathSong )
		end)
	end
end)