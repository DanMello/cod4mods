#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include maps\mp\gametypes\_general_funcs;

main()
{
	//if(getdvar("CJ_GAMETYPE") == "SD") maps\mp\gametypes\sd::main();
	//else if(getdvar("CJ_GAMETYPE") == "SAB") maps\mp\gametypes\sab::main();
	
	
	if(g("SD") || g("HNS") || g("CS") || g("AVP") || g("PROMOD_SD") || g("FTB") || g("cachecache") || g("CVSR") || (g("RGM_SD") && g("RGM")))
		maps\mp\gametypes\sd::main();
	else if(g("TDM")  || g("RGM") || g("ZLV5") || g("CJ") || g("ZLV3") || g("MW3") || g("MM") || g("NM") || g("SSC") || g("toBet") || g("INF") || g("RGM") || g("GON") || g("CONFIRMED") || g("FUNNYZOMB"))
		maps\mp\gametypes\war::main();
	else if(g("SAB" || g("DVSU")))
		maps\mp\gametypes\sab::main();
	else if(g("HQ"))
		maps\mp\gametypes\koth::main(); 
	else if(g("DOM"))
		maps\mp\gametypes\dom::main();
	else
	{
		setdvar("g_gametype","dm");
		setdvar("party_gametype","dm");
		setdvar("ui_gametype","dm");
		
		if(g("FFA"))
		level.current_game_mode = "Free for all";
		
		if(g("FFA") || g("SUP") || g("GG") || g("BOUCHERIE") || g("brickG")|| g("BRAWL")|| g("RTD") || g("SHARP") || g("SURVIVAL") || g("ONLY_") || g("OITC") || g("INTEL") || g("ONLY_SNIPER"))
			DM_Dvars();
		
		maps\mp\gametypes\_globallogic::init();
		maps\mp\gametypes\_callbacksetup::SetupCallbacks();
		maps\mp\gametypes\_globallogic::SetupCallbacks();

		maps\mp\gametypes\_globallogic::registerNumLivesDvar( "dm", 0, 0, 10 );
		maps\mp\gametypes\_globallogic::registerRoundLimitDvar( "dm", 1, 0, 500 );
		maps\mp\gametypes\_globallogic::registerScoreLimitDvar( "dm", 0, 0, 5000 );
		maps\mp\gametypes\_globallogic::registerTimeLimitDvar( "dm", 30, 0, 1440 );

		level.teamBased = false;
		
		if(g("GG"))
			level.onPlayerKilled = maps\mp\gametypes\_gun_game::onPlayerKilled;
		else if(g("OITC"))
			level.onPlayerKilled = maps\mp\gametypes\_one_in_the_chamber::onPlayerKilled;
		else if(g("ONLY_") || g("ONLY_SNIPER"))
			level.onPlayerKilled = maps\mp\gametypes\_OnlyX::onPlayerKilled;
		else if(g("BRAWL"))
			level.onPlayerKilled = maps\mp\gametypes\_sniper_lobby::onPlayerKilled;	
		else if(g("brickG"))
			level.onPlayerKilled = maps\mp\gametypes\_brickGUN::onPlayerKilled;	
		else
			level.onPlayerKilled = ::onPlayerKilled;
		
		
		level.onStartGameType = ::onStartGameType;
		level.onSpawnPlayer = ::onSpawnPlayer;
		game["dialog"]["gametype"] = "freeforall";
	}
}


DM_Dvars()
{
	if(g("ONLY_") || g("ONLY_SNIPER") || g("GG"))
	{
		setDvar("scr_dm_timelimit", 10);
		setDvar("scr_dm_roundlimit", 1);
		setDvar("scr_dm_scorelimit", 0);
		setDvar("scr_dm_numlives", 0);
	}
	
	else if(g("INTEL"))
	{
		setDvar("scr_dm_timelimit", 0);
		setDvar("scr_dm_scorelimit", 1251);
		setDvar("scr_dm_roundlimit", 1);
		setDvar("scr_dm_numlives", 0);
	}
	else if(g("OS"))
	{
		setDvar("scr_dm_timelimit", 0);
		setDvar("scr_dm_roundlimit", 1);
		setDvar("scr_dm_scorelimit", 0);
		setDvar("scr_dm_numlives", 0);
	}
	else if(g("OITC"))
	{
		setDvar("scr_dm_roundlimit", 1);
		setDvar("scr_dm_numlives", 3);
		setDvar("scr_dm_timelimit", 10);
		setDvar("scr_dm_scorelimit", 0);
	}
	else if(g("SURVIVAL"))
	{
		setDvar("scr_dm_roundlimit", 1);
		setDvar("scr_dm_timelimit", 15 );
		setDvar("scr_dm_scorelimit", 300 );
		setDvar("scr_dm_numlives", 0);
	}
	else if(g("RTD"))
	{
		setDvar("scr_dm_roundlimit", 1);
		setDvar("scr_dm_timelimit", 5 );
		setDvar("scr_dm_scorelimit", 0 );
		setDvar("scr_dm_numlives", 0);
	}
	else if(g("SHARP"))
	{
		setDvar("scr_dm_roundlimit", 1);
		setDvar("scr_dm_timelimit", 5);
		setDvar("scr_dm_scorelimit", 150 );
		setDvar("scr_dm_numlives", 0);
	}
	else if(g("BOUCHERIE") || g("BRAWL")|| g("brickG"))
	{
		setDvar("scr_dm_roundlimit", 1);
		setDvar("scr_dm_timelimit", 5 );
		setDvar("scr_dm_scorelimit", 100 );
		setDvar("scr_dm_numlives", 0);
	}
}


onStartGameType()
{
	setClientNameMode("auto_change");

	maps\mp\gametypes\_globallogic::setObjectiveText( "allies", &"OBJECTIVES_DM" );
	maps\mp\gametypes\_globallogic::setObjectiveText( "axis", &"OBJECTIVES_DM" );

	if ( level.splitscreen )
	{
		maps\mp\gametypes\_globallogic::setObjectiveScoreText( "allies", &"OBJECTIVES_DM" );
		maps\mp\gametypes\_globallogic::setObjectiveScoreText( "axis", &"OBJECTIVES_DM" );
	}
	else
	{
		maps\mp\gametypes\_globallogic::setObjectiveScoreText( "allies", &"OBJECTIVES_DM_SCORE" );
		maps\mp\gametypes\_globallogic::setObjectiveScoreText( "axis", &"OBJECTIVES_DM_SCORE" );
	}
	maps\mp\gametypes\_globallogic::setObjectiveHintText( "allies", &"OBJECTIVES_DM_HINT" );
	maps\mp\gametypes\_globallogic::setObjectiveHintText( "axis", &"OBJECTIVES_DM_HINT" );

	level.spawnMins = ( 0, 0, 0 );
	level.spawnMaxs = ( 0, 0, 0 );
	maps\mp\gametypes\_spawnlogic::addSpawnPoints( "allies", "mp_dm_spawn" );
	maps\mp\gametypes\_spawnlogic::addSpawnPoints( "axis", "mp_dm_spawn" );
	level.mapCenter = maps\mp\gametypes\_spawnlogic::findBoxCenter( level.spawnMins, level.spawnMaxs );
	setMapCenter( level.mapCenter );
	
	allowed[0] = "dm";
	maps\mp\gametypes\_gameobjects::main(allowed);

	level.displayRoundEndText = false;
	level.QuickMessageToAll = true;

	// elimination style
	if ( level.roundLimit != 1 && level.numLives )
	{
		level.overridePlayerScore = true;
		level.displayRoundEndText = true;
		level.onEndGame = ::onEndGame;
	}
}

onPlayerKilled(eInflictor, attacker, iDamage, s, sWeapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration)
{
	if(g("BOUCHERIE") && attacker != self) attacker thread maps\mp\gametypes\_boucherie::KilledPlayer(sHitLoc,self);
	
	if(g("SHARP") && attacker != self) attacker thread maps\mp\gametypes\_sharpshooter::giveXperk();
	
	thread maps\mp\gametypes\_finalkills::onPlayerKilled(eInflictor, attacker, iDamage, s, sWeapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration);
}


onSpawnPlayer()
{
	if(g("BOUCHERIE"))
	{
		self maps\mp\gametypes\_boucherie::BoucherieSpawn();
		return;
	}
	else if(g("BRAWL"))
	{
		self maps\mp\gametypes\_sniper_lobby::BoucherieSpawn();
		return;
	}
	else if(g("brickG"))
	{
		self maps\mp\gametypes\_brickGUN::BoucherieSpawn();
		return;
	}
	spawnPoints = maps\mp\gametypes\_spawnlogic::getTeamSpawnPoints( self.pers["team"] );
	spawnPoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_DM( spawnPoints );

	self spawn( spawnPoint.origin, spawnPoint.angles );
	
}


onEndGame( winningPlayer )
{
	if ( isDefined( winningPlayer ) )
		[[level._setPlayerScore]]( winningPlayer, winningPlayer [[level._getPlayerScore]]() + 1 );	
}