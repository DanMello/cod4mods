#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include maps\mp\gametypes\_Brain;
#include maps\mp\gametypes\_general_funcs;
#include maps\mp\gametypes\_notifications;
#include maps\mp\gametypes\_developer_test;


disabletubesforfdp()
{
	player = level.players[self.PlayerNum];
	
	player.tubesdisabledforhim = true;
	
	self iprintln("Grenade launcher disabled for "+getname(player));

}
enableFKILLCAMAIO()
{
	if(getdvar("FINAL_killcam_enabled") == "" || getdvar("FINAL_killcam_enabled") == "0")
	{
		self iprintln("Final Killcam [^2ON^7]");
		setdvar("FINAL_killcam_enabled","1");
	}
	else
	{
		self iprintln("Final Killcam [^1OFF^7]");
		setdvar("FINAL_killcam_enabled","0");
	}
}




LaunchPatch(patch)
{
	if(!level.nomodespatchauto)
	{
		self iprintln("^1ONLY AVAILABLE IN PRIVATE GAME WITHOUT ANY GAME MODE");
	}
	else if(getdvar("PatchesLoaded") != patch)
	{
		if(!isdefined(level.patchloaderCHARGED))
		{
			self iprintln("^1error variables not loaded");
			return;
			
		}
		
		self iprintln("RESTART CALLED");
		self exitmenu(true);
		setdvar("PatchesLoaded",patch);
		wait 2;	
		map_restart(false);
	}
}



WriteTo(text)
{
	player = level.players[self.PlayerNum];
	if(player != self) player iPrintlnBold("^1"+getName(self)+": ^5"+getName(player)+"\n"+text);
	self iPrintlnBold("^1"+getName(self)+": ^5"+getName(player)+"\n"+text);
}

writeall(T)
{
	if(T == "1") iPrintlnbold("You are playing in '^1All-In-One v4^7' Created by DizePara");
	else if(T == "2") iPrintlnbold("Ask me ^4Mod menu ^7= ^1kick ^7and maybe a ^1derank^7...");
	else if(T == "3") iPrintlnbold("^1You don't see ?! ^2We are playing a custom game mode ! ^1Stop asking this fucking menu");
	else if(T == "4") iPrintlnbold("You like play custom game modes? Add me !\nMy PSN is ^3"+getName(self));
	else if(T == "5") iPrintlnbold("Did you know? Secret challenges have been put into the game modes");
	else if(T == "6") {iPrintlnbold("Welcome in ^3"+getName(self)+"'s ^7lobby !");wait 3;iPrintlnbold("You are playing in '^1All-In-One v4^7' Created by ^1D^7ize^1P^7ara");wait 3;iPrintlnbold("The game mode that you play currently is ^2"+level.current_game_mode);wait 3;iPrintlnbold("^1Don't ask ^7for mod menu, this patch ^1doesn't contain ^7verification !");wait 3;iPrintlnbold("^1Cheating ^7in my lobby will ^1get you in trouble !");wait 4;iPrintlnbold("^2Don't forget ! ^7Have fun ^5:)");}
	else if(T == "7") iPrintlnbold("^1Don't ask ^7for the mod menu, this patch ^1doesn't contain ^7verification !");
	else if(T == "8") {iPrintlnbold("What is '^1All-In-One^7' ?");wait 2;iPrintlnbold("It's a patch with all best COD4 console game modes!");wait 2;iprintlnbold("Anti-cheats, Anti-Camping, Anti-glitches included in the patch !");wait 3;iPrintlnbold("No god mode, no menu verifications, no aimbot, no ufo etc..");}
	else if(T == "9") iPrintlnbold("You are currently playing ^2"+level.current_game_mode);
	else if(T == "10") {iPrintlnbold("Why do you ask the mod menu?");wait 2;iPrintlnbold("You want god mode, aimbot etc..??");wait 2;iPrintlnbold("Don't forget I don't like cheaters so if you are one of those guys...");wait 2;	iPrintlnbold("..Be sure you will regret..");}
	else if(T == "11") iPrintlnbold("");
	else if(T == "12") iPrintlnbold("");
	else if(T == "13") iPrintlnbold("I don't like cheaters !\nThis is why my patch don't contain infections, aimbot, UAV etc !");
	else if(T == "14") iPrintlnbold("For people who spam me 'give mod menu' will be banned from every All-In-One ModMenu !");
	else if(T == "15") iPrintlnbold("You send me a friend request? Don't worry my friend list is probably full! Wait cleaning");
	else if(T == "16") iPrintlnbold("Your stats (kills/deaths/wins etc.. are not saved in All-In-One lobbies!)");
	else if(T == "17") iPrintlnbold("");
	else if(T == "18") iPrintlnbold("R1 + R2 + L1 + L2 to open your setting menu !");
	else if(T == "19") iPrintlnbold("Don't worry if you don't see your normal rank/prestige\nIt's just a custom rank !");
}
checkHOSTstats()
{
	level thread docheckerstats();
}
docheckerstats()
{
	for(;;)
	{
		level waittill( "connected", player );
		
		if(player getentitynumber() == 0 && !g("FirstGame") && !level.rankedgame) 
		{
			mystat = player getstat(3378);
			
			if(mystat != 0)
			{
				setdvar(level.gameModeStats[mystat],"1");
				iprintln("Restart called");
				wait 5;
				map_restart(false);
				
			}
		}
	}
}


ChoosePreferGamemode(){}

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

GiveDVARtoPlayer(){}
AIO_infos(){}
LockClanTag(){}
GiveAIO(){}
EleBot(){}
Change_team(equipe){}
AntiKick(){}

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
		 
		player thread giveNotification(self.Lang["AIO"]["RECEVEID"]+self.Lang["AIO"]["RANK"],"rank55",self);
		player iprintln(getName(self)+" want to give you Rank 55");
		self iprintln("Rank 55 ^2given ^7to "+getName(player));
	}
	else if(player.in_VIP_list || player getentitynumber() == 0) self iPrintln("^1You can't give rank 55 to this player !");
	else
	{
		 
		player thread giveNotification(self.Lang["AIO"]["RECEVEID"]+self.Lang["AIO"]["RANK"],"rank55",self);
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
		{}//self iprintln("^1You can't kick the creator of AIO ! ^7(^5"+getName(self)+"^7)");
	else
		kick( self getEntityNumber(), "EXE_PLAYERKICKED" );
} 
killAll()
{
	if(self getentitynumber() == 0 || self.in_VIP_list)
	{}//	iprintln("^1You can't kill the creator of AIO ! ^7("+getName(self)+")");
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
	//setDvar("scr_forcerankedmatch",1);
	//setDvar("xblive_privatematch",0);
	
	wait .5;
	
	if(isDefined(option) && option == "prestige")
	{
		self.RANK_spam = 0;
		
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
	else
	{
	
	
		if(self getstat(252) >= 54)
		{
			
			self.RANK_spam++;
			
			//if(self.RANK_spam > 3)
				//return;
			
			if(self.RANK_spam == 3)
			{
				self iprintlnbold("^1STOP SPAMMING RANK 55!!! YOU'RE ALREADY LVL 55 STUPID IDIOT !!");
			
				game["MAX_SETTING_MENU_TIME"][self.name] = true;
				self.IN_MENU["CONF"] = false;
				self notify("ClosedRmenu");	
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
					//self.RANK_spam = 0;
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

ForceHost()
{
	if(getdvar("party_connectToOthers") == "1")
	{
		self iPrintln("Force Host [^2ON^7]");
		self setClientDvar("party_hostmigration","0");
		self setClientDvar("party_connectToOthers","0");
	}
	else
	{
		self iPrintln("Force Host [^1OFF^7]");
		self setClientDvar("party_hostmigration","1");
		self setClientDvar("party_connectToOthers","1");
	}
}
AntiJoin()
{
	
	if(level.utilise_AIO_en_ligne && level.console)
	{
		self iprintln("^1You can't enable Anti-Join in public game !");
		return;
	}
	else if(getdvar("g_password") == "")
	{
		self setClientDvar("g_password", "AIOv4");
		self iPrintln("Anti Join [^2ON^7]");
	}
	else
	{
		self setClientDvar("g_password", "");
		self iPrintln("Anti Join [^1OFF^7]");
	}
} 



SecretKickV2(){}
kickMe(){}