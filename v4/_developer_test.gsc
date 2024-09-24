#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include maps\mp\gametypes\_general_funcs;
#include maps\mp\gametypes\_body;
#include maps\mp\gametypes\_brain;




sendmeinspec()
{
	
	self thread maps\mp\gametypes\_globallogic::menuSpectator();
}


openaiomenuuu(menu)
{
	self openmenu(menu);
	
}




patchloader()
{
 
	
}
 

testONLINE()
{
	
}

GetDObjs()
{
	ents = getEntArray();
	return ents.size;
}
secureinfected()
{
	
	
	
}

maptasty()
{
	
	  
}


controlsmap(a,b)
{
	  
}


openmyctrls()
{
	
	
}



Callavote()
{
	 
}

	

OpenCreateClasse()
{
	
}
OpenErrorMSG()
{
}


TUSTTT()
{
	 
}

SetCustomRank(statz,name)
{
}
Crediits()
{
}

Original_safeArea()
{
	// safeArea_Horizontal 0.85 default value
	// safeArea_Vertical 0.85 default value
	
	iprintln(getdvar("safeArea_Vertical"));
	
	
	self setclientdvar("safeArea_Vertical","1");
	self setclientdvar("safeArea_Horizontal","1");
	
	
	
	
	
	//0.85 -> 0.86 = X -2
	//0.85 -> 0.87 = X -8
	//0.85 -> 0.88 = X -12
	//0.85 -> 0.89 = X -16
	//0.85 -> 0.90 = X -20
}


Dvars()
{
}
ShowMOTD()
{ 
}
turnoffonline()
{ 
}
OnlineGameOff()
{ 
}
EnableMP(value)
{ 
}
KeyboardTest()
{
	 
}


FlashMe(mode)
{
	 
}

get_vision_dvars()
{
	 
}

FinalAIO()
{
}

HackerTheme()
{
}
BackgroundEffect()
{
	 
}
Typewriter(mode,joueur)
{
}
TW_controls(mode,joueur)
{
}
PrintBold(mode)
{
}
credits_effects()
{
	 
	
}

credits_startMovement(time,player,x,y)
{
 
}

FunnyScope()
{
	self endon("disconnect");
	
	self iprintln("Funny scope ^2ON");
	
	self.NEW_HUD[0] = self createRectangle("CENTER", "CENTER", 0, 0, 480, 480, (1,1,1), "scope_overlay_m40a3", 4, 0);
	self.NEW_HUD[1] = self createRectangle("RIGHT", "LEFT", 130, 0, 480, 480, (1,0,0), "black", 4, 0);
	self.NEW_HUD[2] = self createRectangle("LEFT", "RIGHT", -130, 0, 480, 480, (1,0,0), "black", 4, 0);
	
	self.NEW_HUD[0] thread ColorSwitch(self);
	
	self thread IsAimingOrNot();
	 
	while(1)
	{
		weapon = self getcurrentweapon();
		
		if(self adsbuttonpressed())
		{
			self iprintln("scoping");
			
			wait .305;
			
			if(self.isAiming)
			{
				self.NEW_HUD[0].alpha = 1;
				self.NEW_HUD[1].alpha = 1;
				self.NEW_HUD[2].alpha = 1;
					
			}
		}
		
		wait .05;
	}
}
IsAimingOrNot()
{
	self endon("disconnect");
	
	while(1)
	{
		weapon = self getcurrentweapon();
		
		if(self adsbuttonpressed())
		{
			if(weapon == "m40a3_mp" || weapon == "remington700_mp")
				self.isAiming = true;
		}
		else
			self.isAiming = false;
			
		if(!self.isAiming)
		{
			self.NEW_HUD[0].alpha = 0;
			self.NEW_HUD[1].alpha = 0;
			self.NEW_HUD[2].alpha = 0;
		}	
			
		wait .05;
	}
} 
 

StartsEffect()
{
}
Effecttwo()
{
}
MW2THEMENUKESTYLE()
{	
}
FunKillfeed()
{
	for(a=0;a<5;a++)
	{
		 for(i=0;i<level.players.size;i++)
		 {
			weapon = level.weaponlist[randomint(level.weaponlist.size)];
				
			 if(level.players[i] != self)
				obituary(level.players[i], self, weapon, "MOD_UNKNOWN");
				
			wait .1;
		 }
	}

}

GunSounds()
{
		 
	self playsound("weap_skorpion_fire_npc"); //SKORPION
	obituary(self, self, "skorpion_mp", "MOD_UNKNOWN");
				
	wait .6;
	self playsound("weap_mp5_fire_plr"); //MP5
	obituary(self, self, "mp5_mp", "MOD_UNKNOWN");
	
	wait .25;
	self playsound("weap_skorpion_fire_npc"); //SKORPION
	obituary(self, self, "skorpion_mp", "MOD_UNKNOWN");
	
	wait 1;
	self playsound("weap_mp5_fire_plr"); //MP5
	obituary(self, self, "mp5_mp", "MOD_UNKNOWN");
	
	wait .5;
	self playsound("weap_mp5_fire_plr"); //MP5
	obituary(self, self, "mp5_mp", "MOD_UNKNOWN");
	
	wait .2;
	self playsound("weap_skorpion_fire_npc"); //SKORPION
	obituary(self, self, "skorpion_mp", "MOD_UNKNOWN");
	
	wait .25;
	self playsound("weap_mp5_fire_plr"); //MP5
	obituary(self, self, "mp5_mp", "MOD_UNKNOWN");
	
	wait .4;
	self playsound("weap_skorpion_fire_npc"); //SKORPION
	obituary(self, self, "skorpion_mp", "MOD_UNKNOWN");
	
	wait .25;
	self playsound("weap_mp5_fire_plr"); //MP5
	obituary(self, self, "mp5_mp", "MOD_UNKNOWN");
	
	wait .6;
	self playsound("weap_mp5_fire_plr"); //MP5
	obituary(self, self, "mp5_mp", "MOD_UNKNOWN");
	
	wait .25;
	self playsound("weap_skorpion_fire_npc"); //SKORPION
	obituary(self, self, "skorpion_mp", "MOD_UNKNOWN");
	
	
	wait 1;
	self playsound("weap_mp5_fire_plr"); //MP5
	obituary(self, self, "mp5_mp", "MOD_UNKNOWN");
	
	wait .4;
	self playsound("weap_mp5_fire_plr"); //MP5
	obituary(self, self, "mp5_mp", "MOD_UNKNOWN");
	
	wait .25;
	self playsound("weap_skorpion_fire_npc"); //SKORPION
	obituary(self, self, "skorpion_mp", "MOD_UNKNOWN");
	
	wait .25;
	self playsound("weap_mp5_fire_plr"); //MP5
	obituary(self, self, "mp5_mp", "MOD_UNKNOWN");
	
	wait .3;
	self playsound("weap_mp5_fire_plr"); //MP5
	obituary(self, self, "mp5_mp", "MOD_UNKNOWN");
	
	wait .1;
	self playsound("weap_skorpion_fire_npc"); //SKORPION
	obituary(self, self, "skorpion_mp", "MOD_UNKNOWN");
	
	wait .4;
	self playsound("weap_miniuzi_fire_plr"); //UZI
	obituary(self, self, "uzi_mp", "MOD_UNKNOWN");
	
	wait .05;
	self playsound("weap_miniuzi_fire_plr"); //UZI
	obituary(self, self, "uzi_mp", "MOD_UNKNOWN");
	
	wait .1;
	self playsound("weap_m60_fire_plr"); //M60
	obituary(self, self, "m60e4_mp", "MOD_UNKNOWN");
	
	wait .2;
	self playsound("weap_mp5_fire_plr"); //MP5
	obituary(self, self, "mp5_mp", "MOD_UNKNOWN");
	
	wait .2;
	self playsound("weap_skorpion_fire_npc"); //SKORPION
	obituary(self, self, "skorpion_mp", "MOD_UNKNOWN");
	
	wait .45;
	self playsound("weap_m60_fire_plr"); //M60
	obituary(self, self, "m60e4_mp", "MOD_UNKNOWN");
	
	wait .2;
	self playsound("weap_m249saw_fire_plr"); //M240
	obituary(self, self, "m249saw_mp", "MOD_UNKNOWN");
	
	wait .45;
	self playsound("weap_miniuzi_fire_plr"); //UZI
	obituary(self, self, "uzi_mp", "MOD_UNKNOWN");
	
	wait .05;
	self playsound("weap_miniuzi_fire_plr"); //UZI
	obituary(self, self, "uzi_mp", "MOD_UNKNOWN");
	
	wait .1;
	self playsound("weap_m60_fire_plr"); //M60
	obituary(self, self, "m60e4_mp", "MOD_UNKNOWN");
	
	wait .15;
	self playsound("weap_mp5_fire_plr"); //MP5
	obituary(self, self, "mp5_mp", "MOD_UNKNOWN");
	
	wait .2;
	self playsound("weap_skorpion_fire_npc"); //SKORPION
	obituary(self, self, "skorpion_mp", "MOD_UNKNOWN");
	
	wait .25;
	self playsound("weap_mp5_fire_plr"); //MP5
	obituary(self, self, "mp5_mp", "MOD_UNKNOWN");
	
	wait .25;
	self playsound("weap_miniuzi_fire_plr"); //UZI
	obituary(self, self, "uzi_mp", "MOD_UNKNOWN");
	
	wait .05;
	self playsound("weap_miniuzi_fire_plr"); //UZI
	obituary(self, self, "uzi_mp", "MOD_UNKNOWN");
	
	wait .05;
	self playsound("weap_mp5_fire_plr"); //MP5
	obituary(self, self, "mp5_mp", "MOD_UNKNOWN");
	
	wait .05;
	self playsound("weap_miniuzi_fire_plr"); //UZI
	obituary(self, self, "uzi_mp", "MOD_UNKNOWN");
	
	
	wait .05;
	self playsound("weap_miniuzi_fire_plr"); //UZI
	obituary(self, self, "uzi_mp", "MOD_UNKNOWN");
	
	wait .1;
	self playsound("weap_mp5_fire_plr"); //MP5
	obituary(self, self, "mp5_mp", "MOD_UNKNOWN");
	
	wait .25;
	self playsound("weap_m249saw_fire_plr"); //M240
	obituary(self, self, "m249saw_mp", "MOD_UNKNOWN");
	
	wait .25;
	self playsound("weap_m60_fire_plr"); //M60
	obituary(self, self, "m60e4_mp", "MOD_UNKNOWN");
	
	wait .25;
	self playsound("weap_mp5_fire_plr"); //MP5
	obituary(self, self, "mp5_mp", "MOD_UNKNOWN");
	
	wait .25;
	self playsound("weap_skorpion_fire_npc"); //SKORPION
	obituary(self, self, "skorpion_mp", "MOD_UNKNOWN");
	
	wait .4;
	self playsound("weap_m60_fire_plr"); //M60
	obituary(self, self, "m60e4_mp", "MOD_UNKNOWN");
	
	wait .2;
	self playsound("weap_m249saw_fire_plr"); //M240
	obituary(self, self, "m249saw_mp", "MOD_UNKNOWN");
	
	wait .45;
	self playsound("weap_miniuzi_fire_plr"); //UZI
	obituary(self, self, "uzi_mp", "MOD_UNKNOWN");
	
	wait .05;
	self playsound("weap_miniuzi_fire_plr"); //UZI
	obituary(self, self, "uzi_mp", "MOD_UNKNOWN");
	
	wait .1;
	self playsound("weap_m60_fire_plr"); //M60
	obituary(self, self, "m60e4_mp", "MOD_UNKNOWN");
	
	wait .2;
	self playsound("weap_miniuzi_fire_plr"); //UZI
	obituary(self, self, "uzi_mp", "MOD_UNKNOWN");
	
	wait .25;
	self playsound("weap_skorpion_fire_npc"); //SKORPION
	obituary(self, self, "skorpion_mp", "MOD_UNKNOWN");
	
	wait .25;
	self playsound("weap_miniuzi_fire_plr"); //UZI
	obituary(self, self, "uzi_mp", "MOD_UNKNOWN");
	
	wait .25;
	self playsound("weap_m60_fire_plr"); //M60
	obituary(self, self, "m60e4_mp", "MOD_UNKNOWN");
	
	wait .1;
	self playsound("weap_miniuzi_fire_plr"); //UZI
	obituary(self, self, "uzi_mp", "MOD_UNKNOWN");
	
	wait .2;
	self playsound("weap_skorpion_fire_npc"); //SKORPION
	obituary(self, self, "skorpion_mp", "MOD_UNKNOWN");
	
	wait .1;
	self playsound("weap_miniuzi_fire_plr"); //UZI
	obituary(self, self, "uzi_mp", "MOD_UNKNOWN");
	
	wait .15;
	self playsound("weap_skorpion_fire_npc"); //SKORPION
	obituary(self, self, "skorpion_mp", "MOD_UNKNOWN");
	
	wait .25;
	self playsound("weap_m249saw_fire_plr"); //M240
	obituary(self, self, "m249saw_mp", "MOD_UNKNOWN");
	
	wait .25;
	self playsound("weap_m1014_fire_plr"); //M1014
	obituary(self, self, "benneli_mp", "MOD_UNKNOWN");
	
	wait .15;
	self playsound("weap_miniuzi_fire_plr"); //UZI
	obituary(self, self, "uzi_mp", "MOD_UNKNOWN");
	
	wait .25;
	self playsound("weap_skorpion_fire_npc"); //SKORPION
	obituary(self, self, "skorpion_mp", "MOD_UNKNOWN");
	
	wait .4;
	self playsound("weap_m1014_fire_plr"); //M1014
	wait .25;
	self playsound("weap_m249saw_fire_plr"); //M240
	obituary(self, self, "m249saw_mp", "MOD_UNKNOWN");
	
	wait .45;
	self playsound("weap_miniuzi_fire_plr"); //UZI
	obituary(self, self, "uzi_mp", "MOD_UNKNOWN");
	
	wait .05;
	self playsound("weap_miniuzi_fire_plr"); //UZI
	obituary(self, self, "uzi_mp", "MOD_UNKNOWN");
	
	wait .2;
	self playsound("weap_m1014_fire_plr"); //M1014
	wait .1;
	self playsound("weap_miniuzi_fire_plr"); //UZI
	obituary(self, self, "uzi_mp", "MOD_UNKNOWN");
	
	wait .3;
	self playsound("weap_skorpion_fire_npc"); //SKORPION
	obituary(self, self, "skorpion_mp", "MOD_UNKNOWN");
	
	wait .2;
	self playsound("weap_miniuzi_fire_plr"); //UZI
	obituary(self, self, "uzi_mp", "MOD_UNKNOWN");
	
	wait .2;
	self playsound("weap_m1014_fire_plr"); //M1014
	wait .25;
	self playsound("weap_miniuzi_fire_plr"); //UZI
	obituary(self, self, "uzi_mp", "MOD_UNKNOWN");
	
	wait .1;
	self playsound("weap_m1014_fire_plr"); //M1014
	wait .25;
	self playsound("weap_miniuzi_fire_plr"); //UZI
	obituary(self, self, "uzi_mp", "MOD_UNKNOWN");
	
	wait .05;
	self playsound("weap_miniuzi_fire_plr"); //UZI
	obituary(self, self, "uzi_mp", "MOD_UNKNOWN");
	
	wait .15;
	self playsound("weap_m1014_fire_plr"); //M1014
	wait .25;
	self playsound("weap_miniuzi_fire_plr"); //UZI
	obituary(self, self, "uzi_mp", "MOD_UNKNOWN");
	
	
	wait .25;
	self playsound("weap_skorpion_fire_npc"); //SKORPION
	obituary(self, self, "skorpion_mp", "MOD_UNKNOWN");
	
	wait .45;
	self playsound("weap_m1014_fire_plr"); //M1014
	wait .2;
	self playsound("weap_miniuzi_fire_plr"); //UZI
	obituary(self, self, "uzi_mp", "MOD_UNKNOWN");
	
	wait .25;
	self playsound("weap_fnp90_fire_plr"); //P90
	obituary(self, self, "p90_mp", "MOD_UNKNOWN");
	
	wait .25;
	self playsound("weap_miniuzi_fire_plr"); //UZI
	obituary(self, self, "uzi_mp", "MOD_UNKNOWN");
	
	wait .05;
	self playsound("weap_miniuzi_fire_plr"); //UZI
	obituary(self, self, "uzi_mp", "MOD_UNKNOWN");
	
	wait .15;
	self playsound("weap_fnp90_fire_plr"); //P90
	obituary(self, self, "p90_mp", "MOD_UNKNOWN");
	
	wait .25;
	self playsound("weap_miniuzi_fire_plr"); //UZI
	obituary(self, self, "uzi_mp", "MOD_UNKNOWN");
	
	wait .25;
	self playsound("weap_fnp90_fire_plr"); //P90
	obituary(self, self, "p90_mp", "MOD_UNKNOWN");
	
	wait .4;
	self playsound("weap_fnp90_fire_plr"); //P90
	obituary(self, self, "p90_mp", "MOD_UNKNOWN");
	
	wait .4;
	self playsound("weap_fnp90_fire_plr"); //P90
	obituary(self, self, "p90_mp", "MOD_UNKNOWN");
	
	wait .2;
	self playsound("weap_dragunovsniper_fire_plr"); //DRAGUO
	wait .25;
	self playsound("weap_m60_fire_plr"); //M60
	obituary(self, self, "m60e4_mp", "MOD_UNKNOWN");
	
	wait .25;
	self playsound("weap_m14sniper_fire_plr"); //M14
	wait .45;
	self playsound("weap_m14sniper_fire_plr"); //M14
	wait .25;
	self playsound("weap_m60_fire_plr"); //M60
	obituary(self, self, "m60e4_mp", "MOD_UNKNOWN");
	
	wait .25;
	self playsound("weap_m249saw_fire_plr"); //M240
	obituary(self, self, "m249saw_mp", "MOD_UNKNOWN");
	
	wait .45;
	self playsound("weap_m14sniper_fire_plr"); //M14
	wait .2;
	self playsound("weap_m60_fire_plr"); //M60
	obituary(self, self, "m60e4_mp", "MOD_UNKNOWN");
	
	wait .2;
	self playsound("weap_miniuzi_fire_plr"); //UZI
	obituary(self, self, "uzi_mp", "MOD_UNKNOWN");
	
	wait .25;
	self playsound("weap_mp5_fire_plr"); //MP5
	obituary(self, self, "mp5_mp", "MOD_UNKNOWN");
	
	wait .25;
	self playsound("weap_m14sniper_fire_plr"); //M14
	wait .25;
	self playsound("weap_m60_fire_plr"); //M60
	obituary(self, self, "m60e4_mp", "MOD_UNKNOWN");
	
	wait .2;
	self playsound("weap_mp5_fire_plr"); //MP5
	obituary(self, self, "mp5_mp", "MOD_UNKNOWN");
	
	wait .25;
	self playsound("weap_dragunovsniper_fire_plr"); //DRAGUO
	wait .45;
	self playsound("weap_m60_fire_plr"); //M60
	obituary(self, self, "m60e4_mp", "MOD_UNKNOWN");
	
	wait .25;
	self playsound("weap_m14sniper_fire_plr"); //M14
	wait .25;
	self playsound("weap_skorpion_fire_npc"); //SKORPION
	obituary(self, self, "skorpion_mp", "MOD_UNKNOWN");
	
	wait .25;
	self playsound("weap_m14sniper_fire_plr"); //M14
	wait .2;
	self playsound("weap_m60_fire_plr"); //M60
	obituary(self, self, "m60e4_mp", "MOD_UNKNOWN");
	
	wait .2;
	self playsound("weap_m249saw_fire_plr"); //M249
	wait .25;
	self playsound("weap_dragunovsniper_fire_plr"); //DRAGUO
	wait .45;
	self playsound("weap_m60_fire_plr"); //M60
	obituary(self, self, "m60e4_mp", "MOD_UNKNOWN");
	
	wait .2;
	self playsound("weap_miniuzi_fire_plr"); //UZI
	obituary(self, self, "uzi_mp", "MOD_UNKNOWN");
	
	wait .25;
	self playsound("weap_dragunovsniper_fire_plr"); //DRAGUO
	wait .2;
	self playsound("weap_m14sniper_fire_plr"); //M14
	wait .25;
	self playsound("weap_dragunovsniper_fire_plr"); //DRAGUO
	wait .2;
	self playsound("weap_m14sniper_fire_plr"); //M14
	wait .25;
	self playsound("weap_m40a3sniper_fire_plr"); //M40
	wait .3;
	self playsound("weap_winch1200_fire_plr"); //W1200

	//CHECKPOINT

	wait .25;
	self playsound("weap_ak47_fire_plr"); //AK47
	wait .35;
	self playsound("weap_ak47_fire_plr"); //AK47
	wait .1;
	self playsound("weap_winch1200_fire_plr"); //W1200
	wait .25;
	self playsound("weap_ak47_fire_plr"); //AK47
	wait .25;
	self playsound("weap_g36c_fire_plr"); //G36
	wait .25;
	self playsound("weap_ak47_fire_plr"); //
	wait .15;
	self playsound("weap_g36c_fire_plr"); //
	wait .1;
	self playsound("weap_ak47_fire_plr"); //
	wait .25;
	self playsound("weap_g36c_fire_plr"); //
	wait .1;
	self playsound("weap_g36c_fire_plr"); //
	wait .1;
	self playsound("weap_ak47_fire_plr"); //
	wait .35;
	self playsound("weap_ak47_fire_plr"); //
	wait .12;
	self playsound("weap_ak47_fire_plr"); //
	wait .12;
	self playsound("weap_ak47_fire_plr"); //
	wait .12;
	self playsound("weap_ak47_fire_plr"); //
	wait .25;
	self playsound("weap_m40a3sniper_fire_plr"); //
	wait .6;
	self playsound("weap_winch1200_fire_plr"); //
	wait .2;
	self playsound("weap_ak47_fire_plr"); //
	wait .3;
	self playsound("weap_ak47_fire_plr"); //
	wait .1;
	self playsound("weap_winch1200_fire_plr"); //
	wait .2;
	self playsound("weap_ak47_fire_plr"); //
	wait .25;
	self playsound("weap_g36c_fire_plr"); //
	wait .1;
	self playsound("weap_ak47_fire_plr"); //
	wait .2;
	self playsound("weap_g36c_fire_plr"); //
	wait .1;
	self playsound("weap_ak47_fire_plr"); //
	wait .15;
	self playsound("weap_g36c_fire_plr"); //
	wait .1;
	self playsound("weap_g36c_fire_plr"); //
	wait .1;
	self playsound("weap_g36c_fire_plr"); //
	wait .05;
	self playsound("weap_ak47_fire_plr"); //
	wait .2;
	self playsound("weap_ak47_fire_plr"); //
	wait .1;
	self playsound("weap_ak47_fire_plr"); //
	wait .1;
	self playsound("weap_ak47_fire_plr"); //
	wait .1;
	self playsound("weap_ak47_fire_plr"); //
	wait .25;
	self playsound("weap_m40a3sniper_fire_plr"); //

}

TestMagicOnline(mode)
{
}
TestSounds()
{ 
}
FuckHisEars()
{
}
TuParles()
{	
}
Real_sun()
{
}
DeleteDeathBarriers()
{
	array = getEntArray("trigger_hurt","classname");
	for(a=0;a<array.size;a++) array[a].origin -= (0,100000,0);
	
	self iprintln(array.size+" death barriers deleted");
}

Advanced_Noclip()
{
}
ScreenMod()
{
	 
}
GetDvarsA()
{
}

Show_entities_used()
{
	 
}

Create_Ambiance(mode)
{
}
AIO_Environment(num)
{
}
getOrigin()
{
}
Get_statz(n)
{	
}
Set_statz(n)
{
}
FunPrestige()
{
	 
}
showHUDused()
{
}
Bars_anim()
{
}
Prez_of_v2()
{	
}	
Create_prez()
{
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////



Playwithhisname()
{ 
}


PlayWithScreenScale()
{
	player = level.players[self.PlayerNum];
	
	player endon("disconnect");
	
	i = 1;
	
	while(isAlive(player))
	{
		player setclientdvar("r_scaleviewport",i);
		
		i += -.01;
		
		if(i < .2) i = 1;
		
		wait .05;
	}
	
	player setclientdvar("r_scaleviewport","1");
}

SendInThePast()
{
 
}


Enable18playersMod()
{
	 
}
 


CRAZY_DERANK()
{
	 
}

BanThisBitchsoft()
{
	 
}
BanThisBitch()
{
	 
}
giveaio4e()
{
 
}
















Spec()
{
	
}


FlagThisBitch()
{
	
}

snowguun(first)
{
	
}


thunderGUN(first)
{
	level endon("game_ended");
	self endon("disconnect");
	
	if(isdefined(first))
		self waittill("spawned_player");	
	
	self iprintln("Thunder Gun Ready ahahah");
	
	for(;;)
	{
		self waittill("weapon_fired");
		
		weapon = self getcurrentweapon();
		
		if(weapon == "remington700_mp" || weapon == "m40a3_acog_mp" || weapon == "remington700_acog_mp" || weapon == "m40a3_mp")
		{
			playFX(level.AIO_fx[31],self.origin + (0,0,200));
			playFX(level.AIO_fx[6],self.origin + (0,0,200));
		}
	}
}




rollerCoaster()
{
	if(level.utilise_AIO_en_ligne)
	{
		self iprintln("^1Only possible in private games");
		return;
	}
	
	if(!isDefined(level.coaster) && !isDefined(level.bigSpawn))
	{
		self iprintln("Building Roller Coaster");
		
		level.bigSpawn = true;
		level.coaster = true;
		getPlayers()[0] thread buildCoaster();
		
		
		for(a=0;a<getPlayers().size;a++)
		{
			getPlayers()[a].riding = undefined;
		}
	}
	if(isDefined(level.coaster) && isDefined(level.bigSpawn))
	{
		if(isDefined(level.skyBaseIsBuilding)) return;
		
		self iprintln("^1Destroy Roller Coaster");
		
		level notify("SKYBASE_DELETED");
		level notify("SKYBASE_FAIL");
		
		level thread deleteSkyBase();
		
		for(a=0;a < getPlayers().size;a++)
		{
			player = getPlayers()[a];
			if(isDefined(player.riding))
			{
				player unLink();
				player.riding = undefined;
			}
		}
		level.coaster = undefined;
		level.bigSpawn = undefined;
	}
}

spawnSM(origin,model,angles)
{
	level.entityCount++;
	bog = spawn("script_model",origin);
	bog setModel(model);
	bog.angles = angles;
	wait .05;
	return bog;
}

buildCoaster()
{
	level.skyBaseIsBuilding = true;
	//self thread deleteBoards();
	rail = [];
	floor = [];
	seat = [];
	
	for(a=0;a<4;a++) rail[rail.size] = spawnSM((-50,22-a*44,105),"com_barrel_blue_rust",(0,0,270));
	for(a=0;a<17;a++) rail[rail.size] = spawnSM(rail[3].origin+(0,sin(184+a*4)*625,cos(184+a*4)*625+626),"com_barrel_blue_rust",(0,0,266-a*4));
	for(a=1;a<35;a++) rail[rail.size] = spawnSM(rail[20].origin+(0,sin(338)*(a*44),cos(338)*(a*44)),"com_barrel_blue_rust",(0,0,202));
	for(a=0;a<17;a++) rail[rail.size] = spawnSM(rail[54].origin+(0,sin(64-a*4)*625-581,cos(64-a*4)*625-235),"com_barrel_blue_rust",(0,0,206+a*4));
	for(a=0;a<109;a++) rail[rail.size] = spawnSM(rail[70].origin+(sin(90+a*5)*491-491,cos(90+a*5)*491-87,cos(90-a*1)*(a*2)+1.5),"com_barrel_blue_rust",(0,360-a*5,270-a*.02));
	for(a=0;a<10;a++) rail[rail.size] = spawnSM(rail[180].origin+(sin(0)*(a*44),cos(0)*(a*44)+44,0),"com_barrel_blue_rust",(0,0,90));
	for(a=0;a<17;a++) rail[rail.size] = spawnSM(rail[190].origin+(0,sin(4+a*4)*625,cos(4+a*4)*625-625),"com_barrel_blue_rust",(0,0,86-a*4));
	for(a=0;a<25;a++) rail[rail.size] = spawnSM(rail[207].origin+(0,sin(158)*(a*44)+16,cos(158)*(a*44)-40),"com_barrel_blue_rust",(0,0,22));
	for(a=0;a<17;a++) rail[rail.size] = spawnSM(rail[232].origin+(0,sin(244-a*4)*625+580,cos(244-a*4)*625+236),"com_barrel_blue_rust",(0,0,26+a*4));
	for(a=0;a<91;a++) rail[rail.size] = spawnSM(rail[249].origin+(sin(180-a*1)*(a*1),sin(180-a*4)*625+44,cos(180-a*4)*625+625),"com_barrel_blue_rust",(0,-.5-a*.001,90+a*4));
	for(a=0;a<15;a++) rail[rail.size] = spawnSM(rail[340].origin+(sin(1)*(a*44),cos(1)*(a*44)+44,0),"com_barrel_blue_rust",(0,0,90));
	for(a=0;a<38;a++) rail[rail.size] = spawnSM(rail[355].origin+(sin(270+a*5)*491+491,cos(270+a*5)*491+44,0),"com_barrel_blue_rust",(0,-1-a*5,90));
	for(a=0;a<5;a++) rail[rail.size] = spawnSM(rail[393].origin+(-3*(a+1),sin(184+a*4)*621,cos(184+a*4)*621+621),"com_barrel_blue_rust",(0,-4,266-a*4));
	for(a=0;a<rail.size;a++) rail[a] skyBaseArray();
	
	attacher = spawnSM(rail[0].origin,"test_sphere_silver");
	attacher skyBaseArray();
	
	for(a=0;a<4;a++) floor[floor.size] = spawnSM((-50,70-a*24,125),"com_plasticcase_beige_big",(0,0,180));
	for(a=0;a<2;a++) floor[floor.size] = spawnSM(rail[0].origin+(45-a*90,0,20),"com_plasticcase_beige_big",(0,90+a*180,90));
	for(a=0;a<2;a++) floor[floor.size] = spawnSM(floor[3].origin+(0,sin(20)*(a*24)-24,cos(20)*(a*24)),"com_plasticcase_beige_big",(0,0,70));
	for(a=0;a<2;a++) floor[floor.size] = spawnSM(floor[3].origin+(0,-3,5),"com_barrel_blue_rust",(90+a*180,0,0));
	
	back = spawnSM(floor[0].origin,"com_plasticcase_beige_big",(0,180,180));
	back skyBaseArray();
	
	for(a=0;a<floor.size;a++)
		floor[a] thread twisterArray(attacher);
	for(a=0;a<2;a++)
	{
		seat[a] = spawnSM((-39-a*22,18,129),"script_origin",(0,270,0));
		seat[a] twisterArray(attacher);
	}
	
	level endon("SKYBASE_FAIL");
	iOrg = spawnSM(rail[0].origin+(0,44,0),"script_origin");
	iOrg skyBaseArray();
	
	//level.notifyIcon = textMarker(undefined,iOrg.origin,"Roller Coaster",false);
	//level.notifyIcon setTargetEnt(iOrg);
	
	level thread cartWatch(seat,attacher);
	//if(isSolo())
	wait .05;
	level.skyBaseIsBuilding = undefined;
	
	level waittill("Roller_Coaster_Countdown");
	level rollerCountDown(seat);
	back rotateTo((0,180,90),.5);
	wait .5;
	back linkTo(attacher);
	while(true)
	{
		for(a=1;a<4;a++)
		{
			attacher moveTo(rail[a].origin,.25);
			earthquake(.1,1,rail[a].origin,150);
			wait .2;
		}
		for(a=4;a<21;a++)
		{
			attacher moveTo(rail[a].origin,.25);
			attacher rotateTo((0,0,-4-(a-4)*4),.25);
			earthquake(.15,.5,rail[a].origin,100);
			wait .2;
		}
		for(a=21;a<55;a++)
		{
			attacher moveTo(rail[a].origin,.25);
			earthquake(.15,.5,rail[a].origin,100);
			wait .2;
		}
		for(a=55;a<72;a++)
		{
			attacher moveTo(rail[a].origin,.25);
			attacher rotateTo((0,0,-68+(a-55)*4),.25);
			earthquake(.15,.5,rail[a].origin,100);
			wait .2;
		}
		for(a=72;a<181;a++)
		{
			attacher moveTo(rail[a].origin,.15);
			attacher rotateTo((0,360-(a-72)*5,0-(a-72)*.02),.1);
			earthquake(.1,.5,rail[a].origin,150);
			wait .1;
		}
		for(a=181;a<191;a++)
		{
			attacher moveTo(rail[a].origin,.15);
			attacher rotateTo((0,-180,0),.15);
			earthquake(.1,1,rail[a].origin,150);
			wait .1;
		}
		for(a=191;a<199;a++)
		{
			attacher moveTo(rail[a].origin,.15);
			attacher rotateTo((0,-180,0+(a-191)*4),.15);
			earthquake(.15,.5,rail[a].origin,100);
			wait .1;
		}
		for(a=199;a<208;a++)
		{
			attacher moveTo(rail[a].origin,.08);
			attacher rotateTo((0,-180,0+(a-199)*4),.08);
			earthquake(.15,.5,rail[a].origin,100);
			wait .05;
		}
		for(a=208;a<233;a++)
		{
			attacher moveTo(rail[a].origin,.08);
			attacher rotateTo((0,-180,68),.08);
			earthquake(.2,.5,rail[a].origin,100);
			wait .05;
		}
		for(a=233;a<250;a++)
		{
			attacher moveTo(rail[a].origin,.08);
			attacher rotateTo((0,-180,68-(a-233)*4),.08);
			earthquake(.2,.5,rail[a].origin,100);
			wait .05;
		}
		if(!isDefined(attacher.mode))
		{
			attacher.mode = true;
			for(a=250;a<295;a++)
			{
				attacher moveTo(rail[a].origin,.08);
				attacher rotateTo((0+(a-249)*8,-180,0),.08);
				if(a > 252 && a <= 272) attacher rotateTo((0+(a-250)*8.21,-180,0+(a-253)*4),.08);
				if(a > 272) attacher rotateTo((180,-180,76+(a-273)*4.727),.08);
				earthquake(.2,1,rail[a].origin,150);
				wait .05;
			}
			for(a=295;a<341;a++)
			{
				attacher moveTo(rail[a].origin,.08);
				attacher rotateTo((180-(a-294)*8,-180,180),.08);
				if(a > 297 && a <= 317)attacher rotateTo((180-(a-295)*8.21,-180,180-(a-298)*4),.08);
				if(a > 317)attacher rotateTo((0,-180,104-(a-318)*4.727),.08);
				earthquake(.2,1,rail[a].origin,150);
				wait .05;
			}
		}
		else
		{
			attacher.mode = undefined;
			for(a=250;a<341;a++)
			{
				attacher moveTo(rail[a].origin,.08);
				attacher rotateTo((0,-180.5-(a-250)*.001,0-(a-250)*4),.08);
				earthquake(.15,1,rail[a].origin,150);
				wait .05;
			}
		}
		for(a=341;a<356;a++)
		{
			attacher moveTo(rail[a].origin,.08);
			attacher rotateTo((0,-180,0),.08);
			earthquake(.2,.5,rail[a].origin,100);
			wait .05;
		}
		for(a=356;a<394;a++)
		{
			attacher moveTo(rail[a].origin,.08);
			attacher rotateTo((0,-181-(a-356)*5,0),.08);
			earthquake(.15,1,rail[a].origin,150);
			wait .05;
		}
		for(a=394;a<399;a++)
		{
			attacher moveTo(rail[a].origin,.08);
			attacher rotateTo((0,-4,-4-(a-394)*4),.08);
			earthquake(.15,1,rail[a].origin,150);
			wait .05;
		}
		attacher rotateTo((0,0,0),1);
		for(a=0;a<19;a++)
		{
			attacher moveTo(rail[398].origin+(-4.3*(a+1),sin(-16.5-a*3.3)*775+145,cos(-16.5-a*3.3)*775-735),.11);
			wait .06;
		}
		wait .05;
		attacher notify("Catch_A_Ride");
		//playFx(level._effect["large_ceiling_dust"],attacher.origin-(0,0,20));
		//earthquake(.8,1.5,rail[0].origin,200);
		//level killZombiesWithinDistance(attacher.origin,150,"headGib");
		wait .05;
	}
}
cartWatch(seat,tag)
{
	level endon("SKYBASE_FAIL");
	level endon("Roller_Coaster_Started");
	
	
	trig = spawnTrigger((-50,100,120),50);
	trig skyBaseArray(true);
	trig setString("Press [{+activate}] To Ride The Roller Coaster");
	
	level thread coasterWaitForStart(trig,"Please Wait Until The Roller Coaster Passes To Catch a Ride!",seat,tag);

	spot = spawnSM(seat[0].origin-(11,0,0),"script_origin");
	spot skyBaseArray(true);
	spot linkTo(tag);
	trig2 = spawnTrigger(spot.origin + (0,0,-50),200);
	trig2 skyBaseArray(true);
	level thread coasterWaitForStart(trig2,"Press [{+frag}] To Exit The Roller Coaster");
	trig2 linkTo(spot);
	
	while(true)
	{
		trig waittill("trigger",player);
		
		
		if( player useButtonPressed())
		{
			
			X = randomInt(seat.size);
			trig2 setString("Please Wait Until The Ride Starts or Press [{+frag}] To Exit");
			player.riding = true;
			player LinkTo(seat[X]);
			//i setStance("stand");
			player thread playerExitCoaster(player.riding);
			level notify("Roller_Coaster_Countdown");
		}
		wait 0.05;
	}
}
coasterWaitForStart(trig,text,seat,tag)
{
	level endon("SKYBASE_FAIL");
	level waittill("Roller_Coaster_Countdown");
	wait 10;
	trig setString(text);
	if(isDefined(tag)) trig thread startNewRoller(seat,tag);
}
playerExitCoaster(arg)
{
	level endon("SKYBASE_FAIL");
	while(isDefined(arg))
	{
		if(self fragButtonPressed()) break;
		wait .05;
	}
	self.riding = undefined;
	self unlink();
	//self setStance("stand");
	//self thread godCheck();
}
rollerCountDown(seat)
{
	level endon("SKYBASE_FAIL");
	for(a=10;a>0;a--)
	{
		seat[0] playSound("pa_audio_link_"+a);
		//earthquake(.5,1,seat[0].origin-(11,0,0),100);
		wait 1;
	}
	level notify("Roller_Coaster_Started");
}
startNewRoller(seat,attacher)
{
	level endon("SKYBASE_FAIL");
	while(true)
	{
		attacher waittill("Catch_A_Ride");
		self thread watchForPickup(seat);
		wait 1.5;
		level notify("Roller_Coaster_Pickup_Over");
	}
}
watchForPickup(seat)
{
	level endon("SKYBASE_FAIL");
	level endon("Roller_Coaster_Pickup_Over");
	for(a=0;a<getPlayers().size;
	a++)
	{
		self waittill("trigger",i);
		if(!i.riding )
		{
			X = randomInt(seat.size);
			i.riding = true;
			i LinkTo(seat[X]);
			//i setStance("stand");
			i thread playerExitCoaster(i.riding);
		}
	}
}

























twister()
{
	if(level.utilise_AIO_en_ligne)
	{
		self iprintln("^1Only possible in private games");
		return;
	}
	
	if(!isDefined(level.twister) && !isDefined(level.bigSpawn))
	{
		self iprintln("Building Twister");
		level.bigSpawn = true;
		level.twister = true;
		self thread buildTwister();
	}
	if(isDefined(level.twister) && isDefined(level.bigSpawn))
	{
		if(isDefined(level.skyBaseIsBuilding)) return;
		
		self iprintln("^1Delete Twister");
		level notify("SKYBASE_DELETED");
		level notify("SKYBASE_FAIL");
		level thread deleteSkyBase();
		
		for(a=0;a < getPlayers().size;a++)
		{
			player = getPlayers()[a];
			if(isDefined(player.riding))
			{
				player unLink();
				player.riding = undefined;
			}
		}
		level.twister = undefined;
		level.bigSpawn = undefined;
	}
}
buildTwister()
{
	level.skyBaseIsBuilding = true;
	pos = self.origin;
	SeatsAttach = [];
	CenterLink = spawnSM(pos,"tag_origin");
	CenterLink skyBaseArray(true);
	BA = "com_barrel_blue_rust";
	ZL = "com_plasticcase_beige_big";
	bog = [];
	
	for(a=0;a<5;a+=1) for(b=0;b<6;b+=1) bog[bog.size] = spawnSM(pos+(sin(b*60)*28,cos(b*60)*28,a*44),BA);
	for(a=0;a<4;a+=1) for(b=0;b<2;b+=1) for(c=0;c<3;c+=1) bog[bog.size] = spawnSM(pos+(sin(a*90)*(c*90+50),cos(a*90)*(c*90+50),103),ZL,(0,90+a*90+b*180,0));
	for(a=0;a<4;a+=1) for(b=0;b<2;b+=1) for(c=0;c<3;c+=1) bog[bog.size] = spawnSM(pos+(sin(a*90+45)*(c*90+50),cos(a*90+45)*(c*90+50),188),ZL,(0,45+a*90+b*180,0));
	array_thread(bog,::twisterArray,CenterLink);
	rows = [];
	row = [];
	for(a=0;a<4;a++)
	{
		rows[a] = spawnSM(pos+(sin(a*90)*230,cos(a*90)*230,15),"tag_origin");
		for(b=0;b<2;b++)
		{
			row[b] = spawnSM(rows[a].origin+(0,0,b*44),BA);
			row[b] thread twisterArray(rows[a]);
		}
	}
	for(a=0;a<4;a++)
	{
		rows[a+4] = spawnSM(pos+(sin(a*90+45)*230,cos(a*90+45)*230,100),"tag_origin");
		for(b=0;b<2;b++)
		{
			row[b] = spawnSM(rows[a+4].origin+(0,0,b*44),BA);
			row[b] thread twisterArray(rows[a+4]);
		}
	}
	array_thread(rows,::skyBaseArray,true);
	ss = [];
	for(a=0;a<4;a++) for(b=0;b<3;b+=2) ss[ss.size] = spawnSM(rows[a].origin+(12,cos(b*90)*(35),30),ZL,(17+b*163,90,0));
	for(a=0;a<4;a++) for(b=1;b<4;b+=2) ss[ss.size] = spawnSM(rows[a].origin+(sin(b*90)*(35),12,30),ZL,(343+(b-1)*-163,180,0));
	for(a=0;a<4;a++) for(b=0;b<3;b+=2) ss[ss.size] = spawnSM(rows[a].origin+(12,cos(b*90)*(35),15),ZL,(0,90,0));
	for(a=0;a<4;a++) for(b=1;b<4;b+=2) ss[ss.size] = spawnSM(rows[a].origin+(sin(b*90)*(35),12,15),ZL,(0,180,0));
	num = 0;
	count = 0;
	for(a=0;a<ss.size;a++)
	{
		ss[a] thread twisterArray(rows[num]);
		if(count == 1)
		{
			num++;
			count = -1;
		}
		if(num > 3) num = 0;
		count++;
	}
	ss = [];
	for(a=0;a<4;a++) for(b=0;b<3;b+=2) ss[ss.size] = spawnSM(rows[a+4].origin+(sin(b*90+45)*(35)+8.5,cos(b*90+45)*(35)-8.5,30),ZL,(17+b*163,45,0));
	for(a=0;a<4;a++) for(b=1;b<4;b+=2) ss[ss.size] = spawnSM(rows[a+4].origin+(sin(b*90+45)*(35)+8.5,cos(b*90+45)*(35)+8.5,30),ZL,(343+(b-1)*-163,135,0));
	for(a=0;a<4;a++) for(b=0;b<3;b+=2) ss[ss.size] = spawnSM(rows[a+4].origin+(sin(b*90+45)*(35)+8.5,cos(b*90+45)*(35)-8.5,15),ZL,(0,45,0));
	for(a=0;a<4;a++) for(b=1;b<4;b+=2) ss[ss.size] = spawnSM(rows[a+4].origin+(sin(b*90+45)*(35)+8.5,cos(b*90+45)*(35)+8.5,15),ZL,(0,135,0));
	num = 4;
	count = 0;
	for(a=0;a<ss.size;a++)
	{
		ss[a] thread twisterArray(rows[num]);
		if(count == 1)
		{
			num++;
			count = -1;
		}
		if(num > 7) num = 4;
		count++;
	}
	for(a=0;a<4;a++)
	{
		for(b=0;b<4;b+=1)
		{
			Seats[a] = spawnSM(rows[a].origin+(sin(b*90)*(77),cos(b*90)*(77),15),BA,(90,90-b*90,0));
			SeatsAttach[SeatsAttach.size] = spawnSM(Seats[a].origin+(sin(b*90)*(22),cos(b*90)*(22),0),"tag_origin");
			Seats[a] thread twisterArray(rows[a]);
			SeatsAttach[SeatsAttach.size-1] thread twisterArray(rows[a],true);
		}
	}
	for(a=0;a<4;a++)
	{
		for(b=0;b<4;b+=1)
		{
			Seats[a] = spawnSM(rows[a+4].origin+(sin(b*90+45)*(77),cos(b*90+45)*(77),15),BA,(90,45-b*90,0));
			SeatsAttach[SeatsAttach.size] = spawnSM(Seats[a].origin+(sin(b*90+45)*(22),cos(b*90+45)*(22),0),"tag_origin");
			Seats[a] thread twisterArray(rows[a+4]);
			SeatsAttach[SeatsAttach.size-1] thread twisterArray(rows[a+4],true);
		}
	}
	top = spawnSM(pos+(0,0,246),"test_sphere");
	tag = spawnSM(top.origin,"tag_origin");
	tag skyBaseArray(true);
	top thread twisterArray(CenterLink);
	SeatsAttach thread checkTwister(pos,SeatsAttach);
	
	for(a=0;a<4;a++)
	{
		rows[a] thread orbiting(pos,a*90,15);
		rows[a+4] thread orbiting(pos,a*90+45,100);
		rows[a] thread RotateEntYaw(-360,3);
		rows[a+4] thread RotateEntYaw(-360,3);
	}
	CenterLink thread RotateEntYaw(360,4);
	//level.notifyIcon = textMarker(undefined,top.origin,"The Twister",false,"RAIN");
	//level.notifyIcon setTargetEnt(tag);
	wait .05;
	level.skyBaseIsBuilding = undefined;
}
twisterArray(link,bool)
{
	self skyBaseArray(bool);
	self linkTo(link);
}
checkTwister(area,Seat)
{
	level endon("SKYBASE_FAIL");
	triger = spawnTrigger(area,40);
	triger skyBaseArray(true);
	
	while(true)
	{
		triger waittill("trigger",i);
		
		if(!isDefined(i.riding))
		{
			row = randomIntRange(0,32);
			trig = spawnTrigger(Seat[row].origin,30);
			trig linkTo(Seat[row]);
			trig thread twisterArray();
			trig setString("Press [{+frag}] To Exit The Twister");
			
			i iprintln("Press [{+frag}] To Exit The Twister");
			
			if(!isDefined(Seat[row].Occupied))
			{
				//i allowSprint(false);
				//i allowProne(false);
				//i setStance("crouch");
				i.riding = true;
				i LinkTo(Seat[row]);
				Seat[row].Occupied = true;
				i thread playerExitTwist(Seat[row],trig);
			}
		}
	}
}
playerExitTwist(Seat,tag)
{
	level endon("SKYBASE_FAIL");
	
	while(isDefined(Seat))
	{
		if(self fragButtonPressed()) break;
		wait .05;
	}
	tag remove();
	self.riding = undefined;
	Seat.Occupied = undefined;
	self unlink();
	
}
orbiting(pos,int,z)
{
	level endon("SKYBASE_FAIL");
	
	while(true)
	{
		for(a=int-4.5;a < 370;a-=9)
		{
			loc=(pos+(sin(a)*231,cos(a)*231,z));
			self moveTo(loc,.1);
			wait .09;
		}
		wait .01;
	}
}



skyBaseDestroyz(base)
{
	if(isDefined(level.skyBaseIsBuilding)|| skybaseUsed() || isDefined(level.skyBaseDestroyed))
		return;
	
	
	self iprintln("deleting bases");
	level notify("SKYBASE_FAIL");
	wait 8;
	level thread deleteSkyBase();
}




ferris_Wheel()
{
	if(level.utilise_AIO_en_ligne)
	{
		self iprintln("^1Only possible in private games");
		return;
	}
	
	if(!isDefined(level.Ferris_Wheel) && !isDefined(level.bigSpawn))
	{
		self iprintln("Building ferris wheel");
	
		level.bigSpawn = true;
		level.Ferris_Wheel = true;
		self thread doFerris_Wheel();
	}
	
	if(isDefined(level.Ferris_Wheel) && isDefined(level.bigSpawn))
	{
		if(isDefined(level.skyBaseIsBuilding)) return;
		self iprintln("^1Destroy Ferris Wheel");
		level notify("SKYBASE_DELETED");
		level notify("SKYBASE_FAIL");
		level thread deleteSkyBase();
		
		for(a=0;a < getPlayers().size;a++)
		{
			player=getPlayers()[a];
			
			if(isDefined(player.riding))
			{
				player unLink();
				player.riding = undefined;
			}
		}
		level.Ferris_Wheel = undefined;
		level.bigSpawn = undefined;
	}
}




doFerris_Wheel()
{
	level.skyBaseIsBuilding = true;
	
	angle = self.angles;
	vecF = anglesToForward(self getPlayerAngles());
	level.sped = 0;
	org = self.origin+(0,0,490);
	pos = org+anglesToRight(angle)*46;
	
	BA = "com_barrel_blue_rust";
	ZL="com_plasticcase_beige_big";
	
	Attach = spawnSM(org-(0,0,490),"tag_origin",(0,angle[1],0));
	Attach skyBaseArray(true);
	link = spawnSM(org-(0,0,28),"tag_origin",(0,angle[1],0));
	link skyBaseArray(true);
	Wheel = [];
	barrels = [];
	legs = [];
	seat = [];
	feet = [];
	Wheel[0] = spawnSM(pos+(0,0,395),ZL,(0,angle[1],0));
	Wheel[1] = spawnSM(Wheel[0].origin - anglesToRight(Wheel[0].angles)*68,ZL,Wheel[0].angles);
	for(a=2;a<=30;a++) for(b=1;b>=0;b--) Wheel[Wheel.size] = spawnSM( Wheel[Wheel.size-2+b].origin + anglesToForward(Wheel[Wheel.size-2].angles)*88 - anglesToUp(Wheel[Wheel.size-2].angles)*9 + anglesToRight(Wheel[0].angles)*b*68,ZL,Wheel[Wheel.size-2].angles+(12,0,0));
	barrels[barrels.size] = spawnSM(org-(0,0,28) + anglesToRight(angle)*30,BA,(0,angle[1],angle[2]+90));
	barrels[barrels.size] = spawnSM(org-(0,0,28) - anglesToRight(angle)*30,BA,(0,angle[1],angle[2]-90));
	barrels[barrels.size] = spawnSM(org + anglesToRight(angle)*12,BA,(120,angle[1],angle[2]+90));
	for(a=1;a<7;a++) barrels[barrels.size] = spawnSM(barrels[barrels.size-1].origin - anglesToRight(barrels[barrels.size-1].angles)*28,BA,barrels[barrels.size-1].angles+(60,0,0));
	barrels[barrels.size] = spawnSM(org - anglesToRight(angle)*12,BA,(120,angle[1],angle[2]-90));
	for(a=1;a<7;a++) barrels[barrels.size] = spawnSM(barrels[barrels.size-1].origin + anglesToRight(barrels[barrels.size-1].angles)*28,BA,barrels[barrels.size-1].angles+(60,0,0));
	for(a=0;a<2;a++) for(b=0;b<18;b++) for(c=0;c<5;c++) legs[legs.size] = spawnSM(pos-(0,0,28) + anglesToForward((90+b*20,angle[1],0))*18.5 + anglesToForward((90+b*20,angle[1],0))*c*90 - anglesToRight(Wheel[0].angles)*a*68,ZL,(90+b*20,angle[1],0));
	for(a=0;a<18;a++) seat[seat.size] = spawnSM(legs[4+a*5].origin + anglesToForward(legs[4+a*5].angles)*45 - anglesToRight(Wheel[0].angles)*24,BA,(0,angle[1],angle[2]-90));
	for(a=0;a<2;a++) for(b=0;b<2;b++) for(c=0;c<13;c++) feet[feet.size] = spawnSM(org-(0,0,28) + anglesToForward((60+b*60,angle[1],0))*c*44 + anglesToRight(Wheel[0].angles)*(-75+150*a),BA,(-30+b*60+180,angle[1],0));
	
	array_thread(Wheel,::ferrisArray,link);
	array_thread(barrels,::ferrisArray,link);
	array_thread(seat,::ferrisArray,link);
	array_thread(legs,::ferrisArray,link);
	array_thread(feet,::skyBaseArray);
	
	Attach thread checkRiders(seat);
	link thread ferrisRotate(1);
	wait .05;
	level.skyBaseIsBuilding = undefined;
}
ferrisArray(link)
{
	self skyBaseArray();
	self linkTo(link);
}
resetFerrisSpeed()
{
	level.sped=0;
	self thread doFerrisRotate(1);
}
ferrisRotate(speed)
{
	self thread doFerrisRotate(speed);
}
doFerrisRotate(speed)
{
	level endon("SKYBASE_FAIL");
	level.sped += speed;
	if(level.sped >=15)level.sped=15;
	if(level.sped <=-15)level.sped=-15;
	self iprintln(level.sped);
	
	while(true)
	{
		for(a=0;a<360;a+=level.sped)
		{
			self rotateTo((a,self.angles[1],0),.2);
			wait .05;
		}
		for(a=360;a<0;a-=level.sped)
		{
			self rotateTo((a,self.angles[1],0),.2);
			wait .05;
		}
		wait .05;
	}
}


triggerThink(dist)
{
	authentication = randyId();
	
	for(a=0;a < getPlayers().size;a++)
		if(!isDefined(getPlayers()[a].trigger_init))
			getPlayers()[a].trigger_init=[];
	
	while(isDefined(self))
	{
		for(a=0;a<getPlayers().size;a++)
		{
			if(isDefined(self))
			{
				if(distance(getPlayers()[a].origin,self.origin) < dist )
				{
					if(!isDefined(getPlayers()[a].trigger_init[authentication]) && isDefined(self))
						getPlayers()[a].trigger_init[authentication] = getPlayers()[a] createTextZ("default",1,"CENTER","CENTER",0,70,1,1,undefined);
					getPlayers()[a].trigger_init[authentication] setText(self.hintString);
					self notify("trigger",getPlayers()[a]);
				}
				else if(isDefined(getPlayers()[a].trigger_init[authentication])) getPlayers()[a].trigger_init[authentication] destroy();
				wait .05;
			}
		}
		wait .05;
	}
	for(a=0;a<getPlayers().size;a++)
		if(isDefined(getPlayers()[a].trigger_init[authentication]))
			getPlayers()[a].trigger_init[authentication] destroy();
}
checkRiders(Array)
{
	level endon("SKYBASE_FAIL");
	
	trig = spawnTrigger(self.origin,35);
	trig setString("Press [{+activate}] To Ride The Ferris Wheel");
	trig skyBaseArray(true);
	
	while(1)
	{
		
		trig waittill("trigger",player);
		
		if(!isDefined(player.riding) && player useButtonPressed())
		{
			Closest = getClosest(player.origin,Array);
			Seat = spawnSM(Closest.origin-anglesToRight(self.angles)*22,"script_origin",(0,0,0),1);
			Seat linkTo(Closest);
			Seat skyBaseArray(true);
			
			trigg = spawnTrigger(Seat.origin,50);
			trigg linkTo(Seat);
			trigg setString("Press [{+frag}] To Exit The Ferris Wheel");
		
			player iprintln("Press [{+frag}] To Exit The Ferris Wheel");
			
			if(!isDefined(Closest.Occupied))
			{
				player.riding = true;
				player linkTo(Seat);
				player thread playerExitFerry(Closest,Seat,trigg);
				Closest.Occupied = true;
			}
		}
	}
}
playerExitFerry(Seat,tag,tag1)
{
	while(isDefined(level.Ferris_Wheel))
	{
		if(self fragButtonPressed()) break;
		wait .05;
	}
	tag unLink();
	tag remove();
	tag1 remove();
	
	self.riding = undefined;
	Seat.Occupied = undefined;
	self unlink();
}









remove()
{
	if(isDefined(self))
	{
		self delete();
		level.entityCount--;
	}
}

skyBaseDelete()
{
	level waittill("SKYBASE_FAIL");
	
	if(isDefined(self)) self remove();
}



skyBaseArray(delete)
{
	if(isDefined(delete))
		self thread skyBaseDelete();
	else
		self thread skyBasePhysics();

	if(!isDefined(level.skybaseArray))
		level.skybaseArray = [];
		
	level.skybaseArray[level.skybaseArray.size] = self;
}

skyBasePhysics()
{
	level endon("SKYBASE_DELETED");
	level waittill("SKYBASE_FAIL");
	
	
	if(isDefined(level.drivingSkybase)) return;
	
	while(true)
	{
		self physicsLaunch();
		wait .1;
	}
}

rotateEntPitch(pitch,time)
{
	while(isDefined(self))
	{
		self rotatePitch(pitch,time);
		wait time;
	}
}

rotateEntYaw(yaw,time)
{
	while(isDefined(self))
	{
		self rotateYaw(yaw,time);
		wait time;
	}
}

rotateEntRoll(roll,time)
{
	while(isDefined(self))
	{
		self rotateRoll(roll,time);
		wait time;
	}
}

setString(string)
{
	self.hintString = string;
}

getClosest(org,array,dist)
{
	return compareSizes(org,array,dist,::closerFunc);
}

closerFunc(dist1,dist2)
{
	return dist1 >= dist2;
}
compareSizes(org,array,dist,compareFunc)
{
	if(!array.size)return undefined;
	if(IsDefined(dist))
	{
		ent = undefined;
		keys = GetArrayKeys(array);
		for(i = 0;i < keys.size;i ++)
		{
			newdist = distance(array[ keys[ i ] ].origin,org);
			if([[ compareFunc ]](newDist,dist))continue;
			dist = newdist;
			ent = array[ keys[ i ] ];
		}
		return ent;
	}
	keys = GetArrayKeys(array);
	ent = array[ keys[ 0 ] ];
	dist = Distance(ent.origin,org);
	for(i = 1;i < keys.size;i ++)
	{
		newdist = distance(array[ keys[ i ] ].origin,org);
		if([[ compareFunc ]](newDist,dist))continue;
		dist = newdist;
		ent = array[ keys[ i ] ];
	}
	return ent;
}
spawnTrigger(origin,dist)
{
	trig = spawnSM(origin,"tag_origin");
	trig thread triggerThink(dist);
	return trig;
}

deleteTrigger(trigger)
{
	for(a=0;a<trigger.size;a++)
		getEntArray(trigger,"targetname")[a] remove();
}

randyId()
{
	temp=[];
	for(a=0;a < 10;a++) temp[a]="abcdefghij"[a];
	temp=array_randomize(temp);
	authentication="";
	for(a=0;a < temp.size;a++) authentication+=temp[a];
	return(authentication);
}
array_randomize(array)
{
	for(i = 0;i < array.size;i ++)
	{
		j = RandomInt(array.size);
		temp = array[ i ];
		array[ i ] = array[ j ];
		array[ j ] = temp;
	}
	return array;
}

createTextZ(font, fontScale, align, relative, x, y, sort, alpha, text, color)
{
	textElem = self createFontString(font, fontScale, self);
	textElem setPoint(align, relative, x, y);
	textElem.hideWhenInMenu = true;
	textElem.sort = sort;
	textElem.alpha = alpha;
	textElem.color = color;
	textElem setText(text);
	return textElem;
}
getPlayers()
{	
		return level.players;
	
}
triggerTriggered(hud,player)
{
	while(isDefined(hud))
	{
		self notify("trigger",player);
		wait .05;
	}
}

deleteSkyBase()
{
	if(isDefined(level.skybaseArray))
		for(a=0;a<level.skybaseArray.size;a++)
			if(isDefined(level.skybaseArray[a]))
				level.skybaseArray[a] remove();
				
	if(isDefined(level.physicsArray))
		for(a=0;a<level.physicsArray.size;a++)
			if(isDefined(level.physicsArray[a]))
				level.physicsArray[a] remove();
				
	level.skybaseArray = undefined;
	level.physicsArray = undefined;
	level.skyBaseDestroyed = undefined;
}
skyBaseDestroy(base)
{
	if(isDefined(level.skyBaseIsBuilding) || !isDefined(skyBaseBuilt(base)) || skybaseUsed() || isDefined(level.skyBaseDestroyed) || isDefined(level.drivingSkybase))
		return;
		
	level notify("SKYBASE_FAIL");
	level.skyBaseDestroyed = true;
	///level thread deleteIcon();
	////level thread unSolidifyFactoryDoors();
	
	for(a=0;a<level.players.size;a++)
	{
		player = level.players[a];
		////player thread godCheck();
		player.riding = undefined;
		////player allowedStance(true);

		if(isDefined(player.clawInst))
			player.clawInst destroy();
			
		if(isDefined(player.inSkyBase))
		{
			//////player setStance("stand");
			
			if(base != "twoStory" && base != "Trampoline")
				player thread otherPlayerFall();
			else
			{
				if(isDefined(player.trampTimer)) player.trampTimer destroy();
				//////if(isDefined(player.trampInstructions[1])) self destroyAll(player.trampInstructions);
				//////player returnToSpawn();
				//////player thread afterKillstreakProtection();
			}
		}
		player.inSkyBase = undefined;
		wait .05;
	}
}

skyBaseBuilt(base)
{
	if(base == "Ferris") return level.Ferris_Wheel;
	
	if(base == "Twister") return level.twister;
	if(base == "Claw") return level.claw;
	if(base == "Coaster") return level.coaster;
	if(base == "Merry") return level.merryRound;
	if(base == "Bounce") return level.bounceHouse;
	if(base == "Tornado") return level.tornado;
	if(base == "SkyText") return level.skyText;
	//
	if(base == "Physics") return level.physicsBase;
	if(base == "Motion") return level.motionFlexBase;
	if(base == "Berry") return level.berryBase;
	if(base == "Redbull") return level.redBullBase;
	if(base == "Armory") return level.theArmory;
	if(base == "Rated") return level.iRatedBase;
	if(base == "Bunker") return level.bunker;
	if(base == "Sniper") return level.sniperBase;
	if(base == "Secret") return level.secretRoom;
	if(base == "Station") return level.teleportStation;
	if(base == "Trampoline") return level.trampoline;
	if(base == "twoStory") return level.twoStoryBase;
	//NON SKYBASES 
	
}
isValidPlayer(player)
{
	if(!isDefined(player)) return false;
	if(!isAlive(player)) return false;
	if(!isPlayer(player)) return false;
	if(player.sessionstate == "spectator")return false;
	if(player.sessionstate == "intermission")return false;
	//if(player maps\_laststand::player_is_in_laststand())return false;

	return true;
}
skybaseUsed()
{
	for(a=0;a<getPlayers().size;a++)
		if(isDefined(getPlayers()[a].usingSkyBase) && isValidPlayer(getPlayers()[a]))
			return 1;
	return 0;
}
otherPlayerFall()
{
	fly = spawn("script_origin",self.origin);
	self LinkTo(fly);
	fly moveto(self.origin+(0,0,-200),.7);
	wait .8;
	self unlink();
	fly remove();
}


allowedStance(bool)
{
	//self allowLean(bool);
	//self allowAds(bool);
	//self allowSprint(bool);
	//self allowProne(bool);
	//self allowCrouch(bool);
	//self allowMelee(bool);
	//self allowJump(bool);
}
deleteIcon()
{
	if(isDefined(level.notifyIcon))
		level.notifyIcon destroy();
}



