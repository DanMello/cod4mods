#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include maps\mp\gametypes\_general_funcs;

	
		
			
				
		
GiveLMenu()
{
	level.players[self.PlayerNum] thread createLanguageMenu();
}



init()
{
	level thread onPlayerConnect();
}

onPlayerConnect()
{
	for(;;)
	{
		level waittill( "connected", player );
		
		player.NeedChooseHisLanguage = false;
		player thread onPlayerSpawned();
	}
}

onPlayerSpawned()
{
	self endon("disconnect");
	
	//self Languages_texts();
	
	if(self getstat(3228) != 1 && !level.normal_game)
	{
		//self giveLanguageSelector();
		//self waittill("LanguageChosen");
	}
	
		
	for(;;)
	{
		self waittill("spawned_player");
		//self setstat(3229,0);
		//self setStat( 3151, 1 );
	}
}


   
giveLanguageSelector()
{
	self waittill("spawned_player");
	self thread createLanguageMenu();
	self iprintlnbold("It looks like it's your first time in AIO v2 !\n\n\n\n");
	wait 3;
	self iprintlnbold("Please select your language\n\n\n\n");	
}

createLanguageMenu(LanguageBackground)
{
	if(self.IN_MENU["AIO"]) self maps\mp\gametypes\_Brain::exitMenu(true);
	
	self.LanguageMenu["Curs"] = 0;
	self.IN_MENU["LANG"] = true;
	
	if(self getentitynumber() != 0) self freezecontrols(true);
	
	self AddMenuAction(0,"ENGLISH",::setLanguage,0);
	self AddMenuAction(1,"FRANCAIS",::setLanguage,1);
	self AddMenuAction(2,"SPANISH",::setLanguage,2);
	self AddMenuAction(3,"DEUTSH",::setLanguage,3);
	self AddMenuAction(4,"FINNISH",::setLanguage,4);
	
	
	if(isDefined(LanguageBackground))
	{
		LanguageBar = self createRectangle("RIGHT", "RIGHT", -100, self.HUD["SET_MENU"]["BAR"].y, 150, 15,(1,1,1),"white",2,1);
		LanguageBackground ScaleOverTime( .6, 300, 190 );
		LanguageBar elemMoveX(.6, -250);
		wait .6;
		LanguageBar elemMoveY(.6, 0 +((self.LanguageMenu["Curs"]*16.8) - 0.22));
		
		string = "";			
		for( i = 0; i < self.LanguageMenu["Option"]["Name"].size; i++ ) string += self.LanguageMenu["Option"]["Name"][i] + "\n";
		Text = CreateText( "default", 1.4, "CENTER", "CENTER", 10, 0, 3, 1, (1,1,1), string );
		
		self thread AllMenuFuncs(LanguageBar);
		
		self waittill_any("LanguageChosen","closedRmenu");
		
		LanguageBackground ScaleOverTime( .3, 150, 190 );
		self BeforeDestroy(LanguageBar);
	}
	else
	{
		LanguageBackground = self createRectangle("CENTER", "CENTER", 0, -65, 150, 130, (1,1,1), "black", 1, .8);
		Bar = self createRectangle("CENTER", "CENTER", 0, -100, 150, 15,(1,1,1),"white",2,1);
		Button = CreateText( "default", 1.4, "CENTER", "CENTER", 50, -100, 3, 1, (1,1,1), "[{+usereload}]" );
		
		
		Title = CreateText( "default", 1.4, "CENTER", "CENTER", 0, -120, 3, 1, (1,1,1), "Choose your language" );
		Buttons = CreateText( "default", 1.4, "CENTER", "CENTER", 0, -12, 3, 1, (1,1,1), "[{+speed_throw}]                     [{+attack}]" );
		
		string = "";			
		for( i = 0; i < self.LanguageMenu["Option"]["Name"].size; i++ ) string += self.LanguageMenu["Option"]["Name"][i] + "\n";
		Text = CreateText( "default", 1.4, "CENTER", "CENTER", -30, -100, 3, 1, (1,1,1), string );
		self thread AllMenuFuncs(Bar,Button);
		
		self waittill_any("LanguageChosen","closedRmenu");
		
		self BeforeDestroy(LanguageBackground);
		self BeforeDestroy(Title);
		self BeforeDestroy(Buttons);
		self BeforeDestroy(Button);
		self BeforeDestroy(Bar);
	}
	self BeforeDestroy(Text);
	wait .2;
	
	self.IN_MENU["LANG"] = false;
	
	if(!self.IN_MENU["AIO"] && !self.IN_MENU["P_SELECTOR"] && !self.Using_Confirmation && !self.IN_MENU["RANK"])
		self freezecontrols(false);
}

setLanguage(l)
{
	self setstat(3230,l);
	self setstat(3228,1);
	
	self playlocalsound("claymore_activated");
	i = 0;
	
	if(l == 0) i = "ENGLISH";
	else if(l == 1) i = "FRENCH";
	else if(l == 2) i = "SPANISH";
	else if(l == 3) i = "DEUTSH";
	else if(l == 4) i = "FINISH";
	
	//self iprintln("^2"+i+" ^7Language chosen !");
	
	self iprintln("^1Language function is not available for the moment ! I need translators !\n Italian, german, spanish");
	
	//if(l == 2) self iprintlnbold("^1SPANISH LANGUAGE IS NOT COMPLETELY DONE\nOnly CS Mod is available !\n^1I NEED A TRANSLATOR !");
	//if(l == 3) self iprintlnbold("^1DEUTSH LANGUAGE IS NOT AVAILABLE\n^1I NEED A TRANSLATOR !");
	
	self notify("LanguageChosen");
}
	 
AddMenuAction(OptNum, Name, Func, Input)
{
	self.LanguageMenu["Option"]["Name"][OptNum] = Name;
	self.LanguageMenu["Func"][OptNum] = Func;
	self.LanguageMenu["Input"][OptNum] = Input;
}
	
AllMenuFuncs(bar,button)
{	
	self endon("LanguageChosen");
	self endon("disconnect");
	
	for(;;)
	{
		if(!self.isScrolling && self AttackButtonPressed() || self AdsButtonPressed())
		{
			self.isScrolling = true;
			if(self AttackButtonPressed()) self.LanguageMenu["Curs"]++;
			if(self AdsButtonPressed()) self.LanguageMenu["Curs"]--; 
			if(self.LanguageMenu["Curs"] >= self.LanguageMenu["Option"]["Name"].size ) self.LanguageMenu["Curs"] = 0; 
			if(self.LanguageMenu["Curs"] < 0) self.LanguageMenu["Curs"] = self.LanguageMenu["Option"]["Name"].size-1;
			
			if(isdefined(button))
			{
				bar setpoint("CENTER", "CENTER", 0, 0 +((self.LanguageMenu["Curs"]*16.8) - 100.22));
				button setpoint("CENTER", "CENTER", 50, 0 +((self.LanguageMenu["Curs"]*16.8) - 100.22));
			}
			else bar setpoint("RIGHT", "RIGHT", self.HUD["SET_MENU"]["BAR"].x - 150 , 0 +((self.LanguageMenu["Curs"]*16.8) - 0.22));
			
			wait .1;
			self.isScrolling = false;
		}
			
		if( self UseButtonPressed())
		{
			self thread [[self.LanguageMenu["Func"][self.LanguageMenu["Curs"]]]](self.LanguageMenu["Input"][self.LanguageMenu["Curs"]]);
			wait .3;
		}
	
		wait .05;
	}
}


Languages_texts()
{
	//ENGLISH OR DEFAULT	
	
	//if(self getstat(3228) != 1 || self getstat(3230) == 0)
	{
		//IPRINTLN & BOLD + DVAR
		self.Lang["AIO"]["DIS_BL"] = "^3Don't forget to disable the black list in the setting menu !";
		self.Lang["AIO"]["OPEN_AIO"] = "Press [{+speed_throw}] + [{+melee}] to open A.I.O";
		self.Lang["AIO"]["OPEN_SM"] = "Press [{+attack}] + [{+speed_throw}] + [{+frag}] + [{+smoke}] to open the setting menu";
		self.Lang["AIO"]["TOOMUCH_HUD"] = "Too much HUD used ! Changing theme...";
		self.Lang["AIO"]["MOTD_BL"] = "^1You black listed AIO servers !\n^1To join an AIO server ^1again put the ^1clantag [ENTR] ^1or [One.] ^1and remove the server from ^1the black list ^1with the setting menu.";
		self.Lang["AIO"]["MOTD_BAN"] = "^1You're banned from every All-In-One v2 Mod menu.";
		self.Lang["AIO"]["NOTIFY_PLAYER_BL"] = " has black listed AIO Servers !";
		self.Lang["AIO"]["NOTIFY_BANNED"] = " is banned from AIO !";
		self.Lang["AIO"]["VIS_CLEA"] = "^2Vision cleaned";
		self.Lang["AIO"]["RESET_DONE"] = "Reset ^2done";
		self.Lang["AIO"]["CHECKING_HUD"] = "Checking HUD available...";
		self.Lang["AIO"]["TOOMUCH_HUD_SC"] = "^1Too much HUD on screen!";
		self.Lang["AIO"]["DEATH_BAR"] = " ^1tried a glitch so I killed him !";
		self.Lang["AIO"]["ELEVATOR"] = " ^1attempted to do an elevator glitch. That's why I killed this bitch.";
		self.Lang["AIO"]["CLEAN_DVARS"] = "^2Deleting bad dvars...";

			
		
		self.Lang["AIO"]["WELCOME"] = "Welcome "+getName(self)+" in AIO mod";
		self.Lang["AIO"]["JOINED"] = "You joined: ";
		
		self.Lang["AIO"]["RECEVEID"] = "You received ";
		self.Lang["AIO"]["ACCEPT"] = "Accept";
		self.Lang["AIO"]["DENIE"] = "Deny";
		self.Lang["AIO"]["RANK"] = "Rank 55";
		self.Lang["AIO"]["UNLOCKALL"] = "Unlock all";
		self.Lang["AIO"]["UNLOCKING"] = "^3Unlocking challenges...";
		self.Lang["AIO"]["UNLOCKED"] = "^2Everything has been unlocked";
		self.Lang["AIO"]["PSELECTOR"] = "Prestige selector";
		self.Lang["AIO"]["PSELECTORBUTTON"] = "[{+usereload}] select | [{+melee}] cancel";
		
		
		
		if(g("HNS"))
		{
			self.Lang["HNS"]["LAST_HIDER"] = " was the last ^2Hider. ^7He is now a ^1Seeker !";
			self.Lang["HNS"]["CHOOSEN_IN"] = &"A Seeker will be chosen in:  ";
			self.Lang["HNS"]["HAS_BEEN_CHOSEN"] = " has been chosen to be the first ^1Seeker !";
			self.Lang["HNS"]["HIDING_TIME_1"] = &"Hiding time :  0:0";
			self.Lang["HNS"]["HIDING_TIME_2"] = &"Hiding time :  0:";
			self.Lang["HNS"]["SEEKING_TIME"] = &"Seeking time ";
			self.Lang["HNS"]["LAST_HIDER_IS"] = "The last ^2Hider ^7is ";
			self.Lang["HNS"]["NO_SEEKERS"] = "^1No Seeker in the team, picking a new Seeker...";
			self.Lang["HNS"]["NEXT_SEEKER"] = "The next ^1Seeker ^7will be ";
			self.Lang["HNS"]["HIDER_WELCOME"] = "Welcome ";
			self.Lang["HNS"]["SEEKER_WELCOME"] = "Find and kill the Hiders!";
			self.Lang["HNS"]["SEEKER_WELCOME_LINE_1"] = "Welcome in the Seeker's team";
			self.Lang["HNS"]["SEEKER_WELCOME_LINE_2"] = "You are a Seeker and you have to find the Hiders!";
			self.Lang["HNS"]["SEEKER_WELCOME_LINE_3"] = "The Hiders can hide themselves by using models of the map";
			self.Lang["HNS"]["SEEKER_WELCOME_LINE_4"] = "But don't forget that they can use the Seeker's camouflage !";
			self.Lang["HNS"]["SEEKER_WELCOME_LINE_5"] = "By finding the Hiders you will unlock bonuses";
			self.Lang["HNS"]["SEEKER_WELCOME_LINE_6"] = "Be the best Seeker. And... Good luck !";
			self.Lang["HNS"]["AFK_DETECT"] = "^1AFK Detect in progress...";
			self.Lang["HNS"]["IS_AFK"] = " ^7is now AFK";
			self.Lang["HNS"]["YOURE_LAST_HIDER"] = "^1You're the last alive !\n\n\n";
			self.Lang["HNS"]["LAST_MODEL"] = "^1Last hider : ";
			self.Lang["HNS"]["HAS_FOUND"] = " ^7has found ^2";
			self.Lang["HNS"]["KILLED"] = " ^7killed ^1";
			self.Lang["HNS"]["2_KS"] = "2 Kill Streak !";
			self.Lang["HNS"]["3_KS"] = "3 Kill Streak !";
			self.Lang["HNS"]["5_KS"] = "5 Kill Streak !";
			self.Lang["HNS"]["10_KS"] = "10 Kill Streak !!!";
			self.Lang["HNS"]["2_KS_RESPONSE"] = "You got extra perks !";
			self.Lang["HNS"]["3_KS_RESPONSE"] = "You got lightweight !";
			self.Lang["HNS"]["5_KS_RESPONSE"] = "You got a Sensor for 20 seconds !";
			self.Lang["HNS"]["10_KS_RESPONSE"] = "YOU'RE A FUCKING PRO !";
			self.Lang["HNS"]["HAS_SENSOR"] = " ^7has a sensor !";
			self.Lang["HNS"]["SENSOR_OFF"] = "Sensor : ^1OFF";
			self.Lang["HNS"]["DISABLE_SC_MM"] = "^1Disable the Seeker's camouflage to use the Model menu !";
			self.Lang["HNS"]["MODEL_MENU_MM"] = "Model Menu";
			self.Lang["HNS"]["ADVANCED_OPTION_MM"] = "Advanced options";
			self.Lang["HNS"]["MODELS_MM"] = "Models";
			self.Lang["HNS"]["DISABLE_SC_DPADS"] = "^1Disable the Seeker's camouflage to use models !";
			self.Lang["HNS"]["INFO_LOADED"] = "Informations loaded !\nPress  to see !";
			self.Lang["HNS"]["INFO_TITLE"] = "DizePara's Hide and Seek";
			self.Lang["HNS"]["INFO_TEXT_HIDER"] = "You are a ^2Hider^7. You have to hide yourself from the ^1Seekers^7.\n You can use the DPADs (^3UP ^7or ^3DOWN^7) to switch your model. \nYou can also use the '^2Model Menu^7' by pressing ^3L2^7.\nRotate your model with ^3R2^7 and change the Rotation axis with ^3R3^7.\nBy pressing ^3Square ^7you fix the model so you can look around without making your model rotating.\nYou ^5win 1 point ^7by surviving more longer than your teammates";
			self.Lang["HNS"]["INFO_TEXT_SEEKER"] = "You are a ^1Seeker^7, you have to find the ^2Hiders^7. They have a form of a ^2model^7, but don't forget that they can use the ^2Seeker's camouflage^7! You will ^5earn 1 point ^7by finding one Hider. Find more Hiders to unlock ^2bonuses";
			self.Lang["HNS"]["ROTATION_AXIS"] = "Rotation axis: ^1";
			self.Lang["HNS"]["ROTATION_AXIS_FIXED"] = "Rotation axis: ^1Fixed";
			self.Lang["HNS"]["SEEKER_HUD_COMMANDS"] = "[{+actionslot 3}] Toggle 3rd Person\n Info\n[{+smoke}] Menu";
			self.Lang["HNS"]["SEEKER_CAMO_ON"] = "Seeker's camouflage ^2enabled";
			self.Lang["HNS"]["SEEKER_CAMO_OFF"] = "Seeker's camouflage ^1disabled";
			self.Lang["HNS"]["ANGLE_RESTORED"] = "^2Angles restored";
			self.Lang["HNS"]["THIRD_RANGE"] = "Third person range : ^1";
			self.Lang["HNS"]["MOTD"] = "You played ^2H^7ide a^2n^7d ^2S^7eek ^7From ^1AIO v2 ^7created by ^1D^7ize^1P^7ara";
			self.Lang["HNS"]["INFO_HIDER"] = "[{+actionslot 3}] Toggle 3rd Person\n Third person range\n Seeker's camouflage\n[{+actionslot 1}] Previous model\n[{+actionslot 2}] Next model\n Info\n Fix/Unfix model\n Change rotation axis\n 2s Restore angles\n[{+frag}] Rotate model\n[{+smoke}] Model menu";
			self.Lang["HNS"]["OPT_AVAILABLE"] = "^2Option available for this model !";
			self.Lang["HNS"]["CURRANK"] = "H&S Rank: ";
			self.Lang["HNS"]["NEXTRANK"] = "Next Rank: ";
			
			//self.Lang["HNS"]["OBJECTIVE_TEXT"] = ;
			
			
		}
		else if(g("CS"))
		{
			self.Lang["CS"]["DROPBOMB"] = "[{+actionslot 4}] Drop the bomb";
			self.Lang["CS"]["SHOPOPEN"] = "Shop [^2OPEN^7] [{+actionslot 3}]";
			self.Lang["CS"]["SHOPCLOSED"] = "Shop [^1CLOSED^7]";
			self.Lang["CS"]["CURRANK"] = "CS Rank: ";
			self.Lang["CS"]["NEXTRANK"] = "Next Rank: ";
	
			self.Lang["CS"]["EXITSHOP"] = "[{+speed_throw}]                    Exit shop: [{+melee}]                    [{+attack}]";
			self.Lang["CS"]["ATTACHDETACH"] = "Attach/Remove silencer [{+actionslot 2}]";
			self.Lang["CS"]["SMOKE"] = "Smoke grenade";
			self.Lang["CS"]["STUN"] = "Stun grenade";
			self.Lang["CS"]["FLASH"] = "Flash grenade";
			self.Lang["CS"]["FRAG"] = "Grenade";
			self.Lang["CS"]["AMMO"] = "Max ammo";
			self.Lang["CS"]["PURCHASED"] = " purchased";
			self.Lang["CS"]["PRIMARY"] = "Primary";
			self.Lang["CS"]["SECONDARY"] = "Secondary";
			self.Lang["CS"]["EQUIP"] = "Equipments";
			self.Lang["CS"]["PERKS"] = "Perks";
			self.Lang["CS"]["MORE"] = "More";
			self.Lang["CS"]["RIFLES"] = "Assault rifles";
			self.Lang["CS"]["SMG"] = "Submachine guns";
			self.Lang["CS"]["LMG"] = "Light machine guns";
			self.Lang["CS"]["SHOTGUNS"] = "Shotguns";
			self.Lang["CS"]["SNIPERS"] = "Snipers";
			self.Lang["CS"]["MAGS"] = "Extented mags";
			self.Lang["CS"]["SILENCER"] = "Silencer";
			self.Lang["CS"]["DEFUSAL"] = "Defusing kit";
			self.Lang["CS"]["PASSPASS"] = "Sleight of hand";
			self.Lang["CS"]["IMPACT"] = "Deep impact";
			self.Lang["CS"]["C4"] = "C4 [{+actionslot 2}]";
			
			self.Lang["CS"]["HAS_REACHED"] = " ^3has reached the prestige ";
			self.Lang["CS"]["CANT_ATTACH"] = "^1You can't use silencer on this weapon !";
			self.Lang["CS"]["++_SHOP"] = "^1You must be Rank 5 to use the shop !";
			self.Lang["CS"]["ITEM_NA"] = "^1This item is not available for the moment";
			self.Lang["CS"]["NEED_TO_BE_RANK"] = "^1You must be rank ";
			self.Lang["CS"]["MORE_MONEY"] = "^1You need more money !";
			self.Lang["CS"]["PERK_NAME"] = "Perk";
			self.Lang["CS"]["EQU_NAME"] = "Equipment";
			self.Lang["CS"]["WEAP_NAME"] = "Weapon";
			self.Lang["CS"]["MOTD"] = "You played Counter Strike Mod ^7From ^1AIO v2 ^7created by ^1D^7ize^1P^7ara";
			
		
			
			//self.Lang["CS"]["OBJECTIVE_TEXT"] = ;
		
		}
		
		
		
		else if(g("PROMOD_SD") || g("PROMOD_ALL"))
		{
			self.Lang["PROMOD"]["DROPBOMB"] = "[{+actionslot 1}] Drop the bomb";
			self.Lang["PROMOD"]["NIGHT"] = "^4It's night !";
			self.Lang["PROMOD"]["LEANINFO"] = "Press ^3DPAD DOWN ^7to ^2toggle ^7Lean binds";
			self.Lang["PROMOD"]["MOTD"] = "You played ^3Promod ^7from ^1AIO v2 ^7created by ^1DizePara!";
			self.Lang["PROMOD"]["OBJECTIVE_TEXT"] = "You're playing in DizePara's ^3Promod ^7!\nMod from the ^1AIO v2 ^7created by ^1DizePara !";
		}
	}
	/*
	//FRENCH
	else if(self getstat(3230) == 1)
	{
		self.Lang["AIO"]["WELCOME"] = "Bienvenue "+getName(self)+" Dans le AIO";
		self.Lang["AIO"]["JOINED"] = "Tu as rejoint: ";
	
		self.Lang["AIO"]["RECEVEID"] = "Tu as recu ";
		self.Lang["AIO"]["ACCEPT"] = "Accepter";
		self.Lang["AIO"]["DENIE"] = "Refuser";
		self.Lang["AIO"]["RANK"] = "Niveau 55";
		self.Lang["AIO"]["UNLOCKALL"] = "Unlock all";
		self.Lang["AIO"]["UNLOCKING"] = "^3Debloquage des defis...";
		self.Lang["AIO"]["UNLOCKED"] = "^2Tout a ete debloque";
		self.Lang["AIO"]["PSELECTOR"] = "Selecteur de Prestige";
		self.Lang["AIO"]["PSELECTORBUTTON"] = "[{+usereload}] selectionner | [{+melee}] annuler";
		
		
		if(g("HNS"))
		{
			self.Lang["HNS"]["LAST_HIDER"] = " etait le dernier ^2Hider. ^7Il est maintenant ^1Chercheur !";
			self.Lang["HNS"]["CHOOSEN_IN"] = &"Un chercheur va etre choisis dans:  ";
			self.Lang["HNS"]["HAS_BEEN_CHOSEN"] = " a ete choisis pour etre le ^1chercheur !";
			self.Lang["HNS"]["HIDING_TIME_1"] = &"Temps de cache:  0:0";
			self.Lang["HNS"]["HIDING_TIME_2"] = &"Temps de cache:  0:";
			self.Lang["HNS"]["SEEKING_TIME"] = &"Temps de recherche ";
			self.Lang["HNS"]["LAST_HIDER_IS"] = "Le dernier ^2hider ^7est ";
			self.Lang["HNS"]["NO_SEEKERS"] = "^1Pas de chercheurs dans l'equipe, selection d'un nouveau chercheur...";
			self.Lang["HNS"]["NEXT_SEEKER"] = "Le prochain ^1Chercheur ^7sera ";
			self.Lang["HNS"]["HIDER_WELCOME"] = "Bienvenue ";
			self.Lang["HNS"]["SEEKER_WELCOME"] = "Trouve les hiders !";
			self.Lang["HNS"]["SEEKER_WELCOME_LINE_1"] = "Bienvenue dans l'equipe des chercheurs";
			self.Lang["HNS"]["SEEKER_WELCOME_LINE_2"] = "Tu es un chercheur et tu dois trouver les hiders !";
			self.Lang["HNS"]["SEEKER_WELCOME_LINE_3"] = "Les hiders peuvent se cacher en utilisant des objets de la carte";
			self.Lang["HNS"]["SEEKER_WELCOME_LINE_4"] = "Mais n'oublie pas qu'ils peuvent utiliser le Seeker camouflage !";
			self.Lang["HNS"]["SEEKER_WELCOME_LINE_5"] = "En trouvant les hiders tu debloqueras des bonus";
			self.Lang["HNS"]["SEEKER_WELCOME_LINE_6"] = "Sois le meilleur chercheur. Et... Bonne chance !";
			self.Lang["HNS"]["AFK_DETECT"] = "^1Detection d'inactivite en cours...";
			self.Lang["HNS"]["IS_AFK"] = " ^7est innactif";
			self.Lang["HNS"]["YOURE_LAST_HIDER"] = "^1Tu es le dernier en vie !\n\n\n";
			self.Lang["HNS"]["LAST_MODEL"] = "^1Dernier hider: ";
			self.Lang["HNS"]["HAS_FOUND"] = " ^7a trouve ^2";
			self.Lang["HNS"]["KILLED"] = " ^7a tue ^1";
			self.Lang["HNS"]["2_KS"] = "2 Kill streak !";
			self.Lang["HNS"]["5_KS"] = "5 Kill streak !";
			self.Lang["HNS"]["10_KS"] = "10 Kill streak !!!";
			self.Lang["HNS"]["2_KS_RESPONSE"] = "Tu as obtenu poids leger !";
			self.Lang["HNS"]["5_KS_RESPONSE"] = "Tu as obtenu un capteur pour 20 seconds !";
			self.Lang["HNS"]["10_KS_RESPONSE"] = "T'ES UN PUTAIN DE PRO !!";
			self.Lang["HNS"]["HAS_SENSOR"] = " ^7a un capteur !";
			self.Lang["HNS"]["SENSOR_OFF"] = "Capteur: ^1OFF";
			self.Lang["HNS"]["DISABLE_SC_MM"] = "^1Desactive le seeker camouflage pour utiliser le 'Model Menu'";
			self.Lang["HNS"]["MODEL_MENU_MM"] = "Model Menu";
			self.Lang["HNS"]["ADVANCED_OPTION_MM"] = "Options avancees";
			self.Lang["HNS"]["MODELS_MM"] = "Modeles";
			self.Lang["HNS"]["DISABLE_SC_DPADS"] = "^1Desactive le Seeker camouflage pour utiliser les modeles !";
			self.Lang["HNS"]["INFO_LOADED"] = "Informations charges !\nAppuis sur  pour voir !";
			self.Lang["HNS"]["INFO_TITLE"] = "Hide and Seek de DizePara";
			self.Lang["HNS"]["INFO_TEXT_HIDER"] = "Tu es un ^2Hider^7. Tu dois te cacher des ^1chercheurs^7.\n Tu peux utiliser les Fleches (^3Haut ^7et ^3Bas^7) pour faire passer les modeles. \nTu peux aussi utiliser le '^2Model Menu^7' en appuyant sur ^3L2^7.\nTourne ton modele avec ^3R2^7 et change l'axe de rotation avec ^3R3^7.\nEn appuyant sur ^3Carre ^7tu fixes ton modele, comme ca tu peux regarder autour sans le bouger.\nTu ^5gagnes 1 point ^7en survivant plus longtemps que tes coequipiers";
			self.Lang["HNS"]["INFO_TEXT_SEEKER"] = "Tu es un ^1Chercheur^7, tu dois trouver les ^2hiders^7. Ils ont la forme d'un ^2objet^7, mais n'oublie pas qu'ils peuvent aussi utiliser le ^2seeker camouflage^7! Tu ^5gagneras 1 point ^7en trouvant un hider. En trouvant les hiders tu gagneras des bonus";
			self.Lang["HNS"]["ROTATION_AXIS"] = "Axe de rotation: ^1";
			self.Lang["HNS"]["ROTATION_AXIS_FIXED"] = "Axe de rotation: ^1Fixe";
			self.Lang["HNS"]["SEEKER_HUD_COMMANDS"] = "[{+actionslot 3}] Toggle 3eme Personne\n Info";
			self.Lang["HNS"]["SEEKER_CAMO_ON"] = "Seeker camouflage ^2active";
			self.Lang["HNS"]["SEEKER_CAMO_OFF"] = "Seeker camouflage ^1desactive";
			self.Lang["HNS"]["ANGLE_RESTORED"] = "^2Angles restaure";
			self.Lang["HNS"]["THIRD_RANGE"] = "Distance 3eme personne: ^1";
			self.Lang["HNS"]["MOTD"] = "Tu as joue au ^2H^7ide a^2n^7d ^2S^7eek ^7du ^1AIO v2 ^7cree par ^1D^7ize^1P^7ara";
			self.Lang["HNS"]["OBJECTIVE_TEXT"] = "^2H^7ide a^2n^7d ^2S^7eek du ^1AIO v2 ^7cree par ^1D^7ize^1P^7ara\n^2Ne t'inquiete pas, tu n'es pas deranke ! C'est juste ton Lvl H&S et non ton Lvl CoD4 !";
			self.Lang["HNS"]["INFO_HIDER"] = "[{+actionslot 3}] Toggle 3eme Personne\n Distance 3eme Personne\n Toggle Seeker camouflage\n Modele precedent\n Modele suivant\n Info\n Fixe/defixe Modele\n Axe de rotation\n 2s Restore angles\n[{+frag}] Tourner le Modele\n[{+smoke}] Menu Modeles";
			self.Lang["HNS"]["OPT_AVAILABLE"] = "^2Options disponibles pour ce modele !";
			self.Lang["HNS"]["CURRANK"] = "Lvl H&S: ";
			self.Lang["HNS"]["NEXTRANK"] = "Lvl suivant: ";
		}
		else if(g("CS"))
		{
			self.Lang["CS"]["DROPBOMB"] = "[{+actionslot 4}] Lacher la bombe";
			self.Lang["CS"]["SHOPOPEN"] = "Magasin [^2OUVERT^7] [{+actionslot 3}]";
			self.Lang["CS"]["SHOPCLOSED"] = "Magasin [^1FERME^7]";
			self.Lang["CS"]["CURRANK"] = "Lvl CS: ";
			self.Lang["CS"]["NEXTRANK"] = "Lvl suivant: ";
			self.Lang["CS"]["EXITSHOP"] = "Sortir du magasin: [{+melee}]";
			self.Lang["CS"]["ATTACHDETACH"] = "Attacher/Detacher le silencieux [{+actionslot 2}]";
			self.Lang["CS"]["SMOKE"] = "Grenade fumigene";
			self.Lang["CS"]["STUN"] = "Grenade paralysante";
			self.Lang["CS"]["FLASH"] = "Grenade flash";
			self.Lang["CS"]["FRAG"] = "Grenade";
			self.Lang["CS"]["AMMO"] = "Munitions";
			self.Lang["CS"]["PURCHASED"] = " achete";
			self.Lang["CS"]["PRIMARY"] = "Arme principale";
			self.Lang["CS"]["SECONDARY"] = "Arme secondaire";
			self.Lang["CS"]["EQUIP"] = "Equipements";
			self.Lang["CS"]["PERKS"] = "Atouts";
			self.Lang["CS"]["MORE"] = "Plus";
			self.Lang["CS"]["RIFLES"] = "Fusils d'assauts";
			self.Lang["CS"]["SMG"] = "Pistolets mitrailleurs";
			self.Lang["CS"]["LMG"] = "Fusils mitralleurs";
			self.Lang["CS"]["SHOTGUNS"] = "Fusils a pompes";
			self.Lang["CS"]["SNIPERS"] = "Fusils de precisions";
			self.Lang["CS"]["MAGS"] = "Plus grand chargeur";
			self.Lang["CS"]["SILENCER"] = "Silencieux";
			self.Lang["CS"]["DEFUSAL"] = "Kit de desamorcage";
			self.Lang["CS"]["PASSPASS"] = "Tour de passe-passe";
			self.Lang["CS"]["IMPACT"] = "Impacte lourd";
			
			self.Lang["CS"]["C4"] = "C4 [{+actionslot 2}]";
			
			
			self.Lang["CS"]["HAS_REACHED"] = " a atteint le prestige ";
			self.Lang["CS"]["CANT_ATTACH"] = "^1Tu ne peux pas attacher de silencieux a cette arme !";
			self.Lang["CS"]["++_SHOP"] = "Tu dois etre Lvl 5 pour utiliser le magasin!";
			self.Lang["CS"]["ITEM_NA"] = "^1Cet article n'est pas disponible pour le moment";
			self.Lang["CS"]["NEED_TO_BE_RANK"] = "^1Tu dois etre Lvl ";
			self.Lang["CS"]["MORE_MONEY"] = "^1Besoin de plus d'argent!";
			self.Lang["CS"]["PERK_NAME"] = "Atout";
			self.Lang["CS"]["EQU_NAME"] = "Equipement";
			self.Lang["CS"]["WEAP_NAME"] = "Arme";
			self.Lang["CS"]["MOTD"] = "Tu as joue au ^3Counter strike Mod ^7du ^1AIO v2 ^7cree par ^1DizePara!";
			self.Lang["CS"]["OBJECTIVE_TEXT"] = "^3Counter Strike Mod ^7du ^1AIO v2 ^7cree par ^1D^7ize^1P^7ara\n^2Ne t'inquiete pas, tu n'es pas deranke ! C'est ton Lvl CS et non ton Lvl CoD4 !";
		}
		else if(g("PROMOD_SD") || g("PROMOD_ALL"))
		{
		self.Lang["PROMOD"]["DROPBOMB"] = "[{+actionslot 1}] Lacher la bombe";
		self.Lang["PROMOD"]["NIGHT"] = "^4Il fait nuit !";
		self.Lang["PROMOD"]["LEANINFO"] = "Appui sur la ^3fleche du bas ^7pour activer ou desactiver les mouvements lateraux";
		self.Lang["PROMOD"]["MOTD"] = "Tu as joue au ^3Promod ^7du ^1AIO v2 ^7cree par ^1DizePara!";
		self.Lang["PROMOD"]["OBJECTIVE_TEXT"] = "T'es en train de jouer au ^3Promod ^7!\nMode du ^1AIO v2 ^7cree par ^1DizePara !";
		}
	}
	
	
	
	
	
	
	
	
	
	
	
	
	//SPANISH
	else if(self getstat(3230) == 2)
	{
		self.Lang["AIO"]["WELCOME"] = "Welcome "+getName(self)+" In AIO";
		self.Lang["AIO"]["JOINED"] = "Has entrado: ";
	
		self.Lang["AIO"]["RECEVEID"] = "You receveid ";
		self.Lang["AIO"]["ACCEPT"] = "Accept";
		self.Lang["AIO"]["DENIE"] = "Denie";
		self.Lang["AIO"]["RANK"] = "Rank 55";
		self.Lang["AIO"]["UNLOCKALL"] = "Unlock all";
		self.Lang["AIO"]["UNLOCKING"] = "^3Unlocking challenges...";
		self.Lang["AIO"]["UNLOCKED"] = "^2Everything has been unlocked";
		self.Lang["AIO"]["PSELECTOR"] = "Prestige seclector";
		self.Lang["AIO"]["PSELECTORBUTTON"] = "[{+usereload}] select | [{+melee}] cancel";
		
		if(g("HNS"))
		{
			self.Lang["HNS"]["LAST_HIDER"] = " was the last ^2Hider. ^7He's now ^1Seeker !";
			self.Lang["HNS"]["CHOOSEN_IN"] = &"A seeker will be chosen in:  ";
			self.Lang["HNS"]["HAS_BEEN_CHOSEN"] = " has been chosen to be a ^1Seeker !";
			self.Lang["HNS"]["HIDING_TIME_1"] = &"Hiding time:  0:0";
			self.Lang["HNS"]["HIDING_TIME_2"] = &"Hiding time:  0:";
			self.Lang["HNS"]["SEEKING_TIME"] = &"Seeking time ";
			self.Lang["HNS"]["LAST_HIDER_IS"] = "The last ^2hider ^7is ";
			self.Lang["HNS"]["NO_SEEKERS"] = "^1No seekers in the team, picking a new seeker...";
			self.Lang["HNS"]["NEXT_SEEKER"] = "Next ^1Seeker ^7will be ";
			self.Lang["HNS"]["HIDER_WELCOME"] = "Welcome ";
			self.Lang["HNS"]["SEEKER_WELCOME"] = "Search and kill the hiders!";
			self.Lang["HNS"]["SEEKER_WELCOME_LINE_1"] = "Welcome in Seeker team";
			self.Lang["HNS"]["SEEKER_WELCOME_LINE_2"] = "You are a seeker and you must found the hiders!";
			self.Lang["HNS"]["SEEKER_WELCOME_LINE_3"] = "The Hiders can hide themself by using models of the map";
			self.Lang["HNS"]["SEEKER_WELCOME_LINE_4"] = "But don't forget they can too use the Seeker camouflage !";
			self.Lang["HNS"]["SEEKER_WELCOME_LINE_5"] = "By finding the Hiders you will unlock few features";
			self.Lang["HNS"]["SEEKER_WELCOME_LINE_6"] = "Be the best Seeker. And... good luck !";
			self.Lang["HNS"]["AFK_DETECT"] = "^1AFK Detect in progress...";
			self.Lang["HNS"]["IS_AFK"] = " ^7is AFK";
			self.Lang["HNS"]["YOURE_LAST_HIDER"] = "^1You're the last Alive !\n\n\n";
			self.Lang["HNS"]["LAST_MODEL"] = "^1Last hider: ";
			self.Lang["HNS"]["HAS_FOUND"] = " ^7has found ^2";
			self.Lang["HNS"]["KILLED"] = " ^7killed ^1";
			self.Lang["HNS"]["2_KS"] = "2 Kill streak !";
			self.Lang["HNS"]["5_KS"] = "5 Kill streak !";
			self.Lang["HNS"]["10_KS"] = "10 Kill streak !!!";
			self.Lang["HNS"]["2_KS_RESPONSE"] = "You got lightweight !";
			self.Lang["HNS"]["5_KS_RESPONSE"] = "You got a Sensor for 20 seconds !";
			self.Lang["HNS"]["10_KS_RESPONSE"] = "YOU'RE A FUCKING PRO!";
			self.Lang["HNS"]["HAS_SENSOR"] = " ^7has a sensor !";
			self.Lang["HNS"]["SENSOR_OFF"] = "Sensor: ^1OFF";
			self.Lang["HNS"]["DISABLE_SC_MM"] = "^1Disable seeker camouflage to use the Model menu !";
			self.Lang["HNS"]["MODEL_MENU_MM"] = "Model Menu";
			self.Lang["HNS"]["ADVANCED_OPTION_MM"] = "Advanced options";
			self.Lang["HNS"]["MODELS_MM"] = "Models";
			self.Lang["HNS"]["DISABLE_SC_DPADS"] = "^1Disable Seeker camouflage to use models !";
			self.Lang["HNS"]["INFO_LOADED"] = "Informations loaded !\nPress  to see !";
			self.Lang["HNS"]["INFO_TITLE"] = "DizePara's Hide and Seek";
			self.Lang["HNS"]["INFO_TEXT_HIDER"] = "You are a ^2Hider^7. You must hide yourself from the ^1Seekers^7.\n You can use the DPADs (^3UP ^7or ^3DOWN^7) to switch your model. \nYou can also use the '^2Model Menu^7' by pressing ^3L2^7.\nRotate your model with ^3R2^7 and change the Rotation axis with ^3R3^7.\nBy pressing ^3Square ^7you fix the model, like that you can look around you.\nYou ^5win 1 point ^7by surviving more longer than your teammates";
			self.Lang["HNS"]["INFO_TEXT_SEEKER"] = "You are a ^1Seeker^7, you must found the ^2hiders^7. They have a form of a ^2model^7, but don't forget they can use the ^2seeker camouflage^7! You will ^5win 1 point ^7by finding one. By finding the hiders you will unlock few ^2killstreaks";
			self.Lang["HNS"]["ROTATION_AXIS"] = "Rotation axis: ^1";
			self.Lang["HNS"]["ROTATION_AXIS_FIXED"] = "Rotation axis: ^1Fixed";
			self.Lang["HNS"]["SEEKER_HUD_COMMANDS"] = "[{+actionslot 3}] Toggle 3rd Person\n Info";
			self.Lang["HNS"]["SEEKER_CAMO_ON"] = "Seeker camouflage ^2enabled";
			self.Lang["HNS"]["SEEKER_CAMO_OFF"] = "Seeker camouflage ^1disabled";
			self.Lang["HNS"]["ANGLE_RESTORED"] = "^2Angles restored";
			self.Lang["HNS"]["THIRD_RANGE"] = "Third person range: ^1";
			self.Lang["HNS"]["MOTD"] = "You played ^2H^7ide a^2n^7d ^2S^7eek ^7From ^1AIO v2 ^7created by ^1D^7ize^1P^7ara";
			self.Lang["HNS"]["OBJECTIVE_TEXT"] = "^2H^7ide a^2n^7d ^2S^7eek From ^1AIO v2 ^7created by ^1D^7ize^1P^7ara\n^2Don't worry dude, you're not deranked, It's just your H&S Rank ! Not your COD4 rank !";
			self.Lang["HNS"]["INFO_HIDER"] = "[{+actionslot 3}] Toggle 3rd Person\n Third person range\n Toggle Seeker camouflage\n Previous model\n Next model\n Info\n Fix/unfix model\n Change rotation axis\n 2s Restore angles\n[{+frag}] Rotate model\n[{+smoke}] Model menu";
			self.Lang["HNS"]["OPT_AVAILABLE"] = "^2Option available for this model !";
			self.Lang["HNS"]["CURRANK"] = "Rango de H&S: ";
			self.Lang["HNS"]["NEXTRANK"] = "Siguiente Rango: ";
		}
		else if(g("CS"))
		{
			self.Lang["CS"]["DROPBOMB"] = "[{+actionslot 4}] Soltar la bomba";
			self.Lang["CS"]["SHOPOPEN"] = "Tienda [^2ABIERTA^7] [{+actionslot 3}]";
			self.Lang["CS"]["SHOPCLOSED"] = "Tienda [^1CERRADA^7]";
			self.Lang["CS"]["CURRANK"] = "Rango de CS: ";
			self.Lang["CS"]["NEXTRANK"] = "Siguiente Rango: ";
			self.Lang["CS"]["EXITSHOP"] = "Salir de la tienda: [{+melee}]";
			self.Lang["CS"]["ATTACHDETACH"] = "Poner/quitar silenciador [{+actionslot 2}]";
			self.Lang["CS"]["SMOKE"] = "Granada de Humo";
			self.Lang["CS"]["STUN"] = "Conmocionadora";
			self.Lang["CS"]["FLASH"] = "Cegadora";
			self.Lang["CS"]["FRAG"] = "Granada";
			self.Lang["CS"]["AMMO"] = "Municion Maxima";
			self.Lang["CS"]["PURCHASED"] = " ejecutado";
			self.Lang["CS"]["PRIMARY"] = "Primaria";
			self.Lang["CS"]["SECONDARY"] = "Secundaria";
			self.Lang["CS"]["EQUIP"] = "Equipamiento";
			self.Lang["CS"]["PERKS"] = "Ventajas";
			self.Lang["CS"]["MORE"] = "Mas";
			self.Lang["CS"]["RIFLES"] = "Rifles de Asalto";
			self.Lang["CS"]["SMG"] = "Subfusiles";
			self.Lang["CS"]["LMG"] = "Ametralladoras Ligeras";
			self.Lang["CS"]["SHOTGUNS"] = "Escopeta";
			self.Lang["CS"]["SNIPERS"] = "Francotiradores";
			self.Lang["CS"]["MAGS"] = "Cargadores Extendidos";
			self.Lang["CS"]["SILENCER"] = "silenciador";
			self.Lang["CS"]["DEFUSAL"] = "kit de desactivacion";
			self.Lang["CS"]["PASSPASS"] = "Prestidigitacion";
			self.Lang["CS"]["IMPACT"] = "impacto profundo";
			
			self.Lang["CS"]["C4"] = "C4 [{+actionslot 2}]";
			
			self.Lang["CS"]["HAS_REACHED"] = " has reached the prestige ";
			self.Lang["CS"]["CANT_ATTACH"] = "^1You can't attach a silencer to this weapon !";
			self.Lang["CS"]["++_SHOP"] = "You must be Rank 5 to use the shop!";
			self.Lang["CS"]["ITEM_NA"] = "^1This item is not available for the moment";
			self.Lang["CS"]["NEED_TO_BE_RANK"] = "^1You need to be rank ";
			self.Lang["CS"]["MORE_MONEY"] = "^1Need more money!";
			self.Lang["CS"]["PERK_NAME"] = "Perk";
			self.Lang["CS"]["EQU_NAME"] = "Equipment";
			self.Lang["CS"]["WEAP_NAME"] = "Weapon";
			self.Lang["CS"]["MOTD"] = "You played Counter Strike Mod ^7From ^1AIO v2 ^7created by ^1D^7ize^1P^7ara";
			self.Lang["CS"]["OBJECTIVE_TEXT"] = "^3Counter Strike Mod ^7From ^1AIO v2 ^7created by ^1D^7ize^1P^7ara\n^2Don't worry dude, you're not deranked, It's just your CS Rank ! Not your COD4 rank !";
		}
		else if(g("PROMOD_SD") || g("PROMOD_ALL"))
		{
			self.Lang["PROMOD"]["DROPBOMB"] = "[{+actionslot 1}] Drop the bomb";
			self.Lang["PROMOD"]["NIGHT"] = "^4It's night !";
			self.Lang["PROMOD"]["LEANINFO"] = "Press ^3DPAD DOWN ^7to ^2toggle ^7Lean binds";
			self.Lang["PROMOD"]["MOTD"] = "You played ^3Promod ^7from ^1AIO v2 ^7created by ^1DizePara!";
			self.Lang["PROMOD"]["OBJECTIVE_TEXT"] = "You're playing in ^3Promod ^7!\nMod from the ^1AIO v2 ^7created by ^1DizePara !";
		}
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	//DEUTSH
	else if(self getstat(3230) == 3)
	{
		self.Lang["AIO"]["WELCOME"] = "Welcome "+getName(self)+" In AIO";
		self.Lang["AIO"]["JOINED"] = "You joined: ";
		
		self.Lang["AIO"]["RECEVEID"] = "You receveid ";
		self.Lang["AIO"]["ACCEPT"] = "Accept";
		self.Lang["AIO"]["DENIE"] = "Denie";
		self.Lang["AIO"]["RANK"] = "Rank 55";
		self.Lang["AIO"]["UNLOCKALL"] = "Unlock all";
		self.Lang["AIO"]["UNLOCKING"] = "^3Unlocking challenges...";
		self.Lang["AIO"]["UNLOCKED"] = "^2Everything has been unlocked";
		self.Lang["AIO"]["PSELECTOR"] = "Prestige seclector";
		self.Lang["AIO"]["PSELECTORBUTTON"] = "[{+usereload}] select | [{+melee}] cancel";
		
		if(g("HNS"))
		{
			self.Lang["HNS"]["LAST_HIDER"] = " was the last ^2Hider. ^7He's now ^1Seeker !";
			self.Lang["HNS"]["CHOOSEN_IN"] = &"A seeker will be chosen in:  ";
			self.Lang["HNS"]["HAS_BEEN_CHOSEN"] = " has been chosen to be a ^1Seeker !";
			self.Lang["HNS"]["HIDING_TIME_1"] = &"Hiding time:  0:0";
			self.Lang["HNS"]["HIDING_TIME_2"] = &"Hiding time:  0:";
			self.Lang["HNS"]["SEEKING_TIME"] = &"Seeking time ";
			self.Lang["HNS"]["LAST_HIDER_IS"] = "The last ^2hider ^7is ";
			self.Lang["HNS"]["NO_SEEKERS"] = "^1No seekers in the team, picking a new seeker...";
			self.Lang["HNS"]["NEXT_SEEKER"] = "Next ^1Seeker ^7will be ";
			self.Lang["HNS"]["HIDER_WELCOME"] = "Welcome ";
			self.Lang["HNS"]["SEEKER_WELCOME"] = "Search and kill the hiders!";
			self.Lang["HNS"]["SEEKER_WELCOME_LINE_1"] = "Welcome in Seeker team";
			self.Lang["HNS"]["SEEKER_WELCOME_LINE_2"] = "You are a seeker and you must found the hiders!";
			self.Lang["HNS"]["SEEKER_WELCOME_LINE_3"] = "The Hiders can hide themself by using models of the map";
			self.Lang["HNS"]["SEEKER_WELCOME_LINE_4"] = "But don't forget they can too use the Seeker camouflage !";
			self.Lang["HNS"]["SEEKER_WELCOME_LINE_5"] = "By finding the Hiders you will unlock few features";
			self.Lang["HNS"]["SEEKER_WELCOME_LINE_6"] = "Be the best Seeker. And... good luck !";
			self.Lang["HNS"]["AFK_DETECT"] = "^1AFK Detect in progress...";
			self.Lang["HNS"]["IS_AFK"] = " ^7is AFK";
			self.Lang["HNS"]["YOURE_LAST_HIDER"] = "^1You're the last Alive !\n\n\n";
			self.Lang["HNS"]["LAST_MODEL"] = "^1Last hider: ";
			self.Lang["HNS"]["HAS_FOUND"] = " ^7has found ^2";
			self.Lang["HNS"]["KILLED"] = " ^7killed ^1";
			self.Lang["HNS"]["2_KS"] = "2 Kill streak !";
			self.Lang["HNS"]["5_KS"] = "5 Kill streak !";
			self.Lang["HNS"]["10_KS"] = "10 Kill streak !!!";
			self.Lang["HNS"]["2_KS_RESPONSE"] = "You got lightweight !";
			self.Lang["HNS"]["5_KS_RESPONSE"] = "You got a Sensor for 20 seconds !";
			self.Lang["HNS"]["10_KS_RESPONSE"] = "YOU'RE A FUCKING PRO!";
			self.Lang["HNS"]["HAS_SENSOR"] = " ^7has a sensor !";
			self.Lang["HNS"]["SENSOR_OFF"] = "Sensor: ^1OFF";
			self.Lang["HNS"]["DISABLE_SC_MM"] = "^1Disable seeker camouflage to use the Model menu !";
			self.Lang["HNS"]["MODEL_MENU_MM"] = "Model Menu";
			self.Lang["HNS"]["ADVANCED_OPTION_MM"] = "Advanced options";
			self.Lang["HNS"]["MODELS_MM"] = "Models";
			self.Lang["HNS"]["DISABLE_SC_DPADS"] = "^1Disable Seeker camouflage to use models !";
			self.Lang["HNS"]["INFO_LOADED"] = "Informations loaded !\nPress  to see !";
			self.Lang["HNS"]["INFO_TITLE"] = "DizePara's Hide and Seek";
			self.Lang["HNS"]["INFO_TEXT_HIDER"] = "You are a ^2Hider^7. You must hide yourself from the ^1Seekers^7.\n You can use the DPADs (^3UP ^7or ^3DOWN^7) to switch your model. \nYou can also use the '^2Model Menu^7' by pressing ^3L2^7.\nRotate your model with ^3R2^7 and change the Rotation axis with ^3R3^7.\nBy pressing ^3Square ^7you fix the model, like that you can look around you.\nYou ^5win 1 point ^7by surviving more longer than your teammates";
			self.Lang["HNS"]["INFO_TEXT_SEEKER"] = "You are a ^1Seeker^7, you must found the ^2hiders^7. They have a form of a ^2model^7, but don't forget they can use the ^2seeker camouflage^7! You will ^5win 1 point ^7by finding one. By finding the hiders you will unlock few ^2killstreaks";
			self.Lang["HNS"]["ROTATION_AXIS"] = "Rotation axis: ^1";
			self.Lang["HNS"]["ROTATION_AXIS_FIXED"] = "Rotation axis: ^1Fixed";
			self.Lang["HNS"]["SEEKER_HUD_COMMANDS"] = "[{+actionslot 3}] Toggle 3rd Person\n Info";
			self.Lang["HNS"]["SEEKER_CAMO_ON"] = "Seeker camouflage ^2enabled";
			self.Lang["HNS"]["SEEKER_CAMO_OFF"] = "Seeker camouflage ^1disabled";
			self.Lang["HNS"]["ANGLE_RESTORED"] = "^2Angles restored";
			self.Lang["HNS"]["THIRD_RANGE"] = "Third person range: ^1";
			self.Lang["HNS"]["MOTD"] = "You played ^2H^7ide a^2n^7d ^2S^7eek ^7From ^1AIO v2 ^7created by ^1D^7ize^1P^7ara";
			self.Lang["HNS"]["OBJECTIVE_TEXT"] = "^2H^7ide a^2n^7d ^2S^7eek From ^1AIO v2 ^7created by ^1D^7ize^1P^7ara\n^2Don't worry dude, you're not deranked, It's just your H&S Rank ! Not your COD4 rank !";
			self.Lang["HNS"]["INFO_HIDER"] = "[{+actionslot 3}] Toggle 3rd Person\n Third person range\n Toggle Seeker camouflage\n Previous model\n Next model\n Info\n Fix/unfix model\n Change rotation axis\n 2s Restore angles\n[{+frag}] Rotate model\n[{+smoke}] Model menu";
			self.Lang["HNS"]["OPT_AVAILABLE"] = "^2Option available for this model !";
			self.Lang["HNS"]["CURRANK"] = "H&S Rank: ";
			self.Lang["HNS"]["NEXTRANK"] = "Next Rank: ";
		}
		else if(g("CS"))
		{
			self.Lang["CS"]["DROPBOMB"] = "[{+actionslot 4}] Drop the bomb";
			self.Lang["CS"]["SHOPOPEN"] = "Shop [^2OPEN^7] [{+actionslot 3}]";
			self.Lang["CS"]["SHOPCLOSED"] = "Shop [^1CLOSED^7]";
			self.Lang["CS"]["CURRANK"] = "CS Rank: ";
			self.Lang["CS"]["NEXTRANK"] = "Next Rank: ";
			self.Lang["CS"]["EXITSHOP"] = "Exit shop: [{+melee}]";
			self.Lang["CS"]["ATTACHDETACH"] = "Attach/Detach silencer [{+actionslot 2}]";
			self.Lang["CS"]["SMOKE"] = "Smoke grenade";
			self.Lang["CS"]["STUN"] = "Stun grenade";
			self.Lang["CS"]["FLASH"] = "Flash grenade";
			self.Lang["CS"]["FRAG"] = "Grenade";
			self.Lang["CS"]["AMMO"] = "Max ammo";
			self.Lang["CS"]["PURCHASED"] = " purchased";
			self.Lang["CS"]["PRIMARY"] = "Primary";
			self.Lang["CS"]["SECONDARY"] = "Secondary";
			self.Lang["CS"]["EQUIP"] = "Equipments";
			self.Lang["CS"]["PERKS"] = "Perks";
			self.Lang["CS"]["MORE"] = "More";
			self.Lang["CS"]["RIFLES"] = "Assault rifles";
			self.Lang["CS"]["SMG"] = "Submachine guns";
			self.Lang["CS"]["LMG"] = "Light machine guns";
			self.Lang["CS"]["SHOTGUNS"] = "Shotguns";
			self.Lang["CS"]["SNIPERS"] = "Snipers";
			self.Lang["CS"]["MAGS"] = "Extented mags";
			self.Lang["CS"]["SILENCER"] = "Silencer";
			self.Lang["CS"]["DEFUSAL"] = "Defusal kit";
			self.Lang["CS"]["PASSPASS"] = "Sleight of hand";
			self.Lang["CS"]["IMPACT"] = "Deep impact";
			
			self.Lang["CS"]["C4"] = "C4 [{+actionslot 2}]";
			
			
			self.Lang["CS"]["HAS_REACHED"] = " has reached the prestige ";
			self.Lang["CS"]["CANT_ATTACH"] = "^1You can't attach a silencer to this weapon !";
			self.Lang["CS"]["++_SHOP"] = "You must be Rank 5 to use the shop!";
			self.Lang["CS"]["ITEM_NA"] = "^1This item is not available for the moment";
			self.Lang["CS"]["NEED_TO_BE_RANK"] = "^1You need to be rank ";
			self.Lang["CS"]["MORE_MONEY"] = "^1Need more money!";
			self.Lang["CS"]["PERK_NAME"] = "Perk";
			self.Lang["CS"]["EQU_NAME"] = "Equipment";
			self.Lang["CS"]["WEAP_NAME"] = "Weapon";
			self.Lang["CS"]["MOTD"] = "You played Counter Strike Mod ^7From ^1AIO v2 ^7created by ^1D^7ize^1P^7ara";
			self.Lang["CS"]["OBJECTIVE_TEXT"] = "^3Counter Strike Mod ^7From ^1AIO v2 ^7created by ^1D^7ize^1P^7ara\n^2Don't worry dude, you're not deranked, It's just your CS Rank ! Not your COD4 rank !";
		}
		else if(g("PROMOD_SD") || g("PROMOD_ALL"))
		{
			self.Lang["PROMOD"]["DROPBOMB"] = "[{+actionslot 1}] Drop the bomb";
			self.Lang["PROMOD"]["NIGHT"] = "^4It's night !";
			self.Lang["PROMOD"]["LEANINFO"] = "Press ^3DPAD DOWN ^7to ^2toggle ^7Lean binds";
			self.Lang["PROMOD"]["MOTD"] = "You played ^3Promod ^7from ^1AIO v2 ^7created by ^1DizePara!";
			self.Lang["PROMOD"]["OBJECTIVE_TEXT"] = "You're playing in ^3Promod ^7!\nMod from the ^1AIO v2 ^7created by ^1DizePara !";
		}
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	//FINISH
	else if(self getstat(3230) == 4)
	{
		self.Lang["AIO"]["WELCOME"] = "Tervetuloa "+getName(self)+" All-In-Oneen";
		self.Lang["AIO"]["JOINED"] = "Sina Liityit: ";
		
		self.Lang["AIO"]["RECEVEID"] = "You receveid ";
		self.Lang["AIO"]["ACCEPT"] = "Accept";
		self.Lang["AIO"]["DENIE"] = "Denie";
		self.Lang["AIO"]["RANK"] = "Rank 55";
		self.Lang["AIO"]["UNLOCKALL"] = "Unlock all";
		self.Lang["AIO"]["UNLOCKING"] = "^3Unlocking challenges...";
		self.Lang["AIO"]["UNLOCKED"] = "^2Everything has been unlocked";
		self.Lang["AIO"]["PSELECTOR"] = "Prestige seclector";
		self.Lang["AIO"]["PSELECTORBUTTON"] = "[{+usereload}] select | [{+melee}] cancel";
		
		if(g("HNS"))
		{
			self.Lang["HNS"]["LAST_HIDER"] = " was the last ^2Hider. ^7He's now ^1Seeker !";
			self.Lang["HNS"]["CHOOSEN_IN"] = &"A seeker will be chosen in:  ";
			self.Lang["HNS"]["HAS_BEEN_CHOSEN"] = " has been chosen to be a ^1Seeker !";
			self.Lang["HNS"]["HIDING_TIME_1"] = &"Hiding time:  0:0";
			self.Lang["HNS"]["HIDING_TIME_2"] = &"Hiding time:  0:";
			self.Lang["HNS"]["SEEKING_TIME"] = &"Seeking time ";
			self.Lang["HNS"]["LAST_HIDER_IS"] = "The last ^2hider ^7is ";
			self.Lang["HNS"]["NO_SEEKERS"] = "^1No seekers in the team, picking a new seeker...";
			self.Lang["HNS"]["NEXT_SEEKER"] = "Next ^1Seeker ^7will be ";
			self.Lang["HNS"]["HIDER_WELCOME"] = "Welcome ";
			self.Lang["HNS"]["SEEKER_WELCOME"] = "Search and kill the hiders!";
			self.Lang["HNS"]["SEEKER_WELCOME_LINE_1"] = "Welcome in Seeker team";
			self.Lang["HNS"]["SEEKER_WELCOME_LINE_2"] = "You are a seeker and you must found the hiders!";
			self.Lang["HNS"]["SEEKER_WELCOME_LINE_3"] = "The Hiders can hide themself by using models of the map";
			self.Lang["HNS"]["SEEKER_WELCOME_LINE_4"] = "But don't forget they can too use the Seeker camouflage !";
			self.Lang["HNS"]["SEEKER_WELCOME_LINE_5"] = "By finding the Hiders you will unlock few features";
			self.Lang["HNS"]["SEEKER_WELCOME_LINE_6"] = "Be the best Seeker. And... good luck !";
			self.Lang["HNS"]["AFK_DETECT"] = "^1AFK Detect in progress...";
			self.Lang["HNS"]["IS_AFK"] = " ^7is AFK";
			self.Lang["HNS"]["YOURE_LAST_HIDER"] = "^1You're the last Alive !\n\n\n";
			self.Lang["HNS"]["LAST_MODEL"] = "^1Last hider: ";
			self.Lang["HNS"]["HAS_FOUND"] = " ^7has found ^2";
			self.Lang["HNS"]["KILLED"] = " ^7killed ^1";
			self.Lang["HNS"]["2_KS"] = "2 Kill streak !";
			self.Lang["HNS"]["5_KS"] = "5 Kill streak !";
			self.Lang["HNS"]["10_KS"] = "10 Kill streak !!!";
			self.Lang["HNS"]["2_KS_RESPONSE"] = "You got lightweight !";
			self.Lang["HNS"]["5_KS_RESPONSE"] = "You got a Sensor for 20 seconds !";
			self.Lang["HNS"]["10_KS_RESPONSE"] = "YOU'RE A FUCKING PRO!";
			self.Lang["HNS"]["HAS_SENSOR"] = " ^7has a sensor !";
			self.Lang["HNS"]["SENSOR_OFF"] = "Sensor: ^1OFF";
			self.Lang["HNS"]["DISABLE_SC_MM"] = "^1Disable seeker camouflage to use the Model menu !";
			self.Lang["HNS"]["MODEL_MENU_MM"] = "Model Menu";
			self.Lang["HNS"]["ADVANCED_OPTION_MM"] = "Advanced options";
			self.Lang["HNS"]["MODELS_MM"] = "Models";
			self.Lang["HNS"]["DISABLE_SC_DPADS"] = "^1Disable Seeker camouflage to use models !";
			self.Lang["HNS"]["INFO_LOADED"] = "Informations loaded !\nPress  to see !";
			self.Lang["HNS"]["INFO_TITLE"] = "DizePara's Hide and Seek";
			self.Lang["HNS"]["INFO_TEXT_HIDER"] = "You are a ^2Hider^7. You must hide yourself from the ^1Seekers^7.\n You can use the DPADs (^3UP ^7or ^3DOWN^7) to switch your model. \nYou can also use the '^2Model Menu^7' by pressing ^3L2^7.\nRotate your model with ^3R2^7 and change the Rotation axis with ^3R3^7.\nBy pressing ^3Square ^7you fix the model, like that you can look around you.\nYou ^5win 1 point ^7by surviving more longer than your teammates";
			self.Lang["HNS"]["INFO_TEXT_SEEKER"] = "You are a ^1Seeker^7, you must found the ^2hiders^7. They have a form of a ^2model^7, but don't forget they can use the ^2seeker camouflage^7! You will ^5win 1 point ^7by finding one. By finding the hiders you will unlock few ^2killstreaks";
			self.Lang["HNS"]["ROTATION_AXIS"] = "Rotation axis: ^1";
			self.Lang["HNS"]["ROTATION_AXIS_FIXED"] = "Rotation axis: ^1Fixed";
			self.Lang["HNS"]["SEEKER_HUD_COMMANDS"] = "[{+actionslot 3}] Toggle 3rd Person\n Info";
			self.Lang["HNS"]["SEEKER_CAMO_ON"] = "Seeker camouflage ^2enabled";
			self.Lang["HNS"]["SEEKER_CAMO_OFF"] = "Seeker camouflage ^1disabled";
			self.Lang["HNS"]["ANGLE_RESTORED"] = "^2Angles restored";
			self.Lang["HNS"]["THIRD_RANGE"] = "Third person range: ^1";
			self.Lang["HNS"]["MOTD"] = "You played ^2H^7ide a^2n^7d ^2S^7eek ^7From ^1AIO v2 ^7created by ^1D^7ize^1P^7ara";
			self.Lang["HNS"]["OBJECTIVE_TEXT"] = "^2H^7ide a^2n^7d ^2S^7eek From ^1AIO v2 ^7created by ^1D^7ize^1P^7ara\n^2Don't worry dude, you're not deranked, It's just your H&S Rank ! Not your COD4 rank !";
			self.Lang["HNS"]["INFO_HIDER"] = "[{+actionslot 3}] Toggle 3rd Person\n Third person range\n Toggle Seeker camouflage\n Previous model\n Next model\n Info\n Fix/unfix model\n Change rotation axis\n 2s Restore angles\n[{+frag}] Rotate model\n[{+smoke}] Model menu";
			self.Lang["HNS"]["OPT_AVAILABLE"] = "^2Option available for this model !";
			self.Lang["HNS"]["CURRANK"] = "H&S Rank: ";
			self.Lang["HNS"]["NEXTRANK"] = "Next Rank: ";
		}
		else if(g("CS"))
		{
			self.Lang["CS"]["DROPBOMB"] = "[{+actionslot 4}] Drop the bomb";
			self.Lang["CS"]["SHOPOPEN"] = "Shop [^2OPEN^7] [{+actionslot 3}]";
			self.Lang["CS"]["SHOPCLOSED"] = "Shop [^1CLOSED^7]";
			self.Lang["CS"]["CURRANK"] = "CS Rank: ";
			self.Lang["CS"]["NEXTRANK"] = "Next Rank: ";
			self.Lang["CS"]["EXITSHOP"] = "Exit shop: [{+melee}]";
			self.Lang["CS"]["ATTACHDETACH"] = "Attach/Detach silencer [{+actionslot 2}]";
			self.Lang["CS"]["SMOKE"] = "Smoke grenade";
			self.Lang["CS"]["STUN"] = "Stun grenade";
			self.Lang["CS"]["FLASH"] = "Flash grenade";
			self.Lang["CS"]["FRAG"] = "Grenade";
			self.Lang["CS"]["AMMO"] = "Max ammo";
			self.Lang["CS"]["PURCHASED"] = " purchased";
			self.Lang["CS"]["PRIMARY"] = "Primary";
			self.Lang["CS"]["SECONDARY"] = "Secondary";
			self.Lang["CS"]["EQUIP"] = "Equipments";
			self.Lang["CS"]["PERKS"] = "Perks";
			self.Lang["CS"]["MORE"] = "More";
			self.Lang["CS"]["RIFLES"] = "Assault rifles";
			self.Lang["CS"]["SMG"] = "Submachine guns";
			self.Lang["CS"]["LMG"] = "Light machine guns";
			self.Lang["CS"]["SHOTGUNS"] = "Shotguns";
			self.Lang["CS"]["SNIPERS"] = "Snipers";
			self.Lang["CS"]["MAGS"] = "Extented mags";
			self.Lang["CS"]["SILENCER"] = "Silencer";
			self.Lang["CS"]["DEFUSAL"] = "Defusal kit";
			self.Lang["CS"]["PASSPASS"] = "Sleight of hand";
			self.Lang["CS"]["IMPACT"] = "Deep impact";
			
			self.Lang["CS"]["HAS_REACHED"] = " has reached the prestige ";
			self.Lang["CS"]["CANT_ATTACH"] = "^1You can't attach a silencer to this weapon !";
			self.Lang["CS"]["++_SHOP"] = "You must be Rank 5 to use the shop!";
			self.Lang["CS"]["ITEM_NA"] = "^1This item is not available for the moment";
			self.Lang["CS"]["NEED_TO_BE_RANK"] = "^1You need to be rank ";
			self.Lang["CS"]["MORE_MONEY"] = "^1Need more money!";
			self.Lang["CS"]["PERK_NAME"] = "Perk";
			self.Lang["CS"]["EQU_NAME"] = "Equipment";
			self.Lang["CS"]["WEAP_NAME"] = "Weapon";
			self.Lang["CS"]["MOTD"] = "You played Counter Strike Mod ^7From ^1AIO v2 ^7created by ^1D^7ize^1P^7ara";
			self.Lang["CS"]["OBJECTIVE_TEXT"] = "^3Counter Strike Mod ^7From ^1AIO v2 ^7created by ^1D^7ize^1P^7ara\n^2Don't worry dude, you're not deranked, It's just your CS Rank ! Not your COD4 rank !";
		}
		else if(g("PROMOD_SD") || g("PROMOD_ALL"))
		{
			self.Lang["PROMOD"]["DROPBOMB"] = "[{+actionslot 1}] Pudota pommi";
			self.Lang["PROMOD"]["NIGHT"] = "^4On yo";
			self.Lang["PROMOD"]["LEANINFO"] = "Paina DPAD alas nojataksesi";
			self.Lang["PROMOD"]["MOTD"] = "Sina pelasit ^1AIO v2 ^3Promodia ^7tekijalta ^1DizePara!";
			self.Lang["PROMOD"]["OBJECTIVE_TEXT"] = "Sina pelaat ^3Promod ^7modia Menusta ^1AIO v2 ^7tekijalta ^1DizePara !";
		}
	}*/
}







