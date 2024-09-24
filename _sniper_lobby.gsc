//BRAWL

#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include maps\mp\gametypes\_general_funcs;







init()
{
	level thread onPlayerConnect();
	
	level thread initializeCustomSpawns();
	level PrecacheModelsForMap();
	level thread CreateArena();
	level thread onEndGame();
	
	level.gameModeDevName = "BRAWL";
	level.current_game_mode = "Brawl";
	
	
	PrecacheShader("hud_icon_desert_eagle");
	PrecacheShader("waypoint_captureneutral");
	PrecacheShader("killiconmelee");
	PrecacheShader("killicondied");
	PrecacheShader("ammo_counter_riflebullet");
	
	level.HardcoreMode = true;
	setDvar("ui_hud_hardcore",1);
	
	setDvar("mantle_enable","0");
	setdvar("scr_game_allowkillcam ","0");
	setDvar("scr_game_hardpoints", "0");
	
	level deletePlacedEntity("misc_turret");
	
	while(!isDefined(level.inPrematchPeriod)) wait .05;
	
	//playSoundOnPlayers("mp_time_running_out_winning"); 
	
	setdvar("scr_game_allowkillcam ","0");
	
	game["dialog"]["gametype"] = undefined;
	game["music"]["spawn_axis"] = undefined;
	game["music"]["spawn_allies"] = undefined;
	
	
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
	
	self.myVIEWW = (0,0,0);
	
	self thread HUDDD();
	self thread Bouch_Welcome("WEL_TITLE","WEL_SHADER",undefined,"hud_icon_desert_eagle","BRAWL", undefined,(0/255,154/255,255/255),-150);
	self thread StartBoucherie();
	self thread Boucherie_HUD();
	self thread ColorCor();
	self thread CheckAmmo();
	
	for(;;)
	{
		self waittill("spawned_player");

		self thread Setup();
	}
}

Setup()
{
	self endon("disconnect");
	self endon("death");
	
	self.maxhealth = 10;
	self.health = self.maxhealth;
	self notify("end_healthregen");
	self allowJump(false);

	self.bullet = 1;
	self SetPerk( "specialty_bulletdamage" );
	self SetPerk( "specialty_bulletpenetration" );
	
	self.HUD["BRAWL"]["BULLETS_7"].alpha = 1;
	self.HUD["BRAWL"]["BULLETS_6"].alpha = 0;
	self.HUD["BRAWL"]["BULLETS_5"].alpha = 0;		
	self.HUD["BRAWL"]["BULLETS_4"].alpha = 0;
	self.HUD["BRAWL"]["BULLETS_3"].alpha = 0;
	self.HUD["BRAWL"]["BULLETS_2"].alpha = 0;		
	self.HUD["BRAWL"]["BULLETS_1"].alpha = 0;
	
	self setClientDvar( "aim_automelee_enabled", "0" );
	self setClientDvar( "nightVisionDisableEffects", "1" );
	
	for(;;)
	{
		self setWeaponAmmoClip("deserteagle_mp", self.bullet);
		wait .2;
		

		if(self.bullet == 1)	
			self.HUD["BRAWL"]["BULLETS_7"].alpha = 1;
			
		if(self.bullet == 2)	
			self.HUD["BRAWL"]["BULLETS_6"].alpha = 1;
			
		if(self.bullet == 3)	
			self.HUD["BRAWL"]["BULLETS_5"].alpha = 1;
			
		if(self.bullet == 4)
			self.HUD["BRAWL"]["BULLETS_4"].alpha = 1;
			
		if(self.bullet == 5)	
			self.HUD["BRAWL"]["BULLETS_3"].alpha = 1;
			
		if(self.bullet == 6)	
			self.HUD["BRAWL"]["BULLETS_2"].alpha = 1;
			
		if(self.bullet == 7)	
			self.HUD["BRAWL"]["BULLETS_1"].alpha = 1;
		
	}
	
}

HUDDD()
{
	self endon("disconnect");
	
	self waittill("spawned_player");
	
	wait 3;
	
	self.HUD_boucherie = self createRectangle("BOTTOM RIGHT", "BOTTOM RIGHT", -10 + self.AIO["safeArea_X"], -10 + self.AIO["safeArea_Y"]*-1, 50, 50, (1,1,1), "hud_icon_desert_eagle", 1, 1);
	
	self.HUD["BRAWL"]["BULLETS_1"] = self createRectangle("BOTTOM RIGHT", "BOTTOM RIGHT", -10 + self.AIO["safeArea_X"]*-1, -155 + self.AIO["safeArea_Y"]*-1, 30, 10, (1,1,1), "ammo_counter_riflebullet", 2, 0);
	self.HUD["BRAWL"]["BULLETS_2"] = self createRectangle("BOTTOM RIGHT", "BOTTOM RIGHT", -10 + self.AIO["safeArea_X"]*-1, -140 + self.AIO["safeArea_Y"]*-1, 30, 10, (1,1,1), "ammo_counter_riflebullet", 2, 0);
	self.HUD["BRAWL"]["BULLETS_3"] = self createRectangle("BOTTOM RIGHT", "BOTTOM RIGHT", -10 + self.AIO["safeArea_X"]*-1, -125 + self.AIO["safeArea_Y"]*-1, 30, 10, (1,1,1), "ammo_counter_riflebullet", 2, 0);
	self.HUD["BRAWL"]["BULLETS_4"] = self createRectangle("BOTTOM RIGHT", "BOTTOM RIGHT", -10 + self.AIO["safeArea_X"]*-1, -110 + self.AIO["safeArea_Y"]*-1, 30, 10, (1,1,1), "ammo_counter_riflebullet", 2, 0);
	self.HUD["BRAWL"]["BULLETS_5"] = self createRectangle("BOTTOM RIGHT", "BOTTOM RIGHT", -10 + self.AIO["safeArea_X"]*-1, -95 + self.AIO["safeArea_Y"]*-1, 30, 10, (1,1,1), "ammo_counter_riflebullet", 2, 0);
	self.HUD["BRAWL"]["BULLETS_6"] = self createRectangle("BOTTOM RIGHT", "BOTTOM RIGHT", -10 + self.AIO["safeArea_X"]*-1, -80 + self.AIO["safeArea_Y"]*-1, 30, 10, (1,1,1), "ammo_counter_riflebullet", 2, 0);
	self.HUD["BRAWL"]["BULLETS_7"] = self createRectangle("BOTTOM RIGHT", "BOTTOM RIGHT", -10 + self.AIO["safeArea_X"]*-1, -65 + self.AIO["safeArea_Y"]*-1, 30, 10, (1,1,1), "ammo_counter_riflebullet", 2, 0);
	
	while(1)
	{
		self waittill_any("REFRESH_HUDS","destroy_all_huds");

		if(level.gameEnded)
		{
			if(isDefined(self.HUD_boucherie)) self.HUD_boucherie AdvancedDestroy(self);
			if(isDefined(self.HUD["BRAWL"]["BULLETS_1"]))  self.HUD["BRAWL"]["BULLETS_1"] AdvancedDestroy(self);
			if(isDefined(self.HUD["BRAWL"]["BULLETS_2"]))  self.HUD["BRAWL"]["BULLETS_2"] AdvancedDestroy(self);
			if(isDefined(self.HUD["BRAWL"]["BULLETS_3"]))  self.HUD["BRAWL"]["BULLETS_3"] AdvancedDestroy(self);
			if(isDefined(self.HUD["BRAWL"]["BULLETS_4"]))  self.HUD["BRAWL"]["BULLETS_4"] AdvancedDestroy(self);
			if(isDefined(self.HUD["BRAWL"]["BULLETS_5"]))  self.HUD["BRAWL"]["BULLETS_5"] AdvancedDestroy(self);
			if(isDefined(self.HUD["BRAWL"]["BULLETS_6"]))  self.HUD["BRAWL"]["BULLETS_6"] AdvancedDestroy(self);
			if(isDefined(self.HUD["BRAWL"]["BULLETS_7"]))  self.HUD["BRAWL"]["BULLETS_7"] AdvancedDestroy(self);
			
		}
		else
		{
			if(isDefined(self.HUD_boucherie)) self.HUD_boucherie setPoint("BOTTOM RIGHT", "BOTTOM RIGHT", -10 + self.AIO["safeArea_X"]*-1, -10 + self.AIO["safeArea_Y"]*-1);
			
			if(isDefined(self.HUD["BRAWL"]["BULLETS_1"]))  self.HUD["BRAWL"]["BULLETS_1"] setPoint("BOTTOM RIGHT", "BOTTOM RIGHT", -10 + self.AIO["safeArea_X"]*-1, -155 + self.AIO["safeArea_Y"]*-1);
			if(isDefined(self.HUD["BRAWL"]["BULLETS_2"]))  self.HUD["BRAWL"]["BULLETS_2"] setPoint("BOTTOM RIGHT", "BOTTOM RIGHT", -10 + self.AIO["safeArea_X"]*-1, -140 + self.AIO["safeArea_Y"]*-1);
			if(isDefined(self.HUD["BRAWL"]["BULLETS_3"]))  self.HUD["BRAWL"]["BULLETS_3"] setPoint("BOTTOM RIGHT", "BOTTOM RIGHT", -10 + self.AIO["safeArea_X"]*-1, -125 + self.AIO["safeArea_Y"]*-1);
			if(isDefined(self.HUD["BRAWL"]["BULLETS_4"]))  self.HUD["BRAWL"]["BULLETS_4"] setPoint("BOTTOM RIGHT", "BOTTOM RIGHT", -10 + self.AIO["safeArea_X"]*-1, -110 + self.AIO["safeArea_Y"]*-1);
			if(isDefined(self.HUD["BRAWL"]["BULLETS_5"]))  self.HUD["BRAWL"]["BULLETS_5"] setPoint("BOTTOM RIGHT", "BOTTOM RIGHT", -10 + self.AIO["safeArea_X"]*-1, -95 + self.AIO["safeArea_Y"]*-1);
			if(isDefined(self.HUD["BRAWL"]["BULLETS_6"]))  self.HUD["BRAWL"]["BULLETS_6"] setPoint("BOTTOM RIGHT", "BOTTOM RIGHT", -10 + self.AIO["safeArea_X"]*-1, -80 + self.AIO["safeArea_Y"]*-1);
			if(isDefined(self.HUD["BRAWL"]["BULLETS_7"]))  self.HUD["BRAWL"]["BULLETS_7"] setPoint("BOTTOM RIGHT", "BOTTOM RIGHT", -10 + self.AIO["safeArea_X"]*-1, -65 + self.AIO["safeArea_Y"]*-1);
			
		}
	}
}

onEndGame()
{
	level waittill("game_ended");
	wait 1;
	for(a=0;a<level.players.size;a++){ level.players[a] setclientdvar("cg_drawGun",1);}		
}

BoucherieSpawn()
{
	R = randomInt(level.CustomSpawn.size);
	FinalSpawn = level.CustomSpawn[R];
	self.myVIEWW = level.CustomSpawnView[R];
	self spawn( FinalSpawn, self.myVIEWW);
}
Boucherie_HUD()
{
	 
	
}



CheckAmmo()
{
	self endon("disconnect");
	
	while(1)
	{
		self waittill("weapon_fired");
		
		if(self.bullet > 0)
			self.bullet--;
			
		if(self.bullet == 0)	
			self.HUD["BRAWL"]["BULLETS_7"].alpha = 0;

		if(self.bullet == 1)	
			self.HUD["BRAWL"]["BULLETS_6"].alpha = 0;
		
		if(self.bullet == 2)	
			self.HUD["BRAWL"]["BULLETS_5"].alpha = 0;
			
		if(self.bullet == 3)	
			self.HUD["BRAWL"]["BULLETS_4"].alpha = 0;
			
		if(self.bullet == 4)	
			self.HUD["BRAWL"]["BULLETS_3"].alpha = 0;
			
		if(self.bullet == 5)	
			self.HUD["BRAWL"]["BULLETS_2"].alpha = 0;
			
		if(self.bullet == 6)	
			self.HUD["BRAWL"]["BULLETS_1"].alpha = 0;
		
	}
}

onPlayerKilled(eInflictor, attacker, iDamage, s, sWeapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration)
{
	thread maps\mp\gametypes\_finalkills::onPlayerKilled(eInflictor, attacker, iDamage, s, sWeapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration);
		
	if(attacker != self)
	{
		attacker thread HUD_Kills(s);	
			
		if(attacker.bullet < 7)
		{
			attacker.bullet++;
		}
	}
}



ColorCor()
{
	
	self waittill("spawned_player");
	
	wait 2;
	
	self thread maps\mp\gametypes\_CJ_Functions::Color_correction("CC8");
	
}


StartBoucherie(attend)
{
	if(!level.inPrematchPeriod)
		return;
		
	self freezecontrols(true);
	
	if(!isDefined(self.BlackScreen)) self.BlackScreen = self createRectangle("center", "center", 0, 0, 960, 480, (0,0,0), "white", 20, 1);
	
	self playlocalsound("artillery_impact");
	
	self.BlackScreen fadeOverTime(3);
	self.BlackScreen.alpha = 0;
	
	if(!self.IN_MENU["AIO"] && !self.IN_MENU["RANK"] && !level.inPrematchPeriod)
	self freezecontrols(false);
}



Bouch_Welcome(C1,C2,C3,shader,Title,Text,glowColor,y)
{
	self endon("disconnect");

	self waittill("spawned_player");
	
	self playLocalSound("mp_last_stand");
	
	self.HNS_HUD[C1] = self createText("bigfixed", 2.2, "CENTER", "CENTER", 0, y, 1, 0, (1,1,1), Title, glowColor,1);

	
	self.HNS_HUD[C2] = self createRectangle("CENTER","CENTER", 0, -90, 100, 100, (1,1,1), shader, 1, 0);
	
	
	self.HNS_HUD["WEL_SHADER"] fadeOverTime(2);
	self.HNS_HUD["WEL_SHADER"].alpha = 0.80;
	self.HNS_HUD["WEL_TITLE"] fadeOverTime(2);
	self.HNS_HUD["WEL_TITLE"].alpha = 1;
	
	wait 4;
	
	self.HNS_HUD["WEL_SHADER"] fadeOverTime(2);
	self.HNS_HUD["WEL_SHADER"].alpha = 0;
	self.HNS_HUD["WEL_TITLE"] fadeOverTime(2);
	self.HNS_HUD["WEL_TITLE"].alpha = 0;

	
	wait 2;
	
	self.HNS_HUD["WEL_TITLE"] AdvancedDestroy(self);
	self.HNS_HUD["WEL_SHADER"] AdvancedDestroy(self);
	
}

BlurEffect()
{
	for(i=10;i>0;i--)
	{
		self setClientDvar( "r_blur", i );
		wait .8;
	}
}
HealthOverlayEffect()
{
	self endon("disconnect");
	
	while(1)
	{
		self.health = 2;
		wait .05;
		self.health = 1;
		wait .5;
	}
}



HUD_Kills(s)
{
	self notify("Boucherie_new_kill");
	self endon("Boucherie_new_kill");
	
	if(s == "MOD_MELEE")
	{
		r = "killiconmelee";
		y = 70;
		t = 50;
	}
	else if(s == "MOD_EXPLOSIVE")
	{
		r = "killicondied";
		y = 70;
		t = 50;
	}
	else
	{
		r = "hud_icon_desert_eagle";
		y = 90;
		t = 70;
	}
	if(isDefined(self.HUD_Kill[2]))
	{
		self.HUD_Kill[0] AdvancedDestroy(self);
		self.HUD_Kill[1] AdvancedDestroy(self);
		self.HUD_Kill[2] AdvancedDestroy(self);
	}
	
	self playLocalSound("mp_war_objective_taken");
	
	self.HUD_Kill[0] = self createRectangle("CENTER", "CENTER", 0, -145, 90, 60, (1,1,1), "black", 1, 1);
	self.HUD_Kill[1] = self createRectangle("CENTER", "CENTER", 0, -105, 90, 60, (0,0,0), "waypoint_captureneutral", 1, 1);
	self.HUD_Kill[2] = self createRectangle("CENTER", "CENTER", 0, -130, y, y, (1,1,1), r, 2, 1);
	
	self.HUD_Kill[0] ScaleOverTime( .2, 65, 40 );
	self.HUD_Kill[1] ScaleOverTime( .2, 65, 40 );
	self.HUD_Kill[2] ScaleOverTime( .2, t, t );
	
	wait .7;
	
	self.HUD_Kill[0] elemFade(2,0);
	self.HUD_Kill[1] elemFade(2,0);
	self.HUD_Kill[2] elemFade(2,0);
	
	wait 2;
	
	self.HUD_Kill[0] AdvancedDestroy(self);
	self.HUD_Kill[1] AdvancedDestroy(self);
	self.HUD_Kill[2] AdvancedDestroy(self);
	
	
	//elemMoveY(time, input){self moveOverTime(time);self.y=input;}
	//elemMoveX(time, input){self moveOverTime(time);self.x=input;}
	//{self fadeOverTime(time);self.alpha=alpha;}
}









initializeCustomSpawns()
{
	if(level.script == "mp_convoy")
	{
		level.CustomSpawn = [];
		level.CustomSpawnView = [];
		
		level.CustomSpawn[0] = (-2251,1338,-64);
/**/	level.CustomSpawnView[0] = (0,6,0);
		level.CustomSpawn[1] = (-1992,1018,-46);
/**/	level.CustomSpawnView[1] = (0,20,0);
		level.CustomSpawn[2] = (-1626,936,-70);
/**/	level.CustomSpawnView[2] = (0,134,0);
		level.CustomSpawn[3] = (-1514,821,-62);
/**/	level.CustomSpawnView[3] = (0,59,0);
		level.CustomSpawn[4] = (-1136,1076,-52);
/**/	level.CustomSpawnView[4] = (0,170,0);
		level.CustomSpawn[5] = (-523,1008,-62);
/**/	level.CustomSpawnView[5] = (0,180,0);
		level.CustomSpawn[6] = (-502,1291,-57);
/**/	level.CustomSpawnView[6] = (0,151,0);
		level.CustomSpawn[7] = (-506,2107,-35);
/**/	level.CustomSpawnView[7] = (0,-138,0);
		level.CustomSpawn[8] = (-1114,2073,-51);
/**/	level.CustomSpawnView[8] = (0,-91,0);
		level.CustomSpawn[9] = (-1998,1989,-35);
/**/	level.CustomSpawnView[9] = (0,-20,0);
		level.CustomSpawn[10] = (-755,1708,-6);
/**/	level.CustomSpawnView[10] = (0,-140,0);
		level.CustomSpawn[11] = (-1377,1560,-35);
/**/	level.CustomSpawnView[11] = (0,-33,0);
		level.CustomSpawn[12] = (-1936,1271,-57);
/**/	level.CustomSpawnView[12] = (0,28,0);
		level.CustomSpawn[13] = (-1538,1055,-67);
/**/	level.CustomSpawnView[13] = (0,139,0);
		level.CustomSpawn[14] = (-963,1173,-62);
/**/	level.CustomSpawnView[14] = (0,65,0);
		level.CustomSpawn[15] = (-880,1427,-68);
/**/	level.CustomSpawnView[15] = (0,-160,0);
		level.CustomSpawn[16] = (-1927,1760,8);
/**/	level.CustomSpawnView[16] = (0,-34,0);
		level.CustomSpawn[17] = (-1575,1956,-12);
/**/	level.CustomSpawnView[17] = (0,-63,0);
	
	}	
	if(level.script == "mp_backlot")
	{
		level.CustomSpawn = [];
		level.CustomSpawnView = [];
		
		level.CustomSpawn[0] = (-694,952,65);
/**/	level.CustomSpawnView[0] = (0,40,0);
		level.CustomSpawn[1] = (-305,947,69);
/**/	level.CustomSpawnView[1] = (0,155,0);
		level.CustomSpawn[2] = (-319,1219,65);
/**/	level.CustomSpawnView[2] = (0,150,0);
		level.CustomSpawn[3] = (-297,1571,65);
/**/	level.CustomSpawnView[3] = (0,131,0);
		level.CustomSpawn[4] = (-946,1075,80);
/**/	level.CustomSpawnView[4] = (0,45,0);
		level.CustomSpawn[5] = (-753,1358,80);
/**/	level.CustomSpawnView[5] = (0,-114,0);
		level.CustomSpawn[6] = (-943,1741,80);
/**/	level.CustomSpawnView[6] = (0,-38,0);
		level.CustomSpawn[7] = (-775,1736,80);
/**/	level.CustomSpawnView[7] = (0,-22,0);
		level.CustomSpawn[8] = (-288,1685,64);
/**/	level.CustomSpawnView[8] = (0,150,0);
		level.CustomSpawn[9] = (-287,2127,67);
/**/	level.CustomSpawnView[9] = (0,-119,0);
		level.CustomSpawn[10] = (-603,2128,64);
/**/	level.CustomSpawnView[10] = (0,-70,0);
		level.CustomSpawn[11] = (-803,1808,64);
/**/	level.CustomSpawnView[11] = (0,18,0);
		level.CustomSpawn[12] = (-692,2281,64);
/**/	level.CustomSpawnView[12] = (0,-98,0);
		level.CustomSpawn[13] = (-301,1412,64);
/**/	level.CustomSpawnView[13] = (0,148,0);
		level.CustomSpawn[14] = (-637,1352,64);
/**/	level.CustomSpawnView[14] = (0,-38,0);
		level.CustomSpawn[15] = (-688,1573,80);
/**/	level.CustomSpawnView[15] = (0,47,0);
		level.CustomSpawn[16] = (-318,1882,64);
/**/	level.CustomSpawnView[16] = (0,153,0);
		level.CustomSpawn[17] = (-690,1167,80);
/**/	level.CustomSpawnView[17] = (0,33,0);
		
	}
	if(level.script == "mp_bloc")
	{
		level.CustomSpawn = [];
		level.CustomSpawnView = [];
		
		level.CustomSpawn[0] = (1643,-5343,-23);
/**/	level.CustomSpawnView[0] = (0,-133,0);
		level.CustomSpawn[1] = (1636,-6286,-23);
/**/	level.CustomSpawnView[1] = (0,135,0);
		level.CustomSpawn[2] = (575,-6292,-23);
/**/	level.CustomSpawnView[2] = (0,46,0);
		level.CustomSpawn[3] = (566,-5353,-23);
/**/	level.CustomSpawnView[3] = (0,-33,0);
		level.CustomSpawn[4] = (1106,-5372,-23);
/**/	level.CustomSpawnView[4] = (0,-90,0);
		level.CustomSpawn[5] = (1615,-5813,-23);
/**/	level.CustomSpawnView[5] = (0,180,0);
		level.CustomSpawn[6] = (1102,-6269,-23);
/**/	level.CustomSpawnView[6] = (0,90,0);
		level.CustomSpawn[7] = (586,-5825,-23);
/**/	level.CustomSpawnView[7] = (0,-2,0);
		level.CustomSpawn[8] = (914,-5833,-20);
/**/	level.CustomSpawnView[8] = (0,148,0);
		level.CustomSpawn[9] = (1275,-5611,-23);
/**/	level.CustomSpawnView[9] = (0,24,0);
		level.CustomSpawn[10] = (1357,-6083,-23);
/**/	level.CustomSpawnView[10] = (0,85,0);
		level.CustomSpawn[11] = (726,-6109,-23);
/**/	level.CustomSpawnView[11] = (0,79,0);
		level.CustomSpawn[12] = (1006,-5998,-23);
/**/	level.CustomSpawnView[12] = (0,-46,0);
		level.CustomSpawn[13] = (943,-5939,-23);
/**/	level.CustomSpawnView[13] = (0,128,0);
		level.CustomSpawn[14] = (678,-5520,-23);
/**/	level.CustomSpawnView[14] = (0,-8,0);
		level.CustomSpawn[15] = (1351,-5373,-23);
/**/	level.CustomSpawnView[15] = (0,-106,0);
		level.CustomSpawn[16] = (1257,-5858,-23);
/**/	level.CustomSpawnView[16] = (0,-9,0);
		level.CustomSpawn[17] = (803,-2361,-23);
/**/	level.CustomSpawnView[17] = (0,-96,0);
	}
	if(level.script == "mp_bog")
	{
		level.CustomSpawn = [];
		level.CustomSpawnView = [];
		
		level.CustomSpawn[0] = (4286,490,0);
/**/	level.CustomSpawnView[0] = (0,-33,0);
		level.CustomSpawn[1] = (4367,69,16);
/**/	level.CustomSpawnView[1] = (0,53,0);
		level.CustomSpawn[2] = (4694,400,3);
/**/	level.CustomSpawnView[2] = (0,-162,0);
		level.CustomSpawn[3] = (4603,100,14);
/**/	level.CustomSpawnView[3] = (0,21,0);
		level.CustomSpawn[4] = (5985,-243,5);
/**/	level.CustomSpawnView[4] = (0,148,0);
		level.CustomSpawn[5] = (5898,127,32);
/**/	level.CustomSpawnView[5] = (0,-152,0);
		level.CustomSpawn[6] = (5674,255,2);
/**/	level.CustomSpawnView[6] = (0,-161,0);
		level.CustomSpawn[7] = (5537,-301,10);
/**/	level.CustomSpawnView[7] = (0,125,0);
		level.CustomSpawn[8] = (5409,329,2);
/**/	level.CustomSpawnView[8] = (0,-151,0);
		level.CustomSpawn[9] = (4850,-99,18);
/**/	level.CustomSpawnView[9] = (0,62,0);
		level.CustomSpawn[10] = (4786,3,13);
/**/	level.CustomSpawnView[10] = (0,134,0);
		level.CustomSpawn[11] = (4966,357,2);
/**/	level.CustomSpawnView[11] = (0,-151,0);
		level.CustomSpawn[12] = (5264,45,2);
/**/	level.CustomSpawnView[12] = (0,-37,0);
		level.CustomSpawn[13] = (5231,-311,24);
/**/	level.CustomSpawnView[13] = (0,104,0);
		level.CustomSpawn[14] = (5038,-205,18);
/**/	level.CustomSpawnView[14] = (0,100,0);
		level.CustomSpawn[15] = (5491,321,2);
/**/	level.CustomSpawnView[15] = (0,-40,0);
		level.CustomSpawn[16] = (5147,98,2);
/**/	level.CustomSpawnView[16] = (0,134,0);
		level.CustomSpawn[17] = (4325,282,-5);
/**/	level.CustomSpawnView[17] = (0,79,0);
		
	}
	if(level.script == "mp_countdown")
	{
		level.CustomSpawn = [];
		level.CustomSpawnView = [];
		
		level.CustomSpawn[0] = (2293,943,-7);
/**/	level.CustomSpawnView[0] = (0,-90,0);
		level.CustomSpawn[1] = (2329,515,-7);
/**/	level.CustomSpawnView[1] = (0,90,0);
		level.CustomSpawn[2] = (1729,516,-1);
/**/	level.CustomSpawnView[2] = (0,60,0);
		level.CustomSpawn[3] = (1730,896,-7);
/**/	level.CustomSpawnView[3] = (0,58,0);
		level.CustomSpawn[4] = (2415,134,-6);
/**/	level.CustomSpawnView[4] = (0,-90,0);
		level.CustomSpawn[5] = (2425,-290,-6);
/**/	level.CustomSpawnView[5] = (0,90,0);
		level.CustomSpawn[6] = (2005,-284,-6);
/**/	level.CustomSpawnView[6] = (0,90,0);
		level.CustomSpawn[7] = (1843,111,-6);
/**/	level.CustomSpawnView[7] = (0,-48,0);
		level.CustomSpawn[8] = (-1790,56,-15);
/**/	level.CustomSpawnView[8] = (0,120,0);
		level.CustomSpawn[9] = (-1866,468,-15);
/**/	level.CustomSpawnView[9] = (0,-103,0);
		level.CustomSpawn[10] = (-2369,431,-15);
/**/	level.CustomSpawnView[10] = (0,-70,0);
		level.CustomSpawn[11] = (-2438,93,-15);
/**/	level.CustomSpawnView[11] = (0,45,0);
		level.CustomSpawn[12] = (-1622,1835,-9);
/**/	level.CustomSpawnView[12] = (0,-112,0);
		level.CustomSpawn[13] = (-1670,1430,-15);
/**/	level.CustomSpawnView[13] = (0,-115,0);
		level.CustomSpawn[14] = (-2177,1401,-15);
/**/	level.CustomSpawnView[14] = (0,93,0);
		level.CustomSpawn[15] = (-2217,1834,-15);
/**/	level.CustomSpawnView[15] = (0,-86,0);
		level.CustomSpawn[16] = (-1891,1812,-15);
/**/	level.CustomSpawnView[16] = (0,-72,0);
		level.CustomSpawn[17] = (-2034,1405,-15);
/**/	level.CustomSpawnView[17] = (0,62,0);
		level.CustomSpawn[18] = (-2154,266,-15);
/**/	level.CustomSpawnView[18] = (0,-4,0);
		level.CustomSpawn[19] = (2244,-246,-6);
/**/	level.CustomSpawnView[19] = (0,125,0);
		level.CustomSpawn[20] = (2211,124,-6);
/**/	level.CustomSpawnView[20] = (0,-106,0);
		level.CustomSpawn[21] = (2184,925,-7);
/**/	level.CustomSpawnView[21] = (0,-111,0);
		level.CustomSpawn[22] = (2140,510,-7);
/**/	level.CustomSpawnView[22] = (0,108,0);
	}
	if(level.script == "mp_crash")
	{
		level.CustomSpawn = [];
		level.CustomSpawnView = [];
		
		level.CustomSpawn[0] = (1818,-1002,344);
/**/	level.CustomSpawnView[0] = (0,125,0);
		level.CustomSpawn[1] = (1349,-537,344);
/**/	level.CustomSpawnView[1] = (0,-44,0);
		level.CustomSpawn[2] = (1337,-1004,344);
/**/	level.CustomSpawnView[2] = (0,42,0);
		level.CustomSpawn[3] = (1657,-859,344);
/**/	level.CustomSpawnView[3] = (0,-165,0);
		level.CustomSpawn[4] = (1802,-982,207);
/**/	level.CustomSpawnView[4] = (0,135,0);
		level.CustomSpawn[5] = (1392,-995,207);
/**/	level.CustomSpawnView[5] = (0,43,0);
		level.CustomSpawn[6] = (1400,-547,207);
/**/	level.CustomSpawnView[6] = (0,-41,0);
		level.CustomSpawn[7] = (1736,-547,207);
/**/	level.CustomSpawnView[7] = (0,-156,0);
		level.CustomSpawn[8] = (1453,-986,71);
/**/	level.CustomSpawnView[8] = (0,43,0);
		level.CustomSpawn[9] = (1820,-1000,71);
/**/	level.CustomSpawnView[9] = (0,140,0);
		level.CustomSpawn[10] = (1818,-537,71);
/**/	level.CustomSpawnView[10] = (0,-111,0);
		level.CustomSpawn[11] = (1395,-535,71);
/**/	level.CustomSpawnView[11] = (0,-60,0);
		level.CustomSpawn[12] = (1403,-736,207);
/**/	level.CustomSpawnView[12] = (0,36,0);
		level.CustomSpawn[13] = (1397,-796,207);
/**/	level.CustomSpawnView[13] = (0,-41,0);
		level.CustomSpawn[14] = (1809,-791,207);
/**/	level.CustomSpawnView[14] = (0,118,0);
		level.CustomSpawn[15] = (1817,-541,279);
/**/	level.CustomSpawnView[15] = (0,-117,0);
		level.CustomSpawn[16] = (1820,-678,343);
/**/	level.CustomSpawnView[16] = (0,-111,0);
		level.CustomSpawn[17] = (1594,-716,71);
/**/	level.CustomSpawnView[17] = (0,-90,0);
	}
	if(level.script == "mp_crossfire")
	{
		level.CustomSpawn = [];
		level.CustomSpawnView = [];
		
		level.CustomSpawn[0] = (3196,-3168,-137);
/**/	level.CustomSpawnView[0] = (0,-143,0);
		level.CustomSpawn[1] = (3073,-3386,-142);
/**/	level.CustomSpawnView[1] = (0,85,0);
		level.CustomSpawn[2] = (2965,-3564,-142);
/**/	level.CustomSpawnView[2] = (0,-157,0);
		level.CustomSpawn[3] = (2690,-3629,-136);
/**/	level.CustomSpawnView[3] = (0,-95,0);
		level.CustomSpawn[4] = (2405,-4099,-132);
/**/	level.CustomSpawnView[4] = (0,56,0);
		level.CustomSpawn[5] = (2528,-4172,-132);
/**/	level.CustomSpawnView[5] = (0,60,0);
		level.CustomSpawn[6] = (2655,-4260,-133);
/**/	level.CustomSpawnView[6] = (0,51,0);
		level.CustomSpawn[7] = (2964,-4046,-141);
/**/	level.CustomSpawnView[7] = (0,-141,0);
		level.CustomSpawn[8] = (3065,-4114,-140);
/**/	level.CustomSpawnView[8] = (0,-72,0);
		level.CustomSpawn[9] = (3215,-4195,-139);
/**/	level.CustomSpawnView[9] = (0,-169,0);
		level.CustomSpawn[10] = (2961,-4465,-134);
/**/	level.CustomSpawnView[10] = (0,60,0);
		level.CustomSpawn[11] = (3068,-4534,-134);
/**/	level.CustomSpawnView[11] = (0,60,0);
		level.CustomSpawn[12] = (3346,-4272,-137);
/**/	level.CustomSpawnView[12] = (0,-78,0);
		level.CustomSpawn[13] = (3189,-4585,-135);
/**/	level.CustomSpawnView[13] = (0,85,0);
		level.CustomSpawn[14] = (3509,-4375,-136);
/**/	level.CustomSpawnView[14] = (0,-140,0);
		level.CustomSpawn[15] = (3421,-4745,-135);
/**/	level.CustomSpawnView[15] = (0,109,0);
		level.CustomSpawn[16] = (2793,-3871,-142);
/**/	level.CustomSpawnView[16] = (0,-138,0);
		level.CustomSpawn[17] = (2961,-3562,-142);
/**/	level.CustomSpawnView[17] = (0,152,0);
		
		
		
		
	}
	if(level.script == "mp_citystreets")
	{
		level.CustomSpawn = [];
		level.CustomSpawnView = [];
		
		level.CustomSpawn[0] = (5311,-478,-47);
/**/	level.CustomSpawnView[0] = (0,66,0);
		level.CustomSpawn[1] = (6294,-121,0.2);
/**/	level.CustomSpawnView[1] = (0,-131,0);
		level.CustomSpawn[2] = (6054,-122,-1);
/**/	level.CustomSpawnView[2] = (0,-50,0);
		level.CustomSpawn[3] = (5497,-295,-135);
/**/	level.CustomSpawnView[3] = (0,42,0);
		level.CustomSpawn[4] = (5985,-289,-135);
/**/	level.CustomSpawnView[4] = (0,149,0);
		level.CustomSpawn[5] = (5991,406,-135);
/**/	level.CustomSpawnView[5] = (0,-123,0);
		level.CustomSpawn[6] = (5244,354,-127);
/**/	level.CustomSpawnView[6] = (0,-25,0);
		level.CustomSpawn[7] = (6252,497,0.2);
/**/	level.CustomSpawnView[7] = (0,180,0);
		level.CustomSpawn[8] = (5780,540,-124);
/**/	level.CustomSpawnView[8] = (0,-88,0);
		level.CustomSpawn[9] = (6457,-417,-2);
/**/	level.CustomSpawnView[9] = (0,176,0);
		level.CustomSpawn[10] = (5834,-484,-2);
/**/	level.CustomSpawnView[10] = (0,21,0);
		level.CustomSpawn[11] = (5210,-37,-127);
/**/	level.CustomSpawnView[11] = (0,29,0);
		level.CustomSpawn[12] = (5136,110,-127);
/**/	level.CustomSpawnView[12] = (0,-19,0);
		level.CustomSpawn[13] = (5623,356,-127);
/**/	level.CustomSpawnView[13] = (0,-37,0);
		level.CustomSpawn[14] = (5983,56,-135);
/**/	level.CustomSpawnView[14] = (0,143,0);
		level.CustomSpawn[15] = (5758,-282,-135);
/**/	level.CustomSpawnView[15] = (0,82,0);
		level.CustomSpawn[16] = (5305,-116,-127);
/**/	level.CustomSpawnView[16] = (0,-13,0);
		level.CustomSpawn[17] = (5403,347,-127);
/**/	level.CustomSpawnView[17] = (0,-119,0);
	}
	if(level.script == "mp_farm")
	{
		level.CustomSpawn = [];
		level.CustomSpawnView = [];
		
		level.CustomSpawn[0] = (1743,2477,218);
/**/	level.CustomSpawnView[0] = (0,-49,0);
		level.CustomSpawn[1] = (2550,2476,218);
/**/	level.CustomSpawnView[1] = (0,-127,0);
		level.CustomSpawn[2] = (2529,789,218);
/**/	level.CustomSpawnView[2] = (0,149,0);
		level.CustomSpawn[2] = (1722,792,218);
/**/	level.CustomSpawnView[3] = (0,50,0);
		level.CustomSpawn[4] = (1713,1781,218);
/**/	level.CustomSpawnView[4] = (0,62,0);
		level.CustomSpawn[5] = (1885,2219,218);
/**/	level.CustomSpawnView[5] = (0,-82,0);
		level.CustomSpawn[6] = (2231,2143,218);
/**/	level.CustomSpawnView[6] = (0,44,0);
		level.CustomSpawn[7] = (2137,2478,218);
/**/	level.CustomSpawnView[7] = (0,-87,0);
		level.CustomSpawn[8] = (2532,1625,216);
/**/	level.CustomSpawnView[8] = (0,-140,0);
		level.CustomSpawn[9] = (2405,1008,218);
/**/	level.CustomSpawnView[9] = (0,180,0);
		level.CustomSpawn[10] = (1980,1120,218);
/**/	level.CustomSpawnView[10] = (0,-134,0);
		level.CustomSpawn[11] = (1708,1349,218);
/**/	level.CustomSpawnView[11] = (0,8,0);
		level.CustomSpawn[12] = (2106,1628,213);
/**/	level.CustomSpawnView[12] = (0,59,0);
		level.CustomSpawn[13] = (1963,1944,218);
/**/	level.CustomSpawnView[13] = (0,-121,0);
		level.CustomSpawn[14] = (2289,1331,224);
/**/	level.CustomSpawnView[14] = (0,74,0);
		level.CustomSpawn[15] = (2080,793,218);
/**/	level.CustomSpawnView[15] = (0,13,0);
		//level.CustomSpawn[16] = (000,000,000);
		//level.CustomSpawnView[16] = (0,000,0);
		//level.CustomSpawn[17] = (000,000,000);
		//level.CustomSpawnView[17] = (0,000,0);
		
	}
	if(level.script == "mp_overgrown")
	{
		level.CustomSpawn = [];
		level.CustomSpawnView = [];
		
		
		level.CustomSpawn[0] = (809,537,-199);
/**/	level.CustomSpawnView[0] = (0,-8,0);
		level.CustomSpawn[1] = (1105,528,-280);
/**/	level.CustomSpawnView[1] = (0,-77,0);
		level.CustomSpawn[2] = (1516,600,-317);
/**/	level.CustomSpawnView[2] = (0,-118,0);
		level.CustomSpawn[2] = (1508,-23,-284);
/**/	level.CustomSpawnView[3] = (0,-170,0);
		level.CustomSpawn[4] = (924,-183,-281);
/**/	level.CustomSpawnView[4] = (0,15,0);
		level.CustomSpawn[5] = (1180,139,-318);
/**/	level.CustomSpawnView[5] = (0,106,0);
		level.CustomSpawn[6] = (967,-748,-255);
/**/	level.CustomSpawnView[6] = (0,62,0);
		level.CustomSpawn[7] = (1493,-696,-217);
/**/	level.CustomSpawnView[7] = (0,150,0);
		level.CustomSpawn[8] = (1173,-857,-341);
/**/	level.CustomSpawnView[8] = (0,-92,0);
		level.CustomSpawn[9] = (952,-1065,-322);
/**/	level.CustomSpawnView[9] = (0,-10,0);
		level.CustomSpawn[10] = (1350,-1071,-322);
/**/	level.CustomSpawnView[10] = (0,-177,0);
		level.CustomSpawn[11] = (797,-1467,-332);
/**/	level.CustomSpawnView[11] = (0,18,0);
		level.CustomSpawn[12] = (1273,-1483,-349);
/**/	level.CustomSpawnView[12] = (0,97,0);
		level.CustomSpawn[13] = (1025,-1839,-338);
/**/	level.CustomSpawnView[13] = (0,-175,0);
		level.CustomSpawn[14] = (747,-1470,-166);
/**/	level.CustomSpawnView[14] = (0,-73,0);
		level.CustomSpawn[15] = (767,-1963,-338);
/**/	level.CustomSpawnView[15] = (0,51,0);
		//level.CustomSpawn[16] = (000,000,000);
		//level.CustomSpawnView[16] = (0,000,0);
		//level.CustomSpawn[17] = (000,000,000);
		//level.CustomSpawnView[17] = (0,000,0);
	}
	if(level.script == "mp_pipeline")
	{
		level.CustomSpawn = [];
		level.CustomSpawnView = [];
		
		
		level.CustomSpawn[0] = (1141,3306,-71);
/**/	level.CustomSpawnView[0] = (0,-118,0);
		level.CustomSpawn[1] = (785,3119,-71);
/**/	level.CustomSpawnView[1] = (0,-85,0);
		level.CustomSpawn[2] = (1061,2130,-119);
/**/	level.CustomSpawnView[2] = (0,156,0);
		level.CustomSpawn[2] = (676,2177,-119);
/**/	level.CustomSpawnView[3] = (0,-17,0);
		level.CustomSpawn[4] = (749,1770,-119);
/**/	level.CustomSpawnView[4] = (0,106,0);
		level.CustomSpawn[5] = (754,1664,-119);
/**/	level.CustomSpawnView[5] = (0,-103,0);
		level.CustomSpawn[6] = (731,1207,-119);
/**/	level.CustomSpawnView[6] = (0,105,0);
		level.CustomSpawn[7] = (181,1273,-119);
/**/	level.CustomSpawnView[7] = (0,-40,0);
		level.CustomSpawn[8] = (160,888,-119);
/**/	level.CustomSpawnView[8] = (0,42,0);
		level.CustomSpawn[9] = (-510,1258,-119);
/**/	level.CustomSpawnView[9] = (0,-94,0);
		level.CustomSpawn[10] = (353,833,-119);
/**/	level.CustomSpawnView[10] = (0,-82,0);
		level.CustomSpawn[11] = (355,245,-183);
/**/	level.CustomSpawnView[11] = (0,14,0);
		level.CustomSpawn[12] = (721,396,-183);
/**/	level.CustomSpawnView[12] = (0,-60,0);
		level.CustomSpawn[13] = (1064,196,-183);
/**/	level.CustomSpawnView[13] = (0,163,0);
		level.CustomSpawn[14] = (1260,293,-87);
/**/	level.CustomSpawnView[14] = (0,-122,0);
		level.CustomSpawn[15] = (1208,-29,-87);
/**/	level.CustomSpawnView[15] = (0,84,0);
		level.CustomSpawn[16] = (441,1074,-119);
/**/	level.CustomSpawnView[16] = (0,-177,0);
		level.CustomSpawn[17] = (156,1170,-119);
/**/	level.CustomSpawnView[17] = (0,2,0);
	}
	if(level.script == "mp_showdown")
	{
		level.CustomSpawn = [];
		level.CustomSpawnView = [];
		
		
		level.CustomSpawn[0] = (-746,-483,16);
/**/	level.CustomSpawnView[0] = (0,17,0);
		level.CustomSpawn[1] = (-732,252,16);
/**/	level.CustomSpawnView[1] = (0,-70,0);
		level.CustomSpawn[2] = (-565,-294,0);
/**/	level.CustomSpawnView[2] = (0,86,0);
		level.CustomSpawn[2] = (535,-450,16);
/**/	level.CustomSpawnView[3] = (0,176,0);
		level.CustomSpawn[4] = (698,233,16);
/**/	level.CustomSpawnView[4] = (0,-96,0);
		level.CustomSpawn[5] = (698,-285,16);
/**/	level.CustomSpawnView[5] = (0,90,0);
		level.CustomSpawn[6] = (-495,467,0);
/**/	level.CustomSpawnView[6] = (0,-85,0);
		level.CustomSpawn[7] = (555,477,0);
/**/	level.CustomSpawnView[7] = (0,-169,0);
		level.CustomSpawn[8] = (576,72,0);
/**/	level.CustomSpawnView[8] = (0,176,0);
		level.CustomSpawn[9] = (-403,-304,0);
/**/	level.CustomSpawnView[9] = (0,21,0);
		level.CustomSpawn[10] = (-384,115,0);
/**/	level.CustomSpawnView[10] = (0,-102,0);
		level.CustomSpawn[11] = (-292,444,0);
/**/	level.CustomSpawnView[11] = (0,-171,0);
		level.CustomSpawn[12] = (4,566,16);
/**/	level.CustomSpawnView[12] = (0,-91,0);
		level.CustomSpawn[13] = (219,239,0);
/**/	level.CustomSpawnView[13] = (0,143,0);
		level.CustomSpawn[14] = (241,-261,0);
/**/	level.CustomSpawnView[14] = (0,27,0);
		level.CustomSpawn[15] = (-5,-528,16);
/**/	level.CustomSpawnView[15] = (0,90,0);
		//level.CustomSpawn[16] = (000,000,000);
		//level.CustomSpawnView[16] = (0,000,0);
		//level.CustomSpawn[17] = (000,000,000);
		//level.CustomSpawnView[17] = (0,000,0);
	}
	if(level.script == "mp_strike")
	{
		level.CustomSpawn = [];
		level.CustomSpawnView = [];
		
		
		level.CustomSpawn[0] = (1977,2637,16);
/**/	level.CustomSpawnView[0] = (0,-56,0);
		level.CustomSpawn[1] = (1972,1916,16);
/**/	level.CustomSpawnView[1] = (0,86,0);
		level.CustomSpawn[2] = (2153,2002,30);
/**/	level.CustomSpawnView[2] = (0,20,0);
		level.CustomSpawn[2] = (2254,2754,33);
/**/	level.CustomSpawnView[3] = (0,-76,0);
		level.CustomSpawn[4] = (2538,2781,37);
/**/	level.CustomSpawnView[4] = (0,-50,0);
		level.CustomSpawn[5] = (3338,2788,26);
/**/	level.CustomSpawnView[5] = (0,-176,0);
		level.CustomSpawn[6] = (3330,1929,20);
/**/	level.CustomSpawnView[6] = (0,112,0);
		level.CustomSpawn[7] = (2867,1916,27);
/**/	level.CustomSpawnView[7] = (0,100,0);
		level.CustomSpawn[8] = (2965,2426,20);
/**/	level.CustomSpawnView[8] = (0,45,0);
		level.CustomSpawn[9] = (2658,2488,20);
/**/	level.CustomSpawnView[9] = (0,-43,0);
		level.CustomSpawn[10] = (2474,2078,35);
/**/	level.CustomSpawnView[10] = (0,128,0);
		level.CustomSpawn[11] = (2790,2624,18);
/**/	level.CustomSpawnView[11] = (0,-77,0);
		level.CustomSpawn[12] = (2151,2344,23);
/**/	level.CustomSpawnView[12] = (0,-30,0);
		//level.CustomSpawn[13] = (000,000,000);
		//level.CustomSpawnView[13] = (0,000,0);
		//level.CustomSpawn[14] = (000,000,000);
		//level.CustomSpawnView[14] = (0,000,0);
		//level.CustomSpawn[15] = (000,000,000);
		//level.CustomSpawnView[15] = (0,000,0);
		//level.CustomSpawn[16] = (000,000,000);
		//level.CustomSpawnView[16] = (0,000,0);
		//level.CustomSpawn[17] = (000,000,000);
		//level.CustomSpawnView[17] = (0,000,0);
	}
	if(level.script == "mp_vacant")
	{
		level.CustomSpawn = [];
		level.CustomSpawnView = [];
		
		
		level.CustomSpawn[0] = (1615,626,-47);
/**/	level.CustomSpawnView[0] = (0,-159,0);
		level.CustomSpawn[1] = (934,581,-47);
/**/	level.CustomSpawnView[1] = (0,-5,0);
		level.CustomSpawn[2] = (889,167,-47);
/**/	level.CustomSpawnView[2] = (0,75,0);
		level.CustomSpawn[2] = (1304,264,-47);
/**/	level.CustomSpawnView[3] = (0,45,0);
		level.CustomSpawn[4] = (1632,326,-47);
/**/	level.CustomSpawnView[4] = (0,106,0);
		level.CustomSpawn[5] = (1434,179,-47);
/**/	level.CustomSpawnView[5] = (0,55,0);
		level.CustomSpawn[6] = (1637,48,-47);
/**/	level.CustomSpawnView[6] = (0,-92,0);
		level.CustomSpawn[7] = (1634,336,-47);
/**/	level.CustomSpawnView[7] = (0,87,0);
		level.CustomSpawn[8] = (1626,-611,-47);
/**/	level.CustomSpawnView[8] = (0,-92,0);
		level.CustomSpawn[9] = (1620,-928,-47);
/**/	level.CustomSpawnView[9] = (0,89,0);
		level.CustomSpawn[10] = (1400,-822,-47);
/**/	level.CustomSpawnView[10] = (0,55,0);
		level.CustomSpawn[11] = (1231,-876,-47);
/**/	level.CustomSpawnView[11] = (0,128,0);
		level.CustomSpawn[12] = (899,-919,-47);
/**/	level.CustomSpawnView[12] = (0,88,0);
		level.CustomSpawn[13] = (917,-600,-47);
/**/	level.CustomSpawnView[13] = (0,-90,0);
		level.CustomSpawn[14] = (892,-181,-47);
/**/	level.CustomSpawnView[14] = (0,2,0);
		level.CustomSpawn[15] = (1257,-174,-47);
/**/	level.CustomSpawnView[15] = (0,-177,0);
		level.CustomSpawn[16] = (964,82,-47);
/**/	level.CustomSpawnView[16] = (0,-31,0);
		level.CustomSpawn[17] = (1378,63,-47);
/**/	level.CustomSpawnView[17] = (0,-179,0);
	}
	if(level.script == "mp_cargoship")
	{
		level.CustomSpawn = [];
		level.CustomSpawnView = [];
		
		level.CustomSpawn[0] = (2471,449,176);
/**/	level.CustomSpawnView[0] = (0,-36,0);
		level.CustomSpawn[1] = (2468,-487,176);
/**/	level.CustomSpawnView[1] = (0,37,0);
		level.CustomSpawn[2] = (3379,-345,176);
/**/	level.CustomSpawnView[2] = (0,78,0);
		level.CustomSpawn[2] = (3448,277,176);
/**/	level.CustomSpawnView[3] = (0,-98,0);
		level.CustomSpawn[4] = (3762,226,212);
/**/	level.CustomSpawnView[4] = (0,-113,0);
		level.CustomSpawn[5] = (3722,-169,212);
/**/	level.CustomSpawnView[5] = (0,103,0);
		level.CustomSpawn[6] = (2828,6,176);
/**/	level.CustomSpawnView[6] = (0,2,0);
		level.CustomSpawn[7] = (2954,-210,176);
/**/	level.CustomSpawnView[7] = (0,-94,0);
		level.CustomSpawn[8] = (2941,210,176);
/**/	level.CustomSpawnView[8] = (0,91,0);
		level.CustomSpawn[9] = (3225,17,336);
/**/	level.CustomSpawnView[9] = (0,157,0);
		level.CustomSpawn[10] = (2877,177,336);
/**/	level.CustomSpawnView[10] = (0,-30,0);
		level.CustomSpawn[11] = (2722,-342,336);
/**/	level.CustomSpawnView[11] = (0,92,0);
		level.CustomSpawn[12] = (2719,325,336);
/**/	level.CustomSpawnView[12] = (0,-92,0);
		level.CustomSpawn[13] = (3345,218,336);
/**/	level.CustomSpawnView[13] = (0,-91,0);
		level.CustomSpawn[14] = (3329,-215,336);
/**/	level.CustomSpawnView[14] = (0,91,0);
		level.CustomSpawn[15] = (2840,13,336);
/**/	level.CustomSpawnView[15] = (0,-23,0);
		level.CustomSpawn[16] = (2834,-268,176);
/**/	level.CustomSpawnView[16] = (0,86,0);
		level.CustomSpawn[17] = (2530,-8,180);
/**/	level.CustomSpawnView[17] = (0,78,0);
	}
}






CreateArena()
{
	wait 5;
	
	iprintln("arena");
	
	if(level.script == "mp_convoy")
	{
		Platform = spawn("script_model",(-488,1449,-15));
		Platform setModel("me_corrugated_metal8x8");
		Platform.angles = (0,100,0);
		Platform = spawn("script_model",(-471,1356,-15));
		Platform setModel("me_corrugated_metal8x8");
		Platform.angles = (0,100,0);
		Platform = spawn("script_model",(-456,1264,-15));
		Platform setModel("me_corrugated_metal8x8");
		Platform.angles = (0,100,0);
		Platform = spawn("script_model",(-1791,929,-25));
		Platform setModel("me_corrugated_metal8x8");
		Platform.angles = (0,165,0);
		Platform = spawn("script_model",(-1705,905,-25));
		Platform setModel("me_corrugated_metal8x8");
		Platform.angles = (0,165,0);
		Platform = spawn("script_model",(-1644,888,-25));
		Platform setModel("me_corrugated_metal8x8");
		Platform.angles = (0,165,0);
		CreateInvisibleWall((-1820,918,-71), (-1598,864,-110));
		CreateInvisibleWall((-480,1476,-51), (-446,1277,-90));
	}
	if(level.script == "mp_backlot")
	{
		Platform = spawn("script_model",(-446,903,113));
		Platform setModel("me_corrugated_metal8x8");
		Platform.angles = (0,0,0);
		Platform = spawn("script_model",(-530,901,113));
		Platform setModel("me_corrugated_metal8x8");
		Platform.angles = (0,0,0);
		Platform = spawn("script_model",(-259,1510,80));
		Platform setModel("me_corrugated_metal8x8");
		Platform.angles = (0,90,0);
		Platform = spawn("script_model",(-257,1440,80));
		Platform setModel("me_corrugated_metal8x8");
		Platform.angles = (0,90,0);
		Platform = spawn("script_model",(-255,1379,80));
		Platform setModel("me_corrugated_metal8x8");
		Platform.angles = (0,90,0);
		Platform = spawn("script_model",(-261,1898,80));
		Platform setModel("me_corrugated_metal8x8");
		Platform.angles = (0,90,0);
		Platform = spawn("script_model",(-259,1953,80));
		Platform setModel("me_corrugated_metal8x8");
		Platform.angles = (0,90,0);
		CreateInvisibleWall((-243,1984,63), (-243,1867,20));
		CreateInvisibleWall((-243,1540,63), (-243,1367,20));
		CreateInvisibleWall((-530,887,68), (-431,887,25));
		 
	}
	if(level.script == "mp_bloc")
	{
		Platform = spawn("script_model",(1100,-6331,-28));
		Platform setModel("com_barrier_tall1");
		Platform.angles = (0,0,0);
		Platform = spawn("script_model",(1106,-5314,-28));
		Platform setModel("com_barrier_tall1");
		Platform.angles = (0,0,0);
		Platform = spawn("script_model",(1675,-5825,-28));
		Platform setModel("com_barrier_tall1");
		Platform.angles = (0,90,0);
		Platform = spawn("script_model",(531,-5825,-28));
		Platform setModel("com_barrier_tall1");
		Platform.angles = (0,90,0);
		CreateInvisibleWall((1696,-5773,-23), (1696,-5877,-60));
		CreateInvisibleWall((511,-5882,-23), (511,-5775,-60));
		CreateInvisibleWall((1162,-5305,-23), (1045,-5305,-60));
		CreateInvisibleWall((1045,-6343,-23), (1165,-6343,-60));
		
	}
	if(level.script == "mp_bog")
	{
		Platform = spawn("script_model",(5586,327,48));
		Platform setModel("me_corrugated_metal8x8");
		Platform.angles = (0,160,0);
		Platform = spawn("script_model",(5506,349,48));
		Platform setModel("me_corrugated_metal8x8");
		Platform.angles = (0,165,0);
		Platform = spawn("script_model",(4277,354,-6));
		Platform setModel("com_barrel_fire");
		Platform.angles = (0,165,0);
		CreateInvisibleWall((5627,328,2), (5485,372,-40));
		CreateInvisibleWall((4258,375,0), (4269,320,-40));
		
	}
	if(level.script == "mp_countdown")
	{
		Platform = spawn("script_model",(-1575,1677,-17));
		Platform setModel("com_barrier_tall1");
		Platform.angles = (0,90,0);
		Platform = spawn("script_model",(-1575,1560,-17));
		Platform setModel("com_barrier_tall1");
		Platform.angles = (0,90,0);
		Platform = spawn("script_model",(-1705,301,-17));
		Platform setModel("com_barrier_tall1");
		Platform.angles = (0,90,0);
		Platform = spawn("script_model",(-1705,185,-17));
		Platform setModel("com_barrier_tall1");
		Platform.angles = (0,90,0);
		Platform = spawn("script_model",(1772,-134,-10));
		Platform setModel("com_barrier_tall1");
		Platform.angles = (0,90,0);
		Platform = spawn("script_model",(1772,-24,-10));
		Platform setModel("com_barrier_tall1");
		Platform.angles = (0,90,0);
		Platform = spawn("script_model",(1691,666,-10));
		Platform setModel("com_barrier_tall1");
		Platform.angles = (0,90,0);
		Platform = spawn("script_model",(1691,775,-10));
		Platform setModel("com_barrier_tall1");
		Platform.angles = (0,90,0);
		Platform = spawn("script_model",(-1815,1343,-17));
		Platform setModel("com_barrier_tall1");
		Platform.angles = (0,0,0);
		Platform = spawn("script_model",(-1938,520,-17));
		Platform setModel("com_barrier_tall1");
		Platform.angles = (0,0,0);
		Platform = spawn("script_model",(1920,441,-9));
		Platform setModel("com_barrier_tall1");
		Platform.angles = (0,0,0);
		Platform = spawn("script_model",(2009,195,-9));
		Platform setModel("com_barrier_tall1");
		Platform.angles = (0,0,0);
		CreateInvisibleWall((-1697,134,-15), (-1697,352,-55));
		CreateInvisibleWall((-1905,512,-7), (-1977,512,-47));
		CreateInvisibleWall((-1848,1350,-7), (-1770,1350,-47));
		CreateInvisibleWall((-1570,1510,-15), (-1570,1728,-55));
		CreateInvisibleWall((1688,611,-7), (1688,828,-47));
		CreateInvisibleWall((1664,450,0), (1978,450,-40));
		CreateInvisibleWall((2050,189,2), (1962,189,-40));
		CreateInvisibleWall((1768,-188,-6), (1768,28,-46));
		
	}
	if(level.script == "mp_citystreets")
	{
		Platform = spawn("script_model",(5751,-518,45));
		Platform setModel("me_corrugated_metal8x8");
		Platform = spawn("script_model",(5711,-518,45));
		Platform setModel("me_corrugated_metal8x8");
		Platform = spawn("script_model",(5097,27,-83));
		Platform setModel("me_corrugated_metal8x8");
		Platform.angles = (0,90,0);
		Platform = spawn("script_model",(5097,107,-83));
		Platform setModel("me_corrugated_metal8x8");
		Platform.angles = (0,90,0);
		Platform = spawn("script_model",(5097,27,12));
		Platform setModel("me_corrugated_metal8x8");
		Platform.angles = (0,90,0);
		Platform = spawn("script_model",(5097,107,12));
		Platform setModel("me_corrugated_metal8x8");
		Platform.angles = (0,90,0); 
		Platform = spawn("script_model",(5097,45,80));
		Platform setModel("me_corrugated_metal4x4");
		Platform.angles = (0,90,0);
		Platform = spawn("script_model",(5097,93,80));
		Platform setModel("me_corrugated_metal4x4");
		Platform.angles = (0,90,0);
		Platform = spawn("script_model",(6062,572,45));
		Platform setModel("me_corrugated_metal8x8");
		Platform = spawn("script_model",(6152,572,45));
		Platform setModel("me_corrugated_metal8x8");
		CreateInvisibleWall((5080,128,-140), (5080,-0,-100));
		CreateInvisibleWall((5776,-524,-10), (5695,-524,30));
		CreateInvisibleWall((6128,580,-10), (6031,580,30));
	}
	if(level.script == "mp_farm")
	{
		Platform = spawn("script_model",(1585,1631,216));
		Platform setModel("vehicle_bulldozer");
		Platform.angles = (0,355,0);
		Platform = spawn("script_model",(1649,2441,214));
		Platform setModel("me_refrigerator");
		Platform.angles = (0,355,0);
		CreateInvisibleWall((1655,1573,221), (1655,1671,190));
		CreateInvisibleWall((1653,2460,218), (1653,2415,180));
	}
	if(level.script == "mp_overgrown")
	{
		Platform = spawn("script_model",(675,-2122,-338));
		Platform setModel("prop_misc_rock_boulder_05");
		Platform.angles = (0,355,0);	
		Platform = spawn("script_model",(629,-2042,-338));
		Platform setModel("prop_misc_rock_boulder_04");
		Platform.angles = (0,110,0);
		Platform = spawn("script_model",(790,-677,-172));
		Platform setModel("vehicle_uaz_hardtop_dsr");
		Platform.angles = (17.5,297,-30);
		Platform = spawn("script_model",(1652,-713,-181));
		Platform setModel("vehicle_uaz_hardtop_dsr");
		Platform.angles = (-25,55,0);
		Platform = spawn("script_model",(656,-1489,-168));
		Platform setModel("com_armoire_d");
		Platform.angles = (0,0,0);
		Platform = spawn("script_model",(669,535,-177));
		Platform setModel("vehicle_uaz_hardtop_dsr");
		Platform.angles = (0,72,0);
		CreateInvisibleWall((903,-778,-260), (774,-543,-144));
		CreateInvisibleWall((1581,-778,-220), (1731,-587,-80));
		CreateInvisibleWall((600,-1884,-266), (706,-2123,-340));
		CreateInvisibleWall((648,-1446,-200), (656,-1524,-150));
		CreateInvisibleWall((775,-1103,-190), (821,-1041,-230));
		CreateInvisibleWall((689,471,-170), (707,598,-200));
	}
	if(level.script == "mp_pipeline")
	{
		Platform = spawn("script_model",(1463,96,41));
		Platform setModel("me_corrugated_metal8x8");
		Platform.angles = (0,0,90);	
		Platform = spawn("script_model",(1501,122,41));
		Platform setModel("me_corrugated_metal8x8");
		Platform.angles = (0,0,90);	
		Platform = spawn("script_model",(1507,169,41));
		Platform setModel("me_corrugated_metal8x8");
		Platform.angles = (0,0,90);	
		Platform = spawn("script_model",(1472,172,41));
		Platform setModel("me_corrugated_metal8x8");
		Platform.angles = (0,0,90);	
		Platform = spawn("script_model",(-511,1489,-1));
		Platform setModel("me_corrugated_metal8x8");
		Platform.angles = (0,0,90);	
		Platform = spawn("script_model",(-511,1408,-1));
		Platform setModel("me_corrugated_metal8x8");
		Platform.angles = (0,0,90);	
		Platform = spawn("script_model",(-511,1316,-1));
		Platform setModel("me_corrugated_metal8x8");
		Platform.angles = (0,0,90);	
		Platform = spawn("script_model",(993,3291,47));
		Platform setModel("me_corrugated_metal8x8");
		Platform.angles = (0,0,90);	
		Platform = spawn("script_model",(1111,3305,47));
		Platform setModel("me_corrugated_metal8x8");
		Platform.angles = (0,0,90);	
		Platform = spawn("script_model",(1061,3305,47));
		Platform setModel("me_corrugated_metal8x8");
		Platform.angles = (0,0,90);		
		
		CreateInvisibleWall((1000,3312,-76), (1000,3249,30));
		CreateInvisibleWall((-495,1414,-100), (-549,1414,0));
		CreateInvisibleWall((1521,148,-47), (1483,148,30));
		 
	}
	if(level.script == "mp_showdown")
	{
		Platform = spawn("script_model",(-35,-622,15));
		Platform setModel("ch_crate64x64");
		Platform.angles = (0,25,0);	
		Platform = spawn("script_model",(-730,411,86));
		Platform setModel("com_wagon_donkey");
		Platform.angles = (0,77,0);	
		Platform = spawn("script_model",(-814,160,14));
		Platform setModel("me_dumpster");
		Platform.angles = (0,0,0);	
		Platform = spawn("script_model",(869,-227,16));
		Platform setModel("vehicle_bulldozer");
		Platform.angles = (0,265,0);	
		Platform = spawn("script_model",(725,-487,100));
		Platform setModel("me_basket_rattan02");
		Platform.angles = (0,0,0);	
		Platform = spawn("script_model",(-35,687,15));
		Platform setModel("ch_crate64x64");
		Platform.angles = (0,25,0);	
		
		CreateInvisibleWall((850,-157,16), (850,-296,-15));
		CreateInvisibleWall((-2,-598,16), (-66,-599,-15));
		CreateInvisibleWall((729,-444,125), (729,-506,70));
		CreateInvisibleWall((-807,89,16), (-807,241,-15));
		CreateInvisibleWall((-731,435,102), (-731,343,50));
		CreateInvisibleWall((-75,682,16), (1,689,-15));
		
	}
	if(level.script == "mp_strike")
	{
		Platform = spawn("script_model",(1922,2412,14));
		Platform setModel("vehicle_80s_sedan1_green_destroyed");
		Platform.angles = (0,240,0);
		Platform = spawn("script_model",(1914,2302,74));
		Platform setModel("vehicle_80s_sedan1_reddest");
		Platform.angles = (-20,107,-170);
		Platform = spawn("script_model",(2365,1873,17));
		Platform setModel("com_propane_tank");
		Platform.angles = (0,0,0);
		CreateInvisibleWall((1914,2470,16), (1924,2255,-15));
		CreateInvisibleWall((2334,1858,16), (2376,855,-15));
	}
	if(level.script == "mp_vacant")
	{
		Platform = spawn("script_model",(1192,685,-48));
		Platform setModel("com_locker_double");
		Platform.angles = (0,0,0);
		Platform = spawn("script_model",(1169,685,-48));
		Platform setModel("com_locker_double");
		Platform.angles = (0,0,0);
		Platform = spawn("script_model",(1145,685,-48));
		Platform setModel("com_locker_double");
		Platform.angles = (0,0,0);
		Platform = spawn("script_model",(1121,685,-48));
		Platform setModel("com_locker_double");
		Platform.angles = (0,0,0);
		Platform = spawn("script_model",(1098,685,-48));
		Platform setModel("com_locker_double");
		Platform.angles = (0,0,0);
		Platform = spawn("script_model",(820,-652,-49));
		Platform setModel("ch_furniture_teachers_desk1");
		Platform.angles = (0,65,0);
		Platform = spawn("script_model",(851,-696,-27));
		Platform setModel("ch_furniture_teachers_desk1");
		Platform.angles = (-5,5,27);
		CreateInvisibleWall((1103,703,-47), (1213,703,-87));
		CreateInvisibleWall((842,-744,-47), (842,-647,-87));
	}
	if(level.script == "mp_cargoship")
	{
		Platform = spawn("script_model",(2580,636,173));
		Platform setModel("com_restaurantstainlessteelshelf_02");
		Platform.angles = (-45,80,-20);
		Platform = spawn("script_model",(2565,-638,182));
		Platform setModel("com_restaurantstainlessteelshelf_02");
		Platform.angles = (25,50,-27);
		CreateInvisibleWall((2562,610,176), (2559,645,150));
		CreateInvisibleWall((2562,-610,176), (2561,-645,150));
	}
}

PrecacheModelsForMap()
{
	if(level.script == "mp_convoy")
	{
		PrecacheModel("me_corrugated_metal8x8");
	}
	if(level.script == "mp_backlot")
	{
		PrecacheModel("me_corrugated_metal8x8");
	}
	if(level.script == "mp_crash")
	{
		PrecacheModel("com_signal_light_pole");
		PrecacheModel("com_laptop_2_open");
	}
	if(level.script == "mp_bloc")
	{
		PrecacheModel("com_barrier_tall1");
	}
	if(level.script == "mp_bog")
	{
		PrecacheModel("me_corrugated_metal8x8");
		PrecacheModel("com_barrel_fire");
	}
	if(level.script == "mp_countdown")
	{
		PrecacheModel("com_plasticcase_green_big");
		PrecacheModel("ch_crate32x48");
		PrecacheModel("vehicle_bmp_dsty_static");
		PrecacheModel("com_barrier_tall1");
	}
	if(level.script == "mp_citystreets")
	{
		PrecacheModel("me_corrugated_metal8x8");
		PrecacheModel("me_corrugated_metal2x8");
		PrecacheModel("me_corrugated_metal4x8");
		PrecacheModel("me_corrugated_metal4x4");
		PrecacheModel("me_corrugated_metal2x4");
		PrecacheModel("vehicle_delivery_truck");
	}
	if(level.script == "mp_farm")
	{
		PrecacheModel("vehicle_bulldozer");
		PrecacheModel("me_refrigerator");
	}
	if(level.script == "mp_overgrown")
	{
		PrecacheModel("prop_misc_rock_boulder_05");
		PrecacheModel("prop_misc_rock_boulder_04");
		PrecacheModel("vehicle_uaz_hardtop_dsr");
		PrecacheModel("com_armoire_d");
	}
	if(level.script == "mp_pipeline")
	{
		PrecacheModel("me_corrugated_metal8x8");
	}
	if(level.script == "mp_showdown")
	{
		PrecacheModel("ch_crate64x64");
		PrecacheModel("com_wagon_donkey");
		PrecacheModel("vehicle_bulldozer");
		PrecacheModel("me_dumpster");
		PrecacheModel("me_basket_rattan02");
	}
	if(level.script == "mp_strike")
	{
		PrecacheModel("vehicle_80s_sedan1_green_destroyed");
		PrecacheModel("vehicle_80s_sedan1_reddest");
		PrecacheModel("com_propane_tank");
	}
	if(level.script == "mp_vacant")
	{
		PrecacheModel("com_locker_double");
		PrecacheModel("ch_furniture_teachers_desk1");
	}
	if(level.script == "mp_cargoship")
	{
		PrecacheModel("com_restaurantstainlessteelshelf_02");
	}
}

roundup(floatVal)
{
	if ( int( floatVal ) != floatVal )
		return int( floatVal+1 );
	else
		return int( floatVal );
}


CreateInvisibleWall(start, end)
{	
	blockcol1 = [];
	blockcol2 = [];
	blockcol3 = [];
	
	D = Distance((start[0], start[1], 0), (end[0], end[1], 0));
	H = Distance((0, 0, start[2]), (0, 0, end[2]));
	
	blocks = roundup(D/55);
	height = roundup(H/30);
	
	CX = end[0] - start[0];
	CY = end[1] - start[1];
	CZ = end[2] - start[2];
	
	XA = (CX/blocks);
	YA = (CY/blocks);
	ZA = (CZ/height);
	
	TXA = (XA/4);
	TYA = (YA/4);
	Temp = VectorToAngles(end - start);
	Angle = (0, Temp[1], 90);
	
	for(h=0;h<height;h++)
	{
		blockcol1[0] = spawn( "trigger_radius", ((start + (TXA, TYA, 10) + ((0, 0, ZA) * h)) + (14, 0, 0)), 0, 32, 32 );
		blockcol1[1] = spawn( "trigger_radius", ((start + (TXA, TYA, 10) + ((0, 0, ZA) * h)) + (-14, 0, 0)), 0, 32, 32 );
		
		for(i=0;i<=2;i++)
		{	
			blockcol1[i].angles = (0,0,0);
			blockcol1[i] setContents( 1 );
		}
		
		wait .05;
		
		for(i=1;i<blocks;i++)
		{
			blockcol2[0] = spawn( "trigger_radius", ((start + ((XA, YA, 0) * i) + (0, 0, 10) + ((0, 0, ZA) * h)) + (14, 0, 0)), 0, 32, 32 );
			blockcol2[1] = spawn( "trigger_radius", ((start + ((XA, YA, 0) * i) + (0, 0, 10) + ((0, 0, ZA) * h)) + (-14, 0, 0)), 0, 32, 32 );
			for(j = 0; j <= 2; j++)
			{	blockcol2[j].angles = (0,0,0);
				blockcol2[j] setContents( 1 );	
			}
			
			wait 0.001;
		}
	
		blockcol3[0] = spawn( "trigger_radius", (((end[0], end[1], start[2]) + (TXA * -1, TYA * -1, 10) + ((0, 0, ZA) * h)) + (14, 0, 0)), 0, 32, 32 );
		blockcol3[1] = spawn( "trigger_radius", (((end[0], end[1], start[2]) + (TXA * -1, TYA * -1, 10) + ((0, 0, ZA) * h)) + (-14, 0, 0)), 0, 32, 32 );
		
		for(i=0;i<=2;i++)
		{	
			blockcol3[i].angles = (0,0,0);
			blockcol3[i] setContents(1);
		}
		wait .05;
	}
}











