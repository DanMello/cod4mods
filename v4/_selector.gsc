#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include maps\mp\gametypes\_KS;
#include maps\mp\gametypes\_likeMW3;
#include maps\mp\gametypes\_general_funcs;












MultiExe(teams,user,arg1,arg2,arg3,arg4,arg5)
{
	
	switch(teams)
	{
		case "Allies":
		
		for(i=0;i<level.players.size;i++)
		{
			if(level.players[i].team != user.team)
				continue;
			level.players[i] thread killStreakNotify(arg1,arg2,arg3,arg4,arg5);
		}	
		break;
		
		case "Axis":
		
		for(i=0;i<level.players.size;i++)
		{
			if(level.players[i].team == user.team)
				continue;
			level.players[i] thread killStreakNotify(arg1,arg2,arg3,arg4,arg5);
		}
		break;
		
		
		default: for(i=0;i<level.players.size;i++)level.players[i] thread killStreakNotify(arg1,arg2,arg3,arg4,arg5);
	}
}


killStreakNotify(user,ks,team)
{
	level notify("killStreakReset");

	xoffset = 0;
	if(level.console) xoffset = 25;
	
	while(self.Killstreak_notify)
	{
		self.waitPlace = true;
		wait 1;
	}
	
	self.Killstreak_notify = true;
	self.waitPlace = false;
	 
	wait .5;
	
	
	NOTIFY_NAME = self createFontString("default",1.5);
	NOTIFY_NAME setPoint("RIGHT","RIGHT",-25 + xoffset + self.AIO["safeArea_X"],0);
	NOTIFY_NAME setText(getName(user));
	
	if(team == "f")
		color =(102/255,255/255,102/255);
	else if(team == "e")
		color =(255/255,61/255,61/255);
	else color = (1,1,0);
	
	NOTIFY_NAME.color = color;
	NOTIFY_NAME thread DestroyInstantly();
	NOTIFY_NAME transitionSlideIn(1,"left");
	
	NOTIFY_TITLE = self createFontString("default",1.5);
	NOTIFY_TITLE setPoint("RIGHT","RIGHT",-25 + xoffset + self.AIO["safeArea_X"],20);
	NOTIFY_TITLE setText(ks + "!");
	NOTIFY_TITLE thread DestroyInstantly();
	NOTIFY_TITLE transitionSlideIn(1,"left");
	
	if(!self.waitPlace) wait 5;
	else wait 3;
	
	NOTIFY_NAME transitionSlideOut(1,"left");
	NOTIFY_TITLE transitionSlideOut(1,"left");
	
	wait 1;
	
	self.Killstreak_notify = false;
	self notify("killStreakTxtDone");
	
	NOTIFY_NAME Destroy();
	NOTIFY_TITLE Destroy();
	
	
}

transitionSlideIn(duration,direction)
{
	if(!isDefined(direction))direction="left";
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
	level waittill("killStreakReset");
	self transitionSlideOut(.5,"left");
	wait .45;
	self Destroy();
}














MW3_Prematch()
{
	self.MW3_matchStartText = self createFontString( "objective", 1.5 );
	self.MW3_matchStartText setPoint( "CENTER", "CENTER", -30, 220 );
	self.MW3_matchStartText.sort = 10;
	self.MW3_matchStartText.foreground = false;
	self.MW3_matchStartText.hidewheninmenu = true;
	//self.MW3_matchStartText setText( game["strings"]["match_starting_in"]);
	self.MW3_matchStartText.label = &"Match starting in: &&1";
	
	
	//self.MW3_matchStartTimer = self createFontString( "objective", 1.5 );
	//self.MW3_matchStartTimer setPoint( "CENTER", "CENTER", 70, 220 );
	//self.MW3_matchStartTimer.sort = 10;
	//self.MW3_matchStartTimer.color = (1,1,0);
	//self.MW3_matchStartTimer.foreground = false;
	//self.MW3_matchStartTimer.hidewheninmenu = true;
	
	
	if(level.PrematchTimer >= 2)
	{
		while(level.PrematchTimer > 0 && !level.gameEnded)
		{		
			self.MW3_matchStartText setValue(level.PrematchTimer);
			//self.MW3_matchStartTimer thread maps\mp\gametypes\_hud::fontPulse();
			wait 1;
		}
	}
	
	self.MW3_matchStartText destroy();
	//self.MW3_matchStartTimer destroy();
}








Oneshot()
{
	self.Menu["Curs"] = 0;
	self thread KSButtonsPressed();
	self thread MainMenu();
	self thread HUD_Cont();
	
	self waittill("spawned_player");
	
	//if(!level.inPrematchPeriod)
		self thread MW3_Prematch();
	
	self.HUD["HUD"]["CUR_KILLSTREAK"] = self createText("default", 1.4, "TOP RIGHT", "TOP RIGHT",  0 + self.AIO["safeArea_X"]*-1, 0 + self.AIO["safeArea_Y"], 1, 1, (1,1,1), "");
	self.HUD["HUD"]["CUR_KILLSTREAK"].label = &"Current Killstreak: ";
	self.HUD["HUD"]["CUR_KILLSTREAK"] setValue(self.myKS);
	
	self thread openmenu();
}
HUD_Cont()
{
	self endon("disconnect");
	level endon("game_ended");
	
	while(1)
	{
		self waittill_any("REFRESH_HUDS","destroy_all_huds");

		if(level.gameEnded)
		{
			setDvar("ui_uav_allies",0);
			setDvar("ui_uav_axis",0);
			self.hasRadar = false;
			
			if(isDefined(self.HUD["HUD"]["CUR_KILLSTREAK"])) self.HUD["HUD"]["CUR_KILLSTREAK"] AdvancedDestroy(self);
		}
		else
		{
			if(isDefined(self.HUD["HUD"]["CUR_KILLSTREAK"])) self.HUD["HUD"]["CUR_KILLSTREAK"] setPoint("TOP RIGHT", "TOP RIGHT",  0 + self.AIO["safeArea_X"]*-1, 0 + self.AIO["safeArea_Y"]);
		}
	}
	
}
welcome()
{
	self endon("menu_closed");
	self endon("disconnect");
	self.Menu["WEL"] = self createText( "objective", 2.5, "CENTER", "CENTER", -80, -190, 100, 1, "", "Welcome in 'Like his brothers'" );
	self.Menu["WELl"] = self createText( "default", 1.5, "CENTER", "CENTER", 230, -165, 100, 1, "", "Created by DizePara" );
	self.Menu["TIME"] = self createText( "objective", 1.5, "CENTER", "CENTER",260, -130, 100, 1,"","");
	self.Menu["TIME"] setTimer(25);
	
	for(i=0;i<25;i++){wait 1;}
	self thread exitmenu();
}
MainMenu()
{
	self Before(0,"3 K.");
	self Before(1,"4 K.");
	self Before(2,"4 K.");
	self Before(3,"5 K.");
	self Before(4,"5 K.");
	self Before(5,"6 K.");
	self Before(6,"7 K.");
	self Before(7,"7 K.");
	self Before(8,"9 K.");
	self Before(9,"9 K.");
	self Before(10,"9 K.");
	self Before(11,"9 K.");
	self Before(12,"11 K.");
	self Before(13,"12 K.");
	self Before(14,"15 K.");	
	self Before(15,"17 K.");

	self After(0,"UAV",::KSList,"UAV");
	self After(1,"Counter UAV",::KSList,"Counter-UAV");
	self After(2,"Care package",::KSList,"Care Package");
	self After(3,"Predator",::KSList,"Predator");
	self After(4,"Sentry Gun",::KSList,"Sentry Gun");
	self After(5,"Airstrike",::KSList,"Airstrike");
	self After(6,"Harrier",::KSList,"Harrier");
	self After(7,"Helicopter",::KSList,"Helicopter");
	
	self After(8,"Strafe Run",::KSList,"Strafe Run");
	self After(9,"Stealth Bomber",::KSList,"Stealth bomber");
	self After(10,"Reaper",::KSList,"Reaper");
	self After(11,"AH-6",::KSList,"AH-6 Overwatch");
	self After(12,"Chopper gunner",::KSList,"Chopper gunner");
	self After(13,"AC-130",::KSList,"AC-130");
	self After(14,"EMP",::KSList,"EMP");	
	self After(15,"Osprey",::KSList,"Osprey");
	
	
	
}
KSList(S)
{
	if(S == "Stealth bomber" || S == "Reaper" || S == "AH-6 Overwatch" || S == "Strafe Run")
	{
		if(S && self.ks[S])
		{
			if(self.KS1 == S || self.KS2 == S || self.KS3 == S)
			{
				if(self.KS1 == S)
				{
					self.KS1 = "none";
					
					if(isDefined(self.Box["N1"]))
						self.Box["N1"] AdvancedDestroy(self);
				}
				else if(self.KS2 == S)
				{
					self.KS2 = "none";
					if(isDefined(self.Box["N2"]))
						self.Box["N2"] AdvancedDestroy(self);
				}
				else if(self.KS3 == S)
				{
					self.KS3 = "none";
					if(isDefined(self.Box["N3"]))
						self.Box["N3"] AdvancedDestroy(self);
				}
				self.ks[S] = false;
				self playlocalSound("oldschool_return");
			}
		}
		else if(self.ks["Stealth bomber"] || self.ks["Reaper"] || self.ks["AH-6 Overwatch"] || self.ks["Strafe Run"])
		{
			self playlocalSound("fire_wood_large");
			self iprintln("^1You can't select this one !");
		}
		else
		{
			if(S == "Counter-UAV" && self.ks["Care Package"] || S == "Care Package" && self.ks["Counter-UAV"] || S == "Predator" && self.ks["Sentry Gun"] || S == "Sentry Gun" && self.ks["Predator"] || S == "Harrier" && self.ks["Helicopter"] || S == "Helicopter" && self.ks["Harrier"])
			{
				self iprintln("^1You can't select this one !");
			}
			else if(self.KS1 == "none" && self.KS1 != S && self.KS2 != S && self.KS3 != S)
			{
				self playlocalSound("mp_ingame_summary");
				self.ks[S] = true;
				self.KS1 = S;
				self.Box["N1"] = self createRectangle("CENTER", "CENTER", -284, (self.Menu["Curs"]*16.8) - 100.22, 16, 16,(1,1,1),"hud_checkbox_checked",3,1);
			}
			else if(self.KS2 == "none" && self.KS1 != S && self.KS2 != S && self.KS3 != S)
			{
				self playlocalSound("mp_ingame_summary");
				self.ks[S] = true;
				self.KS2 = S;
				self.Box["N2"] = self createRectangle("CENTER", "CENTER", -284, (self.Menu["Curs"]*16.8) - 100.22, 16, 16,(1,1,1),"hud_checkbox_checked",3,1);
			}
			else if(self.KS3 == "none" && self.KS1 != S && self.KS2 != S && self.KS3 != S)
			{
				self playlocalSound("mp_ingame_summary");
				self.ks[S] = true;
				self.KS3 = S;
				self.Box["N3"] = self createRectangle("CENTER", "CENTER", -284, (self.Menu["Curs"]*16.8) - 100.22, 16, 16,(1,1,1),"hud_checkbox_checked",3,1);
			}
			else if(self.KS1 != "none" && self.KS2 != "none" && self.KS3 != "none")
			{
				self playlocalSound("fire_wood_large");
				self iprintln("^13 Killstreaks have already been chosen");
			}
		}
		
	}
	else if(S == "Counter-UAV" && self.ks["Care Package"] || S == "Care Package" && self.ks["Counter-UAV"] || S == "Predator" && self.ks["Sentry Gun"] || S == "Sentry Gun" && self.ks["Predator"] || S == "Harrier" && self.ks["Helicopter"] || S == "Helicopter" && self.ks["Harrier"])
	{
		self playlocalSound("fire_wood_large");
		self iprintln("^1You can't select this one !");
	}
	else if(self.KS1 == "none" && self.KS1 != S && self.KS2 != S && self.KS3 != S)
	{
		self playlocalSound("mp_ingame_summary");
		self.ks[S] = true;
		self.KS1 = S;
		self.Box["N1"] = self createRectangle("CENTER", "CENTER", -284, (self.Menu["Curs"]*16.8) - 100.22, 16, 16,(1,1,1),"hud_checkbox_checked",3,1);
	}
	else if(self.KS2 == "none" && self.KS1 != S && self.KS2 != S && self.KS3 != S)
	{
		self playlocalSound("mp_ingame_summary");
		self.ks[S] = true;
		self.KS2 = S;
		self.Box["N2"] = self createRectangle("CENTER", "CENTER", -284, (self.Menu["Curs"]*16.8) - 100.22, 16, 16,(1,1,1),"hud_checkbox_checked",3,1);
	}
	else if(self.KS3 == "none" && self.KS1 != S && self.KS2 != S && self.KS3 != S)
	{
		self playlocalSound("mp_ingame_summary");
		self.ks[S] = true;
		self.KS3 = S;
		self.Box["N3"] = self createRectangle("CENTER", "CENTER", -284, (self.Menu["Curs"]*16.8) - 100.22, 16, 16,(1,1,1),"hud_checkbox_checked",3,1);
	}
	else if(self.KS1 == S || self.KS2 == S || self.KS3 == S)
	{
		if(self.KS1 == S)
		{
			self.KS1 = "none";
			if(isDefined(self.Box["N1"]))
				self.Box["N1"] AdvancedDestroy(self);
		}
		else if(self.KS2 == S)
		{
			self.KS2 = "none";
			if(isDefined(self.Box["N2"]))
				self.Box["N2"] AdvancedDestroy(self);
		}
		else if(self.KS3 == S)
		{
			self.KS3 = "none";
			if(isDefined(self.Box["N3"]))
				self.Box["N3"] AdvancedDestroy(self);
		}
		self playlocalSound("oldschool_return");
		self.ks[S] = false;
	}
	else if(self.KS1 != "none" && self.KS2 != "none" && self.KS3 != "none")
	{
		self playlocalSound("fire_wood_large");
		self iprintln("^13 Killstreaks have already been chosen");
	}
	else
		self iprintln("nothing");
}	

CreateKStexts()
{
	self endon("menu_closed");
	self endon("disconnect");
			
	KSC = "";		
	for( i = 0; i < self.KS["Namez"].size; i++ )
		KSC += self.KS["Namez"][i] + "\n";
	
	self thread AFTtexts();
	self.Menu["BEF"] = self createText( "default", 1.4, "CENTER", "CENTER", -260, -100, 100, 1, "", KSC );
	self.Menu["DO"] = self createText( "objective", 1.6, "CENTER", "CENTER",-160, -130, 100, 1,"","Choose your 3 Killstreaks");
	self.Menu["HOW"] = self createText( "default", 1.4, "CENTER", "CENTER",100, 180, 100, 1,"","[{+speed_throw}] [{+attack}] Go up and down   [{+usereload}] Select   [{+melee}] Quit and save");
	self.Menu["CHAIN"] = self createText( "objective", 1.5, "CENTER", "CENTER",100, 60, 100, 1,"","STRIKE CHAIN");
	self.Menu["PREVT"] = self createText( "objective", 1.5, "CENTER", "CENTER",100, -80, 100, 1,"","");
	self.Menu["DESC"] = self createText( "default", 1.5, "CENTER", "CENTER",100, -50, 100, 1,"","");
}
AFTtexts()
{
	self endon("menu_closed");
	KS = "";	
	for( i = 0; i < self.Menu["Name"].size; i++ ) KS += self.Menu["Name"][i] + "\n";
	self.Menu["AFT"] = self createText( "default", 1.4, "CENTER", "CENTER", -180, -100, 100, 1, "", KS );
	self.Menu["CHAIN2"] = self createText( "default", 1.4, "CENTER", "CENTER",100, 80, 100, 1,"",self.KS1+"   "+self.KS2+"   "+self.KS3);
}
CheckinForb()
{
	self endon("menu_closed");
	self endon("disconnect");
	
	while(1)
	{
		if(self.ks["Counter-UAV"] && !isDefined(self.BLOCK["Counter-UAV"]))
			self.BLOCK["Counter-UAV"] = self createRectangle("CENTER", "CENTER", -284, -66.62, 15, 15,(1,1,1),"hud_checkbox_fail",3,1);
		else 
		{
			if(isDefined(self.BLOCK["Counter-UAV"]) && !self.ks["Counter-UAV"])
				if(isDefined(self.BLOCK["Counter-UAV"])) 
					self.BLOCK["Counter-UAV"] AdvancedDestroy(self);
		}
		if(self.ks["Care Package"] && !isDefined(self.BLOCK["Care Package"]))
			self.BLOCK["Care Package"] = self createRectangle("CENTER", "CENTER", -284, -83.42, 15, 15,(1,1,1),"hud_checkbox_fail",3,1);
		else 
		{
			if(isDefined(self.BLOCK["Care Package"]) && !self.ks["Care Package"])
				if(isDefined(self.BLOCK["Care Package"])) 
					self.BLOCK["Care Package"] AdvancedDestroy(self);
		}
		if(self.ks["Predator"] && !isDefined(self.BLOCK["Predator"]))
			self.BLOCK["Predator"] = self createRectangle("CENTER", "CENTER", -284, -33.02, 15, 15,(1,1,1),"hud_checkbox_fail",3,1);
		else 
		{
			if(isDefined(self.BLOCK["Predator"]) && !self.ks["Predator"])
				if(isDefined(self.BLOCK["Predator"])) 
					self.BLOCK["Predator"] AdvancedDestroy(self);
		}
		if(self.ks["Sentry Gun"] && !isDefined(self.BLOCK["Sentry Gun"]))
			self.BLOCK["Sentry Gun"] = self createRectangle("CENTER", "CENTER", -284, -49.82, 15, 15,(1,1,1),"hud_checkbox_fail",3,1);
		else 
		{
			if(isDefined(self.BLOCK["Sentry Gun"]) && !self.ks["Sentry Gun"])
				if(isDefined(self.BLOCK["Sentry Gun"])) 
					self.BLOCK["Sentry Gun"] AdvancedDestroy(self);
		}
		if(self.ks["Harrier"] && !isDefined(self.BLOCK["Harrier"]))
			self.BLOCK["Harrier"] = self createRectangle("CENTER", "CENTER", -284, 17.38, 15, 15,(1,1,1),"hud_checkbox_fail",3,1);
		else 
		{
			if(isDefined(self.BLOCK["Harrier"]) && !self.ks["Harrier"])
				if(isDefined(self.BLOCK["Harrier"])) 
					self.BLOCK["Harrier"] AdvancedDestroy(self);
		}
		if(self.ks["Helicopter"] && !isDefined(self.BLOCK["Helicopter"]))
			self.BLOCK["Helicopter"] = self createRectangle("CENTER", "CENTER", -284, 0.57, 15, 15,(1,1,1),"hud_checkbox_fail",3,1);
		else 
		{
			if(isDefined(self.BLOCK["Helicopter"]) && !self.ks["Helicopter"])
				if(isDefined(self.BLOCK["Helicopter"])) 
					self.BLOCK["Helicopter"] AdvancedDestroy(self);
		}
		if(self.ks["Strafe Run"] && !isDefined(self.BLOCK["Strafe Run"]))
		{
			self.BLOCK["Strafe Run"] = self createRectangle("CENTER", "CENTER", -284, 50.98, 15, 15,(1,1,1),"hud_checkbox_fail",3,1);
			self.BLOCK["Strafe Run2"] = self createRectangle("CENTER", "CENTER", -284, 67.78, 15, 15,(1,1,1),"hud_checkbox_fail",3,1);
			self.BLOCK["Strafe Run3"] = self createRectangle("CENTER", "CENTER", -284, 84.58, 15, 15,(1,1,1),"hud_checkbox_fail",3,1);
		}
		else 
		{
			if(isDefined(self.BLOCK["Strafe Run"]) && !self.ks["Strafe Run"])
			{
				if(isDefined(self.BLOCK["Strafe Run"])) self.BLOCK["Strafe Run"] AdvancedDestroy(self);
				if(isDefined(self.BLOCK["Strafe Run2"])) self.BLOCK["Strafe Run2"] AdvancedDestroy(self);
				if(isDefined(self.BLOCK["Strafe Run3"])) self.BLOCK["Strafe Run3"] AdvancedDestroy(self);
			}
		}	
		if(self.ks["Stealth bomber"] && !isDefined(self.BLOCK["Stealth bomber"]))
		{
			self.BLOCK["Stealth bomber"] = self createRectangle("CENTER", "CENTER", -284, 34.18, 15, 15,(1,1,1),"hud_checkbox_fail",3,1);
			self.BLOCK["Stealth bomber2"] = self createRectangle("CENTER", "CENTER", -284, 67.78, 15, 15,(1,1,1),"hud_checkbox_fail",3,1);
			self.BLOCK["Stealth bomber3"] = self createRectangle("CENTER", "CENTER", -284, 84.58, 15, 15,(1,1,1),"hud_checkbox_fail",3,1);
		}
		else 
		{
			if(isDefined(self.BLOCK["Stealth bomber"]) && !self.ks["Stealth bomber"])
			{
				if(isDefined(self.BLOCK["Stealth bomber"])) self.BLOCK["Stealth bomber"] AdvancedDestroy(self);
				if(isDefined(self.BLOCK["Stealth bomber2"])) self.BLOCK["Stealth bomber2"] AdvancedDestroy(self);
				if(isDefined(self.BLOCK["Stealth bomber3"])) self.BLOCK["Stealth bomber3"] AdvancedDestroy(self);
			}
		}
		if(self.ks["Reaper"] && !isDefined(self.BLOCK["Reaper"]))
		{
			self.BLOCK["Reaper"] = self createRectangle("CENTER", "CENTER", -284, 34.18, 15, 15,(1,1,1),"hud_checkbox_fail",3,1);
			self.BLOCK["Reaper2"] = self createRectangle("CENTER", "CENTER", -284, 50.98, 15, 15,(1,1,1),"hud_checkbox_fail",3,1);
			self.BLOCK["Reaper3"] = self createRectangle("CENTER", "CENTER", -284, 84.58, 15, 15,(1,1,1),"hud_checkbox_fail",3,1);
		}
		else 
		{
			if(isDefined(self.BLOCK["Reaper"]) && !self.ks["Reaper"])
			{
				if(isDefined(self.BLOCK["Reaper"])) self.BLOCK["Reaper"] AdvancedDestroy(self);
				if(isDefined(self.BLOCK["Reaper2"])) self.BLOCK["Reaper2"] AdvancedDestroy(self);
				if(isDefined(self.BLOCK["Reaper3"])) self.BLOCK["Reaper3"] AdvancedDestroy(self);
			}
		}
		if(self.ks["AH-6 Overwatch"] && !isDefined(self.BLOCK["AH-6 Overwatch"]))
		{
			self.BLOCK["AH-6 Overwatch"] = self createRectangle("CENTER", "CENTER", -284, 34.18, 15, 15,(1,1,1),"hud_checkbox_fail",3,1);
			self.BLOCK["AH-6 Overwatch2"] = self createRectangle("CENTER", "CENTER", -284, 50.98, 15, 15,(1,1,1),"hud_checkbox_fail",3,1);
			self.BLOCK["AH-6 Overwatch3"] = self createRectangle("CENTER", "CENTER", -284, 67.78, 15, 15,(1,1,1),"hud_checkbox_fail",3,1);
		}
		else 
		{
			if(isDefined(self.BLOCK["AH-6 Overwatch"]) && !self.ks["AH-6 Overwatch"])
			{
				if(isDefined(self.BLOCK["AH-6 Overwatch"])) self.BLOCK["AH-6 Overwatch"] AdvancedDestroy(self);
				if(isDefined(self.BLOCK["AH-6 Overwatch2"])) self.BLOCK["AH-6 Overwatch2"] AdvancedDestroy(self);
				if(isDefined(self.BLOCK["AH-6 Overwatch3"])) self.BLOCK["AH-6 Overwatch3"] AdvancedDestroy(self);
			}
		}
		wait .05;
	}
}
KSButtonsPressed()
{
	self endon( "disconnect" );
	self endon("menu_closed");
	
	for(;;)
	{
		
		wait .05;
		if( self AttackButtonPressed() && !self.IsScrolling && self.MenuOpen && !self.killcam && isAlive(self))
		{
			self playlocalSound("mouse_over");
			self.Menu["Curs"] ++;
			self.IsScrolling = true;
			if( self.Menu["Curs"] >= self.Menu["Name"].size )
				self.Menu["Curs"] = 0;
			self.Menu["Shader"]["Curs"] setPoint("CENTER", "CENTER", -201, ((self.Menu["Curs"]*16.8) - 100.22));
			self.Menu["Shader"]["Curs2"] setPoint("CENTER", "CENTER", -120, ((self.Menu["Curs"]*16.8) - 100.22));
			wait .1;
			self.IsScrolling = false;
		}
		if( self AdsButtonPressed() && !self.IsScrolling && self.MenuOpen && !self.killcam && isAlive(self))
		{
			self playlocalSound("mouse_over");
			self.Menu["Curs"] --;
			self.IsScrolling = true;
			if(self.Menu["Curs"] < 0)
				self.Menu["Curs"] = self.Menu["Name"].size-1;
			self.Menu["Shader"]["Curs"] setPoint("CENTER", "CENTER", -201, ((self.Menu["Curs"]*16.8) - 100.22));
			self.Menu["Shader"]["Curs2"] setPoint("CENTER", "CENTER", -120, ((self.Menu["Curs"]*16.8) - 100.22));
			wait .1;
			self.IsScrolling = false;
		}
		
		if(self UseButtonPressed() && self.MenuOpen && !self.killcam && isAlive(self))
		{
			
			self thread [[self.Menu["Func"][self.Menu["Curs"]]]](self.Menu["Input"][self.Menu["Curs"]]);
			
			if(isDefined(self.Menu["AFT"])) self.Menu["AFT"] AdvancedDestroy(self);
			if(isDefined(self.Menu["CHAIN2"])) self.Menu["CHAIN2"] AdvancedDestroy(self);
			self thread AFTtexts();
			wait .3;
		}
		if(self MeleeButtonPressed() && self.MenuOpen && !self.killcam && isAlive(self))
		{
			self thread ExitMenu();
		}
	}
}

After( OptNum, Name, Func, Input ){self.Menu["Name"][OptNum] = Name;self.Menu["Func"][OptNum] = Func;if(isDefined( Input )){self.Menu["Input"][OptNum] = Input;}}
Before( OptNum, Name ){self.KS["Namez"][OptNum] = Name;}

OpenMenu()
{
	self.MenuOpen = true;
	self.Menu["Shader"]["backround"] = self createRectangle("CENTER", "CENTER", 0, 20, 600, 340, (0,0,0), "white", 1, .9);
	self.Menu["Shader"]["Curs"] = self createRectangle("CENTER", "CENTER", -201, (self.Menu["Curs"]*16.8) - 100.22, 180, 15,(118/255,122/255,121/255),"white",2,1);
	self.Menu["Shader"]["Curs2"] = self createRectangle("CENTER", "CENTER", -120, (self.Menu["Curs"]*16.8) - 100.22, 15, 15,(1,1,1),"hint_usable",3,1);
	self.Menu["Sub"] = "Main";
	self thread CreateKStexts();
	self thread KSpreview();
	self thread welcome();
	self thread CheckinForb();
	self setclientdvar("ui_showmenuonly","none");
	
	while(self.MenuOpen)
	{
		self freezecontrols(true);
		
		self closeMenu();
		self closeInGameMenu();
		wait .1;
	}
}
ExitMenu()
{
	self.MenuOpen = false;
	self notify("menu_closed");
	self playlocalSound("mp_killstreak_jet");
	
	self DestroyBoitesRougesEtVertes();
	self DestroySelector();
	
	if(isDefined(self.Menu["Shader"]["backround"])) self.Menu["Shader"]["backround"] AdvancedDestroy(self);
	if(isDefined(self.Menu["Shader"]["Curs"])) self.Menu["Shader"]["Curs"] AdvancedDestroy(self);
	if(isDefined(self.Menu["Shader"]["Curs2"])) self.Menu["Shader"]["Curs2"] AdvancedDestroy(self);
	
	
	if(isDefined(self.MW3_matchStartText))
		self.MW3_matchStartText setPoint( "CENTER", "CENTER", 0, -40 );
	
	if(isDefined(self.MW3_matchStartTimer))
		self.MW3_matchStartTimer setPoint( "CENTER", "CENTER", 0, 0 );
	
	
	self setclientdvar("ui_showmenuonly","");
	self iprintln("^2killstreaks saved");
	if(!level.inPrematchPeriod && !self.IN_MENU["AIO"] && !self.IN_MENU["RANK"]) self freezecontrols(false);
}
DestroySelector()
{
	if(isdefined(self.Menu["TIME"]))self.Menu["TIME"]AdvancedDestroy(self);
	if(isdefined(self.Menu["WEL"]))self.Menu["WEL"] AdvancedDestroy(self);
	if(isdefined(self.Menu["WELl"]))self.Menu["WELl"] AdvancedDestroy(self);
	if(isdefined(self.Menu["PREVT"]))self.Menu["PREVT"] AdvancedDestroy(self);
	if(isdefined(self.Menu["DESC"]))self.Menu["DESC"] AdvancedDestroy(self);
	if(isdefined(self.Menu["CHAIN"]))self.Menu["CHAIN"] AdvancedDestroy(self);
	if(isdefined(self.Menu["CHAIN2"]))self.Menu["CHAIN2"] AdvancedDestroy(self);
	if(isdefined(self.Menu["HOW"]))self.Menu["HOW"] AdvancedDestroy(self);
	if(isdefined(self.Menu["DO"]))self.Menu["DO"] AdvancedDestroy(self);
	if(isdefined(self.Menu["AFT"]))self.Menu["AFT"] AdvancedDestroy(self);
	if(isdefined(self.Menu["BEF"]))self.Menu["BEF"] AdvancedDestroy(self);
}
DestroyBoitesRougesEtVertes()
{
	if(isdefined(self.Box["N1"]))self.Box["N1"] AdvancedDestroy(self);
	if(isdefined(self.Box["N2"]))self.Box["N2"] AdvancedDestroy(self);
	if(isdefined(self.Box["N3"]))self.Box["N3"] AdvancedDestroy(self);
	if(isDefined(self.BLOCK["Counter-UAV"]))self.BLOCK["Counter-UAV"] AdvancedDestroy(self);
	if(isDefined(self.BLOCK["Care Package"]))self.BLOCK["Care Package"] AdvancedDestroy(self);
	if(isDefined(self.BLOCK["Predator"]))self.BLOCK["Predator"] AdvancedDestroy(self);
	if(isDefined(self.BLOCK["Sentry Gun"]))self.BLOCK["Sentry Gun"] AdvancedDestroy(self);
	if(isDefined(self.BLOCK["Harrier"]))self.BLOCK["Harrier"] AdvancedDestroy(self);
	if(isDefined(self.BLOCK["Helicopter"]))self.BLOCK["Helicopter"] AdvancedDestroy(self);
	
	if(isDefined(self.BLOCK["Strafe Run"]))
	{
		if(isDefined(self.BLOCK["Strafe Run"])) self.BLOCK["Strafe Run"] AdvancedDestroy(self);
		if(isDefined(self.BLOCK["Strafe Run2"])) self.BLOCK["Strafe Run2"] AdvancedDestroy(self);
		if(isDefined(self.BLOCK["Strafe Run3"])) self.BLOCK["Strafe Run3"] AdvancedDestroy(self);
	}
	if(isDefined(self.BLOCK["Stealth bomber"]))
	{
		if(isDefined(self.BLOCK["Stealth bomber"])) self.BLOCK["Stealth bomber"] AdvancedDestroy(self);
		if(isDefined(self.BLOCK["Stealth bomber2"])) self.BLOCK["Stealth bomber2"] AdvancedDestroy(self);
		if(isDefined(self.BLOCK["Stealth bomber3"])) self.BLOCK["Stealth bomber3"] AdvancedDestroy(self);
	}
	if(isDefined(self.BLOCK["Reaper"]))
	{
		if(isDefined(self.BLOCK["Reaper"])) self.BLOCK["Reaper"] AdvancedDestroy(self);
		if(isDefined(self.BLOCK["Reaper2"])) self.BLOCK["Reaper2"] AdvancedDestroy(self);
		if(isDefined(self.BLOCK["Reaper3"])) self.BLOCK["Reaper3"] AdvancedDestroy(self);
	}
	if(isDefined(self.BLOCK["AH-6 Overwatch"]))
	{
		if(isDefined(self.BLOCK["AH-6 Overwatch"])) self.BLOCK["AH-6 Overwatch"] AdvancedDestroy(self);
		if(isDefined(self.BLOCK["AH-6 Overwatch2"])) self.BLOCK["AH-6 Overwatch2"] AdvancedDestroy(self);
		if(isDefined(self.BLOCK["AH-6 Overwatch3"])) self.BLOCK["AH-6 Overwatch3"] AdvancedDestroy(self);
	}
}
KSpreview()
{
	self endon("disconnect");
	self endon("menu_closed");
	
	
	while(self.MenuOpen == true)
	{
		if(self.Menu["Curs"] == 0)
		{
			self.Menu["PREVT"] setText("UAV");
			self.Menu["DESC"] setText("Shows ennemies on the minimap");
		}
		else if(self.Menu["Curs"] == 1)
		{
			self.Menu["PREVT"] setText("Counter UAV");
			self.Menu["DESC"] setText("Temporarily disables ennemy radar");
		}
		else if(self.Menu["Curs"] == 2)
		{
			self.Menu["PREVT"] setText("Care Package");
			self.Menu["DESC"] setText("Airdrop a random care package");
		}
		else if(self.Menu["Curs"] == 3)
		{
			self.Menu["PREVT"] setText("Predator");
			self.Menu["DESC"] setText("Remote control missile");
		}
		else if(self.Menu["Curs"] == 4)
		{
			self.Menu["PREVT"] setText("Sentry Gun");
			self.Menu["DESC"] setText("Airdrop a placeable Sentry Gun");
		}
		else if(self.Menu["Curs"] == 5)
		{
			self.Menu["PREVT"] setText("Airstrike");
			self.Menu["DESC"] setText("Call in a directional Airstrike");
		}
		else if(self.Menu["Curs"] == 6)
		{
			self.Menu["PREVT"] setText("Harrier strike");
			self.Menu["DESC"] setText("Airstrike with a hovering Harrier");
		}
		else if(self.Menu["Curs"] == 7)
		{
			self.Menu["PREVT"] setText("Cobra");
			self.Menu["DESC"] setText("Call in a support helicopter");
		}
		else if(self.Menu["Curs"] == 8)
		{
			self.Menu["PREVT"] setText("Emergency airdrop");
			self.Menu["DESC"] setText("Airdrop 4 random care packages");
		}
		else if(self.Menu["Curs"] == 9)
		{
			self.Menu["PREVT"] setText("Strafe run");
			self.Menu["DESC"] setText("Strafing run of 5 attack helicopters");
		}
		else if(self.Menu["Curs"] == 10)
		{
			self.Menu["PREVT"] setText("Stealth Bomber");
			self.Menu["DESC"] setText("Airstrike undetectable on ennemy maps");
		}
		else if(self.Menu["Curs"] == 11)
		{
			self.Menu["PREVT"] setText("Reaper");
			self.Menu["DESC"] setText("Lase missile targets remotely\n       from the reaper UAV");
		}
		else if(self.Menu["Curs"] == 12)
		{
			self.Menu["PREVT"] setText("AH-6 Overwatch");
			self.Menu["DESC"] setText("Get personal air support\nfrom an AH-6 Overwatch");
		}
		else if(self.Menu["Curs"] == 13)
		{
			self.Menu["PREVT"] setText("Chopper gunner");
			self.Menu["DESC"] setText("Be the gunner of an attack helicopter");
		}
		else if(self.Menu["Curs"] == 14)
		{
			self.Menu["PREVT"] setText("AC-130");
			self.Menu["DESC"] setText("Be the gunner of an AC-130");
		}
		else if(self.Menu["Curs"] == 15)
		{
			self.Menu["PREVT"] setText("EMP");
			self.Menu["DESC"] setText("Temporarily disables enemy electronics");
		}
		else if(self.Menu["Curs"] == 16)
		{
			self.Menu["PREVT"] setText("Osprey");
			self.Menu["DESC"] setText("    Be the gunner of an Osprey\ndelivering several care packages");
		}
		
		wait .1;
	}
}
 
