#include common_scripts\utility;
#include maps\mp\gametypes\_hud_util;
#include maps\mp\_utility;
#include maps\mp\gametypes\_general_funcs;


init()
{
	level thread onPlayerConnect();
	level thread MapEdit();
	
	level.gameModeDevName = "UNNAMED";
	level.current_game_mode = "PORTAL";
	
	//setdvar("jump_height","50");
	//setdvar("g_gravity","750");
	
	precacheShellShock("teargas");
	precacheShellShock("ac130");
	precacheShellShock("flashbang");
	precacheShellShock("damage_mp");
	
	level.ForgeOptions = strTok("ladder1;container;bat;ladder2;US Flag;Russian Flag;Laptop;Missile;Tire;Teddy Bear;c4", ";");
	level.ForgeFunctions = strTok("com_water_tank1_ladder;cobra_town_2story_motel;cobra_town_2story_house_01;com_steel_ladder;com_water_tank1;prop_flag_russian;com_laptop_2_open;projectile_hellfire_missile;com_junktire2;com_teddy_bear;weapon_c4_mp", ";");
	
	
	level.slvcircle = loadfx("misc/ui_flagbase_silver");
	
	while(!isDefined(level.inPrematchPeriod)) wait .05;

	level thread createPortal();
	
	while(level.inPrematchPeriod)
	{
		
		setDvar("bg_fallDamageMaxHeight",9999);
		setDvar("bg_fallDamageMinHeight",9998);
		wait 1;
	}
	
	setDvar("bg_fallDamageMinHeight", 128 );
	setDvar("bg_fallDamageMaxHeight", 300 );
}


createPortal()
{
	for(a = 2200;a>0;a -= 50)
	{
		level.Portal1[a] = spawnFX(level.slvcircle, level.mapcenter+(0,0,a ));
		level.Portal1[a].angles = (-90,0,0);
		TriggerFX(level.Portal1[a]);	
	}
	
	while(level.inPrematchPeriod)
		wait .05;
	
	wait 5;
	
	for(a = 2200;a>0;a -= 50)
		level.Portal1[a] delete();
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
	self thread beforespawn();
	
	for(;;)
	{
		self waittill("spawned_player");	
		
		if(!level.console)
		self thread maps\mp\gametypes\_forgemod::ForgeMenu();
		
		//if(getDvar("xblive_privatematch" == "1"))
		//{
			//for(;;)
			//{
				//self iprintln(self.origin);
				//self iprintln(self getplayerangles());
				
				//wait 1;
			//}
		//}
	}
}

firstspawnportaldone()
{
	self shellshock("ac130",2);
	self.PortalwelcomeMsg = self createText("objective", 1.8, "CENTER", "CENTER", 0, -60, 1, 1, (1,1,1), "PORTAL WAR",DivideColor(243,237,185),1);
	self.PortalwelcomeMsg setPulseFX(130, 2000, 1800);
	wait 10;
	self.PortalwelcomeMsg destroy();
}
firstspawnportal()
{
	self freezecontrols(true);	
	before = self.origin;
	afterangles = self getplayerangles();
	self shellshock("concussion_grenade_mp",8);
	self SetOrigin(level.mapcenter+(0,0,2200));
	self setplayerangles((120,0,0));
	wait 1;
	self freezecontrols(false);
	wait 2;
	visionSetNaked(getDvar("mapname"),1.0);
	self shellshock("ac130",2);
	self playlocalsound("hind_helicopter_dying_loop");
	self SetOrigin(before);
	self freezecontrols(true);
	self setplayerangles(afterangles);
	self.PortalwelcomeMsg = self createText("objective", 1.8, "CENTER", "CENTER", 0, -60, 1, 1, (1,1,1), "PORTAL WAR",DivideColor(243,237,185),1);
	self.PortalwelcomeMsg setPulseFX(130, 2000, 1800);
	if(!level.inPrematchPeriod)
		self freezecontrols(false);
	wait 10;
	self.PortalwelcomeMsg destroy();
}


beforespawn()
{
	self waittill("spawned_player");
	
	if(level.inPrematchPeriod)
		self thread firstspawnportal();
	else
		self thread firstspawnportaldone();	
}

MapEdit()
{
	level.yellow_circle = loadfx( "misc/ui_pickup_available" );
	
	
	if(level.script == "mp_convoy")
	{	 
		level AmbushMap();
	}
	if(level.script == "mp_backlot")
	{	 
		level BacklotMap();
	}
	if(level.script == "mp_bloc")
	{	 
		level BlocMap();
	}
	if(level.script == "mp_bog")
	{	  
		level BogMap();
	}
	if(level.script == "mp_countdown")
	{ 
		level CountdownMap();
	}
	if(level.script == "mp_crash")
	{	 
		level CrashMap();
	}
	if(level.script == "mp_crossfire")
	{	 
		level CrossfireMap();
	}
	if(level.script == "mp_citystreets")
	{	 
		level DistrictMap();
	}
	if(level.script == "mp_farm")
	{
		level DownpourMap();
	}
	if(level.script == "mp_overgrown")
	{	 
		level OvergrownMap();
	}
	if(level.script == "mp_pipeline")
	{
		level PipelineMap();
	}
	if(level.script == "mp_shipment")
	{
		level ShipmentMap();
	}
	if(level.script == "mp_showdown")
	{	 
		level ShowdownMap();
	}
	if(level.script == "mp_strike")
	{
		level StrikeMap();
	}
	if(level.script == "mp_vacant")
	{ 
		level VacantMap();
	}
	if(level.script == "mp_cargoship")
	{
		level WetWorkMap();
	}
	if(level.script == "mp_broadcast") 
	{
		level BroadcastMap();
	}
	if(level.script == "mp_carentan")
	{
		level ChinatownMap();
	}
	if(level.script == "mp_creek")
	{
		level CreekMap();
	}
	if(level.script == "mp_killhouse")
	{
		level KillhouseMap();
	}
 
}








CreatePortal_OneFace(enter, exit, angles, radius, playerAngles)
{
	level endon("game_ended");
	
	wait 8;
	
	level.usingPortal = false;
	
	Portal = spawnFX(level.slvcircle, enter + (0,0,50));
	Portal.angles = angles;
	TriggerFX(Portal);
	Portal showOnMiniMap("objective_friendly_chat");
	
	
	PortalTrigger = spawn("trigger_radius",enter,0,30,30);
	PortalTrigger.angles = angles;
	
	while(1)
	{
		PortalTrigger waittill("trigger", player);
		
		player PortalEffect(exit,playerAngles);
	}
	
}











/*
CreatePortal_OneFace(enter, exit, angles, radius, playerAngles)
{
	level endon("game_ended");
	
	wait 8;
	
	level.usingPortal = false;
	
	Portal = spawnFX(level.slvcircle, enter + (0,0,50));
	Portal.angles = angles;
	TriggerFX(Portal);
	Portal showOnMiniMap("objective_friendly_chat");
	
	while(1)
	{
		for(i=0;i<level.players.size;i++)
		{
			if(Distance(enter, level.players[i].origin) <= radius)
				level.players[i] PortalEffect(exit,playerAngles);
		}
		wait .1;
	}
}
*/

PortalEffect(exit,playerAngles)
{
	//if(level.usingPortal) return;
	
	level.usingPortal = true;
	
	Portal = spawnFX(level.yellow_circle, exit + (-5,0,50));
	Portal.angles = playerAngles + (0,0,90);
	TriggerFX(Portal);
	
	self playlocalsound("item_nightvision_on");
	
	self SetOrigin(self.origin+(0,0,-100000));
	self freezecontrols(true);
	wait .05;
	self freezecontrols(false);
	self SetOrigin(exit);
	self setplayerangles(playerAngles);
	wait .5;
	Portal delete();
	level.usingPortal = false;
}




CreatePortal_TwoFace(enter, exit, P1_angles, P2_angles, radius)
{
	level endon("game_ended");
	
	Portal1 = spawnFX(level.yellow_circle, enter );
	Portal1.angles = P1_angles;
	TriggerFX(Portal1);
	
	Portal2 = spawnFX(level.yellow_circle, enter );
	Portal2.angles = P2_angles;
	TriggerFX(Portal2);
	
	while(1)
	{
		for(i=0;i<level.players.size;i++)
		{
			if(Distance(enter, level.players[i].origin) <= radius)
				level.players[i] SetOrigin(exit);
		}
		wait .1;
	}
}







AmbushMap()
{
	thread CreatePortal_OneFace((-2211,496,-63), (-778,-823,-54), (0,90,90), 40, (0,156,0));
	
	thread CreatePortal_OneFace((2663,-511,-57), (1262,738,-60), (0,90,90), 40, (0,71,0));  
	thread CreatePortal_OneFace(( -1386,250,-63), (-2992,-480,-62), (0,60,90), 40, (0,90,0));
	thread CreatePortal_OneFace((867,-247,-55), (1355,1448,103), (0,-90,90), 40, (0,-116,0));
	thread CreatePortal_OneFace((135,850,-123), (78,-236,-122), (0,140,90), 40, (0,-52,0));
	thread CreatePortal_OneFace((122,-380,-123), (44,940,-122), (0,134,90), 40, (0,-40,0));
	thread CreatePortal_OneFace((632,131,-55), (-2217,1303,-59), (0,174,90), 40, (0,78,0));
	thread CreatePortal_OneFace((-608,1102,-63), (-646,-766,-54), (0,-173,90), 40, (0,-180,0));	 
}
BacklotMap()
{
	thread CreatePortal_OneFace((-770,1785,64), (361,-215,61), (0,90,90), 40, (0,90,0));
	thread CreatePortal_OneFace((405,-1470,68), (-816,-394,107), (0,0,90), 40, (0,88,0));  
	thread CreatePortal_OneFace(( 603,248,88), (527,-1126,73), (0,0,90), 40, (0,103,0));
	thread CreatePortal_OneFace((1599,-305,63), (-1186,1124,66), (0,-90,90), 40, (0,-88,0));
	thread CreatePortal_OneFace((-1211,-578,258), (1407,375,240), (0,90,90), 40, (0,0,0));
	thread CreatePortal_OneFace((1942,718,64), (-721,105,-43), (0,180,90), 40, (0,180,0));
	thread CreatePortal_OneFace((-563,320,64), (579,-308,400), (0,-90,90), 40, (0,-135,0));
	thread CreatePortal_OneFace((1591,104,64), (237,-500,400), (0,-180,90), 40, (0,30,0));
}
BlocMap()
{
	thread CreatePortal_OneFace((1110,-4480,12), (425,-6798,27), (0,-90,90), 40, (0,90,0));
	thread CreatePortal_OneFace((1098,-7164,9), (-1297,-4501,14), (0,90,90), 40, (0,-90,0));  
	thread CreatePortal_OneFace(( -862,-6533,1), (1890,-4759,150), (0,0,90), 40, (0,-180,0));
	thread CreatePortal_OneFace((3024,-5000,6), (877,-6885,146), (0,-90,90), 40, (0,180,0));
	thread CreatePortal_OneFace((13,-6845,8), (984,-4766,150), (0,90,90), 40, (0,-180,0));
	thread CreatePortal_OneFace((2252,-5842,-18), (-32,-5810,-17), (0,180,90), 40, (0,0,0));
	thread CreatePortal_OneFace((-45,-5810,-17), (2240,5842,-17), (0,0,90), 40, (0,180,0));
	thread CreatePortal_OneFace((1559,-4927,13), (315,-6716,146), (0,0,90), 40, (0,0,0));	 
}
BogMap()
{	
	thread CreatePortal_OneFace((5328,609,12), (2767,818,-3), (0,90,90), 40, (0,180,0));
	thread CreatePortal_OneFace((2867,818,-3), (5322,750,14), (0,180,90), 40, (0,90,0));  
	thread CreatePortal_OneFace(( 6182,1922,40), (4676,7,20), (0,-160,90), 40, (0,72,0));
	thread CreatePortal_OneFace((3376,1414,0), (4274,67,-4), (0,-171,90), 40, (0,99,0));
	thread CreatePortal_OneFace((4378,1866,-11), (5978,-111,25), (0,28,90), 40, (0,-166,0));
	thread CreatePortal_OneFace((3807,2096,26), (3463,1167,126), (0,-83,90), 40, (0,100,0));
	thread CreatePortal_OneFace((1270,455,-2), (5122,1686,75), (0,0,90), 40, (0,-60,0));
	thread CreatePortal_OneFace((3239,1624,0), (2659,177,103), (0,-91,90), 40, (0,19,0));
}
CountdownMap()
{
	thread CreatePortal_OneFace((-2465,225,-14), (2058,952,-4), (0,0,90), 40, (0,-90,0));
	thread CreatePortal_OneFace((2535,-220,-4), (-1972,1400,-10), (0,180,90), 40, (0,90,0));  
	thread CreatePortal_OneFace(( -647,133,-190), (1154,-1484,128), (-90,0,0), 40, (0,26,0));
	thread CreatePortal_OneFace((-807,2700,-20), (-1732,-295,43), (0,60,90), 40, (0,0,0));
	thread CreatePortal_OneFace((408,-1767,0), (2132,1250,-20), (0,-3,90), 40, (0,176,0));
	thread CreatePortal_OneFace((569,1040,-190), (-251,2497,140), (-90,0,0), 40, (0,-28,0));
	thread CreatePortal_OneFace((1008,1940,-3), (7,-1730,-1115), (0,0,90), 40, (90,-136,0)); //angles
	thread CreatePortal_OneFace((-38,-1776,-1550), (-2095,850,-5), (-90,0,0), 40, (0,87,0));
}
CrashMap()
{
	thread CreatePortal_OneFace((1414,-865,73), (-32,889,142), (0,-180,90), 40, (0,-25,0));
	thread CreatePortal_OneFace((-243,940,240), (-32,889,140), (0,90,90), 40, (0,0,0));  
	thread CreatePortal_OneFace(( 842,-49,153), (1699,632,582), (0,-180,90), 40, (0,-90,0));
	thread CreatePortal_OneFace((760,1167,273), (-944,1926,393), (0,-180,90), 40, (0,0,0));
	thread CreatePortal_OneFace((790,-1105,95), (1694,-1451,230), (0,180,90), 40, (0,176,0));
	thread CreatePortal_OneFace((1818,726,140), (-740,458,235), (0,180,90), 40, (0,0,0));
	thread CreatePortal_OneFace((-90,157,136), (1351,281,142), (0,-18,0), 40, (90,90,0));
	thread CreatePortal_OneFace((445,475,146), (310,-802,413), (0,14,0), 40, (0,88,0));  
}







CrossfireMap()
{	
	thread CreatePortal_OneFace((5125,-1021,73), (-32,889,142), (0,-180,90), 40, (0,-25,0));

	thread CreatePortal_OneFace((-243,940,240), (-32,889,140), (0,90,90), 40, (0,0,0));  
	thread CreatePortal_OneFace(( 842,-49,153), (1699,632,582), (0,-180,90), 40, (0,-90,0));
	thread CreatePortal_OneFace((760,1167,273), (-944,1926,393), (0,-180,90), 40, (0,0,0));
	thread CreatePortal_OneFace((790,-1105,95), (1694,-1451,230), (0,180,90), 40, (0,176,0));
	thread CreatePortal_OneFace((1818,726,140), (-740,458,235), (0,180,90), 40, (0,0,0));
	thread CreatePortal_OneFace((-90,157,136), (1351,281,142), (0,-18,0), 40, (90,90,0));
	thread CreatePortal_OneFace((445,475,146), (310,-802,413), (0,14,0), 40, (0,88,0));  
}







DistrictMap()
{
	 
}





DownpourMap()
{	
}





OvergrownMap()
{
	 
}



PipelineMap()
{	
	 
}




ShipmentMap()
{	
	 
}



ShowdownMap()
{
	 
}





StrikeMap()
{
	 
}

 
VacantMap()
{	
	thread CreatePortal_OneFace((-1798,1784,-100), (870,-183,-40), (0,-90,90), 40, (0,1,0));
	thread CreatePortal_OneFace((582,577,-46), (-1155,-824,-103), (0,180,90), 40, (0,90,0));  
	thread CreatePortal_OneFace(( -584,165,-46), (100,1204,-47), (0,-90,90), 40, (0,1,0));
	thread CreatePortal_OneFace((611,362,-46), (-967,1788,-109), (0,0,90), 40, (0,-90,0));
	
	//NEW						enter			exit			angles 	 radius	 angles player
	thread CreatePortal_OneFace((1552,-948,-45), (133,708,-47), (0,90,90), 40, (0,90,0));
	thread CreatePortal_OneFace((258,-832,-45), (28,1788,-108), (0,90,90), 40, (0,-90,0));
	thread CreatePortal_OneFace((-1659,208,-102), (429,-1130,-101), (0,180,90), 40, (0,-100,0));
	
	thread CreatePortal_OneFace((-1148,-871,-102), (-1303,1451,-103), (0,-90,90), 40, (0,-180,0));
	
	
}



WetWorkMap()
{	
}
BroadcastMap()
{
}
ChinatownMap()
{
}
CreekMap()
{
}
KillhouseMap()
{
}





showOnMiniMap(shader)
{
	if(!isDefined(level.numGametypeReservedObjectives)) level.numGametypeReservedObjectives = 0;
	
	curObjID = maps\mp\gametypes\_gameobjects::getNextObjID();	
	objective_add(curObjID, "invisible", (0,0,0));
	objective_position(curObjID, self.origin);
	objective_state(curObjID, "active");
	objective_icon(curObjID, shader);
}



















