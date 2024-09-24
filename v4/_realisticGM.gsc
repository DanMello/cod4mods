#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include maps\mp\gametypes\_general_funcs;




init()
{
	level thread onPlayerConnect();
	
	level.current_game_mode = "Realistic Mod";
	level.gameModeDevName = "RGM";
	level.waitinghelicotime = 35;
	//level.hardcoreMode = true;
	//setDvar("scr_hardcore", "1");
	setDvar( "ui_hud_hardcore", 1 );
	
	level.airstrikefx = loadfx ("explosions/clusterbomb");
	level.mortareffect = loadfx ("explosions/artilleryExp_dirt_brown");
	level.bombstrike = loadfx ("explosions/wall_explosion_pm_a");
	
	level.fx_airstrike_afterburner = loadfx ("fire/jet_afterburner");
	level.fx_airstrike_contrail = loadfx ("smoke/jet_contrail");
	
	level.fx_heli_dust = loadfx ("treadfx/heli_dust_default");
	level.fx_heli_water = loadfx ("treadfx/heli_water");
	
	level.yellow_circle = loadfx( "misc/ui_pickup_available" );
	PrecacheShader("death_helicopter"); 
	PrecacheModel("vehicle_mig29_desert");
	
	
	precacheString( &"QUICKMESSAGE_REGROUP" );
	precacheString( &"QUICKMESSAGE_AREA_SECURE" );
	
	
	
	//HELICO SPAWN STYLE
	level.Helico["allies"] = false;
	level.Helico["axis"] = false;
	
	for(i=0;i<18;i++)level.HelicoPosition["allies"][i] = undefined;
	for(i=0;i<18;i++)level.HelicoPosition["axis"][i] = undefined;
	
	level.heli_start_nodes = getEntArray("heli_start","targetname");
	
	level.HelicopterLeave["allies"] = false;
	level.HelicopterLeave["axis"] = false;
	
	level.PassagerNumber["allies"] = 0;
	level.PassagerNumber["axis"] = 0;
	
	
	
	while(!isDefined(level.inPrematchPeriod)) wait .05;
	

	level thread NUKEMOICA();
	
	game["strings"]["change_class"] = "";

	game["music"]["spawn_axis"] = undefined;
	game["music"]["spawn_allies"] = undefined;
}

onPlayerConnect()
{
	for(;;)
	{
		level waittill( "connected", player );
			
		player.isInHelicopter = false;
		
		player thread onPlayerSpawned();
	}
}

onPlayerSpawned()
{
	self endon("disconnect");
	
	self thread onFirstSpawn();
	
	if(!level.HelicopterLeave[self.team] && level.inPrematchPeriod)
		self thread RealisticIntro();
	else if(!level.inPrematchPeriod)
		self thread arriveEnHelico();
	
	//self.inENDING = false;
		
	for(;;)
	{
		self waittill("spawned_player");
		
		if(isDefined(self.OverlayDead))
		{
			self.OverlayDead advancedDestroy(self);
			self setclientdvar("r_blur","0");
		}
	
		self.maxhealth = 71;
		self.health = self.maxhealth;
		
		//wait 2;
		//if(level.inPrematchPeriod)
		//self thread maps\mp\gametypes\_CJfuncs::addRobot("copain");
		
	}
}

















arriveEnHelico()
{
	
	self.ReachedMyPosition = false;
	
	self waittill("spawned_player");	
	
	self.FirstPos = self.origin;
	self.FirstAng = self.angles;
	passagerr = self.name;
	
	startNode = level.heli_start_nodes[randomInt(level.heli_start_nodes.size)];
	heliOrigin = startnode.origin;
	heliAngles = startnode.angles;
	level.Copter[passagerr] = MakeHeli(heliOrigin+(0,0,800),heliAngles,self,1);
	
	level.Platform[passagerr] = spawn("script_model",level.Copter[passagerr].origin);
	level.Platform[passagerr] setModel("weapon_c4");
	level.Platform[passagerr] Hide();
	level.Platform[passagerr] linkTo(level.Copter[passagerr]);
	
	level.Copter[passagerr] thread TrajetMilieu(self,passagerr);  
	
	self thread JoinHelicopterInGame();
	
	self waittill("disconnect");
	
	if(isdefined( level.Platform[passagerr])) level.Platform[passagerr] delete();
	if(isdefined( level.Platform[passagerr])) level.Copter[passagerr] delete();
}

TrajetMilieu(player,team)
{
	 
	self SetSpeed(30,20);
	
	
	while(distance(self.origin, (player.FirstPos[0],player.FirstPos[1],player.origin[2])) > 4 && isDefined(player) && !player.ReachedMyPosition) 
	{
		if(!isDefined(player)) break;
		if(!isDefined(player.FirstPos)) break;
					
		level.Copter[player.name] setVehGoalPos(player.FirstPos+(0,0,1700),1);
			
		wait .05;
	}
	
	wait .5;
	self SetSpeed(40,40);
		
	wait 2;
	
	level.Platform[player.name] delete();
	
	currentNode = level.heli_start_nodes[randomInt(level.heli_start_nodes.size)];
	nextNode = getEnt(currentNode.target,"targetname");
	
	self SetSpeed(70,50);
	self setVehGoalPos(nextNode.origin,1);
	self waittillmatch("goal");
	self delete();
}

JoinHelicopterInGame()
{
	
	
	self thread OnDisconnect();
	self.isInHelicopter = true;
	self hide();
	self freezecontrols(true);
	self DisableWeapons();
	self.BlackScreen = self createRectangle("center", "center", 0, 0, 960, 480, (0,0,0), "white", 20, 1);
	
	
	while(!isDefined(level.Platform[self.name]))
	{
		wait .05;
		//if(!isdefined(self))
		
	}
	
	self LinkTo(level.Platform[self.name],"tag_origin",(0,0,-60),(0,0,0));
	
	Helicopter = level.Copter[self.name];
	
	self setClientDvar("cg_thirdperson","1");
	self setClientDvar("cg_thirdPersonRange", 900);
	self setClientDvar("cg_thirdPersonAngle", 300 );
	self thread BlackScreenEffect();
	
	while(distance(Helicopter.origin,(self.FirstPos[0],self.FirstPos[1],Helicopter.origin[2])) > 4) 
	{
		wait .05;
		self setPlayerAngles(Helicopter.angles + (40,Helicopter.angles[1],Helicopter.angles[2]));
	}
	
	self notify("ReachedPos");
	self.ReachedMyPosition = true;
	
	self setPlayerAngles(self.FirstAng);
	
	self unlink();
	self LinkTo(level.Platform[self.name],"tag_origin",(0,0,-200),(0,0,0));
	
	wait .1;
	
	self unlink();
	self show();
	
	Platform = spawn("script_model",self.origin);
	Platform setModel("weapon_c4");
	Platform Hide();
	self linkto(Platform);
	
	Platform moveto(self.FirstPos,4);
	
	self thread CameraEffect();
	
	wait .1;
	self setClientDvar("cg_thirdperson","0");
	self setClientDvar("cg_thirdPersonRange", 120);
	self setClientDvar("cg_thirdPersonAngle", 356 );
	
	wait 4;
	self unlink();
	Platform delete();
	
	self.enmodereeloui = true;
	
	
	
	
	if(!level.inPrematchPeriod)
	{
		self freezecontrols(false);
		//self EnableWeapons();
	}
	else
		self freezecontrols(true);
	
	wait 2;
	
}


RealisticIntro()
{
	self.ReachedMyPosition = false;
	
	self waittill("spawned_player");	
	
	self.FirstPos = self.origin;
	self.FirstAng = self.angles;
	
	if(isDefined(level.PrematchTimer) && level.PrematchTimer < 5) return;
	if(!level.inPrematchPeriod) return;

	level.PassagerNumber[self.team]++;
	
	if(!level.Helico["allies"] && self.team == "allies")
		level.Helico["allies"] = true;
	
	else if(!level.Helico["axis"] && self.team == "axis") 
		level.Helico["axis"] = true;
	
	else if(!level.HelicopterLeave[self.team])
	{
		self thread JoinHelicopter();
		return;
	}
	else
	{
		self.ReachedMyPosition = true;
		return;
	}
	
	
	startNode = level.heli_start_nodes[randomInt(level.heli_start_nodes.size)];
	heliOrigin = startnode.origin;
	heliAngles = startnode.angles;
	level.Copter[self.team] = MakeHeli(heliOrigin+(0,0,800),heliAngles,self,1);
	
	level.Platform[self.team] = spawn("script_model",level.Copter[self.team].origin);
	level.Platform[self.team] setModel("weapon_c4");
	level.Platform[self.team] Hide();
	level.Platform[self.team] linkTo(level.Copter[self.team]);
	
	level.Copter[self.team] thread Trajet(self,self.team);  
	
	self thread JoinHelicopter();
	
}   

JoinHelicopter()
{
	for(i=0;i<18;i++)
	{
		if(!isDefined(level.HelicoPosition[self.team][i]))
		{
			level.HelicoPosition[self.team][i] = i;
			break;
		}
	}
	
	self thread OnDisconnect();
	self.isInHelicopter = true;
	self hide();
	self freezecontrols(true);
	self DisableWeapons();
	self.BlackScreen = self createRectangle("center", "center", 0, 0, 960, 480, (0,0,0), "white", 20, 1);
	
	
	while(!isDefined(level.Platform[self.team])) wait .05;
	
	self LinkTo(level.Platform[self.team],"tag_origin",(0,0,-60),(0,0,0));
	
	Helicopter = level.Copter[self.team];
	
	self setClientDvar("cg_thirdperson","1");
	self setClientDvar("cg_thirdPersonRange", 900);
	self setClientDvar("cg_thirdPersonAngle", 300 );
	self thread BlackScreenEffect();
	
	while(distance(Helicopter.origin,(self.FirstPos[0],self.FirstPos[1],Helicopter.origin[2])) > 4) 
	{
		wait .05;
		self setPlayerAngles(Helicopter.angles + (40,Helicopter.angles[1],Helicopter.angles[2]));
	}
	
	self notify("ReachedPos");
	self.ReachedMyPosition = true;
	level.PassagerNumber[self.team]--;
	
	self setPlayerAngles(self.FirstAng);
	
	self unlink();
	self LinkTo(level.Platform[self.team],"tag_origin",(0,0,-200),(0,0,0));
	
	wait .1;
	
	self unlink();
	self show();
	
	Platform = spawn("script_model",self.origin);
	Platform setModel("weapon_c4");
	Platform Hide();
	self linkto(Platform);
	
	Platform moveto(self.FirstPos,4);
	
	self thread CameraEffect();
	
	wait .1;
	self setClientDvar("cg_thirdperson","0");
	self setClientDvar("cg_thirdPersonRange", 120);
	self setClientDvar("cg_thirdPersonAngle", 356 );
	
	wait 4;
	self unlink();
	Platform delete();
	
	self.enmodereeloui = true;
	
	
	
	if(!level.inPrematchPeriod)
	{
		self freezecontrols(false);
		//self EnableWeapons();
	}
	else
		self freezecontrols(true);
	
	wait 2;
	
}
MakeHeli(SPoint,forward,owner,b)
{
	Copter = spawnHelicopter(owner,SPoint,forward,"cobra_mp","vehicle_mi24p_hind_desert");
	Copter playLoopSound("mp_hind_helicopter");
	Copter.currentstate = "ok";
	Copter setdamagestage(4);
	Copter.lifeId = 0;
	Copter.maxhealth = level.heli_maxhealth*2;
	Copter.waittime=level.heli_dest_wait;
	Copter.loopcount=0;
	Copter.evasive=false;
	Copter.health_bulletdamageble = level.heli_armor;
	Copter.health_evasive = level.heli_armor;
	Copter.health_low = level.heli_maxhealth*0.8;
	Copter.targeting_delay = level.heli_targeting_delay; 
	return Copter;
}
OnDisconnect()
{
	self endon("ReachedPos");
	self waittill("disconnect");
	level.PassagerNumber[self.team]--;
	
}
Trajet(player,team)
{
	 
	self SetSpeed(30,20);
	
	while(level.PassagerNumber[team] != 0)
	{
		for(a=0;a<level.players.size;a++)
		{
			if(!level.players[a].ReachedMyPosition && level.players[a].team == team && isDefined(level.players[a]))
			{
				while(distance(self.origin, (level.players[a].FirstPos[0],level.players[a].FirstPos[1],self.origin[2])) > 4 && isDefined(level.players[a])) 
				{
					if(!isDefined(level.players[a])) break;
					if(!isDefined(level.players[a].FirstPos)) break;
					
			
					level.Copter[level.players[a].team] setVehGoalPos(level.players[a].FirstPos+(0,0,1700),1);
				
					wait .05;
				}
				wait .5;
				self SetSpeed(40,40);
			}
			//iprintln(level.PassagerNumber[team]);
		}
		
		if(level.PassagerNumber[team] == 0) wait 5;
		
		wait .05;
	}
	
	//iprintln(level.PassagerNumber[team]);
	
	level.HelicopterLeave[team] = true;
	
	wait 2;
	
	level.Platform["allies"] delete();
	level.Platform["axis"] delete();	
	
	currentNode = level.heli_start_nodes[randomInt(level.heli_start_nodes.size)];
	nextNode = getEnt(currentNode.target,"targetname");
	
	self SetSpeed(70,50);
	self setVehGoalPos(nextNode.origin,1);
	self waittillmatch("goal");
	self delete();
}
CameraEffect()
{
	for(i=-100;i<0;i+=1.5)
	{
		self setPlayerAngles((i,self.FirstAng[1],self.FirstAng[2]));
		wait .05;
	}
	
	wait 1.5;
	
	self enableWeapons();
}
BlackScreenEffect()
{
	wait 2;
	
	self.BlackScreen fadeOverTime(3);
	self.BlackScreen.alpha = .4;
	wait 3;
	self.BlackScreen destroy();
}


Sun()
{ 
	for(a=-10;;a+=0.03)
	{
		self setclientdvar("r_lighttweaksundirection",("-29 "+a +" 0"));
		wait 3;
		
	}
}
onFirstSpawn()
{
	self waittill("spawned_player");
	
	self setClientDvars(
	"r_filmTweakBrightness","0.15", //0.33
	"r_filmTweakContrast","1.15", //1.5
	"r_filmTweakDarktint","0.4 0.42 0.7" , //1 1.1 1.337
	"r_filmTweakDesaturation","0.2" , //0
	"r_filmTweakEnable","1", //1
	"r_filmTweakLighttint","1.2 1.1 1" , //0.6.0.8.1
	"r_filmTweakInvert","0" , //0
	"r_filmUseTweaks","1", //1 \par
	"r_glowUseTweaks","0", //0
	"r_glowTweakEnable","0"); //0
	wait 1;
	self setClientDvars( 
	"r_glowTweakBloomCutoff","0.9", //0.5
	"r_glowtweakbloomintensity0",".8", //.1
	"r_glowTweakradius0","5" , //5
	"r_glow_allowed","1" , //0
	"r_glow_enable","0" , //0
	"r_glow","1" , //1 ETAIT SUR 0
	"r_lightTweakSunDirection","-29 240 0", //000
	"r_lightTweakSunColor","1 0.8 0.5 1", //0101
	"r_lighttweaksunlight","1.5" , //1
	"r_lodBiasRigid","-1000");
	
	wait 2;
	self setClientDvars( 
	"r_lodBiasSkinned","-1000",
	"r_lodScaleRigid","1" ,
	"r_lodScaleSkinned","1" ,
	"r_drawDecals","1",
	"r_drawSun","0",
	"r_drawWater","1" ,
	"r_specular","1" ,
	"r_distortion","1",
	"r_zfeather","1" ,
	"r_fog","1");
	wait 1;
	self setClientDvars( 
	"r_detail","0",
	"r_brightness","0.025" ,
	"r_clear","4",
	"r_dlightLimit","4" ,
	"r_contrast","1.1" ,
	"r_specularcolorscale","4",
	"r_gamma","1",
	"r_blur","0",
	"r_desaturation","0" ,
	"r_smc_enable","1");
	wait 1;
	self setClientDvars( 
	"sm_enable","1",
	"sm_polygonoffsetscale","2",
	"sm_polygonoffsetbias","0" ,
	"sm_sunshadowscale","1" ,
	"sm_polygonoffsetbias","0.5" ,
	"sm_maxLights","4",
	"sm_sunsamplesizenear","1" ,
	"r_sunblind_fadein","0" ,
	"r_sunblind_fadeout","0");
	wait 1;
	self setClientDvars( 
	"r_sunblind_max_angle","90",
	"r_sunflare_max_size","10000",
	"r_sunflare_min_size","10000" ,
	"r_sunsprite_size","1000" ,
	"r_sun_from_dvars","0",
	"r_smc_enable","1");
	
	self thread Environment();
	self thread RealAmmoClip();
	
		
	//self thread DPAD_Monitor();
	
	/*
	self setclientdvar("r_filmtweakenable","1");
	self setclientdvar("r_filmTweakInvert","0");
	self setclientdvar("r_filmusetweaks","1");
	self setclientdvar("r_filmtweakdesaturation","0.25");
	self setclientdvar("r_filmtweakcontrast","1.1");
	self setclientdvar("r_filmtweakbrightness","0");
	self setclientdvar("r_filmTweakdarkTint",".9 .9 1 1");
	self setclientdvar("r_filmTweakLightTint",".9 .9 1 1");
	self setclientdvar("r_lightTweakSunDiffuseColor","0.74902 0.839216 1 1");
	self setclientdvar("r_lightTweakSunDirection","-10");
	self setclientdvar("r_lightTweakSunColor","1 0.430 0.101");
	self setclientdvar("r_lightTweakSunLight","2.0");
	wait 3;
	self setclientdvar("r_glow","1");
	self setclientdvar("r_glow_allowed","1");
	self setclientdvar("r_glow_enable","1");
	self setclientdvar("r_glowTweakBloomCutoff","0.434524");
	self setclientdvar("r_glowTweakBloomIntensity0","0.595238");
	self setclientdvar("r_glowTweakEnable","1");
	self setclientdvar("r_glowTweakRadius0","10.0952");
	self setclientdvar("r_glowUseTweaks","1");
	self setclientdvar("r_fog","0");
	wait 2;
	self setclientdvar("r_distortion","1");
	self setclientdvar("r_specular","1");
	self setclientdvar("r_gamma","1");
	self setclientdvar("r_specularmap","1.5");
	self setclientdvar("r_specularcolorscale","3");
	self setclientdvar("r_normalMap","1");
	self setclientdvar("r_detail","0");
	self setclientdvar("r_detail","1");
	self setclientdvar("r_blur","0.0");
	wait 2;

	self setclientdvar("r_lodBiasSkinned","-1000");
	self setclientdvar("r_lodscalerigid","1");
	self setclientdvar("r_lodscaleskinned","1");
	self setclientdvar("r_lodBiasRigid","-1000");
	self setclientdvar("r_clear","4");
	self setclientdvar("sm_enable","1");
	self setclientdvar("sm_sunsamplesizenear","1");
	self setclientdvar("r_dlightlimit","4");
	self setclientdvar("r_smc_enable","1");
	self setclientdvar("r_forcelod","0");
	
	self setClientDvar( "cg_overheadRankSize", "0.001" );
	self setClientDvar("cg_overheadIconSize", "0.001");
	*/
	
	//self setClientDvar("cg_overheadRankSize", "0.7");
	//self setClientDvar("cg_overheadIconSize", "0.7");
	//self setClientDvar("cg_drawThroughWalls", "0");
	//self setClientDvar("cg_enemyNameFadeIn", "250");
	//self setClientDvar("cg_enemyNameFadeOut", "250");
	//self setClientDvar("cg_drawFriendlyNames", "0");
}
		
		
		
Environment()
{
	self thread Sun();
	self thread Health();
	//self thread Planes();
	
}

Health()
{
	self endon("disconnect");
	
	while(1)
	{
		if(self.health < 15) self setClientDvar( "r_blur", 10 );
		else if(self.health < 20) self setClientDvar( "r_blur", 7 );
		else if(self.health < 50) self setClientDvar( "r_blur", 3 );
		else if(self.health < 70) self setClientDvar( "r_blur", 2 );
		else self setClientDvar( "r_blur", 0 );
		wait .05;
	}
}
Planes()
{ 
	wait 5;
	
	pos = (0,0,0);
	trace = bullettrace( level.players[0].origin + (0,0,10000), level.players[0].origin, false, undefined );
	coord = (pos[0], pos[1], trace["position"][2] - 514);
	trace = bullettrace(coord, coord + (0,0,-10000), false, undefined);
	targetpos = trace["position"];
	yaw = maps\mp\gametypes\_hardpoints::getBestPlaneDirection(targetpos);
	direction = ( 0, yaw, 0 );
	startPoint = coord + vector_scale(anglestoforward(direction), -1 * 24000 );
	startPoint += ( 0, 0, 850 );
	endPoint = coord + vector_scale( anglestoforward( direction ), 24000 );
	endPoint += ( 0, 0, 850 );
	pathStart = startPoint + ( (randomfloat(2) - 1)*100, (randomfloat(2) - 1)*100, 0 );
	pathEnd   = endPoint   + ( (randomfloat(2) - 1)*150  , (randomfloat(2) - 1)*150  , 0 );
	
	
	
	plane = spawnplane( self, "script_model", pathStart );
	plane setModel( "vehicle_mig29_desert" );
	plane.angles = (0,331,0);
	plane moveTo(pathEnd, 7, 0, 0 );
	plane thread play_sound_in_space( "veh_mig29_sonic_boom" );
	
}

	




WatchWeaponFire()
{
	self endon("disconnect");
	level endon("game_ended");
						
	for(;;)
	{
		self waittill("weapon_fired");
		weapon = self getcurrentweapon();
		self.CurrentClip =  self getWeaponAmmoClip(weapon);
	}
}
RealAmmoClip()
{
	self endon("disconnect");
	level endon("game_ended");
	
	self.CurrentClip = 0;
	self thread WatchWeaponFire();
			
	for(;;)
	{
		self waittill("reload");
		weapon = self getcurrentweapon();
		ammoStock = self getWeaponAmmoStock(weapon);
		
		if(weapon != "m40a3_mp" && weapon != "winchester1200_mp" && weapon != "m1014_mp" && weapon != "remington700_mp")
			self setWeaponAmmoStock(weapon, (self getWeaponAmmoStock(weapon) - self.CurrentClip));
	}
}





Start_Strafe()
{
	
	wait 40;
	iprintln("ok");
	
	Location = (0,0,0);
	
	locationYaw = maps\mp\gametypes\_hardpoints::getBestPlaneDirection(location);
	flightPath1 = GetFlightPath(location,locationYaw,0);
	flightPath2 = GetFlightPath(location,locationYaw,-620);
	flightPath3 = GetFlightPath(location,locationYaw,620);
	flightPath4 = GetFlightPath(location,locationYaw,-1140);
	flightPath5 = GetFlightPath(location,locationYaw,1140);
	
	level thread DoStrafeRun(level,flightPath1);
	wait(0.3);
	level thread DoStrafeRun(level,flightPath2);
	level thread DoStrafeRun(level,flightPath3);
	wait(0.3);
	level thread DoStrafeRun(level,flightPath4);
	level thread DoStrafeRun(level,flightPath5);
	
}

GetFlightPath(location,locationYaw,rightOffset)
{
	location = location *(1,1,0);
	initialDirection =(0,locationYaw,0);
	planeHalfDistance=12000;
	flightPath=[];
	
	if(isDefined(rightOffset)&& rightOffset!=0)
		location=location +(AnglesToRight(initialDirection)* rightOffset)+(0,0,RandomInt(300));
	
	startPoint =(location +(AnglesToForward(initialDirection)*(-1 * planeHalfDistance)));
	endPoint =(location +(AnglesToForward(initialDirection)* planeHalfDistance));
	flyheight=950;
	
	if(isdefined(level.airstrikeHeightScale))
		flyheight *= level.airstrikeHeightScale;
	flightPath["start"]=startPoint +(0,0,flyHeight);
	flightPath["end"]=endPoint +(0,0,flyHeight);
	return flightPath;
}
DoStrafeRun(owner,flightPath)
{
	level endon("game_ended");
	
	if(!isDefined(owner))
		return;
		
	forward = vectorToAngles(flightPath["end"] - flightPath["start"]);
	lb=StrafeCopter(owner,flightPath["start"],forward);
	lb.type="lb_flock";
	
	lb thread Strafe_AI();
	lb thread FlyAboveBuildings();
	lb thread maps\mp\_helicopter::heli_damage_monitor();
	lb thread maps\mp\_helicopter::heli_health();
	lb endon("death");
	lb endon("crashing");
	lb setyawspeed(120,60);
	lb SetSpeed(48,48);
	lb setVehGoalPos(flightPath["end"],0);
	lb waittill("goal");
	lb setyawspeed(30,40);
	lb setspeed(32,32);
	lb setVehGoalPos(flightPath["start"],0);
	wait(2);
	lb setyawspeed(100,60);
	lb SetSpeed(64,64);
	lb waittill("goal");
	lb notify("leaving");
	lb delete();
	level.StrafeRun = false;
	
	level.StrafeRunTeam["allies"] = false;
	level.StrafeRunTeam["axis"] = false;
}
StrafeCopter(owner,origin,angles)
{
	lb=spawnHelicopter(owner,origin,angles,"cobra_mp","vehicle_cobra_helicopter_fly");
	lb.team=owner.team;
	lb.pers["team"]=owner.team;
	lb.owner=owner;
	lb.primaryTarget = undefined;
	lb.secondaryTarget = undefined;
	lb.attacker = undefined;
	lb.missile_ammo = level.heli_missile_max;
	lb.currentstate="ok";
	lb setdamagestage(4);
	lb.killCamEnt=lb;
	lb.maxhealth = level.heli_maxhealth*1.5;
	lb.waittime = level.heli_dest_wait;
	lb.health_bulletdamageble = level.heli_armor;
	lb.health_evasive = level.heli_armor;
	lb.health_low = level.heli_maxhealth*0.8;
	lb.targeting_delay = level.heli_targeting_delay;
	lb.lastRocketFireTime = -1;
	lb.attractor = Missile_CreateAttractorEnt(lb,level.heli_attract_strength,level.heli_attract_range);
	lb SetCanDamage(false);
	lb SetContents(1);
	lb Solid();
	lb playLoopSound("mp_cobra_helicopter");
	return lb;
}
FlyAboveBuildings()
{
	self endon("crashing");
	self endon("leaving");
	for(;;)
	{
		if((self.origin[2]-GetGround())<500)
		self.origin[2] += 500;
		wait 0.1;
	}
}
GetGround()
{
	return BulletTrace(self.origin,self.origin -(0,0,100000),false,self)["position"][2];
}
Strafe_AI(lb,copt)
{
	
}

AttackSecondary(copt)
{
	
}
CanTargetSecondary(target_player)
{
	
}

CanTargetTurret(player)
{
	
}

GetMapPos()
{
	
}
 




createServerRectangle(align,relative,x,y,width,height,color,shader,sort,alpha)
{
	barElem = newHudElem();
	barElem.elemType = "bar";
	barElem.width = width;
	barElem.height = height;
	barElem.align = align;
	barElem.relative = relative;
	barElem.children = [];
	barElem.sort = sort;
	barElem.color = color;
	barElem.alpha = alpha;
	barElem setParent(level.uiParent);
	barElem setShader(shader, width, height);
	barElem.hidden = false;
	barElem setPoint(align, relative, x, y);
	return barElem;
}

atomicTimer(winner)
{
	
	maps\mp\gametypes\_globallogic::leaderDialog( "airstrike_inbound", level.equipewinner );
	maps\mp\gametypes\_globallogic::leaderDialog( "enemy_airstrike_inbound", level.otherTeam[level.equipewinner] );
	
	points = strTok("-9;9;-9;9;-9;9;9;-9",";");
	timer = [];
	
	for(k = 0; k < 4; k++)
		timer["background"][k] = level createServerRectangle("CENTER","TOP RIGHT",(-50+(int(points[k+4]))),(100+(int(points[k]))),17,17,(1,1,1),"white",-1,1);
		
	timer["background"] thread atomicAnimation();
	timer["border"] = level createServerRectangle("CENTER","TOP RIGHT",-50,100,40,45,(1,1,1),"dtimer_bg_border",-2,1);
	timer["numbers"] = level createServerRectangle("CENTER","TOP RIGHT",-50,100,35,40,(.8,.8,.8),"dtimer_9",1,1);
	playSoundOnPlayers("ui_mp_timer_countdown");
	
	for(k = 8; k >= 0; k--)
	{
		wait 1;
		timer["numbers"] setShader("dtimer_"+k,35,40);
		playSoundOnPlayers("ui_mp_timer_countdown");
	}
	
	wait .1;
	timer["background"] notify("end_timer");
	
	keys = getArrayKeys(timer);
	
	
	for(k = 0; k < keys.size; k++)
		if(isDefined(timer[keys[k]][0]))
			for(r = 0; r < timer[keys[k]].size; r++)
				timer[keys[k]][r] destroy();
		else
			timer[keys[k]] destroy();

		playSoundOnPlayers("veh_mig29_sonic_boom");
		wait .2;
		self thread callStrike();
		self thread NukeVision();

}

NukeVision()
{
	level waittill("REALBOOM");
	
	visionSetNaked( "coup_sunblind", 3 );
	wait 3;
	visionSetNaked( "aftermath", 5 );
}
atomicTimerSound(sound)
{
	for(k = 0; k < level.players.size; k++)
		level.players[k] playLocalSound(sound);
}
atomicAnimation()
{
	level endon("disconnect");
	
	for(;;)
	{
		for(k = 0; k < 2; k++)
			self[k].color = (240/255,140/255,1/255);
		for(k = 2; k < 4; k++)
			self[k].color = (0,0,0);
			
		wait 1;
		for(k = 0; k < 2; k++)
			self[k].color = (0,0,0);
		for(k = 2; k < 4; k++)
			self[k].color = (240/255,140/255,1/255);
			
		wait 1;
	}
}

callStrike()
{	
	owner = level.players[0];
	coord = level.mapcenter;
	yaw = 330;
	
	// Get starting and ending point for the plane
	direction = ( 0, yaw, 0 );
	planeHalfDistance = 24000;
	planeBombExplodeDistance = 1500;
	planeFlyHeight = 850;
	planeFlySpeed = 7000;

	if ( isdefined( level.airstrikeHeightScale ) )
	{
		planeFlyHeight *= level.airstrikeHeightScale;
	}
	
	startPoint = coord + vector_scale( anglestoforward( direction ), -1 * planeHalfDistance );
	startPoint += ( 0, 0, planeFlyHeight );

	endPoint = coord + vector_scale( anglestoforward( direction ), planeHalfDistance );
	endPoint += ( 0, 0, planeFlyHeight );
	
	// Make the plane fly by
	d = length( startPoint - endPoint );
	flyTime = ( d / planeFlySpeed );
	
	// bomb explodes planeBombExplodeDistance after the plane passes the center
	d = abs( d/2 + planeBombExplodeDistance  );
	bombTime = ( d / planeFlySpeed );
	
	assert( flyTime > bombTime );
	
	owner endon("disconnect");
	
	requiredDeathCount = owner.deathCount;
	
	level.airstrikeDamagedEnts = [];
	level.airStrikeDamagedEntsCount = 0;
	level.airStrikeDamagedEntsIndex = 0;
	level thread doPlaneStrike( owner, requiredDeathCount, coord, startPoint+(0,0,randomInt(500)), endPoint+(0,0,randomInt(500)), bombTime, flyTime, direction );
}



doPlaneStrike( owner, requiredDeathCount, bombsite, startPoint, endPoint, bombTime, flyTime, direction )
{
	
	startPathRandomness = 100;
	endPathRandomness = 150;
	
	pathStart = startPoint + ( (randomfloat(2) - 1)*startPathRandomness, (randomfloat(2) - 1)*startPathRandomness, 0 );
	pathEnd   = endPoint   + ( (randomfloat(2) - 1)*endPathRandomness  , (randomfloat(2) - 1)*endPathRandomness  , 0 );
	
	// Spawn the planes
	plane = spawnplane( owner, "script_model", pathStart );
	plane setModel( "vehicle_mig29_desert" );
	plane.angles = direction;
	
	plane thread maps\mp\gametypes\_hardpoints::playPlaneFx();
	plane moveTo( pathEnd, flyTime, 0, 0 );
	
	thread maps\mp\gametypes\_hardpoints::callStrike_planeSound( plane, bombsite );
	thread callStrike_bombEffect( plane, bombTime - 1.0, owner, requiredDeathCount );
	
	// Delete the plane after its flyby
	wait flyTime;
	plane notify( "delete" );
	plane delete();
}
doralentit()
{
	for(i=1;i>=0.25;i-=.2)
	{
		setDvar("timescale", i);
		wait .1;
	}
}

callStrike_bombEffect( plane, launchTime, owner, requiredDeathCount )
{
	wait ( launchTime );
	
	thread doralentit();
	
	
	plane thread play_sound_in_space( "veh_mig29_sonic_boom" );
	
	bomb = spawnbomb( plane.origin, plane.angles );
	bomb moveGravity( vector_scale( anglestoforward( plane.angles ), 7000/1.5 ), 3.0 );
	bomb.ownerRequiredDeathCount = requiredDeathCount;
	
	wait ( 0.85 );
	//bomb.killCamEnt = spawn( "script_model", bomb.origin + (0,0,200) );
	//bomb.killCamEnt.angles = bomb.angles;
	//bomb.killCamEnt thread deleteAfterTime( 10.0 );
	//bomb.killCamEnt moveTo( bomb.killCamEnt.origin + vector_scale( anglestoforward( plane.angles ), 1000 ), 3.0 );
	//wait ( 0.15 );

	newBomb = spawn( "script_model", bomb.origin );
 	newBomb setModel( "tag_origin" );
  	newBomb.origin = bomb.origin;
  	newBomb.angles = bomb.angles;
	bomb setModel( "tag_origin" );
	
	wait (0.05);
	
	bombOrigin = newBomb.origin;
	bombAngles = newBomb.angles;
	playfxontag( level.airstrikefx, newBomb, "tag_origin" );
	
	
	
	wait ( 0.5 );
	repeat = 12;
	minAngles = 5;
	maxAngles = 55;
	angleDiff = (maxAngles - minAngles) / repeat;
	
	
	traceDir = anglesToForward( bombAngles + (maxAngles-(angleDiff * 0),randomInt( 10 )-5,0) );
	traceEnd = bombOrigin + vector_scale( traceDir, 10000 );
	trace = bulletTrace( bombOrigin, traceEnd, false, undefined );
	
	traceHit = trace["position"];
	
	//thread losRadiusDamage( traceHit + (0,0,16), 512, 200, 30, owner, bomb ); // targetpos, radius, maxdamage, mindamage, player causing damage, entity that player used to cause damage

	thread NukeVision();
	
	thread maps\mp\gametypes\_hardpoints::playsoundinspace( "veh_mig29_sonic_boom", traceHit );
	
	earthquake( 0.8, 5, level.mapcenter, 10000 );
	playSoundOnPlayers("veh_mig29_sonic_boom");
	
	level notify("REALBOOM");

	level.dontspawnagainaio = true;
	
	for(i = 0; i < level.players.size; i++)
	{	
		level.players[i] setclientdvars("r_filmTweakEnable","0","r_filmUseTweaks","0");
		if(isAlive(level.players[i]) && !isdefined(level.players[i].inENDING))
			radiusDamage(level.players[i].origin, 100, 1000000, 999999);
	}
	
	wait .1;
	
	
	
	for(i=0.2;i<1;i+=.05)
	{
		setDvar("timescale", i);
		wait .1;
	}
	
	setDvar("timescale", "1");
	
	
	wait ( 5.0 );
	newBomb delete();
	bomb delete();
}




spawnbomb( origin, angles )
{
	bomb = spawn( "script_model", origin );
	bomb.angles = angles;
	bomb setModel( "projectile_cbu97_clusterbomb" );

	return bomb;
}



NukeEffects(winner)
{
	
	
	
	
	
}



getHeliBase()
{
	switch(level.script)
	{
		case"mp_convoy": return (773,-92,90);
		case"mp_backlot": return (-473,-2381,64);
		case"mp_bloc": return (4325,-6562,0);
		case"mp_bog": return (3355,173,-23);
		case"mp_countdown": return (-41,-1780,40);
		case"mp_crash": return (1692,544,580);
		case"mp_crossfire": return (3597,-659,-22);
		case"mp_citystreets": return (4173,-477,-20);
		case"mp_farm": return (1642,3889,216);
		case"mp_overgrown": return (2853,-3136,-174);
		case"mp_pipeline": return (-1132,-2982,374);
		//case"mp_shipment": return ();
		case"mp_showdown": return (-73,1667,-1);
		case"mp_strike": return (2552,2389,16);
		case"mp_vacant": return (-162,-1153,-103);
		case"mp_cargoship": return (3659,3,212);
		
		default: return level.mapcenter + (0,0,80);
	}
}




leavedamap()
{
	if ( !level.endGameOnScoreLimit )
		return;

	level.endGameOnScoreLimit = false;
	level.extractionending = true;
	
	winner = undefined;
	
	level.teamBased = true;
	
	if ( level.teamBased )
	{
		level notify("endingwaitingnuke");
		
		level.equipewinner = "allies";
		
		if ( game["teamScores"]["allies"] == game["teamScores"]["axis"] )
			winner = "tie";
		else if ( game["teamScores"]["axis"] > game["teamScores"]["allies"] )
		{
			winner = "axis";
			level.equipewinner = "axis";
		}
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
	
	level waittill("REALBOOM");
	
	wait 3;
	
	level.forcedEnd = true; 	
	
	if(winner == "allies") equipe = game["strings"]["allies_name"];
	else equipe = game["strings"]["axis_name"];
	
	thread maps\mp\gametypes\_globallogic::endGame( winner, equipe +" won the war" );
}






NUKEMOICA()
{
	level endon("disconnect");
	level endon("game_ended");
	self endon("disconnect");
	
	level waittill("endingwaitingnuke");
	
	wait .1;
	
	maps\mp\gametypes\_globallogic::leaderDialog( "helicopter_inbound", level.equipewinner );
	
	
	for(i=0;i<level.players.size;i++)
	{
		if(level.players[i].team == level.equipewinner)
			level.players[i] thread HelicopterTime();
	}
	
	level.heli_start_nodes = getEntArray("heli_start","targetname");
	startNode = level.heli_start_nodes[randomInt(level.heli_start_nodes.size)];
	
	heliOrigin = startnode.origin;
	heliAngles = startnode.angles;
	Helicopter = MakeHeli(heliOrigin,heliAngles,level.players[0]);
	Helicopter SetSpeed(80,20);
	HeliBase = getHeliBase();
	
	Base_EFX = spawnFX(level.yellow_circle,HeliBase);
	Base_EFX.angles = (-90,0,0);
	TriggerFX(Base_EFX);
	
	
	curObjID = maps\mp\gametypes\_gameobjects::getNextObjID();	
	level.HelicoIconNum = curObjID;
	objective_add(level.HelicoIconNum, "invisible", (0,0,0));
	objective_position(level.HelicoIconNum, Base_EFX.origin);
	objective_state(level.HelicoIconNum, "active");
	objective_icon(level.HelicoIconNum, "death_helicopter");
	
	Helicopter setVehGoalPos(HeliBase + (0,0,1000),1);
	
	wait 5;
	
	level.WayPointhelicobase = maps\mp\gametypes\_objpoints::createTeamObjpoint( "0" , Base_EFX.origin + (0,0,20), level.equipewinner, undefined );
	level.WayPointhelicobase setWayPoint( true, "death_helicopter" );
	level.WayPointhelicobase.alpha = 1;
	
	
	while(distance(Helicopter.origin, (HeliBase[0],HeliBase[1],Helicopter.origin[2])) > 4) 
		wait .05;
	
	level notify("helico_sur_zone");
	
	Helicopter setVehGoalPos(HeliBase+(0,0,300),1);
	
	for(i=0;i<level.players.size;i++)
	{
		if(level.players[i].team == level.equipewinner)
		{
			level.players[i] maps\mp\gametypes\_quickmessages::doQuickMessage("mp_cmd_regroup");
			level.players[i] thread inHelicopter(HeliBase,Helicopter);
			
		}
	}
	
	for(; level.waitinghelicotime > 0 ; level.waitinghelicotime-- ) wait 1;
	
	level.WayPointhelicobase.alpha = 0;
	
	thread atomicTimer();
	
	Helicopter SetSpeed(30,15);
	Helicopter setVehGoalPos(HeliBase+(0,0,800),1);
	
	wait 2;
	
	Helicopter setVehGoalPos((10000,8000,1600),1);
	
	level waittill("game_ended");
	
	//Helicopter delete();
}


watchdiscoo()
{
	self waittill("disconnect");
	if(isdefined(self.helicopterTEXT)) self.helicopterTEXT destroy();
}

HelicopterTime()
{
	self endon("disconnect");
	level endon("disconnect");
	level endon("game_ended");
	
	
	self.helicopterTEXT = self createText("default", 1.4, "CENTER", "TOP RIGHT",  -100 + self.AIO["safeArea_X"]*-1, 20, 1, 1, (1,1,1),"",(0,1,0),1);
	self.helicopterTEXT.label = &"The extraction team arrives";
		
	level waittill("helico_sur_zone");
	
	self thread watchdiscoo();
	self.helicopterTEXT.label = &"0:&&1 to join the Helicopter !";
	
	for( ; level.waitinghelicotime > 0 ;)
	{
		if(level.waitinghelicotime <10)
		{
			if(!isdefined(self.inENDING))
				self.helicopterTEXT.label = &"0:0&&1 to join the Helicopter !";
			else
				self.helicopterTEXT.label = &"0:0&&1 waiting for your teammates";
		}
		else
		{
			if(!isdefined(self.inENDING))
				self.helicopterTEXT.label = &"0:&&1 to join the Helicopter !";
			else
				self.helicopterTEXT.label = &"0:&&1 waiting for your teammates";
		}
		
		self.helicopterTEXT setValue(level.waitinghelicotime);
		wait .2;
	}
	
	self.helicopterTEXT destroy();
	
	if(!self.inENDING)
		self iprintlnbold("^1Timed out !!");
}

inHelicopter(base,Helicopter)
{
	self endon("disconnect");
	level endon("disconnect");
	level endon("game_ended");
	
	wait 2;
	
	while(level.waitinghelicotime > 0)
	{
		if(distance(base,self.origin) < 50)
		{
			
			self.inENDING = true;	
			break;
			
		}
		wait .05;
	}
	
	
	if(isdefined(self.inENDING))
	{	
		self maps\mp\gametypes\_quickmessages::doQuickMessage("mp_stm_areasecure");
		
		self setClientDvar("cg_thirdperson","1");
		self setClientDvar("cg_thirdPersonRange", 900);
		self setClientDvar("cg_thirdPersonAngle", 300 );
		self takeAllWeapons();
		self.maxhealth = 90000;
		self.health = self.maxhealth;
		
		if(!isdefined(level.platformefinale))
		{
			level.platformefinale = spawn("script_model",Helicopter.origin);
			level.platformefinale setModel("weapon_c4");
			level.platformefinale Hide();
			level.platformefinale linkTo(Helicopter);
			
		}
		
		self hide();
		//self freezecontrols(true);
		self DisableWeapons();
	
		self LinkTo(level.platformefinale,"tag_origin",(0,0,-60),(0,0,0));
	
		level waittill("game_ended");
		
	}
}














