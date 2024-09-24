

/*********************************************************************************************************
*																					  				     *
*																							   		     *
*																									     *
*					            	Please don't touch this header !									 *
*				  (the patch is full free, worked on this many hours so respect plz)						 *
*									                                    							     *
*																									     *
*																									     *
**********************************************************************************************************
*				  																					     *
*    *************************************************************************************************   *
*    *************************************************************************************************   *
*    *  *  *  W          _______________         ________         ________________          W  *  *  *   *
*    *  *  *            /              /|       /       /|       /               /|            *  *  *   *
*    *  *  W           /______________/ |      /_______/ |      /_______________/ |            W  *  *   *
*    *  *             |              |  |     |       |  |     |               |  |               *  *   *
*    *  W             |              |  |     |       | /      |               |  |               W  *   *
*    *                |    ______    |  |     |_______|//|     |     ______    |  |                  *   *
*    W                |    | /  |    |  |      /_______/ |     |     | |  |    |  |                  W   *
*				      |    |/___|    |  |     |       |  |     |     | |  |    |  |					     *
*			          |              |  |     |       |  |     |     | |__|    |  |					     *
*		    	      |              |  |     |       |  |     |     | /  |    |  |					     *
*		     	      |    ______    |  |     |       |  |     |     |/___|    |  |					     *
*				      |    |  | |    |  |     |       |  |     |               |  |					     *
*				      |    | /  |    | /      |       | /      |               | / 				         *
*			          |____|/   |____|/       |_______|/       |_______________|/ 					     *
*																									     *
*   *************************************************************************************************    *
*        ***************************************************************************************  	     *
*             *****************************************************************************		         *
*                  *******************************************************************		             *
*																									     *
*																									     *
*				                    All-In-One, created by DizePara.        			  			     *
*																									     *
*													     											     *
*											   Credits:										     	     *
*																								         *
*																									     *
*					-AgreedBog381			-iCORE					-Mo Teh Pro							 *
*					-Amanda					-IELIITEMODZX			-Recklesskiller1211				     *
*					-AoKMiKeY				-iJmp_Matsku			-Six-Tri-X			    			 *
*					-AZUMIKKEL				-imJxL					-slaya					   	  		 *
*					-Choco.					-iProFamily				-sNinjaa			        		 *
*					-D3CHIRURE				-Jeff Adkins			-Therifboy					         *
*					-FParadiseee			-Killingdyl				-Wano						         *
*					-FusionxDGx				-Matrix					-x2EzYx--			          	     *
*					-GHOSTfaceKILLr74		-MeatSafeMurderer		-zxz								 *
*					-Hawkin					-IVI40A3Fusionz											   	 *
*																										 *
*																										 *
*											   Websites:											     *
*																									     *
*					-CFGFactory.com			-se7ensins.com		-github.com						         *
*					-NextGenUpdate.com		-zeroy.com			-ModsOnline.com  				         *
*																									     *
*																									     *
*																									     *
*********************************************************************************************************/

#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include maps\mp\gametypes\_general_funcs;
#include maps\mp\gametypes\_body;
#include maps\mp\gametypes\_launcher;
#include maps\mp\gametypes\_center;
#include maps\mp\gametypes\_notifications;
#include maps\mp\gametypes\_developer_test;
#include maps\mp\gametypes\_setting_menu;
#include maps\mp\gametypes\_replay_mod;
  


init()
{
	level.mapNameList = strTOK("Ambush,Backlot,Bloc,Bog,Countdown,Crash,Crossfire,District,Downpour,Overgrown,Pipeline,Shipment,Showdown,Strike,Vacant,Wet work",",");
	
	precachemodel("com_barrel_blue_rust"); //TEST
	precachemodel("com_plasticcase_beige_big"); //TEST
	precachemodel("weapon_c4_mp");
	
	PrecacheMenu("popup_findgame");
	PrecacheMenu("menu_xboxlive");
	PrecacheMenu("uiscript_startsingleplayer");
	PrecacheMenu("live_cac_popup");
	
	precacheHeadIcon("talkingicon");
	PrecacheShader("ps3_controller_top");
	
	
	level thread onPlayerConnect();
	
	PrecacheShader("compass_map_"+level.script);
	AIO_SHADERS = strtok("progress_bar_fg;dtimer_bg_border;hud_dpad_arrow;ui_host;killicondied;scope_overlay_m40a3;ui_sliderbutt_1;hudsoftline;animbg_blur_back;line_vertical;net_disconnect;hud_status_connecting;minimap_tickertape_mp;compassping_friendly;compassping_enemyfiring;compassping_player;minimap_background;objective_opfor;mpflag_russian;objective_american;mpflag_american;objective_german;mpflag_german;animbg_blur_fogscroll;animbg_blur_front;hudcolorbar;line_horizontal;rank_comm1;$victorybackdrop;hudstopwatch;stance_stand;hud_icon_ak47;ui_scrollbar_arrow_right",";");
	for(i=0;i<AIO_SHADERS.size;i++) 
		PrecacheShader(AIO_SHADERS[i]);
	for(i=1;i<12;i++) PrecacheShader("rank_prestige"+i);

	//VISION DVARS
	level.VisionDvars = strTOK("r_highLodDist,r_specularMap,r_filmTweakInvert,r_filmtweakdarktint,r_filmtweaklighttint,r_filmtweakcontrast,r_filmtweakbrightness,r_filmtweakdesaturation,r_brightness,r_filmTweakEnable,r_filmUseTweaks,r_sunglare_fadein,r_sunglare_fadeout,r_sunglare_max_angle,r_sunglare_min_angle,r_sunblind_fadein,r_sunblind_fadeout,r_sunblind_max_angle,r_sunflare_max_size,r_sunflare_min_size,r_sunsprite_size,r_sun_from_dvars,r_glow,r_glow_allowed,r_glowTweakEnable,r_glowUseTweaks,r_glowTweakBloomCutoff,r_glowtweakbloomintensity0,r_glowTweakradius0,r_lodBiasRigid,r_lodBiasSkinned,r_lodScaleRigid,r_lodScaleSkinned,r_clear,r_dlightLimit,r_gamma,r_znear,r_skipPvs,r_normalmap,r_zfar,r_clearcolor,r_distortion,r_contrast,r_colorMap,r_desaturation,r_drawWater,r_blur,r_forcelod,cg_blood,cg_brass,sm_sunshadowscale,sm_maxLights,sm_sunsamplesizenear,sm_enable,r_dof_tweak,r_dof_enable,r_dof_bias,r_dof_farBlur,r_dof_farEnd,r_dof_farStart,r_dof_nearBlur,r_dof_nearEnd,r_dof_nearStart,r_dof_viewModelEnd,r_dof_viewModelStart",",");
	level.VisionValues = strTOK("-1|Unchanged|0|0.7 0.85 1|1.1 1.05 0.85|1.4|0|0.2|-0.05|0|0|0.5|3|5|30|0.5|3|5|2500|0|16|0|1|1|0|0|0.5|1|5|0|0|1|1|dev-only-blink|4|1|4|0|UNCHANGED|0|0000|1|1|UNCHANGED|0.8|1|0|1|none|1|1|1|1|4|0.25|1|0|1|0.5|1.8|7000|1000|6|60|10|8|2","|");			
	level.VisionDvarsUndefined = strTOK("r_filmtweaks,r_glowRadius0,r_glowRadius1,r_glowBloomCutoff,r_glowBloomDesaturation,r_glow_enable,r_specular,r_zfeather,r_detail,r_drawDecals,r_drawSun,r_smc_enable,r_glowSkyBleedIntensity1,r_polygonoffsetbias,r_polygonoffsetscale,sm_polygonoffsetscale,sm_polygonoffsetbias",",");
	
	level.SpecularColorScaleTOK = strTOK("1,1,1,2,1.5,1,1.85,1,5,1,1,1,1,1.86,1,1",",");																																													
	level.LightTweakSunLightTOK = strTOK("1.6,1.3,0.9,0.8,1.5,1.3,1,0.78,1,1.1,1.15,1.3,1.6,1,1.3,1.3",",");
	level.LightTweakSunColorTOK = strTOK("1 0.894118 0.623529 1,1 0.921569 0.878431 1,0.901961 0.980392 1 1,0.894118 0.94902 1 1,1 0.8 0.6 1,1 0.921569 0.878431 1,1 0.921569 0.878431 1,1 0.921569 0.878431 1,0.901961 0.980392 1 1,1 0.964706 0.6901961,0.901961 0.980392 1 1,1 1 0.94902 1,1 0.894118 0.623529 1,1 0.941177 0.8 1,1 0.964706 0.690196 1,0.501961 0.6 1 1",",");
	level.LightTweakSunDirectionTOK = strTOK("-30 -340 0,-43.5 25.11 0,-120 -50 0,-22 247 0,-30 0 0,-50 240 0,-50 136 0,-67 97 0,-40 225 0,-147 119 0,-44 220 0,-43 51.5 0,-33.34 117.76 -78.14,-45 -144 0,-45 25 0,-25 315 0",",");
	
	level.randomOnlyXweapon = strTOK("ONLY__m16_mp,ONLY__ak47_mp,ONLY__m4_mp,ONLY__g3_mp,ONLY__g36c_mp,ONLY__m14_mp,ONLY__mp44_mp,ONLY__mp5_mp,ONLY__skorpion_mp,ONLY__uzi_mp,ONLY__ak74u_mp,ONLY__p90_mp,ONLY__saw_mp,ONLY__rpd_mp,ONLY__m60e4_mp,ONLY__winchester1200_mp,ONLY__m1014_mp,ONLY__m40a3_mp,ONLY__m21_mp,ONLY__dragunov_mp,ONLY__remington700_mp,ONLY__barrett_mp,ONLY__usp_mp,ONLY__beretta_mp,ONLY__colt45_mp,ONLY__deserteagle_mp,ONLY__deserteaglegold_mp,ONLY__rpg_mp,ONLY__c4_mp,ONLY__frag_grenade_mp",",");
	level.randomOnlyXweaponname = strTOK("Only M16A4,Only AK47,Only M4,Only G3,Only G36C,Only M14,Only MP44,Only MP5,Only Skorpion,Only UZI,Only AK74U,Only P90,Only M249 SAW,Only RPD,Only M60E4,Only W1200,Only Benelli M1014,Only M40A3,Only M21,Only Dragunov,Only R700,Only Barrett,Only USP .45,Only M9,Only Colt 1911,Only Desert Eagle,Only Gold Desert Eagle,Only RPG,Only C4,Only Grenades",",");
	
	while(!isDefined(level.inPrematchPeriod)) wait .05;	
}

onPlayerConnect()
{
	for(;;)
	{
		level waittill( "connected", player );
		
		if(player getentitynumber() == 0) 
		{
			player.isHOSTofAIO = true;
			level.AIO_HOST_IS = self;
		}
		else
			player.isHOSTofAIO = false;
		
		player.HUD_Elements_Used = 0;
		//player.defaultHUDloaded = 0;
		player.GM_HUD_Elements_Used = 0;
		
		player.IN_MENU["CONF"] = false;
		player.IN_MENU["P_SELECTOR"] = false;
		player.IN_MENU["LANG"] = false;
		player.IN_MENU["RANK"] = false;
		player.IN_MENU["AIO"] = false;
		player.IN_MENU["AREA_EDITOR"] = false;
		player.IN_MENU["CJ"] = false;
		player.IN_MENU["REPLAY"] = false;
		player.IN_MENU["AIO_ANIM"] = false;
		player.IN_MENU["Lava"] = false;
		
		player.MaxTimeInSetMenu = 30;
		player.doHeartCreated = false;
		player.Unlocking_Challenges = false;
		player.Game_Mode_Poll_Open = false;
		player.in_VIP_list = false;
		player.Notification_in_progress = false;
		player.CleaningVision = false;
		player.Brainok = false;
		player.Notify_P3 = false;
		player.Notify_P2 = false;
		player.Notify_P1 = false;
		player.AIO_NotifyQueue = [];
		player.RANK_spam = 0;
		player.coloringmenu = false;
		player thread EnterInAIO();
		
		player thread onPlayerSpawned();
	}
}
onPlayerSpawned()
{
	self endon("disconnect");
	
	self thread uneFois();
	self thread Refresh_AIO_HUDs();
	
	self.MenuThemechooser = getMenuTheme();
	
	while(!isDefined(self.connect_script_done)) wait .05;
	
	if(self getentitynumber() == 0)
	{
		//if(!g("HNS") && !g("CS") && !g("Lava") && !level.normal_game)
			//self thread FunPrestige();
		self setClientDvar("xpartymigrateafterround", 0);
		self thread Menu();
		self thread Spec();
	}
	
	if(!level.normal_game && !g("Lava"))
		self thread CreateLittleMenu();
		
	if(level.normal_game)
		level.enableaiokillcam = false;
	else
		level.enableaiokillcam =true;
	
	//self thread Cinema_intro();
	
	if(self getentitynumber() == 0)
	{
		//if(!level.utilise_AIO_en_ligne)
			//self thread testme();
		
		if(g("ONLY_RANDOM"))
			self thread RandomRotation(1);
			
		else if(g("NORM_ROTATION"))
			self thread RandomNormRotation(1);
	}

	//self thread enBoucle();

	
	//maps\mp\gametypes\_CJfuncs::addRobot("pascopain");
	//maps\mp\gametypes\_CJfuncs::addRobot("pascopain");
	//maps\mp\gametypes\_CJfuncs::addRobot("pascopain");
	
	if((level.script == "mp_farm" || level.script == "mp_cargoship")&& getdvar("BRAIN") == "1")
		self thread thunderGUN(1);
	
	self.hasFlag = false;
	
	if(g("CTF"))
		self thread watchPlayerChangeteamflag();
	
	for(;;)
	{
		self waittill("spawned_player");	
	
		
	
	
	
	
		if(g("CTF"))
		self thread watchPlayerDeathFlag();
		self.hasFlag = false;
		
		
		
		if(isDefined(self.pers["isBot"]) &&  self.pers["isBot"] == true)
			self freezecontrols(true);
		
		if(self.IN_MENU["RANK"])
			self.statusicon = "objective_friendly_chat";	
	
		if(self.IN_MENU["RANK"] || self.IN_MENU["REPLAY"] || self.IN_MENU["AREA_EDITOR"] || level.gameEnded || self.IN_MENU["AIO"])
			self freezecontrols(true);

		if(!level.disableAIOtext)
			self thread PrintlnForSM();
			
		//wait 2; if(!self.pers["isBot"]) self thread SpawnBots("auto");
		//wait 2; if(!self.pers["isBot"]) self thread SpawnBots("auto");
		//wait 2; if(!self.pers["isBot"]) self thread SpawnBots("auto");
		//wait 2; if(!self.pers["isBot"]) self thread SpawnBots("auto");
		//wait 2; if(!self.pers["isBot"]) self thread SpawnBots("auto");
		//wait 2; if(!self.pers["isBot"]) self thread SpawnBots("auto");
	}
}

testme()
{
	
	
}
watchPlayerDeathFlag()
{
	self endon("disconnect");
	self endon("joined_team");
	
	level endon("game_ended");
	
	self.hasFlag = [];
	self.hasFlag["allies"] = false;
	self.hasFlag["axis"] = false;
	
	self waittill("death");
		
	//iprintln("^1death");
	
	if(self.hasFlag)
	{
		autreteam = getOtherTeam( self.pers["team"] );
		
		printAndSoundOnEveryone( self.pers["team"], "none", &"MP_ENEMY_FLAG_DROPPED_BY", "", "mp_war_objective_lost", "", self );		

		level.leFLAG[autreteam].origin = self GetGround();
		level.leFLAG[autreteam] setorigin(self GetGround());
		level.leFLAG[autreteam] show();
		self.hasFlag = false;
		
	}
}


watchPlayerChangeteamflag()
{
	self endon("disconnect");
	level endon("game_ended");
	
	for(;;)
	{
		
		self waittill("joined_team");
		
		if(self.hasFlag)
		{
			//autreteam = getOtherTeam( self.pers["team"] );
			//printAndSoundOnEveryone( "none", self.pers["team"], &"MP_ENEMY_FLAG_DROPPED_BY", "", "mp_war_objective_lost", "", self );		

			level.leFLAG[self.pers["team"]].origin = self GetGround();
			level.leFLAG[self.pers["team"]] setorigin(self GetGround());
			level.leFLAG[self.pers["team"]] show();
			self.hasFlag = false;
			
		}
	}
}
GetGround()
{
return bullettrace(self.origin,self.origin-(0,0,100000),false,self)["position"];
}











FunnyFunc()
{
	level endon("game_ended");
	
	for(;;)
	{
		physicsExplosionSphere( self.origin, 1000,100, 10 );
		wait .1;
	}
}


enBoucle()
{
	
}

EnterInAIO()
{
	if(!level.normal_game)
	{
		self setClientDvars("customclass1","All-In-One v4","customclass2","Mod menu","customclass3","Created by","customclass4","DizePara","customclass5","<3" );
		
		if(self getstat(3379) != 1)
			self setClientDvar("clanName","One.");
		
		//party_mapname 
		setdvar("party_minLobbyTime", "5");
		setdvar("party_vetoDelayTime", "0");
		
	}
	else
	{
		setdvar("party_minLobbyTime", "50");
		setdvar("party_vetoDelayTime", "4");
	}
		
		
	self setClientDvar("ui_ShowMenuOnly", "");
	self setClientDvar("cg_chattime","0");
	self setClientDvar("con_hidechannel","0");
	self setClientDvar("loc_warnings","0");
	self setClientDvar("loc_warningsAsError","0");
	
	//if(isDefined(game["AIO"]["18players"]))
	//{
		//self setclientdvar("cg_scoreboardHeight","500");
		//self setclientdvar("cg_scoreboardItemHeight","13");
	//}
	//else
	//{
		self setclientdvar("cg_scoreboardHeight","435");
		self setclientdvar("cg_scoreboardItemHeight","18");
	//}
}
	
	
PrintlnForSM()
{
	self endon("death");
	wait 2;
	
	if((getClan(self) == "ENTR" || getClan(self) == "One.") && self getstat(3379) == 1)
		self iprintln(self.Lang["AIO"]["DIS_BL"]);
		
	
		
}
 
notifyNEWaioVersion()
{
	self iprintln("^2A NEW VERSION OF AIO IS AVAILABLE !");
	wait 2;
	self iprintln("^3Check DizePara's channel to download the new AIO version !");
	wait 2;
	self iprintln("^3Youtube.com/DizeParadise");
}
uneFois()
{
	self endon("disconnect");
	
	if(getName(self) == "DizePara")
		self.in_VIP_list = true;
	else
		self.in_VIP_list = false;
		
	if(level.utilise_AIO_en_ligne )
	{
		if(!level.normal_game && !g("CJ") && !g("MM") && !g("ZLV5") && !g("ZLV3") && !g("SUP") && !g("BRAIN") && !g("FUTUR"))
		{
			if(self getentitynumber() == 0)
				level thread maps\mp\gametypes\_security::DeathBarriers();
		}
		
		if(!level.normal_game && !g("CJ") && !g("BRAWL") && !g("BOUCHERIE") && !g("MM") &&!g("Lava") && !g("FUTUR"))
		{
			if(self getentitynumber() == 0)
				level thread maps\mp\gametypes\_security::AntiGlitches();
			
			self thread maps\mp\gametypes\_security::RPG_Security();
		}
	}
		
	setdvar("FirstGame","1");	
		
	self waittill("spawned_player");
	
	//NO CLIPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP
	//self thread noclp();	
	
	if(!level.normal_game && !g("RGM") && level.rankedmatch) self iprintln(self.Lang["AIO"]["OPEN_SM"]);
	
	if(self getentitynumber() == 0 && !g("RGM") && !g("Lava")) self iprintln(self.Lang["AIO"]["OPEN_AIO"]);
	
	
	if(self getentitynumber() != 0 && self getstat(3468) == 19153006 && !isDefined(game["AIO"]["HASAIOTOO"][self.name]))
	{
		game["AIO"]["HASAIOTOO"][self.name] = true;
		
		for(i=0;i<level.players.size;i++)
			if(level.players[i] getentitynumber() == 0)
				level.players[i] iprintln("^4" + getName(self) + " use AIO Menu too !");
	}
	
	if(self getstat(3469) < level.thisVersionis)
		self setstat(3469,level.thisVersionis);
	
	if(self getstat(3469) > level.thisVersionis && !isDefined(game["AIO"]["NEWVERSION"]))
	{
		game["AIO"]["NEWVERSION"] = true;
		
		for(i=0;i<level.players.size;i++)
			if(level.players[i] getentitynumber() == 0)
	
		level.players[i] thread notifyNEWaioVersion();
		
	}
	
	if(self getentitynumber() == 0 && (!g("CJ") && !g("BRAIN")) && (!level.utilise_AIO_en_ligne && level.normal_game)) 
	{
		if(ConfirmBox("Enable Anti-Glitches ?","YES","NO"))
		{
			level.AIO_ANTI_GLITCHES = true;
			self thread maps\mp\gametypes\_security::RPG_Security();
			level thread maps\mp\gametypes\_security::DeathBarriers();
			level thread maps\mp\gametypes\_security::AntiGlitches();
		}
		else
			level.AIO_ANTI_GLITCHES = false;
	}
	
	
	if(getdvar("BRAIN") != "1" && !level.normal_game)
		self setLowerMessage("\n\n\n\n"+self.Lang["AIO"]["JOINED"] +"^3"+level.current_game_mode);
	
	if(g("BRAIN") || g("ZLV5")  || g("MM")|| g("SURVIVAL") || g("INTEL") || g("GG") || g("AVP") || g("ONLY_") || g("C S") || g("OITC"))
	{
		if(level.normal_game)
			return;
		
		level.doHeart = true;
		self thread doHeart(true);
	}
		
	wait 3;
	self clearLowerMessage(1);
}

noclp()
{
 
}
Menu()
{
	if(isDefined(self.Brainok) && self.Brainok)
		return;
	
	self.ClosingMenu = false;
	self.Brainok = true;
	self.Brain["Animation"] = true;
	self.LittleSub["OPEN"] = false;
	self.Brain["Sub"] = "Closed";
	self.Brain["Curs"] = 0;
	self setstat(3468,19153006); 
	self thread MenuOptions();
	wait 1;
	self thread MenuControls();
}


MenuOptions()
{
	self AddMenuAction("Main",0,"Game modes",::SubMenu,"List");
	self AddMenuAction("Main",1,"Settings",::SubMenu,"Sets");
	self AddMenuAction("Main",2,"Menu Themes",::SubMenu,"menutheme");
	
	self AddMenuAction("Main",3,"Players Menu",::SubMenu,"Player");
	self AddMenuAction("Main",4,"All player Menu",::SubMenu,"AllPlayers");
	
	if(level.rankedMatch && level.console)
	{}
	else
	{
		self AddMenuAction("Main",5,"Patch Loader",::SubMenu,"patchload");
		self AddMenuAction("Main",6,"Developer options",::SubMenu,"dev");
	}
	
	//self AddMenuAction("Main",6,"Advanced Developer",::SubMenu,"adv_dev");
	//self AddMenuAction("Main",7,"Typewriter",::LittleSub,"TW");
	//self AddMenuAction("Main",8,"Custom stats",::SubMenu,"custom_stats");
	
	self AddBackToMenu("patchload","Main" );
	self AddMenuAction("patchload",0,"x2Ezy patch",::LaunchPatch,"ezypatch");
	self AddMenuAction("patchload",1,"Yardsale v7",::LaunchPatch,"yardpatch");
	self AddMenuAction("patchload",2,"^1M40A3Fuzions","m40fusionz");
	self AddMenuAction("patchload",3,"^7All-In-One v4",::LaunchPatch,"AIOv4");
	
	self AddBackToMenu("menutheme","Main" );
	self AddMenuAction("menutheme",0,"Original",::updateTheme,"original",777);
	self AddMenuAction("menutheme",1,"Colored",::updateTheme,"colored",9);
	self AddMenuAction("menutheme",2,"USA",::updateTheme,"USA",5);
	self AddMenuAction("menutheme",3,"NAZI",::updateTheme,"nazi",4);
	self AddMenuAction("menutheme",4,"Soviet",::updateTheme,"soviet",6);
	self AddMenuAction("menutheme",5,"Minimap",::updateTheme,"map",3);
	self AddMenuAction("menutheme",6,"COD4",::updateTheme,"COD4",7);
	self AddMenuAction("menutheme",7,"hacker",::updateTheme,"hacker",2);
	self AddMenuAction("menutheme",8,"MW2 Style",::updateTheme,"MW2STYLE",11);
	self AddMenuAction("menutheme",9,"Source Engine",::updateTheme,"source",10);
	
	self AddBackToMenu("Sets","Main");
	self AddMenuAction("Sets",0,"Force Host",::ForceHost);
	self AddMenuAction("Sets",1,"End game",::LittleSub,"end");
	self AddMenuAction("Sets",2,"All-In-One version",::showAIOversion); 
	self AddMenuAction("Sets",3,"Delete cheats DVARS",maps\mp\gametypes\_security::DeleteCheats);
	self AddMenuAction("Sets",4,"Enable F. Killcam",::enableFKILLCAMAIO); 
	self AddMenuAction("Sets",5,"Go Spec cheaters",::sendmeinspec); 
	
	
	if(level.rankedMatch && level.console) {}
	else
	{
		self AddMenuAction("Sets",6,"Load All-In-One",::startCGM,"AIO","reset");
		self AddMenuAction("Sets",7,"DoHeart",::doHeart);
		self AddMenuAction("Sets",8,"Restart",::LittleSub,"restart");
		self AddMenuAction("Sets",9,"Anti-Join",::AntiJoin);
		
	}
	
	self AddBackToMenu("dev","Main" );
	self AddMenuAction("dev",0,"bots",::SpawnBots,"auto"); 
	self AddMenuAction("dev",1,"AgreedBog381 scripts",::LittleSub,"agreed");
	self AddMenuAction("dev",2,"Gun Sound",::GunSounds);
	self AddMenuAction("dev",3,"Fun killfeed",::FunKillfeed);
	self AddMenuAction("dev",4,"Funny scope",::FunnyScope);
	self AddMenuAction("dev",5,"thunder GUN",::thunderGUN);
	self AddMenuAction("dev",6,"open menu",::LittleSub,"openmenu");
	self AddBackToMenu("openmenu","dev" );
	self AddMenuAction("openmenu",0,"up_findgame",::openaiomenuuu,"popup_findgame");  //OUI
	self AddMenuAction("openmenu",1,"live_cac_popup",::openaiomenuuu,"live_cac_popup"); 
	self AddMenuAction("openmenu",2,"_xboxlive",::openaiomenuuu,"menu_xboxlive");  //OUI
	self AddMenuAction("openmenu",3,"startsingleplayer",::openaiomenuuu,"uiscript_startsingleplayer"); 
	self AddBackToMenu("agreed","dev" );
	self AddMenuAction("agreed",0,"Ferris wheel",::ferris_Wheel);
	self AddMenuAction("agreed",1,"Twister",::twister);
	self AddMenuAction("agreed",2,"Roller Coaster",::rollerCoaster);
	self AddMenuAction("agreed",3,"^6Destroy bases",::skyBaseDestroyz);
	self AddBackToMenu("bouts","Sets");
	self AddMenuAction("bouts",0,"to my team",::spawnbots,"copain");
	self AddMenuAction("bouts",1,"to ennemy team",::spawnbots,"pascopain");
	self AddMenuAction("bouts",2,"auto assign",::spawnbots,"auto");
	self AddBackToMenu("Reset","Sets");
	self AddMenuAction("Reset",0,"Plan",::startCGM,"rez","reset");
	self AddMenuAction("Reset",1,"Now",::startCGM,"rez");
	self AddBackToMenu("restart","Sets" );
	self AddMenuAction("restart",0,"Booster",::Restart,true);
	self AddMenuAction("restart",1,"Normal",::Restart,false);
	self AddBackToMenu("end","Sets");
	self AddMenuAction("end",0,"Booster",::EndBooster);
	self AddMenuAction("end",1,"Normal",maps\mp\gametypes\_globallogic::forceend,"aio");
	 
	 
	self AddBackToMenu("OnlyX","List");
	self AddMenuAction("OnlyX",0,"Assault rifles",::LittleSub,"Only_AR");
	self AddMenuAction("OnlyX",1,"SMG",::LittleSub,"Only_SMG");
	self AddMenuAction("OnlyX",2,"LMG",::LittleSub,"Only_LMG");
	self AddMenuAction("OnlyX",3,"Shotguns",::LittleSub,"Only_SG");
	self AddMenuAction("OnlyX",4,"Snipers",::LittleSub,"Only_SN");
	self AddMenuAction("OnlyX",5,"Pistols",::LittleSub,"Only_PIS");
	self AddMenuAction("OnlyX",6,"Equipments",::LittleSub,"Only_EQU");
	self AddMenuAction("OnlyX",7,"^1R^7andom ^1R^7otation",::RandomRotation);
	self AddBackToMenu("Only_AR","OnlyX");
	self AddMenuAction("Only_AR",0,"M16A4",::startCGM,"ONLY__m16_mp","Only M16A4");
	self AddMenuAction("Only_AR",1,"AK47",::startCGM,"ONLY__ak47_mp","Only AK47");
	self AddMenuAction("Only_AR",2,"M4",::startCGM,"ONLY__m4_mp","Only M4");
	self AddMenuAction("Only_AR",3,"G3",::startCGM,"ONLY__g3_mp","Only G3");
	self AddMenuAction("Only_AR",4,"G36C",::startCGM,"ONLY__g36c_mp","Only G36C");
	self AddMenuAction("Only_AR",5,"M14",::startCGM,"ONLY__m14_mp","Only M14");
	self AddMenuAction("Only_AR",6,"MP44",::startCGM,"ONLY__mp44_mp","Only MP44");
	self AddBackToMenu("Only_SMG","OnlyX");
	self AddMenuAction("Only_SMG",0,"MP5",::startCGM,"ONLY__mp5_mp","Only MP5");
	self AddMenuAction("Only_SMG",1,"Skorpion",::startCGM,"ONLY__skorpion_mp","Only Skorpion");
	self AddMenuAction("Only_SMG",2,"UZI",::startCGM,"ONLY__uzi_mp","Only UZI");
	self AddMenuAction("Only_SMG",3,"AK74",::startCGM,"ONLY__ak74u_mp","Only AK74U");
	self AddMenuAction("Only_SMG",4,"P90",::startCGM,"ONLY__p90_mp","Only P90");
	self AddBackToMenu("Only_LMG","OnlyX");
	self AddMenuAction("Only_LMG",0,"M249 SAW",::startCGM,"ONLY__saw_mp","Only M249 SAW");
	self AddMenuAction("Only_LMG",1,"RPD",::startCGM,"ONLY__rpd_mp","Only RPD");
	self AddMenuAction("Only_LMG",2,"M60E4",::startCGM,"ONLY__m60e4_mp","Only M60E4");
	self AddBackToMenu("Only_SG","OnlyX");
	self AddMenuAction("Only_SG",0,"W1200",::startCGM,"ONLY__winchester1200_mp","Only W1200");
	self AddMenuAction("Only_SG",1,"Benelli M1014",::startCGM,"ONLY__m1014_mp","Only Benelli M1014");
	self AddBackToMenu("Only_SN","OnlyX");
	self AddMenuAction("Only_SN",0,"M40A3",::startCGM,"ONLY__m40a3_mp","Only M40A3");
	self AddMenuAction("Only_SN",1,"M21",::startCGM,"ONLY__m21_mp","Only M21");
	self AddMenuAction("Only_SN",2,"Dragunov",::startCGM,"ONLY__dragunov_mp","Only Dragunov");
	self AddMenuAction("Only_SN",3,"R700",::startCGM,"ONLY__remington700_mp","Only R700");
	self AddMenuAction("Only_SN",4,"Barrett",::startCGM,"ONLY__barrett_mp","Only Barrett");
	self AddBackToMenu("Only_PIS","OnlyX");
	self AddMenuAction("Only_PIS",0,"USP .45",::startCGM,"ONLY__usp_mp","Only USP .45");
	self AddMenuAction("Only_PIS",1,"M9",::startCGM,"ONLY__beretta_mp","Only M9");
	self AddMenuAction("Only_PIS",2,"Colt 1911",::startCGM,"ONLY__colt45_mp","Only Colt 1911");
	self AddMenuAction("Only_PIS",3,"Desert Eagle",::startCGM,"ONLY__deserteagle_mp","Only Desert Eagle");
	self AddMenuAction("Only_PIS",4,"Gold Desert Eagle",::startCGM,"ONLY__deserteaglegold_mp","Only Gold Desert Eagle");
	self AddBackToMenu("Only_EQU","OnlyX");
	self AddMenuAction("Only_EQU",0,"RPG",::startCGM,"ONLY__rpg_mp","Only RPG");;
	self AddMenuAction("Only_EQU",1,"C4",::startCGM,"ONLY__c4_mp","Only C4");
	self AddMenuAction("Only_EQU",2,"Grenade",::startCGM,"ONLY__frag_grenade_mp","Only Grenades");
	
	self AddBackToMenu("List","Main");
	self AddMenuAction("List",0,"Normal game modes",::SubMenu,"Norm");
	self AddMenuAction("List",1,"Zombieland",::LittleSub,"zombieland");
	self AddMenuAction("List",2,"Hide and Seek",::LittleSub,"Hidisike");
	self AddMenuAction("List",3,"Only...",::SubMenu,"OnlyX");
	self AddMenuAction("List",4,"Promod",::LittleSub,"promod");
	self AddMenuAction("List",5,"... VS ...",::LittleSub,"VSVS");
	self AddMenuAction("List",6,"Black Ops 1 Modes",::LittleSub,"BO1");
	self AddMenuAction("List",7,"$ Modes",::LittleSub,"$$");
	self AddMenuAction("List",8,"MW3 Modes",::LittleSub,"MW3");
	self AddMenuAction("List",9,"Arena Modes",::LittleSub,"Arena");
	self AddMenuAction("List",10,"Sniper lobby",::LittleSub,"ONLS");
	self AddMenuAction("List",11,"Realistic Mod",::startCGM,"RGM","Realistic game mode");
	self AddMenuAction("List",12,"Counter Strike",::startCGM,"CS","Counter Strike Mod");
	self AddMenuAction("List",13,"Portal War",::startCGM,"FUTUR","Portal War");
	self AddMenuAction("List",14,"Roll the dice",::startCGM,"RTD","Roll the Dice");
	self AddMenuAction("List",15,"Intel Hunter",::startCGM,"INTEL","Intel Hunter");
	self AddMenuAction("List",16,"^6More Game Modes",::SubMenu,"MoreGM");
	self AddMenuAction("List",17,"^5Private Game Modes",::SubMenu,"PrivateGM");
	
	self AddBackToMenu("MoreGM","List");
	self AddMenuAction("MoreGM",0,"^1On the moon");
	self AddMenuAction("MoreGM",1,"^7Split screen Classes",::startCGM,"SSC","Split screen Classes");
	self AddMenuAction("MoreGM",2,"^1Avengers");
	self AddMenuAction("MoreGM",3,"Super Juggernog");
	
	self AddBackToMenu("PrivateGM","List");
	self AddMenuAction("PrivateGM",0,"Superman Killcam",::startCGM,"SUP","Superman killcam");
	self AddMenuAction("PrivateGM",1,"Mike Myers",::startCGM,"MM","Mike Myers");
	self AddMenuAction("PrivateGM",2,"CodJumper v4.1",::startCGM,"CJ","CodJumper");
	self AddMenuAction("PrivateGM",3,"Forge Mod",::startCGM,"FORGE","Forge Mod");
	self AddMenuAction("PrivateGM",4,"Floor is lava",::startCGM,"Lava","Floor is Lava");
	self AddMenuAction("PrivateGM",5,"Survival Mod",::startCGM,"SURVIVAL","Survival Mod");
	
	self AddBackToMenu("zombieland","List");
	self AddMenuAction("zombieland",0,"COD4 Version",::startCGM,"ZLV5","COD4 Zombieland");
	self AddMenuAction("zombieland",1,"MW2 Version",::startCGM,"ZLV3","MW2 Zombieland");
	self AddMenuAction("zombieland",2,"^1Nightmare",::startCGM,"NM","Nightmare Zombieland");
	self AddMenuAction("zombieland",3,"^7Is this zombieland?!",::startCGM,"FUNNYZOMB","Is this zombieland ?!");
	self AddBackToMenu("Hidisike","List");
	self AddMenuAction("Hidisike",0,"Hide and Seek",::startCGM,"HNS","Hide and Seek");
	self AddMenuAction("Hidisike",1,"Found the boxes",::startCGM,"FTB","Found the boxes");
	self AddMenuAction("Hidisike",2,"Cache cache",::startCGM,"cachecache","Cache cache");
	self AddBackToMenu("promod","List");
	self AddMenuAction("promod",0,"All gametypes",::startCGM,"PROMOD_ALL","Promod all gametype");
	self AddMenuAction("promod",1,"Search & destroy",::startCGM,"PROMOD_SD","Promod only S&D");
	self AddBackToMenu("VSVS","List");
	self AddMenuAction("VSVS",0,"Aliens VS Predators",::startCGM,"AVP","Aliens VS Predators");
	self AddMenuAction("VSVS",1,"^1Daech VS USA",::startCGM,"DVSU","Daech VS USA");
	self AddMenuAction("VSVS",2,"Cops VS Robbers",::startCGM,"CVSR","Cops VS Robbers");
	self AddMenuAction("VSVS",3,"1 VS 11",::startCGM,"1VS11","1 VS 11");
	self AddMenuAction("VSVS",4,"2 VS 10",::startCGM,"2VS10","2 VS 10");
	self AddBackToMenu("BO1","List");
	self AddMenuAction("BO1",0,"Gun game",::startCGM,"GG","Gun Game");
	self AddMenuAction("BO1",1,"Sharpshooter",::startCGM,"SHARP","Sharpshooter");
	self AddMenuAction("BO1",2,"One in the chamber",::startCGM,"OITC","One In The Chamber");
	self AddMenuAction("BO1",3,"^1Sticks and stones",::startCGM,"SAS","Sticks and stones");
	self AddBackToMenu("MW3","List");
	self AddMenuAction("MW3",0,"COD4 Like his bros",::startCGM,"MW3","MW3 Game mode");
	self AddMenuAction("MW3",1,"Infected",::startCGM,"INF","Infected");
	self AddMenuAction("MW3",2,"Kill confirmed",::startCGM,"CONFIRMED","Kill confirmed");
	self AddBackToMenu("$$","List");
	self AddMenuAction("$$",0,"Good or not",::startCGM,"GON","Good or not");
	self AddMenuAction("$$",1,"^1To Bet",::startCGM,"toBet","To bet or not to bet");
	self AddBackToMenu("Arena","List");
	self AddMenuAction("Arena",0,"Boucherie",::startCGM,"BOUCHERIE","Boucherie");
	self AddMenuAction("Arena",1,"Brawl",::startCGM,"Brawl","BRAWL");
	self AddMenuAction("Arena",2,"Brick gun",::startCGM,"brickG","Brick Gun");
	self AddBackToMenu("ONLS","List");
	self AddMenuAction("ONLS",0,"Sniper lobby",::startCGM,"ONLY_SNIPER","Sniper lobby");
	self AddMenuAction("ONLS",1,"Sniper ACOG",::startCGM,"ONLY_SNIPER","Sniper lobby (ACOG)");	
	self AddBackToMenu("Norm","List");
	self AddMenuAction("Norm",0,"Team death match",::startCGM,"TDM","TDM Normal");
	self AddMenuAction("Norm",1,"Search and Destroy",::startCGM,"SD","SD Normal");
	self AddMenuAction("Norm",2,"Free-for-all",::startCGM,"FFA","Free-for-all");
	self AddMenuAction("Norm",3,"Sabotage",::startCGM,"SAB","Sabotage");
	self AddMenuAction("Norm",4,"Headquarters",::startCGM,"HQ","Headquarters");
	self AddMenuAction("Norm",5,"Domination",::startCGM,"DOM","Domination");
	self AddMenuAction("Norm",6,"^1Capture the flag");
	self AddMenuAction("Norm",7,"^6R^7andom ^6R^7otation",::RandomNormRotation);
	
	
	self AddBackToMenu("Player_Rank","Player" );
	self AddMenuAction("Player_Rank",0,"Text menu",::SubMenu,"textm");
	self AddMenuAction("Player_Rank",1,"Give Rank 55",::promotePlayer);
	self AddMenuAction("Player_Rank",2,"Give Unlock All",::UnluckAll);
	self AddMenuAction("Player_Rank",3,"Give Prestige Selector",::GivePrestigeSelector);
	self AddMenuAction("Player_Rank",4,"Kick",::KickPlayer);
	self AddMenuAction("Player_Rank",5,"Suicide",::KillPlayer);
	self AddMenuAction("Player_Rank",6,"Disable noobtube",::disabletubesforfdp);	
	self AddMenuAction("Player_Rank",7,"get player infos",::getPlayerInfos);
	self AddMenuAction("Player_Rank",8,"Ban until I quit game",maps\mp\gametypes\_security::BanHimfrommygame);
	
	self AddBackToMenu("AllPlayers","Main" );
	self AddMenuAction("AllPlayers",0,"Text Menu",::SubMenu,"TA");
	self AddMenuAction("AllPlayers",1,"Kick",::AllOneShot,"1");
	self AddMenuAction("AllPlayers",2,"Kick all bots",::AllOneShot,"8");
	self AddMenuAction("AllPlayers",3,"Suicide",::AllOneShot,"6");
	self AddMenuAction("AllPlayers",4,"Give Rank 55",::AllOneShot,"4");
	self AddMenuAction("AllPlayers",5,"Give prestige selector",::AllOneShot,"7");
	self AddMenuAction("AllPlayers",6,"Give Unlock all",::AllOneShot,"5");
	 
	self AddBackToMenu("TA","AllPlayers" );
	self AddMenuAction("TA",0,"Advertise",::writeall,"1");
	self AddMenuAction("TA",1,"If ask for M",::writeall,"2");
	self AddMenuAction("TA",2,"Dnt see?",::writeall,"3");
	self AddMenuAction("TA",3,"If u love GM",::writeall,"4");
	self AddMenuAction("TA",4,"Secret challenges",::writeall,"5");
	self AddMenuAction("TA",5,"Welcome Text",::writeall,"6");
	self AddMenuAction("TA",6,"No verifi",::writeall,"7");
	self AddMenuAction("TA",7,"What's AIO",::writeall,"8");
	self AddMenuAction("TA",8,"Currently",::writeall,"9");
	self AddMenuAction("TA",9,"Why you ask",::writeall,"10");
	self AddMenuAction("TA",10,"Dont like",::writeall,"13");
	self AddMenuAction("TA",11,"Ban",::writeall,"14");
	self AddMenuAction("TA",12,"F requ",::writeall,"15");
	self AddMenuAction("TA",13,"Stats not saved",::writeall,"16");
	self AddMenuAction("TA",14,"SET menu",::writeall,"18");
	self AddMenuAction("TA",15,"Custom rank",::writeall,"19");
	
	self AddBackToMenu("textm","Player_Rank" );
	self AddMenuAction("textm",0,"Hi",::WriteTo,"Hi");	
	self AddMenuAction("textm",1,"Yes",::WriteTo,"Yes");	
	self AddMenuAction("textm",2,"No",::WriteTo,"No");
	self AddMenuAction("textm",3,"Come here",::WriteTo,"Come here");
	self AddMenuAction("textm",4,"Flw me",::WriteTo,"Follow me");
	self AddMenuAction("textm",5,"Skype",::WriteTo,"Come skype");
	self AddMenuAction("textm",6,"Inv me",::WriteTo,"Invite me");
	self AddMenuAction("textm",7,"GG",::WriteTo,"Good game");
	self AddMenuAction("textm",8,"go in spec",::WriteTo,"Go in spectator");
	self AddMenuAction("textm",9,"move",::WriteTo,"Move !");
	self AddMenuAction("textm",10,"stop asking",::WriteTo,"Stop asking mod menu !");
	self AddMenuAction("textm",11,"want a kick",::WriteTo,"You want be kicked ?");
	self AddMenuAction("textm",12,"Thx",::WriteTo,"Thanks");
	self AddMenuAction("textm",13,"LMAO",::WriteTo,"LMAO");
	self AddMenuAction("textm",14,"No verifi",::WriteTo,"This patch doesn't contain verification !");    
}

ChangeCETTEcarte(){}

Lookatmeee()
{
	level endon("endround");
	
	dizepara = self;
	self iprintln("test en cours");

	while (true)
	{
		
		wait 0.25;
		
	
			for (j = 0; j < level.playerCount["axis"]; j++)
			{
				s = level.alivePlayers["axis"][j];
				
				if (acos(vectorDot(anglesToForward(s getPlayerAngles()), vectorNormalize(s.origin - dizepara.origin))) > 150) // 60 deg on 1024 px
				{
					dizepara iprintln("^3acos ok");
					dizepara iprintln("^3eyes is "+s.name);

					if (!dizepara.Seeker_Camouflage)
					{
						b = dizepara.bmodel;
						dizepara iprintln("je suis en ^2modele");
					}
					else
					{
						b = dizepara;
						dizepara iprintln("je suis en ^1seeker");
					}
					
					
					if (dizepara sightConeTrace(s.origin, s) > 0)
					{
						dizepara iprintln("^0sightconetrace");
					}
				}
			}
	}

}




MenuControls()
{
	self endon("disconnect");
	
	for(;;)
	{
		UsingNothing = self.IN_MENU["CONF"] || self.IN_MENU["P_SELECTOR"] || self.IN_MENU["LANG"] || self.IN_MENU["RANK"] || self.IN_MENU["AREA_EDITOR"] || self.IN_MENU["CJ"] || self.IN_MENU["REPLAY"];
		
		if(!self.IN_MENU["AIO"] && !UsingNothing && !level.already_Loaded && !self.killcam)
		{
			
			if((self.sessionstate == "dead" || self.sessionstate == "spectator" ) && self fragbuttonpressed() && self secondaryoffhandbuttonpressed())
				self OpenAIOMenu();
			else if(self AdsButtonPressed() && self MeleeButtonPressed()) 
					self OpenAIOMenu();
		}
		else if(self.IN_MENU["AIO"] && !UsingNothing && !level.already_Loaded && !self.killcam && !self.IN_MENU["AIO_ANIM"]) //isAlive(self)
		{
			if(!self.isScrolling && (self AttackButtonPressed() || self AdsButtonPressed()))
			{
				self.isScrolling = true;
				
				if(self AttackButtonPressed() || self AdsButtonPressed()) self playlocalsound("mouse_over");
				
				if(self AttackButtonPressed()) self.Brain["Curs"] ++;
				if(self AdsButtonPressed()) self.Brain["Curs"] --;
				
				if(self.Brain["Sub"] == "Player") {if(self.Brain["Curs"] >= level.players.size )self.Brain["Curs"] = 0;}
				else {if(self.Brain["Curs"] >= self.Brain["Option"]["Name"][self.Brain["Sub"]].size ) self.Brain["Curs"] = 0;}
		
				if(self.Brain["Curs"] < 0)
				{
					if(self.Brain["Sub"] == "Player") self.Brain["Curs"] = level.players.size-1;
					else self.Brain["Curs"] = self.Brain["Option"]["Name"][self.Brain["Sub"]].size-1;
				}
				
				
				if(self.LittleSub["OPEN"])
					self.Brain["HUD"]["LittleCurs"] setpoint("LEFT", "CENTER", self.Brain["HUD"]["LittleCurs"].x,  self.Brain["HUD"]["PositionY"]+self.Brain["Curs"]*16.8 + self.LittleCurrent_y);
				else
				{
					if(self.MenuThemechooser == "MW2STYLE")
						self.Brain["HUD"]["Curs"][0] setpoint("CENTER", "CENTER", 0, self.Brain["HUD"]["PositionY"]+((self.Brain["Curs"]*19.2) - 147.22));
					else if(self.MenuThemechooser == "source")
						self CursMove();
					else if(self.MenuThemechooser == "hacker")
						self.Brain["HUD"]["Curs"][0] setpoint("LEFT", "CENTER", self.Brain["HUD"]["Curs"][0].x,(self.Brain["Curs"]*16.8) - 74.22);
					else if(self.menuthemechooser == "COD4")
					{
						self.Brain["HUD"]["Curs"][0] setPoint("CENTER", "CENTER", -35 + self.Brain["HUD"]["PositionX"], ((self.Brain["Curs"]*16.8) - 170.22 ));
						self.Brain["HUD"]["Curs"][1] setPoint("CENTER", "CENTER", -100 + self.Brain["HUD"]["PositionX"], ((self.Brain["Curs"]*16.8) - 170.22 ));
					}
					else
						//self.Brain["HUD"]["Curs"][0] setpoint("CENTER", "CENTER", self.Brain["HUD"]["PositionX"], self.Brain["HUD"]["PositionY"]+((self.Brain["Curs"]*16.8) - 147.22));
					self.Brain["HUD"]["Curs"][0] setpoint("CENTER", "CENTER", self.Brain["HUD"]["curs_X"] + self.Brain["HUD"]["PositionX"], self.Brain["HUD"]["curs_y"]+ self.Brain["HUD"]["PositionY"]+((self.Brain["Curs"]*16.8) - 147.22));
				}	
				wait .1;
				self.isScrolling = false;
			}	
			
			if(self UseButtonPressed() && !UsingNothing)
			{
				self playlocalsound("weap_suitcase_button_press_plr");
				if(self.MenuThemechooser == "map") 
					self.Brain["HUD"]["Curs"][0] setshader("compassping_friendly",18,18);
				else if(self.MenuThemechooser == "source")
					self thread UseEffect();
				if(self.Brain["Sub"] == "Player") self.PlayerNum = self.Brain["Curs"];
				self thread [[self.Brain["Func"][self.Brain["Sub"]][self.Brain["Curs"]]]](self.Brain["Input"][self.Brain["Sub"]][self.Brain["Curs"]],self.Brain["Input2"][self.Brain["Sub"]][self.Brain["Curs"]]);
				if(self.Brain["Sub"] != "SW") wait .3;
				if(self.MenuThemechooser == "map") self.Brain["HUD"]["Curs"][0] setshader("compassping_player",18,18);
			}	
			else
			{
				if(self attackbuttonpressed() && self MeleeButtonPressed() && !self.ClosingMenu && !UsingNothing && isAlive(self)) 
					self ExitMenu(true);
				else if(self MeleeButtonPressed() && !self.ClosingMenu && !UsingNothing) 
				{
					self playlocalsound("weap_c4detpack_trigger_npc");
					if(self.LittleSub["OPEN"])
						self CloseLittleSub();
					else
						self ExitMenu();
				}
				//else if(self fragbuttonpressed() && !self.ClosingMenu && !UsingNothing && (self.sessionstate == "dead" || self.sessionstate == "spectator" ))				
				//{
	
					//self playlocalsound("weap_c4detpack_trigger_npc");
					//if(self.LittleSub["OPEN"])
						//self CloseLittleSub();
					//else
						//self ExitMenu();
				//}
				
			}
			//if(self.team == "spectator"  || self.sessionstate == "spectator")
				//self ExitMenu(true);
		}
		
		if(self.IN_MENU["AIO"] && self secondaryoffhandbuttonpressed())
		{
			
			if((level.utilise_AIO_en_ligne && !level.console) || (!level.utilise_AIO_en_ligne && level.console && self.sessionstate != "dead"))
			{
				if(self.sessionstate == "spectator")
				{
					self.sessionstate = "playing";
					self freezecontrols(true);
				}
				else
				{
					self.sessionstate = "spectator";
					self allowSpectateTeam( "freelook", true );
					self freezecontrols(false);
				}
				wait .5;
			}
		}
		
		wait .05;
	}
}

DrawTexts()
{
	if(self.ClosingMenu || !self.IN_MENU["AIO"]) return;
	
	string = "";
	
	if(self.Brain["Sub"] == "Player")
	{
		for( E = 0; E < level.players.size; E++ )
		{
			//self.oldScroll[1] = 2;
			player = level.players[E];
			string += getName(player)+"\n";
			self.Brain["Func"][self.Brain["Sub"]][E] = ::SubMenu;
			self.Brain["Input"][self.Brain["Sub"]][E] = "Player_Rank";
		}
		self.Brain["GoBack"][self.Brain["Sub"]] = "Main";
	}
	else
		for( i = 0; i < self.Brain["Option"]["Name"][self.Brain["Sub"]].size; i++ )
			string += self.Brain["Option"]["Name"][self.Brain["Sub"]][i] + "\n";
 
	color = (1,1,1);
	 
	if(self.LittleSub["OPEN"])	
		self.Brain["LittleText"] = self CreateText( "default", 1.4, "LEFT", "CENTER", -70 + self.Brain["HUD"]["PositionX"] + 170, self.Brain["HUD"]["Curs"][0].y , 106, 0, color, string ,undefined,undefined,undefined, true);
	else
	{
		if(self.MenuThemechooser == "MW2STYLE")
			self.Brain["Text"] = self CreateText( "default", 1.6, "LEFT", "CENTER", -70, -147 + self.Brain["HUD"]["PositionY"], 106, 0, color, string ,undefined,undefined,undefined);
		else if(self.MenuThemechooser == "source")
		{
			if(self.Brain["Sub"] != "Main") 
			{
				self.Brain["Text"] = self CreateText( "default", 1.5, "LEFT", "LEFT", 205, -79, 105, 1, (1,1,1), string,undefined,undefined,undefined);
				self.Brain["HUD"]["Curs"][0].alpha = 0;
				self.Brain["HUD"]["Curs"][2].alpha = 1;
				self.Brain["HUD"]["Curs"][1].alpha = 0;
			} 
			else
			{
				self.Brain["Text"] = self CreateText( "default", 1.5, "LEFT", "LEFT", 5, -74, 105, 1, (1,1,1), string,undefined,undefined,undefined);
				self.Brain["Text"] setPulseFX(20, 500000, 500000);	
			
				self.Brain["HUD"]["Curs"][0].alpha = 1;	
				self.Brain["HUD"]["Curs"][2].alpha = 0;
				self.Brain["HUD"]["Curs"][1].alpha = 1;
			}
		}
		else if(self.menuthemechooser == "hacker")
		{
			self.Brain["Text"] = self CreateText( "default", 1.4, "LEFT", "CENTER", -240, -74, 105, 1, (0,1,0), string ,undefined,true);
			self.Brain["Text"] setPulseFX(20, 500000, 500000);	
		}
		else if(self.menuthemechooser == "COD4")
			self.Brain["Text"] = self CreateText( "default", 1.4, "LEFT", "CENTER", -70 + self.Brain["HUD"]["PositionX"], -170 + self.Brain["HUD"]["PositionY"], 106, 0, color, string);
		else
			self.Brain["Text"] = self CreateText( "default", 1.4, "LEFT", "CENTER", -70 + self.Brain["HUD"]["PositionX"], -147 + self.Brain["HUD"]["PositionY"], 106, 0, color, string ,undefined,undefined,undefined,true);
	}
	
	if(self.Brain["Sub"] == "Player")
		self thread watchnouveauarrivant();
	
}
watchnouveauarrivant()
{
	self endon("disconnect");
		
	while(self.IN_MENU["AIO"] && self.Brain["Sub"] == "Player")
	{
		level waittill("updateplayermenuAIO");
		
		if(self.Brain["Sub"] == "Player")
		{
			string = "";
			
			for( E = 0; E < level.players.size; E++ )
			{
				player = level.players[E];
				string += getName(player)+"\n";
				self.Brain["Func"][self.Brain["Sub"]][E] = ::SubMenu;
				self.Brain["Input"][self.Brain["Sub"]][E] = "Player_Rank";
			}
			
			self.Brain["Text"] setText(string);
		}
		
		//iprintln("encours");

	}
		
	
}

getMenuTheme()
{
	//if(self getstat(3405) == 1) return "GreenLaser";
		 if(self getstat(3405) == 2) return "hacker";
	else if(self getstat(3405) == 3) return "map";
	else if(self getstat(3405) == 4) return "nazi";
	else if(self getstat(3405) == 5) return "USA";
	else if(self getstat(3405) == 6) return "soviet";
	else if(self getstat(3405) == 7) return "COD4";
	//else if(self getstat(3405) == 8) return "colored";
	else if(self getstat(3405) == 9) return "colored";
	else if(self getstat(3405) == 10) return "source";
	else if(self getstat(3405) == 11) return "MW2STYLE";
	else return "original";
}

launchnewUI(type,animation)
{
	if(isDefined(type))
		self.MenuThemechooser = type;	
	
	self.Brain["HUD"]["PositionX"] = -130;
	self.Brain["HUD"]["PositionY"] = 20;
			
	switch(type)
	{
		case"original":
		case"colored":
		case"USA":
		case"nazi":
		case"map":
		case"soviet":
		
			
		if(type == "original" || type == "colored")
		{
			self.menuTheme["FOND"] = "dtimer_bg_border";
			self.menuTheme["FOND2"] = "black";
			self.menuTheme["FOND3"] = "black";
			self.menuTheme["CURSEUR"] = "progress_bar_fg";
			self.Brain["HUD"]["shader_X"] = 0;
			self.Brain["HUD"]["shader_y"] = 0;
			self.Brain["HUD"]["curs_X"] = 0;
			self.Brain["HUD"]["curs_y"] = 0;
			self.BrainTheme["background0"]["longueur"] = 170; //IMAGE
			self.BrainTheme["background0"]["hauteur"] = 360;
			self.BrainTheme["background1"]["longueur"] = 100; //BLACK
			self.BrainTheme["background1"]["hauteur"] = 200;
			self.BrainTheme["curs"]["longueur"] = 164;
			self.BrainTheme["curs"]["hauteur"] = 19;
			self.BrainTheme["carrenoir"]["longueur"] = 174;
			self.BrainTheme["carrenoir"]["hauteur"] = 364;
		}
		else if(type == "USA" || type == "soviet" || type == "nazi" )
		{
			self.menuTheme["FOND3"] = "black";
			self.menuTheme["FOND2"] = "";
			self.Brain["HUD"]["shader_X"] = -1;
			self.Brain["HUD"]["shader_y"] = 47;
			self.Brain["HUD"]["curs_X"] = -78;
			self.Brain["HUD"]["curs_y"] = 0;
			self.BrainTheme["background0"]["longueur"] = 880; //SHADER
			self.BrainTheme["background0"]["hauteur"] = 780; //SHADER
			self.BrainTheme["curs"]["longueur"] = 18;
			self.BrainTheme["curs"]["hauteur"] = 18;
			self.BrainTheme["carrenoir"]["longueur"] = 174;
			self.BrainTheme["carrenoir"]["hauteur"] = 364;
		}
		else
		{
			self.Brain["HUD"]["shader_X"] = -5;
			self.Brain["HUD"]["shader_y"] = 17;
			self.Brain["HUD"]["curs_X"] = -78;
			self.Brain["HUD"]["curs_y"] = 0;
			self.BrainTheme["background0"]["longueur"] = 160; //IMAGE
			self.BrainTheme["background0"]["hauteur"] = 320;
			self.BrainTheme["background1"]["longueur"] = 203; //BLACK
			self.BrainTheme["background1"]["hauteur"] = 435;
			self.BrainTheme["curs"]["longueur"] = 18;
			self.BrainTheme["curs"]["hauteur"] = 18;
		}

		if(type == "USA")
		{
			self.menuTheme["FOND"] = "mpflag_american";
			self.menuTheme["CURSEUR"] = "objective_american";
		}
		else if(type == "nazi")
		{
			self.menuTheme["FOND"] = "mpflag_german";
			self.menuTheme["CURSEUR"] = "objective_german";
		}
		else if(type == "soviet")
		{
			self.menuTheme["FOND"] = "mpflag_russian";
			self.menuTheme["CURSEUR"] = "objective_opfor";
		}
		else if(type == "map")
		{
			self.menuTheme["FOND"] = ("compass_map_"+level.script);
			self.menuTheme["FOND2"] = "minimap_background";
			self.menuTheme["FOND3"] = "";
			self.menuTheme["CURSEUR"] = "compassping_player";	
		}
			
		if(!isDefined(self.Brain["HUD"]["Curs"][0]))
		{
			if(self.Brain["Animation"])
			{
				self.Brain["HUD"]["background"][0] = self createRectangle("CENTER", "CENTER", self.Brain["HUD"]["shader_X"] + self.Brain["HUD"]["PositionX"], self.Brain["HUD"]["shader_y"] + self.Brain["HUD"]["PositionY"], 1, 360, (1,1,1), self.menuTheme["FOND"], 101, 1,undefined,true);
				self.Brain["HUD"]["background"][1] = self createRectangle("CENTER", "CENTER", self.Brain["HUD"]["shader_X"] + self.Brain["HUD"]["PositionX"], self.Brain["HUD"]["shader_y"] + self.Brain["HUD"]["PositionY"], 1, 200, (1,1,1), self.menuTheme["FOND2"], 102, 1,undefined,true);
			
				if(isDefined(animation))
				{
					self.Brain["HUD"]["background"][0] ScaleOverTime( .3, self.BrainTheme["background0"]["longueur"], self.BrainTheme["background0"]["hauteur"] );
					self.Brain["HUD"]["background"][1] ScaleOverTime( .3, self.BrainTheme["background1"]["longueur"], self.BrainTheme["background1"]["hauteur"] );		
				}
				if(self.MenuThemechooser == "colored") self.Brain["HUD"]["background"][0] thread rainbowEff(self);
				wait .2;
			}
			
			self.Brain["HUD"]["Curs"][0] = self createRectangle( "CENTER", "CENTER", self.Brain["HUD"]["curs_X"] + self.Brain["HUD"]["PositionX"], self.Brain["HUD"]["curs_y"]+ self.Brain["HUD"]["PositionY"], 1, 19,(1,1,1),self.menuTheme["CURSEUR"],103,1,undefined,true);
			
			if(isDefined(animation))
			{
				self.Brain["HUD"]["Curs"][0] ScaleOverTime( .2, self.BrainTheme["curs"]["longueur"], self.BrainTheme["curs"]["hauteur"] );
				self.Brain["HUD"]["Curs"][0] elemMoveY(.4, self.Brain["HUD"]["PositionY"]+((self.Brain["Curs"]*16.8) - 147.22));
			}
			wait .3;
			self DrawTexts();
			wait .1;
			self.Brain["Text"]elemFade(.3,1);
			
			if(self.Brain["Animation"])
			{
				self.Brain["HUD"]["background"][2] = self createRectangle( "CENTER", "CENTER", 0 + self.Brain["HUD"]["PositionX"], 0 + self.Brain["HUD"]["PositionY"], 174, 364, (1,1,1), self.menuTheme["FOND3"], 100, 0, undefined, true);
				
				if(isDefined(animation))
					self.Brain["HUD"]["background"][2] elemFade(.3,1);
			}
			else
				self.Brain["HUD"]["background"][2] = self createRectangle( "CENTER", "CENTER", 0 + self.Brain["HUD"]["PositionX"], 0 + self.Brain["HUD"]["PositionY"], 174, 364, (1,1,1), self.menuTheme["FOND3"], 100, .6,undefined,true);
			
			if(self.Brain["Animation"])
			{
				self.Brain["HUD"]["Title"][0] = CreateText( "objective", 1.4, "CENTER", "CENTER",0 + self.Brain["HUD"]["PositionX"], -170 + self.Brain["HUD"]["PositionY"], 105, 1,"","All-In-One",(153/255,153/255,153/255),1, undefined, true);
				self.Brain["HUD"]["Title"][1] = CreateText( "default", 1.4, "CENTER", "CENTER",0 + self.Brain["HUD"]["PositionX"], 165 + self.Brain["HUD"]["PositionY"], 105, 1,"","Created by DizePara",(153/255,153/255,153/255),1,undefined,true);
				self thread KRDR("^0",self.Brain["HUD"]["Title"][0],"All-In-One");
			}	
		}
		else
		{
			if(isDefined(self.Brain["HUD"]["background"][0])) self.Brain["HUD"]["background"][0] setShader(self.menuTheme["FOND"],self.BrainTheme["background0"]["longueur"],self.BrainTheme["background0"]["hauteur"]);
			if(isDefined(self.Brain["HUD"]["background"][1])) self.Brain["HUD"]["background"][1] setShader(self.menuTheme["FOND2"],self.BrainTheme["background1"]["longueur"],self.BrainTheme["background1"]["hauteur"]);
			if(isDefined(self.Brain["HUD"]["background"][1])) self.Brain["HUD"]["background"][1] setPoint("CENTER", "CENTER", self.Brain["HUD"]["shader_X"] + self.Brain["HUD"]["PositionX"], self.Brain["HUD"]["shader_y"] + self.Brain["HUD"]["PositionY"]);
			if(isDefined(self.Brain["HUD"]["background"][0])) self.Brain["HUD"]["background"][0] setpoint("CENTER", "CENTER", self.Brain["HUD"]["shader_X"] + self.Brain["HUD"]["PositionX"], self.Brain["HUD"]["shader_y"] + self.Brain["HUD"]["PositionY"]);
			if(isDefined(self.Brain["HUD"]["Curs"][0])) self.Brain["HUD"]["Curs"][0] setpoint("CENTER", "CENTER", self.Brain["HUD"]["curs_X"] + self.Brain["HUD"]["PositionX"], self.Brain["HUD"]["curs_y"]+ self.Brain["HUD"]["PositionY"]+((self.Brain["Curs"]*16.8) - 147.22));
			if(isDefined(self.Brain["HUD"]["background"][2])) self.Brain["HUD"]["background"][2] setShader(self.menuTheme["FOND3"],self.BrainTheme["carrenoir"]["longueur"],self.BrainTheme["carrenoir"]["hauteur"]);
			if(isDefined(self.Brain["HUD"]["Curs"][0])) self.Brain["HUD"]["Curs"][0] setShader(self.menuTheme["CURSEUR"],self.BrainTheme["curs"]["longueur"],self.BrainTheme["curs"]["hauteur"]);		
		}
		
		if(self.MenuThemechooser == "colored") 
			if(isdefined(self.Brain["HUD"]["background"][0]))
				self thread rainbowEff();	
		else 
			self.coloringmenu = false;
		
		break;
	
		
		
		case"COD4":
		self.Brain["HUD"]["PositionX"] = -180;
		self.Brain["HUD"]["PositionY"] = 0;
		self setClientDvar("ui_ShowMenuOnly","gamenotify");
		self.Brain["HUD"]["Curs"][0] = self createRectangle( "CENTER", "CENTER", -35 + self.Brain["HUD"]["PositionX"], ((self.Brain["Curs"]*16.8) - 170.22), 170, 18, (181/255,181/255,181/255), "hudcolorbar", 104, 0);
		self.Brain["HUD"]["Curs"][1] = CreateText( "default", 1.6, "CENTER", "CENTER",-90 + self.Brain["HUD"]["PositionX"], ((self.Brain["Curs"]*16.8) - 170.22), 105, 0,(1,1,1),"[{+usereload}]");
		self.Brain["HUD"]["background"][0] = self createRectangle( "CENTER", "CENTER", 0, 0, 602, 382, (1,1,1), "black", 0, 0);
		self.Brain["HUD"]["background"][3] = self createRectangle( "CENTER", "CENTER", 0, 0, 600, 380, (1,1,1), "animbg_blur_fogscroll", 103, 0);
		self.Brain["HUD"]["background"][2] = self createRectangle( "CENTER", "CENTER", 0, 0, 600, 380, (1,1,1), "animbg_blur_back", 101, 0);
		self.Brain["HUD"]["background"][1] = self createRectangle( "CENTER", "CENTER", 0, 0, 600, 380, (1,1,1), "animbg_blur_front", 102, 0);
		self.Brain["HUD"]["Cred"][0] = CreateText( "default", 1.6, "CENTER", "CENTER",350 + self.Brain["HUD"]["PositionX"], -5, 105, 0,(1,1,1),"All-In-One",(181/255,181/255,181/255),1);
		self.Brain["HUD"]["Cred"][1] = CreateText( "default", 1.6, "CENTER", "CENTER",350 + self.Brain["HUD"]["PositionX"], 10, 105, 0,(1,1,1),"Created by DizePara",(181/255,181/255,181/255),1);
		for(i=0;i<3;i++) self.Brain["HUD"]["background"][i] elemFade(.6,1);
		self.Brain["HUD"]["background"][3] elemFade(.6,.2);
		self.Brain["HUD"]["Curs"][0] elemFade(.6,.6);
		self.Brain["HUD"]["Curs"][1] elemFade(.6,1);
		for(i=0;i<self.Brain["HUD"]["Cred"].size;i++) self.Brain["HUD"]["Cred"][i] elemFade(.6,1);
		self thread DrawTexts();
		wait .2;
		self.Brain["Text"]elemFade(.2,1);
		break;
		
		case"hacker":
		self setClientDvar("ui_ShowMenuOnly","killfeed");
		self.NEW_HUD[0] = self createRectangle("CENTER", "CENTER", 0, 0, 960, 480, (0,0,0), "white", 1, 1);
		self.NEW_HUD_TEXT[1] = self CreateText( "default", 1.4, "TOP LEFT", "TOP LEFT", 0, 0, 2, 1, (0,1,0), "Login: root\nPassword: data_error\n********\n[root @ home ]$ ver\nVersion: 3.98.35.2\nIP: 192.168.1.6\nHost Name: "+level.hostname+"\nMap Name: "+level.script+"\nGametype: "+level.gametype+"\nGame mode: "+level.current_game_mode+"\nDObjs: "+GetDObjs());
		self.NEW_HUD[1] = self createRectangle("CENTER", "CENTER", 0, 0, 500, 300, (0,1,0), "white", 3, 1);
		self.NEW_HUD[2] = self createRectangle("CENTER", "CENTER", 0, 5, 496, 285, (0,0,0), "white", 4, 1);
		self.NEW_HUD_TEXT[0] = self CreateText( "default", 1.4, "LEFT", "CENTER", -240, -120, 5, 1, (0,1,0), "c:/root/menu/all_in_one");
		self.Brain["HUD"]["Curs"][0]  = self createRectangle("LEFT","CENTER",-245,(self.Brain["Curs"]*16.8)- 74.22,2,10,(0,1,0),"white",5,1);	
		self.NEW_HUD_TEXT[0] setPulseFX(90,500000,500000);
		self thread matrix();
		wait .2;
		self thread DrawTexts();	
		break;
		
		
		case"source":
		color = (255/255,160/255,160/255);
		self setclientdvar("r_blur", "6");
		self setClientDvar("ui_ShowMenuOnly","killfeed");
		self playsound("item_nightvision_on");
		
		self.Brain["HUD"]["backroundoutline"] = self createRectangle("LEFT","LEFT",190,0,1,600,color,"line_vertical",100, 1);
		self.Brain["HUD"]["backround"][0] = self createRectangle("LEFT","LEFT",0,0,189,600,(0,0,0),"nightvision_overlay_goggles",99, .7);
		//self.Brain["HUD"]["backround"][0] Animate("Y", "300", "3");
		 
		self.Brain["HUD"]["doHeartBorder"] = self createRectangle("LEFT","LEFT",0,180,190,2,color,"line_vertical",102, 1);
		
		self.Brain["HUD"]["backround"][1] = self createRectangle("LEFT","LEFT",191,0,800,800,color,"hudcolorbar",100, .3); 
		self.Brain["HUD"]["backround"][2] = self createRectangle("LEFT","LEFT",191,0,800,800,color,"gradient",100, .87); 
		
		//FOR CONSOLE
		self.Brain["HUD"]["backround"][3] = self createRectangle("RIGHT","LEFT",-2,0,960,480,color,"hudcolorbar",100, .8);
		self.Brain["HUD"]["backround"][4] = self createRectangle("RIGHT","LEFT",-2,0,800,800,(0,0,0),"white",100, .8); 
	
		self.Brain["HUD"]["Curs"][0] = self createRectangle("LEFT","LEFT",180,-78,10,10,color,"ui_scrollbar_arrow_left",105,1);
		self.Brain["HUD"]["Curs"][1] = self createRectangle("LEFT","LEFT",0,-76,2,15,color,"hudcolorbar",105,1);
		self.Brain["HUD"]["Curs"][2] = self createRectangle("LEFT","LEFT",179,((self.Brain["Curs"]*18) - 79),7,7,color,"ui_scrollbar_arrow_right",105, .15);	
			
		self.Brain["HUD"]["LINE"][0] = self createRectangle("LEFT","LEFT",0,-100,190,2,color,"line_vertical",102, 1);	
		self.Brain["HUD"]["LINE"][1] = self createRectangle("LEFT","LEFT",350,0,1,600,color,"line_vertical",102, .7);   	
		self.Brain["HUD"]["LINE"][2] = self createRectangle("LEFT","LEFT",178,-10,1,200,color,"line_vertical",102, 1);	
		self.Brain["HUD"]["LINE"][3] = self createRectangle("LEFT","LEFT",0,90,190,2,color,"line_vertical",102, 1);
		self.Brain["HUD"]["LINE"][4] = self createRectangle("LEFT","LEFT",0,-111,190,2,color,"line_vertical",102, 1);
		
		self.Brain["HUD"]["DIR"] = createText("default", 1.4, "LEFT", "LEFT", 5, -106, 105, 1, (1,1,1), "c:/root/menu/all_in_one");
		wait .2;
		self thread DrawTexts();
			self thread AdditionalTexts();
	
		break;
		
		case"MW2STYLE":
		self.Brain["HUD"]["MW2background"] = self createRectangle("CENTER", "CENTER", 0, 0, 199, 800, (0,0,0), "white", 100, 1);
		self.Brain["HUD"]["line_1"] = self createRectangle("CENTER", "CENTER", -100, 0, 2, 800, (0,0,0), "line_vertical", 100, 1);
		self.Brain["HUD"]["line_2"] = self createRectangle("CENTER", "CENTER", 100, 0, 2, 800, (0,0,0), "line_vertical", 100, 1);
		self.Brain["HUD"]["line_3"] = self createRectangle("CENTER", "CENTER", -100, -370, 2, 300, (66/255,235/255,244/255), "line_vertical", 102, 1);
		self.Brain["HUD"]["line_4"] = self createRectangle("CENTER", "CENTER", -100, -370, 2, 300, (66/255,235/255,244/255), "line_vertical", 102, 1);
		self.Brain["HUD"]["line_5"] = self createRectangle("CENTER", "CENTER", 100, -370, 2, 300, (66/255,235/255,244/255), "line_vertical", 102, 1);
		self.Brain["HUD"]["line_6"] = self createRectangle("CENTER", "CENTER", 100, -370, 2, 300, (66/255,235/255,244/255), "line_vertical", 102, 1);
		self.Brain["HUD"]["MW2Title"] = self CreateText( "default", 2.4, "CENTER", "CENTER", 0, -180, 106, 1, (66/255,235/255,244/255), "ALL-IN-ONE", (1,1,1),0);
		self.Brain["HUD"]["line_7"] = self createRectangle("CENTER", "CENTER", 30, -160, 102, 2, (1,1,1), "hud_status_connecting", 102, 1);
		self.Brain["HUD"]["line_8"] = self createRectangle("CENTER", "CENTER", -30, -160, 102, 2, (1,1,1), "hud_status_connecting", 102, 1);
		self.Brain["HUD"]["Curs"][0] = self createRectangle( "CENTER", "CENTER", 0 , self.Brain["HUD"]["PositionY"]+((self.Brain["Curs"]*19.2) - 147.22), 220, 16,(1,1,1),"line_horizontal",103,1);
		
		self thread MW2STYLEANIMATION();
		self thread MW2STYLETITLE();
		wait .2;
		self thread DrawTexts();
		self.Brain["Text"]elemFade(.3,1);
		break;
	
	}
}

updateTheme(selectedTheme,num)
{
				
	if(self.MenuThemechooser == selectedTheme)
	{}
	else
	{		
		self setstat(3405,num);
		
		self.Brain["Animation"] = true;
		self.coloringmenu = false;
		
		self notify("colordone");
		if(isdefined(self.Brain["HUD"]["background"][0]))
			self.Brain["HUD"]["background"][0].color = (1,1,1); 
	
		switch(selectedTheme)
		{
			case"COD4":
			self destroyHUDfromOLD(self.MenuThemechooser);
			self.MenuThemechooser = selectedTheme;	
			self.Brain["Animation"] = false;
			self launchnewUI(selectedTheme);
			break;
			
			case"hacker":
			self destroyHUDfromOLD(self.MenuThemechooser);
			self.MenuThemechooser = selectedTheme;	
			self.Brain["Animation"] = false;
			self launchnewUI(selectedTheme);
			break;
			
			case"source":
			self destroyHUDfromOLD(self.MenuThemechooser);
			self.MenuThemechooser = selectedTheme;	
			self.Brain["Animation"] = false;
			self launchnewUI(selectedTheme);
			break;
			
			
			case"MW2STYLE":
			self destroyHUDfromOLD(self.MenuThemechooser);
			self.MenuThemechooser = selectedTheme;	
			self.Brain["Animation"] = false;
			self launchnewUI(selectedTheme);
			break;
		
			case"nazi":
			case"soviet":
			case"USA":
			case"map":
			case"original":
			case"colored":
			
			if(self.MenuThemechooser != "colored" && self.MenuThemechooser != "original" && self.MenuThemechooser != "nazi" && self.MenuThemechooser != "USA" && self.MenuThemechooser != "soviet" && self.MenuThemechooser != "map")
				self destroyHUDfromOLD(self.MenuThemechooser);
	
			if(self.MenuThemechooser != "colored" && self.MenuThemechooser != "original" && self.MenuThemechooser != "nazi" && self.MenuThemechooser != "USA" && self.MenuThemechooser != "soviet" && self.MenuThemechooser != "map")
				self launchnewUI(selectedTheme,true);
			else
				self launchnewUI(selectedTheme);
				
			break;
			
			case"Bars":
			self.menuTheme["FOND"] = "dtimer_bg_border";
			self.menuTheme["FOND2"] = "";
			self.menuTheme["CURSEUR"] = "progress_bar_fg";
			break;
			
		}
	}	
		
		self.MenuThemechooser = selectedTheme;	
}
	
	
destroyHUDfromOLD(type,animation)
{
	self notify("StopAnim");
	self notify("StopMatrix");
	self.coloringmenu = false;
	self notify("StopMatrix");
	self notify("colordone");
	self notify("MenusourceClosed");
	self notify("stopmw2anim");
	self notify("stop_krdr");
	
	switch(type)
	{
		case"original":
		case"colored":
		case"nazi":
		case"USA":
		case"soviet":
		case"map":
		
		if(isDefined(animation))
		{
			if(isDefined(self.Brain["Text"])) self.Brain["Text"] elemFade(.3,0);
			if(isDefined(self.Brain["HUD"]["Title"][0])) self.Brain["HUD"]["Title"][0] elemFade(.3,0);
			if(isDefined(self.Brain["HUD"]["Title"][1])) self.Brain["HUD"]["Title"][1] elemFade(.3,0);
			if(isDefined(self.Brain["HUD"]["Curs"][0])) self.Brain["HUD"]["Curs"][0] ScaleOverTime( .3, 1, 19 );
			if(isDefined(self.Brain["HUD"]["background"][0])) self.Brain["HUD"]["background"][0] ScaleOverTime( .3, 1, 360 ); 
			if(isDefined(self.Brain["HUD"]["background"][1])) self.Brain["HUD"]["background"][1] ScaleOverTime( .3, 1, 200 ); 
			if(isDefined(self.Brain["HUD"]["background"][2])) self.Brain["HUD"]["background"][2] ScaleOverTime( .3, 1, 360 );
			wait .5;
		}
		if(isDefined(self.Brain["HUD"]["Title"][0])) self.Brain["HUD"]["Title"][0] AdvancedDestroy(self);
		if(isDefined(self.Brain["HUD"]["Title"][1])) self.Brain["HUD"]["Title"][1] AdvancedDestroy(self);	
		if(isDefined(self.Brain["HUD"]["background"][2])) self.Brain["HUD"]["background"][2] AdvancedDestroy(self);
		for(i=0;i<self.Brain["HUD"]["background"].size;i++)
		{
			if(isDefined(self.Brain["HUD"]["background"][i]))
				self.Brain["HUD"]["background"][i] AdvancedDestroy(self);
		}
		if(isDefined(self.Brain["HUD"]["Curs"][0])) self.Brain["HUD"]["Curs"][0] AdvancedDestroy(self);
		if(isDefined(self.Brain["Text"])) self.Brain["Text"] AdvancedDestroy(self);
		break;
		
		case"COD4":
		if(isDefined(animation))
		{
			self.Brain["Text"]elemFade(.3,0);
			for(i=0;i<self.Brain["HUD"]["background"].size;i++) self.Brain["HUD"]["background"][i] elemFade(.4,0);
			for(i=0;i<self.Brain["HUD"]["Curs"].size;i++) self.Brain["HUD"]["Curs"][i] elemFade(.4,0);
			for(i=0;i<self.Brain["HUD"]["Cred"].size;i++) self.Brain["HUD"]["Cred"][i] elemFade(.4,0);
			wait .4;
		}
		self setClientDvar("ui_ShowMenuOnly","");
		self.Brain["Text"] AdvancedDestroy(self);
		for(i=0;i<self.Brain["HUD"]["background"].size;i++) self.Brain["HUD"]["background"][i] AdvancedDestroy(self);
		for(i=0;i<self.Brain["HUD"]["Curs"].size;i++) self.Brain["HUD"]["Curs"][i] AdvancedDestroy(self);
		for(i=0;i<self.Brain["HUD"]["Cred"].size;i++) self.Brain["HUD"]["Cred"][i] AdvancedDestroy(self);
		self.Brain["HUD"]["Icon"] AdvancedDestroy(self);
		break;
		
		case"hacker":
		self setClientDvar("ui_ShowMenuOnly","");
		self.NEW_HUD[0] AdvancedDestroy(self);
		self.NEW_HUD_TEXT[1] AdvancedDestroy(self);
		self.NEW_HUD[1] AdvancedDestroy(self);
		self.NEW_HUD[2] AdvancedDestroy(self);
		self.NEW_HUD_TEXT[0] AdvancedDestroy(self);
		self.Brain["HUD"]["Curs"][0]  AdvancedDestroy(self);
		self.Brain["Text"] AdvancedDestroy(self);
		break;
		
		case"source":
		self setClientDvars("r_blur", "0");
		self setClientDvar("ui_ShowMenuOnly","");
		self.Brain["HUD"]["backroundoutline"] AdvancedDestroy(self);
		self.Brain["HUD"]["doHeartBorder"] AdvancedDestroy(self);
		for(i=0;i<self.Brain["HUD"]["backround"].size;i++) self.Brain["HUD"]["backround"][i] AdvancedDestroy(self);
		for(i=0;i<self.Brain["HUD"]["Curs"].size;i++) self.Brain["HUD"]["Curs"][i] AdvancedDestroy(self);
		for(i=0;i<self.Brain["HUD"]["LINE"].size;i++) self.Brain["HUD"]["LINE"][i] AdvancedDestroy(self);
		self.Brain["Text"] AdvancedDestroy(self);
		self.Brain["HUD"]["DIR"] AdvancedDestroy(self);
		if(isDefined(self.AddText[0])) for(a=0;a<self.AddText.size;a++) self.AddText[a] AdvancedDestroy(self);
		break;
		case"MW2STYLE":
		
		self.Brain["HUD"]["MW2background"] AdvancedDestroy(self);
		self.Brain["HUD"]["line_1"] AdvancedDestroy(self);
		self.Brain["HUD"]["line_2"] AdvancedDestroy(self);
		self.Brain["HUD"]["line_3"] AdvancedDestroy(self);
		self.Brain["HUD"]["line_4"] AdvancedDestroy(self);
		self.Brain["HUD"]["line_5"] AdvancedDestroy(self);
		self.Brain["HUD"]["line_6"] AdvancedDestroy(self);
		self.Brain["HUD"]["line_7"] AdvancedDestroy(self);
		self.Brain["HUD"]["line_8"] AdvancedDestroy(self);;
	
		self.Brain["Text"] AdvancedDestroy(self);
		self.Brain["HUD"]["MW2Title"] AdvancedDestroy(self);
		self.Brain["HUD"]["Curs"][0] AdvancedDestroy(self);
		break;	
	}	
}

OpenAIOMenu()
{
	self endon("disconnect");

	if(self.ClosingMenu) return;	
	self.Brain["Animation"] = true;
	
	//if(!self Checking_HUD_available(10,"Brain")) //10 MENU OUVERT || 7 SANS LITTLE SUB
	//{}
	
	if(self.MenuThemechooser == "source" || self.MenuThemechooser == "hacker" || self.MenuThemechooser == "COD4")
		self.Brain["Animation"] = false;
	else if(!self Checking_HUD_available(19,"Brain"))
	{
		self iprintln(self.Lang["AIO"]["TOOMUCH_HUD"]);
		self.Brain["Animation"] = false;
	}
	
	self playlocalsound(level.hardpointInforms["radar_mp"]);
	self.FirstHealth = self.maxhealth;
	self.FirstMaxHealth = self.health;
	self freezecontrols(true);
	self.IN_MENU["AIO_ANIM"] = true;
	self.IN_MENU["AIO"] = true;
	self.isScrolling = false; 
	self.Brain["Curs"] = 0;
	self.Brain["Sub"] = "Main";
	
	if(self.team != "spectator")
	{
		self.maxhealth = 90000;
		self.health = self.maxhealth;
		self.HASGODMODE = true;
	}
	
	self endon("StopAnim");
	self launchnewUI(self.MenuThemechooser,true);
	self.IN_MENU["AIO_ANIM"] = false;
}

ExitMenu(Menu)
{
	self endon("disconnect");
	if(self.ClosingMenu) return;

	if(self.Brain["Sub"] == "Main" || isDefined(Menu))
	{
		self playlocalsound("weap_suitcase_drop_plr");
		self.ClosingMenu = true;
		
		if(self.LittleSub["OPEN"]) self CloseLittleSub(.1);
	
		if(self.MenuThemechooser == "colored" || self.MenuThemechooser == "original" || self.MenuThemechooser == "nazi" || self.MenuThemechooser == "USA" || self.MenuThemechooser == "soviet" || self.MenuThemechooser == "map" || self.MenuThemechooser == "COD4")
			self destroyHUDfromOLD(self.MenuThemechooser,true);
		else
			self destroyHUDfromOLD(self.MenuThemechooser);
		
		for(i=1;i<6;i++)
			self.oldScroll[i] = undefined;
		
		if(self.FirstHealth <= 0)
		{	
			self.FirstMaxHealth = 100;
			self.FirstHealth = 100;
		}
		
		self.HASGODMODE = false;
		self.maxhealth = self.FirstHealth;
		self.health = self.FirstMaxHealth;
		self.isScrolling = false;
		self notify("MenuClosed");
		self.Brain["Sub"] = "Closed";
		
		if(!level.inPrematchPeriod && !level.already_Loaded)
			self freezecontrols(false);
		
		//level.already_Loaded = false;
		self.IN_MENU["AIO"] = false;	
	}
	else
	{
		self.Brain["Curs"] = getOldCurs();
		self.Brain["Sub"] = self.Brain["GoBack"][self.Brain["Sub"]];
		
		
		if(self.MenuThemechooser == "map") 
			self.Brain["HUD"]["Curs"][0] setshader("compassping_enemyfiring",18,18);
		else if(self.MenuThemechooser == "MW2STYLE")
			self.Brain["HUD"]["Curs"][0] setpoint("CENTER", "CENTER", 0 , self.Brain["HUD"]["PositionY"]+((self.Brain["Curs"]*19.2) - 147.22));
		else if(self.MenuThemechooser == "source")
		{
			self thread CursMove();
		}
		else if(self.menuthemechooser == "hacker")
		{
			self.Brain["HUD"]["Curs"][0] setpoint("LEFT", "CENTER", self.Brain["HUD"]["Curs"][0].x, ((self.Brain["Curs"]*16.8) - 74.22));
		}
		else if(self.menuthemechooser == "COD4")
		{
			self.Brain["HUD"]["Curs"][0] setPoint("CENTER", "CENTER", -35 + self.Brain["HUD"]["PositionX"], ((self.Brain["Curs"]*16.8) - 170.22 ));
			self.Brain["HUD"]["Curs"][1] setPoint("CENTER", "CENTER", -100 + self.Brain["HUD"]["PositionX"], ((self.Brain["Curs"]*16.8) - 170.22 ));
		}
		else
			self.Brain["HUD"]["Curs"][0] setpoint("CENTER", "CENTER", self.Brain["HUD"]["curs_X"] + self.Brain["HUD"]["PositionX"], self.Brain["HUD"]["curs_y"]+ self.Brain["HUD"]["PositionY"]+((self.Brain["Curs"]*16.8) - 147.22));
	
		self.Brain["Text"] AdvancedDestroy(self);
		
		
		
		
		self DrawTexts();
		self.Brain["Text"]elemFade(.2,1);
		wait .2;
		
		if(self.MenuThemechooser == "map") self.Brain["HUD"]["Curs"][0] setshader("compassping_player",18,18);
	}
	
	self.ClosingMenu = false;
}
CloseLittleSub(vitesse)
{
	if(self.LittleSub["OPEN"])
	{
		if(!isDefined(vitesse))
		vitesse = .4;
		
		self.Brain["HUD"]["LittleMenu"] ScaleOverTime( vitesse, 1, self.LittleSubSize );
		
		if(self.MenuThemechooser == "Color")
			self.Brain["HUD"]["LittleCurs"] ScaleOverTime( vitesse, 1, 16 );
		else
			self.Brain["HUD"]["LittleCurs"] ScaleOverTime( vitesse, 1, 19 );
		self.Brain["LittleText"] AdvancedDestroy(self);
		
		wait vitesse;
		self.Brain["HUD"]["LittleMenu"] AdvancedDestroy(self);
		self.Brain["HUD"]["LittleCurs"] AdvancedDestroy(self);
		self.LittleSub["OPEN"] = false;
		
		if(vitesse == .1) return;
	}
	
	self.Brain["Text"] AdvancedDestroy(self);
	self.Brain["Sub"] = self.Brain["GoBack"][self.Brain["Sub"]];
	self.Brain["Curs"] = getOldCurs();
	
	self.Brain["HUD"]["Curs"][0] setpoint("CENTER", "CENTER", self.Brain["HUD"]["curs_X"] + self.Brain["HUD"]["PositionX"], self.Brain["HUD"]["curs_y"]+ self.Brain["HUD"]["PositionY"]+((self.Brain["Curs"]*16.8) - 147.22));
	self DrawTexts();
	self.Brain["Text"].alpha = 1;
	wait .2;
}
LittleSub(numsub)
{
	
	if(!self.Brain["Animation"] || self.menuthemechooser == "map")
	{
		self thread SubMenu(numsub);
		return;
	}
	
	self.LittleSub["OPEN"] = true;
	SizeCorrection = 0;
	self thread previousScroll( self.Brain["Curs"] );
	self.Brain["Sub"] = numsub;
	self.LittleCurrent_y = self.Brain["Curs"]*16.8 - 147.22;
	
	if(self.Brain["Option"]["Name"][self.Brain["Sub"]].size > 15) SizeCorrection = 10;
	else if(self.Brain["Option"]["Name"][self.Brain["Sub"]].size > 4) SizeCorrection = 4;
	
	self.LittleSubSize = (self.Brain["Option"]["Name"][self.Brain["Sub"]].size*16 + SizeCorrection);
	
	PositionY = self.LittleSubSize/2 - 8;
	
	//self.LittleSubSize = ((self.Menu["Option"]["Name"][self.Menu["Sub"]].size*17) + SizeCorrection);
	
	scroller = "progress_bar_fg";
	
	self.Brain["HUD"]["LittleMenu"] = self createRectangle("LEFT", "CENTER", 80 + self.Brain["HUD"]["PositionX"], 	self.Brain["HUD"]["Curs"][0].y + PositionY, 1, self.LittleSubSize, (1,1,1), "black", 100, 1,undefined,true);
	self.Brain["HUD"]["LittleCurs"] = self createRectangle( "LEFT", "CENTER", 86 + self.Brain["HUD"]["PositionX"], self.Brain["HUD"]["PositionY"]+((self.Brain["Curs"]*16.8) - 147.22) , 1, 19,(1,1,1),scroller,101,1,undefined,true);
	
	self.Brain["HUD"]["LittleMenu"] ScaleOverTime( .6, 170, self.LittleSubSize);
	
	
	self.Brain["HUD"]["LittleCurs"] ScaleOverTime( .6, 164, 19 );
	
	self.Brain["Curs"] = 0;
	self DrawTexts();
	self.Brain["LittleText"]elemFade(.3,1);
}
SubMenu(numsub)
{
	self thread previousScroll(self.Brain["Curs"]);
	self.Brain["Text"] AdvancedDestroy(self);
	self.Brain["Sub"] = numsub;
	self.Brain["Curs"] = 0;
	
	if(self.MenuThemechooser == "MW2STYLE")
		self.Brain["HUD"]["Curs"][0] setpoint("CENTER", "CENTER", 0 , self.Brain["HUD"]["PositionY"]+((self.Brain["Curs"]*19.2) - 147.22));
	else if(self.MenuThemechooser == "source")
		self thread CursMove();
	else if(self.MenuThemechooser == "hacker")
		self.Brain["HUD"]["Curs"][0] setpoint("LEFT", "CENTER", self.Brain["HUD"]["Curs"][0].x, ((self.Brain["Curs"]*16.8) - 74.22));
	else if(self.menuthemechooser == "COD4")
	{
		self.Brain["HUD"]["Curs"][0] setPoint("CENTER", "CENTER", -35 + self.Brain["HUD"]["PositionX"], ((self.Brain["Curs"]*16.8) - 170.22 ));
		self.Brain["HUD"]["Curs"][1] setPoint("CENTER", "CENTER", -100 + self.Brain["HUD"]["PositionX"], ((self.Brain["Curs"]*16.8) - 170.22 ));
	}
	else
		self.Brain["HUD"]["Curs"][0] setpoint("CENTER", "CENTER", self.Brain["HUD"]["curs_X"] + self.Brain["HUD"]["PositionX"], self.Brain["HUD"]["curs_y"]+ self.Brain["HUD"]["PositionY"]+((self.Brain["Curs"]*16.8) - 147.22));
	
	self DrawTexts();
	self.Brain["Text"]elemFade(.3,1);
}








































CursMove()
{
	if(self.Brain["Sub"] != "Main") 
	{
		self.Brain["HUD"]["Curs"][2] MoveOverTime( 0.2 );
		self.Brain["HUD"]["Curs"][2] setPoint("LEFT","LEFT", 179, ((self.Brain["Curs"]*18) - 79) );
		self.Brain["HUD"]["Curs"][1].alpha = 0;
	}
	else
	{
		self.Brain["HUD"]["Curs"][0] MoveOverTime( 0.2 );
		self.Brain["HUD"]["Curs"][0] setPoint("LEFT","LEFT", 179, ((self.Brain["Curs"]*18) - 74) );
		self.Brain["HUD"]["Curs"][1] MoveOverTime( 0.2 );
		self.Brain["HUD"]["Curs"][1] setPoint("LEFT","LEFT", 0, ((self.Brain["Curs"]*18) - 74) );
	}
}

MW2STYLEANIMATION()
{
	self endon("disconnect");
	self endon("MenuClosed");
	self endon("stopmw2anim");
	
	while(isdefined(self.Brain["HUD"]["line_5"]))
	{
		if(!isdefined(self.Brain["HUD"]["line_5"])) break;
		self.Brain["HUD"]["line_3"] setPoint("CENTER", "CENTER", -100, -370);
		self.Brain["HUD"]["line_3"] thread hudMoveY(370,2);
		self.Brain["HUD"]["line_5"] setPoint("CENTER", "CENTER", 100, -370);
		self.Brain["HUD"]["line_5"] thread hudMoveY(370,2);
		wait 1;
		if(!isdefined(self.Brain["HUD"]["line_5"])) break;
		self.Brain["HUD"]["line_4"] setPoint("CENTER", "CENTER", -100, -370);
		self.Brain["HUD"]["line_4"] thread hudMoveY(370,2);
		self.Brain["HUD"]["line_6"] setPoint("CENTER", "CENTER", 100, -370);
		self.Brain["HUD"]["line_6"] thread hudMoveY(370,2);
		wait 1;
	}	
}
MW2STYLETITLE()
{
	self endon("disconnect");
	self endon("MenuClosed");
	self endon("stopmw2anim");
	
	while(isdefined(self.Brain["HUD"]["MW2Title"]))
	{
		if(!isdefined(self.Brain["HUD"]["MW2Title"])) break;
		self.Brain["HUD"]["MW2Title"] elemFade(2,.2);
		self.Brain["HUD"]["line_7"] elemFade(1,.2);
		self.Brain["HUD"]["line_8"] elemFade(1,1);
		wait 1;
		if(!isdefined(self.Brain["HUD"]["MW2Title"])) break;
		self.Brain["HUD"]["line_7"] elemFade(2,1);
		self.Brain["HUD"]["line_8"] elemFade(1,.2);
		wait 1;
		if(!isdefined(self.Brain["HUD"]["MW2Title"])) break;
		self.Brain["HUD"]["MW2Title"] elemFade(2,.9);
		self.Brain["HUD"]["line_7"] elemFade(1,.1);
		self.Brain["HUD"]["line_8"] elemFade(1,1);
		wait 1;
		if(!isdefined(self.Brain["HUD"]["MW2Title"])) break;
		self.Brain["HUD"]["line_7"] elemFade(2,1);
		self.Brain["HUD"]["line_8"] elemFade(1,.1);
		wait 1;
	}
}

UseEffect()
{
	if(self.Brain["Sub"] != "Main") 
		self.Brain["Shader"]["Curs"][1].alpha = 0;
	else
	{
		self.Brain["Shader"]["Curs"][1].alpha = .4;
		wait 0.2;
		self.Brain["Shader"]["Curs"][1].alpha = 9;
	}
}	

rainbowEff()
{
	if(self.coloringmenu) return;
	
	self endon("disconnect");
	self endon("MenuClosed");
	self endon("colordone");
	
	a = 255;
	b = 0;
	c = 0;
	
	self.coloringmenu = true;
	
	while(self.coloringmenu)
	{
		while(c <= 255)
		{
			self.Brain["HUD"]["background"][0].color = DivideColor(a,b,c);
			c+=4;
			wait .05;
			if(!self.coloringmenu)break;
		}
		while(a >= 0)
		{
			self.Brain["HUD"]["background"][0].color = DivideColor(a,b,c);
			a-=4;
			wait .05;
			if(!self.coloringmenu)break;
		}
		while(b <= 255)
		{
			self.Brain["HUD"]["background"][0].color = DivideColor(a,b,c);
			b+=4;
			wait .05;
			if(!self.coloringmenu)break;
		}
		while(c >= 0)
		{
			self.Brain["HUD"]["background"][0].color = DivideColor(a,b,c);
			c-=4;
			wait .05;
			if(!self.coloringmenu)break;
		}
		while(a <= 255)
		{
			self.Brain["HUD"]["background"][0].color = DivideColor(a,b,c);
			a+=4;
			wait .05;
			if(!self.coloringmenu)break;
		}
		while(b >= 0)
		{
			self.Brain["HUD"]["background"][0].color = DivideColor(a,b,c);
			b-=4;
			wait .05;
			if(!self.coloringmenu)break;
		}
	}
	
	self.Brain["HUD"]["background"][0].color = (1,1,1);
}  

AdditionalTexts()
{
	self endon("MenuClosed");
	self endon("MenusourceClosed");
	
	if(!isDefined(self.AddText[0])) self.AddText[0] = self createText("hudbig",3,"LEFT","LEFT",5,75,105,1,(1,1,1),"SOURCE");
	if(!isDefined(self.AddText[1])) self.AddText[1] = self createText("hudbig",3,"LEFT","LEFT",5,75,105,1,(1,1,1),"SOURCE");
	if(!isDefined(self.AddText[2])) self.AddText[2] = self createText("hudbig",1.5,"LEFT","LEFT",120,80,105,1,(1,1,1),"ENGINE"); 
	if(!isDefined(self.AddText[3])) self.AddText[3] = self createText("hudbig",1.5,"LEFT","LEFT",120,80,105,1,(1,1,1),"ENGINE");
	
	scale = .1;
	while(1)
	{
		self.AddText[0] setText("SOURCE");
		self.AddText[1] setText("SOURCE");
		self.AddText[0] setPulseFX(50, 2000, 1000);
		self.AddText[1] setPulseFX(50, 2000, 1000);
		self.AddText[2].alpha = 0;
		self.AddText[3].alpha = 0;
		self.AddText[2].x = 120;
		self.AddText[3].x = 120;
		wait .3;
		
		for(x=0;x<11;x++)
		{
			self.AddText[2].alpha = x * scale;
			self.AddText[3].alpha = x * scale;
			wait  .1;
		}
		
		wait .3;
		
		for(x=10;x>-1;x--) 
		{
			self.AddText[2].alpha = x * scale;
			self.AddText[3].alpha = x * scale;
			wait .1;
		}
		
		self.AddText[0] setText("INSIDE");
		self.AddText[1] setText("INSIDE");
		self.AddText[2] setText("ALL-IN-ONE");
		self.AddText[3] setText("ALL-IN-ONE");
		self.AddText[2].x = 105;
		self.AddText[3].x = 105;
		wait 1;
		self.AddText[0] setPulseFX(50, 2000, 1000);
		self.AddText[1] setPulseFX(50, 2000, 1000);
		
		for(x=0;x<11;x++) 
		{
			self.AddText[2].alpha = x * scale;
			self.AddText[3].alpha = x * scale;
			wait .1;
		}
		
		wait 0.3;
		
		for(x=10;x>-1;x--) 
		{
			self.AddText[2].alpha = x * scale;
			self.AddText[3].alpha = x * scale;
			wait .1;
		}
		
		wait .2;
		self.AddText[2] setText("ENGINE");
		self.AddText[3] setText("ENGINE");
		wait 1;
	}
}
KRDR(color,hud,text)
{
	self endon("disconnect");
	self endon("stop_krdr");
	
	self.menu["KRDR_Color"] = color;
	
	while(isDefined(hud))
	{
		if(self.menu["KRDR_Color"] == "^7") hud setText("^7"+text);
		while(self.menu["KRDR_Color"] == "^7")
			wait .05;
		for(a=0;a<text.size;a++)
		{
			string = "";
			for(b=0;b<text.size;b++)
			{
				if(b == a)
					string += self.menu["KRDR_Color"]+""+text[b]+"^7";
				else
					string += text[b];
			}
			hud setText(string);
			wait .05;
		}
		wait .05;
		for(a=text.size-1;a>=0;a--)
		{
			string = "";
			for(b=0;b<text.size;b++)
			{
				if(b == a)
					string += self.menu["KRDR_Color"]+""+text[b]+"^7";
				else
					string += text[b];
			}
			hud setText(string);
			wait .05;
		}
		wait .05;
	}
}

AddMenuAction(SubMenu, OptNum, Name, Func, Input, input2 )
{
	self.Brain["Option"]["Name"][SubMenu][OptNum] = Name;
	//self.Brain["Func"]
	self.Brain["Func"][SubMenu][OptNum] = Func;
	
	if(isDefined(Input)) self.Brain["Input"][SubMenu][OptNum] = Input;
	if(isDefined(input2)) self.Brain["Input2"][SubMenu][OptNum] = input2;
}
AddBackToMenu( Menu, GoBack )
{
	self.Brain["GoBack"][Menu] = GoBack;
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
		pos5 = self.oldScroll[5];
		self.oldScroll[5] = undefined;
		return pos5;
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

doHeart(forceON,forceOFF)
{
	if(isdefined(level.gameended) && level.gameended) return;
	
	self endon("disconnect");
	
	if(getdvar("doheart") == "" || getdvar("doheart") == "0" || (isdefined(forceON) && !isdefined(forceOFF)))
	{
		setdvar("doheart","1");
		
		for(i=0;i<level.players.size;i++)
		{
			if(isdefined(level.players[i].doHeartCreated) && !level.players[i].doHeartCreated)
			{
				level.players[i].doHeartCreated = true;
				
				level.players[i].heart["HUD"][0] = createtext("objective", 2.5, "TOP RIGHT", "TOP RIGHT", 0 + self.AIO["safeArea_X"]*-1, 0 + self.AIO["safeArea_Y"], 902, 1, (1,1,1) , "All-In-One");
				level.players[i].heart["HUD"][1] = createtext("objective", 2.5, "TOP RIGHT", "TOP RIGHT", 3 + self.AIO["safeArea_X"]*-1, 0 + self.AIO["safeArea_Y"], 901, 1, (0,0,0) , "All-In-One");	
				level.players[i].heart["HUD"][2] = createtext("objective",2,"TOP RIGHT","TOP RIGHT", 0 + self.AIO["safeArea_X"]*-1, 12 + self.AIO["safeArea_Y"], 904, 1, (1,1,1), "V4");
				level.players[i].heart["HUD"][3] = createtext("objective",2,"TOP RIGHT","TOP RIGHT", 3 + self.AIO["safeArea_X"]*-1, 12 + self.AIO["safeArea_Y"], 903, 1, (0,0,0), "V4");

				level.players[i] thread HeartAnimation();
			}
		}
	}
	else
	{
		setdvar("doheart","0");
		
		for(i=0;i<level.players.size;i++)
		{
			level.players[i].doHeartCreated = false;
			level.players[i] notify("stop_heart_anim");
			if(isDefined(level.players[i].heart["HUD"][0])) level.players[i].heart["HUD"][0] AdvancedDestroy(level.players[i]);
			if(isDefined(level.players[i].heart["HUD"][1])) level.players[i].heart["HUD"][1] AdvancedDestroy(level.players[i]);
			if(isDefined(level.players[i].heart["HUD"][2])) level.players[i].heart["HUD"][2] AdvancedDestroy(level.players[i]);
			if(isDefined(level.players[i].heart["HUD"][3])) level.players[i].heart["HUD"][3] AdvancedDestroy(level.players[i]);
		}	
	}
}
HeartAnimation()
{
	self endon("disconnect");
	self endon("stop_heart_anim");
	
	for(i=-115;;i+=100)
	{
		if(i<-115) i = -10;
		if(i>-10) i = -115;

		if(isDefined(self.heart["HUD"][2])) self.heart["HUD"][2] elemMoveX(4, i + self.AIO["safeArea_X"]*-1);
		if(isDefined(self.heart["HUD"][3])) self.heart["HUD"][3] elemMoveX(4, i + 3 + self.AIO["safeArea_X"]*-1);
		
		wait 4;
	}
}



Refresh_AIO_HUDs()
{
	self endon("disconnect");
	
	for(;;)
	{
		self waittill("REFRESH_HUDS");
		if(self.doHeartCreated)
		{
			self.heart["HUD"][0] setPoint("TOP RIGHT", "TOP RIGHT", 0 + self.AIO["safeArea_X"]*-1, 0 + self.AIO["safeArea_Y"]);
			self.heart["HUD"][1] setPoint("TOP RIGHT", "TOP RIGHT", 3 + self.AIO["safeArea_X"]*-1, 0 + self.AIO["safeArea_Y"]);
			self.heart["HUD"][2] setPoint("TOP RIGHT","TOP RIGHT", 0 + self.AIO["safeArea_X"]*-1, 12 + self.AIO["safeArea_Y"]);
			self.heart["HUD"][3] setPoint("TOP RIGHT","TOP RIGHT", 3 + self.AIO["safeArea_X"]*-1, 12 + self.AIO["safeArea_Y"]);
		}
	}
}


Matrix()
{
	self endon("disconnect");
	self endon("StopMatrix");
	
	self.matrixwatch = 0;
	
	for(;;)
	{
		i= RandomIntRange(1,750);
		wait 0.05;	
	
		while(self.matrixwatch>14)
			wait .05;
		
		self thread MakeMatrix(i);
		wait 0.1;
	}
}
MakeMatrix(position)
{
	self.matrixwatch++;
	m = createFontString("default",1.5);
	m SetText("C");
	m.x = position;
	m.y = 10;
	m.alignX = "top";
	m.alignY = "top";
	m.horzAlign = "top";
	m.vertAlign = "top";
	m.sort = 3;
	m.foreground = true;
	m transitionPulseFXIn(3,5);
	m trans(position);
	m.color =(.6 ,.8,.6);
	m.alpha = 1;
	m fadeOverTime(0.1);
	m.alpha =.2;
	wait 0.1;
	m fadeOverTime(0.1);
	m.alpha=1;
	m.color =(1.0,1.0,1.0);
	wait 0.1;
	m fadeOverTime(0.1);
	m.alpha=.2;
	wait 0.1;
	m fadeOverTime(0.1);
	m.alpha=3;
	m.color =(.6 ,.8,.6);
	m.alpha=1;
	m fadeOverTime(0.1);
	m.alpha=.2;
	wait 0.1;
	m fadeOverTime(0.1);
	m.alpha=1;
	m.color =(1.0,1.0,1.0);
	wait 0.1;
	m fadeOverTime(0.1);
	m.alpha=.2;
	wait 0.1;
	m fadeOverTime(0.1);
	m.alpha=1;
	m.color =(.6 ,.8,.6);
	wait 2.2;
	m destroy();
	self.matrixwatch--;
}

transitionPulseFXIn(inTime,duration)
{
	self endon("StopMatrix");
	//50 2000 1000
	transTime = int(inTime)*1000;
	showTime = int(duration)*1000;
	
	switch(self.elemType)
	{
		case "font": 
		case "timer": 
		
		self setPulseFX(transTime+250,showTime+transTime,transTime+250);
		break;
		default: break;
	}
}

trans(i)
{
	gotoY = 200;
	gotoY += (1000+i);
	self.alpha = 1;
	self moveOverTime(10);
	self.y = gotoY;
}
ColorSwitch()
{}