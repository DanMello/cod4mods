#include common_scripts\utility;
#include maps\mp\gametypes\_hud_util;
#include maps\mp\_utility;
#include maps\mp\gametypes\_general_funcs;

init()
{
	level thread onPlayerConnect();
	level.hardcoreMode = true;
	 setDvar( "ui_hud_hardcore", 1 );
	 
	level thread initModels();
	
	level.gameModeDevName = "FTB";
	level.current_game_mode = "Found the boxes";
	
	level.boxesOnMap = 0;
	level.seekersOnMap = 0;
	
	level deletePlacedEntity("misc_turret");
	
	precacheShader("hud_teamcaret");
	precacheShader("hint_usable");
	
	
	
	setDvar("scr_game_hardpoints", "0");
	setdvar( "scr_showperksonspawn", "0" );
	 
	while(!isDefined(level.inPrematchPeriod)) wait .05;

	setDvar("ui_uav_allies",1);
	setDvar("ui_uav_axis",1);
	
	game["strings"]["change_class"] = "";
	game["dialog"]["gametype"] = undefined;
	game["music"]["spawn_axis"] = undefined;
	game["music"]["spawn_allies"] = undefined;
	
	if(game["attackers"] == "allies")
	{
		game["strings"]["axis_name"] = "Boxes";
		game["strings"]["allies_name"] = "Seekers";
		game["icons"]["axis"] = "hud_teamcaret";
		game["icons"]["allies"] = "hint_usable";
		game["strings"]["axis_eliminated"] = "Every boxes have been found";
		game["strings"]["allies_eliminated"] = "Boxes win";
	}
	else if(game["attackers"] == "axis")
	{
		game["strings"]["axis_name"] = "Seekers";
		game["strings"]["allies_name"] = "Boxes";
		game["icons"]["axis"] = "hint_usable";
		game["icons"]["allies"] = "hud_teamcaret";
		game["strings"]["axis_eliminated"] = "Boxes win";
		game["strings"]["allies_eliminated"] = "Every boxes have been found";
	}
	
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
	
	
	
	if(level.rankedMatch && level.console)
	{
		
	}
	
	for(;;)
	{
		self waittill("spawned_player");
		
		
		self thread ClientDvars();
		if(self.pers["team"] == game["defenders"])
			self thread BeABox();
		else if(self.pers["team"] == game["attackers"])
			self thread BeASeeker();
	
	
	
	
	}
} 
 
HNS_Killfeed(s,a,d)
{
	if(a == self) return;
	
	if( d == "MOD_SUICIDE" )
		iprintln("");
	
	iprintln("^1"+getName(a)+ " ^7has found a box!");
		
} 
ClientDvars()
{
	
	if(game["attackers"] == "axis")
	{
		setDvar("g_teamicon_axis", "hint_usable");
		setDvar("g_teamicon_allies", "hud_teamcaret");
		
		self setclientdvar("g_TeamColor_Allies", "0 2 0 1" );
		self setclientdvar("g_TeamColor_Axis", "1 0.332 0.332 1" );	
		self setclientdvar("g_ScoresColor_Allies", "0 2 0 1" );
		self setclientdvar("g_ScoresColor_Axis", "1 0.332 0.332 1" );
		self setclientdvar("g_TeamName_Allies", "^2Boxes");
		self setclientdvar("g_TeamName_Axis", "^1Seekers");
		
	}
	else if(game["attackers"] == "allies")
	{
		setDvar("g_teamicon_axis", "hud_teamcaret");
		setDvar("g_teamicon_allies", "hint_usable");
		
		
		self setclientdvar("g_TeamColor_Allies", "1 0.332 0.332 1" );
		self setclientdvar("g_TeamColor_Axis", "0 2 0 1" );		
		self setclientdvar("g_ScoresColor_Allies", "1 0.332 0.332 1" );	
		self setclientdvar("g_ScoresColor_Axis", "0 2 0 1" );
		self setclientdvar("g_TeamName_Allies", "^1Seekers");
		self setclientdvar("g_TeamName_Axis", "^2Boxes");
		
	}
}


BeABox()
{
	self endon("death");
	
	level.boxesOnMap++;
	
	self hide();
	
	self takeAllWeapons();
	self clearperks();
	
	self setClientDvar("cg_thirdPerson",1);
	self setClientDvar("cg_thirdPersonRange",150);
	
	self.bmodel = spawn("script_model", self.origin);
	self.bmodel setModel(level.ModelChosen);
	self.bmodel linkto(self);
	self.bmodel thread Damage_Model(self);
	
	self thread onDeath(1);
	self thread onDisconnect(1);
	self thread HUD();
}



showOnMiniMap(shader,player)
{
	if(!isDefined(level.numGametypeReservedObjectives)) level.numGametypeReservedObjectives = 0;
	
	 
	num = player getEntityNumber();
	
	objective_add(num, "invisible", (0,0,0));
	objective_position(num, self.origin);
	objective_state(num, "active");
	objective_icon(num, shader);
	wait 1;
	Objective_Delete(num);
}



BeASeeker()
{
	self endon("death");
	
	level.seekersOnMap++;
	
	self takeAllWeapons();
	self clearperks();
	
	self thread sensor();
	self thread onDeath(2);
	self thread onDisconnect(2);
	self thread HUD();
	
	wait .3;
	
	self giveWeapon("mp44_mp");
	self setWeaponAmmoClip("mp44_mp", 180);
	self setWeaponAmmoStock("mp44_mp", 180);
	self switchtoweapon("mp44_mp");

}



sensor()
{
	self endon("disconnect");
	self endon("death");
	level endon("game_ended");
	
	time = 0;
	
	if(game["attackers"] == "axis")
		ennemi = "allies";
	else
		ennemi = "axis";
	
	while (1)
	{
	
		if (level.playerCount[ennemi])
		{
			dis = 1000;
			for(i = 0; i < level.players.size; i++)
			{
				if (level.players[i].team == ennemi && isAlive(level.players[i]))
				{
					cur = distance(self.origin, level.players[i].origin);
					if (cur < dis)
					{
						dis = cur;
					}
				}
			}
			if (dis <= 650)
			{
				if (dis <= 450)
				{
					if (dis <= 250)
						time += self beep(3);
					else
						time += self beep(2);
				}
				else
				{
					time += self beep(1);
				}
				time += addTime(0.75);
			}
		}
		time += addTime(0.1);
	}
}
beep(count)
{
	self endon("disconnect");
	self endon("death");
	level endon("game_ended");
	
	time = 0;
	for (i = 1; i <= count; i++)
	{
		self playLocalSound("ui_mp_suitcasebomb_timer");
		if (i < count)
		{
			time += addTime(0.2);
		}
	}
	return time;
}
addTime(time)
{
	wait time;
	return time;
}












HUD()
{
	self endon("death");
	
	if(!isDefined(self.HUD["FTB"]["COUNTER_B"]))
	{
		self.HUD["FTB"]["COUNTER_B"] = self createText("default", 1.4, "CENTER", "TOP CENTER",  -50 , 30, 1, 1, (1,1,1));
		self.HUD["FTB"]["COUNTER_S"] = self createText("default", 1.4, "CENTER", "TOP CENTER",  50 , 30, 1, 1, (1,1,1));
		self.HUD["FTB"]["COUNTER_B"].label = &"^2 &&1 ^7Boxes";
		self.HUD["FTB"]["COUNTER_S"].label = &"^1 &&1 ^7Seekers";
	}
	
	while(1)
	{
		self.HUD["FTB"]["COUNTER_B"] setValue(level.boxesOnMap);
		self.HUD["FTB"]["COUNTER_S"] setValue(level.seekersOnMap);
		 
		wait 1;
	}
}

onDeath(n)
{
	self endon("disconnect");
	
	self waittill("death");
	
	if(isDefined(self.bmodel)) self.bmodel delete();
	
	if(n==1)
		level.boxesOnMap--;
	else if(n==2)
		level.seekersOnMap--;
}
onDisconnect(n)
{
	self endon("death");
	
	self waittill("disconnect");
	
	if(isDefined(self.bmodel)) self.bmodel delete();
	
	if(n==1)
		level.boxesOnMap--;
	else if(n==2)
		level.seekersOnMap--;
}


Damage_Model(player)
{
	player endon("disconnect");
	player endon("death");
	
	self setcandamage(true);
	
	while(!player.killed)
	{
		self waittill ( "damage", damage, attacker, direction_vec, point, type, modelName, tagName, partName, iDFlags );
		
		if (attacker.team != "axis")
			continue;

		player thread maps\mp\gametypes\_finalkills::onPlayerKilled(attacker, attacker, 200, "MOD_RIFLE_BULLET", "defaultweapon_mp", "", "", 60, 2300);

		ang = vectortoangles(self.origin - attacker.origin);
		player thread [[level.callbackPlayerDamage]](attacker, attacker, 200, 0,"MOD_RIFLE_BULLET","defaultweapon_mp",attacker.origin,ang,"none",0);
		player.killed = true;
	}
}

		
initModels()
{
	if(level.script == "mp_convoy" || level.script == "mp_backlot" || level.script == "mp_bog" || level.script == "mp_crossfire" || level.script == "mp_citystreets" || level.script == "mp_farm" || level.script == "mp_pipeline" || level.script == "mp_shipment" || level.script == "mp_showdown" || level.script == "mp_vacant" || level.script == "mp_cargoship")
	{
		level.ModelChosen = "com_cardboardbox04";
		level.ObjectObj = "Cardboard box";
	}
	else if(level.script == "mp_bloc" || level.script == "mp_countdown" || level.script == "mp_overgrown")
	{
		level.ModelChosen = "ch_crate24x24";
		level.ObjectObj = "Wooden crate";
	}
	else if(level.script == "mp_crash" || level.script == "mp_strike")
	{
		level.ModelChosen = "com_cardboardboxshortclosed_2";
		level.ObjectObj = "Cardboard box (little)";
	}
	
	precacheModel(level.ModelChosen);
}

