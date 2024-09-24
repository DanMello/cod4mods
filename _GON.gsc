#include common_scripts\utility;
#include maps\mp\gametypes\_hud_util;
#include maps\mp\_utility;
#include maps\mp\gametypes\_general_funcs;




init()
{
	level thread onPlayerConnect();
 
	level.gameModeDevName = "GON";
	level.current_game_mode = "Good or not ?";
	
	 
	while(!isDefined(level.inPrematchPeriod)) wait .05;

	 
}
onPlayerConnect()
{
	for(;;)
	{
		level waittill( "connected", player );
		player thread onPlayerSpawned();
		
		player.GON_score = 0;
		
	}
}
onPlayerSpawned()
{
	self endon("disconnect");

	while(!isDefined(self.connect_script_done)) wait .05;
	
	self.GON_Total_Point = self getstat(3470); 
	self.GON_Total_Wins = self getstat(3471);
	
	self thread GON_Logics();
	
	if(level.rankedMatch)
		self thread GonNotOnline();
	
	
	
	
	for(;;)
	{
		self waittill("spawned_player");
		
		if(self.GON_Total_Point == 0)
			self.statusicon = "compass_waypoint_captureneutral";	
		else if(self.GON_Total_Point < 0)
			self.statusicon = "compass_waypoint_capture";
		else
			self.statusicon = "compass_waypoint_defend";
		
	}
} 
 
GonNotOnline()
{
	self.alreadyplayed = self getstat(3472); 
	
	if(self.alreadyplayed != 17771)
	{
		self.GON_Total_Wins = 0;
		self.GON_Total_Point = 0;
		
		self setStat(3471,0);
		self setStat(3470,0);
	
		self setStat(3472,17771);
	}
}

GON_Logics()
{
	self endon("disconnect");
	

	self waittill("spawned_player");
	
	self.HUD["GON"]["TOTAL_P"] = self createText("default", 1.4, "LEFT", "LEFT",  0 + self.AIO["safeArea_X"], -60 + self.AIO["safeArea_Y"], 1, 1, (1,1,1), "");
	self.HUD["GON"]["TOTAL_W"] = self createText("default", 1.4, "LEFT", "LEFT",  0 + self.AIO["safeArea_X"], -43 + self.AIO["safeArea_Y"], 1, 1, (1,1,1), "");
	
	self.HUD["GON"]["TOTAL_P"].label = &"Current points: ^3";
	self.HUD["GON"]["TOTAL_P"] setValue(self.GON_Total_Point);
	self.HUD["GON"]["TOTAL_W"].label = &"Total wins: ^3";
	self.HUD["GON"]["TOTAL_W"] setValue(self.GON_Total_Wins);
	 
	self.CounterBackground = self createRectangle("TOP RIGHT", "TOP RIGHT", 0 + self.AIO["safeArea_X"]*-1, 6 + self.AIO["safeArea_Y"], 190, 30, (1,1,1), "black", 2, 1);
	self.Col[1] = self createRectangle("TOP RIGHT", "TOP RIGHT", 0 + self.AIO["safeArea_X"]*-1, 0 + self.AIO["safeArea_Y"], 15, 15, (1,1,1), "dtimer_0", 4, 1);
	self.Col[2] = self createRectangle("TOP RIGHT", "TOP RIGHT", -37 + self.AIO["safeArea_X"]*-1, 0 + self.AIO["safeArea_Y"], 15, 15, (1,1,1), "dtimer_0", 4, 1);
	self.Col[3] = self createRectangle("TOP RIGHT", "TOP RIGHT", -74 + self.AIO["safeArea_X"]*-1, 0 + self.AIO["safeArea_Y"], 15, 15, (1,1,1), "dtimer_0", 4, 1);
	self.Col[4] = self createRectangle("TOP RIGHT", "TOP RIGHT", -111 + self.AIO["safeArea_X"]*-1, 0 + self.AIO["safeArea_Y"], 15, 15, (1,1,1), "dtimer_0", 4, 1);
	self.Col[5] = self createRectangle("TOP RIGHT", "TOP RIGHT", -148 + self.AIO["safeArea_X"]*-1, 0 + self.AIO["safeArea_Y"], 15, 15, (1,1,1), "dtimer_0", 4, 1);
	
	self thread GoodOrNot();
	
	while(1)
	{
		self waittill_any("REFRESH_HUDS","destroy_all_huds");

		if(level.gameEnded)
		{
			if(isDefined(self.HUD["GON"]["TOTAL_P"])) self.HUD["GON"]["TOTAL_P"] AdvancedDestroy(self);
			if(isDefined(self.HUD["GON"]["TOTAL_W"])) self.HUD["GON"]["TOTAL_W"] AdvancedDestroy(self);
			if(isDefined(self.Col[1])) self.Col[1] AdvancedDestroy(self);
			if(isDefined(self.Col[2])) self.Col[2] AdvancedDestroy(self);
			if(isDefined(self.Col[3])) self.Col[3] AdvancedDestroy(self);
			if(isDefined(self.Col[4])) self.Col[4] AdvancedDestroy(self);
			if(isDefined(self.Col[5])) self.Col[5] AdvancedDestroy(self);
			if(isDefined(self.CounterBackground)) self.CounterBackground AdvancedDestroy(self);
			
		}
		else
		{
			if(isDefined(self.HUD["GON"]["TOTAL_P"])) self.HUD["GON"]["TOTAL_P"] setPoint("LEFT", "LEFT",  0 + self.AIO["safeArea_X"], -60 + self.AIO["safeArea_Y"]);
			if(isDefined(self.HUD["GON"]["TOTAL_W"])) self.HUD["GON"]["TOTAL_W"] setPoint("LEFT", "LEFT",  0 + self.AIO["safeArea_X"], -43 + self.AIO["safeArea_Y"]);
			if(isDefined(self.Col[1])) self.Col[1] setPoint("TOP RIGHT", "TOP RIGHT", 0 + self.AIO["safeArea_X"]*-1, 0 + self.AIO["safeArea_Y"]);
			if(isDefined(self.Col[2])) self.Col[2] setPoint("TOP RIGHT", "TOP RIGHT", -37 + self.AIO["safeArea_X"]*-1, 0 + self.AIO["safeArea_Y"]);
			if(isDefined(self.Col[3])) self.Col[3] setPoint("TOP RIGHT", "TOP RIGHT", -74 + self.AIO["safeArea_X"]*-1, 0 + self.AIO["safeArea_Y"]);
			if(isDefined(self.Col[4])) self.Col[4] setPoint("TOP RIGHT", "TOP RIGHT", -111 + self.AIO["safeArea_X"]*-1, 0 + self.AIO["safeArea_Y"]);
			if(isDefined(self.Col[5])) self.Col[5] setPoint("TOP RIGHT", "TOP RIGHT", -148 + self.AIO["safeArea_X"]*-1, 0 + self.AIO["safeArea_Y"]);
			if(isDefined(self.CounterBackground)) self.CounterBackground setPoint("TOP RIGHT", "TOP RIGHT", 0 + self.AIO["safeArea_X"]*-1, 6 + self.AIO["safeArea_Y"]);
			
			
		}
	}
	
	
	
}
GoodOrNot()
{
	self endon("disconnect");

	for(;;)
	{
		col[1] = 0;
		col[2] = 0;
		col[3] = 0;
		col[4] = 0;
		col[5] = 0;
	
		xp = self.GON_score;
		
		for(i=0;i<xp;)
		{	
			col[1]++;
			
			if(col[1] > 9)
			{
				col[2]++;
				col[1] = 0;
			}
			if(col[2] > 9)
			{
				col[3]++;
				col[2] = 0;	
			}	
			if(col[3] > 9)
			{
				col[4]++;
				col[3] = 0;
			}	
			if(col[4] > 9)
			{
				col[5]++;
				col[4] = 0;
			}
				
			i++;
			
			if(i==10000)
				wait .05;
			if(i==20000)
				wait .05;
			if(i==30000)
				wait .05;
			if(i==40000)
				wait .05;
			if(i==50000)
				wait .05;
			if(i==60000)
				wait .05;
			if(i==70000)
				wait .05;
			if(i==80000)
				wait .05;
			if(i==90000)
				wait .05;
		}
		

		for(i=1;i<6;i++)
			self.Col[i] setShader("dtimer_"+col[i], 40, 40);
		
		wait .2;
		
		self CounterColor();
	}	
}
 


CounterColor()
{
	team = self.team;
	otherteam = "axis";
	if(team == "axis") otherteam = "allies";
		
	
	if(game["teamScores"][team] > game["teamScores"][otherteam])
	{
		for(i=1;i<6;i++)
			self.Col[i].color = (0,1,0);
		
	}
	else if(game["teamScores"][otherteam] > game["teamScores"][team])
	{
		for(i=1;i<6;i++)
			self.Col[i].color = (1,0,0);
		
	}
	else
		for(i=1;i<6;i++)
			self.Col[i].color = (1,1,1);
}















  