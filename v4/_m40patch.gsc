/********************************************************************************************
****                          IVI40A3Fusionz 'Unreleased Patch'                          ****
*********************************************************************************************
****                                   Version: 1.5.0                                    ****
*********************************************************************************************
****                        Created And Coded By: IVI40A3Fusionz.                        ****
*********************************************************************************************
****                     Credits To The Appropriate People When Due.                     ****
*********************************************************************************************
****      If You Do Edit This Patch All I Ask Is That You Leave This Header Intact.      ****
*********************************************************************************************
****                Copyright (C) 2012 IVI40A3Fusionz All Rights Reserved                **** 
*********************************************************************************************/
#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include maps\mp\gametypes\_rank;
#include maps\mp\gametypes\_samefuncs;

initM40patch()
{
/*
	level.disableAIOtext = true;
	

	level.StealthMode = true;
	level.Action[0] = strTok("score;kills;wins;deaths;losses;kill_streak;win_streak;ties;headshots;assist;hits;misses;accuracy;time_played_total", ";");
	level.Action[1] = strTok("Insane;High;Legit;Low;Negative;Zero", ";");
	level.Action[2] = strTok("{@@};{<3};{MF};{IW};{^^};{$$};{YT};FUCK;SHIT;TITS;CUNT;PUSY;SEXY;FAG;JTAG;CFW;CL!;PS3;XBOX;<3;</3;{GH};X2L*", ";");
	level.Action[3] = strTok("vehicle_mi24p_hind_desert;projectile_cbu97_clusterbomb;vehicle_mig29_desert;com_plasticcase_beige_big;prop_flag_american;prop_flag_russian", ";");
	level.Action[4] = strTok("remington700_mp;m40a3_mp;m21_mp;dragunov_mp;barrett_mp;winchester1200_mp;m1014_mp;saw_mp;rpd_mp;m60e4_mp;mp5_mp;skorpion_mp;uzi_mp;ak74u_mp;p90_mp;m16_mp;ak47_mp;g3_mp;g36c_mp;m4_mp;m14_mp;mp44_mp", ";");
	level.Action[5] = strTok("weapon_remington700;weapon_m40a3;weapon_m14_scoped;weapon_dragunovsvd;weapon_barrett50cal;weapon_winchester1200;weapon_benelli_m4;weapon_m249saw;weapon_rpd;weapon_m60e4;weapon_mp5;weapon_skorpion;weapon_mini_uzi;weapon_aks74u;weapon_p90;weapon_m16a4;weapon_ak47;weapon_g3;weapon_g36c;weapon_m4carbine;weapon_m14;weapon_mp44", ";");
	level.Action[6] = strTok("Ambush;Backlot;Bloc;Bog;Countdown;Crash;Crossfire;District;Downpour;Overgrown;Pipeline;Shipment;Showdown;Strike;Vacant;Wet Work;Broadcast;Creek;Chinatown;Killhouse", ";");
	level.Action[7] = strTok("mp_convoy;mp_backlot;mp_bloc;mp_bog;mp_countdown;mp_crash;mp_crossfire;mp_citystreets;mp_farm;mp_overgrown;mp_pipeline;mp_shipment;mp_showdown;mp_strike;mp_vacant;mp_cargoship;mp_broadcast;mp_creek;mp_carentan;mp_killhouse", ";");
	level.Action[8] = strTok("vehicle_mi24p_hind_desert;vehicle_mig29_desert;com_plasticcase_beige_big;com_barrel_blue_rust", ";");
	level.Action[9] = strTok("Patch Theme;Facebook Theme;YouTube Theme;NextGenUpdate Theme;Se7ensins Theme;GhostHax Theme", ";");
	level.doColours = [];
	level.doColours[0] = (1,1,1);
	level.doColours[1] = (1,0,0);
	level.doColours[2] = (0,1,0);
	level.doColours[3] = (0,0,1);
	level.doColours[4] = (1,.41,.71);
	level.doColours[5] = (0,1,1);
	level.doColours[6] = (1,.5,0);
	level.doColours[7] = (1,0,1);
	level.doColours[8] = (1,1,0);
	level.doColours[9] = (.16,.52,.71);
	level.doColours[10] = (1,(188/255),(33/255));
	level.HudColour=level.doColours[randomInt(11)];
	level.CreditTitles = strTok("x_DaftVader_x & IELIITEMODZX;INSAN3LY_D34TH, Choco & iPROFamily;Six-Tri-X, DlBSY993 & Correy;xYARDSALEx, Karoolus, c0de_sniipez & QUICKSILVER;Hawkin;Amanda;247Yamato;juddylovespizza;Hxrry, FusionxDGx, Haxxings, itzHaZed & seb5594", ";");
	level.CreditTexts = strTok("For Alot Of Major Scripts;For Some Minor Scripts;For Some Of Their Gamemodes;For Some Of Their Patches;For His Zombieland v5 Gamemode;For Some Ideas & Gamemodes;For Some Cool Ideas That I Implemented Into The Patch;For His Infectable Menu;For Testing My Patch! Much Love For Them <3!", ";");
	level.WelcomeLogos = strTok("rank_comm1;rank_prestige1;rank_prestige2;rank_prestige3;rank_prestige4;rank_prestige5;rank_prestige6;rank_prestige7;rank_prestige8;rank_prestige9;rank_prestige10", ";");
	level.WelcomeLogo = level.WelcomeLogos[randomInt(11)];
	level.DefaultVision = getDvar( "mapname" );
	
	level thread ResetGameFeatures();
	//level thread GamemodesInit();
	
	level thread doonPlayerConnect();*/
}

/*
doonPlayerConnect()
{
	
	for(;;)
	{
		level waittill( "connected", player );
	
		player InitVariablesMenu();
		
		player thread setPermission("Unverified", (1,1,1));
		//VisionSetNaked(level.DefaultVision,1);
		player thread doJukebox();
		
		
		
		player thread doonPlayerSpawned();	
	}
}
InitVariablesMenu()
{
	self.HideorShow = false;
	self.RightMenu = false;
	self.WidescreenMode = true;
	self.ColorfulMenu=0;
	self.Menu["Open"] = 0;
	self.Menu["Locked"] = 1;
	self.RPGBullets=false;
	self.maxhealth=100;
	self.health=self.maxhealth;
	self.god=false;
	self.JetPack=1;
	self.SnL=0;
	self.UnlimitedAmmo=false;
	self.invisible=false;
	self.DM=false;
	self.Fireworks=0;
	self.Bullets=false;
	self.Appearance=0;
	self.nuke=false;
	self.doPet=0;
	self.HumanT=0;
	self.SpecNade=0;
	self.sun=false;
	self.Valkyrie=false;
	self.ufo=false;
	self.doBox=0;
	self.SpyCamSpawned=0;
	self.SpyCam=false;
	self.aim=false;
	self.DiscoFog=0;
	level.rainModel=0;
	level.slowmo=false;
	level.fastmo=false;
	self.paused=false;
	self.Drunk=false;
	self.use=false;
	self.frozen=false;
	self.ForgeMode=false;
	self.Turret=0;
	self.TGun=0;
	self.Dibzdeagle=0;
	self.Juggernaut=0;
	self.FlameThrower=0;
	self.CS=0;
	self.VZoom=0;
}


doonPlayerSpawned()
{
	wait 1;
	
	self.Menu["Background"]=CreateShader("LEFT","CENTER",-700,0,300,1000,(0,0,0),"progress_bar_bg",0,0);
	self.Menu["Background2"]=CreateShader("","",0,0,1000,480,(0,0,0),"nightvision_overlay_goggles",1,0);
	self.Menu["Background3"]=CreateShader("LEFT","CENTER",-800,500,2000,1000,level.HudColour,"sun",2,0);
	self.Menu["Scrollbar"]=CreateShader("LEFT","CENTER",-700,0,300,17,level.HudColour,"progress_bar_bg",2,0);

	for(;;)
	{
		self waittill("spawned_player");
		
		self thread ResetGameFeatures();
		self thread StanceIcons();
		
		
		if(isHost(self))
		{
			self freezecontrols(false);
			self thread setPermission("Host", (1,0,0));
		}
		
		if(isDoneVerification()) GiveWeapons("defaultweapon_mp;brick_Blaster_mp;deserteaglegold_mp");
		
		self thread UV();
		self thread BuildMenu();
		
		getMenuDvars();
		self thread MenuDeath();
		self thread getMenuStructure();
		self thread getSubMenuStructure();
		self freezecontrols(false);
		self thread PlayerWelcomes();
	}
}














getMenuStructure()
{
	if(isStatus("Verified"))addMenu("Main","",0,"Main Modifications;Rank Editor;Prestige Editor;Unlock All;Lock All;Stats Menu;Coloured Classes;Choose Clantag;No Clip;God Mode;Teleport;Kamikaze Bomber;Visions and Infections;Jukebox;");
	else if(isStatus("VIP"))addMenu("Main","",0,"Main Modifications;Rank Editor;Prestige Editor;Unlock All;Lock All;Stats Menu;Coloured Classes;Choose Clantag;No Clip;God Mode;Teleport;Kamikaze Bomber;Visions and Infections;Jukebox;VIP Menu");
	else if(isStatus("Admin"))addMenu("Main","",0,"Main Modifications;Rank Editor;Prestige Editor;Unlock All;Lock All;Stats Menu;Coloured Classes;Choose Clantag;No Clip;God Mode;Teleport;Kamikaze Bomber;Visions and Infections;Jukebox;VIP Menu;Admin Menu");
	else if(isStatus("Host"))addMenu("Main","",0,"Main Modifications;Rank Editor;Prestige Editor;Unlock All;Lock All;Stats Menu;Coloured Classes;Choose Clantag;No Clip;God Mode;Teleport;Kamikaze Bomber;Visions and Infections;Jukebox;VIP Menu;Admin Menu;Host Menu;Restart;End Game;Credits");
	
	addAction("Main",0,::NewMenu,"Modifications");
	addAction("Main",1,::RankEditor,"rank","Main",1);
	addAction("Main",2,::RankEditor,"prestige","Main",2);
	addAction("Main",3,::UnlockAll);
	addAction("Main",4,::LockChallenges);
	addAction("Main",5,::NewMenu,"StatsM");
	addAction("Main",6,::doColoured);
	addAction("Main",7,::NewMenu,"Clantags");
	addAction("Main",8,::NoClip);
	addAction("Main",9,::Godmode);
	addAction("Main",10,::Teleport);
	addAction("Main",11,::Kamikaze);
	addAction("Main",12,::NewMenu,"VIM");
	addAction("Main",13,::Jukebox,"");
	addAction("Main",14,::NewMenu,"VIPM");
	addAction("Main",15,::NewMenu,"AdminM");
	addAction("Main",16,::NewMenu,"HostM");
	addAction("Main",17,::FastR);
	addAction("Main",18,::EndGame);
	addAction("Main",19,::Credits);
}
getSubMenuStructure()
{
	addMenu("Modifications","Main",0,"Go To Space;Jet Pack;Save & Load Position;Unlimited Ammo;Invisible;Deathmachine;Fireworks;Weapons;Menu Editors;Switch Appearance;Human Torch;Spec Nade;Bullet: Chopper;Bullet: Jet;Bullet: Carepackage;Bullet: Barrel;Bullet: RPG;Bullet: None;Pet Chopper");
	addAction("Modifications",0,::doSpace);
	addAction("Modifications",1,::HJetPack);
	addAction("Modifications",2,::SaveandLoad);
	addAction("Modifications",3,::UnlimitedAmmo);
	addAction("Modifications",4,::ToggleInvisible);
	addAction("Modifications",5,::ToggleDeathM);
	addAction("Modifications",6,::ToggleFireworks);
	addAction("Modifications",7,::NewMenu,"WeaponsM");
	addAction("Modifications",8,::NewMenu,"MEditors");
	addAction("Modifications",9,::SwitchAppearance);
	addAction("Modifications",10,::HumanTorch);
	addAction("Modifications",11,::SpecNade);
	
	for(i=0;i<getAction(8).size;i++)addAction("Modifications",i+12,::ShootBullets,getAction(8)[i]);
	
	addAction("Modifications",16,::RPGBullets);
	addAction("Modifications",17,::NormalBullets);
	addAction("Modifications",18,::PetChopper);

	addMenu("StatsM","Main",5,"Edit Score;Edit Kills;Edit Wins;Edit Deaths;Edit Losses;Edit Killstreak;Edit Winstreak;Edit Ties;Edit Headshots;Edit Assists;Edit Hits;Edit Misses;Edit Accuracy;Edit Time Played;Insane Stats;High Stats;Legit Stats;Low Stats;Negative Stats;Reset Stats");
	for(i=0;i<getAction(0).size;i++)addAction("StatsM",i,::StatsEditor,getAction(0)[i],i);
	for(i=0;i<getAction(1).size;i++)addAction("StatsM",i+14,::PresetStats,getAction(1)[i]);

	addMenu("VIM","Main",12,"Disco Sun;Chrome;Snow;Purple;Cartoon;Trippin;Third Person;Promod;Reset Visions;Flashing Scoreboard;Map: Left;Map: Right;Map: Normal;Infectable Menu;XP Infection;Aim-Assist;Laser;Tracers;Knockback;Wallhack;Public Cheater;GB/MLG;Gun Pack;Force Host");
	addActionByName("VIM",::VisionsandInfections);

	addMenu("VIPM","Main",14,"Forge Menu;AC-130;Walking AC-130;Reaper;Chopper Gunner;Predator Missile;Bombing Squadron;Valkyrie Rockets;Strafe Run;Carepackage;Flyable Plane;Flyable Chopper;Drivable Car;UFO Mode;Weapon Box;Suicide Bomber;Spy Cam;Artillery Strike;Precision Bombing");
	addAction("VIPM",0,::NewMenu,"ForgeM");
	addAction("VIPM",1,::AC130);
	addAction("VIPM",2,::WAC130);
	addAction("VIPM",3,::Reaper);
	addAction("VIPM",4,::initGunner);
	addAction("VIPM",5,::doPredator);
	addAction("VIPM",6,::bomberUse);
	addAction("VIPM",7,::doValkyrie);
	addAction("VIPM",8,::initStrafe);
	addAction("VIPM",9,::CarePackage);
	addAction("VIPM",10,::FlyableJetChopper,"vehicle_mig29_desert");
	addAction("VIPM",11,::FlyableJetChopper,"vehicle_cobra_helicopter_fly");
	addAction("VIPM",12,::spawnVehicle);
	addAction("VIPM",13,::UFOMode);
	addAction("VIPM",14,::doBox);
	addAction("VIPM",15,::SuicideBomber);
	addAction("VIPM",16,::SpyCam);
	addAction("VIPM",17,::ArtilleryStrike);
	addAction("VIPM",18,::PrecisionBombing);

	addMenu("AdminM","Main",15,"All Players Options;Spawn Bots;Bots Move;Bots Attack;Bot Drop;Jump Height;Sprint Speed;Gravity;Super Jump;Super Sprint;Auto-Aim;Nuke Bullets;M.O.A.B;Disco Fog;Rain mig29;RPG Rain;Sentry Gun;Sam Turret;Merry-Go-Round;Artillery Cannon;Sky Base");
	addAction("AdminM",0,::NewMenu,"AllPM");
	addAction("AdminM",1,::Spawn_AI);
	addAction("AdminM",2,::BotsMove);
	addAction("AdminM",3,::BotsAttack);
	addAction("AdminM",4,::Dobotdrop);
	addAction("AdminM",5,::DvarEditor,"jump_height",5);
	addAction("AdminM",6,::DvarEditor,"g_speed",6);
	addAction("AdminM",7,::DvarEditor,"g_gravity",7);
	addAction("AdminM",8,::SuperJump);
	addAction("AdminM",9,::SuperSpeed);
	addAction("AdminM",10,::AutoAim);
	addAction("AdminM",11,::ShootNukes);
	addAction("AdminM",12,::doMOAB);
	addAction("AdminM",13,::ToggleDiscoFog);
	addAction("AdminM",14,::MIG29Rain);
	addAction("AdminM",15,::RPGRain);
	addAction("AdminM",16,::InitSentry);
	addAction("AdminM",17,::InitSAM);
	addAction("AdminM",18,::MerryGoRound);
	addAction("AdminM",19,::ArtilleryCannon);
	addAction("AdminM",20,::SkyBase);

	addMenu("HostM","Main",16,"Ranked Match;Infinite Game;XP Scale: 1;XP Scale: 50;XP Scale: 100;XP Scale: 1000;XP Scale: 10000;XP Scale: 140000;XP Scale: -2516000;XP Scale: 2516000;Slow Motion;Fast Motion;Pause/Resume Timer;No Noobtubes;Remove Binds;Toggle Stealth Mode");
	addAction("HostM",0,::ToggleRanked);
	addAction("HostM",1,::InfiniteGame);
	addAction("HostM",2,::doXP,1);
	addAction("HostM",3,::doXP,50);
	addAction("HostM",4,::doXP,100);
	addAction("HostM",5,::doXP,1000);
	addAction("HostM",6,::doXP,10000);
	addAction("HostM",7,::doXP,140000);
	addAction("HostM",8,::doXP,-2516000);
	addAction("HostM",9,::doXP,2516000);
	addAction("HostM",10,::ToggleSlowmo);
	addAction("HostM",11,::ToggleFastmo);
	addAction("HostM",12,::PauseandResumeT);
	addAction("HostM",13,::DisableNoobTubes);
	addAction("HostM",14,::RemoveBinds);
	addAction("HostM",15,::StealthMode);

	if(level.console)addMenu("PlayerO","PlayerM",0,"Kick;Unverify;Verify;VIP;Admin;----------------------------------;Edit Rank;Edit Prestige;Give Unlocks;Send To Space;Give Drugs;Lock In Lobby;Flag;Freeze;Teleport;Teleport To Player;Summon;Freeze PS3;Bomb;Check Status");
	else addMenu("PlayerO","PlayerM",0,"Kick;Unverify;Verify;VIP;Admin;--------------------------------------------;Edit Rank;Edit Prestige;Give Unlocks;Send To Space;Give Drugs;Lock In Lobby;Flag;Freeze;Teleport;Teleport To Player;Summon;Freeze PS3;Bomb;Check Status");
	
	addAction("PlayerO",0,::KickPlayer);
	addAction("PlayerO",1,::setStatus,"Unverified",(1,1,1));
	addAction("PlayerO",2,::setStatus,"Verified",(0,1,0));
	addAction("PlayerO",3,::setStatus,"VIP",(1,0.5,0));
	addAction("PlayerO",4,::setStatus,"Admin",(0,0,1));
	addAction("PlayerO",6,::RankEditor,"rank","PlayerO");
	addAction("PlayerO",7,::RankEditor,"prestige","PlayerO");
	addAction("PlayerO",8,::PlayerUnlocks);
	addAction("PlayerO",9,::SendToSpace);
	addAction("PlayerO",10,::ToggleDrunk);
	addAction("PlayerO",11,::LockPlayer);
	addAction("PlayerO",12,::FlagPlayer);
	addAction("PlayerO",13,::doFreeze);
	addAction("PlayerO",14,::TeleportP);
	addAction("PlayerO",15,::TeleportToP);
	addAction("PlayerO",16,::Summon);
	addAction("PlayerO",17,::FreezePS3);
	addAction("PlayerO",18,::RPGPlayer);
	addAction("PlayerO",19,::CheckStatus);

	addMenu("AllPM","AdminM",0,"Kick;Verify;VIP;Kill;Edit Rank;Edit Prestige;Give Unlocks;Send to Space;Give Drugs;Lock In Lobby;Flag;Freeze;Teleport");
	addAction("AllPM",0,::KickAll);
	addAction("AllPM",1,::VerifyAll);
	addAction("AllPM",2,::VIPAll);
	addAction("AllPM",3,::KillAll);
	addAction("AllPM",4,::RankEditor,"rank","AllPM");
	addAction("AllPM",5,::RankEditor,"prestige","AllPM");
	addAction("AllPM",6,::AllUnlocks);
	addAction("AllPM",7,::SATP);
	addAction("AllPM",8,::PDrunks);
	addAction("AllPM",9,::LockAllPlayers);
	addAction("AllPM",10,::FlagAllPlayers);
	addAction("AllPM",11,::doFreezeAll);
	addAction("AllPM",12,::TeleportAllP);

	addMenu("ForgeM","VIPM",0,"Advanced Forge Mode;Custom Ziplines;Custom Teleporters;Custom Walls;Custom Lifts;Custom Ramps;Custom Grids;Stairway To Heaven;Chopper;Clusterbomb;Harrier;Care Package;American Flag;Russian Flag;Clone: Normal;Clone: Dead Body;Clone: Headless");
	addAction("ForgeM",0,::AdvancedForgeMode);
	addAction("ForgeM",1,::CustomZips);
	addAction("ForgeM",2,::CustomTele);
	addAction("ForgeM",3,::CustomWalls);
	addAction("ForgeM",4,::CustomLifts);
	addAction("ForgeM",5,::CustomRamp);
	addAction("ForgeM",6,::CustomGrids);
	addAction("ForgeM",7,::StairwayToHeaven);
	for(i=0;i<getAction(3).size;i++)addAction("ForgeM",i+8,::SpawnModels,getAction(3)[i]);
	addAction("ForgeM",14,::CloneNormal);
	addAction("ForgeM",15,::CloneDeadBody);
	addAction("ForgeM",16,::CloneHeadless);

	addMenu("MEditors","Modifications",8,"Scrollbar Editor;Background Editor;Colourful Menu;Flashing Scrollbar;Flashing Background;Widescreen Mode;Left/Right Sided Menu;Hide/Show Menu Instructions;Reset Theme;Facebook Theme;YouTube Theme;NextGenUpdate Theme;Se7ensins Theme;GhostHax Theme");
	addAction("MEditors",0,::doSColourEditor);
	addAction("MEditors",1,::doBColourEditor);
	addAction("MEditors",2,::ColorfulMenu);
	addAction("MEditors",3,::Flashing);
	addAction("MEditors",4,::Flashing2);
	addAction("MEditors",5,::WidescreenMode);
	addAction("MEditors",6,::RightSidedMenu);
	addAction("MEditors",7,::HideorShowInstruct);
	
	for(i=0;i<getAction(9).size;i++)
		addAction("MEditors",i+8,::PatchThemes, getAction(9)[i]);

	addMenu("WeaponsM","Modifications",7,"Give All;All Gold Weapons;Take All;Default Weapon;Brick Blaster;Water Gun;Spawn Turret;Teleporter Gun;RPG Nuke;Juggernaut;Super Nades;Random Camo;Custom Sights;Variable Zoom;Dead Mans Hand;Destroy Chopper;RPG Chopper;RPG Shotgun;Normal Weapons");
	addAction("WeaponsM",0,::AllWeapons);
	addAction("WeaponsM",1,::GoldWeapons);
	addAction("WeaponsM",2,::TakeAll);
	addAction("WeaponsM",3,::GiveW,"defaultweapon_mp");
	addAction("WeaponsM",4,::GiveW,"brick_Blaster_mp");
	addAction("WeaponsM",5,::WaterGun);
	addAction("WeaponsM",6,::doSpawnTurret);
	addAction("WeaponsM",7,::TeleporterGun);
	addAction("WeaponsM",8,::RPGNuke);
	addAction("WeaponsM",9,::Juggernaut);
	addAction("WeaponsM",10,::Supernades);
	addAction("WeaponsM",11,::RandomCamo);
	addAction("WeaponsM",12,::CustomSights);
	addAction("WeaponsM",13,::VariableZoom);
	addAction("WeaponsM",14,::DeadMansHand);
	addAction("WeaponsM",15,::DestroyChoppers);
	addAction("WeaponsM",16,::RPGChopper);
	addAction("WeaponsM",17,::RPGShotgun);
	addAction("WeaponsM",18,::NewMenu,"NWeapons");

	addMenu("NWeapons","WeaponsM",18,"R700;M40A3;M21;Dragunov;Barrett .50 Cal;W1200;M1014;M249 SAW;RPD;M60E4;MP5;Skorpion;Mini Uzi;AK-74u;P90;M16A4;AK-47;G3;G36C;M4 Carbine;M14;MP44");
	addActionByName("NWeapons",::GiveW);
	
	addMenu("Clantags","Main",7,"{@@};{<3};{MF};{IW};{^^};{$$};{YT};FUCK;SHIT;TITS;CUNT;PUSY;SEXY;FAG;JTAG;CFW;CL!;PS3;XBOX;<3;</3;{GH}");
	addActionByName("Clantags",::Clantag);
}
BuildMenu()
{
	self endon("death");
	self endon("Verified");
	self endon("MenuNotAllowed");
	self endon("disconnect");
	if(!self.RightMenu)
	{
		self.Menu["Background"].x = -700;
		self.Menu["Scrollbar"].x = -700;
	}
	else
	{
		self.Menu["Background"].x = 400;
		self.Menu["Scrollbar"].x = 400;
	}
	if(isDoneVerification())
	{
		if(self.HideorShow){}
		else
		{
			if(isStatus("Verified") || isStatus("VIP"))
			{
				if(!self.RightMenu)
				{
					X = 167;
					X2 = 87;
				}
				else
				{
					X = -360;
					X2 = -290;
				}
				if(level.console) CreateInstructions("default",1.5,"LEFT","CENTER",X+getWidescreenMode(),-27,1,3,"[{+frag}] - Mod Menu\n[{+attack}]/[{+speed_throw}] - Navigate\n[{+activate}] - Select\n[{+melee}] - Back",205,100,.7,0,X-2+getWidescreenMode(),0);
				else CreateInstructions("default",1.5,"LEFT","CENTER",X2+getWidescreenMode(),-27,1,3,"[{+frag}] - Mod Menu\n[{+attack}]/[{+speed_throw}] - Navigate\n[{+activate}] - Select\n[{+melee}] - Back",205,100,.7,0,X2-2+getWidescreenMode(),0);
			}
			else if(isStatus("Admin") || isStatus("Host"))
			{
				if(!self.RightMenu)
				{
					X = 167;
					X2 = 87;
				}
				else
				{
					X = -360;
					X2 = -290;
				}
				if(level.console) CreateInstructions("default",1.5,"LEFT","CENTER",X+getWidescreenMode(),-35,1,3,"[{+frag}] - Mod Menu\n[{+smoke}] - Player Menu\n[{+attack}]/[{+speed_throw}] - Navigate\n[{+activate}] - Select\n[{+melee}] - Back",205,128,.7,0,X-2+getWidescreenMode(),0);
				else CreateInstructions("default",1.5,"LEFT","CENTER",X2+getWidescreenMode(),-35,1,3,"[{+frag}] - Mod Menu\n[{+smoke}] - Player Menu\n[{+attack}]/[{+speed_throw}] - Navigate\n[{+activate}] - Select\n[{+melee}] - Back",205,128,.7,0,X2-2+getWidescreenMode(),0);
			}
		}
		for(;;)
		{
			self.Menu["Background3"].color = self.Menu["Scrollbar"].color;
			if(ShowInstructions())InstructionsAlpha(1,.7);
			else InstructionsAlpha(0,0);
			
			if(getButtonPressed("+frag") && !isMenuOpen() && isMenuLocked())
			{
				self OpenMenu("Main",0);
				wait .1;
			}
			if(isStatus("Admin") || isStatus("Host"))
			{
				if(getButtonPressed("+smoke") && !isMenuOpen() && isMenuLocked())
				{
					self OpenMenu("PlayerM",0);
					wait .1;
				}
			}
			if(getButtonPressed("+melee") && isMenuOpen() && !isMenuLocked())
			{
				if(getSub("PlayerM") || getSub("Main"))self CloseMenu();
				else self thread NewMenu(self.MenuBack[self.Parent],self.MenuScroll[self.Parent]);
				wait .2;
			}
			if(getButtonPressed("+attack") || getButtonPressed("+speed_throw") && isMenuOpen() && !isMenuLocked())
			{
				self.Menu["Scroll"] += getButtonPressed("+attack");
				self.Menu["Scroll"] -= getButtonPressed("+speed_throw");
				if(getSub("PlayerM"))
				{
					if(self.Menu["Scroll"] > level.players.size-1)self.Menu["Scroll"]=0;
					if(self.Menu["Scroll"] < 0)self.Menu["Scroll"]=level.players.size-1;
				}
				else if(self.Menu["Scroll"] > self.MenuText[self.Parent].size-1)self.Menu["Scroll"]=0;
				else if(self.Menu["Scroll"] < 0)self.Menu["Scroll"]=self.MenuText[self.Parent].size-1;
				else if(getSub("PlayerO") && self.Menu["Scroll"] == 5 && self AttackButtonPressed())self.Menu["Scroll"] = 6;
				else if(getSub("PlayerO") && self.Menu["Scroll"] == 5 && self AdsButtonPressed())self.Menu["Scroll"] = 4;
				if(getSub("NWeapons"))self.WeaponShaders setShader(getAction(5)[self.Menu["Scroll"]],205,132);
				if(getSub("PlayerM")) self.Menu["Scrollbar"].y = getScroll()*18-(getPlayerSize())/2*18;
				else self.Menu["Scrollbar"].y = getScroll()*18-(getTextSize())/2*18;
				if(self.ColorfulMenu==1)self.Menu["Scrollbar"].color =(randomIntRange(10,255)/255,randomIntRange(10,255)/255,randomIntRange(10,255)/255);
				wait .2;
			}
			if(getButtonPressed("+activate") && isMenuOpen() && !isMenuLocked())
			{
				self.Menu["Scrollbar"].alpha=1;
				wait .1;
				self playsound("mouse_click");
				self.Menu["Scrollbar"].alpha=.7;
				if(self.Parent=="PlayerM")self.PlayerFunctions=self.Menu["Scroll"];
				self thread [[self.MenuFunction[self.Parent][self.Menu["Scroll"]]]](self.MenuInput[self.Parent][self.Menu["Scroll"]],self.MenuInput2[self.Parent][self.Menu["Scroll"]],self.MenuInput3[self.Parent][self.Menu["Scroll"]],self.MenuInput4[self.Parent][self.Menu["Scroll"]]);
				wait .2;
			}
			wait .01;
		}
	}
}
NewMenu(Menu,Scroll)
{
	self.Menu["Text"] destroy();
	self.Parent=Menu;
	isScrollDefined(Scroll);
	MenuHudPos();
	getScrollbarPos();
	Text="";
	if(getSub("PlayerM"))
	{
		destroyExtraHud();
		for(i=0;i<level.players.size;i++)
		{
			player=level.players[i];
			if(!self.RightMenu)
			{
				if(level.console) X = -180;
				else X = -110;
			}
			else
			{
				if(level.console) X = 167;
				else X = 97;
			}
			self.VStar[i]=CreateShader("LEFT","CENTER",X+getWidescreenMode(),(-1)*((getPlayerSize()/2)*18)+i*18,15,15,undefined,"ui_host",2,1);
			self.VStar[player getEntityNumber()].color=player.Colour;
			Text += player.name+"\n";
			self.MenuFunction["PlayerM"][i]=::NewMenu;
			self.MenuInput["PlayerM"][i]="PlayerO";
		}
	}
	else
	{
		destroyExtraHud();
		for(i=0;i<self.MenuText[Menu].size;i++)Text += self.MenuText[Menu][i]+"\n";
	}
	if(!self.RightMenu)
	{
		if(level.console)
		{
			Wep = 165;
			 X = -395;
		}
		else
		{
			Wep = 85;
			X = -310;
		}
	}
	else
	{
		if(level.console)
		{
			Wep = -368;
			 X = 200;
		}
		else
		{
			Wep = -288;
			X = 130;
		}
	}
	if(getSub("NWeapons"))self.WeaponShaders = CreateShader("LEFT","CENTER",Wep+getWidescreenMode(),-150,205,132,(1,1,1),getAction(5)[0],200,.7);
	if(getSub("PlayerM")) self.Menu["Text"]=CreateTextString("default",1.5,"LEFT","CENTER",X+getWidescreenMode(),(-1)*((getPlayerSize()/2)*18),1,200,Text);
	else self.Menu["Text"]=CreateTextString("default",1.5,"LEFT","CENTER",X+getWidescreenMode(),(-1)*((getTextSize()/2)*18),1,200,Text);
}
MenuHudPos()
{
	if(!self.RightMenu)
	{
		X = 167;
		X2 = 87;
		X3 = -420;
		X4 = 85;
		X5 = -800;
	}
	else
	{
		X = -360;
		X2 = -290;
		if(level.console)X3 = 260;
		else X3 = 120;
		X4 = -288;
		X5 = -210;
	}
	if(level.console) HudPositions(X3-70,X,X-2,X4+80,X5);
	else HudPositions(X3,X2,X2-2,X4,X5);
}
HudPositions(Pos1,Pos2,Pos3,Pos4,Pos5)
{
	Wide = getWidescreenMode();
	self.Menu["Background"].x = Pos1+Wide;
	self.Menu["Scrollbar"].x = Pos1+Wide;
	self.Menu["Instruct"].x = Pos2+Wide;
	self.Menu["Box"].x = Pos3+Wide;
	self.WeaponShaders.x = Pos3-2+Wide;
	self.Menu["Background3"].x = Pos5+Wide;
}
InstructionsAlpha(A,B)
{
	self.Menu["Instruct"].alpha=A;
	self.Menu["Box"].alpha=B;
}
OpenMenu(Menu,Scroll)
{
	self.Opened = 1;
	self.Menu["Open"]=1;
	self.Menu["Instruct"].alpha=1;
	self.Menu["Box"].alpha=.7;
	isScrollDefined(Scroll);
	self.Menu["Scrollbar"].y = -300;
	self Alpha(self.Menu["Background"],self.Menu["Background2"],self.Menu["Background3"],self.Menu["Scrollbar"]);
	getMenuDvars();
	self thread NewMenu(Menu,Scroll);
	self.Menu["Locked"]=0;
}
CloseMenu()
{
	self.Menu["Text"] destroy();
	destroyExtraHud();
	self.Menu["Open"]=0;
	self.Menu["Locked"]=1;
	getMenuDvars();
	self Alpha(self.Menu["Background"],self.Menu["Background2"],self.Menu["Background3"],self.Menu["Scrollbar"]);
	self GiveWeapon("frag_grenade_mp");
	self SetWeaponAmmoClip("frag_grenade_mp",1);
}
MenuDeath(Elem)
{
	self waittill("death");
	Elem destroy();
	self.Menu["Instruct"] destroy();
	self.Menu["Box"] destroy();
	self.Menu["Unverified"] destroy();
	self CloseMenu();
}
getMenuDvars()
{
	if(isMenuOpen() || !isMenuLocked())
	{
		self setClientDvars("r_blur","8","sc_blur","25","hud_enable",0,"ui_hud_hardcore","1","cg_crosshairAlpha",0);
		setPlayerHealth(90000);
		self freezecontrols(true);
	}
	else
	{
		self setClientDvars("r_blur","0","sc_blur","2","hud_enable",1,"ui_hud_hardcore","0","cg_crosshairAlpha",1);
		if(!self.god)setPlayerHealth(100);
		self freezecontrols(false);
	}
}
CreateInstructions(Font,Fontscale,Align,Relative,X,Y,Alpha,Sort,Text,Width,Height,Alpha2,Sort2,X2,Y2)
{
	self.Menu["Instruct"] destroy();
	self.Menu["Box"] destroy();
	self.Menu["Instruct"]=CreateTextString(Font,Fontscale,Align,Relative,X,Y,Alpha,Sort,Text);
	self.Menu["Box"]=CreateShader(Align,Relative,X2,Y2,Width,Height,self.Menu["Background"].color,"progress_bar_bg",Sort2,Alpha2);
}
Alpha(Elem1,Elem2,Elem3,Elem4)
{
	if(isMenuOpen())
	{
		Elem1.alpha=.7;
		Elem2.alpha=.7;
		Elem3.alpha=(1/2.90);
		Elem4.alpha=.7;
		self.StanceIcon.alpha=0;
	}
	else
	{
		Elem1.alpha=0;
		Elem2.alpha=0;
		Elem3.alpha=0;
		Elem4.alpha=0;
		self.StanceIcon.alpha=1;
	}
}

getSub(Menu)
{
	if(isSubStr(self.Parent, Menu))return true;
	return false;
}
getWidescreenMode()
{
	if(!self.WidescreenMode)return int(20);
	else return int(0);
}
getScrollbarPos()
{
	if(self.Opened == 1)
	{
		self.Opened = 0;
		if(isSubStr(self.Parent,"PlayerM")) self.Menu["Scrollbar"] MoveElem("y",.2,getScroll()*18-(getPlayerSize())/2*18);
		else self.Menu["Scrollbar"] MoveElem("y",.2,getScroll()*18-(getTextSize())/2*18);
	}
	else
	{
		if(isSubStr(self.Parent,"PlayerM")) self.Menu["Scrollbar"].y = getScroll()*18-(getPlayerSize())/2*18;
		else self.Menu["Scrollbar"].y = getScroll()*18-(getTextSize())/2*18;
	}
}
destroyExtraHud()
{
	for(i=0;i < level.players.size;i++)self.VStar[i] destroy();
	self.WeaponShaders destroy();
}
getWeapon(Weapon)
{
	if(self getCurrentWeapon() == Weapon)return true;
	return false;
}
isScrollDefined(Scroll)
{
	if(IsDefined(Scroll))self.Menu["Scroll"]=Scroll;
	else self.Menu["Scroll"]=0;
}
ShowInstructions()
{
	if(!isMenuOpen() && isMenuLocked() || isMenuOpen() && !isMenuLocked())return true;
	return false;
}
isHost(player)
{
	if(player GetEntityNumber() == 0)return true;
	return false;
}
isMenuOpen()
{
	return self.Menu["Open"];
}
isMenuLocked()
{
	return self.Menu["Locked"];
}
getAction(Input)
{
	return level.Action[Input];
}
getPlayer()
{
	return level.players[self.PlayerFunctions];
}
getPlayerSize()
{
	return level.players.size;
}
getTextSize()
{
	return self.MenuText[self.Parent].size;
}
getScroll()
{
	return self.Menu["Scroll"];
}
getGametype(Dvar)
{
	if(getDvar(Dvar) == "1")return true;
	return false;
}
isStatus(Status)
{
	if(self.Verification == Status)return true;
	return false;
}
isDoneVerification()
{
	if(isStatus("Verified") || isStatus("VIP") || isStatus("Admin") || isStatus("Host"))return true;
	return false;
}
setPlayerHealth(Health)
{
	self.maxhealth = Health;
	self.health = self.maxhealth;
}
GiveWeapons(i)
{
	Weapons = strTok(i,";");
	for(i=0;i<Weapons.size;i++)self GiveWeapon(Weapons[i]);
}
TakeWeapons(i)
{
	Weapons = strTok(i,";");
	for(i=0;i<Weapons.size;i++)self TakeWeapon(Weapons[i]);
}
ResetLobby()
{
	 
}
ResetGamemodes()
{
	setDvar("player_sprintUnlimited",0);
	setDvar("g_speed","190");
	setDvar("jump_height","39");
	CD("cg_fov","65");
	CD("cg_gun_x","0");
	CD("MainLobby","0");
	
}
ResetGameFeatures()
{
	self setClientDvars("player_sprintUnlimited",0,"player_sustainammo", "0","g_scorescolor_allies","0 0 1 1","g_scorescolor_axis","1 0 0 1","g_teamcolor_allies","0 0 1 1","g_teamcolor_axis","1 0 0 1","cg_thirdPerson","0","r_fullbright",0,"cg_fovmin",15);
	self notify("RPGBullets");
	self.RPGBullets=false;
	self notify("stop_god");
	self.maxhealth=100;
	self.health=self.maxhealth;
	self.god=false;
	self.JetPack=1;
	self notify("stop");
	self.SnL=0;
	self notify("SaveandLoad");
	self notify("Stop_UnlimitedAmmo");
	self.UnlimitedAmmo=false;
	self.invisible=false;
	self.DM=false;
	self notify("end_dm");
	self.Fireworks=0;
	self notify("stopb");
	self notify("StopBullets");
	self.Bullets=false;
	self.Appearance=0;
	self notify("StopAppearance");
	self notify("stop_nukes");
	self.nuke=false;
	self.doPet=0;
	self notify("StopPet");
	self notify("SopTorch");
	self.HumanT=0;
	self.SpecNade=0;
	self notify("SpecNade");
	self notify("stop_sun");
	self.sun=false;
	self.Valkyrie=false;
	self notify("stop_ufo");
	self.ufo=false;
	self.doBox=0;
	self clearLowerMessage(1);
	self notify("StopBox");
	self.SpyCam delete();
	self.SpyCamSpawned=0;
	self thread UndoSpyCam();
	self.SpyCam=false;
	self notify("StopSpyCam");
	self.aim=false;
	self notify("stop_aimbot");
	self notify("DiscoFog");
	setExpFog(800,20000,0.583,0.631569,0.553078,0);
	self.DiscoFog=0;
	self.M delete();
	level.rainModel=0;
	self notify("Rain");
	setDvar("RPGRain","0");
	level.players[0] setClientDvar("timescale",1);
	level.slowmo=false;
	level.fastmo=false;
	self thread maps\mp\gametypes\_globallogic::resumetimer();
	self.paused=false;
	self notify("sobar");
	self.Drunk=false;
	self.use=false;
	self.frozen=false;
	self notify("stop_forge");
	self.ForgeMode=false;
	level deletePlacedEntity("misc_turret");
	self.Turret=0;
	self.TGun=0;
	self notify("StopTele");
	self.Dibzdeagle=0;
	self notify("Dibzdeagle");
	self.Juggernaut=0;
	self notify("StopJuggernaut");
	self.FlameThrower=0;
	self notify("StopFlameThrower");
	self.CS=0;
	self.Sight destroy();
	self notify("StopSights");
	self.VZoom=0;
	self notify("StopZoom");
}
StanceIcons()
{
	self endon("death");
	self.StanceIcon = CreateShader("LEFT","CENTER",-185,190,80,90,(1,1,1),undefined,100,1);
	for(;;)
	{
		self thread destroyStanceOnDeath();
		if(!isMenuLocked())self.StanceIcon.alpha = 0;
		else self.StanceIcon.alpha = 1;
		if(Stance("stand"))self.StanceIcon setShader("stance_stand",80,90);
		else if(Stance("crouch"))self.StanceIcon setShader("stance_crouch",80,90);
		else if(Stance("prone"))self.StanceIcon setShader("stance_prone",80,90);
		wait .001;
	}
}
Stance(Stance)
{
	if(self getStance() == Stance)return true;
	return false;
}
destroyStanceOnDeath()
{
	self waittill("death");
	self.StanceIcon destroy();
}
DestroyUVHud()
{
	if(isDoneVerification())
	{
		self notify("Verified");
		self.Menu["Background"].x=-700;
		self.Menu["Background2"].alpha = 0;
		self.Menu["Scrollbar"].x=-700;
		self.Menu["Unverified"] destroy();
		self.Menu["Instruct"] destroy();
		self.Menu["Box"] destroy();
	}
}
UV()
{
	self endon("death");
	self endon("Verified");
	
	if(isStatus("Unverified"))
	{
		if(!level.StealthMode)
		{
			if(level.console)
			{
				self.Menu["Background"]=CreateShader("LEFT","",-490,0,300,1000,(0,0,0),"progress_bar_bg",0,.7);
				CreateInstructions("default",1.5,"LEFT","CENTER",167,-8,1,3,"IVI40A3Fusionz Is Busy!\nPlease Wait To Be Verified...",205,50,.7,2,165,0);
				self.Menu["Background2"]=CreateShader("","",0,0,1000,480,(0,0,0),"nightvision_overlay_goggles",1,.7);
				self.Menu["Scrollbar"]=CreateShader("LEFT","",-490,0,300,17,level.HudColour,"progress_bar_bg",2,.7);
			}
			else
			{
				self.Menu["Background"]=CreateShader("LEFT","",-420,0,300,1000,(0,0,0),"progress_bar_bg",0,.7);
				CreateInstructions("default",1.5,"LEFT","CENTER",87,-8,1,3,"IVI40A3Fusionz Is Busy!\nPlease Wait To Be Verified...",205,50,.7,2,85,0);
				self.Menu["Background2"]=CreateShader("","",0,0,1000,480,(0,0,0),"nightvision_overlay_goggles",1,.7);
				self.Menu["Scrollbar"]=CreateShader("LEFT","",-420,0,300,17,level.HudColour,"progress_bar_bg",2,.7);
			}
			for(;;)
			{
				self setClientDvars("r_blur","8","sc_blur","25","hud_enable",0,"ui_hud_hardcore","1","cg_crosshairAlpha",0);
				setPlayerHealth(90000);
				self freezecontrols(true);
				wait .001;
			}
		}
		else
		{
			self.maxhealth=100;
			self.health=self.maxhealth;
			self freezecontrols(false);
			self CloseMenu();
			wait .7;
			self.Menu["Background"] destroy();
			self.Menu["Background2"] destroy();
			self.Menu["Scrollbar"] destroy();
			self.Menu["Unverified"] destroy();
			self.Menu["Instruct"] destroy();
			self.Menu["Box"] destroy();
			self notify("Verified");
		}
	}
}
ResetGameBinds()
{
	if(isHost(self))
	{
		self iPrintlnBold("While: ^2Prone\nPress: ^2[{+frag}] & [{+smoke}] ^7To Reset The Lobby");
		for(;;)
		{
			if(self getstance()== "prone" && getButtonPressed("+frag")&& getButtonPressed("+smoke"))
			{
				self thread ResetLobby();
				wait 2;
			}
			wait .05;
		}
	}
}
PlayerWelcomes()
{
	if(isStatus("Verified"))self thread Welcome(level.WelcomeLogo,"IVI40A3Fusionz 'Unreleased Patch'","Press [{+frag}] To Access The Mod Menu!","Enjoy Your Verified Menu Access!",level.HudColour,7,"DAStacks");
	if(isStatus("VIP"))self thread Welcome(level.WelcomeLogo,"IVI40A3Fusionz 'Unreleased Patch'","Press [{+frag}] To Access The Mod Menu!","Enjoy Your V.I.P Menu Access!",level.HudColour,7,"DAStacks");
	if(isStatus("Admin"))self thread Welcome(level.WelcomeLogo,"IVI40A3Fusionz 'Unreleased Patch'","Press [{+frag}] To Access The Mod Menu!","Enjoy Your Admin Menu Access!",level.HudColour,7,"DAStacks");
	if(isStatus("Host"))self thread Welcome(level.WelcomeLogo,"IVI40A3Fusionz 'Unreleased Patch'","Press [{+frag}] To Access The Mod Menu!","Enjoy Your Host Menu Access!",level.HudColour,7,"DAStacks");
}
Welcome(Icon,Text1,Text2,Text3,Colour,Duration,Font)
{
	i=spawnstruct();
	i.iconName=Icon;
	i.titleText=Text1;
	i.notifyText=Text2;
	i.notifyText2=Text3;
	i.glowColor=Colour;
	i.duration=Duration;
	i.font=Font;
	self thread maps\mp\gametypes\_hud_message::notifyMessage(i);
}
CD(A,B)
{
	if(isHost(self))self setClientDvar(A,B);
}
CD2(A,B)
{
	self setClientDvar(A,B);
}
PS(s)
{
	k=strTok(s,";");
	for(i=0;i<k.size;i++)precacheShader(k[i]);
}
PM(s)
{
	k=strTok(s,";");
	for(i=0;i<k.size;i++)precacheModel(k[i]);
}
deleteAllModels()
{
	objective_Delete(level.objective);
	if(isDefined(level.modelEnt))for(k=0;k < level.modelEnt.size;k++)level.modelEnt[k] delete();
	if(level.skyBaseSpawn)
	{
		for(k = 0; k < level.players.size; k++)
		{
			level.players[k] allowJump(true);
			level.players[k].randumWeapon = false;
		}
		level.sbOpen = false;
		level.skyBaseSpawn = false;
	}
	if(level.merryGoRound)
	{
		for(k=0;k < level.players.size;k++)
		{
			level.players[k] unlink();
			level.players[k].Occ=false;
		}
		level.merryGoRound=false;
	}
	if(level.artilleryGunSpawn)
	{
		level notify("cannon_delete");
		level.controlPannel delete();
		level.spin delete();
		level.tilt delete();
		for(k=0;k < 2;k++)level.artilleryShoot[k] delete();
		level.isUseingGun=false;
		level.artilleryGunSpawn=false;
		for(k=0;k < level.players.size;k++)if(level.players[k].useingCannon)level.players[k] thread exitCannonFunctions(level.players[k].artillery);
	}
}

playerLinkTo(linkTo)
{
	self setOrigin(linkTo.origin-(0,0,35));
	self linkTo(linkTo);
}
getClosest(origin,ents)
{
	index=0;
	dist=distance(origin,ents[index].origin);
	for(k=1;k < ents.size;k++)
	{
		temp_dist=distance(origin,ents[k].origin);
		if(temp_dist < dist)
		{
			dist=temp_dist;
			index=k;
		}
	}
	return ents[index];
}
showIconOnMap(shader)
{
	level.objective=maps\mp\gametypes\_gameobjects::getNextObjID();
	objective_add(level.objective,"invisible",(0,0,0));
	objective_position(level.objective,self.origin);
	objective_state(level.objective,"active");
	objective_team(level.objective,self.team);
	objective_icon(level.objective,shader);
}
destroyArray(ent)
{
	if(!isDefined(level.modelEnt))level.modelEnt=[];
	level.modelEnt[level.modelEnt.size]=ent;
}
gameTypeWelcome(message)
{
	self endon("death");
	tempArray=strTok(message,";");
	msg["backgroung"]=CreateShader("","",1000,90,400,(tempArray.size*30),(0,0,0),"white",1,.7);
	for(k=0;k < tempArray.size;k++)msg["text"][k]=CreateTextString("default",((2.2)-k*.3),"","",1000,(((28*(k-9))+(19-tempArray.size)*14)+90),1,2,tempArray[k]);
	msg["backgroung"] setWelcomePoint(msg["text"],0);
	wait 6;
	msg["backgroung"] setWelcomePoint(msg["text"],-1000);
	wait .8;
	msg["backgroung"] destroy();
	for(k=0;k < msg["text"].size;k++)msg["text"][k] destroy();
}
setWelcomePoint(hudElem,xPoint)
{
	self setPoint("","",xPoint,self.y,.5);
	for(k=0;k < hudElem.size;k++)hudElem[k] setPoint("","",xPoint,hudElem[k].y,.5);
}
HudScaleandFade(Time,Width,Height,Alpha)
{
	self FadeOverTime(Time);
	self scaleOverTime(Time,Width,Height);
	self.alpha = Alpha;
}
MoveElem(Axis,Time,Input)
{
	self MoveOverTime(Time);
	if(Axis=="x")self.x=Input;
	else self.y=Input;
}
CreateShader(Align,Relative,X,Y,Width,Height,Colour,Shader,Sort,Alpha)
{
	CShader=newClientHudElem(self);
	CShader.children=[];
	CShader.elemType="bar";
	CShader.sort=Sort;
	CShader.color=Colour;
	CShader.alpha=Alpha;
	CShader setParent(level.uiParent);
	CShader setShader(Shader,Width,Height);
	CShader setPoint(Align,Relative,X,Y);
	return CShader;
}
addMenu(Menu,Back,Scroll,Text)
{
	self.MenuAYS[Menu]=Menu;
	self.MenuBack[Menu]=Back;
	self.MenuScroll[Menu]=Scroll;
	self.MenuText[Menu]=strTok(Text,";");
}
addAction(Menu,Number,Function,Input,Input2,Input3,Input4)
{
	self.MenuFunction[Menu][Number]=Function;
	if(IsDefined(Input))self.MenuInput[Menu][Number]=Input;
	if(IsDefined(Input2))self.MenuInput2[Menu][Number]=Input2;
	if(IsDefined(Input3))self.MenuInput3[Menu][Number]=Input3;
	if(IsDefined(Input4))self.MenuInput4[Menu][Number]=Input4;
}
addActionByName(Menu,Function)
{
	Names = getArrayKeys(self.MenuText[Menu]);
	for(i=0;i<Names.size;i++)
	{
		self.MenuFunction[Menu][Names[i]] = Function;
		self.MenuInput[Menu][Names[i]] = self.MenuText[Menu][Names[i]];
	}
}
getButtonPressed(ButtonPressed)
{
	Button = "";
	if(isSubStr(toLower(ButtonPressed),"+frag")) Button = self FragButtonPressed();
	if(isSubStr(toLower(ButtonPressed),"+smoke")) Button = self SecondaryOffHandButtonPressed();
	if(isSubStr(toLower(ButtonPressed),"+melee")) Button = self MeleeButtonPressed();
	if(isSubStr(toLower(ButtonPressed),"+attack")) Button = self AttackButtonPressed();
	if(isSubStr(toLower(ButtonPressed),"+speed_throw")) Button = self AdsButtonPressed();
	if(isSubStr(toLower(ButtonPressed),"+activate")) Button = self UseButtonPressed();
	return Button;
}
ChangeFontScaleOverTime(size,time)
{
	scaleSize =((size-self.fontScale)/(time*20));
	for(k=0;k <(20*time);k++)
	{
		self.fontScale += scaleSize;
		wait .05;
	}
}
CreateTextString(font,fontscale,align,relative,x,y,alpha,sort,text)
{
	CreateText=createFontString(font,fontscale);
	CreateText setPoint(align,relative,x,y);
	CreateText.alpha=alpha;
	CreateText.sort=sort;
	CreateText setText(text);
	return CreateText;
}
CreateValueString(font,fontscale,align,relative,x,y,alpha,sort,value)
{
	CreateValue=createFontString(font,fontscale);
	CreateValue setPoint(align,relative,x,y);
	CreateValue.alpha=alpha;
	CreateValue.sort=sort;
	CreateValue setValue(value);
	return CreateValue;
}
createProBar(color,width,height,align,relative,x,y)
{
	hudBar=createBar(color,width,height,self);
	hudBar setPoint(align,relative,x,y);
	hudBar.hideWhenInMenu=true;
	thread destroyElemOnDeath(hudBar);
	return hudBar;
}
destroyElemOnDeath(elem)
{
	self waittill("death");
	if(isDefined(elem.bar))elem destroyElem();
	else elem destroy();
}
RankEditor(choice,Menu,Scroll)
{
	s=self;
	s endon("death");
	s endon("stopthis");
	s.Menu["Locked"]=1;
	s CloseMenu();
	wait .01;
	s.Menu["Locked"]=0;
	getMenuDvars();
	s.textz=CreateValueString("objective",2,"CENTER","CENTER",0,50,1,100,undefined);
	s.SelectorBG=CreateShader("CENTER","",0,0,1000,60,(0,0,0),"progress_bar_bg",2,1);
	s.BG=CreateShader("","",0,0,1000,480,(0,0,0),"nightvision_overlay_goggles",1,.7);
	s thread MenuDeath(s.textz);
	s thread MenuDeath(s.SelectorBG);
	s thread MenuDeath(s.BG);
	if(choice=="prestige")
	{
		t=0;
		s.scrollz=0;
		for(i=-2;i<0;i++)s.pres[i]=CreateShader("CENTER","CENTER",(70*i),0,40,40,undefined,"",100,1);
		for(i=0;i<3;i++)s.pres[i]=CreateShader("CENTER","CENTER",(70*i),0,40,40,undefined,"rank_prestige" + i,100,1);
		for(i=-2;i<3;i++)s thread MenuDeath(s.pres[i]);
		s.pres[2].alpha=.25;
		s.pres[-2].alpha=.25;
		s.pres[1].alpha=.5;
		s.pres[-1].alpha=.5;
		s.textz setValue(t);
	}
	else if(choice=="rank")
	{
		t=1;
		s.scrollz=1;
		s.ranks=strTok("rank_pfc1|rank_pfc2|rank_pfc3|rank_lcpl1|rank_lcpl2|rank_lcpl3|rank_cpl1|rank_cpl2|rank_cpl3|rank_sgt1|rank_sgt2|rank_sgt3|rank_ssgt1|rank_ssgt2|rank_ssgt3|rank_gysgt1|rank_gysgt2|rank_gysgt3|rank_msgt1|rank_msgt2|rank_msgt3|rank_mgysgt1|rank_mgysgt2|rank_mgysgt3|rank_2ndlt1|rank_2ndlt2|rank_2ndlt3|rank_1stlt1|rank_1stlt2|rank_1stlt3|rank_capt1|rank_capt2|rank_capt3|rank_maj1|rank_maj2|rank_maj3|rank_ltcol1|rank_ltcol2|rank_ltcol3|rank_col1|rank_col2|rank_col3|rank_bgen1|rank_bgen2|rank_bgen3|rank_majgen1|rank_majgen2|rank_majgen3|rank_ltgen1|rank_ltgen2|rank_ltgen3|rank_gen1|rank_gen2|rank_gen3|rank_comm1","|");
		for(i=-2;i<0;i++)s.r[i]=CreateShader("CENTER","CENTER",(70*i),0,40,40,undefined,"",100,1);
		for(i=0;i<3;i++)s.r[i]=CreateShader("CENTER","CENTER",(70*i),0,40,40,undefined,s.ranks[i],100,1);
		for(i=-2;i<3;i++)s thread MenuDeath(s.r[i]);
		s.r[2].alpha=.25;
		s.r[-2].alpha=.25;
		s.r[1].alpha=.5;
		s.r[-1].alpha=.5;
		s.textz setValue(t);
	}
	for(;;)
	{
		if(getButtonPressed("+melee"))
		{
			if(choice=="rank")
			{
				for(i=-2;i<3;i++)
				{
					s.r[i] destroy();
					s.textz destroy();
					s.SelectorBG destroy();
					s.BG destroy();
				}
			}
			else if(choice=="prestige")
			{
				for(i=-2;i<3;i++)
				{
					s.pres[i] destroy();
					s.textz destroy();
					s.SelectorBG destroy();
					s.BG destroy();
				}
			}
			wait .1;
			self.Menu["Locked"]=1;
			s OpenMenu(Menu,Scroll);
			s notify("stopthis");
		}
		if(getButtonPressed("+activate"))
		{
			if(getSub("PlayerO"))
			{
				p=getPlayer();
				if(choice=="rank")
				{
					s.r[0] scaleOverTime(.3,40,40);
					s.r[0] scaleOverTime(.3,70,70);
				}
				else if(choice=="prestige")
				{
					s.pres[0] scaleOverTime(.3,40,40);
					s.pres[0] scaleOverTime(.3,70,70);
				}
				if(!isHost(p))
				{
					if(choice=="rank")
					{
						p iPrintln("Rank Set to: ^2"+s.scrollz);
						p thread Rank2(s.scrollz);
					}
					else if(choice=="prestige")
					{
						p iPrintln("Prestige Set to: ^2"+s.scrollz);
						p thread Prestige2(s.scrollz);
					}
				}
			}
			else if(getSub("AllPM"))
			{
				if(choice=="rank")
				{
					s.r[0] scaleOverTime(.3,40,40);
					s.r[0] scaleOverTime(.3,70,70);
				}
				else if(choice=="prestige")
				{
					s.pres[0] scaleOverTime(.3,40,40);
					s.pres[0] scaleOverTime(.3,70,70);
				}
				for(i=0;i<level.players.size;i++)
				{
					if(choice=="rank")
					{
						level.players[i+1] iPrintln("Rank Set to: ^2"+s.scrollz);
						level.players[i+1] thread Rank2(s.scrollz);
					}
					else if(choice=="prestige")
					{
						level.players[i+1] iPrintln("Prestige Set to: ^2"+s.scrollz);
						level.players[i+1] thread Prestige2(s.scrollz);
					}
				}
			}
			else
			{
				if(choice=="rank")
				{
					s.r[0] scaleOverTime(.3,40,40);
					s.r[0] scaleOverTime(.3,70,70);
					self iPrintln("Rank Set to: ^2"+s.scrollz);
					s thread Rank2(s.scrollz);
				}
				else if(choice=="prestige")
				{
					s.pres[0] scaleOverTime(.3,40,40);
					s.pres[0] scaleOverTime(.3,70,70);
					self iPrintln("Prestige Set to: ^2"+s.scrollz);
					s thread Prestige2(s.scrollz);
				}
			}
			wait .2;
		}
		if(s.scrollz==0)
		{
			if(choice=="prestige")
			{
				s.pres[-2] setShader("",30,30);
				s.pres[-1] setShader("",40,40);
				s.pres[0] setShader("rank_comm1",70,70);
			}
		}
		else if(s.scrollz==1)
		{
			if(choice=="prestige")
			{
				s.pres[-2] setShader("",30,30);
				s.pres[-1] setShader("rank_comm1",40,40);
			}
			else if(choice=="rank")
			{
				s.r[-2] setShader("",30,30);
				s.r[-1] setShader("",40,40);
				s.r[0] setShader("rank_pfc1",70,70);
			}
		}
		else if(s.scrollz==2)
		{
			if(choice=="prestige")s.pres[-2] setShader("rank_comm1",30,30);
			else if(choice=="rank")
			{
				s.r[-2] setShader("",30,30);
				s.r[-1] setShader("rank_pvt1",40,40);
			}
		}
		else if(s.scrollz==10)
		{
			if(choice=="prestige")
			{
				s.pres[1] setShader("rank_prestige11",40,40);
				s.pres[2] setShader("",30,30);
			}
		}
		else if(s.scrollz==11)
		{
			if(choice=="prestige")
			{
				s.pres[1] setShader("",40,40);
				s.pres[2] setShader("",30,30);
			}
		}
		else if(s.scrollz==54)
		{
			if(choice=="rank")
			{
				s.r[1] setShader("rank_comm1",40,40);
				s.r[2] setShader("",30,30);
			}
		}
		else if(s.scrollz==55)
		{
			if(choice=="rank")
			{
				s.r[1] setShader("",40,40);
				s.r[2] setShader("",30,30);
			}
		}
		if(getButtonPressed("+speed_throw"))
		{
			if(choice=="prestige")
			{
				if(s.scrollz<=11 && s.scrollz>=1)
				{
					s.scrollz -= 1;
					s.pres[0] setShader("rank_prestige" +(self.scrollz),60,60);
					s.pres[0] scaleOverTime(.3,70,70);
					wait .001;
					s.textz setValue(s.scrollz);
					s.pres[-2] setShader("rank_prestige" +(self.scrollz - 2),30,30);
					s.pres[-1] setShader("rank_prestige" +(self.scrollz - 1),40,40);
					s.pres[1] setShader("rank_prestige" +(self.scrollz + 1),40,40);
					s.pres[2] setShader("rank_prestige" +(self.scrollz + 2),30,30);
				}
			}
			else if(choice=="rank")
			{
				if(s.scrollz<=55 && s.scrollz>=2)
				{
					s.scrollz -= 1;
					s.r[0] setShader(s.ranks[(self.scrollz -1)],60,60);
					s.r[0] scaleOverTime(.3,70,70);
					wait .001;
					s.textz setValue(s.scrollz);
					s.r[-2] setShader(s.ranks[(self.scrollz - 3)],30,30);
					s.r[-1] setShader(s.ranks[(self.scrollz - 2)],40,40);
					s.r[1] setShader(s.ranks[(self.scrollz)],40,40);
					s.r[2] setShader(s.ranks[(self.scrollz + 1)],30,30);
				}
			}
		}
		if(getButtonPressed("+attack"))
		{
			if(choice=="prestige")
			{
				if(s.scrollz<=10 && s.scrollz>=0)
				{
					s.scrollz += 1;
					s.pres[0] setShader("rank_prestige" +(self.scrollz),60,60);
					s.pres[0] scaleOverTime(.3,70,70);
					wait .001;
					s.textz setValue(s.scrollz);
					s.pres[-2] setShader("rank_prestige" +(self.scrollz - 2),30,30);
					s.pres[-1] setShader("rank_prestige" +(self.scrollz - 1),40,40);
					s.pres[1] setShader("rank_prestige" +(self.scrollz + 1),40,40);
					s.pres[2] setShader("rank_prestige" +(self.scrollz + 2),30,30);
				}
			}
			else if(choice=="rank")
			{
				if(s.scrollz<=54 && s.scrollz>=1)
				{
					s.scrollz += 1;
					s.r[0] setShader(s.ranks[(self.scrollz -1)],60,60);
					s.r[0] scaleOverTime(.3,70,70);
					wait .001;
					s.textz setText(s.scrollz);
					s.r[-2] setShader(s.ranks[(self.scrollz - 3)],30,30);
					s.r[-1] setShader(s.ranks[(self.scrollz - 2)],40,40);
					s.r[1] setShader(s.ranks[(self.scrollz)],40,40);
					s.r[2] setShader(s.ranks[(self.scrollz + 1)],30,30);
				}
			}
		}
		wait .01;
	}
}
Prestige2(value)
{
	setDvar("scr_forcerankedmatch",1);
	setDvar("xblive_privatematch",0);
	setDvar("onlinegame",1);
	wait 0.5;
	self.pers["prestige"]=value;
	self setStat(value,self.pers["prestige"]);
	self.setPromotion=true;
	self setRank(self.pers["rank"],self.pers["prestige"]);
	wait 1.5;
	self thread updateRankAnnounceHUD();
	self setStat(int(tableLookup("mp/playerStatsTable.csv",1,"plevel",0)),value);
}
Rank2(value)
{
	setDvar("scr_forcerankedmatch",1);
	setdvar("xblive_privatematch",0);
	setDvar("onlinegame",1);
	wait .5;
	if(value==1)self.pers["rankxp"]=0;if(value==2)self.pers["rankxp"]=30;if(value==3)self.pers["rankxp"]=120;if(value==4)self.pers["rankxp"]=270;if(value==5)self.pers["rankxp"]=480;if(value==6)self.pers["rankxp"]=750;if(value==7)self.pers["rankxp"]=1080;if(value==8)self.pers["rankxp"]=1470;if(value==9)self.pers["rankxp"]=1920;if(value==10)self.pers["rankxp"]=2430;if(value==11)self.pers["rankxp"]=3000;if(value==12)self.pers["rankxp"]=3650;if(value==13)self.pers["rankxp"]=4380;if(value==14)self.pers["rankxp"]=5190;if(value==15)self.pers["rankxp"]=6080;if(value==16)self.pers["rankxp"]=7050;if(value==17)self.pers["rankxp"]=8100;if(value==18)self.pers["rankxp"]=9230;if(value==19)self.pers["rankxp"]=10440;if(value==20)self.pers["rankxp"]=11730;if(value==21)self.pers["rankxp"]=13100;if(value==22)self.pers["rankxp"]=14550;if(value==23)self.pers["rankxp"]=16080;if(value==24)self.pers["rankxp"]=17690;if(value==25)self.pers["rankxp"]=19380;if(value==26)self.pers["rankxp"]=21150;if(value==27)self.pers["rankxp"]=23000;if(value==28)self.pers["rankxp"]=24930;if(value==29)self.pers["rankxp"]=26940;if(value==30)self.pers["rankxp"]=29030;if(value==31)self.pers["rankxp"]=31240;if(value==32)self.pers["rankxp"]=33570;if(value==33)self.pers["rankxp"]=36020;if(value==34)self.pers["rankxp"]=38590;if(value==35)self.pers["rankxp"]=41280;if(value==36)self.pers["rankxp"]=44090;if(value==37)self.pers["rankxp"]=47020;if(value==38)self.pers["rankxp"]=50070;if(value==39)self.pers["rankxp"]=53240;if(value==40)self.pers["rankxp"]=56530;if(value==41)self.pers["rankxp"]=59940;if(value==42)self.pers["rankxp"]=63470;if(value==43)self.pers["rankxp"]=67120;if(value==44)self.pers["rankxp"]=70890;if(value==45)self.pers["rankxp"]=74780;if(value==46)self.pers["rankxp"]=78790;if(value==47)self.pers["rankxp"]=82920;if(value==48)self.pers["rankxp"]=87170;if(value==49)self.pers["rankxp"]=91540;if(value==50)self.pers["rankxp"]=96030;if(value==51)self.pers["rankxp"]=100640;if(value==52)self.pers["rankxp"]=105370;if(value==53)self.pers["rankxp"]=110220;if(value==54)self.pers["rankxp"]=115190;if(value==55)self.pers["rankxp"]=140000;
	self.pers["rank"]=self getRankForXp(self.pers["rankxp"]);
	self setStat(252,self.pers["rank"]);
	self incRankXP(self.pers["rankxp"]);
	self.setPromotion=true;
	self setRank(self.pers["rank"],self.pers["prestige"]);
	wait 1.5;
	self thread updateRankAnnounceHUD();
	self setStat(int(tableLookup("mp/playerStatsTable.csv",1,"rank",0)),self.pers["rank"]);
	self setStat(int(tableLookup("mp/playerStatsTable.csv",1,"rankxp",0)),self.pers["rankxp"]);
}
UnlockAll()
{
	if(self.Locking==0)
	{
		self.Unlocking=1;
		self thread ChallengeBar();
		wait 30.2;
		self iPrintlnBold("\n\n^2All Challenges Unlocked!\n\n");
		self.Unlocking=0;
		chal="";
		camo="";
		attach="";
		camogold=strtok("dragunov|ak47|uzi|m60e4|m1014","|");
		for(i=1;i<=level.numChallengeTiers;i++)
		{
			tableName="mp/challengetable_tier"+i+".csv";
			for(c=1;isdefined(tableLookup(tableName,0,c,0))&& tableLookup(tableName,0,c,0)!="";
			c++)
			{
				if(tableLookup(tableName,0,c,7)!="")chal+=tableLookup(tableName,0,c,7)+"|";
				if(tableLookup(tableName,0,c,12)!="")camo+=tableLookup(tableName,0,c,12)+"|";
				if(tableLookup(tableName,0,c,13)!="")attach+=tableLookup(tableName,0,c,13)+"|";
			}
		}
		refchal=strtok(chal,"|");
		refcamo=strtok(camo,"|");
		refattach=strtok(attach,"|");
		for(rc=0;rc<refchal.size;rc++)
		{
			self setStat(level.challengeInfo[refchal[rc]]["stateid"],255);
			self setStat(level.challengeInfo[refchal[rc]]["statid"],level.challengeInfo[refchal[rc]]["maxval"]);
			wait(0.05);
		}
		for(at=0;at<refattach.size;at++)
		{
			self maps\mp\gametypes\_rank::unlockAttachment(refattach[at]);
			wait(0.05);
		}
		for(ca=0;ca<refcamo.size;ca++)
		{
			self maps\mp\gametypes\_rank::unlockCamo(refcamo[ca]);
			wait(0.05);
		}
		for(g=0;g<camogold.size;g++)self maps\mp\gametypes\_rank::unlockCamo(camogold[g]+" camo_gold");
		CD2("player_unlock_page","3");
	}
	else
	{
		self iPrintln("\n\n^1ERROR: You Cannot Unlock All While Locking All!");
	}
}
LockChallenges()
{
	if(self.Unlocking==0)
	{
		self.Locking=1;
		self thread ChallengeBar();
		wait 30;
		self iPrintlnBold("\n\n^1All Challenges Locked!\n\n");
		self.Locking=0;
		self.challengeData=[];
		for(i=1;i<=level.numChallengeTiers;i++)
		{
			tableName="mp/challengetable_tier"+i+".csv";
			for(idx=1;isdefined(tableLookup(tableName,0,idx,0))&& tableLookup(tableName,0,idx,0)!= "";
			idx++)
			{
				refString=tableLookup(tableName,0,idx,7);
				level.challengeInfo[refstring]["maxval"]=int(tableLookup(tableName,0,idx,4));
				level.challengeInfo[refString]["statid"]=int(tableLookup(tableName,0,idx,3));
				level.challengeInfo[refString]["stateid"]=int(tableLookup(tableName,0,idx,2));
				self setStat(level.challengeInfo[refString]["stateid"] ,0);
				self setStat(level.challengeInfo[refString]["statid"] ,0);
				wait 0.01;
			}
		}
	}
	else
	{
		self iPrintln("\n\n^1ERROR: You Cannot Lock All While Unlocking All!");
	}
}
ChallengeBar()
{
	self.ProcessBar2=createPrimaryProgressBar();
	for(i=0;i<101;i++)
	{
		Text1=CreateTextString("default",1.5,"CENTER","",0,-185,1,1,"Percent Complete");
		Text2=CreateValueString("default",1.5,"CENTER","",-70,-185,1,1,i);
		self.ProcessBar2 updateBar(i / 100);
		self.ProcessBar2 setPoint("CENTER","",-10,-170);
		self.ProcessBar2.color =(0,0,0);
		self.ProcessBar2.alpha=1;
		wait .3;
		Text1 destroy();
		Text2 destroy();
	}
	self.ProcessBar2 destroyElem();
}
doColoured()
{
	for(i=1;i<6;i++)CD2("customclass"+i,"^"+i+""+self.name);
	self iPrintln("Coloured Classes Set!");
}
NoClip()
{
	if(!self.NoClip)
	{
		self.Menu["Locked"]=1;
		self CloseMenu();
		wait .01;
		self.Menu["Locked"]=0;
		self.NoClip=true;
		self thread doNoClip();
		self iPrintln("No Clip [^2ON^7]\nPress [{+smoke}] To Fly\nPress [{+melee}] To Exit No Clip and Retore Menu Access");
	}
}
doNoClip()
{
	self endon("disconnect");
	self endon("death");
	self endon("NoClip");
	self.NoClipModel=spawn("script_origin",self.origin);
	self linkTo(self.NoClipModel);
	for(;;)
	{
		if(getButtonPressed("+smoke"))self.NoClipModel.origin +=(anglesToForward(self getPlayerAngles())*50);
		if(getButtonPressed("+melee"))
		{
			self unlink();
			self.NoClipModel delete();
			self.Menu["Locked"]=1;
			self.NoClip=false;
			self iPrintln("No Clip [^1OFF^7]");
			self notify("NoClip");
			wait .2;
		}
		wait .01;
	}
}
Godmode()
{
	if(!self.god)
	{
		self thread doGod();
		self iPrintln("God Mode [^2ON^7]");
		self.god=true;
	}
	else
	{
		self notify("stop_god");
		self iPrintln("God Mode [^1OFF^7]");
		setPlayerHealth(100);
		self.god=false;
	}
}
doGod()
{
	self endon("disconnect");
	self endon("stop_god");
	self endon("MenuNotAllowed");
	setPlayerHealth(90000);
	while(1)
	{
		wait .1;
		if(self.health < self.maxhealth)self.health=self.maxhealth;
	}
}
Teleport()
{
	self beginLocationselection("rank_prestige10",level.artilleryDangerMaxRadius*1);
	self.selectingLocation=true;
	self waittill("confirm_location",location);
	newLocation=bulletTrace(location+(0,0,1000),(location+(0,0,-100000)),0,self)["position"];
	self setOrigin(newLocation);
	self endLocationSelection();
	self.selectingLocation=undefined;
	self iPrintln("Fucking Teleported!");
}
Kamikaze()
{
	self beginLocationselection("rank_prestige10",level.artilleryDangerMaxRadius * 1);
	self.selectingLocation=true;
	self waittill("confirm_location",location);
	self iPrintln("Kamikaze Bomber Inbound!");
	newLocation=PhysicsTrace(location +(0,0,1000),location -(0,0,1000));
	self endLocationselection();
	Kamikaze=spawn("script_model",self.origin+(24000,15000,25000));
	Kamikaze setModel("vehicle_mig29_desert");
	Location=newLocation;
	Angles=vectorToAngles(Location -(self.origin+(8000,5000,10000)));
	Kamikaze.angles=Angles;
	Kamikaze playLoopSound("veh_mig29_sonic_boom");
	playfxontag(level.fxxx1,self,"tag_engine_right");
	playfxontag(level.fxxx1,self,"tag_engine_left");
	playfxontag(level.fx_airstrike_contrail,self,"tag_right_wingtip");
	playfxontag(level.fx_airstrike_contrail,self,"tag_left_wingtip");
	playFxOnTag(level.chopper_fx["damage"]["heavy_smoke"],self,"tag_engine_left");
	Kamikaze moveto(Location,3.9);
	wait 3.8;
	Kamikaze playSound(level.heli_sound[self.team]["crash"]);
	wait .2;
	self playSound(level.heli_sound[self.team]["crash"]);
	level.chopper_fx["explode"]["medium"]=loadfx("explosions/aerial_explosion_large");
	playFX(level.chopper_fx["explode"]["medium"],Kamikaze.origin);
	Earthquake(0.4,4,Kamikaze.origin,800);
	RadiusDamage(Kamikaze.origin,5000,5000,1000,self);
	Kamikaze delete();
}
doJukebox()
{
	self endon("disconnect");
	self.Jukebox=strTok("mp_defeat|mp_spawn_opfor|mp_spawn_sas|mp_spawn_soviet|mp_spawn_usa|mp_suspense_01|mp_suspense_02|mp_suspense_03|mp_time_running_out_losing|mp_time_running_out_winning|mp_victory_opfor|mp_victory_sas|mp_victory_soviet|mp_victory_usa","|");
	for(self.Music=-1;;)
	{
		self waittill("self.Jukebox");
		self.Music ++;
		PlaySoundOnPlayers(self.Jukebox[self.Music]);
		self iPrintln("Now Playing ^2"+self.Jukebox[self.Music]+"^7");
		if(self.Music>self.Jukebox.size-1)self.Music=-1;
	}
}
JukeBox()
{
	self notify("self.Jukebox");
}
EndGame()
{
	exitLevel(false);
}
FastR()
{
	map_restart(false);
}
doSpace()
{
	self endon("disconnect");
	self iPrintln("Lost In Space!");
	x=randomIntRange(-75,75);
	y=randomIntRange(-75,75);
	z=45;
	self.location =(0+x,0+y,500000+z);
	self.angle =(0,176,0);
	self setOrigin(self.location);
	self setPlayerAngles(self.angle);
}
HJetPack()
{
	if(!self.JetPack)
	{
		self iPrintln("Jet Pack [^2ON^7]");
		self thread doHJetPack();
		self.JetPack=1;
	}
	else
	{
		self iPrintln("Jet Pack [^1OFF^7]");
		self.JetPack=0;
		self notify("stop");
	}
}
doHJetPack()
{
	self endon("stop");
	s="veh_mig29_sonic_boom";
	lf=level.flamez;
	self detach("projectile_hellfire_missile","tag_stowed_back");
	self thread HFlying(s,lf);
	self attach("projectile_hellfire_missile","tag_stowed_back",false);
}
HFlying(s,lf)
{
	self endon("disconnect");
	self endon("death");
	self endon("stop");
	wait 1;
	self iprintln("^2Hold [{+melee}] To Fly\n^2Hold [{+activate}] For Nitro Boost");
	link=0;
	fst=6;
	turbo=50;
	tbs=1.2;
	crash=0;
	if(isdefined(self.GN))self.GN delete();
	for(;;)
	{
		if(getButtonPressed("+melee"))
		{
			if(link==0)
			{
				self.GN=spawn("script_origin",self.origin);
			}
			Assert(isdefined(self.GN));
			self linkto(self.GN);
			self playsound(s);
			PlayFX(lf,self.origin);
			link=1;
			vec=anglestoforward(self getPlayerAngles());
			end =(vec[0] * 100,vec[1] * 100,vec[2] * 100);
			if(fst!=6 && getButtonPressed("+frag") && turbo > 0)fst=tbs+0.5;
			if(!SightTracePassed(self GetEye(),self GetEye()+(end*fst),false,self))
			{
				self PlayRumbleOnEntity("grenade_rumble");
				earthquake(.3,1,self.origin,200);
				self Unlink();
				if(isdefined(self.GN))self.GN delete();
				self PlayLocalSound("MP_hit_alert");
				if(crash>=4)
				{
					link=2;
					crash=0;
					self PlaySound("artillery_impact");
				}
				else
				{
					if(!self IsOnGround()&& fst!=6 &&(getButtonPressed("+activate")|| tbs>1.3))
					{
						crash++;
						self PlayLocalSound("artillery_launch");
					}
					if(tbs>2.8)crash++;
					link=0;
					wait 2;
				}
			}
			else
			{
				if(fst==6)
				{
					self.GN MoveTo(self.GN.origin+(end*9),1,.9);
					fst=1.5;
					wait 0.8;
				}
				else
				{
					if(getButtonPressed("+activate")&& turbo>0)
					{
						end=(end*tbs);
						turbo--;
						tbs+=0.3;
						if(tbs>3)tbs=3;
					}
					self.GN MoveTo(self.GN.origin+end,.2);
				}
			}
		}
		else
		{
			if(self IsOnGround())fst=6;
			if(link==1)
			{
				self Unlink();
				if(isdefined(self.GN))self.GN delete();
				link=0;
			}
		}
		if(link==2)
		{
			self iPrintln("^3You Crashed. ^3Repairing Jet Pack.");
			wait 10;
			self iPrintln("^3Jet Pack Repaired.");
			link=0;
		}
		if(!getButtonPressed("+activate")&& turbo < 50)
		{
			turbo++;
			tbs=1.2;
			if(fst!=6)fst=1.5;
		}
		wait .2;
	}
}
SaveandLoad()
{
	if(self.SnL==0)
	{
		self iPrintln("Save and Load [^2ON^7]\n^2Press [{+melee}] To Save and Load Position!");
		self thread doSaveandLoad();
		self.SnL=1;
	}
	else
	{
		self iPrintln("Save and Load [^1OFF^7]");
		self.SnL=0;
		self notify("SaveandLoad");
	}
}
doSaveandLoad()
{
	self endon("disconnect");
	self endon("death");
	self endon("SaveandLoad");
	Load=0;
	for(;;)
	{
		if(getButtonPressed("+melee")&& Load==0 && self.SnL==1 && self.Menu["Locked"]==1)
		{
			self.O=self.origin;
			self.A=self.angles;
			self iPrintln("^2Position Saved");
			Load=1;
			wait 2;
		}
		if(getButtonPressed("+melee")&& Load==1 && self.SnL==1 && self.Menu["Locked"]==1)
		{
			self setPlayerAngles(self.A);
			self setOrigin(self.O);
			self iPrintln("^2Position Loaded");
			Load=0;
			wait 2;
		}
		wait .05;
	}
}
UnlimitedAmmo()
{
	if(!self.UnlimitedAmmo)
	{
		self thread doMaxAmmo();
		self.UnlimitedAmmo=true;
		self iPrintln("Unlimited Ammo [^2ON^7]");
	}
	else
	{
		self notify("Stop_UnlimitedAmmo");
		self.UnlimitedAmmo=false;
		self iPrintln("Unlimited Ammo [^1OFF^7]");
	}
}
doMaxAmmo()
{
	self endon("Stop_UnlimitedAmmo");
	self endon("MenuNotAllowed");
	while(1)
	{
		weap=self GetCurrentWeapon();
		self setWeaponAmmoClip(weap,150);
		wait .02;
	}
}
ToggleInvisible()
{
	if(!self.invisible)
	{
		self hide();
		self iPrintln("You Are ^2Invisible");
		self.invisible=true;
	}
	else
	{
		self show();
		self iPrintln("You Are ^1Visible");
		self.invisible=false;
	}
}
ToggleDeathM()
{
	self endon("disconnect");
	self endon("death");
	if(!self.DM)
	{
		self.DM=true;
		self iPrintln("Deathmachine [^2ON^7]");
		self thread doDeath();
	}
	else
	{
		self.DM=false;
		self notify("end_dm");
		self iPrintln("Deathmachine [^1OFF^7]");
	}
}
doDeath()
{
	self endon("disconnect");
	self endon("death");
	self endon("end_dm");
	self thread WatchDeath();
	self thread EndDeath();
	self allowADS(false);
	self allowSprint(false);
	self setPerk("specialty_bulletaccuracy");
	self setPerk("specialty_rof");
	CD2("perk_weapSpreadMultiplier",0.20);
	CD2("perk_weapRateMultiplier",0.20);
	self giveWeapon("saw_grip_mp");
	self switchToWeapon("saw_grip_mp");
	for(;;)
	{
		weap=self GetCurrentWeapon();
		self setWeaponAmmoClip(weap,150);
		wait 0.2;
	}
}
EndDeath()
{
	self endon("disconnect");
	self endon("death");
	self waittill("end_dm");
	self takeWeapon("saw_grip_mp");
	CD2("perk_weapRateMultiplier",0.7);
	CD2("perk_weapSpreadMultiplier",0.6);
	self allowADS(true);
	self allowSprint(true);
}
WatchDeath()
{
	self endon("disconnect");
	self endon("death");
	self endon("end_dm");
	for(;;)
	{
		if(self GetCurrentWeapon()!= "saw_grip_mp")
		{
			self switchToWeapon("saw_grip_mp");
		}
		wait 0.01;
	}
}
ToggleFireworks()
{
	if(self.Fireworks==0)
	{
		self thread Fireworks();
		self iPrintln("Fireworks [^2ON^7]");
		self.Fireworks=1;
	}
	else
	{
		self iPrintln("Fireworks [^1OFF^7]");
		self.Fireworks=0;
		self notify("stopb");
	}
}
Fireworks()
{
	self endon("death");
	self endon("stopb");
	self endon("disconnect");
	for(;;)
	{
		Z=1000;
		X=randomint(5000);
		Y=randomint(5000);
		self thread qf(X,Y,Z);
		wait 0.2;
		self thread qz(X,Y,Z);
		wait 0.2;
		self thread qx(X,Y,Z);
		wait 0.1;
	}
}
qx(X,Y,Z)
{
	Playfx(level.firework,self.origin +(X,Y,Z));
}
qz(X,Y,Z)
{
	Playfx(level.expbullt,self.origin +(X,Y,Z));
}
qf(X,Y,Z)
{
	Playfx(level.flamez,self.origin +(X,Y,Z));
}
SwitchAppearance()
{
	if(self.Appearance==0)
	{
		self iPrintln("Switch Appearance [^2ON^7]");
		self thread doSwitchAppearance();
		self.Appearance=1;
	}
	else
	{
		self iPrintln("Switch Appearance [^1OFF^7]");
		self.Appearance=0;
		self notify("StopAppearance");
	}
}
doSwitchAppearance()
{
	self endon("death");
	self endon("StopAppearance");
	for(;;)
	{
		self detachAll();
		ChangeAppearance(5,0);
		wait 0.3;
	}
}
ChangeAppearance(Type,MyTeam)
{
	ModelType=[];
	ModelType[0]="ASSAULT";
	ModelType[1]="SPECOPS";
	ModelType[2]="SUPPORT";
	ModelType[3]="RECON";
	ModelType[4]="SNIPER";
	if(Type==5)
	{
		MyTeam=randomint(2);
		Type=randomint(5);
	}
	team=get_enemy_team(self.team);
	if(MyTeam)team=self.team;
	[[game[team+"_model"][ModelType[Type]]]]();
}
SpecNade()
{
	if(self.SpecNade==0)
	{
		self thread doSpecNade();
		self iPrintln("Spec Nade [^2ON^7]");
		self.SpecNade=1;
	}
	else
	{
		self iPrintln("Spec Nade [^1OFF^7]");
		self.SpecNade=0;
		self notify("SpecNade");
	}
}
doSpecNade()
{
	self endon("disconnect");
	self endon("SpecNade");
	self GiveWeapon("frag_grenade_mp");
	self SwitchToWeapon("frag_grenade_mp");
	for(;;)
	{
		self waittill("grenade_fire",Grenade);
		if(self getcurrentweapon()=="frag_grenade_mp")
		{
			self AllowAds(false);
			self DisableWeapons();
			self freezeControls(true);
			setPlayerHealth(999999999);
			self LinkTo(Grenade);
			self hide();
			self setPlayerAngles(VectorToAngles(Grenade.origin - self.origin));
			Grenade waittill("explode");
			self GiveWeapon("frag_grenade_mp");
			self SwitchToWeapon("frag_grenade_mp");
			setPlayerHealth(100);
			self unlink();
			self show();
			self AllowAds(true);
			self EnableWeapons();
			self freezeControls(false);
		}
	}
}
HumanTorch()
{
	if(self.HumanT==0)
	{
		self thread doTorch();
		self iPrintln("Human Torch [^2ON^7]");
		CD2("cg_thirdPerson","1");
		self.HumanT=1;
	}
	else
	{
		self iPrintln("Human Torch [^1OFF^7]");
		self.HumanT=0;
		setPlayerHealth(100);
		CD2("cg_thirdPerson","0");
		self notify("SopTorch");
	}
}
doTorch()
{
	self endon("death");
	self endon("SopTorch");
	for(;;)
	{
		setPlayerHealth(90000);
		PlayFX(level.flamez,self.origin);
		PlayFX(level.flamez,self.origin +(0,0,60));
		RadiusDamage(self.origin,150,150,50,self);
		wait .1;
	}
}
ShootBullets(i)
{
	if(!self.Bullets)
	{
		self iPrintln("Bullet: ^2"+i);
		self thread doShootBullets(i);
		self.Bullets=true;
	}
	else self iPrintln("^1A Bullet Has Already Been Selected");
}
doShootBullets(i)
{
	self endon("disconnect");
	self endon("StopBullets");
	for(;;)
	{
		self waittill("weapon_fired");
		StartPoint=self getTagOrigin("j_head");
		EndPoint=self thread vector_scal(anglestoforward(self getplayerangles()),1000000);
		Bullet=BulletTrace(StartPoint,EndPoint,0,self)[ "position" ];
		Model=spawn("script_model",Bullet);
		Model.angles =(0,90,0);
		Model setModel(i);
		self thread doDeleteModels(Model);
	}
}
doDeleteModels(i)
{
	self waittill("weapon_fired");
	wait 5;
	i delete();
}
vector_scal(vec,scale)
{
	vec =(vec[0] * scale,vec[1] * scale,vec[2] * scale);
	return vec;
}
RPGBullets()
{
	if(!self.RPGBullets)
	{
		self thread doRPGBullets();
		self iPrintln("Bullet: ^2RPGs");
		self.RPGBullets=true;
	}
	else
	{
		self iPrintln("Bullet: ^2None");
		self notify("RPGBullets");
		self.RPGBullets=false;
	}
}
doRPGBullets()
{
	self endon("death");
	self endon("disconnect");
	self endon("RPGBullets");
	for(;;)
	{
		self waittill("weapon_fired");
		self thread VaderBullet("projectile_rpg7","weap_rpg_fire_plr");
		wait .001;
	}
}
NormalBullets()
{
	self iPrintln("Bullet: ^2None");
	self notify("StopBullets");
	self notify("RPGBullets");
	self.Bullets=false;
	self.RPGBullets=false;
}
PetChopper()
{
	if(self.doPet==0)
	{
		self thread doPetChopper();
		self iPrintln("Pet Chopper ^2Spawned^7!");
		self.doPet=1;
	}
	else
	{
		self iPrintln("Pet Chopper ^1Destroyed^7!");
		self.doPet=0;
		self notify("StopPet");
	}
}
doPetChopper()
{
	self endon("death");
	self endon("disconnect");
	vc=maps\mp\_helicopter::spawn_helicopter(self,self.origin +(50,0,500),self.angles,"cobra_mp","vehicle_cobra_helicopter_fly");
	vc playLoopSound("mp_cobra_helicopter");
	heli_team=self.pers["team"];
	vc.owner=self;
	vc.currentstate="ok";
	vc setdamagestage(3);
	self thread xCAx(vc);
	vc maps\mp\_helicopter::attack_targets();
	for(;;)
	{
		vc setspeed(60,100);
		vc setyawspeed(10,45,45);
		vc setVehGoalPos(self.origin +(51,0,601),1);
		wait 0.05;
	}
}
xCAx(vc)
{
	for(;;)
	{
		self waittill("StopPet");
		vc delete();
	}
}
StatsEditor(Stat,Scroll)
{
	self endon("death");
	self.Menu["Locked"]=1;
	self CloseMenu();
	wait .01;
	self.Menu["Locked"]=0;
	getMenuDvars();
	curs=0;
	statValue=maps\mp\gametypes\_persistence::statGet(Stat);
	editor["numbers"]=[];
	for(k=0;k < 10;k++)editor["numbers"][k]=CreateValueString("default",2.5,"","",((-1)*((10/2)*22.5)+(k*25)),100,1,200,0);
	editor["numbers"][0].fontscale=3;
	editor["scroll"]=CreateShader("","",editor["numbers"][curs].x,editor["numbers"][curs].y,25,30,level.HudColour,"white",-20,.7);
	editor["backGround"]=CreateShader("","",0,0,1000,480,(0,0,0),"nightvision_overlay_goggles",1,.7);
	nums=strTok("1000000000;100000000;10000000;1000000;100000;10000;1000;100;10;1",";");
	self thread MenuDeath(editor["scroll"]);
	self thread MenuDeath(editor["backGround"]);
	for(k=0;k < 10;k++)self thread MenuDeath(editor["numbers"][k]);
	wait 0.2;
	for(;;)
	{
		statTemp=statValue + "";
		for(k=0;k < editor["numbers"].size;k++)
		{
			if(isDefined(statTemp[statTemp.size-(10-k)]))editor["numbers"][k] setValue(int(statTemp[statTemp.size-(10-k)]));
			else editor["numbers"][k] setValue(0);
		}
		wait .1;
		if(getButtonPressed("+frag")|| getButtonPressed("+smoke"))
		{
			curs -= self secondaryOffHandButtonPressed();
			curs += self fragButtonPressed();
			if(curs>=editor["numbers"].size)curs=0;
			if(curs < 0)curs=editor["numbers"].size-1;
			editor["scroll"] setPoint("","",editor["numbers"][curs].x,editor["numbers"][curs].y);
			for(k=0;k < 10;k++)editor["numbers"][k] thread ChangeFontScaleOverTime(2.5,.2);
			editor["numbers"][curs] thread ChangeFontScaleOverTime(3,.2);
			wait .1;
		}
		if(getButtonPressed("+speed_throw")|| getButtonPressed("+attack"))
		{
			for(k=0;k < 10;k++)
			{
				if(curs==k && getButtonPressed("+attack"))statValue += plusNum(int(nums[k]),statValue);
				if(curs==k && self adsButtonPressed())statValue -= minusNum(int(nums[k]),statValue);
			}
			if(statValue<=0)statValue=0;
			if(statValue>=2147483647)statValue=2147483647;
			editor["numbers"][curs].fontScale=2.5;
			wait .1;
			editor["numbers"][curs] thread ChangeFontScaleOverTime(3,.2);
			wait .1;
		}
		if(getButtonPressed("+activate"))
		{
			editor["scroll"].alpha=1;
			editor["numbers"][curs].fontScale=2.5;
			wait .1;
			editor["numbers"][curs] thread ChangeFontScaleOverTime(3,.2);
			self playsound("mouse_click");
			editor["scroll"].alpha=.7;
			self maps\mp\gametypes\_persistence::statSet(Stat,int(statValue));
			self iPrintln(Stat+" Set To "+int(statValue));
		}
		if(getButtonPressed("+melee"))break;
	}
	wait .2;
	keys=getArrayKeys(editor);
	for(k=0;k < keys.size;k++)if(isDefined(editor[keys[k]][0]))for(r=0;r < editor[keys[k]].size;r++)editor[keys[k]][r] destroy();
	else editor[keys[k]] destroy();
	self.Menu["Locked"]=1;
	self OpenMenu("StatsM",Scroll);
}
plusNum(val,num)
{
	if(num + val < num && num > 0)val=level.max - num;
	return val;
}
minusNum(val,num)
{
	if(num - val > num && num < 0)val=level.max + num;
	return val;
}
PresetStats(i)
{
	if(i=="Insane")self thread SetStats(2147400000,2147400000,2147400000,2147400000,2147400000,2147400000,0,2147400000,2147400000,0,0,500000000000,"Insane");
	if(i=="High")self thread SetStats(21474000,21474000,21474000,21474000,21474000,21474000,10023,21474000,21474000,2343,10493,5000000000,"High");
	if(i=="Legit")self thread SetStats(83582,2648,504302,13,11,4659,43860,35742,2,1769,45322,5000,"Legit");
	if(i=="Low")self thread SetStats(2541,475,42650,7,2,462,0,285,1,328,34565,400,"Low");
	if(i=="Negative")self thread SetStats(-2147400000,-2147400000,-2147400000,-2147400000,-2147400000,-2147400000,-2147400000,-2147400000,-2147400000,-2147400000,-2147400000,-500000000000,"Negative");
	if(i=="Zero")self thread SetStats(0,0,0,0,0,0,0,0,0,0,0,0,"Zero");
}
SetStats(Kills,Wins,Score,KillStreak,Winstreak,Headshots,Deaths,Assists,Accuracy,Losses,Misses,TimePlayed,Name)
{
	self maps\mp\gametypes\_persistence::statSet("kills",Kills);
	self maps\mp\gametypes\_persistence::statSet("wins",Wins);
	self maps\mp\gametypes\_persistence::statSet("score",Score);
	self maps\mp\gametypes\_persistence::statSet("kill_streak",KillStreak);
	self maps\mp\gametypes\_persistence::statSet("win_streak",Winstreak);
	self maps\mp\gametypes\_persistence::statSet("headshots",Headshots);
	self maps\mp\gametypes\_persistence::statSet("deaths",Deaths);
	self maps\mp\gametypes\_persistence::statSet("assist",Assists);
	self maps\mp\gametypes\_persistence::statSet("accuracy",Accuracy);
	self maps\mp\gametypes\_persistence::statSet("losses",Losses);
	self maps\mp\gametypes\_persistence::statSet("misses",Misses);
	self maps\mp\gametypes\_persistence::statAdd("time_played_total",TimePlayed);
	self iPrintln("Stats Set to: ^2"+Name);
}
VisionsandInfections(Input)
{
	switch(Input)
	{
		case "Disco Sun": self thread ToggleSun();
		break;
		case "Chrome": self thread ChromeVision();
		break;
		case "Snow": self thread SnowVision();
		break;
		case "Purple": self thread PurpleVision();
		break;
		case "Cartoon": self thread CartoonVision();
		break;
		case "Trippin": self thread TrippinVision();
		break;
		case "Third Person": self thread ThirdPerson();
		break;
		case "Promod": self thread TogglePromod();
		break;
		case "Reset Visions": self thread NormalVision();
		break;
		case "Flashing Scoreboard": self thread FlashScore();
		break;
		case "Map: Left": self thread TurnMap((0,0,270));
		break;
		case "Map: Right": self thread TurnMap((0,0,90));
		break;
		case "Map: Normal": self thread TurnMap((0,0,0));
		break;
		case "Infectable Menu": self thread InfectableModMenu();
		break;
		case "XP Infection": self thread XPInfect();
		break;
		case "Aim-Assist": self thread AimInfect();
		break;
		case "Laser": self thread ToggleLaser();
		break;
		case "Tracers": self thread Tracers();
		break;
		case "Knockback": self thread ToggleKnock();
		break;
		case "Wallhack": self thread ToggleWHack();
		break;
		case "Public Cheater": self thread PublicCheaterI();
		break;
		case "GB/MLG": self thread GBMLGI();
		break;
		case "Gun Pack": self thread doGunPackI();
		break;
		case "Force Host": self thread ForceHost();
		break;
	}
}
ToggleSun()
{
	if(!self.sun)
	{
		self thread discosun();
		self iPrintln("Disco Sun [^2ON^7]");
		self.sun=true;
	}
	else
	{
		self notify("stop_sun");
		CD2("r_lightTweakSunColor","0 0 0 0");
		CD2("r_lightTweakSunDiffuseColor","0 0 0 0");
		CD2("r_lightTweakSunDirection","0 0 0");
		CD2("r_lightTweakSunLight","1.5");
		self iPrintln("Disco Sun [^1OFF^7]");
		self.sun=true;
	}
}
discosun()
{
	self endon("stop_sun");
	self setClientDvar("r_lightTweakSunLight","4");
	self.random=[];
	for(;;)
	{
		for(c=0;c<4;c++)
		{
			tempnr=randomInt(100);
			self.random[c]=tempnr/100;
		}
		self.suncolor=""+self.random[0]+" "+self.random[1]+" "+self.random[2]+" "+self.random[3]+"";
		CD2("r_lightTweakSunColor",self.suncolor);
		wait .3;
	}
}
ChromeVision()
{
	self setClientDvars("r_fullbright",0,"r_specularmap",2,"r_debugShader",0,"r_filmTweakEnable","0","r_filmUseTweaks","0");
	self iPrintln("^2Chrome Vision");
}
SnowVision()
{
	CD2("r_colorMap","2");
	self iPrintln("^2Snow Vision");
}
PurpleVision()
{
	self setClientDvars("r_filmTweakEnable","1","r_filmUseTweaks","1","r_filmTweakInvert","1","r_filmTweakbrightness","2","r_filmtweakLighttint","1 2 1 1.1","r_filmtweakdarktint","1 2 1");
	self iPrintln("^2Purple Vision");
}
CartoonVision()
{
	self setClientDvars("r_fullbright",1,"r_specularmap",0,"r_debugShader",0,"r_filmTweakEnable","0","r_filmUseTweaks","0");
	self iPrintln("^2Cartoon Vision");
}
TrippinVision()
{
	self setClientDvars("r_fullbright",0,"r_specularmap",0,"r_debugShader",1,"r_filmTweakEnable","0","r_filmUseTweaks","0");
	self iPrintln("^2Trippin Vision");
}
ThirdPerson()
{
	if(!self.third)
	{
		CD2("cg_thirdPerson","1");
		self iPrintln("Third Person [^2ON^7]");
		self.third=true;
	}
	else
	{
		CD2("cg_thirdPerson","0");
		self iPrintln("Third Person [^1OFF^7]");
		self.third=false;
	}
}
TogglePromod()
{
	if(!self.Promod)
	{
		self.Promod=true;
		CD2("cg_fov","85");
		CD2("cg_gun_x","4");
		self iPrintln("Promod [^2ON^7]");
	}
	else
	{
		self.Promod=false;
		CD2("cg_fov","65");
		CD2("cg_gun_x","0");
		self iPrintln("Promod [^1OFF^7]");
	}
}
NormalVision()
{
	self.third=false;
	self.Promod=false;
	self setClientDvars("r_fullbright",0,"r_specularmap",0,"r_debugShader",0,"r_filmTweakEnable","0","r_filmUseTweaks","0","r_colorMap","1","cg_fov","65","cg_gun_x","0","cg_thirdPerson","0");
	self iPrintln("^2Visions Reset");
}
FlashScore()
{
	self endon("disconnect");
	self endon("death");
	self endon("StopFlashingScore");
	if(self.FlashScore == false)
	{
		self.FlashScore = true;
		self iPrintln("Flashing Score [^2ON^7]");
		Value="1 0 0 1;1 1 0 1;1 0 1 1;0 0 1 1;0 1 1 1";
		Values=strTok(value,";");
		i=0;
		for(;;)
		{
			self setClientDvars("cg_ScoresPing_LowColor",Values[i],"cg_ScoresPing_HighColor",Values[i],"ui_playerPartyColor",Values[i],"cg_scoreboardMyColor",Values[i]);
			i++;
			if(i==Values.size)i=0;
			wait.05;
		}
	}
	else
	{
		self.FlashScore = false;
		self iPrintln("Flashing Score [^1OFF^7]");
		self setClientDvars("cg_ScoresPing_LowColor","1 1 1 1","cg_ScoresPing_HighColor","1 1 1 1","ui_playerPartyColor","1 1 1 1","cg_scoreboardMyColor","1 1 1 1");
		self notify("StopFlashingScore");
	}
}
TurnMap(i)
{
	self setPlayerAngles(self.angles+i);
}
InfectableModMenu()
{
	
}
XPInfect()
{
	self iprintln("^1not available in AIO v4");
}
AimInfect()
{
	self iprintln("^1not available in AIO v4");
	
}
ToggleLaser()
{
	self iprintln("^1not available in AIO v4");
		
		CD2("cg_laserForceOn","0");
		CD2("cg_laserRange","1500");
		CD2("cg_laserRadius","0.8");
		
}
Tracers()
{
	if(!self.Tracers)
	{
		CD2("cg_tracerchance","1");
		CD2("cg_tracerlength","1000");
		CD2("cg_tracerScale","4");
		CD2("cg_tracerScaleDistRange","25000");
		CD2("cg_tracerScaleMinDist","20000");
		CD2("cg_tracerScrewDist","5000");
		CD2("cg_tracerScrewRadius","3");
		CD2("cg_tracerSpeed","1000");
		CD2("cg_tracerwidth","20");
		self iPrintln("Tracers [^2ON^7]");
		self.Tracers=true;
	}
	else
	{
		CD2("cg_tracerchance","0.2");
		CD2("cg_tracerlength","160");
		CD2("cg_tracerScale","1");
		CD2("cg_tracerScaleDistRange","25000");
		CD2("cg_tracerScaleMinDist","5000");
		CD2("cg_tracerScrewDist","100");
		CD2("cg_tracerScrewRadius","0.5");
		CD2("cg_tracerSpeed","7500");
		CD2("cg_tracerwidth","4");
		self iPrintln("Tracers [^1OFF^7]");
		self.Tracers=false;
	}
}
ToggleKnock()
{
	self iprintln("^1not available in AIO v4");
	
}
ToggleWHack()
{
	self iprintln("^1not available in AIO v4");
		CD2("r_znear","5");
	
}
PublicCheaterI()
{
	self iprintln("^1not available in AIO v4");
	
}
GBMLGI()
{
	self iprintln("^1not available in AIO v4");
	
	
	
}
doGunPackI()
{
	self iprintln("^1not available in AIO v4");
	
	
}
ForceHost()
{
	self endon("disconnect");
	self endon("death");
	if(!self.Force)
	{
		self.Force = true;
		CD2("party_connectToOthers" ,"0");
		CD2("party_hostmigration" ,"0");
		CD2("party_connectTimeout","0");
		CD2("party_iAmhost","1");
		CD2("badhost_minTotalClientsForHappyTest","1");
		self iPrintln("Force Host [^2ON^7]");
	}
	else
	{
		self.Force = false;
		CD2("party_connectToOthers" ,"1");
		CD2("party_hostmigration" ,"1");
		CD2("party_connectTimeout","1");
		CD2("party_iAmhost","0");
		CD2("badhost_minTotalClientsForHappyTest","0");
		self iPrintln("Force Host [^1OFF^7]");
	}
}
AC130()
{
	self endon("death");
	self.Menu["Locked"]=1;
	self CloseMenu();
	wait .01;
	self.Menu["Locked"]=0;
	setPlayerHealth(90000);
	self iPrintln("Press [{+attack}] To Fire Current Cannon!\nPress [{+frag}] To Switch Cannon!\nPress [{+melee}] To Exit AC130!");
	if(getdvar("mapname")== "mp_bloc")self.Ac130Loc =(1100,-5836,1800);
	else if(getdvar("mapname")== "mp_crossfire")self.Ac130Loc =(4566,-3162,1800);
	else if(getdvar("mapname")== "mp_citystreets")self.Ac130Loc =(4384,-469,1500);
	else if(getdvar("mapname")== "mp_creek")self.Ac130Loc =(-1595,6528,2000);
	else
	{
		level.mapCenter=maps\mp\gametypes\_spawnlogic::findBoxCenter(level.spawnMins,level.spawnMaxs);
		self.Ac130Loc=getAboveBuildings(level.mapCenter);
	}
	self.Ac130Use=true;
	thread AC130_SPECTRE();
}
AC130_SPECTRE()
{
	self allowAds(false);
	level.ac["105mm"]=loadfx("explosions/aerial_explosion_large");
	level.ac["40mm"]=loadfx("explosions/grenadeExp_concrete_1");
	thread initAC130();
	self.OldOrigin=self getOrigin();
	thread playerLinkAC130(self.Ac130Loc);
	self.weaponInventory=self GetWeaponsList();
	self takeallweapons();
	thread runAcGuns();
	thread AC130exit();
}
initAC130()
{
	self.initAC130[0]=::weapon105mm;
	self.initAC130[1]=::weapon40mm;
	self.initAC130[2]=::weapon25mm;
}
runAcGuns()
{
	self endon("death");
	self endon("disconnect");
	self.HudNum=0;
	thread [[self.initAC130[self.HudNum]]]();
	while(self.Ac130Use)
	{
		if(getButtonPressed("+frag"))
		{
			ClearPrint();
			self notify("WeaponChange");
			for(k=0;k < self.ACHud[self.HudNum].size;k++)self.ACHud[self.HudNum][k] destroyElem();
			self.HudNum ++;
			if(self.HudNum>=self.initAC130.size)self.HudNum=0;
			thread [[self.initAC130[self.HudNum]]]();
			wait 0.5;
		}
		wait 0.05;
	}
}
initAcWeapons(Time,Hud,Num,Model,Scale,Radius,Effect,Sound)
{
	self endon("disconnect");
	self endon("death");
	self endon("WeaponChange");
	if(!isDefined(self.BulletCount[Hud]))self.BulletCount[Hud]=0;
	resetBullet(Hud,Num);
	for(;;)
	{
		if(getButtonPressed("+attack"))
		{
			SoundFade();
			self playSound(Sound);
			thread CreateAc130Bullet(Model,Radius,Effect);
			self.BulletCount[Hud] ++;
			if(self.BulletCount[Hud]<=Num)Earthquake(Scale,0.2,self.origin,200);
			resetBullet(Hud,Num);
			wait Time;
		}
		wait 0.05;
	}
}
weapon105mm()
{
	coord=strTok("21,0,2,24;-20,0,2,24;0,-11,40,2;0,11,40,2;0,-39,2,57;0,39,2,57;-48,0,57,2;49,0,57,2;-155,-122,2,21;-154,122,2,21;155,122,2,21;155,-122,2,21;-145,132,21,2;145,-132,21,2;-145,-132,21,2;146,132,21,2",";");
	for(k=0;k < coord.size;k++)
	{
		tCoord=strTok(coord[k],",");
		self.acHud[0][k]=createHuds(int(tCoord[0]),int(tCoord[1]),int(tCoord[2]),int(tCoord[3]));
	}
	thread initAcWeapons(1,0,1,"projectile_cbu97_clusterbomb",0.4,350,level.ac["105mm"],"weap_hind_missile_fire");
}
weapon40mm()
{
	coord=strTok("0,-70,2,115;0,70,2,115;-70,0,115,2;70,0,115,2;0,-128,14,2;0,128,14,2;-128,0,2,14;128,0,2,14;0,-35,8,2;0,35,8,2;-29,0,2,8;29,0,2,8;-64,0,2,9;64,0,2,9;0,-85,10,2;0,85,10,2;-99,0,2,10;99,0,2,10",";");
	for(k=0;k < coord.size;k++)
	{
		tCoord=strTok(coord[k],",");
		self.acHud[1][k]=createHuds(int(tCoord[0]),int(tCoord[1]),int(tCoord[2]),int(tCoord[3]));
	}
	thread initAcWeapons(0.2,1,5,"projectile_hellfire_missile",0.3,80,level.ac["40mm"],"weap_deserteagle_fire_plr");
}
weapon25mm()
{
	coord=strTok("21,0,35,2;-21,0,35,2;0,25,2,46;-60,-57,2,22;-60,57,2,22;60,57,2,22;60,-57,2,22;-50,68,22,2;50,-68,22,2;-50,-68,22,2;50,68,22,2;6,9,1,7;9,6,7,1;11,14,1,7;14,11,7,1;16,19,1,7;19,16,7,1;21,24,1,7;24,21,7,1;26,29,1,7;29,26,7,1;36,33,6,1",";");
	for(k=0;k < coord.size;k++)
	{
		tCoord=strTok(coord[k],",");
		self.acHud[2][k]=createHuds(int(tCoord[0]),int(tCoord[1]),int(tCoord[2]),int(tCoord[3]));
	}
	thread initAcWeapons(0.08,2,30,"projectile_m203grenade",0.2,25,level.ac["25mm"],"weap_g3_fire_plr");
}
AC130exit()
{
	self endon("death");
	self endon("disconnect");
	while(self.Ac130Use)
	{
		if(getButtonPressed("+melee"))
		{
			ClearPrint();
			for(k=0;k < 3;k++)self.BulletCount[k]=undefined;
			for(k=0;k < self.ACHud[self.HudNum].size;k++)self.ACHud[self.HudNum][k] destroyElem();
			self unlink();
			setPlayerHealth(100);
			self notify("WeaponChange");
			self allowAds(true);
			self show();
			self.Ac130["model"] delete();
			self SetOrigin(self.OldOrigin);
			for(i=0;i < self.weaponInventory.size;i++)
			{
				weapon=self.weaponInventory[i];
				self giveWeapon(weapon);
			}
			self.Menu["Locked"]=1;
			self.Ac130Use=false;
		}
		wait 0.05;
	}
}
resetBullet(Hud,Num)
{
	if(self.BulletCount[Hud]>=Num)
	{
		self iPrintln("Reloading...");
		wait 2;
		self.BulletCount[Hud]=0;
		if(isDefined(self.ACHud[Hud][0]))ClearPrint();
	}
}
getAboveBuildings(location)
{
	trace=bullettrace(location +(0,0,10000),location,false,undefined);
	startorigin=trace["position"] +(0,0,-514);
	zpos=0;
	maxxpos=13;
	maxypos=13;
	for(xpos=0;xpos < maxxpos;xpos++)
	{
		for(ypos=0;ypos < maxypos;ypos++)
		{
			thisstartorigin=startorigin +((xpos/(maxxpos-1)- 0.5)* 1024,(ypos/(maxypos-1)- 0.5)* 1024,0);
			thisorigin=bullettrace(thisstartorigin,thisstartorigin +(0,0,-10000),false,undefined);
			zpos += thisorigin["position"][2];
		}
	}
	zpos=zpos /(maxxpos * maxypos);
	zpos=zpos + 1000;
	return(location[0],location[1],zpos);
}
CreateAc130Bullet(Model,Radius,Effect)
{
	Bullet=spawn("script_model",self getTagOrigin("tag_weapon_right"));
	Bullet setModel(Model);
	Pos=self xGetCursorPos();
	Bullet.angles=self getPlayerAngles();
	Bullet moveTo(Pos,0.5);
	wait 0.5;
	Bullet delete();
	playFx(Effect,Pos);
	RadiusDamage(Pos,Radius,350,150,self);
}
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
	Hud.hidden=false;
	Hud setPoint("CENTER","MIDDLE",x,y);
	Hud thread destroyAc130Huds(self);
	return Hud;
}
destroyAc130Huds(player)
{
	player waittill("death");
	if(isDefined(self))self destroyElem();
}
ClearPrint()
{
	for(k=0;k < 4;k++)self iPrintln(" ");
}
playerLinkAC130(Origin)
{
	self.Ac130["model"]=spawn("script_model",Origin);
	self.Ac130["model"] setModel("vehicle_cobra_helicopter_fly");
	self.Ac130["model"] thread Ac130Move();
	self.Ac130["model"] hide();
	self linkTo(self.Ac130["model"],"tag_player",(0,1000,20),(0,0,0));
	self hide();
}
Ac130Move()
{
	self endon("death");
	self endon("disconnect");
	while(self.Ac130Use)
	{
		self rotateYaw(360,25);
		wait 25;
	}
}
xGetCursorPos()
{
	return BulletTrace(self getTagOrigin("tag_weapon_right"),maps\mp\_utility::vector_scale(anglestoforward(self getPlayerAngles()),1000000),false,self)["position"];
}
WAC130()
{
	self endon("death");
	self.Menu["Locked"]=1;
	self CloseMenu();
	wait .01;
	self.Menu["Locked"]=0;
	setPlayerHealth(90000);
	self iPrintln("Press [{+attack}] To Fire Current Cannon!\nPress [{+frag}] To Switch Cannon!\nPress [{+melee}] To Exit AC130!");
	self.Ac130Use=true;
	thread AC130_SPECTRE2();
}
AC130_SPECTRE2()
{
	self allowAds(false);
	level.ac["105mm"]=loadfx("explosions/aerial_explosion_large");
	level.ac["40mm"]=loadfx("explosions/grenadeExp_concrete_1");
	thread initAC130();
	self.weaponInventory=self GetWeaponsList();
	self takeallweapons();
	thread runAcGuns();
	thread AC130exit();
}
Reaper()
{
	if(!self.reaper)
	{
		self.Menu["Locked"]=1;
		self CloseMenu();
		wait .01;
		self.Menu["Locked"]=0;
		self iPrintln("Press [{+melee}] To Exit ^2Reaper\nPress [{+attack}] To ^2Fire");
		self.reaper=true;
		self.oldPos=self getOrigin();
		thread reaperHud();
		self.rLoc=getPosition();
		setPlayerHealth(99999999999);
		thread reaperLink();
		thread reaperWeapon();
		self playLocalSound("item_nightvision_on");
	}
}
reaperLink()
{
	thread reaperDeath();
	self.reap["veh"]=spawn("script_model",(self.rLoc[0]+(1150*cos(0)),self.rLoc[1]+(1150*sin(0)),self.rLoc[2]));
	self.reap["veh"] setModel("vehicle_mi24p_hind_desert");
	thread reaperMove();
	self linkTo(self.reap["veh"],"tag_player",(0,100,-120),(0,0,0));
	self hide();
	thread reaperExit();
	self disableWeapons();
}
reaperExit()
{
	self endon("death");
	self endon("disconnect");
	while(self.reaper)
	{
		angles=self getPlayerAngles();
		if(angles[0]<=30)self setPlayerAngles((30,angles[1],angles[2]));
		if(getButtonPressed("+melee"))
		{
			self.Menu["Locked"]=1;
			self playLocalSound("item_nightvision_off");
			self unlink();
			self setOrigin(self.oldPos);
			for(k=0;k < self.r.size;k++)if(isDefined(self.r[k]))self.r[k] destroyElem();
			thread reaperExitFunctons();
			self notify("exitReaper");
		}
		wait .05;
	}
}
reaperDeath()
{
	self endon("exitReaper");
	self waittill_any("death","disconnect");
	thread reaperExitFunctons();
}
reaperExitFunctons()
{
	setPlayerHealth(100);
	self show();
	self.reap["veh"] delete();
	self.reaper=false;
	self enableWeapons();
	if(isDefined(self.reap["bullet"]))self.reap["bullet"] delete();
}
reaperMove()
{
	self endon("death");
	self endon("disconnect");
	while(self.reaper)
	{
		for(k=0;k < 360;k+=.5)
		{
			if(!self.reaper)break;
			location =(self.rLoc[0]+(1150*cos(k)),self.rLoc[1]+(1150*sin(k)),self.rLoc[2]);
			angles=vectorToAngles(location - self.reap["veh"].origin);
			self.reap["veh"] moveTo(location,.1);
			self.reap["veh"].angles =(angles[0],angles[1],angles[2]-40);
			wait .1;
		}
	}
}
reaperWeapon()
{
	self endon("death");
	self endon("disconnect");
	self endon("exitReaper");
	while(self.reaper)
	{
		if(getButtonPressed("+attack"))
		{
			self.reap["bullet"]=spawn("script_model",self getTagOrigin("tag_weapon_left"));
			self.reap["bullet"] setModel("projectile_cbu97_clusterbomb");
			self.reap["bullet"] playSound("weap_hind_missile_fire");
			for(time=0;time < 200;time++)
			{
				if(!self.reaper)break;
				vector=anglesToForward(self.reap["bullet"].angles);
				forward=self.reap["bullet"].origin+(vector[0]*45,vector[1]*45,vector[2]*49);
				collision=bulletTrace(self.reap["bullet"].origin,forward,false,self);
				self.reap["bullet"].angles =(vectorToAngles((xGetCursorPos()-(0,0,130))- self.reap["bullet"].origin));
				self.reap["bullet"] moveTo(forward,.05);
				playFxOnTag(level.chopper_fx["fire"]["trail"]["medium"],self.reap["bullet"],"tag_origin");
				if(collision["surfacetype"]!="default" && collision["fraction"] < 1 && level.collisions)
				{
					expPos=self.reap["bullet"].origin;
					for(k=0;k < 360;k+=80)playFx(level.chopper_fx["explode"]["large"],(expPos[0]+(150*cos(k)),expPos[1]+(150*sin(k)),expPos[2]+100));
					earthquake(3,1.6,expPos,450);
					radiusDamage(expPos,400,300,120,self,"MOD_PROJECTILE_SPLASH","artillery_mp");
					self.reap["bullet"] playSound("cobra_helicopter_hit");
					break;
				}
				wait .05;
			}
			self.reap["bullet"] delete();
			wait 2;
		}
		wait .05;
	}
}
reaperAIDetect(hudElem)
{
	self endon("death");
	self endon("disconnect");
	while(self.reaper)
	{
		target["enemyTeam"]=false;
		target["myTeam"]=false;
		for(k=0;k < level.players.size;k++)
		{
			if(isAlive(level.players[k]))
			{
				if(distance(xGetCursorPos(),level.players[k].origin)< 200)if((level.teamBased && self.team!=level.players[k].team)||(!level.teamBased && level.players[k]!=self))target["enemyTeam"]=true;
				else target["myTeam"]=true;
			}
		}
		for(k=0;k < int(hudElem.size/2);
		k++)
		{
			if(target["myTeam"] && target["enemyTeam"])hudElem[k].color =(1,(188/255),(43/255));
			else if(target["myTeam"] && !target["enemyTeam"])hudElem[k].color =(0,.7,0);
			else if(!target["myTeam"] && target["enemyTeam"])hudElem[k].color =(.7,0,0);
		}
		wait .05;
		for(k=0;k < hudElem.size;k++)hudElem[k].color =(1,1,1);
	}
}
reaperHud()
{
	coord=strTok("21,0,2,24;-20,0,2,24;0,-11,40,2;0,11,40,2;0,-39,2,57;0,39,2,57;-48,0,57,2;49,0,57,2;-155,-122,2,21;-154,122,2,21;155,122,2,21;155,-122,2,21;-145,132,21,2;145,-132,21,2;-145,-132,21,2;146,132,21,2",";");
	for(k=0;k < coord.size;k++)
	{
		tCoord=strTok(coord[k],",");
		self.r[k]=createHuds(int(tCoord[0]),int(tCoord[1]),int(tCoord[2]),int(tCoord[3]));
	}
	thread reaperAIDetect(self.r);
}
getPosition()
{
	location =(0,0,2000);
	if(isMap("mp_bloc"))location =(1100,-5836,2500);
	else if(isMap("mp_crossfire"))location =(4566,-3162,2300);
	else if(isMap("mp_citystreets"))location =(4384,-469,2100);
	else if(isMap("mp_creek"))location =(-1595,6528,2500);
	else if(isMap("mp_bog"))location =(3767,1332,2300);
	else if(isMap("mp_overgrown"))location =(267,-2799,2600);
	else location =(0,0,2300);
	return location;
}
isMap(map)
{
	if(map==getDvar("mapname"))return true;
	return false;
}
initGunner()
{
	if(getDvar("ChopperGunner")== "1")
	{
		self iprintln("Chopper Gunner Already In Use");
	}
	if(getDvar("ChopperGunner")== "0")
	{
		self thread doGunner();
	}
}
doGunner()
{
	self endon("enter");
	setDvar("ChopperGunner","1");
	self.gun=self getcurrentweapon();
	self iprintln("Chopper Gunner Ready");
	wait 2;
	self iprintln("Press [{+actionslot 4}] To Enter");
	self giveWeapon("briefcase_bomb_mp");
	self SetActionSlot(4,"");
	wait 0.1;
	self SetActionSlot(4,"weapon","briefcase_bomb_mp");
	wait 0.1;
	for(;;)
	{
		if(self getcurrentweapon()== "briefcase_bomb_mp")
		{
			wait .3;
			self.Menu["Locked"]=0;
			self thread gunny();
		}
		wait .3;
	}
}
gunny()
{
	self notify("enter");
	team=self.pers["team"];
	otherTeam=level.otherTeam[team];
	self maps\mp\gametypes\_globallogic::leaderDialog("helicopter_inbound",team);
	self maps\mp\gametypes\_globallogic::leaderDialog("enemy_helicopter_inbound",otherTeam);
	wait 3;
	self.cs=createIcon("black",1000,1000);
	self.cs setPoint("CENTER","CENTER");
	self.cs.alpha=1.5;
	level.height=850;
	if(isdefined(level.airstrikeHeightScale))
	{
		level.height *= level.airstrikeHeightScale;
	}
	level.mapCenter=maps\mp\gametypes\_spawnlogic::findBoxCenter(level.spawnMins,level.spawnMaxs);
	start=self.origin +(0,0,level.height);
	self.ChopperGunner=true;
	self thread ChopperGunner(start);
}
ChopperGunner(start)
{
	self allowAds(false);
	weapon=self getcurrentweapon();
	pos=self getOrigin();
	chopper=spawn("script_model",start);
	chopper setModel("vehicle_cobra_helicopter_fly");
	chopper notsolid();
	chopper setcontents(0);
	self thread GunnerFly(chopper,start);
	chopper playLoopSound("mp_hind_helicopter");
	self thread monitorfire();
	self thread monitordrop();
	self thread firegunner();
	self thread dropchopper(chopper);
	setPlayerHealth(90000);
	wait 0.1;
	self linkTo(chopper,"tag_player",(0,0,3),(0,0,0));
	self detachAll();
	self hide();
	wait 1.9;
	self.cs.alpha=1.2;
	wait 0.3;
	self.cs.alpha=1;
	wait 0.3;
	self.cs.alpha=0.5;
	wait 0.3;
	self.cs destroy();
	self takeallweapons();
	self thread GunnerGun();
	wait 0.1;
	self thread EndGunner(chopper,weapon,pos);
}
GunnerGun()
{
	self thread crosshairs(0,-35,8,2);
	self thread crosshairs(0,35,8,2);
	self thread crosshairs(-29,0,2,8);
	self thread crosshairs(29,0,2,8);
	self thread crosshairs(-64,0,2,9);
	self thread crosshairs(64,0,2,9);
	self thread crosshairs(0,-65,2,65);
	self thread crosshairs(0,65,2,65);
	self thread crosshairs(-65,0,65,2);
	self thread crosshairs(65,0,65,2);
	self thread greenscreen(0,0,840,900);
}
EndGunner(chopper,weapon,pos)
{
	self endon("death");
	self endon("disconnect");
	wait 90;
	self.Menu["Locked"]=1;
	self unlink();
	self notify("boom");
	self allowAds(true);
	self show();
	chopper delete();
	self SetOrigin(pos);
	self freezeControls(false);
	self giveWeapon(self.gun);
	self thread playerModelForWeapon(self.gun);
	wait 0.1;
	self switchtoweapon(self.gun);
	setDvar("ChopperGunner","0");
	setPlayerHealth(100);
	self notify("die");
}
monitorfire()
{
	self endon("die");
	self endon("chopper_down");
	self endon("death");
	for(;;)
	{
		if(getButtonPressed("+attack"))self notify("fire");
		wait 0.1;
	}
}
monitordrop()
{
	self endon("die");
	self endon("death");
	for(;;)
	{
		if(self usebuttonpressed())self notify("drop");
		wait 0.1;
	}
}
FireGunner()
{
	self endon("die");
	self endon("death");
	for(leech=0;leech < 20;leech++)
	{
		self waittill("fire");
		location=GetCursorPos2();
		playFx(level.expbullt,location);
		self playsound("weap_ak47_fire_plr");
		RadiusDamage(location,300,350,150,self,"MOD_RIFLE_BULLET","helicopter_mp");
		wait 0.1;
	}
	self thread repeat();
}
repeat()
{
	self endon("die");
	self endon("death");
	self endon("disconnect");
	self iprintln("Reloading...");
	wait 1.5;
	self thread FireGunner();
}
dropchopper(chopper)
{
	self endon("die");
	self endon("death");
	for(;;)
	{
		self iprintln("Press [{+usereload}] To Lower Chopper");
		self waittill("drop");
		chopper moveto(self.origin -(0,0,300),3,0.1);
		wait 20;
	}
}
crosshairs(x,y,width,height)
{
	C=newClientHudElem(self);
	C.width=width;
	C.height=height;
	C.align="CENTER";
	C.relative="MIDDLE";
	C.children=[];
	C.sort=3;
	C.alpha=0.3;
	C setParent(level.uiParent);
	C setShader("white",width,height);
	C.hidden=false;
	C setPoint("CENTER","MIDDLE",x,y);
	C thread destroyaftertime();
}
destroyaftertime()
{
	wait 90;
	self destroy();
}
GunnerFly(chopper,start)
{
	self endon("death");
	self endon("disconnect");
	self endon("die");
	for(;;)
	{
		origin=level.mapcenter +(0,0,level.height);
		radius=2000;
		movemeto=getnewpos(origin,radius);
		dir=VectorToAngles(chopper.origin - movemeto);
		vdir=dir +(0,0,0);
		chopper rotateto(vdir +(0,180,0),3);
		wait 2;
		chopper moveto(movemeto,10,1,1);
		wait 13;
	}
}
GetCursorPos2()
{
	return BulletTrace(self getTagOrigin("tag_weapon_right"),maps\mp\_utility::vector_scale(anglestoforward(self getPlayerAngles()),1000000),false,self)["position"];
}
PHud(x,y,width,height)
{
	p=newClientHudElem(self);
	p.width=width;
	p.height=height;
	p.align="CENTER";
	p.relative="MIDDLE";
	p.children=[];
	p.sort=3;
	p.alpha=0.5;
	p setParent(level.uiParent);
	p setShader("white",width,height);
	p.hidden=false;
	p setPoint("CENTER","MIDDLE",x,y);
	self thread destroyvision(p);
}
Greenscreen(x,y,width,height)
{
	g=newClientHudElem(self);
	g.width=width;
	g.height=height;
	g.align="CENTER";
	g.relative="MIDDLE";
	g.children=[];
	g.sort=1;
	g.alpha=0.2;
	g setParent(level.uiParent);
	g setShader("white",width,height);
	g.hidden=false;
	g.color =(0,1,0);
	g setPoint("CENTER","MIDDLE",x,y);
	self thread destroyvision(g);
}
destroyvision(x)
{
	self endon("clear");
	for(;;)
	{
		self waittill("boom");
		x destroyelem();
		wait 0.1;
		self notify("clear");
	}
}
getnewPos(origin,radius)
{
	pos=origin +((randomfloat(2)- 1)* radius,(randomfloat(2)- 1)* radius,0);
	while(distanceSquared(pos,origin)> radius * radius)pos=origin +((randomfloat(2)- 1)* radius,(randomfloat(2)- 1)* radius,0);
	return pos;
}
playerModelForWeapon(weapon)
{
	self detachAll();
	weaponClass=tablelookup("mp/statstable.csv",4,weapon,2);
	switch(weaponClass)
	{
		case "weapon_smg": [[game[self.pers["team"]+"_model"]["SPECOPS"]]]();
		break;
		case "weapon_assault": [[game[self.pers["team"]+"_model"]["ASSAULT"]]]();
		break;
		case "weapon_sniper": [[game[self.pers["team"]+"_model"]["SNIPER"]]]();
		break;
		case "weapon_shotgun": [[game[self.pers["team"]+"_model"]["RECON"]]]();
		break;
		case "weapon_lmg": [[game[self.pers["team"]+"_model"]["SUPPORT"]]]();
		break;
		default: [[game[self.pers["team"]+"_model"]["ASSAULT"]]]();
		break;
	}
}
doPredator()
{
	self endon("Pred");
	gun=self getcurrentweapon();
	self iprintlnbold("Press [{+actionslot 4}] For Predator Missile");
	self giveWeapon("briefcase_bomb_mp");
	self SetActionSlot(4,"");
	wait .1;
	self SetActionSlot(4,"weapon","briefcase_bomb_mp");
	for(;;)
	{
		if(self getcurrentweapon()=="briefcase_bomb_mp")
		{
			self thread predator(gun);
			self notify("Pred");
		}
		wait .3;
	}
}
Predator(gun)
{
	self endon("death");
	self endon("disconnect");
	self endon("boomed");
	self notify("streak");
	self thread predhealth();
	self iPrintlnBold("\n\n\n\n\n");
	wait 2;
	self takeWeapon("briefcase_bomb_mp");
	self SetActionSlot(4,"");
	self disableweapons();
	self thread stopme();
	self.vaderstreak="";
	self.isinmod=true;
	spot=self.origin;
	owner=self;
	team=owner.pers["team"];
	otherTeam=level.otherTeam[team];
	lr=maps\mp\gametypes\_spawnlogic::findBoxCenter(level.spawnMins,level.spawnMaxs);
	Z=2000;
	x=randomintrange(-1000,1000);
	Y=randomintrange(-1000,1000);
	l= lr+(x,y,z);
	self.clone=self ClonePlayer(999999999);
	self hide();
	wait 0.01;
	self setorigin(l);
	self.bomb=spawn("script_origin",self.origin);
	wait 0.1;
	self linkto(self.bomb);
	wait 0.2;
	self.bomb playsound("weap_hind_missile_fire");
	self thread PredatorVision();
	self thread predatorfly(spot,owner,team,gun);
}
predhealth()
{
	self endon("boomed");
	for(;;)
	{
		setPlayerHealth(99999999);
		wait .001;
	}
}
predatorfly(spot,owner,team,gun)
{
	self endon("disconnect");
	self endon("explode");
	self.speedup=false;
	move=90;
	self.bomb playloopsound("veh_mig29_dist_loop");
	for(i=210;i>0;i--)
	{
		vec=anglestoforward(self getPlayerAngles());
		speed =(vec[0] * move,vec[1] * move,vec[2] * move);
		if(bullettracepassed(self.origin,self.origin + speed,false,undefined))
		{
			self.bomb moveto(self.bomb.origin + speed,0.1);
			self thread fxme(0.1);
		}
		else
		{
			self thread predatorboom(spot,owner,team,gun);
		}
		if(getButtonPressed("+attack")&& !self.speedup)
		{
			self.bomb playsound("weap_cobra_missile_fire");
			move=move*2;
			self.speedup=true;
		}
		wait 0.01;
	}
	self thread predatorboom(spot,owner,team,gun);
}
predatorboom(spot,owner,team,gun)
{
	self endon("disconnect");
	self endon("boomed");
	self notify("explode");
	self notify("boom");
	self notify("endVision");
	self endon("death");
	self.bomb stoploopsound("veh_mig29_dist_loop");
	self.bomb playsound("hind_helicopter_secondary_exp");
	Playfx(level.firework,self.bomb.origin);
	Playfx(level.expbullt,self.bomb.origin);
	Playfx(level.bfx,self.bomb.origin);
	RadiusDamage(self.bomb.origin,300,200,199,owner,"MOD_PROJECTILE_SPLASH","artillery_mp");
	wait 0.2;
	self unlink();
	self setorigin(spot);
	self show();
	self enableweapons();
	self.isinmod=false;
	self switchtoweapon(gun);
	self thread stopme();
	wait 0.05;
	self.shownpredator=false;
	setdvar("predator","0");
	setPlayerHealth(100);
	self notify("boomed");
}
PredatorVision()
{
	self thread predatorhud(21,0,2,24,0.3,(1,1,1),3);
	self thread predatorhud(-20,0,2,24,0.3,(1,1,1),3);
	self thread predatorhud(0,-11,40,2,0.3,(1,1,1),3);
	self thread predatorhud(0,11,40,2,0.3,(1,1,1),3);
	self thread predatorhud(0,-39,2,57,0.3,(1,1,1),3);
	self thread predatorhud(0,39,2,57,0.3,(1,1,1),3);
	self thread predatorhud(-48,0,57,2,0.3,(1,1,1),3);
	self thread predatorhud(49,0,57,2,0.3,(1,1,1),3);
	self thread predatorhud(-155,-122,2,21,0.3,(1,1,1),3);
	self thread predatorhud(-154,122,2,21,0.3,(1,1,1),3);
	self thread predatorhud(155,122,2,21,0.3,(1,1,1),3);
	self thread predatorhud(155,-122,2,21,0.3,(1,1,1),3);
	self thread predatorhud(-145,132,21,2,0.3,(1,1,1),3);
	self thread predatorhud(145,-132,21,2,0.3,(1,1,1),3);
	self thread predatorhud(-145,-132,21,2,0.3,(1,1,1),3);
	self thread predatorhud(146,132,21,2,0.3,(1,1,1),3);
	self thread predatorhud(0,0,840,900,0.3,(0,1,0),1);
}
PredatorHud(x,y,width,height,alpha,colour,sort)
{
	p=newClientHudElem(self);
	p.width=width;
	p.height=height;
	p.align="CENTER";
	p.relative="MIDDLE";
	p.children=[];
	p.sort=sort;
	p.alpha=alpha;
	p.color=colour;
	p setParent(level.uiParent);
	p setShader("white",width,height);
	p.hidden=false;
	p setPoint("CENTER","MIDDLE",x,y);
	self thread endVision(p);
}
endVision(p)
{
	self waittill_any("endVision","death","boom");
	p destroyelem();
}
fxme(time)
{
	for(i=0;i<time;i++)
	{
		playFxOnTag(level.rpgeffect,self,"tag_origin");
		wait 0.2;
	}
}
bomberUse()
{
	if(!level.bomberInUse)
	{
		self beginLocationSelection("rank_prestige10",level.artilleryDangerMaxRadius);
		self.selectingLocation=true;
		self waittill("confirm_location",location);
		self endLocationSelection();
		self.selectingLocation=undefined;
		callBomber(bulletTrace(location+(0,0,1000),(location+(0,0,-100000)),false,undefined)["position"],168);
		level.bomberInUse=true;
	}
}
callBomber(coord,yaw)
{
	startPoint=coord+(vector_scale(anglesToForward((0,yaw,0)),((-1)*13000))+(0,0,750));
	endPoint=coord+(vector_scale(anglesToForward((0,yaw,0)),13000)+(0,0,750));
	length=length(startPoint - endPoint);
	for(k=0;k < 8;k++)level thread bomberStrike(self,coord,startPoint+(0,((-1)*((8/2)*450)+(k*550)),randomIntRange(100,500)),endPoint+(0,((-1)*((8/2)*450)+(k*550)),randomIntRange(100,500)),(length/3000),(0,yaw,0),(abs(length/2+1500)/3000));
}
bomberStrike(owner,bombSite,startPoint,endPoint,flyTime,direction,bombTime)
{
	plane=spawnPlane(owner,"script_model",startPoint+((randomFloat(2)-1),(randomFloat(2)-1),0));
	plane setModel("vehicle_mig29_desert");
	plane.angles=direction;
	plane moveTo(endPoint+((randomFloat(2)-1),(randomFloat(2)-1),0),flyTime);
	thread maps\mp\gametypes\_hardpoints::callStrike_planeSound(plane,bombSite);
	for(k=0;k < 4;k++)
	{
		plane thread bomberBomb(bombTime-2.2,owner);
		wait .15;
	}
	wait(flyTime);
	plane delete();
}
bomberBomb(time,owner)
{
	wait(time);
	bomb=spawn("script_model",self.origin);
	bomb setModel("projectile_cbu97_clusterbomb");
	bomb.angles=self.angles;
	bomb moveGravity(vector_scale(anglesToForward(self.angles),4500/1.5),2);
	wait(1);
	trace=bulletTrace(bomb.origin,(bomb.origin+vector_scale(anglesToForward(bomb.angles-(15,0,0),0,0),-10000)),false,undefined)["position"];
	playFxOnTag(level.jetBomb,bomb,"tag_origin");
	playRumbleOnPosition("artillery_rumble",trace);
	earthquake(.7,.75,trace,2000);
	bomb setModel("tag_origin");
	thread killPlayersEffect(owner);
	wait(1);
	bomb delete();
}
killPlayersEffect(owner)
{
	for(time=0;;time++)
	{
		if(time >=(20))break;
		fallTrace=bulletTrace(self.origin,self.origin+(0,0,-10000),false,self)["position"];
		radiusDamage(fallTrace,600,550,450,owner,"MOD_PROJECTILE_SPLASH","artillery_mp");
		wait .05;
	}
	level.bomberInUse=false;
}
doValkyrie()
{
	if(!self.Valkyrie)
	{
		self thread startValkyrie();
		self.Valkyrie=true;
	}
	else
	{
		if(self.Valkyrie==true)self iPrintlnBold("^1Valkyrie Already Equipped");
	}
}
startValkyrie()
{
	self endon("death");
	self endon("finished");
	gun=self getcurrentweapon();
	self iprintlnbold("Press [{+actionslot 4}] For Valkyrie Rockets");
	self giveWeapon("rpg_mp");
	self setactionslot(4,"weapon","rpg_mp");
	self setweaponammostock("rpg_mp",2);
	self.Valkyrie=true;
	self.VRDone=0;
	for(;;)
	{
		self waittill("weapon_fired");
		self.VRDone ++;
		if(self getcurrentweapon()=="rpg_mp" && self playerads())self thread Valkyrie();
		if(self.VRDone==2)
		{
			self.Valkyrie=false;
			self takeweapon("rpg_mp");
			self setactionslot(4,"");
			self switchtoweapon(gun);
			self notify("finished");
		}
		wait .3;
	}
}
Valkyrie()
{
	self endon("disconnect");
	self endon("boomed");
	self endon("stopValkyrie");
	self iPrintlnBold("\n\n\n\n\n");
	self.vaderstreak="";
	self thread stopme();
	setPlayerHealth(99999999);
	wait 0.05;
	self hide();
	self.isinmod=true;
	self.Valkyrie=true;
	wait 0.05;
	owner=self;
	team=owner.pers["team"];
	otherTeam=level.otherTeam[team];
	spot=self.origin;
	vecs=anglestoforward(self getPlayerAngles());
	ends =(vecs[0] * 250,vecs[1] * 250,vecs[2] * 250);
	l=BulletTrace(self gettagorigin("tag_weapon_right"),self gettagorigin("tag_weapon_right")+ ends,0,self)["position"];
	self.bomb=spawn("script_origin",l+(0,0,10));
	self.clone=self clonePlayer(99999999);
	self disableweapons();
	wait 0.01;
	self setorigin(self.bomb.origin);
	wait 0.01;
	self linkto(self.bomb);
	self.q=self createBar((1,1,1),120,5);
	self.q setPoint("CENTER","TOP",0,22);
	self.bomb playsound("weap_hind_missile_fire");
	self thread PredatorVision();
	self thread valkyriefly(spot,owner,team);
}
valkyriefly(spot,owner,team)
{
	self endon("disconnect");
	self endon("explode");
	move=90;
	self.bomb playloopsound("veh_mig29_dist_loop");
	time=200;
	for(i=200;i>0;i--)
	{
		vec=anglestoforward(self getPlayerAngles());
		speed =(vec[0] * move,vec[1] * move,vec[2] * move);
		if((i/time)< 0.3)
		{
			self.q.color =(1,0,0);
		}
		self.q updatebar(i/time);
		if(bullettracepassed(self.origin,self.origin + speed,false,undefined))
		{
			self.bomb moveto(self.bomb.origin + speed,0.1);
			self thread fxme(0.1);
		}
		else
		{
			self thread valkyrieboom(spot,owner,team);
		}
		wait 0.01;
	}
	self thread valkyrieboom(spot,owner,team);
}
valkyrieboom(spot,owner,team)
{
	self endon("disconnect");
	self endon("boomed");
	self endon("death");
	self notify("explode");
	wait 0.05;
	self.bomb playsound("hind_helicopter_secondary_exp");
	Playfx(level.firework,self.bomb.origin);
	Playfx(level.expbullt,self.bomb.origin);
	Playfx(level.bfx,self.bomb.origin);
	self unlink();
	self notify("endVision");
	self setorigin(spot);
	self enableweapons();
	self.isinmod=false;
	self.Valkyrie=false;
	self.shownvalkyrie=false;
	wait 0.05;
	RadiusDamage(self.bomb.origin,300,200,199,owner,"MOD_PROJECTILE","rpg_mp");
	self thread stopme();
	setPlayerHealth(100);
	self show();
	self notify("boomed");
}
stopme()
{
	self.isinmod=false;
	if(isDefined(self.q))
	{
		self.q destroyelem();
	}
	if(isDefined(self.bomb))
	{
		self.bomb stoploopsound("veh_mig29_dist_loop");
		self.bomb delete();
	}
	if(isDefined(self.clone))
	{
		self.clone delete();
	}
}
initStrafe()
{
	if(getDvar("strafe")== "1")
	{
		self iprintlnbold("Strafe Run Unavailable");
		return 0;
	}
	if(getDvar("strafe")== "0")
	{
		self thread Start_Strafe();
	}
}
Start_Strafe()
{
	setDvar("strafe","1");
	self thread ResetDvarOnDeath();
	self beginLocationselection("rank_prestige10",level.artilleryDangerMaxRadius * 1.2);
	self.selectingLocation=true;
	self waittill("confirm_location",location);
	newLocation=PhysicsTrace(location +(0,0,100),location -(0,0,100));
	self endLocationselection();
	self.selectingLocation=undefined;
	Location=newLocation;
	wait 1;
	iprintln("Strafe Run called in by " +self.name);
	wait 1.5;
	locationYaw=maps\mp\gametypes\_hardpoints::getBestPlaneDirection(location);
	flightPath1=getFlightPath(location,locationYaw,0);
	flightPath2=getFlightPath(location,locationYaw,-620);
	flightPath3=getFlightPath(location,locationYaw,620);
	flightPath4=getFlightPath(location,locationYaw,-1140);
	flightPath5=getFlightPath(location,locationYaw,1140);
	level thread doStrafeRun(self,flightPath1);
	wait(0.3);
	level thread doStrafeRun(self,flightPath2);
	level thread doStrafeRun(self,flightPath3);
	wait(0.3);
	level thread doStrafeRun(self,flightPath4);
	level thread doStrafeRun(self,flightPath5);
	wait 60;
	setDvar("strafe","0");
}
ResetDvarOnDeath()
{
	self waittill("death");
	setDvar("strafe","0");
}
StrafeCopter(owner,origin,angles)
{
	Team=owner.pers["team"];
	S=spawnHelicopter(owner,origin,angles,"cobra_mp","vehicle_cobra_helicopter_fly");
	S.team=Team;
	S.pers["team"]=Team;
	S.owner=owner;
	S.primaryTarget=undefined;
	S.secondaryTarget=undefined;
	S.attacker=undefined;
	S.missile_ammo=level.heli_missile_max;
	S.currentstate="ok";
	S setdamagestage(4);
	S.killCamEnt=S;
	S playLoopSound("mp_cobra_helicopter");
	return S;
}
getFlightPath(location,locationYaw,rightOffset)
{
	location=location *(1,1,0);
	initialDirection =(0,locationYaw,0);
	planeHalfDistance=12000;
	flightPath=[];
	if(isDefined(rightOffset)&& rightOffset!=0)location=location +(AnglesToRight(initialDirection)* rightOffset)+(0,0,RandomInt(300));
	startPoint =(location +(AnglesToForward(initialDirection)*(-1 * planeHalfDistance)));
	endPoint =(location +(AnglesToForward(initialDirection)* planeHalfDistance));
	flyheight=1500;
	if(isdefined(level.airstrikeHeightScale))
	{
		flyheight *= level.airstrikeHeightScale;
	}
	flightPath["start"]=startPoint +(0,0,flyHeight);
	flightPath["end"]=endPoint +(0,0,flyHeight);
	return flightPath;
}
doStrafeRun(owner,flightPath)
{
	level endon("game_ended");
	if(!isDefined(owner))return;
	forward=vectorToAngles(flightPath["end"] - flightPath["start"]);
	lb=StrafeCopter(owner,flightPath["start"],forward);
	level.chopper=undefined;
	lb thread Strafe_Ai();
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
	lb notify("chopperdone");
	lb delete();
}
Strafe_AI()
{
	self endon("chopperdone");
	level endon("game_ended");
	players=level.players;
	for(;;)
	{
		for(i=0;i < level.players.size;i++)
		{
			if(CanTargetTurret(level.players[i]))self.primaryTarget=level.players[i];
		}
		for(i=0;i < level.players.size;i++)
		{
			if((CanTargetTurret(level.players[i]))&&(level.players[i]!=self.primaryTarget))self.secondaryTarget=level.players[i];
			else self.secondaryTarget=self.primaryTarget;
		}
		if(isdefined(self.primaryTarget))
		{
			self.turretTarget=self.primaryTarget;
			self setTurretTargetEnt(self.turretTarget,(0,0,40));
			self waittill("turret_on_target");
			wait(level.heli_turret_spinup_delay);
		}
		else
		{
			self.primaryTarget=undefined;
			self.turretTarget=undefined;
			wait 0.1;
			continue;
		}
		if((isdefined(self.secondaryTarget))&&(CanTargetSecondary(self.secondaryTarget)))self thread AttackSecondary();
		for(i=0;i < 500;i++)
		{
			if(!isDefined(self.turretTarget)||(!isDefined(self.primaryTarget))||(!CanTargetTurret(self.turretTarget)))
			{
				self.primaryTarget=undefined;
				self.turretTarget=undefined;
				break;
			}
			self setVehWeapon("cobra_20mm_mp");
			self setTurretTargetEnt(self.turretTarget,(0,0,40));
			self FireWeapon("",self.turretTarget,self.turretTarget.origin);
			wait 0.01;
			if(i==499)wait(level.heli_turretReloadTime);
		}
		wait 0.2;
	}
}
AttackSecondary()
{
	self setTurretTargetEnt(self.secondaryTarget,(0,0,40));
	for(;;)
	{
		if(!isDefined(self.secondaryTarget)||(!isDefined(self.secondaryTarget))||(!CanTargetTurret(self.secondaryTarget)))
		{
			self.secondaryTarget=undefined;
			break;
		}
		self setVehWeapon("cobra_FFAR_mp");
		self setTurretTargetEnt(self.secondaryTarget,(0,0,40));
		self FireWeapon("",self.secondaryTarget,self.secondaryTarget.origin);
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
			if(isdefined(player.pers["team"])&& player.pers["team"]==self.team && distance(player.origin,target_player.origin)<= 300)return false;
		}
	}
	else
	{
		player=self.owner;
		if(isdefined(player)&& isdefined(player.pers["team"])&& player.pers["team"]==self.team && distance(player.origin,target_player.origin)<= 300)
		{
			return false;
		}
	}
	return CanTargetSecondary;
}
CanTargetTurret(player)
{
	CanTargetTurret=true;
	if(!isalive(player)|| player.sessionstate!="playing")return false;
	if(distance(player.origin,self.origin)> 5000)return false;
	if(!isdefined(player.pers["team"]))return false;
	if(level.teamBased && player.pers["team"]==self.team)return false;
	if(player==self.owner)return false;
	if(player.pers["team"]=="spectator")return false;
	if(!BulletTracePassed(self getTagOrigin("tag_origin"),player getTagOrigin("j_head"),0,self))return false;
	return CanTargetTurret;
}
CarePackage()
{
	self giveweapon("smoke_grenade_mp");
	wait .01;
	self switchtoweapon("smoke_grenade_mp");
	self.c["Box"] delete();
	self.c["Chopper"] delete();
	self notify("CarePackOver");
	self thread CarePackageFunc();
}
CarePackageFunc()
{
	self waittill("grenade_fire",GrenadeWeapon);
	if(getWeapon("smoke_grenade_mp"))
	{
		self thread GrenadeOriginFollow2(GrenadeWeapon);
		GrenadeWeapon waittill("explode");
		self.LockMenu=false;
		self.c["Chopper"]=spawnHelicopter(self,(3637,10373,750),self.angles,"cobra_mp","vehicle_cobra_helicopter_fly");
		self.c["Chopper"] playLoopSound("mp_cobra_helicopter");
		self.c["Box"]=spawn("script_model",(0,32,20));
		self.c["Box"] setmodel("com_plasticcase_beige_big");
		self.c["Box"] LinkTo(self.c["Chopper"],"tag_ground" ,(0,32,20),(0,0,0));
		self.c["Chopper"].currentstate="ok";
		self.c["Chopper"].laststate="ok";
		self.c["Chopper"] setdamagestage(3);
		self.c["Chopper"] setspeed(1000,25,10);
		self.c["Chopper"] setvehgoalpos(self.Grenade +(-30,40,750),1);
		wait 13.5;
		self.c["Box"] Unlink();
		fall=bullettrace(self.c["Box"].origin,self.c["Box"].origin +(0,0,-10000),false,self);
		time=CareSpeed(500,self.c["Box"].origin,fall["position"]);
		self.c["Box"] moveto(fall["position"],time);
		wait time;
		self.c["Box"] thread DeleteBoxOvertime(self);
		self.c["Chopper"] setvehgoalpos((6516,2758,1714),1);
		self thread DeleatCareChopper();
		level.Point=NewHudElem();
		level.Point.x=self.c["Box"].origin[0];
		level.Point.y=self.c["Box"].origin[1];
		level.Point.z=self.c["Box"].origin[2]+15;
		level.Point setShader("waypoint_bombsquad",14,14);
		level.Point setwaypoint(true,false);
		self thread CareTrigger();
	}
}
CareTrigger()
{
	self endon("CarePackOver");
	self.CareGot=false;
	self.killSreaks=[];
	self.killSreaks[0]="airstrike_mp";
	self.killSreaks[1]="helicopter_mp";
	self.killSreaks[2]="radar_mp";
	for(;;)
	{
		if(Distance(self.origin,(self.c["Box"].origin))< 35)
		{
			if(getButtonPressed("+activate"))
			{
				self FreezeControls(true);
				self thread CreateBoxBar("CENTER","CENTER",0,120,100,4,(1,1,1),1.5);
				wait 1.5;
				self.PickedKillSteak=RandomInt(self.killSreaks.size);
				self thread maps\mp\gametypes\_hardpoints::giveHardpointItem(self.killSreaks[self.PickedKillSteak],0);
				self iPrintlnBold("^2" + self.killSreaks[self.PickedKillSteak]," ");
				self.c["Box"] Delete();
				self.Progress["Bar"] DestroyElem();
				level.Point destroy();
				self.CareGot=true;
				self.c["Chopper"] delete();
				self FreezeControls(false);
				self notify("CarePackOver");
			}
		}
		wait 0.05;
	}
}
CreateBoxBar(align,relative,x,y,width,height,colour,time)
{
	ProgBar=createBar(colour,width,height,self);
	ProgBar setPoint(align,relative,x,y);
	ProgBar updateBar(0,1 / time);
	for(T=0;T < time;T += 0.05)wait .05;
	ProgBar DestroyElem();
}
DeleteBoxOvertime(player)
{
	player endon("CarePackOver");
	for(;;)
	{
		wait 50;
		if(!self.CareGot)
		{
			self Delete();
			player.Progress["Bar"] DestroyElem();
			level.Point Destroy();
			player notify("CarePackOver");
			player FreezeControls(false);
		}
	}
}
CareSpeed(speed,origin,moveto)
{
	dist=distance(origin,moveto);
	time =(dist / speed);
	return time;
}
DeleatCareChopper()
{
	wait 10;
	self.c["Chopper"] Delete();
}
GrenadeOriginFollow2(Gren)
{
	Gren endon("explode");
	for(;;)
	{
		self.Grenade=Gren.origin;
		wait .01;
	}
}
FlyableJetChopper(Model)
{
	if(Model=="vehicle_mig29_desert")self iPrintlnBold("^2Spawned a Jet");
	else self iPrintlnBold("^2Spawned a Helicopter");
	self iPrintln("Press [{+activate}] To Enter Vehicle!\nPress [{+activate}] To Fly!\nPress [{+melee}] To Exit!");
	position=self getOrigin()+(0,0,50)+ anglesToForward(self getPlayerAngles())* 200;
	flyingJet=spawn("script_model",position);
	self thread xxdestroyOnDeath(flyingJet);
	jet=flyingJet;
	jet.occupied=0;
	jet.soundOn=0;
	jet setModel(Model);
	jet thread monitorOccupant();
}
monitorOccupant()
{
	while(!self.occupied)
	{
		for(i=0;i < level.players.size;i++)
		{
			p=level.players[i];
			if(!self.occupied)
			{
				if((p UseButtonPressed())&& distance(p.origin,self.origin)<= 150)
				{
					self.lastPosition=self.origin;
					self.lastAngles=self.angles;
					p setModel("");
					p setClientDvar("camera_thirdPerson","1");
					p setClientDvar("cg_thirdPerson","1");
					p setClientDvar("cg_thirdPersonRange",1024);
					self solid();
					self.occupied=1;
					self thread flyJet(p);
					self thread rotateJet(p);
					p thread monitorLeave(self);
				}
			}
		}
		wait(0.05);
	}
}
flyJet(pilot)
{
	self endon("disconnect");
	self endon("death");
	pilot setOrigin(self.origin);
	pilot LinkTo(self);
	pilot.speed=0;
	self.baseSpeed=15;
	slowdown=0;
	while(self.occupied)
	{
		if(pilot UseButtonPressed())
		{
			forwards[0]=self.origin + anglesToForward(self.angles)*(self.baseSpeed * pilot.speed);
			forwards[1]=self.origin + anglesToForward(self.angles)* 150;
			trace=bulletTrace(self.origin +(0,0,5),forwards[1],false,self);
			self moveTo(forwards[0],0.05);
			if(pilot.speed < 15)pilot.speed += .5;
		}
		else
		{
			if(pilot.speed > 0)
			{
				pilot.speed -= .05;
				slowdown=self.origin + anglesToForward(self.angles)*(self.baseSpeed * pilot.speed);
				self moveTo(slowdown,0.05);
			}
		}
		wait(0.05);
	}
}
RotateJet(pilot)
{
	turnspeed=undefined;
	rollangle=0;
	while(self.occupied)
	{
		wait 0.1;
		if(pilot.speed > 5)
		{
			playFXOnTag(level.fx_airstrike_contrail,self,"tag_left_wingtip");
			playFXOnTag(level.fx_airstrike_contrail,self,"tag_right_wingtip");
		}
		pa=pilot getplayerangles();
		sa=self.angles;
		if(sa!=pa)
		{
			ps=pa[1] - sa[1];
			sp=sa[1] - pa[1];
			if(!sp||!pilot.speed)rollangle=0;
			else if(sp > 0 && pilot.speed > 5)rollangle =(sp);
			else if(ps > 0 && pilot.speed > 5)rollangle =(ps * -1);
			if(pa[0]<=-45||pa[0]>=45)rollangle=0;
			turnspeed=0.8;
			if(pilot.speed < 8)turnspeed=1.2;
			self rotateTo((pa[0],pa[1],rollangle),turnspeed);
		}
	}
}