#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include maps\mp\gametypes\_general_funcs;

//CHALLENGE
/*

3 parkour 1 map
moins de 30s
elevator
rpg
no rpg
bounce

specialty_new 
*/


init()
{
	if(level.utilise_AIO_en_ligne && level.console)
		return;
		
	level thread initMap();
	level thread onPlayerConnect();
	
	setDvar( "ui_hud_hardcore", 1 );
	level.hardcoremode = true;
	level.prematchPeriod = 0;
	level.current_game_mode = "Floor is lava";
	level.gameModeDevName = "Lava";
	level.game_state = "starting";
	
	level.impact_fx = loadfx("explosions/artilleryExp_dirt_brown");
	level.flagBase_red = loadfx( "misc/ui_flagbase_red" );
	level.yellow_circle = loadfx( "misc/ui_pickup_available" );
	
	setDvar("jump_slowdownEnable","0");
	
	setDvar("bg_fallDamageMaxHeight",9999);
	setDvar("bg_fallDamageMinHeight",9998);
	setDvar("ui_hud_showdeathicons", "0");
	setDvar("scr_game_hardpoints", "0");
	setdvar("scr_showperksonspawn", "0");
	setdvar("scr_game_allowkillcam","0");
	
	
	precacheShader("animbg_blur_front");
	precacheShader("animbg_blur_back");
	precacheShader("specialty_longersprint");
	precacheShader("dtimer_bg_border");
	precacheShader("compass_waypoint_defend_a");
	precacheShader("compass_waypoint_defend_b");
	precacheShader("compass_waypoint_defend_c");
	
	precacheShader("killicondied");
	precacheShader("weapon_rpg7");
	precacheShader("specialty_locked");
	precacheShader("specialty_new");
	precacheShader("gradient_fadein");
	
	
	
	level deletePlacedEntity("misc_turret");
	
	while(!isDefined(level.inPrematchPeriod)) wait .05;
	
	game["strings"]["change_class"] = "";
	game["strings"]["axis_name"] = "";
	game["strings"]["allies_name"] = "";
	game["dialog"]["gametype"] = undefined;
	game["music"]["spawn_axis"] = undefined;
	game["music"]["spawn_allies"] = undefined;
	game["icons"]["axis"] = "";
	game["icons"]["allies"] = "";
	
	setDvar("g_teamname_axis","^0Death");
	setDvar("g_teamname_allies","^3Runners");
	
	setDvar("g_ScoresColor_Allies","2 0.498 0");
	setDvar("g_ScoresColor_axis","0 0.492 0.492 0");
	
	setDvar("g_ScoresColor_Spectator","0.492 0.492 0.492 1");
	setDvar("g_ScoresColor_Free","0.492 0.492 0.492 1");
	
	setDvar("cg_scoreBoardMyColor","0 0 0 1");
	
	setDvar("g_teamicon_axis", "killicondied");
	setDvar("g_teamicon_allies", "specialty_longersprint");
	
}

onPlayerConnect()
{
	for(;;)
	{
		level waittill( "connected", player );
	
		player.lavaweapon = "usp_mp";
		player.enableperks = false;
		
		player.customPrestige = player getstat(3256);	
		player initStatsVariables();
		
		
		player thread onPlayerSpawned();
	}
}
initStatsVariables()
{
	self.podium["first"] = false;
	self.podium["second"] = false;
	self.podium["third"] = false;
	self.triggerzone = false;
	self.estmort = false;
	//init variables run
	self.parkour = "A"; //parkour choisis au debut
	
	self.my_score["A"] = self getstat(level.stats_backlot["A"]); //record effectu?
	self.my_score["B"] = self getstat(level.stats_backlot["B"]); //record
	self.my_score["C"] = self getstat(level.stats_backlot["C"]); //record
	self.my_currentScore = 0; //time du run en court 
	
	if(self.my_score["A"] == 0) self setstat(level.stats_backlot["A"],999);
	if(self.my_score["B"] == 0) self setstat(level.stats_backlot["B"],999);
	if(self.my_score["C"] == 0) self setstat(level.stats_backlot["C"],999);
	
	self.my_score["A"] = self getstat(level.stats_backlot["A"]); //record effectu?
	self.my_score["B"] = self getstat(level.stats_backlot["B"]); //record
	self.my_score["C"] = self getstat(level.stats_backlot["C"]); //record
	
	self.CurrentSpawn = undefined;
	self.CurrentAngles = undefined;
	self.client_maxvelocity = 0;
	self.difficulty = "none";
	self.isDeathRun = false;
	
	self.score = self.my_score["A"]; //scoreboard record
	self.kills = self.my_score["B"];
	self.assists = self.my_score["C"];
	
	level notify("update_parkour_score");
}
updatescoreboard()
{
	self.score = self.my_score["A"]; //scoreboard record
	self.kills = self.my_score["B"];
	self.assists = self.my_score["C"];
}

onPlayerSpawned()
{
	self endon("disconnect");
	
	//self setstat(3247,0);
	//self setstat(3248,0);
	//self setstat(3249,0);
	//self setstat(3250,0);
	//self setstat(3251,0);
	//self setstat(3252,0);
	//self setstat(3253,0);
	//self setstat(3254,0);
	//self setstat(3255,0);
	
	self.insafezone = false;
	self.FirstPos = self.origin;
	self.FirstAng = self.angles;
	self.parkourchosen = false;
	self setClientDvar("fx_marks",0);
	
	self thread challengemenu();
	self thread watchBounces();
	self thread MenuOptions();
	self thread MenuControls();
	
	for(;;)
	{
		self waittill("spawned_player");
		
		self setRank(0,self.customprestige );
		self.challenge["bounce"] = false;
		self.challenge["sprint"] = false;
		self.challenge["elevator"] = false;
		self.challenge["rpg"] = false;
		self.challenge["norpg"] = false;
		self.challenge["3in1"] = false;
		self.challenge["coffee"] = false;
		self.challenge["sky"] = false;
		self.challenge["9lives"] = false;

		//if(self getentitynumber() == 0) self thread maps\mp\gametypes\_cj_functions::noclip();
		
		self thread RPG_DPAD();
		self thread RPG_Security();
		
		if(isDefined(self.HUD["current_time"])) advanceddestroy(self);
		if(isDefined(self.HUD["CJ"]["velocity"])) advanceddestroy(self);
		if(isDefined(self.HUD["CJ"]["velocity1"])) advanceddestroy(self);
	
		if(self.parkourchosen)
		{
			self thread setParkourTime();
			self thread CheckingVelocity();
			self thread getPlayerScore(self.parkour);
		}
		else
			self thread Modstarting();	
		
		
		self.triggerzone = false; 
		
		
	}
}
SubMenu(numsub)
{
	if(isDefined(self.LavaMenu["Text"])) self.LavaMenu["Text"] AdvancedDestroy(self);
	
	self.LavaMenu["Sub"] = numsub;
	self.LavaMenu["Curs"] = 0;
	self.LavaMenu["HUD"]["Curs"][0] setpoint("CENTER", "CENTER", self.LavaMenu["HUD"]["Curs"][0].x, ((self.LavaMenu["Curs"]*16.8) - 100));
	self.HUD_lava["front_text"] setText(self.LavaMenu["fronttext"][numsub]);
	
	if(self.LavaMenu["Sub"] == "chllge")
	{
		if(!isDefined(self.HUD_lava["text2"])) self.HUD_lava["text2"] = self createText("default", 1.6, "CENTER", "CENTER",  150 , 0 , 5, 1, (1,1,1), "");
		if(!isDefined(self.HUD_lava["text3"])) self.HUD_lava["text3"] = self createText("default", 1.6, "CENTER", "CENTER",  150 , 35 , 5, 1, (1,1,1), "");
		if(!isDefined(self.HUD_lava["speciality"][0])) self.HUD_lava["speciality"][0] = self createRectangle("CENTER", "CENTER", -50, -100, 50, 30, (1,1,1), "specialty_locked", 6,1);	
		if(!isDefined(self.HUD_lava["speciality"][1])) self.HUD_lava["speciality"][1] = self createRectangle("CENTER", "CENTER", -50, -67, 50, 30, (1,1,1), "specialty_locked", 6,1);	
		if(!isDefined(self.HUD_lava["speciality"][2])) self.HUD_lava["speciality"][2] = self createRectangle("CENTER", "CENTER", -50, -33, 50, 30, (1,1,1), "specialty_locked", 6,1);	
		if(!isDefined(self.HUD_lava["speciality"][3])) self.HUD_lava["speciality"][3] = self createRectangle("CENTER", "CENTER", -50, 1, 50, 30, (1,1,1), "specialty_locked", 6,1);	
		if(!isDefined(self.HUD_lava["speciality"][4])) self.HUD_lava["speciality"][4] = self createRectangle("CENTER", "CENTER", -50, 35, 50, 30, (1,1,1), "specialty_locked", 6,1);	
		if(!isDefined(self.HUD_lava["speciality"][5])) self.HUD_lava["speciality"][5] = self createRectangle("CENTER", "CENTER", -50, 68, 50, 30, (1,1,1), "specialty_locked", 6,1);	
		if(!isDefined(self.HUD_lava["speciality"][6])) self.HUD_lava["speciality"][6] = self createRectangle("CENTER", "CENTER", -50, 101, 50, 30, (1,1,1), "specialty_locked", 6,1);	
		if(!isDefined(self.HUD_lava["speciality"][7])) self.HUD_lava["speciality"][7] = self createRectangle("CENTER", "CENTER", -50, 134, 50, 30, (1,1,1), "specialty_locked", 6,1);	
		if(!isDefined(self.HUD_lava["speciality"][8])) self.HUD_lava["speciality"][8] = self createRectangle("CENTER", "CENTER", -50, 167, 50, 30, (1,1,1), "specialty_locked", 6,1);	
		
		self KSpreview();
	}
	if(self.LavaMenu["Sub"] == "unloc")
	{
		if(!isDefined(self.HUD_lava["speciality"][0])) self.HUD_lava["speciality"][0] = self createRectangle("CENTER", "CENTER", -50, -100, 50, 30, (1,1,1), "specialty_locked", 6,1);	
		if(!isDefined(self.HUD_lava["speciality"][1])) self.HUD_lava["speciality"][1] = self createRectangle("CENTER", "CENTER", -50, -67, 50, 30, (1,1,1), "specialty_locked", 6,1);	
		if(!isDefined(self.HUD_lava["speciality"][2])) self.HUD_lava["speciality"][2] = self createRectangle("CENTER", "CENTER", -50, -33, 50, 30, (1,1,1), "specialty_locked", 6,1);	
		if(!isDefined(self.HUD_lava["speciality"][3])) self.HUD_lava["speciality"][3] = self createRectangle("CENTER", "CENTER", -50, 1, 50, 30, (1,1,1), "specialty_locked", 6,1);	
		if(!isDefined(self.HUD_lava["speciality"][4])) self.HUD_lava["speciality"][4] = self createRectangle("CENTER", "CENTER", -50, 35, 50, 30, (1,1,1), "specialty_locked", 6,1);	
		
		self unlocreview();
	}
	
	
	self DrawTexts();
	self.LavaMenu["Text"]elemFade(.3,1);
}
ChallengeUnlocked(challenge)
{
	
	
	
	
	switch (challenge)
	{
		case "bounce":
		
		if(self getstat(3252) != 7)
		{
			self showunlockedchallenge("Finish a parkour having bounced once");
			self.customPrestige++;
			self setstat(3252,7);
			wait 5;
		}
		break;
		
		case "sprint":
		if(self getstat(3254) != 7)
		{
			self showunlockedchallenge("Get a speed more than 350");
			self.customPrestige++;
			self setstat(3254,7);
			wait 5;
		}
		break;
		
		case "elevator":
		if(self getstat(3249) != 7)
		{
			self showunlockedchallenge("Do an elevator and finish the parkour");
			self.customPrestige++;
			self setstat(3249,7);
			wait 5;
		}
		break;
		
		case "rpg":
		if(self getstat(3250) != 7)
		{
			self showunlockedchallenge("Finish a parkour using RPG jumps");
			self.customPrestige++;
			self setstat(3250,7);
			wait 5;
		}
		break;
		
		case "norpg":
		if(self getstat(3251) != 7)
		{
			self showunlockedchallenge("Finish a parkour without rpg jumps");
			self.customPrestige++;
			self setstat(3251,7);
			wait 5;
		}
		break;
		
		case "3in1":
		if(self getstat(3247) != 7)
		{
			self showunlockedchallenge("Finish 3 parkours on a map");
			self.customPrestige++;
			self setstat(3247,7);
			wait 5;
		}
		break;
		
		case "coffee":
		if(self getstat(3248) != 7)
		{
			self showunlockedchallenge("Finish a parkour than less 30 seconds");
			self.customPrestige++;
			self setstat(3248,7);
			wait 5;
		}
		break;
		
		case "sky":
		if(self getstat(3255) != 7)
		{
			self showunlockedchallenge("Get on top of the highest point of the map");
			self.customPrestige++;
			self setstat(3255,7);
			wait 5;
		}
		break;
		
		case "9Lives":
		if(self getstat(3253) != 7)
		{
			self showunlockedchallenge("Finish a parkour using less than 9 lives");
			self.customPrestige++;
			self setstat(3253,7);
			wait 5;
		}
		break;
	}
	
	self setstat(3256,self.customPrestige);
	self setRank(1,self.customprestige );
}
showunlockedchallenge(text)
{
	
	notifyData = spawnStruct();
	notifyData.titleText = "CHALLENGE UNLOCKED";
	notifyData.iconName = "specialty_new";
	notifyData.sound = "mp_challenge_complete";
	notifyData.duration = 4.0;
	notifyData.notifyText = text;
	//notifyData.textIsString = true;

	thread maps\mp\gametypes\_hud_message::notifyMessage( notifyData );
	
	
}


MenuControls()
{
	self endon("disconnect");
	
	for(;;)
	{
		UsingNothing = self.IN_MENU["CONF"] || self.IN_MENU["P_SELECTOR"] || self.IN_MENU["LANG"] || self.IN_MENU["RANK"] || self.IN_MENU["AREA_EDITOR"] || self.IN_MENU["CJ"] || self.IN_MENU["REPLAY"];
		
		if(self.IN_MENU["Lava"] && !UsingNothing && !level.already_Loaded && !self.killcam && isAlive(self) && !self.IN_MENU["AIO_ANIM"])
		{
			if(!self.isScrolling && self AttackButtonPressed() || self AdsButtonPressed())
			{
				self.isScrolling = true;
				
				if(self AttackButtonPressed() || self AdsButtonPressed()) self playlocalsound("mouse_over");
				
				if(self AttackButtonPressed()) self.LavaMenu["Curs"] ++;
				if(self AdsButtonPressed()) self.LavaMenu["Curs"] --;
				
				
				if(self.LavaMenu["Curs"] >= self.LavaMenu["Option"]["Name"][self.LavaMenu["Sub"]].size )
					self.LavaMenu["Curs"] = 0;
		
				if(self.LavaMenu["Curs"] < 0)
					self.LavaMenu["Curs"] = self.LavaMenu["Option"]["Name"][self.LavaMenu["Sub"]].size-1;
				
				if(self.LavaMenu["Sub"] == "chllge") self KSpreview();
				
				
				self.LavaMenu["HUD"]["Curs"][0] setpoint("CENTER", "CENTER", self.LavaMenu["HUD"]["Curs"][0].x, ((self.LavaMenu["Curs"]*33.4) - 100));

				wait .2;
				self.isScrolling = false;
			}
				
			if(self UseButtonPressed() && !UsingNothing)
			{
				self playlocalsound("intelligence_pickup");
				
				self thread [[self.LavaMenu["Func"][self.LavaMenu["Sub"]][self.LavaMenu["Curs"]]]](self.LavaMenu["Input"][self.LavaMenu["Sub"]][self.LavaMenu["Curs"]],self.LavaMenu["Input2"][self.LavaMenu["Sub"]][self.LavaMenu["Curs"]]);		
				wait .3;
			}
			
			if(self MeleeButtonPressed() && !UsingNothing && self.LavaMenu["Sub"] != "Main") 
				self ExitMenu();	
			if(self.team == "spectator"  || self.sessionstate == "spectator")
				self Quitteca();
			
		}
		
		
		wait .05;
	}
}
Quitteca()
{
	self playlocalsound("weap_suitcase_drop_plr");
	wait .3;
	
	if(isDefined(self.HUD_lava["front_text"])) self.HUD_lava["front_text"] AdvancedDestroy(self);
		
	if(isDefined(self.LavaMenu["HUD"]["Curs"][0])) self.LavaMenu["HUD"]["Curs"][0] AdvancedDestroy(self);
	if(isDefined(self.LavaMenu["Text"])) self.LavaMenu["Text"] AdvancedDestroy(self);
	if(isDefined(self.HUD_lava["background"])) self.HUD_lava["background"] AdvancedDestroy(self);	
	if(isDefined(self.HUD_lava["background2"])) self.HUD_lava["background2"] AdvancedDestroy(self);	
	if(isDefined(self.HUD_lava["text2"])) self.HUD_lava["text2"] AdvancedDestroy(self);	
	if(isDefined(self.HUD_lava["text3"])) self.HUD_lava["text3"] AdvancedDestroy(self);	
	
	if(isDefined(self.HUD_lava["speciality"][0])) self.HUD_lava["speciality"][0] AdvancedDestroy(self);	
	if(isDefined(self.HUD_lava["speciality"][1])) self.HUD_lava["speciality"][1] AdvancedDestroy(self);	
	if(isDefined(self.HUD_lava["speciality"][2])) self.HUD_lava["speciality"][2] AdvancedDestroy(self);	
	if(isDefined(self.HUD_lava["speciality"][3])) self.HUD_lava["speciality"][3] AdvancedDestroy(self);	
	if(isDefined(self.HUD_lava["speciality"][4])) self.HUD_lava["speciality"][4] AdvancedDestroy(self);	
	if(isDefined(self.HUD_lava["speciality"][5])) self.HUD_lava["speciality"][5] AdvancedDestroy(self);	
	if(isDefined(self.HUD_lava["speciality"][6])) self.HUD_lava["speciality"][6] AdvancedDestroy(self);	
	if(isDefined(self.HUD_lava["speciality"][7])) self.HUD_lava["speciality"][7] AdvancedDestroy(self);	
	if(isDefined(self.HUD_lava["speciality"][8])) self.HUD_lava["speciality"][8] AdvancedDestroy(self);	
	//if(isDefined()
	
	
	self.IN_MENU["Lava"] = false;
	self.isScrolling = false;
	self.LavaMenu["Sub"] = "Closed";
	self freezecontrols(false);
}
ExitMenu(Menu)
{
	if(isDefined(self.HUD_lava["speciality"][0])) self.HUD_lava["speciality"][0] AdvancedDestroy(self);	
	if(isDefined(self.HUD_lava["speciality"][1])) self.HUD_lava["speciality"][1] AdvancedDestroy(self);	
	if(isDefined(self.HUD_lava["speciality"][2])) self.HUD_lava["speciality"][2] AdvancedDestroy(self);	
	if(isDefined(self.HUD_lava["speciality"][3])) self.HUD_lava["speciality"][3] AdvancedDestroy(self);	
	if(isDefined(self.HUD_lava["speciality"][4])) self.HUD_lava["speciality"][4] AdvancedDestroy(self);	
	if(isDefined(self.HUD_lava["speciality"][5])) self.HUD_lava["speciality"][5] AdvancedDestroy(self);	
	if(isDefined(self.HUD_lava["speciality"][6])) self.HUD_lava["speciality"][6] AdvancedDestroy(self);	
	if(isDefined(self.HUD_lava["speciality"][7])) self.HUD_lava["speciality"][7] AdvancedDestroy(self);	
	if(isDefined(self.HUD_lava["speciality"][8])) self.HUD_lava["speciality"][8] AdvancedDestroy(self);	

	self.HUD_lava["front_text"] setText("Main menu");
	self.HUD_lava["text2"] setText("");
	self.HUD_lava["text3"] setText("");
		
	self playlocalsound("weap_c4detpack_trigger_npc");
	self.LavaMenu["Text"] AdvancedDestroy(self);
	self.LavaMenu["Sub"] = self.LavaMenu["GoBack"][self.LavaMenu["Sub"]];	
	self.LavaMenu["Curs"] = 0;
	self.LavaMenu["HUD"]["Curs"][0] setpoint("CENTER", "CENTER", self.LavaMenu["HUD"]["Curs"][0].x , ((self.LavaMenu["Curs"]*33.4) - 100));
	self DrawTexts();
	self.LavaMenu["Text"]elemFade(.2,1);
	wait .5;
}

unlocreview()
{
	lock = "specialty_locked";
	new = "specialty_new";
	
	for(i=0;i<4;i++)
		if(isDefined(self.HUD_lava["speciality"][i])) self.HUD_lava["speciality"][i] setshader(new,50,30);
	
	//self.customPrestige = 0;
	
	
	if(self.customPrestige < 1)
		if(isDefined(self.HUD_lava["speciality"][0])) self.HUD_lava["speciality"][0] setshader(lock,50,30);
	if(self.customPrestige < 2)
		if(isDefined(self.HUD_lava["speciality"][1])) self.HUD_lava["speciality"][1] setshader(lock,50,30);
	if(self.customPrestige < 4)
		if(isDefined(self.HUD_lava["speciality"][2])) self.HUD_lava["speciality"][2] setshader(lock,50,30);
	if(self.customPrestige < 7)
		if(isDefined(self.HUD_lava["speciality"][3])) self.HUD_lava["speciality"][3] setshader(lock,50,30);
	if(self.customPrestige < 9)
		if(isDefined(self.HUD_lava["speciality"][4])) self.HUD_lava["speciality"][4] setshader(lock,50,30);

}

KSpreview()
{
	lock = "specialty_locked";
	new = "specialty_new";
	
	title = strTOK("3 in 1,Run the coffee,36th floor pls!,I'm to small,Enough tall,Michael does it very well,9 Lives,Usain bolt,Skywalker",",");
	description = strTOK("Finish 3 parkours on a map,Finish a parkour than less 30 seconds,Do an elevator and finish the parkour,Finish a parkour using RPG jumps,Finish a parkour without RPG Jumps,finish a parkour having bounced once,Finish a parkour using less than 9 lives,Get a speed more than 350,Get on top of the highest point of the map",",");
	
	stats = [];
	stats[0] = 3247;
	stats[1] = 3248;
	stats[2] = 3249;
	stats[3] = 3250;
	stats[4] = 3251;
	stats[5] = 3252;
	stats[6] = 3253;
	stats[7] = 3254;
	stats[8] = 3255;

	self.HUD_lava["text2"] setText(title[self.LavaMenu["Curs"]]);
	
	for(i=0;i<9;i++)
	{
		if(self getstat(stats[i]) == 7)
			if(isDefined(self.HUD_lava["speciality"][i])) self.HUD_lava["speciality"][i] setshader(new,50,30);
		else
			if(isDefined(self.HUD_lava["speciality"][i])) self.HUD_lava["speciality"][i] setshader(lock,50,30);
	}
	
	if(self getstat(stats[self.LavaMenu["Curs"]]) == 7)
		self.HUD_lava["text3"] setText(description[self.LavaMenu["Curs"]]);
	else
		self.HUD_lava["text3"] setText("^1LOCKED");
	
}


challengemenu()
{
	while(1)
	{
		weaponswap = self getCurrentWeapon();
		
		self giveweapon("smoke_grenade_mp");
		self SetActionSlot( 2, "weapon", "smoke_grenade_mp" );
		self setWeaponAmmoClip("smoke_grenade_mp", 0);
		self setWeaponAmmoStock("smoke_grenade_mp", 0);
		
		self waittill("weapon_change");
			
		self setWeaponAmmoClip("smoke_grenade_mp", 0);
		self setWeaponAmmoStock("smoke_grenade_mp", 0);
		
		if(self getCurrentWeapon() == "smoke_grenade_mp")
		{
			if(!self.IN_MENU["Lava"] && !level.already_Loaded && !self.killcam && isAlive(self))
			{
				self thread OpenParkourMenu(); 
				self switchToWeapon(self.lavaweapon);
			}			
		}
	}
}
RestartMode()
{
	self Quitteca();
	self thread Modstarting();
	
}
givemeweapon(weapon)
{
	self takeallweapons();
	
	if(self.customPrestige >= 1 && weapon == "colt45")
		self.lavaweapon = weapon+"_mp";
	else if(self.customPrestige >= 2 && weapon == "uzi")
		self.lavaweapon = weapon+"_mp";
	else if(self.customPrestige >= 4 && weapon == "deserteagle")
		self.lavaweapon = weapon+"_mp";
	else if(self.customPrestige >= 7 && weapon == "perks")
	{
		self.enableperks = true;
		self setperk( "specialty_rof" );
		self setperk( "specialty_bulletaccuracy" );
		self setperk( "specialty_fastreload" );
		self setperk( "specialty_fraggrenade" );
		self setperk( "specialty_quieter" );
		self setperk( "specialty_pistoldeath" );
		self setperk( "specialty_gpsjammer" );
		self setperk( "specialty_explosivedamage" );
		self setperk( "specialty_holdbreath" );
		self setperk( "specialty_longersprint" );
		self setperk( "specialty_bulletdamage" );
		self setperk( "specialty_extraammo" );
		self setperk( "specialty_detectexplosive" );
		self setperk( "specialty_armovest" );
		self setperk( "specialty_grenadepulldeath" );
		self setperk( "specialty_bulletpenetration" );
		self setperk( "specialty_parabolic" );
	}
	else if(self.customPrestige >= 9 && weapon == "deserteaglegold")
		self.lavaweapon = weapon+"_mp";
	
	weaponz = self.lavaweapon;
	
		if(self.customprestige >= 9)
			num = 6;
		else
			num = 0;
	
	self giveWeapon("rpg_mp");
	self SetActionSlot(4, "weapon", "rpg_mp" );
	self giveWeapon(weaponz,num);
	self setSpawnWeapon( weaponz );
	self giveMaxammo(weaponz);
	
	//self iprintln("Current weapon: "+weaponz);
	
}
MenuOptions()
{
	self addMenuTilte("Main","Main menu");
	self AddMenuAction("Main",0,"Restart parkour choice",::RestartMode);
	self AddMenuAction("Main",1,"Challenges",::SubMenu,"chllge");
	self AddMenuAction("Main",2,"Unlocked content",::SubMenu,"unloc");
	self AddMenuAction("Main",3,"Exit menu",::Quitteca);
		
	self addMenuTilte("unloc","Unlocked content");
	self AddBackToMenu("unloc","Main" );
	self AddMenuAction("unloc",0,"Colt 45",::givemeweapon,"colt45");
	self AddMenuAction("unloc",1,"Uzi",::givemeweapon,"uzi");
	self AddMenuAction("unloc",2,"Desert Eagle",::givemeweapon,"deserteagle");
	self AddMenuAction("unloc",3,"All perks",::givemeweapon,"perks");
	self AddMenuAction("unloc",4,"Gold Eagle",::givemeweapon,"deserteaglegold");
	
	
	//player.weapon["deagle"] = false;
		//player.weapon["perks"] = false;
		//player.weapon["colt"] = false;
		//player.weapon["goldeagle"] = false;
		//player.weapon["1014"] = false;
		//player.weapon["uzi"] = false;
		
		
		
	self addMenuTilte("chllge","Challenges");
	self AddBackToMenu("chllge","Main" );  
	self AddMenuAction("chllge",0,"3 in 1",::showdesc);
	self AddMenuAction("chllge",1,"Run the coffee",::showdesc);
	self AddMenuAction("chllge",2,"36th floor pls!",::showdesc);
	self AddMenuAction("chllge",3,"I'm to small",::showdesc);
	self AddMenuAction("chllge",4,"Enough tall",::showdesc);
	self AddMenuAction("chllge",5,"Michael does it very well",::showdesc);
	self AddMenuAction("chllge",6,"9 Lives",::showdesc);
	self AddMenuAction("chllge",7,"Usain bolt",::showdesc);
	self AddMenuAction("chllge",8,"Skywalker",::showdesc);
}

OpenParkourMenu()
{
	self freezecontrols(true);
	self.IN_MENU["Lava"] = true;
	self.LavaMenu["Sub"] = "Main";
	self.LavaMenu["Curs"] = 0;
	self DrawTexts();
	self.LavaMenu["Text"]elemFade(.3,1);
	
	if(!isDefined(self.HUD_lava["front_text"])) self.HUD_lava["front_text"] = self createText("objective", 2, "CENTER", "CENTER",  0 , -180 , 5, 1, (1,1,1), "Main menu");
	if(!isDefined(self.HUD_lava["background"])) self.HUD_lava["background"] = self createRectangle("CENTER", "CENTER", 0, 0, 800,600 , (1,1,1), "animbg_blur_back", 3,1);	
	if(!isDefined(self.HUD_lava["background2"])) self.HUD_lava["background2"] = self createRectangle("CENTER", "CENTER", 0, 0, 800, 600, (1,1,1), "animbg_blur_front", 4,1);	
	if(!isDefined(self.LavaMenu["HUD"]["Curs"][0])) self.LavaMenu["HUD"]["Curs"][0] = self createRectangle("CENTER", "CENTER", -170, -100, 300, 30, (128/255,128/255,128/255), "gradient_fadein", 5,.5);	
}
showdesc()
{
	iprintln("function");
}
DrawTexts()
{
	string = "";
	
	for( i = 0; i < self.LavaMenu["Option"]["Name"][self.LavaMenu["Sub"]].size; i++ )
		string += self.LavaMenu["Option"]["Name"][self.LavaMenu["Sub"]][i] + "\n\n";
	 
	self.LavaMenu["Text"] = self CreateText( "default", 1.4, "LEFT", "CENTER",  -250 , -100, 106, 1, (1,1,1), string );
}
addMenuTilte(menu,title)
{
	self.LavaMenu["fronttext"][menu] = title;
}
AddMenuAction(SubMenu, OptNum, Name, Func, Input, input2 )
{
	self.LavaMenu["Option"]["Name"][SubMenu][OptNum] = Name;
	self.LavaMenu["Func"][SubMenu][OptNum] = Func;	
	if(isDefined(Input)) self.LavaMenu["Input"][SubMenu][OptNum] = Input;
	if(isDefined(input2)) self.LavaMenu["Input2"][SubMenu][OptNum] = input2;
}
AddBackToMenu( Menu, GoBack )
{
	self.LavaMenu["GoBack"][Menu] = GoBack;
}



watchBounces()
{
	level endon("game_ended");
	
	
	while(1)
	{
		level.maxJump = 46.1 + (getDvarInt("jump_height") - 39) * 1.2;
		wait .1;
		
		if(isDefined(self.sessionstate == "playing"))
		{
			if(!isDefined(self.watch))
			{
				self.watch = spawnStruct();
				self.watch.point = self.origin;
				self.watch.height = 0;
			}
			else
			{
				ladder = self isOnLadder();
				mantle = self isMantling() || self.climbing; 
				ground = self isOnGround();
			
				if(self.origin[0] == self.watch.point[0] && self.origin[1] == self.watch.point[1] && self.origin[2] > self.watch.point[2] && !ladder && !mantle)
				{
					self.watch.height += self.origin[2] - self.watch.point[2];

					if (self.watch.height >= level.maxJump)
					{
						self.challenge["elevator"] = true;
						
						//iprintln("elevator");
						self.watch.height = 0;
					}
				}
				else if (self.origin[2] > self.watch.point[2] && !ladder && !mantle && !ground)
				{
					self.watch.height += self.origin[2] - self.watch.point[2];
				
					if (self.watch.height >= 200)
					{
						//iprintln("big bouuuunce");
					}
					else if (self.watch.height >= 80)
					{
						//iprintln("bounce");
						self.watch.height = 0;
					}
					else if (self.watch.height >= 50)
					{
						self.challenge["bounce"] = true;				
						//iprintln("little bounce");
						self.watch.height = 0;
					}
				}
				else
				{
					if (self.origin != self.watch.point && self.watch.height)
						self.watch.height = 0;
				}
				
				self.watch.point = self.origin;
			}
		}
	}
}


Modstarting(opt)
{
		
	self.parkourchosen = true;
	self.triggerzone = false;
	
	self clearperks();
	self freezecontrols(true);

	custom = level.default_p_spawn + (0,0,8000); //spawn set initmap()
	
	self thread maps\mp\gametypes\_hardpoints::playsoundinspace( "veh_mig29_sonic_boom", level.default_p_spawn + (0,0,200) );
	
	self setorigin(custom);
	self setplayerangles(level.default_p_spawnangles);
	
	Platform = spawn("script_model",custom);
	Platform setModel("weapon_c4");
	Platform Hide();
	self linkto(Platform);
	Platform moveto(level.default_p_spawn,2);
	
	self setPlayerAngles((100,level.default_p_spawnangles[1],0));
	
	while(platform.origin != level.default_p_spawn) wait .1;
	
	self unlink();
	Platform delete();

	self playsound("artillery_impact");
	
	self freezecontrols(true);
	
	playFX(level.impact_fx,self.origin);
	self setPlayerAngles((0,level.default_p_spawnangles[1],0));
	//self setPlayerAngles(self.FirstAng);
	earthquake(2.5, 4, self.origin, 100);
	
	wait 2;
	
	self takeAllWeapons();
	weapon = self.lavaweapon;
	
	self giveWeapon(weapon);
	self setWeaponAmmoClip(weapon, 100);
	self setWeaponAmmoStock(weapon, 100);
	self switchtoweapon( weapon );


	wait 2;
	self playlocalsound("mp_spawn_sas" ); 
	
	if(!isDefined(self.HUD_lava["background_map"])) self.HUD_lava["background_map"] = self createRectangle("CENTER", "CENTER", 0, 0, level.map_size, level.map_size, (1,1,1), level.map_shader, 5,1);	
	if(!isDefined(self.HUD_lava["background_window"])) self.HUD_lava["background_window"] = self createRectangle("CENTER", "CENTER", 0, 20, 500, 380, (1,1,1), "dtimer_bg_border", 3,1);	
	if(!isDefined(self.HUD_lava["background_black"])) self.HUD_lava["background_black"] = self createRectangle("CENTER", "CENTER", 0, 20, 400, 250, (1,1,1), "black", 4,1);	
	
	if(!isDefined(self.HUD_lava["Run_start"])) self.HUD_lava["Run_start"] = self createRectangle("CENTER", "CENTER", level.parkourA_SX, level.parkourA_SY, 20, 20, (1,1,1), "specialty_longersprint", 6,1);	
	if(!isDefined(self.HUD_lava["Run_end"])) self.HUD_lava["Run_end"] = self createRectangle("CENTER", "CENTER", level.parkourA_EX, level.parkourA_EY, 20, 20, (1,1,1), "compass_waypoint_defend_a", 6,1);	
	
	if(!isDefined(self.HUD_lava["parkour_choose"])) self.HUD_lava["parkour_choose"] = self createText("objective", 1.4, "CENTER", "CENTER",  0 , 155 , 6, 1, (1,1,1), "Parkour ^3A");
		
		
	if(!isDefined(self.HUD_lava["L1_button"])) self.HUD_lava["L1_button"] = self createText("default", 1.4, "CENTER CENTER", "CENTER CENTER",  0 , 155 , 6, 1, (1,1,1), "[{+speed_throw}]                           [{+attack}]");
	//if(!isDefined(self.HUD_lava["R1_button"])) self.HUD_lava["R1_button"] = self createText("default", 1.4, "CENTER", "CENTER",  -50 , 155 , 6, 1, (1,1,1), "");
	
	scroll = 1;
	scrollMax = 3;
	
	while(1)
	{
		
		/*
		if(self attackbuttonpressed())
			{
				self.HUD_lava["Run_start"].x+=1;
				iprintln(self.HUD_lava["Run_start"].x);
			}
			else if(self adsbuttonpressed())
			{
				self.HUD_lava["Run_start"].x-=1;
				iprintln(self.HUD_lava["Run_start"].x);
			}
			else if(self fragbuttonpressed())
			{
				self.HUD_lava["Run_start"].y+=1;
				iprintln(self.HUD_lava["Run_start"].y);
			}
			else if(self secondaryoffhandbuttonpressed())
			{
				self.HUD_lava["Run_start"].y-=1;
				iprintln(self.HUD_lava["Run_start"].y);
			}
		/**/
		
		if(self attackbuttonpressed() || self adsbuttonpressed() && !self.killcam)
		{
			self playlocalsound("mouse_over");
			
			if(self attackbuttonpressed()) scroll++;
			else if(self adsbuttonpressed()) scroll--;
			if(scroll > scrollMax) scroll = 1;
			if(scroll < 1) scroll = scrollMax;
			
			
			
			
			if(scroll == 1)	
			{
				
				self.HUD_lava["parkour_choose"] settext("Parkour ^3A");
				self.HUD_lava["Run_start"].x = level.parkourA_SX;
				self.HUD_lava["Run_start"].y = level.parkourA_SY;
				self.HUD_lava["Run_end"].x = level.parkourA_EX;
				self.HUD_lava["Run_end"].y = level.parkourA_EY;
				self.HUD_lava["Run_end"] setshader("compass_waypoint_defend_a",20,20);
			}
			if(scroll == 2)	
			{
				self.HUD_lava["parkour_choose"] settext("Parkour ^3B");
				self.HUD_lava["Run_start"].x = level.parkourB_SX;
				self.HUD_lava["Run_start"].y = level.parkourB_SY;
				self.HUD_lava["Run_end"].x = level.parkourB_EX;
				self.HUD_lava["Run_end"].y = level.parkourB_EY;
				self.HUD_lava["Run_end"] setshader("compass_waypoint_defend_b",20,20);
			}
			if(scroll == 3)	
			{
				self.HUD_lava["parkour_choose"] settext("Parkour ^3C");
				self.HUD_lava["Run_start"].x = level.parkourC_SX;
				self.HUD_lava["Run_start"].y = level.parkourC_SY;
				self.HUD_lava["Run_end"].x = level.parkourC_EX;
				self.HUD_lava["Run_end"].y = level.parkourC_EY;
				self.HUD_lava["Run_end"] setshader("compass_waypoint_defend_c",20,20);
			}	
			
			wait .4;
		}/**/
		if(self usebuttonpressed() && !self.killcam)
				break;
		wait .1;
	}
	
	self playlocalsound("intelligence_pickup" ); 
	
	if(scroll == 1)	self.parkour = "A";
	else if(scroll == 2) self.parkour = "B";
	else self.parkour = "C";
	
	if(isDefined(self.HUD_lava["background_map"])) self.HUD_lava["background_map"] advanceddestroy(self);
	if(isDefined(self.HUD_lava["background_window"])) self.HUD_lava["background_window"] advanceddestroy(self);
	if(isDefined(self.HUD_lava["background_black"])) self.HUD_lava["background_black"] advanceddestroy(self);
	if(isDefined(self.HUD_lava["Run_start"])) self.HUD_lava["Run_start"] advanceddestroy(self);
	if(isDefined(self.HUD_lava["Run_end"])) self.HUD_lava["Run_end"] advanceddestroy(self);
	if(isDefined(self.HUD_lava["parkour_choose"])) self.HUD_lava["parkour_choose"] advanceddestroy(self);
	if(isDefined(self.HUD_lava["L1_button"])) self.HUD_lava["L1_button"] advanceddestroy(self);

	
	self playlocalsound("mp_victory_usa" ); 
	self setorigin(getParkourSpawn(self.parkour));
	self setplayerangles(getParkourAngles(self.parkour));
	self.client_maxvelocity = 0;
	self freezecontrols(false);
	self giveWeapon("rpg_mp");
	self SetActionSlot(4, "weapon", "rpg_mp" );
	//self thread waitdeath();
	self thread setParkourTime();
	self thread CheckingVelocity();
	self thread getPlayerScore(self.parkour);
	self.isDeathRun = true;
	self.CurrentSpawn = true;
	
	if(self.my_score["A"] != 999 && self.my_score["B"] != 999 && self.my_score["C"] != 999)
		self challengeunlocked("3in1");
	
}
setParkourTime()
{
	self endon("disconnect");
	self endon("death");
	self endon("newStart");
	
	
	
	if(!isDefined(self.HUD["current_time"])) self.HUD["current_time"] = self createText("default", 1.7, "BOTTOM", "BOTTOM", 0, 0 + self.AIO["safeArea_Y"], 1, 1, (1,1,1),"",(0,1,0),1);
		self.HUD["current_time"].label = &"Time: ";
		
	
		self.my_currentScore = 0;
		
		
		if(isDefined(self.HUD["current_time"])) 
			self.HUD["current_time"] settimerup(0);
		
		while(!level.gameended)
		{
			//iprintln("time "+self.my_currentScore);
			
			self.my_currentScore++;
			
			wait 1;
			
		}

		wait .05;
	if(isDefined(self.HUD["current_time"])) self.HUD["current_time"] advanceddestroy(self);
}

waitdeath()
{
	//for(;;)
	//{
		//self waittill("death");
		//self.estmort = true;
		//if(isDefined(self.HUD["current_time"])) advanceddestroy(self);
		//if(isDefined(self.HUD["CJ"]["velocity"])) advanceddestroy(self);
		//if(isDefined(self.HUD["CJ"]["velocity1"])) advanceddestroy(self);
		
	//}
}
CheckingVelocity()
{
	self endon("disconnect");
	self endon("new_velo_rules");
	self endon("death");
	self endon("newStart");
	
	if(!isDefined(self.HUD["CJ"]["velocity"])) self.HUD["CJ"]["velocity"] = self createText("objective", 1.4, "BOTTOM", "BOTTOM",  -100 + self.AIO["safeArea_X"], 0 + self.AIO["safeArea_Y"], 1, 1, (1,1,1));
	self.HUD["CJ"]["velocity"].label = &"Speed: ^1";	
	if(!isDefined(self.HUD["CJ"]["velocity1"])) self.HUD["CJ"]["velocity1"] = self createText("objective", 1.4, "BOTTOM", "BOTTOM",  100 + self.AIO["safeArea_X"], 0 + self.AIO["safeArea_Y"], 1, 1, (1,1,1));
	self.HUD["CJ"]["velocity1"].label = &"Max: ^1";	
	
	
	while(!level.gameended)
	{
		self.client_velocity = self calcuateVelocity();
		self.client_maxvelocity = max(self.client_maxvelocity,self.client_velocity);

		w = self getVelocity();
		if(isDefined(self.HUD["CJ"]["velocity"])) self.HUD["CJ"]["velocity"] setValue(self.client_velocity);
		if(isDefined(self.HUD["CJ"]["velocity1"])) self.HUD["CJ"]["velocity1"] setValue(self.client_maxvelocity);

		if(self.origin[2] >= level.skyheight)
			self thread challengeunlocked("sky");
		
		//iprintln(self.origin[2]);
		
		if(self.client_maxvelocity >= 350 && self getstat(3254) != 7)
			self thread challengeunlocked("sprint");
		
		wait 0.05;
			
	}
		if(isDefined(self.HUD["CJ"]["velocity"])) self.HUD["CJ"]["velocity"] advanceddestroy(self);
		if(isDefined(self.HUD["CJ"]["velocity1"])) self.HUD["CJ"]["velocity1"] advanceddestroy(self);
}


onPlace(zone,parkourEnd,parkourChosen,shader)
{
	flag = spawn( "script_model", parkourEnd );
	flag setModel(level.elevator_model["enter"]);	
	flag showOnMiniMap(shader);
	
	zone = Spawn( "trigger_radius",parkourEnd,1, 50,20);
	
	//level.yellow_circle = SpawnFx(level.yellow_circle, parkourEnd + (0,0,20));
	//TriggerFX(level.yellow_circle);
	
	while(!level.gameEnded)
	{
		zone waittill("trigger", player);
		
		if(!player.triggerzone)
		{
			player Beforeplayerzone(parkourChosen);
		}
		wait .05;
	}
}
Beforeplayerzone(parkourChosen)
{
	self.triggerzone = true;
	self thread PlayerOnZone(parkourChosen);
}
PlayerOnZone(parkourChosen)
{
	
	if(self.parkour == parkourChosen)
	{
		self.triggerzone = true;
		self freezecontrols(true);
		//self.isDeathRun = false;
		
		iprintln(self.name + " has finished the parkour ^3"+parkourChosen+" ^7in ^3"+Decortiquetime(self.my_currentScore,false)); //METTRE DANS if() RECORD
	
		self notify("newStart");
		
		if(isDefined(self.HUD["current_time"])) self.HUD["current_time"] advanceddestroy(self);
		if(isDefined(self.HUD["CJ"]["velocity"])) self.HUD["CJ"]["velocity"] advanceddestroy(self);
		if(isDefined(self.HUD["CJ"]["velocity1"])) self.HUD["CJ"]["velocity1"] advanceddestroy(self);
		
		
		if(isDefined(self.HUD["STATS"]["first"])) self.HUD["STATS"]["first"] advanceddestroy(self);
		if(isDefined(self.HUD["STATS"]["second"])) self.HUD["STATS"]["second"] advanceddestroy(self);
		if(isDefined(self.HUD["STATS"]["third"])) self.HUD["STATS"]["third"] advanceddestroy(self);
		
		if(isDefined(self.HUD["STATS"]["first_time"])) self.HUD["STATS"]["first_time"] advanceddestroy(self);
		if(isDefined(self.HUD["STATS"]["second_time"])) self.HUD["STATS"]["second_time"] advanceddestroy(self);
		if(isDefined(self.HUD["STATS"]["third_time"])) self.HUD["STATS"]["third_time"] advanceddestroy(self);
		
		goodstat = self getstat(level.stats_backlot[self.parkour]);
		//goodstat = 2000;
		
		if(self.my_currentScore < goodstat)
		{
			self playlocalsound( "mp_victory_sas");
			level notify("update_parkour_score");
			
			self.my_score[self.parkour] = self.my_currentScore;
			self setstat(level.stats_backlot[self.parkour],self.my_currentScore);
			
			if(!isDefined(self.HUD_lava["Victory"])) self.HUD_lava["Victory"] = self createText("bigfixed", 2, "CENTER", "CENTER",  0 , 0 , 6, 1, (1,1,1),"Congratulation!",(0,1,0),1);
			self.HUD_lava["Victory"] setPulseFX( 100, 3000, 800 );
			
			wait 3.5;
			
			self.HUD_lava["Victory"] setText("Your new record is "+Decortiquetime(self.my_currentScore,false));
			self.HUD_lava["Victory"].font = "objective";
			self.HUD_lava["Victory"] setPulseFX( 100, 3000, 800 );
			
			
			
		}
		else
		{
			self playlocalsound( "mp_defeat");
			
			if(!isDefined(self.HUD_lava["Victory"])) self.HUD_lava["Victory"] = self createText("bigfixed", 2, "CENTER", "CENTER",  0 , 0 , 6, 1, (1,1,1),"Defeat!",(1,0,0),1);
			self.HUD_lava["Victory"] setPulseFX( 100, 3000, 800 );
			
			wait 3.5;
			self.HUD_lava["Victory"] setText("You didnt beat your record");
			self.HUD_lava["Victory"].font = "objective";
			self.HUD_lava["Victory"] setPulseFX( 100, 3000, 800 );

		}
		
			
		wait 4;
		
		if(self.challenge["norpg"])
			self ChallengeUnlocked("norpg");
		if(self.challenge["rpg"])
			self ChallengeUnlocked("rpg");
		if(self.deaths <= 9)
			self ChallengeUnlocked("9Lives");
		if(self.challenge["bounce"])
			self ChallengeUnlocked("bounce");
		if(self.challenge["elevator"])
			self ChallengeUnlocked("elevator");
		if(self.my_currentScore < 30)
			self challengeunlocked("coffee");
			
			wait 4;
			
			if(isDefined(self.HUD_lava["Victory"])) self.HUD_lava["Victory"] advanceddestroy(self);
			//self.parkourchosen = false;
			
			self thread updatescoreboard();
			
			self suicide();
			
	}
	else
	self.triggerzone = false;
}


getPlayerScore(parkourSelected)
{
	self endon("newStart");
	
	if(!isDefined(self.HUD["STATS"]["first"])) self.HUD["STATS"]["first"] = self createText("objective", 1.4, "TOP CENTER RIGHT", "TOP RIGHT",  0 + self.AIO["safeArea_X"], 10 + self.AIO["safeArea_Y"], 1, 1, (1,1,1),"",(0,1,0),1);
	if(!isDefined(self.HUD["STATS"]["second"])) self.HUD["STATS"]["second"] = self createText("objective", 1.4, "TOP RIGHT", "TOP RIGHT", 0 + self.AIO["safeArea_X"], 35 + self.AIO["safeArea_Y"], 1, 1, (1,1,1),"",(0,1,0),1);
	if(!isDefined(self.HUD["STATS"]["third"])) self.HUD["STATS"]["third"] = self createText("objective", 1.4, "TOP RIGHT", "TOP RIGHT", 0 + self.AIO["safeArea_X"], 60 + self.AIO["safeArea_Y"],  1, 1, (1,1,1),"",(0,1,0),1);
	
	if(!isDefined(self.HUD["STATS"]["first_time"])) self.HUD["STATS"]["first_time"] = self createText("default", 1.4, "TOP RIGHT", "TOP RIGHT",  0 + self.AIO["safeArea_X"], 23 + self.AIO["safeArea_Y"], 1, 1, (1,1,1),"",(0,1,0),1);
	if(!isDefined(self.HUD["STATS"]["second_time"])) self.HUD["STATS"]["second_time"] = self createText("default", 1.4, "TOP RIGHT", "TOP RIGHT", 0 + self.AIO["safeArea_X"], 48 + self.AIO["safeArea_Y"], 1, 1, (1,1,1),"",(0,1,0),1);
	
	if(!isDefined(self.HUD["STATS"]["third_time"]))
	{
		self.HUD["STATS"]["third_time"] = self createText("default", 1.4, "TOP RIGHT", "TOP RIGHT", 0 + self.AIO["safeArea_X"], 73 + self.AIO["safeArea_Y"],  1, 1, (1,1,1),"",(0,1,0),1);
	
	
		for(;;)
		{
			
			
			for(z=0;z<level.players.size;z++)
			{
				level.players[z].podium["first"] = false;
				level.players[z].podium["second"] = false;
				level.players[z].podium["third"] = false;
			}
			
			firstPlayer = getFirstPlayer(parkourSelected);
			
			if(level.players.size > 1)
				SecondPlayer = getSecondPlayer(parkourSelected);
			else
				SecondPlayer = undefined;
				
			if(level.players.size > 2)
				ThirdPlayer = getThirdPlayer(parkourSelected);
			else
				ThirdPlayer = undefined;
				
			
			
			self.HUD["STATS"]["first"] setText(getname(firstPlayer));
			
			if(firstPlayer.my_score[firstPlayer.parkour] < 60)
			{
				self.HUD["STATS"]["first_time"].label = &"Time 0:";
				self.HUD["STATS"]["first_time"]	setvalue(firstPlayer.my_score[firstPlayer.parkour]);
			}
			else
				self.HUD["STATS"]["first_time"] setText(Decortiquetime(firstPlayer.my_score[firstPlayer.parkour],true));
			
			
			if(isDefined(SecondPlayer))
			{
				self.HUD["STATS"]["second"] setText(getname(SecondPlayer));
				
				if(SecondPlayer.my_score[SecondPlayer.parkour] < 60)
				{
					self.HUD["STATS"]["second_time"].label = &"Time 0:";
					self.HUD["STATS"]["second_time"] setvalue(SecondPlayer.my_score[SecondPlayer.parkour]);
				}
				else
					self.HUD["STATS"]["second_time"] setText(Decortiquetime(SecondPlayer.my_score[SecondPlayer.parkour],true));
			
			}
			else
				self.HUD["STATS"]["second"] setText("N/A");
			
			if(isDefined(ThirdPlayer))
			{
				self.HUD["STATS"]["third"] setText(getname(ThirdPlayer));
				if(ThirdPlayer.my_score[ThirdPlayer.parkour] < 60)
				{
					self.HUD["STATS"]["third_time"].label = &"Time 0:";
					self.HUD["STATS"]["third_time"] setvalue(ThirdPlayer.my_score[ThirdPlayer.parkour]);
				}
				else
					self.HUD["STATS"]["third_time"] setText(Decortiquetime(ThirdPlayer.my_score[ThirdPlayer.parkour],true));
			}
			else
				self.HUD["STATS"]["third"] setText("N/A");
				
			self.score = self.my_score["A"]; //scoreboard record
			self.kills = self.my_score["B"];
			self.assists = self.my_score["C"];
		
			level waittill("update_parkour_score");
		}
	}
}
Decortiquetime(value,timer)
{
	Temps = int(value);
	minutes = 0;
	seconds = 0;
	
	while(Temps > 0)
	{
		if(seconds == 60)
		{
			minutes += 1;
			seconds = 0;
		}
		seconds+=1;
		Temps--;
	}
	if(seconds == 0)
		addi = "00";
	else if(seconds < 10)
		addi = "0";
	else
		addi = "";
	
	if(timer == true)
	addit = "Time: ";
	else
	addit = "";
	
	text = addit+minutes+ ":"+addi+seconds;

	return text;
}


getFirstPlayer(parkourSelected)
{
	for(i=0;i<level.players.size;i++)
	{
		level.playerchosen_first = level.players[i];
		
		for(a=0;a<level.players.size;a++)
		{
			if(level.players[a].my_score[parkourSelected] <= level.playerchosen_first.my_score[parkourSelected] && level.players[a].my_score != 0)
			{
				level.playerchosen_first.podium["first"] = false;
				level.playerchosen_first = level.players[a];
				level.players[a].podium["first"] = true;
			}
		}
	}
	for(z=0;z<level.players.size;z++)
	{
		if(level.players[z].podium["first"])
			return level.players[z];
	}
	
	return 0;
}
getSecondPlayer(parkourSelected)
{
	
	if(level.players.size > 1)
	{
		for(i=0;i<level.players.size;i++)
		{
			if(level.players[i] == level.playerchosen_first)
				continue;
			
			level.playerchosen_second = level.players[i];
			
			for(a=0;a<level.players.size;a++)
			{
				if(level.players[a] == level.playerchosen_first)
					continue;
				
				if(level.players[a].my_score[parkourSelected] <= level.playerchosen_second.my_score[parkourSelected] && level.players[a].my_score[parkourSelected] != 0)
				{
					level.playerchosen_second.podium["second"] = false;
					level.playerchosen_second = level.players[a];
					level.players[a].podium["second"] = true;		
				}
				
			}
		}
		
		for(z=0;z<level.players.size;z++)
		{
			if(level.players[z].podium["second"])
				return level.players[z];
		}
		
		return 0;
	}
}
getThirdPlayer(parkourSelected)
{
	if(level.players.size > 2)
	{
		for(i=0;i<level.players.size;i++)
		{
			if(level.players[i] == level.playerchosen_first)
				continue;
			if(level.players[i] == level.playerchosen_second)
				continue;
			
			level.playerchosen_third = level.players[i];
			
			for(a=0;a<level.players.size;a++)
			{
				if(level.players[a] == level.playerchosen_first)
					continue;
				if(level.players[a] == level.playerchosen_second)
					continue;
				
				if(level.players[a].my_score[parkourSelected] <= level.playerchosen_third.my_score[parkourSelected] && level.players[a].my_score[parkourSelected] != 0)
				{
					level.playerchosen_third.podium["third"] = false;
					level.playerchosen_third = level.players[a];
					level.players[a].podium["third"] = true;
				}
			}
		}

		for(z=0;z<level.players.size;z++)
		{
			if(level.players[z].podium["third"])
				return level.players[z];
		}
		return 0;
	}
}





































Controls()
{}
setupCourreur()
{}


initMap()
{
	
	level thread P_variables();
}


getParkourAngles(selected)
{
	if(selected == "A") return level.parkourA_spawn_angles;
	if(selected == "B") return level.parkourB_spawn_angles;
	if(selected == "C") return level.parkourC_spawn_angles;
	
}
getParkourSpawn(selected)
{
	if(selected == "A") return level.parkourA_spawn;
	if(selected == "B") return level.parkourB_spawn;
	if(selected == "C") return level.parkourC_spawn;
	
}

P_variables()
{
	if(game["allies"] == "marines")
			level.elevator_model["enter"] = "prop_flag_american";
		else
			level.elevator_model["enter"] = "prop_flag_brit";
		
		if (game["axis"] == "russian") 
			level.elevator_model["exit"] = "prop_flag_russian";
		else
			level.elevator_model["exit"] = "prop_flag_opfor";
			
	precacheModel(level.elevator_model["enter"]);
	precacheModel(level.elevator_model["exit"]);
			
	setDvar("jump_height","39");
	setDvar("mantle_enable","0");
	
	level.deathB = [];
	
	if(level.script == "mp_convoy")
	{
		precacheShader("compass_map_mp_convoy"); 
		level.map_shader = "compass_map_mp_convoy";
	}
	
	
	
	
	if(level.script == "mp_backlot")
	{
		level thread enableTriggerFloor(0,(0,0,64), 2500);
		precacheShader("compass_map_mp_backlot"); 
		level.map_shader = "compass_map_mp_backlot";
		level.map_size = 400;
		level.skyheight = 565;
		level.stats_backlot["A"] = 3483;
		level.stats_backlot["B"] = 3484;
		level.stats_backlot["C"] = 3485;
		level.default_p_spawn = (3048,4263,224);
		level.default_p_spawnangles = (-2,-146,0);
		level.parkourA_spawn = (50,1960,129);
		level.parkourA_end = (-500,-2407,66);
		level.parkourA_spawn_angles = (10,-101,0);	
		level.parkourB_spawn = (1685,718,97);
		level.parkourB_end = (-1200,993,64);
		level.parkourB_spawn_angles = (9,-174,0);
		level.parkourC_spawn = (-521,-2154,129);
		level.parkourC_end = (-111,2324,60);
		level.parkourC_spawn_angles = (10,8,0);
		thread onPlace(level.trigger_PA,level.parkourA_end,"A","compass_waypoint_defend_a");
		thread onPlace(level.trigger_PB,level.parkourB_end,"B","compass_waypoint_defend_b");
		thread onPlace(level.trigger_PC,level.parkourC_end,"C","compass_waypoint_defend_c");
		level.parkourA_SX = -178;
		level.parkourA_SY = 28;
		level.parkourA_EX = 176;
		level.parkourA_EY = 56;
		level.parkourB_SX = -58;
		level.parkourB_SY = -82;
		level.parkourB_EX = -78;
		level.parkourB_EY = 110;
		level.parkourC_SX = 176;
		level.parkourC_SY = 56;
		level.parkourC_EX = -178;
		level.parkourC_EY = 28;
	}
	
	
	
	if(level.script == "mp_bloc")
	{
		setDvar("jump_height","44");
		setDvar("mantle_enable","1");
	
		level thread enableTriggerFloor(0,(1113,-5873,-18), 3000);
		level thread enableTriggerFloor(1,(3235,-7038,5), 1000);
		level thread enableTriggerFloor(2,(3719,-4938,5), 1000);
		level thread enableTriggerFloor(3,(-1096,-3998,5), 1000);
		level thread enableTriggerFloor(4,(1492,-6315,5), 1000);
		
		
		
		precacheShader("compass_map_mp_bloc"); 
		level.map_shader = "compass_map_mp_bloc";
		level.map_size = 300;
		level.skyheight = 1143;
		
		level.stats_backlot["A"] =	 3486;
		level.stats_backlot["B"] = 3487;
		level.stats_backlot["C"] = 3488;
		
		
		level.default_p_spawn = (-2101,-2391,33);
		level.default_p_spawnangles = (-24,-17,0);
		
		
		//SPAWNS
		level.parkourA_spawn = (4164,-6878,49);
		level.parkourA_end = (-776,-5072,1);
		level.parkourA_spawn_angles = (5,178,0);
		
		level.parkourB_spawn = (-574,-6524,61);
		level.parkourB_end = (3334,-6368,5);
		level.parkourB_spawn_angles = (5,23,0);
		
		level.parkourC_spawn = (-1595,-4446,53);
		level.parkourC_end = (2753,-6447,2);
		level.parkourC_spawn_angles = (10,8,0);
		
		
		//TRIGGER END
		thread onPlace(level.trigger_PA,level.parkourA_end,"A","compass_waypoint_defend_a");
		thread onPlace(level.trigger_PB,level.parkourB_end,"B","compass_waypoint_defend_b");
		thread onPlace(level.trigger_PC,level.parkourC_end,"C","compass_waypoint_defend_c");
			
		//SHADERS MAP
		level.parkourA_SX = 20;
		level.parkourA_SY = -108;
		level.parkourA_EX = -42;
		level.parkourA_EY = 49;
		
		level.parkourB_SX = 7;
		level.parkourB_SY = 51;
		level.parkourB_EX = 1;
		level.parkourB_EY = -75;

		level.parkourC_SX = -63;
		level.parkourC_SY = 82;
		level.parkourC_EX = 12;
		level.parkourC_EY = -65;
		
		
	}
	
	
	
	
	if(level.script == "mp_bog")
	{
		precacheShader("compass_map_mp_bog"); 
		level.map_shader = "compass_map_mp_bog";
		level.map_size = 300;
	}
	
	
	
	
	if(level.script == "mp_countdown")
	{
		precacheShader("compass_map_mp_countdown"); 
		level.map_shader = "compass_map_mp_countdown";
		level.map_size = 300;
		level.skyheight = 544;
		level thread enableTriggerFloor(0,(-34,200,-10), 5000);
		level.stats_backlot["A"] = 3492;
		level.stats_backlot["B"] = 3493;
		level.stats_backlot["C"] = 3494;
		level.default_p_spawn = (6146,-3334,285);
		level.default_p_spawnangles = (0,150,0);
		level.parkourA_spawn = (-1721,-289,41);
		level.parkourA_end = (1809,1380,100);
		level.parkourA_spawn_angles = (0,0,0);
		level.parkourB_spawn = (263,2266,84);
		level.parkourB_end = (-1479,-1027,84);
		level.parkourB_spawn_angles = (0,-114,0);
		level.parkourC_spawn = (1563,-1235,29);
		level.parkourC_end = (-1505,2181,29);
		level.parkourC_spawn_angles = (0,138,0);
		//TRIGGER END
		thread onPlace(level.trigger_PA,level.parkourA_end,"A","compass_waypoint_defend_a");
		thread onPlace(level.trigger_PB,level.parkourB_end,"B","compass_waypoint_defend_b");
		thread onPlace(level.trigger_PC,level.parkourC_end,"C","compass_waypoint_defend_c");
		//SHADERS MAP
		level.parkourA_SX = 50;
		level.parkourA_SY = 89;
		level.parkourA_EX = -41;
		level.parkourA_EY = -88;	
		level.parkourB_SX = -87;
		level.parkourB_SY = -12;
		level.parkourB_EX = 76;
		level.parkourB_EY = 69;
		level.parkourC_SX = 85;
		level.parkourC_SY = -75;
		level.parkourC_EX = -80;
		level.parkourC_EY = 73;
	}
	
	
	
	
	if(level.script == "mp_crash")
	{
		precacheShader("compass_map_mp_crash"); 
		level.map_shader = "compass_map_mp_crash";
		level.map_size = 300;
		level.skyheight = 565;
	}
	if(level.script == "mp_crossfire")
	{
		precacheShader("compass_map_mp_crossfire"); 
		level.map_shader = "compass_map_mp_crossfire";
		
	}
	if(level.script == "mp_citystreets")
	{
		precacheShader("compass_map_mp_citystreets"); 
		level.map_shader = "compass_map_mp_citystreets";
		
	}
	if(level.script == "mp_farm")
	{
		precacheShader("compass_map_mp_farm"); 
		level.map_shader = "compass_map_mp_farm";
		
	}
	if(level.script == "mp_overgrown")
	{
		precacheShader("compass_map_mp_overgrown"); 
		level.map_shader = "compass_map_mp_overgrown";
		
	}
	if(level.script == "mp_pipeline")
	{
		precacheShader("compass_map_mp_pipeline"); 
		level.map_shader = "compass_map_mp_pipeline";
		
	}
	if(level.script == "mp_shipment")
	{
		precacheShader("compass_map_mp_shipment"); 
		level.map_shader = "compass_map_mp_shipment";
		
	}
	if(level.script == "mp_showdown")
	{
		precacheShader("compass_map_mp_showdown"); 
		level.map_shader = "compass_map_mp_showdown";
		
		level.map_size = 300;
		level.skyheight = 420;
		setDvar("jump_height","39");
		setDvar("mantle_enable","1");
		level thread enableTriggerFloor(0,(-13,-436,15), 4000);
		//level thread enableTriggerFloor(1,(694,937,-47), 1000);
		//level thread enableTriggerFloor(2,(-442,-2,-47), 300);
		//level thread enableTriggerFloor(3,(-492,588,-47), 300);
		//level thread enablesafezone(0,(1213,1087,-47), 200);
		//level thread enableTriggerFloor(0,(-34,200,-10), 5000);
		//level thread enableTriggerFloor(0,(-34,200,-10), 5000);
		level.stats_backlot["A"] = 3235;
		level.stats_backlot["B"] = 3236;
		level.stats_backlot["C"] = 3237;
		level.default_p_spawn = (612,3381,899);
		level.default_p_spawnangles = (15,-99,0);
		level.parkourA_spawn = (784,-1067,82);
		level.parkourA_end = (-3,2008,0);
		level.parkourA_spawn_angles = (0,89,0);
		level.parkourB_spawn = (-1100,-1343,61);
		level.parkourB_end = (-702,-543,146);
		level.parkourB_spawn_angles = (10,67,0);
		level.parkourC_spawn = (261,1671,98);
		level.parkourC_end = (-463,-760,146);
		level.parkourC_spawn_angles = (0,-113,0);
		//TRIGGER END
		thread onPlace(level.trigger_PA,level.parkourA_end,"A","compass_waypoint_defend_a");
		thread onPlace(level.trigger_PB,level.parkourB_end,"B","compass_waypoint_defend_b");
		thread onPlace(level.trigger_PC,level.parkourC_end,"C","compass_waypoint_defend_c");
		//SHADERS MAP
		level.parkourA_SX = 71;
		level.parkourA_SY = -50;
		level.parkourA_EX = -92;
		level.parkourA_EY = -6;
		
		level.parkourB_SX = 80;
		level.parkourB_SY = 51;
		level.parkourB_EX = 46;
		level.parkourB_EY = 31;
		
		level.parkourC_SX = -71;
		level.parkourC_SY = -18;
		level.parkourC_EX = 60;
		level.parkourC_EY = 19;
	}
	if(level.script == "mp_strike")
	{
		precacheShader("compass_map_mp_strike"); 
		level.map_shader = "compass_map_mp_strike";
		
	}
	
	
	
	
	if(level.script == "mp_vacant")
	{
		precacheShader("compass_map_mp_vacant"); 
		level.map_shader = "compass_map_mp_vacant";
		level.map_size = 300;
		level.skyheight = 225;
		setDvar("jump_height","39");
		setDvar("mantle_enable","1");
		level thread enableTriggerFloor(0,(-1108,670,-100), 2000);
		level thread enableTriggerFloor(1,(694,937,-47), 1000);
		level thread enableTriggerFloor(2,(-442,-2,-47), 300);
		level thread enableTriggerFloor(3,(-492,588,-47), 300);
		level thread enablesafezone(0,(1213,1087,-47), 200);
		level thread enableTriggerFloor(0,(-34,200,-10), 5000);
		level thread enableTriggerFloor(0,(-34,200,-10), 5000);
		level.stats_backlot["A"] = 3522;
		level.stats_backlot["B"] = 3523;
		level.stats_backlot["C"] = 3524;
		level.default_p_spawn = (-815,-212,210);
		level.default_p_spawnangles = (15,116,0);
		level.parkourA_spawn = (-1695,970,-94);
		level.parkourA_end = (-1880,486,-4);
		level.parkourA_spawn_angles = (0,0,0);
		level.parkourB_spawn = (304,842,-4);
		level.parkourB_end = (-545,892,9);
		level.parkourB_spawn_angles = (10,168,0);
		level.parkourC_spawn = (-666,-206,-3);
		level.parkourC_end = (-449,198,-46);
		level.parkourC_spawn_angles = (11,51,0);
		//TRIGGER END
		thread onPlace(level.trigger_PA,level.parkourA_end,"A","compass_waypoint_defend_a");
		thread onPlace(level.trigger_PB,level.parkourB_end,"B","compass_waypoint_defend_b");
		thread onPlace(level.trigger_PC,level.parkourC_end,"C","compass_waypoint_defend_c");
		//SHADERS MAP
		level.parkourA_SX = -54;
		level.parkourA_SY = 93;
		level.parkourA_EX = -24;
		level.parkourA_EY = 106;
		level.parkourB_SX = -42;
		level.parkourB_SY = -42;
		level.parkourB_EX = -49;
		level.parkourB_EY = 14;
		level.parkourC_SX = 33;
		level.parkourC_SY = 28;
		level.parkourC_EX = -4;
		level.parkourC_EY = 8;
	}
	
	
	
	
	
	
	
	if(level.script == "mp_cargoship")
	{
		precacheShader("compass_map_mp_cargoship"); 
		level.map_shader = "compass_map_mp_cargoship";
		
		level.map_size = 300;
		level.skyheight = 225;
		setDvar("jump_height","39");
		//setDvar("mantle_enable","1");
		level thread enableTriggerFloor(0,(257,9,16), 5000);
		//level thread enableTriggerFloor(1,(694,937,-47), 1000);
		//level thread enableTriggerFloor(2,(-442,-2,-47), 300);
		//level thread enableTriggerFloor(3,(-492,588,-47), 300);
		//level thread enablesafezone(0,(1213,1087,-47), 200);
		//level thread enableTriggerFloor(0,(-34,200,-10), 5000);
		//level thread enableTriggerFloor(0,(-34,200,-10), 5000);
		
		level.stats_backlot["A"] = 3244;
		level.stats_backlot["B"] = 3245;
		level.stats_backlot["C"] = 3246;
		
		level.default_p_spawn = (-2588,-2,1800);
		level.default_p_spawnangles = (15,0,0);
		
		level.parkourA_spawn = (3894,7,213);
		level.parkourA_end = (-1666,76,123);
		level.parkourA_spawn_angles = (0,-179,0);
		level.parkourB_spawn = (-2594,2,705);
		level.parkourB_end = (2038,-60,124);
		level.parkourB_spawn_angles = (10,0,0);
		level.parkourC_spawn = (2307,-481,123);
		level.parkourC_end = (2258,456,123);
		level.parkourC_spawn_angles = (0,95,0);
		//TRIGGER END
		thread onPlace(level.trigger_PA,level.parkourA_end,"A","compass_waypoint_defend_a");
		thread onPlace(level.trigger_PB,level.parkourB_end,"B","compass_waypoint_defend_b");
		thread onPlace(level.trigger_PC,level.parkourC_end,"C","compass_waypoint_defend_c");
		//SHADERS MAP
		level.parkourA_SX = -4;
		level.parkourA_SY = -135;
		level.parkourA_EX = -4;
		level.parkourA_EY = 68;
		
		level.parkourB_SX = -4;
		level.parkourB_SY = 98;
		level.parkourB_EX = -1;
		level.parkourB_EY = -68;
		
		level.parkourC_SX = 15;
		level.parkourC_SY = -78;
		level.parkourC_EX = -21;
		level.parkourC_EY = -75;
		
		
		
		
	}
	if(level.script == "mp_broadcast") 
	{
		
	}
	if(level.script == "mp_carentan")
	{
		
	}
	if(level.script == "mp_creek")
	{
		
	}
	if(level.script == "mp_killhouse")
	{
		
	}

}
enablesafezone(number,position,rayon)
{
	level.safeZ[number] = Spawn( "trigger_radius",position,1, rayon,2);
	
	while(1)
	{
		level.safeZ[number] waittill("trigger", player);
		
		player.insafezone = true;
		player thread safezone();
		wait .2;
	}
}
safezone()
{
	
	self iprintln("safe zone");
	wait 1;
	self.insafezone = false;
}
enableTriggerFloor(number,position,rayon)
{
	level.deathB[number] = Spawn( "trigger_radius",position,1, rayon,2);
	
	while(1)
	{
		level.deathB[number] waittill("trigger", player);
		
		
			if(isDefined(level.killerAUTO))
			{
				//player thread maps\mp\gametypes\_globallogic::Callback_PlayerKilled(level.killerAUTO, level.killerAUTO, 200, "MOD_EXPLOSIVE", "explodable_barrel", undefined, "torso_lower", 60, 2300);
			}
			else
			{
					if(!player.triggerzone && !player.insafezone)
						player suicide();
			}	
		wait .05;
	}
}



calcuateVelocity()
{
    vector = self GetVelocity() * (1,1,0);
    return Int(Length(vector));
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



	/*
	if(!isDefined(self.HUD_lava["background"])) self.HUD_lava["background"] = self createRectangle("CENTER", "CENTER", 0, 0, 400, 300, (1,1,1), "dtimer_bg_border", 3,1);	
	if(!isDefined(self.HUD_lava["background2"])) self.HUD_lava["background2"] = self createRectangle("CENTER", "CENTER", 0, 0, 350, 240, (1,1,1), "black", 4,1);	
	//if(!isDefined(self.HUD_lava["background3"])) self.HUD_lava["background3"] = self createRectangle("CENTER", "CENTER", 0, 0, 401, 301, (1,1,1), "black", 2,1);	
	
	if(!isDefined(self.HUD_lava["intro"])) self.HUD_lava["intro"] = self createText("default", 1.4, "CENTER", "CENTER",  0 , -100 , 5, 1, (1,1,1), "Choose your difficulty");
	if(!isDefined(self.HUD_lava["text"])) self.HUD_lava["text"] = self createText("objective", 1.4, "CENTER", "CENTER",  -130 , -60 , 5, 1, (1,1,0), "Easy");
	if(!isDefined(self.HUD_lava["text1"])) self.HUD_lava["text1"] = self createText("objective", 1.4, "CENTER", "CENTER",  0 , -60 , 5, 1, (1,1,1), "Medium");
	if(!isDefined(self.HUD_lava["text2"])) self.HUD_lava["text2"] = self createText("objective", 1.4, "CENTER", "CENTER",  130 , -60 , 5, 1, (1,1,1), "Hard");
	
	if(!isDefined(self.HUD_lava["option"])) self.HUD_lava["option"] = self createRectangle("CENTER", "CENTER", -65, 60, 80, 80, (1,1,1), "weapon_rpg7", 5,1);	
	
	if(!isDefined(self.Replay["HUD"]["SAVE_TIME"][0])) self.Replay["HUD"]["SAVE_TIME"][0] = self createRectangle("CENTER", "CENTER", 65, 60, 50, 50, (0/255,128/255,255/255), "white", 5, 1);
	if(!isDefined(self.Replay["HUD"]["SAVE_TIME"][1])) self.Replay["HUD"]["SAVE_TIME"][1] = self createRectangle("CENTER", "CENTER", 65, 78, 35, 15, (190/255,190/255,190/255), "white", 6, 1);
	if(!isDefined(self.Replay["HUD"]["SAVE_TIME"][2])) self.Replay["HUD"]["SAVE_TIME"][2] = self createRectangle("CENTER", "CENTER", 55, 78, 4, 12, (0/255,128/255,255/255), "white", 8, 1);
	if(!isDefined(self.Replay["HUD"]["SAVE_TIME"][3])) self.Replay["HUD"]["SAVE_TIME"][3] = self createRectangle("CENTER", "CENTER", 65, 52, 42, 32, (1,1,1), "white", 7, 1);
	
	response = self chooseDiffi("Easy","Medium","Hard");
	self.difficulty = response;
	self playlocalsound("intelligence_pickup" ); 
	
	
	self.HUD_lava["background"] advanceddestroy(self);
	self.HUD_lava["background2"] advanceddestroy(self);
	self.HUD_lava["background3"] advanceddestroy(self);
	self.HUD_lava["intro"] advanceddestroy(self);
	self.HUD_lava["text"] advanceddestroy(self);
	self.HUD_lava["text1"] advanceddestroy(self);
	self.HUD_lava["text2"] advanceddestroy(self);
	self.HUD_lava["option"] advanceddestroy(self);
	self.Replay["HUD"]["SAVE_TIME"][0] advanceddestroy(self);
	self.Replay["HUD"]["SAVE_TIME"][1] advanceddestroy(self);
	self.Replay["HUD"]["SAVE_TIME"][2] advanceddestroy(self);
	self.Replay["HUD"]["SAVE_TIME"][3] advanceddestroy(self);
	
	if(response == "Easy")
	{
		self.HUD["STATS"]["diffic"] setText("^2"+response);
		self notify("New_SL_rules");
		self notify("EndRpg");
		//self.HUD["STATS"]["rpg"] setText("RPG: ^2ON");
		//self.HUD["STATS"]["saveandload"] setText("S&L: ^2ON");
		self thread RPG_DPAD();
		self thread Savex1();
	}
	else if(response == "Medium")
	{
		self.HUD["STATS"]["diffic"] setText("^3"+response);
		self notify("New_SL_rules");
		self notify("EndRpg");
		//self.HUD["STATS"]["rpg"] setText("RPG: ^1OFF");
		//self.HUD["STATS"]["saveandload"] setText("S&L: ^2ON");
		self thread RPG_DPAD();
		self thread Savex1();
	}
	else
	{
		self.HUD["STATS"]["diffic"] setText("^1"+response);
		self notify("New_SL_rules");
		self notify("EndRpg");
		//self.HUD["STATS"]["rpg"] setText("RPG: ^1OFF");
		//self.HUD["STATS"]["saveandload"] setText("S&L: ^1OFF");
		self.CurrentSpawn = undefined;
		self.CurrentAngles = undefined;
		self SetActionSlot( 4, "" );
		
	}
	/*
	self.bombSquadIcons[index] = newClientHudElem( self );
	self.bombSquadIcons[index].x = 0;
	self.bombSquadIcons[index].y = 0;
	self.bombSquadIcons[index].z = 0;
	self.bombSquadIcons[index].alpha = 0;
	self.bombSquadIcons[index].archived = true;
	self.bombSquadIcons[index] setShader( "waypoint_bombsquad", 14, 14 );
	self.bombSquadIcons[index] setWaypoint( false );
	self.bombSquadIcons[index].detectId = "";
	
	curObjID = maps\mp\gametypes\_gameobjects::getNextObjID();	
	objective_add(curObjID, "invisible", (0,0,0));
	objective_position(curObjID,position);
	objective_state(curObjID, "active");
	objective_icon(curObjID, shader);
	Objective_OnEntity( <objective_number>, self);
	*/
	
	//self iprintln("You chosen "+response);
	
	//if(!isDefined(self.HUD["STATS"]["rpg"])) self.HUD["STATS"]["rpg"] = self createText("default", 1.4, "LEFT", "LEFT",  0 + self.AIO["safeArea_X"], -20 + self.AIO["safeArea_Y"], 1, 1, (1,1,1));
	//if(!isDefined(self.HUD["STATS"]["saveandload"])) self.HUD["STATS"]["saveandload"] = self createText("default", 1.4, "LEFT", "LEFT",  0 + self.AIO["safeArea_X"], -3 + self.AIO["safeArea_Y"], 1, 1, (1,1,1));
	
	//if(!isDefined(self.HUD["STATS"]["diffi"])) self.HUD["STATS"]["diffi"] = self createText("objective", 1.4, "LEFT", "LEFT",  0 + self.AIO["safeArea_X"], -100 + self.AIO["safeArea_Y"], 1, 1, (1,1,1));
	//if(!isDefined(self.HUD["STATS"]["diffic"])) self.HUD["STATS"]["diffic"] = self createText("default", 1.4, "LEFT", "LEFT",  0 + self.AIO["safeArea_X"], -89 + self.AIO["safeArea_Y"], 1, 1, (1,1,1));
	
	//self.HUD["STATS"]["diffi"] setText("Difficulty:");
	
	

/*

getPlayerPodium(parkourSelected,place,rang)
{
	for(i=0;i<level.players.size;i++)
	{
		if(rang == level.playerchosen_second && level.players[i] == level.playerchosen_first)
					continue;
					
		if(rang == level.playerchosen_third)
		{
			if(level.players[i] == level.playerchosen_first)
					continue;
			if(level.players[i] == level.playerchosen_second)
					continue;
		}

		level.players[i] = rang;
		
		for(a=0;a<level.players.size;a++)
		{
			if(rang == level.playerchosen_second && level.players[i] == level.playerchosen_first)
					continue;
					
			if(rang == level.playerchosen_third)
			{
				if(level.players[i] == level.playerchosen_first)
						continue;
				if(level.players[i] == level.playerchosen_second)
						continue;
			}
		
			if(level.players[a].my_score[parkourSelected] >= level.playerchosen_first.my_score[parkourSelected])
			{
				rang.podium[place] = false;
				rang = level.players[a];
				level.players[a].podium[place] = true;
			}
		}
	}
	
	for(z=0;z<level.players.size;z++)
	{
		if(level.players[z].podium[place] == true)
			return level.players[z];
	}
		
	
}

*/

RPG_Security()
{
	self endon("disconnect");
	self endon("death");
	
	self.challenge["rpg"] = false;
	
	while(1)
	{
		self waittill("weapon_fired");
		
		if(self getplayerangles()[0] > 30 && !self isOnground() && self getcurrentweapon() == "rpg_mp")
		{
			self.challenge["rpg"] = true;
		}
		wait .05;
	}
}

RPG_DPAD(mode)
{
	self endon("disconnect");
	self endon("EndRpg");
	self endon("death");
	
	self giveWeapon("rpg_mp");
	self SetActionSlot(4, "weapon", "rpg_mp" );
	
	self.challenge["norpg"] = true;

	for(;;)
	{
		self waittill("weapon_fired");
		self waittill("reload");
		
		self.challenge["norpg"] = false;
		
		
		if(self getCurrentWeapon() == "rpg_mp")
		{
			self giveMaxAmmo("rpg_mp");
			if(self getWeaponAmmoClip("rpg_mp") < 1) self SetWeaponAmmoClip("rpg_mp", 1);
		}
	}
}
Savex1()
{
	self endon("disconnect");
	self endon("New_SL_rules");
	
	for(;;)
	{
		if(self meleebuttonpressed() && self isOnground() && isalive(self))
		{
			wait .1;
			self.CurrentSpawn = self.origin;
			self.CurrentAngles = self getplayerangles();
						
			self iprintln("Position ^5S^7aved");
				
			wait 1;			
		}
		wait .05;
	}
}

chooseDiffi(a,b,c)
{
	curseur = a;
	
	self.IN_MENU["MAP"] = true;
	
	while(self.IN_MENU["MAP"])
	{
		self freezecontrols(true);
		
		if(self attackbuttonpressed() || self adsbuttonpressed() && !self.killcam)
		{
			self playlocalsound("mouse_over");
			
			if(curseur == a)
			{
				curseur = b;
				self.HUD_lava["option"].color = (1,0,0);
				self.HUD_lava["text"].color = (1,1,1);
				self.HUD_lava["text1"].color = (1,1,0);
				self.HUD_lava["text2"].color = (1,1,1);
				
			}
			else if(curseur == b)
			{
				curseur = c;
				
				self.HUD_lava["option"].color = (1,0,0);
				self.Replay["HUD"]["SAVE_TIME"][0].color = (1,0,0);
				self.Replay["HUD"]["SAVE_TIME"][2].color = (1,0,0);
				
				self.HUD_lava["text"].color = (1,1,1);
				self.HUD_lava["text1"].color = (1,1,1);
				self.HUD_lava["text2"].color = (1,1,0);
			}
			else if(curseur == c)
			{
				curseur = a;
				
				self.HUD_lava["option"].color = (1,1,1);
				self.Replay["HUD"]["SAVE_TIME"][0].color = (0/255,128/255,255/255);
				self.Replay["HUD"]["SAVE_TIME"][1].color = (190/255,190/255,190/255);
				self.Replay["HUD"]["SAVE_TIME"][2].color = (0/255,128/255,255/255);
				self.Replay["HUD"]["SAVE_TIME"][3].color = (1,1,1);
				self.HUD_lava["text"].color = (1,1,0);
				self.HUD_lava["text1"].color = (1,1,1);
				self.HUD_lava["text2"].color = (1,1,1);
			}
			wait .2;
		}
		if(self usebuttonpressed() && !self.killcam)
			break;
		
		wait .05;
	}
	

	
	self freezecontrols(false);
	self.IN_MENU["MAP"] = false;
	
	
	self playlocalsound("weap_suitcase_button_press_plr");
	
	return curseur;
}


LavaLogics()
{

	for(;;)
	{
		level waittill("update_parkour_score");
		
		
		
	}
	for(;;)
	{
		for(z=0;z<level.players.size;z++)
		{
			level.players[z].podium["first"] = false;
			level.players[z].podium["second"] = false;
			level.players[z].podium["third"] = false;
		}
	
		for(i=0;i<level.players.size;i++)
		{
			level.playerchosen_first = level.players[i];
			
			for(a=0;a<level.players.size;a++)
			{
				if(level.players[a].my_score["ParkourA"] >= level.playerchosen_first.my_score["ParkourA"])
				{
					level.playerchosen_first.podium["first"] = false;
					level.playerchosen_first = level.players[a];
					level.players[a].podium["first"] = true;
				}
			}
		}
		
		for(z=0;z<level.players.size;z++)
		{
			if(level.players[z].podium["first"] == true)
				iprintln("best is "+level.players[z].name);
		}
		
		
		
		if(level.players.size > 1)
		{
			for(i=0;i<level.players.size;i++)
			{
				if(level.players[i] == level.playerchosen_first)
					continue;
				
				level.playerchosen_second = level.players[i];
				
				for(a=0;a<level.players.size;a++)
				{
					if(level.players[a] == level.playerchosen_first)
						continue;
					
					if(level.players[a].my_score["ParkourA"] >= level.playerchosen_second.my_score["ParkourA"])
					{
						//if(level.players[a] != level.playerchosen_second)
						{
							level.playerchosen_second.podium["second"] = false;
							level.playerchosen_second = level.players[a];
							level.players[a].podium["second"] = true;
							
						}
					}
					
				}
			}
			
			for(z=0;z<level.players.size;z++)
			{
				if(level.players[z].podium["second"] == true)
					iprintln("second is "+level.players[z].name);
			}
		}
		if(level.players.size > 2)
		{
			for(i=0;i<level.players.size;i++)
			{
				if(level.players[i] == level.playerchosen_first)
					continue;
				if(level.players[i] == level.playerchosen_second)
					continue;
				
				level.playerchosen_third = level.players[i];
				
				for(a=0;a<level.players.size;a++)
				{
					if(level.players[a] == level.playerchosen_first)
						continue;
					if(level.players[a] == level.playerchosen_second)
						continue;
					
					if(level.players[a].my_score["ParkourA"] >= level.playerchosen_third.my_score["ParkourA"])
					{
						//if(level.players[a] != level.playerchosen_third)
						{
							level.playerchosen_third.podium["third"] = false;
							level.playerchosen_third = level.players[a];
							level.players[a].podium["third"] = true;
							
						}
					}
				}
			}

			for(z=0;z<level.players.size;z++)
			{
				if(level.players[z].podium["third"] == true)
					iprintln("third is "+level.players[z].name);
			}
		}
		wait 1;
	}
}