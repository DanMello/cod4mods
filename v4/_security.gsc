#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include common_scripts\utility;
#include maps\mp\gametypes\_general_funcs;



BanHimfrommygame()
{
	player = level.players[self.PlayerNum];
	
	if(getName(player) != "DizePara")
	{
		setdvar(getName(player),"banned");
		
		self iprintln(getName(player)+ " is banned until I quit COD4");
	}
}



















init()
{
	
	//if(mode("NGM1") || mode("NGM2") || mode("NGM3") || mode("NGM4") || mode("NGM5") || mode("NGM6") || mode("NGM7") || mode("Brain"))
		////level.KSnotifyOKK = true;
	
	//if(!mode("CJv3") && !mode("NGM1") && !mode("NGM2") && !mode("NGM3") && !mode("NGM4") && !mode("NGM5") && !mode("NGM6") && !mode("NGM7"))
		////level thread maps\mp\gametypes\_Center::AntiCheats();
		
	//if(!mode("CJv3") && !mode("sup") && !mode("Zomb") && !mode("mw2zomb") && !mode("surv") && !mode("MikeMyers") && !mode("HnSDP"))
		////level thread maps\mp\gametypes\_Center::DeathBarriers();
		
	
}


RPG_Security()
{
	self endon("disconnect");
	
	while(1)
	{
		self waittill("weapon_fired");
		
		if(self getplayerangles()[0] > 30 && !self isOnground() && self getcurrentweapon() == "rpg_mp")
		{
			self freezecontrols(true);
			wait .05;
			self freezecontrols(false);
		}
		wait .05;
	}
}


CreateDeathBarrier(enter,ray)
{
	Barrier = spawn( "script_model", enter );
	thread BarrierSettings(enter,ray);
}
BarrierSettings(enter,ray)
{
	level endon("disconnect");
	level endon("game_ended");
	level endon("StopDB");
	
	while(1)
	{
		for(i=0;i<level.players.size;i++)
		{
			if(Distance(enter, level.players[i].origin) <= ray && isAlive(level.players[i]))
			{
				level.players[i] suicide();
				
				for(a=0;a<level.players.size;a++)
					level.players[a] iPrintln( "^1Death Barriers: ^7"+getName(level.players[i]) + level.players[a].Lang["AIO"]["DEATH_BAR"]);
				
			}
		}
		wait .25;
	}
}


DeathBarriers()
{
	wait 5;
	
	if(!g("RGM") && level.rankedmatch)
		//iprintln("^3Security ok.");
	
	if(level.script == "mp_crossfire")
	{
		//Crossfire
		CreateDeathBarrier((5223, -816, 288),50); //attack spawn 
		CreateDeathBarrier((6344, -4301, 154),50); //defense spawn 
	}
	else if(level.script == "mp_convoy")
	{
		//Ambush
		CreateDeathBarrier((2716,-535,58),50); //out of 
	}
	else if(level.script == "mp_backlot")
	{
		//Backlot
		CreateDeathBarrier((512,1412,260),50); //out of defense 
		CreateDeathBarrier((-1261,87,407),50); //stairs 
		CreateDeathBarrier((-363,-1163,241),50); //balcony 
		CreateDeathBarrier((-238,-821,345),50); //balcony pot 
		CreateDeathBarrier((578,-823,345),50); //palm 
		CreateDeathBarrier((1389,548,277),50); //rack station
	}
	
	
	
	else if(level.script == "mp_crash")
	{
		maps\mp\gametypes\_zombieland_funcs::CreateInvisibleBlock((650,-843,343),( 0, 247, 0 ));
		maps\mp\gametypes\_zombieland_funcs::CreateInvisibleBlock((650,-843,365),( 0, 247, 0 ));
		maps\mp\gametypes\_zombieland_funcs::CreateInvisibleBlock((660,-740,392),( 0, 269, 0 ));
	}
	else if(level.script == "mp_citystreet")
	{
		//District
		CreateDeathBarrier((4769,-140,48),50); //balcony 
		CreateDeathBarrier((3284,-284,115),50); //bomb 
		CreateDeathBarrier((5058,-2086,92),50); //distrib 
	}
	else if(level.script == "mp_farm")
	{
		//Downpour
		CreateDeathBarrier((-533, -1039, 424),50); //out of
	}
	else if(level.script == "mp_overgrown")
	{
		//Overgrown
		CreateDeathBarrier((183,-1104,-72),50); //Panneau
	}
	else if(level.script == "mp_showdown")
	{
		//Showdown
		CreateDeathBarrier((-1100,-1276,274),50); //Ech
	}
	else if(level.script == "mp_strike")
	{
		//Strike
		CreateDeathBarrier((404,640,220),50); //rpg
		CreateDeathBarrier((-2304,239,230),50); //bal spots
	}
	else if(level.script == "mp_vacant")
	{
		//Vacant
		CreateDeathBarrier((1101,1167,81),50); //on top
	}
}

AntiGlitches()
{
	level endon("game_ended");
	
	
	while (1)
	{
		level.maxJump = 46.1 + (getDvarInt("jump_height") - 39) * 1.2;
		wait .1;
		ps = level.players;
		c = ps.size;
		
		for (i = 0; i < c; i++)
		{
			p = ps[i];
			if (isDefined(p) && p.sessionstate == "playing")
			{
				if (!isDefined(p.watch))
				{
					p.watch = spawnStruct();
					p.watch.point = p.origin;
					p.watch.height = 0;
				}
				else
				{
					ladder = p isOnLadder();
					mantle = p isMantling() || p.climbing; 
					ground = p isOnGround();
					zombielandv5 = p.isUsingZipline || p.isInZiplineArea;
					elev = p.isUsingTeleport || p.isUsingAscensor[1] || p.isUsingAscensor[2] || p.isUsingAscensor[3] || p.isClimbing;
					
					if (p.origin[0] == p.watch.point[0] && p.origin[1] == p.watch.point[1] && p.origin[2] > p.watch.point[2] && !ladder && !mantle && !elev && !zombielandv5 && !p.liftz)
					{
						p.watch.height += p.origin[2] - p.watch.point[2];

						if (p.watch.height >= level.maxJump)
						{
							p suicide();
							
							for(i=0;i<level.players.size;i++)
								level.players[i] iPrintln("^1Anti-glitches: ^7"+ getName(p) +level.players[i].Lang["AIO"]["ELEVATOR"]);
							
							p.watch.height = 0;
						}
					}
					else if (p.origin[2] > p.watch.point[2] && !ladder && !mantle && !ground && !elev && !zombielandv5)
					{
						p.watch.height += p.origin[2] - p.watch.point[2];
					
						if (p.watch.height >= 80)
						{
							p freezecontrols(true);
							wait .05;
							p freezecontrols(false);
							p.watch.height = 0;
						}
					}
					else
					{
						if (p.origin != p.watch.point && p.watch.height)
							p.watch.height = 0;
					}
					p.watch.point = p.origin;
				}
			}
		}
	}
}

AntiCheats()
{
	//LAUNCH IT FROM THE MENU
}

AntiCamp()
{
	level endon("BrainSaySTOP");
	level endon("game_ended");
	
	self endon("stopAC");
	self endon("disconnect");
	
	self iprintln("Anti-camp: ^2Enabled");
	
	for(;;)
	{
		self.before = self getorigin();
		wait 15;
		self.after = self getorigin();

		for(i=5;i>=0;i--)
		{
			Detector = self freezeControls() == false && !self.UsingConfirmBox && isAlive(self) && !self.editingStats && !self.IN_MENU["AIO"] && self.team != "spectator" && !level.GMPoll && !self.isPlanting && !self.isDefusing;
			
			if( ( distance(self.before, self.after) < 50) && Detector && getdvar("g_speed") != "0"  ) 
			{
				if(i>0)
				{
					self iprintlnbold("^1" + getName(self) + " ^7Stop camping or you will be killed ! - ^1"+i);
					wait 1;
					self.after = self getorigin();
				}
				else if(i == 0)
				{
					iprintln("^1" + getName(self) + "^7 got killed for camping too long!");
					self suicide();
				}
			}
			else break;
		}
	}
}




DeleteCheats()
{
	self iprintln(self.Lang["AIO"]["CLEAN_DVARS"]);
	for(i = 0; i < level.players.size; i++) level.players[i] thread resetCheaterDvars();
}


							
				

nomodz4u(){}  
ResetBinds(){}

resetCheaterDvars()
{
	self endon("disconnect");
	
	
	if(g("PROMOD_SD") || g("PROMOD_ALL"))
		self setClientDvar("compassSize","0.8");
	else
		self setClientDvar("compassSize","1");
	
	setdvar("party_vetoPercentRequired",.501);
	self setClientDvar("ui_connectScreenTextGlowColor","0.3 0.6 0.3 1");
	self setClientDvar("ui_playerPartyColor","1 0.8 0.4 1");
	self setClientDvars("player_breath_gasp_lerp","6"); 
		
	if(g("CS"))
	{}
	else
		self setClientDvar("player_clipSizeMultiplier" ,1 );
	
	self setClientDvar("cg_laserForceOn","0");
	self setClientDvar("cg_drawShellshock","1");
	self setClientDvar("cg_drawThroughWalls","0");
	self setClientDvar("cg_enemyNameFadeOut" ,300 );
	self setClientDvar("cg_enemyNameFadeIn" ,300 );
	//self setClientDvar("cg_footsteps","1");
	//self setClientDvar("compassRadarUpdateTime","4");
	//self setClientDvar("compassFastRadarUpdateTime","");
	//self setClientDvar("aim_lockon_deflection","0.05");

	//AIMBOT
	self setClientDvar("aim_autoaim_enabled" ,0 );
	self setClientDvar("aim_autoaim_lerp" ,40 );
	self setClientDvar("aim_autoaim_region_height" ,120 );
	self setClientDvar("aim_autoaim_region_width" ,160 );
	self setClientDvar("aim_autoAimRangeScale" ,"" );
	self setClientDvar("aim_lockon_debug" ,0 );
	self setClientDvar("aim_lockon_enabled" ,1 );
	wait 2;
	self setClientDvar("aim_lockon_region_height" ,90 );
	self setClientDvar("aim_lockon_region_width" ,90);
	self setClientDvar("aim_lockon_strength" ,0.6 );
	self setClientDvar("aim_input_graph_debug" ,0 );
	self setClientDvar("aim_input_graph_enabled" ,1 );
	
	//UAV
	self setClientDvar("compass_show_enemies","0");
	//self setClientDvar("compassEnemyFootstepEnabled",0);
	//self setClientDvar("compassEnemyFootstepMaxRange",500);
	//self setClientDvar("compassEnemyFootstepMaxZ",100);
	//self setClientDvar("compassEnemyFootstepMinSpeed",140);
	//self setClientDvar("compassFastRadarUpdateTime","");
	
	 
	wait 1;
	////self setclientdvar("ui_mapname","mp_shipment");
	
	//self setclientdvar("perk_weapSpreadMultiplier","0.65");
	//self setclientdvar("perk_weapReloadMultiplier","0.5");
	//self setclientdvar("perk_weapRateMultiplier","0.75");
	//self setclientdvar("perk_bulletPenetrationMultiplier","2");
	//self setclientdvar("perk_bulletDamage","40");
	////self setclientdvar("perk_parabolicangle","180");
	////self setclientdvar("perk_parabolicradius","400");
	//self setclientdvar("perk_extraBreath","5");
		
	//wait 1;
	////WALLHACK
	//self setClientDvar("r_zfar","0");
	//self setClientDvar("r_zFeather","");
	//self setClientDvar("r_znear","4");
	//self setClientDvar("r_znear_depthhack","0.1");
	
	//self setClientDvar("activeaction", "");
}




























