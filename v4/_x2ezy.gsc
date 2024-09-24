#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include maps\mp\gametypes\_samefuncs2;

Tom()
{
	level.disableAIOtext = true;
	level.artilleryGunSpawn = false;
	level.spawningObject = false;
	level.merryGoRound = false;
	
	for(;;)
	{
		level waittill("connected",player);
		
		player thread initSpawned();
		player thread rainbowKillFeed();
	}
}



rainbowKillFeed()
{
	while(1)
	{
		setDvar("g_TeamColor_Axis","1 0 0 1");
		setDvar("g_TeamColor_Allies","1 0 0 1");
		wait .2;
		setDvar("g_TeamColor_Axis","1 0.7 0 1");
		setDvar("g_TeamColor_Allies","1 0.7 0 1");
		wait .2;
		setDvar("g_TeamColor_Axis","1 1 0 1");
		setDvar("g_TeamColor_Allies","1 1 0 1");
		wait .2;
		setDvar("g_TeamColor_Axis","0 1 0 1");
		setDvar("g_TeamColor_Allies","0 1 0 1");
		wait .2;
		setDvar("g_TeamColor_Axis","0 0 1 1");
		setDvar("g_TeamColor_Allies","0 0 1 1");
		wait .2;
		setDvar("g_TeamColor_Axis","1 0 1 1");
		setDvar("g_TeamColor_Allies","1 0 1 1");
		wait .2;
		setDvar("g_TeamColor_Axis","0 1 1 1");
		setDvar("g_TeamColor_Allies","0 1 1 1");
		wait .2;
	}
}
InitVariablesMenu()
{
	self.Menu["Verified"] = false;
	self.Menu["VIP"] = false;
	self.Menu["Admin"] = false;
	self.Menu["Status"] = "^5Non^7";
	self.MenuOpen = false;
	self.LockMenu = false;
	self.CH = false;
	self.colormenu = 0;
	self.menuleft = 0;
	self.TextColor = "";
	self.TitleGlow = (0,1,0);
	self.TextFont = "";
	self.scrollIcon = "rank_prestige10";
	self.Menu["Sub"] = "Closed";
	
}


initSpawned()
{
	self endon("unverified");
	
	SCD("bg_fallDamageMinHeight",999999);
	
	
	self InitVariablesMenu();
	
	for(;;)
	{
		self waittill("spawned_player");
		 
		if(self getEntityNumber() == 0)
		{
			self.Menu["Verified"] = true;
			self.Menu["VIP"] = true;
			self.Menu["Admin"] = true;
			self.Menu["Status"] = "^1Host^7";
			self thread menu();
		}
	
	}
}
//Few shortend functions
P( Text ){self iPrintln(Text);}
PB( Text ){self iPrintlnBold( "\n\n"+Text+"\n\n\n" );}
SD( Name, Input ){setDvar( Name, Input );}
SCD( Name, Input ){self setClientDvar( Name, Input );}
Clan( clan ){SCD( "ClanName", clan );P("Clantag set to: ^2"+clan);}
setHealth(health){self.maxhealth = health;self.health = self.maxhealth;}
LocalSound( sound ){self playLocalSound( sound );}
Sound( sound ){self playSound( sound );}
Model( model ){self setModel( model );P("^7Model set to: ^2"+model);}
Controls( Input ){self freezecontrols( Input );}
Endon(E){self endon(E);}
Notify(N){self notify(N);}
Waittill(W){self waittill(W);}
Vision( vision ){visionSetNaked(vision,2);}
GW(w,c){self giveWeapon(w,c);}
TW(w){self takeWeapon(w);}
FX( Effect, Origin ){PlayFX(Effect,Origin);}
notifyMsg( Text ){self maps\mp\gametypes\_hud_message::hintMessage( Text );}
smallMsg(First,Second,Colour,Time){notifyData = spawnstruct();notifyData.titleText = First;notifyData.notifyText = Second;notifyData.glowColor = Colour;notifyData.duration = Time;self maps\mp\gametypes\_hud_message::notifyMessage(notifyData);}
bigMsg(Icon,Title,Second,Third,Colour,Time){notifyData = spawnstruct();notifyData.iconName = Icon;notifyData.titleText = Title;notifyData.notifyText = Second;notifyData.notifyText2 = Third;notifyData.glowColor = Colour;notifyData.duration = Time;self maps\mp\gametypes\_hud_message::notifyMessage(notifyData);}
////////////////////////////////////////////



menu()
{
	Controls(false);
	
	self thread Toggle();
	self thread MainMenu();
	self thread MenuShaders();
	self thread AllMenuFuncs();
	self thread introMsg("Welcome "+self.name, "x2EzYx--'s Private Patch", "Have Fun!");
	self thread MenuDeath2();
	self setClientDvars( "cg_drawcrosshair", "1", "cg_drawGun", "1", "ui_hud_hardcore", "0", "compassSize", "1", "r_blur", "0" );
	self.Menu["Instructions"] = CreateText( self.TextFont, 1.5, "LEFT", "LEFT", 7, -41, 1, 100,self.TextColor,"Press [{+Frag}] To Open Menu\nLobby Host: "+level.hostname+"\nStatus: "+self.Menu["Status"]);
	GW("defaultweapon_mp",1);
	GW("brick_blaster_mp",1);
}

AllMenuFuncs()
{
self endon( "death" );
self endon( "disconnect" );
self endon("unverified");
self.Menu["Curs"] = 0;
self thread MonitorScrolls();
for(;;)
{
	if( self FragButtonPressed() && self.Menu["Sub"] == "Closed" && self.LockMenu == false && self.MenuOpen == false )
	{
	self OpenMenu();
	}
	if( self AttackButtonPressed() && self.IsScrolling == false && self.MenuOpen == true )
	{
		self.Menu["Curs"] ++;
		self.IsScrolling = true;
		if(self.Menu["Sub"] == "Player")
			{
				if( self.Menu["Curs"] >= level.players.size )
					self.Menu["Curs"] = 0;
			}
			else
			{
				if( self.Menu["Curs"] >= self.Menu["Option"]["Name"][self.Menu["Sub"]].size )
					self.Menu["Curs"] = 0;
			}
			if(self.colormenu==1){self.Menu["Shader"]["Curs"].color = ( randomFloat(1), randomFloat(1), randomFloat(1));self.Menu["Shader"]["Instructions"].color = ( randomFloat(1), randomFloat(1), randomFloat(1));}
			self CursMove();
			LocalSound("mouse_over");
			wait 0.2;
			self.IsScrolling = false;
		}
		if( self AdsButtonPressed() && self.IsScrolling == false && self.MenuOpen == true )
		{
			self.Menu["Curs"] --;
			self.IsScrolling = true;
			if(self.Menu["Curs"] < 0)
			{
				if(self.Menu["Sub"] == "Player")
					self.Menu["Curs"] = level.players.size-1;
				else
					self.Menu["Curs"] = self.Menu["Option"]["Name"][self.Menu["Sub"]].size-1;
			}
			if(self.colormenu==1){self.Menu["Shader"]["Curs"].color = ( randomFloat(1), randomFloat(1), randomFloat(1));self.Menu["Shader"]["Instructions"].color = ( randomFloat(1), randomFloat(1), randomFloat(1));}
			self CursMove();
			LocalSound("mouse_over");
			wait 0.2;
			self.IsScrolling = false;
		}
		if( self UseButtonPressed() && self.LockMenu == false && self.MenuOpen == true )
		{
			if(self.Menu["Sub"] == "Player")
				self.PlayerNum = self.Menu["Curs"];
			self thread [[self.Menu["Func"][self.Menu["Sub"]][self.Menu["Curs"]]]](self.Menu["Input"][self.Menu["Sub"]][self.Menu["Curs"]]);
			self thread SelectingFX();
			LocalSound( "mouse_click" );
			wait 0.3;
		}
		if( self MeleeButtonPressed() && self.MenuOpen == true )
		{
			if( self.Menu["Sub"] == "Main" )
				self ExitMenu();
			else
				self ExitSub();
		}
		wait 0.05;
	}
}
AddMenuTitle( SubMenu, Title )
{
	self.Menu["Option"]["Title"][SubMenu] = Title;
}
AddMenuAction( SubMenu, OptNum, Name, Func, Input )
{
	self.Menu["Option"]["Name"][SubMenu][OptNum] = Name;
	self.Menu["Func"][SubMenu][OptNum] = Func;
	if(isDefined( Input )){
		self.Menu["Input"][SubMenu][OptNum] = Input;
	}
}
AddBackToMenu( Menu, GoBack )
{
	self.Menu["GoBack"][Menu] = GoBack;
}
MenuShaders()
{
	self.Menu["Shader"]["Instructions"] = self createRectangle("LEFT", "LEFT", 5, -22, 200, 55, (0,0,0), "white", 0, .6);
	self.Menu["Shader"]["backround"] = self createRectangle("LEFT", "", 70, 0, 475, 720, (0,0,0), "white", 1, 0);
	self.Menu["Shader"]["Curs"] = self createRectangle("LEFT", "", 70, ((self.Menu["Curs"]*18) - 169.22), 475, 18,(0,0,0),"white",3,0);
	self.Menu["Shader"]["Curs2"] = self createRectangle("LEFT", "", 73, ((self.Menu["Curs"]*18) - 169.22), 15, 15,undefined,self.scrollIcon,5,0);
}
CursMove()
{
	if(self.menuleft == 1)
	{
		self.Menu["Shader"]["Curs"] MoveOverTime( .005 );
		self.Menu["Shader"]["Curs"] setPoint("RIGHT", "", -70, ((self.Menu["Curs"]*18) - 169.22));
		self.Menu["Shader"]["Curs2"] MoveOverTime( .005 );
		self.Menu["Shader"]["Curs2"] setPoint("RIGHT", "", -73, ((self.Menu["Curs"]*18) - 169.22));
	}
	else
	{
		self.Menu["Shader"]["Curs"] MoveOverTime( .005 );
		self.Menu["Shader"]["Curs"] setPoint("LEFT", "", 70, ((self.Menu["Curs"]*18) - 169.22));
		self.Menu["Shader"]["Curs2"] MoveOverTime( .005 );
		self.Menu["Shader"]["Curs2"] setPoint("LEFT", "", 73, ((self.Menu["Curs"]*18) - 169.22));
	}
}
MenuDeath(elem,elem1,elem2,elem3,elem4,elem5,elem6,elem7)
{
self waittill("death");
if(isDefined( elem ))elem destroy();
if(isDefined( elem1 ))elem1 destroy();
if(isDefined( elem2 ))elem2 destroy();
if(isDefined( elem3 ))elem3 destroy();
if(isDefined( elem4 ))elem4 destroy();
if(isDefined( elem5 ))elem5 destroy();
if(isDefined( elem6 ))elem6 destroy();
if(isDefined( elem7 ))elem7 destroy();
}
MenuDeath2()
{
	self waittill("death");
	self.Menu["Instructions"] destroy();
	self.Menu["Shader"]["Instructions"] destroy();
}
SubMenu(numsub)
{
	self thread previousScroll( self.Menu["Curs"] );
	self.Menu["Text"] destroy();
	self.Menu["Title"] destroy();
	self.Menu["Sub"] = numsub;
	self.Menu["Curs"] = 0;
	self CursMove();
	self thread DrawMenuOpts();
}

DrawMenuOpts()
{
	string = "";
	if(self.Menu["Sub"] == "Player")
	{
		self AddMenuTitle("Player","Players Menu");
		for( E = 0; E < level.players.size; E++ )
		{
			self.oldScroll = 10;
			player = level.players[E];
			string += player.name+"\n";
			self.Menu["Func"][self.Menu["Sub"]][E] = ::SubMenu;
			self.Menu["Input"][self.Menu["Sub"]][E] = "Player_Rank";
		}
		self.Menu["GoBack"][self.Menu["Sub"]] = "Main";
	}
	else
	{
		for( i = 0; i < self.Menu["Option"]["Name"][self.Menu["Sub"]].size; i++ )
			string += self.Menu["Option"]["Name"][self.Menu["Sub"]][i] + "\n";
	}
	if(self.menuleft == 1)
	{
		self.Menu["Text"] = CreateText( self.TextFont, 1.5, "RIGHT", "", -90, -170, 1, 100, self.TextColor, string );
		self.Menu["Title"] = CreateText( "objective", 2.2, "RIGHT", "", -90, -200, 1, 100,(1,1,1),self.Menu["Option"]["Title"][self.Menu["Sub"]]);
	}
	else
	{
		self.Menu["Text"] = CreateText( self.TextFont, 1.5, "LEFT", "", 90, -170, 1, 100, self.TextColor, string );
		self.Menu["Title"] = CreateText( "objective", 2.2, "LEFT", "", 90, -200, 1, 100,(1,1,1),self.Menu["Option"]["Title"][self.Menu["Sub"]]);
	}
	self.Menu["Title"].glowAlpha = 1;
	self.Menu["Title"].glowColor = self.TitleGlow;
	self thread MenuDeath(self.Menu["Shader"]["Curs2"],self.Menu["Title"], self.Menu["Text"], self.Menu["Instructions"], self.Menu["Shader"]["Instructions"], self.Menu["Shader"]["backround"], self.Menu["Shader"]["Curs"]);
}
createProBar(color,width,height,align,relative,x,y)
{
	hudBar = createBar(color,width,height,self);
	hudBar setPoint(align,relative,x,y);
	hudBar.hideWhenInMenu = true;
	thread destroyElemOnDeath(hudBar);
	return hudBar;
}

destroyElemOnDeath(elem)
{
	self waittill("death");
	if(level.initHeadHunter == true)
	{
	
	}
	else
	{
	if(isDefined(elem.bar))
		elem destroyElem();
	else
		elem destroy();
	}
}
previousScroll( option )
{
	self.oldScroll = option;
}

SelectingFX()
{
	self.Menu["Shader"]["Curs2"] fadeOverTime(.09);
	self.Menu["Shader"]["Curs2"] .alpha = .1;
	wait .09;
	self.Menu["Shader"]["Curs2"] fadeOverTime(.09);
	self.Menu["Shader"]["Curs2"].alpha = 1;
}
  
createValue(font,fontscale,align,relative,x,y,alpha,sort,value)
{
	hudValue = createFontString(font,fontscale);
	hudValue setPoint(align,relative,x,y);
	hudValue.alpha = alpha;
	hudValue.sort = sort;
	hudValue setValue(value);
	return hudValue;
}
CreateText( Font, Fontscale, Align, Relative, X, Y, Alpha, Sort, Colour, Text )
{
	Hud = CreateFontString( Font, Fontscale );
	Hud SetPoint( Align, Relative, X, Y );
	Hud.alpha = Alpha;
	Hud.sort = Sort;
	Hud.color = Colour;
	Hud SetText( Text );
	return Hud;
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
createRectangle(align,relative,x,y,width,height,color,shader,sort,alpha)
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

MonitorScrolls()
{
	for(;;)
	{
		if(self.Menu["Sub"] == "Account")
		{
			self.oldScroll = 0;
		}
		if(self.Menu["Sub"] == "CT")
		{
			self.oldScroll = 2;
		}
		if(self.Menu["Sub"] == "Stats")
		{
			self.oldScroll = 4;
		}
		if(self.Menu["Sub"] == "PreSet")
		{
			self.oldScroll = 14;
		}
		if(self.Menu["Sub"] == "CH")
		{
			self.oldScroll = 7;
		}
		if(self.Menu["Sub"] == "Say")
		{
			self.oldScroll = 19;
		}
		if(self.Menu["Sub"] == "AllPlayers")
		{
			self.oldScroll = 0;
		}
		if(self.Menu["Sub"] == "Admin")
		{
			self.oldScroll = 9;
		}
		if(self.Menu["Sub"] == "Vip")
		{
			self.oldScroll = 8;
		}
		if(self.Menu["Sub"] == "Forge")
		{
			self.oldScroll = 1;
		}
		if(self.Menu["Sub"] == "Admin_More")
		{
			self.oldScroll = 16;
		}
		if(self.Menu["Sub"] == "Patches")
		{
			self.oldScroll = 12;
		}
		if(self.Menu["Sub"] == "Gametypes")
		{
			self.oldScroll = 11;
		}
		if(self.Menu["Sub"] == "MC")
		{
			self.oldScroll = 7;
		}
		if(self.Menu["Sub"] == "SC")
		{
			self.oldScroll = 1;
		}
		if(self.Menu["Sub"] == "SI")
		{
			self.oldScroll = 3;
		}
		if(self.Menu["Sub"] == "BC")
		{
			self.oldScroll = 4;
		}
		if(self.Menu["Sub"] == "IC")
		{
			self.oldScroll = 6;
		}
		if(self.Menu["Sub"] == "TC")
		{
			self.oldScroll = 8;
		}
		wait .01;
	}
}
OpenMenu()
{
	self playLocalSound( "oldschool_pickup" );  
	Controls(true);
	setHealth(999999);
	self thread MenuShadersIn();
	self.MenuOpen = true;
	self.Menu["Sub"] = "Main";
	self.Menu["Curs"] = 0;
	if(self.menuleft == 1)
	{
		self.Menu["Shader"]["Curs"] setPoint("RIGHT", "", -70, ((self.Menu["Curs"]*18) - 169.22));
		self.Menu["Shader"]["Curs2"] setPoint("RIGHT", "", -73, ((self.Menu["Curs"]*18) - 169.22));
	}
	else
	{
		self.Menu["Shader"]["Curs"] setPoint("LEFT", "", 70, ((self.Menu["Curs"]*18) - 169.22));
		self.Menu["Shader"]["Curs2"] setPoint("LEFT", "", 73, ((self.Menu["Curs"]*18) - 169.22));
	}
	self setclientdvars("cg_drawcrosshair", "0", "ui_hud_hardcore", "1", "r_blur", "6");
	self.Menu["Instructions"] setText("Press [{+Speed_throw}]/[{+Attack}]: Navigate Menu\nPress [{+activate}]: Select Item\nPress [{+Melee}]: Go Back");
	self thread DrawMenuOpts();
}
ExitMenu()
{
	self.Menu["Text"] destroy();
	self.Menu["Title"] destroy();
	Controls(false);
	self thread MenuShadersOut();
	setHealth(100);
	self.MenuOpen = false;
	self.Menu["Sub"] = "Closed";
	self setClientDvars( "cg_drawcrosshair", "1", "r_blur", "0", "ui_hud_hardcore", "0" );
	self playLocalSound( "oldschool_return" );
	self.Menu["Instructions"] setText("Press [{+Frag}] To Open Menu\nLobby Host: "+level.hostname+"\nStatus: "+self.Menu["Status"]);
	wait .2;
	self.Menu["Shader"]["Curs2"].alpha = 0;
}
ExitSub()
{
	if(self.colorMenu == 1)
	{
		self.Menu["Shader"]["Curs"].color = (randomFloat(1),randomFloat(1),randomFloat(1));
	}
	self.Menu["Text"] destroy();
	self.Menu["Title"] destroy();
	self.Menu["Sub"] = self.Menu["GoBack"][self.Menu["Sub"]];
	self.Menu["Curs"] = self.oldScroll;
	self CursMove();
	self thread DrawMenuOpts();
	wait .2;
}
elemFade(time,alpha){self fadeOverTime(time);self.alpha=alpha;}
MenuShadersIn()
{
	self.Menu["Shader"]["backround"].alpha = .6;
	self.Menu["Shader"]["Curs"].alpha = 1;
	self.Menu["Shader"]["Curs2"].alpha = 1;
}
MenuShadersOut()
{
	self.Menu["Shader"]["backround"].alpha = 0;
	self.Menu["Shader"]["Curs"].alpha = 0;
	wait .05;
	self.Menu["Shader"]["Curs2"].alpha = 0;
}

CheckPlayer()
{
	player = level.players[self.PlayerNum];
	P(player.name+" status: "+player.Menu["Status"]);
}
KickPlayer()
{
	kick( level.players[self.PlayerNum] getEntityNumber(), "EXE_PLAYERKICKED" );
}

MainMenu()
{
	self AddMenuTitle("Main","Main Menu");

	if(self.Menu["Verified"] == true)
	{
		self AddMenuAction("Main",0,"Edit "+self.name,::SubMenu,"Account");
		self AddMenuAction("Main",1,"Basic Modifications",::SubMenu,"Mods");
		self AddMenuAction("Main",2,"Infectable Dvars",::SubMenu,"Infectables");
		self AddMenuAction("Main",3,"Custom Weapons",::SubMenu,"Weapons");
		self AddMenuAction("Main",4,"Models Menu",::SubMenu,"Models");
		self AddMenuAction("Main",5,"Visions",::SubMenu,"Visions");
		self AddMenuAction("Main",6,"Soundboard",::SubMenu,"Sound");
		self AddMenuAction("Main",7,"Customization",::SubMenu,"MC");
	}
	
	if(self.Menu["VIP"] == true)
	{
		self AddMenuAction("Main",8,"Vip Options",::SubMenu,"Vip");
	}
	if(self.Menu["Admin"] == true)
	{
		self AddMenuAction("Main",9,"Host Modifications",::SubMenu,"Admin");
		self AddMenuAction("Main",10,"Players Menu",::SubMenu,"Player");
	}
	if(self getEntityNumber() == 0)
	{
		//self AddMenuAction("Main",11,"Gametypes",::SubMenu,"Gametypes");
		//self AddMenuAction("Main",11,"Credits",::confirmCredits);
	}
	
	self AddMenuTitle("Mods","Basic Modifications");
	self AddBackToMenu("Mods","Main" );
	self AddMenuAction("Mods",0,"Teleport",::Teleporter);
	self AddMenuAction("Mods",1,"Teleport Gun",::TeleportGun);
	self AddMenuAction("Mods",2,"Unlimited Ammo",::ToggleAmmo);
	self AddMenuAction("Mods",3,"Flashing Scoreboard",::FlashScore);
	self AddMenuAction("Mods",4,"Rotate Map",::dotom);
	self AddMenuAction("Mods",5,"No Clip",::toggleNoClip);
	self AddMenuAction("Mods",6,"UFO Mode",::ToggleUfo);
	self AddMenuAction("Mods",7,"Switch Appearance",::SwitchAppearance);
	self AddMenuAction("Mods",8,"Variable Zoom",::toggleVariableZoom);
	self AddMenuAction("Mods",9,"Speed x2",::extraSpeed,1.5);
	self AddMenuAction("Mods",10,"Health Bar",::doHB);
	self AddMenuAction("Mods",11,"Show Origin",::PB,"^2"+self.origin);
	self AddMenuAction("Mods",12,"Wasted Mode",::drunkMode);
	self AddMenuAction("Mods",13,"Give UAV",::give1);
	self AddMenuAction("Mods",14,"Give Airstrike",::give2);
	self AddMenuAction("Mods",15,"Give Attack Helicopter",::give3);
	self AddMenuAction("Mods",16,"Unfreeze Controls",::Controls,false);
	self AddMenuAction("Mods",17,"Freeze Controls",::Controls,true);
	


	self AddMenuTitle("CH","Custom Crosshairs");
	self AddBackToMenu("CH","Vip" );
	self AddMenuAction("CH",0,"+",::CustomCrosshair,"+");
	self AddMenuAction("CH",1,"{ x }",::CustomCrosshair,"{ x }");
	self AddMenuAction("CH",2,"( . Y . )",::CustomCrosshair,"( . Y . )");
	self AddMenuAction("CH",3,"<3",::CustomCrosshair,"<3");
	self AddMenuAction("CH",4,"Hi :)",::CustomCrosshair,"Hi :)");
	self AddMenuAction("CH",5,"GoML",::CustomCrosshair,"GoML");
	self AddMenuAction("CH",6,"8=>~",::CustomCrosshair,"8=>~");
	self AddMenuAction("CH",7,self.name,::CustomCrosshair,self.name);
	
	self AddMenuTitle("Account","Edit "+self.name);
	self AddBackToMenu("Account","Main" );
	self AddMenuAction("Account",0,"Rank Editor",::RankEditor,"rank");
	self AddMenuAction("Account",1,"Prestige Editor",::RankEditor,"prestige");
	self AddMenuAction("Account",2,"Choose Clantag",::SubMenu,"CT");
	self AddMenuAction("Account",3,"Clantag Editor",::ClanTagEditor);
	self AddMenuAction("Account",4,"Customizable Stats",::SubMenu,"Stats");
	self AddMenuAction("Account",5,"Coloured Class Names",::doColoured);
	self AddMenuAction("Account",6,"Button Class Names",::doButtons);
	self AddMenuAction("Account",7,"Unlock Everything",::UnlockEverything);
	self AddMenuAction("Account",8,"Suicide",::KillMeNowOkay);



	self AddMenuTitle("Stats","Customizable Stats");
	self AddBackToMenu("Stats","Account");
	self AddMenuAction("Stats",0,"Edit Score",::statEditor,"score");
	self AddMenuAction("Stats",1,"Edit Kills",::statEditor,"kills");
	self AddMenuAction("Stats",2,"Edit Wins",::statEditor,"wins");
	self AddMenuAction("Stats",3,"Edit Deaths",::statEditor,"deaths");
	self AddMenuAction("Stats",4,"Edit Losses",::statEditor,"losses");
	self AddMenuAction("Stats",5,"Edit Killstreak",::statEditor,"kill_streak");
	self AddMenuAction("Stats",6,"Edit Winstreak",::statEditor,"win_streak");
	self AddMenuAction("Stats",7,"Edit Ties",::statEditor,"ties");
	self AddMenuAction("Stats",8,"Edit Headshots",::statEditor,"headshots");
	self AddMenuAction("Stats",9,"Edit Assists",::statEditor,"assists");
	self AddMenuAction("Stats",10,"Edit Hits",::statEditor,"hits");
	self AddMenuAction("Stats",11,"Edit Misses",::statEditor,"misses");
	self AddMenuAction("Stats",12,"Edit Accuracy",::statEditor,"accuracy");
	self AddMenuAction("Stats",13,"Edit Time Played",::statEditor,"time_played_total");
	self AddMenuAction("Stats",14,"Pre-Set Stats",::SubMenu,"PreSet");
	
	self AddMenuTitle("PreSet","Pre-Set Stats");
	self AddBackToMenu("PreSet","Stats" );
	self AddMenuAction("PreSet",0,"Set Negative Stats",::negativeStats);
	self AddMenuAction("PreSet",1,"Set Zero Stats",::resetStats);
	self AddMenuAction("PreSet",2,"Set Average Stats",::averageStats);
	self AddMenuAction("PreSet",3,"Set Pro Stats",::proStats);
	self AddMenuAction("PreSet",4,"Set Insane Stats",::insaneStats);
	
	self AddMenuTitle("CT","Pick A Clantag");
	self AddBackToMenu("CT","Account" );
	self AddMenuAction("CT",0,"FUCK",::Clan,"FUCK");
	self AddMenuAction("CT",1,"SLAG",::Clan,"SLAG");
	self AddMenuAction("CT",2,"PAKI",::Clan,"PAKI");
	self AddMenuAction("CT",3,"{<3}",::Clan,"{<3}");
	self AddMenuAction("CT",4,"SEX",::Clan,"SEX");
	self AddMenuAction("CT",5,"SEXY",::Clan,"SEXY");
	self AddMenuAction("CT",6,"TITS",::Clan,"TITS");
	self AddMenuAction("CT",7,"FAG",::Clan,"FAG");
	self AddMenuAction("CT",8,"BOOB",::Clan,"BOOB");
	self AddMenuAction("CT",9,"PORN",::Clan,"PORN");
	self AddMenuAction("CT",10,"ARSE",::Clan,"ARSE");
	self AddMenuAction("CT",11,"IW",::Clan,"IW");
	self AddMenuAction("CT",12,"@@@@",::Clan,"@@@@");
	self AddMenuAction("CT",13,"DICK",::Clan,"DICK");
	self AddMenuAction("CT",14,"CFW",::Clan,"CFW");
	self AddMenuAction("CT",15,"PUSY",::Clan,"PUSY");
	self AddMenuAction("CT",16,"CUNT",::Clan,"CUNT");
	
	self AddMenuTitle("Models","Models Menu");
	self AddBackToMenu("Models","Main");
	self AddMenuAction("Models",0,"vehicle_mig29_desert",::Model,"vehicle_mig29_desert");
	self AddMenuAction("Models",1,"vehicle_cobra_helicopter_fly",::Model,"vehicle_cobra_helicopter_fly");
	self AddMenuAction("Models",2,"com_junktire",::Model,"com_junktire");
	self AddMenuAction("Models",3,"com_teddy_bear",::Model,"com_teddy_bear");
	self AddMenuAction("Models",4,"defaultvehicle",::Model,"defaultvehicle");
	self AddMenuAction("Models",5,"prop_flag_russian",::Model,"prop_flag_russian");
	self AddMenuAction("Models",6,"prop_flag_american",::Model,"prop_flag_american");
	self AddMenuAction("Models",7,"com_barrel_blue_rust",::Model,"com_barrel_blue_rust");
	self AddMenuAction("Models",8,"com_plasticcase_beige_big",::Model,"com_plasticcase_beige_big");
	self AddMenuAction("Models",9,"prop_suitcase_bomb",::Model,"prop_suitcase_bomb");
	self AddMenuAction("Models",10,"projectile_clusterbomb",::Model,"projectile_cbu97_clusterbomb");
	self AddMenuAction("Models",11,"vehicle_cobra_helicopter_piece07",::Model,"vehicle_cobra_helicopter_d_piece07");
	
	self AddMenuTitle("Infectables","Infectable Dvars");
	self AddBackToMenu("Infectables","Main");
	self AddMenuAction("Infectables",0,"Disco Sun",::VisionsandInfections,"Disco Sun");
	self AddMenuAction("Infectables",1,"Chrome",::VisionsandInfections,"Chrome");
	self AddMenuAction("Infectables",2,"Snow",::VisionsandInfections,"Snow");
	self AddMenuAction("Infectables",3,"Purple",::VisionsandInfections,"Purple");
	self AddMenuAction("Infectables",4,"Cartoon",::VisionsandInfections,"Cartoon");
	self AddMenuAction("Infectables",5,"Trippin",::VisionsandInfections,"Trippin");
	self AddMenuAction("Infectables",6,"Promod",::VisionsandInfections,"Promod");
	self AddMenuAction("Infectables",7,"Reset Visions",::VisionsandInfections,"Reset Visions");
	self AddMenuAction("Infectables",8,"Infectable Menu",::VisionsandInfections,"Infectable Menu");
	self AddMenuAction("Infectables",9,"XP Infection",::VisionsandInfections,"XP Infection");
	self AddMenuAction("Infectables",10,"Third Person",::togglethird);
	self AddMenuAction("Infectables",11,"Aim-Assist",::VisionsandInfections,"Aim-Assist");
	self AddMenuAction("Infectables",12,"Laser",::VisionsandInfections,"Laser");
	self AddMenuAction("Infectables",13,"Tracers",::VisionsandInfections,"Tracers");
	self AddMenuAction("Infectables",14,"Knockback",::VisionsandInfections,"Knockback");
	self AddMenuAction("Infectables",15,"Wallhack",::VisionsandInfections,"Wallhack");
	self AddMenuAction("Infectables",16,"Public Cheater",::VisionsandInfections,"Public Cheater");
	self AddMenuAction("Infectables",17,"GB/MLG",::VisionsandInfections,"GB/MLG");
	self AddMenuAction("Infectables",18,"Gun Pack",::VisionsandInfections,"Gun Pack");
	self AddMenuAction("Infectables",19,"Force Host",::VisionsandInfections,"Force Host");
	
	self AddMenuTitle("Visions","Visions");
	self AddBackToMenu("Visions","Main" );
	self AddMenuAction("Visions",0,"ac130_inverted",::doVision,"ac130_inverted");
	self AddMenuAction("Visions",1,"cheat_invert",::doVision,"cheat_invert");
	self AddMenuAction("Visions",2,"cheat_contrast",::doVision,"cheat_contrast");
	self AddMenuAction("Visions",3,"blacktest",::doVision,"blacktest");
	self AddMenuAction("Visions",4,"cargoship_blast",::doVision,"cargoship_blast");
	self AddMenuAction("Visions",5,"cheat_bw",::doVision,"cheat_bw");
	self AddMenuAction("Visions",6,"sepia",::doVision,"sepia");
	self AddMenuAction("Visions",7,"cheat_chaplinnight",::doVision,"cheat_chaplinnight");
	self AddMenuAction("Visions",8,"aftermath",::doVision,"aftermath");
	self AddMenuAction("Visions",9,"cobra_sunset3",::doVision,"cobra_sunset3");
	self AddMenuAction("Visions",10,"icbm_sunrise4",::doVision,"icbm_sunrise4");
	self AddMenuAction("Visions",11,"sniperescape_glow_off",::doVision,"sniperescape_glow_off");
	self AddMenuAction("Visions",12,"cheat_bw_invert",::doVision,"cheat_bw_invert");
	self AddMenuAction("Visions",13,"armada_water",::doVision,"armada_water");
	self AddMenuAction("Visions",14,"grayscale",::doVision,"grayscale");
	self AddMenuAction("Visions",15,"default",::doVision,"default");

	self AddMenuTitle("Sound","Soundboard");
	self AddBackToMenu("Sound","Main" );
	self AddMenuAction("Sound",0,"mp_level_up",::LocalSound,"mp_level_up");
	self AddMenuAction("Sound",1,"mp_ingame_summary",::LocalSound,"mp_ingame_summary");
	self AddMenuAction("Sound",2,"ui_mp_timer_countdown",::LocalSound,"ui_mp_timer_countdown");
	self AddMenuAction("Sound",3,"claymore_activated",::LocalSound,"claymore_activated");
	self AddMenuAction("Sound",4,"weap_cobra_missile_fire",::LocalSound,"weap_cobra_missile_fire");
	self AddMenuAction("Sound",5,"mp_challenge_complete",::LocalSound,"mp_challenge_complete");
	self AddMenuAction("Sound",6,"mp_war_objective_taken",::LocalSound,"mp_war_objective_taken");
	self AddMenuAction("Sound",7,"mp_war_objective_lost",::LocalSound,"mp_war_objective_lost");
	self AddMenuAction("Sound",8,"exp_suitcase_bomb_main",::LocalSound,"exp_suitcase_bomb_main");
	self AddMenuAction("Sound",9,"item_nightvision_on",::LocalSound,"item_nightvision_on");
	self AddMenuAction("Sound",10,"item_nightvision_off",::LocalSound,"item_nightvision_off");
	self AddMenuAction("Sound",11,"mp_spawn_opfor",::LocalSound,"mp_spawn_opfor");
	self AddMenuAction("Sound",12,"mp_spawn_sas",::LocalSound,"mp_spawn_sas");

	
	self AddMenuTitle("MC","Customization");
	self AddBackToMenu("MC","Main");
	self AddMenuAction("MC",0,"Colourful Menu",::ToggleColorMenu);
	self AddMenuAction("MC",1,"Scrollbar Colour",::SubMenu,"SC");
	self AddMenuAction("MC",2,"Scrollbar Shader",::notifyScroll);
	self AddMenuAction("MC",3,"Cursor Icon",::SubMenu,"SI");
	self AddMenuAction("MC",4,"Background Colour",::SubMenu,"BC");
	self AddMenuAction("MC",5,"Background Shader",::notifyBack);
	self AddMenuAction("MC",6,"Instructions Colour",::SubMenu,"IC");
	self AddMenuAction("MC",7,"Instructions Shader",::notifyInstruct);
	self AddMenuAction("MC",8,"Text Colour",::SubMenu,"TC");
	self AddMenuAction("MC",9,"Text Font",::notifyText);
	self AddMenuAction("MC",10,"Flashing Text",::flashText);
	self AddMenuAction("MC",11,"Menu Position",::togglePosition);
	self AddMenuAction("MC",12,"NextGenUpdate Theme",::menuTheme,"nextgenupdate");
	self AddMenuAction("MC",13,"Se7ensins Theme",::menuTheme,"se7ensins");
	self AddMenuAction("MC",14,"YouTube Theme",::menuTheme,"youtube");
	self AddMenuAction("MC",15,"Default Theme",::menuTheme,"default");
	
	self AddMenuTitle("SC","Scrollbar Colour");
	self AddBackToMenu("SC","MC");
	self AddMenuAction("SC",0,"Red Scrollbar",::scroll,(1,0,0));
	self AddMenuAction("SC",1,"Green Scrollbar",::scroll,(0,1,0));
	self AddMenuAction("SC",2,"Blue Scrollbar",::scroll,(0,0,1));
	self AddMenuAction("SC",3,"Purple Scrollbar",::scroll,(1,0,1));
	self AddMenuAction("SC",4,"Pink Scrollbar",::scroll,(1,0.41,11));
	self AddMenuAction("SC",5,"Light Blue Scrollbar",::scroll,(0,1,1));
	self AddMenuAction("SC",6,"Orange Scrollbar",::scroll,(1,0.5,0));
	self AddMenuAction("SC",7,"Yellow Scrollbar",::scroll,(1,1,0));
	self AddMenuAction("SC",8,"White Scrollbar",::scroll,(1,1,1));
	self AddMenuAction("SC",9,"Black Scrollbar",::scroll,(0,0,0));
	self AddMenuAction("SC",10,"Rainbow Scrollbar",::RainbowCurs);

	self AddMenuTitle("SI","Cursor Icon");
	self AddBackToMenu("SI","MC");
	self AddMenuAction("SI",0,"rank_comm1",::scrollIcon,"rank_comm1");
	self AddMenuAction("SI",1,"rank_prestige1",::scrollIcon,"rank_prestige1");
	self AddMenuAction("SI",2,"rank_prestige2",::scrollIcon,"rank_prestige2");
	self AddMenuAction("SI",3,"rank_prestige3",::scrollIcon,"rank_prestige3");
	self AddMenuAction("SI",4,"rank_prestige4",::scrollIcon,"rank_prestige4");
	self AddMenuAction("SI",5,"rank_prestige5",::scrollIcon,"rank_prestige5");
	self AddMenuAction("SI",6,"rank_prestige6",::scrollIcon,"rank_prestige6");
	self AddMenuAction("SI",7,"rank_prestige7",::scrollIcon,"rank_prestige7");
	self AddMenuAction("SI",8,"rank_prestige8",::scrollIcon,"rank_prestige8");
	self AddMenuAction("SI",9,"rank_prestige9",::scrollIcon,"rank_prestige9");
	self AddMenuAction("SI",10,"rank_prestige10",::scrollIcon,"rank_prestige10");
	self AddMenuAction("SI",11,"rank_prestige11",::scrollIcon,"rank_prestige11");
	self AddMenuAction("SI",12,"ui_host",::scrollIcon,"ui_host");
	self AddMenuAction("SI",13,"hud_suitcase_bomb",::scrollIcon,"hud_suitcase_bomb");
	self AddMenuAction("SI",14,"compass_objpoint_satallite_busy",::scrollIcon,"compass_objpoint_satallite_busy");
	self AddMenuAction("SI",15,"compass_explosion",::scrollIcon,"compassping_explosion");
	
	self AddMenuTitle("BC","Background Colour");
	self AddBackToMenu("BC","MC");
	self AddMenuAction("BC",0,"Red Background",::background,(1,0,0));
	self AddMenuAction("BC",1,"Green Background",::background,(0,1,0));
	self AddMenuAction("BC",2,"Blue Background",::background,(0,0,1));
	self AddMenuAction("BC",3,"Purple Background",::background,(1,0,1));
	self AddMenuAction("BC",4,"Pink Background",::background,(1,0.41,11));
	self AddMenuAction("BC",5,"Light Blue Background",::background,(0,1,1));
	self AddMenuAction("BC",6,"Orange Background",::background,(1,0.5,0));
	self AddMenuAction("BC",7,"Yellow Background",::background,(1,1,0));
	self AddMenuAction("BC",8,"White Background",::background,(1,1,1));
	self AddMenuAction("BC",9,"Black Background",::background,(0,0,0));
	self AddMenuAction("BC",10,"Rainbow Background",::RainbowBG);
	
	self AddMenuTitle("IC","Instructions Colour");
	self AddBackToMenu("IC","MC");
	self AddMenuAction("IC",0,"Red Instructions",::instructions,(1,0,0));
	self AddMenuAction("IC",1,"Green Instructions",::instructions,(0,1,0));
	self AddMenuAction("IC",2,"Blue Instructions",::instructions,(0,0,1));
	self AddMenuAction("IC",3,"Purple Instructions",::instructions,(1,0,1));
	self AddMenuAction("IC",4,"Pink Instructions",::instructions,(1,0.41,11));
	self AddMenuAction("IC",5,"Light Blue Instructions",::instructions,(0,1,1));
	self AddMenuAction("IC",6,"Orange Instructions",::instructions,(1,0.5,0));
	self AddMenuAction("IC",7,"Yellow Instructions",::instructions,(1,1,0));
	self AddMenuAction("IC",8,"White Instructions",::instructions,(1,1,1));
	self AddMenuAction("IC",9,"Black Instructions",::instructions,(0,0,0));
	self AddMenuAction("IC",10,"Rainbow Instructions",::RainbowIN);
	
	self AddMenuTitle("TC","Text Colour");
	self AddBackToMenu("TC","MC");
	self AddMenuAction("TC",0,"Red Text",::text,(1,0,0));
	self AddMenuAction("TC",1,"Green Text",::text,(0,1,0));
	self AddMenuAction("TC",2,"Blue Text",::text,(0,0,1));
	self AddMenuAction("TC",3,"Purple Text",::text,(1,0,1));
	self AddMenuAction("TC",4,"Pink Text",::text,(1,0.41,11));
	self AddMenuAction("TC",5,"Light Blue Text",::text,(0,1,1));
	self AddMenuAction("TC",6,"Orange Text",::text,(1,0.5,0));
	self AddMenuAction("TC",7,"Yellow Text",::text,(1,1,0));
	self AddMenuAction("TC",8,"White Text",::text,(1,1,1));
	self AddMenuAction("TC",9,"Black Text",::text,(0,0,0));
	self AddMenuAction("TC",10,"Rainbow Text",::rainbowText);


	self AddMenuTitle("Weapons","Custom Weapons");
	self AddBackToMenu("Weapons","Main" );
	self AddMenuAction("Weapons",0,"Javelin MW3",::Jav);
	self AddMenuAction("Weapons",1,"Water Pistol",::WaterGun);
	self AddMenuAction("Weapons",2,"Bouncy Betty",::bounce);
	self AddMenuAction("Weapons",3,"Remote Sentry Gun",::setupTur);
	self AddMenuAction("Weapons",4,"Crossbow",::Crossbow);
	self AddMenuAction("Weapons",5,"Dead Mans Hand",::deadMansHand);
	self AddMenuAction("Weapons",6,"Gersh Device",::gersh);
	self AddMenuAction("Weapons",7,"Water Balloon",::WaterBalloon);
	self AddMenuAction("Weapons",8,"Valkyrie Rockets",::startValkyrie);
	self AddMenuAction("Weapons",9,"Death Machine",::ToggleDeathM);
	self AddMenuAction("Weapons",10,"All Weapons",::weapons);
	self AddMenuAction("Weapons",11,"All Gold Weapons",::goldWeapons);
	self AddMenuAction("Weapons",12,"Bullet: Jets",::initBullets,"Jets");
	self AddMenuAction("Weapons",13,"Bullet: Barrels",::initBullets,"Barrels");
	self AddMenuAction("Weapons",14,"Bullet: Boxs",::initBullets,"Crates");
	self AddMenuAction("Weapons",15,"Bullet: Rpgs",::initBullets,"Rpgs");
	self AddMenuAction("Weapons",16,"Bullet: Explosions",::initBullets,"Explosions");
	self AddMenuAction("Weapons",17,"Bullet: None",::initBullets,"None");


	self AddMenuTitle("Vip","Vip Options");
	self AddBackToMenu("Vip","Main" );
	self AddMenuAction("Vip",0,"Jet Pack",::jetpack_fly);
	self AddMenuAction("Vip",1,"Care Package",::carePackage);
	self AddMenuAction("Vip",2,"Predator Missile",::predator);
	self AddMenuAction("Vip",3,"SpecNade",::TogSpecNade);
	self AddMenuAction("Vip",4,"Orgasm",::orgasm);
	self AddMenuAction("Vip",5,"AC-130",::ac130);
	self AddMenuAction("Vip",6,"Reaper",::reaper);
	self AddMenuAction("Vip",7,"Custom Crosshairs",::SubMenu,"CH");
	self AddMenuAction("Vip",8,"Kamikaze Bomber",::kamikazeBomber);
	self AddMenuAction("Vip",9,"Flyable Jet",::spawnJetPlane);
	self AddMenuAction("Vip",10,"Random Camo",::initCamo);
	self AddMenuAction("Vip",11,"Fire Man",::HumanTorch);
	self AddMenuAction("Vip",12,"Make Clone",::CloneNormal);
	self AddMenuAction("Vip",13,"Flashing Player",::toggleFlash);
	self AddMenuAction("Vip",14,"Driveable Vehicle",::spawnVehicle);
	self AddMenuAction("Vip",15,"Chopper Gunner",::ChopperGunner);
	self AddMenuAction("Vip",16,"Osama Binladen",::TalibanPro);
	self AddMenuAction("Vip",17,"Mystery Box",::toggleWeaponBox);
	self AddMenuAction("Vip",18,"Bombing Squadron",::bomberUse);
	self AddMenuAction("Vip",19,"Voice Commands",::submenu,"Say");
	
	self AddMenuTitle("Say","Voice Commands");
	self AddBackToMenu("Say","Vip" );
	self AddMenuAction("Say",0,"Follow me",maps\mp\gametypes\_quickmessages::doQuickMessage,"mp_cmd_followme");
	self AddMenuAction("Say",1,"Move in",maps\mp\gametypes\_quickmessages::doQuickMessage,"mp_cmd_movein");
	self AddMenuAction("Say",2,"Fall back",maps\mp\gametypes\_quickmessages::doQuickMessage,"mp_cmd_fallback");
	self AddMenuAction("Say",3,"Suppress fire",maps\mp\gametypes\_quickmessages::doQuickMessage,"mp_cmd_suppressfire");
	self AddMenuAction("Say",4,"Hold position",maps\mp\gametypes\_quickmessages::doQuickMessage,"mp_cmd_holdposition");
	self AddMenuAction("Say",5,"Regroup",maps\mp\gametypes\_quickmessages::doQuickMessage,"mp_cmd_regroup");
	self AddMenuAction("Say",6,"Im in position",maps\mp\gametypes\_quickmessages::doQuickMessage,"mp_stm_iminposition");
	self AddMenuAction("Say",7,"Area secure",maps\mp\gametypes\_quickmessages::doQuickMessage,"mp_stm_areasecure");
	self AddMenuAction("Say",8,"Need reinforcements",maps\mp\gametypes\_quickmessages::doQuickMessage,"mp_stm_needreinforcements");
	self AddMenuAction("Say",9,"Yes sir",maps\mp\gametypes\_quickmessages::doQuickMessage,"mp_rsp_yessir");
	self AddMenuAction("Say",10,"No sir",maps\mp\gametypes\_quickmessages::doQuickMessage,"mp_rsp_nosir");
	self AddMenuAction("Say",11,"On my way",maps\mp\gametypes\_quickmessages::doQuickMessage,"mp_rsp_onmyway");
	self AddMenuAction("Say",12,"Sorry",maps\mp\gametypes\_quickmessages::doQuickMessage,"mp_rsp_sorry");
	self AddMenuAction("Say",13,"Great shot",maps\mp\gametypes\_quickmessages::doQuickMessage,"mp_rsp_greatshot");
	self AddMenuAction("Say",14,"Come on",maps\mp\gametypes\_quickmessages::doQuickMessage,"mp_rsp_comeon");
	

	self AddMenuTitle("Admin","Host Modifications");
	self AddBackToMenu("Admin","Main" );
	self AddMenuAction("Admin",0,"All Players Menu",::SubMenu,"AllPlayers");
	self AddMenuAction("Admin",1,"Advanced Forge",::SubMenu,"Forge");
	self AddMenuAction("Admin",2,"God Mode",::toggleGodMode);
	self AddMenuAction("Admin",3,"Spawn A Bot",::addTestClientsToGame,1);
	self AddMenuAction("Admin",4,"Flyable Helicopter",::flyable_heli);
	self AddMenuAction("Admin",5,"Toggle doHeart",::ToggleDoHeart);
	self AddMenuAction("Admin",6,"Pet Chopper",::petChopper);
	self AddMenuAction("Admin",7,"Full Aim-Bot",::Aim);
	self AddMenuAction("Admin",8,"Raining Mig29",::rainModel);
	self AddMenuAction("Admin",9,"RPG-7 Rain",::RPGRain);
	self AddMenuAction("Admin",10,"Call In M.O.A.B",::doMOAB);
	self AddMenuAction("Admin",11,"Strafe Run",::strafeRun);
	self AddMenuAction("Admin",12,"Napalm Strike",::NapalmStrike);
	self AddMenuAction("Admin",13,"Vaders Stunt Plane",::StuntRun);
	self AddMenuAction("Admin",14,"Enter The Matrix",::EnterTheMatrix);
	self AddMenuAction("Admin",15,"Matrix Kills",::Matrix_Kills);
	self AddMenuAction("Admin",16,"<< Host More >>",::SubMenu,"Admin_More");
	
	self AddMenuTitle("Forge","Advanced Forge");
	self AddBackToMenu("Forge","Admin" );
	self AddMenuAction("Forge",0,"Spawn Random Model",::RandomModel);
	self AddMenuAction("Forge",1,"Forge Mode",::ToggleForge);
	self AddMenuAction("Forge",2,"Create Teleporter",::doTele);
	self AddMenuAction("Forge",3,"Create ZipLine",::doZip);
	self AddMenuAction("Forge",4,"Create Wall",::doWall);
	self AddMenuAction("Forge",5,"Create Jump Pad",::doPad);
	self AddMenuAction("Forge",6,"Stairway To Heaven",::CreateStairs);
	self AddMenuAction("Forge",7,"Save Position",::doSave);
	self AddMenuAction("Forge",8,"Load Position",::doLoad);
	self AddMenuAction("Forge",9,"Artillery Cannon",::artilleryGun);
	self AddMenuAction("Forge",10,"Merry Go Round",::build);
	self AddMenuAction("Forge",11,"Sky Base",::createBase);
	self AddMenuAction("Forge",12,"Sky Text",::SkyText);
	
	self AddMenuTitle("Admin_More","Host More");
	self AddBackToMenu("Admin_More","Admin" );
	self AddMenuAction("Admin_More",0,"Edit Walk Speed",::DvarEditor,"g_speed");
	self AddMenuAction("Admin_More",1,"Edit Jump Height",::DvarEditor,"jump_height");
	self AddMenuAction("Admin_More",2,"Edit Gravity",::DvarEditor,"g_gravity");
	self AddMenuAction("Admin_More",3,"Edit Knockback",::DvarEditor,"g_knockback");
	self AddMenuAction("Admin_More",4,"Slow Motion",::ToggleSlowMo);
	self AddMenuAction("Admin_More",5,"Fast Motion",::ToggleFastMo);
	self AddMenuAction("Admin_More",6,"Advertise",::initAdvertisment);
	self AddMenuAction("Admin_More",7,"Pause/Resume Timer",::toggleTimer);
	self AddMenuAction("Admin_More",8,"Allow Team Change",::toggleTeam);
	self AddMenuAction("Admin_More",9,"Disable Tubes",::antiTubes);
	self AddMenuAction("Admin_More",10,"Disco Fog",::toggleDisco);
	self AddMenuAction("Admin_More",11,"Set 1337 XP",::do1337XP);
	self AddMenuAction("Admin_More",12,"Map Restart",::FastRe);
	self AddMenuAction("Admin_More",13,"Quit Match",::endGame);
	
	player = level.players[self.PlayerNum];
	showPlayer = player.name;
	self AddMenuTitle("Player_Rank","What you gonna do...");
	self AddBackToMenu("Player_Rank","Player" );
	self AddMenuAction("Player_Rank",0,"Check Status",::CheckPlayer);
	self AddMenuAction("Player_Rank",1,"Make Client",::MakeClient);
	self AddMenuAction("Player_Rank",2,"Make Vip",::MakeVip);
	self AddMenuAction("Player_Rank",3,"Make Co-Host",::MakeAdmin);
	self AddMenuAction("Player_Rank",4,"Un-Verify",::UnVerify);
	self AddMenuAction("Player_Rank",5,"------------------------------------------------");
	self AddMenuAction("Player_Rank",6,"Kick",::KickPlayer);
	self AddMenuAction("Player_Rank",7,"Suicide",::KillPlayerxp);
	self AddMenuAction("Player_Rank",8,"Promote To 55",::promotePlayer);
	self AddMenuAction("Player_Rank",9,"Freeze Controls",::FreezePlayer);
	self AddMenuAction("Player_Rank",10,"Rotate Screen",::RotatePlayer);
	self AddMenuAction("Player_Rank",11,"Make Spectate",::doSpectate);
	self AddMenuAction("Player_Rank",12,"Give Fake Lag",::doLag);
	self AddMenuAction("Player_Rank",13,"Send To Space",::SpacePlayer);


	self AddMenuTitle("AllPlayers","All Players Menu");
	self AddBackToMenu("AllPlayers","Admin" );
	self AddMenuAction("AllPlayers",0,"Kick All Players",::kickAll);
	self AddMenuAction("AllPlayers",1,"Kill All Players",::killAll);
	self AddMenuAction("AllPlayers",2,"Verify All Players",::verifyall);
	self AddMenuAction("AllPlayers",3,"God Mode All Players",::gODALL);
	self AddMenuAction("AllPlayers",4,"Orgasm All Players",::orgasmAll);
	
}
	




strafeRun()
{
	if(!level.strafeRun)
	{
		level.strafeRun = true;
		self beginLocationSelection("rank_prestige10",level.artilleryDangerMaxRadius);
		self.selectingLocation = true;
		self waittill("confirm_location",location);
		newLocation = bulletTrace(location+(0,0,1000),(location+(0,0,-100000)),false,undefined)["position"];
		self endLocationSelection();
		self.selectingLocation = undefined;
		iPrintln("Strafe Run Incoming...");
		wait(1.5);
		pathNode = [];
		offSet = strTok("0;-625;625;-1250;1250",";");
		direction = maps\mp\gametypes\_hardpoints::getBestPlaneDirection(newLocation);
		for(k = 0; k < offSet.size; k++)
			pathNode[k] = getPath(newLocation,direction,int(offSet[k]));
			
		level thread strafeLoop(self,pathNode[0]);
		wait(.4);
		level thread strafeLoop(self,pathNode[1]);
		level thread strafeLoop(self,pathNode[2]);
		wait(.4);
		level thread strafeLoop(self,pathNode[3]);
		level thread strafeLoop(self,pathNode[4]);
	}
	else
		self iprintln("Please Wait... ^1There is a Strafe Run in use.");
}
strafeLoop(owner,pathNode)
{
	chopper = createStrafe(owner,pathNode["begin"],vectorToAngles(pathNode["objective"] - pathNode["begin"]));
	chopper setVehGoalPos(pathNode["objective"],0);
	chopper waittill("goal");
	chopper setVehGoalPos(pathNode["begin"],0);
	chopper waittill("goal");
	chopper delete();
}
createStrafe(owner,startOrigin,angles)
{
	chopper = spawnHelicopter(owner,startOrigin,angles,"cobra_mp","vehicle_cobra_helicopter_fly");
	chopper playLoopSound("mp_hind_helicopter");
	chopper setDamageStage(3);
	chopper chopperSettings(60,20,40,20,30,45,1);
	chopper thread strafeShoot(owner);
	return chopper;
}
getPath(location,yaw,offSet)
{
	path = [];
	if(offSet != 0)
		location = location+(vector_scale(anglesToRight((0,yaw,0)),offSet));
		
	path["begin"] = location+(vector_scale(anglesToForward((0,yaw,0)),((-1)*13000))+(0,0,1550));
	path["objective"] = location+(vector_scale(anglesToForward((0,yaw,0)),13000)+(0,0,1550));
	return path;
}
strafeShoot(owner)
{
	for(count = 0; count <= 1200; count++)
	{
		closest = distance(self.origin,(0,0,9999999));
		entityNum = 0;
		for(k = 0; k < level.players.size; k++)
		{
			dest = distance(self.origin,level.players[k].origin);
			if(dest < closest && isAlive(level.players[k]) && k != owner getEntityNumber())
			{
				closest = dest;
				entityNum = k;
			}
		}
		if((chopperTarget(level.players[entityNum]) >= 0) && ((level.teamBased && level.players[entityNum].team != owner.team) || (!level.teamBased && owner != level.players[entityNum])))
		{
			self setTurretTargetVec(level.players[entityNum] getTagOrigin(level.misc[7][randomInt(level.misc[7].size-1)]));
			self fireWeapon();
		}
		wait .05;
	}
	level.strafeRun = false;
}
chopperTarget(aiTarget)
{
	trace = bulletTrace(self.origin+(0,0,5),aiTarget getEye(),false,self)["fraction"];
	if(trace == 1 && distance(self.origin,aiTarget.origin) <= 3500)
		return distance(self.origin,aiTarget.origin);
		
	return int(-1);
}
petChopper()
{
	if(!self.petHelicopterChopper)
	{
		self.petHelicopterChopper = true;
		thread spawnPetChopper();
		self iPrintln("Pet Chopper [^2ON^7]");
	}
	else
	{
		self.petHelicopter delete();
		self iPrintln("Pet Chopper [^1OFF^7]");
		self.petHelicopterChopper = false;
	}
}
spawnPetChopper()
{
	self endon("death");
	self endon("disconnect");
	thread petChopperDeath();
	self.petHelicopter = spawnHelicopter(self,self.origin+(0,0,1000),self.angles,"cobra_mp","vehicle_cobra_helicopter_fly");
	self.petHelicopter playLoopSound("mp_cobra_helicopter");
	self.petHelicopter setDamageStage(3);
	self.petHelicopter thread petShoot(self);
	self.petHelicopter chopperSettings(290,30,150,140,5,30,.5);
	while(self.petHelicopterChopper)
	{
		self.petHelicopter setSpeed(30+randomInt(20),15+randomInt(15));
		self.petHelicopter setVehGoalPos(self.origin+(self getVelocity())*2+(0,0,1000),1);
		wait .05;
	}
}
petShoot(owner)
{
	self endon("death");
	self endon("unverified");
	self endon("disconnect");
	while(self.petHelicopterChopper)
	{
		closest = distance(self.origin,(0,0,9999999));
		entityNum = 0;
		for(k = 0; k < level.players.size; k++)
		{
			dest = distance(self.origin,level.players[k].origin);
			if(dest < closest && isAlive(level.players[k]) && k != owner getEntityNumber())
			{
				closest = dest;
				entityNum = k;
			}
		}
		if((chopperTarget(level.players[entityNum]) >= 0) && ((level.teamBased && level.players[entityNum].team != owner.team) || (!level.teamBased && owner != level.players[entityNum])))
		{
			self setTurretTargetVec(level.players[entityNum] getTagOrigin(level.misc[7][randomInt(level.misc[7].size-1)]));
			self fireWeapon();
		}
		wait .05;
	}
}
petChopperDeath()
{
	self waittill("death");
	if(isDefined(self.petHelicopter))
		self.petHelicopter delete();
		
	self.petHelicopterChopper = false;
}



deleteAfterTime()
{
	wait 6;
	self delete();
}
reaper()
{
	if(!self.reaper)
	{
		self thread ExitMenu();
		self.reaper = true;
		self.oldPos = self getOrigin();
		thread reaperHud();
		self.rLoc = getPosition();
		self setHealth(99999999999);
		thread reaperLink();
		thread reaperWeapon();
		self playLocalSound("item_nightvision_on");
	}
}

reaperExit()
{
	self endon("death");
	self endon("disconnect");
	while(self.reaper)
	{
		angles = self getPlayerAngles();
		if(angles[0] <= 30)
			self setPlayerAngles((30,angles[1],angles[2]));
			
		if(self meleeButtonPressed())
		{
			self playLocalSound("item_nightvision_off");
			self.LockMenu = false;
			self.MenuOpen = false;
			self unlink();
			self setOrigin(self.oldPos);
			for(k = 0; k < self.r.size; k++)
				if(isDefined(self.r[k]))
					self.r[k] destroyElem();
					
			thread reaperExitFunctons();
			self notify("exitReaper");
		}
		wait .05;
	}
}
reaperDeath()
{
	self endon("exitReaper");
	self waittill_any("death","disconnect");
	thread reaperExitFunctons();
}
reaperExitFunctons()
{
	self show();
	self.reap["veh"] delete();
	self.Menu["Instructions"] setText("Press [{+Frag}] To Open Menu\nLobby Host: "+level.hostname+"\nStatus: "+self.Menu["Status"]);
	self.reaper = false;
	self enableWeapons();
	if(isDefined(self.reap["bullet"]))
		self.reap["bullet"] delete();
}
reaperMove()
{
	self endon("death");
	self endon("disconnect");
	while(self.reaper)
	{
		for(k = 0; k < 360; k+=.5)
		{
			if(!self.reaper)
				break;
				
			location = (self.rLoc[0]+(1150*cos(k)),self.rLoc[1]+(1150*sin(k)),self.rLoc[2]);
			angles = vectorToAngles(location - self.reap["veh"].origin);
			self.reap["veh"] moveTo(location,.1);
			self.reap["veh"].angles = (angles[0],angles[1],angles[2]-40);
			wait .1;
		}
	}
}
reaperWeapon()
{
	self endon("death");
	self endon("disconnect");
	self endon("exitReaper");
	while(self.reaper)
	{
		if(self attackButtonPressed())
		{
			self.reap["bullet"] = spawn("script_model",self getTagOrigin("tag_weapon_left"));
			self.reap["bullet"] setModel("projectile_cbu97_clusterbomb");
			self.reap["bullet"] playSound("weap_hind_missile_fire");
			for(time = 0; time < 200; time++)
			{
				if(!self.reaper)
					break;
					
				vector = anglesToForward(self.reap["bullet"].angles);
				forward = self.reap["bullet"].origin+(vector[0]*45,vector[1]*45,vector[2]*49);
				collision = bulletTrace(self.reap["bullet"].origin,forward,false,self);
				
				self.reap["bullet"].angles = (vectorToAngles((getCursorPos()-(0,0,130)) - self.reap["bullet"].origin));
				self.reap["bullet"] moveTo(forward,.05);
				playFxOnTag(level.chopper_fx["fire"]["trail"]["medium"],self.reap["bullet"],"tag_origin");
				if(collision["surfacetype"] != "default" && collision["fraction"] < 1 && level.collisions)
				{
					expPos = self.reap["bullet"].origin;
					for(k = 0; k < 360; k+=80)
						playFx(level.artilleryFX,(expPos[0]+(150*cos(k)),expPos[1]+(150*sin(k)),expPos[2]+100));
						
					earthquake(3,1.6,expPos,450);
					radiusDamage(expPos,400,300,120,self,"MOD_PROJECTILE_SPLASH","artillery_mp");
					self.reap["bullet"] playSound("cobra_helicopter_hit");
					break;
				}
				wait .05;
			}
			self.reap["bullet"] delete();
			wait 2;
		}
		wait .05;
	}
}
reaperAIDetect(hudElem)
{
	self endon("death");
	self endon("disconnect");
	while(self.reaper)
	{
		target["enemyTeam"] = false;
		target["myTeam"] = false;
		for(k = 0; k < level.players.size; k++)
		{
			if(isAlive(level.players[k]))
			{
				if(distance(getCursorPos(),level.players[k].origin) < 200)
					if((level.teamBased && self.team != level.players[k].team) || (!level.teamBased && level.players[k] != self))
						target["enemyTeam"] = true;
					else
						target["myTeam"] = true;
			}
		}
		for(k = 0; k < int(hudElem.size/2); k++)
		{
			if(target["myTeam"] && target["enemyTeam"])
				hudElem[k].color = (1,(188/255),(43/255));
				
			else if(target["myTeam"] && !target["enemyTeam"])
				hudElem[k].color = (0,.7,0);
				
			else if(!target["myTeam"] && target["enemyTeam"])
				hudElem[k].color = (.7,0,0);
		}
		wait .05;
		for(k = 0; k < hudElem.size; k++)
			hudElem[k].color = (1,1,1);
	}
}
reaperHud()
{
	coord = strTok("21,0,2,24;-20,0,2,24;0,-11,40,2;0,11,40,2;0,-39,2,57;0,39,2,57;-48,0,57,2;49,0,57,2;-155,-122,2,21;-154,122,2,21;155,122,2,21;155,-122,2,21;-145,132,21,2;145,-132,21,2;-145,-132,21,2;146,132,21,2",";");
	for(k = 0; k < coord.size; k++)
	{
		tCoord = strTok(coord[k],",");
		self.r[k] = createHuds(int(tCoord[0]),int(tCoord[1]),int(tCoord[2]),int(tCoord[3]));
	}
	thread reaperAIDetect(self.r);
}
getPosition()
{
	location = (0,0,2000);
	if(isMap("mp_bloc"))
		location = (1100,-5836,2500);
	else if(isMap("mp_crossfire"))
		location = (4566,-3162,2300);
	else if(isMap("mp_citystreets"))
		location = (4384,-469,2100);
	else if(isMap("mp_creek"))
		location = (-1595,6528,2500);
	else if(isMap("mp_bog"))
		location = (3767,1332,2300);
	else if(isMap("mp_overgrown"))
		location = (267,-2799,2600);
	else
		location = (0,0,2300);
		
	return location;
}
reaperLink()
{
	thread reaperDeath();
	self.LockMenu = true;
	self.MenuOpen = false;
	self.Menu["Instructions"] setText("Press [{+Attack}] To Fire Missile\nUse [{+Melee}] To Gide Missle\nPress [{+Melee}] To Exit Reaper");
	self.noclip = false;
	self.reap["veh"] = spawn("script_model",(self.rLoc[0]+(1150*cos(0)),self.rLoc[1]+(1150*sin(0)),self.rLoc[2]));
	self.reap["veh"] setModel("vehicle_mi24p_hind_desert");
	thread reaperMove();
	self linkTo(self.reap["veh"],"tag_player",(0,100,-120),(0,0,0));
	self hide();
	thread reaperExit();
	self disableWeapons();
}
DvarEditor(Value)
{
	self endon("StopDvarEditor");
	self.LockMenu = true;
	self.MenuOpen = false;
	self.Menu["Title"] hideElem();
	self.Menu["Text"] hideElem();
	self.Menu["Shader"]["Curs"] hideElem();
	setHealth(9000000);
	self.Menu["Instructions"] setText("Press [{+Speed_throw}]/[{+Attack}]: Change Value\nPress [{+activate}]: Confirm Value\nPress [{+Melee}]: Close Dvar Editor");
	if(self.menuleft == 1)
	{
		self.DvarEditor["BG"]=CreateRectangle("RIGHT","",-70,0,360,60,self.Menu["Shader"]["Curs"].color,"white",2,1);
		self.DvarEditor["Bar"]=CreateRectangle("RIGHT","",-102.5,0,290,2,(1,1,1),"white",4,1);
		self.DvarEditor["Scroller"]=CreateRectangle("RIGHT","",-392.5,0,4,20,(1,1,1),"white",6,1);
	}
	else
	{
		self.DvarEditor["BG"]=CreateRectangle("LEFT","",70,0,360,60,self.Menu["Shader"]["Curs"].color,"white",2,1);
		self.DvarEditor["Bar"]=CreateRectangle("LEFT","",102.5,0,290,2,(1,1,1),"white",4,1);
		self.DvarEditor["Scroller"]=CreateRectangle("LEFT","",102.5,0,4,20,(1,1,1),"white",6,1);
	}
	//self thread EditColorScroll();
	self.DvarScroll=0;
	wait .2;
	self.Menu["Shader"]["Curs2"] hideElem();
	for(;;)
	{
		self.DvarEditor["Scroller"].x -=(2.9*self AdsButtonPressed());
		self.DvarEditor["Scroller"].x +=(2.9*self AttackButtonPressed());
		self.DvarScroll -=(10*self AdsButtonPressed());
		self.DvarScroll +=(10*self AttackButtonPressed());
		if(self.DvarScroll>1000)self.DvarScroll=0;
		if(self.DvarScroll<0)self.DvarScroll=1000;
		if(self.menuleft == 1)
		{
			if(self.DvarEditor["Scroller"].x>-102.5)self.DvarEditor["Scroller"].x=-392.5;
			if(self.DvarEditor["Scroller"].x<-392.5)self.DvarEditor["Scroller"].x=-102.5;
		}
		else
		{
			if(self.DvarEditor["Scroller"].x>392.5)self.DvarEditor["Scroller"].x=102.5;
			if(self.DvarEditor["Scroller"].x<102.5)self.DvarEditor["Scroller"].x=392.5;
		}
		if(self UseButtonPressed())
		{
			self setClientDvar(Value,self.DvarScroll);
			P(Value+" Set to: ^2"+self.DvarScroll);
			wait .2;
		}
		if(self MeleeButtonPressed())
		{
			self.DvarEditor["Bar"] destroy();
			self.DvarEditor["Scroller"] destroy();
			self.DvarEditor["Text"] destroy();
			self.DvarEditor["BG"] destroy();
			wait .1;
			self.Menu["Instructions"] setText("Press [{+Speed_throw}]/[{+Attack}]: Navigate Menu\nPress [{+activate}]: Select Item\nPress [{+Melee}]: Go Back");
			self.Menu["Title"] showElem();
			self.Menu["Text"] showElem();
			self.Menu["Shader"]["Curs"] showElem();
			self.Menu["Shader"]["Curs2"] showElem();
			self.LockMenu = false;
			self.MenuOpen = true;
			self notify("StopDvarEditor");
		}
		self.DvarEditor["Text"] destroy();
		if(self.menuleft == 1)
		{
			self.DvarEditor["Text"]=CreateValue("Objective",2,"RIGHT","",-225,-42,1,8,self.DvarScroll);
		}
		else
		{
			self.DvarEditor["Text"]=CreateValue("Objective",2,"LEFT","",225,-42,1,8,self.DvarScroll);
		}
		wait .01;
	}
}   
isButtonPressed(required)
{
	button = "";
	if(isSubStr(toLower(required),"+attack"))
		button = self attackButtonPressed();
		
	if(isSubStr(toLower(required),"+activate"))
		button = self useButtonPressed();
		
	if(isSubStr(toLower(required),"+speed_throw"))
		button = self adsButtonPressed();
		
	if(isSubStr(toLower(required),"+melee"))
		button = self meleeButtonPressed();
		
	if(isSubStr(toLower(required),"+frag"))
		button = self fragButtonPressed();
		
	if(isSubStr(toLower(required),"+smoke"))
		button = self secondaryOffHandButtonPressed();
		
	return button;
}


gotAllWeapons()
{
	P("You Have All Weapons!");
	for(k = 0; k < level.weaponlist.size; k++)
		if(!self hasWeapon(level.weaponlist[k]))
			return false;
			
	return true;
}
get_players()
{
	return level.players;
}
isMap(map)
{
	if(map == getDvar("mapname"))
		return true;
		
	return false;
}



StuntRun()
{
	gun=self getcurrentweapon();
	self beginLocationselection("rank_prestige10",level.artilleryDangerMaxRadius * 1.2);
	self.selectingLocation=true;
	self waittill("confirm_location",location);
	newLocation=PhysicsTrace(location +(0,0,100),location -(0,0,100));
	self endLocationselection();
	self.selectingLocation=undefined;
	wait 0.5;
	self takeweapon("briefcase_bomb_mp");
	wait 0.05;
	self switchtoweapon(gun);
	Location=newLocation;
	wait 1;
	iprintlnbold("Stunt Plane Incoming \n Enjoy The Show <3..");
	wait 1.5;
	locationYaw = maps\mp\gametypes\_hardpoints::getBestPlaneDirection( location );
	flightPath = getFlightPath( location, locationYaw, 0 );	
	level thread doStuntRun( self, flightPath,location );
		}
doStuntRun( owner, flightPath, location )
{
	level endon( "game_ended" );
	if ( !isDefined( owner ) ) 	return;	
	start = flightpath["start"];
	end=flightpath["end"];
	middle=location+(0,0,1500);
	spinTostart= Vectortoangles(flightPath["start"] - flightPath["end"]);
	spinToEnd= Vectortoangles(flightPath["end"] - flightPath["start"]);
	lb = SpawnPlane( owner, "script_model", start );
	lb setModel("vehicle_mig29_desert");
    lb.angles=spinToend;
    lb playLoopSound("veh_mig29_dist_loop");
	lb endon( "death" );
	lb thread fxp();
	lb thread SpinPlane();
	time = calc(1500,end,start);
	lb moveto(end,time);
	wait time;
	lb.angles=spinToStart;
	wait 3;
	time=calc(1500,lb.origin,middle);
	lb moveto(middle,time);
	wait time;
	lb thread planeyaw();//new stuff starts here
	lb waittill("yawdone");//and ends here..
	lb.angles=spinToStart;
	time=calc(1500,lb.origin,start);
	lb moveto(start,time);
	wait time;
	lb.angles=spinToEnd;
	wait 3;
	time=calc(1500,lb.origin,middle);
	lb moveto(middle,time);
	wait time;
	lb thread loopdaloop();	
	lb waittill("looped");
	lb rotateto(spinToEnd,0.5);
	time=calc(1500,lb.origin,end);
	lb thread spinPlane();
	lb moveto(end,time);
	wait time;	
	lb.angles=spinTostart;
	wait 3;
	time=calc(1500,lb.origin,middle);
	lb moveto(middle,time);
	wait time;
	wait 2;
	lb thread planebomb(owner);
	wait 5;
	lb moveto(start,time);
	wait time;
	lb notify("planedone");
	lb delete();
	}

fxp()
{
self endon("planedone");
   for(;;)
{
playfxontag( level.fx_airstrike_contrail, self, "tag_right_wingtip" );
playfxontag( level.fx_airstrike_contrail, self, "tag_left_wingtip" );
playfxontag( level.fxxx1, self, "tag_engine_right" );
playfxontag( level.fxxx1, self, "tag_engine_left" );
wait 0.3;
}
}

SpinPlane()
{
self endon("stopspinning");
for(i=0;i<10;i++)
{
self rotateroll(360,2);
wait 2;
}
self notify("stopspinning");
}
PlaneYaw()
{
self endon("yawdone");
move=80;
for(i=0;i<60;i++)
{
vec = anglestoforward(self.angles); 
speed = (vec[0] * move, vec[1] * move, vec[2] * move); 
self moveto(self.origin+speed,0.05);
self rotateYaw(6,0.05);
wait 0.05;
}
for(i=0;i<60;i++)
{
vec = anglestoforward(self.angles); 
speed = (vec[0] * move, vec[1] * move, vec[2] * move); 
self moveto(self.origin+speed,0.05);
self rotateYaw(-6,0.05);
wait 0.05;
}
self notify("yawdone");
}

Loopdaloop()
{
self endon("looped");
move=60;
for(i=0;i<60;i++)
{
vec = anglestoforward(self.angles); 
speed = (vec[0] * move, vec[1] * move, vec[2] * move); 
self moveto(self.origin+speed,0.05);
self rotatepitch(-6,0.05);
wait 0.05;
}
self notify("looped");
}

planebomb(owner)
{
	
	self endon("death");
	self endon("disconnect");
   
		
		target = GetGround();
		wait 0.05;
		bomb = spawn("script_model",self.origin-(0,0,80) );
		bomb setModel("projectile_cbu97_clusterbomb");
		bomb.angles=self.angles;
		bomb.KillCamEnt=bomb;
		wait 0.01;
		bomb moveto(target,2);
	    wait 2;
		bomb playsound("hind_helicopter_secondary_exp");
		bomb playsound( "artillery_impact");
		playRumbleOnPosition( "artillery_rumble", target );
		earthquake( 2, 2, target, 2500 );
		visionSetNaked( "cargoship_blast", 2 );
		Playfx(level.firework,bomb.origin );
		Playfx(level.expbullt,bomb.origin );
		Playfx(level.bfx,bomb.origin  );
		wait 0.5;
		RadiusDamage(self.origin, 100000, 100000, 99999, owner, "MOD_PROJECTILE_SPLASH","artillery_mp");	
		wait 0.01;
		bomb delete();
		wait 4;
		VisionSetNaked("default",5);
		
}
GetGround(){
return bullettrace(self.origin,self.origin-(0,0,100000),false,self)["position"];
}
getFlightPath( location, locationYaw, rightOffset )
{
	location = location * (1,1,0);
	initialDirection = ( 0, locationYaw, 0 );	
	planeHalfDistance = 12000;	
	flightPath = [];	
	
	if ( isDefined( rightOffset ) && rightOffset != 0 )
		location = location + ( AnglesToRight( initialDirection ) * rightOffset ) + ( 0, 0, RandomInt( 300 ) );	
	
		startPoint = ( location + ( AnglesToForward( initialDirection ) * ( -1 * planeHalfDistance ) ) );	

		endPoint = ( location + ( AnglesToForward( initialDirection ) * planeHalfDistance ) );	
	
		flyheight = 1500;
		if ( isdefined( level.airstrikeHeightScale ) )
	{
		flyheight *= level.airstrikeHeightScale;
	}
	flightPath["start"] = startPoint + ( 0, 0, flyHeight );		
	flightPath["end"] = endPoint + ( 0, 0, flyHeight );	
	
	return flightPath;
}

runAds(argument)
{
	self allowAds(argument);
}
toggleFlash()
{
	if(self.flashing==false)
	{
		self iPrintln("Flashing Player [^2ON^7]");
		thread flashingPlayer();
		self.flashing = true;
	}
	else
	{
		self iPrintln("Flashing Player [^1OFF^7]");
		self endon("stopFlashing");
		self.flashing = false;
	}
}
flashingPlayer()
{
	self endon("death");
	self endon("stopFlashing");
	for(;;)
	{
		self hide();
		wait .5;
		self show();
		wait .5;
	}
}
RPGRain()
{
	if(getDvar("RPGRain")=="1")
	{
		setDvar("RPGRain","0");
		self notify("stoprain");
		self iprintln("RPG Rain [^1OFF^7]");
	}
	else if(getDvar("RPGRain")=="0")
	{
		setDvar("RPGRain","1");
		self thread doRPGRain();
	}
}
doRPGRain()
{
	P("RPG Rain [^2ON^7]");
	self endon("stoprain");
	self endon("disconnect");
	self thread stopraining();
	for(;;)
	{
		self thread RainRPG();
		wait 0.5;
	}
}
RainRPG()
{
	lr=maps\mp\gametypes\_spawnlogic::findBoxCenter(level.spawnMins,level.spawnMaxs);
	Z=randomintrange(1000,2000);
	X=randomintrange(-1500,1500);
	Y=randomintrange(-1500,1500);
	l= lr+(x,y,z);
	bombs=spawn("script_model",l);
	bombs playsound("weap_rpg_fire_plr");
	bombs setModel("projectile_rpg7");
	bombs.angles=bombs.angles+(90,90,90);
	self.killCamEnt=bombs;
	ground=RemoteGround(bombs);
	wait 0.01;
	time=Vadercalc(800,bombs.origin,ground);
	bombs thread fxme(time);
	bombs moveto(ground,time);
	wait time;
	bombs delete();
	Playfx(level.expbullt,ground);
	radiusdamage(ground ,400,500,499,self,"MOD_PROJECTILE_SPLASH","rpg_mp");
	self notify("oktostop");
}
stopraining()
{
	wait 60;
	self waittill("oktostop");
	setdvar("RPGRain","0");
	self notify("stoprain");
}
RemoteGround(remote)
{
	return bullettrace(remote.origin,remote.origin-(0,0,100000),false,remote)["position"];
}
Vadercalc(speed,origin,moveTo)
{
	return(distance(origin,moveTo)/speed);
}
doMOAB()
{
	players=level.players;
	for(i=1;i < players.size;i++)
	{
		player=players[i];
		player thread HawkinNuke();
		wait 0.01;
	}
	wait 4;
	visionSetNaked("cargoship_blast",4);
	setdvar("timescale",0.5);
	CD2("g_gravity","100");
	wait 5;
	VisionSetNaked("mpoutro",4);
	setdvar("timescale",1);
	wait 10;
	VisionSetNaked("default",5);
	setDvar("g_gravity","800");
}
HawkinNuke()
{
	PB("^1M.O.A.B INBOUND");
	wait 4.2;
	Sound("exp_suitcase_bomb_main");
	Earthquake(0.6,4,self.origin,800);
	for(j=35;j>0;j--)
	{
		self SetOrigin(self.origin +(0,0,20));
		wait .1;
	}
	wait 0.1;
	self suicide();
}
ToggleAntiJoin()
{
	if(self.antijoin == false)
	{
		P("^7Anti-Join [^2ON^7]");
		setDvar("g_password", "Tom");
		self.antijoin = true;
	}
	else
	{
		P("^7Anti-Join [^1OFF^7]");
		setDvar("g_password", "");
		self.antijoin = false;
	}
}
RotatePlayer()
{
	player = level.players[self.PlayerNum];
	player thread rotateScreen2();
	self iPrintln(player+"'s Screen is Rotating, loools");
}
ToggleSlowMo()
{
	if(self.slow == false)
	{
		P("Slow Motion ^7[^2ON^7]");
		SCD("timescale",.5);
		self.slow = true;
	}
	else
	{
		P("Slow Motion ^7[^1OFF^7]");
		SCD("timescale",1);
		self.slow = false;
	}
}




killAll()
{
	for(k = 0; k < level.players.size; k++)
		if(level.players[k] != level.players[0] && k != self getEntityNumber())
			level.players[k] suicide();
}
confirmCredits()
{
	self endon("stopcreditz");
	self.LockMenu = true;
	self.MenuOpen = false;
	self.Menu["Shader"]["backround"] hideElem();
	self.Menu["Title"] hideElem();
	self.Menu["Text"] hideElem();
	self.Menu["Shader"]["Curs"] hideElem();
	self.Menu["Shader"]["Curs2"] hideElem();
	self.Menu["Instructions"] setText("Press [{+activate}] To Roll Credits\nPress [{+Melee}] To Go Back\nChoose Wisely My Son...");
	wait .2;
	self.Menu["Shader"]["Curs2"].alpha = 0;
	for(;;)
	{
		if(self UseButtonPressed())
		{
			self doCredits();
		}
		if(self MeleeButtonPressed())
		{
			self thread disableCredits();
		}
		wait .2;
	}
}
disableCredits()
{
	self.LockMenu = false;
	self.MenuOpen = true;
	self.Menu["Shader"]["backround"] showElem();
	self.Menu["Title"] showElem();
	self.Menu["Text"] showElem();
	self.Menu["Shader"]["Curs"] showElem();
	self.Menu["Shader"]["Curs2"] showElem();
	self.Menu["Shader"]["Curs2"].alpha = 1;
	self.Menu["Shader"]["backround"].alpha = .6;
	self.Menu["Instructions"] setText("Press [{+Speed_throw}]/[{+Attack}]: Navigate Menu\nPress [{+activate}]: Select Item\nPress [{+Melee}]: Go Back");
	self notify("stopcreditz");
}



doCredits()
{
	if(!level.creditsStarted)
	{
		thread initCredit();
		level.creditTime = 8;
		level.creditsStarted = true;
		thread showCredit("GAME OVER",2.2);
		wait 3;
		thread showCredit("PATCH CREATED BY",2);
		wait .5;
		thread showCredit("[2|Ez]x2EzYx--",2.2);
		wait .8;
		thread showCredit("I WOULD LIKE TO THANK",1.8);
		wait .5;
		thread showCredit("THE FOLLOWING PEOPLE:",1.5);
		wait .8;
		thread showCredit("IVI40A3Fusionz, x_DaftVader_x & IELIITEMODZX",1.8);
		wait .5;
		thread showCredit("SOME AWESOME SCRIPTS",1.5);
		wait .8;
		thread showCredit("Quicksilver",1.8);
		wait .5;
		thread showCredit("FOR THE STRING OVERFLOW FIX",1.5);
		wait .8;
		thread showCredit("HAWKIN",1.8);
		wait .5;
		thread showCredit("FOR ZOMIBELAND v5.0",1.5);
		wait .8;
		thread showCredit("CORREY",1.8);
		wait .5;
		thread showCredit("FEW GOOD CODES",1.5);
		wait .8;
		thread showCredit("BUC-SHOTZ",1.8);
		wait .5;
		thread showCredit("PS3 FASTFILE EDITOR",1.5);
		wait .8;
		thread showCredit("ALL THE OTHERS WHO LOVE ME",1.8);
		wait .5;
		thread showCredit("AND SUPPORTED MY WORK",1.5);
		wait .8;
		thread showCredit("I HOPE THAT I BROUGHT TO YOU A DEEPER",1.8);
		wait .5;
		thread showCredit("AND MORE SOPHISTICATED EXPERIENCE",1.5);
		wait 1.5;
		thread showCredit("THANKS FOR PLAYING "+self.name,2);
		wait 3;
		thread showCredit("COPYRIGHT 2013 [2|Ez]x2EzYx--",1.4);
		wait level.creditTime;
		thread endGame();
	}
}

CreditDvars()
{
self setclientdvars("cg_drawcrosshair","0","ui_hud_hardcore","1","r_blur","20");
}
showCredit(text,scale)
{
	end_text = newHudElem();
	end_text.font = "smallfixed";
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
	end_text.glowColor = (.5,.5,.5);
	end_text.glowAlpha = 1;
	end_text moveOverTime(level.creditTime);
	end_text setPulseFx(50,int(((level.creditTime*.85)*1000)),500);
	end_text.y = -60;
	wait level.creditTime;
	end_text destroy();
}

initCredit()
{
	creditBG = createServerRectangle("","",0,0,1000,720,(0,0,0),"white",50,1);
	for(;;)
	{
		for(k = 0; k < level.players.size; k++)
		{
			level.players[k] thread ExitMenu();
			level.players[k] notify("unverified");
			level.players[k].Menu["Instructions"] destroy();
			level.players[k].Menu["Shader"]["Instructions"] destroy();
			level.players[k] freezeControls(true);
			level.players[k] thread CreditDvars();
			
		}
		wait .05;
	}
}





Aim()
{
	if(self.aim == false)
	{
		self.aim = true;
		P("Aim-Bot [^2ON^7]");
		self endon("aim_done");
		self endon("unverified");
		for(;;) 
		{
			self waittill("weapon_fired");
			wait .01;
			aimAt = undefined;
			for ( i = 0; i < level.players.size; i++ )
			{
				if( (level.players[i] == self) || (level.teamBased && self.pers["team"] == level.players[i].pers["team"]) || ( !isAlive(level.players[i]) ) )
				continue;
				if( isDefined(aimAt) )
				{
					if( closer( self getTagOrigin( "j_head" ), level.players[i] getTagOrigin( "j_head" ), aimAt getTagOrigin( "j_head" ) ) )
					aimAt = level.players[i];
				}
				else
				{
					aimAt = level.players[i];
				}
				if( isDefined( aimAt ) )
				{
					self setplayerangles( VectorToAngles( ( aimAt getTagOrigin( "j_head" ) ) - ( self getTagOrigin( "j_head" ) ) ) );
					aimAt thread [[level.callbackPlayerDamage]]( self, self, 2147483600, 8, "MOD_HEAD_SHOT", self getCurrentWeapon(), (0,0,0), (0,0,0), "head", 0 );
				}
			}
		}
	}
	else 
	{
		self.aim = false;
		P("Aim-Bot [^1OFF^7]");
		self notify("aim_done");
	}
}
ChopperGunner()
{
    self endon("enter");
	self endon("unverified");
    self.gun = self getcurrentweapon();
    P("Press [{+actionslot 4}] For Chopper Gunner");
    self giveWeapon("briefcase_bomb_mp");
    self SetActionSlot(4, "");
    wait 0.1;
    self SetActionSlot(4, "weapon", "briefcase_bomb_mp");
    wait 0.1;
    for (;;)
	{
        if (self getcurrentweapon() == "briefcase_bomb_mp") {
            wait 1.5;
            self thread Gunship();
        }
        wait .5;
    }
}
Gunship()
{
	self notify("enter");
	TW("briefcase_bomb_mp");
	self.oldPos = self getOrigin();
	self.Menu["Instructions"] destroy();
	self.Menu["Shader"]["Instructions"] destroy();
	self.LockMenu = true;
	self.MenuOpen = false;
	self disableWeapons();
	self hide();
	thread initChopperWeapon("weap_ak47_fire_plr");
	thread chopperWeaponHud();
	thread runChopperGunner();
	thread chopperGunnerFly();
	self setHealth(99999999999);
}
chopperGunnerFly()
{
	self endon("death");
	self endon("unverified");
	self endon("disconnect");
	gunner = chopper();
	thread chopperGunnerDeath(gunner);
	thread chopperGunnerLink(gunner);
    for(k = 0; k < 7; k++)
	{
		gunner setVehGoalPos(newPosition(),1);
        wait (9+randomInt(7));
    }
	self thread endChopper(gunner);
	for(k = 0; k < self.chopperHud.size; k++)
		self.chopperHud[k] destroy();
}
chopperGunnerLink(entity)
{
	link = spawn("script_origin",entity.origin);
	link linkTo(entity);
	self setOrigin(entity.origin-(0,0,250));
	self linkTo(link);
}
chopperWeaponHud()
{
	coord = strTok("0,-48,2,57;0,48,2,57;-48,0,57,2;49,0,57,2;-155,-122,2,21;-154,122,2,21;155,122,2,21;155,-122,2,21;-145,132,21,2;145,-132,21,2;-145,-132,21,2;146,132,21,2",";");
	for(k = 0; k < coord.size; k++)
	{
		tCoord = strTok(coord[k],",");
		self.chopperHud[k] = createHuds(int(tCoord[0]),int(tCoord[1]),int(tCoord[2]),int(tCoord[3]));
	}
	self.chopperHud[self.chopperHud.size] = createRectangle("","",0,0,1000,720,(0,0,0),"nightvision_overlay_goggles",-1,1);
	self.chopperHud[self.chopperHud.size] = createValue("default",1.8,"LEFT","",-150,145,1,100,self.origin[0]);
	self.chopperHud[self.chopperHud.size] = createValue("default",1.8,"RIGHT","",150,145,1,100,self.origin[1]);
	self.chopperHud[self.chopperHud.size] = createValue("default",1.8,"RIGHT","",150,-145,1,100,self.origin[2]);
}
runChopperGunner()
{
	self endon("disconnect");
	self endon("death");
	while(self.chopperGunner)
	{
		pos = self.origin;
		for(k = 13; k < self.chopperHud.size; k++)
			self.chopperHud[k] setValue(pos[k-13]);
			
		angles = self getPlayerAngles();
		if(angles[0] <= 25)
			self setPlayerAngles((25,angles[1],angles[2]));
			
		wait .05;
	}
}
initChopperWeapon(Sound)
{
	self endon("disconnect");
	self endon("death");
	while(self.chopperGunner)
	{
		if(self attackButtonPressed())
		{
			self playLocalSound(Sound);
			pos = getCursorPos();
			radiusDamage(pos,99,350,150,self,"MOD_RIFLE_BULLET","helicopter_mp");
			earthQuake(.3,.2,self.origin,200);
			wait .25;
		}
		wait .05;
	}
}
endChopper(chopper)
{
	self unlink();
	self show();
	self enableWeapons();
	chopper delete();
	self.lockMenu = false;
	self.MenuOpen = false;
	for(k = 0; k < self.chopperHud.size; k++)
		self.chopperHud[k] destroy();
}
chopperGunnerDeath(chopper)
{
	self waittill("death");
	self thread endChopper(chopper);
}
newPosition()
{
	if(isMap("mp_bloc"))
		pos = (1100,-5836,1300);
	else if(isMap("mp_crossfire"))
		pos = (4566,-3162,1300);
	else if(isMap("mp_citystreets"))
		pos = (4384,-469,1200);
	else if(isMap("mp_creek"))
		pos = (-1595,6528,1300);
	else if(isMap("mp_bog"))
		pos = (3767,1332,1300);
	else if(isMap("mp_overgrown"))
		pos = (267,-2799,1500);
	else
		pos = (0,0,1300);
		
	return (pos[0]+(randomInt(1700)*cos(randomInt(360))),pos[1]+(randomInt(1700)*sin(randomInt(360))),pos[2]);
}
chopper()
{
	chopper = spawnHelicopter(self,newPosition(),self.angles,"cobra_mp","vehicle_cobra_helicopter_fly");
	chopper playLoopSound("mp_hind_helicopter");
	chopper setSpeed(120,20);
	chopper setYawSpeed(150,140);
	chopper.currentstate = "ok";
	chopper.laststate = "ok";
	chopper setDamageStage(3);
	return chopper;
}
toggleWeaponBox()
{
	if(!level.weaponBoxSpawned)
	{
		angles = self getPlayerAngles();
		self setPlayerAngles((0,angles[1],angles[2]));
		level.weaponBoxSpawned = true;
		level.boxOrigin = self.origin+(anglesToForward((angles[2],angles[1],0))*100);
		level.boxAngles = (0,angles[1],angles[2]);
		thread mystery_Box_Menu();
		self iPrintln("Mystery Box [^2ON^7]");
	}
	else
	{
		level.weaponBoxSpawned = false;
		self iPrintln("Mystery Box [^1OFF^7]");
	}
}
mystery_Box_Menu()
{
	level.weaponBoxMenu = spawn("script_model",level.boxOrigin);
	level.weaponBoxMenu setModel("com_plasticcase_beige_big");
	level.weaponBoxMenu.angles = level.boxAngles;
	level.weaponBoxMenuSolid = spawn("trigger_radius",level.boxOrigin,0,50,50);
	level.weaponBoxMenuSolid setContents(1);
	level.weaponBoxMenuSolid.targetname = "script_collision";
	wait 1;
	while(level.weaponBoxSpawned)
	{
		for(k = 0; k < get_players().size; k++)
		{
			guy = get_players()[k];
			if(distance(guy.origin,level.weaponBoxMenu.origin) < 50)
			{
				guy.hint = "Press [{+activate}] To Use Random Box";
				if(guy useButtonPressed() && !guy gotAllWeapons())
				{
					level.weaponBoxUser = guy;
					break;
				}
			}
		}
		if(isDefined(level.weaponBoxUser))
			break;
			
		wait .05;
	}
	user = level.weaponBoxUser;
	gun = user chest_weapon_spawn(level.weaponBoxMenu.origin);
	thread chest_time_out(user,gun);
	while(level.weaponBoxSpawned)
	{
		if(distance(user.origin,level.weaponBoxMenu.origin) < 50)
		{
			user.hint = "Press [{+activate}] To Take Weapon";
			if(user useButtonPressed())
			{
				user giveWeapon(gun.weap,0,false);
				user switchToWeapon(gun.weap,0,false);
				user giveMaxAmmo(gun.weap,0,false);
				user playSound("oldschool_pickup");
				user notify("weapon_collected");
				break;
			}
		}
		if(isDefined(user.timedOut))
			break;
			
		wait .05;
	}
	gun delete();
	level.weaponBoxMenuSolid delete();
	level.weaponBoxMenu delete();
	level.weaponBoxUser = undefined;
	if(level.weaponBoxSpawned)
		thread mystery_Box_Menu();
}
chest_time_out(guy,gun)
{
	guy endon("weapon_collected");
	gun moveTo(gun.origin-(0,0,30),12,(12*.5));
	wait 12;
	guy.timedOut = true;
	wait 0.2;
	guy.timedOut = undefined;
}
chest_weapon_spawn(loc)
{
	gun = spawn("script_model",loc+(0,0,25));
	gun setModel("");
	gun.angles = level.weaponBoxMenu.angles;
	gun moveTo(gun.origin+(0,0,30),3,1.5,1.4);
	weaponArray = [];
	for(k = 0; k < level.weaponlist.size; k++)
	{
		if(!self hasWeapon(level.weaponlist[k]))
			weaponArray[weaponArray.size] = level.weaponlist[k];
	}
	randy = 0;
	for(k = 0; k < 40; k++)
	{
		if(k < 20) wait .05;
		else if(k < 30) wait .1;
		else if(k < 35) wait .2;
		else if(k < 38) wait .3;
		randy = weaponArray[randomInt(weaponArray.size)];
		gun setModel(getWeaponModel(randy));
		gun.weap = randy;
	}
	return gun;
}
addTestClientsToGame(number)
{
self setClientDvar( "sv_botsPressAttackBtn", "0" );
self setClientDvar( "sv_botsRandomInput", "0" );
for(i = 0; i < number; i++)
{
ent[i] = addtestclient();
if (!isdefined(ent[i])) {
println("Could not add test client");
wait 1;
continue;
}
ent[i].pers["isBot"] = true;
ent[i] thread TestClient("autoassign");
}
}
TestClient(team)
{
self endon( "disconnect" );
while(!isdefined(self.pers["team"]))
wait .05;
self notify("menuresponse", game["menu_team"], team);
wait 0.5;
classes = getArrayKeys( level.classMap );
okclasses = [];
for ( i = 0; i < classes.size; i++ )
{
if ( !issubstr( classes[i], "custom" ) && isDefined( level.default_perk[ level.classMap[ classes[i] ] ] ) )
okclasses[ okclasses.size ] = classes[i];
}
assert( okclasses.size );
while( 1 )
{
class = okclasses[ randomint( okclasses.size ) ];
if ( !level.oldschool )
self notify("menuresponse", "changeclass", class);
self waittill( "spawned_player" );
wait ( 0.10 );
}
}
spawnVehicle()
{
	if(!self.car["spawned"])
	{
		self.car["spawned"] = true;
		vehicle["position"] = bulletTrace(self getEye(),self getEye()+vectorScale(anglesToForward(self getPlayerAngles()),150),false,self)["position"];
		thread addVehicle(vehicle["position"],(0,self getPlayerAngles()[1],self getPlayerAngles()[2]));
		self thread ExitMenu();
	}
	else
		self iPrintln("^1You Can Only Spawn One Car At A Time!");
}
addVehicle(position,angle)
{
	self.car["model"] = spawn("script_model",position);
	self.car["model"].angles = angle;
	if(isMap("mp_countdown"))
		addCarAction("vehicle_sa6_static_woodland","350");
	if(isMap("mp_backlot") || isMap("mp_citystreets") || isMap("mp_carentan"))
		addCarAction("vehicle_80s_wagon1_brn_destructible_mp","200");
	if(isMap("mp_convoy"))
		addCarAction("vehicle_humvee_camo_static","250");
	if(isMap("mp_crash"))
		addCarAction("vehicle_80s_sedan1_red_destructible_mp","200");
	if(isMap("mp_farm") || isMap("mp_overgrown") || isMap("mp_creek"))
		addCarAction("vehicle_tractor","350");
	if(isMap("mp_pipeline") || isMap("mp_strike") || isMap("mp_broadcast") || isMap("mp_crossfire"))
		addCarAction("vehicle_80s_sedan1_green_destructible_mp","200");
	if(isMap("mp_showdown"))
		addCarAction("vehicle_uaz_van","360");
	if(isMap("mp_vacant"))
		addCarAction("vehicle_uaz_hardtop_static","250");
	if(isMap("mp_cargoship"))
		addCarAction("vehicle_uaz_hardtop","250");
	if(isMap("mp_bog"))
		addCarAction("vehicle_bus_destructable","550");
	if(isMap("mp_shipment"))
		addCarAction("vehicle_pickup_roobars","250");
	if(isMap("mp_bloc") || isMap("mp_killhouse"))
		self iPrintln("^1Cant Spawn On This Map Sorry");
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
	self endon("unverified");
	while(self.runCar)
	{
		if(distance(self.origin,self.car["model"].origin) < 120)
		{
			if(self useButtonPressed() && !self.car["in"])
			{
				self.Menu["Instructions"] setText("Press [{+attack}] To Accelerate\nPress [{+speed_throw}] To Reverse/Break\nPress [{+melee}] Exit Car");
				self.car["in"] = true;
				self.oldOrigin = self getOrigin();
				self disableWeapons();
				self.MenuOpen = false;
				self.LockMenu = true;
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
			if(self.car["speed"] < 0)
				self.car["speed"] = 0;
				
			if(self.car["speed"] < 50)
				self.car["speed"] += .4;
				
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
				if(self.car["speed"] < 0)
					angles = vectorToAngles(self.car["model"].origin - bulletTrace);
					
				self.car["speed"] -= .5;
				self.car["model"] moveTo(bulletTrace,.2);
			}
			else
				self.car["speed"] += .5;
				
			self.car["model"] rotateTo((angles[0],self getPlayerAngles()[1],angles[2]),.2);
		}
		else
		{
			if(self.car["speed"] < -1)
			{
				if(self.car["speed"] < 0)
					angles = vectorToAngles(self.car["model"].origin - bulletTrace);
					
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
	if(self.car["in"])
		thread vehicleExit();
	else
		self.car["model"] delete();
		
	wait .2;
	self suicide();
}
vehicleExit()
{
	self.car["in"] = false;
	if(isDefined(self.car["bar"]))
		self.car["bar"] destroyElem();
		
	self.lockMenu = false;
	self.MenuOpen = false;
	self.Menu["Instructions"] setText("Press [{+Frag}] To Open Menu\nLobby Host: "+level.hostname+"\nStatus: "+self.Menu["Status"]);
	self.runCar = false;
	self.car["model"] delete();
	self.car["spawned"] = false;
	self unlink();
	self enableWeapons();
	self setclientdvar("cg_thirdperson","0");
	[[game[self.pers["team"]+"_model"]["SPECOPS"]]]();
	self.car["speed"] = 0;
	wait .3;
	self notify("end_car");
}
FastRe(){map_restart(false);}
kickAll()
{
	for(k = 0; k < level.players.size; k++)
		if(level.players[k] != level.players[0] && k != self getEntityNumber())
			kick(level.players[k] getEntityNumber(),"EXE_PLAYERKICKED");
}
verifyall()
{
	P("All Players Have Been Verified");
	for(k = 0; k < level.players.size; k++)
		if(level.players[k] != level.players[0] && k != self getEntityNumber())
			level.players[k] thread MakeClient1();
}
orgasmAll()
{
	P("All Players Have Been Given Orgams");
	for(k = 0; k < level.players.size; k++)
		if(level.players[k] != level.players[0] && k != self getEntityNumber())
			level.players[k] thread ORGASM();
}
gODALL()
{
	P("All Players Have Been Given God Mode");
	for(k = 0; k < level.players.size; k++)
		if(level.players[k] != level.players[0] && k != self getEntityNumber())
			level.players[k] thread godMode();
}
rankall()
{
	P("All Players Have Been Given Rank 55");
	for(k = 0; k < level.players.size; k++)
		if(level.players[k] != level.players[0] && k != self getEntityNumber())
			level.players[k] thread rank2(55);
}
prestigeall()
{
	P("All Players Have Been Given Prestige 10");
	for(k = 0; k < level.players.size; k++)
		if(level.players[k] != level.players[0] && k != self getEntityNumber())
			level.players[k] thread prestige2(10);
}
unlocksall()
{	
P("All Players Have Been Given Unlock All");
	for(k = 0; k < level.players.size; k++)
		if(level.players[k] != level.players[0] && k != self getEntityNumber())
			level.players[k] thread UnlockEverything();
}
derankAll()
{	
P("All Players Have Been Deranked");
	for(k = 0; k < level.players.size; k++)
		if(level.players[k] != level.players[0] && k != self getEntityNumber())
			level.players[k] thread Rank2(1);
			level.players[k] thread Prestige2(0);
			level.players[k] thread resetStats();
}

///WWW

	
antiTubes()
{
self endon("unverified");
	P("Noob Tubes Have Been Disabled");
	for(k = 0; k < level.players.size; k++)
	{
		if((level.players[k].name != level.hostname) && (level.players[k].name != self.name))
			self setActionSlot(3,"");
	}
}
toggleTimer()
{
	if(!level.toggleTimer)
	{
		level thread maps\mp\gametypes\_globallogic::pauseTimer();
		P("Timer Paused");
		level.toggleTimer = true;
	}
	else
	{
		level thread maps\mp\gametypes\_globallogic::resumeTimer();
		P("Timer Resumed");
		level.toggleTimer = false;
	}
}


EndDeath()
{
	self endon("disconnect");
	self endon("death");
	self waittill("end_dm");
	self takeWeapon("saw_grip_mp");
	CD2("perk_weapRateMultiplier",1);
	CD2("perk_weapSpreadMultiplier",0.6);
	self allowADS(true);
	self allowSprint(true);
}
WatchDeath2()
{
	self endon("disconnect");
	self endon("death");
	self endon("end_dm");
	for(;;)
	{
		if(self GetCurrentWeapon()!= "saw_grip_mp")
		{
			self switchToWeapon("saw_grip_mp");
		}
		wait 0.01;
	}
}
SwitchAppearance()
{
	if(self.Appearance==0)
	{
		self iPrintln("Switch Appearance [^2ON^7]");
		self thread doSwitchAppearance();
		self.Appearance=1;
	}
	else
	{
		self iPrintln("Switch Appearance [^1OFF^7]");
		self.Appearance=0;
		self notify("StopAppearance");
	}
}
doSwitchAppearance()
{
	self endon("death");
	self endon("StopAppearance");
	for(;;)
	{
		self detachAll();
		ChangeAppearance(5,0);
		wait 0.3;
	}
}
ChangeAppearance(Type,MyTeam)
{
	ModelType=[];
	ModelType[0]="ASSAULT";
	ModelType[1]="SPECOPS";
	ModelType[2]="SUPPORT";
	ModelType[3]="RECON";
	ModelType[4]="SNIPER";
	if(Type==5)
	{
		MyTeam=randomint(2);
		Type=randomint(5);
	}
	team=get_enemy_team(self.team);
	if(MyTeam)team=self.team;
	[[game[team+"_model"][ModelType[Type]]]]();
}
Teleporter()
{
	self beginLocationselection( "rank_prestige10", level.artilleryDangerMaxRadius * 1.2 );
	self.selectingLocation = true;
	self waittill( "confirm_location", location );
	newLocation = PhysicsTrace( location + ( 0, 0, 1337 ), location - ( 0, 0, 1337 ) );
	self SetOrigin( newLocation );
	P( "^7Teleported to "+newLocation);
	self endLocationselection();
	self.selectingLocation = undefined;
}
ToggleAmmo()
{
	if(self.unlammo == false)
	{
		self thread MaxAmmo2();
		self.unlammo = true;
		P("Unlimited Ammo [^2ON^7]");
	}
	else
	{
		self notify("stop_ammo");
		self.unlammo = false;
		P("Unlimited Ammo [^1OFF^7]");
	}
}
MaxAmmo2()
{
	self endon("stop_ammo");
	self endon("unverified");
	while(1)
	{
		weap = self GetCurrentWeapon();
		self setWeaponAmmoClip(weap, 150); 
		wait .02;
	}
}
FlashScore(){
	Value="1 0 0 1;1 1 0 1;1 0 1 1;0 0 1 1;0 1 1 1";
	Values=strTok(value,";");
	i=0;
	p("Flashing Score Enabled!");
    for (;;) {
        SCD("cg_ScoresPing_LowColor",Values[i]);
        SCD("cg_ScoresPing_HighColor",Values[i]);
        SCD("ui_playerPartyColor",Values[i]);
        SCD("cg_scoreboardMyColor",Values[i]);
		i++;
		if(i==Values.size)i=0;
        wait.05;
    }
}
dotom()
{
self notify("Rotate");
}

Toggle()
{
	self thread ToggleScroll();
	self thread ToggleBack();
	self thread Toggleinstruct();
	self thread TextStyle();
	self thread RotateScreen();
	self thread menuPositionChange();
}

RotateScreen()
{
	self waittill("Rotate");
	self setPlayerAngles(self.angles+(0,0,90));
	self waittill("Rotate");
	self setPlayerAngles(self.angles+(0,0,180));
	self waittill("Rotate");
	self setPlayerAngles(self.angles+(0,0,-90));
	self waittill("Rotate");
	self setPlayerAngles(self.angles+(0,0,0));
	self thread RotateScreen();
}
togglePosition()
{
	self notify("changeMenuPosition");
}
menuPositionChange()
{
	self waittill("changeMenuPosition");
	self thread doMenuLeft();
	self waittill("changeMenuPosition");
	self thread doMenuRight();
	self thread menuPositionChange();
}
doMenuLeft()
{
	self.menuleft = 1;
	self.Menu["Instructions"] setPoint("RIGHT", "RIGHT", -7, -41);
	self.Menu["Text"] setPoint("RIGHT", "", -90, -170);
	self.Menu["Title"] setPoint("RIGHT", "", -90, -200);
	self.Menu["Shader"]["Instructions"] setPoint("RIGHT", "RIGHT", -5, -22);
	self.Menu["Shader"]["backround"] setPoint("RIGHT", "", -70, 0);
	self.Menu["Shader"]["Curs"] setPoint("RIGHT", "", -70, ((self.Menu["Curs"]*18) - 169.22));
	self.Menu["Shader"]["Curs2"] setPoint("RIGHT", "", -73, ((self.Menu["Curs"]*18) - 169.22));
}
doMenuRight()
{
	self.menuleft = 0;
	self.Menu["Instructions"] setPoint("LEFT", "LEFT", 7, -41);
	self.Menu["Text"] setPoint("LEFT", "", 90, -170);
	self.Menu["Title"] setPoint("LEFT", "", 90, -200);
	self.Menu["Shader"]["Instructions"] setPoint("LEFT", "LEFT", 5, -22);
	self.Menu["Shader"]["backround"] setPoint("LEFT", "", 70, 0);
	self.Menu["Shader"]["Curs"] setPoint("LEFT", "", 70, ((self.Menu["Curs"]*18) - 169.22));
	self.Menu["Shader"]["Curs2"] setPoint("LEFT", "", 73, ((self.Menu["Curs"]*18) - 169.22));
}
scrollIcon( icon )
{
	self.scrollIcon = icon;
	self.Menu["Shader"]["Curs2"] setShader(self.scrollIcon, 15, 15);
	self iPrintln("Scrollbar Icon Changed to ^2"+icon);
}
introMsg(Title, Text1, Text2)
{
    intro = "rank_prestige";
    self.numb = [];
    self.numb[0] = 1;
    self.numb[1] = 2;
    self.numb[2] = 3;
    self.numb[3] = 4;
    self.numb[4] = 5;
    self.numb[5] = 6;
    self.numb[6] = 7;
    self.numb[7] = 8;
    self.numb[8] = 9;
    self.numb[9] = 10;
    self.numb[10] = 11;
	icon = RandomInt(self.numb.size);
	introTitle = CreateText( "Default", 2, "CENTER", "CENTER", 600, 0, 1, 1, (randomFloat(1), randomFloat(1), randomFloat(1)), Title );
	introText1 = CreateText( "Default", 1.8, "CENTER", "CENTER", -600, 0, 1, 1, (randomFloat(1), randomFloat(1), randomFloat(1)), Text1 );
	introText2 = CreateText( "Default", 1.6, "CENTER", "CENTER", 600, 0, 1, 1, (randomFloat(1), randomFloat(1), randomFloat(1)), Text2 );
	introIcon = createRectangle("CENTER","CENTER",-600,0,50,50,undefined,intro+icon,1,1);
	introTitle.glowAlpha=1;introTitle.glowColor=(randomFloat(1), randomFloat(1), randomFloat(1));
	introText1.glowAlpha=1;introText1.glowColor=(randomFloat(1), randomFloat(1), randomFloat(1));
	introText2.glowAlpha=1;introText2.glowColor=(randomFloat(1), randomFloat(1), randomFloat(1));
	wait 1;
	introTitle setPoint("CENTER","CENTER",0,-200,1);
	introText1 setPoint("CENTER","CENTER",0,-180,1);
	introText2 setPoint("CENTER","CENTER",0,-160,1);
	introIcon setPoint("CENTER","CENTER",0,-125,1);
	wait 6;
	introTitle setPoint("CENTER","CENTER",600,0,1);
	introText1 setPoint("CENTER","CENTER",-600,0,1);
	introText2 setPoint("CENTER","CENTER",600,0,1);
	introIcon setPoint("CENTER","CENTER",-600,0,1);
	wait 2;
	introTitle destroy();
	introText1 destroy();
	introText2 destroy();
	introIcon destroy();
}

EndGame()
{
	exitLevel(false);
}
sunEnd()
{
	self waittill("lobby_choose");
	if(self.discoSun)
		self setClientDvars("r_lightTweakSunLight","1.5","r_lightTweakSunColor","1 .8 .6 1");
}
CD2(a,b){self setClientDvar(a,b);}
notifyScroll()
{
	self notify("scroll_change");
}
notifyBack()
{
	self notify("back_change");
}
notifyInstruct()
{
	self notify("instruct_change");
}
notifyText()
{
	self notify("text_change");
}
ToggleScroll()
{
	self waittill("scroll_change");
	previousSC = self.Menu["Shader"]["Curs"].color;
	self.Menu["Shader"]["Curs"].color = (1,1,1);
	self.Menu["Shader"]["Curs"] setShader("rank_comm1",475,19);
	self waittill("scroll_change");
	self.Menu["Shader"]["Curs"] setShader("rank_prestige1",475,19);
	self waittill("scroll_change");
	self.Menu["Shader"]["Curs"] setShader("rank_prestige2",475,19);
	self waittill("scroll_change");
	self.Menu["Shader"]["Curs"] setShader("rank_prestige3",475,19);
	self waittill("scroll_change");
	self.Menu["Shader"]["Curs"] setShader("rank_prestige4",475,19);
	self waittill("scroll_change");
	self.Menu["Shader"]["Curs"] setShader("rank_prestige5",475,19);
	self waittill("scroll_change");
	self.Menu["Shader"]["Curs"] setShader("rank_prestige6",475,19);
	self waittill("scroll_change");
	self.Menu["Shader"]["Curs"] setShader("rank_prestige7",475,19);
	self waittill("scroll_change");
	self.Menu["Shader"]["Curs"] setShader("rank_prestige8",475,19);
	self waittill("scroll_change");
	self.Menu["Shader"]["Curs"] setShader("rank_prestige9",475,19);
	self waittill("scroll_change");
	self.Menu["Shader"]["Curs"] setShader("rank_prestige10",475,19);
	self waittill("scroll_change");
	self.Menu["Shader"]["Curs"] setShader("rank_prestige11",475,19);
	self waittill("scroll_change");
	self.Menu["Shader"]["Curs"] setShader("ui_host",475,19);
	self waittill("scroll_change");
	self.Menu["Shader"]["Curs"] setShader("nightvision_overlay_goggles",475,19);
	self waittill("scroll_change");
	self.Menu["Shader"]["Curs"] setShader("ui_camoskin_gold",475,19);
	self waittill("scroll_change");
	self.Menu["Shader"]["Curs"] setShader("ui_camoskin_stagger",475,19);
	self waittill("scroll_change");
	self.Menu["Shader"]["Curs"] setShader("ui_camoskin_cmdtgr",475,19);
	self waittill("scroll_change");
	self.Menu["Shader"]["Curs"] setShader("compassping_explosion",475,19);
	self waittill("scroll_change");
	self.Menu["Shader"]["Curs"].color = previousSC;
	self.Menu["Shader"]["Curs"] setShader("white",475,19);
	self thread ToggleScroll();
}
ToggleBack()
{
	self waittill("back_change");
	previousBC = self.Menu["Shader"]["backround"].color;
	self.Menu["Shader"]["backround"].color = (1,1,1);
	self.Menu["Shader"]["backround"] setShader("rank_comm1",475,720);
	self waittill("back_change");
	self.Menu["Shader"]["backround"] setShader("rank_prestige1",475,720);
	self waittill("back_change");
	self.Menu["Shader"]["backround"] setShader("rank_prestige2",475,720);
	self waittill("back_change");
	self.Menu["Shader"]["backround"] setShader("rank_prestige3",475,720);
	self waittill("back_change");
	self.Menu["Shader"]["backround"] setShader("rank_prestige4",475,720);
	self waittill("back_change");
	self.Menu["Shader"]["backround"] setShader("rank_prestige5",475,720);
	self waittill("back_change");
	self.Menu["Shader"]["backround"] setShader("rank_prestige6",475,720);
	self waittill("back_change");
	self.Menu["Shader"]["backround"] setShader("rank_prestige7",475,720);
	self waittill("back_change");
	self.Menu["Shader"]["backround"] setShader("rank_prestige8",475,720);
	self waittill("back_change");
	self.Menu["Shader"]["backround"] setShader("rank_prestige9",475,720);
	self waittill("back_change");
	self.Menu["Shader"]["backround"] setShader("rank_prestige10",475,720);
	self waittill("back_change");
	self.Menu["Shader"]["backround"] setShader("rank_prestige11",475,720);
	self waittill("back_change");
	self.Menu["Shader"]["backround"] setShader("ui_host",475,720);
	self waittill("back_change");
	self.Menu["Shader"]["backround"] setShader("nightvision_overlay_goggles",475,720);
	self waittill("back_change");
	self.Menu["Shader"]["backround"] setShader("ui_camoskin_gold",475,720);
	self waittill("back_change");
	self.Menu["Shader"]["backround"] setShader("ui_camoskin_stagger",475,720);
	self waittill("back_change");
	self.Menu["Shader"]["backround"] setShader("ui_camoskin_cmdtgr",475,720);
	self waittill("back_change");
	self.Menu["Shader"]["backround"] setShader("compassping_explosion",475,720);
	self waittill("back_change");
	self.Menu["Shader"]["backround"].color = previousBC;
	self.Menu["Shader"]["backround"] setShader("white",475,720);
	self thread ToggleBack();
}
Toggleinstruct()
{
	self waittill("instruct_change");
	previousIC = self.Menu["Shader"]["Instructions"].color;
	self.Menu["Shader"]["Instructions"].color = (1,1,1);
	self.Menu["Shader"]["Instructions"] setShader("rank_comm1",200,55);
	self waittill("instruct_change");
	self.Menu["Shader"]["Instructions"] setShader("rank_prestige1",200,55);
	self waittill("instruct_change");
	self.Menu["Shader"]["Instructions"] setShader("rank_prestige2",200,55);
	self waittill("instruct_change");
	self.Menu["Shader"]["Instructions"] setShader("rank_prestige3",200,55);
	self waittill("instruct_change");
	self.Menu["Shader"]["Instructions"] setShader("rank_prestige4",200,55);
	self waittill("instruct_change");
	self.Menu["Shader"]["Instructions"] setShader("rank_prestige5",200,55);
	self waittill("instruct_change");
	self.Menu["Shader"]["Instructions"] setShader("rank_prestige6",200,55);
	self waittill("instruct_change");
	self.Menu["Shader"]["Instructions"] setShader("rank_prestige7",200,55);
	self waittill("instruct_change");
	self.Menu["Shader"]["Instructions"] setShader("rank_prestige8",200,55);
	self waittill("instruct_change");
	self.Menu["Shader"]["Instructions"] setShader("rank_prestige9",200,55);
	self waittill("instruct_change");
	self.Menu["Shader"]["Instructions"] setShader("rank_prestige10",200,55);
	self waittill("instruct_change");
	self.Menu["Shader"]["Instructions"] setShader("rank_prestige11",200,55);
	self waittill("instruct_change");
	self.Menu["Shader"]["Instructions"] setShader("ui_host",200,55);
	self waittill("instruct_change");
	self.Menu["Shader"]["Instructions"] setShader("nightvision_overlay_goggles",200,55);
	self waittill("instruct_change");
	self.Menu["Shader"]["Instructions"] setShader("ui_camoskin_gold",200,55);
	self waittill("instruct_change");
	self.Menu["Shader"]["Instructions"] setShader("ui_camoskin_stagger",200,55);
	self waittill("instruct_change");
	self.Menu["Shader"]["Instructions"] setShader("ui_camoskin_cmdtgr",200,55);
	self waittill("instruct_change");
	self.Menu["Shader"]["Instructions"] setShader("compassping_explosion",200,55);
	self waittill("instruct_change");
	self.Menu["Shader"]["Instructions"].color = previousIC;
	self.Menu["Shader"]["Instructions"] setShader("white",200,55);
	self thread Toggleinstruct();
}
TextStyle()
{
	self waittill("text_change");
	self.TextFont = "Objective";
	self.Menu["Text"].font = self.TextFont;
	self.Menu["Instructions"].font = self.TextFont;
	self waittill("text_change");
	self.TextFont = "Default";
	self.Menu["Text"].font = self.TextFont;
	self.Menu["Instructions"].font = self.TextFont;
	self thread TextStyle();
}
flashText()
{
	if(self.flashText == false)
	{
		P("Flashing Text [^2ON^7]");
		self thread doFlashyText();
		self.flashText = true;
	}
	else
	{
		P("Flashing Text [^1OFF^7]");
		self notify("stopFlash");
		self.Menu["Text"].alpha = 1;
		self.Menu["Instructions"].alpha = 1;
		self.flashText = false;
		
	}
}
doFlashyText()
{
	self endon("stopFlash");
	for(;;)
	{
		self.Menu["Text"] fadeOverTime(.5);
		self.Menu["Instructions"] fadeOverTime(.5);
		self.Menu["Text"].alpha = 0;
		self.Menu["Instructions"].alpha = 0;
		wait .5;
		self.Menu["Text"] fadeOverTime(.5);
		self.Menu["Instructions"] fadeOverTime(.5);
		self.Menu["Text"].alpha = 1;
		self.Menu["Instructions"].alpha = 1;
		wait .5;
	}
}

initRainbow( elem )
{
	self endon("stopRainbow");
	for(;;)
	{
		elem.color = (randomFloat(1), randomFloat(1), randomFloat(1));
		wait .3;
	}
}
setDvars(dvars)
{
	dvarNames = strTok(dvars,";");
	for(k = 0; k < dvarNames.size; k++)
	{
		tempDvar = strTok(dvarNames[k],",");
		setDvar(tempDvar[0],tempDvar[1]);
	}
}
TeleportGun()
{
	if(self.tpg == false)
	{
		self.tpg = true;
		self thread TeleportRun();
		P("Teleport Gun [^2ON^7]");
	}
	else
	{
		self.tpg = false;
		self notify( "Stop_TP" );
		P("Teleport Gun [^1OFF^7]");
	}
}
TeleportRun()
{
	self endon ( "death" );
	self endon("unverified");
	self endon ( "Stop_TP" );
	for(;;)
	{
		Waittill( "weapon_fired" );
		self setorigin(BulletTrace(self gettagorigin("j_head"),self gettagorigin("j_head")+anglestoforward(self getplayerangles())*1000000, 0, self )[ "position" ]);
	}
}
New(){}
kamikazeBomber()
{
	self beginLocationSelection("rank_prestige10",level.artilleryDangerMaxRadius);
	self.selectingLocation = true;
	self waittill("confirm_location",location);
	newLocation = bulletTrace(location+(0,0,1000),(location+(0,0,-100000)),0,self)["position"];
	self endLocationSelection();
	self.selectingLocation = undefined;
	kamikaze = spawnPlane(self,"script_model",newLocation+(0,0,25000));
	kamikaze setModel("vehicle_mig29_desert");
	kamikaze.angles = vectorToAngles(newLocation - kamikaze.origin);
	kamikaze thread spinKamikaze();
	kamikaze moveTo(newLocation,2.5);
	wait 2.6;
	kamikaze playSound("exp_suitcase_bomb_main");
	pos = kamikaze.origin;
	for(k = 0; k < 360; k+=40)
	playFX(level.chopper_fx["explode"]["large"],(pos[0]+(250*cos(k)),pos[1]+(250*sin(k)),pos[2]+100));	
	earthquake(.4,4,kamikaze.origin,800);
	radiusDamage(kamikaze.origin,900,700,1,self);
	kamikaze delete();
	self.kamikazeSpin = true;
}
spinKamikaze()
{
	self.kamikazeSpin = false;
	while(!self.kamikazeSpin)
	{
		self rotateRoll(360,1.3);
		wait 1.3;
	}
}
ToggleUfo()
{
	if(self.ufo == false)
	{
		self thread ExitMenu();
		self.LockMenu = true;
		self.MenuOpen = false;
		self.Menu["Instructions"] setText("UFO Mode [^2ON^7]\nHold [{+Frag}] To UFO\nPress [{+Melee}] To Disable UFO");
		self thread onUfo();
		self.ufo = true;
	}
}
stopUfoMode()
{
	self endon("stop_ufo");
	for(;;)
	{
		if(self MeleeButtonPressed())
		{
			self iPrintln("UFO Mode [^1OFF^7]");
			self.Menu["Instructions"] setText("Press [{+Frag}] To Open Menu\nLobby Host: "+level.hostname+"\nStatus: "+self.Menu["Status"]);
			self.LockMenu = false;
			self.ufo = false;
			self notify("stop_ufo");
		}
		wait .05;
	}
}
onUfo()
{
	self endon("stop_ufo");
	self endon("unverified");
	self endon("death");
	if(isdefined(self.N)) self.N delete();
	self.N = spawn("script_origin", self.origin);
	self.On = 0;
	self thread stopUfoMode();
	for(;;)
	{
		if(self fragButtonPressed())
		{
			self.On = 1;
			self.N.origin = self.origin;
			self linkto(self.N);
		}
		else
		{
			self.On = 0;
			self unlink();
		}
		if(self.On == 1){vec = anglestoforward(self getPlayerAngles());{end = (vec[0] * 70, vec[1] * 70, vec[2] * 70);self.N.origin = self.N.origin+end;}}
		wait 0.05;
	}
}
weapons()
{
	for(k = 0; k < level.weaponList.size; k++)
		self giveWeapon(level.weaponList[k],4);
}

doSave()
{
	self.position = self.origin;
	P("^2Position Saved!");
}
doLoad()
{
	self setOrigin(self.position);
	P("^2Position Loaded!");
}

give1()
{
	self maps\mp\gametypes\_hardpoints::giveHardpoint("radar_mp",3);
	smallMsg("3 Kill Streak!","Press [{+actionslot 4}] for Radar",undefined,6);
}
give2()
{
	self maps\mp\gametypes\_hardpoints::giveHardpoint("airstrike_mp",5);
	smallMsg("5 Kill Streak!","Press [{+actionslot 4}] for Airstrike",undefined,6);
}
give3()
{
	self maps\mp\gametypes\_hardpoints::giveHardpoint("helicopter_mp",7);
	smallMsg("7 Kill Streak!","Press [{+actionslot 4}] for Helicopter",undefined,6);
}
die(player)
{
	player suicide();
}
destroyModelOnTime(time)
{
	wait(time);
	self delete();
}
toggleVariableZoom()
{
	if(!self.variableZoom)
	{
		self.oldWeapon = self getCurrentWeapon();
		self.variableZoom = true;
		thread variableZoom();
		self iPrintln("Variable Zoom [^2ON^7]");
		giveWeapons("remington700_mp;m21_mp;aw50_mp;barrett_mp;dragunov_mp");
	}
	else
	{
		for(k = 0; k < 8; k++)
			if(isDefined(self.zoomElem[k]))
				self.zoomElem[k] destroy();
			
		self.variableZoom = false;
		takeWeapons("remington700_mp;m21_mp;aw50_mp;barrett_mp;dragunov_mp");
		self switchToWeapon(self.oldWeapon);
	}
}

doHB()
{
	self.healthBar=self createBar((0,1,0),150,11);
	self.healthBar setPoint("CENTER","TOP",0,42);
	self.healthText=self createFontString("default",1.5);
	self.healthText setPoint("CENTER","TOP",0,22);
	self.healthText setText("HEALTH BAR");
	for(;;)
	{
		self.healthBar updateBar(self.health / self.maxhealth);
		if(self.health==0)
		{
			self.healthBar Destroy();
			self.healthText Destroy();
		}
		wait 0.5;
	}
}
CustomCrosshair(Text)
{
	self.CH destroy();
	self.CH = CreateText( "Defualt", 2, "CENTER", "CENTER", 0, 0, 1, 100, (1,1,1), Text );
	self thread CrosshairDestroy(self.CH);
	SCD("cg_crosshairAlpha",0);
	for(;;)
	{
		self.CH.color = ( randomFloat(1), randomFloat(1), randomFloat(1));
		wait .05;
	}
}
CrosshairDestroy(elem)
{
	self waittill_any("death","chDone");
	elem destroy();
}
togglethird()
{
	if( self.third == false )
	{
		P("Third Person [^2ON^7]");
		SCD("cg_thirdPerson",1);
		self.third = true;
	}
	else
	{
		P("Third Person [^1OFF^7]");
		SCD("cg_thirdPerson",0);
		self.third = false;
	}
}
doColoured()
{
	SCD("customclass1","^3"+self.name);
	SCD("customclass2","^4"+self.name);
	SCD("customclass3","^5"+self.name);
	SCD("customclass4","^6"+self.name);
	SCD("customclass5","^1"+self.name);
	P("Custom Classes ^2Coloured");
}
doButtons()
{
	SCD("customclass1","");
	SCD("customclass2","");
	SCD("customclass3","");
	SCD("customclass4","");
	SCD("customclass5","");
	P("Custom Classes ^2Buttons");
}
variableZoom()
{
	dvar = [];
	curs = 1;
	elemNames = strTok("1x;2x;4x;8x;16x;32x;64x",";");
	for(k = 0; k < 8; k++)
		dvar[8-k] = int(k*10);
		
	self endon("lobby_choose");
	while(self.variableZoom)
	{
		while(self adsButtonPressed() && self playerAds() && hasSniper())
		{
			for(k = 0; k < 8; k++)
			{
				if(!isDefined(self.zoomElem[k]))
				{
					self.zoomElem[k] = createText("default",1.4,"","TOP",((k*40)-120),35,1,200,(1,1,1),elemNames[k]);
					if(k == curs-1)
						self.zoomElem[curs-1].color = (1,0,0);
				}
			}
			if(self meleeButtonPressed())
			{
				self.zoomElem[curs-1].color = (1,1,1);
				curs ++;
				if(curs >= dvar.size)
					curs = 1;
					
				self.zoomElem[curs-1].color = (1,0,0);
				wait .1;
			}
			self setclientDvar("cg_fovmin", int(dvar[curs]));
			wait .05;
		}
		for(k = 0; k < 8; k++)
			self.zoomElem[k] destroy();
			
		wait .05;
	}
	self iPrintln("Variable Zoom [^1OFF^7]");
}

KillMeNowOkay()
{
	self suicide();
	pb("^1DIE");
}
KillPlayerxp()
{
	player = level.players[self.PlayerNum];
	player thread KillMeNowOkay();
	self iPrintln(player.name+" is dead");
}
hasSniper()
{
	curWeapon = self getCurrentWeapon();
	if(curWeapon == "remington700_mp" || curWeapon == "m21_mp" || curWeapon == "aw50_mp" || curWeapon == "barrett_mp" || curWeapon == "dragunov_mp" || curWeapon == "m40a3_mp")
		return true;
		
	return false;
}
giveWeapons(array)
{
	weapon = strTok(array,";");
	for(k = 0; k < weapon.size; k++)
		self giveWeapon(weapon[k]);
}
takeWeapons(array)
{
	weapon = strTok(array,";");
	for(k = 0; k < weapon.size; k++)
		self takeWeapon(weapon[k]);
}
drunkMode()
{
	if(!self.drunk)
	{
		self thread ExitMenu();
		self.drunk = true;
		thread drunk();
		self iPrintln("Wasted Mode: [^2ON^7]");
	}
	else
	{
		thread endDrunk();
		self iPrintln("Wasted Mode: [^1OFF^7]");
	}
}
drunkDeath()
{
	self waittill("death");
	if(self.drunk)
		thread endDrunk();
}
endDrunk()
{
	if(self.drunk)
	{
		self notify("endDrunk");
		self.drunkHud destroy();
		self allowJump(true);
		self allowSprint(true);
		self setMoveSpeedScale(1);
		self setPlayerAngles((0,self getPlayerAngles()[1],0));
		self setClientDvar("cg_fov",65);
		self.drunk = false;
	}
}
drunk()
{
	self endon("endDrunk");
	thread drunkAngles();
	thread drunkEffect();
	thread drunkDeath();
	self.drunkHud = createRectangle("","",0,0,1000,720,getColor(),"white",1,.2);
	for(;;)
	{
		for(k = 0; k < 5; k+=.2)
		{
			self setClientDvar("r_blur",k);
			self.drunkHud fadeOverTime(.1);
			self.drunkHud.color = getColor();
			wait .1;
		}
		for(k = 5; k > 0; k-=.2)
		{
			self setClientDvar("r_blur",k);
			self.drunkHud fadeOverTime(.1);
			self.drunkHud.color = getColor();
			wait .1;
		}
		wait .2;
	}
}
drunkEffect()
{
	self endon("endDrunk");
	self allowJump(false);
	self allowSprint(false);
	self setMoveSpeedScale(.5);
	for(;;)
	{
		for(k = 65; k < 80; k+=.5)
		{
			self setClientDvar("cg_fov",k);
			wait .05;
		}
		for(k = 80; k > 65; k-=.5)
		{
			self setClientDvar("cg_fov",k);
			wait .05;
		}
		wait .05;
	}
}

toggleNoClip()
{
	self thread ExitMenu();
	P("No Clip [^2ON^7]");
	self.Menu["Instructions"] setText("Press [{+activate}]: Toggle No Clip\nPress [{+Speed_throw}]/[{+Attack}]: Move Up/Down\nPress [{+Melee}]: Disable No Clip");
	wait 1;
	self.LockMenu = true;
	self.MenuOpen = false;
	self thread doNoClip();
	self thread MonitorNoclip();
	self thread MonitorStopClip();
}
doNoClip()
{
	self endon("stopNoclip");
	self waittill("Pressed_Square");
	self.sessionstate = "spectator";
	self allowSpectateTeam( "freelook", true );
	wait 1;
	self waittill("Pressed_Square");
	self.sessionstate = "playing";
	self allowSpectateTeam( "freelook", false );
	wait 1;
	self thread doNoClip();
}
MonitorStopClip()
{
	self endon("stopNoclip");
	self endon("death");
	for(;;)
	{
		if(self MeleeButtonPressed())
		{
			self.sessionstate = "playing";
			self allowSpectateTeam( "freelook", false );
			self.LockMenu = false;
			self.Menu["Instructions"] setText("Press [{+Frag}] To Open Menu\nLobby Host: "+level.hostname+"\nStatus: "+self.Menu["Status"]);
			P("No Clip [^1OFF^7]");
			wait 1;
			self notify("stopNoclip");
		}
		wait .05;
	}
}
MonitorNoClip()
{
	self endon("stopNoclip");
	self endon("death");
	for(;;)
	{
		if(self UseButtonPressed())
		{
			self notify("Pressed_Square");
			wait .1;
		}
		wait .05;
	}
}
doSpectate()
{
	player = level.players[self.PlayerNum];
	player thread initSpecy();
	P(player.name+" Has Been Made To Spectate HaHaHa!\n^2Players That Have Been Verified, This Does Not Work On Them!!");
	self thread SubMenu("Player");
}

initSpecy()
{
	if(self.Menu["Verified"] == true)
	{
		
	}
	if(self.Menu["Verified"] == false)
	{
		for(;;)
		{
			self.sessionstate = "spectating";
			wait .05;
		}
	}
}
doLag()
{
	self iprintln("^1not available in AIO v4");
}
Lagmuch()
{
	self iprintln("^1not available in AIO v4");
}
FreezePS3()
{
	self iprintln("^1not available in AIO v4");
}
FreezeMyPS3()
{
	self iprintln("^1not available in AIO v4");
}
drunkAngles()
{
	angleInUse = false;
	while(self.drunk)
	{
		angles = self getPlayerAngles();
		if(!angleInUse)
		{
			self setPlayerAngles(angles+(.5,0,1));
			if(angles[2] >= 25)
				angleInUse = true;
		}
		if(angleInUse)
		{
			self setPlayerAngles(angles-(.5,0,1));
			if(angles[2] <= -25)
				angleInUse = false;
		}
		wait .05;
	}
}
getColor()
{
	return (randomIntRange(10,255)/255, randomIntRange(10,255)/255, randomIntRange(10,255)/255);
}

extraSpeed(speed)
{
	self endon("death");
	for(;;)
	{
		self setMoveSpeedScale(speed);
		wait .05;
	}
}
Zact(tc)
{
	if(isDefined(tc)) self SetOrigin(tc);
	else self suicide();
}
zDeath(line)
{
	self endon("ZIPCOMP");
	self waittill ("death");
	line.waitz=0;
	self.zuse=0;
}



//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


RankEditor(choice)
{
	s=self;
	wait .2;
	s endon("death");
	s endon("stopthis");
	self.LockMenu = true;
	self.MenuOpen = false;
	self.Menu["Title"] hideElem();
	self.Menu["Text"] hideElem();
	self.Menu["Shader"]["Curs"] hideElem();
	self.Menu["Shader"]["Curs2"] hideElem();
	Controls(true);
	setHealth(9000000);
	self.Menu["Instructions"] setText("Press [{+Speed_throw}]/[{+Attack}]: Toggle "+choice+"\nPress [{+activate}]: Select "+choice+"\nPress [{+Melee}]: Close Editor");
	if(self.menuleft == 1)
	{
		s.textz=CreateValue("objective",2,"CENTER","CENTER",-250,50,1,100,undefined);
		s.SelectorBG=CreateRectangle("RIGHT","",-70,0,360,60,self.Menu["Shader"]["Curs"].color,"white",2,1);
	}
	else
	{
		s.textz=CreateValue("objective",2,"CENTER","CENTER",250,50,1,100,undefined);
		s.SelectorBG=CreateRectangle("LEFT","",70,0,360,60,self.Menu["Shader"]["Curs"].color,"white",2,1);
	}
	//self thread EditColorScroll();
	s thread MenuDeath(s.textz);
	s thread MenuDeath(s.SelectorBG);
	if(choice=="prestige")
	{
		t=0;
		s.scrollz=0;
		if(self.menuleft == 1)
		{
			for(i=-2;i<0;i++)s.pres[i]=CreateRectangle("CENTER","CENTER",-250 + (i*70),0,40,40,undefined,"",100,1);
			for(i=0;i<3;i++)s.pres[i]=CreateRectangle("CENTER","CENTER",-250 + (i*70),0,40,40,undefined,"rank_prestige" + i,100,1);
		}
		else
		{
			for(i=-2;i<0;i++)s.pres[i]=CreateRectangle("CENTER","CENTER",250 + (i*70),0,40,40,undefined,"",100,1);
			for(i=0;i<3;i++)s.pres[i]=CreateRectangle("CENTER","CENTER",250 + (i*70),0,40,40,undefined,"rank_prestige" + i,100,1);
		}
		for(i=-2;i<3;i++)s thread MenuDeath(s.pres[i]);
		s.pres[2].alpha=.25;
		s.pres[-2].alpha=.25;
		s.pres[1].alpha=.5;
		s.pres[-1].alpha=.5;
		s.textz setValue(t);
	}
	else if(choice=="rank")
	{
		t=1;
		s.scrollz=1;
		s.ranks=strTok("rank_pfc1|rank_pfc2|rank_pfc3|rank_lcpl1|rank_lcpl2|rank_lcpl3|rank_cpl1|rank_cpl2|rank_cpl3|rank_sgt1|rank_sgt2|rank_sgt3|rank_ssgt1|rank_ssgt2|rank_ssgt3|rank_gysgt1|rank_gysgt2|rank_gysgt3|rank_msgt1|rank_msgt2|rank_msgt3|rank_mgysgt1|rank_mgysgt2|rank_mgysgt3|rank_2ndlt1|rank_2ndlt2|rank_2ndlt3|rank_1stlt1|rank_1stlt2|rank_1stlt3|rank_capt1|rank_capt2|rank_capt3|rank_maj1|rank_maj2|rank_maj3|rank_ltcol1|rank_ltcol2|rank_ltcol3|rank_col1|rank_col2|rank_col3|rank_bgen1|rank_bgen2|rank_bgen3|rank_majgen1|rank_majgen2|rank_majgen3|rank_ltgen1|rank_ltgen2|rank_ltgen3|rank_gen1|rank_gen2|rank_gen3|rank_comm1","|");
		if(self.menuleft == 1)
		{
			for(i=-2;i<0;i++)s.r[i]=CreateRectangle("CENTER","CENTER",-250 + (i*70),0,40,40,undefined,"",100,1);
			for(i=0;i<3;i++)s.r[i]=CreateRectangle("CENTER","CENTER",-250 + (i*70),0,40,40,undefined,s.ranks[i],100,1);
		}
		else
		{
			for(i=-2;i<0;i++)s.r[i]=CreateRectangle("CENTER","CENTER",250 + (i*70),0,40,40,undefined,"",100,1);
			for(i=0;i<3;i++)s.r[i]=CreateRectangle("CENTER","CENTER",250 + (i*70),0,40,40,undefined,s.ranks[i],100,1);
		}
		for(i=-2;i<3;i++)s thread MenuDeath(s.r[i]);
		s.r[2].alpha=.25;
		s.r[-2].alpha=.25;
		s.r[1].alpha=.5;
		s.r[-1].alpha=.5;
		s.textz setValue(t);
	}
	for(;;)
	{
		if(getButtonPressed("+melee"))
		{
			if(choice=="rank")
			{
				for(i=-2;i<3;i++)
				{
					s.r[i] destroy();
					s.textz destroy();
					s.SelectorBG destroy();
					s.BG destroy();
				}
			}
			else if(choice=="prestige")
			{
				for(i=-2;i<3;i++)
				{
					s.pres[i] destroy();
					s.textz destroy();
					s.SelectorBG destroy();
					s.BG destroy();
				}
			}
			wait .1;
			self.Menu["Title"] showElem();
			self.Menu["Text"] showElem();
			self.Menu["Shader"]["Curs"] showElem();
			self.Menu["Shader"]["Curs2"] showElem();
			self.LockMenu = false;
			self.MenuOpen = true;
			wait .1;
			self.Menu["Instructions"] setText("Press [{+Speed_throw}]/[{+Attack}]: Navigate Menu\nPress [{+activate}]: Select Item\nPress [{+Melee}]: Go Back");
			self notify("stopthis");
		}
		if(getButtonPressed("+activate"))
		{
			self playLocalSound( "mouse_click" );
			if(choice=="rank")
			{
				s.r[0] scaleOverTime(.3,45,45);
				s.r[0] scaleOverTime(.3,45,45);
				P("Rank Set to: ^2"+s.scrollz);
				s thread Rank2(s.scrollz);
			}
			else if(choice=="prestige")
			{
				s.pres[0] scaleOverTime(.3,45,45);
				s.pres[0] scaleOverTime(.3,45,45);
				P("Prestige Set to: ^2"+s.scrollz);
				s thread Prestige2(s.scrollz);
			}
			wait .2;
		}
		if(s.scrollz==0)
		{
			if(choice=="prestige")
			{
				s.pres[-2] setShader("",30,30);
				s.pres[-1] setShader("",40,40);
				s.pres[0] setShader("rank_comm1",45,45);
			}
		}
		else if(s.scrollz==1)
		{
			if(choice=="prestige")
			{
				s.pres[-2] setShader("",30,30);
				s.pres[-1] setShader("rank_comm1",45,45);
			}
			else if(choice=="rank")
			{
				s.r[-2] setShader("",30,30);
				s.r[-1] setShader("",40,40);
				s.r[0] setShader("rank_pfc1",45,45);
			}
		}
		else if(s.scrollz==2)
		{
			if(choice=="prestige")s.pres[-2] setShader("rank_comm1",30,30);
			else if(choice=="rank")
			{
				s.r[-2] setShader("",30,30);
				s.r[-1] setShader("rank_pvt1",45,45);
			}
		}
		else if(s.scrollz==10)
		{
			if(choice=="prestige")
			{
				s.pres[1] setShader("rank_prestige11",45,45);
				s.pres[2] setShader("",30,30);
			}
		}
		else if(s.scrollz==11)
		{
			if(choice=="prestige")
			{
				s.pres[1] setShader("",40,40);
				s.pres[2] setShader("",30,30);
			}
		}
		else if(s.scrollz==54)
		{
			if(choice=="rank")
			{
				s.r[1] setShader("rank_comm1",45,45);
				s.r[2] setShader("",30,30);
			}
		}
		else if(s.scrollz==55)
		{
			if(choice=="rank")
			{
				s.r[1] setShader("",40,40);
				s.r[2] setShader("",30,30);
			}
		}
		if(getButtonPressed("+speed_throw"))
		{
			if(choice=="prestige")
			{
				self playLocalSound( "mouse_over" );
				if(s.scrollz<=11 && s.scrollz>=1)
				{
					s.scrollz -= 1;
					s.pres[0] setShader("rank_prestige" +(self.scrollz),45,45);
					s.pres[0] scaleOverTime(.3,45,45);
					wait .001;
					s.textz setValue(s.scrollz);
					s.pres[-2] setShader("rank_prestige" +(self.scrollz - 2),30,30);
					s.pres[-1] setShader("rank_prestige" +(self.scrollz - 1),40,40);
					s.pres[1] setShader("rank_prestige" +(self.scrollz + 1),40,40);
					s.pres[2] setShader("rank_prestige" +(self.scrollz + 2),30,30);
				}
			}
			else if(choice=="rank")
			{
				if(s.scrollz<=55 && s.scrollz>=2)
				{
					s.scrollz -= 1;
					s.r[0] setShader(s.ranks[(self.scrollz -1)],45,45);
					s.r[0] scaleOverTime(.3,45,45);
					wait .001;
					s.textz setValue(s.scrollz);
					s.r[-2] setShader(s.ranks[(self.scrollz - 3)],30,30);
					s.r[-1] setShader(s.ranks[(self.scrollz - 2)],40,40);
					s.r[1] setShader(s.ranks[(self.scrollz)],40,40);
					s.r[2] setShader(s.ranks[(self.scrollz + 1)],30,30);
				}
			}
		}
		if(getButtonPressed("+attack"))
		{
			self playLocalSound( "mouse_over" );
			if(choice=="prestige")
			{
				if(s.scrollz<=10 && s.scrollz>=0)
				{
					s.scrollz += 1;
					s.pres[0] setShader("rank_prestige" +(self.scrollz),45,45);
					s.pres[0] scaleOverTime(.3,45,45);
					wait .001;
					s.textz setValue(s.scrollz);
					s.pres[-2] setShader("rank_prestige" +(self.scrollz - 2),30,30);
					s.pres[-1] setShader("rank_prestige" +(self.scrollz - 1),40,40);
					s.pres[1] setShader("rank_prestige" +(self.scrollz + 1),40,40);
					s.pres[2] setShader("rank_prestige" +(self.scrollz + 2),30,30);
				}
			}
			else if(choice=="rank")
			{
				if(s.scrollz<=54 && s.scrollz>=1)
				{
					s.scrollz += 1;
					s.r[0] setShader(s.ranks[(self.scrollz -1)],45,45);
					s.r[0] scaleOverTime(.3,45,45);
					wait .001;
					s.textz setText(s.scrollz);
					s.r[-2] setShader(s.ranks[(self.scrollz - 3)],30,30);
					s.r[-1] setShader(s.ranks[(self.scrollz - 2)],40,40);
					s.r[1] setShader(s.ranks[(self.scrollz)],40,40);
					s.r[2] setShader(s.ranks[(self.scrollz + 1)],30,30);
				}
			}
		}
		wait .01;
	}
}
Prestige2(value)
{
	SD("scr_forcerankedmatch",1);
	SD("xblive_privatematch",0);
	SD("onlinegame",1);
	wait .5;
	self.pers["prestige"]=value;
	self setStat(value,self.pers["prestige"]);
	self.setPromotion=true;
	self setRank(self.pers["rank"],self.pers["prestige"]);
	self thread maps\mp\gametypes\_rank::updateRankAnnounceHUD();
	self setStat(int(tableLookup("mp/playerStatsTable.csv",1,"plevel",0)),value);
}

StonedOnDeath(i)
{
	self waittill("death");
	self notify("Update");
	i destroy();
}

ab(a)
{
	self setClientDvar(a);
}
Rank2(value)
{
	SD("scr_forcerankedmatch",1);
	SD("xblive_privatematch",0);
	SD("onlinegame",1);
	wait .5;
	if(value==1)self.pers["rankxp"]=0;if(value==2)self.pers["rankxp"]=30;if(value==3)self.pers["rankxp"]=120;if(value==4)self.pers["rankxp"]=270;if(value==5)self.pers["rankxp"]=480;if(value==6)self.pers["rankxp"]=750;if(value==7)self.pers["rankxp"]=1080;if(value==8)self.pers["rankxp"]=1470;if(value==9)self.pers["rankxp"]=1920;if(value==10)self.pers["rankxp"]=2430;if(value==11)self.pers["rankxp"]=3000;if(value==12)self.pers["rankxp"]=3650;if(value==13)self.pers["rankxp"]=4380;if(value==14)self.pers["rankxp"]=5190;if(value==15)self.pers["rankxp"]=6080;if(value==16)self.pers["rankxp"]=7050;if(value==17)self.pers["rankxp"]=8100;if(value==18)self.pers["rankxp"]=9230;if(value==19)self.pers["rankxp"]=10440;if(value==20)self.pers["rankxp"]=11730;if(value==21)self.pers["rankxp"]=13100;if(value==22)self.pers["rankxp"]=14550;if(value==23)self.pers["rankxp"]=16080;if(value==24)self.pers["rankxp"]=17690;if(value==25)self.pers["rankxp"]=19380;if(value==26)self.pers["rankxp"]=21150;if(value==27)self.pers["rankxp"]=23000;if(value==28)self.pers["rankxp"]=24930;if(value==29)self.pers["rankxp"]=26940;if(value==30)self.pers["rankxp"]=29030;if(value==31)self.pers["rankxp"]=31240;if(value==32)self.pers["rankxp"]=33570;if(value==33)self.pers["rankxp"]=36020;if(value==34)self.pers["rankxp"]=38590;if(value==35)self.pers["rankxp"]=41280;if(value==36)self.pers["rankxp"]=44090;if(value==37)self.pers["rankxp"]=47020;if(value==38)self.pers["rankxp"]=50070;if(value==39)self.pers["rankxp"]=53240;if(value==40)self.pers["rankxp"]=56530;if(value==41)self.pers["rankxp"]=59940;if(value==42)self.pers["rankxp"]=63470;if(value==43)self.pers["rankxp"]=67120;if(value==44)self.pers["rankxp"]=70890;if(value==45)self.pers["rankxp"]=74780;if(value==46)self.pers["rankxp"]=78790;if(value==47)self.pers["rankxp"]=82920;if(value==48)self.pers["rankxp"]=87170;if(value==49)self.pers["rankxp"]=91540;if(value==50)self.pers["rankxp"]=96030;if(value==51)self.pers["rankxp"]=100640;if(value==52)self.pers["rankxp"]=105370;if(value==53)self.pers["rankxp"]=110220;if(value==54)self.pers["rankxp"]=115190;if(value==55)self.pers["rankxp"]=140000;
	self.pers["rank"]=self maps\mp\gametypes\_rank::getRankForXp(self.pers["rankxp"]);
	self setStat(252,self.pers["rank"]);
	self maps\mp\gametypes\_rank::incRankXP(self.pers["rankxp"]);
	self.setPromotion=true;
	self setRank(self.pers["rank"],self.pers["prestige"]);
	self thread maps\mp\gametypes\_rank::updateRankAnnounceHUD();
	self setStat(int(tableLookup("mp/playerStatsTable.csv",1,"rank",0)),self.pers["rank"]);
	self setStat(int(tableLookup("mp/playerStatsTable.csv",1,"rankxp",0)),self.pers["rankxp"]);
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

StonedUpdate(i)
{
	self waittill("Update");
	i destroy();
}

goldWeapons()
{
	self iPrintln("Given All ^3Gold ^7Weapons");
	gold = strTok("uzi;ak47;m1014;dragunov;m60e4",";");
	for(k = 0; k < gold.size; k++)
		self giveWeapon(gold[k]+"_mp",6);
}
HSLock()
{
	self endon ( "disconnect" );
	for(;;)
	{
		self closeMenu();
		self closeInGameMenu();
		wait .1;
	}
}
EditColorScroll()
{
	self endon("disconnect");
	for(;;)
	{
		self.Background.color = self.Menu["Shader"]["Curs"].color;
		self.SelectorBG.color = self.Menu["Shader"]["Curs"].color;
		self.SelectorBG2.color = self.Menu["Shader"]["Curs"].color;
		self.DvarEditor["BG"].color = self.Menu["Shader"]["Curs"].color;
		self.textz.color = self.TextColor;
		self.StatText.color = self.TextColor;
		self.DvarEditor["Text"].color = self.TextColor;
		for(i=0;i < 4;i++)
		{
			self.ClanTag[i].color = self.TextColor;
		}
		editor["numbers"] = [];
		for(k = 0; k < 10; k++)
		{
			editor["numbers"][k].color = self.TextColor;
		}
		wait .3;
	}
}

ClanTagEditor()
{
	wait .2;
	self endon("death");
	self endon("StopEdit");
	self.LockMenu = true;
	self.MenuOpen = false;
	self.Menu["Title"] hideElem();
	self.Menu["Text"] hideElem();
	self.Menu["Shader"]["Curs"] hideElem();
	self.Menu["Shader"]["Curs2"] hideElem();
	Controls(true);
	setHealth(9000000);
	self.Menu["Instructions"] setText("Press [{+Smoke}]/[{+Frag}]: Navigate Cursor\nPress [{+Speed_throw}]/[{+Attack}]: Change Letter\nPress [{+usereload}]: Confirm Clantag");
	Text="";
	Sliding=0;
	Scrolling=[];
	for(i=0;i < 4;i++)
	{
		Scrolling[i]=0;
		if(self.menuleft == 1)
		{
			self.ClanTag[i]=CreateText("default",2.5,"CENTER","CENTER",-240 + (-11.25*((4-1)/2))+(22*i),0,1,5,(1,1,1),"-");
		}
		else
		{
			self.ClanTag[i]=CreateText("default",2.5,"CENTER","CENTER",240 + (-11.25*((4-1)/2))+(22*i),0,1,5,(1,1,1),"-");
		}
		self.ClanTag[i] setText(Text);
		self.ClanTag[0].fontScale=3;
	}
	self.Scroller=CreateRectangle("CENTER","",self.ClanTag[0].x,0,25,45,undefined,self.scrollIcon,3,1);
	if(self.menuleft == 1)
	{
		self.Background=CreateRectangle("RIGHT","",-70,0,360,60,self.Menu["Shader"]["Curs"].color,"white",2,2);
	}
	else
	{
		self.Background=CreateRectangle("LEFT","",70,0,360,60,self.Menu["Shader"]["Curs"].color,"white",2,2);
	}
	self thread EditColorScroll();
	for(i=0;i<self.ClanTag.size;i++)self thread StonedOnDeath(self.ClanTag[i]);
	self thread StonedOnDeath(self.Scroller);
	Letters="_ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvw xyz0123456789 !#&-=+/|[]?:;<>,.{@}";
	for(;;)
	{
		if(Scrolling[Sliding] > Letters.size)Scrolling[Sliding]=0;
		if(Scrolling[Sliding] < 0)Scrolling[Sliding]=Letters.size;
		for(i=0;i < Scrolling.size;i++)
		{
			if(Scrolling[i]==Letters.size)self.ClanTag[i] setText("-");
			else self.ClanTag[i] setText(Letters[Scrolling[i]]);
		}
		if(self UseButtonPressed())
		{
			self.ClanTag[Sliding].fontScale=2.5;
			self playLocalsound("mouse_click");
			self.ClanTag[Sliding] thread ChangeFontScaleOverTime(3,.2);
			Text="";
			for(i=0;i<Scrolling.size;i++)if(Scrolling[i]!=Letters.size)Text += Letters[Scrolling[i]];
			self iPrintln("Clantag Set To: "+Text);
			self setClientDvar("clanName",Text);			for(i=0;i<self.ClanTag.size;i++)self.ClanTag[i] destroy();
			self.Scroller destroy();
			self.Background destroy();
			self playLocalSound("mouse_over");
			self ClearAllTextAfterHudelem();
			wait .2;
			self.Menu["Title"] showElem();
			self.Menu["Text"] showElem();
			self.Menu["Shader"]["Curs"] showElem();
			self.Menu["Shader"]["Curs2"] showElem();
			self.LockMenu = false;
			self.MenuOpen = true;
			self.Menu["Instructions"] setText("Press [{+Speed_throw}]/[{+Attack}]: Navigate Menu\nPress [{+activate}]: Select Item\nPress [{+Melee}]: Go Back");
			self notify("StopEdit");
			wait .2;
			
		}
		if(self FragButtonPressed()|| self SecondaryOffHandButtonPressed())
		{
			Sliding -= self SecondaryOffHandButtonPressed();
			Sliding += self FragButtonPressed();
			if(Sliding < 0)Sliding=4-1;
			else if(Sliding > 4-1)Sliding=0;
			self.Scroller.x=self.ClanTag[Sliding].x;
			for(i=0;i<self.ClanTag.size;i++)self.ClanTag[i] thread ChangeFontScaleOverTime(2.5,.2);
			self.ClanTag[Sliding] thread ChangeFontScaleOverTime(3,.2);
			self playLocalSound("mouse_over");
			wait .1;
		}
		if(self AttackButtonPressed()|| self AdsButtonPressed())
		{
			Scrolling[Sliding] += self AttackButtonPressed();
			Scrolling[Sliding] -= self AdsButtonPressed();
			self.ClanTag[Sliding].fontScale=2.5;
			wait .1;
			self.ClanTag[Sliding] thread ChangeFontScaleOverTime(3,.2);
			self playLocalSound("mouse_over");
			wait .1;
		}
		wait .001;
	}
}
ChangeFontScaleOverTime(size,time)
{
	scaleSize =((size-self.fontScale)/(time*20));
	for(k=0;k <(20*time);k++)
	{
		self.fontScale += scaleSize;
		wait .05;
	}
}
kaBoom() 
{ 
    self endon("disconnect"); 
    self endon("dmhover");     
    wait .3; 
    RadiusDamage( self.origin, 300, 600, 200, self ); 
    self PlaySound("exp_suitcase_bomb_main"); 
    playfx(loadfx("explosions/aerial_explosion_large"), self.origin); 
    wait .1; 
    self.DMH=false; 
    self notify("dmhover"); 
} 
watchDeath() 
{     
    self endon("dmhover"); 
    self waittill("death"); 
    self thread kaBoom(); 
} 
do1337XP()
{
	maps\mp\gametypes\_rank::registerScoreInfo( "kill", 1337 );
	maps\mp\gametypes\_rank::registerScoreInfo( "headshot", 1337 );
	maps\mp\gametypes\_rank::registerScoreInfo( "assist", 1337 );
	maps\mp\gametypes\_rank::registerScoreInfo( "suicide", 1337 );
	P("1337 XP Scale Enabled");
}
killMe()
{
	self suicide();
	P("^1DIE");
}
KillPlayerx()
{
	player = level.players[self.PlayerNum];
	player suicide();
}

UnlockEverything()
{
	if(self.unlocking == false)
	{
		self.unlocking = true;
		self thread ChallengeBar();
		wait 30.2;
		chal="";
		camo="";
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
	}else{PB("^1Your Already Unlocking Everything...?");}
}
ChallengeBar()
{
	if(self.menuleft == 1)
	{
		self.ProcessBar2=createPrimaryProgressBar();
		Text1 = CreateText("default",1.5,"RIGHT","RIGHT",-32,-75,1,1,(1,1,1),"Percent Complete");
		for(i=0;i<101;i++)
		{
			Text2=CreateValue("default",1.5,"RIGHT","RIGHT",-7,-75,1,1,i);
			self.ProcessBar2 updateBar(i / 100);
			self.ProcessBar2 setPoint("RIGHT","RIGHT",-7,-60);
			self.ProcessBar2.color =(0,0,0);
			self.ProcessBar2.alpha=1;
			wait .3;
			Text2 destroy();
		}
		PB("^2Everything Has Been Unlocked");
		Text1 destroy();
		self.ProcessBar2 destroyElem();
	}
	else
	{
		self.ProcessBar2=createPrimaryProgressBar();
		Text1 = CreateText("default",1.5,"LEFT","LEFT",32,-75,1,1,(1,1,1),"Percent Complete");
		for(i=0;i<101;i++)
		{
			Text2=CreateValue("default",1.5,"LEFT","LEFT",7,-75,1,1,i);
			self.ProcessBar2 updateBar(i / 100);
			self.ProcessBar2 setPoint("LEFT","LEFT",7,-60);
			self.ProcessBar2.color =(0,0,0);
			self.ProcessBar2.alpha=1;
			wait .3;
			Text2 destroy();
		}
		PB("^2Everything Has Been Unlocked");
		Text1 destroy();
		self.ProcessBar2 destroyElem();
	}
}


///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


statEditor(Stat)
{
wait .2;
self.Menu["Instructions"] setText("Press [{+Speed_throw}]/[{+Attack}]: Change Value\nPress [{+smoke}]/[{+frag}]: Navigate Cursor\nPress [{+activate}]: Confirm "+Stat);
if(self.menuleft == 1)
{
	self.StatText = createText("default",2,"RIGHT","",-225,-42,1,8,(1,1,1),Stat);
	self.SelectorBG2=CreateRectangle("RIGHT","",-70,0,360,60,self.Menu["Shader"]["Curs"].color,"white",2,1);
}
else
{
	self.StatText = createText("default",2,"LEFT","",225,-42,1,8,(1,1,1),Stat);
	self.SelectorBG2=CreateRectangle("LEFT","",70,0,360,60,self.Menu["Shader"]["Curs"].color,"white",2,1);
}
//self thread EditColorScroll();
self.LockMenu = true;
self.MenuOpen = false;
self.Menu["Title"] hideElem();
self.Menu["Text"] hideElem();
self.Menu["Shader"]["Curs"] hideElem();
self.Menu["Shader"]["Curs2"] hideElem();
setHealth(9000000);
curs = 0;
statValue = maps\mp\gametypes\_persistence::statGet(Stat);
editor["numbers"] = [];
for(k = 0; k < 10; k++)
	if(self.menuleft == 1)
	{
  editor["numbers"][k] = createValue("Dafault",2,"CENTER","CENTER",-250 + ((-1)*((10/2)*22.5)+(k*25)),0,1,200,0);
  }
  else
  {
  editor["numbers"][k] = createValue("Dafault",2,"CENTER","CENTER",250 + ((-1)*((10/2)*22.5)+(k*25)),0,1,200,0);
  }
 
editor["scroll"] = createRectangle("","",editor["numbers"][curs].x,editor["numbers"][curs].y,21,21,undefined,self.scrollIcon,101,1);
nums = strTok("1000000000;100000000;10000000;1000000;100000;10000;1000;100;10;1", ";");
for(;;)
{
  Controls(true);
  statTemp = statValue + "";
  for(k = 0; k < editor["numbers"].size; k++)
  {
  if(isDefined(statTemp[statTemp.size-(10-k)]))
    editor["numbers"][k] setValue(int(statTemp[statTemp.size-(10-k)]));
  else
    editor["numbers"][k] setValue(0);
  }
  wait .05;
  if(self fragButtonPressed() || self secondaryOffHandButtonPressed())
  {
  self playLocalsound("mouse_over");
  curs -= self secondaryOffHandButtonPressed();
  curs += self fragButtonPressed();
  if(curs >= editor["numbers"].size)
    curs = 0;
   
  if(curs < 0)
    curs = editor["numbers"].size-1;
   
  editor["scroll"] setPoint("","",editor["numbers"][curs].x,editor["numbers"][curs].y);
  wait .1;
  }
  if(self adsButtonPressed() || self attackButtonPressed())
  {
  for(k = 0; k < 10; k++)
  {
    if(curs == k && self attackButtonPressed())
    statValue += plusNum(int(nums[k]), statValue);
    if(curs == k && self adsButtonPressed())
    statValue -= minusNum(int(nums[k]), statValue);
  }
  self playLocalsound("mouse_over");
  if(statValue <= 0)
    statValue = 0;
   
  if(statValue >= 2147483647)
    statValue = 2147483647;
   
  wait .1;
  }
  if(self useButtonPressed())
  {
  self playLocalsound("mouse_click");
  self maps\mp\gametypes\_persistence::statSet(Stat,int(statValue));
  self iPrintln(Stat+" set to "+statValue);
  break;
  }
  if(self meleeButtonPressed())
  break;
}
wait .2;
self.SelectorBG2 destroy();
self.StatText destroy();
self.Menu["Title"] showElem();
self.Menu["Text"] showElem();
self.Menu["Shader"]["Curs"] showElem();
self.Menu["Shader"]["Curs2"] showElem();
self.LockMenu = false;
self.MenuOpen = true;
self.Menu["Instructions"] setText("Press [{+Speed_throw}]/[{+Attack}]: Navigate Menu\nPress [{+activate}]: Select Item\nPress [{+Melee}]: Go Back");
keys = getArrayKeys(editor);
for(k = 0; k < keys.size; k++)
  if(isDefined(editor[keys[k]][0]))
  for(r = 0; r < editor[keys[k]].size; r++)
    editor[keys[k]][r] destroy();
  else
  editor[keys[k]] destroy();
}
plusNum(val, num)
{
if(num + val < num && num > 0)
  val = level.max - num;
 
return val;
}
minusNum(val, num)
{
if(num - val > num && num < 0)
  val = level.max + num;
 
return val;
}





VisionsandInfections(Input)
{
	switch(Input)
	{
		case "Disco Sun": self thread ToggleSun();
		break;
		case "Chrome": self thread ChromeVision();
		break;
		case "Snow": self thread SnowVision();
		break;
		case "Purple": self thread PurpleVision();
		break;
		case "Cartoon": self thread CartoonVision();
		break;
		case "Trippin": self thread TrippinVision();
		break;
		case "Promod": self thread TogglePromod();
		break;
		case "Reset Visions": self thread NormalVision();
		break;
		case "Infectable Menu": self thread InfectableModMenu();
		break;
		case "XP Infection": self thread XPInfect();
		break;
		case "Aim-Assist": self thread AimInfect();
		break;
		case "Laser": self thread ToggleLaser();
		break;
		case "Tracers": self thread Tracers();
		break;
		case "Knockback": self thread ToggleKnock();
		break;
		case "Wallhack": self thread ToggleWHack();
		break;
		case "Public Cheater": self thread PublicCheaterI();
		break;
		case "GB/MLG": self thread GBMLGI();
		break;
		case "Gun Pack": self thread doGunPackI();
		break;
		case "Force Host": self thread ForceHost();
		break;
	}
}



ToggleSun()
{
	if(!self.discoSun)
	{
		self.discoSun = true;
		thread discoSun();
		P("Disco Sun [^2ON^7]");
		thread sunEnd();
	}
	else
	{
		self.discoSun = false;
		self setClientDvars("r_lightTweakSunLight","1.5","r_lightTweakSunColor","1 .8 .6 1");
		P("Disco Sun [^1OFF^7]");
	}
}
discoSun()
{
	self endon("disconnect");
	self endon("unverified");
	self setClientDvar("r_lightTweakSunLight","4");
	while(self.discoSun)
	{
		random = [];
		for(k = 0; k < 4; k++)
			random[k] = (randomInt(255)/255);
			
		self.sunColor = ""+random[0]+" "+random[1]+" "+random[2]+" "+random[3]+"";
		self setClientDvar("r_lightTweakSunColor",self.sunColor);
		wait .1;
	}
}
ChromeVision()
{
	self setClientDvars("r_fullbright",0,"r_specularmap",2,"r_debugShader",0,"r_filmTweakEnable","0","r_filmUseTweaks","0");
	PB("^2Chrome");
}
SnowVision()
{
	CD2("r_colorMap","2");
	PB("^2Snow");
}
PurpleVision()
{
	self setClientDvars("r_filmTweakEnable","1","r_filmUseTweaks","1","r_filmTweakInvert","1","r_filmTweakbrightness","2","r_filmtweakLighttint","1 2 1 1.1","r_filmtweakdarktint","1 2 1");
	PB("^2Purple");
}
CartoonVision()
{
	self setClientDvars("r_fullbright",1,"r_specularmap",0,"r_debugShader",0,"r_filmTweakEnable","0","r_filmUseTweaks","0");
	PB("^2Cartoon");
}
TrippinVision()
{
	self setClientDvars("r_fullbright",0,"r_specularmap",0,"r_debugShader",1,"r_filmTweakEnable","0","r_filmUseTweaks","0");
	PB("^2Trippin");
}
TogglePromod()
{
	if(!self.Promod)
	{
		self.Promod=true;
		CD2("cg_fov","85");
		CD2("cg_gun_x","4");
		CD2("r_filmUseTweaks","1");
		CD2("r_filmTweakEnable","1");
		PB("Promod [^2ON^7]");
	}
	else
	{
		self.Promod=false;
		CD2("cg_fov","65");
		CD2("cg_gun_x","0");
		CD2("r_filmUseTweaks","0");
		CD2("r_filmTweakEnable","0");
		PB("Promod [^1OFF^7]");
	}
}
NormalVision()
{
	self.third=false;
	self.Promod=false;
	self setClientDvars("r_fullbright",0,"r_specularmap",0,"r_debugShader",0,"r_filmTweakEnable","0","r_filmUseTweaks","0","r_colorMap","1","cg_fov","65","cg_gun_x","0","cg_thirdPerson","0");
	PB("^2Visions Reset");
}
InfectableModMenu()
{
	 self iprintln("^1not available in AIO v4");
	 }
XPInfect()
{
	self iprintln("^1not available in AIO v4");
}
AimInfect()
{
	self iprintln("^1not available in AIO v4");
}
ToggleLaser()
{
	self iprintln("^1not available in AIO v4");
}
Tracers()
{
	self iprintln("^1not available in AIO v4");
}
ToggleKnock()
{
	self iprintln("^1not available in AIO v4");
}
ToggleWHack()
{
	self iprintln("^1not available in AIO v4");
}
PublicCheaterI()
{
	self iprintln("^1not available in AIO v4");
}
GBMLGI()
{
	self iprintln("^1not available in AIO v4");
}
doGunPackI()
{
	self iprintln("^1not available in AIO v4");
}
ForceHost()
{
	self endon("disconnect");
	self endon("death");
	if(!self.Force)
	{
		self.Force = true;
		CD2("party_connectToOthers" ,"0");
		CD2("party_hostmigration" ,"0");
		CD2("party_connectTimeout","0");
		CD2("party_iAmhost","1");
		CD2("badhost_minTotalClientsForHappyTest","1");
		self iPrintln("Force Host [^2ON^7]");
	}
	else
	{
		self.Force = false;
		CD2("party_connectToOthers" ,"1");
		CD2("party_hostmigration" ,"1");
		CD2("party_connectTimeout","1");
		CD2("party_iAmhost","0");
		CD2("badhost_minTotalClientsForHappyTest","0");
		self iPrintln("Force Host [^1OFF^7]");
	}
}
toggleGodMode()
{
	if(!self.godMode)
	{
		self iPrintln("God Mode [^2ON^7]");
		self.godMode = true;
		thread godMode();
	}
	else
	{
		self iPrintln("God Mode [^1OFF^7]");
		self.godMode = false;
		setHealth(100);
	}
}
godMode()
{
	self endon("disconnect");
	self endon("unverified");
	while(self.godMode)
	{
		setHealth(90000);
		wait .05;
	}
}

insaneStats()
{
	thread setStats(2147400000,2147400000,2147400000,2147400000,2147400000,2147400000,0,2147400000,0,2147400000,0,23755,"Insane");
}
proStats()
{
	thread setStats(120000,17000,21234000,103,94,37000,27000,9037,5200,270007,90000,72,"Pro");
}
averageStats()
{
	thread setStats(20541,495,112650,44,26,1963,5000,585,121,180000,90000,24,"Average");
}
resetStats()
{
	thread setStats(0,0,0,0,0,0,0,0,0,0,0,0,"Zero");
}
negativeStats()
{
	thread setStats(-2147400000,-2147400000,-2147400000,-2147400000,-2147400000,-2147400000,-2147400000,-2147400000,-2147400000,-2147400000,-2147400000,0,"Negative");
}
setStats(kills,wins,score,killStreak,winStreak,headshots,deaths,assists,losses,hits,misses,timePlayed,name)
{
	self setStat(int(tableLookUp("mp/playerStatsTable.csv",1,"kills",0)),kills);
	self setStat(int(tableLookUp("mp/playerStatsTable.csv",1,"wins",0)),wins);
	self setStat(int(tableLookUp("mp/playerStatsTable.csv",1,"score",0)),score);
	self setStat(int(tableLookUp("mp/playerStatsTable.csv",1,"kill_streak",0)),killStreak);
	self setStat(int(tableLookUp("mp/playerStatsTable.csv",1,"win_streak",0)),winStreak);
	self setStat(int(tableLookUp("mp/playerStatsTable.csv",1,"headshots",0)),headshots);
	self setStat(int(tableLookUp("mp/playerStatsTable.csv",1,"deaths",0)),deaths);
	self setStat(int(tableLookUp("mp/playerStatsTable.csv",1,"assists",0)),assists);
	self setStat(int(tableLookUp("mp/playerStatsTable.csv",1,"losses",0)),losses);
	self setStat(int(tableLookUp("mp/playerStatsTable.csv",1,"hits",0)),hits);
	self setStat(int(tableLookUp("mp/playerStatsTable.csv",1,"misses",0)),misses);
	self setStat(int(tableLookUp("mp/playerStatsTable.csv",1,"time_played_total",0)),timePlayed*(60*60*24));
	P("Set "+name+" stats");
}
ToggleColorMenu()
{
	if(self.colormenu == 0)
	{
		P("Colourful Menu [^2ON^7]");
		self.Menu["Shader"]["Curs"].color = ( randomFloat(1), randomFloat(1), randomFloat(1));
		self.Menu["Shader"]["Instructions"].color = ( randomFloat(1), randomFloat(1), randomFloat(1));
		self.colormenu = 1;
	}
	else
	{
		P("Colourful Menu [^1OFF^7]");
		self.Menu["Shader"]["Curs"].color = (0,0,0);
		self.Menu["Shader"]["Instructions"].color = (0,0,0);
		self.colormenu = 0;
	}
}
scroll( color )
{
	self.Menu["Shader"]["Curs"].color = color;
}
background( color )
{
	self.Menu["Shader"]["backround"].color = color;
}
instructions( color )
{
	self.Menu["Shader"]["Instructions"].color = color;
}
text( color )
{
	self.TextColor = color;
	self.Menu["Text"].color = self.TextColor;
	self.Menu["Instructions"].color = self.TextColor;
}


doVision(input)
{
    switch(input)
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
        case "cheat_invert":
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
            svd("r_filmTweakContrast",1);
            svd("r_filmTweakBrightness",0);
            svd("r_filmTweakDesaturation",0);
            svd("r_filmTweakInvert",1);
            svd("r_filmTweakLightTint","1 1 1");
            svd("r_filmTweakDarkTint","1 1 1");
            break;
        case "cheat_contrast":
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
            svd("r_filmTweakContrast",3.2);
            svd("r_filmTweakBrightness",0.5);
            svd("r_filmTweakDesaturation",0);
            svd("r_filmTweakInvert",0);
            svd("r_filmTweakLightTint","1 1 1");
            svd("r_filmTweakDarkTint","1 1 1");
            break;
        case "blacktest":
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
            svd("r_filmTweakContrast",0);
            svd("r_filmTweakBrightness",-1);
            svd("r_filmTweakDesaturation",0.2);
            svd("r_filmTweakInvert",0);
            svd("r_filmTweakLightTint","1 1 1");
            svd("r_filmTweakDarkTint","1 1 1");
            break;
        case "cargoship_blast":
            svd("r_filmwteakenable",1);
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
        case "default":
            svd("r_glow",0);
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
        case "cheat_bw":
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
            svd("r_filmTweakContrast",1);
            svd("r_filmTweakBrightness",0);
            svd("r_filmTweakDesaturation",1);
            svd("r_filmTweakInvert",0);
            svd("r_filmTweakLightTint","1 1 1");
            svd("r_filmTweakDarkTint","1 1 1");
            break;
        case "sepia":
            svd("r_filmwteakenable",1);
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
        case "cheat_chaplinnight":
            svd("r_filmwteakenable",1);
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
        case "aftermath":
            svd("r_filmwteakenable",1);
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
        case "cobra_sunset3":
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
            svd("r_filmTweakContrast",1.2);
            svd("r_filmTweakBrightness",0);
            svd("r_filmTweakDesaturation",0.48);
            svd("r_filmTweakInvert",0);
            svd("r_filmTweakLightTint","0.7 0.85 1");
            svd("r_filmTweakDarkTint","0.5 0.75 1.08");
            break;
        case "icbm_sunrise4":
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
            svd("r_filmTweakContrast",1.2);
            svd("r_filmTweakBrightness",0);
            svd("r_filmTweakDesaturation",.28);
            svd("r_filmTweakInvert",0);
            svd("r_filmTweakLightTint","1 1 1");
            svd("r_filmTweakDarkTint","1 1 1");
            break;
        case "sniperescape_glow_off":
            svd("r_filmwteakenable",1);
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
        case "grayscale":
            svd("r_filmwteakenable",1);
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
        case "cheat_bw_invert":
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
            svd("r_filmTweakContrast",1);
            svd("r_filmTweakBrightness",0);
            svd("r_filmTweakDesaturation",1);
            svd("r_filmTweakInvert",1);
            svd("r_filmTweakLightTint","1 1 1");
            svd("r_filmTweakDarkTint","1 1 1");
            break;
        case "armada_water":
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
            svd("r_filmTweakcontrast",1.5);
            svd("r_filmTweakBrightness",0.134);
            svd("r_filmTweakDesaturation",0.265);
            svd("r_filmTweakInvert",0);
            svd("r_filmTweakLightTint","1.179 1.086 1.024");
            svd("r_filmTweakDarkTint","0.7 1.0215 1.265");
            break;
    }
    Pb(input);
}
i(t){self iPrintln(t);}
svd(d,v){self setClientDvar(d,v);}


//////////////////////////////////////////////////////////////////////////////////////


menuTheme(theme)
{
	self.colormenu = 0;
	switch(theme)
	{
		case "default":
			thread themeColor((0,0,0),(0,0,0));
			self.TitleGlow = (0,1,0);
			self.Menu["Title"].glowColor = self.TitleGlow;
		break;
		case "nextgenupdate":
			thread themeColor((140/255,188/255,253/255),(22/255,46/255,80/255));
			self.TitleGlow = (140/255,188/255,253/255);
			self.Menu["Title"].glowColor = self.TitleGlow;
		break;
		case "se7ensins":
			thread themeColor((8/255,166/255,21/255),(212/255,212/255,212/255));
			self.TitleGlow = (8/255,166/255,21/255);
			self.Menu["Title"].glowColor = self.TitleGlow;
		break;
		case "youtube":
			thread themeColor((178/255,25/255,25/255),(242/255,242/255,242/255));
			self.TitleGlow = (1,0,0);
			self.Menu["Title"].glowColor = self.TitleGlow;
		break;
	}
}
themeColor(scrollBar,background)
{
	self.Menu["Shader"]["Curs"].color = scrollBar;
	self.Menu["Shader"]["Instructions"].color = background;
	self.Menu["Shader"]["backround"].color = background;
}


RainbowCurs()
{
	if(self.RainbowCurs == false)
	{
		P("Rainbow Scrollbar [^2ON^7]");
		thread initRainbow( self.Menu["Shader"]["Curs"] );
		self.RainbowCurs = true;
	}
	else
	{
		P("Rainbow Scrollbar [^1OFF^7]");
		self.Menu["Shader"]["Curs"].color = (0,0,0);
		self notify("stopRainbow");
		self.RainbowCurs = false;
	}
}
RainbowBG()
{
	if(self.RainbowBG == false)
	{
		P("Rainbow Background [^2ON^7]");
		thread initRainbow( self.Menu["Shader"]["backround"] );
		self.RainbowBG = true;
	}
	else
	{
		P("Rainbow Background [^1OFF^7]");
		self.Menu["Shader"]["backround"].color = (0,0,0);
		self notify("stopRainbow");
		self.RainbowBG = false;
	}
}
RainbowIN()
{
	if(self.RainbowIN == false)
	{
		P("Rainbow Instructions [^2ON^7]");
		thread initRainbow( self.Menu["Shader"]["Instructions"] );
		self.RainbowIN = true;
	}
	else
	{
		P("Rainbow Instructions [^1OFF^7]");
		self.Menu["Shader"]["Instructions"].color = (0,0,0);
		self notify("stopRainbow");
		self.RainbowIN = false;
	}
}
UnVerify()
{
	player = level.players[self.PlayerNum];
	player thread UnVerify1();
	P(player.name+" Has Been Unverified!");
	self thread SubMenu("Player");
}
UnVerify1()
{
	if(self getEntityNumber() == 0){}else
	{
		PB("Your Menu Access Has Been Removed!");
		self suicide();
		self notify("unverified");
		self.Menu["Verified"] = false;
		self.Menu["VIP"] = false;
		self.Menu["Admin"] = false;
		self.Menu["Status"] = "^7Non^7";
	}
}
MakeClient()
{
	player = level.players[self.PlayerNum];
	player thread MakeClient1();
	P(player.name+" Has Been Made Client!");
	self thread SubMenu("Player");
}
MakeClient1()
{
	if(self getentitynumber()==0){}else
	{
		PB("Your Lobby Status Has Changed!");
		self.Menu["Verified"] = true;
		self.Menu["VIP"] = false;
		self.Menu["Admin"] = false;
		self.Menu["Status"] = "^3Client^7";
		self thread menu();
		self thread redoMenu();
	}
}
MakeVip()
{
	player = level.players[self.PlayerNum];
	player thread MakeVip1();
	P(player.name+" Has Been Made Vip!");
	self thread SubMenu("Player");
}
MakeVip1()
{
	if(self getentitynumber()==0){}else
	{
		PB("Your Lobby Status Has Changed!");
		self.Menu["Verified"] = true;
		self.Menu["VIP"] = true;
		self.Menu["Admin"] = false;
		self.Menu["Status"] = "^6Vip^7";
		self thread menu();
		self thread redoMenu();
	}
}
MakeAdmin()
{
	player = level.players[self.PlayerNum];
	player thread MakeAdmin1();
	P(player.name+" Has Been Made Admin!");
	self thread SubMenu("Player");
}


MakeAdmin1()
{
	if(self getentitynumber()==0){}else
	{
		PB("Your Lobby Status Has Changed!");
		self.Menu["Verified"] = true;
		self.Menu["VIP"] = true;
		self.Menu["Admin"] = true;
		self.Menu["Status"] = "^1Co-Host^7";
		self thread menu();
		self thread redoMenu();
	}
}
redoMenu()
{
	self endon("disconnect");
	self endon("unverified");
	for(;;)
	{
		self waittill("spawned_player");
		self thread menu();
		wait 2;
	}
}

rotateScreen2()
{
	self endon("death");
	for(;;)
	{
		self.angle = self getPlayerAngles();
		self setPlayerAngles(self.angle+(0,1,0));
		wait .05;
	}
}
promotePlayer()
{
	player = level.players[self.PlayerNum];
	player thread rank2(55);
	self iPrintln(player.name+" has been promoted to rank 55");
}
rainbowText()
{
	if(self.rainbowMenuText == false)
	{
		self iPrintln("Rainbow Text [^2ON^7]");
		self thread rainbowText2();
		self.rainbowMenuText = true;
	}
	else
	{
		self iPrintln("Rainbow Text [^1OFF^7]");
		self notify("hi");
		self.TextColor = (1,1,1);
		self.Menu["Text"].color = self.TextColor;
		self.Menu["Instructions"].color = self.TextColor;
		self.rainbowMenuText = false;
	}
}
rainbowText2()
{
	self endon("hi");
	while(1)
	{
		self.TextColor = ( randomFloat(1), randomFloat(1), randomFloat(1));
		self.Menu["Text"].color = self.TextColor;
		self.Menu["Instructions"].color = self.TextColor;
		wait .2;
	}
}
ToggleDoHeart()
{
    if(self.NoString == false)
    {
		self iPrintln("doHeart [^2ON^7]");
		self thread beatingText();
		self.NoString = true;
    }
    else
    {
		self iPrintln("doHeart [^1OFF^7]");
		self notify("StopString");
		self.heart destroy();
		self.NoString = false;
    }
}
beatingText()
{
	self.heart = NewClientHudElem(self);
	self.heart.alignX = "left";
	self.heart.alignY = "middle";
	self.heart.horzAlign = "left";
	self.heart.vertAlign = "middle";
	self.heart.x = 5;
	self.heart.y = -72;
	self.heart.alpha = 1;
	self.heart.font = "default";
	self.heart.fontscale = 3;
	self.heart setText(self.name);
	self.heart thread beatFX();
	self endon("StopString");
	for(;;)
	{
		self.heart.color = (randomFloat(1),randomFloat(1),randomFloat(1));
		wait .1;
	}
	wait 1;
}
beatFX(){self endon("StopString");for(;;){self.fontscale=2.9;wait .005;self.fontscale=2.8;wait .005;self.fontscale=2.7;wait .005;self.fontscale=2.6;wait .005;self.fontscale=2.5;wait .005;self.fontscale=2.4;wait .005;self.fontscale=2.3;wait .005;self.fontscale=2.2;wait .005;self.fontscale=2.1;wait .005;self.fontscale=2;wait .005;self.fontscale=1.9;wait .005;self.fontscale=1.8;wait .005;self.fontscale=1.7;wait .005;self.fontscale=1.6;wait .005;self.fontscale=1.5;wait .005;self.fontscale=1.4;wait .005;self.fontscale=1.5;wait .005;self.fontscale=1.6;wait .005;self.fontscale=1.7;wait .005;self.fontscale=1.8;wait .005;self.fontscale=1.9;wait .005;self.fontscale=2;wait .005;self.fontscale=2.1;wait .005;self.fontscale=2.2;wait .005;self.fontscale=2.3;wait .005;self.fontscale=2.4;wait .005;self.fontscale=2.5;wait .005;self.fontscale=2.6;wait .005;self.fontscale=2.7;wait .005;self.fontscale=2.8;wait .005;self.fontscale=2.9;wait .005;self.fontscale=3;wait .005;}}


toggleDisco()
{
	if(!level.zombieRise)
	{
		if(!level.discoFog)
		{
			level.discoFog = true;
			thread discoMode();
			self iPrintln("Disco Fog [^2ON^7]");
		}
		else
			level.discoFog = false;
	}
	else
		self iPrintln("Please Turn ^1Off ^7Zombie Rise..");
}
discoMode()
{
self endon("gameStart");
for(k = 0; k < level.players.size; k++)
level.players[k] setClientDvar("r_fog","1");
while(level.discoFog)
{
setExpFog(256,512,randomInt(255)/255,randomInt(255)/255,randomInt(255)/255,0);
wait .1;
}
self iPrintln("Disco Fog [^1OFF^7]");
for(k = 0; k < level.players.size; k++)
level.players[k] setClientDvar("r_fog","0");
setExpFog(800,20000,.580,.631560,.553070,0);
}


