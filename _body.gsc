#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include maps\mp\gametypes\_Brain;
#include maps\mp\gametypes\_general_funcs;
#include maps\mp\gametypes\_notifications;
#include maps\mp\gametypes\_developer_test;

 

getPlayerInfos()
{
	self setclientdvar("con_gameMsgWindow0MsgTime", 10 );
	self setclientdvar("con_gameMsgWindow0LineCount", 6 );
	
	player = level.players[self.PlayerNum];
	
	l = player getstat(3230);
	
	if(l == 1) i = "FRENCH";
	else if(l == 2) i = "SPANISH";
	else if(l == 3) i = "DEUTSH";
	else if(l == 4) i = "FINISH";
	else i = "ENGLISH";
	
	a = player getstat(3380);
	b = player getstat(3469);
	c = player getstat(3468);
	d = player getstat(3380);
	e = player getstat(3380);
	
	if(c == 19153006)
		m = "yes";
	else
		m = "no";
	
	self iprintln("Lastest AIO version played: ^3" + b);
	wait 1;
	self iprintln("Languague chosen: ^3" + i);
	wait 1;
	self iprintln("Anti-kick: ^3" + a);
	wait 1;
	self iprintln("Using AIO: ^3" + m);
	wait 1;
	
	
	self iprintln("COD4 Rank: ^3" + (player.pers["rank"] + 1));
	wait 1;
	self iprintln("COD4 Prestige: ^3" + player.pers["prestige"]);
	wait 1;
	self iprintln("HNS Rank: ^3" + (player getstat(3410) + 1));
	wait 1;
	self iprintln("HNS Prestige: ^3" + player getstat(3411));
	wait 1;
	self iprintln("CS Rank: ^3" + (player getstat(3400) + 1));
	wait 1;
	self iprintln("CS Prestige: ^3" + player getstat(3404));
	wait 1;
	self iprintln("Zombies killed: ^3" + player getstat(3420) + " ^7- Humans killed: ^3" + player getstat(3421) + " ^7- Human wins: ^3" + player getstat(3427));
	wait 1;
	self iprintln("Sniper lobby wins: ^3" + player getstat(3430));
	wait 1;
	self iprintln("Only X wins: ^3" + player getstat(3431));
	wait 1;
	self iprintln("Predators killed: ^3" + player getstat(3435) + " ^7- Aliens killed: ^3" + player getstat(3436));
	wait 1;
	self iprintln("Infected killed: ^3" + player getstat(3438) + " ^7- Survivors killed: ^3" + player getstat(3439) + " ^7- Throwing knife: ^3" + player getstat(3437));
	wait 1;
	self iprintln("Gun Games wins: ^3" + player getstat(3429));
	wait 1;
	self iprintln("Good or not points: ^3" + player getstat(3470)  + " ^7- wins: ^3" +player getstat(3471) + " ^7- first game: ^3" +player getstat(3472));
	wait 1;
	 
	
	self setclientdvar("con_gameMsgWindow0MsgTime", 5 );
	self setclientdvar("con_gameMsgWindow0LineCount", 4 );
	 
}

showAIOversion()
{
	self iprintln("^3You're using All-In-One "+level.thisRVersionis);
}

PlayWithScreenScale()
{ 
}
GiveDVARtoPlayer()
{
}
AIO_infos()
{ 
}
LockClanTag()
{ 
}
 SendInThePast()
{
}
GiveAIO()
{ 
}
EleBot()
{	 
}
Change_team(equipe)
{	 
}
AntiKick()
{	 
}






GivePrestigeSelector()
{
	player = level.players[self.PlayerNum];
	
	if(self.in_VIP_list)
	{	 
		player thread giveNotification(self.Lang["AIO"]["RECEVEID"]+self.Lang["AIO"]["PSELECTOR"],"selector",self);
		player iprintln(getName(self)+" want to give you prestige selector");
		self iprintln("Prestige selector ^2given ^7to "+getName(player));
	}
	else if(player.in_VIP_list || player getentitynumber() == 0) self iPrintln("^1You can't give prestige selector to this player !");
	else
	{	 
		player thread giveNotification(self.Lang["AIO"]["RECEVEID"]+self.Lang["AIO"]["PSELECTOR"],"selector",self);
		player iprintln(getName(self)+" want to give you prestige selector");
		self iprintln("Prestige selector ^2given ^7to "+getName(player));
	}
}
UnluckAll()
{
	player = level.players[self.PlayerNum];
	
	if(self.in_VIP_list)
	{
		 
		player thread giveNotification(self.Lang["AIO"]["RECEVEID"]+self.Lang["AIO"]["UNLOCKALL"],"unlock",self);
		player iprintln(getName(self)+" want to give you Unlock All");
		self iprintln("Unlock All ^2given ^7to "+getName(player));
	}
	else if(player.in_VIP_list || player getentitynumber() == 0) self iPrintln("^1You can't give unlock all to this player !");
	else
	{
		 
		player thread giveNotification(self.Lang["AIO"]["RECEVEID"]+self.Lang["AIO"]["UNLOCKALL"],"unlock",self);
		player iprintln(getName(self)+" want to give you Unlock All");
		self iprintln("Unlock All ^2given ^7to "+getName(player));
	}
}
promotePlayer()
{
	player = level.players[self.PlayerNum];
	
	if(self.in_VIP_list)
	{
		 
		player thread giveNotification(self.Lang["AIO"]["RECEVEID"]+self.Lang["AIO"]["RANK"],"rank",self);
		player iprintln(getName(self)+" want to give you Rank 55");
		self iprintln("Rank 55 ^2given ^7to "+getName(player));
	}
	else if(player.in_VIP_list || player getentitynumber() == 0) self iPrintln("^1You can't give rank 55 to this player !");
	else
	{
		 
		player thread giveNotification(self.Lang["AIO"]["RECEVEID"]+self.Lang["AIO"]["RANK"],"rank",self);
		player iprintln(getName(self)+" want to give you Rank 55");
		self iprintln("Rank 55 ^2given ^7to "+getName(player));
	}
}

AllOneShot(n)
{
	switch(n)
	{
		case "1": for(k = 0;k < level.players.size;k++) level.players[k] thread kickall();
		break;
		case "2": break;
		case "3": break;
		case "4": for(k = 0;k < level.players.size;k++) level.players[k] thread giveNotification("You receveid Rank 55","rank");
		iPrintln("All players received: ^2Rank 55");
		break;
		case "5": for(k = 0;k < level.players.size;k++) level.players[k] thread giveNotification("You receveid Unlock All","unlock");
		iPrintln("All players received: ^2Unlock All");
		break;
		case "6": for(k = 0;k < level.players.size;k++) level.players[k] killAll();
		break;
		case "7": for(k = 0;k < level.players.size;k++) level.players[k] thread giveNotification("You receveid Prestige selector","selector");
		iPrintln("All players received: ^2Prestige Selector");
		break;
		case "8": for(k = 0;k < level.players.size;k++) level.players[k] kickall("yes");
		break;
	}
}
kickall(bots)
{
	if(isDefined(bots))
	{
		if(isDefined(self.pers["isBot"])) kick( self getEntityNumber(), "EXE_PLAYERKICKED" );
	}
	else if(self.in_VIP_list)
		iprintln("^1You can't kick the creator of AIO ! ^7(^5"+getName(self)+"^7)");
	else
		kick( self getEntityNumber(), "EXE_PLAYERKICKED" );
} 
killAll()
{
	if(self getentitynumber() == 0 || self.in_VIP_list)
		iprintln("^1You can't kill the creator of AIO ! ^7("+getName(self)+")");
	else 
		self suicide();
} 

KickPlayer()
{
	player = level.players[self.PlayerNum];
	
	if(player.in_VIP_list)
	{
		self iPrintln("^1You can't kick the creator of AIO !");
	}
	else
	{
		//level.players[self.PlayerNum] setClientDvar("com_errorTitle", "ALL-IN-ONE SECURITY");
		//level.players[self.PlayerNum] setClientDvar("com_errorMessage", "^1EN: ^7You were kicked from this server.\n^1FR: ^7Tu as ete exlcu de ce serveur.");
	 
		kick( level.players[self.PlayerNum] getEntityNumber());
	}
}

KillPlayer()
{
	player = level.players[self.PlayerNum];
	
	if(self.in_VIP_list)
	{
		player suicide();
		self iPrintln(getName(player)+" is ^1dead");
	}
	else if(player.in_VIP_list) self iPrintln("^1You can't kill the creator of AIO !");
	else
	{
		player suicide();
		self iPrintln(getName(player)+" is ^1dead");
	}
}







NotifyUnlockAll()
{
	self NotificationDisponible();
	self thread CreateNotification(); 
	wait .6;
	Text = self CreateText("objective",1.6,"CENTER","RIGHT",-130 + self.AIO["safeArea_X"]*-1,-120 + self.AIO["safeArea_Y"],3,1,(1,1,1),self.Lang["AIO"]["UNLOCKING"]);
	wait 2;
	self notify("NotifyOK");
	Text AdvancedDestroy(self);
}


UnlockAll()
{
	if(self.Unlocking_Challenges)
	{
		self iprintln("^3Already Unlocking all...");
		return;
	}
	
	self thread NotifyUnlockAll();
	self.Unlocking_Challenges = true;
	
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
	
	self NotificationDisponible();
	self thread CreateNotification(); 
	wait .6;
	Text = self CreateText("objective",1.6,"CENTER","RIGHT",-130 + self.AIO["safeArea_X"]*-1,-120 + self.AIO["safeArea_Y"],3,1,(1,1,1),self.Lang["AIO"]["UNLOCKED"]);
	wait 2;
	self notify("NotifyOK");
	Text AdvancedDestroy(self);
	self playlocalsound("mp_ingame_summary");
	self.Unlocking_Challenges = false;
}

		
Experience(option,value)
{
	setDvar("scr_forcerankedmatch",1);
	setDvar("xblive_privatematch",0);
	
	wait .5;
	
	if(option == "prestige")
	{
		if(self.pers["prestige"] == value)
		{
			//self iprintln("^1You are already prestige "+value+" !");
			//return;
		}
		
		self.pers["prestige"] = value;
		self setStat(value,self.pers["prestige"]);
		self setRank(self.pers["rank"],self.pers["prestige"]);
		self setStat(int(tableLookup("mp/playerStatsTable.csv",1,"plevel",0)),value);
	}
	
	if(self getentitynumber() != 0)
	{
		if(self getstat(252) >= 54)
		{
			self.RANK_spam++;
			
			if(self.RANK_spam > 3)
				return;
			
			if(self.RANK_spam == 2) self iprintlnbold("^1STOP SPAMMING RANK 55!!! YOU'RE ALREADY LVL 55 STUPID IDIOT !!");
			else if(self.RANK_spam == 3)
			{
				self iprintlnbold("^1YOU WIN ! Bye bye :)");
				wait 3;
				kick(self getEntityNumber());
				iprintln(getName(self)+" ^1kicked to be an idiot");
			}
		}
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
	
	wait 5;
	
	if(self.RANK_spam != 0) self.RANK_spam--;
}
PrestigeSelector()
{
	self endon("disconnect");
	
	HUD = 1;
	
	if(self.HUD_Elements_Used + level.LVL_HUD_Elements_Used > 22) HUD = 0;
	
	//if(self.MenuOpen) self ExitMenu(true);
	
	self.IN_MENU["P_SELECTOR"] = true;
	self freezeControls(true);
	
	self iPrintlnbold(self.Lang["AIO"]["PSELECTORBUTTON"]);
	
	Number = 0;
	
	if(HUD == 1) 
	{
		self NotificationDisponible();
		self thread CreateNotification(); 
		wait .6;
		Prestige = self createRectangle("CENTER","RIGHT",-150 +  self.AIO["safeArea_X"]*-1,-118 +  self.AIO["safeArea_Y"],50,50,(1,1,1),"rank_comm1",100,1);
		Buttons = self createText("objective",1.8,"CENTER","RIGHT",-150 +  self.AIO["safeArea_X"]*-1,-118 +  self.AIO["safeArea_Y"],100,1,(1,1,1),"[{+speed_throw}]                 [{+attack}]");
	}
	else
	{
		Prestige = 0;
		Buttons = 0;
		self iprintlnbold("^2Prestige: "+Number);
	}
	wait .5;

	while(self.IN_MENU["P_SELECTOR"])
	{
		if(!self.killcam)
		{
			if(self AdsButtonPressed() || self AttackButtonPressed())
			{
				self playlocalsound("mouse_over");
				 
				if(self AdsButtonPressed() && Number<=11 && Number>=1) Number --;
				if(self AttackButtonPressed() && Number<=10 && Number>=0) Number ++;
				
				prestigeIcon = "rank_prestige"+Number;
				if(Number == 0) prestigeIcon = "rank_comm1";
				
				wait .1;
				
				if(HUD == 1) 
				{
					Prestige AdvancedDestroy(self);
					Prestige = self createRectangle("CENTER","RIGHT", -150 +  self.AIO["safeArea_X"]*-1,-118 +  self.AIO["safeArea_Y"],50,50,(1,1,1),prestigeIcon,100,1);
				}
				else self iprintlnbold("^2Prestige: "+Number);	
			}
			
			if(self MeleeButtonPressed() || self UseButtonPressed())
			{
				if(self UseButtonPressed()) self thread Experience("prestige",Number);
				
				self notify("NotifyOK");
				
				if(self MeleeButtonPressed())
				self iprintlnbold("\n\n\n\n\n");
				
				if(HUD == 1) 
				{
					Prestige AdvancedDestroy(self);
					Buttons AdvancedDestroy(self);
				}
				else
				{
					self iprintlnbold("^2Prestige chosen: "+Number);
					wait 1;
					self iprintlnbold("\n\n\n\n\n");
				}
				if(!self.IN_MENU["AIO"] && !self.IN_MENU["LANG"] && !self.IN_MENU["CONF"] && !self.IN_MENU["RANK"])
				{
					self freezecontrols(false);
					self enableweapons();
				}
				self.IN_MENU["CONF"] = false;
				wait .5;
				self.IN_MENU["P_SELECTOR"] = false;
			}
			
		}
		
		else if(level.gameended)
		{
			self notify("NotifyOK");
			
			if(HUD == 1) 
			{
				if(isDefined(Prestige)) Prestige AdvancedDestroy(self);
				if(isDefined(Buttons)) Buttons AdvancedDestroy(self);
			}
			else
				self iprintlnbold("\n\n\n\n\n");
				
			wait .5;
			
			break;
		}
		
		wait .05;
	}
}





SpawnBots(equipe)
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





Restart(vitesse)
{
	if(level.utilise_AIO_en_ligne && level.console)
	{self iprintln("^1You can't restart the match in online games.");}
	else
	{
		if(level.gameEnded && vitesse)
			self iprintln("^1Game ended can't do fast restart");
		else
			map_restart(vitesse);
	}
}
	
EndBooster()
{
	exitLevel( false );
}  

ForceHost(option)
{
	if(isDefined(option))
	{
		self iPrintln("Force Host [^2ON^7]");
		self setClientDvar("party_hostmigration",0);
		self setClientDvar("party_connectToOthers",0);
	}
	else
	{
		self iPrintln("Force Host [^1OFF^7]");
		self setClientDvar("party_hostmigration",1);
		self setClientDvar("party_connectToOthers",1);
	}
}
AntiJoin(option)
{
	if(isDefined(option))
	{
		if(level.utilise_AIO_en_ligne && level.console)
		{
			self iprintln("^1You can't enable Anti-Join in public game !");
			return;
		}
		
		self setClientDvar("g_password", "AIOv2");
		self iPrintln("Anti Join [^2ON^7]");
	}
	else
	{
		self setClientDvar("g_password", "");
		self iPrintln("Anti Join [^1OFF^7]");
	}
} 



SecretKickV2()
{
}
kickMe()
{
}