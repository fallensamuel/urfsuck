local function MakePoo(player)
	local turd = ents.Create("ent_poop")
	turd:SetPos(player:GetPos() + Vector(0,0,32))
	turd:Spawn()
	player:EmitSound("ambient/levels/canals/swamp_bird2.wav", 50, 80)
	timer.Simple(30, function() if turd:IsValid() then turd:Remove() end end)
end


local function DoPoo(pl)
	if !pl:Alive() then
			rp.Notify(pl, NOTIFY_ERROR, rp.Term('YouAreDead'))
		return "" 
	end
	if pl.NextPoo != nil && pl.NextPoo >= CurTime() then
			--if math.random(1, 5) == 5 and not (pl.IsHandcuffed and pl:IsHandcuffed()) then
				--MakePoo(pl)
				--pl:Kill()
				--rp.Notify(pl, NOTIFY_ERROR, rp.Term('AnalProlapse'))
				--return ""
			--end
			rp.Notify(pl, NOTIFY_ERROR, rp.Term('NoMorePoo'))
		return "" 
	end
	pl.NextPoo = CurTime() + 10
	MakePoo(pl)
	return ""
end

if not rp.cfg.Serious then
	rp.AddCommand("/poo", DoPoo)
	rp.AddCommand("/poop", DoPoo)
end