#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include maps\mp\gametypes\_general_funcs;

init()
{
	level thread onPlayerConnect();
	level.hardcoreMode = true;
	level.current_game_mode = "Gun game";
	level deletePlacedEntity("misc_turret");
	
	level.endGameOnScoreLimit = false;
	level.gameModeDevName = "GG";
	
	setDvar("scr_game_hardpoints", 0);
	setdvar("scr_showperksonspawn", 0 );
	
	level.GunGame_Weapon = strTOK("colt45_mp beretta_mp deserteaglegold_mp winchester1200_mp m1014_mp p90_mp mp5_mp uzi_mp skorpion_mp g3_mp m14_mp m16_mp ak47_mp m4_mp m60e4_mp barrett_mp dragunov_mp rpg_mp remington700_mp m40a3_mp defaultweapon_mp"," ");
	level.GunGame_WeaponShader = strTOK("weapon_colt_45 weapon_m9beretta weapon_desert_eagle_gold weapon_winchester1200 weapon_benelli_m4 weapon_p90 weapon_mp5 weapon_mini_uzi weapon_skorpion weapon_g3 weapon_m14 weapon_m16a4 weapon_ak47 weapon_m4carbine weapon_m60e4 weapon_barrett50cal weapon_dragunovsvd weapon_rpg7 weapon_remington700 weapon_m40a3 ui_host"," ");
	
	for(i=0;i<level.GunGame_WeaponShader.size;i++)
	precacheShader(level.GunGame_WeaponShader[i]);
	
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
	maps\mp\gametypes\_rank::registerScoreInfo( "melee", 0 );
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
	
	self thread Gun_game_prematch();
	self thread init_gun_game();
	self.currentWeapon = 0;
	
	self.GunGame_Wins = self getstat(3429); //Wins
	
	if(level.rankedMatch)
		self thread Texts();
		
	for(;;)
	{
		self waittill("spawned_player");
		
		self iprintln("Weapon ^3"+(self.currentWeapon+1)+"/20");
		self thread GiveDvars();
	}
}

Texts()
{
	self endon("disconnect");
	
	self waittill("spawned_player");
	
	self.HUD["ONLY"]["TOTAL_WINS"] = self createText("default", 1.4, "LEFT", "LEFT",  0 + self.AIO["safeArea_X"], -50 + self.AIO["safeArea_Y"], 1, 1, (1,1,1), "");
	self.HUD["ONLY"]["TOTAL_WINS"].label = &"Gun Game wins: ^3";	
	self.HUD["ONLY"]["TOTAL_WINS"] setValue(self.GunGame_Wins);

	while(1)
	{
		self waittill_any("REFRESH_HUDS","destroy_all_huds");

		if(level.gameEnded)
		{
			if(isDefined(self.HUD["ONLY"]["TOTAL_WINS"])) self.HUD["ONLY"]["TOTAL_WINS"] AdvancedDestroy(self);
		}
		else
		{
			if(isDefined(self.HUD["ONLY"]["TOTAL_WINS"])) self.HUD["ONLY"]["TOTAL_WINS"] setPoint("LEFT", "LEFT",  0 + self.AIO["safeArea_X"], -50 + self.AIO["safeArea_Y"]);
		}
	}
}
Gun_game_prematch()
{
	self.HUD["GG"]["GAME_TIMER"] = createFontString("default",2.8);
	self.HUD["GG"]["GAME_TIMER"] setPoint("BOTTOM LEFT","BOTTOM LEFT");
	self.HUD["GG"]["GAME_TIMER"].sort = 2;
	self.HUD["GG"]["GAME_TIMER"].alpha = 1;
	self.HUD["GG"]["GAME_TIMER"].x = 80 + self.AIO["safeArea_X"];
	self.HUD["GG"]["GAME_TIMER"].y = -15 + self.AIO["safeArea_Y"]*-1;
	
	while(!isDefined(level.temps_de_partie)) wait .05;
	
	self.HUD["GG"]["GAME_TIMER"] setTimer(level.temps_de_partie - 1);
	
	level waittill("game_ended");
	
	self.HUD["GG"]["GAME_TIMER"] AdvancedDestroy(self);
	
}
init_gun_game()
{
	self endon("disconnect");
	
	self.HUD["shader"]["weapon"] = self createRectangle("BOTTOM RIGHT","BOTTOM RIGHT", -80 + self.AIO["safeArea_X"]*-1, -5 + self.AIO["safeArea_Y"]*-1, 65, 50, (1,1,1), level.GunGame_WeaponShader[0], 2, 1);
	self.HUD["shader"]["right"] = self createRectangle("BOTTOM RIGHT","BOTTOM RIGHT", 0 + self.AIO["safeArea_X"]*-1,0 + self.AIO["safeArea_Y"]*-1,167,63, (1,1,1), "black", 1, .2);
	self.HUD["shader"]["left"] = self createRectangle("BOTTOM LEFT","BOTTOM LEFT", 0 + self.AIO["safeArea_X"],0 + self.AIO["safeArea_Y"]*-1,167,63, (1,1,1), "black", 1, .2);
	
	self.HUD["ammo"]["clip"] = self createText("default", 2.8, "CENTER","BOTTOM RIGHT", -30 + self.AIO["safeArea_X"]*-1,-40 + self.AIO["safeArea_Y"]*-1, 2, 1, (1,1,1));
	self.HUD["ammo"]["stock"] = self createText("default", 1.8, "CENTER","BOTTOM RIGHT", -30 + self.AIO["safeArea_X"]*-1,-15 + self.AIO["safeArea_Y"]*-1, 2, 1, (1,1,1));
	self.HUD["level"]["me"] = self createText("default", 2.8, "CENTER","BOTTOM LEFT", 30 + self.AIO["safeArea_X"],-40 + self.AIO["safeArea_Y"]*-1, 2, 1, (1,1,1));
	self.HUD["level"]["best"] = self createText("default", 1.8, "CENTER","BOTTOM LEFT", 30 + self.AIO["safeArea_X"],-15 + self.AIO["safeArea_Y"]*-1, 2, 1, (1,1,1));
	
	self.HUD["level"]["me"] setValue(1);
	self.HUD["level"]["best"] setValue(1);
	
	self thread Ammo_counter();
	
	while(1)
	{
		self waittill_any("REFRESH_HUDS","destroy_all_huds");

		if(level.gameEnded)
		{
			if(isDefined(self.HUD["shader"]["weapon"])) self.HUD["shader"]["weapon"] AdvancedDestroy(self);
			if(isDefined(self.HUD["shader"]["left"])) self.HUD["shader"]["left"] AdvancedDestroy(self);
			if(isDefined(self.HUD["shader"]["right"])) self.HUD["shader"]["right"] AdvancedDestroy(self);
			if(isDefined(self.HUD["ammo"]["clip"])) self.HUD["ammo"]["clip"] AdvancedDestroy(self);
			if(isDefined(self.HUD["ammo"]["stock"])) self.HUD["ammo"]["stock"] AdvancedDestroy(self);
			if(isDefined(self.HUD["level"]["me"])) self.HUD["level"]["me"] AdvancedDestroy(self);
			if(isDefined(self.HUD["level"]["best"])) self.HUD["level"]["best"] AdvancedDestroy(self);
			if(isDefined(self.HUD["GG"]["GAME_TIMER"])) self.HUD["GG"]["GAME_TIMER"] AdvancedDestroy(self);
		}
		else
		{
			if(isDefined(self.HUD["shader"]["weapon"])) self.HUD["shader"]["weapon"] setPoint("BOTTOM RIGHT","BOTTOM RIGHT", -80 + self.AIO["safeArea_X"]*-1, -5 + self.AIO["safeArea_Y"]*-1);
			if(isDefined(self.HUD["shader"]["left"])) self.HUD["shader"]["left"] setPoint("BOTTOM LEFT","BOTTOM LEFT", 0 + self.AIO["safeArea_X"],0 + self.AIO["safeArea_Y"]*-1);
			if(isDefined(self.HUD["shader"]["right"])) self.HUD["shader"]["right"] setPoint("BOTTOM RIGHT","BOTTOM RIGHT", 0 + self.AIO["safeArea_X"]*-1,0 + self.AIO["safeArea_Y"]*-1);
			if(isDefined(self.HUD["ammo"]["clip"])) self.HUD["ammo"]["clip"] setPoint("CENTER","BOTTOM RIGHT", -30 + self.AIO["safeArea_X"]*-1,-40 + self.AIO["safeArea_Y"]*-1);
			if(isDefined(self.HUD["ammo"]["stock"])) self.HUD["ammo"]["stock"] setPoint("CENTER","BOTTOM RIGHT", -30 + self.AIO["safeArea_X"]*-1,-15 + self.AIO["safeArea_Y"]*-1);
			if(isDefined(self.HUD["level"]["me"])) self.HUD["level"]["me"] setPoint("CENTER","BOTTOM LEFT", 30 + self.AIO["safeArea_X"],-40 + self.AIO["safeArea_Y"]*-1);
			if(isDefined(self.HUD["level"]["best"])) self.HUD["level"]["best"] setPoint("CENTER","BOTTOM LEFT", 30 + self.AIO["safeArea_X"],-15 + self.AIO["safeArea_Y"]*-1);
			if(isDefined(self.HUD["GG"]["GAME_TIMER"])) self.HUD["GG"]["GAME_TIMER"] setPoint("BOTTOM LEFT","BOTTOM LEFT",80 + self.AIO["safeArea_X"],-15 + self.AIO["safeArea_Y"]*-1);
		}	
	}
}
Ammo_counter()
{
	self endon("disconnect");
	
	while(!level.gameEnded)
	{
		//iprintln(level.gameEnded);
		
		weapon = self getCurrentWeapon();
		ammoClip = self getWeaponAmmoClip(weapon);
		ammoStock = self getWeaponAmmoStock(weapon);
		
		self.HUD["ammo"]["clip"] setValue(ammoClip);
		self.HUD["ammo"]["stock"] setValue(ammoStock);
		wait .05;	
	}
}


onPlayerKilled(eInflictor, attacker, iDamage, s, sWeapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration)
{

	if(attacker != self)
	{
		if(s == "MOD_MELEE")
			self thread Humiliated(attacker);
			
			if(s == "MOD_PISTOL_BULLET" || s == "MOD_RIFLE_BULLET" || s == "MOD_HEAD_SHOT" || s == "MOD_PROJECTILE_SPLASH")
				attacker thread Killed();
	}
	thread maps\mp\gametypes\_finalkills::onPlayerKilled(eInflictor, attacker, iDamage, s, sWeapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration);
}
Humiliated(attacker)
{
	if(self.currentWeapon != 0)
	{
		self.currentWeapon--;
		self thread GunGame_Logic();
	}
	iprintln("^1"+getName(self)+" ^7was humiliated by ^1"+getName(attacker));
}
Killed()
{
	self.currentWeapon++;
	self thread GunGame_Logic();
}
GunGame_Logic()
{
	if(self.currentWeapon < 20)
		self iprintln("Weapon ^3"+(self.currentWeapon+1)+"/20");
	
	winner = maps\mp\gametypes\_globallogic::getHighestScoringPlayer();
		
	self.HUD["shader"]["weapon"] setShader(level.GunGame_WeaponShader[self.currentWeapon],65,50);	
	
	if(self.currentWeapon+1 < 21) self.HUD["level"]["me"] setValue(self.currentWeapon+1);
	
	if(isDefined(winner))
	{
		for(i=0;i<level.players.size;i++)
		if(level.players[i].currentWeapon+1 < 21) level.players[i].HUD["level"]["best"] setValue(winner.currentWeapon+1);
	}	
	
	self takeallweapons();
	self giveWeapon(level.GunGame_Weapon[self.currentWeapon]);
	self switchToWeapon(level.GunGame_Weapon[self.currentWeapon]);

	if(self.currentWeapon == 19)
		iprintlnbold("^3"+getName(self)+" ^7has reached the final weapon !\n\n\n");
	
	if(self.currentWeapon == 20)
	{
		thread maps\mp\gametypes\_globallogic::endGame(self,getName(self)+" has reached all levels !");
		
		if(level.rankedMatch)
		{
			self.GunGame_Wins++;
			self setstat(3429,self.GunGame_Wins);
		}
	}
}
GiveDvars()
{
	self SetPerk( "specialty_bulletdamage" );
	self setClientDvar( "cg_fovScale", "1.125" );
	self setClientDvar( "cg_fov", "80" );
	self setClientDvar( "cg_gun_x", "2" );
	self setClientDvar( "aim_automelee_enabled", "0" );
	self setClientDvar( "nightVisionDisableEffects", "1" );
	self.hasRadar = true;
	self setClientDvar( "ui_uav_client", 1 );
}