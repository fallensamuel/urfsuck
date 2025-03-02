local ACTION = table.Copy( EmoteActions:GetRawAction( "__base" ) );

ACTION.Name = "Показать";
ACTION.Desc = "";
ACTION.Category = "Эмоции";

ACTION.ChatAliases = {
	"front", "behind", "left", "right", "впереди", "сзади", "слева", "справа"
}

ACTION.Sequences = {
	"buttonfront",
	"buttonleft",
	"buttonright",
	"luggagewarn"
}

ACTION.SequenceCheck = {
	"buttonfront",
	"buttonleft",
	"buttonright",
	"luggagewarn"
}

if SERVER then
	function ACTION:onStart( ply, args )
		ply:SetEmoteActionState( ACTION_STATE_STARTING );

		local anim = "buttonfront";

		if args == "left" or args == "слева" then
			anim = "buttonleft";
		elseif args == "right" or args == "справа" then
			anim = "buttonright";
		elseif args == "behind" or args == "сзади" then
			anim = "luggagewarn";
		end 

		ply:SetEmoteActionSequences( anim, 0, function()
			ply:DropEmoteAction();
		end );
	end

	function ACTION:onEnd( ply )
		ply:SetEmoteActionState( ACTION_STATE_ENDING );
		ply:DropEmoteAction();
	end
end

EmoteActions:RegisterAction( "point", ACTION );