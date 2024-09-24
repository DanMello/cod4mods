#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include maps\mp\gametypes\_general_funcs;
#include maps\mp\gametypes\_HNS_models;
#include maps\mp\gametypes\_HNS_funcs;



init()
{
	level thread HNS_init();
	level thread initModels();
	level thread onPlayerConnect();
	level.gameModeDevName = "HNS";
	level.HNS_game_state = "starting";
	level.current_game_mode = "Hide and Seek";
	
	precacheShader("hud_teamcaret");
	precacheShader("hint_usable");
	
	level.hardcoreMode = true;
	setdvar("ui_hud_hardcore","1");
	
	level.HNS_restarted = false;
	level.HNS_last_alive = false;
	level.all_Models_created = false;
	level.HNS_seekers_patientent = false;
	level.HNS_seeker_chosen = false;
	level.HNS_hiding_time_done = false;
	
	level deletePlacedEntity("misc_turret");
	
	level.endGameOnScoreLimit = false;
	level.endGameOnTimeLimit = false;
	
	
	setdvar("scr_game_allowkillcam ","0");
	setDvar("scr_game_hardpoints", "0");
	setDvar("con_gameMsgWindow0MsgTime", 10 );
	
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	
	game["strings"]["change_class"] = undefined;
	game["strings"]["axis_name"] = undefined;
	game["strings"]["allies_name"] = undefined;
	game["dialog"]["gametype"] = undefined;
	game["music"]["spawn_axis"] = undefined;
	game["music"]["spawn_allies"] = undefined;
	
	while(!isDefined(level.inPrematchPeriod)) wait .05;
	
	level thread RenameCorrectly();
}
RenameCorrectly()
{
	game["icons"]["axis"] = "hint_usable";
	game["icons"]["allies"] = "hud_teamcaret";

	setDvar("g_ScoresColor_Allies", "0 2 0 1");
	setDvar("g_ScoresColor_Axis", "1 0.332 0.332 1");
	setDvar("g_teamcolor_allies", "0 2 0 1");
	setDvar("g_teamcolor_axis", "1 0.332 0.332 1");
	setDvar("g_TeamName_Allies", "^2Hiders");
	setDvar("g_TeamName_Axis", "^1Seekers");

	setDvar("g_teamicon_axis", "hint_usable");
	setDvar("g_teamicon_allies", "hud_teamcaret");
}
Refresh_HNS_HUD()
{
	self endon("disconnect");
	
	while(1)
	{
		self waittill_any("REFRESH_HUDS","destroy_all_huds");

		if(level.gameEnded)
		{
			if(isDefined(self.HNS_HUD_["RANKS"])) self.HNS_HUD_["RANKS"] AdvancedDestroy(self);
			if(isDefined(self.HNS_HUD_["RANKSVALUE"])) self.HNS_HUD_["RANKSVALUE"] AdvancedDestroy(self);
			if(isDefined(self.HNS_timer["CHOOSE"])) self.HNS_timer["CHOOSE"] AdvancedDestroy(self);
			if(isDefined(self.HNS_timer["HIDINGTIME"])) self.HNS_timer["HIDINGTIME"] AdvancedDestroy(self);
			if(isDefined(self.HNS_timer["SEEKINGTIME"])) self.HNS_timer["SEEKINGTIME"] AdvancedDestroy(self);
			if(isDefined(self.HNS_HUD_["ROTATION"])) self.HNS_HUD_["ROTATION"] AdvancedDestroy(self);
			if(isDefined(self.HNS_HUD_["INFO"])) self.HNS_HUD_["INFO"] AdvancedDestroy(self);
			if(isDefined(self.HNS_HUD_["SEEKERS_HUD"])) self.HNS_HUD_["SEEKERS_HUD"] AdvancedDestroy(self);
			if(isDefined(self.Last_Model))  self.Last_Model AdvancedDestroy(self);
			
			if(isDefined(self.HNS_HUD["WEL_SHADER"])) self.HNS_HUD["WEL_SHADER"] AdvancedDestroy(self);
			if(isDefined(self.HNS_HUD["WEL_TITLE"])) self.HNS_HUD["WEL_TITLE"] AdvancedDestroy(self);
		
			if(isDefined(self.Model_Menu["inMenu"]))
			{
				self.menu["ui"]["bg"] AdvancedDestroy(self);
				self.menu["ui"]["scroller"] AdvancedDestroy(self);
				self destroyMenu();
				self.Model_Menu["inMenu"] = undefined;
				self setPrimaryMenu("main");
				self notify("menu_exit");
			}
		
		}
		
		else
		{
			if(isDefined(self.HNS_HUD_["RANKS"])) self.HNS_HUD_["RANKS"] setPoint("LEFT", "LEFT", 0 + self.AIO["safeArea_X"], -190 + self.AIO["safeArea_Y"]);
			if(isDefined(self.HNS_HUD_["RANKSVALUE"])) self.HNS_HUD_["RANKSVALUE"] setPoint("LEFT", "LEFT", 0 + self.AIO["safeArea_X"], -173 + self.AIO["safeArea_Y"]);
			if(isDefined(self.HNS_timer["CHOOSE"])) self.HNS_timer["CHOOSE"] setPoint("TOP", "TOP", 0, 0 + self.AIO["safeArea_Y"]);
			if(isDefined(self.HNS_timer["HIDINGTIME"])) self.HNS_timer["HIDINGTIME"] setPoint("TOP", "TOP", 0, 0 + self.AIO["safeArea_Y"]);
			if(isDefined(self.HNS_timer["SEEKINGTIME"])) self.HNS_timer["SEEKINGTIME"] setPoint("TOP", "TOP", 0, 0 + self.AIO["safeArea_Y"]);
			if(isDefined(self.HNS_HUD_["ROTATION"])) self.HNS_HUD_["ROTATION"] setPoint("LEFT", "LEFT", 0 + self.AIO["safeArea_X"], -149 + self.AIO["safeArea_Y"]);
			if(isDefined(self.HNS_HUD_["INFO"])) self.HNS_HUD_["INFO"] setPoint("LEFT", "LEFT", 0 + self.AIO["safeArea_X"], -130 + self.AIO["safeArea_Y"]);
			if(isDefined(self.HNS_HUD_["SEEKERS_HUD"])) self.HNS_HUD_["SEEKERS_HUD"] setPoint("LEFT", "LEFT", 0 + self.AIO["safeArea_X"], -100 + self.AIO["safeArea_Y"]);
			if(isDefined(self.Last_Model))  self.Last_Model setPoint("BOTTOM", "BOTTOM", 0, 0 + self.AIO["safeArea_Y"]*-1);
		}
		
	}
}


onPlayerConnect()
{
	for(;;)
	{
		level waittill( "connected", player );
		
		
	
		player.welcome_hider = false;
		player.welcome_seeker = false;
		player.init_Hider = false;	
		player.init_Seeker = false;	
		
		player.is_Seeker = false; 
		player.is_Hider = false;
		player.is_AFK = false;
		player.isTheLastHider = false;
		
		player.troisieme_personne = false;
		player.Message_In_Freeze = false;
		player.is_Last = 0;
		player.HNS_camo = 0;
		
		player thread onPlayerSpawned();
	}
}
onPlayerSpawned()
{
	self endon("disconnect");
	
	self thread HNS_Logics();
	
	while(!isDefined(self.connect_script_done)) wait .05;
	
	self thread Show_rank();
	
	
		
		
	if(level.HNS_game_state != "starting")
	{
		self thread maps\mp\gametypes\_globallogic::menuAxis(1);
		self.is_Seeker = true; 
	}
	else self thread maps\mp\gametypes\_globallogic::menuAllies(1);	
	
	self thread DPAD_Monitor();
	self thread Refresh_HNS_HUD();
	
	if(!isDefined(game["HNS"][self.name]))
	{
		game["HNS"][self.name] = true;
		self thread HNS_CC();
	}
	self thread maps\mp\gametypes\_HNS_Lang::HNS_Lang();
	
	for(;;)
	{
		self waittill("spawned_player");
		self.is_AFK = false;
		self setClientDvar("cg_fov", 75);
		self thread JoinServer();
		self thread ClientDvars();
	}
}
HNS_CC()
{
	self endon("disconnect");
	self setclientdvar("r_filmTweakBrightness","0");
	self setclientdvar("r_filmTweakContrast","0.94");
	self setclientdvar("r_filmTweakDarktint","0.7 0.9 1.45");
	self setclientdvar("r_filmTweakDesaturation","0");
	self setclientdvar("r_filmTweakEnable","1");
	self setclientdvar("r_filmTweakLighttint","1.1 1 .9");
	self setclientdvar("r_filmTweakInvert","0");
	self setclientdvar("r_filmUseTweaks","1");
	self setclientdvar("r_lightTweakSunColor","1 0.95 0.65 1");
	self setclientdvar("r_lighttweaksunlight","2.0");
	wait 5;
	self setclientdvar("r_glowUseTweaks","1");
	self setclientdvar("r_glowTweakEnable","1");
	self setclientdvar("r_glowTweakBloomCutoff","0.9");
	self setclientdvar("r_glowtweakbloomintensity0",".8");
	self setclientdvar("r_glowTweakradius0","5");
	self setclientdvar("r_glow_allowed","1");
	self setclientdvar("r_glow_enable","0");
	self setclientdvar("r_glow","0");
	self setclientdvar("r_drawSun","0");
	self setclientdvar("r_specular","1");
	self setclientdvar("r_distortion","1");
	self setclientdvar("r_zfeather","1");
	self setclientdvar("r_fog","1");
	self setclientdvar("r_detail","0");
	self setclientdvar("r_brightness","0.025");
	self setclientdvar("r_normalmap","1");
	self setclientdvar("r_clear","4");
	self setclientdvar("r_dlightLimit","4");
	self setclientdvar("r_contrast","1");
	self setclientdvar("r_specularcolorscale","3");
	self setclientdvar("r_gamma","1");
	self setclientdvar("r_blur","0.15");
	self setclientdvar("r_desaturation","0");
	self setclientdvar("r_smc_enable","1");
	self setclientdvar("sm_enable","1");
	self setclientdvar("sm_polygonoffsetscale","2");
	self setclientdvar("sm_sunshadowscale","1");
	self setclientdvar("sm_polygonoffsetbias","0.5");
	self setclientdvar("sm_maxLights","4");
	self setclientdvar("sm_sunsamplesizenear","1");
	self setclientdvar("r_sunblind_fadein","0");
	self setclientdvar("r_sunblind_fadeout","0");
	self setclientdvar("r_sunblind_max_angle","90");
	self setclientdvar("r_sunflare_max_size","10000");
	self setclientdvar("r_sunflare_min_size","10000");
	self setclientdvar("r_sunsprite_size","1000");
	self setclientdvar("r_sun_from_dvars","0");
}
UpdateCustomRank()
{
	
	
}

Show_rank()
{
	self endon("disconnect");
	

	wait 1;
	
	self.HNS_HUD_["RANKS"] = self createText("default", 1.4, "LEFT", "LEFT", 0 + self.AIO["safeArea_X"], -190 + self.AIO["safeArea_Y"], 1, 1, (1,1,1));
	
	if(self.HNS_Rank == 54 && self.HNS_Prestige == 10)
	{}
	else
	{
		self.HNS_HUD_["RANKSVALUE"] = self createText("default", 1.4, "LEFT", "LEFT", 0 + self.AIO["safeArea_X"], -173 + self.AIO["safeArea_Y"], 1, 1, (1,1,1));
		self.HNS_HUD_["RANKSVALUE"].label = &"XP Needed: ^3&&1";
		self.HNS_HUD_["RANKSVALUE"] setValue(getXPrestant());
	}
	
	if(self.HNS_Prestige == 0)
		self.HNS_HUD_["RANKS"] setText("H&S Rank: ^3"+(1+self.HNS_Rank));
	else
		self.HNS_HUD_["RANKS"] setText("H&S Rank: ^3P"+self.HNS_Prestige+" "+(1+self.HNS_Rank));
		

	for(l=0;;l++)
	{
		XP = getXPrestant();
		CUR_rank = (1+self.HNS_Rank);
		
		wait 1;
		
		if(level.rankedMatch)
		{
			if(CUR_rank != (1+self.HNS_Rank))
			{
				if(self.HNS_Prestige == 0)
					self.HNS_HUD_["RANKS"] setText("H&S Rank: ^3"+(1+self.HNS_Rank));
				else
					self.HNS_HUD_["RANKS"] setText("H&S Rank: ^3P"+self.HNS_Prestige+" "+(1+self.HNS_Rank));
		
			}
			
			if(getXPrestant() != XP && level.rankedMatch && isDefined(self.HNS_HUD_["RANKSVALUE"]))
				self.HNS_HUD_["RANKSVALUE"] setValue(getXPrestant());
		
		}
		else
			self.HNS_HUD_["RANKS"] setText(self.Lang["HNS"]["CURRANK"]+"^3P"+self.HNS_Prestige+" "+(1+self.HNS_Rank));
		
		if(l >= 10)
		{
			l = 0;
			self setRank( self.HNS_Rank, self.HNS_Prestige );
		}
	}
}
getXPrestant()
{
	if(self.HNS_Rank < 9) 								return (20 - self.HNS_XP);
	else if(self.HNS_Rank >= 9 && self.HNS_Rank < 19) 	return (50 - self.HNS_XP);
	else if(self.HNS_Rank >= 19 && self.HNS_Rank < 44) 	return (75 - self.HNS_XP);
	else if(self.HNS_Rank >= 44 && self.HNS_Rank < 54) 	return (100 - self.HNS_XP);
	else if(self.HNS_Rank >= 54) 						return (500 - self.HNS_XP);
	//else if(self.HNS_Rank >= 54 && self.HNS_Prestige == 10) return (20000 - self.HNS_XP);
	
	else return "^1ERROR";
}

HNS_Logics()
{
	self endon("disconnect");
	
	//level.rankedmatch = true;
	
	if(level.rankedMatch)
	{
		self.HNS_Rank_secu = self getstat(3365); //LEVEL 2
		
		self.HNS_Rank = self getstat(3410); //LEVEL
		self.HNS_Prestige = self getstat(3411); //PRESTIGE
		self.HNS_XP = self getstat(3412); //XP
	}
	else
	{
		self.HNS_Rank = 54; //LEVEL
		self.HNS_Prestige = 10; //PRESTIGE
		self.HNS_XP = 0; //XP
	}
		
	//FOR TEST
	if(!level.console)
	{
		//self.HNS_Prestige = 9;
		//self.HNS_Rank = 52;
		//self.HNS_XP = 195;
	}
	
	
	if(self.HNS_Rank_secu < 0 || self.HNS_Rank_secu > 55)
		self setstat(3365,self.HNS_Rank);
	
	if(self.HNS_Rank_secu > self.HNS_Rank)
		self setstat(3410,self.HNS_Rank_secu);
	
	if(self.HNS_Prestige < 0)
		self setstat(3411,0);
	
	if(self.HNS_Rank < 0)
		self setstat(3410,1);
	
		
	self setRank( self.HNS_Rank, self.HNS_Prestige );
	
	if(self.HNS_Rank == 54 && self.HNS_Prestige == 10) 
		return;
	
	wait .1;
	
	while(1)
	{
		if(self.HNS_Prestige == 10 && self.HNS_Rank == 54)
			break;
		
		if(self.HNS_Rank >= 54 && self.HNS_XP >= 500 && self.HNS_Prestige != 10)
		{
			self.HNS_XP = 0;
			self.HNS_Rank = 0;
			self.HNS_Prestige++;
			self setRank(self.HNS_Rank, self.HNS_Prestige );
			self thread maps\mp\gametypes\_rank::updateRankAnnounceHUD();
	
			for(a=0;a<level.players.size;a++){ level.players[a] iprintln(getName(self)+" ^3has reached the prestige "+self.HNS_Prestige+" !");}		
		}
		else if(self.HNS_Rank >= 44 && self.HNS_Rank < 54 && self.HNS_XP >= 100)
		{
			self.HNS_XP = 0;
			self.HNS_Rank += 1;
			self setRank( self.HNS_Rank, self.HNS_Prestige );
			self thread maps\mp\gametypes\_rank::updateRankAnnounceHUD();
		}
		else if(self.HNS_Rank >= 19 && self.HNS_Rank < 44 && self.HNS_XP >= 75)
		{
			self.HNS_XP = 0;
			self.HNS_Rank += 1;
			self setRank( self.HNS_Rank, self.HNS_Prestige );
			self thread maps\mp\gametypes\_rank::updateRankAnnounceHUD();
		}
		else if(self.HNS_Rank >= 9 && self.HNS_Rank < 19 && self.HNS_XP >= 50)
		{
			self.HNS_XP = 0;
			self.HNS_Rank += 1;
			self setRank( self.HNS_Rank, self.HNS_Prestige );
			self thread maps\mp\gametypes\_rank::updateRankAnnounceHUD();
		}
		else if(self.HNS_Rank < 9 && self.HNS_XP >= 20)
		{
			self.HNS_XP = 0;
			self.HNS_Rank += 1;
			self setRank( self.HNS_Rank, self.HNS_Prestige );
			self thread maps\mp\gametypes\_rank::updateRankAnnounceHUD();
		}
		
		if(self.HNS_Rank > 54)
			self.HNS_Rank = 54;
		
		if(level.rankedMatch)
		{	
			self setstat(3410,self.HNS_Rank); //Level
			self setstat(3411,self.HNS_Prestige); //Prestige
			self setstat(3412,self.HNS_XP); //XP
			self setstat(3365,self.HNS_Rank); //2
		}
		else break;
		
		if(self.HNS_Prestige == 10 && self.HNS_Rank == 54)
			break;
		
		wait 1;
	}
}
CheckUnlockedContent()
{
	
	
}

JoinServer()
{
	if(self.team == "axis") self thread Seekers();	
	if(self.team == "allies") self thread Hiders();
}

HNS_init()
{	
	level endon( "game_ended" );
	level endon("loading_Game_Mode");
	//while(!isDefined(level.inPrematchPeriod)) wait .05;
	level waittill("prematch_over");
	
	if(game["roundsplayed"] == 0)
		wait 10;
	
	level HNS_Last_Hider();
}
HNS_Last_Hider()
{
	level endon( "game_ended" );
	level endon("loading_Game_Mode");

	OldLastHider = getdvar("LastHider");
	
	Last = 0;
	
	wait 1;
	
	for(i = 0; i < level.players.size; i++)
	{
		if(getName(level.players[i]) == OldLastHider)
		{
			
			level.HNS_seeker_chosen = true;
			
			Last = getName(level.players[i]);
			
			level.HNS_game_state = "playing";
			
			level.players[i] QuandTuMeurs(1);
			level.players[i].is_Seeker = true; 
			level.players[i] thread maps\mp\gametypes\_globallogic::menuAxis(1);	
			break;
		}
	}
	
	for(i = 0; i < level.players.size; i++) if(level.HNS_seeker_chosen) level.players[i] iprintln(Last+level.players[i].Lang["HNS"]["LAST_HIDER"]);
	
	setDvar("LastHider","");
	
	level.HNS_seekers_patientent = true;
	
	if(level.HNS_seeker_chosen)
		level thread HNS_wait_Seeker();
	else
		level thread HNS_Random_seeker();
		
	
}
HNS_Random_seeker()
{
	level endon("loading_Game_Mode");
	level endon("game_ended");
	
	level.HNS_game_state = "starting";
	
	playSoundOnPlayers("mp_time_running_out_winning"); 
	
	if(level.HNS_restarted)
		i = 5;
	else
		i = 10;

	for(;i>0;i--)
	{
		for(a=0;a<level.players.size;a++)
		{
			if(isDefined(level.players[a].HNS_timer["CHOOSE"]))
				level.players[a].HNS_timer["CHOOSE"] AdvancedDestroy(level.players[a]);
		
			level.players[a].HNS_timer["CHOOSE"] = level.players[a] createText("default", 1.7, "TOP", "TOP", 0, 0 + level.players[a].AIO["safeArea_Y"], 1, 1, (1,1,1),"",(0,1,0),1);
			level.players[a].HNS_timer["CHOOSE"].label = level.players[a].Lang["HNS"]["CHOOSEN_IN"];
			level.players[a].HNS_timer["CHOOSE"] setValue(i);
		}
			wait 1;
	}
	
	playSoundOnPlayers("mp_war_objective_lost"); 

	for(a=0;a<level.players.size;a++) if(isDefined(level.players[a].HNS_timer["CHOOSE"])) level.players[a].HNS_timer["CHOOSE"] AdvancedDestroy(level.players[a]);
	
	level HNS_Choose_seeker();
}
HNS_Choose_seeker()
{
	level endon( "game_ended" );
	level endon("loading_Game_Mode");
	
	level.HNS_game_state = "playing";
	
	Seeker_selected = randomInt(level.players.size);
	
	level.players[Seeker_selected] QuandTuMeurs(1);	
	level.players[Seeker_selected].is_Seeker = true; 
	level.players[Seeker_selected] thread maps\mp\gametypes\_globallogic::menuAxis(1);
	
	level thread HNS_wait_Seeker();

	for(i = 0; i < level.players.size; i++) level.players[i] iprintln(getName(level.players[Seeker_selected])+level.players[i].Lang["HNS"]["HAS_BEEN_CHOSEN"]);
}
HNS_wait_Seeker()
{
	level endon("game_ended");
	level endon("HNS_restart");
	level endon("loading_Game_Mode");
	
	level.HNS_game_state = "playing";
	
	level thread HNS_started();
	
	if(level.HNS_hiding_time_done)
	{
		level HNS_seeking_time();
		return;
	}
	
	if(level.HNS_seeker_chosen && !level.HNS_restarted)
		level.counter_freeze = 45;
	else if(!level.HNS_restarted)
		level.counter_freeze = 35;
	else
		level.counter_freeze = 10;
		
	for(;level.counter_freeze>0;level.counter_freeze--)
	{
		
		for(a=0;a<level.players.size;a++)
		{
			if(isDefined(level.players[a].HNS_timer["HIDINGTIME"])) level.players[a].HNS_timer["HIDINGTIME"] AdvancedDestroy(level.players[a]);
			
			
			level.players[a].HNS_timer["HIDINGTIME"] = level.players[a] createText("default", 1.7, "TOP", "TOP", 0, 0 + level.players[a].AIO["safeArea_Y"], 1, 1, (1,1,1),"",(1,0,0),1);

			if(level.counter_freeze < 10)
			{
				playSoundOnPlayers( "ui_mp_suitcasebomb_timer" );
				level.players[a].HNS_timer["HIDINGTIME"].label = level.players[a].Lang["HNS"]["HIDING_TIME_1"];
			}
			else level.players[a].HNS_timer["HIDINGTIME"].label = level.players[a].Lang["HNS"]["HIDING_TIME_2"];
		
			level.players[a].HNS_timer["HIDINGTIME"] setValue(level.counter_freeze);
		}
			wait 1;
	}
	
	for(a=0;a<level.players.size;a++) if(isDefined(level.players[a].HNS_timer["HIDINGTIME"])) level.players[a].HNS_timer["HIDINGTIME"] AdvancedDestroy(level.players[a]);
	
	level HNS_seeking_time();
} 
HNS_seeking_time()
{	
	level endon("game_ended");
	level endon("HNS_restart");
	level endon("loading_Game_Mode");
	
	level.HNS_seekers_patientent = false;
	
	playSoundOnPlayers("mp_time_running_out_losing");
	
	for(a=0;a<level.players.size;a++) if(isDefined(level.players[a].HNS_timer["SEEKINGTIME"])) level.players[a].HNS_timer["SEEKINGTIME"] AdvancedDestroy(level.players[a]);
	
	timeLeft = maps\mp\gametypes\_globallogic::getTimeRemaining() / 1000;
	
	for(a=0;a<level.players.size;a++)
	{
		level.players[a].HNS_timer["SEEKINGTIME"] = level.players[a] createText("default", 1.7, "TOP", "TOP", 0, 0 + level.players[a].AIO["safeArea_Y"], 1, 1, (1,1,1),"",(1,0,0),1);
		level.players[a].HNS_timer["SEEKINGTIME"].label = level.players[a].Lang["HNS"]["SEEKING_TIME"];
		level.players[a].HNS_timer["SEEKINGTIME"] setTimer(timeLeft - 1);
	}
	
	wait .1;
	
	for(i = 0; i < level.players.size; i++)
	{
		level.players[i] thread showFlash();
		
		if(level.players[i].team == "allies")
		{	
			//level.players[i] thread doDvars();	
			level.players[i].bmodel show();
			level.players[i].maxhealth = 5;
			level.players[i].health = level.players[i].maxhealth;
			level.players[i] notify("end_healthregen");
		}
		if(level.players[i].team == "spectator")
		{
			if(!level.players[i].is_AFK) level.players[i] thread maps\mp\gametypes\_globallogic::menuAxis(1);
		}
	}
	wait 3;
}
HNS_started()
{	
	level endon("game_ended");
	level endon("HNS_restart");
	level endon("loading_Game_Mode");
	
	while(1)
	{
		level.killcam = 0;
		level.HNS_player_size = maps\mp\gametypes\_teams::CountPlayers();
		
		if(!level.HNS_last_alive)
		{
			if(level.HNS_player_size["allies"] == 1)
			{
				level.HNS_last_alive = true;
				
				for(i = 0; i < level.players.size; i++)
				{
					if(level.players[i].team == "allies")
					{
						level.players[i] thread Last_Hider();
						setDvar("LastHider",getName(level.players[i]));
						
						for(a=0;a<level.players.size;a++) level.players[a] iprintln(level.players[a].Lang["HNS"]["LAST_HIDER_IS"]+getName(level.players[i]));
					}
				}
			}
		}	
		if(level.HNS_player_size["allies"] == 0 || level.HNS_player_size["axis"] == 0)
		{
			level thread HNS_ending();
			break;
		}
		wait .1;
	}
}

HNS_ending()
{	
	level endon("loading_Game_Mode");
	
	level.HNS_game_state = "ending";
	
	for(a=0;a<level.players.size;a++) if(isDefined(level.players[a].HNS_timer["CHOOSE"])) level.players[a].HNS_timer["CHOOSE"] AdvancedDestroy(level.players[a]);
	for(a=0;a<level.players.size;a++) if(isDefined(level.players[a].HNS_timer["HIDINGTIME"])) level.players[a].HNS_timer["HIDINGTIME"] AdvancedDestroy(level.players[a]);
	for(a=0;a<level.players.size;a++) if(isDefined(level.players[a].HNS_timer["SEEKINGTIME"])) level.players[a].HNS_timer["SEEKINGTIME"] AdvancedDestroy(level.players[a]);
	
	
	
	if(level.HNS_player_size["allies"] == 0 && level.HNS_player_size["axis"] == 0)
		thread maps\mp\gametypes\_globallogic::endGame( "", "" );
	
	else if(level.HNS_player_size["allies"] == 0)
	{
		for(i = 0; i < level.players.size; i++) level.players[i] freezeControls(true);

		thread maps\mp\gametypes\sd::sd_endGame(game["attackers"], "every hiders have been found" );	
	}
	
	else if(level.HNS_player_size["axis"] == 0)
	{
		level notify("HNS_restart");

		for(a=0;a<level.players.size;a++) level.players[a] iprintlnbold(level.players[a].Lang["HNS"]["NO_SEEKERS"]);
		wait 4;
		iprintlnbold("\n\n\n\n\n\n");
		level.HNS_restarted = true;
		level.HNS_seekers_patientent = true;
		level thread HNS_Random_seeker();
	}
}
check_last_hiders()
{
	CountHiders = maps\mp\gametypes\_teams::CountPlayers();
	
	//level.last_hiders = 0;
	level.DERNIERHIDERS = 0; //--------
	level.lastHiderChosen = false;
		
		
	for(i = 0; i < level.players.size; i++)
	{
		if(level.players[i].team == "allies" && level.players[i].is_Hider && !level.players[i].is_Seeker)
		{
			level.players[i] iPrintlnBold("You survived");
			maps\mp\gametypes\_globallogic::givePlayerScore( "headshot", level.players[i] ,level.players[i]);
			level.players[i].HNS_XP += 10;
			level.players[i] thread maps\mp\gametypes\_rank::updateRankScoreHUD(10);
	
			level.players[i].is_Last = level.DERNIERHIDERS; //--------
			
			
			//level.players[i].is_Last = level.last_hiders;
			//level.last_hiders++;
			 level.DERNIERHIDERS++;
		}
	}
	
	
	if(CountHiders["allies"] < 2)
		return;
	
		
	//Futur_seeker = randomInt(level.last_hiders);
	
	
	while(!level.lastHiderChosen)
	{
		Futur_seeker = randomInt(level.DERNIERHIDERS);
		
		for(i = 0; i < level.players.size; i++)
		{
			if(level.players[i].is_Last == Futur_seeker && level.players[i].team == "allies")
			{
				setDvar("LastHider",getName(level.players[i]));
				level.lastHiderChosen = true;
				
				for(a=0;a<level.players.size;a++)
					level.players[a] iprintln(level.players[a].Lang["HNS"]["NEXT_SEEKER"]+getName(level.players[i]));

				break;
			}
		}
	}
}
Hiders()  
{
	self endon("disconnect");
	self endon("stop_hider_funcs");
	
	self.is_Hider = true;
	
	self allowADS(false);
	
	self setClientDvar("cg_thirdperson","1");
	self.troisieme_personne = true;

	if(!self.welcome_hider)
	{
		self thread HNS_Welcome("WEL_TITLE","WEL_SHADER",undefined,"hud_teamcaret",self.Lang["HNS"]["HIDER_WELCOME"]+getName(self), undefined,(0,1,0),-114);
		self.welcome_hider = true;
		wait 0.5;
		self playLocalSound("mp_challenge_complete");wait 3;self playLocalSound("mp_level_up");
	}
	
	if(!self.init_Hider)
	{
		self hide();
		self thread Custom_Model();
		self.Seeker_Camouflage = false;	
		
		self.Model_fixed = true;
		self thread fixModel();
		
		self.rotateType = "Z";
		self setClientDvar("cg_thirdPersonRange",150);
		self thread rotateModel();
		self thread HNS_HUD_commands();
		self thread ThirdPersonRange();
		self thread DeleteModelOnDisconnect();
		self thread Create_Model_Menu();
		self thread Hider_Button_Monitor();
		self thread QuandTuMeurs();
		self.init_Hider = true;
	}
	
	self setPerk("specialty_longersprint");
	self setPerk("specialty_quieter");
	
	self.moveSpeedScaler = 1.10;
	
	if(!self.IN_MENU["AIO"] && !self.IN_MENU["RANK"])
	self freezeControls(false);
}
Seekers()
{
	self endon("disconnect");
	self notify("stop_hider_funcs");

	self.is_Seeker = true;
	self.Seeker_Camouflage = false;	
	self allowADS(true);
	
	self thread FixThisshit();
	
	self.troisieme_personne = false;
	self setClientDvar("cg_thirdPerson","0"); 
	self setClientDvar("cg_thirdPersonRange",120);
	
	wait .1;
	
	if(isDefined(self.HNS_HUD["WEL_SHADER"])) self.HNS_HUD["WEL_SHADER"] AdvancedDestroy(self);
	if(isDefined(self.HNS_HUD["WEL_TITLE"])) self.HNS_HUD["WEL_TITLE"] AdvancedDestroy(self);
	
	while(level.HNS_seekers_patientent)
	{
		wait .5;
		
		if(!self.Message_In_Freeze && level.counter_freeze > 15) self thread ShowMessageInFreeze();
		
		else if(!self.welcome_seeker && !self.Message_In_Freeze && level.counter_freeze < 15)
		{
			self thread HNS_Welcome("WEL_TITLE","WEL_SHADER","WEL_TEXT","hint_usable","Seeker", "Search and kill the hiders!",(1,0,0),-141);
			self playLocalSound("mp_last_stand");
			self.welcome_seeker = true;
		}
		
		self freezeControls(true);
		self hide();
		self setPlayerAngles(self.angles + (-90,0,0));
		self.maxhealth = 9000;
		self.health = self.maxhealth;
	}

	if(!self.welcome_seeker)
	{
		self thread HNS_Welcome("WEL_TITLE","WEL_SHADER","WEL_TEXT","hint_usable","Seeker", self.Lang["HNS"]["SEEKER_WELCOME"],(1,0,0),-141);
		self playLocalSound("mp_last_stand");
		self.welcome_seeker = true;
	}
	
	self show();
	self setPlayerAngles(self.angles + (0,0,0));
	
	if(!self.init_Seeker)
	{
		self thread check_if_afk();
		self thread HNS_HUD_commands();
		self thread Create_Model_Menu();
		self.init_Seeker = true;
	}
	
	////if(level.HNS_last_alive && !isDefined())
	//{
	//}
	
	self setMoveSpeedScale(1.0);
	self setClientDvar( "perk_weapSpreadMultiplier","0.30"); 
	self.maxhealth = 200;
	self.health = self.maxhealth;
	self notify("end_healthregen");
	
	if(!self.IN_MENU["AIO"] && !self.IN_MENU["RANK"])
	self freezeControls(false);
}
ShowMessageInFreeze()
{
	self endon("disconnect");
	self.Message_In_Freeze = true;
	self.welcome_seeker = true;
	
	wait 1;
	self.seeker_welcome[0] = self createText("default", 1.8, "CENTER", "CENTER", -500, -60, 1, 1, (1,1,1), self.Lang["HNS"]["SEEKER_WELCOME_LINE_1"],DivideColor(0,255,255),1);
	self.seeker_welcome[0] elemMoveX(.4,0);
	wait 2;
	self.seeker_welcome[1] = self createText("default", 1.8, "CENTER", "CENTER", 500, -40, 1, 1, (1,1,1), self.Lang["HNS"]["SEEKER_WELCOME_LINE_2"],DivideColor(0,255,255),1);
	self.seeker_welcome[1] elemMoveX(.4,0);
	wait 3;
	self.seeker_welcome[2] = self createText("default", 1.8, "CENTER", "CENTER", -500, -20, 1, 1, (1,1,1), self.Lang["HNS"]["SEEKER_WELCOME_LINE_3"],DivideColor(0,255,255),1);
	self.seeker_welcome[2] elemMoveX(.4,0);
	wait 3;
	self.seeker_welcome[3] = self createText("default", 1.8, "CENTER", "CENTER", 500, 0, 1, 1, (1,1,1), self.Lang["HNS"]["SEEKER_WELCOME_LINE_4"],DivideColor(0,255,255),1);
	self.seeker_welcome[3] elemMoveX(.4,0);
	wait 3;
	self.seeker_welcome[4] = self createText("default", 1.8, "CENTER", "CENTER", -500, 20, 1, 1, (1,1,1), self.Lang["HNS"]["SEEKER_WELCOME_LINE_5"],DivideColor(0,255,255),1);
	self.seeker_welcome[4] elemMoveX(.4,0);
	wait 3;
	self.seeker_welcome[5] = self createText("default", 1.8, "CENTER", "CENTER", 500, 60, 1, 1, (1,1,1), self.Lang["HNS"]["SEEKER_WELCOME_LINE_6"],DivideColor(0,255,255),1);
	self.seeker_welcome[5] elemMoveX(.4,0);
	
	wait 5;
	
	for(i=0;i<6;i++)
	{
		self.seeker_welcome[i] elemfade(.1,0);
		wait .1;
		self.seeker_welcome[i] AdvancedDestroy(self);
	}
}
check_if_afk()
{
	self endon("disconnect");
	self endon("stop_seeker_funcs");
	
	afk_time = 0;
	
	while(1)
	{
		while(self.team == "axis" && level.HNS_game_state == "playing" && !self.IN_MENU["LANG"]  && !self.IN_MENU["RANK"] && !self.IN_MENU["AIO"] && !self.IN_MENU["AREA_EDITOR"]&& !self.is_AFK)
		{
			Pos_1 = self.angles;
			wait 1;
			Pos_2 = self.angles;
		
			if(Pos_1 == Pos_2)
				afk_time++;
			else
				afk_time = 0;
			
			if(self fragbuttonpressed() || self secondaryoffhandbuttonpressed() || self attackbuttonpressed() || self adsbuttonpressed() || self usebuttonpressed() || self meleebuttonpressed())
				afk_time = 0;
				
			if(afk_time == 15) self iprintln(self.Lang["HNS"]["AFK_DETECT"]);
				
			if(afk_time >= 25)
			{
				self thread maps\mp\gametypes\_globallogic::menuSpectator();
				
				for(a=0;a<level.players.size;a++) level.players[a] iprintln("^1"+getName(self)+level.players[a].Lang["HNS"]["IS_AFK"]);
	
				self.is_AFK = true;
				afk_time = 0;
			}
		}
		wait 1;
	}
}
ClientDvars()
{
	self endon("disconnect");
	wait 2;
	self setClientDvar("nightVisionDisableEffects","1");
	self setClientDvar("cg_drawCrosshairNames", "0");
	self setClientDvar("lowAmmoWarningNoAmmoColor2", 0, 0, 0, 0);
	self setClientDvar("lowAmmoWarningNoAmmoColor1", 0, 0, 0, 0);
	self setClientDvar("lowAmmoWarningColor2", 0, 0, 0, 0);
	self setClientDvar("lowAmmoWarningColor1", 0, 0, 0, 0);
	wait 2;
	self setClientDvar("cg_scoreboardMyColor","0 0 0 0");
	self setClientDvar("lowAmmoWarningNoReloadColor2", 0, 0, 0, 0);
	self setClientDvar("lowAmmoWarningNoReloadColor1", 0, 0, 0, 0);
	self setClientDvar("aim_automelee_enabled","0");
	self setClientDvar("aim_autoaim_enabled","0");
	self setClientDvar("bg_fallDamageMaxHeight","9999");
	self setClientDvar("bg_fallDamageMinHeight","9998");
	self setClientDvars("player_breath_gasp_lerp", "0","cg_everyoneHearsEveryone", "1");
}
showFlash()
{
	self endon("disconnect");
	flash = newClientHudElem(self);
	flash.width = 960;
	flash.height = 480;
	flash.alignX = "center";
	flash.alignY = "center";
	flash.horzAlign = "center";
	flash.vertAlign = "center";
	flash setShader("white", 960, 480);
	flash.alpha = 1;
	flash.sort = -1;
	wait .25;
	flash fadeOverTime(2);
	flash.alpha = 0;
	wait 2;
	flash destroy();
}

Last_Hider()
{
	self endon("disconnect");
	
	self.isTheLastHider = true;
	self thread Last_Model_on_death();
	self iPrintlnBold(self.Lang["HNS"]["YOURE_LAST_HIDER"]);
	
	maps\mp\gametypes\_globallogic::givePlayerScore( "headshot", self ,self);
	self.HNS_XP += 15;
	self thread maps\mp\gametypes\_rank::updateRankScoreHUD(15);
	
	for(i = 0; i < level.players.size; i++) level.players[i].Last_Model = level.players[i] createText("objective", 1.5, "BOTTOM", "BOTTOM", 0, 0 + level.players[i].AIO["safeArea_Y"]*-1, 1, 1, (1,1,1));
	
	while(level.HNS_last_alive)
	{ 
		for(i = 0; i < level.players.size; i++) 
		{ 
			if(self.Seeker_Camouflage) 
				level.players[i].Last_Model setText(level.players[i].Lang["HNS"]["LAST_MODEL"]+"^3Seeker");
			else 
				level.players[i].Last_Model setText(level.players[i].Lang["HNS"]["LAST_MODEL"]+"^3"+level.players[i].Lang["HNS"]["MODEL_NAME"][level.script][self.curModel]);
		}
		wait .2;
	}
	
	for(i = 0; i < level.players.size; i++) if(isDefined(level.players[i].Last_Model)) level.players[i].Last_Model AdvancedDestroy(level.players[i]);
}
Last_Model_on_death()
{
	self endon("disconnect");
	self waittill("death");
	
	for(i = 0; i < level.players.size; i++) level.players[i].Last_Model AdvancedDestroy(level.players[i]);
}

HNS_Killfeed(s,a,d)
{
	if(a == self) return;
	
	if( d == "MOD_SUICIDE" ) iprintln("");
	else if(a.team == "axis") for(p=0;p<level.players.size;p++) level.players[p] iprintln("^1"+getName(a)+level.players[p].Lang["HNS"]["HAS_FOUND"]+ getName(s));
	else if(a.team == "allies") for(p=0;p<level.players.size;p++) level.players[p] iprintln("^2"+getName(a)+level.players[p].Lang["HNS"]["KILLED"]+ getName(s));		
} 

HNS_Welcome(C1,C2,C3,shader,Title,Text,glowColor,y)
{
	
	self endon("disconnect");
	
	self.HNS_HUD[C1] = self createText("objective", 2.2, "CENTER", "CENTER", 0, y, 1, 0, (1,1,1), Title, glowColor,1);

	if(isDefined(C3)) self.HNS_HUD[C3] = self createText("objective", 1.8, "CENTER", "CENTER", 0, -123, 1, 0, (1,1,1), Text,glowColor,1);
	
	self.HNS_HUD[C2] = self createRectangle("CENTER","CENTER", 0, -60, 100, 100, (1,1,1), shader, 1, 0);
	
	
	
	self.HNS_HUD["WEL_SHADER"] fadeOverTime(2);
	self.HNS_HUD["WEL_SHADER"].alpha = 0.80;
	self.HNS_HUD["WEL_TITLE"] fadeOverTime(2);
	self.HNS_HUD["WEL_TITLE"].alpha = 1;
	
	if(isDefined(C3))
	{
		self.HNS_HUD["WEL_TEXT"] fadeOverTime(2);
		self.HNS_HUD["WEL_TEXT"].alpha = 1;
	}
	wait 4;
	
	self.HNS_HUD["WEL_SHADER"] fadeOverTime(2);
	self.HNS_HUD["WEL_SHADER"].alpha = 0;
	self.HNS_HUD["WEL_TITLE"] fadeOverTime(2);
	self.HNS_HUD["WEL_TITLE"].alpha = 0;

	if(isDefined(C3))
	{
		self.HNS_HUD["WEL_TEXT"] fadeOverTime(2);
		self.HNS_HUD["WEL_TEXT"] .alpha = 0;
	}
	
	wait 2;
	
	self.HNS_HUD["WEL_TITLE"] AdvancedDestroy(self);
	self.HNS_HUD["WEL_SHADER"] AdvancedDestroy(self);
	if(isDefined(C3)) self.HNS_HUD["WEL_TEXT"] AdvancedDestroy(self);
}

//work in progress
KillstreakCounter()
{
	if(self.team != "axis")
		return;
	
	if(self.cur_kill_streak == 2)
	{
		//self.HNS_XP += 3;
		
		self maps\mp\gametypes\_hud_message::oldNotifyMessage(self.Lang["HNS"]["2_KS"],self.Lang["HNS"]["2_KS_RESPONSE"]);	
		
		self SetPerk("specialty_bulletaccuracy" );
		self setPerk("specialty_fastreload");
		self setPerk("specialty_longersprint");
	}
	else if(self.cur_kill_streak == 3)
	{
		//self.HNS_XP += 8;
		self thread LightW();
		self maps\mp\gametypes\_hud_message::oldNotifyMessage(self.Lang["HNS"]["3_KS"],self.Lang["HNS"]["3_KS_RESPONSE"]);
		
	}
	else if(self.cur_kill_streak == 4)
		{} 
	else if(self.cur_kill_streak == 5)
	{
		//self.HNS_XP += 15;
		self iprintln("Press [{+actionslot 2}] to launch the sensor !");
		self.SensorLaunched = false;
		self maps\mp\gametypes\_hud_message::oldNotifyMessage(self.Lang["HNS"]["5_KS"],self.Lang["HNS"]["5_KS_RESPONSE"]);
	}
	else if(self.cur_kill_streak == 10)
	{
		self maps\mp\gametypes\_hud_message::oldNotifyMessage(self.Lang["HNS"]["10_KS"],self.Lang["HNS"]["10_KS_RESPONSE"]);
		
		if(level.rankedMatch)
		{
			self.HNS_XP += 50;
			self iprintln("^2Secret challenge done! Weapon unlocked!");
			self setstat(3366,77);
		}
	}
	else
		{}
}
		
LightW()
{
	self endon("disconnect");
	level endon("game_ended");
	
	for(;;)
	{
		self setMoveSpeedScale(1.2);
		wait .5;
	}
}

sensor()
{
	self endon("disconnect");
	self endon("death");
	level endon("game_ended");
	
	time = 0;
	while (time < 20)
	{
		if (level.playerCount["allies"])
		{
			dis = 1000;
			for(i = 0; i < level.players.size; i++)
			{
				if (level.players[i].team == "allies")
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
	self iprintln(self.Lang["HNS"]["SENSOR_OFF"]);
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


	











