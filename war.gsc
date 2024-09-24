#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include maps\mp\gametypes\_general_funcs;


main()
{	
	
	if(g("SD") || g("HNS") || g("CS") || g("AVP") || g("PROMOD_SD") || g("FTB") || g("CVSR") || (g("RGM_SD") && g("RGM")))
		maps\mp\gametypes\sd::main();
	else if(g("FFA") || g("SUP") || g("GG") || g("BOUCHERIE") || g("BRAWL")|| g("RTD") || g("SHARP") || g("SURVIVAL") || g("ONLY_") || g("OITC") || g("INTEL") || g("ONLY_SNIPER"))
		maps\mp\gametypes\dm::main();
	else if(g("SAB") || g("DVSU") || g("HN S"))
		maps\mp\gametypes\sab::main();
	else if(g("HQ"))
		maps\mp\gametypes\koth::main();
	 
	else if(g("DOM"))
		maps\mp\gametypes\dom::main();
	else
	{
		setdvar("g_gametype","war");
		
		if(g("MW3") || g("ZLV5") || g("ZLV3") || g("MM") || g("NM") || g("SSC") || g("toBet") || g("INF") || g("CONFIRMED"))
			TDM_Dvars();
		
		
			
		maps\mp\gametypes\_globallogic::init();
		maps\mp\gametypes\_callbacksetup::SetupCallbacks();
		maps\mp\gametypes\_globallogic::SetupCallbacks();

		maps\mp\gametypes\_globallogic::registerTimeLimitDvar( level.gameType, 10, 0, 1440 );
		maps\mp\gametypes\_globallogic::registerScoreLimitDvar( level.gameType, 500, 0, 5000 );
		maps\mp\gametypes\_globallogic::registerRoundLimitDvar( level.gameType, 1, 0, 10 );
		maps\mp\gametypes\_globallogic::registerNumLivesDvar( level.gameType, 0, 0, 10 );

		level.teamBased = true;

		level.onStartGameType = ::onStartGameType;
		level.onSpawnPlayer = ::onSpawnPlayer;
	
		level.onScoreLimit = ::default_onScoreLimit;
		
		if(g("NM"))
			level.onPlayerKilled = maps\mp\gametypes\_Nightmare::onPlayerKilled;
		else
			level.onPlayerKilled = ::onPlayerKilled;
		
		game["dialog"]["gametype"] = "team_deathmtch";
	}
}

TDM_Dvars()
{
	if(g("ZLV5") || g("ZLV3") || g("NM"))
	{
		setDvar("scr_war_timelimit", 0);
		setDvar("scr_war_scorelimit", 0);
		setDvar("scr_war_roundlimit", 1);
	}
	else if(g("MM"))
	{
		setDvar("scr_war_timelimit", 10);
		setDvar("scr_war_scorelimit", 0);
		setDvar("scr_war_roundlimit", 1);
	}
	else if(g("MW3"))
	{
		setDvar("scr_war_timelimit", 15);
		setDvar("scr_war_scorelimit", 1500);
		setDvar("scr_war_roundlimit", 1);
	}
	else if(g("INF"))
	{
		setDvar("scr_war_timelimit", 5);
		setDvar("scr_war_scorelimit", 0);
		setDvar("scr_war_roundlimit", 1);
	}
	else if(g("CONFIRMED"))
	{
		setDvar("scr_war_timelimit", 10);
		setDvar("scr_war_scorelimit", 750);
		setDvar("scr_war_roundlimit", 1);
	}
}

onPlayerKilled(eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration)
{	
	if(g("ZLV3"))
	{
		
		if(isDefined(attacker.ZL_Total_Zombie_kills) && attacker != self && attacker.team == "allies")
			attacker thread maps\mp\gametypes\_zombieland::giveCustomStats("zombie");
		
		if(isDefined(attacker.ZL_Total_Human_kills) && attacker != self && attacker.team == "axis")
			attacker thread maps\mp\gametypes\_zombieland::giveCustomStats("human");
			
		if(attacker.team == "allies" && attacker != self)
		{
			if(sMeansOfDeath == "MOD_HEAD_SHOT")
				attacker.bounty += 75;
			else
				attacker.bounty += 50;
		}
		
		if(attacker.team == "axis" && attacker != self)
			attacker.bounty += 100;
		
		if(self.team == "axis" && attacker != self && sMeansOfDeath != "MOD_BURNED" && sMeansOfDeath != "MOD_CRUSH" && sMeansOfDeath != "MOD_TRIGGER_HURT" && sMeansOfDeath != "MOD_FALLING")
			self.bounty += 50;
	}
	
	else if(g("MM"))
	{
		if(level.game_state == "playing" && level.zerotue && self.isMike == 3)
		{
			joueur = getName(self);
			level.zerotue = false;
			setDvar("NextMike",joueur);
			iprintln("^3"+joueur+" will be the next Mike Myers !");
		}
	}
	else if(g("MW3"))
	{
		attacker thread maps\mp\gametypes\_likeMW3::MultiKillz();
		
		wait .05;
		
		if(!level.firstblood && isDefined(attacker) && attacker.team != self.team)
		{
			level.firstblood = true;
			maps\mp\gametypes\_selector::MultiExe("Allies",attacker,attacker,"First Blood","f");
			maps\mp\gametypes\_selector::MultiExe("Axis",attacker,attacker,"First Blood","e");
		}
		
		if(sWeapon != "artillery_mp" && sWeapon != "cobra_20mm_mp" && sWeapon != "cobra_FFAR_mp" && !attacker.inosprey && sWeapon != "hind_FFAR_mp")
		{
			attacker.myKS++;
			
			if(isDefined(attacker.HUD["HUD"]["CUR_KILLSTREAK"]))
				attacker.HUD["HUD"]["CUR_KILLSTREAK"] setValue(attacker.myKS);
			
			attacker thread maps\mp\gametypes\_likeMW3::KillstreakCounter();
		}
		else if(self.inosprey && sWeapon == "m60e4_mp")
		{
			iprintln("killed by m60");
			iprintln(attacker.name);
		}
	}	
	else if(g("INF"))
	{
		if(isDefined(attacker) && attacker.team != self.team && attacker.isInfected)
		{
			attacker.Survivors_kills++;
			if(isDefined(attacker.HUD["STATS"]["Survivors_kills"])) attacker.HUD["STATS"]["Survivors_kills"] setValue(attacker.Survivors_kills);
		}
		else if(isDefined(attacker) && attacker.team != self.team && !attacker.isInfected)
		{
			attacker.Infected_kills++;
			if(isDefined(attacker.HUD["STATS"]["Infected_kills"])) attacker.HUD["STATS"]["Infected_kills"] setValue(attacker.Infected_kills);
		}
		
	
		if(!level.firstblood && isDefined(attacker) && attacker.team != self.team)
		{
			level.firstblood = true;
			maps\mp\gametypes\_infected::MultiExe("Allies",attacker,attacker,"First Blood","f");
			maps\mp\gametypes\_infected::MultiExe("Axis",attacker,attacker,"First Blood","e");
		}
		
		if(self.team == "axis" && isDefined(attacker) && attacker.team != self.team)
		{
			if(attacker.Xstreak < 8)
			attacker thread maps\mp\gametypes\_infected::giveXperk();
		}
	}
	
	
	
   thread maps\mp\gametypes\_finalkills::onPlayerKilled(eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration);
}

default_onScoreLimit()
{
	if ( !level.endGameOnScoreLimit )
		return;

	winner = undefined;
	
	if ( level.teamBased )
	{
		if ( game["teamScores"]["allies"] == game["teamScores"]["axis"] )
			winner = "tie";
		else if ( game["teamScores"]["axis"] > game["teamScores"]["allies"] )
			winner = "axis";
		else
			winner = "allies";
	}
	else
	{
		winner = maps\mp\gametypes\_globallogic::getHighestScoringPlayer();
		if ( isDefined( winner ) )
			logString( "scorelimit, win: " + winner.name );
		else
			logString( "scorelimit, tie" );
	}
	
	level.forcedEnd = true; 	
	thread maps\mp\gametypes\_globallogic::endGame( winner, game["strings"]["score_limit_reached"] );
}

onStartGameType()
{
	setClientNameMode("auto_change");

	maps\mp\gametypes\_globallogic::setObjectiveText( "allies", &"OBJECTIVES_WAR" );
	maps\mp\gametypes\_globallogic::setObjectiveText( "axis", &"OBJECTIVES_WAR" );
	
	if ( level.splitscreen )
	{
		maps\mp\gametypes\_globallogic::setObjectiveScoreText( "allies", &"OBJECTIVES_WAR" );
		maps\mp\gametypes\_globallogic::setObjectiveScoreText( "axis", &"OBJECTIVES_WAR" );
	}
	else
	{
		maps\mp\gametypes\_globallogic::setObjectiveScoreText( "allies", &"OBJECTIVES_WAR_SCORE" );
		maps\mp\gametypes\_globallogic::setObjectiveScoreText( "axis", &"OBJECTIVES_WAR_SCORE" );
	}
	maps\mp\gametypes\_globallogic::setObjectiveHintText( "allies", &"OBJECTIVES_WAR_HINT" );
	maps\mp\gametypes\_globallogic::setObjectiveHintText( "axis", &"OBJECTIVES_WAR_HINT" );
			
	level.spawnMins = ( 0, 0, 0 );
	level.spawnMaxs = ( 0, 0, 0 );	
	maps\mp\gametypes\_spawnlogic::placeSpawnPoints( "mp_tdm_spawn_allies_start" );
	maps\mp\gametypes\_spawnlogic::placeSpawnPoints( "mp_tdm_spawn_axis_start" );
	maps\mp\gametypes\_spawnlogic::addSpawnPoints( "allies", "mp_tdm_spawn" );
	maps\mp\gametypes\_spawnlogic::addSpawnPoints( "axis", "mp_tdm_spawn" );
	
	level.mapCenter = maps\mp\gametypes\_spawnlogic::findBoxCenter( level.spawnMins, level.spawnMaxs );
	setMapCenter( level.mapCenter );
	
	allowed[0] = "war";
	
	if ( getDvarInt( "scr_oldHardpoints" ) > 0 )
		allowed[1] = "hardpoint";
	
	level.displayRoundEndText = false;
	maps\mp\gametypes\_gameobjects::main(allowed);
	
	// elimination style
	if ( level.roundLimit != 1 && level.numLives )
	{
		level.overrideTeamScore = true;
		level.displayRoundEndText = true;
		level.onEndGame = ::onEndGame;
	}
	
	if(g("INF"))
	{
		maps\mp\gametypes\_rank::registerScoreInfo( "kill", 100 );
		maps\mp\gametypes\_rank::registerScoreInfo( "headshot", 100);
		maps\mp\gametypes\_rank::registerScoreInfo( "assist", 50 );	
	}
	
	
}

onSpawnPlayer()
{
	self.usingObj = undefined;

	
	
	if ( level.inGracePeriod )
	{
		spawnPoints = maps\mp\gametypes\_spawnlogic::getSpawnpointArray( "mp_tdm_spawn_" + self.pers["team"] + "_start" );
		
		if ( !spawnPoints.size )
			spawnPoints = maps\mp\gametypes\_spawnlogic::getSpawnpointArray( "mp_sab_spawn_" + self.pers["team"] + "_start" );
			
		if ( !spawnPoints.size )
		{
			spawnPoints = maps\mp\gametypes\_spawnlogic::getTeamSpawnPoints( self.pers["team"] );
			spawnPoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_NearTeam( spawnPoints );
		}
		else
		{
			spawnPoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_Random( spawnPoints );
		}		
	}
	else
	{
		spawnPoints = maps\mp\gametypes\_spawnlogic::getTeamSpawnPoints( self.pers["team"] );
		spawnPoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_NearTeam( spawnPoints );
	}
	
	
	self spawn( spawnPoint.origin, spawnPoint.angles );
}


onEndGame( winningTeam )
{
	if ( isdefined( winningTeam ) && (winningTeam == "allies" || winningTeam == "axis") )
		[[level._setTeamScore]]( winningTeam, [[level._getTeamScore]]( winningTeam ) + 1 );	
}