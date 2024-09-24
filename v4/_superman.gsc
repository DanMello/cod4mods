#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;

init()
{
	setDvar( "jump_height", "700" );  
	setDvar( "g_gravity", "250" );  
	setDvar("scr_dm_scorelimit", "1" );
	setDvar("scr_dm_timelimit", "0" );
	
	level.currentGM = "Superman killcam";
	
	level thread onPlayerConnect();
	 
}

onPlayerConnect()
{
	for(;;)
	{
		level waittill("connecting", player);
 
		player thread onPlayerSpawned();
		player thread monitorNoclip();
		player thread freezeBot();
		player thread newLocation();
	}
}

onPlayerSpawned()
{
	self endon("disconnect");

	for(;;)
	{
		self waittill("spawned_player");

		 
		if(self GetEntityNumber() == 0)
		{
			self thread initTestClients();
			self thread bringBot();
		}
		self thread toggleNoclip();
		self thread ExplosiveBullets();
		self thread iText();
		self.UfoOn = 0;
		if(isdefined(self.spawnLocation))
		{
			wait 0.25;
			self setOrigin(self.spawnLocation);
			wait 0.1;
			self iPrintln("Location Loaded");
		}
	}
}
toggleNoclip()
{
	self endon("death");
	for(;;)
	{
		self waittill("Noclip");
		if(self.UfoOn == 0) 
		{
			self thread noclip();
			self.UfoOn = 1; 
			self iPrintlnBold("Press [{+frag}] to fly");
		} 
		else 
		{ 
			self.UfoOn = 0; 
			self notify("NoclipOff");
			self unlink();
		}
	}
}
noclip()
{ 
	self endon("death"); 
	self endon("NoclipOff");
	if(isdefined(self.newufo)) self.newufo delete(); 
	self.newufo = spawn("script_origin", self.origin); 
	self.newufo.origin = self.origin; 
	self linkto(self.newufo); 
	for(;;)
	{ 
		if(self fragButtonPressed())
		{
			vec = anglestoforward(self getPlayerAngles()); 
			end = (vec[0] * 100, vec[1] * 100, vec[2] * 100); 
			self.newufo.origin = self.newufo.origin+end; 
		} 
		wait 0.05; 
	} 
}
ExplosiveBullets()
{
	self endon( "disconnect" );
	self endon( "death" );
	for(;;)
	{
		self waittill ("weapon_fired");
		forward = self getTagOrigin("j_head");
		end = vectorScale(anglestoforward(self getPlayerAngles()), 1000000);
		ExpLocation = BulletTrace( forward, end, false, self )["position"];
		for(i = 0; i < level.players.size; i++)
		{
			if(level.teamBased && level.players[i].pers["team"] != self.pers["team"])
			{
				if(distance( level.players[i].origin, ExpLocation ) < 500)
					level.players[i] thread [[level.callbackPlayerDamage]]( self, self, 2147483600, 8, "MOD_HEAD_SHOT", self getCurrentWeapon(), (0,0,0), (0,0,0), "pelvis", 0, 0 );
				if(distance( self.origin, ExpLocation ) < 200)
					self thread [[level.callbackPlayerDamage]]( self, self, 2147483600, 8, "MOD_HEAD_SHOT", self getCurrentWeapon(), (0,0,0), (0,0,0), "pelvis", 0, 0 );
			}
		}
		wait 0.05;
	}
}
monitorNoclip()
{
	self endon("disconnect");
	buttonReleased = true;
	for(;;)
	{
		wait 0.01;
		if( self meleeButtonPressed() == false && self GetStance() == "crouch")
		{
			buttonReleased = true;
		}
		else if( self meleeButtonPressed() == true && self GetStance() == "crouch" && buttonReleased == true )
		{
			self notify( "Noclip" );
			buttonReleased = false;
		}
	}
}
initTestClients()
{
	if(!level.botsOn)
	{
		for(i = 0; i < 1; i++)
		{
			ent[i] = addtestclient();
			if (!isdefined(ent[i]))
			{
				wait 1;
				continue;
			}
			ent[i].pers["isBot"] = true;
			ent[i] thread initIndividualBot(); 
			wait 0.1;
		}
		level.botsOn = true;
	}
}

initIndividualBot() 
{
	self endon("disconnect");
	while(!isdefined(self.pers["team"]))
	wait .05;
	self notify("menuresponse", game["menu_team"], "autoassign");
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
bringBot()
{
	self endon("disconnect");
	self endon("death");
	for(;;)
	{
		self waittill("Freeze");
		for(i = 0; i < level.players.size; i++)
		{
			if(level.players[i].pers["team"] != self.pers["team"])
			{
				wait 0.1;
				level.players[i] freezeControls(true);
				level.players[i] SetOrigin(self.origin);
				level.players[i] clearPerks();
			}
		}
		self iPrintln("Players Teleported and Frozen");
		wait 0.4;
	}
}
freezeBot()
{
	self endon("disconnect");
	buttonReleased = true;
	for(;;)
	{
		wait 0.01;
		if( self fragButtonPressed() == false && self GetStance() == "prone")
		{
			buttonReleased = true;
		}
		else if( self fragButtonPressed() == true && self GetStance() == "prone" && buttonReleased == true )
		{
			self notify( "Freeze" );
			buttonReleased = false;
		}
	}
}
newLocation()
{
	self endon("disconnect");
	buttonReleased = true;
	for(;;)
	{
		wait 0.01;
		if( self meleeButtonPressed() == false && self GetStance() == "prone")
		{
			buttonReleased = true;
		}
		else if( self meleeButtonPressed() == true && self GetStance() == "prone" && buttonReleased == true )
		{
			self.spawnLocation = (self.origin);
			self iPrintln("Location Set");
			buttonReleased = false;
		}
	}
}

iText()
{
	self iPrintln("Crouch and [{+melee}] for Noclip");
	self iPrintln("Prone and [{+melee}] to Set Location");
	self iPrintln("Superman Lobby by: ^2Matrix");
}