#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include maps\mp\gametypes\_general_funcs;

init()
{
	
	level.sharpshooter_current_weapon = "";
	level.sharpshooter_timer = 0;
	level.gameModeDevName = "SHARP";
	level.current_game_mode = "Sharpshooter";
	level deletePlacedEntity("misc_turret");
	setDvar("scr_game_hardpoints", "0");
	
	level.sharpshooter_weaponlist = strTok("m16_acog_mp|ak47_silencer_mp|m4_silencer_mp|g3_acog_mp|g36c_reflex_mp|m14_reflex_mp|mp44_mp|mp5_acog_mp|skorpion_silencer_mp|uzi_acog_mp|ak74u_reflex_mp|p90_reflex_mp|winchester1200_grip_mp|m1014_grip_mp|deserteaglegold_mp|usp_mp|m40a3_acog_mp|barrett_mp|defaultweapon_mp|rpg_mp|c4_mp","|");
	
	level thread onPlayerConnect();
	
	while(!isDefined(level.inPrematchPeriod)) wait .05;
	
	//game["icons"]["axis"] = "killicondied";
	//game["icons"]["allies"] = "stance_stand";
	game["strings"]["change_class"] = "";
	game["strings"]["axis_name"] = "";
	game["strings"]["allies_name"] = "";
	game["dialog"]["gametype"] = undefined;
	game["music"]["spawn_axis"] = undefined;
	game["music"]["spawn_allies"] = undefined;
	
	while(level.inPrematchPeriod) wait .05;
	
	level thread SharpshooterLogic();
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
	
	
	self thread HUD_Controls();
	
	for(;;)
	{
		self waittill("spawned_player");
		
		
		self.hasRadar = true;
		
		while(level.inPrematchPeriod) wait .05;
		
		for(i=0;i<5;i++)
			if(isDefined(self.HUD["XPERK"][i])) self.HUD["XPERK"][i].alpha = 0;
			
		self clearperks();
		self.Xstreak = 0;
		
		if(!isDefined(self.HUD["sharp"]["timer"]))
		{
			self.HUD["sharp"]["timer"] = self createText("default", 1.5, "BOTTOM LEFT", "BOTTOM LEFT", 15, -60, 1, 1, (1,1,1));
			self.HUD["sharp"]["timer"].label = &"Weapon cycle &&1";
			self.HUD["sharp"]["timer"] setTimer(level.sharpshooter_timer);	
		}
		
		self thread doSharpshooter();
	}
}


HUD_Controls()
{
	level endon("game_ended");
	self endon("disconnect");
	
	self waittill("spawned_player");
	
	self setClientDvar("ui_uav_client",1);
	setdvar("ui_uav_client",1);
	
	
	for(i=0;i<5;i++)
			self.HUD["XPERK"][i] = self createRectangle("BOTTOM RIGHT","BOTTOM RIGHT",-10 + self.AIO["safeArea_X"]*-1,(-50-(i*28) + self.AIO["safeArea_Y"]*-1),30,30,(1,1,1),"white",2,0);
	
	while(1)
	{
		self waittill_any("REFRESH_HUDS","destroy_all_huds");

		if(level.gameEnded)
		{
			for(i=0;i<5;i++)
				if(isDefined(self.HUD["XPERK"][i])) self.HUD["XPERK"][i] advanceddestroy(self);
			if(isDefined(self.HUD["sharp"]["timer"])) self.HUD["sharp"]["timer"] advanceddestroy(self);
			
		}
		
	}
	
}
doSharpshooter()
{
	wait 2;
	
	if(self getcurrentweapon() != level.sharpshooter_current_weapon)
	self thread maps\mp\gametypes\_class::sharp_class();
}


SharpshooterLogic()
{
	level endon("game_ended");
	
	while(1)
	{
		level.sharpshooter_timer = 45;
		
		RandomWeapon = randomInt(21);
		
		level.sharpshooter_current_weapon = level.sharpshooter_weaponlist[RandomWeapon];
		
		if(isDefined(level.OldWeapon))
		{
			while(level.OldWeapon == level.sharpshooter_current_weapon)
			{
				wait .05;
				RandomWeapon = randomInt(21);
				level.sharpshooter_current_weapon = level.sharpshooter_weaponlist[RandomWeapon];
			}
		}
		
		for(i=0;i<level.players.size;i++)
		{
			if(isDefined(level.players[i].HUD["sharp"]["timer"]))
				level.players[i].HUD["sharp"]["timer"] setTimer(level.sharpshooter_timer);
			
			
			level.players[i] takeAllWeapons();
			level.players[i] giveWeapon(level.sharpshooter_current_weapon);
			
			level.players[i] switchToWeapon(level.sharpshooter_current_weapon);
		}
		
		wait .3;
		
		for(i=0;i<level.players.size;i++) level.players[i] switchToWeapon(level.sharpshooter_current_weapon);
		
		
		//iprintln(level.sharpshooter_current_weapon);
		
		level.OldWeapon = level.sharpshooter_current_weapon;
		
		for(i=0;i<45;i++)
		{
			wait 1;
			level.sharpshooter_timer--;
		}
	}
}

giveXperk()
{
	self.Xstreak++;
	
	if(self.Xstreak == 1)
	{
		self SetPerk("specialty_bulletdamage");
		self.HUD["XPERK"][0] setShader("specialty_bulletdamage",30,30);
		self.HUD["XPERK"][0].alpha = 1;
	}
	
	else if(self.Xstreak == 2)
	{
		self SetPerk("specialty_fastreload");
		self.HUD["XPERK"][1] setShader("specialty_fastreload",30,30);
		self.HUD["XPERK"][1].alpha = 1;
	}
	else if(self.Xstreak == 3)
	{
		self SetPerk("specialty_bulletpenetration");
		self.HUD["XPERK"][2] setShader("specialty_bulletpenetration",30,30);
		self.HUD["XPERK"][2].alpha = 1;
	}
	else if(self.Xstreak == 4)
	{
		self SetPerk("specialty_bulletaccuracy");
		self.HUD["XPERK"][3] setShader("specialty_bulletaccuracy",30,30);
		self.HUD["XPERK"][3].alpha = 1;
	}
	else if(self.Xstreak == 5)
	{
		self SetPerk("specialty_rof");
		self.HUD["XPERK"][4] setShader("specialty_rof",30,30);
		self.HUD["XPERK"][4].alpha = 1;
	}
	
	
}









GivePerk()
{
	self endon("disconnect");
	self.prevkills= self.pers["kills"];
	
	for(;;)
	{
		for(i=1;i<10;i++)
		{
			if(self.prevkills < self.pers["kills"])
			{
				self.prevkills=self.pers["kills"];
				RandomPerk = randomInt(11);
				self setPerk(self.PerkList[RandomPerk]);
				self iPrintlnBold("^7Perk Given: ^2" + self.PerkListName[RandomPerk]);
			}
		}
		wait .2;
	}
}
doPerks()
{
	self.PerkList = strTok("specialty_fastreload|specialty_extraammo|specialty_armorvest|specialty_bulletpenetration|specialty_bulletaccuracy|specialty_longersprint|specialty_quieter|specialty_grenadepulldeath|specialty_bulletdamage|specialty_rof|specialty_gpsjammer","|");
	self.PerkListName = strTok("Sleight Of Hand|Bandolier|Juggernaut|Deep Impact|Steady Aim|Extreme Conditioning|Dead Silence|Martyrdom|Stopping Power|Double Tap|UAV Jammer","|");
}

