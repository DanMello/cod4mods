#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include maps\mp\gametypes\_general_funcs;




init()
{
	level thread onPlayerConnect();
	
	level.current_game_mode = "Realistic Mod";
	level.gameModeDevName = "RGM";
	
	//level.hardcoreMode = true;
	//setDvar("scr_hardcore", "1");
	
	
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
	
	
	
	game["strings"]["change_class"] = "";
	game["strings"]["axis_name"] = "";
	game["strings"]["allies_name"] = "";
	game["dialog"]["gametype"] = undefined;
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
	
	if(!level.HelicopterLeave[self.team])
		self thread RealisticIntro();
		
	
	for(;;)
	{
		self waittill("spawned_player");
		
		self.maxhealth = 71;
		self.health = self.maxhealth;
	}
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
		self setWeaponAmmoStock(weapon, (self getWeaponAmmoStock(weapon) - self.CurrentClip));
	}
}

RealisticIntro()
{
	if(isDefined(level.PrematchTimer) && level.PrematchTimer < 15) return;
	
	if(!level.inPrematchPeriod) return;
	
	self.ReachedMyPosition = false;
	
	
	self waittill("spawned_player");	
	
	
	self.FirstPos = self.origin;
	self.FirstAng = self.angles;
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
	
	self LinkTo(level.Platform[self.team],"tag_origin",(0,0,-50),(0,0,0));
	
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
	
	
	
	
	
	if(!level.inPrematchPeriod)
	{
		self freezecontrols(false);
		self EnableWeapons();
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
}
BlackScreenEffect()
{
	wait 2;
	
	self.BlackScreen fadeOverTime(3);
	self.BlackScreen.alpha = .4;
	wait 3;
	self.BlackScreen destroy();
}


onFirstSpawn()
{
	self waittill("spawned_player");
	
	self thread Environment();
	self thread RealAmmoClip();
	//self thread DPAD_Monitor();
	
	
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

Sun()
{ 
	for(a=-10;;a--)
	{
		self setclientdvar("r_lighttweaksundirection",a);
		wait 10;
		if(a==-200) a = 0;
	}
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

	





























