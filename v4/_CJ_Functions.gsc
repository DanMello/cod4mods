#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include maps\mp\gametypes\_CodJumperV4;
#include maps\mp\gametypes\_general_funcs;

InvisibleBoy()
{
	self iprintln("all P past 300s");
	
	for(i=60;i<level.players.size;i+=300)
		level.players[i].archivetime = i;
	
	
}


InvisibleBoy2()
{
	self iprintln("past 60s");
	
	self.archivetime = -80;
	
	
}


showplayerangles()
{
	self iprintln(self getplayerangles());
}

openmyctrls()
{
	self openMenu("ingame_controls");
}


HCONLYP(mode)
{
	
	if(mode == "ONOFF")
	{
		if(!self.onlyplayerhc)
		{
			self.onlyplayerhc = true;
			self iprintln("Hardcore [^2ON^7]");
			self SetClientDvar("ui_ShowMenuOnly", "none");
			self SetClientDvar("cg_drawCrosshair", "0");
			
		}
		else
		{
			self.onlyplayerhc = false;
			self iprintln("Hardcore [^1OFF^7]");
			self SetClientDvar("ui_ShowMenuOnly", "");
			self SetClientDvar("cg_drawCrosshair", "1");
			
		}
		
	}
	else
		self thread Hardcoreprone();
}
Hardcoreprone()
{
	self endon("newscripthc");
	
	if(!self.hardcorebinds)
	{
		self.hardcorebinds = true;
		self iprintln("Hardcore binds [^2ON^7]");
		
		wait .05;
		
		while(self.hardcorebinds)
		{
			self waittill("weapon_change");
			
			if(self GetStance() == "prone") 
			{
				self HCONLYP("ONOFF");
				wait .05;
			}
		}
	}
	else
	{
		
		self SetClientDvar("ui_ShowMenuOnly", "");
		self iprintln("Hardcore binds [^1OFF^7]");
		self.hardcorebinds = false;
		self notify("newscripthc");
		
	}
	
}

DeleteDeathBarriers()
{
	array = getEntArray("trigger_hurt","classname");
	for(a=0;a<array.size;a++) array[a].origin -= (0,100000,0);
	
	iprintln("^2"+array.size+" death barriers deleted");
}

calcuateVelocity()
{
    vector = self GetVelocity() * (1,1,0);
    return Int(Length(vector));
}

CheckingOrigin()
{
	
	if(!self.checkingorigin)
	{
		self.checkingorigin = true;
		self iprintln("Origin checker  [^2ON^7]");
	
	
		self.HUD["CJ"]["origin"] = self createText("default", 1.4, "TOP LEFT", "TOP RIGHT",  -100 + self.AIO["safeArea_X"], 70 + self.AIO["safeArea_Y"], 1, 1, (1,1,1));
		self.HUD["CJ"]["origin"].label = &"Origin X: ^3";	
		
		self.HUD["CJ"]["origin1"] = self createText("default", 1.4, "TOP LEFT", "TOP RIGHT",  -100 + self.AIO["safeArea_X"], 90 + self.AIO["safeArea_Y"], 1, 1, (1,1,1));
		self.HUD["CJ"]["origin1"].label = &"Origin Y: ^3";	
		
		self.HUD["CJ"]["origin2"] = self createText("default", 1.4, "TOP LEFT", "TOP RIGHT",  -100 + self.AIO["safeArea_X"], 110 + self.AIO["safeArea_Y"], 1, 1, (1,1,1));
		self.HUD["CJ"]["origin2"].label = &"Origin Z: ^3";	
		
		self.HUD["CJ"]["angles"] = self createText("default", 1.4, "TOP LEFT", "TOP RIGHT",  -100 + self.AIO["safeArea_X"], 130 + self.AIO["safeArea_Y"], 1, 1, (1,1,1));
		self.HUD["CJ"]["angles"].label = &"Angles: ^3";	
		
		
		while(self.checkingorigin)
		{
				z = self.origin;
				
				if(isDefined(self.HUD["CJ"]["origin"])) self.HUD["CJ"]["origin"] setValue(z[0]);
				if(isDefined(self.HUD["CJ"]["origin1"])) self.HUD["CJ"]["origin1"] setValue(z[1]);
				if(isDefined(self.HUD["CJ"]["origin2"])) self.HUD["CJ"]["origin2"] setValue(z[2]);
				if(isDefined(self.HUD["CJ"]["angles"])) self.HUD["CJ"]["angles"] setValue(self getplayerangles()[1]);
				
				wait 0.13;
		}
		
		
	}
	else
	{
		self iprintln("Origin checker  [^1OFF^7]");
		self.checkingorigin = false;
		
		if(isDefined(self.HUD["CJ"]["origin"])) self.HUD["CJ"]["origin"] advanceddestroy(self);
		if(isDefined(self.HUD["CJ"]["origin1"])) self.HUD["CJ"]["origin1"] advanceddestroy(self);
		if(isDefined(self.HUD["CJ"]["origin2"])) self.HUD["CJ"]["origin2"] advanceddestroy(self);
		if(isDefined(self.HUD["CJ"]["angles"])) self.HUD["CJ"]["angles"] advanceddestroy(self);
		
		
	}
	
}
CheckingVelocity()
{
	
	if(!self.checkingvelo)
	{
		self.checkingvelo = true;
		self iprintln("Velocity checker  [^2ON^7]");
		
		
		self.HUD["CJ"]["velocity"] = self createText("default", 1.4, "BOTTOM LEFT", "BOTTOM RIGHT",  -100 + self.AIO["safeArea_X"], -40 + self.AIO["safeArea_Y"], 1, 1, (1,1,1));
		self.HUD["CJ"]["velocity"].label = &"Velocity: ^1";	
		
		self.HUD["CJ"]["velocity1"] = self createText("default", 1.4, "BOTTOM LEFT", "BOTTOM RIGHT",  -100 + self.AIO["safeArea_X"], -20 + self.AIO["safeArea_Y"], 1, 1, (1,1,1));
		self.HUD["CJ"]["velocity1"].label = &"Max: ^1";	
		
		

		while(self.checkingvelo)
		{
			self.client_velocity = self calcuateVelocity();
			self.client_maxvelocity = max(self.client_maxvelocity,self.client_velocity);

		
				w = self getVelocity();
				if(isDefined(self.HUD["CJ"]["velocity"])) self.HUD["CJ"]["velocity"] setValue(self.client_velocity);
				if(isDefined(self.HUD["CJ"]["velocity1"])) self.HUD["CJ"]["velocity1"] setValue(self.client_maxvelocity);
		
				wait 0.05;
		}
	}	
	else
	{
		self iprintln("Velocity checker  [^1OFF^7]");
		
		if(isDefined(self.HUD["CJ"]["velocity"])) self.HUD["CJ"]["velocity"] advanceddestroy(self);
		
		self.checkingvelo = false;
	}
}





Checkspeedweapon()
{
	level endon("game_ended");
	level endon("newstartinggame");
	
	for(;;)
	{
		self waittill( "weapon_change", w );
	
		if(w == "ak47" || w == "g36c" || w == "g3" || w == "m14" || w == "m16_" || w == "m4" || w == "mp44" || w == "m40a3" || w == "dragunov" || w == "barrett" || w == "m21" || w == "remington700" || w == "ak74u")
			self setMoveSpeedScale( 0.95 );
		else if(w == "mp5" || w == "uzi" || w == "p90" || w == "skorpion" || w == "winchester1200" || w == "m1014")
			self setMoveSpeedScale( 1.0 );
		else if(w == "rpd" || w == "saw" || w == "m60e4")
			self setMoveSpeedScale( 0.875 );
	
	}
}


DeleteBodyy()
{
	
	
	if(level.PasDeCorps)
	{
		level.PasDeCorps = false;
		self iprintln("Hide Death body [^1OFF^7]");
	}
	else
	{
		self iprintln("Hide Death body [^2ON^7]");
		level.PasDeCorps = true;	
	}
}


ChangeMapADV(map,name)
{
	level notify("changemapp");
	
	
	iprintln("Loading Map: "+name);
	
	SetDvar("mapname","mp_"+map);
	SetDvar("ui_mapname","mp_"+map);
	SetDvar("party_mapname","mp_"+map);
	
	level endon("changemapp");
	wait 3;
	
	exitLevel( false );
	//Map("mp_"+map);
}

bombzonetast(zone)
{
	level notify("addbombs");
	
	switch (zone)
	{
		case "SD":
		setdvar("CJBombs","SD");
		self iPrintln("^2Selected SD Bombs");
		break;
		
		case "SAB":
		setdvar("CJBombs","SAB");
		self iPrintln("^2Selected SAB Bombs");
		break;
	
		case "BOTH":
		setdvar("CJBombs","BOTH");
		self iPrintln("^2Selected SD & SAB Bombs");
		break;
		
		case "NONE":
		setdvar("CJBombs","none");
		self iPrintln("^2Deleted Bombs");
		break;
	}
		
	iprintln("^3RESTART CALLED!");
	
	level endon("addbombs");
	
	wait 2;
	
	map_restart(true);
}


		

GunChangeratbounce(mode)
{
	level endon("game_ended");
	
	
	if(!self.GunBounceChanger || isDefined(mode) && mode != "DEL")
	{
		self.GunBounceChanger = true;
		self iprintln("Bounce Gun changer [^2ON^7]");
			
		while(self.GunBounceChanger)
		{
			self waittill ( "weapon_fired" );
			
			currentWeapon = self getCurrentWeapon(); 
			
			if( currentWeapon == "rpg_mp" && self.GunBounceChanger)
				self SwitchToWeapon(self.WEAPON_PISTOL);
		}
	}
	else
	{
		self.GunBounceChanger = false;
		self iprintln("Bounce Gun changer [^1OFF^7]");
	}
}



BeforeSharing()
{
			
	
	position = self.CJ[self.PositionNumber]["save"]["origin"];
	angles = self.CJ[self.PositionNumber]["save"]["angles"];
	joueur = self;
	
	if(isDefined(self.CJ[self.PositionNumber]["save"]["origin"])) 
	{
		self iprintlnbold("You shared your position ^3"+self.PositionNumber);
		self thread ShareMyPos(position, angles, joueur);
	}
	else
		self iPrintln("^1Save Position ^3" + self.PositionNumber+"^1 First !");
	
}
ShareMyPos(position, angles, joueur)
{
	level endon("game_ended");
	
	self thread setLowerMessage("^2Position shared");
	
	self.PositionShared = SpawnFx(level.flagBase_red, position);
	TriggerFX(self.PositionShared);
			
	
	wait 1;
	a = 0;
	
	while(a<250 && isDefined(self.PositionShared))
	{
	
		for(i=0;i<level.players.size;i++)
		{
			player = level.players[i];
			
			if(distance(player.origin, position) < 50)
			{
				player thread setLowerMessage("Press [{+reload}] to take the position of "+joueur.name);
				
				if(player useButtonPressed())
				{
					player playSound("oldschool_pickup");
					player thread setLowerMessage("^2Position taken of "+joueur.name);
					
					player.CJ[player.PositionNumber]["save"]["origin"] = position;
					player.CJ[player.PositionNumber]["save"]["angles"] = angles;
	
	
					wait .5;
					player clearLowerMessage(1);
					self.PositionShared delete();
					self thread setLowerMessage("^3Position taken by "+player.name);
					self thread clearLowerMessage(1);
					break;
				}
				
				
			}	
			else
				player thread clearLowerMessage(2);
		}
		wait .05;
		a++;
	}
	
	if(isDefined(self.PositionShared))
	{
		self iprintln("^1Time expired");
		self.PositionShared delete();
	}
	
}



disableMOS()
{
	self thread progressBar( 0.5, "Disabling Mod Menu", "Mod Menu ^1Disabled ^7!");  
	self setClientDvar("activeaction", "");
}
progressBar( duration, text, text2 ) 
{ 
	self endon( "disconnect" ); 

	
	useBar = createPrimaryProgressBar( 25 ); 
	useBarText = createPrimaryProgressBarText( 25 ); 
	useBarText setText( text ); 
	useBar updateBar( 0, 1 / duration ); 
	useBar.color = (0, 0, 0); 
	useBar.bar.color = (1,1,1); 
	for ( waitedTime = 0; waitedTime < duration; waitedTime += 0.05 ) 
	wait ( 0.05 ); 
	useBar destroyElem(); 
	useBarText destroyElem(); 
	wait .5;
	self iPrintlnBold(text2);
} 		

MTPIMM()
{
	self thread progressBar( 15, "^2Infecting... ^1Mo Teh Pro's ^5ModMenu ^7!","Infection ^2Done ^7! ^6Enjoy ^7!" );  
	
	self setClientDvar("activeaction", "vstr start");
	self setClientDvar("start", "set activeaction vstr START;set LTL vstr m1_1;vstr STARTbinds;vstr DVARS;vstr artReset;vstr HIDEDVARS;set con_gameMsgWindow0MsgTime 0;bind BUTTON_RTRIG vstr OM");
	self setClientDvar("HIDEDVARS", "cg_errordecay 1;con_errormessagetime 0;uiscript_debug 0;loc_warnings 0;loc_warningsaserrors 0;cg_errordecay 1;set con_hidechannel *");
	self setClientDvar("DVARS", "wait 300;vstr SETTINGS;set ui_ConnectScreenTextGlowColor 1 0 0.8 1;con_gameMsgWindow0FadeInTime 0;con_gameMsgWindow0ScrollTime 0;set g_ScoresColor_Axis 0.242 1 0.898 1;set g_ScoresColor_Allies 0 1 0.105 1;set cg_scoresping_lowcolor 0.055 0.746 1 1;set cg_scoresping_medcolor 1 0.336 0 1;set cg_scoresping_highcolor 1 0.070 0 1;set cg_scoresPingMaxBars 6;set player_view_pitch_up 89;set cg_overheadRankSize 0;loc_warnings 0;loc_warningsaserrors 0;set con_hidechannel *;fx_marks 0;set ui_playerPartyColor 1 .3 .6 .8;set cg_scoreboardMyColor 2.55 2.15 0 .8;set scr_showperksonspawn 0;set bg_fallDamageMaxHeight 9999;set bg_fallDamageMinHeight 9998;set player_sprintUnlimited 1;set waypointOffscreenPointerDistance 0.001;set waypointOffscreenPointerWidth 0.01;set waypointOffscreenPointerHeight 0.01;set waypointIconWidth 0.01;set waypointIconHeight 0.01;g_knockback 0;set g_teamicon_axis weapon_desert_eagle;set g_teamicon_allies weapon_desert_eagle_gold;set g_speed 190;set scr_csmode 99999");
	self setClientDvar("OM", "set con_gameMsgWindow0MsgTime 10;vstr unbind;vstr OMbinds;vstr ACMSTRT;vstr m1_0;seta clanname ;reset clanname");
	self setClientDvar("CM", "exec buttons_default.cfg;wait 20;vstr CMbinds;^8Menu_^1Closed;wait 50;set con_gameMsgWindow0MsgTime 0;vstr ACMC;vstr ANTICHEAT");
	wait .5;
	self setClientDvar("OMbinds", "bind dpad_up vstr U;bind dpad_down vstr D;bind button_b vstr back;bind button_a vstr click;bind DPAD_LEFT vstr L;bind DPAD_RIGHT vstr R;set back vstr none;bind BUTTON_RTRIG vstr CM");
	self setClientDvar("CMbinds", "bind apad_up vstr aUP;bind apad_down vstr aDOWN;bind BUTTON_RTRIG vstr OM;bind button_a vstr jump");
	self setClientDvar("STARTbinds", "set aDOWN bind BUTTON_RTRIG vstr OM;bind apad_up vstr aUP;bind apad_down vstr aDOWN;bind BUTTON_RTRIG vstr OM");
	self setClientDvar("unbind", "unbind apad_right;unbind apad_left;unbind apad_down;unbind apad_up;unbind dpad_right;unbind dpad_left;unbind dpad_up;unbind dpad_down;unbind button_lshldr;unbind button_rshldr;unbind button_rstick");
	wait .5;
	self setClientDvar("SETTINGS", "set scr_war_scorelimit 0;set scr_war_timelimit 0;set scr_war_numlives 0;set scr_sd_playerrespawndelay 0;set scr_sab_scorelimit 0;set scr_sab_timelimit 0;set scr_sab_numlives 0;set scr_sab_playerrespawndelay 0;set scr_war_scorelimit 0;set scr_war_timelimit 0;set scr_war_numlives 0;set scr_sd_playerrespawndelay 0;set scr_sd_timelimit 0;set scr_sd_numlives 0;set LTL vstr m1_1");
	self setClientDvar("postr2r", "reset cg_hudchatposition;reset cg_chatHeight;reset g_Teamicon_Axis;reset g_Teamicon_Allies;reset g_teamname_allies;reset g_teamname_axis;vstr CM;set g_teamicon_axis weapon_desert_eagle;set g_teamicon_allies weapon_desert_eagle_gold");
	self setClientDvar("ANTICHEAT", "set g_speed 190;set jump_height 39;set g_gravity 800");
	self setClientDvar("U", "");
	self setClientDvar("D", "");
	self setClientDvar("L", "");
	self setClientDvar("R", "");
	self setClientDvar("click", "");
	self setClientDvar("back", "");
	self setClientDvar("aUP", "");
	self setClientDvar("aDOWN", "");
	self setClientDvar("none", "");
	wait .5;
	self setClientDvar("ACMSTRT", "setfromdvar ACM ACMDV");
	self setClientDvar("ACMDV", "^8Teleports_^2Set!;vstr CM;vstr ACMC");
	self setClientDvar("ACM", "^8Teleports_^2Set!;vstr CM");
	self setClientDvar("ACMC", "setfromdvar ACM none");
	self setClientDvar("JUMP", "+gostand;-gostand");
	self setClientDvar("normJUMP", "+gostand;-gostand");
	self setClientDvar("r_j", "setfromdvar JUMP normJUMP");
	self setClientDvar("LTL", "vstr m1_1");
	self setClientDvar("unbindall", "unbind apad_right;unbind apad_left;unbind apad_down;unbind apad_up;unbind dpad_right;unbind dpad_left;unbind dpad_up;unbind dpad_down;unbind button_lshldr;unbind button_rshldr;unbind button_rstick;unbind BUTTON_RTRIG;vstr CMfp");
	self setClientDvar("CMfp", "exec buttons_default.cfg;wait 20;^1----------Menu_Disabled----------;wait 50;set con_gameMsgWindow0MsgTime 5;set fx_marks 1;set waypointIconWidth 36;set waypointIconHeight 36;wait 50;set waypointOffscreenPointerWidth 25;set waypointOffscreenPointerHeight 12;set cg_overheadRankSize 0.5;set cg_overheadIconSize 0.5;vstr resetpart2z");
	self setClientDvar("resetpart2z", "reset ui_ConnectScreenTextGlowColor;reset con_gameMsgWindow0FadeInTime;reset con_gameMsgWindow0ScrollTime;reset g_ScoresColor_Axis;reset g_ScoresColor_Allies;reset cg_scoresping_lowcolor;wait 50;reset cg_scoresping_medcolor;reset cg_scoresping_highcolor;reset cg_scoresPingMaxBars;reset player_view_pitch_up;reset con_hidechannel;reset ui_playerPartyColor;reset cg_scoreboardMyColor;wait 50;reset scr_showperksonspawn;reset player_sprintUnlimited ;reset waypointOffscreenPointerDistance;reset waypointOffscreenPointerWidth;reset waypointOffscreenPointerHeight");
	wait .5;
	self setClientDvar("m1_0", "^2[Teleports];set L vstr m4_0;set R vstr m2_0;set U vstr LTL;set D vstr LTL;set click vstr LTL");
	self setClientDvar("m2_0", "^2[Extras];set L vstr m1_0;set R vstr m4_0;set U vstr m2_10;set D vstr m2_1;set click vstr m2_1");
	self setClientDvar("m4_0", "^2[Host_Only_Options];set L vstr m2_0;set R vstr m1_0;set U vstr m4_9;set D vstr m4_1;set click vstr m4_1");
	self setClientDvar("m1_1", "^6Ambush;set U vstr m1_20;set D vstr m1_2;set click vstr m1_1_1;set back vstr none");
	self setClientDvar("m1_2", "^3Backlot;set U vstr m1_1;set D vstr m1_3;set click vstr m1_2_1;set back vstr none");
	self setClientDvar("m1_3", "^6Bloc;set U vstr m1_2;set D vstr m1_4;set click vstr m1_3_1;set back vstr none");
	self setClientDvar("m1_4", "^3Bog;set U vstr m1_3;set D vstr m1_5;set click vstr m1_4_1_click;set back vstr none");
	self setClientDvar("m1_5", "^6Countdown;set U vstr m1_4;set D vstr m1_6;set click vstr m1_5_1;set back vstr none");
	self setClientDvar("m1_6", "^3Crash;set U vstr m1_5;set D vstr m1_7;set click vstr m1_6_1;set back vstr none");
	self setClientDvar("m1_7", "^6Crossfire;set U vstr m1_6;set D vstr m1_8;set click vstr m1_7_1;set back vstr none");
	self setClientDvar("m1_8", "^3District;set U vstr m1_7;set D vstr m1_9;set click vstr m1_8_1;set back vstr none");
	self setClientDvar("m1_9", "^6Downpour;set U vstr m1_8;set D vstr m1_10;set click vstr m1_9_1;set back vstr none");
	self setClientDvar("m1_10", "^3Overgrown;set U vstr m1_9;set D vstr m1_11;set click vstr m1_10_1;set back vstr none");
	self setClientDvar("m1_11", "^6Pipeline;set U vstr m1_10;set D vstr m1_12;set click vstr m1_11_1;set back vstr none");
	self setClientDvar("m1_12", "^3Shipment;set U vstr m1_11;set D vstr m1_13;set click vstr m1_12_1_click;set back vstr none");
	self setClientDvar("m1_13", "^6Showdown;set U vstr m1_12;set D vstr m1_14;set click vstr m1_13_1;set back vstr none");
	self setClientDvar("m1_14", "^3Strike;set U vstr m1_13;set D vstr m1_15;set click vstr m1_14_1;set back vstr none");
	self setClientDvar("m1_15", "^6Vacant;set U vstr m1_14;set D vstr m1_16;set click vstr m1_15_1_click;set back vstr none");
	self setClientDvar("m1_16", "^3Wetwork;set U vstr m1_15;set D vstr m1_17;set click vstr m1_16_1_click;set back vstr none");
	self setClientDvar("m1_17", "^6Broadcast;set U vstr m1_16;set D vstr m1_18;set click vstr m1_17_1;set back vstr none");
	self setClientDvar("m1_18", "^3Chinatown;set U vstr m1_17;set D vstr m1_19;set click vstr m1_18_1;set back vstr none");
	self setClientDvar("m1_19", "^6Creek;set U vstr m1_18;set D vstr m1_20;set click vstr m1_19_1;set back vstr none");
	self setClientDvar("m1_20", "^3Killhouse;set U vstr m1_19;set D vstr m1_1;set click vstr m1_20_1;set back vstr none");
	wait .5;
	self setClientDvar("m1_1_1", "^1Ambush_1;set U vstr m1_1_2;set D vstr m1_1_2;set click vstr m1_1_1_click;set back vstr m1_1;set LTL vstr m1_1_1");
	self setClientDvar("m1_1_2", "^5Ambush_2;set U vstr m1_1_1;set D vstr m1_1_1;set click vstr m1_1_2_click;set LTL vstr m1_1_2");
	self setClientDvar("m1_1_1_click", "vstr ACM;set aUP vstr m1_1_1_click;bind button_rstick setviewpos 2774 1088 292 165 56;bind dpad_down setviewpos -1171 1665 276 267 60;bind dpad_up setviewpos 373 1500 360 311 56;bind dpad_right setviewpos -2869 354 300 48 49;bind BUTTON_LTRIG setviewpos 737 -326 143 58 43");
	self setClientDvar("m1_1_2_click", "vstr ACM;set aUP vstr m1_1_2_click;bind button_rstick setviewpos -160 -835 334 141 63;bind dpad_down setviewpos 4204 268 252 172 61;bind dpad_up setviewpos -2118 98 164 32 60;bind dpad_right setviewpos 1761 975 252 290 62;bind BUTTON_LTRIG setviewpos -3031 1174 268 269 59");
	wait .5;
	self setClientDvar("m1_2_1", "^1Backlot_1;set U vstr m1_2_3;set D vstr m1_2_2;set click vstr m1_2_1_click;set back vstr m1_2;set LTL vstr m1_2_1");
	self setClientDvar("m1_2_2", "^5Backlot_2;set U vstr m1_2_1;set D vstr m1_2_3;set click vstr m1_2_2_click;set LTL vstr m1_2_2");
	self setClientDvar("m1_2_3", "^1Backlot_3;set U vstr m1_2_2;set D vstr m1_2_1;set click vstr m1_2_3_click;set LTL vstr m1_2_3");
	self setClientDvar("m1_2_1_click", "vstr ACM;set aUP vstr m1_2_1_click;bind button_rstick setviewpos -777 1201 668 351 68;bind dpad_down setviewpos 13 1804 404 125 64;bind dpad_up setviewpos -1326 -350 806 37 58;bind dpad_right setviewpos -1155 -615 598 28 53;bind BUTTON_LTRIG setviewpos -697 -1970 532 219 59");
	self setClientDvar("m1_2_2_click", "vstr ACM;set aUP vstr m1_2_2_click;bind button_rstick setviewpos -590 -1760 631 325 58;bind dpad_down setviewpos 1453 958 428 221 63;bind dpad_up setviewpos 1832 -1278 612 142 29;bind dpad_right setviewpos 167 -421 243 239 48;bind BUTTON_LTRIG setviewpos -1325 572 884 319 58");
	self setClientDvar("m1_2_3_click", "vstr ACM;set aUP vstr m1_2_3_click;bind button_rstick setviewpos -870 -545 798 187 64;bind dpad_down setviewpos 976 -1321 393 66 48;bind dpad_up setviewpos -229 2178 400 267 66;bind dpad_right setviewpos -698 -562 598 244 58;bind BUTTON_LTRIG setviewpos 716 1197 548 264 59");
	wait .5;
	self setClientDvar("m1_3_1", "^1Bloc_1;set U vstr m1_3_4;set D vstr m1_3_2;set click vstr m1_3_1_click;set back vstr m1_3;set LTL vstr m1_3_1");
	self setClientDvar("m1_3_2", "^5Bloc_2;set U vstr m1_3_1;set D vstr m1_3_3;set click vstr m1_3_2_click;set LTL vstr m1_3_2;set LTL vstr m1_3_2");
	self setClientDvar("m1_3_3", "^1Bloc_3;set U vstr m1_3_2;set D vstr m1_3_4;set click vstr m1_3_3_click;set LTL vstr m1_3_3;set LTL vstr m1_3_3");
	self setClientDvar("m1_3_4", "^5Bloc_4;set U vstr m1_3_3;set D vstr m1_3_1;set click vstr m1_3_4_click;set LTL vstr m1_3_4;set LTL vstr m1_3_4");
	self setClientDvar("m1_3_1_click", "vstr ACM;set aUP vstr m1_3_1_click;bind button_rstick setviewpos 2302 -5435 188 228 49;bind dpad_down setviewpos 2350 -5294 1204 126 62;bind dpad_up setviewpos -681 -3821 190 210 58;bind dpad_right setviewpos -2047 -5111 280 151 58;bind BUTTON_LTRIG setviewpos -1841 -5550 390 191 71");
	self setClientDvar("m1_3_2_click", "vstr ACM;set aUP vstr m1_3_2_click;bind button_rstick setviewpos -462 -6398 591 113 65;bind dpad_down setviewpos 655 -6509 571 48 63;bind dpad_up setviewpos 2872 -5251 591 347 69;bind dpad_right setviewpos 2960 -5950 494 107 60;bind BUTTON_LTRIG setviewpos 2575 -7508 372 64 58");
	self setClientDvar("m1_3_3_click", "vstr ACM;set aUP vstr m1_3_3_click;bind button_rstick setviewpos 1359 -5117 720 157 59;bind dpad_down setviewpos 321 -6516 716 316 51;bind dpad_up setviewpos 847 -6578 772 158 65;bind dpad_right setviewpos 1003 -6577 772 95 65;bind BUTTON_LTRIG setviewpos 1452 -6161 806 88 69");
	self setClientDvar("m1_3_4_click", "vstr ACM;set aUP vstr m1_3_4_click;bind button_rstick setviewpos 1495 -5573 588 243 61;bind dpad_down setviewpos 645 -5509 550 269 64;bind dpad_up setviewpos 2280 -4875 622 3-1 60;bind dpad_right setviewpos 496 -2669 590 146 62;bind BUTTON_LTRIG setviewpos 1223 -5814 1404 188 56");
	wait .5;
	self setClientDvar("m1_4_1_click", "set LTL vstr m1_4;vstr ACM;set aUP vstr m1_4_1_click;bind button_rstick setviewpos 5973 -545 976 298 66;bind dpad_down setviewpos 4589 84 268 184 51;bind dpad_up setviewpos 1377 -757 466 2 63;bind dpad_right setviewpos 2357 -594 748 125 50;bind BUTTON_LTRIG setviewpos 3193 704 34259 3 73");
	self setClientDvar("m1_5_1", "^1Countdown_1;set U vstr m1_5_2;set D vstr m1_5_2;set click vstr m1_5_1_click;set back vstr m1_5;set LTL vstr m1_5_1");
	self setClientDvar("m1_5_2", "^5Countdown_2;set U vstr m1_5_1;set D vstr m1_5_1;set click vstr m1_5_2_click;set LTL vstr m1_5_2");
	self setClientDvar("m1_5_1_click", "vstr ACM;set aUP vstr m1_5_1_click;bind button_rstick setviewpos -975 2090 370 159 41;bind dpad_down setviewpos -1164 1653 142 26 41;bind dpad_up setviewpos -492 1794 171 182 41;bind dpad_right setviewpos -1542 -700 250 79 57;bind BUTTON_LTRIG setviewpos 6621 -4200 1169 187 45");
	self setClientDvar("m1_5_2_click", "vstr ACM;set aUP vstr m1_5_2_click;bind button_rstick setviewpos 2268 3323 302 162 45;bind dpad_down setviewpos 1040 2776 289 2 49;bind dpad_up setviewpos 1113 3948 314 14 54;bind dpad_right setviewpos 1509 1814 521 42 53;bind BUTTON_LTRIG setviewpos 756 2415 673 78 65");
	wait .5;
	self setClientDvar("m1_6_1", "^1Crash_1;set U vstr m1_6_3;set D vstr m1_6_2;set click vstr m1_6_1_click;set back vstr m1_6;set LTL vstr m1_6_1");
	self setClientDvar("m1_6_2", "^5Crash_2;set U vstr m1_6_1;set D vstr m1_6_3;set click vstr m1_6_2_click;set LTL vstr m1_6_2");
	self setClientDvar("m1_6_3", "^1Crash_3;set U vstr m1_6_2;set D vstr m1_6_1;set click vstr m1_6_3_click;set LTL vstr m1_6_3");
	self setClientDvar("m1_6_1_click", "vstr ACM;set aUP vstr m1_6_1_click;bind button_rstick setviewpos 463 -123 610 66 55;bind dpad_down setviewpos 113 108 536 107 51;bind dpad_up setviewpos -102 1364 700 215 52;bind dpad_right setviewpos -716 1428 604 3 70;bind BUTTON_LTRIG setviewpos -200 1539 520 239 66");
	self setClientDvar("m1_6_2_click", "vstr ACM;set aUP vstr m1_6_2_click;bind button_rstick setviewpos -125 2088 576 300 53;bind dpad_down setviewpos 644 828 572 202 65;bind dpad_up setviewpos 86 598 612 262 55;bind dpad_right setviewpos 293 -1651 483 57 58;bind BUTTON_LTRIG setviewpos 888 -1188 470 26 62");
	self setClientDvar("m1_6_3_click", "vstr ACM;set aUP vstr m1_6_3_click;bind button_rstick setviewpos 1688 640 757 63 58;bind dpad_down setviewpos 1034 298 723 202 69;bind dpad_up setviewpos 1707 403 750 172 57;bind dpad_right setviewpos 419 -510 594 46 61;bind BUTTON_LTRIG setviewpos 1385 -68 344 271 55");
	wait .5;
	self setClientDvar("m1_7_1", "^1Crossfire_1;set U vstr m1_7_6;set D vstr m1_7_2;set click vstr m1_7_1_click;set back vstr m1_7;set LTL vstr m1_7_1");
	self setClientDvar("m1_7_2", "^5Crossfire_2;set U vstr m1_7_1;set D vstr m1_7_3;set click vstr m1_7_2_click;set LTL vstr m1_7_2");
	self setClientDvar("m1_7_3", "^1Crossfire_3;set U vstr m1_7_2;set D vstr m1_7_4;set click vstr m1_7_3_click;set LTL vstr m1_7_3");
	self setClientDvar("m1_7_4", "^5Crossfire_4;set U vstr m1_7_3;set D vstr m1_7_5;set click vstr m1_7_4_click;set LTL vstr m1_7_4");
	self setClientDvar("m1_7_5", "^1Crossfire_5;set U vstr m1_7_4;set D vstr m1_7_6;set click vstr m1_7_5_click;set LTL vstr m1_7_5");
	self setClientDvar("m1_7_6", "^5Crossfire_6;set U vstr m1_7_5;set D vstr m1_7_1;set click vstr m1_7_6_click;set LTL vstr m1_7_6");
	self setClientDvar("m1_7_1_click", "vstr ACM;set aUP vstr m1_7_1_click;bind button_rstick setviewpos 5130 -989 620 267 66;bind dpad_down setviewpos 6423 -1992 705 89 56;bind dpad_up setviewpos 3003 -899 430 27 50;bind dpad_right setviewpos 4826 -1790 368 175 50;bind BUTTON_LTRIG setviewpos 5512 -1398 445 13 52");
	self setClientDvar("m1_7_2_click", "vstr ACM;set aUP vstr m1_7_2_click;bind button_rstick setviewpos 5714 -2355 520 46 61;bind dpad_down setviewpos 5868 -2166 576 57 65;bind dpad_up setviewpos 4740 -4646 155 339 50;bind dpad_right setviewpos 4737 -3709 545 117 47;bind BUTTON_LTRIG setviewpos 4709 -3797 689 112 55");
	self setClientDvar("m1_7_3_click", "vstr ACM;set aUP vstr m1_7_3_click;bind button_rstick setviewpos 4698 -3851 833 127 63;bind dpad_down setviewpos 4032 -2690 456 112 45;bind dpad_up setviewpos 3894 -2795 456 206 52;bind dpad_right setviewpos 3982 -2937 268 227 59;bind BUTTON_LTRIG setviewpos 4651 -4648 498 352 65");
	self setClientDvar("m1_7_4_click", "vstr ACM;set aUP vstr m1_7_4_click;bind button_rstick setviewpos 3364 -3312 400 59 47;bind dpad_down setviewpos 4087 -4483 576 231 65;bind dpad_up setviewpos 4097 -4427 296 102 74;bind dpad_right setviewpos 5863 -5152 449 228 50;bind BUTTON_LTRIG setviewpos 5132 -4709 506 344 66");
	self setClientDvar("m1_7_5_click", "vstr ACM;set aUP vstr m1_7_5_click;bind button_rstick setviewpos 5480 -4828 530 137 65;bind dpad_down setviewpos 6192 -3985 587 360 61;bind dpad_up setviewpos 5293 -3682 561 254 68;bind dpad_right setviewpos 4994 -4038 564 39 71;bind BUTTON_LTRIG setviewpos 6331 -5043 644 110 61");
	self setClientDvar("m1_7_6_click", "vstr ACM;set aUP vstr m1_7_6_click;bind button_rstick setviewpos 3175 -795 351 133 62;bind dpad_down setviewpos 3686 112 678 2 64;bind dpad_up setviewpos 6340 -1597 529 264 57;bind dpad_right setviewpos 4947 -4187 708 306 69;bind BUTTON_LTRIG setviewpos 4143 -2601 268 124 40");
	wait .5;
	self setClientDvar("m1_8_1", "^1District_1;set U vstr m1_8_4;set D vstr m1_8_2;set click vstr m1_8_1_click;set back vstr m1_8;set LTL vstr m1_8_1");
	self setClientDvar("m1_8_2", "^5District_2;set U vstr m1_8_1;set D vstr m1_8_3;set click vstr m1_8_2_click;set LTL vstr m1_8_2");
	self setClientDvar("m1_8_3", "^1District_3;set U vstr m1_8_2;set D vstr m1_8_4;set click vstr m1_8_3_click;set LTL vstr m1_8_3");
	self setClientDvar("m1_8_4", "^5District_4;set U vstr m1_8_3;set D vstr m1_8_1;set click vstr m1_8_4_click;set LTL vstr m1_8_4");
	self setClientDvar("m1_8_1_click", "vstr ACM;set aUP vstr m1_8_1_click;bind button_rstick setviewpos 2591 441 164 267 49;bind dpad_down setviewpos 3574 -571 228 218 54;bind dpad_up setviewpos 3079 -414 340 339 66;bind dpad_right setviewpos 4218 489 222 87 58;bind BUTTON_LTRIG setviewpos 3928 525 162 274 53");
	self setClientDvar("m1_8_2_click", "vstr ACM;set aUP vstr m1_8_2_click;bind button_rstick setviewpos 4333 356 304 285 57;bind dpad_down setviewpos 3658 -144 388 151 47;bind dpad_up setviewpos 2735 -666 500 261 66;bind dpad_right setviewpos 2733 -753 416 264 62;bind BUTTON_LTRIG setviewpos 2733 -753 280 271 58");
	self setClientDvar("m1_8_3_click", "vstr ACM;set aUP vstr m1_8_3_click;bind button_rstick setviewpos 3785 88 772 269 62;bind dpad_down setviewpos 3617 528 772 1 61;bind dpad_up setviewpos 3745 372 612 46 55;bind dpad_right setviewpos 3691 -71 612 305 59;bind BUTTON_LTRIG setviewpos 3326 220 612 150 57");
	self setClientDvar("m1_8_4_click", "vstr ACM;set aUP vstr m1_8_4_click;bind button_rstick setviewpos 5402 -441 260 149 50;bind dpad_down setviewpos 5655 304 332 174 65;bind dpad_up setviewpos 5550 304 196 188 64;bind dpad_right setviewpos 5360 -222 188 122 62;bind BUTTON_LTRIG setviewpos 4769 656 200 328 68");
	wait .5;
	self setClientDvar("m1_9_1", "^1Downpour_1;set U vstr m1_9_3;set D vstr m1_9_2;set click vstr m1_9_1_click;set back vstr m1_9;set LTL vstr m1_9_1");
	self setClientDvar("m1_9_2", "^5Downpour_2;set U vstr m1_9_1;set D vstr m1_9_3;set click vstr m1_9_2_click;set LTL vstr m1_9_2");
	self setClientDvar("m1_9_3", "^1Downpour_3;set U vstr m1_9_2;set D vstr m1_9_1;set click vstr m1_9_3_click;set LTL vstr m1_9_3");
	self setClientDvar("m1_9_1_click", "vstr ACM;set aUP vstr m1_9_1_click;bind button_rstick setviewpos 1825 3277 893 140 78;bind dpad_down setviewpos 374 2945 893 270 68;bind dpad_up setviewpos 695 2304 705 278 59;bind dpad_right setviewpos 366 2952 893 277 62;bind BUTTON_LTRIG setviewpos 654 1419 617 79 64");
	self setClientDvar("m1_9_2_click", "vstr ACM;set aUP vstr m1_9_2_click;bind button_rstick setviewpos -525 583 825 20 64;bind dpad_down setviewpos 1326 718 756 145 69;bind dpad_up setviewpos -261 -1521 580 104 65;bind dpad_right setviewpos -554 -896 484 325 45;bind BUTTON_LTRIG setviewpos -924 -2232 494 72 73");
	self setClientDvar("m1_9_3_click", "vstr ACM;set aUP vstr m1_9_3_click;bind button_rstick setviewpos -516 -2339 915 194 68;bind dpad_down setviewpos 1414 -806 588 181 65;bind dpad_up setviewpos 661 552 695 169 74;bind dpad_right setviewpos 2599 1319 897 91 71;bind BUTTON_LTRIG setviewpos 2325 1249 670 60 70");
	wait .5;
	self setClientDvar("m1_10_1", "^1Overgrown_1;set U vstr m1_10_3;set D vstr m1_10_2;set click vstr m1_10_1_click;set back vstr m1_10;set LTL vstr m1_10_1");
	self setClientDvar("m1_10_2", "^5Overgrown_2;set U vstr m1_10_1;set D vstr m1_10_3;set click vstr m1_10_2_click;set LTL vstr m1_10_2");
	self setClientDvar("m1_10_3", "^1Overgrown_3;set U vstr m1_10_2;set D vstr m1_10_1;set click vstr m1_10_3_click;set LTL vstr m1_10_3");
	self setClientDvar("m1_10_1_click", "vstr ACM;set aUP vstr m1_10_1_click;bind button_rstick setviewpos 492 -1741 117 250 45;bind dpad_down setviewpos 1541 -4298 184 127 57;bind dpad_up setviewpos 956 -2305 184 209 52;bind dpad_right setviewpos 1483 -1791 8 145 60;bind BUTTON_LTRIG setviewpos 806 -1460 -72 246 58");
	self setClientDvar("m1_10_2_click", "vstr ACM;set aUP vstr m1_10_2_click;bind button_rstick setviewpos 1661 -2469 264 150 69;bind dpad_down setviewpos 121 -3899 83 238 56;bind dpad_up setviewpos -1336 -2252 67 306 59;bind dpad_right setviewpos -1807 -3486 153 4 62;bind BUTTON_LTRIG setviewpos -1372 -1870 235 310 62");
	self setClientDvar("m1_10_3_click", "vstr ACM;set aUP vstr m1_10_3_click;bind button_rstick setviewpos -801 -1422 23 338 51;bind dpad_down setviewpos 1137 -2134 514 182 70;bind dpad_up setviewpos -620 -1796 92 18 56;bind dpad_right setviewpos 878 -3755 553 209 70;bind BUTTON_LTRIG setviewpos -480 -2803 291 215 48");
	wait .5;
	self setClientDvar("m1_11_1", "^1Pipeline_1;set U vstr m1_11_4;set D vstr m1_11_2;set click vstr m1_11_1_click;set back vstr m1_11;set LTL vstr m1_11_1");
	self setClientDvar("m1_11_2", "^5Pipeline_2;set U vstr m1_11_1;set D vstr m1_11_3;set click vstr m1_11_2_click;set LTL vstr m1_11_2");
	self setClientDvar("m1_11_3", "^1Pipeline_3;set U vstr m1_11_2;set D vstr m1_11_4;set click vstr m1_11_3_click;set LTL vstr m1_11_3");
	self setClientDvar("m1_11_4", "^5Pipeline_4;set U vstr m1_11_3;set D vstr m1_11_1;set click vstr m1_11_4_click;set LTL vstr m1_11_4");
	self setClientDvar("m1_11_1_click", "vstr ACM;set aUP vstr m1_11_1_click;bind button_rstick setviewpos 707 597 596 49 31;bind dpad_down setviewpos -935 -390 681 167 58;bind dpad_up setviewpos -209 63 469 326 65;bind dpad_right setviewpos 787 -641 555 24 61;bind BUTTON_LTRIG setviewpos -232 2047 644 127 49");
	self setClientDvar("m1_11_2_click", "vstr ACM;set aUP vstr m1_11_2_click;bind button_rstick setviewpos 759 3600 498 186 63;bind dpad_down setviewpos 310 3589 326 268 54;bind dpad_up setviewpos -39 2120 223 132 55;bind dpad_right setviewpos -280 1302 300 86 59;bind BUTTON_LTRIG setviewpos -811 2120 264 335 59");
	self setClientDvar("m1_11_3_click", "vstr ACM;set aUP vstr m1_11_3_click;bind button_rstick setviewpos -219 2628 216 290 70;bind dpad_down setviewpos 2014 1444 420 75 61;bind dpad_up setviewpos -629 2690 470 202 70;bind dpad_right setviewpos -212 1925 334 278 62;bind BUTTON_LTRIG setviewpos 1127 1821 345 151 64");
	self setClientDvar("m1_11_4_click", "vstr ACM;set aUP vstr m1_11_4_click;bind button_rstick setviewpos 270 2982 246 332 46;bind dpad_down setviewpos 2236 4606 652 286 64;bind dpad_up setviewpos 48 93 484 222 65;bind dpad_right setviewpos -1351 -41 490 337 53;bind BUTTON_LTRIG setviewpos 489 2037 470 64 64");
	wait .5;
	self setClientDvar("m1_12_1_click", "set LTL vstr m1_12;vstr ACM;set aUP vstr m1_12_1_click;bind button_rstick setviewpos 7703 594 413 47 55;bind dpad_down setviewpos -2916 1240 467 344 31;bind dpad_up setviewpos -792 37 803 39 52;bind dpad_right setviewpos 8280 -5232 252 253 70;bind BUTTON_LTRIG setviewpos -194 -147 467 184 40");
	wait .5;
	self setClientDvar("m1_13_1", "^1Showdown_1;set U vstr m1_13_4;set D vstr m1_13_2;set click vstr m1_13_1_click;set back vstr m1_13;set LTL vstr m1_13_1");
	self setClientDvar("m1_13_2", "^5Showdown_2;set U vstr m1_13_1;set D vstr m1_13_3;set click vstr m1_13_2_click;set LTL vstr m1_13_2");
	self setClientDvar("m1_13_3", "^1Showdown_3;set U vstr m1_13_2;set D vstr m1_13_4;set click vstr m1_13_3_click;set LTL vstr m1_13_3");
	self setClientDvar("m1_13_4", "^5Showdown_4;set U vstr m1_13_3;set D vstr m1_13_1;set click vstr m1_13_4_click;set LTL vstr m1_13_4");
	self setClientDvar("m1_13_1_click", "vstr ACM;set aUP vstr m1_13_1_click;bind button_rstick setviewpos -293 -1783 440 56 63;bind dpad_down setviewpos 351 -2102 443 202 58;bind dpad_up setviewpos 1345 -128 452 147 53;bind dpad_right setviewpos 560 748 362 212 46;bind BUTTON_LTRIG setviewpos 426 2144 442 169 47");
	self setClientDvar("m1_13_2_click", "vstr ACM;set aUP vstr m1_13_2_click;bind button_rstick setviewpos -478 1957 360 48 48;bind dpad_down setviewpos 490 1955 360 131 59;bind dpad_up setviewpos -1204 2351 356 334 51;bind dpad_right setviewpos -582 814 378 285 44;bind BUTTON_LTRIG setviewpos 1312 -630 584 102 58");
	self setClientDvar("m1_13_3_click", "vstr ACM;set aUP vstr m1_13_3_click;bind button_rstick setviewpos 605 -1559 892 229 48;bind dpad_down setviewpos 791 -59 628 263 68;bind dpad_up setviewpos 197 -520 628 179 69;bind dpad_right setviewpos 114 994 395 62 63;bind BUTTON_LTRIG setviewpos -126 2046 442 178 54");
	self setClientDvar("m1_13_4_click", "vstr ACM;set aUP vstr m1_13_4_click;bind button_rstick setviewpos -558 -1473 798 345 30;bind dpad_down setviewpos 382 2298 574 169 34;bind dpad_up setviewpos -1517 3107 686 297 55;bind dpad_right setviewpos -1146 959 596 354 42;bind BUTTON_LTRIG setviewpos 765 974 167 331 29");
	wait .5;
	self setClientDvar("m1_14_1", "^1Strike_1;set U vstr m1_14_6;set D vstr m1_14_2;set click vstr m1_14_1_click;set back vstr m1_14;set LTL vstr m1_14_1");
	self setClientDvar("m1_14_2", "^5Strike_2;set U vstr m1_14_1;set D vstr m1_14_3;set click vstr m1_14_2_click;set LTL vstr m1_14_2;set LTL vstr m1_14_2");
	self setClientDvar("m1_14_3", "^1Strike_3;set U vstr m1_14_2;set D vstr m1_14_4;set click vstr m1_14_3_click;set LTL vstr m1_14_3;set LTL vstr m1_14_3");
	self setClientDvar("m1_14_4", "^5Strike_4;set U vstr m1_14_3;set D vstr m1_14_5;set click vstr m1_14_4_click;set LTL vstr m1_14_4;set LTL vstr m1_14_4");
	self setClientDvar("m1_14_5", "^1Strike_5;set U vstr m1_14_4;set D vstr m1_14_6;set click vstr m1_14_5_click;set LTL vstr m1_14_5;set LTL vstr m1_14_5");
	self setClientDvar("m1_14_6", "^5Strike_6;set U vstr m1_14_5;set D vstr m1_14_1;set click vstr m1_14_6_click;set LTL vstr m1_14_6;set LTL vstr m1_14_6");
	self setClientDvar("m1_14_1_click", "vstr ACM;set aUP vstr m1_14_1_click;bind button_rstick setviewpos 1886 207 532 103 57;bind dpad_down setviewpos 1868 450 396 135 64;bind dpad_up setviewpos 1560 855 320 272 62;bind dpad_right setviewpos 1145 600 550 26 62;bind BUTTON_LTRIG setviewpos 1369 1460 636 23 52");
	self setClientDvar("m1_14_2_click", "vstr ACM;set aUP vstr m1_14_2_click;bind button_rstick setviewpos 1502 1057 354 350 56;bind dpad_down setviewpos 1833 207 396 110 55;bind dpad_up setviewpos 905 747 550 220 54;bind dpad_right setviewpos 696 735 346 323 64;bind BUTTON_LTRIG setviewpos 1513 1003 450 335 63");
	self setClientDvar("m1_14_3_click", "vstr ACM;set aUP vstr m1_14_3_click;bind button_rstick setviewpos 1247 -136 532 9 61;bind dpad_down setviewpos 1199 -593 676 330 56;bind dpad_up setviewpos 1633 -38 532 305 54;bind dpad_right setviewpos 721 -145 518 40 65;bind BUTTON_LTRIG setviewpos 43 804 464 38 49");
	self setClientDvar("m1_14_4_click", "vstr ACM;set aUP vstr m1_14_4_click;bind button_rstick setviewpos 1988 299 516 210 68;bind dpad_down setviewpos 1864 800 516 268 61;bind dpad_up setviewpos 1825 434 260 50 60;bind dpad_right setviewpos 1865 440 516 136 64;bind BUTTON_LTRIG setviewpos 1110 426 632 343 70");
	self setClientDvar("m1_14_5_click", "vstr ACM;set aUP vstr m1_14_5_click;bind button_rstick setviewpos -1191 -1452 920 196 61;bind dpad_down setviewpos -1279 -1217 633 186 69;bind dpad_up setviewpos -1237 -2545 828 354 63;bind dpad_right setviewpos -243 -1237 532 320 55;bind BUTTON_LTRIG setviewpos -669 -1619 543 235 74");
	self setClientDvar("m1_14_6_click", "vstr ACM;set aUP vstr m1_14_6_click;bind button_rstick setviewpos -242 -1377 533 317 66;bind dpad_down setviewpos -17 -1460 357 324 72;bind dpad_up setviewpos -1645 1089 444 142 62;bind dpad_right setviewpos -1550 463 607 216 58;bind BUTTON_LTRIG setviewpos -2308 467 496 111 54");
	wait .5;
	self setClientDvar("m1_15_1_click", "set LTL vstr m1_15;vstr ACM;set aUP vstr m1_15_1_click;bind button_rstick setviewpos -310 1194 68 92 53;bind dpad_down setviewpos 2445 -1833 363 58 70;bind dpad_up setviewpos -148 -1821 362 131 71;bind dpad_right setviewpos 2694 -1357 80 250 55;bind BUTTON_LTRIG setviewpos 1183 887 140 215 64");
	self setClientDvar("m1_16_1_click", "set LTL vstr m1_16;vstr ACM;set aUP vstr m1_16_1_click;bind button_rstick setviewpos -1572 29 289 253 42;bind dpad_down setviewpos -1169 -408 289 16 50;bind dpad_up setviewpos 933 405 272 217 54;bind dpad_right setviewpos -696 -120 272 121 54;bind BUTTON_LTRIG setviewpos -575 -78 1357 93 49");
	self setClientDvar("m1_17_1", "^1Broadcast_1;set U vstr m1_17_2;set D vstr m1_17_2;set click vstr m1_17_1_click;set back vstr m1_17;set LTL vstr m1_17_1");
	self setClientDvar("m1_17_2", "^5Broadcast_2;set U vstr m1_17_1;set D vstr m1_17_1;set click vstr m1_17_2_click;set LTL vstr m1_17_2");
	self setClientDvar("m1_17_1_click", "vstr ACM;set aUP vstr m1_17_1_click;bind button_rstick setviewpos -647 3148 110 187 54;bind dpad_down setviewpos -1038 2368 185 4 42;bind dpad_up setviewpos -942 1288 228 240 47;bind dpad_right setviewpos -175 1731 234 221 43;bind BUTTON_LTRIG setviewpos -410 -1033 308 90 37");
	self setClientDvar("m1_17_2_click", "vstr ACM;set aUP vstr m1_17_2_click;bind button_rstick setviewpos -2789 2403 268 163 54;bind dpad_down setviewpos -3215 2486 268 264 50;bind dpad_up setviewpos -3576 2093 412 336 46;bind dpad_right setviewpos -3358 1798 268 87 45;bind BUTTON_LTRIG setviewpos -2608 1223 300 130 32");
	wait .5;
	self setClientDvar("m1_18_1", "^1Chinatown_1;set U vstr m1_18_3;set D vstr m1_18_2;set click vstr m1_18_1_click;set back vstr m1_18;set LTL vstr m1_18_1");
	self setClientDvar("m1_18_2", "^5Chinatown_2;set U vstr m1_18_1;set D vstr m1_18_3;set click vstr m1_18_2_click;set LTL vstr m1_18_2");
	self setClientDvar("m1_18_3", "^1Chinatown_3;set U vstr m1_18_2;set D vstr m1_18_1;set click vstr m1_18_3_click;set LTL vstr m1_18_3");
	self setClientDvar("m1_18_1_click", "vstr ACM;set aUP vstr m1_18_1_click;bind button_rstick setviewpos 378 573 309 245 60;bind dpad_down setviewpos -154 828 309 325 53;bind dpad_up setviewpos 432 1037 409 6 59;bind dpad_right setviewpos 115 318 175 90 70;bind BUTTON_LTRIG setviewpos 585 -513 493 60 70");
	self setClientDvar("m1_18_2_click", "vstr ACM;set aUP vstr m1_18_2_click;bind button_rstick setviewpos 21 2830 503 308 63;bind dpad_down setviewpos 19 2829 401 319 67;bind dpad_up setviewpos -552 1198 427 237 66;bind dpad_right setviewpos 921 389 380 351 50;bind BUTTON_LTRIG setviewpos 2779 113 861 98 40");
	self setClientDvar("m1_18_3_click", "vstr ACM;set aUP vstr m1_18_3_click;bind button_rstick setviewpos 3606 1098 420 285 67;bind dpad_down setviewpos 2936 977 500 279 70;bind dpad_up setviewpos 2118 1067 596 270 57;bind dpad_right setviewpos 3162 738 670 333 70;bind BUTTON_LTRIG setviewpos -1696 2183 725 109 70");
	wait .5;
	self setClientDvar("m1_19_1", "^1Creek_1;set U vstr m1_19_4;set D vstr m1_19_2;set click vstr m1_19_1_click;set back vstr m1_19;set LTL vstr m1_19_1");
	self setClientDvar("m1_19_2", "^5Creek_2;set U vstr m1_19_1;set D vstr m1_19_3;set click vstr m1_19_2_click;set LTL vstr m1_19_2");
	self setClientDvar("m1_19_3", "^1Creek_3;set U vstr m1_19_2;set D vstr m1_19_4;set click vstr m1_19_3_click;set LTL vstr m1_19_3");
	self setClientDvar("m1_19_4", "^5Creek_4;set U vstr m1_19_3;set D vstr m1_19_1;set click vstr m1_19_4_click;set LTL vstr m1_19_4");
	self setClientDvar("m1_19_1_click", "vstr ACM;set aUP vstr m1_19_1_click;bind button_rstick setviewpos -3223 6751 498 272 48;bind dpad_down setviewpos -2521 5518 584 15 65;bind dpad_up setviewpos -625 7926 355 28 62;bind dpad_right setviewpos -315 7764 287 167 46;bind BUTTON_LTRIG setviewpos -526 7293 271 17 66");
	self setClientDvar("m1_19_2_click", "vstr ACM;set aUP vstr m1_19_2_click;bind button_rstick setviewpos -1110 6042 243 223 47;bind dpad_down setviewpos -1097 5785 392 345 32;bind dpad_up setviewpos -1245 7101 164 64 50;bind dpad_right setviewpos -696 7867 168 145 44;bind BUTTON_LTRIG setviewpos -598 6046 388 178 54");
	self setClientDvar("m1_19_3_click", "vstr ACM;set aUP vstr m1_19_3_click;bind button_rstick setviewpos -501 5289 366 148 44;bind dpad_down setviewpos -1158 6022 253 190 43;bind dpad_up setviewpos 451 4964 293 344 45;bind dpad_right setviewpos -1132 5775 397 140 43;bind BUTTON_LTRIG setviewpos -2856 6748 622 20 49");
	self setClientDvar("m1_19_4_click", "vstr ACM;set aUP vstr m1_19_4_click;bind button_rstick setviewpos -3543 4081 369 142 58;bind dpad_down setviewpos -3554 4552 349 40 43;bind dpad_up setviewpos -2575 5518 896 15 70;bind dpad_right setviewpos -2300 6159 966 241 70;bind BUTTON_LTRIG setviewpos 964 5595 533 75 70");
	wait .5;
	self setClientDvar("m1_20_1", "^1Killhouse_1;set U vstr m1_20_4;set D vstr m1_20_2;set click vstr m1_20_1_click;set back vstr m1_20;set LTL vstr m1_20_1");
	self setClientDvar("m1_20_2", "^5Killhouse_2;set U vstr m1_20_1;set D vstr m1_20_3;set click vstr m1_20_2_click;set LTL vstr m1_20_2");
	self setClientDvar("m1_20_3", "^1Killhouse_3;set U vstr m1_20_2;set D vstr m1_20_4;set click vstr m1_20_3_click;set LTL vstr m1_20_3");
	self setClientDvar("m1_20_4", "^5Killhouse_4;set U vstr m1_20_3;set D vstr m1_20_1;set click vstr m1_20_4_click;set LTL vstr m1_20_4");
	self setClientDvar("m1_20_1_click", "vstr ACM;set aUP vstr m1_20_1_click;bind button_rstick setviewpos 705 1417 428 239 62;bind dpad_down setviewpos 197 2650 407 305 60;bind dpad_up setviewpos 1001 450 305 175 68;bind dpad_right setviewpos 209 762 410 271 55;bind BUTTON_LTRIG setviewpos 719 2094 240 16 59");
	self setClientDvar("m1_20_2_click", "vstr ACM;set aUP vstr m1_20_2_click;bind button_rstick setviewpos 1178 2397 408 229 56;bind dpad_down setviewpos 2607 -1075 785 114 35;bind dpad_up setviewpos 694 722 276 221 66;bind dpad_right setviewpos 331 163 299 143 55;bind BUTTON_LTRIG setviewpos 301 487 200 182 48");
	self setClientDvar("m1_20_3_click", "vstr ACM;set aUP vstr m1_20_3_click;bind button_rstick setviewpos 2659 169 766 250 53;bind dpad_down setviewpos 942 113 640 205 49;bind dpad_up setviewpos 1347 585 541 214 49;bind dpad_right setviewpos 1718 123 524 208 52;bind BUTTON_LTRIG setviewpos 254 991 624 321 54");
	self setClientDvar("m1_20_4_click", "vstr ACM;set aUP vstr m1_20_4_click;bind button_rstick setviewpos 1123 2563 597 209 36;bind dpad_down setviewpos 287 2669 411 21 53;bind dpad_up setviewpos 1171 609 410 267 61;bind dpad_right setviewpos 1017 2669 411 163 53;bind BUTTON_LTRIG setviewpos 641 715 828 287 55");

	self setClientDvar("m2_1", "^6Freeze_Jump;set U vstr m2_10;set D vstr m2_2;set click vstr m2_1_click");
	self setClientDvar("m2_2", "^3Small_Movements;set U vstr m2_1;set D vstr m2_3;set click vstr m2_2_click");
	self setClientDvar("m2_3", "^6Promod_&_Lean;set U vstr m2_2;set D vstr m2_4;set click vstr m2_3_click");
	self setClientDvar("m2_4", "^3Graphics_Menu;set U vstr m2_3;set D vstr m2_5;set click vstr m2_4_1;set back vstr none");
	self setClientDvar("m2_5", "^6Spectator_Buttons;set U vstr m2_4;set D vstr m2_6;set click vstr spec");
	self setClientDvar("m2_6", "^3Remove_Teleports;set U vstr m2_5;set D vstr m2_7;set click vstr m2_6_click");
	self setClientDvar("m2_7", "^6Rpg_Smoke;set U vstr m2_6;set D vstr m2_8;set click vstr smoke");
	self setClientDvar("m2_8", "^3Third_Person;set U vstr m2_7;set D vstr m2_9;set click vstr third");
	self setClientDvar("m2_9", "^6Jump_Crouch;set U vstr m2_8;set D vstr m2_10;set click vstr jcMODE;set back vstr none");
	self setClientDvar("m2_10", "^3Disable_The_Mod_Menu;set U vstr m2_9;set D vstr m2_1;set click vstr unbindall;set back vstr none");
	wait .5;
	self setClientDvar("m2_1_click", "vstr CM;set con_gameMsgWindow0MsgTime 10;setfromdvar com_errorMessage frz;vstr CM;wait 150;^6Press__to_Freeze!;setfromdvar com_errorMessage frz;set con_gameMsgWindow0MsgTime 0");
	self setClientDvar("frz", "^6Your in the freeze Jump Now :)\n^2Press  to exit at any time :)\n\n\n\n\n\n\n\n\n\n");
	self setClientDvar("m2_2_click", "^6Use_[DPADS]_to_Move_&__For_Rockets;wait 200;set aUP vstr sm;vstr CM");
	self setClientDvar("m2_3_click", "^6[DPAD_DOWN]^1_for_FOV_^6[DPAD_LEFT&RIGHT]^1_for_Lean;wait 200;set aUP vstr pl;vstr CM");
	wait .5;
	self setClientDvar("m2_4_1", "^1Art_1;set U vstr m2_4_5;set D vstr m2_4_2;set click vstr art1;set back vstr m2_4");
	self setClientDvar("m2_4_2", "^5Art_2;set U vstr m2_4_1;set D vstr m2_4_3;set click vstr art2;set back vstr m2_4");
	self setClientDvar("m2_4_3", "^1Art_3;set U vstr m2_4_2;set D vstr m2_4_4;set click vstr art3;set back vstr m2_4");
	self setClientDvar("m2_4_4", "^5Art_4;set U vstr m2_4_3;set D vstr m2_4_5;set click vstr art4;set back vstr m2_4");
	self setClientDvar("m2_4_5", "^1Art_OFF;set U vstr m2_4_4;set D vstr m2_4_1;set click vstr artReset;set back vstr m2_4");
	wait .5;
	self setClientDvar("m2_6_click", "^8Teleports_^2Removed;set aUP vstr none;unbind apad_up;unbind apad_down;unbind apad_left;unbind apad_right;bind button_back togglescores;bind DPAD_UP +actionslot 1;bind DPAD_DOWN +actionslot 2;bind DPAD_LEFT +actionslot 3;bind DPAD_RIGHT +actionslot 4;vstr CM");
	wait .5;
	self setClientDvar("sm", "bind DPAD_LEFT +moveleft wait 0.1 -moveleft;bind DPAD_RIGHT +moveright wait 0.1 -moveright;bind dpad_up +forward wait 0.1 -forward;bind dpad_down +back wait 0.1 -back;bind button_lshldr +actionslot 3");
	self setClientDvar("pl", "bind DPAD_LEFT +leanleft;bind DPAD_RIGHT +leanright;bind dpad_down toggle cg_fovScale 1 1.2 1.3 1.5 1.64;bind dpad_up +actionslot 3");
	wait .5;
	self setClientDvar("artReset", "scr_art_tweak 0;r_glowUseTweaks 0;r_filmUseTweaks 0;reset r_filmusetweaks;reset r_filmtweakenable;reset r_filmtweakbrightness;reset r_filmtweakdesaturation;reset r_filmtweaklighttint;reset r_filmtweakdarktint;reset r_Filmtweakcontrast;reset r_lighttweaksuncolor;reset r_lighttweaksundirection;reset r_lighttweaksunlight;reset r_specularcolorscale;reset r_glow;reset r_desaturation;reset r_filmusetweaks;reset r_specularcolorscale;reset r_lighttweaksuncolor;reset r_lighttweaksundirection;reset r_lighttweaksunlight;reset r_filmtweakenable;reset r_filmtweakdarktint;reset r_filmtweaklighttint;reset r_filmtweakcontrast;reset sm_enable;reset r_normalmap;reset r_distortion;reset r_desaturation;reset r_blur;reset r_filmtweakdesaturation");
	self setClientDvar("art1", "vstr artReset;wait 10;set r_glowUseTweaks 1;set r_filmUseTweaks 1;^8Art1_^2Activated");
	self setClientDvar("art2", "vstr artReset;wait 10;r_filmusetweaks 1;r_filmtweakenable 1;r_filmtweakbrightness 0.07;r_filmtweakdesaturation 0.2;r_filmtweaklighttint 1.2 1.2 1;r_filmtweakdarktint 1.1 1.1 1.8;r_Filmtweakcontrast 1.6;r_lighttweaksuncolor 0.9 0.6 0.35 1;r_lighttweaksundirection -40 140 0;r_lighttweaksunlight 1.1;r_specularcolorscale 4;r_glow 0;r_desaturation 0;^8Art2_^2Activated");
	self setClientDvar("art3", "vstr artReset;wait 10;r_filmusetweaks 1;r_specularcolorscale 3;r_lighttweaksuncolor 1 0.6 0.25 0;r_lighttweaksundirection -30 -260 0;r_lighttweaksunlight 1.6;r_filmtweakenable 1;r_filmtweakdarktint 0.9 1 1.3;r_filmtweaklighttint 1.25 1.4 1.7;r_filmtweakcontrast 1.4;r_distortion 1;r_desaturation 0;r_blur 0.05;r_filmtweakdesaturation 0;^8Art3_^2Activated");
	self setClientDvar("art4", "vstr artReset;r_filmtweakenable 1;r_filmTweakBrightness 0.0;r_filmTweakContrast 1.2;r_filmTweakDesaturation 0.2;r_filmTweakInvert 0;r_filmTweakLightTint 1.6 1.6 1.6;r_filmUseTweaks 1;r_lighttweaksunlight 1.3;r_filmtweaklighttint 1.6 1.6 1.6;r_filmtweakdarktint 0.8 0.8 0.9;r_lighttweaksuncolor 1 0.9 0.6 1;r_lightTweakSunDirection -90 100 0;^8Art4_^1ON");
	wait .5;
	self setClientDvar("jcMODE", "vstr jcON");
	self setClientDvar("jcON", "set jcMODE vstr jcOFF;setfromdvar JUMP JC;^8JumpCrouch_^2ON");
	self setClientDvar("jcOFF", "set jcMODE vstr jcON;setfromdvar JUMP normJUMP;^8JumpCrouch_^1OFF;bind button_back togglescores");
	self setClientDvar("JC", "+gostand;-gostand;wait 4;togglecrouch");
	wait .5;
	self setClientDvar("spec", "^2Spec_Messages_TOGGLED;toggle cg_drawSpectatorMessages 0 1");
	wait .5;
	self setClientDvar("smoke", "^2RPG_Smoke_TOGGLED;toggle fx_enable 0 1");
	wait .5;
	self setClientDvar("third", "^2Thirdperson_TOGGLED;toggle cg_thirdperson 1 0");
	wait .5;

	self setClientDvar("m4_1", "^6Restart_Game;set U vstr m4_7;set D vstr m4_2;set click vstr FR;set back vstr none");
	self setClientDvar("m4_2", "^3Unlimited_Ammo;set U vstr m4_1;set D vstr m4_3;set click vstr ammo");
	self setClientDvar("m4_3", "^6Oldschool_Mode;set U vstr m4_2;set D vstr m4_5;set click vstr old");
	self setClientDvar("m4_5", "^3SuperJump;set U vstr m4_3;set D vstr m4_6;set click vstr m4_5_click;set back vstr none");
	self setClientDvar("m4_6", "^6Kick_Menu;set U vstr m4_5;set D vstr m4_7;set click vstr k1;set back vstr none");
	self setClientDvar("m4_7", "^3Joinable;set U vstr m4_6;set D vstr m4_1;set click vstr join;set back vstr none");
	
	wait .5;
	self setClientDvar("FR", "vstr CM;wait 20;fast_restart");
	self setClientDvar("resetdvars", "set LTL vstr m1_1;vstr artReset;reset player_view_pitch_up;reset player_view_pitch_down;reset con_minicon;reset bg_bobMax;reset jump_height;reset g_speed;reset g_password;reset g_knockback;reset player_sustainAmmo;reset g_gravity;reset phys_gravity;reset jump_slowdownenable;reset cg_thirdperson;reset cg_FOV;reset cg_FOVScale;reset friction;set old vstr oldON;set join vstr joinON;reset ragdoll_enable;vstr START;^2Dvars_Reset!;set m4_5_click vstr sjON");

	self setClientDvar("m4_5_click", "vstr sjON");
	self setClientDvar("sjON", "set m4_5_click vstr sjOFF;^8SuperJump_^2ON__To_Toggle!;vstr CM;wait 30;bind button_back toggle jump_height 999 39");
	self setClientDvar("sjOFF", "set m4_5_click vstr sjON;^8SuperJump_^1OFF;set jump_height 39;vstr CM;wait 30;bind button_back togglescores");
	wait .5;
	
	self setClientDvar("old", "vstr oldON");
	self setClientDvar("oldON", "^8Oldschool_^2ON;vstr CM;wait 30;set jump_height 64;set jump_slowdownenable 0;set old vstr oldOFF");
	self setClientDvar("oldOFF", "set jump_height 39;set jump_slowdownenable 1;^8Oldschool_^1OFF;set old vstr oldON");
	wait .5;
	self setClientDvar("ammo", "^2Unlimited_Ammo_TOGGLED;toggle player_sustainAmmo 1 0");
	wait .5;
	self setClientDvar("join", "vstr joinON");
	self setClientDvar("joinON", "set g_password somethingyouwillneverguess;^8Game_^1NOT-Joinable;set join vstr joinOFF");
	self setClientDvar("joinOFF", "reset g_password;^8Game_^2Joinable;set join vstr joinON");
	wait .5;
	self setClientDvar("k1", "^1Kick_Player_1;set U vstr k17;set D vstr k2;set click clientkick 1;set back vstr m4_6");
	self setClientDvar("k2", "^5Kick_Player_2;set U vstr k1;set D vstr k3;set click clientkick 2");
	self setClientDvar("k3", "^1Kick_Player_3;set U vstr k2;set D vstr k4;set click clientkick 3");
	self setClientDvar("k4", "^5Kick_Player_4;set U vstr k3;set D vstr k5;set click clientkick 4");
	self setClientDvar("k5", "^1Kick_Player_5;set U vstr k4;set D vstr k6;set click clientkick 5");
	self setClientDvar("k6", "^5Kick_Player_6;set U vstr k5;set D vstr k7;set click clientkick 6");
	self setClientDvar("k7", "^1Kick_Player_7;set U vstr k6;set D vstr k8;set click clientkick 7");
	self setClientDvar("k8", "^5Kick_Player_8;set U vstr k7;set D vstr k9;set click clientkick 8");
	self setClientDvar("k9", "^1Kick_Player_9;set U vstr k8;set D vstr k10;set click clientkick 9");
	self setClientDvar("k10", "^5Kick_Player_10;set U vstr k9;set D vstr k11;set click clientkick 10");
	self setClientDvar("k11", "^1Kick_Player_11;set U vstr k10;set D vstr k12;set click clientkick 11");
	self setClientDvar("k12", "^5Kick_Player_12;set U vstr k11;set D vstr k13;set click clientkick 12");
	self setClientDvar("k13", "^1Kick_Player_13;set U vstr k12;set D vstr k14;set click clientkick 13");
	self setClientDvar("k14", "^5Kick_Player_14;set U vstr k13;set D vstr k15;set click clientkick 14");
	self setClientDvar("k15", "^1Kick_Player_15;set U vstr k14;set D vstr k16;set click clientkick 15");
	self setClientDvar("k16", "^5Kick_Player_16;set U vstr k15;set D vstr k17;set click clientkick 16");
	self setClientDvar("k17", "^1Kick_Player_17;set U vstr k16;set D vstr k1;set click clientkick 17");
	wait .5;
}

Advanced_Noclip(mode)
{
	self endon("disconnect");
	self endon("unverifiedCJ");
	
	if(isDefined(mode) && mode == "DEL" || !isDefined(mode) && self.NoclipSpectator)
	{
		self.NoclipSpectator = false;
		self notify("stopNoclipSpectator");
		self iprintln("Noclip Spectator mode ^1disabled");
		return;
	}
	else if(self.NoclipSpectator) return;
	self endon("stopNoclipSpectator");
	self iprintln("Noclip Spectator mode ^2enabled");
	self.NoclipSpectator = true;
	
	if(self.Noclip) self thread Noclip("DEL");
	
	for(;;)
	{
		if(self SecondaryOffHandButtonPressed() && !self meleebuttonpressed())
		{
			if(self.InNoclipSpectator)
			{
				self.sessionstate = "playing";
				self allowSpectateTeam( "freelook", false );
				self.InNoclipSpectator = false;
			}
			else
			{
				self allowSpectateTeam( "freelook", true );
				self.sessionstate = "spectator";
				self.InNoclipSpectator = true;
			}
			wait .5;
		}
		wait .05;
	}
}

Change_team(equipe)
{
	player = level.players[self.PlayerNum];
	
	if(equipe == "regardemoi") player thread maps\mp\gametypes\_globallogic::menuSpectator();
	
	else if(self.team == "allies")
	{
		if(equipe == "pascopain") player thread maps\mp\gametypes\_globallogic::menuAxis();
		else if(equipe == "copain") player thread maps\mp\gametypes\_globallogic::menuAllies();	
	}
	else if(self.team == "axis")
	{
		if(equipe == "pascopain") player thread maps\mp\gametypes\_globallogic::menuAllies();	
		else if(equipe == "copain") player thread maps\mp\gametypes\_globallogic::menuAxis();
	}
	
}


Gameplay_effects(opt)
{
	if(opt == "jump")
	{
		if(!level.SuperJump)
		{
			level.SuperJump = true;
			self iPrintln("Super Jump [^2ON^7]");
			setDvar("jump_height","999");
			setDvar("bg_fallDamageMaxHeight","9999");
			setDvar("bg_fallDamageMinHeight","9998");
		}
		else
		{
			level.SuperJump = false;
			self iPrintln("Super Jump [^1OFF^7]");
			setDvar("jump_height","39");
		}
	}
	else if(opt == "speed")
	{
		if(!level.SuperSpeed)
		{
			level.SuperSpeed=true;
			setDvar("g_speed","600");
			self iPrintln("Super Speed [^2ON^7]");
		}
		else
		{
			level.SuperSpeed=false;
			setDvar("g_speed","190");
			self iPrintln("Super Speed [^1OFF^7]");
		}
	}
	else if(opt == "gravity")
	{
		if(!level.SuperGravity)
		{
			level.SuperGravity=true;
			setDvar("g_gravity","200");
			self iPrintln("Super Gravity [^2ON^7]");
		}
		else
		{
			level.SuperGravity=false;
			setDvar("g_gravity","800");
			self iPrintln("Super Gravity [^1OFF^7]");
		}
	}
	else if(opt == "timescale")
	{
		if(!level.SuperTime)
		{
			level.SuperTime=true;
			setDvar("timescale","0.5");
			self iPrintln("Slow Motion [^2ON^7]");
		}
		else
		{
			level.SuperTime=false;
			setDvar("timescale","1");
			self iPrintln("Slow Motion [^1OFF^7]");
		}
	}
	else
	{
		setdvar("jump_height",39);
		setdvar("g_speed",190);
		setdvar("g_gravity",800);
		setdvar("timescale",1);
		setdvar("player_sprintSpeedScale",1.5);
		iPrintln("Jump_height ^2reset ^7(39)\ng_speed ^2reset ^7(190)\ng_gravity ^2reset ^7(800)\ntimescale ^2reset ^7(1)");
	}
}



Adv_settings(opt)
{
	if(opt == "jump")	
	{
		if(!self.JumpSlowDown)
		{
			self setClientDvar("jump_slowdownEnable",1);
			self iPrintln("jump_slowdownEnable [^2DEFAULT^7]");
			self.JumpSlowDown = true;
		}
		else
		{
			self setClientDvar("jump_slowdownEnable",0);
			self iPrintln("jump_slowdownEnable [^1DISABLED^7]");
			self.JumpSlowDown = false;
		}
	}
	else if(opt == "sprint")
	{
		if(self.UnlimitedSprint)
		{
			self setClientDvar("player_sprintUnlimited",0);
			self iPrintln("Sprint Unlimited [^1DISABLED^7]");
			self.UnlimitedSprint = false;
		}
		else
		{
			self setClientDvar("player_sprintUnlimited",1);
			self iPrintln("Sprint Unlimited [^2ON^7]");
			self.UnlimitedSprint = true;
		}
	}
	
	
}
		
		
		
TurnOnShotGunMode()
{
	
	
}
JusquauBoutdeLaNuit()
{
	self iPrintln("Gametype ^2Unlimited ^7!");
	
	
	SetDvar("scr_dm_scorelimit",0);
	SetDvar("scr_dm_timelimit",0);
	
	SetDvar("scr_sab_scorelimit",0);
	SetDvar("scr_sab_timelimit",0);
	setDvar("scr_sab_numlives", 0);
	setDvar("scr_sab_roundswitch", 0);
	setDvar("scr_sab_playerrespawndelay", 0);
	setDvar("scr_sab_waverespawndelay", 0);	
	
	SetDvar("scr_sd_scorelimit",0);
	SetDvar("scr_sd_timelimit",0);
	SetDvar("scr_sd_numlives",0);
	
	SetDvar("scr_war_scorelimit",0);
	SetDvar("scr_war_timelimit",0);
	
}

Game_effect(mode)
{
	if(mode == "fast") map_restart(true);
	else if(mode == "normal") map_restart(false);
	else if(mode == "exit") exitLevel(false);
	else self thread maps\mp\gametypes\_globallogic::forceEnd();
}

AntiJoin(mode)
{
	if(mode == "LOCK")
	{
		self setClientDvar("g_password", "FP<3");
		self iPrintln("Anti-Join [^2ON^7]");
	}
	else
	{
		self setClientDvar("g_password", "");
		self iPrintln("Anti-Join [^1OFF^7]");
	}
}
CallOS(mode)
{
	if(mode == "OS")
	{
		if(getDvar("scr_oldschool")== "0")
		{
			setdvar("scr_oldschool","1");
			self iPrintln("Old School Mode [^2ON^7]");
			wait 1;
			map_restart(true);
		}
		else
		{
			setdvar("scr_oldschool","0");
			self iPrintln("Old School Mode [^1OFF^7]");
			wait 1;
			map_restart(true);
		}
	}
	else
	{
		if(!level.OldSchoolJump)
		{
			iPrintlnBold("Old School Jump [^2ON^7](^464^7)");
			self iPrintln("Old School Jump [^2ON^7](^464^7)");
			setdvar("jump_height",64);
			level.OldSchoolJump = true;
		}
		else
		{
			iPrintlnBold("Old School Jump [^1OFF^7](^439^7)");
			self iPrintln("Old School Jump [^1OFF^7](^439^7)");
			setdvar("jump_height",39);
			level.OldSchoolJump = false;
		}
	}
}

		









WhatIsPO()
{
	self setClientDvar("com_errorTitle","Profil parameters");
	self setClientDvar("com_errorMessage","Profil option is like the '^1START CODJUMPER^7' on my old menu\nBut now you can choose what you want launch !\nFor that go to ^5gameplay ^7or ^5graphic ^7params and select what func you want.\nYou can select the '^2autolaunch^7' when you spawn for the first spawn in a map your profil option will be ^2automaticaly ^7launched.\n^3Note: ^7Your params will be saved for ever! You can turn donw your PS3 etc..");
	wait .1;
	self openMenu(game["error_popmenu"]);
	
}


CloneMe()
{
	self ClonePlayer(9999);
	self iprintln("cloned");
}

KillMe()
{
	self suicide();
}
AmmoMon(mode)
{
	self endon("disconnect");
	
	if(isDefined(mode) && mode == "DEL")
	{
		self.UnlimitedAmmo = 0;
		self notify("Stop_Ammo");
		self iprintln("Unlimited ammo ^1disabled");
		return;
	}
	
	if(self.UnlimitedAmmo == 0)
	{
		self.UnlimitedAmmo = 1;
		self iprintln("Unlimited ammo [^2normal mode^7]");
		
		self notify("Stop_Ammo");
		self endon("Stop_Ammo");
		
		for(;;)
		{
			self giveMaxAmmo(self getCurrentWeapon());
			
			self waittill("weapon_fired");
			self waittill("reload");
			
			self giveMaxAmmo(self getCurrentWeapon());
		}
	}
	else if(self.UnlimitedAmmo == 1)
	{
		self.UnlimitedAmmo = 2;
		self iprintln("Unlimited ammo [^2cheater mode^7]");
		
		self notify("Stop_Ammo");
		self endon("Stop_Ammo");
		
		for(;;)
		{
			self setWeaponAmmoClip(self GetCurrentWeapon(),150);
			wait .05;
		}
	}
	else if(self.UnlimitedAmmo == 2)
	{
		self.UnlimitedAmmo = 0;
		
		self iprintln("Unlimited ammo ^1disabled");
		
		self notify("Stop_Ammo");
	}
}

FreezeJump()
{
	self setClientDvar("com_errorTitle","CODJUMPER V4");
	self setClientDvar("com_errorMessage","You are now ^2Frozen^7, press  to ^1quit");
	self iPrintln("Freeze Jump ^2Ready ^7!\nPress [{togglescores}] to Freeze !");
}



ThirdP()
{
	if(!self.ThirdP)
	{
		self setClientDvars("cg_thirdPerson","1","cg_fov","115","cg_thirdPersonAngle","354");
		self.ThirdP = true;
		self iPrintln("3rd Person ^2enabled");
	}
	else
	{
		self setClientDvars("cg_thirdPerson","0","cg_fov","65","cg_thirdPersonAngle","0");
		self.ThirdP = false;
		self iPrintln("3rd Person ^1disabled");
	}
}





Color_correction(CC)
{
	self ResetProperly();
	
	switch (CC)
	{
		case "CC1": self setClientDvar("r_glowUseTweaks","1","r_filmUseTweaks","1");
		self iPrintln("Color Correction 1 ^2Set");
		break;
		case "CC2": self setClientDvars("r_filmusetweaks","1","r_filmtweakenable","1","r_filmtweakbrightness","0.07","r_filmtweakdesaturation","0.2","r_filmtweaklighttint","1.2 1.2 1","r_filmtweakdarktint","1.1 1.1 1.8","r_filmtweakcontrast","1.6","r_lighttweaksuncolor","0.9 0.6 0.35 1","r_lighttweaksundirection","-40 140 0","r_lighttweaksunlight","1.1","r_specularcolorscale","4","r_glow","0","r_desaturation","0");
		self iPrintln("Color Correction 2 ^2Set");
		break;
		case "CC3": self setClientDvars("r_filmusetweaks","1","r_specularcolorscale","3","r_lighttweaksuncolor","1 0.6 0.25 0","r_lighttweaksundirection","-30 -260 0","r_lighttweaksunlight","1.6","r_filmtweakenable","1","r_filmtweakdarktint","0.9 1 1.3","r_filmtweaklighttint","1.25 1.4 1.7","r_filmtweakcontrast","1.4","r_distortion","1","r_desaturation","0","r_blur","0.05","r_filmtweakdesaturation","0");
		self iPrintln("Color Correction 3 ^2Set");
		break;
		case "CC4": self setClientDvars("r_filmtweakenable","1","r_filmTweakBrightness","0.0","r_filmTweakContrast","1.2","r_filmTweakDesaturation","0.2","r_filmTweakInvert","0","r_filmTweakLightTint","1.6 1.6 1.6","r_filmUseTweaks","1","r_lighttweaksunlight","1.3","r_filmtweaklighttint","1.6 1.6 1.6","r_filmtweakdarktint","0.8 0.8 0.9","r_lighttweaksuncolor","1 0.9 0.6 1","r_lightTweakSunDirection","-90 100 0");
		self iPrintln("Color Correction 4 ^2Set");
		break;
		case "CC5": self setClientDvars("r_filmUseTweaks","1" ,"r_filmTweakEnable","1" ,"r_filmTweakBrightness","0.03" ,"r_filmTweakContrast","1.3" ,"r_filmtweakdarktint","0.5 0.65 1.25" ,"r_filmTweakDesaturation","0.25" ,"r_filmTweakInvert","0" ,"r_filmTweakLightTint","1.1 1.4 1.45" ,"r_specular","1" ,"r_blur","0" ,"r_fog","0" ,"r_desaturation","0" ,"r_contrast","0.9" ,"r_specularcolorscale","5" ,"r_gamma","0.9" ,"r_glowTweakEnable","0" ,"r_glowTweakBloomCutoff","0.9" ,"r_glowtweakbloomintensity0","1" ,"r_glowTweakradius0","32" ,"r_glow_allowed","0" ,"r_glow_enable","0" ,"r_lighttweaksunlight","1.7" ,"r_lightTweakSunColor"," 0.8 0.56 0.4 1" ,"r_lighttweaksundirection","-120 -120" ,"r_detail","0" ,"sm_enable","1" ,"r_drawdecals","1");
		self iPrintln("Color Correction 5 ^2Set");
		break;
		case "CC6": self setClientDvars( "r_filmTweakBrightness","0.025" ,"r_filmTweakContrast","1" ,"r_filmTweakDarktint","0.7 0.85 1.1" ,"r_filmTweakDesaturation","0.01" ,"r_filmTweakEnable","1" ,"r_filmTweakLighttint","1.7 1.6 1.8" ,"r_filmTweakInvert","0" ,"r_filmUseTweaks","1" ,"r_glowUseTweaks","1" ,"r_glowTweakEnable","1" ,"r_glowTweakBloomCutoff","0.65" ,"r_glowtweakbloomintensity0","1" ,"r_glowTweakradius0","32" ,"r_glow_allowed","1" ,"r_glow_enable","1" ,"r_lightTweakSuncolor","1 0.85 0.61 1" ,"r_lightTweakSundirection","-30 -130 0" ,"r_lightTweakSunlight","1.3" ,"r_lodBiasRigid","-1000" ,"r_lodBiasSkinned","-1000" ,"r_lodScaleRigid","1" ,"r_lodScaleSkinned","1" ,"r_drawDecals","0" ,"r_drawSun","1" ,"r_drawWater","1" ,"r_specular","1" ,"r_distortion","1" ,"r_zfeather","1" ,"r_fog","1" ,"r_detail","0" ,"r_clear","4" ,"r_dlightLimit","4" ,"r_contrast","1.1" ,"r_specularcolorscale","6.5" ,"r_gamma","1" ,"r_blur","0" ,"r_desaturation","0" ,"sm_enable","1" ,"sm_polygonoffsetscale","2" ,"sm_polygonoffsetbias","0" ,"sm_sunshadowscale","1" ,"sm_polygonoffsetbias","0.5" ,"sm_maxLights","4" ,"sm_sunsamplesizenear","1" ,"r_sunblind_fadein","0" ,"r_sunblind_fadeout","0" ,"r_sunblind_max_angle","90" ,"r_sunflare_max_size","10000" ,"r_sunflare_min_size","10000" ,"r_sunsprite_size","1000" ,"r_sun_from_dvars","0");
		self iPrintln("Color Correction 6 ^2Set");
		break;
		case "CC7": self setClientDvars( "r_filmTweakBrightness","0.15" ,"r_filmTweakContrast","1.15" ,"r_filmTweakDarktint","0.4 0.42 0.7" ,"r_filmTweakDesaturation","0.2" ,"r_filmTweakEnable","1" ,"r_filmTweakLighttint","1.2 1.1 1" ,"r_filmTweakInvert","0" ,"r_filmUseTweaks","1" ,"r_glowUseTweaks","0" ,"r_glowTweakEnable","0" ,"r_glowTweakBloomCutoff","0.9" ,"r_glowtweakbloomintensity0",".8" ,"r_glowTweakradius0","5" ,"r_glow_allowed","1" ,"r_glow_enable","0" ,"r_glow","0" ,"r_lightTweakSunDirection","-29 240 0" ,"r_lightTweakSunColor","1 0.8 0.5 1" ,"r_lighttweaksunlight","1.5" ,"r_lodBiasRigid","-1000" ,"r_lodBiasSkinned","-1000" ,"r_lodScaleRigid","1" ,"r_lodScaleSkinned","1" ,"r_drawDecals","1" ,"r_drawSun","0" ,"r_drawWater","1" ,"r_specular","1" ,"r_distortion","1" ,"r_zfeather","1" ,"r_fog","1" ,"r_detail","0" ,"r_brightness","0.025" ,"r_clear","4","r_dlightLimit","4" ,"r_contrast","1.1" ,"r_specularcolorscale","8" ,"r_gamma","1" ,"r_blur","0.3" ,"r_desaturation","0" ,"r_smc_enable","1" ,"sm_enable","1" ,"sm_polygonoffsetscale","2" ,"sm_polygonoffsetbias","0" ,"sm_sunshadowscale","1" ,"sm_polygonoffsetbias","0.5" ,"sm_maxLights","4" ,"sm_sunsamplesizenear","1" ,"r_sunblind_fadein","0" ,"r_sunblind_fadeout","0" ,"r_sunblind_max_angle","90" ,"r_sunflare_max_size","10000" ,"r_sunflare_min_size","10000" ,"r_sunsprite_size","1000" ,"r_sun_from_dvars","0" ,"r_smc_enable","1" ,"sm_enable","1");
		self iPrintln("Color Correction 7 ^2Set");
		break;
		case "CC8": self setClientDvars( "r_lighttweaksunlight","1.45" ,"r_fog","0" ,"ragdoll_enable","0" ,"r_desaturation","0" ,"r_glowUseTweaks","1" ,"r_glowTweakEnable","1" ,"r_glowTweakBloomCutoff","0.7" ,"r_glowtweakbloomintensity0","0.9" ,"r_glowTweakradius0","32" ,"r_glow_allowed","0" ,"r_glow_enable","0" ,"sm_enable","1" ,"r_smc_enable","1" ,"r_normalmap","1" ,"r_distortion","1" ,"r_blur","0" ,"r_lodbiasrigid","-1000" ,"r_lodbiasskinned","-1000" ,"r_forcelod","0" ,"r_filmtweakcontrast","1.2" ,"r_filmtweaks","1" ,"r_filmtweakenable","1" ,"r_filmTweakBrightness","0.15" ,"r_filmTweakContrast","1.8" ,"r_filmTweakDesaturation","0.2" ,"r_filmTweakEnable","1" ,"r_filmTweakInvert","0" ,"r_filmTweakLightTint","2 2 2" ,"r_filmTweakdarkTint","1.2 1.2 1.5" ,"r_filmUseTweaks","1" ,"r_lodScaleRigid","1" ,"r_lodScaleSkinned","1" ,"r_lighttweakSunColor","1 1 1" ,"r_lighttweakSunLight","1" ,"r_filmtweakcontrast","1.4" ,"r_filmtweakbrightness","0.25" ,"r_filmtweakdarktint","0.4 0.55 0.7" ,"r_filmtweaklighttint","1.4 1.4 1.4" ,"r_sunblind_fadein","0" ,"r_sunblind_fadeout","0" ,"r_sunblind_max_angle","90" ,"r_sunflare_max_size","10000" ,"r_sunflare_min_size","10000" ,"r_sunsprite_size","1000" ,"r_sun_from_dvars","0" ,"sm_polygonoffsetscale","2" ,"sm_polygonoffsetbias","0" ,"sm_sunshadowscale","1" ,"sm_polygonoffsetbias",".5" ,"sm_maxLights","4" ,"r_drawDecals","1" ,"r_drawSun","0" ,"r_drawWater","1" ,"r_specular","1" ,"r_specularcolorscale","3" ,"r_distortion","1" ,"r_zfeather","1" ,"dynent_active","1" ,"r_fog","0" ,"r_detail","0" ,"r_clear","4" ,"r_dlightLimit","4" ,"r_gamma","0.8" ,"r_filmtweakdesaturation","0" ,"r_filmtweakdesaturation","0.25");
		self iPrintln("Color Correction 8 ^2Set");
		break;
		case "CC9": self setClientDvars( "r_filmtweaks","1" ,"r_filmtweakenable","1" ,"r_filmTweakBrightness","0" ,"r_filmTweakContrast","1.1" ,"r_filmTweakDesaturation","0" ,"r_filmTweakEnable","1" ,"r_filmTweakInvert","0" ,"r_filmUseTweaks","1" ,"r_lighttweaksunlight","1.4" ,"r_filmTweakLightTint","1.03 1. 1.053" ,"r_filmTweakdarkTint","1.01 1.1 1.23" ,"r_lightTweakSunColor","1 1 1 1" ,"r_distortion","1" ,"r_fog","0" ,"r_smc_enable","1" ,"sm_enable","1" ,"r_clear","3" ,"r_colorMap","1" ,"r_detail","0" ,"r_dlightLimit","4" ,"r_drawDecals","1" ,"r_drawSun","0" ,"r_drawWater","1" ,"r_forceLod","0" ,"r_lodBiasRigid","-1000" ,"r_lodBiasSkinned","-1000" ,"r_lodScaleRigid","1" ,"r_lodScaleSkinned","1" ,"r_normalMap","1" ,"r_polygonOffsetBias","-1" ,"r_polygonOffsetScale","-1" ,"r_specular","1" ,"r_specularMap","1" ,"r_zFeather","1" ,"sm_polygonOffsetScale","2" ,"sm_polygonOffsetBias","0.5");
		self iPrintln("Color Correction 9 ^2Set");
		break;
		case "CC10": self setClientDvars( "r_Distortion","1","r_DrawDecals", "0","r_DrawSun", "1","r_DrawWater", "1","r_Desaturation", "0","sm_sunsamplesizenear","1","r_filmTweakBrightness", "0.0595238","r_filmTweakContrast", "1.42857","r_filmTweakDarkTint", "1.55952 1.41667 1.5119","r_filmTweakDesaturation", "0","r_filmTweakEnable", "1","r_filmTweakInvert", "0","r_filmTweakLightTint", "1.83333 1.69048 1.54762","r_filmtweaks", "1","r_filmUseTweaks", "1","r_lightTweakSunColor", "0.87451 0.819608 0.713726 1","r_lightTweakSunDirection", "-43.5 25.11 1","r_lightTweakSunLight", "0.78","r_Specular", "1","r_SpecularColorScale", "2.97619","r_glow", "0","r_glow_allowed", "0","r_glow_enable", "1","r_glowTweakBloomCutoff", "0.5","r_glowTweakBloomIntensity0", "1","r_glowTweakEnable", "1","r_glowTweakRadius0", "5","r_glowUseTweaks", "0","r_sunblind_fadein", "60","r_sunblind_fadeout", "0","r_sunblind_max_angle", "90","r_sunflare_max_size", "1","r_sunflare_min_size", "0","r_sunglare_fadein", "0.4","r_sunglare_fadeout", "0.4","r_sunglare_max_angle", "25","r_sunglare_min_angle", "25","r_sunsprite_size", "1","sm_enable", "1","sm_polygonoffsetscale", "2","sm_polygonoffsetbias", "0","sm_sunshadowscale", "1","sm_polygonoffsetbias", ".5","sm_maxLights", "4");
		self iPrintln("Color Correction 10 ^2Set");
		break;
		case "CC11": self setClientDvars("r_lightTweakSunColor","1 1 1 1","r_lightTweakSunDiffuseColor","1 1 1 1","r_lightTweakSunLight","1.26","r_lightTweakSunDirection","-80 180 0","r_filmtweakenable","1","r_filmUseTweaks","1","r_filmTweakBrightness","-0.00","r_filmTweakContrast","1.15","r_filmTweakDesaturation","0.00","r_filmTweakLightTint","1.3 1.3 1.2","r_filmTweakdarkTint","1.1 1.3 1.5","r_detail","0","sm_enable","1","r_drawdecals","0","r_blur","0.10","r_specular","1","r_specularcolorscale","4","r_fog","0");
		self iPrintln("Color Correction 11 ^2Set");
		break;

		
		
		case "CC12": self setClientDvars("r_sun_from_dvars","0","r_sunsprite_size","1000","r_sunflare_min_size","10000","r_sunflare_max_size","10000","r_sunblind_max_angle","90","r_sunblind_fadeout","0","r_sunblind_fadein","0","sm_sunsamplesizenear","1","sm_maxLights","4","sm_polygonoffsetbias","0.5","sm_sunshadowscale","1","sm_polygonoffsetscale","2","sm_enable","1","r_smc_enable","1","r_desaturation","0","r_blur","0.15","r_gamma","1","r_specularcolorscale","3","r_contrast","1","r_dlightLimit","4","r_clear","4","r_normalmap","1","r_brightness","0.025","r_detail","0","r_fog","1","r_zfeather","1","r_distortion","1","r_specular","1","r_drawSun","0","r_drawDecals","1","r_lighttweaksunlight","2.0","r_lightTweakSunColor","1 0.95 0.65 1","r_lightTweakSunDirection","-35 300 0","r_glow","0","r_glow_enable","0","r_glow_allowed","1","r_glowTweakradius0","5","r_glowtweakbloomintensity0",".8","r_glowTweakBloomCutoff","0.9","r_glowTweakEnable","1","r_glowUseTweaks","1","r_filmUseTweaks","1","r_filmTweakInvert","0","r_filmTweakLighttint","1.1 1 .9","r_filmTweakEnable","1","r_filmTweakDesaturation","0","r_filmTweakDarktint","0.7 0.9 1.45","r_filmTweakContrast","0.94","r_filmTweakBrightness","0");
		self iPrintln("Color Correction 12 ^2Set");
		break;

		case "CC13": self setClientDvars("sm_polygonOffsetScale","2","sm_polygonOffsetBias","0.5","sm_polygonoddsetbias","32","sm_maxLights","4","sm_polygonoffsetbias",".5","sm_sunshadowscale","1","sm_polygonoffsetbias","0","sm_polygonoffsetscale","2","sm_enable","1","sm_sunsamplesizenear","1","r_polygonOffsetScale","-1","r_polygonOffsetBias","-1","r_lodScaleSkinned","1","r_lodScaleRigid","1","r_lodBiasSkinned","-1000","r_lodBiasRigid","-1000","r_highLodDist","-1","r_forceLod","0","r_drawWater","1","r_clear","4","r_smc_enable","1","r_drawSun","1","r_fog","0","r_sunsprite_size","1","r_sunglare_min_angle","25","r_sunglare_max_angle","25","r_sunglare_fadeout","0.4","r_sunglare_fadein","0.4","r_sunflare_min_size","0","r_sunflare_max_size","1","r_sunblind_max_angle","90","r_sunblind_fadeout","0","r_sunblind_fadein","60","r_drawDecals","1","r_specularMap","1","r_normalMap","1","r_normal","1","r_dlightLimit","4","r_detail","","r_colorMap","1","r_clear","3","r_SpecularColorScale","5","r_Specular","1","r_Desaturation","0","r_Distortion","1","r_glowUseTweaks","0","r_glowTweakRadius0","5","r_glowTweakEnable","1","r_glowTweakBloomIntensity0","1","r_glowTweakBloomCutoff","0.5","r_glow_enable","1","r_glow_allowed","0","r_glow","0","r_lightTweakSunLight","1.5","r_lightTweakSunDirection","-45 137 0","r_lightTweakSunColor","0.85098 0.45098 0.2 0","r_filmUseTweaks","1","r_filmtweaks","1","r_filmTweakLightTint","1 1.02 1.2","r_filmTweakInvert","0","r_filmTweakEnable","1","r_filmTweakDesaturation","0","r_filmTweakDarkTint","0.7 0.72 0.95","r_filmTweakContrast","1.4","r_filmTweakBrightness","0.1");
		self iPrintln("Color Correction 13 ^2Set");
		break;
		
 		case "CC14": self setClientDvars("r_blur","0.0","r_detail","1","r_forcelod","0","r_smc_enable","1","r_drawdecals","1","r_dlightlimit","4","r_detail","0","r_normalMap","1","r_drawsun","0","r_fog","0","cg_brass","1","sm_sunsamplesizenear","1","sm_enable","1","r_clear","4","r_zfeather","1","r_specularcolorscale","3","r_specularmap","3","r_gamma","1","r_specular","1","r_distortion","1","r_lodBiasRigid","-1000","r_lodscaleskinned","1","r_lodscalerigid","1","r_lodBiasSkinned","-1000","r_glowUseTweaks","1","r_glowTweakRadius0","10.0952","r_glowTweakEnable","1","r_glowTweakBloomIntensity0","0.595238","r_glowTweakBloomCutoff","0.434524","r_glow_enable","1","r_glow_allowed","1","r_glow","1","r_lightTweakSunLight","2.0","r_lightTweakSunColor","1 0.430 0.101","r_lightTweakSunDirection","-30.4286 -140.857 1","r_lightTweakSunDiffuseColor","0.74902 0.839216 1 1","r_filmTweakLightTint",".9 .9 1 1","r_filmTweakdarkTint",".9 .9 1 1","r_filmtweakbrightness","0","r_filmtweakcontrast","1.1","r_filmtweakdesaturation","0.25","r_filmusetweaks","1","r_filmTweakInvert","0","r_filmtweakenable","1");
		self iPrintln("Color Correction 14 ^2Set");
		break;

		//R3 CC
 		case "CC15": self setClientDvars("r_forcelod", "0","r_smc_enable", "1","r_filmtweakdesaturation", "0","r_filmtweaklighttint", "1.3 1.4 1.5","r_filmtweakdarktint", "1.3 1.3 1.7","r_filmtweakcontrast", "1.1","r_fog", "0","r_glow", "0","r_filmtweakenable", "1","r_lighttweaksunlight", "1.3","r_desaturation", "0","r_lodbiasskinned", "-1000","r_lodbiasrigid", "-1000","r_distortion", "1","r_normalmap", "1","sm_enable", "1","r_lighttweaksuncolor", "1 0.9 0.6 1","r_specularcolorscale", "6","r_filmusetweaks", "1");
		self iPrintln("Color Correction 15 ^2Set");
		break;

		
 		case "CC16": self setClientDvars("r_colorMap","1","r_lightMap","1","r_blur","0.50","r_blur","0.50","r_drawdecals","0","sm_enable","0","r_detail","0","r_filmTweakdarkTint","0.922 0.938 1 1","r_filmTweakLightTint","1 1 1 1","r_filmTweakDesaturation","0.10","r_filmTweakContrast","1.00","r_filmTweakBrightness","-0.00","r_filmUseTweaks","1","r_filmTweakEnable","1","r_lightTweakSunDirection","239 105","r_lightTweakSunLight","1.90","r_lightTweakSunDiffuseColor","0.344 0.344 0.344 1","r_lightTweakSunColor","1 0.898 0.492 1");
		self iPrintln("Color Correction 16 ^2Set");
		break;

	    case "CC17": self setClientDvars("r_drawdecals","1","r_detail","0","r_specularcolorscale","10","sm_enable","1","r_lighttweaksunlight","1.4","r_lighttweaksuncolor","1 0.9 0.7","r_filmusetweaks","1","r_filmtweaklighttint","1.5 1.1 1.1","r_filmtweakinvert","0","r_filmtweakenable","1","r_filmtweakdesaturation","0","r_filmtweakdarktint","1.1 1.2 1.4","r_filmtweakcontrast","1.4","r_filmtweakbrightness","0","r_filmtweak","1");
		self iPrintln("Color Correction 17 ^2Set");
		break;

		
	}
}














ShowPositionOnMap()
{
	if(self.ShowingPosition)
	{
		self iprintln("^1Already showing position !");
		return;
	}
	self.ShowingPosition = true;
	if(isDefined(self.CJ["A"]["save"]["origin"]))
	{
		self.PositionMark["A"] = SpawnFx(level.PositionMarkage, self.CJ["A"]["save"]["origin"]);
		TriggerFX(self.PositionMark["A"]);
		for(i=0;i<level.players.size;i++) level.players[i] thread TriggerPosition(self.CJ["A"]["save"]["origin"],self.CJ["A"]["save"]["angles"],self);
	}
	if(isDefined(self.CJ["B"]["save"]["origin"]))
	{
		self.PositionMark["B"] = SpawnFx(level.PositionMarkage, self.CJ["B"]["save"]["origin"]);
		TriggerFX(self.PositionMark["B"]);
		for(i=0;i<level.players.size;i++) level.players[i] thread TriggerPosition(self.CJ["B"]["save"]["origin"],self.CJ["B"]["save"]["angles"],self);
	}
	if(isDefined(self.CJ["C"]["save"]["origin"]))
	{
		self.PositionMark["C"] = SpawnFx(level.PositionMarkage, self.CJ["C"]["save"]["origin"]);
		TriggerFX(self.PositionMark["C"]);
		for(i=0;i<level.players.size;i++) level.players[i] thread TriggerPosition(self.CJ["C"]["save"]["origin"],self.CJ["C"]["save"]["angles"],self);
	}
	if(isDefined(self.CJ["D"]["save"]["origin"]))
	{
		self.PositionMark["D"] = SpawnFx(level.PositionMarkage, self.CJ["D"]["save"]["origin"]);
		TriggerFX(self.PositionMark["D"]);
		for(i=0;i<level.players.size;i++) level.players[i] thread TriggerPosition(self.CJ["D"]["save"]["origin"],self.CJ["D"]["save"]["angles"],self);
	}
	if(isDefined(self.CJ["E"]["save"]["origin"]))
	{
		self.PositionMark["E"] = SpawnFx(level.PositionMarkage, self.CJ["E"]["save"]["origin"]);
		TriggerFX(self.PositionMark["E"]);
		for(i=0;i<level.players.size;i++) level.players[i] thread TriggerPosition(self.CJ["E"]["save"]["origin"],self.CJ["E"]["save"]["angles"],self);
	}
	if(!isDefined(self.PositionMark["A"]) && !isDefined(self.PositionMark["B"]) && !isDefined(self.PositionMark["C"]) && !isDefined(self.PositionMark["D"]) && !isDefined(self.PositionMark["E"])) self iprintlnbold("No position saved");
	else
	{
		self iprintlnbold("Sharing positions for 20 seconds");
		wait 20;
	}
	self.ShowingPosition = false;
	if(isDefined(self.PositionMark["A"])) self.PositionMark["A"] delete();
	if(isDefined(self.PositionMark["B"])) self.PositionMark["B"] delete();
	if(isDefined(self.PositionMark["C"])) self.PositionMark["C"] delete();
	if(isDefined(self.PositionMark["D"])) self.PositionMark["D"] delete();
	if(isDefined(self.PositionMark["E"])) self.PositionMark["E"] delete();
}
TriggerPosition(POS,ANGLES,P)
{
	while(isDefined(P.ShowingPosition))
	{
		Position = distance(POS, self.origin);
		if(Position < 50)
		{
			self setLowerMessage("Press [{+usereload}] to take the position");
			if(self UseButtonPressed())
			{
				wait .1;
				if(self UseButtonPressed())
				{
					self clearLowerMessage(1);
					self.CJ[self.PositionNumber]["save"]["origin"] = POS;
					self.CJ[self.PositionNumber]["save"]["angles"] = ANGLES;
					self iprintln("^3The new position has been saved");
					self clearLowerMessage(1);
					break;
				}
			}
		}
		else self clearLowerMessage(1);
		wait .01;
	}
}
GraphicPreset()
{
	if(!self.graphicPreset)
	{
		if(self.ShowSLText) self thread GraphicFuncs("0");
		if(!self.fx_marks) self thread GraphicFuncs("2");
		if(!self.ShowIcons) self thread GraphicFuncs("4");
		if(!self.ShowRankIcons) self thread GraphicFuncs("10");
		self.graphicPreset = true;
		self thread CallLowerText("\n\n\n\nGraphic Preset [^2ON^7]",2);
	}
	else
	{
		if(!self.ShowSLText) self thread GraphicFuncs("0");
		if(self.fx_marks) self thread GraphicFuncs("2");
		if(self.ShowIcons) self thread GraphicFuncs("4");
		if(self.ShowRankIcons) self thread GraphicFuncs("10");
		self.graphicPreset = false;
		self thread CallLowerText("\n\n\n\nGraphic Preset [^1OFF^7]",2);
	}
}
SkinMonitor(team,mode)
{
	self detachAll();
	[[game[team+"_model"][mode]]]();
}
DeleteAllBody()
{
	origin = self.origin;
	self setOrigin(level.mapCenter + (0,0,-1000) );
	for(i=0;i<20;i++) self ClonePlayer(9999);
	self setOrigin(origin);
	self iPrintln("Clone and body ^2deleted");
}
Smoke_trail()
{
	self endon("disconnect");
	self endon("stop_trail");
	if(self.SmokeTrail)
	{
		self.SmokeTrail = false;
		self iprintln("Smoke trail ^1disabled");
	}
	else
	{
		self.SmokeTrail = true;
		self iprintln("Smoke trail ^2enabled");
		while(self.SmokeTrail)
		{
			playfx(level._effect["lantern_light"],self.origin);
			wait .05;
		}
	}
}
GraphicFuncs(G)
{
	switch(G)
	{
		case "-1": 
		
		self iprintlnbold("Total number of saved position: "+self.SavedPosition);
		wait 1;
		self iprintlnbold("Total number of loaded position: "+self.LoadedPosition);
		break;
		
		case "0":
		
		if(!self.ShowSLText)
		{
			self.ShowSLText = true;
			self iPrintln("Save and load TEXTS [^2ON^7]");
		}
		else
		{
			self.ShowSLText = false;
			self iPrintln("Save and load TEXTS [^1OFF^7]");
		}
		break;
		
		case "1":
		
		if(!self.fx_enable)
		{
			self setClientDvar("fx_enable",0);
			self iPrintln("fx_enable [^1DISABLED^7]");
			self.fx_enable = true;
		}
		else
		{
			self setClientDvar("fx_enable",1);
			self iPrintln("fx_enable [^2DEFAULT^7]");
			self.fx_enable = false;
		}
		break;
		
		case "2":
		
		if(!self.fx_marks)
		{
			self setClientDvar("fx_marks",0);
			self iPrintln("fx_marks [^1DISABLED^7]");
			self.fx_marks = true;
		}
		else
		{
			self setClientDvar("fx_marks",1);
			self iPrintln("fx_marks [^2DEFAULT^7]");
			self.fx_marks = false;
		}
		break;
		
		case "3":
		
		if(!self.fx_draw)
		{
			self setClientDvar("fx_draw",0);
			self iPrintln("fx_draw [^1DISABLED^7]");
			self.fx_draw = true;
		}
		else
		{
			self setClientDvar("fx_draw",1);
			self iPrintln("fx_draw [^2DEFAULT^7]");
			self.fx_draw = false;
		}
		break;
		
		case "4":
		
		if(!self.ShowIcons)
		{
			self setClientDvar("waypointIconWidth", 0.1);
			self setClientDvar("waypointIconHeight", 0.1);
			self setClientDvar("waypointOffscreenPointerWidth", 0.1);
			self setClientDvar("waypointOffscreenPointerHeight", 0.1);
			self iPrintln("Icons [^1DISABLED^7]");
			self.ShowIcons = true;
		}
		else
		{
			self setClientDvar("waypointIconWidth", 36);
			self setClientDvar("waypointIconHeight", 36);
			self setClientDvar("waypointOffscreenPointerWidth", 25);
			self setClientDvar("waypointOffscreenPointerHeight", 12);
			self iPrintln("Icons [^2DEFAULT^7]");
			self.ShowIcons = false;
		}
		break;
		
		case "5": 
		
		if(!self.ShowGun)
		{
			self setClientDvar("cg_drawgun", 0);
			self iPrintln("cg_drawgun [^1DISABLED^7]");
			self.ShowGun = true;
		}
		else
		{
			self setClientDvar("cg_drawgun", 1);
			self iPrintln("cg_drawgun [^2DEFAULT^7]");
			self.ShowGun = false;
		}
		break;
		
		case "6":
		if(!self.ShowCrossHair)
		{
			self setClientDvar("cg_drawcrosshair", 0);
			self iPrintln("Cross hair [^1DISABLED^7]");
			self.ShowCrossHair = true;
		}
		else
		{
			self setClientDvar("cg_drawcrosshair", 1);
			self iPrintln("Cross hair [^2DEFAULT^7]");
			self.ShowCrossHair = false;
		}
		break;
		
		case "7":
		if(!self.Fov85)
		{
			self.Fov85 = true;
			self setClientDvar("cg_fov","85");
			self iPrintln("Fov 85 [^2DEFAULT^7]");
		}
		else
		{
			self.Fov85 = false;
			self setClientDvar("cg_fov","65");
			self iPrintln("Fov 85 [^1DISABLED^7]");
		}
		break;
		
		case "8":
		if(!self.ShowKillfeed)
		{
			self iPrintln("Killfeed [^1DISABLED^7]");
			self setClientDvar("ui_hud_obituaries", 0);
			
			
			self.ShowKillfeed = true;
		}
		else
		{
			self setClientDvar("ui_hud_obituaries", 1);
			self iPrintln("Killfeed [^2DEFAULT^7]");
			self.ShowKillfeed = false;
		}
		break;
		
		case "9": 
		
		if(!self.ShowFPS)
		{
			self setClientDvar("cg_drawFPS",1);
			self iPrintln("drawFPS [^2ON^7]");
			self.ShowFPS = true;
		}
		else
		{
			self setClientDvar("cg_drawFPS",0);
			self iPrintln("drawFPS [^1OFF^7]");
			self.ShowFPS = false;
		}
		break;
		
		case "10":
		
		if(!self.ShowRankIcons)
		{
			self setClientDvar("cg_overheadRankSize", 0);
			self setClientDvar("cg_overheadIconSize", 0);
			self iPrintln("Ranks and Icons [^1DISABLED^7]");
			self.ShowRankIcons = true;
		}
		else
		{
			self setClientDvar("cg_overheadRankSize", "0.5");
			self setClientDvar("cg_overheadIconSize", "0.7");
			self iPrintln("Ranks and Icons [^2DEFAULT^7]");
			self.ShowRankIcons = false;
		}
		break;
		
		case "11":
		
		if(!self.ShowNames)
		{
			self setClientDvar("cg_overheadNamesSize", 0);
			self iPrintln("Name [^1DISABLED^7]");
			self.ShowNames = true;
		}
		else
		{
			self setClientDvar("cg_overheadNamesSize", "1");
			self iPrintln("Name [^2DEFAULT^7]");
			self.ShowNames = false;
		}
		break;
		
		case "12": 
		
		if(!self.ShowSpecButs)
		{
			self setClientDvar("cg_drawSpectatorMessages",0);
			self iPrintln("Spectator Buttons [^1OFF^7]");
			self.ShowSpecButs = true;
		}
		else
		{
			self setClientDvar("cg_drawSpectatorMessages",1);
			self iPrintln("Spectator Buttons [^2DEFAULT^7]");
			self.ShowSpecButs = false;
		}
		break;
		
		case "-10": 
		
		if(!self.ShowHardcore)
		{
			self setClientDvar("ui_hud_hardcore", 1);
			self iPrintln("Hardcore [^2ON^7]");
			self.ShowHardcore = true;
		}
		else
		{
			self setClientDvar("ui_hud_hardcore", 0);
			self iPrintln("Hardcore [^1DISABLED^7]");
			self.ShowHardcore = false;
		}
		break;
	}
}
DP_CJ_class()
{
	self iprintln("DizePara's CJ Class ^2set");
	self setClientDvars("customclass1","^1SMG RPG+JUGG","customclass2","^5Sniper RPG","customclass3","^2LMG RPG","customclass4","^3Shotgun RPG","customclass5","^6SMG RPG" );
	self setStat(201,10);
	self setStat(202,0);
	self setStat(203,3);
	self setStat(204,0);
	self setStat(205,186);
	self setStat(206,167);
	self setStat(207,154);
	self setStat(208,102);
	self setStat(209,4);
	self setStat(211,61);
	self setStat(212,0);
	self setStat(213,4);
	self setStat(214,0);
	self setStat(215,186);
	self setStat(216,164);
	self setStat(217,154);
	self setStat(218,102);
	self setStat(219,3);
	self setStat(221,80);
	self setStat(222,0);
	self setStat(223,3);
	self setStat(224,0);
	self setStat(225,186);
	self setStat(226,164);
	self setStat(227,154);
	self setStat(228,102);
	self setStat(229,4);
	self setStat(231,70);
	self setStat(232,0);
	self setStat(233,4);
	self setStat(234,0);
	self setStat(235,186);
	self setStat(236,164);
	self setStat(237,154);
	self setStat(238,102);
	self setStat(239,6);
	self setStat(241,12);
	self setStat(242,0);
	self setStat(243,3);
	self setStat(244,0);
	self setStat(245,186);
	self setStat(246,164);
	self setStat(247,154);
	self setStat(248,102);
	self setStat(249,3);
}
LoadBounce()
{
	if(self.LoadBounce)
	{
		self.LoadBounce = false;
		self iprintln("Load Bounce Mod ^1disabled");
	}
	else
	{
		self.LoadBounce = true;
		self iprintln("Load Bounce Mod ^2enabled");
	}
}
floor_pos(pos)
{
	return ((floor(pos[0]), floor(pos[1]), floor(pos[2])));
}
ceil_pos(pos)
{
	return ((ceil(pos[0]), ceil(pos[1]), ceil(pos[2])));
}
EleBot(mode)
{
	self endon("disconnect");
	self endon("unverifiedCJ");
	
	if(isDefined(mode) && mode == "DEL" || !isDefined(mode) && self.Elebot)
	{
		self.Elebot = false;
		self notify("stopElebot");
		self iprintln("Elebot binds ^1disabled");
		return;
	}
	else if(self.Elebot) return;
	self endon("stopElebot");
	self iprintln("Elebot binds ^2enabled");
	self iprintlnBold(" +  to use Elebot!");
	self.Elebot = true;
	
	for(;;)
	{
		if(self adsbuttonpressed() && self usebuttonpressed() && isalive(self) && !self.IN_MENU["CJ"])
		{
			origin = self.origin;
			fpos = floor_pos(origin);
			cpos = ceil_pos(origin);
			self setOrigin(fpos);
			wait(0.10);
			
			if (int(self.origin[2] - fpos[2]) > 10)
			{}
			else self setOrigin(cpos);
			wait 1;
		}
		wait .5;
	}
}
ChangeCamo(camo)
{
	weapon = self GetCurrentWeapon();
	self TakeWeapon(weapon);
	self GiveWeapon(weapon, camo);
	self SwitchToWeapon(weapon);
}
Allweap(w)
{
	if(getDvar("scr_oldschool") == "0")
	{
		if(w == "ak47" || w == "g36c" || w == "g3" || w == "m14" || w == "m16_" || w == "m4" || w == "mp44" || w == "m40a3" || w == "dragunov" || w == "barrett" || w == "m21" || w == "remington700" || w == "ak74u")
		{
			self setMoveSpeedScale( 0.95 );
			self iprintln("MoveSpeedScale modified ! ^3Your weight is now a Sniper class");
		}
		else if(w == "mp5" || w == "uzi" || w == "p90" || w == "skorpion" || w == "winchester1200" || w == "m1014")
		{
			self setMoveSpeedScale( 1.0 );
			self iprintln("MoveSpeedScale modified ! ^3Your weight is now a SMG class");
		}
		else if(w == "rpd" || w == "saw" || w == "m60e4")
		{
			self setMoveSpeedScale( 0.875 );
			self iprintln("MoveSpeedScale modified ! ^3Your weight is now a LMG class");
		}
	}
	else self setMoveSpeedScale( 1.0 );
	
	
	if(w == "usp" || w == "beretta" || w == "colt45" || w == "deserteagle" || w == "deserteaglegold") 
	{
		self TakeWeapon(self.WEAPON_PISTOL);
		 
		self.WEAPON_PISTOL = w + "_mp";
	}
	else
		self TakeWeapon(self GetCurrentWeapon());
	
	
	self giveWeapon(w+ "_mp");
	self SwitchToWeapon(w+"_mp");
	
	
	
}
CodJumperMod()
{
	if(!self.snl)
	{
		self CallSV("x2x2");
		self thread GodMode(1);
		self thread RPG_DPAD(1);
		self thread Noclip(1);
		self thread Call_third(1);
		self thread Call_teleport(1);
		self.snl = true;
		self thread CallLowerText("\n\n\n\nCodJumper Preset [^2ON^7]",2);
	}
	else
	{
		self CallSV("DEL");
		self thread GodMode("DEL");
		self thread RPG_DPAD("DEL");
		self thread Noclip("DEL");
		self thread Call_third("DEL");
		self thread Call_teleport("DEL");
		self.snl = false;
		self thread CallLowerText("\n\n\n\nCodJumper Preset [^1OFF^7]",2);
	}
}
Call_third(mode)
{
	self endon("disconnect");
	self endon("unverifiedCJ");
	
	if(isDefined(mode) && mode == "DEL" || !isDefined(mode) && self.Call_third)
	{
		self.Call_third = false;
		self notify("EndThird");
		self iprintln("Third person binds ^1disabled");
		return;
	}
	else if(self.Call_third) return;
	
	self endon("EndThird");
	self iprintln("Third person binds ^2enabled");
	self iprintln("In prone switch your weapon to change person view");
	self.Call_third = true;
	
	for(;;)
	{
		self waittill("weapon_change");
		
		if(self GetStance() == "prone") 
		{
			if(!self.ThirdP)
			{
				self setClientDvar( "cg_thirdperson", "1" );
				self.ThirdP = true;
			}
			else
			{
				self setClientDvar( "cg_thirdperson", "0" );
				self.ThirdP = false;
			}
		}
	}
}


Call_teleport(mode)
{
	self endon("disconnect");
	self endon("unverifiedCJ");
	
	if(isDefined(mode) && mode == "DEL" || !isDefined(mode) && self.Call_teleport)
	{
		self.Call_teleport = false;
		self notify("EndTele");
		self iprintln("Teleport binds ^1disabled");
		return;
	}
	else if(self.Call_teleport) return;
	self endon("EndTele");
	self iprintln("Teleport binds ^2enabled");
	self iprintln("Press [{+melee}] 5 seconds to use teleport");
	self.Call_teleport = true;
	for(;;)
	{
		i = 0;
		while(self meleeButtonPressed() && i < 2 && !self.IN_MENU["CJ"])
		{
			wait .02;
			i+=.09;
		}
		if(i > 1) self thread Teleport();
		wait .1;
	}
}
Teleport()
{
	self endon("disconnect");
	self endon("death");
	self endon("unverifiedCJ");
	
	for(;;)
	{
		self beginLocationselection( "map_artillery_selector", level.artilleryDangerMaxRadius * 1.2 );
		self.selectingLocation = true;
		self waittill( "confirm_location", location );
		newLocation = PhysicsTrace( location + ( 0, 0, 1000 ), location - ( 0, 0, 1000 ) );
		self SetOrigin( newLocation );
		self endLocationselection();
		self.selectingLocation = undefined;
		self waittill( "actionslot 2" );
		self endLocationselection();
	}
}
Noclip(mode)
{
	self endon("disconnect");
	self endon("unverifiedCJ");
	
	if(isDefined(mode) && mode == "DEL" || !isDefined(mode) && self.Noclip)
	{
		self.Noclip = false;
		self notify("stop_ufo");
		self iprintln("Noclip ^1disabled");
		return;
	}
	else if(self.Noclip) return;
	
	self endon("stop_ufo");
	if(isdefined(self.N)) self.N delete();
	self.N = spawn("script_origin", self.origin);
	self.On = 0;
	self iprintln("Noclip ^2enabled");
	self.Noclip = true;
	
	
	
	if(self.NoclipSpectator) self thread Advanced_Noclip("DEL");
	
	for(;;)
	{
		if(self SecondaryOffHandButtonPressed() && !self MeleeButtonPressed() && !self.IN_MENU["CJ"])
		{
			if(self.On != 1)
				wait .1;
			
			if(!self.IN_MENU["CJ"])
			{
				self.On = 1;
				self.N.origin = self.origin;
				self linkto(self.N);
			}
		}
		else
		{
			self.On = 0;
			self unlink();
		}
		
		if(self.On == 1)
		{
			if(self adsbuttonpressed())
				valuue = 60;
			else
				valuue = 20;
			
			vec = anglestoforward(self getPlayerAngles());
			end = (vec[0] * valuue, vec[1] * valuue, vec[2] * valuue);
			
			
			self.N.origin = self.N.origin+end;
		}
		wait .05;
	}
}
RPG_DPAD(mode)
{
	self endon("disconnect");
	self endon("unverifiedCJ");
	
	if(isDefined(mode) && mode == "DEL" || !isDefined(mode) && self.RPG_DPAD)
	{
		self.RPG_DPAD = false;
		self notify("EndRpg");
		self SetActionSlot( 4, "" );
		self iprintln("RPG DPAD ^1disabled");
		return;
	}
	else if(self.RPG_DPAD) return;
	
	self endon("EndRpg");
	self giveWeapon("rpg_mp");
	self SetActionSlot(4, "weapon", "rpg_mp" );
	self iprintln("RPG DPAD ^2enabled");
	self.RPG_DPAD = true;

	for(;;)
	{
		self waittill("weapon_fired");
		self waittill("reload");
		if(self getCurrentWeapon() == "rpg_mp")
		{
			self giveMaxAmmo("rpg_mp");
			if(self getWeaponAmmoClip("rpg_mp") < 1) self SetWeaponAmmoClip("rpg_mp", 1);
		}
	}
}
GodMode(mode)
{
	self endon("disconnect");
	self endon("unverifiedCJ");
	
	if(isDefined(mode) && mode == "DEL" || !isDefined(mode) && self.GodMode)
	{
		self.HASGODMODE = false;
		self.GodMode = false;
		self notify("EndGodMode");
		self iprintln("God mode ^1disabled");
		self.maxhealth = 100;
		self.health = self.maxhealth;
		self notify("end_healthregen");
		return;
	}
	
	else if(self.GodMode) return;
	
	self endon("EndGodMode");
	self.maxhealth = 90000;
	self.health = self.maxhealth;
	self iprintln("God mode ^2enabled");
	self.GodMode = true;
	self.HASGODMODE = true;
	
	for(;;)
	{
		while(self.health < self.maxhealth)
		{
			self.maxhealth = 90000;
			self.health = self.maxhealth;
			wait .1;
		}
		wait .1;
	}
}
Multi_Positions()
{
	self endon("New_SL_rules");
	self endon("disconnect");
	self endon("unverifiedCJ");
	
	while(1)
	{
		if(self fragbuttonpressed())
		{
			if(self.PositionNumber == "A")
			{
				self.PositionNumber = "B";
				self iprintln("List ^3B ^7enabled");
			}
			else if(self.PositionNumber == "B")
			{
				self.PositionNumber = "C";
				self iprintln("List ^3C ^7enabled");
			}
			else if(self.PositionNumber == "C")
			{
				self.PositionNumber = "D";
				self iprintln("List ^3D ^7enabled");
			}
			else if(self.PositionNumber == "D")
			{
				self.PositionNumber = "E";
				self iprintln("List ^3E ^7enabled");
			}
			else if(self.PositionNumber == "E")
			{
				self.PositionNumber = "A";
				self iprintln("List ^3A ^7enabled");
			}
			wait .2;
		}
		wait .05;
	}
}
CallSV(N)
{
	self notify("New_SL_rules");
	self thread Multi_Positions();
	
	switch(N)
	{
		case "x1x1": self iPrintln("SAVE x1 LOAD x1 ^2enabled");
		self thread Savex1();
		self thread Loadx1();
		break;
		case "x2x1": self iPrintln("SAVE x2 LOAD x1 ^2enabled");
		self thread Savex2();
		self thread Loadx1();
		break;
		case "x1x2": self iPrintln("SAVE x1 LOAD x2 ^2enabled");
		self thread Savex1();
		self thread Loadx2();
		break;
		case "x2x2": self iPrintln("SAVE x2 LOAD x2 ^2enabled");
		self thread Savex2();
		self thread Loadx2();
		break;
		case "DEL": self notify("New_SL_rules");
		self iPrintln("SAVE and LOAD ^1disabled");
		break;
	}
}
Savex1()
{
	self endon("disconnect");
	self endon("New_SL_rules");
	self endon("unverifiedCJ");
	
	for(;;)
	{
		if(self meleebuttonpressed() && self isOnground() && !self.IN_MENU["CJ"] && !self.IN_MENU["REPLAY"])
		{
			wait .07;
			
			if(!self.IN_MENU["CJ"])
			{
				self.CJ[self.PositionNumber]["save"]["origin"] = self.origin;
				self.CJ[self.PositionNumber]["save"]["angles"] = self getplayerangles();
				self.SavedPosition++;
				
				if(self.ShowSLText)
				{
					self iprintln("Position ^3"+self.PositionNumber+" ^5S^7aved");
				}
				wait .1;
			}
		}
		wait .05;
	}
}
Loadx1()
{
	self endon("disconnect");
	self endon("New_SL_rules");
	self endon("unverifiedCJ");
	
	for(;;)
	{
		if(self useButtonPressed() && !self.IN_MENU["CJ"] && !self AdsButtonPressed() && !self.IN_MENU["REPLAY"])
		{
			if(self AdsButtonPressed() && self.Elebot)
			{
			}
			else if(!isDefined(self.CJ[self.PositionNumber]["save"]["origin"]))
			{
				self iPrintln("^1Save Position ^3" + self.PositionNumber+"^1 First !");
				wait .5;
			}
			else
			{
				if(self.GunBounceChanger)
				{
					self spawn( self.CJ[self.PositionNumber]["save"]["origin"], self.CJ[self.PositionNumber]["save"]["angles"] );
					self maps\mp\gametypes\_class::giveLoadout( self.team, self.class );
					self giveweapon("rpg_mp");
					self setspawnweapon("rpg_mp");
				}
				else
				{
					self setPlayerAngles(self.CJ[self.PositionNumber]["save"]["angles"]);
					self setOrigin(self.CJ[self.PositionNumber]["save"]["origin"]);
				}
				
				self.LoadedPosition++;
				if(self.ShowSLText)
				{
					self iprintln("Position ^3"+self.PositionNumber+" ^5L^7oaded");
				}
				if(!self.LoadBounce)
				{
					self freezecontrols(true);
					wait .1;
					self freezecontrols(false);
					wait .1;
				}
				wait .1;
			}
		}
		wait .05;
	}
}
Savex2()
{
	self endon("disconnect");
	self endon("New_SL_rules");
	self endon("unverifiedCJ");
	
	for(;;)
	{
		if(self meleeButtonPressed())
		{
			catch_next = false;
			for(i=0;i<0.5;i+=0.05)
			{
				if(catch_next && self meleeButtonPressed() && self isOnground() && !self.IN_MENU["CJ"] && !self.IN_MENU["REPLAY"])
				{
					self.CJ[self.PositionNumber]["save"]["origin"] = self.origin;
					self.CJ[self.PositionNumber]["save"]["angles"] = self getplayerangles();
					self.SavedPosition++;
					if(self.ShowSLText)
					{
						self iprintln("Position ^3"+self.PositionNumber+" ^5S^7aved");
					}
					wait .5;
					break;
				}
				else if(!(self meleeButtonPressed()) && !(self attackButtonPressed())) catch_next = true;
				wait .05;
			}
		}
		wait .05;
	}
}
Loadx2()
{
	self endon("disconnect");
	self endon("New_SL_rules");
	self endon("unverifiedCJ");
	
	for(;;)
	{
		if(self useButtonPressed()  && !self AdsButtonPressed())
		{
			catch_next = false;
			
			for(i=0;i<=0.5;i+=0.05)
			{
				if(catch_next && self useButtonPressed() && !(self isMantling()) && !self.IN_MENU["CJ"] && !self.IN_MENU["REPLAY"])
				{
					if(!isDefined(self.CJ[self.PositionNumber]["save"]["origin"]))
					{
						self iPrintln("^1Save Position ^3" + self.PositionNumber+"^1 First !");
						wait .5;
					}
					else
					{
						if(self.GunBounceChanger)
						{
							self spawn( self.CJ[self.PositionNumber]["save"]["origin"], self.CJ[self.PositionNumber]["save"]["angles"] );
							self maps\mp\gametypes\_class::giveLoadout( self.team, self.class );
							self giveweapon("rpg_mp");
							self setspawnweapon("rpg_mp");
						}
						else
						{
							self setPlayerAngles(self.CJ[self.PositionNumber]["save"]["angles"]);
							self setOrigin(self.CJ[self.PositionNumber]["save"]["origin"]);
						}
						
						self.LoadedPosition++;
						
						if(self.ShowSLText)
						{
							self iprintln("Position ^3"+self.PositionNumber+" ^5L^7oaded");
						}
						if(!self.LoadBounce)
						{
							self freezecontrols(true);
							wait .1;
							self freezecontrols(false);
							wait .1;
						}
						break;
					}
				}
				else if(!(self useButtonPressed())) catch_next = true;
				wait .05;
			}
		}
		wait .05;
	}
}
