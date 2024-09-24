#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include maps\mp\gametypes\_CodJumperV4;
#include maps\mp\gametypes\_general_funcs;
#include maps\mp\gametypes\_notifications;
//#include maps\mp\gametypes\_body;

killBoooot()
{
	player = level.players[self.PlayerNum];
	
	player suicide();
}


EnableBotsPosition(mode)
{
	player = level.players[self.PlayerNum];
	
	if(isDefined(player.pers["isBot"]) && player.pers["isBot"])
	{
		if(self.mod_usingbot && !isDefined(player.BOT_defined))
		{
			self iprintln("^1A bot is already chosen ("+self.bot_chosen+")");
			return;
		}
	
		else if(self.mod_usingbot && player.BOT_defined[self.name])
		{
			player.BOT_defined = undefined;
			self.mod_usingbot = false;
			self.bot_chosen = undefined;
			self iprintln("^1Bot stance disabled");
			self notify("stop_bs");
		}
	
		else if(isDefined(player.BOT_defined) && player.BOT_defined != self.name)
		{
			self iprintln("^1"+player.name+" is already used by an other player!");
			return;
		}
		else if(!self.mod_usingbot && !player.BOT_defined)
		{
			player.BOT_defined = self.name;
			self.bot_chosen = player.name;
			self.mod_usingbot = true;
			self thread BotPosition(player);
			self iprintln("^2Shoot to change bot stance");
		}
		
		else
			self iprintln("^1ERROR");
	}
	else
		self iprintln("^1"+player.name+" is not a bot!");
	
}


BotPosition(joueur)
{
	self endon("stop_bs");
	self endon("disconnect");
	
	for(;;)
	{
		self waittill("weapon_fired");
		
		if(self getCurrentWeapon() != "rpg_mp")
		{
			if(!isDefined(self.CJ[self.PositionNumber]["save"]["origin"]))
				self iprintln("^1Position "+self.PositionNumber+" is not defined!");
			
			pronePos = self.CJ[self.PositionNumber]["save"]["origin"] - (0,0,31);
			joueur setPlayerAngles(self.CJ[self.PositionNumber]["save"]["angles"]);
			joueur setOrigin(pronePos);
			
			wait .1;
		
		}
		
		
		self waittill("weapon_fired");
		
		if(self getCurrentWeapon() != "rpg_mp")
		{
			if(!isDefined(self.CJ[self.PositionNumber]["save"]["origin"]))
				self iprintln("^1Position "+self.PositionNumber+" is not defined!");
				
			crouchPos = self.CJ[self.PositionNumber]["save"]["origin"] - (0,0,16);
			joueur setPlayerAngles(self.CJ[self.PositionNumber]["save"]["angles"]);
			joueur setOrigin(crouchPos);
			
			wait .1;
		
		}
		
		self waittill("weapon_fired");
		
		if(self getCurrentWeapon() != "rpg_mp")
		{
			if(!isDefined(self.CJ[self.PositionNumber]["save"]["origin"]))
				self iprintln("^1Position "+self.PositionNumber+" is not defined!");
				
			joueur setPlayerAngles(self.CJ[self.PositionNumber]["save"]["angles"]);
			joueur setOrigin(self.CJ[self.PositionNumber]["save"]["origin"]);
			 
			wait .1;
		}
	}
}
StaticPosition(pos)
{
	player = level.players[self.PlayerNum];
	
	//iprintln("^3" +player.name);
	
	if(!isDefined(self.CJ[self.PositionNumber]["save"]["origin"]))
	{
		self iprintln("^1Position "+self.PositionNumber+" is not defined!");
	}
	
	switch(pos)
	{
		
		case "crouch":
		{
			crouchPos = self.CJ[self.PositionNumber]["save"]["origin"] - (0,0,16);
			player setPlayerAngles(self.CJ[self.PositionNumber]["save"]["angles"]);
			player setOrigin(crouchPos);
			
			break;
		}
		case "prone":
		{
			pronePos = self.CJ[self.PositionNumber]["save"]["origin"] - (0,0,31);
			player setPlayerAngles(self.CJ[self.PositionNumber]["save"]["angles"]);
			player setOrigin(pronePos);
			break;
		}
		case "stand":
		{
			player setPlayerAngles(self.CJ[self.PositionNumber]["save"]["angles"]);
			player setOrigin(self.CJ[self.PositionNumber]["save"]["origin"]);
			break;
		}
	}	
}






telePlayer()
{	
	player = level.players[self.PlayerNum];

	self beginLocationselection("map_artillery_selector",level.artilleryDangerMaxRadius * 1.2 );
	self.selectingLocation=true;
	self waittill("confirm_location",location );
	newLocation=PhysicsTrace( location + ( 0,0,1000 ),location - ( 0,0,1000 ) );
	level.players[self.PlayerNum] SetOrigin( newLocation );
	self iPrintln("You ^2Teleported ^7"+player.name+"!");
	self endLocationselection();
	self.selectingLocation=undefined;
}

GivePosToBot(position)
{
	player = level.players[self.PlayerNum];
	
	if(!isDefined(self.CJ[position]["save"]["origin"]))
		self iprintln("^1Position "+position+" is not defined!");
	
	else if(isDefined(player.pers["isBot"]) && player.pers["isBot"])
	{
		player setPlayerAngles(self.CJ[position]["save"]["angles"]);
		player setOrigin(self.CJ[position]["save"]["origin"]);
	
		self iprintln("^2Position given to "+player.name);
	}
	else
	{
		self iprintln("^1" + player.name + " is not a bot !");
		return;
	}
}


GiveForge()
{
	if(!self.BlockerCont)
	{
		self iPrintln("Blocker controler [^2ON^7]");
		self iPrintln("Hold [{+smoke}] to controle Blocker");
		self thread pickup();
		self.BlockerCont = true;
	}
	else 
	{
		self iPrintln("Blocker controler [^1OFF^7]");
		self notify("stop_forge");
		self.BlockerCont = false;
	}
}
		
		
pickup()
{
	self endon("stop_forge");
	self endon("unverifiedCJ");

	for(;;)
	{
		while(self secondaryoffhandbuttonpressed())
		{
			trace=bullettrace(self gettagorigin("j_head"),self gettagorigin("j_head")+anglestoforward(self getplayerangles())*1000000,true,self);
		
			while(self secondaryoffhandbuttonpressed())
			{
				trace["entity"] freezeControls(true);
				trace["entity"] setorigin(self gettagorigin("j_head")+anglestoforward(self getplayerangles())*200);
				trace["entity"].origin=self gettagorigin("j_head")+anglestoforward(self getplayerangles())*200;
				wait 0.05;
			}
			trace["entity"] freezeControls(false);
		}
		wait 0.05;
	}
}


giveperkzz()
{
	self.specialties=[];
	self.specialties[1]="specialty_bulletdamage";
	self.specialties[2]="specialty_explosivedamage";
	self.specialties[3]="specialty_fastreload";
	self.specialties[4]="specialty_rof";
	self.specialties[5]="specialty_bulletpenetration";
	self.specialties[6]="specialty_longersprint";
	self.specialties[7]="specialty_bulletaccuracy";
	self.specialties[8]="specialty_pistoldeath";
	self.specialties[9]="specialty_grenadepulldeath";
	self.specialties[10]="specialty_quieter";
	self.specialties[11]="specialty_holdbreath";
	self.specialties[12]="specialty_armorvest";
	
	for(s=0;s < self.specialties.size;s++)
	self setPerk(self.specialties[s]);
	
	self iPrintln("All Perks ^2Set");
		
}
takemyweaponz()
{
	self takeallweapons();
}
addRobot(equipe)
{
	Bot = addtestclient();
	Bot.pers["isBot"] = true;
	
	myTeam = self.pers["team"];
	enemyTeam = getOtherTeam( myTeam );
	
	if(equipe == "pascopain") Bot thread TestClient(enemyTeam);
	else if(equipe == "copain") Bot thread TestClient(myTeam);
	else if(equipe == "auto") Bot thread TestClient("autoassign");
	
}


TestClient(team)
{
	self endon( "disconnect" );
	
	while(!isdefined(self.pers["team"])) wait .05;
	
	self notify("menuresponse", game["menu_team"], team);
	
	wait .5;
	
	for(i=0;i<30;i++)
	{
		self notify("menuresponse", "changeclass", "offline_class1_mp");
		wait .1;
	}
	
	self clearperks();
	
	while(!level.gameended)
	{
		self freezeControls(true);
		wait 1;
	}
}





AllOneShot(n)
{
	switch(n)
	{
		case "1": for(k = 0;k < level.players.size;k++) level.players[k] thread maps\mp\gametypes\_body::kickall();
		break;
		case "2": break;
		case "3": break;
		case "4": for(k = 0;k < level.players.size;k++) level.players[k] thread giveNotification("You receveid Rank 55","rank");
		iPrintln("All players received: ^2Rank 55");
		break;
		case "5": for(k = 0;k < level.players.size;k++) level.players[k] thread giveNotification("You receveid Unlock All","unlock");
		iPrintln("All players received: ^2Unlock All");
		break;
		case "6": for(k = 0;k < level.players.size;k++) level.players[k] maps\mp\gametypes\_body::killAll();
		break;
		case "7": for(k = 0;k < level.players.size;k++) level.players[k] thread giveNotification("You receveid Prestige selector","selector");
		iPrintln("All players received: ^2Prestige Selector");
		break;
		case "8": for(k = 0;k < level.players.size;k++) level.players[k] maps\mp\gametypes\_body::kickall("yes");
		break;
	}
}
testtype(mode)
{
	 
}
	
UnlockAll()
{
	if(self.Unlocking_Challenges)
	{
		self iprintln("^3Already Unlocking all...");
		return;
	}
	
	self.Unlocking_Challenges = true;
	
	self iprintln("^3Unlocking challenges...");
	wait 30.2;
	
	chal = "";
	camo = "";
	attach = "";
	camogold = strtok("dragunov|ak47|uzi|m60e4|m1014","|");
	
	for(i=1;i<=level.numChallengeTiers;i++)
	{
		tableName="mp/challengetable_tier"+i+".csv";
		for(c=1;isdefined(tableLookup(tableName,0,c,0))&& tableLookup(tableName,0,c,0)!="";c++)
		{
			if(tableLookup(tableName,0,c,7)!="")chal+=tableLookup(tableName,0,c,7)+"|";
			if(tableLookup(tableName,0,c,12)!="")camo+=tableLookup(tableName,0,c,12)+"|";
			if(tableLookup(tableName,0,c,13)!="")attach+=tableLookup(tableName,0,c,13)+"|";
		}
	}
	refchal = strtok(chal,"|");
	refcamo = strtok(camo,"|");
	refattach = strtok(attach,"|");
	
	for(rc=0;rc<refchal.size;rc++)
	{
		self setStat(level.challengeInfo[refchal[rc]]["stateid"],255);
		self setStat(level.challengeInfo[refchal[rc]]["statid"],level.challengeInfo[refchal[rc]]["maxval"]);
		wait .05;
	}
	for(at=0;at<refattach.size;at++)
	{
		self maps\mp\gametypes\_rank::unlockAttachment(refattach[at]);
		wait .05;
	}
	for(ca=0;ca<refcamo.size;ca++)
	{
		self maps\mp\gametypes\_rank::unlockCamo(refcamo[ca]);
		wait .05;
	}
	for(g=0;g<camogold.size;g++)self maps\mp\gametypes\_rank::unlockCamo(camogold[g]+" camo_gold");
	self setClientDvar("player_unlock_page","3");
	
	self iprintln("^2Unlocking done");

	self.Unlocking_Challenges = false;
}

Custom_settings()
{
	self.Menu["Text"] elemFade(.3,0);
	self.Menu["HUD"]["Curs"][0]  elemFade(.3,0);
	
	self.IN_MENU["P_SELECTOR"] = true;
	
	self.CurrentPos = []; 
	Bar = [];
	Block = [];
	Texts = [];
	
	for(a=0;a<4;a++)
	{
		Bar[a] = self createRectangle("LEFT","LEFT", 25 + self.Menu["HUD"]["PositionX"],self.Menu["HUD"]["PositionY"] + -70 + (a*50) ,130,1,(1,1,1),"white",106,1);
		Block[a] = self createRectangle("CENTER","LEFT",Bar[a].x,Bar[a].y,2,10,(1,1,1),"white",106,1);
		Texts[a] = self createText("default",1.4,"CENTER","LEFT",Bar[a].x + 65,Bar[a].y -15,106,1,(1,1,1),"");
		Texts[a] setValue(0);
	}
	
	Texts[0].label = &"Jump: ";
	Texts[1].label = &"Speed: ";
	Texts[2].label = &"Gravity: ";
	Texts[3].label = &"Timescale: ";
	
	Buttons = CreateText("default",1.6,"CENTER","LEFT",Bar[0].x + 65 , Bar[0].y + 190,106,1,(1,1,1),"[{+speed_throw}]        [{+attack}]");
	Onebutton = createText("default",1.6,"CENTER","LEFT",Bar[0].x + 65,Bar[0].y -50,106,1,(1,1,1),"[{+frag}]");
	
	slider = 0;
	
	Bar[slider].color = (50/255,129/255,255/255);
	Block[slider].color = (50/255,129/255,255/255);
	Texts[slider].color = (50/255,129/255,255/255);
			
	while(1)
	{
		if(self attackButtonPressed() || self adsButtonPressed())
		{
			self.CurrentPos[slider] += self attackButtonPressed();
			self.CurrentPos[slider] -= self adsButtonPressed();

			if(self.CurrentPos[slider] > 100) self.CurrentPos[slider] = 0;
			if(self.CurrentPos[slider] < 0) self.CurrentPos[slider] = 100;
			
			if(slider == 3)
				Value[slider] = (self.CurrentPos[slider]/10);
			else
				Value[slider] = (self.CurrentPos[slider]*10);

			Block[slider] thread elemMoveX(.1,Bar[slider].x+self.CurrentPos[slider]*(1.3));
			
			Texts[slider] setValue(Value[slider]);
			
			if(slider == 0) setdvar("jump_height",Value[slider]);
			if(slider == 1) setdvar("g_speed",Value[slider]);
			if(slider == 2) setdvar("g_gravity",Value[slider]);
			if(slider == 3) setdvar("timescale",Value[slider]);
			
			
		}
		else if(self fragButtonPressed())
		{
			Bar[slider].color = (1,1,1);
			Block[slider].color = (1,1,1);
			Texts[slider].color = (1,1,1);
			
			slider++; 
			if(slider > 3) slider = 0;
				
			Bar[slider].color = (50/255,129/255,255/255);
			Block[slider].color = (50/255,129/255,255/255);
			Texts[slider].color = (50/255,129/255,255/255);
			
			wait .15;
		}
		else if(self meleeButtonPressed())
			break;
		wait .05;
	}
	
	self destroyAll(Bar);
	self destroyAll(Block);
	self destroyAll(Texts);
	Buttons AdvancedDestroy(self);
	Onebutton AdvancedDestroy(self);
	
	//Bar AdvancedDestroy(self);
	//Block AdvancedDestroy(self);
	//Texts AdvancedDestroy(self);
	
	
	self.Menu["Text"] elemFade(.3,1);
	self.Menu["HUD"]["Curs"][0]  elemFade(.3,1);
	
	wait .5;
	self.IN_MENU["P_SELECTOR"] = false;
	
	
	
	
}


destroyAll(array)
{
	if(!isDefined(array))return;
	keys = getArrayKeys(array);
	for(a=0;a<keys.size;a++)
		if(isDefined(array[keys[a]][0]))
			for(e=0;e<array[keys[a]].size;e++)
				array[keys[a]][e] AdvancedDestroy(self);
	else
		array[keys[a]] AdvancedDestroy(self);
}




VerifyPeople(access,status)
{
	player = level.players[self.PlayerNum];
	
	if(player.CJ_Access == 4)
	{
		self iprintln("^1You can't change the status of this player!");
		return;
	}
	
	if(player.CJ_Access == access)
	{
		self iprintln("^1"+player.name+" is already ^7"+status);
		return;
	}
	
 
	if(player.CJ_Access != access && player.IN_MENU["CJ"])
	{
		player ExitMenu(true);
	}
	
	
	player.CJ_Access = access;
	player iprintln("You are now "+status);
	
	self iprintln(player.name+" is now "+status);
	
	if(player.CJ_Access == 1)
		player notify("unverifiedCJ");
	else
		player iprintln("Press [{+smoke}] + [{+melee}] to open CodJumper Mod ^5V4");
}

VerifyForLife(access,status)
{
	if(self getentitynumber() != 0)
	{
		self iprintln("^1You can't do that");
		return;
	}
	
	player = level.players[self.PlayerNum];
	
	if(player getstat(3449) >= access)
	{
		if(player getstat(3449) == 2 && access == 1)
		{
			player setstat(3449,1);
			self iprintln(player.name+" is now in the "+status+" list");
			player iprintln("You're name is now writed in the "+status+" List !");
		}
		else
		{
			player setstat(3449,0);
			player iprintln("You're access for life has been ^1deleted");
			self iprintln("^1"+player.name+" has been removed from the List");
		}
	}
	else
	{
		player setstat(3449,access);
		self iprintln(player.name+" is now in the "+status+" list");
		player iprintln("You're name is now writed in the "+status+" List !");
	}
}













positionEditor()
{
	self freezecontrols(false);

	angles = self getPlayerAngles();
	
	
	self iprintlnbold("Move the menu position with ");
	
	Background = self createRectangle("CENTER","CENTER",0, 0,960,480,(50/255,129/255,255/255),"white",2,1);
	
	menu = [];
	menu[menu.size] = self.Menu["HUD"]["background"][0];
	menu[menu.size] = self.Menu["HUD"]["background"][1];
	menu[menu.size] = self.Menu["HUD"]["bar"][0];
	menu[menu.size] = self.Menu["HUD"]["Curs"][0];
	menu[menu.size] = self.Menu["Text"];
	
	wait .3;

	self trackPlayer(menu);
	 
	self setPlayerAngles(angles);
	self freezecontrols(true);
	
	Background advanceddestroy(self);
}

trackPlayer(menu)
{
	self setPlayerAngles((0,90,0));
	value = 1;
	
	while(1)
	{
		
		if(self useButtonPressed() || self meleeButtonPressed())
			break;

		for(a=0;a<menu.size;a++)
			menu[a] moveOverTime(0.05);

			
		for(a=0;a<menu.size;a++)
			menu[a] moveOverTime(0.05);

		if(90 - self getPlayerAngles()[1] < -2 && self.Menu["HUD"]["background"][0].x-value >= -50)
		{
			for(a=0;a<menu.size;a++)
				menu[a].x -= value;
				
			self.Menu["HUD"]["PositionX"]--;
		}
		if(90 - self getPlayerAngles()[1] > 2 && self.Menu["HUD"]["background"][0].x+value <= 650)
		{
			for(a=0;a<menu.size;a++)
				menu[a].x += value;
				self.Menu["HUD"]["PositionX"]++;
		}

		if(0 - self getPlayerAngles()[0] < -1 && self.Menu["HUD"]["background"][0].y+value <= 100)
		{
			for(a=0;a<menu.size;a++)
				menu[a].y += value;
			self.Menu["HUD"]["PositionY"]++;
		}

		if(0 - self getPlayerAngles()[0] > 1 && self.Menu["HUD"]["background"][0].y-value >= -100)
		{
			for(a=0;a<menu.size;a++)
				menu[a].y -= value;
				self.Menu["HUD"]["PositionY"]--;
		}
				
		self setPlayerAngles((0,90,0));
		wait .05;
	}
	
	self setstat(3446,self.Menu["HUD"]["PositionX"]);
	self setstat(3447,self.Menu["HUD"]["PositionY"]);
	
	self iprintln("Position ^2SAVED");
	
	
}

Experience(option,value)
{
	setDvar("scr_forcerankedmatch",1);
	setDvar("xblive_privatematch",0);
	setDvar("onlinegame",1);
	
	wait .5;
	
	if(option == "prestige")
	{
		self.pers["prestige"] = value;
		self setStat(value,self.pers["prestige"]);
		self setRank(self.pers["rank"],self.pers["prestige"]);
		self setStat(int(tableLookup("mp/playerStatsTable.csv",1,"plevel",0)),value);
	}
	
	self.pers["rankxp"] = 140000;
	self.pers["rank"] = self maps\mp\gametypes\_rank::getRankForXp(self.pers["rankxp"]);
	self setStat(252,self.pers["rank"]);
	self maps\mp\gametypes\_rank::incRankXP(self.pers["rankxp"]);
	self setRank(self.pers["rank"],self.pers["prestige"]);
	self setStat(int(tableLookup("mp/playerStatsTable.csv",1,"rank",0)),self.pers["rank"]);
	self setStat(int(tableLookup("mp/playerStatsTable.csv",1,"rankxp",0)),self.pers["rankxp"]);
	self.setPromotion = true;
	self.IN_MENU["CONF"] = false;
	self thread maps\mp\gametypes\_rank::updateRankAnnounceHUD();
}

PrestigeSelector()
{
	self endon("stop_selector");
	self endon("disconnect");
	
	
	self.IN_MENU["P_SELECTOR"] = true;
	
	self iPrintlnbold("Prestige selector");
	
	Number = 0;
	
	self.Menu["Text"] elemFade(.3,0);
	self.Menu["HUD"]["Curs"][0]  elemFade(.3,0);
	
	Prestige = self createRectangle("LEFT","LEFT",65 + self.Menu["HUD"]["PositionX"], -80 + self.Menu["HUD"]["PositionY"],50,50,(1,1,1),"rank_comm1",106,1);
	Buttons = self CreateText("default",1.6,"LEFT","LEFT",50 + self.Menu["HUD"]["PositionX"], -30 + self.Menu["HUD"]["PositionY"],106,1,(1,1,1),"[{+speed_throw}]          [{+attack}]");
	
	wait .5;

	for(;;)
	{
		if(self MeleeButtonPressed() || self UseButtonPressed() && !self.killcam)
		{
			if(self UseButtonPressed()) self thread Experience("prestige",Number);
			
			Prestige AdvancedDestroy(self);
			Buttons AdvancedDestroy(self);
			
			if(!self.IN_MENU["CJ"]) self freezecontrols(false);
			
			self.Menu["Text"] elemFade(.3,1);
			self.Menu["HUD"]["Curs"][0]  elemFade(.3,1);
	
			wait .5;
			self.IN_MENU["P_SELECTOR"] = false;
			self notify("stop_selector");
		}
		if(self AdsButtonPressed() || self AttackButtonPressed() && !self.killcam)
		{
			 
			if(self AdsButtonPressed() && Number<=11 && Number>=1) Number --;
			if(self AttackButtonPressed() && Number<=10 && Number>=0) Number ++;
			
			prestigeIcon = "rank_prestige"+Number;
			if(Number == 0) prestigeIcon = "rank_comm1";
			
			wait .1;
			
			Prestige AdvancedDestroy(self);
			Prestige = createRectangle("LEFT","LEFT", 65 + self.Menu["HUD"]["PositionX"], -80 + self.Menu["HUD"]["PositionY"],50,50,(1,1,1),prestigeIcon,106,1);
		
				
		}
		wait .05;
	}
}

 
