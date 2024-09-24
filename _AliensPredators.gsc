#include common_scripts\utility;
#include maps\mp\gametypes\_hud_util;
#include maps\mp\_utility;
#include maps\mp\gametypes\_general_funcs;

init()
{
	level thread onPlayerConnect();
	level.hardcoreMode = true;
	 
	level.gameModeDevName = "AVP";
	level.current_game_mode = "Aliens VS Predators";
	level.sensorLimit = 500;
	
	precacheModel("weapon_parabolic_knife");
	precacheShader("killiconmelee");
	precacheShader("weapon_g36c");
	precacheShader("nightvision_overlay_goggles");
	
	
	precacheModel("vehicle_cobra_helicopter_d_piece02");
	
	
	level deletePlacedEntity("misc_turret");
	
	setDvar("scr_game_hardpoints", "0");
	setdvar( "scr_showperksonspawn", "0" );
	setdvar("jump_height",70);

	while(!isDefined(level.inPrematchPeriod)) wait .05;

	game["strings"]["change_class"] = "";
	game["strings"]["axis_name"] = "";
	game["strings"]["allies_name"] = "";
	game["dialog"]["gametype"] = undefined;
	game["music"]["spawn_axis"] = undefined;
	game["music"]["spawn_allies"] = undefined;
	
	if(game["attackers"] == "allies")
	{
		game["icons"]["axis"] = "killiconmelee";
		game["icons"]["allies"] = "weapon_g36c";
		game["strings"]["axis_eliminated"] = "Predators eliminated !";
		game["strings"]["allies_eliminated"] = "Aliens eliminated !";
	}
	else if(game["attackers"] == "axis")
	{
		game["icons"]["axis"] = "weapon_g36c";
		game["icons"]["allies"] = "killiconmelee";
		game["strings"]["axis_eliminated"] = "Aliens eliminated !";
		game["strings"]["allies_eliminated"] = "Predators eliminated !";
	}
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
	
	self setClientDvar("g_ScoresColor_Axis","0 0 0 0");
	self setClientDvar("g_ScoresColor_Allies","0 0 0 0");
			
	self.isAlien = false;
	self.isPredator = false;
	
	
	if(level.rankedMatch)
	{
		self.AVP_predators_killed = self getstat(3435); //Preds
		self.AVP_aliens_killed = self getstat(3436); //Aliens
		
		if(self.AVP_predators_killed < 0)
			self setstat(3435,0);
			
		if(self.AVP_aliens_killed < 0)
			self setstat(3436,0);
			
		self thread AVP_stats();
	}
	
	for(;;)
	{
		self waittill("spawned_player");
		
		self thread doDvars();
		
		//if(self.team == game["defenders"]) self thread maps\mp\gametypes\_AliensPredators::doAliens();
		//else if(self.team == game["attackers"]) self thread maps\mp\gametypes\_AliensPredators::doPredator();
	
	
	}
} 
 
AVP_stats()
{
	self endon("disconnect");
	
	self.AVP_predators_killed = self getstat(3435); //Preds
	self.AVP_aliens_killed = self getstat(3436); //Aliens

	self waittill("spawned_player");
	
	self.HUD["AVP"]["PREDS_KILLED"] = self createText("default", 1.4, "LEFT", "LEFT",  0 + self.AIO["safeArea_X"], -60, 1, 1, (1,1,1), "");
	self.HUD["AVP"]["PREDS_KILLED"].label = &"Predators killed: ^3";
	self.HUD["AVP"]["PREDS_KILLED"] setValue(self.AVP_predators_killed);

	self.HUD["AVP"]["ALIENS_KILLED"] = self createText("default", 1.4, "LEFT", "LEFT",  0 + self.AIO["safeArea_X"], -43, 1, 1, (1,1,1), "");
	self.HUD["AVP"]["ALIENS_KILLED"].label = &"Aliens killed: ^3";
	self.HUD["AVP"]["ALIENS_KILLED"] setValue(self.AVP_aliens_killed);

	
	while(1)
	{
		self waittill_any("REFRESH_HUDS","destroy_all_huds");

		if(level.gameEnded)
		{
			self.PredatorsBar["1"] AdvancedDestroy(self);
			self.PredatorsBar["2"] AdvancedDestroy(self);
			self.PredatorsBar["3"] AdvancedDestroy(self);
			
			self.HUD["AVP"]["PREDS_KILLED"] AdvancedDestroy(self);
			self.HUD["AVP"]["ALIENS_KILLED"] AdvancedDestroy(self);
			
			if(isDefined(self.PredBar))self.PredBar AdvancedDestroy(self);
			if(isDefined(self.PredText))self.PredText AdvancedDestroy(self);
			
		}
		else
		{
			self.HUD["AVP"]["PREDS_KILLED"] setPoint("LEFT", "LEFT",  0 + self.AIO["safeArea_X"], -60);
			self.HUD["AVP"]["ALIENS_KILLED"] setPoint("LEFT", "LEFT",  0 + self.AIO["safeArea_X"], -43);
		}
	}
}
 
doDvars()
{
	self setClientDvar("nightVisionDisableEffects", "1" );
	
	wait 4;
	
	self setClientDvar("bg_fallDamageMaxHeight", "9999" );
	self setClientDvar("bg_fallDamageMinHeight", "9999" );
	self setClientDvar("aim_automelee_enabled", "0" );
	self setClientDvar("player_UnlimitedSprint", "1");
	
	
	wait 1;
	
	self setClientDvar("cg_drawCrosshair", "1");
	
	if(game["attackers"] == "allies")
	{
		self setClientDvar("g_TeamColor_Allies", "0 2 0 1");
		self setClientDvar("g_TeamColor_Axis", "1 0 0 1" );
		self setClientDvar("g_TeamName_Allies", "^1Predators");
		self setClientDvar("g_TeamName_Axis", "^2Aliens");
		self setClientDvar("g_teamicon_axis", "killiconmelee");
		self setClientDvar("g_teamicon_allies", "weapon_g36c");
	}
	else if(game["attackers"] == "axis")
	{
		self setClientDvar("g_TeamColor_Allies", "1 0 0 1");
		self setClientDvar("g_TeamColor_Axis", "0 2 0 1" );		
		self setClientDvar("g_TeamName_Allies", "^2Aliens");
		self setClientDvar("g_TeamName_Axis", "^1Predators");
		self setClientDvar("g_teamicon_axis", "weapon_g36c");
		self setClientDvar("g_teamicon_allies", "killiconmelee");
	}
 
} 



doAliens()
{
	self setclientdvar("r_filmTweakLightTint","1.63834 0.47453 1.48423");
	self setClientDvar("cg_scoreboardMyColor","0 2 0 1");
	self.isAlien = true;
	self VisionSetNakedForPlayer("cheat_chaplinnight");
	self thread maps\mp\gametypes\_hud_message::hintMessage("^7You are an ^2ALIEN!");
	self setMoveSpeedScale(1.5);
	self setPerk("specialty_quieter");
	self thread ThrowingKnife();
	self giveWeapon("defaultweapon_mp", 0, false);
	self switchToWeapon("defaultweapon_mp");
	self setWeaponAmmoClip("defaultweapon_mp", 0);
	self setWeaponAmmoStock("defaultweapon_mp", 0);
	
	self thread useBooster();
	//self attach("vehicle_cobra_helicopter_d_piece02","J_spine4",false);
	//self attach("vehicle_cobra_helicopter_d_piece02","J_knee_ri",false);
	//self attach("vehicle_cobra_helicopter_d_piece02","J_knee_le",false);
	//self attach("vehicle_cobra_helicopter_d_piece02","J_shoulder_RI",false);
	//self attach("vehicle_cobra_helicopter_d_piece02","J_shoulder_LE",false);
	
	self.maxhealth = 200;
	self.health = self.maxhealth;
}
useBooster()
{
	self endon("disconnect");
	self endon("death");
	
	self iprintlnbold("Press [{+attack}] to use booster");
	
	for(;;)
	{
		if(self attackButtonPressed())
		{
			earthquake(0.75, 2, self.origin, 400);
			self setclientdvar("r_filmTweakLightTint","0 1.08 1");
			self setMoveSpeedScale(2.5);
			wait 3;
			self setclientdvar("r_filmTweakLightTint","1.63834 0.47453 1.48423");
			self setMoveSpeedScale(1.5);
			wait 8;
			self iprintln("^2Booster ready");
		}
		
		
		wait .05;
	}
}
doPredator()
{
	self setClientDvar("cg_scoreboardMyColor","1 0 0 1");
	self.isPredator = true;
	self allowJump(false);		
	self setPerk("specialty_bulletaccuracy");
	self setPerk("specialty_bulletpenetration");
	self setPerk("specialty_bulletdamage");
	self setPerk("specialty_extraammo");
	self setMoveSpeedScale(.9);
	self VisionSetNakedForPlayer("cheat_invert_contrast");
	self thread maps\mp\gametypes\_hud_message::hintMessage("^7You are a ^1PREDATOR!");	
	self thread Sensor();
	self thread SensorParam();
	self giveWeapon( "g36c_reflex_mp", 0, false );
	self setWeaponAmmoClip("g36c_reflex_mp", 30);
	self setWeaponAmmoStock("g36c_reflex_mp", 180);
	self switchToWeapon( "g36c_reflex_mp" );
	
	self thread predatorHUD();
	
}
predatorHUD()
{
	self.PredatorsBar["1"] = self createRectangle("CENTER", "CENTER", 500, 0, 2, 800, (1,0,0), "white", 1, 1);
	self.PredatorsBar["2"] = self createRectangle("CENTER", "CENTER", 500, 0, 2, 800, (1,0,0), "white", 1, 1);
	self.PredatorsBar["3"] = self createRectangle("CENTER", "CENTER", 500, 0, 2, 800, (1,0,0), "white", 1, 1);
	self.PredatorsBar["0"] = self createRectangle("CENTER", "CENTER", 0, 0, 960, 480, (1,1,1), "nightvision_overlay_goggles", 2, 1);
	
	
	self thread movinanim();
}

movinanim()
{
	self endon("disconnect");
	self endon("death");
	
	while(!level.gameEnded)
	{
		time1 = randomintrange(2,6);
		time2 = randomintrange(2,6);
		time3 = randomintrange(2,6);
		
		self.PredatorsBar["1"] thread hudMoveX(-500,time1);
		wait .2;
		self.PredatorsBar["2"] thread hudMoveX(-500,time2);
		wait 1;
		self.PredatorsBar["3"] thread hudMoveX(-500,time3);
		wait 5;
	 
		self.PredatorsBar["1"].x = 500;
		self.PredatorsBar["2"].x = 500;
		self.PredatorsBar["3"].x = 500;
		 
	}

}

ThrowingKnife()
{
	self endon("disconnect");
	self endon("KillKnife");
	
	self iPrintlnBold( "Press [{+smoke}] to throw knife" );	
	
	self SetOffhandSecondaryClass("flash");
	self giveWeapon("flash_grenade_mp");
	self setWeaponAmmoClip("flash_grenade_mp", 1);
	self SwitchToOffhand("flash_grenade_mp");
							
	self waittill( "grenade_fire", grenadeWeapon );
	
	if(grenadeWeapon == "flash_grenade_mp")
	{
		
		grenadeWeapon delete();
		
		if(self getstance() == "stand")
			pos = (0,0,20); 
		else if(self getstance() == "crouch")
			pos = (0,0,0);
		else
			pos = (0,0,-30);
		
		trace = bullettrace(self geteye() + pos,self geteye() + vector_scale( anglestoforward(self getplayerangles()), 500000 ) + pos, true, self );
		Knife = spawn("script_model", self.origin);
		Knife.origin = self geteye() + pos;
		Knife.angles = self.angles;
		Knife setmodel("weapon_parabolic_knife");
		Knife thread KnifeSpin(self);
		time = Distratios(distance(Knife.origin,trace["position"]));
		
		Knife moveto(trace["position"],time);
		Knife.startangle = self.angles;
		self.hasEquipment = false;
		
		while(Knife.origin != trace["position"])
		{
			wait 0.75;
			tracez = bullettrace( Knife.origin, Knife.origin + vector_scale( anglestoforward( Knife.startangle ), 45 ), true, Knife );
			
			if( isDefined(tracez["entity"]) && isplayer( tracez["entity"] ) && isAlive( tracez["entity"]) && tracez["entity"].team != self.team) 
				tracez["entity"] [[level.callbackPlayerDamage]]( self, self, tracez["entity"].health, level.iDFLAGS_NO_KNOCKBACK, "MOD_MELEE", "m16_mp", (0,0,0), (0,0,0), "torso_lower", 0 );
			
		}
		
		self thread ThrowingKnife();
		Knife delete();
		Knife notify("KillKnife");
		
	}
}
KnifeSpin(player)
{
	self endon("KillKnife");
	level endon("game_ended");
	player endon("disconnect");
	
	
	for(;;)
	{
		self rotatepitch(180, 0.20);
		wait 0.35;
	}
}
Distratios(dist)
{
	time = dist / 3000;
	return time;
}


Sensor()
{
	self endon("disconnect");
	
	self.PredBar = createPrimaryProgressBar((1,0,0));
	self.PredBar setPoint("CENTER","TOP",0,20 + self.AIO["safeArea_Y"]);
	self.PredBar.color = (0,0,0);
	
	self.PredText = createFontString("default",1.5);
	self.PredText setPoint("CENTER","TOP",0,0 + self.AIO["safeArea_Y"]);
	self.PredText.color =(1,0,0);
	self.PredText setText("Aliens sensor");
	
	while(1)
	{
		for(i = 0; i < level.players.size; i++)
		{
			player = level.players[i];
		
			if(player.team != self.team && isAlive(player))
			{
				if(distance(self.origin, player.origin) < level.sensorLimit)
				{
					self.curDist = distance(self.origin, player.origin);
					//self.curPlayer = player;
				}
			}
		}
		wait .05;
	}
}
SensorParam()
{
	self endon("disconnect");
	
	for(;;)
	{
		for(i = 0; i < level.players.size; i++)
		{
			player = level.players[i];
			
			if(player.team != self.team && isAlive(player))
			{
				while(distance(self.origin, player.origin) < level.sensorLimit)
				{
					self.dist = distance(self.origin, player.origin);
					//self.joueur = player;
					
					if(!isAlive(player))
						break;

					if(self.curDist < self.dist)
					{
						//self iprintln(self.joueur.name+" "+self.curPlayer.name);
						
						//if(self.curPlayer != self.joueur)
						//{
							
							//self iprintln("changed " +player.name);
							break;
						//}
					}
					//if(self.curPlayer != self.joueur)
						//self iprintln(self.joueur.name+" "+self.curPlayer.name);
					
					upBar = (distance(self.origin, player.origin) / level.sensorLimit);
				
					///self iprintln(upBar);
					
					if(upBar < 0.5)
					{
						ecart = (0.5 - upBar);
						upBar = (0.5 + ecart);
					}
					else if(upBar > 0.5)
					{
						ecart = (upBar - 0.5);
						upBar = (0.5 - ecart);
					}
					
					self.PredBar updateBar(upBar);
				
					wait .05;
				}
				
			}
		}
		
		wait .05;
		
		self.PredBar updateBar(0);
		
		
	}
}
	

VisionSetNakedForPlayer(vision)
{
	switch(vision)
	{
		case "cheat_invert_contrast":
		self setClientDvar("r_filmwteakenable",1);
		self setClientDvar("r_filmUseTweaks",1);
		self setClientDvar("r_glow",0);
		self setClientDvar("r_glowRadius0",7);
		self setClientDvar("r_glowRadius1",7);
		self setClientDvar("r_glowBloomCutoff",0.99);
		self setClientDvar("r_glowBloomDesaturation",0.65);
		self setClientDvar("r_glowBloomIntensity0",0.36);
		self setClientDvar("r_glowBloomIntensity1",0.36);
		self setClientDvar("r_glowSkyBleedIntensity0",0.29);
		self setClientDvar("r_glowSkyBleedIntensity1",0.29);
		self setClientDvar("r_filmTweakEnable",1);
		self setClientDvar("r_filmTweakContrast",3);
		self setClientDvar("r_filmTweakBrightness",1);
		self setClientDvar("r_filmTweakDesaturation",0);
		self setClientDvar("r_filmTweakInvert",1);
		self setClientDvar("r_filmTweakLightTint","1 1 1");
		self setClientDvar("r_filmTweakDarkTint","1 1 1");
		break;
		
			//self setClientDvars(
			//"r_specularmap",2,
			//"r_filmTweakLightTint","0 1.08 1",
			//"r_filmTweakDesaturation",.2,
			//"r_filmTweakEnable",1,
			//"r_filmUseTweaks",1,
			//"r_filmTweakContrast",1.55,
			//"r_filmTweakBrightness",.13,
			//"r_filmTweakInvert",1,
			//"r_lightTweakSunColor","1 1 1 1");

			
		case "cheat_chaplinnight": 
		self setClientDvar("r_filmwteakenable",1);
		self setClientDvar("r_filmUseTweaks",1);
		self setClientDvar("r_glow",1);
		self setClientDvar("r_glowRadius0",0);
		self setClientDvar("r_glowRadius1",0);
		self setClientDvar("r_glowBloomCutoff",0.99);
		self setClientDvar("r_glowBloomDesaturation",0.65);
		self setClientDvar("r_glowBloomIntensity0",0.36);
		self setClientDvar("r_glowBloomIntensity1",0.36);
		self setClientDvar("r_glowSkyBleedIntensity0",0.29);
		self setClientDvar("r_glowSkyBleedIntensity1",0.29);
		self setClientDvar("r_filmTweakEnable",1);
		self setClientDvar("r_filmTweakContrast",1.43801);
		self setClientDvar("r_filmTweakBrightness",0.1443);
		self setClientDvar("r_filmTweakDesaturation",0.9525);
		self setClientDvar("r_filmTweakInvert",1);
		self setClientDvar("r_filmTweakLightTint","1.63834 0.47453 1.48423");
		self setClientDvar("r_filmTweakDarkTint","2 2 2");
		break;
	}
}
