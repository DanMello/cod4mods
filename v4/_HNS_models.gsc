#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include maps\mp\gametypes\_general_funcs;


		
		
		
initModels()
{
	if(level.script == "mp_convoy")
	{
		setDvar("scr_sd_timelimit", 6.20);
		setDvar("scr_sab_timelimit", 6.20);
		level.Map_models_dev_[level.script] = strTOK("me_ac_big;me_concrete_barrier;me_dumpster_close;me_refrigerator;me_satellitedish;me_rooftop_tank_01;me_corrugated_metal8x8;com_northafrica_armoire_short;com_cafe_table2;com_cafe_chair2;com_cafe_chair;com_barrel_fire;com_barrel_white_rust;com_barrel_blue_rust;com_stove;com_pallet_2;vehicle_bulldozer;vehicle_uaz_light_dsr;vehicle_80s_sedan1_yeldest;vehicle_humvee_camo_static;mil_sandbag_desert_curved;mil_sandbag_desert_long;foliage_tree_palm_bushy_3;foliage_tree_river_birch_xl_a;foliage_dead_pine_sm",";");
	}
	if(level.script == "mp_backlot")
	{
		setDvar("scr_sd_timelimit", 6.20);
		setDvar("scr_sab_timelimit", 6.20);
		level.Map_models_dev_[level.script] = strTOK("me_ac_big;me_concrete_barrier;me_refrigerator2;me_satellitedish;me_dumpster_close;me_gas_pump;me_corrugated_metal8x8;me_ac_window;com_bike;com_water_heater;com_cafe_table2;com_cafe_chair2;com_wheelbarrow;com_cafe_chair;com_pallet_2;com_pallet_stack;com_barrel_blue_rust;com_barrel_white_rust;com_restaurantstainlessteelshelf_02;com_folding_chair;com_dresser_d;com_plasticcase_beige_big;ch_dinerboothchair;ch_dinercounterchair;ch_dinerboothtable;ch_furniture_couch02;ch_furniture_couch01;ch_washer_01;ch_bedframemetal_gray;ch_russian_table;bc_hesco_barrier_med;foliage_tree_palm_bushy_3_static;foliage_tree_river_birch_xl_a;vehicle_80s_sedan1_silvdest;vehicle_80s_sedan1_yeldest;vehicle_80s_sedan1_silv_destructible_mp;vehicle_80s_sedan1_yel_destructible_mp",";");
	}
	if(level.script == "mp_bloc")
	{
		setDvar("scr_sd_timelimit", 8.20);
		setDvar("scr_sab_timelimit", 8.20);
		level.Map_models_dev_[level.script] = strTOK("com_bench;com_metalbench;com_cafe_chair2;com_cafe_chair;com_plainchair;com_barrier_tall1;com_folding_table;com_restaurantchair_2;com_locker_double;com_barrel_fire;com_office_book_shelf;com_playpen;com_barrel_white_rust;com_dresser_d;com_bookshelves1_d;com_armoire_d;com_stove;com_plasticcase_beige_big;ch_baby_carriage;ch_mattress_bent_1;ch_russian_table;ch_mattress_boxspring;ch_bedframemetal_gray;ch_furniture_couch01;ch_crate64x64;ch_crate48x64;me_concrete_barrier;me_refrigerator;me_refrigerator_d;mil_sandbag_desert_long;mil_sandbag_desert_curved;foliage_red_pine_lg;foliage_red_pine_xxl;foliage_red_pine_xl;vehicle_80s_hatch1_reddest;vehicle_80s_wagon1_tandest;prop_misc_rock_boulder_snow_05",";");
	}
	if(level.script == "mp_bog")
	{
		setDvar("scr_sd_timelimit", 5.20);
		setDvar("scr_sab_timelimit", 5.20);
		level.Map_models_dev_[level.script] = strTOK("com_barrel_white_rust;com_barrel_blue_rust;com_barrel_black;com_barrel_fire;com_trashcan_metal_with_trash;com_trashcan_metal;com_water_heater;com_cafe_table1;com_cafe_chair;com_restaurantsink_1comp;com_restaurantstove;com_wagon_donkey;com_plasticcase_beige_big;ch_crate48x64;ch_dinercounterchair;ch_dinerboothchair;ch_dinerboothtable;ch_washer_01;me_concrete_barrier;me_dumpster_close;me_dumpster;me_market_stand4;me_refrigerator;me_refrigerator2;me_ac_big;me_satellitedish;me_corrugated_metal8x8;vehicle_80s_hatch2_yeldest;vehicle_80s_sedan1_silvdest;vehicle_80s_sedan1_tandest;vehicle_80s_hatch1_greendest;vehicle_80s_sedan1_silv_destructible_mp;bc_militarytent_wood_table;foliage_tree_palm_bushy_1_static;foliage_tree_palm_bushy_2_static",";");
	}
	if(level.script == "mp_countdown")
	{
		setDvar("scr_sd_timelimit", 6.20);
		setDvar("scr_sab_timelimit", 6.20);
		level.Map_models_dev_[level.script] = strTOK("me_ac_big;me_construction_dumpster_close;me_corrugated_metal4x8;com_barrier_tall1;com_restaurantstainlessteelshelf_01;com_barrel_blue_rust;com_barrel_white_rust;com_barrel_black_rust;com_pallet_2;com_plasticcase_green_big;com_plasticcase_beige_big;com_plasticcase_green_rifle;ch_missle_rack;ch_crate24x24;ch_crate32x48;ch_crate64x64;ch_roadrock_01;bc_military_comm_tower;mil_sandbag_desert_curved;foliage_red_pine_stump_sm;foliage_red_pine_xxl;foliage_red_pine_lg;vehicle_bmp_dsty_static;vehicle_sa6_static_woodland;vehicle_pickup_technical_destroyed",";");
	}
	if(level.script == "mp_crash")
	{
		setDvar("scr_sd_timelimit", 6.20);
		setDvar("scr_sab_timelimit", 6.20);
		level.Map_models_dev_[level.script] = strTOK("me_phonebooth;me_refrigerator;com_cafe_chair;com_cafe_chair2;com_cafe_table2;com_barrel_white_rust;com_barrel_blue_rust;com_restaurantchair_2;com_restaurantstainlessteelshelf_02;com_restaurantstove;com_restaurantstovewithburner;com_restaurantkitchentable_1;com_restaurantkitchentable_4;com_trashcan_metal;com_dresser_d;com_pallet_stack;com_tv1;com_plasticcase_beige_big;me_concrete_barrier;me_ac_big;me_ac_window;me_corrugated_metal8x8;me_satellitedish;me_dumpster_close;ch_dinerboothchair;ch_dinerboothtable;ch_mattress_2;ch_furniture_couch02;ch_bedframemetal_gray;mil_sandbag_desert_curved;foliage_tree_palm_bushy_3_static;foliage_tree_river_birch_xl_a;bc_militarytent_wood_table;bc_hesco_barrier_med;vehicle_pickup_technical_destroyed;vehicle_80s_sedan1_red_destroyed;vehicle_80s_sedan1_brn_destructible_mp;vehicle_80s_sedan1_green_destructible_mp",";");
	}
	if(level.script == "mp_crossfire")
	{
		setDvar("scr_sd_timelimit", 7.20);
		setDvar("scr_sab_timelimit", 7.20);
		level.Map_models_dev_[level.script] = strTOK("me_basket_rattan01;me_basket_wicker01;me_refrigerator;me_refrigerator2;me_dumpster_close;me_dumpster;me_ac_big;me_ac_window;me_satellitedish;me_corrugated_metal8x8;com_water_heater;com_cafe_chair;com_cafe_chair2;com_cafe_table1;com_cafe_table2;com_folding_chair;com_folding_table;com_restaurantstainlessteelshelf_02;com_restaurantstovewithburner;com_restaurantsink_2comps;com_trashcan_metal;com_trashcan_metal_with_trash;com_tv2;com_tv1;com_dresser;com_dresser_d;com_plasticcase_beige_big;com_barrel_blue_rust;com_barrel_black_rust;ch_russian_table;ch_washer_01;ch_dinerboothchair;ch_dinerboothtable;ch_bedframemetal_gray;ch_furniture_couch01;ch_furniture_couch02;bc_militarytent_wood_table;bc_hesco_barrier_med;foliage_tree_palm_bushy_1;vehicle_80s_sedan1_green_destroyed;vehicle_80s_sedan1_silv_destroyed;vehicle_80s_sedan1_silv_destructible_mp;vehicle_80s_sedan1_green_destructible_mp",";");
	}
	if(level.script == "mp_citystreets")
	{
		setDvar("scr_sd_timelimit", 7.20);
		setDvar("scr_sab_timelimit", 7.20);
		level.Map_models_dev_[level.script] = strTOK("com_restaurantstainlessteelshelf_02;com_restaurantsink_2comps;com_restaurantstovewithburner;com_trashcan_metal;com_wagon_donkey_nohandle;com_mannequin1;com_cafe_chair;com_cafe_chair2;com_cafe_table2;com_pallet_stack;com_barrel_benzin;com_barrel_white_rust;com_barrel_corrosive_rust;com_plasticcase_beige_big;me_concrete_barrier;me_wood_cage_large;me_satellitedish;me_ac_window;me_ac_big;me_corrugated_metal8x8;me_dumpster_close;me_basket_wicker05;me_gas_pump;me_refrigerator;me_refrigerator2;ch_crate32x48;ch_dinerboothchair;ch_dinerboothtable;ch_furniture_couch02;ch_bedframemetal_gray;foliage_tree_palm_bushy_1;mil_sandbag_desert_long;bc_militarytent_wood_table;vehicle_80s_hatch2_tan;vehicle_80s_sedan1_silv_destroyed;vehicle_80s_sedan1_red_destroyed;vehicle_80s_sedan1_silv_destructible_mp;vehicle_80s_sedan1_red_destructible_mp",";");
	}
	if(level.script == "mp_farm")
	{
		setDvar("scr_sd_timelimit", 7.20);
		setDvar("scr_sab_timelimit", 7.20);
		level.Map_models_dev_[level.script] = strTOK("me_refrigerator;me_dumpster;me_dumpster_close;com_restaurantstainlessteelshelf_02;com_restaurantsink_1comp;com_barrel_white_rust;com_barrel_blue_rust;com_pallet_stack;com_dresser;com_dresser_d;com_stove_d;com_wheelbarrow;com_cafe_chair;com_propane_tank02;com_satellite_dish_big;com_plasticcase_beige_big;com_tv2;ch_bedframemetal_gray;ch_washer_01;ch_hayroll_03;ch_lawnmower;ch_crate64x64;ch_furniture_couch02;me_corrugated_metal8x8;bc_militarytent_wood_table;foliage_tree_river_birch_xl_a;foliage_red_pine_stump_xl;foliage_tree_destroyed_fallen_log_a;foliage_tree_destroyed_tree_a;foliage_dead_pine_lg;vehicle_80s_sedan1_tandest;vehicle_80s_hatch2_brndest;vehicle_tractor_plow;vehicle_tractor_2",";");
	}
	if(level.script == "mp_overgrown")
	{
		setDvar("scr_sd_timelimit", 7.20);
		setDvar("scr_sab_timelimit", 7.20);
		level.Map_models_dev_[level.script] = strTOK("com_restaurantstainlessteelshelf_02;com_barrier_tall1;com_restaurantsink_1comp;com_stove_d;com_cafe_chair;com_bookshelves1_d;com_barrel_white_rust;com_barrel_blue_rust;com_barrel_fire;com_dresser_d;com_restaurantstove;com_restaurantstovewithburner;com_armoire_d;com_plasticcase_beige_big;com_bookshelveswide;com_bookshelves1;ch_furniture_couch02;ch_russian_table;ch_furniture_couch01;ch_bedframemetal_gray;ch_hayroll_02;ch_crate32x48;ch_crate48x64;ch_crate64x64;ch_crate24x36;ch_crate24x24;ch_street_light_01_off;me_gas_pump;me_refrigerator_d;me_dumpster_close;me_corrugated_metal8x8;vehicle_tractor;vehicle_80s_sedan1_yeldest;vehicle_80s_wagon1_brndest;foliage_tree_destroyed_fallen_log_a;foliage_red_pine_stump_xl;foliage_tree_river_birch_xl_a;foliage_red_pine_stump_lg;mil_sandbag_desert_curved;mil_sandbag_desert_long;prop_misc_rock_boulder_04",";");
	}
	if(level.script == "mp_pipeline")
	{
		setDvar("scr_sd_timelimit", 8.20);
		setDvar("scr_sab_timelimit", 8.20);
		level.Map_models_dev_[level.script] = strTOK("com_restaurantstainlessteelshelf_02;com_filecabinetblackopen;com_barrel_white_rust;com_barrel_blue_rust;com_pallet_2;com_barrel_green_dirt;com_propane_tank02;com_pallet_stack;com_barrel_biohazard_rust;com_plasticcase_beige_big;com_folding_table;com_water_heater;com_electrical_transformer;com_filecabinetblackclosed;me_concrete_barrier;me_dumpster_close;me_refrigerator;me_ac_big;me_corrugated_metal8x8;ch_gas_pump;ch_furniture_teachers_desk1;ch_crate48x64;ch_mattress_bent_2;ch_crate64x64;ch_crate32x48;bc_militarytent_wood_table;vehicle_80s_sedan1_green_destructible_mp;vehicle_80s_hatch1_red_destructible_mp;;;;;vehicle_80s_hatch1_reddest;vehicle_80s_sedan1_greendest;vehicle_bulldozer;foliage_tree_grey_oak_xl_a;foliage_red_pine_stump_lg",";");
	}
	if(level.script == "mp_shipment")
	{
		setDvar("scr_sd_timelimit", 1.60);
		setDvar("scr_sab_timelimit", 1.60);
		level.Map_models_dev_[level.script] = strTOK("com_barrel_blue_rust;com_barrel_green_rust;com_barrel_biohazard_rust;com_pallet_stack;com_folding_chair;com_folding_table;com_trashcan_metal_with_trash;com_trashcan_metal;com_bomb_objective_d;com_bomb_objective;com_plasticcase_beige_big;com_pallet_destroyed;com_tower_crane;com_water_tower;com_cardboardbox01;com_cardboardbox02;com_cardboardbox03;com_cardboardbox04;com_cardboardbox06;me_dumpster_close;me_streetlight;me_dumpster;me_streetlightdual_on;me_docks_tank_03;me_docks_tank_02;me_docks_tank_01;vehicle_80s_sedan1_greendest;vehicle_80s_hatch1_yeldest;vehicle_delivery_truck;vehicle_pickup_roobars;vehicle_pickup_4door_static;vehicle_semi_truck_cargo;vehicle_80s_sedan1_red;vehicle_tanker_truck_civ;vehicle_humvee_camo_50cal_nodoors;vehicle_pickup_nodoor;bc_militarytent_wood_table;foliage_tree_pine_xl_b;ch_crate32x48",";");
	}
	if(level.script == "mp_showdown")
	{
		setDvar("scr_sd_timelimit", 6.20);
		setDvar("scr_sab_timelimit", 6.20);
		level.Map_models_dev_[level.script] = strTOK("com_wagon_donkey;com_tv2;com_wheelbarrow;com_barrel_white_rust;com_barrel_blue_rust;com_barrel_white_rust;com_trashcan_metal;com_trashcan_metal_with_trash;com_plasticcase_beige_big;com_filecabinetblackclosed;com_industrialtrashbin;com_cinderblockstack;me_woodcrateclosed;me_wood_cage_small;me_ac_window;me_satellitedish;me_dumpster;me_construction_dumpster_open;me_dumpster_close;me_basket_wicker03;me_basket_wicker05;me_basket_rattan02;me_basket_wicker08;me_basket_wicker01;me_basket_rattan01;me_statue;ch_crate24x24;ch_crate64x64;vehicle_pickup_4door_static;vehicle_pickup_nodoor_static;vehicle_bulldozer;vehicle_uaz_van;vehicle_80s_sedan1_silv;foliage_tree_palm_bushy_2_static;",";");
	}
	if(level.script == "mp_strike")
	{
		setDvar("scr_sd_timelimit", 8.20);
		setDvar("scr_sab_timelimit", 8.20);
		level.Map_models_dev_[level.script] = strTOK("com_restaurantstainlessteelshelf_02;com_cafe_table2;com_cafe_chair2;com_cafe_chair;com_folding_table;com_trashcan_metal;com_dresser;com_water_heater;com_restaurantsink_2comps;com_restaurantstovewithburner;com_plasticcase_beige_big;me_phonebooth;me_refrigerator;me_concrete_barrier;me_dumpster_close;me_ac_window;me_ac_big;me_satellitedish;me_corrugated_metal8x8;me_basket_wicker05;ch_gas_pump;ch_furniture_couch01;ch_bedframemetal_gray;ch_washer_01;foliage_tree_river_birch_xl_a;foliage_tree_palm_bushy_2;bc_militarytent_wood_table;bc_hesco_barrier_med;mil_sandbag_desert_short;vehicle_80s_sedan1_brn_destructible_mp;vehicle_80s_sedan1_green_destructible_mp;vehicle_80s_sedan1_reddest;vehicle_80s_sedan1_green_destroyed",";");
	}
	if(level.script == "mp_vacant")
	{
		setDvar("scr_sd_timelimit", 6);
		setDvar("scr_sab_timelimit", 6);
		level.Map_models_dev_[level.script] = strTOK("mil_bunker_bed3;com_barrel_white_rust;com_barrel_blue_rust;com_pallet_2;com_conference_table1;com_plasticcase_green_big;com_filecabinetblackopen;com_photocopier;com_filecabinetblackclosed;com_folding_chair;com_locker_double;com_restaurantstainlessteelshelf_02;com_water_heater;com_folding_table;com_stove;com_trashcan_metal_with_trash;com_bench;com_urinal_trough;com_sheet_chair;com_plasticcase_beige_big;com_computer_case;com_tv2_d;com_office_chair_black;ch_furniture_school_lunch_table;ch_furniture_couch01;ch_crate48x64;ch_furniture_teachers_desk1;ch_mattress_2;ch_crate32x48;me_ac_big;me_refrigerator;me_satellitedish;me_dumpster_close;me_dumpster;me_concrete_barrier;bc_militarytent_wood_table;vehicle_80s_sedan1_yel_destructible_mp;vehicle_80s_hatch1_green_destroyed;vehicle_80s_sedan1_red_destroyed;tvs_cubicle_round_half_1;tvs_cubicle_round_1;foliage_dead_pine_sm;foliage_tree_river_birch_xl_a",";");
	}
	if(level.script == "mp_cargoship")
	{
		setDvar("scr_sd_timelimit", 5);
		setDvar("scr_sab_timelimit", 5);
		level.Map_models_dev_[level.script] = strTOK("com_barrel_blue_rust;com_barrel_white_rust;mil_bunker_bed2;com_folding_chair;com_folding_table;com_restaurantchair_2;cs_monitor1;com_restaurantstainlessteelshelf_02;com_restaurantsink_2comps;com_tv1;cs_monitor2;vehicle_uaz_hardtop;com_cardboardbox04;com_plasticcase_beige_big;com_bomb_objective;com_bomb_objective_d;com_barrel_black_rust;me_ac_window;ch_radiator01;com_locker_double;cs_steeringwheel;cs_cargoship_door_pull",";");
	}
	
	precacheModel("com_pan_copper");
	precacheModel("com_tin_oval_flat");
	precacheModel("com_tin_square_tall01");
	precacheModel("com_tin_square_tall02");
	precacheModel("com_tin_oval_tall");
	precacheModel("com_tin_oval_tall");
	precacheModel("com_tin_oval_tall");
	
	
	
	for(i=0;i<level.Map_models_dev_[level.script].size;i++)
	{
		PrecacheModel(level.Map_models_dev_[level.script][i]);
		getOption(i);
		level.hasModel[level.Map_models_dev_[level.script][i]] = true;
	}
}




getOption(num)
{
	switch(level.Map_models_dev_[level.script][num])
	{
		case"com_barrel_fire":
		case"com_stove":
		
		level.HasOption[level.Map_models_dev_[level.script][num]] = true;
		break;
	}
}



DeathBarriers(map)
{
	wait 10;
	
	switch(map)
	{
		case "mp_convoy":
			CreateDeathBarrier((-2221,328,98),150); //trou
			CreateDeathBarrier((-2284,-96,143),80); //arbre
			CreateDeathBarrier((1144,384,108),40); //mantle poubelle
			CreateDeathBarrier((1245,336,108),40); //mantle poubelle
			CreateDeathBarrier((750,1056,72),150); //mantle 2 mur
			CreateDeathBarrier((802,736,90),180); //mantle 2 mur tank
			CreateDeathBarrier((674,535,108),40); //mantle 2 tank fenetre
			CreateDeathBarrier((774,493,108),80); //mantle 2 tank fenetre
			CreateDeathBarrier((1622,572,136),60); //mantle poubelle
			CreateDeathBarrier((1383,462,108),80); //mantle poubelle
		break;
		
		case "mp_backlot":
			CreateDeathBarrier((876,1599,250),150); //out of map	
			CreateDeathBarrier((699,1099,238),80); //out of map bal
			CreateDeathBarrier((1522,541,278),50); //station rack
			CreateDeathBarrier((1342,252,256),50); //station bal
			CreateDeathBarrier((573,-820,345),100); //poto
			CreateDeathBarrier((2,-827,345),100); //poto
			CreateDeathBarrier((-12,249,341),100); //tracto bal
		break;
		
		case "mp_countdown":
			CreateDeathBarrier((-600,1036,-167),40);
		break;
		
		case "mp_citystreets":
			CreateDeathBarrier((3284,-294,110),50); //bounce mini bal
			CreateDeathBarrier((3328,-476,152),50); //bounce mini bal
			CreateDeathBarrier((4782,-131,48),50); //bal
		break;
			
		case "mp_farm":
			CreateDeathBarrier((-526,-1039,424),50); //out of map
			CreateDeathBarrier((59,1139,424),50); //tree spot
		break;
		
		case "mp_strike":
				CreateDeathBarrier((718,-111,184),30); //spot
				CreateDeathBarrier((107,-1981,283),100); //spot 2	
		break;
		case "mp_crash":
				CreateDeathBarrier((639,-855,351),80); //bat spot vent
				CreateDeathBarrier((588,-739,397),100); //bat spot aerator
				CreateDeathBarrier((-61,-971,370),20); //bat spot echelle
				CreateDeathBarrier((1367,-1323,352),60); //hard strafe vent
				CreateDeathBarrier((1299,104,447),60); //rack
				CreateDeathBarrier((52,2109,406),80); //garage
				CreateDeathBarrier((-339,1019,400),80); //bal
				CreateDeathBarrier((-233,1022,400),80); //bal	
		break;
		
		
		case "mp_crossfire":
				CreateDeathBarrier((6341,-4301,152),20); //out of chaise
				CreateDeathBarrier((5038,-743,208),80); //out of pont	
				CreateDeathBarrier((6320,-1479,240),80); //bal pont
				CreateDeathBarrier((6433,-1315,240),80); //bal pont
				CreateDeathBarrier((3502,-3257,-20),30); //bal 2
		break;
		
		case "mp_overgrown":
				CreateDeathBarrier((1603,-2457,183),50); //pole
				CreateDeathBarrier((516,-2804,-350),30); //glitch inv
				CreateDeathBarrier((117,-1378,-55),50); //truck
		break;
	}
}	
CreateDeathBarrier(enter,ray)
{
	Barrier = spawn( "script_model", enter );
	self thread DeathBarrier(enter,ray);
}
DeathBarrier(enter,ray)
{
	level endon("game_ended");
	
	while(1)
	{
		for(i = 0; i < level.players.size; i++)
		{
			if(Distance(enter, level.players[i].origin) <= ray && isalive(level.players[i]))
			{
				level.players[i] suicide();
				iPrintln( "^1Anti-glitches: ^7"+getName(level.players[i]) + " ^1tried a glitch/jump so I killed this Bitch !");
			}
		}
		wait .25;
	}
}

		
		