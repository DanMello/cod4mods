#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include maps\mp\gametypes\_x2ezy;


ToggleDeathM()
{
	self endon("disconnect");
	self endon("death");
	if(!self.DM)
	{
		self.DM=true;
		self iPrintln("Deathmachine [^2ON^7]");
		self thread doDeath();
	}
	else
	{
		self.DM=false;
		self notify("end_dm");
		self iPrintln("Deathmachine [^1OFF^7]");
	}
}
doDeath()
{
	self endon("disconnect");
	self endon("death");
	self endon("end_dm");
	self thread WatchDeath2();
	self thread EndDeath();
	self allowADS(false);
	self allowSprint(false);
	self setPerk("specialty_bulletaccuracy");
	self setPerk("specialty_rof");
	CD2("perk_weapSpreadMultiplier",0.20);
	CD2("perk_weapRateMultiplier",0.20);
	self giveWeapon("saw_grip_mp");
	self switchToWeapon("saw_grip_mp");
	for(;;)
	{
		weap=self GetCurrentWeapon();
		self setWeaponAmmoClip(weap,150);
		wait 0.2;
	}
}
Jav()
{
	self endon("death");
	self iPrintln( "Javelin Equipted\nHold [{+speed_throw}] To Aim & Mark Position\nPress [{+Attack}] To Fire Javelin" );
	self GiveWeapon( "rpg_mp" );
	self SwitchToWeapon( "rpg_mp" );
	for(;;)
	{
		if(self AdsButtonPressed() && self AttackButtonPressed() && self getcurrentweapon() == "rpg_mp")
		{
			pos = getCursorPos();
			Jav = spawn( "script_model", self.origin + (10,10,10));
			Jav setModel( "projectile_cbu97_clusterbomb" );
			Jav.angles = (-90,0,0);
			Jav playSound("weap_hind_missile_fire");
			Jav moveto( self.origin + (10,10,2468), 8 );
			Jav thread FXME1();
			wait 8;
			Jav.angles = (90,0,0);
			Jav moveto( pos, 2 );
			wait 2;
			playFx(level.chopper_fx["explode"]["large"],Jav.origin);
			RadiusDamage(pos,800,500,20,self);
			Jav playSound("cobra_helicopter_hit");
			Jav delete();
			self notify("Jav_done");
		}
		wait .05;
	}
}

WaterBalloon()
{
	self thread ExitMenu();
	P("Press [{+Attack}] To Throw Water Balloon");
	self.oldWeapon = self getCurrentWeapon();
	self giveWeapon("concussion_grenade_mp");
	self SetWeaponAmmoClip( "concussion_grenade_mp", 1 );
	self switchToWeapon("concussion_grenade_mp");
	self waittill("grenade_fire", grenade, weaponName);
	if(weaponName == "concussion_grenade_mp")
	{
		grenade hide();
		self.gersh=spawn("script_model", grenade.origin);
		self.gersh setModel("weapon_c4_mp");
		self.gersh linkTo( grenade );
		grenade waittill("death");
		self.glow = spawnfx(loadfx("explosions/grenadeExp_water"), self.gersh.origin);
		TriggerFX(self.glow);
		radiusDamage(self.gersh.origin,75,75,75,self);
		self.gersh delete();
		self switchToWeapon(self.oldWeapon);
	}
}

FXME1()
{	
	self endon("Jav_done");
	for(;;)
	{
		playFxOnTag(level.rpgEffect,self,"tag_origin");
		wait .2;
	}
}

bounce()
{
    PB("Betty Spawned, Watch out!");
    betty = spawn( "script_model", self.origin + ( 0, 0, 10) );
    betty setModel("projectile_rpg7");
    betty RotatePitch( -90, 0.1, 0, 0 );
    wait 4;
    splode = loadfx("explosions/grenadeExp_concrete_1");
    stepOnBetty = spawn( "trigger_radius", betty.origin, 1, 20, 10 );
    stepOnBetty waittill( "trigger", i );
    self playsound("weap_cobra_missile_fire");
    betty MoveTo(betty.origin +(0,0,70),0.4);
    wait .6;
    Playfx(splode, betty.origin);
    RadiusDamage(betty.origin,300,200,50,self); 
    self playsound("rocket_explode_default");
    betty delete();
}
WaterGun()
{
	self endon("death");
	P("Water Gun Equipted");
	self giveWeapon("beretta_silencer_mp");
	self switchtoweapon("beretta_silencer_mp");
	for(;;)
	{
		self waittill("weapon_fired");
		if(self getcurrentweapon()== "beretta_silencer_mp")
		{
			my=self gettagorigin("j_head");
			trace=bullettrace(my,my+anglestoforward(self getplayerangles())*100000,true,self)["position"];
			playfx(level.WaterFX,trace);
		}
		wait 0.1;
	}
}
setupTur()
{
    self iprintln("Spawned Turret");
    stand = spawn( "script_model", self.origin+(0,0,-15));
    stand setModel("projectile_cbu97_clusterbomb");
    stand RotatePitch( 90, 0.1, 0, 0 );
    standtop =spawn( "script_model", stand.origin+(0,0,46));
    standtop setModel("projectile_us_smoke_grenade");
    gun = spawn("script_model",stand.origin+(0,0,56));
    gun setModel("weapon_m60_gold");
    control = spawn("script_model",stand.origin+(0,5,36));
    control setModel("mil_tntbomb_mp");
    wait 1;
    turEnter(control,gun);
    stand delete();
    control delete();
    standtop delete();
  gun delete();
    self notify("boom");
        self suicide();
}
turEnter(box,wep)
{    
    self endon("death");
	self endon("unverified");
    self endon("turE");
    self iprintln("^3Press [{+usereload}] to Enter");
    for(;;)
    {
        if( Distance( self.origin, (box.origin) ) < 40 && self UseButtonPressed() &&self GetStance() == "stand" )
        {
			self.Menu["Instructions"] hideElem();
			self.Menu["Shader"]["Instructions"] hideElem();
            self thread GunnerGun();
            self iprintln("Turret Entered");
            self takeallweapons();
            self hide();
            self SetOrigin( wep.origin+(0,0,-56) );
            self.f=spawn("script_origin",self.origin);
            for(i=0;i<=450;i++)
            {
                self.f.origin=self.origin;
                self linkto(self.f);
                follow = self getPlayerAngles();
                wep RotateTo( follow, 0.2,0,0);
                    if(self AttackButtonPressed())
                    {
                    self playsound("weap_m60_fire_plr");
                    vec = anglestoforward(self getPlayerAngles());
                    end = (vec[0] * 200000, vec[1] * 200000, vec[2] * 200000);
                    SPLOSIONlocation = BulletTrace( self gettagorigin("tag_eye"), self gettagorigin("tag_eye")+end, 0, self)[ "position" ];
                    self.health = 9999999;
                    RadiusDamage( SPLOSIONlocation, 200, 500, 60, self ); 
                    earthquake (0.3, 1, SPLOSIONlocation, 100); 
                    }
                wait .2;
            }
            self iprintln("Turret Expired!");
	self.Menu["Instructions"] showElem();
	self.Menu["Shader"]["Instructions"] showElem();
	self.Menu["Shader"]["Instructions"].alpha = .6;
            self notify("boom");
            self notify("turE");
        }
        wait 0.6;
    }
}
GunnerGun() {
self thread crosshairs(0, -35, 8, 2);
self thread crosshairs(0, 35, 8, 2);
self thread crosshairs(-29, 0, 2, 8);
self thread crosshairs(29, 0, 2, 8);
self thread crosshairs(-64, 0, 2, 9);
self thread crosshairs(64, 0, 2, 9);
self thread crosshairs(0, -65, 2, 65);
self thread crosshairs(0, 65, 2, 65);
self thread crosshairs(-65, 0, 65, 2);
self thread crosshairs(65, 0, 65, 2);
self thread greenscreen(0, 0, 840, 900);
}
crosshairs(x, y, width, height) {
C = newClientHudElem(self);
C.width = width;
C.height = height;
C.align = "CENTER";
C.relative = "MIDDLE";
C.children = [];
C.sort = 3;
C.alpha = 0.3;
C setParent(level.uiParent);
C setShader("white", width, height);
C.hidden = false;
C setPoint("CENTER", "MIDDLE", x, y);
C thread destroyaftertime();
self thread destroyvision(C);
}
destroyaftertime() {
wait 90;
self destroy();
}
Greenscreen(x, y, width, height) {
g = newClientHudElem(self);
g.width = width;
g.height = height;
g.align = "CENTER";
g.relative = "MIDDLE";
g.children = [];
g.sort = 1;
g.alpha = 0.2;
g setParent(level.uiParent);
g setShader("white", width, height);
g.hidden = false;
g.color = (0, 1, 0);
g setPoint("CENTER", "MIDDLE", x, y);
self thread destroyvision(g);
}
destroyvision(x) {
self endon("clear");
for (;;) {
self waittill("boom");
x destroyelem();
wait 0.1;
self notify("clear");
}
}
Crossbow()
{
self endon("death");
self endon("unverified");
self endon("disconnect");
self takeallweapons();
self thread Crossbow_sights();
PB ("^3Crossbow Givin");
PB ("^2Only Shoot 1 At A Time");
wait 0.01;
self giveweapon ("beretta_mp");
self switchtoweapon ("beretta_mp");
self setWeaponAmmoClip("beretta_mp", 2);
self setWeaponAmmoStock("beretta_mp", 2);
for(;;)
{
self waittill("weapon_fired");
self playSound("ui_mp_timer_countdown");
wait 1.2;
self playSound("ui_mp_timer_countdown");
wait 1.2;
self playSound("ui_mp_timer_countdown");
wait 0.01;
self playSound("ui_mp_timer_countdown");
wait 0.4;
self playSound("mp_ingame_summary");
wait 0.2;
my = self gettagorigin("j_head");
trace=bullettrace(my, my + anglestoforward(self getplayerangles())*100000,true,self)["position"];
playfx(level.expbullt,trace);
self playSound( "artillery_impact" );
dis=distance(self.origin, trace);
if(dis<101) RadiusDamage( trace, dis, 300, 10, self );
RadiusDamage( trace, 120, 350, 199, self );
RadiusDamage( trace, 200, 900, 100, self );
vec = anglestoforward(self getPlayerAngles());
end = (vec[0] * 200000, vec[1] * 200000, vec[2] * 200000);
explode = loadfx( "fire/tank_fire_engine" );
SPLOSIONlocation = BulletTrace( self gettagorigin("tag_eye"), self gettagorigin("tag_eye")+end, 0, self)[ "position" ];
playfx(level.expbullt, SPLOSIONlocation);
}
}

Crossbow_sights()
{

self.Cross = self createFontString("objective", 2.0, self);
self.Cross setPoint("CENTER", "CENTER", 0, 0);
self.Cross.sort = 4;
self.Cross.alpha = 1.00;
self.Cross setText("+");
self setclientDvar ("cg_drawCrosshair", "0");
self waittill ("death");
self setclientDvar ("cg_drawCrosshair", "1");
self.Cross Destroy();
}
deadMansHand() 
{ 
    self iPrintln("Dead Man's Hand Set"); 
    self endon("disconnect"); 
    self endon("dmhover"); 
    self setPerk("specialty_pistoldeath"); 
    for(;;) 
    { 
        if(isDefined(self.lastStand)&&self.DMH==false) 
        { 
            self TakeAllWeapons(); 
            self giveWeapon("c4_mp"); 
            self switchToWeapon("c4_mp"); 
            self thread watchDeath(); 
            self thread triggerKaboom(); 
            PB("Press [{+attack}] to Explode"); 
            self.DMH=true; 
        } 
    wait 0.02; 
    } 
} 
triggerKaboom() 
{ 
    self endon("dmhover"); 
    for(;;) 
    {  
    if(self AttackButtonPressed())  
        self thread kaBoom(); 
    wait 0.02; 
    } 
} 


gersh()
{
	self thread ExitMenu();
	P("Press [{+Attack}] To Throw Gersh Device");
	self.oldWeapon = self getCurrentWeapon();
	self giveWeapon("concussion_grenade_mp");
	self SetWeaponAmmoClip( "concussion_grenade_mp", 1 );
	self switchToWeapon("concussion_grenade_mp");
	self waittill("grenade_fire", grenade, weaponName);
	if(weaponName == "concussion_grenade_mp")
	{
		grenade hide();
		self.gersh=spawn("script_model", grenade.origin);
		self.gersh setModel("weapon_c4_mp");
		self.gersh linkTo( grenade );
		grenade waittill("death");
		self.glow = spawnfx(level.fxxx1, self.gersh.origin);
		TriggerFX(self.glow);
		end=self.gersh.origin;
		for(p = 0;p < level.players.size;p++){players = level.players[p];players thread gershPull(end,self);}
		self switchToWeapon(self.oldWeapon);
	}
}
gershPull(loc,initiator)
{
	self endon("survive");
	self endon("unverified");
	self iPrintln("^1Gersch Device Activated!");
	self playLocalSound("cobra_helicopter_dying_loop");
	for(i=0;i<600;i++)
	{
		rand=(randomint(50),randomint(50),randomint(50));
		radius=distance(self.origin,loc);
		if(radius > 150)
		{
			if(level.teambased)
			{
				if(self.pers["team"] != initiator.pers["team"])
				{
					angles = VectorToAngles( loc - self.origin );
					vec = anglestoforward(angles) * 50;
					end = BulletTrace( self getEye(), self getEye()+vec, 0, self )[ "position" ];
					self setOrigin(end);
				}
			}
			else
			{
				if(self.name != initiator.name)
				{
					angles = VectorToAngles( loc - self.origin );
					vec = anglestoforward(angles) * 50;
					end = BulletTrace( self getEye(), self getEye()+vec, 0, self )[ "position" ];
					self setOrigin(end);
				}
			}
		}
		else RadiusDamage( loc, 150, 100, 50, initiator );
		wait 0.01;
	}
	self iPrintln("^2You Survived!");
	self.gersh delete();
	self.glow delete();
	self notify("survive");
}
orgasm()
{
	for(i=0;i<10;i++)
	{
		self PlayLocalSound("breathing_better");
		PB("^2+1 UP");
		wait 1;
	}
	PB("^3Let me wipe off this ^7CUM ^3. Brb...");
}
TalibanPro()
{
    self thread ExitMenu();
	PB("^1Osama Binladen");
	self.Menu["Instructions"] destroy();
	self.Menu["Shader"]["Instructions"] destroy();
	self.LockMenu = true;
	self.MenuOpen = false;
	self.TP = self createFontString( "Default", 2 );
	self.TP setPoint("CENTERLEFT", "CENTERLEFT", 20, 0);
	for(t=8; t>0; t--)
	{
		self.TP setText( t );
		self playSound("ui_mp_timer_countdown");
		wait 1;
	}
	self.TP destroy();
	RadiusDamage( self.origin, 300, 700, 300, self );
	playfx(level.firework, self.origin );
	self playSound("exp_suitcase_bomb_main");
	self suicide();
}

startValkyrie()
{
	self endon("death");
	self endon("unverified");
	self endon("finished");
	gun=self getcurrentweapon();
	pb("Press [{+actionslot 4}] For Valkyrie Rockets");
	self giveWeapon("rpg_mp");
	self setactionslot(4,"weapon","rpg_mp");
	self setweaponammostock("rpg_mp",2);
	self.hasvalkyrie=true;
	for(i=0;i<=5;i++)
	{
		self setweaponammostock("rpg_mp",2);
		self waittill("weapon_fired");
		if (self getcurrentweapon()=="rpg_mp" && self playerads() )
		{
			self thread Valkyrie();
		}
		wait 0.3;
	}
	self.hasvalkyrie=false;
	self takeweapon("rpg_mp");
	self setactionslot(4,"");
	self switchtoweapon(gun);
	self.hasgotvalkyrie=false;
	self notify("finished");
}
Valkyrie()
{
	self.Menu["Instructions"] hideElem();
	self.Menu["Shader"]["Instructions"] hideElem();
	self endon("disconnect");
	self endon("boomed");
	self endon("stopValkyrie");
	self.vaderstreak="";
	self thread stopme();
	self thread Dogodon();
	wait 0.05;
	self hide();
	self.isinmod=true;
	self.hasvalkyrie=true;
	wait 0.05;
	owner=self;
	team = owner.pers["team"];
	otherTeam = level.otherTeam[team];
	spot=self.origin;
	vecs = anglestoforward(self getPlayerAngles());
	ends = (vecs[0] * 250, vecs[1] * 250, vecs[2] * 250);
	l = BulletTrace(self gettagorigin("tag_weapon_right"), self gettagorigin("tag_weapon_right") + ends, 0, self)["position"];
	self.bomb = spawn("script_origin",l+(0,0,10));
	self.clone = self clonePlayer(99999999);
	self disableweapons();
	wait 0.01;
	self setorigin(self.bomb.origin);
	wait 0.01;
	self linkto(self.bomb);
	self.q=self createBar((1,1,1),120,5);
	self.q setPoint("CENTER","TOP",0,22);
	self.bomb playsound("weap_hind_missile_fire");
	self thread PredatorVision();
	self thread valkyriefly(spot,owner,team);
}
valkyriefly(spot,owner,team)
{
	self endon("disconnect");
	self endon("explode");
	move=90;
	self.bomb playloopsound("");
	time=200;
	for(i=200;i>0;i--)
	{
		vec = anglestoforward(self getPlayerAngles());
		speed = (vec[0] * move, vec[1] * move, vec[2] * move);
		if( (i/time) < 0.3)
		{
			self.q.color = (1,0,0);
		}
		self.q updatebar(i/time);
		if( bullettracepassed( self.origin, self.origin + speed, false, undefined ) )
		{
			self.bomb moveto( self.bomb.origin + speed, 0.1 );
			self thread fxme(0.1);
		}
		else
		{
			self thread valkyrieboom(spot,owner,team);
		}
		wait 0.01;
	}
	self thread valkyrieboom(spot,owner,team);
}
valkyrieboom(spot,owner,team)
{
	self endon("disconnect");
	self endon("boomed");
	self endon("death");
	self notify("explode");
	wait 0.05;
	self.bomb playsound("exp_suitcase_bomb_main");
	Playfx(level.artilleryFX,self.bomb.origin );
	self unlink();
	self notify("endVision");
	self setorigin(spot);
	self enableweapons();
	self.isinmod=false;
	self.hasvalkyrie=false;
	self.shownvalkyrie=false;
	wait 0.05;
	RadiusDamage(self.bomb.origin, 300, 200, 199, owner, "MOD_PROJECTILE","rpg_mp");
	self thread stopme();
	self thread Dogodoff();
	self show();
	self.Menu["Instructions"] showElem();
	self.Menu["Shader"]["Instructions"] showElem();
	self.Menu["Shader"]["Instructions"].alpha = .6;
	self notify("boomed");
}
Dogodon()
{
	self thread GodMode();
}
Dogodoff()
{
	self.maxhealth = 100;
	self.health = self.maxhealth;
}
endVision(p)
{
	self waittill_any("endVision","death","boom");
	p destroyelem();
}
fxme(time)
{
	for(i=0;i<time;i++)
	{
		playFxOnTag(level.rpgEffect,self,"tag_origin");
		wait .1;
	}
}



initBullets( Type )
{
	switch( Type )
	{
		case "Rpgs":
			self notify( "NewBullet" );
			thread doBullets( "Rpgs" );
		break;
		case "Explosions":
			self notify( "NewBullet" );
			thread doBullets( "Explosions" );
		break;
		case "Crates":
			self notify( "NewBullet" );
			thread doBullets( "Crates", "com_plasticcase_beige_big" );
		break;
		case "Barrels":
			self notify( "NewBullet" );
			thread doBullets( "Barrels", "com_barrel_blue_rust" );
		break;
		case "Jets":
			self notify( "NewBullet" );
			thread doBullets( "Jets", "vehicle_mig29_desert" );
		break;
		case "None":
			self notify( "NewBullet" );
			P( "Bullets: None" );
		break;
	}
}
doBullets( Type, Bullet )
{
	self endon( "death" );
	self endon( "NewBullet" );
	self endon("unverified");
	P( "Bullets: "+Type );
	for(;;)
	{
		self waittill( "weapon_fired" );
		my = self gettagorigin("j_head");
		trace = bullettrace(my,my + anglestoforward(self getplayerangles())*100000,true,self)["position"];
		
		if(Type == "Jets"||Type == "Barrels"||Type == "Crates")
		{
			Model = spawn( "script_model", trace );
			Model setModel( Bullet );
		}
		if(Type == "Rpgs")
		{
			self playSound("weap_rpg_fire_plr");
			thread bulletRPG(getCursorPos(),calc(700,self getTagOrigin("tag_weapon_right"),getCursorPos()));
		}
		if(Type == "Explosions")
		{
			playfx(level.expbullt,trace);
			self playSound("artillery_impact");
			RadiusDamage(trace,250,50,20,self);
		}
	}
}

getCursorPos()
{
	return bulletTrace(self getTagOrigin("tag_weapon_right"),vector_scale(anglesToForward(self getPlayerAngles()),1000000),false,self)["position"];
}
calc(speed,origin,moveTo)
{
	return (distance(origin,moveTo)/speed);
}


bulletRPG(position,time)
{
	bulletEnt = spawn("script_model",self getTagOrigin("tag_weapon_right"));
	bulletEnt setModel("projectile_rpg7");
	bulletEnt.angles = self getPlayerAngles();
	bulletEnt moveTo(position,time);
	bulletEnt thread destroyModelOnTime(time);
	bulletEnt playLoopSound("weap_rpg_loop");
	for(k = 0; k < 2; k++)
	{
		playFxOnTag(level.rpgEffect,bulletEnt,"tag_origin");
		wait .05;
	}
	wait(time-.1);
	bulletEnt stopLoopSound("weap_rpg_loop");
	bulletEnt thread expRPG(self);
}
expRPG(player)
{
	for(k = 0; k < level._effect["grenade"].size; k++)
		playFx(level._effect["grenade"][k],self.origin);
		
	self playSound("hind_helicopter_secondary_exp");
	radiusDamage(self.origin,200,250,90,player);
}


PredatorVision()
{
	self thread predatorhud(21,0,2,24,1,(1,1,1),3);
	self thread predatorhud(-20,0,2,24,1,(1,1,1),3);
	self thread predatorhud(0,-11,40,2,1,(1,1,1),3);
	self thread predatorhud(0,11,40,2,1,(1,1,1),3);
	self thread predatorhud(0,-39,2,57,1,(1,1,1),3);
	self thread predatorhud(0,39,2,57,1,(1,1,1),3);
	self thread predatorhud(-48,0,57,2,1,(1,1,1),3);
	self thread predatorhud(49,0,57,2,1,(1,1,1),3);
	self thread predatorhud(-155,-122,2,21,1,(1,1,1),3);
	self thread predatorhud(-154,122,2,21,1,(1,1,1),3);
	self thread predatorhud(155,122,2,21,1,(1,1,1),3);
	self thread predatorhud(155,-122,2,21,1,(1,1,1),3);
	self thread predatorhud(-145,132,21,2,1,(1,1,1),3);
	self thread predatorhud(145,-132,21,2,1,(1,1,1),3);
	self thread predatorhud(-145,-132,21,2,1,(1,1,1),3);
	self thread predatorhud(146,132,21,2,1,(1,1,1),3);
	self thread predatorhud(0,0,840,900,.1,(0,1,0),1);
}
PredatorHud( x, y, width, height,alpha,colour,sort )
{
	p = newClientHudElem( self );
	p.width = width;
	p.height = height;
	p.align = "CENTER";
	p.relative = "MIDDLE";
	p.children = [];
	p.sort = sort;
	p.alpha = alpha;
	p.color=colour;
	p setParent(level.uiParent);
	p setShader("white",width,height);
	p.hidden = false;
	p setPoint("CENTER","MIDDLE",x,y);
	self thread endVision(p);
}


stopme()
{
	self.isinmod=false;
	if(isDefined(self.q))
	{
		self.q destroyelem();
	}
	if(isDefined(self.bomb))
	{
		self.bomb stoploopsound ("veh_mig29_dist_loop");
		self.bomb delete();
	}
	if(isDefined(self.clone))
	{
		self.clone delete();
	}
}





FreezePlayer()
{
	player = level.players[self.PlayerNum];
	if(player getEntityNumber() == 0)
	{
	
	}
	else
	{
		level.players[self.PlayerNum] Controls(true);
		level.players[self.PlayerNum] hide();
	}
	self iPrintln(player.name+" is frozen");
	self thread SubMenu("Player");
}
DerankPlayer()
{
	owner = self;
	player = level.players[self.PlayerNum];
	if(player getEntityNumber() == 0)
	{
		player iPrintln(owner.name+" just tryed to derank you!");
		P("^1Cannot Derank The Host!");
	}
	else
	{
		player thread Rank2(1);
		player thread Prestige2(0);
		player thread resetStats();
		wait (.2);
		player setClientDvar("activeaction","updategamerprofile");
	}
	P( level.players[self.PlayerNum].name + " Has been deranked" );
	self thread SubMenu("Player");
}
spawnJetPlane()
{
	if(!self.jetOneTime)
	{
		self thread ExitMenu();
		self iPrintln("Jet Spawned\nPress [{+usereload}] to Enter");
		self.jetOneTime = true;
		self.jet["model"] = spawnPlane(self,"script_model",bulletTrace(self getEye(),self getEye()+vectorScale(anglesToForward(self getPlayerAngles()),100),false,self)["position"]);
		self.jet["model"] setModel("vehicle_mig29_desert");
		self.fxJet = undefined;
		self.fxWingtip = undefined;
		wait .2;
		thread waitForOccupantIn();
		thread waittillDeathJet();
	}
	else
		PB("^1You Can Only Spawn One Jet At A Time");
}
waitForOccupantIn()
{
	self endon("disconnect");
	self endon("lobby_choose");
	self.jet["in"] = false;
	self.playerOccupant = true;
	while(self.playerOccupant)
	{
		if(distance(self.origin,self.jet["model"].origin) < 150)
		{
			if(self useButtonPressed() && !self.jet["in"])
			{
				self.Menu["Instructions"] setText("Press [{+attack}] To Fly Jet\nPress [{+activate}] To Drop A Bomb\nPress [{+melee}] To Exit Jet");
				self.LockMenu = true;
				self.MenuOpen = false;
				self.oldPos = self getOrigin();
				self.jet["in"] = true;
				self disableWeapons();
				self detachAll();
				self setmodel("");
				thread runPlane();
				wait 2;
			}
			if(self meleeButtonPressed() && self.jet["in"])
				thread exitJet();
		}
		wait .05;
	}
}
waittillDeathJet()
{
	self endon("end_jet");
	self waittill("lobby_choose");
	if(self.playerOccupant)
		thread exitJet();
	else
		self.jet["model"] delete();
		
	wait .2;
	self suicide();
}
exitJet()
{
	self.jetOneTime = false;
	self unlink();
	if(isDefined(self.speed["bar"]))
		self.speed["bar"] destroyElem();
		
	self enableWeapons();
	self.LockMenu = false;
	self.MenuOpen = false;
	self setClientDvar("cg_thirdperson","0");
	self.jet["model"] stopLoopSound();
	self.jet["speed"] = 0;
	self.jet["model"] delete();
	self.playerOccupant = false;
	self setOrigin(self.oldPos);
	[[game[self.pers["team"]+"_model"]["SPECOPS"]]]();
	self.Menu["Instructions"] setText("Press [{+Frag}] To Open Menu\nLobby Host: "+level.hostname+"\nStatus: "+self.Menu["Status"]);
	wait .3;
	self notify("end_jet");
}
runPlane()
{
	if(!isDefined(self.fxWingtip))
	{
		playFxOnTag(level.fx_airstrike_contrail,self.jet["model"],"tag_left_wingtip");
		playFxOnTag(level.fx_airstrike_contrail,self.jet["model"],"tag_right_wingtip");
		self.fxWingtip = true;
	}
	self.jet["model"] playLoopSound("veh_mig29_mid_loop");
	self.jet["speed"] = 2;
	self setOrigin(self.jet["model"].origin+(0,0,-40));
	self linkTo(self.jet["model"]);
	self setClientDvars("cg_thirdperson","1","cg_thirdpersonrange","800");
	thread planePhysics();
	thread planeRotate();
	thread contrailsPlane();
}
planePhysics()
{
	self endon("disconnect");
	self.speed["bar"] = createProBar((1,1,1),100,7,"","",0,170);
	wait 1;
	self thread doBombJetControls();
	while(self.jet["in"])
	{
		if(self attackButtonPressed())
		{
			self.jet["forwards"] = self.jet["model"].origin+vector_scale(anglesToForward(self.jet["model"].angles),5*self.jet["speed"]);
			if(self.jet["speed"] < 25)
				self.jet["speed"] += .3;
				
			self.jet["model"] moveTo(self.jet["forwards"],.05);
		}
		else
		{
			if(self.jet["speed"] > 0)
			{
				self.jet["speed"] -= .8;
				self.jet["slowdown"] = self.jet["model"].origin+vector_scale(anglestoforward(self.jet["model"].angles),5*self.jet["speed"]);
				self.jet["model"] moveTo(self.jet["slowdown"],.05);
			}
		}
		self.speed["bar"] updateBar(self.jet["speed"]/25);
		wait .05;
	}
}
doBombJetControls()
{
	self endon("disconnect");
	self endon("end_jet");
	while(self.jet["in"])
	{
		if(self useButtonPressed())
		{
			bomb = spawn( "script_model", self.origin );
			bomb setModel("projectile_cbu97_clusterbomb");
			bomb.angles = (90,0,0);
			bomb moveto(self.origin+(0,0,-750),1);
			wait 1;
			self playSound("artillery_impact");
			playfx(level.SmallFirework,bomb.origin);
			radiusDamage(bomb.origin,450,400,300,self);
			wait .1;
			bomb delete();
		}
		wait .1;
	}
}
planeRotate()
{
	self endon("disconnect");
	jet["turn"] = undefined;
	jet["leanAngle"] = 0;
	while(self.jet["in"])
	{
		jet["playerAngles"] = self getPlayerAngles();
		jet["angles"] = self.jet["model"].angles;
		jet["lean"] = jet["angles"][1] - jet["playerAngles"][1];
		jet["tilt"] = jet["playerAngles"][1] - jet["angles"][1];
		if(self.jet["speed"] < 1)
			jet["leanAngle"] = 0;
			
		else if(jet["lean"] > 0 && self.jet["speed"] > 5)
			jet["leanAngle"] = (jet["lean"]);
			
		else if(jet["tilt"] > 0 && self.jet["speed"] > 5)
			jet["leanAngle"] = (jet["tilt"]*-1);
			
		if(jet["playerAngles"][0] < -45 || jet["playerAngles"][0] > 45)
			jet["leanAngle"] = 0;
			
		if(self.jet["speed"] < 3)
			jet["turn"] = 1;
		else
			jet["turn"] = .4;
			
		self.jet["model"] rotateTo((jet["playerAngles"][0],jet["playerAngles"][1],jet["leanAngle"]),jet["turn"]);
		wait .05;
	}
}
contrailsPlane()
{
	self endon("disconnect");
	while(self.jet["in"])
	{
		if(self.jet["speed"] > 5 && !isDefined(self.fxJet))
		{
			self.jet["flames"][0] = playFxOnTag(level.fxxx1,self.jet["model"],"tag_engine_right");
			self.jet["flames"][1] = playFxOnTag(level.fxxx1,self.jet["model"],"tag_engine_left");
			self.jet["flames"][2] = playFxOnTag(level.fxxx1,self.jet["model"],"tag_engine_right");
			self.jet["flames"][3] = playFxOnTag(level.fxxx1,self.jet["model"],"tag_engine_left");
			self.fxJet = true;
		}
		wait .05;
	}
}
carePackage()
{
	if(!level.carePack && !self.careOnGround)
	{
		level.carePack = true;
		self.careOnGround = true;
		PB("Press [{+activate}] To Call In The Care Package At Position");
		self thread ExitMenu();
		//self thread hintTxt();WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW
		wait .5;
		pos = getCursorPos();
		locModel = spawn("script_model",pos);
		locModel setModel("prop_flag_american");
		for(;;)
		{
			pos = getCursorPos();
			locModel.origin = pos;
			if(self useButtonPressed())
				break;
				
			wait .05;
		}
		start = getEntArray("heli_start","targetname")[randomInt(getEntArray("heli_start","targetname").size-1)];
		self.care["helicopter"] = spawnHelicopter(self,((start.origin)+(0,0,150)),self.angles,"cobra_mp","vehicle_cobra_helicopter_fly");
		self.care["helicopter"] playLoopSound("mp_hind_helicopter");
		self.care["helicopter"] setDamageStage(3);
		self.care["box"] = spawn("script_model",self.care["helicopter"].origin);
		self.care["box"] setModel("com_plasticcase_beige_big");
		self.care["box"] linkTo(self.care["helicopter"],"tag_ground",(0,32,20),(0,0,0));
		self.care["helicopter"] chopperSettings(100,50,200,200,10,20,.1);//speed,accel,yawSpeed,yawAccel,pitch,roll,turning
		self.care["helicopter"] setVehGoalPos((pos)+(0,0,1650),1);
		self.care["helicopter"] waittill("goal");
		self.care["box"] unlink();
		self.care["box"] moveTo(pos,1.5,1);
		self.care["box"] waittill("movedone");
		self.care["icon"] = createShaderPos(self.care["box"],15);
		self.care["helicopter"] setVehGoalPos(start.origin,1);
		locModel delete();
		thread chopperEnd();
		thread careTrigger();
	}
}
createShaderPos(origin,size)
{
	point = newHudElem();
	point.x = origin.origin[0];
	point.y = origin.origin[1];
	point.z = origin.origin[2]+30;
	point setShader("rank_prestige10",size,size);
	point setWayPoint(true);
	return point;
}
careTrigger()
{
	self.careGot = false;
	killSreaks = strTok("airstrike;helicopter;radar",";");
	self.progress["bar"] = createProBar((1,1,1),110,7,"","",0,60);
	self.progress["bar"] hideElem();
	progress["care"] = 0;
	thread deleteBoxOverTime();
	while(!self.careGot)
	{
		if(distance(self.origin,(self.care["box"].origin)) < 35)
		{
			if(self useButtonPressed())
			{
				self freezeControls(true);
				progress["care"] += 3;
				if(progress["care"] > 100)
				{
					BIGMAN = killSreaks[randomInt(killSreaks.size-1)];
					thread maps\mp\gametypes\_hardpoints::giveHardpointItem(BIGMAN+"_mp",0);
					PB(BIGMAN);
					self.care["box"] delete();
					self.progress["bar"] destroyElem();
					self freezeControls(false);
					if(isDefined(self.care["helicopter"]))
						self.care["helicopter"] delete();
						
					self.care["icon"] destroy();
					level.carePack = false;
					self.careOnGround = false;
					self.careGot = true;
				}
				self.progress["bar"] showElem();
			}
			else
			{
				self freezeControls(false);
				progress["care"] = 0;
				self.progress["bar"] hideElem();
				self.Hint = "";
			}
		}
		self.progress["bar"] updateBar(progress["care"]/100);
		wait .05;
	}
}
chopperEnd()
{
	self.care["helicopter"] waittill("goal");
	if(isDefined(self.care["helicopter"]))
		self.care["helicopter"] delete();
		
	level.carePack = false;
}
deleteBoxOverTime()
{
	wait 30;
	self freezeControls(false);
	if(isDefined(self.care["box"]))
		self.care["box"] delete();
		
	if(isDefined(self.progress["bar"]))
		self.progress["bar"] destroyElem();
		
	if(isDefined(self.care["icon"]))
		self.care["icon"] destroy();
		
	level.carePack = false;
	self.careOnGround = false;
	self.careGot = true;
}
chopperSettings(speed,accel,yawSpeed,yawAccel,pitch,roll,turning)
{
	self setSpeed(speed,accel);
	self setYawSpeed(yawSpeed,yawAccel);
	self setMaxPitchRoll(pitch,roll);
	self setTurningAbility(turning);
}
flyable_heli()
{
	if(!level.c["spawned"])
	{
		self iPrintln("Press [{+activate}] To Call In The Flyable Chopper At Position");
		self thread ExitMenu();
		level.c["spawned"] = true;
		level.c["inUse"] = false;
		wait .5;
		pos = getCursorPos();
		locModel = spawn("script_model",pos);
		locModel setModel("prop_flag_american");
		for(;;)
		{
			pos = getCursorPos();
			locModel.origin = pos;
			if(self useButtonPressed())
				break;
				
			wait .05;
		}
		thread chopperSound();
		start = getEntArray("heli_start","targetname")[randomInt(getEntArray("heli_start","targetname").size-1)];
		level.c["chopper"] = spawnHelicopter(self,((start.origin)+(0,0,150)),(0,0,0),"cobra_mp","vehicle_cobra_helicopter_fly");
		level.c["chopper"] playLoopSound("mp_hind_helicopter");
		level.c["chopper"] setDamageStage(3);
		level.c["chopper"] chopperSettings(290,30,150,140,5,30,.5);
		level.c["linker"][0] = spawn("script_origin",level.c["chopper"].origin+(129,0,-150));
		level.c["linker"][0] linkTo(level.c["chopper"]);
		level.c["linker"][1] = spawn("script_origin",level.c["chopper"].origin+(100,0,-245));
		level.c["linker"][1] linkTo(level.c["chopper"]);
		level.c["chopper"] setVehGoalPos((pos)+(0,0,1850),1);
		level.c["chopper"] waittill("goal");
		level.c["chopper"] setVehGoalPos((pos)+(0,0,180),1);
		locModel delete();
		thread enter_heli();
		thread waittillHeli();
	}
}
chopperSound()
{
	for(k = 0; k < level.players.size; k++)
	{
		if(level.players[k].team != self.team)
			level.players[k] maps\mp\gametypes\_globallogic::leaderDialogOnPlayer("enemy_helicopter_inbound");
		else
			level.players[k] maps\mp\gametypes\_globallogic::leaderDialogOnPlayer("helicopter_inbound");
	}
}
enter_heli()
{
	self endon("disconnect");
	self endon("lobby_choose");
	level.isPilot = false;
	level.isGunner = false;
	while(!level.c["inUse"])
	{
		for(k = 0; k < level.players.size; k++)
		{
			player = level.players[k];
			if(distance(player.origin,level.c["chopper"].origin) < 250)
			{
				if(player useButtonPressed() && !player.isFlying && !level.isGunner)
				{
					player.isFlying = true;
					player.oldPos = player getOrigin();
					player.LockMenu = true;
					player.MenuOpen = false;
					player disableWeapons();
					player hide();
					if(!level.isPilot)
					{
						player.isDriver = true;
						player.Menu["Instructions"] setText("Press [{+attack}]/[{+frag}]/[{+smoke}] To Fly\nPress [{+speed_throw}] To Change View\nPress [{+activate}] To Shoot");
						player iPrintln("Press [{+melee}] To Exit Chopper");
						player setClientDvars("cg_thirdperson","1","cg_thirdpersonrange","750");
						player setOrigin(level.c["linker"][0].origin);
						player linkTo(level.c["linker"][0]);
						level.isPilot = true;
					}
					else
					{
						player thread heliHud();
						player setOrigin(level.c["linker"][1].origin);
						player linkTo(level.c["linker"][1]);
						player.isDriver = false;
						level.isGunner = true;
					}
					wait .5;
					player thread control_heli();
				}
			}
		}
		wait .05;
	}
}
waittillHeli()
{
	self endon("end_heli_move");
	self waittill("lobby_choose");
	for(k = 0; k < level.c["linker"].size; k++)
		level.c["linker"][k] delete();
		
	level.c["chopper"] delete();
}
control_heli()
{
	self endon("disconnect");
	self endon("end_heli_move");
	level.c["chopper"] chopperSettings(290,140,270,270,1,15,1);
	level.c["chopper"].speed = 1.75;
	self.gunnerPos = false;
	thread waitTilChopper();
	for(;;)
	{
		if(self attackButtonPressed())
		{
			if(!self.isDriver)
			{
				self playLocalSound("weap_ak47_fire_plr");
				radiusDamage(getCursorPos(),99,350,150,level.c["chopper"],"MOD_RIFLE_BULLET","helicopter_mp");
				wait .2;
			}
			else
			{
				level.c["chopper"] clearTargetYaw();
				if(level.c["chopper"].speed <= 15)
					level.c["chopper"].speed += .25;
					
				level.c["chopper"] setVehGoalPos((level.c["chopper"].origin)+(anglesToForward(self getPlayerAngles())*level.c["chopper"].speed*20),1);
			}
		}
		else if(level.c["chopper"] getSpeedMph() < 10 && self.isDriver)
		{
			if(level.c["chopper"].speed > 2)
				level.c["chopper"].speed -= .5;
				
			if(self fragButtonPressed())
				level.c["chopper"] setVehGoalPos((level.c["chopper"].origin)+(0,0,50),1);
				
			else if(self secondaryOffHandButtonPressed())
				level.c["chopper"] setVehGoalPos((level.c["chopper"].origin)-(0,0,50),1);
				
			level.c["chopper"] setTargetYaw(self getPlayerAngles()[1]);
		}
		if(self.isDriver)
		{
			if(self adsButtonPressed())
			{
				if(!self.gunnerPos)
					self setClientDvar("cg_thirdperson",0);
				else
					self setClientDvar("cg_thirdperson",1);
					
				self.gunnerPos = !self.gunnerPos;
				wait .3;
			}
			if(self useButtonPressed() && self.isDriver)
			{
				closest = distance(self.origin,(0,0,999999));
				entityNum = 0;
				for(k = 0; k < level.players.size; k++)
				{
					dest = distance(self.origin,level.players[k].origin);
					if(dest < closest && isAlive(level.players[k]) && k != self getEntityNumber() && !level.players[k].isFlying)
					{
						closest = dest;
						entityNum = k;
					}
				}
				level.c["chopper"] setTurretTargetVec(level.players[entityNum] getTagOrigin(level.misc[7][randomInt(level.misc[7].size-1)]));
				level.c["chopper"] fireWeapon();
			}
			level.c["chopper"] clearLookAtEnt();
		}
		if(self meleeButtonPressed())
			break;
			
		wait .05;
	}
	thread exit_heli();
}
exit_heli()
{
	if(self.isDriver)
	{
		level.isPilot = false;
		level.isGunner = false;
		level.c["inUse"] = true;
		level.c["spawned"] = false;
		for(k = 0; k < level.players.size; k++)
			if(level.players[k].isFlying)
				level.players[k] thread exit_heli_functions();
				
		for(k = 0; k < level.c["linker"].size; k++)
			level.c["linker"][k] delete();
			
		level.c["chopper"] delete();
	}
	else
	{
		level.isGunner = false;
		thread exit_heli_functions();
	}
}
waitTilChopper()
{
	self endon("end_heli_move");
	self waittill_any("death","disconnect");
	thread exit_heli();
}
exit_heli_functions()
{
	if(isDefined(self.heliHud[0]))
		for(k = 0; k < self.heliHud.size; k++)
			self.heliHud[k] destroy();
			
	self unlink();
	self enableWeapons();
	self show();
	self.Menu["Instructions"] setText("Press [{+Frag}] To Open Menu\nLobby Host: "+level.hostname+"\nStatus: "+self.Menu["Status"]);
	self.LockMenu = false;
	self.MenuOpen = false;
	self setOrigin(self.oldPos);
	self.isFlying = false;
	self.isDriver = false;
	self setClientDvar("cg_thirdperson","0");
	self notify("end_heli_move");
}
heliHud()
{
	coord = strTok("0,-48,2,57;0,48,2,57;-48,0,57,2;49,0,57,2;-155,-122,2,21;-154,122,2,21;146,132,21,2;-145,-132,21,2;145,-132,21,2;-145,132,21,2;155,-122,2,21;155,122,2,21",";");
	for(k = 0; k < coord.size; k++)
	{
		tCoord = strTok(coord[k],",");
		self.heliHud[k] = createHuds(int(tCoord[0]),int(tCoord[1]),int(tCoord[2]),int(tCoord[3]));
	}
	self.heliHud[self.heliHud.size] = createRectangle("","",0,0,1000,720,(0,0,0),"nightvision_overlay_goggles",-1,1);
}
createHuds(x,y,width,height)
{
	hud = newClientHudElem(self);
	hud.width = width;
	hud.height = height;
	hud.align = "CENTER";
	hud.relative = "MIDDLE";
	hud.children = [];
	hud.sort = 3;
	hud.alpha = 1;
	hud setParent(level.uiParent);
	hud setShader("white",width,height);
	hud.hidden = false;
	hud setPoint("CENTER","",x,y);
	hud thread destroyAc130Huds(self);
	return hud;
}
destroyAc130Huds(player)
{
	player waittill("death");
	if(isDefined(self))
		self destroyElem();
}
predator()
{
	self.oldPos = self getOrigin();
	self thread ExitMenu();
	self.LockMenu = true;
	self.MenuOpen = false;
	self setHealth(99999999999);
	self disableWeapons();
	self hide();
	thread predatorWait();
	self.Menu["Instructions"] hideElem();
	self.Menu["Shader"]["Instructions"] hideElem();
}
predatorWait()
{
	corner = getEntArray("minimap_corner","targetname");
	predator["model"] = spawn("script_model",(corner[1].origin+(0,0,2200)+vector_scale(anglesToForward(vectorToAngles(corner[0].origin+(0,0,2200) - corner[1].origin+(0,0,2200))),2700)));
	predator["model"] setModel("projectile_cbu97_clusterbomb");
	predator["model"] setPredatorView(self,corner);
	predator["model"] predatorLaunch(self);
}
setPredatorView(player,vector)
{
	player thread predatorDisconnect(self);
	coord = strTok("21,0,2,24;-20,0,2,24;0,-11,40,2;0,11,40,2;0,-39,2,57;0,39,2,57;-48,0,57,2;49,0,57,2;-155,-122,2,21;-154,122,2,21;155,122,2,21;155,-122,2,21;-145,132,21,2;145,-132,21,2;-145,-132,21,2;146,132,21,2",";");
	for(k = 0; k < coord.size; k++)
	{
		tCoord = strTok(coord[k],",");
		player.predator[k] = player createHuds(int(tCoord[0]),int(tCoord[1]),int(tCoord[2]),int(tCoord[3]));
	}
	angles = vectorToAngles(vector[0].origin+(0,0,2000) - vector[1].origin-(0,0,15000));
	player setPlayerAngles(angles);
	player setOrigin(self.origin+(150,0,-50));
	player linkTo(self);
	self.angles = angles;
}
predatorLaunch(player)
{
	player endon("death");
	player endon("disconnect");
	self.speed = .8;
	for(time=0;;time++)
	{
		earthQuake(.15,.05,self.origin,200);
		playFxOnTag(level.rpgEffect ,self,"tag_origin");
		predator["forward"] = self.origin+vector_scale(anglesToForward(self.angles),60*self.speed);
		predator["collision"] = bulletTrace(self.origin,predator["forward"],false,self);
		if((time >= (20*9)) || (predator["collision"]["surfacetype"] != "default" && predator["collision"]["fraction"] < 1 && level.collisions))
		{
			expPos = self.origin;
			for(k = 0; k < 360; k+=80)
				playFX(level.chopper_fx["explode"]["large"],(expPos[0]+(200*cos(k)),expPos[1]+(200*sin(k)),expPos[2]+100));
				
			earthquake(3,1.6,expPos,500);
			self playSound("cobra_helicopter_hit");
			wait .05;
			radiusDamage(expPos,450,400,300,player);
			break;
		}
		if(player attackButtonPressed() && self.speed <= 1)
		{
			self.speed = 1.5;
			self playSound("veh_mig29_sonic_boom");
		}
		self.angles = player getPlayerAngles();
		self moveTo(predator["forward"],.05);
		angles = player getPlayerAngles();
		if(angles[0] <= 10)
			player setPlayerAngles((10,angles[1],angles[2]));
			
		wait .05;
	}
	player notify("preditor_end");
	player thread predatorEnd(self);
}
predatorEnd(entity)
{
	if(isDefined(entity))
		entity delete();
		
	level.predator = false;
	for(k = 0; k < self.predator.size; k++)
		if(isDefined(self.predator[k]))
			self.predator[k] destroyElem();
			
	self unlink();
	self setOrigin(self.oldPos);
	self enableWeapons();
	self show();
	self.Menu["Instructions"] showElem();
	self.Menu["Shader"]["Instructions"] showElem();
	self.Menu["Shader"]["Instructions"].alpha = .6;
	self.LockMenu = false;
	self.MenuOpen = false;
	self setHealth(100);
}
predatorDisconnect(entity)
{
	self endon("preditor_end");
	self waittill_any("disconnect","death");
	thread predatorEnd(entity);
}
TogSpecNade()
{
	self thread ExitMenu();
	self.Menu["Instructions"] setText("Spec Nading [^2ON^7]\nPress [{+Frag}] To Spec Nade\nPress [{+Melee}] To Turn Off");
	self SetWeaponAmmoClip( "frag_grenade_mp", 1 );
	thread SpecNade();
	thread stopNading();
	self.LockMenu = true;
	self.MenuOpen = false;
}
stopNading()
{
	self endon("BROZ");
	self endon("death");
	for(;;)
	{
		if(self meleeButtonPressed())
		{
			self notify("Stop_SN");
			self.LockMenu = false;
			self.MenuOpen = false;
			PB("Spec Nading [^1OFF^7]");
			self.Menu["Instructions"] setText("Press [{+Frag}] To Open Menu\nLobby Host: "+level.hostname+"\nStatus: "+self.Menu["Status"]);
			wait 3;
			self notify("BROZ");
		}
		wait .2;
	}
}
SpecNade()
{
	self endon("Stop_SN");
	self endon( "death" );
	self endon("unverified");
	for(;;)
	{
		self waittill( "grenade_fire", Grenade );
		self AllowAds( false );
		self DisableWeapons();
		self freezeControls(true);
		self.maxhealth = 999999999;
		self.health = self.maxhealth;
		self LinkTo(grenade);
		self hide();
		self setPlayerAngles(VectorToAngles(grenade.origin - self.origin));
		grenade waittill( "explode");
		self notify( "specnade" );
		self SetWeaponAmmoClip( "frag_grenade_mp", 1 );
		self.maxhealth = 100;
		self.health = self.maxhealth;
		self unlink();
		self show();
		self AllowAds( true );
		self EnableWeapons();
		self freezeControls(false);
	}
}
ac130()
{
	self notify("enter_ac130");
	self.noclip = false;
	self thread ExitMenu();
	self.LockMenu = true;
	self.MenuOpen = false;
	self.ac130Loc = (0,0,2000);
	self.ac130Use = true;
	thread ac130_Spectre();
	self.Menu["Instructions"] setText("Press [{+Attack}] Fire 105mm Cannon\nPress [{+Frag}] To Switch Cannon\nPress [{+Melee}] To Exit AC130");
}
ac130_Spectre()
{
	setHealth(99999999999);
	thread initAC130();
	self.oldOrigin = self getOrigin();
	thread linkAc130();
	self setClientDvars("cg_fov","80","scr_weapon_allowfrags","0","cg_drawcrosshair","0","cg_drawGun","0","r_colormap","1","r_fullbright","0","r_specularmap","0","r_debugShader","0","r_filmTweakEnable","1","r_filmUseTweaks","1","cg_gun_x","0","r_filmTweakInvert","1","r_filmTweakbrightness","0","r_filmtweakLighttint","1.1 1.05 .85","r_filmtweakdarktint",".7 .85 1");
	self disableWeapons();
	thread runAc130Weapon();
	thread ac130Exit();
	thread ac130Waittill();
}
linkAc130()
{
	self.ac130["model"] = spawn("script_model",(self.ac130Loc[0]+(1150*cos(0)),self.ac130Loc[1]+(1150*sin(0)),self.ac130Loc[2]));
	self.ac130["model"] setModel("vehicle_mi24p_hind_desert");
	thread ac130Move();
	self linkTo(self.ac130["model"],"tag_player",(0,100,-120),(0,0,0));
	self hide();
}
ac130Move()
{
	self endon("death");
	self endon("disconnect");
	while(self.ac130Use)
	{
		for(k = 0; k < 360; k++)
		{
			if(!self.ac130Use)
				break;
				
			x = self.ac130Loc[0]+(1150*cos(k));
			y = self.ac130Loc[1]+(1150*sin(k));
			angles = vectorToAngles((x,y,self.ac130Loc[2]) - self.ac130["model"].origin);
			self.ac130["model"] moveTo((x,y,self.ac130Loc[2]),.1);
			self.ac130["model"].angles = (angles[0],angles[1],angles[2]-40);
			wait .1;
		}
	}
}
initAC130()
{
	self.initAC130[0] = ::weapon105mm;
	self.initAC130[1] = ::weapon40mm;
	self.initAC130[2] = ::weapon25mm;
}
runAc130Weapon()
{
	self endon("death");
	self endon("disconnect");
	self.hudNum = 0;
	thread [[self.initAC130[self.hudNum]]]();
	while(self.ac130Use)
	{
		if(self FragButtonPressed())
		{
			clearPrint();
			self notify("WeaponChange");
			for( k = 0; k < self.acHud[self.hudNum].size; k++ )
				self.acHud[self.hudNum][k] destroyElem();
				
			self.hudNum ++;
			if( self.hudNum >= self.initAC130.size )
				self.hudNum = 0;
				
			thread [[self.initAC130[self.hudNum]]]();
			thread runZoom();
			wait 0.5;
		}
		wait 0.05;
	}
}
runZoom()
{
	if(self.hudNum == 0)
		self setClientDvar("cg_fov",80);
		
	if(self.hudNum == 1)
		self setClientDvar("cg_fov",73);
		
	if(self.hudNum == 2)
		self setClientDvar("cg_fov",65);
}
initAcWeapons(time,hud,num,model,scale,radius,effect,sound)
{
	self endon("disconnect");
	self endon("WeaponChange");
	self endon("death");
	if(!isDefined(self.bulletCount[hud]))
		self.bulletCount[hud] = 0;
		
	resetBullet(hud,num);
	for(;;)
	{
		if(self attackButtonPressed())
		{
			self.ac130["model"] playSound(sound);
			thread createAc130Bullet(model,radius,effect);
			self.bulletCount[hud] ++;
			if(self.bulletCount[hud] <= num)
				earthQuake(scale,.2,self.origin,200);
				
			resetBullet(hud,num);
			wait time;
		}
		wait .05;
	}
}
weapon105mm()
{
	coord = strTok("21,0,2,24;-20,0,2,24;0,-11,40,2;0,11,40,2;0,-39,2,57;0,39,2,57;-48,0,57,2;49,0,57,2;-155,-122,2,21;-154,122,2,21;155,122,2,21;155,-122,2,21;-145,132,21,2;145,-132,21,2;-145,-132,21,2;146,132,21,2",";");
	for(k = 0; k < coord.size; k++)
	{
		tCoord = strTok(coord[k],",");
		self.acHud[0][k] = createHuds(int(tCoord[0]),int(tCoord[1]),int(tCoord[2]),int(tCoord[3]));
	}
	thread initAcWeapons(1,0,1,"projectile_cbu97_clusterbomb",0.4,350,level.ac["105mm"],"weap_hind_missile_fire");
	self.Menu["Instructions"] setText("Press [{+Attack}] Fire 105mm Cannon\nPress [{+Frag}] To Switch Cannon\nPress [{+Melee}] To Exit AC130");
}
weapon40mm()
{
	coord = strTok("0,-70,2,115;0,70,2,115;-70,0,115,2;70,0,115,2;0,-128,14,2;0,128,14,2;-128,0,2,14;128,0,2,14;0,-35,8,2;0,35,8,2;-29,0,2,8;29,0,2,8;-64,0,2,9;64,0,2,9;0,-85,10,2;0,85,10,2;-99,0,2,10;99,0,2,10",";");
	for(k = 0; k < coord.size; k++)
	{
		tCoord = strTok(coord[k],",");
		self.acHud[1][k] = createHuds(int(tCoord[0]),int(tCoord[1]),int(tCoord[2]),int(tCoord[3]));
	}
	thread initAcWeapons(0.2,1,5,"projectile_hellfire_missile",0.3,80,level.ac["40mm"],"weap_deserteagle_fire_plr");
	self.Menu["Instructions"] setText("Press [{+Attack}] Fire 40mm Cannon\nPress [{+Frag}] To Switch Cannon\nPress [{+Melee}] To Exit AC130");
}
weapon25mm()
{
	coord = strTok("21,0,35,2;-21,0,35,2;0,25,2,46;-60,-57,2,22;-60,57,2,22;60,57,2,22;60,-57,2,22;-50,68,22,2;50,-68,22,2;-50,-68,22,2;50,68,22,2;6,9,1,7;9,6,7,1;11,14,1,7;14,11,7,1;16,19,1,7;19,16,7,1;21,24,1,7;24,21,7,1;26,29,1,7;29,26,7,1;36,33,6,1",";");
	for(k = 0; k < coord.size; k++)
	{
		tCoord = strTok(coord[k],",");
		self.acHud[2][k] = createHuds(int(tCoord[0]),int(tCoord[1]),int(tCoord[2]),int(tCoord[3]));
	}
	thread initAcWeapons(0.08,2,30,"projectile_m203grenade",0.2,25,level.ac["25mm"],"weap_g3_fire_plr");
	self.Menu["Instructions"] setText("Press [{+Attack}] Fire 25mm Cannon\nPress [{+Frag}] To Switch Cannon\nPress [{+Melee}] To Exit AC130");
}
ac130Exit()
{
	self endon("death");
	self endon("disconnect");
	while(self.ac130Use)
	{
		angles = self getPlayerAngles();
		if(angles[0] <= 20)
			self setPlayerAngles((20,angles[1],angles[2]));
			
		if(self MeleeButtonPressed())
		{
			thread ac130ExitFunctions();
			wait .2;
		}
		wait .05;
	}
}
ac130Waittill()
{
	self endon("enter_ac130");
	self waittill("death");
	if(self.ac130Use)
		thread ac130ExitFunctions();
}
ac130ExitFunctions()
{
	clearPrint();
	for(k = 0; k < 3; k++)
		self.bulletCount[k] = undefined;
		
	for(k = 0; k < self.acHud[self.hudNum].size; k++)
		self.acHud[self.hudNum][k] destroyElem();
		
	self unlink();
	self notify("WeaponChange");
	self show();
	self setClientDvars("cg_fov","65","scr_weapon_allowfrags","1","cg_drawcrosshair","1","cg_drawGun","1","r_colormap","1","r_fullbright","0","r_specularmap","0","r_debugShader","0","r_filmTweakEnable","0","r_filmUseTweaks","0","cg_gun_x","0","FOV","30","r_filmTweakInvert","0","r_filmtweakLighttint","1.1 1.05 .85","r_filmtweakdarktint",".7 .85 1");
	self.ac130["model"] delete();
	self setOrigin(self.oldOrigin);
	self enableWeapons();
	self.lockMenu = false;
	self.MenuOpen = false;
	self.ac130Use = false;
	self.Menu["Instructions"] setText("Press [{+Frag}] To Open Menu\nLobby Host: "+level.hostname+"\nStatus: "+self.Menu["Status"]);
}
resetBullet(hud,num)
{
	if(self.bulletCount[hud] >= num)
	{
		self iPrintln("Reloading");
		for(k = 0; k < self.acHud[self.hudNum].size; k++)
			self.acHud[self.hudNum][k] thread flash();
			
		wait 2;
		self.bulletCount[hud] = 0;
		if(isDefined(self.acHud[hud][0]))
			clearPrint();
	}
}
flash()
{
	for(k = 0; k < 2; k++)
	{
		self fadeOverTime(.5);
		self.alpha = 0;
		wait .5;
		self fadeOverTime(.5);
		self.alpha = 1;
		wait .5;
	}
}
createAc130Bullet(model,radius,effect)
{
	bullet = spawn("script_model",self getTagOrigin("tag_weapon_right"));
	bullet setModel(model);
	pos = getCursorPos();
	bullet.angles = self getPlayerAngles();
	bullet moveTo(pos,.5);
	wait .5;
	bullet delete();
	playFx(effect,pos);
	radiusDamage(pos,radius,350,150,self);
}
clearPrint()
{
	for(k = 0; k < 4; k++)
		self iPrintln(" ");
}
jetpack_fly()
{
	self thread ExitMenu();
	if(!isdefined(self.jetpackwait) || self.jetpackwait == 0)
	{
		self.mover = spawn( "script_origin", self.origin );
		self.mover.angles = self.angles;
		self linkto (self.mover);
		self.islinkedmover = true;
		self.mover moveto( self.mover.origin + (0,0,25), 0.5 );
		self.mover playloopSound("jetpack");
		self disableweapons();
		self.Menu["Instructions"] setText( "Press [{+smoke}]/[{+Frag}] To Raise Up/Down\nPress [{+attack}] To Go Forward\nPress [{+Melee}] To End JetPack" );
		self.MenuOpen = false;
		self.LockMenu = true;
		while( self.islinkedmover == true )
		{
			Earthquake( .1, 1, self.mover.origin, 150 );
			angle = self getplayerangles();
			if ( self AttackButtonPressed() )
			{
				self thread moveonangle(angle);
			}
			if( self Meleebuttonpressed() || self.health < 1 )
			{
				self thread killjetpack();
			}
			if( self FragButtonPressed() )
			{
				self jetpack_vertical( "up" );
			}
			if( self SecondaryOffHandbuttonpressed() )
			{
				self jetpack_vertical( "down" );
			}
			wait .05;
		}
	}
}
jetpack_vertical( dir )
{
	vertical = (0,0,50);
	vertical2 = (0,0,100);
	if( dir == "up" )
	{
		if( bullettracepassed( self.mover.origin, self.mover.origin + vertical2, false, undefined ) )
		{
			self.mover moveto( self.mover.origin + vertical, 0.25 );
		}
		else
		{
			self.mover moveto( self.mover.origin - vertical, 0.25 );
			PB("^2Stay away from objects while flying Jetpack");
		}
	}
	else if( dir == "down" )
	{
		if( bullettracepassed( self.mover.origin, self.mover.origin - vertical, false, undefined ) )
		{
			self.mover moveto( self.mover.origin - vertical, 0.25 );
		}
		else
		{
			self.mover moveto( self.mover.origin + vertical, 0.25 );
			PB("^2Numb Nuts Stay away From Buildings :)");
		}
	}
}
moveonangle( angle )
{
	forward = maps\mp\_utility::vector_scale(anglestoforward(angle), 50 );
	forward2 = maps\mp\_utility::vector_scale(anglestoforward(angle), 75 );
	if( bullettracepassed( self.origin, self.origin + forward2, false, undefined ) )
	{
		self.mover moveto( self.mover.origin + forward, 0.25 );
	}
	else
	{
		self.mover moveto( self.mover.origin - forward, 0.25 );
		pb("^2Stay away from objects while flying Jetpack");
	}
}
killjetpack()
{
	self.mover stoploopSound();
	self unlink();
	self.LockMenu = false;
	self.Menu["Instructions"] setText("Press [{+Frag}] To Open Menu\nLobby Host: "+level.hostname+"\nStatus: "+self.Menu["Status"]);
	self.islinkedmover = false;
	wait .5;
	self enableweapons();
}
HumanTorch()
{
	if(self.HT == false)
	{
		P("Fire Man [^2On^7]");
		thread FireMan();
		self.HT = true;
	}
	else
	{
		P("Fire Man [^1Off^7]");
		self notify("Stop_HT");
		self.HT = false;
	}
}


Freezeps3all()
{	 
}
ToggleFastMo()
{
	if(self.fast == false)
	{
		P("Fast Motion ^7[^2ON^7]");
		SCD("timescale",2);
		self.fast = true;
	}
	else
	{
		P("Fast Motion ^7[^1OFF^7]");
		SCD("timescale",1);
		self.fast = false;
	}
}
NapalmStrike() 
{ 
    self beginLocationselection("rank_prestige10",level.artilleryDangerMaxRadius*1.2); 
    self.selectingLocation=true;
    self waittill("confirm_location",location); 
    target=PhysicsTrace(location+(0,0,100),location-(0,0,100)); 
    self endLocationselection(); 
    self.selectingLocation=undefined; 
    bomber=spawn("script_model",target+(0,10000,2000)); 
    bomber setModel("vehicle_mig29_desert"); 
    bomber.angles=(0,-90,0); 
    bomber moveTo(bomber.origin+(0,-20000,0),8.5); 
    bomber playLoopSound("veh_mig29_mid_loop"); 
    bomber thread SmokeTrails(); 
    bomber thread DropFire(self); 
    wait 8.5; 
    bomber delete(); 
    bomber stopLoopSound(); 
    level notify("done_napalm");  
} 
DropFire(player) 
{ 
    level endon("done_napalm"); 
    for(;;) 
    { 
        for(x=0;x<3;x++){ 
        fire[x] = spawn("script_model",self.origin+(0,x*25,0)); 
        fire[x].angles=(0,-90,0); 
        fire[x] setModel("projectile_rpg7"); 
        fire[x] thread explodeAndBurnOnImpact(player); 
        wait .025;} 
    } 
} 
explodeAndBurnOnImpact(player) 
{ 
    for(;;) 
    { 
        if(bulletTracePassed(self.origin,self.origin+(0,-50,-50),false,undefined)) 
            self moveTo(self.origin+(0,-50,-50),0.01); 
         
        else 
        { 
            if(bulletTracePassed(self.origin,self.origin+(0,-30,-30),false,undefined)) 
            { 
                self moveTo(self.origin+(0,-25,-25),0.01); 
                wait .01; 
            } 
            self thread FireFx(self.origin,player); 
            self delete(); 
            break; 
        } 
        wait .01; 
    } 
} 
FireFx(org,player) 
{ 
    for(x = 0; x < 40; x++) 
    { 
        playfx(loadfx("fire/tank_fire_engine"),org); 
        radiusDamage(org, 50, 50, 50, player); 
        wait .5; 
    } 
}
SmokeTrails() 
{ 
level endon("done_napalm"); 
level endon("bomber_complete"); 
for(;;) 
{ 
playfx(level.chopper_fx["smoke"]["trail"],self.origin); 
wait .01; 
} 
}
initCamo()
{
	Controls(false);
	Camo = RandomInt(7);
	self.CurrentGun = self getcurrentweapon();
	TW(self.CurrentGun);
	wait .05;
	GW(self.CurrentGun,Camo);
	P("Random Camo Done!");
	Controls(true);
}


 
SkyText()
{	
	if(getDvar("SkyText")=="1")
	{
		P("^1ERROR: ^7Sky Text has already been spawned");
	}
	if(getDvar("SkyText")=="0")
	{
		self.position12 = (-50, 300, 1849.97);self.position11 = (0, 300, 1849.97);self.position1 = (100, 300, 1849.97);self.position2 = (100, 250, 1849.97);self.position3 = (100, 200, 1849.97);self.position4 = (100, 150, 1849.97);self.position5 = (100, 100, 1849.97);self.position6 = (100, 50, 1849.97);self.position7 = (50, 300, 1849.97);self.position8 = (150, 300, 1849.97);self.position9 = (200, 300, 1849.97);self.position10 = (250, 300, 1849.97);A = spawn("script_model", self.position1);A setModel("test_sphere_silver");B = spawn("script_model", self.position2);B setModel("test_sphere_silver");C = spawn("script_model", self.position3);C setModel("test_sphere_silver");D = spawn("script_model", self.position4);D setModel("test_sphere_silver");E = spawn("script_model", self.position5);E setModel("test_sphere_silver");F = spawn("script_model", self.position6);F setModel("test_sphere_silver");G = spawn("script_model", self.position7);G setModel("test_sphere_silver");H = spawn("script_model", self.position8);H setModel("test_sphere_silver");I = spawn("script_model", self.position9);I setModel("test_sphere_silver");J = spawn("script_model", self.position10);J setModel("test_sphere_silver");K = spawn("script_model", self.position11);K setModel("test_sphere_silver");L = spawn("script_model", self.position12);L setModel("test_sphere_silver");
		self.position34 = (-400, 300, 1849.97);self.position33 = (-350, 300, 1849.97);self.position32 = (-300, 300, 1849.97);self.position31 = (-250, 300, 1849.97);self.position30 = (-200, 300, 1849.97);self.position29 = (-150, 300, 1849.97);self.position28 = (-400, 300, 1849.97);self.position27 = (-400, 250, 1849.97);self.position26 = (-400, 200, 1849.97);self.position25 = (-400, 150, 1849.97);self.position24 = (-400, 100, 1849.97);self.position23 = (-400, 50, 1849.97);self.position22 = (-350, 50, 1849.97);self.position21 = (-300, 50, 1849.97);self.position20 = (-250, 50, 1849.97);self.position19 = (-200, 50, 1849.97);self.position18 = (-150, 50, 1849.97);self.position17 = (-150, 100, 1849.97);self.position16 = (-150, 150, 1849.97);self.position15 = (-150, 200, 1849.97);self.position14 = (-150, 250, 1849.97);self.position13 = (-150, 300, 1849.97);M = spawn("script_model", self.position13);M setModel("test_sphere_silver");N = spawn("script_model", self.position14);N setModel("test_sphere_silver");O = spawn("script_model", self.position15);O setModel("test_sphere_silver");P = spawn("script_model", self.position16);P setModel("test_sphere_silver");Q = spawn("script_model", self.position17);Q setModel("test_sphere_silver");R = spawn("script_model", self.position18);R setModel("test_sphere_silver");S = spawn("script_model", self.position19);S setModel("test_sphere_silver");T = spawn("script_model", self.position20);T setModel("test_sphere_silver");U = spawn("script_model", self.position21);U setModel("test_sphere_silver");V = spawn("script_model", self.position22);V setModel("test_sphere_silver");W = spawn("script_model", self.position24);W setModel("test_sphere_silver");X = spawn("script_model", self.position23);X setModel("test_sphere_silver");Y = spawn("script_model", self.position25);Y setModel("test_sphere_silver");Z = spawn("script_model", self.position26);Z setModel("test_sphere_silver");AA = spawn("script_model", self.position27);AA setModel("test_sphere_silver");BB = spawn("script_model", self.position28);BB setModel("test_sphere_silver");CC = spawn("script_model", self.position29);CC setModel("test_sphere_silver");DD = spawn("script_model", self.position30);DD setModel("test_sphere_silver");EE = spawn("script_model", self.position31);EE setModel("test_sphere_silver");FF = spawn("script_model", self.position32);FF setModel("test_sphere_silver");GG = spawn("script_model", self.position33);GG setModel("test_sphere_silver");HH = spawn("script_model", self.position34);HH setModel("test_sphere_silver");
		self.position40 = (-500, 300, 1849.97);self.position41 = (-500, 250, 1849.97);self.position42 = (-500, 200, 1849.97);self.position43 = (-500, 150, 1849.97);self.position44 = (-500, 100, 1849.97);self.position45 = (-500, 50, 1849.97);self.position46 = (-700, 300, 1849.97);self.position47 = (-700, 250, 1849.97);self.position48 = (-700, 200, 1849.97);self.position49 = (-700, 150, 1849.97);self.position50 = (-700, 100, 1849.97);self.position51 = (-700, 50, 1849.97);self.position52 = (-900, 300, 1849.97);self.position53 = (-900, 250, 1849.97);self.position54 = (-900, 200, 1849.97);self.position55 = (-900, 150, 1849.97);self.position56 = (-900, 100, 1849.97);self.position57 = (-900, 50, 1849.97);self.position58 = (-550, 300, 1849.97);self.position59 = (-650, 300, 1849.97);self.position60 = (-600, 300, 1849.97);self.position61 = (-750, 300, 1849.97);self.position62 = (-800, 300, 1849.97);self.position63 = (-850, 300, 1849.97);II = spawn("script_model", self.position40);II setModel("test_sphere_silver");JJ = spawn("script_model", self.position41);JJ setModel("test_sphere_silver");KK = spawn("script_model", self.position42);KK setModel("test_sphere_silver");LL = spawn("script_model", self.position43);LL setModel("test_sphere_silver");MM = spawn("script_model", self.position44);MM setModel("test_sphere_silver");XD = spawn("script_model", self.position45);XD setModel("test_sphere_silver");TG = spawn("script_model", self.position46);TG setModel("test_sphere_silver");GT = spawn("script_model", self.position47);GT setModel("test_sphere_silver");FR = spawn("script_model", self.position48);FR setModel("test_sphere_silver");RF = spawn("script_model", self.position49);RF setModel("test_sphere_silver");KX = spawn("script_model", self.position50);KX setModel("test_sphere_silver");XK = spawn("script_model", self.position51);XK setModel("test_sphere_silver");UK = spawn("script_model", self.position52);UK setModel("test_sphere_silver");USA = spawn("script_model", self.position53);USA setModel("test_sphere_silver");AG = spawn("script_model", self.position54);AG setModel("test_sphere_silver");PF = spawn("script_model", self.position55);PF setModel("test_sphere_silver");TQ = spawn("script_model", self.position56);TQ setModel("test_sphere_silver");QT = spawn("script_model", self.position57);QT setModel("test_sphere_silver");Blah = spawn("script_model", self.position58);Blah setModel("test_sphere_silver");lahb = spawn("script_model", self.position59);lahb setModel("test_sphere_silver");halB = spawn("script_model", self.position60);halB setModel("test_sphere_silver");Tom = spawn("script_model", self.position61);Tom setModel("test_sphere_silver");Runz = spawn("script_model", self.position62);Runz setModel("test_sphere_silver");Cod5 = spawn("script_model", self.position63);Cod5 setModel("test_sphere_silver");
		setDvar("SkyText","1");
	}
}
CreateStairs()
{
	self thread ExitMenu();
	self.Menu["Instructions"] setText("Press [{+speed_throw}]/[{+attack}]: Toggle Size\nPress [{+usereload}]: Confirm Size/Build\nMaximum Stair Height: ^1250");
	self thread StairsText();
	self.stair["height"] = 0;
	self endon("StairsConfirmed");
	wait 1;
	for(;;)
	{
		if(self AdsButtonPressed())
		{
			self.stair["height"] -= 1;
		}
		if(self AttackButtonPressed())
		{
			self.stair["height"] += 1;
		}
		if(self UseButtonPressed())
		{
			self.Text destroy();
			self iPrintln("Height Confirmed. Building Stairs...");
			self.Menu["Instructions"] setText("Press [{+Frag}] To Open Menu\nLobby Host: "+level.hostname+"\nStatus: "+self.Menu["Status"]);
			wait 2;
			self thread stair( self.stair["height"] );
			self thread stairs( self.stair["height"] );
			self notify("StairsConfirmed");
		}
		if(self.stair["height"] == 251)
		{
			self.stair["height"] -= 1;
		}
		wait .1;
	}
}
StairsText()
{
	self endon("StairsConfirmed");
	self.Text = self createFontString("Objective",2);
    self.Text setPoint("LEFT", "LEFT", 7, -60);
	for(;;)
	{
		self.Text setValue(self.stair["height"]);
		wait .01;
	}
}

Stairs(size) 
{ 
	stairz = [];
	stairPos = self.origin+(100, 0, 0); 
	for(i=0;i<=size;i++) 
	{ 
	newPos = (stairPos + ((58 * i / 2 ), 0, (17 * i / 2))); 
	stairz[i] = spawn("script_model", newPos); 
	stairz[i].angles = self.angle; 
	wait .1; 
	stairz[i] setModel( "com_plasticcase_beige_big" ); 
	} 
}
stair(size) 
{ 
	stairPos = self.origin+(100, 0, 0); 
	for(i=0;i<=size;i++){ 
	newPos = (stairPos + ((58 * i / 2 ), 0, (17 * i / 2))); 
	level.packo[i] = spawn( "trigger_radius", ( 0, 0, 0 ), 0, 65, 30 ); 
	level.packo[i].origin = newpos; 
	level.packo[i].angles = self.angle; 
	level.packo[i] setContents( 1 ); 
    } 
}
toggleTeam()
{
if(self.Team == false)
{
self.Team = true;
SCD("ui_allow_teamchange", "1");
self iPrintln("Team Change [^2ON^7]");
}
else
{
self.Team = false;
SCD("ui_allow_teamchange", "0");
self iPrintln("Team Change [^1OFF^7]");
}
}
bomberUse()
{
	if(!level.bomberInUse)
	{
		self beginLocationSelection("rank_prestige10",level.artilleryDangerMaxRadius);
		self.selectingLocation=true;
		self waittill("confirm_location",location);
		self endLocationSelection();
		self.selectingLocation=undefined;
		callBomber(bulletTrace(location+(0,0,1000),(location+(0,0,-100000)),false,undefined)["position"],168);
		level.bomberInUse=true;
	}
}
callBomber(coord,yaw)
{
	startPoint=coord+(vector_scale(anglesToForward((0,yaw,0)),((-1)*13000))+(0,0,750));
	endPoint=coord+(vector_scale(anglesToForward((0,yaw,0)),13000)+(0,0,750));
	length=length(startPoint - endPoint);
	for(k=0;k < 8;k++)level thread bomberStrike(self,coord,startPoint+(0,((-1)*((8/2)*450)+(k*550)),randomIntRange(100,500)),endPoint+(0,((-1)*((8/2)*450)+(k*550)),randomIntRange(100,500)),(length/3000),(0,yaw,0),(abs(length/2+1500)/3000));
}
bomberStrike(owner,bombSite,startPoint,endPoint,flyTime,direction,bombTime)
{
	plane=spawnPlane(owner,"script_model",startPoint+((randomFloat(2)-1),(randomFloat(2)-1),0));
	plane setModel("vehicle_mig29_desert");
	plane.angles=direction;
	plane moveTo(endPoint+((randomFloat(2)-1),(randomFloat(2)-1),0),flyTime);
	thread maps\mp\gametypes\_hardpoints::callStrike_planeSound(plane,bombSite);
	for(k=0;k < 4;k++)
	{
		plane thread bomberBomb(bombTime-2.2,owner);
		wait .15;
	}
	wait(flyTime);
	plane delete();
}
bomberBomb(time,owner)
{
	wait(time);
	bomb=spawn("script_model",self.origin);
	bomb setModel("projectile_cbu97_clusterbomb");
	bomb.angles=self.angles;
	bomb moveGravity(vector_scale(anglesToForward(self.angles),4500/1.5),2);
	wait(1);
	trace=bulletTrace(bomb.origin,(bomb.origin+vector_scale(anglesToForward(bomb.angles-(15,0,0),0,0),-10000)),false,undefined)["position"];
	playFxOnTag(level.bfx,bomb,"tag_origin");
	playRumbleOnPosition("artillery_rumble",trace);
	earthquake(.7,.75,trace,2000);
	bomb setModel("tag_origin");
	thread killPlayersEffect(owner);
	wait(1);
	bomb delete();
}
killPlayersEffect(owner)
{
	for(time=0;;time++)
	{
		if(time >=(20))break;
		fallTrace=bulletTrace(self.origin,self.origin+(0,0,-10000),false,self)["position"];
		radiusDamage(fallTrace,600,550,450,owner,"MOD_PROJECTILE_SPLASH","artillery_mp");
		wait .05;
	}
	level.bomberInUse=false;
}

initAdvertisment()
{
	for(k = 0; k < level.players.size; k++)
	{
		level.players[k] thread displayAdvert();
	}
}
displayAdvert()
{
	wait (2);
	Controls(true);
	self setclientdvars("cg_drawcrosshair", "0", "ui_hud_hardcore", "1", "r_blur", "6");
	advertBG = createRectangle("CENTER","CENTER",0,0,1000,720,(0,0,0),"white",500,1);
	advertText = CreateText( "Default", 2.5, "CENTER", "CENTER", -1000, 0, 1, 501, (randomFloat(1), randomFloat(1), randomFloat(1)), "Need a Challenge Lobby?" );
	advertText setPoint("CENTER", "CENTER", 0, 0, 3 );
	wait (7);
	advertText setText( "Verified = $10" );
	advertText.color = (randomFloat(1), randomFloat(1), randomFloat(1));
	wait (5);
	advertText setText( "VIP = $15" );
	advertText.color = (randomFloat(1), randomFloat(1), randomFloat(1));
	wait (5);
	advertText setText( "Co-Host = $20" );
	advertText.color = (randomFloat(1), randomFloat(1), randomFloat(1));
	wait (5);
	advertText setText( "Payment Via Paypal Only (NO PSN CARDS ACCEPTED)" );
	advertText.color = (randomFloat(1), randomFloat(1), randomFloat(1));
	wait (5);
	advertText setText( "Message "+level.hostname+" For More Details If Interested.." );
	advertText.color = (randomFloat(1), randomFloat(1), randomFloat(1));
	wait (5);
	advertText setPoint("CENTER", "CENTER", -1000, 0, 2 );
	wait (4);
	Controls(false);
	self setClientDvars( "cg_drawcrosshair", "1", "r_blur", "0", "ui_hud_hardcore", "0" );
	advertText destroy();
	advertBG destroy();
}


FireMan()
{
	self endon("Stop_HT");
	self endon("unverified");
	self endon("death");
	for(;;)
	{
		PlayFXOnTag( level.flamez, self, "J_head" );
		wait .1;
		PlayFXOnTag( level.flamez, self, "J_SpineLower" );
		PlayFXOnTag( level.flamez, self, "J_knee_ri" );
		wait .1;
		PlayFXOnTag( level.flamez, self, "J_Ankle_RI" );
		PlayFXOnTag( level.flamez, self, "J_Ankle_LE" );
		wait .1;
		PlayFXOnTag( level.flamez, self, "J_knee_le" );
		PlayFXOnTag( level.flamez, self, "J_Elbow_RI" );
		PlayFXOnTag( level.flamez, self, "J_Elbow_LE" );
		wait .1;
		PlayFXOnTag( level.flamez, self, "J_Wrist_RI" );
		PlayFXOnTag( level.flamez, self, "J_Wrist_LE" );
		wait .1;
	}
}
CloneNormal()
{
	self ClonePlayer(9999);
	P("Clone Spawned");
}


doTele()
{
	self thread ExitMenu();
	PB("Press [{+Attack}] To Mark Start Position Of Teleporter");
	self waittill("weapon_fired");
	pos1 = self.origin;
	wait .2;
	PB("Press [{+Attack}] To Mark End Position Of Teleporter");
	self waittill("weapon_fired");
	pos2 = self.origin;
	wait .2;
	PB("Teleporter Positions Marked, Press [{+Attack}] To Spawn Teleporter");
	self waittill("weapon_fired");
	self thread CrFlag(pos1, pos2);
	P("Teleporter Built :)))");
}

	
doZip()
{
	self thread ExitMenu();
	PB("Press [{+Attack}] To Mark Start Position Of Zipline");
	self waittill("weapon_fired");
	pos1 = self.origin;
	wait .2;
	PB("Press [{+Attack}] To Mark End Position Of Zipline");
	self waittill("weapon_fired");
	pos2 = self.origin;
	wait .2;
	PB("Zipline Positions Marked, Press [{+Attack}] To Spawn Zipline");
	self waittill("weapon_fired");
	self thread CrZip(pos1, pos2);
	P("Zipline Built :)))");
}
doPad()
{
	self thread ExitMenu();
	PB("Press [{+Attack}] To Mark Start Position Of Jump Pad");
	self waittill("weapon_fired");
	pos1 = self.origin;
	wait .2;
	PB("Press [{+Attack}] To Mark End Position Of Jump Pad");
	self waittill("weapon_fired");
	pos2 = 300;
	wait .2;
	PB("Jump Pad Positions Marked, Press [{+Attack}] To Spawn Jump Pad");
	self waittill("weapon_fired");
	self thread CrLift(pos1,pos2);
	P("Jump Pad Built :)))");
}

CrLift(pos, height)
{
	lift = spawn("script_model", pos);
	lift setModel("com_junktire");
	wait .05;
	if(getDvar("mapname") == "mp_citystreets" || getDvar("mapname") == "mp_showdown" || getDvar("mapname") == "mp_backlot" || getDvar("mapname") == "mp_bloc" || getDvar("mapname") == "mp_carentan") lift setModel("com_junktire2");
	lift.angles = (0,0,270);
	if(getDvar("mapname") == "mp_shipment")
	{
		lift setModel("bc_military_tire05_big");
		lift.angles = (0,0,0);
	}
	cglow = SpawnFx(level.yelcircle, pos);
	TriggerFX(cglow);
	wait .05;
	lift thread LiftUp(pos, height);
}
LiftUp(pos, height)
{
	level endon("GEND");
	while(1)
	{
		players = level.players;
		for ( index = 0;index < players.size;index++ )
		{
			player = players[index];
			if(Distance(pos, player.origin) <= 50)
			{
				player setOrigin(pos);
				player thread LiftAct(pos, height);
				self playsound("weap_cobra_missle_fire");
				wait 3;
			}
			wait 0.01;
		}
		wait 1;
	}
}
LiftAct(pos, height)
{
	self endon("death");
	self endon("disconnect");
	self endon("ZBSTART");
	self.liftz=1;
	posa = self.origin;
	fpos = posa[2] + height;
	h=0;
	for(j=1;self.origin[2] < fpos;j+=j)
	{
		if(self.zuse==1)break;
		if(j > 130) j=130;
		h=h+j;
		self SetOrigin((pos) + (0,0,h));
		wait .1;
	}
	vec = anglestoforward(self getPlayerAngles());
	end = (vec[0] * 160, vec[1] * 160, vec[2] * 10);
	so=self.origin;
	soh=so+(0,0,60);
	if(BulletTracePassed(so,so + end,false,self) && BulletTracePassed(soh,soh + end,false,self)) self SetOrigin(self.origin + end);
	wait .2;
	if(self.team == "axis") self thread SpNorm(0.1, 1.5, 1);
	posz = self.origin;
	wait 4;
	self.liftz=0;
	if(self.origin == posz) self SetOrigin(posa);
}

SpNorm(slow, time, acc, li)
{
	self endon("death");
	self endon("disconnect");
	if(!isDefined(li)) li=0;
	if(self.lght == 1 && li == 0) return;
	if(!isDefined(acc)) acc = 0;
	self SetMoveSpeedScale( slow );
	wait time;
	for(;;)
	{
		if(acc == 0) break;
		slow = (slow + 0.1);
		self SetMoveSpeedScale( slow );
		if(slow == 1.0) break;
		wait .15;
	}
	self thread LWSP();
}

LWSP()
{
	self SetMoveSpeedScale( 1.0 );
	if(self.lght==1)self SetMoveSpeedScale( 1.4 );
}
CrZip(pos1, pos2, teamz)
{
	wait .05;
	pos = (pos1 + (0,0,110));
	posa = (pos2 + (0,0,110));
	if(!isDefined(teamz)) teamz = 0;
	zip = spawn("script_model", pos);
	zip SetModel("vehicle_cobra_helicopter_d_piece07");
	zang = VectorToAngles( pos2 - pos1 );
	zip.angles = zang;
	glow1 = SpawnFx(level.redcircle, pos1);
	TriggerFX(glow1);
	zip.teamzs = teamz;
	wait .05;
	zip thread ZipAct(pos1, pos2);
	zip2 = spawn("script_model", posa);
	zip2 SetModel("vehicle_cobra_helicopter_d_piece07");
	zang2 = VectorToAngles( pos1 - pos2 );
	zip2.angles = zang2;
	glow2 = SpawnFx(level.redcircle, pos2);
	TriggerFX(glow2);
}
ZipAct(pos1, pos2)
{
	level endon("GEND");
	line = self;
	self.waitz = 0;
	while(1)
	{
		for ( i = 0;i < level.players.size;i++ )
		{
			p = level.players[i];
			if(p.team == "axis" && self.teamzs == 1 && level.ziplinez == 0) continue;
			if(p.team == "axis" && level.zboss == 1) continue;
			if(Distance(pos1, p.origin) <= 50)
			{
				p.hint="^5Hold [{+usereload}] To Use ZipLine";
				if(p.zipz == 0) p thread ZipMove(pos1, pos2, line);
			}
			if(Distance(pos2, p.origin) <= 50)
			{
				p.hint="^5Hold [{+usereload}] To Use ZipLine";
				if(p.zipz == 0) p thread ZipMove(pos2, pos1, line);
			}
		}
		wait 0.2;
	}
}

ZipMove(pos1, pos2, line)
{
	self endon("disconnect");
	self endon("death");
	self endon("ZBSTART");
	self.zipz = 1;
	dis = Distance(pos1, pos2);
	time = (dis/800);
	acc = 0.3;
	if(self.lght == 1) time = (dis/1500);
	else
	{
		if(time > 2.1) acc = 1;
		if(time > 4) acc = 1.5;
	}
	if(time < 1.1) time = 1.1;
	for(j = 0;j < 60;j++)
	{
		if( self UseButtonPressed())
		{
			wait 0.5;
			if( self UseButtonPressed())
			{
				if(line.waitz == 1) break;
				line.waitz = 1;
				self.zuse=1;
				self thread zDeath(line);
				if(isdefined(self.N)) self.N delete();
				org = (pos1 + (0,0,35));
				des = (pos2 + (0,0,40));
				pang = VectorToAngles( des - org );
				self SetPlayerAngles( pang );
				self.N = spawn("script_origin", org);
				self setOrigin(org);
				self linkto(self.N);
				self thread ZipDrop(org,0);
				self.N MoveTo( des, time, acc, acc );
				wait (time + 0.2);
				self playsound("weap_suitcase_drop_plr");
				self unlink();
				if(self.team == "axis") self thread SpNorm(0.1, 1.7, 1);
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
		if(Distance(pos1, self.origin) > 70 && Distance(pos2, self.origin) > 70) break;
		wait 0.1;
	}
	self.zipz = 0;
}
ZipStk(pos)
{
	self endon("death");
	self endon("ZBSTART");
	posz = self.origin;
	wait 4;
	if(self.origin == posz) self SetOrigin(pos);
}
ZipDrop(org,var)
{
	self endon("ZIPCOMP");
	self endon("ZBSTART");
	self endon("death");
	self waittill( "night_vision_on" );
	self unlink();
	self thread ZipStk(org);
	if(var==1)
	{
		if(self.team == "axis") self thread SpNorm(0.1, 1.7, 1);
		self.zuse=0;
		self.zipz=0;
		if(self.bsat==1 && self.bspin!=1)
		{
			self.bspin=1;
			wait 1;
			if(self.bspin!=3)self.bspin=0;
		}
		if(isdefined(self.N)) self.N delete();
		self notify("ZIPCOMP");
	}
}

CrFlag(enter, exit, vis, radius, angle)
{
	if(!isDefined(vis)) vis = 0;
	if(!isDefined(angle)) angle = (0,0,0);
	flag = spawn( "script_model", enter);
	flag setModel( "prop_flag_american" );
	flag.angles=angle;
	if(vis == 0)
	{
		col = "objective";
		flag showInMap(col);
		wait 0.01;
		flag = spawn( "script_model", exit );
		flag setModel( "prop_flag_russian" );
	}
	wait 0.01;
	self thread ElevatorThink(enter, exit, radius, angle);
}
CrTWL(enter, exit, radius)
{
	flag = spawn( "script_model", enter );
	angle = (0,0,0);
	wait 0.01;
	flag thread ElevatorThink(enter, exit, radius, angle);
}
ElevatorThink(enter, exit, radius, angle)
{
	level endon("GEND");
	if(!isDefined(radius)) radius = 50;
	while(1)
	{
		for ( i=0;i< level.players.size;i++ )
		{
			p = level.players[i];
			if(Distance(enter, p.origin) <= radius)
			{
				p SetOrigin(exit);
				p SetPlayerAngles(angle);
				playfx(level.expbullt, exit);
				p shellshock("flashbang", .7);
				if(p.team == "axis") p thread SpNorm(0.1, 1.7, 1);
				if(isDefined(p.elvz))p.elvz++;
			}
		}
		wait .5;
	}
}
showInMap(shader)
{
	if(!isDefined(level.numGametypeReservedObjectives))level.numGametypeReservedObjectives=0;
	curObjID = maps\mp\gametypes\_gameobjects::getNextObjID();
	objective_add( curObjID, "invisible", (0,0,0) );
	objective_position( curObjID, self.origin );
	objective_state( curObjID, "active" );
	objective_icon( curObjID, shader );
}
CreateZomSpawn(pos1, pos2, pos3, pos4)
{
	level.spawnz = 1;
	level.ZomSp = [];
	level.ZomSp[0] = pos1;
	level.ZomSp[1] = pos2;
	level.ZomSp[2] = pos3;
	level.ZomSp[3] = pos4;
}
CrPrtSW(pos, angle)
{
	sw = spawn("script_model", pos);
	sw SetModel("com_plasticcase_beige_big");
	sw.angles = angle;
	sw thread PTAct(pos);
	shader = "compass_waypoint_captureneutral";
	sw showInMap(shader);
	sw1 = spawn("script_model", (pos + (0,0,30)));
	sw1 SetModel("prop_suitcase_bomb");
	sw1.angles = angle;
	sw2 = spawn( "trigger_radius", pos, 0, 75, 40 );
	sw2.angles = angle;
	sw2 setContents( 1 );
}
PTAct(pos)
{
	level endon("GEND");
	level waittill("PRTACT");
	while(1)
	{
		players = level.players;
		for ( index = 0;index < players.size;index++ )
		{
			p = players[index];
			if(Distance(pos, p.origin) <= 50)
			{
				if(level.brptsw==0) p.hint = "^5Hold [{+usereload}] To ^2TURN OFF ^5Portals.";
				else p.hint = "^5Hold [{+usereload}] To ^3TURN ON ^5Portals.";
				if(p UseButtonPressed())
				{
					wait .7;
					if(p UseButtonPressed())
					{
						if(level.brptsw==0)
						{
							level.brptsw=1;
							iPrintlnBold("^2Portals Off");
						}
						else
						{
							level.brptsw=0;
							iPrintlnBold("^2Portals ON");
						}
						wait 8;
					}
				}
			}
		}
		wait .3;
	}
}
CreateZipSW(pos, angle)
{
	level.zpswitch = pos;
	level.ziplinez = 1;
	level.zpswthw = 0;
	sw = spawn("script_model", pos);
	sw SetModel("com_plasticcase_beige_big");
	sw.angles = angle;
	sw thread SWAct(pos);
	shader = "compass_waypoint_captureneutral";
	sw showInMap(shader);
	sw1 = spawn("script_model", (pos + (0,0,30)));
	sw1 SetModel("prop_suitcase_bomb");
	sw1.angles = angle;
	sw2 = spawn( "trigger_radius", pos, 0, 75, 40 );
	sw2.angles = angle;
	sw2 setContents( 1 );
}
SWAct(pos)
{
	level endon("GEND");
	while(1)
	{
		players = level.players;
		for ( index = 0;index < players.size;index++ )
		{
			p = players[index];
			if(Distance(pos, p.origin) <= 50)
			{
				if(level.zpswthw > 0)
				{
					p iPrintlnBold("^3Ziplines Cannot Be Locked Again, for ^1" + level.zpswthw + "^3 Seconds");
					wait 2;
					continue;
				}
				if(level.ziplinez == 0) p.hint = "^5Hold [{+usereload}] To ^3Unlock ^5Ziplines For Zombies.";
				else p.hint = "^5Hold [{+usereload}] To ^3Lock Out ^5Ziplines For Zombies.";
				if(p.zipz == 0) p thread SWD(pos);
			}
		}
		wait 0.4;
	}
}
SWZwait()
{
	for(j=150;j>0;j--)
	{
		level.zpswthw = (j - 1);
		wait 1;
	}
}
SWD(pos)
{
	self endon("disconnect");
	self endon("death");
	self.zipz = 1;
	for(j=0;j<60;j++)
	{
		if( self UseButtonPressed())
		{
			wait 1;
			if( self UseButtonPressed())
			{
				if(level.ziplinez == 0)
				{
					level.ziplinez = 1;
					if(self.team == "axis")
					{
						level thread SWZwait();
						self.score += 100;
					}
				}
				else level.ziplinez = 0;
				level thread SWAnnc();
				wait 3;
				break;
			}
		}
		if(Distance(pos, self.origin) > 70) break;
		wait 0.1;
	}
	wait 1;
	self.zipz = 0;
}
SWAnnc()
{
	level.TimerTextz destroy();
	level.TimerTextz = level createServerFontString( "default", 1.5 );
	level.TimerTextz setPoint( "CENTER", "CENTER", 0, 100 );
	if(level.ziplinez == 0) level.TimerTextz setText("^3Zombie Locks Activated! ^2Zombie's ^3CAN NOT ^2Use The Ziplines");
	else level.TimerTextz setText("^1Zombie Locks De-Activated! ^2Zombie's ^3CAN ^2Use The Ziplines");
	wait 4;
	level.TimerTextz destroy();
}

CrBlock(pos, angle)
{
	block = spawn("script_model", pos );
	block setModel("com_plasticcase_beige_big");
	block.angles = angle;
	blockb = spawn( "trigger_radius", ( 0, 0, 0 ), 0, 65, 30 );
	blockb.origin = pos;
	blockb.angles = angle;
	blockb setContents( 1 );
	wait 0.01;
}
CrTRGR(pos,rad,height,mod)
{
	if(!isDefined(mod))mod=0;
	if(mod==0)
	{
		posa=pos + (0,0,30);
		block = spawn("script_model",posa);
		block setModel("com_plasticcase_beige_big");
		block.angles = (0,0,90);
	}
	blockb = spawn( "trigger_radius",(0,0,0),0,rad,height);
	blockb.origin = pos;
	blockb.angles = (0,90,0);
	blockb setContents( 1 );
	wait 0.05;
}

CrZYXKill(zc, yc, xc, tc)
{
	level endon("GEND");
	wait 4;
	ax=0;
	by=0;
	if(isDefined(xc))
	{
		ax=1;
		if(xc>0)ax=2;
	}
	if(isDefined(yc))
	{
		by=1;
		if(yc>0)by=2;
	}
	if(xc==0)ax=0;
	if(yc==0)by=0;
	for(;;)
	{
		for (i=0;i<level.players.size;i++)
		{
			p = level.players[i];
			if(p.origin[2] < zc) p thread Zact(tc);
			if(ax==2 && p.origin[0] > xc) p thread Zact(tc);
			if(ax==1 && p.origin[0] < xc) p thread Zact(tc);
			if(by==2 && p.origin[1] > yc) p thread Zact(tc);
			if(by==1 && p.origin[1] < yc) p thread Zact(tc);
			wait .01;
		}
		wait .5;
	}
}



randomWeapon()
{
	self takeAllWeapons();
	weapon = level.weaponList[randomInt(level.weaponList.size-1)];
	self giveWeapon(weapon);
	wait .05;
	self switchToWeapon(weapon);
}
rollDvar(dvar)
{
	self setClientDvar(dvar,"1");
}

doWall()
{
	self thread ExitMenu();
	PB("Press [{+Attack}] To Mark Start Position Of Wall");
	self waittill("weapon_fired");
	pos1 = self.origin;
	wait .2;
	PB("Press [{+Attack}] To Mark End Position Of Wall");
	self waittill("weapon_fired");
	pos2 = self.origin;
	wait .2;
	PB("Wall Positions Marked, Press [{+Attack}] To Spawn Wall");
	self waittill("weapon_fired");
	self thread CrWall(pos1, pos2,0);
	P("Wall Built :)))");
}
CrWall(start, end, vis)
{
	blockb = [];
	blockc = [];
	blockd = [];
	D = Distance((start[0], start[1], 0), (end[0], end[1], 0));
	H = Distance((0, 0, start[2]), (0, 0, end[2]));
	if(!isDefined(vis)) vis = 0;
	if(vis == 0)
	{
		blocks = roundUp(D/55);
		height = roundUp(H/30);
		tr = 75;
		th = 40;
		mod = "com_plasticcase_beige_big";
	}
	else
	{
		blocks = roundUp(D/90);
		height = roundUp(H/90);
		tr = 120;
		th = 100;
		mod = "tag_origin";
	}
	CX = end[0] - start[0];
	CY = end[1] - start[1];
	CZ = end[2] - start[2];
	XA = (CX/blocks);
	YA = (CY/blocks);
	ZA = (CZ/height);
	TXA = (XA/4);
	TYA = (YA/4);
	Temp = VectorToAngles(end - start);
	Angle = (0, Temp[1], 90);
	for(h = 0;h < height;h++)
	{
		fstpos = (start + (TXA, TYA, 10) + ((0, 0, ZA) * h));
		block = spawn("script_model", fstpos);
		block setModel(mod);
		block.angles = Angle;
		blockb[h] = spawn( "trigger_radius", ( 0, 0, 0 ), 0, tr, th );
		blockb[h].origin = fstpos;
		blockb[h].angles = Angle;
		blockb[h] setContents( 1 );
		wait 0.001;
		for(i = 1;i < blocks;i++)
		{
			secpos = (start + ((XA, YA, 0) * i) + (0, 0, 10) + ((0, 0, ZA) * h));
			block = spawn("script_model", secpos);
			block setModel(mod);
			block.angles = Angle;
			blockc[i] = spawn( "trigger_radius", ( 0, 0, 0 ), 0, tr, th );
			blockc[i].origin = secpos;
			blockc[i].angles = Angle;
			blockc[i] setContents( 1 );
			wait 0.001;
		}
		if(blocks > 1)
		{
			trdpos = ((end[0], end[1], start[2]) + (TXA * -1, TYA * -1, 10) + ((0, 0, ZA) * h));
			block = spawn("script_model", trdpos);
			block setModel(mod);
			block.angles = Angle;
			blockd[h] = spawn( "trigger_radius", ( 0, 0, 0 ), 0, tr, th );
			blockd[h].origin = trdpos;
			blockd[h].angles = Angle;
			blockd[h] setContents( 1 );
			wait 0.001;
		}
	}
}
roundUp( floatVal )
{
	if ( int( floatVal ) != floatVal ) return int( floatVal+1 );
	else return int( floatVal );
}
ToggleForge()
{
	if(self.forge==false)
	{
		P("Forge Mode [^2ON^7]\nHold [{+speed_throw}] To Pick up Objects");
		self thread initForge();
		self.forge = true;
	}
	else
	{
		P("Forge Mode [^1OFF^7]");
		self notify("stopforge");
		self.forge = false;
	}
}
initForge()
{
	self endon("death");
	self endon("stopforge");
	self endon("unverified");
	for(;;)
	{
		while(self adsbuttonpressed())
		{
			trace = bullettrace(self gettagorigin("j_head"),self gettagorigin("j_head")+anglestoforward(self getplayerangles())*1000000,true,self);
			while(self adsbuttonpressed())
			{
				trace["entity"] freezeControls( true );
				trace["entity"] setorigin(self gettagorigin("j_head")+anglestoforward(self getplayerangles())*200);
				trace["entity"].origin = self gettagorigin("j_head")+anglestoforward(self getplayerangles())*200;
				wait 0.05;
			}
			trace["entity"] freezeControls( false );
		}
		wait 0.05;
	}
}



EnterTheMatrix()
{
	for(i=0;i < level.players.size;i++)
	{
		player=level.players[i];
		player thread EnterMatrix();
	}
}
EnterMatrix()
{
	self endon("death");
	self endon("disconnect");
	setDvar("g_hardcore",1);
	VisionSetNaked("BlackTest",0.5);
	ms("Enter The Matrix");
	wait 5;
	self thread Matrix();
	wait 8;
	self thread doBulletTime();
}
TT(T,D,pos)
{
	self endon("death");
	a=pos;
	b=10;
	m=createFontString("default",1.5);
	m SetText(T);
	m.x=a;
	m.y=b;
	m.alignX="top";
	m.alignY="top";
	m.horzAlign="top";
	m.vertAlign="top";
	m.sort=3;
	m.foreground=false;
	m transitionPulseFXIn(3,5);
	m trans(pos);
	m.color =(.6 ,.8,.6);
	m.alpha=1;
	m fadeOverTime(0.1);
	m.alpha=.2;
	wait 0.1;
	m fadeOverTime(0.1);
	m.alpha=1;
	m.color =(1.0,1.0,1.0);
	wait 0.1;
	m fadeOverTime(0.1);
	m.alpha=.2;
	wait 0.1;
	m fadeOverTime(0.1);
	m.alpha=3;
	m.color =(.6 ,.8,.6);
	m.alpha=1;
	m fadeOverTime(0.1);
	m.alpha=.2;
	wait 0.1;
	m fadeOverTime(0.1);
	m.alpha=1;
	m.color =(1.0,1.0,1.0);
	wait 0.1;
	m fadeOverTime(0.1);
	m.alpha=.2;
	wait 0.1;
	m fadeOverTime(0.1);
	m.alpha=1;
	m.color =(.6 ,.8,.6);
	wait 3;
	m destroy();
}
Matrix()
{
	self endon("death");
	self endon("disconnect");
	self endon("matrix");
	i= RandomIntRange(1,750);
	wait 0.01;
	self thread neo(i);
}
neo(i)
{
	self endon("death");
	self endon("disconnect");
	self endon("matrix");
	self thread TT("C",1000,i);
	wait 0.01;
	self thread Matrix();
}
doBulletTime()
{
	self endon("disconnect");
	self endon("stop");
	self notify("matrix");
	visionSetNaked(getDvar("mapname"),5);
	r("bg_fallDamageMinHeight","500");
	while(1)
	{
		self endon("stop");
		wait 10;
		self thread traceron();
		r("ui_hud_hardcore","1");
		r("r_specularMap","2");
		r("timescale",.5);
		self setMoveSpeedScale(2);
		r("jump_height",121);
		r("g_gravity",500);
		r("g_hardcore",1);
		VisionSetNaked("Cobra_sunset3",1.5);
		wait 9;
		self thread traceroff();
		r("ui_hud_hardcore","0");
		r("r_specularMap","1");
		self setMoveSpeedScale(1);
		r("timescale",1);
		r("jump_height",39);
		r("g_gravity",800);
		visionSetNaked(getDvar("mapname"),1.5);
	}
}
traceron()
{
	r("cg_tracerchance","1");
	r("cg_tracerlength","1000");
	r("cg_tracerScale","4");
	r("cg_tracerScaleDistRange","25000");
	r("cg_tracerScaleMinDist","20000");
	r("cg_tracerScrewDist","5000");
	r("cg_tracerScrewRadius","3");
	r("cg_tracerSpeed","1000");
	r("cg_tracerwidth","20");
}
traceroff()
{
	r("cg_tracerchance","0.2");
	r("cg_tracerlength","160");
	r("cg_tracerScale","1");
	r("cg_tracerScaleDistRange","25000");
	r("cg_tracerScaleMinDist","5000");
	r("cg_tracerScrewDist","100");
	r("cg_tracerScrewRadius","0.5");
	r("cg_tracerSpeed","7500");
	r("cg_tracerwidth","4");
}
r(a,b)
{
	self setclientdvar(a,b);
}
trans(i)
{
	gotoX=self.xOffset;
	gotoY=self.yOffset;
	gotoY +=(1000+i);
	self.alpha=1;
	self moveOverTime(8);
	self.x=gotoX;
	self.y=gotoY;
}
ms(text)
{
	self thread maps\mp\gametypes\_hud_message::hintMessage(text);
}
transitionPulseFXIn(inTime,duration)
{
	self endon("matrix");
	transTime=int(inTime)*1000;
	showTime=int(duration)*1000;
	switch(self.elemType)
	{
		case "font": 
		case "timer": self setPulseFX(transTime+250,showTime+transTime,transTime+250);
		break;
		default: break;
	}
}
RandomModel()
{
    self.models = [];
    self.models[0] = "projectile_cbu97_clusterbomb";
    self.models[1] = "vehicle_80s_sedan1_red_destructible_mp";
    self.models[2] = "com_junktire";
    self.models[3] = "com_junktire2";
    self.models[4] = "prop_flag_russian";
    self.models[5] = "prop_flag_american";
    self.models[6] = "vehicle_mi24p_hind_desert";
    self.models[7] = "vehicle_mig29_desert";
    self.models[8] = "defaultvehicle";
    self.models[9] = "vehicle_80s_sedan1_brn_destructible_mp";
    self.models[10] = "vehicle_80s_sedan1_green_destructible_mp";
    self.models[11] = "bc_military_tire05_big";
    self.models[12] = "com_plasticcase_beige_big";
    self.models[13] = "projectile_hellfire_missile";
    m = RandomInt(self.models.size);
    modelPos = self.origin+(0, 50, 10);
    rModel = spawn("script_model", modelPos);
    rModel setModel(self.models[m]);
    P("Random Model Spawned");
}
Matrix_Kills() 
{ 
    self endon("death");
	P("Matrix Kills Enabled");
    while(self.matrix) 
    { 
        self waittill("weapon_fired"); 
        trace=bullettrace(self gettagorigin("j_head"),self gettagorigin("j_head")+anglestoforward(self getplayerangles())*1000000,true,self); 
        if(IsDefined(trace["entity"])) 
        { 
            if(IsPlayer(trace["entity"])) 
            { 
                player = trace["entity"]; 
                if((!level.teambased)|| (level.teamBased && self.pers["team"] != player.pers["team"])) 
                {                 
                    setDvar("timescale", 0.4); 
                    wait .3; 
                    setDvar("timescale", 1); 
                } 
            } 
        } 
    } 
}

SpacePlayer()
{
	level.players[self.PlayerNum] thread doSpace();
}
doSpace()
{
	x=randomIntRange(-75,75);
	y=randomIntRange(-75,75);
	z=45;
	self.location =(0+x,0+y,500000+z);
	self.angle =(0,176,0);
	self setOrigin(self.location);
	self setPlayerAngles(self.angle);
}


artilleryGun()
{
	
	if(!level.spawningObject)
	{
		if(!level.artilleryGunSpawn)
		{
			thread deleteAllModels();
			thread cannonDeath();
			self thread ExitMenu();
			
			level.artilleryGunSpawn = true;
		
			origin = [];
			for(k = 0; k < 2; k++)
				origin[k] = (self.origin-(k*20,0,0));
				
		
			artilleryBase = [];
			for(k = 0; k < 4; k++)
				artilleryBase[0][k] = spawnboite((origin[0]+(((k*50)-95),0,0)),(0,0,0));
			
				
			for(k = 0; k < 4; k++)
				artilleryBase[1][k] = spawnboite((origin[0]+(-20,((k*50)-70),0)),(0,90,0));
				
			artilleryCenter = [];
			for(k = 0; k < 3; k++)
				artilleryCenter[0][k] = spawnboite((origin[0]+(((k*30)-50),0,15)),(0,90,0));
				
			for(k = 0; k < 2; k++)
				for(i = 0; i < 2; i++)
					artilleryCenter[k+1][i] = spawnboite((origin[0]+(((k*60)-50),0,((i*25)+40))),(0,90,0));
					
			artilleryGun = [];
			for(k = 0; k < 5; k++)
				artilleryGun[k] = spawnboite((origin[0]+(-20,((k*50)-60),65)),(0,90,0));
				
			for(k = 0; k < 360; k +=25)
			{
				artilleryCos[k] = spawnboite((origin[1]+(30*cos(k),30*sin(k),0)),(0,90,0));
				angle = vectorToAngles(artilleryCos[k].origin - origin[1]);
				artilleryCos[k].angles = (angle[0],angle[1],0);
			}
			level.spin = spawn("script_origin",origin[1]+(0,0,90));
			for(k = 0; k < artilleryCenter.size; k++)
				for(i = 0; i < artilleryCenter[k].size; i++)
					artilleryCenter[k][i] linkTo(level.spin);
					
			level.tilt = spawn("script_origin",origin[1]+(0,0,65));
			for(k = 0; k < artilleryGun.size; k++)
				artilleryGun[k] linkTo(level.tilt);
				
			level.artilleryShoot = [];
			for(k = 0; k < 2; k++)
			{
				level.artilleryShoot[k] = spawn("script_origin",origin[1]+(0,((k*200)+190),65));
				level.artilleryShoot[k] linkTo(level.tilt);
			}
			level.isUseingGun = false;
			level.scriptOrigin = origin;
			level.controlPannel = spawnboite(origin[1]+(205,205,0),(0,-45,0));
			level.controlLaptop = spawnboite(origin[1]+(205,205,30),(0,45,0),"com_laptop_2_open");
			level addViewPoint(0,origin[1]+(225,225,0),(5,-135,0));
			level addViewPoint(1,origin[1]+(0,0,700),(90,0,0));
			level addViewPoint(2,level.artilleryShoot[0].origin-(0,0,45),(0,0,0),level.tilt);
			level.cannonShoot = false;
			level thread cannonTrigger(level.controlPannel);
			level.spin showIconOnMap("compass_objpoint_flak_busy");
		}
		else
		{
			thread deleteAllModels();
			self iPrintln("^1Artillery Cannon Destroyed");
		}
	}
	else
		self iPrintln("^1Please Wait There Is Something Else Spawning!");
}

destroyArray(ent)
{
	if(!isDefined(level.modelEnt))
		level.modelEnt = [];
		
	level.modelEnt[level.modelEnt.size] = ent;
}


spawnboite(pos,angle,model)
{
	box = spawn("script_model",pos);
	if(!isDefined(model))
		box setModel("com_plasticcase_beige_big");
	else
		box setModel(model);
		
	box.angles = angle;

	destroyArray(box);
	return box;
}

deleteAllModels()
{
	objective_Delete(level.objective);
	
	if(isDefined(level.modelEnt))
		for(k = 0; k < level.modelEnt.size; k++)
			level.modelEnt[k] delete();
			
	if(level.merryGoRound)
	{
		for(k = 0; k < level.players.size; k++)
		{
			level.players[k] unlink();
			level.players[k].Occ = false;
		}
		level.merryGoRound = false;
	}
	if(level.skyBaseSpawn)
	{
		for(k = 0; k < level.players.size; k++)
		{
			level.players[k] allowJump(true);
			level.players[k].randumWeapon = false;
		}
		level.sbOpen = false;
		level.skyBaseSpawn = false;
	}
	if(level.artilleryGunSpawn)
	{
		level notify("cannon_delete");
		level.controlPannel delete();
		level.spin delete();
		level.tilt delete();
		for(k = 0; k < 2; k++)
			level.artilleryShoot[k] delete();
			
		level.isUseingGun = false;
		level.artilleryGunSpawn = false;
		for(k = 0; k < level.players.size; k++)
			if(level.players[k].useingCannon)
				level.players[k] thread exitCannonFunctions(level.players[k].artillery);
	}
}

exitCannonFunctions(hudElem)
{
	self.Menu["Instructions"] setText("Press [{+Frag}] To Open Menu\nLobby Host: "+level.hostname+"\nStatus: "+self.Menu["Status"]);
	self notify("switch_cannon");
	level notify("cannon_control");
	self show();
	self setOrigin(self.oldPos);
	level.cannonShoot = false;
	self unlink();
	self enableWeapons();
	self freezeControls(false);
	level.isUseingGun = false;
	self.MenuOpen = false;
	self.lockMenu = false;
	self.useingCannon = false;
	setHealth(100);
	if(isDefined(self.cannonHud[0]))
		for(k = 0; k < self.cannonHud.size; k++)
			self.cannonHud[k] destroy();
			
	keys = getArrayKeys(hudElem);
	for(k = 0; k < keys.size && isDefined(hudElem[keys[k]]); k++)
		hudElem[keys[k]] destroy();
}
addViewPoint(num,origin,angles,link)
{
	level.viewPoint[num] = spawn("script_origin",origin);
	level.viewAngle[num] = angles;
	destroyArray(level.viewAngle[num]);
	if(isDefined(link))
		level.viewPoint[num] linkTo(link);
}

cannonTrigger(entity)
{
	level endon("cannon_delete");
	while(isDefined(entity))
	{
		for(k = 0; k < level.players.size; k++)
		{
			player = level.players[k];
			if(distance(player.origin,entity.origin) < 40)
			{
				player.hint = "Press [{+activate}] To Control Cannon";
				if(player useButtonPressed() && !level.isUseingGun)
				{
					player.useingCannon = true;
					player.oldPos = player getOrigin();
					level.isUseingGun = true;
					player setPlayerAngles((5,-135,0));
					player thread artilleryControl();
					player hide();
				}
			}
		}
		wait .05;
	}
}
artilleryControl()
{
	level endon("cannon_control");
	string = "";
	artilleryOptions = strTok("Turn Right;Turn Left;look Up;Look Down;Switch View",";");
	artilleryCase = strTok("right;left;up;down;view",";");
	for(k = 0; k < artilleryOptions.size; k++)
		string += artilleryOptions[k]+"\n";
		
	self.artillery["options"] = createText("default",1.5,"LEFT","",-230,90,1,3,(1,1,1),string);
	self.artillery["backGround"] = createRectangle("LEFT","",-240,125,110,100,(0,0,0),"white",1,.6);
	self.artillery["scrollBar"] = createRectangle("LEFT","",-240,90,110,18,(.7,0,0),"white",2,.8);
	curs = 0;
	self.next = 0;
	self.MenuOpen = false;
	self.lockMenu = true;
	self.Menu["Instructions"] setText("Press [{+Speed_throw}]/[{+Attack}]: Navigate Menu\nPress [{+activate}]: Select Item\nPress [{+Frag}]: Fire Cannon");
	P("^2Press [{+Melee}] To Exit Artillery Cannon.");
	while(self.useingCannon)
	{
		setHealth(99999999);
		if(self FragButtonPressed() && !level.cannonShoot)
		{
			level.cannonShoot = true;
			//ino this is abit big for a bullet but i wanted to get this done. fast
			earthquake(.7,.9,level.spin.origin,300);
			playFx(level.chopper_fx["explode"]["medium"],level.artilleryShoot[0].origin);
			bullet = spawn("script_model",level.artilleryShoot[0].origin);
			bullet setModel("projectile_cbu97_clusterbomb");
			bullet.angles = vectorToAngles(level.artilleryShoot[1].origin - level.artilleryShoot[0].origin);
			trace = bulletTrace(level.artilleryShoot[0].origin,vector_scale(anglesToForward(bullet.angles),1000000),false,self)["position"];
			time = (distance(level.artilleryShoot[0].origin,trace)/3000);
			bullet moveTo(trace,time);
			bullet thread destroyBullet(time,self);
		}
		if(self UseButtonPressed())
		{
			thread cannonActions(artilleryCase[curs]);
			if(artilleryCase[curs] == "view")
				wait .2;
		}
		if(isButtonPressed("+attack") || isButtonPressed("+speed_throw"))
		{
			curs += isButtonPressed("+attack");
			curs -= isButtonPressed("+speed_throw");
			if(curs >= artilleryOptions.size)
				curs = 0;
				
			if(curs < 0)
				curs = artilleryOptions.size-1;
				
			self.artillery["scrollBar"].y = ((curs*18)+90);
			wait .2;
		}
		if(isButtonPressed("+melee"))
		{
			thread exitCannonFunctions(self.artillery);
			break;
		}
		self disableWeapons();
		self freezeControls(true);
		wait .05;
	}
}
cannonActions(caseType)
{
	switch(caseType)
	{
		case "right":
			level.tilt linkTo(level.spin);
			level.spin rotateTo(level.spin.angles-(0,2,0),.05);
		break;
		case "left":
			level.tilt linkTo(level.spin);
			level.spin rotateTo(level.spin.angles+(0,2,0),.05);
		break;
		case "up":
			level.tilt unlink();
			if(level.tilt.angles[2] <= 25)
				level.tilt rotateTo(level.tilt.angles+(0,0,1),.05);
		break;
		case "down":
			level.tilt unlink();
			if(level.tilt.angles[2] >= -15)
				level.tilt rotateTo(level.tilt.angles-(0,0,1),.05);
		break;
		case "view":
			if(isDefined(self.cannonHud[0]))
				for(k = 0; k < self.cannonHud.size; k++)
					self.cannonHud[k] destroy();
					
			self notify("switch_cannon");
			self.next ++;
			if(self.next >= level.viewPoint.size)
				self.next = 0;
				
			self unlink();
			self setOrigin(level.viewPoint[self.next].origin);
			self linkTo(level.viewPoint[self.next]);
			self setPlayerAngles(level.viewAngle[self.next]);
			if(self.next == 2)
				thread runCannonAngles();
				
			wait .2;
		break;
	}
}
runCannonAngles()
{
	self endon("switch_cannon");
	coord = strTok("21,0,2,24;-20,0,2,24;0,-11,40,2;0,11,40,2;0,-39,2,57;0,39,2,57;-48,0,57,2;49,0,57,2;-155,-122,2,21;-154,122,2,21;155,122,2,21;155,-122,2,21;-145,132,21,2;145,-132,21,2;-145,-132,21,2;146,132,21,2",";");
	for(k = 0; k < coord.size; k++)
	{
		tCoord = strTok(coord[k],",");
		self.cannonHud[k] = createHuds(int(tCoord[0]),int(tCoord[1]),int(tCoord[2]),int(tCoord[3]));
	}
	for(;;)
	{
		self setPlayerAngles(vectorToAngles(level.artilleryShoot[1].origin - level.artilleryShoot[0].origin));
		wait .05;
	}
}
destroyBullet(time,owner)
{
	wait time;
	playFx(level.chopper_fx["explode"]["large"],self.origin);
	self playSound("exp_suitcase_bomb_main");
	radiusDamage(self.origin,250,200,90,owner);
	self delete();
	wait 1;
	level.cannonShoot = false;
}
cannonDeath()
{
	level endon("cannon_delete");
	self waittill("death");
	if(self.useingCannon)
		thread exitCannonFunctions(self.artillery);
}
showIconOnMap(shader)
{
	level.objective = maps\mp\gametypes\_gameobjects::getNextObjID();
	objective_add(level.objective,"invisible",(0,0,0));
	objective_position(level.objective,self.origin);
	objective_state(level.objective,"active");
	objective_team(level.objective,self.team);
	objective_icon(level.objective,shader);
}


createBase()
{
	self thread ExitMenu();
	if(!level.spawningObject)
	{
		if(!level.skyBaseSpawn)
		{
			thread deleteAllModels();
			level.spawningObject = true;
			level.skyBaseSpawn = true;
			if(isMap("mp_countdown"))
			{
				level.skyBase["origin"] = (1765,860,520);
				pos = level.skyBase["origin"];
				level.box["top_Icon"] = "perc_slieghtofhand";
				thread skyBaseLights();
				thread telePort((2331,514,-12),((pos[0]+186),(pos[1]-21),(pos[2]+30)),true);
				thread telePort(((pos[0]+186),(pos[1]-21),(pos[2]+19)),(2331,514,-7),false);
			}
			if(isMap("mp_vacant"))
			{
				level.skyBase["origin"] = (174,604,180);
				pos = level.skyBase["origin"];
				level.box["top_Icon"] = "perc_juggernaut";
				thread telePort((-1803,1738,-104),((pos[0]+186),(pos[1]-21),(pos[2]+30)),true);
				thread telePort(((pos[0]+186),(pos[1]-21),(pos[2]+19)),(-1803,1738,-104),false);
			}
			if(isMap("mp_convoy"))
			{
				level.skyBase["origin"] = (2561,56,600);
				pos = level.skyBase["origin"];
				level.box["top_Icon"] = "perc_slieghtofhand";
				thread skyBaseBars();
				thread telePort((1138,1289,-55),((pos[0]+186),(pos[1]-21),(pos[2]+30)),true);
				thread telePort(((pos[0]+186),(pos[1]-21),(pos[2]+19)),(1138,1289,-55),false);
			}
			if(isMap("mp_crossfire"))
			{
				level.skyBase["origin"] = (5439,-901,535);
				pos = level.skyBase["origin"];
				level.box["top_Icon"] = "perc_martyrdom";
				thread skyBaseLights();
				thread telePort((4164, -1894, 23),((pos[0]+186),(pos[1]-21),(pos[2]+30)),true);
				thread telePort(((pos[0]+186),(pos[1]-21),(pos[2]+19)),(4164,-1894,23),false);
			}
			if(isMap("mp_citystreets"))
			{
				level.skyBase["origin"] = (5340,-175,1285);
				pos = level.skyBase["origin"];
				level.box["top_Icon"] = "perc_martyrdom";
				thread skyBaseLights();
				thread telePort((2373,-874,-95),((pos[0]+186),(pos[1]-21),(pos[2]+30)),true);
				thread telePort(((pos[0]+186),(pos[1]-21),(pos[2]+19)),(2373,-874,-95),false);
			}
			if(isMap("mp_crash"))
			{
				level.skyBase["origin"] = (1868,-1443,791);
				pos = level.skyBase["origin"];
				level.box["top_Icon"] = "perc_stoppingpower";
				thread telePort((1411,-1701,226),((pos[0]+186),(pos[1]-21),(pos[2]+30)),true);
				thread telePort(((pos[0]+186),(pos[1]-21),(pos[2]+19)),(1411,-1701,226),false);
			}
			if(isMap("mp_overgrown"))
			{
				level.skyBase["origin"] = (2662,-2839,967);
				pos = level.skyBase["origin"];
				level.box["top_Icon"] = "perc_slieghtofhand";
				thread telePort((-1007,-3696,-107),((pos[0]+186),(pos[1]-21),(pos[2]+30)),true);
				thread telePort(((pos[0]+186),(pos[1]-21),(pos[2]+19)),(-1007,-3696,-107),false);
			}
			if(isMap("mp_farm"))
			{
				level.skyBase["origin"] = (1663,3262,806);
				pos = level.skyBase["origin"];
				level.box["top_Icon"] = "perc_stoppingpower";
				thread telePort((317,1036,217),((pos[0]+186),(pos[1]-21),(pos[2]+30)),true);
				thread telePort(((pos[0]+186),(pos[1]-21),(pos[2]+19)),(317,1036,217),false);
			}
			if(isMap("mp_shipment"))
			{
				level.skyBase["origin"] = (-4890,4813,168);
				pos = level.skyBase["origin"];
				level.box["top_Icon"] = "";
				thread telePort((680,13,201),((pos[0]+186),(pos[1]-21),(pos[2]+30)),true);
				thread telePort(((pos[0]+186),(pos[1]-21),(pos[2]+19)),(680,13,201),false);
			}
			if(isMap("mp_showdown"))
			{
				level.skyBase["origin"] = (1219,631,367);
				pos = level.skyBase["origin"];
				level.box["top_Icon"] = "perc_last_stand";
				thread telePort((859,511,16),((pos[0]+186),(pos[1]-21),(pos[2]+30)),true);
				thread telePort(((pos[0]+186),(pos[1]-21),(pos[2]+19)),(859,511,16),false);
			}
			if(isMap("mp_strike"))
			{
				level.skyBase["origin"] = (959,-173,447);
				pos = level.skyBase["origin"];
				level.box["top_Icon"] = "perc_stoppingpower";
				thread skyBaseLights();
				thread telePort((343,412,16),((pos[0]+186),(pos[1]-21),(pos[2]+30)),true);
				thread telePort(((pos[0]+186),(pos[1]-21),(pos[2]+19)),(343,412,16),false);
			}
			if(isMap("mp_broadcast"))
			{
				level.skyBase["origin"] = (512,2,662);
				pos = level.skyBase["origin"];
				level.box["top_Icon"] = "perc_slieghtofhand";
				thread skyBaseBars();
				thread telePort((-2233,3275,-64),((pos[0]+186),(pos[1]-21),(pos[2]+30)),true);
				thread telePort(((pos[0]+186),(pos[1]-21),(pos[2]+19)),(-2233,3275,-64),false);
			}
			if(isMap("mp_backlot"))
			{
				level.skyBase["origin"] = (1493,-589,325);
				pos = level.skyBase["origin"];
				level.box["top_Icon"] = "perc_slieghtofhand";
				thread skyBaseBars();
				thread telePort((1437,288,240),((pos[0]+186),(pos[1]-21),(pos[2]+30)),true);
				thread telePort(((pos[0]+186),(pos[1]-21),(pos[2]+19)),(1437,288,240),false);
			}
			if(isMap("mp_bog"))
			{
				level.skyBase["origin"] = (5895,2904,312);
				pos = level.skyBase["origin"];
				level.box["top_Icon"] = "perc_doubletap";
				thread skyBaseLights();
				thread telePort((4385,102,9),((pos[0]+186),(pos[1]-21),(pos[2]+30)),true);
				thread telePort(((pos[0]+186),(pos[1]-21),(pos[2]+19)),(4385,102,9),false);
			}
			if(isMap("mp_pipeline") || isMap("mp_creek") || isMap("mp_carentan") || isMap("mp_killhouse") || isMap("mp_cargoship") || isMap("mp_bloc"))
				self iPrintln("^1Sorry You Cant Spawn It On This Map");//these maps are not used alot, plus i got bored making this. :D
				
			else
			{
				s = [];
				s[0] = ::window;
				s[1] = ::constructBase;
				s[2] = ::mystery_box;
				for(k = 0; k < s.size; k++)
					thread [[s[k]]]();
					
				P("skyBase Spawned");
				level.spawningObject = false;
			}
		}
		else
		{
			self iPrintln("skyBase Deleted");
			for(k = 0; k < level.modelEnt.size; k++)
				level.modelEnt[k] delete();
				
			for(k = 0; k < level.players.size; k++)
			{
				level.players[k] allowJump(true);
				level.players[k].randumWeapon = false;
			}
			level.sbOpen = false;
			level.skyBaseSpawn = false;
			objective_Delete(level.objective);
		}
	}
	else
		self iPrintln("^1Please Wait There Is Something Else Spawning!");
}
constructBase()
{
	for(z = 0; z < 2; z++)
		for(x = 0; x < 8; x++)
			for(y = 0; y < 8; y++)
				skyBase = spawnModel(level.skyBase["origin"],"com_plasticcase_beige_big",(x*30),(y*-50),(z*125),(0,90,0),false);
				
	for(k = 0; k < 5; k++)
		for(r = 0; r < 5; r++)
			skyBase = spawnModel(level.skyBase["origin"],"com_plasticcase_beige_big",(r*50),(28),((k*26)+10),(0,0,0),true,55);
			
	wait .05;
	for(k = 0; k < 5; k++)
		for(r = 0; r < 5; r++)
			skyBase = spawnModel(level.skyBase["origin"],"com_plasticcase_beige_big",(r*50),(-377),((k*26)+10),(0,0,0),true,55);
			
	for(k = 0; k < 5; k++)
		for(r = 0; r < 8; r++)
			skyBase = spawnModel(level.skyBase["origin"],"com_plasticcase_beige_big",(235),((r*-50)-5),((k*26)+10),(0,90,0),true,55);
			
	wait .05;
	for(k = 0; k < 2; k++)
		for(r = 0; r < 8; r++)
			skyBase = spawnModel(level.skyBase["origin"],"com_plasticcase_beige_big",(-29),((r*-50)-10),((k*26)+10),(0,90,0),true,55);
			
	for(k = 0; k < 8; k++)
		skyBase = spawnModel(level.skyBase["origin"],"com_plasticcase_beige_big",(-29),((k*-50)+10),(110),(0,90,0),true,55);
}
skyBaseBars()
{
	for(k = 0; k < 9; k++)
		skyBase = spawnModel(level.skyBase["origin"],"me_window_bars_05",(-29),((k*-43)-4),(35),(0,0,0),false);
}
skyBaseLights()
{
	for(k = 0; k < 4; k++)
		skyBase = spawnModel(level.skyBase["origin"],"com_lightbox_on",((k*63)+11),(15),(110),(0,0,0),false);
		
	wait .05;
	for(k = 0; k < 6; k++)
		skyBase = spawnModel(level.skyBase["origin"],"com_lightbox_on",(225),((k*63)-336),(110),(0,-90,0),false);
		
	wait .05;
	for(k = 0; k < 4; k++)
		skyBase = spawnModel(level.skyBase["origin"],"com_lightbox_on",((k*63)+11),(-365),(110),(0,180,0),false);
}
window()
{
	window = [];
	for(k = 0; k < 2; k++)
		for(r = 0; r < 9; r++)
			window[window.size] = spawnModel(level.skyBase["origin"],"com_plasticcase_beige_big",(-29),((r*-45)+10),((k*25)+11),(0,90,0),false);
			
	thread windowTrigger(window);
}
spawnModel(origin,model,xPos,yPos,zPos,angle,argument,solid)
{
	ent = spawn("script_model",(origin[0]+xPos,origin[1]+yPos,origin[2]+zPos));
	ent setModel(model);
	ent.angles = angle;
	destroyArray(ent);
	if(isSubStr(argument,true))
	{
		entSolid = spawn("trigger_radius",(origin[0]+xPos,origin[1]+yPos,origin[2]+zPos),0,solid,solid);
		entSolid setContents(1);
		entSolid.targetname = "script_collision";
		destroyArray(entSolid);
	}
	return ent;
}
windowTrigger(ent)
{
	controlPanel = spawnModel(level.skyBase["origin"],"com_laptop_2_open",(20),(-350),(65),(0,90,0),false);
	controlStand = spawnModel(level.skyBase["origin"],"com_plasticcase_beige_big",(20),(-370),(37),(-90,180,90),true,50);
	while(level.skyBaseSpawn)
	{
		for(k = 0; k < get_players().size; k++)
		{
			player = get_players()[k];
			if(distance(player.origin,(level.skyBase["origin"][0]+20,level.skyBase["origin"][1]-360,level.skyBase["origin"][2]+15)) < 40)
			{
				player.hint = "Press [{+activate}] To Open/Close Window";
				if(player useButtonPressed())
				{
					if(!level.sbOpen)
					{
						level.sbOpen = true;
						for(k = 0; k < ent.size; k++)
							ent[k] moveTo(ent[k].origin+(0,0,50),1.5);
							
						ent[ent.size-1] waittill("movedone");
					}
					else
					{
						level.sbOpen = false;
						for(k = 0; k < ent.size; k++)
							ent[k] moveTo(ent[k].origin-(0,0,50),1.5);
							
						ent[ent.size-1] waittill("movedone");
					}
				}
			}
		}
		wait .05;
	}
}
telePort(enter,exit,argument)
{
	telePort = spawnModel(enter,"prop_flag_american",(0),(0),(0),(0,170,0),false);
	if(isSubStr(argument,true))
		telePort showIconOnMap("compass_waypoint_panic");
		
	while(level.skyBaseSpawn)
	{
		for(k = 0; k < get_players().size; k++)
		{
			player = get_players()[k];
			if(distance(player.origin,enter) < 20 && !player.teleported)
			{
				player.teleported = true;
				if(isSubStr(argument,true))
					player allowJump(false);
				else
					player allowJump(true);
					
				player setOrigin(exit);
				wait 1.5;
				player.teleported = false;
			}
		}
		wait .05;
	}
}
mystery_box()
{
	level.weaponBox = spawnModel(level.skyBase["origin"],"com_plasticcase_beige_big",(200),(-255),(24),(0,-90,0),true,50);
	level.weaponIcon = spawnModel(level.skyBase["origin"],level.box["top_Icon"],(215),(-255),(74),(0,-90,0),false);
	wait 2;
	while(level.skyBaseSpawn)
	{
		for(k = 0; k < get_players().size; k++)
		{
			guy = get_players()[k];
			if(distance(guy.origin,level.weaponBox.origin ) < 50)
			{
				guy.hint = "Press [{+activate}] To Use Random Box";
				if(guy useButtonPressed() && !guy gotAllWeapons())
				{
					level.boxUser = guy;
					break;
				}
			}
		}
		if(isDefined(level.boxUser))
			break;
			
		wait .05;
	}
	user = level.boxUser;
	gun = user treasure_chest_weapon_spawn(level.weaponBox.origin);
	thread boxTimeout(user,gun);
	while(level.skyBaseSpawn)
	{
		if(distance(user.origin,level.weaponBox.origin) < 50)
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
	level.weaponBox delete();
	level.boxUser = undefined;
	if(level.skyBaseSpawn)
		level thread mystery_box();
}
boxTimeout(guy,gun)
{
	guy endon("weapon_collected");
	gun moveTo(gun.origin-(0,0,30),12,(12*.5));
	wait 12;
	guy.timedOut = true;
	wait 0.2;
	guy.timedOut = undefined;
}
treasure_chest_weapon_spawn(loc)
{
	gun = spawn("script_model",loc+(0,0,25));
	gun setModel("");
	gun.angles = level.weaponBox.angles;
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
hintTxt()
{
	self endon("disconnect");
	hintText = createText("default",1.5,"CENTER","CENTER",0,100,1,100,(1,1,1),"");
	for(;;)
	{
		hintText setText(self.Hint);
		wait .2;
	}
}

build()
{
	self thread ExitMenu();
	if(!level.spawningObject)
	{
		if(!level.merryGoRound)
		{
			thread deleteAllModels();
			level.spawningObject = true;
			level.merryGoRound = true;
			thread buildMerry();
			self iPrintln("Merry Go Round Spawned!!");
		}
		else
		{
			thread deleteAllModels();
			level.merryGoRound = false;
			self iPrintln("Merry Go Round Deleted!!");
		}
	}
	else
		self iPrintln("^1Please Wait There Is Something Else Spawning!");
}
buildMerry()
{
	center = self.origin;
	level.crates = [];
	sizeArray = strTok("21;12;9",";");
	for(z = 0; z < 160; z += 155)
	{
		num = 0;
		for(k = 55; k < 200; k += 55)
		{
			for(r = 0; r < 360; r += int(sizeArray[num]))
			{
				size = level.crates.size;
				x = center[0]+(k*cos(r));
				y = center[1]+(k*sin(r));
				level.crates[size] = spawn("script_model",(x,y,center[2]+z));
				level.crates[size] setModel("com_plasticcase_beige_big");
				angle = vectorToAngles(level.crates[size].origin - (center[0],center[1],center[2]+z));
				level.crates[size].angles = (angle[0],angle[1],0);
				destroyArray(level.crates[size]);
				wait .05;
			}
			num ++;
		}
	}
	for(z = 28; z < 168; z +=28)
	{
		for(k = 0; k < 7; k++)
		{
			size = level.centerCrates.size;
			level.centerCrates[size] = spawn("script_model",(center[0],center[1],center[2]+z-10));
			level.centerCrates[size] setModel("com_plasticcase_beige_big");
			level.centerCrates[size].angles = (0,22*k,0);
			destroyArray(level.centerCrates[size]);
		}
		wait .05;
	}
	thread spawnSeat(center+(-123,101,40),(90,45,0));
	thread spawnSeat(center+(-23,-101,40),(90,0,0));
	thread spawnSeat(center+(-23,101,40),(90,0,0));
	thread spawnSeat(center+(-101,-123,40),(90,135,0));
	thread spawnSeat(center+(101,-23,40),(90,90,0));
	thread spawnSeat(center+(123,-101,40),(90,-135,0));
	thread spawnSeat(center+(101,123,40),(90,-45,0));
	thread spawnSeat(center+(-101,-23,40),(90,90,0));
	for(k = 0; k < level.merrySeat.size; k++)
	{
		level.seatCenter[k] = spawn("script_origin",center);
		destroyArray(level.seatCenter[k]);
		level.merrySeat[k] linkTo(level.seatCenter[k]);
		level.seatCenter[k] thread moveSeat();
	}
	center = spawn("script_origin",center);
	for(k = 0; k < level.crates.size; k++)
		level.crates[k] linkTo(center);
		
	center thread monitorPlayers();
	level.spawningObject = false;
	center showIconOnMap("compass_waypoint_panic");
	while(level.merryGoRound)
	{
		center rotateYaw(-360,4);
		for(k = 0; k < level.seatCenter.size; k++)
			level.seatCenter[k] rotateYaw(-360,4);
			
		wait 4;
	}
}
monitorPlayers()
{
	while(level.merryGoRound)
	{
		for(k = 0; k < level.players.size; k++)
		{
			player = level.players[k];
			if(distance(self.origin,player.origin) < 210)
			{
				closest = getClosest(player.origin,level.merrySeat);
				if(!closest.inUse && !player.Occ)
				{
					player.oldOrigin = player getOrigin();
					player playerLinkTo(closest);
					closest.inUse = true;
					player.Occ = true;
					Player iPrintln("Press [{+Melee}] To Exit Merry Go Round");
				}
				else if(player meleeButtonPressed() && closest.inUse && player.Occ)
				{
					player unlink();
					player setOrigin(player.oldOrigin);
					closest.inUse = false;
					wait 2;
					player.Occ = false;
				}
			}
		}
		wait .05;
	}
}
spawnSeat(arg,angles)
{
	if(!isDefined(level.merrySeat))
		level.merrySeat = [];
		
	size = level.merrySeat.size;
	level.merrySeat[size] = spawnStruct();
	level.merrySeat[size] = spawn("script_model",arg);
	level.merrySeat[size] setModel("com_barrel_blue_rust");
	level.merrySeat[size].angles = angles;
	level.merrySeat[size].inUse = false;
	destroyArray(level.merrySeat[size]);
}
moveSeat()
{
	while(level.merryGoRound)
	{
		rand = randomFloatRange(1,2);
		self moveTo((self.origin[0],self.origin[1],self.origin[2]+85),rand);
		wait rand;
		Rand = randomFloatRange(1,2);
		self moveTo((self.origin[0],self.origin[1],self.origin[2]-85),rand);
		wait rand;
	}
}
playerLinkTo(linkTo)
{
	self setOrigin(linkTo.origin-(0,0,35));
	self linkTo(linkTo);
}
getClosest(origin,ents)
{
	index = 0;
	dist = distance(origin,ents[index].origin);
	for(k = 1; k < ents.size; k++)
	{
		temp_dist = distance(origin,ents[k].origin);
		if(temp_dist < dist)
		{
			dist = temp_dist;
			index = k;
		}
	}
	return ents[index];
}


rainModel()
{
	if(!level.rainModel)
	{
		thread rain("vehicle_mig29_desert");
		self iPrintln("Raining Mig29 [^2ON^7]");
		level.rainModel = true;
	}
	else
	{
		self iPrintln("Raining Mig29 [^1OFF^7]");
		level.rainModel = false;
	}
}
rain(model)
{
	self endon("unverified");
	level endon("game_ended");
	
	while(level.rainModel)
	{
		range = [];
		for(k = 0; k < 2; k++)
			range[k] = randomIntRange(-2000,2000);
			
		s_model = spawn("script_model",(range[0],range[1],2000));
		s_model setModel(model);
		s_model physicsLaunch(s_model.origin,(0,0,-5000));
		s_model thread deleteAfterTime();
		wait .2;
	}
}









