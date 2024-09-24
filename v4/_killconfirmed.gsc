#include common_scripts\utility;
#include maps\mp\gametypes\_hud_util;
#include maps\mp\_utility;
#include maps\mp\gametypes\_general_funcs;

init()
{
	level thread onPlayerConnect();
 
	level.gameModeDevName = "CONFIRMED";
	level.current_game_mode = "Kill Confirmed";
	
	level.yellow_circle = loadfx( "misc/ui_pickup_available" );
	game["dialog"]["gametype"] = undefined;
	
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
	
	self thread initIntelHunter();
	
	for(;;)
	{
		self waittill("spawned_player");
	 
	}
} 

initIntelHunter()
{
	level thread maps\mp\gametypes\_rank::registerScoreInfo("hardpoint",10);
	level thread maps\mp\gametypes\_rank::registerScoreInfo("kill",10);
	thread runIntelHunter();
}

runIntelHunter()
{
	level endon("game_ended");
	
	self.visuals = [];
	self.visuals2 = [];
	
	for(;;)
	{
		self waittill("death");
		
		next = self.visuals.size;
		self.visuals[next] = spawn("script_model",self getOrigin());
		self.visuals[next] setModel("prop_suitcase_bomb");
		self.trigers[next] = spawn("trigger_radius",self getOrigin(),1,32,32);
		self.visuals2[next] = spawnFX(level.yellow_circle, self getOrigin() + (0,0,0));
		TriggerFX(self.visuals2[next]);
		
		self.trigers[next] thread triggerIntel(self.visuals[next],self,self.visuals2[next]);
		self.visuals[next] thread bounceIntelHunter(self.trigers[next]);
		self.visuals[next] thread destroyVisuals(self.trigers[next]);
		self.visuals2[next] thread destroyVisuals(self.trigers[next]);
	}
}
triggerIntel(entity,owner,entity2)
{
	level endon("game_ended");
	self endon("destroyed");
	
	for(;;)
	{
		self waittill("trigger",player);
		
		if(player != owner && player.team != owner.team)
		{
			maps\mp\gametypes\_globallogic::givePlayerScore( "hardpoint", player, player );
			maps\mp\gametypes\_globallogic::giveTeamScore( "hardpoint", player.team, player, player );
			player thread maps\mp\gametypes\_rank::giveRankXP( "hardpoint", 10 );
			player thread HUD_confirmed("Kill Confirmed!",(255/255,230/255,0/255));
			//owner thread HUD_confirmed("Kill denied!",(1,0,0));
			
		}
		else if(player.team == owner.team)
		{
			maps\mp\gametypes\_globallogic::givePlayerScore( "hardpoint", player, player );
			player thread maps\mp\gametypes\_rank::giveRankXP( "hardpoint", 10 );
			player thread HUD_confirmed();
			player thread HUD_confirmed("Kill denied!",(1,0,0));
			//owner thread HUD_confirmed("Kill denied!",(1,0,0));
		}
		
		self notify("trigger_used");
		player playLocalSound("mp_suitcase_pickup");
		break;
	}
	
	self delete();
	entity delete();
	entity2 delete();

}
 


HUD_confirmed(qui,col)
{
	self notify("confirmed_new_kill");
	self endon("confirmed_new_kill");
	
	if(isDefined(self.Confirmed_HUD))
		self.Confirmed_HUD AdvancedDestroy(self);
	
	self.Confirmed_HUD["FRIEND"] = self createText("default", 1.4, "CENTER", "CENTER", 80 + self.AIO["safeArea_X"], 50 + self.AIO["safeArea_Y"], 1, 1, col);
	self.Confirmed_HUD["FRIEND"] setText(qui);
	
	
	self.Confirmed_HUD["FRIEND"] elemFade(2,0);
	wait 2;
	self.Confirmed_HUD["FRIEND"] AdvancedDestroy(self);
	
	
	//elemMoveY(time, input){self moveOverTime(time);self.y=input;}
	//elemMoveX(time, input){self moveOverTime(time);self.x=input;}
	//{self fadeOverTime(time);self.alpha=alpha;}
}


bounceIntelHunter(entity)
{
	entity endon("trigger_used");
	level endon("game_ended");
	
	bottomPos = self.origin+(0,0,25);
	topPos = self.origin+(0,0,45);
	while(isDefined(self))
	{
		self moveTo(topPos,.7,.2,.2);
		self rotateYaw(180,.7);
		wait(.7);
		self moveTo(bottomPos,.7,.2,.2);
		self rotateYaw(180,.7);
		wait(.7);
	}
}

destroyVisuals(entity)
{
	wait 40;
	
	if(isDefined(self))
	{
		self delete();
		entity delete();
	}
	entity notify("trigger_used");
	entity notify("destroyed");
}

showIconOnMap(shader)
{
	level.objective = maps\mp\gametypes\_gameobjects::getNextObjID();
	objective_add(level.objective,"invisible",(0,0,0));
	objective_position(level.objective,self.origin);
	objective_state(level.objective,"active");
	objective_team(level.objective,self.team);
	objective_icon(level.objective,shader);
}

      