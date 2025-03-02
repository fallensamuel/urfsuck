
local on 	= Sound('npc/overwatch/radiovoice/on1.wav')
local off 	= Sound('npc/overwatch/radiovoice/off4.wav')

hook('PlayerStartVoice', function(ply)
	if IsValid(ply) and ply:IsCombineOrDisguised() then
		ply:EmitSound(on, 75)
	end
end)

hook('PlayerEndVoice', function(ply)
	if IsValid(ply) and ply:IsCombineOrDisguised() then
		ply:EmitSound(off, 75)
	end
end)

hook('ChatRoomMessage', function(chat, pl, text)
	if !isstring(pl) and IsValid(pl) and pl:IsCombineOrDisguised() then
		if chat == CHAT_LOCAL then
			pl:EmitSound(on, 75)	
		end
	end
end)