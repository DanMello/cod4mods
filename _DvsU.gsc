#include common_scripts\utility;
#include maps\mp\gametypes\_hud_util;
#include maps\mp\_utility;
#include maps\mp\gametypes\_general_funcs;


init()
{
	level thread onPlayerConnect();
		
	 
	level.gameModeDevName = "DVSU";
	level.current_game_mode = "Daech VS U.S.A";
	
	level deletePlacedEntity("misc_turret");
	
	setDvar("scr_game_hardpoints", 0);
	setdvar( "scr_showperksonspawn", 0 );
	
	precacheShader("hud_suitcase_bomb");
	precacheShader("compass_objpoint_satallite_friendly");
	
	
	precacheShader("waypoint_captureneutral_a");
	precacheShader("waypoint_captureneutral_b");
	precacheShader("waypoint_captureneutral_c");
	precacheShader("waypoint_captureneutral_d");
	precacheShader("waypoint_captureneutral_e");
	
	
	game["strings"]["change_class"] = "";
	game["strings"]["axis_name"] = "";
	game["strings"]["allies_name"] = "";
	game["dialog"]["gametype"] = undefined;
	game["music"]["spawn_axis"] = undefined;
	game["music"]["spawn_allies"] = undefined;
	game["icons"]["axis"] = undefined;
	game["icons"]["allies"] = undefined;
	
	while(!isDefined(level.inPrematchPeriod)) wait .05;
	
	level thread uploadIntel();
}


onPlayerConnect()
{
	for(;;)
	{
		level waittill( "connected", player );
	 
		
		player.intelPoints = 25;
		player thread onPlayerSpawned();
		
	}
}

onPlayerSpawned()
{
	self endon("disconnect");
	
	while(!isDefined(self.connect_script_done)) wait .05;
	
	self thread init_dvsu();
	
	for(;;)
	{
		self waittill("spawned_player");
		
		 
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
showIconOnMap(shader)
{
	level.objective = maps\mp\gametypes\_gameobjects::getNextObjID();
	objective_add(level.objective,"invisible",(0,0,0));
	objective_position(level.objective,self.origin);
	objective_state(level.objective,"active");
	objective_team(level.objective,self.team);
	objective_icon(level.objective,shader);
}

init_dvsu()
{
	
	self waittill("spawned_player");
	
	self.intel["bar"] = createProBar((1,1,1),150,10,"CENTER","TOP",0 + self.AIO["safeArea_X"],45 + self.AIO["safeArea_Y"]);
	
	for(;;)
	{
		
		self.intel["bar"] updateBar(self.intelPoints/25);
	
		wait .05;
	}
	if(self.team == "axis")
	{
		//self setClientDvar("cg_thirdperson","1");
		
		//self attach("prop_suitcase_bomb","tag_stowed_back",false);	
		
	}
	
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
		
		if(!level.intelUploaded)
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

