#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include maps\mp\gametypes\_general_funcs;


init()
{
	if(level.utilise_AIO_en_ligne && level.console)
		return;
		
	level thread initMM();
	level thread onPlayerConnect();
	level.hardcoreMode = true;
	level.zerotue = true;
	level.MikeHasBeenChosen = false;
	level.endGameOnScoreLimit = false;
	 
	level.current_game_mode = "Mike Myers";
	level.gameModeDevName = "MM";
 
	level.game_state = "starting";
	
	setDvar("jump_slowdownEnable","0");
	setDvar("jump_height","64");
	setDvar("g_gametype", "war");
	setDvar("scr_game_hardpoints", "0");
	setdvar("scr_showperksonspawn", "0");
		
	precacheShader("killiconmelee");
	precacheShader("stance_stand");
	
	level deletePlacedEntity("misc_turret");
	
	while(!isDefined(level.inPrematchPeriod)) wait .05;
	
	game["strings"]["change_class"] = "";
	game["strings"]["axis_name"] = "";
	game["strings"]["allies_name"] = "";
	game["dialog"]["gametype"] = undefined;
	game["music"]["spawn_axis"] = undefined;
	game["music"]["spawn_allies"] = undefined;
	game["icons"]["axis"] = "killiconmelee";
	game["icons"]["allies"] = "stance_stand";
	
	setDvar("g_teamname_axis","^1Mike Myers");
	setDvar("g_teamname_allies","^3Survivors");
	setDvar("g_ScoresColor_Allies","0.949 1 0.633 1");
	setDvar("g_ScoresColor_axis","1 0.492 0.492 1");
	setDvar("g_ScoresColor_Spectator","0.492 0.492 0.492 1");
	setDvar("g_ScoresColor_Free","0.492 0.492 0.492 1");
	setDvar("cg_scoreBoardMyColor","0 0 0 1");
	setDvar("g_teamicon_axis", "killiconmelee");
	setDvar("g_teamicon_allies", "stance_stand");
}

onPlayerConnect()
{
	for(;;)
	{
		level waittill( "connected", player );
		
		player.isMike = 0;
		player thread onPlayerSpawned();
	}
}

onPlayerSpawned()
{
	self endon("disconnect");

	while(!isDefined(self.connect_script_done)) wait .05;

	 
	if(level.game_state != "starting")
	{
		self thread maps\mp\gametypes\_globallogic::menuSpectator();
		self.isMike = 3;
	}
	else self thread maps\mp\gametypes\_globallogic::menuAllies(1);	
	

	for(;;)
	{
		self waittill("spawned_player");
		
		if(self.isMike == 1) 
			self thread doMike();
		else
			self thread doSurvivor();
	}
}
initMM()
{	
	level endon("game_ended");
	
	level.MikeSpawned = 0;
	level.game_state = "";
	level.lastAlive = 0;
	
	wait 1;
	
	if(!isDefined(level.SurvivorsAlive))
		level.SurvivorsAlive = 0;
		
	level.game_state = "starting";
	
	wait 20;
	
	FirstSurvivorKilled = getdvar("NextMike");

	for(i=0;i<level.players.size;i++)
	{
		if(getName(level.players[i]) == FirstSurvivorKilled)
		{
			level.MikeHasBeenChosen = true;
	 
			level.players[i].isMike = 1;
			level.players[i] thread maps\mp\gametypes\_globallogic::menuAxis(1);	
			 
			level.SurvivorsAlive--;
			
			setDvar("NextMike","");
			
			iprintln(getName(level.players[i])+" has been the first ^1killed. ^7He's now ^1the Mike Myers");
		}
	}
	
	if(level.MikeHasBeenChosen)
		level thread PreGame();
	else
		level thread PickAMike();
}

PickAMike()
{
	level endon("game_ended");
	
	for(;;)
	{
		Mike = randomInt(level.players.size); 
		wait .05;
		
		if(!isAlive(level.players[Mike]))
			iprintln("^1not alive");
		else
			break;
	}
	level.players[Mike].isMike = 1;
	level.players[Mike] thread maps\mp\gametypes\_globallogic::menuAxis(1);	
	level.SurvivorsAlive--;
	level thread PreGame();	
}
PreGame()
{
	playSoundOnPlayers("mp_time_running_out_losing");
	
	level.TimerText = level createServerFontString("objective", 1.5);
	level.TimerText setPoint( "CENTER", "CENTER", 0, -100 );
	level.timerText setText("^1Mike is Coming... HIDE !!!");
	
	for(i=0;i<level.players.size;i++)
		if(level.players[i].team == "allies")
			level.players[i].isMike = 3;
				
				
	level playsound("mp_war_objective_lost");
	level.game_state = "playing";
	wait 1;
	level thread doPlaying();
}

doPlaying()
{
	level.TimerText destroy();
	
	while(1)
	{
		level.playersLeft = maps\mp\gametypes\_teams::CountPlayers();
		
		if(!level.lastAlive)
		{
			if(level.playersLeft["allies"] == 1)
			{
				level.lastAlive = 1;
				
				for(i=0;i<level.players.size;i++)
				{
					if(level.players[i].team == "allies")
						level.players[i] thread LastSurvivor();
						
					if(level.players[i].team == "axis")
						level.players[i] notify("lastlive");
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

LastSurvivor() 
{
	self iPrintlnBold("^1You are the last alive!..");
	self.hasRadar = true;
	setDvar( "ui_uav_allies", 1 );
	wait 1;
	self iprintlnbold("^1Go Kill Mike !! ..");
}
doEnding()
{
	level.game_state = "ending";
	
	if(level.lastAlive && level.playersLeft["axis"] == 0)
		thread maps\mp\gametypes\_globallogic::endGame( "allies", "Survivor killed Mike !" );
		
	else
	{
		if(level.playersLeft["axis"] == 0 && level.playersLeft["allies"] >= 1)
		{
			level endon("game_ended");
			level.counter = 10;
			level.MikeSpawned = 0;
			level.SurvivorsAlive = 0;
			level.game_state = "starting";
			
			for(i=0;i<level.players.size;i++)
			{
				level.players[i].isMike = 0;
				if(level.players[i].team != "allies") 
					level.players[i] thread maps\mp\gametypes\_globallogic::menuAllies(1);	
			}
			while(level.counter > 0)
			{	
				if(!isDefined(level.TimerText))
					level.TimerText = level createServerFontString( "objective", 1.5 );
				
				level.TimerText setPoint( "CENTER", "CENTER", 0, -100 );
				level.TimerText.label = &"^1Mike left the game, Picking a new Mike in: ";
				level.TimerText setValue(level.counter);
				wait 1;
				level.counter--;
			}
			
			if(isDefined(level.TimerText)) 	level.TimerText destroy();
		
			wait 1;
			level thread PickAMike();
		}
		if(level.playersLeft["allies"] == 0 && level.playersLeft["axis"] == 0)
			thread maps\mp\gametypes\_globallogic::endGame( "", "No player in the game" );
			
		if(level.playersLeft["allies"] == 0 && level.playersLeft["axis"] == 1)
			thread maps\mp\gametypes\_globallogic::endGame( "axis", "Michael Killed All Survivors" );
	}
}
doSurvivor()  
{
	self setMoveSpeedScale(1.0);
	self setclientdvar("player_sprintUnlimited","1");
	self thread doDvars();
	
	if(!self.deja)
	{
		//self thread ShowGametypeMM();
		//self thread MMHud();
		//self thread TeamCheckm();
		self.deja = 1;	
	}
	
	if(!self.IN_MENU["AIO"] && !self.IN_MENU["RANK"])
		self freezeControls(false);
}
doMike() 
{
	self.hasRadar = true;
	setDvar( "ui_uav_axis", 1 );
	self setclientdvar("player_sprintUnlimited","1");
	self setMoveSpeedScale(1.0);
	self thread ondeath();
	self playsound("mp_war_objective_taken");
	
	if(!self.IN_MENU["AIO"] && !self.IN_MENU["RANK"])
		self freezeControls(false);
	
	self thread doDvars();
	level.MikeSpawned = true;
	notifySpawn = spawnstruct();
	notifySpawn.titleText = "^1You are Mike Myers";
	notifySpawn.notifyText = "^1Kill Them ALL !!";
	notifySpawn.glowColor = (1,0,0);
	self thread maps\mp\gametypes\_hud_message::notifyMessage(notifySpawn);
}
   

doDvars()
{
	self setClientDvar( "bg_fallDamageMinHeight", "9999" );
	self setClientDvar( "bg_fallDamageMaxHeight", "9999" );
	self setClientDvar("aim_automelee_range", 92);
	self setClientDvar( "cg_drawCrosshairNames", 1);
	self setClientDvar( "cg_drawCrosshair", 1);
	self setClientDvar( "cg_everyoneHearsEveryone", 1);
}


TeamCheckm()
{
	self endon("disconnect");
	self endon("stopcheck");
	
	if(self.team == "allies")
	{
		level.SurvivorsAlive++;
		self thread SurvivorsAliveCheck();
		self thread SurvivorsAliveCheckdis();
	}	
		 
}
OnDeath()
{
	self waittill("lastlive");
	self iprintln("^1It's your last life !");
	self waittill("death");
	self thread maps\mp\gametypes\_globallogic::menuSpectator();	
}

 
SurvivorsAliveCheck()
{
	self endon("disconnect");
	 	
	while(level.game_state != "playing")
			wait 1;

	if(self.team == "allies")
	{
		self waittill("death");
		level.SurvivorsAlive--;		 
	}
}
SurvivorsAliveCheckdis()
{
	self endon("death");
	self endon("immike");
	
	while(level.game_state != "playing")
			wait 1;

	if(self.team == "allies")
	{
		 
		self waittill("disconnect");
		level.SurvivorsAlive--;
			 
	}
}
 
ShowGametypeMM()
{
	 
}
RemoveHudDeathMM()
{
 
}
IconBarsMM()
{
	 
}
MMHud()
{
	 
}
 