rp.util = {}

function rp.util.include(fileName, state)
	if (!fileName) then
		error("No file name specified for including.")
	end

	-- Only include server-side if we're on the server.
	if ((state == "server" or fileName:find("sv_")) and SERVER) then
		include(fileName)
	-- Shared is included by both server and client.
	elseif (state == "shared" or fileName:find("sh_")) then
		if (SERVER) then
			-- Send the file to the client if shared so they can run it.
			AddCSLuaFile(fileName)
		end

		include(fileName)
	-- File is sent to client, included on client.
	elseif (state == "client" or fileName:find("cl_")) then
		if (SERVER) then
			AddCSLuaFile(fileName)
		else
			include(fileName)
		end
	end
end

function rp.util.drawText(text, x, y, color, alignX, alignY, font, alpha)
	color = color or Color(255,255,255)

	return draw.TextShadow({
		text = text,
		font = font or "nutGenericFont",
		pos = {x, y},
		color = color,
		xalign = alignX or 0,
		yalign = alignY or 0
	}, 1, alpha or (color.a * 0.575))
end