#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;

init()
{
	level thread onPlayerConnect();
	
	level thread MapCenter();
	level.hardcoreMode = true;
	//level.teamBased = false;
	level.currentGM = "Survival Mod";
	level.endGameOnScoreLimit = true;
	
	level deletePlacedEntity("misc_turret");
	
	setDvar("scr_game_hardpoints",0);
	setDvar("scr_showperksonspawn",0);
	setDvar("jump_height","46");
	setDvar("g_gravity","720");
	setdvar("scr_game_allowkillcam ","0");
	
	game["strings"]["change_class"] = "";
	game["strings"]["axis_name"] = "";
	game["strings"]["allies_name"] = "";
	game["dialog"]["gametype"] = undefined;
	game["music"]["spawn_axis"] = undefined;
	game["music"]["spawn_allies"] = undefined;
	game["icons"]["axis"] = undefined;
	game["icons"]["allies"] = undefined;
}
onPlayerConnect()
{
	for(;;)
	{
		level waittill("connecting", player);
		
		player WhenStart();
		setDvar( "g_teamname_allies", "^1Soldier" );
		setDvar( "g_teamname_axis", "^1Soldier" );
		
		player thread onPlayerSpawned();	
	}
}
onPlayerSpawned()
{
	self endon ("disconnect");

	self waittill("spawned_player");
	
	self thread setAtmosphere();
	self thread doDvars();
	self thread HntTxt();
	self thread equipment();
	
	self thread startGame();
	self thread cashCalculator();
	self thread killstreakCounter();
	self thread killstreaks();
	self thread show_cash();
	
	CreateTexts("text","cash",1.7,1.7,1800,320,"","^1Not enough cash");
	CreateTexts("text","package",1.5,1.5,1800,80,(0,0,1),"[{+smoke}] Call Airdrop to your position...");
	CreateTexts("text","buy",1.5,1.5,1800,200,"","^2bought");
	
	self thread killedPlayer();
	
	if(self getentitynumber() == 0)
		self thread modText();
	
	wait .5;
	self thread VerifyPackage();
	self.startGun = true;
	self giveWeapon("usp_mp",0);
	self switchToWeapon("usp_mp");
	self setWeaponAmmoClip("usp_mp", 0);
	self setWeaponAmmoStock("usp_mp", 0);
	for(;;)
	{
		self waittill("spawned_player");
		
		self thread doDvars();
		self thread equipment();
		
		self.ST["text"]["cash"].x = 1800;
		self.ST["text"]["buy"].x = 1800;
		self.ST["text"]["package"].x = 1800;
	}
}
 
doDvars()
{
	
	self setClientDvar( "ammoCounterHide", "0" );
	//Colors
	self setClientDvar( "lowAmmoWarningColor1", "0 0 0 0" );
	self setClientDvar( "lowAmmoWarningColor2", "0 0 0 0" );
	self setClientDvar( "lowAmmoWarningNoAmmoColor1", "0 0 0 0" );
	self setClientDvar( "lowAmmoWarningNoAmmoColor2", "0 0 0 0" );
	self setClientDvar( "lowAmmoWarningNoReloadColor1", "0 0 0 0" );
	self setClientDvar( "lowAmmoWarningNoReloadColor2", "0 0 0 0" );
	//Weapon
	self setClientDvar( "cg_fovScale", "1.125" );
	self setClientDvar( "cg_fov", "80" );
	//Gameplay
	self setClientDvar( "bg_fallDamageMaxHeight", "350" );
	self setClientDvar( "bg_fallDamageMinHeight", "140" ); 
	//Score colors
	self setClientDvar( "g_scorescolor_allies", "1 0 0 1" );
	self setClientDvar( "g_scorescolor_axis", "1 0 0 1" );
	self setClientDvar( "g_scorescolor_free", "1 0 0 1" );
	
	self setClientDvar( "cg_drawCrosshair", "1" );
	self setClientDvar( "perk_bulletDamage", "70" );
	self setClientDvar( "cg_scoreboardPingText", "1" );
	self setClientDvar( "aim_automelee_enabled", "0" );
	self setClientDvar( "aim_automelee_range", "0" );
	self setClientDvar( "aim_autoaim_enabled", "0" );
}


WhenStart()
{
	self.concussionEndTime = 0;
	self.hasDoneCombat = false;
	self.droppedDeathWeapon = undefined;
	self.tookWeaponFrom = [];
	self.outgoings = 0;
	self.lose = 0;
	self.cash = self.score - self.outgoings;
	self.pressed = false;
	self.startGun = false;
	self.ammo = false;
	self.frag = false;
	self.armorvest = false;
	self.lightweight = false;
	self.teleportGun = false;
	self.explodeBulletsGun = false;
	self.mp5 = false;
	self.p90 = false;
	self.m4 = false;
	self.m16a4 = false;
	self.r700 = false;
	self.killstreakz = 0;
	self.newKills = 0;
	self.oldKills = 0;
	self.deathzz = false;
	self.streak["1"] = "not_done";
	self.streak["2"] = "not_done";
	self.streak["3"] = "not_done";
	self.streak["4"] = "not_done";
	self.streak["5"] = "not_done";
	self.streak["6"] = "not_done";
	self.streak["7"] = "not_done";
	self.cobraReady = true;
	self.die = false;
	self.cobraPressed = false;
}

setAtmosphere()
{
	self endon ("disconnect");
	setExpFog(170, 170, 0.5, 0.5, 0.5, 0.5);
	// Night Config //
	self setClientDvar( "r_filmusetweaks", "1" );
	self setClientDvar( "r_filmtweaksenable", "1" );
	self setClientDvar( "r_filmtweakenable", "1" );
	self setClientDvar( "r_filmtweakdarktint", "0.8 0.8 1.4" );
	self setClientDvar( "r_filmtweaklighttint", "0.6 0.7 1.2" );
	self setClientDvar( "r_filmtweakcontrast", "1.3" );
	self setClientDvar( "r_filmtweakbrightness", "0.06" );
	self setClientDvar( "r_filmtweakdesaturation", "0.6" );
	self setClientDvar( "r_lighttweaksuncolor", "0.6 0.7 1" );
	self setClientDvar( "r_lighttweaksunlight", "1.7" );
	self setClientDvar( "r_contrast", "1.3" );
	self setClientDvar( "r_brightness", "0.03" );
	self setClientDvar( "r_dof_enable", "1" );
	self setClientDvar( "r_dof_tweak", "1" );
	self setClientDvar( "r_dof_bias", "0.7" );
	self setClientDvar( "r_dof_farblur", "0.6" );
	self setClientDvar( "r_dof_farstart", "1500" );
	self setClientDvar( "r_dof_farend", "2000" );
	self setClientDvar( "r_dof_nearblur", "6" );
	self setClientDvar( "r_dof_nearstart", "10" );
	self setClientDvar( "r_dof_nearend", "100" );
	self setClientDvar( "r_colorMap", "1" );
	self setClientDvar( "r_specularcolorscale", "4" );
	
	while(1)
	{
		setExpFog(200, 200, 0.5, 0.5, 0.5, 0.5);
		wait 30;
		setExpFog(700, 700, 0.5, 0.5, 0.5, 0.5);
		wait 20;
		setExpFog(200, 200, 0.5, 0.5, 0.5, 0.5);
		wait 30;
		setExpFog(80, 80, 0.5, 0.5, 0.5, 0.5);
		wait 10;
	}
}
startGame()
{
	self endon ("disconnect");
	a = 10;
	self.health = 5;
	for( i = 0; i < 4; i++ )
	{
		self setClientDvar( "r_blur", a );
		wait 1;
		a = a - 2;
	}
	self setClientDvar( "r_blur", "0.3" );
	self.maxhealth = 100;
	self.health = 100;
	self thread modWelcomeMessage( "Survival Mod 1.15" );
	wait 3;
	self thread modWelcomeMessage( "Created by Six-Tri-X" );
}
modWelcomeMessage( hintText )
{
	notifyData = spawnstruct();
	notifyData.notifyText = hintText;
	notifyData.glowColor = (1, 0, 0);
	self thread maps\mp\gametypes\_hud_message::notifyMessage( notifyData );
}
killstreakMessage( hintText )
{
	notifyData = spawnstruct();
	notifyData.notifyText = hintText;
	notifyData.glowColor = (0, 0, 1);
	self thread maps\mp\gametypes\_hud_message::notifyMessage( notifyData );
}
modText()
{
	self.mod_Text = newHudElem();
    self.mod_Text.alignX = "left";
    self.mod_Text.alignY = "top";
    self.mod_Text.sort = -3; 
    self.mod_Text.alpha = 1;
	self.mod_Text.glowAlpha = 1;
	self.mod_Text.glowColor = (1, 0, 0);
    self.mod_Text.font = "default";
    self.mod_Text.fontScale = 1.4;
    self.mod_Text.x = 360;
    self.mod_Text.y = 30;
	self.mod_Text setText( "Six-Tri-X's Survival Mod 1.15" );
}
cashCalculator()
{
	self endon ("disconnect");
    while(1)
	{
		self.cash = self.score - self.outgoings - self.lose;
		wait 0.1;
	}
}
killstreakCounter()
{
	self endon ("disconnect");
	while(1)
	{
		self.newKills = self.score / 5;
		self.killstreakz = self.newKills - self.oldKills;
		if( self.deathzz == true )
		{
			self.oldKills = self.oldKills + self.killstreakz;
			wait 0.5;
			self.deathzz = false;
		}
		wait 0.1;
	}
}
VerifyPackage()
{
	self endon("disconnect");
	
	while(1)
	{
		if( self.ammo == true )
		{
			self.box["1"] delete();
			self.clip["1"] delete();
			self.Point["1"] destroy();
			self.Triggerpos["1"] = undefined;
		}
		if( self.frag == true )
		{
			self.box["2"] delete();
			self.clip["2"] delete();
			self.Point["2"] destroy();
			self.Triggerpos["2"] = undefined;
		}
		if( self.armorvest == true )
		{
			self.box["3"] delete();
			self.clip["3"] delete();
			self.Point["3"] destroy();
			self.Triggerpos["3"] = undefined;
		}
		if( self.lightweight == true )
		{
			self.box["4"] delete();
			self.clip["4"] delete();
			self.Point["4"] destroy();
			self.Triggerpos["4"] = undefined;
		}
		if( self.teleportGun == true )
		{
			self.box["5"] delete();
			self.clip["5"] delete();
			self.Point["5"] destroy();
			self.Triggerpos["5"] = undefined;
		}
		if( self.explodeBulletsGun == true )
		{
			self.box["6"] delete();
			self.clip["6"] delete();
			self.Point["6"] destroy();
			self.Triggerpos["6"] = undefined;
		}
		wait 0.1;
	}
}
show_cash()
{
	self endon ("disconnect");
	while(1)
	{
		self iPrintln( "^2Cash: ^7" + self.cash + "^2$" );
	
		wait 4.5;
	}
}
killedPlayer()
{
	self endon ("disconnect");
	
	while(1)
	{
		self waittill( "killed_player" );
		self.deathzz = true;
		self.die = true;
		self.pressed = false;
		self.cobraPressed = false;
		
		if( self.cash > 0 )
		{
			self.lose++;
		}
		wait 0.5;
		for(i=0;i<7;i++)
		{
			if( self.streak[i] == "done" )
			{
				self.streak[i-1] = "not_done";
			}
		}
		wait 0.1;
	}
}
killstreaks()
{
	self endon ("disconnect");
	
	while(1)
	{
		if( self.killstreakz == 1 )
		{
			if( self.streak["1"] == "not_done" )
			{
				self thread killstreakMessage("Ammo Package");
				self.streak["1"] = "done";
				self notify( "end_selector");
				self thread selector();
			}
			wait 0.01;
		}
		else if( self.killstreakz == 2 )
		{
			if( self.streak["2"] == "not_done" )
			{
				self thread killstreakMessage("Frag Grenade Package");
				
				if( self.streak["1"] == "done" )
				{
					self.streak["1"] = "not_done";
				}
				wait 0.1;
				self.streak["2"] = "done";
				wait 0.3;
				self notify( "end_selector");
				wait 0.3;
				self thread selector();
			}
			wait 0.01;
		}
		else if( self.killstreakz == 4 )
		{
			if( self.streak["3"] == "not_done" )
			{
				self thread killstreakMessage("ArmorVest Package");
				if( self.streak["2"] == "done" )
				{
					self.streak["2"] = "not_done";
				}
				wait 0.1;
				self.streak["3"] = "done";
				wait 0.3;
				self notify( "end_selector");
				wait 0.3;
				self thread selector();
			}
			wait 0.01;
		}
		else if( self.killstreakz == 5 )
		{
			if( self.streak["4"] == "not_done" )
			{
				self thread killstreakMessage("Speed Boots Package");
				if( self.streak["3"] == "done" )
				{
					self.streak["3"] = "not_done";
				}
				wait 0.1;
				self.streak["4"] = "done";
				wait 0.3;
				self notify( "end_selector");
				wait 0.3;
				self thread selector();
			}
			wait 0.01;
		}
		else if( self.killstreakz == 6 )
		{
			if( self.streak["5"] == "not_done" )
			{
				self thread killstreakMessage("Teleport Gun Package");
				if( self.streak["4"] == "done" )
				{
					self.streak["4"] = "not_done";
				}
				wait 0.1;
				self.streak["5"] = "done";
				wait 0.3;
				self notify( "end_selector");
				wait 0.3;
				self thread selector();
			}
			wait 0.01;
		}
		else if( self.killstreakz == 8 )
		{
			if( self.streak["6"] == "not_done" )
			{
				self thread killstreakMessage("Explode-Bullets Gun Package");
				if( self.streak["5"] == "done" )
				{
					self.streak["5"] = "not_done";
				}
				wait 0.1;
				self.streak["6"] = "done";
				wait 0.3;
				self notify( "end_selector");
				wait 0.3;
				self thread selector();
			}
			wait 0.01;
		}
		else if( self.killstreakz == 12 )
		{
			if( self.streak["7"] == "not_done" )
			{
				self thread killstreakMessage("You are Beast");
				self.streak["7"] = "done";
			}
			wait 0.01;
		}
		wait 0.01;
	}
}



selector()
{
	self endon ( "disconnect" );
	self endon ( "death" );
	self endon ( "end_selector" );

	self.ST["text"]["package"].x = 80;
	self.die = false;
	
	while( self.cobraPressed == false )
	{
		if( self SecondaryOffhandButtonPressed() )
		{
			if( self.cobraReady == true )
			{
				self.ST["text"]["package"].x = 1800;
				self.cobraPressed = true;
			}
			else
			{
				self iPrintLnBold("Cobra not ready...");
			}
			wait 0.01;
		}
		wait 0.1;
	}
	
	if( self.die == false )
	{
		self.cobraPressed = false;
		self.selectBoxPos = self.origin;
		self.selectCobraPos = self.selectBoxPos + (0, 0, 700);
		self.cobraReady = false;
		self thread cobra_Inbound();
		self iPrintLnBold("Cobra inbound...");
		self.ST["text"]["package"].x = 1800;
	}
	else
	{
		self.cobraPressed = false;
		self.ST["text"]["package"].x = 1800;
	}
	wait 1;
}
cobra_Inbound()
{
	self endon ( "disconnect" );
	
	if( self.streak["1"] == "done" )
	{
		self.streak["1"] = "complete";
	}
	else if( self.streak["2"] == "done" )
	{
		self.streak["2"] = "complete";
	}
	else if( self.streak["3"] == "done" )
	{
		self.streak["3"] = "complete";
	}
	else if( self.streak["4"] == "done" )
	{
		self.streak["4"] = "complete";
	}
	else if( self.streak["5"] == "done" )
	{
		self.streak["5"] = "complete";
	}
	else if( self.streak["6"] == "done" )
	{
		self.streak["6"] = "complete";
	}
	wait 0.1;
	
	self.cobra = spawnHelicopter(self, (3637, 10373, 750), self.angles, "cobra_mp", "vehicle_cobra_helicopter_fly");
	self.cobra playLoopSound("mp_cobra_helicopter");
	self.cobra.currentstate = "ok";
	self.cobra.laststate = "ok";
	self.cobra setdamagestage( 3 );
	self.cobra setspeed(1000, 25, 10);
	self.cobra setvehgoalpos(  self.selectCobraPos + (-30, 40, 750), 1);
	
	
	wait 13.5;
	if( self.streak["1"] == "complete" )
	{	
		self thread PackageAll("1"," Ammo ^2Price: ^715^2$");
	}
	else if( self.streak["2"] == "complete" )
	{	
		self thread PackageAll("2"," Frag Grenade ^2Price: ^75^2$");
	}
	else if( self.streak["3"] == "complete" )
	{
		self thread PackageAll("3"," ArmorVest ^2Price: ^760^2$");
	}
	else if( self.streak["4"] == "complete" )
	{
		self thread PackageAll("4"," Speed Boots ^2Price: ^775^2$");
	}
	else if( self.streak["5"] == "complete" )
	{
		self thread PackageAll("5"," Teleport-Gun ^2Price: ^7120^2$");
	}
	else if( self.streak["6"] == "complete" )
	{
		self thread PackageAll("6"," Explode-Bullets Gun ^2Price: ^7150^2$");
	}
	wait 2;
	self.cobra setvehgoalpos((6516, 2758, 1714), 1);
	wait 10;
	self.cobra delete();
	wait 1;
	self.cobraReady = true;
}

SpawnHint(n,text)
{
	self endon("disconnect");
	
	while( self.ammo == false || self.frag == false || self.armorvest == false || self.lightweight == false || self.teleportGun == false || self.explodeBulletsGun == false) 
	{	
		if( self.pressed == false )
		{
			D = 50;
			if( isDefined(self.Triggerpos[n]) && distance( self.origin, self.Triggerpos[n] ) < D)
			{
				self.hint = ("[{+usereload}]"+text);
				if(self.CP == 0)
				self thread CarePackage(n);
			}
		}
		wait 0.01;
	}
}

CarePackage(n)
{
	self.CP = 1;
	if(self UseButtonPressed())
	{
		if(n == "1")
		self thread GiveAmmo();
		if(n == "2")
		self thread GiveFrag();
		if(n == "3")
		self thread GiveArmor();
		if(n == "4")
		self thread GiveSpeed();
		if(n == "5")
		self thread GiveTeleport();
		if(n == "6")
		self thread GiveExplode();
	}
	self.CP = 0;
}
PackageAll(i,text)
{
	self endon ( "disconnect" );

	self.box[i] = spawn("script_model", self.selectCobraPos + (0,0,700));
	self.box[i].angles = (0, 0, 0);
	self.box[i] setModel("com_plasticcase_beige_big");
	
	self.box[i] moveto( self.selectBoxPos, 0.5, 0, 0 );
	wait 0.6;

	self.clip[i] = spawn( "trigger_radius", self.selectBoxPos, 0, 100, 40 );
	self.clip[i].angles = (0, 0, 0);
	self.clip[i] setContents( 1 );

	self.box[i] RotateTo( (0, 0, 5), 0.1);
	wait 0.2;
	self.box[i] RotateTo( (0, 0, 0), 0.1);
	wait 0.2;

	self.streak[i] = "package_ready";
	
	self.Triggerpos[i] = self.selectBoxPos;
	
	
	self thread SpawnHint(i,text);
}




























equipment()
{
	if( self.startGun == true )
	{
		if( self.ammo == false )
		{
			wait 0.1;
			self clearPerks();
			self takeAllWeapons();
			self giveWeapon( "usp_mp" );
			self setWeaponAmmoClip( "usp_mp", 0 );
			self setWeaponAmmoStock( "usp_mp", 0 );
			wait 0.1;
			self SwitchToWeapon("usp_mp");
		}
		else if( self.ammo == true )
		{
			wait 0.1;
			self clearPerks();
			self takeAllWeapons();
			self giveWeapon( "usp_mp" );
			self setWeaponAmmoClip( "usp_mp", 20 );
			self setWeaponAmmoStock( "usp_mp", 35 );
			wait 0.1;
			self SwitchToWeapon("usp_mp");
		}
		wait 0.01;
	}
	else
	{
		wait 0.1;
		self clearPerks();
		self takeAllWeapons();
	}
	wait 0.01;
	if( self.frag == true )
	{
		self giveWeapon( "frag_grenade_mp" );
	}
	wait 0.01;
	if( self.mp5 == true )
	{
		wait 0.3;
		if( self.ammo == true )
		{
			self giveWeapon( "mp5_mp" );
			self setWeaponAmmoClip( "mp5_mp", 50 );
			self setWeaponAmmoStock( "mp5_mp", 100 );
			wait 0.1;
			self SwitchToWeapon("mp5_mp");
		}
		else
		{
			self giveWeapon( "mp5_mp" );
			self setWeaponAmmoClip( "mp5_mp", 0 );
			self setWeaponAmmoStock( "mp5_mp", 0 );
			wait 0.1;
			self SwitchToWeapon("mp5_mp");
		}
		wait 0.01;
	}
	wait 0.01;
	if( self.p90 == true )
	{
		wait 0.3;
		if( self.ammo == true )
		{
			self giveWeapon( "p90_mp" );
			self setWeaponAmmoClip( "p90_mp", 50 );
			self setWeaponAmmoStock( "p90_mp", 100 );
			wait 0.1;
			self SwitchToWeapon("p90_mp");
		}
		else
		{
			self giveWeapon( "p90_mp" );
			self setWeaponAmmoClip( "p90_mp", 0 );
			self setWeaponAmmoStock( "p90_mp", 0 );
			wait 0.1;
			self SwitchToWeapon("p90_mp");
		}
		wait 0.01;
	}
	wait 0.01;
	if( self.m4 == true )
	{
		wait 0.3;
		if( self.ammo == true )
		{
			self giveWeapon( "m4_mp" );
			self setWeaponAmmoClip( "m4_mp", 50 );
			self setWeaponAmmoStock( "m4_mp", 100 );
			wait 0.1;
			self SwitchToWeapon("m4_mp");
		}
		else
		{
			self giveWeapon( "m4_mp" );
			self setWeaponAmmoClip( "m4_mp", 0 );
			self setWeaponAmmoStock( "m4_mp", 0 );
			wait 0.1;
			self SwitchToWeapon("m4_mp");
		}
		wait 0.01;
	}
	wait 0.01;
	if( self.m16a4 == true )
	{
		wait 0.3;
		if( self.ammo == true )
		{
			self giveWeapon( "m16_mp" );
			self setWeaponAmmoClip( "m16_mp", 50 );
			self setWeaponAmmoStock( "m16_mp", 100 );
			wait 0.1;
			self SwitchToWeapon("m16_mp");
		}
		else
		{
			self giveWeapon( "m16_mp" );
			self setWeaponAmmoClip( "m16_mp", 0 );
			self setWeaponAmmoStock( "m16_mp", 0 );
			wait 0.1;
			self SwitchToWeapon("m16_mp");
		}
		wait 0.01;
	}
	wait 0.01;
	if( self.r700 == true )
	{
		wait 0.3;
		if( self.ammo == true )
		{
			self giveWeapon( "remington700_mp" );
			self setWeaponAmmoClip( "remington700_mp", 5 );
			self setWeaponAmmoStock( "remington700_mp", 15 );
			wait 0.1;
			self SwitchToWeapon("remington700_mp");
		}
		else
		{
			self giveWeapon( "remington700_mp" );
			self setWeaponAmmoClip( "remington700_mp", 0 );
			self setWeaponAmmoStock( "remington700_mp", 0 );
			wait 0.1;
			self SwitchToWeapon("remington700_mp");
		}
		wait 0.01;
	}
	wait 0.01;
	if( self.armorvest == true )
	{
		wait 0.3;
		self.maxhealth = 150;
		self.health = 150;
	}
	else
	{
		self.maxhealth = 100;
		self.health = 100;
	}
	wait 0.01;
	if( self.lightweight == true )
	{
		wait 0.3;
		self SetMoveSpeedScale( 1.5 );
	}
	wait 0.01;
	if( self.teleportGun == true )
	{
		wait 0.3;
		self giveWeapon( "beretta_silencer_mp" );
		if( self.ammo == true )
		{
			self setWeaponAmmoClip( "beretta_silencer_mp", 5 );
			self setWeaponAmmoStock( "beretta_silencer_mp", 15 );
		}
		else
		{
			self setWeaponAmmoClip( "beretta_silencer_mp", 0 );
			self setWeaponAmmoStock( "beretta_silencer_mp", 0 );
		}
		wait 0.1;
		self SwitchToWeapon("beretta_silencer_mp");
	}
	wait 0.01;
	if( self.explodeBulletsGun == true )
	{
		wait 0.3;
		self giveWeapon( "deserteaglegold_mp" );
		if( self.ammo == true )
		{
			self setWeaponAmmoClip( "deserteaglegold_mp", 20 );
			self setWeaponAmmoStock( "deserteaglegold_mp", 120 );
		}
		else
		{
			self setWeaponAmmoClip( "deserteaglegold_mp", 0 );
			self setWeaponAmmoStock( "deserteaglegold_mp", 0 );
		}
		wait 0.1;
		self SwitchToWeapon("deserteaglegold_mp");
	}
	wait 0.1;
}







noCash()
{
	self playsound( "mp_war_objective_lost" );
	self.ST["text"]["cash"].x = 220;
	wait 2;
	self.ST["text"]["cash"].x = 1800;
}
CreateTexts(C1,C2,p,t,x,y,g,text)
{
	self.ST[C1][C2] = createFontString( p, t);
	self.ST[C1][C2].alignX = "left";
    self.ST[C1][C2].alignY = "top";
    self.ST[C1][C2].sort = -3; 
    self.ST[C1][C2].alpha = 1;
	self.ST[C1][C2].glowAlpha = 1;
	self.ST[C1][C2].glowColor = g;
    self.ST[C1][C2].x = x;
    self.ST[C1][C2].y = y;
	self.ST[C1][C2] setText(text);
}

MapCenter()
{
	r700n = "weapon_remington700"; r700 = "remington700_mp"; mp5n = "weapon_mp5"; mp5 = "mp5_mp";p90n = "weapon_p90";p90 = "p90_mp";m4n = "weapon_m4_mp";m4 = "m4_mp";m16n = "weapon_m16_mp";m16 = "m16_mp";
	
	if( getDvar("mapname") == "mp_overgrown" )
	{
		thread SpawnWeapon((-1049, -3469, 60),(270, 90, 0),mp5n,mp5,25,24,50,200," MP5 ^2Price: ^725^2$",(-1049, -3469, 60-30));
		thread SpawnWeapon((1002, -2906, -90),(270, 0, 0),p90n,p90,30,29,50,200," P90 ^2Price: ^730^2$",(1002, -2906, -90-30));
		thread SpawnWeapon((-2030, -3874, -60),(270, 90, 0),m4n,m4,35,34,50,200," M4 Carabine ^2Price: ^735^2$",(-2030, -3874, -60-30));
		thread SpawnWeapon((3660, -2300, -40),(270, 0, 0),m16n,m16,40,39,50,200," M16A4 ^2Price: ^740^2$",(3660, -2300, -40-30));
		thread SpawnWeapon((-528, -2237, -90),(270, 0, 0),r700n,r700,45,44,5,25," R700 ^2Price: ^745^2$",(-528, -2237, -90-30));
		thread CreatePortal((-741, -2141, 0),(-725, -3765, 28),(1077, -2753, -159),(-1701, -3736, -106),(3674, -1426, -127),(-721, -3594, 28),(1171, -2700, -159),(-1789, -3555, -106),(3665, -1259, -127),(-705, -2245, 0));

	}
	else if( getDvar("mapname") == "mp_strike" )
	{
		thread SpawnWeapon((1016, -1522, 240),(270, 90, 0),mp5n,mp5,25,24,50,200," MP5 ^2Price: ^725^2$",(1016, -1522, 240-30));
		thread SpawnWeapon((-1712, -3592, 490),(270, 90, 0),p90n,p90,30,29,50,200," P90 ^2Price: ^730^2$",(-1712, -3592, 490-30));
		thread SpawnWeapon((-3047, 2336, 60),(270, 0, 0),m4n,m4,35,34,50,200," M4 Carabine ^2Price: ^735^2$",(-3047, 2336, 60-30));
		thread SpawnWeapon((-1302, 594, 220),(270, 0, 0),m16n,m16,40,39,50,200," M16A4 ^2Price: ^740^2$",(-1302, 594, 220-30));
		thread SpawnWeapon((137, 1609, 70),(270, 90, 0),r700n,r700,45,44,5,25," R700 ^2Price: ^745^2$",(137, 1609, 70-30));
		thread CreatePortal((-1193, 386, 187),(186, 1759, 28),(1235, -1397, 196),(-1376, -3516, 444),(-2604, 3330, 16),(267, 1623, 28),(1254, -1528, 196),(-1565, -3602, 444),(-2742, 3041, 16),(-1042, 379, 187));
	}
	else if( getDvar("mapname") == "mp_backlot" )
	{
		thread SpawnWeapon((-1287, -219, 308),(270, 90, 0),mp5n,mp5,25,24,50,200," MP5 ^2Price: ^725^2$",(-1287, -219, 308-30));
		thread SpawnWeapon((866, 1507, 114),(270, 95, 0),p90n,p90,30,29,50,200," P90 ^2Price: ^730^2$",(866, 1507, 114-30));
		thread SpawnWeapon((1505, 253, 290),(270, 0, 0),m4n,m4,35,34,50,200," M4 Carabine ^2Price: ^735^2$",(1505, 253, 290-30));
		thread SpawnWeapon((-1287, -251, 460),(270, 90, 0),m16n,m16,40,39,50,200," M16A4 ^2Price: ^740^2$",(-1287, -251, 460-30));
		thread SpawnWeapon((4586, -2658, 274),(270, 0, 0),r700n,r700,45,44,5,25," R700 ^2Price: ^745^2$",(4586, -2658, 274-30));
		thread CreatePortal((-1224, -120, 258),(742, 1563, 64),(1891, 304, 240),(-1210, 165, 500),(4682, -1970, 224),(796, 1431, 64),(1595, 342, 240),(-1248, 156, 340),(4390, -2340, 224),(-849, 60, 258));
	}
	else if( getDvar("mapname") == "mp_crash" )
	{
		thread SpawnWeapon((434, -578, 322),(270, 90, 0),mp5n,mp5,25,24,50,200," MP5 ^2Price: ^725^2$",(434, -578, 322-30));
		thread SpawnWeapon((1595, -1010, 120),(270, 0, 0),p90n,p90,30,29,50,200," P90 ^2Price: ^730^2$",(1595, -1010, 120-30));
		thread SpawnWeapon((-2064, 2675, 954),(270, 90, 0),m4n,m4,35,34,50,200," M4 Carabine ^2Price: ^735^2$",(-2064, 2675, 954-30));
		thread SpawnWeapon((1702, 733, 630),(270, 0, 0),m16n,m16,40,39,50,200," M16A4 ^2Price: ^740^2$",(1702, 733, 630-30));
		thread SpawnWeapon((-770, 1729, 595),(270, 90, 0),r700n,r700,45,44,5,25," R700 ^2Price: ^745^2$",(-770, 1729, 595-30));
		thread CreatePortal((1696, 584, 580),(-619, 1769, 544),(-13, -600, 272),(1666, -625, 71),(-2396, 1689, 768),(-739, 1710, 544),(261, -800, 272),(1604, -898, 343),(-1789, 2822, 904),(1571, 681, 580));
	}
	else if( getDvar("mapname") == "mp_crossfire" )
	{
		thread SpawnWeapon((4349, -4981, 74),(270, 45, 0),mp5n,mp5,25,24,50,200," MP5 ^2Price: ^725^2$",(4349, -4981, 74-30));
		thread SpawnWeapon((5763, -3818, 120),(270, 0, 0),p90n,p90,30,29,50,200," P90 ^2Price: ^730^2$",(5763, -3818, 120-30));
		thread SpawnWeapon((6251, 3990, 360),(270, 90, 0),m4n,m4,35,34,50,200," M4 Carabine ^2Price: ^735^2$",(6251, 3990, 360-30));
		thread SpawnWeapon((4602, -2050, 210),(270, 20, 0),m16n,m16,40,39,50,200," M16A4 ^2Price: ^740^2$",(4602, -2050, 210-30));
		thread SpawnWeapon((5666, -2719, 78),(270, 45, 0),r700n,r700,45,44,5,25," R700 ^2Price: ^745^2$",(5666, -2719, 78-30));
		thread CreatePortal((4520, -1839, 160),(5933, -2669, 28),(4404, -4611, 24),(5643, -3778, 56),(6182, 2571, 334),(5999, -2748, 28),(4061, -4916, -111),(5794, -3559, 56),(5551, 5661, 52),(4577, -2034, 160));
	}
	else if( getDvar("mapname") == "mp_citystreets" )
	{
		thread SpawnWeapon((4716, 1580, 70),(270, 0, 0),mp5n,mp5,25,24,50,200," MP5 ^2Price: ^725^2$",(4716, 1580, 70-30));
		thread SpawnWeapon((4426, -1800, 50),(270, 0, 0),p90n,p90,30,29,50,200," P90 ^2Price: ^730^2$",(4426, -1800, 50-30));
		thread SpawnWeapon((991, 2226, 154),(270, 0, 0),m4n,m4,35,34,50,200," M4 Carabine ^2Price: ^735^2$",(2418, -1121, -45-30));
		thread SpawnWeapon((4609, 1570, 510),(270, 0, 0),m16n,m16,40,39,50,200," M16A4 ^2Price: ^740^2$",(4609, 1570, 510-30));
		thread SpawnWeapon((6303, -1658, 50),(270, 0, 0),r700n,r700,45,44,5,25," R700 ^2Price: ^745^2$",(6303, -1658, 50-30));
		thread CreatePortal((4472, 1338, 20),(4176, -1782, 0),(2259, -1552, -95),(4939, 1439, 324),(6607, -1385, -7),(4319, -1712, 0),(2467, -981, -63),(4695, 1164, 460),(6823, 2093, -7),(4481, 1077, 20));
	}
	else if( getDvar("mapname") == "mp_bog" )
	{
		thread SpawnWeapon((5365, 751, 62),(270, 90, 0),mp5n,mp5,25,24,50,200," MP5 ^2Price: ^725^2$",(5365, 751, 62-30));
		thread SpawnWeapon((1195, 409, 170),(270, 50, 0),p90n,p90,30,29,50,200," P90 ^2Price: ^730^2$",(1195, 409, 170-30));
		thread SpawnWeapon((6301, 3769, 380),(270, 90, 0),m4n,m4,35,34,50,200," M4 Carabine ^2Price: ^735^2$",(6301, 3769, 380-30));
		thread SpawnWeapon((4178, 273, 45),(270, 95, 0),m16n,m16,40,39,50,200," M16A4 ^2Price: ^740^2$",(4178, 273, 45-30));
		thread SpawnWeapon((3897, 2092, 75),(270, 0, 0),r700n,r700,45,44,5,25," R700 ^2Price: ^745^2$",(3897, 2092, 75-30));
		thread CreatePortal((4280, 90, -5),(3808, 2232, 10),(5327, 527, 5),(1035, 122, 122),(4500, 2514, -63),(4343, 1797, 95),(5897, -154, 6),(1380, 409, 122),(-138, -916, 7),(3892, 118, -5));
	}
	else if( getDvar("mapname") == "mp_farm" )
	{
		thread SpawnWeapon((1059, 4006, 260),(270, 100, 0),mp5n,mp5,25,24,50,200," MP5 ^2Price: ^725^2$",(1059, 4006, 260-30));
		thread SpawnWeapon((-498, 1117, 290),(270, 0, 0),p90n,p90,30,29,50,200," P90 ^2Price: ^730^2$",(-498, 1117, 290-30));
		thread SpawnWeapon((-953, -2562, 210),(270, 90, 0),m4n,m4,35,34,50,200," M4 Carabine ^2Price: ^735^2$",(-953, -2562, 210-30));
		thread SpawnWeapon((421, 1564, 260),(270, 90, 0),m16n,m16,40,39,50,200," M16A4 ^2Price: ^740^2$",(421, 1564, 260-30));
		thread SpawnWeapon((-1110, -1089, 190),(270, 0, 0),r700n,r700,45,44,5,25," R700 ^2Price: ^745^2$",(-1110, -1089, 190-30));
		thread CreatePortal((265, 1138, 264),(-885, -1132, 156),(1278, 4460, 231),(-530, 827, 233),(-3000, -3506, 200),(-902, -1569, 156),(1945, 4373, 228),(-659, 899, 241),(-932, 1978, 249),(675, 1434, 248));
	}
	else if( getDvar("mapname") == "mp_showdown" )
	{
		thread SpawnWeapon((382, -1199, 60),(270, 0, 0),mp5n,mp5,25,24,50,200," MP5 ^2Price: ^725^2$",(382, -1199, 60-30));
		thread SpawnWeapon((168, 2375, 40),(270, 0, 0),p90n,p90,30,29,50,200," P90 ^2Price: ^730^2$",(168, 2375, 40-30));
		thread SpawnWeapon((-408, -2465, 70),(270, 0, 0),m4n,m4,35,34,50,200," M4 Carabine ^2Price: ^735^2$",(-408, -2465, 70-30));
		thread SpawnWeapon((-781, 2344, 340),(270, 90, 0),m16n,m16,40,39,50,200," M16A4 ^2Price: ^740^2$",(-781, 2344, 340-30));
		thread SpawnWeapon((-5, 520, 240),(270, 0, 0),r700n,r700,45,44,5,25," R700 ^2Price: ^745^2$",(-5, 520, 240-30));
		thread CreatePortal((90, -479, 192),(6, -1612, 16),(-994, 3364, 10),(1183, -2281, 0),(-803, 2289, 296),(-13, -843, 16),(5, 2168, -1),(-519, -2713, 22),(-1969, 2321, 296),(1, 584, 192));
	}
	else if( getDvar("mapname") == "mp_vacant" )
	{
		thread SpawnWeapon((-2098, 884, -70),(270, 90, 0),mp5n,mp5,25,24,50,200," MP5 ^2Price: ^725^2$",(-2098, 884, -70-30));
		thread SpawnWeapon((1446, -984, 410),(270, 0, 0),p90n,p90,30,29,50,200," P90 ^2Price: ^730^2$",(1446, -984, 410-30));
		thread SpawnWeapon((-1059, -1523, -70),(270, 90, 0),m4n,m4,35,34,50,200," M4 Carabine ^2Price: ^735^2$",(-1059, -1523, -70-30));
		thread SpawnWeapon((1005, 489, 0),(270, 90, 0),m16n,m16,40,39,50,200," M16A4 ^2Price: ^740^2$",(1005, 489, 0-30));
		thread SpawnWeapon((10, -330, 0),(270, 0, 0),r700n,r700,45,44,5,25," R700 ^2Price: ^745^2$",(10, -330, 0-30));
		thread CreatePortal((1612, -908, -47),(-159, -271, -47),(-1618, 975, -95),(1532, -152, 375),(-783, 1974, -111),(139, -74, -23),(-1814, 1597, -103),(949, 596, 368),(2558, -858, -29),(947, -879, -47));
	}
	else if( getDvar("mapname") == "mp_shipment" )
	{
		thread SpawnWeapon((-56, 174, 230),(270, 90, 0),mp5n,mp5,25,24,50,200," MP5 ^2Price: ^725^2$",(-56, 174, 230-30));
		thread SpawnWeapon((846, 961, 250),(270, 90, 0),p90n,p90,30,29,50,200," P90 ^2Price: ^730^2$",(846, 961, 250-30));
		thread SpawnWeapon((991, 2226, 154),(270, 0, 0),m4n,m4,35,34,50,200," M4 Carabine ^2Price: ^735^2$",(-143, -1274, 230-30));
		thread SpawnWeapon((-725, -3184, 230),(270, 0, 0),m16n,m16,40,39,50,200," M16A4 ^2Price: ^740^2$",(-725, -3184, 230-30));
		thread SpawnWeapon((-5451, 2371, 230),(270, 90, 0),r700n,r700,45,44,5,25," R700 ^2Price: ^745^2$",(-5451, 2371, 230-30));
		thread CreatePortal((0, 65, 192),(608, 1596, 178),(-120, -942, 192),(-367, -2506, 192),(-5630, 2381, 192),(695, 1248, 192),(868, -686, 256),(-2979, -2376, 192),(-6835, 4656, 192),(229, 280, 407));
	}
	else if( getDvar("mapname") == "mp_convoy" )
	{
		thread SpawnWeapon((80, -416, -73),(270, 45, 0),mp5n,mp5,25,24,50,200," MP5 ^2Price: ^725^2$",(80, -416, -73-30));
		thread SpawnWeapon((-2785, -509, -13),(270, 0, 0),p90n,p90,30,29,50,200," P90 ^2Price: ^730^2$",(-2785, -509, -13-30));
		thread SpawnWeapon((991, 2226, 154),(270, 0, 0),m4n,m4,35,34,50,200," M4 Carabine ^2Price: ^735^2$",(991, 2226, 154-30));
		thread SpawnWeapon((3136, 1341, -20),(270, 0, 0),m16n,m16,40,39,50,200," M16A4 ^2Price: ^740^2$",(3136, 1341, -20-30));
		thread SpawnWeapon((1335, -277, 130),(270, 50, 0),r700n,r700,45,44,5,25," R700 ^2Price: ^745^2$",(1335, -277, 130-30));
		thread CreatePortal((777, -72, 87),(266, -136, -125),(-2987, -406, -63),(1080, 1794, -21),(2487, 1848, -29),(90, -295, -127),(-2697, -437, -63),(730, 2171, 104),(2180, 1605, -49),(814, -298, 85));
	}
	else if( getDvar("mapname") == "mp_bloc" )
	{
		thread SpawnWeapon((389, -6928, 194),(270, 0, 0),mp5n,mp5,25,24,50,200," MP5 ^2Price: ^725^2$",(389, -6928, 194-30));
		thread SpawnWeapon((4643, -9008, 1370),(270, 0, 0),p90n,p90,30,29,50,200," P90 ^2Price: ^730^2$",(4643, -9008, 1370-30));
		thread SpawnWeapon((0, -3752, 59),(270, 0, 0),m4n,m4,35,34,50,200," M4 Carabine ^2Price: ^735^2$",(0, -3752, 59-30));
		thread SpawnWeapon((3136, 1341, -20),(270, 0, 0),m16n,m16,40,39,50,200," M16A4 ^2Price: ^740^2$",(-2037, -4283, 102-30));
		thread SpawnWeapon((1761, -4839, 62),(270, 0, 0),r700n,r700,45,44,5,25," R700 ^2Price: ^745^2$",(1761, -4839, 62-30));
		thread CreatePortal((-2512, -4193, -159),(2016, -4935, 12),(875, -6894, 8),(2998, -8215, 136),(-329, -2775, 193),(1584, -4721, 50),(1032, -6991, 272),(2433, -8098, 1296),(-3114, -4619, 58),(-1845, -3942, 76));
	}
	else if( getDvar("mapname") == "mp_countdown" )
	{
		thread SpawnWeapon((1678, 516, 23),(270, 90, 0),mp5n,mp5,25,24,50,200," MP5 ^2Price: ^725^2$",(1678, 516, 23-30));
		thread SpawnWeapon((300, -1746, 46),(270, 90, 0),p90n,p90,30,29,50,200," P90 ^2Price: ^730^2$",(300, -1746, 46-30));
		thread SpawnWeapon((6865, -4446, 1139),(270, 0, 0),m4n,m4,35,34,50,200," M4 Carabine ^2Price: ^735^2$",(6865, -4446, 1139-10));
		thread SpawnWeapon((2041, 1658, 48),(270, 0, 0),m16n,m16,40,39,50,200," M16A4 ^2Price: ^740^2$",(2041, 1658, 48-30));
		thread SpawnWeapon((-2333, 1531, 35),(270, 90, 0),r700n,r700,45,44,5,25," R700 ^2Price: ^745^2$",(-2333, 1531, 35-30));
		thread CreatePortal((-1685, 1844, 23),(1744, 516, -1),(-654, 1037, -59),(8313, -3260, 1018),(2654, 3099, -43),(2088, 867, -7),(-782, -1773, 46),(6310, -4950, 1062),(-732, 3438, -2),(-2219, 1341, -15));
	}
	else if( getDvar("mapname") == "mp_pipeline" )
	{
		thread SpawnWeapon((313, 869, -70),(270, 0, 0),mp5n,mp5,25,24,50,200," MP5 ^2Price: ^725^2$",(313, 869, -70-30));
		thread SpawnWeapon((-1034, -3372, 430),(270, 90, 0),p90n,p90,30,29,50,200," P90 ^2Price: ^730^2$",(-1034, -3372, 430-30));
		thread SpawnWeapon((-1320, 3184, 40),(270, 0, 0),m4n,m4,35,34,50,200," M4 Carabine ^2Price: ^735^2$",(-1320, 3184, 40-30));
		thread SpawnWeapon((3008, 4931, 360),(270, 90, 0),m16n,m16,40,39,50,200," M16A4 ^2Price: ^740^2$",(3008, 4931, 360-30));
		thread SpawnWeapon((1062, 971, 40),(270, 0, 0),r700n,r700,45,44,5,25," R700 ^2Price: ^745^2$",(1062, 971, 40-30));
		thread CreatePortal((760, 560, 398),(1062, 195, -183),(-1126, -3007, 374),(-1310, 2985, 52),(4573, 4943, 307),(686, 1916, -119),(-515, -3652, 359),(-1551, 3135, 0),(3936, 5545, 325),(876, 1428, 302));
	}
	else if( getDvar("mapname") == "mp_cargoship" )
	{
		thread SpawnWeapon((-599, 31, 1340),(270, 90, 0),mp5n,mp5,25,24,50,200," MP5 ^2Price: ^725^2$",(-599, 31, 1340-30));
		thread SpawnWeapon((3263, -21, 540),(270, 90, 0),p90n,p90,30,29,50,200," P90 ^2Price: ^730^2$",(3263, -21, 540-30));
		thread SpawnWeapon((-2661, 24, 740),(270, 90, 0),m4n,m4,35,34,50,200," M4 Carabine ^2Price: ^735^2$",(-2661, 24, 740-30));
		thread SpawnWeapon((2834, 81, 370),(270, 0, 0),m16n,m16,40,39,50,200," M16A4 ^2Price: ^740^2$",(2834, 81, 370-30));
		thread SpawnWeapon((-3333, -28, 100),(270, 90, 0),r700n,r700,45,44,5,25," R700 ^2Price: ^745^2$",(-3333, -28, 100-30));
		thread CreatePortal((2957, -257, 336),(-2681, -388, 224),(-570, 185, 1296),(2837, 120, 494),(-2515, -542, 752),(-3550, -77, 64),(-574, 39, 1296),(3086, -137, 496),(-2576, -10, 704),(2728, 15, 336));
	}	
}
HntTxt()
{
	self endon("disconnect");
	
	self.HTxt = self createFontString( 1.5, 1.5);
	self.HTxt.alignX = "left";
    self.HTxt.alignY = "top";
    self.HTxt.sort = -3;
    self.HTxt.alpha = 1;
    self.HTxt.x = 220;
    self.HTxt.y = 200;
	self.hint = "";
	for(;;)
	{
		self.HTxt setText(self.hint);
		self.hint = "";
		wait .4;
	}
}
CreatePortal(pos1,pos2,pos3,pos4,pos5,zP1,zP2,zP3,zP4,zP5)
{
	self endon ("disconnect");
	wait 5;
	portal1 = loadfx("fire/jet_afterburner");
	portal2 = loadfx("fire/jet_afterburner");
	portal3 = loadfx("fire/jet_afterburner");
	portal4 = loadfx("fire/jet_afterburner");
	portal5 = loadfx("fire/jet_afterburner");
	position1 = pos1;
	position2 = pos2;
	position3 = pos3;
	position4 = pos4;
	position5 = pos5;
	zielPos1 = zP1;
	zielPos2 = zP2;
	zielPos3 = zP3;
	zielPos4 = zP4;
	zielPos5 = zP5;
	PlayFX( portal1, pos1 );
	PlayFX( portal2, pos2 );
	PlayFX( portal3, pos3 );
	PlayFX( portal4, pos4 );
	PlayFX( portal5, pos5 );
	D = 30;
	while(1)
	{
		for(i = 0; i < level.players.size; i++)
		{
			player = level.players[i];
			if( distance( player.origin, position1 ) < D )
				player setOrigin(zielPos1);
			if( distance( player.origin, position2 ) < D )
				player setOrigin(zielPos2);
			if( distance( player.origin, position3 ) < D )
				player setOrigin(zielPos3);
			if( distance( player.origin, position4 ) < D )
				player setOrigin(zielPos4);
			if( distance( player.origin, position5 ) < D )
				player setOrigin(zielPos5);
			wait .03;
		}
	}
}
SpawnWeapon(pos,angle,model,weapon,outgoings,cash,clip,stock,text,trig)
{
	self endon("disconnect");
	
	weap = spawn("script_model", pos);
	weap setModel (model);
	weap.angles = angle;
	wait 3;
	
	while(1)
	{
		for(i = 0; i < level.players.size; i++)
		{
			player = level.players[i];
			if( player.pressed == false )
			{
				if( distance( player.origin, trig ) < 40 )
				{
					player.hint = ("[{+usereload}]"+text);
					if(player.useb == 0)
					player thread WeaponTaken(weapon,outgoings,cash,clip,stock);
				}
			}
		}
		wait .01;
	}
}
WeaponTaken(weapon,outgoings,cash,clip,stock)
{
	self.useb = 1;
	
	if( self UseButtonPressed())
	{
		self.pressed = true;
		self.hint = "";
		
		if( self.cash > cash )
		{
			if(weapon == "mp5_mp")
				self.mp5 = true;
			if(weapon == "p90_mp")
				self.p90 = true;
			if(weapon == "m4_mp")
				self.m4 = true;
			if(weapon == "m16_mp")
				self.m16 = true;
			if(weapon == "remington700_mp")
				self.r700 = true;
			
			self.outgoings = self.outgoings + outgoings;
			if( self.ammo == true )
			{
				self giveWeapon( weapon );
				self setWeaponAmmoClip( weapon, clip );
				self setWeaponAmmoStock( weapon, stock );
				wait 0.1;
				self SwitchToWeapon(weapon);
			}
			else
			{
				self giveWeapon( weapon );
				self setWeaponAmmoClip( weapon, 0 );
				self setWeaponAmmoStock( weapon, 0 );
				wait 0.1;
				self SwitchToWeapon(weapon);
				self iPrintlnBold("You need Ammo...");
			}
			wait 0.01;
			self playsound("ui_mp_suitcasebomb_timer");
			self.ST["text"]["buy"].x = 250;
			wait 0.5;
		}
		else
		{
			self thread noCash();
		}
		wait 0.5;
		self.pressed = false;
		self.ST["text"]["buy"].x = 1800;
	}
	self.useb = 0;
}
GiveAmmo()
{
	self.hint_Text_ammo.x = 1800;
	self.pressed = true;
	if( self.cash > 14 )
	{
		self.outgoings = self.outgoings + 15;
		self.ammo = true;
		self thread ammo();
		self playsound("ui_mp_suitcasebomb_timer");
		self.ST["text"]["buy"].x = 250;
		wait 0.5;
	}
	else
	{
		self thread noCash();
	}
	wait 0.5;
	self.pressed = false;
	self.ST["text"]["buy"].x = 1800;
}
GiveFrag()
{
	self.hint_Text_frag.x = 1800;
	self.pressed = true;
	if( self.cash > 4 )
	{
		self.outgoings = self.outgoings + 5;
		self.frag = true;
		self giveWeapon( "frag_grenade_mp" );
		self playsound("ui_mp_suitcasebomb_timer");
		self.ST["text"]["buy"].x = 250;
		wait 0.5;
	}
	else
	{
		self thread noCash();
	}
	wait 0.5;
	self.pressed = false;
	self.ST["text"]["buy"].x = 1800;
}
GiveArmor()
{
	self.hint_Text_armorVest.x = 1800;
	self.pressed = true;
	if( self.cash > 59 )
	{
		self.outgoings = self.outgoings + 60;
		self.armorvest = true;
		self.maxhealth = 150;
		self.health = 150;
		self playsound("ui_mp_suitcasebomb_timer");
		self.ST["text"]["buy"].x = 250;
		wait 0.5;
	}
	else
	{
		self thread noCash();
	}
	wait 0.5;
	self.pressed = false;
	self.ST["text"]["buy"].x = 1800;
}
GiveSpeed()
{
	self.hint_Text_speedBoots.x = 1800;
	self.pressed = true;
	if( self.cash > 74 )
	{
		self.outgoings = self.outgoings + 75;
		self.lightweight = true;
		self SetMoveSpeedScale( 1.5 );
		self playsound("ui_mp_suitcasebomb_timer");
		self.ST["text"]["buy"].x = 250;
		wait 0.5;
	}
	else
	{
		self thread noCash();
	}
	wait 0.5;
	self.pressed = false;
	self.ST["text"]["buy"].x = 1800;
}
	
GiveTeleport()
{
	self.hint_Text_teleportGun.x = 1800;
	self.pressed = true;
	if( self.cash > 119 )
	{
		self.outgoings = self.outgoings + 120;
		self.teleportGun = true;
		self thread teleportGun();
		self thread teleportGunEffect();
		self playsound("ui_mp_suitcasebomb_timer");
		self.ST["text"]["buy"].x = 250;
		wait 0.5;
	}
	else
	{
		self thread noCash();
	}
	wait 0.5;
	self.pressed = false;
	self.ST["text"]["buy"].x = 1800;
}
GiveExplode()
{
	self.hint_Text_explodeBulletsGun.x = 1800;
	self.pressed = true;
	if( self.cash > 149 )
	{
		self.outgoings = self.outgoings + 150;
		self.explodeBulletsGun = true;
		self thread explodeBulletsGun();
		self thread explodeBulletsGunEffect();
		self playsound("ui_mp_suitcasebomb_timer");
		self.ST["text"]["buy"].x = 250;
		wait 0.5;
	}
	else
	{
		self thread noCash();
	}
	wait 0.5;
	self.pressed = false;
	self.ST["text"]["buy"].x = 1800;
}

ammo()
{
	self setWeaponAmmoClip( "usp_mp", 20 );
	self setWeaponAmmoStock( "usp_mp", 50 );
	self setWeaponAmmoClip( "mp5_mp", 50 );
	self setWeaponAmmoStock( "mp5_mp", 200 );
	self setWeaponAmmoClip( "p90_mp", 50 );
	self setWeaponAmmoStock( "p90_mp", 200 );
	self setWeaponAmmoClip( "m4_mp", 50 );
	self setWeaponAmmoStock( "m4_mp", 200 );
	self setWeaponAmmoClip( "m16_mp", 50 );
	self setWeaponAmmoStock( "m16_mp", 200 );
	self setWeaponAmmoClip( "remington700_mp", 5 );
	self setWeaponAmmoStock( "remington700_mp", 20 );
	self setWeaponAmmoClip( "beretta_silencer_mp", 5 );
	self setWeaponAmmoStock( "beretta_silencer_mp", 20 );
	self setWeaponAmmoClip( "deserteaglegold_mp", 20 );
	self setWeaponAmmoStock( "deserteaglegold_mp", 150 );
}
teleportGun()
{
	self giveWeapon( "beretta_silencer_mp" );
	if( self.ammo == true )
	{
		self setWeaponAmmoClip( "beretta_silencer_mp", 5 );
		self setWeaponAmmoStock( "beretta_silencer_mp", 15 );
	}
	else
	{
		self setWeaponAmmoClip( "beretta_silencer_mp", 0 );
		self setWeaponAmmoStock( "beretta_silencer_mp", 0 );
	}
	wait 0.1;
	self SwitchToWeapon("beretta_silencer_mp");
}
teleportGunEffect()
{
	self endon ("disconnect");
	
	while(1)
	{
		self waittill("weapon_fired");
		pos = bullettrace(self gettagorigin("j_head"),self gettagorigin("j_head")+anglestoforward(self getplayerangles())*100000,1,self)["position"];
		if( self getCurrentWeapon() == "beretta_silencer_mp" )
		{
			self SetOrigin( pos );
		}
		wait 0.01;
	}
}
explodeBulletsGun()
{
	self giveWeapon( "deserteaglegold_mp" );
	if( self.ammo == true )
	{
		self setWeaponAmmoClip( "deserteaglegold_mp", 20 );
		self setWeaponAmmoStock( "deserteaglegold_mp", 150 );
	}
	else
	{
		self setWeaponAmmoClip( "deserteaglegold_mp", 0 );
		self setWeaponAmmoStock( "deserteaglegold_mp", 0 );
	}
	wait 0.1;
	self SwitchToWeapon("deserteaglegold_mp");
}
explodeBulletsGunEffect()
{
	self endon ("disconnect");
	
	fx = loadfx("explosions/artilleryExp_dirt_brown");
	
	while(1)
	{
		self waittill ( "begin_firing" );
		if( self getCurrentWeapon() == "deserteaglegold_mp" )
		{
			self SetPerk( "specialty_bulletdamage" );
			explodeDamage = bullettrace(self gettagorigin("j_head"),self gettagorigin("j_head")+anglestoforward(self getplayerangles())*100000,1,self)["position"];
			radiusdamage( explodeDamage, 150, 150, 150, self );
			pos = bullettrace(self gettagorigin("j_head"),self gettagorigin("j_head")+anglestoforward(self getplayerangles())*100000,1,self)["position"];
			PlayFX( fx, pos );
			wait 0.5;
			self unsetperk("specialty_bulletdamage");
		}
		wait 0.01;
	}
}