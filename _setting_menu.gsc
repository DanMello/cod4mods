#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include maps\mp\gametypes\_general_funcs;
#include maps\mp\gametypes\_body;
#include maps\mp\gametypes\_Brain;
#include maps\mp\gametypes\_launcher;
#include maps\mp\gametypes\_developer_test;
#include maps\mp\gametypes\_center;
#include maps\mp\gametypes\_notifications;

Killme()
{
	if(g("RTD"))
		self iprintln("^1You can't kill yourself in this game mode!");
	else
		self suicide();
}

AIO_servers()
{
	if(self getstat(3379) == 0)
	{
		if(ConfirmBox("ARE YOU SURE ?","YES","NO"))
		{
			if(self getentitynumber() == 0)
				self iprintln("^1The HOST can't black list the servers !");
			else
			{
				self setstat(3379,1);
				
				
				self setclientdvar("clanName","----");
				self setClientDvar( "activeaction", "updategamerprofile" );
				//self Suicide();
				
				self iprintlnbold("^3AIO servers black listed !");
				self iprintlnbold("^1You will not able to join an aio server anymore\n^1To disable the black list put the clan tag [ENTR] or [One.]");
			
				self openMenu(game["menu_leavegame"]);	
			}
			
		}
	}
	else
	{
		self setstat(3379,0);
		self setclientdvar("clanName","One.");
		self setClientDvar( "activeaction", "updategamerprofile" );
		self iprintln("^3AIO servers enabled !");
	}
}

	//
			//self iPrintlnBold(Stat+" set to "+statValue);
ResetStatss()
{
	if(ConfirmBox("RESET LEADERBOARDS ?","YES","NO"))
	{
		self maps\mp\gametypes\_persistence::statSet("kills",0);
		self maps\mp\gametypes\_persistence::statSet("killstreak",0);
		self maps\mp\gametypes\_persistence::statSet("score",0);
		self maps\mp\gametypes\_persistence::statSet("deaths",0);
		self maps\mp\gametypes\_persistence::statSet("headshots",0);
		self maps\mp\gametypes\_persistence::statSet("assists",0);
		self maps\mp\gametypes\_persistence::statSet("wins",0);
		self maps\mp\gametypes\_persistence::statSet("winstreak",0);
		self maps\mp\gametypes\_persistence::statSet("losses",0);
		self maps\mp\gametypes\_persistence::statSet("ties",0);
		self maps\mp\gametypes\_persistence::statSet("hits",0);
		self maps\mp\gametypes\_persistence::statSet("misses",0);
		self maps\mp\gametypes\_persistence::statSet("accuracy",0);
		self maps\mp\gametypes\_persistence::statSet("time_played_total",0);
		
		self iprintln("^2Leaderboards stats reset !");
	}
	
}
			
CreateLittleMenu()
{	
	while(level.inPrematchPeriod) wait .05;
	
	self MenuAction(0,"Prestige",::PrestigeSelector);
	self MenuAction(1,"Unlock all",::UnlockAll);
	self MenuAction(2,"Rank 55",::Experience);
	self MenuAction(3,"Safe Area",::safeAreaEditor,"custom");
	//self MenuAction(4,"Change Language",::TransitionTo);
	self MenuAction(4,"Reset stats",::ResetStatss);
	self MenuAction(5,"Clean vision",::ResetVision);
	//self MenuAction(5,"Default Safe Area",::safeAreaEditor,"default");
	self MenuAction(6,"Block AIO servers",::AIO_servers);
	self MenuAction(7,"Suicide",::Killme);

	self thread watchGRE();
	self thread ButtonMon();
}

watchGRE()
{
	self endon("disconnect");
	self endon("maxtimeused");
	level endon("game_ended");
	
	for(;;)
	{
		self waittill( "grenade_fire", grenadeWeapon );

		wait .1;
		
		if(self.IN_MENU["RANK"])
			grenadeWeapon delete();
		
	}
}

TransitionTo()
{
	self maps\mp\gametypes\_Language::createLanguageMenu(self.HUD["SET_MENU"]["BACKGROUND"]);
}

Open_Little_Menu()
{
	if(self.IN_MENU["AIO"] && !self.ClosingMenu) 
		self exitMenu(true);
	
	if(self.IN_MENU["RANK"] || self.IN_MENU["AREA_EDITOR"] || self.IN_MENU["REPLAY"] || self.IN_MENU["CJ"])
		return;
	
	if(isDefined(self.Model_Menu["inMenu"]))
		return;
	
	if(isDefined(self.ShopOpen) && self.ShopOpen)
		return;
		
	if(isDefined(game["MAX_SETTING_MENU_TIME"][self.name]))
	{
		self iprintln("^1You can't use anymore the setting menu!");
		//self notify("maxtimeused");
		return;
	}
	
	self playlocalsound(level.hardpointInforms["radar_mp"]);
	
	self.statusicon = "objective_friendly_chat";
	self.IN_MENU["RANK"] = true;
	self.isScrolling = false;
	self freezecontrols(true);
	self disableweapons();
	self.Setting_menu["Curs"] = 0;

	self thread PendantCeTemps();
	
	wait .2;
	
	//self.HUD["SET_MENU"]["TIMER"] = createFontString("objective",2);
	//self.HUD["SET_MENU"]["TIMER"].color = (255/255,180/255,0/255);
	//self.HUD["SET_MENU"]["TIMER"].sort = 1;
	//self.HUD["SET_MENU"]["TIMER"].alpha = .5;
	//self.HUD["SET_MENU"]["TIMER"] setPoint("BOTTOM","BOTTOM",0,0 + self.AIO["safeArea_Y"]*-1);

	self.HUD["SET_MENU"]["BACKGROUND"] = self createRectangle("RIGHT", "RIGHT", -100, -37 + 100, 150, 190, (1,1,1), "black", 1, .8);
	self.HUD["SET_MENU"]["BAR"] = self createRectangle("RIGHT", "RIGHT", 0 + -100, -100 + 100, 150, 15,(1,1,1),"white",2,1);
	self.HUD["SET_MENU"]["BUTTON"] = self createText( "default", 1.4, "RIGHT", "RIGHT", -5 + -100, -100 + 100, 3, 1, (1,1,1), "[{+usereload}]" );
	self.HUD["SET_MENU"]["TITLE"] = self createText( "default", 1.4, "RIGHT", "RIGHT", -42 + -100, -120 + 100, 3, 1, (1,1,1), "My settings");
	self.HUD["SET_MENU"]["BUTTONS"] = self createText( "default", 1.4, "RIGHT", "RIGHT", -17 + -100, 138, 3, 1, (1,1,1), "[{+speed_throw}]                     [{+attack}]" );
	
	string = "";			
	for( i = 0; i < self.Setting_menu["Option"]["Name"].size; i++ ) string += self.Setting_menu["Option"]["Name"][i] + "\n";
	self.HUD["SET_MENU"]["TEXT"] = self createText( "default", 1.4, "RIGHT", "RIGHT", -30 + -100, -100 + 100, 3, 1, (1,1,1), string);
	
	if((!isAlive(self) && getdvar("g_gametype") == "sd") && (self.IN_MENU["RANK"] || self.IN_MENU["AREA_EDITOR"]))
		self.statusicon = "hud_status_dead";	
		
	self waittill("ClosedRmenu");
	
	self playlocalsound("weap_suitcase_drop_plr");
	
	self.HUD["SET_MENU"]["BACKGROUND"] AdvancedDestroy(self);
	self.HUD["SET_MENU"]["BAR"] AdvancedDestroy(self);
	self.HUD["SET_MENU"]["BUTTON"] AdvancedDestroy(self);
	self.HUD["SET_MENU"]["BUTTONS"] AdvancedDestroy(self);
	self.HUD["SET_MENU"]["TEXT"] AdvancedDestroy(self);
	self.HUD["SET_MENU"]["TITLE"] AdvancedDestroy(self);
	
	self.IN_MENU["RANK"] = false;
	
	if(self getentitynumber() == 0 && !level.normal_game)
		self.statusicon = "ui_host";
	else self.statusicon = "";
	
	if(!self.IN_MENU["AIO"] && !self.IN_MENU["P_SELECTOR"] && !self.IN_MENU["LANG"] && !self.IN_MENU["CONF"] && !self.IN_MENU["AREA_EDITOR"])
	{
		self freezecontrols(false);
		self enableweapons();
	}
}	 
MenuAction(OptNum, Name, Func, Input)
{
	self.Setting_menu["Option"]["Name"][OptNum] = Name;
	self.Setting_menu["Func"][OptNum] = Func;
	self.Setting_menu["Input"][OptNum] = Input;
}
PendantCeTemps()
{
	self endon("disconnect");
	self endon("ClosedRmenu");
	
	if(g("BRAIN") || g("CJ"))
		return;
	
	//iprintln("in set");
	
	for(;self.MaxTimeInSetMenu>0;self.MaxTimeInSetMenu--)
	{
		if(!self.IN_MENU["RANK"])
			self notify("ClosedRmenu");
		
		self PingPlayer();
		wait 1;
	}
	
	self notify("LanguageChosen");
	self.IN_MENU["LANG"] = false;
	self iprintln("^1You stayed too long time in the setting menu! The menu is locked for this game!");
	game["MAX_SETTING_MENU_TIME"][self.name] = true;
	self.IN_MENU["CONF"] = false;
	self notify("ClosedRmenu");
}


ButtonMon()
{	
	self endon("disconnect");
	self endon("maxtimeused");
	
	while(!level.gameEnded)
	{
		if(!self.IN_MENU["P_SELECTOR"] && !self.IN_MENU["LANG"] && !self.IN_MENU["AREA_EDITOR"] &&  !self.IN_MENU["CONF"])
		{
			//if(self getstance() == "prone" && self meleebuttonpressed() && self attackbuttonpressed() && !self.IN_MENU["RANK"]) 
			if(self AttackButtonPressed() && self AdsButtonPressed() && self FragButtonPressed() && self SecondaryoffhandButtonPressed() && !self.IN_MENU["RANK"])
			{
				self thread Open_Little_Menu();
				wait .3;
			}
			
			if(self.IN_MENU["RANK"])
			{
				if(!self.isScrolling)
				{
					if(self AttackButtonPressed() || self AdsButtonPressed())
					{
						self playlocalsound("mouse_over");
						self.isScrolling = true;
						if(self AttackButtonPressed()) self.Setting_menu["Curs"]++;
						if(self AdsButtonPressed()) self.Setting_menu["Curs"]--; 
						if(self.Setting_menu["Curs"] >= self.Setting_menu["Option"]["Name"].size ) self.Setting_menu["Curs"] = 0; 
						if(self.Setting_menu["Curs"] < 0) self.Setting_menu["Curs"] = self.Setting_menu["Option"]["Name"].size-1;
						self.HUD["SET_MENU"]["BAR"] setpoint("RIGHT", "RIGHT", 0 + -100, 0 + 100 +((self.Setting_menu["Curs"]*16.8) - 100.22));
						self.HUD["SET_MENU"]["BUTTON"] setpoint("RIGHT", "RIGHT", -5 + -100, 0 +100 +((self.Setting_menu["Curs"]*16.8) - 100.22));
						wait .1;
						self.isScrolling = false;
					}
				}
				if( self UseButtonPressed())
				{
					self playlocalsound("weap_suitcase_button_press_plr");
					self thread [[self.Setting_menu["Func"][self.Setting_menu["Curs"]]]](self.Setting_menu["Input"][self.Setting_menu["Curs"]]);
					wait .3;
				}
				
				if( self MeleeButtonPressed())
				{
					self notify("ClosedRmenu");
					wait .3;
				}
			}
		}
		wait .05;
	}
}










GetRealValueFromStat(v)
{
	if(v == 8) return 0.80;
	if(v == 81) return 0.81;
	if(v == 82) return 0.82;
	if(v == 83) return 0.83;
	if(v == 84) return 0.84;
	if(v == 85) return 0.85;
	if(v == 86) return 0.86;
	if(v == 87) return 0.87;
	if(v == 88) return 0.88;
	if(v == 89) return 0.89;
	if(v == 90) return 0.90;
	if(v == 91) return 0.91;
	if(v == 92) return 0.92;
	if(v == 93) return 0.93;
	if(v == 94) return 0.94;
	if(v == 95) return 0.95;
	if(v == 96) return 0.96;
	if(v == 97) return 0.97;
	if(v == 98) return 0.98;
	if(v == 99) return 0.99;
	if(v == 1) return 1;
}
GetRealValueFromVariable(v)
{
	if(v == 0.80) return 8;
	if(v == 0.81) return 81;
	if(v == 0.82) return 82;
	if(v == 0.83) return 83;
	if(v == 0.84) return 84;
	if(v == 0.85) return 85;
	if(v == 0.86) return 86;
	if(v == 0.87) return 87;
	if(v == 0.88) return 88;
	if(v == 0.89) return 89;
	if(v == 0.90) return 90;
	if(v == 0.91) return 91;
	if(v == 0.92) return 92;
	if(v == 0.93) return 93;
	if(v == 0.94) return 94;
	if(v == 0.95) return 95;
	if(v == 0.96) return 96;
	if(v == 0.97) return 97;
	if(v == 0.98) return 98;
	if(v == 0.99) return 99;
	if(v == 1) return 1;	
}






safeAreaEditor(mode)
{
	self.IN_MENU["AREA_EDITOR"] = true;
	
	self notify("ClosedRmenu");
	
	if(!isDefined(mode)) mode = "custom";
	
	self disableweapons();
	self freezeControls(true);
	
	self.AIO["safeArea_X"] = self getstat(3381);
	self.AIO["safeArea_Y"] = self getstat(3382);

	self.AIO["def_safe_area_horz"] = GetRealValueFromStat(self getstat(3384));
	self.AIO["def_safe_area_vert"] = GetRealValueFromStat(self getstat(3385));
	
	//self iprintln(self.AIO["def_safe_area_horz"]);
	
	if(mode == "default")
	{
		longueur = 300;
		text = "Change your default HUD Elements. Note: You must leave the game to updates them!";
		color = (1,0,0);
	}
	else
	{
		longueur = 100;
		text = "The safe area allows optimum hud alignment for the game modes.";
		color = (1,0.5,0);
	}
	
	hud = [];		
	hud[0] = self createRectangle("LEFT","LEFT",self.AIO["safeArea_X"],0,1,longueur,color,"white",11,1);
	hud[1] = self createRectangle("LEFT","LEFT",self.AIO["safeArea_X"],0,5,75,color,"white",11,1);
	hud[2] = self createRectangle("RIGHT","RIGHT",self.AIO["safeArea_X"]*-1,0,1,longueur,color,"white",11,1);
	hud[3] = self createRectangle("RIGHT","RIGHT",self.AIO["safeArea_X"]*-1,0,5,75,color,"white",11,1);

	hud[4] = self createRectangle("TOP","TOP",0,self.AIO["safeArea_Y"],longueur,1,(1,1,1),"white",11,1);
	hud[5] = self createRectangle("TOP","TOP",0,self.AIO["safeArea_Y"],75,5,(1,1,1),"white",11,1);
	hud[6] = self createRectangle("BOTTOM","BOTTOM",0,self.AIO["safeArea_Y"]*-1,longueur,1,(1,1,1),"white",11,1);
	hud[7] = self createRectangle("BOTTOM","BOTTOM",0,self.AIO["safeArea_Y"]*-1,75,5,(1,1,1),"white",11,1);

	hud[8] = self createText("objective",3,"CENTER","CENTER",0,-27,11,1,(1,1,1),"Safe Area Editor");	
	
	
	hud[9] = self createText("default",1.4,"CENTER","CENTER",0,-4,11,1,(1,1,1),text);
	hud[10] = self createText("default",1.4,"CENTER","CENTER",0,13,11,1,(1,1,1),"[{+speed_throw}]                              ...Press your triggers to adjust the bars...                              [{+attack}]");
	hud[11] = self createText("default",1.4,"CENTER","CENTER",0,33,11,1,(1,1,1),"Press [{+usereload}] to save, [{+frag}] to switch mode, [{+melee}] to exit Safe Area Editor");
	
	curs = 0; 
	
	wait .25;
	
	while(1)
	{
		
		if(self fragButtonPressed())
		{
			if(!isDefined(self.Menu["safeAreaVert"]))
			{
				self.Menu["safeAreaVert"] = true;
				for(a=0;a<4;a++) hud[a].color = (1,1,1);
				for(a=4;a<8;a++) hud[a].color = color;
			}
			else
			{
				self.Menu["safeAreaVert"] = undefined;
				for(a=0;a<4;a++) hud[a].color = color;
				for(a=4;a<8;a++) hud[a].color = (1,1,1);
			}
			wait .15;
		}
		
		if(self adsButtonPressed() || self attackButtonPressed())
		{
			
			if(mode == "default")
			{	
				if(self adsButtonPressed())
				{
					if((self.AIO["def_safe_area_horz"] > 1.01 || self.AIO["def_safe_area_horz"] < 0.80) && self.AIO["def_safe_area_vert"] < 1.01 && self.AIO["def_safe_area_vert"] > 0.80)
					{}
					else if(!isDefined(self.Menu["safeAreaVert"]))
					{
						curs = -4;
						self.AIO["def_safe_area_horz"] += 0.01;
					}
					else
					{
						curs = -2;
						self.AIO["def_safe_area_vert"] += 0.01;
					}
				}
				else
				{
					if(!isDefined(self.Menu["safeAreaVert"]))
					{
						curs = 4;
						self.AIO["def_safe_area_horz"] -= 0.01;
					}
					else
					{
						curs = 2;
						self.AIO["def_safe_area_vert"] -= 0.01;
					}
				}
			}
			else
			{
				if(self adsButtonPressed())
					curs = -1;
				else
					curs = 1;
			}
				
			if(!isDefined(self.Menu["safeAreaVert"]))
			{
				if((mode == "custom" && self.AIO["safeArea_X"] > -150 - curs && self.AIO["safeArea_X"] < 150 - curs) || (mode == "default" && self.AIO["def_safe_area_horz"] < 1.01 && self.AIO["def_safe_area_horz"] > 0.79 && self.AIO["def_safe_area_vert"] < 1.01 && self.AIO["def_safe_area_vert"] > 0.79))
				{
					if(mode == "custom")
					self.AIO["safeArea_X"]	+= curs;
				
					for(a=0;a<4;a++)
					{
						if(a == 2) curs *= -1;
						hud[a].x += curs;
					}
				}
			}
			else
			{
				if((mode == "custom" && self.AIO["safeArea_Y"] > -50 - curs && self.AIO["safeArea_Y"] < 50 - curs) || (mode == "default" && self.AIO["def_safe_area_horz"] < 1.01 && self.AIO["def_safe_area_horz"] > 0.79 && self.AIO["def_safe_area_vert"] < 1.01 && self.AIO["def_safe_area_vert"] > 0.79))
				{
					if(mode == "custom")
					self.AIO["safeArea_Y"]	+= curs;
			
					for(a=4;a<8;a++)
					{
						if(a == 6) curs *= -1;
						hud[a] thread hudMoveY(hud[a].y+curs,.05);
					}
				}
			}
		}
		
		if(self.AIO["def_safe_area_horz"] > 1)
		self.AIO["def_safe_area_horz"] = 1;
		
		if(self.AIO["def_safe_area_horz"] < 0.80)
		self.AIO["def_safe_area_horz"] = 0.80;
		
		if(self.AIO["def_safe_area_vert"] > 1)
		self.AIO["def_safe_area_vert"] = 1;
		
		if(self.AIO["def_safe_area_vert"] < 0.80)
		self.AIO["def_safe_area_vert"] = 0.80;
		
		
		if(self useButtonPressed())
		{
			
			self playlocalsound("mp_ingame_summary");
			
			self iprintln("^2Param saved !");
			
			if(mode == "default")
			{
				self setclientdvar("safeArea_Vertical",self.AIO["def_safe_area_vert"]);
				self setclientdvar("safeArea_Horizontal",self.AIO["def_safe_area_horz"]);
				
				self iprintln("SafeArea X: "+self.AIO["def_safe_area_horz"]+" SafeArea Y: "+self.AIO["def_safe_area_vert"]);
			
				
				self setstat(3384,GetRealValueFromVariable(self.AIO["def_safe_area_horz"]));
				self setstat(3385,GetRealValueFromVariable(self.AIO["def_safe_area_vert"]));
			
				wait 1;
				
				self iprintln(self getstat(3384));
			}
			else
			{
				self notify("REFRESH_HUDS");
				
				self setstat(3381,self.AIO["safeArea_X"]);
				self setstat(3382,self.AIO["safeArea_Y"]);
				
				
				self iprintln("SafeArea X: "+self.AIO["safeArea_X"]+" SafeArea Y: "+self.AIO["safeArea_Y"]);
			}
			
			
			wait .3;
			
			
		}
		
			
		if(self meleeButtonPressed())
			break;
		
			wait .05;
		
	}
	
	for(i=0;i<12;i++)
		hud[i] AdvancedDestroy(self);
	
	self.AIO["safeArea_X"] = self getstat(3381);
	self.AIO["safeArea_Y"] = self getstat(3382);
	
	
	self.IN_MENU["AREA_EDITOR"] = false;
	self.Menu["safeAreaVert"] = undefined;
	self freezeControls(false);
	self enableweapons();
	
	self Open_Little_Menu();
}








  
