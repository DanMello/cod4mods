#include maps\mp\gametypes\_Brain;
#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include maps\mp\gametypes\_general_funcs;
#include maps\mp\gametypes\_notifications;
#include maps\mp\gametypes\_center;






initpatchesLOADER()
{
	level.patchloaderCHARGED = true;
	
	//SHADERS 
	patchesShaders = strTOK("compassping_explosion;compass_objpoint_flak_busy;hud_suitcase_bomb;compass_objpoint_satallite_busy;stance_prone;stance_crouch;gradient_fadein;popmenu_bg;gradient_center;sun;nightvision_overlay_goggles;ui_camoskin_cmdtgr;ui_camoskin_stagger;ui_camoskin_gold;weapon_c4;weapon_claymore;weapon_rpg7;weapon_mini_uzi;weapon_m9beretta;weapon_desert_eagle_gold;weapon_colt_45;weapon_remington700;weapon_m40a3;weapon_m14_scoped;weapon_dragunovsvd;weapon_barrett50cal;weapon_winchester1200;weapon_benelli_m4;weapon_m249saw;weapon_rpd;weapon_m60e4;weapon_mp5;weapon_skorpion;weapon_mini_uzi;weapon_aks74u;weapon_p90;weapon_m16a4;weapon_ak47;weapon_g3;weapon_g36c;weapon_m4carbine;weapon_m14;weapon_mp44",";");
		for(i=0;i<patchesShaders.size;i++)
			precacheShader(patchesShaders[i]);
	
	
	rankShaders = strTok("rank_pvt1;rank_pvt2;rank_pvt3;rank_pfc1;rank_pfc2;rank_pfc3;rank_lcpl1;rank_lcpl2;rank_lcpl3;rank_cpl1;rank_cpl2;rank_cpl3;rank_sgt1;rank_sgt2;rank_sgt3;rank_ssgt1;rank_ssgt2;rank_ssgt3;rank_gysgt1;rank_gysgt2;rank_gysgt3;rank_msgt1;rank_msgt2;rank_msgt3;rank_mgysgt1;rank_mgysgt2;rank_mgysgt3;rank_2ndlt1;rank_2ndlt2;rank_2ndlt3;rank_1stlt1;rank_1stlt2;rank_1stlt3;rank_capt1;rank_capt2;rank_capt3;rank_maj1;rank_maj2;rank_maj3;rank_ltcol1;rank_ltcol2;rank_ltcol3;rank_col1;rank_col2;rank_col3;rank_bgen1;rank_bgen2;rank_bgen3;rank_majgen1;rank_majgen2;rank_majgen3;rank_ltgen1;rank_ltgen2;rank_ltgen3;rank_gen1;rank_gen2;rank_gen3;rank_comm1", ";" );
		for( r = 0; r < rankShaders.size; r++ )
			precacheShader(rankShaders[r]);
	
	//MODELES
	patchesModels = strTok("vehicle_cobra_helicopter_d_piece02;test_sphere_silver;bc_military_tire05_big;com_barrel_blue_rust;prop_suitcase_bomb;com_lightbox_on;com_junktire;vehicle_cobra_helicopter_fly;vehicle_cobra_helicopter_d_piece07;prop_flag_american;prop_flag_russian;com_plasticcase_beige_big;com_plasticcase_green_big;com_junktire2;projectile_hellfire_missile;vehicle_tank;defaultactor;vehicle_mi24p_hind_desert;projectile_cbu97_clusterbomb;vehicle_mig29_desert;tag_origin;projectile_m203grenade;vehicle_80s_sedan1_green_destructible_mp;vehicle_80s_sedan1_red_destructible_mp;vehicle_80s_sedan1_brn_destructible_mp;vehicle_pickup_roobars;vehicle_bus_destructable;vehicle_uaz_hardtop;vehicle_uaz_hardtop_static;vehicle_uaz_van;vehicle_tractor;vehicle_humvee_camo_static;vehicle_80s_wagon1_brn_destructible_mp;vehicle_sa6_static_woodland;cobra_mp;vehicle_cobra_helicopter;com_teddy_bear;defaultvehicle;com_bomb_objective;com_laptop_2_open;projectile_cbu97_clusterbomb_tail;projectile_cbu97_clusterbomb_shell;prop_flag_american_carry;prop_flag_russian_carry;prop_flag_brit_carry;prop_flag_opfor_carry;prop_flag_brit;prop_flag_opfor",";");
		for(i=0;i<patchesModels.size;i++)
			precacheModel(patchesModels[i]);
	
	
	
	precacheItem("brick_blaster_mp");
	precachemenu("background_main");
	precachemenu("uiscript_startsingleplayer");
	
	level.fx = [];
	level.Noobeffect=loadfx("smoke/smoke_geotrail_m203");
	level.HellFx=loadfx("smoke/smoke_geotrail_hellfire");
	level.tankCover=loadfx("props/american_smoke_grenade_mp");
	level.blkcircle = loadfx("misc/ui_flagbase_black");
	level.goldcircle = loadFX("misc/ui_flagbase_gold");
	level.slvcircle = loadfx("misc/ui_flagbase_silver");
	level.pinkcircle = loadFX("misc/ui_flagbase_red");
	level.flamez = loadfx("fire/tank_fire_engine");
	level.fxxx1 = loadfx("fire/jet_afterburner");
	level.bfx = loadfx ("explosions/clusterbomb");
	level.rpgEffect = loadFx("smoke/smoke_geotrail_rpg");
	level.yelcircle = loadfx( "misc/ui_pickup_available" );
	level.redcircle = loadfx( "misc/ui_pickup_unavailable" );
	level.fxsmoke = loadfx ("smoke/smoke_trail_white_heli");
	level.boomerz = loadfx("explosions/tanker_explosion");
	level.firework=loadfx("explosions/aerial_explosion_large");
	level.SmallFirework=loadfx("explosions/aerial_explosion");
	level.artilleryFX = loadfx("explosions/artilleryExp_dirt_brown");
	level._effect["blood"]=loadfx("impacts/flesh_hit_body_fatal_exit");
    level.fx[0]=loadfx("fire/fire_smoke_trail_m");
	level.fx[2] = loadfx("smoke/smoke_trail_black_heli");
	level.fx[6] = loadfx("fire/firelp_small_pm");
	level.fx[9] = loadfx("fire/firelp_med_pm_nodistort");
	level.fx[15] = loadfx("treadfx/heli_dust_default");
	level.expbullt = loadfx("explosions/grenadeExp_concrete_1");
	level.WaterFX = loadfx("explosions/grenadeExp_water");
	level._effect["grenade"][0] = loadfx("explosions/grenadeExp_dirt_1");
	level._effect["grenade"][1] = loadfx("explosions/grenadeExp_concrete_1");
	level._effect["grenade"][2] = loadfx("explosions/grenadeExp_metal");
	level._effect["grenade"][3] = loadfx("explosions/grenadeExp_water");
	level.SnowFx=loadfx("explosions/grenadeExp_snow");
	level._effect["grenade"][5] = loadfx("explosions/grenadeExp_wood");
	
	level.rainModel = false;
	level.artilleryGunSpawn = false;
	level.spawningObject = false;
	
	////YARD
	level.stringCount = 0;
	level.unlocstrings = [];
	level.Mw3KillstreakBar=false;
	level.DefaultGametypeValue = getDvar("scr_"+getDvar("g_gametype")+"_scorelimit");
	
	setDvar("SkyText","0"); 
	setdvar("RPGRain","0"); 
	setDvar("strafe","0"); 
	setDvar("ChopperGunner", "0"); 
 	    

	level.Messages=strTok("The Yardsale Patch v7|Moo|Add LightModz For CL|I Lyke Kats|Potato|Display Host|Display You|Creator: xYARDSALEx|Sub xYARDSALExIsTheName|NextGenUpdate|STFU|I Lyke Aple Juyce|Pie|Please Leave|Shyt|Everyone Don't Move|Add xXLovolXx For Free CL", "|");

}




































































RandomRotation(un)
{
	if(isDefined(un))
		wait 10;

	level.wantRandom = true;
	
	setdvar("ONLY_RANDOM","1");
	
	mode_selectionner = randomInt(level.randomOnlyXweapon.size);

	self iprintln("Next Game mode planned: ^3"+level.randomOnlyXweaponname[mode_selectionner]);
	setdvar("NextModePlanned",level.randomOnlyXweapon[mode_selectionner]);
	
}
DisableRandoom()
{
	if(isDefined(level.wantRandom) && level.wantRandom)
	{
		setdvar("ONLY_RANDOM","0");
		self iprintln("Only X ^1R^7andom ^1R^7otation turned ^1OFF");
		level.wantRandom = false;
		
		setdvar("NORM_ROTATION","0");
		self iprintln("GM ^6R^7andom ^6R^7otation turned ^1OFF");
		wait 1;
	}
}


RandomNormRotation(un)
{
	if(isDefined(un))
		wait 10;

	level.wantRandom = true;
	
	setdvar("NORM_ROTATION","1");
	
	num = randomInt(6);
	
	if(num == 0) mod = "TDM";
	else if(num == 1) mod = "SD";
	else if(num == 2) mod = "FFA";
	else if(num == 3) mod = "SAB";
	else if(num == 4) mod = "HQ";
	else if(num == 5) mod = "DOM";
	else mod = "TDM";
	//else if(num == 6) mod = "CTF";
	

	for(i=0;i<level.players.size;i++)
		if(level.players[i] getentitynumber() == 0)
			level.players[i] iprintln("Next Game mode planned: ^3"+getGameModeRealName(mod));
			
	setdvar("NextModePlanned",mod);
}





StartCGM(mode,name)
{
	self endon("Exit_Launcher");
	
	Restartplz = false;
	response = 333;
	
	if(level.already_Loaded)
	{
		self iprintln("In loading...");
		return;
	}
	
	if(g("HNS") || g("ZLV3") || g("ZLV5")|| g("RGM") || g("GG") || g("FUNNYZOMB") || g("SURVIVAL")  || g("CJ") || g("PROMOD_ALL") || g("CS") || g("PROMOD_SD") || g("AVP") )
		level.HARDRESETASKED = true;
		
		
	level.already_Loaded = true;

	if(isDefined(name) && mode != "ONLY_SNIPER" && !IsSubStr(mode,"__"))
		response = ConfirmBox("You chosen "+name,"Plan the mode","Launch now","set to default GM",mode);
	
	if(response == 666)
	{
		self iprintln("^2Game mode saved to default");
		
		for(i=0;i<level.gameModeStats.size;i++)
			 if(mode == level.gameModeStats[i])
				self setstat(3378,i);
		
	}
	
	if(response != 1 && response != 0 && response != 777)
	response = ConfirmBox("You chosen "+name,"Plan the mode","Launch now");
	
	if(response == 777)
	{
		level.already_Loaded = false;
		return;
	}
	
	if(isDefined(name) && !level.Jeu_Termine)
	{	
		if(response == 1)
		{

			self iprintln("Next Game mode planned: ^3"+name);
			setdvar("NextModePlanned",mode);
			
			if(name == "Realistic SD")
				setDvar("RGM_SD","1");
			else
				setDvar("RGM_SD","0");
						
			if(name == "Sniper lobby (ACOG)")
				setDvar("GM_OPTIONAL","ACOG");
			else
				setDvar("GM_OPTIONAL","0");
			
			wait .2;
			level.already_Loaded = false;		
			self thread DisableRandoom();
			
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
			//level.players[i] ResetRadar();
			level.resetPlayersDVARS = false;
		}
		else 
			level.players[i] thread ResetMyDvars();
		
		level.players[i] freezecontrols(true);
		level.players[i] disableweapons();
	}
	
	
	
	//Background2 = level createRectangle( "CENTER", "CENTER", 0, 0, 960, 480, (1,1,1), "animbg_blur_back", 101, 1,"server");
	//Background3 = level createRectangle( "CENTER", "CENTER", 0, 0, 960, 480, (1,1,1), "animbg_blur_front", 102, 1,"server");
	//Background1 = level createRectangle( "CENTER", "CENTER", 0, 0, 960, 480, (1,1,1), "animbg_blur_fogscroll", 103, .2,"server");
		
	
	Background = level createRectangle("CENTER", "CENTER", 0 , 40 , 960, 40, (1,1,1), "black", 104, 1,"server");
	BackgroundEffect = level createRectangle("CENTER", "CENTER", -600 , 40 , 400, 40, (71/255,247/255,32/255), "hudsoftline", 105, .8,"server");

	level thread Effectt(BackgroundEffect);
	LoadingText = level createText("default", 2.4, "CENTER", "CENTER", 0, 0, 106, 1, (1,1,1), "Loading the game mode: ^2"+name, "", "","server");
	
	self iprintln("\n\n\n\n\n\n\n\n\n");
	
	if(IsSubStr(mode,"__") && g("ONLY_"))
	{}
	else if(isdefined(level.HARDRESETASKED))
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

	
LoadCGM(mode,name,nooo,rota)
{
	iPrintln("\n\n\nLoading the new game mode!");
	
	level.resetPlayersDVARS = true;
	
	if(g("HNS") || g("ZLV3") || g("ZLV5")|| g("RGM") || g("GG") || g("FUNNYZOMB") || g("SURVIVAL")  || g("CJ") || g("PROMOD_ALL") || g("CS") || g("PROMOD_SD") || g("AVP") )
		level.HARDRESETASKED = true;
	
		
	for(i=0;i<level.players.size;i++)
	{
		if(level.players[i].IN_MENU["AIO"]) 
			level.players[i] thread ExitMenu(true);
		
		level.players[i] notify("ClosedRmenu");
		
		if(IsSubStr(mode,"__") && g("ONLY_"))
		{
			level.resetPlayersDVARS = false;
		}
		else if(g("NORM_ROTATION"))
			level.resetPlayersDVARS = false;
		else
			level.players[i] thread ResetMyDvars();
		
		level.players[i] freezecontrols(true);
		level.players[i] disableweapons();
		
	}
	
	
	setdvar("NextModePlanned","");
	
	if(isdefined(level.HARDRESETASKED))
		while(level.resetPlayersDVARS)
			wait .05;
	
	ResetGamesModes(undefined,rota);
	
	wait 1;
	
	if(mode == "AIO")
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
			
		}
		else
			setDvar(mode,"1");
		
		if(isDefined(name) && name == "Sniper lobby (ACOG)")
			setDvar("GM_OPTIONAL","ACOG");
		else
			setDvar("GM_OPTIONAL","0");
		
	}
}


ResetGamesModes(lol, lol2)
{
	if(isDefined(lol))
		setdvar("ONLY_RANDOM","1");
	else
		setdvar("ONLY_RANDOM","0");
		
	if(isDefined(lol2))
		setdvar("NORM_ROTATION","1");
	else
		setdvar("NORM_ROTATION","0");
		
	setDvar("GM_OPTIONAL","0");
	setDvar("DVSU","0");
	setDvar("toBet","0");
	setdvar("brickG","0");
	setDvar("SSC","0");
	setDvar("JUGG","0");
	setDvar("FUTUR","0");
	setDvar("cachecache","0");
	setDvar("Lava","0");
	
	//TDM
	setDvar("ZLV5","0");
	setDvar("ZLV3","0");
	setDvar("MM","0");
	setDvar("MW3","0");
	setDvar("NM","0");
	setDvar("FUNNYZOMB","0");
	setDvar("RGM","0"); 
	setDvar("GON","0");
	setDvar("ONLY_SNIPER","0");
	setDvar("INF","0");
	setDvar("CONFIRMED","0");
	setDvar("MOON","0");
	
	
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
	
	setDvar( "ui_hud_hardcore", 0 );
}

























