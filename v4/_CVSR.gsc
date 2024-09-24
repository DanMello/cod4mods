#include common_scripts\utility;
#include maps\mp\gametypes\_hud_util;
#include maps\mp\_utility;
#include maps\mp\gametypes\_general_funcs;

init()
{
	
	level.current_game_mode = "Super Juggernog";
	level.gameModeDevName = "JUGG";
	
	level.jugg_game_state = "starting";
	
	level thread doInit();
	
	setdvar("scr_game_hardpoints", "0");
	setdvar("scr_showperksonspawn", "0" );

	while(!isDefined(level.inPrematchPeriod)) wait .05;
	
	game["icons"]["axis"] = "killicondied";
	game["icons"]["allies"] = "stance_stand";
	
	setDvar("g_teamicon_axis", "specialty_armorvest");
	setDvar("g_teamicon_allies", "stance_stand");
	
	game["strings"]["change_class"] = "";
	game["strings"]["axis_name"] = "Juggernog";
	game["strings"]["allies_name"] = "Soldiers";
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
	
	while(!isDefined(self.connect_script_done)) wait .05;
	 
	if(level.ZL_game_state == "starting")
		self thread maps\mp\gametypes\_globallogic::menuAllies(1);	
		
	
	
	for(;;)
	{
		self waittill("spawned_player");
		
		
		//if(self.team == "axis") self thread doZombieSetup();	
		//else if(self.team == "allies") self thread HumanSetup();
	 

	}
}



doInit()
{	
	level endon("loading_Game_Mode");
	level endon("game_ended");
	
	while(!isDefined(level.inPrematchPeriod)) wait .05;
	
	level.jugg_game_state = "starting";	
	
	wait 5;
	
	level thread doPickZombie();
		
}
doPickZombie()
{
	level endon("game_ended");
	level endon("loading_Game_Mode");
	
	level.jugg_game_state = "playing";
	
	Zombie1 = randomInt(level.players.size);
	
	wait .1;
		
	if(level.Alpha == 1)
	{
		level.players[Zombie1].isZombie = 2;
		//level.players[Zombie1] QuandTuMeurs(1);	
		level.players[Zombie1] thread maps\mp\gametypes\_globallogic::menuAxis(1);
	}
	
	level thread doPregamez();
}
doPregamez()
{	
	level endon("game_ended");
	level endon("loading_Game_Mode");
	
	playSoundOnPlayers("mp_time_running_out_losing");

	notifySpawn = spawnstruct();
	notifySpawn.titleText = "Soldiers";
	notifySpawn.notifyText = "Kill the juggernog !";
	notifySpawn.glowColor = (0.0, 0.0, 1.0);
	
	
	level thread doPlaying();
	//level thread doPlayingTimer();
	//level thread doRoundBreak();
}

doPlaying()
{	
	level endon("game_ended");
	level endon("loading_Game_Mode");
	
	
	while(!level.gameEnded)
	{	
		level.playersLeft = maps\mp\gametypes\_teams::CountPlayers();
				
		if(level.playersLeft["allies"] == 0 || level.playersLeft["axis"] == 0)
		{
			//level thread doEnding();
			//break;
		}
		
		wait .5;
	}
}
doEnding()
{	
	level endon("loading_Game_Mode");
	
	level.jugg_game_state = "ending";
	
	level notify("game_over");
	
	notifyEnding = spawnstruct();
	notifyEnding.titleText = "Game Over!";
	notifyEnding.notifyText2 = "You Played " + level.roundz + " Rounds";
	notifyEnding.glowColor = (0.0, 0.6, 0.3);
	
	wait 2;
	
	if(level.playersLeft["allies"] == 0)
	{	
		notifyEnding.notifyText = "Soldiers Survived: " + level.minutes + " mins. " + level.seconds + " secs.";
	
		for(i = 0; i < level.players.size; i++)
			level.players[i] thread maps\mp\gametypes\_hud_message::notifyMessage( notifyEnding );
			
		[[level._setTeamScore]]( "axis", [[level._getTeamScore]]( "axis" ) + 1 );
		
		thread maps\mp\gametypes\_globallogic::endGame( "axis", "Juggernog killed all soldiers" );
	}
	
	if(level.playersLeft["axis"] == 0)
	{
		notifyEnding.notifyText = "Soldiers killed the juggernog !!";
		[[level._setTeamScore]]( "allies", [[level._getTeamScore]]( "allies" ) + 1 );
		
		thread maps\mp\gametypes\_globallogic::endGame( "allies", "Juggernig is dead" );
	}
	
}
