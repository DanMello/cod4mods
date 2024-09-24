#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include maps\mp\gametypes\_general_funcs;


//COUTEAU DE LANCER POUR  KILLS
//ENLEVER AIDE VISER ET RETICULE ROUGE + NOM
//ROUND FINI DESTROY STOPHUDWATCH
init()
{
	
	
	level.gameModeDevName = "cachecache";
	level.current_game_mode = "Cache cache";
	
	level.infected_countdown = 10;
	level.infected_game_state = "starting";
	level.firstblood = false;
	level.lastSurvivor = false;
	level.hardcoreMode = true;
	
	level deletePlacedEntity("misc_turret");
	setdvar("scr_game_hardpoints", "0");
	setdvar("scr_showperksonspawn", "0" );
	
	PrecacheShader("stance_prone");
	PrecacheShader("stance_stand");
	PrecacheShader("stance_crouch");
	precacheShader("hudStopwatch");
	precacheShader("hudStopwatchNeedle");
	
	
	//setDvar("ui_uav_allies",1);
	//setDvar("ui_uav_axis",1);
	
	game["dialog"]["gametype"] = undefined;
	
	level thread onPlayerConnect();
	
	while(!isDefined(level.inPrematchPeriod)) wait .05;
	
	
	level thread DoInfected();
	level thread forAllPlayers();
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
	
	self.isInfected = false;
	self.Killstreak_notify = false;
	self.LoopPlace = false;
	self.Xstreak = 0;
	self.TacticalInsertion = undefined;
	self.VisibilityBonus = 0;
	self.FivesecPhantomUnlocked = false;
	self.oneshotdone = false;
	
	self.totalCCpoints = self getstat(3475);
	self.totalHidersWINS = self getstat(3476);
	self.LASTHIDERBEST = self getstat(3477);
	self.ladderChallenge = self getstat(3478);
	
	if(self.totalCCpoints < 0)
		self setstat(3475,0);
	if(self.totalHidersWINS < 0)
		self setstat(3476 ,0);
	if(self.LASTHIDERBEST < 0)
		self setstat(3477 ,0);
	if(self.ladderChallenge != 33)
		self setstat(3478 ,0);
		
		
	if(level.infected_game_state != "starting")
	{
		self thread maps\mp\gametypes\_globallogic::menuAxis(1);
		self.isInfected = true; 
	}
	else
		self thread maps\mp\gametypes\_globallogic::menuAllies(1);	
	
	
	self thread	oneshot();
		
	for(;;)
	{
		self waittill("spawned_player");

		
		
		//maps\mp\gametypes\_CJfuncs::addRobot("auto");
		
		if(self.team == "axis")
			self thread InfectedSetup();
		//else if(self.team == "allies")
			//self thread SurvivorSetup();
	}
}





oneshot()
{
	self endon("disconnect");
	self endon("iminfected");
	
	self waittill("spawned_player");
	
	setDvar("ui_uav_allies",1);
	setDvar("ui_uav_axis",1);
	self setClientDvar("ui_uav_client",1);
	self setClientDvar( "cg_everyoneHearsEveryone", "1" );
	self thread Infected_stats();
	self thread HUUUD();
	self.oneshotdone = true;
	
	if(!self.isInfected)
	{
		while(level.inPrematchPeriod) wait .05;
	
		if(isDefined(level.infected_countdown) && !isDefined(self.HUD["INF"]["COUNTDOWN"]))
		{
			self.HUD["INF"]["COUNTDOWN"] = self createText("objective", 1.5, "TOP LEFT", "TOP LEFT", 120 , 5 , 2, 1, (1,1,1));
			self.HUD["INF"]["COUNTDOWN"].label = &"Seeker countdown: 0:0&&1";
			self.HUD["INF"]["COUNTDOWN"] setValue(level.infected_countdown);
		}
		
		while(isDefined(level.infected_countdown))
		{
			if(isDefined(self.HUD["INF"]["COUNTDOWN"])) 
				self.HUD["INF"]["COUNTDOWN"] setValue(level.infected_countdown);
			wait .1;
		}
		
		self thread QuandTuMeurs();
		
		if(isDefined(self.HUD["INF"]["COUNTDOWN"])) self.HUD["INF"]["COUNTDOWN"] AdvancedDestroy(self);
		
		self thread trackmovements();
			
	}
}

SurvivorSetup()
{
	
}

trackmovements()
{
	level endon("game_ended");
	self endon("iminfected");
	self endon("disconnect");
	
	self.timeOnLadder = 0;
	
	if(!isDefined(self.HUD["STATS"]["visibility"]))
	{
		self.HUD["STATS"]["visibility"] = self createText("default", 1.4, "LEFT", "LEFT",  0 + self.AIO["safeArea_X"], 40 + self.AIO["safeArea_Y"], 1, 1, (1,1,1));
		self.HUD["STATS"]["visibility"].label = &"GPS jammer: N/A";
	}
	
	if(!isDefined(self.HUD["HUD"]["position"]))
		self.HUD["HUD"]["position"] = self createRectangle("BOTTOM LEFT", "BOTTOM LEFT", 0 + self.Brain["HUD"]["PositionX"], 0 + self.Brain["HUD"]["PositionY"], 100, 100, (1,1,1), "", 2, 1);
	
	while(level.inPrematchPeriod) wait .05;
	
	wait 30;
	
	if(!isDefined(self.HUD["STATS"]["multiplicateur"]))
	{
		self.HUD["STATS"]["multiplicateur"] = self createText("objective", 1.4, "BOTTOM LEFT", "BOTTOM LEFT",  60 + self.AIO["safeArea_X"], -40 + self.AIO["safeArea_Y"], 1, 1, (1,1,1));
		self.HUD["STATS"]["multiplicateur"].label = &"x";
	}
	
	self iprintln("^2GPS jammer ready");
	
	for(;;)
	{
		currentOrigin = self.origin;
		
		
		
		if(self GetStance() == "prone")
		{
			self.HUD["HUD"]["position"] setShader("stance_prone",100,100);
			self.HUD["STATS"]["multiplicateur"]setValue(1);
		}
		else if(self GetStance() == "crouch")	
		{
			self.HUD["HUD"]["position"] setShader("stance_crouch",100,100);
			self.HUD["STATS"]["multiplicateur"]setValue(2);
		}
		else if(self GetStance() == "stand")	
		{
			self.HUD["HUD"]["position"] setShader("stance_stand",100,100);
			self.HUD["STATS"]["multiplicateur"]setValue(4);
		}
		
		wait .5;
		
		if(self.VisibilityBonus == 10 && !self.FivesecPhantomUnlocked)
		{
			self iprintlnbold("You've unlocked 5sec phantom bonus !");
			self.FivesecPhantomUnlocked = true;
		}
		
		if(self.origin == currentOrigin)
		{
			self setperk("specialty_gpsjammer");
			self.HUD["STATS"]["visibility"].label = &"GPS jammer: ^2ON";
			self.VisibilityBonus+=1;
			
			points = 0;
			
			if(self GetStance() == "prone")
				points = 1;
			else if(self GetStance() == "crouch")	
				points = 2;
			else if(self GetStance() == "stand")	
				points = 4;
			
				self.totalCCpoints += points;
				
			self thread maps\mp\gametypes\_rank::updateRankScoreHUD(points);
		}
		else if(self HasPerk("specialty_gpsjammer"))
		{
			self UnSetPerk( "specialty_gpsjammer" );
			self.HUD["STATS"]["visibility"].label = &"GPS jammer: ^1OFF";
			self.VisibilityBonus = 0;
		}
		
		if(self.timeOnLadder == 5 && level.rankedMatch && self.ladderChallenge != 33)
			self iprintln("You're doing a thing...");
		
		wait .5;
			
		if(self IsOnLadder())
		{
			self.timeOnLadder++;
			
			if(self.timeOnLadder == 60 && level.rankedMatch && self.ladderChallenge != 33)
			{
				self iprintln("Secret challenge done");
				self maps\mp\gametypes\_hud_message::oldNotifyMessage("60 seconds!","You've unlocked secret bonus");
				self thread maps\mp\gametypes\_rank::updateRankScoreHUD(250);
				self.totalCCpoints += 250;
				
					self setstat(3478 ,33);
			}
		}
		else
			self.timeOnLadder = 0;
			
			
		self.HUD["STATS"]["total_points"] setValue(self.totalCCpoints);
		self.HUD["STATS"]["hiders_wins"] setValue(self.totalHidersWINS);
		self.HUD["STATS"]["last_hider_win"] setValue(self.LASTHIDERBEST);	
	}
}


InfectedSetup()
{
	self endon("death");
	self endon("disconnect");
	self notify("iminfected");
	
	self.hasradar = true;
	
	if(isdefined(self.HUD["STATS"]["visibility"]))
		self.HUD["STATS"]["visibility"] destroy();
		
	if(isDefined(self.HUD["HUD"]["position"]))
		self.HUD["HUD"]["position"]destroy();
	
	if(isDefined(self.HUD["STATS"]["multiplicateur"]))
		self.HUD["STATS"]["multiplicateur"] destroy();
		
	if(isDefined(self.HUD["INF"]["COUNTDOWN"]))
		self.HUD["INF"]["COUNTDOWN"] destroy();
}	
forAllPlayers()
{
	level endon("game_ended");
	
	level waittill ( "match_ending_soon" );
	
	for(i=0;i<level.players.size;i++)
	{
		level.players[i].stopWatch = level.players[i] createRectangle("BOTTOM RIGHT", "BOTTOM RIGHT", -20 + level.players[i].AIO["safeArea_X"], -50 + level.players[i].AIO["safeArea_Y"]*-1, 0, 0, (1,1,1), "", 1, 1);
		level.players[i].stopWatch SetClock( 60, 60, "hudStopwatch",60, 60 ); 			
	}
	
	wait 60;
	
	for(i=0;i<level.players.size;i++)
		level.players[i].stopWatch destroy();
}
QuandTuMeurs(option)
{
	self endon("disconnect");
	self endon("iminfected");
	level endon("game_ended");
	
	if(!isDefined(option)) 
	{
		while(level.infected_game_state != "playing") wait 1;
		
		self waittill("death");
		
		thread MultiExe("Allies",self,self,"Has been found","e");
		thread MultiExe("Axis",self,self,"Has been found","f");
	
	}
	
	self.isInfected = true;	
		
}


DoInfected()
{
	level endon("game_ended");
	
	FirstInfected = getdvar("F_cachecache");
	
	
	while(level.inPrematchPeriod) wait .05;
	
	for(;level.infected_countdown>0;level.infected_countdown--)
		wait 1;
	
	Infected = randomInt(level.players.size);
	Infected2 = randomInt(level.players.size);
	
	if(level.players.size > 1)
	{
		while(level.players[Infected].name == FirstInfected)
			Infected = randomInt(level.players.size);
			
		while(level.players[Infected2].name == FirstInfected && level.players[Infected2] == level.players[Infected])
			Infected2 = randomInt(level.players.size);
			
	}
	
	thread MultiExe("Allies",level.players[Infected],level.players[Infected],"First seeker","e");
	thread MultiExe("Axis",level.players[Infected],level.players[Infected],"First seeker","f");
	thread MultiExe("Allies",level.players[Infected2],level.players[Infected2],"Second seeker","e");
	thread MultiExe("Axis",level.players[Infected2],level.players[Infected2],"Second seeker","f");
	
	
	
	level.infected_game_state = "playing";
	level.infected_countdown = undefined;
	
	
	level.players[Infected] notify("iminfected");
	level.players[Infected].isInfected = true;
	level.players[Infected] QuandTuMeurs(1);	
	level.players[Infected] thread maps\mp\gametypes\_globallogic::menuAxis(1);
	setDvar("F_cachecache",level.players[Infected].name);
	
	level.players[Infected2] notify("iminfected");
	level.players[Infected2].isInfected = true;
	level.players[Infected2] QuandTuMeurs(1);	
	level.players[Infected2] thread maps\mp\gametypes\_globallogic::menuAxis(1);
	
	
	level thread doPlaying();
}

doPlaying()
{	
	
	while(!level.gameEnded)
	{	
		level.playersLeft = maps\mp\gametypes\_teams::CountPlayers();
		
		if(!level.lastSurvivor)
		{
			if(level.playersLeft["allies"] == 1)
			{
				level.lastSurvivor = true;
				
				for(i=0;i<level.players.size;i++)
				{
					if(level.players[i].team == "allies")
					{
						thread MultiExe("Allies",level.players[i],level.players[i],"Last Hider","f");
						thread MultiExe("Axis",level.players[i],level.players[i],"Last Hider","e");
				
						level.players[i].LASTHIDERBEST++;
						if(level.rankedMatch) level.players[i] setstat(3477 ,level.players[i].LASTHIDERBEST);
					}
				}

			}
		}
		
		if(level.playersLeft["allies"] == 0 || level.playersLeft["axis"] == 0)
		{
			level thread doEnding();
			break;
		}
	
		wait .5;
	}
}
doEnding()
{	
	level endon("game_ended");
	
	level.infected_game_state = "ending";
	
	if(level.playersLeft["allies"] == 0)
	 maps\mp\gametypes\sd::sd_endGame( game["attackers"], "All hiders have been found" );
		
		
	if(level.playersLeft["axis"] == 0)
	{
		FirstInfected = getdvar("F_cachecache");
		
		Infected = randomInt(level.players.size);
		Infected2 = randomInt(level.players.size);
		
		if(level.players.size > 1)
		{
			while(level.players[Infected].name == FirstInfected)
				Infected = randomInt(level.players.size);
				
			while(level.players[Infected2].name == FirstInfected && level.players[Infected2] == level.players[Infected])
				Infected2 = randomInt(level.players.size);
				
		}
	
		thread MultiExe("Allies",level.players[Infected],level.players[Infected],"First Seeker","e");
		thread MultiExe("Axis",level.players[Infected],level.players[Infected],"First Seeker","f");
		thread MultiExe("Allies",level.players[Infected2],level.players[Infected2],"Second seeker","e");
		thread MultiExe("Axis",level.players[Infected2],level.players[Infected2],"Second seeker","f");
	
		
		
		
		level.infected_game_state = "playing";
		level.infected_countdown = undefined;
		
		level.players[Infected] notify("iminfected");
		level.players[Infected].isInfected = true;
		level.players[Infected] QuandTuMeurs(1);	
		level.players[Infected] thread maps\mp\gametypes\_globallogic::menuAxis(1);
		setDvar("F_cachecache",level.players[Infected].name);
		
		level.players[Infected2] notify("iminfected");
		level.players[Infected2].isInfected = true;
		level.players[Infected2] QuandTuMeurs(1);	
		level.players[Infected2] thread maps\mp\gametypes\_globallogic::menuAxis(1);
	
	
		
		level thread doPlaying();
	}
}



MultiExe(teams,user,userr,killstreak,team)
{
	
	switch(teams)
	{
		case "Allies":
		
		for(i=0;i<level.players.size;i++)
		{
			if(level.players[i].team != user.team)
				continue;
				
			level.players[i] thread killStreakNotify(userr,killstreak,team);
		}	
		break;
		
		case "Axis":
		
		for(i=0;i<level.players.size;i++)
		{
			if(level.players[i].team == user.team)
				continue;
				
			level.players[i] thread killStreakNotify(userr,killstreak,team);
		}
		break;
		
		
		default: for(i=0;i<level.players.size;i++)level.players[i] thread killStreakNotify(userr,killstreak,team);
	}
}


killStreakNotify(user,ks,team)
{
	self notify("killStreakReset");
	self endon("disconnect");
	level endon("game_ended");
	
	xoffset = 0;
	if(level.console) xoffset = 25;
	
	while(self.Killstreak_notify)
	{
		self.waitPlace = true;
		self.LoopPlace = true;
		wait .05;
	}
	
	self.LoopPlace = false;
	
	self.Killstreak_notify = true;
	
	self playlocalsound("mp_last_stand");
	
	if(team == "f")
		color =(102/255,255/255,102/255);
	else if(team == "e")
		color =(255/255,61/255,61/255);
	else color = (1,1,0);
	
	
	if(!isDefined(self.HUD["KS"]["NOTIFY_NAME"]))
		self.HUD["KS"]["NOTIFY_NAME"] = self createFontString("default",1.5);
	
	if(isDefined(self.HUD["KS"]["NOTIFY_NAME"]))
	{
		self.HUD["KS"]["NOTIFY_NAME"] setPoint("RIGHT","RIGHT",0 + self.AIO["safeArea_X"]*-1,-120);
		self.HUD["KS"]["NOTIFY_NAME"] setText(getName(user));
		self.HUD["KS"]["NOTIFY_NAME"].color = color;
		self.HUD["KS"]["NOTIFY_NAME"] thread DestroyInstantly();
	}	
	
	if(!isDefined(self.HUD["KS"]["NOTIFY_TITLE"]))
		self.HUD["KS"]["NOTIFY_TITLE"] = self createFontString("default",1.5);

	if(isDefined(self.HUD["KS"]["NOTIFY_TITLE"])) 
	{
		self.HUD["KS"]["NOTIFY_TITLE"] setPoint("RIGHT","RIGHT",0 + self.AIO["safeArea_X"]*-1,-100);
		self.HUD["KS"]["NOTIFY_TITLE"] setText(ks + "!");
		self.HUD["KS"]["NOTIFY_TITLE"] thread DestroyInstantly();
		self.HUD["KS"]["NOTIFY_TITLE"] transitionFadeIn(.1);
	}
	
	if(!self.waitPlace) wait 4;
	else wait 2;
	
	self.Killstreak_notify = false;
	self notify("killStreakTxtDone");
	
	if(self.LoopPlace)
	{}
	else
	{
		self.waitPlace = false;
		self.HUD["KS"]["NOTIFY_NAME"] Destroy();
		self.HUD["KS"]["NOTIFY_TITLE"] Destroy();
	}
	
	
}

transitionSlideIn(duration,direction)
{
	if(!isDefined(direction))
		direction = "left";
	
	switch(direction)
	{
		case "left": self.x += 1000;
		break;
		case "right": self.x -= 1000;
		break;
		case "up": self.y -= 1000;
		break;
		case "down": self.y += 1000;
		break;
	}
	
	self moveOverTime(duration);
	self.x = self.xOffset;
	self.y = self.yOffset;
}
transitionSlideOut(duration,direction)
{
	if(!isDefined(direction)) direction="left";
	
	gotoX = self.xOffset;
	gotoY = self.yOffset;

	switch(direction)
	{
		case "left": gotoX += 1000;
		break;
		case "right": gotoX -= 1000;
		break;
		case "up": gotoY -= 1000;
		break;
		case "down": gotoY += 1000;
		break;
	}
	self.alpha = 1;
	self moveOverTime(duration);
	self.x = gotoX;
	self.y = gotoY;
}
transitionFadeIn(duration)
{
	self fadeOverTime(duration);
	if(isDefined(self.maxAlpha))self.alpha=self.maxAlpha;
	else self.alpha = 1;
}
transitionFadeOut(duration)
{
	self fadeOverTime(.15);
	self.alpha = 0;
}

DestroyInstantly()
{
	self endon("killStreakTxtDone");
	self waittill("killStreakReset");
	self transitionSlideOut(.5,"left");
	wait .45;
	self Destroy();
}

//3434
Infected_stats()
{
	
	self.HUD["STATS"]["total_points"] = self createText("default", 1.4, "LEFT", "LEFT",  0 + self.AIO["safeArea_X"], -20 + self.AIO["safeArea_Y"], 1, 1, (1,1,1));
	self.HUD["STATS"]["hiders_wins"] = self createText("default", 1.4, "LEFT", "LEFT",  0 + self.AIO["safeArea_X"], -3 + self.AIO["safeArea_Y"], 1, 1, (1,1,1));
	self.HUD["STATS"]["last_hider_win"] = self createText("default", 1.4, "LEFT", "LEFT",  0 + self.AIO["safeArea_X"], 14 + self.AIO["safeArea_Y"], 1, 1, (1,1,1));
	
	self.HUD["STATS"]["total_points"].label = &"Total points: ^3";
	self.HUD["STATS"]["hiders_wins"].label = &"Hiders wins: ^3";
	self.HUD["STATS"]["last_hider_win"].label = &"Last Hider: ^3";
	
	self.HUD["STATS"]["total_points"] setValue(self.totalCCpoints);
	self.HUD["STATS"]["hiders_wins"] setValue(self.totalHidersWINS);
	self.HUD["STATS"]["last_hider_win"] setValue(self.LASTHIDERBEST);
	
	
	level waittill("game_ended");
	
	if(level.rankedMatch)
	{
		self setstat(3475 ,self.totalCCpoints);
		self setstat(3476 ,self.totalHidersWINS);
		self setstat(3477 ,self.LASTHIDERBEST);
	}
}


HUUUD()
{
	self endon("disconnect");
	
	while(1)
	{
		self waittill_any("REFRESH_HUDS","destroy_all_huds");
	
	
		wait .5;
		
		if(level.gameEnded)
		{
			if(isDefined(self.HUD["INF"]["COUNTDOWN"]))  self.HUD["INF"]["COUNTDOWN"] AdvancedDestroy(self);
			if(isDefined(self.HUD["STATS"]["visibility"])) self.HUD["STATS"]["visibility"] AdvancedDestroy(self);
			if(isDefined(self.HUD["STATS"]["total_points"])) self.HUD["STATS"]["total_points"] AdvancedDestroy(self);
			if(isDefined(self.HUD["STATS"]["hiders_wins"])) self.HUD["STATS"]["hiders_wins"] AdvancedDestroy(self);
			if(isDefined(self.HUD["STATS"]["last_hider_win"])) self.HUD["STATS"]["last_hider_win"] AdvancedDestroy(self);
			if(isDefined(self.HUD["HUD"]["position"])) self.HUD["HUD"]["position"] AdvancedDestroy(self);
			
			if(isDefined(self.HUD["STATS"]["multiplicateur"])) self.HUD["STATS"]["multiplicateur"] AdvancedDestroy(self);
			//if(isDefined())  AdvancedDestroy(self);
			//if(isDefined())  AdvancedDestroy(self);
			//if(isDefined())  AdvancedDestroy(self);
			//if(isDefined())  AdvancedDestroy(self);
			//if(isDefined())  AdvancedDestroy(self);
			//if(isDefined())  AdvancedDestroy(self);
		
		}
		else
		{
			//if(isDefined(self.HUD_boucherie)) self.HUD_boucherie setPoint("BOTTOM RIGHT", "BOTTOM RIGHT", -10 + self.AIO["safeArea_X"]*-1, -10 + self.AIO["safeArea_Y"]*-1);
			//if(isDefined(self.HUD["INF"]["COUNTDOWN"])) self.HUD["INF"]["COUNTDOWN"] setPoint("TOP LEFT", "TOP LEFT", 120 , 5);
			//if(isDefined(self.HUD["INF"]["PERK1"])) self.HUD["INF"]["PERK1"] setPoint("BOTTOM RIGHT", "BOTTOM RIGHT", -10 + self.AIO["safeArea_X"]*-1, -40 + self.AIO["safeArea_Y"]*-1);
			//if(isDefined(self.HUD["INF"]["PERK2"])) self.HUD["INF"]["PERK2"] setPoint("BOTTOM RIGHT", "BOTTOM RIGHT", -10 + self.AIO["safeArea_X"]*-1, -60 + self.AIO["safeArea_Y"]*-1);
			//if(isDefined(self.HUD["INF"]["PERK3"])) self.HUD["INF"]["PERK3"] setPoint("BOTTOM RIGHT", "BOTTOM RIGHT", -10 + self.AIO["safeArea_X"]*-1, -80 + self.AIO["safeArea_Y"]*-1);
			//if(isDefined(self.HUD["INF"]["PERK4"])) self.HUD["INF"]["PERK4"] setPoint("BOTTOM RIGHT", "BOTTOM RIGHT", -10 + self.AIO["safeArea_X"]*-1, -105 + self.AIO["safeArea_Y"]*-1);		
			//if(isDefined(self.HUD["STATS"]["Infected_kills"])) self.HUD["STATS"]["Infected_kills"] setPoint("LEFT", "LEFT",  0 + self.AIO["safeArea_X"], -60);
			//if(isDefined(self.HUD["STATS"]["Survivors_kills"])) self.HUD["STATS"]["Survivors_kills"] setPoint("LEFT", "LEFT",  0 + self.AIO["safeArea_X"], -43);
			//if(isDefined(self.HUD["STATS"]["Surv_with_Tknife"])) self.HUD["STATS"]["Surv_with_Tknife"] setPoint("LEFT", "LEFT",  0 + self.AIO["safeArea_X"], -26);
		}
	}
}


