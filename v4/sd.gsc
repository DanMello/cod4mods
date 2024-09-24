#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include maps\mp\gametypes\_general_funcs;

main()
{
	precacheShader("hudStopwatch");
	precacheShader("hudStopwatchNeedle");
	precacheShader("hud_icon_c4"); 
	
	
	if(getdvar("mapname") == "mp_background")
		return;
	
		
	if(g("TDM") || g("ZLV5") || g("RGM") || g("CJ") || g("ZLV3") || g("MW3") || g("MM") || g("NM") || g("SSC") || g("toBet") || g("INF") || g("GON") || g("CONFIRMED") || g("FUNNYZOMB") || g("CJ"))
		maps\mp\gametypes\war::main();
	else if(g("FFA") || g("SUP") || g("GG") || g("brickG") || g("BOUCHERIE") || g("BRAWL")|| g("RTD") || g("SHARP") || g("SURVIVAL") || g("ONLY_") || g("OITC") || g("INTEL") || g("ONLY_SNIPER"))
		maps\mp\gametypes\dm::main();
	else if(g("SAB"))
		maps\mp\gametypes\sab::main();
	else if(g("HQ"))
		maps\mp\gametypes\koth::main(); 
	else if(g("DOM"))
		maps\mp\gametypes\dom::main();
	else
	{
		setdvar("g_gametype","sd");
		setdvar("party_gametype","sd");
		setdvar("ui_gametype","sd");
		
		
		if(g("SD"))
		level.current_game_mode = "Search and destroy";
		
			
		if(g("HNS") || g("CS") || g("AVP") || g("PROMOD_SD") || g("FTB") || g("CVSR") || g("cachecache"))
			thread SD_Dvars();
			
	maps\mp\gametypes\_globallogic::init();
	maps\mp\gametypes\_callbacksetup::SetupCallbacks();
	maps\mp\gametypes\_globallogic::SetupCallbacks();
	
	maps\mp\gametypes\_globallogic::registerRoundSwitchDvar( level.gameType, 3, 0, 9 );
	maps\mp\gametypes\_globallogic::registerTimeLimitDvar( level.gameType, 2.5, 0, 1440 );
	maps\mp\gametypes\_globallogic::registerScoreLimitDvar( level.gameType, 4, 0, 500 );
	maps\mp\gametypes\_globallogic::registerRoundLimitDvar( level.gameType, 0, 0, 12 );
	maps\mp\gametypes\_globallogic::registerNumLivesDvar( level.gameType, 1, 0, 10 );
	
	 
	
	level.teamBased = true;
	level.overrideTeamScore = true;
	level.onPrecacheGameType = ::onPrecacheGameType;
	level.onStartGameType = ::onStartGameType;
	level.onSpawnPlayer = ::onSpawnPlayer;
	level.onPlayerKilled = ::onPlayerKilled;
	level.onDeadEvent = ::onDeadEvent;
	level.onOneLeftEvent = ::onOneLeftEvent;
	level.onTimeLimit = ::onTimeLimit;
	level.onRoundSwitch = ::onRoundSwitch;
	
	level.endGameOnScoreLimit = false;
	
	game["dialog"]["gametype"] = "searchdestroy";
	game["dialog"]["offense_obj"] = "obj_destroy";
	game["dialog"]["defense_obj"] = "obj_defend";
	}
}

SD_Dvars()
{
	if(g("HNS") || g("cachecache"))
	{
		if(g("cachecache"))
			setDvar("scr_sd_timelimit", 3.5);
		
		setDvar("scr_sd_numlives", 0);
		setDvar("scr_sd_roundswitch", 0);
		setDvar("scr_sd_scorelimit", 3);
		setDvar("scr_sd_playerrespawndelay", 0);
		setDvar("scr_sd_waverespawndelay", 0);	
	}
	else if(g("CS") || g("AVP") || g("FTB"))
	{
		setDvar("scr_sd_numlives", 1);
		setDvar("scr_sd_roundswitch", 2);
		setDvar("scr_sd_scorelimit", 6);
		setDvar("scr_sd_playerrespawndelay", 0);
		setDvar("scr_sd_waverespawndelay", 0);	
		setDvar( "scr_sd_planttime", "6.5" );
		setDvar( "scr_sd_bombtimer", "50" );
		setDvar( "scr_sd_defusetime", "7.7" );
	
		if(g("AVP"))
		{
			setDvar("scr_sd_timelimit", 3.50);
			setDvar("scr_sd_scorelimit", 4);
		}
		else if(g("FTB"))
		{
			setDvar("scr_sd_timelimit", 2);
			setDvar("scr_sd_scorelimit", 4);
			
		}
	}
	else if(g("PROMOD_SD"))
	{
		setDvar( "scr_sd_planttime", "5.2" );
		setDvar( "scr_sd_bombtimer", "50" );
		setDvar( "scr_sd_defusetime", "7.7" );
		setDvar( "scr_sd_scorelimit", "8" );
		setDvar( "scr_sd_roundswitch", "4" );
	}
	else if(g("CVSR"))
	{
		setDvar("scr_sd_timelimit", 0);
		setDvar("scr_sd_numlives", 1);
		setDvar("scr_sd_roundswitch", 1);
		setDvar("scr_sd_scorelimit", 3);
		setDvar("scr_sd_playerrespawndelay", 0);
		setDvar("scr_sd_waverespawndelay", 0);	
	}
}

onPlayerKilled(eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration)
{
	if(self.IN_MENU["RANK"] || self.IN_MENU["AREA_EDITOR"])
		self.statusicon = "hud_status_dead";	
		
	if(g("HNS"))
	{
		s = sMeansOfDeath;
		if(s == "MOD_MELEE" || s == "MOD_PISTOL_BULLET" || s == "MOD_RIFLE_BULLET" || s == "MOD_HEAD_SHOT" || s == "MOD_PROJECTILE_SPLASH")
			attacker thread maps\mp\gametypes\_HNS::KillstreakCounter();
			
		if(self.isTheLastHider)
		{
			attacker iprintlnbold("You killed the last hider !");
			attacker.HNS_XP += 10;
			attacker thread maps\mp\gametypes\_rank::updateRankScoreHUD(1);
		}
	}
	
	
	else if(g("AVP"))
	{
		if(self.isAlien)
		{
			attacker.AVP_aliens_killed++;
			if(isDefined(attacker.HUD["AVP"]["ALIENS_KILLED"])) attacker.HUD["AVP"]["ALIENS_KILLED"] setValue(attacker.AVP_aliens_killed);
		}
		else if(self.isPredator)
		{
			attacker.AVP_predators_killed++;
			if(isDefined(attacker.HUD["AVP"]["PREDS_KILLED"])) attacker.HUD["AVP"]["PREDS_KILLED"] setValue(attacker.AVP_predators_killed);
		}
	}
	
	
	if((g("HNS") && attacker.team == "allies") || (g("cachecache") && attacker.team == "allies") )
		{}
	else
		thread maps\mp\gametypes\_finalkills::onPlayerKilled(eInflictor, attacker, iDamage, sWeapon, sWeapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration);
	
	thread checkAllowSpectating();
}

onPrecacheGameType()
{
	game["bombmodelname"] = "mil_tntbomb_mp";
	game["bombmodelnameobj"] = "mil_tntbomb_mp";
	game["bomb_dropped_sound"] = "mp_war_objective_lost";
	game["bomb_recovered_sound"] = "mp_war_objective_taken";
	
	precacheModel(game["bombmodelname"]);
	precacheModel(game["bombmodelnameobj"]);

	precacheShader("waypoint_bomb");
	precacheShader("hud_suitcase_bomb");
	precacheShader("waypoint_target");
	precacheShader("waypoint_target_a");
	precacheShader("waypoint_target_b");
	precacheShader("waypoint_defend");
	precacheShader("waypoint_defend_a");
	precacheShader("waypoint_defend_b");
	precacheShader("waypoint_defuse");
	precacheShader("waypoint_defuse_a");
	precacheShader("waypoint_defuse_b");
	precacheShader("compass_waypoint_target");
	precacheShader("compass_waypoint_target_a");
	precacheShader("compass_waypoint_target_b");
	precacheShader("compass_waypoint_defend");
	precacheShader("compass_waypoint_defend_a");
	precacheShader("compass_waypoint_defend_b");
	precacheShader("compass_waypoint_defuse");
	precacheShader("compass_waypoint_defuse_a");
	precacheShader("compass_waypoint_defuse_b");
	
	precacheString( &"MP_EXPLOSIVES_RECOVERED_BY" );
	precacheString( &"MP_EXPLOSIVES_DROPPED_BY" );
	precacheString( &"MP_EXPLOSIVES_PLANTED_BY" );
	precacheString( &"MP_EXPLOSIVES_DEFUSED_BY" );
	precacheString( &"PLATFORM_HOLD_TO_PLANT_EXPLOSIVES" );
	precacheString( &"PLATFORM_HOLD_TO_DEFUSE_EXPLOSIVES" );
	precacheString( &"MP_CANT_PLANT_WITHOUT_BOMB" );	
	precacheString( &"MP_PLANTING_EXPLOSIVE" );	
	precacheString( &"MP_DEFUSING_EXPLOSIVE" );	
}

onRoundSwitch()
{
	if ( !isdefined( game["switchedsides"] ) )
		game["switchedsides"] = false;
	
	if ( game["teamScores"]["allies"] == level.scorelimit - 1 && game["teamScores"]["axis"] == level.scorelimit - 1 )
	{
		// overtime! team that's ahead in kills gets to defend.
		aheadTeam = getBetterTeam();
		if ( aheadTeam != game["defenders"] )
		{
			game["switchedsides"] = !game["switchedsides"];
		}
		else
		{
			level.halftimeSubCaption = "";
		}
		level.halftimeType = "overtime";
	}
	else
	{
		level.halftimeType = "halftime";
		game["switchedsides"] = !game["switchedsides"];
	}
}

getBetterTeam()
{
	kills["allies"] = 0;
	kills["axis"] = 0;
	deaths["allies"] = 0;
	deaths["axis"] = 0;
	
	for ( i = 0; i < level.players.size; i++ )
	{
		player = level.players[i];
		team = player.pers["team"];
		if ( isDefined( team ) && (team == "allies" || team == "axis") )
		{
			kills[ team ] += player.kills;
			deaths[ team ] += player.deaths;
		}
	}
	
	if ( kills["allies"] > kills["axis"] )
		return "allies";
	else if ( kills["axis"] > kills["allies"] )
		return "axis";
	
	// same number of kills

	if ( deaths["allies"] < deaths["axis"] )
		return "allies";
	else if ( deaths["axis"] < deaths["allies"] )
		return "axis";
	
	// same number of deaths
	
	if ( randomint(2) == 0 )
		return "allies";
	return "axis";
}

onStartGameType()
{
	if ( !isDefined( game["switchedsides"] ) )
		game["switchedsides"] = false;
	
	if ( game["switchedsides"] )
	{
		oldAttackers = game["attackers"];
		oldDefenders = game["defenders"];
		game["attackers"] = oldDefenders;
		game["defenders"] = oldAttackers;
	}
	
	setClientNameMode( "manual_change" );
	
	game["strings"]["target_destroyed"] = &"MP_TARGET_DESTROYED";
	game["strings"]["bomb_defused"] = &"MP_BOMB_DEFUSED";
	
	precacheString( game["strings"]["target_destroyed"] );
	precacheString( game["strings"]["bomb_defused"] );

	level._effect["bombexplosion"] = loadfx("explosions/tanker_explosion");
	
	maps\mp\gametypes\_globallogic::setObjectiveText( game["attackers"], &"OBJECTIVES_SD_ATTACKER" );
	maps\mp\gametypes\_globallogic::setObjectiveText( game["defenders"], &"OBJECTIVES_SD_DEFENDER" );

	if ( level.splitscreen )
	{
		maps\mp\gametypes\_globallogic::setObjectiveScoreText( game["attackers"], &"OBJECTIVES_SD_ATTACKER" );
		maps\mp\gametypes\_globallogic::setObjectiveScoreText( game["defenders"], &"OBJECTIVES_SD_DEFENDER" );
	}
	else
	{
		maps\mp\gametypes\_globallogic::setObjectiveScoreText( game["attackers"], &"OBJECTIVES_SD_ATTACKER_SCORE" );
		maps\mp\gametypes\_globallogic::setObjectiveScoreText( game["defenders"], &"OBJECTIVES_SD_DEFENDER_SCORE" );
	}
	maps\mp\gametypes\_globallogic::setObjectiveHintText( game["attackers"], &"OBJECTIVES_SD_ATTACKER_HINT" );
	maps\mp\gametypes\_globallogic::setObjectiveHintText( game["defenders"], &"OBJECTIVES_SD_DEFENDER_HINT" );

	level.spawnMins = ( 0, 0, 0 );
	level.spawnMaxs = ( 0, 0, 0 );	
	maps\mp\gametypes\_spawnlogic::placeSpawnPoints( "mp_sd_spawn_attacker" );
	maps\mp\gametypes\_spawnlogic::placeSpawnPoints( "mp_sd_spawn_defender" );
	
	maps\mp\gametypes\_spawnlogic::addSpawnPoints( "allies", "mp_dm_spawn" );
	maps\mp\gametypes\_spawnlogic::addSpawnPoints( "axis", "mp_dm_spawn" );
	

	level.mapCenter = maps\mp\gametypes\_spawnlogic::findBoxCenter( level.spawnMins, level.spawnMaxs );
	setMapCenter( level.mapCenter );
	
	if(g("HNS") || g("AVP") || g("FTB") || g("CVSR") || g("cachecache"))
		allowed[0] = "";
	
	else
	{
		allowed[0] = "sd";
		allowed[1] = "bombzone";
		allowed[2] = "blocker";
		
		//if(getdvar("CJ_GAMETYPE") == "SAB") allowed[3] = "sab";
	
		
	}
	
	maps\mp\gametypes\_gameobjects::main(allowed);
	
	
	if(g("HNS"))
	{
		maps\mp\gametypes\_rank::registerScoreInfo( "kill", 3 );
		maps\mp\gametypes\_rank::registerScoreInfo( "headshot", 5);
		maps\mp\gametypes\_rank::registerScoreInfo( "assist", 1 );	
		maps\mp\gametypes\_rank::registerScoreInfo( "plant", 300 );
	}
	else if(g("cachecache"))
	{
		maps\mp\gametypes\_rank::registerScoreInfo( "kill", 10 );
		maps\mp\gametypes\_rank::registerScoreInfo( "headshot", 5);
		maps\mp\gametypes\_rank::registerScoreInfo( "assist", 1 );	
		maps\mp\gametypes\_rank::registerScoreInfo( "plant", 300 );
	}
	else
	{
		maps\mp\gametypes\_rank::registerScoreInfo( "kill", 50 );
		maps\mp\gametypes\_rank::registerScoreInfo( "headshot", 50 );
		maps\mp\gametypes\_rank::registerScoreInfo( "assist", 25 );
		maps\mp\gametypes\_rank::registerScoreInfo( "plant", 100 );
	}
	

	maps\mp\gametypes\_rank::registerScoreInfo( "win", 2 );
	maps\mp\gametypes\_rank::registerScoreInfo( "loss", 1 );
	maps\mp\gametypes\_rank::registerScoreInfo( "tie", 1.5 );
	maps\mp\gametypes\_rank::registerScoreInfo( "defuse", 100 );
	
	thread updateGametypeDvars();
	
	thread bombs();
}


onSpawnPlayer()
{
	self.isPlanting = false;
	self.isDefusing = false;
	self.isBombCarrier = false;
		
	if(self.pers["team"] == game["attackers"])
		spawnPointName = "mp_sd_spawn_attacker";
	else
		spawnPointName = "mp_sd_spawn_defender";
		
	if ( level.multiBomb && !isDefined( self.carryIcon ) && self.pers["team"] == game["attackers"] && !level.bombPlanted )
	{
		if ( level.splitscreen )
		{
			self.carryIcon = createIcon( "hud_suitcase_bomb", 35, 35 );
			self.carryIcon setPoint( "BOTTOM RIGHT", "BOTTOM RIGHT", -10, -50 );
			self.carryIcon.alpha = 0.75;
		}
		else
		{
			self.carryIcon = createIcon( "hud_suitcase_bomb", 50, 50 );
			self.carryIcon setPoint( "CENTER", "CENTER", 220, 140 );
			self.carryIcon.alpha = 0.75;
		}
	}

	if((g("HNS") || g("cachecache")) && self.team == "axis")
	{
		spawnPoints = maps\mp\gametypes\_spawnlogic::getTeamSpawnPoints( self.pers["team"] );
		spawnPoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_DM( spawnPoints );
		self spawn( spawnPoint.origin, spawnPoint.angles );
	}
	else
	{
		spawnPoints = maps\mp\gametypes\_spawnlogic::getSpawnpointArray( spawnPointName );
		assert( spawnPoints.size );
		spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_Random( spawnPoints );

		self spawn( spawnpoint.origin, spawnpoint.angles );
	}
	
	level notify ( "spawned_player" );
}



checkAllowSpectating()
{
	wait ( 0.05 );
	
	update = false;
	
	if ( !level.aliveCount[ game["attackers"] ] )
	{
		level.spectateOverride[game["attackers"]].allowEnemySpectate = 1;
		update = true;
	}
	if ( !level.aliveCount[ game["defenders"] ] )
	{
		level.spectateOverride[game["defenders"]].allowEnemySpectate = 1;
		update = true;
	}
	if ( update )
		maps\mp\gametypes\_spectating::updateSpectateSettings();
}


sd_endGame( winningTeam, endReasonText )
{
	if ( isdefined( winningTeam ) )
		[[level._setTeamScore]]( winningTeam, [[level._getTeamScore]]( winningTeam ) + 1 );
	
	thread maps\mp\gametypes\_globallogic::endGame( winningTeam, endReasonText );
}


onDeadEvent( team )
{
	if ( level.bombExploded || level.bombDefused )
		return;
	
	if ( team == "all" )
	{
		if ( level.bombPlanted )
			sd_endGame( game["attackers"], game["strings"][game["defenders"]+"_eliminated"] );
		else
			sd_endGame( game["defenders"], game["strings"][game["attackers"]+"_eliminated"] );
	}
	else if ( team == game["attackers"] )
	{
		if ( level.bombPlanted )
			return;
		
		sd_endGame( game["defenders"], game["strings"][game["attackers"]+"_eliminated"] );
	}
	else if ( team == game["defenders"] )
	{
		sd_endGame( game["attackers"], game["strings"][game["defenders"]+"_eliminated"] );
	}
}


onOneLeftEvent( team )
{
	if ( level.bombExploded || level.bombDefused )
		return;
	
	//if ( team == game["attackers"] )
	warnLastPlayer( team );
}


onTimeLimit()
{
	if(g("HNS"))
	{
		sd_endGame( game["defenders"], "Seekers didn't found Hiders" );
		
		for(a=0;a<level.players.size;a++) if(isDefined(level.players[a].HNS_timer["CHOOSE"])) level.players[a].HNS_timer["CHOOSE"] destroy();
		for(a=0;a<level.players.size;a++) if(isDefined(level.players[a].HNS_timer["HIDINGTIME"])) level.players[a].HNS_timer["HIDINGTIME"] destroy();
		for(a=0;a<level.players.size;a++) if(isDefined(level.players[a].HNS_timer["SEEKINGTIME"])) level.players[a].HNS_timer["SEEKINGTIME"] destroy();
	
	
		thread maps\mp\gametypes\_HNS::check_last_hiders();
	}
	else if(g("cachecache"))
	{
		for(a=0;a<level.players.size;a++)
			if(isDefined(level.players[a].totalHidersWINS) && level.players[a].team == "allies")
			{
				level.players[a].totalHidersWINS++;
				level.players[a] setstat(3476 ,level.players[a].totalHidersWINS);
			}
		
		
		sd_endGame( game["defenders"], "Seekers didn't found Hiders" );
	}
	else
	{
		if ( level.teamBased )
			sd_endGame( game["defenders"], game["strings"]["time_limit_reached"] );
		else
			sd_endGame( undefined, game["strings"]["time_limit_reached"] );
	}
}


warnLastPlayer( team )
{
	if ( !isdefined( level.warnedLastPlayer ) )
		level.warnedLastPlayer = [];
	
	if ( isDefined( level.warnedLastPlayer[team] ) )
		return;
		
	level.warnedLastPlayer[team] = true;

	players = level.players;
	for ( i = 0; i < players.size; i++ )
	{
		player = players[i];

		if ( isDefined( player.pers["team"] ) && player.pers["team"] == team && isdefined( player.pers["class"] ) )
		{
			if ( player.sessionstate == "playing" && !player.afk )
				break;
		}
	}
	
	if ( i == players.size )
		return;
	
	players[i] thread giveLastAttackerWarning();
	
	if(players[i].IN_MENU["RANK"]) iprintln(players[i].name+" is using the setting menu !");
}


giveLastAttackerWarning()
{
	self endon("death");
	self endon("disconnect");
	
	fullHealthTime = 0;
	interval = .05;
	
	while(1)
	{
		if ( self.health != self.maxhealth )
			fullHealthTime = 0;
		else
			fullHealthTime += interval;
		
		wait interval;
		
		if (self.health == self.maxhealth && fullHealthTime >= 3)
			break;
	}
	
	//self iprintlnbold(&"MP_YOU_ARE_THE_ONLY_REMAINING_PLAYER");
	self maps\mp\gametypes\_globallogic::leaderDialogOnPlayer( "last_alive" );
	
	self maps\mp\gametypes\_missions::lastManSD();
}


updateGametypeDvars()
{
	level.plantTime = dvarFloatValue( "planttime", 5, 0, 20 );
	level.defuseTime = dvarFloatValue( "defusetime", 5, 0, 20 );
	level.bombTimer = dvarFloatValue( "bombtimer", 45, 1, 300 );
	level.multiBomb = dvarIntValue( "multibomb", 0, 0, 1 );
}


bombs()
{
	level.bombPlanted = false;
	level.bombDefused = false;
	level.bombExploded = false;

	trigger = getEnt( "sd_bomb_pickup_trig", "targetname" );
	
	if ( !isDefined( trigger ) )
	{
		maps\mp\_utility::error("No sd_bomb_pickup_trig trigger found in map.");
		return;
	}
	
	visuals[0] = getEnt( "sd_bomb", "targetname" );
	
	if ( !isDefined( visuals[0] ) )
	{
		maps\mp\_utility::error("No sd_bomb script_model found in map.");
		return;
	}

	precacheModel( "prop_suitcase_bomb" );	
	visuals[0] setModel( "prop_suitcase_bomb" );
	
	if ( !level.multiBomb )
	{
		level.sdBomb = maps\mp\gametypes\_gameobjects::createCarryObject( game["attackers"], trigger, visuals, (0,0,32) );
		level.sdBomb maps\mp\gametypes\_gameobjects::allowCarry( "friendly" );
		level.sdBomb maps\mp\gametypes\_gameobjects::set2DIcon( "friendly", "compass_waypoint_bomb" );
		level.sdBomb maps\mp\gametypes\_gameobjects::set3DIcon( "friendly", "waypoint_bomb" );
		level.sdBomb maps\mp\gametypes\_gameobjects::setVisibleTeam( "friendly" );
		level.sdBomb maps\mp\gametypes\_gameobjects::setCarryIcon( "hud_suitcase_bomb" );
		level.sdBomb.allowWeapons = true;
		level.sdBomb.onPickup = ::onPickup;
		level.sdBomb.onDrop = ::onDrop;
	}
	else
	{
		trigger delete();
		visuals[0] delete();
	}
	
	
	level.bombZones = [];
	
	bombZones = getEntArray( "bombzone", "targetname" );
	
	for ( index = 0; index < bombZones.size; index++ )
	{
		trigger = bombZones[index];
		visuals = getEntArray( bombZones[index].target, "targetname" );
		
		bombZone = maps\mp\gametypes\_gameobjects::createUseObject( game["defenders"], trigger, visuals, (0,0,64) );
		bombZone maps\mp\gametypes\_gameobjects::allowUse( "enemy" );
		bombZone thread maps\mp\gametypes\_gameobjects::setUseTime( level.plantTime );
		bombZone maps\mp\gametypes\_gameobjects::setUseText( &"MP_PLANTING_EXPLOSIVE" );
		bombZone maps\mp\gametypes\_gameobjects::setUseHintText( &"PLATFORM_HOLD_TO_PLANT_EXPLOSIVES" );
		if ( !level.multiBomb )
			bombZone maps\mp\gametypes\_gameobjects::setKeyObject( level.sdBomb );
		label = bombZone maps\mp\gametypes\_gameobjects::getLabel();
		bombZone.label = label;
		bombZone maps\mp\gametypes\_gameobjects::set2DIcon( "friendly", "compass_waypoint_defend" + label );
		bombZone maps\mp\gametypes\_gameobjects::set3DIcon( "friendly", "waypoint_defend" + label );
		bombZone maps\mp\gametypes\_gameobjects::set2DIcon( "enemy", "compass_waypoint_target" + label );
		bombZone maps\mp\gametypes\_gameobjects::set3DIcon( "enemy", "waypoint_target" + label );
		bombZone maps\mp\gametypes\_gameobjects::setVisibleTeam( "any" );
		bombZone.onBeginUse = ::onBeginUse;
		bombZone.onEndUse = ::onEndUse;
		bombZone.onUse = ::onUsePlantObject;
		bombZone.onCantUse = ::onCantUse;
		bombZone.useWeapon = "briefcase_bomb_mp";
		
		for ( i = 0; i < visuals.size; i++ )
		{
			if ( isDefined( visuals[i].script_exploder ) )
			{
				bombZone.exploderIndex = visuals[i].script_exploder;
				break;
			}
		}
		
		level.bombZones[level.bombZones.size] = bombZone;
		
		bombZone.bombDefuseTrig = getent( visuals[0].target, "targetname" );
		assert( isdefined( bombZone.bombDefuseTrig ) );
		bombZone.bombDefuseTrig.origin += (0,0,-10000);
		bombZone.bombDefuseTrig.label = label;
	}
	
	for ( index = 0; index < level.bombZones.size; index++ )
	{
		array = [];
		for ( otherindex = 0; otherindex < level.bombZones.size; otherindex++ )
		{
			if ( otherindex != index )
				array[ array.size ] = level.bombZones[otherindex];
		}
		level.bombZones[index].otherBombZones = array;
	}
}


onBeginUse( player )
{
	if(self maps\mp\gametypes\_gameobjects::isFriendlyTeam( player.pers["team"] ) )
	{
		player playSound( "mp_bomb_defuse" );
		player.isDefusing = true;
		
		if ( isDefined( level.sdBombModel ) )
			level.sdBombModel hide();
	}
	else
	{
		player.isPlanting = true;

		if ( level.multibomb )
		{
			for ( i = 0; i < self.otherBombZones.size; i++ )
			{
				self.otherBombZones[i] maps\mp\gametypes\_gameobjects::disableObject();
			}
		}
	}
}

onEndUse( team, player, result )
{
	if ( !isAlive( player ) )
		return;
		
	player.isDefusing = false;
	player.isPlanting = false;

	if ( self maps\mp\gametypes\_gameobjects::isFriendlyTeam( player.pers["team"] ) )
	{
		if ( isDefined( level.sdBombModel ) && !result )
		{
			level.sdBombModel show();
		}
	}
	else
	{
		if ( level.multibomb && !result )
		{
			for ( i = 0; i < self.otherBombZones.size; i++ )
			{
				self.otherBombZones[i] maps\mp\gametypes\_gameobjects::enableObject();
			}
		}
	}
}

onCantUse( player )
{
	player iPrintLnBold( &"MP_CANT_PLANT_WITHOUT_BOMB" );
}

onUsePlantObject( player )
{
	// planted the bomb
	if ( !self maps\mp\gametypes\_gameobjects::isFriendlyTeam( player.pers["team"] ) )
	{
		level thread bombPlanted( self, player );
		player logString( "bomb planted: " + self.label );
		
		// disable all bomb zones except this one
		for ( index = 0; index < level.bombZones.size; index++ )
		{
			if ( level.bombZones[index] == self )
				continue;
				
			level.bombZones[index] maps\mp\gametypes\_gameobjects::disableObject();
		}
		
		player playSound( "mp_bomb_plant" );
		player notify ( "bomb_planted" );
		if ( !level.hardcoreMode )
			iPrintLn( &"MP_EXPLOSIVES_PLANTED_BY", player );
		maps\mp\gametypes\_globallogic::leaderDialog( "bomb_planted" );

		maps\mp\gametypes\_globallogic::givePlayerScore( "plant", player );
		player thread [[level.onXPEvent]]( "plant" );
	}
}

onUseDefuseObject( player )
{
	wait .05;
	
	player notify ( "bomb_defused" );
	player logString( "bomb defused: " + self.label );
	level thread bombDefused();
	
	// disable this bomb zone
	self maps\mp\gametypes\_gameobjects::disableObject();
	
	if ( !level.hardcoreMode )
		iPrintLn( &"MP_EXPLOSIVES_DEFUSED_BY", player );
	maps\mp\gametypes\_globallogic::leaderDialog( "bomb_defused" );

	maps\mp\gametypes\_globallogic::givePlayerScore( "defuse", player );
	player thread [[level.onXPEvent]]( "defuse" );
}


onDrop( player )
{
	if ( !level.bombPlanted )
	{
		if ( isDefined( player ) && isDefined( player.name ) )
			printOnTeamArg( &"MP_EXPLOSIVES_DROPPED_BY", game["attackers"], player );

//		maps\mp\gametypes\_globallogic::leaderDialog( "bomb_lost", player.pers["team"] );
		if ( isDefined( player ) )
		 	player logString( "bomb dropped" );
		 else
		 	logString( "bomb dropped" );
	}

	self maps\mp\gametypes\_gameobjects::set3DIcon( "friendly", "waypoint_bomb" );
	
	maps\mp\_utility::playSoundOnPlayers( game["bomb_dropped_sound"], game["attackers"] );
}


onPickup( player )
{
	player.isBombCarrier = true;

	self maps\mp\gametypes\_gameobjects::set3DIcon( "friendly", "waypoint_defend" );

	if ( !level.bombDefused )
	{
		if ( isDefined( player ) && isDefined( player.name ) )
			printOnTeamArg( &"MP_EXPLOSIVES_RECOVERED_BY", game["attackers"], player );
			
		maps\mp\gametypes\_globallogic::leaderDialog( "bomb_taken", player.pers["team"] );
		player logString( "bomb taken" );
	}		
	maps\mp\_utility::playSoundOnPlayers( game["bomb_recovered_sound"], game["attackers"] );
}


onReset()
{
}

IconBlink()
{
	self endon("disconnect");
	
	self.HUD_icon["BOMB"]["ICON"] = self createRectangle("BOTTOM","BOTTOM", 0,0 + self.AIO["safeArea_Y"]*-1, 30,30,(255/255,180/255,0/255),"hud_suitcase_bomb", 1, 1);
	self.HUD_icon["C4"]["ICON"] = self createRectangle("BOTTOM","BOTTOM", 0,-1 + self.AIO["safeArea_Y"]*-1, 20,20,(1,1,1), "hud_icon_c4",2, 1);

	for(i=50;i>0;i--)
	{
		if(i<7)
		{
			self.HUD_icon["BOMB"]["ICON"].alpha = .4;
			wait .249;
			self.HUD_icon["BOMB"]["ICON"].alpha = 1;
			self playlocalsound("ui_mp_suitcasebomb_timer");
			wait .249;
			self.HUD_icon["BOMB"]["ICON"].alpha = .4;
			self playlocalsound("ui_mp_suitcasebomb_timer");
			wait .249;
			self.HUD_icon["BOMB"]["ICON"].alpha = 1;
			self playlocalsound("ui_mp_suitcasebomb_timer");
			wait .249;
		}
		else if(i<15)
		{
			self.HUD_icon["BOMB"]["ICON"].alpha = .4;
			wait .5;
			self.HUD_icon["BOMB"]["ICON"].alpha = 1;
			self playlocalsound("ui_mp_suitcasebomb_timer");
			wait .5;
		}
		else if(i<51)
		{
			self.HUD_icon["BOMB"]["ICON"].alpha = .4;
			wait 1;
			self.HUD_icon["BOMB"]["ICON"].alpha = 1;
			wait 1;
			i--;
		}
		
		if(level.gameEnded) break;
		
		
	}
		
	self.HUD_icon["BOMB"]["ICON"] AdvancedDestroy(self);
	self.HUD_icon["C4"]["ICON"] AdvancedDestroy(self);
}


bombPlanted( destroyedObj, player )
{
	maps\mp\gametypes\_globallogic::pauseTimer();
	level.bombPlanted = true;
	
	destroyedObj.visuals[0] thread maps\mp\gametypes\_globallogic::playTickingSound();
	level.tickingObject = destroyedObj.visuals[0];

	level.timeLimitOverride = true;
	setGameEndTime(0);
	

	if(g("CS"))
	{
		level notify("bomb_planted");
		
		for(i=0;i<level.players.size;i++) 
			level.players[i] thread IconBlink();
	}
	else if(g("PROMOD_SD"))
	{
		
		for(a=0;a<level.players.size;a++)
		{
			player = level.players[a]; 
			
			player.stopWatch = player createRectangle("BOTTOM RIGHT", "BOTTOM RIGHT", -20 + player.AIO["safeArea_X"], -50 + player.AIO["safeArea_Y"]*-1, 0, 0, (1,1,1), "", 1, 1);
			player.stopWatch SetClock( level.bombTimer, 60, "hudStopwatch",60, 60 ); 
			//player.stopWatch = newClientHudElem(player);
			//player.stopWatch.archived = false;
			//player.stopWatch.align = "RIGHT";
			//player.stopWatch.relative = "RIGHT";
			//player.stopWatch.sort = 0;
			//player.stopWatch.alpha = 1;
			//player.stopWatch.x = 0;
			//player.stopWatch.y = 150;
			
		}
	}
	else
	{
		setGameEndTime( int( gettime() + (level.bombTimer * 1000) ) );
		setDvar( "ui_bomb_timer", 1 );
	}
	
	
	if ( !level.multiBomb )
	{
		level.sdBomb maps\mp\gametypes\_gameobjects::allowCarry( "none" );
		level.sdBomb maps\mp\gametypes\_gameobjects::setVisibleTeam( "none" );
		level.sdBomb maps\mp\gametypes\_gameobjects::setDropped();
		level.sdBombModel = level.sdBomb.visuals[0];
	}
	else
	{
		
		for ( index = 0; index < level.players.size; index++ )
		{
			if ( isDefined( level.players[index].carryIcon ) )
				level.players[index].carryIcon destroyElem();
		}

		trace = bulletTrace( player.origin + (0,0,20), player.origin - (0,0,2000), false, player );
		
		tempAngle = randomfloat( 360 );
		forward = (cos( tempAngle ), sin( tempAngle ), 0);
		forward = vectornormalize( forward - vector_scale( trace["normal"], vectordot( forward, trace["normal"] ) ) );
		dropAngles = vectortoangles( forward );
		
		level.sdBombModel = spawn( "script_model", trace["position"] );
		level.sdBombModel.angles = dropAngles;
		level.sdBombModel setModel( "prop_suitcase_bomb" );
	}
	destroyedObj maps\mp\gametypes\_gameobjects::allowUse( "none" );
	destroyedObj maps\mp\gametypes\_gameobjects::setVisibleTeam( "none" );
	/*
	destroyedObj maps\mp\gametypes\_gameobjects::set2DIcon( "friendly", undefined );
	destroyedObj maps\mp\gametypes\_gameobjects::set2DIcon( "enemy", undefined );
	destroyedObj maps\mp\gametypes\_gameobjects::set3DIcon( "friendly", undefined );
	destroyedObj maps\mp\gametypes\_gameobjects::set3DIcon( "enemy", undefined );
	*/
	label = destroyedObj maps\mp\gametypes\_gameobjects::getLabel();
	
	// create a new object to defuse with.
	trigger = destroyedObj.bombDefuseTrig;
	trigger.origin = level.sdBombModel.origin;
	visuals = [];
	defuseObject = maps\mp\gametypes\_gameobjects::createUseObject( game["defenders"], trigger, visuals, (0,0,32) );
	defuseObject maps\mp\gametypes\_gameobjects::allowUse( "friendly" );
	defuseObject thread maps\mp\gametypes\_gameobjects::setUseTime( level.defuseTime );
	defuseObject maps\mp\gametypes\_gameobjects::setUseText( &"MP_DEFUSING_EXPLOSIVE" );
	defuseObject maps\mp\gametypes\_gameobjects::setUseHintText( &"PLATFORM_HOLD_TO_DEFUSE_EXPLOSIVES" );
	defuseObject maps\mp\gametypes\_gameobjects::setVisibleTeam( "any" );
	defuseObject maps\mp\gametypes\_gameobjects::set2DIcon( "friendly", "compass_waypoint_defuse" + label );
	defuseObject maps\mp\gametypes\_gameobjects::set2DIcon( "enemy", "compass_waypoint_defend" + label );
	defuseObject maps\mp\gametypes\_gameobjects::set3DIcon( "friendly", "waypoint_defuse" + label );
	defuseObject maps\mp\gametypes\_gameobjects::set3DIcon( "enemy", "waypoint_defend" + label );
	defuseObject.label = label;
	defuseObject.onBeginUse = ::onBeginUse;
	defuseObject.onEndUse = ::onEndUse;
	defuseObject.onUse = ::onUseDefuseObject;
	defuseObject.useWeapon = "briefcase_bomb_defuse_mp";
	
	BombTimerWait();
	setDvar( "ui_bomb_timer", 0 );
	
	destroyedObj.visuals[0] maps\mp\gametypes\_globallogic::stopTickingSound();
	
	if ( level.gameEnded || level.bombDefused )
		return;
	
	level.bombExploded = true;
	
	explosionOrigin = level.sdBombModel.origin;
	level.sdBombModel hide();
	
	if ( isdefined( player ) )
		destroyedObj.visuals[0] radiusDamage( explosionOrigin, 512, 200, 20, player );
	else
		destroyedObj.visuals[0] radiusDamage( explosionOrigin, 512, 200, 20 );
	
	rot = randomfloat(360);
	explosionEffect = spawnFx( level._effect["bombexplosion"], explosionOrigin + (0,0,50), (0,0,1), (cos(rot),sin(rot),0) );
	triggerFx( explosionEffect );
	
	thread playSoundinSpace( "exp_suitcase_bomb_main", explosionOrigin );
	
	if ( isDefined( destroyedObj.exploderIndex ) )
		exploder( destroyedObj.exploderIndex );
	
	for ( index = 0; index < level.bombZones.size; index++ )
		level.bombZones[index] maps\mp\gametypes\_gameobjects::disableObject();
	defuseObject maps\mp\gametypes\_gameobjects::disableObject();
	
	setGameEndTime( 0 );
	
	wait 3;
	
	sd_endGame( game["attackers"], game["strings"]["target_destroyed"] );
}

BombTimerWait()
{
	level endon("game_ended");
	level endon("bomb_defused");
	wait level.bombTimer;
}

playSoundinSpace( alias, origin )
{
	org = spawn( "script_origin", origin );
	org.origin = origin;
	org playSound( alias  );
	wait 10; // MP doesn't have "sounddone" notifies =(
	org delete();
}

bombDefused()
{
	level.tickingObject maps\mp\gametypes\_globallogic::stopTickingSound();
	level.bombDefused = true;
	setDvar( "ui_bomb_timer", 0 );
	
	level notify("bomb_defused");
	
	wait 1.5;
	
	setGameEndTime( 0 );
	
	sd_endGame( game["defenders"], game["strings"]["bomb_defused"] );
}


