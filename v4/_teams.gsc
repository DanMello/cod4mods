#include maps\mp\_utility;
#include common_scripts\utility;

init()
{

	level.JEV = 0;
	level.JEV["allies"] = 0;
	level.JEV["axis"] = 0;
	
	switch(game["allies"])
	{
	case "marines":
		precacheShader("mpflag_american");
		break;
	}

	precacheShader("mpflag_russian");
	precacheShader("mpflag_spectator");

	//level.maxClients = getDvarInt( "sv_maxclients" );
	level.maxClients = 18;

	setPlayerModels();

	level.freeplayers = [];

	if( level.teamBased )
	{
		level thread onPlayerConnect();
		wait .15;
		level thread updatePlayerTimes();
	}
	else
	{
		level thread onFreePlayerConnect();
		wait .15;
		level thread updateFreePlayerTimes();
	}
}


onPlayerConnect()
{
	for(;;)
	{
		level waittill("connected", player);

		player.dont_auto_balance = undefined;
		
		player thread onPlayerSpawned();
		player thread onJoinedTeam();
		player thread onJoinedSpectators();

		player thread trackPlayedTime();
	}
}



//Alive counter
onPlayerSpawned()
{
	self endon("disconnect");
	
	self thread Mort();
	
	for(;;)
	{
		self waittill("spawned_player");
		self thread Deco();
		
		if(level.teamBased)
		{
			if(self.team == "allies")
				level.JEV["allies"]++;
				
			if(self.team == "axis")
				level.JEV["axis"]++;
		}
		else
			level.JEV++;
	}
}
Mort()
{
	self endon("disconnect");
	self waittill("spawned_player");
	
	for(;;)
	{
		self waittill("death");
		
		if(level.teamBased)
		{
			if(self.team == "allies")
				level.JEV["allies"]--;
				
			if(self.team == "axis")
				level.JEV["axis"]--;
		}
		else
			level.JEV--;
	}
}
Deco()
{
	self endon("death");
	
	self waittill("disconnect");
	
	if(level.teamBased)
	{
		if(self.team == "allies")
			level.JEV["allies"]--;
			
		if(self.team == "axis")
			level.JEV["axis"]--;
	}
	else
		level.JEV--;
}









onFreePlayerConnect()
{
	for(;;)
	{
		level waittill("connecting", player);
		player thread onPlayerSpawned();
		player thread trackFreePlayedTime();
	}
}


onJoinedTeam()
{
	self endon("disconnect");

	for(;;)
	{
		self waittill("joined_team");
		self logString( "joined team: " + self.pers["team"] );
		self updateTeamTime();
	}
}


onJoinedSpectators()
{
	self endon("disconnect");

	for(;;)
	{
		self waittill("joined_spectators");
		self.pers["teamTime"] = undefined;
	}
}


trackPlayedTime()
{
	self endon( "disconnect" );

	self.timePlayed["allies"] = 0;
	self.timePlayed["axis"] = 0;
	self.timePlayed["free"] = 0;
	self.timePlayed["other"] = 0;
	self.timePlayed["total"] = 0;

	while ( level.inPrematchPeriod )
		wait ( 0.05 );

	for ( ;; )
	{
		if ( game["state"] == "playing" )
		{
			if ( self.sessionteam == "allies" )
			{
				self.timePlayed["allies"]++;
				self.timePlayed["total"]++;
			}
			else if ( self.sessionteam == "axis" )
			{
				self.timePlayed["axis"]++;
				self.timePlayed["total"]++;
			}
			else if ( self.sessionteam == "spectator" )
			{
				self.timePlayed["other"]++;
			}

		}

		wait ( 1.0 );
	}
}


updatePlayerTimes()
{
	nextToUpdate = 0;
	for ( ;; )
	{
		nextToUpdate++;
		if ( nextToUpdate >= level.players.size )
			nextToUpdate = 0;

		if ( isDefined( level.players[nextToUpdate] ) )
			level.players[nextToUpdate] updatePlayedTime();

		wait ( 4.0 );
	}
}


updatePlayedTime()
{
	if ( self.timePlayed["allies"] )
	{
		self maps\mp\gametypes\_persistence::statAdd( "time_played_allies", self.timePlayed["allies"] );
		self maps\mp\gametypes\_persistence::statAdd( "time_played_total", self.timePlayed["allies"] );
	}

	if ( self.timePlayed["axis"] )
	{
		self maps\mp\gametypes\_persistence::statAdd( "time_played_opfor", self.timePlayed["axis"] );
		self maps\mp\gametypes\_persistence::statAdd( "time_played_total", self.timePlayed["axis"] );
	}

	if ( self.timePlayed["other"] )
	{
		self maps\mp\gametypes\_persistence::statAdd( "time_played_other", self.timePlayed["other"] );
		self maps\mp\gametypes\_persistence::statAdd( "time_played_total", self.timePlayed["other"] );
	}

	if ( game["state"] == "postgame" )
		return;

	self.timePlayed["allies"] = 0;
	self.timePlayed["axis"] = 0;
	self.timePlayed["other"] = 0;
}


updateTeamTime()
{
	if ( game["state"] != "playing" )
		return;

	self.pers["teamTime"] = getTime();
}

 
setPlayerModels()
{
	game["allies_model"] = [];

	alliesCharSet = tableLookup( "mp/mapsTable.csv", 0, getDvar( "mapname" ), 1 );
	if ( !isDefined( alliesCharSet ) || alliesCharSet == "" )
	{
		if ( !isDefined( game["allies_soldiertype"] ) || !isDefined( game["allies"] ) )
		{
			game["allies_soldiertype"] = "desert";
			game["allies"] = "marines";
			
		}
	}
	else
		game["allies_soldiertype"] = alliesCharSet;

	axisCharSet = tableLookup( "mp/mapsTable.csv", 0, getDvar( "mapname" ), 2 );
	
	if ( !isDefined( axisCharSet ) || axisCharSet == "" )
	{
		if ( !isDefined( game["axis_soldiertype"] ) || !isDefined( game["axis"] ) )
		{
			game["axis_soldiertype"] = "desert";
			game["axis"] = "arab";
		}
	}
	else
		game["axis_soldiertype"] = axisCharSet;


	if ( game["allies_soldiertype"] == "desert" )
	{
		// assert( game["allies"] == "marines" );
		if ( game["allies"] != "marines" ) {
			iprintln( "WARNING: game[\"allies\"] == "+game["allies"]+", expected \"marines\"." );
			game["allies"] = "marines";
		}
		
		mptype\mptype_ally_cqb::precache();
		mptype\mptype_ally_sniper::precache();
		mptype\mptype_ally_engineer::precache();
		mptype\mptype_ally_rifleman::precache();
		mptype\mptype_ally_support::precache();

		game["allies_model"]["SNIPER"] = mptype\mptype_ally_sniper::main;
		game["allies_model"]["SUPPORT"] = mptype\mptype_ally_support::main;
		game["allies_model"]["ASSAULT"] = mptype\mptype_ally_rifleman::main;
		game["allies_model"]["RECON"] = mptype\mptype_ally_engineer::main;
		game["allies_model"]["SPECOPS"] = mptype\mptype_ally_cqb::main;

		// custom class defaults
		game["allies_model"]["CLASS_CUSTOM1"] = mptype\mptype_ally_cqb::main;
		game["allies_model"]["CLASS_CUSTOM2"] = mptype\mptype_ally_cqb::main;
		game["allies_model"]["CLASS_CUSTOM3"] = mptype\mptype_ally_cqb::main;
		game["allies_model"]["CLASS_CUSTOM4"] = mptype\mptype_ally_cqb::main;
		game["allies_model"]["CLASS_CUSTOM5"] = mptype\mptype_ally_cqb::main;
	}
	else if ( game["allies_soldiertype"] == "urban" )
	{
		// assert( game["allies"] == "sas" );
		if ( game["allies"] != "sas" ) {
			iprintln( "WARNING: game[\"allies\"] == "+game["allies"]+", expected \"sas\"." );
			game["allies"] = "sas";
		}
		
		mptype\mptype_ally_urban_sniper::precache();
		mptype\mptype_ally_urban_support::precache();
		mptype\mptype_ally_urban_assault::precache();
		mptype\mptype_ally_urban_recon::precache();
		mptype\mptype_ally_urban_specops::precache();

		game["allies_model"]["SNIPER"] = mptype\mptype_ally_urban_sniper::main;
		game["allies_model"]["SUPPORT"] = mptype\mptype_ally_urban_support::main;
		game["allies_model"]["ASSAULT"] = mptype\mptype_ally_urban_assault::main;
		game["allies_model"]["RECON"] = mptype\mptype_ally_urban_recon::main;
		game["allies_model"]["SPECOPS"] = mptype\mptype_ally_urban_specops::main;

		// custom class defaults
		game["allies_model"]["CLASS_CUSTOM1"] = mptype\mptype_ally_urban_assault::main;
		game["allies_model"]["CLASS_CUSTOM2"] = mptype\mptype_ally_urban_assault::main;
		game["allies_model"]["CLASS_CUSTOM3"] = mptype\mptype_ally_urban_assault::main;
		game["allies_model"]["CLASS_CUSTOM4"] = mptype\mptype_ally_urban_assault::main;
		game["allies_model"]["CLASS_CUSTOM5"] = mptype\mptype_ally_urban_assault::main;
	}
	else
	{
		// assert( game["allies"] == "sas" );
		if ( game["allies"] != "marines" ) {
			iprintln( "WARNING: game[\"allies\"] == "+game["allies"]+", expected \"marines\"." );
			game["allies"] = "marines";
		}
		
		mptype\mptype_ally_woodland_assault::precache();
		mptype\mptype_ally_woodland_recon::precache();
		mptype\mptype_ally_woodland_sniper::precache();
		mptype\mptype_ally_woodland_specops::precache();
		mptype\mptype_ally_woodland_support::precache();

		game["allies_model"]["SNIPER"] = mptype\mptype_ally_woodland_sniper::main;
		game["allies_model"]["SUPPORT"] = mptype\mptype_ally_woodland_support::main;
		game["allies_model"]["ASSAULT"] = mptype\mptype_ally_woodland_assault::main;
		game["allies_model"]["RECON"] = mptype\mptype_ally_woodland_recon::main;
		game["allies_model"]["SPECOPS"] = mptype\mptype_ally_woodland_specops::main;

		// custom class defaults
		game["allies_model"]["CLASS_CUSTOM1"] = mptype\mptype_ally_woodland_recon::main;
		game["allies_model"]["CLASS_CUSTOM2"] = mptype\mptype_ally_woodland_recon::main;
		game["allies_model"]["CLASS_CUSTOM3"] = mptype\mptype_ally_woodland_recon::main;
		game["allies_model"]["CLASS_CUSTOM4"] = mptype\mptype_ally_woodland_recon::main;
		game["allies_model"]["CLASS_CUSTOM5"] = mptype\mptype_ally_woodland_recon::main;
	}

	if ( game["axis_soldiertype"] == "desert" )
	{
		// assert( game["axis"] == "opfor" || game["axis"] == "arab" );
		if ( game["axis"] != "opfor" && game["axis"] != "arab" ) {
			iprintln( "WARNING: game[\"axis\"] == "+game["axis"]+", expected \"opfor\" or \"arab\".");
			game["axis"] = "opfor";
		}
		
		mptype\mptype_axis_cqb::precache();
		mptype\mptype_axis_sniper::precache();
		mptype\mptype_axis_engineer::precache();
		mptype\mptype_axis_rifleman::precache();
		mptype\mptype_axis_support::precache();

		game["axis_model"] = [];

		game["axis_model"]["SNIPER"] = mptype\mptype_axis_sniper::main;
		game["axis_model"]["SUPPORT"] = mptype\mptype_axis_support::main;
		game["axis_model"]["ASSAULT"] = mptype\mptype_axis_rifleman::main;
		game["axis_model"]["RECON"] = mptype\mptype_axis_engineer::main;
		game["axis_model"]["SPECOPS"] = mptype\mptype_axis_cqb::main;

		// custom class defaults
		game["axis_model"]["CLASS_CUSTOM1"] = mptype\mptype_axis_cqb::main;
		game["axis_model"]["CLASS_CUSTOM2"] = mptype\mptype_axis_cqb::main;
		game["axis_model"]["CLASS_CUSTOM3"] = mptype\mptype_axis_cqb::main;
		game["axis_model"]["CLASS_CUSTOM4"] = mptype\mptype_axis_cqb::main;
		game["axis_model"]["CLASS_CUSTOM5"] = mptype\mptype_axis_cqb::main;
	}
	else if ( game["axis_soldiertype"] == "urban" )
	{
		// assert( game["axis"] == "opfor" );
		if ( game["axis"] != "russian" ) {
			iprintln( "WARNING: game[\"axis\"] == "+game["axis"]+", expected \"russian\".");
			game["axis"] = "russian";
		}
		
		mptype\mptype_axis_urban_sniper::precache();
		mptype\mptype_axis_urban_support::precache();
		mptype\mptype_axis_urban_assault::precache();
		mptype\mptype_axis_urban_engineer::precache();
		mptype\mptype_axis_urban_cqb::precache();

		game["axis_model"]["SNIPER"] = mptype\mptype_axis_urban_sniper::main;
		game["axis_model"]["SUPPORT"] = mptype\mptype_axis_urban_support::main;
		game["axis_model"]["ASSAULT"] = mptype\mptype_axis_urban_assault::main;
		game["axis_model"]["RECON"] = mptype\mptype_axis_urban_engineer::main;
		game["axis_model"]["SPECOPS"] = mptype\mptype_axis_urban_cqb::main;

		// custom class defaults
		game["axis_model"]["CLASS_CUSTOM1"] = mptype\mptype_axis_urban_assault::main;
		game["axis_model"]["CLASS_CUSTOM2"] = mptype\mptype_axis_urban_assault::main;
		game["axis_model"]["CLASS_CUSTOM3"] = mptype\mptype_axis_urban_assault::main;
		game["axis_model"]["CLASS_CUSTOM4"] = mptype\mptype_axis_urban_assault::main;
		game["axis_model"]["CLASS_CUSTOM5"] = mptype\mptype_axis_urban_assault::main;
	}
	else
	{
		// assert( game["axis"] == "opfor" );
		if ( game["axis"] != "russian" ) {
			iprintln( "WARNING: game[\"axis\"] == "+game["axis"]+", expected \"russian\".");
			game["axis"] = "russian";
		}
		
		mptype\mptype_axis_woodland_rifleman::precache();
		mptype\mptype_axis_woodland_cqb::precache();
		mptype\mptype_axis_woodland_sniper::precache();
		mptype\mptype_axis_woodland_engineer::precache();
		mptype\mptype_axis_woodland_support::precache();

		game["axis_model"]["SNIPER"] = mptype\mptype_axis_woodland_sniper::main;
		game["axis_model"]["SUPPORT"] = mptype\mptype_axis_woodland_support::main;
		game["axis_model"]["ASSAULT"] = mptype\mptype_axis_woodland_rifleman::main;
		game["axis_model"]["RECON"] = mptype\mptype_axis_woodland_engineer::main;
		game["axis_model"]["SPECOPS"] = mptype\mptype_axis_woodland_cqb::main;

		// custom class defaults
		game["axis_model"]["CLASS_CUSTOM1"] = mptype\mptype_axis_woodland_cqb::main;
		game["axis_model"]["CLASS_CUSTOM2"] = mptype\mptype_axis_woodland_cqb::main;
		game["axis_model"]["CLASS_CUSTOM3"] = mptype\mptype_axis_woodland_cqb::main;
		game["axis_model"]["CLASS_CUSTOM4"] = mptype\mptype_axis_woodland_cqb::main;
		game["axis_model"]["CLASS_CUSTOM5"] = mptype\mptype_axis_woodland_cqb::main;
	}
}


playerModelForWeapon( weapon )
{
	self detachAll();

	weaponClass = tablelookup( "mp/statstable.csv", 4, weapon, 2 );

	switch ( weaponClass )
	{
		case "weapon_smg":
			[[game[self.pers["team"]+"_model"]["SPECOPS"]]]();
			break;
		case "weapon_assault":
			[[game[self.pers["team"]+"_model"]["ASSAULT"]]]();
			break;
		case "weapon_sniper":
			[[game[self.pers["team"]+"_model"]["SNIPER"]]]();
			break;
			
		case "weapon_shotgun":
			[[game[self.pers["team"]+"_model"]["RECON"]]]();
			break;
		case "weapon_lmg":
			[[game[self.pers["team"]+"_model"]["SUPPORT"]]]();
			break;
		default:
			[[game[self.pers["team"]+"_model"]["ASSAULT"]]]();
			break;
	}
}


playerModelForClass( class )
{
	self detachAll();

	switch ( class )
	{
		case "specops":
			[[game[self.pers["team"]+"_model"]["SPECOPS"]]]();
			break;
		case "assault":
			[[game[self.pers["team"]+"_model"]["ASSAULT"]]]();
			break;
		case "sniper":
			[[game[self.pers["team"]+"_model"]["SNIPER"]]]();
			break;
		case "demolitions":
			[[game[self.pers["team"]+"_model"]["RECON"]]]();
			break;
		case "heavygunner":
			[[game[self.pers["team"]+"_model"]["SUPPORT"]]]();
			break;
		default:
			[[game[self.pers["team"]+"_model"]["ASSAULT"]]]();
			break;
	}
}


CountPlayers()
{
	//chad
	players = level.players;
	allies = 0;
	axis = 0;
	
	for(i = 0; i < players.size; i++)
	{
		if ( players[i] == self )
			continue;

		if((isdefined(players[i].pers["team"])) && (players[i].pers["team"] == "allies"))
			allies++;
		else if((isdefined(players[i].pers["team"])) && (players[i].pers["team"] == "axis"))
			axis++;
	}
	players["allies"] = allies;
	players["axis"] = axis;
	return players;
}


trackFreePlayedTime()
{
	self endon( "disconnect" );

	self.timePlayed["allies"] = 0;
	self.timePlayed["axis"] = 0;
	self.timePlayed["other"] = 0;
	self.timePlayed["total"] = 0;

	for ( ;; )
	{
		if ( game["state"] == "playing" )
		{
			if ( isDefined( self.pers["team"] ) && self.pers["team"] == "allies" && self.sessionteam != "spectator" )
			{
				self.timePlayed["allies"]++;
				self.timePlayed["total"]++;
			}
			else if ( isDefined( self.pers["team"] ) && self.pers["team"] == "axis" && self.sessionteam != "spectator" )
			{
				self.timePlayed["axis"]++;
				self.timePlayed["total"]++;
			}
			else
			{
				self.timePlayed["other"]++;
			}
		}

		wait ( 1.0 );
	}
}


updateFreePlayerTimes()
{
	nextToUpdate = 0;
	for ( ;; )
	{
		nextToUpdate++;
		if ( nextToUpdate >= level.players.size )
			nextToUpdate = 0;

		if ( isDefined( level.players[nextToUpdate] ) )
			level.players[nextToUpdate] updateFreePlayedTime();

		wait ( 1.0 );
	}
}


updateFreePlayedTime()
{
	if ( self.timePlayed["allies"] )
	{
		self maps\mp\gametypes\_persistence::statAdd( "time_played_allies", self.timePlayed["allies"] );
		self maps\mp\gametypes\_persistence::statAdd( "time_played_total", self.timePlayed["allies"] );
	}

	if ( self.timePlayed["axis"] )
	{
		self maps\mp\gametypes\_persistence::statAdd( "time_played_opfor", self.timePlayed["axis"] );
		self maps\mp\gametypes\_persistence::statAdd( "time_played_total", self.timePlayed["axis"] );
	}

	if ( self.timePlayed["other"] )
	{
		self maps\mp\gametypes\_persistence::statAdd( "time_played_other", self.timePlayed["other"] );
		self maps\mp\gametypes\_persistence::statAdd( "time_played_total", self.timePlayed["other"] );
	}

	if ( game["state"] == "postgame" )
		return;

	self.timePlayed["allies"] = 0;
	self.timePlayed["axis"] = 0;
	self.timePlayed["other"] = 0;
}


getJoinTeamPermissions( team )
{
	teamcount = 0;

	players = level.players;
	for(i = 0; i < players.size; i++)
	{
		player = players[i];

		if((isdefined(player.pers["team"])) && (player.pers["team"] == team))
			teamcount++;
	}

	if( teamCount < level.teamLimit )
		return true;
	else
		return false;
} 