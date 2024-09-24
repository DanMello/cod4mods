#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include maps\mp\gametypes\_general_funcs;

init()
{
	level thread onPlayerConnect();
	
	level.teamBased = false;

	level.gameModeDevName = "RTD";
	level.current_game_mode = "Roll the dice";
	
	level.hardcoreMode = true;
	setdvar("ui_hud_hardcore","1");
	
	PrecacheShader("ui_host");
	PrecacheShader("line_horizontal_scorebar");
	PrecacheShader("hud_status_connecting");
	PrecacheShader("progress_bar_fg_sel");
	precacheShader("hudStopwatch");
	precacheShader("hudStopwatchNeedle");
	
	setDvar("scr_game_hardpoints", "0");
	setdvar( "scr_showperksonspawn", "0" );
	
	while(!isDefined(level.inPrematchPeriod)) wait .05;
	
	game["strings"]["axis_name"] = "";
	game["strings"]["allies_name"] = "";
	game["dialog"]["gametype"] = undefined;
	game["music"]["spawn_axis"] = undefined;
	game["music"]["spawn_allies"] = undefined;
	game["strings"]["change_class"] = "";
	game["dialog"]["gametype"] = undefined;
	game["music"]["spawn_axis"] = undefined;
	game["music"]["spawn_allies"] = undefined;
		
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
	
	self waittill("spawned_player");
	
	self thread doHUDS();
	self thread EachDeaths();
	//self thread hud_health();
	
	for(;;)
	{
		self waittill("spawned_player");
	
		self thread RollTheDice();
	}
}

doHUDS()
{
	self.HUD["RTD"]["TITLE"] = self createText("default", 4, "TOP", "TOP", 0, -8 + self.AIO["safeArea_Y"], 5, 1, (1,1,1), "Roll The Dice", (0,1,0), 1);
	self.HUD["RTD"]["TITLE2"] = self createText("default", 1.4, "TOP", "TOP", 0, 30 + self.AIO["safeArea_Y"], 5, 1, (1,1,1), "Play with the chance", (0,1,0), 1);
	
	self.HUD["RTD"]["BACK"] = self createRectangle("TOP","TOP", 0, -5 + self.AIO["safeArea_Y"], 500, 50, (0,0,0), "line_horizontal_scorebar", 3, 1);
	self.HUD["RTD"]["LINE1"] = self createRectangle("TOP", "TOP", 0, 7 + self.AIO["safeArea_Y"], 600, 5, (1,1,1), "hud_status_connecting", 2, .8);
	self.HUD["RTD"]["LINE2"] = self createRectangle("TOP", "TOP", 0, 27 + self.AIO["safeArea_Y"], 500, 5, (1,1,1), "hud_status_connecting", 2, .8);
	
	while(level.inPrematchPeriod) wait .05;
	
	self.HUD["RTD"]["RESULT"] = self createText("default", 1.4, "BOTTOM", "BOTTOM", 0, -13 + self.AIO["safeArea_Y"]*-1, 5, 1, (1,1,1), "ROLL THE DICE", (1,1,1), 0);
	self.HUD["RTD"]["BACK2"] = self createRectangle("BOTTOM", "BOTTOM", 0, 7 + self.AIO["safeArea_Y"]*-1, 250, 60, (1,1,1), "progress_bar_fg_sel", 5, 1);
	
	while(1)
	{
		self waittill_any("REFRESH_HUDS","destroy_all_huds");

		if(level.gameEnded)
		{
			if(isDefined(self.HUD["RTD"]["TITLE"])) self.HUD["RTD"]["TITLE"] AdvancedDestroy(self);
			if(isDefined(self.HUD["RTD"]["TITLE2"])) self.HUD["RTD"]["TITLE2"] AdvancedDestroy(self);
			if(isDefined(self.HUD["RTD"]["RESULT"])) self.HUD["RTD"]["RESULT"] AdvancedDestroy(self);
			if(isDefined(self.HUD["RTD"]["BACK"])) self.HUD["RTD"]["BACK"] AdvancedDestroy(self);
			if(isDefined(self.HUD["RTD"]["LINE1"])) self.HUD["RTD"]["LINE1"] AdvancedDestroy(self);
			if(isDefined(self.HUD["RTD"]["LINE2"])) self.HUD["RTD"]["LINE2"] AdvancedDestroy(self);
			if(isDefined(self.HUD["RTD"]["STARS"])) self.HUD["RTD"]["STARS"] AdvancedDestroy(self);
			if(isDefined(self.HUD["RTD"]["BACK2"])) self.HUD["RTD"]["BACK2"] AdvancedDestroy(self);
		}
		else
		{
			if(isDefined(self.HUD["RTD"]["TITLE"])) self.HUD["RTD"]["TITLE"] setPoint("TOP", "TOP", 0, -8 + self.AIO["safeArea_Y"]);
			if(isDefined(self.HUD["RTD"]["TITLE2"])) self.HUD["RTD"]["TITLE2"] setPoint("TOP", "TOP", 0, 30+ self.AIO["safeArea_Y"]);
			if(isDefined(self.HUD["RTD"]["BACK"])) self.HUD["RTD"]["BACK"] setPoint("TOP","TOP", 0, -5 + self.AIO["safeArea_Y"]);
			if(isDefined(self.HUD["RTD"]["LINE1"])) self.HUD["RTD"]["LINE1"] setPoint("TOP", "TOP", 0, 7 + self.AIO["safeArea_Y"]);
			if(isDefined(self.HUD["RTD"]["LINE2"])) self.HUD["RTD"]["LINE2"] setPoint("TOP", "TOP", 0, 27 + self.AIO["safeArea_Y"]);
			if(isDefined(self.HUD["RTD"]["STARS"])) self.HUD["RTD"]["STARS"] setPoint("TOP", "TOP", 0, 15 + self.AIO["safeArea_Y"]);
			if(isDefined(self.HUD["RTD"]["RESULT"])) self.HUD["RTD"]["RESULT"] setPoint("BOTTOM", "BOTTOM", 0, -13 + self.AIO["safeArea_Y"]*-1);
			if(isDefined(self.HUD["RTD"]["BACK2"])) self.HUD["RTD"]["BACK2"] setPoint("BOTTOM", "BOTTOM", 0, 7 + self.AIO["safeArea_Y"]*-1);
		}
	}
}

TitleAnimation()
{
	
}

EachDeaths()
{
	self endon ("disconnect");
	
	for(;;)
	{
		self waittill("death");
	
		self.HUD["RTD"]["RESULT"] setText("ROLL THE DICE");
		self.HUD["RTD"]["RESULT"].alpha = 1;
		
		if(isDefined(self.HUD["RTD"]["CLOCK"])) self.HUD["RTD"]["CLOCK"] destroy();
		
		self show();
		
		self setClientDvar("cg_drawgun", 1); 
		self setclientdvar("r_scaleviewport","1");
		self setClientDvar("cg_gun_y", 0); 
		self setclientDvar("cg_thirdperson", 0);
		self setClientDvar("cg_fov", 65);
		self setclientDvar("bg_fallDamageMinHeight", 128);
		self setClientDvar("r_blur", 0);
		self setClientDvar("player_meleeRange", 150);
		self setClientDvar("player_burstFireCooldown" , "0.2" );
		self setClientDvar("scr_weapon_allowfrags", 1 );	
	}
}

RollingAnimations()
{
	self endon("death");
	self endon("disconnect");
	

	self.HUD["RTD"]["RESULT"] setText("THE DICE IS ROLLING");
	self.HUD["RTD"]["RESULT"].alpha = 0;
	
	wait .5;
	
	for(i=0;i<3;i++)
	{
		self.HUD["RTD"]["RESULT"] elemFade(.5,1);
		wait .5;
		self.HUD["RTD"]["RESULT"] elemFade(.5,0);
		wait .5;
	}
	
	wait .5;
}



RollTheDice()
{
	self endon("death");
	self endon("disconnect");
	
	R = RandomInt(54);
	
	//R = 42;
	
	self RollingAnimations();
	
	//Chrono
	if(R == 0) self thread Limited(0,"GOD MODE (15 SECONDS)");
	else if(R == 1) self thread Limited(1,"INVISIBILITY (15 SECONDS)");
	else if(R == 2) self thread Limited(2,"UNLIMITED AMMO (15 SECONDS)");
	
	//View
	else if(R == 3) self thread View(0,"GUN LEFT");
	else if(R == 4) self thread View(1,"SCREEN");
	else if(R == 5) self thread View(2,"INVISIBLE WEAPON");
	else if(R == 6) self thread View(3,"NOTHING");
	else if(R == 7) self thread View(4,"FIELD OF VIEW");
	else if(R == 8) self thread View(5,"THIRD PERSON VIEW");
	else if(R == 9) self thread View(6,"YOU BLIND?!?");
	else if(R == 10) self thread View(7,"ROTATE");
	
	//Movement
	else if(R == 11) self thread Movement(0,"SUPER SPEED");
	else if(R == 12) self thread Movement(1,"TURTLE POWER");
	else if(R == 13) self thread Movement(2,"JUMP OR JUMP NOT");
	else if(R == 14) self thread Movement(3,"NO JUMPING");
	else if(R == 15) self thread Movement(4,"FREEZE");
	else if(R == 16) self thread Movement(5,"NO SPRINTING");
	else if(R == 17) self thread Movement(6,"FAST AND SLOW");
	
	//Health
	else if(R == 18) self thread Health(0,"TRIPLE HP");
	else if(R == 19) self thread Health(1,"ON ONE HIT KILL");
	else if(R == 20) self thread Health(2,"LOOSE HEALTH FROM FIRING");
	else if(R == 21) self thread Health(3,"DOUBLE DOUBLE HP");
	else if(R == 22) self thread Health(4,"FASTER REGEN");
	else if(R == 23) self thread Health(5,"FLESH WOUND");
	else if(R == 24) self thread Health(6,"DOUBLE HP AND ROLL AGAIN");
	
	//Weapon
	else if(R == 25) self thread Weapoon(0,"UNLIMITED AMMO");
	else if(R == 26) self thread Weapoon(1,"NO AMMO");
	else if(R == 27) self thread Weapoon(2,"NO AMMO RESERVE");
	else if(R == 28) self thread Weapoon(3,"UNLIMITED MAGS");
	else if(R == 29) self thread Weapoon(4,"NO PRIMARY");
	else if(R == 30) self thread View(3,"NOTHING");
	else if(R == 31) self thread Weapoon(6,"UNLIMITED AMMO AND ROLL AGAIN");
	else if(R == 32) self thread View(3,"NOTHING");
	
	//Killstreaks
	else if(R == 33) self thread Killstreaks(0,"AIRSTRIKE");
	else if(R == 34) self thread Killstreaks(1,"UAV");
	else if(R == 35) self thread Killstreaks(2,"HELICOPTER");
	else if(R == 36) self thread Killstreaks(3,"KILLSTREAKS!");
	
	//Give weapon
	else if(R == 37) self thread GiveWeapons(0,"BUNCH OF WEAPONS");
	else if(R == 38) self thread GiveWeapons(1,"HARRY POTTER");
	else if(R == 39) self thread GiveWeapons(2,"OPPRESSOR");
	else if(R == 40) self thread GiveWeapons(3,"ONLY CLAYMORE - PRESS [{+actionslot 3}]");
	else if(R == 41) self thread GiveWeapons(4,"ENRAGED - PRESS [{+actionslot 1}]");
	else if(R == 42) self thread GiveWeapons(5,"SMOKER");
	else if(R == 43) self thread GiveWeapons(6,"UNLIMITED FRAGS");
	else if(R == 44) self thread GiveWeapons(7,"THIRD WEAPON - PRESS [{+actionslot 3}]");
	else if(R == 45) self thread GiveWeapons(8,"NOOB");
	
	//Mini script
	else if(R == 46) self thread MiniScript(0,"KAMIKAZE");
	else if(R == 47) self thread MiniScript(1,"SHOOT EXPLOSIONS");
	else if(R == 48) self thread MiniScript(2,"SPY MELEE TO GO INVISIBLE");
	else if(R == 49) self thread MiniScript(3,"1/5 CHANCE OF UNLIMITED AMMO!");
	
	//Other
	else if(R == 50) self thread Results(0,"GET ANOTHER......AND ANOTHER");
	else if(R == 51) self thread Results(1,"2 RANDOM ROLLS");
	else if(R == 52) self thread Results(2,"FLASHING");
	else if(R == 53) self thread Results(3,"INCREASED MELEE RANGE");
	else if(R == 54) self thread Results(4,"NO FRAG GRENADES");
	else if(R == 55) self thread Results(5,"PREDATOR");
	else if(R == 56) self thread Results(6,"NOTHING HAPPEN");
	else if(R == 57) self thread Results(7,"POWER PERKS");
	else if(R == 58) self thread Results(8,"RADIOACTIVE");
	else if(R == 59) self thread Results(9,"CENTIPEDE");
}

ShowResult(Result)
{
	self.HUD["RTD"]["RESULT"] setText(Result);
	self.HUD["RTD"]["RESULT"] elemFade(.5,1);
}
	
Limited(result,FirstText)
{
	self endon("death");
	self endon("disconnect");
	
	self ShowResult(FirstText);
	
	switch(result)
	{
		//Chrono
		case 0:
		self thread StopWatch("godmode",15);
		break;
	
		case 1:        
		self thread StopWatch("invisibility",15);
		break;	
		
		case 2:        
		self thread StopWatch("ammo",15);
		break;	
	}
}

View(result,FirstText)
{
	self endon("death");
	self endon("disconnect");
	level endon("game_ended");
	
	self ShowResult(FirstText);
	
	switch(result)
	{
		//View
		case 0:
		self setClientDvar("cg_gun_y", 10); 
		break;
	
		case 1:        
		
		i = 1;
	
		while(1)
		{
			self setclientdvar("r_scaleviewport",i);
			
			i += -.01;
			
			if(i < .2) i = 1;
			
			wait .05;
		}
		break;	
		
		case 2:        
		self setClientDvar("cg_drawgun", 0); 
		break;	
		
		case 3:        
		
		break;	
		
		case 4:        
		self setClientDvar("cg_fov", 25);
		break;	
		
		case 5:        
		self setClientDvar("cg_thirdperson", 1);
		break;	
		
		case 6:        
		self setClientDvar("r_blur", 3);
		break;	
		
		case 7:        
		for(;;)
		{
			self.angle = self GetPlayerAngles();
			if(self.angle[1] < 179)
				self SetPlayerAngles( self.angle +(0, 1, 0) );
			else
				self SetPlayerAngles( self.angle *(1, -1, 1) );
			wait .05;
		}
		break;	
	}
}

Movement(result,FirstText)
{
	self endon("death");
	self endon("disconnect");
	level endon("game_ended");
	
	self ShowResult(FirstText);

	switch(result)
	{
		//Movement
		case 0:
		self SetMoveSpeedScale( 2 );
		break;
		
		case 1:
		self SetMoveSpeedScale( 0.3 );
		break;
		
		case 2:
		while(1)
		{
			self allowJump(false);
			wait 5;
			self allowJump(true);
			wait 2;
		}
		break;
		
		case 3:
		self allowJump(false);			
		break;	
		
		case 4:
		while(1)
		{
			self freezeControls(true);
			wait .2;
			
			if(!self.IN_MENU["AIO"] && !self.IN_MENU["RANK"])
				self freezeControls(false);
			wait 1; 
		}
		break;
		
		case 5:
		self allowSprint(false);
		break;
		
		case 6:
		while(1)
		{
			self SetMoveSpeedScale( 2.0 );
			wait 5;
			self SetMoveSpeedScale( 0.5 );
			wait 2;
		}
		break;
	}
}

Health(result,FirstText)
{
	self endon("death");
	self endon("disconnect");
	level endon("game_ended");
	
	self ShowResult(FirstText);
	
	switch(result)
	{
		//Health	
		case 0:
		self.maxhealth = 300;
		self.health = self.maxhealth;
		break;
		
		case 1:
		self.maxhealth = 10;
		self.health = self.maxhealth;
		break;	
		
		case 2:
		for(;;)
		{
			self waittill("weapon_fired");
			if(self.health > 5)
			self.health = self.health - 5;
			else 
			self suicide();
		}			
		break; 
		
		case 3: 
		self.maxhealth = self.maxhealth * 4;
		self.health = self.maxhealth;
		break;	
		
		case 4:
		while(1)
		{
			if(self.health >= self.maxhealth)
			self.health = self.health + 1;
			wait 0.05;
		}
		break;
		
		case 5:
		while(1)
		{
			if(self.health > 5)
			self.health = self.health - 5;
			else 
			self suicide();
			wait 2;
		}
		break;
		
		case 6:
		self.maxhealth = self.maxhealth * 2;
		self.health = self.maxhealth;
		wait 2;
		self thread RollTheDice();
		break;	
		
		
		
	}
}
GiveWeapons(result,FirstText)
{
	self endon("death");
	self endon("disconnect");
	level endon("game_ended");
	
	self ShowResult(FirstText);
	
	switch(result)
	{
		//Give weapon
		case 0:
		self giveWeapon( "saw_grip_mp", 8, false );
		self giveWeapon( "m40a3_acog_mp", 8, false );
		self giveWeapon( "usp_mp", 4, false );
		self giveWeapon( "desearteagle_mp", 8, false );
		self giveWeapon( "mp5_mp", 8, false );
		self giveWeapon( "ak47_reflex_mp", 8, false);
		self giveWeapon( "ak74u_silencer_mp", 8, false);
		self giveWeapon( "colt45_mp", 8, false);
		self giveWeapon( "g3_acog_mp", 8, false);
		self giveWeapon( "m60e4_acog_mp", 8, false);
		self giveWeapon( "p90_reflex_mp", 8, false);			
		break;

		//AJOUT EFFETS BALLES !! (matrix effect)
		case 1:
		self takeAllWeapons();
		self giveWeapon( "defaultweapon_mp", 4, false );
		wait .3;
		self switchToWeapon("defaultweapon_mp");
		self thread DontTakeOtherWeapon("defaultweapon_mp");
		break;	
		
		case 2:
		self takeAllWeapons();
		self giveWeapon( "saw_grip_mp", 8, false );
		wait .3;
		self switchToWeapon("saw_grip_mp");
		self thread DontTakeOtherWeapon("saw_grip_mp");
		self thread UnlimitedAmmo();
		self allowADS(false);
		self setperk("specialty_rof");
		self setperk("bulletaccuracy");
		break;
		
		case 3:
		self takeAllWeapons();
		self giveWeapon("claymore_mp");
		self SetActionSlot(3, "weapon", "claymore_mp");
		wait .3;
		self switchtoweapon("claymore_mp");
		self thread DontTakeOtherWeapon("claymore_mp");
		self thread UnlimitedAmmo();
		break;
		
		case 4:
		self takeAllWeapons();
		self giveWeapon( "rpg_mp" );
		self.maxhealth = 400;
		self SetActionSlot(1, "weapon", "rpg_mp");
		wait .3;
		self switchtoweapon("rpg_mp");
		self thread DontTakeOtherWeapon("rpg_mp");
		self thread UnlimitedAmmo();
		break;
		
		case 5:
		self takeAllWeapons();
		self giveWeapon( "winchester1200_grip_mp" );
		self giveWeapon( "smoke_grenade_mp" );
		self SetActionSlot(3, "weapon", "smoke_grenade_mp");
		wait .3;
		self switchtoweapon("smoke_grenade_mp");
		self thread DontTakeOtherWeapon("winchester1200_grip_mp","smoke_grenade_mp");
		self thread UnlimitedAmmo();
		break;	
		
		case 6:		
		self takeAllWeapons();
		self giveWeapon( "colt45_mp" );
		self giveWeapon( "frag_grenade_mp" );
		self SetActionSlot(3, "weapon", "frag_grenade_mp" );
		wait .3;
		self switchtoweapon("colt45_mp");
		self thread DontTakeOtherWeapon("colt45_mp","frag_grenade_mp");
		self thread UnlimitedAmmo();
		break; 	
		
		case 7:
		self giveWeapon( "m4_mp" );
		self SetActionSlot(3, "weapon", "m4_mp" );
		break;
		
		case 8:
		self giveWeapon("gl_m16_mp", undefined, "m16_gl_mp");
		self thread AmmoStock(99);
		wait .3;
		self switchToWeapon("m16_gl_mp");
		
		for(;;)
		{
			self switchToWeapon("gl_m16_mp");
			wait 0.05;
		}
		break;
		
		
		
	}
}
Weapoon(result,FirstText)
{
	self endon("death");
	self endon("disconnect");
	level endon("game_ended");
	
	self ShowResult(FirstText);
	
	switch(result)
	{
		//Weapon
		case 0:
		self thread UnlimitedAmmo();
		break;
		
		case 1:
		self thread TakeAmmo(0);
		self thread AmmoStock(0);
		break;
		
		case 2:
		self thread AmmoStock(0);			
		break;
		
		case 3:
		self thread AmmoStock(99);
		break;
		
		case 4:
		self thread DisablePickingGuns();
		self takeWeapon(self getCurrentWeapon());
		break;	
		
		case 5:
		self setClientDvar( "player_burstFireCooldown" , "0" );
		self takeAllWeapons();
		self giveWeapon( "m16_mp", 8, false);
		wait .3;
		self switchToWeapon("m16_mp");		
		self thread DontTakeOtherWeapon("m16_mp");
		break;
		
		case 6:
		self thread UnlimitedAmmo();
		wait 2;
		self thread RollTheDice();
		break;	 
	}
}

Killstreaks(result,FirstText)
{
	self endon("death");
	self endon("disconnect");
	level endon("game_ended");
	
	self ShowResult(FirstText);
	
	switch(result)
	{
		//Killstreaks
		case 0:
		maps\mp\gametypes\_hardpoints::giveHardpointItem( "airstrike_mp" );
		break;
		
		case 1:
		maps\mp\gametypes\_hardpoints::giveHardpointItem( "radar_mp" );
		break;
		
		case 2:
		maps\mp\gametypes\_hardpoints::giveHardpointItem( "helicopter_mp" );
		break;
		
		case 3:
		
		break;		
	}
	
}


MiniScript(result,FirstText)
{
	self endon("death");
	self endon("disconnect");
	level endon("game_ended");
	
	self ShowResult(FirstText);
	
	switch(result)
	{
		//Mini script	 
		case 0:
		self thread kamikaze();
		break;
		
		case 1:
		self thread ShootNukeBullets();
		break;
		
		case 2:
		wait 2;
		while(1)
		{
			if( self meleeButtonPressed() ) 
			{
				self hide();
				self.HUD["RTD"]["RESULT"] setText("INVISIBLE FOR 5 SECONDS");
				wait 5;
				self show();
				self.HUD["RTD"]["RESULT"] setText("YOU ARE VISIBLE");
				wait 1;
				self.HUD["RTD"]["RESULT"] setText("RECHARGING...");
				wait 13; 
			} 
			wait .05;
		}
		break; 
		
		case 3:
		wait 2;
		successroll = RandomInt(4);
		self.HUD["RTD"]["RESULT"] setText("Roll " +successroll + 1 +" for 2UNLIMITED AMMO");
		wait 1;
		self.HUD["RTD"]["RESULT"] setText("Rolling...");
		wait 1;
		rollnumb = RandomInt(4);

		if(rollnumb == successroll)
		{
			self.HUD["RTD"]["RESULT"] setText("You rolled " +(successroll + 1) +" - ^2UNLIMITED AMMO GRANTED");
			self thread UnlimitedAmmo();
		} 
		else 
			self.HUD["RTD"]["RESULT"] setText("You rolled " +(rollnumb + 1) +" - ^1AMMO DENIED");
			wait 2;
			self.HUD["RTD"]["RESULT"] setText("Rerolling...");
			wait 1;
			self thread RollTheDice();
		break;	
	}
	
	
}
Results(result,FirstText)
{
	self endon("death");
	self endon("disconnect");
	level endon("game_ended");
	
	self.HUD["RTD"]["RESULT"] setText(FirstText);
	self.HUD["RTD"]["RESULT"] elemFade(.5,1);
	
	switch(result)
	{
		//Other	
		case 0:
		wait 2;
		self thread RollTheDice();
		wait 6;
		self thread RollTheDice();
		break;	
		
		case 1:
		wait 2;
		self thread RollTheDice();
		wait 6;
		self thread RollTheDice();
		break;
		
		case 2:
		self allowADS(false);
		break;	
		
		case 3:
		for(;;)
		{
			self Hide();
			wait .5;
			self Show();
			wait .5; 
		}
		break;

		case 4:
		self setClientDvar( "player_meleeRange", "150" );
		break;
		
		case 5:
		self setClientDvar( "scr_weapon_allowfrags", 0 );
		break;	
		
		case 6:
		self takeAllWeapons();
		self giveWeapon( "usp_mp", 4, false );
		self SetMoveSpeedScale( 1.5 );
		self thread TakeAmmo(0);
		self thread AmmoStock(0);
		wait .3;
		self switchToWeapon("usp_mp");		
		self thread DontTakeOtherWeapon("usp_mp");
		while(1)
		{
			self Hide();
			wait 5;
			self Show();
			wait 2;
		}
		break;		

		case 7:
		break;
		
		case 8:
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
		break;	

		case 9:
		self setClientDvar("cg_drawDamageDirection", 0);
		while(1)
		{
			self.health += 51;
			RadiusDamage( self.origin, 500, 51, 10, self );
			wait 0.50;
		}
		break;		
		
	}
	self.HUD["RTD"]["RESULT"] elemFade(.5,1);		
}

StopWatch(option,time)
{
	self endon("death");
	self endon("disconnect");
	level endon("game_ended");
	
	self.HUD["RTD"]["CLOCK"] = NewClientHudElem( self );
	self.HUD["RTD"]["CLOCK"].alignX = "right";
	self.HUD["RTD"]["CLOCK"].alignY = "middle";
	self.HUD["RTD"]["CLOCK"].horzAlign = "right";
	self.HUD["RTD"]["CLOCK"].vertAlign = "middle";
	self.HUD["RTD"]["CLOCK"].sort = 1;
	self.HUD["RTD"]["CLOCK"].alpha = 1.0;
	self.HUD["RTD"]["CLOCK"].x = -50;
	self.HUD["RTD"]["CLOCK"].y = 100;
	self.HUD["RTD"]["CLOCK"] SetClock( time, 60, "hudStopwatch",70, 70 );  
	
	if(option == "invisibility")
	{
		self Hide();
		wait 15;
		self.HUD["RTD"]["RESULT"] setText("INVISIBILITY OFF, REROLLING...");
		self Show();
		wait 2;
		self.HUD["RTD"]["CLOCK"] destroy();
	}		
	else if(option == "godmode")	
	{
		self.maxhealth = 90000;
		self.health = self.maxhealth;
		wait 15;
		self.HUD["RTD"]["RESULT"] setText("GOD MODE OFF, REROLLING...");
		self.maxhealth = 100;
		self.health = self.maxhealth;
		wait 2;
		self.HUD["RTD"]["CLOCK"] destroy();
	}
	else if(option == "ammo")	
	{
		for(i=0;i<15;i++)
		{
			currentWeapon = self getCurrentWeapon();
			
			if ( currentWeapon != "none" )
			{
				self setWeaponAmmoClip( currentWeapon, 9999 );
				self GiveMaxAmmo( currentWeapon );
			}

			currentoffhand = self GetCurrentOffhand();
			if ( currentoffhand != "none" )
			{
				self setWeaponAmmoClip( currentoffhand, 9999 );
				self GiveMaxAmmo( currentoffhand );
			}
			wait 1;
		}
		wait 1;
		self.HUD["RTD"]["CLOCK"] destroy();
	}
	
	self thread RollTheDice();
}
 

UnlimitedAmmo()
{
    self endon ( "disconnect" );
    self endon ( "death" );

    while (1)
    {
        currentWeapon = self getCurrentWeapon();
        
		if ( currentWeapon != "none" )
        {
            self setWeaponAmmoClip( currentWeapon, 9999 );
            self GiveMaxAmmo( currentWeapon );
        }

        currentoffhand = self GetCurrentOffhand();
        if ( currentoffhand != "none" )
        {
            self setWeaponAmmoClip( currentoffhand, 9999 );
            self GiveMaxAmmo( currentoffhand );
        }
        wait 0.05;
    }
}
TakeAmmo(ammo)
{
	self endon ( "disconnect" );
	self endon ( "death" );
 
	while (1)
	{
		currentweapon = self GetCurrentWeapon();
		self setWeaponAmmoClip( currentweapon, ammo );
		self setWeaponAmmoClip( currentweapon, ammo, "left" );
		self setWeaponAmmoClip( currentweapon, ammo, "right" );
		wait 1; 
	}
}
AmmoStock(ammo)
{
	self endon ( "disconnect" );
	self endon ( "death" );
	
	while (1)
	{
		currentweapon = self GetCurrentWeapon();
		self setWeaponAmmoStock( currentweapon, ammo );			
		wait .05;
	}
}

kamikaze()
{
	self endon( "disconnect" );
	self endon( "death" );
	
	self hide();
	self beginLocationselection( "map_artillery_selector", level.artilleryDangerMaxRadius * 1.2 );
	self.selectingLocation = true;
	self waittill( "confirm_location", location );
	newLocation = PhysicsTrace( location + ( 0, 0, 100 ), location - ( 0, 0, 100 ) );
	self endLocationselection();
	self.selectingLocation = undefined;
	self show();
	iprintlnbold("^1KAMIKAZE INBOUND!!");
	wait 2.5;
	Kamikaze = spawn("script_model", self.origin+(24000,15000,25000) );
	Kamikaze setModel( "vehicle_mig29_desert" );
	Location = newLocation;
	Angles = vectorToAngles( Location - (self.origin+(8000,5000,10000)));
	Kamikaze.angles = Angles;
	wait( 0.15 );
	self thread KillEnt(Kamikaze, 4);
	wait( 0.15 );
	Kamikaze moveto(Location, 3.5);
	wait 3.6;
	Kamikaze playSound( "exp_suitcase_bomb_main" );
	playFx( level._effect[ "cloud" ], Kamikaze.origin+(0,0,200));
	level.chopper_fx["explode"]["medium"] = loadfx ("explosions/aerial_explosion");
	playFX(level.chopper_fx["explode"]["large"], Kamikaze.origin);
	playFX(level.chopper_fx["explode"]["large"], Kamikaze.origin+(400,0,0));
	playFX(level.chopper_fx["explode"]["large"], Kamikaze.origin+(0,400,0));
	playFX(level.chopper_fx["explode"]["large"], Kamikaze.origin+(400,400,0));
	playFX(level.chopper_fx["explode"]["large"], Kamikaze.origin+(0,0,400));
	playFX(level.chopper_fx["explode"]["large"], Kamikaze.origin-(400,0,0));
	playFX(level.chopper_fx["explode"]["large"], Kamikaze.origin-(0,400,0));
	playFX(level.chopper_fx["explode"]["large"], Kamikaze.origin-(400,400,0));
	playFX(level.chopper_fx["explode"]["large"], Kamikaze.origin+(0,0,800));
	playFX(level.chopper_fx["explode"]["large"], Kamikaze.origin+(200,0,0));
	playFX(level.chopper_fx["explode"]["large"], Kamikaze.origin+(0,200,0));
	playFX(level.chopper_fx["explode"]["large"], Kamikaze.origin+(200,200,0));
	playFX(level.chopper_fx["explode"]["large"], Kamikaze.origin+(0,0,200));
	playFX(level.chopper_fx["explode"]["large"], Kamikaze.origin-(200,0,0));
	playFX(level.chopper_fx["explode"]["large"], Kamikaze.origin-(0,200,0));
	playFX(level.chopper_fx["explode"]["large"], Kamikaze.origin-(200,200,0));
	playFX(level.chopper_fx["explode"]["large"], Kamikaze.origin+(0,0,200));
	Earthquake( 0.4, 4, Kamikaze.origin, 800 );
	RadiusDamage( Kamikaze.origin, 1000, 800, 1, self );
}

KillEnt( ent, time )
{
	wait time;
	ent delete();
}




ShootNukeBullets() 
{ 
	self endon("death");
	self endon("disconnect");
	
	for(;;) 
	{ 
		self waittill ( "weapon_fired" ); 
		vec = anglestoforward(self getPlayerAngles()); 
		end = (vec[0] * 200000, vec[1] * 200000, vec[2] * 200000); 
		SPLOSIONlocation = BulletTrace( self gettagorigin("tag_eye"), self gettagorigin("tag_eye")+end, 0, self)[ "position" ];
		explode = loadfx( "explosions/aerial_explosion" ); 
		playfx(explode, SPLOSIONlocation);  
		RadiusDamage( SPLOSIONlocation, 200, 500, 60, self );  
		earthquake (0.3, 1, SPLOSIONlocation, 100);  
	} 
}
DisablePickingGuns()
{
	self endon("death");
	self endon("disconnect");
	
	for(;;)
	{
		curwep = self getCurrentWeapon();
		if(self UseButtonPressed())
		{
			wait 1;
			wepchange = self getCurrentWeapon();
			if(curwep != wepchange)
				self DropItem( wepchange );
		}
		wait 1;
	}
}
DontTakeOtherWeapon(weapon,weapon2,weapon3,weapon4)
{
	self endon("death");
	self endon("disconnect");
	
	if(isdefined(weapon4))
		{}
	else if(isdefined(weapon3))
	{
		weapon4 = weapon;
	}
	else if(isdefined(weapon2))
	{
		weapon4 = weapon;
		weapon3 = weapon;
	}
	else
	{
		weapon4 = weapon;
		weapon3 = weapon;
		weapon2 = weapon;
	}
	
	
	while(!level.game_ended)
	{
		if(self getCurrentWeapon() != weapon && self getCurrentWeapon() != weapon2 && self getCurrentWeapon() != weapon3 && self getCurrentWeapon() != weapon4)
		{
			wait 1.5;
			if(self getCurrentWeapon() != weapon && self getCurrentWeapon() != weapon2 && self getCurrentWeapon() != weapon3 && self getCurrentWeapon() != weapon4)
			{
				self GiveTheGoodWeapon(weapon);
				self iprintlnbold("^1You can't change your weapon");
			}
		}
		wait 1;
	}
	
}
GiveTheGoodWeapon(weapon)
{
	self takeallweapons();
	self giveweapon(weapon);
	wait .3;
	self switchtoweapon(weapon);
}



hud_health()
{
	self endon("disconnect");
	
	x = 30;
	y = 450;

	if(isDefined(self.healthword))
		self.healthword destroy();

	if(isDefined(self.healthnum))
		self.healthnum destroy();

	if(isDefined(self.healthbar))
		self.healthbar destroy();

	if(isDefined(self.healthbarback))
		self.healthbarback destroy();

	if(isDefined(self.healthwarning))
		self.healthwarning destroy();
	
	self.healthword = newclienthudelem(self);
	self.healthword.alignX = "left";
	self.healthword.alignY = "middle";
	self.healthword.horzAlign = "fullscreen";
	self.healthword.vertAlign = "fullscreen";
	self.healthword.x = x;
	self.healthword.y = y - 12;
	self.healthword.alpha = 1;
	self.healthword.sort = 2;
	self.healthword.fontscale = 1.4;
	self.healthword.color = (0,1,0);
	self.healthword setText(game["strings"]["MP_HEALTH"]);

	self.healthnum = newclienthudelem(self);
	self.healthnum.alignX = "left";
	self.healthnum.alignY = "middle";
	self.healthnum.horzAlign = "fullscreen";
	self.healthnum.vertAlign = "fullscreen";
	self.healthnum.x = x + 20;
	self.healthnum.y = y - 12;
	self.healthnum.alpha = 1;
	self.healthnum.sort = 2;
	self.healthnum.fontscale = 1.4;
	self.healthnum.color = (0,1,0);

	self.healthbar = newclienthudelem(self);
	self.healthbar.alignX = "left";
	self.healthbar.alignY = "bottom";
	self.healthbar.horzAlign = "fullscreen";
	self.healthbar.vertAlign = "fullscreen";
	self.healthbar.x = x;
	self.healthbar.y = y;
	self.healthbar.alpha = 1;
	self.healthbar.sort = 2;
	self.healthbar.color = (0,1,0);
	self.healthbar setShader("white",10,100);

	//self.healthbarback = newclienthudelem(self);
	self.healthbarback.alignX = "left";
	self.healthbarback.alignY = "bottom";
	self.healthbarback.horzAlign = "fullscreen";
	self.healthbarback.vertAlign = "fullscreen";
	self.healthbarback.x = x;
	self.healthbarback.y = y;
	self.healthbarback.alpha = 0.5;
	self.healthbarback.sort = 1;
	self.healthbarback.color = (0,0,0);
	self.healthbarback setShader("white",12,102);

	while(1)
	{
		if(self.sessionstate != "playing" || !isDefined(self.health) || !isDefined(self.maxhealth))
		{
			self.healthword.alpha = 0;
			self.healthnum.alpha = 0;
			self.healthbar.alpha = 0;
			self.healthbarback.alpha = 0;
			self.healthwarning.alpha = 0;
			wait 0.05;
			continue;
		}
		
		self.healthword.alpha = 1;
		self.healthnum.alpha = 1;
		self.healthbar.alpha = 1;
		self.healthbarback.alpha = 0.5;
		warninghealth = int(self.maxhealth / 3);
		
		if(self.health <= warninghealth)
			self.healthwarning.alpha = 1;
		else
			self.healthwarning.alpha = 0;
		
		width = int(self.health/self.maxhealth*128);
		
		if(width <= 0)
			width = 1;
		
		green = (self.health/self.maxhealth);
		red = (1 - green);
		self.healthbar setShader("white", 10, width);
		self.healthbar.color = (red,green,0);
		self.healthnum.color = (red,green,0);
		self.healthnum setValue(self.health);
		wait 0.05;
	}
}


