#include common_scripts\utility;
#include maps\mp\gametypes\_hud_util;
#include maps\mp\_utility;
#include maps\mp\gametypes\_general_funcs;

init()
{
	level thread onPlayerConnect();
 
	level.gameModeDevName = "INF";
	level.current_game_mode = "Infected";
	level deletePlacedEntity("misc_turret");
	level.infected_game_state = "starting";
	level.firstblood = false;
	level.lastSurvivor = false;
	level.hardcoreMode = true;
	
	PrecacheShader("killiconmelee");
	PrecacheModel("weapon_parabolic_knife");
	level.flagBase_red = loadfx( "misc/ui_flagbase_red" );
	
	setdvar("scr_game_hardpoints", "0");
	setdvar("scr_showperksonspawn", "0" );
	
	
	level.armeAterre = 0;
	
	level.Infected_primary_weapons = strTOK("m1014_grip_mp;mp44_mp;p90_reflex_mp;winchester1200_grip_mp;g36c_reflex_mp;mp5_acog_mp;g3_reflex_mp;m16_reflex_mp;m21_acog_mp;m4_mp",";");
	level.Infected_secondary_weapons = strTOK("skorpion_mp;uzi_mp;barrett_mp;m40a3_acog_mp;m14_reflex_mp;deserteagle_mp",";");
	
	while(!isDefined(level.inPrematchPeriod)) wait .05;

	setDvar("ui_uav_allies",1);
	setDvar("ui_uav_axis",1);
	
	level thread StartInfected();
}
onPlayerConnect()
{
	for(;;)
	{
		level waittill( "connected", player );
		
		player.isInfected = false;
		player.Killstreak_notify = false;
		player.LoopPlace = false;
		player.Xstreak = 0;
		player.TacticalInsertion = undefined;
		
		player thread onPlayerSpawned();
		

	}
}
onPlayerSpawned()
{
	self endon("disconnect");

	while(!isDefined(self.connect_script_done)) wait .05;
	
	self.Infected_kills = self getstat(3438);
	self.Survivors_kills = self getstat(3439);
	self.Surv_with_Tknife = self getstat(3437);
	
	
	if(self.Infected_kills < 0)
		self setstat(3438,0);
	if(self.Survivors_kills < 0)
		self setstat(3439,0);
	if(self.Surv_with_Tknife < 0)
		self setstat(3437,0);
		

	if(level.infected_game_state != "starting")
	{
		self thread maps\mp\gametypes\_globallogic::menuAxis(1);
		self.isInfected = true; 
	}
	else
	{
		self thread maps\mp\gametypes\_globallogic::menuAllies(1);	
		self thread SurvivorSetup();
	}
	
	if(level.rankedMatch)
		self thread Infected_stats();
	
	
	
	for(;;)
	{
		self waittill("spawned_player");
		
		self.hasRadar = true;
		self setclientdvar("cg_drawCrosshair","1");
		
		if(isDefined(self.TacticalInsertion)) 
			self thread ResetTacticalInsertion();
			
		if(self.team == "axis")
			self thread InfectedSetup();
	}
} 



//3434
Infected_stats()
{
	self waittill("spawned_player");
	
	self.HUD["STATS"]["Infected_kills"] = self createText("default", 1.4, "LEFT", "LEFT",  0 + self.AIO["safeArea_X"], -20 + self.AIO["safeArea_Y"], 1, 1, (1,1,1));
	self.HUD["STATS"]["Survivors_kills"] = self createText("default", 1.4, "LEFT", "LEFT",  0 + self.AIO["safeArea_X"], -3 + self.AIO["safeArea_Y"], 1, 1, (1,1,1));
	self.HUD["STATS"]["Surv_with_Tknife"] = self createText("default", 1.4, "LEFT", "LEFT",  0 + self.AIO["safeArea_X"], 14 + self.AIO["safeArea_Y"], 1, 1, (1,1,1));
	
	self.HUD["STATS"]["Infected_kills"].label = &"Infected killed: ^3";
	self.HUD["STATS"]["Survivors_kills"].label = &"Survivors killed: ^3";
	self.HUD["STATS"]["Surv_with_Tknife"].label = &"With Throwing knife: ^3";
	
	self.HUD["STATS"]["Infected_kills"] setValue(self.Infected_kills);
	self.HUD["STATS"]["Survivors_kills"] setValue(self.Survivors_kills);
	self.HUD["STATS"]["Surv_with_Tknife"] setValue(self.Surv_with_Tknife);
	
	level waittill("game_ended");
	
	if(level.rankedMatch)
	{
		self setstat(3438,self.Infected_kills);
		self setstat(3439,self.Survivors_kills);
		self setstat(3437,self.Surv_with_Tknife);
	}
}




CheckInfectedWeapon()
{
	self endon("disconnect");
	level endon("game_ended");
	self endon("death");
	
	while(1)
	{
		
		if(self getcurrentweapon() != "usp_mp")
		{
			self dropitem(self getcurrentweapon());
			self giveWeapon("usp_mp");
			self setWeaponAmmoClip("usp_mp", 0);
			self setWeaponAmmoStock("usp_mp", 0);
			self switchtoweapon("usp_mp");
		}
		wait .1;
	}
}


InfectedSetup()
{
	self notify("isInfected");
	
	self setClientDvar( "cg_everyoneHearsEveryone", "1" );
	
	if(isDefined(self.HUD["INF"]["PERK1"])) self.HUD["INF"]["PERK1"] AdvancedDestroy(self);
	if(isDefined(self.HUD["INF"]["PERK2"])) self.HUD["INF"]["PERK2"] AdvancedDestroy(self);
	if(isDefined(self.HUD["INF"]["PERK3"])) self.HUD["INF"]["PERK3"] AdvancedDestroy(self);
	if(isDefined(self.HUD["INF"]["PERK4"])) self.HUD["INF"]["PERK4"] AdvancedDestroy(self);
	
	if(!isDefined(self.HUD_boucherie))
		self.HUD_boucherie = self createRectangle("BOTTOM RIGHT", "BOTTOM RIGHT", -10 + self.AIO["safeArea_X"], -10 + self.AIO["safeArea_Y"]*-1, 40, 40, (1,1,1), "killiconmelee", 1, 1);
	else
		self.HUD_boucherie.alpha = 1;
		
	self thread InfectedHUDD();
	self thread CheckInfectedWeapon();
	self thread TacticalInsertion();
	self thread ThrowingKnife();
	
}

InfectedHUDD()
{
	
	//if(!isDefined(self.HUD_boucherie))
		//self.HUD_boucherie = self createRectangle("BOTTOM RIGHT", "BOTTOM RIGHT", -10 + self.AIO["safeArea_X"], -10 + self.AIO["safeArea_Y"]*-1, 40, 40, (1,1,1), "killiconmelee", 1, 1);
	//else
		//self.HUD_boucherie.alpha = 1;
}

QuandTuMeurs(option)
{
	self endon("disconnect");
	self endon("isInfected");
	level endon("game_ended");
	
	if(!isDefined(option)) 
	{
		while(level.infected_game_state != "playing") wait 1;
		
		self waittill("death");
		
		thread MultiExe("Allies",self,self,"Got Infected","e");
		thread MultiExe("Axis",self,self,"Got Infected","f");
	
	}
	
	self.isInfected = true;	
		
}
HUUUD()
{
	
	while(1)
	{
		self waittill_any("REFRESH_HUDS","destroy_all_huds");
	
		if(level.gameEnded)
		{
			if(isDefined(self.HUD_boucherie)) self.HUD_boucherie AdvancedDestroy(self);
			if(isDefined(self.HUD["INF"]["COUNTDOWN"])) self.HUD["INF"]["COUNTDOWN"] AdvancedDestroy(self);
			if(isDefined(self.HUD["INF"]["PERK1"])) self.HUD["INF"]["PERK1"] AdvancedDestroy(self);
			if(isDefined(self.HUD["INF"]["PERK2"])) self.HUD["INF"]["PERK2"] AdvancedDestroy(self);
			if(isDefined(self.HUD["INF"]["PERK3"])) self.HUD["INF"]["PERK3"] AdvancedDestroy(self);
			if(isDefined(self.HUD["INF"]["PERK4"])) self.HUD["INF"]["PERK4"] AdvancedDestroy(self);
			if(isDefined(self.HUD["STATS"]["Infected_kills"])) self.HUD["STATS"]["Infected_kills"] AdvancedDestroy(self);
			if(isDefined(self.HUD["STATS"]["Survivors_kills"])) self.HUD["STATS"]["Survivors_kills"] AdvancedDestroy(self);
			if(isDefined(self.HUD["STATS"]["Surv_with_Tknife"])) self.HUD["STATS"]["Surv_with_Tknife"] AdvancedDestroy(self);

		}
		else
		{
			if(isDefined(self.HUD_boucherie)) self.HUD_boucherie setPoint("BOTTOM RIGHT", "BOTTOM RIGHT", -10 + self.AIO["safeArea_X"]*-1, -10 + self.AIO["safeArea_Y"]*-1);
			if(isDefined(self.HUD["INF"]["COUNTDOWN"])) self.HUD["INF"]["COUNTDOWN"] setPoint("TOP LEFT", "TOP LEFT", 120 , 5);
			if(isDefined(self.HUD["INF"]["PERK1"])) self.HUD["INF"]["PERK1"] setPoint("BOTTOM RIGHT", "BOTTOM RIGHT", -10 + self.AIO["safeArea_X"]*-1, -40 + self.AIO["safeArea_Y"]*-1);
			if(isDefined(self.HUD["INF"]["PERK2"])) self.HUD["INF"]["PERK2"] setPoint("BOTTOM RIGHT", "BOTTOM RIGHT", -10 + self.AIO["safeArea_X"]*-1, -60 + self.AIO["safeArea_Y"]*-1);
			if(isDefined(self.HUD["INF"]["PERK3"])) self.HUD["INF"]["PERK3"] setPoint("BOTTOM RIGHT", "BOTTOM RIGHT", -10 + self.AIO["safeArea_X"]*-1, -80 + self.AIO["safeArea_Y"]*-1);
			if(isDefined(self.HUD["INF"]["PERK4"])) self.HUD["INF"]["PERK4"] setPoint("BOTTOM RIGHT", "BOTTOM RIGHT", -10 + self.AIO["safeArea_X"]*-1, -105 + self.AIO["safeArea_Y"]*-1);		
			if(isDefined(self.HUD["STATS"]["Infected_kills"])) self.HUD["STATS"]["Infected_kills"] setPoint("LEFT", "LEFT",  0 + self.AIO["safeArea_X"], -60);
			if(isDefined(self.HUD["STATS"]["Survivors_kills"])) self.HUD["STATS"]["Survivors_kills"] setPoint("LEFT", "LEFT",  0 + self.AIO["safeArea_X"], -43);
			if(isDefined(self.HUD["STATS"]["Surv_with_Tknife"])) self.HUD["STATS"]["Surv_with_Tknife"] setPoint("LEFT", "LEFT",  0 + self.AIO["safeArea_X"], -26);
		}
	}
}
SurvivorSetup()
{
	self endon("disconnect");
	level endon("game_ended");
	
	self waittill("spawned_player");
	
	self setClientDvar( "cg_everyoneHearsEveryone", "1" );
	
	while(level.inPrematchPeriod) wait .05;
	
	self thread QuandTuMeurs();
	
	self.HUD["INF"]["PERK1"] = self createRectangle("BOTTOM RIGHT", "BOTTOM RIGHT", -10 + self.AIO["safeArea_X"]*-1, -40 + self.AIO["safeArea_Y"]*-1, 20, 20, (1,1,1), "specialty_null", 2, 1);
	self.HUD["INF"]["PERK2"] = self createRectangle("BOTTOM RIGHT", "BOTTOM RIGHT", -10 + self.AIO["safeArea_X"]*-1, -60 + self.AIO["safeArea_Y"]*-1, 20, 20, (1,1,1), "specialty_null", 2, 1);
	self.HUD["INF"]["PERK3"] = self createRectangle("BOTTOM RIGHT", "BOTTOM RIGHT", -10 + self.AIO["safeArea_X"]*-1, -80 + self.AIO["safeArea_Y"]*-1, 20, 20, (1,1,1), "specialty_null", 2, 1);
	self.HUD["INF"]["PERK4"] = self createRectangle("BOTTOM RIGHT", "BOTTOM RIGHT", -10 + self.AIO["safeArea_X"]*-1, -105 + self.AIO["safeArea_Y"]*-1, 15, 15, (1,1,1), "", 2, 1);
	
	
	
	if(isDefined(level.infected_countdown))
	{
		self.HUD["INF"]["COUNTDOWN"] = self createText("objective", 1.5, "TOP LEFT", "TOP LEFT", 120 , 5 , 2, 1, (1,1,1));
		self.HUD["INF"]["COUNTDOWN"].label = &"Infection countdown: 0:0&&1";
		self.HUD["INF"]["COUNTDOWN"] setValue(level.infected_countdown);
	}
	
	while(isDefined(level.infected_countdown))
	{
		if(isDefined(self.HUD["INF"]["COUNTDOWN"])) self.HUD["INF"]["COUNTDOWN"] setValue(level.infected_countdown);
		wait .1;
	}
	
	if(isDefined(self.HUD["INF"]["COUNTDOWN"])) self.HUD["INF"]["COUNTDOWN"] AdvancedDestroy(self);
	
	self thread HUUUD();
	
	
}

giveXperk()
{
	self endon("disconnect");
	level endon("game_ended");
	
	self.Xstreak++;
	
	icon = "";
	perkname = "";
	
	
	if(self.Xstreak == 2)
	{
		self SetPerk("specialty_fastreload");
		self.HUD["INF"]["PERK1"] setShader("specialty_fastreload",20,20);
		icon = "specialty_fastreload";
		perkname = "SLEIGHT OF HAND";
	}
	else if(self.Xstreak == 4)
	{
		self SetPerk("specialty_bulletdamage");
		self.HUD["INF"]["PERK2"] setShader("specialty_bulletdamage",20,20);
		icon = "specialty_bulletdamage";
		perkname = "STOPPING POWER";
	}
	else if(self.Xstreak == 6)
	{
		self SetPerk("specialty_bulletpenetration");
		self.HUD["INF"]["PERK3"] setShader("specialty_bulletpenetration",20,20);
		icon = "specialty_bulletpenetration";
		perkname = "DEEP IMPACT";
	}
	else if(self.Xstreak == 8)
	{
		self SetPerk("specialty_bulletaccuracy");
		self.HUD["INF"]["PERK4"] setShader("ui_host",20,20);
		icon = "ui_host";
		perkname = "ALL PERKS";
		
		self SetPerk("specialty_bulletaccuracy");
		self SetPerk("specialty_rof");
		self SetPerk("specialty_explosivedamage");
		self SetPerk("specialty_longersprint");
		self SetPerk("specialty_quieter");
	}
	else return;
	
	self notify("newPerkNotify");
	self endon("newPerkNotify");
	
	if(isDefined(self.HUD["INF"]["NOTIFY_PERK"])) self.HUD["INF"]["NOTIFY_PERK"] advanceddestroy(self);
	if(isDefined(self.HUD["INF"]["NOTIFY_PERK_T"])) self.HUD["INF"]["NOTIFY_PERK_T"] advanceddestroy(self);
	if(isDefined(self.HUD["INF"]["NOTIFY_PERK_T2"])) self.HUD["INF"]["NOTIFY_PERK_T2"] advanceddestroy(self);
	
	
	if(!isDefined(self.HUD["INF"]["NOTIFY_PERK"])) self.HUD["INF"]["NOTIFY_PERK"] = self createRectangle("TOP", "TOP", 0, 50, 30, 30, (1,1,1), icon, 2, 1);
	else self.HUD["INF"]["NOTIFY_PERK"] setShader(icon,30,30);
	
	if(!isDefined(self.HUD["INF"]["NOTIFY_PERK_T"]) && icon != "") self.HUD["INF"]["NOTIFY_PERK_T"] = self createText("objective", 1.4, "TOP", "TOP", 0, 80, 2, 1, (1,1,1), perkname,(0.3, 0.6, 0.3),1);	
	else self.HUD["INF"]["NOTIFY_PERK_T"] setText(perkname);
	
	if(!isDefined(self.HUD["INF"]["NOTIFY_PERK_T2"]) && icon != "") self.HUD["INF"]["NOTIFY_PERK_T2"] = self createText("default", 1.4, "TOP", "TOP", 0, 95, 2, 1, (1,1,1), self.Xstreak +" Point streak!");
	else self.HUD["INF"]["NOTIFY_PERK_T2"] setText(self.Xstreak +" Point streak!");
	
	wait 1;
	
	if(isDefined(self.HUD["INF"]["NOTIFY_PERK"])) self.HUD["INF"]["NOTIFY_PERK"] elemFade(3,0);
	if(isDefined(self.HUD["INF"]["NOTIFY_PERK_T"])) self.HUD["INF"]["NOTIFY_PERK_T"] elemFade(3,0);
	if(isDefined(self.HUD["INF"]["NOTIFY_PERK_T2"])) self.HUD["INF"]["NOTIFY_PERK_T2"] elemFade(3,0);
	
	wait 3;
	
	if(isDefined(self.HUD["INF"]["NOTIFY_PERK"])) self.HUD["INF"]["NOTIFY_PERK"] advanceddestroy(self);
	if(isDefined(self.HUD["INF"]["NOTIFY_PERK_T"])) self.HUD["INF"]["NOTIFY_PERK_T"] advanceddestroy(self);
	if(isDefined(self.HUD["INF"]["NOTIFY_PERK_T2"])) self.HUD["INF"]["NOTIFY_PERK_T2"] advanceddestroy(self);
	
	
}



StartInfected()
{
	level endon("game_ended");
	
	level.PrimaryInfectedWeapon = level.Infected_primary_weapons[randomInt(level.Infected_primary_weapons.size)];
	level.SecondaryInfectedWeapon = level.Infected_secondary_weapons[randomInt(level.Infected_secondary_weapons.size)];
	
	wait 2;
	level thread DoInfected();
}


DoInfected()
{
	level endon("game_ended");
	
	FirstInfected = getdvar("F_I");
	level.infected_countdown = 8;
	
	while(level.inPrematchPeriod) wait .05;
	
	for(;level.infected_countdown>0;level.infected_countdown--)
		wait 1;
	
	Infected = randomInt(level.players.size);
	
	if(level.players.size > 1)
	{
		while(level.players[Infected].name == FirstInfected)
			Infected = randomInt(level.players.size);
	}
	
	thread MultiExe("Allies",level.players[Infected],level.players[Infected],"First Infected","e");
	thread MultiExe("Axis",level.players[Infected],level.players[Infected],"First Infected","f");
	
	level.infected_game_state = "playing";
	level.infected_countdown = undefined;
	
	level.players[Infected] notify("isInfected");
	level.players[Infected].isInfected = true;
	level.players[Infected] QuandTuMeurs(1);	
	level.players[Infected] thread maps\mp\gametypes\_globallogic::menuAxis(1);
	
	setDvar("F_I",level.players[Infected].name);
	
	level thread doPlaying();
}

doPlaying()
{	
	level endon("game_ended");
	
	//if(isDefined(level.HUD["ZLV3"]["TIMER"])) level.HUD["ZLV3"]["TIMER"] destroy();
	
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
						thread MultiExe("Allies",level.players[i],level.players[i],"Last Survivor","f");
						thread MultiExe("Axis",level.players[i],level.players[i],"Last Survivor","e");
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
	level.infected_game_state = "ending";
	
	
	wait 2;
	
	if(level.playersLeft["allies"] == 0)
	{	
		thread maps\mp\gametypes\_globallogic::endGame( "axis", "Survivors infected" );

	}
	
	if(level.playersLeft["axis"] == 0)
	{
		FirstInfected = getdvar("F_I");
		Infected = randomInt(level.players.size);
	
		if(level.players.size > 1)
		{
			while(level.players[Infected].name == FirstInfected)
				Infected = randomInt(level.players.size);
		}
		
		thread MultiExe("Allies",level.players[Infected],level.players[Infected],"First Infected","e");
		thread MultiExe("Axis",level.players[Infected],level.players[Infected],"First Infected","f");
		
		level.infected_game_state = "playing";
		level.infected_countdown = undefined;
		
		level.players[Infected] notify("isInfected");
		level.players[Infected].isInfected = true;
		level.players[Infected] QuandTuMeurs(1);	
		level.players[Infected] thread maps\mp\gametypes\_globallogic::menuAxis(1);
		
		setDvar("F_I",level.players[Infected].name);
		
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
		self.HUD["KS"]["NOTIFY_NAME"] = self createFontString("objective",1.5);
	
	if(isDefined(self.HUD["KS"]["NOTIFY_NAME"]))
	{
		self.HUD["KS"]["NOTIFY_NAME"] setPoint("RIGHT","RIGHT",0 + self.AIO["safeArea_X"]*-1,-120);
		self.HUD["KS"]["NOTIFY_NAME"] setText(getName(user));
		self.HUD["KS"]["NOTIFY_NAME"].color = color;
		self.HUD["KS"]["NOTIFY_NAME"] thread DestroyInstantly();
	}	
	
	if(!isDefined(self.HUD["KS"]["NOTIFY_TITLE"]))
		self.HUD["KS"]["NOTIFY_TITLE"] = self createFontString("objective",1.5);

	if(isDefined(self.HUD["KS"]["NOTIFY_TITLE"])) 
	{
		self.HUD["KS"]["NOTIFY_TITLE"] setPoint("RIGHT","RIGHT",0 + self.AIO["safeArea_X"]*-1,-100);
		self.HUD["KS"]["NOTIFY_TITLE"] setText(ks + "!");
		self.HUD["KS"]["NOTIFY_TITLE"] thread DestroyInstantly();
		self.HUD["KS"]["NOTIFY_TITLE"] transitionFadeIn(.1);
	}
	
	if(!self.waitPlace) wait 4;
	else wait 2;
	
	//NOTIFY_NAME transitionSlideOut(1,"left");
	//NOTIFY_TITLE transitionSlideOut(1,"left");
	
	//wait 1;
	
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





ResetTacticalInsertion()
{
	self SetOrigin(self.TacticalInsertion); 
	self setplayerangles(self.InsertionAngles);
	self playSound("oldschool_return");
	//self notify("DENIED");
	wait .5;
	self.InsertionFX Delete();
	self.TacticalInsertionModel Delete();
	self.InsertionModelFX Delete();
	self.TacticalInsertion = undefined;
}
TacticalInsertion()
{
	self endon("DENIED");
	self endon("death");
	self endon("disconnect");
	level endon("game_ended");
	
	for(;;)
	{
		wait .05;
		
		if(self fragbuttonpressed() && !self.IN_MENU["AREA_EDITOR"])
		{
			if(self isOnground())
			{
				self setLowerMessage("Posing Tactical Insertion...");
				InsertionOrigin = self.origin;
				self.InsertionAngles = self getplayerangles();
				
				wait 2;
				self setLowerMessage("Tactical Insertion placed");
				self.TacticalInsertion = InsertionOrigin;
				
				self.InsertionFX = SpawnFx(level.flagBase_red, InsertionOrigin);
				TriggerFX(self.InsertionFX);
				
				self thread InsertionOnDisconnect();
				
				self.TacticalInsertionModel = spawn("script_model", InsertionOrigin);
				self.TacticalInsertionModel setModel("weapon_c4_mp");
				
				self.TacticalInsertionModel thread InsertionAttacked(self);
				
				self.InsertionModelFX = SpawnFx(level.c4_light,(InsertionOrigin +(0,0,10)));
				TriggerFX(self.InsertionModelFX);
				
				self playlocalSound("mp_ingame_summary");
				self clearLowerMessage(2);
				
				self iprintlnbold("\n\n\n\n\n\n");
				
				self thread TacticalText(InsertionOrigin);
				break;
			}
			else
			{
				//iprintln("^2cant place here");
				self iprintlnbold("^1Can't place here");
				//self clearLowerMessage(3);
				
			}
		}
	}
	
	wait .1;
	
	while(isDefined(self.TacticalInsertion))
	{
		Rayon = distance(InsertionOrigin, self.origin);
		
		if(Rayon < 75)
		{
			self setLowerMessage("Press [{+usereload}] to pick up Tactical Insertion");
			//self iprintlnbold("Press [{+usereload}] to pick up Tactical Insertion");
			
			if(self UseButtonPressed()) 
			{
				wait .1;
				if(self UseButtonPressed())
				{
					self clearLowerMessage(1);
					self thread TakeTacticalInsertion();
				}
			}
		}
		else 
			self clearLowerMessage(1);
		
		wait .05;
	}
}	
TacticalText(InsertionOrigin)
{
	self endon("DENIED");
	self endon("death");
	self endon("disconnect");
	level endon("game_ended");
	
	team = self.team;
	otherteam = "axis";
	if(team == "axis") otherteam = "allies";
				
	for(;;)
	{
		for(i = 0;i < level.players.size;i++)
		{
			Player = level.players[i];
			
			if((Player.team == team) && (Player.name != self.name))
				continue;
				
			Rayon = distance(InsertionOrigin, Player.origin);
			
			if(Rayon < 75 && Player.name != self.name)
			{
				Player setLowerMessage("Press [{+usereload}] to smash Tactical Insertion");
				
				if(Player UseButtonPressed()) 
				{
					wait .1;
					if(Player UseButtonPressed())
					{
						Player clearLowerMessage(1);
						self thread RemoveInsertion(Player);
					}
				}
			}
			else 
				Player clearLowerMessage(1);
		}
		wait .01;
	}
}

RemoveInsertion(player)
{
	if(isDefined(player))
	{
		player PlayLocalSound("mp_war_objective_taken");
		player thread CallLowerText("^1DENIED!\n^3You Destroyed An Enemy Tactical Insertion!",3);
		self iprintln("^1" + getName(player) + " ^3destroyed your Tactical Insertion");
	}
	
	self.InsertionFX Delete();
	self.TacticalInsertionModel Delete();
	self.InsertionModelFX Delete();
	self.TacticalInsertion = undefined;
	self notify("DENIED");
	self PlayLocalSound("mp_war_objective_lost");
	self thread CallLowerText("^1Your Tactical Insertion has been destroyed",3);
}
TakeTacticalInsertion()
{
	self.InsertionFX Delete();
	self.TacticalInsertionModel Delete();
	self.InsertionModelFX Delete();
	self.TacticalInsertion = undefined;
	self notify("DENIED");
	self playlocalsound("oldschool_pickup");
	self thread TacticalInsertion();
}
InsertionOnDisconnect()
{
	self endon("DENIED");
	self endon("death");
	
	self waittill("disconnect");
	
	self.InsertionFX Delete();
	self.TacticalInsertionModel Delete();
	self.InsertionModelFX Delete();
	self.TacticalInsertion = undefined;
	self notify("DENIED");
}
InsertionAttacked(player)
{
	 
}


ThrowingKnife()
{
	self endon("disconnect");
	self endon("KillKnife");
	level endon("game_ended");
	self endon("death");
	
	wait 1;
	
	
	self iPrintlnBold( "Press [{+smoke}] to throw knife" );	
	
	self SetOffhandSecondaryClass("flash");
	self giveWeapon("flash_grenade_mp");
	self setWeaponAmmoClip("flash_grenade_mp", 1);
	self SwitchToOffhand("flash_grenade_mp");
							
	self waittill( "grenade_fire", grenadeWeapon );
	
	
	if(grenadeWeapon == "flash_grenade_mp")
	{
		self thread deletegreondeath(grenadeWeapon);
		self.HUD_boucherie.alpha = 0;
		
		grenadeWeapon delete();
		
		if(self getstance() == "stand")
			pos = (0,0,20); 
		else if(self getstance() == "crouch")
			pos = (0,0,0);
		else
			pos = (0,0,-30);
		
		trace = bullettrace(self geteye() + pos,self geteye() + vector_scale( anglestoforward(self getplayerangles()), 500000 ) + pos, true, self );
		Knife = spawn("script_model", self.origin);
		Knife.origin = self geteye() + pos;
		Knife.angles = self.angles;
		Knife setmodel("weapon_parabolic_knife");
		Knife thread KnifeSpin(self);
		time = Distratios(distance(Knife.origin,trace["position"]));
		
		Knife moveto(trace["position"],time);
		Knife.startangle = self.angles;
		self.hasEquipment = false;
		
		while(Knife.origin != trace["position"])
		{
			wait 0.75;
			tracez = bullettrace( Knife.origin, Knife.origin + vector_scale( anglestoforward( Knife.startangle ), 45 ), true, Knife );
			
			if(isDefined(tracez["entity"]) && isplayer( tracez["entity"] ) && isAlive( tracez["entity"]) && tracez["entity"].team != self.team) 
			{
				tracez["entity"] [[level.callbackPlayerDamage]]( self, self, tracez["entity"].health, level.iDFLAGS_NO_KNOCKBACK, "MOD_MELEE", "m16_mp", (0,0,0), (0,0,0), "torso_lower", 0 );
				self.Surv_with_Tknife++;
				self.HUD["STATS"]["Surv_with_Tknife"] setValue(self.Surv_with_Tknife);
			}
		}
		
		
		Knife delete();
		Knife notify("KillKnife");
	}
}
deletegreondeath(grenadeWeapon)
{
	if(isDefined(grenadeWeapon)) grenadeWeapon delete();
}
KnifeSpin(player)
{
	self endon("KillKnife");
	level endon("game_ended");
	player endon("disconnect");
	
	for(;;)
	{
		if(!isDefined(self))
			self delete();
		
		self rotatepitch(180, 0.20);
		wait 0.35;
	}
}
Distratios(dist)
{
	time = dist / 3000;
	return time;
}
 


