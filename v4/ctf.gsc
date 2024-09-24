#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;

main()
{
	if(getdvar("mapname") == "mp_background")
		return;
	
	setdvar("g_gametype","ctf");
	setdvar("party_gametype","ctf");
	setdvar("ui_gametype","ctf");
	
	setdvar("scr_ctf_playerrespawndelay","0");
	setdvar("scr_player_respawndelay","0");
	
		 
	maps\mp\gametypes\_globallogic::init();
	maps\mp\gametypes\_callbacksetup::SetupCallbacks();
	maps\mp\gametypes\_globallogic::SetupCallbacks();
	
	maps\mp\gametypes\_globallogic::registerTimeLimitDvar( "ctf", 15, 0, 1440 );
	maps\mp\gametypes\_globallogic::registerScoreLimitDvar( "ctf", 0, 0, 0000 );
	maps\mp\gametypes\_globallogic::registerRoundLimitDvar( "ctf", 2, 0, 10 );
	maps\mp\gametypes\_globallogic::registerRoundSwitchDvar( "ctf", 1, 0, 9 );
	maps\mp\gametypes\_globallogic::registerNumLivesDvar( "ctf", 0, 0, 0 );

	//if ( getdvar("scr_ctf_spawnPointFacingAngle") == "" ) //WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW
		//setdvar("scr_ctf_spawnPointFacingAngle", "60");

	level.teamBased = true;
	level.overrideTeamScore = true;
	
	level.onStartGameType = ::onStartGameType;
	level.onSpawnPlayer = ::onSpawnPlayer;
	level.onSpawnPlayerUnified = ::onSpawnPlayerUnified; //WWWW
	level.onPrecacheGameType = ::onPrecacheGameType;
	level.onPlayerKilled = ::onPlayerKilled;
	
	
	level.onRoundSwitch = ::onRoundSwitch;
	level.onRoundEndGame = ::onRoundEndGame;
	level.onEndGame = ::onEndGame;
	level.onTeamOutcomeNotify = ::onTeamOutcomeNotify;
	level.getTeamKillPenalty = ::ctf_getTeamKillPenalty;
	level.getTeamKillScore = ::ctf_getTeamKillScore;
	
//	level.onScoreLimit = ::onScoreLimit;
//	level.endGameOnScoreLimit = false;
	level.scoreLimitIsPerRound = true;
	
	
	if (!isdefined( game["ctf_teamscore"]))
	{
		game["ctf_teamscore"]["allies"] = 0;
		game["ctf_teamscore"]["axis"] = 0;
	}

	//game["dialog"]["gametype"] = "domination";  FROM DOM
	//game["dialog"]["offense_obj"] = "capture_objs";
	//game["dialog"]["defense_obj"] = "capture_objs";
		
	game["dialog"]["gametype"] = "ctf";
	game["dialog"]["wetake_flag"] = "wetake_flag";
	game["dialog"]["theytake_flag"] = "theytake_flag";
	game["dialog"]["theydrop_flag"] = "theydrop_flag";
	game["dialog"]["wedrop_flag"] = "wedrop_flag";
	game["dialog"]["wereturn_flag"] = "wereturn_flag";
	game["dialog"]["theyreturn_flag"] = "theyreturn_flag";
	game["dialog"]["theycap_flag"] = "theycap_flag";
	game["dialog"]["wecap_flag"] = "wecap_flag";
	game["dialog"]["offense_obj"] = "ctf_boost";
	game["dialog"]["defense_obj"] = "ctf_boost";

	level.lastDialogTime = getTime();
}

onPrecacheGameType()
{
	game["flag_dropped_sound"] = "mp_war_objective_lost";
	game["flag_recovered_sound"] = "mp_war_objective_taken";
	
	game["flagmodels"] = [];
	game["carry_flagmodels"] = [];
	game["carry_icon"] = [];
	game["waypoints_flag"] = [];
	game["waypoints_base"] = [];
	game["compass_waypoint_flag"] = [];
	game["compass_waypoint_base"] = [];

	if ( game["allies"] == "marines" )
	{
		//level.AlliesCircle = loadFX("misc/ui_flagbase_silver");
		//level.AlliesFlagModel = "prop_flag_american";
		
		game["flagmodels"]["allies"] = "prop_flag_american";
		game["carry_flagmodels"]["allies"] = "prop_flag_american_carry";
		game["waypoints_flag"]["allies"] = "waypoint_flag_american";
		game["waypoints_base"]["allies"] = "waypoint_flag_x_american";
		game["compass_waypoint_flag"]["allies"] = "compass_flag_american";
		game["compass_waypoint_base"]["allies"] = "compass_noflag_american";
		game["carry_icon"]["allies"] = "hudicon_american_ctf_flag_carry";
	}
	else
	{
		//SAS
		//level.AlliesCircle = loadFX("misc/ui_flagbase_black");
		//level.AlliesFlagModel = "";
		game["flagmodels"]["axis"] = "prop_flag_brit";
		game["carry_flagmodels"]["axis"] = "prop_flag_german_carry";
		game["waypoints_flag"]["axis"] = "waypoint_flag_german";
		game["waypoints_base"]["axis"] = "waypoint_flag_x_german";
		game["compass_waypoint_flag"]["axis"] = "compass_flag_german";
		game["compass_waypoint_base"]["axis"] = "compass_noflag_german";
		game["carry_icon"]["axis"] = "hudicon_german_ctf_flag_carry";
		
	}
	
	if ( game["axis"] == "russian" ) 
	{
		//level.AxisCircle = loadFX("misc/ui_flagbase_red");
		//level.AxisFlagModel = "prop_flag_russian";
		
		game["flagmodels"]["allies"] = "prop_flag_russian";
		game["carry_flagmodels"]["allies"] = "prop_flag_russian_carry";
		game["waypoints_flag"]["allies"] = "waypoint_flag_russian";
		game["waypoints_base"]["allies"] = "waypoint_flag_x_russian";
		game["compass_waypoint_flag"]["allies"] = "compass_flag_russian";
		game["compass_waypoint_base"]["allies"] = "compass_noflag_russian";
		game["carry_icon"]["allies"] = "hudicon_russian_ctf_flag_carry";
	}
	else
	{
		//opfor
		//level.AxisCircle = loadFX("misc/ui_flagbase_gold");
		//level.AxisFlagModel = "prop_flag_opfor";
		
		game["flagmodels"]["axis"] = "prop_flag_opfor";
		game["carry_flagmodels"]["axis"] = "prop_flag_japanese_carry";
		game["waypoints_flag"]["axis"] = "waypoint_flag_japanese";
		game["waypoints_base"]["axis"] = "waypoint_flag_x_japanese";
		game["compass_waypoint_flag"]["axis"] = "compass_flag_japanese";
		game["compass_waypoint_base"]["axis"] = "compass_noflag_japanese";
		game["carry_icon"]["axis"] = "hudicon_japanese_ctf_flag_carry";
	}
	
	precacheModel( game["flagmodels"]["allies"] );
	precacheModel( game["flagmodels"]["axis"] );
	precacheModel( game["carry_flagmodels"]["allies"] );
	precacheModel( game["carry_flagmodels"]["axis"] );

	precacheShader( game["waypoints_flag"]["allies"] );
	precacheShader( game["waypoints_base"]["allies"] );
	precacheShader( game["compass_waypoint_flag"]["allies"] );
	precacheShader( game["compass_waypoint_base"]["allies"] );
	precacheShader( game["carry_icon"]["allies"] );
	
	precacheShader( game["waypoints_flag"]["axis"] );
	precacheShader( game["waypoints_base"]["axis"] );
	precacheShader( game["compass_waypoint_flag"]["axis"] );
	precacheShader( game["compass_waypoint_base"]["axis"] );
	precacheShader( game["carry_icon"]["axis"] );
	
	precacheString(&"MP_FLAG_TAKEN_BY");
	precacheString(&"MP_ENEMY_FLAG_TAKEN_BY");
	precacheString(&"MP_FLAG_CAPTURED_BY");
	precacheString(&"MP_ENEMY_FLAG_CAPTURED_BY");
	//precacheString(&"MP_FLAG_RETURNED_BY");
	precacheString(&"MP_FLAG_RETURNED");
	precacheString(&"MP_ENEMY_FLAG_RETURNED");
	precacheString(&"MP_YOUR_FLAG_RETURNING_IN");
	precacheString(&"MP_ENEMY_FLAG_RETURNING_IN");
	precacheString(&"MP_ENEMY_FLAG_DROPPED_BY");
	precacheString(&"MP_SUDDEN_DEATH");
	precacheString(&"MP_CAP_LIMIT_REACHED");
	precacheString(&"MP_CTF_CANT_CAPTURE_FLAG" );
	
	game["strings"]["score_limit_reached"] = &"MP_CAP_LIMIT_REACHED";

}

onStartGameType()
{
	if ( !isdefined( game["switchedsides"] ) )
		game["switchedsides"] = false;

	
	
	setClientNameMode("auto_change");

	ctf_setTeamScore( "allies", 0 );
	ctf_setTeamScore( "axis", 0 );

	maps\mp\gametypes\_globallogic::setObjectiveText( "allies", &"OBJECTIVES_CTF" );
	maps\mp\gametypes\_globallogic::setObjectiveText( "axis", &"OBJECTIVES_CTF" );
	
	if ( level.splitscreen )
	{
		maps\mp\gametypes\_globallogic::setObjectiveScoreText( "allies", &"OBJECTIVES_CTF" );
		maps\mp\gametypes\_globallogic::setObjectiveScoreText( "axis", &"OBJECTIVES_CTF" );
	}
	else
	{
		maps\mp\gametypes\_globallogic::setObjectiveScoreText( "allies", &"OBJECTIVES_CTF_SCORE" );
		maps\mp\gametypes\_globallogic::setObjectiveScoreText( "axis", &"OBJECTIVES_CTF_SCORE" );
	}
	maps\mp\gametypes\_globallogic::setObjectiveHintText( "allies", &"OBJECTIVES_CTF_HINT" );
	maps\mp\gametypes\_globallogic::setObjectiveHintText( "axis", &"OBJECTIVES_CTF_HINT" );
			
	level.spawnMins = ( 0, 0, 0 );
	level.spawnMaxs = ( 0, 0, 0 );	
	maps\mp\gametypes\_spawnlogic::placeSpawnPoints( "mp_ctf_spawn_allies_start" );
	maps\mp\gametypes\_spawnlogic::placeSpawnPoints( "mp_ctf_spawn_axis_start" );
	maps\mp\gametypes\_spawnlogic::addSpawnPoints( "allies", "mp_ctf_spawn_allies" );
	maps\mp\gametypes\_spawnlogic::addSpawnPoints( "axis", "mp_ctf_spawn_axis" );
	//maps\mp\gametypes\_spawning::updateAllSpawnPoints();
	
	level.mapCenter = maps\mp\gametypes\_spawnlogic::findBoxCenter( level.spawnMins, level.spawnMaxs );
	setMapCenter( level.mapCenter );
	
	level.spawn_axis = maps\mp\gametypes\_spawnlogic::getSpawnpointArray( "mp_ctf_spawn_axis" );
	level.spawn_allies = maps\mp\gametypes\_spawnlogic::getSpawnpointArray( "mp_ctf_spawn_allies" );
	level.spawn_axis_start = maps\mp\gametypes\_spawnlogic::getSpawnpointArray( "mp_ctf_spawn_axis_start" );
	level.spawn_allies_start = maps\mp\gametypes\_spawnlogic::getSpawnpointArray( "mp_ctf_spawn_allies_start" );

	maps\mp\gametypes\_rank::registerScoreInfo( "capture", 100 );
	maps\mp\gametypes\_rank::registerScoreInfo( "defend", 10 );
	maps\mp\gametypes\_rank::registerScoreInfo( "kill_carrier", 10 );

	allowed[0] = "ctf";
	maps\mp\gametypes\_gameobjects::main(allowed);
	
	// now that the game objects have been deleted place the influencers
	//maps\mp\gametypes\_spawning::create_map_placed_influencers();

	thread updateGametypeDvars();
	
	thread ctf();
}

ctf()
{
	level.flags = [];
	level.teamFlags = [];
	level.flagZones = [];
	level.teamFlagZones = [];
	
	level.iconCapture3D = "waypoint_capture";
	level.iconCapture2D = "compass_waypoint_capture";
	
	level.iconDefend3D = "waypoint_defend";
	level.iconDefend2D = "compass_waypoint_defend";
	
	level.iconTakenFriendly3D = "waypoint_taken_friendly";
	level.iconTakenEnemy3D = "waypoint_taken_enemy";
	
	level.iconTakenFriendly2D = "compass_waypoint_taken_friendly";
	level.iconTakenEnemy2D = "compass_waypoint_taken_enemy";
	
	level.iconDropped3D = "waypoint_defend";
	level.iconCarrier3D = "waypoint_flag_yellow";
	
	level.iconEnemyCarrier3D = "waypoint_kill";
	level.iconReturn3D = "waypoint_return";
	level.iconBase3D = "waypoint_capture";
	
	precacheShader( level.iconCapture3D );
	precacheShader( level.iconDefend3D );
	precacheShader( level.iconCapture2D );
	precacheShader( level.iconDefend2D );
	precacheShader( level.iconTakenFriendly3D );
	precacheShader( level.iconTakenEnemy3D );
	precacheShader( level.iconTakenFriendly2D );
	precacheShader( level.iconTakenEnemy2D );
	precacheShader( level.iconDropped3D );
	precacheShader( level.iconCarrier3D );
	precacheShader( level.iconReturn3D );
	precacheShader( level.iconBase3D );
	precacheShader( level.iconEnemyCarrier3D );

	flagBaseFX = [];
	flagBaseFX["marines"] = "misc/ui_flagbase_silver";
	flagBaseFX["sas"] = "misc/ui_flagbase_black";
	flagBaseFX["opfor"] = "misc/ui_flagbase_gold";
	flagBaseFX["russian"] = "misc/ui_flagbase_red";
	
	level.flagBaseFXid[ "allies" ] = loadfx( flagBaseFX[ game[ "allies" ] ] );
	level.flagBaseFXid[ "axis"   ] = loadfx( flagBaseFX[ game[ "axis"   ] ] );

	level.leFLAG = [];
	
	entitytypes = getentarray();
	for(i=0;i<entitytypes.size;i++)
	{
		//ctf_trig_allies ctf_trig_axis || ctf_flag_allies ctf_flag_axis || ctf_zone_allies ctf_zone_axis
			
		if(isDefined(entitytypes[i].targetname) && entitytypes[i].targetname == "ctf_flag_allies")
			level.leFLAG["allies"] = entitytypes[i];
		
		if(isDefined(entitytypes[i].targetname) && entitytypes[i].targetname == "ctf_flag_axis")
			level.leFLAG["axis"] = entitytypes[i];
		
		//ZONE
		if(isDefined(entitytypes[i].targetname) && entitytypes[i].targetname == "ctf_zone_allies")
		{
			
			entitytypes[i].script_team = "allies";
			flagZone = createFlagZone( entitytypes[i] );
			level.flagZones[level.flagZones.size] = flagZone;		
			level.teamFlagZones["allies"] = flagZone;		
			level.flagHints["allies"] = createFlagHint( "allies", entitytypes[i].origin );				
		}
		if(isDefined(entitytypes[i].targetname) && entitytypes[i].targetname == "ctf_zone_axis")
		{
			entitytypes[i].script_team = "axis";
			flagZone = createFlagZone( entitytypes[i] );
			level.flagZones[level.flagZones.size] = flagZone;		
			level.teamFlagZones["axis"] = flagZone;		
			level.flagHints["axis"] = createFlagHint( "axis", entitytypes[i].origin );		
		}
	}
	
	level.leFLAG["allies"].script_team = "allies";
	level.leFLAG["axis"].script_team = "axis";
	
	flagAllies = createFlag(level.leFLAG["allies"]);
	flagAxis = createFlag(level.leFLAG["axis"]);
	
	level.secondOrigine = [];
	level.secondOrigine["allies"] = level.leFLAG["allies"].origin;
	level.secondOrigine["axis"] = level.leFLAG["axis"].origin;
	
	level.Flagpickedonzone["allies"] = false;
	level.Flagpickedonzone["axis"] = false;
	
	createReturnMessageElems();
}


createFlag( trigger )
{		
	
	//if ( isDefined( trigger.target ) )
	//{
		//visuals[0] = getEnt( trigger.target, "targetname" );
	//}
	//else
	{
		visuals[0] = spawn( "script_model", trigger.origin );
		visuals[0].angles = trigger.angles;
	}

	entityTeam = trigger.script_team;
	
	if ( game["switchedsides"] )
		entityTeam = getOtherTeam( entityTeam );

	trigger setModel( game["flagmodels"][entityTeam] );

	
	
			
	//test = maps\mp\gametypes\_gameobjects::createUseObject( entityTeam, trigger, trigger,(0,0,100) );
	//test maps\mp\gametypes\_gameobjects::set2DIcon( "enemy", "ui_host" );
	//test maps\mp\gametypes\_gameobjects::set2DIcon( "friendly", "ui_host" );
		
		
	//self maps\mp\gametypes\_gameobjects::allowUse( "enemy" );
	//self maps\mp\gametypes\_gameobjects::setUseTime( level.plantTime );
	//self maps\mp\gametypes\_gameobjects::setUseText( &"MP_PLANTING_EXPLOSIVE" );
	//self maps\mp\gametypes\_gameobjects::setUseHintText( &"PLATFORM_HOLD_TO_PLANT_EXPLOSIVES" );
	//self maps\mp\gametypes\_gameobjects::setKeyObject( level.sabBomb );
	
	//self maps\mp\gametypes\_gameobjects::set3DIcon( "friendly", "waypoint_defend" );
	
	//self maps\mp\gametypes\_gameobjects::set3DIcon( "enemy", "waypoint_target" );
	//self maps\mp\gametypes\_gameobjects::setVisibleTeam( "none" );
	//self.useWeapon = "briefcase_bomb_mp";
		
		
		
	
	
	
	
	
	
	
	
	
	
	
	
	flag = maps\mp\gametypes\_gameobjects::createCarryObject( entityTeam, trigger, visuals, (0,0,100) );
	flag maps\mp\gametypes\_gameobjects::allowCarry( "enemy" );
	flag maps\mp\gametypes\_gameobjects::setVisibleTeam( "any" );
	flag maps\mp\gametypes\_gameobjects::setVisibleCarrierModel( game["carry_flagmodels"][entityTeam] );
//	flag maps\mp\gametypes\_gameobjects::setCarryIcon( game["carry_icon"][entityTeam] );
	flag maps\mp\gametypes\_gameobjects::set2DIcon( "friendly", level.iconDefend2D );
	flag maps\mp\gametypes\_gameobjects::set3DIcon( "friendly", level.iconDefend3D );
	flag maps\mp\gametypes\_gameobjects::set2DIcon( "enemy", level.iconCapture2D );
	flag maps\mp\gametypes\_gameobjects::set3DIcon( "enemy", level.iconCapture3D );
	flag maps\mp\gametypes\_gameobjects::setCarryIcon( game["compass_waypoint_flag"][entityTeam] );

	if ( level.enemyCarrierVisible == 2 )
	{
		flag.objIDPingFriendly = true;
	}
	
	//flag.allowWeapons = true;
	//flag.onPickup = ::onPickup;
	//flag.onPickupFailed = ::onPickup;
	//flag.onDrop = ::onDrop;
	//flag.onReset = ::onReset;
			
	if ( level.idleFlagReturnTime > 0 )
	{
		flag.autoResetTime = level.idleFlagReturnTime;
	}
	else
	{
		flag.autoResetTime = undefined;
	}		
	
	flag thread watchpickupflag(entityTeam,trigger);
}

watchpickupflag(flagteam,trigger)
{
	level endon("game_ended");
	
	
	autreteam = getOtherTeam( flagteam );
	
	while(true)
	{
		for(i=0;i<level.players.size;i++)
		{
			player = level.players[i];
			
			//EQUIPE ALLIES CAPTURE
			if(Distance(level.leFLAG[flagteam].origin,player.origin) < 50) // !)
			{
				//iprintln("1st");
				
				//if(!level.Flagpickedonzone[flagteam])
				{
					if(player.pers["team"] != flagteam && !player.hasFlag && isAlive(player))
					{
						//printAndSoundOnEveryone( team, otherteam, printFriendly, printEnemy, soundFriendly, soundEnemy, printarg )
						printAndSoundOnEveryone( flagteam, autreteam, "ennemi prit drapeau", &"MP_ENEMY_FLAG_TAKEN_BY", "mp_obj_returned", "" ,player);

						
						player iprintlnbold("captured");
						level.leFLAG[flagteam] hide();
						player attach(game["flagmodels"][flagteam],"J_spine4");
						level.Flagpickedonzone[flagteam] = true; 
						player.hasFlag = true;
						
						player thread FollowFlagCapture();
						
					}
				}
					if(player.pers["team"] == flagteam && level.Flagpickedonzone[flagteam] && isAlive(player))
					{
						printAndSoundOnEveryone( flagteam, "none", &"MP_FLAG_RETURNED_BY", "", "mp_obj_returned", "", player );

						player iprintlnbold("returned");
						level.leFLAG[flagteam].origin = level.secondOrigine[flagteam];
						level.leFLAG[flagteam] setorigin(level.secondOrigine[flagteam]);
						
						level.leFLAG[flagteam] show();
						level.Flagpickedonzone[flagteam] = false;
					}
		
			}
			
			
			
			//precacheString(&"MP_FLAG_TAKEN_BY");
	//precacheString(&"MP_ENEMY_FLAG_TAKEN_BY");
	//precacheString(&"MP_FLAG_CAPTURED_BY");
	//precacheString(&"MP_ENEMY_FLAG_CAPTURED_BY");
	////precacheString(&"MP_FLAG_RETURNED_BY");
	//precacheString(&"MP_FLAG_RETURNED");
	//precacheString(&"MP_ENEMY_FLAG_RETURNED");
	//precacheString(&"MP_YOUR_FLAG_RETURNING_IN");
	//precacheString(&"MP_ENEMY_FLAG_RETURNING_IN");
	//precacheString(&"MP_ENEMY_FLAG_DROPPED_BY");
	//precacheString(&"MP_SUDDEN_DEATH");
	
	//precacheString(&"MP_CAP_LIMIT_REACHED");
	//precacheString(&"MP_CTF_CANT_CAPTURE_FLAG" );
	//self.hasFlag = [];
	//self.hasFlag["allies"] = false;
	//self.hasFlag["axis"] = false;
	
		//if(self.hasFlag)
		//{
			//autreteam = getOtherTeam( self.pers["team"] );
			
			//level.leFLAG[autreteam].origin = self GetGround();
			//level.leFLAG[autreteam] setorigin(self GetGround());
			//level.leFLAG[autreteam] show();
			//self.hasFlag = false;
			
		//}
	//}
//}

			
			
			
			if(Distance(level.secondOrigine[autreteam],player.origin) < 50 && player.hasFlag)
			{
				if(player.hasFlag && player.pers["team"] == autreteam && isAlive(player))
				{
					printAndSoundOnEveryone( flagteam, autreteam, &"MP_FLAG_CAPTURED_BY",&"MP_ENEMY_FLAG_CAPTURED_BY" , "mp_obj_captured", "mp_enemy_obj_captured", player );

					player iprintlnbold("gagnee");
					player detach(game["flagmodels"][flagteam],"J_spine4");
					level.leFLAG[flagteam].origin = level.secondOrigine[flagteam];
					level.leFLAG[flagteam] setorigin(level.secondOrigine[flagteam]);
					level.Flagpickedonzone[flagteam] = false; 
					level.leFLAG[flagteam] show();
					//printAndSoundOnEveryone( flagteam, autreteam, "ennemi prit drapeau", "captured", "mp_obj_returned", "" ,"");
					player.hasFlag = false;
				}
			}
			
			  
				

			}
			/*
			if(Distance(level.leFLAG[flagteam].origin,player.origin) < 50 && player.hasFlag)
			{
				level.leFLAG[autreteam] show();
				level.alliesflagpicked = true;
				
				level.players[i] iprintlnbold("rapport?");
				level.players[i].hasFlag = false;
				
				autreteam = getOtherTeam( flagteam );
			  //printAndSoundOnEveryone( team, otherteam, printFriendly, printEnemy, soundFriendly, soundEnemy, printarg )
				printAndSoundOnEveryone( flagteam, autreteam, "perdu", "rapport?", "mp_obj_returned", "" ,"");

				level.players[i] Detach(game["flagmodels"][autreteam],"J_spine4");
					
				wait .1;
			}
*/
			
		
		wait .05;
	}
}

FollowFlagCapture()
{
	
	self endon("disconnect");
	
	while(self.hasFlag)
	{
		
		//objective_add( carryObject.objIDAllies, "invisible", carryObject.curOrigin );
		//objective_add( carryObject.objIDAxis, "invisible", carryObject.curOrigin );
		//objective_team( carryObject.objIDAllies, "allies" );
		//objective_team( carryObject.objIDAxis, "axis" );
		
	
		objective_add(11, "invisible", (0,0,0));
		objective_icon(11, "compass_waypoint_capture");
		objective_position(11, self.origin);
		objective_state(11, "active");
		objective_team(11,self.team);
		
		self ViewKick( 127, self.origin );
		//objective_icon(11, "compass_waypoint_capture");
		
		for(i=0;i<3 && self.hasFlag;i++)
			wait 1;

		Objective_Delete(11);
	}
	Objective_Delete(11);
}



createFlagZone( trigger )
{
	visuals = [];
	
	entityTeam = trigger.script_team;
	
	if ( game["switchedsides"] )
		entityTeam = getOtherTeam( entityTeam );

	flagZone = maps\mp\gametypes\_gameobjects::createUseObject( entityTeam, trigger, visuals, (0,0,100) );
	//flagZone maps\mp\gametypes\_gameobjects::allowUse( "friendly" );
	//flagZone maps\mp\gametypes\_gameobjects::setUseTime( 0 );
	//flagZone maps\mp\gametypes\_gameobjects::setUseText( "CAPTURE FLAG" );
	//flagZone maps\mp\gametypes\_gameobjects::setVisibleTeam( "none" );
	flagZone maps\mp\gametypes\_gameobjects::set2DIcon( "friendly", level.iconTakenFriendly2D );
	//flagZone maps\mp\gametypes\_gameobjects::set3DIcon( "friendly", level.iconTakenFriendly3D );
	flagZone maps\mp\gametypes\_gameobjects::set2DIcon( "enemy", level.iconTakenEnemy2D );
	//flagZone maps\mp\gametypes\_gameobjects::set3DIcon( "enemy", level.iconTakenEnemy3D );

	enemyTeam = getOtherTeam( entityTeam );
	
	//flagZone maps\mp\gametypes\_gameobjects::setKeyObject( level.teamFlags[enemyTeam] );
	//flagZone.onUse = ::onCapture;
	
	flag = level.teamFlags[entityTeam];
	flag.flagBase = flagZone;
	flagZone.flag = flag;
	
	traceStart = trigger.origin + (0,0,32);
	traceEnd = trigger.origin + (0,0,-32);
	trace = bulletTrace( traceStart, traceEnd, false, undefined );

	upangles = vectorToAngles( trace["normal"] );
	flagZone.baseeffectforward = anglesToForward( upangles );
	flagZone.baseeffectright = anglesToRight( upangles );
	
	flagZone.baseeffectpos = trace["position"];
	
	flagZone thread resetFlagBaseEffect();
	
	flagZone createFlagSpawnInfluencer( entityTeam );
	
	return flagZone;
//		flag resetIcons();
}

onCapture( player )
{
	team = player.pers["team"];
	enemyTeam = getOtherTeam( team );
	
	playerTeamsFlag = level.teamFlags[team];
	
	// is players team flag away from base?
	if ( playerTeamsFlag maps\mp\gametypes\_gameobjects::isObjectAwayFromHome() && level.touchReturn )
	{
		return;
	}

	printAndSoundOnEveryone( team, enemyTeam, &"MP_ENEMY_FLAG_CAPTURED_BY", &"MP_FLAG_CAPTURED_BY", "mp_obj_captured", "mp_enemy_obj_captured", player );

	thread playSoundOnPlayers( "mx_CTF_score"+"_"+level.teamPrefix[team] );
	
	if( getTime() - level.lastDialogTime > 1500 )
	{
		maps\mp\gametypes\_globallogic::leaderDialog( "wecap_flag", team );
		maps\mp\gametypes\_globallogic::leaderDialog( "theycap_flag", enemyTeam );
		level.lastDialogTime = getTime();
	}

	
	//player setStatLBByName( "CTF_Flags", 1, "Captured");
	player thread giveFlagCaptureXP( player );

	player logString( enemyTeam + " flag captured" );

	flag = player.carryObject;
	
	flag.dontAnnounceReturn = true;
	flag maps\mp\gametypes\_gameobjects::returnHome();
	flag.dontAnnounceReturn = undefined;
	
	level.teamFlags[level.otherTeam[team]] maps\mp\gametypes\_gameobjects::allowCarry( "enemy" );
	level.teamFlags[level.otherTeam[team]] maps\mp\gametypes\_gameobjects::setVisibleTeam( "any" );
	level.teamFlags[level.otherTeam[team]] maps\mp\gametypes\_gameobjects::returnHome();
	level.teamFlagZones[level.otherTeam[team]] maps\mp\gametypes\_gameobjects::allowUse( "friendly" );

	player.isFlagCarrier = false;
	player deleteBaseIcon();

	// execution will stop on this line on last flag cap of a level
	[[level._setTeamScore]]( team, [[level._getTeamScore]]( team ) + 1 );

	//if( game["teamScores"]["allies"] == level.scoreLimit - 1 || game["teamScores"]["axis"] == level.scoreLimit - 1 )
		//setMusicState( "MATCH_END" );
}
createFlagHint( team, origin )
{
	radius = 128;
	height = 64;
	
	trigger = spawn("trigger_radius", origin, 0, radius, height);
	trigger setHintString( "CANT CAPTURE FLAG" );
	trigger setcursorhint("HINT_NOICON");
	trigger.original_origin = origin;
	
	trigger turn_off();
	
	return trigger;
}

ctf_setTeamScore( team, teamScore )
{
	if ( teamScore == game["teamScores"][team] )
		return;

	game["teamScores"][team] = teamScore;
	
	maps\mp\gametypes\_globallogic::updateTeamScores( team );
}

onRoundSwitch()
{
	if ( !isdefined( game["switchedsides"] ) )
		game["switchedsides"] = false;
	
	game["switchedsides"] = !game["switchedsides"];
}

onScoreLimit()
{
	if ( maps\mp\gametypes\_globallogic::hitRoundLimit())
	{
		level.endGameOnScoreLimit = true;
		maps\mp\gametypes\_globallogic::default_onScoreLimit();
		return;
	}	
	
	winner = undefined;
	
	if ( game["teamScores"]["allies"] == game["teamScores"]["axis"] )
		winner = "tie";
	else if ( game["teamScores"]["axis"] > game["teamScores"]["allies"] )
		winner = "axis";
	else
		winner = "allies";
	logString( "scorelimit, win: " + winner + ", allies: " + game["teamScores"]["allies"] + ", axis: " + game["teamScores"]["axis"] );
	
	makeDvarServerInfo( "ui_text_endreason", game["strings"]["score_limit_reached"] );
	setDvar( "ui_text_endreason", game["strings"]["score_limit_reached"] );
	
	thread maps\mp\gametypes\_globallogic::endGame( winner, game["strings"]["score_limit_reached"] );
}

onEndGame( winningTeam )
{
	game["ctf_teamscore"]["allies"] += maps\mp\gametypes\_globallogic::_getTeamScore( "allies");
	game["ctf_teamscore"]["axis"] += maps\mp\gametypes\_globallogic::_getTeamScore( "axis");
}

onRoundEndGame( winningTeam )
{
	ctf_setTeamScore( "allies", game["ctf_teamscore"]["allies"] );
	ctf_setTeamScore( "axis", game["ctf_teamscore"]["axis"] );
	
	if ( game["teamScores"]["allies"] == game["teamScores"]["axis"] )
		winner = "tie";
	else if ( game["teamScores"]["axis"] > game["teamScores"]["allies"] )
		winner = "axis";
	else
		winner = "allies";

	// make sure stats get reported
	maps\mp\gametypes\_globallogic::updateWinLossStats( winner );
	
	return winner;
}

// using this to set the halftime scores to be the total scores if there is more then
// one round per half
// this happens per player but after the first player the ctf_setTeamScore
// should not do anything
onTeamOutcomeNotify( switchtype, isRound, endReasonText )
{
	if ( switchtype == "halftime" || switchtype == "intermission")
	{
		ctf_setTeamScore( "allies", game["ctf_teamscore"]["allies"] );
		ctf_setTeamScore( "axis", game["ctf_teamscore"]["axis"] );
	}
	
	maps\mp\gametypes\_hud_message::teamOutcomeNotify( switchtype, isRound, endReasonText );
}

onSpawnPlayerUnified()
{
	self.isFlagCarrier = false;
	
	//maps\mp\gametypes\_spawning::onSpawnPlayer_Unified();
}

onSpawnPlayer()
{
	self.isFlagCarrier = false;

	spawnteam = self.pers["team"];
	if ( game["switchedsides"] )
		spawnteam = getOtherTeam( spawnteam );

	if ( level.useStartSpawns )
	{
		if (spawnteam == "axis")
			spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_Random(level.spawn_axis_start);
		else
			spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_Random(level.spawn_allies_start);
	}	
	else
	{
		if (spawnteam == "axis")
			spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_NearTeam(level.spawn_axis);
		else
			spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_NearTeam(level.spawn_allies);
	}

	assert( isDefined(spawnpoint) );

	self spawn( spawnPoint.origin, spawnPoint.angles );
}

updateGametypeDvars()
{
	level.idleFlagReturnTime = dvarFloatValue( "idleflagreturntime", 30, 0, 120 );
	level.flagRespawnTime = dvarIntValue( "flagrespawntime", 0, 0, 120 );
	level.touchReturn = dvarIntValue( "touchreturn", 0, 0, 1 );
	level.enemyCarrierVisible = dvarIntValue( "enemycarriervisible", 0, 0, 2 );
	
	level.teamKillPenaltyMultiplier = dvarFloatValue( "teamkillpenalty", 2, 0, 10 );
	level.teamKillScoreMultiplier = dvarFloatValue( "teamkillscore", 20, 0, 40 );

	// do not allow both a idleFlagReturnTime of forever and no touch return
	// at the same time otherwise the game is unplayable
	if ( level.idleFlagReturnTime == 0 && level.touchReturn == 0)
	{
		level.touchReturn = 1;
	}
}

ctf_endGame( winningTeam, endReasonText )
{
	if ( isdefined( winningTeam ) )
		[[level._setTeamScore]]( winningTeam, [[level._getTeamScore]]( winningTeam ) + 1 );
	
	thread maps\mp\gametypes\_globallogic::endGame( winningTeam, endReasonText );
}

onTimeLimit()
{
	if ( level.teamBased )
		ctf_endGame( game["defenders"], game["strings"]["time_limit_reached"] );
	else
		ctf_endGame( undefined, game["strings"]["time_limit_reached"] );
}

onDrop( player )
{
	player.isFlagCarrier = false;
	player deleteBaseIcon();

	team = self maps\mp\gametypes\_gameobjects::getOwnerTeam();
	otherTeam = getOtherTeam( team );
	
	if ( level.touchReturn )
	{
		self maps\mp\gametypes\_gameobjects::allowCarry( "any" );
		level.flagHints[otherTeam] turn_off();
	}
		
	printAndSoundOnEveryone( team, "none", &"MP_ENEMY_FLAG_DROPPED_BY", "", "mp_war_objective_lost", "", player );		


	if( getTime() - level.lastDialogTime > 1500 )
	{
		maps\mp\gametypes\_globallogic::leaderDialog( "wedrop_flag", otherTeam );
		maps\mp\gametypes\_globallogic::leaderDialog( "theydrop_flag", team );
		level.lastDialogTime = getTime();
	}

	if ( isDefined( player ) )
	 	player logString( team + " flag dropped" );
	else
	 	logString( team + " flag dropped" );

	player playLocalSound("flag_drop_plr");

//	self maps\mp\gametypes\_gameobjects::set3DIcon( "friendly", level.iconDefend3D );

	if ( level.touchReturn )
	{
		self maps\mp\gametypes\_gameobjects::set3DIcon( "friendly", level.iconReturn3D );
	}
	else
	{
		self maps\mp\gametypes\_gameobjects::set3DIcon( "friendly", level.iconDropped3D );
	}	
	self maps\mp\gametypes\_gameobjects::set3DIcon( "enemy",    level.iconCapture3D );
	self maps\mp\gametypes\_gameobjects::setVisibleTeam( "any" );

	thread maps\mp\_utility::playSoundOnPlayers( game["flag_dropped_sound"], game["attackers"] );

	self thread returnFlagAfterTimeMsg( level.idleFlagReturnTime );
}


onPickup( player )
{
	if ( level.touchReturn )
	{
		self maps\mp\gametypes\_gameobjects::allowCarry( "enemy" );
	}

	team = self maps\mp\gametypes\_gameobjects::getOwnerTeam();
	otherTeam = getOtherTeam( team );
	if ( isDefined( player ) && player.pers["team"] == team )
	{	
		//player setStatLBByName( "CTF_Flags", 1, "Returned");
	
		self notify("picked_up");

		printAndSoundOnEveryone( team, "none", &"MP_FLAG_RETURNED_BY", "", "mp_obj_returned", "", player );

		clearReturnFlagHudElems();
		
		// want to return the flag here
		self returnFlag();
		self maps\mp\gametypes\_gameobjects::returnHome();
		if ( isDefined( player ) )
		 	player logString( team + " flag returned" );
		 else
		 	logString( team + " flag returned" );
		return;
	}
	else
	{
		printAndSoundOnEveryone( otherteam, team, &"MP_ENEMY_FLAG_TAKEN_BY", &"MP_FLAG_TAKEN_BY", "mp_obj_taken", "mp_enemy_obj_taken", player );

		//player setStatLBByName( "CTF_Flags", 1, "Picked Up");
		
		if( getTime() - level.lastDialogTime > 1500 )
		{
			//check if we want to do the squad line
			//squadID = getplayersquadid( player );
		
			//if( isDefined( squadID ) )
				//maps\mp\gametypes\_globallogic::leaderDialog( "wetake_flag", otherTeam, undefined, undefined, "squad_take", squadID );
			//else
				//maps\mp\gametypes\_globallogic::leaderDialog( "wetake_flag", otherTeam );

			maps\mp\gametypes\_globallogic::leaderDialog( "theytake_flag", team );
			level.lastDialogTime = getTime();
		}
	
		player.isFlagCarrier = true;
		player playLocalSound("flag_pickup_plr");
	
		if ( level.enemyCarrierVisible )
		{
			self maps\mp\gametypes\_gameobjects::setVisibleTeam( "any" );
		}
		else
		{
			self maps\mp\gametypes\_gameobjects::setVisibleTeam( "enemy" );
		}
		self maps\mp\gametypes\_gameobjects::set3DIcon( "enemy", level.iconCarrier3D );
		self maps\mp\gametypes\_gameobjects::set3DIcon( "friendly", level.iconEnemyCarrier3D );
		
		player thread claim_trigger( level.flagHints[otherTeam] );
		
		player setupBaseIcon();
		player updateBaseIcon();
		
		update_hints();

		player logString( team + " flag taken" );
	}
	
}

returnFlag()
{
	team = self maps\mp\gametypes\_gameobjects::getOwnerTeam();
	otherTeam = level.otherTeam[team];
	
	level.teamFlagZones[otherTeam] maps\mp\gametypes\_gameobjects::allowUse( "friendly" );
	level.teamFlagZones[otherTeam] maps\mp\gametypes\_gameobjects::setVisibleTeam( "none" );

	update_hints();
	
	if ( level.touchReturn )
	{
		self maps\mp\gametypes\_gameobjects::allowCarry( "enemy" );
	}
	self maps\mp\gametypes\_gameobjects::returnHome();
	self maps\mp\gametypes\_gameobjects::setVisibleTeam( "any" );
	self maps\mp\gametypes\_gameobjects::set3DIcon( "friendly", level.iconDefend3D );	
	self maps\mp\gametypes\_gameobjects::set3DIcon( "enemy", level.iconCapture3D );	
	
	
	if( getTime() - level.lastDialogTime > 1500 )
	{
		maps\mp\gametypes\_globallogic::leaderDialog( "wereturn_flag", team );
		maps\mp\gametypes\_globallogic::leaderDialog( "theyreturn_flag", otherTeam );
		level.lastDialogTime = getTime();
	}
}



giveFlagCaptureXP( player )
{
	wait .05;
	player thread [[level.onXPEvent]]( "capture" );
	maps\mp\gametypes\_globallogic::givePlayerScore( "capture", player );
}

onReset()
{	
	update_hints();

	team = self maps\mp\gametypes\_gameobjects::getOwnerTeam();
	
	self maps\mp\gametypes\_gameobjects::set3DIcon( "friendly", level.iconDefend3D );
	self maps\mp\gametypes\_gameobjects::set3DIcon( "enemy", level.iconCapture3D );
	level.teamFlagZones[team] maps\mp\gametypes\_gameobjects::setVisibleTeam( "none" );
	level.teamFlagZones[team] maps\mp\gametypes\_gameobjects::allowUse( "friendly" );
}

getOtherFlag( flag )
{
	if ( flag == level.flags[0] )
	 	return level.flags[1];
	 	
	return level.flags[0];
}

onPlayerKilled( eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration )
{
	if ( !isDefined( self.isFlagCarrier ) || !self.isFlagCarrier )
		return;

	if ( isDefined( attacker ) && isPlayer( attacker ) && attacker.pers["team"] != self.pers["team"] )
	{
		attacker thread [[level.onXPEvent]]( "kill_carrier" );
		maps\mp\gametypes\_globallogic::givePlayerScore( "kill_carrier", attacker );
	}
}

createReturnMessageElems()
{
	level.ReturnMessageElems = [];

	level.ReturnMessageElems["allies"]["axis"] = createServerTimer( "objective", 1.4, "allies" );
	level.ReturnMessageElems["allies"]["axis"] setPoint( "TOPRIGHT", "TOPRIGHT", 0, 0 );
	level.ReturnMessageElems["allies"]["axis"].label = &"MP_ENEMY_FLAG_RETURNING_IN";
	level.ReturnMessageElems["allies"]["axis"].alpha = 0;
	level.ReturnMessageElems["allies"]["axis"].archived = false;
	level.ReturnMessageElems["allies"]["allies"] = createServerTimer( "objective", 1.4, "allies" );
	level.ReturnMessageElems["allies"]["allies"] setPoint( "TOPRIGHT", "TOPRIGHT", 0, 20 );
	level.ReturnMessageElems["allies"]["allies"].label = &"MP_YOUR_FLAG_RETURNING_IN";
	level.ReturnMessageElems["allies"]["allies"].alpha = 0;
	level.ReturnMessageElems["allies"]["allies"].archived = false;

	level.ReturnMessageElems["axis"]["allies"] = createServerTimer( "objective", 1.4, "axis" );
	level.ReturnMessageElems["axis"]["allies"] setPoint( "TOPRIGHT", "TOPRIGHT", 0, 0 );
	level.ReturnMessageElems["axis"]["allies"].label = &"MP_ENEMY_FLAG_RETURNING_IN";
	level.ReturnMessageElems["axis"]["allies"].alpha = 0;
	level.ReturnMessageElems["axis"]["allies"].archived = false;
	level.ReturnMessageElems["axis"]["axis"] = createServerTimer( "objective", 1.4, "axis" );
	level.ReturnMessageElems["axis"]["axis"] setPoint( "TOPRIGHT", "TOPRIGHT", 0, 20 );
	level.ReturnMessageElems["axis"]["axis"].label = &"MP_YOUR_FLAG_RETURNING_IN";
	level.ReturnMessageElems["axis"]["axis"].alpha = 0;
	level.ReturnMessageElems["axis"]["axis"].archived = false;
}

returnFlagAfterTimeMsg( time )
{
	if ( level.touchReturn )
		return;
		
	result = returnFlagHudElems( time );
	
	clearReturnFlagHudElems();
	
	if ( !isdefined( result ) ) // returnFlagHudElems hit an endon
		return;
	
//	self returnFlag();
}

returnFlagHudElems( time )
{
	self endon("picked_up");
	level endon("game_ended");
	
	ownerteam = self maps\mp\gametypes\_gameobjects::getOwnerTeam();
	
	assert( !level.ReturnMessageElems["axis"][ownerteam].alpha );
	level.ReturnMessageElems["axis"][ownerteam].alpha = 1;
	level.ReturnMessageElems["axis"][ownerteam] setTimer( time );
	
	assert( !level.ReturnMessageElems["allies"][ownerteam].alpha );
	level.ReturnMessageElems["allies"][ownerteam].alpha = 1;
	level.ReturnMessageElems["allies"][ownerteam] setTimer( time );
	
	if( time <= 0 )
		return false;
	else
		wait time;
	
	return true;
}

clearReturnFlagHudElems()
{
	ownerteam = self maps\mp\gametypes\_gameobjects::getOwnerTeam();
	
	level.ReturnMessageElems["allies"][ownerteam].alpha = 0;
	level.ReturnMessageElems["axis"][ownerteam].alpha = 0;
}

resetFlagBaseEffect()
{
	// dont spawn first frame
	wait (0.1);
	
	if ( isdefined( self.baseeffect ) )
		self.baseeffect delete();
	
	team = self maps\mp\gametypes\_gameobjects::getOwnerTeam();
	
	if ( team != "axis" && team != "allies" )
		return;
	
	fxid = level.flagBaseFXid[ team ];

	self.baseeffect = spawnFx( fxid, self.baseeffectpos, self.baseeffectforward, self.baseeffectright );
	
	triggerFx( self.baseeffect );
}

turn_on()
{
	if ( level.hardcoreMode )
		return;
		
	self.origin = self.original_origin;
}

turn_off()
{
	self.origin = ( self.original_origin[0], self.original_origin[1], self.original_origin[2] - 10000);
}

update_hints()
{
	allied_flag = level.teamFlags["allies"];
	axis_flag = level.teamFlags["axis"];

	if ( isdefined(allied_flag.carrier) )
		allied_flag.carrier updateBaseIcon();
			
	if ( isdefined(axis_flag.carrier) )
		axis_flag.carrier updateBaseIcon();
			
	if ( !level.touchReturn )
		return;

	if ( isdefined(allied_flag.carrier) && axis_flag maps\mp\gametypes\_gameobjects::isObjectAwayFromHome() )
	{
		level.flagHints["axis"] turn_on();		
	}
	else
	{
		level.flagHints["axis"] turn_off();
	}		
	
	if ( isdefined(axis_flag.carrier) && allied_flag maps\mp\gametypes\_gameobjects::isObjectAwayFromHome() )
	{
		level.flagHints["allies"] turn_on();		
	}
	else
	{
		level.flagHints["allies"] turn_off();
	}		
}

claim_trigger( trigger )
{
	self endon("disconnect");
	self ClientClaimTrigger( trigger );
	
	self waittill("drop_object");
	self ClientReleaseTrigger( trigger );
}

setupBaseIcon()
{
	zone = level.teamFlagZones[self.pers["team"]];
	self.ctfBaseIcon = newClientHudElem( self );
	self.ctfBaseIcon.x = zone.trigger.origin[0];
	self.ctfBaseIcon.y = zone.trigger.origin[1];
	self.ctfBaseIcon.z = zone.trigger.origin[2] + 100;
	self.ctfBaseIcon.alpha = 1; // needs to be solid to obscure flag icon
	self.ctfBaseIcon.baseAlpha = 1;
	self.ctfBaseIcon.awayAlpha = 0.35;
	self.ctfBaseIcon.archived = true;
	self.ctfBaseIcon setShader( level.iconBase3D, level.objPointSize, level.objPointSize );
	self.ctfBaseIcon setWaypoint( true, level.iconBase3D );
	self.ctfBaseIcon.sort = 1; // make sure it sorts on top of the flag icon
}

deleteBaseIcon()
{
	self.ctfBaseIcon destroy();
	self.ctfBaseIcon = undefined;
}

updateBaseIcon()
{
	team = self.pers["team"];
	otherteam = getotherteam(team);
	
	flag = level.teamFlags[team];
	
	visible = false;
	if ( flag maps\mp\gametypes\_gameobjects::isObjectAwayFromHome() )
	{
		visible = true;
	}
	
	updateBaseIconVisibility( visible );
}

updateBaseIconVisibility( visible )
{
	// can hit here if a friendly team touches flag to return
	if ( !isdefined(self.ctfBaseIcon) )
		return;
		
	if ( visible )
	{
		self.ctfBaseIcon.alpha = self.ctfBaseIcon.awayAlpha;
		self.ctfBaseIcon.isShown = true;
	}
	else
	{
		self.ctfBaseIcon.alpha = self.ctfBaseIcon.baseAlpha;
		self.ctfBaseIcon.isShown = true;
	}
}

createFlagSpawnInfluencer( entityTeam )
{
	// ctf: influencer around friendly base
	ctf_friendly_base_influencer_score= level.spawnsystem.ctf_friendly_base_influencer_score;
	ctf_friendly_base_influencer_score_curve= level.spawnsystem.ctf_friendly_base_influencer_score_curve;
	ctf_friendly_base_influencer_radius= level.spawnsystem.ctf_friendly_base_influencer_radius;
	
	// ctf: influencer around enemy base
	ctf_enemy_base_influencer_score= level.spawnsystem.ctf_enemy_base_influencer_score;
	ctf_enemy_base_influencer_score_curve= level.spawnsystem.ctf_enemy_base_influencer_score_curve;
	ctf_enemy_base_influencer_radius= level.spawnsystem.ctf_enemy_base_influencer_radius;
	
	//otherteam = getotherteam(entityTeam);
	//team_mask = get_team_mask( entityTeam );
	//other_team_mask = get_team_mask( otherteam );
	
	//self.spawn_influencer_friendly = addsphereinfluencer( level.spawnsystem.eINFLUENCER_TYPE_GAME_MODE,
							 //self.trigger.origin, 
							 //ctf_friendly_base_influencer_radius,
							 //ctf_friendly_base_influencer_score,
							 //team_mask,
							 //maps\mp\gametypes\_spawning::get_score_curve_index(ctf_friendly_base_influencer_score_curve) );

	//self.spawn_influencer_enemy = addsphereinfluencer( level.spawnsystem.eINFLUENCER_TYPE_GAME_MODE,
							 //self.trigger.origin, 
							 //ctf_enemy_base_influencer_radius,
							 //ctf_enemy_base_influencer_score,
							 //other_team_mask,
							 //maps\mp\gametypes\_spawning::get_score_curve_index(ctf_enemy_base_influencer_score_curve) );



}


ctf_getTeamKillPenalty( eInflictor, attacker, sMeansOfDeath, sWeapon )
{
	//teamkill_penalty = maps\mp\gametypes\_globallogic::default_getTeamKillPenalty( eInflictor, attacker, sMeansOfDeath, sWeapon );

	//if ( ( isdefined( self.isFlagCarrier ) && self.isFlagCarrier ) )
	//{
		//teamkill_penalty = teamkill_penalty * level.teamKillPenaltyMultiplier;
	//}
	
	//return teamkill_penalty;
}

ctf_getTeamKillScore( eInflictor, attacker, sMeansOfDeath, sWeapon )
{
	teamkill_score = maps\mp\gametypes\_rank::getScoreInfoValue( "kill" );
	
	if ( ( isdefined( self.isFlagCarrier ) && self.isFlagCarrier ) )
	{
		teamkill_score = teamkill_score * level.teamKillScoreMultiplier;
	}
	
	return int(teamkill_score);
}


