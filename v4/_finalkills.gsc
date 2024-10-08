﻿#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include common_scripts\utility;

init()
{
    level.killcam_style = 0;
    level.fk = false;
    level.showFinalKillcam = false;
    level.waypoint = false;
    
    level.doFK["axis"] = false;
    level.doFK["allies"] = false;
    
    level.slowmotstart = undefined;
    
    onPlayerConnect();
}

onPlayerConnect()
{
    for(;;)
    {
        level waittill("connected", player);
        player thread beginFK();
    }
}
        
beginFK()
{
    self endon("disconnect");
    
	
    for(;;)
    {
        self waittill("beginFK", winner);
        
        self notify ( "reset_outcome" );

        if(level.TeamBased)
            self finalkillcam(level.KillInfo[winner]["attacker"], level.KillInfo[winner]["attackerNumber"], level.KillInfo[winner]["deathTime"], level.KillInfo[winner]["victim"]);
        else
            self finalkillcam(winner.KillInfo["attacker"], winner.KillInfo["attackerNumber"], winner.KillInfo["deathTime"], winner.KillInfo["victim"]);
    }
}

finalkillcam( attacker, attackerNum, deathtime, victim)
{
    self endon("disconnect");
    level endon("end_killcam");
    
	if(!isDefined(attacker getentitynumber()))
	{
		level.fk = false;
		wait 1;
		self notify("end_killcam");
		level notify("end_killcam");
		return;
	}
	
    self SetClientDvar("ui_ShowMenuOnly", "none");
	self setClientDvar("cg_drawGun", "1");
	self setClientDvar("cg_thirdperson", "0");

    camtime = 5;
    predelay = getTime()/1000 - deathTime;
    postdelay = 2;
    killcamlength = camtime + postdelay;
    killcamoffset = camtime + predelay;
    
    visionSetNaked( getdvar("mapname") );
    
    self notify ( "begin_killcam", getTime() );
    
    self allowSpectateTeam("allies", true);
	self allowSpectateTeam("axis", true);
	self allowSpectateTeam("freelook", true);
	self allowSpectateTeam("none", true);
    
    self.sessionstate = "spectator";
	self.spectatorclient = attackerNum;
	self.killcamentity = -1;
	self.archivetime = killcamoffset;
	self.killcamlength = killcamlength;
	self.psoffsettime = 0;
    
    if(!isDefined(level.slowmostart))
        level.slowmostart = killcamlength - 2.5;
    
    self.killcam = true;
    
    wait .05;
    
    if(!isDefined(self.top_fk_shader))
    {
        self CreateFKMenu(victim , attacker);
    }
    else
    {
        self.fk_title.alpha = 1;
        self.fk_title_low.alpha = 1;
        self.top_fk_shader.alpha = 0.5;
        self.bottom_fk_shader.alpha = 0.5;
        //self.credits.alpha = 0.2;
    }
    
	//self.credits setText("predelay: "+predelay + " getTime: "+getTime()/1000 + " deathtime: "+deathtime);
	 
    self thread WaitEnd(killcamlength);
    
    wait .05;
    
    self waittill("end_killcam");
    
	
    self thread CleanFK();
    
    self.killcamentity = -1;
	self.archivetime = 0;
	self.psoffsettime = 0;
    
    wait .05;
    
    self.sessionstate = "spectator";
	spawnpointname = "mp_global_intermission";
	spawnpoints = getentarray(spawnpointname, "classname");
	assert( spawnpoints.size );
	spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_Random(spawnpoints);

	self spawn(spawnpoint.origin, spawnpoint.angles);

    wait .05;
    
    self.killcam = undefined;
    self thread maps\mp\gametypes\_spectating::setSpectatePermissions();

    level notify("end_killcam");

    level.fk = false;  
	
	//self.switching_teams = true;
	//self.joining_team = "allies";
	//self.leaving_team = self.pers["team"];
	//self.pers["class"] = undefined;
	//self.class = undefined;
	//self.pers["weapon"] = undefined;
	//self.pers["savedmodel"] = undefined;
	
	
	//FIX Spectate bug
	self.pers["team"] = self.TeamDefini;
	self.team = self.TeamDefini;
	self.sessionteam = self.TeamDefini;
}

CleanFK()
{
    self.fk_title.alpha = 0;
    self.fk_title_low.alpha = 0;
    self.top_fk_shader.alpha = 0;
    self.bottom_fk_shader.alpha = 0;
    self.credits.alpha = 0;
    
    self SetClientDvar("ui_ShowMenuOnly", "");
    
    visionSetNaked( "mpOutro", 1.0 );
}

WaitEnd( killcamlength )
{
    self endon("disconnect");
	self endon("end_killcam");
    
    wait killcamlength;
    
    self notify("end_killcam");
}

CreateFKMenu( victim , attacker)
{
    self.top_fk_shader = newClientHudElem(self);
    self.top_fk_shader.elemType = "shader";
    self.top_fk_shader.archived = false;
    self.top_fk_shader.horzAlign = "fullscreen";
    self.top_fk_shader.vertAlign = "fullscreen";
    self.top_fk_shader.sort = 99;
    self.top_fk_shader.foreground = true;
    self.top_fk_shader.color	= (.15, .15, .15);
    self.top_fk_shader setShader("white",640,112);
    
    self.bottom_fk_shader = newClientHudElem(self);
    self.bottom_fk_shader.elemType = "shader";
    self.bottom_fk_shader.y = 368;
    self.bottom_fk_shader.archived = false;
    self.bottom_fk_shader.horzAlign = "fullscreen";
    self.bottom_fk_shader.vertAlign = "fullscreen";
    self.bottom_fk_shader.sort = 99; 
    self.bottom_fk_shader.foreground = true;
    self.bottom_fk_shader.color	= (.15, .15, .15);
    self.bottom_fk_shader setShader("white",640,112);
    
    self.fk_title = newClientHudElem(self);
    self.fk_title.archived = false;
    self.fk_title.y = 45;
    self.fk_title.alignX = "center";
    self.fk_title.alignY = "middle";
    self.fk_title.horzAlign = "center";
    self.fk_title.vertAlign = "top";
    self.fk_title.sort = 100; // force to draw after the bars
    self.fk_title.font = "objective";
    self.fk_title.fontscale = 3.5;
    self.fk_title.foreground = true;
    self.fk_title.shadown = 1;
    
    self.fk_title_low = newClientHudElem(self);
    self.fk_title_low.archived = false;
    self.fk_title_low.x = 0;
    self.fk_title_low.y = -35;
    self.fk_title_low.alignX = "center";
    self.fk_title_low.alignY = "bottom";
    self.fk_title_low.horzAlign = "center_safearea";
    self.fk_title_low.vertAlign = "bottom";
    self.fk_title_low.sort = 100; // force to draw after the bars
    self.fk_title_low.font = "objective";
    self.fk_title_low.fontscale = 1.4;
    self.fk_title_low.foreground = true;
    
    self.credits = newClientHudElem(self);
    self.credits.archived = false;
    self.credits.x = 0;
    self.credits.y = 0;
    self.credits.alignX = "left";
    self.credits.alignY = "bottom";
    self.credits.horzAlign = "left";
    self.credits.vertAlign = "bottom";
    self.credits.sort = 100; // force to draw after the bars
    self.credits.font = "default";
    self.credits.fontscale = 1.4;
    self.credits.foreground = true;

	
	
    self.fk_title.alpha = 1;
    self.fk_title_low.alpha = 1;
    self.top_fk_shader.alpha = 0.5;
    self.bottom_fk_shader.alpha = 0.5;
    self.credits.alpha = 1;

	
	
	
    self.credits setText("   ");
    self.fk_title_low setText(attacker.name);
    
    //if( !level.killcam_style )
        //self.fk_title setText("GAME WINNING KILL");
    //else
        self.fk_title setText("FINAL KILLCAM");
}

onPlayerKilled(eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration)
{
  
	if(attacker != self && sWeapon != "none")
    {
        level.showFinalKillcam = true;
        
        team = attacker.team;
        
        level.doFK[team] = true;
        
        if(level.teamBased)
        {
            level.KillInfo[team]["attacker"] = attacker;
            level.KillInfo[team]["attackerNumber"] = attacker getEntityNumber();
            level.KillInfo[team]["victim"] = self;
            level.KillInfo[team]["deathTime"] = GetTime()/1000;
        }
        else
        {
            attacker.KillInfo["attacker"] = attacker;
            attacker.KillInfo["attackerNumber"] = attacker getEntityNumber();
            attacker.KillInfo["victim"] = self;
            attacker.KillInfo["deathTime"] = GetTime()/1000;
        }
		
		wait 5;
    }
}



startFK( winner )
{
    level endon("end_killcam");
  
    if(!level.showFinalKillcam)
        return;
    
    if(!isPlayer(Winner) && !level.doFK[winner])
        return;
	
    level.fk = true;
  
    for( i = 0; i < level.players.size; i ++)  level.players[i] notify("beginFK", winner);
   
    
    slowMotion();

}

slowMotion()
{
    while(!isDefined(level.slowmostart))
        wait 0.05;
    
    wait (level.slowmostart - 0.1);
    
    SetDvar("timescale", ".3");
	
    for(i=0;i<level.players.size;i++)
        level.players[i] setclientdvar("timescale", ".3");
    
    wait 1.7;
    
    SetDvar("timescale", "1");
	
    for(i=0;i<level.players.size;i++)
        level.players[i] setclientdvar("timescale", "1");
}
