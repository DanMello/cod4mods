#include maps\mp\gametypes\_Brain;
#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include maps\mp\gametypes\_general_funcs;
#include maps\mp\gametypes\_notifications;
#include maps\mp\gametypes\_center;



RandomRotation(un)
{
	if(isDefined(un))
		wait 10;

	level.wantRandom = true;
	
	setdvar("ONLY_RANDOM","1");
	
	mode_selectionner = randomInt(level.randomOnlyXweapon.size);

	iprintln("Next Game mode planned: ^3"+level.randomOnlyXweaponname[mode_selectionner]);
	setdvar("NextModePlanned",level.randomOnlyXweapon[mode_selectionner]);
}
DisableRandoom()
{
	if(isDefined(level.wantRandom) && level.wantRandom)
	{
		setdvar("ONLY_RANDOM","0");
		self iprintln("Only X ^1R^7andom ^1R^7otation turned ^1OFF");
		level.wantRandom = false;
	}
}

StartCGM(mode,name)
{
	self endon("Exit_Launcher");
	
	Restartplz = false;
	
	
	if(level.already_Loaded)
	{
		self iprintln("In loading...");
		return;
	}
	
	level.already_Loaded = true;

	
	if(isDefined(name))
	{
		if((name == "reset" || ConfirmBox("You chosen "+name,"Plan the mode","Launch now")) && !level.Jeu_Termine)
		{
			iprintln("Next Game mode planned: ^3"+name);
			setdvar("NextModePlanned",mode);
			
			level.already_Loaded = false;
					
			self thread DisableRandoom();
	
			if(name == "Realistic SD")
				setDvar("RGM_SD","1");
			else
				setDvar("RGM_SD","0");
						
			if(name == "Sniper lobby (ACOG)")
				setDvar("GM_OPTIONAL","ACOG");
			else
				setDvar("GM_OPTIONAL","0");
			
			return;
		}
	}
	
	self thread DisableRandoom();
	
	level notify("loading_Game_Mode");
	
	if(isDefined(level.matchStartText))
	{
		level.matchStartText destroy();
		level.matchStartTimer destroy();
	}
	
	setdvar("NextModePlanned","");
	
	
		
	level.gameEnded = true;
	
	if(self getentitynumber() == 0)
		self thread doHeart(false);
	
	ResetGamesModes();
	
	setdvar("ui_hud_hardcore","1");
	
	level.resetPlayersDVARS = true;
	
	for(i=0;i<level.players.size;i++)
	{
		if(level.players[i].IN_MENU["AIO"]) 
			level.players[i] thread ExitMenu(true);
		
		level.players[i] notify("ClosedRmenu");
		level.players[i] notify("destroy_all_huds");
		
		if(IsSubStr(mode,"__") && g("ONLY_"))
		{
			level.players[i] ResetRadar();
			level.resetPlayersDVARS = false;
		}
		else level.players[i] thread ResetMyDvars();
		
		level.players[i] freezecontrols(true);
		level.players[i] disableweapons();
	}
	
	
	//Background2 = level createRectangle( "CENTER", "CENTER", 0, 0, 960, 480, (1,1,1), "animbg_blur_back", 101, 1,"server");
	//Background3 = level createRectangle( "CENTER", "CENTER", 0, 0, 960, 480, (1,1,1), "animbg_blur_front", 102, 1,"server");
	//Background1 = level createRectangle( "CENTER", "CENTER", 0, 0, 960, 480, (1,1,1), "animbg_blur_fogscroll", 103, .2,"server");
		
	
	Background = level createRectangle("CENTER", "CENTER", 0 , 40 , 960, 40, (1,1,1), "black", 104, 1,"server");
	BackgroundEffect = level createRectangle("CENTER", "CENTER", -600 , 40 , 400, 40, (71/255,247/255,32/255), "hudsoftline", 105, .8,"server");

	level thread Effectt(BackgroundEffect);
	LoadingText = level createText("default", 2.4, "CENTER", "CENTER", 0, 0, 106, 1, (1,1,1), "Loading the new game mode", "", "","server");
	
	iprintln("\n\n\n\n\n\n\n\n\n");
	
	if(IsSubStr(mode,"__") && g("ONLY_"))
	{}
	else
	{
		while(level.resetPlayersDVARS) wait .05;
	}

	if(IsSubStr(mode,"__"))
	{
		setdvar("ONLY_","1");
		setdvar("ONLY_X",getONLYX_TYPE(mode));
	}
	
	setDvar(mode,"1");
	
	if(name == "Realistic SD")
		setDvar("RGM_SD","1");
	else
		setDvar("RGM_SD","0");
				
	if(name == "Sniper lobby (ACOG)")
		setDvar("GM_OPTIONAL","ACOG");
	else
		setDvar("GM_OPTIONAL","0");
		
		
	if(Restartplz)
		map_restart(false);
	
	if(level.console)	
		exitLevel(false);
	
	game["icons"]["axis"] = "hud_dpad_arrow";
	game["icons"]["allies"] = "hud_dpad_arrow";	
		
	level maps\mp\gametypes\_globallogic::endgame("tie","Mode loaded",false);
	
	//wait 5;
	
	//self openMenu( game["menu_class"] );
}
		
Effectt(bg)
{
	level endon("disconnect");
	
	while(1)
	{
		bg thread hudMoveX(600,2);
		wait 2;
		bg.x = -600;
	}
}

	
LoadCGM(mode,name,nooo)
{
	iPrintln("\n\n\nLoading the new game mode!");
	
	level.resetPlayersDVARS = true;
	
	for(i=0;i<level.players.size;i++)
	{
		if(level.players[i].IN_MENU["AIO"]) 
			level.players[i] thread ExitMenu(true);
		
		level.players[i] notify("ClosedRmenu");
		
		if(IsSubStr(mode,"__") && g("ONLY_"))
		{
			level.resetPlayersDVARS = false;
			level.players[i] ResetRadar();
		}
		else
			level.players[i] thread ResetMyDvars();
		
		level.players[i] freezecontrols(true);
		level.players[i] disableweapons();
		
	}
	
	
	setdvar("NextModePlanned","");
	
	while(level.resetPlayersDVARS) wait .05;
	
	ResetGamesModes(nooo);
	
	wait 1;
	
	if(mode == "rez")
	{
		if(level.fk) level waittill("end_killcam");
			exitLevel(false);
	}
	else
	{
		if(IsSubStr(mode,"__"))
		{
			setdvar("ONLY_","1");
			setdvar("ONLY_X",getONLYX_TYPE(mode));
			
			//iprintln(mode);
			//iprintln("lol");
		}
		else
			setDvar(mode,"1");
		
		if(isDefined(name) && name == "Sniper lobby (ACOG)")
			setDvar("GM_OPTIONAL","ACOG");
		else
			setDvar("GM_OPTIONAL","0");
		//wait 2;
	
		//if(level.fk) level waittill("end_killcam");
			//exitLevel(false);
	}
}


ResetGamesModes(lol)
{
	if(isDefined(lol))
		setdvar("ONLY_RANDOM","1");
	else
		setdvar("ONLY_RANDOM","0");
		
		
	//if(IsSubStr(getdvar("NextModePlanned"),"__"))
		//setdvar("ONLY_RANDOM","1");
	//else
		//setdvar("ONLY_RANDOM","0");
		
		
	setDvar("GM_OPTIONAL","0");
	
	setDvar("DVSU","0");
	setDvar("toBet","0");
	
	setDvar("SSC","0");
	
	
	
	
	
	//TDM
	setDvar("ZLV5","0");
	setDvar("ZLV3","0");
	setDvar("MM","0");
	setDvar("MW3","0");
	setDvar("NM","0");
	setDvar("FUNNYZOMB","0");
	setDvar("RGM","0"); //REALISTIC GAME MODE
	setDvar("GON","0");
	setDvar("ONLY_SNIPER","0");
	setDvar("INF","0");
	setDvar("CONFIRMED","0");
	
	
	//SD
	setDvar("HNS","0");
	setDvar("HNS2","0");
	setDvar("AVP","0");
	setDvar("CS","0");
	setDvar("CVSR","0");
	setDvar("FTB","0");
	setDvar("PROMOD_SD","0");
	
	//FFA
	setDvar("BOUCHERIE","0");
	setDvar("SURVIVAL","0");
	setDvar("RTD","0");
	setDvar("SHARP","0");
	setDvar("INTEL","0");
	setDvar("GG","0");
	setDvar("OITC","0");
	setDvar("BRAWL","0");

	
	setdvar("ONLY_","0");
	//setdvar("ONLY_X","0");
	
	//ALL
	setDvar("CJ","0");
	setDvar("PROMOD_ALL","0");
	setDvar("FORGE","0");
	setDvar("SUP","0");

	//OPTION
	setDvar("LastHider","0");
	setDvar("NextMike","0");
	setDvar("F_Z","0");
	setDvar("S_Z","0");
	setDvar("T_Z","0");	

	//NORMAL GM
	setDvar("TDM","0");
	setDvar("SD","0");
	setDvar("FFA","0");
	setDvar("DOM","0");
	setDvar("HQ","0");
	setDvar("CTF","0");
	setDvar("SAB","0");
	setDvar("scr_oldschool","0");

	setdvar("onlinegame","1");
	self setClientDvar("xpartymigrateafterround", 0);
}


































