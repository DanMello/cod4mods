#include common_scripts\utility;
#include maps\mp\gametypes\_hud_util;
#include maps\mp\_utility;
#include maps\mp\gametypes\_general_funcs;
#include maps\mp\gametypes\_Zombieland;
#using_animtree("multiplayer");

SuperBoots()
{
	self.hasSuperBoots = true;
	self iprintlnbold("You're now immunize against turtle power");
}


lozJerichoSystem()
{
	self endon("death");
	level endon("Jericho_done");
	
	if(!self.lozJerichoSpawned)
	{
		self.lozJerichoSpawned = true;
		level.PlayerUsingJericho = true;
		
		self thread Jericho_on_death("dis");
		self thread Jericho_on_death();
		self thread JerichoTime();

		self giveweapon("deserteagle_mp");
	
		notifyData = spawnStruct();
		notifyData.titleText = "Jericho Missiles [ONLINE]";
		notifyData.glowColor = (0,0,1);
		notifyData.sound = "mp_killstreak_jet";
		notifyData.duration = 5;
		self maps\mp\gametypes\_hud_message::notifyMessage( notifyData );
		
		
		BaseOrigin = GetJerichoBase(self);
		self.Jericho_base = spawn("script_model",BaseOrigin);
		
		self.missile = [];
		self.missile[0] = spawn("script_model",BaseOrigin + (0,30,0));
		self.missile[0] setModel("projectile_cbu97_clusterbomb");
		self.missile[1] = spawn("script_model",BaseOrigin + (0,0,0));
		self.missile[1] setModel("projectile_cbu97_clusterbomb");
		self.missile[2] = spawn("script_model",BaseOrigin + (0,-30,0));
		self.missile[2] setModel("projectile_cbu97_clusterbomb");
			
	
		self.missile[3] = spawn("script_model",BaseOrigin+(0,0,-20));
		self.missile[3] setModel("com_pallet_2");
	
		self.missile[4] = spawn("script_model",BaseOrigin + (-15,0,-50));
		self.missile[4] setModel("com_plasticcase_beige_big");
		self.missile[4].angles = (90,0,0);
	
		self.missile[5] = spawn("script_model",BaseOrigin + (-15,0,-100));
		self.missile[5] setModel("com_plasticcase_beige_big");
		self.missile[5].angles = (90,0,0);
	
		if(isDefined(level.mapCenter))
			MapOrigin = VectorToAngles(level.mapCenter - BaseOrigin);
		else
			MapOrigin = (0,90,0);
		
		for(x = 0; x < 6; x++)
			self.missile[x] linkto(self.Jericho_base);
					
		self.Jericho_base moveto(BaseOrigin + (0,0,100),2);
		
		wait 2;
		
		self.Jericho_base rotateTo(MapOrigin + (-40,0,0), 3);	
		
		wait 3;
		location = [];
		self.lozJerichoFx = [];
		num = 0;
		
		for(s = 0; s < 6; s++)
			self.missile[s] unlink();
		
		wait .5;
		
		self switchtoweapon("deserteagle_mp");
		
		for(o = 0; o < 3; o++)
		{
			self iprintlnbold("Missile "+(o+1)+" ^2Ready\n^7Mark the positions by shooting!");
			
			for(e = 0; e < 5; e++)
			{
				self waittill("weapon_fired");
			
				self givemaxammo("deserteagle_mp");
				
				if(self getcurrentweapon() != "deserteagle_mp")
				{
					e--;
					continue;
				}
				
				self playSound("mp_ingame_summary");
				trace = bulletTrace(self getTagOrigin("j_head"), self getTagOrigin("j_head") + anglesToForward(self getPlayerAngles()) * 1000000, 0, self)["position"];
				location[e] = trace;
				self.lozJerichoFx[e] = spawnFx(level.yellow_circle, trace);
				TriggerFX(self.lozJerichoFx[e]);
				
				wait .2;
			}
			
			self playSound("oldschool_return");
				
			for(w = 0; w < 5; w++)
			{
				self.lozJerichoFx[w] delete();
				self.lozJerichoFx[w] = spawnFx(level.red_circle, location[w]);
				triggerFx(self.lozJerichoFx[w]);
			}
			
			for(;;)
			{
				self waittill("weapon_fired");
				
				if(self getcurrentweapon() == "deserteagle_mp")
				break;
			}
			
			 
			speed = vectorScale(vectorNormalize(anglesToForward(self.missile[num].angles)), 5000);
			self.missile[num] thread trailLozBullet(level.smoke_rpg_trail, .1, 1);
			
			self.Jericho_base playSound("weap_cobra_missile_fire");
			
			wait .3;
			
			self.missile[num] moveGravity(speed, 3);
			wait 1;
			
			expPos = self.missile[num].origin;
			
			playFx(level.airstrikefx, expPos);
			self.missile[num] thread maps\mp\gametypes\_hardpoints::playsoundinspace("hind_helicopter_secondary_exp", expPos);
			
			for(c = 0; c < 360; c += 80)
				playFx(loadfx(level.bombstrike), (expPos[0]+(200*cos(c)), expPos[1]+(200*sin(c)), expPos[2]));
			
			self.missile[num] delete();
			
			for(a = 0; a < 5; a++)
				self thread spawnLozBullet("ks",expPos,"projectile_hellfire_missile",3000,loadfx("explosions/tanker_explosion"),5,4,level.smoke_rpg_trail,.1,"exp_suitcase_bomb_main",.3,2,500,400,500,100,"MOD_PROJECTILE_SPLASH","artillery_mp","grenade_rumble",500,location[a]);
			
			wait 1.5;
			
			for(q = 0; q < 5; q++)
				self.lozJerichoFx[q] delete();
				
			num++;
		}
		
		self takeweapon("deserteagle_mp");
		
		for(p=2;p<6;p++)
			self.missile[p] delete();
		
		self.Jericho_base delete();
	
		level.PlayerUsingJericho = false;
		self.lozJerichoSpawned = false;
		iprintln("Jericho Missiles [^1OFFLINE^7]");
		level notify("Jericho_done");
	}
	else
		self iPrintLn("^1Warning^7 : Jericho System Already Active");
}
JerichoTime()
{
	level endon("Jericho_done");
	wait 180;
	self iprintlnbold("Time expired !");
	self thread Jericho_on_death("defined");
}
Jericho_on_death(opt)
{
	//self endon("disconnect");
	level endon("game_ended");
	level endon("Jericho_done");
	
	if(!isDefined(opt))
		self waittill("death");
	
	if(isDefined(opt) && opt == "dis")
		self waittill("disconnect");
	
	for(s = 0; s < 6; s++)
			if(isDefined(self.missile[s]))self.missile[s] delete();
	self.Jericho_base delete();	
	
	for(w = 0; w < 5; w++) self.lozJerichoFx[w] delete();
			
	self takeweapon("deserteagle_mp");
	
	iprintln("Jericho Missiles [^1OFFLINE^7]");
	level.PlayerUsingJericho = false;
	self.lozJerichoSpawned = false;
	level notify("Jericho_done");
}

trailLozBullet(trailFX,trailTime, missile)
{
	while(isDefined(self))
	{
		if(isDefined(missile))
			playfxontag( level.fx_airstrike_afterburner, self, "tag_origin" );
		
		playFxOnTag(trailFX, self, "tag_origin");
		wait trailTime;
	}
}

spawnLozBullet(lozType,spawnPos,model,speed,FX,range,timeout,trailFX,trailTime,sound,eqScale,eqTime,eqRadius,rdRange,rdMax,rdMin,rdMod,rdWeap,rumble,rumbleMaxDist,expPos)
{
	bullet = spawn("script_model",spawnPos);
	bullet setModel(model);
	
	
	bullet.killcament = bullet;
	//if(lozType == "plr")
	tracer = bulletTrace(self getEye(), self getEye()+vectorScale(anglesToForward(self getPlayerAngles()), 1000000), true, self)["position"];
	
	if(lozType == "ks" && isDefined(expPos))
		tracer = expPos;
	
	bullet.angles = vectorToAngles(tracer - bullet.origin);
	bullet rotateTo(vectorToAngles(tracer - bullet.origin), .01);
	
	duration = calcDistance(speed, bullet.origin, tracer);
	
	bullet moveTo(tracer, duration);
	
	if(isDefined(trailFX) && isDefined(trailTime)) 
		bullet thread trailLozBullet(trailFX, trailTime);
	
	if(duration < range)
		wait duration;
	else
		wait timeout;
	
	if(isDefined(sound))
	bullet thread maps\mp\gametypes\_hardpoints::playsoundinspace(sound, bullet.origin );
		//bullet playSound(sound);
	if(isDefined(eqScale) && isDefined(eqTime) && isDefined(eqRadius)) 
		earthquake(eqScale, eqTime, bullet.origin, eqRadius);
	if(isDefined(FX)) 
		playFx(FX, bullet.origin + (0,0,1));
		
	bullet RadiusDamage(bullet.origin, rdRange, rdMax, rdMin, self, rdMod, rdWeap);
	
	if(isDefined(rumble) && isDefined(rumbleMaxDist))
	{
		for(i=0;i<level.players.size;i++)
		{
			if(distance(level.players[i].origin, bullet.origin)< rumbleMaxDist)
				level.players[i] playRumbleOnEntity(rumble);
		}
	}
	bullet delete();
}

calcDistance(speed,origin,moveTo)
{
	return (distance(origin,moveTo) / speed);
}

GetJerichoBase(player)
{
	switch(level.script)
	{
		case"mp_convoy": return (1073,-999,112);
		case"mp_backlot": return (468,-1274,472);
		case"mp_bloc": return (-1659,-8028,3);
		case"mp_bog": return (3465,1228,123);
		case"mp_countdown": return (-1040,2232,310);
		case"mp_crash": return (1495,-1560,400);
		case"mp_crossfire": return (3309,-3301,340);
		case"mp_citystreets": return (4109,-492,-23);
		case"mp_farm": return (980,2880,501);
		case"mp_overgrown": return (1665,-1555,28);
		case"mp_pipeline": return (1241,74,208);
		//case"mp_shipment": return ();
		case"mp_showdown": return (7,2199,382);
		case"mp_strike": return (98,599,404);
		case"mp_vacant": return (67,329,208);
		case"mp_cargoship": return (-2518,-557,752);
		
		default: return player.origin;
	}
}





showOnMiniMap(shader)
{
	if(!isDefined(level.numGametypeReservedObjectives)) level.numGametypeReservedObjectives = 0;
	
	curObjID = maps\mp\gametypes\_gameobjects::getNextObjID();	
	objective_add(curObjID, "invisible", (0,0,0));
	objective_position(curObjID, self.origin);
	objective_state(curObjID, "active");
	objective_icon(curObjID, shader);
}




CreateWeaponOnWall(position,angles,model,weapon)
{
	weapon = spawn("script_model", position);
	weapon setModel (model);
	weapon.angles = angles;
	
	while(!level.gameEnded)
	{
		for(i=0;i<level.players.size;i++)
		{
			player = level.players[i];
			
			if(player.team == "allies" && Distance(player.origin, weapon.origin + (0,0,-50)) <= 10)
			{
				player.hint = "Press [{+reload}] for this weapon [^3COST "+level.itemCost["rpdbloc"]+"$^7]";
				
				if(player useButtonPressed())
				{
					if(player.bounty >= level.itemCost["rpdbloc"])
					{
						player.bounty -= level.itemCost["rpdbloc"];
						
						player takeWeapon(player getcurrentweapon());
						player giveWeapon(weapon);
						player switchToWeapon(weapon);
						player giveMaxAmmo(weapon);
						wait .5;
					}
					else
						player iPrintlnBold("^1Need More ^3$$");
				}
			}
		}
		wait .05;
	}
}	
CreateLight(position,angles, light_1, light_2,light_3,light_4,light_1_angles,light_2_angles,light_3_angles,light_4_angles,Light_effect)
{	
	Laser = SpawnFX(level.claymore_laser, position );
	Laser.angles = angles;
	TriggerFX(Laser);
	Laser.lights_status = "off";
	Laser thread LightSwitch();
	Laser thread LightEffects(position,light_1, light_2,light_3,light_4,light_1_angles,light_2_angles,light_3_angles,light_4_angles,Light_effect);
}

LightEffects(position,light_1, light_2,light_3,light_4,light_1_angles,light_2_angles,light_3_angles,light_4_angles,Light_effect)
{	
	level endon("game_ended");
	
	Light_effect = level.yellow_circle;
	
	Light1 = SpawnFx(Light_effect, Light_1);
	Light1.angles = Light1;
	Light2 = SpawnFx(Light_effect, Light_2);
	Light2.angles = Light2;
	Light3 = SpawnFx(Light_effect, Light_3);
	Light3.angles = Light3;
	Light4 = SpawnFx(Light_effect, Light_4);
	Light4.angles = Light4;
	
	while(1)
	{
		self waittill("light_switch");
		
		if(self.lights_status == "off")
		{	
			self.lights_status = "on";
			TriggerFX(Light1);
			TriggerFX(Light2);
			TriggerFX(Light3);
			TriggerFX(Light4);
		}
		else if(self.lights_status == "on")
		{	
			Light1 delete();
			Light2 delete();
			Light3 delete();
			Light4 delete();
			
			Light1 = SpawnFx(Light_effect, Light_1);
			Light1.angles = Light1;
			Light2 = SpawnFx(Light_effect, Light_2);
			Light2.angles = Light2;
			Light3 = SpawnFx(Light_effect, Light_3);
			Light3.angles = Light3;
			Light4 = SpawnFx(Light_effect, Light_4);
			Light4.angles = Light4;
		}
	}
}
LightSwitch(position)
{	
	level endon("game_ended");
	
	while(1)
	{
		for(i=0;i<level.players.size;i++)
		{
			player = level.players[i];
			
			if(Distance(self.origin, player.origin) <= 50)
			{
				if(self.lights_status == "off")
					player.hint = "Press [{+reload}] to turn ^2ON ^7Lights";
				else if(self.lights_status == "on")	
					player.hint = "Press [{+reload}] to turn ^1Off ^7Lights";
				
				if(player UseButtonPressed())
				{
					self notify("light_switch");
					wait 1;
				}
			}
		}
		wait .05;
	}
}
ForceField(Panel_position, ForceField_position, angles, width, height, hp, range,effect)
{	
	Panel = spawn("script_model", Panel_position );
	Panel setModel("com_laptop_2_open");
	Panel showOnMiniMap("field_radio");
	Panel.angles = angles;
	Panel.hp = hp;
	Panel thread ForceFieldSwitch(Panel_position, ForceField_position, range);
	Panel thread ForceFieldEffects(ForceField_position, width, height,effect);
}
ForceFieldEffects(ForceField_position, width, height,effect)
{
	level endon("game_ended");
	
	effect = level.jet_efx;
	
	ForceField = spawn("script_model", ForceField_position );
	ForceField_EFX = SpawnFx(effect, ForceField_position);
	ForceField_EFX.angles = (270,0,0);
	
	self.ForceFieldstatus = "off";
	
	while(1)
	{	
		self waittill("forcefield_status_changed");
		
		if(self.ForceFieldstatus == "off")
		{	
			self.ForceFieldstatus = "on";
			self playLoopSound("cobra_helicopter_dying_loop");
			ForceField = spawn( "trigger_radius", ( 0, 0, 0 ), 0, width, height); 
			ForceField.origin = ForceField_position; 
			ForceField.angles = self.angles;
			ForceField setContents(1);
			TriggerFX(ForceField_EFX);
			wait 1;
			self stopLoopSound("cobra_helicopter_dying_loop");
		}
		else if(self.ForceFieldstatus == "on")
		{	
			self.ForceFieldstatus = "off";
			self playloopsound("cobra_helicopter_dying_loop");
			ForceField delete();
			ForceField_EFX delete();
			ForceField_EFX = SpawnFx(effect, ForceField_position);
			ForceField_EFX.angles = (270,0,0);
			wait 1;
			self stoploopsound("cobra_helicopter_dying_loop");
		}
		else if(self.ForceFieldstatus == "broken") 
		{
			self playsound("cobra_helicopter_crash");
			ForceField delete();
			ForceField_EFX delete();
			break;
		}
	}
}
ForceFieldSwitch(position,ForceField_position, range)
{	
	level endon("game_ended");
	
	wait 1;
	
	while(1)
	{
		for(i=0;i<level.players.size;i++)
		{
			player = level.players[i];	
			
			if(Distance(position, player.origin) <= range)
			{
				if(player.team == "allies")
				{
					if(self.ForceFieldstatus == "off")
						player.hint = ("Press [{+reload}] to turn ^2ON ^7ForceField");
					else if(self.ForceFieldstatus == "on") 
						player.hint = ("Press [{+reload}] to turn ^1OFF. ^7Power:^2" + self.hp + "");
					else if(self.ForceFieldstatus == "broke")
						player.hint = ("ForceField is ^1broken");
					
					if(player UseButtonPressed())	
					{
						self notify( "forcefield_status_changed");
						
						self playloopsound("weap_suitcase_button_press_plr");
						wait .5;
						self StopLoopSound("weap_suitcase_button_press_plr");
					}
				}
			}
			else if(Distance(ForceField_position, player.origin) <= range)
			{
			
				if(player.team == "axis")
				{
					//player iprintln("area");
					
					
					if(self.ForceFieldstatus == "on")
						player.hint = ("Press [{+melee}] to ^1drain ^7ForceField");
					else if(self.ForceFieldstatus == "broke")
						player.hint = ("ForceField ^2Broken");
					
					if(player MeleeButtonPressed() && self.ForceFieldstatus == "on")
					{
						self.hp--;
						player iPrintlnBold("^1HIT! ^7Power:^2" + self.hp + "");
						player.bounty += 5;
						
						if(self.hp <= 0)
						{
							self.ForceFieldstatus = "broken";
							self notify( "forcefield_status_changed");
						}
						wait 1;
					} 
				}
			}
		}
		wait .05;
	}
}
CreateDoors(open, close, angles, size, height, hp, range)
{
	offset = (((size / 2) - 0.5) * -1);

	Door = spawn("script_model", open );
	Door showOnMiniMap("hint_usable");
	
	for(j=0;j<size;j++)
	{
		Block = spawn("script_model", open + ((0, 30, 0) * offset));
		Block setModel("com_plasticcase_beige_big");
		Block Solid();
		Block EnableLinkTo();
		Block LinkTo(Door);
		
		doorcol[0] = spawn("trigger_radius", open + ((0, 30, 0) * offset), 1, 40, 40);
		doorcol[1] = spawn("trigger_radius", open + ((0, 30, 0) * offset), 1, 40, 40);
		
		for(o=0;o<=2;o++)
		{	
			doorcol[o].angles = (0,0,0);
			doorcol[o] setContents(1);
			doorcol[o] EnableLinkTo();
			doorcol[o] LinkTo(Door);
		}
		for(h=1;h<height;h++)
		{
			Block = spawn("script_model", open + ((0, 30, 0) * offset) - ((70, 0, 0) * h));
			Block setModel("com_plasticcase_beige_big");
			Block Solid();
			Block EnableLinkTo();
			Block LinkTo(Door);
			
			doorcol1[0] = spawn("trigger_radius", open + ((0, 30, 0) * offset - ((70, 0, 0) * h)), 1, 40, 40);
			doorcol1[1] = spawn("trigger_radius", open + ((0, 30, 0) * offset - ((70, 0, 0) * h)), 1, 40, 40);
			
			for(k=0;k<=2;k++)
			{	
				doorcol1[k].angles = (0,0,0);
				doorcol1[k] setContents(1);
				doorcol1[k] EnableLinkTo();
				doorcol1[k] LinkTo(Door);
			}
		}
		
		offset += 1;
	}
	
	wait 1;
	
	Door.angles = angles;
	Door.state = "open";
	Door.hp = hp;
	Door.range = range;
	level.doorwait = 2;
	Door thread DoorUse();
	Door thread DoorThink(open, close);
}
DoorThink(open, close)
{
	level endon("game_ended");
	
	while(1)
	{
		if(self.hp > 0)
		{
			self waittill("door_use" ,player);
			
			if(player.team == "allies")
			{
				if(self.state == "open")
				{
					self MoveTo(close, level.doorwait);
					wait level.doorwait;
					self.state = "close";
				}
				else if(self.state == "close")
				{
					self MoveTo(open, level.doorwait);
					wait level.doorwait;
					self.state = "open";
				}
			}
			else if(player.team == "axis")
			{
				if(self.state == "close")
				{
					self.hp--;
					player iPrintlnBold("HIT! +5$");
					player.bounty += 5;
					wait 1;
				}
			}
		} 
		else 
		{
			if(self.state == "close")
				self MoveTo(open, level.doorwait);
			
			self.state = "broken";
			wait .5;
		}
	}
}				
DoorUse()
{
	level endon("game_ended");
	
	while(1)
	{
		for(i=0;i<level.players.size;i++)
		{
			player = level.players[i];
			
			if(Distance(self.origin, player.origin) <= self.range)
			{
				if(player.team == "allies")
				{
					if(self.state == "open") player.hint = "[{+melee}] ^1Closes ^7the door.";
					if(self.state == "close") player.hint = "[{+melee}] ^2Opens ^7the door. [{+reload}] Shows ^2HP.";
					if(self.state == "broken") player.hint = "Door is Broken";
				}
				else if(player.team == "axis")
				{
					if(self.state == "close") player.hint = "[{+melee}] ^1Damages ^7the door. [{+reload}] Shows ^2HP.";
					if(self.state == "broken") player.hint = "^1Door is Broken";
				}
				
				if( player MeleeButtonPressed())
					self notify( "door_use" , player);
				if( player UseButtonPressed())
				{
					player iPrintlnBold("^3" + self.hp + "^1:HP Left");
					wait .5;
				}
			}
		}
		wait .05;
	}
}
createPerkMachine(position, angles, perk, number, lev, text)
{
	level endon("game_ended");
	
	Machine = spawn("script_model", position);
	Machine showOnMiniMap(perk);
	Machine.angles = angles;

	wait 1;
	
	for(;;)
	{
		for(i=0;i<level.players.size;i++)
		{
			player = level.players[i];
			
			if(player.team == "allies" && distance(player.origin, Machine.origin) < 50)
			{
				player.hint = "Press [{+reload}] for "+text+"^7[^3COST "+level.itemCost["bulletp"]+"$^7]";
				
				if(player useButtonPressed())
				{
					if(!self hasPerk(perk))
					{
						if(player.bounty >= level.itemCost["bulletp"])
						{
							player.bounty -= level.itemCost["bulletp"];
							player iPrintlnBold("^2Perk buy");
							player setPerk(perk);
							player showPerk(lev, perk, -50);
							wait .5;
						} 
						else
						{
							player iPrintlnBold("^1Need More ^3$$");
							wait .5;
						} 
					}
					else
						player iPrintlnBold("^1Perk already buy");
				}
			}	
		}
		wait .05;
	}
}

createWeaponBox(position,angles)
{
	level endon("game_ended");
	
	Box = spawn("script_model", position);
	Box.angles = angles;
	Box setModel("com_plasticcase_beige_big");
	Box showOnMiniMap("weapon_m4carbine");
	
	WayPointIcon = maps\mp\gametypes\_objpoints::createTeamObjpoint( "0" , box.origin + (0,0,20), "all", undefined );
	WayPointIcon setWayPoint( true, "weapon_m4carbine" );
	WayPointIcon.alpha = 1;
	
	wait 1;
	
	for(;;)
	{
		for(;;)
		{
			for(i=0;i<level.players.size;i++)
			{
				player = level.players[i];

					if(player.team == "allies" && distance(player.origin, Box.origin) < 50)
					{
						player.hint = "Press [{+reload}] To Use ^2Random Box ^7[^3COST 200$^7]";
						
						if(player useButtonPressed() && !player gotAllWeapons())
						{
							if(player.bounty >= level.itemCost["rbox"])
							{
								player.bounty -= level.itemCost["rbox"]; 
								level.BoxUser = player;
								wait .5;
							}
							else 
							{
								player iPrintlnBold("^1Need More ^3$$");
								wait .5;
							} 
						}
					}
				}

			if(isDefined(level.BoxUser))
				break;
			wait .05;
		}
		
		User = level.BoxUser;
		Weapon = User treasure_chest_weapon_spawn(position,angles);
		thread boxTimeout(User, Weapon);
		
		for(;;)
		{
			if(isSubStr(Weapon.weap, "m14_") || isSubStr(Weapon.weap, "deserteaglegold_")) 
			{
				User iprintlnbold("^1Sorry it's a bad weapon.\nWe apologize, we give you 250$");
				User.bounty += 250;
				break;
			}
			else
			{
				if(distance(User.origin, Box.origin) < 50)
				{
					User.hint = "Press [{+reload}] To ^2Take ^7Weapon";
					
					if(User useButtonPressed())
					{
						if(isSubStr(Weapon.weap, "c4_") || isSubStr(Weapon.weap, "claymore_") || isSubStr(Weapon.weap, "frag_grenade_") || isSubStr(Weapon.weap, "flash_grenade_") || isSubStr(Weapon.weap, "concussion_grenade_") || isSubStr(Weapon.weap, "smoke_grenade_")	|| isSubStr(Weapon.weap, "rpg_"))
							User iprintlnbold("^1If you change your weapon you will lose this one !!");
						else
							User takeWeapon(user getcurrentweapon());
						
						User giveWeapon(Weapon.weap);
						User switchToWeapon(Weapon.weap);
						User giveMaxAmmo(Weapon.weap);
						User playSound("oldschool_pickup");
						User notify("weapon_collected");
						break;
					}
					if(isDefined(User.timedOut))
						break;
				}
			}
			wait .05;
		}
		Weapon delete();
		wait 2;
		level.BoxUser = undefined;
	}
}
boxTimeout(User, weapon)
{
	User endon("user_grabbed_weapon");
	weapon moveTo(weapon.origin-(0, 0, 30), 12, (12*.5));
	wait 12;
	User.timedOut = true;
	wait .2;
	User.timedOut = undefined;
}
treasure_chest_weapon_spawn(position,angles)
{
	gun = spawn("script_model", position +(0, 0, 20));
	gun setModel("");
	gun moveTo(position+(0, 0, 40), 3, 2, .9);
	gun.angles = angles;
	
	weaponArray = [];
	
	for(m = 0; m < level.weaponlist.size; m++)
		if(!self hasWeapon(level.weaponlist[m]))
			weaponArray[weaponArray.size] = level.weaponlist[m];
			
	randy = 0;
	
	for(m = 0; m < 40; m++)
	{
		if(m < 20) wait .05;
		else if(m < 30) wait .1;
		else if(m < 35) wait .2;
		else if(m < 38) wait .3;
		
		randy = weaponArray[randomInt(weaponArray.size)];
		gun setModel(getWeaponModel(randy));
		gun.weap = randy;
	}
	return gun;
}
gotAllWeapons()
{
	for(m = 0; m < level.weaponlist.size; m++)
		if(!self hasWeapon(level.weaponlist[m]))
			return false;
	return true;
}

createMegaLine(start, end, p2, p3, p4, p5, p6, effect)
{
	effect = level.red_circle;
	startPosition = (start + (0,0,110));
	endPosition = (end + (0,0,110));
	Zipline = spawn("script_model", startPosition);
	Zipline SetModel("vehicle_cobra_helicopter_d_piece07");
	Zipline showOnMiniMap("objective_friendly_chat");
	ZiplineAngle = VectorToAngles( p2 - start );
	Zipline.angles = ZiplineAngle;
	Zipline_EFX = SpawnFx(effect, start);
	TriggerFX(Zipline_EFX);
	Second_Zipline = spawn("script_model", endPosition);
	Second_Zipline SetModel("vehicle_cobra_helicopter_d_piece07");
	Second_Zipline showOnMiniMap("objective_friendly_chat");
	Second_ZiplineAngle = VectorToAngles( p6 - end );
	Second_Zipline.angles = Second_ZiplineAngle;
	Second_Zipline_EFX = SpawnFx(effect, end);
	TriggerFX(Second_Zipline_EFX);
	
	Zipline thread MegaLineArea(start, end, p2, p3, p4, p5, p6);
}
MegaLineArea(start, end, p2, p3, p4, p5,p6)
{	
	level endon("game_ended");
	
	Line = self;
	Line.used = false;
	
	wait 1;
	
	while(1)
	{	
		for(i=0;i<level.players.size;i++)
		{
			player = level.players[i];
			
			if(Distance(start, player.origin) <= 50)
			{	
				player.hint = "Hold [{+reload}] to use ^2MegaLine";
				if(!player.isInZiplineArea)
					player thread MegaLineMove(start, end, p2, p3, p4, p5,p6, Line,0);
			}
			
			if(Distance(end, player.origin) <= 50)
			{	
				player.isUsingZipline = "Hold [{+reload}] to use ^2MegaLine";
				if(!player.isInZiplineArea)
					player thread MegaLineMove(start, end, p2, p3, p4, p5,p6, Line,1);
			}
		}
		wait .05;
	}
}
ZiplineOnDeath(line)
{	
	self endon("ZIPLINE_END");
	self waittill("death");
	line.used = false;
	self.isInZiplineArea = false;
	self.isUsingZipline = false;
}
MegaLineMove(start,end,p2,p3,p4,p5,p6,line,var)
{	
	self endon("disconnect");
	self endon("death");
	level endon("game_ended");
	
	self.isInZiplineArea = true;
	
	FirstDefined = false;
	
	for(j=0;j<60;j++)
	{
		if(self UseButtonPressed())
		{
			wait .5;
			
			if( self UseButtonPressed())
			{
				self.isUsingZipline=true;
				
				self thread ZiplineOnDeath(line);
				
				if(isdefined(self.Platform)) self.Platform delete();
				
				if(var == 0)
				{
					if(isDefined(p2)) self MegaLineAction(start,p2,1);
					if(isDefined(p3)) self MegaLineAction(p2,p3,0);
					if(isDefined(p4)) self MegaLineAction(p3,p4,0);
					if(isDefined(p5)) self MegaLineAction(p4,p5,0);
					if(isDefined(p6)) self MegaLineAction(p5,p6,0);
					if(isDefined(p2)) self MegaLineAction(self.origin,end,2);
					else self MegaLineAction(start,end,3);
				} 
				else
				{
					if(isDefined(p6))
					{
						self MegaLineAction(end,p6,1);
						FirstDefined = true;
					}
					if(isDefined(p5))
					{
						if(FirstDefined) 
							self MegaLineAction(p6,p5,0);
						else
							self MegaLineAction(end,p5,1);
						FirstDefined = true;
					}
					
					if(isDefined(p4))
					{
						if(FirstDefined)
							self MegaLineAction(p5,p4,0);
						else
							self MegaLineAction(end,p4,1);
						FirstDefined = true;
					}
					if(isDefined(p3))
					{
						if(FirstDefined)
							self MegaLineAction(p4,p3,0);
						else 
							self MegaLineAction(end,p3,1);
						FirstDefined = true;
					}
					if(isDefined(p2))
					{	
						if(FirstDefined)
							self MegaLineAction(p3,p2,0);
						else 
							self MegaLineAction(end,p2,1);
						FirstDefined = true;
					}
					
					if(FirstDefined)
						self MegaLineAction(self.origin,start,2);
					else
						self MegaLineAction(end,start,3);
				}
				
				wait .2;
				self playsound("weap_suitcase_drop_plr");
				self unlink();
				line.used = false;
				self.isUsingZipline = false;
				self notify("ZIPLINE_END");
				if(isdefined(self.Platform)) self.Platform delete();
				wait 1;
				break;
			}			
		}
		if(Distance(start, self.origin) > 70 && Distance(end, self.origin) > 70)
			break;
		wait .1;
	}
	self.isInZiplineArea = false;
}
MegaLineAction(p1,p2,var)
{
	dis = Distance(p1, p2);
	time = (dis/300);
	acc = 0.3;
	
	if(self.lght == 1)
		time = (dis/600);
	else	
	{
		if(time > 2.1) acc = 1;
		if(time > 4) acc = 1.5;
	}
	
	if(time < .5) 
		time = .5;
	
	org = (p1 + (0,0,35));
	des = (p2 + (0,0,40));
	
	if(var == 1)
	{	
		PlayerAngles = VectorToAngles( des - org);
		self SetPlayerAngles(PlayerAngles);
		self setOrigin(org);
		
		self.Platform = spawn("script_origin", org);
		self linkto(self.Platform);
		self.Platform MoveTo( des, time, acc, 0);
	}
	else if(var == 2)
		self.Platform MoveTo( des, time, 0, acc);
		
	else if(var == 3)
		self.Platform MoveTo( des, time, acc, acc);
	else
		self.Platform MoveTo( des, time, 0, 0);
	
	wait (time);
}

CreateZipline(start, end, effect)
{	
	effect = level.red_circle;
	startPosition = (start + (0,0,110));
	endPosition = (end + (0,0,110));
	Zipline = spawn("script_model", startPosition);
	Zipline SetModel("vehicle_cobra_helicopter_d_piece07");
	Zipline showOnMiniMap("objective_friendly_chat");
	ZiplineAngles = VectorToAngles( end - start );
	Zipline.angles = ZiplineAngles;
	Zipline_EFX = SpawnFx(effect, start);
	TriggerFX(Zipline_EFX);
	Second_Zipline = spawn("script_model", endPosition);
	Second_Zipline SetModel("vehicle_cobra_helicopter_d_piece07");
	Second_Zipline showOnMiniMap("objective_friendly_chat");
	Second_ZiplineAngles = VectorToAngles( start - end );
	Second_Zipline.angles = Second_ZiplineAngles;
	Second_Zipline_EFX = SpawnFx(effect, end);
	TriggerFX(Second_Zipline_EFX);
	
	Zipline thread ZiplineArea(start, end);
	
}
ZiplineArea(start, end)
{	
	level endon("game_ended");
	
	line = self;
	line.used = false;
	
	wait 1;
	
	while(1)
	{	
		for(i=0;i<level.players.size;i++)
		{	
			player = level.players[i];
			
			if(Distance(start, player.origin) <= 50)
			{
				player.hint = "Hold [{+reload}] To Use ^2ZipLine";
				if(!player.isInZiplineArea)
					player thread ZiplineMove(start, end, line);
			}
			if(Distance(end, player.origin) <= 50)
			{	
				player.hint = "Hold [{+reload}] To Use ^2ZipLine";
				if(!player.isInZiplineArea)
					player thread ZiplineMove(end, start, line);
			}
		}
		wait .05;
	}
}
ZiplineMove(start, end, line)
{	
	self endon("disconnect");
	self endon("death");
	level endon("game_ended");
	
	self.isInZiplineArea = true;
	
	dis = Distance(start, end);
	time = (dis/800);
	acc = 0.3;
	
	if(self.lght == 1)
		time = (dis/1500);
	else
	{
		if(time > 2.1) acc = 1;
		if(time > 4) acc = 1.5;
	}
	
	if(time < 1.1)
		time = 1.1;

	for(j=0;j<60;j++)
	{	
		if(self UseButtonPressed())
		{	
			wait .5;
			
			if(self UseButtonPressed())
			{	
				if(line.used)
					break;
				
				line.used = true;
				self.isUsingZipline = true;
				self thread ZiplineOnDeath(line);
				if(isdefined(self.Platform))	self.Platform delete();
				org = (start + (0,0,35));
				des = (end + (0,0,40));
				playerAngles = VectorToAngles( des - org );
				self SetPlayerAngles(playerAngles);
				self setOrigin(org);
				self.Platform = spawn("script_origin", org);
				self linkto(self.Platform);
				self.Platform MoveTo( des, time, acc, acc );
				wait (time + 0.2);
				self playsound("weap_suitcase_drop_plr");
				self unlink();
				line.used = false;
				self.isUsingZipline = false;
				self notify("ZIPLINE_END");
				if(isdefined(self.Platform))	self.Platform delete(); 
				wait 1;
				break;
			}			
		}
		if(Distance(start, self.origin) > 70 && Distance(end, self.origin) > 70) break;
		wait .1;
	}
	self.isInZiplineArea = false;
}

createArea(position, angles, distance, elevation, style, width, height)
{
	if (!isDefined(height))
		height = width;
	
	Area = spawn("trigger_radius", position, 0, width, height);
	Area.angle = angles;
	Area.dist = distance;
	Area.elevation = elevation;
	Area.style = style;
	Area showOnMiniMap("hint_mantle");
	Area.fx = playLoopedFX(level.yellow_circle, 4, Area.origin);
	Area thread goToArea();
}
goToArea()
{
	level endon("game_ended");
	
	Area = self;
	
	wait 1;
	
	while(1)
	{
		self waittill("trigger", player);

		if(vectorDot(player.origin - Area.origin, anglesToForward(player.angles)) < 0 && !player.isClimbing && player getStance() == "stand")
		{
			a = player.angles[1] - Area.angle;
			
			if (a > 180)
				a -= 360;
			else if (a < -180)
				a += 360;

			forward = abs(a) <= 20;
			
			if((forward || abs(invertAngle(a)) <= 20))
			{
				if(player useButtonPressed())
					player thread climbToArea(Area, forward);
				else
					player.hint = "Press [{+reload}] to ^2Pass";
			}
		}
	}
}


climbToArea(Area, forward)
{
	self endon("disconnect");
	self endon("death");
	
	self.isClimbing = true;
	self setClientDvar("cg_thirdperson", 1);

	if (forward)
		ang = Area.angle;
	else
		ang = invertAngle(Area.angle);

	forward = undefined;

	self setPlayerAngles((self getPlayerAngles()[0], ang, 0));
	self freezeControls(true);
	
	Platform = spawn("script_model", self.origin);
	Platform setModel("tag_origin");
	self linkTo(Platform);
//#include maps\_anim;
	switch(Area.style)
	{
		case "climb": 
			len = getAnimLength(%pb_climbup);
			Platform moveTo(self.origin + (0, 0, Area.elevation), len);
			wait len;
			self setClientDvar("cg_thirdperson", 0);
			Platform moveTo(Area.origin + (0, 0, Area.elevation) + anglesToForward((0, ang, 0)) * Area.dist, 0.2);
			wait 0.2;
		break;
		case "high":
			len = getAnimLength(%mp_mantle_over_high) / 2;
			Platform moveTo(Area.origin + (0, 0, Area.elevation), len);
			wait len;
			Platform moveTo(Area.origin + anglesToForward((0, ang, 0)) * Area.dist, len);
			wait len;
		break;
		case "door":
			len = getAnimLength(%pb_stumble_forward) / 2;
			Platform moveTo(Area.origin + (0, 0, Area.elevation), len);
			wait len;
			Platform moveTo(Area.origin + anglesToForward((0, ang, 0)) * Area.dist, len);
			wait len;
		break;
	}
	
	self setClientDvar("cg_thirdperson", 0);
	self.isClimbing = false;
	self freezeControls(false);
	self unLink();
	Platform delete();
}
invertAngle(a)
{
	if (a > 0)
		return a - 180;
	else
		return a + 180;
}


CreateModel(position, angles, Mo)
{
	Model = spawn("script_model", position );
	Model setModel(Mo);
	Model.angles = angles;
}


createMapLimit(Z, Y, X, rePosition)
{	
	level endon("game_ended");
	
	a_style = 0; b_style = 0;
	
	if(isDefined(X))
	{ 
		a_style = 1; 
		if(X > 0) a_style = 2; 
	}
	
	if(isDefined(Y)) 
	{
		b_style = 1; 
		if(Y > 0) b_style = 2; 
	}
	
	if(X == 0) a_style = 0;
	if(Y == 0) b_style = 0;
	
	for(;;)
	{
		for(i=0;i<level.players.size;i++)
		{
			player = level.players[i];
			
			if(player.origin[2] < Z) player thread MapLimitEffect(rePosition);
			if(a_style == 2 && player.origin[0] > X) player thread MapLimitEffect(rePosition);
			if(a_style == 1 && player.origin[0] < X) player thread MapLimitEffect(rePosition);
			if(b_style == 2 && player.origin[1] > Y) player thread MapLimitEffect(rePosition);
			if(b_style == 1 && player.origin[1] < Y) player thread MapLimitEffect(rePosition);
			
			wait .05;
		}
		wait .5;
	}
}
MapLimitEffect(Position)
{	
	if(isDefined(Position)) 
		self SetOrigin(Position);
	else
		self suicide();
}




CreateAscensor(depart, arivee, angles, time, number)
{	
	level endon("game_ended");
	
	Ascmodel = spawn("script_model", depart);
	Ascmodel showOnMiniMap("hud_dpad_arrow");
	Ascmodel setModel("com_plasticcase_beige_big");
	Ascmodel.angles = angles;
	
	Asc = [];
	Asc[0] = spawn("script_model", (depart + (24, 8, 28)));
	Asc[1] = spawn("script_model", (depart + (24, -8, 28)));
	Asc[2] = spawn("script_model", (depart + (16, 0, 28)));
	Asc[3] = spawn("script_model", (depart + (8, 8, 28)));
	Asc[4] = spawn("script_model", (depart + (8, -8, 28)));
	Asc[5] = spawn("script_model", (depart + (0, 0, 28)));
	Asc[6] = spawn("script_model", (depart + (-8, 8, 28)));
	Asc[7] = spawn("script_model", (depart + (-8, -8, 28)));
	Asc[8] = spawn("script_model", (depart + (-16, 0, 28)));
	Asc[9] = spawn("script_model", (depart + (-24, 8, 28)));
	Asc[10] = spawn("script_model", (depart + (-24, -8, 28)));
	
	for(i=0;i<=10;i++)
	{	
		Asc[i].angles = (0,0,0);
		Asc[i] setContents(1);
		Asc[i] EnableLinkTo();
		Asc[i] LinkTo(Ascmodel);
	}

	wait .5;
	
	for(i=0;i<=10;i++)
	{
		Asc[i] Unlink();
		currentOrigin = Asc[i] GetOrigin();
		newOrigin = (arivee + (currentOrigin - depart));
		Asc[i] thread AscensorMove(currentOrigin, newOrigin, time);
	}
	
	Ascmodel thread AscensorMove(depart, arivee, time);
	
	while(1)
	{
		for(a=0;a<level.players.size;a++)
		{
			if(Distance(Ascmodel.origin, level.players[a].origin) < 50)
				level.players[a].isUsingAscensor[number] = true;
			else
				level.players[a].isUsingAscensor[number] = false;
		}
		wait .05;
	}
}
AscensorMove(depart, arivee, time)
{
	level endon("game_ended");
	
	while(1)
	{
		if(self.state == "open")
		{
			self MoveTo(depart, time);
			wait time*1.5;
			self.state = "close";
		}
		else if(self.state == "close")
		{
			self MoveTo(arivee, time);
			wait time*1.5;
			self.state = "open";
		}
	}
}


createTeleport(enter, exit, angles)
{
	level endon("game_ended");
	
	flag = spawn( "script_model", enter );
	flag setModel(level.elevator_model["enter"]);
	flag showOnMiniMap("compass_waypoint_panic");
	flag = spawn( "script_model", exit );
	flag setModel(level.elevator_model["exit"]);
	
	while(1)
	{
		for(i=0;i<level.players.size;i++)
		{
			if(Distance(enter, level.players[i].origin) <= 50)
			{
				level.players[i].isUsingTeleport = true;
				level.players[i] SetOrigin(exit);
				level.players[i] SetPlayerAngles(angles);
				wait .2;
				level.players[i].isUsingTeleport = false;
			}
		}
		wait .2;
	}
}

CreateSecuFlag(enter, exit, ray)
{
	level endon("game_ended");
	
	flag = spawn( "script_model", enter );
	
	while(1)
	{
		for(i=0;i<level.players.size;i++)
		{
			if(Distance(enter, level.players[i].origin) <= ray)
			{
				level.players[i].isUsingTeleport = true;
				level.players[i] SetOrigin(exit);
				level.players[i] iPrintlnBold("^1This area is prohibited !\n\n\n\n");
				wait .2;
				level.players[i].isUsingTeleport = false;
			}
		}
		wait .2;
	}
}



CreateSecretFlag(enter, exit, ray, angles, invisible)
{
	level endon("game_ended");
	
	flag = spawn( "script_model", enter );
	
	if(!isDefined(invisible))
		flag setModel( level.elevator_model["enter"] );
	
	Discovered = false;
	
	while(1)
	{
		for(i=0;i<level.players.size;i++)
		{
			if(Distance(enter, level.players[i].origin) <= ray)
			{
				level.players[i].isUsingTeleport = true;
				level.players[i] SetOrigin(exit);
				level.players[i] SetPlayerAngles(angles);
				
				if(!Discovered)
				{
					iPrintlnBold("^1"+ getName(level.players[i]) +" ^2Has Found a ^1Secret Flag!\n^2Find the other ones!\n\n\n");
					Discovered = true;
				}
				
				wait .2;
				level.players[i].isUsingTeleport = false;
			}
		}
		wait .2;
	}
}

CreatePortal(enter, exit, radius)
{
	level endon("game_ended");
	
	//CREATE FX HERE
	
	while(1)
	{
		for(i=0;i<level.players.size;i++)
		{
			if(Distance(enter, level.players[i].origin) <= radius)
			{
				level.players[i].isUsingTeleport = true;
				level.players[i] SetOrigin(exit);
				
				//playFX(level.fxex, exit);
				//level.players[i] playsound("mp_war_objective_lost");
				
				wait .2;
				level.players[i].isUsingTeleport = false;
			}
		}
		wait .25;
	}
}

CreateBlocks(position, angles)
{	
	block = spawn("script_model", position );
	block setModel ("com_plasticcase_beige_big");
	block.angles = angles;
	
	blockcol = [];
	blockcol[0] = spawn( "trigger_radius", position + (14, 0, 0), 0, 32, 32 );
	blockcol[1] = spawn( "trigger_radius", position + (-14, 0, 0), 0, 32, 32 );

	for(i = 0; i <= 2; i++)
	{	
		blockcol[i].angles = (0,0,0);
		blockcol[i] setContents(1);
		blockcol[i] EnableLinkTo();
		blockcol[i] LinkTo(block);
	}
}
CreateInvisibleBlock(position)
{	
	blockcol = [];
	blockcol[0] = spawn( "trigger_radius", position + (14, 0, 0), 0, 30, 60 );
	blockcol[1] = spawn( "trigger_radius", position + (-14, 0, 0), 0, 30, 60 );
	
	for(i = 0; i <= 2; i++)
	{
		blockcol[i].angles = (0,0,0);
		blockcol[i] setContents(1);
		blockcol[i] EnableLinkTo();
	}
}



CreateRamps(top, bottom)
{
	blockcol = [];
	D = Distance(top, bottom);
	blocks = roundup(D/30);
	
	
	CX = top[0] - bottom[0];
	CY = top[1] - bottom[1];
	CZ = top[2] - bottom[2];
	
	XA = CX/blocks;
	YA = CY/blocks;
	ZA = CZ/blocks;
	
	CXY = Distance((top[0], top[1], 0), (bottom[0], bottom[1], 0));
	Temp = VectorToAngles(top - bottom);
	BA = (Temp[2], Temp[1] + 90, Temp[0]);
	
	for(b=0;b<blocks;b++)
	{
		block = spawn("script_model", (bottom + ((XA, YA, ZA) * b)));
		block setModel("com_plasticcase_beige_big");
		block.angles = (0,0,0);
		
		blockcol[0] = spawn( "trigger_radius", ((bottom + ((XA, YA, ZA) * b)) + (14, 0, 0)), 0, 32, 32 );
		blockcol[1] = spawn( "trigger_radius", ((bottom + ((XA, YA, ZA) * b)) + (-14, 0, 0)), 0, 32, 32 );
		
		for(i = 0; i <= 2; i++)
		{	
			blockcol[i].angles = (0,0,0);
			blockcol[i] setContents(1);
			blockcol[i] EnableLinkTo();
			blockcol[i] LinkTo( block );
		}
		block.angles = BA;
		wait .05;
	}
	
	block = spawn("script_model", (bottom + ((XA, YA, ZA) * blocks) - (0, 0, 5)));
	block setModel("com_plasticcase_beige_big");
	block.angles = (0,0,0);
	
	blockcol[0] = spawn( "trigger_radius", ((bottom + ((XA, YA, ZA) * blocks) - (0, 0, 5)) + (14, 0, 0)), 0, 32, 32 );
	blockcol[1] = spawn( "trigger_radius", ((bottom + ((XA, YA, ZA) * blocks) - (0, 0, 5)) + (-14, 0, 0)), 0, 32, 32 );
	
	for(i=0;i<=2;i++)
	{	
		blockcol[i].angles = (0,0,0);
		blockcol[i] setContents(1);
		blockcol[i] EnableLinkTo();
		blockcol[i] LinkTo(block);
	}
	block.angles = (BA[0], BA[1], 0);
}



CreateInvisibleWall(start, end)
{	
	blockcol1 = [];
	blockcol2 = [];
	blockcol3 = [];
	
	D = Distance((start[0], start[1], 0), (end[0], end[1], 0));
	H = Distance((0, 0, start[2]), (0, 0, end[2]));
	
	blocks = roundup(D/55);
	height = roundup(H/30);
	
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
	
	for(h=0;h<height;h++)
	{
		blockcol1[0] = spawn( "trigger_radius", ((start + (TXA, TYA, 10) + ((0, 0, ZA) * h)) + (14, 0, 0)), 0, 32, 32 );
		blockcol1[1] = spawn( "trigger_radius", ((start + (TXA, TYA, 10) + ((0, 0, ZA) * h)) + (-14, 0, 0)), 0, 32, 32 );
		
		for(i=0;i<=2;i++)
		{	
			blockcol1[i].angles = (0,0,0);
			blockcol1[i] setContents( 1 );
		}
		
		wait .05;
		
		for(i=1;i<blocks;i++)
		{
			blockcol2[0] = spawn( "trigger_radius", ((start + ((XA, YA, 0) * i) + (0, 0, 10) + ((0, 0, ZA) * h)) + (14, 0, 0)), 0, 32, 32 );
			blockcol2[1] = spawn( "trigger_radius", ((start + ((XA, YA, 0) * i) + (0, 0, 10) + ((0, 0, ZA) * h)) + (-14, 0, 0)), 0, 32, 32 );
			for(j = 0; j <= 2; j++)
			{	blockcol2[j].angles = (0,0,0);
				blockcol2[j] setContents( 1 );	
			}
			
			wait 0.001;
		}
	
		blockcol3[0] = spawn( "trigger_radius", (((end[0], end[1], start[2]) + (TXA * -1, TYA * -1, 10) + ((0, 0, ZA) * h)) + (14, 0, 0)), 0, 32, 32 );
		blockcol3[1] = spawn( "trigger_radius", (((end[0], end[1], start[2]) + (TXA * -1, TYA * -1, 10) + ((0, 0, ZA) * h)) + (-14, 0, 0)), 0, 32, 32 );
		
		for(i=0;i<=2;i++)
		{	
			blockcol3[i].angles = (0,0,0);
			blockcol3[i] setContents(1);
		}
		wait .05;
	}
}
roundup(floatVal)
{
	if ( int( floatVal ) != floatVal )
		return int( floatVal+1 );
	else
		return int( floatVal );
}




iniMapEdit()
{	 
	
	if(game["allies"] == "marines")
		level.elevator_model["enter"] = "prop_flag_american";
	else
		level.elevator_model["enter"] = "prop_flag_brit";
	
	if (game["axis"] == "russian") 
		level.elevator_model["exit"] = "prop_flag_russian";
	else
		level.elevator_model["exit"] = "prop_flag_opfor";
		
	precacheModel(level.elevator_model["enter"]);
	precacheModel(level.elevator_model["exit"]);
	
	precacheModel("com_plasticcase_beige_big");
	precacheModel("vehicle_cobra_helicopter_d_piece07");
	PrecacheModel("weapon_parabolic_knife");
	precacheModel("com_pallet_2");
	
	//RIOT SHIELD
	PrecacheModel("perc_slieghtofhand");
	PrecacheModel("perc_juggernaut");
	PrecacheModel("perc_stoppingpower");
	PrecacheModel("perc_doubletap");
	
	
	level.smoke_trail_white = loadfx ("smoke/smoke_trail_white_heli");
	level.tanker_explosion = loadfx("explosions/tanker_explosion");
	level.aerial_explosion = loadfx ("explosions/aerial_explosion");
	level.yellow_circle = loadfx( "misc/ui_pickup_available" );
	level.red_circle = loadfx("misc/ui_pickup_unavailable");
	level.c4_light = loadfx( "misc/light_c4_blink" );
	level.claymore_laser = loadfx( "misc/claymore_laser" );
	level.jet_efx = loadfx("fire/jet_afterburner");
	level.flagBase_red = loadfx( "misc/ui_flagbase_red" );
	level.expbullt = loadfx("explosions/grenadeExp_concrete_1");
	level.flamez = loadfx("fire/tank_fire_engine");
	level.fxsmokes = loadfx ("smoke/smoke_trail_black_heli");
	 
	level.smoke_rpg_trail = loadfx("smoke/smoke_geotrail_rpg");
	level.aerial_explosion = loadfx ("explosions/aerial_explosion");
	
  
	precacheShader("field_radio");
	precacheShader("hint_mantle");
	precacheShader("hint_usable");
	precacheShader("objective_friendly_chat");
	precacheShader("hud_dpad_arrow");
	precacheShader("weapon_m4carbine");
	
	PrecacheShader("stance_stand");  
	PrecacheShader("killicondied"); 
	precacheShader("killiconmelee");
	PrecacheShader("dtimer_bg_border"); 
	PrecacheShader("death_helicopter"); 
	
	
	if(level.script == "mp_convoy")
	{
		precacheModel("me_corrugated_metal8x8");
		precacheModel("vehicle_bulldozer");
		precacheModel("me_transmitting_tower");
		precacheModel("com_ladder_wood");
		level AmbushMap();
	}
	if(level.script == "mp_backlot")
	{
		precacheModel("cobra_town_2story_house_01");
		precacheModel("com_steel_ladder");
		precacheModel("com_constructionrailingcornerbendout");
		precacheModel("me_market_umbrella_3");
		precacheModel("me_refrigerator2");
		precacheModel("ch_furniture_couch01");
		precacheModel("ch_russian_table");
		precacheModel("com_cellphone_on");
		precacheModel("cobra_town_2story_motel"); 
		precacheModel("vehicle_bmp_dsty_static"); 
		level BacklotMap();
	}
	if(level.script == "mp_bloc")
	{
		precacheModel("ch_ferriswheel_structure");
		precacheModel("ch_ferriswheel_gondola"); 
		precacheModel("ch_russian_ww2_monument_rightguy"); 
		level BlocMap();
	}
	if(level.script == "mp_bog")
	{
		precacheModel("vehicle_bus_destructable");
		precacheModel("vehicle_m1a1_abrams_dmg"); 
		precacheModel("vehicle_t72_tank_d_body_static"); 
		level BogMap();
	}
	if(level.script == "mp_countdown")
	{
		precacheModel("vehicle_tanker_truck");
		precacheModel("vehicle_tanker_truck_d");  
		precacheModel("com_barrier_tall1"); 
		precacheModel("com_powerline_tower"); 
		level CountdownMap();
	}
	if(level.script == "mp_crash")
	{
		precacheModel("me_mosque_tower02");
		precacheModel("vehicle_ch46e_damaged_front_piece");
		precacheModel("me_transmitting_tower");
		precacheModel("vehicle_ch46e_damaged_rear_piece");
		precacheModel("cobra_town_residential_6s");
		level CrashMap();
	}
	if(level.script == "mp_crossfire")
	{
		precacheModel("vehicle_bus_destructable");
		precacheModel("com_steel_ladder");
		level CrossfireMap();
	}
	if(level.script == "mp_citystreets")
	{
		precacheModel("vehicle_delivery_truck");
		precacheModel("com_mannequin1");
		precacheModel("me_market_umbrella_5");
		precacheModel("com_vending_can_new1_lit");
		precacheModel("ch_furniture_couch02");
		precacheModel("com_cafe_table2");
		precacheModel("me_mosque_tower02");
		level DistrictMap();
	}
	if(level.script == "mp_farm")
	{
		precacheModel("bc_military_comm_tower");	
		precacheModel("vehicle_tractor_plow"); 
		level DownpourMap();
	}
	if(level.script == "mp_overgrown")
	{
		precacheModel("com_powerline"); 
		level OvergrownMap();
	}
	if(level.script == "mp_pipeline")
	{
		level PipelineMap();
	}
	if(level.script == "mp_shipment")
	{
		level ShipmentMap();
	}
	if(level.script == "mp_showdown")
	{
		precacheModel("com_tower_crane");
		precacheModel("me_statue");
		precacheModel("me_construction_dumpster_open");
		precacheModel("com_trashchuteslide");
		level ShowdownMap();
	}
	if(level.script == "mp_strike")
	{
		level StrikeMap();
	}
	if(level.script == "mp_vacant")
	{
		precacheModel("com_vending_can_old2"); 
		precacheModel("com_coffee_machine");
		precacheModel("com_vending_can_old1");
		precacheModel("vehicle_semi_truck_cargo");
		precacheModel("vehicle_delivery_truck");
		precacheModel("ch_apartment_5story_noentry_01");
		precacheModel("ch_apartment_9story_noentry_02");
		level VacantMap();
	}
	if(level.script == "mp_cargoship")
	{
		level WetWorkMap();
	}
	if(level.script == "mp_broadcast") 
	{
		level BroadcastMap();
	}
	if(level.script == "mp_carentan")
	{
		level ChinatownMap();
	}
	if(level.script == "mp_creek")
	{
		level CreekMap();
	}
	if(level.script == "mp_killhouse")
	{
		level KillhouseMap();
	}

	wait 5;
	
	level notify("CREATED");

}


AmbushMap()
{
	rePosition = (-262,573,0);
	
	wait 8;
	CreateModel((-900,785,-150),( 0, 60, 0 ),"me_transmitting_tower");
	thread CreateSecretFlag((-1134,-886,80),(-900,800,210),70); //aller a la tour
	
	//Area 1
	CreateModel((3009,1735,-15),( 0, 90, 0 ),"me_corrugated_metal8x8"); //ANGLES=1er: incliner vers bas ou haut  2eme: tourner sur les cot?s 3eme: retourner a l'envers
	CreateInvisibleBlock((2985,1735,-15),( 0, 90, 0 ));
	CreateModel((3579,1150,-15),( 0, 90, 0 ),"me_corrugated_metal8x8");
	CreateModel((3579,1080,-15),( 0, 90, 0 ),"me_corrugated_metal8x8");
	CreateInvisibleBlock((4295,264,-58),( 0, 105, 0 ));CreateInvisibleBlock((4314,206,-58),( 0, 105, 0 ));CreateInvisibleBlock((4327,144,-58),( 0, 105, 0 ));CreateInvisibleBlock((4345,90,-58),( 0, 105, 0 ));CreateInvisibleBlock((4360,32,-58),( 0, 110, 0 ));CreateInvisibleBlock((4377,-4,-58),( 0, 110, 0 ));CreateInvisibleBlock((4295,264,-30),( 0, 105, 0 ));CreateInvisibleBlock((4314,206,-30),( 0, 105, 0 ));CreateInvisibleBlock((4327,144,-30),( 0, 105, 0 ));CreateInvisibleBlock((4345,90,-30),( 0, 105, 0 ));CreateInvisibleBlock((4360,32,-30),( 0, 110, 0 ));CreateInvisibleBlock((4377,-4,-30),( 0, 110, 0 )); wait 2;
	CreateInvisibleBlock((3380,592,170),( 0, 90, 0 ));CreateInvisibleBlock((3380,510,160),( 0, 90, 0 ));CreateInvisibleBlock((3450,580,110),( 0, 90, 0 ));CreateInvisibleBlock((3450,510,110),( 0, 90, 0 ));wait 5;CreateInvisibleWall((3579,1055,-100),(3579,1168,200));CreateInvisibleBlock((3701,246,100));CreateInvisibleBlock((3984,190,92),( 0, -170, 0 ));CreateInvisibleBlock((3879,257,92),( 0, 110, 0 ));
	CreateModel((4350,220,-50),( 0, -70, 10 ),"vehicle_bulldozer");
	CreateModel((4450,70,-49),( 6, -160, 0 ),"vehicle_bulldozer");
	thread createTeleport((3074,1383,-74),(-2413,681,-71),(0,3,0)); //retourner dans la map
	thread createTeleport((672,136,-60),(3071,-99,-71),(0,9,0)); //aller a area 1 
	
	//Area 2
	CreateBlocks((-3108,500,95),( 0, 0, 0 ));
	thread CreateZipline((-3162,869,73),(-3101,472,105));
	CreateInvisibleBlock((-3271,1168,121),( 0, 174, 0 ));CreateInvisibleBlock((-3374,1063,113),( 0, 269, 0 ));CreateInvisibleBlock((-3443,806,-64),( 0, 270, 0 ));
	wait 2;
	createArea((-3007, 290, 104), 90, 40, 0, "door", 16, 20); // 2= angle 3= distance 4= elevation 5=style 67= wh 
	createArea((-2635, 89,104), 0, 35, 30, "high", 16, 20); //sortir
	thread createWeaponBox((-2658, 297,104),(0,90,0));
	thread createTeleport((-3112,23,104),(677,486,-59),(0,-49,0)); // retourner dans la map
	thread createTeleport((-502,143,-66),(-3157,-718,-55),(0,95,0)); //Aller a area 2
	thread createTeleport((-2735,657,-71),(-3337,1136,72),(0,-52,0)); //pour aller a la rampe
	
	//Area 4
	createArea((-1296,-623, -65), 90, 50, 120, "climb", 16, 20); 
	CreateModel((-1296, -613, -65), (0, 90, 0),"com_ladder_wood");
	CreateModel((-1296, -635, -65), (0, 90, 0),"com_ladder_wood");
	CreateInvisibleBlock((-2318,-1175,125),( 0, 90, 0 ));CreateInvisibleBlock((-2318,-1220,125),( 0, 90, 0 ));CreateInvisibleBlock((-1392,-1220,100),( 0, 90, 0 ));CreateInvisibleBlock((-1392,-1220,130),( 0, 90, 0 ));CreateInvisibleBlock((-1392,-1150,100),( 0, 90, 0 ));CreateInvisibleBlock((-2318,-1175,125),( 0, 90, 0 ));CreateInvisibleBlock((-2318,-1195,125),( 0, 90, 0 ));
	thread CreateAscensor((-1537,-1157,-75),(-1537,-1157,55),(0,90,0),2,1);
	thread createMapLimit(-180,-1240,-3600,rePosition); //1=+haut -bas      2= +gauche -droite   3= +devant -derriere 
}




BacklotMap()
{
	rePosition = (712,-446,80);
	
	wait 8;
	CreateModel((-1297, -2300, 60), (0,0,0),"cobra_town_2story_motel");
	CreateModel((-1157, -2300, 60), (0,0,0),"cobra_town_2story_motel");
	CreateModel((-1271, -1574, 60), (0,0,0),"cobra_town_2story_house_01");
	
	//glitches/jumps
	CreateInvisibleBlock((-240,-820,350),( 0, 90, 0 ));
	CreateInvisibleBlock((630,-1038,385),( 0, 7, 0 ));
	CreateInvisibleBlock((327,232,297),( 0, 90, 0 ));
	CreateInvisibleBlock((327,232,320),( 0, 90, 0 ));
	CreateInvisibleBlock((487,1391,251),( 0, 0, 0 ));
	CreateInvisibleBlock((712,1491,196),( 0, 90, 0 ));
	CreateInvisibleBlock((1549,531,262),( 0, 90, 0 ));
	wait 2;
	thread createWeaponBox((160, -1345,290),(0,0,0));
	CreateModel((89, -1275,281), (0,227,20),"me_market_umbrella_3");
	CreateModel((163, -1260,303), (0,270,0),"ch_furniture_couch01");
	CreateModel((161, -1330,284), (0,0,0),"ch_russian_table");
	CreateModel((161, -1362,284), (0,0,0),"ch_russian_table");
	CreateModel((70, -1345,303), (0,0,0),"ch_furniture_couch01");
	CreateModel((136, -1328,320), (0,190,0),"com_laptop_2_open");
	wait 1;
	
	//Area 1
	createArea((-1146,1157, 64), 90, 60, 120, "climb", 25, 25); 
	CreateModel((-1146, 1150, 180), (0, -90, 0),"com_steel_ladder");
	CreateModel((-1146, 1168, 180), (0, 90, 0),"com_steel_ladder");
	CreateModel((-10, 2700, 54), (0, 0, 0),"cobra_town_2story_house_01");
	CreateModel((-520, 2680, 54), (0, 0, 0),"cobra_town_2story_house_01");
	wait 2;
	CreateInvisibleBlock((-790,2730,75),( 0, 90, 0 ));
	CreateInvisibleBlock((-790,2770,75),( 0, 90, 0 ));
	CreateInvisibleBlock((-790,2810,75),( 0, 90, 0 ));
	CreateInvisibleBlock((-790,2850,75),( 0, 90, 0 ));
	wait 2;
	CreateInvisibleBlock((-790,2890,80),( 0, 90, 0 ));
	CreateInvisibleBlock((-790,2740,110),( 0, 90, 0 ));
	CreateInvisibleBlock((-790,2810,110),( 0, 90, 0 ));
	CreateInvisibleBlock((-790,2880,115),( 0, 90, 0 ));
	thread CreateAscensor((-1250,1828,40),(-1250,1828,210),(0,90,0),3,1);
	CreateBlocks((-1210,1900,190),( 0, 90, 0 ));
	createMegaLine((-132,-2347,60), (-1419,2760,51),(-132,-2810,40), (-1612,-2810,40), (-1612,-1305,40), (-1454,-1305,40),(-1454,1085,70)); //start end 2 3 4 5 6
	CreateModel((-1500, 1090, 62), (0, 360, 0),"vehicle_bmp_dsty_static");
	CreateInvisibleBlock((-1600,1150,80),( 0, 0, 0 ));
	CreateInvisibleBlock((-1530,1150,75),( 0, 0, 0 ));
	CreateInvisibleBlock((-1450,1150,75),( 0, 0, 0 ));
	wait 2;
	CreateInvisibleBlock((-1370,1150,75),( 0, 0, 0 ));
	CreateInvisibleBlock((-1600,1150,110),( 0, 0, 0 ));
	CreateInvisibleBlock((-1530,1150,105),( 0, 0, 0 ));
	CreateInvisibleBlock((-1450,1150,105),( 0, 0, 0 ));
	CreateInvisibleBlock((-1370,1150,105),( 0, 0, 0 ));
	wait 5;
	
	//Area 2
	thread CreateAscensor((275,-1750,50),(275,-1743,275),(0,0,0),3,2);
	CreateBlocks((311,-1662,305),( 0, 90, 0 ));
	CreateInvisibleBlock((-354,-1450,245),( 0, 90, 0 ));
	CreateInvisibleBlock((-354,-1380,245),( 0, 90, 0 ));
	CreateInvisibleBlock((-354,-1310,245),( 0, 90, 0 ));
	CreateInvisibleBlock((-354,-1240,245),( 0, 90, 0 ));
	wait 2;
	CreateInvisibleBlock((-354,-1450,285),( 0, 90, 0 ));
	CreateInvisibleBlock((-354,-1380,285),( 0, 90, 0 ));
	CreateInvisibleBlock((-354,-1310,285),( 0, 90, 0 ));
	CreateInvisibleBlock((-354,-1240,285),( 0, 90, 0 ));
	CreateInvisibleBlock((682,-1457,369),( 0, 121, 0 ));
	CreateInvisibleBlock((707,-1519,369),( 0, 121, 0 ));
	CreateInvisibleBlock((740,-1573,369),( 0, 121, 0 ));
	CreateInvisibleBlock((646,-1408,369),( 0,121, 0 ));
	wait 2;
	CreateInvisibleBlock((682,-1457,410),( 0, 121, 0 ));
	CreateInvisibleBlock((707,-1519,410),( 0, 121, 0 ));
	CreateInvisibleBlock((740,-1573,410),( 0, 121, 0 ));
	CreateInvisibleBlock((646,-1408,410),( 0,121, 0 ));
	thread CreateSecretFlag((352,-1498,100),rePosition,70,(0,67,0)); //sortir du trou
	
	//Secret Flags
	thread CreateSecretFlag((-506,-2040,69),(-1034,975,171),70,(0,-92,0)); //pour aller sur le container
	thread createMapLimit(-180,0,0,rePosition);
}








BlocMap()
{
	wait 8;
	
	//Megaline & Asc pool
	thread CreateAscensor((-2458,-3950,153),(-2458,-3950,25),(0,90,0),2,1);
	createMegaLine((-2776,-5278,32), (3891,-6573,1),(-2815,-7281,264), (-2068,-7284,165), (-1544,-8261,807), (494,-8261,807),(2566,-6549,807)); //start end 2 3 4 5 6
	wait 2;
	
	//Area 3		 2eme roue
	CreateModel((-493, -8010,0),( 0, 180, 0 ),"ch_ferriswheel_structure");
	CreateModel((-570, -7507,330),( -15, 65, 12 ),"ch_ferriswheel_gondola");
	CreateModel((-1095, -7806,113),( -132, 65, -168 ),"ch_ferriswheel_gondola");
	CreateModel((107, -7898,114),( 100, 65, -163 ),"ch_ferriswheel_gondola");
	CreateModel((-427, -7690,15),( 0, 180, 0 ),"ch_russian_ww2_monument_rightguy");
	thread CreateSecretFlag((4239,-7564,24),(-685,-7743,39),70,(0,-168,0)); //secret flag aller a la roue
	thread createWeaponBox((-413, -7667,7),(0,180,0));
	createArea((-300,-6745, 25), 90, 30, 90, "high", 25, 25); 
	thread CreateSecretFlag((2066,-7473,-60),(437,-7198,656),70,(0,-164,0)); //secret flag on the building
	thread CreateAscensor((-1575,-7325,38),(-1575,-7325,120),(0,90,0),2,2);
	CreateInvisibleBlock((620,-7215,685),( 0, 90, 0 ));
	thread createTeleport((43, -7912,80),(147,-5532,56),(0,-28,0)); //quitter zone roue
	wait 2;
	
	//Area 1		 Escaliers/stairs
	CreateBlocks((1039,-6805,140),( 0, 0, 0 ));CreateBlocks((1039,-6835,150),( 0, 0, 0 ));CreateBlocks((1039,-6865,160),( 0, 0, 0 ));CreateBlocks((1039,-6895,180),( 0, 0, 0 ));
	thread CreateSecretFlag((1039,-6804,528),(-2661,-3896,256),70,(0,-88,0)); //secret flag aller sur le plongeoir
	wait 2;
	
	//Area 2 		Room + rpd
	//CreateLight((133, -7155,184),(0,90,0),(260, -7118,145),(-90,0,0),(260, -6992,145), (-90,0,0),(260, -7118,260),(90,0,0),(260, -6992,260),(90,0,0));
	//createArea((387,-6950, 144), 90, 25, 0, "door", 25, 25); 
	//weaponwall((230,-6958,196),(0,0,0),"weapon_rpd");
	//CreateDoors((306,-7100,148), (306,-7043,148), (90,0,0), 2, 2, 100, 90);
	//createTeleport((960,-7033,144),(1225,-7045,144),(0,0,0)); //2eme salle
	//CreateSecretFlag((1540,-7042,144),(1225,-6883,144),70,(0,0,0)); //sortie des salles
	wait 2;
	
	//Area 4		Autre batiment
	//createArea((1890,-4958, 148), 0, 40, 20, "high", 50, 50); 
	//CreateLight((1218, -4681,186),(0,0,0),(2009, -4932,150),(-90,0,0),(2013, -4611,150), (-90,0,0),(1734, -4611,150),(-90,0,0),(1359, -4611,150),(-90,0,0));
	//CreateDoors((1907,-4548,148), (1907,-4607,148), (90,0,0), 2, 2, 60, 90);
	//createTeleport((1558,-4445,148),(147,-5532,56),(0,89,0)); //Sortie des salles sur rocher
	wait 2;
	
	//Blocks bal 1 bal 2 bal 3
	//CreateInvisibleBlock((1881,-4419,195),( 0, 180, 0 ));CreateInvisibleBlock((1820,-4419,195),( 0, 180, 0 ));CreateInvisibleBlock((1760,-4419,195),( 0, 180, 0 ));
	//CreateInvisibleBlock((1700,-4419,195),( 0, 180, 0 ));CreateInvisibleBlock((1640,-4419,195),( 0, 180, 0 ));CreateInvisibleBlock((1580,-4419,195),( 0, 180, 0 ));CreateInvisibleBlock((1520,-4419,195),( 0, 180, 0 ));CreateInvisibleBlock((1460,-4419,195),( 0, 180, 0 ));CreateInvisibleBlock((1400,-4419,195),( 0, 180, 0 ));
	//CreateInvisibleBlock((1340,-4419,195),( 0, 180, 0 ));CreateInvisibleBlock((1280,-4419,195),( 0, 180, 0 ));CreateInvisibleBlock((1220,-4419,195),( 0, 180, 0 ));
	wait 2;
	
	//Area 5 swimming pool bal
	thread createTeleport((-2517,-4392,100),(-2139,-3869,220),(0,-88,0)); //Petit saut
	
	//Area 6 swimming pool int
	thread createTeleport((-2662,-4437,150),(-2024,-3913,220),(0,-74,0)); //Grand saut
	thread CreateSecretFlag((-1657,-5041,220),(-1566,-4368,188),70,(0,-62,0)); //sortie int
}






BogMap()
{	
	rePosition = (3436,1415,109);
	wait 8;
	
	//Area 4 Bridge
	thread createTeleport((5327,661,12),(5976,2370,334),(0,-76,0)); //Bridge
	ForceField((6060,1565,368),(5324,828,12),(0,12,0),100,100,20,100);
	CreateModel((5920,2640,334),( 0, 282, 0 ),"vehicle_bus_destructable");
	CreateModel((6254,1090,380),( 0, 270, -92 ),"vehicle_bus_destructable");
	CreateModel((6205,2130,334),( 0, 285, 0 ),"vehicle_m1a1_abrams_dmg");
	thread createTeleport((6218,1011,334),rePosition); //Partir
	
	//end of bridge
	CreateInvisibleBlock((6016,2435,350),( 0, 17, 0 ));CreateInvisibleBlock((5955,2423,350),( 0, 17, 0 ));CreateInvisibleBlock((5900,2405,350),( 0, 15, 0 ));CreateInvisibleBlock((6016,2435,380),( 0, 17, 0 ));CreateInvisibleBlock((5955,2423,380),( 0, 17, 0 ));CreateInvisibleBlock((5900,2405,380),( 0, 15, 0 ));CreateInvisibleBlock((5819,2346,370),( 0, 32, 0 ));CreateInvisibleBlock((5757,2312,370),( 0, 32, 0 ));CreateInvisibleBlock((5819,2346,390),( 0, 32, 0 ));CreateInvisibleBlock((5757,2312,390),( 0, 32, 0 ));CreateInvisibleBlock((5862,2373,360),( 0, 27, 0 ));CreateInvisibleBlock((5862,2373,390),( 0, 27, 0 ));
	
	//Mid bridge
	wait 2;
	CreateInvisibleBlock((6333,1330,350),( 0, 17, 0 ));CreateInvisibleBlock((6283,1309,350),( 0, 17, 0 ));CreateInvisibleBlock((6333,1330,380),( 0, 17, 0 ));CreateInvisibleBlock((6283,1309,380),( 0, 17, 0 ));
	
	//Start bridge
	wait 2;
	CreateInvisibleBlock((6222,967,350),( 0, 12, 0 ));CreateInvisibleBlock((6170,967,350),( 0, 12, 0 ));CreateInvisibleBlock((6222,967,390),( 0, 12, 0 ));CreateInvisibleBlock((6170,967,390),( 0, 12, 0 ));
	
	//Area 3 wall zip box
	createArea((3972, -30, -3), -80, 30, 0, "door", 40, 40);
	CreateZipline((2950,-766,367),(4309,-78,-3));
	thread createWeaponBox((3017, -1011,363),(0,19.5,0));
	thread CreateAscensor((2998,-582,341),(2998,-582,215),(0,19.5,0),2,1);
	thread CreateSecretFlag((3426,1440,-40),(2866,-518,466),70,(0,8,0)); //secret flag aller au dessus, box

	wait 2;

	thread createMapLimit(-100,-1070,-745,rePosition); //1 haut bas 2 gauche droite 3 derriere devant
}






CountdownMap()
{
	rePosition = (-42,-1779,40);
	CreateModel((549,1630,-23),( 0, 90, 0 ),"com_powerline_tower");
	wait 8;
	
	//Area 3
	createArea((-824, 3053, -23), 143, 35, 120, "high", 40, 40);
	thread CreateAscensor((-1077,3080,-50),(-1077,3080,285),(0,240,0),5,1);
	CreateZipline((-855,2839,310),(-252,2487,136));
	thread CreateSecuFlag((-720,3915,150),rePosition,730); //out of
	thread CreateSecuFlag((-2354,1899,-15),rePosition,30); //pres hangar
	thread CreateAscensor((366,2199,-50),(366,2199,60),(0,240,0),2,2);
	thread createTeleport((170,2306,83),(-16,2364,136)); 
	
	//Area 2 hangar
	CreateModel((1776,-140,-7),( 0, 90, 0 ),"com_barrier_tall1");CreateModel((1776,-20,-7),( 0, 90, 0 ),"com_barrier_tall1");
	CreateInvisibleBlock((1771,-170,-6),( 0, 90, 0 ));CreateInvisibleBlock((1771,-110,-6),( 0, 90, 0 ));CreateInvisibleBlock((1771,-50,-6),( 0, 90, 0 ));CreateInvisibleBlock((1771,10,-6),( 0, 90, 0 ));CreateInvisibleBlock((1771,-170,26),( 0, 90, 0 ));CreateInvisibleBlock((1771,-110,26),( 0, 90, 0 ));CreateInvisibleBlock((1771,-50,26),( 0, 90, 0 ));CreateInvisibleBlock((1771,10,26),( 0, 90, 0 ));
	CreateDoors((1938,161,5), (2008,161,5), (90,90,0), 2, 2, 20, 90);
	//CreateBlocks((1771,10,26),( 0, 90, 0 ));
	
	//Area 1
	CreateModel((7052,-2550,1123),( -10, 183, 85 ),"vehicle_tanker_truck_d");
	CreateModel((6029,-4871,1056),( 20, 112, 60 ),"vehicle_tanker_truck_d");
	CreateInvisibleBlock((6922,-2574,1084),( 0, 60, 0 ));CreateInvisibleBlock((6973,-2539,1087),( 0,  5, 0 ));CreateInvisibleBlock((7030,-2527,1078),( 0, -5, 0 ));CreateInvisibleBlock((7087,-2513,1065),( 0, -5, 0 ));CreateInvisibleBlock((7146,-2518,1054),( 0, -5, 0 ));CreateInvisibleBlock((7196,-2500,1048),( 0, 80, 0 ));CreateInvisibleBlock((7206,-2442,1045),( 0, 80, 0 ));wait 2;CreateInvisibleBlock((6922,-2574,1115),( 0, 60, 0 ));CreateInvisibleBlock((6973,-2539,1120),( 0,  5, 0 ));CreateInvisibleBlock((7030,-2527,1110),( 0, -5, 0 ));CreateInvisibleBlock((7087,-2513,1095),( 0, -5, 0 ));CreateInvisibleBlock((7146,-2518,1085),( 0, -5, 0 ));CreateInvisibleBlock((7196,-2500,1080),( 0, 80, 0 ));CreateInvisibleBlock((7206,-2442,1080),( 0, 80, 0 ));CreateInvisibleBlock((6922,-2574,1150),( 0, 60, 0 ));CreateInvisibleBlock((6973,-2539,1160),( 0,  5, 0 ));CreateInvisibleBlock((7030,-2527,1140),( 0, -5, 0 ));CreateInvisibleBlock((7087,-2513,1125),( 0, -5, 0 ));CreateInvisibleBlock((7146,-2518,1115),( 0, -5, 0 ));CreateInvisibleBlock((7196,-2500,1110),( 0, 80, 0 ));CreateInvisibleBlock((7206,-2442,1110),( 0, 80, 0 ));wait 2;
	CreateInvisibleBlock((6107,-4680,1036),( 0, 105, 0 ));CreateInvisibleBlock((6123,-4740,1039),( 0, 92, 0 ));CreateInvisibleBlock((6135,-4802,1048),( 0, 282, 0 ));CreateInvisibleBlock((6146,-4863,1050),( 0, 102, 0 ));CreateInvisibleBlock((6164,-4922,1054),( 0, 105, 0 ));CreateInvisibleBlock((6166,-4979,1053),( 0, 270, 0 ));wait 2;CreateInvisibleBlock((6107,-4680,1070),( 0, 105, 0 ));CreateInvisibleBlock((6123,-4740,1070),( 0, 92, 0 ));CreateInvisibleBlock((6135,-4802,1080),( 0, 282, 0 ));CreateInvisibleBlock((6146,-4863,1080),( 0, 102, 0 ));CreateInvisibleBlock((6164,-4922,1085),( 0, 105, 0 ));CreateInvisibleBlock((6166,-4979,1087),( 0, 270, 0 ));wait 2;CreateInvisibleBlock((6107,-4680,1100),( 0, 105, 0 ));CreateInvisibleBlock((6123,-4740,1100),( 0, 92, 0 ));CreateInvisibleBlock((6135,-4802,1110),( 0, 282, 0 ));CreateInvisibleBlock((6146,-4863,1110),( 0, 102, 0 ));CreateInvisibleBlock((6164,-4922,1115),( 0, 105, 0 ));CreateInvisibleBlock((6166,-4979,1117),( 0, 270, 0 ));
	thread CreateSecuFlag((5491,-3107,131),rePosition,1500); 
	thread createWeaponBox((6596,-4104,1106),(0,59,0));
	thread createTeleport((2051,-77,-6),(6786,-4231,1109),(0,145,0));  //Aller tour + box
	thread createTeleport((-1787,1615,-6),(2323,709,-7),(0,179,0)); //aller au hangar area 2
	createMegaLine((6929,-4316,1109), (9759,-5972,1493),(9015,-5555,1500)); //start end 2 
	thread createMapLimit(-150,9000,10200,rePosition);
}





CrashMap()
{
	wait 8;
	CreateModel((100,-1080,0),( 0,90, 0 ),"me_transmitting_tower");
	CreateModel((642,-612,434),( 12,14, 82 ),"vehicle_ch46e_damaged_front_piece");
	CreateModel((408,-749,410),( 5,21, -10 ),"vehicle_ch46e_damaged_rear_piece");
	CreateModel((2077,-1364,818),(0,0,0),"me_mosque_tower02");
	CreateModel((2077,-1705,818),(0,0,0),"me_mosque_tower02");
	
	//Glitches/jumps
	CreateInvisibleBlock((650,-843,343),( 0, 247, 0 ));CreateInvisibleBlock((650,-843,365),( 0, 247, 0 ));CreateInvisibleBlock((660,-740,392),( 0, 269, 0 ));
	
	//Area 1
	createArea((1420, -864, 71), 0, 30, 0, "door", 25, 20); 
	CreateDoors((1569,-665,207), (1569,-724,207), (90,180,0), 2, 2, 20, 90);
	thread CreateAscensor((1715,-869,320),(1715,-869,450),(0,90,0),2,1);
	thread createWeaponBox((1600,-873,343),(0,90,0));
	CreateDoors((1733,-631,360), (1733,-555,360), (180,0,0), 3, 2, 20, 120);
	createArea((1323, -1016, 343), 0, 180, 30, "high", 20, 20); 
	thread CreateSecretFlag((1509,442,128),(1820,-1000,207),70,(0,137,0)); //secret area 1
	
	//Area 2
	//CreateSecuFlag((-2240,-80,131),(230,-2032,141),1500); 
	//CreateInvisibleBlock((-770,-780,334),( 0, 90, 0 ));CreateInvisibleBlock((-770,-720,334),( 0, 90, 0 ));CreateInvisibleBlock((-770,-660,334),( 0, 90, 0 ));CreateInvisibleBlock((-770,-600,334),( 0, 90, 0 ));CreateInvisibleBlock((-770,-540,334),( 0, 90, 0 ));CreateInvisibleBlock((-770,-480,334),( 0, 90, 0 ));CreateInvisibleBlock((-770,-420,334),( 0, 90, 0 ));CreateInvisibleBlock((-770,-360,334),( 0, 90, 0 ));CreateInvisibleBlock((-770,-300,334),( 0, 90, 0 ));
	//thread CreateAscensor((-492,-13,400),(-492,-13,195),(0,0,0),3);
	//createTeleport((21,841,137),(-621,-1460,215),(0,87,0)); //chato do
	//createTeleport((-715,51,251),(230,-2032,141),(0,87,0)); //chato do partir
	
	//Area 3
	//CreateZipline((-919,1925,390),(-919,2141,526));
	//createTeleport((-933,1910,662),(725,1070,140),(0,-136,0));  //esc
	
	//Little area
	thread CreateSecretFlag((810,125,210),(1841,-1565,636),70,(0,112,0)); //grand Bal
	thread createTeleport((1830,-1310,636),(230,-2032,141),(0,87,0)); //partir
	
	//Little area 2
	thread CreateSecretFlag((-120,99,170),(796,-1573,244),70,(0,45,0)); //Bal
	thread createTeleport((1128,-1568,244),(-22,-906,136),(0,0,0)); //partir
}







CrossfireMap()
{	
	rePosition = (5671,-4218,5);
	wait 8;
	//Glitches/jumps
	CreateInvisibleBlock((6337,-4279,118),( 0, 182, 0 ));CreateInvisibleBlock((6251,-1286,235),( 0, 237, 0 ));CreateInvisibleBlock((5215,-789,208),( 0, 332, 0 ));CreateInvisibleBlock((5168,-764,208),( 0, 332, 0 ));
	
	//Area HnS
	createArea((3472, -4737, -135), 165, 62, 120, "climb", 25, 20); // Parking lot #1
	CreateModel((3483, -4735, 0), (0, -15, 0),"com_steel_ladder");
	CreateModel((3465, -4735, 0), (0, 165, 0),"com_steel_ladder");
	thread createTeleport((3171,-3173,-136),(5378,-2422,125),(0,55,0)); //partir bus
	thread createTeleport((3082,-3106,-135),(2630,-2488,30),(0,-15,0)); //go area 4
	thread CreateSecretFlag((4779,-5004,-137),(3117,-4137,-7),70,(0,155,0)); //bal
	thread CreateAscensor((3395,-4333,-160),(3395,-4333,-7),(0,240,0),2,1);//bal
	thread CreateSecretFlag((5328,-2492,-40),(2843,-3791,128),70,(0,89,0)); //bus au bal tout en haut
	
	//Area 2
	createArea((4200, -4880, 24), 165, 30, 0, "door", 25, 25); //en face du parking
	CreateDoors((4337,-4850,40), (4281,-4831,40), (90,75,0), 3, 1, 20, 120);
	thread createWeaponBox((4575, -4782,28),(0,75,0));
	
	//Area 3
	createArea((4611, -2062, 160), 152, 25, 0, "door", 25, 25); //petit salle pour drap secret
	thread CreateSecretFlag((4714,-2064,160),(3346,-4291,-137),70,(0,164,0)); //area hns
	
	//Area 4 out of
	thread createTeleport((5178,-822,24),(3537,-1900,12),(0,-124,0)); //area 4
	
	//thread CreateAscensor((2765,-2835,-60),(2765,-2835,130),(0,238,0),2,2);//bal
	thread CreateSecuFlag((4627,-5794,-159),(4242,-5235,-156),400); 
	CreateModel((4530,-5551,-148), (0, 22, 0),"vehicle_bus_destructable");
	thread createTeleport((2221,-3886,-91),(5378,-2422,125),(0,55,0)); //partir, go bus
	thread createMapLimit(-220,0,0,rePosition);
}







DistrictMap()
{
	//Area 1 HnS
	wait 8;
	CreateModel((5258,1710,270),( 0, 0, 0 ),"me_mosque_tower02");CreateModel((5258,1431,270),( 0, 0, 0 ),"me_mosque_tower02");CreateModel((5492,1487,270),( 0, 0, 0 ),"me_mosque_tower02");CreateModel((5480,1688,311),( 0, 345, 0 ),"com_mannequin1");CreateModel((5451,1577,268),( 0, 180, 0 ),"ch_furniture_couch02");CreateModel((5368,1509,268),( 0, 90, 0 ),"ch_furniture_couch02");CreateModel((5390,1577,255),( 0, 0, 0 ),"com_cafe_table2");CreateModel((5350,1577,255),( 0, 0, 0 ),"com_cafe_table2");CreateModel((5352,1775,270),( 0, 0, 0 ),"com_vending_can_new1_lit");CreateModel((5391,1448,252),( -15, 70, 0 ),"me_market_umbrella_5");
	wait 2;
	createArea((5085, 1440, 0), 90, 50, 48, "high", 40, 32);
	thread createTeleport((4241,1423,0),(1726,-397,-47),(0,-90,0)); //go pass
	thread createTeleport((1727,-665,-47),(5619,1526,0),(0,-90,0)); //pass here
	thread CreateSecretFlag((5215,-1232,40),(4307,1515,109),70,(0,90,0)); //sur le camion
	thread CreateSecretFlag((3408,-907,145),(5350,1560,272),70,(0,53,0)); //sur le toit fun
	thread CreateSecretFlag((5648,1879,0),(5308,-479,-47),70,(0,85,0)); //quitter le toit fun
	ForceField((5382,1565,288),(4919,1690,31),(0,300,0),140,140,20,100);
	thread createWeaponBox((4560, 2621,0),(0,0,0));
	
	//perks
	thread createPerkMachine((5375,1304,27),( 0, 0, 0 ),"specialty_rof","1",1,"^2Double tap ");
	thread createPerkMachine((2691,-608,-67),( 0, 0, 0 ),"specialty_bulletpenetration","2",2,"^2Deep impact ");
	thread createPerkMachine((5074,-2089,34),( 0, 0, 0 ),"specialty_longersprint","3",3,"^2Extreme conditioning ");
	wait 2;

	//Area 2 Derriere map
	createArea((6170, -1431, -7), 0, 55, 48, "high", 40, 40);
	createArea((6170, 1372, 0), 0, 55, 48, "high", 40, 40);
	thread CreateAscensor((7197,-615,130),(7197,-615,-26),( 0, 90, 0 ),2,1);
	thread createTeleport((6803,2366,-7),(3328,-1786,-95),(0,90,0));
	wait 2;
	
	//Area 3 Bat
	thread createTeleport((4228,-366,-127),(3549,552,0),(0,-85,0));
	CreateDoors((3480,383,0), (3545,383,0), (90,90,0), 2, 2, 20, 90);
	thread createTeleport((3577,-103,-87),(1726,-397,-47),(0,-88,0)); //go pass
	wait 2;
	
	//Area 4 Bat esc
	createMegaLine((4953,1255,20), (4945,1507,324),(4945,1520,188), (4593,1520,188), (4593,1165,188), (4945,1165,188)); //start end 2 3 4 5 6 7
	thread createMapLimit(-200,0,0,(2553,-1182,-85));
}





DownpourMap()
{	
	rePosition = (-41,2141,230);
	wait 8;
	
	//perk
	thread createPerkMachine((-1234,-1650,200),( 0, 0, 0 ),"specialty_rof","1",1,"^2Double tap ");
	
	//Area 1 serre
	createArea((700, -1508, 133), 0, 30, 0, "door", 25, 25);
	CreateDoors((1200,-1728,140), (1252,-1728,140), (90,-90,0), 1, 2, 20, 90);
	thread createTeleport((1429,-229,119),(2517,791,217),(0,142,0)); //go bomb defense
	createMegaLine((1877,-246,176), (-1236,2006,239),(2736,627,245), (2698,3246,246), (2010,5287,276), (-2656,5534,253),(-2664,4682,333)); //start end 2 3 4 5 6 7
	thread createWeaponBox((1680, -183,154),(0,-180,0));
	wait 2;//Area 2 bat & bat
	thread CreateAscensor((-511,-757,267),(-511,-757,396),( 0, 0, 0 ),2,1);
	CreateZipline((326,1055,385),(-131,-843,424));
	CreateModel((-287,-915,421),( 0, 0, 0 ),"bc_military_comm_tower");
	CreateModel((372,1590,401),( 10, 182, 15 ),"vehicle_tractor_plow");
	CreateInvisibleBlock((422,1510,383),( 0, 90, 0 ));CreateInvisibleBlock((422,1570,373),( 0, 90, 0 ));CreateInvisibleBlock((422,1626,346),( 0, 90, 0 ));CreateInvisibleBlock((396,1666,347),( 0, 140, 0 ));CreateInvisibleBlock((422,1570,403),( 0, 90, 0 ));CreateInvisibleBlock((422,1626,376),( 0, 90, 0 ));CreateInvisibleBlock((396,1666,377),( 0, 140, 0 ));
	
	//Area 3 //out of
	createArea((-823, 1972, 254), 0, 35, 80, "high", 25, 25);
	thread createTeleport((-344,-1643,138),(-1442,-2536,157),(0,-143,0));
	wait 2;
	
	//Flags
	thread createTeleport((-805,2218,239),(1247,3484,381),(0,10,0)); //petit bat spawn defense
	thread createTeleport((171,2490,216),(-1706,-922,160),(0,-82,0)); //go area 3
	
	//Secret flag
	thread CreateSecretFlag((287,-1110,128),(1498,917,526),70,(0,176,0)); //sur le toit
	thread createMapLimit(50,0,0,rePosition);
}





OvergrownMap()
{
	rePosition =(4197,-1415,-127);
	wait 8;
	
	//Area 1 house with easter egg	
	createArea((-1530, -2443, -169), 0, 30, 0, "door", 25, 25);
	CreateDoors((-1800,-2465,-98), (-1881,-2465,-98), (90,-90,0), 2, 2, 20, 90);
	thread createTeleport((-1892,-2306,-46),(-1872,-3565,21),(0,-71,0));
	thread CreateSecretFlag((-1906,-2593,-170),(-598,-1826,0),20,(0,52,0)); //go to bal
	
	//Area 2 attack spawn 1st house
	createArea((-1728, -4403, -116), 0, 30, 0, "door", 25, 25);
	thread CreateAscensor((-1900,-4663,-140),(-1900,-4663,105),( 0, 90, 0 ),3,1);
	
	//Area 3 attack spawn 2nd house
	createArea((-1645, -3634, -105), 0, 30, 0, "door", 25, 25);
	
	//Door for the spot
	createArea((-670, -3679, 28), 0, 30, 0, "door", 25, 25);	
	
	//Area 4 Champs
	thread createTeleport((1179,-906,-191),rePosition,(0,179,0)); //bridge to champs
	thread createWeaponBox((3773, -1415,-133),(0,-90,0));
	thread createTeleport((3342,-1415,-127),(1928,-236,-120),(0,-82,0)); //partir
	thread CreateSecuFlag((3855,-2634,-119),rePosition,600); 
	thread CreateSecuFlag((3186,-2335,-79),rePosition,340); 
	thread CreateSecuFlag((2777,-662,-73),rePosition,100); 
	CreateModel((3903, -1368,-140),( 0, 90, 0 ),"com_powerline");
	thread createMapLimit(-400,0,0,rePosition);
}



PipelineMap()
{	
	rePosition = (226,1663,-2);
	wait 8;
	
	//Area 1
	thread createTeleport((2053,1642,0),(3061,3614,113),(0,0,0));
	thread CreateSecretFlag((1489,1290,15),(2648,3505,320),20,(0,65,0)); //go on bridge
	
	//Area 2 super slide
	createArea((-1020, 2657, 0.125), 180, 20, 128, "high", 10, 10);
	thread createTeleport((-1312,2980,52),(-131,2924,328),(0,-37,0)); //go bat turret
	
	//Area 3 bat
	CreateBlocks((965,679,412),( 0, 90, 0 ));CreateBlocks((965,679,445),( 0, 90, 0 ));
	CreateDoors((719,1550,412), (719,1633,412), (90,0,0), 2, 1, 20, 90);
	thread createWeaponBox((844, 547,398),(0,0,0));
	thread createTeleport((749,1823,0),(1016,1445,302),(0,-117,0)); //2nd ladder
	
	//Area 4 bat 2
	CreateBlocks((-693,1283,208),( 0, 90, 0 ));CreateBlocks((-693,1283,243),( 0, 90, 0 )); CreateInvisibleBlock((-693,1334,243),( 0, 90, 0 ));CreateInvisibleBlock((-693,1334,275),( 0, 90, 0 ));CreateInvisibleBlock((-693,1283,275),( 0, 90, 0 ));
	CreateBlocks((-77,1963,216),( 0, 0, 0 )); //ladder
	ForceField((-630,1317,240),(-605,713,220),(0,320,0),80,80,20,100);
	CreateZipline((788,1061,398),(-75,958,208)); //bat 1 to 2
	
	//sous sol
	CreateBlocks((1201,2202,-75),( 0, 90, 0 )); //rond
	CreateBlocks((764,2719,-119),( 0, 0, 0 ));CreateBlocks((764,2719,-85),( 0, 0, 0 )); //end
	CreateBlocks((395,859,-119),( 0, 0, 0 ));CreateBlocks((395,859,-85),( 0, 0, 0 )); //mil
	CreateBlocks((-461,958,-119),( 0, 90, 0 )); CreateBlocks((-461,958,-85),( 0, 90, 0 ));//start
	thread createTeleport((-86,1278,208),(-398,958,-119),(0,0,0)); //go quit
	thread createTeleport((760,2670,-119),(-291,3869,1),(0,-90,0)); //quit
}




ShipmentMap()
{	
	rePosition = (-499,-460,196);
	thread createMapLimit(180,-1287,-4587,rePosition);
}



ShowdownMap()
{
	rePosition = (342,819,110);
	wait 8;
	CreateModel((-908,-1286,-530),( 0, 106, 0 ),"com_tower_crane");
	CreateModel((-179,2700,-700),( 0, 5, 0 ),"com_tower_crane");
	CreateModel((-1800,93,-1300),( 0, 127, 0 ),"com_tower_crane");
	CreateModel((-7,22,300),( 0, 317, 0 ),"me_statue");

	//Secret area van
	thread CreateSecretFlag((-645,456,88),(1200,1206,217),10,(0,-94,0)); //van 
	thread createTeleport((1207,-484,217),rePosition,(0,0,0));
	
	//Area 1 Echaff
	thread CreateAscensor((-490,-825,-9),(-490,-825,248),( 0, 0, 0 ),3,1);
	CreateZipline((-1093,-1128,273),(-523,-593,296));
	thread CreateAscensor((-1100,-1300,121),(-1100,-1300,248),( 0, 0, 0 ),2,2);
	
	//Area 2 construct trash
	
	//-787 212 16  -787 115 16
	
	 //thread CreateRamps((352,1205,275), (352,851,90));
	   
	   
	//CreateDoors((-491,1320,70), (-491,1320,10), (90,90,90), 7, 2, 20, 90);
	
	
	 CreateBlocks((-789,130,14),( 0, 90, 0 ));
	 CreateBlocks((-789,196,14),( 0, 90, 0 ));
	 CreateBlocks((-789,130,50),( 0, 90, 0 ));
	 CreateBlocks((-789,196,50),( 0, 90, 0 ));
	  CreateInvisibleBlock((-789,130,85),( 0, 90, 0 ));
	 CreateInvisibleBlock((-789,196,85),( 0, 90, 0 ));
	 CreateBlocks((-1074,-203,230),( 0, 0, 0 ));
	 createBlocks((-1013,-203,230),( 0, 0, 0 ));
	 CreateBlocks((-954,-203,230),( 0, 0, 0 ));
	 CreateBlocks((-895,-203,230),( 0, 0, 0 ));
	 CreateBlocks((-835,-203,230),( 0, 0, 0 ));
	 CreateInvisibleBlock((-1074,-203,260),( 0, 0, 0 ));
	 CreateInvisibleBlock((-1013,-203,260),( 0, 0, 0 ));
	 CreateInvisibleBlock((-954,-203,260),( 0, 0, 0 ));
	 CreateInvisibleBlock((-895,-203,260),( 0, 0, 0 ));
	 CreateInvisibleBlock((-835,-203,260),( 0, 0, 0 ));

	ForceField((-1072,360,33),(-956,718,14),(0,17,0),140,140,20,80);
	thread createWeaponBox((-1072, -121,16),(0,90,0));
	thread CreateAscensor((-875,-153,-10),(-875,-153,115),( 0, 90, 0 ),2,3);
	thread CreateSecretFlag((305,878,-20),(-442,1160,204),85,(0,-108,0)); //bal
	thread createTeleport((1066,-1407,16),(-1043,43,89),(0,62,0)); //go area 2
	thread createTeleport((-1072,512,16),(705,222,16),(0,-91,0)); //quit area 2
	
	//Area 3
	//CreateZipline((8,1882,-1),(216,1203,302));
	//CreateSecuFlag((526,1524,300),def,150); 
	thread createMapLimit(-180,-2170,0,rePosition);
}





StrikeMap()
{
	rePosition = (-315,-816,466);
	wait 8;
	thread createPerkMachine((-196,-566,62),( 0, 0, 0 ),"specialty_rof","1",1,"^2Double tap ");
	thread createPerkMachine((-1480,681,120),( 0, 0, 0 ),"specialty_bulletpenetration","2",2,"^2Deep impact ");
	thread createPerkMachine((-1476,1144,120),( 0, 0, 0 ),"specialty_longersprint","3",3,"^2Extreme conditioning ");
	
	//Area 1 bat central
	thread CreateAscensor((-298,585,-9),(-298,585,195),( 0, 90, 0 ),3,1);
	CreateZipline((-208,782,220),(-520,1272,223)); //1st zip
	CreateZipline((-380,1272,223),(-23,787,404)); //2nd zip
	CreateZipline((-900,1272,223),(-1405,1092,384)); //3rd zip
	thread createTeleport((1695,2386,16),(-640,1385,223),(0,-90,0)); //go to zipss
	thread createTeleport((1302,-1506,20),(-122,441,220),(0,104,0)); //go to zip 1
	
	//3rd zip
	thread CreateAscensor((-1425,662,360),(-1425,662,521),( 0, 0, 0 ),2,2);
	CreateBlocks((-1093,81,604),( 0, 180, 0 ));
	thread createTeleport((1695,2386,16),(-1543,625,384),(0,22,0)); //go to asc
	thread CreateSecretFlag((-2273,-1106,42),(-1353,75,547),10,(0,0,0)); //go to roof
	
	//Area 3
	thread createTeleport((-774,-777,24),(-774,-777,456),(0,0,0)); //go to roof
	wait 2;
	
	//Area 2 semi out of
	CreateZipline((908,-1569,384),(989,-1947,420));
	thread CreateSecretFlag((147,1423,28),(1182,-2022,556),10,(0,134,0)); //en haut
	thread createTeleport((-640,1343,24),(709,-1294,464),(0,-30,0)); //go box
	thread createWeaponBox((1375, -1472,384),(0,90,0));
}



MapLimites(map,rePosition)
{
	level endon("game_ended");
	
	switch(level.script)
	{
		case"mp_vacant":
		
		while(1)
		{
			for(i=0;i<level.players.size;i++)
			{
				if(level.players[i].origin[1] > 695 && level.players[i].origin[0] > 1411)
					level.players[i] setOrigin(rePosition);
				
				if(level.players[i].origin[1] < -1402)	
					level.players[i] setOrigin(rePosition);
					
			}
			wait .05;
		}
	}
}
VacantMap()
{	
	rePosition = (-907,1075,-110);
	wait 8;
	
	thread MapLimites(level.script,rePosition);

	//Area 1 in bat
	thread createTeleport((633,626,-47),(387,-784,126),(0,162,0)); //go area 2
	
	//Area 2 roof
	thread CreateAscensor((-698,-359,101),(-698,-359,183),( 0, 0, 0 ),2,1);
	
	//Area 3 out of map
	CreateModel((2464,-1800,200),( 0, 0, 0 ),"ch_apartment_5story_noentry_01");CreateModel((450,-1735,200),( 0, 180, 0 ),"ch_apartment_5story_noentry_01");CreateModel((-1552,-1735,200),( 0, 180, 0 ),"ch_apartment_5story_noentry_01");
	CreateModel((3020,-391,200),( 0, -90, 0 ),"ch_apartment_5story_noentry_01");CreateModel((3020,1620,200),( 0, -90, 0 ),"ch_apartment_5story_noentry_01");CreateModel((1810,2000,200),( 0, 0, 0 ),"ch_apartment_5story_noentry_01");CreateModel((2209,1200,470),( 0, 0, 0 ),"ch_apartment_9story_noentry_02");
	thread createWeaponBox((1711, -1086,-83),(0,90,0));
	createArea((1685, -150, -47), 0,40, 0, "door", 25, 25);
	thread createTeleport((-1627,956,-95),(2592,-179,-91),(0,-177,0)); //go area 3
	thread createTeleport((1760,585,-48),(2562,-1069,68),(0,90,0)); //go camion
	CreateZipline((2560,-863,68),(1561,-820,368)); //zip roof
	
	//Area 4 toilette room
	//createArea((451, -30, -47), 90,35, 0, "door", 25, 25);
	//createTeleport((453,-213,-47),(1348,971,178),(0,-177,0)); //rpg jump
	//CreateSecretFlag((364,-305,-67),(-1126,1784,32),30,(0,-151,0)); //room citerne
	//createTeleport((-1712,1788,32),(-577,-922,-58),(0,-174,0)); //quitter room

	thread createMapLimit(-220,0,0,rePosition);
}




WetWorkMap()
{	
}
BroadcastMap()
{
}
ChinatownMap()
{
}
CreekMap()
{
}
KillhouseMap()
{
}
