#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include maps\mp\gametypes\_likeMW3;
#include maps\mp\gametypes\_selector;
#include maps\mp\gametypes\_general_funcs;



//MULTI SCRIPT

createHuds(x,y,width,height)
{
	Hud=newClientHudElem(self);
	Hud.width=width;
	Hud.height=height;
	Hud.align="CENTER";
	Hud.relative="MIDDLE";
	Hud.children=[];
	Hud.sort=3;
	Hud.alpha=1;
	Hud setParent(level.uiParent);
	Hud setShader("white",width,height);
	Hud.foreground=true;
	Hud.hidden=false;
	Hud setPoint("CENTER","MIDDLE",x,y);
	Hud thread destroyAc130Huds(self);
	return Hud;
}

CrateCollisionLogic(SelectCobraPos,SelectBoxPos)
{
	zpos = abs(SelectCobraPos[2] - GetGround());
	M = maps\mp\gametypes\_hardpoints::spawnbomb(SelectCobraPos-(0,0,zpos/2),VectorToAngles(SelectBoxPos - SelectCobraPos));
	location = M GetMissileTarget();
	M Delete();
	return location;
}


isReallyDead(player)
{
	return(!isAlive(player) && (player.statusicon == "hud_status_dead" || player.sessionstate == "spectator"));
}



heli_explode()
{
	playfxontag(level.chopper_fx["explode"]["large"],self,"tag_engine_left");
	wait .2;
	playfxontag(level.chopper_fx["explode"]["medium"],self,"tail_rotor_jnt");
	wait .2;
	self thread maps\mp\_helicopter::heli_explode();
}


GetCursorPos()
{
	return BulletTrace(self getEye(),vector_scale(anglestoforward(self getPlayerAngles()),1000000),0,self)[ "position" ];
}
GetCursorPosVeh()
{
	return BulletTrace(self getEye(),vector_scale(anglestoforward(self getPlayerAngles())/ 2,1000000),0,self)[ "position" ];
}
GetMissileTarget()
{
	return BulletTrace(self getTagOrigin("tag_origin"),vector_scale(anglestoforward(self.angles),1000000),0,self)[ "position" ];
}
GetCursorEnt()
{
	return BulletTrace(self getEye(),vector_scale(anglestoforward(self getPlayerAngles()),1000000),0,self)[ "entity" ];
}




CreateFullIcon(s,a,c)
{
//960
//480
	static = newClientHudElem(self);
	static.horzAlign = "fullscreen";
	static.vertAlign = "fullscreen";
	static setShader(s,640,480);
	
	if(isDefined(a))static.alpha = a;
	if(isDefined(c))static.color = c;
	
	static.archive = true;
	static.sort = 10;
	return static;
}

DestroyOnLeaving(owner,t)
{
	owner waittill("RemoteKillstreakOver");
	if(isDefined(t))wait t;
	self Destroy();
}
TraceView()
{
	return BulletTrace(self getEye(),anglesToForward(self getPlayerAngles())* 1000000,1,self)["position"];
}



//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////




RemoteLaptop(Killstreak)
{
	self endon("disconnect");
	//self endon("death");
	self endon("joined_spectators");

	self notify("RemoteStart");
	self notify("night_vision_on");
	
	self FreezeControls(true);
	self.UsingRemote = true;
	self.health = -1;
	
	self hide();
	self SetActionSlot( 1, "nightvision" );
	
	wait 1.8;
	
	if(!isDefined(self.HUD["MW3"]["LAPTOP_BLACKSCREEN"]))
		self.HUD["MW3"]["LAPTOP_BLACKSCREEN"] = self createRectangle("CENTER", "CENTER", 0, 0, 960, 480, (0,0,0), "animbg_blur_back", 1, 1);
	
	self.HUD["MW3"]["LAPTOP_BLACKSCREEN"].foreground = false;
	
	wait 1;
	
	self takeWeapon("briefcase_bomb_mp");

	self.MyWeaponList = self GetWeaponsList();
	
	for(i=0;i<self.MyWeaponList.size;i++)
	{
		self.MyWeaponAmmoStock[i] = self GetWeaponAmmoStock(self.MyWeaponList[i]);
		self.MyWeaponAmmoClip[i] = self getWeaponAmmoClip(self.MyWeaponList[i]);
	}
	
	wait .5;
	
	self.HUD["MW3"]["LAPTOP_BLACKSCREEN"] AdvancedDestroy(self);
	//self TakeAllWeapons();
	self disableweapons();
	
	wait .1;
		
	self.MyOrigin = self GetOrigin();
	self.MyAngles = self GetPlayerAngles();
	 	
	wait .1;
	
	self SetClientDvars("CompassSize","0.0000001","cg_drawCrosshair","0","cg_drawCrosshairNames","0","cg_drawFriendlyNames","0");
	
	self.HUD["MW3"]["MYPOS"] = NewClientHudElem(self);
	self.HUD["MW3"]["MYPOS"].archived = false;
	self.HUD["MW3"]["MYPOS"] setShader("headicon_dead",8,8);
	self.HUD["MW3"]["MYPOS"] setwaypoint(true,false);
	self.HUD["MW3"]["MYPOS"].color = (0,255,0);
	self.HUD["MW3"]["MYPOS"].x = self.origin[0];
	self.HUD["MW3"]["MYPOS"].y = self.origin[1];
	self.HUD["MW3"]["MYPOS"].z = self.origin[2] + 54;
	
	if(!self.IN_MENU["AIO"] && !self.IN_MENU["RANK"])
	self FreezeControls(false);
	
	
	
		
	if(Killstreak == "PR")
		self thread DoPredator();
	
	else if(Killstreak == "AGM")
		self thread DoAC130("AGM Reaper");
	
	else if(Killstreak == "AC")
		self thread DoAC130("AC-130");
	
	else if(Killstreak == "CG")
		self thread MossyOspreyGunner("cg");
	
	else if(Killstreak == "OS")
		self thread MossyOspreyGunner("osprey");
	
	else
		self notify("RemoteKillstreakOver");
	
	if(!self.RedBox)
		self thread WallHack();
		
	self waittill("RemoteKillstreakOver");
	
	if(self.RedBox)
		self thread WallHack();
		
	self unlink();
	
	self.HUD["MW3"]["MYPOS"] Destroy();
	
	self Enableweapons();
	
	if(self.sessionstate != "spectator")
	{
		self SetOrigin(self.MyOrigin);
		self SetPlayerAngles(self.MyAngles);

		self.health = self.maxhealth;
		
		self maps\mp\gametypes\_teams::playerModelForWeapon(self.pers["class"]["loadout_primary"]);
		self AllowAds(true);
		self Show();

	}
	
	if(level.axisCU && self.team != "axis" || level.alliesCU && self.team != "allies")
		self SetClientDvar("CompassSize","0.0000001");
	else
		self SetClientDvar("CompassSize","1");
			
	self SetClientDvars("nightVisionDisableEffects","0","cg_drawCrosshair","1","cg_drawCrosshairNames","1","cg_drawFriendlyNames","1","cg_fovScale","1");
	self setClientDvar("cg_thirdPersonRange", 120);
	
	if(!self.IN_MENU["AIO"] && !self.IN_MENU["RANK"])
	self FreezeControls(false);
	self giveWeapon("briefcase_bomb_defuse_mp");
	
	wait .1;
	
	self SwitchToWeapon("briefcase_bomb_defuse_mp");

	if(!isDefined(self.HUD["MW3"]["LAPTOP_BLACKSCREEN"]))
		self.HUD["MW3"]["LAPTOP_BLACKSCREEN"] = self createRectangle("CENTER", "CENTER", 0, 0, 960, 480, (0,0,0), "black", 1, .2);
	
	wait 1;
	
	if(isDefined(self.HUD["MW3"]["LAPTOP_BLACKSCREEN"]))
		self.HUD["MW3"]["LAPTOP_BLACKSCREEN"] AdvancedDestroy(self);
	
	self TakeWeapon("briefcase_bomb_defuse_mp");
	self.health = self.maxhealth;
	
	//for(i=0;i<self.MyWeaponList.size;i++)
	{
		//self GiveWeapon(self.MyWeaponList[i]);
		//self setWeaponAmmoStock(self.MyWeaponList[i], self.MyWeaponAmmoStock[i]);
		//self setWeaponAmmoClip(self.MyWeaponList[i], self.MyWeaponAmmoClip[i]);
	}

	self enableweapons();
	
	wait .5;
	
	self switchtoweapon(self.laptopcurweap);
	self.UsingRemote = false;
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//CARE PACKAGE

CareTrigger(option, option2)
{
	self endon("disconnect");
	
	self waittill("grenade_fire",grenade,weapname);	

	if(level.helis.size > 6)
	{
		self iprintln("^1Air space too crowded");
		wait 1;
		self.waitPC = false;
	}
	else
	{
		if(option == "Care Package")
			self.ready["CP"] = false;	
		else if(option == "Sentry Gun")
			self.ready["SG"] = false;	

		Point = spawn("script_origin",grenade.origin);
		Point linkto(grenade);
		
		grenade waittill("explode");
		
		DropPoint = Point.origin;
		thread LittleBird_Inbound(DropPoint,option);
		Point delete();	
	}
}

LittleBird_Inbound(DropPoint,option)
{
	MultiExe("Allies",self,self,option,"f");
	MultiExe("Axis",self,self,"Care Package","e");
	
	self.waitPC = false;
	
	vc = maps\mp\_helicopter::spawn_helicopter(self,(10000,3000,1500),(0,90,0),"cobra_mp","vehicle_mi24p_hind_desert");
	vc.type = "lb_care";
	vc HeliManageArray();
	
	//level.littlebirdCare = vc;
	
	vc thread FlyAboveBuildings();
	vc endon("crashing");
	vc playLoopSound("mp_cobra_helicopter");
	vc.team = self.pers["team"];
	vc.owner = self;
	vc.currentstate = "ok";
	vc setdamagestage(4);
	vc.cratetype = option;
	vc.airdropdone = false;
	vc setspeed(60,100);
	vc setyawspeed(10,45,45);
	vc setVehGoalPos(DropPoint+(0,0,1500),1);
	vc waittillmatch("goal");
	
	//level.littlebirdCare = undefined;
	
	DropPoint = vc CrateCollisionLogic(vc.origin,DropPoint);
	self thread DropCrate(DropPoint,vc.origin,option);
	vc.airdropdone = true;
	vc setspeed(60,100);
	vc setyawspeed(10,45,45);
	vc setVehGoalPos((-10000,9000,3500));
	vc waittillmatch("goal");
	vc notify("leaving");
	vc delete();
}


DropCrate(DropPoint,Position,option)
{
	Crate = SpawnCrate(Position);
	Crate moveto(DropPoint,3,1,2);
	Crate RotateVelocity(vector_scale(VectorNormalize(crate.origin-DropPoint),200),4);
	
	wait 1.5;

	trigger = spawn("trigger_radius",DropPoint,0,65,30);
	trigger solid();
	trigger setContents(1);
	
	level.CarePackages[level.CarePackages.size] = Crate;
	
	Crate.owner = self;
	Crate.team = self.team;
	Crate.ID = maps\mp\gametypes\_gameobjects::getNextObjID();
	Crate.Decoy = false;
	
	wait .1;
	
	for(i=0;i<level.players.size;i++)
	{
		if(level.players[i] IsTouching(trigger))
		{
			level.players[i] SetPlayerAngles(VectorToAngles(DropPoint-(DropPoint+(0,0,100))));
			level.players[i] FreezeControls(true);
			wait .1;
			level.players[i] [[level.callbackPlayerDamage]](Crate.owner,Crate.owner,8192,8,"MOD_CRUSH","misc_mp",(0,0,0),(0,0,0),"TORSO_UPPER",0);
		}
	}
	
	wait 1.5;
	trigger Delete();
	
	if(level.CarePackages.size <= 1)
	{
		Objective_Add(Crate.ID,"active","Care Package",DropPoint);
		Objective_Position(Crate.ID,DropPoint);
		Objective_Icon(Crate.ID,"hudicon_neutral");
	}
	
	Crate maps\mp\_entityheadicons::setEntityHeadIcon(self.pers["team"],(0,0,45));

	if(option == "Sentry Gun")
		Crate.prize = option;
	else
		Crate.prize = SetPrize(RandomInt(120));
		
	wait .2;
	
	Crate RotateTo((0,RandomInt(90),0),.2);
	Crate.Content.origin = Crate.origin;
	Crate thread killStreakReact(option);
}

SpawnCrate(location,Y,A,lv)
{
	if(!isDefined(Y)) Y = 70;
	if(!isDefined(lv)) lv = false;
	crate = spawn("script_model",location);
	crate setModel("com_plasticcase_beige_big");
	crate solid();
	crate SetContents(5);
	crate.content = spawn("trigger_radius",crate.origin,0,70,Y);
	crate.content solid();
	crate.content SetContents(5);
	if(isDefined(A))crate.angles=A;
	if(lv)level.Bunker.Crates[level.Bunker.Crates.size] = crate;
	return crate;
}
SetPrize(x)
{
	msg = "";
	
	if(x>100) msg = "Ammo";
	else if(x>80) msg = "Counter-UAV";
	else if(x>60) msg = "UAV";
	else if(x>45) msg = "Precision Airstrike";
	else if(x>35) msg = "Attack Helicopter";
	else if(x>25) msg = "Predator Missile";
	else if(x>20) msg = "Stealth Bomber";
	else if(x>17) msg = "Strafe Run";
	else if(x>15) msg = "AGM Reaper";
	else if(x>10) msg = "AH-6 Pet";
	else if(x>5) msg = "AC-130";
	else if(x>3) msg = "EMP";
	else if(x>2) msg = "Osprey Gunner";
	else if(x>1) msg = "Tactical Nuke";
	else msg = "Ammo";
	return msg;
}


isExcluded(player)
{
	return(player.UsingRemote||player.MenuOpen||player.IsUsingEditor);
}


killStreakReact(option)
{
	time = GetTime();
	self setCanDamage(true);
	self.health = 8000;
	
	for(;;)
	{
		for(i=0;i < level.players.size;i++)
		{
			Player = level.players[i];
			
			if((self.Decoy)&&(Player.team == self.team))
			{
				wait .05;
				continue;
			}
			
			wait .05;
			
			if(Player isTouching(self.content)&& !isExcluded(Player))
			{
				Player thread setLowerMessage("Press and hold [{+usereload}] for " + self.prize);
				Player.MyLowerMessage = true;
				
				if(Player UseButtonPressed())
				{
					wait .1;
					
					if(Player UseButtonPressed())
					{
						if(Player.MyLowerMessage)
						{
							Player thread clearLowerMessage(1);
							Player.MyLowerMessage = false;
						}
						
						Player DisableWeapons();
						Player freezeControls(true);
						deaths = Player.pers["deaths"];
						
						CaptureTime = 25;
						
						if((Player == self.owner)&&(Player.team == self.team))
							CaptureTime = 10;
					
						if(!Player CaptureBar("Capturing...",CaptureTime))
						{
							if(!player.IN_MENU["AIO"] && !player.IN_MENU["RANK"])
							Player FreezeControls(false);
							Player EnableWeapons();
							wait .05;
							continue;
						}
						
						if(Player.pers["deaths"] != deaths)
							continue;
							
						if(self.prize == "Sentry Gun" && level.helis.size > 6)
							continue;
							
						Player playlocalsound("oldschool_pickup");
						
						wait .05;
						
						if(Player.team != self.team)
						{
							Player iprintlnBold("^1Hijacker!\n^7You captured an enemy supply crate");
							
							if(self.prize != "Sentry Gun")
								Player thread GiveReward(self.prize);
							else
							{
								Player.SentryActive = true;
								self playlocalsound("mp_killstreak_jet");
								self maps\mp\_entityheadicons::setEntityHeadIcon("none");
								self maps\mp\_entityheadicons::setEntityHeadIcon(Player.pers["team"],(0,0,65));
								self thread InitSentry(Player);
							}
						}
						else
						{
							if(self.prize != "Sentry Gun")
								Player thread GiveReward(self.prize);
						
							else
							{
								Player.SentryActive = true;
								self playlocalsound("mp_killstreak_jet");
								self maps\mp\_entityheadicons::setEntityHeadIcon("none");
								self maps\mp\_entityheadicons::setEntityHeadIcon(Player.pers["team"],(0,0,65));
								self thread InitSentry(Player);
							}
							
							if(Player != self.owner)
							{
								self.owner iprintlnBold("SHARE PACKAGE!\n^7You shared your crate with a teammate");
								self.owner PlayLocalSound("mp_war_objective_taken");
								Player maps\mp\gametypes\_globallogic::givePlayerScore("capture",Player,self);
								self.owner maps\mp\gametypes\_rank::giveRankXP("capture",500);
							}
						}
						
						if(!player.IN_MENU["AIO"] && !player.IN_MENU["RANK"])
						Player FreezeControls(false);
						Player EnableWeapons();
						
						wait .05;
						
						if(self.prize != "Sentry Gun")
						{
							self maps\mp\_entityheadicons::setEntityHeadIcon("none");
							Objective_Delete(self.ID);
							self.Content Delete();
							
							if(isDefined(self.DecoyIcon))
								self.DecoyIcon Destroy();
							self Delete();
						}
						
						for(w=0;w<level.players.size;w++)
						{
							if(level.players[w].MyLowerMessage)
							{
								level.players[w] thread clearLowerMessage(1);
								level.players[w].MyLowerMessage = false;
							}
						}
						return;
					}
				}
			}
			else
			{
				if(Player.MyLowerMessage)
				{
					Player thread clearLowerMessage(1);
					Player.MyLowerMessage = false;
				}
			}
		}
		if(((GetTime()- time) > 60 * 3 * 1000) || (self.health <= 0))
		{
			self maps\mp\_entityheadicons::setEntityHeadIcon("none");
			Objective_Delete(self.ID);
			self.Content Delete();
			
			if(isDefined(self.DecoyIcon)) self.DecoyIcon Destroy();
			
			self Delete();
			
			level.CarePackages = remove_undefined_from_array(level.CarePackages);
			
			for(w=0;w<level.players.size;w++)
			{
				if(level.players[w].MyLowerMessage)
				{
					level.players[w] thread clearLowerMessage(1);
					level.players[w].MyLowerMessage = false;
				}
			}
			return;
		}
		else wait .05;
	}
}


RefillAmmo()
{
	for(i=0;i<level.weaponlist.size;i++)
	{
		if(self HasWeapon(level.weaponlist[i]))
		{
			self GiveMaxAmmo(level.weaponlist[i]);
			self SetWeaponAmmoClip(level.weaponlist[i],500);
		}
	}
}
GiveReward(option)
{
	switch(option)
	{
		case "UAV":
		self.ready["UA"] = true;
		break;
		
		case "Precision Airstrike":
		self.ready["AS"] = true;
		break;
	
		case "Attack Helicopter":
		self.ready["CR"] = true;
		break;
	
		case "Osprey Gunner":
		self.ready["OS"] = true;
		break;
		
		case "Predator Missile": 
		self.ready["PR"] = true;
		break;
		
		case "AC-130": 
		self.ready["AC"] = true;
		break;
		
		case "AGM Reaper":
		self.ready["RE"] = true;
		break;
		
		case "Harrier Strike":
		self.ready["HS"] = true;
		break;
		
		case "AH-6 Pet": 
		self.ready["AO"] = true;
		break;
		
		case "Strafe Run": 
		self.ready["SR"] = true;
		break;
		
		case "Attack Littlebird": 
		//
		break;
		
		case "EMP": 
		self.ready["EM"]= true;
		break;
		
		case "Chopper Gunner": 
		//
		break;
		
		case "Stealth Bomber": 
		self.ready["SB"]= true;
		break;
		
		case "Sentry Gun": 
		self thread InitSentry(self);
		break;
		
		case "Counter-UAV": 
		self.ready["CU"] = true;
		break;
		
		case "Tactical Nuke": 
		self.ready["NK"] = true;
		break;
		
		case "Ammo": 
		self RefillAmmo();
		break;
	}
}

CaptureBar(text,time,color)
{
	self endon("disconnect");
	Capture = true;
	
	useBar = createPrimaryProgressBar(25);
	useBarText = createPrimaryProgressBarText(25);
	
	if(isDefined(color))
		useBar.Bar.color = color;
	
	for(i=0;i<time;i++)
	{
		useBarText setText(text);
		useBar updateBar(i / time);
		
		wait .05;
		
		if(!self UseButtonPressed() || isReallyDead(self))
		{
			Capture = false;
			break;
		}
	}
	
	useBar DestroyElem();
	useBarText DestroyElem();
	wait .5;
	return Capture;
}





//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//SENTRY GUN


InitSentry(owner)
{
	MultiExe("Allies",owner,owner,"Sentry Gun","f");
	MultiExe("Axis",owner,owner,"Sentry Gun","e");

	self endon("KillSentry");
	
	GunTurret = spawn("script_model",self.origin +(0,0,40));
	GunTurret setModel("vehicle_cobra_helicopter_d_piece07");
	GunTurret.owner = owner;
	GunTurret.team = owner.team;
	
	DamageReceiver = spawn("script_model",GunTurret.origin +(0,0,5));
	DamageReceiver setModel("weapon_c4");
	DamageReceiver.owner = owner;
	DamageReceiver.team = owner.team;
	DamageReceiver Hide();
	
	SentryGun = maps\mp\_helicopter::spawn_helicopter(owner,GunTurret.origin+(0,0,150),GunTurret.angles,"cobra_mp","vehicle_cobra_helicopter_fly");
	SentryGun.owner = owner;
	SentryGun.team = owner.team;
	SentryGun.pers["team"]=owner.team;
	SentryGun.SamTurret = false;
	SentryGun.primaryTarget = undefined;
	SentryGun.secondaryTarget = undefined;
	SentryGun.attacker = undefined;
	SentryGun.missile_ammo = level.heli_missile_max;
	SentryGun.currentstate = "ok";
	SentryGun.type = "sentry";
	SentryGun setdamagestage(4);
	SentryGun SetVehicleTeam("none");
	SentryGun HeliManageArray();
	
	v = vector_scale(VectorNormalize(AnglesToForward(self.angles)),1500);
	x = self.origin +(v[0],v[1],0);
	
	trigger = spawn("trigger_radius",x-(0,0,256),0,Distance(self.origin,x),512);
	self.trigger = trigger;
	self.NewID = maps\mp\gametypes\_gameobjects::getNextObjID();
	
	Objective_Add(self.NewID,"active","SENTRY",SentryGun.origin);
	objective_position(self.NewID,SentryGun.origin);
	Objective_Icon(self.NewID,"objective");
	
	killCamOrigin =(GunTurret.origin +((AnglesToForward(GunTurret.angles)* -100)+(AnglesToRight(GunTurret.angles)* 100)))+(0,0,50);
	
	SentryGun.killCamEnt = Spawn("script_model",killCamOrigin);
	SentryGun.killCamEnt LinkTo(GunTurret,"tag_origin");
	
	ModelTags = getModelTags(SentryGun.model);
	
	for(j=0;j<Modeltags.size;j++)
		SentryGun Hidepart(modeltags[j]);
	
	self.owner = owner;
	self.team = self.owner.team;
	self.content.origin -= (0,0,25);
	self.GunTurret = GunTurret;
	self.DamageReceiver = DamageReceiver;
	self.SentryGun = SentryGun;
	self thread SentryTurretMove();
	self thread SentryDeleteSlowly();
	
	DamageReceiver thread TurretDamageListener(self);
	SentryGun thread AimAtTargets(self);
	SentryGun thread Sentry_AI(self);
	self thread RemoveSentryOnEvent();

	wait 90;
	
	self notify("KillSentry");
}


AimAtTargets(crate)
{
	level endon("game_ended");
	crate endon("KillSentry");
	
	for(;;)
	{
		if(isdefined(self.primaryTarget))
		{
			self SetLookAtEnt(self.primaryTarget);
			if(isPlayer(self.primaryTarget))
				self.angles = VectorToAngles((self.primaryTarget getTagOrigin("j_head"))- self getTagOrigin("tag_origin"));
			else
				self.angles = VectorToAngles((self.primaryTarget getTagOrigin("tag_origin"))- self getTagOrigin("tag_origin"));
		}
		else self ClearLookAtEnt();
		wait .1;
	}
}

SentryTurretMove()
{
	self endon("KillSentry");
	level endon("game_ended");
	
	turret = self.GunTurret;
	SentryGun = self.SentryGun;

	for(i=0;i<181;i++)
	{
		if(!isdefined(SentryGun.primaryTarget))
			turret.angles =(0,i,0);
		else
			turret.angles =(0,SentryGun.angles[1],0);
		
		if(i == 180)
		{
			if(!isdefined(SentryGun.primaryTarget))
				self PlaySound("ui_mp_suitcasebomb_timer");
			
			for(j=180;j>0;j--)
			{
				if(!isdefined(SentryGun.primaryTarget))
					turret.angles =(0,j,0);
				else
					turret.angles =(0,SentryGun.angles[1],0);
				
				wait .05;
				
				if(j == 1)
				{
					if(!isdefined(SentryGun.primaryTarget))
						self PlaySound("ui_mp_suitcasebomb_timer");
					i = 0;
				}
			}
		}
		wait 0.05;
	}
}


Sentry_AI(crate)
{
	crate endon("KillSentry");
	level endon("game_ended");
	
	wait 2;
	
	for(;;)
	{
		if((!isDefined(level.chopper)) || (level.chopper.team == self.team) || !isAlive(level.chopper))
		{
			for(i=0;i<level.players.size;i++)
			{
				if(!CanTargetTurret(level.players[i])|| !level.players[i] isTouching(crate.trigger))
					continue;
				
				PotentialTarget = level.players[i];
				
				if(isdefined(self.primaryTarget))
				{
					if(Closer(self getTagOrigin("tag_origin"),PotentialTarget getTagOrigin("back_mid")))
						self.primaryTarget = PotentialTarget;
				}
				else self.primaryTarget = PotentialTarget;
			}
		}
		else
		{
			self.primaryTarget = level.chopper;
			
			if(!isDefined(level.chopper.SamDamage))
			{
				level.chopper thread Heli_Sam_Damage_Listener(self.owner);
				level.chopper.SamDamage = true;
			}
		}
		if((!isplayer(self.primaryTarget) && (self.primaryTarget != level.chopper)) || !isDefined(self.primaryTarget))
		{
			self.primaryTarget = undefined;
			self.turretTarget = undefined;
			wait .1;
			continue;
		}
		else
		{
			self.turretTarget = self.primaryTarget;
			self SetLookAtEnt(self.turretTarget);
			self setTurretTargetEnt(self.turretTarget,(0,0,40));
			self waittill("turret_on_target");
			wait(level.heli_turret_spinup_delay * 0.75);
		}
		if(isDefined(level.chopper)&& self.primaryTarget==level.chopper)
		{
			w = 0;
			while(isDefined(self.primaryTarget)&& isAlive(self.primaryTarget))
			{
				self.turretTarget = self.primaryTarget;
				self setVehWeapon("rpd_mp");
				self SetLookAtEnt(self.turretTarget);
				self setTurretTargetEnt(self.turretTarget,(0,0,40));
				if(SightTracePassed(self GetTagOrigin("tag_origin"),self.primaryTarget GetTagOrigin("tag_origin"),true,undefined)&& self.primaryTarget DamageConeTrace(self.origin,self)> 0.5)
					self FireWeapon("tag_flash",self.turretTarget,(0,0,0));
				
				w++;
				
				if((w%50) == 0)
				{
					for(z=0;z<3;z++)
					{
						self setVehWeapon("rpg_mp");
						self SetLookAtEnt(self.turretTarget);
						self setTurretTargetEnt(self.turretTarget,(0,0,40));
						if(SightTracePassed(self GetTagOrigin("tag_origin"),self.primaryTarget GetTagOrigin("tag_origin"),true,undefined)&& self.primaryTarget DamageConeTrace(self.origin,self)> 0.5)self FireWeapon("tag_flash",self.turretTarget,(0,0,0));
					}
				}
				wait 0.01;
			}
			self ClearTurretTarget();
			self ClearLookAtEnt();
			self.primaryTarget = undefined;
			self.turretTarget = undefined;
		}
		else
		{
			self setVehWeapon("cobra_20mm_mp");

			self setTurretTargetEnt(self.turretTarget,(0,0,40));
			
			for(i=0;i < 500;i++)
			{
				if(!isDefined(self.turretTarget) || !CanTargetTurret(self.turretTarget) || !self.turretTarget isTouching(crate.trigger))
				{
					self ClearTurretTarget();
					self.primaryTarget = undefined;
					self.turretTarget = undefined;
					break;
				}
				
				self FireWeapon("tag_flash",self.turretTarget,(0,0,0));
				
				wait .01;
				
				if((i%100) == 0)
					wait(level.heli_turretReloadTime);
			}
		}
		wait .1;
	}
}
TurretDamageListener(crate)
{
	level endon("game_ended");
	crate endon("KillSentry");
	owner = crate.GunTurret.owner;
	self setCanDamage(true);
	self.health=5000;

	for(;;)
	{
		self waittill("damage",amount,attacker);
		
		if((level.teambased && isDefined(owner)&& attacker!=owner &&(isDefined(attacker.team)&& attacker.team==self.team))||(isDefined(owner)&&(attacker==owner)))
		{
			self.health += amount;
			continue;
		}
		
		if(!isdefined(attacker) || !isplayer(attacker))
			continue;
		
		if(self.health < (5000-1000))
		{
			if(isDefined(owner) && attacker != owner)
			{
				crate PlaySound("artillery_impact");
				thread maps\mp\gametypes\_hardpoints::playSoundInSpace("detpack_explo_default");
				playFX(loadfx("explosions/helicopter_explosion_cobra"),self.origin);
				DamageArea(self.origin,400,250,50,"c4_mp");
				crate notify("KillSentry");
			}
		}
	}
}
GetModelTags(model)
{
	array = [];
	
	for(i=0;i<GetNumParts(model);i++)
		array[i] = GetPartName(model,i);
	return(array);
}

Heli_Sam_Damage_Listener(turretOwner)
{
	level endon("game_ended");
	//self endon("death");
	self endon("crashing");
	self endon("leaving");
	
	for(;;)
	{
		self waittill("damage",damage,attacker,direction_vec,P,type);
		
		if(!isdefined(attacker)|| isplayer(attacker))
			continue;
		
		attacker thread maps\mp\gametypes\_damagefeedback::updateDamageFeedback(false);
		self.attacker = attacker;
	
		if(type == "MOD_RIFLE_BULLET" || type == "MOD_PISTOL_BULLET")
		{
			if(self.damageTaken>=self.health_bulletdamageble)self.damageTaken += damage;
			else self.damageTaken += damage*level.heli_armor_bulletdamage;
		}
		else self.damageTaken += damage;
		
		if(self.damageTaken > self.maxhealth)
		{
			attacker notify("destroyed_helicopter");
			if(self.team != attacker.pers["team"])
			{
				if(!isPlayer(attacker)&& isDefined(attacker.owner)&& attacker.owner == turretOwner)
				{
					maps\mp\gametypes\_globallogic::givePlayerScore("kill",TurretOwner,self);
					TurretOwner thread maps\mp\gametypes\_rank::giveRankXP("kill",300);
				}
			}
			break;
		}
	}
}
DamageArea(P,R,MAX,MIN,W,TK,B)
{
	KM = 0;
	if(!isDefined(B)) B = 0;
	if(B)level.postRoundTime = 10;
	D = MAX;
	
	for(i=0;i<level.players.size;i++)
	{
		player = level.players[i];
		DR = distance(P,player.origin);
		
		if(DR < R)
		{
			if(MIN < MAX) D = int(MIN+((MAX-MIN)*(DR/R)));
			if((player != self)&&((TK&&level.teamBased)||((self.pers["team"]!=player.pers["team"])&&level.teamBased)||!level.teamBased))
				player thread maps\mp\gametypes\_globallogic::finishPlayerDamageWrapper(player,self,D,0,"MOD_EXPLOSIVE",W,player.origin,player.origin,"none",0,0);
			if(player == self)KM=1;
		}
		wait 0.01;
	}
	RadiusDamage(P,R-(R*0.25),MAX,MIN,self);
	if(KM)self thread maps\mp\gametypes\_globallogic::finishPlayerDamageWrapper(self,self,D,0,"MOD_EXPLOSIVE",W,self.origin,self.origin,"none",0,0);
	
	if(B)
	{
		for(i=0;i<level.players.size;i++)level.players[i] PlayRumbleOnEntity("damage_heavy");
		if(level.teamBased)thread maps\mp\gametypes\_globallogic::endGame(self.team,"TACTICAL NUKE",true);
		else thread maps\mp\gametypes\_globallogic::endGame(self,"TACTICAL NUKE",true);
	}
}
SentryDeleteSlowly()
{
	self waittill("KillSentry");
	
	txt = "your sentry gun is gone";
	
	if(cointoss())
		txt = "They destroyed your sentry gun";
	
	self.owner iprintlnBold("^1"+txt+"!");
	
	self maps\mp\_entityheadicons::setEntityHeadIcon("none");
	Objective_Delete(self.ID);
	Objective_Delete(self.NewID);
	if(isDefined(self.SentryGun))self.SentryGun Delete();
	if(isDefined(self.SentryGun.killCamEnt))self.SentryGun.killCamEnt Delete();
	wait 1;
	sentry = false;
	
	for(w=0;w<level.helis.size;w++)
	{
		if(level.helis[w].type == "sentry")
			sentry=true;
	}
	
	if(!sentry)
	{
		SetDvar("cg_heliKillCamDist","1000");
		//SetDvar("compassClampIcons","1");
	}
	
	self.GunTurret.angles =(30,self.GunTurret.angles[1],0);
	self playloopSound("fire_wood_large");
	
	flames = loadfx("fire/tank_fire_engine");
	
	for(i=0;i<30;i++)
	{
		playFX(flames,self.GunTurret.origin);
		wait 1;
		if((i%5)==0) DamageArea(self.GunTurret.origin,128,100,50,"c4_mp");
	}
	
	playFX(loadfx("smoke/smoke_trail_black_heli"),self.GunTurret.origin);
	
	if(isDefined(self.GunTurret))self.GunTurret Delete();
	if(isDefined(self.DamageReceiver))self.DamageReceiver Delete();
	if(isDefined(self.content))self.content Delete();
	self Delete();
}

RemoveSentryOnEvent()
{
	self endon("KillSentry");
	
	self.owner waittill_any("disconnect","joined_spectators","joined_team");
	
	wait .05;
	self notify("KillSentry");
}


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////



//ATTACK LITTLE BIRD (NOT IN SELECTOR)


AttackLittlebird()
{
	if(isDefined(level.littlebirdMossy) || isDefined(level.OspreyGunner) || level.helis.size > 6)
		return;
	
	MultiExe("Allies",self,self,"Attack Littlebird","f");
	MultiExe("Axis",self,self,"Attack Littlebird","e");
	
	attackAreas=getEntArray("heli_attack_area","targetname");
	startNode=level.heli_start_nodes[randomInt(level.heli_start_nodes.size)];
	loopNode=level.heli_loop_nodes[randomInt(level.heli_loop_nodes.size)];
	heliOrigin=startnode.origin;
	heliAngles=startnode.angles;
	lb=MakeHeli(heliOrigin,heliAngles,self,1);
	if(!isDefined(lb))return;
	level.littlebirdMossy = lb;
	lb.type="lb_mossy";
	lb HeliManageArray();
	lb setspeed(60,100);
	lb setyawspeed(10,45,45);
	lb thread maps\mp\_helicopter::heli_damage_monitor();
	lb thread maps\mp\_helicopter::heli_health();
	lb thread ALBSound();
	lb thread LittleBirdBlinkFx();
	lb thread FlyAboveBuildings();
	lb thread heli_fly_simple_path(loopNode);
	lb thread Strafe_AI();
	lb thread AttackTargets();
	lb endon("crashing");
	//lb endon("death");
	lb endon("crashing");
	lb endon("abandoned");
	wait 90;
	lb thread maps\mp\_helicopter::heli_leave();
}

LittleBirdBlinkFx()
{
	//self endon("death");
	level endon("game_ended");
	//self endon("death");
	self endon("crashing");
	self endon("leaving");
	self endon("abandoned");
	
	for(;;)
	{
		r = spawnfx(level.C4FXid,self GetTagOrigin("tag_engine_right"));
		triggerfx(r);
		l = spawnfx(level.C4FXid,self GetTagOrigin("tag_engine_left"));
		triggerfx(l);
		wait .2;
		r Delete();
		l Delete();
	}
}
AttackTargets()
{
	level endon("game_ended");
	//self endon("death");
	self endon("crashing");
	self endon("leaving");
	self endon("abandoned");
	
	for(;;)
	{
		Target = GetVictim();
		self setTurretTargetEnt(Target,(0,0,40));
		self setVehWeapon("rpg_mp");
		self setTurretTargetEnt(Target,(0,0,40));
		
		for(i=0;i<10;i++)
			self FireWeapon("",Target,Target.origin);
		
		wait RandomfloatRange(2,5);
		
		self thread maps\mp\_helicopter::check_owner();
		
		if(!CanTargetTurret(Target))
			Target = GetVictim();
		
		self setVehWeapon("gl_m4_mp");
		self setTurretTargetEnt(Target,(0,0,40));
		
		for(i=0;i<10;i++)
			self FireWeapon("",Target,Target.origin);
		
		wait RandomfloatRange(5,10);
		
		self thread maps\mp\_helicopter::check_owner();
	}
}

GetVictim()
{
	victims = [];
	
	for(i=0;i<level.players.size;i++)
	{
		player = level.players[i];
		
		if(!CanTargetTurret(player) || !CanTargetSecondary(player))
			continue;
		victims[victims.size] = player;
	}
	
	AimedPlayer = undefined;
	
	for(i=0;i<victims.size;i++)
	{
		player = victims[i];
		
		if(isDefined(AimedPlayer))
		{
			if(closer(self getTagOrigin("tag_origin"),player getTagOrigin("back_mid"),AimedPlayer getTagOrigin("back_mid")))AimedPlayer = player;
		}
		else
			AimedPlayer = player;
	}
	return AimedPlayer;
}
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//STEALTH BOMBER

stealthbomber()
{
	self beginLocationselection("map_artillery_selector",level.artilleryDangerMaxRadius * 1.2);
	self.selectingLocation = true;
	
	self waittill("confirm_location",location);
	
	self GiveTriggerz("",4,0,0,"");
	self.ready["SB"] = false;
	
	
	newLocation = PhysicsTrace(location +(0,0,100),location -(0,0,100));
	self endLocationselection();
	self.selectingLocation = undefined;
	wait .5;
	Location = newLocation;
	wait 1.5;
	locationYaw = maps\mp\gametypes\_hardpoints::getBestPlaneDirection( location );
	flightPath = getFlightPath( location, locationYaw, 0 );
	level thread Move( self, flightPath,location );
}
Move( owner, flightPath, location )
{
	if (!isDefined(owner)) return;
	start = flightpath["start"];
	end = flightpath["end"];
	middle = location+(0,0,1500);
	spinTostart = Vectortoangles(flightPath["start"] - flightPath["end"]);
	spinToEnd = Vectortoangles(flightPath["end"] - flightPath["start"]);
	
	MultiExe("Allies",owner,owner,"Stealth bomber","f");
	
	lb = SpawnPlane( owner, "script_model", start );
	lb setModel("vehicle_mig29_desert");
	lb.angles=spinToend;
	lb playLoopSound("veh_mig29_dist_loop");
	lb endon( "death" );
	time = calc(800, lb.origin, middle);
	lb moveto(middle, time);
	lb thread planebomb(owner,location);
	lb moveto(end, time);
	wait time;
	lb notify("planedone");
	lb notify("endbomb");
	lb delete();
}
calc(speed, origin, moveTo)
{
	return (distance(origin, moveTo) / speed);
}
planebomb(owner)
{
	//self endon("death");
	self endon("disconnect");
	self endon("endbomb");
	
	for(;;)
	{
		bomb = spawn("script_model", self.origin - (0, 0, 80));
		bomb setModel("projectile_cbu97_clusterbomb");
		bomb.angles = (90,50,50);
		bomb.KillCamEnt = bomb;
		bomb moveGravity( vector_scale( anglestoforward( bomb.angles ), 7000/4 ), 3.0 );
	
		bomb playsound("hind_helicopter_secondary_exp");
		bomb playsound("artillery_impact");
		playRumbleOnPosition("artillery_rumble", self.origin);
		earthquake(2, 2, self.origin, 2500);
		thread bombact(bomb,owner);
		wait .2;
	}
}
bombact(bomb,owner)
{
	wait .5;
	Playfx(level.Firework, bomb.origin);
	Playfx(level.SmallFirework, bomb.origin);
	RadiusDamage(bomb.origin,500,350,50,owner,"MOD_PROJECTILE_SPLASH","artillery_mp");
	wait 1;
	bomb delete();
}


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// AC130 + REAPER



DoAC130(option)
{
	if((option == "AC-130" && isDefined(level.AC130)) || (option == "AGM Reaper" && isDefined(level.Reaper)))
	{
		self iprintln("^1Air space too crowded");
		
		wait .1;
		
		self notify("RemoteKillstreakOver");
		return;
	}
	
	//wait 20;
	
	if(option == "AC-130")
		self.ready["AC"] = false;
	else
		self.ready["RE"] = false;
	
	switch(level.script)
	{
		case "mp_bloc": Ac130Loc = (1100,-5836,1800);
		break;
		case "mp_crossfire": Ac130Loc = (4566,-3162,1800);
		break;
		case "mp_citystreets": Ac130Loc = (4384,-469,1500);
		break;
		case "mp_creek": Ac130Loc = (-1595,6528,2000);
		break;
		default: level.mapCenter = maps\mp\gametypes\_spawnlogic::findBoxCenter(level.spawnMins,level.spawnMaxs);
		Ac130Loc = maps\mp\gametypes\_copter::getAboveBuildingslocation(level.mapCenter);
	}
	AC130_SPECTRE(Ac130Loc,option);
}


AC130_SPECTRE(Ac130Loc,option)
{
	
	
	startNode = level.heli_start_nodes[randomInt(level.heli_start_nodes.size)];
	StartPos = (startNode.origin[0],startNode.origin[1],Ac130Loc[2]);
	AC130 = SpawnPlane(self,"script_model",StartPos);
	AC130 setModel("vehicle_mig29_desert");
	AC130.angles = VectorToAngles(Ac130Loc-StartPos);
	AC130.owner = self;
	AC130.team = self.team;
	AC130 MoveTo(Ac130Loc,2.5);
	vec = Ac130Loc -(0,0,10000);
	wait .05;
	self DetachAll();
	self SetModel("");
	wait .05;
	self LinkTo(AC130,"tag_origin",(0,0,-100),(0,0,0));
	self SetPlayerAngles(VectortoAngles(vec-self getEye()));
	 
	MultiExe("Allies",self,self,option,"f");
	MultiExe("Axis",self,self,option,"e");
	
	AC130 thread PlayAC130Fx(1);
	thread maps\mp\gametypes\_hardpoints::callStrike_planeSound(AC130,AC130.origin);
	
	if(option == "AC-130")
	{
		self AllowADS(false);
		self.AC130 = true;
		level.AC130=AC130;
		flytime = 400;
		zoffset = randomint(512);
		Cannons = InitAC130Guns(self);
		self.AC130MyCannon=0;
		self [[cannons[self.AC130MyCannon].function]]();
		self setClientDvar("cg_fovScale",cannons[self.AC130MyCannon].zoom);
		self.SpectreAmmo[0]=0;
		self.SpectreAmmo[1]=0;
		self.SpectreAmmo[2]=0;
		reloading = AC130UI(AC130,self);
		self thread CannonsCycle(AC130,cannons);
		self thread CannonsFire(cannons,reloading,AC130);
		self thread CannonAutoReload(1,2.5/5);
		AC130.Guns=Cannons;
	}
	else
	{
		self.ReaperAGM = true;
		level.Reaper = AC130;
		Weapon105MM();
		reaperHUD = ReaperUI(AC130,self);
		zoffset = 0;
		self thread MonitorAGMCannon(reaperHUD);
		self thread ReaperZoom();
		flytime=50000000;
	}
	self thread ToggleAC130Vision();
	r = randomintrange(-512,512);
	radius = 1500 + r;
	AC130.zoffset=zoffset;
	
	for(i=0;i<flytime;i++)
	{
		x=Ac130Loc[0] - radius * cos(i);
		y=Ac130Loc[1] - radius * sin(i);
		z=Ac130Loc[2]+1000+zoffset;
		AC130.origin =(x,y,z);
		AC130.angles =(0,270+i,0);
		wait .1;
		if(self.sessionstate == "spectator" || self.team != AC130.team || !isDefined(self) || isReallyDead(self) || (option == "AGM Reaper" && !self.ReaperAGM) || (option=="AC-130" && !self.AC130))	break;
	}
	
	random_leave_node = randomInt(level.heli_leavenodes.size);
	leavenode=level.heli_leavenodes[random_leave_node];
	AC130 notify("leaving");
	
	if(option == "AC-130")
	{
		self.AC130 = false;
		for(i=0;i<AC130.Guns.size;i++)AC130.Guns[i].name Destroy();
	}
	else 
		self.ReaperAGM = false;
	
	
	self unlink();
	self notify("RemoteKillstreakOver");
	AC130.angles=VectorToAngles((leavenode.origin[0]*2.5,leavenode.origin[1]*2.5,AC130.origin[2])-AC130.origin);
	AC130 MoveTo((leavenode.origin[0]*2.5,leavenode.origin[1]*2.5,AC130.origin[2]+500),20);

	if(option == "AC-130")
	{
		for(i=0;i<5;i++)
		{
			FlarePos=AC130.origin - vector_scale(VectorNormalize(AnglesToForward(AC130.angles)),200);
			playfx(level.chopper_fx["fire"]["trail"]["large"],FlarePos);
			wait .5;
			playfx(level.SmallFireWork,FlarePos);
			wait 1.5;
		}
	}
	else
	{
		for(i=0;i<10;i++)
		{
			FlarePos=AC130.origin - vector_scale(VectorNormalize(AnglesToForward(AC130.angles)),200);
			playfxontag(level.fx_airstrike_contrail,self,"tag_right_wingtip");
			playfxontag(level.fx_airstrike_contrail,self,"tag_left_wingtip");
			wait 1;
		}
	}
	AC130 Delete();
}
Weapon105MM()
{
	origins = StrTok("21,0,2,24,-20,0,2,24,0,-11,40,2,0,11,40,2,0,-39,2,57,0,39,2,57,-48,0,57,2,49,0,57,2,-155,-122,2,21,-155,122,2,21,155,122,2,21,155,-122,2,21,-145,132,21,2,145,-132,21,2,-145,-132,21,2,145,132,21,2",",");
	j=0;
	for(i=0;i<origins.size;i+=4)
	{
		self.ACHud[0][j]=createHuds(int(origins[i]),int(origins[i+1]),int(origins[i+2]),int(origins[i+3]));
		j++;
	}
}
Weapon40MM()
{
	origins = StrTok("0,-70,2,115,0,70,2,115,-70,0,115,2,70,0,115,2,0,-128,14,2,0,128,14,2,-128,0,2,14,128,0,2,14,0,-35,8,2,0,35,8,2,-29,0,2,8,29,0,2,8,-64,0,2,9,64,0,2,9,0,-85,10,2,0,85,10,2,-99,0,2,10,99,0,2,10",",");
	j=0;
	for(i=0;i<origins.size;i+=4)
	{
		self.ACHud[1][j]=createHuds(int(origins[i]),int(origins[i+1]),int(origins[i+2]),int(origins[i+3]));
		j++;
	}
}
Weapon25MM()
{
	origins=StrTok("21,0,35,2,-21,0,35,2,0,25,2,46,-60,-57,2,22,-60,57,2,22,60,57,2,22,60,-57,2,22,-50,68,22,2,50,-68,22,2,-50,-68,22,2,50,68,22,2,6,9,1,7,9,6,7,1,11,14,1,7,14,11,7,1,16,19,1,7,19,16,7,1,21,24,1,7,24,21,7,1,26,29,1,7,29,26,7,1,36,33,6,1",",");
	j=0;
	for(i=0;i<origins.size;i+=4)
	{
		self.ACHud[2][j]=createHuds(int(origins[i]),int(origins[i+1]),int(origins[i+2]),int(origins[i+3]));
		j++;
	}
}

InitAC130Guns(gunner)
{
	xoffset=0;
	yoffset=0;
	if(level.console)
	{
		xoffset=10;
		yoffset=10;
	}
	cannons=[];
	for(i=0;i<3;i++)cannons[i]=SpawnStruct();
	

	cannons[0].name = gunner createFontString("DAStacks",2);
	cannons[0].name SetPoint("BOTTOM RIGHT","BOTTOM RIGHT",-70+xoffset,-170+yoffset);
	cannons[0].name SetText("105MM");
	cannons[0].name.foreground=true;
	cannons[0].zoom=1;
	cannons[0].ammo=1;
	cannons[0].reloadtime=5;
	cannons[0].reloading=false;
	cannons[0].function=::Weapon105MM;
	cannons[0].MagicBullet="projectile_cbu97_clusterbomb";
	cannons[0].BulletTime=.05;
	cannons[0].ExplodeFx1=level.chopper_fx["explode"]["large"];
	cannons[0].ExplodeFx2=loadfx("explosions/tanker_explosion");
	cannons[0].TraceFx=level.rpgeffect;
	cannons[0].FireSound="weap_cobra_missile_fire";
	cannons[0].ExplodeSound="exp_suitcase_bomb_main";
	cannons[0].range=550;
	cannons[0].min=150;
	cannons[0].max=300;
	cannons[0].scale=0.4;
	cannons[0].duration=1.0;
	cannons[0].radius=3500;
	cannons[1].name=gunner createFontString("DAStacks",2);
	cannons[1].name SetPoint("BOTTOM RIGHT","BOTTOM RIGHT",-70+xoffset,-120+yoffset);
	cannons[1].name SetText("40MM");
	cannons[1].name.foreground=true;
	cannons[1].zoom=0.55;
	cannons[1].ammo=5;
	cannons[1].reloadtime=3;
	cannons[1].reloading=false;
	cannons[1].function=::Weapon40MM;
	cannons[1].MagicBullet="projectile_rpg7";
	cannons[1].BulletTime=.05/2;
	cannons[1].ExplodeFx1=level.chopper_fx["explode"]["medium"];
	cannons[1].ExplodeFx2=level._effect["grenade"][4];
	cannons[1].TraceFx=level.chopper_fx["smoke"]["trail"];
	cannons[1].FireSound="weap_m203_fire_plr";
	cannons[1].ExplodeSound="hind_helicopter_secondary_exp";
	cannons[1].range=250;
	cannons[1].min=80;
	cannons[1].max=150;
	cannons[1].scale=0.2;
	cannons[1].duration=0.5;
	cannons[1].radius=2000;
	cannons[2].name=gunner createFontString("DAStacks",2);
	cannons[2].name SetPoint("BOTTOM RIGHT","BOTTOM RIGHT",-70+xoffset,-70+yoffset);
	cannons[2].name SetText("25MM");
	cannons[2].name.foreground=true;
	cannons[2].zoom=0.25;
	cannons[2].ammo=25;
	cannons[2].reloadtime=1.5;
	cannons[2].reloading=false;
	cannons[2].function=::Weapon25MM;
	cannons[2].MagicBullet="projectile_m203grenade";
	cannons[2].BulletTime=.05/5;
	cannons[2].ExplodeFx1=level._effect["grenade"][1];
	cannons[2].ExplodeFx2=level._effect["grenade"][2];
	cannons[2].TraceFx=level.noobeffect;
	cannons[2].FireSound="weap_g3_fire_plr";
	cannons[2].ExplodeSound="artillery_impact";
	cannons[2].range=100;
	cannons[2].min=20;
	cannons[2].max=51;
	cannons[2].scale=0;
	cannons[2].duration=0;
	cannons[2].radius=0;
	return cannons;
}
CannonsCycle(lb,cannons)
{
	lb endon("leaving");

	self iprintlnbold("Press [{+smoke}] to change canon");
	
	for(;;)
	{
		//self waittill_any("L2","TRIANGLE");
		if(self secondaryoffhandbuttonpressed())
		{
			self notify("CannonsCycle");
			self PlayLocalSound("detpack_pickup");
			self.AC130MyCannon++;
			
			if(self.AC130MyCannon>2) self.AC130MyCannon = 0;
			self [[cannons[self.AC130MyCannon].function]]();
			self setClientDvar("cg_fovScale",cannons[self.AC130MyCannon].zoom);
			
			for(i=0;i<3;i++)
			{
				cannons[i].name.color =(192/255,192/255,192/255);
				cannons[i].name.alpha=.7;
			}
			cannons[self.AC130MyCannon].name.color =(1,1,1);
			cannons[self.AC130MyCannon].name.alpha=1;
			
			wait .3;
		}
		wait .05;
	}
}
CannonsFire(cannons,reloading,AC130)
{
	for(;;)
	{
		if(self AttackButtonPressed())
		{
			if(cannons[self.AC130MyCannon].reloading)reloading.alpha=1;
			else
			{
				reloading.alpha = 0;
				if(self.AC130MyCannon == 1) wait .125;
				if(self.AC130MyCannon == 0) earthquake(0.2,1,self.origin,1000);
				else if(self.AC130MyCannon==1)earthquake(0.1,0.5,self.origin.origin,1000);
				thread VaderBullet(AC130 GetTagOrigin("tag_origin")-(0,0,AC130.zoffset/1.25),cannons[self.AC130MyCannon].MagicBullet,cannons[self.AC130MyCannon].Firesound,100,cannons[self.AC130MyCannon].BulletTime,cannons[self.AC130MyCannon].TraceFx,cannons[self.AC130MyCannon].ExplodeSound,cannons[self.AC130MyCannon].explodefx1,cannons[self.AC130MyCannon].explodefx2,cannons[self.AC130MyCannon].range,cannons[self.AC130MyCannon].max,cannons[self.AC130MyCannon].min,cannons[self.AC130MyCannon].scale,cannons[self.AC130MyCannon].duration,cannons[self.AC130MyCannon].radius);
				self.SpectreAmmo[self.AC130MyCannon]++;
				if(self.SpectreAmmo[self.AC130MyCannon]>=cannons[self.AC130MyCannon].ammo)
				{
					cannons[self.AC130MyCannon].reloading = true;
					self thread CannonReloading(cannons[self.AC130MyCannon],reloading,self.AC130MyCannon);
				}
			}
		}
		wait .1;
		if(!self.AC130)
			break;
	}
}
VaderBullet(start,model,firesound,move,duration,TraceFx,explodesound,explodefx1,explodefx2,range,max,min,scale,time,radius)
{
	vec=anglestoforward(self getPlayerAngles());
	Bullet=spawn("script_model",start);
	Bullet setModel(model);
	Bullet.angles=self getPlayerAngles();
	Bullet.owner=self;
	Bullet playsound(firesound);
	
	for(i=350;i > 0;i--)
	{
		speed =(vec[0] * move,vec[1] * move,vec[2] * move);
		if(model == "vehicle_mig29_desert")
		{
			Bullet thread maps\mp\gametypes\_hardpoints::playPlaneFx();
			if((i%5)==0) playFxOnTag(level.chopper_fx["smoke"]["trail"],Bullet,"tag_origin");
		}
		else if(model=="projectile_cbu97_clusterbomb_tail")
		{
			Bullet RotatePitch(-5,.1);
			Bullet RotateVelocity(vector_scale(VectorNormalize(self GetCursorPos()),1000),.1);
			playFx(loadfx("fire/fire_smoke_trail_m"),Bullet.origin);
			playFx(loadfx("fire/fire_smoke_trail_m"),Bullet.origin);
			playFx(loadfx("props/barrel_ignite"),Bullet.origin);
		}
		else if(model=="projectile_m84_flashbang_grenade")
		{
			if((i%20)==0)playfx(level.WaterFx,Bullet.Origin);
		}
		if(Bullettracepassed(Bullet.origin,Bullet.origin + speed,true,self)&& !Bullet MissileDetectHelis(256,false))
		{
			Bullet moveto(Bullet.origin + speed,duration);
			playFxOnTag(TraceFx,Bullet,"tag_origin");
		}
		else break;
		wait 0.01;
	}
	wait 0.05;
	Bullet playsound(explodesound);
	if(isDefined(explodefx1))Playfx(explodefx1,Bullet.origin);
	if(isDefined(explodefx2))Playfx(explodefx2,Bullet.origin);
	RadiusDamage(Bullet.origin,range,max,min,self,"MOD_PROJECTILE_SPLASH","artillery_mp");
	position=Bullet.origin;
	Bullet Delete();
	if(!isDefined(scale))scale=0.2;
	if(!isDefined(time))time=0.5;
	if(!isDefined(radius))time=2000;
	Earthquake(scale,time,position,radius);
}
CannonReloading(cannon,reloading,c)
{
	reloading.alpha = 1;
	wait cannon.reloadtime;
	cannon.reloading=false;
	reloading.alpha=0;
	self.SpectreAmmo[c]=0;
}
CannonAutoReload(num,time)
{
	for(;;)
	{
		wait time;
		if(self.SpectreAmmo[num] > 0) self.SpectreAmmo[num]--;
	
		if(!self.AC130)
		{
			self.SpectreAmmo[0]=0;
			self.SpectreAmmo[1]=0;
			self.SpectreAmmo[2]=0;
			break;
		}
	}
}
PlayAC130Fx(s)
{
	self endon("death");
	level endon("game_ended");
	
	wait 1;
	self maps\mp\gametypes\_hardpoints::playPlaneFx();
	wait 1;
	
	for(;;)
	{
		playfxontag(level.noobeffect,self,"tag_right_wingtip");
		playfxontag(level.noobeffect,self,"tag_left_wingtip");
		if(s)playfx(level.fx[15],self.origin-(0,0,550));
		wait .3;
	}
}
AC130UI(lb,owner)
{
	y = 175;
	if(level.console)y = 155;
	
	AC130["Reloading"] = owner createFontString("default",2);
	AC130["Reloading"] setPoint("CENTRE","CENTRE",0,y);
	AC130["Reloading"] setText("Reloading...");
	AC130["Reloading"].alpha = 0;
	AC130["Reloading"].ff = false;
	AC130["Misc"]=owner createFontString("default",2.5);
	AC130["Misc"] SetPoint("TOP LEFT","TOP LEFT",18,20);
	AC130["Misc"].foreground = true;
	AC130["Misc"] setText("0    AG    MAN    NARO\n\nRAY\n\nFF30\n\nLIR\n\n\nBOR");
	AC130["timer"]=owner createFontString("objective",2);
	AC130["timer"] setPoint("TOP RIGHT","TOP RIGHT",-60,40);
	AC130["timer"] setTimer(40.0);
	AC130["static"]=CreateFullIcon("overlay_tag_it",.65,(0.2,0.4,0.4));
	
	thread DynamicAC130HUDS(AC130,owner);
	keys = GetArrayKeys(AC130);
	
	for(k=0;k < keys.size;k++)
	{
		owner thread DestroyIf(AC130[keys[k]]);
		AC130[keys[k]] thread DestroyOnLeaving(owner);
	}
	return AC130["Reloading"];
}
DisplayCursorPos(owner)
{
	for(;;)
	{
		self SetValue(Length(owner.origin - owner GetCursorPos()));
		wait 0.2;
		if(!level.killstreaks.AC130)
		{
			self Destroy();
			break;
		}
	}
}
DynamicAC130HUDS(AC130,owner)
{
	for(;;)
	{
		if(!AC130["Reloading"].ff)AC130["Reloading"].color =(1,1,1);
		else AC130["Reloading"].color =(193/255,205/255,205/255);
		AC130["Reloading"].ff=!AC130["Reloading"].ff;
		wait 0.2;
	}
}
DestroyAc130Huds(player)
{
	player waittill_any("death","disconnect","joined_spectators","RemoteKillstreakOver","CannonsCycle");
	if(isDefined(self))self DestroyElem();
}

MonitorAGMCannon(HUD)
{
	self endon("disconnect");
	//self endon("death");
	self endon("joined_spectators");
	self endon("joined_team");
	//self endon("spawned_player");
	self endon("RemoteKillstreakOver");
	zoom = 90;
	self.isShooting = 0;
	maxshots = 14;
	flytime = GetTime();
	
	for(;;)
	{
		wait .1;
		
		if(self AttackButtonPressed())
		{
			self.isShooting = 1;
			earthquake(0.2,1,self getEye(),1000);
			
			self playLocalSound("weap_rpg_fire_plr");
			missile = spawn("script_model",self getEye()-(0,0,30));
			missile setModel("projectile_cbu97_clusterbomb");
			missile NotSolid();
			missile SetContents(0);
			missile playLoopSound("veh_mig29_dist_loop");
			missile MissileControl(self,HUD["Values"]);
			HUD["Values"] SetValue(int(self.origin[2]));
			maxshots--;
			HUD["Missiles"][1] SetValue(maxshots);
			missile playSound(level.heli_sound["axis"]["crash"]);
			missile delete();
			self.isShooting=0;
		}
		if(((GetTime()-flytime)>=50 * 1000) || (maxshots <=0))
		break;
	}
	self.ReaperAGM=false;
}
ReaperZoom()
{
	self endon("disconnect");
	//self endon("death");
	self endon("joined_spectators");
	self endon("joined_team");
	self endon("spawned_player");
	self endon("RemoteKillstreakOver");
	for(;;)
	{
		if(self AdsButtonPressed())self setClientDvar("cg_fovScale",.4);
		else self setClientDvar("cg_fovScale",1);
		wait .1;
	}
}
ReaperUI(lb,owner)
{
	laser = createIcon("sun",64,64);
	laser setPoint("CENTER","CENTER",0,0);
	laser.color =(1,0,0);

	map=level.script;
	
	if(map!="mp_shipment" && map!="mp_bloc" && map!="mp_bog" && map!="mp_farm" && map!="mp_citystreets" && !isBonusMap(map))
	{
		laser.alpha=1;
		thread PlayLaserFx(laser);
	}
	
	else
		laser.alpha=0;
	
	T = owner createFontString("DAStacks",2.3);
	T setPoint("CENTRE","CENTRE",-100,100);
	T setvalue(int(lb.origin[2]));
	T.color =(1,1,1);
	
	Cam=owner createFontString("objective",1.5);
	Cam setPoint("CENTER","CENTER",0,-143);
	Cam setText("REMOTE UAV CAMERA");

	IR=owner createFontString("objective",1.5);
	
	if(level.console)
		IR setPoint("CENTRE","CENTRE",200,185);
	else 
		IR setPoint("CENTRE","CENTRE",200,200);
	IR setText("[{+reload}] TOGGLE THERMAL");
	
	Misc = owner createFontString("",1.5);
	Misc SetPoint("TOP LEFT","TOP LEFT",18,20);
	Misc setText("LAZER ARMED");
	Misc.foreground = true;
	
	staticBG = CreateFullIcon("nightvision_overlay_goggles",1,(0.4,0.2,0.8));
	static = CreateFullIcon("white",.4,(0.2,0.6,0.4));

	Missiles=[];
	
	for(i=0;i<2;i++)
	{
		Missiles[i]=self createFontString("default",1.5);
		Missiles[i] setPoint("CENTER","CENTER",100+50*i,100);
		Missiles[i].sort=5;
		Missiles[i].glowalpha=0;
		Missiles[i].glowcolor=(1,1,1);
		Missiles[i].fontscale=1.1;
		Missiles[i].alpha=1;
		Missiles[i].color=(1,1,1);
	}
	
	Missiles[0] setshader("hud_icon_rpg",45,25);
	Missiles[1] SetValue(14);
	
	AGM["Laser"]=laser;
	AGM["Values"]=T;
	AGM["CAM"]=Cam;
	AGM["IR"]=IR;
	AGM["Misc"]=Misc;
	AGM["staticBG"]=staticBG;
	AGM["static"]=static;
	AGM["Missiles"]=Missiles;
	
	keys=GetArrayKeys(AGM);
	
	for(k=0;k < keys.size;k++)
	{
		owner thread DestroyIf(AGM[keys[k]]);
		AGM[keys[k]] thread DestroyOnLeaving(owner);
		if(isDefined(AGM[keys[k]].size))
		{
			for(w=0;w<AGM[keys[k]].size;w++)
			{
				owner thread DestroyIf(AGM[keys[k]][w]);
				AGM[keys[k]][w] thread DestroyOnLeaving(owner);
			}
		}
	}
	return AGM;
}
PlayLaserFx(laser)
{
	self endon("disconnect");
	for(;;)
	{
		laser FadeOverTime(randomFloat(3.0));
		laser.alpha=randomFloatRange(0.4,1.0);
		wait .1;
		laser.alpha=0;
		while(Distance(self.origin,self GetCursorPos())>5000)
		{
			wait .1;
			laser.alpha=0;
		}
	}
}
MissileControl(shooter,T)
{
	turnSpeed = .05;
	rollAngle = 0;
	vecParts = 0;
	v = 0;
	vec = 0;
	time = GetTime();

	for(;;)
	{
		for(i=0;i < level.fx.size;i++) playFX(loadfx("fire/fire_smoke_trail_m"),self getTagOrigin("tag_origin"));
		pAngles=vectorToAngles(shooter traceView()- self.origin);
		self.angles=pAngles;
		flyLocation=self.origin + anglesToForward(pAngles)* 100;
		self moveTo(flyLocation,.05);
		T setvalue(int(distance(shooter traceView(),self.origin)- 70));
		trophyInRange=false;
		
		if(level.SentryTurrets.size)
		{
			for(w=0;w<level.SentryTurrets.size;w++)
			{
				if((level.SentryTurrets[w].sentry.team!=shooter.team)&&(distance(self.origin,level.SentryTurrets[w].sentry.origin)< 512)&&(level.SentryTurrets[w].trophyAmmo > 0))
				{
					trophyInRange = true;
					level.SentryTurrets[w] thread PlayTrophyFx(.5);
				}
			}
		}
		if((distance(shooter traceView(),self.origin)< 70)|| self MissileDetectHelis(128,false)||((GetTime()- time)>= 10 * 1000)|| trophyInRange)
		{
			origins="200 0 0|0 200 0|200 200 0|0 0 200|100 0 0|0 100 0|100 100 0|0 0 100";
			playFX(level.chopper_fx["explode"]["medium"],shooter traceView());
			vecParts=strTok(origins,"|");
			for(i=0;i < vecParts.size;i++)
			{
				v=strTok(vecParts[i]," ");
				vec =(int(v[0]),int(v[1]),int(v[2]));
				playFX(level.chopper_fx["explode"]["medium"],shooter traceView()- vec);
				playFX(level.chopper_fx["explode"]["medium"],shooter traceView()+ vec);
			}
			earthquake(2.5,1.5,shooter traceView(),700);
			RadiusDamage(shooter traceView(),500,350,50,shooter,"MOD_PROJECTILE_SPLASH","artillery_mp");
			break;
		}
		wait .05;
	}
}


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


//OSPREY


MossyOspreyGunner(option)
{
	if(isDefined(level.littlebirdMossy) || isDefined(level.OspreyGunner) || level.helis.size > 6 || level.ospreyy)
	{
		self iprintln("^1Air space too crowded");
		
		wait .1;
		
		self notify("RemoteKillstreakOver");
		return;
	}
	
	self.inosprey = true;
	level.ospreyy = true;
	
	
	if(option == "osprey")
	{
		self.ready["OS"] = false;
		MultiExe("Allies",self,self,"Osprey Gunner","f");
		MultiExe("Axis",self,self,"Osprey Gunner","e");
	}
	else
	{
		self.ready["CG"] = false;
		MultiExe("Allies",self,self,"Chopper Gunner","f");
		MultiExe("Axis",self,self,"Chopper Gunner","e");
	}
	
	
	attackAreas = getEntArray("heli_attack_area","targetname");
	startNode = level.heli_start_nodes[randomInt(level.heli_start_nodes.size)];
	loopNode = level.heli_loop_nodes[randomInt(level.heli_loop_nodes.size)];
	heliOrigin = startnode.origin;
	heliAngles = startnode.angles;
	lb = MakeHeli(heliOrigin,heliAngles,self,1);
	
	if(!isDefined(lb))return;
	
	level.OspreyGunner = lb;
	
	lb HeliManageArray();
	lb.type = "osprey";
	lb setspeed(50,80);
	lb setyawspeed(10,45,45);
	lb EnableLinkTo();
	
	Gunner = spawn("script_model",lb getTagOrigin("tag_engine_right"));
	Gunner setModel("weapon_c4");
	Gunner Hide();
	Gunner linkTo(lb,"tag_engine_right",(0,0,0),(0,0,0));
	
	wait .05;
	self SetClientDvar("cg_thirdPersonRange","512");
	self DetachAll();
	self SetModel("");
	wait .05;
	self LinkTo(Gunner,"tag_origin",(0,0,-200),(0,0,0));
	wait .05;
	self.MyDecoy.origin = self.MyOrigin;
	VisionSetNight("ac130",1.5);
	Osprey25MMGun(lb);
	lb thread FlyAboveBuildings();
	lb thread heli_fly_simple_path(loopNode);
	lb thread Osprey_check_owner();
	lb thread FireMiniGunOnCMD();
	self thread OspreyGunnerHUD(lb,option);
	self thread ManualTargeting(lb);
	self thread ToggleAC130Vision();
	wait 90;
	lb thread maps\mp\_helicopter::heli_leave();
	wait 2;
	self.inosprey = false;
	level.ospreyy = false;
	level.OspreyGunner = undefined;
	self notify("RemoteKillstreakOver");
}
Osprey_check_owner()
{
	//self endon("death");
	self endon("crashing");
	self endon("leaving");
	self.owner waittill_any("disconnect","death","joined_spectators","spawned_player","joined_team");
	self notify("abandoned");
	level.OspreyGunner=undefined;
	self.owner notify("RemoteKillstreakOver");
	wait .05;
	self thread maps\mp\_helicopter::heli_leave();
}
ManualTargeting(lb)
{
	self endon("disconnect");
	//self endon("death");
	self endon("RemoteKillstreakOver");
	//lb endon("death");
	lb endon("crashing");
	lb endon("leaving");
	
	if(isDefined(self.CrossHairs))
		self.CrossHairs delete();
	
	self.CrossHairs = spawn("script_model",(0,0,0));
	self.CrossHairs setModel("weapon_c4");
	self.CrossHairs Hide();
	self Hide();

	for(;;)
	{
		self.CrossHairs.origin = GetCursorPos();
		Line(self.origin,self.CrossHairs.origin,(0,1,0),false,100);
		wait 0.05;
	}
}
FireMiniGunOnCMD()
{
	owner=self.owner;
	owner endon("disconnect");
	//owner endon("death");
	owner endon("RemoteKillstreakOver");
	//self endon("death");
	self endon("crashing");
	self endon("leaving");
	wait 1;
	self setVehWeapon("m60e4_mp");
	self setTurretTargetEnt(owner.CrossHairs,(0,0,0));
	for(;;)
	{
		if(owner AttackButtonPressed())
		{
			self FireWeapon("tag_flash",owner.CrossHairs,(0,0,0),.05);
			if(CanTargetSecondary(owner.CrossHairs))RadiusDamage(owner.CrossHairs.origin,75,30,10,owner,"MOD_EXPLOSIVE","cobra_20mm_mp");
		}
		wait 0.05;
	}
}
OspreyDropCrate(owner,careText)
{
	owner endon("disconnect");
	//owner endon("death");
	owner endon("RemoteKillstreakOver");
	//self endon("death");
	self endon("crashing");
	self endon("leaving");
	self playSound("oldschool_return");
	wait 15;
	
	for(;;)
	{
		self playSound("oldschool_return");
		careText.alpha=1;
	
		if(self secondaryoffhandbuttonpressed())
		{
			careText.alpha=0;
			self ForceDropCrate();
		}
		wait 15;
	}
}
OspreyGunnerHUD(lb,option)
{
	yoffset=0;
	Osprey["IR"]=self createFontString("objective",1.5);
	Osprey["IR"] setPoint("CENTRE","CENTRE",200,100);
	Osprey["IR"] setText("25MM\n\n\n\n[{+reload}] Toggle thermal");
	Osprey["T"]=self createFontString("objective",1.5);
	Osprey["T"] setPoint("CENTRE","CENTRE",0,0);
	Osprey["T"] setText(&"MP_PLUS");
	Osprey["T"].color =(1,0,0);
	Osprey["T"].alpha=0;
	Osprey["staticBG"]=CreateFullIcon("nightvision_overlay_goggles",1,(0,0.6,0.4));
	Osprey["static"]=CreateFullIcon("popmenu_bg",.95,(0.2,0.4,0.4));
	Osprey["static"] fadeOverTime(10);
	Osprey["static"].alpha=.35;
	Osprey["D"]=self createFontString("",1.5);

	if(level.console)
	{
		Osprey["D"] setPoint("CENTRE","CENTRE",0,170);
		yoffset=30;
	}
	
	else Osprey["D"] setPoint("CENTRE","CENTRE",0,178);
	Osprey["X"] = self createFontString("",1.5);
	Osprey["X"] setPoint("CENTRE","CENTRE",0,-180);
	Osprey["Y"] = self createFontString("",1.5);
	Osprey["Y"] setPoint("CENTRE","CENTRE",-100,-180);
	Osprey["Z"] = self createFontString("",1.5);
	Osprey["Z"] setPoint("CENTRE","CENTRE",100,-180);
	Osprey["careText"] = self createFontString("",1.5);
	Osprey["careText"] setPoint("CENTRE","CENTRE",-140,-230+yoffset);
	Osprey["careText"] SetText("PRESS [{+smoke}] TO DROP CRATE");
	Osprey["careText"].alpha=0;
	Osprey["careText"].ff=false;
	careText=Osprey["careText"];
	self SetclientDvars("r_blur",5,"r_contrast",2.5);
	self thread DecreaseBlur();
	self thread OspreyDetectEnemy(Osprey["T"]);
	if(option == "osprey")
	lb thread OspreyDropCrate(self,Osprey["careText"]);
	keys=getArrayKeys(Osprey);
	for(k=0;k < keys.size;k++)
	{
		self thread DestroyElemOnDeath(Osprey[keys[k]],2);
		Osprey[keys[k]] thread DestroyOnLeaving(self);
	}
	self endon("disconnect");
	//self endon("death");
	self endon("RemoteKillstreakOver");
	lb endon("death");
	lb endon("crashing");
	lb endon("leaving");
	
	for(;;)
	{
		Osprey["D"] SetValue(Length(self.origin - self GetCursorPos()));
		Osprey["X"] SetValue(self.origin[0]);
		Osprey["Y"] SetValue(self.origin[1]);
		Osprey["Z"] SetValue(self.origin[2]);
		if(!careText.ff)careText.color =(0.4,0.4,0.8);
		else careText.color =(0.4,0.6,0.8);
		careText.ff=!careText.ff;
		ent=self GetCursorEnt();
		wait 0.2;
	}
}

MossylbDestroy()
{
	self notify("crashing");
	self SetSpeed(25,5);
	self thread harrierSpin(RandomIntRange(180,220));
	wait(RandomFloatRange(.5,1.5));
	self playSound(level.heli_sound["axis"]["crash"]);
	deathAngles=self getTagAngles("tag_origin");
	playFx(level.chopper_fx["explode"]["large"],self getTagOrigin("tag_origin"),anglesToForward(deathAngles),anglesToUp(deathAngles));
	wait(0.05);
	self Delete();
}
heli_fly_simple_path(startNode)
{
	//self endon("death");
	self endon("leaving");
	self notify("flying");
	self endon("flying");
	maps\mp\_helicopter::heli_reset();
	currentNode=startNode;
	while(isDefined(currentNode.target))
	{
		nextNode=getEnt(currentNode.target,"targetname");
		assertEx(isDefined(nextNode),"Next node in path is undefined,but has targetname");
		if(isDefined(currentNode.script_airspeed)&& isDefined(currentNode.script_accel))
		{
			heli_speed=currentNode.script_airspeed;
			heli_accel=currentNode.script_accel;
		}
		else
		{
			heli_speed=30 + randomInt(20);
			heli_accel=15 + randomInt(15);
		}
		self SetSpeed(heli_speed,heli_accel);
		if(!isDefined(nextNode.target))
		{
			self setVehGoalPos(nextNode.origin+(self.zOffset),true);
			self waittill("near_goal");
		}
		else
		{
			self setVehGoalPos(nextNode.origin+(self.zOffset),false);
			self waittill("near_goal");
			self setGoalYaw(nextNode.angles[ 1 ]);
			self waittillmatch("goal");
		}
		currentNode=nextNode;
	}
	printLn(currentNode.origin);
	printLn(self.origin);
}
DecreaseBlur()
{
	self endon("disconnect");
	for(i=1;i<41;i++)
	{
		self SetclientDvars("r_blur",5-.125*i,"r_contrast",2-.025*i);
		wait .2;
	}
}
OspreyDetectEnemy(t)
{
	self endon("disconnect");
	//self endon("death");
	self endon("RemoteKillstreakOver");
	
	for(;;)
	{
		for(index=0;index < level.players.size;index++)
		{
			P=level.players[index];
			if(!level.teamBased)
			{
				if(P!=self && distance(P.origin,self GetCursorPos())<128)DisplaySS(t);
			}
			else
			{
				if(P!=self && P.team!=self.team && distance(P.origin,self GetCursorPos())<128)DisplaySS(t);
			}
		}
		wait .1;
	}
}
DisplaySS(text)
{
	text.alpha=0.7;
	wait 1;
	text.alpha=0;
}
Osprey25MMGun(lb)
{
	origins=StrTok("0,-70,2,115,0,70,2,115,-70,0,115,2,70,0,115,2,0,-65,2,65,-155,-122,2,21,-155,122,2,21,155,122,2,21,155,-122,2,21,-145,132,21,2,145,-132,21,2,-145,-132,21,2,145,132,21,2",",");
	j=0;
	for(i=0;i<origins.size;i+=4)
	{
		createHuds(int(origins[i]),int(origins[i+1]),int(origins[i+2]),int(origins[i+3]),lb);
		j++;
	}
}

ForceDropCrate()
{
	location=self.origin;
	DropPoint=CrateCollisionLogic(location,location-(0,0,1000000));
	self.owner thread DropCrate(DropPoint,location,self.cratetype);
}

	
MakeHeli(SPoint,forward,owner,b)
{
	if(!isDefined(b))
		b=false;
	
	if(!b)
	{
		lb = spawnHelicopter(owner,SPoint/2,forward,"cobra_mp","vehicle_cobra_helicopter_fly");
		lb playLoopSound("mp_cobra_helicopter");
	}
	else
	{
		lb=spawnHelicopter(owner,SPoint,forward,"cobra_mp","vehicle_mi24p_hind_desert");
		lb playLoopSound("mp_hind_helicopter");
	}
	if(!isDefined(lb))return;
	lb.owner = owner;
	lb.team = owner.team;
	lb.pers["team"] = owner.team;
	lb.zOffset=(0,0,lb getTagOrigin("tag_origin")[2]-lb getTagOrigin("tag_ground")[2]);
	lb.attractor=Missile_CreateAttractorEnt(lb,level.heli_attract_strength,level.heli_attract_range);
	lb setdamagestage(4);
	lb.currentstate="ok";
	lb.attacker=undefined;
	lb.lifeId=0;
	lb SetCanDamage(true);
	lb.reached_dest=false;
	lb.maxhealth=level.heli_maxhealth*2;
	lb.waittime=level.heli_dest_wait;
	lb.loopcount=0;
	lb.evasive=false;
	lb.health_bulletdamageble=level.heli_armor;
	lb.health_evasive=level.heli_armor;
	lb.health_low=level.heli_maxhealth*0.8;
	lb.targeting_delay=level.heli_targeting_delay;
	lb.primaryTarget=undefined;
	lb.secondaryTarget=undefined;
	lb.missile_ammo=level.heli_missile_max;
	lb.lastRocketFireTime=-1;
	lb.cratetype="Care Package";
	lb.mgTurret1=spawn("script_model",lb.origin);
	lb.mgTurret1 setModel(getWeaponModel("m60e4_mp",6));
	lb.mgTurret1 linkTo(lb,"tag_engine_right",(10,10,0),(0,90,180));
	lb.mgTurret2=spawn("script_model",lb.origin);
	lb.mgTurret2 setModel(getWeaponModel("m60e4_mp",6));
	lb.mgTurret2 linkTo(lb,"tag_engine_left",(10,10,0),(0,-90,0));
	lb thread ALBDelete(self);
	return lb;
}





//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


//PREDATOR




DoPredator()
{
	self.inpredator = true;
	VisionSetNight("sepia",1);
	wait .05;
	lr = maps\mp\gametypes\_spawnlogic::findBoxCenter(level.spawnMins,level.spawnMaxs);
	Z=2000;
	x=randomintrange(-1000,1000);
	Y=randomintrange(-1000,1000);
	l= lr+(x,y,z);
	wait .05;
	
	MultiExe("Allies",self,self,"Predator Missile","f");
	MultiExe("Axis",self,self,"Predator Missile","e");
	
	vec = GetAverageOrigin(level.players);

	if(!isDefined(vec))
	{
		self iprintln("not defined");
		vec=l -(0,0,10000);
	}
	vec=l -(0,0,10000);
	self setorigin(l);
	self SetPlayerAngles(VectortoAngles(vec-self getEye()));
	
	
	Missile=spawn("script_model",self.origin);
	Missile SetModel("projectile_cbu97_clusterbomb");
	Missile.angles=VectorToAngles(self TraceView()- Missile GetTagOrigin("tag_origin"));
	Missile NotSolid();
	Missile SetContents(0);
	Missile.owner=self;
	
	
	wait .1;
	self LinkTo(Missile,"tag_origin",(0,0,10),(0,0,0));
	//wait .2;
	Missile playsound("weap_hind_missile_fire");
	Weapon105MM();
	PredatorHUD();
	
	self thread RemoteMissileHint();
	PredatorFly(Missile);
}
PredatorFly(Missile)
{
	owner=Missile.owner;
	team=owner.team;
	self.speedup=false;
	move=70;
	Missile playloopsound("veh_mig29_dist_loop");
	for(i=230;i>0;i--)
	{
		vec=anglestoforward(self getPlayerAngles());
		speed =(vec[0] * move,vec[1] * move,vec[2] * move);
		if(Bullettracepassed(self.origin,self.origin + speed,true,self))
		{
			Missile moveto(Missile.origin + speed,0.1);
			Missile.angles=VectorToAngles(owner TraceView()- Missile GetTagOrigin("tag_origin"));
			playFxOnTag(level.rpgeffect,Missile,"tag_origin");
			playFxOnTag(level._fireFX[1],Missile,"tag_origin");
		}
		else break;
		if(self attackbuttonpressed()&& !self.speedup)
		{
			Missile playsound("weap_cobra_missile_fire");
			move=move*2;
			self.speedup=true;
		}
		wait 0.01;
		if(owner.sessionstate=="spectator"||owner.team!=team||!isDefined(owner)|| Missile MissileDetectHelis(512,true))break;
		trophyInRange=false;
		if(level.SentryTurrets.size)
		{
			for(w=0;w<level.SentryTurrets.size;w++)
			{
				if((level.SentryTurrets[w].sentry.team!=owner.team)&&(distance(Missile.origin,level.SentryTurrets[w].sentry.origin)< 512)&&(level.SentryTurrets[w].trophyAmmo > 0))
				{
					trophyInRange=true;
					level.SentryTurrets[w] thread PlayTrophyFx(.5);
				}
			}
		}
		if(trophyInRange)break;
	}
	self.inpredator = false;
	PredatorBoom(Missile);
}
PredatorBoom(Missile)
{
	owner=Missile.owner;
	Missile stoploopsound("veh_mig29_dist_loop");
	Missile playsound("hind_helicopter_secondary_exp");
	Playfx(level.firework,Missile.origin);
	Playfx(level.expbullt,Missile.origin);
	Playfx(level.Clusterfx,Missile.origin);
	Playfx(level.Snowfx,Missile.origin);
	RadiusDamage(Missile.origin,300,250,100,owner,"MOD_PROJECTILE_SPLASH","artillery_mp");
	wait 0.2;
	Missile Delete();
	wait 0.05;
	owner notify("RemoteKillstreakOver");
}
PredatorHUD()
{
	staticBG=CreateFullIcon("nightvision_overlay_goggles",1,(0.4,0.2,0.8));
	static=CreateFullIcon("white",.2,(0.6,1,0.6));
	staticBG thread DestroyPredatorHuds(self);
	static thread DestroyPredatorHuds(self);
}
DestroyPredatorHuds(player)
{
	player waittill_any("death","disconnect","joined_spectators","RemoteKillstreakOver","joined_team");
	self Destroy();
}
MissileDetectHelis(d,s)
{
	lbfound=false;
	
	if(isDefined(s)&& s)
	{
		if(isDefined(level.AC130)&& distance(self.origin,level.AC130.origin)< d)lbfound=true;
		if(isDefined(level.Reaper)&& distance(self.origin,level.Reaper.origin)< d)lbfound=true;
		if(isDefined(level.RemoteJet)&& distance(self.origin,level.RemoteJet.origin)< d && level.RemoteJet!=self)lbfound=true;
	}
	
	for(i=0;i<level.helis.size;i++)
	{
		if(distance(self.origin,level.helis[i].origin)< d)
		{
			if((level.helis[i].owner==self.owner)||(level.helis[i].team!=self.owner.team))
			{
				lbfound=true;
				DamageHeli(level.helis[i]);
			}
		}
	}
	return lbfound;
}
DamageHeli(lb)
{
	switch(lb.type)
	{
		case "lb_mossy": lb thread MossylbDestroy();
		break;
		case "lb_care": lb thread DropCrateNdestroy();
		break;
		case "lb_guard": lb thread maps\mp\_helicopter::heli_crash();
		break;
		case "lb_flock": lb thread heli_explode();
		break;
		case "lb_normal": lb thread maps\mp\_helicopter::heli_crash();
		break;
		case "harrier": lb thread harrierDestroyed();
		break;
	}
}
RemoteMissileHint()
{
	
	wait 2;
	self iprintlnBold("[{+attack}] SPEED BOOST");
	wait 4;
	ClearPrint(1);
}



GetAverageOrigin(ent_array)
{
	avg_origin =(0,0,0);
	if(!ent_array.size)return undefined;
	for(i=0;i<ent_array.size;i++)
	{
		ent=ent_array[i];
		avg_origin += ent.origin;
	}
	avg_x=int(avg_origin[ 0 ] / ent_array.size);
	avg_y=int(avg_origin[ 1 ] / ent_array.size);
	avg_z=int(avg_origin[ 2 ] / ent_array.size);
	avg_origin =(avg_x,avg_y,avg_z);
	return avg_origin;
}




//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


//AH-6 OVERWATCH

LittleBirdGuard()
{
	if(isDefined(level.LittleBirdGuard) || level.helis.size > 6)
	{
		self iprintln("^1Air space too crowded");
		self switchtoweapon(self.laptopcurweap);
		return;
	}
	
	self GiveTriggerz("",4,0,0,"");
	self.ready["AO"] = false;
	
	MultiExe("Allies",self,self,"AH-6 Overwatch","f");
	MultiExe("Axis",self,self,"AH-6 Overwatch","e");
	
	
	startNode = level.heli_start_nodes[randomInt(level.heli_start_nodes.size)];
	leaveNode = level.heli_leave_nodes[randomInt(level.heli_leave_nodes.size)];
	rand = randomInt(500);
	start = startNode.origin+(0,0,rand);
	goal = (self.origin[0],self.origin[1],start[2]);
	vc = StrafeCopter(self,start,vectorToAngles(goal-start));
	vc HeliManageArray();
	vc.type = "lb_guard";
	level.LittleBirdGuard=vc;
	vc thread maps\mp\_helicopter::heli_damage_monitor();
	vc thread maps\mp\_helicopter::heli_health();
	vc.zOffset = (0,0,vc getTagOrigin("tag_origin")[2]-vc getTagOrigin("tag_ground")[2]);
	vc setspeed(60,100);
	vc setyawspeed(10,45,45);
	flyTo = getnewpos(self.origin+(0,0,getCorrectHeight(self.origin[0],self.origin[1],20)),200);
	vc setVehGoalPos(flyTo,5);
	wait 5;
	vc thread Strafe_AI(1,"AH6");
	
	for(i=0;i<10;i++)
	{
		if(!isdefined(vc.owner) || !isdefined(vc.owner.pers["team"]) || vc.owner.pers["team"] != vc.team || vc.owner.sessionstate == "spectator"||!isAlive(vc))
		break;
		flyTo=getnewpos(self.origin+(0,0,getCorrectHeight(self.origin[0],self.origin[1],20)),200);
		vc setVehGoalPos(flyTo,1);
		vc.angles=vectorToAngles(flyTo-vc.origin);
		wait 5;
	}
	
	if(isDefined(vc)&& isAlive(vc))
	{
		vc ClearLookAtEnt();
		vc maps\mp\_helicopter::heli_leave();
	}
}
getnewPos(origin,radius)
{
	pos=origin +((randomfloat(2)-1)*radius,(randomfloat(2)-1)*radius,0);
	while(distanceSquared(pos,origin)> radius*radius)pos=origin +((randomfloat(2)-1)*radius,(randomfloat(2)-1)*radius,0);
	return pos;
}

   

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


//STRAFE RUN



Start_Strafe()
{
	if(level.StrafeRun || level.helis.size >3)
	{
		self iprintln("^1air space too crowded");
		self switchtoweapon(self.laptopcurweap);
		return;
	}
	Location = GetMapPos();
	
	if(!isDefined(Location) || level.StrafeRun || level.helis.size>3)
		return;
		
	self GiveTriggerz("",4,0,0,"");
	level.StrafeRun = true;
	
	if(self.team == "allies")
		level.StrafeRunTeam["allies"] = true;
	else if(self.team == "axis")
		level.StrafeRunTeam["axis"] = true;
	
	self.ready["SR"] = false;
	wait 1;
	
	MultiExe("Allies",self,self,"Strafe Run","f");
	MultiExe("Axis",self,self,"Strafe Run","e");
	
	wait 1.5;
	locationYaw = maps\mp\gametypes\_hardpoints::getBestPlaneDirection(location);
	flightPath1 = GetFlightPath(location,locationYaw,0);
	flightPath2 = GetFlightPath(location,locationYaw,-620);
	flightPath3 = GetFlightPath(location,locationYaw,620);
	flightPath4 = GetFlightPath(location,locationYaw,-1140);
	flightPath5 = GetFlightPath(location,locationYaw,1140);
	level thread DoStrafeRun(self,flightPath1);
	wait(0.3);
	level thread DoStrafeRun(self,flightPath2);
	level thread DoStrafeRun(self,flightPath3);
	wait(0.3);
	level thread DoStrafeRun(self,flightPath4);
	level thread DoStrafeRun(self,flightPath5);
	
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
	lb HeliManageArray();
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
	lb SetCanDamage(true);
	lb SetContents(1);
	lb Solid();
	lb playLoopSound("mp_cobra_helicopter");
	return lb;
}
HeliManageArray()
{
	self addToHeliList();
	self thread removeHeliOnDeath();
}
removeHeliOnDeath()
{
	self waittill("death");
	removeFromHeliList(self);
}
addToHeliList()
{
	for(i=0;i<level.helis.size;i++)
	{
		if(!isDefined(level.helis[i]))continue;
		if(level.helis[i]==self)return;
	}
	level.helis[level.helis.size]=self;
}
removeFromHeliList(lb)
{
	if(isDefined(lb))lb=undefined;
	for(i=0;i<level.helis.size;i++)
	{
		if(!isDefined(level.helis[i]))continue;
		if(level.helis[i]==self)level.helis[i]=undefined;
	}
	level.helis=remove_undefined_from_array(level.helis);
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
	self endon("crashing");
	self endon("leaving");
	self endon("abandoned");
	
	for(;;)
	{
		for(i=0;i<level.players.size;i++)
		{
			if(!CanTargetTurret(level.players[i]))continue;
			PotentialTarget = level.players[i];
			
			if(isdefined(self.primaryTarget))
			{
				if(Closer(self getTagOrigin("tag_origin"),PotentialTarget getTagOrigin("back_mid")))self.primaryTarget=PotentialTarget;
			}
			else self.primaryTarget=PotentialTarget;
		}
		
		for(i=0;i<level.players.size;i++)
		{
			if((CanTargetTurret(level.players[i]))&&(level.players[i]!=self.primaryTarget))
			{
				self.secondaryTarget=level.players[i];
				break;
			}
			else self.secondaryTarget=self.primaryTarget;
		}
		if(isdefined(self.primaryTarget))
		{
			self.turretTarget=self.primaryTarget;
			self setTurretTargetEnt(self.turretTarget,(0,0,40));
			if(isDefined(lb)&& lb)self SetLookAtEnt(self.turretTarget);
			self waittill("turret_on_target");
			wait(level.heli_turret_spinup_delay);
		}
		else
		{
			self ClearLookAtEnt();
			self.primaryTarget=undefined;
			self.turretTarget=undefined;
			wait 0.1;
			continue;
		}
		
		
		if(isdefined(self.secondaryTarget)&& CanTargetSecondary(self.secondaryTarget)) 
		self thread AttackSecondary(copt);
		
		
		for(i=0;i < 500;i++)
		{
			if(!isDefined(self.turretTarget)||(!isDefined(self.primaryTarget))||(!CanTargetTurret(self.turretTarget)))
			{
				self ClearLookAtEnt();
				self.primaryTarget=undefined;
				self.turretTarget=undefined;
				break;
			}
			if(!isdefined(self.owner)|| !isdefined(self.owner.pers["team"])|| self.owner.pers["team"]!=self.team)break;
			self setVehWeapon("cobra_20mm_mp");
			self setTurretTargetEnt(self.turretTarget,(0,0,40));
			if(isDefined(lb)&& lb)self SetLookAtEnt(self.turretTarget);
			self FireWeapon("tag_flash",self.turretTarget,(0,0,0),.05);
			wait 0.01;
			if((i%100)==0)wait(level.heli_turretReloadTime);
		}
		self ClearLookAtEnt();
		if(!isdefined(self.owner)|| !isdefined(self.owner.pers["team"])|| self.owner.pers["team"]!=self.team)self notify("abandoned");
		wait 0.1;
	}
}

AttackSecondary(copt)
{
	self endon("crashing");
	self endon("leaving");
	self endon("abandoned");
	
	self setTurretTargetEnt(self.secondaryTarget,(0,0,40));
	
	for(;;)
	{
		if(!isDefined(self.secondaryTarget)||(!isPlayer(self.secondaryTarget))||(!CanTargetTurret(self.secondaryTarget)))
		{
			self.secondaryTarget=undefined;
			break;
		}
		
		if(isdefined(copt))
		{
			self setVehWeapon("cobra_20mm_mp");
		}
		else
		{
			if(self.model == "vehicle_cobra_helicopter_fly")
				self setVehWeapon("cobra_FFAR_mp");
			else
				self setVehWeapon("hind_FFAR_mp");
		}
		
		self setTurretTargetEnt(self.secondaryTarget,(0,0,40));
		self FireWeapon("",self.secondaryTarget,(0,0,0));
		wait RandomfloatRange(0.5,2.0);
	}
}
CanTargetSecondary(target_player)
{
	CanTargetSecondary=true;
	
	if(level.teambased)
	{
		for(i=0;i < level.players.size;i++)
		{
			player=level.players[i];
			if(isdefined(player.pers["team"])&& player.pers["team"]==self.team && distance(player.origin,target_player.origin)<= level.heli_missile_friendlycare*1.25)return false;
		}
	}
	else
	{
		player=self.owner;
		if(isdefined(player)&& isdefined(player.pers["team"])&& player.pers["team"]==self.team && distance(player.origin,target_player.origin)<= level.heli_missile_friendlycare*1.25)
		{
			return false;
		}
	}
	return CanTargetSecondary;
}

CanTargetTurret(player)
{
	if(!isalive(player)|| player.sessionstate!="playing")return false;
	if(distance(player.origin,self.origin)> 5000)return false;
	if(!isdefined(player.pers["team"]))return false;
	if(level.teamBased && player.pers["team"]==self.team)return false;
	if(player==self.owner)return false;
	if(player.pers["team"]=="spectator")return false;
	if(!BulletTracePassed(self getTagOrigin("tag_origin"),player getTagOrigin("j_head"),0,self))return false;
	return true;
}

GetMapPos()
{
	S=maps\mp\gametypes\_hardpoints::endSelectionOn;
	self beginLocationSelection("map_artillery_selector",level.artilleryDangerMaxRadius * 1.2);
	self.selectingLocation = true;
	self notify("Silvi");
	self thread [[S]]("cancel_location");
	self thread [[S]]("death");
	self thread [[S]]("disconnect");
	self thread [[S]]("used");
	self endon("stop_location_selection");
	self waittill("confirm_location",location);
	self notify("used");
	l=PhysicsTrace(location+(0,0,800),location-(0,0,800));
	return l+(0,0,1);
}
 




//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


//HARRIER







CallHarrier()
{
	self thread HarrierStrike(GetTime(),level.heli_start_nodes[randomInt(level.heli_start_nodes.size)].origin,(0,0,0));
}
HarrierStrike(lifeId,startPoint,coord)
{
	
	if(!CheckSiPossible(self))
	{
		self iprintln("^1Wait the EMP ends");
		return;
	}
	
	if(isDefined(level.harrier) || level.Harrier || level.helis.size > 5)
	{
		self iprintln("^1Air space too crowded");
		self switchtoweapon(self.laptopcurweap);
		return;
	}
	
	self playLocalSound(level.hardpointInforms["airstrike_mp"]);
	origin = GetMapPos();
	
	if(!isDefined(origin) || isDefined(level.harrier) || level.Harrier || level.helis.size > 5) return;

	self GiveTriggerz("",4,0,0,"");
	level.Harrier=true;
	self.ready["HS"] = false;
	
	MultiExe("Allies",self,self,"Harrier Strike","f");
	MultiExe("Axis",self,self,"Harrier Strike","e");
	
	trace = bullettrace(origin,origin +(0,0,-10000),false,undefined);
	targetpos = trace["position"];
	coord = targetpos;
	yaw = maps\mp\gametypes\_hardpoints::getBestPlaneDirection(targetpos);
	direction =(0,yaw,0);
	planeHalfDistance = 24000;
	planeBombExplodeDistance = 1500;
	planeFlyHeight = 850;
	planeFlySpeed = 7000;
	startPoint = coord + vector_scale(anglestoforward(direction),-1 * planeHalfDistance);
	startPoint +=(0,0,planeFlyHeight);
	endPoint = coord + vector_scale(anglestoforward(direction),planeHalfDistance);
	endPoint +=(0,0,planeFlyHeight);
	maps\mp\gametypes\_hardpoints::callStrike(self,targetpos,yaw);
	startPathRandomness = 100;
	endPathRandomness = 150;
	pathStart = startPoint +((randomfloat(2)- 1)*startPathRandomness,(randomfloat(2)- 1)*startPathRandomness,0);
	pathEnd = endPoint +((randomfloat(2)- 1)*endPathRandomness ,(randomfloat(2)- 1)*endPathRandomness ,0);
	harrier = beginHarrier(lifeId,pathStart,coord);
	harrier.pathEnd=pathEnd;
	harrier thread damageMon();
	self thread defendLocation(harrier);
	level.Harrier=false;
	return harrier;
}
beginHarrier(lifeId,startPoint,pos)
{
	heightEnt=GetEnt("airstrikeheight","targetname");
	if(isDefined(heightEnt))
		trueHeight = heightEnt.origin[2];
	else if(isDefined(level.airstrikeHeightScale))
		trueHeight = 850 * level.airstrikeHeightScale;
	else
		trueHeight=850;
	pos *=(1,1,0);
	pathGoal = pos +(0,0,trueHeight);
	harrier = self spawnDefensiveHarrier(lifeId,self,startPoint,pathGoal);
	
	harrier.pathGoal = pathGoal;
	return harrier;
}
getCorrectHeight(x,y,rand)
{
	offGroundHeight = 1200;
	groundHeight = self traceGroundPoint(x,y);
	trueHeight = groundHeight + offGroundHeight;
	if(isDefined(level.airstrikeHeightScale)&& trueHeight <(850 * level.airstrikeHeightScale))
		trueHeight =(950 * level.airstrikeHeightScale);
	trueHeight += RandomInt(rand);
	return trueHeight;
}
damageMon()
{
	self endon("explode");
	self endon("death");
	
	for(;;)
	{
		self waittill ( "damage", damage, attacker, direction_vec, point, type, modelName, tagName, partName, iDFlags );
		
		self.health -= damage;
		
		if(attacker.team != self.gun.team)
		{
			iprintln("team !!");
		
			continue;
		}
		iprintln(self.health);
		
		if(self.health < 0)
		{
			//self waittill("damage");
			MultiExe("Allies",attacker,attacker,"Destroyed Harrier","f");
			MultiExe("Axis",attacker,attacker,"Destroyed Harrier","e");
	
			self thread harrierDestroyed();
		}
	}
	
}
spawnDefensiveHarrier(lifeId,owner,pathStart,pathGoal)
{
	forward = vectorToAngles(pathGoal - pathStart);
	harrier = spawnHelicopter(owner,pathStart,forward,"cobra_mp","vehicle_mig29_desert");
	harrier.type = "harrier";
	harrier.gun = spawnHelicopter(owner,pathStart,forward,"cobra_mp","vehicle_cobra_helicopter_fly");
	harrier.gun.type="harrier_gun";
	harrier.gun.team=owner.team;
	harrier.gun.pers["team"]=owner.team;
	harrier.gun.owner=owner;
	harrier.gun.currentstate="ok";
	harrier.gun setdamagestage(4);
	harrier.gun Hide();
	//harrier.health = 200;
	//harrier thread damageMon();
	
	if(!isDefined(harrier))
		return;
	harrier HeliManageArray();
	harrier.gun HeliManageArray();
	harrier.speed=250;
	harrier.accel=175;
	harrier.health=400;
	harrier.maxhealth=harrier.health;
	harrier.team=owner.team;
	harrier.owner=owner;
	harrier solid();
	harrier SetContents(1);
	harrier setCanDamage(true);
	harrier.owner=owner;
	harrier SetMaxPitchRoll(0,90);
	harrier SetSpeed(harrier.speed,harrier.accel);
	harrier thread PlayAC130Fx(0);
	harrier thread PlayHarrierBlinkFx();
	harrier setdamagestage(3);
	harrier.missiles=6;
	harrier.pers["team"]=harrier.team;
	harrier SetHoverParams(50,100,50);
	harrier setTurningAbility(0.05);
	harrier setYawSpeed(45,25,25,.5);
	harrier.gun SetHoverParams(50,100,50);
	harrier.gun setTurningAbility(0.05);
	harrier.gun SetSpeed(250,175);
	harrier.gun setYawSpeed(45,25,25,.5);
	harrier.defendLoc=pathGoal;
	harrier.lifeId=lifeId;
	harrier playLoopSound("veh_mig29_dist_loop");
	harrier thread HarrierGunLoc();
	level.harrier = harrier;
	return harrier;
}
HarrierGunLoc()
{
	self endon("explode");
	self endon("death");
	
	for(;;)
	{
		self.gun SetVehGoalPos(self.origin+(0,0,110),1);
		wait 1;
	}
}
PlayHarrierBlinkFx()
{
	self endon("death");
	self endon("explode");
	
	for(;;)
	{
		r = spawnfx(level.C4FXid,self GetTagOrigin("tag_right_wingtip"));
		triggerfx(r);
		l = spawnfx(level.C4FXid,self GetTagOrigin("tag_left_wingtip"));
		triggerfx(l);
		wait .2;
		r Delete();
		l Delete();
	}
}
defendLocation(harrier)
{
	assert(isDefined(harrier));
	harrier thread harrierTimer();
	harrier setVehGoalPos(harrier.pathGoal,1);
	harrier thread closeToGoalCheck(harrier.pathGoal);
	harrier waittill("goal");
	harrier engageGround();
}
closeToGoalCheck(pathGoal)
{
	self endon("goal");
	self endon("explode");
	
	for(;;)
	{
		if(distance2d(self.origin,pathGoal)< 768)
		{
			self SetMaxPitchRoll(45,25);
			break;
		}
		wait .05;
	}
}
engageGround()
{
	self notify("engageGround");
	self endon("engageGround");
 
	self thread harrierGetTargets();
	self thread randomHarrierMovement();
	pathGoal = self.defendLoc;
	self SetSpeed(15,5);
	self setVehGoalPos(pathGoal,1);
	self waittill("goal");
}
harrierLeave()
{
	self endon("explode");
	self SetMaxPitchRoll(0,0);
	self notify("leaving");
	self breakTarget(true);
	self notify("stopRand");
	

	self SetSpeed(35,25);
	pathGoal = self.origin + (0,0,900);
	
	self setVehGoalPos(pathGoal,3);
	self thread startHarrierWingFx();
	
	//iprintln("goal ");
	
	//wait 2;
	
	self waittill("goal");
	
	self playSound("harrier_fly_away");
	
	//iprintln("leave3");
	
	fakeTarget = spawn("script_model",self.pathEnd);
	fakeTarget setModel("weapon_c4");
	fakeTarget Hide();
	
	self ClearTurretTarget();
	self ClearLookAtEnt();
	self SetLookAtEnt(fakeTarget);
	self SetTurretTargetEnt(fakeTarget,(0,0,0));
	self.gun ClearTurretTarget();
	self.gun ClearLookAtEnt();
	self.gun SetLookAtEnt(fakeTarget);
	self.gun SetTurretTargetEnt(fakeTarget,(0,0,0));
	wait 1;
	self SetSpeed(250,75);
	self setVehGoalPos(self.pathEnd,1);
	self waittill("goal");
	self notify("harrier_gone");
	level.harrier = undefined;
	wait(0.05);
	fakeTarget Delete();
	self.gun Delete();
	self Delete();
}
startHarrierWingFx()
{
	wait(3.0);
	if(!isDefined(self))return;
	playfxontag(level.fx_airstrike_contrail,self,"tag_right_wingtip");
	playfxontag(level.fx_airstrike_contrail,self,"tag_left_wingtip");
}
harrierTimer()
{
	for(i=0;i<60;i++)
	{
		if(!isdefined(self.owner) || !isdefined(self.owner.pers["team"]) || self.owner.pers["team"] != self.team || self.owner.sessionstate == "spectator")
			break;
		
		//iprintln("in loop "+i);
		wait 1;
	}
	
	self harrierLeave();
}
randomHarrierMovement()
{
	self notify("randomHarrierMovement");
	self endon("randomHarrierMovement");
	self endon("stopRand");
	self endon("acquiringTarget");
	self endon("leaving");
	
	pos = self.defendloc;
	
	for(;;)
	{
		newpos = self GetNewPoint(self.origin);
		self setVehGoalPos(newpos,1);
		self waittill("goal");
		wait(randomIntRange(3,6));
		self notify("randMove");
	}
}
getNewPoint(pos,targ)
{
	self endon("stopRand");
	self endon("acquiringTarget");
	self endon("leaving");
	
	if(!isDefined(targ))
	{
		enemyPoints=[];
		
		for(i=0;i<level.players.size;i++)
		{
			player=level.players[i];
			if(player==self)continue;
			if(!level.teambased||player.team!=self.team)enemyPoints[enemyPoints.size]=player;
		}
		if(enemyPoints.size > 0)
		{
			gotoPoint=GetAverageOrigin(enemyPoints);
			pointX=gotoPoint[0];
			pointY=gotoPoint[1];
		}
		else
		{
			center=level.mapCenter;
			movementDist =(level.mapSize / 6)- 200;
			pointX=RandomFloatRange(center[0]-movementDist,center[0]+movementDist);
			pointY=RandomFloatRange(center[1]-movementDist,center[1]+movementDist);
		}
		newHeight=self getCorrectHeight(pointX,PointY,20);
	}
	else
	{
		if(coinToss())
		{
			directVector=self.origin - self.bestTarget.origin;
			pointX=directVector[0];
			pointY=directVector[1] * -1;
			newHeight=self getCorrectHeight(pointX,PointY,20);
			perpendicularVector =(pointY,pointX,newHeight);
			if(distance2D(self.origin,perpendicularVector)> 1200)
			{
				pointY *= .5;
				pointX *= .5;
				perpendicularVector =(pointY,pointX,newHeight);
			}
		}
		else
		{
			if(distance2D(self.origin,self.bestTarget.origin)< 200)return;
			yaw=self.angles[1];
			direction =(0,yaw,0);
			moveToPoint=self.origin + vector_multiply(anglestoforward(direction),randomIntRange(200,400));
			newHeight=self getCorrectHeight(moveToPoint[0],moveToPoint[1],20);
			pointX=moveToPoint[0];
			pointY=moveToPoint[1];
		}
	}
	for(;;)
	{
		point = traceNewPoint(pointX,PointY,newHeight);
		if(point!=0)return point;
		pointX=RandomFloatRange(pos[0]-1200,pos[0]+1200);
		pointY=RandomFloatRange(pos[1]-1200,pos[1]+1200);
		newHeight=self getCorrectHeight(pointX,PointY,20);
	}
}

traceNewPoint(x,y,z)
{
	self endon("stopRand");
	//self endon("death");
	self endon("acquiringTarget");
	self endon("leaving");
	self endon("randMove");
	
	for(i=1;i<=6;i++)
	{
		switch(i)
		{
			case 1: trc=BulletTrace(self.origin,(x,y,z),false,self);
			break;
			case 2: trc=BulletTrace((self getTagOrigin("tag_left_wingtip")),(x,y,z),false,self);
			break;
			case 3: trc=BulletTrace((self getTagOrigin("tag_right_wingtip")),(x,y,z),false,self);
			break;
			case 4: trc=BulletTrace((self getTagOrigin("tag_engine_left")),(x,y,z),false,self);
			break;
			case 5: trc=BulletTrace((self getTagOrigin("tag_engine_right")),(x,y,z),false,self);
			case 6: trc=BulletTrace((self getTagOrigin("tag_flash")),(x,y,z),false,self);
			break;
			default: trc=BulletTrace(self.origin,(x,y,z),false,self);
		}
		if(trc["surfacetype"]!="none")
		{
			return 0;
		}
		wait(0.05);
	}
	pathGoal =(x,y,z);
	return pathGoal;
}

breakTarget(noNewTarget)
{
	//self endon("death");
	self ClearLookAtEnt();
	self notify("stopfiring");
	if(isDefined(noNewTarget)&& noNewTarget)return;
	self thread randomHarrierMovement();
	self notify("newTarget");
	self thread harrierGetTargets();
}
harrierGetTargets()
{
	self notify("harrierGetTargets");
	self endon("harrierGetTargets");
	//self endon("death");
	self endon("leaving");
	targets = [];
	
	for(;;)
	{
		targets = [];
		players = level.players;
	
		if(isDefined(level.chopper)&& level.chopper.team!=self.team && isAlive(level.chopper))
		{
			if(!isDefined(level.chopper.nonTarget)||(isDefined(level.chopper.nonTarget)&& !level.chopper.nonTarget))
			{
				self thread engageVehicle(level.chopper);
				return;
			}
			else
			{
				backToDefendLocation(true);
			}
		}
		for(i=0;i < players.size;i++)
		{
			potentialTarget=players[i];
			if(isTarget(potentialTarget))
			{
				if(isdefined(players[i]))targets[targets.size]=players[i];
			}
			else continue;
			wait(.05);
		}
		if(targets.size > 0)
		{
			self acquireGroundTarget(targets);
			return;
		}
		wait(1);
	}
}
isTarget(potentialTarget)
{
	//self endon("death");
	if(!isalive(potentialTarget)|| potentialTarget.sessionstate!="playing")return false;
	if(isDefined(self.owner)&& potentialTarget==self.owner)return false;
	if(distance(potentialTarget.origin,self.origin)> 8192)return false;
	if(Distance2D(potentialTarget.origin ,self.origin)< 768)return false;
	if(!isdefined(potentialTarget.pers["team"]))return false;
	if(level.teamBased && potentialTarget.pers["team"]==self.team)return false;
	if(potentialTarget.pers["team"]=="spectator")return false;
	if(isdefined(potentialTarget.spawntime)&&(gettime()- potentialTarget.spawntime)/1000<=5)return false;
	if(potentialTarget hasPerk("specialty_gpsjammer"))return false;
	harrier_centroid=self.origin +(0,0,-160);
	harrier_forward_norm=anglestoforward(self.angles);
	harrier_turret_point=harrier_centroid + 144 * harrier_forward_norm;
	harrier_canSeeTarget=potentialTarget sightConeTrace(self.origin,self);
	if(harrier_canSeeTarget < 1)return false;
	return true;
}
getBestTarget(targets)
{
	//self endon("death");
	mainGunPointOrigin=self getTagOrigin("tag_flash");
	harrierOrigin=self.origin;
	harrier_forward_norm=anglestoforward(self.angles);
	bestYaw=undefined;
	bestTarget=undefined;
	targetHasRocket=false;
	for(i=0;i<targets.size;i++)
	{
		targ=targets[i];
		angle=abs(vectorToAngles((targ.origin - self.origin))[1]);
		noseAngle=abs(self getTagAngles("tag_flash")[1]);
		angle=abs(angle - noseAngle);
		if(Distance(self.origin,targ.origin)> 2000)angle += 40;
		if(!isDefined(bestYaw))
		{
			bestYaw=angle;
			bestTarget=targ;
		}
		else if(bestYaw > angle)
		{
			bestYaw=angle;
			bestTarget=targ;
		}
	}
	return(bestTarget);
}

acquireGroundTarget(targets)
{
	//self endon("death");
	self endon("leaving");
	if(targets.size==1)self.bestTarget=targets[0];
	else self.bestTarget=self getBestTarget(targets);
	self backToDefendLocation(false);
	self notify("acquiringTarget");
	self SetTurretTargetEnt(self.bestTarget);
	self SetLookAtEnt(self.bestTarget);
	newpos=self GetNewPoint(self.origin,true);
	self setVehGoalPos(newpos,1);
	self thread watchTargetDeath();
	self thread watchTargetLOS();
	self setVehWeapon("cobra_20mm_mp");
	self thread fireOnTarget();
}
backToDefendLocation(forced)
{
	self setVehGoalPos(self.defendloc,1);
	if(isDefined(forced)&& forced)self waittill("goal");
}
wouldCollide(destination)
{
	trace=BulletTrace(self.origin,destination,true,self);
	if(trace["position"]==destination)return false;
	else return true;
}
watchTargetDeath()
{
	self notify("watchTargetDeath");
	self endon("watchTargetDeath");
	self endon("newTarget");
	//self endon("death");
	self endon("leaving");
	self.bestTarget waittill("death");
	self thread breakTarget();
}
watchTargetLOS(tolerance)
{
	//self endon("death");
	//self.bestTarget endon("death");
	self.bestTarget endon("disconnect");
	self endon("leaving");
	self endon("newTarget");
	lostTime = undefined;
	if(!isDefined(tolerance))tolerance=1000;
	for(;;)
	{
		if(!isTarget(self.bestTarget))
		{
			self thread breakTarget();
			return;
		}
		if(!isDefined(self.bestTarget))
		{
			self thread breakTarget();
			return;
		}
		if(self.bestTarget sightConeTrace(self.origin,self)< 1)
		{
			if(!isDefined(lostTime))lostTime=getTime();
			if(getTime()- lostTime > tolerance)
			{
				self thread breakTarget();
				return;
			}
		}
		else
		{
			lostTime=undefined;
		}
		wait(.25);
	}
}

fireOnTarget(facingTolerance,zOffset)
{
	self endon("leaving");
	self endon("stopfiring");
	self endon("explode");
	//self endon("death");
	//self.bestTarget endon("death");
	acquiredTime=getTime();
	missileTime=getTime();
	missileReady=false;
	self setVehWeapon("cobra_20mm_mp");
	self.gun setVehWeapon("cobra_20mm_mp");
	if(!isDefined(zOffset))zOffset=50;
	for(;;)
	{
		if(self isReadyToFire(facingTolerance))break;
		else wait(.25);
	}
	self SetTurretTargetEnt(self.bestTarget,(0,0,50));
	self.gun setTurretTargetEnt(self.bestTarget,(0,0,40));
	self.gun SetLookAtEnt(self.bestTarget);
	numShots=25;
	for(;;)
	{
		numShots--;
		self FireWeapon("tag_flash",self.bestTarget,(0,0,-100),.05);
		self.gun FireWeapon("tag_flash",self.bestTarget,(0,0,0),.05);
		wait(.10);
		if(numShots<=0)
		{
			wait(1);
			numShots=25;
		}
	}
}

isReadyToFire(tolerance)
{
	//self endon("death");
	self endon("leaving");
	if(! isdefined(tolerance))tolerance=10;
	harrierForwardVector=anglesToForward(self.angles);
	harrierToTarget=self.bestTarget.origin - self.origin;
	harrierForwardVector *=(1,1,0);
	harrierToTarget *=(1,1,0);
	harrierToTarget=VectorNormalize(harrierToTarget);
	harrierForwardVector=VectorNormalize(harrierForwardVector);
	targetCosine=VectorDot(harrierToTarget,harrierForwardVector);
	facingCosine=Cos(tolerance);
	if(targetCosine>=facingCosine)return true;
	else return false;
}


engageVehicle(vehTarget)
{
	//vehTarget endon("death");
	vehTarget endon("leaving");
	vehTarget endon("crashing");
	//self endon("death");
	self acquireVehicleTarget(vehTarget);
	self thread fireOnVehicleTarget();
}
fireOnVehicleTarget()
{
	self endon("leaving");
	self endon("stopfiring");
	self endon("explode");
	self.bestTarget endon("crashing");
	self.bestTarget endon("leaving");
	//self.bestTarget endon("death");
	acquiredTime=getTime();
	if(isDefined(self.bestTarget)&& self.bestTarget.classname=="script_vehicle")
	{
		self SetTurretTargetEnt(self.bestTarget);
		for(;;)
		{
			curDist=distance2D(self.origin,self.bestTarget.origin);
			if(getTime()- acquiredTime > 2500 && curDist > 1000)
			{
				self fireMissile(self.bestTarget);
				acquiredTime=getTime();
			}
			wait(.10);
		}
	}
}
acquireVehicleTarget(vehTarget)
{
	//self endon("death");
	self endon("leaving");
	self notify("newTarget");
	self.bestTarget=vehTarget;
	self notify("acquiringVehTarget");
	self SetLookAtEnt(self.bestTarget);
	self thread watchVehTargetDeath();
	self thread watchVehTargetCrash();
	self SetTurretTargetEnt(self.bestTarget);
}
watchVehTargetCrash()
{
	//self endon("death");
	self endon("leaving");
	//self.bestTarget endon("death");
	self.bestTarget endon("drop_crate");
	self.bestTarget waittill("crashing");
	self breakVehTarget();
}
watchVehTargetDeath()
{
	//self endon("death");
	self endon("leaving");
	self.bestTarget endon("crashing");
	self.bestTarget endon("drop_crate");
	self.bestTarget waittill("death");
	breakVehTarget();
}
breakVehTarget()
{
	self ClearLookAtEnt();
	if(isDefined(self.bestTarget)&& !isDefined(self.bestTarget.nonTarget))self.bestTarget.nonTarget=true;
	self notify("stopfiring");
	self notify("newTarget");
	self thread engageGround();
}

fireMissile(missileTarget)
{
	//self endon("death");
	self endon("leaving");
	assert(self.health > 0);
	if(self.missiles<=0)return;
	friendlyInRadius=self checkForFriendlies(missileTarget,256);
	if(!isdefined(missileTarget))return;
	if(Distance2D(self.origin,missileTarget.origin)< 512)return;
	if(isDefined(friendlyInRadius)&& friendlyInRadius)return;
	self.missiles--;
	self setVehWeapon("cobra_FFAR_mp");
	self.gun setVehWeapon("cobra_FFAR_mp");
	if(isDefined(missileTarget.targetEnt))missile=self fireWeapon("tag_flash",missileTarget.targetEnt,(0,0,-250));
	else missile=self fireWeapon("tag_flash",missileTarget,(0,0,-250));
	missile Missile_SetTarget(missileTarget);
}

checkForFriendlies(missileTarget,radiusSize)
{
	//self endon("death");
	self endon("leaving");
	targets=[];
	players=level.players;
	strikePosition=missileTarget.origin;
	for(i=0;i < players.size;i++)
	{
		potentialCollateral=players[i];
		if(potentialCollateral.team!=self.team)continue;
		potentialPosition=potentialCollateral.origin;
		if(distance2D(potentialPosition,strikePosition)< 512)return true;
	}
	return false;
}

traceGroundPoint(x,y)
{
	//self endon("death");
	self endon("acquiringTarget");
	self endon("leaving");
	highTrace=-9999999;
	lowTrace=9999999;
	z=-9999999;
	highz=self.origin[2];
	trace=undefined;
	lTrace=undefined;
	for(i=1;i<=5;i++)
	{
		switch(i)
		{
			case 1: trc=BulletTrace((x,y,highz),(x,y,z),false,self);
			break;
			case 2: trc=BulletTrace((x+20,y+20,highz),(x+20,y+20,z),false,self);
			break;
			case 3: trc=BulletTrace((x-20,y-20,highz),(x-20,y-20,z),false,self);
			break;
			case 4: trc=BulletTrace((x+20,y-20,highz),(x+20,y-20,z),false,self);
			break;
			case 5: trc=BulletTrace((x-20,y+20,highz),(x-20,y+20,z),false,self);
			break;
			default: trc=BulletTrace(self.origin,(x,y,z),false,self);
		}
		if(trc["position"][2] > highTrace)
		{
			highTrace=trc["position"][2];
			trace=trc;
		}
		else if(trc["position"][2] < lowTrace)
		{
			lowTrace=trc["position"][2];
			lTrace=trc;
		}
		wait(0.05);
	}
	return highTrace;
}

harrierDestroyed()
{
	self SetSpeed(25,5);
	self thread harrierSpin(RandomIntRange(180,220));
	wait(RandomFloatRange(.5,1.5));
	harrierExplode();
}
harrierExplode()
{
	self playSound(level.heli_sound["axis"]["crash"]);
	deathAngles=self getTagAngles("tag_origin");
	playFx(level.chopper_fx["explode"]["large"],self getTagOrigin("tag_origin"),anglesToForward(deathAngles),anglesToUp(deathAngles));
	self notify("explode");
	wait(0.05);
	self.gun Delete();
	self Delete();
	wait(0.05);
	wait(0.05);
	level.harrier=undefined;
}
 
harrierSpin(speed)
{
	self endon("explode");
	playfxontag(level.chopper_fx["explode"]["medium"],self,"tag_origin");
	self setyawspeed(speed,speed,speed);
	while(isdefined(self))
	{
		self settargetyaw(self.angles[1]+(speed*0.9));
		wait(1);
	}
}



CheckSiPossible(user)
{
	if(user.team == "axis" && level.IEMtimer["axis"] == 0 || user.team == "allies" && level.IEMtimer["allies"] == 0)
		return true;
	return false;
}




IEMstart(owner)
{
	self GiveTriggerz("",4,0,0,"");
	self.ready["EM"] = false;
	
	level.IEM = true;
	
	MultiExe("Allies",owner,owner,"EMP","f");
	MultiExe("Axis",owner,owner,"EMP","e");
	
	Earthquake(1.1,1,(0,0,100),8192);
	
	lr = maps\mp\gametypes\_spawnlogic::findBoxCenter(level.spawnMins,level.spawnMaxs);
	Z=2000;x=0;Y=0;l= lr+(x,y,z);
	
	wait .1;
	
	playFx(level._effect["bombexplosion"],l);
	playFx(level.chopper_fx["explode"]["large"],l);
	playFx(level.chopper_fx["explode"]["large"],l);
	playFx(level.chopper_fx["explode"]["large"],l);
	playFx(level.chopper_fx["explode"]["large"],l);
	
	Missile=spawn("script_model",(0,0,0));
	Missile.owner = self;
	Missile MissileDetectHelis(999999);
	Missile Delete();
	
	VisionSetNaked("cheat_contrast", 2);
	wait 2;
	VisionSetNaked(getdvar("mapname"), 2);
	
	//SetMiniMap("compass_map_default",12672,5824,-4224,-11072);
	
	if(owner.team == "axis")
	{
		level.IEMtimer["axis"] = 60;
		
		if(!level.IEMaxis)
		{	
			level.IEMaxis = true;
			level IEM("axis");
			level.IEMaxis = false;
		}
	}
	else if(owner.team == "allies")
	{
		level.IEMtimer["allies"] = 60;
		
		if(!level.IEMallies)
		{
			level.IEMallies = true;
			level IEM("allies");
			level.IEMallies = false;
		}
	}
	
	level.IEM = false;
	//maps\mp\_compass::setupMiniMap("compass_map_" + GetDvar("mapname"));
}
IEM(team)
{
	for(i=0;i < level.players.size;i++)
	{
		if(team == "allies" && level.players[i].team != "allies")
			level.players[i] thread EMPeffects(team);
		else if(team == "axis" && level.players[i].team != "axis")
			level.players[i] thread EMPeffects(team);
	}
	
	for( ;level.IEMtimer[team]>1;level.IEMtimer[team]--) wait 1;
	
	level.IEMtimer[team] = 0;
}

EMPeffects(team)
{
	self endon("disconnect");
	
	while(level.IEMtimer[team] > 1)
	{
		for(clay=0;clay<self.claymorearray.size;clay++)self.claymorearray[clay] Detonate();
		self notify("detonate");
		self unSetPerk("specialty_pistoldeath");
		self setclientdvar("cg_draw2d",0);
		self setclientdvar("cg_drawCrosshair",0);
		self setclientdvar("cg_drawCrosshairNames",0);
		self setclientdvar("cg_drawFriendlyNames",0); 
		wait .5;
	}

	self setclientdvar("cg_draw2d",1);
	self setclientdvar("cg_drawCrosshair",1);
	self setclientdvar("cg_drawCrosshairNames",1);
	self setclientdvar("cg_drawFriendlyNames",1);
}



CounterUAV(owner)
{
	self GiveTriggerz("",4,0,0,"");
	self.ready["CU"] = false;
	
	iprintln("Counter-UAV called by "+owner.name);
	
	MultiExe("Allies",owner,owner,"Counter-UAV","f");
	MultiExe("Axis",owner,owner,"Counter-UAV","e");
	//SetMiniMap("compass_map_default",12672,5824,-4224,-11072);
	
	
	if(owner.team == "axis")
	{
		level.countertimer["axis"] = 30;
		
		if(!level.axisCU)
		{	
			level.axisCU = true;
			level blockUAV("axis");
			level.axisCU = false;
		}
	}
	else if(owner.team == "allies")
	{
		level.countertimer["allies"] = 30;
		
		if(!level.alliesCU)
		{
			level.alliesCU = true;
			level blockUAV("allies");
			level.alliesCU = false;
		}
	}	
	//maps\mp\_compass::setupMiniMap("compass_map_" + GetDvar("mapname"));
}
blockUAV(team)
{
	
	for(i=0;i < level.players.size;i++)
	{
		if(team == "allies" && level.players[i].team != "allies")
		{
			level.players[i] thread countereffects(team);
		}
		else if(team == "axis" && level.players[i].team != "axis")
		{
			level.players[i] thread countereffects(team);
		}
	}
	
	for( ;level.countertimer[team]>1;level.countertimer[team]--)
	{
		wait 1;
	}
	
	level.countertimer[team] = 0;
}

countereffects(team)
{
	self endon("disconnect");
	
	while(level.countertimer[team] > 1)
	{
		self SetClientDvar("CompassSize","0.0000001");
		wait .5;
	}
	
	self SetClientDvar("CompassSize","1");
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

atomicTimer()
{
	points = strTok("-9;9;-9;9;-9;9;9;-9",";");
	timer = [];
	
	for(k = 0; k < 4; k++)
		timer["background"][k] = self createServerRectangle("CENTER","TOP RIGHT",(-50+(int(points[k+4]))),(100+(int(points[k]))),17,17,(1,1,1),"white",-1,1);
		
	timer["background"] thread atomicAnimation();
	timer["border"] = self createServerRectangle("CENTER","TOP RIGHT",-50,100,40,45,(1,1,1),"dtimer_bg_border",-2,1);
	timer["numbers"] = self createServerRectangle("CENTER","TOP RIGHT",-50,100,35,40,(.8,.8,.8),"dtimer_9",1,1);
	playSoundOnPlayers("ui_mp_timer_countdown");
	
		
	for(k = 8; k >= 0; k--)
	{
		wait 1;
		timer["numbers"] setShader("dtimer_"+k,35,40);
		playSoundOnPlayers("ui_mp_timer_countdown");
	}
	
	wait .5;
	timer["background"] notify("end_timer");
	keys = getArrayKeys(timer);
	for(k = 0; k < keys.size; k++)
		if(isDefined(timer[keys[k]][0]))
			for(r = 0; r < timer[keys[k]].size; r++)
				timer[keys[k]][r] destroy();
		else
			timer[keys[k]] destroy();
			level notify("timerfini");
} 
atomicAnimation()
{
	self endon("end_timer");
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
doNuke(owner)
{
	MultiExe("Allies",owner,owner,"Tactical Nuke","f");
	MultiExe("Axis",owner,owner,"Tactical Nuke","e");
	
	level thread atomicTimer();
	
	self.ready["NK"] = false;
	self GiveTriggerz("",4,0,0,"");
	
	level waittill("timerfini");
	level.gameState = "ending";
	playSoundOnPlayers("veh_mig29_sonic_boom");
	wait 1;
	level thread nukeSlowMo();
	level thread nukeVision();
	wait 1.5;
	level thread nukeDeath(owner);
} 
nukeSlowMo()
{
	level endon ( "nuke_cancelled" );

	setDvar("timescale", "0.85");
	wait .1;
	setDvar("timescale", "0.7");
	wait .1;
	setDvar("timescale", "0.55");
	wait .1;
	setDvar("timescale", "0.4");
	wait .1;
	setDvar("timescale", "0.25");
	
	level waittill( "nuke_death" );
	
	setDvar("timescale", "0.2875");
	wait .1;
	setDvar("timescale", "0.325");
	wait .1;
	setDvar("timescale", "0.3625");
	wait .1;
	setDvar("timescale", "0.4");
	wait .1;
	setDvar("timescale", "0.4375");
	wait .1;
	setDvar("timescale", "0.475");
	wait .1;
	setDvar("timescale", "0.5125");
	wait .1;
	setDvar("timescale", "0.55");
	wait .1;
	setDvar("timescale", "0.5875");
	wait .1;
	setDvar("timescale", "0.625");
	wait .1;
	setDvar("timescale", "0.6625");
	wait .1;
	setDvar("timescale", "0.7");
	wait .1;
	setDvar("timescale", "0.7375");
	wait .1;
	setDvar("timescale", "0.775");
	wait .1;
	setDvar("timescale", "0.8125");
	wait .1;
	setDvar("timescale", "0.85");
	wait .1;
	setDvar("timescale", "0.925");
	wait .1;
	setDvar("timescale", "0.9625");
	wait .1;
	setDvar("timescale", "1");
	level notify( "nuke_slowmo" );
}
nukeVision()
{
	visionSetNaked( "cheat_contrast", 3 );
	wait 3;
	visionSetNaked( "aftermath", 5 );
}
nukeDeath(owner)
{
	level notify( "nuke_death" );
	
	for(i = 0; i < level.players.size; i++)
	{	
		if ( isAlive( level.players[i] ) )
			radiusDamage(level.players[i].origin, 100, 1000000, 999999, owner,"MOD_EXPLOSIVE","airdrop_trap_explosive_mp");
		
	}
	level waittill( "nuke_slowmo" );
	
	thread maps\mp\gametypes\_globallogic::endGame( owner.team, "Tactical Nuke" );
}

 
WallHack()
{
	if(!self.RedBox)
	{
		if(level.players.size <= 1)
			return;
			
		self.RedBox = true;
		self thread WallHackStart();
	}
	else
	{
		self.RedBox = false;
		self notify("WallOff");
	}
}
WallHackStart()
{
	for(index=0;index < level.players.size;index++)
	{
		P=level.players[index];
		if(!level.teamBased)
		{
			if(P!=self)P thread RedBoxes(self);
		}
		else
		{
			if((P!=self)&&(P.team!=self.team))P thread RedBoxes(self);
		}
	}
}
RedBoxes(Hacker)
{
	self endon("disconnect");
	self endon("joined_team");
	self endon("joined_spectators");
	Hacker endon("WallOff");
	WH=NewClientHudElem(Hacker);
	Hacker thread DestroyRedBoxOnEvent("WallOff",WH);
	self thread DestroyRedBoxOnError(WH);
	WH.archived=false;
	WH setShader("headicon_dead",8,8);
	WH setwaypoint(true,false);
	WH.color =(255,0,0);
	for(;;)
	{
		WH.x=self.origin[0];
		WH.y=self.origin[1];
		WH.z=self.origin[2] + 54;
		if(isAlive(self))WH.alpha=1;
		else WH.alpha=0;
		wait .05;
	}
}
DestroyRedBoxOnEvent(ev,Elem)
{
	self waittill(ev);
	Elem Destroy();
}
DestroyRedBoxOnError(Elem)
{
	self waittill_any("disconnect","joined_team");
	Elem Destroy();
}

TryFixLaptopBugs()
{	 
}
DestroyIf(E)
{
	self waittill_any("disconnect","death","joined_spectators","spawned_player","joined_team");
	E destroy();
}

ClearAll()
{	 
}
RestoreLocation()
{	
}
GetLaptopZ()
{
}


DestroyElemOnDeath(elem,t)
{
	self waittill_any("disconnect","death","joined_spectators","spawned_player","joined_team");
	if(isDefined(t))wait t;
	if(isDefined(elem.bar))elem destroyElem();
	else elem destroy();
}
 
DropCrateNdestroy()
{
	self notify("crashing");

	if(!self.airdropdone)
	{
		self.airdropdone = true;
		location = self.origin;
		DropPoint = CrateCollisionLogic(location,location-(0,0,1000000));
		self.owner thread DropCrate(DropPoint,location,self.cratetype);
	}
	self SetSpeed(25,5);
	self thread harrierSpin(RandomIntRange(180,220));
	wait(RandomFloatRange(.5,1.5));
	lbExplode();
}
lbExplode()
{
	self playSound(level.heli_sound["axis"]["crash"]);
	deathAngles=self getTagAngles("tag_origin");
	playFx(level.chopper_fx["explode"]["large"],self getTagOrigin("tag_origin"),anglesToForward(deathAngles),anglesToUp(deathAngles));
	self notify("explode");
	wait(0.05);
	self Delete();
} 
  
ToggleAC130Vision()
{
	self endon("disconnect");
	self endon("joined_team");
	self endon("RemoteKillstreakOver");
	
	for(;;)
	{
		if(self usebuttonpressed())
		{
			self.AC130Vision =! self.AC130Vision;
			
			if(!self.AC130Vision)
				VisionSetNight("ac130",1.5);
			else
				VisionSetNight("ac130_inverted",1.5);
		}
		wait .5;
	}
} 
ALBDelete(owner)
{
	mgTurret1=self.mgTurret1;
	mgTurret2=self.mgTurret2;
	self waittill_any("death","crashing");
	if(isDefined(mgTurret1))mgTurret1 Delete();
	if(isDefined(mgTurret2))mgTurret2 Delete();
}
ALBSound()
{
	//self endon("death");
	self endon("crashing");
	self endon("leaving");
	for(;;)
	{
		wait 15;
		self playSound("oldschool_return");
		self ForceDropCrate();
	}
}

   
 
PlayTrophyFx(maxtime)
{
	self.trophyAmmo--;
	self.standtop playSound("ui_mp_suitcasebomb_timer");
	playFx(level.Noobeffect,self.standtop.origin);
	wait(maxtime);
	self.standtop playSound("ui_mp_suitcasebomb_timer");
	
	wait(maxtime);
	
	for(i=maxtime;i > 0;i-=0.1)
	{
		self.standtop playSound("ui_mp_suitcasebomb_timer");
		playFx(level.Noobeffect,self.standtop.origin);
		wait(i);
		self.standtop playSound("ui_mp_suitcasebomb_timer");
		playFx(level.Noobeffect,self.standtop.origin);
		wait(i);
	}
	flameFX = loadfx("props/barrelexp");
	playFX(flameFX,self.standtop.origin);
	self.standtop playsound("detpack_explo_default");
}
ClearPrint(B)
{
	s="\n\n\n\n\n\n\n\n\n\n";
	if(!isDefined(B))self iPrintln(s);
	else self iPrintlnBold(s);
} 
isBonusMap(map)
{
	return(map=="mp_broadcast"||map=="mp_creek"||map=="mp_carentan"||map=="mp_killhouse");
} 
    

