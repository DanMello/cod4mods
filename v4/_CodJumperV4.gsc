#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include maps\mp\gametypes\_general_funcs;
#include maps\mp\gametypes\_CJfuncs;
#include maps\mp\gametypes\_CJ_functions;



//GAMETYPES SETTING
//HARDCORE UN JOUEUR

//TROUVER DES FUNCS POUR BOTS

//BINDS CUSTOM

init()
{
	if(level.utilise_AIO_en_ligne && level.console)
		return;
	
	
	level notify("newstartinggame");
		
	level thread onPlayerConnect();
	
	level.gameModeDevName = "CJ";
	level.current_game_mode = "CodJumper Mod V4.2";
	
	level.PositionMarkage = loadfx( "misc/ui_flagbase_red" );
	level.Map_Center = maps\mp\gametypes\_spawnlogic::findBoxCenter(level.spawnMins,level.spawnMaxs);
	level.flagBase_red = loadfx( "misc/ui_flagbase_red" );
	
	//PRESTIGE
	for(i=1;i<12;i++) PrecacheShader("rank_prestige"+i);
	PrecacheShader("rank_comm1");
	
	//setDvar( "bg_bobMax", 0 );
	//setDvar( "player_throwBackInnerRadius", 0 );
	//setDvar( "player_throwBackOuterRadius", 0 );
	
	setdvar("CJ_GAMETYPE","0");
	
	level.mapDEVlist = strTOK("convoy,backlot,bloc,bog,countdown,crash,crossfire,citystreets,farm,overgrown,pipeline,shipment,showdown,strike,vacant,cargoship",",");
	level.mapNameList = strTOK("Ambush,Backlot,Bloc,Bog,Countdown,Crash,Crossfire,District,Downpour,Overgrown,Pipeline,Shipment,Showdown,Strike,Vacant,Wet work",",");
	
	level.RiflesShaders = strTok("weapon_m16a4,weapon_ak47,weapon_m4carbine,weapon_g3,weapon_g36c,weapon_m14,weapon_mp44",",");
	for(i=0;i<level.RiflesShaders.size;i++) PrecacheShader(level.RiflesShaders[i]);
	
	level.SMGShaders = strTok("weapon_mp5,weapon_skorpion,weapon_mini_uzi,weapon_aks74u,weapon_p90",",");
	for(i=0;i<level.SMGShaders.size;i++) PrecacheShader(level.SMGShaders[i]);
	
	level.LMGShaders = strTok("weapon_m249saw,weapon_rpd,weapon_m60e4",",");
	for(i=0;i<level.LMGShaders.size;i++) PrecacheShader(level.LMGShaders[i]);
	
	level.SHOTGUNSShaders = strTok("weapon_winchester1200,weapon_benelli_m4",",");
	for(i=0;i<level.SHOTGUNSShaders.size;i++) PrecacheShader(level.SHOTGUNSShaders[i]);
	
	level.SNIPERSShaders = strTok("weapon_m40a3,weapon_dragunovsvd,weapon_m14_scoped,weapon_remington700,weapon_barrett50cal",",");
	for(i=0;i<level.SNIPERSShaders.size;i++) PrecacheShader(level.SNIPERSShaders[i]);
	
	level.SecondaryShaders = strTok("weapon_usp_45,weapon_m9beretta,weapon_colt_45,,weapon_desert_eagle,weapon_desert_eagle_gold",",");
	for(i=0;i<level.SecondaryShaders.size;i++) PrecacheShader(level.SecondaryShaders[i]);
	
	setdvar("g_pdayerCollisionEjectSpeed","1");
	
	while(!isDefined(level.inPrematchPeriod)) wait .05;
	
}
onPlayerConnect()
{
	
	for(;;)
	{
		level waittill( "connected", player );
		
		if ( isDefined( player.pers["isBot"] ) )
			return;	
			
		//CJ
		player.Profil_launched = false;
		player.snl = false;
		player.graphicPreset = false;
		player.Call_third = false;
		player.Call_teleport = false;
		player.RPG_DPAD = false;
		player.Noclip = false;
		player.GodMode = false;
		player.Elebot = false;
		player.LoadBounce = false;
		player.ThirdP = false;
		player.UnlimitedAmmo = 0;
		player.NoclipSpectator = false;
		player.InNoclipSpectator = false;
		player.BlockerCont = false;
		player.Unlocking_Challenges = false;
		player.GunBounceChanger = false;
		player.inMovingMenuPos = false;
		player.checkingvelo = false;
		player.mod_usingbot = false;
		player.onlyplayerhc = false;
		player.hardcorebinds = false;
		player.checkingorigin = false;
		player.client_velocity = 0;
		player.client_maxvelocity = 0;
		
		
		
		player.PositionNumber = "A";
		player.SmokeTrail= false;
		
		player.IN_MENU["CONF"] = false;
		player.IN_MENU["P_SELECTOR"] = false;
		player.IN_MENU["LANG"] = false;
		player.IN_MENU["RANK"] = false;
		player.IN_MENU["CJ"] = false;
		
		player.SavedPosition = 0;
		player.LoadedPosition = 0;
		
		player.ShowingPosition = false;
	
		
		
		
		//GRAPHIC
		player.ShowSLText = true;
		player.fx_enable = false;
		player.fx_marks = false;
		player.fx_draw = false;
		player.ShowIcons = false;
		player.ShowGun = false;
		player.ShowCrossHair = false;
		player.Fov85 = false;
		player.ShowKillfeed = false;
		player.ShowFPS = false;
		player.ShowRankIcons = false;
		player.ShowNames = false;
		player.ShowSpecButs = false;
		player.ShowHardcore = false;

		player.UnlimitedSprint = true;
		player.JumpSlowDown = true;
		
		player.Unlocking_Challenges = false;
		player.in_VIP_list = false;
		player.Notification_in_progress = false;
		
		player.Notify_P3 = false;
		player.Notify_P2 = false;
		player.Notify_P1 = false;
		
		player thread EnterInAIO();
		
		player thread onPlayerSpawned();
	}
}
EnterInAIO()
{
	if(!level.normal_game)
	{
		self setClientDvars("customclass1","CodJumper","customclass2","Patch ^5v4.1","customclass3","Created by","customclass4","DizePara","customclass5","<3" );
	}
	
	self setClientDvar("ui_ShowMenuOnly", "");
	self setClientDvar("loc_warnings","0");
	self setClientDvar("loc_warningsAsError","0");
	
}
	


onPlayerSpawned()
{
	self endon("disconnect");
		
	while(!isDefined(self.connect_script_done)) wait .05;
	
	if(getDvar("scr_oldschool") == "0")
		self thread Checkspeedweapon();
	
	
	self setClientDvar( "cg_everyoneHearsEveryone", 1);
	 
	if(self getentitynumber() == 0)
	{
		setDvar("bg_fallDamageMaxHeight",9999);
		setDvar("bg_fallDamageMinHeight",9998);
		setDvar("jump_slowdownEnable",0);
		setDvar("player_sprintUnlimited",1);
		
		iPrintln("CJ Dvars ^2loaded");
	}	
		
	self thread maps\mp\gametypes\_replay_mod::ReplayMode();
	
	if(self getstat(3446) == 0) self.Menu["HUD"]["PositionX"] = 0;
	else self.Menu["HUD"]["PositionX"] = self getstat(3446);
	if(self getstat(3447) == 0) self.Menu["HUD"]["PositionY"] = 20;
	else self.Menu["HUD"]["PositionY"] = self getstat(3447);
	
	
	if(self getstat(3448) == 1) self thread getSavedParam("auto"); //AUTO LAUNCH
	
	self thread Menu();
	
	
	for(;;)
	{
		self waittill("spawned_player");	
	
		if(self.RPG_DPAD)
		{
			self giveWeapon("rpg_mp");
			self SetActionSlot(4, "weapon", "rpg_mp" );
		}
		
		if(self.GodMode && self.HASGODMODE)
		{
			self.maxhealth = 90000;
			self.health = self.maxhealth;
		}
		
	 
	self setclientdvar("g_pdayerCollisionEjectSpeed","1");
	
		self TakeWeapon("frag_grenade_mp");
		self TakeWeapon("flash_grenade_mp");
		self TakeWeapon("concussion_grenade_mp");
		self TakeWeapon("smoke_grenade_mp");
		
		if(self.CJ_Access > 1) self iprintln("Press [{+smoke}] + [{+melee}] to open CodJumper Mod ^5V4.2");
		
	}
}

Menu()
{
	self freezecontrols(false);
	
	self.ClosingMenu = false;
	self.LittleSub["OPEN"] = false;
	self.Menu["Sub"] = "Closed";
	self.Menu["Curs"] = 0;
	
	if(self getentitynumber() == 0) 
		self.CJ_Access = 4;
	else
		self.CJ_Access = 1;
		
	wait 1;
	
	if(self getstat(3449) == 1 && self.CJ_Access < 2) self.CJ_Access = 2;
	if(self getstat(3449) == 2 && self.CJ_Access < 3) self.CJ_Access = 3;
	
	wait 1;
	self thread MenuOptions();
	wait 1;
	self thread MenuControls();
}


xx()
{
}

StartProfil()
{
	self thread KFTIME();
	self setClientDvar( "con_gameMsgWindow0LineCount", 7);
	self setClientDvar( "con_gameMsgWindow0FadeOutTime ", 2);
	
	if(!self.Profil_launched)
	{
		self.Profil_launched = true;
		self thread getSavedParam();
		self thread CallLowerText("\n\n\n\n^2Profil enabled",2);
	}
	else
	{
		self.Profil_launched = false;
		self thread getSavedParam("DEL");
		self thread CallLowerText("\n\n\n\n^1Profil disabled",2);
	}
	
	
}
KFTIME()
{
	wait 3;
	self setClientDvar( "con_gameMsgWindow0LineCount", 4);
	self setClientDvar( "con_gameMsgWindow0FadeOutTime ", 0.5);
}

setCustomSettings(text,num)
{
	if(text == "NOCLIP")
	{
		if(self getstat(num) == 0)
		{
			self setstat(num,1);
			self iprintln(text+": v1 ^2SAVED");
		}
		else if(self getstat(num) == 1)
		{
			self setstat(num,2);
			self iprintln(text+": v2 ^2SAVED");
		}
		else if(self getstat(num) == 2)
		{
			self setstat(num,0);
			self iprintln(text+": ^1DELETED");
		}
	}
	
	else if(text == "Unlimited ammo")
	{
		if(self getstat(num) == 0)
		{
			self setstat(num,1);
			self iprintln(text+": normal ^2SAVED");
		}
		else if(self getstat(num) == 1)
		{
			self setstat(num,2);
			self iprintln(text+": cheater ^2SAVED");
		}
		else if(self getstat(num) == 2)
		{
			self setstat(num,0);
			self iprintln(text+": ^1DELETED");
		}
	}
	else if(text == "Save and load")
	{
		if(self getstat(num) == 0)
		{
			self setstat(num,1);
			self iprintln(text+": x1x1 ^2SAVED");
		}
		else if(self getstat(num) == 1)
		{
			self setstat(num,2);
			self iprintln(text+": x1x2 ^2SAVED");
		}
		else if(self getstat(num) == 2)
		{
			self setstat(num,3);
			self iprintln(text+": x2x1 ^2SAVED");
		}
		else if(self getstat(num) == 3)
		{
			self setstat(num,4);
			self iprintln(text+": x2x2 ^2SAVED");
		}
		else if(self getstat(num) == 4)
		{
			self setstat(num,0);
			self iprintln(text+": ^1DELETED");
		}
	}
	else
	{
		if(self getstat(num) == 0)
		{
			self setstat(num,1);
			self iprintln(text+": ^2SAVED");
		}
		else if(self getstat(num) == 1)
		{
			self setstat(num,0);
			self iprintln(text+": ^1DELETED");
		}
	}
}

getSavedParam(mode)
{
	if(isDefined(mode) && mode == "auto")
	{
		self waittill("spawned_player");	
		self.Profil_launched = true;
		
	}
	
	if(isDefined(mode) && mode == "DEL")
	{
		if(self getstat(3450) != 0) self thread CallSV("DEL"); //S&L
		if(self getstat(3451) == 1) self thread GodMode("DEL"); //GOD
		if(self getstat(3452) != 0) self thread AmmoMon("DEL"); //AMMO
		if(self getstat(3453) == 1) self thread RPG_DPAD("DEL"); //RPG
		
		if(self getstat(3454) != 0)
		{
			self thread Noclip("DEL"); //NOCLIP
			self thread Advanced_Noclip("DEL");
		}
		
		if(self getstat(3455) == 1) self thread Call_third("DEL"); //THIRD PERSON
		if(self getstat(3456) == 1) self thread Call_teleport("DEL"); //TELE BINDS
		if(self getstat(3457) == 1) self thread EleBot("DEL"); //ELEBOT
		if(self getstat(3467) == 1) self thread GunChangeratbounce("DEL"); //ELEBOT
		
		if(self getstat(3458) == 1 && !self.ShowSLText) self thread GraphicFuncs("0"); //SL
		if(self getstat(3459) == 1 && self.fx_enable) self thread GraphicFuncs("1"); //ENABLE
		if(self getstat(3460) == 1 && self.fx_marks) self thread GraphicFuncs("2"); //MARKS
		if(self getstat(3461) == 1 && self.fx_draw) self thread GraphicFuncs("3"); //DRAW
		if(self getstat(3462) == 1 && self.ShowIcons) self thread GraphicFuncs("4"); //ICONS
		if(self getstat(3463) == 1 && self.ShowFPS) self thread GraphicFuncs("9"); //FPS
		if(self getstat(3464) == 1 && self.ShowRankIcons) self thread GraphicFuncs("10"); //RANKS
		if(self getstat(3465) == 1 && self.ShowNames) self thread GraphicFuncs("11"); //NAMES
		if(self getstat(3466) == 1 && self.ShowHardcore) self thread xx(); //HARDCORE
		return;
	}
	
	//PROFIL PARAM
	if(self getstat(3450) == 1) self thread CallSV("x1x1"); //S&L
	if(self getstat(3450) == 2) self thread CallSV("x1x2");
	if(self getstat(3450) == 3) self thread CallSV("x2x1");
	if(self getstat(3450) == 4) self thread CallSV("x2x2"); 
	
	if(self getstat(3451) == 1) self thread GodMode(1); //GOD
	
	if(self getstat(3452) == 1) 
	{
		self.UnlimitedAmmo = 0;
		self thread AmmoMon(); //AMMO NORMAL
	}
	else if(self getstat(3452) == 2)
	{
		self.UnlimitedAmmo = 1;
		self thread AmmoMon(); //AMMO CHEATER
	}
	
	if(self getstat(3453) == 1) self thread RPG_DPAD(1); //RPG
	
	if(self getstat(3454) == 1) self thread Noclip(1);  //NOCLIP
	else if(self getstat(3454) == 2) self thread Advanced_Noclip(1); //NOCLIP v2
	
	if(self getstat(3455) == 1) self thread Call_third(1); //THIRD PERSON
	if(self getstat(3456) == 1) self thread Call_teleport(1); //TELE BINDS
	if(self getstat(3457) == 1) self thread EleBot(1); //ELEBOT
	
	if(self getstat(3467) == 1) self thread GunChangeratbounce(1); //ELEBOT
	
	
	//GRAPHIC
	if(self getstat(3458) == 1 && self.ShowSLText) self thread GraphicFuncs("0"); //SL
	if(self getstat(3459) == 1 && !self.fx_enable) self thread GraphicFuncs("1"); //ENABLE
	if(self getstat(3460) == 1 && !self.fx_marks) self thread GraphicFuncs("2"); //MARKS
	if(self getstat(3461) == 1 && !self.fx_draw) self thread GraphicFuncs("3"); //DRAW
	if(self getstat(3462) == 1 && !self.ShowIcons) self thread GraphicFuncs("4"); //ICONS
	if(self getstat(3463) == 1 && !self.ShowFPS) self thread GraphicFuncs("9"); //FPS
	if(self getstat(3464) == 1 && !self.ShowRankIcons) self thread GraphicFuncs("10"); //RANKS
	if(self getstat(3465) == 1 && !self.ShowNames) self thread GraphicFuncs("11"); //NAMES
	if(self getstat(3466) == 1 && !self.ShowHardcore) self thread xx(); //HARDCORE

	
}



MenuOptions()
{
	w = self GetCurrentWeapon();
	
	if(self.CJ_Access > 1 || self getstat(3449) == 1)
	{
		self AddMenuAction("Main",0,"Start your profil",::StartProfil);
		self AddMenuAction("Main",1,"Account Menu",::SubMenu,"account");
		self AddMenuAction("Main",2,"CJ Options",::SubMenu,"Option");
		self AddMenuAction("Main",3,"Advanced CJ Options",::SubMenu,"AdvOptions");
		self AddMenuAction("Main",4,"Graphic Options",::SubMenu,"graphic");
		self AddMenuAction("Main",5,"CC Menu",::SubMenu,"CC");
		self AddMenuAction("Main",6,"Infectable Mod Menu",::LittleSub,"MODMENU");
		self AddMenuAction("Main",7,"Weapon Menu",::SubMenu,"weapons");
		self AddMenuAction("Main",8,"Player appearance",::SubMenu,"Skin");
		
	}
	
	if(self.CJ_Access == 4 || self.CJ_Access == 3 || self getstat(3449) == 2)
	{
		self AddMenuAction("Main",9,"Blockers Menu",::SubMenu,"BotMenu");
		self AddMenuAction("Main",10,"Blocker Options",::SubMenu,"blockers");
		self AddMenuAction("Main",11,"------","","host");
		self AddMenuAction("Main",12,"^7Game settings",::SubMenu,"game_settings");
		self AddMenuAction("Main",13,"Advanced settings",::SubMenu,"adv_settings");
		self AddMenuAction("Main",14,"Jump settings",::SubMenu,"jump_settings");
		self AddMenuAction("Main",15,"Players Menu",::SubMenu,"Player");
		self AddMenuAction("Main",16,"All player Menu",::SubMenu,"AllPlayers");
	}
	
	self AddBackToMenu("account","Main");
	self AddMenuAction("account",0,"Unlock All",::UnlockAll);
	self AddMenuAction("account",1,"Rank 55",::Experience);
	self AddMenuAction("account",2,"Prestige Selector",::PrestigeSelector);
	self AddMenuAction("account",3,"Menu Position",::positionEditor);
	self AddMenuAction("account",4,"CJ Profil Parameter",::SubMenu,"Profil");
	self AddMenuAction("account",5,"Open controls",::openmyctrls);
	
	
	
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//CUSTOM PARAMETER
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	self AddBackToMenu("Profil","account");
	self AddMenuAction("Profil",0,"Launch by first spawn",::setCustomSettings,"Auto launch",3448);
	self AddMenuAction("Profil",1,"Gameplay",::LittleSub,"Profil_gameplay");
	self AddMenuAction("Profil",2,"Graphic",::LittleSub,"Profil_graphic");
	self AddMenuAction("Profil",3,"^3What is 'profil option'?",::WhatIsPO);
	
	self AddBackToMenu("Profil_gameplay","Profil");
	self AddMenuAction("Profil_gameplay",0,"Save and load",::setCustomSettings,"Save and load",3450);
	self AddMenuAction("Profil_gameplay",1,"God mode",::setCustomSettings,"God mode",3451);
	self AddMenuAction("Profil_gameplay",2,"Ammo",::setCustomSettings,"Unlimited ammo",3452);
	self AddMenuAction("Profil_gameplay",3,"RPG",::setCustomSettings,"RPG DPAD",3453);
	self AddMenuAction("Profil_gameplay",4,"Noclip",::setCustomSettings,"NOCLIP",3454);
	self AddMenuAction("Profil_gameplay",5,"Third person binds",::setCustomSettings,"Third person binds",3455);
	self AddMenuAction("Profil_gameplay",6,"Teleport binds",::setCustomSettings,"Teleport binds",3456);
	self AddMenuAction("Profil_gameplay",7,"Elebot",::setCustomSettings,"Elebot binds",3457);
	self AddMenuAction("Profil_gameplay",8,"RPG Bounce changer",::setCustomSettings,"RPG Gun changer",3467);
	
	
	self AddBackToMenu("Profil_graphic","Profil");
	self AddMenuAction("Profil_graphic",0,"Hardcore (only player)",::setCustomSettings,"Enable Hardcore",3466);
	self AddMenuAction("Profil_graphic",1,"S&L TEXTS",::setCustomSettings,"Hide Save and Load TEXTS",3458);
	self AddMenuAction("Profil_graphic",2,"fx_enable",::setCustomSettings,"Disable fx_enable",3459);
	self AddMenuAction("Profil_graphic",3,"fx_marks",::setCustomSettings,"Disable fx_marks",3460);
	self AddMenuAction("Profil_graphic",4,"fx_draw",::setCustomSettings,"Disable fx_draw",3461);
	self AddMenuAction("Profil_graphic",5,"Objective Icons",::setCustomSettings,"Hide Objective Icons",3462);
	self AddMenuAction("Profil_graphic",6,"FPS",::setCustomSettings,"Show FPS",3463);
	self AddMenuAction("Profil_graphic",7,"Player Ranks/Icons",::setCustomSettings,"Hide Player Ranks/Icons",3464);
	self AddMenuAction("Profil_graphic",8,"Player Names",::setCustomSettings,"Hide Player names",3465);
	//self AddMenuAction("Profil_graphic",8,"Player Names",::setCustomSettings,"Hide Player names",3465);
	
	
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	self AddBackToMenu("Option","Main");
	self AddMenuAction("Option",0,"CodJumper preset",::CodJumperMod);
	self AddMenuAction("Option",1,"Save and Load params",::LittleSub,"customsl");
	self AddMenuAction("Option",2,"Freeze Jump",::FreezeJump);
	self AddMenuAction("Option",3,"Teleport",::Teleport);
	self AddMenuAction("Option",4,"God Mode",::GodMode);
	self AddMenuAction("Option",5,"Unlimited Ammo",::AmmoMon);
	self AddMenuAction("Option",6,"Third Person",::ThirdP);
	self AddMenuAction("Option",7,"NoClip",::Noclip);
	self AddMenuAction("Option",8,"NoClip V2",::Advanced_Noclip);
	self AddMenuAction("Option",9,"RPG DPAD Right",::RPG_DPAD);
	self AddMenuAction("Option",10,"Load Bounce Mod",::LoadBounce);
	self AddMenuAction("Option",11,"Teleport Binds",::Call_teleport);
	self AddMenuAction("Option",12,"3rd Person Binds",::Call_third);
	
	
	
	
	
	self AddBackToMenu("customsl","Option" );
	self AddMenuAction("customsl",0,"Save x1 ^7Load x1",::CallSV,"x1x1");
	self AddMenuAction("customsl",1,"Save x1 ^7Load x2",::CallSV,"x1x2");
	self AddMenuAction("customsl",2,"Save x2 ^7Load x1",::CallSV,"x2x1");
	self AddMenuAction("customsl",3,"Save x2 ^7Load x2",::CallSV,"x2x2");
	self AddMenuAction("customsl",4,"Disable save and load",::CallSV,"DEL");
	
	self AddBackToMenu("AdvOptions","Main");
	
	self AddMenuAction("AdvOptions",0,"Clone yourself",::CloneMe);
	self AddMenuAction("AdvOptions",1,"Suicide",::KillMe);
	self AddMenuAction("AdvOptions",2,"Smoke trail",::Smoke_trail);
	self AddMenuAction("AdvOptions",3,"set CodJumper Class",::DP_CJ_class);
	self AddMenuAction("AdvOptions",4,"EleBot",::EleBot);
	self AddMenuAction("AdvOptions",5,"Share my positions",::BeforeSharing);
	self AddMenuAction("AdvOptions",6,"Show number of S&L",::GraphicFuncs,"-1");
	self AddMenuAction("AdvOptions",7,"RPG Bounce changer",::GunChangeratbounce);
	self AddMenuAction("AdvOptions",8,"Velocity Checker",::CheckingVelocity);
	self AddMenuAction("AdvOptions",9,"Origin Checker",::CheckingOrigin);
	//self AddMenuAction("AdvOptions",10,"change time TEST",::InvisibleBoy);
	//self AddMenuAction("AdvOptions",11,"change time TEST2",::InvisibleBoy2);
	//self AddMenuAction("AdvOptions",12,"show angles",::showplayerangles);
	
	
	//self AddMenuTitle("graphic","Graphic Menu");
	self AddBackToMenu("graphic","Main" );
	self AddMenuAction("graphic",0,"CodJumper preset",::GraphicPreset);
	self AddMenuAction("graphic",1,"Hardcore (only player)",::LittleSub,"hcplayer");
	self AddMenuAction("graphic",2,"S&L TEXTS",::GraphicFuncs,"0");
	self AddMenuAction("graphic",3,"fx_enable",::GraphicFuncs,"1");
	self AddMenuAction("graphic",4,"fx_marks",::GraphicFuncs,"2");
	self AddMenuAction("graphic",5,"fx_draw",::GraphicFuncs,"3");
	self AddMenuAction("graphic",6,"Objective Icons",::GraphicFuncs,"4");
	self AddMenuAction("graphic",7,"draw_gun",::GraphicFuncs,"5");
	self AddMenuAction("graphic",8,"Cross hair",::GraphicFuncs,"6");
	self AddMenuAction("graphic",9,"Fov 85",::GraphicFuncs,"7");
	self AddMenuAction("graphic",10,"Killfeed",::GraphicFuncs,"8");
	self AddMenuAction("graphic",11,"drawFPS",::GraphicFuncs,"9");
	self AddMenuAction("graphic",12,"Player Ranks/Icons",::GraphicFuncs,"10");
	self AddMenuAction("graphic",13,"Player Names",::GraphicFuncs,"11");
	self AddMenuAction("graphic",14,"Spectator Buttons",::GraphicFuncs,"12");
	
	self AddBackToMenu("hcplayer","graphic" );
	self AddMenuAction("hcplayer",0,"Hardcore ON/OFF",::HCONLYP,"ONOFF");
	self AddMenuAction("hcplayer",1,"Hardcore Binds",::HCONLYP,"binds");
	
	
	
	//self AddMenuTitle("CC","CC Menu");
	self AddBackToMenu("CC","Main");
	//self AddMenuAction("CC",0,"CC 1",::Color_correction,"CC1");
	self AddMenuAction("CC",0,"CC 2",::Color_correction,"CC2");
	self AddMenuAction("CC",1,"CC 3",::Color_correction,"CC3");
	self AddMenuAction("CC",2,"CC 4",::Color_correction,"CC4");
	self AddMenuAction("CC",3,"CC 5",::Color_correction,"CC5");
	self AddMenuAction("CC",4,"CC 6",::Color_correction,"CC6");
	self AddMenuAction("CC",5,"CC 7",::Color_correction,"CC7");
	self AddMenuAction("CC",6,"CC 8",::Color_correction,"CC8");
	self AddMenuAction("CC",7,"CC 9",::Color_correction,"CC9");
	self AddMenuAction("CC",8,"CC 10",::Color_correction,"CC10");
	self AddMenuAction("CC",9,"CC 11",::Color_correction,"CC11");
	self AddMenuAction("CC",10,"CC 12",::Color_correction,"CC12");
	self AddMenuAction("CC",11,"CC 13",::Color_correction,"CC13");
	self AddMenuAction("CC",12,"CC 14",::Color_correction,"CC14");
	self AddMenuAction("CC",13,"CC 15",::Color_correction,"CC15");
	self AddMenuAction("CC",14,"CC 16",::Color_correction,"CC16");
	self AddMenuAction("CC",15,"CC 17",::Color_correction,"CC17");
	self AddMenuAction("CC",16,"Default Vision",::Color_correction);
	
	 
	self AddBackToMenu("MODMENU","Main");
	self AddMenuAction("MODMENU",0,"Enable",::MTPIMM);
	self AddMenuAction("MODMENU",1,"Disable",::disableMOS);
	
	//self AddMenuTitle("weapons","Weapon Menu");
	self AddBackToMenu("weapons","Main");
	self AddMenuAction("weapons",0,"Change Camo",::LittleSub,"CAM");
	self AddMenuAction("weapons",1,"Give all perks",::giveperkzz);
	self AddMenuAction("weapons",2,"Take all weapons",::takemyweaponz);
	self AddMenuAction("weapons",3,"Assault Rifles",::LittleSub,"AR");
	self AddMenuAction("weapons",4,"SMGs",::LittleSub,"SMG");
	self AddMenuAction("weapons",5,"LMGs",::LittleSub,"LMG");
	self AddMenuAction("weapons",6,"Shotguns",::LittleSub,"SG");
	self AddMenuAction("weapons",7,"Sniper Rifles",::LittleSub,"SN");
	self AddMenuAction("weapons",8,"Pistols",::LittleSub,"GUN");
	
	self AddBackToMenu("AR","weapons");
	self AddMenuAction("AR",0,"M16",::Allweap,"m16");
	self AddMenuAction("AR",1,"AK47",::Allweap,"ak47");
	self AddMenuAction("AR",2,"M4",::Allweap,"m4");
	self AddMenuAction("AR",3,"G3",::Allweap,"g3");
	self AddMenuAction("AR",4,"G36c",::Allweap,"g36c");
	self AddMenuAction("AR",5,"M14",::Allweap,"m14");
	self AddMenuAction("AR",6,"MP44",::Allweap,"mp44");
	
	self AddBackToMenu("SMG","weapons");
	self AddMenuAction("SMG",0,"MP5",::Allweap,"mp5");
	self AddMenuAction("SMG",1,"Skorpion",::Allweap,"skorpion");
	self AddMenuAction("SMG",2,"Mini-Uzi",::Allweap,"uzi");
	self AddMenuAction("SMG",3,"AK74u",::Allweap,"ak74u");
	self AddMenuAction("SMG",4,"P90",::Allweap,"p90");
	
	self AddBackToMenu("LMG","weapons");
	self AddMenuAction("LMG",0,"M249 Saw",::Allweap,"saw");
	self AddMenuAction("LMG",1,"RPD",::Allweap,"rpd");
	self AddMenuAction("LMG",2,"M60e4",::Allweap,"m60e4");
	
	self AddBackToMenu("SG","weapons");
	self AddMenuAction("SG",0,"W1200",::Allweap,"winchester1200");
	self AddMenuAction("SG",1,"M1014",::Allweap,"m1014");
	
	self AddBackToMenu("SN","weapons");
	self AddMenuAction("SN",0,"M40a3",::Allweap,"m40a3");
	self AddMenuAction("SN",1,"Dragunov",::Allweap,"dragunov");
	self AddMenuAction("SN",2,"M21",::Allweap,"m21");
	self AddMenuAction("SN",3,"R700",::Allweap,"remington700");
	self AddMenuAction("SN",4,"Barrett",::Allweap,"barrett");
	
	self AddBackToMenu("GUN","weapons");
	self AddMenuAction("GUN",0,"USP",::Allweap,"usp");
	self AddMenuAction("GUN",1,"Beretta",::Allweap,"beretta");
	self AddMenuAction("GUN",2,"Colt45",::Allweap,"colt45");
	self AddMenuAction("GUN",3,"Desert Eagle",::Allweap,"deserteagle");
	self AddMenuAction("GUN",4,"Gold Eagle",::Allweap,"deserteaglegold");
	
	self AddBackToMenu("CAM","weapons");
	self AddMenuAction("CAM",0,"None",::ChangeCamo,0);
	self AddMenuAction("CAM",1,"Desert",::ChangeCamo,1);
	self AddMenuAction("CAM",2,"Woodland",::ChangeCamo,2);
	self AddMenuAction("CAM",3,"Digital",::ChangeCamo,3);
	self AddMenuAction("CAM",4,"Blue Tiger",::ChangeCamo,5);
	self AddMenuAction("CAM",5,"Red Tiger",::ChangeCamo,4);
	self AddMenuAction("CAM",6,"Gold",::ChangeCamo,6);
	
	self AddBackToMenu("Skin","Main");
	self AddMenuAction("Skin",0,"SPEC OPS",::SkinMonitor,"allies","SPECOPS");
	self AddMenuAction("Skin",1,"ASSAULT",::SkinMonitor,"allies","ASSAULT");
	self AddMenuAction("Skin",2,"SNIPER",::SkinMonitor,"allies","SNIPER");
	self AddMenuAction("Skin",3,"RECON",::SkinMonitor,"allies","RECON");
	self AddMenuAction("Skin",4,"SUPPORT",::SkinMonitor,"allies","SUPPORT");
	self AddMenuAction("Skin",5,"^1ENNEMY ^7SPEC OPS",::SkinMonitor,"axis","SPECOPS");
	self AddMenuAction("Skin",6,"^1ENNEMY ^7ASSAULT",::SkinMonitor,"axis","ASSAULT");
	self AddMenuAction("Skin",7,"^1ENNEMY ^7SNIPER",::SkinMonitor,"axis","SNIPER");
	self AddMenuAction("Skin",8,"^1ENNEMY ^7RECON",::SkinMonitor,"axis","RECON");
	self AddMenuAction("Skin",9,"^1ENNEMY ^7SUPPORT",::SkinMonitor,"axis","SUPPORT");
	
	
	self AddBackToMenu("blockers","Main");
	self AddMenuAction("blockers",0,"Add Blocker",::LittleSub,"AdvBlocker");
	self AddMenuAction("blockers",1,"Blocker controler",::GiveForge);
	self AddMenuAction("blockers",2,"Kick all bots",::AllOneShot,"8");
	
	
	self AddBackToMenu("AdvBlocker","blockers");
	self AddMenuAction("AdvBlocker",0,"Add to my team",::addRobot,"copain");
	self AddMenuAction("AdvBlocker",1,"Add to ennemy team",::addRobot,"pascopain");
	self AddMenuAction("AdvBlocker",2,"Auto",::addRobot,"auto");
	
	self AddBackToMenu("bot_opt","BotMenu" );
	self AddMenuAction("bot_opt",0,"Suicide",::killBoooot);
	//self AddMenuAction("bot_opt",1,"Change team",::LittleSub,"change_team");
	self AddMenuAction("bot_opt",1,"Give position",::LittleSub,"giveposi");
	self AddMenuAction("bot_opt",2,"Live stance",::EnableBotsPosition);
	self AddMenuAction("bot_opt",3,"Static stance",::LittleSub,"staticstance");
	self AddMenuAction("bot_opt",4,"Teleport",::telePlayer);
	
	
	//self AddMenuTitle("host","HOST Menu");
	self AddBackToMenu("host","Main");
	
	
	
	//self AddMenuTitle("game_settings","Game Settings");
	self AddBackToMenu("game_settings","Main");
	self AddMenuAction("game_settings",0,"Restart",::LittleSub,"restart");
	self AddMenuAction("game_settings",1,"End Game",::LittleSub,"endgame");
	self AddMenuAction("game_settings",2,"Game unlimited",::JusquauBoutdeLaNuit);
	self AddMenuAction("game_settings",3,"Anti-Join",::LittleSub,"join");
	self AddMenuAction("game_settings",4,"Old School Options",::LittleSub,"old");
	self AddMenuAction("game_settings",5,"Add bomb zone",::LittleSub,"GTBOMBZ");
	self AddMenuAction("game_settings",6,"Change Map",::SubMenu,"mapchanger");
	
	
	
	
	self AddBackToMenu("mapchanger","game_settings");
	
	for(i=0;i<level.mapDEVlist.size;i++)
		self AddMenuAction("mapchanger",i,level.mapNameList[i],::ChangeMapADV,level.mapDEVlist[i],level.mapNameList[i]);
	
	self AddMenuAction("mapchanger",16,"Map pack",::LittleSub,"mappack");

	self AddBackToMenu("mappack","mapchanger");
	self AddMenuAction("mappack",0,"Broadcast",::ChangeMapADV,"broadcast","Broadcast");
	self AddMenuAction("mappack",1,"Creek",::ChangeMapADV,"creek","Creek");
	self AddMenuAction("mappack",2,"Chinatown",::ChangeMapADV,"carentan","Chinatown");
	self AddMenuAction("mappack",3,"Killhouse",::ChangeMapADV,"killhouse","Killhouse");
	
	
	
	
	self AddBackToMenu("GTBOMBZ","game_settings");
	self AddMenuAction("GTBOMBZ",0,"S&D",::bombzonetast,"SD");
	self AddMenuAction("GTBOMBZ",1,"SABOTAGE",::bombzonetast,"SAB");
	self AddMenuAction("GTBOMBZ",2,"S&D SABOTAGE",::bombzonetast,"BOTH");
	self AddMenuAction("GTBOMBZ",3,"NONE",::bombzonetast,"NONE");
	
	
	
	self AddBackToMenu("old","game_settings");
	self AddMenuAction("old",0,"Mode",::CallOS,"OS");
	self AddMenuAction("old",1,"Jump",::CallOS,"whatisthat");
	
	self AddBackToMenu("SGMODE","game_settings");
	self AddMenuAction("SGMODE",0,"Enable");
	self AddMenuAction("SGMODE",1,"Disable");
	
	self AddBackToMenu("restart","game_settings");
	self AddMenuAction("restart",0,"Booster",::Game_effect,"fast");
	self AddMenuAction("restart",1,"Fast",::Game_effect,"normal");
	
	self AddBackToMenu("endgame","game_settings");
	self AddMenuAction("endgame",0,"Booster",::Game_effect,"exit");
	self AddMenuAction("endgame",1,"Normal",::Game_effect,"lul");

	self AddBackToMenu("join","game_settings");
	self AddMenuAction("join",0,"^1CLOSE",::AntiJoin,"LOCK");
	self AddMenuAction("join",1,"^2OPEN",::AntiJoin,"OPEN");
	
	
	self AddBackToMenu("adv_settings","Main");
	self AddMenuAction("adv_settings",0,"Disable dead body",::DeleteBodyy);
	self AddMenuAction("adv_settings",1,"jump_slowdownenable",::Adv_settings,"jump");
	self AddMenuAction("adv_settings",2,"Sprint Unlimited",::Adv_settings,"sprint");
	self AddMenuAction("adv_settings",3,"Delete all clone & body",::DeleteAllBody);
	self AddMenuAction("adv_settings",4,"Hardcore for all",::GraphicFuncs,"-10");
	self AddMenuAction("adv_settings",5,"Delete death barriers",::DeleteDeathBarriers);
	
	
	
	
	
	//self AddMenuTitle("jump_settings","Jump Settings");
	self AddBackToMenu("jump_settings","Main" );
	self AddMenuAction("jump_settings",0,"Reset All",::Gameplay_effects,"non");
	self AddMenuAction("jump_settings",1,"Presets",::LittleSub,"presets");
	self AddMenuAction("jump_settings",2,"Custom",::Custom_settings,"custom");
	
	self AddBackToMenu("presets","jump_settings" );
	self AddMenuAction("presets",0,"Jump",::Gameplay_effects,"jump");
	self AddMenuAction("presets",1,"Speed",::Gameplay_effects,"speed");
	self AddMenuAction("presets",2,"Gravity",::Gameplay_effects,"gravity");
	self AddMenuAction("presets",3,"Slow Motion",::Gameplay_effects,"timescale");
	
	self AddBackToMenu("Player_Rank","Player" );
	self AddMenuAction("Player_Rank",0,"Verify Menu",::LittleSub,"ver");
	self AddMenuAction("Player_Rank",1,"Kick");
	self AddMenuAction("Player_Rank",2,"Suicide");
	self AddMenuAction("Player_Rank",3,"Change team",::LittleSub,"change_team");
	//self AddMenuAction("Player_Rank",4,"Give position",::LittleSub,"giveposi");
	//self AddMenuAction("Player_Rank",5,"Live stance",::EnableBotsPosition);
	//self AddMenuAction("Player_Rank",6,"Static stance",::LittleSub,"staticstance");
	self AddMenuAction("Player_Rank",4,"Teleport",::telePlayer);
	
	
	
	self AddBackToMenu("staticstance","bot_opt" );
	self AddMenuAction("staticstance",0,"Stand",::StaticPosition,"stand");
	self AddMenuAction("staticstance",1,"Crouch",::StaticPosition,"crouch");
	self AddMenuAction("staticstance",2,"Prone",::StaticPosition,"prone");

	
	self AddBackToMenu("giveposi","bot_opt" );
	self AddMenuAction("giveposi",0,"A",::GivePosToBot,"A");
	self AddMenuAction("giveposi",1,"B",::GivePosToBot,"B");
	self AddMenuAction("giveposi",2,"C",::GivePosToBot,"C");
	self AddMenuAction("giveposi",3,"D",::GivePosToBot,"D");
	self AddMenuAction("giveposi",4,"E",::GivePosToBot,"E");
	
	
	self AddBackToMenu("ver","Player_Rank" );
	self AddMenuAction("ver",0,"^1Un-Verify",::VerifyPeople,1,"^1Un-verified");
	self AddMenuAction("ver",1,"^7Verify",::VerifyPeople,2,"^2Verified");
	self AddMenuAction("ver",2,"Co-Host",::VerifyPeople,3,"^3CO-HOST");
	self AddMenuAction("ver",3,"Verify for life",::VerifyForLife,1,"Verified");
	self AddMenuAction("ver",4,"Co-Host for life",::VerifyForLife,2,"CO-HOST");
	
	self AddBackToMenu("change_team","Player_Rank" );
	self AddMenuAction("change_team",0,"to my team",::Change_team,"copain");
	self AddMenuAction("change_team",1,"to ennemi team",::Change_team,"pascopain");
	self AddMenuAction("change_team",2,"Spectator",::Change_team,"regardemoi");
	
	self AddBackToMenu("AllPlayers","Main" );
	self AddMenuAction("AllPlayers",0,"Give Rank 55",::AllOneShot,"4");
	self AddMenuAction("AllPlayers",1,"Give prestige selector",::AllOneShot,"7");
	self AddMenuAction("AllPlayers",2,"Give Unlock all",::AllOneShot,"5");
	self AddMenuAction("AllPlayers",3,"Kick",::AllOneShot,"1");
	self AddMenuAction("AllPlayers",4,"Suicide",::AllOneShot,"6");
	
	
}





tasty()
{
	/*level endon("endround");

	while (true)
	{
		wait 0.25;
		waitStatusUpdate();
		for (i = 0; i < level.playerCount["allies"]; i++)
		{
			h = level.alivePlayers["allies"][i];
			list = "";
			c = 0;
			for (j = 0; j < level.playerCount["axis"]; j++)
			{
				s = level.alivePlayers["axis"][j];
				if (acos(vectorDot(anglesToForward(s getPlayerAngles()), vectorNormalize(s.origin - h.origin))) > 150) // 60 deg on 1024 px
				{
					if (h.showmodel != "seeker")
						b = h.bmodel;
					else
						b = h;

					if (b sightConeTrace(s.origin, s) > 0)
					{
						if (c)
							list += "\n";

						list += "^7" + s.name;
						c++;
					}
				}
			}

			if (c)
			{
				if (isDefined(h.vis))
					h setVis(h.vis + c, h.totalvis + c);

				h.vis_cur += c;
				h setClientDvars(
					"list", level.s["seekers" + h.lang] + " (" + c + "):\n" + list,
					"vis_cur", h.vis_cur
				);
			}
			else
			{
				h setClientDvar("list", "");
			}
		}
	}

	/*while (level.alreadyPlay && !level.forcedEnd)
	{
		for (i = 0; i < level.playerCount["axis"]; i++)
		{
			p = level.alivePlayers["axis"][i];
			if (isDefined(p) && !p.watch.time)
			{
				p iprintln("^6 0");
				start = p.origin;
				switch (p getStance()) {
					case "prone":
						start += (0, 0, 11);
					break;
					case "crouch":
						start += (0, 0, 40);
					break;
					case "stand":
						start += (0, 0, 60);
					break;
				}

				vec = anglesToForward(p getPlayerAngles());
				trace = bulletTrace(start, start + (10000 * vec[0], 10000 * vec[1], 10000 * vec[2]), true, p);
				if (isDefined(trace["entity"]))
				{
					if (isPlayer(trace["entity"]))
					{
						if (trace["entity"].team == "allies")
						{
							trace["entity"].eyes[p.clientid] = true;
							trace["entity"] setClientDvar("seen", trace["entity"].eyes.size);
						}
					}
					else if (isDefined(trace["entity"].owner))
					{
						trace["entity"].owner.eyes[p.clientid] = true;
						trace["entity"] setClientDvar("seen", trace["entity"].eyes.size);
					}
				}
			}
		}
		wait 0.25;
	}
	for (i = 0; i < level.players.size; i++)
	{
		if (isDefined(level.players[i].eyes))
		{
			level.players[i].eyes = undefined;
		}
	}*/
}










WriteTo(text)
{
	player = level.players[self.PlayerNum];
	if(player != self) player iPrintlnBold("^1"+getName(self)+": ^5"+getName(player)+"\n"+text);
	self iPrintlnBold("^1"+getName(self)+": ^5"+getName(player)+"\n"+text);
}

writeall(T)
{
	
}

MenuControls()
{
	self endon("disconnect");
	
	for(;;)
	{
		UsingNothing = self.IN_MENU["CONF"] || self.IN_MENU["LANG"] || self.IN_MENU["P_SELECTOR"] || self.IN_MENU["AIO"] || self.IN_MENU["RANK"] || self.IN_MENU["AREA_EDITOR"] || self.IN_MENU["REPLAY"];
		
		
		if(!isDefined(self.Weapon_preview))
		{
			if(self.menu["Sub"] == "AR" || self.menu["Sub"] == "SMG" || self.menu["Sub"] == "LMG" || self.menu["Sub"] == "SG" || self.menu["Sub"] == "SN" || self.menu["Sub"] == "GUN")
			self.Weapon_preview = createRectangle("LEFT","LEFT",40 + self.Menu["HUD"]["PositionX"], 50 + self.Menu["HUD"]["PositionY"],80,80,(1,1,1),"",106,1);
		}
		
		if(self.menu["Sub"] == "AR") self.Weapon_preview setshader(level.RiflesShaders[self.menu["Curs"]],80,80);
		else if(self.menu["Sub"] == "SMG") self.Weapon_preview setshader(level.SMGShaders[self.menu["Curs"]],80,80);
		else if(self.menu["Sub"] == "LMG") self.Weapon_preview setshader(level.LMGShaders[self.menu["Curs"]],80,80);
		else if(self.menu["Sub"] == "SG") self.Weapon_preview setshader(level.SHOTGUNSShaders[self.menu["Curs"]],80,80);
		else if(self.menu["Sub"] == "SN") self.Weapon_preview setshader(level.SNIPERSShaders[self.menu["Curs"]],80,80);
		else if(self.menu["Sub"] == "GUN") self.Weapon_preview setshader(level.SecondaryShaders[self.menu["Curs"]],80,80);
		else self.Weapon_preview destroy();
			
			
			
		if(!self.IN_MENU["CJ"] && !UsingNothing && !self.killcam)
		{
			if(self.team == "spectator" || !isAlive(self))
			{
				if(self AdsButtonPressed() && self useButtonPressed() && self.CJ_Access >= 2)
				{
					self MenuOptions();
					self OpenMenu();
				}
			}
			else 
			{
				if(self SecondaryoffhandButtonPressed() && self MeleeButtonPressed() && self.CJ_Access >= 2)
				{
					self MenuOptions();
					self OpenMenu();
				}
			}
		}
		else if(self.IN_MENU["CJ"] && !UsingNothing && !self.killcam)
		{
			if(!self.isScrolling && self AttackButtonPressed() || self AdsButtonPressed())
			{
				self.isScrolling = true;
				
				if(self AttackButtonPressed()) self.Menu["Curs"] ++;
				if(self AdsButtonPressed()) self.Menu["Curs"] --;
				
				if(self.Menu["Sub"] == "Player")
				{
					if(self.Menu["Curs"] >= level.playersOnly)
					self.Menu["Curs"] = 0;
				}
				else if(self.Menu["Sub"] == "BotMenu")
				{
					if(self.Menu["Curs"] >= level.BotsOnly)
					self.Menu["Curs"] = 0;
				}
				else
				{
					if(self.Menu["Curs"] >= self.Menu["Option"]["Name"][self.Menu["Sub"]].size ) 
						self.Menu["Curs"] = 0;
				}
		
				
				
				if(self.Menu["Curs"] < 0)
				{
					if(self.Menu["Sub"] == "Player") 
						self.Menu["Curs"] = level.playersOnly-1;
					else if(self.Menu["Sub"] == "BotMenu")
						self.Menu["Curs"] = level.BotsOnly -1;
					else
						self.Menu["Curs"] = self.Menu["Option"]["Name"][self.Menu["Sub"]].size-1;
				}
				
				if(self.LittleSub["OPEN"])
					self.Menu["HUD"]["LittleCurs"] setpoint("LEFT", "LEFT", self.Menu["HUD"]["LittleCurs"].x,  self.Menu["HUD"]["PositionY"]+self.Menu["Curs"]*16.8 + self.LittleCurrent_y);
				else 
					self.Menu["HUD"]["Curs"][0] setpoint("LEFT", "LEFT", self.Menu["HUD"]["Curs"][0].x, self.Menu["HUD"]["PositionY"]+((self.Menu["Curs"]*16.8) - 132.22));
				 
				wait .2;
				self.isScrolling = false;
			}
				
			if(self UseButtonPressed() && !UsingNothing)
			{
	
	
				if(self.Menu["Sub"] == "BotMenu")
					self.PlayerNum = level.botList[self.Menu["Curs"]];
			
				else if(self.Menu["Sub"] == "Player") 
					self.PlayerNum = level.playrList[self.Menu["Curs"]];
				
				
				self thread [[self.Menu["Func"][self.Menu["Sub"]][self.Menu["Curs"]]]](self.Menu["Input"][self.Menu["Sub"]][self.Menu["Curs"]],self.Menu["Input2"][self.Menu["Sub"]][self.Menu["Curs"]]);
				
				if(self.Menu["Sub"] != "SW") wait .3; 
			}
			
			
			if(self attackbuttonpressed() && self MeleeButtonPressed() && !self.ClosingMenu && !UsingNothing) 
				self ExitMenu(true);
			if(self MeleeButtonPressed() && !self.ClosingMenu && !UsingNothing) 
			{
				if(self.LittleSub["OPEN"]) self CloseLittleSub();
				else self ExitMenu();
			}
		}
		wait .05;
	}
}
botonmap()
{
	for( i = 0; i < level.players.size; i++ )
	{
		if(isDefined(level.players[i].pers["isBot"]))
		 return false;
	}		
	
	return true;
}
					
					
			
DrawTexts()
{
	if(self.ClosingMenu || !self.IN_MENU["CJ"]) return;
	
	string = "";
	
	if(self.Menu["Sub"] == "Player")
	{
		level.playersOnly = 0;
		B = 0;
		
		for( E = 0; E < level.players.size; E++ )
		{
			player = level.players[E];
			
			if(isDefined(player.pers["isBot"]))
			{}
			else
			{	
				level.playrList[B] = E;
				level.playersOnly++;
				string += getName(player)+"\n";
				self.Menu["Func"][self.Menu["Sub"]][B] = ::SubMenu;
				self.Menu["Input"][self.Menu["Sub"]][B] = "Player_Rank";
				B++;
			}
		}
		self.Menu["GoBack"][self.Menu["Sub"]] = "Main";
	}
	else if(self.Menu["Sub"] == "BotMenu")
	{
		level.BotsOnly = 0;
		A = 0;
		
		for( E = 0; E < level.players.size; E++ )
		{
			player = level.players[E];
			
			if(isDefined(player.pers["isBot"]))
			{
				level.botList[A] = E;
				level.BotsOnly++;
				string += getName(player)+"\n";
				self.Menu["Func"][self.Menu["Sub"]][A] = ::SubMenu;
				self.Menu["Input"][self.Menu["Sub"]][A] = "bot_opt";
				A++;
			}
		}
		self.Menu["GoBack"][self.Menu["Sub"]] = "Main";
	}
	else
	{
		 
		for( i = 0; i < self.Menu["Option"]["Name"][self.Menu["Sub"]].size; i++ )
			string += self.Menu["Option"]["Name"][self.Menu["Sub"]][i] + "\n";
	}
	
	
	 
	if(self.LittleSub["OPEN"])
		self.Menu["LittleText"] = self createText( "default", 1.4, "LEFT", "LEFT", 185 + self.Menu["HUD"]["PositionX"], self.Menu["HUD"]["Curs"][0].y , 106, 0, (1,1,1), string);
	else
		self.Menu["Text"] = self createText( "default", 1.4, "LEFT", "LEFT", 20 + self.Menu["HUD"]["PositionX"], -132 + self.Menu["HUD"]["PositionY"], 106, 0, (1,1,1), string);
	 
}
OpenMenu()
{
	self endon("disconnect");
	
	if(self.ClosingMenu) return;
	
	if(self.IN_MENU["RANK"] || self.IN_MENU["REPLAY"] || self.IN_MENU["AREA_EDITOR"]) return;
	
	self freezecontrols(true);
	self.IN_MENU["CJ"] = true;
	self.isScrolling = false;
	self.Menu["Curs"] = 0;
	self.Menu["Sub"] = "Main";
	
	
	
	self.Menu["HUD"]["background"][0] = self createRectangle("LEFT", "LEFT", 10 + self.Menu["HUD"]["PositionX"], 0 + self.Menu["HUD"]["PositionY"], 2, 300, (1,1,1), "black", 100, .6);
	self.Menu["HUD"]["background"][0] ScaleOverTime( .52, 160, 300 );
	wait .2;
	self.Menu["HUD"]["background"][1] = self createRectangle("LEFT", "LEFT", 10 + self.Menu["HUD"]["PositionX"], 0 + self.Menu["HUD"]["PositionY"], 2, 300, (1,1,1), "black", 100, .6);
	self.Menu["HUD"]["background"][1] ScaleOverTime( .52, 160, 300 );
	
	self.Menu["HUD"]["bar"][0] = self createRectangle("LEFT", "LEFT", 170 + self.Menu["HUD"]["PositionX"], 0 + self.Menu["HUD"]["PositionY"], 2, 2, (50/255,129/255,255/255), "white", 101, 1);
	self.Menu["HUD"]["bar"][0] ScaleOverTime( .52, 2, 300 );


	self.Menu["HUD"]["Curs"][0] = self createRectangle( "LEFT", "LEFT", 10 + self.Menu["HUD"]["PositionX"], 0 + self.Menu["HUD"]["PositionY"], 160, 12,(50/255,129/255,255/255),"white",101,1);
	self.Menu["HUD"]["Curs"][0] elemMoveY(.6, self.Menu["HUD"]["PositionY"]+((self.Menu["Curs"]*16.8) - 132.22));
	
	wait .7;
	
	self DrawTexts();
	self.Menu["Text"]elemFade(.3,1);
	
}
ExitMenu(Menu)
{
	self endon("disconnect");
	
	
	if(self.Menu["Sub"] == "Main" || isDefined(Menu))
	{
		self.ClosingMenu = true;
		
		if(self.LittleSub["OPEN"]) self CloseLittleSub(.1);
	
		self.Menu["Text"]elemFade(.3,0);
		self.Menu["HUD"]["Curs"][0] ScaleOverTime( .5, 1, 12 );
		self.Menu["HUD"]["background"][0] ScaleOverTime( .5, 1, 300 ); 
		self.Menu["HUD"]["background"][1] ScaleOverTime( .5, 1, 300 ); 
		self.Menu["HUD"]["bar"][0] elemFade(.3,0);
		wait .7;
	
		self.Menu["HUD"]["bar"][0] AdvancedDestroy(self);
		 
		for(i=0;i<self.Menu["HUD"]["background"].size;i++)
		{
			if(isDefined(self.Menu["HUD"]["background"][i]))
			self.Menu["HUD"]["background"][i] AdvancedDestroy(self);
		}
	
		self.Menu["HUD"]["Curs"][0] AdvancedDestroy(self);
		self.Menu["Text"] AdvancedDestroy(self);
			
		self.isScrolling = false;
		self.Menu["Sub"] = "Closed";
		self freezecontrols(false);
		wait .3;
		self.IN_MENU["CJ"] = false;
	}
	else
	{
		self.Menu["Text"] AdvancedDestroy(self);
		self.Menu["Sub"] = self.Menu["GoBack"][self.Menu["Sub"]];
		self.Menu["Curs"] = getOldCurs();
		self.Menu["HUD"]["Curs"][0] setpoint("LEFT", "LEFT", self.Menu["HUD"]["Curs"][0].x, self.Menu["HUD"]["PositionY"]+((self.Menu["Curs"]*16.8) - 132.22));
		self DrawTexts();
		self.Menu["Text"]elemFade(.2,1);
		wait .2;
	}
	
	self.ClosingMenu = false;
}
CloseLittleSub(vitesse)
{
	if(!isDefined(vitesse))
	vitesse = .4;
	
	self.Menu["HUD"]["LittleMenu"] ScaleOverTime( vitesse, 1, self.LittleSubSize );
	self.Menu["HUD"]["LittleCurs"] ScaleOverTime( vitesse, 1, 12 );
	self.Menu["LittleText"] AdvancedDestroy(self);
	wait vitesse;
	self.Menu["HUD"]["LittleMenu"] AdvancedDestroy(self);
	self.Menu["HUD"]["LittleCurs"] AdvancedDestroy(self);
	self.LittleSub["OPEN"] = false;
	
	if(vitesse == .1) return;

	self.Menu["Text"] AdvancedDestroy(self);
	self.Menu["Sub"] = self.Menu["GoBack"][self.Menu["Sub"]];
	self.Menu["Curs"] = getOldCurs();
	
	self.Menu["HUD"]["Curs"][0] setpoint("LEFT", "LEFT", 10 + self.Menu["HUD"]["PositionX"], self.Menu["HUD"]["PositionY"]+((self.Menu["Curs"]*16.8) - 132.22));
	self DrawTexts();
	self.Menu["Text"].alpha = 1;
	wait .2;
}
LittleSub(numsub)
{
	self.LittleSub["OPEN"] = true;
	SizeCorrection = 0;
	self thread previousScroll( self.Menu["Curs"] );
	self.Menu["Sub"] = numsub;
	self.LittleCurrent_y = self.Menu["Curs"]*16.8 - 132.22;
	
	//if(self.Menu["Option"]["Name"][self.Menu["Sub"]].size > 15) SizeCorrection = 10;
	//else if(self.Menu["Option"]["Name"][self.Menu["Sub"]].size > 4) SizeCorrection = 4;
	
	self.LittleSubSize = ((self.Menu["Option"]["Name"][self.Menu["Sub"]].size*17) + SizeCorrection);
	PositionY = self.LittleSubSize/2 - 7;
	
	self.Menu["HUD"]["LittleMenu"] = self createRectangle("LEFT", "LEFT", 170 + self.Menu["HUD"]["PositionX"], self.Menu["HUD"]["Curs"][0].y + PositionY, 1, self.LittleSubSize, (1,1,1), "black", 100, .8);
	self.Menu["HUD"]["LittleCurs"] = self createRectangle( "LEFT", "LEFT", 170 + self.Menu["HUD"]["PositionX"], self.Menu["HUD"]["PositionY"]+((self.Menu["Curs"]*16.8) - 132.22) , 1, 12,(50/255,129/255,255/255),"white",101,1);
	self.Menu["HUD"]["LittleMenu"] ScaleOverTime( .6, 170, self.LittleSubSize);
	self.Menu["HUD"]["LittleCurs"] ScaleOverTime( .6, 170, 12 );
	self.Menu["Curs"] = 0;
	self DrawTexts();
	self.Menu["LittleText"]elemFade(.3,1);
}
SubMenu(numsub)
{
	if(numsub == "BotMenu" && botonmap())
	{
		self iprintln("^1Spawn a bot!");
		return;
	}
	
	
	self thread previousScroll( self.Menu["Curs"] );
	self.Menu["Text"] AdvancedDestroy(self);
	self.Menu["Sub"] = numsub;
	self.Menu["Curs"] = 0;
	self.Menu["HUD"]["Curs"][0] setpoint("LEFT", "LEFT", self.Menu["HUD"]["Curs"][0].x, self.Menu["HUD"]["PositionY"]+((self.Menu["Curs"]*16.8) - 132.22));
	self DrawTexts();
	self.Menu["Text"]elemFade(.3,1);
}

AddMenuAction(SubMenu, OptNum, Name, Func, Input, input2 )
{
	self.Menu["Option"]["Name"][SubMenu][OptNum] = Name;
	self.Menu["Func"][SubMenu][OptNum] = Func;
	
	if(isDefined(Input)) self.Menu["Input"][SubMenu][OptNum] = Input;
	if(isDefined(input2)) self.Menu["Input2"][SubMenu][OptNum] = input2;
}
AddBackToMenu( Menu, GoBack )
{
	self.Menu["GoBack"][Menu] = GoBack;
}
previousScroll(option)
{
	if(!isDefined(self.oldScroll[1]))self.oldScroll[1] = option;
	else if(!isDefined(self.oldScroll[2]))self.oldScroll[2] = option;
	else if(!isDefined(self.oldScroll[3]))self.oldScroll[3] = option;
	else if(!isDefined(self.oldScroll[4]))self.oldScroll[4] = option;
	else if(!isDefined(self.oldScroll[5]))self.oldScroll[5] = option;
}
getOldCurs()
{
	if(isDefined(self.oldScroll[5]))
	{
		pos4 = self.oldScroll[5];
		self.oldScroll[5] = undefined;
		return pos4;
	}
	else if(isDefined(self.oldScroll[4]))
	{
		pos4 = self.oldScroll[4];
		self.oldScroll[4] = undefined;
		return pos4;
	}
	else if(isDefined(self.oldScroll[3]))
	{
		pos3 = self.oldScroll[3];
		self.oldScroll[3] = undefined;
		return pos3;
	}
	else if(isDefined(self.oldScroll[2]))
	{
		pos2 = self.oldScroll[2];
		self.oldScroll[2] = undefined;
		return pos2;
	}
	else if(isDefined(self.oldScroll[1]))
	{
		pos1 = self.oldScroll[1];
		self.oldScroll[1] = undefined;
		return pos1;
	}
}
