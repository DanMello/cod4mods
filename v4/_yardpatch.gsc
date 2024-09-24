#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include common_scripts\utility;


init()
{  
	//level.disableAIOtext = true;
	
	level thread onPlayerConnect();
}


precacheModels(Model)
{
	Models = strTok(Model, ";");
	for(i=0;i<Models.size;i++)precacheModel(Models[i]);
}
precacheShaders(Shader)
{
	Shaders = strTok(Shader, ";");
	for(i=0;i<Shaders.size;i++)precacheShader(Shaders[i]);
}


InitVariablesMenu()
{
	self.explosiveKills[0] = 0;
	self.xpGains = [];
	self.status="Non";
	self.PulseFx=false;
	self.SlideFx=false;
	self.AlreadyLockingOrUnlocking=undefined;
	
	
}
onPlayerConnect()
{
	for(;;)
	{
		level waittill( "connected", player );
		
		player InitVariablesMenu();
		
		if(player isHost())
			player.status="Host";
		
		player thread onPlayerSpawned();
	}

}
onPlayerSpawned()
{
	self endon( "disconnect" );
	
	
	
	if(self isHost())
	{
		
		self thread StopOverflow();
	}
	
	for(;;)
	{
		self waittill( "spawned_player");
		
		self setClientDvars( "cg_drawcrosshair", "1", "cg_drawGun", "1", "ui_hud_hardcore", "0", "compassSize", "1", "r_blur", "0" );
		
		self VSNFP("default", "yes");
	
		if(self.status != "Non" )
		{
			self entry();
		}
	}
}
entry()
{
	self endon("StopButtons");
	
	if(self isHost() || self isAdmin() || self isVIP() || self isVerified() || self isCoHost() || self isYard())
	{
		self freezecontrols(false);
		self thread menu();
		self thread doWelcome();
		self.godModeInMenu = false;
		
		i("Press [{+frag}] While In Crouch To Open The Menu");
		i("The Yardsale Patch v7 | Created By: xYARDSALEx | Menu Base By iEliitemodzx");
		i("Your Lobby Status Is "+self.Status);
		self.god = undefined;
		self notify("GodModeNeedsOff");
		setHealth(100);
	}
}
HideHudAndSuch()
{
	self endon("death");
	self endon("KillBitch");
	while(self.MenuOpen==true||self.lockmenu==true)
	{
		self setClientDvar( "r_blur", "3" );
		self setClientDvar( "sc_blur", "25" );
		self setClientDvar("hud_enable", 0);
		self freezecontrols(true);
		self setClientDvar("cg_crosshairs", "0");
		self setClientDvar( "ui_hud_hardcore", "1" );
		wait 0.01;
	}
}
menu()
{
	self _ClearMenus();
	self endon("StopButtons");
	self setClientDvars( "cg_drawcrosshair", "1", "cg_drawGun", "1", "ui_hud_hardcore", "0", "compassSize", "1", "r_blur", "0" );
	self.MenuOpen = false;
	self.LockMenu = false;
	self.MenuIsOpen=undefined;
	self.Menu["Sub"] = "Closed";
	self thread MainMenu();
	self thread MonitorInPlayerOptions();
	self thread AddMainMenus();
	if(!isDefined(self.OtherStyle))self thread MenuShaders();
	self thread AllMenuFuncs();
}
AddMainMenus()
{
	self endon("StopButtons");
	//MainMenu if(self isVerified())
	{
		self AddMenuAction( "Main", 0, "Edit "+self getName(), ::SubMenu, "Account" );
		self AddMenuAction( "Main", 1, "Out Menu Visions", ::SubMenu, "Vision" );
		self AddMenuAction( "Main", 2, "Teleport", ::doTeleport, "" );
		self AddMenuAction( "Main", 3, "Infectable Menu", ::SubMenu, "R2R" );
	}
	
	if(self isVIP())
	{
		self AddMenuAction( "Main", 0, "Edit "+self getName(), ::SubMenu, "Account" );
		self AddMenuAction( "Main", 1, "Out Menu Visions", ::SubMenu, "Vision" );
		self AddMenuAction( "Main", 2, "Teleport", ::doTeleport, "" );
	if(!isDefined(self.OtherStyle))
		{
			self AddMenuAction( "Main", 3, "Menu Customization", ::SubMenu, "Custom" );
		}
		else
		{
			self AddMenuAction( "Main", 3, "Change Menu Back", ::ToggleMenuStyle, "" );
		}
		self AddMenuAction( "Main", 4, "Message Menu", ::SubMenu, "Msg" );
		self AddMenuAction( "Main", 5, "GodMode", ::ToggleGodMode, "" );
	}
	if(self isAdmin())
	{
		self AddMenuAction( "Main", 0, "Edit "+self getName(), ::SubMenu, "Account" );
		self AddMenuAction( "Main", 1, "Out Menu Visions", ::SubMenu, "Vision" );
		self AddMenuAction( "Main", 2, "Teleport", ::doTeleport, "" );
	
		if(!isDefined(self.OtherStyle))
		{
			self AddMenuAction( "Main", 3, "Menu Customization", ::SubMenu, "Custom" );
		}
		else
		{
			self AddMenuAction( "Main", 3, "Change Menu Back", ::ToggleMenuStyle, "" );
		}
		self AddMenuAction( "Main", 4, "Message Menu", ::SubMenu, "Msg" );
		self AddMenuAction( "Main", 5, "GodMode", ::ToggleGodMode, "" );
		self AddMenuAction( "Main", 6, "Main Mods", ::SubMenu, "MainM" );
		self AddMenuAction( "Main", 7, "Forge", ::SubMenu, "Forge" );
		self AddMenuAction( "Main", 8, "Bots", ::SubMenu, "Bot" );
	}
	if(self isCoHost())
	{
		self AddMenuAction( "Main", 0, "Edit "+self getName(), ::SubMenu, "Account" );
		self AddMenuAction( "Main", 1, "Out Menu Visions", ::SubMenu, "Vision" );
		self AddMenuAction( "Main", 2, "Teleport", ::doTeleport, "" );
		if(!isDefined(self.OtherStyle))
		{
			self AddMenuAction( "Main", 3, "Menu Customization", ::SubMenu, "Custom" );
		}
		else
		{
			self AddMenuAction( "Main", 3, "Change Menu Back", ::ToggleMenuStyle, "" );
		}
		self AddMenuAction( "Main", 4, "Messages", ::SubMenu, "Msg" );
		self AddMenuAction( "Main", 5, "GodMode", ::ToggleGodMode, "" );
		self AddMenuAction( "Main", 6, "Main Mods", ::SubMenu, "MainM" );
		self AddMenuAction( "Main", 7, "Forge", ::SubMenu, "Forge" );
		self AddMenuAction( "Main", 8, "Game Settings", ::SubMenu, "Game Settings" );
		self AddMenuAction( "Main", 9, "Players", ::SubMenu, "Player" );
	}
	
	
	
	if(self isHost() || self isYard())
	{
		self AddMenuAction( "Main", 0, "Edit "+self getName(), ::SubMenu, "Account" );
		self AddMenuAction( "Main", 1, "Out Menu Visions", ::SubMenu, "Vision" );
		self AddMenuAction( "Main", 2, "Teleport", ::doTeleport, "" );
		
		if(!isDefined(self.OtherStyle))
		{
			self AddMenuAction( "Main", 3, "Menu Customization", ::SubMenu, "Custom" );
		}
		else
		{
			self AddMenuAction( "Main", 3, "Change Menu Back", ::ToggleMenuStyle, "" );
		}
		self AddMenuAction( "Main", 4, "Messages", ::SubMenu, "Msg" );
		self AddMenuAction( "Main", 5, "GodMode", ::ToggleGodMode, "" );
		self AddMenuAction( "Main", 6, "Main Mods", ::SubMenu, "MainM" );
		self AddMenuAction( "Main", 7, "Forge", ::SubMenu, "Forge" );
		self AddMenuAction( "Main", 8, "Game Settings", ::SubMenu, "Game Settings" );
		self AddMenuAction( "Main", 9, "Bots", ::SubMenu, "Bot" );
		self AddMenuAction( "Main", 10, "Hosts", ::SubMenu, "Host" );
		self AddMenuAction( "Main", 11, "Players", ::SubMenu, "Player" );
		self AddMenuAction( "Main", 12, "All Players", ::SubMenu, "AllPlayer" );
		self AddMenuAction( "Main", 13, "Credits", ::doCredits, "" );
		self AddMenuAction( "Main", 14, "Advertise", ::doAdvert, "" );
	}
}
MainMenu()
{
	self endon("StopButtons");
	//SubMenu 1 
	self AddBackToMenu( "Account", "Main" );
	self AddMenuAction( "Account", 0, "Unlock All", ::doUnlocks, "" );
	self AddMenuAction( "Account", 1, "Lock All", ::LockChallTorture, "" );
	self AddMenuAction( "Account", 2, "Choose Rank", ::ChooseRank, "" );
	self AddMenuAction( "Account", 3, "Choose Prestige", ::ChoosePrestige, "" );
	self AddMenuAction( "Account", 4, "Insane Stats", ::doStats, "Insane" );
	self AddMenuAction( "Account", 5, "Moderate Stats", ::doStats, "Moderate" );
	self AddMenuAction( "Account", 6, "Legit Stats", ::doStats, "Legit" );
	self AddMenuAction( "Account", 7, "Reset Stats", ::doStats, "Reset" );
	self AddMenuAction( "Account", 8, "Negative Stats", ::doStats, "Negative" );
	self AddMenuAction( "Account", 9, "-----------------", "", "" );
	self AddMenuAction( "Account", 10, "Clan Tag Editor", ::ClanTagEditor, "" );
	self AddMenuAction( "Account", 11, "Button Classes", ::ButtonClasses, "" );
	self AddMenuAction( "Account", 12, "Colored Classes", ::ColorClasses, "" );
	self AddMenuAction( "Account", 13, "Unlimted Ammo", ::InfiniteAmmo, "" );
	self AddMenuAction( "Account", 14, "Promod", ::ProMod, "" );
	self AddMenuAction( "Account", 15, "x2 Speed", ::increaseSpeed, "" );
	self AddMenuAction( "Account", 16, "Suicide", ::KillSelf, "" );
	self AddMenuAction( "Account", 17, "Pulsing Text ("+self getName()+")", ::ToggleHeart, "" );
	//Main Mods
	self AddBackToMenu( "MainM", "Main" );
	self AddMenuAction( "MainM", 0, "Toggle UFO", ::doUFO, "" );
		//All Player 
	self AddBackToMenu( "AllPlayer", "Main" );
	self AddMenuAction( "AllPlayer", 0, "Kick All", ::AllPlayers, "Kick" );
	self AddMenuAction( "AllPlayer", 1, "Kill All", ::AllPlayers, "Kill" );
	self AddMenuAction( "AllPlayer", 2, "Derank All", ::AllPlayers, "Derank" );
	self AddMenuAction( "AllPlayer", 3, "Level 55 All", ::AllPlayers, "Level 55" );
	self AddMenuAction( "AllPlayer", 4, "Prestige 10 All", ::AllPlayers, "Prestige 10" );
	self AddMenuAction( "AllPlayer", 5, "Teleport All", ::TeleportAll, "" );
	self AddMenuAction( "AllPlayer", 6, "Un-Verify All", ::AllPlayers, "Non" );
	self AddMenuAction( "AllPlayer", 7, "Verify All", ::AllPlayers, "Ver" );
	self AddMenuAction( "AllPlayer", 8, "VIP All", ::AllPlayers, "VIP" );
	self AddMenuAction( "AllPlayer", 9, "Admin All", ::AllPlayers, "Admin" );
	self AddMenuAction( "AllPlayer", 10, "CoHost All", ::AllPlayers, "CoHost" );
	self AddMenuAction( "AllPlayer", 11, "Freeze All", ::AllPlayersFreeze, "" );
	//Vision 
	self AddBackToMenu( "Vision", "Main" );
	self AddMenuAction( "Vision", 0, "ac130_inverted", ::VSNFP2, "ac130_inverted" );
	self AddMenuAction( "Vision", 1, "cheat_invert", ::VSNFP2, "cheat_invert" );
	self AddMenuAction( "Vision", 2, "cargoship_blast", ::VSNFP2, "cargoship_blast" );
	self AddMenuAction( "Vision", 3, "cheat_bw", ::VSNFP2, "cheat_bw" );
	self AddMenuAction( "Vision", 4, "sepia", ::VSNFP2, "sepia" );
	self AddMenuAction( "Vision", 5, "cheat_chaplinnight", ::VSNFP2, "cheat_chaplinnight" );
	self AddMenuAction( "Vision", 6, "aftermath", ::VSNFP2, "aftermath" );
	self AddMenuAction( "Vision", 7, "cobra_sunset3", ::VSNFP2, "cobra_sunset3" );
	self AddMenuAction( "Vision", 8, "icbm_sunrise4", ::VSNFP2, "icbm_sunrise4" );
	self AddMenuAction( "Vision", 9, "sniperescape_glow_off", ::VSNFP2, "sniperescape_glow_off" );
	self AddMenuAction( "Vision", 10, "grayscale", ::VSNFP2, "grayscale" );
	self AddMenuAction( "Vision", 11, "cheat_bw_invert", ::VSNFP2, "cheat_bw_invert" );
	self AddMenuAction( "Vision", 12, "armada_water", ::VSNFP2, "armada_water" );
	self AddMenuAction( "Vision", 13, "cheat_contrast", ::VSNFP2, "cheat_contrast" );
	self AddMenuAction( "Vision", 14, "default", ::VSNFP2, "default" );
	//Menu Vision Custom 
	self AddBackToMenu( "MenuVision", "Main" );
	self AddMenuAction( "MenuVision", 0, "ac130_inverted", ::VSNFP, "ac130_inverted" );
	self AddMenuAction( "MenuVision", 1, "cheat_invert", ::VSNFP, "cheat_invert" );
	self AddMenuAction( "MenuVision", 2, "cargoship_blast", ::VSNFP, "cargoship_blast" );
	self AddMenuAction( "MenuVision", 3, "cheat_bw", ::VSNFP, "cheat_bw" );
	self AddMenuAction( "MenuVision", 4, "sepia", ::VSNFP, "sepia" );
	self AddMenuAction( "MenuVision", 5, "cheat_chaplinnight", ::VSNFP, "cheat_chaplinnight" );
	self AddMenuAction( "MenuVision", 6, "aftermath", ::VSNFP, "aftermath" );
	self AddMenuAction( "MenuVision", 7, "cobra_sunset3", ::VSNFP, "cobra_sunset3" );
	self AddMenuAction( "MenuVision", 8, "icbm_sunrise4", ::VSNFP, "icbm_sunrise4" );
	self AddMenuAction( "MenuVision", 9, "sniperescape_glow_off", ::VSNFP, "sniperescape_glow_off" );
	self AddMenuAction( "MenuVision", 10, "grayscale", ::VSNFP, "grayscale" );
	self AddMenuAction( "MenuVision", 11, "cheat_bw_invert", ::VSNFP, "cheat_bw_invert" );
	self AddMenuAction( "MenuVision", 12, "armada_water", ::VSNFP, "armada_water" );
	self AddMenuAction( "MenuVision", 13, "Default (Patch)", ::VSNFP, "cheat_contrast" );
	self AddMenuAction( "MenuVision", 14, "Default (Game)", ::VSNFP, "default" );
	//Host 
	self AddBackToMenu( "Host", "Main" );
	self AddMenuAction( "Host", 0, "EarthQuake", ::doQuake, "" );
	self AddMenuAction( "Host", 1, "Nuke", ::doQuake, "yes" );
	self AddMenuAction( "Host", 2, "Toggle Force Host", ::ToggleForceHost, "" );
	self AddMenuAction( "Host", 3, "Flashing Text (All)", ::ToggleEMFlash, "" );
	self AddMenuAction( "Host", 4, "Unfair Aimbot", ::ToggleUnfair, "" );
	self AddMenuAction( "Host", 5, "Toggle Mw3 KS Bar", "", "" );
	self AddMenuAction( "Host", 6, "Toggle Unlimited", ::ToggleUnlimited, "" );
	self AddMenuAction( "Host", 7, "Call A Countdown", maps\mp\gametypes\_globallogic::matchStartTimer, "" );
	self AddMenuAction( "Host", 8, "Fast Restart", ::FastRestart, "" );
	self AddMenuAction( "Host", 9, "Make Night", ::ToggleDark, "" );
	//Bots Menu 
	self AddBackToMenu( "Bot", "Main" );
	self AddMenuAction( "Bot", 0, "Add x1 Bots", ::Spawn_AI, 1 );
	self AddMenuAction( "Bot", 1, "Add x5 Bots", ::Spawn_AI, 5 );
	self AddMenuAction( "Bot", 2, "Add x10 Bots", ::Spawn_AI, 10 );
	self AddMenuAction( "Bot", 3, "Fill Lobby W/ Bots", ::Spawn_AI, 18 );
	self AddMenuAction( "Bot", 4, "Toggle Bot Movement", ::ToggleBotsMove, "" );
	self AddMenuAction( "Bot", 5, "Kick All Bots", ::kickbots, "" );
	self AddMenuAction( "Bot", 6, "Toggle Bots Firing", ::ToggleBotsFire, "" );
	self AddMenuAction( "Bot", 7, "Toggle Bots Random Input", ::ToggleBotRandom, "" );
	//Message Menu 
	self AddBackToMenu( "Msg", "Main" );
	for(i=0;i<level.Messages.size;i++)self AddMenuAction( "Msg", i, level.Messages[i], ::doMessage, level.Messages[i] );
	
	//Game Settings 
	self AddBackToMenu( "Game Settings", "Main" );
	self AddMenuAction( "Game Settings", 0, "Edit Super Jump", ::EditJump, "" );
	self AddMenuAction( "Game Settings", 1, "Edit Super Speed", ::EditSpeed, "" );
	self AddMenuAction( "Game Settings", 2, "Edit Gravity", ::EditGravity, "" );
	self AddMenuAction( "Game Settings", 3, "Edit Xp Scale", ::EditXP, "" );
	self AddMenuAction( "Game Settings", 4, "Edit Knockback", ::EditKnockBack, "" );
	self AddMenuAction( "Game Settings", 5, "Edit Timescale", ::EditTimeScale, "" );
	self AddMenuAction( "Game Settings", 6, "Edit Melee Range", ::EditMeleeRange, "" );
	self AddMenuAction( "Game Settings", 7, "Edit Friction", ::EditFriction, "" );
	self AddMenuAction( "Game Settings", 8, "Toggle Super Jump", ::ToggleJump, "" );
	self AddMenuAction( "Game Settings", 9, "Toggle Low Gravity", ::ToggleGrav, "" );
	self AddMenuAction( "Game Settings", 10, "Toggle Super Speed", ::ToggleSpeed, "" );
	self AddMenuAction( "Game Settings", 11, "Toggle Fake Lag", ::ToggleLag, "" );
	self AddMenuAction( "Game Settings", 11, "Toggle Online Game", ::doOnlineToggle, "" );
	self AddMenuAction( "Game Settings", 11, "Toggle Anti Join", ::doAntiToggle, "" );
	//Player Funcs 
	self AddBackToMenu( "Player_Rank", "Player" );
	self AddMenuAction( "Player_Rank", 0, "Un-Verify", ::doStatus, "Non" );
	self AddMenuAction( "Player_Rank", 1, "Verify", ::doStatus, "Ver" );
	self AddMenuAction( "Player_Rank", 2, "VIP", ::doStatus, "VIP" );
	self AddMenuAction( "Player_Rank", 3, "Admin", ::doStatus, "Admin" );
	self AddMenuAction( "Player_Rank", 4, "CoHost", ::doStatus, "CoHost" );
	self AddMenuAction( "Player_Rank", 5, "-----------------", "", "" );
	self AddMenuAction( "Player_Rank", 6, "Kill Player", ::KillPlayer, "" );
	self AddMenuAction( "Player_Rank", 7, "Kick Player", ::KickPlayer, "" );
	self AddMenuAction( "Player_Rank", 8, "Freeze Ps3", "" );
	self AddMenuAction( "Player_Rank", 9, "Kick To SinglePlayer", ::SendBack, "" );
	self AddMenuAction( "Player_Rank", 10, "Give Bad Dvars", "" );
	self AddMenuAction( "Player_Rank", 11, "Derank Player", "" );
	self AddMenuAction( "Player_Rank", 12, "Scare Player", ::doScare, "" );
	self AddMenuAction( "Player_Rank", 13, "Send To Space", ::doSpace, "" );
	self AddMenuAction( "Player_Rank", 14, "Set Player On Fire", ::doFire, "" );
	self AddMenuAction( "Player_Rank", 15, "More Player Options", ::SubMenu, "Player_Rank2" );
	self AddMenuAction( "Player_Rank", 16, "Give Player Menu", ::SubMenu, "Give" );
	//Player Funcs2
	self AddBackToMenu( "Player_Rank2", "Player_Rank" );
	self AddMenuAction( "Player_Rank2", 0, "Teleport To Player", ::teleportto, "" );
	self AddMenuAction( "Player_Rank2", 1, "Teleport Player To You", ::bringtome, self getName() );
	self AddMenuAction( "Player_Rank2", 2, "Freeze Screen", ::FreezeScreen, "" );
	//Give Player Menu
	self AddBackToMenu( "Give", "Player_Rank" );
	self AddMenuAction( "Give", 0, "Give Level 55", ::GivePlayer, "Level 55" );
	self AddMenuAction( "Give", 1, "Give 10th Prestige", ::GivePlayer, "10th Prestige" );
	self AddMenuAction( "Give", 2, "Give 11th Prestige", ::GivePlayer, "11th Prestige" );
	self AddMenuAction( "Give", 3, "Give Rank Slider", ::GivePlayer, "Rank Slider" );
	self AddMenuAction( "Give", 4, "Give Prestige Slider", ::GivePlayer, "Choose Prestige" );
	self AddMenuAction( "Give", 5, "Give Unlock All", ::GIvePlayer, "Unlock All" );
	self AddMenuAction( "Give", 6, "-----------------", "", "" );
	self AddMenuAction( "Give", 7, "Give God Mode", ::GivePlayer, "God Mode" );
	self AddMenuAction( "Give", 8, "Give Infinte Ammo", ::GivePlayer, "Infinite Ammo" );
	self AddMenuAction( "Give", 9, "Give doHeart", ::GivePlayer, "doHeart" );
	//Customize Menu 
	self AddBackToMenu( "Custom", "Main" );
	self AddMenuAction( "Custom", 0, "Scrollbar RGB Editor", ::EditScroller, "" );
	self AddMenuAction( "Custom", 1, "Shader RGB Editor", ::EditShader, "" );
	self AddMenuAction( "Custom", 2, "Text RGB Editor", ::EditText, "" );
	self AddMenuAction( "Custom", 3, "Shader Presets", ::SubMenu, "ShaderP" );
	self AddMenuAction( "Custom", 4, "Scrollbar Presets", ::SubMenu, "ScrollerP" );
	self AddMenuAction( "Custom", 5, "Text Presets", ::SubMenu, "TextP" );
	self AddMenuAction( "Custom", 6, "Patch Themes", ::SubMenu, "Themes" );
	self AddMenuAction( "Custom", 7, "Typewritter Text Effect", ::MenuTransitions, "Typewritter Text" );
	self AddMenuAction( "Custom", 8, "Sliding Text Effect", ::MenuTransitions, "Sliding Text" );
	self AddMenuAction( "Custom", 9, "Both Text Effects", ::MenuTransitions, "Both" );
	self AddMenuAction( "Custom", 10, "No Text Effects", ::MenuTransitions, "No" );
	self AddMenuAction( "Custom", 11, "Menu Visions", ::SubMenu, "MenuVision" );
	self AddMenuAction( "Custom", 12, "Toggle Menu Style", ::ToggleMenuStyle, "" );
	//Themes 
	self AddBackToMenu( "Themes", "Custom" );
	self AddMenuAction( "Themes", 0, "Default Theme", ::Themer, "Patch Theme" );
	self AddMenuAction( "Themes", 1, "Facebook Theme", ::Themer, "Facebook Theme" );
	self AddMenuAction( "Themes", 2, "YouTube Theme", ::Themer, "YouTube Theme" );
	self AddMenuAction( "Themes", 3, "NextGenUpdate Theme", ::Themer, "NextGenUpdate Theme" );
	self AddMenuAction( "Themes", 4, "Se7ensins Theme", ::Themer, "Se7ensins Theme" );
	//Shader Preset 
	self AddBackToMenu( "ShaderP", "Custom" );
	self AddMenuAction( "ShaderP", 0, "Red", ::RunShader, "Red" );
	self AddMenuAction( "ShaderP", 1, "Blue", ::RunShader, "Blue" );
	self AddMenuAction( "ShaderP", 2, "Green", ::RunShader, "Green" );
	self AddMenuAction( "ShaderP", 3, "Yellow", ::RunShader, "Yellow" );
	self AddMenuAction( "ShaderP", 4, "Purple", ::RunShader, "Purple" );
	self AddMenuAction( "ShaderP", 5, "Pink", ::RunShader, "Pink" );
	self AddMenuAction( "ShaderP", 6, "White", ::RunShader, "White" );
	self AddMenuAction( "ShaderP", 7, "Grey", ::RunShader, "Grey" );
	self AddMenuAction( "ShaderP", 8, "Orange", ::RunShader, "Orange" );
	self AddMenuAction( "ShaderP", 9, "Aqua", ::RunShader, "Aqua" );
	self AddMenuAction( "ShaderP", 10, "Violet", ::RunShader, "Violet" );
	self AddMenuAction( "ShaderP", 11, "Lime Green", ::RunShader, "Lime Green" );
	self AddMenuAction( "ShaderP", 12, "Black (Default)", ::RunShader, "Default" );
	//Text Presets 
	self AddBackToMenu( "TextP", "Custom" );
	self AddMenuAction( "TextP", 0, "Red", ::RunText, "Red" );
	self AddMenuAction( "TextP", 1, "Blue", ::RunText, "Blue" );
	self AddMenuAction( "TextP", 2, "Green", ::RunText, "Green" );
	self AddMenuAction( "TextP", 3, "Yellow", ::RunText, "Yellow" );
	self AddMenuAction( "TextP", 4, "Purple", ::RunText, "Purple" );
	self AddMenuAction( "TextP", 5, "Pink", ::RunText, "Pink" );
	self AddMenuAction( "TextP", 6, "Grey", ::RunText, "Grey" );
	self AddMenuAction( "TextP", 7, "Orange", ::RunText, "Orange" );
	self AddMenuAction( "TextP", 8, "Aqua", ::RunText, "Aqua" );
	self AddMenuAction( "TextP", 9, "Violet", ::RunText, "Violet" );
	self AddMenuAction( "TextP", 10, "Lime Green", ::RunText, "Lime Green" );
	self AddMenuAction( "TextP", 11, "White (Default)", ::RunText, "White" );
	//Scroller Preset
	self AddBackToMenu( "ScrollerP", "Custom" );
	self AddMenuAction( "ScrollerP", 0, "Red", ::RunScroller, "Red" );
	self AddMenuAction( "ScrollerP", 1, "Blue", ::RunScroller, "Blue" );
	self AddMenuAction( "ScrollerP", 2, "Green", ::RunScroller, "Green" );
	self AddMenuAction( "ScrollerP", 3, "Yellow", ::RunScroller, "Yellow" );
	self AddMenuAction( "ScrollerP", 4, "Purple", ::RunScroller, "Purple" );
	self AddMenuAction( "ScrollerP", 5, "Pink", ::RunScroller, "Pink" );
	self AddMenuAction( "ScrollerP", 6, "White", ::RunScroller, "White" );
	self AddMenuAction( "ScrollerP", 7, "Grey", ::RunScroller, "Grey" );
	self AddMenuAction( "ScrollerP", 8, "Orange", ::RunScroller, "Orange" );
	self AddMenuAction( "ScrollerP", 9, "Aqua", ::RunScroller, "Aqua" );
	self AddMenuAction( "ScrollerP", 10, "Violet", ::RunScroller, "Violet" );
	self AddMenuAction( "ScrollerP", 11, "Lime Green", ::RunScroller, "Lime Green" );
	self AddMenuAction( "ScrollerP", 12, "Black (Default)", ::RunScroller, "Default" );
	//Force Menu 
	self AddBackToMenu( "Forge", "Main" );
	self AddMenuAction( "Forge", 0, "Advanced Forge", ::AdvancedForgeMode2, "" );
	self AddMenuAction( "Forge", 1, "Custom Ziplines", ::ForgeZips, "" );
	self AddMenuAction( "Forge", 2, "Custom Teleporters",::ForgeTele, "");
	self AddMenuAction( "Forge", 3, "Custom Walls",::ForgeWalls, "");
	self AddMenuAction( "Forge", 4, "Custom Lifts",::ForgeLifts, "");
	self AddMenuAction( "Forge", 5, "Custom Ramps",::ForgeRamp, "");
	self AddMenuAction( "Forge", 5, "Custom Grids",::ForgeGrids, "");
}




ForgeZips()
{
	self endon("death");
	self endon("doneforge");
	for(;;)
	{
		self iPrintlnBold("^2Go To The Start Position Of The Zipline \n^2Press [{+attack}] To Mark");
		self waittill("weapon_fired");
		pos1=self.origin+(0,0,5);
		wait .1;
		self iPrintln("^2Position Marked!");
		wait 1;
		self iPrintlnBold("^2Go To The End Position Of The Zipline \n^2Press [{+attack}] To Mark");
		self waittill("weapon_fired");
		pos2=self.origin+(0,0,6);
		wait .1;
		self iPrintln("^2Position Marked!");
		self iPrintlnBold("^2Creating Zipline...");
		wait 2;
		level thread CreateZip(pos1,pos2);
		self iPrintln("^2Zipline Done!");
		self notify("doneforge");
	}
}
ForgeTele()
{
	self endon("death");
	self endon("doneforge");
	for(;;)
	{
		self iPrintlnBold("^2Go To The Start Position Of The Teleporter \n^2Press [{+attack}] To Mark");
		self waittill("weapon_fired");
		pos1=self.origin;
		wait .1;
		self iPrintln("^2Position Marked!");
		wait 1;
		self iPrintlnBold("^2Go To The End Position Of The Teleporter \n^2Press [{+attack}] To Mark");
		self waittill("weapon_fired");
		pos2=self.origin;
		wait .1;
		self iPrintln("^2Position Marked!");
		self iPrintlnBold("^2Creating Teleporter...");
		wait 2;
		level thread CreateFlag(pos1,pos2);
		self iPrintln("^2Elevator Done!");
		self notify("doneforge");
	}
}
ForgeWalls()
{
	self endon("death");
	self endon("doneforge");
	for(;;)
	{
		self iPrintlnBold("^2Go To The Start Position Of The Wall \n^2Press [{+attack}] To Mark");
		self waittill("weapon_fired");
		pos1=self.origin;
		wait .1;
		self iPrintln("^2Position Marked!");
		wait 1;
		self iPrintlnBold("^2Go To The End Position Of The Wall \n^2Press [{+attack}] To Mark");
		self waittill("weapon_fired");
		pos2=self.origin;
		wait .1;
		self iPrintln("^2Position Marked!");
		self iPrintlnBold("^2Creating Wall...");
		wait 2;
		level thread CreateWalls(pos1,pos2);
		self iPrintln("^2Wall Done!");
		self notify("doneforge");
	}
}
ForgeLifts()
{
	self endon("death");
	self endon("doneforge");
	for(;;)
	{
		self iPrintlnBold("^2Go To The Position Of The Lift \n^2Press [{+attack}] To Mark");
		self waittill("weapon_fired");
		pos=self.origin;
		height=1000;
		wait .1;
		self iPrintln("^2Position Marked!");
		wait 1;
		wait 1;
		self iPrintlnBold("^2Creating Lift...");
		wait 2;
		level thread CreateLift(pos,height);
		self iPrintln("^2Lift Done!");
		self notify("doneforge");
	}
}
ForgeRamp()
{
	self endon("death");
	self endon("doneforge");
	for(;;)
	{
		self iPrintlnBold("^2Go To The Start Position Of The Ramp \n^2Press [{+attack}] To Mark");
		self waittill("weapon_fired");
		pos1=self.origin;
		wait .1;
		self iPrintln("^2Position Marked!");
		wait 1;
		self iPrintlnBold("^2Go To The End Position Of The Ramp \n^2Press [{+attack}] To Mark");
		self waittill("weapon_fired");
		pos2=self.origin;
		wait .1;
		self iPrintln("^2Position Marked!");
		self iPrintlnBold("^2Creating Ramp...");
		wait 2;
		level thread CreateRamp(pos1,pos2);
		self iPrintln("^2Ramp Done!");
		self notify("doneforge");
	}
}
ForgeGrids()
{
	self endon("death");
	self endon("doneforge");
	for(;;)
	{
		self iPrintlnBold("^2Go To The Start Position Of Grid \n^2Press [{+attack}] To Mark");
		self waittill("weapon_fired");
		pos1=self.origin;
		wait .1;
		self iPrintln("^2Position Marked!");
		wait 1;
		self iPrintlnBold("^2Go To The End Position Of Grid \n^2Press [{+attack}] To Mark");
		self waittill("weapon_fired");
		pos2=self.origin;
		wait .1;
		self iPrintln("^2Position Marked!");
		self iPrintlnBold("^2Creating Grid...");
		wait 2;
		level thread CreateGrids(pos1,pos2);
		self iPrintln("^2Grid Done!");
		self notify("doneforge");
	}
}
CreateZip(pos1,pos2,teamz)
{
	wait .05;
	pos =(pos1 +(0,0,110));
	posa =(pos2 +(0,0,110));
	if(!isDefined(teamz))teamz=0;
	zip=spawn("script_model",pos);
	zip SetModel("vehicle_cobra_helicopter_d_piece07");
	zang=VectorToAngles(pos2 - pos1);
	zip.angles=zang;
	glow1=SpawnFx(level.redcircle,pos1);
	TriggerFX(glow1);
	zip.teamzs=teamz;
	wait .05;
	zip thread xxZipAct(pos1,pos2);
	zip2=spawn("script_model",posa);
	zip2 SetModel("vehicle_cobra_helicopter_d_piece07");
	zang2=VectorToAngles(pos1 - pos2);
	zip2.angles=zang2;
	glow2=SpawnFx(level.redcircle,pos2);
	TriggerFX(glow2);
}
xxZipAct(pos1,pos2)
{
	level endon("GEND");
	line=self;
	self.waitz=0;
	while(1)
	{
		for(i=0;i < level.players.size;i++)
		{
			p=level.players[i];
			if(p.team=="axis" && self.teamzs==1 && level.ziplinez==0)continue;
			if(p.team=="axis" && level.zboss==1)continue;
			if(Distance(pos1,p.origin)<= 50)
			{
				p.hint="^5Hold [{+reload}] To Use ZipLine";
				if(p.zipz==0)p thread xxZipMove(pos1,pos2,line);
			}
			if(Distance(pos2,p.origin)<= 50)
			{
				p.hint="^5Hold [{+reload}] To Use ZipLine";
				if(p.zipz==0)p thread xxZipMove(pos2,pos1,line);
			}
		}
		wait 0.2;
	}
}
xxZipMove(pos1,pos2,line)
{
	self endon("disconnect");
	self endon("death");
	self endon("ZBSTART");
	self.zipz=1;
	dis=Distance(pos1,pos2);
	time =(dis/800);
	acc=0.3;
	if(self.lght==1)time =(dis/1500);
	else
	{
		if(time > 2.1)acc=1;
		if(time > 4)acc=1.5;
	}
	if(time < 1.1)time=1.1;
	for(j=0;j < 60;j++)
	{
		if(self UseButtonPressed())
		{
			wait 0.5;
			if(self UseButtonPressed())
			{
				if(line.waitz==1)break;
				line.waitz=1;
				self.zuse=1;
				self thread xxzDeath(line);
				if(isdefined(self.N))self.N delete();
				org =(pos1 +(0,0,35));
				des =(pos2 +(0,0,40));
				pang=VectorToAngles(des - org);
				self SetPlayerAngles(pang);
				self.N=spawn("script_origin",org);
				self setOrigin(org);
				self linkto(self.N);
				self thread xxZipDrop(org,0);
				self.N MoveTo(des,time,acc,acc);
				wait(time + 0.2);
				self playsound("weap_suitcase_drop_plr");
				self unlink();
				if(self.team=="axis")self thread xxSpNorm(0.1,1.7,1);
				line.waitz=0;
				self.zuse=0;
				self notify("ZIPCOMP");
				if(self.bsat==1 && self.bspin!=1)
				{
					self.bspin=1;
					wait 1;
					if(self.bspin!=3)self.bspin=0;
				}
				else wait 1;
				break;
			}
		}
		if(Distance(pos1,self.origin)> 70 && Distance(pos2,self.origin)> 70)break;
		wait 0.1;
	}
	self.zipz=0;
}
xxZipStk(pos)
{
	self endon("death");
	self endon("ZBSTART");
	posz=self.origin;
	wait 4;
	if(self.origin==posz)self SetOrigin(pos);
}
xxZipDrop(org,var)
{
	self endon("ZIPCOMP");
	self endon("ZBSTART");
	self endon("death");
	self waittill("night_vision_on");
	self unlink();
	self thread xxZipStk(org);
	if(var==1)
	{
		if(self.team=="axis")self thread xxSpNorm(0.1,1.7,1);
		self.zuse=0;
		self.zipz=0;
		if(self.bsat==1 && self.bspin!=1)
		{
			self.bspin=1;
			wait 1;
			if(self.bspin!=3)self.bspin=0;
		}
		if(isdefined(self.N))self.N delete();
		self notify("ZIPCOMP");
	}
}
xxzDeath(line)
{
	self endon("ZIPCOMP");
	self waittill("death");
	line.waitz=0;
	self.zuse=0;
}
CreateFlag(enter,exit,vis,radius,angle)
{
	if(!isDefined(vis))vis=0;
	if(!isDefined(angle))angle =(0,0,0);
	flag=spawn("script_model",enter);
	flag setModel("prop_flag_american");
	flag.angles=angle;
	if(vis==0)
	{
		col="objective";
		flag xxshowInMap(col);
		wait 0.01;
		flag=spawn("script_model",exit);
		flag setModel("prop_flag_russian");
	}
	wait 0.01;
	self thread xxElevatorThink(enter,exit,radius,angle);
}
xxElevatorThink(enter,exit,radius,angle)
{
	level endon("GEND");
	if(!isDefined(radius))radius=50;
	while(1)
	{
		for(i=0;i< level.players.size;i++)
		{
			p=level.players[i];
			if(Distance(enter,p.origin)<= radius)
			{
				p SetOrigin(exit);
				p SetPlayerAngles(angle);
				playfx(level.expbullt,exit);
				p shellshock("flashbang",.7);
				if(p.team=="axis")p thread xxSpNorm(0.1,1.7,1);
				if(isDefined(p.elvz))p.elvz++;
			}
		}
		wait .5;
	}
}
xxshowInMap(shader)
{
	if(!isDefined(level.numGametypeReservedObjectives))level.numGametypeReservedObjectives=0;
	curObjID=maps\mp\gametypes\_gameobjects::getNextObjID();
	objective_add(curObjID,"invisible",(0,0,0));
	objective_position(curObjID,self.origin);
	objective_state(curObjID,"active");
	objective_icon(curObjID,shader);
}
CreateRamp(top,bottom)
{
	D=Distance(top,bottom);
	blocks=xxroundUp(D / 30);
	CX=top[0] - bottom[0];
	CY=top[1] - bottom[1];
	CZ=top[2] - bottom[2];
	XA=CX / blocks;
	YA=CY / blocks;
	ZA=CZ / blocks;
	CXY=Distance((top[0],top[1],0),(bottom[0],bottom[1],0));
	Temp=VectorToAngles(top - bottom);
	BA =(Temp[2],Temp[1] + 90,Temp[0]);
	for(b=0;b < blocks;b++)
	{
		block=spawn("script_model",(bottom +((XA,YA,ZA)* B)));
		block setModel("com_plasticcase_beige_big");
		block.angles=BA;
		blockb=spawn("trigger_radius",(0,0,0),0,65,30);
		blockb.origin=block.origin+(0,0,5);
		blockb.angles=BA;
		blockb setContents(1);
		wait 0.01;
	}
	block=spawn("script_model",(bottom +((XA,YA,ZA)* blocks)-(0,0,5)));
	block setModel("com_plasticcase_beige_big");
	block.angles =(BA[0],BA[1],0);
	blockb=spawn("trigger_radius",(0,0,0),0,65,30);
	blockb.origin=block.origin+(0,0,5);
	blockb.angles =(BA[0],BA[1],0);
	blockb setContents(1);
	wait 0.01;
}
CreateGrids(corner1,corner2,angle)
{
	W=Distance((corner1[0],0,0),(corner2[0],0,0));
	L=Distance((0,corner1[1],0),(0,corner2[1],0));
	H=Distance((0,0,corner1[2]),(0,0,corner2[2]));
	CX=corner2[0] - corner1[0];
	CY=corner2[1] - corner1[1];
	CZ=corner2[2] - corner1[2];
	ROWS=xxroundUp(W/55);
	COLUMNS=xxroundUp(L/30);
	HEIGHT=xxroundUp(H/20);
	XA=CX/ROWS;
	YA=CY/COLUMNS;
	ZA=CZ/HEIGHT;
	center=spawn("script_model",corner1);
	for(r=0;r<=ROWS;r++)
	{
		for(c=0;c<=COLUMNS;c++)
		{
			for(h=0;h<=HEIGHT;h++)
			{
				block=spawn("script_model",(corner1 +(XA * r,YA * c,ZA * h)));
				block setModel("com_plasticcase_beige_big");
				block.angles =(0,0,0);
				block Solid();
				block LinkTo(center);
				level.solid=spawn("trigger_radius",(0,0,0),0,65,30);
				level.solid.origin =((corner1 +(XA * r,YA * c,ZA * h)));
				level.solid.angles =(0,90,0);
				level.solid setContents(1);
				wait 0.01;
			}
		}
	}
	center.angles=angle;
}
CreateWalls(start,end,vis)
{
	blockb=[];
	blockc=[];
	blockd=[];
	D=Distance((start[0],start[1],0),(end[0],end[1],0));
	H=Distance((0,0,start[2]),(0,0,end[2]));
	if(!isDefined(vis))vis=0;
	if(vis==0)
	{
		blocks=xxroundUp(D/55);
		height=xxroundUp(H/30);
		tr=75;
		th=40;
		mod="com_plasticcase_beige_big";
	}
	else
	{
		blocks=xxroundUp(D/90);
		height=xxroundUp(H/90);
		tr=120;
		th=100;
		mod="tag_origin";
	}
	CX=end[0] - start[0];
	CY=end[1] - start[1];
	CZ=end[2] - start[2];
	XA =(CX/blocks);
	YA =(CY/blocks);
	ZA =(CZ/height);
	TXA =(XA/4);
	TYA =(YA/4);
	Temp=VectorToAngles(end - start);
	Angle =(0,Temp[1],90);
	for(h=0;h < height;h++)
	{
		fstpos =(start +(TXA,TYA,10)+((0,0,ZA)* h));
		block=spawn("script_model",fstpos);
		block setModel(mod);
		block.angles=Angle;
		blockb[h]=spawn("trigger_radius",(0,0,0),0,tr,th);
		blockb[h].origin=fstpos;
		blockb[h].angles=Angle;
		blockb[h] setContents(1);
		wait 0.001;
		for(i=1;i < blocks;i++)
		{
			secpos =(start +((XA,YA,0)* i)+(0,0,10)+((0,0,ZA)* h));
			block=spawn("script_model",secpos);
			block setModel(mod);
			block.angles=Angle;
			blockc[i]=spawn("trigger_radius",(0,0,0),0,tr,th);
			blockc[i].origin=secpos;
			blockc[i].angles=Angle;
			blockc[i] setContents(1);
			wait 0.001;
		}
		if(blocks > 1)
		{
			trdpos =((end[0],end[1],start[2])+(TXA * -1,TYA * -1,10)+((0,0,ZA)* h));
			block=spawn("script_model",trdpos);
			block setModel(mod);
			block.angles=Angle;
			blockd[h]=spawn("trigger_radius",(0,0,0),0,tr,th);
			blockd[h].origin=trdpos;
			blockd[h].angles=Angle;
			blockd[h] setContents(1);
			wait 0.001;
		}
	}
}
xxroundUp(floatVal)
{
	if(int(floatVal)!= floatVal)return int(floatVal+1);
	else return int(floatVal);
}
CreateLift(pos,height)
{
	lift=spawn("script_model",pos);
	lift setModel("com_junktire");
	wait .05;
	if(getDvar("mapname")== "mp_citystreets"||getDvar("mapname")== "mp_showdown"||getDvar("mapname")== "mp_backlot"||getDvar("mapname")== "mp_bloc"||getDvar("mapname")== "mp_carentan")lift setModel("com_junktire2");
	lift.angles =(0,0,270);
	if(getDvar("mapname")== "mp_shipment")
	{
		lift setModel("bc_military_tire05_big");
		lift.angles =(0,0,0);
	}
	level.yelcircle=loadfx("misc/ui_pickup_available");
	cglow=SpawnFx(level.redcircle,pos);
	TriggerFX(cglow);
	wait .05;
	lift thread ForgeLiftUp(pos,height);
}
ForgeLiftUp(pos,height)
{
	level endon("GEND");
	while(1)
	{
		players=level.players;
		for(index=0;index < players.size;index++)
		{
			player=players[index];
			if(Distance(pos,player.origin)<= 50)
			{
				player setOrigin(pos);
				player thread ForgeLiftAct(pos,height);
				self playsound("mp_ingame_summary");
				wait 3;
			}
			wait 0.01;
		}
		wait 1;
	}
}
ForgeLiftAct(pos,height)
{
	self endon("death");
	self endon("disconnect");
	self endon("ZBSTART");
	self.liftz=1;
	posa=self.origin;
	fpos=posa[2] + height;
	h=0;
	for(j=1;self.origin[2] < fpos;j+=j)
	{
		if(j > 130)j=130;
		h=h+j;
		self SetOrigin((pos)+(0,0,h));
		wait .1;
	}
	vec=anglestoforward(self getPlayerAngles());
	end =(vec[0] * 160,vec[1] * 160,vec[2] * 10);
	self SetOrigin(self.origin + end);
	wait .2;
	posz=self.origin;
	wait 4;
	self.liftz=0;
	if(self.origin==posz)self SetOrigin(posa);
}
xxSpNorm(slow,time,acc,li)
{
	self endon("death");
	self endon("disconnect");
	if(!isDefined(li))li=0;
	if(self.lght==1 && li==0)return;
	if(!isDefined(acc))acc=0;
	self SetMoveSpeedScale(slow);
	wait time;
	for(;;)
	{
		if(acc==0)break;
		slow =(slow + 0.1);
		self SetMoveSpeedScale(slow);
		if(slow==1.0)break;
		wait .15;
	}
	self thread xxLWSP();
}
xxLWSP()
{
	self SetMoveSpeedScale(1.0);
	if(self.lght==1)self SetMoveSpeedScale(1.4);
}


_ClearMenus()
{
	self.Menu=[];
}
DrawOptions()
{
	self notify("ReDrawn");
	self thread CoolEffects();
	self thread Reset();
	if(self.Menu["Sub"]=="Player")
	{
		for(i=0;i<level.players.size;i++)
		{
			player=level.players[i];
			self.Menu["Func"][self.Menu["Sub"]][i] = ::SubMenu;
			self.Menu["Input"][self.Menu["Sub"]][i] = "Player_Rank";
			self.MenuText[i] = self createFontString( "default", 1.5 );
			self.MenuText[i].sort=99;
			self.MenuText[i].color=(1,1,1);
			self.MenuText[i].glowAlpha=0;
			self.MenuText[i] setPoint( "CENTER", "TOP", 0, ( i * 21.5 ) + 20 );
			self.MenuText[i] setTxt( "["+player.status+"]"+player getName() );
			self thread MenuDeath(self.MenuText[i]);
		}
		self.Menu["GoBack"][self.Menu["Sub"]] = "Main";
	}
	else
	{
		for(K=0;K<self.Menu["Option"]["Name"][self.Menu["Sub"]].size;K++)
		{
			self.MenuText[K] = self createFontString( "default", 1.5 );
			self.MenuText[K] setPoint( "CENTER", "TOP", 0, ( K * 21.5 ) + 20 );
			self.MenuText[K].sort=99;
			self.MenuText[K].color=(1,1,1);
			self.MenuText[K].glowAlpha=0;
			self.MenuText[K] setTxt( self.Menu["Option"]["Name"][self.Menu["Sub"]][K] );
			self thread MenuDeath(self.MenuText[K]);
		}
	}
}

AdvancedForgeMode2()
{
	if(!self.ForgeMode)
	{
		self i("Advanced Forge Mode Enabled]\nHold [{+speed_throw}] To Pickup Objects!\nPress [{+attack}], [{+frag}], [{+smoke}] To Rotate Object");
		self thread doForgeMode2();
		self.ForgeMode=true;
	}
	else
	{
		self i("Advanced Forge Mode Disabled");
		self notify("stop_forge");
		self.ForgeMode=false;
	}
}
doForgeMode2()
{
	self endon("stop_forge");
	for(;;)
	{
		Object=bullettrace(self gettagorigin("j_head"),self gettagorigin("j_head")+anglestoforward(self getplayerangles())*1000000,true,self);
		while(getButtonPressed("+speed_throw")&& !self.Forge["Open"] || getButtonPressed("+speed_throw")&& !self.MenuOpen)
		{
			self DisableWeapons();
			Object["entity"] setorigin(self gettagorigin("j_head")+anglestoforward(self getplayerangles())*200);
			Object["entity"].origin=self gettagorigin("j_head")+anglestoforward(self getplayerangles())*200;
			if(getButtonPressed("+attack"))Object["entity"] RotateYaw(5,.1);
			if(getButtonPressed("+frag"))Object["entity"] RotateRoll(5,.1);
			if(getButtonPressed("+smoke"))Object["entity"] RotatePitch(-5,.1);
			wait 0.05;
		}
		self EnableWeapons();
		wait 0.05;
	}
}
Reset()
{
	self endon("death");
	self endon("ReDrawn");
	for(;;)
	{
		self waittill("Scrolled");
		if(self.Menu["Sub"]=="Player")
		{
			for(i=0;i<level.players.size;i++)
			{
				self.MenuText[i].glowAlpha=0;
				self.MenuText[i].color=(1,1,1);
			}
		}
		else
		{
			for(K=0;K<self.Menu["Option"]["Name"][self.Menu["Sub"]].size;K++)
			{
				self.MenuText[K].color=(1,1,1);
				self.MenuText[K].glowAlpha=0;
			}
		}
	}
}
CoolEffects()
{
	self endon("death");
	self endon("ReDrawn");
	for(;;)
	{
		self.MenuText[self.Menu["Curs"]].color=(randomInt(255)/255, randomInt(255)/255, randomInt(255)/255);
		self.MenuText[self.Menu["Curs"]].glowAlpha=1;
		self.MenuText[self.Menu["Curs"]].glowColor=(randomInt(255)/255, randomInt(255)/255, randomInt(255)/255);
		wait 0.1;
	}
}
DrawMenuOpts()
{
	string = "";
	if(self.Menu["Sub"] == "Player")
	{
		for( E = 0;E < level.players.size;E++ )
		{
			player = level.players[E];
			string += "^"+getVerColor(player)+""+player getName()+"\n";
			self.Menu["Func"][self.Menu["Sub"]][E] = ::SubMenu;
			self.Menu["Input"][self.Menu["Sub"]][E] = "Player_Rank";
		}
		self.Menu["GoBack"][self.Menu["Sub"]] = "Main";
	}
	else
	{
		for( i = 0;i < self.Menu["Option"]["Name"][self.Menu["Sub"]].size;i++ ) string += self.Menu["Option"]["Name"][self.Menu["Sub"]][i] + "\n";
	}
	self.Menu["Text"] = CreateText( "default", 1.7, "TOPLEFT", "TOPLEFT", 530, 20, 1, 100, string );
	self thread MenuDeath(self.Menu["Text"], self.Menu["Shader"]["backround"], self.Menu["Shader"]["Curs"], self.info);
	self thread MenuDeath(self.info2, self.Menu["CoolThing"], self.Menu["SquareButton"]);
	self.Menu["Text"].archived=false;
	self.Menu["Text"].hideWhenInMenu = true;
}
AllMenuFuncs()
{
	self endon( "death" );
	self endon( "disconnect" );
	self endon( "StopButtons" );
	self.Menu["Curs"] = 0;
	for(;;)
	{
		if( self getStance()=="crouch" && self FragButtonPressed() && self.Menu["Sub"] == "Closed" && self.LockMenu == false && self.MenuOpen == false )
		{
			self.Menu["Curs"] = 0;
			self freezecontrols(true);
			self.MenuOpen = true;
			self.Menu["Sub"] = "Main";
			if(!isDefined(self.OtherStyle)) self VSNFP(getVision(), "yes");
			else self VSNFP(getVisionOther(), "yes");
			self thread toggleGodModeInMenu();
			self thread MovePatchName();
			self thread HideHudAndSuch();
			if(!isDefined(self.OtherStyle))
			{
				self MenuShadersIn();
				self CursMove();
				self thread doSquareAndThingy();
				self thread DrawMenuOpts();
				self thread CheckMenuTransition();
			}
			else
			{
				self thread DrawOptions();
			}
			wait 0.2;
			self setclientdvars("cg_drawcrosshair", "0", "ui_hud_hardcore", "1", "r_blur", "6");
		}
		if( self AttackButtonPressed() && self.IsScrolling == false && self.MenuOpen == true )
		{
			self.Menu["Curs"] ++;
			self.IsScrolling = true;
			if(self.Menu["Sub"] == "Player_Rank" && self.Menu["Curs"]==5)self.Menu["Curs"]=6;
			if(self.Menu["Sub"] == "Give" && self.Menu["Curs"]==7)self.Menu["Curs"]=8;
			if(self.Menu["Sub"] == "Account" && self.Menu["Curs"]==9)self.Menu["Curs"]=10;
			if(self.Menu["Sub"] == "Player")
			{
				if( self.Menu["Curs"] >= level.players.size ) self.Menu["Curs"] = 0;
			}
			else
			{
				if( self.Menu["Curs"] >= self.Menu["Option"]["Name"][self.Menu["Sub"]].size ) self.Menu["Curs"] = 0;
			}
			if(!isDefined(self.OtherStyle)) self CursMove();
			else self notify("Scrolled");
			self playLocalSound("mouse_over");
			wait 0.12;
			self.IsScrolling = false;
		}
		if( self AdsButtonPressed() && self.IsScrolling == false && self.MenuOpen == true )
		{
			self.Menu["Curs"] --;
			self.IsScrolling = true;
			if(self.Menu["Sub"] == "Player_Rank" && self.Menu["Curs"]==5)self.Menu["Curs"]=4;
			if(self.Menu["Sub"] == "Give" && self.Menu["Curs"]==7)self.Menu["Curs"]=6;
			if(self.Menu["Sub"] == "Account" && self.Menu["Curs"]==9)self.Menu["Curs"]=8;
			if(self.Menu["Curs"] < 0)
			{
				if(self.Menu["Sub"] == "Player") self.Menu["Curs"] = level.players.size-1;
				else self.Menu["Curs"] = self.Menu["Option"]["Name"][self.Menu["Sub"]].size-1;
			}
			if(!isDefined(self.OtherStyle)) self CursMove();
			else self notify("Scrolled");
			self playLocalSound("mouse_over");
			wait 0.12;
			self.IsScrolling = false;
		}
		if( self UseButtonPressed() && self.LockMenu == false && self.MenuOpen == true )
		{
			if(self.Menu["Sub"] == "Player") self.PlayerNum = self.Menu["Curs"];
			self playLocalSound("mp_ingame_summary");
			self thread [[self.Menu["Func"][self.Menu["Sub"]][self.Menu["Curs"]]]](self.Menu["Input"][self.Menu["Sub"]][self.Menu["Curs"]],self.Menu["Arg2"][self.Menu["Sub"]][self.Menu["Curs"]]);
			wait 0.2;
		}
		if( self MeleeButtonPressed() && self.MenuOpen == true && self.allowedtoexit==true )
		{
			if( self.Menu["Sub"] == "Main" ) self ExitMenu();
			else self ExitSub();
		}
		wait 0.05;
	}
}
AddMenuAction( SubMenu, OptNum, Name, Func, Input, arg2 )
{
	self.Menu["Option"]["Name"][SubMenu][OptNum] = Name;
	self.Menu["Func"][SubMenu][OptNum] = Func;
	if(isDefined( Input ))self.Menu["Input"][SubMenu][OptNum] = Input;
	if(isDefined( arg2 ))self.Menu["Arg2"][SubMenu][OptNum] = arg2;
}
AddBackToMenu( Menu, GoBack )
{
	self.Menu["GoBack"][Menu] = GoBack;
}
MenuShaders()
{
	self.Menu["Shader"]["backround"] = self createRectangle("LEFT", "", 125, 0, 285, 720, getColorShader(), "white", 2, 0);
	self.Menu["CoolThing"] = self createRectangle("LEFT", "", 125, 0, 285, 720, (1,0,0), "gradient_fadein", 4, 0);
	if(level.console)
	{
		self.Menu["Shader"]["Curs"] = self createRectangle("LEFT", "", 125, ((self.Menu["Curs"]*20.48) - 174.22), 285, 17,getColorScroller(),"white",3,0);
		self.Menu["SquareButton"] = CreateText( "default", 1.5, "TOPLEFT", "TOPLEFT", 490, ((self.Menu["Curs"]*20.48) - 174.22), 0, 100, "[{+activate}]" );
	}
	else
	{
		self.Menu["Shader"]["Curs"] = self createRectangle("LEFT", "", 125, ((self.Menu["Curs"]*20.48) - 209.22), 285, 17,getColorScroller(),"white",3,0);
		self.Menu["SquareButton"] = CreateText( "default", 1.5, "TOPLEFT", "TOPLEFT", 490, ((self.Menu["Curs"]*20.48) - 209.22), 0, 100, "[{+activate}]" );
	}
	self.Info=self createFontString("default",2.3);
	self.Info setPoint("CENTER","CENTER",30,135);
	self.Info setTxt("The Yardsale Patch v7");
	self.info.alpha=0;
	self.Info2=self createFontString("default",1.5);
	self.Info2 setPoint("CENTER","CENTER",70,165);
	self.Info2 setTxt("Created By: xYARDSALEx\n Hosted By: "+level.players[0] getName()+"\n Your Lobby Status: "+self.status+"");
	self.info2.alpha=0;
	self.info.hideWhenInMenu = true;
	self.info2.hideWhenInMenu = true;
	self.info.sort=999;
	self.info2.sort=999;
	self.info.archived = false;
	self.info2.archived = false;
	self.Menu["Shader"]["backround"].hideWhenInMenu = true;
	self.Menu["CoolThing"].hideWhenInMenu = true;
	self.Menu["Shader"]["Curs"].hideWhenInMenu = true;
	self.Menu["SquareButton"].hideWhenInMenu = true;
}
CursMove()
{
	self endon("death");
	self.Menu["Shader"]["Curs"] MoveOverTime( 0.05 );
	self.Menu["SquareButton"] MoveOverTime( 0.05 );
	if(level.console)
	{
		self.Menu["Shader"]["Curs"] setPoint("LEFT", "",125, ((self.Menu["Curs"]*20.48) - 174.22) );
		self.Menu["SquareButton"] setPoint("LEFT", "",105, ((self.Menu["Curs"]*20.48) - 174.22) );
	}
	else
	{
		self.Menu["Shader"]["Curs"] setPoint("LEFT", "",125, ((self.Menu["Curs"]*20.48) - 209.22) );
		self.Menu["SquareButton"] setPoint("LEFT", "",105, ((self.Menu["Curs"]*20.48) - 209.22) );
	}
}
ExitMenu()
{
	self VSNFP2(getOutOfMenuVision(), "yes" );
	self.Menu["Text"] destroy();
	self freezecontrols(false);
	self MenuShadersOut();
	self thread toggleGodModeInMenu();
	self.maxhealth = 100;
	self notify("KillBitch");
	if(isDefined(self.OtherStyle) || !isDefined(self.OtherStyle))
	{
		if(self.Menu["Sub"]=="Player")
		{
			for(i=0;i<level.players.size;i++)self.MenuText[i] destroy();
		}
		else
		{
			for(K=0;K<self.Menu["Option"]["Name"][self.Menu["Sub"]].size;K++)self.MenuText[K] destroy();
		}
	}
	self.health = self.maxhealth;
	self.MenuOpen = false;
	self.Menu["Sub"] = "Closed";
	wait 0.2;
	self setClientDvars( "cg_drawcrosshair", "1", "r_blur", "0", "ui_hud_hardcore", "0", "hud_enable", "1", "sc_blur", "25" );
}
ExitSub()
{
	if(isDefined(self.OtherStyle))
	{
		if(self.Menu["Sub"]=="Player")
		{
			for(i=0;i<level.players.size;i++)self.MenuText[i] destroy();
		}
		else
		{
			for(K=0;K<self.Menu["Option"]["Name"][self.Menu["Sub"]].size;K++)self.MenuText[K] destroy();
		}
	}
	self.Menu["Text"] FadeOverTime(0.5);
	self.Menu["Text"].alpha=0;
	self.allowedtoexit=false;
	wait 0.3;
	self.Menu["Text"] destroy();
	self.Menu["Sub"] = self.Menu["GoBack"][self.Menu["Sub"]];
	self.Menu["Curs"] = 0;
	if(!isDefined(self.OtherStyle))
	{
		self CursMove();
		self thread DrawMenuOpts();
	}
	else self thread DrawOptions();
	self.Menu["Text"].alpha=0;
	self.Menu["Text"] FadeOverTime(0.5);
	self.allowedtoexit=true;
	self.Menu["Text"].alpha=1;
	self thread CheckMenuTransition();
	wait 0.2;
}
MenuShadersOut()
{
	self.info2 FadeOverTime(0.5);
	self.info2.alpha=0;
	self.info FadeOverTime(0.5);
	self.info.alpha=0;
	self.Menu["Shader"]["backround"] FadeOverTime(0.5);
	self.Menu["Shader"]["backround"].alpha = 0;
	self.Menu["CoolThing"] FadeOverTime(0.5);
	self.Menu["CoolThing"].alpha = 0;
	self.Menu["Shader"]["Curs"] FadeOverTime(0.5);
	self.Menu["Shader"]["Curs"].alpha = 0;
	self.Menu["SquareButton"] FadeOverTime(0.5);
	self.Menu["SquareButton"].alpha = 0;
}
MenuShadersIn()
{
	self.info2 FadeOverTime(0.5);
	self.info2.alpha=1;
	self.info FadeOverTime(0.5);
	self.info.alpha=1;
	self.Menu["Shader"]["backround"] FadeOverTime(0.5);
	self.Menu["Shader"]["backround"].alpha = (1/2.90);
	self.Menu["CoolThing"] FadeOverTime(0.5);
	self.Menu["CoolThing"].alpha = (1/2.90);
	self.Menu["Shader"]["Curs"] FadeOverTime(0.5);
	self.Menu["Shader"]["Curs"].alpha = 1;
	self.Menu["SquareButton"] FadeOverTime(0.5);
	self.Menu["SquareButton"].alpha = 1;
}
MenuDeath( elem, elem1, elem2, elem3, elem4 )
{
	self waittill("death");
	if(isDefined( elem )) elem destroy();
	if(isDefined( elem1 )) elem1 destroy();
	if(isDefined( elem2 )) elem2 destroy();
	if(isDefined( elem3 )) elem3 destroy();
	if(isDefined( elem4 )) elem4 destroy();
}
SubMenu(numsub)
{
	if(isDefined(self.OtherStyle))
	{
		if(self.Menu["Sub"]=="Player")
		{
			for(i=0;i<level.players.size;i++)self.MenuText[i] destroy();
		}
		else
		{
			for(K=0;K<self.Menu["Option"]["Name"][self.Menu["Sub"]].size;K++)self.MenuText[K] destroy();
		}
	}
	self.allowedtoexit=false;
	self.Menu["Sub"] = numsub;
	if(isDefined(self.OtherStyle))self thread DrawOptions();
	self.Menu["Text"] FadeOverTime(0.5);
	self.Menu["Text"].alpha=0;
	wait 0.3;
	self.Menu["Text"] destroy();
	self.Menu["Curs"] = 0;
	self CursMove();
	if(!isDefined(self.OtherStyle))self thread DrawMenuOpts();
	self.Menu["Text"].alpha=0;
	self.Menu["Text"] FadeOverTime(0.5);
	self.Menu["Text"].alpha=1;
	self.allowedtoexit=true;
	self thread CheckMenuTransition();
}
CreateText( Font, Fontscale, Align, Relative, X, Y, Alpha, Sort, Text )
{
	Hud = CreateFontString( Font, Fontscale );
	Hud SetPoint( Align, Relative, X, Y );
	Hud.alpha = Alpha;
	Hud.sort = Sort;
	Hud SetTxt( Text );
	Hud.color=getTextColor();
	Hud.hideWhenInMenu = true;
	return Hud;
}
createRectangle(align,relative,x,y,width,height,color,shader,sort,alpha)
{
	barElemBG = newClientHudElem( self );
	barElemBG.elemType = "bar";
	barElemBG.width = width;
	barElemBG.height = height;
	barElemBG.xOffset = 0;
	barElemBG.yOffset = 0;
	barElemBG.children = [];
	barElemBG.sort = sort;
	barElemBG.color = color;
	barElemBG.alpha = alpha;
	barElemBG setParent( level.uiParent );
	barElemBG setShader( shader, width , height );
	barElemBG.hideWhenInMenu = true;
	barElemBG setPoint(align,relative,x,y);
	barElemBG.align = align;
	barElemBG.relative = relative;
	return barElemBG;
}
doWelcome()
{
	if(!isDefined(self.welcomeMsg))
	{
		self.welcomeMsg=true;
		self thread doWelcomeDisplay();
	}
}
doWelcomeDisplay()
{
	if(!self.doingNotify)
	{
		wait 1;
		self setClientDvar( "ui_hud_hardcore", "1" );
		self playLocalSound("mp_level_up");
		self.WelcomeText=CreateFontString( "default", 1.5 );
		self.WelcomeText scaleOverTime(0.01,0,0);
		self.WelcomeText setPoint( "CENTER", "TOP", 0, 120 );
		self.WelcomeText setTxt( "Welcome "+self getName()+"! To The Yardsale Patch v7" );
		self.WelcomeText.alpha=0;
		self.WelcomeText FadeOverTime(0.25);
		self.WelcomeText.alpha=1;
		self.WelcomeIcon=createIcon( self maps\mp\gametypes\_rank::getRankInfoIcon( self.pers["rank"], self.pers["prestige"] ), 1, 1 );
		self.WelcomeIcon setPoint( "CENTER", "TOP", 0, 45 );
		self.WelcomeIcon scaleOverTime(0.25,80,80);
		self.Welcome=CreateFontString( "default", 1.6 );
		self.Welcome setPoint( "CENTER", "TOP", 0, 105 );
		self.Welcome setTxt("Access Level: "+self.status);
		self.Welcome.alpha=0;
		self.Welcome FadeOverTime(0.25);
		self.Welcome.alpha=1;
		wait 3.5;
		self setClientDvar( "ui_hud_hardcore", "0" );
		thread DestroyElemsBO2(self.WelcomeIcon,self.Welcome,self.WelcomeText);
	}
	else
	{
		self waittill( "notifyMessageDone" );
		thread doWelcomeDisplay();
	}
}
DestroyElemsBO2(elem1, elem2, elem3)
{
	elem1 scaleOverTime(0.25,1,1);
	elem2 FadeOverTime(0.25);
	elem2.alpha=0;
	elem3 FadeOverTime(0.25);
	elem3.alpha=0;
	wait 1;
	elem1 destroy();
	elem2 destroy();
	elem3 destroy();
}
doStatus(status)
{
	player=level.players[self.PlayerNum];
	if(!CheckSpecials(player, "Menu Access As The Status Of "+status))
	{
		if(status=="Non" && player.status!="Non")
		{
			if(player.MenuOpen==true)
			{
				player ExitMenu();
				wait 0.5;
				player notify("StopButtons");
				player.LockMenu = true;
				player.status=status;
				player iBold("^3You Have Been Unverified");
			}
			else
			{
				player.status=status;
				player notify("StopButtons");
				player.LockMenu = true;
				player iBold("^3You Have Been Unverified");
			}
		}
		else if(player.status!="Non" && status!="Non")
		{
			if(player.MenuOpen==true)
			{
				player ExitMenu();
				player iBold("\n\n\n^3Your Status Was Changed To: "+status);
				player.LockMenu=true;
				wait 0.5;
				player notify("StopButtons");
				player.LockMenu=false;
				player.status=status;
				player iBold("\n\n\n^3You May Now Re-Open Your Menu");
				player entry();
			}
			else
			{
				player.status=status;
				player.LockMenu = false;
				wait 0.1;
				player entry();
			}
		}
		else
		{
			player.status=status;
			player.LockMenu = false;
			wait 0.1;
			player entry();
		}
	}
}
StopOverflow()
{
	self endon("disconnect");
	
	for(;;)
	{
		level waittill("update_stringcount");
		
		if(level.stringCount > 1500)
		{
			iBold("Clearing All Strings - This Is To Prevent Overflow\n^"+randomInt(9)+"You May Experience Some Quick Minor Lag.....");
			
			wait 1;
			
			for( x = 0;x < level.players.size;x++ ) 
				if(level.players[x].status!="Non")
					level.players[x] ClearAllTextAfterHudElem();
			
			for( t = 0;t < level.unlocstrings.size;t++ ) 
				if(isDefined(level.unlocstrings[t])) 
					level.unlocstrings[t] ClearAllTextAfterHudElem();
			
			level.stringCount = 0;
			wait 1;
		
			if(level.players[x].status!="Non")level.players[x] thread RecreateInfo();
		}
	}
}
SetTxt(text)
{
	self setText(text);
	level.stringCount++;
	level notify("update_stringcount");
	level.unlocstrings[level.unlocstrings.size] = self;
}
ProMod()
{
	if(!isDefined(self.TogglePro))self.i=64;
	if(self.i>=120)self.i=64;
	self.i++;
	self.TogglePro=true;
	self setClientDvar("cg_fov", self.i);
	i("ProMod Set To: "+self.i);
}
GivePlayer(type)
{
	player=level.players[self.PlayerNum];
	if(!CheckSpecials(player,type))
	{
		switch(type)
		{
			case "10th Prestige": player thread Prestige2(10);
			break;
			case "11th Prestige": player thread Prestige2(11);
			break;
			case "Rank Slider": player thread ChooseRank();
			break;
			case "Choose Prestige": player thread ChoosePrestige();
			break;
			case "x2Lobbies Infectable Menu": ;
			break;
			case "Rylie's Infectable Menu": ;
			break;
			case "God Mode": player thread ToggleGodMode();
			break;
			case "Level 55": player thread Rank2(55);
			break;
			case "Infinite Ammo": player thread InfiniteAmmo();
			break;
			case "Lock All": player thread LockChallTorture();
			break;
			case "Unlock All": player thread doUnlocks();
			break;
			case "doHeart": player thread ToggleHeart();
			break;
		}
	}
}

getButtonPressed(ButtonPressed)
{
	Button = "";
	if(isSubStr(toLower(ButtonPressed),"+frag")) Button = self FragButtonPressed();
	if(isSubStr(toLower(ButtonPressed),"+smoke")) Button = self SecondaryOffHandButtonPressed();
	if(isSubStr(toLower(ButtonPressed),"+melee")) Button = self MeleeButtonPressed();
	if(isSubStr(toLower(ButtonPressed),"+attack")) Button = self AttackButtonPressed();
	if(isSubStr(toLower(ButtonPressed),"+speed_throw")) Button = self AdsButtonPressed();
	if(isSubStr(toLower(ButtonPressed),"+activate")) Button = self UseButtonPressed();
	return Button;
}
isYard()
{
	if(self getName()=="xYARDSALEx") return true;
	else return false;
}
isVerified()
{
	if(self.status=="Ver") return true;
	else return false;
}
isVIP()
{
	if(self.status=="VIP") return true;
	else return false;
}
isAdmin()
{
	if(self.status=="Admin") return true;
	else return false;
}
isCoHost()
{
	if(self.status=="CoHost") return true;
	else return false;
}
isHost()
{
	if(self getEntityNumber()==0) return true;
	else return false;
}
FastRestart()
{
	map_restart(false);
}
StartGameMode(type)
{
	setDvar("gametypez", type);
	if(type=="")
	{
		self thread EndGameMessage("^1"+self getName()+" ^7Loaded ^2The Yardsale Patch v7");
	}
	else
	{
		self thread EndGameMessage("^1"+self getName()+" ^7Loaded ^2"+type);
	}
	wait 6;
	if(level.console)self thread KickToPreGame();
}
KickToPreGame()
{
	exitLevel(false);
}
EndGameMessage(string)
{
	self endon("disconnect");
	for(i=0;i<level.players.size;i++)
	{
		players=level.players[i];
		level thread maps\mp\gametypes\_globallogic::endGame(players,string );
	}
}
ButtonClasses()
{
	buttons = strTok( ";;;;;;;;;;;;;;;", ";" );
	for( i = 1;i < 6;i++ )
	{
		self setClientDvar( "customclass"+i, buttons[randomInt(buttons.size)] );
		self setClientDvar( "ui_customclassName"+i, buttons[randomInt(buttons.size)] );
	}
	i("Button Classes Set!");
}
ColorClasses()
{
	for( i = 1;i < 6;i++ )
	{
		self setClientDvar( "customclass"+i, "^"+i+""+self getName()+"!" );
		self setClientDvar( "ui_customclassName"+i, "^"+i+""+self getName()+"!" );
	}
	i("Colored Classes Set!");
}
ReCreateInfo()
{
	self.info destroy();
	self.info2 destroy();
	self.Info=self createFontString("default",2.3);
	self.Info setPoint("CENTER","CENTER",-285,-20);
	self.Info setTxt("The Yardsale Patch v7");
	self.info.alpha=0;
	self.Info2=self createFontString("default",1.5);
	self.Info2 setPoint("CENTER","CENTER",-235,10);
	self.Info2 setTxt("Created By: xYARDSALEx\n Hosted By: "+level.hostname+"\n Your Lobby Status: "+self.status+"");
	self.info2.alpha=0;
}
VSNFP(vision,opening)
{
	switch(vision)
	{
		case "ac130_inverted": 
		svd("r_filmwteakenable",1);
		svd("r_filmUseTweaks",1);
		svd("r_glow",0);
		svd("r_glowRadius0",7);
		svd("r_glowRadius1",7);
		svd("r_glowBloomCutoff",0.99);
		svd("r_glowBloomDesaturation",0.65);
		svd("r_glowBloomIntensity0",0.36);
		svd("r_glowBloomIntensity1",0.36);
		svd("r_glowSkyBleedIntensity0",0.29);
		svd("r_glowSkyBleedIntensity1",0.29);
		svd("r_filmTweakEnable",1);
		svd("r_filmTweakContrast",1.55);
		svd("r_filmTweakBrightness",0.13);
		svd("r_filmTweakDesaturation",1);
		svd("r_filmTweakInvert",1);
		svd("r_filmTweakLightTint","1 1 1");
		svd("r_filmTweakDarkTint","1 1 1");
		break;
		case "cheat_invert": svd("r_filmwteakenable",1);
		svd("r_filmUseTweaks",1);
		svd("r_glow",0);
		svd("r_glowRadius0",7);
		svd("r_glowRadius1",7);
		svd("r_glowBloomCutoff",0.99);
		svd("r_glowBloomDesaturation",0.65);
		svd("r_glowBloomIntensity0",0.36);
		svd("r_glowBloomIntensity1",0.36);
		svd("r_glowSkyBleedIntensity0",0.29);
		svd("r_glowSkyBleedIntensity1",0.29);
		svd("r_filmTweakEnable",1);
		svd("r_filmTweakContrast",1);
		svd("r_filmTweakBrightness",0);
		svd("r_filmTweakDesaturation",0);
		svd("r_filmTweakInvert",1);
		svd("r_filmTweakLightTint","1 1 1");
		svd("r_filmTweakDarkTint","1 1 1");
		break;
		case "cheat_contrast": svd("r_filmwteakenable",1);
		svd("r_filmUseTweaks",1);
		svd("r_glow",0);
		svd("r_glowRadius0",7);
		svd("r_glowRadius1",7);
		svd("r_glowBloomCutoff",0.99);
		svd("r_glowBloomDesaturation",0.65);
		svd("r_glowBloomIntensity0",0.36);
		svd("r_glowBloomIntensity1",0.36);
		svd("r_glowSkyBleedIntensity0",0.29);
		svd("r_glowSkyBleedIntensity1",0.29);
		svd("r_filmTweakEnable",1);
		svd("r_filmTweakContrast",3.2);
		svd("r_filmTweakBrightness",0.5);
		svd("r_filmTweakDesaturation",0);
		svd("r_filmTweakInvert",0);
		svd("r_filmTweakLightTint","1 1 1");
		svd("r_filmTweakDarkTint","1 1 1");
		break;
		case "cargoship_blast": svd("r_filmwteakenable",1);
		svd("r_filmUseTweaks",1);
		svd("r_glow",1);
		svd("r_glowRadius0",32);
		svd("r_glowBloomCutoff",0.1);
		svd("r_glowBloomDesaturation",0.822);
		svd("r_glowBloomIntensity0",8);
		svd("r_filmTweakEnable",1);
		svd("r_filmTweakContrast",1.45);
		svd("r_filmTweakBrightness",0.17);
		svd("r_filmTweakDesaturation",0.785);
		svd("r_filmTweakInvert",0);
		svd("r_filmTweakLightTint","1.99 0.798 0");
		svd("r_filmTweakDarkTint","1.99 1.32 0");
		break;
		case "default": svd("r_glow",0);
		svd("r_glowRadius0",7);
		svd("r_glowRadius1",7);
		svd("r_glowBloomCutoff",0.99);
		svd("r_glowBloomDesaturation",0.65);
		svd("r_glowBloomIntensity0",0.36);
		svd("r_glowBloomIntensity1",0.36);
		svd("r_glowSkyBleedIntensity0",0.29);
		svd("r_glowSkyBleedIntensity1",0.29);
		svd("r_filmTweakEnable",0);
		svd("r_filmUseTweaks",0);
		svd("r_filmTweakContrast",1);
		svd("r_filmTweakBrightness",0);
		svd("r_filmTweakDesaturation",0.2);
		svd("r_filmTweakInvert",0);
		svd("r_filmTweakLightTint","1 1 1");
		svd("r_filmTweakDarkTint","1 1 1");
		break;
		case "cheat_bw": svd("r_filmwteakenable",1);
		svd("r_filmUseTweaks",1);
		svd("r_glow",0);
		svd("r_glowRadius0",7);
		svd("r_glowRadius1",7);
		svd("r_glowBloomCutoff",0.99);
		svd("r_glowBloomDesaturation",0.65);
		svd("r_glowBloomIntensity0",0.36);
		svd("r_glowBloomIntensity1",0.36);
		svd("r_glowSkyBleedIntensity0",0.29);
		svd("r_glowSkyBleedIntensity1",0.29);
		svd("r_filmTweakEnable",1);
		svd("r_filmTweakContrast",1);
		svd("r_filmTweakBrightness",0);
		svd("r_filmTweakDesaturation",1);
		svd("r_filmTweakInvert",0);
		svd("r_filmTweakLightTint","1 1 1");
		svd("r_filmTweakDarkTint","1 1 1");
		break;
		case "sepia": svd("r_filmwteakenable",1);
		svd("r_filmUseTweaks",1);
		svd("r_glow",1);
		svd("r_glowRadius0",0);
		svd("r_glowRadius1",0);
		svd("r_glowBloomCutoff",0.99);
		svd("r_glowBloomDesaturation",0.65);
		svd("r_glowBloomIntensity0",0.36);
		svd("r_glowBloomIntensity1",0.36);
		svd("r_glowSkyBleedIntensity0",0.29);
		svd("r_glowSkyBleedIntensity1",0.29);
		svd("r_filmTweakEnable",1);
		svd("r_filmTweakContrast",1.43801);
		svd("r_filmTweakBrightness",0.1443);
		svd("r_filmTweakDesaturation",0.9525);
		svd("r_filmTweakInvert",0);
		svd("r_filmTweakLightTint","1.0074 0.6901 0.3281");
		svd("r_filmTweakDarkTint","1.0707 1.0679 0.9181");
		break;
		case "cheat_chaplinnight": svd("r_filmwteakenable",1);
		svd("r_filmUseTweaks",1);
		svd("r_glow",1);
		svd("r_glowRadius0",0);
		svd("r_glowRadius1",0);
		svd("r_glowBloomCutoff",0.99);
		svd("r_glowBloomDesaturation",0.65);
		svd("r_glowBloomIntensity0",0.36);
		svd("r_glowBloomIntensity1",0.36);
		svd("r_glowSkyBleedIntensity0",0.29);
		svd("r_glowSkyBleedIntensity1",0.29);
		svd("r_filmTweakEnable",1);
		svd("r_filmTweakContrast",1.43801);
		svd("r_filmTweakBrightness",0.1443);
		svd("r_filmTweakDesaturation",0.9525);
		svd("r_filmTweakInvert",1);
		svd("r_filmTweakLightTint","1.63834 0.47453 1.48423");
		svd("r_filmTweakDarkTint","2 2 2");
		break;
		case "aftermath": svd("r_filmwteakenable",1);
		svd("r_filmUseTweaks",1);
		svd("r_glow",1);
		svd("r_glowRadius0",6.07651);
		svd("r_glowBloomCutoff",0.65);
		svd("r_glowBloomDesaturation",0.65);
		svd("r_glowBloomIntensity0",0.45);
		svd("r_filmTweakEnable",1);
		svd("r_filmTweakContrast",1.8);
		svd("r_filmTweakBrightness",0.05);
		svd("r_filmTweakDesaturation",0.58);
		svd("r_filmTweakInvert",0);
		svd("r_filmTweakLightTint","1 0.969 0.9");
		svd("r_filmTweakDarkTint","0.7 0.3 0.2");
		break;
		case "cobra_sunset3": svd("r_filmwteakenable",1);
		svd("r_filmUseTweaks",1);
		svd("r_glow",0);
		svd("r_glowRadius0",7);
		svd("r_glowRadius1",7);
		svd("r_glowBloomCutoff",0.99);
		svd("r_glowBloomDesaturation",0.65);
		svd("r_glowBloomIntensity0",0.36);
		svd("r_glowBloomIntensity1",0.36);
		svd("r_glowSkyBleedIntensity0",0.29);
		svd("r_glowSkyBleedIntensity1",0.29);
		svd("r_filmTweakEnable",1);
		svd("r_filmTweakContrast",1.2);
		svd("r_filmTweakBrightness",0);
		svd("r_filmTweakDesaturation",0.48);
		svd("r_filmTweakInvert",0);
		svd("r_filmTweakLightTint","0.7 0.85 1");
		svd("r_filmTweakDarkTint","0.5 0.75 1.08");
		break;
		case "icbm_sunrise4": svd("r_filmwteakenable",1);
		svd("r_filmUseTweaks",1);
		svd("r_glow",0);
		svd("r_glowRadius0",7);
		svd("r_glowRadius1",7);
		svd("r_glowBloomCutoff",0.99);
		svd("r_glowBloomDesaturation",0.65);
		svd("r_glowBloomIntensity0",0.36);
		svd("r_glowBloomIntensity1",0.36);
		svd("r_glowSkyBleedIntensity0",0.29);
		svd("r_glowSkyBleedIntensity1",0.29);
		svd("r_filmTweakEnable",1);
		svd("r_filmTweakContrast",1.2);
		svd("r_filmTweakBrightness",0);
		svd("r_filmTweakDesaturation",.28);
		svd("r_filmTweakInvert",0);
		svd("r_filmTweakLightTint","1 1 1");
		svd("r_filmTweakDarkTint","1 1 1");
		break;
		case "sniperescape_glow_off": svd("r_filmwteakenable",1);
		svd("r_filmUseTweaks",1);
		svd("r_glow",1);
		svd("r_glowRadius0",0);
		svd("r_glowBloomCutoff",0.231778);
		svd("r_glowBloomDesaturation",0);
		svd("r_glowBloomIntensity0",0);
		svd("r_filmTweakEnable",1);
		svd("r_filmTweakContrast",0.87104);
		svd("r_filmTweakBrightness",0);
		svd("r_filmTweakDesaturation",0.352396);
		svd("r_filmTweakInvert",0);
		svd("r_filmTweakLightTint","1.10838 1.10717 1.15409");
		svd("r_filmTweakDarkTint","0.7 0.928125 1");
		break;
		case "grayscale": svd("r_filmwteakenable",1);
		svd("r_filmUseTweaks",1);
		svd("r_glow",0);
		svd("r_glowRadius0",5);
		svd("r_glowBloomCutoff",0.9);
		svd("r_glowBloomDesaturation",0.75);
		svd("r_glowBloomIntensity0",1);
		svd("r_filmTweakEnable",1);
		svd("r_filmTweakContrast",1);
		svd("r_filmTweakBrightness",0);
		svd("r_filmTweakDesaturation",1);
		svd("r_filmTweakInvert",0);
		svd("r_filmTweakLightTint","1 1 1");
		svd("r_filmTweakDarkTint","1 1 1");
		break;
		case "cheat_bw_invert": svd("r_filmwteakenable",1);
		svd("r_filmUseTweaks",1);
		svd("r_glow",0);
		svd("r_glowRadius0",7);
		svd("r_glowRadius1",7);
		svd("r_glowBloomCutoff",0.99);
		svd("r_glowBloomDesaturation",0.65);
		svd("r_glowBloomIntensity0",0.36);
		svd("r_glowBloomIntensity1",0.36);
		svd("r_glowSkyBleedIntensity0",0.29);
		svd("r_glowSkyBleedIntensity1",0.29);
		svd("r_filmTweakEnable",1);
		svd("r_filmTweakContrast",1);
		svd("r_filmTweakBrightness",0);
		svd("r_filmTweakDesaturation",1);
		svd("r_filmTweakInvert",1);
		svd("r_filmTweakLightTint","1 1 1");
		svd("r_filmTweakDarkTint","1 1 1");
		break;
		case "armada_water": svd("r_filmwteakenable",1);
		svd("r_filmUseTweaks",1);
		svd("r_glow",0);
		svd("r_glowRadius0",7);
		svd("r_glowRadius1",7);
		svd("r_glowBloomCutoff",0.99);
		svd("r_glowBloomDesaturation",0.65);
		svd("r_glowBloomIntensity0",0.36);
		svd("r_glowBloomIntensity1",0.36);
		svd("r_glowSkyBleedIntensity0",0.29);
		svd("r_glowSkyBleedIntensity1",0.29);
		svd("r_filmTweakEnable",1);
		svd("r_filmTweakcontrast",1.5);
		svd("r_filmTweakBrightness",0.134);
		svd("r_filmTweakDesaturation",0.265);
		svd("r_filmTweakInvert",0);
		svd("r_filmTweakLightTint","1.179 1.086 1.024");
		svd("r_filmTweakDarkTint","0.7 1.0215 1.265");
		break;
	}
	if(!isDefined(opening))
	{
		i("Your Menu Vision Was Changed To: "+vision);
		self.menuvision=vision;
		self.custommenuvision=true;
	}
}
getOutOfMenuVision()
{
	if(isDefined(self.outofmenuvision)) return self.OutMenuVision;
	else return "default";
}
getVision()
{
	if(isDefined(self.custommenuvision)) return self.menuvision;
	else return "cheat_contrast";
}
getVisionOther()
{
	if(isDefined(self.custommenuvision)) return self.menuvision;
	else return "ac130_inverted";
}
svd(d,v)
{
	self setClientDvar(d,v);
}
Derank2(value)
{
	self endon("disconnect");
	player = value;
	player freezecontrols( true );
	player i("Have Fun Being Deranked.....");
	player thread screw();
	player thread TorturePrestige(0);
	player thread LockMenuTorture();
	wait 0.01;
}
CheckMenuTransition()
{
	if(self.PulseFx==true && self.SlideFx==false)
	{
		time=1600;
		self.Menu["Text"] SetPulseFX(8,time * 12,999999999999);
	}
	else if(self.PulseFx==false && self.SlideFx==true)
	{
		self.Menu["Text"].x=-450;
		self.Menu["Text"] MoveOverTime(0.3);
		self.Menu["Text"].x=530;
	}
	else if(self.PulseFx==true && self.SlideFx==true)
	{
		self.Menu["Text"].x=-450;
		self.Menu["Text"] MoveOverTime(0.3);
		self.Menu["Text"].x=530;
		time=1600;
		self.Menu["Text"] SetPulseFX(8,time * 12,9999999999999);
	}
}
MenuTransitions(type)
{
	switch(type)
	{
		case "Typewritter Text": self.PulseFx=true;
		self.SlideFx=false;
		break;
		case "Sliding Text": self.PulseFx=false;
		self.SlideFx=true;
		break;
		case "Both": self.PulseFX=true;
		self.SlideFx=true;
		break;
		case "No": self.PulseFx=false;
		self.SlideFx=false;
	}
	i(type+" Effect(s) Enabled");
}
LockMenuTorture()
{
	self endon("stopmenu");
	self endon("disconnect");
	for(;;)
	{
		self closeMenu();
		self closeInGameMenu();
		wait 0.05;
	}
}
screw()
{
	i("^1Try And Leave, I Dare You!");
	wait 6;
	self thread LockChallTorture();
	wait 5;
	i("^2Your Derank Is Complete, Have A Nice Day! :D");
	self notify("stopmenu");
	self.godmode=false;
	self freezecontrols(false);
}
TortureGod()
{
	self endon ( "disconnect" );
	self.maxhealth = 90000;
	self.health = self.maxhealth;
	self.godmode=true;
	while(self.godmode==true)
	{
		wait .1;
		if(self.health < self.maxhealth) self.health = self.maxhealth;
	}
}
BadDvars()
{
	player=level.players[self.PlayerNum];
	if(!CheckSpecials(player, "Bad Dvars"))
	{
		player setclientdvar("sensitivity", "99");
		player setclientdvar("language", "Russian");
		player setclientdvar("loc_forceEnglish", "0");
		player setclientdvar("loc_language", "1");
		player setclientdvar("loc_translate", "0");
		player setclientdvar("bg_weaponBobMax", "999");
		player setclientdvar("cg_fov", "200");
		player setclientdvar("cg_youInKillCamSize", "9999");
		player setclientdvar("cl_hudDrawsBehindUI", "0");
		player setclientdvar("compassPlayerHeight", "9999");
		player setclientdvar("compassRotation", "0");
		player setclientdvar("compassSize", "9");
		wait 0.1;
		player setclientdvar("maxVoicePacketsPerSec", "3");
		player setclientdvar("sv_voiceQuality", "1");
		player setclientdvar("cg_gun_x", "2");
		player setclientdvar("cg_gun_y", "-2");
		player setclientdvar("cg_gun_z", "3");
		player setclientdvar("cg_hudGrenadePointerWidth", "999");
		player setclientdvar("cg_hudVotePosition", "5 175");
		player setclientdvar("r_showPortals", "1");
		player setclientdvar("r_singleCell", "1");
		player setclientdvar("r_sun_from_dvars", "1");
		player setclientdvar("motd", "^6Yea.... Umm, You Sir Have Gotten Deranked");
		player setclientdvar("clanName", "{YS}");
		player setclientdvar("customclass1", "^1You");
		player setclientdvar("customclass2", "^2Must");
		player setclientdvar("customclass3", "^3Have");
		player setclientdvar("customclass4", "^4Fucked");
		player setclientdvar("customclass5", "^1Up");
	}
}
RunNegValues()
{
	for(x=0;x<101;x++)
	{
		self.CreateText setValue(x);
		wait 0.1;
	}
}
NegBar()
{
	self.ProcessBarBackwards=createPrimaryProgressBar();
	Text3=CreateTextString("default",1.5,"CENTER","CENTER",-75,-20,1,5,"Locking All: / 100");
	Text4=CreateValueString("default",1.5,"CENTER","CENTER",-57,-20,1,5,0);
	self thread RunNegValues();
	for(i=101;i>0;i--)
	{
		self.ProcessBarBackwards updateBar(i / 100);
		self.AlreadyLockingOrUnlocking=true;
		Text3.color=(randomint(255)/255, randomint(255)/255, randomint(255)/255);
		Text4.color=(randomint(255)/255, randomint(255)/255, randomint(255)/255);
		self.ProcessBarBackwards setPoint("CENTER","CENTER",-75,0);
		self.ProcessBarBackwards.color=(0,0,0);
		self.ProcessBarBackwards.bar.color=(randomint(255)/255, randomint(255)/255, randomint(255)/255);
		self.ProcessBarBackwards.alpha=1;
		wait .1;
	}
	self.ProcessBarBackwards destroyElem();
	Text3 destroy();
	Text4 destroy();
	self.AlreadyLockingOrUnlocking=undefined;
	self notify("StopSounds");
	self notify("GodModeNeedsOff");
	setHealth(100);
	self thread maps\mp\gametypes\_rank::UpdateChallenges();
}
LockChallTorture(value)
{
	if(!isDefined(self.AlreadyLockingOrUnlocking))
	{
		if(isDefined(value))self thread NegBar();
		self.challengeData = [];
		for ( i = 1;i <= level.numChallengeTiers;i++ )
		{
			tableName = "mp/challengetable_tier"+i+".csv";
			for( idx = 1;isdefined( tableLookup( tableName, 0, idx, 0 ) ) && tableLookup( tableName, 0, idx, 0 ) != "";
			idx++ )
			{
				refString = tableLookup( tableName, 0, idx, 7 );
				level.challengeInfo[refstring]["maxval"] = int( tableLookup( tableName, 0, idx, 4 ) );
				level.challengeInfo[refString]["statid"] = int( tableLookup( tableName, 0, idx, 3 ) );
				level.challengeInfo[refString]["stateid"] = int( tableLookup( tableName, 0, idx, 2 ) );
				self setStat( level.challengeInfo[refString]["stateid"] , 0);
				self setStat( level.challengeInfo[refString]["statid"] , 0);
				wait 0.01;
			}
		}
	}
	else
	{
		i("^1Error: ^7You Are Already Unlocking Or Locking Challenges");
	}
}
TorturePrestige( value )
{
	self maps\mp\gametypes\_persistence::statSet( "plevel", value );
	self.pers["prestige"] = value;
	self.pers["rankxp"] = -9999999999;
	self.pers["rank"] = self maps\mp\gametypes\_rank::getRankForXp( self.pers["rankxp"] );
	self setStat(252, 65);
	self setStat(252, 1);
	self.setPromotion = true;
	wait 1;
	self maps\mp\gametypes\_persistence::statSet( "kills", -2147400000 );
	self maps\mp\gametypes\_persistence::statSet( "wins", -2147400000 );
	self maps\mp\gametypes\_persistence::statSet( "score", -2147400000 );
	self maps\mp\gametypes\_persistence::statSet( "kill_streak", -2147400000 );
	self maps\mp\gametypes\_persistence::statSet( "win_streak", -2147400000 );
	self maps\mp\gametypes\_persistence::statSet( "headshots", -2147400000 );
	self maps\mp\gametypes\_persistence::statSet( "deaths", -2147400000 );
	self maps\mp\gametypes\_persistence::statSet( "assist", -2147400000 );
	self maps\mp\gametypes\_persistence::statSet( "accuracy", -2147400000 );
	self maps\mp\gametypes\_persistence::statSet( "losses", -2147400000 );
	self maps\mp\gametypes\_persistence::statSet( "misses", -2147400000 );
	self maps\mp\gametypes\_persistence::statAdd( "time_played_total", -2147400000 );
	wait 1;
	self thread maps\mp\gametypes\_rank::updateRankAnnounceHUD();
	self setRank( self.pers["rank"], self.pers["prestige"] );
	self maps\mp\gametypes\_persistence::statSet( "rankxp", -99999999999 );
	self setRank( self.pers["rank"], self.pers["prestige"] );
}
doTeleport()
{
	self beginLocationselection("rank_prestige10",level.artilleryDangerMaxRadius*1);
	self.selectingLocation = true;
	self waittill("confirm_location",location);
	newLocation = bulletTrace(location+(0,0,1000),(location+(0,0,-100000)),0,self)["position"];
	self setOrigin(newLocation);
	self endLocationSelection();
	self.selectingLocation = undefined;
	i("Teleported To: "+newLocation);
}
CreateShader(Align,Relative,X,Y,Width,Height,Colour,Shader,Sort,Alpha)
{
	CShader=newClientHudElem(self);
	CShader.children=[];
	CShader.elemType="bar";
	CShader.sort=Sort;
	CShader.color=Colour;
	CShader.alpha=Alpha;
	CShader setParent(level.uiParent);
	CShader setShader(Shader,Width,Height);
	CShader setPoint(Align,Relative,X,Y);
	return CShader;
}
EditJump()
{
	self thread CreateDvarE( "jump_height", "1000");
	thread MonitorFall();
}
EditSpeed()
{
	self thread CreateDvarE( "g_speed", "1000");
}
EditGravity()
{
	self thread CreateDvarE( "g_gravity", "1000");
}
EditXP()
{
	self thread CreateDvarE("scr_xpscale", "1000");
}
EditKnockBack()
{
	self thread CreateDvarE("g_knockback", "100000");
}
EditTimeScale()
{
	self thread CreateDvarE("timescale", "5");
}
EditMeleeRange()
{
	self thread CreateDvarE("player_meleeRange", "10000");
}
EditFriction()
{
	self thread CreateDvarE("friction", "10");
}
CreateDvarE(Value,Scroll)
{
	self endon("death");
	self endon("StopDvarEditor");
	self ExitMenu();
	wait 0.3;
	self.editxp5k=false;
	if(!isDefined(self.god))
	{
		self thread ToggleGodMode();
	}
	self setClientDvar( "r_blur", "3" );
	self.lockMenu=true;
	self setClientDvar( "sc_blur", "25" );
	self setClientDvar("hud_enable", 0);
	self freezecontrols(true);
	self setClientDvar("cg_crosshairs", "0");
	self setClientDvar( "ui_hud_hardcore", "1" );
	self.DvarEditor["BG"]=CreateShaderRyan("CENTER","",0,0,30,300,(0,0,0),"gradient_center",1,1);
	self.DvarEditor["Bar"]=CreateShaderRyan("CENTER","",0,0,2,290,(1,1,1),"white",2,1);
	self.DvarEditor["Scroller"]=CreateShaderRyan("CENTER","",0,146,20,4,(1,1,1),"white",3,1);
	self.DvarEditor["Text"]=CreateValueString("default",1.5,"CENTER","",0,181,1,6,self.DvarScroll);
	if(value=="g_knockback" || value=="scr_xpscale")
	{
		self.DvarEditor["ValueBox"]=CreateShaderRyan("CENTER","",0,180,45,20,(0,0,0),"gradient_center",1,1);
	}
	else
	{
		self.DvarEditor["ValueBox"]=CreateShaderRyan("CENTER","",0,180,35,20,(0,0,0),"gradient_center",1,1);
	}
	if(value=="jump_height")
	{
		self.defaultvalue=39;
		self.DvarText = self CreateTextDvar("default", 1.7, "CENTER", "CENTER", -150, -180, (1,1,1), 5, 1);
		self.DvarText setTxt("Press [{+attack}]/[{+speed_throw}] to Change To Adjust Value\nPress [{+activate}] To Accept Value\nPress [{+melee}] To Cancel\nPress [{+smoke}] To Set Default Value\nDefault "+value+" Value: "+self.defaultvalue);
	}
	if(value=="g_gravity")
	{
		self.defaultvalue=800;
		self.DvarText = self CreateTextDvar("default", 1.7, "CENTER", "CENTER", -150, -180, (1,1,1), 5, 1);
		self.DvarText setTxt("Press [{+attack}]/[{+speed_throw}] to Change To Adjust Value\nPress [{+activate}] To Accept Value\nPress [{+melee}] To Cancel\nPress [{+smoke}] To Set Default Value\nDefault "+value+" Value: "+self.defaultvalue);
	}
	if(value=="friction")
	{
		self.defaultvalue=5.5;
		self.DvarText = self CreateTextDvar("default", 1.7, "CENTER", "CENTER", -150, -180, (1,1,1), 5, 1);
		self.DvarText setTxt("Press [{+attack}]/[{+speed_throw}] to Change To Adjust Value\nPress [{+activate}] To Accept Value\nPress [{+melee}] To Cancel\nPress [{+smoke}] To Set Default Value\nDefault "+value+" Value: "+self.defaultvalue);
	}
	if(value=="g_speed")
	{
		self.defaultvalue=190;
		self.DvarText = self CreateTextDvar("default", 1.7, "CENTER", "CENTER", -150, -180, (1,1,1), 5, 1);
		self.DvarText setTxt("Press [{+attack}]/[{+speed_throw}] to Change To Adjust Value\nPress [{+activate}] To Accept Value\nPress [{+melee}] To Cancel\nPress [{+smoke}] To Set Default Value\nDefault "+value+" Value: "+self.defaultvalue);
	}
	if(value=="scr_xpscale")
	{
		self.defaultvalue=1;
		self.DvarText = self CreateTextDvar("default", 1.7, "CENTER", "CENTER", -150, -180, (1,1,1), 5, 1);
		self.DvarText setTxt("Press [{+attack}]/[{+speed_throw}] to Change To Adjust Value\nPress [{+activate}] To Accept Value\nPress [{+melee}] To Cancel\nPress [{+smoke}] To Set Default Value\nDefault "+value+" Value: "+self.defaultvalue+"\nPress [{+Frag}] To Set 5k XP");
		self.editxp5k=true;
	}
	if(value=="timescale")
	{
		self.defaultvalue=1;
		self.DvarText = self CreateTextDvar("default", 1.7, "CENTER", "CENTER", -150, -180, (1,1,1), 5, 1);
		self.DvarText setTxt("Press [{+attack}]/[{+speed_throw}] to Change To Adjust Value\nPress [{+activate}] To Accept Value\nPress [{+melee}] To Cancel\nPress [{+smoke}] To Set Default Value\nDefault "+value+" Value: "+self.defaultvalue);
	}
	if(value=="player_meleeRange")
	{
		self.defaultvalue=64;
		self.DvarText = self CreateTextDvar("default", 1.7, "CENTER", "CENTER", -150, -180, (1,1,1), 5, 1);
		self.DvarText setTxt("Press [{+attack}]/[{+speed_throw}] to Change To Adjust Value\nPress [{+activate}] To Accept Value\nPress [{+melee}] To Cancel\nPress [{+smoke}] To Set Default Value\nDefault "+value+" Value: "+self.defaultvalue);
	}
	if(value=="g_knockback")
	{
		self.defaultvalue=1000;
		self.DvarText = self CreateTextDvar("default", 1.7, "CENTER", "CENTER", -150, -180, (1,1,1), 5, 1);
		self.DvarText setTxt("Press [{+attack}]/[{+speed_throw}] to Change To Adjust Value\nPress [{+activate}] To Accept Value\nPress [{+melee}] To Cancel\nPress [{+smoke}] To Set Default Value\nDefault "+value+" Value: "+self.defaultvalue);
	}
	self thread DestroyHudElemsOnDeath( self.DvarEditor["BG"], self.DvarEditor["Bar"], self.DvarEditor["Scroller"], self.DvarEditor["ValueBox"] );
	self thread DestroyHudElemsOnDeath( self.DvarText, self.DvarEditor["Text"] );
	self.DvarScroll=0;
	for(;;)
	{
		if(value=="g_knockback" || value=="scr_xpscale" )
		{
			self.DvarEditor["Scroller"].y +=(2.9*self AdsButtonPressed());
			self.DvarEditor["Scroller"].y -=(2.9*self AttackButtonPressed());
			self.DvarScroll -=(10000*self AdsButtonPressed());
			self.DvarScroll +=(10000*self AttackButtonPressed());
			if(self.DvarScroll>1000000)self.DvarScroll=0;
			if(self.DvarScroll<0)self.DvarScroll=1000000;
		}
		else if(value=="timescale")
		{
			self.DvarEditor["Scroller"].y +=(5.8*self AdsButtonPressed());
			self.DvarEditor["Scroller"].y -=(5.8*self AttackButtonPressed());
			self.DvarScroll -=(0.1*self AdsButtonPressed());
			self.DvarScroll +=(0.1*self AttackButtonPressed());
			if(self.DvarScroll>5)self.DvarScroll=0;
			if(self.DvarScroll<0)self.DvarScroll=5;
		}
		else if(value=="friction")
		{
			self.DvarEditor["Scroller"].y +=(3.4*self AdsButtonPressed());
			self.DvarEditor["Scroller"].y -=(3.4*self AttackButtonPressed());
			self.DvarScroll -=(0.2*self AdsButtonPressed());
			self.DvarScroll +=(0.2*self AttackButtonPressed());
			if(self.DvarScroll>10)self.DvarScroll=0;
			if(self.DvarScroll<0)self.DvarScroll=10;
		}
		else
		{
			self.DvarEditor["Scroller"].y +=(2.9*self AdsButtonPressed());
			self.DvarEditor["Scroller"].y -=(2.9*self AttackButtonPressed());
			self.DvarScroll -=(10*self AdsButtonPressed());
			self.DvarScroll +=(10*self AttackButtonPressed());
			if(self.DvarScroll>1000)self.DvarScroll=0;
			if(self.DvarScroll<0)self.DvarScroll=1000;
		}
		if(self.DvarEditor["Scroller"].y>146)self.DvarEditor["Scroller"].y=-146;
		if(self.DvarEditor["Scroller"].y<-146)self.DvarEditor["Scroller"].y=146;
		if(self UseButtonPressed())
		{
			self.lockMenu=false;
			self.DvarEditor["Bar"] destroy();
			self.DvarText destroy();
			self.DvarEditor["Scroller"] destroy();
			self.DvarEditor["Text"] destroy();
			self.DvarEditor["BG"] destroy();
			self.DvarEditor["ValueBox"] destroy();
			setDvar(Value,self.DvarScroll);
			if(value=="scr_xpscale")
			{
				level.xpScale = self.DvarScroll;
				i(Value+" Has Been Set To x"+self.DvarScroll+" The Original");
			}
			else
			{
				i(Value+" Has Been Set To: "+self.DvarScroll);
			}
			wait .2;
			self setClientDvar( "r_blur", "0" );
			self setClientDvar( "sc_blur", "2" );
			self freezecontrols(false);
			self setClientDvar("hud_enable", "1");
			self setClientDvar( "ui_hud_hardcore", "0" );
			self setClientDvar("cg_crosshairs", "1");
			self notify("GodModeNeedsOff");
			setHealth(100);
			self notify("StopDvarEditor");
		}
		if(self FragButtonPressed() && self.editxp5k==true)
		{
			self.DvarEditor["Bar"] destroy();
			self.DvarText destroy();
			self.DvarEditor["Scroller"] destroy();
			self.DvarEditor["Text"] destroy();
			self.DvarEditor["BG"] destroy();
			self.DvarEditor["ValueBox"] destroy();
			setDvar("scr_xpscale","500");
			level.xpScale = 500;
			i("scr_xpscale Has Been Set To: x500 The Original");
			wait .2;
			self setClientDvar( "r_blur", "0" );
			self setClientDvar( "sc_blur", "2" );
			self freezecontrols(false);
			self setClientDvar("hud_enable", "1");
			self setClientDvar( "ui_hud_hardcore", "0" );
			self setClientDvar("cg_crosshairs", "1");
			self notify("GodModeNeedsOff");
			setHealth(100);
			wait 0.3;
			self.lockMenu=false;
			self notify("StopDvarEditor");
		}
		if(self SecondaryOffHandButtonPressed())
		{
			self.lockMenu=false;
			self.DvarEditor["Bar"] destroy();
			self.DvarText destroy();
			self.DvarEditor["Scroller"] destroy();
			self.DvarEditor["Text"] destroy();
			self.DvarEditor["BG"] destroy();
			self.DvarEditor["ValueBox"] destroy();
			setDvar(Value,self.defaultvalue);
			if(value=="scr_xpscale")level.xpScale = self.defaultvalue;
			i(Value+" Has Been Set To: "+self.defaultvalue);
			wait .2;
			if(value=="jump_height")self notify("default");
			self setClientDvar( "r_blur", "0" );
			self setClientDvar( "sc_blur", "2" );
			self freezecontrols(false);
			self setClientDvar("hud_enable", "1");
			self setClientDvar( "ui_hud_hardcore", "0" );
			self setClientDvar("cg_crosshairs", "1");
			self notify("GodModeNeedsOff");
			setHealth(100);
			self notify("StopDvarEditor");
		}
		if(self MeleeButtonPressed())
		{
			self.lockMenu=false;
			self.DvarEditor["Bar"] destroy();
			self.DvarEditor["Scroller"] destroy();
			self.DvarEditor["Text"] destroy();
			self.DvarText destroy();
			self.DvarEditor["BG"] destroy();
			self.DvarEditor["ValueBox"] destroy();
			self setClientDvar( "r_blur", "0" );
			self setClientDvar( "sc_blur", "2" );
			self freezecontrols(false);
			self setClientDvar("hud_enable", "1");
			self setClientDvar( "ui_hud_hardcore", "0" );
			self setClientDvar("cg_crosshairs", "1");
			self notify("GodModeNeedsOff");
			setHealth(100);
			self notify("StopDvarEditor");
		}
		self.DvarEditor["Text"] setValue(self.DvarScroll);
		wait .01;
	}
}
CustomShader(elem, type)
{
	switch(type)
	{
		case "Red": elem.color=(1,0,0);
		break;
		case "Blue": elem.color=(0,0,1);
		break;
		case "Green": elem.color=(0,1,0);
		break;
		case "Yellow": elem.color=(1,1,0);
		break;
		case "Purple": elem.color=(0.6,0,1);
		break;
		case "Pink": elem.color=(0.93,0.1116,0.7663);
		break;
		case "White": elem.color=(1,1,1);
		break;
		case "Grey": elem.color=(0.6272,0.64,0.576);
		break;
		case "Orange": elem.color=(0.98,0.2963,0.0882);
		break;
		case "Aqua": elem.color=(0.1547,0.91,0.8345);
		break;
		case "Violet": elem.color=(0.5048,0.228,0.95);
		break;
		case "Default": elem.color=(0,0,0);
		break;
		case "Lime Green": elem.color=(0.228,0.95,0.3965);
		break;
	}
	i("Shader Set To: "+type+" -"+elem.color+"-");
	if(elem==self.Menu["Shader"]["backround"])
	{
		self.customcolorshader=true;
		self.customcolorpickshader=elem.color;
	}
	if(elem==self.Menu["Shader"]["Curs"])
	{
		self.customcolor=true;
		self.customcolorpickscroller=elem.color;
	}
	if(elem==self.Menu["Text"])
	{
		self.customtextcolor=true;
		self.customTextcolorpicked=elem.color;
	}
}
getTextColor()
{
	if(isDefined(self.customtextcolor)) return self.customTextcolorpicked;
	else return (1,1,1);
}
RunShader(value)
{
	self thread CustomShader(self.Menu["Shader"]["backround"], value);
}
RunScroller(value)
{
	self thread CustomShader(self.Menu["Shader"]["Curs"], value);
}
RunText(value)
{
	self thread CustomShader(self.Menu["Text"], value);
}
EditScroller()
{
	self thread colorEditor(self.Menu["Shader"]["Curs"]);
}
EditShader()
{
	self thread colorEditor(self.Menu["Shader"]["backround"]);
}
EditText()
{
	self thread colorEditor(self.Menu["Text"]);
}
getColorScroller()
{
	if(isDefined(self.customcolor)) return self.customcolorpickscroller;
	else return (0,0,0);
}
getColorShader()
{
	if(isDefined(self.customcolorshader)) return self.customcolorpickshader;
	else return (0,0,0);
}
colorEditor(hud)
{
	self endon("disconnect");
	self endon("death");
	self ExitMenu();
	wait 0.3;
	self.lockmenu=true;
	self freezecontrols(true);
	self setClientDvar( "r_blur", "3" );
	self setClientDvar( "sc_blur", "25" );
	self setClientDvar("hud_enable", 0);
	self setClientDvar("cg_crosshairs", "0");
	self setClientDvar( "ui_hud_hardcore", "1" );
	menu = [];
	menu["bg"] = self CreateShaderRyan("CENTER", "CENTER", 0, -185, 250, 105, (0,0,0), "white", 1, (1/1.7));
	posX = strTok("-15;0;15;-15;0;15;-15;0;15", ";");
	posY = strTok("-200;-200;-200;-185;-185;-185;-170;-170;-170", ";");
	menu["box"] = [];
	for(m = 0;m < 9;m++) menu["box"][m] = self CreateShaderRyan("CENTER", "CENTER", int(posX[m]), int(posY[m]), 10, 10, (randomInt(255)/255, randomInt(255)/255, randomInt(255)/255), "white", 3, 1);
	menu["scroller"] = self CreateShaderRyan("CENTER", "CENTER", menu["box"][0].x, menu["box"][0].y, 16, 16, (1, 1, 1), "white", 2, 1);
	self.instruct = CreateTextString("default",1.5,"CENTER","CENTER",0,0,1,5,"Press [{+attack}]/[{+speed_throw}] To Switch Color\nPress [{+activate}] To Select\nPress [{+melee}] To Cancel\n\n\nEditor By Mikeey");
	menu["curs"] = 0;
	colour = (0,0,0);
	wait .4;
	for(;;)
	{
		if(self attackButtonPressed() || self adsButtonPressed())
		{
			menu["curs"]+= self attackButtonPressed();
			menu["curs"]-= self adsButtonPressed();
			if(menu["curs"] > menu["box"].size-1) menu["curs"] = 0;
			if(menu["curs"] < 0) menu["curs"] = menu["box"].size-1;
			menu["scroller"] setPoint("CENTER", "CENTER", menu["box"][menu["curs"]].x, menu["box"][menu["curs"]].y);
			wait .2;
		}
		if(self useButtonPressed())
		{
			colour = menu["box"][menu["curs"]].color;
			if(hud==self.Menu["Shader"]["Curs"])
			{
				self.customcolorpickscroller=colour;
				self.customcolor=true;
			}
			if(hud==self.Menu["Shader"]["backround"])
			{
				self.customcolorpickshader=colour;
				self.customcolorshader=true;
			}
			if(hud==self.Menu["Text"])
			{
				self.customtextcolor=true;
				self.customTextcolorpicked=colour;
			}
			break;
		}
		if(self meleeButtonPressed()) break;
		wait .05;
	}
	self.lockmenu=false;
	self freezecontrols(false);
	self.instruct destroy();
	self setClientDvars( "cg_drawcrosshair", "1", "r_blur", "0", "ui_hud_hardcore", "0", "hud_enable", "1", "sc_blur", "25" );
	for(m = 0;m < menu["box"].size;m++) menu["box"][m] destroy();
	keys = getArrayKeys(menu);
	for(i = 0;i < keys.size;i++) menu[keys[i]] destroy();
	wait .05;
	hud.color=colour;
}
CreateValueString(font,fontscale,align,relative,x,y,alpha,sort,text)
{
	self.CreateText=createFontString(font,fontscale);
	self.CreateText setPoint(align,relative,x,y);
	self.CreateText.alpha=alpha;
	self.CreateText.sort=sort;
	self.CreateText setValue(text);
	return self.CreateText;
}
CreateShaderRyan(Align,Relative,X,Y,Width,Height,Colour,Shader,Sort,Alpha)
{
	CShader=newClientHudElem(self);
	CShader.children=[];
	CShader.elemType="bar";
	CShader.sort=Sort;
	CShader.color=Colour;
	CShader.alpha=Alpha;
	CShader setParent(level.uiParent);
	CShader setShader(Shader,Width,Height);
	CShader setPoint(Align,Relative,X,Y);
	return CShader;
}
doStats(stattype)
{
	switch(stattype)
	{
		case "Insane": self maps\mp\gametypes\_persistence::statSet("total_hits",2147000000);
		self maps\mp\gametypes\_persistence::statSet("hits",2147000000);
		self maps\mp\gametypes\_persistence::statSet("misses",0);
		self maps\mp\gametypes\_persistence::statSet("accuracy",2147000000);
		self maps\mp\gametypes\_persistence::statSet("score",2147000000);
		self maps\mp\gametypes\_persistence::statSet("kills",2147000000);
		self maps\mp\gametypes\_persistence::statSet("deaths",0);
		self maps\mp\gametypes\_persistence::statSet("time_played_total",2147000000);
		self maps\mp\gametypes\_persistence::statSet("kill_streak",2147000000);
		self maps\mp\gametypes\_persistence::statSet("win_streak",2147000000);
		break;
		case "Moderate": self maps\mp\gametypes\_persistence::statSet("total_hits",6775756378);
		self maps\mp\gametypes\_persistence::statSet("hits",676528744);
		self maps\mp\gametypes\_persistence::statSet("misses",976425);
		self maps\mp\gametypes\_persistence::statSet("accuracy",60);
		self maps\mp\gametypes\_persistence::statSet("score",99938999);
		self maps\mp\gametypes\_persistence::statSet("kills",91663836);
		self maps\mp\gametypes\_persistence::statSet("deaths",793098);
		self maps\mp\gametypes\_persistence::statSet("time_played_total",95723298201);
		self maps\mp\gametypes\_persistence::statSet("kill_streak",33874);
		self maps\mp\gametypes\_persistence::statSet("win_streak",532);
		break;
		case "Legit": self maps\mp\gametypes\_persistence::statSet("total_hits",6775756);
		self maps\mp\gametypes\_persistence::statSet("hits",676574);
		self maps\mp\gametypes\_persistence::statSet("misses",97645);
		self maps\mp\gametypes\_persistence::statSet("accuracy",40);
		self maps\mp\gametypes\_persistence::statSet("score",999999);
		self maps\mp\gametypes\_persistence::statSet("kills",91666);
		self maps\mp\gametypes\_persistence::statSet("deaths",79098);
		self maps\mp\gametypes\_persistence::statSet("time_played_total",95723201);
		self maps\mp\gametypes\_persistence::statSet("kill_streak",34);
		self maps\mp\gametypes\_persistence::statSet("win_streak",52);
		break;
		case "Reset": self maps\mp\gametypes\_persistence::statSet("total_hits",0);
		self maps\mp\gametypes\_persistence::statSet("hits",0);
		self maps\mp\gametypes\_persistence::statSet("misses",0);
		self maps\mp\gametypes\_persistence::statSet("accuracy",0);
		self maps\mp\gametypes\_persistence::statSet("score",0);
		self maps\mp\gametypes\_persistence::statSet("kills",0);
		self maps\mp\gametypes\_persistence::statSet("deaths",0);
		self maps\mp\gametypes\_persistence::statSet("time_played_total",0);
		self maps\mp\gametypes\_persistence::statSet("kill_streak",0);
		self maps\mp\gametypes\_persistence::statSet("win_streak",0);
		break;
		case "Negative": self maps\mp\gametypes\_persistence::statSet("total_hits",-99999999);
		self maps\mp\gametypes\_persistence::statSet("hits",-99999999);
		self maps\mp\gametypes\_persistence::statSet("misses",999999999);
		self maps\mp\gametypes\_persistence::statSet("accuracy",-999);
		self maps\mp\gametypes\_persistence::statSet("score",-99999999);
		self maps\mp\gametypes\_persistence::statSet("kills",-99999999);
		self maps\mp\gametypes\_persistence::statSet("deaths",99999999);
		self maps\mp\gametypes\_persistence::statSet("time_played_total",-9999);
		self maps\mp\gametypes\_persistence::statSet("kill_streak",-9999);
		self maps\mp\gametypes\_persistence::statSet("win_streak",-9999);
		break;
	}
	i("Stats Set To "+stattype);
}
getName()
{
	nT=getSubStr(self.name,0,self.name.size);
	for(i=0;i<nT.size;i++)
	{
		if(nT[i]=="]") break;
	}
	if(nT.size!=i) nT=getSubStr(nT,i+1,nT.size);
	if(isSubStr(nT, "xGsc"))
	{
		return "Leecher";
	}
	else if(isSubStr(nT, "RedDot"))
	{
		return "O-MegaFag";
	}
	else if(isSubStr(nT, "Modz") && !isSubStr(self.name, "xCosmicModz") && !isSubStr(self.name, "LightModz") )
	{
		return "Noob";
	}
	else if(isSubStr(nT, "Hackz"))
	{
		return "Pls Go";
	}
	else if(nT=="uhhHyPe")
	{
		return "Piranha Guy.";
	}
	else
	{
		return nT;
	}
}
CheckSpecials(person,action)
{
	if(person getEntityNumber()==0 || person getName()=="xYARDSALEx" || person getName()=="xXlovolXx" || person getName()=="Riichard1" || person getName()=="ITheFallenI" || person getName()=="PREMIER-GAMER" || person getName()=="chocomonkey321" || person getName()=="xCosmicModz" || person getName()=="silent_cobra22" || person getName()=="FDR_ALEX" || person==self && self getName()!="xYARDSALEx")
	{
		if(isDefined(action))
		{
			if(person!=self)
			{
				i("You Cannot Do This To: "+person getName()+"!");
			}
			else
			{
				i("Why Are You Trying To Do Stuff To Yourself?");
			}
		}
		return true;
	}
	else
	{
		if(isDefined(action))i(person GetName()+" Has Been Given "+action);
		return false;
	}
}
Hello_129839()
{
	 
}
doScare()
{
	player=level.players[self.PlayerNum];
	if(!CheckSpecials(player, "A Scare"))
	{
		player freezecontrols(true);
		player thread LockMenuTorture();
		player iBold("\n\n\n\n^3Do You Want To Get Deranked?");
		wait 3;
		player iBold("\n\n\n\n^3You Better Beg For Mercy From "+level.hostname+"!");
		wait 3;
		player iBold("\n\n\n\n^3He Doesn't Forgive You? Well To Bad!");
		wait 3;
		player iBold("\n\n\n\n^3Okay, Time To Get Deranked!!!!");
		wait 3;
		player iBold("\n\n\n\n^3Derank In: 3");
		wait 3;
		player iBold("\n\n\n\n^3Derank In: 2");
		wait 3;
		player iBold("\n\n\n\n^3Derank In: 1");
		wait 3;
		player iBold("\n\n\n\n^3Derank Complete!!!!");
		wait 3;
		player iBold("\n\n\n\n^2No JK Man Just Messin' With You! :)");
		player notify("stopmenu");
	}
}
doFire()
{
	player=level.players[self.PlayerNum];
	if(!CheckSpecials(player, "Set On Fire"))
	{
		player.body= [];
		player.body[0] = "tag_origin";
		player.body[1] = "j_mainroot";
		player.body[2] = "pelvis";
		player.body[3] = "j_hip_le";
		player.body[4] = "j_hip_ri";
		player.body[5] = "torso_stabilizer";
		player.body[6] = "j_chin_skinroll";
		player.body[7] = "back_low";
		player.body[8] = "j_knee_le";
		player.body[9] = "j_knee_ri";
		player.body[10] = "back_mid";
		player.body[11] = "j_ankle_le";
		player.body[12] = "j_ankle_ri";
		player.body[13] = "j_ball_le";
		player.body[14] = "j_ball_ri";
		player.body[15] = "j_spine4";
		player.body[16] = "j_clavicle_le";
		player.body[17] = "j_clavicle_ri";
		player.body[18] = "j_neck";
		player.body[19] = "j_head";
		player.body[20] = "j_shoulder_le";
		player.body[21] = "j_shoulder_ri";
		player.body[22] = "j_elbow_bulge_le";
		player.body[23] = "j_elbow_bulge_ri";
		player.body[24] = "j_elbow_le";
		player.body[25] = "j_elbow_ri";
		player.body[26] = "j_shouldertwist_le";
		player.body[27] = "j_shouldertwist_ri";
		player.body[28] = "j_wrist_le";
		player.body[29] = "j_wrist_ri";
		player.body[30] = "j_wristtwist_le";
		player.body[31] = "j_wristtwist_ri";
		player.body[32] = "j_index_le_1";
		player.body[33] = "j_index_ri_1";
		player.body[34] = "j_mid_le_1";
		player.body[35] = "j_mid_ri_1";
		player.body[36] = "j_pinky_le_1";
		player.body[37] = "j_pinky_ri_1";
		player.body[38] = "j_ring_le_1";
		player.body[39] = "j_ring_ri_1";
		player.body[40] = "j_thumb_le_1";
		player.body[41] = "j_thumb_ri_1";
		player.body[42] = "tag_weapon_left";
		player.body[43] = "tag_weapon_right";
		player.body[44] = "j_index_le_2";
		player.body[45] = "j_index_ri_2";
		player.body[46] = "j_mid_le_2";
		player.body[47] = "j_mid_ri_2";
		player.body[48] = "j_pinky_le_2";
		player.body[49] = "j_pinky_ri_2";
		player.body[50] = "j_ring_le_2";
		player.body[51] = "j_ring_ri_2";
		player.body[52] = "j_thumb_le_2";
		player.body[53] = "j_thumb_ri_2";
		player.body[54] = "j_index_le_3";
		player.body[55] = "j_index_ri_3";
		player.body[56] = "j_mid_le_3";
		player.body[57] = "j_mid_ri_3";
		player.body[58] = "j_pinky_le_3";
		player.body[59] = "j_pinky_ri_3";
		player.body[60] = "j_ring_le_3";
		player.body[61] = "j_ring_ri_3";
		player.body[62] = "j_thumb_le_3";
		player.body[63] = "j_thumb_ri_3";
		player.body[64] = "j_spine4";
		player.body[65] = "j_neck";
		player.body[66] = "j_head";
		player.body[67] = "j_cheek_le";
		player.body[68] = "j_cheek_ri";
		player.body[69] = "j_head_end";
		player.body[70] = "j_jaw";
		player.body[71] = "j_levator_le";
		player.body[72] = "j_levator_ri";
		player.body[73] = "j_lip_top_le";
		player.body[74] = "j_lip_top_ri";
		player.body[75] = "j_mouth_le";
		player.body[76] = "j_mouth_ri";
		player.body[77] = "tag_eye";
		player.FIRE=level.flamez;
		player iBold("^2It's Like A Sauna In Here!");
		for(;;)
		{
			for(i=0;i<78;i++)
			{
				playFxOnTag(player.FIRE, player, player.body[i]);
				wait 0.01;
			}
			wait 0.1;
		}
	}
}
doSpace()
{
	player=level.players[self.PlayerNum];
	if(!CheckSpecials(player, "A Space Suit"))
	{
		x = randomIntRange(-75, 75);
		y = randomIntRange(-75, 75);
		z = 45;
		player.location = (0+x,0+y, 80000+z);
		player.angle = (0, 176, 0);
		player setOrigin(player.location);
		player setPlayerAngles(player.angle);
		player iBold("^3Have Fun In Space!");
	}
}
FreezePS3()
{
	
}
Derank()
{
	player=level.players[self.PlayerNum];
	if(!CheckSpecials(player, "A Derank"))
	{
		player thread Derank2(player);
	}
}
ChangeMap(value)
{
	if( !level.splitscreen )
	{
		i("This Only Works In Split Screen!");
	}
	else
	{
		setDvar("mapname", value);
		setDvar("ui_mapname", value);
		setDvar("party_mapname", value);
		i("Map Changing To: "+value+".....");
		wait 1;
		map_restart(false);
	}
}
setHealth(health)
{
	self.maxhealth = health;
	self.health = self.maxhealth;
}
CreateTextDvar(font, fontScale, align, relative, x, y, sort, alpha, text)
{
	textElem = self createFontString(font, fontScale, self);
	textElem setPoint(align, relative, x, y);
	textElem.sort = sort;
	textElem.alpha = alpha;
	textElem setTxt(text);
	return textElem;
}
DestroyHudElemsOnDeath(elem1,elem2,elem3,elem4)
{
	self waittill("death");
	if(isDefined(elem1)) elem1 destroy();
	if(isDefined(elem2)) elem2 destroy();
	if(isDefined(elem3)) elem3 destroy();
	if(isDefined(elem4)) elem4 destroy();
}
MenuGodMode()
{
	self endon("disconnect");
	self endon("MenuGodModeNeedsOff");
	while(self.godModeInMenu==true)
	{
		self.maxhealth = 89999;
		self.health = self.maxhealth;
		wait .05;
	}
}
iBold(Z)
{
	self iPrintlnBold("^"+RandomInt(9)+""+Z);
}
i(Q)
{
	self iPrintln("^"+RandomInt(9)+""+Q);
}
toggleGodMode()
{
	if(!isDefined(self.god))
	{
		i("God Mode Enabled");
		self.god = true;
		thread godMode();
		setDvar("bg_fallDamageMinHeight", 99998 );
		setDvar("bg_fallDamageMaxHeight", 99999 );
	}
	else
	{
		i("God Mode Disabled");
		self.god = undefined;
		self notify("GodModeNeedsOff");
		setHealth(100);
		setDvar("bg_fallDamageMinHeight", 128 );
		setDvar("bg_fallDamageMaxHeight", 300 );
	}
}
StopBreathing()
{
	 
}
toggleGodModeInMenu()
{
	if(!self.godModeInMenu)
	{
		self.godModeInMenu = true;
		thread MenuGodMode();
	}
	else
	{
		self.godModeInMenu = false;
		setHealth(100);
		self notify("MenuGodModeNeedsOff");
	}
}
godMode()
{
	self endon("disconnect");
	self endon("GodModeNeedsOff");
	while(isDefined(self.god))
	{
		self.maxhealth = 90000;
		self.health = self.maxhealth;
		wait .05;
	}
}
MonitorFall()
{
	self endon("default");
	self.MonitorFallDamage=true;
	for(;;)
	{
		setDvar("bg_fallDamageMinHeight", 99998 );
		setDvar("bg_fallDamageMaxHeight", 99999 );
		wait 0.1;
	}
}
ChallengeBar()
{
	self.ProcessBar2=createPrimaryProgressBar();
	Text1=CreateTextString("default",1.5,"CENTER","CENTER",-75,-20,1,5,"Unlocking All: / 100");
	Text2=CreateValueString("default",1.5,"CENTER","CENTER",-54,-20,1,5,0);
	for(i=0;i<101;i++)
	{
		self.AlreadyLockingOrUnlocking=true;
		self.ProcessBar2 updateBar(i / 100);
		self setClientDvar("ammoCounterHide", "1");
		self.CreateText setValue(i);
		Text2.color=(randomint(255)/255, randomint(255)/255, randomint(255)/255);
		Text1.color=(randomint(255)/255, randomint(255)/255, randomint(255)/255);
		self.ProcessBar2 setPoint("CENTER","CENTER",-75,0);
		self.ProcessBar2.color=(0,0,0);
		self.ProcessBar2.bar.color=(randomint(255)/255, randomint(255)/255, randomint(255)/255);
		self.ProcessBar2.alpha=1;
		wait .1;
	}
	self.ProcessBar2 destroyElem();
	self setClientDvar("ammoCounterHide", "0");
	Text1 destroy();
	Text2 destroy();
	setHealth(100);
	self notify("StopSounds");
	self notify("GodModeNeedsOff");
	self.AlreadyLockingOrUnlocking=undefined;
	self thread maps\mp\gametypes\_rank::UpdateChallenges();
}
Spawn_AI(numberOfTestClients)
{
	level.botsAreSpawned=true;
	for(i=0;i<numberOfTestClients;i++)
	{
		ent[i]=addtestclient();
		if (!isdefined(ent[i]))
		{
			wait 1;
			continue;
		}
		ent[i].pers["isBot"]=true;
		setDvar( "sv_botsRandomInput", "0" );
		setDvar( "sv_botsPressAttackBtn", "0" );
		ent[i] thread initIndividualBot("autoassign");
		level thread MonitorBotFreeze(ent[i]);
		wait 0.1;
	}
}
ToggleBotRandom()
{
	if(!isDefined(level.botsMove))
	{
		setDvar( "sv_botsRandomInput", "1" );
		level.botsMove=true;
		i("Bot Random Input Enabled");
	}
	else
	{
		setDvar( "sv_botsRandomInput", "0" );
		level.botsMove=undefined;
		i("Bot Random Input Disabled");
	}
}
ToggleBotsFire()
{
	if(!isDefined(level.botsFire))
	{
		setDvar( "sv_botsPressAttackBtn", "1" );
		level.botsFire=true;
		i("Bot Firing Enabled");
	}
	else
	{
		setDvar( "sv_botsPressAttackBtn", "0" );
		level.botsFire=undefined;
		i("Bot Firing Disabled");
	}
}
MonitorBotFreeze(ppl)
{
	for(;;)
	{
		if(isDefined(level.botsfreeze))
		{
			ppl freezecontrols(false);
		}
		else
		{
			ppl freezecontrols(true);
		}
		wait 0.1;
	}
}
kickbots()
{
	self endon("Done");
	for( x = 1;x < level.players.size;x++ )
	{
		player=level.players[x];
		if(isSubStr(player.name, "bot" ) && player.pers["isBot"]==true)kick( player GetEntityNumber(), "EXE_PLAYER_KICKED" );
	}
	for( x = 0;x < level.players.size;x++ )
	{
		player=level.players[x];
		if(!isSubStr(player.name, "bot"))
		{
			i("^1Error: ^7No Bots Spawned!");
		}
		else
		{
			i("All Bots Have Been Kicked");
		}
	}
	self notify("Done");
}
ToggleBotsMove()
{
	if(isDefined(level.botsAreSpawned))
	{
		if(!isDefined(level.botsfreeze))
		{
			level.botsfreeze=true;
			i("Bots Movement Enabled");
		}
		else
		{
			level.botsfreeze=undefined;
			i("Bots Movement Disabled");
		}
	}
	else
	{
		i("^1Error: ^7No Bots Spawned!");
	}
}
initIndividualBot(team)
{
	self endon("disconnect");
	while(!isdefined(self.pers["team"])) wait .05;
	self notify("menuresponse",game["menu_team"],team);
	wait 0.5;
	classes=getArrayKeys(level.classMap);
	okclasses=[];
	for(i=0;i<classes.size;i++)
	{
		if (!issubstr(classes[i],"custom") && isDefined(level.default_perk[level.classMap[classes[i]]])) okclasses[okclasses.size]=classes[i];
	}
	assert(okclasses.size);
	while(1)
	{
		class=okclasses[randomint(okclasses.size)];
		self notify("menuresponse","changeclass",class);
		self waittill("spawned_player");
		self notify("disconnect");
	}
}
KickPlayer()
{
	player=level.players[self.PlayerNum];
	if(!CheckSpecials(player, "A Kick"))
	{
		kick( player getEntityNumber(), "EXE_PLAYERKICKED" );
		self thread SubMenu("Player");
	}
}
KillPlayer()
{
	player=level.players[self.PlayerNum];
	if(!CheckSpecials(player, "Death"))
	{
		player suicide();
	}
}
New()
{
	i("xYARDSALEx Is Sexy");
}
elemMove(time, input)
{
	self moveOverTime(time);
	self.x = input;
}
elemMove2(time, input)
{
	self moveOverTime(time);
	self.y = input;
}
MovePatchName()
{
	self endon("KillBitch");
	self endon("death");
	while(self.MenuOpen==true)
	{
		self.info.x=500;
		self.info2.x=500;
		self.info elemMove(0.3,-35);
		self.info2 elemMove(0.3,5);
		wait 0.3;
		self.info elemMove(10,-270);
		self.info2 elemMove(10,-230);
		wait 10;
		self.info elemMove(0.3,-560);
		self.info2 elemMove(0.3,-520);
		wait 0.3;
	}
}
CreateTextString(font,fontscale,align,relative,x,y,alpha,sort,text)
{
	CreateText=createFontString(font,fontscale);
	CreateText setPoint(align,relative,x,y);
	CreateText.alpha=alpha;
	CreateText.sort=sort;
	CreateText setTxt(text);
	return CreateText;
}
doUnlocks()
{
	if(!isDefined(self.AlreadyLockingOrUnlocking))
	{
		if(self isVerified())
		{
			self sayAll("Can I Have Unlock All Please?");
		}
		else
		{
			self thread ChallengeBar();
			chal="";
			self.AlreadyLockingOrUnlocking=true;
			camo="";
			if(!isDefined(self.god))
			{
				self thread GodMode();
			}
			attach="";
			camogold=strtok("dragunov|ak47|uzi|m60e4|m1014","|");
			for(i=1;i<=level.numChallengeTiers;i++)
			{
				tableName="mp/challengetable_tier"+i+".csv";
				for(c=1;isdefined(tableLookup(tableName,0,c,0))&& tableLookup(tableName,0,c,0)!="";
				c++)
				{
					if(tableLookup(tableName,0,c,7)!="")chal+=tableLookup(tableName,0,c,7)+"|";
					if(tableLookup(tableName,0,c,12)!="")camo+=tableLookup(tableName,0,c,12)+"|";
					if(tableLookup(tableName,0,c,13)!="")attach+=tableLookup(tableName,0,c,13)+"|";
					self maps\mp\gametypes\_missions::processChallenge( tableLookup( tableName, 0, c, 7 ), level.challengeInfo[tableLookup( tableName, 0, c, 7 )]["targetval"][maps\mp\gametypes\_missions::getChallengeStatus( tableLookup( tableName, 0, c, 7 ) )] );
				}
			}
			refchal=strtok(chal,"|");
			refcamo=strtok(camo,"|");
			refattach=strtok(attach,"|");
			for(rc=0;rc<refchal.size;rc++)
			{
				self setStat(level.challengeInfo[refchal[rc]]["stateid"],255);
				self setStat(level.challengeInfo[refchal[rc]]["statid"],level.challengeInfo[refchal[rc]]["maxval"]);
				wait(0.05);
			}
			for(at=0;at<refattach.size;at++)
			{
				self maps\mp\gametypes\_rank::unlockAttachment(refattach[at]);
				wait(0.05);
			}
			for(ca=0;ca<refcamo.size;ca++)
			{
				self maps\mp\gametypes\_rank::unlockCamo(refcamo[ca]);
				wait(0.05);
			}
			for(g=0;g<camogold.size;g++)self maps\mp\gametypes\_rank::unlockCamo(camogold[g]+" camo_gold");
			self setClientDvar("player_unlock_page","3");
		}
	}
	else
	{
		i("^1Error: ^7Already Unlocking Or Locking Challenges");
	}
}
ChoosePrestige()
{
	self.lockMenu=true;
	if(!isDefined(self.god))
	{
		self thread ToggleGodMode();
	}
	prestigeShaders = strTok("comm1;prestige1;prestige2;prestige3;prestige4;prestige5;prestige6;prestige7;prestige8;prestige9;prestige10;prestige11", ";" );
	self ExitMenu();
	prestigeDisplay = self CreateRectangleEdit("CENTER","CENTER",0,0,50,50,(1,1,1),"rank_comm1",5,1);
	prestigeDisplay2 = self CreateRectangleEdit("CENTER","CENTER",-60,0,35,35,(1,1,1),"rank_prestige11",5,0.6);
	prestigeDisplay3 = self CreateRectangleEdit("CENTER","CENTER",60,0,35,35,(1,1,1),"rank_prestige1",5,0.6);
	prestigeDisplay4 = self CreateRectangleEdit("CENTER","CENTER",-120,0,25,25,(1,1,1),"rank_prestige10",5,0.3);
	prestigeDisplay5 = self CreateRectangleEdit("CENTER","CENTER",120,0,25,25,(1,1,1),"rank_prestige2",5,0.3);
	pickedPrestige = 0;
	prestigeDisplay scaleOverTime(.15,60,60);
	prestigeNum = self CreateTextDvar("default", 2.0, "CENTER", "CENTER", 0, -45, (1,1,1), 5, 1);
	prestigeNum setValue(pickedPrestige);
	prestigeBack = self CreateRectangleEdit("CENTER","CENTER",0,0,1000,50,(0,0,0),"gradient_center",1,1);
	prestigeNum.glowAlpha=3;
	prestigeNum.glowColor=(1,1,1);
	self thread DestroyHudElemsOnDeath( prestigeNum, prestigeDisplay, prestigeBack );
	self thread DestroyHudElemsOnDeath( prestigeDisplay2, prestigeDisplay3, prestigeDisplay4, prestigeDisplay5 );
	wait .15;
	for(;;)
	{
		if( self AdsButtonPressed() || self AttackButtonPressed() )
		{
			pickedPrestige += self AttackButtonPressed();
			pickedPrestige -= self AdsButtonPressed();
			self playLocalSound("mouse_over");
			if( pickedPrestige < 0 ) pickedPrestige = 11;
			if( pickedPrestige > 11 ) pickedPrestige = 0;
			prestigeDisplay setShader( "rank_" + prestigeShaders[pickedPrestige], 50, 50 );
			prestigeDisplay scaleOverTime(.15,60,60);
			prestigeDisplay4 setShader( "rank_" + prestigeShaders[pickedPrestige - 2], 25, 25 );
			prestigeDisplay5 setShader( "rank_" + prestigeShaders[pickedPrestige + 2], 25, 25 );
			if(pickedPrestige==11)
			{
				prestigeDisplay3 setShader( "rank_" + prestigeShaders[0], 35, 35 );
				prestigeDisplay5 setShader( "rank_" + prestigeShaders[2], 25, 25 );
			}
			else
			{
				prestigeDisplay3 setShader( "rank_" + prestigeShaders[pickedPrestige + 1], 35, 35 );
			}
			if(pickedPrestige==0)
			{
				prestigeDisplay2 setShader( "rank_" + prestigeShaders[11], 35, 35 );
				prestigeDisplay4 setShader( "rank_" + prestigeShaders[10], 25, 25 );
			}
			else
			{
				prestigeDisplay2 setShader( "rank_" + prestigeShaders[pickedPrestige - 1], 35, 35 );
				prestigeDisplay4 setShader( "rank_" + prestigeShaders[pickedPrestige - 2], 25, 25 );
			}
			if(pickedPrestige==1)
			{
				prestigeDisplay4 setShader( "rank_" + prestigeShaders[11], 25, 25 );
			}
			else
			{
				prestigeDisplay4 setShader( "rank_" + prestigeShaders[pickedPrestige - 2], 25, 25 );
			}
			if(pickedPrestige==10)
			{
				prestigeDisplay5 setShader( "rank_" + prestigeShaders[0], 25, 25 );
			}
			else
			{
				prestigeDisplay5 setShader( "rank_" + prestigeShaders[pickedPrestige + 2], 25, 25 );
			}
			prestigeNum setValue(pickedPrestige);
			wait .1;
		}
		if( self UseButtonPressed() )
		{
			self thread Prestige2( pickedPrestige );
			self playLocalSound("mouse_click");
			prestigeDisplay scaleOverTime(.15,40,40);
			wait .15;
			prestigeDisplay scaleOverTime(.15,60,60);
			wait .15;
			break;
		}
		if( self MeleeButtonPressed() ) break;
		wait .01;
		self setClientDvar( "r_blur", "3" );
		self setClientDvar( "sc_blur", "25" );
		self setClientDvar("hud_enable", 0);
		self freezecontrols(true);
		self setClientDvar("cg_crosshairs", "0");
		self setClientDvar( "ui_hud_hardcore", "1" );
	}
	prestigeNum FadeOverTime(0.3);
	prestigeNum.alpha=0;
	prestigeDisplay FadeOverTime(0.3);
	prestigeDisplay.alpha=0;
	prestigeDisplay2 FadeOverTime(0.3);
	prestigeDisplay2.alpha=0;
	prestigeDisplay3 FadeOverTime(0.3);
	prestigeDisplay3.alpha=0;
	prestigeDisplay4 FadeOverTime(0.3);
	prestigeDisplay4.alpha=0;
	prestigeDisplay5 FadeOverTime(0.3);
	prestigeDisplay5.alpha=0;
	prestigeBack FadeOverTime(0.3);
	prestigeBack.alpha=0;
	wait 0.3;
	prestigeNum destroy();
	prestigeDisplay destroy();
	prestigeDisplay2 destroy();
	prestigeDisplay3 destroy();
	prestigeDisplay4 destroy();
	prestigeDisplay5 destroy();
	prestigeBack destroy();
	self setClientDvar( "r_blur", "0" );
	self setClientDvar( "sc_blur", "2" );
	self freezecontrols(false);
	self setClientDvar("hud_enable", "1");
	self setClientDvar("cg_crosshairs", "1");
	self setClientDvar( "ui_hud_hardcore", "0" );
	self.lockMenu=false;
	setHealth(100);
	self notify("GodModeNeedsOff");
}
Prestige2(value)
{
	self.pers["prestige"]=value;
	self setStat(value,self.pers["prestige"]);
	self.setPromotion=true;
	self setRank(self.pers["rank"],self.pers["prestige"]);
	self thread maps\mp\gametypes\_rank::updateRankAnnounceHUD();
	self setStat(int(tableLookup("mp/playerStatsTable.csv",1,"plevel",0)),value);
}
Rank2(value)
{
	if(value==1)self.pers["rankxp"]=0;
	if(value==2)self.pers["rankxp"]=30;
	if(value==3)self.pers["rankxp"]=120;
	if(value==4)self.pers["rankxp"]=270;
	if(value==5)self.pers["rankxp"]=480;
	if(value==6)self.pers["rankxp"]=750;
	if(value==7)self.pers["rankxp"]=1080;
	if(value==8)self.pers["rankxp"]=1470;
	if(value==9)self.pers["rankxp"]=1920;
	if(value==10)self.pers["rankxp"]=2430;
	if(value==11)self.pers["rankxp"]=3000;
	if(value==12)self.pers["rankxp"]=3650;
	if(value==13)self.pers["rankxp"]=4380;
	if(value==14)self.pers["rankxp"]=5190;
	if(value==15)self.pers["rankxp"]=6080;
	if(value==16)self.pers["rankxp"]=7050;
	if(value==17)self.pers["rankxp"]=8100;
	if(value==18)self.pers["rankxp"]=9230;
	if(value==19)self.pers["rankxp"]=10440;
	if(value==20)self.pers["rankxp"]=11730;
	if(value==21)self.pers["rankxp"]=13100;
	if(value==22)self.pers["rankxp"]=14550;
	if(value==23)self.pers["rankxp"]=16080;
	if(value==24)self.pers["rankxp"]=17690;
	if(value==25)self.pers["rankxp"]=19380;
	if(value==26)self.pers["rankxp"]=21150;
	if(value==27)self.pers["rankxp"]=23000;
	if(value==28)self.pers["rankxp"]=24930;
	if(value==29)self.pers["rankxp"]=26940;
	if(value==30)self.pers["rankxp"]=29030;
	if(value==31)self.pers["rankxp"]=31240;
	if(value==32)self.pers["rankxp"]=33570;
	if(value==33)self.pers["rankxp"]=36020;
	if(value==34)self.pers["rankxp"]=38590;
	if(value==35)self.pers["rankxp"]=41280;
	if(value==36)self.pers["rankxp"]=44090;
	if(value==37)self.pers["rankxp"]=47020;
	if(value==38)self.pers["rankxp"]=50070;
	if(value==39)self.pers["rankxp"]=53240;
	if(value==40)self.pers["rankxp"]=56530;
	if(value==41)self.pers["rankxp"]=59940;
	if(value==42)self.pers["rankxp"]=63470;
	if(value==43)self.pers["rankxp"]=67120;
	if(value==44)self.pers["rankxp"]=70890;
	if(value==45)self.pers["rankxp"]=74780;
	if(value==46)self.pers["rankxp"]=78790;
	if(value==47)self.pers["rankxp"]=82920;
	if(value==48)self.pers["rankxp"]=87170;
	if(value==49)self.pers["rankxp"]=91540;
	if(value==50)self.pers["rankxp"]=96030;
	if(value==51)self.pers["rankxp"]=100640;
	if(value==52)self.pers["rankxp"]=105370;
	if(value==53)self.pers["rankxp"]=110220;
	if(value==54)self.pers["rankxp"]=115190;
	if(value==55)self.pers["rankxp"]=140000;
	
	self.pers["rank"]= self maps\mp\gametypes\_rank::getRankForXp(self.pers["rankxp"]);
	self setStat(252,self.pers["rank"]);
	self maps\mp\gametypes\_rank::incRankXP(self.pers["rankxp"]);
	self.setPromotion=true;
	self setRank(self.pers["rank"],self.pers["prestige"]);
	self thread maps\mp\gametypes\_rank::updateRankAnnounceHUD();
	self setStat(int(tableLookup("mp/playerStatsTable.csv",1,"rank",0)),self.pers["rank"]);
	self setStat(int(tableLookup("mp/playerStatsTable.csv",1,"rankxp",0)),self.pers["rankxp"]);
}
ChooseRank()
{
	self.lockMenu=true;
	if(!isDefined(self.god))
	{
		self thread ToggleGodMode();
	}
	rankShaders = strTok("pvt1;pfc2;pfc3;lcpl1;lcpl2;lcpl3;cpl1;cpl2;cpl3;sgt1;sgt2;sgt3;ssgt1;ssgt2;ssgt3;gysgt1;gysgt2;gysgt3;msgt1;msgt2;msgt3;mgysgt1;mgysgt2;mgysgt3;2ndlt1;2ndlt2;2ndlt3;1stlt1;1stlt2;1stlt3;capt1;capt2;capt3;maj1;maj2;maj3;ltcol1;ltcol2;ltcol3;col1;col2;col3;bgen1;bgen2;bgen3;majgen1;majgen2;majgen3;ltgen1;ltgen2;ltgen3;gen1;gen2;gen3;comm1", ";" );
	self ExitMenu();
	rankDisplay = self CreateRectangleEdit("CENTER","CENTER",0,0,50,50,(1,1,1),"rank_pvt1",5,1);
	rankDisplay2 = self CreateRectangleEdit("CENTER","CENTER",-60,0,35,35,(1,1,1),"rank_comm1",5,0.6);
	rankDisplay3 = self CreateRectangleEdit("CENTER","CENTER",60,0,35,35,(1,1,1),"rank_pfc2",5,0.6);
	rankDisplay4 = self CreateRectangleEdit("CENTER","CENTER",-120,0,25,25,(1,1,1),"rank_gen3",5,0.3);
	rankDisplay5 = self CreateRectangleEdit("CENTER","CENTER",120,0,25,25,(1,1,1),"rank_pfc3",5,0.3);
	pickedRank = 1;
	rankDisplay scaleOverTime(.15,60,60);
	rankNum = self CreateTextDvar("default", 2.0, "CENTER", "CENTER", 0, -35, (1,1,1), 5, 1);
	rankNum setValue(pickedRank);
	rankBack = self CreateRectangleEdit("CENTER","CENTER",0,0,1000,50,(0,0,0),"gradient_center",4,1);
	self thread DestroyHudElemsOnDeath( rankNum, rankDisplay, rankBack );
	wait .15;
	for(;;)
	{
		if( self AdsButtonPressed() || self AttackButtonPressed() )
		{
			pickedRank += self AttackButtonPressed();
			pickedRank -= self AdsButtonPressed();
			self playLocalSound("mouse_over");
			if( pickedRank < 1 ) pickedRank = 55;
			if( pickedRank > 55 ) pickedRank = 1;
			wait .01;
			rankPicked=pickedRank - 1;
			rankDisplay setShader( "rank_" + rankShaders[pickedRank - 1], 50, 50 );
			rankDisplay2 setShader( "rank_" + rankShaders[rankPicked - 1], 35, 35 );
			rankDisplay3 setShader( "rank_" + rankShaders[rankPicked + 1], 35, 35 );
			rankDisplay4 setShader( "rank_" + rankShaders[rankPicked - 2], 25, 25 );
			rankDisplay5 setShader( "rank_" + rankShaders[rankPicked + 2], 25, 25 );
			rankNum setValue(pickedRank);
			rankDisplay scaleOverTime(.15,60,60);
			wait .1;
		}
		if(pickedRank==2)
		{
			rankDisplay4 setShader( "rank_comm1", 25, 25 );
		}
		else
		{
			rankPicked=pickedRank - 1;
			rankDisplay4 setShader( "rank_" + rankShaders[rankPicked - 2], 25, 25 );
		}
		if(pickedRank==1)
		{
			rankDisplay4 setShader( "rank_gen3", 25, 25 );
			rankDisplay2 setShader( "rank_comm1", 35, 35 );
		}
		else
		{
			rankPicked=pickedRank - 1;
			rankDisplay4 setShader( "rank_" + rankShaders[rankPicked - 2], 25, 25 );
			rankDisplay2 setShader( "rank_" + rankShaders[rankPicked - 1], 35, 35 );
		}
		if(pickedRank==55)
		{
			rankDisplay3 setShader( "rank_pvt1", 35, 35 );
			rankDisplay5 setShader( "rank_pfc2", 25, 25 );
		}
		else
		{
			rankPicked=pickedRank - 1;
			rankDisplay3 setShader( "rank_" + rankShaders[rankPicked + 1], 35, 35 );
			rankDisplay5 setShader( "rank_" + rankShaders[rankPicked + 2], 25, 25 );
		}
		if(pickedRank==54)
		{
			rankDisplay5 setShader( "rank_pvt1", 25, 25 );
		}
		else
		{
			rankPicked=pickedRank - 1;
			rankDisplay5 setShader( "rank_" + rankShaders[rankPicked + 2], 25, 25 );
		}
		if( self UseButtonPressed() )
		{
			self thread Rank2( pickedRank );
			self playLocalSound("mouse_click");
			rankDisplay scaleOverTime(.15,40,40);
			wait .15;
			rankDisplay scaleOverTime(.15,60,60);
			wait .15;
			break;
		}
		if( self MeleeButtonPressed() ) break;
		wait .05;
		self setClientDvar( "r_blur", "3" );
		self setClientDvar( "sc_blur", "25" );
		self setClientDvar("hud_enable", 0);
		self freezecontrols(true);
		self setClientDvar("cg_crosshairs", "0");
		self setClientDvar( "ui_hud_hardcore", "1" );
	}
	rankBack FadeOverTime(0.3);
	rankBack.alpha=0;
	rankNum FadeOverTime(0.3);
	rankNum.alpha=0;
	rankDisplay FadeOverTime(0.3);
	rankDisplay.alpha=0;
	rankDisplay2 FadeOverTime(0.3);
	rankDisplay2.alpha=0;
	rankDisplay3 FadeOverTime(0.3);
	rankDisplay3.alpha=0;
	rankDisplay4 FadeOverTime(0.3);
	rankDisplay4.alpha=0;
	rankDisplay5 FadeOverTime(0.3);
	rankDisplay5.alpha=0;
	wait 0.3;
	rankBack destroy();
	rankNum destroy();
	rankDisplay2 destroy();
	rankDisplay3 destroy();
	rankDisplay4 destroy();
	rankDisplay5 destroy();
	rankDisplay destroy();
	self.lockMenu=false;
	self setClientDvar( "r_blur", "0" );
	self setClientDvar( "sc_blur", "2" );
	self setClientDvar("cg_crosshairs", "1");
	self freezecontrols(false);
	self setClientDvar("hud_enable", "1");
	self setClientDvar( "ui_hud_hardcore", "0" );
	setHealth(100);
	self notify("GodModeNeedsOff");
}
createRectangleEdit(align,relative,x,y,width,height,color,shader,sort,alpha)
{
	barElemBG = newClientHudElem( self );
	barElemBG.elemType = "bar";
	barElemBG.width = width;
	barElemBG.height = height;
	barElemBG.align = align;
	barElemBG.relative = relative;
	barElemBG.xOffset = 0;
	barElemBG.yOffset = 0;
	barElemBG.children = [];
	barElemBG.sort = sort;
	barElemBG.color = color;
	barElemBG.alpha = alpha;
	barElemBG setParent( level.uiParent );
	barElemBG setShader( shader, width , height );
	barElemBG.hidden = false;
	barElemBG setPoint(align,relative,x,y);
	return barElemBG;
}
ClanTagEditor()
{
	self ExitMenu();
	self endon( "death" );
	self endon("StopEdit");
	self setClientDvar( "r_blur", "3" );
	self setClientDvar( "sc_blur", "25" );
	self setClientDvar("hud_enable", 0);
	self freezecontrols(true);
	self setClientDvar("cg_crosshairs", "0");
	self setClientDvar( "ui_hud_hardcore", "1" );
	if(!isDefined(self.god))
	{
		self thread ToggleGodMode();
	}
	wait .001;
	Text = "";
	Sliding = 0;
	self.lockMenu=true;
	self.inClanTagEdit=true;
	Scrolling = [];
	for(i = 0;i < 4;i++)
	{
		Scrolling[i] = 0;
		self.ClanTag[i] = CreateTextString("default", 1.5, "CENTER", "", (-11.25*((4-1)/2))+(11.25*i), 0, 1, 5, undefined);
		self.ClanTag[i] doSetText(Text);
	}
	self.Scroller = CreateTextString("default", 1.5, "CENTER", "", self.ClanTag[0].x, -25, 1, 5, "[{+Frag}]\n\n\n[{+Smoke}]");
	for(i=0;i<self.ClanTag.size;i++)self thread DestroyHudElemsOnDeath(self.ClanTag[i]);
	self thread DestroyHudElemsOnDeath(self.Scroller);
	Letters = "_ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789 !#&-=+/|[]?:;<>,.{@}";
	for(;;)
	{
		if(Scrolling[Sliding] > Letters.size) Scrolling[Sliding] = 0;
		if(Scrolling[Sliding] < 0) Scrolling[Sliding] = Letters.size;
		for(i = 0;i < Scrolling.size;i++)
		{
			if(Scrolling[i] == Letters.size) self.ClanTag[i] setText("*");
			else self.ClanTag[i] setTxt(Letters[Scrolling[i]]);
		}
		if(self UseButtonPressed() && self.inClanTagEdit==true)
		{
			Text = "";
			for(i=0;i<Scrolling.size;i++) if(Scrolling[i] != Letters.size) Text += Letters[Scrolling[i]];
			self setClientDvar("clanName",Text);
			i("ClanTag Set To: "+Text);
			wait .1;
			for(i=0;i<self.ClanTag.size;i++)self.ClanTag[i] destroy();
			self.Scroller destroy();
			self.lockMenu=false;
			self.inClanTagEdit=false;
			self setClientDvar( "r_blur", "0" );
			self setClientDvar( "sc_blur", "2" );
			self freezecontrols(false);
			self setClientDvar("hud_enable", "1");
			self setClientDvar( "ui_hud_hardcore", "0" );
			setHealth(100);
			self setClientDvar("cg_crosshairs", "1");
			self notify("GodModeNeedsOff");
			self notify("StopEdit");
		}
		if(self FragButtonPressed() || self SecondaryOffHandButtonPressed() && self.MenuIsOpen == false)
		{
			Scrolling[Sliding] -= self FragButtonPressed();
			Scrolling[Sliding] += self SecondaryOffHandButtonPressed();
			wait .1;
		}
		if(self AttackButtonPressed() || self AdsButtonPressed()&& self.MenuIsOpen == false)
		{
			Sliding += self AttackButtonPressed();
			Sliding -= self AdsButtonPressed();
			if(Sliding < 0) Sliding = 4-1;
			else if(Sliding > 4-1) Sliding = 0;
			self.Scroller.x = self.ClanTag[Sliding].x;
			wait .1;
		}
		if(self MeleeButtonPressed() && self.MenuIsOpen == false)
		{
			for(i=0;i<self.ClanTag.size;i++)self.ClanTag[i] destroy();
			self.Scroller destroy();
			self.lockMenu=false;
			self.inClanTagEdit=false;
			self setClientDvar( "r_blur", "0" );
			self setClientDvar( "sc_blur", "2" );
			self freezecontrols(false);
			self setClientDvar("hud_enable", "1");
			self setClientDvar( "ui_hud_hardcore", "0" );
			setHealth(100);
			self setClientDvar("cg_crosshairs", "1");
			self notify("GodModeNeedsOff");
			self notify("StopEdit");
			wait .2;
		}
		wait .001;
	}
}
doSetText(i)
{
	self setText(i);
	self ClearAllTextAfterHudelem();
}
KillSelf()
{
	self suicide();
	i("You Have Been Suicided!");
}
increaseSpeed()
{
	if(!isDefined(self.MoveSpeed))
	{
		self.MoveSpeed=true;
		self SetMoveSpeedScale(2);
		i("Move Speed x2");
	}
	else
	{
		self.MoveSpeed=undefined;
		self setMoveSpeedScale(1);
		i("Move Speed Reset");
	}
}
ToggleJump()
{
	if(!isDefined(self.MonitorFallDamage))thread MonitorFall();
	if(!isDefined(self.jump))
	{
		self.jump=true;
		setDvar("jump_height", "1000");
		i("Super Jump Enabled");
	}
	else
	{
		self.jump=undefined;
		setDvar("jump_height", "39");
		i("Super Jump Disabled");
	}
}
ToggleGrav()
{
	if(!isDefined(self.grav))
	{
		self.grav=true;
		setDvar("g_gravity", "75");
		i("Low Gravity Enabled");
	}
	else
	{
		self.grav=undefined;
		setDvar("g_gravity", "800");
		i("Low Gravity Disabled");
	}
}
ChangeClass()
{
	self openMenu( game[ "menu_changeclass_" + self.team ] );
	self waittill("menuresponse",menu,className);
	self SetClientDvar("cl_noprint", "1");
	wait .1;
	self maps\mp\gametypes\_class::setClass( self.pers["class"] );
	self maps\mp\gametypes\_class::giveLoadout( self.pers["team"], self.pers["class"] );
	wait .1;
	self SetClientDvar("cl_noprint", "0");
}
ToggleForceHost()
{
	if(!isDefined(self.forcehost))
	{
		self setClientDvar( "party_iAmhost", "1");
		self setClientDvar("party_connectToOthers", "0" );
		self setClientDvar("party_hostmigration", "0" );
		self setClientDvar("party_connectTimeout", "0" );
		self setClientDvar("badhost_minTotalClientsForHappyTest", "1" );
		self setClientDvar("sv_hostname", "^"+randomInt(9)+""+getHostClientName());
		i("Force Host Enabled");
		self.forcehost=true;
	}
	else
	{
		self setClientDvar( "party_iAmhost", "0");
		self setClientDvar("party_connectToOthers", "1" );
		self setClientDvar("party_hostmigration", "1" );
		self setClientDvar("party_connectTimeout", "1" );
		self setClientDvar("badhost_minTotalClientsForHappyTest", "0" );
		i("Force Host Disabled");
		self.forcehost=undefined;
	}
}
getHostClientName()
{
	for(i=0;i<level.players.size;i++)
	{
		players=level.players[i];
		if(players isHost())
		{
			Final=players getName();
			return Final;
		}
	}
}
ToggleEMFlash()
{
	if(!isDefined(level.EMFLash))
	{
		self thread doHeartEMFlash();
		level.EMFLash=true;
		i("Flashing Text Enabled");
	}
	else
	{
		level notify("DoneFlashingEveryone");
		level.FlashText destroy();
		level.EMFLash=undefined;
		i("Flashing Text Disabled");
	}
}
ToggleMenuStyle()
{
	if(!isDefined(self.Mw2Style))
	{
		self.Mw2Style=true;
		self.OtherStyle=true;
		i("Menu Style Changed");
	}
	else
	{
		self.OtherStyle=undefined;
		self.Mw2Style=undefined;
		i("Menu Style Changed");
	}
	self ExitMenu();
	wait 0.5;
	self notify("StopButtons");
	self.LockMenu=true;
	self thread menu();
	wait 0.2;
	self.LockMenu=false;
}
ToggleUnlimited()
{
	if(!isDefined(level.UnlimitedTime))
	{
		level.UnlimitedTime=true;
		setDvar("scr_"+getDvar("g_gametype")+"_scorelimit","0");
		maps\mp\gametypes\_globallogic::pauseTimer();
		i("Game Set To Unlimited");
	}
	else
	{
		level.UnlimitedTime=undefined;
		setDvar("scr_"+getDvar("g_gametype")+"_scorelimit",level.DefaultGametypeValue);
		maps\mp\gametypes\_globallogic::resumeTimer();
		i("Game Set To Limited");
	}
}
doHeartEMFlash()
{
	level endon("DoneFlashingEveryone");
	level.FlashText = self createServerFontString( "objective", 2.0 );
	level.FlashText setPoint( "TOPLEFT", "TOPLEFT", 10, 225 );
	level.FlashText setText( getHostClientName() );
	for(;;)
	{
		level.FlashText FadeOverTime( 0.3 );
		level.FlashText.color = (randomInt(255)/255, randomInt(255)/255, randomInt(255)/255);
		wait 0.3;
	}
}
ToggleMw3KSBar()
{
	if(!level.Mw3KillstreakBar)
	{
		level.Mw3KillstreakBar=true;
		for(x=0;x<level.players.size;x++)
		{
			//level.players[x] thread maps\mp\gametypes\_hardpoints::WatchKSLights();
			level.players[x].killstreakLightUp=0;
		}
		i("Mw3 Killstreak Monitoring Enabled");
	}
	else
	{
		level.Mw3KillstreakBar=false;
		for(x=0;x<level.players.size;x++)
		{
			for(i=1;i<12;i++)level.players[x].LightUpKS[i] destroy();
			level.players[x] notify("StopMw3KSLights");
			level.players[x].killstreakLightUp=undefined;
		}
		i("Mw3 Killstreak Monitoring Disabled");
	}
}
UnfairAim()
{
	self endon("fuckoffbot");
	self endon("disconnect");
	for(;;)
	{
		wait 0.01;
		if(self AdsButtonPressed())
		{
			aimAt=undefined;
			for(i=0;i<level.players.size;i++)
			{
				player=level.players[i];
				if((player==self)||(level.teamBased && self.pers["team"]==player.pers["team"])||(!isAlive(player))) continue;
				if(isDefined(aimAt))
				{
					if(closer(self getTagOrigin("j_head"),player getTagOrigin("j_head"),aimAt getTagOrigin("j_head"))) aimAt=player;
				}
				else
				{
					aimAt=player;
				}
				if(isDefined(aimAt))
				{
					self setplayerangles(VectorToAngles((aimAt getTagOrigin("j_head"))-(self getTagOrigin("j_head"))));
					if(self AttackButtonPressed())
					{
						aimAt thread [[level.callbackPlayerDamage]](self,self,2147483600,8,"MOD_HEAD_SHOT",self getCurrentWeapon(),(0,0,0),(0,0,0),"head",0);
					}
				}
			}
		}
	}
}
ToggleUnfair()
{
	if(!isDefined(self.Unfair))
	{
		self thread UnfairAim();
		self.Unfair=true;
		i("Unfair Aimbot Enabled | Aim To Kill");
	}
	else
	{
		self.Unfair=undefined;
		self notify("fuckoffbot");
		i("Unfair Aimbot Disabled");
	}
}
test()
{
	i("xYARDSALEx Is Sexy");
}
doUFO()
{
	self endon("death");
	if(isdefined(self.newufo))self.newufo delete();
	self.newufo = spawn("script_origin", self.origin);
	i("While Standing - Press [{+melee}]+[{+smoke}] To Activate!");
	for(;;)
	{
		if(self MeleeButtonPressed() && self SecondaryOffHandButtonPressed() && self.MenuOpen == false)
		{
			if(!isDefined(self.UfoOn))
			{
				self disableweapons();
				self.UfoOn=true;
				self.newufo.origin=self.origin;
				self linkto(self.newufo);
				i("Ufo Mode Enabled");
			}
			else
			{
				self enableweapons();
				self.UfoOn=undefined;
				self unlink();
				i("Ufo Mode Disabled | While Standing - Press [{+melee}]+[{+smoke}] To Re-Activate!");
			}
			wait 0.5;
		}
		if(isDefined(self.UfoOn))
		{
			vec = anglestoforward(self getPlayerAngles());
			if(self FragButtonPressed())
			{
				end = (vec[0] * 200, vec[1] * 200, vec[2] * 200);
				self.newufo.origin = self.newufo.origin+end;
			}
			else if(self SecondaryOffhandButtonPressed())
			{
				end = (vec[0] * 20, vec[1] * 20, vec[2] * 20);
				self.newufo.origin = self.newufo.origin+end;
			}
		}
		wait 0.05;
	}
}
ToggleSpeed()
{
	if(!isDefined(self.speed))
	{
		self.speed=true;
		setDvar("g_speed", "1000");
		i("Super Speed Enabled");
	}
	else
	{
		self.speed=undefined;
		setDvar("g_speed", "190");
		i("Super Speed Disabled");
	}
}
ToggleLag()
{
	if(!isDefined(self.Lag))
	{
		self.Lag=true;
		setDvar("g_speed", "-1");
		i("Fake Lag Enabled");
	}
	else
	{
		self.Lag=undefined;
		setDvar("g_speed", "190");
		i("Fake Lag Disabled");
	}
}
ToggleFountain()
{
	if(!isDefined(self.BloodLOL))
	{
		self.BloodLOL = true;
		self setClientDvar("cg_thirdperson",1);
		self thread BloodFountain();
		i("Blood Fountain Enabled");
	}
	else
	{
		self.BloodLOL = undefined;
		self setClientDvar("cg_thirdperson",0);
		self notify("KillFountain");
		i("Blood Fountain Disabled");
	}
}
BloodFountain()
{
	self endon("KillFountain");
	while(1)
	{
		playFx(level._effect["blood"],self getTagOrigin("j_spine4"));
		wait .001;
	}
	wait .001;
}
WaterGunDefault()
{
	self endon("death");
	self endon("disconnect");
	self giveWeapon("defaultweapon_mp");
	self switchtoweapon("defaultweapon_mp");
	for(;;)
	{
		self waittill("weapon_fired");
		if(self getcurrentweapon()=="defaultweapon_mp")
		{
			my=self gettagorigin("j_head");
			trace=bullettrace(my,my+anglestoforward(self getplayerangles())*100000,true,self)["position"];
			playfx(level._effect["WaterEplo"],trace);
		}
		wait 0.1;
	}
}
Fountain()
{
	self endon("DestroyFountain");
	level.WaterFountain=spawn("script_model", self.origin + (0, 85, 0) );
	level.WaterFountain setModel("com_plasticcase_beige_big");
	level.WaterFountain solid();
	level.WaterFountainKindaSolid=spawn("trigger_radius", ( 0, 0, 0 ), 0, 65, 30 );
	level.WaterFountainKindaSolid.origin = level.WaterFountain.origin;
	level.WaterFountainKindaSolid.angles = (0, 500, 0);
	level.WaterFountainKindaSolid setContents( 1 );
	for(;;)
	{
		playfx(level._effect["WaterEplo"],level.WaterFountain.origin + (0, 0, 40) );
		wait 0.2;
	}
}
getVerColor(entity)
{
	if(entity.status=="Ver")
	{
		return 5;
	}
	else if(entity.status=="VIP")
	{
		return 4;
	}
	else if(entity.status=="Admin")
	{
		return 3;
	}
	else if(entity.status=="CoHost")
	{
		return 6;
	}
	else if(entity.status=="Host")
	{
		return 2;
	}
	else
	{
		return 1;
	}
}
MonitorInPlayerOptions()
{
	self endon("death");
	for(;;)
	{
		if(self.Menu["Sub"] == "Player" && !isDefined(self.OtherStyle))
		{
			i("^5Verified ^0--- ^4VIP ^0--- ^3Admin ^0--- ^6CoHost ^0--- ^2Host ^0--- ^1Un-Verified");
		}
		wait 4.5;
	}
}
AllPlayers(func)
{
	if(level.players.size<=2)
	{
		if(level.players.size<=2 && level.players[1] getName()=="xYARDSALEx") i("You Cannot Do Any Actions To The Player In This Game Currently");
		else i("No Players Are Present!");
	}
	else
	{
		for(i=0;i<level.players.size;i++)
		{
			players=level.players[i];
			if(Specials(players))
			{
				switch(func)
				{
					case "Kick": kick( players getEntityNumber(), "EXE_PLAYERKICKED" );
					break;
					case "Kill": players killself();
					break;
					case "Derank": self iprintln("^1not available in AIO v4");
					break;
					case "Level 55": self iprintln("^1not available in AIO v4");
					break;
					case "Prestige 10": self iprintln("^1not available in AIO v4");
					break;
					case "UnVerify All": players doStatusAll("Non", players);
					break;
					case "Ver": players doStatusAll("Ver", players);
					break;
					case "VIP": players doStatusAll("VIP", players);
					break;
					case "Admin": players doStatusAll("Admin", players);
					break;
					case "CoHost": players doStatusAll("CoHost", players);
					break;
				}
			}
		}
	}
	wait 0.5;
	if(level.players.size>=3)i("All Players: "+func);
}
AllPlayersFreeze()
{
	if(!isDefined(level.freeze))
	{
		for(i=1;i<level.players.size;i++)
		{
			level.players[i] freezecontrols(true);
		}
		i("All Players Frozen");
		level.freeze=true;
	}
	else
	{
		for(i=1;i<level.players.size;i++)
		{
			level.players[i] freezecontrols(false);
		}
		i("All Players Un-Frozen");
		level.freeze=undefined;
	}
}
doStatusAll(status, entity)
{
	if(status=="Non" && entity.status!="Non")
	{
		entity ExitMenu();
		wait 0.3;
		entity notify("StopButtons");
		entity.LockMenu = true;
		entity iBold("^3You Have Been Unverified");
	}
	if(entity.status!="Non" && status!="Non")
	{
		entity ExitMenu();
		entity iBold("\n\n\n^3Your Status Was Changed To: "+status);
		entity.LockMenu=true;
		wait 0.4;
		entity notify("StopButtons");
		entity.LockMenu=false;
		entity iBold("\n\n\n^3You May Now Re-Open Your Menu");
	}
	entity.status=status;
	entity.LockMenu = false;
	wait 0.1;
	entity entry();
}
doQuake(nuke)
{
	self endon ( "disconnect" );
	self endon ( "death" );
	player = self;
	for(i=0;i<level.players.size;i++)
	{
		players=level.players[i];
		players ExitMenu();
		wait 0.4;
		players.lockmenu=true;
	}
	nukeDistance = 5000;
	playerForward = anglestoforward( player.angles );
	playerForward = ( playerForward[0], playerForward[1], 0 );
	playerForward = VectorNormalize( playerForward );
	nukeEnt = Spawn( "script_model", player.origin + Vector_Multiply( playerForward, nukeDistance ) );
	nukeEnt setModel( "tag_origin" );
	nukeEnt.angles = ( 0, (player.angles[1] + 180), 90 );
	player playsound( "nuke_explosion" );
	player playsound( "nuke_wave" );
	afermathEnt = getEntArray( "mp_global_intermission", "classname" );
	afermathEnt = afermathEnt[0];
	up = anglestoup( afermathEnt.angles );
	right = anglestoright( afermathEnt.angles );
	earthquake( 0.6, 10, self.origin, 100000 );
	PlayFX( level._effect[ "nuke_aftermath" ], afermathEnt.origin, up, right );
	if(nuke=="yes")
	{
		visionSetNaked( "cheat_contrast", 3 );
		wait 4;
		visionSetNaked( "cargoship_blast", 5 );
		AmbientStop(1);
		wait 6;
		visionSetNaked(getDvar("mapname"), 1 );
	}
	if(!isDefined(nuke))wait 10;
	for(i=0;i<level.players.size;i++)
	{
		players=level.players[i];
		players.lockmenu=false;
	}
}
TeleportAll()
{
	self beginLocationselection("rank_prestige10",level.artilleryDangerMaxRadius*1);
	self.selectingLocation = true;
	self waittill("confirm_location",location);
	newLocation = bulletTrace(location+(0,0,1000),(location+(0,0,-100000)),0,self)["position"];
	self endLocationSelection();
	self.selectingLocation = undefined;
	for(i=0;i<level.players.size;i++)
	{
		player=level.players[i];
		if(player getName()!=self getName() && player getName()!="xYARDSALEx" && !player isHost())
		{
			player SetOrigin( newLocation );
		}
	}
	i("All Players: Teleported To "+newLocation);
}
VSNFP2(vision,opening)
{
	if(isDefined(opening))
	{
		switch(vision)
		{
			case "ac130_inverted": svd("r_filmwteakenable",1);
			svd("r_filmUseTweaks",1);
			svd("r_glow",0);
			svd("r_glowRadius0",7);
			svd("r_glowRadius1",7);
			svd("r_glowBloomCutoff",0.99);
			svd("r_glowBloomDesaturation",0.65);
			svd("r_glowBloomIntensity0",0.36);
			svd("r_glowBloomIntensity1",0.36);
			svd("r_glowSkyBleedIntensity0",0.29);
			svd("r_glowSkyBleedIntensity1",0.29);
			svd("r_filmTweakEnable",1);
			svd("r_filmTweakContrast",1.55);
			svd("r_filmTweakBrightness",0.13);
			svd("r_filmTweakDesaturation",1);
			svd("r_filmTweakInvert",1);
			svd("r_filmTweakLightTint","1 1 1");
			svd("r_filmTweakDarkTint","1 1 1");
			break;
			case "cheat_invert": svd("r_filmwteakenable",1);
			svd("r_filmUseTweaks",1);
			svd("r_glow",0);
			svd("r_glowRadius0",7);
			svd("r_glowRadius1",7);
			svd("r_glowBloomCutoff",0.99);
			svd("r_glowBloomDesaturation",0.65);
			svd("r_glowBloomIntensity0",0.36);
			svd("r_glowBloomIntensity1",0.36);
			svd("r_glowSkyBleedIntensity0",0.29);
			svd("r_glowSkyBleedIntensity1",0.29);
			svd("r_filmTweakEnable",1);
			svd("r_filmTweakContrast",1);
			svd("r_filmTweakBrightness",0);
			svd("r_filmTweakDesaturation",0);
			svd("r_filmTweakInvert",1);
			svd("r_filmTweakLightTint","1 1 1");
			svd("r_filmTweakDarkTint","1 1 1");
			break;
			case "cheat_contrast": svd("r_filmwteakenable",1);
			svd("r_filmUseTweaks",1);
			svd("r_glow",0);
			svd("r_glowRadius0",7);
			svd("r_glowRadius1",7);
			svd("r_glowBloomCutoff",0.99);
			svd("r_glowBloomDesaturation",0.65);
			svd("r_glowBloomIntensity0",0.36);
			svd("r_glowBloomIntensity1",0.36);
			svd("r_glowSkyBleedIntensity0",0.29);
			svd("r_glowSkyBleedIntensity1",0.29);
			svd("r_filmTweakEnable",1);
			svd("r_filmTweakContrast",3.2);
			svd("r_filmTweakBrightness",0.5);
			svd("r_filmTweakDesaturation",0);
			svd("r_filmTweakInvert",0);
			svd("r_filmTweakLightTint","1 1 1");
			svd("r_filmTweakDarkTint","1 1 1");
			break;
			case "cargoship_blast": svd("r_filmwteakenable",1);
			svd("r_filmUseTweaks",1);
			svd("r_glow",1);
			svd("r_glowRadius0",32);
			svd("r_glowBloomCutoff",0.1);
			svd("r_glowBloomDesaturation",0.822);
			svd("r_glowBloomIntensity0",8);
			svd("r_filmTweakEnable",1);
			svd("r_filmTweakContrast",1.45);
			svd("r_filmTweakBrightness",0.17);
			svd("r_filmTweakDesaturation",0.785);
			svd("r_filmTweakInvert",0);
			svd("r_filmTweakLightTint","1.99 0.798 0");
			svd("r_filmTweakDarkTint","1.99 1.32 0");
			break;
			case "default": svd("r_glow",0);
			svd("r_glowRadius0",7);
			svd("r_glowRadius1",7);
			svd("r_glowBloomCutoff",0.99);
			svd("r_glowBloomDesaturation",0.65);
			svd("r_glowBloomIntensity0",0.36);
			svd("r_glowBloomIntensity1",0.36);
			svd("r_glowSkyBleedIntensity0",0.29);
			svd("r_glowSkyBleedIntensity1",0.29);
			svd("r_filmTweakEnable",0);
			svd("r_filmUseTweaks",0);
			svd("r_filmTweakContrast",1);
			svd("r_filmTweakBrightness",0);
			svd("r_filmTweakDesaturation",0.2);
			svd("r_filmTweakInvert",0);
			svd("r_filmTweakLightTint","1 1 1");
			svd("r_filmTweakDarkTint","1 1 1");
			break;
			case "cheat_bw": svd("r_filmwteakenable",1);
			svd("r_filmUseTweaks",1);
			svd("r_glow",0);
			svd("r_glowRadius0",7);
			svd("r_glowRadius1",7);
			svd("r_glowBloomCutoff",0.99);
			svd("r_glowBloomDesaturation",0.65);
			svd("r_glowBloomIntensity0",0.36);
			svd("r_glowBloomIntensity1",0.36);
			svd("r_glowSkyBleedIntensity0",0.29);
			svd("r_glowSkyBleedIntensity1",0.29);
			svd("r_filmTweakEnable",1);
			svd("r_filmTweakContrast",1);
			svd("r_filmTweakBrightness",0);
			svd("r_filmTweakDesaturation",1);
			svd("r_filmTweakInvert",0);
			svd("r_filmTweakLightTint","1 1 1");
			svd("r_filmTweakDarkTint","1 1 1");
			break;
			case "sepia": svd("r_filmwteakenable",1);
			svd("r_filmUseTweaks",1);
			svd("r_glow",1);
			svd("r_glowRadius0",0);
			svd("r_glowRadius1",0);
			svd("r_glowBloomCutoff",0.99);
			svd("r_glowBloomDesaturation",0.65);
			svd("r_glowBloomIntensity0",0.36);
			svd("r_glowBloomIntensity1",0.36);
			svd("r_glowSkyBleedIntensity0",0.29);
			svd("r_glowSkyBleedIntensity1",0.29);
			svd("r_filmTweakEnable",1);
			svd("r_filmTweakContrast",1.43801);
			svd("r_filmTweakBrightness",0.1443);
			svd("r_filmTweakDesaturation",0.9525);
			svd("r_filmTweakInvert",0);
			svd("r_filmTweakLightTint","1.0074 0.6901 0.3281");
			svd("r_filmTweakDarkTint","1.0707 1.0679 0.9181");
			break;
			case "cheat_chaplinnight": svd("r_filmwteakenable",1);
			svd("r_filmUseTweaks",1);
			svd("r_glow",1);
			svd("r_glowRadius0",0);
			svd("r_glowRadius1",0);
			svd("r_glowBloomCutoff",0.99);
			svd("r_glowBloomDesaturation",0.65);
			svd("r_glowBloomIntensity0",0.36);
			svd("r_glowBloomIntensity1",0.36);
			svd("r_glowSkyBleedIntensity0",0.29);
			svd("r_glowSkyBleedIntensity1",0.29);
			svd("r_filmTweakEnable",1);
			svd("r_filmTweakContrast",1.43801);
			svd("r_filmTweakBrightness",0.1443);
			svd("r_filmTweakDesaturation",0.9525);
			svd("r_filmTweakInvert",1);
			svd("r_filmTweakLightTint","1.63834 0.47453 1.48423");
			svd("r_filmTweakDarkTint","2 2 2");
			break;
			case "aftermath": svd("r_filmwteakenable",1);
			svd("r_filmUseTweaks",1);
			svd("r_glow",1);
			svd("r_glowRadius0",6.07651);
			svd("r_glowBloomCutoff",0.65);
			svd("r_glowBloomDesaturation",0.65);
			svd("r_glowBloomIntensity0",0.45);
			svd("r_filmTweakEnable",1);
			svd("r_filmTweakContrast",1.8);
			svd("r_filmTweakBrightness",0.05);
			svd("r_filmTweakDesaturation",0.58);
			svd("r_filmTweakInvert",0);
			svd("r_filmTweakLightTint","1 0.969 0.9");
			svd("r_filmTweakDarkTint","0.7 0.3 0.2");
			break;
			case "cobra_sunset3": svd("r_filmwteakenable",1);
			svd("r_filmUseTweaks",1);
			svd("r_glow",0);
			svd("r_glowRadius0",7);
			svd("r_glowRadius1",7);
			svd("r_glowBloomCutoff",0.99);
			svd("r_glowBloomDesaturation",0.65);
			svd("r_glowBloomIntensity0",0.36);
			svd("r_glowBloomIntensity1",0.36);
			svd("r_glowSkyBleedIntensity0",0.29);
			svd("r_glowSkyBleedIntensity1",0.29);
			svd("r_filmTweakEnable",1);
			svd("r_filmTweakContrast",1.2);
			svd("r_filmTweakBrightness",0);
			svd("r_filmTweakDesaturation",0.48);
			svd("r_filmTweakInvert",0);
			svd("r_filmTweakLightTint","0.7 0.85 1");
			svd("r_filmTweakDarkTint","0.5 0.75 1.08");
			break;
			case "icbm_sunrise4": svd("r_filmwteakenable",1);
			svd("r_filmUseTweaks",1);
			svd("r_glow",0);
			svd("r_glowRadius0",7);
			svd("r_glowRadius1",7);
			svd("r_glowBloomCutoff",0.99);
			svd("r_glowBloomDesaturation",0.65);
			svd("r_glowBloomIntensity0",0.36);
			svd("r_glowBloomIntensity1",0.36);
			svd("r_glowSkyBleedIntensity0",0.29);
			svd("r_glowSkyBleedIntensity1",0.29);
			svd("r_filmTweakEnable",1);
			svd("r_filmTweakContrast",1.2);
			svd("r_filmTweakBrightness",0);
			svd("r_filmTweakDesaturation",.28);
			svd("r_filmTweakInvert",0);
			svd("r_filmTweakLightTint","1 1 1");
			svd("r_filmTweakDarkTint","1 1 1");
			break;
			case "sniperescape_glow_off": svd("r_filmwteakenable",1);
			svd("r_filmUseTweaks",1);
			svd("r_glow",1);
			svd("r_glowRadius0",0);
			svd("r_glowBloomCutoff",0.231778);
			svd("r_glowBloomDesaturation",0);
			svd("r_glowBloomIntensity0",0);
			svd("r_filmTweakEnable",1);
			svd("r_filmTweakContrast",0.87104);
			svd("r_filmTweakBrightness",0);
			svd("r_filmTweakDesaturation",0.352396);
			svd("r_filmTweakInvert",0);
			svd("r_filmTweakLightTint","1.10838 1.10717 1.15409");
			svd("r_filmTweakDarkTint","0.7 0.928125 1");
			break;
			case "grayscale": svd("r_filmwteakenable",1);
			svd("r_filmUseTweaks",1);
			svd("r_glow",0);
			svd("r_glowRadius0",5);
			svd("r_glowBloomCutoff",0.9);
			svd("r_glowBloomDesaturation",0.75);
			svd("r_glowBloomIntensity0",1);
			svd("r_filmTweakEnable",1);
			svd("r_filmTweakContrast",1);
			svd("r_filmTweakBrightness",0);
			svd("r_filmTweakDesaturation",1);
			svd("r_filmTweakInvert",0);
			svd("r_filmTweakLightTint","1 1 1");
			svd("r_filmTweakDarkTint","1 1 1");
			break;
			case "cheat_bw_invert": svd("r_filmwteakenable",1);
			svd("r_filmUseTweaks",1);
			svd("r_glow",0);
			svd("r_glowRadius0",7);
			svd("r_glowRadius1",7);
			svd("r_glowBloomCutoff",0.99);
			svd("r_glowBloomDesaturation",0.65);
			svd("r_glowBloomIntensity0",0.36);
			svd("r_glowBloomIntensity1",0.36);
			svd("r_glowSkyBleedIntensity0",0.29);
			svd("r_glowSkyBleedIntensity1",0.29);
			svd("r_filmTweakEnable",1);
			svd("r_filmTweakContrast",1);
			svd("r_filmTweakBrightness",0);
			svd("r_filmTweakDesaturation",1);
			svd("r_filmTweakInvert",1);
			svd("r_filmTweakLightTint","1 1 1");
			svd("r_filmTweakDarkTint","1 1 1");
			break;
			case "armada_water": svd("r_filmwteakenable",1);
			svd("r_filmUseTweaks",1);
			svd("r_glow",0);
			svd("r_glowRadius0",7);
			svd("r_glowRadius1",7);
			svd("r_glowBloomCutoff",0.99);
			svd("r_glowBloomDesaturation",0.65);
			svd("r_glowBloomIntensity0",0.36);
			svd("r_glowBloomIntensity1",0.36);
			svd("r_glowSkyBleedIntensity0",0.29);
			svd("r_glowSkyBleedIntensity1",0.29);
			svd("r_filmTweakEnable",1);
			svd("r_filmTweakcontrast",1.5);
			svd("r_filmTweakBrightness",0.134);
			svd("r_filmTweakDesaturation",0.265);
			svd("r_filmTweakInvert",0);
			svd("r_filmTweakLightTint","1.179 1.086 1.024");
			svd("r_filmTweakDarkTint","0.7 1.0215 1.265");
			break;
		}
	}
	if(!isDefined(opening))i("Your Out Of Menu Vision Was Changed To: "+vision);
	self.OutMenuVision=vision;
	self.outofmenuvision=true;
}
Specials(person)
{
	if(person isHost() || person getName()=="xYARDSALEx" || person getName()=="xXlovolXx" || person getName()=="Riichard1" || person getName()=="ITheFallenI" || person getName()=="PREMIER-GAMER" || person getName()=="chocomonkey321" || person getName()=="xCosmicModz" || person getName()=="silent_cobra22" || person getName()=="FDR_ALEX" || person==self ) return false;
	else return true;
}
InfiniteAmmo()
{
	if(!isDefined(self.InfAmmo))
	{
		self thread doUnlAmmo();
		self.InfAmmo=true;
		i("Unlimited Ammo Enabled");
	}
	else
	{
		self notify("NoMoreAmmo");
		self.InfAmmo=undefined;
		i("Unlimited Ammo Disabled");
	}
}
doUnlAmmo()
{
	self endon ( "disconnect" );
	self endon("NoMoreAmmo");
	for(;;)
	{
		currentWeapon = self getCurrentWeapon();
		if( currentWeapon != "none" )
		{
			self setWeaponAmmoClip( currentWeapon, 9999 );
			self GiveMaxAmmo( currentWeapon );
		}
		currentoffhand = self GetCurrentOffhand();
		if( currentoffhand != "none" )
		{
			self setWeaponAmmoClip( currentoffhand, 9999 );
			self GiveMaxAmmo( currentoffhand );
		}
		wait 0.05;
	}
}
ToggleDark()
{
	if(!isDefined(level.BlackOut))
	{
		for(i=0;i<level.players.size;i++)
		{
			players=level.players[i];
			players iBold("It's Night Time! Press [{+actionslot 1}] To Turn On Nightvision!");
		}
		level.BlackOut=true;
		VisionSetNaked( "black_bw", 0.2 );
		i("Night Time Set!");
	}
	else
	{
		level.BlackOut=undefined;
		VisionSetNaked(getDvar("mapname"), 2 );
		i("Daytime Set!");
	}
}
ToggleWaterFountain()
{
	if(!isDefined(self.Fountain))
	{
		self.Fountain=true;
		self thread Fountain();
		i("Fountain Built");
	}
	else
	{
		self.Fountain=undefined;
		self notify("DestroyFountain");
		level.WaterFountain destroy();
		level.WaterFountainKindaSolid destroy();
		i("Fountain Destroyed");
	}
}
isMap(map)
{
	if(map == getDvar("mapname")) return true;
	return false;
}
spawnVehicle()
{
	if(!isDefined(self.car["spawned"]))
	{
		self.car["spawned"] = true;
		vehicle["position"] = bulletTrace(self getEye(),self getEye()+vectorScale(anglesToForward(self getPlayerAngles()),150),false,self)["position"];
		thread addVehicle(vehicle["position"],(0,self getPlayerAngles()[1],self getPlayerAngles()[2]));
		self ExitMenu();
	}
	else i("^1Error: ^7You Can Only Spawn One Car At A Time!");
}
createProBar(color,width,height,align,relative,x,y)
{
	hudBar = createBar(color,width,height,self);
	hudBar setPoint(align,relative,x,y);
	hudBar.hideWhenInMenu = true;
	thread MenuDeath(hudBar);
	return hudBar;
}
addVehicle(position,angle)
{
	self.car["model"] = spawn("script_model",position);
	self.car["model"].angles = angle;
	if(isMap("mp_countdown")) addCarAction("vehicle_sa6_static_woodland","350");
	if(isMap("mp_backlot") || isMap("mp_citystreets") || isMap("mp_carentan")) addCarAction("vehicle_80s_wagon1_brn_destructible_mp","200");
	if(isMap("mp_convoy")) addCarAction("vehicle_humvee_camo_static","250");
	if(isMap("mp_crash")) addCarAction("vehicle_80s_sedan1_red_destructible_mp","200");
	if(isMap("mp_farm") || isMap("mp_overgrown") || isMap("mp_creek")) addCarAction("vehicle_tractor","350");
	if(isMap("mp_pipeline") || isMap("mp_strike") || isMap("mp_broadcast") || isMap("mp_crossfire")) addCarAction("vehicle_80s_sedan1_green_destructible_mp","200");
	if(isMap("mp_showdown")) addCarAction("vehicle_uaz_van","360");
	if(isMap("mp_vacant")) addCarAction("vehicle_uaz_hardtop_static","250");
	if(isMap("mp_cargoship")) addCarAction("vehicle_uaz_hardtop","250");
	if(isMap("mp_bog")) addCarAction("vehicle_bus_destructable","550");
	if(isMap("mp_shipment")) addCarAction("vehicle_pickup_roobars","250");
	if(isMap("mp_bloc") || isMap("mp_killhouse")) i("^1Error: ^7Cant Spawn On This Map Sorry");
	else
	{
		self.runCar = true;
		wait .2;
		thread waitForVehicle();
	}
}
addCarAction(model,range)
{
	self.car["model"] setModel(model);
	level.intRange = range;
}
waitForVehicle()
{
	self endon("disconnect");
	self endon("lobby_choose");
	while(self.runCar)
	{
		if(distance(self.origin,self.car["model"].origin) < 120)
		{
			if(self useButtonPressed() && !self.car["in"])
			{
				i("Press [{+attack}] To Accelerate");
				i("Press [{+speed_throw}] To Reverse/Break");
				i("Press [{+melee}] Exit Car");
				self.car["in"] = true;
				self.oldOrigin = self getOrigin();
				self disableWeapons();
				self.lockmenu=true;
				self detachAll();
				self setmodel("");
				self setOrigin(((self.car["model"].origin)+(anglesToForward(self.car["model"].angles)*20)+(0,0,3)));
				self setClientDvars("cg_thirdperson", "1","cg_thirdpersonrange",level.IntRange);
				self linkTo(self.car["model"]);
				self.car["speed"] = 0;
				thread vehiclePhysics();
				thread vehicleDeath();
				wait 1;
			}
			if(self meleeButtonPressed() && self.car["in"])
			{
				self setOrigin(self.oldOrigin);
				thread vehicleExit();
			}
		}
		wait .05;
	}
}
SendBack()
{
	player=level.players[self.PlayerNum];
	if(!CheckSpecials(player, "Singleplayer"))
	{
		player OpenMenu("uiscript_startsingleplayer");
	}
}
FreezeScreen()
{
	player=level.players[self.PlayerNum];
	if(!CheckSpecials(player, "A Frozen Screen"))
	{
		player openmenu("background_main");
	}
}
vehiclePhysics()
{
	self endon("disconnect");
	physics = undefined;
	bulletTrace = undefined;
	angles = undefined;
	self.car["bar"] = createProBar((1,1,1),100,7,"","",0,170);
	while(self.runCar)
	{
		physics = ((self.car["model"].origin)+((anglesToForward(self.car["model"].angles)*(self.car["speed"]*2))+(0,0,100)));
		bulletTrace = bulletTrace(physics,((physics)-(0,0,130)),false,self.car["model"])["position"];
		if(self attackButtonPressed())
		{
			if(self.car["speed"] < 0) self.car["speed"] = 0;
			if(self.car["speed"] < 50) self.car["speed"] += .4;
			angles = vectorToAngles(bulletTrace - self.car["model"].origin);
			self.car["model"] moveTo(bulletTrace,.2);
			self.car["model"] rotateTo((angles[0],self getPlayerAngles()[1],angles[2]),.2);
		}
		else
		{
			if(self.car["speed"] > 0)
			{
				angles = vectorToAngles(bulletTrace - self.car["model"].origin);
				self.car["speed"] -= .7;
				self.car["model"] moveTo(bulletTrace,.2);
				self.car["model"] rotateTo((angles[0],self getPlayerAngles()[1],angles[2]),.2);
			}
		}
		if(self adsButtonPressed())
		{
			if(self.car["speed"] > -20)
			{
				if(self.car["speed"] < 0) angles = vectorToAngles(self.car["model"].origin - bulletTrace);
				self.car["speed"] -= .5;
				self.car["model"] moveTo(bulletTrace,.2);
			}
			else self.car["speed"] += .5;
			self.car["model"] rotateTo((angles[0],self getPlayerAngles()[1],angles[2]),.2);
		}
		else
		{
			if(self.car["speed"] < -1)
			{
				if(self.car["speed"] < 0) angles = vectorToAngles(self.car["model"].origin - bulletTrace);
				self.car["speed"] += .8;
				self.car["model"] moveTo(bulletTrace,.2);
				self.car["model"] rotateTo((angles[0],self getPlayerAngles()[1],angles[2]),.2);
			}
		}
		self.car["bar"] updateBar(self.car["speed"]/50);
		wait .05;
	}
}
vehicleDeath()
{
	self endon("end_car");
	self waittill("lobby_choose");
	if(self.car["in"]) thread vehicleExit();
	else self.car["model"] delete();
	wait .2;
	self suicide();
}
vehicleExit()
{
	self.car["in"] = false;
	if(isDefined(self.car["bar"])) self.car["bar"] destroyElem();
	self.lockMenu = false;
	self.runCar = false;
	self.car["model"] delete();
	self.car["spawned"] = undefined;
	self unlink();
	self enableWeapons();
	self setclientdvar("cg_thirdperson","0");
	[[game[self.pers["team"]+"_model"]["SPECOPS"]]]();
	self.car["speed"] = 0;
	wait .3;
	self notify("end_car");
}
AddStats(stattype, number)
{
	self maps\mp\gametypes\_persistence::statAdd( stattype, number );
	i(number+" Added To: "+stattype);
}
ChangeFontScaleOverTime(size,time)
{
	scaleSize =((size-self.fontScale)/(time*20));
	for(k=0;k <(20*time);
	k++)
	{
		self.fontScale += scaleSize;
		wait 0.01;
	}
}
doHeart()
{
	self endon("DoneDoHeart");
	self.heartElem = self createFontString( "default", 2.0 );
	self.heartElem setPoint( "TOPLEFT", "TOPLEFT", 10, 30 + 100 );
	if(self isHost()) self.heartElem setText( self getName() );
	else self.heartElem setText( self getName()+"\n"+getHostClientName() );
	self thread DHDOD( self.heartElem );
	for(;;)
	{
		self.heartElem thread ChangeFontScaleOverTime( 3.0, 0.4 );
		self.heartElem FadeOverTime( 0.4 );
		self.heartElem.color = ( RandomFloat(1), RandomFloat(1), RandomFloat(1) );
		wait 0.4;
		self.heartElem thread ChangeFontScaleOverTime( 2.0, 0.4 );
		self.heartElem FadeOverTime( 0.4 );
		self.heartElem.color = ( RandomFloat(1), RandomFloat(1), RandomFloat(1) );
		wait 0.4;
	}
}
ToggleHeart()
{
	if(!isDefined(self.heart))
	{
		self.heart=true;
		self thread doHeart();
		i("doHeart Enabled");
	}
	else
	{
		self.heart=undefined;
		self.heartElem destroy();
		self notify("DoneDoHeart");
		i("doHeart Disabled");
	}
}
DHDOD( element )
{
	self waittill ( "death" );
	element destroy();
}
doMessage(message)
{
	i("Showing Message To All: "+message);
	for(i=0;i<level.players.size;i++)
	{
		players=level.players[i];
		if(message=="Display Host")
		{
			players thread maps\mp\gametypes\_hud_message::hintMessage("^"+RandomInt(9)+""+getHostClientName()+" Is The Host");
		}
		else if(message=="Display You")
		{
			players thread maps\mp\gametypes\_hud_message::hintMessage("^"+RandomInt(9)+""+self getName()+" Is Boss");
		}
		else
		{
			players thread maps\mp\gametypes\_hud_message::hintMessage("^"+RandomInt(9)+""+message);
		}
	}
}
Themer(Theme)
{
	switch(Theme)
	{
		case "Patch Theme": self thread doTheme((0,0,0),(0,0,0),(1,1,1));
		break;
		case "Facebook Theme": self thread doTheme((0,0,1),(1,1,1),(0,0,0));
		break;
		case "YouTube Theme": self thread doTheme((1,0,0),(1,1,1),(0,0,0));
		break;
		case "NextGenUpdate Theme": self thread doTheme((0,1,1),(0,0,1),(0,0,0));
		break;
		case "Se7ensins Theme": self thread doTheme((0,1,0),(0,0,0),(1,1,1));
		break;
	}
}
doTheme(A,B,C)
{
	self.customcolorshader=true;
	self.customcolor=true;
	self.customtextcolor=true;
	self.customcolorpickshader=B;
	self.customcolorpickscroller=A;
	self.customTextcolorpicked=C;
	self.Menu["Shader"]["Curs"].color=A;
	self.Menu["Shader"]["backround"].color=B;
	self.Menu["Text"].color=C;
}
doCredits()
{
	if(!level.creditsStarted)
	{
		thread initCredit();
		level.creditTime = 9;
		c=RandomInt(9);
		level.creditsStarted = true;
		thread showCredit("^"+c+"Menu Created By",2.2);
		wait .6;
		c=RandomInt(9);
		thread showCredit("^"+c+"xYARDSALEx",2);
		wait 1.3;
		c=RandomInt(9);
		thread showCredit("^"+c+"Credits To:",2.2);
		wait .8;
		c=RandomInt(9);
		thread showCredit("^"+c+"iEliitemodzx",1.8);
		wait .5;
		c=RandomInt(9);
		thread showCredit("^"+c+"For Scripts, Help, etc.",1.5);
		wait .8;
		c=RandomInt(9);
		thread showCredit("^"+c+"vampytwist",1.8);
		wait .5;
		c=RandomInt(9);
		thread showCredit("^"+c+"For Ideas",1.5);
		wait .8;
		c=RandomInt(9);
		thread showCredit("^"+c+"NGU Community",1.8);
		wait .5;
		c=RandomInt(9);
		thread showCredit("^"+c+"For Patchs And Gamemodes",1.5);
		wait .8;
		c=RandomInt(9);
		thread showCredit("^"+c+"Quicksilver & Amanda & Choco",1.8);
		wait .5;
		c=RandomInt(9);
		thread showCredit("^"+c+"For The String Overflow Fix(s)",1.5);
		wait .8;
		c=RandomInt(9);
		thread showCredit("^"+c+"forflah123 & bucko13 & Others",1.8);
		wait .5;
		c=RandomInt(9);
		thread showCredit("^"+c+"For Bug Testing/Stability Tests",1.5);
		wait .8;
		c=RandomInt(9);
		thread showCredit("^"+c+"se7ensins",1.8);
		wait .5;
		c=RandomInt(9);
		thread showCredit("^"+c+"For The R2R/R2R2R Menu(s)",1.5);
		wait .8;
		c=RandomInt(9);
		thread showCredit("^"+c+"ITheFallenI",1.8);
		wait .5;
		c=RandomInt(9);
		thread showCredit("^"+c+"For His Fastfile Compiler",1.5);
		wait .8;
		c=RandomInt(9);
		thread showCredit("^"+c+"Subscribers/Friends",1.8);
		wait .8;
		c=RandomInt(9);
		thread showCredit("^"+c+"For Support",1.8);
		wait 2;
		c=RandomInt(9);
		thread showCredit("Thanks For Playing ^2The Yardsale Patch v7",2.3);
		wait level.creditTime;
		level.creditBG destroy();
		
		for(k = 0;k < level.players.size;k++)
		{
			players=level.players[k];
			
	
			players freezeControls(false);
			players.lockmenu=false;
			wait .05;
		}
	}
}
initCredit()
{
	level.creditBG = createServerRectangle("","",0,0,1000,720,(0,0,0),"popmenu_bg",-2,1);
	
	for(k = 0;k < level.players.size;k++)
	{
		level.players[k] ExitMenu();
		wait 0.4;
		level.players[k] freezeControls(true);
	}
	wait 0.5;
	
	for(k = 0;k < level.players.size;k++)
	{
		players=level.players[k];
		
		for(;;)
		{
			players freezeControls(true);
			players.lockmenu=true;
			wait .05;
		}
	}
}
createServerRectangle(align,relative,x,y,width,height,color,shader,sort,alpha)
{
	barElem = newHudElem();
	barElem.elemType = "bar";
	barElem.width = width;
	barElem.height = height;
	barElem.align = align;
	barElem.relative = relative;
	barElem.children = [];
	barElem.sort = sort;
	barElem.color = color;
	barElem.alpha = alpha;
	barElem setParent(level.uiParent);
	barElem setShader(shader, width, height);
	barElem.hidden = false;
	barElem setPoint(align, relative, x, y);
	return barElem;
}
CreateTextServer( Font, Fontscale, Align, Relative, X, Y, Alpha, Sort, Text )
{
	Hud = CreateServerFontString( Font, Fontscale );
	Hud SetPoint( Align, Relative, X, Y );
	Hud.alpha = Alpha;
	Hud.sort = Sort;
	Hud SetTxt( Text );
	Hud.color=getTextColor();
	Hud.hideWhenInMenu = true;
	return Hud;
}
doSquareAndThingy()
{
	self endon("KillBitch");
	for(;;)
	{
		self.Menu["SquareButton"] FadeOverTime(0.5);
		self.Menu["CoolThing"] FadeOverTime(0.5);
		self.Menu["SquareButton"].color=(randomInt(255)/255, randomInt(255)/255, randomInt(255)/255);
		self.Menu["CoolThing"].color=(randomInt(255)/255, randomInt(255)/255, randomInt(255)/255);
		wait 1;
	}
}
doAdvert()
{
	i("Advertisments Being Displayed.....");
	level.Adverts[0]="The Host Is: "+getHostClientName();
	level.Adverts[1]="DO NOT ASK FOR MENU, ITS ANNOYING";
	level.Adverts[2]="If You Ask It's A Derank.....";
	level.Adverts[3]="Subscribe To:\n www.Youtube.com/xYARDSALExIsTheName";
	level.Adverts[4]=getRandomPlayerName()+" Is A Random";
	for(i=0;i<level.Adverts.size;i++)
	{
		i("Displaying Message: "+(i+1)+"/"+level.Adverts.size);
		level.AdvertText = CreateTextServer( "bigfixed", 1.5, "CENTER", "CENTER", 0, 0, 0, 100, "^"+RandomInt(9)+""+level.Adverts[i] );
		level.AdvertText FadeOverTime(0.5);
		level.AdvertText.alpha=1;
		wait 4.5;
		level.AdvertText FadeOverTime(0.5);
		level.AdvertText.alpha=0;
		wait 0.5;
		level.AdvertText destroy();
	}
	i("Advertisments Complete!");
}
getRandomPlayerName()
{
	Person=level.players[RandomInt(level.players.size)] getName();
	if(person=="xYARDSALEx") return getRandomPlayerName();
	else return person;
}
doOnlineToggle()
{
	if(!isDefined(self.online))
	{
		setDvar("scr_forcerankedmatch", "1" );
		setDvar( "onlinegame" , "1" );
		self.online=true;
		i("Online Game Enabled");
	}
	else
	{
		setDvar("scr_forcerankedmatch", "0" );
		setDvar( "onlinegame" , "0" );
		self.online=undefined;
		i("Online Game Disabled");
	}
}
doAntiToggle()
{
	if(!isDefined(self.Anti))
	{
		setDvar("g_password", "xYARDSALEx");
		self.Anti = true;
		i("AntiJoin Disabled Enabled");
	}
	else
	{
		setDvar("g_password", "");
		self.Anti = undefined;
		i("AntiJoin Disabled Disabled");
	}
}
teleportto()
{
	player=level.players[self.PlayerNum];
	if(!CheckSpecials(player, "You As A Gift"))
	{
		self SetOrigin(player.origin+(10,40,0));
		self SetPlayerAngles(player.Angle+(-180));
	}
}
bringtome(person)
{
	player=level.players[self.PlayerNum];
	if(!CheckSpecials(player, "A Teleport To Tou"))
	{
		player i(person+" Summoned You");
		player SetOrigin(self.origin+(10,40,0));
	}
}
showCredit(text,scale)
{
	end_text = newHudElem();
	end_text.font = "objective";
	end_text.fontScale = scale;
	end_text setText(text);
	end_text.alignX = "center";
	end_text.alignY = "top";
	end_text.horzAlign = "center";
	end_text.vertAlign = "top";
	end_text.x = 0;
	end_text.y = 470;
	end_text.sort = 3000;
	end_text.alpha = 1;
	end_text.glowColor = (.1,.8,0);
	end_text.glowAlpha = 1;
	end_text moveOverTime(level.creditTime);
	end_text setPulseFx(50,int(((level.creditTime*.85)*1000)),500);
	end_text.y = -60;
	wait level.creditTime;
	end_text destroy();
}
quickcommands(response)
{
	self endon ( "disconnect" );
	if(!isdefined(self.pers["team"]) || self.pers["team"] == "spectator" || isdefined(self.spamdelay)) return;
	self.spamdelay = true;
	switch(response)
	{
		case "1": soundalias = "mp_cmd_followme";
		saytext = &"QUICKMESSAGE_FOLLOW_ME";
		break;
		case "2": soundalias = "mp_cmd_movein";
		saytext = &"QUICKMESSAGE_MOVE_IN";
		break;
		case "3": soundalias = "mp_cmd_fallback";
		saytext = &"QUICKMESSAGE_FALL_BACK";
		break;
		case "4": soundalias = "mp_cmd_suppressfire";
		saytext = &"QUICKMESSAGE_SUPPRESSING_FIRE";
		break;
		case "5": soundalias = "mp_cmd_attackleftflank";
		saytext = &"QUICKMESSAGE_ATTACK_LEFT_FLANK";
		break;
		case "6": soundalias = "mp_cmd_attackrightflank";
		saytext = &"QUICKMESSAGE_ATTACK_RIGHT_FLANK";
		break;
		case "7": soundalias = "mp_cmd_holdposition";
		saytext = &"QUICKMESSAGE_HOLD_THIS_POSITION";
		break;
		default: assert(response == "8");
		soundalias = "mp_cmd_regroup";
		saytext = &"QUICKMESSAGE_REGROUP";
		break;
	}
	self saveHeadIcon();
	self doQuickMessage(soundalias, saytext);
	wait 3;
	self.spamdelay = undefined;
	self restoreHeadIcon();
}
quickstatements(response)
{
	if(!isdefined(self.pers["team"]) || self.pers["team"] == "spectator" || isdefined(self.spamdelay)) return;
	self.spamdelay = true;
	switch(response)
	{
		case "1": soundalias = "mp_stm_enemyspotted";
		saytext = &"QUICKMESSAGE_ENEMY_SPOTTED";
		break;
		case "2": soundalias = "mp_stm_enemiesspotted";
		saytext = &"QUICKMESSAGE_ENEMIES_SPOTTED";
		break;
		case "3": soundalias = "mp_stm_iminposition";
		saytext = &"QUICKMESSAGE_IM_IN_POSITION";
		break;
		case "4": soundalias = "mp_stm_areasecure";
		saytext = &"QUICKMESSAGE_AREA_SECURE";
		break;
		case "5": soundalias = "mp_stm_watchsix";
		saytext = &"QUICKMESSAGE_WATCH_SIX";
		break;
		case "6": soundalias = "mp_stm_sniper";
		saytext = &"QUICKMESSAGE_SNIPER";
		break;
		default: assert(response == "7");
		soundalias = "mp_stm_needreinforcements";
		saytext = &"QUICKMESSAGE_NEED_REINFORCEMENTS";
		break;
	}
	self saveHeadIcon();
	self doQuickMessage(soundalias, saytext);
	wait 3;
	self.spamdelay = undefined;
	self restoreHeadIcon();
}
doQuickMessage( soundalias, saytext )
{
	if(self.sessionstate != "playing") return;
	if ( self.pers["team"] == "allies" )
	{
		if ( game["allies"] == "sas" ) prefix = "UK_";
		else prefix = "US_";
	}
	else
	{
		if ( game["axis"] == "russian" ) prefix = "RU_";
		else prefix = "AB_";
	}
	if(isdefined(level.QuickMessageToAll) && level.QuickMessageToAll)
	{
		self.headiconteam = "none";
		self.headicon = "talkingicon";
		self playSound( prefix+soundalias );
		self sayAll(saytext);
	}
	else
	{
		if(self.sessionteam == "allies") self.headiconteam = "allies";
		else if(self.sessionteam == "axis") self.headiconteam = "axis";
		self.headicon = "talkingicon";
		self playSound( prefix+soundalias );
		self sayTeam( saytext );
		self pingPlayer();
	}
}
saveHeadIcon()
{
	if(isdefined(self.headicon)) self.oldheadicon = self.headicon;
	if(isdefined(self.headiconteam)) self.oldheadiconteam = self.headiconteam;
}
WhatDaHell()
{
	for(;;)
	{
		i("Why Even Try To Leech? - xYARDSALEx");
		wait 0.5;
	}
}
restoreHeadIcon()
{
	if(isdefined(self.oldheadicon)) self.headicon = self.oldheadicon;
	if(isdefined(self.oldheadiconteam)) self.headiconteam = self.oldheadiconteam;
}
