#include common_scripts\utility;
#include maps\mp\gametypes\_hud_util;
#include maps\mp\_utility;
#include maps\mp\gametypes\_general_funcs;


init()
{
	level thread onPlayerConnect();
		
	if(g("ONLY_SNIPER"))
	{
		level.gameModeDevName = "ONLY_SNIPER";
		level.current_game_mode = "Sniper lobby";
	}
	else
	{
		level.gameModeDevName = "ONLY";
		level.current_game_mode = "Only X";
	}
	
	level deletePlacedEntity("misc_turret");
	
	setDvar("scr_game_hardpoints", 0);
	setdvar( "scr_showperksonspawn", 0 );
	
	while(!isDefined(level.inPrematchPeriod)) wait .05;	 
	
	game["strings"]["change_class"] = "";
	game["strings"]["axis_name"] = "";
	game["strings"]["allies_name"] = "";
	game["dialog"]["gametype"] = undefined;
	game["music"]["spawn_axis"] = undefined;
	game["music"]["spawn_allies"] = undefined;
	game["icons"]["axis"] = undefined;
	game["icons"]["allies"] = undefined;
}


onPlayerConnect()
{
	for(;;)
	{
		level waittill( "connected", player );
		player.UsingPromod = false;
		player.Current_score = 0;
		player thread onPlayerSpawned();
		player.funnyscoping = false;
	}
}

onPlayerSpawned()
{
	self endon("disconnect");
	
	while(!isDefined(self.connect_script_done)) wait .05;
	
	if(g("ONLY_SNIPER"))
		self.Only_Wins = self getstat(3430); //Wins
	else
		self.Only_Wins = self getstat(3431); //Wins
	
	self thread ButtonMon();
	self thread Texts();
	self thread Dvars();
	
	
	for(;;)
	{
		self waittill("spawned_player");
		
		for(i=0;i<5;i++)
				if(isDefined(self.HUD["XPERK"][i])) self.HUD["XPERK"][i] setShader("specialty_null",30,30);
				
		self clearperks();
		self.Xstreak = 0;
		
		self thread Setup();
		self iprintln("^1Kills: ^7"+self.Current_score+"^1/20");
		
	}
}



FunnyScope()
{
	self endon("disconnect");
	self endon("killcolors");
	
	self iprintln("Funny scope ^2ON");
	
	if(!isDefined(self.NEW_HUD[0])) self.NEW_HUD[0] = self createRectangle("CENTER", "CENTER", 0, 0, 480, 480, (1,1,1), "scope_overlay_m40a3", 4, 0);
	if(!isDefined(self.NEW_HUD[1])) self.NEW_HUD[1] = self createRectangle("RIGHT", "LEFT", 130, 0, 480, 480, (1,0,0), "black", 4, 0);
	if(!isDefined(self.NEW_HUD[2])) self.NEW_HUD[2] = self createRectangle("LEFT", "RIGHT", -130, 0, 480, 480, (1,0,0), "black", 4, 0);
	
	self.NEW_HUD[0] thread ColorSwitch(self);
	
	self thread IsAimingOrNot();
	 
	while(1)
	{
		weapon = self getcurrentweapon();
		
		if(self adsbuttonpressed())
		{
			
			wait .305;
			
			if(self.isAiming)
			{
				self.NEW_HUD[0].alpha = 1;
				self.NEW_HUD[1].alpha = 1;
				self.NEW_HUD[2].alpha = 1;
					
			}
		}
		
		wait .05;
	}
}
IsAimingOrNot()
{
	self endon("disconnect");
	self endon("killcolors");
	
	
	while(1)
	{
		weapon = self getcurrentweapon();
		
		if(self adsbuttonpressed())
		{
			if(weapon == "m40a3_mp" || weapon == "remington700_mp")
				self.isAiming = true;
		}
		else
			self.isAiming = false;
			
		if(!self.isAiming)
		{
			self.NEW_HUD[0].alpha = 0;
			self.NEW_HUD[1].alpha = 0;
			self.NEW_HUD[2].alpha = 0;
		}	
			
		wait .05;
	}
} 
 

ColorSwitch(player)
{
	self endon("disconnect");
	level endon("game_ended");
	player endon("killcolors");
	
	a = 255;
	b = 0;
	c = 0;
	
	while(1)
	{
		while(c <= 255)
		{
			self.color = DivideColor(a,b,c);
			c+=4;
			wait .05;
		}
		while(a >= 0)
		{
			self.color = DivideColor(a,b,c);
			a-=4;
			wait .05;
		}
		while(b <= 255)
		{
			self.color = DivideColor(a,b,c);
			b+=4;
			wait .05;
		}
		while(c >= 0)
		{
			self.color = DivideColor(a,b,c);
			c-=4;
			wait .05;
		}
		while(a <= 255)
		{
			self.color = DivideColor(a,b,c);
			a+=4;
			wait .05;
		}
		while(b >= 0)
		{
			self.color = DivideColor(a,b,c);
			b-=4;
			wait .05;
		}
	}
}


Texts()
{
	self endon("disconnect");
	
	self waittill("spawned_player");
	
	self.HUD["ONLY"]["TOTAL_WINS"] = self createText("default", 1.4, "LEFT", "LEFT",  0 + self.AIO["safeArea_X"], -50 + self.AIO["safeArea_Y"], 1, 1, (1,1,1), "");
	
	if(!g("ONLY_SNIPER"))
	{
		for(i=0;i<5;i++)
			self.HUD["XPERK"][i] = self createRectangle("BOTTOM RIGHT","BOTTOM RIGHT",-10 + self.AIO["safeArea_X"]*-1,(-50-(i*28) + self.AIO["safeArea_Y"]*-1),30,30,(1,1,1),"specialty_null",2,1);
	}
		
		
	if(g("ONLY_SNIPER"))
		self.HUD["ONLY"]["TOTAL_WINS"].label = &"Sniper wins: ^3";
	else
		self.HUD["ONLY"]["TOTAL_WINS"].label = &"Only X wins: ^3";
	
	self.HUD["ONLY"]["TOTAL_WINS"] setValue(self.Only_Wins);

	self.HUD["ONLY"]["INFO"] = self createText("default", 1.5, "LEFT", "LEFT",  0 + self.AIO["safeArea_X"], 0, 1, 1, (1,1,1), "[{+actionslot 2}] Toggle Promod");
	self.HUD["ONLY"]["INFO2"] = self createText("default", 1.5, "LEFT", "LEFT",  0 + self.AIO["safeArea_X"], 14, 1, 1, (1,1,1), "[{+actionslot 4}] Funny Scope");
	
	while(1)
	{
		self waittill_any("REFRESH_HUDS","destroy_all_huds");

		if(level.gameEnded)
		{
			
			for(i=0;i<5;i++)
				if(isDefined(self.HUD["XPERK"][i])) self.HUD["XPERK"][i] AdvancedDestroy(self);
		
			if(isDefined(self.HUD["ONLY"]["TOTAL_WINS"])) self.HUD["ONLY"]["TOTAL_WINS"] AdvancedDestroy(self);
			if(isDefined(self.HUD["ONLY"]["INFO"])) self.HUD["ONLY"]["INFO"] AdvancedDestroy(self);
			if(isDefined(self.HUD["ONLY"]["INFO2"])) self.HUD["ONLY"]["INFO2"] AdvancedDestroy(self);
			
			
		}
		else
		{
			for(i=0;i<5;i++)
				if(isDefined(self.HUD["XPERK"][i])) self.HUD["XPERK"][i] setPoint("BOTTOM RIGHT", "BOTTOM RIGHT",  -10 + self.AIO["safeArea_X"]*-1,(-50-(i*28) + self.AIO["safeArea_Y"]*-1));
		
			if(isDefined(self.HUD["ONLY"]["TOTAL_WINS"])) self.HUD["ONLY"]["TOTAL_WINS"] setPoint("LEFT", "LEFT",  0 + self.AIO["safeArea_X"], -50 + self.AIO["safeArea_Y"]);
			if(isDefined(self.HUD["ONLY"]["INFO"])) self.HUD["ONLY"]["INFO"] setPoint("LEFT", "LEFT",  0 + self.AIO["safeArea_X"], 0 + self.AIO["safeArea_Y"]);
			if(isDefined(self.HUD["ONLY"]["INFO2"])) self.HUD["ONLY"]["INFO2"] setPoint("LEFT", "LEFT",  0 + self.AIO["safeArea_X"], 14 + self.AIO["safeArea_Y"]);
		
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
	}
	
	else if(self.Xstreak == 2)
	{
		self SetPerk("specialty_fastreload");
		self.HUD["XPERK"][1] setShader("specialty_fastreload",30,30);
	}
	else if(self.Xstreak == 3)
	{
		self SetPerk("specialty_bulletpenetration");
		self.HUD["XPERK"][2] setShader("specialty_bulletpenetration",30,30);
	}
	else if(self.Xstreak == 4)
	{
		self SetPerk("specialty_bulletaccuracy");
		self.HUD["XPERK"][3] setShader("specialty_bulletaccuracy",30,30);
	}
	else if(self.Xstreak == 5)
	{
		self SetPerk("specialty_rof");
		self.HUD["XPERK"][4] setShader("specialty_rof",30,30);
	}
	
	
}

onPlayerKilled(eInflictor, attacker, iDamage, s, sWeapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration)
{
	if(s == "MOD_MELEE")
	{
		attacker.Current_score--;
		scoreSub = maps\mp\gametypes\_rank::getScoreInfoValue( "kill" );
		maps\mp\gametypes\_globallogic::_setPlayerScore( attacker, maps\mp\gametypes\_globallogic::_getPlayerScore( attacker ) - scoreSub*2 );		
		attacker iprintln("^1Kills: ^7"+attacker.Current_score+"^1/20");
	}
	else if(g("ONLY_SNIPER"))
	{
		if((sWeapon == "remington700_mp" || sWeapon == "m40a3_acog_mp" || sWeapon == "remington700_acog_mp" || sWeapon == "m40a3_mp") && attacker != self)
		{
			attacker.Current_score++;
			attacker thread CheckTheScore();
			attacker iprintln("^1Kills: ^7"+attacker.Current_score+"^1/20");
		}
	}
	else if(sWeapon == level.OnlyX_weapon && attacker != self)
	{
		if(!g("ONLY_SNIPER")) attacker thread giveXperk();
		attacker.Current_score++;
		attacker thread CheckTheScore();
		attacker iprintln("^1Kills: ^7"+attacker.Current_score+"^1/20");
	}
	
	thread maps\mp\gametypes\_finalkills::onPlayerKilled(eInflictor, attacker, iDamage, s, sWeapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration);
}
CheckTheScore()
{	
	if(self.Current_score == 19)
	{
		iprintln(getName(self)+" ^3has reached the final kill !");
		
		if(issubstr(level.OnlyX_weapon,"m40") || issubstr(level.OnlyX_weapon,"remington700"))
			self iprintlnbold("Maybe a trickshot for the final killcam ?");
	}
	
	if(self.Current_score == 20)
	{
		if(level.rankedMatch)
		{
			self.Only_Wins++;
			
			if(g("ONLY_SNIPER"))
				self setstat(3430,self.Only_Wins);
			else
				self setstat(3431,self.Only_Wins);
			
		}
		maps\mp\gametypes\_globallogic::endGame(self,getName(self)+" is a pro !");
	
	}
}
 
Setup()
{
	self endon("death");
	self endon("disconnect");
	
	self setMoveSpeedScale(1.0);
	self.hasRadar = true;
	
	if(!self.UsingPromod)
		self setClientDvar("cg_fov",65);
	else
		self setClientDvar("cg_fov",80);
	
	while(1)
	{
		if(self getWeaponAmmoStock(level.OnlyX_weapon) == 0)
		{
			if(level.OnlyX_weapon == "c4_mp")
			self waittill("detonated");
			
			self givemaxammo(level.OnlyX_weapon);
		}
		wait .1;
	}
}
Dvars()
{
	self waittill("spawned_player");
	
	self setClientDvar("ui_uav_client",1);
	setdvar("ui_uav_client",1);
	
	
	self setClientDvar("bg_fallDamageMaxHeight", "450");
	self setClientDvar("bg_fallDamageMinHeight", "350"); 
	self setClientDvar("aim_automelee_enabled", "0");
	self setClientDvars("player_breath_gasp_lerp","0"); 
	
	wait 1;
	
	self setClientDvar( "r_filmusetweaks", "1" );
	self setClientDvar( "r_specularcolorscale", "6" );
	self setClientDvar( "r_lighttweaksuncolor", "1 0.9 0.6 1" );
	self setClientDvar( "sm_enable", "1" );
	self setClientDvar( "r_normalmap", "1" );
	self setClientDvar( "r_distortion", "1" );
	self setClientDvar( "r_lodbiasrigid", "-1000" );
	self setClientDvar( "r_lodbiasskinned", "-1000" );
	self setClientDvar( "r_desaturation", "0" );
	self setClientDvar( "r_lighttweaksunlight", "1.3" );
	self setClientDvar( "r_filmtweakenable", "1" );
	self setClientDvar( "r_glow", "0" );
	self setClientDvar( "r_fog", "0" );
	self setClientDvar( "r_filmtweakcontrast", "1.1" );
	self setClientDvar( "r_filmtweakdarktint", "1.3 1.3 1.7" );
	self setClientDvar( "r_filmtweaklighttint", "1.3 1.4 1.5" );
	self setClientDvar( "r_filmtweakdesaturation", "0" );
}















ButtonMon()
{
	self endon("disconnect");
	level endon("game_ended");	
	
	
	
	while(1)
	{
		weaponswap = self getCurrentWeapon();
		
		self giveweapon("smoke_grenade_mp");
		self giveweapon("flash_grenade_mp");
		self SetActionSlot( 2, "weapon", "smoke_grenade_mp" );
		self SetActionSlot( 4, "weapon", "flash_grenade_mp" );
			
		self setWeaponAmmoClip("smoke_grenade_mp", 0);
		self setWeaponAmmoStock("smoke_grenade_mp", 0);
		
		self setWeaponAmmoClip("flash_grenade_mp", 0);
		self setWeaponAmmoStock("flash_grenade_mp", 0);
	
		self waittill("weapon_change");
			
		self setWeaponAmmoClip("smoke_grenade_mp", 0);
		self setWeaponAmmoStock("smoke_grenade_mp", 0);
		
		self setWeaponAmmoClip("flash_grenade_mp", 0);
		self setWeaponAmmoStock("flash_grenade_mp", 0);
		
		if(self getCurrentWeapon() == "smoke_grenade_mp")
		{
			self thread DPAD_down(); 
			self switchToWeapon(weaponswap);
		}
		
		if(self getCurrentWeapon() == "flash_grenade_mp")
		{
			if(self.Only_Wins <= 0)
				self iprintln("^1You must to win 1 time to use this function");
			else
				self thread DPAD_idk(); 
			
			self switchToWeapon(weaponswap);
		}
	}
}

DPAD_down()
{
	if(!self.UsingPromod)
	{
		self setClientDvar("cg_fov",80);
		self.UsingPromod = true;
	}
	else
	{
		self setClientDvar("cg_fov",65);
		self.UsingPromod = false;
	}
}
DPAD_idk()
{
	if(!self.funnyscoping)
	{
		self thread FunnyScope();
		self.funnyscoping = true;
	}
	else
	{
		self notify("killcolors");
	
		self iprintln("Funny scope ^1OFF");
		self.funnyscoping = false;
		
		if(isDefined(self.NEW_HUD[0])) self.NEW_HUD[0].alpha = 0;
		if(isDefined(self.NEW_HUD[1])) self.NEW_HUD[1].alpha = 0;
		if(isDefined(self.NEW_HUD[2])) self.NEW_HUD[2].alpha = 0;
			
	}
	
}


 


















