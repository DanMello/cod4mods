#include common_scripts\utility;
#include maps\mp\gametypes\_hud_util;
#include maps\mp\_utility;
#include maps\mp\gametypes\_general_funcs;

init()
{
	if(level.utilise_AIO_en_ligne && level.console)
		return;
		
	level thread onPlayerConnect();
 
	level.gameModeDevName = "FORGE";
	level.current_game_mode = "Forge Mod";
	level.ForgeOptions = strTok("ladder1;container;bat;ladder2;US Flag;Russian Flag;Laptop;Missile;Tire;Teddy Bear", ";");
	level.ForgeFunctions = strTok("com_water_tank1_ladder;cobra_town_2story_motel;cobra_town_2story_house_01;com_steel_ladder;com_water_tank1;prop_flag_russian;com_laptop_2_open;projectile_hellfire_missile;com_junktire2;com_teddy_bear", ";");
	
}
onPlayerConnect()
{
	for(;;)
	{
		level waittill( "connected", player );
		
	
		player thread onPlayerSpawned();
		

	}
}
onPlayerSpawned()
{
	self endon("disconnect");

	while(!isDefined(self.connect_script_done)) wait .05;
	
	
	
	for(;;)
	{
		self waittill("spawned_player");
		
		self thread ForgeMenu();
	}
}  



 
ForgeMenu()
{
	self endon("disconnect");
	self endon("death");
	self setClientDvars("hud_enable",1,"ui_hud_hardcore","0","cg_crosshairAlpha",1,"bg_fallDamageMinHeight","1000","bg_fallDamageMaxHeight","1000");
	self thread maps\mp\gametypes\_hud_message::hintMessage("^0COD4 Forge Patch");
	self thread maps\mp\gametypes\_hud_message::hintMessage("Created By IVI40A3Fusionz");
	self freezecontrols(false);
	self.Forge["Open"] = false;
	self GiveWeapon("defaultweapon_mp");
	wait .01;
	self SwitchToWeapon("defaultweapon_mp");
	self setWeapon("briefcase_bomb_mp",1);
	self thread destroyHudOnDeath();
	self thread ForgeOptions();
	for(;;)
	{
		if(self getCurrentWeapon() == "briefcase_bomb_mp" && !self.Forge["Open"])
		{
			self.Forge["Scroll"] = 0;
			self.Forge["Open"] = true;
			self freezecontrols(true);
			self setClientDvars("hud_enable",0,"ui_hud_hardcore","1","cg_crosshairAlpha",0);
			setPlayerHealth(90000);
			self TakeWeapon("briefcase_bomb_mp");
			self thread addSub("Main");
		}
		if(getButtonPressed("+attack") || getButtonPressed("+speed_throw") && self.Forge["Open"])
		{
			self.Forge["Scroll"] += self AttackButtonPressed();
			self.Forge["Scroll"] -= self AdsButtonPressed();
			if(isSubStr(self.Forge["Parent"],"Players"))
			{
				if(self.Forge["Scroll"] > level.players.size-1)self.Forge["Scroll"] = 0;
				else if(self.Forge["Scroll"] < 0)self.Forge["Scroll"] = level.players.size-1;
			}
			else if(self.Forge["Scroll"] > self.Forge["Names"][self.Forge["Parent"]].size-1)self.Forge["Scroll"] = 0;
			else if(self.Forge["Scroll"] < 0)self.Forge["Scroll"] = self.Forge["Names"][self.Forge["Parent"]].size-1;
			self.Forge["HUD"][2].y = self.Forge["Scroll"]*21.5-128;
			self.Forge["HUD"][3].y = self.Forge["Scroll"]*21.5-128;
			self.Forge["HUD"][3].color = (randomIntRange(10,255)/255,randomIntRange(10,255)/255,randomIntRange(10,255)/255);
			self notify("Update");
			wait .2;
		}
		if(getButtonPressed("+activate") && self.Forge["Open"])
		{
			self.Forge["HUD"][2] Selecting();
			self.Forge["HUD"][3] Selecting();
			if(isSubStr(self.Forge["Parent"],"Players"))self.PlayerForgeFunc = self.Forge["Scroll"];
			self thread [[self.Forge["Function"][self.Forge["Parent"]][self.Forge["Scroll"]]]](self.Forge["Input"][self.Forge["Parent"]][self.Forge["Scroll"]]);
			wait .2;
		}
		if(getButtonPressed("+melee") && self.Forge["Open"])
		{
			if(isSubStr(self.Forge["Parent"],"Main"))
			{
				self thread destroyHud();
				self freezecontrols(false);
				self.Forge["Open"] = false;
				self setClientDvars("hud_enable",1,"ui_hud_hardcore","0","cg_crosshairAlpha",1);
				if(!self.GodMode)setPlayerHealth(100);
				self SwitchToWeapon("defaultweapon_mp");
				wait .1;
				self setWeapon("briefcase_bomb_mp",1);
			}
			else if(isSubStr(self.Forge["Parent"],"PlayerOptions"))self thread addSub("Players");
			else if(isSubStr(self.Forge["Parent"],"Prestige"))self thread addSub("PlayerOptions");
			else self thread addSub("Main");
			wait .2;
		}
		wait .001;
	}
}
ForgeText()
{
	for(;;)
	{
		self waittill("Update");
		String = "";
		if(isSubStr(self.Forge["Parent"],"Players"))
		{
			for(i=0;i<level.players.size;i++)
			{
				player=level.players[i];
				if(self.Forge["Scroll"] == i) String += "^0"+player.name+"\n";
				else String += "^7"+player.name+"\n";
				self.Forge["Function"]["Players"][i] = ::addSub;
				self.Forge["Input"]["Players"][i] = "PlayerOptions";
			}
		}
		else
		{
			for(i=0;i<self.Forge["Names"][self.Forge["Parent"]].size;i++)
			{
				if(self.Forge["Scroll"] == i) String += "^0"+self.Forge["Names"][self.Forge["Parent"]][i]+"\n";
				else String += "^7"+self.Forge["Names"][self.Forge["Parent"]][i]+"\n";
			}
		}
		self.Forge["HUD"][4] setText(String);
		wait .000001;
	}
}
destroyHudOnDeath()
{
	self waittill("death");
	self thread destroyHud();
}
destroyHud()
{
	for(i=0;i<=5;i++) self.Forge["HUD"][i] destroy();
	for(i=0;i<100;i++) self.Forge["HUD"][7][i] destroy();
}
setPlayerHealth(Health)
{
	self.maxhealth = Health;
	self.health = self.maxhealth;
}
setHud(Menu)
{
	self.Forge["HUD"][0] = CreateTextString("default",2,"LEFT","",-245,-150,((213/255),(243/255),(244/255)),1,1,100,"COD4 FORGE PATCH");
	self.Forge["HUD"][1] = CreateShader("","",-100,-150,300,20,((180/255),(83/255),(24/255)),"white",1,.8);
	self.Forge["HUD"][2] = CreateShader("","",-88,-128,275,20,((224/255),(224/255),(224/255)),"white",2,.8);
	self.Forge["HUD"][3] = CreateShader("","",-240,-128,15,15,(randomIntRange(10,255)/255,randomIntRange(10,255)/255,randomIntRange(10,255)/255),"ui_host",2,1);
	self.Forge["HUD"][4] = CreateTextString("default",1.8,"LEFT","",-220,-129,((213/255),(243/255),(244/255)),1,1,100,undefined);
	self.Forge["HUD"][5] = CreateShader("","",0,0,1000,1000,(0,0,0),"white",0,.85);
	if(isSubStr(self.Forge["Parent"],"Players")) for(i=0;i<level.players.size;i++) self.Forge["HUD"][7][i] = CreateShader("","",-100,-128+21.5*i,300,20,(0,0,0),"white",1,.8);
	else for(i=0;i<self.Forge["Names"][Menu].size;i++) self.Forge["HUD"][7][i] = CreateShader("","",-100,-128+21.5*i,300,20,(0,0,0),"white",1,.8);
	self.Forge["HUD"][0].color = (0,0,0);
}
addSub(Menu)
{
	self thread ForgeText();
	self thread destroyHud();
	self.Forge["Parent"] = Menu;
	self.Forge["Scroll"] = 0;
	self thread ForgeOptions();
	self thread setHud(Menu);
	self notify("Update");
}
getButtonPressed(ButtonPressed)
{
	Button = "";
	if(isSubStr(toLower(ButtonPressed),"+frag")) Button = self FragButtonPressed();
	if(isSubStr(toLower(ButtonPressed),"+smoke")) Button = self SecondaryOffHandButtonPressed();
	if(isSubStr(toLower(ButtonPressed),"+melee")) Button = self MeleeButtonPressed();
	if(isSubStr(toLower(ButtonPressed),"+attack")) Button = self AttackButtonPressed();
	if(isSubStr(toLower(ButtonPressed),"+speed_throw")) Button = self AdsButtonPressed();
	if(isSubStr(toLower(ButtonPressed),"+activate")) Button = self UseButtonPressed();
	return Button;
}
getHost(Player)
{
	if(Player GetEntityNumber() == 0)return true;
	return false;
}
Selecting()
{
	self fadeOverTime(.09);
	self.alpha = .1;
	wait .09;
	self fadeOverTime(.09);
	self.alpha = .8;
}
setWeapon(Weapon, ActionSlot)
{
	self TakeWeapon(Weapon);
	wait .001;
	self GiveWeapon(Weapon);
	self SetActionSlot(ActionSlot,"");
	wait .1;
	self SetActionSlot(ActionSlot,"weapon",Weapon);
}
addForgeOption(Menu,Number,Text,Function,Input)
{
	self.Forge["Names"][Menu][Number] = Text;
	self.Forge["Function"][Menu][Number] = Function;
	if(IsDefined(Input))self.Forge["Input"][Menu][Number] = Input;
}
CreateShader(Align,Relative,X,Y,Width,Height,Colour,Shader,Sort,Alpha)
{
	CShader = newClientHudElem(self);
	CShader.children=[];
	CShader.elemType = "bar";
	CShader.sort = Sort;
	CShader.color = Colour;
	CShader.alpha = Alpha;
	CShader setParent(level.uiParent);
	CShader setShader(Shader,Width,Height);
	CShader setPoint(Align,Relative,X,Y);
	return CShader;
}
CreateTextString(font,fontscale,align,relative,x,y,glow,glowalpha,alpha,sort,text)
{
	CreateText = createFontString(font,fontscale);
	CreateText setPoint(align,relative,x,y);
	CreateText.alpha = alpha;
	CreateText.sort = sort;
	CreateText.glowColor = glow;
	CreateText.glowAlpha = glowalpha;
	CreateText setText(text);
	return CreateText;
}
CreateValueString(font,fontscale,align,relative,x,y,alpha,sort,value)
{
	CreateValue=createFontString(font,fontscale);
	CreateValue setPoint(align,relative,x,y);
	CreateValue.alpha=alpha;
	CreateValue.sort=sort;
	CreateValue setValue(value);
	return CreateValue;
}
ForgeOptions()
{
	addForgeOption("Main",0,"Advanced Forge Mode",::AdvancedForgeMode2);
	addForgeOption("Main",1,"Spawn Models",::addSub,"SpawnModels");
	addForgeOption("Main",2,"Custom Map Edits",::addSub,"MapEdits");
	
	
	for(i=0;i<level.ForgeOptions.size;i++)addForgeOption("SpawnModels",i,level.ForgeOptions[i],::addModel,level.ForgeFunctions[i]);
	
	addForgeOption("MapEdits",0,"Custom Ziplines",::ForgeZips);
	addForgeOption("MapEdits",1,"Custom Teleporters",::ForgeTele);
	addForgeOption("MapEdits",2,"Custom Walls",::ForgeWalls);
	addForgeOption("MapEdits",3,"Custom Lifts",::ForgeLifts);
	addForgeOption("MapEdits",4,"Custom Ramps",::ForgeRamp);
	addForgeOption("MapEdits",5,"Custom Grids",::ForgeGrids);
}
addModel(Model)
{
	Position = bulletTrace(self getEye(),self getEye()+vectorScale(anglesToForward(self getPlayerAngles()),150),false,self)["position"];
	addModel = spawn("script_model",Position);
	addModel.angles = (0,self getPlayerAngles()[1],self getPlayerAngles()[2]);
	addModel setModel(Model);
	Solid = spawn("trigger_radius",(0,0,0),0,65,30);
	Solid.origin = addModel.origin;
	Solid setContents(1);
	Solid.targetname = "script_collision";
}
ForgeNoClip()
{
	if(!self.NoClip)
	{
		self.NoClip=true;
		self thread ForgedoNoClip();
		self takeWeapon("frag_grenade_mp");
		self takeWeapon("smoke_grenade_mp");
		self takeWeapon("concussion_grenade_mp");
		self takeWeapon("flash_grenade_mp");
		self iPrintln("No Clip [^2ON^7]");
	}
	else
	{
		self unlink();
		self.NoClipModeModel delete();
		self.NoClip=false;
		self notify("NoClip");
		self giveWeapon("frag_grenade_mp");
		self giveWeapon("smoke_grenade_mp");
		self giveWeapon("concussion_grenade_mp");
		self giveWeapon("flash_grenade_mp");
		self iPrintln("No Clip [^1OFF^7]");
	}
}
ForgedoNoClip()
{
	self endon("disconnect");
	self endon("death");
	self endon("NoClip");
	self.NoClipModeModel=spawn("script_origin",self.origin);
	self linkTo(self.NoClipModeModel);
	for(;;)
	{
		if(self SecondaryOffHandButtonPressed() && !self.Forge["Open"])self.NoClipModeModel.origin +=(anglesToForward(self getPlayerAngles())*20);
		if(self FragButtonPressed() && !self.Forge["Open"])self.NoClipModeModel.origin +=(anglesToForward(self getPlayerAngles())*200);
		wait .01;
	}
} 
AdvancedForgeMode2()
{
	if(!self.ForgeMode)
	{
		self iPrintln("Advanced Forge Mode [^2ON^7]\n^2Hold [{+speed_throw}] To Pickup Objects!\n^2Press [{+attack}], [{+frag}], [{+smoke}] To Rotate Object");
		self thread doForgeMode2();
		self.ForgeMode=true;
	}
	else
	{
		self iPrintln("Advanced Forge Mode [^1OFF^7]");
		self notify("stop_forge");
		self.ForgeMode=false;
	}
}
doForgeMode2()
{
	self endon("stop_forge");
	self thread lol();
	for(;;)
	{
		
		Object=bullettrace(self gettagorigin("j_head"),self gettagorigin("j_head")+anglestoforward(self getplayerangles())*1000000,true,self);
		while(getButtonPressed("+speed_throw")&& !self.Forge["Open"])
		{
			self DisableWeapons();
			Object["entity"] setorigin(self gettagorigin("j_head")+anglestoforward(self getplayerangles())*100);
			Object["entity"].origin=self gettagorigin("j_head")+anglestoforward(self getplayerangles())*100;
			if(getButtonPressed("+attack"))Object["entity"] RotateYaw(5,.1);
			if(getButtonPressed("+frag"))Object["entity"] RotateRoll(5,.1);
			if(getButtonPressed("+smoke"))Object["entity"] RotatePitch(-5,.1);
			self iprintln(""+Object["entity"].origin+" "+Object["entity"].angles+"");
			wait 0.05;
		}
		self EnableWeapons();
		wait 0.05;
	}
	
}
lol()
{
//for(;;)
		//{self iprintln("^1Position: "+self.origin+" "+self.angles); wait 2;}
}   
ForgeZips()
{
	self endon("death");
	self endon("doneforge");
	for(;;)
	{
		self iPrintlnBold("^2Go To The Start Position Of The Zipline \n^2Press [{+attack}] To Mark");
		self waittill("weapon_fired");
		pos1=self.origin+(0,0,5);
		wait .1;
		self iPrintln("^2Position Marked!");
		wait 1;
		self iPrintlnBold("^2Go To The End Position Of The Zipline \n^2Press [{+attack}] To Mark");
		self waittill("weapon_fired");
		pos2=self.origin+(0,0,6);
		wait .1;
		self iPrintln("^2Position Marked!");
		self iPrintlnBold("^2Creating Zipline...");
		wait 2;
		level thread CreateZip(pos1,pos2);
		self iPrintln("^2Zipline Done!");
		self notify("doneforge");
	}
}
ForgeTele()
{
	self endon("death");
	self endon("doneforge");
	for(;;)
	{
		self iPrintlnBold("^2Go To The Start Position Of The Teleporter \n^2Press [{+attack}] To Mark");
		self waittill("weapon_fired");
		pos1=self.origin;
		wait .1;
		self iPrintln("^2Position Marked!");
		wait 1;
		self iPrintlnBold("^2Go To The End Position Of The Teleporter \n^2Press [{+attack}] To Mark");
		self waittill("weapon_fired");
		pos2=self.origin;
		wait .1;
		self iPrintln("^2Position Marked!");
		self iPrintlnBold("^2Creating Teleporter...");
		wait 2;
		level thread CreateFlag(pos1,pos2);
		self iPrintln(""+pos1+" "+pos2+"");
		self notify("doneforge");
	}
}
ForgeWalls()
{
	self endon("death");
	self endon("doneforge");
	for(;;)
	{
		self iPrintlnBold("^2Go To The Start Position Of The Wall \n^2Press [{+attack}] To Mark");
		self waittill("weapon_fired");
		pos1=self.origin;
		wait .1;
		self iPrintln("^2Position Marked!");
		wait 1;
		self iPrintlnBold("^2Go To The End Position Of The Wall \n^2Press [{+attack}] To Mark");
		self waittill("weapon_fired");
		pos2=self.origin;
		wait .1;
		self iPrintln("^2Position Marked!");
		self iPrintlnBold("^2Creating Wall...");
		wait 2;
		level thread CreateWalls(pos1,pos2);
		self iPrintln(""+pos1+" "+pos2+"");
		self notify("doneforge");
	}
}
ForgeLifts()
{
	self endon("death");
	self endon("doneforge");
	for(;;)
	{
		self iPrintlnBold("^2Go To The Position Of The Lift \n^2Press [{+attack}] To Mark");
		self waittill("weapon_fired");
		pos=self.origin;
		height=1000;
		wait .1;
		self iPrintln("^2Position Marked!");
		wait 1;
		wait 1;
		self iPrintlnBold("^2Creating Lift...");
		wait 2;
		level thread CreateLift(pos,height);
		self iPrintln("^2Lift Done!");
		self notify("doneforge");
	}
}
ForgeRamp()
{
	self endon("death");
	self endon("doneforge");
	for(;;)
	{
		self iPrintlnBold("^2Go To The Start Position Of The Ramp \n^2Press [{+attack}] To Mark");
		self waittill("weapon_fired");
		pos1=self.origin;
		wait .1;
		self iPrintln("^2Position Marked!");
		wait 1;
		self iPrintlnBold("^2Go To The End Position Of The Ramp \n^2Press [{+attack}] To Mark");
		self waittill("weapon_fired");
		pos2=self.origin;
		wait .1;
		self iPrintln("^2Position Marked!");
		self iPrintlnBold("^2Creating Ramp...");
		wait 2;
		level thread CreateRamp(pos1,pos2);

		self iPrintln(""+pos1+" "+pos2+"");
		self notify("doneforge");
	}
}
ForgeGrids()
{
	self endon("death");
	self endon("doneforge");
	for(;;)
	{
		self iPrintlnBold("^2Go To The Start Position Of Grid \n^2Press [{+attack}] To Mark");
		self waittill("weapon_fired");
		pos1=self.origin;
		wait .1;
		self iPrintln("^2Position Marked!");
		wait 1;
		self iPrintlnBold("^2Go To The End Position Of Grid \n^2Press [{+attack}] To Mark");
		self waittill("weapon_fired");
		pos2=self.origin;
		wait .1;
		self iPrintln("^2Position Marked!");
		self iPrintlnBold("^2Creating Grid...");
		wait 2;
		level thread CreateGrids(pos1,pos2);
		self iPrintln("^2Grid Done!");
		self notify("doneforge");
	}
}
CreateZip(pos1,pos2,teamz)
{
	wait .05;
	pos =(pos1 +(0,0,110));
	posa =(pos2 +(0,0,110));
	if(!isDefined(teamz))teamz=0;
	zip=spawn("script_model",pos);
	zip SetModel("vehicle_cobra_helicopter_d_piece07");
	zang=VectorToAngles(pos2 - pos1);
	zip.angles=zang;
	glow1=SpawnFx(level.redcircle,pos1);
	TriggerFX(glow1);
	zip.teamzs=teamz;
	wait .05;
	zip thread xxZipAct(pos1,pos2);
	zip2=spawn("script_model",posa);
	zip2 SetModel("vehicle_cobra_helicopter_d_piece07");
	zang2=VectorToAngles(pos1 - pos2);
	zip2.angles=zang2;
	glow2=SpawnFx(level.redcircle,pos2);
	TriggerFX(glow2);
}
xxZipAct(pos1,pos2)
{
	level endon("GEND");
	line=self;
	self.waitz=0;
	while(1)
	{
		for(i=0;i < level.players.size;i++)
		{
			p=level.players[i];
			if(p.team=="axis" && self.teamzs==1 && level.ziplinez==0)continue;
			if(p.team=="axis" && level.zboss==1)continue;
			if(Distance(pos1,p.origin)<= 50)
			{
				p.hint="^5Hold [{+reload}] To Use ZipLine";
				if(p.zipz==0)p thread xxZipMove(pos1,pos2,line);
			}
			if(Distance(pos2,p.origin)<= 50)
			{
				p.hint="^5Hold [{+reload}] To Use ZipLine";
				if(p.zipz==0)p thread xxZipMove(pos2,pos1,line);
			}
		}
		wait 0.2;
	}
}
xxZipMove(pos1,pos2,line)
{
	self endon("disconnect");
	self endon("death");
	self endon("ZBSTART");
	self.zipz=1;
	dis=Distance(pos1,pos2);
	time =(dis/800);
	acc=0.3;
	if(self.lght==1)time =(dis/1500);
	else
	{
		if(time > 2.1)acc=1;
		if(time > 4)acc=1.5;
	}
	if(time < 1.1)time=1.1;
	for(j=0;j < 60;j++)
	{
		if(self UseButtonPressed())
		{
			wait 0.5;
			if(self UseButtonPressed())
			{
				if(line.waitz==1)break;
				line.waitz=1;
				self.zuse=1;
				self thread xxzDeath(line);
				if(isdefined(self.N))self.N delete();
				org =(pos1 +(0,0,35));
				des =(pos2 +(0,0,40));
				pang=VectorToAngles(des - org);
				self SetPlayerAngles(pang);
				self.N=spawn("script_origin",org);
				self setOrigin(org);
				self linkto(self.N);
				self thread xxZipDrop(org,0);
				self.N MoveTo(des,time,acc,acc);
				wait(time + 0.2);
				self playsound("weap_suitcase_drop_plr");
				self unlink();
				if(self.team=="axis")self thread xxSpNorm(0.1,1.7,1);
				line.waitz=0;
				self.zuse=0;
				self notify("ZIPCOMP");
				if(self.bsat==1 && self.bspin!=1)
				{
					self.bspin=1;
					wait 1;
					if(self.bspin!=3)self.bspin=0;
				}
				else wait 1;
				break;
			}
		}
		if(Distance(pos1,self.origin)> 70 && Distance(pos2,self.origin)> 70)break;
		wait 0.1;
	}
	self.zipz=0;
}
xxZipStk(pos)
{
	self endon("death");
	self endon("ZBSTART");
	posz=self.origin;
	wait 4;
	if(self.origin==posz)self SetOrigin(pos);
}
xxZipDrop(org,var)
{
	self endon("ZIPCOMP");
	self endon("ZBSTART");
	self endon("death");
	self waittill("night_vision_on");
	self unlink();
	self thread xxZipStk(org);
	if(var==1)
	{
		if(self.team=="axis")self thread xxSpNorm(0.1,1.7,1);
		self.zuse=0;
		self.zipz=0;
		if(self.bsat==1 && self.bspin!=1)
		{
			self.bspin=1;
			wait 1;
			if(self.bspin!=3)self.bspin=0;
		}
		if(isdefined(self.N))self.N delete();
		self notify("ZIPCOMP");
	}
}
xxzDeath(line)
{
	self endon("ZIPCOMP");
	self waittill("death");
	line.waitz=0;
	self.zuse=0;
}
CreateFlag(enter,exit,vis,radius,angle)
{
	if(!isDefined(vis))vis=0;
	if(!isDefined(angle))angle =(0,0,0);
	flag=spawn("script_model",enter);
	flag setModel("prop_flag_american");
	flag.angles=angle;
	if(vis==0)
	{
		col="objective";
		flag xxshowInMap(col);
		wait 0.01;
		flag=spawn("script_model",exit);
		flag setModel("prop_flag_russian");
	}
	wait 0.01;
	self thread xxElevatorThink(enter,exit,radius,angle);
}
xxElevatorThink(enter,exit,radius,angle)
{
	level endon("GEND");
	if(!isDefined(radius))radius=50;
	while(1)
	{
		for(i=0;i< level.players.size;i++)
		{
			p=level.players[i];
			if(Distance(enter,p.origin)<= radius)
			{
				p SetOrigin(exit);
				p SetPlayerAngles(angle);
				playfx(level.expbullt,exit);
				p shellshock("flashbang",.7);
				if(p.team=="axis")p thread xxSpNorm(0.1,1.7,1);
				if(isDefined(p.elvz))p.elvz++;
			}
		}
		wait .5;
	}
}
xxshowInMap(shader)
{
	if(!isDefined(level.numGametypeReservedObjectives))level.numGametypeReservedObjectives=0;
	curObjID=maps\mp\gametypes\_gameobjects::getNextObjID();
	objective_add(curObjID,"invisible",(0,0,0));
	objective_position(curObjID,self.origin);
	objective_state(curObjID,"active");
	objective_icon(curObjID,shader);
}
CreateRamp(top,bottom)
{
	D=Distance(top,bottom);
	blocks=xxroundUp(D / 30);
	CX=top[0] - bottom[0];
	CY=top[1] - bottom[1];
	CZ=top[2] - bottom[2];
	XA=CX / blocks;
	YA=CY / blocks;
	ZA=CZ / blocks;
	CXY=Distance((top[0],top[1],0),(bottom[0],bottom[1],0));
	Temp=VectorToAngles(top - bottom);
	BA =(Temp[2],Temp[1] + 90,Temp[0]);
	for(b=0;b < blocks;b++)
	{
		block=spawn("script_model",(bottom +((XA,YA,ZA)* B)));
		block setModel("com_plasticcase_beige_big");
		block.angles=BA;
		blockb=spawn("trigger_radius",(0,0,0),0,65,30);
		blockb.origin=block.origin+(0,0,5);
		blockb.angles=BA;
		blockb setContents(1);
		wait 0.01;
	}
	block=spawn("script_model",(bottom +((XA,YA,ZA)* blocks)-(0,0,5)));
	block setModel("com_plasticcase_beige_big");
	block.angles =(BA[0],BA[1],0);
	blockb=spawn("trigger_radius",(0,0,0),0,65,30);
	blockb.origin=block.origin+(0,0,5);
	blockb.angles =(BA[0],BA[1],0);
	blockb setContents(1);
	wait 0.01;
}
CreateGrids(corner1,corner2,angle)
{
	W=Distance((corner1[0],0,0),(corner2[0],0,0));
	L=Distance((0,corner1[1],0),(0,corner2[1],0));
	H=Distance((0,0,corner1[2]),(0,0,corner2[2]));
	CX=corner2[0] - corner1[0];
	CY=corner2[1] - corner1[1];
	CZ=corner2[2] - corner1[2];
	ROWS=xxroundUp(W/55);
	COLUMNS=xxroundUp(L/30);
	HEIGHT=xxroundUp(H/20);
	XA=CX/ROWS;
	YA=CY/COLUMNS;
	ZA=CZ/HEIGHT;
	center=spawn("script_model",corner1);
	for(r=0;r<=ROWS;r++)
	{
		for(c=0;c<=COLUMNS;c++)
		{
			for(h=0;h<=HEIGHT;h++)
			{
				block=spawn("script_model",(corner1 +(XA * r,YA * c,ZA * h)));
				block setModel("com_plasticcase_beige_big");
				block.angles =(0,0,0);
				block Solid();
				block LinkTo(center);
				level.solid=spawn("trigger_radius",(0,0,0),0,65,30);
				level.solid.origin =((corner1 +(XA * r,YA * c,ZA * h)));
				level.solid.angles =(0,90,0);
				level.solid setContents(1);
				wait 0.01;
			}
		}
	}
	center.angles=angle;
}
CreateWalls(start,end,vis)
{
	blockb=[];
	blockc=[];
	blockd=[];
	D=Distance((start[0],start[1],0),(end[0],end[1],0));
	H=Distance((0,0,start[2]),(0,0,end[2]));
	if(!isDefined(vis))vis=0;
	if(vis==0)
	{
		blocks=xxroundUp(D/55);
		height=xxroundUp(H/30);
		tr=75;
		th=40;
		mod="com_plasticcase_beige_big";
	}
	else
	{
		blocks=xxroundUp(D/90);
		height=xxroundUp(H/90);
		tr=120;
		th=100;
		mod="tag_origin";
	}
	CX=end[0] - start[0];
	CY=end[1] - start[1];
	CZ=end[2] - start[2];
	XA =(CX/blocks);
	YA =(CY/blocks);
	ZA =(CZ/height);
	TXA =(XA/4);
	TYA =(YA/4);
	Temp=VectorToAngles(end - start);
	Angle =(0,Temp[1],90);
	for(h=0;h < height;h++)
	{
		fstpos =(start +(TXA,TYA,10)+((0,0,ZA)* h));
		block=spawn("script_model",fstpos);
		block setModel(mod);
		block.angles=Angle;
		blockb[h]=spawn("trigger_radius",(0,0,0),0,tr,th);
		blockb[h].origin=fstpos;
		blockb[h].angles=Angle;
		blockb[h] setContents(1);
		wait 0.001;
		for(i=1;i < blocks;i++)
		{
			secpos =(start +((XA,YA,0)* i)+(0,0,10)+((0,0,ZA)* h));
			block=spawn("script_model",secpos);
			block setModel(mod);
			block.angles=Angle;
			blockc[i]=spawn("trigger_radius",(0,0,0),0,tr,th);
			blockc[i].origin=secpos;
			blockc[i].angles=Angle;
			blockc[i] setContents(1);
			wait 0.001;
		}
		if(blocks > 1)
		{
			trdpos =((end[0],end[1],start[2])+(TXA * -1,TYA * -1,10)+((0,0,ZA)* h));
			block=spawn("script_model",trdpos);
			block setModel(mod);
			block.angles=Angle;
			blockd[h]=spawn("trigger_radius",(0,0,0),0,tr,th);
			blockd[h].origin=trdpos;
			blockd[h].angles=Angle;
			blockd[h] setContents(1);
			wait 0.001;
		}
	}
}
xxroundUp(floatVal)
{
	if(int(floatVal)!= floatVal)return int(floatVal+1);
	else return int(floatVal);
}
CreateLift(pos,height)
{
	lift=spawn("script_model",pos);
	lift setModel("com_junktire");
	wait .05;
	if(getDvar("mapname")== "mp_citystreets"||getDvar("mapname")== "mp_showdown"||getDvar("mapname")== "mp_backlot"||getDvar("mapname")== "mp_bloc"||getDvar("mapname")== "mp_carentan")lift setModel("com_junktire2");
	lift.angles =(0,0,270);
	if(getDvar("mapname")== "mp_shipment")
	{
		lift setModel("bc_military_tire05_big");
		lift.angles =(0,0,0);
	}
	level.yelcircle=loadfx("misc/ui_pickup_available");
	cglow=SpawnFx(level.redcircle,pos);
	TriggerFX(cglow);
	wait .05;
	lift thread ForgeLiftUp(pos,height);
}
ForgeLiftUp(pos,height)
{
	level endon("GEND");
	while(1)
	{
		players=level.players;
		for(index=0;index < players.size;index++)
		{
			player=players[index];
			if(Distance(pos,player.origin)<= 50)
			{
				player setOrigin(pos);
				player thread ForgeLiftAct(pos,height);
				self playsound("mp_ingame_summary");
				wait 3;
			}
			wait 0.01;
		}
		wait 1;
	}
}
ForgeLiftAct(pos,height)
{
	self endon("death");
	self endon("disconnect");
	self endon("ZBSTART");
	self.liftz=1;
	posa=self.origin;
	fpos=posa[2] + height;
	h=0;
	for(j=1;self.origin[2] < fpos;j+=j)
	{
		if(j > 130)j=130;
		h=h+j;
		self SetOrigin((pos)+(0,0,h));
		wait .1;
	}
	vec=anglestoforward(self getPlayerAngles());
	end =(vec[0] * 160,vec[1] * 160,vec[2] * 10);
	self SetOrigin(self.origin + end);
	wait .2;
	posz=self.origin;
	wait 4;
	self.liftz=0;
	if(self.origin==posz)self SetOrigin(posa);
}
xxSpNorm(slow,time,acc,li)
{
	self endon("death");
	self endon("disconnect");
	if(!isDefined(li))li=0;
	if(self.lght==1 && li==0)return;
	if(!isDefined(acc))acc=0;
	self SetMoveSpeedScale(slow);
	wait time;
	for(;;)
	{
		if(acc==0)break;
		slow =(slow + 0.1);
		self SetMoveSpeedScale(slow);
		if(slow==1.0)break;
		wait .15;
	}
	self thread xxLWSP();
}
xxLWSP()
{
	self SetMoveSpeedScale(1.0);
	if(self.lght==1)self SetMoveSpeedScale(1.4);
}
MapChecks()
{
	
	
		level.ForgeOptions = strTok("ladder1;container;bat;ladder2;US Flag;Russian Flag;Laptop;Missile;Tire;Teddy Bear", ";");
		level.ForgeFunctions = strTok("com_water_tank1_ladder;cobra_town_2story_motel;cobra_town_2story_house_01;com_steel_ladder;com_water_tank1;prop_flag_russian;com_laptop_2_open;projectile_hellfire_missile;com_junktire2;com_teddy_bear", ";");
	
}
getMap(Map)
{
	if(Map == getDvar("mapname"))return true;
	return false;
}

