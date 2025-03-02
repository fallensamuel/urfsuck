rp.RadioSpeakers = {}

nw.Register 'RC_RadioOnSpeak'
	:Write(net.WriteBool)
	:Read(net.ReadBool)
	:SetPlayer()
	
nw.Register 'RC_RadioOnHear'
	:Write(net.WriteBool)
	:Read(net.ReadBool)
	:SetPlayer()
	
function rp.AddToRadioChannel(can_speak, can_hear)
	if not can_speak or #can_speak == 0 then return end
	can_hear = table.Copy(can_hear or {})
	
	local speakers = table.Copy(can_speak)
	table.Add(can_hear, can_speak)
	
	for i = 1, #can_hear do
		for j = 1, #speakers do
			rp.RadioSpeakers[speakers[j]] = true

			rp.RadioChanels[can_hear[i]] = rp.RadioChanels[can_hear[i]] or {}
			rp.RadioChanels[can_hear[i]][speakers[j]] = true
		end
	end
end
