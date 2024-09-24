#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include common_scripts\utility;
#include maps\mp\gametypes\_general_funcs;
#include maps\mp\gametypes\_launcher;






 

ResetVision()
{
	if(self.CleaningVision)
		return;
	
	
	self.CleaningVision = true;
	
	self ResetProperly();
	
	if(g("CS"))
	{
		self setClientDvars("r_Distortion","1","r_DrawSun","1","r_DrawWater","1","r_Desaturation","0","sm_sunsamplesizenear","1","r_filmTweakBrightness","0.0595238","r_filmTweakContrast","1.42857","r_filmTweakDarkTint","1.55952 1.41667 1.5119","r_filmTweakDesaturation","0","r_filmTweakEnable","1","r_filmTweakInvert","0","r_filmTweakLightTint","1.83333 1.69048 1.54762","r_filmtweaks","1","r_filmUseTweaks","1","r_lightTweakSunColor","0.87451 0.819608 0.713726 1","r_lightTweakSunDirection","-43.5 25.11 1","r_lightTweakSunLight","0.78","r_Specular","1","r_SpecularColorScale","2.97619","r_glow","0","r_glow_allowed","0");
		self setClientDvars("r_glow_enable","1","r_glowTweakBloomCutoff","0.5","r_glowTweakBloomIntensity0","1","r_glowTweakEnable","1","r_glowTweakRadius0","5","r_glowUseTweaks","0","r_sunblind_fadein","60","r_sunblind_fadeout","0","r_sunblind_max_angle","90","r_sunflare_max_size","1","r_sunflare_min_size","0","r_sunglare_fadein","0.4","r_sunglare_fadeout","0.4","r_sunglare_max_angle","25","r_sunglare_min_angle","25","r_sunsprite_size","1","sm_enable","1","sm_polygonoffsetscale","2","sm_polygonoffsetbias","0","sm_sunshadowscale","1","sm_polygonoffsetbias",".5","sm_maxLights","4");
	}
	else if(g("HNS"))
		self maps\mp\gametypes\_HNS::HNS_CC();	
		
		
	else if(g("PROMOD_SD") || g("PROMOD_ALL"))
		self maps\mp\gametypes\_Pmod::CC();
	
	else if(g("ONLY_"))
	{
		self setClientDvars( "r_filmusetweaks", "1","r_specularcolorscale", "6","r_lighttweaksuncolor", "1 0.9 0.6 1","sm_enable", "1", "r_normalmap", "1","r_distortion", "1"  );
		self setClientDvars("r_lodbiasrigid", "-1000","r_lodbiasskinned", "-1000" ,"r_desaturation", "0","r_lighttweaksunlight", "1.3" ,"r_filmtweakenable", "1" ,"r_glow", "0"  );
		self setClientDvars( "r_fog", "0" , "r_filmtweakcontrast", "1.1" ,"r_filmtweakdarktint", "1.3 1.3 1.7", "r_filmtweaklighttint", "1.3 1.4 1.5", "r_filmtweakdesaturation", "0" );
	}
	else if(g("AVP"))
	{
		if(self.isPredator)
			self maps\mp\gametypes\_AliensPredators::VisionSetNakedForPlayer("cheat_invert_contrast");
		else if(self.isAlien)
			self maps\mp\gametypes\_AliensPredators::VisionSetNakedForPlayer("cheat_chaplinnight");
		
	}
	
	
	wait 1;
	self.CleaningVision = false;
	self iprintln(self.Lang["AIO"]["VIS_CLEA"]);
}

	

InitializeDvars(){}



resetMyDvars()
{
	
	self endon("disconnect");
	
	
	//iprintln("Cleaned game");
	
	self notify("destroy_all_huds");
	
	self ResetPriority();
	wait 1;
	self ResetHUD();
	wait 1;
	self ResetGameDvars();
	wait .2;
	self ResetMovement();
	self ResetColors();
	wait .5;
	self ResetScoreboard();
	self ResetTeamIcons();
	wait .5;
	self ResetProperly();
	wait .5;
	self ResetGameType();
	
	//self maps\mp\gametypes\_security::resetCheaterDvars();
	
	if(self getentitynumber() == 0) self iprintln(self.Lang["AIO"]["RESET_DONE"]);
	
	level.resetPlayersDVARS = false;
	level.dvarsallcleaned = true;
}


ResetPriority()
{

	self.hasRadar = false;
	self setClientDvar( "ui_uav_client", 0 );
	self setClientDvar( "ui_uav_allies", 0 );
	self setClientDvar( "ui_uav_axis", 0 );
	setdvar("ui_uav_client", 0);
	setDvar("ui_uav_allies",0);
	setDvar("ui_uav_axis",0);
	//self setClientDvar("activeaction", "none");
	//self setClientDvar("rebind", "bind BUTTON_RTRIG +frag; bind BUTTON_LTRIG +smoke; bind DPAD_UP +actionslot 1; bind DPAD_DOWN +actionslot 2; bind DPAD_LEFT +actionslot 3; bind DPAD_RIGHT +actionslot 4");
	self setClientDvar("compassSize", 1);
	self setClientDvar("cg_drawThroughWalls", "0");
	self setClientDvar("cg_enemyNameFadeIn", "250");
	self setClientDvar("cg_enemyNameFadeOut", "250");
	wait .1;
	self setClientDvar("perk_bulletDamage", "40");
	self setClientDvar("perk_bulletPenetrationMultiplier", "2");
	self setClientDvar("player_sprintSpeedScale", 1.5);
	self setClientDvar("player_sprintUnlimited","0");
	self setClientDvar("fx_enable", "1");
	self setClientDvar("r_fog", "1");
	//self thread ResetBinds();
	wait 1;
	self setClientDvar("player_clipSizeMultiplier",1.0);
	self setClientDvar("player_burstFireCooldown",.2);
	self setClientDvar("player_spectateSpeedScale",1);
	self setClientDvar("aim_automelee_range",128);
	self setClientDvar("aim_automelee_region_width",320);
	self setClientDvar("aim_automelee_region_height",240);
	self setClientDvar("aim_lockon_debug",0);
	self setClientDvar("aim_lockon_region_height",90);
	self setClientDvar("perk_weapReloadMultiplier",.05);
	self setClientDvar("perk_weapRateMultiplier",.75);
	wait .1;
	self setClientDvar("perk_parabolicangle",180);
	self setClientDvar("perk_parabolicradius",400);
	self setClientDvar("perk_grenadeDeath","frag_grenade_short_mp");
	self setClientDvar("phys_gravity",-800);
	self setClientDvar("bg_prone_yawcap",85); 
	self setClientDvar("fx_marks", "1");
	self setClientDvar("fx_draw", "1");
	self setClientDvar("perk_explosiveDamage", "25");
	self setClientDvar("perk_armorVest", "75");
	self setClientDvar("perk_weapspreadMultiplier", "0.65");
	wait .7;
	self setClientDvar("player_breath_hold_time",4.5);
	self setClientDvar("player_breath_gasp_lerp",6);
	self setClientDvar("player_breath_gasp_time",1);
	self setClientDvar("player_breath_gasp_scale",4.5);
	wait .1;
	self setClientDvar("g_knockback",1000);
	self setClientDvar("cg_overheadNamesFont",2);
	self setClientDvar("cg_overheadNamesSize",0.5);
	//self setClientDvar("cg_drawSnapshot",0);
	self setClientDvar("cg_drawFPS","Off");
	wait .2;
	self setClientDvar("cg_debugInfoCornerOffset","0");
	self setClientDvar("cg_ScoresPing_MaxBars",4);
	self setClientDvar("cg_ScoresPing_Interval",100);
	//self setClientDvar("cg_ScoresPing_LowColor","0");
	//self setClientDvar("cg_ScoresPing_MedColor","0.8");
	//wait .1;
	//self setClientDvar("cg_ScoresPing_HighColor","0.8");
	self setClientDvar("cg_tracerSpeed",7500);
	self setClientDvar("cg_tracerwidth",4);
	self setClientDvar("cg_tracerlength",160);
	self setClientDvar("cg_overheadNamesGlow","0");
	self setClientDvar("cg_drawlagometer",0);
	wait .6;
	self setClientDvar("cg_overheadRankSize", "0.7");
	self setClientDvar("cg_overheadIconSize", "0.7");
	self setClientDvar("cg_gun_x", "0");
	self setClientDvar("cg_gun_y", "0");
	self setClientDvar("cg_gun_z", "0");
	self setClientDvar("cg_fov", "65");
	self setClientDvar("cg_laserForceOn", "0");
	self setClientDvar("cg_drawCrosshairNames", "1");
	wait .1;
	self setClientDvar("player_meleeHeight","10");
	self setClientDvar("player_meleeRange","64");
	self setClientDvar("player_meleeWidth","10");
	self setClientDvar("cg_drawFriendlyNames", "1");
	
}
ResetBinds()
{
	wait 1;
	self setClientDvar("activeaction", "exec buttons_default.cfg;updategamerprofile");
}


ResetHealth()
{
	self setClientDvar("painVisionTriggerHealth", "1");
	setDvar("scr_player_maxhealth", "100");
	self.maxhealth = 100;
	self.health = self.maxhealth;
}

ResetPerks()
{
	
}
ResetHUD()
{
	self setClientDvar( "player_sprintCameraBob", "0.5" );
	setDvar("ui_hud_showdeathicons", "1");
	self setClientDvar("waypointIconWidth",36);
	self setClientDvar("waypointIconHeight",36);
	self setClientDvar("waypointOffscreenPointerWidth", 25);
	self setClientDvar("waypointOffscreenPointerHeight", 12);
	self setClientDvar("con_gameMsgWindow0MsgTime", 5);
	self setClientDvar("con_gameMsgWindow1MsgTime", 5);
	wait .1;
	self setClientDvar("con_gameMsgWindow0LineCount", 4 );
	self setClientDvar("nightVisionDisableEffects", 0 );
	self setClientDvar("cg_drawBreathHint", 1 );
	self setClientDvar("cg_drawMantleHint", 1 );
    self setClientDvar("scr_drawfriend", 0 );
	self setClientDvar("cg_thirdperson","0");
	self setClientDvar("cg_thirdPersonRange", 120);
	self setClientDvar("cg_thirdPersonAngle", 356 );
}
ResetGameDvars()
{
	self setClientDvar("ui_allow_teamchange","");
	setDvar("scr_game_hardpoints", 1);
}
ResetGameType()
{
	//WAR
	setDvar("scr_war_timelimit", 10 );
	setDvar("scr_war_playerrespawndelay", 0);
	setDvar("scr_war_scorelimit", 750);
	setDvar("scr_war_waverespawndelay", 0);
	setDvar("scr_war_roundswitch", 0);
	setDvar("scr_war_roundlimit", 1);
	//SD
	setDvar("scr_sd_waverespawndelay", 0);
	setDvar("scr_sd_playerrespawndelay", 0);
	setDvar("scr_sd_scorelimit", 4);
	setDvar("scr_sd_roundswitch", 3);
	setDvar("scr_sd_roundlimit", 0);
	setDvar("scr_sd_timelimit", 2.5);
	setDvar("scr_sd_numlives", 1);
	//DM
	setDvar("scr_dm_waverespawndelay", 0);
	setDvar("scr_dm_playerrespawndelay", 0);
	setDvar("scr_dm_scorelimit", 150);
	setDvar("scr_dm_roundswitch", 0);
	setDvar("scr_dm_roundlimit", 0);
	setDvar("scr_dm_timelimit", 10);
	setDvar("scr_dm_numlives", 0);
}
ResetMovement()
{
	setDvar("mantle_enable","1");
	setdvar("jump_height", 39);
	setdvar("g_speed", 190);
	setdvar("g_gravity", 800);
	setdvar("timescale", 1);
	
}
ResetColors()
{
	self setClientDvars("ui_playerPartyColor","1 0.8 0.4 1","lowAmmoWarningColor1","0.701961 0.701961 0.701961 0.8","lowAmmoWarningColor2","1 1 1 1","lowAmmoWarningNoAmmoColor1","0.8 0.25098 0.301961 0.8","lowAmmoWarningNoAmmoColor2","1 0.25098 0.301961 1","lowAmmoWarningNoReloadColor1","0.701961 0.701961 0.301961 0.701961","lowAmmoWarningNoReloadColor2","0.701961 0.701961 0.301961 1");
}
ResetScoreboard()
{
	//self setClientDvar("cg_scoreboardBannerHeight","35" );
	//self setClientDvar("cg_scoreboardFont","0");
	//self setClientDvar("cg_scoreboardHeaderFontScale","0.3" );
	//self setClientDvar("cg_scoreboardHeight","435");
	//self setClientDvar("cg_scoreboardItemHeight","18" );
	//self setClientDvar("cg_scoreboardMyColor","1 0.8 0.4 1" );
	//self setClientDvar("cg_scoreboardPingGraph","1" );
	//wait .1;
	//self setClientDvar("cg_scoreboardPingHeight","0.7" );
	//self setClientDvar("cg_scoreboardPingText","0" );
	//self setClientDvar("cg_scoreboardPingWidth","0.036" );
	//self setClientDvar("cg_scoreboardRankFontScale","0.3" );
	//self setClientDvar("cg_scoreboardScrollStep","3" );
	//self setClientDvar("cg_scoreboardTextOffset","0.62" );
	//self setClientDvar("cg_scoreboardWidth","500" );
	self thread maps\mp\gametypes\_scoreboard::init();
}
ResetTeamIcons()
{
	switch ( game["allies"] ){case "sas":game["icons"]["allies"] = "faction_128_sas";break;case "marines":default:game["icons"]["allies"] = "faction_128_usmc";break;}switch ( game["axis"] ){case "russian":game["icons"]["axis"] = "faction_128_ussr";break;case "arab":case "opfor":default:game["icons"]["axis"] = "faction_128_arab";break;}	
}





DisableCC(){}
addDefDvars(){}
addDefDvar(dvarname){if (!isDefined(level.defaultDvars))level.defaultDvars = [];level.defaultDvars[dvarname] = getdvar(dvarname);}
loadDefaultDvar(dvarname){self setClientDvar(dvarname, level.defaultDvars[dvarname]);}
CC_tast(mode){}








