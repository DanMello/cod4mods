#include common_scripts\utility;
#include maps\mp\gametypes\_hud_util;
#include maps\mp\_utility;
#include maps\mp\gametypes\_general_funcs;

init()
{
	level thread onPlayerConnect();
	
	level.gameModeDevName = "SSC";
	level.current_game_mode = "Split screen classes";
	
	while(!isDefined(level.inPrematchPeriod)) wait .05;
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
	
	for(;;)
	{
		self waittill("spawned_player");
	}
}


//self setClientDvar("cg_objectiveText",&"OBJECTIVES_CTF_SCORE");


InitCTF()
{}
/*
	level.PrevWinner = "tie";
	level.SuddenDeath = false;
	level.Icon2D = maps\mp\gametypes\_gameobjects::set2DIcon;
	level.Icon3D = maps\mp\gametypes\_gameobjects::set3DIcon;
	
	setDvar("g_gametype","ctf");
	setDvar("ui_gametype","ctf");
	setDvar("party_teambased","1");
	
	setDvar("scr_ctf_numlives","0");
	setDvar("scr_ctf_playerrespawndelay","0");
	setDvar("scr_ctf_roundlimit","2");
	setDvar("scr_ctf_roundswitch","1");
	setDvar("scr_ctf_scorelimit","10");
	setDvar("scr_ctf_timelimit","5");
	setDvar("scr_ctf_waverespawndelay","15");
	SetDvar("scr_sab_roundlimit","1");
	SetDvar("scr_sab_roundswitch","1");
	SetDvar("scr_sab_scorelimit","100");
	SetDvar("scr_sab_timelimit",20);
	
	registerScore=maps\mp\gametypes\_rank::registerScoreInfo;
	
	[[registerScore]]("capture",250);
	[[registerScore]]("defend",150);
	[[registerScore]]("defend_assist",75);
	[[registerScore]]("assault",50);
	[[registerScore]]("assault_assist",10);
	
	if(game["allies"] == "sas")
	{
		level.AlliesCircle = loadFX("misc/ui_flagbase_black");
		level.AlliesFlagModel = "prop_flag_brit";
	}
	else if(game["allies"] == "marines")
	{
		level.AlliesCircle = loadFX("misc/ui_flagbase_silver");
		level.AlliesFlagModel = "prop_flag_american";
	}
	if(game["axis"] == "opfor")
	{
		level.AxisCircle = loadFX("misc/ui_flagbase_gold");
		level.AxisFlagModel = "prop_flag_opfor";
	}
	else if(game["axis"] == "russian")
	{
		level.AxisCircle = loadFX("misc/ui_flagbase_red");
		level.AxisFlagModel = "prop_flag_russian";
	}
	
	level.Captures["allies"] = 0;
	level.Captures["axis"] = 0;
	
	level.bombZones["allies"] maps\mp\gametypes\_gameobjects::setModelVisibility(false);
	level.bombZones["axis"] maps\mp\gametypes\_gameobjects::setModelVisibility(false);
	level.bombZones["allies"] maps\mp\gametypes\_gameobjects::DisableObject();
	level.bombZones["axis"] maps\mp\gametypes\_gameobjects::DisableObject();
	
	level.sabBomb maps\mp\gametypes\_gameobjects::setModelVisibility(false);
	level.sabBomb maps\mp\gametypes\_gameobjects::DisableObject();
	
	maps\mp\gametypes\_globallogic::setObjectiveText("allies",&"OBJECTIVES_CTF");
	maps\mp\gametypes\_globallogic::setObjectiveText("axis",&"OBJECTIVES_CTF");
	
	maps\mp\gametypes\_globallogic::setObjectiveScoreText("allies",&"OBJECTIVES_CTF_SCORE");
	maps\mp\gametypes\_globallogic::setObjectiveScoreText("axis",&"OBJECTIVES_CTF_SCORE");
	
	maps\mp\gametypes\_globallogic::setObjectiveHintText("allies",&"OBJECTIVES_CTF_HINT");
	maps\mp\gametypes\_globallogic::setObjectiveHintText("axis",&"OBJECTIVES_CTF_HINT");
	
	
	while(!isDefined(level.inPrematchPeriod)) wait .05;
	
	level thread CTFConnect();
	
}

CTFConnect()
{
	//for(;;)
	{
		level waittill( "connected", player );
		//player thread onPlayerSpawned();
	}
	
	FX1 = SpawnFx(level.AlliesCircle,level.bombZones["allies"].visuals[0].origin);
	TriggerFX(FX1);
	FX2 = SpawnFx(level.AxisCircle,level.bombZones["axis"].visuals[0].origin);
	TriggerFX(FX2);
	
	level.Flag["allies"] = Spawn("script_model",level.bombZones["allies"].visuals[0].origin);
	level.Flag["allies"] Setmodel(level.AlliesFlagModel);
	level.Flag["allies"].team = "allies";
	level.Flag["allies"].enemyteam = "axis";
	level.Flag["allies"].IsMissing = false;
	level.Flag["allies"].IsLinked = false;
	level.Flag["allies"].IsCooling = false;
	level.Flag["allies"].Home = level.bombZones["allies"].visuals[0].origin;
	
	level.Flag["axis"] = Spawn("script_model",level.bombZones["axis"].visuals[0].origin);
	level.Flag["axis"] Setmodel(level.AxisFlagModel);
	level.Flag["axis"].team = "axis";
	level.Flag["axis"].enemyteam = "allies";
	level.Flag["axis"].IsMissing = false;
	level.Flag["axis"].IsLinked = false;
	level.Flag["axis"].IsCooling = false;
	level.Flag["axis"].Home = level.bombZones["axis"].visuals[0].origin;
	
	level.FlagPos["allies"] = spawn("script_model",level.Flag["allies"].Home);
	level.FlagPos["allies"] setmodel("weapon_c4");
	level.FlagPos["allies"].team = "allies";
	level.FlagPos["allies"].enemyteam = "axis";
	level.FlagPos["allies"] Hide();
	
	level.FlagPos["axis"] = spawn("script_model",level.Flag["axis"].Home);
	level.FlagPos["axis"] setmodel("weapon_c4");
	level.FlagPos["axis"].team = "axis";
	level.FlagPos["axis"].enemyteam = "allies";
	level.FlagPos["axis"] Hide();
	
	wait 10;
	
	CreateAlliesFlagZone();
	CreateAxisFlagZone();
	
	allowed[0] = "ctf";
	maps\mp\gametypes\_gameobjects::main(allowed);
	
	
	level.FlagIcon["allies"] = level createServerFontString("objective",1.9);
	level.FlagIcon["allies"] SetPoint("LEFT","LEFT",18,0);
	level.FlagIcon["allies"] SetShader("compass_flag_american");
	
	level.FlagIcon["axis"] = level createServerFontString("objective",1.9);
	level.FlagIcon["axis"] SetPoint("LEFT","LEFT",18,50);
	level.FlagIcon["axis"] SetShader("compass_flag_russian");
	
	level.FlagTxt["allies"] = level createServerFontString("objective",1.5);
	level.FlagTxt["allies"] SetPoint("LEFT","LEFT",50,0);
	level.FlagTxt["allies"] SetText("HOME");
	
	level.FlagTxt["axis"] = level createServerFontString("objective",1.5);
	level.FlagTxt["axis"] SetPoint("LEFT","LEFT",50,50);
	level.FlagTxt["axis"] SetText("HOME");
	
	wait 5;
	level.FlagPos["allies"] thread MonitorFlagHome();
	level.FlagPos["axis"] thread MonitorFlagHome();
	
	level.Flag["allies"] thread MonitorFlagAway();
	level.Flag["axis"] thread MonitorFlagAway();
	
	thread MonitorWinner();
}
MonitorWinner()
{
	level waittill("match_ending_very_soon");
	
	for(;;)
	{
		if(level.Captures["allies"] > level.Captures["axis"])
			winner="allies";
		else if(level.Captures["axis"] > level.Captures["allies"])
			winner="axis";
		else
			winner="tie";
		
		if((winner!="tie")&&(maps\mp\gametypes\_globallogic::getTimeRemaining()<1000))
			maps\mp\gametypes\_globallogic::EndGame(winner,game[winner]+ " CAPTURED ^3" + level.Captures[winner] + " ^7FLAGS!");
		wait .5;
	}
}
MonitorFlagHome()
{
	for(;;)
	{
		if(level.Flag[self.team].IsCooling)
		{
			wait 0.05;
			continue;
		}
		for(i=0;i<level.players.size;i++)
		{
			if(isReallyDead(level.players[i]))
				continue;
			
			D = Distance(self.origin,level.players[i].origin);
			
			if(D < 50)
			{
				if((level.players[i].team==self.team)&&(level.Flag[self.team].IsMissing)&&(!level.players[i].IsFlagCarrier)&&(!level.players[i].IsAware))
				{
					level.players[i].IsAware=true;
					level.players[i] notify("Aware");
					level.players[i] iprintlnbold("^3THE ENEMY GOT OUR FLAG! RETURN IT TO OUR BASE.");
					continue;
				}
				else if((level.players[i].team==self.team)&&(!level.Flag[self.team].IsMissing)&&(!level.players[i].isFlagCarrier)&&(!level.players[i].IsAware))
				{
					level.players[i].IsAware=true;
					level.players[i] notify("Aware");
					level.players[i] iprintlnbold("^2DEFEND OUR FLAG! DON'T LET THE ENEMY GET IT.");
					continue;
				}
				else if((level.players[i].team==self.team)&&(!level.Flag[self.team].IsMissing)&&(level.Flag[self.enemyteam].IsMissing)&&(level.players[i].isFlagCarrier))
				{
					level.players[i].IsAware = true;
					level.players[i].isFlagCarrier = false;
					level.players[i].FlagCarryIcon MyTransitionFadeOut(2);
					level.players[i] Detach(level.players[i].FlagModel,"J_spine4");
					
					PrintBoldOnTeam("^2ENEMY FLAG CAPTURED!",level.players[i].team);
					PrintBoldOnTeam("^1THE ENEMY CAPTURED OUR FLAG!",level.players[i].Enemyteam);
					
					level.players[i] PlaySound("mp_challenge_complete");
					
					maps\mp\gametypes\_globallogic::leaderDialog("enemyflag_return",level.players[i].team);
					maps\mp\gametypes\_globallogic::givePlayerScore("challenge",level.players[i]);
					
					level.players[i] notify("Flag_Capture");
					
					SetTeamScore(self.team,GetTeamScore(self.team)+ 20);
					level.Captures[level.players[i].team]++;
					
					if(GetTeamScore(self.team)> getTeamScore(self.enemyteam))
						SetWinningTeam(self.team);
					else 
						SetWinningTeam(self.Enemyteam);
					
					if(level.Captures[level.players[i].team]>=5)
						maps\mp\gametypes\_globallogic::EndGame(level.players[i].team,game[level.players[i].team]+ " CAPTURED ^3" + level.Captures[level.players[i].team] + " ^7FLAGS!");
					
					if((level.timeLimitOverride)&&(level.inOvertime))
						maps\mp\gametypes\_globallogic::EndGame(level.players[i].team,game[level.players[i].team]+ " CAPTURED ^3THE GAME WINNING FLAG!");
					
					thread ResetEnemyFlag(level.players[i]);
					wait .1;
					break;
				}
				else if((level.players[i].team==self.team)&&(level.Flag[self.team].IsMissing)&&(level.Flag[self.enemyteam].IsMissing)&&(level.players[i].isFlagCarrier)&&(!level.players[i].IsAware))
				{
					level.players[i].IsAware=true;
					level.players[i] notify("Aware");
					level.players[i] IprintLnBold("^2OUR FLAG MUST RETURN BEFORE YOU CAPTURE THE ENEMY ONE!");
					continue;
				}
				else if((level.players[i].team!=self.team)&&(!level.Flag[self.team].IsMissing)&&(!level.players[i].isFlagCarrier))
				{
					if(!level.players[i] FlagCaptureBar("CAPTURING...",5,self.origin))
						continue;
					
					level.players[i].IsAware=true;
					level.players[i] notify("Aware");
					level.Flag[self.team].IsMissing=true;
					level.Flag[self.team].IsLinked=true;
					level.players[i].isFlagCarrier=true;
					
					level.players[i] thread DropFlagOnEvents();
					
					thread playSoundOnPlayers("mp_war_objective_taken",level.players[i].team);
					thread playSoundOnPlayers("mp_war_objective_lost",level.otherTeam[level.players[i].team]);
					
					level.players[i] thread [[level.onXPEvent]]("capture");
					maps\mp\gametypes\_globallogic::givePlayerScore("capture",level.players[i]);
					
					PrintBoldOnTeam("^2WE GOT THE ENEMY FLAG!\n^0BRING IT TO OUR BASE.",level.players[i].team);
					PrintBoldOnTeam("^1THEY GOT OUR FLAG!\n^8RETURN IT TO OUR BASE.",level.players[i].Enemyteam);
					
					level.FlagZone[self.team] thread MonitorPosition(level.players[i]);
					level.FlagTxt[self.team] SetText(getName(level.players[i]));
					
					level.Flag[self.team] linkto(level.players[i]);
					level.Flag[self.team] Hide();
					
					level.players[i] attach(level.players[i].FlagModel,"J_spine4");
					level.players[i].FlagCarryIcon.alpha=1;
					wait .1;
					break;
				}
				else if((level.players[i].team!=self.team)&&(level.Flag[self.team].IsMissing)&&(level.players[i].isFlagCarrier)&&(!level.players[i].IsAware))
				{
					level.players[i].IsAware=true;
					level.players[i] notify("Aware");
					level.players[i] iprintlnbold("^3ESCORT THE ENEMY FLAG TO YOUR BASE!");
					continue;
				}
				else if((level.players[i].team!=self.team)&&(level.Flag[self.team].IsMissing)&&(!level.players[i].isFlagCarrier)&&(!level.players[i].IsAware))
				{
					level.players[i].IsAware=true;
					level.players[i] notify("Aware");
					level.players[i] iprintlnbold("^6ENEMY FLAG IS MISSING...");
				}
			}
		}
		wait 0.05;
	}
}
MonitorFlagAway()
{
	for(;;)
	{
		if((self.IsLinked)||(!self.IsMissing))
		{
			wait 0.05;
			continue;
		}
		for(i=0;i<level.players.size;i++)
		{
			if(isReallyDead(level.players[i]))
				continue;
			
			R=Distance(self.origin,level.players[i].origin);
			
			if(R < 50)
			{
				if(level.players[i].team==self.team)
				{
					level.players[i].isAware=true;
					level.players[i] notify("Aware");
					
					if(!level.players[i] FlagCaptureBar("CAPTURING...",1.5,self.origin))
						continue;
					
					self.origin=self.Home;
					level.FlagTxt[self.Team] SetText("HOME");
					self show();
					self.origin=self.Home;
					self.IsMissing=false;
					self.IsLinked=false;
					self.IsCooling=false;
					
					level.FlagZone[self.Team] maps\mp\gametypes\_gameobjects::setModelVisibility(true);
					level.FlagZone[self.Team] maps\mp\gametypes\_gameobjects::EnableObject();
					level.FlagZone[self.Team] setPosition(level.Flag[self.Team].Home,(0,0,0));
					level.FlagZone[self.Team] [[level.Icon2D]]("friendly","compass_waypoint_defend");
					level.FlagZone[self.Team] [[level.Icon3D]]("friendly","waypoint_defend");
					level.FlagZone[self.Team] [[level.Icon2D]]("enemy","compass_waypoint_capture");
					level.FlagZone[self.Team] [[level.Icon3D]]("enemy","waypoint_capture");
					
					iprintlnbold(game[level.players[i].team] + " ^5 FLAG RETURNED!");
					
					thread playSoundOnPlayers("mp_war_objective_taken",level.players[i].team);
					thread playSoundOnPlayers("mp_war_objective_lost",level.otherTeam[level.players[i].team]);
					wait .1;
					break;
				}
				else if((level.players[i].team!=self.team)&&(!level.players[i].isFlagCarrier))
				{
					level.players[i].isAware=true;
					level.players[i] notify("Aware");
					
					if(!level.players[i] FlagCaptureBar("CAPTURING...",2.5,self.origin))
						continue;
					
					level.players[i] PlayLocalSound("oldschool_pickup");
					level.players[i].isFlagCarrier=true;
					
					self.IsMissing=true;
					self.IsLinked=true;
					
					level.players[i] thread DropFlagOnEvents();
					level.FlagZone[self.team] thread MonitorPosition(level.players[i]);
					level.FlagTxt[self.team] SetText(getName(level.players[i]));
					
					self linkto(level.players[i]);
					self Hide();
					
					level.players[i] Attach(level.players[i].FlagModel,"J_spine4");
					level.players[i].FlagCarryIcon.alpha=1;
					level.players[i] iprintlnbold("^2YOU GOT THE ENEMY FLAG\n^3ESCORT IT TO YOUR BASE!");
					wait .1;
					break;
				}
			}
		}
		wait 0.05;
	}
}
ResetEnemyFlag(player)
{
	player notify("FlagDrop");
	
	level.FlagZone[self.Enemyteam] maps\mp\gametypes\_gameobjects::setModelVisibility(false);
	level.FlagZone[self.Enemyteam] maps\mp\gametypes\_gameobjects::DisableObject();
	level.FlagZone[self.Enemyteam] maps\mp\gametypes\_gameobjects::clearCarrier();
	
	level.Flag[self.EnemyTeam] unlink();
	level.Flag[self.EnemyTeam].IsCooling=true;
	
	wait 5;
	iprintlnbold(game[level.otherTeam[player.team]] + " ^5FLAG RESET!");
	
	level.Flag[self.EnemyTeam] PlaySound("mp_ingame_summary");
	level.Flag[self.EnemyTeam] show();
	level.Flag[self.EnemyTeam].origin=level.Flag[self.EnemyTeam].Home;
	level.FlagTxt[self.EnemyTeam] SetText("HOME");
	level.Flag[self.EnemyTeam].IsMissing=false;
	level.Flag[self.EnemyTeam].IsLinked=false;
	level.Flag[self.EnemyTeam].IsCooling=false;
	
	level.FlagZone[self.Enemyteam] maps\mp\gametypes\_gameobjects::setModelVisibility(true);
	level.FlagZone[self.Enemyteam] maps\mp\gametypes\_gameobjects::EnableObject();
	level.FlagZone[self.EnemyTeam] setPosition(level.Flag[self.EnemyTeam].Home,(0,0,0));
	level.FlagZone[self.EnemyTeam] [[level.Icon2D]]("enemy","compass_waypoint_capture");
	level.FlagZone[self.EnemyTeam] [[level.Icon3D]]("enemy","waypoint_capture");
	level.FlagZone[self.EnemyTeam] [[level.Icon2D]]("friendly","compass_waypoint_defend");
	level.FlagZone[self.EnemyTeam] [[level.Icon3D]]("friendly","waypoint_defend");
}
FlagEventsAware()
{
	self endon("disconnect");
	for(;;)
	{
		wait 10;
		self.IsAware=false;
		self waittill("Aware");
	}
}
CreateAlliesFlagZone()
{
	visuals[0]=getEnt("sab_bomb","targetname");
	visuals[0] setModel("prop_flag_american");
	
	level.FlagZone["allies"] = maps\mp\gametypes\_gameobjects::createCarryObject("allies",level.Flag["allies"],visuals,(0,0,64));
	level.FlagZone["allies"] maps\mp\gametypes\_gameobjects::allowCarry("any");
	level.FlagZone["allies"] [[level.Icon2D]]("enemy","compass_waypoint_capture");
	level.FlagZone["allies"] [[level.Icon3D]]("enemy","waypoint_capture");
	level.FlagZone["allies"] [[level.Icon2D]]("friendly","compass_waypoint_defend");
	level.FlagZone["allies"] [[level.Icon3D]]("friendly","waypoint_defend");
	level.FlagZone["allies"] maps\mp\gametypes\_gameobjects::setCarryIcon("compass_flag_american");
	level.FlagZone["allies"] maps\mp\gametypes\_gameobjects::setVisibleTeam("any");
	level.FlagZone["allies"].objPoints["allies"].archived=true;
	level.FlagZone["allies"].objPoints["axis"].archived=true;
}
CreateAxisFlagZone()
{
	visuals[0]=getEnt("sab_bomb","targetname");
	visuals[0] setModel("prop_flag_american");
	
	level.FlagZone["axis"]=maps\mp\gametypes\_gameobjects::createCarryObject("axis",level.Flag["axis"],visuals,(0,0,64));
	level.FlagZone["axis"] maps\mp\gametypes\_gameobjects::allowCarry("any");
	level.FlagZone["axis"] [[level.Icon2D]]("enemy","compass_waypoint_capture");
	level.FlagZone["axis"] [[level.Icon3D]]("enemy","waypoint_capture");
	level.FlagZone["axis"] [[level.Icon2D]]("friendly","compass_waypoint_defend");
	level.FlagZone["axis"] [[level.Icon3D]]("friendly","waypoint_defend");
	level.FlagZone["axis"] maps\mp\gametypes\_gameobjects::setCarryIcon("compass_flag_russian");
	level.FlagZone["axis"] maps\mp\gametypes\_gameobjects::setVisibleTeam("any");
	level.FlagZone["axis"].objPoints["allies"].archived=true;
	level.FlagZone["axis"].objPoints["axis"].archived=true;
}
DropFlagOnEvents()
{
	self endon("Flag_Capture");
	
	self waittill_any("disconnect","death","joined_spectators");
	self notify("FlagDrop");

	self.IsAware=true;
	self notify("Aware");
	self.isFlagCarrier=false;
	
	level.Flag[self.EnemyTeam].IsLinked=false;
	level.FlagTxt[self.EnemyTeam] SetText("NONE");
	level.Flag[self.EnemyTeam] Show();
	level.Flag[self.EnemyTeam] Unlink();
	level.Flag[self.EnemyTeam].origin=self.origin -(0,0,12);
	
	level.FlagZone[self.EnemyTeam] maps\mp\gametypes\_gameobjects::clearCarrier();
	level.FlagZone[self.EnemyTeam] setPosition(level.Flag[self.EnemyTeam].origin +(0,0,5),(0,0,0));
	level.FlagZone[self.EnemyTeam] [[level.Icon2D]]("enemy","compass_waypoint_captureneutral");
	level.FlagZone[self.EnemyTeam] [[level.Icon3D]]("enemy","waypoint_captureneutral");
	level.FlagZone[self.EnemyTeam] [[level.Icon2D]]("friendly","compass_waypoint_captureneutral");
	level.FlagZone[self.EnemyTeam] [[level.Icon3D]]("friendly","waypoint_captureneutral");
	
	self.FlagCarryIcon.alpha=0;
	self shellShock("ac130",0.01);
	//MultiExe(::killStreakNotify,"All",self,self,"^5DROPPED FLAG");
}
MonitorPosition(p)
{
	P endon("FlagDrop");
	self maps\mp\gametypes\_gameobjects::setCarrier(P);
	self SetTargetEnt(P);
	self [[level.Icon2D]]("enemy","compass_waypoint_defend");
	self [[level.Icon3D]]("enemy","waypoint_defend");
	self [[level.Icon2D]]("friendly","compass_waypoint_target");
	self [[level.Icon3D]]("friendly","waypoint_kill");
}
MyTransitionFadeOut(duration)
{
	self fadeOverTime(duration);
	self.alpha=0;
}
setPosition(origin,angles)
{
	self.isResetting=true;
	for(index=0;index < self.visuals.size;index++)
	{
		self.visuals[index].origin=self.origin;
		self.visuals[index].angles=self.angles;
		self.visuals[index] show();
	}
	self.trigger.origin=origin;
	self.curOrigin=self.trigger.origin;
	maps\mp\gametypes\_gameobjects::updateWorldIcons();
	maps\mp\gametypes\_gameobjects::updateCompassIcons();
	self.isResetting=false;
}
FlagCaptureBar(text,time,loc,color)
{
	Capture=true;
	useBar=createPrimaryProgressBar(25);
	useBarText=createPrimaryProgressBarText(25);
	if(isDefined(color))useBar.Bar.color=color;
	for(i=0;i<time;i++)
	{
		useBarText setText(text);
		useBar updateBar(i / time);
		wait(0.2);
		
		if(Distance(self.origin,loc)>75||isReallyDead(self))
		{
			Capture=false;
			break;
		}
	}
	useBar DestroyElem();
	useBarText DestroyElem();
	wait 0.5;
	return Capture;
}

isReallyDead(player)
{
	return(!isAlive(player)&&(player.statusicon=="hud_status_dead"||player.sessionstate=="spectator"));
}
