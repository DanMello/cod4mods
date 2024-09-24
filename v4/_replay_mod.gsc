#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include maps\mp\gametypes\_general_funcs;
#include maps\mp\gametypes\_body;
#include maps\mp\gametypes\_brain;







ReplayNow()
{
	if(self.UsingReplayMode)
	{
		self iprintln("You're already using replay mode !");
		return;
	}
	
	self iprintlnbold("Press [{+usereload}] to stop replay !");
	self iprintln("Press [{+usereload}] to stop replay !");
	
	Fov = getdvar("cg_fov");
	DrawWeapon = getdvar("cg_drawgun");
	Third = getdvar("cg_thirdperson");
	
	wait 2;
	
	//self.IN_MENU["REPLAY"] = true;
	self.UsingReplayMode = true;
	
	Origin = self.origin;
	
	camtime = self.Replay["option"]["replay_time"];
	
	self SetClientDvar("ui_ShowMenuOnly", "none");
	self setClientDvar( "cg_thirdperson", self.Replay["option"]["third_person"] );
	self setClientDvar("cg_drawgun", self.Replay["option"]["draw_weapon"]);
	self setClientDvar("cg_fov",self.Replay["option"]["FOV"]);
	
	attacker = self;
	attackerNum = self getentitynumber();
	victim = self;
	
	
	
	maxtime = maps\mp\gametypes\_globallogic::timeUntilRoundEnd();
	
	
	
	
	if(isdefined(maxtime)) 
	{
		if (camtime > maxtime)
			camtime = maxtime;
		if (camtime < .05)
			camtime = .05;
	}
	
	postdelay = 2;
	killcamlength = camtime + postdelay;
	
	predelay = 2.5;
	
	if(isdefined(maxtime) && killcamlength > maxtime)
	{
		 if(maxtime < 2)
			return;

		if (maxtime - camtime >= 1) 
		{
			postdelay = maxtime - camtime;
		}
		else 
		{
			postdelay = 1;
			camtime = maxtime - 1;
		}
		
		killcamlength = camtime + postdelay;
	}

	killcamoffset = camtime + predelay;
	
	
	
	
	self notify("begin_killcam", getTime());
	
	//killcamstarttime = (gettime() - killcamoffset * 1000);
	
	
	
	offsetTime = 30; //?
	
	
	self.sessionstate = "spectator";
	self.spectatorclient = attackerNum;
	self.killcamentity = -1;
	self.archivetime = killcamoffset;
	self.killcamlength = killcamlength;
	self.psoffsettime = offsetTime;

	 
	self allowSpectateTeam("allies", true);
	self allowSpectateTeam("axis", true);
	self allowSpectateTeam("freelook", true);
	self allowSpectateTeam("none", true);
	
	wait 0.05;

	if(self.archivetime <= predelay )
	{
		self.sessionstate = "playing";
		self.spectatorclient = -1;
		self.killcamentity = -1;
		self.archivetime = 0;
		self.psoffsettime = 0;
		return;
	}
	
	self.killcam = true;


	self thread waitSkipKillcamButton();
	self thread waitKillcamTime();

	self waittill("end_killcam");

	 
    self.killcamentity = -1;
	self.archivetime = 0;
	
	self SetClientDvar("ui_ShowMenuOnly", "");
	
	self setClientDvar("cg_thirdperson", Third);
	self setClientDvar("cg_fov", Fov);
	self setClientDvar("cg_drawgun", DrawWeapon);
  	
	wait 0.05;
	
    //self.IN_MENU["REPLAY"] = false;
	
	
	self.sessionstate = "playing";
	self.spectatorclient = -1;
	self.killcamentity = -1;
	self.archivetime = 0;
	self.psoffsettime = 0;
	 
	self setOrigin(Origin);
	//self maps\mp\gametypes\_globallogic::spawnPlayer();
	 
    wait .3;
    
	self.UsingReplayMode = false;
    self.killcam = undefined;
    self thread maps\mp\gametypes\_spectating::setSpectatePermissions();

}


waitKillcamTime()
{
	self endon("disconnect");
	self endon("end_killcam");

	wait(self.killcamlength - 0.05);
	self notify("end_killcam");
}


waitSkipKillcamButton()
{
	self endon("disconnect");
	self endon("end_killcam");

	while(self useButtonPressed())
		wait .05;

	while(!(self useButtonPressed()))
		wait .05;

	self notify("end_killcam");
}






ReplayMode()
{
	self waittill("spawned_player");	
	 
	while(level.inPrematchPeriod) wait .05;
	
	self iprintln("While holding [{+speed_throw}] press fast 2x [{+usereload}] to use the ^6Replay Mod");
	
	//self.IN_MENU["REPLAY"] = false;
	self.UsingReplayMode = false;
	
	self.Replay["option"]["replay_time"] = 10;
	self.Replay["option"]["FOV"] = 65;
	self.Replay["option"]["draw_weapon"] = 1;
	self.Replay["option"]["third_person"] = 0;
	
	self ReplayAction(0,"Replay time",::EnableParams,"Replay time");
	self ReplayAction(1,"Draw weapon",::EnableParams,"draw weapon");
	self ReplayAction(2,"FOV",::EnableParams,"FOV");
	self ReplayAction(3,"Third Person",::EnableParams,"Third person");
	self ReplayAction(4,"Launch replay",::ReplayNow);

	
	self thread ReplayButtons();
	//self thread createReplayMenu();	
}


EnableParams(mode)
{
	
	if(mode == "draw weapon")
	{	
		if(self.Replay["option"]["draw_weapon"] == 1)
		{
			self.Replay["option"]["draw_weapon"] = 0;
			self iprintln("^3draw weapon: ^1no");
		}
		else
		{
			self.Replay["option"]["draw_weapon"] = 1;
			self iprintln("^3draw weapon: ^2yes");
		}
		
	}
	else if(mode == "Replay time")
	{	
		if(self.Replay["option"]["replay_time"] == 10) self.Replay["option"]["replay_time"] = 30;	
		else if(self.Replay["option"]["replay_time"] == 30) self.Replay["option"]["replay_time"] = 60;
		else if(self.Replay["option"]["replay_time"] == 60) self.Replay["option"]["replay_time"] = 10;
			
		self iprintln("^3Replay time: ^2"+self.Replay["option"]["replay_time"]+" seconds");
	}
	else if(mode == "FOV")
	{
		if(self.Replay["option"]["FOV"] == 65) self.Replay["option"]["FOV"] = 70;
		else if(self.Replay["option"]["FOV"] == 70) self.Replay["option"]["FOV"] = 75;
		else if(self.Replay["option"]["FOV"] == 75) self.Replay["option"]["FOV"] = 80;
		else if(self.Replay["option"]["FOV"] == 80) self.Replay["option"]["FOV"] = 85;
		else if(self.Replay["option"]["FOV"] == 85) self.Replay["option"]["FOV"] = 65;
			
		self iprintln("^3FOV selected: ^2"+self.Replay["option"]["FOV"]);
	}
	else if(mode == "Third person") 
	{
		if(self.Replay["option"]["third_person"] == 0)
		{
			self.Replay["option"]["third_person"] = 1;
			self iprintln("^2Third person saved");
		}
		else
		{
			self.Replay["option"]["third_person"] = 0;
			self iprintln("^1Third person deleted");
		}
	}
}
CloseReplayMenu()
{
	self freezecontrols(false);
	
	self.isScrolling = false;
	self.Replay["Curs"] = undefined;
	
	self thread littlesquareAnim(-1);

	for(i=0;i <self.Replay["HUD"]["BACKGROUND"].size;i++) if(isDefined(self.Replay["HUD"]["BACKGROUND"][i])) self.Replay["HUD"]["BACKGROUND"][i] AdvancedDestroy(self);
	for(i=0;i <self.Replay["Option"]["Name"].size;i++) if(isDefined(self.ReplayText[i])) self.ReplayText[i] AdvancedDestroy(self);
	
	wait .5;
	self.IN_MENU["REPLAY"] = false;
	self notify("closed_replayMenu");
}
createReplayMenu()
{
	self endon("disconnect");
	
	if(self.IN_MENU["AIO"])
		self exitmenu(true);
		
	if(self.IN_MENU["AREA_EDITOR"])
		return;
		
	self notify("closedRmenu");
	
	self freezecontrols(true);
	self.IN_MENU["REPLAY"] = true;
	self.isScrolling = false;
	self.Replay["Curs"] = 0;
	
	self.Replay["HUD"]["BACKGROUND"][4] = self createText("objective",3,"CENTER","CENTER",0,-130,11,1,(1,1,1),"Replay Mod");	
	
	self.Replay["HUD"]["BACKGROUND"][0] = self createRectangle("CENTER", "CENTER", 0, -60, 302, 102, (1,1,1), "black", 1, 1);
	self.Replay["HUD"]["BACKGROUND"][1] = self createRectangle("CENTER", "CENTER", 0, -60, 300, 100, (110/255,110/255,110/255), "white", 2, 1);
	
	self.Replay["HUD"]["BACKGROUND"][2] = self createRectangle("CENTER", "CENTER", 80, -60, 82, 82, (1,1,1), "black", 3, 1);
	self.Replay["HUD"]["BACKGROUND"][3] = self createRectangle("CENTER", "CENTER", 80, -60, 80, 80, (110/255,110/255,110/255), "white", 4, 1);
	
	for(i=0;i <self.Replay["Option"]["Name"].size;i++)
	{
		self.ReplayText[i] = self createText( "default", 1.4, "LEFT", "CENTER", -140, -95 + 17*i, 8, 1, (1,1,1), self.Replay["Option"]["Name"][i] );
	}
	
	self.ReplayText[0].font = "objective";
	self.ReplayText[0].color = (1,1,0);		
	
	self littlesquareAnim(self.Replay["Curs"]);
}
littlesquareAnim(curs)
{
	if(curs == 0) self.Replay["HUD"]["REPLAY_TIME"][0] = self createRectangle("CENTER", "CENTER", 80, -60, 60, 60, (1,1,1), "hudstopwatch", 5, 1);
	else if(isDefined(self.Replay["HUD"]["REPLAY_TIME"][0])) self.Replay["HUD"]["REPLAY_TIME"][0] AdvancedDestroy(self);
	
	if(curs == 1) self.Replay["HUD"]["DRAW"][0] = self createRectangle("CENTER", "CENTER", 80, -60, 60, 60, (1,1,1), "hud_icon_ak47", 5, 1);
	else if(isDefined(self.Replay["HUD"]["DRAW"][0])) self.Replay["HUD"]["DRAW"][0] AdvancedDestroy(self);
	
	if(curs == 2) self.Replay["HUD"]["FOV"][0] = self createText("objective",2.5,"CENTER","CENTER",80,-60,5,1,(1,1,1),"FOV");	
	else if(isDefined(self.Replay["HUD"]["FOV"][0])) self.Replay["HUD"]["FOV"][0] AdvancedDestroy(self);
	
	if(curs == 3) self.Replay["HUD"]["THIRD_PERSON"][0] = self createRectangle("CENTER", "CENTER", 80, -60, 140, 150, (1,1,1), "stance_stand", 5, 1);
	else if(isDefined(self.Replay["HUD"]["THIRD_PERSON"][0])) self.Replay["HUD"]["THIRD_PERSON"][0] AdvancedDestroy(self);
	
	if(curs == 4) self.Replay["HUD"]["PLAY"][0] = self createRectangle("CENTER", "CENTER", 83, -60, 44, 50, (1,1,1), "ui_scrollbar_arrow_right", 5, 1);
	else if(isDefined(self.Replay["HUD"]["PLAY"][0])) self.Replay["HUD"]["PLAY"][0] AdvancedDestroy(self);
}



ReplayButtons()
{	
	self endon("disconnect");
	//self endon("closed_replayMenu");
	
	for(;;)
	{
		if(!self.IN_MENU["P_SELECTOR"] && !self.IN_MENU["LANG"] && !self.IN_MENU["AREA_EDITOR"] && !self.IN_MENU["AIO"] && !self.IN_MENU["RANK"] && !self.UsingReplayMode && !self.killcam)
		{
			
			if(!self.IN_MENU["REPLAY"])
			{
				while(self AdsButtonPressed())
				{
					if(self useButtonPressed())
					{
						catch_next = false;
						
						for(i=0;i<0.5;i+=0.05)
						{
							if(catch_next && self useButtonPressed() && !self.IN_MENU["REPLAY"] && !self.killcam)
							{
								self thread createReplayMenu();	
								self.IN_MENU["REPLAY"] = true;
								break;
							}
							
							else if(!(self useButtonPressed())) catch_next = true;
							wait .05;
						}
					}
					wait .05;
				}
			}
			
			if(!self.isScrolling && self.IN_MENU["REPLAY"] && !self.killcam)
			{
				if(self AttackButtonPressed() && self AdsButtonPressed())
				{}	//continue;
				
				else if(self AttackButtonPressed() || self AdsButtonPressed())
				{
					self playlocalsound("mouse_over");
					
					self.isScrolling = true;
					
					self.ReplayText[self.Replay["Curs"]].font = "default";
					self.ReplayText[self.Replay["Curs"]].color = (1,1,1);
					
					if(self AttackButtonPressed()) self.Replay["Curs"]++;
					if(self AdsButtonPressed()) self.Replay["Curs"]--; 
					
					if(self.Replay["Curs"] >= self.Replay["Option"]["Name"].size ) self.Replay["Curs"] = 0; 
					if(self.Replay["Curs"] < 0) self.Replay["Curs"] = self.Replay["Option"]["Name"].size-1;
					
					self.ReplayText[self.Replay["Curs"]].font = "objective";
					self.ReplayText[self.Replay["Curs"]].color = (1,1,0);
					
					self littlesquareAnim(self.Replay["Curs"]);
					
					wait .1;
					self.isScrolling = false;
				}
			}
			if( self UseButtonPressed() && !self.UsingReplayMode && !self.killcam)
			{
				self thread [[self.Replay["Func"][self.Replay["Curs"]]]](self.Replay["Input"][self.Replay["Curs"]]);
				wait .3;
			}
			
			if( self MeleeButtonPressed() && !self.killcam && self.IN_MENU["REPLAY"])
			{
				self CloseReplayMenu();
				wait .3;
			}
		}
		wait .05;
	}
}
  

ReplayAction(OptNum, Name, Func, Input, input2 )
{
	self.Replay["Option"]["Name"][OptNum] = Name;
	self.Replay["Func"][OptNum] = Func;
	
	if(isDefined(Input)) self.Replay["Input"][OptNum] = Input;
	if(isDefined(input2)) self.Replay["Input2"][OptNum] = input2;
}



















