hook.Add('LoadTerms', function()
	rp.AddTerm('TrashDesyroyReward', "Вы получили "..rp.FormatMoney(rp.cfg.TrashDestroyReward).." за уничтожение мусора!")
end)
