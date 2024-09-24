#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include maps\mp\gametypes\_general_funcs;
#include maps\mp\gametypes\_NightmareME;

//GetCurrentOffhand


//LAG QUAND PERSONNE QUITTE

init()
{
	
	level thread onPlayerConnect();
	
	level.hardcoreMode = true;
	level.current_game_mode = "Is this zombieland ?!";
	level.gameModeDevName = "FUNNYZOMB";
	level deletePlacedEntity("misc_turret");
	
	//setDvar("con_gameMsgWindow0MsgTime", 40 ); //TESTTTTTTTTTT
	
	level.ZL_game_state = "starting";
	level.ZombiesDeaths = 0;
	level.manches = 1;
	level.ZombiesObj = 7;
	level.manche_suivante = false;
	
	level thread SpawnMoitoutca();
	
	PrecacheShader("scorebar_ussr");
	PrecacheShader("weapon_fraggrenade");
	PrecacheShader("code_warning_file");
	PrecacheShader("weapon_fraggrenade");
	PrecacheShader("weapon_fraggrenade");
		
	setDvar("mantle_enable","0");
	setDvar("ui_hud_showdeathicons", "0");
	setDvar("scr_game_hardpoints", "0");
	setdvar("scr_showperksonspawn", "0");
	setdvar("scr_game_allowkillcam ","0");
	
	while(!isDefined(level.inPrematchPeriod)) wait .05;
	
	setDvar("ui_uav_allies",1);
	setDvar("ui_uav_axis",1);
	
	game["strings"]["change_class"] = "";
	//game["strings"]["axis_name"] = "";
	//game["strings"]["allies_name"] = "";
	//game["dialog"]["gametype"] = undefined;
	game["music"]["spawn_axis"] = undefined;
	game["music"]["spawn_allies"] = undefined;
	
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

	
	self.manche_animation = false;
	self.grenadepretes = 1;
	self.Human_setup = false;
	self.playerSpawnedOK = false;
	self.playerHUDinitOK = false;
	self.jaiquunearme = true;
	self.score = 500;
	self.pers["score"] = 500;
	self.finalPoint = 0;
	
	/*
	if ( type == "teamkill" )
			self thread updateRankScoreHUD( 0 - getScoreInfoValue( "kill" ) );
		else
		{
			self thread updateRankScoreHUD( value );
		
			self.pers["score"] = 0;
			self.pers["kills"] = 0;
			self.pers["assists"] = 0;
			self.pers["deaths"] = 0;
			self.pers["suicides"] = 0;
			self.score = 0;
			self.kills = 0;
			self.assists = 0;
			self.deaths = 0;
			self.suicides = 0;
			self.headshots = 0;
			
			registerScoreInfo( "kill", 10 );
			registerScoreInfo( "headshot", 10 );
			registerScoreInfo( "assist", 2 );
			registerScoreInfo( "suicide", 0 );
			registerScoreInfo( "teamkill", 0 );
			registerScoreInfo( "melee", -1 );
		*/		
				
				
				
	self thread oneshot();
	
	for(;;)
	{
		
		
		self waittill("spawned_player");
		 
		//self thread doForgeMode2();
		self thread HumanSetup();
	}
}
oneshot()
{
	//self.score = 500;
	//self.pers["score"] = 500;
	
	//maps\mp\gametypes\_globallogic::_setPlayerScore( self, 500 );
	
	
	
	self thread Zombieland_HUD();
	
	self waittill("spawned_player");
	
	self playlocalsound("mp_suspense_04"); 
	
	self setClientDvar( "cg_drawCrosshair", "1");				
							 
	self thread GrenadeTracking();
	self thread HintText();
	self clearPerks();
	
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
	


	wait 1;
	
	self waittill( "weapon_change" ,newweapon);
	
	
	if(newweapon != "c4_mp" && newweapon != "claymore_mp" && newweapon != "frag_grenade_mp" && newweapon != "flash_grenade_mp" && newweapon != "concussion_grenade_mp" && newweapon != "smoke_grenade_mp" && newweapon != "rpg_mp" && newweapon != "" && newweapon != "none")
		self.jaiquunearme = false;				
	
}
HumanSetup()
{
	self endon("death");
	level endon("game_ended");
	self endon("disconnect");
	
	self.grenadepretes = 1;
			
	for(i=1;i<5;i++)
		if(isDefined(self.HUD["NM"]["GRENADE"][i]))
			self.HUD["NM"]["GRENADE"][i].alpha = 0;
	
	for(i=1;i<self.grenadepretes+1;i++)
		if(isDefined(self.HUD["NM"]["GRENADE"][i]))
			self.HUD["NM"]["GRENADE"][i].alpha = 1;
	
			
				
	while(1)
	{
		
		weapon = self getCurrentWeapon();
		ammoClip = self getWeaponAmmoClip(weapon);
		ammoStock = self getWeaponAmmoStock(weapon);
		
		if(isDefined(self.HUD_text["AMMO"]["CLIP"])) self.HUD_text["AMMO"]["CLIP"] setValue(ammoClip);
		if(isDefined(self.HUD_text["AMMO"]["STOCK"])) self.HUD_text["AMMO"]["STOCK"] setValue(ammoStock);
		
		wait .05;
	}
}

isThisClass()
{
	wait .05;
	
	if(!self.jaiquunearme)
		return;
	
	self clearperks();
	
	self giveWeapon("colt45_mp");
	self setWeaponAmmoClip("colt45_mp", 40);
	self setWeaponAmmoStock("colt45_mp", 40);
	wait .05;
	self switchtoweapon("colt45_mp");
	
	self giveweapon("frag_grenade_mp");
	self setWeaponAmmoClip("frag_grenade_mp", 1);
}


ZombielandLogics()
{
	level endon("game_ended");
	
	for(;;)
	{
		wait 50;
		
		//while(level.manche_suivante) wait .05;
			
			
			level.manches+=1;
		
			for(i=0;i<level.players.size;i++)
				if(!level.players[i].manche_animation && level.players[i].playerSpawnedOK && level.players[i].playerHUDinitOK)
					level.players[i] thread MancheAnimation();
	}		
}
Zombieland_HUD()
{
	self endon("disconnect");
	
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
	self.HUD["ZL"]["CUR_POINTS"] setValue(self.score);

	wait .1;
	
	Batons = strTok(" ,|,||,|||,||||,||||,|||| |,|||| ||,|||| |||,|||| ||||,|||| ||||,11",",");

	
	if(isDefined(level.inPrematchPeriod) && level.inPrematchPeriod)
	{
		self.HUD["ZL"]["MANCHE_TEXT_BLANC"] = self createText( "objective", 3, "CENTER", "CENTER", 0, -50, 2, 1, (1,1,1), "Round");
		self.HUD["ZL"]["MANCHE_TEXT"] = self createText( "objective", 3, "CENTER", "CENTER", 0, -50, 1, 1, (1,0,0), "Round");
		
		self.HUD["ZL"]["MANCHE_TEXT_BLANC"] hudFade(0,3);
		self.HUD["ZL"]["MANCHE_TEXT"] hudFade(0,1.5);
	}
	
	
	if(level.manches < 12)
		self.HUD["ZL"]["MANCHE_BLANCHE"] = self createText( "objective", 3, "BOTTOM LEFT", "BOTTOM LEFT", 300, -250, 1, 1, (1,1,1), Batons[level.manches]);
	else
		self.HUD["ZL"]["MANCHE_BLANCHE"] = self createText( "objective", 3, "BOTTOM LEFT", "BOTTOM LEFT", 10, -10, 1, 1, (1,1,1), level.manches);
	
	if(level.manches >= 5 && level.manches < 11 && !isDefined(self.HUD["ZL"]["MANCHE_5EME_BLANCHE"]))
		self.HUD["ZL"]["MANCHE_5EME_BLANCHE"] = self createText( "objective", 3, "BOTTOM LEFT", "BOTTOM LEFT", 20, -10, 3, 1, (1,1,1), "/");
			
	if(level.manches >= 10 && level.manches < 11 && !isDefined(self.HUD["ZL"]["MANCHE_10EME_BLANCHE"]))
		self.HUD["ZL"]["MANCHE_10EME_BLANCHE"] = self createText( "objective", 3, "BOTTOM LEFT", "BOTTOM LEFT", 70, -10, 3, 1, (1,1,1), "/");
		 
	
	if(level.manches < 12)
		self.HUD["ZL"]["MANCHE_GLOBAL"] = self createText( "objective", 3, "BOTTOM LEFT", "BOTTOM LEFT", 300, -250, 2, 0, (1,0,0), Batons[level.manches]);
	else
		self.HUD["ZL"]["MANCHE_GLOBAL"] = self createText( "objective", 3, "BOTTOM LEFT", "BOTTOM LEFT", 10, -10, 2, 0, (1,0,0), level.manches);
	
	if(level.manches >= 5 && level.manches < 11 && !isDefined(self.HUD["ZL"]["MANCHE_5EME"]))
		self.HUD["ZL"]["MANCHE_5EME"] = self createText( "objective", 3, "BOTTOM LEFT", "BOTTOM LEFT", 20, -10, 4, 0, (1,0,0), "/");
		
	if(level.manches >= 10 && level.manches < 11 && !isDefined(self.HUD["ZL"]["MANCHE_10EME"]))
		self.HUD["ZL"]["MANCHE_10EME"] = self createText( "objective", 3, "BOTTOM LEFT", "BOTTOM LEFT", 70, -10, 4, 0, (1,0,0), "/");

	
	self.HUD["ZL"]["MANCHE_GLOBAL"] elemFade(0.5,1);
	self.HUD["ZL"]["MANCHE_GLOBAL"] hudMoveXY(4,10,-10);
	self.HUD["ZL"]["MANCHE_BLANCHE"] hudMoveXY(4,10,-10);
	
	
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
	self endon("disconnect");
	
	self.manche_animation = true;
	level.manche_suivante = true;
	

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
	self endon("disconnect");
	
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
	self endon("disconnect");
	
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

ZombiePointMonitor(num,point,color,negative)
{
	self endon("disconnect");
	
	RandomPosX = strTOK("-120;-110;-105;-100;-115;-118;-105;-113;-115;-100;-116;-105",";");
	RandomPosY = strTOK("-20;-5;-25;-18;-15;-5;-10;-15;-17;-25;-7;-18",";");
	Haut = -50;
	
	self.HUD["ZL"]["POINTS"][num] = self createText( "default", 1.5, "BOTTOM RIGHT", "BOTTOM RIGHT", -90 + self.AIO["safeArea_X"], -18 + Haut + self.AIO["safeArea_Y"]*-1, 2, 1, color);
	
	
	if(isDefined(negative) && negative) 
	{
		self.HUD["ZL"]["POINTS"][num].label = &"&&1";
		self.score += point;
	}
	else 
	{
		self.score += point;
		self.HUD["ZL"]["POINTS"][num].label = &"+&&1";
	}
	
	self.HUD["ZL"]["POINTS"][num] setValue(point);
	self.HUD["ZL"]["POINTS"][num] hudMoveXY(1,int(RandomPosX[randomInt(11)]),int(RandomPosY[randomInt(11)]) + Haut + self.AIO["safeArea_Y"]*-1);
	
	
	if(isDefined(self.HUD["ZL"]["CUR_POINTS"]))
		self.HUD["ZL"]["CUR_POINTS"] setValue(self.score);
	
	self.HUD["ZL"]["POINTS"][num] hudFade(0,1.3);
	
	self.pers["score"] = self.score;
	wait .1;
	self.HUD["ZL"]["POINTS"][num] AdvancedDestroy(self);
	
}


createWeaponBox(position,angles)
{
	level endon("game_ended");
	
	Box = spawn("script_model", position);
	Box.angles = angles;
	Box setModel("com_plasticcase_beige_big");
	Box showOnMiniMap("code_warning_file");
	
	level.itemCost["rbox"] = 700;
	
	//WayPointIcon = maps\mp\gametypes\_objpoints::createTeamObjpoint( "0" , box.origin + (0,0,20), "all", undefined );
	//WayPointIcon setWayPoint( true, "weapon_m4carbine" );
	//WayPointIcon.alpha = 1;
	

	for(;;)
	{
		for(;;)
		{
			for(i=0;i<level.players.size;i++)
			{
				player = level.players[i];

					if(distance(player.origin, Box.origin) < 50)
					{
						player.hint = "Press [{+reload}] To Use Random Box ^7[^3COST 700$^7]";
						
						if(player useButtonPressed() && !player gotAllWeapons())
						{
							if(player.score >= level.itemCost["rbox"])
							{
								self.score -= level.itemCost["rbox"]; 
								level.BoxUser = player;
								player.HUD["ZL"]["CUR_POINTS"] setValue(self.score);
								
								player thread ZombiePointMonitor(level.counterPlayerBuyed,700,(1,0,0),1);
								
								wait .5;
							}
							else 
							{
								player iPrintlnBold("^1Need more money");
								wait .5;
							} 
						}
					}
				}

			if(isDefined(level.BoxUser))
				break;
			wait .05;
		}
		
		User = level.BoxUser;
		Weapon = User treasure_chest_weapon_spawn(position,angles);
		thread boxTimeout(User, Weapon);
		
		for(;;)
		{
			if(distance(User.origin, Box.origin) < 50)
			{
				User.hint = "Press [{+reload}] To Take Weapon";
				
				if(User useButtonPressed())
				{
					Kurrent = user getcurrentweapon();
					
					if(isSubStr(Weapon.weap, "c4_") || isSubStr(Weapon.weap, "claymore_") || isSubStr(Weapon.weap, "frag_grenade_") || isSubStr(Weapon.weap, "flash_grenade_") || isSubStr(Weapon.weap, "concussion_grenade_") || isSubStr(Weapon.weap, "smoke_grenade_")	|| isSubStr(Weapon.weap, "rpg_"))
						User iprintlnbold("^1If you change your weapon you will lose this one !!");
					else if(!User.jaiquunearme)
						User takeWeapon(Kurrent);
						
						
					User giveWeapon(Weapon.weap);
					User switchToWeapon(Weapon.weap);
					//User giveMaxAmmo(Weapon.weap);
					User playSound("oldschool_pickup");
					User notify("weapon_collected");
					User.HUD["ZL"]["CUR_POINTS"] setValue(User.score);
					break;
				}
				
			}
			if(isDefined(User.timedOut))
					break;
			wait .05;
		}
		
		Weapon delete();
		wait 2;
		level.BoxUser = undefined;
	}
}
boxTimeout(User, weapon)
{
	User endon("user_grabbed_weapon");
	weapon moveTo(weapon.origin-(0, 0, 30), 12, (12*.5));
	wait 12;
	
	User.timedOut = true;
	wait .2;
	User.timedOut = undefined;
}
treasure_chest_weapon_spawn(position,angles)
{
	level endon("game_ended");
	
	gun = spawn("script_model", position +(0, 0, 20));
	gun setModel("");
	gun moveTo(position+(0, 0, 40), 3, 2, .9);
	gun.angles = angles;
	
	weaponArray = [];
	
	for(m = 0; m < level.weaponlist.size; m++)
		if(!self hasWeapon(level.weaponlist[m]))
			weaponArray[weaponArray.size] = level.weaponlist[m];
			
	randy = 0;
	
	for(m = 0; m < 40; m++)
	{
		if(m < 20) wait .05;
		else if(m < 30) wait .1;
		else if(m < 35) wait .2;
		else if(m < 38) wait .3;
		
		randy = weaponArray[randomInt(weaponArray.size)];
		gun setModel(getWeaponModel(randy));
		gun.weap = randy;
	}
	return gun;
}
gotAllWeapons()
{
	for(m = 0; m < level.weaponlist.size; m++)
		if(!self hasWeapon(level.weaponlist[m]))
			return false;
	return true;
}
SpawnMoitoutca()
{

	if( getDvar("mapname") == "mp_convoy" )
	{
	
		thread SpawnArmeAUmur((2595,137,-5),( 0, 90, 0 ),"hint_usable","dragunov_mp","","Dragunov",400,"weapon_dragunov");
		thread SpawnArmeAUmur((1089,950,12),( 0, 71, 0 ),"hint_usable","g3_mp","","G3",300,"weapon_g3");
		thread SpawnArmeAUmur((-2324,407,-10),( 0, 270, 0 ),"hint_usable","remington700_mp","","R700",350,"weapon_remington700");
		thread SpawnArmeAUmur((-2739,-745,-10),( 0, 176, 0 ),"hint_usable","m21_mp","","M21",400,"weapon_m14_mp");
		thread SpawnArmeAUmur((-347,-836,5),( 0, 94, 0 ),"hint_usable","winchester1200_mp","","Winchester 1200",250,"weapon_winchest1200");
		thread SpawnArmeAUmur((-598,1229,-6),( 0, 221, 0 ),"hint_usable","mp44_mp","","MP44",500,"weapon_mp44");
		thread SpawnArmeAUmur((1977,900,-12),( 0, 260, 0 ),"hint_usable","skorpion_mp","","Skorpion",200,"weapon_skorpion");
		thread createWeaponBox((1350, 1433,92),(0,339,0));
	}
	else if( getDvar("mapname") == "mp_backlot" )
	{
		thread SpawnArmeAUmur((-970,1491,133),( 0, 90, 0 ),"hint_usable","dragunov_mp","","Dragunov",400,"weapon_dragunov");
		thread SpawnArmeAUmur((599,917,111),( 0, 180, 0 ),"hint_usable","g3_mp","","G3",300,"weapon_g3");
		thread SpawnArmeAUmur((832,-240,119),( 0, 90, 0 ),"hint_usable","remington700_mp","","R700",350,"weapon_remington700");
		thread SpawnArmeAUmur((218,-379,259),( 0, 80, 0 ),"hint_usable","m21_mp","","M21",400,"weapon_m14_mp");
		thread SpawnArmeAUmur((-399,-2612,127),( 0, 177, 0 ),"hint_usable","winchester1200_mp","","Winchester 1200",250,"weapon_winchest1200");
		thread SpawnArmeAUmur((1169,-1373,122),( 0, 270, 0 ),"hint_usable","mp44_mp","","MP44",500,"weapon_mp44");
		thread SpawnArmeAUmur((-1270,-240,311),( 0, 90, 0 ),"hint_usable","skorpion_mp","","Skorpion",200,"weapon_skorpion");
		thread createWeaponBox((447,470,195),(0,0,0));
	}
	
	
	
	else if( getDvar("mapname") == "mp_bloc" )
	{
		thread SpawnArmeAUmur((-927,-5069, 20),( -62, 0, 90 ),"hint_usable","dragunov_mp","","Dragunov",400,"weapon_dragunov");
		thread SpawnArmeAUmur((585,-4880, 186),( 180, 125, 90 ),"hint_usable","g3_mp","","G3",300,"weapon_g3");
		thread SpawnArmeAUmur((1181,-6818, 33),( -180, 250, 90 ),"hint_usable","skorpion_mp","","Skorpion",200,"weapon_skorpion");
		thread SpawnArmeAUmur((3990,-6336, 37),( -115, 350, 90 ),"hint_usable","m21_mp","","M21",400,"weapon_m14_mp");
		thread SpawnArmeAUmur((1609,-6773, 198),( -115, 177, 90 ),"hint_usable","winchester1200_mp","","Winchester 1200",250,"weapon_winchest1200");
		thread SpawnArmeAUmur((-873,-5638, -4),( -115, 117, 90 ),"hint_usable","mp44_mp","","MP44",500,"weapon_mp44");
		thread createWeaponBox((1526,-4881, 142),(0,90,0));
	}
	else if( getDvar("mapname") == "mp_bog" )
	{
		thread SpawnArmeAUmur((3919,325,44),( 0, 42, 90 ),"hint_usable","remington700_mp","","R700",350,"weapon_remington700");
		thread SpawnArmeAUmur((2657,-411,38),( 0, 95, 90 ),"hint_usable","g3_mp","","G3",300,"weapon_g3");
		thread SpawnArmeAUmur((3418,1487,46),( 0, 205, 90 ),"hint_usable","m21_mp","","M21",400,"weapon_m14_mp");
		thread SpawnArmeAUmur((5114,1811,31),( 0, 335, 90 ),"hint_usable","winchester1200_mp","","Winchester 1200",250,"weapon_winchest1200");
		thread SpawnArmeAUmur((5100,36,49),( 0, 32, 90 ),"hint_usable","mp44_mp","","MP44",500,"weapon_mp44");
		thread createWeaponBox((4284,60,-7),(0,11,0));
	}
	else if( getDvar("mapname") == "mp_countdown" )
	{
		thread SpawnArmeAUmur((2230,-300,12),( 0,22 , 90 ),"hint_usable","remington700_mp","","R700",350,"weapon_remington700");
		thread SpawnArmeAUmur((-2327,1624,21),( 0,72 , 90 ),"hint_usable","g3_mp","","G3",300,"weapon_g3");
		thread SpawnArmeAUmur((-2460,344,4),( 0,250 , 90 ),"hint_usable","m21_mp","","M21",400,"weapon_m14_mp");
		thread SpawnArmeAUmur((57,-388,-2),( 0,210 , 90 ),"hint_usable","winchester1200_mp","","Winchester 1200",250,"weapon_winchest1200");
		thread SpawnArmeAUmur((-414,1594,34),( -72,265 , 90 ),"hint_usable","mp44_mp","","MP44",500,"weapon_mp44");
		thread createWeaponBox((-2396,554,-19),(0,90,0));
	}
	else if( getDvar("mapname") == "mp_crash" )
	{
		thread SpawnArmeAUmur((1692,-1520,123),( -35, 80, 90 ),"hint_usable","remington700_mp","","R700",350,"weapon_remington700");
		thread SpawnArmeAUmur((1551,462,177),( 0, 80, 90 ),"hint_usable","dragunov_mp","","Dragunov",400,"weapon_dragunov");
		thread SpawnArmeAUmur((222,2036,277),( 0, 125, 90 ),"hint_usable","g3_mp","","G3",300,"weapon_g3");
		thread SpawnArmeAUmur((108,765,151),( -45, 190, 85 ),"hint_usable","skorpion_mp","","Skorpion",200,"weapon_skorpion");
		
		thread CreateDoors((1755,453,300),(1755,453,600), ( 90, 90, 90 ), 2, 2, 100);
		
		
		//thread SpawnArmeAUmur((57,-683,187),( 0,205, 85 ),"hint_usable","m21_mp","","M21",400,"weapon_m14_mp");
		thread SpawnArmeAUmur((1135,1289,155),( -100, 235, 85 ),"hint_usable","winchester1200_mp","","Winchester 1200",250,"weapon_winchest1200");
		thread SpawnArmeAUmur((-252,527,270),( 0, 205, 85 ),"hint_usable","mp44_mp","","MP44",500,"weapon_mp44");
		thread createWeaponBox((1790,559,578),(90,90,0));
	}
	else if( getDvar("mapname") == "mp_crossfire" )
	{
		thread SpawnArmeAUmur((3304,-1446,63),( 0,0 , 90 ),"hint_usable","remington700_mp","","R700",350,"weapon_remington700");
		thread SpawnArmeAUmur((5202,-3285,-48),( 0,140 , 90 ),"hint_usable","skorpion_mp","","Skorpion",200,"weapon_skorpion");
		thread SpawnArmeAUmur((5173,-4968,-101),( 0,325, 90 ),"hint_usable","g3_mp","","G3",300,"weapon_g3");
		thread SpawnArmeAUmur((5848,-1477,61),( 0,12 , 90 ),"hint_usable","dragunov_mp","","Dragunov",400,"weapon_dragunov");
		thread SpawnArmeAUmur((3379,-3607,-122),( -82,35 , 90 ),"hint_usable","m21_mp","","M21",400,"weapon_m14_mp");
		thread SpawnArmeAUmur((5547,-2937,66),( 0,0 , 90 ),"hint_usable","winchester1200_mp","","Winchester 1200",250,"weapon_winchest1200");
		thread SpawnArmeAUmur((4245,-2858,-18),( 0,22 , 90 ),"hint_usable","mp44_mp","","MP44",500,"weapon_mp44");
		thread createWeaponBox((4323,-3040,69),(0,60,0));
	}

	else if( getDvar("mapname") == "mp_citystreets" )
	{
		thread SpawnArmeAUmur((4807, -2391, 15),( -117,342 , 90 ),"hint_usable","remington700_mp","","R700",350,"weapon_remington700");
		thread SpawnArmeAUmur((4460, -161, -81),( 185,0 , 90 ),"hint_usable","m21_mp","","M21",400,"weapon_m14_mp");
		thread SpawnArmeAUmur((5655, 556,41),( 180,130 , 90 ),"hint_usable","winchester1200_mp","","Winchester 1200",250,"weapon_winchest1200");
		thread SpawnArmeAUmur((2520, -1061, -62),( 180,250 , 90 ),"hint_usable","mp44_mp","","MP44",500,"weapon_mp44");
		thread createWeaponBox((3478, -1128, -4),(0,50,0));
	}
	else if( getDvar("mapname") == "mp_farm" )
	{
		thread SpawnArmeAUmur((1799,3038,255),( 0, 250, 90 ),"hint_usable","remington700_mp","","R700",350,"weapon_remington700");
		thread SpawnArmeAUmur((950,839,259),( 0, 250, 90 ),"hint_usable","g3_mp","","G3",300,"weapon_g3");
		thread SpawnArmeAUmur((723,-1018,176),( 0, 70, 90 ),"hint_usable","m21_mp","","M21",400,"weapon_m14_mp");
		thread SpawnArmeAUmur((281,1331,260),( 0, 140, 90 ),"hint_usable","winchester1200_mp","","Winchester 1200",250,"weapon_winchest1200");
		thread SpawnArmeAUmur((-331,2457,242),( -77, 140, 90 ),"hint_usable","mp44_mp","","MP44",500,"weapon_mp44");
		thread createWeaponBox((1498,897,219),(0,180,0));
	}
	
	else if( getDvar("mapname") == "mp_overgrown" )
	{
		thread SpawnArmeAUmur((1726,-1281,-157),( 0,172 , 0 ),"hint_usable","dragunov_mp","","Dragunov",400,"weapon_dragunov");
		thread SpawnArmeAUmur((1000,-2913,-96),( 0, 177, 0 ),"hint_usable","skorpion_mp","","Skorpion",200,"weapon_skorpion");
		thread SpawnArmeAUmur((-530,-2234,-78),( 0, 142, 0 ),"hint_usable","g3_mp","","G3",300,"weapon_g3");
		thread SpawnArmeAUmur((-686,-3575,-57),( 0, 267, 0 ),"hint_usable","remington700_mp","","R700",350,"weapon_remington700");
		thread SpawnArmeAUmur((-530,-5375,-105),( 0,182 , 0 ),"hint_usable","m21_mp","","M21",400,"weapon_m14_mp");
		thread SpawnArmeAUmur((1083,-4128,40),( 0, 85, 0 ),"hint_usable","winchester1200_mp","","Winchester 1200",250,"weapon_winchest1200");
		thread SpawnArmeAUmur((-515,-595,-128),( 0,112 , -90 ),"hint_usable","mp44_mp","","MP44",500,"weapon_mp44");
		thread createWeaponBox((1179,-2243,-33),(0,211,0));
	}
	else if( getDvar("mapname") == "mp_pipeline" )
	{
		thread SpawnArmeAUmur((940,2909,83),( 0, 42, 90 ),"hint_usable","remington700_mp","","R700",350,"weapon_remington700");
		thread SpawnArmeAUmur((-110,1585,243),( 0, 42, 90 ),"hint_usable","g3_mp","","G3",300,"weapon_g3");
		thread SpawnArmeAUmur((1616,476,54),( 0, 42, 90 ),"hint_usable","m21_mp","","M21",400,"weapon_m14_mp");
		thread SpawnArmeAUmur((-1026,-751,284),(-65, 2, 90 ),"hint_usable","winchester1200_mp","","Winchester 1200",250,"weapon_winchest1200");
		thread SpawnArmeAUmur((1171,-42,90),( 180, 30, 90 ),"hint_usable","mp44_mp","","MP44",500,"weapon_mp44");
		thread createWeaponBox((-863,880, 203),(0,90,0));
	}
	else if( getDvar("mapname") == "mp_shipment" )
	{
		thread SpawnArmeAUmur((-557,568,211),( -122, 0, 90 ),"hint_usable","winchester1200_mp","","Winchester 1200",250,"weapon_winchest1200");
		thread createWeaponBox((216,177,202),(0,90,0));
	}
	else if( getDvar("mapname") == "mp_showdown" )
	{
		thread SpawnArmeAUmur((357,1792,24),(-17, 52, 67 ),"hint_usable","remington700_mp","","R700",350,"weapon_remington700");
		thread SpawnArmeAUmur((773,289,212),(-60, 0, 70 ),"hint_usable","g3_mp","","G3",300,"weapon_g3");
		thread SpawnArmeAUmur((-762,-155,221),(-70, 0, 70 ),"hint_usable","m21_mp","","M21",400,"weapon_m14_mp");
		thread SpawnArmeAUmur((-801,-1146,33),(-52, 17, 70 ),"hint_usable","winchester1200_mp","","Winchester 1200",250,"weapon_winchest1200");
		thread SpawnArmeAUmur((-1058,221,30),(-32, 270, 70 ),"hint_usable","mp44_mp","","MP44",500,"weapon_mp44");
		thread createWeaponBox((0,684,189),(0,0,0));
	}
	else if( getDvar("mapname") == "mp_strike" )
	{
		precacheModel("bc_militarytent_wood_table");
		precacheModel("com_red_toolbox");
		precacheModel("com_propane_tank");
		
		thread Spawnmodele((-448,-2385,210),( 0,0 , 0 ),"","","","","","bc_militarytent_wood_table");
		thread Spawnmodele((-446,-2358,254),( 0,220 , 0 ),"","","","","","com_red_toolbox");
		thread Spawnmodele((-448,-2414,252),( 0,0 , 0 ),"","","","","","com_propane_tank");
		
		thread SpawnArmeAUmur((-453,-2391,256),( 0,274 , -90 ),"hint_usable","remington700_mp","","R700",350,"weapon_remington700");
		thread SpawnArmeAUmur((-1172,299,64),( 0,151 , 90 ),"hint_usable","g3_mp","","G3",300,"weapon_g3");
		thread SpawnArmeAUmur((1585,1393,42),( 0,211 , 90 ),"hint_usable","m21_mp","","M21",400,"weapon_m14_mp");
		thread SpawnArmeAUmur((655,-1521,57),( 0,256 , 90 ),"hint_usable","winchester1200_mp","","Winchester 1200",250,"weapon_winchest1200");
		thread SpawnArmeAUmur((-204,577,59),( 0,166 , 90 ),"hint_usable","mp44_mp","","MP44",500,"weapon_mp44");
		thread createWeaponBox((-637,1940,16),(0,0,0));
	}
	else if( getDvar("mapname") == "mp_vacant" )
	{
		thread SpawnArmeAUmur((-676,138,-80),( 0,0 , -90 ),"hint_usable","remington700_mp","","R700",350,"weapon_remington700");
		thread SpawnArmeAUmur((-158,1175,-9),( 0,240 , -90 ),"hint_usable","g3_mp","","G3",300,"weapon_g3");
		thread SpawnArmeAUmur((1349,1061,-12),( 0,307 , -90 ),"hint_usable","m21_mp","","M21",400,"weapon_m14_mp");
		thread SpawnArmeAUmur((899,-441,-15),( 0,185 , -90 ),"hint_usable","winchester1200_mp","","Winchester 1200",250,"weapon_winchest1200");
		thread SpawnArmeAUmur((-264,-389,-28),( -115,260 , -90 ),"hint_usable","mp44_mp","","MP44",500,"weapon_mp44");
		thread createWeaponBox((715,574,-50),(0,0,0));
	}
	else if( getDvar("mapname") == "mp_cargoship" )
	{
		thread SpawnArmeAUmur((3333,-88,196),( -115, 7, -90),"hint_usable","remington700_mp","","R700",350,"weapon_remington700");
		thread SpawnArmeAUmur((1340,175,56),( -180, 105, -90),"hint_usable","g3_mp","","G3",300,"weapon_g3");
		thread SpawnArmeAUmur((-2001,-264,64),( -180, 250, -90),"hint_usable","m21_mp","","M21",400,"weapon_m14_mp");
		thread SpawnArmeAUmur((-3343,0,86),( -112, 180, -90),"hint_usable","winchester1200_mp","","Winchester 1200",250,"weapon_winchest1200");
		thread SpawnArmeAUmur((250,228,35),( -112, 250, -90),"hint_usable","mp44_mp","","MP44",500,"weapon_mp44");
		thread createWeaponBox((186,-524,13),(0,0,0));
	}	
}
	
	//12
	//55
	
	
createPerkMachine(position, angles, perk, number, lev, text,price)
{
	level endon("game_ended");
	
	Machine = spawn("script_model", position);
	Machine showOnMiniMap(perk);
	Machine.angles = angles;

	wait 1;
	
	for(;;)
	{
		for(i=0;i<level.players.size;i++)
		{
			player = level.players[i];
			
			if(distance(player.origin, Machine.origin) < 50)
			{
				player.hint = "Press [{+reload}] for "+text+" ^7[^3COST "+price+"$^7]";
				
				if(player useButtonPressed())
				{
					if(!self hasPerk(perk))
					{
						if(self.score >= price)
						{
							self.score -= price;
							player setPerk(perk);
							player showPerk(lev, perk, -50);
							wait .5;
						} 
						else
						{
							player iPrintlnBold("^1Need more money");
							wait .2;
						} 
					}
				}
			}	
		}
		wait .05;
	}
}


Spawnmodele(position, angles, HUD, weapon, lev, text,price,arme)
{
	
	Weap = spawn("script_model", position);
	Weap.angles = angles;
	Weap setModel(arme);
	
}
SpawnArmeAUmur(position, angles, HUD, weapon, lev, text,price,arme)
{
	level endon("game_ended");
	
	Weap = spawn("script_model", position);
	Weap showOnMiniMap(HUD);
	Weap.angles = angles;
	Weap setModel(arme);
	
	clip = 30;
	stock = 30;
	
	wait 1;
	
	for(;;)
	{
		for(i=0;i<level.players.size;i++)
		{
			player = level.players[i];
			
			if(distance(player.origin, Weap.origin) < 80)
			{
				player.hint = "Press [{+reload}] for "+text+" ^7[^3COST "+price+"$^7]";
				
				if(player useButtonPressed())
				{
					
						if(player.score >= price)
						{
							Kurrent = player getcurrentweapon();
					
							if(!player.jaiquunearme)
								player takeWeapon(Kurrent);
						
							
							self.score-= price;
							player giveWeapon( weapon );
							player setWeaponAmmoClip( weapon, clip );
							player setWeaponAmmoStock( weapon, stock );
							wait 0.1;
							player playSound("oldschool_pickup");
							player SwitchToWeapon(weapon);
							player.HUD["ZL"]["CUR_POINTS"] setValue(player.score);
							player thread ZombiePointMonitor(level.counterPlayerBuyed,price,(1,0,0),1);
								
							wait 2;
						} 
						else
						{
							player iPrintlnBold("^1Need more money");
							wait .5;
						} 
				}
				
				
			}	
		}
		wait .05;
	}
}

CreateDoors(close, open, angles, size, height, price)
{
	offset = (((size / 2) - 0.5) * -1);

	Door = spawn("script_model", close );
	Door showOnMiniMap("hint_usable");
	
	for(j=0;j<size;j++)
	{
		level.BlockModel[j] = spawn("script_model", close + ((0, 30, 0) * offset));
		level.BlockModel[j] setModel("com_plasticcase_beige_big");
		level.BlockModel[j] Solid();
		level.BlockModel[j] EnableLinkTo();
		level.BlockModel[j] LinkTo(Door);
		
		doorcol[j][0] = spawn("trigger_radius", close + ((0, 30, 0) * offset), 1, 40, 40);
		doorcol[j][1] = spawn("trigger_radius", close + ((0, 30, 0) * offset), 1, 40, 40);
		
		for(o=0;o<=2;o++)
		{	
			level.doorcol[j][o].angles = (0,0,0);
			level.doorcol[j][o] setContents(1);
			level.doorcol[j][o] EnableLinkTo();
			level.doorcol[j][o] LinkTo(Door);
		}
		
		for(h=1;h<height;h++)
		{
			level.BlockModel2[j][h] = spawn("script_model", close + ((0, 30, 0) * offset) - ((70, 0, 0) * h));
			level.BlockModel2[j][h] setModel("com_plasticcase_beige_big");
			level.BlockModel2[j][h] Solid();
			level.BlockModel2[j][h] EnableLinkTo();
			level.BlockModel2[j][h] LinkTo(Door);
			
			level.doorcol1[j][h][0] = spawn("trigger_radius", close + ((0, 30, 0) * offset - ((70, 0, 0) * h)), 1, 40, 40);
			level.doorcol1[j][h][1] = spawn("trigger_radius", close + ((0, 30, 0) * offset - ((70, 0, 0) * h)), 1, 40, 40);
			
			for(k=0;k<=2;k++)
			{	
				level.doorcol1[j][h][k].angles = (0,0,0);
				level.doorcol1[j][h][k] setContents(1);
				level.doorcol1[j][h][k] EnableLinkTo();
				level.doorcol1[j][h][k] LinkTo(Door);
			}
		}
		
		offset += 1;
	}
	
	wait 1;
	
	Door.angles = angles;
	Door thread DoorThink(open,price);
	
	door waittill("killdoor");
	
	for(j=0;j<size;j++)
	{
		level.BlockModel[j] delete();
		level.doorcol[j][0] delete();
		level.doorcol[j][1] delete();
		
		for(h=1;h<height;h++) 
		{
			level.BlockModel2[j][h] delete();
			level.doorcol1[j][h][0] delete();
			level.doorcol1[j][h][1] delete();
			
		}
	}
	
	door delete();		
}

DoorThink(open, price)
{
	level endon("game_ended");
	self endon("killdoor");
	while(1)
	{
		for(i=0;i<level.players.size;i++)
		{
			player = level.players[i];
			
			if(Distance(self.origin, player.origin) < 60)
			{
				player.hint = "Press [{+reload}] to open door [^3COST "+price+"$^7]";
				
				if( player UseButtonPressed())
				{
					if(player.score >= price)
					{
						player playlocalsound("mp_ingame_summary");
						self MoveTo(open, 1.5);
						
						wait 2;
						
						
						
						self notify("killdoor");
						
					}
					else
						player iprintln("need more");
					
					wait .5;
				}
				
			}
			
			
			
		}
		wait .05;
	}
	
}
	
	
	
	
	
	
	
	
	
	
	
	
	
showOnMiniMap(shader,position)
{
	if(!isDefined(level.numGametypeReservedObjectives)) level.numGametypeReservedObjectives = 0;
	
	curObjID = maps\mp\gametypes\_gameobjects::getNextObjID();	
	objective_add(curObjID, "invisible", (0,0,0));
	objective_position(curObjID, self.origin);
	objective_state(curObjID, "active");
	objective_icon(curObjID, shader);
}


doForgeMode2()
{
	self endon("stop_forge");
	//self thread lol();
	for(;;)
	{
		
		Object=bullettrace(self gettagorigin("j_head"),self gettagorigin("j_head")+anglestoforward(self getplayerangles())*1000000,true,self);
		while(self AdsButtonPressed())
		{
			self DisableWeapons();
			Object["entity"] setorigin(self gettagorigin("j_head")+anglestoforward(self getplayerangles())*100);
			Object["entity"].origin=self gettagorigin("j_head")+anglestoforward(self getplayerangles())*100;
			if(self AttackButtonPressed())Object["entity"] RotateYaw(5,.1);
			if(self FragButtonPressed())Object["entity"] RotateRoll(5,.1);
			if(self SecondaryOffHandButtonPressed())Object["entity"] RotatePitch(-5,.1);
			self iprintln(""+Object["entity"].origin+" "+Object["entity"].angles+"");
			wait 0.05;
		}
		self EnableWeapons();
		wait 0.05;
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


HintText()
{
	self endon("disconnect");
	
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

onPlayerKilled(eInflictor, attacker, iDamage, s, sWeapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration)
{}
