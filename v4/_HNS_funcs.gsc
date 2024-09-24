#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include maps\mp\gametypes\_general_funcs;



Add_attachment(MO,DEL,POS,ANG)
{
	if(DEL == "NEW_MODEL" && isDefined(self.Model_attach))
	{
		for(i=0;i<self.Model_attach.size;i++)
		self.Model_attach[i] delete();
		
		//iprintln(self.Model_attach.size);
		
	}
	else if(!isDefined(self.Model_attach[MO]) && MO != "")
	{
		self.Model_attach[MO] = spawn("script_model", self.bmodel.origin + POS);
		self.Model_attach[MO] setModel(MO);
		self.Model_attach[MO].angles = ANG;
		self.Model_attach[MO] linkto(self.bmodel);
		self iprintln("^2Attachment added");
	}
	else if(isDefined(self.Model_attach[MO]))
	{
		self.Model_attach[MO] delete();
		self iprintln("^1Attachment deleted");
	}
}

Add_FX_to_the_Model(MO,DEL,POS)
{
	if(DEL == "NEW_MODEL" && isDefined(self.Model_fx)) self.Model_fx.size delete();	
	
	else if(DEL == "DEL" && isDefined(self.Model_fx[MO])) 
	{
		self.Model_fx[MO] delete();	
		self iprintln("^1Effect deleted");
	}
	else if(MO != "" && DEL == "")
	{
		if(isDefined(self.Model_fx[MO])) {self iprintln("^1Option already added"); return;}
		
		//self iprintln("^2Effect added");
		self iprintln("^1Effect not available");
		
		
		/*
		while(1)
		{
			self.Model_fx[MO] = spawnFX(level.AIO_fx[14], self.origin + POS);
			TriggerFX(self.Model_fx[MO]);
			wait .3;
			self.Model_fx[MO] delete();	
		}
		*/
		
		
		//playfxontag( level.AIO_fx[14], self + (0,0,100), "tag_origin" );
	
		//self.Model_fx[MO] LinkTo(self.bmodel);
		
		//self.Model_attach[0] linkto(self.bmodel);
		
		//PlayFXOnTag(, self.Model_test, "script_model");
		
	}
}
LevelRequired(model)
{
	if(self.HNS_Prestige > 0)
		return 0;
	
		
	switch(level.Map_models_dev_[level.script][model])
	{
		case "me_corrugated_metal8x8": return 5;
		case "me_corrugated_metal4x8": return 15;
		
		case "com_cafe_chair2": return 45;
		case "com_cafe_chair": return 45;
		case "com_folding_chair": return 35;
		case "com_plainchair": return 20;
		case "com_restaurantchair_2": return 40;
		
		case "ch_crate24x24": return 17;
		case "ch_crate32x48": return 15;
		case "me_woodcrateclosed": return 20;
		case "me_wood_cage_large": return 54;
		case "me_wood_cage_small": return 54;
		
		case "com_woodlog_16_192_d": return 32;
		case "com_woodlog_24_96_d": return 29;
		case "foliage_dead_pine_sm": return 24;
		case "foliage_red_pine_sm": return 32;
		case "foliage_red_pine_stump_sm": return 31;
		case "foliage_tree_destroyed_fallen_log_a": return 41;
		case "foliage_tree_river_birch_xl_a": return 36;
		
		case "com_tv1": return 18;
		case "com_tv2": return 16;
		case "com_tv2_d": return 38;
		case "com_computer_case": return 43;
		
		case "ch_mattress_2": return 50;
		case "ch_mattress_3": return 50;
		case "ch_mattress_boxspring": return 41;
		
		case "com_mannequin1": return 8;
		case "com_mannequin3": return 12;
		
		case "com_filecabinetblackopen": return 14;
		case "com_filecabinetblackclosed": return 14;
		
		//qcase"vehicle_bus_destructable": if(self.HNS_Rank < 20) return 20;
		//case"vehicle_delivery_truck": if(self.HNS_Rank < 20) return 20;
		
		case "ch_street_light_01_off": return 49;
		case "com_signal_light_pole": return 46;
		
		case "com_pallet_2": return 32;
		case "com_bike": return 19;
		case "com_barrier_tall1": return 13;
		case "ch_radiator01": return 48;
		case "com_plasticcase_green_rifle": return 53;
		case "me_satellitedish": return 9;
		case "me_mosque_tower02": return 4;
		case "com_cafe_table2": return 15;
		case "com_barrel_benzin": return 16;
		case "me_gas_pump":  return 11;
		case "com_wheelbarrow": return 10;
		//case"com_wall_fan": if(self.HNS_Rank < 20) return 20;
		//qcase"ch_wood_fence_128": if(self.HNS_Rank < 20) return 20;
		//case"ch_post_fence_128": if(self.HNS_Rank < 20) return 20;
		case "com_propane_tank02": return 7;
		//case"com_tower_crane": if(self.HNS_Rank < 20) return 20;
		case "com_cinderblockstack": return 34;
		
		
		default: return 0;
		
		
	}	
} 
 	 


SetModelz(model)
{
	self endon("disconnect");
	
	ModelCalled = self LevelRequired(model);
	
	if(self.HNS_Prestige == 0 && self.HNS_Rank < ModelCalled)
	{
		self iprintln("^1You must be level "+ModelCalled+" to use this model !");
		return;
	}
	
	
	self.curModel = model;	
	self.showmodel = level.Map_models_dev_[level.script][model];
	self freshModel();
	
	wait .1;
	
	x = self getCurs();
	
	//if(isDefined(level.HasOption[level.Map_models_dev_[level.script][self.curModel]]) && level.HasOption[level.Map_models_dev_[level.script][self.curModel]])
		//self thread NewMenu("MO");
	//else
		self thread NewMenu("main");
	
	self revalueCurs(x);
}


initializeMenuOpts()
{
	if(self.team == "allies")
	{
		//if(isDefined(level.HasOption[level.Map_models_dev_[level.script][self.curModel]]) && level.HasOption[level.Map_models_dev_[level.script][self.curModel]])
		//{
			//m = "main";
			//self addMenu(m,"Advanced Menu");
			//self addOpt(m,self.Lang["HNS"]["MODELS_MM"],::newmenu,"MO");
			//self addOpt(m,self.Lang["HNS"]["ADVANCED_OPTION_MM"],::newmenu,"AO");
			
			//self initializeADVOpts();
			
			//self addMenu("MO",self.Lang["HNS"]["MODEL_MENU_MM"],"main");
			
			//m = "MO";
		//}
		//else
		//{
			self addMenu("main",self.Lang["HNS"]["MODEL_MENU_MM"]);
			m = "main";
		//}
		
		for(i=0;i < level.Map_models_dev_[level.script].size;i++) self addOpt(m,self.Lang["HNS"]["MODEL_NAME"][level.script][i],::SetModelz,i);	
	}
	else if(self.team == "axis")
	{
		m = "main";
		self addMenu(m,"Unlocked Content");
		
		self addOpt(m,"Weapons",::newmenu,"Weapon");
		
		m = "Weapon";
		self addMenu(m,"Weapons unlocked","main");
		
		
		if(self.HNS_Prestige >= 1) 
			self addOpt(m,"M40A3",::HNS_GiveWeapon,"m40a3_mp");
		else
			self addOpt(m,"M40A3",::AvailableAt,"prestige 1");
			
		if(self.HNS_Prestige >= 4) 
			self addOpt(m,"W1000",::HNS_GiveWeapon,"winchester1200_mp");
		else
			self addOpt(m,"W1000",::AvailableAt,"prestige 4");
		
		if(self.HNS_Prestige >= 10) 
			self addOpt(m,"Dragunov",::HNS_GiveWeapon,"dragunov_mp");
		else
			self addOpt(m,"Dragunov",::AvailableAt,"prestige 10");	
			
		if(self getstat(3366) == 77)
			self addOpt(m,"M1014",::HNS_GiveWeapon,"m1014_mp");
		else
			self addOpt(m,"M1014",::Mustdoo,"Secret challenge!");	
			
	}
}

Mustdoo(niveau)
{
	self iprintln("^1You must do the "+niveau);
}
AvailableAt(niveau)
{
	self iprintln("^1You must be "+niveau);
}

HNS_GiveWeapon(weapon)
{
	self takeallweapons();
	
	
	if(weapon == "m1014_mp")
		self giveweapon(weapon,6);
	else
		self giveweapon(weapon,self.HNS_camo);
	
		self switchtoweapon(weapon);
	
}
initializeADVOpts()
{
	m = "AO";
	self addMenu(m,self.Lang["HNS"]["ADVANCED_OPTION_MM"],"main");

	if(level.Map_models_dev_[level.script][self.curModel] == "com_barrel_fire")
	{
		self addOpt(m,"Add flames",::Add_FX_to_the_Model,"com_barrel_fire","",(0,0,40));
		self addOpt(m,"Remove flames",::Add_FX_to_the_Model,"com_barrel_fire","DEL");
	}
	
	if(level.Map_models_dev_[level.script][self.curModel] == "com_stove")
	{
		//self addOpt(m,"com_pan_copper",::Add_attachment,"com_pan_copper","",(8,4,40),(20,30,20));	
	}
}

Custom_Model()
{
	
	self endon("disconnect");
	
	self.curModel = 0;
	self.Next_Model = 0;
	self.Prev_Model = 0;
	
	self.bmodel = spawn("script_model", self.origin);
	self.bmodel hide();
	self.bmodel showToPlayer(self);
	self.showmodel = level.Map_models_dev_[level.script][0]; 
	self freshModel();
	
	//self detachall();
	//self setModel("tag_origin");
	
	
	// Attachments
	for (i = 0; i < self.models.size; i++)
	{
		//self.models[i] show();
		//self.models[i] setCanDamage(true);
		//self.models[i] thread damageModel(self);
	}

	//if (isDefined(self.effect))
		//self.effect show();

	
	
	self.bmodel thread Damage_Model(self);
	//self thread Player_Model();
}

freshModel(restore)
{
	self endon("disconnect");
	
	if (isDefined(self.bmodel))
	{
		self notify("freshmodel");
		
		self Add_FX_to_the_Model("","NEW_MODEL");
		self Add_attachment("","NEW_MODEL");
		
		self restoreAttachments(restore);

		if(!self.Seeker_Camouflage)
		{
			// Remove light
			//if (isDefined(self.light))
				//self.light delete();

			//self detachAll();
			//self setModel("tag_origin");
			
			self.bmodel.xangle = 0;
			self.bmodel unLink();
			self.bmodel setModel(self.showmodel);
			self.bmodel.angles = self.angles;
			self optimizeOrigin(self.bmodel, self.showmodel);
		
			/*
			switch (self.showmodel)
			{
				case "me_gas_pump":
				case "me_corrugated_metal8x8":
				case "ch_dinercounterchair":
				case "me_concrete_barrier":
				case "com_cafe_chair":
				case "com_cafe_chair2":
				case "cargocontainer_20ft_red":
				//case "cargocontainer_20ft_white":
				case "ch_bedframemetal_gray":
				case "ch_bedframemetal_dark":
				case "ch_lawnmower":
				case "ch_mattress_2":
				case "ch_mattress_3":
				case "com_plasticcase_beige_big":
				case "com_barrier_tall1":
				case "vehicle_delivery_truck":
				case "com_bench":
				case "me_construction_dumpster_open":
				case "me_ac_window":
				case "me_telegraphpole":
				case "snowman":
				case "mil_bunker_bed1":
				case "mil_bunker_bed2":
				case "mil_bunker_bed3":
				case "com_mannequin3":
				case "com_northafrica_armoire_short":
				 
				case "me_market_stand1":
				case "com_office_chair_black":
				case "com_industrialtrashbin":
				case "com_server_rack_sid":
					self.bmodel.angles += (0, 90, 0);
				break;

				case "me_sign_stop":
				case "me_sign_noentry":
				case "ch_sign_noentry":
				case "ch_sign_nopedestrians":
				case "ch_sign_noparking":
				case "ch_sign_stopsign":
				case "ch_washer_01":
				case "com_water_heater":
				case "com_bookshelveswide":
				case "com_stove":
				case "com_stove_d":
				case "ch_gas_pump":
				case "ch_baby_carriage":
		 
				case "ct_statue_chinese_lion":
				case "ct_statue_chinese_lion_gold":
				case "cs_monitor1":
				case "me_market_stand4":
				case "com_restaurantchair_2":
				case "cs_steeringwheel":
					self.bmodel.angles += (0, 270, 0);
				break;

				case "com_bike":
				case "com_dresser":
				case "com_dresser_d":
				case "me_dumpster":
				case "me_dumpster_close":
				case "com_filecabinetblackclosed":
				case "ch_furniture_teachers_desk1":
				case "com_armoire_d":
				case "bathroom_toilet":
				case "com_shopping_cart":
					self.bmodel.angles += (0, 180, 0);
				break;
				case "com_rowboat":
					self.bmodel.angles += (0, 270, 180);
					self.bmodel.xangle = 180;
				break;
				case "com_steel_ladder":
					self.bmodel.angles += (0, 180, 180);
					self.bmodel.xangle = 180;
				break;
			}*/
			self.bmodel linkTo(self);

			// Save the current model for fast-reloading
			//self.saveModel = self.showmodel;	 
		}
		else
		{
			self.bmodel setModel(self.showmodel);
		}
	}
}


fixModel()
{
	self endon("disconnect");
	
	while(self.Model_fixed)
	{
		self.bmodel unLink();
		self optimizeOrigin(self.bmodel, self.showmodel);
		self.bmodel linkTo(self);
		wait .05;
	}
}


rotateModel()
{
	level endon("game_ended");
	self endon("disconnect");
	self endon("spawn"); // joined_team
	
	while (true)
	{
		wait 0.05;
		
		if (self meleeButtonPressed())
		{
			time = 0;
		 
			{
				self.Model_fixed = false;
				
			switch (self.rotateType)
			{
				case "X" : self.rotateType = "-X"; break;
				case "-X" : self.rotateType = "Y"; break;
				case "Y" : self.rotateType = "-Y"; break;
				case "-Y" : self.rotateType = "Z"; break;
				case "Z" : self.rotateType = "-Z"; break;
				case "-Z" : self.rotateType = "X"; break;
			}
				 
			}
			while (self meleeButtonPressed())
			{
				wait 0.05;
			}
		}
		
		else if (self fragButtonPressed())
		{
			self.Model_fixed = false;
			self.bmodel unLink();

			// Check angle limitation defined in the config file
			//m = getDvarInt("scr_hns_maxangle_" + self.showmodel);
			m = 20;
			 
			if (m > 0 && m <= 180 && !(m % 5))
			{
				degrees = m;
			}
			else
			{
				// Default rotation angle
				degrees = 20;
 

				// Global limitations
				switch (self.showmodel)
				{
					case "ch_mattress_2":
					case "ch_mattress_3":
					case "com_restaurantstainlessteelshelf_01":
					case "com_restaurantstainlessteelshelf_02":
					case "ch_bedframemetal_gray":
					case "ch_bedframemetal_dark":
					case "com_restaurantsink_1comp":
					case "com_restaurantsink_2comps":
					case "com_folding_table":
					case "me_telegraphpole":
					case "me_telegraphpole2":
					case "com_powerpole1":
					case "com_powerpole3":
					case "me_streetlight":
					case "me_streetlight_on":
					case "me_streetlightdual":
					case "com_cafe_chair":
					case "com_cafe_chair2":
					case "com_restaurantkitchentable_1":
					case "me_market_umbrella_3":
					case "me_market_umbrella_5":
					case "me_market_umbrella_6":
					case "com_ladder_wood":
					case "mil_bunker_bed1":
					case "com_steel_ladder":
					case "com_water_tank1":
					case "me_antenna":
					case "me_antenna2":
					case "me_antenna3":
					case "me_sign_stop":
					case "me_sign_noentry":
					case "ch_sign_noentry":
					case "ch_sign_nopedestrians":
					case "ch_sign_noparking":
					case "ch_sign_stopsign":
					case "com_newspaperbox_blue":
					case "com_newspaperbox_red":
					case "com_basketball_goal":
					case "mil_razorwire_long_static":
						degrees = 5;
					break;
					case "com_cafe_table1":
					case "com_cafe_table2":
						degrees = 10;
					break;
					case "com_barrel_white_rust":
					case "com_barrel_blue_rust":
					case "com_barrel_black_rust":
					case "com_barrel_fire":
					case "com_barrel_green_dirt":
					case "com_barrel_biohazard_rust":
					case "com_barrel_green":
					case "com_barrel_tan_rust":
					case "me_corrugated_metal8x8":
						degrees = 30;
					break;
				}
			}

			switch (self.rotateType)
			{
				case "X":
					if (self getXDegrees() < degrees)
					{
						self.bmodel.angles += (0, 0, 5);
					}
				break;
				case "-X":
					if (self getXDegrees() > -1 * degrees)
					{
						self.bmodel.angles -= (0, 0, 5);
					}
				break;
				case "Y":
					newY = getRealY(self.bmodel.angles[0]);
					if (newY < degrees)
					{
						self.bmodel.angles = (newY + 5, self.bmodel.angles[1], self.bmodel.angles[2]);
					}
				break;
				case "-Y":
					newY = getRealY(self.bmodel.angles[0]);
					if (newY > -1 * degrees)
					{
						self.bmodel.angles = (newY - 5, self.bmodel.angles[1], self.bmodel.angles[2]);
					}
				break;
				case "Z":
					self.bmodel.angles += (0, 10, 0);
				break;
				case "-Z":
					self.bmodel.angles -= (0, 10, 0);
				break;
			}

			self optimizeOrigin(self.bmodel, self.showmodel);
			self.bmodel linkTo(self);
		}
		 
	}
}


Hider_Button_Monitor()
{
	self endon("disconnect");
	self endon("stop_hider_funcs");
	level endon("game_ended");
	
	while(1)
	{
		if(self attackbuttonpressed() && !isDefined(self.Model_Menu["inMenu"]) && !self.IN_MENU["AIO"] && !self.IN_MENU["LANG"]  && !self.IN_MENU["RANK"] && !self.IN_MENU["AREA_EDITOR"])
		{
			self notify("toggle_range");
			wait .2;
		}
		else if(self adsbuttonpressed() && !isDefined(self.Model_Menu["inMenu"]) && !self.IN_MENU["AIO"] && !self.IN_MENU["LANG"]  && !self.IN_MENU["RANK"] && !self.IN_MENU["AREA_EDITOR"])
		{
			if(level.HNS_models_loaded)
			{
				if(!self.Seeker_Camouflage)
				{
					self.Seeker_Camouflage = true;
					self Player_Model();
					self show();
					self.showmodel = "tag_origin";
					self freshModel();
					self thread AdvancedGiveWeapon("remington700_mp",0,0,1);
					self iprintln(self.Lang["HNS"]["SEEKER_CAMO_ON"]);
				}
				else
				{
					self.Seeker_Camouflage = false;
					
					//self detachall();
					//self setModel("tag_origin");
					
					self hide();
					self.showmodel = level.Map_models_dev_[level.script][self.curModel];
					self freshModel();
					self thread AdvancedGiveWeapon("deserteagle_mp",0,0,1);
					self iprintln(self.Lang["HNS"]["SEEKER_CAMO_OFF"]);
				}
			}
			wait .5;
		}
		else if(self usebuttonpressed() && !isDefined(self.Model_Menu["inMenu"]) && !self.IN_MENU["AIO"] && !self.IN_MENU["LANG"]  && !self.IN_MENU["RANK"] && !self.IN_MENU["AREA_EDITOR"])
		{
			if(!self.Model_fixed)
			{
				self.Model_fixed = true;
				self thread fixModel();
			}
			else self.Model_fixed = false;
			
			wait .5;
		}

		else if(self meleebuttonpressed() && !isDefined(self.Model_Menu["inMenu"]) && !self.IN_MENU["AIO"] && !self.IN_MENU["LANG"]  && !self.IN_MENU["RANK"] && !self.IN_MENU["AREA_EDITOR"])
		{
			i = 0;
			while(self meleeButtonPressed() && i < 2)
			{
				wait .05;
				i += .09;
			}
			
			if(i > 1)
			{ 
				self.bmodel unLink();
				self.bmodel.angles = (0,0,0);
				self freshModel();
				self.bmodel linkTo(self);
				self iprintln(self.Lang["HNS"]["ANGLE_RESTORED"]);
			}
			wait 1;
		}
		wait .05;	
	}
}
FixThisshit()
{
	if(isDefined(self.HNS_HUD_["INFO"]))
	{
		self thread QuandTuMeurs(1);
		self notify("stop_hider_funcs");
	}
	
}
QuandTuMeurs(option)
{
	self endon("disconnect");
	
	if(!isDefined(option)) 
	{
		while(level.HNS_game_state != "playing") wait 1;
		
		self waittill("death");
		
		playFX(level.AIO_fx[21],self.origin);
	}
	
	self.is_Seeker = true;
	
	self.Seeker_Camouflage = false;
		
	if(isDefined(self.Model_Menu["inMenu"])) self exitMenu();
	if(isDefined(self.menu["ui"]["menuDisp"][0])) for(m = 0; m < self.menu["ui"]["menuDisp"].size; m++) self.menu["ui"]["menuDisp"][m] AdvancedDestroy(self);
	if(isDefined(self.menu["ui"]["title"])) self.menu["ui"]["title"] AdvancedDestroy(self);
	if(isDefined(self.HNS_HUD_["ROTATION"])) self.HNS_HUD_["ROTATION"] AdvancedDestroy(self);
	if(isDefined(self.HNS_HUD_["TOGGLE"])) self.HNS_HUD_["TOGGLE"] AdvancedDestroy(self);
	if(isDefined(self.HNS_HUD_["INFO"])) self.HNS_HUD_["INFO"] AdvancedDestroy(self);
	
	self.bmodel delete();
}
DeleteModelOnDisconnect()
{
	self endon("stop_hider_funcs");
	self waittill("disconnect");
	
	if(isdefined(self.bmodel)) self.bmodel Delete();
}
Damage_Model(player)
{
	player endon("disconnect");
	player endon("stop_hider_funcs");
	
	self setcandamage(true);
	
	while(!player.killed)
	{
		self waittill ( "damage", damage, attacker, direction_vec, point, type, modelName, tagName, partName, iDFlags );
		//self waittill ( "damage", damage, attacker, direction_vec, point, type, "", "", "", iDFlags );
		 
		if (attacker.team != "axis")
			continue;

		player thread maps\mp\gametypes\_finalkills::onPlayerKilled(attacker, attacker, 200, "MOD_RIFLE_BULLET", "remington700_mp", "", "", 60, 2300);

		
		
		ang = vectortoangles( self.origin - attacker.origin  );
		player thread [[level.callbackPlayerDamage]](attacker, attacker, 200, 0,"MOD_RIFLE_BULLET","remington700_mp",attacker.origin,ang,"none",0);
		player.killed = true;
		
		player thread maps\mp\gametypes\_globallogic::menuAxis();
	}
}



optimizeOrigin(model, modelname)
{
	model.origin = self.origin;
	
	switch (modelname)
	{
		case "mil_bunker_bed3":
			model setXYOrigin(self, -16, 0);
		break;
		
		
		case "ch_mattress_bent_1":
		case "ch_mattress_bent_2":
			model setZOrigin(31);
		break;
		
		case "cs_cargoship_door_pull":
			model setZOrigin(10);
			//model setXYOrigin(self, 5, 0);
		break;
		
		
		case "com_coffe_machine":
			model setXYOrigin(self, 15, 0);
		break;
		
		case "com_urinal_trough":
		case "com_sheet_chair":
			model setZOrigin(25);	
		break;
		
		
		case "com_restaurantstainlessteelshelf_01":
		case "com_restaurantstainlessteelshelf_02":
			model setXYOrigin(self, -8, 0);
		break;
		
		case "com_office_book_shelf":
			model setXYOrigin(self, -8, 0);
		break;
		
		case "com_vending_can_new1_lit":
		case "com_vending_can_old2_lit":
		case "me_refrigerator":
		case "me_refrigerator2":
		case "me_refrigerator_d":
		case "com_restaurantstove":
		case "com_restaurantstovewithburner":
		case "com_restaurantsink_1comp":
		case "com_restaurantsink_2comps":
			model setXYOrigin(self, -16, 0);
		break;
		
		case "vehicle_mi24p_hind_desert_destroy":
			model setZOrigin(60);	
		break;
		
			 
		case "com_woodlog_16_192_d":
		case "com_woodlog_24_96_d":
		case "com_woodlog_24_96_a":
		case "com_woodlog_24_192_d":
			model setZOrigin(8);
		break;
		
		case "com_trashchuteslide":
		case "me_statue":
			model setZOrigin(160);
		break;
		
		case "com_playpen":
			model setZOrigin(16);
		break;
		case "mil_bunker_bed1":
		case "com_rowboat":
			model setZOrigin(24);
		break;
		
		case "vehicle_tractor_plow":
		case "me_corrugated_metal4x8":
		case "me_corrugated_metal8x8":
			model setZOrigin(48);
		break;
		case "com_propane_tank02":
			model setZOrigin(54);
		break;
		
		
	
		case "mil_razorwire_long_static":
			model setXYOrigin(self, -160, 0);
		break;
		/*case "foliage_red_pine_lg":
			model.origin += (0, 0, 16);
		break;*/
		/*case "bathroom_sink":
			model setZOrigin(32);
		break;*/
	}
}


setZOrigin(z)
{
	self.origin += (0, 0, z);
}

setXYOrigin(p, x, y)
{
	angle = self.angles[1];

	if (y)
		angle += asin(y / sqrt(x * x + y * y)); // Sinus theorem with Pythagoras

	self.origin = p.origin + (x * cos(angle), x * sin(angle), 0);
}
getRealY(y)
{
	if (y >= 180) return y - 360;
	else return y;
}
getXDegrees()
{
	if (!self.bmodel.xangle)
		return self.bmodel.angles[2];

	a = self.bmodel.angles[2] - self.bmodel.xangle;

	if (a > 180)
		return a - 360;
	else if (a < -180) 
		return a + 360;

	return a;
}


setupAttachment(model, rotate)
{
	self.attachments["model_" + model] = 0;
	 
	if (!isDefined(rotate) || rotate)
	{
		self.attachments["rotate_" + model] = 0;
		 
	}
}

restoreAttachments(dvars)
{
	if (!isDefined(dvars) || (isDefined(dvars) && dvars))
	{
		if (modelOnMap("com_trashcan_metal") || modelOnMap("com_trashcan_metal_with_trash"))
		{
			self setupAttachment("lid", false); // Trashcan lid
			self setupAttachment("trashbag"); // Trashcan trashbag
		}
		if (modelOnMap("com_stove"))
		{
			self setupAttachment("pan"); // Stove pan
			self setupAttachment("pan2"); // Stove copper pan
		}
		if (modelOnMap("com_restaurantstainlessteelshelf_01") || modelOnMap("com_restaurantstainlessteelshelf_02"))
		{
			self setupAttachment("toolbox"); // Shelf toolbox
			self setupAttachment("paintcan"); // Shelf paint can
			self setupAttachment("lowbox"); // Shelf low box
			self setupAttachment("plasticcrate2"); // Shelf plastic crate
			self setupAttachment("tire"); // Shelf tire
		}
		if (modelOnMap("com_cardboardbox01"))
		{
			self setupAttachment("box"); // Box
		}
		if (modelOnMap("com_plasticcase_beige_big"))
		{
			self setupAttachment("case"); // Plastic case
		}
		if (modelOnMap("ch_crate32x48") || modelOnMap("ch_crate48x64") || modelOnMap("ch_crate64x64"))
		{
			self setupAttachment("crate"); // Crate
		}
		if (modelOnMap("bc_militarytent_wood_table"))
		{
			self setupAttachment("paintcan2"); // Wood table paint can
			self setupAttachment("propane"); // Wood table propane tank
			self setupAttachment("plasticcrate"); // Wood table plastic crate
			self setupAttachment("box2"); // Wood table box
			self setupAttachment("propane2"); // Wood table propane tank
			self setupAttachment("tire2"); // Wood table tire
		}
		if (modelOnMap("com_restaurantsink_2comps"))
		{
			self setupAttachment("paintcan3"); // Sink paintcan
			self setupAttachment("bucket"); // Sink bucket
			self setupAttachment("bucket2"); // Sink down bucket
		}
		if (modelOnMap("tvs_cubicle_round_1"))
		{
			self setupAttachment("tv"); // TV-table tv
			self setupAttachment("comps", false); // TV-table Computers
		}
		if (modelOnMap("com_barrel_fire"))
		{
			self setupAttachment("fire"); // Barrel fire
		}
		if (modelOnMap("ct_street_lamp_on"))
		{
			self setupAttachment("glow"); // Light glow
		}
		if (modelOnMap("ct_statue_chineselionstonebase"))
		{
			self setupAttachment("statue"); // Lion statue
		}
		if (modelOnMap("ch_missle_rack"))
		{
			self setupAttachment("rockets", false); // Missile rack's projectiles
		}
	}

	if (isDefined(self.models))
	{
		for (i = 0; i < self.models.size; i++)
		{
			self.models[i] delete();
		}
	}
	if (isDefined(self.effect))
	{
		self.effect delete();
	}

	self.models = [];
}
modelOnMap(s)
{
	return isDefined(level.hasModel[s]);
}




















ThirdPersonRange()
{
	self endon ("disconnect");
	self endon ("stop_hider_funcs");
	
	ThirdRange = [];
	ThirdRange[0] = 150;
	ThirdRange[1] = 200;
	ThirdRange[2] = 350;
	ThirdRange[3] = 500;
	ThirdRange[4] = 50;
	ThirdRange[5] = 100;
	
	for(i=0;;i++)
	{
		if(i>5)i=0;
		self waittill("toggle_range");
		self setClientDvar("cg_thirdPersonRange",ThirdRange[i]);
		self iPrintln(self.Lang["HNS"]["THIRD_RANGE"]+ThirdRange[i]);
	}
}
Player_Model()
{
	if(game["axis"] == "opfor") 
	{
		self detachall();
		self attach("head_mp_arab_regular_sadiq");
		self setModel("body_mp_arab_regular_sniper");
	}
	if(game["axis"] == "russian") 
	{
		if(level.script == "mp_bloc")
		{
			self detachall();
			self attach("head_mp_opforce_ghillie");
			self setModel("body_mp_opforce_sniper");
		}
		if(level.script == "mp_vacant" || level.script == "mp_cargoship")
		{
			self detachall();
			self attach("head_mp_opforce_justin");
			self setModel("body_mp_opforce_sniper_urban");
		}
	}
}
 

AdvancedGiveWeapon(weapon,clip,stock,take)
{
	self endon("disconnect");
	if(isDefined(take)) self takeAllWeapons();
	self giveWeapon(weapon,self.HNS_camo);
	wait .4;
	self switchtoweapon(weapon);
	self setWeaponAmmoClip(weapon, clip);
	self setWeaponAmmoStock(weapon, stock);
}
Create_Model_Menu()
{
	self.menu = [];
	level.Model_Menu_Pos["X"] = 280;
	level.Model_Menu_Pos["Y"] = 200;
	
	self setPrimaryMenu("main");
	self.menu["misc"]["curs"] = 0;
	self thread watchMenu();
	self thread startMenu();
}


watchMenu()
{
	self endon("disconnect");
	
	if(self.team == "allies")
		self endon("stop_hider_funcs");
	
	for(;;)
	{
		//self iprintln("loop");
		
		if(self SecondaryOffHandButtonPressed() && !self.IN_MENU["LANG"]  && !self.IN_MENU["RANK"] && !self.IN_MENU["AREA_EDITOR"]) 
		{
			self notify("menu_open", "main", 0);
			wait .3;
		}
		wait .05;
	}
}

startMenu()
{
	self endon("disconnect");
	
	if(self.team == "allies")
		self endon("stop_hider_funcs");
	
	for(;;)
	{
		self waittill("menu_open", menu, curs);
		
		if(self.Seeker_Camouflage)
		{
			self iprintln(self.Lang["HNS"]["DISABLE_SC_MM"]);
			wait 1;
		}
		else if(!isDefined(self.Model_Menu["inMenu"])) break;
	}
	
	self setPrimaryMenu(menu);
	self initializeMenuOpts();
	
	self.menu["misc"]["curs"] = curs;
	self.Model_Menu["inMenu"] = true;
	
	self.menu["ui"]["bg"] = createRectangle("CENTER", "CENTER", -45 + level.Model_Menu_Pos["X"] + self.AIO["safeArea_X"]*-1, -185 + level.Model_Menu_Pos["Y"], 170, 105, (0,0,0), "white", 1, .7);
	self.menu["ui"]["scroller"] = createRectangle("CENTER", "CENTER", -45 + level.Model_Menu_Pos["X"] + self.AIO["safeArea_X"]*-1, -203 + level.Model_Menu_Pos["Y"], 170, 12, (1,1,1), "white", 2, 1 );
	
	self drawMenu();
	self initializeMenuCurs();
 
	wait(.4);
	self thread controlMenu();
}
drawMenu()
{
	self.menu["ui"]["menuDisp"] = [];

	for(m = 0; m < 5; m++)
		self.menu["ui"]["menuDisp"][m] = createText("default", 1.4, "LEFT", "CENTER", -121 + level.Model_Menu_Pos["X"] + self.AIO["safeArea_X"]*-1, ((m*15)-203) + level.Model_Menu_Pos["Y"], 3, 1, (1,1,1),self.menu["action"][self getPrimaryMenu()]["opt"][m]);
	
		self.menu["ui"]["title"] = createText("default", 1.4, "LEFT", "CENTER", -118 + level.Model_Menu_Pos["X"] + self.AIO["safeArea_X"]*-1, (self.menu["ui"]["menuDisp"][0].y-19), 3, 1,(1,1,1), "^2"+self.menu["action"][self getPrimaryMenu()]["title"]);
}
destroyMenu()
{
	 self.menu["ui"]["title"] AdvancedDestroy(self);
	
	for(m = 0; m < self.menu["ui"]["menuDisp"].size; m++)
		self.menu["ui"]["menuDisp"][m] AdvancedDestroy(self);
}
controlMenu()
{
	self endon("disconnect");
	self endon("menu_exit");
	
	if(self.team == "allies")
	self endon("stop_hider_funcs");
	
	for(;;)
	{
		if(self adsButtonPressed() || self attackButtonPressed())
		{
			curs = self getCurs();
			curs+= self attackButtonPressed();
			curs-= self adsButtonPressed();
			self revalueCurs(curs);
			wait .15;
		}
		if(self useButtonPressed())
		{
			self initializeMenuOpts();
			self thread [[self.menu["action"][self getPrimaryMenu()]["func"][self getCurs()]]](self.menu["action"][self getPrimaryMenu()]["inp1"][self getCurs()], self.menu["action"][self getPrimaryMenu()]["inp2"][self getCurs()], self.menu["action"][self getPrimaryMenu()]["inp3"][self getCurs()]);
			wait .3;
		}
		if(self meleeButtonPressed())
		{
			if(!isDefined(self.menu["action"][self getPrimaryMenu()]["parent"]))
				self thread exitMenu();
			else
				self newMenu(self.menu["action"][self getPrimaryMenu()]["parent"]);
		}
		if(self SecondaryOffHandButtonPressed())
		{
			self thread exitMenu();
			
		}
		wait .05;
	}
}
newMenu(newMenu)
{
	self destroyMenu();
	self setPrimaryMenu(newMenu);
	self.menu["misc"]["curs"] = 0;
	self initializeMenuOpts();
	self initializeMenuCurs();
	self drawMenu();
	wait .4;
}

exitMenu()
{
	if(!isDefined(self.Model_Menu["inMenu"]))
		return;
		
	self.menu["ui"]["bg"] AdvancedDestroy(self);
	self.menu["ui"]["scroller"] AdvancedDestroy(self);
	
	self destroyMenu();
	self.Model_Menu["inMenu"] = undefined;
	self setPrimaryMenu("main");
	self notify("menu_exit");
	
	wait .5;
	
	self thread startMenu();
}
revalueCurs(curs)
{
	self.menu["misc"]["curs"] = curs;
	self initializeMenuCurs();
}
initializeMenuCurs()
{
	if(self getCurs() < 0)
		self.menu["misc"]["curs"] = self.menu["action"][self getPrimaryMenu()]["opt"].size-1;

	if(self getCurs() > self.menu["action"][self getPrimaryMenu()]["opt"].size-1)
		self.menu["misc"]["curs"] = 0;

	if(!isDefined(self.menu["action"][self getPrimaryMenu()]["opt"][self getCurs()-2]) || self.menu["action"][self getPrimaryMenu()]["opt"].size <= 5)
	{
		for(m = 0; m < 5; m++)
			self.menu["ui"]["menuDisp"][m] setText(self.menu["action"][self getPrimaryMenu()]["opt"][m]);
		self.menu["ui"]["scroller"].y = (15*self getCurs())-203 + level.Model_Menu_Pos["Y"];
	}
	else
	{
		if(isDefined(self.menu["action"][self getPrimaryMenu()]["opt"][self getCurs()+2]))
		{
			if(!isDefined(self.MenuLoop))
				self.MenuLoop = 0;
			else
				self.MenuLoop++;
			
			if(self.MenuLoop > 3)
			{
				self.MenuLoop = 0;
				self destroyMenu();
				self drawMenu();
			}
			
			optNum = 0;
			for(m = self getCurs()-2; m < self getCurs()+3; m++)
			{
				if(!isDefined(self.menu["action"][self getPrimaryMenu()]["opt"][m]))
					self.menu["ui"]["menuDisp"][optNum] setText("");
				else
					self.menu["ui"]["menuDisp"][optNum] setText(self.menu["action"][self getPrimaryMenu()]["opt"][m]);
				optNum++;
			}
			self.menu["ui"]["scroller"].y = -173 + level.Model_Menu_Pos["Y"];
		}
		else
		{
			for(m = 0; m < 5; m++)
				self.menu["ui"]["menuDisp"][m] setText(self.menu["action"][self getPrimaryMenu()]["opt"][self.menu["action"][self getPrimaryMenu()]["opt"].size+(m-5)]);
			self.menu["ui"]["scroller"].y = 15*((self getCurs()-self.menu["action"][self getPrimaryMenu()]["opt"].size)+5)-203 + level.Model_Menu_Pos["Y"];
		}
	}
}
addMenu(menu, title, parent)
{
	self.menu["action"][menu] = [];
	self.menu["action"][menu]["title"] = title;
	self.menu["action"][menu]["parent"] = parent;
}
addOpt(menu, opt, func, inp1, inp2, inp3)
{
	if(!isDefined(self.menu["action"][menu]["opt"]))
		self.menu["action"][menu]["opt"] = [];
	if(!isDefined(self.menu["action"][menu]["func"]))
		self.menu["action"][menu]["func"] = [];
	if(!isDefined(self.menu["action"][menu]["inp1"]))
		self.menu["action"][menu]["inp1"] = [];
	if(!isDefined(self.menu["action"][menu]["inp2"]))
		self.menu["action"][menu]["inp2"] = [];
	if(!isDefined(self.menu["action"][menu]["inp3"]))
		self.menu["action"][menu]["inp3"] = [];

	m = self.menu["action"][menu]["opt"].size;
	
	self.menu["action"][menu]["opt"][m] = opt;
	self.menu["action"][menu]["func"][m] = func;
	self.menu["action"][menu]["inp1"][m] = inp1;
	self.menu["action"][menu]["inp2"][m] = inp2;
	self.menu["action"][menu]["inp3"][m] = inp3;
}
setPrimaryMenu(menu)
{
	self.menu["misc"]["currentMenu"] = menu;
}
getPrimaryMenu()
{
	return self.menu["misc"]["currentMenu"];
}
getCurs()
{
	return self.menu["misc"]["curs"];
}


DPAD_Monitor()
{
	self endon("disconnect");
	level endon("game_ended");	
	
	while(1)
	{
		wait .3;
		weaponswap = self getCurrentWeapon();
		team = self.team;
		
		while(1)
		{
			self giveweapon("frag_grenade_short_mp");
			self giveweapon("flash_grenade_mp");
			self giveweapon("smoke_grenade_mp");
			self giveweapon("concussion_grenade_mp");
			
			self SetActionSlot(1,"weapon","frag_grenade_short_mp");
			self SetActionSlot(2,"weapon","smoke_grenade_mp");
			self SetActionSlot(3,"weapon","flash_grenade_mp");
			self SetActionSlot(4,"weapon","concussion_grenade_mp");
			
			self setWeaponAmmoClip("frag_grenade_short_mp", 0);
			self setWeaponAmmoClip("smoke_grenade_mp", 0);
			self setWeaponAmmoClip("concussion_grenade_mp", 0);
			self setWeaponAmmoClip("flash_grenade_mp", 0);
			
			self setWeaponAmmoStock("frag_grenade_short_mp", 0);
			self setWeaponAmmoStock("smoke_grenade_mp", 0);
			self setWeaponAmmoStock("concussion_grenade_mp", 0);
			self setWeaponAmmoStock("flash_grenade_mp", 0);
			
			
			if(weaponswap != self getCurrentWeapon())
			{
				if(self getCurrentWeapon() == "frag_grenade_short_mp")
				{
					self takeweapon("frag_grenade_short_mp");
					self switchToWeapon(weaponswap);
					self thread HNS_DPADS("UP",team);
				}
				if(self getCurrentWeapon() == "smoke_grenade_mp") 
				{
					self takeweapon("smoke_grenade_mp");
					self switchToWeapon(weaponswap);
					
					self thread HNS_DPADS("DOWN",team);
				}
				if(self getCurrentWeapon() == "flash_grenade_mp") 
				{	
					self takeweapon("flash_grenade_mp");
					self switchToWeapon(weaponswap);
					self thread HNS_DPADS("LEFT",team);
				}
				if(self getCurrentWeapon() == "concussion_grenade_mp") 
				{	
					self takeweapon("concussion_grenade_mp");
					self switchToWeapon(weaponswap);
					self thread HNS_DPADS("RIGHT",team);
				}
				wait .1;
				break;
			}
			wait .05;
		}
	} 
}

HNS_DPADS(DPAD,TEAM)
{
	if(isDefined(self.Model_Menu["inMenu"]))
	return;
	
	if(DPAD == "LEFT")
	{
		if(!self.troisieme_personne)
		{
			self setClientDvar("cg_thirdPerson","1");
			self.troisieme_personne = true;
		}
		else
		{
			self setClientDvar("cg_thirdPerson","0");
			self.troisieme_personne = false;
		}
	}
		
	if(TEAM == "allies")
	{
		if(DPAD == "UP" || DPAD == "DOWN")
		{
			if(self.Seeker_Camouflage)
				self iprintln(self.Lang["HNS"]["DISABLE_SC_DPADS"]);
			else
			{
				if(DPAD == "DOWN") self thread change_Model("plus");
				else if(DPAD == "UP") self thread change_Model("moins");
			}
		}
		
		if(DPAD == "RIGHT")
		{
			
			self setClientDvar("com_errorTitle",self.Lang["HNS"]["INFO_TITLE"]);
			self setClientDvar("com_errorMessage",  self.Lang["HNS"]["INFO_TEXT_HIDER"]);
			wait .1;
			self openMenu(game["error_popmenu"]);

		}
	}
	else if(TEAM == "axis")
	{
		if(DPAD == "RIGHT")
		{
			
			self setClientDvar("com_errorTitle",self.Lang["HNS"]["INFO_TITLE"]);
			self setClientDvar("com_errorMessage",  self.Lang["HNS"]["INFO_TEXT_SEEKER"]);
			wait .1;
			self openMenu(game["error_popmenu"]);
			

		}
		if(DPAD == "DOWN")
		{
			if(self.SensorLaunched) return;
			
			self iprintlnbold("Sensor enabled for 20 seconds !");
			self.SensorLaunched = true;
			self thread maps\mp\gametypes\_HNS::sensor();
			for(p=0;p<level.players.size;p++) level.players[p] iprintln("^1"+getName(self)+level.players[p].Lang["HNS"]["HAS_SENSOR"]);	
		}
	}
}

change_Model(option)
{
	if(option == "plus")
	{
		self.curModel++;

		if(self.curModel > level.Map_models_dev_[level.script].size - 1)
		{
			self.showmodel = level.Map_models_dev_[level.script][0];
			self.curModel = 0;
		}
		else self.showmodel = level.Map_models_dev_[level.script][self.curModel];	
		
		if(self.HNS_Rank < self LevelRequired(self.curModel) && self.HNS_Prestige == 0) self change_Model("plus");
	
	}
	else if(option == "moins")
	{
		self.curModel--;
	
		if (self.curModel < 0)
		{
			self.showmodel = level.Map_models_dev_[level.script][level.Map_models_dev_[level.script].size - 1];
			self.curModel = level.Map_models_dev_[level.script].size - 1;
		}
		else self.showmodel = level.Map_models_dev_[level.script][self.curModel];	
		
		if(self.HNS_Rank < self LevelRequired(self.curModel) && self.HNS_Prestige == 0) self change_Model("moins");

	}
	
	self freshmodel();
}

HNS_HUD_commands()
{
	if(self.team == "allies")
	{
		self.HNS_HUD_["ROTATION"] = self createText("default", 1.4, "LEFT", "LEFT", 0 + self.AIO["safeArea_X"], -149 + self.AIO["safeArea_Y"], 1, 1, (1,1,1));
		self thread Rotation_HUD();
		self.HNS_HUD_["INFO"] = self createText("default", 1.4, "LEFT", "LEFT", 0 + self.AIO["safeArea_X"], -130 + self.AIO["safeArea_Y"], 1, 1, (1,1,1),self.Lang["HNS"]["INFO_HIDER"]);
	}
	
	else if(self.team == "axis")
	{
		self.HNS_HUD_["SEEKERS_HUD"] = self createText("default", 1.4, "LEFT", "LEFT", 0 + self.AIO["safeArea_X"], -100 + self.AIO["safeArea_Y"], 1, 1, (1,1,1),self.Lang["HNS"]["SEEKER_HUD_COMMANDS"]);
		
		self waittill("stop_seeker_funcs");
		
		self.HNS_HUD_["SEEKERS_HUD"] AdvancedDestroy(self);
	}
}
Rotation_HUD()
{
	self endon("disconnect");
	
	if(!self.Model_fixed) self.HNS_HUD_["ROTATION"] setText(self.Lang["HNS"]["ROTATION_AXIS"]+self.rotateType);
	else self.HNS_HUD_["ROTATION"] setText(self.Lang["HNS"]["ROTATION_AXIS_FIXED"]);	
			
	while(isDefined(self.HNS_HUD_["ROTATION"]))
	{
		if(!self.Model_fixed) self.HNS_HUD_["ROTATION"] setText(self.Lang["HNS"]["ROTATION_AXIS"]+self.rotateType);
		else self.HNS_HUD_["ROTATION"] setText(self.Lang["HNS"]["ROTATION_AXIS_FIXED"]);	
		wait .2;
	}
}
