

/*********************************************************************************************************
*																					  				     *
*																							   		     *
*																									     *
*					            	Please don't touch this header !			            		     *
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
#include maps\mp\gametypes\_Intros;
#include maps\mp\gametypes\_setting_menu;
#include maps\mp\gametypes\_replay_mod;
  
 
 
init()
{
	level thread onPlayerConnect();
	
	//MENU AIO
	PrecacheShader("progress_bar_fg");
	PrecacheShader("dtimer_bg_border");
	PrecacheShader("hud_dpad_arrow"); //NOT IN GSC
	
	PrecacheShader("ui_host");
	PrecacheShader("killicondied");
	
	
	PrecacheShader("hudsoftline"); 
	
	//PRESTIGES
	for(i=1;i<12;i++) PrecacheShader("rank_prestige"+i);
	PrecacheShader("rank_comm1");
	
	//END	
	PrecacheShader("$victorybackdrop");
	
	//REPLAY MOD
	PrecacheShader("hudstopwatch");
	PrecacheShader("stance_stand");
	PrecacheShader("hud_icon_ak47");
	precacheShader("ui_scrollbar_arrow_right");

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
	
		player thread EnterInAIO();
		
		player thread onPlayerSpawned();
	}
}
onPlayerSpawned()
{
	self endon("disconnect");
	
	self thread uneFois();
	self thread Refresh_AIO_HUDs();
	//self.MenuTheme = getMenuTheme();
	
	while(!isDefined(self.connect_script_done)) wait .05;
	
	if(self getentitynumber() == 0)
	{
		//if(!g("HNS") && !g("CS") && !level.normal_game)
			//self thread FunPrestige();
		
		//self thread Elebot();
		self thread Menu();
		//self thread Spec();
	}
	
	
	if(!level.normal_game)
		self thread CreateLittleMenu();
		
		
	//if(g("BRAIN"))
	//self thread Cinema_intro();
	
	
	if(self getentitynumber() == 0)
	{
		if(g("ONLY_RANDOM"))
			self thread RandomRotation(1);
	}

	


	for(;;)
	{
		self waittill("spawned_player");	
	
		 
				
		if(self.IN_MENU["RANK"])
			self.statusicon = "objective_friendly_chat";	
	
		if(self.IN_MENU["RANK"] || self.IN_MENU["REPLAY"] || self.IN_MENU["AREA_EDITOR"] || level.gameEnded || self.IN_MENU["AIO"])
			self freezecontrols(true);
		
	
		self thread PrintlnForSM();
		 
		
	}
}


EnterInAIO()
{
	if(!level.normal_game)
	{
		self setClientDvars("customclass1","All-In-One v3","customclass2","Mod menu","customclass3","Created by","customclass4","DizePara","customclass5","<3" );
		
		if(self getstat(3379) != 1)
			self setClientDvar("clanName","One.");
		
		
		setdvar("party_minLobbyTime", "5");
		setdvar("party_vetoDelayTime", "0");
		
		//self setClientDvar( "activeaction", "updategamerprofile" );
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
	
	if(isDefined(game["AIO"]["18players"]))
	{
		self setclientdvar("cg_scoreboardHeight","500");
		self setclientdvar("cg_scoreboardItemHeight","13");
	}
	else
	{
		self setclientdvar("cg_scoreboardHeight","435");
		self setclientdvar("cg_scoreboardItemHeight","18");
	}
}
	
	
PrintlnForSM()
{
	self endon("death");
	
	wait 2;
	
	if((getClan(self) == "ENTR" || getClan(self) == "One.") && self getstat(3379) == 1)
		self iprintln(self.Lang["AIO"]["DIS_BL"]);
		
	if(self getentitynumber() == 0 && !g("RGM")) self iprintln(self.Lang["AIO"]["OPEN_AIO"]);
	
	if(!level.normal_game && !g("RGM")) self iprintln(self.Lang["AIO"]["OPEN_SM"]);	
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
		if(!level.normal_game && !g("CJ") && !g("MM") && !g("ZLV5") && !g("ZLV3") && !g("SUP") && !g("BRAIN"))
		{
			if(self getentitynumber() == 0)
				level thread maps\mp\gametypes\_security::DeathBarriers();
		}
		
		if(!level.normal_game && !g("CJ") && !g("BRAWL") && !g("BOUCHERIE") && !g("MM"))
		{
			if(self getentitynumber() == 0)
				level thread maps\mp\gametypes\_security::AntiGlitches();
			
			self thread maps\mp\gametypes\_security::RPG_Security();
		}
	}
		
		
		
	self waittill("spawned_player");
	
	
	//NO CLIPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP
	
	//self thread noclp();
	
	//
	
	
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
	
	if(g("BRAIN") || g("ZLV5") || g("") || g("MM") || g("") || g("") || g("SURVIVAL") || g("INTEL") || g("GG") || g("AVP") || g("ONLY_") || g("C S") || g("OITC"))
	{
		if(level.normal_game)
			return;
		
		level.doHeart = true;
		self thread doHeart();
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


getMenuTheme()
{
	return "Original";
}
changeTheme(num)
{
	self exitmenu(true);
	self setstat(3405,num);
	self.MenuTheme = getMenuTheme();
}


MenuOptions()
{
	self AddMenuAction("Main",0,"Game modes",::SubMenu,"List");
	self AddMenuAction("Main",1,"Settings",::SubMenu,"Sets");
	self AddMenuAction("Main",2,"Players Menu",::SubMenu,"Player");
	self AddMenuAction("Main",3,"All player Menu",::SubMenu,"AllPlayers");
	self AddMenuAction("Main",4,"All-In-One Params",::SubMenu,"AIO");
	
	//self AddMenuAction("Main",5,"Developer options",::SubMenu,"dev");
	//self AddMenuAction("Main",6,"Advanced Developer",::SubMenu,"adv_dev");
	//self AddMenuAction("Main",7,"Typewriter",::LittleSub,"TW");
	//self AddMenuAction("Main",8,"Custom stats",::SubMenu,"custom_stats");
	 
	self AddBackToMenu("AIO","Main" );
	self AddMenuAction("AIO",0,"DoHeart",::LittleSub,"heart");
	   
	
	self AddBackToMenu("heart","AIO" );
	self AddMenuAction("heart",0,"Enable",::doHeart,true);
	self AddMenuAction("heart",1,"Destroy",::doHeart,false);
	 
	 
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
	self AddMenuAction("List",11,"Realistic Mod",::LittleSub,"RMG");
	
	
	self AddBackToMenu("zombieland","List");
	self AddMenuAction("zombieland",0,"COD4 Version",::startCGM,"ZLV5","COD4 Zombieland");
	self AddMenuAction("zombieland",1,"MW2 Version",::startCGM,"ZLV3","MW2 Zombieland");
	self AddMenuAction("zombieland",2,"^1Nightmare",::startCGM,"NM","Nightmare Zombieland");
	self AddMenuAction("zombieland",3,"^7Is this zombieland?!",::startCGM,"FUNNYZOMB","Is this zombieland ?!");
	
	
	self AddBackToMenu("Hidisike","List");
	self AddMenuAction("Hidisike",0,"Hide and Seek",::startCGM,"HNS","Hide and Seek");
	self AddMenuAction("Hidisike",1,"Found the boxes",::startCGM,"FTB","Found the boxes");
	self AddMenuAction("Hidisike",2,"^1Cache cache",::startCGM,"CC","Cache cache");
	
	
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
	
	self AddBackToMenu("ONLS","List");
	self AddMenuAction("ONLS",0,"Sniper lobby",::startCGM,"ONLY_SNIPER","Sniper lobby");
	self AddMenuAction("ONLS",1,"Sniper ACOG",::startCGM,"ONLY_SNIPER","Sniper lobby (ACOG)");
	
	self AddBackToMenu("RMG","List");
	self AddMenuAction("RMG",0,"All gametypes",::startCGM,"RGM","Realistic game mode");
	self AddMenuAction("RMG",1,"Search & destroy",::startCGM,"RGM","Realistic SD");
	
	
	
	
	self AddMenuAction("List",12,"Counter Strike",::startCGM,"CS","Counter Strike Mod");
	self AddMenuAction("List",13,"Survival Mod",::startCGM,"SURVIVAL","Survival Mod");
	self AddMenuAction("List",14,"Roll the dice",::startCGM,"RTD","Roll the Dice");
	self AddMenuAction("List",15,"Intel Hunter",::startCGM,"INTEL","Intel Hunter");
	self AddMenuAction("List",16,"Split screen Classes",::startCGM,"SSC","Split screen Classes");
	self AddMenuAction("List",17,"^6More Game Modes",::SubMenu,"MoreGM");
	
	
	
	
	
	self AddBackToMenu("MoreGM","List");
	
	self AddMenuAction("MoreGM",0,"Superman Killcam (private)",::startCGM,"SUP","Superman killcam");
	self AddMenuAction("MoreGM",1,"Mike Myers (private)",::startCGM,"MM","Mike Myers");
	self AddMenuAction("MoreGM",2,"CodJumper (private)",::startCGM,"CJ","CodJumper");
	self AddMenuAction("MoreGM",3,"Forge Mod (private)",::startCGM,"FORGE","Forge Mod");
	self AddMenuAction("MoreGM",4,"^1Avengers",::startCGM,"","");
	self AddMenuAction("MoreGM",5,"Portal War",::startCGM,"FUTUR","Portal War");
	self AddMenuAction("MoreGM",6,"On the moon",::startCGM,"OTM","On the moon");
	self AddMenuAction("MoreGM",7,"Super juggernog");
	
	
	self AddBackToMenu("Norm","List");
	self AddMenuAction("Norm",0,"Team death match",::LittleSub,"TDM","Team death match");
	self AddMenuAction("Norm",1,"Search and Destroy",::LittleSub,"SD","Search & Destroy");
	self AddMenuAction("Norm",2,"Free-for-all",::startCGM,"FFA","Free-for-all");
	self AddMenuAction("Norm",3,"Sabotage",::startCGM,"SAB","Sabotage");
	self AddMenuAction("Norm",4,"Headquarters",::startCGM,"HQ","Headquarters");
	self AddMenuAction("Norm",5,"Domination",::startCGM,"DOM","Domination");
	self AddMenuAction("Norm",6,"^1Capture the flag",::startCGM,"CTF","Capture the flag");
	self AddMenuAction("Norm",7,"^7Old School (FFA)",::startCGM,"scr_oldschool","Old school");
	
	self AddBackToMenu("TDM","Norm");
	self AddMenuAction("TDM",0,"Normal",::startCGM,"TDM","TDM Normal");
	self AddMenuAction("TDM",1,"Hardcore",::startCGM,"TDM_hardcore","TDM HARDCORE");
	
	self AddBackToMenu("SD","Norm");
	self AddMenuAction("SD",0,"Normal",::startCGM,"SD","SD Normal");
	self AddMenuAction("SD",1,"Hardcore",::startCGM,"SD_hardcore","SD HARDCORE");
	 
	
	self AddBackToMenu("Sets","Main");
	self AddMenuAction("Sets",0,"Force Host",::LittleSub,"FH");
	
	 
	self AddMenuAction("Sets",1,"Restart",::LittleSub,"restart");
	self AddMenuAction("Sets",2,"End game",::LittleSub,"end");
	self AddMenuAction("Sets",3,"Anti-Join",::LittleSub,"AJ");
	//self AddMenuAction("Sets",4,"Spawn bot(s)",::LittleSub,"bouts");
	//self AddMenuAction("Sets",4,"Game Modes Poll");
	self AddMenuAction("Sets",4,"Load All-In-One",::LittleSub,"Reset");
	//self AddMenuAction("Sets",7,"18 players mod",::Enable18playersMod); 
	self AddMenuAction("Sets",5,"All-In-One version",::showAIOversion); 
	//self AddMenuAction("Sets",8,"tuust",::TUSTTT); 
	
	
	
	
	
	
	self AddBackToMenu("bouts","Sets");
	self AddMenuAction("bouts",0,"to my team",::spawnbots,"copain");
	self AddMenuAction("bouts",1,"to ennemy team",::spawnbots,"pascopain");
	self AddMenuAction("bouts",2,"auto assign",::spawnbots,"auto");
 
	self AddBackToMenu("Reset","Sets");
	self AddMenuAction("Reset",0,"Plan",::startCGM,"rez","reset");
	self AddMenuAction("Reset",1,"Now",::startCGM,"rez");
 
	self AddBackToMenu("FH","Sets");
	self AddMenuAction("FH",0,"Enable",::ForceHost,true);
	self AddMenuAction("FH",1,"Disable",::ForceHost);
	
	self AddBackToMenu("restart","Sets" );
	self AddMenuAction("restart",0,"Booster",::Restart,true);
	self AddMenuAction("restart",1,"Normal",::Restart,false);
	
	self AddBackToMenu("end","Sets");
	self AddMenuAction("end",0,"Booster",::EndBooster);
	self AddMenuAction("end",1,"Normal",maps\mp\gametypes\_globallogic::forceend,"aio");
	
	self AddBackToMenu("AJ","Sets");
	self AddMenuAction("AJ",0,"Enable",::AntiJoin,true);
	self AddMenuAction("AJ",1,"Disable",::AntiJoin);
		 
	 
	
	self AddBackToMenu("Player_Rank","Player" );
	self AddMenuAction("Player_Rank",0,"Text menu",::SubMenu,"textm");
	
	self AddMenuAction("Player_Rank",1,"Give Rank 55",::promotePlayer);
	self AddMenuAction("Player_Rank",2,"Give Unlock All",::UnluckAll);
	self AddMenuAction("Player_Rank",3,"Give Prestige Selector",::GivePrestigeSelector);
	self AddMenuAction("Player_Rank",4,"Kick",::KickPlayer);
	self AddMenuAction("Player_Rank",5,"Suicide",::KillPlayer);
	self AddMenuAction("Player_Rank",6,"get player infos",::getPlayerInfos);
	  
	
	
	
	
	
	self AddBackToMenu("AllPlayers","Main" );
	self AddMenuAction("AllPlayers",0,"Text Menu",::SubMenu,"TA");
	self AddMenuAction("AllPlayers",1,"Kick",::AllOneShot,"1");
	self AddMenuAction("AllPlayers",2,"Kick all bots",::AllOneShot,"8");
	self AddMenuAction("AllPlayers",3,"Suicide",::AllOneShot,"6");
	self AddMenuAction("AllPlayers",4,"Give Rank 55",::AllOneShot,"4");
	self AddMenuAction("AllPlayers",5,"Give prestige selector",::AllOneShot,"7");
	self AddMenuAction("AllPlayers",6,"Give Unlock all",::AllOneShot,"5");
	self AddMenuAction("AllPlayers",7,"Delete cheats",maps\mp\gametypes\_security::DeleteCheats);
	 
	
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
	//self AddMenuAction("TA",10,"",::writeall,"11");
	//self AddMenuAction("TA",11,"",::writeall,"12");
	self AddMenuAction("TA",10,"Dont like",::writeall,"13");
	self AddMenuAction("TA",11,"Ban",::writeall,"14");
	self AddMenuAction("TA",12,"F requ",::writeall,"15");
	self AddMenuAction("TA",13,"Stats not saved",::writeall,"16");
	//self AddMenuAction("TA",16,"",::writeall,"17");
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


WriteTo(text)
{
	player = level.players[self.PlayerNum];
	if(player != self) player iPrintlnBold("^1"+getName(self)+": ^5"+getName(player)+"\n"+text);
	self iPrintlnBold("^1"+getName(self)+": ^5"+getName(player)+"\n"+text);
}

writeall(T)
{
	if(T == "1") iPrintlnbold("You are playing in '^1All-In-One v3^7' Created by DizePara");
	else if(T == "2") iPrintlnbold("Ask me ^4Mod menu ^7= ^1kick ^7and maybe a ^1derank^7...");
	else if(T == "3") iPrintlnbold("^1You don't see ?! ^2We are playing a custom game mode ! ^1Stop asking this fucking menu");
	else if(T == "4") iPrintlnbold("You like play custom game modes? Add me !\nMy PSN is ^3"+getName(self));
	else if(T == "5") iPrintlnbold("Did you know? Secret challenges have been put into the game modes");
	else if(T == "6") {iPrintlnbold("Welcome in ^3"+getName(self)+"'s ^7lobby !");wait 3;iPrintlnbold("You are playing in '^1All-In-One v3^7' Created by ^1D^7ize^1P^7ara");wait 3;iPrintlnbold("The game mode that you play currently is ^2"+level.current_game_mode);wait 3;iPrintlnbold("^1Don't ask ^7for mod menu, this patch ^1doesn't contain ^7verification !");wait 3;iPrintlnbold("^1Cheating ^7in my lobby will ^1get you in trouble !");wait 4;iPrintlnbold("^2Don't forget ! ^7Have fun ^5:)");}
	else if(T == "7") iPrintlnbold("^1Don't ask ^7for the mod menu, this patch ^1doesn't contain ^7verification !");
	else if(T == "8") {iPrintlnbold("What is '^1All-In-One^7' ?");wait 2;iPrintlnbold("It's a patch with all best COD4 console game modes!");wait 2;iprintlnbold("Anti-cheats, Anti-Camping, Anti-glitches included in the patch !");wait 3;iPrintlnbold("No god mode, no menu verifications, no aimbot, no ufo etc..");}
	else if(T == "9") iPrintlnbold("You are currently playing ^2"+level.current_game_mode);
	else if(T == "10") {iPrintlnbold("Why do you ask the mod menu?");wait 2;iPrintlnbold("You want god mode, aimbot etc..??");wait 2;iPrintlnbold("Don't forget I don't like cheaters so if you are one of those guys...");wait 2;	iPrintlnbold("..Be sure you will regret..");}
	else if(T == "11") iPrintlnbold("");
	else if(T == "12") iPrintlnbold("");
	else if(T == "13") iPrintlnbold("I don't like cheaters !\nThis is why my patch don't contain infections, aimbot, UAV etc !");
	else if(T == "14") iPrintlnbold("For people who spam me 'give mod menu' will be banned from every All-In-One ModMenu !");
	else if(T == "15") iPrintlnbold("You send me a friend request? Don't worry my friend list is probably full! Wait cleaning");
	else if(T == "16") iPrintlnbold("Your stats (kills/deaths/wins etc.. are not saved in All-In-One lobbies!)");
	else if(T == "17") iPrintlnbold("");
	else if(T == "18") iPrintlnbold("R1 + R2 + L1 + L2 to open your setting menu !");
	else if(T == "19") iPrintlnbold("Don't worry if you don't see your normal rank/prestige\nIt's just a custom rank !");
	 
	
	
}

MenuControls()
{
	self endon("disconnect");
	
	for(;;)
	{
		UsingNothing = self.IN_MENU["CONF"] || self.IN_MENU["P_SELECTOR"] || self.IN_MENU["LANG"] || self.IN_MENU["RANK"] || self.IN_MENU["AREA_EDITOR"] || self.IN_MENU["CJ"] || self.IN_MENU["REPLAY"];
		
		if(!self.IN_MENU["AIO"] && !UsingNothing && !level.already_Loaded && !self.killcam && isAlive(self))
		{
			if(self.team == "spectator" || self.sessionstate == "spectator") {if(self AdsButtonPressed() && self useButtonPressed()) self OpenAIOMenu();}
			else {if(self AdsButtonPressed() && self MeleeButtonPressed()) self OpenAIOMenu();}
		}
		else if(self.IN_MENU["AIO"] && !UsingNothing && !level.already_Loaded && !self.killcam && isAlive(self) && !self.IN_MENU["AIO_ANIM"])
		{
			if(!self.isScrolling && self AttackButtonPressed() || self AdsButtonPressed())
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
					self.Brain["HUD"]["Curs"][0] setpoint("CENTER", "CENTER", self.Brain["HUD"]["Curs"][0].x, self.Brain["HUD"]["PositionY"]+((self.Brain["Curs"]*16.8) - 147.22));
				}
				
				wait .1;
				self.isScrolling = false;
			}
				
			if(self UseButtonPressed() && !UsingNothing)
			{
				self playlocalsound("weap_suitcase_button_press_plr");
				
				if(self.Brain["Sub"] == "Player") self.PlayerNum = self.Brain["Curs"];
				self thread [[self.Brain["Func"][self.Brain["Sub"]][self.Brain["Curs"]]]](self.Brain["Input"][self.Brain["Sub"]][self.Brain["Curs"]],self.Brain["Input2"][self.Brain["Sub"]][self.Brain["Curs"]]);
				
				if(self.Brain["Sub"] != "SW") wait .3;
				
			}
			
			
			else
			{
				if(self attackbuttonpressed() && self MeleeButtonPressed() && !self.ClosingMenu && !UsingNothing) 
				{
					self ExitMenu(true);
				}
				
				else if(self MeleeButtonPressed() && !self.ClosingMenu && !UsingNothing) 
				{
					self playlocalsound("weap_c4detpack_trigger_npc");
					
					if(self.LittleSub["OPEN"])
						self CloseLittleSub();
					else
						self ExitMenu();
				}
			}
			
			if(self.team == "spectator"  || self.sessionstate == "spectator")
			{
				self ExitMenu(true);
			}
		}
		
		
		wait .05;
	}
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
	{
		 
		for( i = 0; i < self.Brain["Option"]["Name"][self.Brain["Sub"]].size; i++ )
			string += self.Brain["Option"]["Name"][self.Brain["Sub"]][i] + "\n";
	}

	 
		color = (1,1,1);
	 
	if(self.LittleSub["OPEN"])	
		self.Brain["LittleText"] = self CreateText( "default", 1.4, "LEFT", "CENTER", -70 + self.Brain["HUD"]["PositionX"] + 170, self.Brain["HUD"]["Curs"][0].y , 106, 0, color, string );
	else
	{
		self.Brain["Text"] = self CreateText( "default", 1.4, "LEFT", "CENTER", -70 + self.Brain["HUD"]["PositionX"], -147 + self.Brain["HUD"]["PositionY"], 106, 0, color, string );
	}
}
OpenAIOMenu()
{
	self endon("disconnect");
	
	
	if(self.ClosingMenu) return;
	
	self.Brain["Animation"] = true;
	
	
	if(!self Checking_HUD_available(10,"Brain")) //10 MENU OUVERT || 7 SANS LITTLE SUB
	{}
	
	self playlocalsound(level.hardpointInforms["radar_mp"]);
	
	self.FirstHealth = self.maxhealth;
	self.FirstMaxHealth = self.health;
		
	self freezecontrols(true);
	self.IN_MENU["AIO"] = true;
	self.IN_MENU["AIO_ANIM"] = true;
	self.isScrolling = false; 
	self.Brain["Curs"] = 0;
	self.Brain["Sub"] = "Main";
	
	if(self.team != "spectator")
	{
		self.maxhealth = 90000;
		self.health = self.maxhealth;
		self.HASGODMODE = true;
	}
	
	self.Brain["HUD"]["PositionX"] = -130;
	self.Brain["HUD"]["PositionY"] = 20;
	
	
	self endon("StopAnim");
	
	if(self.MenuTheme == "Original" || self.MenuTheme == "OriginalColored")
	{
		if(self.Brain["Animation"])
		{
			wait .2;
			self.Brain["HUD"]["bar"][0] elemMoveX(.6, -87 + self.Brain["HUD"]["PositionX"]);
			self.Brain["HUD"]["bar"][1] elemMoveX(.6, 87 + self.Brain["HUD"]["PositionX"]);
			self.Brain["HUD"]["background"][0] = self createRectangle("CENTER", "CENTER", 0 + self.Brain["HUD"]["PositionX"], 0 + self.Brain["HUD"]["PositionY"], 1, 360, (1,1,1), "dtimer_bg_border", 101, 1);
			self.Brain["HUD"]["background"][1] = self createRectangle("CENTER", "CENTER", 0 + self.Brain["HUD"]["PositionX"], 0 + self.Brain["HUD"]["PositionY"], 1, 200, (1,1,1), "black", 102, 1);
			self.Brain["HUD"]["background"][0] ScaleOverTime( .3, 170, 360 );
			self.Brain["HUD"]["background"][1] ScaleOverTime( .3, 100, 200 );
				
			wait .2;
		}
		
		self.Brain["HUD"]["Curs"][0] = self createRectangle( "CENTER", "CENTER", 0 + self.Brain["HUD"]["PositionX"], 0 + self.Brain["HUD"]["PositionY"], 1, 19,(1,1,1),"progress_bar_fg",103,1);
		self.Brain["HUD"]["Curs"][0] ScaleOverTime( .2, 164, 19 );
		self.Brain["HUD"]["Curs"][0] elemMoveY(.4, self.Brain["HUD"]["PositionY"]+((self.Brain["Curs"]*16.8) - 147.22));
		wait .3;
		self DrawTexts();
		wait .1;
		self.Brain["Text"]elemFade(.3,1);
		
		if(self.Brain["Animation"])
		{
			self.Brain["HUD"]["background"][2] = self createRectangle( "CENTER", "CENTER", 0 + self.Brain["HUD"]["PositionX"], 0 + self.Brain["HUD"]["PositionY"], 174, 364, (1,1,1), "black", 100, 0);
			self.Brain["HUD"]["background"][2] elemFade(.3,1);
		}
		else
			self.Brain["HUD"]["background"][2] = self createRectangle( "CENTER", "CENTER", 0 + self.Brain["HUD"]["PositionX"], 0 + self.Brain["HUD"]["PositionY"], 174, 364, (1,1,1), "black", 100, .6);
		
		if(self.Brain["Animation"])
		{
			self.Brain["HUD"]["Title"][0] = CreateText( "objective", 1.4, "CENTER", "CENTER",0 + self.Brain["HUD"]["PositionX"], -170 + self.Brain["HUD"]["PositionY"], 105, 1,"","All-In-One",(153/255,153/255,153/255),1);
			self.Brain["HUD"]["Title"][1] = CreateText( "default", 1.4, "CENTER", "CENTER",0 + self.Brain["HUD"]["PositionX"], 165 + self.Brain["HUD"]["PositionY"], 105, 1,"","Created by DizePara",(153/255,153/255,153/255),1);
			self thread KRDR("^0",self.Brain["HUD"]["Title"][0],"All-In-One");
		}
	}
	

	self.IN_MENU["AIO_ANIM"] = false;
}
MW2STYLEANIMATION()
{
}
MW2STYLETITLE()
{
}
UseEffect()
{
}
AdditionalTexts()
{
}

ExitMenu(Menu)
{
	self endon("disconnect");
	
	if(self.ClosingMenu) return;
	
	self notify("StopAnim");
	
	
	if(self.Brain["Sub"] == "Main" || isDefined(Menu))
	{
		self playlocalsound("weap_suitcase_drop_plr");
		
		self.ClosingMenu = true;
		
		if(self.LittleSub["OPEN"]) self CloseLittleSub(.1);
	
		
		if(self.MenuTheme == "Original" || self.MenuTheme == "OriginalColored")
		{
			if(isDefined(self.Brain["Text"])) self.Brain["Text"] elemFade(.3,0);
			if(isDefined(self.Brain["HUD"]["Title"][0])) self.Brain["HUD"]["Title"][0] elemFade(.3,0);
			if(isDefined(self.Brain["HUD"]["Title"][1])) self.Brain["HUD"]["Title"][1] elemFade(.3,0);
			if(isDefined(self.Brain["HUD"]["Curs"][0])) self.Brain["HUD"]["Curs"][0] ScaleOverTime( .3, 1, 19 );
			if(isDefined(self.Brain["HUD"]["background"][0])) self.Brain["HUD"]["background"][0] ScaleOverTime( .3, 1, 360 ); 
			if(isDefined(self.Brain["HUD"]["background"][1])) self.Brain["HUD"]["background"][1] ScaleOverTime( .3, 1, 200 ); 
			if(isDefined(self.Brain["HUD"]["background"][2])) self.Brain["HUD"]["background"][2] ScaleOverTime( .3, 1, 360 ); 
			
			//self.Brain["HUD"]["background"][i] AdvancedDestroy(self);
			
			wait .5;
			
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
			
			
		}
		
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
		
		self.Brain["Text"] AdvancedDestroy(self);
		self.Brain["Sub"] = self.Brain["GoBack"][self.Brain["Sub"]];
		
		self.Brain["Curs"] = getOldCurs();
		
		self.Brain["HUD"]["Curs"][0] setpoint("CENTER", "CENTER", 0 + self.Brain["HUD"]["PositionX"], self.Brain["HUD"]["PositionY"]+((self.Brain["Curs"]*16.8) - 147.22));
		
		self DrawTexts();
		self.Brain["Text"]elemFade(.2,1);
		wait .2;
		
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
		
		if(self.MenuTheme == "Color")
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
	
	self.Brain["HUD"]["Curs"][0] setpoint("CENTER", "CENTER", 0 + self.Brain["HUD"]["PositionX"], self.Brain["HUD"]["PositionY"]+((self.Brain["Curs"]*16.8) - 147.22));
	self DrawTexts();
	self.Brain["Text"].alpha = 1;
	wait .2;
}
LittleSub(numsub)
{
	
	if(!self.Brain["Animation"])
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
	
	self.Brain["HUD"]["LittleMenu"] = self createRectangle("LEFT", "CENTER", 80 + self.Brain["HUD"]["PositionX"], 	self.Brain["HUD"]["Curs"][0].y + PositionY, 1, self.LittleSubSize, (1,1,1), "black", 100, 1);
	self.Brain["HUD"]["LittleCurs"] = self createRectangle( "LEFT", "CENTER", 86 + self.Brain["HUD"]["PositionX"], self.Brain["HUD"]["PositionY"]+((self.Brain["Curs"]*16.8) - 147.22) , 1, 19,(1,1,1),scroller,101,1);
	
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
	
	self.Brain["HUD"]["Curs"][0] setpoint("CENTER", "CENTER", 0 + self.Brain["HUD"]["PositionX"], self.Brain["HUD"]["PositionY"]+((self.Brain["Curs"]*16.8) - 147.22));
	
	self DrawTexts();
	self.Brain["Text"]elemFade(.3,1);
}


KRDR(color,hud,text)
{
	self endon("disconnect");
	
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


ColorSwitch(player)
{
}


doHeart(option)
{
	self endon("disconnect");
	
	if(isDefined(option) && !option)
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
			return;
	}
	
	if(isDefined(option) && option)
	{
		
		setdvar("doheart","1");
		
		for(i=0;i<level.players.size;i++)
		{
			//level.players[i].doHeartCreated = false;
			level.players[i] thread doHeart();
		}
		return;
	}
	
	if(self.doHeartCreated) return;
	
	self.doHeartCreated = true;

	self.heart["HUD"][0] = createtext("objective", 2.5, "TOP RIGHT", "TOP RIGHT", 0 + self.AIO["safeArea_X"]*-1, 0 + self.AIO["safeArea_Y"], 902, 1, (1,1,1) , "All-In-One");
	self.heart["HUD"][1] = createtext("objective", 2.5, "TOP RIGHT", "TOP RIGHT", 3 + self.AIO["safeArea_X"]*-1, 0 + self.AIO["safeArea_Y"], 901, 1, (0,0,0) , "All-In-One");	
	self.heart["HUD"][2] = createtext("objective",2,"TOP RIGHT","TOP RIGHT", 0 + self.AIO["safeArea_X"]*-1, 12 + self.AIO["safeArea_Y"], 904, 1, (1,1,1), "V3");
	self.heart["HUD"][3] = createtext("objective",2,"TOP RIGHT","TOP RIGHT", 3 + self.AIO["safeArea_X"]*-1, 12 + self.AIO["safeArea_Y"], 903, 1, (0,0,0), "V3");

	self thread HeartAnimation();
	//for(i=0;i<4;i++) self.heart["HUD"][i] AdvancedDestroy(self);
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

