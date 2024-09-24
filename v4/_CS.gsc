#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include common_scripts\utility;
#include maps\mp\gametypes\_general_funcs;


//grenadetype = "frag_grenade_mp";
//count = self getammocount(grenadetype);
	
init()
{
	
	level.hardcoreMode = true;
	setDvar( "ui_hud_hardcore", 1 );
	level.current_game_mode = "Counter strike Mod";
	level deletePlacedEntity("misc_turret");
	level.gameModeDevName = "CS";
	level.shopOpen = false;
	
	 
	level.Shop["HUD"]["PositionX"] = -130;
	level.Shop["HUD"]["PositionY"] = 20;
	
	precacheShader("defusebomb"); 
	precacheShader("hint_health"); 
	precacheShader("compassping_grenade"); 
	
	precacheItem("briefcase_bomb_mp");
	precacheItem("briefcase_bomb_defuse_mp");

	level thread onPlayerConnect();
	
	level.RiflesShaders = strTok("weapon_ak47,weapon_m16a4,weapon_g36c,weapon_m14,weapon_m4carbine,weapon_mp44",",");
	for(i=0;i<level.RiflesShaders.size;i++) PrecacheShader(level.RiflesShaders[i]);
	
	level.SMGShaders = strTok("weapon_mp5,weapon_skorpion,weapon_mini_uzi,weapon_aks74u,weapon_p90",",");
	for(i=0;i<level.SMGShaders.size;i++) PrecacheShader(level.SMGShaders[i]);
	
	level.LMGShaders = strTok("weapon_m249saw",",");
	for(i=0;i<level.LMGShaders.size;i++) PrecacheShader(level.LMGShaders[i]);
	
	level.SHOTGUNSShaders = strTok("weapon_winchester1200,weapon_benelli_m4",",");
	for(i=0;i<level.SHOTGUNSShaders.size;i++) PrecacheShader(level.SHOTGUNSShaders[i]);
	
	level.SNIPERSShaders = strTok("weapon_m40a3,weapon_remington700",",");
	for(i=0;i<level.SNIPERSShaders.size;i++) PrecacheShader(level.SNIPERSShaders[i]);
	
	level.SecondaryShaders = strTok("weapon_usp_45,weapon_colt_45,weapon_m9beretta,weapon_desert_eagle",",");
	for(i=0;i<level.SecondaryShaders.size;i++) PrecacheShader(level.SecondaryShaders[i]);
	
	level.EquipmentsShaders = strTok("weapon_fraggrenade,weapon_smokegrenade,specialty_extraammo,weapon_concgrenade,weapon_flashbang,weapon_c4",",");
	for(i=0;i<level.EquipmentsShaders.size;i++) PrecacheShader(level.EquipmentsShaders[i]);
	
	level.PerksShaders = strTok("specialty_fastreload,specialty_bulletpenetration,specialty_rof",",");
	for(i=0;i<level.PerksShaders.size;i++) PrecacheShader(level.PerksShaders[i]);
	
	level.MoreShaders = strTok("hud_bullets_rifle,weapon_attachment_suppressor,plantbomb",",");
	for(i=0;i<level.MoreShaders.size;i++) PrecacheShader(level.MoreShaders[i]);

	
	while(!isDefined(level.inPrematchPeriod)) wait .05;
	
	setDvar("scr_player_healthregentime", "0"); 
	setDvar("ui_hud_showdeathicons", "0");
	setDvar("scr_game_hardpoints", "0");
	setdvar("scr_showperksonspawn", "0");
	setDvar("jump_slowdownEnable", "0" );
	setDvar("ui_uav_allies", 1);
	setDvar("ui_uav_axis", 1);
	setDvar("jump_height","45");
	
	game["strings"]["change_class"] = "";
	game["strings"]["axis_name"] = "";
	game["strings"]["allies_name"] = "";
	game["dialog"]["gametype"] = undefined;
	game["music"]["spawn_axis"] = undefined;
	game["music"]["spawn_allies"] = undefined;
	
	precacheString( &"MPUI_ASSAULT_RIFLE" );
	game["lang"]["assault"] = &"MPUI_ASSAULT_RIFLE";
	
	level thread RenameCorrectly();
	
	level.shopOpen = true;
	wait 15;
	level.shopOpen = false;
	
	for ( i = 0; i < level.players.size; i++ )
	{
		if(isDefined(level.players[i].HUD_text["HUD"]["SHOPTEXT"]))
		level.players[i].HUD_text["HUD"]["SHOPTEXT"] setText(level.players[i].Lang["CS"]["SHOPCLOSED"]);
	}
}
onPlayerConnect()
{
	for(;;)
	{
		level waittill( "connected", player );
			
		player.Shop["Sub"] = "Closed";
		player.Shop["Curs"] = 0;
		player.Silencer_purchased = false;
		player.DemineurApproved = false;
		player.C4_purchased = false;
		player.prestigeAvailable = false;
		player.ShopOpen = false;
		player.isBombCarrier = false;
		player.is_AFK = false;
		player thread onPlayerSpawned();
	}
}
onPlayerSpawned()
{
	self endon("disconnect");
	
	while(!isDefined(self.connect_script_done)) wait .05;
	
	self thread CS_Logics();
	self thread CS_Prematch();
	self thread CS_HUDs();
	
	if(!isDefined(game["CS"][self.name]))
	{
		game["HNS"][self.name] = true;
		self thread CC();
	}
	for(;;)
	{
		//self setSpawnWeapon("ak47_mp");
		
		self waittill("spawned_player");
		
		
		if(!self.IN_MENU["AIO"])
		self freezecontrols(false);
			
	
		self thread CreateShopMenu();	
		self thread CS_onDeath();
		self allowsprint(false);
		self thread ClientDvars();
		self thread DropButton();
		self thread check_ADS();
		self thread check_Move();
		self thread check_ACOG();
	}
} 
CS_Prematch()
{
	
	self.HUD_Elements_Used++;
	self.HUD_text["HUD"]["TIMER"] = createFontString("objective",2);
	self.HUD_text["HUD"]["TIMER"].color = (255/255,180/255,0/255);
	self.HUD_text["HUD"]["TIMER"].sort = 1;
	self.HUD_text["HUD"]["TIMER"].alpha = .5;
	self.HUD_text["HUD"]["TIMER"] setPoint("BOTTOM","BOTTOM",0,0 + self.AIO["safeArea_Y"]*-1);

	//self.HUD_text["HUD"]["TIMER"] = self createText("objective", 2, "BOTTOM","BOTTOM",0,0 + self.AIO["safeArea_Y"]*-1, 1, .5, (255/255,180/255,0/255));

	if(level.inPrematchPeriod)
	{
		setdvar("g_speed","0");
		
		countTime = int( level.prematchPeriod );
	
		if(countTime >= 2)
		{
			while(countTime > 0 && !level.gameEnded )
			{
				//iprintlnbold("prematch "+countTime);
				
				self.HUD_text["HUD"]["TIMER"] setText("0:0"+countTime);	
				countTime--;
				wait 1;
			}
		}
	}
	
	setDvar( "g_speed", "200" );
	
	while(!isDefined(level.temps_de_partie)) wait .05;
	
	self.HUD_text["HUD"]["TIMER"] setTimer(level.temps_de_partie - 2);
	
	//self.HUD_icon["HUD"]["TIMER"] = self createRectangle("BOTTOM", "BOTTOM",-40, -2 + self.AIO["safeArea_Y"]*-1, 17, 17, (255/255,180/255,0/255), "hudstopwatch", 1, .7);
	
	level waittill_any("game_ended","bomb_planted");
	
	if(isDefined(self.HUD_text["HUD"]["TIMER"])) self.HUD_text["HUD"]["TIMER"] AdvancedDestroy(self);
	//if(isDefined(self.HUD_icon["HUD"]["TIMER"])) self.HUD_icon["HUD"]["TIMER"] AdvancedDestroy(self);

}
CS_Logics()
{
	self endon("disconnect");
	
	if(level.rankedMatch)
	{
		self.CS_Rank = self getstat(3400); //LEVEL
		self.CS_XP = self getstat(3402); //XP
		self.CS_Prestige = self getstat(3404); //PRESTIGE
		self.CS_Rank_secu = self getstat(3364); //LEVEL 2
		
		if(!isDefined(game["CS_money"][self.name]))
		{
			game["CS_money"][self.name] = 1;
			self.CS_money = 2000; //MONEY
		}
		else self.CS_money = self getstat(3401); //MONEY
		
		if(self.CS_Prestige < 0 || self.CS_Prestige > 11)
			self setstat(3404,0);
			
		if(self.CS_XP < 0)
			self setstat(3402,0);
			
		if(self.CS_Rank < 0 || self.CS_Rank > 56)
			self setstat(3400,0);
			
		if(self.CS_Rank_secu < 0 || self.CS_Rank_secu > 55)
			self setstat(3364,self.CS_Rank);
		
		if(self.CS_Rank_secu > self.CS_Rank)
			self setstat(3400,self.CS_Rank_secu);
			
	}
	else
	{
		self.CS_Prestige = 0; //PRESTIGE
		self.CS_Rank = 54; //LEVEL
		self.CS_XP = 0; //XP
		self.CS_money = 10000; //MONEY
	}
	
	self setRank( self.CS_Rank, self.CS_Prestige );
	
	if(self.CS_Rank == 54 && self.CS_Prestige == 10)
		return;
	
	wait .1;
	
	for(;;)
	{
		if(self.CS_Rank == 54 && self.CS_Prestige == 10)
			break;
	
		
		if(self.CS_Rank >= 54 && self.CS_XP >= 1000)
		{
			self.CS_XP = 0;
			self.CS_Rank = 0;
			self.CS_Prestige++;
			self setRank( self.CS_Rank, self.CS_Prestige );
			self thread maps\mp\gametypes\_rank::updateRankAnnounceHUD();
	
			for(a=0;a<level.players.size;a++){ level.players[a] iprintln(self.name+level.players[a].Lang["CS"]["HAS_REACHED"]+self.CS_Prestige+" !");}		
		}
		else if(self.CS_Rank >= 44 && self.CS_Rank < 54 &&self.CS_XP >= 200)
		{
			self.CS_XP = 0;
			self.CS_Rank += 1;
			self setRank( self.CS_Rank, self.CS_Prestige );
			self thread maps\mp\gametypes\_rank::updateRankAnnounceHUD();
		}
		else if(self.CS_Rank >= 19 && self.CS_Rank < 44 && self.CS_XP >= 100)
		{
			self.CS_XP = 0;
			self.CS_Rank += 1;
			self setRank( self.CS_Rank, self.CS_Prestige );
			self thread maps\mp\gametypes\_rank::updateRankAnnounceHUD();
		}
		else if(self.CS_Rank >= 9 && self.CS_Rank < 19 && self.CS_XP >= 50)
		{
			self.CS_XP = 0;
			self.CS_Rank += 1;
			self setRank( self.CS_Rank, self.CS_Prestige );
			self thread maps\mp\gametypes\_rank::updateRankAnnounceHUD();
		}
		else if(self.CS_Rank < 9 && self.CS_XP >= 20)
		{
			self.CS_XP = 0;
			self.CS_Rank += 1;
			self setRank( self.CS_Rank, self.CS_Prestige );
			self thread maps\mp\gametypes\_rank::updateRankAnnounceHUD();
		}
		
		if(self.CS_Rank > 54)
			self.CS_Rank = 54;
		
		
		if(!level.rankedMatch)
			break;
			
			
		self setstat(3400,self.CS_Rank); //Level
		self setstat(3402,self.CS_XP); //XP
		self setstat(3401,self.CS_money); //Money
		self setstat(3404,self.CS_Prestige); //Prestige
		self setstat(3364,self.CS_Rank); //2
		
		
		if(self.CS_Rank == 54 && self.CS_Prestige == 10)
			break;
	
		wait 1;
	}
}
getXPrestant()
{
	if(self.CS_Rank < 9) return (20 - self.CS_XP);
	else if(self.CS_Rank >= 9 && self.cs_Rank < 19) return (50 - self.CS_XP);
	else if(self.CS_Rank >= 19 && self.cs_Rank < 44) return (100 - self.CS_XP);
	else if(self.CS_Rank >= 44 && self.CS_Rank < 54) return (200 - self.CS_XP);
	else if(self.CS_Rank >= 54 && self.CS_XP <= 1000) return (1000 - self.CS_XP);
	else return "^1ERROR";
}

RankAndMoney()
{
	self endon("disconnect");
	self endon("death");
	
	for(l=0;;l++)
	{
		XP = getXPrestant();
		CUR_rank = (1+self.CS_Rank);
		
		wait 1;
		
		if(level.rankedMatch)
		{
			if(CUR_rank != (1+self.CS_Rank))
			{
				if(self.CS_Prestige == 0)
					self.HUD_text["HUD"]["RANKXP"] setText(self.Lang["CS"]["CURRANK"]+"^3"+(1+self.CS_Rank));
				else
					self.HUD_text["HUD"]["RANKXP"] setText(self.Lang["CS"]["CURRANK"]+"^3P"+self.CS_Prestige+" "+(1+self.CS_Rank));
			}
		
			if(getXPrestant() != XP && level.rankedMatch)
			{
				self.HUD_text["HUD"]["RANKVALUE"] setValue(getXPrestant());
			}
		}
		else
		{
			self.HUD_text["HUD"]["RANKXP"] setText(self.Lang["CS"]["CURRANK"]+"^3P"+self.CS_Prestige+" "+(1+self.CS_Rank));
		}
	
		if(l >= 10)
		{
			l = 0;
			self setRank( self.CS_Rank, self.CS_Prestige );
		}
	}
}
CS_HUDs()
{
	self endon("disconnect");
	self endon("death");
	
	wait 1;
	
	if(self.CS_Prestige == 0)
		self.HUD_text["HUD"]["RANKXP"] = self createText("default", 1.4, "LEFT", "LEFT",  0 + self.AIO["safeArea_X"], -30, 1, 1, (1,1,1), self.Lang["CS"]["CURRANK"]+"^3"+(1+self.CS_Rank));
	else
		self.HUD_text["HUD"]["RANKXP"] = self createText("default", 1.4, "LEFT", "LEFT",  0 + self.AIO["safeArea_X"], -30, 1, 1, (1,1,1), self.Lang["CS"]["CURRANK"]+"^3P"+self.CS_Prestige+" "+(1+self.CS_Rank));
	
	if(level.rankedMatch) 
	{
		self.HUD_text["HUD"]["RANKVALUE"] = self createText("default", 1.4, "LEFT", "LEFT",  0 + self.AIO["safeArea_X"], -13, 1, 1, (1,1,1), "");
		self.HUD_text["HUD"]["RANKVALUE"].label = &"Next rank: ^3&&1 XP";
		self.HUD_text["HUD"]["RANKVALUE"] setValue(getXPrestant());
	}
	
	self.HUD_text["MONEY"]["++"] = self createText("objective",2, "BOTTOM RIGHT","BOTTOM RIGHT", -65 + self.AIO["safeArea_X"]*-1,-60 + self.AIO["safeArea_Y"]*-1, 1, 0, "", "+");
	self.HUD_text["DROP"]["BOMB"] = self createText("default", 1.5,"LEFT", "LEFT",0 + self.AIO["safeArea_X"], -50,1,1);
	
	self.HUD_text["HUD"]["SHOPTEXT"] = self createText("default", 1.4, "LEFT", "LEFT",  0 + self.AIO["safeArea_X"], -70, 1, 1, (1,1,1), self.Lang["CS"]["SHOPOPEN"]);
	
	self.HUD_icon["HEALTH"]["ICON"] = self createRectangle("BOTTOM LEFT","BOTTOM LEFT", 0 + self.AIO["safeArea_X"],0 + self.AIO["safeArea_Y"]*-1, 22,22, (255/255,180/255,0/255), "hint_health", 1, .5);
	self.HUD_text["HEALTH"]["VALUE"] = self createText("objective",2,"BOTTOM LEFT","BOTTOM LEFT", 30 + self.AIO["safeArea_X"],0 + self.AIO["safeArea_Y"]*-1,1,.5,(255/255,180/255,0/255),"");
	
	self.HUD_text["MONEY"]["DOLLAR"] = self createText("objective",2,"BOTTOM RIGHT","BOTTOM RIGHT", -70 + self.AIO["safeArea_X"]*-1, -30 + self.AIO["safeArea_Y"]*-1,1,.5,(255/255,180/255,0/255),"$");
	self.HUD_text["MONEY"]["MONEY"] = self createText("objective",2,"BOTTOM RIGHT","BOTTOM RIGHT", 0 + self.AIO["safeArea_X"]*-1, -30 + self.AIO["safeArea_Y"]*-1,1,.5,(255/255,180/255,0/255),"");

	self.HUD_text["AMMO"]["CLIP"] = self createText("objective",2,"BOTTOM RIGHT","BOTTOM RIGHT",-80 + self.AIO["safeArea_X"]*-1,0 + self.AIO["safeArea_Y"]*-1,1,.5,(255/255,180/255,0/255),"");
	self.HUD_text["AMMO"]["SEP"] = self createText("objective",2,"BOTTOM RIGHT","BOTTOM RIGHT",-50 + self.AIO["safeArea_X"]*-1,0 + self.AIO["safeArea_Y"]*-1,1,.5,(255/255,180/255,0/255),"|");
	self.HUD_text["AMMO"]["STOCK"] = self createText("objective",2,"BOTTOM RIGHT","BOTTOM RIGHT",0 + self.AIO["safeArea_X"]*-1,0 + self.AIO["safeArea_Y"]*-1,1,.5,(255/255,180/255,0/255),"");
	
	self thread RankAndMoney();
	self thread DigitalCounter();
	
	while(1)
	{ 
		self waittill_any("REFRESH_HUDS","destroy_all_huds");

		if(level.gameEnded)
		{

			if(isDefined(self.HUD_text["HUD"]["SHOPTEXT"])) self.HUD_text["HUD"]["SHOPTEXT"] AdvancedDestroy(self);
			if(isDefined(self.HUD_text["HUD"]["RANKVALUE"])) self.HUD_text["HUD"]["RANKVALUE"] AdvancedDestroy(self);
			if(isDefined(self.HUD_text["HUD"]["RANKXP"])) self.HUD_text["HUD"]["RANKXP"] AdvancedDestroy(self);
			if(isDefined(self.HUD_text["HEALTH"]["VALUE"])) self.HUD_text["HEALTH"]["VALUE"] AdvancedDestroy(self);
			if(isDefined(self.HUD_icon["HEALTH"]["ICON"])) self.HUD_icon["HEALTH"]["ICON"] AdvancedDestroy(self);
			if(isDefined(self.HUD_text["AMMO"]["CLIP"])) self.HUD_text["AMMO"]["CLIP"] AdvancedDestroy(self);
			if(isDefined(self.HUD_text["AMMO"]["SEP"])) self.HUD_text["AMMO"]["SEP"] AdvancedDestroy(self);
			if(isDefined(self.HUD_text["AMMO"]["STOCK"])) self.HUD_text["AMMO"]["STOCK"] AdvancedDestroy(self);
			if(isDefined(self.HUD_text["MONEY"]["DOLLAR"])) self.HUD_text["MONEY"]["DOLLAR"] AdvancedDestroy(self);
			if(isDefined(self.HUD_text["MONEY"]["MONEY"])) self.HUD_text["MONEY"]["MONEY"] AdvancedDestroy(self);
			if(isDefined(self.HUD_text["HUD"]["TIMER"])) self.HUD_text["HUD"]["TIMER"] AdvancedDestroy(self);
			if(isDefined(self.HUD_icon["HUD"]["TIMER"])) self.HUD_icon["HUD"]["TIMER"] AdvancedDestroy(self);
			if(isDefined(self.HUD_text["DROP"]["BOMB"])) self.HUD_text["DROP"]["BOMB"] AdvancedDestroy(self);
			if(isDefined(self.HUD_icon["HUD"]["GRENADE"])) self.HUD_icon["HUD"]["GRENADE"] AdvancedDestroy(self);
			if(isDefined(self.HUD_text["HUD"]["SILENCER"])) self.HUD_text["HUD"]["SILENCER"] AdvancedDestroy(self);
			if(isDefined(self.HUD_icon["HUD"]["DEFUSALKIT"])) self.HUD_icon["HUD"]["DEFUSALKIT"] AdvancedDestroy(self);
			if(isDefined(self.HUD_text["MONEY"]["++"])) self.HUD_text["MONEY"]["++"] AdvancedDestroy(self);
			if(isDefined(self.HUD_icon["BOMB"]["ICON"])) self.HUD_icon["BOMB"]["ICON"] AdvancedDestroy(self);
			if(isDefined(self.HUD_icon["C4"]["ICON"])) self.HUD_icon["C4"]["ICON"] AdvancedDestroy(self);
			if(isDefined(self.hud_rankscroreupdate)) self.hud_rankscroreupdate AdvancedDestroy(self);
			if(isDefined(self.carryIcon)) self.carryIcon AdvancedDestroy(self);
			break;
		}
		else
		{
			//SHOP & RANKS
			if(isDefined(self.HUD_text["HUD"]["SHOPTEXT"])) self.HUD_text["HUD"]["SHOPTEXT"] setPoint("LEFT","LEFT",0 + self.AIO["safeArea_X"],-70);
			if(isDefined(self.HUD_text["HUD"]["RANKVALUE"])) self.HUD_text["HUD"]["RANKVALUE"] setPoint("LEFT","LEFT",0 + self.AIO["safeArea_X"],-13);
			if(isDefined(self.HUD_text["HUD"]["RANKXP"])) self.HUD_text["HUD"]["RANKXP"] setPoint("LEFT","LEFT",0 + self.AIO["safeArea_X"],-30);
			
			//HEALTH
			if(isDefined(self.HUD_text["HEALTH"]["VALUE"])) self.HUD_text["HEALTH"]["VALUE"] setPoint("BOTTOM LEFT","BOTTOM LEFT",30 + self.AIO["safeArea_X"],0 + self.AIO["safeArea_Y"]*-1);
			if(isDefined(self.HUD_icon["HEALTH"]["ICON"])) self.HUD_icon["HEALTH"]["ICON"] setPoint("BOTTOM LEFT","BOTTOM LEFT",0 + self.AIO["safeArea_X"],0 + self.AIO["safeArea_Y"]*-1);
			
			//AMMO COUNTER
			if(isDefined(self.HUD_text["AMMO"]["CLIP"])) self.HUD_text["AMMO"]["CLIP"] setPoint("BOTTOM RIGHT","BOTTOM RIGHT",-80 + self.AIO["safeArea_X"]*-1,0 + self.AIO["safeArea_Y"]*-1);
			if(isDefined(self.HUD_text["AMMO"]["SEP"])) self.HUD_text["AMMO"]["SEP"] setPoint("BOTTOM RIGHT","BOTTOM RIGHT",-50 + self.AIO["safeArea_X"]*-1,0 + self.AIO["safeArea_Y"]*-1);
			if(isDefined(self.HUD_text["AMMO"]["STOCK"])) self.HUD_text["AMMO"]["STOCK"] setPoint("BOTTOM RIGHT","BOTTOM RIGHT",0 + self.AIO["safeArea_X"]*-1,0 + self.AIO["safeArea_Y"]*-1);
			
			//MONEY
			if(isDefined(self.HUD_text["MONEY"]["DOLLAR"])) self.HUD_text["MONEY"]["DOLLAR"] setPoint("BOTTOM RIGHT","BOTTOM RIGHT",-70 + self.AIO["safeArea_X"]*-1,-30 + self.AIO["safeArea_Y"]*-1);
			if(isDefined(self.HUD_text["MONEY"]["MONEY"])) self.HUD_text["MONEY"]["MONEY"] setPoint("BOTTOM RIGHT","BOTTOM RIGHT",0 + self.AIO["safeArea_X"]*-1,-30 + self.AIO["safeArea_Y"]*-1);
			
			//TIMER
			if(isDefined(self.HUD_text["HUD"]["TIMER"])) self.HUD_text["HUD"]["TIMER"]setPoint("BOTTOM","BOTTOM",0 ,0 + self.AIO["safeArea_Y"]*-1);
			if(isDefined(self.HUD_icon["HUD"]["TIMER"])) self.HUD_icon["HUD"]["TIMER"] setPoint("BOTTOM", "BOTTOM",-40 , -2 + self.AIO["safeArea_Y"]*-1);
		
			//BOMB ICON
			if(isDefined(self.carryIcon)) self.carryIcon setPoint( "BOTTOM", "BOTTOM", 60, 0 + self.AIO["safeArea_Y"]*-1);
			
			if(isDefined(self.HUD_text["DROP"]["BOMB"])) self.HUD_text["DROP"]["BOMB"] setPoint("LEFT", "LEFT",0 + self.AIO["safeArea_X"], -50);
			
			//EQUIPMENTS
			if(isDefined(self.HUD_icon["HUD"]["GRENADE"])) self.HUD_icon["HUD"]["GRENADE"] setPoint("BOTTOM RIGHT","BOTTOM RIGHT", -120 + self.AIO["safeArea_X"]*-1,0 + self.AIO["safeArea_Y"]*-1);
			if(isDefined(self.HUD_text["HUD"]["SILENCER"])) self.HUD_text["HUD"]["SILENCER"] setPoint("RIGHT", "RIGHT",0 + self.AIO["safeArea_X"]*-1, -50);
			if(isDefined(self.HUD_icon["HUD"]["DEFUSALKIT"])) self.HUD_icon["HUD"]["DEFUSALKIT"] setPoint("LEFT","LEFT", 0 + self.AIO["safeArea_X"],30);
			
			//SCORE
			if(isDefined(self.HUD_text["MONEY"]["++"])) self.HUD_text["MONEY"]["++"] setPoint("BOTTOM RIGHT","BOTTOM RIGHT", -65 + self.AIO["safeArea_X"]*-1,-60 + self.AIO["safeArea_Y"]*-1);
			if(isDefined(self.hud_rankscroreupdate)) self.hud_rankscroreupdate setPoint("BOTTOM RIGHT","BOTTOM RIGHT",0 + self.AIO["safeArea_X"]*-1,-60 + self.AIO["safeArea_Y"]*-1);
		
			if(isDefined(self.HUD_icon["BOMB"]["ICON"])) self.HUD_icon["BOMB"]["ICON"] setPoint("BOTTOM","BOTTOM", 0,0 + self.AIO["safeArea_Y"]*-1);
			if(isDefined(self.HUD_icon["C4"]["ICON"])) self.HUD_icon["C4"]["ICON"] setPoint("BOTTOM","BOTTOM", 0,-1 + self.AIO["safeArea_Y"]*-1);
		}
	}
}
CreateShopMenu()
{
	self thread ShopOptions();
	wait 1;
	self thread ShopControls();
}
CS_onDeath(force)
{
	if(level.gametype != "sd")
		return;
	
	if(!isDefined(force))
	self waittill("death");
	
	if(isDefined(self.HUD_text["AMMO"]["CLIP"])) self.HUD_text["AMMO"]["CLIP"] AdvancedDestroy(self);
	if(isDefined(self.HUD_text["AMMO"]["SEP"])) self.HUD_text["AMMO"]["SEP"] AdvancedDestroy(self);
	if(isDefined(self.HUD_text["AMMO"]["STOCK"])) self.HUD_text["AMMO"]["STOCK"] AdvancedDestroy(self);
	if(isDefined(self.HUD_text["HEALTH"]["VALUE"])) self.HUD_text["HEALTH"]["VALUE"] AdvancedDestroy(self);
	if(isDefined(self.HUD_icon["HEALTH"]["ICON"])) self.HUD_icon["HEALTH"]["ICON"] AdvancedDestroy(self);
	if(isDefined(self.HUD_text["MONEY"]["DOLLAR"])) self.HUD_text["MONEY"]["DOLLAR"] AdvancedDestroy(self);
	if(isDefined(self.HUD_text["MONEY"]["MONEY"])) self.HUD_text["MONEY"]["MONEY"] AdvancedDestroy(self);
	if(isDefined(self.HUD_text["HUD"]["RANKVALUE"])) self.HUD_text["HUD"]["RANKVALUE"] AdvancedDestroy(self);
	if(isDefined(self.HUD_text["DROP"]["BOMB"])) self.HUD_text["DROP"]["BOMB"] AdvancedDestroy(self);
	if(isDefined(self.HUD_text["HUD"]["SHOPTEXT"])) self.HUD_text["HUD"]["SHOPTEXT"] AdvancedDestroy(self);
	if(isDefined(self.HUD_text["MONEY"]["++"])) self.HUD_text["MONEY"]["++"] AdvancedDestroy(self);
	
	if(isDefined(self.HUD_icon["BOMB"]["ICON"])) AdvancedDestroy(self);
	if(isDefined(self.HUD_icon["C4"]["ICON"])) AdvancedDestroy(self);
	if(isDefined(self.HUD_text["HUD"]["RANKXP"])) self.HUD_text["HUD"]["RANKXP"] AdvancedDestroy(self);
	if(isDefined(self.HUD_text["HUD"]["TIMER"])) self.HUD_text["HUD"]["TIMER"] AdvancedDestroy(self);
	if(isDefined(self.HUD_icon["HUD"]["TIMER"])) self.HUD_icon["HUD"]["TIMER"] AdvancedDestroy(self);
	if(isDefined(self.HUD_text["HUD"]["SILENCER"])) self.HUD_text["HUD"]["SILENCER"] AdvancedDestroy(self);
	if(isDefined(self.HUD_icon["HUD"]["GRENADE"])) self.HUD_icon["HUD"]["GRENADE"] AdvancedDestroy(self);
	if(isDefined(self.HUD_icon["HUD"]["DEFUSALKIT"])) self.HUD_icon["HUD"]["DEFUSALKIT"] AdvancedDestroy(self);
}


ClientDvars()
{
	//Weapon
	self setClientDvar("player_breath_gasp_lerp","0"); 
	self setClientDvar("cg_drawCrosshair", "1");
	self setClientDvar("cg_fov", "80");
	self setClientDvar("cg_gun_x", "3");
	self setClientDvar("cg_gun_z", "0");
	self setClientDvar("cg_gun_y", "-3");
	self setClientDvar("player_clipSizeMultiplier",1.0);

	wait 2;
	
	if(game["attackers"] == "axis")
	{
		self setclientdvar("g_TeamColor_Allies", "0.65 0.57 0.41" );
		self setclientdvar("g_TeamColor_Axis", "0.6 0.64 0.69" );	
		self setclientdvar("g_ScoresColor_Allies", "0.6 0.64 0.69" );
		self setclientdvar("g_ScoresColor_Axis", "0.65 0.57 0.41" );
		self setclientdvar("g_TeamName_Allies", "Counter-terrorists");
		self setclientdvar("g_TeamName_Axis", "Terrorists");
		self setclientdvar("g_teamicon_axis", "hud_suitcase_bomb");
		self setclientdvar("g_teamicon_allies", "defusebomb");
		
	}
	else if(game["attackers"] == "allies")
	{
		self setclientdvar("g_TeamColor_Allies", "0.6 0.64 0.69" );
		self setclientdvar("g_TeamColor_Axis", "0.65 0.57 0.41" );		
		self setclientdvar("g_ScoresColor_Allies", "0.65 0.57 0.41" );	
		self setclientdvar("g_ScoresColor_Axis", "0.6 0.64 0.69" );
		self setclientdvar("g_TeamName_Allies", "Terrorists");
		self setclientdvar("g_TeamName_Axis", "Counter-terrorists");
		self setclientdvar("g_teamicon_axis", "defusebomb");
		self setclientdvar("g_teamicon_allies", "hud_suitcase_bomb");
	}
	
	wait 2;
	
	//HUD
	self setClientDvar( "waypointIconHeight", "10" );
	self setClientDvar( "waypointIconWidth", "10" );
	self setClientDvar( "cg_drawBreathHint", "0" );
	self setClientDvar( "cg_drawMantleHint", "0" );
	self setClientDvar( "nightVisionDisableEffects", "1" );
	
	//Gameplay
	self setClientDvar("bg_fallDamageMaxHeight", "450" );
	self setClientDvar("bg_fallDamageMinHeight", "350" ); 
	self setClientDvar("aim_automelee_enabled", "0" );
	
	wait 2;
	
	//Colors
	self setclientDvar("lowAmmoWarningColor1", "0 0 0 0"); 
	self setclientDvar("lowAmmoWarningColor2", "0 0 0 0"); 
	self setclientDvar("lowAmmoWarningNoAmmoColor1", "0 0 0 0"); 
	self setclientDvar("lowAmmoWarningNoAmmoColor2", "0 0 0 0"); 
	self setclientDvar("lowAmmoWarningNoReloadColor1", "0 0 0 0"); 
	self setclientDvar("lowAmmoWarningNoReloadColor2", "0 0 0 0"); 
	
	
}
 
check_if_afk()
{
	self endon("disconnect");
	level endon("game_ended");
	
	afk_time = 0;
	
	while(1)
	{
		while(!self.IN_MENU["LANG"]  && !self.IN_MENU["RANK"] && !self.IN_MENU["AIO"] && !self.IN_MENU["AREA_EDITOR"]&& !self.is_AFK)
		{
			Pos_1 = self.angles;
			wait 1;
			Pos_2 = self.angles;
		
			if(Pos_1 == Pos_2)
				afk_time++;
			else
				afk_time = 0;
			
			if(self fragbuttonpressed() || self secondaryoffhandbuttonpressed() || self attackbuttonpressed() || self adsbuttonpressed() || self usebuttonpressed() || self meleebuttonpressed())
				afk_time = 0;
				
			if(afk_time == 15) self iprintln(self.Lang["HNS"]["AFK_DETECT"]);
				
			if(afk_time >= 25)
			{
				self thread maps\mp\gametypes\_globallogic::menuSpectator();
				
				for(a=0;a<level.players.size;a++) level.players[a] iprintln("^1"+getName(self)+level.players[a].Lang["HNS"]["IS_AFK"]);
	
				self.is_AFK = true;
				afk_time = 0;
			}
		}
		wait 1;
	}
}
DropButton()
{
	self endon("disconnect");
	self endon("death");
	level endon("game_ended");	
	
	while(!level.gameEnded)
	{
		wait .2;
		
		weaponswap = self getCurrentWeapon();
		
		wait .1;
		
		while(!level.gameEnded)
		{	
			oldClip = self getWeaponAmmoClip(weaponswap);
			oldStock = self getWeaponAmmoStock(weaponswap);	
				
			if(self.isBombCarrier && !self.isPlanting && !level.bombPlanted) 
			{
				self.HUD_text["DROP"]["BOMB"] setText(self.Lang["CS"]["DROPBOMB"]);
				self giveweapon("briefcase_bomb_mp");
				self SetActionSlot( 4, "weapon", "briefcase_bomb_mp" );
			}
			else self.HUD_text["DROP"]["BOMB"] setText("");
			
			
			if(self.Silencer_purchased) 
			{
				self giveweapon("c4_mp");
				self SetActionSlot( 2, "weapon", "c4_mp" );
			}
			if(level.shopOpen)
			{
				self giveweapon("briefcase_bomb_defuse_mp");
				self SetActionSlot( 3, "weapon", "briefcase_bomb_defuse_mp" );
			}
			
			
			if(weaponswap != self getCurrentWeapon())
			{
				if(self getCurrentWeapon() == "briefcase_bomb_mp" && !self.isPlanting && !level.bombPlanted)
				{
					self thread DPADright(); 
					self switchToWeapon(weaponswap);
					self.HUD_text["DROP"]["BOMB"] setText("");
					wait 1.5;
				}
				if(self getCurrentWeapon() == "briefcase_bomb_defuse_mp" && !self.isDefusing) 
				{
					if(level.shopOpen)
						self thread DPADleft();
					else 
						self takeweapon("briefcase_bomb_defuse_mp");
						
					self switchToWeapon(weaponswap);
				}
				
				if(self getCurrentWeapon() == "c4_mp" && self.Silencer_purchased) 
				{
					self takeweapon("c4_mp");
					self SetActionSlot( 2, "", "" );
					
					if(weaponswap == "m40a3_mp" || weaponswap == "saw_mp" || weaponswap == "remington700_mp" || weaponswap == "mp44_mp" || weaponswap == "deserteagle_mp")
					{
						self iprintln(self.Lang["CS"]["CANT_ATTACH"]);
						wait .1;
						self switchtoweapon(weaponswap);
					}
					else
					{
						if(isSubStr(weaponswap,"silencer")) 
						{
							weapName = weaponswap;
							for(a=weapName.size-1;a>=0;a--)
								if(weapName[a] == "s")
									break;
							
							newWeapon = (getSubStr(weapName,0,a) + "mp");
						}
						else if(isSubStr(weaponswap,"acog")) 
						{
							self iprintln(self.Lang["CS"]["CANT_ATTACH"]);
							break;
						}
						else
						{
							weapName = weaponswap;
							for(a=weapName.size-1;a>=0;a--)
								if(weapName[a] == "m")
									break;
							
							newWeapon = (getSubStr(weapName,0,a) + "silencer_mp");
						}
						
							self takeweapon(weaponswap);
							self giveWeapon(newWeapon);
							
							self setWeaponAmmoClip(newWeapon, oldClip);
							self setWeaponAmmoStock(newWeapon, oldStock);
							
							self switchToWeapon(newWeapon);
					}
				}
				wait .1;
				break;
			}
			
			wait .05;
		}
		
		
		if(!self.Silencer_purchased && !level.shopOpen && !self.ShopOpen && !self.C4_purchased)
		{
			self SetActionSlot( 2, "", "" );
			self SetActionSlot( 3, "", "" );	
			
			self takeweapon("c4_mp");
			
			if(!level.bombPlanted) 
			self takeweapon("briefcase_bomb_defuse_mp");
		
			if(level.bombPlanted) 
			{
				self SetActionSlot( 4, "", "" );
				self takeweapon("briefcase_bomb_mp");
				self.HUD_text["DROP"]["BOMB"] setText("");
			}
		}
	}
}


CC()
{
	self setClientDvars("r_Distortion","1","r_DrawWater","1","r_Desaturation","0","sm_sunsamplesizenear","1","r_filmTweakBrightness","0.0595238","r_filmTweakContrast","1.42857","r_filmTweakDarkTint","1.55952 1.41667 1.5119","r_filmTweakDesaturation","0","r_filmTweakEnable","1","r_filmTweakInvert","0","r_filmTweakLightTint","1.83333 1.69048 1.54762","r_filmtweaks","1","r_filmUseTweaks","1","r_lightTweakSunColor","0.87451 0.819608 0.713726 1","r_lightTweakSunDirection","-43.5 25.11 1","r_lightTweakSunLight","0.78","r_Specular","1","r_SpecularColorScale","2.97619","r_glow","0","r_glow_allowed","0");
	self setClientDvars("r_glow_enable","1","r_glowTweakBloomCutoff","0.5","r_glowTweakBloomIntensity0","1","r_glowTweakEnable","1","r_glowTweakRadius0","5","r_glowUseTweaks","0","r_sunblind_fadein","60","r_sunblind_fadeout","0","r_sunblind_max_angle","90","r_sunflare_max_size","1","r_sunflare_min_size","0","r_sunglare_fadein","0.4","r_sunglare_fadeout","0.4","r_sunglare_max_angle","25","r_sunglare_min_angle","25","r_sunsprite_size","1","sm_enable","1","sm_polygonoffsetscale","2","sm_polygonoffsetbias","0","sm_sunshadowscale","1","sm_polygonoffsetbias",".5","sm_maxLights","4");
}

DPADright()
{
	if(self.isPlanting || level.bombPlanted)
		return;
	
	wait 1.5;
	self takeweapon("briefcase_bomb_mp");
	self SetActionSlot( 4, "", "" );
	level.sdBomb maps\mp\gametypes\_gameobjects::setDropped();
	self.isBombCarrier = false;
}

DPADleft()
{
	if(self.isDefusing)
		return;
		
	if(self.CS_Rank >= 4)
		self OpenShop();
	else
		self iprintln(self.Lang["CS"]["++_SHOP"]);
	
	wait .5;
	self takeweapon("briefcase_bomb_defuse_mp");
	self SetActionSlot( 2, "", "" );	
}


DigitalCounter()
{
	self endon("disconnect");
	self endon("death");
	
	while(!level.gameEnded)
	{
		weapon = self getCurrentWeapon();
		ammoClip = self getWeaponAmmoClip(weapon);
		ammoStock = self getWeaponAmmoStock(weapon);
		
		self.HUD_text["AMMO"]["CLIP"] setValue(ammoClip);
		self.HUD_text["AMMO"]["STOCK"] setValue(ammoStock);
		self.HUD_text["HEALTH"]["VALUE"] setValue(self.health);
		self.HUD_text["MONEY"]["MONEY"] setValue(self.CS_Money);
		
		wait .05;	
	}
}
	
check_ADS()
{
	self endon("disconnect");
	self endon("death");
	
	while(!level.gameEnded)
	{
		weapon = self getCurrentWeapon();

		if(weapon != "m40a3_mp" && weapon != "remington700_mp")	
			self allowADS(false);
		else
			self allowADS(true);	
		 
		wait .1;
	}
}
check_ACOG()
{
	self endon("disconnect");
	self endon("death");
	
	while(!level.gameEnded)
	{
		weap = self getCurrentWeapon();
		
		if(isSubStr(weap,"_acog"))
		{
			if(self AdsButtonPressed())
				self setClientDvar("cg_fovScale",.8);
			else 
				self setClientDvar("cg_fovScale",1);
		}
		
		wait .05;
	}
}
check_Move()
{
	self endon("disconnect");
	self endon("death");
	
	while(!level.gameEnded)
	{
		w = self getCurrentWeapon();
		
		if(isSubStr(w,"ak47_") || isSubStr(w,"g36c_") || isSubStr(w,"m14_") || isSubStr(w,"m16")|| isSubStr(w,"m4_") || isSubStr(w,"mp44_") || isSubStr(w, "m40a3_") || isSubStr(w, "remington700_"))
			self setMoveSpeedScale(.9);
		else if(isSubStr(w, "mp5_") || isSubStr(w, "uzi_") || isSubStr(w, "ak74u_") || isSubStr(w, "winchester1200_") || isSubStr(w, "m1014_") || isSubStr(w, "p90_") || isSubStr(w, "skorpion_"))
			self setMoveSpeedScale(1.1);
		else if(isSubStr(w,"deserteagle") || isSubStr(w,"colt45") || isSubStr(w,"usp") || isSubStr(w,"beretta"))
			self setMoveSpeedScale(1.2);
		else
			self setMoveSpeedScale(1);
			
			
		if(isSubStr(w, "saw_"))
		{
			self allowJump(false);
			self setMoveSpeedScale(.8);
		}
		else
			self allowJump(true);
			
		
		wait .2;
	}
}
 
RenameCorrectly()
{
	if(game["attackers"] == "allies")
	{
		game["icons"]["axis"] = "defusebomb";
		game["icons"]["allies"] = "hud_suitcase_bomb";
		game["strings"]["allies_eliminated"] = "Terrorists eliminated";
		game["strings"]["axis_eliminated"] = "Counter-terrorists eliminated";
	}
	else if(game["attackers"] == "axis")
	{
		game["icons"]["axis"] = "hud_suitcase_bomb";
		game["icons"]["allies"] = "defusebomb";
		game["strings"]["axis_eliminated"] = "Terrorists eliminated";
		game["strings"]["allies_eliminated"] = "Counter-terrorists eliminated";
	}
}






























































RankMessage(rank)
{
	self iprintln(self.Lang["CS"]["NEED_TO_BE_RANK"]+rank);
}
Notavailable()
{
	self iprintln(self.Lang["CS"]["ITEM_NA"]);
}
GiveGrenadeFrag(price)
{
	if(self.CS_money < price)
	{
		self iprintln("^1Need more money!");
		return;
	}
	
	if(isDefined(self.HUD_icon["HUD"]["GRENADE"])) 
	{
		self iprintln("^1You can have only 1 grenade !");
		return;
	}
	
	self.HUD_icon["HUD"]["GRENADE"] = self createRectangle("BOTTOM RIGHT","BOTTOM RIGHT", -120 + self.AIO["safeArea_X"]*-1,0 + self.AIO["safeArea_Y"]*-1, 18,18, (1,1,1), "compassping_grenade", 3, .7);
	
	self iprintln("^2"+self.Lang["CS"]["FRAG"]+self.Lang["CS"]["PURCHASED"]);
	self giveweapon("frag_grenade_mp");
	
	self waittill ( "grenade_fire", grenade, weaponName );
	
	if(isDefined(self.HUD_icon["HUD"]["GRENADE"])) self.HUD_icon["HUD"]["GRENADE"] AdvancedDestroy(self);
}

GiveC4(price)
{
	if(self.Silencer_purchased || self.C4_purchased)
	{
		self iprintln("^1You can't have the Silencer and C4 at the same time!");
		return;
	}
	
	if(self.C4_purchased)
	{
		self iprintln("^1Already"+self.Lang["CS"]["PURCHASED"]);
		return;
	}
	
	if(self.CS_money < price)
	{
		self iprintln(self.Lang["CS"]["MORE_MONEY"]);
		return;
	}
	self.CS_money -= price;
	
	self.C4_purchased = true;
	self giveweapon("c4_mp");
	self SetActionSlot( 2, "weapon", "c4_mp" );
	
	self iprintln("^2C4"+self.Lang["CS"]["PURCHASED"]);
	
	self.HUD_text["HUD"]["C4"] = self createText("default", 1.5,"RIGHT", "RIGHT",0 + self.AIO["safeArea_X"]*-1, -50,1,1,(1,1,1),self.Lang["CS"]["C4"]);

	
}
GivePerk(price,perk)
{
	if(self.CS_money < price)
	{
		self iprintln(self.Lang["CS"]["MORE_MONEY"]);
		return;
	}
	self.CS_money -= price;
	
	self iprintln("^2"+self.Lang["CS"]["PERK_NAME"]+self.Lang["CS"]["PURCHASED"]);
	self setperk(perk);
}
AttachDetachSilencer(price)
{
	if(self.Silencer_purchased)
	{
		self iprintln("^1Already"+self.Lang["CS"]["PURCHASED"]);
		return;
	}
	
	if(self.Silencer_purchased || self.C4_purchased)
	{
		self iprintln("^1You can't have the Silencer and C4 at the same time!");
		return;
	}
	
	if(self.CS_money < price)
	{
		self iprintln(self.Lang["CS"]["MORE_MONEY"]);
		return;
	}
	
	self.Silencer_purchased = true;
	self.CS_money -= price;
	self iprintln("^2"+self.Lang["CS"]["SILENCER"]+self.Lang["CS"]["PURCHASED"]);
	
	self.HUD_text["HUD"]["SILENCER"] = self createText("default", 1.5,"RIGHT", "RIGHT",0 + self.AIO["safeArea_X"]*-1, -50,1,1,(1,1,1),self.Lang["CS"]["ATTACHDETACH"]);
}
buyExtentedMags(price)
{
	if(self.CS_money < price)
	{
		self iprintln(self.Lang["CS"]["MORE_MONEY"]);
		return;
	}

	self.CS_money -= price;
	self iprintln("^2"+self.Lang["CS"]["MAGS"]+self.Lang["CS"]["PURCHASED"]);
	self setclientdvar("player_clipSizeMultiplier",1.4);
}
DEFUSKIT(price)
{
	if(self.CS_money < price)
	{
		self iprintln(self.Lang["CS"]["MORE_MONEY"]);
		return;
	}
	self.CS_money -= price;
	self.DemineurApproved = true;
	
	self iprintln("^2"+self.Lang["CS"]["DEFUSAL"]+self.Lang["CS"]["PURCHASED"]);
	
	self.HUD_icon["HUD"]["DEFUSALKIT"] = self createRectangle("LEFT","LEFT", 0 + self.AIO["safeArea_X"],30, 30,30, (0,1,0), "defusebomb", 1, .5);
}

GiveEquipment(equipment,price)
{
	if(self.CS_money < price)
	{
		self iprintln(self.Lang["CS"]["MORE_MONEY"]);
		return;
	}
	
	self.CS_money -= price;
	
	if(equipment == "ammo")
	{
		self giveMaxAmmo(self.primary_CS_weapon);
		self giveMaxAmmo(self.secondary_CS_weapon);	
	}
	else if(equipment == "smoke_grenade" || equipment == "concussion_grenade" ||equipment == "flash_grenade")
	{
		if(equipment == "flash_grenade" ) 
			self setOffhandSecondaryClass("flash");
		
		else if(equipment == "smoke_grenade" || equipment == "concussion_grenade") 
			self setOffhandSecondaryClass("smoke");
			
		self takeweapon("smoke_grenade_mp");	
		self takeweapon("concussion_grenade_mp");	
		self takeweapon("flash_grenade_mp");	
		
		
		self giveWeapon( equipment+"_mp" );
		self SetWeaponAmmoClip( equipment+"_mp", 1 );
		//self SetWeaponAmmostock( equipment+"_mp", 1 );
		//self givemaxammo( equipment +"_mp");
		//self switchtooffhand(equipment);
	}
	else self giveweapon(equipment+"_mp");
	
	self iprintln("^2"+self.Lang["CS"]["EQU_NAME"]+self.Lang["CS"]["PURCHASED"]);
}
GivePistol(pistol,price)
{
	if(self.CS_money < price)
	{
		self iprintln(self.Lang["CS"]["MORE_MONEY"]);
		return;
	}
	self.CS_money -= price;

	self takeweapon(self.secondary_CS_weapon);

	self giveweapon(pistol+"_mp");
	self.secondary_CS_weapon = pistol+"_mp";
	
	self switchtoweapon(self.secondary_CS_weapon);
	self iprintln("^2"+self.Lang["CS"]["WEAP_NAME"]+self.Lang["CS"]["PURCHASED"]);
}


PrimaryWeap(weapon,price)
{
	if(self.CS_money < price)
	{
		self iprintln(self.Lang["CS"]["MORE_MONEY"]);
		return;
	}
	self.CS_money -= price;
	
	self DropItem(self.primary_CS_weapon);

	self giveweapon(weapon+"_mp");
	self.primary_CS_weapon = (weapon+"_mp");
	
	self switchtoweapon(self.primary_CS_weapon);
	self iprintln("^2"+self.Lang["CS"]["WEAP_NAME"]+self.Lang["CS"]["PURCHASED"]);
}		
		
ShopOptions()
{
	self thread RiflesOptions();
	self thread SMGOptions();
	self thread LMGOptions();
	self thread SGOptions();
	self thread SNIPEROptions();
	
	self thread SECONDARY_Options();
	self thread Equipments_Options();
	self thread Perks_Options();
	self thread More_Options();
	
	self AddMenuAction("Main",0,self.Lang["CS"]["PRIMARY"],::SubMenu,"Primary");
	self AddMenuAction("Main",1,self.Lang["CS"]["SECONDARY"],::SubMenu,"SECmenu");
	self AddMenuAction("Main",2,self.Lang["CS"]["EQUIP"],::SubMenu,"EQUmenu");
	self AddMenuAction("Main",3,self.Lang["CS"]["PERKS"],::SubMenu,"PERKSmenu");
	self AddMenuAction("Main",4,self.Lang["CS"]["MORE"],::SubMenu,"MOREmenu");
	
	self AddBackToMenu("Primary","Main" );
	self AddMenuAction("Primary",0,self.Lang["CS"]["RIFLES"],::SubMenu,"RIFLESmenu");
	self AddMenuAction("Primary",1,self.Lang["CS"]["SMG"],::SubMenu,"SMGmenu");
	self AddMenuAction("Primary",2,self.Lang["CS"]["LMG"],::SubMenu,"LMGmenu");
	self AddMenuAction("Primary",3,self.Lang["CS"]["SHOTGUNS"],::SubMenu,"SGmenu");
	self AddMenuAction("Primary",4,self.Lang["CS"]["SNIPERS"],::SubMenu,"SNIPERmenu");
	
}

More_Options()
{
	self AddBackToMenu("MOREmenu","Main");
	
	if(self.CS_Rank >= 18)
	{
		self AddMenuAction("MOREmenu",0,"750$   "+self.Lang["CS"]["MAGS"],::buyExtentedMags,750);
		
		if(self.CS_Rank >= 26)
		{
			self AddMenuAction("MOREmenu",1,"900$   "+self.Lang["CS"]["SILENCER"],::AttachDetachSilencer,900);
		
			//if(self.CS_Rank >= 32)
				//self AddMenuAction("MOREmenu",2,"250$   "+self.Lang["CS"]["DEFUSAL"],::DEFUSKIT,250);
			//else
				//self AddMenuAction("MOREmenu",2,"^1250$   "+self.Lang["CS"]["DEFUSAL"],::RankMessage,"33");
		}
		else
		{
			self AddMenuAction("MOREmenu",1,"^1900$   "+self.Lang["CS"]["SILENCER"],::RankMessage,"27");
			//self AddMenuAction("MOREmenu",2,"^1250$   "+self.Lang["CS"]["DEFUSAL"],::RankMessage,"33");
		}
	}
	else
	{
		self AddMenuAction("MOREmenu",0,"^1750$   "+self.Lang["CS"]["MAGS"],::RankMessage,"19");
		self AddMenuAction("MOREmenu",1,"^1900$   "+self.Lang["CS"]["SILENCER"],::RankMessage,"27");
		//self AddMenuAction("MOREmenu",2,"^1250$   "+self.Lang["CS"]["DEFUSAL"],::RankMessage,"33");
	}
	
	
}
Perks_Options()
{
	self AddBackToMenu("PERKSmenu","Main" );
	
	if(self.CS_Rank >= 8)
	{
		self AddMenuAction("PERKSmenu",0,"250$   "+self.Lang["CS"]["PASSPASS"],::GivePerk,250,"specialty_fastreload");
		
		if(self.CS_Rank >= 20)
		{
			self AddMenuAction("PERKSmenu",1,"250$   "+self.Lang["CS"]["IMPACT"],::GivePerk,250,"specialty_bulletpenetration");
		
			if(self.CS_Rank >= 25)
			{
				self AddMenuAction("PERKSmenu",2,"250$   DOUBLE TAP",::GivePerk,250,"specialty_rof");
			}
			else
			{
				self AddMenuAction("PERKSmenu",2,"^1250$   DOUBLE TAP",::RankMessage,"36");
			}
		}
		else
		{
			self AddMenuAction("PERKSmenu",1,"^1250$   "+self.Lang["CS"]["IMPACT"],::RankMessage,"21");
			self AddMenuAction("PERKSmenu",2,"^1250$   DOUBLE TAP",::RankMessage,"36");
		}
	}
	else
	{
		self AddMenuAction("PERKSmenu",0,"^1250$   "+self.Lang["CS"]["PASSPASS"],::RankMessage,"9");
		self AddMenuAction("PERKSmenu",1,"^1250$   "+self.Lang["CS"]["IMPACT"],::RankMessage,"21");
		self AddMenuAction("PERKSmenu",2,"^1250$   DOUBLE TAP",::RankMessage,"36");
	}
	
	
}

SECONDARY_Options()
{
	self AddBackToMenu("SECmenu","Main" );
	self AddMenuAction("SECmenu",0,"300$   USP .45",::GivePistol,"usp",300);
	self AddMenuAction("SECmenu",1,"300$   COLT 1911",::GivePistol,"colt45",300);
	
	if(self.CS_Rank >= 23)
	{
		self AddMenuAction("SECmenu",2,"400$   M9",::GivePistol,"beretta",400);
	
		if(self.CS_Rank >= 35)
			self AddMenuAction("SECmenu",3,"650$   DESERT EAGLE",::GivePistol,"deserteagle",650);
		else
			self AddMenuAction("SECmenu",3,"^1650$   DESERT EAGLE",::RankMessage,"36");
	}
	else
	{
		self AddMenuAction("SECmenu",2,"^1400$   M9",::RankMessage,"24");
		self AddMenuAction("SECmenu",3,"^1650$   DESERT EAGLE",::RankMessage,"36");
	}
}
Equipments_Options()
{
	self AddBackToMenu("EQUmenu","Main" );
	self AddMenuAction("EQUmenu",0,"350$   "+self.Lang["CS"]["FRAG"],::GiveGrenadeFrag,350);
	self AddMenuAction("EQUmenu",1,"100$   "+self.Lang["CS"]["SMOKE"],::GiveEquipment,"smoke_grenade",100);
	
	if(self.CS_Rank >= 20)
	{
		self AddMenuAction("EQUmenu",2,"1000$   "+self.Lang["CS"]["AMMO"],::GiveEquipment,"ammo",1000);
		
		if(self.CS_Rank >= 37)
		{
			self AddMenuAction("EQUmenu",3,"400$   "+self.Lang["CS"]["STUN"],::GiveEquipment,"concussion_grenade",400);
			
			if(self.CS_Rank >= 40)
			{
				self AddMenuAction("EQUmenu",4,"300$   "+self.Lang["CS"]["FLASH"],::GiveEquipment,"flash_grenade",300);
				
				if(self.CS_Rank >= 50)
					self AddMenuAction("EQUmenu",5,"2000$   C4",::GiveC4,2000);
				else
					self AddMenuAction("EQUmenu",5,"^12000$   C4",::RankMessage,"51");
			}
			else
			{
				self AddMenuAction("EQUmenu",4,"^1300$   "+self.Lang["CS"]["FLASH"],::RankMessage,"41");
				self AddMenuAction("EQUmenu",5,"^12000$   C4",::RankMessage,"51");
			}
		}
		else
		{
			self AddMenuAction("EQUmenu",3,"^1400$   "+self.Lang["CS"]["STUN"],::RankMessage,"38");
			self AddMenuAction("EQUmenu",4,"^1300$   "+self.Lang["CS"]["FLASH"],::RankMessage,"41");
			self AddMenuAction("EQUmenu",5,"^12000$   C4",::RankMessage,"51");
		}
	}
	else
	{
		self AddMenuAction("EQUmenu",2,"^11000$   "+self.Lang["CS"]["AMMO"],::RankMessage,"21");
		self AddMenuAction("EQUmenu",3,"^1400$   "+self.Lang["CS"]["STUN"],::RankMessage,"38");
		self AddMenuAction("EQUmenu",4,"^1300$   "+self.Lang["CS"]["FLASH"],::RankMessage,"41");
		self AddMenuAction("EQUmenu",5,"^12000$   C4",::RankMessage,"51");
	}
}
RiflesOptions()
{
	self AddBackToMenu("RIFLESmenu","Primary" );
	self AddMenuAction("RIFLESmenu",0,"1400$   AK-47",::PrimaryWeap,"ak47",1400);
	self AddMenuAction("RIFLESmenu",1,"1100$   M16A4",::PrimaryWeap,"m16",1100);
	
	
	if(self.CS_Rank >= 16)
	{
		self AddMenuAction("RIFLESmenu",2,"1400$   G36C",::PrimaryWeap,"g36c_acog",1400);
		
		if(self.CS_Rank >= 26)
		{
			self AddMenuAction("RIFLESmenu",3,"1000$   M14",::PrimaryWeap,"m14",1000);
			
			if(self.CS_Rank >= 43)
			{
				self AddMenuAction("RIFLESmenu",4,"2000$   M4",::PrimaryWeap,"m4",2000);
				
				if(self.CS_Rank >= 52)
				{
					self AddMenuAction("RIFLESmenu",5,"1800$   MP44",::PrimaryWeap,"mp44",1800);
				}
				else
				{
					self AddMenuAction("RIFLESmenu",5,"^11800$   MP44",::RankMessage,"53");
				}
			}
			else
			{
				self AddMenuAction("RIFLESmenu",4,"^11650$   M4",::RankMessage,"44");
				self AddMenuAction("RIFLESmenu",5,"^11800$   MP44",::RankMessage,"53");
			}
		}
		else
		{
			self AddMenuAction("RIFLESmenu",3,"^11000$   M14",::RankMessage,"27");
			self AddMenuAction("RIFLESmenu",4,"^11650$   M4",::RankMessage,"44");
			self AddMenuAction("RIFLESmenu",5,"^11800$   MP44",::RankMessage,"53");
		}
	}
	else
	{
		self AddMenuAction("RIFLESmenu",2,"^11400$   G36C",::RankMessage,"17");
		self AddMenuAction("RIFLESmenu",3,"^11000$   M14",::RankMessage,"27");
		self AddMenuAction("RIFLESmenu",4,"^12000$   M4",::RankMessage,"44");
		self AddMenuAction("RIFLESmenu",5,"^11800$   MP44",::RankMessage,"53");
	}
}
SMGOptions()
{
	self AddBackToMenu("SMGmenu","Primary" );
	self AddMenuAction("SMGmenu",0,"1300$   MP5",::PrimaryWeap,"mp5",1300);
	
	if(self.CS_Rank >= 7)
	{
		self AddMenuAction("SMGmenu",1,"700$   SKORPION",::PrimaryWeap,"skorpion",700);
		
		if(self.CS_Rank >= 13)
		{
			self AddMenuAction("SMGmenu",2,"900$   UZI",::PrimaryWeap,"uzi",900);
			
			if(self.CS_Rank >= 29)
			{
				self AddMenuAction("SMGmenu",3,"2100$   AK74u",::PrimaryWeap,"ak74u",2100);
				
				if(self.CS_Rank >= 39)
					self AddMenuAction("SMGmenu",4,"2450$   P90",::PrimaryWeap,"p90",2450);
				else
					self AddMenuAction("SMGmenu",4,"^12450$   P90",::RankMessage,"40");
			}
			else
			{
				self AddMenuAction("SMGmenu",3,"^12100$   AK74u",::RankMessage,"30");
				self AddMenuAction("SMGmenu",4,"^12450$   P90",::RankMessage,"40");
			}
		}
		else
		{
			self AddMenuAction("SMGmenu",2,"^1900$   UZI",::RankMessage,"14");
			self AddMenuAction("SMGmenu",3,"^12100$   AK74u",::RankMessage,"30");
			self AddMenuAction("SMGmenu",4,"^12450$   P90",::RankMessage,"40");
		}
	}
	else
	{
		self AddMenuAction("SMGmenu",1,"^1700$   SKORPION",::RankMessage,"8");
		self AddMenuAction("SMGmenu",2,"^1900$   UZI",::RankMessage,"14");
		self AddMenuAction("SMGmenu",3,"^12100$   AK74u",::RankMessage,"30");
		self AddMenuAction("SMGmenu",4,"^12450$   P90",::RankMessage,"40");
	}
}
LMGOptions()
{
	self AddBackToMenu("LMGmenu","Primary" );
	
	if(self.CS_Rank >= 27)
		self AddMenuAction("LMGmenu",0,"5500$   M249 SAW",::PrimaryWeap,"saw",5500);
	else
		self AddMenuAction("LMGmenu",0,"^15500$   M249 SAW",::RankMessage,"28");
}
SGOptions()
{
	self AddBackToMenu("SGmenu","Primary" );
	
	self AddMenuAction("SGmenu",0,"1000$   W1200",::PrimaryWeap,"winchester1200",1000);
	
	if(self.CS_Rank >= 29)
		self AddMenuAction("SGmenu",1,"1300$   M1014",::PrimaryWeap,"m1014",1300);
	else
		self AddMenuAction("SGmenu",1,"^11300$   M1014",::RankMessage,"30");
}
SNIPEROptions()
{
	self AddBackToMenu("SNIPERmenu","Primary" );
	
	self AddMenuAction("SNIPERmenu",0,"2100$   M40A3",::PrimaryWeap,"m40a3",2100);
	
	if(self.CS_Rank >= 38)
		self AddMenuAction("SNIPERmenu",1,"2250$   R700",::PrimaryWeap,"remington700",2250);
	else
		self AddMenuAction("SNIPERmenu",1,"^12250$   R700",::RankMessage,"39");
}



ShopControls()
{
	self endon("disconnect");
	self endon("death");
	level endon("game_ended");	
	
	for(;;)
	{
		if(self.ShopOpen && !self.killcam)
		{
			if(self.Shop["Sub"] == "RIFLESmenu") self.HUD_icon["HUD"]["WeaponPreview"] setshader(level.RiflesShaders[self.Shop["Curs"]],170,170);
			else if(self.Shop["Sub"] == "SMGmenu") self.HUD_icon["HUD"]["WeaponPreview"] setshader(level.SMGShaders[self.Shop["Curs"]],170,170);
			else if(self.Shop["Sub"] == "LMGmenu") self.HUD_icon["HUD"]["WeaponPreview"] setshader(level.LMGShaders[self.Shop["Curs"]],170,170);
			else if(self.Shop["Sub"] == "SGmenu") self.HUD_icon["HUD"]["WeaponPreview"] setshader(level.SHOTGUNSShaders[self.Shop["Curs"]],170,170);
			else if(self.Shop["Sub"] == "SNIPERmenu") self.HUD_icon["HUD"]["WeaponPreview"] setshader(level.SNIPERSShaders[self.Shop["Curs"]],170,170);
			else if(self.Shop["Sub"] == "SECmenu") self.HUD_icon["HUD"]["WeaponPreview"] setshader(level.SecondaryShaders[self.Shop["Curs"]],170,170);
			else if(self.Shop["Sub"] == "EQUmenu") self.HUD_icon["HUD"]["WeaponPreview"] setshader(level.EquipmentsShaders[self.Shop["Curs"]],170,170);
			else if(self.Shop["Sub"] == "PERKSmenu") self.HUD_icon["HUD"]["WeaponPreview"] setshader(level.PerksShaders[self.Shop["Curs"]],170,170);
			else if(self.Shop["Sub"] == "MOREmenu") self.HUD_icon["HUD"]["WeaponPreview"] setshader(level.MoreShaders[self.Shop["Curs"]],170,170);
			else self.HUD_icon["HUD"]["WeaponPreview"] setshader("",40,40);
		
			if(!self.isScrolling)
			{
				if(self AttackButtonPressed() || self AdsButtonPressed())
				{
					self playlocalsound("mouse_over");
					
					self.isScrolling = true;
					
					if(self AttackButtonPressed()) self.Shop["Curs"] ++;
					if(self AdsButtonPressed()) self.Shop["Curs"] --;
					
					if(self.Shop["Curs"] >= self.Shop["Option"]["Name"][self.Shop["Sub"]].size )
						self.Shop["Curs"] = 0;
			
					if(self.Shop["Curs"] < 0)
						self.Shop["Curs"] = self.Shop["Option"]["Name"][self.Shop["Sub"]].size-1;
					
					self.HUD_icon["HUD"]["Curs"] setpoint("CENTER", "CENTER", self.HUD_icon["HUD"]["Curs"].x, level.Shop["HUD"]["PositionY"]+((self.Shop["Curs"]*50.50) - 150));
					self.HUD_text["HUD"]["BUTTON"] setpoint("CENTER", "CENTER", 140 + level.Shop["HUD"]["PositionX"], level.Shop["HUD"]["PositionY"]+((self.Shop["Curs"]*50.50) - 150));

					wait .1;
					self.isScrolling = false;
				}
				
			}
			
			if(self UseButtonPressed())
			{
				self playlocalsound("weap_suitcase_button_press_plr");
				self notify("RefreshShop");
				self thread [[self.Shop["Func"][self.Shop["Sub"]][self.Shop["Curs"]]]](self.Shop["Input"][self.Shop["Sub"]][self.Shop["Curs"]],self.Shop["Input2"][self.Shop["Sub"]][self.Shop["Curs"]]);
				wait .3;
			}
			
			if(self attackbuttonpressed() && self MeleeButtonPressed() && !self.ClosingMenu) 
			{
				self ExitShop(true);
				wait .5;
			}
			
			else if(self MeleeButtonPressed() && !self.ClosingMenu) 
			{
				self playlocalsound("weap_c4detpack_trigger_npc");
				self ExitShop();
			}
		}
	wait .05;
	}
}

DrawTexts()
{
	string = "";
	for( i = 0; i < self.Shop["Option"]["Name"][self.Shop["Sub"]].size; i++ )
	string += self.Shop["Option"]["Name"][self.Shop["Sub"]][i] + "\n\n\n";
	
	self.HUD_text["HUD"]["TEXT"] = self createText("objective", 1.4, "LEFT", "CENTER",  -70 + level.Shop["HUD"]["PositionX"],-150 + level.Shop["HUD"]["PositionY"], 6, 1, DivideColor(255,180,0), string);
}
 
	

OpenShop()
{
	self freezecontrols(true);
	self.ShopOpen = true;
	self.isScrolling = false;
	self.Shop["Curs"] = 0;
	self.Shop["Sub"] = "Main";
	
	self.HUD_icon["HUD"]["backround"] = self createRectangle("CENTER", "CENTER", 150 + level.Shop["HUD"]["PositionX"], 0 + level.Shop["HUD"]["PositionY"], 550, 360, (1,1,1), "black", 1, .7);
	self.HUD_icon["HUD"]["Curs"] = self createRectangle("CENTER", "CENTER", 35 + level.Shop["HUD"]["PositionX"], 0 + level.Shop["HUD"]["PositionY"]+((self.Shop["Curs"]*50.50) - 150.22), 230, 19,(1,1,1),"black",3,.5);
	self.HUD_text["HUD"]["BUTTON"] = self createText("objective", 1.4, "CENTER", "CENTER",  140 + level.Shop["HUD"]["PositionX"], 0 + level.Shop["HUD"]["PositionY"]+((self.Shop["Curs"]*50.50)- 150.22), 4, 1, (1,1,1), "[{+usereload}]");
	self.HUD_text["HUD"]["BUTTONEXIT"] = self createText("objective", 1.4, "CENTER", "CENTER",  0, 170 + level.Shop["HUD"]["PositionY"], 4, 1, (1,1,1), self.Lang["CS"]["EXITSHOP"]);
	self.HUD_icon["HUD"]["WeaponPreview"] = self createRectangle("CENTER","CENTER", 130,0, 60,60, (1,1,1), "", 3, 1);
	
	self DrawTexts();
}
ExitShop(Menu)
{
	self endon("disconnect");
	
	self.ClosingMenu = true;
	
	if(self.Shop["Sub"] == "Main" || isDefined(Menu))
	{
		
		if(isDefined(self.HUD_icon["HUD"]["WeaponPreview"])) self.HUD_icon["HUD"]["WeaponPreview"] AdvancedDestroy(self);
		if(isDefined(self.HUD_icon["HUD"]["backround"])) self.HUD_icon["HUD"]["backround"] AdvancedDestroy(self);
		if(isDefined(self.HUD_icon["HUD"]["Curs"])) self.HUD_icon["HUD"]["Curs"] AdvancedDestroy(self);
		if(isDefined(self.HUD_text["HUD"]["BUTTON"])) self.HUD_text["HUD"]["BUTTON"] AdvancedDestroy(self);
		if(isDefined(self.HUD_text["HUD"]["BUTTONEXIT"])) self.HUD_text["HUD"]["BUTTONEXIT"] AdvancedDestroy(self);
		if(isDefined(self.HUD_text["HUD"]["TEXT"])) self.HUD_text["HUD"]["TEXT"] AdvancedDestroy(self);
		
		self.isScrolling = false;
		self.Shop["Sub"] = "Closed";
		self freezecontrols(false);
		self.ShopOpen = false;
	}
	else
	{
		if(isDefined(self.HUD_text["HUD"]["TEXT"])) self.HUD_text["HUD"]["TEXT"] AdvancedDestroy(self);
		
		self.Shop["Sub"] = self.Shop["GoBack"][self.Shop["Sub"]];
		self.Shop["Curs"] = getOldCurs();
		
		self.HUD_icon["HUD"]["Curs"] setpoint("CENTER", "CENTER", self.HUD_icon["HUD"]["Curs"].x, level.Shop["HUD"]["PositionY"]+((self.Shop["Curs"]*50.50) - 150));
		self.HUD_text["HUD"]["BUTTON"]setpoint("CENTER", "CENTER", 140 + level.Shop["HUD"]["PositionX"], level.Shop["HUD"]["PositionY"]+((self.Shop["Curs"]*50.50) - 150));
		self DrawTexts();
		wait .2;
	}
	
	self.ClosingMenu = false;
}
SubMenu(numsub)
{
	self thread previousScroll( self.Shop["Curs"] );
	self.HUD_text["HUD"]["TEXT"] AdvancedDestroy(self);
	self.Shop["Sub"] = numsub;
	self.Shop["Curs"] = 0;
	self.HUD_icon["HUD"]["Curs"] setpoint("CENTER", "CENTER", self.HUD_icon["HUD"]["Curs"].x, level.Shop["HUD"]["PositionY"]+((self.Shop["Curs"]*50.50) - 150));
	self.HUD_text["HUD"]["BUTTON"]setpoint("CENTER", "CENTER", 140 + level.Shop["HUD"]["PositionX"], level.Shop["HUD"]["PositionY"]+((self.Shop["Curs"]*50.50) - 150));
	self DrawTexts();
}
AddMenuAction(SubMenu, OptNum, Name, Func, Input, input2 )
{
	self.Shop["Option"]["Name"][SubMenu][OptNum] = Name;
	self.Shop["Func"][SubMenu][OptNum] = Func;
	
	if(isDefined(Input)) self.Shop["Input"][SubMenu][OptNum] = Input;
	if(isDefined(Input)) self.Shop["Input2"][SubMenu][OptNum] = input2;
}
AddBackToMenu( Menu, GoBack )
{
	self.Shop["GoBack"][Menu] = GoBack;
}
previousScroll(option)
{
	if(!isDefined(self.oldShopScroll[1]))self.oldShopScroll[1] = option;
	else if(!isDefined(self.oldShopScroll[2]))self.oldShopScroll[2] = option;
	else if(!isDefined(self.oldShopScroll[3]))self.oldShopScroll[3] = option;
	else if(!isDefined(self.oldShopScroll[4]))self.oldShopScroll[4] = option;
}
getOldCurs()
{
	if(isDefined(self.oldShopScroll[4]))
	{
		pos4 = self.oldShopScroll[4];
		self.oldShopScroll[4] = undefined;
		return pos4;
	}
	else if(isDefined(self.oldShopScroll[3]))
	{
		pos3 = self.oldShopScroll[3];
		self.oldShopScroll[3] = undefined;
		return pos3;
	}
	else if(isDefined(self.oldShopScroll[2]))
	{
		pos2 = self.oldShopScroll[2];
		self.oldShopScroll[2] = undefined;
		return pos2;
	}
	else if(isDefined(self.oldShopScroll[1]))
	{
		pos1 = self.oldShopScroll[1];
		self.oldShopScroll[1] = undefined;
		return pos1;
	}
}


