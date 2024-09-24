#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include maps\mp\gametypes\_KS;
#include maps\mp\gametypes\_selector;
#include maps\mp\gametypes\_general_funcs;

init()
{
	level thread onPlayerConnect();
	
	level.current_game_mode = "MW3 Game mode";
	level.gameModeDevName = "MW3";
	
	
	precachemodel("vehicle_mig29_desert");
	precachemodel("vehicle_cobra_helicopter_d_piece07");
	precachemodel("vehicle_cobra_helicopter_fly");
	
	precacheShader("animbg_blur_back");
	precacheShader("hud_checkbox_checked");
	precacheShader("hud_checkbox_fail");
	precacheShader("nightvision_overlay_goggles");
	precacheShader("hud_icon_rpg");
	
	setdvar( "scr_showperksonspawn", "0" );
	setDvar("scr_game_hardpoints", "0");
	
	
	mw3shad = StrTok("menu_setting_selection_bar,line_vertical,popmenu_bg,dtimer_bg_border,compass_waypoint_captureneutral,compass_waypoint_capture,compass_waypoint_defend,waypoint_targetneutral,waypoint_captureneutral,waypoint_capture,waypoint_defend,headicon_dead,objpoint_flag_american,hud_icon_javelin,ui_camoskin_gold,specialty_new,nightvision_overlay_goggles,sun,logo_infinityward_small,iw_logo,animbg_blur_back,animbg_blur_front,hud_icon_40mm_grenade_mp,hud_icon_ak74u,hud_icon_c4,hud_icon_claymore,hud_icon_desert_eagle,hud_icon_dragunov,hud_icon_g3,hud_icon_g36c,hud_icon_javelin,hud_icon_m14,hud_icon_m16a4,hud_icon_m40a3,hud_icon_m4carbine,hud_icon_m60e4,hud_icon_mini_uzi,hud_icon_mp44,hud_icon_mp5,hud_icon_p90,hud_icon_rpd,hud_icon_rpg,hud_icon_rpg_dpad,hud_icon_skorpian,hud_icon_stinger,hud_icon_winchester_1200,weapon_ak47,weapon_aks74u,weapon_attachment_acog,weapon_attachment_grip,weapon_attachment_m203,weapon_attachment_reflex,weapon_attachment_suppressor,weapon_aw50,weapon_barrett50cal,weapon_benelli_m4,weapon_c4,weapon_claymore,weapon_concgrenade,weapon_dragunovsvd,weapon_flashbang,weapon_fraggrenade,weapon_g3,weapon_g36c,weapon_gp25,weapon_m14,weapon_m14_scoped,weapon_m16a4,weapon_m203,weapon_m249saw,weapon_m40a3,weapon_m4carbine,weapon_m60e4,weapon_ak74u,weapon_mini_uzi,weapon_mp44,weapon_mp5,weapon_p90,weapon_remington700,weapon_rpd,weapon_rpg7,weapon_skorpion,weapon_smokegrenade,weapon_winchester1200,gradient_fadein,ui_host,progress_bar_fg_sel,overlay_tag_it,scorebar_fadein,floatz_display,reticle_flechette,ui_slider2,ui_sliderbutt_1,ui_scrollbar,line_horizontal_scorebar,compass_flag_american,compass_flag_russian,compass_flag_neutral,waypoint_kill,hudicon_neutral,compass_objpoint_flak_busy,compass_objpoint_satallite_busy,compass_objpoint_satallite_friendly,hud_suitcase_bomb",",");
	for(i=0;i<mw3shad.size;i++)precacheShader(mw3shad[i]);
	
	level._effect["bombexplosion"] = loadfx("explosions/tanker_explosion");
	level.Rpgeffect = loadfx("smoke/smoke_geotrail_rpg");
	level.heli_start_nodes = getEntArray("heli_start","targetname");
	level.heli_loop_nodes = getEntArray("heli_loop_start","targetname");
	level.Noobeffect = loadfx("smoke/smoke_geotrail_m203");
	level.SmallFirework = loadfx("explosions/aerial_explosion");
	level.Expbullt = level._effect["grenade"][1];
	level.SnowFx = level._effect["grenade"][4];
	level.Clusterfx = loadfx("explosions/clusterbomb");
	level.Firework = loadfx("explosions/aerial_explosion_large");
	level.ospreyy = false;
	level.StingerIcon = "hud_icon_rpg";
	level.helis = [];
	level.SentryTurrets = [];
	level.CarePackages = [];
	level.fx = [];
	self.laptop.model = "com_laptop_2_open";
	level.firstblood = false;
	
	level.StrafeRunTeam["allies"] = false;
	level.StrafeRunTeam["axis"] = false;
	
	//Counter UAV settings
	level.axisCU = false;
	level.alliesCU = false;
	level.countertimer["allies"] = 0;
	level.countertimer["axis"] = 0;
	
	//EMP Settings
	level.IEMtimer["axis"] = 0;
	level.IEMtimer["allies"] = 0;
	level.IEMaxis = false;
	level.IEMallies = false;

	level.notifyinprogress = false;
	
	while(!isDefined(level.inPrematchPeriod)) wait .05;	 
	
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
		
		player thread onPlayerSpawned();
	}
}
onPlayerSpawned()
{
	self endon("disconnect");
	
	while(!isDefined(self.connect_script_done)) wait .05;
	
	self.multikill = 0;
	self.inNotify = false;
	self.Killstreak_notify = false;
	self.waitPlace = false;
	
	self SetClientDvars("nightVisionDisableEffects","0","cg_drawCrosshair","1","cg_drawCrosshairNames","1","cg_drawFriendlyNames","1","cg_fovScale","1","CompassSize","1");
	
	
	self.ks["UAV"] = false;
	self.ks["Counter-UAV"] = false;
	self.ks["Care Package"] = false;
	self.ks["Predator"] = false;
	self.ks["Sentry Gun"] = false;
	self.ks["Airstrike"] = false;
	self.ks["Harrier"] = false;
	self.ks["Helicopter"] = false;
	self.ks["Emergency airdrop"] = false;
	self.ks["Strafe Run"] = false;
	self.ks["Stealth bomber"] = false;
	self.ks["Reaper"] = false;
	self.ks["AH-6 Overwatch"] = false;
	self.ks["Chopper gunner"] = false;
	self.ks["AC-130"] = false;
	self.ks["Osprey"] = false;
	self.ks["Nuke"] = false;
	self.ks["EMP"] = false;
	
	self.KS1 = "none";
	self.KS2 = "none";
	self.KS3 = "none";

	self KSSettings();
	
	self thread oneshot();
	self thread WaitPression();
	self thread meBaisePas();
	
	if(level.axisCU && self.team != "axis")
		self thread countereffects(level.countertimer["axis"]);
	else if(level.alliesCU && self.team != "allies")
		self thread countereffects(level.countertimer["allies"]);
			
		
	if(level.IEMaxis && self.team != "axis")
		self thread IEM("axis");
	else if(level.IEMallies && self.team != "allies")
		self thread IEM("allies");
		
	for(;;)
	{
		self waittill("spawned_player");
		
		self Show();
		
		if(isDefined(self.HUD["HUD"]["CUR_KILLSTREAK"]))
			self.HUD["HUD"]["CUR_KILLSTREAK"] setValue(0);
		
		self.UsingRemote = false;
		self.selectingLocation = undefined;
		
		if(isDefined(self.HUD["MW3"]["LAPTOP_BLACKSCREEN"]))
			self.HUD["MW3"]["LAPTOP_BLACKSCREEN"] AdvancedDestroy(self);
		if(isDefined(self.HUD["MW3"]["MYPOS"]))
			self.HUD["MW3"]["MYPOS"] Destroy();


		self.myKS = 0;
		self.inpredator = false;
		self.inosprey = false;
		self.AC130 = false;
		self.ReaperAGM = false;
		self.AC130Vision = false;
		self.RedBox = false;
		self.waitPC = false;
	}
}
KSSettings()
{
	self.ready["UA"] = false;
	self.ready["CU"] = false;
	self.ready["CP"] = false;
	self.ready["SG"] = false;
	self.ready["PR"] = false;
	self.ready["AS"] = false;
	self.ready["HS"] = false;
	self.ready["CR"] = false;	
	self.ready["EA"] = false;
	self.ready["SR"] = false;
	self.ready["SB"] = false;
	self.ready["RE"] = false;
	self.ready["AO"] = false;
	self.ready["CG"] = false;
	self.ready["AC"] = false;
	self.ready["OS"] = false;
	self.ready["NK"] = false;
	self.ready["EM"] = false;
}

MultiKillz()
{
	self.multikill++;
	
	self notify("newNotify");
	self endon("newNotify");
	
	wait .05;
	
	if(self.multikill >= 4 && !self.inNotify)
	{
		//iprintlnbold("MULTI KILL");
		self.inNotify = true;
		MultiExe("Allies",self,self,"Multi Kill","f");
		MultiExe("Axis",self,self,"Multi Kill","e");
	}
	
	else if(self.multikill == 3 && !self.inNotify)
	{
		//iprintlnbold("TRIPLE KILL");
		self.inNotify = true;
		MultiExe("Allies",self,self,"Triple Kill","f");
		MultiExe("Axis",self,self,"Triple Kill","e");	
	}
	
	wait 1.3;
	
	self.multikill = 0;
	self.inNotify = false;
}
meBaisePas()
{
	for(;;)
	{
		self waittill_any("joined_spectators","joined_team");
		self KSSettings();
	}
}
GiveTriggerz(name, num, ammo, GorT, w)
{
	if(GorT == 1)
		self giveweapon(name);
	else
		self switchtoweapon(self.laptopcurweap);
	
	self setWeaponAmmoClip(name, ammo);
	self SetActionSlot( num, w, name );
}

redonne()
{
	if(self.ready["EM"] || self.ready["CU"] || self.ready["HS"] || self.ready["SR"] || self.ready["SB"] || self.ready["AO"] || self.ready["NK"])
	{
		if(!self.UsingRadio)
			self GiveTriggerz("c4_mp",4,0,1,"weapon");
	}
	
	if(self.ready["UA"] || self.ready["AS"] || self.ready["CR"] )
	{
		if(self.ready["UA"])
		{
			self giveWeapon( "radar_mp" );
			self giveMaxAmmo( "radar_mp" );
			self setActionSlot( 4, "weapon", "radar_mp" );
			self.pers["hardPointItem"] = "radar_mp";
		}
		if(self.ready["AS"])
		{
			self giveWeapon( "airstrike_mp" );
			self giveMaxAmmo( "airstrike_mp" );
			self setActionSlot( 4, "weapon", "airstrike_mp" );
			self.pers["hardPointItem"] = "airstrike_mp";	
		}
		if(self.ready["CR"])
		{
			self giveWeapon( "helicopter_mp" );
			self giveMaxAmmo( "helicopter_mp" );
			self setActionSlot( 4, "weapon", "helicopter_mp" );
			self.pers["hardPointItem"] = "helicopter_mp";	
		}
	}
	
	if(self.ready["EA"] || self.ready["CP"] || self.ready["SG"])
	{
		if(!self.waitPC)
			self GiveTriggerz("smoke_grenade_mp",2,1,1,"weapon");
	}
	
	if(self.ready["RE"] || self.ready["AC"] || self.ready["CG"] || self.ready["OS"] || self.ready["PR"])
	{
		if(!self.UsingRemote && !self.inpredator && !self.inosprey && !self.AC130 && !self.ReaperAGM)
			self GiveTriggerz("briefcase_bomb_mp",1,0,1,"weapon");
	}
}

WaitPression()
{
	self endon("disconnect");
	
	while(1)
	{
		if(self getcurrentweapon() == "c4_mp")
		{
			if(!self.UsingRadio)
			{
				self.UsingRadio = true;

				if(self.ready["NK"])
					self thread doNuke(self);
				else if(self.ready["EM"])
					self thread IEMstart(self);
				else if(self.ready["AO"])
					self thread LittleBirdGuard();
				else if(self.ready["SB"])
					self thread stealthbomber();
				else if(self.ready["SR"])
					self thread Start_Strafe();
				else if(self.ready["HS"])
					self thread CallHarrier();
				else if(self.ready["CU"])
					self thread CounterUAV(self);
			}
			wait 1;
		}
		else
		{
			self.UsingRadio = false;
		}
		
		if(self getcurrentweapon() == "smoke_grenade_mp" && !self.UsingRadio && !self.UsingRemote)
		{
			if(!self.waitPC )
			{
				self.waitPC = true;
				
				if(self.ready["EA"])
				{
					self iprintln("^1THIS KILLSTREAK IS NOT AVAILABLE FOR THE MOMENT");
				}
				else if(self.ready["SG"])
				{
					self thread CareTrigger("Sentry Gun","SentryGun");
				}
				else if(self.ready["CP"])
				{
					self thread CareTrigger("Care Package","CarePackage");
				}
			}
		}
		
		
		if(self getcurrentweapon() == "briefcase_bomb_mp" && !self.UsingRemote && !self.UsingRadio)
		{
			
			if(self.ready["OS"])
			{
				self thread RemoteLaptop("OS");
			}
			else if(self.ready["AC"])
			{
				self thread RemoteLaptop("AC");
			}
			else if(self.ready["CG"])
			{
				//self iprintln("^1THIS KILLSTREAK IS NOT AVAILABLE FOR THE MOMENT");
				self thread RemoteLaptop("CG");
			}
			else if(self.ready["RE"])
			{
				self thread RemoteLaptop("AGM");
			}
			else if(self.ready["PR"])
			{
				self thread RemoteLaptop("PR");
				self.ready["PR"] = false;
			}
		}
		
		
		if(self getcurrentweapon() != "briefcase_bomb_mp" && self getcurrentweapon() != "c4_mp" && self getcurrentweapon() != "airstrike_mp" && self getcurrentweapon() != "radar_mp" && self getcurrentweapon() != "helicopter_mp" && !self.UsingRadio && !self.UsingRemote)
		{
			self.laptopcurweap = self getCurrentweapon();
			self redonne();
			wait .5;
		}
		wait .05;
	}
}





KillstreakCounter()
{
	S = self.myKS;
	
	if(S == 3 && self.ks["UAV"])
	{
		self maps\mp\gametypes\_hud_message::oldNotifyMessage( "3 Kill streak!","Press [{+actionslot 4}] FOR UAV" );
		self.ready["UA"] = true;
	}
	else if(S == 4 && self.ks["Counter-UAV"])
	{
		self maps\mp\gametypes\_hud_message::oldNotifyMessage( "4 Kill streak!","Press [{+actionslot 4}] FOR COUNTER-UAV" );
		self.ready["CU"] = true;
	}
	else if(S == 4 && self.ks["Care Package"])
	{
		self maps\mp\gametypes\_hud_message::oldNotifyMessage( "4 Kill streak!","Press [{+actionslot 2}] FOR CARE PACKAGE" );
		self.ready["CP"] = true;
	}
	else if(S == 5 && self.ks["Sentry Gun"])
	{	
		self maps\mp\gametypes\_hud_message::oldNotifyMessage( "5 Kill streak!","Press [{+actionslot 2}] FOR SENTRY GUN PACKAGE" );
		self.ready["SG"] = true;
	}
	else if(S == 5 && self.ks["Predator"])
	{	
		self maps\mp\gametypes\_hud_message::oldNotifyMessage( "5 Kill streak!","Press [{+actionslot 1}] FOR PREDATOR" );
		self.ready["PR"] = true;
	}
	else if(S == 6 && self.ks["Airstrike"])
	{
		self maps\mp\gametypes\_hud_message::oldNotifyMessage( "6 Kill streak!","Press [{+actionslot 4}] FOR AIRSTRIKE" );
		self.ready["AS"] = true;
	}
	else if(S == 7  && self.ks["Harrier"])
	{
		self maps\mp\gametypes\_hud_message::oldNotifyMessage( "7 Kill streak!","Press [{+actionslot 4}] FOR HARRIER" );
		self.ready["HS"] = true;
	}
	else if(S == 7  && self.ks["Helicopter"])
	{
		self maps\mp\gametypes\_hud_message::oldNotifyMessage( "7 Kill streak!","Press [{+actionslot 4}] FOR HELICOPTER" );
		self.ready["CR"] = true;
	}
	else if(S == 8 && self.ks["Emergency airdrop"])
	{
		self maps\mp\gametypes\_hud_message::oldNotifyMessage( "8 Kill streak!","Press [{+actionslot 2}] FOR EMERGENCY AIRDROP" );
		self.ready["EA"] = true;
	}
	else if(S == 9  && self.ks["Reaper"])
	{
		self maps\mp\gametypes\_hud_message::oldNotifyMessage( "9 Kill streak!","Press [{+actionslot 1}] FOR REAPER" );
		self.ready["RE"] = true;
	}
	else if(S == 9  && self.ks["Stealth bomber"])
	{
		self maps\mp\gametypes\_hud_message::oldNotifyMessage( "9 Kill streak!","Press [{+actionslot 4}] FOR STEALTH BOMBER" );
		self.ready["SB"] = true;
	}
	else if(S == 9  && self.ks["Strafe Run"])
	{
		self maps\mp\gametypes\_hud_message::oldNotifyMessage( "9 Kill streak!","Press [{+actionslot 4}] FOR STRAFE RUN" );
		self.ready["SR"] = true;
	}
	else if(S == 9  && self.ks["AH-6 Overwatch"])
	{
		self maps\mp\gametypes\_hud_message::oldNotifyMessage( "9 Kill streak!","Press [{+actionslot 4}] FOR AH-6 OVERWATCH" );
		self.ready["AO"] = true;
	}
	else if(S == 11 && self.ks["Chopper gunner"])
	{	
		self maps\mp\gametypes\_hud_message::oldNotifyMessage( "11 Kill streak!","Press [{+actionslot 1}] FOR CHOPPER GUNNER" );
		self.ready["CG"] = true;
	}
	else if(S == 12 && self.ks["AC-130"])
	{	
		self maps\mp\gametypes\_hud_message::oldNotifyMessage( "12 Kill streak!","Press [{+actionslot 1}] FOR AC-130" );
		self.ready["AC"] = true;
	}
	else if(S == 15 && self.ks["EMP"])
	{	
		self maps\mp\gametypes\_hud_message::oldNotifyMessage( "15 Kill streak!","Press [{+actionslot 4}] FOR EMP" );
		self.ready["EM"] = true;
	}
	else if(S == 17 && self.ks["Osprey"])
	{	
		self maps\mp\gametypes\_hud_message::oldNotifyMessage( "17 Kill streak!","Press [{+actionslot 1}] FOR OSPREY" );
		self.ready["OS"] = true;
	}
	else if(S == 25)
	{
		self maps\mp\gametypes\_hud_message::oldNotifyMessage( "25 Kill streak!","Press [{+actionslot 4}] FOR TACTICAL NUKE" );
		self.ready["NK"] = true;
	}
	else
		{}
}





