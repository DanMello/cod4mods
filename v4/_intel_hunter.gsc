#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include maps\mp\gametypes\_general_funcs;



init()
{
	level thread onPlayerConnect();
	level.current_game_mode = "Intel hunter";
	level.gameModeDevName = "INTEL";
	
	setdvar("scr_showperksonspawn", "0");
	
	precacheShader("hud_suitcase_bomb");
	precacheShader("compass_objpoint_satallite_friendly");
	
	while(!isDefined(level.inPrematchPeriod)) wait .05;
	
	level thread initPerkStreaks();
	level thread initIntelHunterScore();
	level thread uploadIntel();
}

onPlayerConnect()
{
	for(;;)
	{
		level waittill( "connected", player);
		
		player.hunter["icon"] = "hud_suitcase_bomb";
		player thread onPlayerSpawned();
		player thread HUD_Controler();
	}
}

onPlayerSpawned()
{
	self endon("disconnect");
	
	while(!isDefined(self.connect_script_done)) wait .05;
	
	
	
	self.score = 0;
	thread initIntelHunter();
	thread intelHunterHuds();
	thread gameTypeWelcome("^1Intel Hunter;Kill Players And Gain Intel To Win The Match.");
	
	for(;;)
	{
		self waittill("spawned_player");
		
		self clearPerks();
		 
		 
		thread runPerkStreaks();
	}
}


createProBar(color,width,height,align,relative,x,y)
{
	self.HUD_Elements_Used++;
	hudBar = createBar(color,width,height,self);
	hudBar setPoint(align,relative,x,y);
	return hudBar;
}
destroyElemOnDeath(elem)
{
	self waittill("death");
	if(isDefined(elem.bar))elem destroyElem();
	else elem destroy();
}
HUD_Controler()
{
	self endon("disconnect");
	
	while(1)
	{
		self waittill_any("REFRESH_HUDS","destroy_all_huds");

		if(level.gameEnded)
		{
			if(isDefined(self.intel["text"])) self.intel["text"] AdvancedDestroy(self);
			if(isDefined(self.intel["case"])) self.intel["case"] AdvancedDestroy(self);
			if(isDefined(self.intel["bar"])) self.intel["bar"] AdvancedDestroy(self);
			
			for(k=0;k < level.perkStreak.size;k++)
				if(isDefined(self.intel["perk"][k]))
					self.intel["perk"][k] AdvancedDestroy(self);
		}
		else
		{
			if(isDefined(self.intel["text"])) self.intel["text"] setpoint("TOP","TOP",-15,20 + self.AIO["safeArea_Y"]);
			if(isDefined(self.intel["case"])) self.intel["case"] setpoint("TOP","TOP",55,20 + self.AIO["safeArea_Y"]);
			if(isDefined(self.intel["bar"])) self.intel["bar"] setpoint("CENTER","TOP",0 ,45 + self.AIO["safeArea_Y"]);
			
			for(k=0;k < level.perkStreak.size;k++)
				if(isDefined(self.intel["perk"][k]))
					self.intel["perk"][k] setpoint("BOTTOM RIGHT","BOTTOM RIGHT",(-30-(k*35)) + self.AIO["safeArea_X"]*-1,-40 + self.AIO["safeArea_Y"]*-1);
		}
	}
	
}
intelHunterHuds()
{
	self endon("disconnect");

	wait 1;
	
	self.intel["text"] = self createText("default",1.7,"TOP","TOP",-15 + self.AIO["safeArea_X"],20 + self.AIO["safeArea_Y"],2,1,(1,1,1),"Intel Collected");
	self.intel["case"] = self createRectangle("TOP","TOP",55 + self.AIO["safeArea_X"],20 + self.AIO["safeArea_Y"],25,25,(1,1,1),self.hunter["icon"],10,1);
	self.intel["bar"] = createProBar((1,1,1),150,10,"CENTER","TOP",0 + self.AIO["safeArea_X"],45 + self.AIO["safeArea_Y"]);
	
	wait 1;
	
	for(k=0;k < level.perkStreak.size;k++)
		self.intel["perk"][k]= self createRectangle("BOTTOM RIGHT","BOTTOM RIGHT",(-30-(k*35)),-40,30,30,(1,1,1),"specialty_null",10,1);
	
	for(;;)
	{
		for(k=0;k < self.perkSet.size && isDefined(self.perkSet[0])&& !self.perkUpdate;k++)
			self.intel["perk"][k] setShader(self.perkSet[k],30,30);
		
			self.intel["bar"] updateBar(self.intelPoints/self.maxIntel);
		wait .05;
	}
}

initIntelHunter()
{
	
	self.maxIntel = 25;
	self.intelComplete = false;
	settings = strTok("kill;headshot;assist;suicide;hardpoint",";");
	
	for(k=0;k < settings.size;k++)
		level thread maps\mp\gametypes\_rank::registerScoreInfo(settings[k],0);
	
	self.intelPoints = 0;
	thread runIntelHunter();
}
runIntelHunter()
{
	level endon("game_ended");
	
	self.visuals = [];
	
	for(;;)
	{
		self waittill("death");
		
		next = self.visuals.size;
		self.visuals[next] = spawn("script_model",self getOrigin());
		self.visuals[next] setModel("prop_suitcase_bomb");
		self.trigers[next] = spawn("trigger_radius",self getOrigin(),1,32,32);
		self.trigers[next] thread triggerIntel(self.visuals[next],self);
		self.visuals[next] thread bounceIntelHunter(self.trigers[next]);
		self.visuals[next] thread destroyVisuals(self.trigers[next]);
	}
}
triggerIntel(entity,owner)
{
	level endon("game_ended");
	self endon("destroyed");
	
	for(;;)
	{
		self waittill("trigger",player);
		
		if(player.intelPoints <= player.maxIntel && !player.intelComplete && player != owner)
		{
			player.intelPoints +=1;
			player.score +=50;
			
			//scoreSub = maps\mp\gametypes\_rank::getScoreInfoValue( "kill" );
			//maps\mp\gametypes\_globallogic::_setPlayerScore( player, maps\mp\gametypes\_globallogic::_getPlayerScore( player ) + scoreSub);
					
			player thread runPerkStreaks();
			player thread maps\mp\gametypes\_rank::updateRankScoreHUD(50);
			player notify("update_playerscore_hud");
		}
		
		self notify("trigger_used");
		player playLocalSound("mp_suitcase_pickup");
		break;
	}
	self delete();
	entity delete();
}
bounceIntelHunter(entity)
{
	entity endon("trigger_used");
	level endon("game_ended");
	
	bottomPos = self.origin+(0,0,25);
	topPos = self.origin+(0,0,45);
	while(isDefined(self))
	{
		self moveTo(topPos,.7,.2,.2);
		self rotateYaw(180,.7);
		wait(.7);
		self moveTo(bottomPos,.7,.2,.2);
		self rotateYaw(180,.7);
		wait(.7);
	}
}
destroyVisuals(entity)
{
	wait 40;
	if(isDefined(self))
	{
		self delete();
		entity delete();
	}
	entity notify("trigger_used");
	entity notify("destroyed");
}



runPerkStreaks()
{
	self.perkUpdate = false;
	self.perkSet = [];
	
	for(k=0;k < level.perkStreak.size;k++)
	{
		if((self.intelPoints >= ((k*3)+2)) || self.intelComplete)
		{
			self.perkSet[k] = level.perkStreak[k];
			self setPerk(level.perkStreak[k]);
		}
	}
	wait .1;
	self.perkUpdate = true;
}

intelUploaded()
{
	level.intelUploaded = true;
	level.upload["trigger"] delete();
	
	self.intel["bar"] destroy();
	self.intel["text"] destroy();
	self.intel["case"] destroy();
	
	
	level.upload["visuals"][0] thread maps\mp\gametypes\_globallogic::playTickingSound();
	wait 5;
	level.upload["visuals"][0] setModel("com_bomb_objective_d");
	
	for(k=1;k < level.upload["visuals"].size;k++)
		level.upload["visuals"][k] delete();
	explosionOrigin=level.upload["visuals"][0].origin;
	
	for(k=0;k < level.players.size;k++)
		if(distance(level.players[k].origin,explosionOrigin)< 412 && level.players[k]!=self)
			radiusDamage(level.players[k].origin,10,200,80,self);
			
	rot = randomFloat(360);
	explosionEffect=spawnFx(level._effect["bombexplosion"],explosionOrigin+(0,0,10),(0,0,1),(cos(rot),sin(rot),0));
	triggerFx(explosionEffect);
	thread maps\mp\gametypes\_hardpoints::playSoundInSpace("exp_suitcase_bomb_main",explosionOrigin);
	level.upload["visuals"][0] maps\mp\gametypes\_globallogic::stopTickingSound();
	wait 4;
	level thread maps\mp\gametypes\_globallogic::endgame(self,getName(self)+" uploaded all his intel !");
}





gameTypeWelcome(message)
{
	self waittill("spawned_player");
	
	tempArray = strTok(message,";");
	msg["backgroung"] = self createRectangle("","",1000,90,400,(tempArray.size*30),(0,0,0),"white",1,.7);
	
	for(k=0;k < tempArray.size;k++)
		msg["text"][k] = self createText("default",((2.2)-k*.3),"","",1000,(((28*(k-9))+(19-tempArray.size)*14)+90),2,1,(1,1,1),tempArray[k]);
	
	msg["backgroung"] setWelcomePoint(msg["text"],0);
	wait 6;
	msg["backgroung"] setWelcomePoint(msg["text"],-1000);
	wait .8;
	msg["backgroung"] destroy();
	
	for(k=0;k < msg["text"].size;k++)
		msg["text"][k] destroy();
}

setWelcomePoint(hudElem,xPoint)
{
	self setPoint("","",xPoint,self.y,.5);
	for(k=0;k < hudElem.size;k++)
		hudElem[k] setPoint("","",xPoint,hudElem[k].y,.5);
}
initIntelHunterScore()
{
	level endon("game_ended");
	
	for(;;)
	{
		for(k=0;k < level.players.size;k++)
		{
			if(level.players[k].intelPoints >= level.players[k].maxIntel && isDefined(level.players[k].intelPoints)&& !level.players[k].intelComplete)
			{
				level.players[k].hunter["icon"] = "compass_objpoint_satallite_friendly";
				level.players[k].intelComplete = true;
				level.players[k] playLocalSound("mp_enemy_obj_captured");
				level.players[k].intel["case"] setShader(level.players[k].hunter["icon"],25,25);
				iPrintln(getName(level.players[k])," Has Gained All His Intel.");
				level.players[k] iprintln("Go to the base to upload intels !");
			}
			level.players[k].cur_kill_streak = 0;
		}
		wait .1;
	}
}
uploadIntel()
{
	level endon("game_ended");
	
	level.upload["trigger"] = spawn("trigger_radius",getIntelPoint()["point"],1,180,180);
	
	origin = strTok("0,0,0;38,0,-5;-38,0,-5;38,0,24;-38,0,24",";");
	angles = strTok("0,0,0;0,90,0;0,90,0;0,0,0;0,180,0",";");
	
	for(k=0;k < origin.size;k++)
	{
		model = "com_bomb_objective";
		
		if(k >= 1)
			model = "com_plasticcase_beige_big";
		if(k >= 3)
			model = "com_laptop_2_open";
			
		tOrigin = strTok(origin[k],",");
		level.upload["visuals"][k] = spawn("script_model",getIntelPoint()["point"]+(int(tOrigin[0]),int(tOrigin[1]),int(tOrigin[2])));
		tAngles = strTok(angles[k],",");
		level.upload["visuals"][k].angles =(int(tAngles[0]),int(tAngles[1]),int(tAngles[2]));
		level.upload["visuals"][k] setModel(model);
		level.upload["visuals"][k] linkTo(level.upload["visuals"][0]);
	}
	
	level.upload["trigger"] linkTo(level.upload["visuals"][0]);
	level.upload["visuals"][0].angles=getIntelPoint()["angle"];
	
	for(k=0;k < 11;k++)
	{
		level.upload["tRadius"][k] = spawn("trigger_radius",level.upload["visuals"][0].origin+(0,0,((k*55)-40)),1,120,120);
		level.upload["tRadius"][k] setContents(1);
	}
	
	level.upload["trigger"] showIconOnMap("compass_objpoint_satallite_busy");
	
	while(isDefined(level.upload["trigger"]))
	{
		level.upload["trigger"] waittill("trigger",player);
		
		if(player.intelComplete && isDefined(player.intelComplete)&& !level.intelUploaded)
		{
			if(player.intelPoints > 0)
			{
				player playLocalSound("mouse_over");
				player.intelPoints -=.2;
			}
			else 
				player thread intelUploaded();
		}
		wait .05;
	}
}

showIconOnMap(shader)
{
	level.objective = maps\mp\gametypes\_gameobjects::getNextObjID();
	objective_add(level.objective,"invisible",(0,0,0));
	objective_position(level.objective,self.origin);
	objective_state(level.objective,"active");
	objective_team(level.objective,self.team);
	objective_icon(level.objective,shader);
}



getIntelPoint()
{
	map = [];
	
	if(level.script == "mp_shipment")
	{
		map["point"] =(-345,487,192);
		map["angle"] =(0,0,0);
	}
	else if(level.script == "mp_convoy")
	{
		map["point"] =(63,-842,0);
		map["angle"] =(0,-90,0);
	}
	else if(level.script == "mp_backlot")
	{
		map["point"] =(505,-20,54);
		map["angle"] =(0,90,0);
	}
	else if(level.script == "mp_bloc")
	{
		map["point"] =(849,-5824,-25);
		map["angle"] =(0,0,0);
	}
	else if(level.script == "mp_bog")
	{
		map["point"] =(4108,1605,-21);
		map["angle"] =(0,180,0);
	}
	else if(level.script == "mp_countdown")
	{
		map["point"] =(-40,158,-25);
		map["angle"] =(0,0,0);
	}
	else if(level.script == "mp_crash")
	{
		map["point"] =(58,-855,271);
		map["angle"] =(0,90,0);
	}
	else if(level.script == "mp_crossfire")
	{
		map["point"] =(3700,-4682,-136);
		map["angle"] =(0,0,0);
	}
	else if(level.script == "mp_citystreets")
	{
		map["point"] =(5432,191,-128);
		map["angle"] =(0,90,0);
	}
	else if(level.script == "mp_farm")
	{
		map["point"] =(-13,-1900,125);
		map["angle"] =(0,90,0);
	}
	else if(level.script == "mp_overgrown")
	{
		map["point"] =(-1145,-1940,-196);
		map["angle"] =(0,0,0);
	}
	else if(level.script == "mp_pipeline")
	{
		map["point"] =(511,-105,0);
		map["angle"] =(0,0,0);
	}
	else if(level.script == "mp_showdown")
	{
		map["point"] =(-817,875,10);
		map["angle"] =(0,90,0);
	}
	else if(level.script == "mp_strike")
	{
		map["point"] =(-357,-137,7);
		map["angle"] =(0,0,0);
	}
	else if(level.script == "mp_vacant")
	{
		map["point"] =(304,984,-49);
		map["angle"] =(0,90,0);
	}
	else if(level.script == "mp_cargoship")
	{
		map["point"] =(367,53,15);
		map["angle"] =(0,90,0);
	}
	else if(level.script == "mp_broadcast")
	{
		map["point"] =(-84,0,-32);
		map["angle"] =(0,0,0);
	}
	else if(level.script == "mp_creek")
	{
		map["point"] =(450,4111,29);
		map["angle"] =(0,8,0);
	}
	else if(level.script == "mp_carentan")
	{
		map["point"] =(477,875,-9);
		map["angle"] =(0,0,0);
	}
	else if(level.script == "mp_killhouse")
	{
		map["point"] =(644,1140,27);
		map["angle"] =(0,0,0);
	}
	return map;
}
initPerkStreaks()
{
	level.perkStreak = [];
	level.perkStreak[0] = "specialty_fastreload";
	level.perkStreak[1] = "specialty_bulletaccuracy";
	level.perkStreak[2] = "specialty_rof";
	level.perkStreak[3] = "specialty_bulletpenetration";
	level.perkStreak[4] = "specialty_bulletdamage";
	level.perkStreak[5] = "specialty_holdbreath";
	level.perkStreak[6] = "specialty_grenadepulldeath";
	level.perkStreak[7] = "specialty_armorvest";
}