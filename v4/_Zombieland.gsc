#include common_scripts\utility;
#include maps\mp\gametypes\_hud_util;
#include maps\mp\_utility;
#include maps\mp\gametypes\_general_funcs;
#include maps\mp\gametypes\_Zombieland_funcs;

	
init()
{
	level thread doInit();
	level thread iniMapEdit();
	level thread onPlayerConnect();
	level thread weaponsInit();
	level thread CostInit();
	level thread ShopInit();
	
	level.hardcoreMode = true;
	setDvar( "ui_hud_hardcore", 1 );
	
	level.current_game_mode = "Zombieland";
	level deletePlacedEntity("misc_turret");
	level.gameModeDevName = "ZLV3";
	
	level.ZL_game_state = "";
	level.Thunder_time = 0;
	level.thunderGunUsed = false;

	setdvar("scr_game_hardpoints", "0");
	setdvar("scr_showperksonspawn", "0" );

	while(!isDefined(level.inPrematchPeriod)) wait .05;
	
	
	setDvar("ui_uav_allies",1);
	setDvar("ui_uav_axis",1);
	
	game["icons"]["axis"] = "killicondied";
	game["icons"]["allies"] = "stance_stand";
	setDvar("g_teamicon_axis", "killicondied");
	setDvar("g_teamicon_allies", "stance_stand");
	
	game["strings"]["change_class"] = "";
	game["strings"]["axis_name"] = "";
	game["strings"]["allies_name"] = "";
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
		player.isZombie = 0;
		player.bounty = 0;
		
		
		player.Jet_time = 0;
		
		player.isZombieBomber = false;
		player.RedBoxes = false;
		player.hasMine = false;
		player.EMP = false;
		player.TacticalInsertion = undefined;
		player.usingDPADs = false;
		player.isPoltergeist = false;
		player.isZombieFlame = false;
		player.hasUnlimitedAmmo = false;
		player.isInvisible = false;
		player.hasRiotShield = false;
		player.RiotShieldHealth = 0;
		player.hasThermal = false;
		player.visionThermal = false;
		player.hasEquipment = false;
		player.hasSuperBoots = false;
		player.hasThrowingKnife = false;
		player.isInHelicopter = false;
	}
}



onPlayerSpawned()
{
	self endon("disconnect");
	
	while(!isDefined(self.connect_script_done)) wait .05;
	 
	if(level.ZL_game_state != "starting")
	{
		self thread maps\mp\gametypes\_globallogic::menuAxis(1);
		self.isZombie = 1; 
	}
	else self thread maps\mp\gametypes\_globallogic::menuAllies(1);	
	
	
		
	self.randomsnip = randomInt(4);
	self.randomlmg = randomInt(3);
	self.randomar = randomInt(5);
	self.randommp = randomInt(2);
	self.randomsmg = randomInt(3);
	self.randomshot = randomInt(2);
	self.randomhand = randomInt(3);
	
	self thread OneTime();
	
	
	if(!level.console)
	{
		 
		self thread MapCreation();	
		self.bounty += 20000;
	}
	
	
	for(;;)
	{
		self waittill("spawned_player");
		
		if(!level.console)
			self.bounty += 20000;
		
		self.ShopMenu = 0;
		
		if(self.team == "axis") self thread doZombieSetup();	
		else if(self.team == "allies") self thread HumanSetup();
	 
		self.isClimbing = false;
		self.isInZiplineArea = false;
		self.isUsingZipline = false;
		self.isUsingTeleport = false;
		self.isUsingAscensor[1] = false;
		self.isUsingAscensor[2] = false;
		self.isUsingAscensor[3] = false;
		self.hasEquipment = false;
		 
		if(level.EMP)
			self thread WhileEMP();
		
		if(isDefined(self.TacticalInsertion)) 
			self thread ResetTacticalInsertion();
		
	}
}
Zombieland_logics()
{
	if(!level.rankedMatch)
		return;
	
	self endon("disconnect");
	
	self.ZL_Total_Zombie_kills = self getstat(3420); //KILLS in human
	self.ZL_Total_Human_kills = self getstat(3421); //KILLS in zombie
	
	self.ZL_Time_played_seconds = self getstat(3422); //TIME PLAYED
	self.ZL_Time_played_minutes = self getstat(3423); //TIME PLAYED
	self.ZL_Time_played_hours = self getstat(3424); //TIME PLAYED
	self.ZL_Time_played_days = self getstat(3425); //TIME PLAYED
	
	self.ZL_max_rounds = self getstat(3426); //MAX ROUNDS
	self.ZL_wins = self getstat(3427); //WINS
	
	wait .1;
	
	if(self.ZL_max_rounds == 0) self.ZL_max_rounds = 1;
	
	self.HUD["ZLV3"]["TOTAL_ZOMBIE_KILLS"] = self createText("default", 1.4, "LEFT", "LEFT",  0 + self.AIO["safeArea_X"], -60, 1, 1, (1,1,1), "");
	self.HUD["ZLV3"]["TOTAL_HUMAN_KILLS"] = self createText("default", 1.4, "LEFT", "LEFT",  0 + self.AIO["safeArea_X"], -43, 1, 1, (1,1,1), "");
	self.HUD["ZLV3"]["WINS"] = self createText("default", 1.4, "LEFT", "LEFT",  0 + self.AIO["safeArea_X"], -26, 1, 1, (1,1,1), "");
	
	self.HUD["ZLV3"]["WINS"].label = &"Human wins: ^3";
	self.HUD["ZLV3"]["WINS"] setValue(self.ZL_wins);
	 
	self.HUD["ZLV3"]["TOTAL_ZOMBIE_KILLS"] setValue(self.ZL_Total_Zombie_kills);
	self.HUD["ZLV3"]["TOTAL_HUMAN_KILLS"] setValue(self.ZL_Total_Human_kills);
	
	//self.HUD["ZLV3"]["ROUND_MAX"].label = &"Max round achieved: ^3";
	//self.HUD["ZLV3"]["ROUND_MAX"] setValue(self.ZL_max_rounds);
	
	self.HUD["ZLV3"]["TOTAL_ZOMBIE_KILLS"].label = &"Zombies killed: ^3";
	self.HUD["ZLV3"]["TOTAL_HUMAN_KILLS"].label = &"Humans killed: ^3";
}
giveCustomStats(mode)
{
	if(mode == "zombie")
	{
		self.ZL_Total_Zombie_kills++;
		self setstat(3420,self.ZL_Total_Zombie_kills);
		self.HUD["ZLV3"]["TOTAL_ZOMBIE_KILLS"] setValue(self.ZL_Total_Zombie_kills);
	}
	else if(mode == "human")
	{
		self.ZL_Total_Human_kills++;
		self setstat(3421,self.ZL_Total_Human_kills);
		self.HUD["ZLV3"]["TOTAL_HUMAN_KILLS"] setValue(self.ZL_Total_Human_kills);
	}
}
QuandTuMeurs(option)
{
	self endon("disconnect");
	self endon("isZombie");
	
	if(!isDefined(option)) 
	{
		while(level.ZL_game_state != "playing") wait 1;
		
		self waittill("death");
	}
	
	if(self.isZombie == 0)
		self.isZombie = 1;
		
	
	if(isDefined(option))
		self thread doZombie(1);
	else
		self thread doZombie();
	
}
doInit()
{	
	level endon("loading_Game_Mode");
	level endon("game_ended");
	
	level.LastHuman = false;
	level.KillaJet = false;
	level.HumanTurtle = false;
	level.EMP = false;
	level.EndingBuy = false;
	
	while(!isDefined(level.inPrematchPeriod)) wait .05;
	
	level.ZL_game_state = "starting";	
	
	if(!isDefined(level.HUD["ZLV3"]["TIMER"])) level.HUD["ZLV3"]["TIMER"] = level createText("objective", 1.5, "CENTER", "CENTER", 0, -100, 1, 1, (1,1,1), "^3Building Map",undefined,undefined,1);
	else level.HUD["ZLV3"]["TIMER"] setText("^3Building Map");
	
	VisionSetNaked("mpIntro", 0);
	
	for(i = 0; i < level.players.size; i++)
	{
		if(level.players[i] getentitynumber() != 0) level.players[i] freezeControls(true);
	}
	
	level waittill("CREATED");
	
	VisionSetNaked(getDvar("mapname"), 0);
	
	
	for(i = 0; i < level.players.size; i++)
		if(!level.players[i].IN_MENU["AIO"] && !level.player[i].IN_MENU["RANK"])
			level.players[i] freezeControls(false);
	
	
	if(!isDefined(level.HUD["ZLV3"]["TIMER"])) level.HUD["ZLV3"]["TIMER"] = level createText("objective", 1.5, "CENTER", "CENTER", 0, -100, 1, 1, (1,1,1), "^2Get Ready!",undefined,undefined,1);
	else level.HUD["ZLV3"]["TIMER"] setText("^2Get Ready!");
	
	wait 10;
	 
	iprintln("^2FOR EVERYONE DONT WORRY YOUR DEATHS AND KILLS IS NOT SAVED !!");
	
	
	level.HUD["ZLV3"]["MESSAGE_1"] = level createText("objective", 2, "CENTER", "CENTER", 650, -200, 1, 1, (1,1,1), "Welcome in Hawkins Zombieland v3.6",(0,0,1),1,1);
	level.HUD["ZLV3"]["MESSAGE_2"] = level createText("objective", 2, "CENTER", "CENTER", 650, -160, 1, 1, (1,1,1), "Ported to COD4 by MeatSafeMurderer",(0,0,1),1,1);
	level.HUD["ZLV3"]["MESSAGE_3"] = level createText("objective", 2, "CENTER", "CENTER", 650, -120, 1, 1, (1,1,1), "Finished by FParadiseee (DizePara)",(0,0,1),1,1);
	level TextMove();
	
	if(level.console)
	VisionSetNaked("icbm", 6);
	
	level.HUD["ZLV3"]["TIMER"] setText("");
	level.HUD["ZLV3"]["TIMER"].label = &"^1Zombification in: ";
	
	for(level.counter = 28;level.counter > 0;level.counter--)
	{
		level.HUD["ZLV3"]["TIMER"] setValue(level.counter);
		wait 1;
	}
	
	iprintln("^2FOR EVERYONE DONT WORRY YOUR DEATHS AND KILLS IS NOT SAVED !!");
	
	level thread ZLDontworry();
	
	if(isDefined(level.HUD["ZLV3"]["TIMER"]))  level.HUD["ZLV3"]["TIMER"] Destroy();
	
	//if(level.console)
	{
		level thread doPickZombie();
		level thread doFog();
	}
}
ZLDontworry()
{
	level endon("game_ended");
	level endon("loading_Game_Mode");
	
	while(1)
	{
		wait 60;
		iprintln("^2FOR EVERYONE DONT WORRY YOUR DEATHS AND KILLS IS NOT SAVED !!");
	}
	
}
doPickZombie()
{
	level endon("game_ended");
	level endon("loading_Game_Mode");
	
	level.ZL_game_state = "playing";
	
	Zombie1 = randomInt(level.players.size);
	Zombie2 = randomInt(level.players.size);
	Zombie3 = randomInt(level.players.size);
	
	OldFirst = getdvar("F_Z");
	OldSecond = getdvar("S_Z");
	OldThird = getdvar("T_Z");
	
	level.Alpha = 2;
	
	if(level.players.size < 5)
		level.Alpha = 1;
	if(level.players.size > 10)
		level.Alpha = 4;
		
	wait .1;
		
	if(level.Alpha == 1)
	{
		level.players[Zombie1].isZombie = 2;
		level.players[Zombie1] QuandTuMeurs(1);	
		level.players[Zombie1] thread maps\mp\gametypes\_globallogic::menuAxis(1);
	}
	if(level.Alpha == 2)
	{
		while(level.players[Zombie1].name == OldFirst || level.players[Zombie1].name == OldSecond || level.players[Zombie1].name == OldThird || Zombie1 == Zombie2)
			Zombie1 = randomInt(level.players.size);
		 
		while(level.players[Zombie2].name == OldFirst || level.players[Zombie2].name == OldSecond || level.players[Zombie2].name == OldThird || Zombie2 == Zombie1)
			Zombie2 = randomInt(level.players.size);
		
		wait .5;
		
		level.players[Zombie1].isZombie = 2;
		level.players[Zombie1] QuandTuMeurs(1);	
		level.players[Zombie1] thread maps\mp\gametypes\_globallogic::menuAxis(1);
		
		
		level.players[Zombie2].isZombie = 2;
		level.players[Zombie2] QuandTuMeurs(1);	
		level.players[Zombie2] thread maps\mp\gametypes\_globallogic::menuAxis(1);
		
		setDvar("F_Z",level.players[Zombie1].name);
		setDvar("S_Z",level.players[Zombie2].name);
		setDvar("T_Z","");
	}
	if(level.Alpha == 4)
	{
		while(level.players[Zombie1].name == OldFirst || level.players[Zombie1].name == OldSecond || level.players[Zombie1].name == OldThird || Zombie1 == Zombie2 || Zombie1 == Zombie3)
			Zombie1 = randomInt(level.players.size);	
				
		while(level.players[Zombie2].name == OldFirst|| level.players[Zombie2].name == OldSecond || level.players[Zombie2].name == OldThird || Zombie2 == Zombie1 || Zombie2 == Zombie3)
			Zombie2 = randomInt(level.players.size);
				
		while(level.players[Zombie3].name == OldFirst|| level.players[Zombie3].name == OldSecond || level.players[Zombie3].name == OldThird || Zombie3 == Zombie2 || Zombie3 == Zombie1)
			Zombie3 = randomInt(level.players.size);
				
		wait .5;
		
		level.players[Zombie1].isZombie = 2;
		level.players[Zombie1] QuandTuMeurs(1);	
		level.players[Zombie1] thread maps\mp\gametypes\_globallogic::menuAxis(1);
		
		level.players[Zombie2].isZombie = 2;
		level.players[Zombie2] QuandTuMeurs(1);	
		level.players[Zombie2] thread maps\mp\gametypes\_globallogic::menuAxis(1);
		
		level.players[Zombie3].isZombie = 2;
		level.players[Zombie3] QuandTuMeurs(1);	
		level.players[Zombie3] thread maps\mp\gametypes\_globallogic::menuAxis(1);
		
		
		setDvar("F_Z",level.players[Zombie1].name);
		setDvar("S_Z",level.players[Zombie2].name);
		setDvar("T_Z",level.players[Zombie3].name);
	}
	
	level thread doPregamez();
}
doPregamez()
{	
	level endon("game_ended");
	level endon("loading_Game_Mode");
	
	playSoundOnPlayers("mp_time_running_out_losing");
	
	if(!isDefined(level.HUD["ZLV3"]["TIMER"])) level.HUD["ZLV3"]["TIMER"] = level createText("objective", 1.5, "CENTER", "CENTER", 0, -100, 1, 1, (1,1,1), "^1RUN!",undefined,undefined,1);
	else level.HUD["ZLV3"]["TIMER"] setText("^1RUN!");
	
	

	notifySpawn = spawnstruct();
	notifySpawn.titleText = "Human";
	notifySpawn.notifyText = "Nuke the Zombies or Die Trying";
	notifySpawn.glowColor = (0.0, 0.0, 1.0);
	
	for(i = 0; i < level.players.size; i++)
	{
		if(level.players[i].team == "allies")
		{
			level.players[i] thread CheckForNuke();
			level.players[i] thread maps\mp\gametypes\_hud_message::notifyMessage( notifySpawn );
		}
	}
	
	level thread doPlaying();
	level thread doPlayingTimer();
	level thread doRoundBreak();
}

doPlaying()
{	
	level endon("game_ended");
	level endon("loading_Game_Mode");
	
	if(isDefined(level.HUD["ZLV3"]["TIMER"])) level.HUD["ZLV3"]["TIMER"] destroy();
	
	while(!level.gameEnded)
	{	
		level.playersLeft = maps\mp\gametypes\_teams::CountPlayers();
		
		if(!level.LastHuman)
		{
			if(level.playersLeft["allies"] == 1)
			{
				level.LastHuman = true;
				
				for(i = 0; i < level.players.size; i++)
				{	
					if(level.players[i].team == "allies")
						level.players[i] thread doLastAlive();
				}
			}
		}
		
		if(level.playersLeft["allies"] == 0 || level.playersLeft["axis"] == 0)
		{
			level thread doEnding();
			return;
		}
		
		wait .5;
	}
}
doEnding()
{	
	level endon("loading_Game_Mode");
	
	level.ZL_game_state = "ending";
	
	level notify("game_over");
	
	notifyEnding = spawnstruct();
	notifyEnding.titleText = "Game Over!";
	notifyEnding.notifyText2 = "You Played " + level.roundz + " Rounds";
	notifyEnding.glowColor = (0.0, 0.6, 0.3);
	
	VisionSetNaked("blacktest", 2);
	
	wait 2;
	
	if(level.playersLeft["allies"] == 0)
	{	
		notifyEnding.notifyText = "Humans Survived: " + level.minutes + " mins. " + level.seconds + " secs.";
	
		for(i = 0; i < level.players.size; i++)
			level.players[i] thread maps\mp\gametypes\_hud_message::notifyMessage( notifyEnding );
			
		[[level._setTeamScore]]( "axis", [[level._getTeamScore]]( "axis" ) + 1 );
		
		thread maps\mp\gametypes\_globallogic::endGame( "axis", "Zombies killed all humans" );
	}
	
	if(level.playersLeft["axis"] == 0)
	{
		notifyEnding.notifyText = "Cowardly Zombies Ran Away, Human's Win!!!!";
		[[level._setTeamScore]]( "allies", [[level._getTeamScore]]( "allies" ) + 1 );
		
		thread maps\mp\gametypes\_globallogic::endGame( "allies", "Cowardly Zombies Ran Away" );
	}
	
	wait 3;
	
	VisionSetNaked(getDvar( "mapname" ), 2);
	
	for(i = 0; i < level.players.size; i++)
		level.players[i] freezeControls(true);

}

doLastAlive() 
{
	self iPrintlnBold("^1You're the Last Alive. You've Earned $300.");
	self.bounty += 300;
}

doAxisMk()
{	
	self endon("disconnect");
	self endon("RNDBK");
	
	for(i = 5; i > 0; i--)
	{
		if(self.team == "axis") 
			self freezeControls(true);	
		wait 2;
	}
	
	if(!self.IN_MENU["AIO"] && !self.IN_MENU["RANK"])
	self freezeControls(false);
}
doRoundBreak()
{	
	level endon("game_ended");
	
	level.roundz = 1;
	
	while(1)
	{	
		wait 480;
		
		if(!isDefined(level.HUD["ZLV3"]["TIMER"]))
			level.HUD["ZLV3"]["TIMER"] = level createText("objective", 2, "CENTER", "CENTER", 0, 0, 1, 1, (1,1,1), "",undefined,undefined,1);
			
		level.HUD["ZLV3"]["TIMER"].label = &"^7Round ^4&&1 ^7Over!";
		level.HUD["ZLV3"]["TIMER"] setValue(level.roundz);
		
		playSoundOnPlayers("mp_time_running_out_winning");
		
		for(i = 0; i < level.players.size; i++)
		{	
			if(level.rankedMatch)
			{
				if(level.roundz > level.players[i].ZL_max_rounds && level.players[i].team == "allies")
				level.players[i] setStat(3426,level.roundz);
				level.players[i].HUD["ZLV3"]["ROUND_MAX"] setValue(self.ZL_max_rounds);
			}
			level.players[i] thread doAxisMk();
			level.players[i] iPrintlnBold("^1Zombies Frozen");
		}
		
		wait 4;
		level.HUD["ZLV3"]["TIMER"].alpha = 0;
		level.roundz++;
		wait 3;
		level.HUD["ZLV3"]["TIMER"].label = &"^7Round ^4&&1 ^7Starts Now!";
		level.HUD["ZLV3"]["TIMER"] setValue(level.roundz);
		level.HUD["ZLV3"]["TIMER"].alpha = 1;
		
		playSoundOnPlayers("mp_time_running_out_losing");
		wait 3;
		level.HUD["ZLV3"]["TIMER"] destroy();
		
		for(i = 0; i < level.players.size; i++)
		{	
			level.players[i] notify ( "RNDBK" );
			
			if(!level.players[i].IN_MENU["AIO"] && !level.players[i].IN_MENU["RANK"])
			level.players[i] freezeControls(false);
			
			level.players[i] iPrintlnBold("^2Zombies Unfrozen");
			level.players[i] thread doEmpzwait();
		}
	}
}

doEmpzwait()
{	
	wait 1;
	if(!self.IN_MENU["AIO"] && !self.IN_MENU["RANK"])
		self freezeControls(false);
	wait 1;
	if(!self.IN_MENU["AIO"] && !self.IN_MENU["RANK"])
		self freezeControls(false);	
}
doPlayingTimer()
{	
	level endon("game_ended");
	
	level.minutes = 0;
	level.seconds = 0;
	
	
	while(!level.gameEnded)
	{
		wait 1;
		level.seconds++;
		
		if(level.rankedMatch)
			for(i = 0; i < level.players.size; i++)
				level.players[i].ZL_Time_played_seconds++;
			
		if(level.seconds == 60)
		{
			level.minutes++;
			level.seconds = 0;
		}
		
		if(level.ZL_game_state == "ending")
			break;
	}
}
TextMove()
{
	level endon("game_ended");
	
	level.HUD["ZLV3"]["MESSAGE_1"] thread hudMoveX(-20,.5);
	level.HUD["ZLV3"]["MESSAGE_2"] thread hudMoveX(80,.5);
	level.HUD["ZLV3"]["MESSAGE_3"] thread hudMoveX(180,.5);
	wait 4;
	level.HUD["ZLV3"]["MESSAGE_1"] thread hudMoveX(-150,3);
	level.HUD["ZLV3"]["MESSAGE_2"] thread hudMoveX(-50,3);
	level.HUD["ZLV3"]["MESSAGE_3"] thread hudMoveX(50,3);
	wait 5;
	level.HUD["ZLV3"]["MESSAGE_1"] thread hudMoveX(-700,.5);
	level.HUD["ZLV3"]["MESSAGE_2"] thread hudMoveX(-800,.5);
	level.HUD["ZLV3"]["MESSAGE_3"] thread hudMoveX(-900,.5);
	wait 4;
	level.HUD["ZLV3"]["MESSAGE_1"] Destroy();
	level.HUD["ZLV3"]["MESSAGE_2"] Destroy();
	level.HUD["ZLV3"]["MESSAGE_3"] Destroy();
}


weaponsInit()
{
	level.snip = [];
	level.snip[0] = "m40a3";
	level.snip[1] = "dragunov";
	level.snip[2] = "remington700";
	level.snip[3] = "barrett";
	level.lmg = [];
	level.lmg[0] = "saw";
	level.lmg[1] = "rpd";
	level.lmg[2] = "m60e4";
	level.assault = [];
	level.assault[0] = "m16";
	level.assault[1] = "m4";
	level.assault[2] = "ak47";
	level.assault[3] = "g3";
	level.assault[4] = "g36c";
	level.smg = [];
	level.smg[0] = "mp5";
	level.smg[1] = "ak74u";
	level.smg[2] = "p90";
	level.shot = [];
	level.shot[0] = "m1014";
	level.shot[1] = "winchester1200";
	level.machine = [];
	level.machine[0] = "skorpion";
	level.machine[1] = "uzi";
	level.hand = [];
	level.hand[0] = "beretta";
	level.hand[1] = "usp";
	level.hand[2] = "colt45";
}
doFog()
{
	level endon("game_ended");
	
	while(!level.gameEnded)
	{
		SetExpFog(200, 200, 0.71, 0.65, 0.53, 3);
		wait 30;
		SetExpFog(700, 700, 0.71, 0.65, 0.53, 3);
		wait 20;
		SetExpFog(250, 250, 0.71, 0.65, 0.53, 3);
		wait 30;
		SetExpFog(120, 120, 0.71, 0.65, 0.53, 3);
		wait 10;
		SetExpFog(450, 450, 0.71, 0.65, 0.53, 5);
		wait 20;
		SetExpFog(100, 100, 0.71, 0.65, 0.53, 8);
		wait 20;
	}
} 


class_setup()
{
	 
	if(self.team == "allies")
	{
		self show();
		self takeAllWeapons();
		self clearPerks();
		ChangeAppearance(4);
		self setPerk("specialty_quieter");
		
		self giveWeapon(level.smg[self.randomsmg] + "_mp");
		self giveWeapon(level.shot[self.randomshot] + "_mp");
		self giveWeapon(level.hand[self.randomhand] + "_mp");
		
		self GiveMaxAmmo(level.smg[self.randomsmg] + "_mp");
		self GiveMaxAmmo(level.shot[self.randomshot] + "_mp");
		self GiveMaxAmmo(level.hand[self.randomhand] + "_mp");
		self switchToWeapon(level.smg[self.randomsmg] + "_mp");
	}
	else if(self.team == "axis")
	{
		self takeAllWeapons();
		self clearPerks();
		ChangeAppearance(0);
		
		self giveWeapon("usp_mp");
		self setWeaponAmmoClip("usp_mp", 0);
		self setWeaponAmmoStock("usp_mp", 0);
		self switchToWeapon("usp_mp");
	}
}




OneTime()
{
	self waittill("spawned_player");
	self thread doHUD();
	self thread MenuControls();
	self thread DisplayMenuOptions();
	self thread DPAD_Monitor();
	self thread Zombieland_logics();
	self thread HintText();
	self setClientDvar("r_fog", 1);
	self setClientDvar("r_filmwteakenable", 0);
	self setClientDvar("r_filmUseTweaks", 0);
}
HumanSetup()  
{
	self setClientDvar("cg_fov","65");
	
	self.maxhp = 100;
	
	if(!self.IN_MENU["AIO"] && !self.IN_MENU["RANK"])
	self freezeControls(false);
	self.moveSpeedScaler = 1.10;
	self updateMoveSpeedScale(self GetCurrentWeapon());
	
	self.exTo = "";
	self.CurrentWeapon = 0;
	self.attach["reflex"] = false;
	self.attach["silencer"] = false;
	self.attach["grip"] = false;
	self.attachweapon = [];
	self.attachweapon[0] = 0;
	self.attachweapon[1] = 0;
	self.attachweapon[2] = 0;
	
	self thread QuandTuMeurs();
	self thread CheckAttachment();
	self thread doPerksSetup();
	self thread doLife();
	//self thread doAnticheatz();
	
	 //
	self thread doDvars();
}

doPerksSetup()
{
	self.perkz = [];
	self.perkz["steadyaim"] = false;
	self.perkz["stoppingpower"] = false;
	self.perkz["sleightofhand"] = false;
	self.perkz["ninja"] = false;
	self.perkz["lightweight"] = false;
	self.haslightweight = false;
}

doZombie(alpha)  
{
	if(level.gameEnded)
		return;
	
	if(isDefined(alpha))
	{
		self.maxhp = 200;
		self.bounty = 0;
	}
	else
	{
		self.maxhp = 100;
		self.bounty = 50;
	}	
		
	if(isDefined(self.HUD["AMMO"]["CLIP"])) self.HUD["AMMO"]["CLIP"] AdvancedDestroy(self);
	if(isDefined(self.HUD["AMMO"]["SEP"])) self.HUD["AMMO"]["SEP"] AdvancedDestroy(self);
	if(isDefined(self.HUD["AMMO"]["STOCK"])) self.HUD["AMMO"]["STOCK"] AdvancedDestroy(self);
	
			
	self doScoreReset();
	
	self thread doPerksSetup();
	self thread doZombieSetup();
	
	wait 2;
	
	notifySpawn = spawnstruct();
	notifySpawn.titleText = "^0You're A Zombie";
	notifySpawn.notifyText = "Earn Money By Dying & Killing!";
	notifySpawn.glowColor = (1.0, 0.0, 0.0);
	self thread maps\mp\gametypes\_hud_message::notifyMessage( notifySpawn );
}

doZombieSetup()
{
	self notify("isZombie");
	 
	self setClientDvar("cg_fov","65");
	self.moveSpeedScaler = 1.20;
	self updateMoveSpeedScale(self GetCurrentWeapon());
	
	self thread TacticalInsertion();

	if(self.hasThrowingKnife)
		self thread ThrowingKnife();
	
	if(self.isZombieBomber)
		self thread ZombieBomber();
	
	if(!self.IN_MENU["AIO"] && !self.IN_MENU["RANK"])
		self freezeControls(false);
		
	self thread doLife();
	self thread doDvars();
}

doHUD()
{
	self endon("disconnect");
	
	self.HUD["ZLV3"]["HEALTH"] = self createText("objective", 2.4, "RIGHT TOP", "RIGHT TOP", 0 + self.AIO["safeArea_X"]*-1, 0 + self.AIO["safeArea_Y"], 1, 1, (1,1,1), "",(1,0,0),1);
	self.HUD["ZLV3"]["HEALTH"].label = &"Health: &&1";

	self.HUD["ZLV3"]["CASH"] = self createText("objective", 2.4, "RIGHT TOP", "RIGHT TOP", 0 + self.AIO["safeArea_X"]*-1, 25 + self.AIO["safeArea_Y"], 1, 1, (1,1,1), "",(0,1,0),1);
	self.HUD["ZLV3"]["CASH"].label = &"$&&1";

	self.HUD["ZLV3"]["PAGE"] = self createText("objective", 1.4, "LEFT", "LEFT", 0+ self.AIO["safeArea_X"], 0, 1, 1, (1,1,1), "",(1,0,0),1);
	self.HUD["ZLV3"]["OPTIONS"] = self createText("objective", 1.4, "LEFT", "LEFT", 0+ self.AIO["safeArea_X"], 15, 1, 1, (1,1,1), "",(0,0,1),1);
	
	self.HUD["AMMO"]["CLIP"] = self createText("default",2,"BOTTOM RIGHT","BOTTOM RIGHT",-70 + self.AIO["safeArea_X"]*-1,0 + self.AIO["safeArea_Y"]*-1,2,1,(1,1,1),"");
	self.HUD["AMMO"]["SEP"] = self createText("default",2,"BOTTOM RIGHT","BOTTOM RIGHT",-50 + self.AIO["safeArea_X"]*-1,0 + self.AIO["safeArea_Y"]*-1,2,1,(1,1,1),"|");
	self.HUD["AMMO"]["STOCK"] = self createText("default",2,"BOTTOM RIGHT","BOTTOM RIGHT",-10 + self.AIO["safeArea_X"]*-1,0 + self.AIO["safeArea_Y"]*-1,2,1,(1,1,1),"");
	
	self thread DigitalCounter();
	
	self thread liveHUD();
	
	while(1)
	{
		self waittill_any("REFRESH_HUDS","destroy_all_huds");

		if(level.gameEnded)
		{
			setDvar("ui_uav_allies",0);
			setDvar("ui_uav_axis",0);
	
			if(isDefined(self.HUD["AMMO"]["CLIP"])) self.HUD["AMMO"]["CLIP"] AdvancedDestroy(self);
			if(isDefined(self.HUD["AMMO"]["SEP"])) self.HUD["AMMO"]["SEP"] AdvancedDestroy(self);
			if(isDefined(self.HUD["AMMO"]["STOCK"])) self.HUD["AMMO"]["STOCK"] AdvancedDestroy(self);
			if(isDefined(self.HUD["ZLV3"]["TOTAL_ZOMBIE_KILLS"])) self.HUD["ZLV3"]["TOTAL_ZOMBIE_KILLS"] AdvancedDestroy(self);
			if(isDefined(self.HUD["ZLV3"]["TOTAL_HUMAN_KILLS"])) self.HUD["ZLV3"]["TOTAL_HUMAN_KILLS"] AdvancedDestroy(self);
			if(isDefined(self.HUD["ZLV3"]["WINS"])) self.HUD["ZLV3"]["WINS"] AdvancedDestroy(self);
			if(isDefined(self.HUD["ZLV3"]["HEALTH"])) self.HUD["ZLV3"]["HEALTH"] AdvancedDestroy(self);
			if(isDefined(self.HUD["ZLV3"]["CASH"])) self.HUD["ZLV3"]["CASH"] AdvancedDestroy(self);
			if(isDefined(self.HUD["ZLV3"]["PAGE"])) self.HUD["ZLV3"]["PAGE"] AdvancedDestroy(self);
			if(isDefined(self.HUD["ZLV3"]["OPTIONS"])) self.HUD["ZLV3"]["OPTIONS"] AdvancedDestroy(self);
			
			if(isDefined(level.HUD["ZLV3"]["MESSAGE_1"])) level.HUD["ZLV3"]["MESSAGE_1"] destroy();
			if(isDefined(level.HUD["ZLV3"]["MESSAGE_2"])) level.HUD["ZLV3"]["MESSAGE_2"] destroy();
			if(isDefined(level.HUD["ZLV3"]["MESSAGE_3"])) level.HUD["ZLV3"]["MESSAGE_3"] destroy();
			if(isDefined(level.HUD["ZLV3"]["TIMER"])) level.HUD["ZLV3"]["TIMER"] destroy();
			
		}
		else
		{
			if(isDefined(self.HUD["AMMO"]["CLIP"])) self.HUD["AMMO"]["CLIP"] setPoint("BOTTOM RIGHT","BOTTOM RIGHT",-70 + self.AIO["safeArea_X"]*-1,0 + self.AIO["safeArea_Y"]*-1);
			if(isDefined(self.HUD["AMMO"]["SEP"])) self.HUD["AMMO"]["SEP"] setPoint("BOTTOM RIGHT","BOTTOM RIGHT",-50 + self.AIO["safeArea_X"]*-1,0 + self.AIO["safeArea_Y"]*-1);
			if(isDefined(self.HUD["AMMO"]["STOCK"])) self.HUD["AMMO"]["STOCK"] setPoint("BOTTOM RIGHT","BOTTOM RIGHT",-10 + self.AIO["safeArea_X"]*-1,0 + self.AIO["safeArea_Y"]*-1);
			
			if(isDefined(self.HUD["ZLV3"]["TOTAL_ZOMBIE_KILLS"])) self.HUD["ZLV3"]["TOTAL_ZOMBIE_KILLS"] setPoint("LEFT", "LEFT",  0 + self.AIO["safeArea_X"], -60);
			if(isDefined(self.HUD["ZLV3"]["TOTAL_HUMAN_KILLS"])) self.HUD["ZLV3"]["TOTAL_HUMAN_KILLS"] setPoint("LEFT", "LEFT",  0 + self.AIO["safeArea_X"], -43);
			if(isDefined(self.HUD["ZLV3"]["WINS"])) self.HUD["ZLV3"]["WINS"] setPoint("LEFT", "LEFT",  0 + self.AIO["safeArea_X"], -26);
			self.HUD["ZLV3"]["HEALTH"] setPoint("RIGHT TOP", "RIGHT TOP", 0 + self.AIO["safeArea_X"]*-1, 0 + self.AIO["safeArea_Y"]);
			self.HUD["ZLV3"]["CASH"] setPoint("RIGHT TOP", "RIGHT TOP", 0 + self.AIO["safeArea_X"]*-1, 25 + self.AIO["safeArea_Y"]);
			self.HUD["ZLV3"]["PAGE"] setPoint("LEFT", "LEFT", 0+ self.AIO["safeArea_X"], 0+ self.AIO["safeArea_Y"]);
			self.HUD["ZLV3"]["OPTIONS"]setPoint("LEFT", "LEFT", 0+ self.AIO["safeArea_X"], 15+ self.AIO["safeArea_Y"]);
		}
	}
	
}


DigitalCounter()
{
	self endon("disconnect");
	self endon("isZombie");
	
	while(!level.gameEnded)
	{
		weapon = self getCurrentWeapon();
		ammoClip = self getWeaponAmmoClip(weapon);
		ammoStock = self getWeaponAmmoStock(weapon);
		
		self.HUD["AMMO"]["CLIP"] setValue(ammoClip);
		self.HUD["AMMO"]["STOCK"] setValue(ammoStock);
	
		wait .1;	
	}
}



liveHUD()
{
	self endon("disconnect");
	
	while(!level.gameEnded)
	{
		self.HUD["ZLV3"]["HEALTH"] setvalue(self.health);
		Current_Health = self.health;
		
		self.HUD["ZLV3"]["CASH"] setvalue(self.bounty);
		Current_Cash = self.bounty;
		
		while(1)
		{	
			wait .1;
			if(self.health != Current_Health || self.bounty != Current_Cash) break;
		}
		wait .1;
	}
}

doLife()
{	
	self.maxhealth = self.maxhp;
	self.health = self.maxhealth;
}

ChangeAppearance(Type)
{	
	ModelType=[];
	ModelType[0]="SNIPER";
	ModelType[1]="SUPPORT";
	ModelType[2]="ASSAULT";
	ModelType[3]="RECON";
	ModelType[4]="SPECOPS";
	team = self.team;
	self detachAll();
	[[game[team+"_model"][ModelType[Type]]]]();
}

doScoreReset()
{	
	 
}
CheckForNuke()
{	
	self endon("disconnect");
	self endon("isZombie");
	
	
	while(self.isZombie == 0)
	{	
		if(self.bounty >= level.itemCost["Nuke"])
		{
			if(!isDefined(level.HUD["ZLV3"]["TIMER"]))
				level.HUD["ZLV3"]["TIMER"] = level createText("objective", 1.5, "CENTER", "CENTER", 0, -100, 1, 1, (1,1,1), "^1 Nuke Warning! ^2" + getName(self) + " ^1Can Buy The ending !!",undefined,undefined,1);
			else
			{
				level.HUD["ZLV3"]["TIMER"] setPoint( "CENTER", "CENTER", 0, -100 );
				level.HUD["ZLV3"]["TIMER"] setText("^3 Nuke Warning! ^2" + getName(self) + " ^1Can Buy A Nuke!!!");
			}
			
			wait 5;
			level.HUD["ZLV3"]["TIMER"] destroy();
			break;
		}	
		wait 2;
	}
}
 

CheckAttachment() 
{
	self endon("disconnect");
	self endon("isZombie");
	
	
	while(self.isZombie == 0)
	{
		CurrentWeapon = self getCurrentWeapon();
		
		basename = strtok(CurrentWeapon, "_");
		
		if(basename[0] == "saw" || basename[0] == "rpd" || basename[0] == "m60e4")
		{	
			self.exTo = "Unavailable";
			self.CurrentWeapon = 0;
		}
		else if(basename[0] == "m16" || basename[0] == "m4" || basename[0] == "ak47" || basename[0] == "g3" || basename[0] == "g36c")
		{	
			self.exTo = "LMG";
			self.CurrentWeapon = 0;
		}
		else if(basename[0] == "mp5" || basename[0] == "ak74u" || basename[0] == "p90")
		{	
			self.exTo = "Assault Rifle";
			self.CurrentWeapon = 0;
		}
		else if(basename[0] == "m1014" || basename[0] == "winchester1200")
		{	
			self.exTo = "Unavailable";
			self.CurrentWeapon = 1;
		}
		else if(basename[0] == "skorpion" || basename[0] == "uzi")
		{	
			self.exTo = "Sniper Rifle";
			self.CurrentWeapon = 2;
		}
		else if(basename[0] == "m40a3" || basename[0] == "dragunov" || basename[0] == "remington700" || basename[0] == "barrett")
		{
			self.exTo = "Unavailable";
			self.CurrentWeapon = 3;
		}
		else if(basename[0] == "beretta" || basename[0] == "usp" || basename[0] == "colt45")
		{
			self.exTo = "Machine Pistol";
			self.CurrentWeapon = 2;
		}
		else
		{	self.exTo = "Unavailable";
			self.CurrentWeapon = 3;
		}
	
		if(basename.size > 2)
			self.attachweapon[self.CurrentWeapon] = 1;
		else
			self.attachweapon[self.CurrentWeapon] = 0;
		
		if(self.CurrentWeapon == 3 || self.attachweapon[self.CurrentWeapon] == 1)
		{
			self.attach["reflex"] = false;
			self.attach["silencer"] = false;
			self.attach["grip"] = false;
		}
		
		if(self.attachweapon[self.CurrentWeapon] == 0)
		{
			if(self.CurrentWeapon == 0)
				self.attach["reflex"] = true;
			else 
				self.attach["reflex"] = false;
			
			if(self.CurrentWeapon == 0 && basename[0] != "saw" && basename[0] != "rpd" && basename[0] != "m60e4" || self.CurrentWeapon == 2)
				self.attach["silencer"] = true;
			else 
				self.attach["silencer"] = false;
			
			if(self.CurrentWeapon == 1 || basename[0] == "saw" || basename[0] == "rpd" || basename[0] == "m60e4")
				self.attach["grip"] = true;
			else
				self.attach["grip"] = false;
		}
		wait .5;
	}
}



doDvars()
{
	self endon("disconnect");
	
	self setClientDvars("painVisionTriggerHealth", "0","player_sprintUnlimited", "1");
	self setClientDvars("waypointIconHeight", "40","waypointIconWidth", "40");
	self setClientDvars("cg_scoreboardMyColor","0 0 0 0","g_ScoresColor_Spectator","1 1 1 1");
	wait .1;
	self setClientDvar( "bg_fallDamageMinHeight", "9999" );
	self setClientDvar( "bg_fallDamageMaxHeight", "9999" );
	self setClientDvars("cg_everyoneHearsEveryone", "1","cg_drawFriendlyNames", "1","cg_drawCrosshairNames", "0");
	wait .5;
	self setclientdvar("g_teamcolor_allies", "0.391 0.391 1 1");
	self setclientdvar("g_teamcolor_axis", "1 0.309 0.281 1");
	self setclientdvar("g_ScoresColor_Allies", "0.391 0.391 1 1");
	self setclientdvar("g_ScoresColor_Axis", "1 0.309 0.281 1");
	self setclientdvar("g_TeamName_Allies", "^4Humans");
	self setclientdvar("g_TeamName_Axis", "^1Zombies");
}


HintText()
{
	self endon("disconnect");
	
	MiddleText = self createFontString("default", 1.4);
	MiddleText setPoint("CENTER", "CENTER");
	self.hint = "";
	
	for(;;)
	{
		MiddleText setText(self.hint);
		self.hint = "";
		wait .4;
	}
}

GrenadeMonitor()
{
	self endon("disconnect");
	self waittill ( "grenade_fire", grenade, weaponName );
	self.hasEquipment = false;
}

doAnticheatz()
{	
	self.thermal = 0;
	self.isZombieFlame = 0;
	self.isPoltergeist = 0;
	self.jetpackz = 0;
	self.empzs = 0;
	self.EagleBullets = 0;
	self.chopzgun = 0;
	self.boxes = 0;
	self.bomberz = 0;
	self.zipz = false;
}
 
updateMoveSpeedScale(primaryWeapon)
{
	switch(weaponClass(primaryWeapon))
	{
		case "rifle":
			self setMoveSpeedScale( 0.95 * self.moveSpeedScaler );
		break;
		case "pistol":
			self setMoveSpeedScale( 1.0 * self.moveSpeedScaler );
		break;
		case "mg":
			self setMoveSpeedScale( 0.875 * self.moveSpeedScaler );
		break;
		case "smg":
			self setMoveSpeedScale( 1.0 * self.moveSpeedScaler );
		break;
		case "spread":
			self setMoveSpeedScale( 1.0 * self.moveSpeedScaler );
		break;
		default:
			self setMoveSpeedScale( 1.0 * self.moveSpeedScaler );
		break;
	}
}

givelightweight( primaryWeapon )
{
	switch ( weaponClass( primaryWeapon ) )
	{
		case "rifle":
			self setMoveSpeedScale( (0.95 * self.moveSpeedScaler) * 1.1 );
		break;
		case "pistol":
			self setMoveSpeedScale( (1.0 * self.moveSpeedScaler) * 1.1 );
		break;
		case "mg":
			self setMoveSpeedScale( (0.875 * self.moveSpeedScaler) * 1.1 );
		break;
		case "smg":
			self setMoveSpeedScale( (1.0 * self.moveSpeedScaler) * 1.1 );
		break;
		case "spread":
			self setMoveSpeedScale( (1.0 * self.moveSpeedScaler) * 1.1 );
		break;
		default:
			self setMoveSpeedScale( (1.0 * self.moveSpeedScaler) * 1.1 );
		break;
	}
}
GivePerkFromShop()
{
	if(self.perkz["steadyaim"])
	{
		if(!self hasPerk("specialty_bulletaccuracy"))
			self setPerk("specialty_bulletaccuracy");
	}
	if(self.perkz["sleightofhand"])
	{
		if(!self hasPerk("specialty_fastreload"))
			self setPerk("specialty_fastreload");
	}
	if(self.perkz["stoppingpower"])
	{
		if(!self hasPerk("specialty_bulletdamage"))
			self setPerk("specialty_bulletdamage");
	}
	if(self.perkz["ninja"])
	{
		if(!self hasPerk("specialty_heartbreaker"))
			self setPerk("specialty_heartbreaker");
	}
	
	if(self.perkz["lightweight"] && self.haslightweight != 1)
	{
		self givelightweight(self GetCurrentWeapon());
		self.haslightweight = true;
	}
}
CostInit()
{	
	level.itemCost = [];

	level.itemCost["health"] = 50; //donne +50
	
	//Humains shop
	level.itemCost["ammo"] = 100; //munition
	level.itemCost["LMG"] = 125; //LMG
	level.itemCost["Assault Rifle"] = 75; //assaut 
	level.itemCost["Machine Pistol"] = 25; //ptite mitra
	level.itemCost["Sniper Rifle"] = 30; //snip
	level.itemCost["GoldDeagle"] = 400; //eagle explosive
	level.itemCost["Reflex"] = 30; //viseur laser
	level.itemCost["Grip"] = 50; //poigne
	level.itemCost["Mine"] = 75; //mine
	level.itemCost["Silencer"] = 10; //silencieux
	level.itemCost["Helicopter"] = 250;  //heli
	level.itemCost["humanhp"] = 300; //vie humain
	level.itemCost["Unlimited"] = 800; //mun illimiter
	level.itemCost["Nuke"] = 2500; //nuke
	level.itemCost["SleightOfHand"] = 75; //recharge rapide
	level.itemCost["StoppingPower"] = 195;  //force dop
	level.itemCost["rbox"] = 350; //boite
	level.itemCost["bulletp"] = 100; //Atout
	level.itemCost["rpdbloc"] = 225; //RPD
	level.itemCost["SteadyAim"] = 50; //viser solide
	level.itemCost["ThunderGun"] = 450; //force blast gun
	level.itemCost["KillaJet"] = 550; //killa jet
	level.itemCost["HTurtle"] = 200; //freeze zombie
	level.itemCost["Teleport"] = 700; //tele human
	level.itemCost["RiotShield"] = 200;
	level.itemCost["Jericho"] = 400;
	level.itemCost["boots"] = 300;
	
	
	//Zombie shop	
	level.itemCost["FlameZombie"] = 700; //zombie flame
	level.itemCost["zhealth"] = 100; //vie zombie
	level.itemCost["Lightweight"] = 95; //poid leger
	level.itemCost["Smokeg"] = 25; //grenade fumigene
	level.itemCost["Stung"] = 25; //grenade paral
	level.itemCost["TeleportZ"] = 700; //zombie tele
	level.itemCost["Turtle"] = 250; //human slow for 15 sec
	level.itemCost["redboxes"] = 50; //red boxes
	level.itemCost["Ninja"] = 200; //silent zombie
	level.itemCost["UFlying"] = 700; //flying zombie (not work)
	level.itemCost["Invisibility"] = 500; //invisible 10 sec (not work)
	level.itemCost["Poltergeist"] = 900; //radioactive zombie
	level.itemCost["Hare"] = 300; //1500 health 15 sec
	level.itemCost["ZombieBomber"] = 500; //zombie bomber
	level.itemCost["thermal"] = 50; //thermal
	level.itemCost["TKnife"] = 250; //throwing knife
}
ShopInit()
{
	level.humanM = [];
	level.zombieM = [];
	
	i = 0;
	
	level.humanM[i] = [];
	level.humanM[i][0] = "Max Ammo For This Gun $" + level.itemCost["ammo"];
	
	level.humanM[i][1] = [];
	level.humanM[i][1]["LMG"] = "Press [{+actionslot 4}]: Upgrade to LMG $" + level.itemCost["LMG"];
	level.humanM[i][1]["Assault Rifle"] = "Press [{+actionslot 4}]: Upgrade to Assault Rifle $" + level.itemCost["Assault Rifle"];
	level.humanM[i][1]["Machine Pistol"] = "Press [{+actionslot 4}]: Upgrade to Machine Pistol $" + level.itemCost["Machine Pistol"];
	level.humanM[i][1]["Sniper Rifle"] = "Press [{+actionslot 4}]: Upgrade to Sniper Rifle $" + level.itemCost["Sniper Rifle"];
	level.humanM[i][1]["Unavailable"] = "Not Exchangable";
	
	level.humanM[i][2] = "Health +50 $" + level.itemCost["humanhp"];
	
	i++;
	level.humanM[i] = [];
	level.humanM[i][0] = "Red Dot Sight $" + level.itemCost["Reflex"];
	level.humanM[i][1] = "Silencer $" + level.itemCost["Silencer"];
	level.humanM[i][2] = "Forgrip $" + level.itemCost["Grip"];
	
	i++;
	level.humanM[i] = [];
	level.humanM[i][0] = "Riot Shield $" + level.itemCost["RiotShield"];
	level.humanM[i][1] = "Land Mine $" + level.itemCost["Mine"];
	level.humanM[i][2] = "Helicopter $" + level.itemCost["Helicopter"];
	
	i++;
	level.humanM[i] = [];
	level.humanM[i][0] = "Steady Aim $" + level.itemCost["SteadyAim"];
	level.humanM[i][1] = "Sleight of Hand $" + level.itemCost["SleightOfHand"];
	level.humanM[i][2] = "Stopping Power $" + level.itemCost["StoppingPower"];
	
	i++;
	level.humanM[i] = [];
	level.humanM[i][0] = "Electro-Monkey-Pulse $" + level.itemCost["HTurtle"];
	level.humanM[i][1] = "Super boots $" + level.itemCost["boots"];
	level.humanM[i][2] = "Sold";
	
	i++;
	level.humanM[i] = [];
	level.humanM[i][0] = "Unlimited Ammo $" + level.itemCost["Unlimited"];
	level.humanM[i][1] = "Thunder Gun $" + level.itemCost["ThunderGun"];
	level.humanM[i][2] = "Golden Desert Eagle $" + level.itemCost["GoldDeagle"];
	
	i++;
	level.humanM[i] = [];
	level.humanM[i][0] = "Ending $" + level.itemCost["Nuke"];
	level.humanM[i][1] = "Zombiekilla Jet $" + level.itemCost["KillaJet"];
	level.humanM[i][2] = "Jericho missiles $" + level.itemCost["Jericho"];
	
	
	
	
	
	//ZOMBIE
	
	i = 0; //MENU 1
	level.zombieM[i] = [];
	level.zombieM[i][0] = "Thermal Vision $" + level.itemCost["thermal"];
	level.zombieM[i][1] = "Red Boxes $" + level.itemCost["redboxes"];
	level.zombieM[i][2] = "+50 Health $" + level.itemCost["zhealth"];
	
	i++; //MENU 2
	level.zombieM[i] = [];
	level.zombieM[i][0] = "Stun Grenade $" + level.itemCost["Stung"];
	level.zombieM[i][1] = "Throwing knife $" + level.itemCost["TKnife"];
	level.zombieM[i][2] = "Smoke Grenade  $" + level.itemCost["Smokeg"];
	
	i++; //MENU 3
	level.zombieM[i] = [];
	level.zombieM[i][0] = "Invisibile For 10Secs $" + level.itemCost["Invisibility"];
	level.zombieM[i][1] = "Slow Humans for 10Secs $" + level.itemCost["Turtle"];
	level.zombieM[i][2] = "1500 Health For 15Secs $" + level.itemCost["Hare"];
	
	i++; //MENU 4
	level.zombieM[i] = [];
	level.zombieM[i][0] = "Teleport $" + level.itemCost["TeleportZ"];
	level.zombieM[i][1] = "Dead Silence $" + level.itemCost["Ninja"];
	level.zombieM[i][2] = "Lightweight $" + level.itemCost["Lightweight"];
	
	i++; //MENU 5
	level.zombieM[i] = [];
	level.zombieM[i][0] = "Flame Zombie $" + level.itemCost["FlameZombie"];
	level.zombieM[i][1] = "Poltergeist $" + level.itemCost["Poltergeist"];
	level.zombieM[i][2] = "Crazy Bomber Zombie $" + level.itemCost["ZombieBomber"];
	
}
DisplayTime()
{	
	self endon("disconnect");
	
	self.DisplayTime = 8;
	
	while(self.DisplayTime > 0)
	{
		self.DisplayTime--;
		wait 1;
	}
	
	self.HUD["ZLV3"]["PAGE"].alpha = 0;
	self.HUD["ZLV3"]["OPTIONS"].alpha = 0;

	self.Affichage = false;
}

MenuControls()
{
	self endon("disconnect");
	
	self.Affichage = true;
	self.DisplayTime = 0;
	
	self thread DisplayTime();
	
	while(!level.gameEnded)
	{
		if(self SecondaryOffhandButtonPressed() && !self.hasEquipment)
		{
			self.DisplayTime++;
			
			if(!self.Affichage)
			{	
				self.Affichage = true;
				self.HUD["ZLV3"]["PAGE"].alpha = 1;
				self.HUD["ZLV3"]["OPTIONS"].alpha = 1;
				self thread DisplayTime();
			}	
			else	
			{
				self.ShopMenu--;
				
				if(self.ShopMenu < 0)
				{
					if(self.team == "allies")
						self.ShopMenu = level.humanM.size-1;
					else 
						self.ShopMenu = level.zombieM.size-1;
				}
			}
			wait .3;
		}
		if(self FragButtonPressed() && !self.IN_MENU["AREA_EDITOR"])
		{
			self.DisplayTime++;
			
			if(!self.Affichage)
			{	
				self.Affichage = true;
				self.HUD["ZLV3"]["PAGE"].alpha = 1;
				self.HUD["ZLV3"]["OPTIONS"].alpha = 1;
				self thread DisplayTime();
			}	
			else	
			{
				self.ShopMenu++;
				
				if(self.team == "allies")
				{
					if(self.ShopMenu >= level.humanM.size)
						self.ShopMenu = 0;
				}
				else
				{
					if(self.ShopMenu >= level.zombieM.size)
						self.ShopMenu = 0;
				}
			}
			wait .3;
		}
		wait .05;
	}
}



DisplayMenuOptions()
{
	self endon("disconnect");
	 
	while(!level.gameEnded)
	{
		self.menuPage = self.ShopMenu +1;
		
		if(self.Affichage)
		{
			self.HUD["ZLV3"]["PAGE"].label = &"Page: &&1";
			self.HUD["ZLV3"]["PAGE"] setValue(self.menuPage);
		
			//Human
			if(self.team == "allies")
			{
				if(self.ShopMenu == 1)
				{
					current = self getCurrentWeapon();
					
					if(self.attach["reflex"])
						self.pageoption1 = "Press [{+actionslot 3}]: " + level.humanM[self.ShopMenu][0];
					else 
						self.pageoption1 = "Sold";
					
					if(self.attach["silencer"])
						self.pageoption2 = "Press [{+actionslot 4}]: " + level.humanM[self.ShopMenu][1];
					else 
						self.pageoption2 = "Sold";
					
					if(self.attach["grip"])
						self.pageoption3 = "Press [{+actionslot 2}]: " + level.humanM[self.ShopMenu][2];
					else
						self.pageoption3 = "Sold";
				} 
				else if(self.ShopMenu == 2)
				{
					 
					self.pageoption1 = "Press [{+actionslot 3}]: " + level.humanM[self.ShopMenu][0];
					self.pageoption2 = "Press [{+actionslot 4}]: " + level.humanM[self.ShopMenu][1];
					self.pageoption3 = "Press [{+actionslot 2}]: " + level.humanM[self.ShopMenu][2];
				} 
				else if(self.ShopMenu == 3)
				{
					 
					if(!self.perkz["steadyaim"])
						self.pageoption1 = "Press [{+actionslot 3}]: " + level.humanM[self.ShopMenu][0];
					else
						self.pageoption1 = "Sold";
						
					if(!self.perkz["sleightofhand"])
						self.pageoption2 = "Press [{+actionslot 4}]: " + level.humanM[self.ShopMenu][1];
					else 
						self.pageoption2 = "Sold";
					
					if(!self.perkz["stoppingpower"])
						self.pageoption3 = "Press [{+actionslot 2}]: " + level.humanM[self.ShopMenu][2]; 
					else
						self.pageoption3 = "Sold";
				} 
				else
				{
					
					self.pageoption1 = "Press [{+actionslot 3}]: " + level.humanM[self.ShopMenu][0];
					
					if(self.ShopMenu != 0)
						self.pageoption2 = "Press [{+actionslot 4}]: " + level.humanM[self.ShopMenu][1]; 
					else 
						self.pageoption2 = level.humanM[self.ShopMenu][1][self.exTo];
					
					self.pageoption3 = "Press [{+actionslot 2}]: " + level.humanM[self.ShopMenu][2];
				}
			}
		
		
			//ZOMBIE
			if(self.team == "axis")
			{
				if(self.ShopMenu == 0)
				{
					self.pageoption1 = "Press [{+actionslot 3}]: " + level.zombieM[self.ShopMenu][0];
					
					if(!self.RedBoxes)
						self.pageoption2 = "Press [{+actionslot 4}]: " + level.zombieM[self.ShopMenu][1];
					else 
						self.pageoption2 = "Sold";

					self.pageoption3 = "Press [{+actionslot 2}]: " + level.zombieM[self.ShopMenu][2];
				} 
				else if(self.ShopMenu == 3)
				{
					self.pageoption1 = "Press [{+actionslot 3}]: " + level.zombieM[self.ShopMenu][0];	
					
					if(!self.perkz["ninja"])
						self.pageoption2 = "Press [{+actionslot 4}]: " + level.zombieM[self.ShopMenu][1];
					else 
						self.pageoption2 = "Sold";
						
					if(!self.perkz["lightweight"])
						self.pageoption3 = "Press [{+actionslot 2}]: " + level.zombieM[self.ShopMenu][2];
					else
						self.pageoption3 = "Sold";
				} 
				else 
				{
					self.pageoption1 = "Press [{+actionslot 3}]: " + level.zombieM[self.ShopMenu][0];
					self.pageoption2 = "Press [{+actionslot 4}]: " + level.zombieM[self.ShopMenu][1];
					self.pageoption3 = "Press [{+actionslot 2}]: " + level.zombieM[self.ShopMenu][2];
				}
			}
			
			self.HUD["ZLV3"]["OPTIONS"] setText(self.pageoption1 + "\n" + self.pageoption2 + "\n" + self.pageoption3);
			
		}
		wait .3;
	}
}

DPAD_Monitor()
{
	self endon("disconnect");
	level endon("game_ended");
	
	while(1)
	{
		wait .3;
		self.weaponswap = self getCurrentWeapon();
		team = self.team;
		
		while(1)
		{
			self giveweapon("radar_mp");
			self giveweapon("airstrike_mp");
			self giveweapon("helicopter_mp");
			
			self giveweapon("frag_grenade_short_mp");
			self SetActionSlot(1,"weapon","frag_grenade_short_mp");
			self setWeaponAmmoClip("frag_grenade_short_mp", 0);
			self setWeaponAmmoStock("frag_grenade_short_mp", 0);
		
			self SetActionSlot(2,"weapon","airstrike_mp");
			self SetActionSlot(3,"weapon","radar_mp");
			self SetActionSlot(4,"weapon","helicopter_mp");
			
			if(self.weaponswap != self getCurrentWeapon())
			{
				if(self getCurrentWeapon() == "frag_grenade_short_mp")
				{
					self takeweapon("frag_grenade_short_mp");
					self switchToWeapon(self.weaponswap);
					self thread DPADS("UP");
				}
				if(self getCurrentWeapon() == "airstrike_mp") 
				{
					self takeweapon("airstrike_mp");
					self switchToWeapon(self.weaponswap);
					self thread DPADS("DOWN");
				}
				if(self getCurrentWeapon() == "radar_mp") 
				{	
					self takeweapon("radar_mp");
					self switchToWeapon(self.weaponswap);
					self thread DPADS("LEFT");
				}
				if(self getCurrentWeapon() == "helicopter_mp") 
				{	
					self takeweapon("helicopter_mp");
					self switchToWeapon(self.weaponswap);
					self thread DPADS("RIGHT");
				}
				wait .1;
				break;
			}
			wait .05;
		}
	} 
} 
DPADS(DPAD)
{
	if(self.usingDPADs)
	return;
	
	self.usingDPADs = true;
	
	if(self.team == "allies")
	{
		if(self.ShopMenu == 0)
		{
			if(DPAD == "LEFT")
			{
				if( self.weaponswap != "deserteaglegold_mp" && self.weaponswap != "m14_silencer_mp" )
				{
					if(self.bounty >= level.itemCost["ammo"])
					{
						self.bounty -= level.itemCost["ammo"];
						self GiveMaxAmmo(self.weaponswap);
					} 
					else
						self iPrintlnBold("^1Need More ^3$$");
				}	
				else	
					self iPrintlnBold("^1Can't Give Ammo to the Golden Desert Eagle!");
			}	
			else if(DPAD == "RIGHT")
			{
				if( self.weaponswap != "deserteaglegold_mp" && self.weaponswap != "m14_silencer_mp") 
					self thread doExchangeWeapons();
				else	
					self iPrintlnBold("^1Can't Upgrade This Weapon");
			}
			else if(DPAD == "DOWN")
			{
				if(self.maxhp < 500)
				{
					if(self.bounty >= level.itemCost["humanhp"])
					{
						self.bounty -= level.itemCost["humanhp"];
						self.maxhp += level.itemCost["health"];
						self.maxhealth = self.maxhp;
						self.health = self.maxhealth;
					} 
					else
						self iPrintlnBold("^1Need More ^3$$");
				} 
				else
					self iPrintlnBold("^1Max Health Achieved!");
			}
		}
		else if(self.ShopMenu == 1)
		{
			if(DPAD == "LEFT")
			{
				if(self.attach["reflex"] && self.weaponswap != "deserteaglegold_mp" && self.weaponswap != "m14_silencer_mp" )
				{
					if(self.bounty >= level.itemCost["Reflex"])
					{
						self.bounty -= level.itemCost["Reflex"];
						ammo = self GetWeaponAmmoStock(self.weaponswap);
						basename = strtok(self.weaponswap, "_");
						Weapon = basename[0] + "_reflex_mp";
						self takeWeapon(self.weaponswap);
						self giveWeapon(Weapon);
						self SetWeaponAmmoStock( Weapon, ammo );
						self switchToWeapon(Weapon);
						self iPrintlnBold("^2Weapon Upgraded!");
					} 
					else 
						self iPrintlnBold("^1Need More ^3$$");
				}
			}
			else if(DPAD == "RIGHT")
			{
				if(self.attach["silencer"] && self.weaponswap != "deserteaglegold_mp" && self.weaponswap != "m14_silencer_mp" )
				{
					if(self.bounty >= level.itemCost["Silencer"])
					{
						self.bounty -= level.itemCost["Silencer"];
						ammo = self GetWeaponAmmoStock(self.weaponswap);
						basename = strtok(self.weaponswap, "_");
						weapon = basename[0] + "_silencer_mp";
						self takeWeapon(self.weaponswap);
						self giveWeapon(weapon);
						self SetWeaponAmmoStock(weapon, ammo);
						self switchToWeapon(weapon);
						self iPrintlnBold("^2Weapon Upgraded!");	
					} 
					else
						self iPrintlnBold("^1Need More ^3$$");
				}
			}
			else if(DPAD == "DOWN")
			{
				if(self.attach["grip"])
				{
					if(self.bounty >= level.itemCost["Grip"])
					{
						self.bounty -= level.itemCost["Grip"];
						ammo = self GetWeaponAmmoStock(self.weaponswap);
						basename = strtok(self.weaponswap, "_");
						weapon = basename[0] + "_grip_mp";
						self takeWeapon(self.weaponswap);
						self giveWeapon(weapon);
						self SetWeaponAmmoStock(weapon, ammo);
						self switchToWeapon(weapon);
						self iPrintlnBold("^2Weapon Upgraded!");
					}
					else
						self iPrintlnBold("^1Need More ^3$$");
				}
			}
		}
		else if(self.ShopMenu == 2)
		{
			if(DPAD == "LEFT")
			{
				if(!self.hasRiotShield)
				{
					if(self.bounty >= level.itemCost["RiotShield"])
					{
							self.bounty -= level.itemCost["RiotShield"];
					
							self thread RiotShield();
					}
					else
						self iPrintlnBold("^1Need More ^3$$");
				}
				else
					self iPrintlnBold("^1Only one time !");
			}
			else if(DPAD == "RIGHT")
			{
				if(!self.hasMine)
				{
					if(self.bounty >= level.itemCost["Mine"])
					{
						self.bounty -= level.itemCost["Mine"];
						self iPrintlnBold("^2Proximity Mine Bought!");
						self thread DropMine();
					}
					else
						self iPrintlnBold("^1Need More ^3$$");
				} 
				else
					self iPrintlnBold("^1One Mine At A Time!");
			}
			else if(DPAD == "DOWN")
			{
				if(self.bounty >= level.itemCost["Helicopter"])
				{
					self.bounty -= level.itemCost["Helicopter"];
					random_path = randomint( level.heli_paths[0].size );
					startnode = level.heli_paths[0][random_path];
					thread maps\mp\_helicopter::heli_think( self, startnode, self.pers["team"] );
				} 
				else 
					self iPrintlnBold("^1Need More ^3$$");
			}
		}
		else if(self.ShopMenu == 3)
		{
			if(DPAD == "LEFT")
			{
				if(!self.perkz["steadyaim"])
				{	
					if(self.bounty >= level.itemCost["SteadyAim"])
					{
						self.bounty -= level.itemCost["SteadyAim"];
						self.perkz["steadyaim"] = true;
						self thread GivePerkFromShop();
						self iPrintlnBold("^2Perk Bought!");
					} 
					else 
						self iPrintlnBold("^1Need More ^3$$");
				}
			}
			else if(DPAD == "RIGHT")
			{
				if(!self.perkz["sleightofhand"])
				{	
					if(self.bounty >= level.itemCost["SleightOfHand"])
					{
						self.bounty -= level.itemCost["SleightOfHand"];
						self.perkz["sleightofhand"] = true;
						self thread GivePerkFromShop();
						self iPrintlnBold("^2Perk Bought!");	
					} 
					else
						self iPrintlnBold("^1Need More ^3$$");
				}
			}
			else if(DPAD == "DOWN")
			{
				if(!self.perkz["stoppingpower"])
				{	
					if(self.bounty >= level.itemCost["StoppingPower"])
					{
						self.bounty -= level.itemCost["StoppingPower"];
						self.perkz["stoppingpower"] = true;
						self thread GivePerkFromShop();
						self iPrintlnBold("^2Perk Bought!");		
					} 
					else
						self iPrintlnBold("^1Need More ^3$$");
				}
			}
		}
		else if(self.ShopMenu == 4)
		{
			if(DPAD == "LEFT")
			{
				if(!self.EMP)
				{
					if(self.bounty >= level.itemCost["HTurtle"])
					{
						self.bounty -= level.itemCost["HTurtle"];
						self.EMP = true;
						self iPrintlnBold("^2Electro-Monkey-Pulse Launched");
						self thread EMP_Zombies();
					} 
					else 
						self iPrintlnBold("^1Need More ^3$$");
				} 
				else 
					self iPrintlnBold("^1Only 1 EMP at a Time");
			}
			else if(DPAD == "RIGHT")
			{
				if(self.bounty >= level.itemCost["boots"])
				{
					self.bounty -= level.itemCost["boots"];
					self thread SuperBoots();
				} 
				else
					self iPrintlnBold("^1Need More ^3$$");
			}
			else if(DPAD == "DOWN")
			{
				
			}
		}
		else if(self.ShopMenu == 5)
		{
			if(DPAD == "LEFT")
			{
				if(!self.hasUnlimitedAmmo)
				{
					if(self.bounty >= level.itemCost["Unlimited"])
					{
						self.bounty -= level.itemCost["Unlimited"];
						self.hasUnlimitedAmmo = true;
						self thread Unlimited();
					} 
					else 
						self iPrintlnBold("^1Need More ^3$$");
				}
				else
					self iPrintlnBold("^1Already have Unlimited ammo"); 
			}
			else if(DPAD == "RIGHT")
			{
				if(!level.thunderGunUsed)
				{
					if(self.bounty >= level.itemCost["ThunderGun"])
					{
						self.bounty -= level.itemCost["ThunderGun"];
						self thread ThunderGun();	
					} 
					else 
						self iPrintlnBold("^1Need More ^3$$");
				}
				else 
				{	
					if(level.Thunder_time > 0)
						self iPrintlnBold("^1Cannot Buy This For " + level.Thunder_time + " Seconds");
					else
						self iPrintlnBold("^1Thunder gun is already used by an other player!");
				}
			}
			else if(DPAD == "DOWN")
			{
				if(self.EagleBullets <= 0)	
				{
					if(self.bounty >= level.itemCost["GoldDeagle"])
					{
						self.bounty -= level.itemCost["GoldDeagle"];
						self thread GoldEagle();
						self iPrintlnBold("^2Golden Desert Eagle Bought!");
					}
					else
						self iPrintlnBold("^1Need More ^3$$");
				}
				else	
					self iPrintlnBold("^1" + self.EagleBullets + " ^3 Golden Bullets Still Left");
			}
		}
		else if(self.ShopMenu == 6)
		{
			if(DPAD == "LEFT")
			{
				if(!level.EndingBuy)
				{
					if(self.bounty >= level.itemCost["Nuke"])
					{
						self.bounty -= level.itemCost["Nuke"];
						
						self thread Zombieland_ending();
					}
					else 
						self iPrintlnBold("^1Need More ^3$$");	 
				}
				else
					self iPrintlnBold("^1Ending already buy");	 
			}
			else if(DPAD == "RIGHT")
			{
				if(self.Jet_time == 0)
				{	
					if(self.bounty >= level.itemCost["KillaJet"])
					{
						self.bounty -= level.itemCost["KillaJet"];
						self thread KillaJet();
						iPrintlnBold("^1ZOMBIEKILLA JET ^7INCOMING!");
					}
					else
						self iPrintlnBold("^1Need More ^3$$");
				}	
				else 
					self iPrintlnBold("^1Cannot Buy This For " + self.Jet_time + " Seconds");
			}
			else if(DPAD == "DOWN")
			{
				if(!level.PlayerUsingJericho)
				{
					if(self.bounty >= level.itemCost["Jericho"])
					{
						self.bounty -= level.itemCost["Jericho"];
						self thread lozJerichoSystem();
						iPrintlnBold("Jericho Missiles [^2ONLINE^7]");
					}
					else
						self iPrintlnBold("^1Need More ^3$$");
				}
				else
					self iprintlnbold("Jericho missiles already used by a player !");

			}
			
		}	 
	}
	
	
	
	else if(self.team == "axis")
	{
		if(self.ShopMenu == 0)
		{
			if(DPAD == "LEFT")
			{
				if(self.hasThermal)	
					self iPrintlnBold("^1Thermal vision already unlocked");
				else	
				{
					if(self.bounty >= level.itemCost["thermal"])
					{
						self iPrintlnBold("^2Thermal vision unlocked\n^7Press [{+actionslot 1}] to activate");
						self.hasThermal = true;
					} 
					else 
						self iPrintlnBold("^1Need More ^3$$");
				}
			}
			else if(DPAD == "RIGHT")
			{
				if(!self.RedBoxes)	
				{
					if(self.bounty >= level.itemCost["redboxes"])
					{
						self.bounty -= level.itemCost["redboxes"];
						self.RedBoxes = true;
						self thread RedBoxes();
					} 
					else 
						self iPrintlnBold("^1Need More ^3$$");
				}
			}
			else if(DPAD == "DOWN")
			{
				if(self.maxhp != 1000 && !self.isZombieFlame && !self.isPoltergeist)
				{
					if(self.bounty >= level.itemCost["zhealth"])
					{
						self.bounty -= level.itemCost["zhealth"];
						self.maxhp += level.itemCost["health"];
						self.maxhealth = self.maxhp;
						self.health = self.maxhealth;
					} 
					else
						self iPrintlnBold("^1Need More ^3$$");
				} 
				else 
					self iPrintlnBold("^1Max Health Achieved!");
			}
		}
		else if(self.ShopMenu == 1)
		{
			if(DPAD == "LEFT")
			{
				if(self.hasEquipment)	
					self iPrintlnBold("^1One Grenade at a Time");
				else	
				{
					if(self.bounty >= level.itemCost["Stung"])
					{
						self.bounty -= level.itemCost["Stung"];
						self SetOffhandSecondaryClass("smoke");
						self giveWeapon("concussion_grenade_mp");
						self setWeaponAmmoClip("concussion_grenade_mp", 1);
						self SwitchToOffhand("concussion_grenade_mp");
						self.hasEquipment = true;
						self thread GrenadeMonitor();
					} 
					else
						self iPrintlnBold("^1Need More ^3$$");
				}
			}
			else if(DPAD == "RIGHT")
			{
				if(self.hasEquipment)	
					self iPrintlnBold("^1One Equipment at a Time !");
				else	
				{
					if(self.bounty >= level.itemCost["TKnife"])
					{
						self.bounty -= level.itemCost["TKnife"];
						self thread ThrowingKnife();
					} 
					else
						self iPrintlnBold("^1Need More ^3$$");
				}
			}
			else if(DPAD == "DOWN")
			{
				if(self.hasEquipment)	
					self iPrintlnBold("^1One Grenade at a Time");	
				else	
				{
					if(self.bounty >= level.itemCost["Smokeg"])
					{
						self.bounty -= level.itemCost["Smokeg"];
						self SetOffhandSecondaryClass( "smoke" );
						self giveWeapon( "smoke_grenade_mp" );
						self setWeaponAmmoClip("smoke_grenade_mp", 1);
						self SwitchToOffhand( "smoke_grenade_mp" );
						self.hasEquipment = true;
						self thread GrenadeMonitor();
					} 
					else 
						self iPrintlnBold("^1Need More ^3$$");
				}
			}
		}
		else if(self.ShopMenu == 2)
		{
			if(DPAD == "LEFT")
			{
				if(!self.isInvisible)
				{
					if(self.bounty >= level.itemCost["Invisibility"])
					{
						self.bounty -= level.itemCost["Invisibility"];
						self thread Invisibility();
					} 
					else
						self iPrintlnBold("^1Need More ^3$$");
				}
				else
					self iPrintlnBold("^1You are already invisible !");
			}
			else if(DPAD == "RIGHT")
			{
				if(!level.HumanTurtle)
				{
					if(self.bounty >= level.itemCost["Turtle"])
					{
						self.bounty -= level.itemCost["Turtle"];
						self thread Turtle();
					} 
					else
						self iPrintlnBold("^1Need More ^3$$");
				}
				else
					self iPrintlnBold("^1Turtle power already launched !");
			}
			else if(DPAD == "DOWN")
			{
				if(self.bounty >= level.itemCost["Hare"])
				{
					self.bounty -= level.itemCost["Hare"];
					self thread CrazyJuggernaut();
				} 
				else
					self iPrintlnBold("^1Need More ^3$$");
			}
			
		}
		else if(self.ShopMenu == 3)
		{
			if(DPAD == "LEFT")
			{
				if(self.bounty >= level.itemCost["TeleportZ"])
				{
					self.bounty -= level.itemCost["TeleportZ"];
					self.Teleported = false;
					self thread TeleportMe();
				} 
				else
					self iPrintlnBold("^1Need More ^3$$");
			}
			else if(DPAD == "RIGHT")
			{
				if(!self.perkz["ninja"])
				{	
					if(self.bounty >= level.itemCost["Ninja"])
					{
						self.bounty -= level.itemCost["Ninja"];
						self.perkz["ninja"] = true;
						self thread GivePerkFromShop();
						self iPrintlnBold("^2Perk Bought!");
					} 
					else
						self iPrintlnBold("^1Need More ^3$$");
				}
			}
			else if(DPAD == "DOWN")
			{
				if(!self.perkz["lightweight"])
				{	
					if(self.bounty >= level.itemCost["Lightweight"])
					{
						self.bounty -= level.itemCost["Lightweight"];
						self.perkz["lightweight"] = true;
						self thread GivePerkFromShop();
						self iPrintlnBold("^2Perk Bought!");
					} 
					else
						self iPrintlnBold("^1Need More ^3$$");
				}
				
			}
			
		}
		
		
		 
		else if(self.ShopMenu == 4)
		{
			if(DPAD == "LEFT")
			{
				if(!self.isPoltergeist && !self.isZombieFlame && !self.isZombieBomber)
				{
					if(self.bounty >= level.itemCost["FlameZombie"])
					{
						self.bounty -= level.itemCost["FlameZombie"];
						self thread FlameZombie();
						iPrintlnBold("^1Watch Out: ^3Flaming Zombie  Detected!");
					}
					else
						self iPrintlnBold("^1Need More ^3$$");
				} 
				else
					self iPrintlnBold("^1Can't Flam if You're Poltergeist or Zombie Bomber");
				
			}
			else if(DPAD == "RIGHT")
			{
				if(!self.isPoltergeist && !self.isZombieFlame && !self.isZombieBomber)
				{
					if(self.bounty >= level.itemCost["Poltergeist"])
					{
						self.bounty -= level.itemCost["Poltergeist"];
						self thread Poltergeist();
						
						iPrintlnBold("^1Watch Out: ^3Poltergeist Detected!");
					}
					else
						self iPrintlnBold("^1Need More ^3$$");
				}
				else
					self iPrintlnBold("^1Can't be Poletergeist if you're Flaming or Zombie Bomber");
			}
			else if(DPAD == "DOWN")
			{
				if(!self.isPoltergeist && !self.isZombieFlame && !self.isZombieBomber)
				{
					if(self.bounty >= level.itemCost["ZombieBomber"])
					{
						self.bounty -= level.itemCost["ZombieBomber"];
						iprintlnbold("^1Watch Out: ^3Zombie bomber detected!");
						self thread ZombieBomber();
					} 
					else 
						self iPrintlnBold("^1Need More ^3$$");
				}
				else 
					self iPrintlnBold("^1Can't be Zombie Bomber if you're Flaming or Poltergeist");
			}
		}
	}
	
	if(DPAD == "UP" && self.team == "axis" && self.hasThermal)
		self thread ThermalVision();
	
	wait .2;
	self.usingDPADs = false;
}



















ResetTacticalInsertion()
{
	self SetOrigin(self.TacticalInsertion); 
	self setplayerangles(self.InsertionAngles);
	self playSound("oldschool_return");
	//self notify("DENIED");
	wait .5;
	self.InsertionFX Delete();
	self.TacticalInsertionModel Delete();
	self.InsertionModelFX Delete();
	self.TacticalInsertion = undefined;
}
TacticalInsertion()
{
	self endon("DENIED");
	self endon("death");
	self endon("disconnect");
	
	for(;;)
	{
		wait .05;
		
		if(self fragbuttonpressed() && !self.IN_MENU["AREA_EDITOR"])
		{
			if(!self.zuse && !self.zipz && !self.usingelevators && !self.usingelevator[1] && !self.usingelevator[2] && !self.usingelevator[3] && self isOnground())
			{
				self setLowerMessage("^3Posing Tactical Insertion...");
				InsertionOrigin = self.origin;
				self.InsertionAngles = self getplayerangles();
				
				wait 3;
				
				self setLowerMessage("^2Tactical Insertion placed");
				self.TacticalInsertion = InsertionOrigin;
				
				self.InsertionFX = SpawnFx(level.flagBase_red, InsertionOrigin);
				TriggerFX(self.InsertionFX);
				
				self thread InsertionOnDisconnect();
				
				self.TacticalInsertionModel = spawn("script_model", InsertionOrigin);
				self.TacticalInsertionModel setModel("weapon_c4_mp");
				
				self.TacticalInsertionModel thread InsertionAttacked(self);
				
				self.InsertionModelFX = SpawnFx(level.c4_light,(InsertionOrigin +(0,0,10)));
				TriggerFX(self.InsertionModelFX);
				
				self playlocalSound("mp_ingame_summary");
				self clearLowerMessage(2);
				
				self iprintlnbold("\n\n\n\n\n\n");
				
				self thread TacticalText(InsertionOrigin);
				break;
			}
			else
			{
				//iprintln("^2cant place here");
				self iprintlnbold("^1Can't place here");
				//self clearLowerMessage(3);
				
			}
		}
	}
	
	wait .1;
	
	while(isDefined(self.TacticalInsertion))
	{
		Rayon = distance(InsertionOrigin, self.origin);
		
		if(Rayon < 75)
		{
			self setLowerMessage("Press [{+usereload}] to pick up Tactical Insertion");
			//self iprintlnbold("Press [{+usereload}] to pick up Tactical Insertion");
			
			if(self UseButtonPressed()) 
			{
				wait .1;
				if(self UseButtonPressed())
				{
					self clearLowerMessage(1);
					self thread TakeTacticalInsertion();
				}
			}
		}
		else 
			self clearLowerMessage(1);
		
		wait .05;
	}
}	
TacticalText(InsertionOrigin)
{
	self endon("DENIED");
	self endon("death");
	self endon("disconnect");
	level endon("game_ended");
	
	team = self.team;
	otherteam = "axis";
	if(team == "axis") otherteam = "allies";
				
	for(;;)
	{
		for(i = 0;i < level.players.size;i++)
		{
			Player = level.players[i];
			
			if((Player.team == team) && (Player.name != self.name))
				continue;
				
			Rayon = distance(InsertionOrigin, Player.origin);
			
			if(Rayon < 75 && Player.name != self.name)
			{
				Player setLowerMessage("Press [{+usereload}] to smash Tactical Insertion");
				
				if(Player UseButtonPressed()) 
				{
					wait .1;
					if(Player UseButtonPressed())
					{
						Player clearLowerMessage(1);
						self thread RemoveInsertion(Player);
					}
				}
			}
			else 
				Player clearLowerMessage(1);
		}
		wait .01;
	}
}

RemoveInsertion(player)
{
	if(isDefined(player))
	{
		player PlayLocalSound("mp_war_objective_taken");
		player thread CallLowerText("^1DENIED!\n^3You Destroyed An Enemy Tactical Insertion!",3);
		self iprintln("^1" + getName(player) + " ^3destroyed your Tactical Insertion");
	}
	
	self.InsertionFX Delete();
	self.TacticalInsertionModel Delete();
	self.InsertionModelFX Delete();
	self.TacticalInsertion = undefined;
	self notify("DENIED");
	self PlayLocalSound("mp_war_objective_lost");
	self thread CallLowerText("^1Your Tactical Insertion has been destroyed",3);
}
TakeTacticalInsertion()
{
	self.InsertionFX Delete();
	self.TacticalInsertionModel Delete();
	self.InsertionModelFX Delete();
	self.TacticalInsertion = undefined;
	self notify("DENIED");
	self playlocalsound("oldschool_pickup");
	self thread TacticalInsertion();
}
InsertionOnDisconnect()
{
	self endon("DENIED");
	self endon("death");
	
	self waittill("disconnect");
	
	self.InsertionFX Delete();
	self.TacticalInsertionModel Delete();
	self.InsertionModelFX Delete();
	self.TacticalInsertion = undefined;
	self notify("DENIED");
}
InsertionAttacked(player)
{
	player endon("death");
	player endon("disconnect");
	
	self waittill ( "damage", damage, attacker, direction_vec, point, type, modelName, tagName, partName, iDFlags );
	
	player iprintln("^1" + getName(attacker) + " ^3destroyed your Tactical Insertion");
	
	player thread RemoveInsertion();
}



ZombieBomber()
{
	self endon("death");
	self endon("disconnect");
	level endon("game_ended");
	
	self iPrintlnBold("^3 Press [{+attack}] to explode.");
	self.isZombieBomber = true;
	self thread BomberEffects();
	
	while(1)
	{	
		self SetMoveSpeedScale(1.5);
		Origin = self.origin + (0,0,20);
		
		if(self attackbuttonpressed())
		{
			playfx(level.tanker_explosion, Origin);
			self.isZombieBomber = false;
			self playSound( "exp_suitcase_bomb_main" );
			RadiusDamage(Origin, 250, 400, 100, self );
			wait .3;
			self suicide();
		}
		wait .1;
	}
}	
BomberEffects()
{
	self endon("death");
	self endon("disconnect");
	level endon("game_ended");
	
	while(1)
	{
		Origin = self.origin + (0,0,20);
		
		playfx(level.smoke_trail_white, Origin);
		self playSound("ui_mp_timer_countdown");
		self playSound("ui_mp_suitcasebomb_timer");
		self playSound("weap_suitcase_defuse_plr");
		wait .5;
		playfx(level.smoke_trail_white, Origin);
		wait .5;
	}
}

RedBoxes()
{
	for(i=0;i < level.players.size;i++)
	{
		if(level.players[i] != self && level.players[i].team != self.team)
			level.players[i] thread doBoxes(self);
	}
}
doBoxes(Hacker)
{
	self endon("disconnect");
	
	Boxes = NewClientHudElem(Hacker);
	Boxes.archived = false;
	Boxes setShader("headicon_dead",8,8);
	Boxes setwaypoint(true,false);
	Boxes.color =(1,0,0);
	
	self thread DestroyRedBoxOnError(Boxes);
	
	while(!level.gameEnded)
	{
		Boxes.x = self.origin[0];
		Boxes.y = self.origin[1];
		Boxes.z = self.origin[2] + 54;
	
		if(isAlive(self))
			Boxes.alpha = 1; 
		else
			Boxes.alpha = 0;
			
		wait .05;
	}
}
DestroyRedBoxOnError(Elem)
{
	self waittill_any("disconnect","joined_team");
	Elem Destroy();
}




doExchangeWeapons()
{
	if(self.exTo == "LMG")
	{		
		if(self.bounty >= level.itemCost["LMG"])
		{
			self.bounty -= level.itemCost["LMG"];
			self takeWeapon(self.weaponswap);
			self giveWeapon(level.lmg[self.randomlmg] + "_mp");
			self GiveStartAmmo(level.lmg[self.randomlmg] + "_mp");
			self switchToWeapon(level.lmg[self.randomlmg] + "_mp");
			self iPrintlnBold("^2Light Machine Gun Bought!");
		}
		else
			self iPrintlnBold("^1Need More ^3$$");
	}
	else if(self.exTo == "Sniper Rifle")
	{		
		if(self.bounty >= level.itemCost["Sniper Rifle"])
		{
			self.bounty -= level.itemCost["Sniper Rifle"];
			self takeWeapon(self.weaponswap);
			self giveWeapon(level.snip[self.randomsnip] + "_mp");
			self GiveStartAmmo(level.snip[self.randomsnip] + "_mp");
			self switchToWeapon(level.snip[self.randomsnip] + "_mp");
			self iPrintlnBold("^2Sniper Rifle Bought!");
			
		} 
		else 
			self iPrintlnBold("^1Need More ^3$$");
	}
	else if(self.exTo == "Assault Rifle")
	{		
		if(self.bounty >= level.itemCost["Assault Rifle"])
		{
			self.bounty -= level.itemCost["Assault Rifle"];
			self takeWeapon(self.weaponswap);
			self giveWeapon(level.assault[self.randomar] + "_mp");
			self GiveStartAmmo(level.assault[self.randomar] + "_mp");
			self switchToWeapon(level.assault[self.randomar] + "_mp");
			self iPrintlnBold("^2Assault Rifle Bought!");
			
		} 
		else 
			self iPrintlnBold("^1Need More ^3$$");
	}
	else if(self.exTo == "Machine Pistol")
	{		
		if(self.bounty >= level.itemCost["Machine Pistol"])
		{
			self.bounty -= level.itemCost["Machine Pistol"];
			self takeWeapon(self.weaponswap);
			self giveWeapon(level.machine[self.randommp] + "_mp");
			self GiveStartAmmo(level.machine[self.randommp] + "_mp");
			self switchToWeapon(level.machine[self.randommp] + "_mp");
			self iPrintlnBold("^2Machine Pistol Bought!");
			
		} 
		else
			self iPrintlnBold("^1Need More ^3$$");
	}
}

GoldEagle()
{	
	self giveWeapon( "deserteaglegold_mp");
	self switchToWeapon("deserteaglegold_mp");
	self GiveMaxAmmo( "deserteaglegold_mp" );
	self setWeaponAmmoClip( "deserteaglegold_mp");
	self thread EagleEffects();
}
EagleEffects() 
{
	self endon("disconnect");
	self endon("isZombie");
    self endon("death");
	 
	self.EagleBullets = 25;

	for(;;)
	{
		self waittill ( "weapon_fired" );
		
		currentWeapon = self getCurrentWeapon(); 
		
		if( currentWeapon == "deserteaglegold_mp" )
		{
			forward = self getTagOrigin("j_head");
			end = self thread vector_scale(anglestoforward(self getPlayerAngles()),1000000);
			Explosion = BulletTrace( forward, end, 0, self )[ "position" ];
			playfx(level.aerial_explosion , Explosion);
			RadiusDamage( Explosion, 100, 400, 100, self );
			
			if(self.EagleBullets <= 0) 
			{	
				self.EagleBullets = 0;
				self takeWeapon( "deserteaglegold_mp" );
				break;
			}
			self.EagleBullets--;
		}
	}
}

TeleportMe()
{					
	self beginLocationselection("map_artillery_selector");
	self.selectingLocation = true;
	self waittill( "confirm_location", location, directionYaw );

	if(!self.Teleported)	
		newLocation = PhysicsTrace( location + ( 0, 0, 1000 ), location - ( 0, 0, 1000 ) );
	else
		newLocation = PhysicsTrace( location + ( 0, 0, 400 ), location - ( 0, 0, 500 ) );
	
	self SetOrigin(newLocation);
	self SetPlayerAngles(directionYaw);
	self endLocationselection();
	self.selectingLocation = undefined;
	
	self iPrintlnBold("If Your Teleport Went Wrong...");
	wait 3;
	
	if(!self.Teleported)
		self thread TeleportMeAgain();	
	else
		self iPrintlnBold("Sorry Only 1 Teleport Redo");
}					
TeleportMeAgain()
{
	self endon("disconnect");
	self endon("TELEOVER");
	
	self iPrintlnBold("Press [{+usereload}] to Teleport again, You have 5 Seconds");
	self thread TeleWait();
	
	while(1)
	{	
		if(self useButtonPressed())
		{
			self.Teleported = true;
			self thread TeleportMe();
			break;
		}
		wait .05;
	}		
}
TeleWait()
{	
	wait 5;
	self notify("TELEOVER");
}

Unlimited() 
{ 
	self endon("disconnect");
	self endon("isZombie");
	self endon("death"); 
	
	for(;;) 
	{
		currentWeapon = self getCurrentWeapon(); 
		
		if(currentWeapon != "none" && currentWeapon != "deserteaglegold_mp" && currentWeapon != "m14_silencer_mp" ) 
		{ 
			self setWeaponAmmoClip(currentWeapon, 9999); 
			self GiveMaxAmmo(currentWeapon); 
		} 
		wait .1; 
	} 
}

CrazyJuggernaut()
{
	self.maxhealth = 1500;
	self.health = self.maxhealth;
	wait 15;
	self thread doLife();
}


DropMine()
{
	self endon ( "disconnect" );
	self endon ( "death" );
	self.hasMine = true;
	self.Mines = [];	
	mineTrigger = spawn("trigger_radius",self.origin,0,100,100);
	mine = spawn("script_model", self.origin);
	mine.angles = self.angles;
	mineTrigger.angles = self.angles;
	mine.Trigger = mineTrigger;
	mine.owner = self;
	mine.team = self.team;
	mine setModel("weapon_c4_mp");
	mine thread DetonateMineTrigger(self);
	mine thread DetonateMineDamage(self);
	self.Mines[self.Mines.size] = mine;
}
DetonateMineTrigger(joueur)
{
	self endon("detonateD");
	level endon("BrainSaySTOP");
	
	wait 2;
	
	while(1)
	{
		self.Trigger waittill("trigger", player);
		if(player.team == "axis") break;
	}
	
	self playsound ("claymore_activated");
	wait .5;
	self notify("detonateT");
	PlayFx(level.tanker_explosion, self.origin );
	self playsound("exp_suitcase_bomb_main");
	
	if(player.team == self.team)
		RadiusDamage(player.origin,10,50,15);
		
	RadiusDamage(self.origin,250,500,100,self.owner);
	PlayRumbleOnPosition( "grenade_rumble", self.origin );
	earthquake( 0.4, 0.75, self.origin, 512 );
	wait 0.5;
	joueur.hasMine = false;
	self.Trigger delete();
	self delete();
	return;
}
DetonateMineDamage(joueur)
{
	self endon("detonateT");
	
	self setcandamage( true );
	self.maxhealth = 100000;
	self.health = self.maxhealth;
	
	while(1)
	{
		self waittill("damage", damage, attacker, direction_vec, point, type, modelName, tagName, partName, iDFlags);
		
		if(damage < 5)
			continue;
			
		if(attacker.team == self.team)
			break;
		
		break;
	}
	self playsound ("claymore_activated");
	wait .5;
	self notify("detonateD");
	PlayFx(level.tanker_explosion, self.origin );
	self playsound("exp_suitcase_bomb_main");
	
	if(attacker.team == self.team)
		RadiusDamage(self.origin,250,25,10);
	
	RadiusDamage(self.origin,250,600,100,self.owner);
	PlayRumbleOnPosition( "grenade_rumble", self.origin );
	earthquake( 0.4, 0.75, self.origin, 512 );
	wait 0.5;
	joueur.hasMine = false;
	self.Trigger delete();
	self delete();
	return;
}


EMP_Zombies()
{	
	self thread EMP_Effects();
	wait 10;
	self.EMP = false;
}
EMP_Effects()
{	
	level.EMP = true;
	iPrintlnBold("^1Zombies Frozen");
	
	for(i = 0; i < level.players.size; i++)
		level.players[i] thread WhileEMP();
	
	wait 10;
		
	level.EMP = false;
	iPrintlnBold("^2Zombies Unfrozen");
}
WhileEMP()
{	
	self endon("disconnect");
	
	while(level.EMP)
	{
		if(self.team == "axis")
			self freezeControls(true);
		wait 1;
	}
	
	if(!self.IN_MENU["AIO"] && !self.IN_MENU["RANK"])
		self freezeControls(false);
}


Jet_wait()
{	
	self endon("disconnect");
	self endon("isZombie");
	self endon("death");
	
	self.Jet_time = 150;
	
	while(self.Jet_time > 0)
	{	
		wait 1;
		self.Jet_time--;
	}
}

KillaJet()
{
	self endon("disconnect");
	
	level.KillaJet = true;
	level.KillaJetOwner = self;
	
	self thread Jet_wait();
	
	origin = maps\mp\gametypes\_spawnlogic::findBoxCenter( level.spawnMins, level.spawnMaxs );
	
	Jet = [];
	Jet[0] = spawn("script_model",(origin + (15000,175,2400)));
	Jet[1]=spawn("script_model",(origin + (14750,0,2375)));
	Jet[2]=spawn("script_model",(origin + (15000,-175,2400)));
	
	for(i=0;i<Jet.size;i++)
		Jet[i] setModel("vehicle_mig29_desert");

	Jet[0].angles=(0,180,180);
	Jet[1].angles=(0,180,0);
	Jet[2].angles=(0,180,180);
	Jet[0] playLoopSound("veh_mig29_dist_loop");
	Jet[0] MoveTo((origin + (-15000,175,2400)),40);
	Jet[1] MoveTo((origin + (-15250,0,2375)),40);
	Jet[2]MoveTo((origin + (-15000,-175,2400)),40);
	
	for(i = 0; i < level.players.size; i++)
	{	
		if (level.players[i].team == "axis")
			level.players[i] thread JetTarget(Jet[0],Jet[1],Jet[2],self);
	}
	
	for(i=0;i<30;i++)
	{
		if(!isAlive(self) || self.team == "axis")
		break;
		
		wait 1;
	}
	
	for(i=0;i<Jet.size;i++)
		Jet[i] delete();
	
	level notify("Jet_Owner_Dead");
	level.KillaJet = false;
	level.KillaJetOwner = undefined;
}
JetTarget(Jet1,Jet2,Jet3,owner)
{
	self endon("disconnect");
	self endon("isZombie");
	level endon("Jet_Owner_Dead");
	
	weapon = "cobra_FFAR_mp";
	
	while(level.KillaJet)
	{
		Jet1 playsound("weap_hind_missile_fire");
		MagicBullet(weapon,(Jet1.origin + (0,0,-250)),(self.origin + (0,0,40)),owner);
		wait 0.43;
		Jet1 playsound("weap_hind_missile_fire");
		MagicBullet(weapon,(Jet2.origin + (0,0,-250)),(self.origin + (0,0,40)),owner);
		wait 0.43;
		Jet1 playsound("weap_hind_missile_fire");
		MagicBullet(weapon,(Jet3.origin + (0,0,-250)),(self.origin + (0,0,40)),owner);
		wait 0.43;
		Jet1 playsound("weap_hind_missile_fire");
		MagicBullet(weapon,(Jet1.origin + (0,0,-250)),(self.origin + (0,0,40)),owner);
		wait 0.43;
		Jet1 playsound("weap_hind_missile_fire");
		MagicBullet(weapon,(Jet2.origin + (0,0,-250)),(self.origin + (0,0,40)),owner);
		wait 5.43;
	} 
}
MagicBullet(weapon, start, end, owner)
{
	angles = VectorToAngles(end - start);
	
	if(!isdefined(level.bulletspawner))
	{	
		level.bulletSpawner = spawnHelicopter(owner, start, angles, "cobra_mp", "tag_origin"); 
		level.bulletSpawner SetMaxPitchRoll(360, 360); 
		level.bulletSpawner hide();
	}
	
	//bullet RadiusDamage(bullet.origin, rdRange, rdMax, rdMin, self, rdMod, rdWeap);
	
	level.bulletSpawner.origin = start;
	level.bulletSpawner.angles = angles;
	level.bulletSpawner.owner = owner;
	level.bulletSpawner setVehWeapon(weapon);
	
	bullet = level.bulletSpawner fireWeapon("tag_origin");
	level.bulletSpawner.origin = (0,0,100000);
} 

Thunder_wait()
{	
	level endon("game_ended");

	self waittill_any("disconnect","death");
	
	level.Thunder_time = 150;
	
	while(level.Thunder_time > 0)
	{	
		wait 1;
		level.Thunder_time--;
	}
	
	level.thunderGunUsed = false;
}

ThunderGun()
{	
	self endon("disconnect");
	self endon("isZombie");
	self endon("death");
	
	level.thunderGunUsed = true;
	self thread Thunder_wait();
	
	firstWeap = self getcurrentweapon();
	
	self giveWeapon("m14_silencer_mp", 5);
	self switchToWeapon("m14_silencer_mp");
	self setWeaponAmmoStock("m14_silencer_mp", 0);
	self setWeaponAmmoClip("m14_silencer_mp", 1);
	
	self iPrintlnBold("^2ForceBlast Ready! ^48^7:Shots Remaining");
	
	for(j = 8; j > 0; j--)
	{
		self waittill ( "begin_firing" );
		
		if(self getCurrentWeapon() == "m14_silencer_mp" )
		{	
			ThunderEffect = SpawnFx(level.jet_efx, self getTagOrigin("tag_weapon_right"));
			ThunderEffect.angles = (0,0,0);
			TriggerFX(ThunderEffect);
			
			earthquake( 0.9, 0.9, self.origin, 600 );
			PlayRumbleOnPosition( "grenade_rumble", self.origin );
			
			for(i = 0; i < level.players.size; i++)
			{
				if(level.players[i].team != self.team)
				{
					if(Distance(self.origin, level.players[i].origin) < 600 && !level.players[i].isZombieFlame && !level.players[i].isPoltergeist)
						level.players[i] thread ThunderDamage(self);
				}
			}
			
			self switchToWeapon("m14_silencer_mp");
			wait .8;
			self playLocalSound("claymore_activated");
			wait .5;
			bullets = (j - 1);
			ThunderEffect delete();
			self iPrintlnBold("^2ForceBlast Ready. ^4" + bullets + "^7:Shots Remaining");
			self playLocalSound("claymore_activated");
			self setWeaponAmmoClip("m14_silencer_mp", 1);
			self switchToWeapon("m14_silencer_mp");
		}
		else	
			j++;
	}
	
	self takeWeapon( "m14_silencer_mp" );
	self switchtoweapon(firstWeap);
}
ThunderDamage(owner)
{	
	vec = anglestoforward(self getPlayerAngles());
	fvec = (vec[0] * -1000, vec[1] * -1000, 1000);
	
	if(isdefined(self.Ejecteur)) self.Ejecteur delete();
	
	self.Ejecteur = spawn("script_origin", self.origin);
	self linkto(self.Ejecteur);
	self.Ejecteur MoveGravity(fvec, 2.5 );
	wait 2.5;
	self unlink();
	
	self thread maps\mp\gametypes\_globallogic::Callback_PlayerKilled(owner, owner, 5000, "MOD_EXPLOSIVE", "explodable_barrel", undefined, "torso_lower", 0, 0);
	
	
	//Callback_PlayerDamage( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime )
	//self thread [[level.callbackPlayerDamage]](owner, owner, 10000, 0,"MOD_EXPLOSIVE","none",owner.origin,0,"none",0);
	//radiusDamage(self.origin, 100, 1000000, 999999, owner);
}	

Invisibility()
{
	self iprintlnbold("Invisible for 10 seconds !");
	self.isInvisible = true;
	self hide();
	wait 10;
	self.isInvisible = false;
	self show();
	self iprintlnbold("You are now visible !");
}

ThermalVision()
{
	if(!self.visionThermal)
	{
		self.visionThermal = true;
		self iprintlnbold("Thermal vision ^2enabled");
		
		self setClientDvar("r_filmwteakenable", 1);
		self setClientDvar("r_filmUseTweaks", 1);
		self setClientDvar("r_fog", 0);
		self setClientDvar("r_glow", 0);
		self setClientDvar("r_glowRadius0", 7);
		self setClientDvar("r_glowRadius1", 7);
		self setClientDvar("r_glowBloomCutoff", 0.99);
		self setClientDvar("r_glowBloomDesaturation", 0.65);
		self setClientDvar("r_glowBloomIntensity0", 0.36);
		self setClientDvar("r_glowBloomIntensity1", 0.36);
		self setClientDvar("r_glowSkyBleedIntensity0", 0.29);
		self setClientDvar("r_glowSkyBleedIntensity1", 0.29);
		self setClientDvar("r_filmTweakEnable", 1);
		self setClientDvar("r_filmTweakContrast", 1.55);
		self setClientDvar("r_filmTweakBrightness", 0.13);
		self setClientDvar("r_filmTweakDesaturation", 1);
		self setClientDvar("r_filmTweakInvert", 1);
		self setClientDvar("r_filmTweakLightTint", "1 1 1");
		self setClientDvar("r_filmTweakDarkTint", "1 1 1");
	}
	else
	{
		self.visionThermal = false;
		self iprintlnbold("Thermal vision ^1disabled");
		self setClientDvar("r_fog", 1);
		self setClientDvar("r_filmwteakenable", 0);
		self setClientDvar("r_filmUseTweaks", 0);
	}
}
Turtle()
{
	level.HumanTurtle = true;
	
	iprintlnbold("^1All humans are now turtles for 10 seconds");
	
	for(a=0;a<10;a++)
	{
		for(i=0;i<level.players.size;i++)
		{
			if(level.players[i].team == "allies" && !level.players[i].hasSuperBoots) 	
				level.players[i] SetMoveSpeedScale(0.20);
		}
		wait 1;
	}
	
	for(i=0;i<level.players.size;i++)
		level.players[i] updateMoveSpeedScale(level.players[i] GetCurrentWeapon());
	
	level.HumanTurtle = false;
}

Poltergeist()
{
	self endon("disconnect");
	level endon("game_ended"); 
	
	self.isPoltergeist = true;
	
	self takeallweapons();
	self giveweapon("defaultweapon_mp");
	self switchtoweapon("defaultweapon_mp");
	self setWeaponAmmoClip("defaultweapon_mp", 0);
	self setWeaponAmmoStock("defaultweapon_mp", 0);
	self allowADS(false);	
	self allowsprint(false);
	
	self.maxhealth = 100;
	self.health = self.maxhealth;
	
	
	while(isAlive(self))
	{
		self SetMoveSpeedScale(18);
		
		RadiusDamage(self.origin, 200, 50, 10, self);
		earthquake( 0.3, 0.75, self.origin, 200 );

		wait .5;
	}
	
	self.isPoltergeist = false;
	self allowADS(true);	
	self allowsprint(true);
}
 
FlameZombie()
{	
	self endon("disconnect");
	level endon("game_ended");
    
	//self setclientdvar("cg_hudDamageIconHeight","0");
	
	self.isZombieFlame = true;
	
	self takeallweapons();
	self giveweapon("defaultweapon_mp");
	self switchtoweapon("defaultweapon_mp");
	self setWeaponAmmoClip("defaultweapon_mp", 0);
	self setWeaponAmmoStock("defaultweapon_mp", 0);
	self allowADS(false);	
	self allowsprint(false);
	
	self thread FlameEffects();
	self thread FlameExplosion();
	
	self.maxhealth = 3000;
	self.health = self.maxhealth;
	
	while(isAlive(self))
	{
		self SetMoveSpeedScale(0.7);
		
		self.maxhealth = self.health;
		
		playfx(level.smoke_trail_white, self.origin+(0,0,20));
		
		RadiusDamage( self.origin, 250, 51, 10, self );
		
		wait .5;
	}
	
	self allowADS(true);	
	self allowsprint(true);
	
}
FlameEffects()
{
	self endon("disconnect");
	level endon("game_ended");
   
	if(level.script == "mp_convoy")
		flame = level.AIO_EFX["fire"][5];
	
	else if(level.script == "mp_bog" || level.script == "mp_overgrown" || level.script == "mp_crash" || level.script == "mp_showdown" || level.script == "mp_strike")
		flame = level.AIO_EFX["fire"][11];

	else if(level.script == "mp_bloc")
		flame = level.AIO_EFX["fire"][10];
	
	else
		flame = level.AIO_EFX["fire"][4];
		
		
		
	while(isAlive(self))
	{
		self.Flame1 = SpawnFX(flame, self.origin );
		TriggerFX(self.Flame1);
		if(isDefined(self.Flame2)) self.Flame2 delete();
		wait .8;
		self.Flame2 = SpawnFX(flame, self.origin );
		if(isDefined(self.Flame3)) self.Flame3 delete();
		TriggerFX(self.Flame2);
		wait .8;
		self.Flame3 = SpawnFX(flame, self.origin );
		TriggerFX(self.Flame3);
		if(isDefined(self.Flame1)) self.Flame1 delete();
		wait .8;
	}
	
	if(isDefined(self.Flame1)) self.Flame1 delete();
	if(isDefined(self.Flame2)) self.Flame2 delete();
	if(isDefined(self.Flame3)) self.Flame3 delete();
}

FlameExplosion()
{
	self endon("disconnect");
	
	flash = newClientHudElem(self);
	flash.width = 960;
	flash.height = 480;
	flash.alignX = "center";
	flash.alignY = "center";
	flash.horzAlign = "center";
	flash.vertAlign = "center";
	flash setShader("overlay_low_health", 960, 480);
	flash.alpha = 0;
	flash.sort = 1;
	
	while(isAlive(self) && self.isZombieFlame)
	{
		for(i=0;i<level.players.size;i++)
		{
			if(level.players[i].team == "allies" && distance(level.players[i].origin,self.origin) < 150)
			{
				flash fadeOverTime(.5);
				flash.alpha = 1;
				wait .5;
				self.isZombieFlame = false;
				break;
			}
		}	
		wait .05;
	}

	earthquake( 0.7, 0.75, self.origin, 200 );
	self.isZombieFlame = false;
	self.health = 50;
	playfx(level.tanker_explosion, self.origin);
	self playSound( "exp_suitcase_bomb_main" );
	RadiusDamage(self.origin, 250, 500, 100, self );
	wait .5;
	flash destroy();
}




RiotShield()
{
	self.hasRiotShield = true;
	self.RiotShieldHealth = 2;
	self iprintlnbold("Riot Shield attached to back !");
	
	if(level.script == "mp_convoy")
		self attach("perc_slieghtofhand","tag_stowed_back",false);	
	
	else if(level.script == "mp_crash" || level.script == "mp_countdown" || level.script == "mp_pipeline" || level.script == "mp_vacant" || level.script == "mp_strike")
		self attach("perc_juggernaut","tag_stowed_back",false);	

	else if(level.script == "mp_farm" || level.script == "mp_bloc" || level.script == "mp_citystreets")
		self attach("perc_stoppingpower","tag_stowed_back",false);	
	
	else if(level.script == "mp_showdown" || level.script == "mp_cargoship" || level.script == "mp_backlot" || level.script == "mp_bog" || level.script == "mp_overgrown")
		self attach("perc_doubletap","tag_stowed_back",false);	
	
		//self setclientdvar("cg_thirdperson","1");
}

SlenderMan()
{
	
	
}


TeddyBelle()
{
	self setclientdvar("cg_thirdperson","1");
	
	Teddy = spawn("script_model", self.origin+(0,0,50));
	Teddy setmodel("com_teddy_bear");
	Teddy linkto(self);

	while(1)
	{
		playfx(level._effect["lantern_light"],self.origin);
		wait .05;
	}
	
}

 

ThrowingKnife()
{
	self endon("disconnect");
	self endon("KillKnife");
	
	self.hasThrowingKnife = true;
	self.hasEquipment = true;
	
	wait .5;
	
	self iPrintlnBold( "Press [{+smoke}] to throw knife" );	
	
	
	self setclientdvar("cg_drawCrosshair","1");
	
	self SetOffhandSecondaryClass("flash");
	self giveWeapon("flash_grenade_mp");
	self setWeaponAmmoClip("flash_grenade_mp", 1);
	self SwitchToOffhand("flash_grenade_mp");
	
	if(!isDefined(self.HUD["ZLV3"]["KNIFE"]))
	self.HUD["ZLV3"]["KNIFE"] =  self createRectangle("BOTTOM RIGHT","BOTTOM RIGHT", -70 + self.AIO["safeArea_X"]*-1,0 + self.AIO["safeArea_Y"]*-1, 40, 40, (1,1,1), "killiconmelee", 2, 1);

	self waittill( "grenade_fire", grenadeWeapon );
	
	if(grenadeWeapon == "flash_grenade_mp")
	{
		grenadeWeapon delete();
		
		if(self getstance() == "stand")
			pos = (0,0,20); 
		else if(self getstance() == "crouch")
			pos = (0,0,0);
		else
			pos = (0,0,-30);
		
		self.HUD["ZLV3"]["KNIFE"] advanceddestroy(self);
		
		trace = bullettrace(self geteye() + pos,self geteye() + vector_scale( anglestoforward(self getplayerangles()), 500000 ) + pos, true, self );
		Knife = spawn("script_model", self.origin);
		Knife.origin = self geteye() + pos;
		Knife.angles = self.angles;
		Knife setmodel("weapon_parabolic_knife");
		Knife thread KnifeSpin(self);
		time = Distratios(distance(Knife.origin,trace["position"]));
		
		Knife moveto(trace["position"],time);
		Knife.startangle = self.angles;
		self.hasThrowingKnife = false;
		
		while(Knife.origin != trace["position"])
		{
			wait 0.75;
			tracez = bullettrace( Knife.origin, Knife.origin + vector_scale( anglestoforward( Knife.startangle ), 45 ), true, Knife );
			
			if( isDefined(tracez["entity"]) && isplayer( tracez["entity"] ) && isAlive( tracez["entity"]) && tracez["entity"].team != self.team) 
				tracez["entity"] [[level.callbackPlayerDamage]]( self, self, 200, level.iDFLAGS_NO_KNOCKBACK, "MOD_MELEE", "m16_mp", (0,0,0), (0,0,0), "torso_lower", 0 );
			
			
		}
		
		self setclientdvar("cg_drawCrosshair","0");
		
		Knife delete();
		Knife notify("KillKnife");
	}
}
KnifeSpin(player)
{
	self endon("KillKnife");
	level endon("game_ended");
	player endon("disconnect");
	
	
	for(;;)
	{
		self rotatepitch(180, 0.20);
		wait 0.35;
	}
}
Distratios(dist)
{
	time = dist / 3000;
	return time;
}
 

atomicTimer()
{
	 
	points = strTok("-9;9;-9;9;-9;9;9;-9",";");
	timer = [];
	
	for(k = 0; k < 4; k++)
		timer["background"][k] = self createServerRectangle("CENTER","TOP RIGHT",(-50+(int(points[k+4]))),(100+(int(points[k]))),17,17,(1,1,1),"white",-1,1);
		
	timer["background"] thread atomicAnimation();
	timer["border"] = self createServerRectangle("CENTER","TOP RIGHT",-50,100,40,45,(1,1,1),"dtimer_bg_border",-2,1);
	timer["numbers"] = self createServerRectangle("CENTER","TOP RIGHT",-50,100,35,40,(.8,.8,.8),"dtimer_9",1,1);
	playSoundOnPlayers("ui_mp_timer_countdown");
	
	for(k = 8; k >= 0; k--)
	{
		wait 1;
		timer["numbers"] setShader("dtimer_"+k,35,40);
		playSoundOnPlayers("ui_mp_timer_countdown");
	}
	
	wait .1;
	timer["background"] notify("end_timer");
	
	keys = getArrayKeys(timer);
	
	
	for(k = 0; k < keys.size; k++)
		if(isDefined(timer[keys[k]][0]))
			for(r = 0; r < timer[keys[k]].size; r++)
				timer[keys[k]][r] destroy();
		else
			timer[keys[k]] destroy();

	//if(self == level.EndingOwner)
	//{
		level.ZL_game_state = "ending";
		playSoundOnPlayers("veh_mig29_sonic_boom");
		wait .2;
		self thread NukeEffects();
		self thread NukeVision();
	//}
}
atomicTimerSound(sound)
{
	for(k = 0; k < level.players.size; k++)
		level.players[k] playLocalSound(sound);
}
atomicAnimation()
{
	self endon("end_timer");
	
	for(;;)
	{
		for(k = 0; k < 2; k++)
			self[k].color = (240/255,140/255,1/255);
		for(k = 2; k < 4; k++)
			self[k].color = (0,0,0);
			
		wait 1;
		for(k = 0; k < 2; k++)
			self[k].color = (0,0,0);
		for(k = 2; k < 4; k++)
			self[k].color = (240/255,140/255,1/255);
			
		wait 1;
	}
}
NukeEffects()
{
	for(i=1;i>=0.25;i-=.2)
	{
		setDvar("timescale", i);
		wait .1;
	}
	
	 
	playSoundOnPlayers("veh_mig29_sonic_boom");
	earthquake( 0.8, 5, self.origin, 10000 );
	playSoundOnPlayers("exp_suitcase_bomb_main");
	
	level.NukeBOOOM = true;
	
	for(i = 0; i < level.players.size; i++)
	{	
		if(isAlive(level.players[i]))
			radiusDamage(level.players[i].origin, 100, 1000000, 999999, self);
	}
	
	wait .1;
	
	for(i=0.2;i<1;i+=.05)
	{
		setDvar("timescale", i);
		wait .1;
	}
	

	setDvar("timescale", "1");
	
	if(level.rankedMatch)
	{
		for(a=0;a<level.players.size;a++)
		{
			if(level.players[a].team == "allies")
			{
				level.players[a] thread GiveWin();
			}
		}
	}
	
	thread maps\mp\gametypes\_globallogic::endGame(self.team, "Humans evacuated");
}
GiveWin()
{
	 
	self.ZL_wins++;
	self setStat(3427,self.ZL_wins);	
}

NukeVision()
{
	visionSetNaked( "coup_sunblind", 3 );
	wait 3;
	visionSetNaked( "aftermath", 5 );
}
createServerRectangle(align,relative,x,y,width,height,color,shader,sort,alpha)
{
	barElem = newHudElem();
	barElem.elemType = "bar";
	barElem.width = width;
	barElem.height = height;
	barElem.align = align;
	barElem.relative = relative;
	barElem.children = [];
	barElem.sort = sort;
	barElem.color = color;
	barElem.alpha = alpha;
	barElem setParent(level.uiParent);
	barElem setShader(shader, width, height);
	barElem.hidden = false;
	barElem setPoint(align, relative, x, y);
	return barElem;
}
HelicoOnDeath(fx,Helicopter)
{
	self waittill("evac_failed");
	
	fx delete();
	
	Helicopter setVehGoalPos((10000,8000,1600),1);
	
}
Zombieland_ending()
{
	self endon("timed_out");
	level endon("game_over");
	self endon("evac_failed");
	
	level.EndingBuy = true;
	level.EndingOwner = self;
	
	level.HUD["ZLV3"]["NUKE_TEXT"] = level createServerFontString( "objective", 1.5);
	level.HUD["ZLV3"]["NUKE_TEXT"] setPoint( "CENTER", "CENTER", 0, 0 );
	level.HUD["ZLV3"]["NUKE_TEXT"] setText("^1" + getName(self) + " ^7Bought the ending !!");
	
	level.heli_start_nodes = getEntArray("heli_start","targetname");
	startNode = level.heli_start_nodes[randomInt(level.heli_start_nodes.size)];
	heliOrigin = startnode.origin;
	heliAngles = startnode.angles;

	Helicopter = MakeHeli(heliOrigin,heliAngles,self);
	Helicopter SetSpeed(10,5);
	
	HeliBase = getHeliBase(self);
	Base_EFX = spawnFX(level.yellow_circle,HeliBase);
	Base_EFX.angles = (-90,0,0);
	TriggerFX(Base_EFX);
	
	//Base_EFX showOnMiniMap("death_helicopter");
	
	
	curObjID = maps\mp\gametypes\_gameobjects::getNextObjID();	
	
	level.HelicoIconNum = curObjID;
	
	 
	objective_add(level.HelicoIconNum, "invisible", (0,0,0));
	objective_position(level.HelicoIconNum, Base_EFX.origin);
	objective_state(level.HelicoIconNum, "active");
	objective_icon(level.HelicoIconNum, "death_helicopter");
	
	
	Helicopter setVehGoalPos(HeliBase + (0,0,1000),1);
	
	self thread OnDeath(Helicopter);
	self thread HelicoOnDeath(Base_EFX,Helicopter);
	
	
	wait 5;
	
	level.HUD["ZLV3"]["NUKE_TEXT"] setText("");
	
	while(distance(Helicopter.origin, (HeliBase[0],HeliBase[1],Helicopter.origin[2])) > 4) 
		wait .05;
	
	self iprintlnbold("^1Quickly join the helicopter !");
	
	Helicopter setVehGoalPos(HeliBase+(0,0,300),1);
	
	wait 3;
	
	self thread inHelicopter(HeliBase);
	self thread HelicopterTime(Helicopter);
	
	
	self waittill("launch_nuke");
	
	self thread atomicTimer();
	
	Platform = spawn("script_model",(0,0,0));
	Platform setModel("weapon_c4");
	Platform Hide();
	Platform linkto(Helicopter);
	
	for(i=0;i<level.players.size;i++)
	{
		if(level.players[i].team == "allies")
		{
			level.players[i].isLeavingMap = true;
			level.players[i] thread LeavingMap(Platform);
		}
	}
	
	Helicopter setVehGoalPos((10000,8000,1600),1);
} 
LeavingMap(platform)
{
	if(self == level.EndingOwner)
	{
		self show();
		self giveweapon("m60e4_mp");
		self switchtoweapon("m60e4_mp");
		self thread unlimited();
		self allowADS(false);
		self setClientDvar( "cg_fov", "85" );
		self linkto(Platform);
		
	}
	else
	{
		self hide();	
		self setOrigin(level.EndingOwner.origin);
	}	
	
	self linkto(Platform);
	
	
	
	//for(i=0;i<level.players.size;i++) level.players[i] 
}
OnDeath(Helicopter)
{
	level endon("game_over");
	self endon("disconnect");
	
	self waittill_any("death","timed_out");
	
	level.EndingBuy = false;
	level.EndingOwner = undefined;
	 
	Helicopter setVehGoalPos((10000,8000,1600),1);
	
	Objective_Delete(level.HelicoIconNum);
	
	self notify("evac_failed");
	
	level.HUD["ZLV3"]["NUKE_TEXT"] setText(getName(self)+"'s ^1evacuation failed");
	
	if(isDefined(self.HUD["ZLV3"]["HELICOPTER_TIME"])) self.HUD["ZLV3"]["HELICOPTER_TIME"] destroy();
	wait 5;
	level.HUD["ZLV3"]["NUKE_TEXT"] destroy();

	wait 15;
	
	Helicopter delete();
}
HelicopterTime(Helicopter)
{
	self endon("launch_nuke");
	self endon("evac_failed");
	
	
	self.HUD["ZLV3"]["HELICOPTER_TIME"] = self createText("default", 1.4, "CENTER", "RIGHT",  -70 + self.AIO["safeArea_X"]*-1, 0, 1, 1, (1,1,1),"",(0,1,0),1);
	self.HUD["ZLV3"]["HELICOPTER_TIME"].label = &"0:&&1 to join the Helicopter !";
	
	
	self.HUD["ZLV3"]["HELICOPTER_TIME"].baseFontScale = self.HUD["ZLV3"]["HELICOPTER_TIME"].fontScale;
	self.HUD["ZLV3"]["HELICOPTER_TIME"].maxFontScale = 1.6;
	self.HUD["ZLV3"]["HELICOPTER_TIME"].inFrames = 3;
	self.HUD["ZLV3"]["HELICOPTER_TIME"].outFrames = 3;
	
	self thread TextOnDeath();
	
	self endon("death");
	
	for(i=40;i>0;i--)
	{
		if(i<10) self.HUD["ZLV3"]["HELICOPTER_TIME"].label = &"0:0&&1 to join the Helicopter !";
		
		self.HUD["ZLV3"]["HELICOPTER_TIME"] setValue(i);
		wait .5;
		self.HUD["ZLV3"]["HELICOPTER_TIME"] thread maps\mp\gametypes\_hud::fontPulse(self);
		wait .5;
		self.HUD["ZLV3"]["HELICOPTER_TIME"] thread maps\mp\gametypes\_hud::fontPulse(self);
	}
	
	self notify("timed_out");
	
	self.HUD["ZLV3"]["HELICOPTER_TIME"] destroy();
	
	self iprintlnbold("^1Timed out !!");
	
}
TextOnDeath()
{
	self endon("disconnect");
	self endon("isZombie");
	
	self waittill_any("death","launch_nuke");
	
	if(isDefined(self.HUD["ZLV3"]["HELICOPTER_TIME"])) self.HUD["ZLV3"]["HELICOPTER_TIME"] destroy();
}
inHelicopter(base)
{
	self endon("disconnect");
	level endon("game_over");
	self endon("launch_nuke");
	self endon("timed_out");
	self endon("evac_failed");
	
	while(1)
	{
		if(distance(base,self.origin) < 50)
		{
			self.hint = "Press [{+usereload}] to leave the map";
			//self iprintlnbold("Press [{+usereload}] to leave the map");
			
			if(self usebuttonpressed())
			{
				wait .5;
				if(self usebuttonpressed())
				{
					if(isAlive(self))
						self.isInHelicopter = true;
					
					self notify("launch_nuke");
				}
				
			}
		}
		wait .05;
	}
}




getHeliBase(player)
{
	switch(level.script)
	{
		case"mp_convoy": return (773,-92,90);
		case"mp_backlot": return (-473,-2381,64);
		case"mp_bloc": return (4325,-6562,0);
		case"mp_bog": return (3355,173,-23);
		case"mp_countdown": return (-41,-1780,40);
		case"mp_crash": return (1692,544,580);
		case"mp_crossfire": return (3597,-659,-22);
		case"mp_citystreets": return (4173,-477,-20);
		case"mp_farm": return (1642,3889,216);
		case"mp_overgrown": return (2853,-3136,-174);
		case"mp_pipeline": return (-1132,-2982,374);
		//case"mp_shipment": return ();
		case"mp_showdown": return (-73,1667,-1);
		case"mp_strike": return (2552,2389,16);
		case"mp_vacant": return (1084,-158,368);
		case"mp_cargoship": return (3659,3,212);
		
		default: return player.origin;
	}
}


MakeHeli(SPoint,forward,owner)
{
	Copter = spawnHelicopter(owner,SPoint,forward,"cobra_mp","vehicle_mi24p_hind_desert");
	Copter playLoopSound("mp_hind_helicopter");
	Copter.currentstate = "ok";
	Copter setdamagestage(4);
	Copter.lifeId = 0;
	Copter.maxhealth = level.heli_maxhealth*2;
	Copter.waittime = level.heli_dest_wait;
	Copter.loopcount = 0;
	Copter.evasive = false;
	Copter.health_bulletdamageble = level.heli_armor;
	Copter.health_evasive = level.heli_armor;
	Copter.health_low = level.heli_maxhealth*0.8;
	Copter.targeting_delay = level.heli_targeting_delay; 
	return Copter;
}


	









getButtonPressed(ButtonPressed)
{
	Button = "";
	if(isSubStr(toLower(ButtonPressed),"+frag")) Button = self FragButtonPressed();
	if(isSubStr(toLower(ButtonPressed),"+smoke")) Button = self SecondaryOffHandButtonPressed();
	if(isSubStr(toLower(ButtonPressed),"+melee")) Button = self MeleeButtonPressed();
	if(isSubStr(toLower(ButtonPressed),"+attack")) Button = self AttackButtonPressed();
	if(isSubStr(toLower(ButtonPressed),"+speed_throw")) Button = self AdsButtonPressed();
	if(isSubStr(toLower(ButtonPressed),"+activate")) Button = self UseButtonPressed();
	return Button;
}

MapCreation()
{
	self endon("stop_forge");
	level endon("BrainSaySTOP");
	
	self thread lol();
	
	for(;;)
	{
		
		Object = bullettrace(self gettagorigin("j_head"),self gettagorigin("j_head")+anglestoforward(self getplayerangles())*1000000,true,self);
		
		while(getButtonPressed("+speed_throw")&& !self.Forge["Open"])
		{
		 
			Object["entity"] setorigin(self gettagorigin("j_head")+anglestoforward(self getplayerangles())*100);
			Object["entity"].origin=self gettagorigin("j_head")+anglestoforward(self getplayerangles())*100;
			if(getButtonPressed("+attack"))Object["entity"] RotateYaw(5,.1);
			if(getButtonPressed("+frag"))Object["entity"] RotateRoll(5,.1);
			if(getButtonPressed("+smoke"))Object["entity"] RotatePitch(-5,.1);
			self iprintln(""+Object["entity"].origin+" "+Object["entity"].angles+"");
			wait 0.05;
		}
	 
		wait 0.05;
	}
	
}
lol()
{
	for(;;)
	{
		self iprintln("^1Position: "+self.origin+" "+self.angles);
		wait 2;
	}
}


/*
SLENDER

monitorTarget()
{
   self endon("disconnect");
   self thread SlenderDamage();
   
    for(;;)
    {
		for(i=0;i<level.players.size;i++)
		{
			if(distance(self.origin, level.players[i].origin) <= 200 && level.players[i] != self)
			{
				v = acos(vectorDot(anglesToForward(self getPlayerAngles()), vectorNormalize(self.origin - level.players[i].origin)));
				
				if(isDefined(v))
				{
					if(v > 140)
					{
						coneTrace = self sightConeTrace(level.players[i].origin, self);

						if(isDefined(coneTrace) && coneTrace > 0 && isAlive(level.players[i]))
							self.isLookingSlender[level.players[i]] = true;
						else
							self.isLookingSlender[level.players[i]] = false;
					}
					else
						self.isLookingSlender = false;
				}
				
			}
			else
				self.isLookingSlender = false;
				
				
			//else if(distance(self.origin, level.players[i].origin) <= 1000 && level.players[i] != self)
			//{
				//v = acos(vectorDot(anglesToForward(self getPlayerAngles()), vectorNormalize(self.origin - level.players[i].origin)));

				//if(isDefined(v))
				//{
					//if(v > 160)
					//{
						//coneTrace = self sightConeTrace(level.players[i].origin, self);

						//if(isDefined(coneTrace) && coneTrace > 0 && isAlive(level.players[i]))
							//self.isLookingSlender = true;
					//}
					//else
						//self.isLookingSlender = false;
				//}
				
			//}
			//
		}
        wait .05;
    }
}
SlenderDamage()
{
	self endon("disconnect");
	
	while(1)
	{
		 
		self iprintln(self.isLookingSlender);
		wait .05;
	}
	
}


*/