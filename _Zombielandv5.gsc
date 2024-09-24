#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include maps\mp\gametypes\_general_funcs;
#include maps\mp\gametypes\_V5_functions;

init()
{
	level.current_game_mode = "Zombieland";
	level.gameModeDevName = "ZLV5";
	level.game_state = "starting";
	
	
	level thread init_Zombieland();
	level thread MapEdit();
	level thread gamestartz();
	level thread onPlayerConnect();
	
	level deletePlacedEntity("misc_turret");
	
	level.endGameOnScoreLimit = false;
	level.endGameOnTimeLimit = false;
	level.overrideTeamScore = false;
	 
	setdvar("scr_showperksonspawn", "0");
	setDvar("jump_height", "60");
	setDvar("scr_game_hardpoints", 0);

	
	precacheShader("stance_stand");  
	precacheShader("killicondied"); 
	precacheShader( "objective" );
	precacheShader( "compass_waypoint_captureneutral" );
	precacheModel("prop_suitcase_bomb");
	precacheModel("com_lightbox_on");
	precacheModel("com_junktire");
	precacheModel("vehicle_cobra_helicopter_d_piece07");
	precacheModel("vehicle_cobra_helicopter_d_piece02");
	precacheModel("prop_flag_american");
	precacheModel("prop_flag_russian");
	precacheModel("com_plasticcase_beige_big" );
	precacheModel("com_junktire2");
	
	level.yelcircle = loadfx( "misc/ui_pickup_available" );
	level.redcircle = loadfx( "misc/ui_pickup_unavailable" );
	level.fxxx1 = loadfx("fire/jet_afterburner");
	level.expbullt = loadfx("explosions/grenadeExp_concrete_1");
	level.fxsmoke = loadfx ("smoke/smoke_trail_white_heli");
	level.flamez = loadfx("fire/tank_fire_engine");
	level.boomerz = loadfx("explosions/tanker_explosion");
	level.fxsmokes=loadfx ("smoke/smoke_trail_black_heli");
	
	while(!isDefined(level.inPrematchPeriod)) wait .05;
	
	game["strings"]["axis_name"] = "";
	game["strings"]["allies_name"] = "";
	game["dialog"]["gametype"] = undefined;
	game["music"]["spawn_axis"] = undefined;
	game["music"]["spawn_allies"] = undefined;
	game["icons"]["axis"] = "killicondied";
	game["icons"]["allies"] = "stance_stand";
	
	//setDvar("g_teamcolor_allies", "0.391 0.391 1 1");
	//setDvar("g_teamcolor_axis", "1 0.309 0.281 1");
	setDvar("g_ScoresColor_Allies", "0.391 0.391 1 1");
	setDvar("g_ScoresColor_Axis", "1 0.309 0.281 1");
	setDvar("g_ScoresColor_Spectator","1 1 1 1");
	setDvar("g_TeamName_Allies", "^4Humans");
	setDvar("g_TeamName_Axis", "^1Zombies");
	setDvar("g_teamicon_axis", "killicondied");
	setDvar("g_teamicon_allies", "stance_stand");
	
}


onPlayerConnect()
{
	for(;;)
	{
		level waittill("connecting", player);
		player thread onPlayerSpawned();
		
		 
	}
}


onPlayerSpawned()
{
	self endon("disconnect");
	
	//ONE TIME
	self thread HintText();
	self thread initSelfVariables();
	self thread MenuMove();
	
	self.isZombie = 0;
	self.menu = 0;
	self.isShowingHealth = false;
	
	self.dcnt = 0;
	self.isWaitingEndOfZB = false;
	self.zomb = 0;
	self.luckz = 0;
	 
	self thread FFTextD();
	
	if(level.game_state != "starting")
	{
		self thread maps\mp\gametypes\_globallogic::menuAxis(1);
		self.isZombie = 1;
		
		if(level.ZombieBoss)
			self thread ZombieBossWait(1);
	}
	else self thread maps\mp\gametypes\_globallogic::menuAllies(1);	
	
	for(;;)
	{
		self waittill("spawned_player");
		
		if(self.team == "axis") self thread doZombies();	
		else if(self.team == "allies") self thread doHumans();
	 
		 	
		if(level.ZombieBossAlive && !self.isWaitingEndOfZB)
			self thread ZombieBossWait(1);
	}
}


initSelfVariables()
{
	if(self.dcnt == 0)
		self.hasLightWeight = false;
	
	self.FlyTraps = 1;
	self.Bullet = 0;
	self.SuperShield = 0;
	self.SuperShieldTime = 0;
	self.PortalBreakers = 4;
	self.isFrozen = false;
	self.hasBulletDamage = false;
	self.hasDoubleTap = false;
	self.hasSleightOfHand = false;
	self.hasSteadyAim = false;
	self.isBomberZombie = false;
	self.hasExplodingDragon = false;
	self.hasSteelSkin = false;
	self.hasTechShield = false;
	self.hasShakerGun = false;
	self.hasUnlimitedAmmo = false;
	self.PlayerFrozen = false;
	self.hasAssaultRifle = false;
	self.hasLMG = false;
	self.isFlyingZombie = false;
	self.UneFois = false;
	self.IceZombieAttacking = false;
	self.isIceZombie = false;
	self.IceGun = false;
	self.isSemiInvisibleZombie = false;
	self.isFlamingZombie = false;
	self.isInZiplineArea = false;
	self.isUsingZipline = false;
	
	self.brimm = 0;
	self.liftz = false;
	self.elvz = 0;
	self.bsat = 0;
}
Dvars()
{
	self setClientDvar("cg_scoreboardMyColor","0 0 0 0");
	self setClientDvars("bg_fallDamageMaxHeight", "9999", "bg_fallDamageMinHeight", "9998", "player_sprintUnlimited", "1");
	self setClientDvars("player_meleeRange", "70", "player_meleeHeight", "800", "player_meleeWidth", "800");
	self setClientDvars("r_fog", "1", "cg_enemyNameFadeOut", "2500", "cg_enemyNameFadeIn", "0","cg_drawThroughWalls", "0" );
	self setClientDvars("painVisionTriggerHealth", "0","cg_everyoneHearsEveryone", "1",  "perk_bulletPenetrationMultiplier", "4", "cg_laserForceOn", "0" );
}

SettingWeapon()
{	
	level.Weapon = [];
	level.ass = [];
	level.shotgz = [];
	level.lmgz = [];
	level.Weapon[0] = "mp5_reflex";
	level.Weapon[1] = "p90_reflex";
	level.Weapon[2] = "ak74u_reflex";
	level.ass[0] = "ak47_acog";
	level.ass[1] = "m4_acog";
	level.ass[2] = "mp44";
	level.ass[3] = "g36c_reflex";
	level.shotgz[0] = "m1014_grip";
	level.shotgz[1] = "winchester1200_grip";
	level.lmgz[0] = "rpd_grip";
	level.lmgz[1] = "m60e4_grip";
	level.lmgz[2] = "saw_grip";
}





init_Zombieland()
{	
	level thread SettingWeapon();
	 
	level.trapz = 0;
	level.ZombieBoss = false;
	level.ZombieBossAlive = false;
	level.minutes = 0;
	level.seconds = 0;
	level.BomberZombieOnMap = false;
	level.FlyTrapCost = 250;
	level.FlyTrapDestroy = false;
	level.FlyTrapsDestroyed = false;
	level.ekillz = 0;
	level.instaKill = false;
	level.instakill_locked = false;
	level.nuke = 0;
	level.lastAlive = 0;
	level.scoreInfo = [];
}
gamestartz()
{	
	wait 30;
	SetExpFog(200, 800, 0.5, 0.5, 0.5, 10);
	iPrintlnBold("^1ZOMBIFICATION IN 30 SECONDS");
	wait 30;
	
	/*for(i=0;i<level.players.size;i++ )
	{	
		p = level.players[i];
		
		if(p.name != level.hostname && p.team == "spectator")	
			p.isZombie = 2;
		
		p PlaySound("mp_war_objective_lost");
	}
	*/
	 
	level thread doPickZombie();
}
doPickZombie()
{	
	level.game_state = "playing";
	
	zombie1 = randomInt(level.players.size);
	zombie2 = randomInt(level.players.size);
	zombie3 = randomInt(level.players.size);
		
	style = 2;
	
	if(level.players.size < 5) style = 1;
	if(level.players.size > 12) style = 3;
	
	OldFirst = getdvar("firstZ");
	OldSecond = getdvar("SecondZ");
	OldThird = getdvar("thirdZ");
	
	
	

	if(style == 1)
	{
		level.players[zombie1].isZombie = 2;
		level.players[zombie1] thread maps\mp\gametypes\_globallogic::menuAxis(1);
	}
	
	if(style == 2)
	{
		while(level.players[zombie1].name == OldFirst || level.players[zombie1].name == OldSecond || level.players[zombie1].name == OldThird || zombie1 == zombie2)
			zombie1 = randomInt(level.players.size);
		 
		while(level.players[zombie2].name == OldFirst || level.players[zombie2].name == OldSecond || level.players[zombie2].name == OldThird || zombie2 == zombie1)
			zombie2 = randomInt(level.players.size);
		
		wait .5;
			
		level.players[zombie1].isZombie = 2;
		level.players[zombie1] thread maps\mp\gametypes\_globallogic::menuAxis(1);
		
		
		level.players[zombie2].isZombie = 2;
		level.players[zombie2] thread maps\mp\gametypes\_globallogic::menuAxis(1);
		
		
		setDvar("firstZ",level.players[zombie1].name);
		setDvar("SecondZ",level.players[zombie2].name);
		setDvar("thirdZ","");	

	}
	
	
	if(style == 3)
	{
		while(level.players[zombie1].name == OldFirst || level.players[zombie1].name == OldSecond || level.players[zombie1].name == OldThird || zombie1 == zombie2 || zombie1 == Zombie3)
			zombie1 = randomInt(level.players.size);	
				
		while(level.players[zombie2].name == OldFirst|| level.players[zombie2].name == OldSecond || level.players[zombie2].name == OldThird || zombie2 == zombie1 || Zombie2 == zombie3)
			zombie2 = randomInt(level.players.size);
				
		while(level.players[zombie3].name == OldFirst|| level.players[zombie3].name == OldSecond || level.players[zombie3].name == OldThird || zombie3 == zombie2 || zombie3 == Zombie1)
			zombie3 = randomInt(level.players.size);
				
		wait .5;
		
		level.players[zombie1].isZombie = 2;
		level.players[zombie1] thread maps\mp\gametypes\_globallogic::menuAxis(1);
		
		level.players[zombie2].isZombie = 2;
		level.players[zombie2] thread maps\mp\gametypes\_globallogic::menuAxis(1);
		
		level.players[zombie3].isZombie = 2;
		level.players[zombie3] thread maps\mp\gametypes\_globallogic::menuAxis(1);
		
		
		setDvar("firstZ",level.players[zombie1].name);
		setDvar("SecondZ",level.players[zombie2].name);
		setDvar("thirdZ",level.players[zombie3].name);	

	}

	level thread doPlaying();
}
doPlaying()
{
	level thread GameTimer();
	level thread ZombieBossTimer();
	
	level notify ("GSTART");
	
	iPrintlnBold("^3Zombies Are Coming");
	wait 4;
	
	while(1)
	{
		level.playersLeft = maps\mp\gametypes\_teams::CountPlayers();
		
		if(!level.lastAlive)
		{
			if(level.playersLeft["allies"] == 1 && level.ZombieBoss != 1)
			{
				level.lastAlive = true;
			
				for(i=0;i<level.players.size;i++)
				{
					if(level.players[i].team == "allies")
						level.players[i] thread doLasta();
				}
			}
		}
		if(level.playersLeft["allies"] == 0 || level.playersLeft["axis"] == 0)
		{
			level notify ("GEND");
			level thread doEnding();
			break;
		}
		wait 2;
	}
}

doScor()
{
	if(!isDefined(self.tokill)) self.tokill = 0;
	if(!isDefined(self.totalscore)) self.totalscore = 0;
	
	self.score = (self.score + self.totalscore);
	self.kills = (self.tokill + self.kills);
	
	wait .4;
	
	if(self.kills > level.HighKills) 
		self thread doHiSC();
	else
	{
		wait .2;
		if(self.kills == level.HighKills && self.score > level.highsc)	self thread doHiSC();
	}
}

doHiSC()
{	
	level.highsc = self.score;
	level.HighScoreName = self.name;
	level.HighKills = self.kills;
}
doEnding()
{	
	visionSetNaked( "mpoutro", 2 );
	
	level.highsc = 0;
	level.HighKills = 0;
	
	wait 2;
	
	for(i=0;i<level.players.size;i++)
	{
		level.players[i] thread doScor();
		wait .01;
	}
	
	wait 1;
	
	MusicPlay("mp_defeat");
	level notify ("ZB_DEATH");
	
	level.TimerText destroy();
	level.TimerText = level createServerFontString( "objective", 1.6 );
	level.TimerText setPoint( "CENTER", "CENTER", 0, -60 );
	level.TimerText2 destroy();
	level.TimerText2 = level createServerFontString( "objective", 1.6 );
	level.TimerText2 setPoint( "CENTER", "CENTER",0,0);
	
	
	if(level.playersLeft["allies"] == 0)	
		level.TimerText setText("Humans Survived: "+ level.minutes +" mins. "+ level.seconds +" secs.");
	
	if(level.playersLeft["axis"] == 0)
		level.TimerText setText("Cowardly Zombies Ran Away! Human's Win!!!!");
	
	level.TimerText2 setText("" + level.HighScoreName + " Wins! He had the MOST KILLS with " + level.HighKills + " Kills.");
	
	wait 8;
	
	setDvar("ui_uav_allies", 0);
	setDvar("ui_uav_axis", 0);
			
	thread maps\mp\gametypes\_globallogic::endGame( "axis", "Zombies killed all humans" );
	
	wait 1;
	
	level.TimerText destroy();
	level.TimerText2 destroy();
}



class_setup()
{
	if(self.team == "allies")
	{
		self takeallweapons();
		self clearPerks();
	
		self giveWeapon("beretta_mp");
		self setWeaponAmmoStock( "beretta_mp", 60 );
	
		Random = randomInt(2);	
		self giveWeapon(level.shotgz[Random] + "_mp", 4);
		self giveMaxAmmo(level.shotgz[Random] + "_mp");
		
		Random = randomInt(3);
		self giveWeapon(level.Weapon[Random] + "_mp", 4);
		self giveMaxAmmo(level.Weapon[Random] + "_mp");
	
		self switchToWeapon(level.Weapon[Random] + "_mp");
		
		self setPerk("specialty_quieter");
		self setPerk("specialty_bulletpenetration");
	}
	else if(self.team == "axis")
	{
		self clearPerks();
		self takeallweapons();
		self giveWeapon("beretta_mp");
		self setWeaponAmmoClip( "beretta_mp", 0 );
		self setWeaponAmmoStock( "beretta_mp", 0 );
		self switchtoweapon("beretta_mp");
	}
}

doHumans()
{	
	self notify("isHuman");
	
	VisionSetNight( "cheat_contrast", 0.2 );
	self.CustomHealth = 100;
	
	self iPrintlnBold("^1Welcome To Hawkin's COD4 Zombieland v5.1");
	wait 1;
	notifyData = spawnStruct();
	notifyData.titleText = "You Are Human... For Now!";
	notifyData.glowColor = (1.0, 0.0, 0.0);
	notifyData.duration = 4.0;
	thread maps\mp\gametypes\_hud_message::notifyMessage(notifyData);	
	wait 4;
	
	self thread LightWeightSpeed();
	self thread Dvars();
	self thread doLife();
	
	self thread HumanDamage();
	self thread HumanShop();
	self thread HumanScore();
	self thread HumanBuy();
	
	self.PortalBreakers = 4;
	
	if(!self.IN_MENU["AIO"] && !self.IN_MENU["RANK"])
		self freezeControls(false);
	
	while(level.game_state != "playing") wait 1;
		self thread HumanLucks();
	
	if(self.isZombie != 2) self.isZombie = 1; 
}

 


HumanDamage()
{
	self endon("disconnect");
	self endon("death");
	
	while(1)
    {
		self waittill ( "damage", damage, attacker, direction_vec, point, type, modelName, tagName, partName, iDFlags );
		
		if(attacker == self || !isPlayer( attacker ) || !isDefined(attacker.team))
			self.health +=damage;
			
		else if(attacker.team=="axis" && !attacker.isIceZombie) 
		{
			if(level.ZombieBoss==0) 
				attacker.score +=20;
			else
				attacker.score +=10;
		}
		
		else if(attacker.isFlamingZombie) 
			attacker.score +=5;
	}	
}

doZombies()
{	
	self notify("isZombie");
	
	if(self.FirstTimeZombie)
	{
		self.FirstTimeZombie = false;
		self thread doScoreReset();
		wait .1;
		
		self.killz = self.kills;
		self.deathz = self.deaths;
		self.suicidez = self.suicides;
		self.CustomHealth = 100;
		
		notifyData = spawnStruct();
		if(self.isZombie == 2)
		{
			self.CustomHealth = 200;
			notifyData.titleText = "You are a Alpha Zombie with 200 Health";
		}	
		else if(self.luckz > 0)
			notifyData.titleText = "You are a Lucky Zombie";
		else 
			notifyData.titleText = "You are a Whimpy Zombie";
		
		notifyData.glowColor = (1,0,0);
		notifyData.duration = 4.0;
		thread maps\mp\gametypes\_hud_message::notifyMessage( notifyData );
		
		self thread ZombieCash();
		self thread ZombieShop();
		self thread ZombiebBuy();
		
		self thread Dvars();
		self thread SDZFix();
		self thread LuckyZombie(); 
	}
	
	
	if(self.isFlamingZombie) 
		self thread FlamingZombie();
	

	if(self.Bullet > 0)
	{
		self setWeaponAmmoClip("beretta_mp", self.Bullet);
		self setWeaponAmmoStock("beretta_mp", 0);
	}
	if(self.isBomberZombie) self thread ZombieBomber();
	if(self.isSemiInvisibleZombie) self thread SemiInvisible();
	if(level.spawnz == 1) self thread RandomSpawn();
	if(self.isIceZombie) self thread IceZombie();
	if(self.SuperShieldTime > 10) self thread SuperShield(1);
	if(self.hasTechShield) self thread TechS();
	if(self.isFlyingZombie)self thread Flying();
	
	self thread doLife();
	self thread LightWeightSpeed();
}




RandomDrop(var,owner)
{		
	//iprintln("Random drop script");
	
	RandomNum = (50 + (level.minutes * 3));
	
	if(var == 1) 
		RandomNum = 25;
	
	Random = randomInt(RandomNum);
	
	if(Random == 24) 
		owner thread FreeBuy();
		
	if(owner.team == "allies")
	{
		if(Random == 8 || Random == 7)
		{
			owner.SuperShieldTime +=60;	
			owner thread SuperShield(1);
		}
		if(Random == 53)
			owner thread ShakerGun();
		if(Random == 5) 
			level thread InstaKill();
		
		for(i=0;i<level.players.size;i++)
		{
			if(level.players[i].team == "allies")
			{
				if(Random < 2)	
					level.players[i] thread MAmoz();
			}
		}
	}	
	else	
	{	
		if(level.minutes >1 && Random == 18)
			owner thread SSkin();
		if(Random == 78 || Random == 81 || Random == 56 )
			owner thread SSkin();
		if(Random == 15 || Random == 57) 
			owner thread FreeBuy();
		if(Random == 65 && !owner.isIceZombie)
		{
			wait 2; 
			owner iPrintlnBold ("Random Drop: Ice Zombie"); 
			owner thread IceZombie(); 
			owner.isIceZombie = true;
		}
	}
}



 
SDZFix()
{
	self endon("disconnect");
	level endon("game_ended");
	
	while(1)
    {
		self waittill ( "damage", damage, attacker, direction_vec, point, type, modelName, tagName, partName, iDFlags );
		
		if(!isDefined(attacker.team))
			attacker.team = "world";
		
		if(attacker.team != self.team && isPlayer(attacker))
		{
			if(attacker GetCurrentWeapon() != "m21_acog_mp")
				attacker.score +=5;
			else 
				attacker.score +=2;
				
			self.score +=5;
		}
		
		if(!isAlive(self))
		{
			if(!isPlayer( attacker ) && attacker.team != "allies") 
				self.score -= 50;	
			continue;
		}
		else 
		{
			if(attacker == self && self.bsat)
				self.health += damage; 
			
			if(level.instaKill && isPlayer(attacker))
				RadiusDamage(self.origin + (0,0,20), 30, 1000, 900, attacker);
			
			else if(self.isFlyingZombie && isPlayer(attacker))
			{
				self DamagePlayer(250,attacker);
				wait .1;
			}
		}
	}	
} 

HintText()
{
	self endon("disconnect");
	level endon("game_ended");
	
	MiddleText = self createFontString( "objective", 1.4 );
	MiddleText setPoint( "CENTER", "CENTER" );
	self.hint = "";
	
	for(;;)
	{	
		MiddleText setText(self.hint);
		self.hint = "";
		wait .6;
	}
}
RandomSpawn()
{
	random = randomInt(4);
	self SetOrigin(level.ZomSp[random]);
}  

FFTextD()
{	
	self endon("disconnect");
	
	self.ForceFieldText = false;
	
	while(1)
	{
		if(self.ForceFieldText)
		{
			wait 3;
			self.ForceFieldText = false;
		}
		wait .2;
	}
}











MaxAmmozomb()
{	
	self endon("death");
	self endon("disconnect");
	
	while(1)
	{
		weapon = self GetCurrentWeapon();
		
		if(weapon != "dragunov_mp" && weapon != "m40a3_mp")
		{
			self setWeaponAmmoClip(weapon, 150);
			self giveMaxAmmo(weapon);
		}
		wait .5;
	}
}


doEMPZ(time)
{	
	self.PlayerFrozen = true;

	for(i=0;i<level.players.size;i++)
		level.players[i] thread AcEMP(time);
	
	wait 120;
	self.PlayerFrozen = 0;
}

AcEMP(time)
{	
	self endon ( "disconnect" );
	
	if(!isDefined(time))
		time = 4;
	
	self.isFrozen = true;
	
	for(j=time;j>0;j--)
	{
		if(self.team == "axis")	
			self freezeControls(true);
			
		self iPrintlnBold("^1Zombies Frozen");
		wait 3;
	}
	
	if(!self.IN_MENU["AIO"] && !self.IN_MENU["RANK"])
		self freezeControls(false);
	
	self iPrintlnBold("^2Zombies UnFrozen");
	self.isFrozen = false;
	wait 3;
	
	if(!self.IN_MENU["AIO"] && !self.IN_MENU["RANK"])
		self freezeControls(false);
}
FlamingZombie()
{	
	self endon ( "disconnect" ); 
	self endon ( "death" );
	self thread FZFX();

	while(1)
	{	
		for(i=0;i<level.players.size;i++)
		{	
			d = level.players[i].origin + (0,0,20);
			s = self gettagorigin("j_head");
			
			if(level.players[i].team == "allies" && Distance(s, d)<300) 
			
			if(BulletTracePassed(s,d,0,self) || BulletTracePassed(s,level.players[i].origin,0,self) || BulletTracePassed(s,level.players[i] gettagorigin("j_head"),0,self))
			{
				if(level.players[i].SuperShield==1) 
					RadiusDamage(d, 40, 15, 14, self );
				else
					RadiusDamage(d, 40, 35, 25, self );
				level.players[i] thread LightWeightSpeed();
			}
		}
		
		while(level.ZombieBoss) wait 1;
		wait 0.5;
	}
}
FZFX()
{	
	self endon ( "disconnect" ); 
    self endon ( "death" );
	
	while(1)
	{	PlayFX( level.flamez, self.origin );
		wait .5;
	}
}

FlyTrapBuy()	
{
	self.score -= level.FlyTrapCost;
	self iPrintlnBold("^2Trap Placed.");
	owner = self;
	self.FlyTraps++;
	self thread FLTrap(owner);
	level.trapz ++;
}
FLTrap(owner)
{	
	trap = spawn("script_model", owner.origin );
	trap setModel("weapon_c4_mp");
	trap.act = 0;
	trap thread TrapAct(owner);
}	


TrapAct(owner)
{	
	self endon ("disconnect");
	
	org = self.origin;
	fxc4 = SpawnFx(level.C4FXid, (org + (0,0,10)));
	self playSound("oldschool_return");
	TriggerFX(fxc4);
	
	j=0;

	while(1)
	{	
		if(!self.act)
		{	
			for(i=0;i<level.players.size;i++)
			{	
				player = level.players[i];
				
				if(player.team == "axis" && !level.ZombieBoss)
				{
					if(Distance(org, player.origin) < 120)
					{
						if(isAlive(player) && !player.hasTechShield)
						{
							player thread TrapMove(owner);
							self.act = 1;
						}
					}
				}
			}
		}
		
		if(self.act)
		{	
			fxti = SpawnFx(level.fxxx1, org);
			fxti.angles = (270,0,0);
			earthquake( 0.8, 0.5, org, 300 );
			self playSound( "fast_artillery_round" );
			TriggerFX(fxti);
			wait .8;
			fxc4 delete();
			fxti delete();
			self.act = 2;
		}
		if(self.act == 2)
		{	
			j++;
			
			if(j > 100)
			{	self playSound("oldschool_return");
				fxc4 = SpawnFx(level.C4FXid, (org + (0,0,10)));
				TriggerFX(fxc4);
				self.act = 0;
				j=0;
			}
		}
		if(owner.team == "axis" || level.FlyTrapsDestroyed)
		{	
			fxc4 delete();
			level.trapz--;
			owner.FlyTraps--;
			playfx(level.expbullt,self.origin);
			self playSound( "artillery_impact" );
			self delete();
			break;
		}
		while(level.ZombieBoss) wait 1;

		wait .2;
	}
}
TrapMove(owner)
{	
	self endon ("disconnect");
	self endon ("death");
	
	vec = anglestoforward(self getPlayerAngles());
	fvec = (vec[0] * -1000, vec[1] * -1000, 1000);
	
	if(isdefined(self.N))	self.N delete();
	
	self.N = spawn("script_origin", self.origin);
	self linkto(self.N);
	self.N MoveGravity( fvec, 2.5 );
	wait 2.5;
	self playSound("artillery_impact");
	self unlink();
	self.score += 50;
	owner.kills++;
	owner.score += 50;
	self suicide();
}


//MEGA ZOMBIE CODE
ZombieBossTimer()
{
	level.ZombieBossTime = 0;
	time = 5;
	
	if(isDefined(level.ZombieBossSpawn))
	{
		while(1)
		{
			ZombieBossTrigger = (level.minutes - level.ZombieBossTime);
			
			if(ZombieBossTrigger >= time) 
			{	
				level thread ZombieBoss();
				level waittill ("ZB_DEATH");
				wait 9;
				level.ZombieBossTime = (level.minutes + 1);
			}
			wait 1;
		}
	}
}
ZombieBoss()
{	
	if(level.nuke) 
	{
		level notify("ZB_DEATH"); 
		return;
	}
	
	level.ZombieBoss = true;
	level.instaKill = false;
	level.ZombieBossSurvived = false;
	level.HighKills = 0;
	
	SetExpFog(200, 1000, 0.5, 0.4, 0.4, 6);
	
	for(i=0;i<level.players.size;i++)
	{	
		if(level.players[i].team == "axis") level.players[i] ZombieBossDriver();
	}
	
	wait 3;
	
	xf = 2+(level.minutes/2);
	level.ZombieBossHealth = (xf * 300);

	level.BossStructure = spawn("script_origin", level.ZombieBossSpawn);
	Position = 1;
	level.ZombieBossAlive = true;
	
	iPrintlnBold("^1The Zombies Are Forming MEGA-ZOMBIE.");
	
	for(i=0;i<level.players.size;i++)
	{	
		player = level.players[i];
		
		player playsound("mp_war_objective_lost");
		player.HealthBeforeBoss = player.CustomHealth;
		
		if(player.team == "axis")
		{
			player notify("ZB_START");
			player.CustomHealth = 99999; 
			player thread doLife();
			player thread giveUAV();
			
			if(level.HighScoreName == player.name)
			{
				player.BossPosition = 0;
				Position--;
			}
			else player.BossPosition = Position;
			
			
			if(player.BossPosition > 12)
				player thread ZombieBossWait(1);
			else
				player thread ZBossForm(player);
			
			Position++;
		}
		if(isAlive(player) && player.team == "allies")	player thread ZBHLife();
	}
	
	
	level notify("ZB_FORM");
	
	wait 1;
	level.BossStructure linkto(level.BossLeader);
	
	time = 0;
	
	while(1)
	{
		if(level.ZombieBossHealth <= 0)
		{
			smallmm = loadfx("explosions/aerial_explosion");
			playfx(smallmm, level.ZombieBossSpawn);
			Earthquake( 0.8, 3, level.ZombieBossSpawn, 1000 );
			self playsound("mpl_sd_exp_suitcase_bomb_main"); 
			level notify ("ZB_DEATH");
			level.ZombieBossAlive = false;
			level.ZombieBoss = false;
			level.BossStructure unlink();
			level.BossStructure delete();
			SetExpFog(200, 800, 0.5, 0.5, 0.5, 6);
			wait 5;
			break;
		}
		
		wait 1;
		time++;
		
		if(time > 139)
		{
			level.ZombieBossHealth = 0; 
			level.ZombieBossSurvived = true;
			iPrintlnBold("^1Mega-Zombie Time Limit Expired.");
		}
	}
	
	for(i=0;i<level.players.size;i++)
	{	
		player = level.players[i];
		player thread AcEMP(2);
		
		if(player.team == "allies" && player.ZB_AlliesAlive && !level.ZombieBossSurvived) 
		{	
			player.score += 200;
			player iPrintlnBold("^2You Got $200 for Surviving Mega-Zombie.");
			player thread MAmoz();
		}
		if(player.team == "allies" && level.ZombieBossSurvived)
		{
			player.score -= 200;
			player iPrintlnBold("^3You lost $200 for Not Killing Mega-Zombie.");
		}
	}
}
ZombieBossDriver()
{
	if(self.kills >= level.HighKills) 
	{
		level.HighScoreName = self.name;
		level.HighKills = self.kills;
	}
}
ZBHLife()
{
	self endon("disconnect");
	level endon("ZB_DEATH");
	
	self.ZB_AlliesAlive = true;
	self waittill ("death");
	self.dcnt = 1;
	self.ZB_AlliesAlive = false;
	self thread ZombieBossWait(0);
	wait 3;
	self iPrintlnBold("^3You are a Useless BACKYARD ZOMBIE.");
	wait 2;
	self iPrintlnBold("^2You will become Human if Mega-Zombie DIES!");
}
ZombieBossWait(team)
{
	self endon ("disconnect");
	
	self.isWaitingEndOfZB = true;
	
	if(!isDefined(self.HealthBeforeBoss))
		self.HealthBeforeBoss = 100;
	
	self.CustomHealth = self.HealthBeforeBoss;
	
	while(1)
	{
		self takeallweapons();
		wait 2;
		self clearPerks();
		wait 2;
		
		if(!level.ZombieBoss)
		{
			//GO BACK TO ALLIES
			if(team == 0)
			{
				self.isZombie = 0;
				self suicide();
				wait 7;
				self.dcnt = 0;
				self.CustomHealth = self.HealthBeforeBoss;
				self thread Dvars();
				self.isZombie=1;
			}
			else
				self suicide();
			
			self.isWaitingEndOfZB = false;
			
			break;
		}
	}
}
ZBossForm(P)
{	
	BossSpawn = level.ZombieBossSpawn;
	
	level waittill("ZB_FORM");
	
	if(isdefined(self.N)) self.N delete();
	
	if(self.BossPosition == 0) 
	{	
		level.BossLeader = self;
		self.norg = BossSpawn;
		self thread ZombieBossSpeed();
		self thread ResetZombieBossHealth();
	}
	
	if(self.BossPosition == 1) self.norg = (BossSpawn + (0,0,90));
	if(self.BossPosition == 2) self.norg = (BossSpawn + (0,-40,130));
	if(self.BossPosition == 3) self.norg = (BossSpawn + (0,40,130));
	if(self.BossPosition == 4) self.norg = (BossSpawn + (0,0,180));
	if(self.BossPosition == 5) self.norg = (BossSpawn + (0,60,0));
	if(self.BossPosition == 6) self.norg = (BossSpawn + (0,-60,0));
	if(self.BossPosition == 7) self.norg = (BossSpawn + (0,-80,100));
	if(self.BossPosition == 8) self.norg = (BossSpawn + (0,80,100));
	if(self.BossPosition == 9) self.norg = (BossSpawn + (0,0,240));
	if(self.BossPosition == 10) self.norg = (BossSpawn + (0,60,250));
	if(self.BossPosition == 11) self.norg = (BossSpawn + (0,-60,250));
	if(self.BossPosition == 12) self.norg = (BossSpawn + (0,-0,320));
	
	self freezeControls(true);
	
	self setOrigin(self.norg);
	self SetPlayerAngles((0,0,0));
	
	if(self.BossPosition != 0)	
		self linkto(level.BossStructure);
		
	self thread ZombieBossFire();
	self thread ZombieBossHealth();
	wait 2;
	self freezeControls( false );
	level waittill("ZB_DEATH");
	wait .6;
	self playSound("artillery_impact");
	self unlink();
	self.score += 50;
	self.CustomHealth = self.HealthBeforeBoss;
	self suicide();
}
ResetZombieBossHealth()
{	
	level endon("ZB_DEATH");
	self waittill("death");
	level.ZombieBossHealth = 0;
}
ZombieBossSpeed()
{	
	level endon ("ZB_DEATH");

	self iPrintlnBold("^3You're the Godfather Zombie. You Must Drive Mega-Zombie.");
	
	while(1)
	{
		self SetMoveSpeedScale(0.7);
		wait 1;
	}
}
ZombieBossFire()
{
	self endon("disconnect");
	self endon("death");
	level endon("ZB_DEATH");
	
	self takeWeapon("beretta_mp");
	wait .1;
	self giveWeapon("deserteaglegold_mp");
	self setWeaponAmmoClip("deserteaglegold_mp", 1);
	self setWeaponAmmoStock("deserteaglegold_mp", 0);
	wait .1;
	self switchToWeapon("deserteaglegold_mp");
	
	while(1)
	{
		self waittill("weapon_fired");
		
		head = self gettagorigin("j_head");
		trace = bullettrace(head, head + anglestoforward(self getplayerangles())*100000,true,self)["position"]; 
		playfx(level.expbullt,trace);
		self playSound("artillery_impact");
		RadiusDamage(trace, 100, 51, 20, self);
		wait .6;
		self setWeaponAmmoClip("deserteaglegold_mp", 1);
	}
}
ZombieBossHealth()
{	
	self endon ("disconnect");
	level endon ("ZB_DEATH");
	
	wait 2;
	
	while(1)
	{	
		self waittill ( "damage", damage, attacker, direction_vec, point, type, modelName, tagName, partName, iDFlags );
		
		if(attacker.team != "axis")
		{	
			level.ZombieBossHealth = (level.ZombieBossHealth - damage);
			attacker.score += 5;
		}
		wait .05;
	}
}





BRCastPort()
{	
	wait 25;
	
	level.brptsw = 0;
	
	level notify("PRTACT");
	iPrintlnBold("All Players Have 4 Portal Breakers.");
	iPrintlnBold("HOLD [{+melee}] and run into a portal to destroy it.");
	
	j = 1;
	h = 0;
	
	while(1)
	{
		level.brptdel = 0;
		
		for(i=0;i<level.brpt.size;i++)
		{	
			if(j >= 2) 
			{
				j = 0;
				level thread BrSpawn(level.brpt[i],50);
			}
			wait .1;
			j++;
		}
		
		wait 5;
		level.brptdel = 1;
		wait .5;
		
		while(level.brptsw == 1) wait 1;
		 
		if(h == 0)
		{
			j = 2;
			h = 1;
		}
		else if(h == 1)
		{
			j = 1;
			h = 0;
		}
	}
}
BrSpawn(pos,radius)
{
	posa = pos +(0,0,35);
	Effect = SpawnFx(level.fxxx1, pos);
	Effect.angles = (270,0,0);
	TriggerFX(Effect);
	j = 0;
	
	while(level.brptdel == 0)
	{	
		for(i=0;i<level.players.size;i++)
		{
			player = level.players[i];
			
			if(Distance(player.origin, pos) < radius)			
			{
				if(player.brimm == 1) 
					continue;
				
				if(player.PortalBreakers > 0 && player MeleeButtonPressed())
				{
					player.PortalBreakers--;
					playfx(level.boomerz,posa);
					player playSound( "artillery_impact" );
					player iPrintlnBold("You Have " + player.PortalBreakers + " Portal Breakers Left.");
					j = 1;
					break;
				}
				
				rn = randomInt(level.brpt.size);
				player setOrigin(level.brpt[rn]);
				player thread BRImm();
			}
		}
		if(j == 1) 
			break;
		wait .1;
	}
	Effect delete();
}
BRImm()
{	
	self.brimm = 1;
	wait 3.5;
	self.brimm = 0;
}

HumanLucks()
{	
	self endon("death");
	self endon("disconnect");
	
	Luck = 0;
	rd = 0;
	
	while(1)
	{
		so = self.origin;
		sh = 0;
		dis = 450;
		rd++;
		
		for(j=0;j<6;j++)
		{
			son = self.origin;
			se = self.elvz;
			disx = dis - Distance2D(so,self.origin);
			wait 1; 
			
			if(self.elvz != se)
			{
				dis = disx;
				so = self.origin;
			}
			else if(Distance(son,self.origin) > 100)
				sh++;
		}
		
		if(Distance2D(so,self.origin) > dis && sh > 2)
			Luck++;
		else if(Distance(so,self.origin) < 40 && rd > 6)
		{
			rd = 0;
			Luck--;
		}
		
		if(Luck < 0)
			Luck = 0;
		
		if(Luck > 12)
		{	
			self iPrintlnBold("You Earned Some LUCK!");
			self.luckz++;
			Luck = 0; 
			
			if(self.luckz > 2)
			{
				if(self.hasShakerGun != 1)
					self thread ShakerGun();
				else
				{
					self.SuperShieldTime +=60;
					self thread SuperShield(1);
				}
			} 
			else
				self thread FreeBuy();  
		}
	}
}


ExDrag()
{	
	self endon("disconnect");
	self endon("death");
	
	self iPrintlnBold("Ah... Wise Choice My Son. Take This Old Weapon.");
	self giveWeapon("dragunov_mp", 6);
	self giveStartAmmo("dragunov_mp");
	wait .5;
	self switchToWeapon("dragunov_mp");	
	
	while(1)
	{
		self waittill("weapon_fired");
	
		if(self GetCurrentWeapon() != "dragunov_mp")
			continue;
		
		head = self gettagorigin("j_head");
		trace = bullettrace(head, head + anglestoforward(self getplayerangles())*100000,true,self)["position"];
		
		playfx(level.expbullt,trace);
		self playSound("artillery_impact");
		
		for(i=0;i<level.players.size;i++)
		{
			player = level.players[i];
			playerOrigin = player.origin;
			playerOriginB = playerOrigin + (0,0,30);
			distance = distance(playerOrigin, trace);
			
			if(distance < 150 && player.team == "axis")
			if(level.ZombieBoss)
			{
				RadiusDamage( trace, 60, 200, 50, self );
				break;
			}
			else if(BulletTracePassed(trace,playerOrigin,0,self) || BulletTracePassed(trace+(0,0,30),playerOriginB,0,self) || BulletTracePassed(trace,playerOriginB,0,self))
			{
				vdam = 900-(distance*6);
				
				if(!player.hasTechShield) 
					RadiusDamage( playerOriginB, 40, vdam, 50, self );
				else
					RadiusDamage( playerOriginB, 40, int(vdam/5), 50, self );
			}
		}	
	}
}



ZombieBomber()
{
	self endon("ZB_START");
	self endon("death");
	
	self iPrintlnBold("Press [{+actionslot 1}] to explode.");
	self.isBomberZombie = true;
	
	self thread CrazyTrig();
	self thread CrazyFX();
	
	while(1)
	{	
		self SetMoveSpeedScale( 1.5 );
		Origin = self.origin + (0,0,20);
		
		if(!self.isBomberZombie)
		{
			playfx(level.boomerz, Origin);
			self playSound( "exp_suitcase_bomb_main" );
			RadiusDamage(Origin, 250, 500, 125, self );
			wait .3;
			level.BomberZombieOnMap = false;
			self suicide();
		}
		wait .1;
	}
}	
CrazyTrig()
{
	self endon("death");
	self endon("ZB_START");
	self waittill( "night_vision_on" );
	level.BomberZombieOnMap = true;
	self.isBomberZombie = false;
}
CrazyFX()
{	
	self endon ("death");
	self endon ("ZB_START");
	
	for(;;)
	{
		origin = self.origin + (0,0,20);
		playfx(level.fxsmoke, origin);
		self playSound("ui_mp_timer_countdown");
		self playSound("ui_mp_suitcasebomb_timer");
		self playSound("weap_suitcase_defuse_plr");
		wait .5;
		playfx(level.fxsmokes, origin);
		wait .5;
	}
}


doNUKE(owner)
{
	if(isDefined(level.TimerText)) level.TimerText destroy();
	
	level.TimerText = level createServerFontString( "default", 1.5 );
	level.TimerText setPoint( "CENTER", "CENTER", 0, 50 );
	level.TimerText setText("^3" + owner.name + " ^1Activated the ^6Zombie Launcher. ^7It takes 60 Seconds to Charge.");
	wait 5;
	level.TimerText setText("");
	wait 25;
	level.TimerText setText("In 30 Seconds Zombies Die");
	wait 3;
	level.TimerText setText("");
	wait 27;
	
	if(isDefined(owner) && isAlive(owner) && owner.team == "allies")
	{
		Earthquake( 0.6, 4, owner.origin, 800 );
		
		for(i=0;i<level.players.size;i++)
		{	
			if(level.players[i].team == "axis") 
				level.players[i] thread NukeEffects();
		}
		
		wait 4;
		visionSetNaked( "mpIntro", 0 );
		level.TimerText setText("^1"+ owner.name +" ^2Wins! All Zombies Were Destroyed!");
		level notify("GEND");
		wait 4;
		level.TimerText destroy();
		
		thread maps\mp\gametypes\_globallogic::endGame( "allies", "Tactical Nuke" );
	}
	else
	{
		level.TimerText setText("^3" + owner.name + "^2became a Zombie. Zombies Survive.");
		level.nuke = false;
		wait 5;
		level.TimerText destroy();
	}
}
NukeEffects()
{	
	self setClientDvar("g_gravity", "100"); 
	
	for(j=35;j>0;j--)
	{
		self SetOrigin( self.origin + (0,0,150));
		wait .1;
	}
	
	FX = loadfx("explosions/aerial_explosion_large");
	playfx(FX, self.origin);
	self playSound( "exp_suitcase_bomb_main" );
	wait 2;
	self suicide();
}


GameTimer()
{	
	level endon("GEND");
	
	while(1)
	{	
		wait 1;
		level.seconds++;
		
		if(level.seconds == 60)
		{
			level.minutes++;
			level.seconds = 0;
		}
	}
}
 

SpNorm(speed, time, acc, li)
{	
	self endon("death");
	self endon("disconnect");
	
	if(!isDefined(li))
		li = 0;

	if(self.hasLightWeight == 1 && li == 0)
		return;
		
	if(!isDefined(acc))
		acc = 0;

	self SetMoveSpeedScale(speed);
	wait time;
	
	for(;;)
	{
		if(acc == 0)
			break;
		speed = (speed + 0.1);
		self SetMoveSpeedScale( speed );
		
		if(speed == 1.0)
			break;
		wait .15;
	}	
	self thread LightWeightSpeed();
}


doScoreReset()
{	
	self.pers["score"] = 0;
	self.pers["kills"] = 0;
	self.pers["assists"] = 0;
	self.pers["deaths"] = 0;
	self.pers["suicides"] = 0;
	self.score = 0;
	self.kills = 0;
	self.assists = 0;
	self.deaths = 0;
	self.suicides = 0;
	self.headshots = 0;
}

doLasta() 
{	
	self iPrintlnBold("^1You're Last Alive. You've Earned $300.");
	self.score += 300;
	self.FlyTraps--;
	wait 2;
	
	if(isDefined(level.ZombieBossSpawn))	
		self SetOrigin(level.ZombieBossSpawn);
		
	self iPrintlnBold("No more Camping For You.");
	self thread doEMPZ(3);
	wait 2;
	self.PlayerFrozen = false;
}



MenuMove()
{	
	self endon("disconnect");
	level endon("game_ended");
	
	while(1)
	{	
		if(self SecondaryOffhandButtonPressed())
		{
			self.menu++;
			
			if(self.team == "allies")
			{
				if(self.menu > 9) 
					self.menu = 0;
			}
			else 
			{
				if(self.menu > 11)
					self.menu = 0;
			}
			
			wait .3;
		}
		
		if(self UseButtonPressed() && !self.isShowingHealth)	
		{
			wait .7;
			if(self UseButtonPressed()) 
			{
				self.isShowingHealth = true;
				self thread ShowCurrentHealth();
			}
		}
		wait .05;
	}
}

ShowCurrentHealth()
{
	self iPrintln("^7Health: ^3" + self.health + "^2/" + self.CustomHealth );
	wait 3;
	self.isShowingHealth = false;
}

HumanShop()
{	
	self endon("disconnect");
	self endon("isZombie");
	self endon("isHuman");
	
	while(1)
	{
		self.CurrentGun = self GetCurrentWeapon();
		
		if(self.menu == 0)
		{	
			if(self.CurrentGun == "beretta_mp")	
				self iPrintln("Hold [{+frag}]| Exchange Gun For Sniper Rifle ^3$75");
			
			else if(self.hasAssaultRifle && !self.hasLMG)
				self iPrintln("Hold [{+frag}]| Exchange Gun For Light Machine Gun ^3$125");
			
			else if(self.hasLMG && !self.IceGun)
				self iPrintln("Hold [{+frag}]| Exchange Gun For Rocky's Freeze-Ray ^3$350");
			
			else if(self.IceGun) 
				self.menu++;
			
			else 
				self iPrintln("Hold [{+frag}]| Exchange Gun For Assault Rifle ^3$100");
		}
		
		if(self.menu == 1 && self.CustomHealth < 300) self iPrintln("Hold [{+frag}]| Health ^3$300");
		if(self.menu == 1 && self.CustomHealth > 250)self.menu++;
		if(self.menu == 2 && !self.hasSleightOfHand && !self.hasBulletDamage) self iPrintln("Hold [{+frag}]| Slight of Hand ^3$100");
		if(self.menu == 2 && self.hasSleightOfHand && !self.hasBulletDamage) self iPrintln("Hold [{+frag}]| Stopping Power ^3$250");
		if(self.menu == 2 && self.hasBulletDamage && !self.hasSteadyAim) self iPrintln("Hold [{+frag}]| Super Steady Aim ^3$100");
		if(self.menu == 2 && self.hasBulletDamage && self.hasSteadyAim) self.menu++;
		if(self.menu == 3 && !self.hasLightWeight) self iPrintln("Hold [{+frag}]| Lightweight ^3$250");
		if(self.menu == 3 && self.hasLightWeight && !self.hasDoubleTap) self iPrintln("Hold [{+frag}]| Double Tap ^3$100");
		if(self.menu == 3 && self.hasLightWeight && self.hasDoubleTap) self.menu++;
		if(self.menu == 4 && self.kills > 29 && !self.hasUnlimitedAmmo) self iPrintln("Hold [{+frag}]| Unlimited Ammo ^3$100");
		if(self.menu == 4 && self.hasUnlimitedAmmo) self.menu++;
		if(self.menu == 4 && self.kills < 30) self iPrintln("Get 30 Kills First To Buy Unlimited Ammo");
		if(self.menu == 5 && !self.hasExplodingDragon) self iPrintln("Hold [{+frag}]| Exploding Dragon ^3$450");
		if(self.menu == 5 && self.hasExplodingDragon) self.menu++;
		if(self.menu == 6 && self.FlyTraps < 2) self iPrintln("Hold [{+frag}]| Place Fly Trap ^3$" + level.FlyTrapCost );
		if(self.menu == 6 && self.FlyTraps >= 2) self.menu++;
		if(self.menu == 7) self iPrintln("Hold [{+frag}]| Zombie Freezer ^3$300");
		if(self.menu == 8) self iPrintln("Hold [{+frag}]| Helicopter ^3$300");
		if(self.menu == 9) self iPrintln("Hold [{+frag}]| Send Zombies To Space(Human's Win) ^3$2299");
		
		self.menu_wait = self.menu;
		
		for(a=50;a>0;a--)
		{
			wait .1;
			if(self.menu_wait != self.menu)
				break;
		}
		
		wait .1;
		
	}
}

HumanScore()
{	
	self endon("disconnect");
	self endon("isZombie");
	self endon("isHuman");
	
	self.killz = self.kills;
	self.headshotz = self.headshots;
	
	j = 0;
	
	while(1)
	{
		//iprintln("headshots"+self.headshots);
		//iprintln("headshotz"+self.headshotz);
		
		
		if(self.headshots - self.headshotz > 0)	
		{
			self.score += 50;
			self.headshotz++;
			j++;
			self iprintln("^1Random drop");
			level thread RandomDrop(0,self);
		}
		
		if(self.kills - self.killz > 0)
		{
			self.killz++;
			j++;
			
			if(self.luckz>0)
			{
				j = 4 - self.luckz; 
				
				if(j==0) 
				{
					level thread RandomDrop(0,self);
					self iprintln("^2Random drop");
				}
				
			}
			
			level thread RandomDrop(0,self);
			
			if(j>11)
			{
				self iprintln("^3Random drop");
				j=0; 
				RandomDrop(1,self);
				
			}
		}

		if(self.score < 0)
			self.score = 0;
		
		self.pers["score"] = self.score;
		wait .1;
	}
}

LightWeightSpeed()
{
	if(self.hasLightWeight)
		self SetMoveSpeedScale(1.4);
	else	
		self SetMoveSpeedScale(1.0);
}


HumanBuy()
{	
	self endon("disconnect");
	self endon("isZombie");
	self endon("isHuman");
	
	while(1)
	{
		if(self FragButtonPressed())
		{	
			wait .5;
			
			if(self FragButtonPressed())
			{
				if(self.menu == 0) 
				{
					if(self.CurrentGun == "beretta_mp")
					{
						if(self.score >= 75)
						{
							self.score -=75;
							self iPrintlnBold("^2Weapon Bought");
							self takeWeapon(self.CurrentGun);
							self giveWeapon("barrett_mp", 4);
							self giveMaxAmmo("barrett_mp");
							self switchToWeapon("barrett_mp");
						}
						else	
							self thread MorePoint();
					}	
					else	
					{
						if(self.hasAssaultRifle == 1 && self.hasLMG == 0)
						{	
							if(self.score >= 125)
							{
								self.score -=125;
								Random = randomInt(3);
							
								self iPrintlnBold("^2Weapon Bought");
								self takeWeapon(self.CurrentGun);
								self giveWeapon(level.lmgz[Random] + "_mp", 4);
								self giveMaxAmmo(level.lmgz[Random] + "_mp");
								wait .1;
								self switchToWeapon(level.lmgz[Random] + "_mp");
								self.hasLMG = 1;
							}	
							else
								self thread MorePoint();
						}	
						else	
						{
							if(self.hasLMG == 1 && self.IceGun == 0)
							{
								if(self.score >= 350)
								{	
									self.score -= 350;
									self takeWeapon(self.CurrentGun);
									self.IceGun = 1;
									wait .1;
									self thread IceGun();
								}	
								else
									self thread MorePoint();
							}
							else if(self.IceGun == 1)
								g = 1;
							else	
							{
								if(self.score >= 100)
								{	
									self.score -= 100;
									Random = randomInt(4);
									self iPrintlnBold("^2Weapon Bought");
									self takeWeapon(self.CurrentGun);
									self giveWeapon(level.ass[Random] + "_mp", 4);
									self giveMaxAmmo(level.ass[Random] + "_mp");
									wait .1;
									self switchToWeapon(level.ass[Random] + "_mp");
									self.hasAssaultRifle = 1;
								}	
								else
									self iPrintlnBold("^1Can't Buy.");
							}
						}
					}
				}	
				if(self.menu == 1)
				{
					if(self.score >= 300 && self.CustomHealth < 300)
					{
						self.score -=300;
						self.CustomHealth +=50;
						self thread doLife();
						self iPrintlnBold("^2Health Bought. Hold [{+reload}] To See");
					}	
					else
						self thread MorePoint();
				}
				if(self.menu == 2)
				{
					if(!self.hasSleightOfHand) 
					
					if(self.score >= 100) 
					{
						self.score -=100;
						self iPrintlnBold("^2Perk Bought");
						self setPerk("specialty_fastreload");
						self showPerk( 2, "specialty_fastreload", -50 );
						self.hasSleightOfHand = true;
						wait 2; 
						continue;
					}
					else
						self thread MorePoint();
					
					if(self.hasSleightOfHand && !self.hasBulletDamage)
					
					if(self.score >= 250)
					{
						self.score -=250;
						self iPrintlnBold("^2Perk Bought");
						self setPerk("specialty_bulletdamage");
						self showPerk( 3, "specialty_bulletdamage", -50 );
						self setClientDvar( "perk_bulletdamage", "99" );
						self.hasBulletDamage = true; 
						wait 2;
						continue;
					}	
					else
						self thread MorePoint();
					
					if(!self.hasSteadyAim && self.hasBulletDamage) 
					
					if(self.score >= 100)
					{
						self.score -=100;
						self iPrintlnBold("^2Perk Bought");
						self setPerk("specialty_bulletaccuracy");
						self showPerk( 0, "specialty_bulletaccuracy", -50 );
						self setClientDvar( "perk_weapspreadMultiplier", "0.1" );
						self setClientDvar( "cg_laserForceOn", "1" );
						self.hasSteadyAim = true;
					}	
					else
						self thread MorePoint();
				}
				if(self.menu == 3)
				{	
					if(!self.hasLightWeight)
					
					if(self.score >= 250)
					{	
						self.score -=250;
						self iPrintlnBold("^2Perk Bought");
						self.hasLightWeight = true;
						self.PortalBreakers +=4;
						self thread LightWeightSpeed();
						wait 2;
						continue;
					}	
					else
						self thread MorePoint();
					
					if(self.score >= 100 && !self.hasDoubleTap && self.hasLightWeight)
					{	
						self.score -=100;
						self iPrintlnBold("^2Perk Bought");
						self setPerk("specialty_rof");
						self showPerk( 1, "specialty_rof", -50 );
						self.hasDoubleTap = true;
					}	
					else
						self thread MorePoint();
				}
				
				if(self.menu == 4)
				{
					if(!self.hasUnlimitedAmmo && self.kills > 29) 
					
					if(self.score >= 100)
					{
						self.score -=100;
						self thread MaxAmmozomb();
						self.hasUnlimitedAmmo = true;
						self iPrintlnBold("^2You Have Unlimited Ammo");
					}	
					else	
						self thread MorePoint();
				}
				if(self.menu == 5)
				{	
					if(self.score >= 450 && !self.hasExplodingDragon)
					{
						self.score -=450;
						self thread ExDrag();
						self.hasExplodingDragon = true;
					}	
					else	
						self thread MorePoint();
				}
				if(self.menu == 6)
				{
					if(self.score >= level.FlyTrapCost && level.trapz < 10 && self.FlyTraps < 2)
					{
						if(isDefined(level.zpswitch))
						{
							if(Distance(self.origin, level.zpswitch) < 450)
							{
								self iPrintlnBold("^3Can't Place A Trap. This Close to a Zipline Switch.");
								wait 2;
								continue;
							}
						}
						self thread FlyTrapBuy();
					}
					else
						self thread MorePoint();
				}
				if(self.menu == 7)
				{
					if(self.score >= 300 && self.empz == 0 && !level.FlyTrapDestroy && !level.ZombieBoss && !level.nuke)
					{	
						self.score -=300;
						self iPrintlnBold("^2Emp Bought");
						self thread doEMPZ();
					}	
					else
						self iPrintlnBold("^3Can't Buy It. Right Now.");
				}
				if(self.menu == 8) 
				{
					if(self.score >= 300)
					{
						self.score -=300;
						self iPrintlnBold("^2Helicopter Bought.");
						self giveWeapon( "helicopter_mp" );
						self giveMaxAmmo( "helicopter_mp");
						self setActionSlot( 4, "weapon", "helicopter_mp" );
						self.pers["hardPointItem"] = "helicopter_mp";
					}	
					else	
						self thread MorePoint();
				}
				if(self.menu == 9)	
				{
					if(self.score >= 2299)
					{
						self.score -=2299;
						level thread doNUKE(self);
						level.nuke = true;
					}
					else	
						self thread MorePoint();
				}
				wait 3;
			}	
			else
				continue;
		}
		wait .1;
	}
}

MorePoint()
{
	self iPrintlnBold("^1Need More Points.");
}


LuckyZombie()
{	
	wait 4;
	
	if(self.luckz == 0)
		return;
	
	self.CustomHealth += 100;
	
	if(self.luckz == 1)
	{	
		self iPrintlnBold("You're Mildly Lucky +100 Health");
		return;
	}
	
	else if(self.luckz == 2)
		self iPrintlnBold("You're Very Lucky +100 Health & Lightweight");
	
	self.hasLightWeight = 1;
	self thread LightWeightSpeed();
		
	lu = ((self.luckz*100)-200);
	lux = lu - 100;
	
	if(lux > 290)
		lux = 300;
	
	else if(self.luckz > 2)
		self iPrintlnBold("You're Amazingly Lucky " + lu + ":Health, Lightweight & Semi-Visible.");
	else if(self.luckz > 3)
		self.CustomHealth += lux;
}

ZombieShop()
{	
	self endon("disconnect");
	level endon("game_ended");
	
	while(1)
	{	 
		if(self.menu == 0 && self.CustomHealth < 1000) self iPrintln("Hold [{+frag}] | Health ^3$50 ^7| Current Health: " + self.CustomHealth + "");
		if(self.menu == 0 && self.CustomHealth > 999) self.menu++;
		if(self.menu == 1 && !self.UneFois) self iPrintln("Hold [{+frag}] | Flame Zombie ^3$1000");
		if(self.menu == 1 && self.UneFois) self.menu++;
		if(self.menu == 2) self iPrintln("Hold [{+frag}] | Five Bullets ^3$300");
		if(self.menu == 3 && !self.hasLightWeight) self iPrintln("Hold [{+frag}] | Lightweight ^3$300");
		if(self.menu == 3 && self.hasLightWeight && !self.hasTechShield) self iPrintln("Hold [{+frag}] | Tech Shield ^3$450");
		if(self.menu == 3 && self.hasTechShield) self.menu++;
		if(self.menu == 4 && !self.isFlyingZombie) self iPrintln("Hold [{+frag}] | CrazyAzn Bomber Zombie ^3$500");
		if(self.menu == 4 && self.isFlyingZombie) self.menu++;
		if(self.menu == 5) self iPrintln("Hold [{+frag}] | Flash Grenade ^3$25");
		if(self.menu == 6) self iPrintln("Hold [{+frag}] | Teleport ^3$500");
		if(self.menu == 7) self iPrintln("Hold [{+frag}] | UAV ^3$25");
		if(self.menu == 8 && !self.isSemiInvisibleZombie) self iPrintln("Hold [{+frag}] | Semi-Visible Assassin Zombie ^3$350");
		if(self.menu == 8 && self.isSemiInvisibleZombie) self.menu++;
		if(self.menu == 9) self iPrintln("Hold [{+frag}] | Destroy All Fly Traps ^3$400");
		if(self.menu == 10 && !self.UneFois) self iPrintln("Hold [{+frag}] | Become Ice Zombie ^3$500");
		if(self.menu == 10 && self.UneFois) self.menu++;
		if(self.menu == 11 && !self.UneFois) self iPrintln("Hold [{+frag}] | Become Flying Zombie ^3$600");
		if(self.menu == 11 && self.UneFois) self.menu++;
		
		self.menu_wait = self.menu;
		
		for(a=50;a>0;a--)
		{	
			wait .1;
			if(self.menu_wait != self.menu) 
				break;
		}
		
		while(level.ZombieBoss) wait 1;
		
		wait .1;
	}
}

doLife()
{	
	self.maxhealth = self.CustomHealth;
	self.health = self.maxhealth;
}  


ZombieBullets()
{	
	for(;self.Bullet>0;self.Bullet--)
		self waittill("weapon_fired");
}

ShakerGun()
{	
	self endon("disconnect");
	self endon("death");
	level endon("game_ended");
	
	if(self.hasShakerGun)
		return;
	
	self.hasShakerGun = true;
	
	self iPrintlnBold("^6Random Drop: Shaker Gun");

	self giveWeapon("uzi_mp", 6);
	self giveMaxAmmo("uzi_mp");
	
	wait .5;
	
	self switchToWeapon("uzi_mp");
	
	while(1)
	{	
		self waittill("weapon_fired");
		
		weapon = self GetCurrentWeapon();
		
		if(weapon != "uzi_mp")
			continue;
		
		head = self gettagorigin("j_head");
		trace = bullettrace(head, head + anglestoforward(self getplayerangles())*100000,true,self)["position"];
		
		for(i=0;i<level.players.size;i++)
		{
			if(level.players[i].team == "axis")
			{
				if(distance(level.players[i].origin,trace) < 130 && !level.players[i].hasTechShield)
					level.players[i] shellshock("concussion_grenade_mp", 1.5);
			}
		}
		wait .5;
	}
} 

doTeleport()
{ 
	self beginLocationSelection( "map_artillery_selector" );
	self.selectingLocation = true;
	self waittill( "confirm_location", location );
	
	if(!self.Teleported)
		newLocation = PhysicsTrace(location + ( 0, 0, 1000 ), location - ( 0, 0, 1000 ));
	else
		newLocation = PhysicsTrace(location + ( 0, 0, 400 ), location - ( 0, 0, 500 ));
	
	self SetOrigin(newLocation);
	self endLocationSelection();
	self.selectingLocation = undefined;
	
	self iPrintlnBold("^2If Your Teleport Went Wrong...");
	
	wait 3;
	
	if(!self.Teleported)
		self thread TeleportAgain();
	else
		iPrintlnBold("^1Sorry Only 1 Teleport Redo");
}					
TeleportAgain()
{	
	self iPrintlnBold("^7Press & Hold [{+usereload}] to Teleport again, You have 5 Seconds");
	
	for(j=30;j>0;j--)
	{
		if(self UseButtonPressed())
		{	
			wait .8;
			if(self UseButtonPressed())
			{
				self.Teleported = true;
				self thread doTeleport();
				break;
			}
		}
		wait .2;
	}		
}

giveUAV()
{	
	self giveWeapon("radar_mp");
	self giveMaxAmmo("radar_mp");
	self setActionSlot( 3, "weapon", "radar_mp" );
	self.pers["hardPointItem"] = "radar_mp";
}


SemiInvisible()
{
	self endon("death");
	self endon("disconnect");
	level endon("game_ended");
	
	while(1)
	{
		self hide();
		wait .3;
		self show();
		wait .3;
	}
}

DestroyAllTraps()
{
	iPrintlnBold("^3All Fly Traps will be destroyed in 15 Seconds");
	level.FlyTrapDestroy = true;
	wait 15;
	iPrintlnBold("^1Fly Traps Destroyed");
	iPrintlnBold("^3Any Fly Traps Bought in the Next 30 Seconds, will also be destroyed.");
	level.FlyTrapsDestroyed = true;
	wait 30;
	level.FlyTrapsDestroyed = false;
	iPrintlnBold("^2Fly Traps May Be Placed Again");
	level.FlyTrapDestroy = false;
}

IceZombie()
{
	self endon("disconnect");
	self endon("death");
	level endon("game_ended");
	
	while(1)
	{
		for(i=0;i<level.players.size;i++)
		{	
			if(level.players[i].team == "allies" && Distance2D(self.origin, level.players[i].origin) < 180 && level.players[i].SuperShield != 1)
			{	
				if(level.players[i].hasLightWeight) 
					level.players[i] SetMoveSpeedScale(.6);
				else	
					level.players[i] SetMoveSpeedScale(.3);
				
				level.players[i] thread IceAct(self);
			}
		}
		while(level.ZombieBoss) wait 1;

		wait .3;
	}
}
IceAct(owner)
{	
	self endon("disconnect");
	self endon("death");
	level endon("game_ended");
	
	if(self.IceZombieAttacking)
		return;
	
	self.IceZombieAttacking = true;
	ice = IceVision(self);
	
	while(self.IceZombieAttacking)
	{
		if(Distance2D(self.origin, owner.origin) > 200)
		{
			ice destroy();
			self thread LightWeightSpeed();
			self.IceZombieAttacking = false;
			self notify("IceEnd");
			break;
		}
		origin = self.origin + (0,0,20);
		RadiusDamage(origin, 40, 10, 4, owner );
		
		wait .8;
	}
}
IceVision(owner)
{
	ice = newClientHudElem( owner ); 
	ice.x = 0; 
	ice.y = 0; 
	ice.alignX = "CENTER"; 
	ice.alignY = "CENTER"; 
	ice.horzAlign = "fullscreen"; 
	ice.vertAlign = "fullscreen"; 
	ice.alpha = 1; 
	ice.color = (0.0,0.0,0.4);
	ice setshader("overlay_low_health", 960, 480);
	owner thread DestroyOnDeath(ice, "IceEnd");
	return ice;
}

DestroyOnDeath(Element,noti)
{
	if(isDefined(noti))
		self endon(noti);
		
	self waittill("death");
	
	Element destroy();
}




IceGun()
{	
	self endon("death");
	level endon("game_ended");
	
	self giveWeapon("m40a3_mp", 5);
	self giveStartAmmo("m40a3_mp");
	wait .1;
	self switchToWeapon("m40a3_mp");
	
	while(1)
	{	
		self waittill("weapon_fired");
		
		weapon = self GetCurrentWeapon();
		
		if(weapon != "m40a3_mp") 
			continue;
		
		head = self gettagorigin("j_head");
		trace = bullettrace(head, head + anglestoforward(self getplayerangles())*100000,true,self)["position"];
		
		for(i=0;i<level.players.size;i++)
		{
			if(level.players[i].team != "axis")
				continue;
				
			distance = Distance(level.players[i].origin, trace);
			
			if(level.ZombieBoss && distance <= 200)
			{
				level.players[i] thread DamagePlayer(50,self);
				wait .05;
				continue;
			}
			
			if(!level.players[i].hasTechShield && distance <= 200 && isAlive(level.players[i])) level.players[i] thread IceGunAct(self,distance,trace);
			//else if(p.hasTechShield==1)	{p thread SpNorm(0.7,1.5,0,1); p thread DamagePlayer(75,self);}
		}
		wait .2;
	}
}
IceGunAct(owner,distance,trace)
{
	self endon("death");
	self endon ("disconnect");
	
	damage = 60;
	time = 60;
	ice = IceVision(self);
	
	if(distance >= 60)
	{
		damage = 45;
		time = 40;
	}
		
	if(distance > 120)
	{
		damage = 35;
		time = 20;
	}
	
	if(distance > 180)
	{
		damage = 30;
		time = 10;
	}
	if(distance < 60)
	{
		self thread Icedead();
		self freezeControls(true);
	}
	
	brfree = 0;
	j = 0;
	
	for(x=0;x<time;x++)
	{	
		self SetMoveSpeedScale(.1);
		
		if(!self isOnGround() && j == 0)
		{
			brfree++;
			ice.alpha = 0;
			j = 1;
		}
		
		if(int(x/5) == (x/5))
		{
			if(self isOnGround() || (self.isFlyingZombie && Distance(self.origin,trace) < 200))
				self thread DamagePlayer(damage,owner);
		}
		else if (j == 1 && self isOnGround())
			self thread DamagePlayer(damage,owner);
		
		if(self isOnGround())
		{
			j = 0;
			ice.alpha=1;
		}
		
		if(brfree > 3)
			break;
		wait .1;
	}
	
	ice destroy();
	self notify ("IceEnd");
	self thread LightWeightSpeed();
	
	if(distance < 65)
	{
		if(!self.IN_MENU["AIO"] && !self.IN_MENU["RANK"])
			self freezeControls(false);
		
		self notify("Unfreeze");
	}
}
Icedead()
{	
	self endon("Unfreeze");
	self endon("disconnect");
	self waittill("death");
	
	if(!self.IN_MENU["AIO"] && !self.IN_MENU["RANK"])
		self freezeControls(false);
}



ZombiebBuy()
{
	self endon("disconnect");
	level endon("game_ended");
	
	while(1)
	{	
		if(self FragButtonPressed())
		{
			wait .5;
			
			if(self FragButtonPressed())
			{
				if(self.menu == 0) 
				{
					if(self.score >= 50 && self.CustomHealth < 1000)
					{
						self.score -= 50;
						self.CustomHealth += 50;
						self thread doLife();
						self iPrintlnBold("^2Health Bought. Hold [{+reload}] To See");
					}	
					else
						self iPrintlnBold("^1Can't Buy");
				}	
				if(self.menu == 1)
				{	
					if(self.score >= 800 && !self.isFlamingZombie && !self.UneFois)
					{
						self.score -= 800;
						self thread FlamingZombie();
						self.isFlamingZombie = true;
						self.UneFois = true;
						self iPrintlnBold("^2You Are Now A Flame Zombie");
					}	
					else
						self iPrintlnBold("^1Can't Buy This");
				}
				if(self.menu == 2) 
				{
					if(self.score >= 300 && self.Bullet <= 5)
					{
						self.score -= 300;
						self iPrintlnBold("^2Bullets Bought");
						self.Bullet = 5;
						self setWeaponAmmoClip("beretta_mp", 5);
						self thread ZombieBullets();
					}	
					else	
						self iPrintlnBold("^3Can't Buy It.");
				}
				if(self.menu == 3) 
				{	
					if(!self.hasLightWeight) 
					if(self.score >= 300)
					{
						self.score -= 300;
						self iPrintlnBold("^2Perk Bought");
						self.hasLightWeight = true;
						self thread LightWeightSpeed();
					}	
					else
						self iPrintlnBold("^3Need $$");
					
					if(!self.hasTechShield && self.hasLightWeight)
					if(self.score >= 450) 
					{	
						self.score -=450;
						self iPrintlnBold("^2You're Immune to Traps, Super Shields, and Special Weapons.");
						self.hasTechShield = true;
						self thread TechS();
					}	
					else
						self iPrintlnBold("^3Need $$");
				}
				if(self.menu == 4) 
				{	
					if(self.score >= 500 && !self.isBomberZombie && !self.isFlyingZombie)
					{
						self.score -= 500;
						self thread ZombieBomber();
					}	
					else
						self iPrintlnBold("^1Can't Buy This");
				}
				if(self.menu == 5) 
				{
					if(self.score >= 25)
					{
						self.score -= 25;
						self setOffhandSecondaryClass("flash");
						self GiveWeapon( "flash_grenade_mp" );
						self SetWeaponAmmoClip( "flash_grenade_mp", 1 );
						self SwitchToOffhand( "flash_grenade_mp" );
						self iPrintlnBold("^2Flash Grenade Bought");
					}	
					else
						self iPrintlnBold("^1Can't Buy This");
				}
				if(self.menu == 6) 
				{	
					if(self.score >= 500)
					{
						self.score -= 500;
						self.Teleported = false;
						self thread doTeleport();
					}
					else
						self iPrintlnBold("^3Need More $$");
				}
				if(self.menu == 7)
				{	
					if(self.score >= 25)
					{
						self.score -= 25;
						self thread giveUAV();
						self iPrintlnBold("^2UAV Bought");
					}
					else
						self iPrintlnBold("^3Need More $$");
				}
				if(self.menu == 8)
				{
					if(self.score >= 350 && !self.isSemiInvisibleZombie)
					{
						self.score -= 350;
						self thread SemiInvisible();
						self iPrintlnBold("^2Peekaboo No One Can See You.");
						self.isSemiInvisibleZombie = true;
						wait 1;
						self iPrintlnBold("^2OH now they can, wait can't, can, can't");
					}	
					else
						self iPrintlnBold("^3Can't Buy It.");
				}
				if(self.menu == 9)
				{	
					if(self.score >= 400 && !level.FlyTrapDestroy)
					{
						self.score -= 400;
						self thread DestroyAllTraps();
					}
					else
						self iPrintlnBold("^3Can't Buy It.");
				}
				if(self.menu == 10)
				{
					if(self.score >= 500 && !self.UneFois)
					{
						self.score -= 500;
						self thread IceZombie();
						self iPrintlnBold("You Are Now An Ice Zombie");
						self.isIceZombie = true;
						self.UneFois = true;
					}
					else
						self iPrintlnBold("^3Can't Buy It.");
				}
				if(self.menu == 11)
				{	
					if(self.score >= 600 && !self.UneFois)
					{
						self.score -= 600;
						self thread Flying();
						self iPrintlnBold("You Are Now A Flying Zombie.");
						self iPrintlnBold("However Bullets Damage You Much More.");
						self.isFlyingZombie = true;
						self.UneFois = true;
					}
					else
						self iPrintlnBold("^3Can't Buy It.");
				}
				wait 3;
			}	
			else
				continue;
		}
		
		while(level.ZombieBoss) wait 1;
		
		wait .1;
	}
}

InstaKill()
{
	if(level.instaKill || level.ZombieBoss || level.instakill_locked)
		return;
	
	level.instaKill = true;
	level.instakill_locked = true;
	iPrintlnBold("Random Drop: One-Shot Zombie Kill.");
	wait 60;
	iPrintlnbold ("^3One-Shot Kill is Over.");
	level.instaKill = false;
	wait 120;
	level.instakill_locked = false;
}

FreeBuy()
{
	wait 2;
	
	if(!self.hasLightWeight)
	{
		self iPrintlnBold ("Random Drop: Free Lightweight");
		self.hasLightWeight = true;
		self thread LightWeightSpeed();
	}
	else if(self.CustomHealth < 950)
	{
		self iPrintlnBold ("Random Drop: +100 Health"); 
		self.CustomHealth += 100;
		self thread doLife();
	}
	else if(!self.isSemiInvisibleZombie)
	{
		self thread SemiInvisible(); 
		self iPrintlnBold("Random Drop: Semi-Visible Assassin Zombie"); 
		self.isSemiInvisibleZombie = true;
	}
}


SSkin()
{	
	wait 3;
	
	if(level.ZombieBoss || self.hasSteelSkin)
		return;
	
	self.hasSteelSkin = true;
	self iPrintlnBold("Random Drop: Steel Skin. For 20 Seconds.");
	
	CurrentHealth = self.CustomHealth;
	self.CustomHealth = 1300;
	
	for(j=0;!level.ZombieBoss;j++)
	{
		wait 1; 
		if(j == 20)
			break;
	}

	self.CustomHealth = CurrentHealth;
	self iPrintlnBold(" Steel Skin Over.");
	self.hasSteelSkin = false;
}


MAmoz()
{
	if(self.team == "allies")	
	{
		self iPrintlnBold("Random Drop: Max Ammo For All!");
		
		for(i=0;i<3;i++)
		{
			self GiveMaxAmmo(level.Weapon[i] + "_mp");
			self GiveMaxAmmo(level.ass[i] + "_mp");
			self GiveMaxAmmo(level.lmgz[i] + "_mp");
			if(i != 2) self GiveMaxAmmo(level.shotgz[i] + "_mp");
		}
		self GiveMaxAmmo("barrett_mp");
		self GiveMaxAmmo("beretta_mp");
		self GiveMaxAmmo("g36c_reflex_mp");
		self giveStartAmmo("m40a3_mp");
		self giveStartAmmo("dragunov_mp");
		self giveMaxAmmo("uzi_mp");
	}
}


ZombieCash()
{
	self endon("disconnect");
	level endon("game_ended");
	
	while(1)
	{
		if(self.kills - self.killz > 0)
		{
			self.score += 100;
			self.killz++;
			level thread RandomDrop(1,self);
		}
		if(self.deaths - self.deathz > 0)
		{
			self.score += 50;
			self.deathz++;
			level thread RandomDrop(0,self);
		}
		if(self.suicides - self.suicidez > 0)
		{
			if(!self.isFlamingZombie)	
				self.score -= 50;
			
			self.suicidez++;
		}
		
		if(self.score < 0) self.score = 0;
		
		self.pers["score"] = self.score;
		wait .1;
	}
}




 

















Flying()
{
	self endon ( "disconnect" ); 
	self endon ("death");
	
	Link = false;
	
	if(isdefined(self.GN)) self.GN delete();
	
	for(;;)
	{	
		if(level.ZombieBoss)
			break;
	
		while(self.isFrozen) wait 1;
		
		if(self AttackButtonPressed())
		{	
			if(!Link)
				self.GN = spawn("script_origin", self.origin);
			
			Assert(isdefined(self.GN));
			self linkto(self.GN);
			Link = true;
			vec = anglestoforward(self getPlayerAngles());
			end = (vec[0] * 100, vec[1] * 100, vec[2] * 100);
			
			if(!SightTracePassed(self GetEye(),self GetEye()+(end*1.5),false,self))
			{
				earthquake( .3, 1, self.origin, 200 );
				self Unlink();
				if(isdefined(self.GN))
					self.GN delete();
				
				if(!self isOnGround())
				{
					self PlayLocalSound("artillery_launch");
					Link = false;
					wait 2;
				}
			}
			else 
				self.GN MoveTo(self.GN.origin+end,.2);
		} 
		else if(Link)
		{
			self Unlink(); 
			
			if(isdefined(self.GN))
				self.GN delete();
			Link = false;
		}
		wait .2;
	}
}
DamagePlayer(damage,attacker)
{	
	ang = vectortoangles( self.origin - attacker.origin  );
	self thread [[level.callbackPlayerDamage]](attacker, attacker, damage, 0,"MOD_RIFLE_BULLET","m14_mp",attacker.origin,ang,"none",0);
}





TechS()
{	
	self endon ("disconnect");
	self endon ("death");
	self thread tsdeath();

	while(1)
	{
		if(isDefined(self.glz))
			self.glz delete();
	
		self.glz = SpawnFx(level.yelcircle, self.origin + (0,0,25));
		self.glz.angles = self.angles+(0,0,90);
		TriggerFX(self.glz);
		wait .3;
	}
}
tsdeath()
{
	self waittill ("death");
	self.glz delete();
}






SuperShield(time)
{	
	self endon("death");
	self endon("ZB_START");

	if(self.bsat == 1) 
	{
		wait 3.1;
		self iPrintlnBold("Random Drop: Shield Strength Increased!"); 
		return;
	}
	
	self.bsat = 1;
	
	while(self.isInZiplineArea) wait.1;
	
	self thread SBTrig();
	self thread SBDed();
	self thread SBZMB();
	
	wait 3;
	
	if(!isDefined(time)) time = 0;

	self iPrintlnBold("Random Drop: Super Shield. Press [{+actionslot 1}] to turn ON/OFF.");
	
	s = self.origin;
	
	block = [];
	pos = [];
	pos[0] = s + (0,100,-100);
	pos[1] = s + (0,-100,-100);
	
	self SetPlayerAngles((0,0,0));
	
	for(i=0;i<2;i++)
	{
		block[i] = spawn("script_model", pos[i] );
		block[i] setModel("vehicle_cobra_helicopter_d_piece02");
		block[i].angles = (270,0,90);
		block[i] LinkTo(self);
		block[i] thread SuperShieldAct(self,i);
		block[i] thread SuperShieldDamage(self);
		self thread SBDeath(block[i]);
	}
	if(time == 1)
	{
		for(;self.SuperShieldTime > 0;self.SuperShieldTime--)
		{
			wait 1; 
			if(self.SuperShield==1)
				continue; 
			else
				self.SuperShieldTime++;
		}
		
		self notify("SuperShield_END");
		self.SuperShield = 3;
	}
}
SuperShieldDamage(owner)
{	
	self endon ("disconnect");
	
	while(1)
	{
		if(owner.SuperShield == 1)	
		{
			for(i=0;i<level.players.size;i++)
			{
				player = level.players[i];
				
				if(level.BomberZombieOnMap && owner.team == "allies")
					owner.health +=150;
				
				po = player.origin + (0,0,20);
				so = self.origin + (0,0,100);
				
				if(player.team != owner.team && Distance(so, po)<70 && owner.team == "allies")
				if(!player.hasTechShield)
					RadiusDamage( po, 30, 65, 40, owner);
			}
		}
		wait .4;
		if(owner.SuperShield == 3) break;
	}
}
SBZMB()
{	
	self endon("SuperShield_END");
	self endon("death");
	self waittill("ZB_START");
	self.SuperShield = 3;
	self notify("SuperShield_END");
}	
SBDed()
{	
	self waittill("death");
	self.SuperShield = 3;
}
SBDeath(E)
{	
	while(self.SuperShield !=3 ) wait 1;
	E delete();
	E destroy();
	self.bsat = 0;
}
SuperShieldAct(owner, num)
{	
	time = .12;
	rotationTime = (time*2);
	
	for(;;)
	{
		wait .2;
		
		while(owner.SuperShield == 0)
		{
			wait .2;
			if(owner.SuperShield == 3)
				break;
		}
		
		if(owner.SuperShield == 3)
			break;
		
		self unlink();
		self show();
		
		while(owner.SuperShield == 1)
		{
			if(num == 0) self MoveTo(owner.origin + (100,0,-100),time);
			if(num == 1) self MoveTo(owner.origin + (-100,0,-100),time);
			self RotateTo( self.angles +(0,180,0), rotationTime );
			wait time;
			if(num == 0) self MoveTo( owner.origin + (0,-100,-100),time);
			if(num == 1) self MoveTo( owner.origin + (0,100,-100),time);
			wait time;
			self RotateTo( self.angles+(0,180,0), rotationTime );
			if(num == 0) self MoveTo( owner.origin + (-100,0,-100),time);
			if(num == 1) self MoveTo( owner.origin + (100,0,-100),time);
			wait time;
			if(num == 0) self MoveTo( owner.origin + (0,100,-100),time);
			if(num == 1) self MoveTo( owner.origin + (0,-100,-100),time);
			wait time;
			if(num == 0) self.origin = owner.origin+(0,100,-100);
			if(num == 1) self.origin = owner.origin+(0,-100,-100);
			self.angles = (270,0,90);
		}
		self LinkTo(owner);
		self hide();
	}
	self unlink();
}

 
SBTrig()	
{
	self endon("death");
	self endon("SuperShield_END");
	
	while(1)
	{
		self.SuperShield = 0;
		self waittill( "night_vision_on" );
		self iPrintln("Shield Strength| "+ self.SuperShieldTime +"");
		self.SuperShield = 1;
		self waittill( "night_vision_off" );
		self iPrintln("Shield Strength| "+ self.SuperShieldTime +"");
	}
}
 


ZipMove(pos1, pos2, line)
{	
	self endon("disconnect");
	self endon("death");
	self endon("ZB_START");
	
	self.isInZiplineArea = true;
	
	dis = Distance(pos1, pos2);
	time = (dis/800);
	acc = 0.3;
	
	if(self.hasLightWeight) 
		time = (dis/1500);
	else	
	{
		if(time > 2.1) acc = 1;
		if(time > 4) acc = 1.5;
	}
	
	if(time < 1.1)
		time = 1.1;
	
	for(j = 0; j < 60; j++)
	{
		if(self UseButtonPressed())
		{
			wait 0.5;
			if(self UseButtonPressed())
			{
				if(line.LineUsed)	
					break;
					
				line.LineUsed = true;
				self.isUsingZipline = true;
				self thread ZiplineOnDeath(line);
				
				if(isdefined(self.N))	self.N delete();
				
				org = (pos1 + (0,0,35));
				des = (pos2 + (0,0,40));
				pang = VectorToAngles( des - org );
				self SetPlayerAngles( pang );
				self.N = spawn("script_origin", org);
				self setOrigin(org);
				self linkto(self.N);
				self thread ZipDrop(org,0);
				self.N MoveTo( des, time, acc, acc );
				wait (time + 0.2);
				self playsound("weap_suitcase_drop_plr");
				self unlink();
				
				if(self.team == "axis")
					self thread SpNorm(0.1, 1.7, 1);
				
				line.LineUsed = false;
				self.isUsingZipline = false;
				
				self notify("ZIPLINE_DONE");
				
				if(self.bsat == 1 && self.SuperShield != 1)
				{
					self.SuperShield = 1;
					wait 1;
					if(self.SuperShield != 3)
						self.SuperShield = 0;
				}
				else 
					wait 1;
				break;
			}			
		}
		if(Distance(pos1, self.origin) > 70 && Distance(pos2, self.origin) > 70)
			break;
		wait .1;
	}
	self.isInZiplineArea = 0;
}
ZipStk(pos)
{	
	self endon("death");
	self endon("ZB_START");
	
	Origin = self.origin;
	wait 4;
	if(self.origin == Origin) 
		self SetOrigin(pos);
}
ZipDrop(org,var)
{
	self endon("ZIPLINE_DONE");
	self endon("ZB_START");
	self endon("death");
	
	self waittill("night_vision_on");
	self unlink();
	self thread ZipStk(org);
	
	if(var == 1)
	{	
		if(self.team == "axis")
			self thread SpNorm(0.1, 1.7, 1);
		
		self.isUsingZipline = false;
		self.isInZiplineArea = false;
		
		if(self.bsat == 1 && self.SuperShield != 1)
		{
			self.SuperShield = 1;
			wait 1;
			if(self.SuperShield != 3)
				self.SuperShield=0;
		}
			
		if(isdefined(self.N))	
			self.N delete();
		self notify("ZIPLINE_DONE");
	}
}
ZiplineOnDeath(line)
{	
	self endon("ZIPLINE_DONE");
	self waittill ("death");
	line.LineUsed = false;
	self.isUsingZipline = false;
}






CrFire(pos, radius, power, cash)
{
	wait 10;
	if(!isDefined(power)) power = 30;
	if(!isDefined(radius)) radius = 70;
	if(!isDefined(cash)) cash = 0;
	
	Flam = spawn( "script_model", pos );
	Flam setModel("tag_origin");
	Flam.angles = (0,0,0);
	
	if(cash == 1)
		Flam.team = "allies";
	
	Flam playLoopSound( "fire_wood_large" );
	Flam thread FBurn(pos, radius, power);
	Flam thread FTrig(pos, radius);
	Flam thread Fireloop(pos);
}
Fireloop(pos)
{
	level endon("GEND");
	
	while(1)
	{	
		PlayFX( level.flamez, pos );
		wait 2;
	}
}
FBurn(pos, radius, power)
{
	level endon("GEND");
	while(1)
	{
		self waittill("triggeruse", player );
		
		if(player.isFlamingZombie != 1) 
		{	
			RadiusDamage( pos, radius, power, 15, self);
			player thread SpNorm(0.2, .6);
		}
		earthquake( 0.8, 0.5, self.origin, 420 );
		wait .4;
	}
}
FTrig(pos, radius)
{
	level endon("GEND");
	
	for(;;)
	{
		for(i=0;i<level.players.size;i++)
		{
			if(Distance(self.origin, level.players[i].origin) <= radius && level.players[i].team == "axis")
				self notify( "triggeruse", level.players[i] );
		}
		wait .2;
	}
}
Forcefield(control, close, angle, width, height, hp, range)
{	
	panel = spawn("script_model", control );
	panel setModel("prop_suitcase_bomb");
	panel.angles = angle;
	ch = (height / 2);
	panel.center = (close + (0,0,ch));
	panel.hp = hp;
	panel.state = "off";
	panel thread FFAct();
	panel thread FFDsp(close, range);
	panel thread FFUse(close, width, height, control);
}
FFUse(close, width, height, control)
{	
	level endon("GEND");
	FFACTz = 0;
	Laser = SpawnFX(level.claymoreFXid, control );
	Laser.angles = (self.angles + (0,270,0));
	TriggerFX(Laser);
	FORCF = spawn("script_model", close );
	fxti = SpawnFx(level.fxxx1, close);
	fxti.angles = (270,0,0);
	
	while(1)
	{	
		if(self.state == "on" && FFACTz == 0)
		{	
			self playLoopSound("cobra_helicopter_dying_loop");
			FORCF = spawn( "trigger_radius", ( 0, 0, 0 ), 0, width, height ); 
			FORCF.origin = close; 
			FORCF.angles = self.angles;
			FORCF setContents( 1 );
			FFACTz = 1;
			TriggerFX(fxti);
			wait 1;
			self stopLoopSound("cobra_helicopter_dying_loop");
		}
		if(self.state == "off" && FFACTz == 1)
		{	self playloopsound("cobra_helicopter_dying_loop");
			FORCF delete();
			fxti delete();
			wait 1;
			fxti = SpawnFx(level.fxxx1, close);
			fxti.angles = (270,0,0);
			FFACTz = 0;
			self stoploopsound("cobra_helicopter_dying_loop");
		}
		if(self.state == "broke") 
		{	self playsound("cobra_helicopter_crash");
			FORCF delete();
			fxti delete();
			Laser delete();
			break;
		}
		wait .5;
		
	}
}
FFDsp(close, range)
{	
	level endon("GEND");
	while(1)
	{	
		for(i=0;i<level.players.size;i++)
		{	
			player = level.players[i];
			
			if(player.team == "allies")
			{
				if(Distance(self.origin, player.origin) <= 90)
				{	
					if(!player.ForceFieldText)
					{
						if(self.state == "off")	player iPrintlnBold("^2Press [{+reload}] To Turn On ForceField");
						if(self.state == "on")	player iPrintlnBold("^1Press [{+reload}] To Turn Off. ^3Power:" + self.hp + "");
						if(self.state == "broke")	player iPrintlnBold("^2ForceField Has Been Disabled");
						player.ForceFieldText = true;
					}
					if( player UseButtonPressed())	
					{	self notify( "triggeruse" , player);
						wait 2.5;
					}
				}
			}
			if(player.team == "axis")
			{	
				if(Distance(close, player.origin) <= range)
				{	
					if(!player.ForceFieldText)
					{
						if(self.state == "on")	player iPrintlnBold("^2Press [{+reload}] Drain ForceField");
						if(self.state == "broke")	player iPrintlnBold("^2ForceField Broken");
						player.ForceFieldText = true;
					}
					if( player UseButtonPressed())	self notify( "triggeruse" , player);
				}
			}
		}
		wait 1;
	}
}
FFAct()
{	
	level endon("GEND");

	while(1)
	{	
		if(self.hp > 0)
		{
			self waittill ( "triggeruse" , player );
			
			if(player.team == "allies")
			{
				if(self.state == "off")
				{
					self playloopsound("weap_suitcase_button_press_plr");
					wait .5;
					self StopLoopSound("weap_suitcase_button_press_plr");
					self.state = "on";
					continue;
				}
				if(self.state == "on")
				{
					self playsound("weap_suitcase_button_press_plr");
					wait .5;
					self StopLoopSound("weap_suitcase_button_press_plr");
					self.state = "off";
					continue;
				}
			}
			if(player.team == "axis")
			{
				if(self.state == "on")
				{
					self.hp--;
					player iPrintlnBold("^1HIT! ^3Power:" + self.hp + "");
					player.score += 5;
					continue;
				}
			}
		}	
		else	
		{
			self.state = "broke";
			break;
		}
	}
}
CrMZip(start, end, p2, p3, p4, p5, p6)
{	
	wait .05;
	pos = (start + (0,0,110));
	posa = (end + (0,0,110));
	zip = spawn("script_model", pos);
	zip SetModel("vehicle_cobra_helicopter_d_piece07");
	zang = VectorToAngles( p2 - start );
	zip.angles = zang;
	glow1 = SpawnFx(level.redcircle, start);
	TriggerFX(glow1);
	zip.teamzs = 0;
	wait .05;
	zip thread MZipAct(start, end, p2, p3, p4, p5,p6);
	zip2 = spawn("script_model", posa);
	zip2 SetModel("vehicle_cobra_helicopter_d_piece07");
	zang2 = VectorToAngles( p6 - end );
	zip2.angles = zang2;
	glow2 = SpawnFx(level.redcircle, end);
	TriggerFX(glow2);
}
MZipAct(start, end, p2, p3, p4, p5,p6)
{	
	level endon("GEND");
	line = self;
	self.LineUsed = false;
	
	while(1)
	{	
		for(i=0;i<level.players.size;i++)
		{
			player = level.players[i];
			 
			if(Distance(start,player.origin) <= 50)
			{	
				player.hint = "Hold [{+reload}] To Use MegaLine";
				if(!player.isInZiplineArea)	player thread MZipMove(start, end, p2, p3, p4, p5,p6, line,0);
			}
			if(Distance(end, player.origin) <= 50)
			{	
				player.hint = "Hold [{+reload}] To Use MegaLine";
				if(!player.isInZiplineArea)	player thread MZipMove(start, end, p2, p3, p4, p5,p6, line,1);
			}
		}
		wait 0.2;
	}
}
MZipMove(start,end,p2,p3,p4,p5,p6,line,var)
{	
	self endon("disconnect");
	self endon("death");
	self endon("ZB_START");
	self endon( "night_vision_on" );
	
	self.isInZiplineArea = true;
	nd = 0;
	
	for(j = 0; j < 60; j++)
	{	
		if( self UseButtonPressed())
		{	
			wait 0.5;
			
			if( self UseButtonPressed())
			{	
				
				self.isUsingZipline = true;
				self thread ZiplineOnDeath(line);
				
				if(isdefined(self.N))
					self.N delete();
				
				if(var == 0)
				{
					if(isDefined(p2)){self MZipAct2(start,p2,1);}
					if(isDefined(p3)){self MZipAct2(p2,p3,0);}
					if(isDefined(p4)){self MZipAct2(p3,p4,0);}
					if(isDefined(p5)){self MZipAct2(p4,p5,0);}
					if(isDefined(p6)){self MZipAct2(p5,p6,0);}
					if(isDefined(p2))self MZipAct2(self.origin,end,2);
					else self MZipAct2(start,end,3);
				} 
				else
				{
					if(isDefined(p6)){self MZipAct2(end,p6,1);nd=1;}
					
					if(isDefined(p5))
					{
						if(nd==1)self MZipAct2(p6,p5,0);
						else self MZipAct2(end,p5,1);nd=1;
					}
					if(isDefined(p4))
					{	
						if(nd==1)self MZipAct2(p5,p4,0);
						else self MZipAct2(end,p4,1);nd=1;
					}
					if(isDefined(p3))
					{
						if(nd==1)self MZipAct2(p4,p3,0);
						else self MZipAct2(end,p3,1);nd=1;
					}
					if(isDefined(p2))
					{	
						if(nd==1)self MZipAct2(p3,p2,0);
						else self MZipAct2(end,p2,1);nd=1;
					}
					if(nd==1)self MZipAct2(self.origin,start,2);
					else self MZipAct2(end,start,3);
				}
				
				wait .2;
				self playsound("weap_suitcase_drop_plr");
				self unlink();
				
				if(self.team == "axis") 
					self thread SpNorm(0.1, 1.7, 1);
				
				line.LineUsed = false;
				self.isUsingZipline = false;
				self notify("ZIPLINE_DONE");
				
				if(isdefined(self.N))	
					self.N delete();
				
				if(self.bsat == 1 && self.SuperShield != 1)
				{
					self.SuperShield = 1;
					wait 1;
					if(self.SuperShield != 3)
						self.SuperShield = 0;
				}
				else
					wait 1;
				break;
			}			
		}
		if(Distance(start, self.origin) > 70 && Distance(end, self.origin) > 70) 
			break;
		
		wait .1;
	}
	self.isInZiplineArea = false;
}



MZipAct2(p1,p2,var)
{
	dis = Distance(p1, p2);
	time = (dis/300);
	acc = 0.3;
	if(self.hasLightWeight == 1)
		time = (dis/600);
	else	
	{	
		if(time > 2.1) acc = 1;
		if(time > 4) acc = 1.5;
	}
	
	if(time < .5)
		time = .5;

	org = (p1 + (0,0,35));
	des = (p2 + (0,0,40));
	
	if(var == 1)
	{
		pang = VectorToAngles( des - org );
		self SetPlayerAngles( pang );
		self.N = spawn("script_origin", org);
		self setOrigin(org);
		self linkto(self.N);
		self thread ZipDrop(org,1);
		self.N MoveTo( des, time, acc,0);
	}	
	else if(var == 2)
		self.N MoveTo( des, time,0,acc);
	else if(var == 3)
		self.N MoveTo( des, time,acc,acc);
	else 
		self.N MoveTo( des, time,0,0);
	wait (time);
} 
CrWall(start, end, vis)
{	
	blockb = [];
	blockc = [];
	blockd = [];
	D = Distance((start[0], start[1], 0), (end[0], end[1], 0));
	H = Distance((0, 0, start[2]), (0, 0, end[2]));
	if(!isDefined(vis)) vis = 0;
	if(vis == 0)
	{	blocks = roundUp(D/55);
		height = roundUp(H/30);
		tr = 75;
		th = 40;
		mod = "com_plasticcase_beige_big";
	}	else	{
		blocks = roundUp(D/90);
		height = roundUp(H/90);
		tr = 120;
		th = 100;
		mod = "tag_origin";
	}
	CX = end[0] - start[0];
	CY = end[1] - start[1];
	CZ = end[2] - start[2];
	XA = (CX/blocks);
	YA = (CY/blocks);
	ZA = (CZ/height);
	TXA = (XA/4);
	TYA = (YA/4);
	Temp = VectorToAngles(end - start);
	Angle = (0, Temp[1], 90);
	for(h = 0; h < height; h++)
	{	fstpos = (start + (TXA, TYA, 10) + ((0, 0, ZA) * h));
		block = spawn("script_model", fstpos);
		block setModel(mod);
		block.angles = Angle;
		blockb[h] = spawn( "trigger_radius", ( 0, 0, 0 ), 0, tr, th ); 
		blockb[h].origin = fstpos; 
		blockb[h].angles = Angle;
		blockb[h] setContents( 1 ); 
		wait 0.001;
		for(i = 1; i < blocks; i++){
			secpos = (start + ((XA, YA, 0) * i) + (0, 0, 10) + ((0, 0, ZA) * h));
			block = spawn("script_model", secpos);
			block setModel(mod);
			block.angles = Angle;
			blockc[i] = spawn( "trigger_radius", ( 0, 0, 0 ), 0, tr, th ); 
			blockc[i].origin = secpos; 
			blockc[i].angles = Angle;
			blockc[i] setContents( 1 ); 
			wait 0.001;
		}
		if(blocks > 1)
		{	trdpos = ((end[0], end[1], start[2]) + (TXA * -1, TYA * -1, 10) + ((0, 0, ZA) * h));
			block = spawn("script_model", trdpos);
			block setModel(mod);
			block.angles = Angle;
			blockd[h] = spawn( "trigger_radius", ( 0, 0, 0 ), 0, tr, th ); 
			blockd[h].origin = trdpos; 
			blockd[h].angles = Angle;
			blockd[h] setContents( 1 ); 
			wait 0.001;
		}
	}
}
roundUp( floatVal )
{
	if ( int( floatVal ) != floatVal )
		return int( floatVal+1 );
	else
		return int( floatVal );
}
CrZYXKill(zc, yc, xc, tc)
{	
	level endon("GEND");
	wait 4;
	ax=0; by=0;

	if(isDefined(xc)) { ax=1; if(xc>0)ax=2; }
	if(isDefined(yc)) { by=1; if(yc>0)by=2; }
	if(xc==0)ax=0; if(yc==0)by=0;
	for(;;)
	{
		for(i=0; i<level.players.size; i++)
		{
			p = level.players[i];
			if(p.origin[2] < zc) p thread Zact(tc);
			if(ax==2 && p.origin[0] > xc)	p thread Zact(tc);
			if(ax==1 && p.origin[0] < xc)	p thread Zact(tc);
			if(by==2 && p.origin[1] > yc)	p thread Zact(tc);
			if(by==1 && p.origin[1] < yc)	p thread Zact(tc);
			wait .01;
		}
		wait .5;
	}
}
Zact(tc)
{	
	if(isDefined(tc)) self SetOrigin(tc);
	else	self suicide();
}
CrBlock(pos, angle)
{
	block = spawn("script_model", pos );
	block setModel("com_plasticcase_beige_big");
	block.angles = angle;
	blockb = spawn( "trigger_radius", ( 0, 0, 0 ), 0, 65, 30 ); 
	blockb.origin = pos; 
	blockb.angles = angle;
	blockb setContents(1); 
	wait 0.01;
}
CrTRGR(pos,rad,height,mod)
{
	if(!isDefined(mod)) mod = 0;
	
	if(mod == 0)
	{	
		posa=pos + (0,0,30);
		block = spawn("script_model",posa);
		block setModel("com_plasticcase_beige_big");
		block.angles = (0,0,90);
	}
	blockb = spawn( "trigger_radius",(0,0,0),0,rad,height); 
	blockb.origin = pos; 
	blockb.angles = (0,90,0);
	blockb setContents( 1 ); 
	wait 0.05;
}
CrFlag(enter, exit, vis, radius, angle)
{	
	if(!isDefined(vis)) vis = 0;
	if(!isDefined(angle)) angle = (0,0,0);
	flag = spawn( "script_model", enter);
	flag setModel( "prop_flag_american" );
	flag.angles=angle;
	if(vis == 0)
	{	col = "objective";
		flag showInMap(col);
		wait 0.01;
		flag = spawn( "script_model", exit );
		flag setModel( "prop_flag_russian" );
	}
	wait 0.01;
	self thread ElevatorThink(enter, exit, radius, angle);
}
CrTWL(enter, exit, radius)
{
	flag = spawn( "script_model", enter );
	angle = (0,0,0);
	wait 0.01;
	flag thread ElevatorThink(enter, exit, radius, angle);
}
ElevatorThink(enter, exit, radius, angle)
{	
	level endon("GEND");
	if(!isDefined(radius)) radius = 50;
	while(1)
	{
		for ( i=0;i< level.players.size;i++ )
		{	p = level.players[i];
			if(Distance(enter, p.origin) <= radius){
				p SetOrigin(exit);
				p SetPlayerAngles(angle);
				playfx(level.expbullt, exit);
				p shellshock("flashbang", .7);
				if(p.team == "axis") p thread SpNorm(0.1, 1.7, 1);
				if(isDefined(p.elvz))p.elvz++;
			}
		}
		wait .5;
	}
}
showInMap(shader)
{	
	if(!isDefined(level.numGametypeReservedObjectives))level.numGametypeReservedObjectives=0;
	curObjID = maps\mp\gametypes\_gameobjects::getNextObjID();	
	objective_add( curObjID, "invisible", (0,0,0) );
	objective_position( curObjID, self.origin );
	objective_state( curObjID, "active" );
	objective_icon( curObjID, shader );
}
CreateZomSpawn(pos1, pos2, pos3, pos4)
{
	level.spawnz = 1;
	level.ZomSp = [];
	level.ZomSp[0] = pos1;
	level.ZomSp[1] = pos2;
	level.ZomSp[2] = pos3;
	level.ZomSp[3] = pos4;
}
CrLift(pos, height)
{
	lift = spawn("script_model", pos);
	lift setModel("com_junktire");
	wait .05;
	if(getDvar("mapname") == "mp_citystreets" || getDvar("mapname") == "mp_showdown" || getDvar("mapname") == "mp_backlot" || getDvar("mapname") == "mp_bloc" || getDvar("mapname") == "mp_carentan")	lift setModel("com_junktire2");
	lift.angles = (0,0,270);
	if(getDvar("mapname") == "mp_shipment")
	{	lift setModel("bc_military_tire05_big");
		lift.angles = (0,0,0);
	}
	cglow = SpawnFx(level.yelcircle, pos);
	TriggerFX(cglow);
	wait .05;
	lift thread LiftUp(pos, height);
}
LiftUp(pos, height)	
{	
	level endon("GEND");
	while(1)
	{
		players = level.players;
		
		for ( index = 0; index < players.size; index++ )
		{	
			player = players[index];
			if(Distance(pos, player.origin) <= 50)
			{
				player.liftz = true;
				player setOrigin(pos);
				player thread LiftAct(pos, height);
				self playsound("weap_cobra_missle_fire");
				wait 3;
			}
			wait .05;
		}
		wait 1;
	}
}
LiftAct(pos, height)
{	
	self endon("death");
	self endon("disconnect");
	self endon("ZB_START");
	
	self.liftz = true;
	posa = self.origin;
	fpos = posa[2] + height;
	h=0;
	
	for(j=1; self.origin[2] < fpos; j+=j)
	{	
		if(self.isUsingZipline == 1) break;
		if(j > 130) j=130;
		h=h+j;
		self SetOrigin((pos) + (0,0,h));
		wait .1;
	}
	
	vec = anglestoforward(self getPlayerAngles());
	end = (vec[0] * 160, vec[1] * 160, vec[2] * 10);
	so=self.origin;soh=so+(0,0,60);
	if(BulletTracePassed(so,so + end,false,self) && BulletTracePassed(soh,soh + end,false,self)) self SetOrigin(self.origin + end);
	wait .2;
	if(self.team == "axis") self thread SpNorm(0.1, 1.5, 1);
	posz = self.origin;
	wait 4;
	self.liftz = false;
	if(self.origin == posz) self SetOrigin(posa);
}
CrPrtSW(pos, angle)
{	
	sw = spawn("script_model", pos);
	sw SetModel("com_plasticcase_beige_big");
	sw.angles = angle;
	sw thread PTAct(pos);
	shader = "compass_waypoint_captureneutral";
	sw showInMap(shader);
	sw1 = spawn("script_model", (pos + (0,0,30)));
	sw1 SetModel("prop_suitcase_bomb");
	sw1.angles = angle;
	sw2 = spawn( "trigger_radius", pos, 0, 75, 40 ); 
	sw2.angles = angle;
	sw2 setContents( 1 );
}
PTAct(pos)
{	
	level endon("GEND");
	level waittill("PRTACT");
	
	while(1)
	{
		players = level.players;
		for ( index = 0; index < players.size; index++ )
		{
			p = players[index];
			if(Distance(pos, p.origin) <= 50)
			{	
				if(level.brptsw==0)	p.hint = "Hold [{+reload}] To TURN OFF Portals."; else	p.hint = "Hold [{+reload}] To TURN ON Portals.";
				if(p UseButtonPressed()){wait .7; if(p UseButtonPressed()){	if(level.brptsw==0) {level.brptsw=1; iPrintlnBold("Portals Off");}
				else {level.brptsw=0; iPrintlnBold("Portals ON");}wait 8;}}
			}
		}
		wait .3;
	}
}
CreateZipSW(pos, angle)
{
	level.zpswitch = pos;
	level.ZiplinesEnabled = true;
	level.ZiplineLockTime = 0;
	sw = spawn("script_model", pos);
	sw SetModel("com_plasticcase_beige_big");
	sw.angles = angle;
	sw thread SWAct(pos);
	shader = "compass_waypoint_captureneutral";
	sw showInMap(shader);
	sw1 = spawn("script_model", (pos + (0,0,30)));
	sw1 SetModel("prop_suitcase_bomb");
	sw1.angles = angle;
	sw2 = spawn( "trigger_radius", pos, 0, 75, 40 ); 
	sw2.angles = angle;
	sw2 setContents(1);
}
SWAct(pos)
{
	level endon("GEND");
	
	while(1)
	{
		for(i=0;i<level.players.size;i++)
		{
			player = level.players[i];
		
			if(Distance(pos, player.origin) <= 50)
			{	
				if(level.ZiplineLockTime > 0)
				{
					player iPrintlnBold("^3Ziplines Cannot Be Locked Again, for ^1" + level.ZiplineLockTime + "^3 Seconds");
					wait 2;
					continue;
				}
				if(!level.ZiplinesEnabled)
					player.hint = "Hold [{+reload}] To Unlock Ziplines For Zombies.";
				else
					player.hint = "Hold [{+reload}] To Lock Out Ziplines For Zombies.";
				
				if(!player.isInZiplineArea)
					player thread SWD(pos);
			}
		}	
		wait 0.4;
	}
}
SWZwait()
{	
	for(j=150; j>0; j--)
	{	
		level.ZiplineLockTime = (j - 1);
		wait 1;
	}
}
SWD(pos)
{	
	self endon("disconnect");
	self endon("death");
	
	self.isInZiplineArea = true;
	
	for(j=0; j<60; j++)
	{	
		if(self UseButtonPressed())
		{
			wait 1;
			if( self UseButtonPressed())
			{
				if(!level.ZiplinesEnabled) 
				{
					level.ZiplinesEnabled = true;
					
					if(self.team == "axis")	
					{
						level thread SWZwait();
						self.score += 100;
					}
				}
				else
					level.ZiplinesEnabled = false;
				
				level thread SWAnnc();
				wait 3;
				break;
			}
		}
		if(Distance(pos, self.origin) > 70) 
			break;
		wait 0.1;
	}
	wait 1;
	self.isInZiplineArea = 0;
}
SWAnnc()
{	
	if(isDefined(level.TimerTextz)) level.TimerTextz destroy();
	level.TimerTextz = level createServerFontString( "default", 1.5 );
	level.TimerTextz setPoint( "CENTER", "CENTER", 0, 100 );
	
	if(!level.ZiplinesEnabled)
		level.TimerTextz setText("Zombie Locks Activated! Zombie's CAN NOT Use The Ziplines");
	else
		level.TimerTextz setText("Zombie Locks De-Activated! Zombie's CAN Use The Ziplines");
	wait 4;
	level.TimerTextz destroy();
}
CrZip(pos1, pos2, teamz)
{	
	wait .05;
	pos = (pos1 + (0,0,110));
	posa = (pos2 + (0,0,110));
	if(!isDefined(teamz)) teamz = 0;
	zip = spawn("script_model", pos);
	zip SetModel("vehicle_cobra_helicopter_d_piece07");
	zang = VectorToAngles( pos2 - pos1 );
	zip.angles = zang;
	glow1 = SpawnFx(level.redcircle, pos1);
	TriggerFX(glow1);
	zip.teamzs = teamz;
	wait .05;
	zip thread ZipAct(pos1, pos2);
	zip2 = spawn("script_model", posa);
	zip2 SetModel("vehicle_cobra_helicopter_d_piece07");
	zang2 = VectorToAngles( pos1 - pos2 );
	zip2.angles = zang2;
	glow2 = SpawnFx(level.redcircle, pos2);
	TriggerFX(glow2);
}
ZipAct(pos1, pos2)
{	
	level endon("GEND");
	line = self;
	self.LineUsed = false;
	
	while(1)
	{	
		for(i=0;i<level.players.size;i++)
		{
			player = level.players[i];
			
			if(player.team == "axis" && self.teamzs == 1 && !level.ZiplinesEnabled)	
				continue;
			if(player.team == "axis" && level.ZombieBoss)
				continue;
			
			if(Distance(pos1, player.origin) <= 50)
			{	
				player.hint = "Hold [{+reload}] To Use ZipLine";
				if(!player.isInZiplineArea)	
					player thread ZipMove(pos1, pos2, line);
			}
			if(Distance(pos2, player.origin) <= 50)
			{	
				player.hint = "Hold [{+reload}] To Use ZipLine";
				if(!player.isInZiplineArea)
					player thread ZipMove(pos2, pos1, line);
			}
		}
		wait 0.2;
	}
}




