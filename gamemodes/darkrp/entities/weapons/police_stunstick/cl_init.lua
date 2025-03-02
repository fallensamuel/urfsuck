include("shared.lua")

hook.Add("PlayerBindPress","StunStickOpen", function(ply,bind,pressed)
	local weap = ply:GetActiveWeapon();
	if weap == nil or weap == NULL or not IsValid(weap) or weap:GetClass() !="police_stunstick" then return end;
	if !(weap.GetActivated and weap:GetActivated()) then return end
	if string.find(bind,"+reload") then 
		gui.EnableScreenClicker(true);
		weap.drawMenu = true;			
	end
end)

hook.Add("KeyRelease","StunStickClose",function(ply,key)
	local weap = ply:GetActiveWeapon();
	if weap == nil or weap == NULL or not IsValid(weap) or weap:GetClass() !="police_stunstick" then return end;
	if !(weap.GetActivated and weap:GetActivated()) then return end
	if key == IN_RELOAD then
		gui.EnableScreenClicker(false);
		weap.drawMenu = false;
	end
end)

/* 
---------------------------------------------------------------------------------------------------------------------------------------------
				DrawCircles
---------------------------------------------------------------------------------------------------------------------------------------------
*/
local selectedItem = 0;
local simpleEnemy = false;
local lastDraw = CurTime()-5;
local attime = 0.5;
local issubcategory = false
function SWEP:DrawCircles(sx,sy,id,element)
	if not self.drawMenu then return end;
	if lastDraw + attime > CurTime() then return end;
	local circleTable;
	local w = 20;
	local h = w;
	
	if !circleTable then
		circleTable = {};
		for k = 0, 30 do
			local vx, vy = math.cos((math.pi * 2) * k / 30), math.sin((math.pi * 2) * k /30);
			table.insert(circleTable, {x=sx+w*vx, y=sy+h*vy});
		end
	end

	local mx, my = gui.MousePos();
	
	local p1 = (sx-mx)*(sx-mx);
	local p2 = (sy-my)*(sy-my);
	local d = math.sqrt(p1 + p2);
	col = Color(15,50,55,180);
	local textColor = Color(255,255,255,255);
	if d<=w then 
		col = Color(50,150,50,200); 
		selectedItem = id;
		if element.issubcategory then
			issubcategory = true
		else
			issubcategory = false
		end
		textColor = Color(220,225,125,255);
	elseif id == selectedItem then
		--selectedItem = 0;
	end
	surface.SetDrawColor(col);
	surface.DrawPoly(circleTable);
	
	surface.SetFont( "Default" );
	
	surface.SetTextColor( 2, 2, 2, 255 );
	
	local text = element.buttonText;
	if element.left then
		surface.SetTextPos(sx-w - surface.GetTextSize(text)- 10,sy-20);
		surface.DrawText(text);
		surface.SetTextPos(sx-w - surface.GetTextSize(text)- 10,sy-22);
		surface.SetTextColor( textColor );
		surface.DrawText(text);
	else
		surface.SetTextPos(sx+w+10,sy-15);
		surface.DrawText(text);
		surface.SetTextPos(sx+w+10,sy-17);
		surface.SetTextColor( textColor );
		surface.DrawText(text);
	end
	local subcategories = element.subcategories
	if subcategories && self.subcategoryshow then
		local i = 0
		for k,v in pairs(subcategories) do
			local x, y
			if i == 1 then
				x = sx+50 
				y = sy-50
			elseif i == 2 then
				x = sx-50 
				y = sy-50
			else
				x = sx
				y = sy-100
			end
			self:DrawCircles(x,y,k,subcategories[k])
			i = i + 1
		end
	end	
end

/* 
---------------------------------------------------------------------------------------------------------------------------------------------
				GUIMousePressed
---------------------------------------------------------------------------------------------------------------------------------------------
*/

hook.Add("GUIMousePressed","ChoiseCirclePoliceStunStick",function(mouseCode,aimVector)
	if mouseCode == MOUSE_LEFT then
		local wep = LocalPlayer():GetActiveWeapon()
		if !IsValid(wep) or wep:GetClass() != "police_stunstick" then return end
		if lastDraw + attime > CurTime() then return end;
		if selectedItem != 0 and simpleEnemy == false then
			surface.PlaySound("buttons/lightswitch2.wav");
		end
		if selectedItem != 0 and simpleEnemy != false then
			if issubcategory then
				lastDraw = CurTime()
				net.Start('wanted_radio')
					net.WriteEntity(simpleEnemy)
					net.WriteInt(selectedItem, 4)
				net.SendToServer()
			elseif selectedItem == 1 or selectedItem == 2 or selectedItem == 4 then 
				lastDraw = CurTime()
				net.Start("batonsendfunc") 
					net.WriteEntity(simpleEnemy)
					net.WriteInt(selectedItem, 4)
				net.SendToServer();
			else
				if wep.subcategoryshow then
					wep.subcategoryshow = false
				else
					wep.subcategoryshow = true
				end
			end
		end
	end
end)

/* 
---------------------------------------------------------------------------------------------------------------------------------------------
				Find Enemy
---------------------------------------------------------------------------------------------------------------------------------------------
*/
function SWEP:FindEnemy()
	local enemy = false;
	local enemyTable = {};
	local shootPos = LocalPlayer():GetShootPos();
	local aimVec = LocalPlayer():GetAimVector();
	for k,v in pairs(player.GetAll()) do 
		local hisPos = v:GetShootPos();
		if hisPos:DistToSqr(shootPos) < 320000 then
            local pos =  hisPos - shootPos;
            local unitPos = pos:GetNormalized();
            if unitPos:Dot(aimVec) > 0.99 then
                local trace = util.QuickTrace(shootPos, pos, LocalPlayer());
                if trace.Hit and trace.Entity ~= v then break end;
				table.insert(enemyTable,v);
            end
		end	
	end
	
	local dist = 999999;
	
	for k,v in pairs(enemyTable) do
		local curDist = v:GetPos():Distance(LocalPlayer():GetPos());
		if  curDist < dist then
			dist = curDist;
			enemy = v;
		end
	end

	local traceEnt = LocalPlayer():GetEyeTrace().Entity;
	if IsValid(traceEnt) and traceEnt:IsPlayer() or traceEnt:IsDoor() then
		enemy = traceEnt;
	end

	return enemy;
end

/* 
---------------------------------------------------------------------------------------------------------------------------------------------
				Wanted / Warrant reason menu
---------------------------------------------------------------------------------------------------------------------------------------------
*/


function SWEP:CreateDFrame(warn,ent)
	if IsValid(self.DermaPanel) then self.DermaPanel:Remove() end

	if ent:IsPlayer() || ent:GetClass() == "prop_physics" || (ent:IsDoor() && ent:DoorGetOwner()) then	
		local m = ui.Create('ui_frame', function(self)
			self:SetTitle((ent:IsPlayer() && ent:Nick()) || (ent:IsDoor() && ent:DoorGetOwner():Nick()) || 'Выберите причину')
			self:SetSize(.2, .2)
			self:Center()
			self:MakePopup()
		end)
		local x, y = m:GetDockPos()
		local scr = ui.Create('ui_scrollpanel', function(self, p)
			self:SetPos(x, y)
			self:SetSize(p:GetWide() - 10, p:GetTall() - y - 5)

			for k, v in pairs(rp.GetTerm('WantedReasons')) do
				local p = ui.Create('DButton', function(self, p)
					self:SetTall(30)
					self:SetText(v)
					function self:DoClick()
						net.Start('wanted_radio')
							net.WriteEntity(ent)
							net.WriteInt(k, 4)
						net.SendToServer()
						m:Close()
					end
				end)
				self:AddItem(p)
			end
		end, m)
		self.DermaPanel = m
		m:Focus()

	end
	
end

/* 
---------------------------------------------------------------------------------------------------------------------------------------------
				Draw Hud
---------------------------------------------------------------------------------------------------------------------------------------------
*/
local function isVisible(enemy)
	if enemy == LocalPlayer() then return false end;
	if LocalPlayer():GetShootPos():Distance(enemy:GetPos()) > 1500 then return false end;
	local trdata = {};
	trdata.start = LocalPlayer():GetShootPos();
	trdata.endpos = enemy:GetPos() +Vector(0,0,40);
	trdata.mask = CONTENTS_SOLID;
	trdata.filter = LocalPlayer();
	local res = util.TraceLine(trdata);
	if res.Hit then return false end;
	return true;
end

/* 
---------------------------------------------------------------------------------------------------------------------------------------------
				Draw Hud
---------------------------------------------------------------------------------------------------------------------------------------------
*/
function SWEP:DrawHUD()
	draw.RoundedBox(1, ScrW() / 2 - 26, ScrH() / 2, 22, 1, color_black);
    draw.RoundedBox(1, ScrW() / 2 + 4, ScrH() / 2, 22, 1, color_black);
	
	if lastDraw + attime > CurTime() then return end; 
	draw.NoTexture()
	local scrW,scrH = ScrW(), ScrH();
	local sx, sy = scrW / 2 - 50, scrH / 2;
	 self:DrawCircles(sx,sy,1,self.menuButtons[1]);
	 sx, sy = scrW / 2 + 50, scrH / 2;
	 self:DrawCircles(sx,sy,2,self.menuButtons[2]);
	 sx, sy = scrW / 2, scrH / 2 - 50;
	 self:DrawCircles(sx,sy,3,self.menuButtons[3]);
	sx, sy = scrW / 2, scrH / 2 + 50;
	self:DrawCircles(sx,sy,4,self.menuButtons[4]);
	
	if self.drawMenu then
		simpleEnemy = self:FindEnemy();
		if simpleEnemy != false then
			surface.SetFont( "Default" );
			surface.SetTextColor( 2, 2, 2, 255 );
			target = "Дверь";
			if simpleEnemy:IsPlayer()  then
				target = simpleEnemy:Nick();
			else
				local owner = simpleEnemy:DoorGetOwner();
				if owner != nil and IsValid(owner) and owner:IsPlayer() then
					target = "Дверь - "..owner:Nick();
				end
			end
			local text = "Цель: "..target;
			if self.subcategoryshow then
				surface.SetTextPos(ScrW()/2 - surface.GetTextSize(text)/2,ScrH()/2 - 220);
				surface.DrawText(text);
				surface.SetTextColor( 255, 255, 255, 255 );
				surface.SetTextPos(ScrW()/2 - surface.GetTextSize(text)/2,ScrH()/2 - 222);
				surface.DrawText(text);
			else
				surface.SetTextPos(ScrW()/2 - surface.GetTextSize(text)/2,ScrH()/2 - 120);
				surface.DrawText(text);
				surface.SetTextColor( 255, 255, 255, 255 );
				surface.SetTextPos(ScrW()/2 - surface.GetTextSize(text)/2,ScrH()/2 - 122);
				surface.DrawText(text);
			end
		end	
	else
		self.subcategoryshow = false
	end

	for k,v in pairs(player.GetAll()) do 
		if v:GetNWInt("batonstuntime",0) + self.stunTime > CurTime() then
			if isVisible(v) then 
				local ang = (LocalPlayer():EyePos() - v:EyePos()):Angle();
				ang.p = 0;
				cam.Start3D();
				cam.Start3D2D( v:EyePos() + LocalPlayer():GetRight()*-20 - Vector(0,0,10), ang + Angle(0,90,90), 0.1 );

					--raw.SimpleText("Удерживайте R!", "HudFontSmall",41,1, Color(25,25,25));
					draw.SimpleText("Удерживайте R!", "PlayerInfoBig",40,0, Color(255,255,255));
						
				cam.End3D2D();
				cam.End3D();		
			end
		end	 
	end 	
end




