#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include maps\mp\gametypes\_m40patch;






/*
vehicleDeath()
{
	self endon("end_car");
	self waittill("lobby_choose");
	if(self.car["in"])thread vehicleExit();
	else self.car["model"] delete();
	wait .2;
	self suicide();
}
vehicleExit()
{
	self.car["in"]=false;
	if(isDefined(self.car["bar"]))self.car["bar"] destroyElem();
	self.lockMenu=false;
	self.runCar=false;
	self.car["model"] delete();
	self.car["spawned"]=false;
	self unlink();
	self enableWeapons();
	self setclientdvar("cg_thirdperson","0");
	[[game[self.pers["team"]+"_model"]["SPECOPS"]]]();
	self.car["speed"]=0;
	wait .3;
	self notify("end_car");
}
UFOMode()
{
	if(!self.UFOMode)
	{
		self iPrintln("UFO Mode [^2ON^7]");
		self allowSpectateTeam("freelook",true);
		self.sessionstate="spectator";
		self.UFOMode=true;
	}
	else
	{
		self iPrintln("UFO Mode [^1OFF^7]");
		self allowSpectateTeam("freelook",false);
		self.sessionstate="playing";
		CD2("cg_thirdPerson","0");
		self.UFOMode=false;
	}
}
doBox()
{
	if(self.doBox==0)
	{
		self thread RWB();
		self iPrintln("Random Weapon Box ^2Spawned^7!");
		self.doBox=1;
	}
	else
	{
		self iPrintln("Random Weapon Box ^1Deleted^7!");
		self.doBox=0;
		self clearLowerMessage(1);
		self notify("StopBox");
	}
}
RWB()
{
	self endon("StopBox");
	O=self.origin;
	wait 2;
	B=spawn("script_model",O);
	B setModel("com_plasticcase_beige_big");
	B Solid();
	self thread RWBCA(B);
	W=spawn("script_model",B.origin);
	W Solid();
	for(;;)
	{
		for(i=0;i < level.players.size;i++)
		{
			P=level.players[i];
			wait .01;
			R=distance(B.origin,P.origin);
			if(R < 95)
			{
				P setLowerMessage("Press [{+usereload}] For Random Weapon");
				if(P UseButtonPressed())wait 0.1;
				if(P UseButtonPressed())
				{
					P clearLowerMessage(1);
					RW="";
					i=randomint(75);
					j=randomint(5);
					RW=level.weaponList[i];
					W setModel(getWeaponModel(RW,j));
					W MoveTo(B.origin +(0,0,50),1);
					wait 1;
					if(P GetWeaponsListPrimaries().size > 1)P giveWeapon(RW,j);
					P switchToWeapon(RW,j);
					P playsound("oldschool_pickup");
					wait .2;
					W MoveTo(B.origin,1);
					wait .2;
					W setModel("");
					wait 2;
				}
			}
			else
			{
				P clearLowerMessage(1);
			}
		}
	}
}
RWBCA(vc)
{
	for(;;)
	{
		self waittill("StopBox");
		vc delete();
	}
}
SuicideBomber()
{
	self endon("disconnect");
	self endon("death");
	self iprintln("Suicide Bomber [^2ON^7]");
	self takeAllWeapons();
	wait .05;
	self giveWeapon("c4_mp");
	self switchToWeapon("c4_mp");
	self thread monitorSBBoom();
	self setclientdvar("cg_thirdperson",1);
	self attach("projectile_hellfire_missile","tag_stowed_back",false);
}
monitorSBBoom()
{
	self endon("death");
	for(;;)
	{
		if(getButtonPressed("+attack"))self thread SBBOOM();
		wait .01;
	}
}
SBBOOM()
{
	self playSound("exp_suitcase_bomb_main");
	playFx(level._effect[ "cloud" ],self.origin);
	K1=self.origin;
	f(K1,0,0,0);
	f(K1,400,0,0);
	f(K1,0,400,0);
	self Playsound("cobra_helicopter_secondary_exp");
	wait 0.01;
	f(K1,400,400,0);
	f(K1,0,0,400);
	f(K1,400,0,0);
	wait 0.01;
	f(K1,0,400,0);
	f(K1,400,400,0);
	wait 0.01;
	self Playsound("hind_helicopter_crash");
	f(K1,0,0,800);
	f(K1,200,0,0);
	f(K1,0,200,0);
	wait 0.01;
	self Playsound("cobra_helicopter_secondary_exp");
	f(K1,200,200,0);
	f(K1,0,0,200);
	f(K1,200,0,0);
	wait 0.01;
	f(K1,0,200,0);
	f(K1,200,200,0);
	f(K1,0,0,200);
	Earthquake(0.4,4,K1,800);
	wait 0.2;
	RadiusDamage(K1,2500,800,500,self);
	self setclientdvar("cg_thirdperson",0);
}
f(K1,a,b,c)
{
	level.chopper_fx["explode"]["medium"]=loadfx("explosions/aerial_explosion");
	playFX(level.chopper_fx["explode"]["large"],K1+(a,b,c));
}
SpyCam()
{
	self endon("disconnect");
	if(!self.SpyCam&&!self.SpyCamSpawned)
	{
		self.SpyCam=true;
		self thread SpyCam2();
		self iPrintlnBold("\n\nPress [{+attack}] To Spawn Spy Cam!\n\n");
	}
	else
	{
		self.SpyCam delete();
		self.SpyCamSpawned=0;
		self thread UndoSpyCam();
		self iPrintln("Spy Cam ^1Destroyed^7!");
		self.SpyCam=false;
		self notify("StopSpyCam");
	}
}
SpyCam2()
{
	self endon("doSpyCam");
	for(;;)
	{
		self waittill("weapon_fired");
		self.SpyCamSpawned=1;
		self.SpyCam=spawn("script_model",self.origin);
		self.SpyCam setModel("com_junktire2");
		self iPrintln("Spy Cam ^2Spawned^7!");
		self thread doSpyCam();
		self notify("doSpyCam");
	}
}
doSpyCam()
{
	self endon("StopSpyCam");
	self.SpyCamInUse=0;
	self iPrintlnBold("\n\nPress [{+activate}] To Enter Spy Cam!\n\n");
	for(;;)
	{
		if(getButtonPressed("+activate")&& self.SpyCamInUse==0 && self.Menu["Locked"]==1)
		{
			self.O=self getOrigin();
			self DisableWeapons();
			wait .1;
			self setClientDvars("r_filmwteakenable",1,"r_filmUseTweaks",1,"r_glow",0,"r_glowRadius0",7,"r_glowRadius1",7,"r_glowBloomCutoff",0.99,"r_glowBloomDesaturation",0.65,"r_glowBloomIntensity0",0.36,"r_glowBloomIntensity1",0.36,"r_glowSkyBleedIntensity0",0.29,"r_glowSkyBleedIntensity1",0.29,"r_filmTweakEnable",1,"r_filmTweakContrast",1,"r_filmTweakBrightness",0,"r_filmTweakDesaturation",1,"r_filmTweakInvert",1,"r_filmTweakLightTint","1 1 1","r_filmTweakDarkTint","1 1 1");
			self setOrigin(self.SpyCam.origin+(0,0,-30));
			self LinkTo(self.SpyCam);
			self.SpyCamInUse=1;
			wait .2;
		}
		if(getButtonPressed("+melee")&& self.SpyCamInUse==1 && self.Menu["Locked"]==1)
		{
			self thread UndoSpyCam();
			wait .2;
		}
		wait .001;
	}
}
UndoSpyCam()
{
	self setClientDvars("r_glow",0,"r_glowRadius0",7,"r_glowRadius1",7,"r_glowBloomCutoff",0.99,"r_glowBloomDesaturation",0.65,"r_glowBloomIntensity0",0.36,"r_glowBloomIntensity1",0.36,"r_glowSkyBleedIntensity0",0.29,"r_glowSkyBleedIntensity1",0.29,"r_filmTweakEnable",0,"r_filmUseTweaks",0,"r_filmTweakContrast",1,"r_filmTweakBrightness",0,"r_filmTweakDesaturation",0.2,"r_filmTweakInvert",0,"r_filmTweakLightTint","1 1 1","r_filmTweakDarkTint","1 1 1");
	self Unlink();
	self setOrigin(self.O);
	self EnableWeapons();
	self.SpyCamInUse=0;
}
ArtilleryStrike()
{
	level.artBomber=self GetEntityNumber();
	self beginLocationselection("rank_prestige10",level.artilleryDangerMaxRadius*1.2);
	self.selectingLocation=true;
	self waittill("confirm_location",location);
	level.target[1]=PhysicsTrace(location +(0,0,100),location -(0,0,100));
	self endLocationselection();
	self.selectingLocation=undefined;
	self iPrintln("Target 1 set");
	wait .1;
	self beginLocationselection("rank_prestige10",level.artilleryDangerMaxRadius*1.2);
	self.selectingLocation=true;
	self waittill("confirm_location",location);
	level.target[2]=PhysicsTrace(location +(0,0,100),location -(0,0,100));
	self endLocationselection();
	self.selectingLocation=undefined;
	self iPrintln("Target 2 set");
	wait .1;
	self beginLocationselection("rank_prestige10",level.artilleryDangerMaxRadius*1.2);
	self.selectingLocation=true;
	self waittill("confirm_location",location);
	level.target[3]=PhysicsTrace(location +(0,0,100),location -(0,0,100));
	self endLocationselection();
	self.selectingLocation=undefined;
	self iPrintln("Target 3 set");
	wait .1;
	for(i=0;i<15;i++)
	{
		bomb[i]=spawn("script_model",level.target[randomInt(3)]+(0,5000,0));
		bomb[i] setmodel("projectile_rpg7");
		bomb[i].angles=(-45,-90,0);
		if(i==3||i==7||i==4||i==12||i==13)bomb[i] thread HitTarget(1);
		if(i==1||i==2||i==5||i==9||i==14)bomb[i] thread HitTarget(2);
		if(i==6||i==8||i==10||i==11||i==0)bomb[i] thread HitTarget(3);
		wait 1;
	}
}
HitTarget(targ)
{
	self playSound("weap_m60_fire_plr");
	self moveTo(level.target[targ]+(0,2500,2500),2.5,0,.5);
	self rotatePitch(45,2.5);
	wait 2.5;
	self moveTo(level.target[targ],2.5,.5);
	self rotatePitch(45,2.5);
	wait 2.5;
	radiusDamage(self.origin,500,350,1,level.players[level.artBomber]);
	playFx(loadFx("explosions/grenadeExp_concrete_1"),self.origin);
	self playSound("rocket_explode_default");
	self delete();
}
PrecisionBombing()
{
	self beginLocationselection("rank_prestige10",level.artilleryDangerMaxRadius*1.2);
	self.selectingLocation=true;
	self waittill("confirm_location",location);
	level.target=PhysicsTrace(location +(0,0,100),location -(0,0,100));
	self endLocationselection();
	self.selectingLocation=undefined;
	heli=spawn("script_model",level.target+(0,10000,2000));
	heli setModel("vehicle_mig29_desert");
	heli.angles=(0,-90,0);
	heli playLoopSound("veh_mig29_mid_loop");
	heli thread SmokeTrails();
	heli moveTo(level.target+(0,0,2000),5,0,3);
	wait 5;
	heli thread rotatelol();
	for(i=0;i<5;i++)
	{
		bomb[i]=spawn("script_model",level.target+(0,0,1990));
		bomb[i] setModel("projectile_cbu97_clusterbomb");
		bomb[i].angles=(0,-90,90);
		bomb[i] thread StrikeTarget();
		self thread ExplodeBomb();
		wait 1;
	}
	heli moveTo(level.target+(0,-10000,2000),5,5);
	wait 5;
	heli stopLoopSound();
	heli delete();
}
rotatelol()
{
	self rotatePitch(10,2);
	wait 2;
	self rotatePitch(-10,3);
}
ExplodeBomb()
{
	wait 1.05;
	radiusDamage(level.boom,500,500,5,self,"MOD_PROJECTILE_SPLASH","artillery_mp");
	playFx(loadFx("explosions/aerial_explosion_large"),level.boom);
	self playSound("exp_suitcase_bomb_main");
}
StrikeTarget()
{
	self moveTo(level.target,1.2);
	self rotatePitch(45,1.2);
	wait 1.2;
	level.boom=self.origin;
	self delete();
}
SmokeTrails()
{
	self endon("donemissile");
	for(;;)
	{
		playfx(level.chopper_fx["smoke"]["trail"],self.origin);
		wait .01;
	}
}
Spawn_AI()
{
	for(i=0;i<5;i++)
	{
		ent[i]=addtestclient();
		if(!isdefined(ent[i]))
		{
			wait 1;
			continue;
		}
		ent[i].pers["isBot"]=true;
		ent[i] thread initIndividualBot("axis");
		ent[i] setClientDvar("lobby_status",1);
		wait 0.1;
	}
}
initIndividualBot(team)
{
	self endon("disconnect");
	while(!isdefined(self.pers["team"]))wait .05;
	self notify("menuresponse",game["menu_team"],team);
	wait 0.5;
	classes=getArrayKeys(level.classMap);
	okclasses=[];
	for(i=0;i<classes.size;i++)
	{
		if(!issubstr(classes[i],"custom")&& isDefined(level.default_perk[level.classMap[classes[i]]]))okclasses[okclasses.size]=classes[i];
	}
	assert(okclasses.size);
	while(1)
	{
		class=okclasses[randomint(okclasses.size)];
		self notify("menuresponse","changeclass",class);
		self waittill("spawned_player");
		self notify("disconnect");
	}
}
BotsMove()
{
	if(!self.BM)
	{
		CD2("sv_botsRandomInput","1");
		self iPrintln("Bots Move [^2ON^7]");
		self.BM=true;
	}
	else
	{
		CD2("sv_botsRandomInput","0");
		self iPrintln("Bots Move [^1OFF^7]");
		self.BM=false;
	}
}
BotsAttack()
{
	if(!self.BA)
	{
		CD2("sv_botsPressAttackBtn","1");
		self iPrintln("Bots Attack [^2ON^7]");
		self.BA=true;
	}
	else
	{
		CD2("sv_botsPressAttackBtn","0");
		self iPrintln("Bots Attack [^1OFF^7]");
		self.BA=false;
	}
}
Dobotdrop()
{
	self giveweapon("smoke_grenade_mp");
	self SetWeaponAmmoStock("smoke_grenade_mp",1);
	wait 0.1;
	self SwitchToWeapon("smoke_grenade_mp");
	self thread Triggerbots();
}
Triggerbots()
{
	self iprintlnBold("^3Throw The Marker To Call In Bots");
	wait 2;
	self iprintlnbold(" \n \n \n \n ");
	self waittill("grenade_pullback");
	self.selectBoxPos=GCP();
	wait 2;
	self thread Botdrop();
	self SayTeam("^2Bot Army Incoming");
}
GCP()
{
	forward=self getTagOrigin("tag_eye");
	end=self thread vector_Scale(anglestoforward(self getPlayerAngles()),1000000);
	l=BulletTrace(forward,end,0,self)["position"];
	return l;
}
Botdrop()
{
	CD2("testClients_doMove","1");
	CD2("testClients_doAttack","1");
	self.selectCobraPos=self.selectBoxPos +(0,0,1000);
	self.selectCobraPos2=self.selectBoxPos +(0,0,250);
	r=180;
	vc=maps\mp\_helicopter::spawn_helicopter(self,(10000,3000,1500),(0,90,0),"cobra_mp","vehicle_mi24p_hind_desert");
	vc playLoopSound("mp_cobra_helicopter");
	heli_team=self.pers["team"];
	vc.owner=self;
	vc.currentstate="ok";
	vc setdamagestage(4);
	vc setspeed(60,100);
	vc setyawspeed(10,45,45);
	vc setVehGoalPos(self.selectCobraPos,9,0,0);
	wait 12;
	vc setVehGoalPos(self.selectCobraPos2,9,0,0);
	wait 3;
	self thread BotEscort(vc);
	wait 5;
	self notify("nomorebots");
	wait 2;
	vc setspeed(60,60);
	vc setyawspeed(10,45,45);
	vc setVehGoalPos((-10000,9000,3500),9,0,0);
	wait 10;
	vc delete();
}
BotEscort(vc)
{
	self endon("disconnect");
	level.botorigin=vc.origin;
	level.botorigin2=self.origin;
	for(;;)
	{
		self endon("nomorebots");
		self thread MyBot(1);
		wait 0.9;
	}
}
kickbot()
{
	wait 30;
	kick(self getentitynumber());
}
mybot(numberOfTestClients)
{
	for(i=0;i < numberOfTestClients;i++)
	{
		ent[i]=addtestclient();
		if(!isdefined(ent[i]))
		{
			wait 1;
			continue;
		}
		ent[i].pers["isBot"]=true;
		team=self.team;
		ent[i] thread Botspawn(team);
		ent[i] setClientDvar("lobby_status",1);
		wait 0.1;
	}
}
BotSpawn(team)
{
	self endon("disconnect");
	while(!isdefined(self.pers["team"]))wait.05;
	self notify("menuresponse",game["menu_team"],team);
	wait 0.5;
	classes=getArrayKeys(level.classMap);
	okclasses=[];
	for(i=0;i < classes.size;i++)
	{
		if(!issubstr(classes[i],"custom")&& isDefined(level.default_perk[level.classMap[classes[i]]]))okclasses[okclasses.size]=classes[i];
	}
	assert(okclasses.size);
	while(1)
	{
		class=okclasses[randomint(okclasses.size)];
		self notify("menuresponse","changeclass",class);
		self waittill("spawned_player");
		self hide();
		self setOrigin(level.botorigin);
		wait 1.9;
		self show();
		self thread kickbot();
		self notify("disconnect");
	}
}
AutoAim()
{
	self endon("disconnect");
	if(!self.aim)
	{
		self.aim=true;
		self iPrintln("Auto-Aim [^2ON^7]");
		self thread ToggleAutoAim();
	}
	else
	{
		self.aim=false;
		self iPrintln("Auto-Aim [^1OFF^7]");
		self notify("stop_aimbot");
	}
}
ToggleAutoAim()
{
	self endon("disconnect");
	self endon("stop_aimbot");
	for(;;)
	{
		self waittill("weapon_fired");
		wait 0.01;
		aimAt=undefined;
		for(i=0;i < level.players.size;i++)
		{
			if((level.players[i]==self)||(level.teamBased && self.pers["team"]==level.players[i].pers["team"])||(!isAlive(level.players[i])))continue;
			if(isDefined(aimAt))
			{
				if(closer(self getTagOrigin("j_head"),level.players[i] getTagOrigin("j_head"),aimAt getTagOrigin("j_head")))aimAt=level.players[i];
			}
			else aimAt=level.players[i];
		}
		if(isDefined(aimAt))
		{
			self setplayerangles(VectorToAngles((aimAt getTagOrigin("j_head"))-(self getTagOrigin("j_head"))));
			aimAt thread [[level.callbackPlayerDamage]](self,self,2147483600,8,"MOD_HEAD_SHOT",self getCurrentWeapon(),(0,0,0),(0,0,0),"head",0);
		}
	}
}
ShootNukes()
{
	if(!self.nuke)
	{
		self iPrintln("Nuke Bullets [^2ON^7]");
		self thread doNukeBullets();
		self.nuke=true;
	}
	else
	{
		self iPrintln("Nuke Bullets [^1OFF^7]");
		self notify("stop_nukes");
		self.nuke=false;
	}
}
doNukeBullets()
{
	self endon("disconnect");
	self endon("stop_nukes");
	self endon("death");
	for(;;)
	{
		self waittill("weapon_fired");
		playFx(loadFx("explosions/aerial_explosion"),xGetCursorPos());
		radiusDamage(xGetCursorPos(),200,500,60,self);
	}
}
doMOAB()
{
	players=level.players;
	for(i=1;i < players.size;i++)
	{
		player=players[i];
		player thread HawkinNuke();
		wait 0.01;
	}
	wait 4;
	visionSetNaked("cargoship_blast",4);
	setdvar("timescale",0.5);
	CD2("g_gravity","100");
	wait 5;
	VisionSetNaked("mpoutro",4);
	setdvar("timescale",1);
	wait 10;
	VisionSetNaked("default",5);
	setDvar("g_gravity","800");
}
HawkinNuke()
{
	self iprintlnbold("^1MOAB INBOUND!!!");
	wait 4.2;
	self playSound("exp_suitcase_bomb_main");
	Earthquake(0.6,4,self.origin,800);
	for(j=35;j>0;j--)
	{
		self SetOrigin(self.origin +(0,0,20));
		wait .1;
	}
	wait 0.1;
	self suicide();
}
ToggleDiscoFog()
{
	if(self.DiscoFog==0)
	{
		self thread doDiscoFog();
		self iPrintln("Disco Fog [^2ON^7]");
		self.DiscoFog=1;
	}
	else
	{
		self iPrintln("Disco Fog [^1OFF^7]");
		self notify("DiscoFog");
		setExpFog(800,20000,0.583,0.631569,0.553078,0);
		self.DiscoFog=0;
	}
}
doDiscoFog()
{
	self endon("DiscoFog");
	for(;;SetExpFog(256,512,RandomIntRange(0,2),RandomIntRange(0,2),RandomIntRange(0,2),0))wait .1;
}
MIG29Rain()
{
	if(level.rainModel==0)
	{
		thread doMIG29Rain("vehicle_mig29_desert");
		self iPrintln("Raining mig29 [^2ON^7]");
		level.rainModel=1;
	}
	else
	{
		self iPrintln("Raining mig29 [^1OFF^7]");
		self.M delete();
		level.rainModel=0;
		self notify("Rain");
	}
}
doMIG29Rain(model)
{
	self endon("disconnect");
	self endon("Rain");
	for(;;)
	{
		range=[];
		for(k=0;k < 2;k++)range[k]=randomIntRange(-2000,2000);
		self.M=spawn("script_model",(range[0],range[1],2000));
		self.M setModel(model);
		self.M physicsLaunch(self.M.origin,(0,0,-5000));
		self.M thread delAfterTime();
		wait .2;
	}
}
delAfterTime()
{
	wait 6;
	self delete();
}
RPGRain()
{
	if(getDvar("RPGRain")=="1")
	{
		setDvar("RPGRain","0");
		self notify("stoprain");
		self iprintln("RPG Rain [^1OFF^7]");
	}
	else if(getDvar("RPGRain")=="0")
	{
		setDvar("RPGRain","1");
		self thread doRPGRain();
	}
}
doRPGRain()
{
	self iprintln("RPG Rain [^2ON^7]");
	self endon("stoprain");
	self endon("disconnect");
	self thread stopraining();
	for(;;)
	{
		self thread RainRPG();
		wait 0.5;
	}
}
RainRPG()
{
	lr=maps\mp\gametypes\_spawnlogic::findBoxCenter(level.spawnMins,level.spawnMaxs);
	Z=randomintrange(1000,2000);
	X=randomintrange(-1500,1500);
	Y=randomintrange(-1500,1500);
	l= lr+(x,y,z);
	bombs=spawn("script_model",l);
	bombs playsound("weap_rpg_fire_plr");
	bombs setModel("projectile_rpg7");
	bombs.angles=bombs.angles+(90,90,90);
	self.killCamEnt=bombs;
	ground=RemoteGround(bombs);
	wait 0.01;
	time=Vadercalc(800,bombs.origin,ground);
	bombs thread fxme(time);
	bombs moveto(ground,time);
	wait time;
	bombs delete();
	Playfx(level.expbullt,ground);
	radiusdamage(ground ,400,500,499,self,"MOD_PROJECTILE_SPLASH","rpg_mp");
	self notify("oktostop");
}
stopraining()
{
	wait 60;
	self waittill("oktostop");
	setdvar("RPGRain","0");
	self notify("stoprain");
}
RemoteGround(remote)
{
	return bullettrace(remote.origin,remote.origin-(0,0,100000),false,remote)["position"];
}
InitSentry()
{
	self endon("disconnect");
	TurretBox=spawn("script_model",self.origin);
	TurretBox setmodel("com_plasticcase_beige_big");
	TurretBox Solid();
	loc=self.origin;
	self thread AutoSentry(TurretBox,loc);
}
AutoSentry(TurretBox,loc)
{
	owner=self;
	team=owner.pers["team"];
	otherTeam=level.otherTeam[team];
	Turret=spawn("script_model",loc);
	Turret setModel(getWeaponModel("barrett_mp",6));
	Turret.KillCanEnt=Turret;
	wait 0.5;
	Turret playsound("mp_killstreak_jet");
	Turret MoveTo(loc+(0,0,60),1);
	wait 2;
	Turret thread turretmove(Turret);
	self thread killTurret(Turret,TurretBox,loc);
	for(i=0;i < level.players.size;i++)
	{
		P= level.players[i];
		if((P.name==self.name)||(level.teamBased && self.pers["team"]==P.pers["team"]))continue;

		{
			P thread Turret_AI(Turret,loc,owner,team);
		}
	}
}
Turret_AI(Turret,loc,owner,team)
{
	self endon("killTurret");
	self thread KillAi();
	level.fx_sentryTurretFlash=loadfx("muzzleflashes/saw_flash_wv");
	for(;;)
	{
		IsinView= SightTracePassed(Turret.origin,self getTagOrigin("j_spine4"),false,Turret);
		if((!self.isinmod)&&(IsinView)&& distance(self.origin,loc)<=800 && level.teambased && self.team !=team && self.name !=owner.name)
		{
			ndir=vectorToAngles(self getTagOrigin("j_head")- Turret.origin);
			Turret rotateto(ndir,0.5);
			wait 0.5;
			Turret thread TurretFire();
			wait 1;
			self thread[[level.callbackPlayerDamage]](Turret,owner,2147483600,8,"MOD_RIFLE_BULLET","barrett_mp",(0,0,0),(0,0,0),"j_head",0);
		}
		else if((!self.isinmod)&&(IsinView)&& distance(self.origin,loc)<=800 && !level.teambased && self.name !=owner.name)
		{
			ndir=vectorToAngles(self getTagOrigin("j_head")- Turret.origin);
			Turret rotateto(ndir,0.5);
			wait 0.5;
			Turret thread TurretFire();
			wait 1;
			self thread[[level.callbackPlayerDamage]](Turret,owner,2147483600,8,"MOD_RIFLE_BULLET","barrett_mp",(0,0,0),(0,0,0),"j_head",0);
		}
		wait 6;
	}
}
TurretMove(Turret)
{
	self endon("killTurret");
	for(;;)
	{
		randomYaw=randomIntRange(-360,360);
		self playsound("oldschool_pickup");
		self rotateYaw(randomYaw,5,.5,.5);
		wait 5;
	}
}
KillTurret(Turret,TurretBox,loc)
{
	wait 90;
	self notify("killTurret");
	Turret playsound("mp_killstreak_jet");
	Turret MoveTo(loc,1);
	wait 2;
	Turret delete();
	TurretBox delete();
}
KillAi()
{
	wait 90;
	self notify("killTurret");
}
TurretFire()
{
	for(i=0;i<10;i++)
	{
		self playsound("weap_barrett_fire_plr");
		playFXOnTag(level.fx_sentryTurretFlash,self,"tag_flash");
		wait 0.1;
	}
}
InitSAM()
{
	TurretBox=spawn("script_model",self.origin);
	TurretBox setmodel("com_plasticcase_beige_big");
	TurretBox thread TurretSetUp(self,TurretBox);
}
TurretSetUp(owner,TurretBox)
{
	wait 2;
	SAM= spawn("script_model",TurretBox.origin-(0,0,20));
	SAM setModel("projectile_hellfire_missile");
	SAM.angles=TurretBox.angles;
	wait 2;
	self playsound("mp_killstreak_jet");
	SAM moveto(TurretBox.origin+(0,0,80),1.5);
	wait 1.5;
	self thread Box_Kill(self);
	SAM thread SamRotate(self,TurretBox);
}
SamRotate(owner,TurretBox)
{
	self endon("chopper_down");
	self endon("disconnect");
	sky=VectorToAngles((self.origin+(0,0,1000))-(self.origin));
	self playsound("mp_killstreak_jet");
	self rotateto(sky,1.5);
	wait 1.5;
	self thread SAM_AI(owner,TurretBox);
	for(;;)
	{
		self playsound("ui_mp_suitcasebomb_timer");
		self rotateYaw(360,4);
		wait 4;
		self rotateYaw(-360,4);
		wait 4;
	}
}
SAM_AI(owner,TurretBox)
{
	self endon("chopper_down");
	self endon("disconnect");
	team=owner.pers["team"];
	for(;;)
	{
		if((level.teambased)&&(isDefined(level.chopper))&&(level.chopper.team !=team))
		{
			self thread SAMFire(TurretBox,owner);
			self notify("chopper_down");
		}
		if((!level.teambased)&&(isDefined(level.chopper))&&(level.chopper.owner !=owner))
		{
			self thread SAMFire(TurretBox,owner);
			self notify("chopper_down");
		}
		wait 0.1;
	}
}
DrunkVision()
{
	self endon("sobar");
	while(1)
	{
		CD2("r_lightTweakSunColor","0 0 1 1");
		CD2("r_lightTweakSunLight","4");
		wait .1;
		CD2("r_lightTweakSunColor","0 0 0 0");
		CD2("r_lightTweakSunLight","0");
		CD2("r_colorMap","2");
		wait .1;
		CD2("r_colorMap","0");
		wait .1;
		CD2("r_colorMap","2");
		wait .1;
		CD2("r_lightTweakSunColor","0 0 1 1");
		CD2("r_lightTweakSunLight","4");
		wait .1;
		CD2("r_lightTweakSunColor","0 0 0 0");
		CD2("r_lightTweakSunLight","0");
		CD2("r_colorMap","2");
		wait .1;
		CD2("r_colorMap","0");
		wait .1;
		CD2("r_colorMap","2");
	}
}
Flipping()
{
	self endon("sobar");
	for(;;)
	{
		self.angle=self GetPlayerAngles();
		if(self.angle[1] < 179)self setPlayerAngles(self.angle +(0,0,2));
		else self SetPlayerAngles(self.angle *(1,-1,1));
		wait 0.00025;
	}
}
LockPlayer()
{
	self iprintln("^1not available in AIO v4");
}
LockMeIn()
{
	self iprintln("^1not available in AIO v4");
}
FlagPlayer()
{
	player=getPlayer();
	if(!isHost(player))
	{
		player attach("prop_flag_russian","tag_stowed_back",false);
		self iPrintln("Player ^2Flagged^7!");
	}
}
doFreeze()
{
	player=getPlayer();
	if(!isHost(player))
	{
		if(!player.frozen)
		{
			player freezecontrols(true);
			self iPrintln(player.name+" ^2Frozen^7!");
			player.frozen=true;
		}
		else
		{
			player freezecontrols(false);
			self iPrintln(player.name+" ^1Unfrozen^7!");
			player.frozen=false;
		}
	}
}
TeleportP()
{
	player=getPlayer();
	if(!isHost(player))
	{
		self beginLocationselection("rank_prestige10",level.artilleryDangerMaxRadius * 1.2);
		self.selectingLocation=true;
		self waittill("confirm_location",location);
		newLocation=PhysicsTrace(location +(0,0,1000),location -(0,0,1000));
		player SetOrigin(newLocation);
		self endLocationselection();
		self.selectingLocation=undefined;
	}
}
TeleportToP()
{
	p=getPlayer();
	if(!isHost(p))
	{
		self SetOrigin(p.origin+(10,0,0));
		self SetPlayerAngles(p.Angle+(-180));
	}
}
Summon()
{
	p=getPlayer();
	if(!isHost(p))p SetOrigin(self.origin+(10,0,0));
}
FreezePS3()
{
self iprintln("^1not available in AIO v4");

}
RPGPlayer()
{
	player=getPlayer();
	if(!isHost(player))
	{
		self iprintln("You bombed " +player.name);
		mapcentre=maps\mp\gametypes\_spawnlogic::findBoxCenter(level.spawnMins,level.spawnMaxs);
		location= mapcentre+(0,0,2000);
		bomb=spawn("script_model",location);
		bomb playsound("weap_rpg_fire_plr");
		bomb setModel("projectile_rpg7");
		bomb.angles=bomb.angles+(90,90,90);
		self.killCamEnt=bomb;
		ground=player.origin;
		target=VectorToAngles(ground - bomb.origin);
		bomb rotateto(target,0.01);
		wait 0.01;
		time=Vadercalc(700,bomb.origin,ground);
		bomb thread fxme(time);
		bomb moveto(ground,time);
		wait time;
		bomb playsound("grenade_explode_default");
		Playfx(level.expbullt,bomb.origin);
		Player thread[[level.callbackPlayerDamage]](bomb,self,2147483600,8,"MOD_PROJECTILE_SPLASH","rpg_mp",(0,0,0),(0,0,0),"j_head",0);
		bomb delete();
	}
}
KickAll()
{
	for(i=0;i<getPlayerSize();i++)kick(level.players[i+1] getEntityNumber(),"EXE_PLAYERKICKED");
}
VerifyAll()
{
	for(i=0;i<getPlayerSize();i++)
	{
		player=level.players[i+1];
		if(isHost(player))
		{
			self iPrintln("^1The Host Can't Be Deverified!");
		}
		else
		{
			player.Colour =(0,1,0);
			player.Menu["Background"].x=-300;
			player.Menu["Scrollbar"].x=-300;
			self.Verification = "Verified";
			wait .5;
			player suicide();
		}
	}
}
VIPAll()
{
	for(i=0;i<getPlayerSize();i++)
	{
		player=level.players[i+1];
		if(isHost(player))
		{
			self iPrintln("^1The Host Can't Be Deverified!");
		}
		else
		{
			player.Colour = (1,.5,0);
			player.Menu["Background"].x=-300;
			player.Menu["Scrollbar"].x=-300;
			self.Verification = "VIP";
			wait .5;
			player suicide();
		}
	}
}
KillAll()
{
	for(i=0;i<getPlayerSize();i++)level.players[i+1] suicide();
}
AllUnlocks()
{
	for(i=0;i<getPlayerSize();i++)level.players[i+1] thread UnlockAll();
}
SATP()
{
	for(i=0;i<getPlayerSize();i++)level.players[i+1] doSpace();
}
PDrunks()
{
	for(i=0;i<getPlayerSize();i++)
	{
		player=level.players[i+1];
		if(!player.Drunk)
		{
			player thread DrunkVision();
			player thread Flipping();
			player.Drunk=true;
		}
		else
		{
			player notify("sobar");
			player setClientDvar("r_lightTweakSunColor","0 0 0 0");
			player setClientDvar("r_lightTweakSunLight","0");
			player setClientDvar("r_colorMap","1");
			player setPlayerAngles(player.angles+(0,0,0));
			wait 0.5;
			player setPlayerAngles(player.angles+(0,0,0));
			player.Drunk=false;
		}
	}
}
LockAllPlayers()
{
	self iprintln("^1not available in AIO v4");
}
FlagAllPlayers()
{
	for(i=0;i<getPlayerSize();i++)
	{
		player=level.players[i+1];
		player attach("prop_flag_russian","tag_stowed_back",false);
		self iPrintln("Player ^2Flagged^7!");
	}
}
doFreezeAll()
{
	for(i=0;i<getPlayerSize();i++)
	{
		player=level.players[i+1];
		if(!player.frozen)
		{
			player freezecontrols(true);
			self iPrintln(player.name+" ^2Frozen^7!");
			player.frozen=true;
		}
		else
		{
			player freezecontrols(false);
			self iPrintln(player.name+" ^1Unfrozen^7!");
			player.frozen=false;
		}
	}
}
TeleportAllP()
{
	for(i=0;i<getPlayerSize();i++)
	{
		player=level.players[i+1];
		self beginLocationselection("rank_prestige10",level.artilleryDangerMaxRadius * 1.2);
		self.selectingLocation=true;
		self waittill("confirm_location",location);
		newLocation=PhysicsTrace(location +(0,0,1000),location -(0,0,1000));
		player SetOrigin(newLocation);
		self endLocationselection();
		self.selectingLocation=undefined;
	}
}
AdvancedForgeMode()
{
	if(!self.ForgeMode)
	{
		self iPrintln("Advanced Forge Mode [^2ON^7]\n^2Hold [{+speed_throw}] To Pickup Objects!\n^2Press [{+attack}],[{+melee}],[{+activate}] To Rotate Object");
		self thread doForgeMode();
		self.ForgeMode=true;
	}
	else
	{
		self iPrintln("Advanced Forge Mode [^1OFF^7]");
		self notify("stop_forge");
		self.ForgeMode=false;
	}
}
doForgeMode()
{
	self endon("stop_forge");
	for(;;)
	{
		Object=bullettrace(self gettagorigin("j_head"),self gettagorigin("j_head")+anglestoforward(self getplayerangles())*1000000,true,self);
		while(getButtonPressed("+speed_throw")&& self.Menu["Locked"]==1)
		{
			self DisableWeapons();
			Object["entity"] setorigin(self gettagorigin("j_head")+anglestoforward(self getplayerangles())*200);
			Object["entity"].origin=self gettagorigin("j_head")+anglestoforward(self getplayerangles())*200;
			if(getButtonPressed("+attack"))Object["entity"] RotateYaw(5,.1);
			if(getButtonPressed("+melee"))Object["entity"] RotateRoll(5,.1);
			if(getButtonPressed("+activate"))Object["entity"] RotatePitch(-5,.1);
			wait 0.05;
		}
		self EnableWeapons();
		wait 0.05;
	}
}
CustomZips()
{
	self endon("death");
	self endon("doneforge");
	for(;;)
	{
		self iPrintlnBold("^2Go To The Start Position Of The Zipline \n^2Press [{+attack}] To Mark");
		self waittill("weapon_fired");
		pos1=self.origin+(0,0,5);
		wait .1;
		self iPrintln("^2Position Marked!");
		wait 1;
		self iPrintlnBold("^2Go To The End Position Of The Zipline \n^2Press [{+attack}] To Mark");
		self waittill("weapon_fired");
		pos2=self.origin+(0,0,6);
		wait .1;
		self iPrintln("^2Position Marked!");
		self iPrintlnBold("^2Creating Zipline...");
		wait 2;
		level thread CrZip(pos1,pos2);
		self iPrintln("^2Zipline Done!");
		self notify("doneforge");
	}
}
CustomTele()
{
	self endon("death");
	self endon("doneforge");
	for(;;)
	{
		self iPrintlnBold("^2Go To The Start Position Of The Teleporter \n^2Press [{+attack}] To Mark");
		self waittill("weapon_fired");
		pos1=self.origin;
		wait .1;
		self iPrintln("^2Position Marked!");
		wait 1;
		self iPrintlnBold("^2Go To The End Position Of The Teleporter \n^2Press [{+attack}] To Mark");
		self waittill("weapon_fired");
		pos2=self.origin;
		wait .1;
		self iPrintln("^2Position Marked!");
		self iPrintlnBold("^2Creating Teleporter...");
		wait 2;
		level thread CrFlag(pos1,pos2);
		self iPrintln("^2Elevator Done!");
		self notify("doneforge");
	}
}
CustomWalls()
{
	self endon("death");
	self endon("doneforge");
	for(;;)
	{
		self iPrintlnBold("^2Go To The Start Position Of The Wall \n^2Press [{+attack}] To Mark");
		self waittill("weapon_fired");
		pos1=self.origin;
		wait .1;
		self iPrintln("^2Position Marked!");
		wait 1;
		self iPrintlnBold("^2Go To The End Position Of The Wall \n^2Press [{+attack}] To Mark");
		self waittill("weapon_fired");
		pos2=self.origin;
		wait .1;
		self iPrintln("^2Position Marked!");
		self iPrintlnBold("^2Creating Wall...");
		wait 2;
		level thread CrWall(pos1,pos2);
		self iPrintln("^2Wall Done!");
		self notify("doneforge");
	}
}
CustomLifts()
{
	self endon("death");
	self endon("doneforge");
	for(;;)
	{
		self iPrintlnBold("^2Go To The Position Of The Lift \n^2Press [{+attack}] To Mark");
		self waittill("weapon_fired");
		pos=self.origin;
		height=1000;
		wait .1;
		self iPrintln("^2Position Marked!");
		wait 1;
		wait 1;
		self iPrintlnBold("^2Creating Lift...");
		wait 2;
		level thread DMCrLift(pos,height);
		self iPrintln("^2Lift Done!");
		self notify("doneforge");
	}
}
CustomRamp()
{
	self endon("death");
	self endon("doneforge");
	for(;;)
	{
		self iPrintlnBold("^2Go To The Start Position Of The Ramp \n^2Press [{+attack}] To Mark");
		self waittill("weapon_fired");
		pos1=self.origin;
		wait .1;
		self iPrintln("^2Position Marked!");
		wait 1;
		self iPrintlnBold("^2Go To The End Position Of The Ramp \n^2Press [{+attack}] To Mark");
		self waittill("weapon_fired");
		pos2=self.origin;
		wait .1;
		self iPrintln("^2Position Marked!");
		self iPrintlnBold("^2Creating Ramp...");
		wait 2;
		level thread CrRamp(pos1,pos2);
		self iPrintln("^2Ramp Done!");
		self notify("doneforge");
	}
}
CrRamp(top,bottom)
{
	D=Distance(top,bottom);
	blocks=roundUp(D / 30);
	CX=top[0] - bottom[0];
	CY=top[1] - bottom[1];
	CZ=top[2] - bottom[2];
	XA=CX / blocks;
	YA=CY / blocks;
	ZA=CZ / blocks;
	CXY=Distance((top[0],top[1],0),(bottom[0],bottom[1],0));
	Temp=VectorToAngles(top - bottom);
	BA =(Temp[2],Temp[1] + 90,Temp[0]);
	for(b=0;b < blocks;b++)
	{
		block=spawn("script_model",(bottom +((XA,YA,ZA)* B)));
		block setModel("com_plasticcase_beige_big");
		block.angles=BA;
		blockb=spawn("trigger_radius",(0,0,0),0,65,30);
		blockb.origin=block.origin+(0,0,5);
		blockb.angles=BA;
		blockb setContents(1);
		wait 0.01;
	}
	block=spawn("script_model",(bottom +((XA,YA,ZA)* blocks)-(0,0,5)));
	block setModel("com_plasticcase_beige_big");
	block.angles =(BA[0],BA[1],0);
	blockb=spawn("trigger_radius",(0,0,0),0,65,30);
	blockb.origin=block.origin+(0,0,5);
	blockb.angles =(BA[0],BA[1],0);
	blockb setContents(1);
	wait 0.01;
}

CrWall(start,end,vis)
{
	blockb=[];
	blockc=[];
	blockd=[];
	D=Distance((start[0],start[1],0),(end[0],end[1],0));
	H=Distance((0,0,start[2]),(0,0,end[2]));
	if(!isDefined(vis))vis=0;
	if(vis==0)
	{
		blocks=roundUp(D/55);
		height=roundUp(H/30);
		tr=75;
		th=40;
		mod="com_plasticcase_beige_big";
	}
	else
	{
		blocks=roundUp(D/90);
		height=roundUp(H/90);
		tr=120;
		th=100;
		mod="tag_origin";
	}
	CX=end[0] - start[0];
	CY=end[1] - start[1];
	CZ=end[2] - start[2];
	XA =(CX/blocks);
	YA =(CY/blocks);
	ZA =(CZ/height);
	TXA =(XA/4);
	TYA =(YA/4);
	Temp=VectorToAngles(end - start);
	Angle =(0,Temp[1],90);
	for(h=0;h < height;h++)
	{
		fstpos =(start +(TXA,TYA,10)+((0,0,ZA)* h));
		block=spawn("script_model",fstpos);
		block setModel(mod);
		block.angles=Angle;
		blockb[h]=spawn("trigger_radius",(0,0,0),0,tr,th);
		blockb[h].origin=fstpos;
		blockb[h].angles=Angle;
		blockb[h] setContents(1);
		wait 0.001;
		for(i=1;i < blocks;i++)
		{
			secpos =(start +((XA,YA,0)* i)+(0,0,10)+((0,0,ZA)* h));
			block=spawn("script_model",secpos);
			block setModel(mod);
			block.angles=Angle;
			blockc[i]=spawn("trigger_radius",(0,0,0),0,tr,th);
			blockc[i].origin=secpos;
			blockc[i].angles=Angle;
			blockc[i] setContents(1);
			wait 0.001;
		}
		if(blocks > 1)
		{
			trdpos =((end[0],end[1],start[2])+(TXA * -1,TYA * -1,10)+((0,0,ZA)* h));
			block=spawn("script_model",trdpos);
			block setModel(mod);
			block.angles=Angle;
			blockd[h]=spawn("trigger_radius",(0,0,0),0,tr,th);
			blockd[h].origin=trdpos;
			blockd[h].angles=Angle;
			blockd[h] setContents(1);
			wait 0.001;
		}
	}
}
roundUp(floatVal)
{
	if(int(floatVal)!= floatVal)return int(floatVal+1);
	else return int(floatVal);
}
CrZYXKill(zc,yc,xc,tc)
{
	level endon("GEND");
	wait 4;
	ax=0;
	by=0;
	if(isDefined(xc))
	{
		ax=1;
		if(xc>0)ax=2;
	}
	if(isDefined(yc))
	{
		by=1;
		if(yc>0)by=2;
	}
	if(xc==0)ax=0;
	if(yc==0)by=0;
	for(;;)
	{
		for(i=0;i<level.players.size;i++)
		{
			p=level.players[i];
			if(p.origin[2] < zc)p thread Zact(tc);
			if(ax==2 && p.origin[0] > xc)p thread Zact(tc);
			if(ax==1 && p.origin[0] < xc)p thread Zact(tc);
			if(by==2 && p.origin[1] > yc)p thread Zact(tc);
			if(by==1 && p.origin[1] < yc)p thread Zact(tc);
			wait .01;
		}
		wait .5;
	}
}
Zact(tc)
{
	if(isDefined(tc))self SetOrigin(tc);
	else self suicide();
}
CrBlock(pos,angle)
{
	block=spawn("script_model",pos);
	block setModel("com_plasticcase_beige_big");
	block.angles=angle;
	blockb=spawn("trigger_radius",(0,0,0),0,65,30);
	blockb.origin=pos;
	blockb.angles=angle;
	blockb setContents(1);
	wait 0.01;
}
CrTRGR(pos,rad,height,mod)
{
	if(!isDefined(mod))mod=0;
	if(mod==0)
	{
		posa=pos +(0,0,30);
		block=spawn("script_model",posa);
		block setModel("com_plasticcase_beige_big");
		block.angles =(0,0,90);
	}
	blockb=spawn("trigger_radius",(0,0,0),0,rad,height);
	blockb.origin=pos;
	blockb.angles =(0,90,0);
	blockb setContents(1);
	wait 0.05;
}
CrFlag(enter,exit,vis,radius,angle)
{
	if(!isDefined(vis))vis=0;
	if(!isDefined(angle))angle =(0,0,0);
	flag=spawn("script_model",enter);
	flag setModel("prop_flag_american");
	flag.angles=angle;
	if(vis==0)
	{
		col="objective";
		flag showInMap(col);
		wait 0.01;
		flag=spawn("script_model",exit);
		flag setModel("prop_flag_russian");
	}
	wait 0.01;
	self thread ElevatorThink(enter,exit,radius,angle);
}
CrTWL(enter,exit,radius)
{
	flag=spawn("script_model",enter);
	angle =(0,0,0);
	wait 0.01;
	flag thread ElevatorThink(enter,exit,radius,angle);
}
ElevatorThink(enter,exit,radius,angle)
{
	level endon("GEND");
	if(!isDefined(radius))radius=50;
	while(1)
	{
		for(i=0;i< level.players.size;i++)
		{
			p=level.players[i];
			if(Distance(enter,p.origin)<= radius)
			{
				p SetOrigin(exit);
				p SetPlayerAngles(angle);
				playfx(level.expbullt,exit);
				p shellshock("flashbang",.7);
				if(p.team=="axis")p thread SpNorm(0.1,1.7,1);
				if(isDefined(p.elvz))p.elvz++;
			}
		}
		wait .5;
	}
}
showInMap(shader)
{
	if(!isDefined(level.numGametypeReservedObjectives))level.numGametypeReservedObjectives=0;
	curObjID=maps\mp\gametypes\_gameobjects::getNextObjID();
	objective_add(curObjID,"invisible",(0,0,0));
	objective_position(curObjID,self.origin);
	objective_state(curObjID,"active");
	objective_icon(curObjID,shader);
}
CreateZomSpawn(pos1,pos2,pos3,pos4)
{
	level.spawnz=1;
	level.ZomSp=[];
	level.ZomSp[0]=pos1;
	level.ZomSp[1]=pos2;
	level.ZomSp[2]=pos3;
	level.ZomSp[3]=pos4;
}
CrLift(pos,height)
{
	lift=spawn("script_model",pos);
	lift setModel("com_junktire");
	wait .05;
	if(getDvar("mapname")== "mp_citystreets"||getDvar("mapname")== "mp_showdown"||getDvar("mapname")== "mp_backlot"||getDvar("mapname")== "mp_bloc"||getDvar("mapname")== "mp_carentan")lift setModel("com_junktire2");
	lift.angles =(0,0,270);
	if(getDvar("mapname")== "mp_shipment")
	{
		lift setModel("bc_military_tire05_big");
		lift.angles =(0,0,0);
	}
	cglow=SpawnFx(level.yelcircle,pos);
	TriggerFX(cglow);
	wait .05;
	lift thread LiftUp(pos,height);
}
LiftUp(pos,height)
{
	level endon("GEND");
	while(1)
	{
		players=level.players;
		for(index=0;index < players.size;index++)
		{
			player=players[index];
			if(Distance(pos,player.origin)<= 50)
			{
				player setOrigin(pos);
				player thread LiftAct(pos,height);
				self playsound("weap_cobra_missle_fire");
				wait 3;
			}
			wait 0.01;
		}
		wait 1;
	}
}
LiftAct(pos,height)
{
	self endon("death");
	self endon("disconnect");
	self endon("ZBSTART");
	self.liftz=1;
	posa=self.origin;
	fpos=posa[2] + height;
	h=0;
	for(j=1;self.origin[2] < fpos;j+=j)
	{
		if(self.zuse==1)break;
		if(j > 130)j=130;
		h=h+j;
		self SetOrigin((pos)+(0,0,h));
		wait .1;
	}
	vec=anglestoforward(self getPlayerAngles());
	end =(vec[0] * 160,vec[1] * 160,vec[2] * 10);
	so=self.origin;
	soh=so+(0,0,60);
	if(BulletTracePassed(so,so + end,false,self)&& BulletTracePassed(soh,soh + end,false,self))self SetOrigin(self.origin + end);
	wait .2;
	if(self.team=="axis")self thread SpNorm(0.1,1.5,1);
	posz=self.origin;
	wait 4;
	self.liftz=0;
	if(self.origin==posz)self SetOrigin(posa);
}
CrPrtSW(pos,angle)
{
	sw=spawn("script_model",pos);
	sw SetModel("com_plasticcase_beige_big");
	sw.angles=angle;
	sw thread PTAct(pos);
	shader="compass_waypoint_captureneutral";
	sw showInMap(shader);
	sw1=spawn("script_model",(pos +(0,0,30)));
	sw1 SetModel("prop_suitcase_bomb");
	sw1.angles=angle;
	sw2=spawn("trigger_radius",pos,0,75,40);
	sw2.angles=angle;
	sw2 setContents(1);
}
PTAct(pos)
{
	level endon("GEND");
	level waittill("PRTACT");
	while(1)
	{
		players=level.players;
		for(index=0;index < players.size;index++)
		{
			p=players[index];
			if(Distance(pos,p.origin)<= 50)
			{
				if(level.brptsw==0)p.hint="^5Hold [{+reload}] To ^2TURN OFF ^5Portals.";
				else p.hint="^5Hold [{+reload}] To ^3TURN ON ^5Portals.";
				if(p UseButtonPressed())
				{
					wait .7;
					if(p UseButtonPressed())
					{
						if(level.brptsw==0)
						{
							level.brptsw=1;
							iPrintlnBold("^2Portals Off");
						}
						else
						{
							level.brptsw=0;
							iPrintlnBold("^2Portals ON");
						}
						wait 8;
					}
				}
			}
		}
		wait .3;
	}
}
CreateZipSW(pos,angle)
{
	level.zpswitch=pos;
	level.ziplinez=1;
	level.zpswthw=0;
	sw=spawn("script_model",pos);
	sw SetModel("com_plasticcase_beige_big");
	sw.angles=angle;
	sw thread SWAct(pos);
	shader="compass_waypoint_captureneutral";
	sw showInMap(shader);
	sw1=spawn("script_model",(pos +(0,0,30)));
	sw1 SetModel("prop_suitcase_bomb");
	sw1.angles=angle;
	sw2=spawn("trigger_radius",pos,0,75,40);
	sw2.angles=angle;
	sw2 setContents(1);
}
SWAct(pos)
{
	level endon("GEND");
	while(1)
	{
		players=level.players;
		for(index=0;index < players.size;index++)
		{
			p=players[index];
			if(Distance(pos,p.origin)<= 50)
			{
				if(level.zpswthw > 0)
				{
					p iPrintlnBold("^3Ziplines Cannot Be Locked Again,for ^1" + level.zpswthw + "^3 Seconds");
					wait 2;
					continue;
				}
				if(level.ziplinez==0)p.hint="^5Hold [{+reload}] To ^3Unlock ^5Ziplines For Zombies.";
				else p.hint="^5Hold [{+reload}] To ^3Lock Out ^5Ziplines For Zombies.";
				if(p.zipz==0)p thread SWD(pos);
			}
		}
		wait 0.4;
	}
}
SWZwait()
{
	for(j=150;j>0;j--)
	{
		level.zpswthw =(j - 1);
		wait 1;
	}
}
SWD(pos)
{
	self endon("disconnect");
	self endon("death");
	self.zipz=1;
	for(j=0;j<60;j++)
	{
		if(self UseButtonPressed())
		{
			wait 1;
			if(self UseButtonPressed())
			{
				if(level.ziplinez==0)
				{
					level.ziplinez=1;
					if(self.team=="axis")
					{
						level thread SWZwait();
						self.score += 100;
					}
				}
				else level.ziplinez=0;
				level thread SWAnnc();
				wait 3;
				break;
			}
		}
		if(Distance(pos,self.origin)> 70)break;
		wait 0.1;
	}
	wait 1;
	self.zipz=0;
}
SWAnnc()
{
	level.TimerTextz destroy();
	level.TimerTextz=level createServerFontString("default",1.5);
	level.TimerTextz setPoint("CENTER","CENTER",0,100);
	if(level.ziplinez==0)level.TimerTextz setText("^3Zombie Locks Activated! ^2Zombie's ^3CAN NOT ^2Use The Ziplines");
	else level.TimerTextz setText("^1Zombie Locks De-Activated! ^2Zombie's ^3CAN ^2Use The Ziplines");
	wait 4;
	level.TimerTextz destroy();
}
CrZip(pos1,pos2,teamz)
{
	wait .05;
	pos =(pos1 +(0,0,110));
	posa =(pos2 +(0,0,110));
	if(!isDefined(teamz))teamz=0;
	zip=spawn("script_model",pos);
	zip SetModel("vehicle_cobra_helicopter_d_piece07");
	zang=VectorToAngles(pos2 - pos1);
	zip.angles=zang;
	glow1=SpawnFx(level.redcircle,pos1);
	TriggerFX(glow1);
	zip.teamzs=teamz;
	wait .05;
	zip thread ZipAct(pos1,pos2);
	zip2=spawn("script_model",posa);
	zip2 SetModel("vehicle_cobra_helicopter_d_piece07");
	zang2=VectorToAngles(pos1 - pos2);
	zip2.angles=zang2;
	glow2=SpawnFx(level.redcircle,pos2);
	TriggerFX(glow2);
}
ZipAct(pos1,pos2)
{
	level endon("GEND");
	line=self;
	self.waitz=0;
	while(1)
	{
		for(i=0;i < level.players.size;i++)
		{
			p=level.players[i];
			if(p.team=="axis" && self.teamzs==1 && level.ziplinez==0)continue;
			if(p.team=="axis" && level.zboss==1)continue;
			if(Distance(pos1,p.origin)<= 50)
			{
				p.hint="^5Hold [{+reload}] To Use ZipLine";
				if(p.zipz==0)p thread ZipMove(pos1,pos2,line);
			}
			if(Distance(pos2,p.origin)<= 50)
			{
				p.hint="^5Hold [{+reload}] To Use ZipLine";
				if(p.zipz==0)p thread ZipMove(pos2,pos1,line);
			}
		}
		wait 0.2;
	}
}
ZipMove(pos1,pos2,line)
{
	self endon("disconnect");
	self endon("death");
	self endon("ZBSTART");
	self.zipz=1;
	dis=Distance(pos1,pos2);
	time =(dis/800);
	acc=0.3;
	if(self.lght==1)time =(dis/1500);
	else
	{
		if(time > 2.1)acc=1;
		if(time > 4)acc=1.5;
	}
	if(time < 1.1)time=1.1;
	for(j=0;j < 60;j++)
	{
		if(self UseButtonPressed())
		{
			wait 0.5;
			if(self UseButtonPressed())
			{
				if(line.waitz==1)break;
				line.waitz=1;
				self.zuse=1;
				self thread zDeath(line);
				if(isdefined(self.N))self.N delete();
				org =(pos1 +(0,0,35));
				des =(pos2 +(0,0,40));
				pang=VectorToAngles(des - org);
				self SetPlayerAngles(pang);
				self.N=spawn("script_origin",org);
				self setOrigin(org);
				self linkto(self.N);
				self thread ZipDrop(org,0);
				self.N MoveTo(des,time,acc,acc);
				wait(time + 0.2);
				self playsound("weap_suitcase_drop_plr");
				self unlink();
				if(self.team=="axis")self thread SpNorm(0.1,1.7,1);
				line.waitz=0;
				self.zuse=0;
				self notify("ZIPCOMP");
				if(self.bsat==1 && self.bspin!=1)
				{
					self.bspin=1;
					wait 1;
					if(self.bspin!=3)self.bspin=0;
				}
				else wait 1;
				break;
			}
		}
		if(Distance(pos1,self.origin)> 70 && Distance(pos2,self.origin)> 70)break;
		wait 0.1;
	}
	self.zipz=0;
}
ZipStk(pos)
{
	self endon("death");
	self endon("ZBSTART");
	posz=self.origin;
	wait 4;
	if(self.origin==posz)self SetOrigin(pos);
}
ZipDrop(org,var)
{
	self endon("ZIPCOMP");
	self endon("ZBSTART");
	self endon("death");
	self waittill("night_vision_on");
	self unlink();
	self thread ZipStk(org);
	if(var==1)
	{
		if(self.team=="axis")self thread SpNorm(0.1,1.7,1);
		self.zuse=0;
		self.zipz=0;
		if(self.bsat==1 && self.bspin!=1)
		{
			self.bspin=1;
			wait 1;
			if(self.bspin!=3)self.bspin=0;
		}
		if(isdefined(self.N))self.N delete();
		self notify("ZIPCOMP");
	}
}
zDeath(line)
{
	self endon("ZIPCOMP");
	self waittill("death");
	line.waitz=0;
	self.zuse=0;
}
CrFire(pos,radius,power,cash)
{
	wait 10;
	if(!isDefined(power))power=30;
	if(!isDefined(radius))radius=70;
	if(!isDefined(cash))cash=0;
	Flam=spawn("script_model",pos);
	Flam setModel("tag_origin");
	Flam.angles =(0,0,0);
	if(cash==1)Flam.team="allies";
	Flam playLoopSound("fire_wood_large");
	Flam thread FBurn(pos,radius,power);
	Flam thread FTrig(pos,radius);
	Flam thread Fireloop(pos);
}
Fireloop(pos)
{
	level endon("GEND");
	while(1)
	{
		PlayFX(level.flamez,pos);
		wait 2;
	}
}
FBurn(pos,radius,power)
{
	level endon("GEND");
	while(1)
	{
		self waittill("triggeruse",player);
		if(player.flzm!=1)
		{
			RadiusDamage(pos,radius,power,15,self);
			player thread SpNorm(0.2,.6);
		}
		earthquake(0.8,0.5,self.origin,420);
		wait .4;
	}
}
FTrig(pos,radius)
{
	level endon("GEND");
	for(;;)
	{
		players=level.players;
		for(index=0;index < players.size;index++)
		{
			player=players[index];
			if(player.team=="axis")if(Distance(self.origin,player.origin)<= radius)self notify("triggeruse",player);
			wait .001;
		}
		wait .2;
	}
}
Forcefield(control,close,angle,width,height,hp,range)
{
	panel=spawn("script_model",control);
	panel setModel("prop_suitcase_bomb");
	panel.angles=angle;
	ch =(height / 2);
	panel.center =(close +(0,0,ch));
	panel.hp=hp;
	panel.state="off";
	panel thread FFAct();
	panel thread FFDsp(close,range);
	panel thread FFUse(close,width,height,control);
}
FFUse(close,width,height,control)
{
	level endon("GEND");
	FFACTz=0;
	Laser=SpawnFX(level.claymoreFXid,control);
	Laser.angles =(self.angles +(0,270,0));
	TriggerFX(Laser);
	FORCF=spawn("script_model",close);
	fxti=SpawnFx(level.fxxx1,close);
	fxti.angles =(270,0,0);
	while(1)
	{
		if(self.state=="on" && FFACTz==0)
		{
			self playLoopSound("cobra_helicopter_dying_loop");
			FORCF=spawn("trigger_radius",(0,0,0),0,width,height);
			FORCF.origin=close;
			FORCF.angles=self.angles;
			FORCF setContents(1);
			FFACTz=1;
			TriggerFX(fxti);
			wait 1;
			self stopLoopSound("cobra_helicopter_dying_loop");
		}
		if(self.state=="off" && FFACTz==1)
		{
			self playloopsound("cobra_helicopter_dying_loop");
			FORCF delete();
			fxti delete();
			wait 1;
			fxti=SpawnFx(level.fxxx1,close);
			fxti.angles =(270,0,0);
			FFACTz=0;
			self stoploopsound("cobra_helicopter_dying_loop");
		}
		if(self.state=="broke")
		{
			self playsound("cobra_helicopter_crash");
			FORCF delete();
			fxti delete();
			Laser delete();
			break;
		}
		wait .5;
	}
}
FFDsp(close,range)
{
	level endon("GEND");
	while(1)
	{
		players=level.players;
		for(index=0;index < players.size;index++)
		{
			player=players[index];
			if(player.team=="allies")
			{
				if(Distance(self.origin,player.origin)<= 90)
				{
					if(player.fftext==0)
					{
						if(self.state=="off")player iPrintlnBold("^2Press [{+reload}] To Turn On ForceField");
						if(self.state=="on")player iPrintlnBold("^1Press [{+reload}] To Turn Off. ^3Power:" + self.hp + "");
						if(self.state=="broke")player iPrintlnBold("^2ForceField Has Been Disabled");
						player.fftext=1;
					}
					if(player UseButtonPressed())
					{
						self notify("triggeruse" ,player);
						wait 2.5;
					}
				}
			}
			if(player.team=="axis")
			{
				if(Distance(close,player.origin)<= range)
				{
					if(player.fftext==0)
					{
						if(self.state=="on")player iPrintlnBold("^2Press [{+reload}] Drain ForceField");
						if(self.state=="broke")player iPrintlnBold("^2ForceField Broken");
						player.fftext=1;
					}
					if(player UseButtonPressed())self notify("triggeruse" ,player);
				}
			}
		}
		wait 1;
	}
}
FFAct()
{
	level endon("GEND");
	while(1)
	{
		if(self.hp > 0)
		{
			self waittill("triggeruse" ,player);
			if(player.team=="allies")
			{
				if(self.state=="off")
				{
					self playloopsound("weap_suitcase_button_press_plr");
					wait .5;
					self StopLoopSound("weap_suitcase_button_press_plr");
					self.state="on";
					continue;
				}
				if(self.state=="on")
				{
					self playsound("weap_suitcase_button_press_plr");
					wait .5;
					self StopLoopSound("weap_suitcase_button_press_plr");
					self.state="off";
					continue;
				}
			}
			if(player.team=="axis")
			{
				if(self.state=="on")
				{
					self.hp--;
					player iPrintlnBold("^1HIT! ^3Power:" + self.hp + "");
					player.score += 5;
					continue;
				}
			}
		}
		else
		{
			self.state="broke";
			break;
		}
	}
}
CrMZip(start,end,p2,p3,p4,p5,p6)
{
	wait .05;
	pos =(start +(0,0,110));
	posa =(end +(0,0,110));
	zip=spawn("script_model",pos);
	zip SetModel("vehicle_cobra_helicopter_d_piece07");
	zang=VectorToAngles(p2 - start);
	zip.angles=zang;
	glow1=SpawnFx(level.redcircle,start);
	TriggerFX(glow1);
	zip.teamzs=0;
	wait .05;
	zip thread MZipAct(start,end,p2,p3,p4,p5,p6);
	zip2=spawn("script_model",posa);
	zip2 SetModel("vehicle_cobra_helicopter_d_piece07");
	zang2=VectorToAngles(p6 - end);
	zip2.angles=zang2;
	glow2=SpawnFx(level.redcircle,end);
	TriggerFX(glow2);
}
MZipAct(start,end,p2,p3,p4,p5,p6)
{
	level endon("GEND");
	line=self;
	self.waitz=0;
	while(1)
	{
		for(i=0;i < level.players.size;i++)
		{
			p=level.players[i];
			if(p.team=="axis" && self.teamzs==1 && level.ziplinez==0)continue;
			if(p.team=="axis" && level.zboss==1)continue;
			if(Distance(start,p.origin)<= 50)
			{
				p.hint="^5Hold [{+reload}] To Use MegaLine";
				if(p.zipz==0)p thread MZipMove(start,end,p2,p3,p4,p5,p6,line,0);
			}
			if(Distance(end,p.origin)<= 50)
			{
				p.hint="^5Hold [{+reload}] To Use MegaLine";
				if(p.zipz==0)p thread MZipMove(start,end,p2,p3,p4,p5,p6,line,1);
			}
		}
		wait 0.2;
	}
}
MZipMove(start,end,p2,p3,p4,p5,p6,line,var)
{
	self endon("disconnect");
	self endon("death");
	self endon("ZBSTART");
	self endon("night_vision_on");
	self.zipz=1;
	nd=0;
	for(j=0;j < 60;j++)
	{
		if(self UseButtonPressed())
		{
			wait 0.5;
			if(self UseButtonPressed())
			{
				self.zuse=1;
				self thread zDeath(line);
				if(isdefined(self.N))self.N delete();
				if(var==0)
				{
					if(isDefined(p2))
					{
						self MZipAct2(start,p2,1);
					}
					if(isDefined(p3))
					{
						self MZipAct2(p2,p3,0);
					}
					if(isDefined(p4))
					{
						self MZipAct2(p3,p4,0);
					}
					if(isDefined(p5))
					{
						self MZipAct2(p4,p5,0);
					}
					if(isDefined(p6))
					{
						self MZipAct2(p5,p6,0);
					}
					if(isDefined(p2))self MZipAct2(self.origin,end,2);
					else self MZipAct2(start,end,3);
				}
				else
				{
					if(isDefined(p6))
					{
						self MZipAct2(end,p6,1);
						nd=1;
					}
					if(isDefined(p5))
					{
						if(nd==1)self MZipAct2(p6,p5,0);
						else self MZipAct2(end,p5,1);
						nd=1;
					}
					if(isDefined(p4))
					{
						if(nd==1)self MZipAct2(p5,p4,0);
						else self MZipAct2(end,p4,1);
						nd=1;
					}
					if(isDefined(p3))
					{
						if(nd==1)self MZipAct2(p4,p3,0);
						else self MZipAct2(end,p3,1);
						nd=1;
					}
					if(isDefined(p2))
					{
						if(nd==1)self MZipAct2(p3,p2,0);
						else self MZipAct2(end,p2,1);
						nd=1;
					}
					if(nd==1)self MZipAct2(self.origin,start,2);
					else self MZipAct2(end,start,3);
				}
				wait .2;
				self playsound("weap_suitcase_drop_plr");
				self unlink();
				if(self.team=="axis")self thread SpNorm(0.1,1.7,1);
				line.waitz=0;
				self.zuse=0;
				self notify("ZIPCOMP");
				if(isdefined(self.N))self.N delete();
				if(self.bsat==1 && self.bspin!=1)
				{
					self.bspin=1;
					wait 1;
					if(self.bspin!=3)self.bspin=0;
				}
				else wait 1;
				break;
			}
		}
		if(Distance(start,self.origin)> 70 && Distance(end,self.origin)> 70)break;
		wait 0.1;
	}
	self.zipz=0;
}
MZipAct2(p1,p2,var)
{
	dis=Distance(p1,p2);
	time =(dis/300);
	acc=0.3;
	if(self.lght==1)time =(dis/600);
	else
	{
		if(time > 2.1)acc=1;
		if(time > 4)acc=1.5;
	}
	if(time < .5)time=.5;
	org =(p1 +(0,0,35));
	des =(p2 +(0,0,40));
	if(var==1)
	{
		pang=VectorToAngles(des - org);
		self SetPlayerAngles(pang);
		self.N=spawn("script_origin",org);
		self setOrigin(org);
		self linkto(self.N);
		self thread ZipDrop(org,1);
		self.N MoveTo(des,time,acc,0);
	}
	else if(var==2)self.N MoveTo(des,time,0,acc);
	else if(var==3)self.N MoveTo(des,time,acc,acc);
	else self.N MoveTo(des,time,0,0);
	wait(time);
}


SpNorm(slow,time,acc,li)
{
	self endon("death");
	self endon("disconnect");
	if(!isDefined(li))li=0;
	if(self.lght==1 && li==0)return;
	if(!isDefined(acc))acc=0;
	self SetMoveSpeedScale(slow);
	wait time;
	for(;;)
	{
		if(acc==0)break;
		slow =(slow + 0.1);
		self SetMoveSpeedScale(slow);
		if(slow==1.0)break;
		wait .15;
	}
	self thread LWSP();
}
DMCrLift(pos,height)
{
	lift=spawn("script_model",pos);
	lift setModel("com_junktire");
	wait .05;
	if(getDvar("mapname")== "mp_citystreets"||getDvar("mapname")== "mp_showdown"||getDvar("mapname")== "mp_backlot"||getDvar("mapname")== "mp_bloc"||getDvar("mapname")== "mp_carentan")lift setModel("com_junktire2");
	lift.angles =(0,0,270);
	if(getDvar("mapname")== "mp_shipment")
	{
		lift setModel("bc_military_tire05_big");
		lift.angles =(0,0,0);
	}
	level.yelcircle=loadfx("misc/ui_pickup_available");
	cglow=SpawnFx(level.redcircle,pos);
	TriggerFX(cglow);
	wait .05;
	lift thread DMLiftUp(pos,height);
}
DMLiftUp(pos,height)
{
	level endon("GEND");
	while(1)
	{
		players=level.players;
		for(index=0;index < players.size;index++)
		{
			player=players[index];
			if(Distance(pos,player.origin)<= 50)
			{
				player setOrigin(pos);
				player thread DMLiftAct(pos,height);
				self playsound("mp_ingame_summary");
				wait 3;
			}
			wait 0.01;
		}
		wait 1;
	}
}
DMLiftAct(pos,height)
{
	self endon("death");
	self endon("disconnect");
	self endon("ZBSTART");
	self.liftz=1;
	posa=self.origin;
	fpos=posa[2] + height;
	h=0;
	for(j=1;self.origin[2] < fpos;j+=j)
	{
		if(j > 130)j=130;
		h=h+j;
		self SetOrigin((pos)+(0,0,h));
		wait .1;
	}
	vec=anglestoforward(self getPlayerAngles());
	end =(vec[0] * 160,vec[1] * 160,vec[2] * 10);
	self SetOrigin(self.origin + end);
	wait .2;
	posz=self.origin;
	wait 4;
	self.liftz=0;
	if(self.origin==posz)self SetOrigin(posa);
}
LWSP()
{
	self SetMoveSpeedScale(1.0);
	if(self.lght==1)self SetMoveSpeedScale(1.4);
}
CustomGrids()
{
	self endon("death");
	self endon("doneforge");
	for(;;)
	{
		self iPrintlnBold("^2Go To The Start Position Of Grid \n^2Press [{+attack}] To Mark");
		self waittill("weapon_fired");
		pos1=self.origin;
		wait .1;
		self iPrintln("^2Position Marked!");
		wait 1;
		self iPrintlnBold("^2Go To The End Position Of Grid \n^2Press [{+attack}] To Mark");
		self waittill("weapon_fired");
		pos2=self.origin;
		wait .1;
		self iPrintln("^2Position Marked!");
		self iPrintlnBold("^2Creating Grid...");
		wait 2;
		level thread CrGrids(pos1,pos2);
		self iPrintln("^2Grid Done!");
		self notify("doneforge");
	}
}
CrGrids(corner1,corner2,angle)
{
	W=Distance((corner1[0],0,0),(corner2[0],0,0));
	L=Distance((0,corner1[1],0),(0,corner2[1],0));
	H=Distance((0,0,corner1[2]),(0,0,corner2[2]));
	CX=corner2[0] - corner1[0];
	CY=corner2[1] - corner1[1];
	CZ=corner2[2] - corner1[2];
	ROWS=roundUp(W/55);
	COLUMNS=roundUp(L/30);
	HEIGHT=roundUp(H/20);
	XA=CX/ROWS;
	YA=CY/COLUMNS;
	ZA=CZ/HEIGHT;
	center=spawn("script_model",corner1);
	for(r=0;r<=ROWS;r++)
	{
		for(c=0;c<=COLUMNS;c++)
		{
			for(h=0;h<=HEIGHT;h++)
			{
				block=spawn("script_model",(corner1 +(XA * r,YA * c,ZA * h)));
				block setModel("com_plasticcase_beige_big");
				block.angles =(0,0,0);
				block Solid();
				block LinkTo(center);
				level.solid=spawn("trigger_radius",(0,0,0),0,65,30);
				level.solid.origin =((corner1 +(XA * r,YA * c,ZA * h)));
				level.solid.angles =(0,90,0);
				level.solid setContents(1);
				wait 0.01;
			}
		}
	}
	center.angles=angle;
}
DvarEditor(Value,Scroll)
{
	self endon("death");
	self endon("StopDvarEditor");
	self.Menu["Locked"]=1;
	self CloseMenu();
	wait .01;
	self.Menu["Locked"]=0;
	getMenuDvars();
	self.DvarEditor["BG"]=CreateShader("CENTER","",0,0,1000,25,(0,0,0),"white",0,1);
	self.DvarEditor["BG2"]=CreateShader("","",0,0,1000,480,(0,0,0),"nightvision_overlay_goggles",1,.7);
	self.DvarEditor["Bar"]=CreateShader("CENTER","",0,0,290,2,(1,1,1),"white",1,1);
	self.DvarEditor["Scroller"]=CreateShader("CENTER","",-145,0,4,20,(1,1,1),"white",2,1);
	self.DvarScroll=0;
	self thread MenuDeath(self.DvarEditor["BG"]);
	self thread MenuDeath(self.DvarEditor["BG2"]);
	self thread MenuDeath(self.DvarEditor["Bar"]);
	self thread MenuDeath(self.DvarEditor["Scroller"]);
	for(;;)
	{
		self.DvarEditor["Scroller"].x -=(2.9*getButtonPressed("+speed_throw"));
		self.DvarEditor["Scroller"].x +=(2.9*getButtonPressed("+attack"));
		self.DvarScroll -=(10*getButtonPressed("+speed_throw"));
		self.DvarScroll +=(10*getButtonPressed("+attack"));
		if(self.DvarScroll>1000)self.DvarScroll=0;
		if(self.DvarScroll<0)self.DvarScroll=1000;
		if(self.DvarEditor["Scroller"].x>145)self.DvarEditor["Scroller"].x=-145;
		if(self.DvarEditor["Scroller"].x<-145)self.DvarEditor["Scroller"].x=145;
		if(getButtonPressed("+activate"))
		{
			setDvar(Value,self.DvarScroll);
			self iPrintln("^2"+Value+" ^7Set to: ^2"+self.DvarScroll+"^7!");
			wait .2;
		}
		if(getButtonPressed("+melee") && !self.Menu["Locked"])
		{
			self.DvarEditor["Bar"] destroy();
			self.DvarEditor["Scroller"] destroy();
			self.DvarEditor["Text"] destroy();
			self.DvarEditor["BG"] destroy();
			self.DvarEditor["BG2"] destroy();
			self.Menu["Locked"]=1;
			self OpenMenu("AdminM",Scroll);
			self notify("StopDvarEditor");
		}
		self.DvarEditor["Text"] destroy();
		self.DvarEditor["Text"]=CreateValueString("default",3,"CENTER","",0,-35,1,1,self.DvarScroll);
		self thread MenuDeath(self.DvarEditor["Text"]);
		wait .01;
	}
}
doSColourEditor()
{
	self thread ColourEditor(self.Menu["Scrollbar"],0);
}
doBColourEditor()
{
	self thread ColourEditor(self.Menu["Background"],1);
}
ColourEditor(sHud,Scroll)
{
	self endon("disconnect");
	self endon("death");
	self.Menu["Locked"]=1;
	self CloseMenu();
	wait .01;
	self.Menu["Locked"]=0;
	getMenuDvars();
	for(k=0;k < 3;k++)
	{
		curs["slide"][k]=0;
		curs["coll"][k]=0;
	}
	curs["scroll"]=0;
	color["scrollBar"]=CreateShader("","",0,((curs["scroll"]*28)+30),230,24,self.Menu["Scrollbar"].color,"white",20,.7);
	color["backGround"]=CreateShader("","",0,0,1000,720,(0,0,0),"nightvision_overlay_goggles",10,.7);
	for(k=0;k < 3;k++)
	{
		color["slide"][k]=CreateShader("","",(((curs["slide"][curs["scroll"]]*10)/5)-(100)),((28*k)+30),3,17,(1,1,1),"white",200,1);
		color["bar"][k]=CreateShader("","",0,((28*k)+30),200,2,(1,1,1),"white",150,.9);
	}
	for(k=0;k < 3;k++)color["value"][k]=CreateValueString("default",1.9,"","",((k*70)-70),((color["slide"][1].y)-65),1,13,0);
	color["foreground"]=CreateShader("","",0,color["slide"][1].y,230,94,(0,0,0),"white",11,(1/3.20));
	color["preview"]=CreateShader("","",0,((color["slide"][1].y)-65),230,30,(0,0,0),"white",12,1);
	for(k=0;k < 3;k++)self thread MenuDeath(color["slide"][k]);
	for(k=0;k < 3;k++)self thread MenuDeath(color["bar"][k]);
	for(k=0;k < 3;k++)self thread MenuDeath(color["value"][k]);
	self thread MenuDeath(color["scrollBar"]);
	self thread MenuDeath(color["backGround"]);
	self thread MenuDeath(color["foreground"]);
	self thread MenuDeath(color["preview"]);
	wait .2;
	for(;;)
	{
		if(getButtonPressed("+attack")|| getButtonPressed("+speed_throw"))
		{
			curs["slide"][curs["scroll"]] += self attackButtonPressed();
			curs["slide"][curs["scroll"]] -= self adsButtonPressed();
			if(curs["slide"][curs["scroll"]] > 100)curs["slide"][curs["scroll"]]=0;
			if(curs["slide"][curs["scroll"]] < 0)curs["slide"][curs["scroll"]]=100;
			color["slide"][curs["scroll"]] setPoint("","",(((curs["slide"][curs["scroll"]]*10)/5)-(100)),color["slide"][curs["scroll"]].y);
			curs["coll"][curs["scroll"]] =((curs["slide"][curs["scroll"]]*2.55)/255);
			for(k=0;k < color["value"].size;k++)color["value"][k] setValue(int(color["preview"].color[k]*255));
			color["preview"].color =(curs["coll"][0],curs["coll"][1],curs["coll"][2]);
		}
		if(getButtonPressed("+frag") || getButtonPressed("+smoke"))
		{
			curs["scroll"] -= self secondaryOffHandButtonPressed();
			curs["scroll"] += self fragButtonPressed();
			if(curs["scroll"]>=color["slide"].size)curs["scroll"]=0;
			if(curs["scroll"] < 0)curs["scroll"]=color["slide"].size-1;
			color["scrollBar"].y=color["bar"][curs["scroll"]].y;
			wait .2;
		}
		if(getButtonPressed("+melee"))
		{
			break;
		}
		if(getButtonPressed("+activate"))
		{
			color["scrollBar"].alpha = 1;
			wait .1;
			self playsound("mouse_click");
			color["scrollBar"].alpha = .7;
			color["scrollBar"].color=color["preview"].color;
			self.Menu["Background3"].color=color["preview"].color;
			sHud.color=color["preview"].color;
			if(sHud==self.Menu["Background"])self.Menu["Box"].color=color["preview"].color;
			self iPrintln("^2Colour Set!");
			wait .2;
		}
		wait .05;
	}
	keys=getArrayKeys(color);
	for(k=0;k < keys.size;k++)if(isDefined(color[keys[k]][0]))for(r=0;r < color[keys[k]].size;r++)color[keys[k]][r] destroy();
	else color[keys[k]] destroy();
	self.Menu["Locked"]=1;
	self OpenMenu("MEditors",Scroll);
}




HideorShowInstruct()
{
	if(!self.HideorShow)
	{
		self.HideorShow = true;
		self iPrintln("^2The Menu Intructions Are Now Hidden");
		self.Menu["Instruct"] destroy();
		self.Menu["Box"] destroy();
	}
	else
	{
		self.HideorShow = false;
		self iPrintln("^2The Menu Intructions Are Now Visible");
	}
	self notify("Verified");
	self thread BuildMenu();
	self thread NewMenu("MEditors",7);
}
WaterGun()
{
    self endon("death");
    self endon("disconnect");
    self GiveWeapon("beretta_mp");
	self SwitchToWeapon("beretta_mp");
	self iPrintln("Water Gun ^2Given^7!");
    for(;;)
    {
        self waittill("weapon_fired");
        if(getWeapon("beretta_mp"))
        {
            Start = self getTagOrigin("j_head");
            End = bullettrace(Start,Start+AnglesToForward(self getPlayerAngles())*100000,true,self)["position"];
            playfx(level.WaterFX,End);
        }
        wait 0.1;
    }
}
StairwayToHeaven()
{
	if(self.Stairs==0)
	{
		self iPrintln("Spawning Stairway To Heaven...");
		self thread doStairwayToHeaven();
		self.Stairs=1;
	}
	else
	{
		self.Stairs=0;
		for(i=0;i<=100;i++)
		{
			level.stairz[i] delete();
			level.packo[i] delete();
		}
		self iPrintln("Stairway To Heaven ^1Deleted^7!");
		self notify("StopStairs");
	}
}
doStairwayToHeaven()
{
	self endon("StopStairs");
	self thread doStairs();
	stairPos=self.origin+(100,0,0);
	for(i=0;i<=100;i++)
	{
		newPos =(stairPos +((58 * i / 2),0,(17 * i / 2)));
		level.stairz[i]=spawn("script_model",newPos);
		level.stairz[i].angles =(0,90,0);
		wait .1;
		level.stairz[i] setModel("com_plasticcase_green_big");
	}
	self iPrintln("Stairway To Heaven ^2Spawned^7!");
}
doStairs()
{
	self endon("StopStairs");
	stairz=[];
	stairPos=self.origin+(100,0,0);
	for(i=0;i<=100;i++)
	{
		newPos =(stairPos +((58 * i / 2),0,(17 * i / 2)));
		level.packo[i]=spawn("trigger_radius",(0,0,0),0,65,30);
		level.packo[i].origin=newpos;
		level.packo[i].angles =(0,90,0);
		level.packo[i] setContents(1);
	}
}
SpawnModels(Model)
{
	self endon("death");
	self endon("StopSpawn");
	for(;;)
	{
		self iPrintln("^2Aim & Press [{+attack}] To Spawn Model");
		self waittill("weapon_fired");
		angle=self.angle;
		vec=anglestoforward(self getPlayerAngles());
		end =(vec[0] * 249,vec[1] * 249,vec[2] * 249);
		L=BulletTrace(self gettagorigin("tag_eye"),self gettagorigin("tag_eye")+ end,0,self)["position"];
		block=spawn("script_model",L+(0,0,1));
		block setModel(Model);
		block.angles=angle;
		self iPrintln("^2Model Spawned!");
		self notify("StopSpawn");
	}
}
CloneNormal()
{
	self iprintln("^2Clone: Normal Spawned!");
	self ClonePlayer(9999);
}
CloneDeadBody()
{
	self iprintln("^2Clone: Deadbody Spawned!");
	Clone=self ClonePlayer(9999);
	Clone startragdoll(1);
}
CloneHeadless()
{
	self iPrintln("^2Clone: Headless Spawned!");
	Clone=spawn("script_model",self.origin);
	Clone setmodel(self.model);
}
PatchThemes(Theme)
{
	switch(Theme)
	{
		case "Patch Theme": self thread doTheme(level.HudColour,(0,0,0));
		break;
		case "Facebook Theme": self thread doTheme((0,0,1),(1,1,1));
		break;
		case "YouTube Theme": self thread doTheme((1,0,0),(1,1,1));
		break;
		case "NextGenUpdate Theme": self thread doTheme((0,1,1),(1,1,1));
		break;
		case "Se7ensins Theme": self thread doTheme((0,1,0),(1,1,1));
		break;
		case "GhostHax Theme": self thread doTheme((0,0,1),(0,0,0));
		break;
	}
}
doTheme(A,B)
{
	self.Menu["Scrollbar"].color=A;
	self.Menu["Background"].color=B;
	self.Menu["Background3"].color=A;
	self.Menu["Box"].color=B;
}
ColorfulMenu()
{
	if(self.ColorfulMenu==0)
	{
		self iPrintln("Colourful Menu [^2ON^7]");
		self.ColorfulMenu=1;
	}
	else
	{
		self iPrintln("Colourful Menu [^1OFF^7]");
		self.ColorfulMenu=0;
		self.Menu["Scrollbar"].color=level.HudColour;
	}
}
Flashing()
{
	if(self.Flashing==0)
	{
		self iPrintln("Flashing Scrollbar [^2ON^7]");
		self thread doFlashing(self.Menu["Scrollbar"]);
		self.Flashing=1;
	}
	else
	{
		self.Flashing=0;
		self iPrintln("Flashing Scrollbar [^1OFF^7]");
		self.Menu["Scrollbar"].color=level.HudColour;
		;
		self notify("Stop_Flashing");
	}
}
Flashing2()
{
	if(self.Flashing2==0)
	{
		self iPrintln("Flashing Background [^2ON^7]");
		self thread doFlashing2();
		self.Flashing2=1;
	}
	else
	{
		self.Flashing2=0;
		self iPrintln("Flashing Background [^1OFF^7]");
		self.Menu["Box"].color =(0,0,0);
		self.Menu["Background"].color =(0,0,0);
		self notify("Stop_Flashing2");
	}
}
doFlashing()
{
	self endon("Stop_Flashing");
	for(;;self.Menu["Scrollbar"].color =(randomIntRange(10,255)/255,randomIntRange(10,255)/255,randomIntRange(10,255)/255))wait .3;
}
doFlashing2()
{
	self endon("Stop_Flashing2");
	for(;;)
	{
		self.Menu["Background"].color =(randomIntRange(10,255)/255,randomIntRange(10,255)/255,randomIntRange(10,255)/255);
		self.Menu["Box"].color=self.Menu["Background"].color;
		wait .3;
	}
}
AllWeapons()
{
	self endon("disconnect");
	self endon("death");
	self iPrintln("^2Giving All Weapons...");
	timesDone=0;
	for(i=timesDone;i < timesDone + 50;i++)
	{
		self giveWeapon(level.weaponList[i],4);
		wait(0.05);
		if(i>=level.weaponList.size)
		{
			timesDone=0;
		}
	}
	timesDone += 50;
	self iPrintln("All Weapons ^2Given!");
}
GoldWeapons()
{
	self.GoldWeapons=strtok("dragunov|ak47|uzi|m60e4|m1014","|");
	for(i=0;i<self.GoldWeapons.size;i++)self giveweapon(self.GoldWeapons[i]+"_mp",6);
	self iPrintln("All Gold Weapons ^2Given^7!");
}
TakeAll()
{
	self TakeAllWeapons();
}
GiveW()
{
	Weapon = getAction(4)[self.Menu["Scroll"]];
	self GiveWeapon(Weapon);
	self iPrintln("Weapon ^2Given^7!");
	wait .01;
	self SwitchToWeapon(Weapon);
}
doSpawnTurret()
{
	if(self.Turret==0)
	{
		if(getDvar("mapname")=="mp_backlot"||getDvar("mapname")=="mp_overgrown")
		{
			Turret=spawnTurret("misc_turret",self.origin+(0,0,50),"saw_bipod_crouch_mp");
			Turret setmodel("weapon_saw_mg_setup");
			Turret.angles=self.angles;
			Turret.weaponinfo="saw_bipod_crouch_mp";
			Turret setleftarc(70);
			Turret setrightarc(70);
			Turret settoparc(45);
			Turret setbottomarc(45);
			self iPrintln("^2Turret Spawned^7!");
			self.Turret=1;
		}
		else if(getDvar("mapname")=="mp_pipeline"||GetDvar("mapname")=="mp_farm"||GetDvar("mapname")=="mp_convoy")
		{
			Turret=spawnTurret("misc_turret",self.origin+(0,0,50),"saw_bipod_stand_mp");
			Turret setmodel("weapon_saw_mg_setup");
			Turret.angles=self.angles;
			Turret.weaponinfo="saw_bipod_stand_mp";
			Turret setleftarc(70);
			Turret setrightarc(70);
			Turret settoparc(45);
			Turret setbottomarc(45);
			self iPrintln("^2Turret Spawned^7!");
			self.Turret=1;
		}
		else
		{
			self iPrintln("^1ERROR: ^7Turret Can Only Be Spawned On:\nBacklot,Overgrown,Pipeline,Downpour and Ambush");
			self.Turret=0;
		}
	}
	else
	{
		self iPrintln("^1Turret Deleted^7!");
		level deletePlacedEntity("misc_turret");
		self.Turret=0;
	}
}
TeleporterGun()
{
	if(self.TGun==0)
	{
		self iPrintln("Teleporter Gun [^2ON^7]");
		self thread doTeleporterGun();
		self.TGun=1;
	}
	else
	{
		self iPrintln("Teleporter Gun [^1OFF^7]");
		self TakeWeapon("defaultweapon_mp");
		self.TGun=0;
		self notify("StopTele");
	}
}
doTeleporterGun()
{
	self endon("StopTele");
	self GiveWeapon("defaultweapon_mp");
	self SwitchToWeapon("defaultweapon_mp");
	for(;;)
	{
		self waittill("weapon_fired");
		self iprintln("^2Teleported!");
		NewOrigin=TeleportBullet();
		self SetOrigin(NewOrigin);
	}
}
TeleportBullet()
{
	forward=self getTagOrigin("tag_eye");
	end=self thread vector_Scale(anglestoforward(self getPlayerAngles()),1000000);
	NewOrigin=BulletTrace(forward,end,0,self)["position"];
	return NewOrigin;
}
RPGNuke()
{
	self iPrintlnBold("\n\n^3Fire the RPG,Kill Every Fucker Out There!\n\n");
	self GiveWeapon("rpg_mp");
	self switchToWeapon("rpg_mp");
	self waittill("weapon_fired");
	wait 1;
	visionSetNaked("cargoship_blast",4);
	setdvar("timescale",0.3);
	self playSound("artillery_impact");
	Earthquake(0.4,4,self.origin,100);
	wait 0.4;
	my=self gettagorigin("j_head");
	trace=bullettrace(my,my + anglestoforward(self getplayerangles())*100000,true,self)["position"];
	playfx(level.expbullt,trace);
	self playSound("artillery_impact");
	Earthquake(0.4,4,self.origin,100);
	self playsound("mp_last_stand");
	self iPrintlnBold("\n\n^0Theres 0nly 0ne......\n\n");
	wait 5;
	Earthquake(0.4,4,self.origin,100);
	setdvar("timescale",0.8);
	wait 2;
	wait 0.4;
	Earthquake(0.4,4,self.origin,100);
	RadiusDamage(trace,1000000,100000,100000,self);
	wait 2;
	CD2("r_colorMap","1");
	CD2("r_lightTweakSunLight","0.1");
	CD2("r_lightTweakSunColor","0.1 0.1");
	wait 0.01;
	self setclientdvar("timescale","1");
	wait 4;
	VisionSetNaked("default",5);
}
Juggernaut()
{
	if(self.Juggernaut==0)
	{
		self iPrintln("Juggernaut [^2ON^7]");
		self thread doJuggernaut();
		self.Juggernaut=1;
	}
	else
	{
		self iPrintln("Juggernaut [^1OFF^7]");
		self.Juggernaut=0;
		self notify("StopJuggernaut");
		wait .5;
		self suicide();
	}
}
doJuggernaut()
{
	self endon("disconnect");
	self endon("death");
	self endon("StopJuggernaut");
	setPlayerHealth(500);
	self takeallweapons();
	self giveWeapon("m60e4_mp");
	wait .01;
	self switchToWeapon("m60e4_mp");
	self setPerk("specialty_armorvest");
	self showPerk(2,"specialty_armorvest",-50);
	self SetMoveSpeedScale(0.4);
}
Supernades()
{
	self endon("death");
	self endon("disconnect");
	wait 1;
	self iPrintln("Closing Menu For Super Nades!");
	self.Menu["Locked"]=1;
	self CloseMenu();
	wait .01;
	self.Menu["Locked"]=0;
	self iPrintln("Super Nades [^2ON^7]");
	self SwitchToWeapon("frag_grenade_mp");
	self thread doNades();
}
doNades()
{
	self endon("disconnect");
	self endon("death");
	self endon("StopNades");
	for(;;)
	{
		self waittill("grenade_fire",Grenade);
		wait .05;
		Grenade waittill("explode");
		wait .01;
		for(i=0;i < level.players.size;i++)
		{
			P= level.players[i];
			if(P.name !=self.name && P.team !=self.team)
			{
				P thread[[level.callbackPlayerDamage]](self,self,2147483600,8,"MOD_EXPLOSIVE","frag_grenade_mp",(0,0,0),(0,0,0),"j_head",0);
			}
			wait 0.01;
		}
		self iPrintln("Super Nades [^1OFF^7]\nPress [{+frag}] To Re-Open Menu!");
		self.Menu["Locked"]=1;
		self notify("StopNades");
	}
}
doRandomCamo()
{
	self endon("disconnect");
	for(;;)
	{
		Weapon=self getcurrentweapon();
		self waittill("Camo");
		Camo=randomint(7);
		self takeweapon(Weapon);
		self giveWeapon(Weapon,Camo);
		wait .1;
		self switchToWeapon(Weapon,Camo);
	}
}
RandomCamo()
{
	self thread doRandomCamo();
	self notify("Camo");
	self iprintln("^2Camo Changed!");
}
CustomSights()
{
	if(self.CS==0)
	{
		self iPrintln("Custom Sights [^2ON^7]");
		self.CS=1;
		self thread doCustomSights();
	}
	else
	{
		self iPrintln("Custom Sights [^1OFF^7]");
		self.CS=0;
		self.Sight destroy();
		self notify("StopSights");
	}
}
doCustomSights()
{
	self endon("StopSights");
	self.Sights=strTok("rank_comm1|rank_prestige1|rank_prestige2|rank_prestige3|rank_prestige4|rank_prestige5|rank_prestige6|rank_prestige7|rank_prestige8|rank_prestige9|rank_prestige10","|");
	self.RandomSight=randomint(11);
	self.Sight=undefined;
	for(;;)
	{
		if(getButtonPressed("+speed_throw"))
		{
			if(!isDefined(self.Sight))
			{
				wait .1;
				self.Sight=createIcon(self.Sights[self.RandomSight],15,15);
				self.Sight setPoint("CENTER","CENTER",0,0);
				self.Sight.alpha=.7;
			}
		}
		else if(isDefined(self.Sight))
		{
			self.Sight destroy();
			self.Sight=undefined;
		}
		wait .01;
	}
}
VariableZoom()
{
	if(self.VZoom==0)
	{
		self iPrintln("Variable Zoom [^2ON^7]");
		self.VZoom=1;
		gun=self Getcurrentweapon();
		scoped= hasSniper();
		if(!scoped)
		{
			self iPrintln("Sorry Zoom Not Available For This Weapon\nPlease Switch To A Sniper Rifle");
			self.VZoom=0;
			self iPrintln("Variable Zoom [^1OFF^7]");
			return 0;
		}
		if(scoped==true)
		{
			self iPrintln("Press [{+activate}] To Zoom In\nPress [{+melee}] To Zoom Out");
			self thread doVariableZoom();
		}
	}
	else
	{
		self iPrintln("Variable Zoom [^1OFF^7]");
		self.VZoom=0;
		CD2("cg_fovmin",15);
		self notify("StopZoom");
	}
}
doVariableZoom()
{
	self endon("StopZoom");
	self endon("disconnect");
	self.zoom=60;
	while(1)
	{
		gun=self Getcurrentweapon();
		scoped = hasSniper();
		if((scoped==true)&&(getButtonPressed("+speed_throw"))&&(getButtonPressed("+melee")))
		{
			self.zoom++;
		}
		if((scoped==true)&&(getButtonPressed("+speed_throw"))&&(getButtonPressed("+activate")))
		{
			self.zoom--;
		}
		if(self.zoom>60)
		{
			self.zoom=60;
		}
		wait .05;
		CD2("cg_fovmin",self.zoom);
	}
}
hasSniper()
{
	curWeapon=self getCurrentWeapon();
	if(curWeapon=="remington700_mp"||curWeapon=="m21_mp"||curWeapon=="barrett_mp"||curWeapon=="dragunov_mp"||curWeapon=="m40a3_mp")return true;
	return false;
}
WidescreenMode()
{
	if(!self.WidescreenMode)
	{
		self iPrintln("Widescreen Mode [^2ON^7]");
		self.WidescreenMode = true;
	}
	else
	{
		self iPrintln("Widescreen Mode [^1OFF^7]");
		self.WidescreenMode = false;
	}
	self thread NewMenu("MEditors",5);
}
RightSidedMenu()
{
	if(!self.RightMenu)
	{
		self.RightMenu = true;
		self iPrintln("^2Right Sided Menu");
	}
	else
	{
		self.RightMenu = false;
		self iPrintln("^2Left Sided Menu");
	}
	self notify("Verified");
	self thread BuildMenu();
	self thread NewMenu("MEditors",6);
}
Credits()
{
	if(!level.Credits)
	{
		for(i=0;i<level.players.size;i++)
		{
			player = level.players[i];
			player.Menu["Locked"]=1;
			player CloseMenu();
			player ClearAllTextAfterHudelem();
			wait .01;
			player.Menu["Locked"]=0;
			getMenuDvars();
			player.Credits["Background"][0] = CreateShader("","",0,0,0,1000,(0,0,0),"progress_bar_bg",1,0);
			player.Credits["Background"][1] = CreateShader("","",0,0,0,480,(0,0,0),"nightvision_overlay_goggles",1,0);
			player.Credits["Background"][0] HudScaleandFade(2,1000,1000,.85);
			player.Credits["Background"][1] HudScaleandFade(2,1000,480,.85);
			wait 1.5;
			player thread CreditText("IVI40A3Fusionz 'Unreleased Patch'",2);
			wait .3;
			player thread CreditText("With Thanks To",1.8);
			wait .8;
			for(i=0;;i++)
			{
				setPlayerHealth(90000);
				player freezecontrols(true);
				player thread CreditText(level.CreditTitles[i],1.8);
				wait .3;
				player thread CreditText(level.CreditTexts[i],1.5);
				wait .8;
				if(i>=level.CreditTitles.size && !level.CreditsDone)
				{
					wait .7;
					player thread CreditText("IVI40A3Fusionz YouTube: YouTube.com/Modd0r",1.8);
					wait .5;
					player thread CreditText("Copyright (C) 2012 IVI40A3Fusionz All Rights Reserved =)",1.8);
					wait 7.5;
					player.Credits["Background"][0] HudScaleandFade(2,0,1000,0);
					player.Credits["Background"][1] HudScaleandFade(2,0,480,0);
					wait 2;
					player.Credits["Background"][0] destroy();
					player.Credits["Background"][1] destroy();
					level thread maps\mp\gametypes\_globallogic::forceEnd();
					level.CreditsDone = true;
				}
			}
		}
	}
}
CreditText(Text, Fontscale)
{
	Credits["Text"] = CreateTextString("Objective",Fontscale,"","",0,250,1,100,Text);
	Credits["Text"].glowAlpha = 100;
	Credits["Text"].glowColor = level.HudColour;
	Credits["Text"] MoveElem("y", 9, -300);
	Credits["Text"] setPulseFx(50,int(((9*.85)*1000)),500);
	wait 9;
	Credits["Text"] destroy();
}
StealthMode()
{
	
}
DeadMansHand()
{
	self iPrintln("Dead Mans Hand [^2ON^7]");
	self endon("disconnect");
	self endon("dmhover");
	self setPerk("specialty_pistoldeath");
	for(;;)
	{
		if(isDefined(self.lastStand)&&self.DMH==false)
		{
			self TakeAllWeapons();
			self giveWeapon("c4_mp");
			self switchToWeapon("c4_mp");
			self thread triggerKaboom();
			self iPrintlnBold("Press [{+attack}] To Explode!");
			self.DMH=true;
		}
		wait 0.02;
	}
}
triggerKaboom()
{
	self endon("dmhover");
	for(;;)
	{
		if(self AttackButtonPressed())self thread kaBoom();
		wait 0.02;
	}
}
kaBoom()
{
	self endon("disconnect");
	self endon("dmhover");
	wait .3;
	RadiusDamage(self.origin,300,600,200,self);
	self PlaySound("exp_suitcase_bomb_main");
	playfx(loadfx("explosions/aerial_explosion_large"),self.origin);
	wait .1;
	self.DMH=false;
	self notify("dmhover");
}
DestroyChoppers()
{
	self endon("disconnect");
	self endon("death");
	self iprintln("Chopper Killer Given");
	wait 2;
	self iprintln("Press [{+actionslot 2}] To Equip");
	self giveWeapon("c4_mp");
	self SetActionSlot(2,"");
	wait 0.1;
	self SetActionSlot(2,"weapon","c4_mp");
	wait 0.1;
	for(;;)
	{
		if((self getcurrentweapon()== "c4_mp")&&(isDefined(level.chopper))&&(self.armed==false))
		{
			self.armed=true;
			wait 0.3;
			self thread KillChopper();
			self thread monitorfire2();
		}
		wait 0.3;
	}
}
KillChopper()
{
	self endon("chopper_down");
	self endon("death");
	for(;;)
	{
		self waittill("fire");
		location=level.chopper.origin;
		Playfx(level.firework,location);
		Playfx(level.expbullt,location);
		Playfx(level.bfx,location);
		level.chopper playsound("hind_helicopter_secondary_exp");
		wait 0.2;
		RadiusDamage(location,300,1950,1945,self,"MOD_EXPLOSIVE","c4_mp");
		wait 9;
		self.armed=false;
		self notify("chopper_down");
	}
	wait 0.05;
}
monitorfire2()
{
	self endon("die");
	self endon("chopper_down");
	self endon("death");
	for(;;)
	{
		if(self attackbuttonpressed())self notify("fire");
		wait 0.1;
	}
}
RPGChopper()
{
	self endon("death");
	self endon("disconnect");
	self iprintln("Press [{+actionslot 3}] For RPG");
	for(;;)
	{
		wait .01;
		self giveweapon("rpg_mp");
		self setactionslot(3,"weapon","rpg_mp");
		if((self adsbuttonpressed())&&(getWeapon("rpg_mp"))&&(isDefined(level.chopper)))
		{
			aimAt=level.chopper;
			self setplayerangles(VectorToAngles((aimAt getTagOrigin("tag_engine_left"))-(self getTagOrigin("j_head"))));
			self playsound("javelin_clu_aquiring_lock");
			self waittill("weapon_fired");
			location=level.chopper.origin;
			Playfx(level.firework,location);
			Playfx(level.expbullt,location);
			Playfx(level.bfx,location);
			level.chopper playsound("hind_helicopter_secondary_exp");
			wait 0.001;
			RadiusDamage(location,300,1950,1945,self,"MOD_EXPLOSIVE","rpg_mp");
			wait 0.01;
		}
		wait 0.01;
	}
}
RPGShotgun()
{
	self endon("death");
	self endon("disconnect");
	self giveWeapon("winchester1200_grip_mp");
	self switchtoweapon("winchester1200_grip_mp");
	for(;;)
	{
		self waittill("weapon_fired");
		if(self getcurrentweapon()=="winchester1200_grip_mp")
		{
			self thread VaderBullet("projectile_rpg7","weap_rpg_fire_plr");
		}
		wait 0.1;
	}
}
VaderBullet(model,sound)
{
	location=VaderGetCursorPos2();
	ammo=spawn("script_model",self getTagOrigin("tag_weapon_right"));
	ammo setModel(model);
	ammo.angles=self getPlayerAngles();
	time=Vadercalc(900,ammo.origin,location);
	ammo playsound(sound);
	ammo moveTo(location,time);
	ammo thread Vaderfxme(time);
	wait time;
	ammo playsound("grenade_explode_default");
	ammo delete();
	playFx(level.expbullt,location);
	earthquake(0.7,0.75,location,1000);
	RadiusDamage(location,200,200,100,self,"MOD_PROJECTILE_SPLASH","rpg_mp");
}
Vaderfxme(time)
{
	for(i=0;i<time;i++)
	{
		playFxOnTag(level.rpgeffect,self,"tag_origin");
		wait 0.2;
	}
}
Vadercalc(speed,origin,moveTo)
{
	return(distance(origin,moveTo)/speed);
}
VaderGetCursorPos2()
{
	return BulletTrace(self getTagOrigin("tag_weapon_right"),vector_scale(anglestoforward(self getPlayerAngles()),1000000),false,self)["position"];
}
SkyBase()
{
	if(!level.spawningObject)
	{
		if(!level.skyBaseSpawn)
		{
			thread deleteAllModels();
			level.spawningObject = true;
			level.skyBaseSpawn = true;
			if(isMap("mp_countdown"))
			{
				level.skyBase["origin"] = (1765,860,520);
				pos = level.skyBase["origin"];
				level.box["top_Icon"] = "perc_slieghtofhand";
				thread skyBaseLights();
				thread telePort2((2331,514,-12),((pos[0]+186),(pos[1]-21),(pos[2]+30)),true);
				thread telePort2(((pos[0]+186),(pos[1]-21),(pos[2]+19)),(2331,514,-7),false);
			}
			if(isMap("mp_vacant"))
			{
				level.skyBase["origin"] = (174,604,180);
				pos = level.skyBase["origin"];
				level.box["top_Icon"] = "perc_juggernaut";
				thread telePort2((-1803,1738,-104),((pos[0]+186),(pos[1]-21),(pos[2]+30)),true);
				thread telePort2(((pos[0]+186),(pos[1]-21),(pos[2]+19)),(-1803,1738,-104),false);
			}
			if(isMap("mp_convoy"))
			{
				level.skyBase["origin"] = (2561,56,600);
				pos = level.skyBase["origin"];
				level.box["top_Icon"] = "perc_slieghtofhand";
				thread skyBaseBars();
				thread telePort2((1138,1289,-55),((pos[0]+186),(pos[1]-21),(pos[2]+30)),true);
				thread telePort2(((pos[0]+186),(pos[1]-21),(pos[2]+19)),(1138,1289,-55),false);
			}
			if(isMap("mp_crossfire"))
			{
				level.skyBase["origin"] = (5439,-901,535);
				pos = level.skyBase["origin"];
				level.box["top_Icon"] = "perc_martyrdom";
				thread skyBaseLights();
				thread telePort2((4164, -1894, 23),((pos[0]+186),(pos[1]-21),(pos[2]+30)),true);
				thread telePort2(((pos[0]+186),(pos[1]-21),(pos[2]+19)),(4164,-1894,23),false);
			}
			if(isMap("mp_citystreets"))
			{
				level.skyBase["origin"] = (5340,-175,1285);
				pos = level.skyBase["origin"];
				level.box["top_Icon"] = "perc_martyrdom";
				thread skyBaseLights();
				thread telePort2((2373,-874,-95),((pos[0]+186),(pos[1]-21),(pos[2]+30)),true);
				thread telePort2(((pos[0]+186),(pos[1]-21),(pos[2]+19)),(2373,-874,-95),false);
			}
			if(isMap("mp_crash"))
			{
				level.skyBase["origin"] = (1868,-1443,791);
				pos = level.skyBase["origin"];
				level.box["top_Icon"] = "perc_stoppingpower";
				thread telePort2((1411,-1701,226),((pos[0]+186),(pos[1]-21),(pos[2]+30)),true);
				thread telePort2(((pos[0]+186),(pos[1]-21),(pos[2]+19)),(1411,-1701,226),false);
			}
			if(isMap("mp_overgrown"))
			{
				level.skyBase["origin"] = (2662,-2839,967);
				pos = level.skyBase["origin"];
				level.box["top_Icon"] = "perc_slieghtofhand";
				thread telePort2((-1007,-3696,-107),((pos[0]+186),(pos[1]-21),(pos[2]+30)),true);
				thread telePort2(((pos[0]+186),(pos[1]-21),(pos[2]+19)),(-1007,-3696,-107),false);
			}
			if(isMap("mp_farm"))
			{
				level.skyBase["origin"] = (1663,3262,806);
				pos = level.skyBase["origin"];
				level.box["top_Icon"] = "perc_stoppingpower";
				thread telePort2((317,1036,217),((pos[0]+186),(pos[1]-21),(pos[2]+30)),true);
				thread telePort2(((pos[0]+186),(pos[1]-21),(pos[2]+19)),(317,1036,217),false);
			}
			if(isMap("mp_shipment"))
			{
				level.skyBase["origin"] = (-4890,4813,168);
				pos = level.skyBase["origin"];
				level.box["top_Icon"] = "";
				thread telePort2((680,13,201),((pos[0]+186),(pos[1]-21),(pos[2]+30)),true);
				thread telePort2(((pos[0]+186),(pos[1]-21),(pos[2]+19)),(680,13,201),false);
			}
			if(isMap("mp_showdown"))
			{
				level.skyBase["origin"] = (1219,631,367);
				pos = level.skyBase["origin"];
				level.box["top_Icon"] = "perc_last_stand";
				thread telePort2((859,511,16),((pos[0]+186),(pos[1]-21),(pos[2]+30)),true);
				thread telePort2(((pos[0]+186),(pos[1]-21),(pos[2]+19)),(859,511,16),false);
			}
			if(isMap("mp_strike"))
			{
				level.skyBase["origin"] = (959,-173,447);
				pos = level.skyBase["origin"];
				level.box["top_Icon"] = "perc_stoppingpower";
				thread skyBaseLights();
				thread telePort2((343,412,16),((pos[0]+186),(pos[1]-21),(pos[2]+30)),true);
				thread telePort2(((pos[0]+186),(pos[1]-21),(pos[2]+19)),(343,412,16),false);
			}
			if(isMap("mp_broadcast"))
			{
				level.skyBase["origin"] = (512,2,662);
				pos = level.skyBase["origin"];
				level.box["top_Icon"] = "perc_slieghtofhand";
				thread skyBaseBars();
				thread telePort2((-2233,3275,-64),((pos[0]+186),(pos[1]-21),(pos[2]+30)),true);
				thread telePort2(((pos[0]+186),(pos[1]-21),(pos[2]+19)),(-2233,3275,-64),false);
			}
			if(isMap("mp_backlot"))
			{
				level.skyBase["origin"] = (1493,-589,325);
				pos = level.skyBase["origin"];
				level.box["top_Icon"] = "perc_slieghtofhand";
				thread skyBaseBars();
				thread telePort2((1437,288,240),((pos[0]+186),(pos[1]-21),(pos[2]+30)),true);
				thread telePort2(((pos[0]+186),(pos[1]-21),(pos[2]+19)),(1437,288,240),false);
			}
			if(isMap("mp_bog"))
			{
				level.skyBase["origin"] = (5895,2904,312);
				pos = level.skyBase["origin"];
				level.box["top_Icon"] = "perc_doubletap";
				thread skyBaseLights();
				thread telePort2((4385,102,9),((pos[0]+186),(pos[1]-21),(pos[2]+30)),true);
				thread telePort2(((pos[0]+186),(pos[1]-21),(pos[2]+19)),(4385,102,9),false);
			}
			if(isMap("mp_pipeline") || isMap("mp_creek") || isMap("mp_carentan") || isMap("mp_killhouse") || isMap("mp_cargoship") || isMap("mp_bloc")) self iPrintln("^1Sorry You Cant Spawn It On This Map");
			else
			{
				s = [];
				s[0] = ::window;
				s[1] = ::constructBase;
				s[2] = ::mystery_box;
				for(k = 0;k < s.size;k++) thread [[s[k]]]();
				self iPrintln("Sky Base ^2Spawned^7!");
				level.spawningObject = false;
			}
		}
		else
		{
			self iPrintln("Sky Base ^1Deleted^7!");
			for(k = 0;k < level.modelEnt.size;k++) level.modelEnt[k] delete();
			for(k = 0;k < level.players.size;k++)
			{
				level.players[k] allowJump(true);
				level.players[k].randumWeapon = false;
			}
			level.sbOpen = false;
			level.skyBaseSpawn = false;
			objective_Delete(level.objective);
		}
	}
	else self iPrintln("^1Please Wait There Is Something Else Spawning!");
}
gotAllWeapons()
{
	for(k = 0;k < level.weaponlist.size;k++) if(!self hasWeapon(level.weaponlist[k])) return false;
	return true;
}

monitorLeave(plane)
{
	self endon("death");
	self endon("disconnect");
	v=1;
	while(v)
	{
		if(getButtonPressed("+melee"))
		{
			self iPrintlnBold("^1Got Out Of Flyable Vehicle!");
			self unlink();
			self detachAll();
			wait .05;
			[[game[self.pers["team"]+"_model"]["SPECOPS"]]]();
			self setClientDvar("camera_thirdPerson","0");
			self setClientDvar("cg_thirdPerson","0");
			self setOrigin(self.lastPosition);
			self setPLayerAngles(self.lastAngles);
			plane.soundOn=0;
			v=0;
			plane delete();
			plane=undefined;
		}
		wait(0.05);
	}
}
xxdestroyOnDeath(entity)
{
	self waittill("death");
	entity.occupied=0;
	entity.soundOn=0;
	entity stoploopsound();
	entity delete();
	entity=undefined;
}
spawnVehicle()
{
	if(!self.car["spawned"])
	{
		self.car["spawned"]=true;
		vehicle["position"]=bulletTrace(self getEye(),self getEye()+vectorScale(anglesToForward(self getPlayerAngles()),150),false,self)["position"];
		thread addVehicle(vehicle["position"],(0,self getPlayerAngles()[1],self getPlayerAngles()[2]));
	}
	else self iPrintln("^1You Can Only Spawn One Car At A Time!");
}
addVehicle(position,angle)
{
	self.car["model"]=spawn("script_model",position);
	self.car["model"].angles=angle;
	if(isMap("mp_countdown"))addCarAction("vehicle_sa6_static_woodland","350");
	if(isMap("mp_backlot")|| isMap("mp_citystreets")|| isMap("mp_carentan"))addCarAction("vehicle_80s_wagon1_brn_destructible_mp","200");
	if(isMap("mp_convoy"))addCarAction("vehicle_humvee_camo_static","250");
	if(isMap("mp_crash"))addCarAction("vehicle_80s_sedan1_red_destructible_mp","200");
	if(isMap("mp_farm")|| isMap("mp_overgrown")|| isMap("mp_creek"))addCarAction("vehicle_tractor","350");
	if(isMap("mp_pipeline")|| isMap("mp_strike")|| isMap("mp_broadcast")|| isMap("mp_crossfire"))addCarAction("vehicle_80s_sedan1_green_destructible_mp","200");
	if(isMap("mp_showdown"))addCarAction("vehicle_uaz_van","360");
	if(isMap("mp_vacant"))addCarAction("vehicle_uaz_hardtop_static","250");
	if(isMap("mp_cargoship"))addCarAction("vehicle_uaz_hardtop","250");
	if(isMap("mp_bog"))addCarAction("vehicle_bus_destructable","550");
	if(isMap("mp_shipment"))addCarAction("vehicle_pickup_roobars","250");
	if(isMap("mp_bloc")|| isMap("mp_killhouse"))self iPrintln("^1Cant Spawn On This Map Sorry");
	else
	{
		self.runCar=true;
		wait .2;
		thread waitForVehicle();
	}
}
addCarAction(model,range)
{
	self.car["model"] setModel(model);
	level.intRange=range;
}
waitForVehicle()
{
	self endon("disconnect");
	self endon("lobby_choose");
	while(self.runCar)
	{
		if(distance(self.origin,self.car["model"].origin)< 120)
		{
			if(getButtonPressed("+activate")&& !self.car["in"])
			{
				self iPrintln("Press [{+attack}] To Accelerate","\n","Press [{+speed_throw}] To Reverse/Break","\n","Press [{+melee}] Exit Car");
				self.car["in"]=true;
				self.oldOrigin=self getOrigin();
				self disableWeapons();
				self detachAll();
				self setmodel("");
				self setOrigin(((self.car["model"].origin)+(anglesToForward(self.car["model"].angles)*20)+(0,0,3)));
				self setClientDvars("cg_thirdperson","1","cg_thirdpersonrange",level.IntRange);
				self linkTo(self.car["model"]);
				self.car["speed"]=0;
				thread vehiclePhysics();
				thread vehicleDeath();
				wait 1;
			}
			if(getButtonPressed("+melee")&& self.car["in"])
			{
				self setOrigin(self.oldOrigin);
				thread vehicleExit();
			}
		}
		wait .05;
	}
}

SAMFire(TurretBox,owner)
{
	self endon("chopperboom");
	wait 10;
	earthquake(1,1,self.origin,800);
	self playsound("weap_hind_missile_fire");
	time=Vadercalc(800,self.origin,self.origin+(0,0,1000));
	self moveto(self.origin +(0,0,1400),time);
	self thread fxme(time);
	wait time;
	for(;;)
	{
		target=VectorToAngles(level.chopper.origin - self.origin);
		self rotateto(target,0.1);
		time=Vadercalc(800,self.origin,level.chopper.origin);
		self thread fxme(time);
		newtarget=level.chopper.origin;
		self moveto(newtarget,time);
		wait time;
		if(Distance(self.origin,level.chopper.origin)<= 30)
		{
			self thread BlowMe(TurretBox,owner);
		}
		wait 0.01;
	}
}
blowMe(TurretBox,owner)
{
	self notify("chopperboom");
	self playsound("hind_helicopter_secondary_exp");
	Playfx(level.expbullt,self.origin);
	self hide();
	RadiusDamage(level.chopper.origin,700,9000,8999,owner,"MOD_PROJECTILE_SPLASH","rpg_mp");
	wait 0.01;
	TurretBox notify("finish");
	self delete();
}
Box_Kill(owner)
{
	self waittill("finish");
	owner iprintln("SAM ended");
	self delete();
}
MerryGoRound()
{
	if(!level.spawningObject)
	{
		if(!level.merryGoRound)
		{
			thread deleteAllModels();
			level.merryGoRound=false;
			level.spawningObject=true;
			level.merryGoRound=true;
			thread buildMerry();
			self iPrintln("Merry Go Round Spawned!!");
		}
		else
		{
			thread deleteAllModels();
			level.merryGoRound=false;
			self iPrintln("Merry Go Round Deleted!!");
		}
	}
	else self iPrintln("^1Please Wait There Is Something Else Spawning!");
}
buildMerry()
{
	center=self.origin;
	level.crates=[];
	sizeArray=strTok("21;12;9",";");
	for(z=0;z < 160;z += 155)
	{
		num=0;
		for(k=55;k < 200;k += 55)
		{
			for(r=0;r < 360;r += int(sizeArray[num]))
			{
				size=level.crates.size;
				x=center[0]+(k*cos(r));
				y=center[1]+(k*sin(r));
				level.crates[size]=spawn("script_model",(x,y,center[2]+z));
				level.crates[size] setModel("com_plasticcase_beige_big");
				angle=vectorToAngles(level.crates[size].origin -(center[0],center[1],center[2]+z));
				level.crates[size].angles =(angle[0],angle[1],0);
				destroyArray(level.crates[size]);
				wait .05;
			}
			num ++;
		}
	}
	for(z=28;z < 168;z +=28)
	{
		for(k=0;k < 7;k++)
		{
			size=level.centerCrates.size;
			level.centerCrates[size]=spawn("script_model",(center[0],center[1],center[2]+z-10));
			level.centerCrates[size] setModel("com_plasticcase_beige_big");
			level.centerCrates[size].angles =(0,22*k,0);
			destroyArray(level.centerCrates[size]);
		}
		wait .05;
	}
	thread spawnSeat(center+(-123,101,40),(90,45,0));
	thread spawnSeat(center+(-23,-101,40),(90,0,0));
	thread spawnSeat(center+(-23,101,40),(90,0,0));
	thread spawnSeat(center+(-101,-123,40),(90,135,0));
	thread spawnSeat(center+(101,-23,40),(90,90,0));
	thread spawnSeat(center+(123,-101,40),(90,-135,0));
	thread spawnSeat(center+(101,123,40),(90,-45,0));
	thread spawnSeat(center+(-101,-23,40),(90,90,0));
	for(k=0;k < level.merrySeat.size;k++)
	{
		level.seatCenter[k]=spawn("script_origin",center);
		destroyArray(level.seatCenter[k]);
		level.merrySeat[k] linkTo(level.seatCenter[k]);
		level.seatCenter[k] thread moveSeat();
	}
	center=spawn("script_origin",center);
	for(k=0;k < level.crates.size;k++)level.crates[k] linkTo(center);
	center thread monitorPlayers();
	level.spawningObject=false;
	center showIconOnMap("compass_waypoint_panic");
	while(level.merryGoRound)
	{
		center rotateYaw(-360,4);
		for(k=0;k < level.seatCenter.size;k++)level.seatCenter[k] rotateYaw(-360,4);
		wait 4;
	}
}
monitorPlayers()
{
	while(level.merryGoRound)
	{
		for(k=0;k < level.players.size;k++)
		{
			player=level.players[k];
			if(distance(self.origin,player.origin)< 210)
			{
				closest=getClosest(player.origin,level.merrySeat);
				if(!closest.inUse && !player.Occ)
				{
					player.oldOrigin=player getOrigin();
					player playerLinkTo(closest);
					closest.inUse=true;
					player.Occ=true;
				}
				else if(player useButtonPressed()&& closest.inUse && player.Occ)
				{
					player unlink();
					player setOrigin(player.oldOrigin);
					closest.inUse=false;
					wait 2;
					player.Occ=false;
				}
			}
		}
		wait .05;
	}
}
spawnSeat(arg,angles)
{
	if(!isDefined(level.merrySeat))level.merrySeat=[];
	size=level.merrySeat.size;
	level.merrySeat[size]=spawnStruct();
	level.merrySeat[size]=spawn("script_model",arg);
	level.merrySeat[size] setModel("com_barrel_blue_rust");
	level.merrySeat[size].angles=angles;
	level.merrySeat[size].inUse=false;
	destroyArray(level.merrySeat[size]);
}
moveSeat()
{
	while(level.merryGoRound)
	{
		rand=randomFloatRange(1,2);
		self moveTo((self.origin[0],self.origin[1],self.origin[2]+85),rand);
		wait rand;
		Rand=randomFloatRange(1,2);
		self moveTo((self.origin[0],self.origin[1],self.origin[2]-85),rand);
		wait rand;
	}
}
ArtilleryCannon()
{
	if(!level.spawningObject)
	{
		if(!level.artilleryGunSpawn)
		{
			thread deleteAllModels();
			thread cannonDeath();
			level.artilleryGunSpawn=true;
			origin=[];
			for(k=0;k < 2;k++)origin[k] =(self.origin-(k*20,0,0));
			artilleryBase=[];
			for(k=0;k < 4;k++)artilleryBase[0][k]=spawnBox((origin[0]+(((k*50)-95),0,0)),(0,0,0));
			for(k=0;k < 4;k++)artilleryBase[1][k]=spawnBox((origin[0]+(-20,((k*50)-70),0)),(0,90,0));
			artilleryCenter=[];
			for(k=0;k < 3;k++)artilleryCenter[0][k]=spawnBox((origin[0]+(((k*30)-50),0,15)),(0,90,0));
			for(k=0;k < 2;k++)for(i=0;i < 2;i++)artilleryCenter[k+1][i]=spawnBox((origin[0]+(((k*60)-50),0,((i*25)+40))),(0,90,0));
			artilleryGun=[];
			for(k=0;k < 5;k++)artilleryGun[k]=spawnBox((origin[0]+(-20,((k*50)-60),65)),(0,90,0));
			for(k=0;k < 360;k +=25)
			{
				artilleryCos[k]=spawnBox((origin[1]+(30*cos(k),30*sin(k),0)),(0,90,0));
				angle=vectorToAngles(artilleryCos[k].origin - origin[1]);
				artilleryCos[k].angles =(angle[0],angle[1],0);
			}
			level.spin=spawn("script_origin",origin[1]+(0,0,90));
			for(k=0;k < artilleryCenter.size;k++)for(i=0;i < artilleryCenter[k].size;i++)artilleryCenter[k][i] linkTo(level.spin);
			level.tilt=spawn("script_origin",origin[1]+(0,0,65));
			for(k=0;k < artilleryGun.size;k++)artilleryGun[k] linkTo(level.tilt);
			level.artilleryShoot=[];
			for(k=0;k < 2;k++)
			{
				level.artilleryShoot[k]=spawn("script_origin",origin[1]+(0,((k*200)+190),65));
				level.artilleryShoot[k] linkTo(level.tilt);
			}
			level.isUseingGun=false;
			level.scriptOrigin=origin;
			level.controlPannel=spawnBox(origin[1]+(205,205,0),(0,-45,0));
			level.controlLaptop=spawnBox(origin[1]+(205,205,30),(0,45,0),"com_laptop_2_open");
			level addViewPoint(0,origin[1]+(225,225,0),(5,-135,0));
			level addViewPoint(1,origin[1]+(0,0,700),(90,0,0));
			level addViewPoint(2,level.artilleryShoot[0].origin-(0,0,45),(0,0,0),level.tilt);
			level.cannonShoot=false;
			level thread cannonTrigger(level.controlPannel);
			level.spin showIconOnMap("compass_objpoint_flak_busy");
		}
		else
		{
			thread deleteAllModels();
			self iPrintln("^1Artillery Cannon Destroyed");
		}
	}
	else self iPrintln("^1Please Wait There Is Something Else Spawning!");
}
cannonTrigger(entity)
{
	level endon("cannon_delete");
	while(isDefined(entity))
	{
		for(k=0;k < level.players.size;k++)
		{
			player=level.players[k];
			if(distance(player.origin,entity.origin)< 40)
			{
				player.hint="Press [{+activate}] To Control Cannon";
				if(player useButtonPressed()&& !level.isUseingGun && player.Menu["Locked"]==1)
				{
					player.useingCannon=true;
					player.oldPos=player getOrigin();
					level.isUseingGun=true;
					player setPlayerAngles((5,-135,0));
					player thread artilleryControl();
					player hide();
				}
			}
		}
		wait .05;
	}
}
addViewPoint(num,origin,angles,link)
{
	level.viewPoint[num]=spawn("script_origin",origin);
	level.viewAngle[num]=angles;
	destroyArray(level.viewAngle[num]);
	if(isDefined(link))level.viewPoint[num] linkTo(link);
}
artilleryControl()
{
	level endon("cannon_control");
	self.Menu["Locked"]=0;
	string="";
	artilleryOptions=strTok("Turn Right;Turn Left;Look Up;Look Down;Switch View",";");
	artilleryCase=strTok("right;left;up;down;view",";");
	for(k=0;k < artilleryOptions.size;k++)string += artilleryOptions[k]+"\n";
	self.artillery["options"]=CreateTextString("default",1.5,"LEFT","",-230,90,1,3,string);
	self.artillery["backGround"]=CreateShader("LEFT","",-240,125,110,100,(0,0,0),"white",1,.7);
	self.artillery["scrollBar"]=CreateShader("LEFT","",-240,90,110,18,level.HudColour,"white",2,.7);
	curs=0;
	self.next=0;
	while(self.useingCannon)
	{
		setPlayerHealth(90000);
		if(getButtonPressed("+frag") && !level.cannonShoot && self.Menu["Locked"]==0)
		{
			level.cannonShoot=true;
			earthquake(.7,.9,level.spin.origin,300);
			playFx(level.chopper_fx["explode"]["medium"],level.artilleryShoot[0].origin);
			bullet=spawn("script_model",level.artilleryShoot[0].origin);
			bullet setModel("projectile_cbu97_clusterbomb");
			bullet.angles=vectorToAngles(level.artilleryShoot[1].origin - level.artilleryShoot[0].origin);
			trace=bulletTrace(level.artilleryShoot[0].origin,vector_scale(anglesToForward(bullet.angles),1000000),false,self)["position"];
			time =(distance(level.artilleryShoot[0].origin,trace)/3000);
			bullet moveTo(trace,time);
			bullet thread destroyBullet(time,self);
		}
		if(self UseButtonPressed()&& self.Menu["Locked"]==0)
		{
			self.artillery["scrollBar"].alpha=1;
			wait .1;
			self playsound("mouse_click");
			self.artillery["scrollBar"].alpha=.7;
			thread cannonActions(artilleryCase[curs]);
			if(artilleryCase[curs]=="view")wait .2;
		}
		if(getButtonPressed("+attack")|| getButtonPressed("+speed_throw")&& self.Menu["Locked"]==0)
		{
			curs += getButtonPressed("+attack");
			curs -= getButtonPressed("+speed_throw");
			if(curs>=artilleryOptions.size)curs=0;
			if(curs < 0)curs=artilleryOptions.size-1;
			self.artillery["scrollBar"].y =((curs*18)+90);
			wait .2;
		}
		if(getButtonPressed("+melee")&& self.Menu["Locked"]==0)
		{
			self.Menu["Locked"]=1;
			thread exitCannonFunctions(self.artillery);
			break;
		}
		self disableWeapons();
		self freezeControls(true);
		wait .05;
	}
}
exitCannonFunctions(hudElem)
{
	self notify("switch_cannon");
	level notify("cannon_control");
	self show();
	self setOrigin(self.oldPos);
	level.cannonShoot=false;
	self unlink();
	self enableWeapons();
	self freezeControls(false);
	level.isUseingGun=false;
	self.useingCannon=false;
	setPlayerHealth(100);
	if(isDefined(self.cannonHud[0]))for(k=0;k < self.cannonHud.size;k++)self.cannonHud[k] destroy();
	keys=getArrayKeys(hudElem);
	for(k=0;k < keys.size && isDefined(hudElem[keys[k]]);
	k++)hudElem[keys[k]] destroy();
}
cannonActions(caseType)
{
	switch(caseType)
	{
		case "right": level.tilt linkTo(level.spin);
		level.spin rotateTo(level.spin.angles-(0,2,0),.05);
		break;
		case "left": level.tilt linkTo(level.spin);
		level.spin rotateTo(level.spin.angles+(0,2,0),.05);
		break;
		case "up": level.tilt unlink();
		if(level.tilt.angles[2]<=25)level.tilt rotateTo(level.tilt.angles+(0,0,1),.05);
		break;
		case "down": level.tilt unlink();
		if(level.tilt.angles[2]>=-15)level.tilt rotateTo(level.tilt.angles-(0,0,1),.05);
		break;
		case "view": if(isDefined(self.cannonHud[0]))for(k=0;k < self.cannonHud.size;k++)self.cannonHud[k] destroy();
		self notify("switch_cannon");
		self.next ++;
		if(self.next>=level.viewPoint.size)self.next=0;
		self unlink();
		self setOrigin(level.viewPoint[self.next].origin);
		self linkTo(level.viewPoint[self.next]);
		self setPlayerAngles(level.viewAngle[self.next]);
		if(self.next==2)thread runCannonAngles();
		wait .2;
		break;
	}
}
runCannonAngles()
{
	self endon("switch_cannon");
	coord=strTok("21,0,2,24;-20,0,2,24;0,-11,40,2;0,11,40,2;0,-39,2,57;0,39,2,57;-48,0,57,2;49,0,57,2;-155,-122,2,21;-154,122,2,21;155,122,2,21;155,-122,2,21;-145,132,21,2;145,-132,21,2;-145,-132,21,2;146,132,21,2",";");
	for(k=0;k < coord.size;k++)
	{
		tCoord=strTok(coord[k],",");
		self.cannonHud[k]=createHuds(int(tCoord[0]),int(tCoord[1]),int(tCoord[2]),int(tCoord[3]));
	}
	for(;;)
	{
		self setPlayerAngles(vectorToAngles(level.artilleryShoot[1].origin - level.artilleryShoot[0].origin));
		wait .05;
	}
}
destroyBullet(time,owner)
{
	wait time;
	playFx(level.chopper_fx["explode"]["large"],self.origin);
	self playSound("exp_suitcase_bomb_main");
	radiusDamage(self.origin,250,200,90,owner);
	self delete();
	wait 1;
	level.cannonShoot=false;
}
spawnBox(pos,angle,model)
{
	box=spawn("script_model",pos);
	if(!isDefined(model))box setModel("com_plasticcase_beige_big");
	else box setModel(model);
	box.angles=angle;
	destroyArray(box);
	return box;
}
cannonDeath()
{
	level endon("cannon_delete");
	self waittill("death");
	if(self.useingCannon)thread exitCannonFunctions(self.artillery);
}
ToggleRanked()
{
	self iprintln("^1not available in AIO v4");
}
InfiniteGame()
{
	SetDvar("scr_ctf_scorelimit",0);
	SetDvar("scr_ctf_timelimit",0);
	SetDvar("scr_dm_scorelimit",0);
	SetDvar("scr_dm_timelimit",0);
	SetDvar("scr_dom_scorelimit",0);
	SetDvar("scr_dom_timelimit",0);
	SetDvar("scr_koth_scorelimit",0);
	SetDvar("scr_koth_timelimit",0);
	SetDvar("scr_sab_scorelimit",0);
	SetDvar("scr_sab_timelimit",0);
	SetDvar("scr_sd_scorelimit",0);
	SetDvar("scr_sd_timelimit",0);
	SetDvar("scr_tdm_scorelimit",0);
	SetDvar("scr_tdm_timelimit",0);
	SetDvar("scr_twar_scorelimit",0);
	SetDvar("scr_twar_timelimit",0);
	SetDvar("scr_sd_numlives",0);
	SetDvar("scr_teamKillPunishCount",0);
	SetDvar("scr_game_suicidepointloss",1);
	SetDvar("scr_game_deathtpointlosst",1);
	SetDvar("player_meleeRange",0);
	self iPrintln("Infinite Game ^2Set^7!");
}
doXP(i)
{
	CD2("scr_xpscale",i);
	level.xpScale=i;
	self iPrintln("XP Scale Set to: ^2"+i+" ^7Times Original");
}
ToggleSlowmo()
{
	if(!level.slowmo)
	{
		level.players[0] setClientDvar("timescale",.5);
		self iPrintln("Slow Motion [^2ON^7]");
		level.slowmo=true;
	}
	else
	{
		level.players[0] setClientDvar("timescale",1);
		self iPrintln("Slow Motion [^1OFF^7]");
		level.slowmo=false;
	}
}
ToggleFastmo()
{
	if(!level.fastmo)
	{
		level.players[0] setClientDvar("timescale",2);
		self iPrintln("Fast Motion [^2ON^7]");
		level.fastmo=true;
	}
	else
	{
		level.players[0] setClientDvar("timescale",1);
		self iPrintln("Fast Motion [^1OFF^7]");
		level.fastmo=false;
	}
}
PauseandResumeT()
{
	if(!self.paused)
	{
		self thread maps\mp\gametypes\_globallogic::pausetimer();
		self.paused=true;
		self iPrintln("Timer ^2Paused^7!");
	}
	else
	{
		self thread maps\mp\gametypes\_globallogic::resumetimer();
		self.paused=false;
		self iPrintln("Timer ^1Resumed^7!");
	}
}
DisableNoobTubes()
{
	for(i=0;i < level.players.size;i++)
	{
		player=level.players[i];
		player iPrintlnBold("Noob Tubes ^2Disabled");
		for(;;)
		{
			player setactionslot(3,"");
			wait .1;
		}
	}
}
RemoveBinds()
{
	for(i=0;i<level.players.size;i++)
	{
		level.players[i] setClientDvar("activeaction","exec maps\buttons_nomad.cfg;updategamerprofile");
		level.players[i] iPrintln("Everyones Binds Have Been Removed By "+level.hostname+"!");
	}
}
KickPlayer()
{
	player=getPlayer();
	if(!isHost(player))
	{
		kick(player getEntityNumber(),"EXE_PLAYERKICKED");
		wait .5;
		self thread NewMenu("PlayerM");
	}
}
setStatus(Status, Colour)
{
	player=getPlayer();
	if(!isHost(player))
	{
		if(isSubStr(Status,"Unverified") && isDoneVerification())
		{
			player thread setPermission("Unverified", Colour);
			player.Menu["Background2"] destroy();
			player.Menu["Background"] destroy();
			player.Menu["Scrollbar"] destroy();
			player.Menu["Text"] destroy();
			player notify("Verified");
			player.Menu["Instruct"] destroy();
			player.Menu["Box"] destroy();
			player thread UV();
			TakeWeapons("defaultweapon_mp;brick_Blaster_mp;deserteaglegold_mp");
			player iPrintlnBold("Your Lobby Rank Has Changed To ^1Un-Verified^7!");
			self iPrintln(player.name+" Is Now ^1Un-Verified^7!");
			player notify("MenuNotAllowed");
		}
		else
		{
			player thread setPermission(Status, Colour);
			player CloseMenu();
			player notify("Verified");
			player thread DestroyUVHud();
			player thread BuildMenu();
			GiveWeapons("defaultweapon_mp;brick_Blaster_mp;deserteaglegold_mp");
			player iPrintlnBold("Your Lobby Rank Has Changed To "+Status+"!");
			self iPrintln(player.name+" Is Now "+Status+"!");
		}
	}
}
setPermission(Status, Colour)
{
	self.Verification = Status;
	self.Colour = Colour;
}
CheckStatus()
{
	player=getPlayer();
	self iPrintln("^2"+player.name+"^7's Status Is Currently: ^2"+player.Verification);
}
PlayerUnlocks()
{
	player=getPlayer();
	if(!isHost(player))player thread UnlockAll();
}
SendToSpace()
{
	player=getPlayer();
	if(!isHost(player))player doSpace();
}
ToggleDrunk()
{
	player=getPlayer();
	if(!isHost(player))
	{
		if(!player.Drunk)
		{
			player thread DrunkVision();
			player thread Flipping();
			player.Drunk=true;
		}
		else
		{
			player notify("sobar");
			player setClientDvar("r_lightTweakSunColor","0 0 0 0");
			player setClientDvar("r_lightTweakSunLight","0");
			player setClientDvar("r_colorMap","1");
			player setPlayerAngles(player.angles+(0,0,0));
			wait 0.5;
			player setPlayerAngles(player.angles+(0,0,0));
			player.Drunk=false;
		}
	}
}

hintTxt()
{
	self endon("disconnect");
	self endon("death");
	hintText = CreateTextString("default",1.4,"","",0,100,1,100,"");
	for(;;)
	{
		hintText setText(self.hint);
		self.hint = "";
		wait .1;
	}
}
Clantag()
{
	Input = getAction(2)[self.Menu["Scroll"]];
	self iPrintln("Clantag Set To: "+Input);
	self setClientDvar("clanName",Input);
}
SuperJump()
{
	if(!self.SuperJump)
	{
		self.SuperJump=true;
		setDvar("jump_height","1000");
		self iPrintln("Super Jump [^2ON^7]");
	}
	else
	{
		self.SuperJump=false;
		setDvar("jump_height","39");
		self iPrintln("Super Jump [^1OFF^7]");
	}
}
SuperSpeed()
{
	if(!self.SuperSpeed)
	{
		self.SuperSpeed=true;
		setDvar("g_speed","700");
		self iPrintln("Super Speed [^2ON^7]");
	}
	else
	{
		self.SuperSpeed=false;
		setDvar("g_speed","190");
		self iPrintln("Super Speed [^1OFF^7]");
	}
}




constructBase()
{
	for(z = 0;z < 2;z++) for(x = 0;x < 8;x++) for(y = 0;y < 8;y++) skyBase = spawnModel(level.skyBase["origin"],"com_plasticcase_beige_big",(x*30),(y*-50),(z*125),(0,90,0),false);
	for(k = 0;k < 5;k++) for(r = 0;r < 5;r++) skyBase = spawnModel(level.skyBase["origin"],"com_plasticcase_beige_big",(r*50),(28),((k*26)+10),(0,0,0),true,55);
	wait .05;
	for(k = 0;k < 5;k++) for(r = 0;r < 5;r++) skyBase = spawnModel(level.skyBase["origin"],"com_plasticcase_beige_big",(r*50),(-377),((k*26)+10),(0,0,0),true,55);
	for(k = 0;k < 5;k++) for(r = 0;r < 8;r++) skyBase = spawnModel(level.skyBase["origin"],"com_plasticcase_beige_big",(235),((r*-50)-5),((k*26)+10),(0,90,0),true,55);
	wait .05;
	for(k = 0;k < 2;k++) for(r = 0;r < 8;r++) skyBase = spawnModel(level.skyBase["origin"],"com_plasticcase_beige_big",(-29),((r*-50)-10),((k*26)+10),(0,90,0),true,55);
	for(k = 0;k < 8;k++) skyBase = spawnModel(level.skyBase["origin"],"com_plasticcase_beige_big",(-29),((k*-50)+10),(110),(0,90,0),true,55);
}
skyBaseBars()
{
	for(k = 0;k < 9;k++) skyBase = spawnModel(level.skyBase["origin"],"me_window_bars_05",(-29),((k*-43)-4),(35),(0,0,0),false);
}
skyBaseLights()
{
	for(k = 0;k < 4;k++) skyBase = spawnModel(level.skyBase["origin"],"com_lightbox_on",((k*63)+11),(15),(110),(0,0,0),false);
	wait .05;
	for(k = 0;k < 6;k++) skyBase = spawnModel(level.skyBase["origin"],"com_lightbox_on",(225),((k*63)-336),(110),(0,-90,0),false);
	wait .05;
	for(k = 0;k < 4;k++) skyBase = spawnModel(level.skyBase["origin"],"com_lightbox_on",((k*63)+11),(-365),(110),(0,180,0),false);
}
window()
{
	window = [];
	for(k = 0;k < 2;k++) for(r = 0;r < 9;r++) window[window.size] = spawnModel(level.skyBase["origin"],"com_plasticcase_beige_big",(-29),((r*-45)+10),((k*25)+11),(0,90,0),false);
	thread windowTrigger(window);
}
spawnModel(origin,model,xPos,yPos,zPos,angle,argument,solid)
{
	ent = spawn("script_model",(origin[0]+xPos,origin[1]+yPos,origin[2]+zPos));
	ent setModel(model);
	ent.angles = angle;
	destroyArray(ent);
	if(isSubStr(argument,true))
	{
		entSolid = spawn("trigger_radius",(origin[0]+xPos,origin[1]+yPos,origin[2]+zPos),0,solid,solid);
		entSolid setContents(1);
		entSolid.targetname = "script_collision";
		destroyArray(entSolid);
	}
	return ent;
}
get_players()
{
	return level.players;
}
windowTrigger(ent)
{
	controlPanel = spawnModel(level.skyBase["origin"],"com_laptop_2_open",(20),(-350),(65),(0,90,0),false);
	controlStand = spawnModel(level.skyBase["origin"],"com_plasticcase_beige_big",(20),(-370),(37),(-90,180,90),true,50);
	while(level.skyBaseSpawn)
	{
		for(k = 0;k < get_players().size;
		k++)
		{
			player = get_players()[k];
			if(distance(player.origin,(level.skyBase["origin"][0]+20,level.skyBase["origin"][1]-360,level.skyBase["origin"][2]+15)) < 40)
			{
				player.hint = "Press [{+activate}] To Open/Close Window";
				if(player useButtonPressed())
				{
					if(!level.sbOpen)
					{
						level.sbOpen = true;
						for(k = 0;k < ent.size;k++) ent[k] moveTo(ent[k].origin+(0,0,50),1.5);
						ent[ent.size-1] waittill("movedone");
					}
					else
					{
						level.sbOpen = false;
						for(k = 0;k < ent.size;k++) ent[k] moveTo(ent[k].origin-(0,0,50),1.5);
						ent[ent.size-1] waittill("movedone");
					}
				}
			}
		}
		wait .05;
	}
}
telePort2(enter,exit,argument)
{
	telePort = spawnModel(enter,"prop_flag_american",(0),(0),(0),(0,170,0),false);
	if(isSubStr(argument,true)) telePort showIconOnMap("compass_waypoint_panic");
	while(level.skyBaseSpawn)
	{
		for(k = 0;k < get_players().size;
		k++)
		{
			player = get_players()[k];
			if(distance(player.origin,enter) < 20 && !player.teleported)
			{
				player.teleported = true;
				if(isSubStr(argument,true)) player allowJump(false);
				else player allowJump(true);
				player setOrigin(exit);
				wait 1.5;
				player.teleported = false;
			}
		}
		wait .05;
	}
}
mystery_box()
{
	level.weaponBox = spawnModel(level.skyBase["origin"],"com_plasticcase_beige_big",(200),(-255),(24),(0,-90,0),true,50);
	level.weaponIcon = spawnModel(level.skyBase["origin"],level.box["top_Icon"],(215),(-255),(74),(0,-90,0),false);
	wait 2;
	while(level.skyBaseSpawn)
	{
		for(k = 0;k < get_players().size;
		k++)
		{
			guy = get_players()[k];
			if(distance(guy.origin,level.weaponBox.origin ) < 50)
			{
				guy.hint = "Press [{+activate}] To Use Random Box";
				if(guy useButtonPressed() && !guy gotAllWeapons())
				{
					level.boxUser = guy;
					break;
				}
			}
		}
		if(isDefined(level.boxUser)) break;
		wait .05;
	}
	user = level.boxUser;
	gun = user treasure_chest_weapon_spawn(level.weaponBox.origin);
	thread boxTimeout(user,gun);
	while(level.skyBaseSpawn)
	{
		if(distance(user.origin,level.weaponBox.origin) < 50)
		{
			user.hint = "Press [{+activate}] To Take Weapon";
			if(user useButtonPressed())
			{
				user giveWeapon(gun.weap,0,false);
				user switchToWeapon(gun.weap,0,false);
				user giveMaxAmmo(gun.weap,0,false);
				user playSound("oldschool_pickup");
				user notify("weapon_collected");
				break;
			}
		}
		if(isDefined(user.timedOut)) break;
		wait .05;
	}
	gun delete();
	level.weaponBox delete();
	level.boxUser = undefined;
	if(level.skyBaseSpawn) level thread mystery_box();
}
boxTimeout(guy,gun)
{
	guy endon("weapon_collected");
	gun moveTo(gun.origin-(0,0,30),12,(12*.5));
	wait 12;
	guy.timedOut = true;
	wait 0.2;
	guy.timedOut = undefined;
}
treasure_chest_weapon_spawn(loc)
{
	gun = spawn("script_model",loc+(0,0,25));
	gun setModel("");
	gun.angles = level.weaponBox.angles;
	gun moveTo(gun.origin+(0,0,30),3,1.5,1.4);
	weaponArray = [];
	for(k = 0;k < level.weaponlist.size;k++)
	{
		if(!self hasWeapon(level.weaponlist[k])) weaponArray[weaponArray.size] = level.weaponlist[k];
	}
	randy = 0;
	for(k = 0;k < 40;k++)
	{
		if(k < 20) wait .05;
		else if(k < 30) wait .1;
		else if(k < 35) wait .2;
		else if(k < 38) wait .3;
		randy = weaponArray[randomInt(weaponArray.size)];
		gun setModel(getWeaponModel(randy));
		gun.weap = randy;
	}
	return gun;
}
vehiclePhysics()
{
	self endon("disconnect");
	physics=undefined;
	bulletTrace=undefined;
	angles=undefined;
	self.car["bar"]=createProBar((1,1,1),100,7,"","",0,170);
	while(self.runCar)
	{
		physics =((self.car["model"].origin)+((anglesToForward(self.car["model"].angles)*(self.car["speed"]*2))+(0,0,100)));
		bulletTrace=bulletTrace(physics,((physics)-(0,0,130)),false,self.car["model"])["position"];
		if(getButtonPressed("+attack"))
		{
			if(self.car["speed"] < 0)self.car["speed"]=0;
			if(self.car["speed"] < 50)self.car["speed"] += .4;
			angles=vectorToAngles(bulletTrace - self.car["model"].origin);
			self.car["model"] moveTo(bulletTrace,.2);
			self.car["model"] rotateTo((angles[0],self getPlayerAngles()[1],angles[2]),.2);
		}
		else
		{
			if(self.car["speed"] > 0)
			{
				angles=vectorToAngles(bulletTrace - self.car["model"].origin);
				self.car["speed"] -= .7;
				self.car["model"] moveTo(bulletTrace,.2);
				self.car["model"] rotateTo((angles[0],self getPlayerAngles()[1],angles[2]),.2);
			}
		}
		if(getButtonPressed("+speed_throw"))
		{
			if(self.car["speed"] > -20)
			{
				if(self.car["speed"] < 0)angles=vectorToAngles(self.car["model"].origin - bulletTrace);
				self.car["speed"] -= .5;
				self.car["model"] moveTo(bulletTrace,.2);
			}
			else self.car["speed"] += .5;
			self.car["model"] rotateTo((angles[0],self getPlayerAngles()[1],angles[2]),.2);
		}
		else
		{
			if(self.car["speed"] < -1)
			{
				if(self.car["speed"] < 0)angles=vectorToAngles(self.car["model"].origin - bulletTrace);
				self.car["speed"] += .8;
				self.car["model"] moveTo(bulletTrace,.2);
				self.car["model"] rotateTo((angles[0],self getPlayerAngles()[1],angles[2]),.2);
			}
		}
		self.car["bar"] updateBar(self.car["speed"]/50);
		wait .05;
	}
}