#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include common_scripts\utility;
#include maps\mp\gametypes\_general_funcs;

init()
{
	 
	level thread onPlayerConnect();
	level.hardcoreMode = true;
	setDvar( "ui_hud_hardcore", 1 );
	
	level.teamBased = false;
	level.gameModeDevName = "OITC";
	level.current_game_mode = "One in the chamber";
	setDvar( "ui_hud_hardcore", 1 );
	
	precacheShader("stance_stand");  
	precacheShader("ammo_counter_riflebullet");  
	level.endGameOnScoreLimit = false;
		
	level deletePlacedEntity("misc_turret");
	
	setDvar("scr_game_hardpoints", 0);
	setdvar("scr_showperksonspawn", 0 );
		
	while(!isDefined(level.inPrematchPeriod)) wait .05;	 
		 
		
	game["strings"]["change_class"] = "";
	game["strings"]["axis_name"] = "";
	game["strings"]["allies_name"] = "";
	game["dialog"]["gametype"] = undefined;
	game["music"]["spawn_axis"] = undefined;
	game["music"]["spawn_allies"] = undefined;
	game["icons"]["axis"] = undefined;
	game["icons"]["allies"] = undefined;
	
	maps\mp\gametypes\_rank::registerScoreInfo( "kill", 1 );
	maps\mp\gametypes\_rank::registerScoreInfo( "headshot", 1 );
	maps\mp\gametypes\_rank::registerScoreInfo( "melee", 1 );
	maps\mp\gametypes\_rank::registerScoreInfo( "suicide", 0 );
	
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
	
	self thread CheckAmmo();
	self thread HUD_Controls();
	
	
	for(;;)
	{
		self waittill("spawned_player");
		
		self.bullet = 1;
		self.hasRadar = true;
		self thread Setup();
	}
}
 

Setup()
{
	self endon("disconnect");
	self endon("death");
	
	self setClientDvar("cg_fov","70");
	self.maxhealth = 10;
	self.health = self.maxhealth;
	self notify("end_healthregen");
	
	self SetPerk( "specialty_bulletdamage" );
	self SetPerk( "specialty_bulletpenetration" );
	
	self.HUD["OITC"]["BULLETS_3"].alpha = 1;
	self.HUD["OITC"]["BULLETS_2"].alpha = 0;		
	self.HUD["OITC"]["BULLETS_1"].alpha = 0;
	
	self setClientDvar( "aim_automelee_enabled", "0" );
	self setClientDvar( "nightVisionDisableEffects", "1" );
	
	//wait .5;
	//self thread doDvars();

	for(;;)
	{
		self setWeaponAmmoClip("deserteagle_mp", self.bullet);
		wait .1;
		
		if(self.bullet == 1)	
			self.HUD["OITC"]["BULLETS_3"].alpha = 1;
		if(self.bullet == 2)	
			self.HUD["OITC"]["BULLETS_2"].alpha = 1;
		if(self.bullet == 3)	
			self.HUD["OITC"]["BULLETS_1"].alpha = 1;
		
		self.HUD["OITC"]["COUNTER_VALUE"] setValue(level.JEV);
	}
	
}

HUD_Controls()
{
	self endon("game_ended");
	self endon("disconnect");
	
	self waittill("spawned_player");
	
	self setClientDvar("ui_uav_client",1);
	//setdvar("ui_uav_client",1);
	
	self.HUD["OITC"]["LIVES_1"] = self createRectangle("BOTTOM RIGHT", "BOTTOM RIGHT", -100 + self.AIO["safeArea_X"]*-1, 0 + self.AIO["safeArea_Y"]*-1, 40, 100, (1,1,1), "stance_stand", 2, 1);
	self.HUD["OITC"]["LIVES_2"] = self createRectangle("BOTTOM RIGHT", "BOTTOM RIGHT", -70 + self.AIO["safeArea_X"]*-1, 0 + self.AIO["safeArea_Y"]*-1, 40, 100, (1,1,1), "stance_stand", 2, 1);
	self.HUD["OITC"]["LIVES_3"] = self createRectangle("BOTTOM RIGHT", "BOTTOM RIGHT", -40 + self.AIO["safeArea_X"]*-1, 0 + self.AIO["safeArea_Y"]*-1, 40, 100, (1,1,1), "stance_stand", 2, 1);
	
	self.HUD["OITC"]["BULLETS_1"] = self createRectangle("BOTTOM RIGHT", "BOTTOM RIGHT", -120 + self.AIO["safeArea_X"]*-1, -12 + self.AIO["safeArea_Y"]*-1, 30, 10, (1,1,1), "ammo_counter_riflebullet", 2, 0);
	self.HUD["OITC"]["BULLETS_2"] = self createRectangle("BOTTOM RIGHT", "BOTTOM RIGHT", -80 + self.AIO["safeArea_X"]*-1, -12 + self.AIO["safeArea_Y"]*-1, 30, 10, (1,1,1), "ammo_counter_riflebullet", 2, 0);
	self.HUD["OITC"]["BULLETS_3"] = self createRectangle("BOTTOM RIGHT", "BOTTOM RIGHT", -40 + self.AIO["safeArea_X"]*-1, -12 + self.AIO["safeArea_Y"]*-1, 30, 10, (1,1,1), "ammo_counter_riflebullet", 2, 0);
	
	self.HUD["OITC"]["SHADER_LEFT"] = self createRectangle("BOTTOM LEFT", "BOTTOM LEFT", 10 + self.AIO["safeArea_X"], -10 + self.AIO["safeArea_Y"]*-1, 167, 63, (1,1,1), "black", 1, .2);
	self.HUD["OITC"]["SHADER_RIGHT"] = self createRectangle("BOTTOM RIGHT", "BOTTOM RIGHT", -10 + self.AIO["safeArea_X"]*-1, -10 + self.AIO["safeArea_Y"]*-1, 167, 63, (1,1,1), "black", 1, .2);
	
	self.HUD["OITC"]["COUNTER_VALUE"] = self createText("default",2.8, "BOTTOM LEFT", "BOTTOM LEFT", 50 + self.AIO["safeArea_X"], -30 + self.AIO["safeArea_Y"]*-1, 2, 1, (1,1,1));
	self.HUD["OITC"]["COUNTER_TEXT"] = self createText("default",1.4, "BOTTOM LEFT", "BOTTOM LEFT", 25 + self.AIO["safeArea_X"], -20 + self.AIO["safeArea_Y"]*-1, 2, 1, (1,1,1), "players alive");

	self.HUD["OITC"]["COUNTER_TIMER"] = self createText("default",2.8, "BOTTOM LEFT", "BOTTOM LEFT", 110 + self.AIO["safeArea_X"], -23 + self.AIO["safeArea_Y"]*-1, 2, 1, (1,1,1));
	
	self.HUD["OITC"]["COUNTER_TIMER"] setTimer(599);
	
	
	while(1)
	{
		self waittill_any("REFRESH_HUDS","destroy_all_huds");

		if(level.gameEnded)
		{
			
			if(isDefined(self.HUD["OITC"]["LIVES_1"])) self.HUD["OITC"]["LIVES_1"] AdvancedDestroy(self);
			if(isDefined(self.HUD["OITC"]["LIVES_2"])) self.HUD["OITC"]["LIVES_2"] AdvancedDestroy(self);
			if(isDefined(self.HUD["OITC"]["LIVES_3"])) self.HUD["OITC"]["LIVES_3"] AdvancedDestroy(self);
			if(isDefined(self.HUD["OITC"]["BULLETS_1"])) self.HUD["OITC"]["BULLETS_1"] AdvancedDestroy(self);
			if(isDefined(self.HUD["OITC"]["BULLETS_2"])) self.HUD["OITC"]["BULLETS_2"] AdvancedDestroy(self);
			if(isDefined(self.HUD["OITC"]["BULLETS_3"])) self.HUD["OITC"]["BULLETS_3"] AdvancedDestroy(self);
			if(isDefined(self.HUD["OITC"]["SHADER_LEFT"])) self.HUD["OITC"]["SHADER_LEFT"] AdvancedDestroy(self);
			if(isDefined(self.HUD["OITC"]["SHADER_RIGHT"])) self.HUD["OITC"]["SHADER_RIGHT"] AdvancedDestroy(self);
			if(isDefined(self.HUD["OITC"]["COUNTER_VALUE"])) self.HUD["OITC"]["COUNTER_VALUE"] AdvancedDestroy(self);
			if(isDefined(self.HUD["OITC"]["COUNTER_TEXT"])) self.HUD["OITC"]["COUNTER_TEXT"] AdvancedDestroy(self);
			if(isDefined(self.HUD["OITC"]["COUNTER_TIMER"])) self.HUD["OITC"]["COUNTER_TIMER"] AdvancedDestroy(self);
		}
		else
		{
		
			if(isDefined(self.HUD["OITC"]["LIVES_1"])) self.HUD["OITC"]["LIVES_1"] setPoint("BOTTOM RIGHT", "BOTTOM RIGHT", -100 + self.AIO["safeArea_X"]*-1, 0 + self.AIO["safeArea_Y"]*-1);
			if(isDefined(self.HUD["OITC"]["LIVES_2"])) self.HUD["OITC"]["LIVES_2"] setPoint("BOTTOM RIGHT", "BOTTOM RIGHT", -70 + self.AIO["safeArea_X"]*-1, 0 + self.AIO["safeArea_Y"]*-1);
			if(isDefined(self.HUD["OITC"]["LIVES_3"])) self.HUD["OITC"]["LIVES_3"] setPoint("BOTTOM RIGHT", "BOTTOM RIGHT", -40 + self.AIO["safeArea_X"]*-1, 0 + self.AIO["safeArea_Y"]*-1);
			if(isDefined(self.HUD["OITC"]["BULLETS_1"])) self.HUD["OITC"]["BULLETS_1"] setPoint("BOTTOM RIGHT", "BOTTOM RIGHT", -120 + self.AIO["safeArea_X"]*-1, -12 + self.AIO["safeArea_Y"]*-1);
			if(isDefined(self.HUD["OITC"]["BULLETS_2"])) self.HUD["OITC"]["BULLETS_2"] setPoint("BOTTOM RIGHT", "BOTTOM RIGHT", -80 + self.AIO["safeArea_X"]*-1, -12 + self.AIO["safeArea_Y"]*-1);
			if(isDefined(self.HUD["OITC"]["BULLETS_3"])) self.HUD["OITC"]["BULLETS_3"] setPoint("BOTTOM RIGHT", "BOTTOM RIGHT", -40 + self.AIO["safeArea_X"]*-1, -12 + self.AIO["safeArea_Y"]*-1);
			if(isDefined(self.HUD["OITC"]["SHADER_LEFT"])) self.HUD["OITC"]["SHADER_LEFT"] setPoint("BOTTOM LEFT", "BOTTOM LEFT", 10 + self.AIO["safeArea_X"], -10 + self.AIO["safeArea_Y"]*-1);
			if(isDefined(self.HUD["OITC"]["SHADER_RIGHT"])) self.HUD["OITC"]["SHADER_RIGHT"] setPoint("BOTTOM RIGHT", "BOTTOM RIGHT", -10 + self.AIO["safeArea_X"]*-1, -10 + self.AIO["safeArea_Y"]*-1);
			if(isDefined(self.HUD["OITC"]["COUNTER_VALUE"])) self.HUD["OITC"]["COUNTER_VALUE"] setPoint("BOTTOM LEFT", "BOTTOM LEFT", 50 + self.AIO["safeArea_X"], -30 + self.AIO["safeArea_Y"]*-1);
			if(isDefined(self.HUD["OITC"]["COUNTER_TEXT"])) self.HUD["OITC"]["COUNTER_TEXT"] setPoint("BOTTOM LEFT", "BOTTOM LEFT", 25 + self.AIO["safeArea_X"], -20 + self.AIO["safeArea_Y"]*-1);
			if(isDefined(self.HUD["OITC"]["COUNTER_TIMER"])) self.HUD["OITC"]["COUNTER_TIMER"] setPoint("BOTTOM LEFT", "BOTTOM LEFT", 110 + self.AIO["safeArea_X"], -23 + self.AIO["safeArea_Y"]*-1);
		}
	}
	
}

CheckAmmo()
{
	self endon("disconnect");
	
	while(1)
	{
		self waittill("weapon_fired");
		
		if(self.bullet > 0)
			self.bullet--;
			
		if(self.bullet == 0)	
			self.HUD["OITC"]["BULLETS_3"].alpha = 0;

		if(self.bullet == 1)	
			self.HUD["OITC"]["BULLETS_2"].alpha = 0;
		
		if(self.bullet == 2)	
			self.HUD["OITC"]["BULLETS_1"].alpha = 0;
	}
}

onPlayerKilled(eInflictor, attacker, iDamage, s, sWeapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration)
{
	thread maps\mp\gametypes\_finalkills::onPlayerKilled(eInflictor, attacker, iDamage, s, sWeapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration);
	
	if(self.deaths == 3 && isDefined(self.HUD["OITC"]["LIVES_3"]))
		self.HUD["OITC"]["LIVES_3"].alpha = .4;

	if(self.deaths == 2 && isDefined(self.HUD["OITC"]["LIVES_2"]))
		self.HUD["OITC"]["LIVES_2"].alpha = .4;
	
	if(self.deaths == 1 && isDefined(self.HUD["OITC"]["LIVES_1"]))
		self.HUD["OITC"]["LIVES_1"].alpha = .4;
		
		
	if(attacker != self)
	{
		
		if(s == "MOD_PISTOL_BULLET" || s == "MOD_RIFLE_BULLET" || s == "MOD_HEAD_SHOT" || s == "MOD_MELEE")
		{	
			wait .1;
			
			if(attacker.bullet < 3)
			{
				attacker.bullet++;
			}
		}
	}
	
	
}