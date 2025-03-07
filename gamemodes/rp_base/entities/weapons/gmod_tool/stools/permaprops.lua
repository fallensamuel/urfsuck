-- "gamemodes\\rp_base\\entities\\weapons\\gmod_tool\\stools\\permaprops.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
/*
	PermaProps
	Created by Entoros, June 2010
	Facepunch: http://www.facepunch.com/member.php?u=180808
	Modified By Malboro 28 / 12 / 2012
	
	Ideas:
		Make permaprops cleanup-able
		
	Errors:
		Errors on die

	Remake:
		By Malboro the 28/12/2012
*/

TOOL.Category		=	"Staff"
TOOL.Name			=	"PermaProps"
TOOL.Command		=	nil
TOOL.ConfigName		=	""

if CLIENT then
	language.Add("Tool.permaprops.name", "PermaProps")
	language.Add("Tool.permaprops.desc", translates.Get("Создание пермапропа из пропа") or "Создание пермапропа из пропа")
	language.Add("Tool.permaprops.0", translates.Get("ЛКМ - создать, ПКМ - удалить, R - обновить") or "ЛКМ - создать, ПКМ - удалить, R - обновить")

	surface.CreateFont("PermaPropsToolScreenFont", { font = "Arial", size = 40, weight = 1000, antialias = true, additive = false })
	surface.CreateFont("PermaPropsToolScreenSubFont", { font = "Arial", size = 30, weight = 1000, antialias = true, additive = false })
end

function TOOL:LeftClick(trace)

	if CLIENT then return end

	local ent = trace.Entity
	local ply = self:GetOwner()

	if not PermaProps then ply:ChatPrint( "ERROR: Lib not found" ) return end
	
	if ULib and ULib.ucl then

		print(ULib.ucl.query( ply, "permaprops_save" ))

		if not ULib.ucl.query( ply, "permaprops_save" ) then return false end

	else

		if ply:HasFlag("e") then
		elseif PermaProps.IsAdmin(ply) and PermaProps.Permissions["ToolSaveA"] then
		elseif PermaProps.IsSuperAdmin(ply) and PermaProps.Permissions["ToolSaveSA"] then
		else
			return false
		end

	end

	if not ent:IsValid() then ply:ChatPrint( "That is not a valid entity !" ) return end
	if ent:IsPlayer() then ply:ChatPrint( "That is a player !" ) return end
	if ent.PermaProps then ply:ChatPrint( "That entity is already permanent !" ) return end

	local content = PermaProps.PPGetEntTable(ent)
	if not content then return end

	local max = tonumber(sql.QueryValue("SELECT MAX(id) FROM permaprops;"))
	if not max then max = 1 else max = max + 1 end

	local new_ent = PermaProps.PPEntityFromTable(content, max)
	if !new_ent or !new_ent:IsValid() then return end

	PermaProps.SparksEffect( ent )

	PermaProps.SQL.Query("INSERT INTO permaprops (id, map, content) VALUES(NULL, ".. sql.SQLStr(rp.cfg.ServerMapId) ..", ".. sql.SQLStr(util.TableToJSON(content)) ..");")
	ply:ChatPrint("You saved " .. ent:GetClass() .. " with model ".. ent:GetModel() .. " to the database.")

	ent:Remove()

	return true

end

function TOOL:RightClick(trace)

	if CLIENT then return end

	if (not trace.Entity:IsValid()) then RunConsoleCommand("pp_cfg_open") return false end

	local ent = trace.Entity
	local ply = self:GetOwner()

	if not PermaProps then ply:ChatPrint( "ERROR: Lib not found" ) return end

	if ULib and ULib.ucl then

		if not ULib.ucl.query( ply, "permaprops_delete" ) then return false end

	else

		if ply:HasFlag("e") then
		elseif PermaProps.IsAdmin(ply) and PermaProps.Permissions["ToolDelA"] then
		elseif PermaProps.IsSuperAdmin(ply) and PermaProps.Permissions["ToolDelSA"] then
		else
			return false
		end

	end

	if not ent:IsValid() then ply:ChatPrint( "That is not a valid entity !" ) return end
	if ent:IsPlayer() then ply:ChatPrint( "That is a player !" ) return end
	if not ent.PermaProps then ply:ChatPrint( "That is not a PermaProp !" ) return end
	if not ent.PermaProps_ID then ply:ChatPrint( "ERROR: ID not found" ) return end

	PermaProps.SQL.Query("DELETE FROM permaprops WHERE id = ".. ent.PermaProps_ID ..";")

	ply:ChatPrint("You erased " .. ent:GetClass() .. " with a model of " .. ent:GetModel() .. " from the database.")

	ent:Remove()

	return true

end

function TOOL:Reload(trace)

	if CLIENT then return end

	if not PermaProps then ply:ChatPrint( "ERROR: Lib not found" ) return end

	if (not trace.Entity:IsValid()) then
		local ply = self:GetOwner();
		
		if (not ply:IsRoot()) and ((ply.PermaPropsLastReload or 0) > SysTime()) then
			ply:ChatPrint( "Please wait before reloading PermaProps!" );
			return false
		end

		ply.PermaPropsLastReload = SysTime() + 300;
		ply:ChatPrint( "You have reload all PermaProps!" );
		PermaProps.ReloadPermaProps();

		return false
	end

	if trace.Entity.PermaProps then

		local ent = trace.Entity
		local ply = self:GetOwner()

		if ULib and ULib.ucl then

			if not ULib.ucl.query( ply, "permaprops_update" ) then return false end

		else

			if ply:HasFlag("e") then
			elseif  PermaProps.IsAdmin(ply) and PermaProps.Permissions["ToolUpdtA"] then
			elseif PermaProps.IsSuperAdmin(ply) and PermaProps.Permissions["ToolUpdtSA"] then
			else
				return false
			end

		end

		if ent:IsPlayer() then ply:ChatPrint( "That is a player !" ) return end
		
		local content = PermaProps.PPGetEntTable(ent)
		if not content then return end

		PermaProps.SQL.Query("UPDATE permaprops set content = ".. sql.SQLStr(util.TableToJSON(content)) .." WHERE id = ".. ent.PermaProps_ID .." AND map = ".. sql.SQLStr(rp.cfg.ServerMapId) .. ";")

		local new_ent = PermaProps.PPEntityFromTable(content, ent.PermaProps_ID)
		if !new_ent or !new_ent:IsValid() then return end

		PermaProps.SparksEffect( ent )

		ply:ChatPrint("You updated the " .. ent:GetClass() .. " in the database.")

		ent:Remove()


	else

		return false

	end

	return true

end

function TOOL.BuildCPanel(panel)

	panel:AddControl("Header",{Text = "PermaProps", Description = translates.Get("Пермапропы\n\nСохраняет пропы даже после рестарта\n") or "Пермапропы\n\nСохраняет пропы даже после рестарта\n"})
	panel:AddControl("Button",{Label = translates.Get("Открыть меню конфигураций") or "Открыть меню конфигураций", Command = "pp_cfg_open"})

end

function TOOL:DrawToolScreen(width, height)

	if SERVER then return end

	surface.SetDrawColor(17, 148, 240, 255)
	surface.DrawRect(0, 0, 256, 256)

	surface.SetFont("PermaPropsToolScreenFont")
	local w, h = surface.GetTextSize(" ")
	surface.SetFont("PermaPropsToolScreenSubFont")
	local w2, h2 = surface.GetTextSize(" ")

	draw.SimpleText("PermaProps", "PermaPropsToolScreenFont", 128, 100, Color(224, 224, 224, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, Color(17, 148, 240, 255), 4)
	draw.SimpleText("By Malboro", "PermaPropsToolScreenSubFont", 128, 128 + (h + h2) / 2 - 4, Color(224, 224, 224, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, Color(17, 148, 240, 255), 4)

end