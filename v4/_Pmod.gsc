#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include common_scripts\utility;
#include maps\mp\gametypes\_general_funcs;




init()
{
	level thread onPlayerConnect();
	
	level.hardcoreMode = false;
	level.teamBased = true;
	
	level deletePlacedEntity("misc_turret");
	
	level.gameModeDevName = "PM";
	level.current_game_mode = "Promod";
	
	level.alliesOnMap = 0;
	level.axisOnMap = 0;
	
	precacheshader("scorebar_usmc");
	precacheshader("scorebar_ussr");
	
	for(i=0;i<6;i++)level.AlliesPosition[i] = undefined;
	for(i=0;i<6;i++)level.AxisPosition[i] = undefined;
	
	if(game["roundsplayed"] == 0)
		wait 8;
	else
		wait 2;
	
	level thread GeneralDvars();
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
	
	self thread LeanDvars();
	self thread Promod_Prematch();
	self.show_COD_Casting = false;
	
	
	if(level.gametype == "sd")
	{
		self thread DPAD_Monitor();
		self thread PlantingDefusingBomb();
	}
		
	for(;;)
	{
		self waittill("spawned_player");
		
		self freezecontrols(false);
		
		if(level.gametype == "sd")
		{
			self thread initPlacement();
		
			if(self.team == ("allies"))
			{
				level.alliesOnMap++;
				colorA = (0,1,0);
				colorD = (1,0,0);
				
				self thread onDeath(2);
				self thread onDisconnect(2);
			}
			else
			{
				level.axisOnMap++;
				colorA = (1,0,0);
				colorD = (0,1,0);
				
				self thread onDeath(1);
				self thread onDisconnect(1);
			}
			
			self.HUD["PMOD"]["COUNTER_A"] = self createText("default", 1.8, "BOTTOM RIGHT", "BOTTOM RIGHT",  -50 , -60, 1, 1, (1,1,1),"",colorA,1);
			self.HUD["PMOD"]["COUNTER_D"] = self createText("default", 1.8, "BOTTOM RIGHT", "BOTTOM RIGHT",  -36 , -60, 1, 1, (1,1,1),"",colorD,1);
			
		}
		
		
		self iprintln(self.Lang["PROMOD"]["LEANINFO"]);
	
		
		
		self thread On_disconnect();
		self thread HUD_Controler();
		
		self thread Promod_class();
		self thread ClientDvars();
		
		
		if(!isDefined(game["PMOD"][self.name]))
		{
			game["PMOD"][self.name] = true;
			self thread CC();
		}
		
		
		
		while(1)
		{
			self.HUD["PMOD"]["COUNTER_A"] setValue(level.alliesOnMap);
			self.HUD["PMOD"]["COUNTER_D"] setValue(level.axisOnMap);
			
			wait 1;
		}
	}
}

onDeath(n)
{
	self endon("disconnect");
	
	self waittill("death");
	
	if(n==1)
		level.alliesOnMap--;
	else if(n==2)
		level.axisOnMap--;
}
onDisconnect(n)
{
	self endon("death");
	
	self waittill("disconnect");
	
	if(n==1)
		level.alliesOnMap--;
	else if(n==2)
		level.axisOnMap--;
}
Promod_Prematch()
{
	//self endon("death");
	
	stratText = self createFontString("objective",1.4);
	stratText setPoint("CENTER","CENTER",0,-33);
	stratText.sort = 1;
	stratText.alpha = 1;
	stratText.color = (1,1,1);
	stratText setText("Strat time");
	
	TimerText = self createFontString("objective",1.4);
	TimerText setPoint("CENTER","CENTER",0,-21);
	TimerText.sort = 1;
	TimerText.alpha = 1;
	TimerText.color = (1,1,1);
	 
	level.stratTime = true;
	
	countTime = int( level.prematchPeriod );
	
	
	if(level.inPrematchPeriod)
	{
		setdvar("g_speed","0");
		
		countTime = int( level.prematchPeriod );
	
		if(countTime >= 2)
		{
			while(countTime > 0 && !level.gameEnded)
			{
				TimerText setText( "0:0"+countTime );
				
				self setClientDvar( "player_sustainAmmo", "1" );
				self allowsprint(false);
				self setClientDvar("cg_drawGun", "1");
				self setClientDvar("cg_drawCrosshair", "0" );
				
				
				countTime--;
				wait 1;
			}
		}
	}
	 
	level.stratTime = false;
	
	stratText destroy();
	TimerText destroy();
	
	setDvar( "g_speed", "190" );
	
	self setClientDvar( "player_sustainAmmo", "0" );
	self allowsprint(true);
	self setClientDvar( "cg_drawCrosshair", "1" );

}


Promod_class()
{
	self setclientdvar( "customclass1", "^1AK-47");
	self setclientdvar( "customclass2", "^2AK74u");
	self setclientdvar( "customclass3", "^3W1200");
	self setclientdvar( "customclass4", "^4R700");
	self setclientdvar( "customclass5", "^5M40A3");
}
ClientDvars()
{
	self setClientDvar( "player_sprintCameraBob", "0" );
	
	//Scoreboard
	self setClientDvar( "cg_scoreboardPingText", "1" );
	self setClientDvar( "cg_scoreboardPingGraph", "0" );
	self setClientDvar( "cg_scoreboardWidth", "600" );
	self setClientDvar( "compassSize", "0.8" );
	//Weapon
	self setClientDvar( "cg_fovScale", "1.125" );
	self setClientDvar( "cg_fov", "80" );
	self setClientDvar( "cg_drawGun", "1" );
	self setClientDvar( "cg_drawCrosshair", "1" );
	self setclientDvar( "player_breath_gasp_lerp", "0" ); 
	self setClientDvar( "aim_automelee_enabled", "0" );
	self setClientDvar( "aim_automelee_range", "69" );
	self setClientDvar( "aim_autoaim_enabled", "0" );
	
	wait 2;
	
	//Perks
	self setClientDvar( "perk_weapspreadMultiplier", "0.4" ); 
	self setClientDvar( "perk_bulletPenetrationMultiplier", "23" );
	self setClientDvar( "perk_bulletDamage", "60" );
	self setClientDvar( "perk_bullet_penetrationMinFxDist", "33" );
	self setClientDvar( "perk_bullet_penetrationEnabled", "1" );
	
	//Screen
	self setClientDvar( "waypointIconHeight", "0.1" );
	self setClientDvar( "waypointIconWidth", "0.1" );
	self setClientDvar( "cg_overheadRankSize", "0.001" );
	self setClientDvar( "nightVisionDisableEffects", "1" );
	self setClientDvar( "cg_drawBreathHint", "0" );
	self setClientDvar( "cg_drawMantleHint", "0" );
    
	//Gameplay
	self setClientDvar("bg_fallDamageMaxHeight", "450" );
	self setClientDvar("bg_fallDamageMinHeight", "350" ); 
	
	wait 1;
	setDvar("lowAmmoWarningColor1", "0 0 0 0" ); 
	setDvar("lowAmmoWarningColor2", "0 0 0 0" ); 
	setDvar("lowAmmoWarningNoAmmoColor1", "0 0 0 0" ); 
	setDvar("lowAmmoWarningNoAmmoColor2", "0 0 0 0" ); 
	setDvar("lowAmmoWarningNoReloadColor1", "0 0 0 0" ); 
	setDvar("lowAmmoWarningNoReloadColor2", "0 0 0 0" ); 
}
CC()
{
	self setClientDvar( "r_filmusetweaks","1");
	self setClientDvar( "r_filmtweakenable","1");
	self setClientDvar( "r_filmtweakContrast","1.8");
	self setClientDvar( "r_filmtweakLighttint","0.4 0.6 1");
	self setClientDvar( "r_filmtweakDarktint","1.3 1.1 1.2");
	self setClientDvar( "r_filmtweakDesaturation","0");
	self setClientDvar( "r_gamma","0.9");
	self setClientDvar( "r_filmtweakbrightness","0.5");
	self setClientDvar( "r_lighttweaksunlight","0.1");	 
	
}
LeanDvars()
{
	self setClientDvar("activeaction", "vstr LEANtoggle");
	self setClientDvar("LEANtoggle", "set con_hidechannel *;bind dpad_down vstr turnOn");
	self setClientDvar("turnOn", "bind dpad_down vstr turnOff;vstr gachettes;Lean_^2ON");
	self setClientDvar("turnOff", "vstr unbindtrigz;bind dpad_down vstr turnOn;Lean_^1OFF");
	self setClientDvar("gachettes", "bind BUTTON_LTRIG +leanleft;bind BUTTON_RTRIG +leanright");
	self setClientDvar("unbindtrigz", "bind BUTTON_LTRIG +smoke ;bind BUTTON_RTRIG +frag");
}

DPAD_Monitor()
{
	self endon("disconnect");
	level endon("game_ended");	
	
	self.isBombCarrier = false;
	
	self.HUD["TEXT"]["DROPBOMB"] = self createText("default", 1.5, "LEFT", "LEFT", 0 + self.AIO["safeArea_X"], -50 + self.AIO["safeArea_Y"] , 1, 1 );
	
	self thread DestroyHUDondeath();
	
	while(1)
	{
		wait .3;
		weaponswap = self getCurrentWeapon();
		
		while(1)
		{
			if(self.isBombCarrier && !self.isPlanting && !level.bombPlanted)
			{
				self.HUD["TEXT"]["DROPBOMB"] setText(self.Lang["PROMOD"]["DROPBOMB"]);
				self giveweapon("briefcase_bomb_mp");
				self setWeaponAmmoClip("briefcase_bomb_mp", 0);
				self setWeaponAmmoStock("briefcase_bomb_mp", 0);
				self SetActionSlot(1, "weapon", "briefcase_bomb_mp" );
			}
			else self.HUD["TEXT"]["DROPBOMB"] setText("");
			
			self giveweapon("flash_grenade_mp");
			self SetActionSlot(3,"weapon","flash_grenade_mp");
			self setWeaponAmmoClip("flash_grenade_mp", 0);
			
			if(weaponswap != self getCurrentWeapon())
			{
				if(self getCurrentWeapon() == "briefcase_bomb_mp" && !self.isPlanting)
				{
					wait .5;
					self thread PM_DPADS("UP");
					self switchToWeapon(weaponswap);
				}
				if(self getCurrentWeapon() == "flash_grenade_mp") 
				{
					self takeweapon("flash_grenade_mp");
					self switchToWeapon(weaponswap);
					self thread PM_DPADS("LEFT");
				}
				wait .1;
				break;
			}
			wait .05;
		}
	} 
}

PM_DPADS(DPAD)
{
	
	if(DPAD == "DOWN")
	{
		
	}
		
	if(DPAD == "LEFT")
	{
		if(self.show_COD_Casting)
		{
			for(i=0;i<level.players.size;i++)
			{
				if(isDefined(self.Promod_rect[getName(level.players[i])]["HUD"]["allies"])) self.Promod_rect[getName(level.players[i])]["HUD"]["allies"] AdvancedDestroy(self);
				if(isDefined(self.Promod_text[getName(level.players[i])]["NAME"]["allies"])) self.Promod_text[getName(level.players[i])]["NAME"]["allies"] AdvancedDestroy(self);
				if(isDefined(self.Promod_rect[getName(level.players[i])]["HUD"]["axis"])) self.Promod_rect[getName(level.players[i])]["HUD"]["axis"] AdvancedDestroy(self);
				if(isDefined(self.Promod_text[getName(level.players[i])]["NAME"]["axis"])) self.Promod_text[getName(level.players[i])]["NAME"]["axis"] AdvancedDestroy(self);
			}
			
			self iprintln("COD Casting ^1disabled");
			
			self.show_COD_Casting = false;
		}
		else self thread CreateSpectateHUD();
	}
	
	if(DPAD == "UP") 
	{
		self takeweapon("briefcase_bomb_mp");
		self SetActionSlot(1, "", "" );
		
		level.sdBomb maps\mp\gametypes\_gameobjects::setDropped();
		wait .2;
		self.isBombCarrier = false;
	}
	if(DPAD == "RIGHT")
	{

	}
}
DestroyHUDondeath()
{
	self waittill("death");
	self.HUD["TEXT"]["DROPBOMB"] AdvancedDestroy(self);
}





PlantingDefusingBomb()
{
	self endon("disconnect");
	
	self waittill("spawned_player");
	
	for(;;)
	{
		while(self.isPlanting || self.isDefusing)
		{
			self setClientDvar("cg_drawGun", "0");
			self setClientDvar("cg_drawCrosshair", "0");
			wait .1;
		}	
		self setClientDvar("cg_drawGun", "1");
		self setClientDvar("cg_drawCrosshair", "1");
		wait .1;
	}
}
GeneralDvars()
{
	setDvar("jump_height", "45" );
	setDvar("jump_slowdownEnable", "0" );
	setDvar("g_gravity", "780" );
	setDvar("scr_game_hardpoints", "0" );
	setDvar("scr_player_maxhealth", "80");
	setDvar("scr_player_healthregentime", "5"); 
	setDvar("scr_showperksonspawn", "0");
	setDvar("con_gameMsgWindow0MsgTime", 17 );
	setDvar("con_gameMsgWindow0LineCount", 5 );
	setDvar("perk_armorVest", "100");           
	setDvar("perk_bulletDamage", "40");
	setDvar("perk_explosiveDamage", "0");
	setDvar("ui_hud_showdeathicons", "0");
}










	
	
		
/**************************

	COD CASTING PROJECT

**************************/






initPlacement()
{	
	if(self.team == "allies")
	{
		for(i=0;i<6;i++)
		{
			if(!isDefined(level.AlliesPosition[i]))
			{
				level.AlliesPosition[i] = i;
				self.MyPosition = level.AlliesPosition[i];
				break;
			}
		}
	}
	if(self.team == "axis")
	{
		for(i=0;i<6;i++)
		{
			if(!isDefined(level.AxisPosition[i]))
			{
				level.AxisPosition[i] = i;
				self.MyPosition = level.AxisPosition[i];
				break;
			}
		}	
	}
}


Create_Promod_Rectangle(C1,C2,C3,align, relative, x, y, width, height, color, shader, sort, alpha)
{
	self.HUD_Elements_Used++;
	
	self.Promod_rect[C1][C2][C3] = newClientHudElem(self);
	self.Promod_rect[C1][C2][C3].elemType = "bar";
	self.Promod_rect[C1][C2][C3].width = width;
	self.Promod_rect[C1][C2][C3].height = height;
	self.Promod_rect[C1][C2][C3].align = align;
	self.Promod_rect[C1][C2][C3].relative = relative;
	self.Promod_rect[C1][C2][C3].xOffset = 0;
	self.Promod_rect[C1][C2][C3].yOffset = 0;
	self.Promod_rect[C1][C2][C3].children = [];
	self.Promod_rect[C1][C2][C3].sort = sort;
	self.Promod_rect[C1][C2][C3].color = color;
	self.Promod_rect[C1][C2][C3].alpha = alpha;
	self.Promod_rect[C1][C2][C3].shader = shader;
	self.Promod_rect[C1][C2][C3].horzAlign = "fullscreen";
	self.Promod_rect[C1][C2][C3].vertAlign = "fullscreen";
	self.Promod_rect[C1][C2][C3] setParent(level.uiParent);
	self.Promod_rect[C1][C2][C3] setShader(shader,width,height);
	self.Promod_rect[C1][C2][C3].hidden = false;
	self.Promod_rect[C1][C2][C3] setPoint(align, relative, x, y);
}

Create_Promod_Text(C1,C2,C3,font, fontScale, align, relative, x, y, sort, alpha, color, text, glowcolor, glowalpha)
{
	self.HUD_Elements_Used++;	
	
	self.Promod_text[C1][C2][C3] = self createFontString(font, fontScale, self);
	self.Promod_text[C1][C2][C3] setPoint(align,relative);
	self.Promod_text[C1][C2][C3].alpha = alpha;
	self.Promod_text[C1][C2][C3].sort = sort;
	self.Promod_text[C1][C2][C3].color = color;
	self.Promod_text[C1][C2][C3].x = x;
	self.Promod_text[C1][C2][C3].y = y;
	self.Promod_text[C1][C2][C3].glowColor = glowcolor;
	self.Promod_text[C1][C2][C3].glowAlpha = glowalpha;
	self.Promod_text[C1][C2][C3] setText(text);	
}

CreateSpectateHUD()
{
	
	if(self.show_COD_Casting)
	{
		self iprintln("^1COD Casting already enabled !");
		return;
	}
	
	self iprintln("COD Casting ^2enabled");
	
	myTeam = self.pers["team"];
	enemyTeam = getOtherTeam( myTeam );
		
	self.show_COD_Casting = true;
	
	//self Create_Promod_Text("DEV","HUD","TEXT","default", 1.6, "TOP", "TOP",  0, 0, 1, 1, (1,1,1),"Developer MODE" );

	for(a=0;a<level.players.size;a++)
	{
		if(level.players[a].team == myTeam) 
		{
			if(isDefined(level.players[a].MyPosition))
			{
				self Create_Promod_Rectangle(getName(level.players[a]),"HUD","allies","LEFT", "LEFT", 0 + self.AIO["safeArea_X"], 0 + level.players[a].MyPosition*16 + self.AIO["safeArea_Y"], 200, 15, DivideColor(0,76,153), "scorebar_usmc", 1, 1);
				self Create_Promod_Text(getName(level.players[a]),"NAME","allies","default", 1.6, "LEFT", "LEFT",  10 + self.AIO["safeArea_X"], 0 + level.players[a].MyPosition*16 + self.AIO["safeArea_Y"], 2, 1, (1,1,1), getName(level.players[a]));
			}
		}
		if(level.players[a].team == enemyTeam)
		{
			if(isDefined(level.players[a].MyPosition))
			{
				self Create_Promod_Rectangle(getName(level.players[a]),"HUD","axis","RIGHT", "RIGHT", 0 + self.AIO["safeArea_X"]*-1, 0 + level.players[a].MyPosition*16 + self.AIO["safeArea_Y"], 200, 15, DivideColor(255,51,51), "scorebar_ussr", 1, 1);
				self Create_Promod_Text(getName(level.players[a]),"NAME","axis","default", 1.6, "RIGHT", "RIGHT",  -10 + self.AIO["safeArea_X"]*-1, 0 + level.players[a].MyPosition*16 + self.AIO["safeArea_Y"], 2, 1, (1,1,1), getName(level.players[a]));
			}
		}
	}
	self thread CreateHUDs();
}
CreateHUDs()
{
	myTeam = self.pers["team"];
	enemyTeam = getOtherTeam( myTeam );
		
	while(self.show_COD_Casting)
	{
		for(i=0;i<level.players.size;i++)
		{
			joueur = level.players[i];
			
			if(isDefined(joueur.MyPosition))
			{
				if(joueur.team == myTeam && isDefined(self.Promod_rect[getName(joueur)]["HUD"]["allies"]))
				{
					 
					if(joueur.sessionstate != "playing" || !isDefined(joueur.health) || !isDefined(joueur.maxhealth) || !isAlive(joueur) || joueur.team == "spectator")
					{
						
						self.Promod_rect[getName(joueur)]["HUD"]["allies"] AdvancedDestroy(self);
						self.Promod_text[getName(joueur)]["NAME"]["allies"].color = DivideColor(130,130,130);
					}
					else
					{
						self.Promod_rect[getName(joueur)]["HUD"]["allies"].alpha = 1;
						self.Promod_text[getName(joueur)]["NAME"]["allies"].color = (1,1,1);
					}
					
					width = int(joueur.health/joueur.maxhealth*155);
					
					if(width <= 0) width = 1;
				
					self.Promod_rect[getName(joueur)]["HUD"]["allies"] setShader("scorebar_usmc", width, 15);
				}
				
				else if(joueur.team == enemyTeam && isDefined(self.Promod_rect[getName(joueur)]["HUD"]["axis"]))
				{
					 
					if(joueur.sessionstate != "playing" || !isDefined(joueur.health) || !isDefined(joueur.maxhealth) || !isAlive(joueur) || joueur.team == "spectator")
					{
						self.Promod_text[getName(joueur)]["NAME"]["axis"].color = DivideColor(130,130,130);
						self.Promod_rect[getName(joueur)]["HUD"]["axis"] AdvancedDestroy(self);
					}
					else
					{
						self.Promod_rect[getName(joueur)]["HUD"]["axis"].alpha = 1;
						self.Promod_text[getName(joueur)]["NAME"]["axis"].color = (1,1,1);
					}
					width = int(joueur.health/joueur.maxhealth*155);
					
					if(width <= 0) width = 1;
				
					self.Promod_rect[getName(joueur)]["HUD"]["axis"] setShader("scorebar_ussr", width, 15);	
				}
			}
			
		}
		wait .05;
	}
}
HUD_Controler()
{
	self endon("disconnect");
	
	while(!level.gameEnded)
	{ 
		self waittill("REFRESH_HUDS");

		
		if(isDefined(self.HUD["TEXT"]["DROPBOMB"])) self.HUD["TEXT"]["DROPBOMB"] setpoint("LEFT","LEFT",0 + self.AIO["safeArea_X"], -50 + self.AIO["safeArea_Y"]);
		
		for(a=0;a<level.players.size;a++)
		{
			if(isDefined(self.stopWatch)) self.stopWatch setpoint("BOTTOM RIGHT", "BOTTOM RIGHT", -20 + self.AIO["safeArea_X"], -70 + (self.AIO["safeArea_Y"]*-1));	
			if(isDefined(self.Promod_rect[getName(level.players[a])]["HUD"]["allies"])) self.Promod_rect[getName(level.players[a])]["HUD"]["allies"] setpoint("LEFT", "LEFT", 0 + self.AIO["safeArea_X"], 0 + level.players[a].MyPosition*16 + self.AIO["safeArea_Y"]);
			if(isDefined(self.Promod_text[getName(level.players[a])]["NAME"]["allies"])) self.Promod_text[getName(level.players[a])]["NAME"]["allies"] setpoint("LEFT", "LEFT",  10 + self.AIO["safeArea_X"], 0+level.players[a].MyPosition*16 + self.AIO["safeArea_Y"]);
			if(isDefined(self.Promod_rect[getName(level.players[a])]["HUD"]["axis"])) self.Promod_rect[getName(level.players[a])]["HUD"]["axis"] setpoint("RIGHT", "RIGHT", 0 + self.AIO["safeArea_X"]*-1, 0 + level.players[a].MyPosition*16 + self.AIO["safeArea_Y"]);
			if(isDefined(self.Promod_text[getName(level.players[a])]["NAME"]["axis"])) self.Promod_text[getName(level.players[a])]["NAME"]["axis"] setpoint("RIGHT", "RIGHT",  -10 + self.AIO["safeArea_X"]*-1, 0+level.players[a].MyPosition*16 + self.AIO["safeArea_Y"]);
		}
	}
	
}
On_disconnect()
{
	disc = getName(self);
	
	self waittill("disconnect");

	if(self.team == "allies") level.AlliesPosition[self.MyPosition] = undefined;
	else if(self.team == "axis") level.AxisPosition[self.MyPosition] = undefined;
	
	self.MyPosition = undefined;
	
	for(i=0;i<level.players.size;i++)
	{
		player = level.players[i];
	
		if(isDefined(player.Promod_rect[disc]["HUD"]["allies"])) player.Promod_rect[disc]["HUD"]["allies"] destroy();
		if(isDefined(player.Promod_text[disc]["NAME"]["allies"])) player.Promod_text[disc]["NAME"]["allies"] destroy();
		if(isDefined(player.Promod_rect[disc]["HUD"]["axis"])) player.Promod_rect[disc]["HUD"]["axis"] destroy();
		if(isDefined(player.Promod_text[disc]["NAME"]["axis"])) player.Promod_text[disc]["NAME"]["axis"] destroy();
	}
}




















