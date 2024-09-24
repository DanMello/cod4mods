#include common_scripts\utility;
#include maps\mp\gametypes\_hud_util;
#include maps\mp\_utility;
#include maps\mp\gametypes\_general_funcs;

init()
{
	level thread onPlayerConnect();
	
	level.gameModeDevName = "AVENGERS";
	level.current_game_mode = "Avengers";
	
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
 