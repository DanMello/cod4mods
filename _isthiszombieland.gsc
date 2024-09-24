#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include maps\mp\gametypes\_general_funcs;
#include maps\mp\gametypes\_NightmareME;


init()
{
	
	level thread onPlayerConnect();
	
	//level thread MapEdit();
	level.hardcoreMode = true;
	level.current_game_mode = "Is this zombieland ?!";
	level.gameModeDevName = "FUNNYZOMB";
	level deletePlacedEntity("misc_turret");
	
	
	
	level.ZL_game_state = "starting";
	level.ZombiesDeaths = 0;
	level.manches = 1;
	level.ZombiesObj = 7;
	level.manche_suivante = false;
	
	
	
	PrecacheShader("scorebar_ussr");
	PrecacheShader("weapon_fraggrenade");
	
	
	
	setDvar("mantle_enable","0");
	setDvar("ui_hud_showdeathicons", "0");
	setDvar("scr_game_hardpoints", "0");
	setdvar("scr_showperksonspawn", "0");
	
	while(!isDefined(level.inPrematchPeriod)) wait .05;
	
	//setDvar("ui_uav_allies",1);
	//setDvar("ui_uav_axis",1);
	
	game["strings"]["change_class"] = "";
	//game["strings"]["axis_name"] = "";
	//game["strings"]["allies_name"] = "";
	//game["dialog"]["gametype"] = undefined;
	game["music"]["spawn_axis"] = undefined;
	game["music"]["spawn_allies"] = undefined;
	
	//level thread doInit();
	level thread ZombielandLogics();
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

	//self.isZombie = 0;
	self.human_score = 500;
	self.manche_animation = false;
	self.grenadepretes = 1;
	self.Human_setup = false;
	self.playerSpawnedOK = false;
	self.playerHUDinitOK = false;
	self thread Zombieland_HUD();
	
	
	
	for(;;)
	{
		
		
		self waittill("spawned_player");
		 
		self thread HumanSetup();
	}
}

HintText()
{
	MiddleText = self createFontString("default", 1.4);
	MiddleText setPoint("CENTER", "CENTER");
	self.hint = "";
	
	for(;;)
	{
		MiddleText setText(self.hint);
		self.hint = "";
		wait .4;
	}
}
HumanSetup()
{
	self endon("death");
	
	
	self thread GrenadeTracking();
	self thread HintText();

	if(!isDefined(self.HUD["NM"]["GRENADE"][1]))
		self.HUD["NM"]["GRENADE"][1] = self createRectangle("CENTER", "BOTTOM RIGHT", -20 + self.AIO["safeArea_X"]*-1, -5 + self.AIO["safeArea_Y"]*-1, 30, 30, (1,1,1), "weapon_fraggrenade", 2, 1);

	if(!isDefined(self.HUD["NM"]["GRENADE"][2]))
		self.HUD["NM"]["GRENADE"][2] = self createRectangle("CENTER", "BOTTOM RIGHT", -40 + self.AIO["safeArea_X"]*-1, -5 + self.AIO["safeArea_Y"]*-1, 30, 30, (1,1,1), "weapon_fraggrenade", 2, 0);

	if(!isDefined(self.HUD["NM"]["GRENADE"][3]))
		self.HUD["NM"]["GRENADE"][3] = self createRectangle("CENTER", "BOTTOM RIGHT", -60 + self.AIO["safeArea_X"]*-1, -5 + self.AIO["safeArea_Y"]*-1, 30, 30, (1,1,1), "weapon_fraggrenade", 2, 0);

	if(!isDefined(self.HUD["NM"]["GRENADE"][4]))
		self.HUD["NM"]["GRENADE"][4] = self createRectangle("CENTER", "BOTTOM RIGHT", -80 + self.AIO["safeArea_X"]*-1, -5 + self.AIO["safeArea_Y"]*-1, 30, 30, (1,1,1), "weapon_fraggrenade", 2, 0);

	
	if(!isDefined(self.HUD_text["AMMO"]["CLIP"]))	
	self.HUD_text["AMMO"]["CLIP"] = self createText("default",2,"CENTER","BOTTOM RIGHT",-60 + self.AIO["safeArea_X"]*-1,-35 + self.AIO["safeArea_Y"]*-1,2,1,(1,1,1),"");
	
	if(!isDefined(self.HUD_text["AMMO"]["SEP"]))
	self.HUD_text["AMMO"]["SEP"] = self createText("default",2,"CENTER","BOTTOM RIGHT",-40 + self.AIO["safeArea_X"]*-1,-35 + self.AIO["safeArea_Y"]*-1,2,1,(1,1,1),"/");
	
	if(!isDefined(self.HUD_text["AMMO"]["STOCK"]))
	self.HUD_text["AMMO"]["STOCK"] = self createText("default",2,"CENTER","BOTTOM RIGHT",-20 + self.AIO["safeArea_X"]*-1,-35 + self.AIO["safeArea_Y"]*-1,2,1,(1,1,1),"");
	



	while(1)
	{
		weapon = self getCurrentWeapon();
		ammoClip = self getWeaponAmmoClip(weapon);
		ammoStock = self getWeaponAmmoStock(weapon);
		
		self.HUD_text["AMMO"]["CLIP"] setValue(ammoClip);
		self.HUD_text["AMMO"]["STOCK"] setValue(ammoStock);
		
		wait .05;
	}
}

doZombieSetup()
{
}
doZombie(alpha)  
{	
}
QuandTuMeurs(option)
{	
}
doInit()
{
}
doPickZombie()
{
}
doPregamez()
{	
}
doPlaying()
{	
}
doEnding()
{	
}






onPlayerKilled(eInflictor, attacker, iDamage, s, sWeapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration)
{
	
}

ZombielandLogics()
{
	level endon("game_ended");
	
	for(;;)
	{
		wait 60;
		
		//while(level.manche_suivante) wait .05;
			
			
			level.manches+=1;
			//iprintln("changement "+level.manches);
			
			for(i=0;i<level.players.size;i++)
				if(!level.players[i].manche_animation && level.players[i].playerSpawnedOK && level.players[i].playerHUDinitOK)
					level.players[i] thread MancheAnimation();
	}
			
}

HealthOverlayEffect()
{
	self endon("disconnect");
	
	while(level.inPrematchPeriod)
	{
		self.health = 2;
		wait .05;
		self.health = 1;
		wait .5;
	}
	
	self.health = self.maxhealth;
}
Zombieland_HUD()
{
	self setClientDvar("g_ScoresColor_Axis","0 0 0 0");
	self setClientDvar("g_ScoresColor_Allies","0 0 0 0");
	self setClientDvar("cg_scoreboardMyColor","1 0 0 1");
	
	self waittill("spawned_player");
	
	self.playerSpawnedOK = true;
	
	
	if(isDefined(level.inPrematchPeriod) && level.inPrematchPeriod)
		self thread HealthOverlayEffect();
	
	Haut = -50;
	
	self.HUD["ZL"]["CUR_POINTS_SHADER"] = self createRectangle("BOTTOM RIGHT", "BOTTOM RIGHT", -20 + self.AIO["safeArea_X"], -20 + Haut + self.AIO["safeArea_Y"]*-1, 60, 13, (1,0,0), "scorebar_ussr", 2, 1);
	self.HUD["ZL"]["CUR_POINTS"] =  self createText( "default", 1.6, "BOTTOM RIGHT", "BOTTOM RIGHT", -30 + self.AIO["safeArea_X"], -17 + Haut + self.AIO["safeArea_Y"]*-1, 3, 1, (1,1,1));
	self.HUD["ZL"]["CUR_POINTS"] setValue(self.human_score);
	
	self playlocalsound("mp_suspense_04"); 
	
	wait 1;
	
	Batons = strTok(" ,|,||,|||,||||,||||,|||| |,|||| ||,|||| |||,|||| ||||,|||| ||||,11",",");

	
	if(isDefined(level.inPrematchPeriod) && level.inPrematchPeriod)
	{
		self.HUD["ZL"]["MANCHE_TEXT_BLANC"] = self createText( "objective", 3, "CENTER", "CENTER", 0, -50, 2, 1, (1,1,1), "Round");
		self.HUD["ZL"]["MANCHE_TEXT"] = self createText( "objective", 3, "CENTER", "CENTER", 0, -50, 1, 1, (1,0,0), "Round");
		
		self.HUD["ZL"]["MANCHE_TEXT_BLANC"] hudFade(0,3);
		self.HUD["ZL"]["MANCHE_TEXT"] hudFade(0,1.5);
	}
	
	
	if(level.manches < 12)
		self.HUD["ZL"]["MANCHE_BLANCHE"] = self createText( "objective", 3, "BOTTOM LEFT", "BOTTOM LEFT", 10, -10, 1, 1, (1,1,1), Batons[level.manches]);
	else
		self.HUD["ZL"]["MANCHE_BLANCHE"] = self createText( "objective", 3, "BOTTOM LEFT", "BOTTOM LEFT", 10, -10, 1, 1, (1,1,1), level.manches);
	
	if(level.manches >= 5 && level.manches < 11 && !isDefined(self.HUD["ZL"]["MANCHE_5EME_BLANCHE"]))
		self.HUD["ZL"]["MANCHE_5EME_BLANCHE"] = self createText( "objective", 3, "BOTTOM LEFT", "BOTTOM LEFT", 20, -10, 3, 1, (1,1,1), "/");
			
	if(level.manches >= 10 && level.manches < 11 && !isDefined(self.HUD["ZL"]["MANCHE_10EME_BLANCHE"]))
		self.HUD["ZL"]["MANCHE_10EME_BLANCHE"] = self createText( "objective", 3, "BOTTOM LEFT", "BOTTOM LEFT", 70, -10, 3, 1, (1,1,1), "/");
		 
	
	if(level.manches < 12)
		self.HUD["ZL"]["MANCHE_GLOBAL"] = self createText( "objective", 3, "BOTTOM LEFT", "BOTTOM LEFT", 10, -10, 2, 0, (1,0,0), Batons[level.manches]);
	else
		self.HUD["ZL"]["MANCHE_GLOBAL"] = self createText( "objective", 3, "BOTTOM LEFT", "BOTTOM LEFT", 10, -10, 2, 0, (1,0,0), level.manches);
	
	if(level.manches >= 5 && level.manches < 11 && !isDefined(self.HUD["ZL"]["MANCHE_5EME"]))
		self.HUD["ZL"]["MANCHE_5EME"] = self createText( "objective", 3, "BOTTOM LEFT", "BOTTOM LEFT", 20, -10, 4, 0, (1,0,0), "/");
		
	if(level.manches >= 10 && level.manches < 11 && !isDefined(self.HUD["ZL"]["MANCHE_10EME"]))
		self.HUD["ZL"]["MANCHE_10EME"] = self createText( "objective", 3, "BOTTOM LEFT", "BOTTOM LEFT", 70, -10, 4, 0, (1,0,0), "/");
		
		
		
	
		
	self.HUD["ZL"]["MANCHE_GLOBAL"] elemFade(3,1);
	
	if(isDefined(self.HUD["ZL"]["MANCHE_5EME"]))	
		self.HUD["ZL"]["MANCHE_5EME"] elemFade(3,1);
	
	if(isDefined(self.HUD["ZL"]["MANCHE_10EME"]))	
		self.HUD["ZL"]["MANCHE_10EME"] elemFade(3,1);
		
		
		
		
	self.HUD["ZL"]["MANCHE_BLANCHE"] AdvancedDestroy(self);
	
	if(isDefined(self.HUD["ZL"]["MANCHE_5EME_BLANCHE"]))	
		self.HUD["ZL"]["MANCHE_5EME_BLANCHE"] AdvancedDestroy(self);
	
	if(isDefined(self.HUD["ZL"]["MANCHE_10EME_BLANCHE"]))	
		self.HUD["ZL"]["MANCHE_10EME_BLANCHE"] AdvancedDestroy(self);
	
		
	self.playerHUDinitOK = true;
		
	while(1)
	{
		self waittill_any("REFRESH_HUDS","destroy_all_huds");

		if(level.gameEnded)
		{
			if(isDefined(self.HUD["ZL"]["CUR_POINTS_SHADER"])) self.HUD["ZL"]["CUR_POINTS_SHADER"] AdvancedDestroy(self);
			if(isDefined(self.HUD["ZL"]["CUR_POINTS"])) self.HUD["ZL"]["CUR_POINTS"] AdvancedDestroy(self);
			if(isDefined(self.HUD["ZL"]["MANCHE_TEXT_BLANC"])) self.HUD["ZL"]["MANCHE_TEXT_BLANC"] AdvancedDestroy(self);
			if(isDefined(self.HUD["ZL"]["MANCHE_TEXT"])) self.HUD["ZL"]["MANCHE_TEXT"] AdvancedDestroy(self);
			if(isDefined(self.HUD["ZL"]["MANCHE_BLANCHE"])) self.HUD["ZL"]["MANCHE_BLANCHE"] AdvancedDestroy(self);
			if(isDefined(self.HUD["ZL"]["MANCHE_GLOBAL"])) self.HUD["ZL"]["MANCHE_GLOBAL"] AdvancedDestroy(self);
			if(isDefined(self.HUD["ZL"]["MANCHE_5EME_BLANCHE"])) self.HUD["ZL"]["MANCHE_5EME_BLANCHE"] AdvancedDestroy(self);
			if(isDefined(self.HUD["ZL"]["MANCHE_5EME"])) self.HUD["ZL"]["MANCHE_5EME"] AdvancedDestroy(self);
			if(isDefined(self.HUD["ZL"]["MANCHE_10EME_BLANCHE"])) self.HUD["ZL"]["MANCHE_10EME_BLANCHE"] AdvancedDestroy(self);
			if(isDefined(self.HUD["ZL"]["MANCHE_10EME"])) self.HUD["ZL"]["MANCHE_10EME"]AdvancedDestroy(self);
			if(isDefined(self.HUD_text["AMMO"]["CLIP"])) self.HUD_text["AMMO"]["CLIP"] AdvancedDestroy(self);
			if(isDefined(self.HUD_text["AMMO"]["SEP"])) self.HUD_text["AMMO"]["SEP"] AdvancedDestroy(self);
			if(isDefined(self.HUD_text["AMMO"]["STOCK"])) self.HUD_text["AMMO"]["STOCK"] AdvancedDestroy(self);
			
			for(i=1;i<5;i++)
				if(isDefined(self.HUD["NM"]["GRENADE"][i])) self.HUD["NM"]["GRENADE"][i] AdvancedDestroy(self);
				

		}
		else
		{
			/*
			if(isDefined())  setPoint("", "",  0 + self.AIO["safeArea_X"], 0 + self.AIO["safeArea_Y"]);
			if(isDefined())  setPoint("", "",  0 + self.AIO["safeArea_X"], 0 + self.AIO["safeArea_Y"]);
			if(isDefined())  setPoint("", "",  0 + self.AIO["safeArea_X"], 0 + self.AIO["safeArea_Y"]);
			if(isDefined())  setPoint("", "",  0 + self.AIO["safeArea_X"], 0 + self.AIO["safeArea_Y"]);
			if(isDefined())  setPoint("", "",  0 + self.AIO["safeArea_X"], 0 + self.AIO["safeArea_Y"]);
			if(isDefined())  setPoint("", "",  0 + self.AIO["safeArea_X"], 0 + self.AIO["safeArea_Y"]);
			if(isDefined())  setPoint("", "",  0 + self.AIO["safeArea_X"], 0 + self.AIO["safeArea_Y"]);
			if(isDefined())  setPoint("", "",  0 + self.AIO["safeArea_X"], 0 + self.AIO["safeArea_Y"]);
			if(isDefined())  setPoint("", "",  0 + self.AIO["safeArea_X"], 0 + self.AIO["safeArea_Y"]);
			*/
			
		}
	}
	
	
}

MancheAnimation()
{
	self.manche_animation = true;
	level.manche_suivante = true;
	
	self iprintln(level.manches);
	
	
	

	if(level.manches < 12)
	{
		Batons = strTok(" ,|,||,|||,||||,||||,|||| |,|||| ||,|||| |||,|||| ||||,|||| ||||,11",",");
		
		if(level.manches >= 6 && level.manches < 12)
		{	
			if(!isDefined(self.HUD["ZL"]["MANCHE_5EME_BLANCHE"]))
				self.HUD["ZL"]["MANCHE_5EME_BLANCHE"] = self createText( "objective", 3, "BOTTOM LEFT", "BOTTOM LEFT", 20, -10, 2, 1, (1,1,1), "/");
			
			if(!isDefined(self.HUD["ZL"]["MANCHE_5EME"]))
				self.HUD["ZL"]["MANCHE_5EME"] = self createText( "objective", 3, "BOTTOM LEFT", "BOTTOM LEFT", 20, -10, 4, 1, (1,0,0), "/");
		}
		
		if(level.manches >= 11 && level.manches < 12)
		{	
			if(!isDefined(self.HUD["ZL"]["MANCHE_10EME_BLANCHE"]))
			{
				self.HUD["ZL"]["MANCHE_10EME_BLANCHE"] = self createText( "objective", 3, "BOTTOM LEFT", "BOTTOM LEFT", 70, -10, 2, 1, (1,1,1), "/");
			
			}
			if(!isDefined(self.HUD["ZL"]["MANCHE_10EME"]))
				self.HUD["ZL"]["MANCHE_10EME"] = self createText( "objective", 3, "BOTTOM LEFT", "BOTTOM LEFT", 70, -10, 5, 1, (1,0,0), "/");
		}
		
		
		if(!isDefined(self.HUD["ZL"]["MANCHE_BLANCHE"]))
			self.HUD["ZL"]["MANCHE_BLANCHE"] = self createText( "objective", 3, "BOTTOM LEFT", "BOTTOM LEFT", 10, -10, 2, 1, (1,1,1), Batons[level.manches-1]);
		
		
		if(isDefined(self.HUD["ZL"]["MANCHE_10EME"])) self.HUD["ZL"]["MANCHE_10EME"] elemFade(2,0);
		if(isDefined(self.HUD["ZL"]["MANCHE_5EME"])) self.HUD["ZL"]["MANCHE_5EME"] elemFade(2,0);
	
		self.HUD["ZL"]["MANCHE_GLOBAL"] elemFade(2,0);
		
		wait 2;
		
		self playlocalsound("mp_time_running_out_winning"); 
		
		 
		
		for(i=0;i<6;i++)
		{
			if(isDefined(self.HUD["ZL"]["MANCHE_10EME_BLANCHE"])) 
				self.HUD["ZL"]["MANCHE_10EME_BLANCHE"] elemFade(.8,1);
				
			if(isDefined(self.HUD["ZL"]["MANCHE_5EME_BLANCHE"]))
				self.HUD["ZL"]["MANCHE_5EME_BLANCHE"] elemFade(.8,1);

			
			self.HUD["ZL"]["MANCHE_BLANCHE"] elemFade(.8,1);
			wait .8;
			
			if(isDefined(self.HUD["ZL"]["MANCHE_10EME_BLANCHE"])) 
				self.HUD["ZL"]["MANCHE_10EME_BLANCHE"] elemFade(.8,0);
			if(isDefined(self.HUD["ZL"]["MANCHE_5EME_BLANCHE"])) 
				self.HUD["ZL"]["MANCHE_5EME_BLANCHE"] elemFade(.8,0);
			
			self.HUD["ZL"]["MANCHE_BLANCHE"] elemFade(.8,0);
			wait .8;
		}
		
		
		if(level.manches == 10)
		{	
			if(!isDefined(self.HUD["ZL"]["MANCHE_10EME_BLANCHE"]))
				self.HUD["ZL"]["MANCHE_10EME_BLANCHE"] = self createText( "objective", 3, "BOTTOM LEFT", "BOTTOM LEFT", 70, -10, 2, 0, (1,1,1), "/");
			
			if(!isDefined(self.HUD["ZL"]["MANCHE_10EME"]))	
				self.HUD["ZL"]["MANCHE_10EME"] = self createText( "objective", 3, "BOTTOM LEFT", "BOTTOM LEFT", 70, -10, 5, 0, (1,0,0), "/");
		}
		
		//NOUVELLE MANCHE ICI /////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		if(level.manches >= 5 && level.manches < 11)
		{	
			
			if(!isDefined(self.HUD["ZL"]["MANCHE_5EME"]))
				self.HUD["ZL"]["MANCHE_5EME"] = self createText( "objective", 3, "BOTTOM LEFT", "BOTTOM LEFT", 20, -10, 5, 0, (1,0,0), "/");
		}
		
		if(level.manches >= 10 && level.manches < 11)
		{	
			if(!isDefined(self.HUD["ZL"]["MANCHE_10EME"]))
				self.HUD["ZL"]["MANCHE_10EME"] = self createText( "objective", 3, "BOTTOM LEFT", "BOTTOM LEFT", 70, -10, 5, 0, (1,0,0), "/");
		}
		
		
		
		
		self.HUD["ZL"]["MANCHE_BLANCHE"] setText(Batons[level.manches]);
		
		//self iprintln("new manche: "+level.manches);
		
		self thread ChaqueManche();
		
		if(level.manches >= 5&& level.manches < 11)
		{
			
			if(!isDefined(self.HUD["ZL"]["MANCHE_5EME_BLANCHE"]))
				self.HUD["ZL"]["MANCHE_5EME_BLANCHE"] = self createText( "objective", 3, "BOTTOM LEFT", "BOTTOM LEFT", 20, -10, 2, 0, (1,1,1), "/");
		
				self.HUD["ZL"]["MANCHE_5EME_BLANCHE"] elemFade(2,1);
		}
		
		if(level.manches >= 10 && level.manches < 11)
		{
		
			if(!isDefined(self.HUD["ZL"]["MANCHE_10EME_BLANCHE"]))
				self.HUD["ZL"]["MANCHE_10EME_BLANCHE"] = self createText( "objective", 3, "BOTTOM LEFT", "BOTTOM LEFT", 70, -10, 2, 0, (1,1,1), "/");
			
			self.HUD["ZL"]["MANCHE_10EME_BLANCHE"] elemFade(2,1);
			
		}
		
		self.HUD["ZL"]["MANCHE_BLANCHE"] elemFade(2,1);
		
		wait 2;
		
		if(level.manches < 11)
		{
			if(isDefined(self.HUD["ZL"]["MANCHE_10EME_BLANCHE"])) self.HUD["ZL"]["MANCHE_10EME_BLANCHE"] elemFade(1,0);
			if(isDefined(self.HUD["ZL"]["MANCHE_5EME_BLANCHE"])) self.HUD["ZL"]["MANCHE_5EME_BLANCHE"] elemFade(1,0);
		}
		
		self.HUD["ZL"]["MANCHE_BLANCHE"]elemFade(1,0);
		
		wait 1;
		
		self.HUD["ZL"]["MANCHE_GLOBAL"] setText(Batons[level.manches]);
		
		if(level.manches < 11)
		{
			if(isDefined(self.HUD["ZL"]["MANCHE_10EME_BLANCHE"])) self.HUD["ZL"]["MANCHE_10EME_BLANCHE"] elemFade(3,1);	
			if(isDefined(self.HUD["ZL"]["MANCHE_5EME_BLANCHE"])) self.HUD["ZL"]["MANCHE_5EME_BLANCHE"] elemFade(3,1);	
		}
		
		self.HUD["ZL"]["MANCHE_BLANCHE"] elemFade(3,1);	
			
		wait 3;
		
		if(level.manches < 11)
		{
			if(isDefined(self.HUD["ZL"]["MANCHE_10EME"])) self.HUD["ZL"]["MANCHE_10EME"] elemFade(3,1);
			if(isDefined(self.HUD["ZL"]["MANCHE_5EME"])) self.HUD["ZL"]["MANCHE_5EME"] elemFade(3,1);
			
		}
		
		self.HUD["ZL"]["MANCHE_GLOBAL"] elemFade(3,1);
		
		wait 3;
		
		self.HUD["ZL"]["MANCHE_BLANCHE"] advanceddestroy(self);
		if(isDefined(self.HUD["ZL"]["MANCHE_5EME_BLANCHE"])) self.HUD["ZL"]["MANCHE_5EME_BLANCHE"] AdvancedDestroy(self);
		if(isDefined(self.HUD["ZL"]["MANCHE_10EME_BLANCHE"])) self.HUD["ZL"]["MANCHE_10EME_BLANCHE"] AdvancedDestroy(self);
			
		if(level.manches >= 11)
		{
			if(isDefined(self.HUD["ZL"]["MANCHE_5EME_BLANCHE"])) self.HUD["ZL"]["MANCHE_5EME_BLANCHE"] AdvancedDestroy(self);
			if(isDefined(self.HUD["ZL"]["MANCHE_5EME"])) self.HUD["ZL"]["MANCHE_5EME"] AdvancedDestroy(self);
			if(isDefined(self.HUD["ZL"]["MANCHE_10EME_BLANCHE"])) self.HUD["ZL"]["MANCHE_10EME_BLANCHE"] AdvancedDestroy(self);
			if(isDefined(self.HUD["ZL"]["MANCHE_10EME"])) self.HUD["ZL"]["MANCHE_10EME"] AdvancedDestroy(self);
		}
	}
	else
	{
		if(!isDefined(self.HUD["ZL"]["MANCHE_BLANCHE"]))
			self.HUD["ZL"]["MANCHE_BLANCHE"] = self createText( "objective", 3, "BOTTOM LEFT", "BOTTOM LEFT", 10, -10, 1, 1, (1,1,1));
		self.HUD["ZL"]["MANCHE_BLANCHE"] setValue(level.manches-1);
		self.HUD["ZL"]["MANCHE_GLOBAL"] hudFade(0,2);
		
		for(i=0;i<6;i++)
		{
			self.HUD["ZL"]["MANCHE_BLANCHE"] hudFade(1,.8);
			wait .1;
			self.HUD["ZL"]["MANCHE_BLANCHE"] hudFade(0,.8);
		}
		
		self.HUD["ZL"]["MANCHE_BLANCHE"] setValue(level.manches);
		self.HUD["ZL"]["MANCHE_BLANCHE"] hudFade(1,2);
		self.HUD["ZL"]["MANCHE_BLANCHE"] hudFade(0,1);
		self.HUD["ZL"]["MANCHE_GLOBAL"] setValue(level.manches);
		self.HUD["ZL"]["MANCHE_BLANCHE"] hudFade(1,3);
		self.HUD["ZL"]["MANCHE_GLOBAL"] hudFade(1,3);
		self.HUD["ZL"]["MANCHE_BLANCHE"] advanceddestroy(self);
	}
	
	wait .5;
	
	//for(i=0;i<level.players.size;i++) if(level.players[i].team == "axis") level.players[i] freezecontrols(false);
	
	level.manche_suivante = false;
	self.manche_animation = false;
	
	//self iprintln("done");
}
ChaqueManche()
{
	grenadeStock = self getWeaponAmmoStock("frag_grenade_mp");	
	self giveweapon("frag_grenade_mp");
	self setWeaponAmmoStock("frag_grenade_mp",grenadeStock+1);
	
	self.grenadepretes += 1;
			
	if(self.grenadepretes > 4)
		self.grenadepretes = 4;
	
	for(i=1;i<self.grenadepretes+1;i++)
		if(isDefined(self.HUD["NM"]["GRENADE"][i]))
			self.HUD["NM"]["GRENADE"][i].alpha = 1;
	
}


GrenadeTracking()
{
	level endon("game_ended");
	
	while(1)
	{
		self waittill ( "grenade_fire", grenade, weaponName );
		
		oldGrenadecount = self.grenadepretes;
		
		if(weaponName == "frag_grenade_mp")
		{
			self.grenadepretes--;
			stock = self getWeaponAmmoStock("frag_grenade_mp");
			
			if(isDefined(self.HUD["NM"]["GRENADE"][oldGrenadecount]))
				self.HUD["NM"]["GRENADE"][oldGrenadecount].alpha = 0;
			
			for(i=stock;i<stock;i++)
				if(isDefined(self.HUD["NM"]["GRENADE"][stock]))
					self.HUD["NM"]["GRENADE"][stock].alpha = 1;
	
		}
	
	}	
	
}


ZombiePointMonitor(num,point)
{
	RandomPosX = strTOK("-120;-110;-105;-100;-115;-118;-105;-113;-115;-100;-116;-105",";");
	RandomPosY = strTOK("-20;-5;-25;-18;-15;-5;-10;-15;-17;-25;-7;-18",";");
	
	color = (255/255,255/255,35/255);
	
	Haut = -50;
	
	self.HUD["ZL"]["POINTS"][num] = self createText( "default", 1.5, "BOTTOM RIGHT", "BOTTOM RIGHT", -90 + self.AIO["safeArea_X"], -18 + Haut + self.AIO["safeArea_Y"]*-1, 2, 1, color);
	self.HUD["ZL"]["POINTS"][num].label = &"+&&1";
	self.HUD["ZL"]["POINTS"][num] setValue(point);
	
	self.HUD["ZL"]["POINTS"][num] hudMoveXY(1,int(RandomPosX[randomInt(11)]),int(RandomPosY[randomInt(11)]) + Haut + self.AIO["safeArea_Y"]*-1);
	
	self.human_score += point;
	
	if(isDefined(self.HUD["ZL"]["CUR_POINTS"]))
		self.HUD["ZL"]["CUR_POINTS"] setValue(self.human_score);
	
	self.HUD["ZL"]["POINTS"][num] hudFade(0,1.3);
	
	wait .1;
	
	self.HUD["ZL"]["POINTS"][num] AdvancedDestroy(self);
	
}














