#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include maps\mp\gametypes\_general_funcs;




HNS_Lang()
{
	//ENGLISH OR UNDEFINED
	if(self getstat(3228) != 1 || self getstat(3230) == 0)
	{
		self thread ENGLISH_HNS_LANG();
	}
	//FRENCH
	else if(self getstat(3230) == 1)
	{
		self thread ENGLISH_HNS_LANG();
		//self thread FRENCH_HNS_LANG();
	}
	//SPANISH
	else if(self getstat(3230) == 2)
	{
		self thread ENGLISH_HNS_LANG();
	}
	//DEUTSH
	else if(self getstat(3230) == 3)
	{
		self thread ENGLISH_HNS_LANG();
	}
	//FINISH
	else if(self getstat(3230) == 4)
	{
		self thread ENGLISH_HNS_LANG();
	}
}




ENGLISH_HNS_LANG()
{
	
	if(level.script == "mp_convoy")
	{
		self.Lang["HNS"]["MODEL_NAME"][level.script] = strTOK("Aerator;Concrete barrier;Dumpster;Refregirator;Satellite dish;Rooftop tank;Corrugated metal;Armoire;Cafe table;Cafe chair;Wooden chair;Barrel (fire);Barrel (white);Barrel (blue);Stove;Pallet;Bulldozer;UAZ (destroyed);Car (Yellow);Humvee;Sandbag (curved);Sandbag (long);Palm;Tree;Tree (burned) (small)",";");
	}
	if(level.script == "mp_backlot")
	{
		self.Lang["HNS"]["MODEL_NAME"][level.script] = strTOK("Aerator;Concrete barrier;Refregirator (blue);Satellite dish;Dumpster (close);Gas pump;Corrugated metal;Aerator (window);Bike;Boiler;Cafe table;Cafe chair;Wheelbarrow;Wooden chair;Pallet;Pallet stack;Barrel (blue);Barrel (white);Shelf;Folding chair;Dresser (destroyed);Plastic case;Diner bench;Diner chair;Diner table;Couch (old);Couch (new);Washer;Bed frame metal;Russian table;Hesco barrier;Palm;Tree;Car (grey) (destroyed);Car (Yellow) (destroyed);Car (grey) ;Car (yellow)",";");
	}
	if(level.script == "mp_bloc")
	{
		self.Lang["HNS"]["MODEL_NAME"][level.script] = strTOK("Bench (wood);Bench (metal);Cafe chair;Wooden chair;Chair (old);Concrete barrier (tall);Folding table;Kitchen chair;Locker (double);Barrel (fire);Office bookshelf;Playpen;Barrel (white);Dresser (destroyed);Bookshelves (destroyed);Armoire (destroyed);Stove;Plastic case;Baby carriage;Mattress (bent);Russian table;Mattress (boxspring);Bed frame metal;Couch (new);Crate 64x64;Crate 48x64;Concrete barrier;Refregirator;Refregirator (destroyed);Sandbag (long);Sandbag (curved);Tree;Tree (tall);Tree;Car (red) (destroyed);Car (brown) (destroyed);Rock",";");
	}
	if(level.script == "mp_bog")
	{
		self.Lang["HNS"]["MODEL_NAME"][level.script] = strTOK("Barrel (white);Barrel (blue);Barrel (black);Barrel (fire);Trashcan (full);Trashcan;Boiler;Cafe table (round);Wooden chair;Sink;Stove;Wagon donkey;Plastic case;Crate 48x64;Diner chair;Diner bench;Diner table;Washer;Concrete barrier;Dumpster (close);Dumpster;Market stand;Refregirator;Refregirator (blue);Aerator;Satellite dish;Corrugated metal;Car part (yellow);Car (grey) (destroyed);Car (brown) (destroyed);Car (green) (destroyed);Car (grey) ;Wooden table;Palm;Palm",";");
	}
	if(level.script == "mp_countdown")
	{
		self.Lang["HNS"]["MODEL_NAME"][level.script] = strTOK("Aerator;ConstructionDumpster;Corrugated metal;Concrete barrier (tall);Shelf;Barrel (blue);Barrel (white);Barrel (black);Pallet;Plastic case (green);Plastic case;Plastic case green (little);Missile rack;Crate 24x24;Crate 32x48;Crate 64x64;Rock;Military tower;Sandbag (curved);Tree (stump);Tree (tall);Tree;BMP (destroyed);SA6;Pickup (destroyed)",";");
	}
	if(level.script == "mp_crash")
	{
		self.Lang["HNS"]["MODEL_NAME"][level.script] = strTOK("Phonebooth;Refregirator;Wooden chair;Cafe chair;Cafe table;Barrel (white);Barrel (blue);;Kitchen chair;Shelf;Stove;Stove with burner;Kitchen table;Kitchen table (small);Trashcan;Dresser (destroyed);Pallet stack;TV;Plastic case;Concrete barrier;Aerator;Aerator (window);Corrugated metal;Satellite dish;Dumpster (close);Diner bench;Diner table;Mattress;Couch (old);Bed frame metal;Sandbag (curved);Palm;Tree;Wooden table;Hesco barrier;Pickup (destroyed);Car (red) (destroyed);Car (brown);Car (green)",";");
	}
	if(level.script == "mp_crossfire")
	{
		self.Lang["HNS"]["MODEL_NAME"][level.script] = strTOK("Basket (rattan);Basket (wicker);Refregirator;Refregirator (blue);Dumpster (close);Dumpster;Aerator;Aerator (window);Satellite dish;Corrugated metal;Boiler;Wooden chair;Cafe chair;Cafe table (round);Cafe table;Folding chair;Folding table;Shelf;Stove with burner;Sink;Trashcan;Trashcan (full);TV;TV;Dresser;Dresser (destroyed);Plastic case;Barrel (blue);Barrel (black);Russian table;Washer;Diner bench;Diner table;Bed frame metal;Couch (new);Couch (old);Wooden table;Hesco barrier;Palm;Car (green) (destroyed);Car (grey) (destroyed);Car (grey) ;Car (green)",";");
	}
	if(level.script == "mp_citystreets")
	{
		self.Lang["HNS"]["MODEL_NAME"][level.script] = strTOK("Shelf ;Sink;Stove with burner;Trashcan;Wagon donkey;Mannequin;Wooden chair;Cafe chair;Cafe table;Pallet stack;Barrel (explosive);Barrel (white);Barrel (blue);Plastic case;Concrete barrier;Wood cage;Satellite dish;Aerator (window);Aerator;Corrugated metal;Dumpster (close);Basket (wicker);Gas pump;Refregirator;Refregirator (blue);Crate 32x48;Diner bench;Diner table;Couch (old);Bed frame metal;Palm;Sandbag (long);Wooden table;Car (orange);Car (grey) (destroyed);Car (red) (destroyed);Car (grey) ;Car (red)",";");
	}
	if(level.script == "mp_farm")
	{
		self.Lang["HNS"]["MODEL_NAME"][level.script] = strTOK("Refregirator;Dumpster;Dumpster (close);Shelf ;Sink;Barrel (white);Barrel (blue);Pallet stack;Dresser;Dresser (destroyed);Stove (destroyed);Wheelbarrow;Wooden chair;Propane tank;Satellite dish;Plastic case;TV;Bed frame metal;Washer;Hayroll;Lawnmower;Crate 64x64;Couch (old);Corrugated metal;Wooden table;Tree (river birch);Tree (stump) (big);Woodlog (destroyed);Tree (destroyed);Tree;Car (grey) (destroyed);Car (brown) (destroyed);Tractor plow;Tractor",";");
	}
	if(level.script == "mp_overgrown")
	{
		self.Lang["HNS"]["MODEL_NAME"][level.script] = strTOK("Shelf;Concrete barrier (tall);Sink;Stove (destroyed);Wooden chair;Bookshelves (destroyed);Barrel (white);Barrel (blue);Barrel (fire);Dresser (destroyed);Stove;Stove with burner;Armoire (destroyed);Plastic case;Bookshelves (big);Bookshelves;Couch (old);Russian table;Couch (new);Bed frame metal;Hayroll;Crate 32x48;Crate 48x64;Crate 64x64;Crate 24x36;Crate 24x24;Lamp;Gas pump;Refregirator (destroyed);Dumpster (close);Corrugated metal;Tractor;Car (Yellow);Car (brown) (destroyed);Woodlog (destroyed);Tree (stump) (big);Tree;Stump (big);Sandbag (curved);Sandbag (long);Rock",";");
	}
	if(level.script == "mp_pipeline")
	{
		self.Lang["HNS"]["MODEL_NAME"][level.script] = strTOK("Shelf ;File cabinet (open);Barrel (white);Barrel (blue);Pallet;Barrel (green);Propane tank;Pallet stack;Barrel (white);Plastic case;Folding table;Boiler;Transformer;File cabinet;Concrete barrier;Dumpster (close);Refregirator;Aerator;Corrugated metal;Gas pump;Desk;Crate 48x64;Mattress (bent);Crate 64x64;Crate 32x48;Wooden table;Car (green);Car (red);Car (red) (destroyed);Car (green) (destroyed);Bulldozer;Tree;Stump (big)",";");
	}
	if(level.script == "mp_shipment")
	{
		self.Lang["HNS"]["MODEL_NAME"][level.script] = strTOK("Barrel (blue);Barrel (green);Barrel (white);Pallet stack;Folding chair;Folding table;Trashcan (full);Trashcan;Bomb site (destroyed);Bomb site;Plastic case;Pallet (destroyed);Crane;Water tower;Cardboard box 1;Cardboard box 2;Cardboard box 3;Cardboard box 4;Cardboard box 5;Dumpster (close);Streetlight;Dumpster;Streetlight (double);me_docks_tank_03;me_docks_tank_02;me_docks_tank_01;Car (green) (destroyed);vehicle_80s_hatch1_yeldest;Delivery truck;Pickup;Pickup;vehicle_semi_truck_cargo;vehicle_80s_sedan1_red;Tanker truck_civ;vehicle_humvee_camo_50cal_nodoors;vehicle_Car (grey)_nodoor;Wooden table;foliage_tree_pine_xl_b;Crate 32x48",";");
	}
	if(level.script == "mp_showdown")
	{
		self.Lang["HNS"]["MODEL_NAME"][level.script] = strTOK("Wagon donkey;TV;Wheelbarrow;Barrel (white);Barrel (blue);Barrel (white);Trashcan;Trashcan (full);Plastic case;File cabinet;Industrial trash bin;com_cinderblockstack;Wood crate (little);Wood cage (little);Aerator (window);Satellite dish;Dumpster;Construction dumpster;Dumpster (close);Basket (wicker);Basket (wicker);Basket (rattan);Basket (wicker);Basket (wicker);Basket (rattan);Statue;Crate 24x24;Crate 64x64;Pickup;4x4;Bulldozer;Van;Car (grey);Palm",";");
	}
	if(level.script == "mp_strike")
	{
		self.Lang["HNS"]["MODEL_NAME"][level.script] = strTOK("Shelf;Cafe table;Cafe chair;Wooden chair;Folding table;Trashcan;Dresser;Boiler;Sink;Stove with burner;Plastic case;Phonebooth;Refregirator;Concrete barrier;Dumpster (close);Aerator (window);Aerator;Satellite dish;Corrugated metal;Basket (wicker);Gas pump;Couch (new);Bed frame metal;Washer;Tree;Palm 2;Wooden table;Hesco barrier;Sandbag (short);Car (brown);Car (green);Car (red) (destroyed);Car (green) (destroyed)",";");
	}
	if(level.script == "mp_vacant")
	{
		self.Lang["HNS"]["MODEL_NAME"][level.script] = strTOK("Bed;Barrel (white);Barrel (blue);Pallet;Conference table;Plastic case (green);File cabinet (open);Photocopier;File cabinet;Folding chair;Locker (double);Shelf ;Boiler;Folding table;Stove;Trashcan (full);Bench (wood);Urinal;Sheet chair;Plastic case;Computer;TV (black);Office chair;Lunch table;Couch (new);Crate 48x64;Desk;Mattress;Crate 32x48;Aerator;Refregirator;Satellite dish;Dumpster (close);Dumpster;Concrete barrier;Wooden table;Car (yellow);Car (green) (destroyed);Car (red) (destroyed);TV Table (half);TV Table;Tree (burned) (small);Tree",";");
	}
	if(level.script == "mp_cargoship")
	{
		self.Lang["HNS"]["MODEL_NAME"][level.script] = strTOK("Barrel (blue);Barrel (white);Bed;Folding chair;Folding table;Kitchen chair;Cargo Ship Monitor 1;Shelf ;Sink;TV;Cargo Ship Monitor 2;Jeep UAZ;Cardboard box;Plastic case;Bomb site;Bomb site (destroyed);Barrel (black);Aerator (window);Radiator;Locker (double);Cargo Ship Steering wheel;Cargo Ship door",";");
	}


}




FRENCH_HNS_LANG()
{
	if(level.script == "mp_convoy")
	{
		self.Lang["HNS"]["MODEL_NAME"][level.script] = strTOK("Aerateur;Barriere en beton;me_dumpster_close;me_refrigerator;me_satellitedish;me_rooftop_tank_01;me_corrugated_metal8x8;com_northafrica_armoire_short;com_cafe_table2;com_cafe_chair2;com_cafe_chair;com_barrel_fire;com_barrel_white_rust;com_barrel_blue_rust;com_stove;com_water_tower;com_pallet_2;com_bomb_objective;com_bomb_objective_d;ch_mattress_bent_1;vehicle_bulldozer;vehicle_uaz_light_dsr;vehicle_80s_sedan1_yeldest;vehicle_humvee_camo_static;mil_sandbag_desert_curved;mil_sandbag_desert_short;mil_sandbag_desert_long;foliage_tree_palm_bushy_1;foliage_tree_palm_bushy_2;foliage_tree_palm_bushy_3;foliage_tree_palm_tall_3foliage_tree_river_birch_xl_a;foliage_tree_river_birch_lg_a;foliage_dead_pine_med;foliage_dead_pine_sm",";");
	}
	if(level.script == "mp_backlot")
	{
		self.Lang["HNS"]["MODEL_NAME"][level.script] = strTOK("me_ac_big;me_concrete_barrier;me_refrigerator2;me_satellitedish;me_dumpster_close;me_gas_pump;me_corrugated_metal8x8;me_ac_window;com_bike;com_water_heater;com_cafe_table2;com_cafe_chair2;com_wheelbarrow;com_cafe_chair;com_pallet;com_pallet_2;com_pallet_stack;com_barrel_blue_rust;com_barrel_white_rust;com_barrel_corrosive_rust;com_restaurantstainlessteelshelf_02;com_folding_chair;com_water_tank1;com_dresser_d;com_bomb_objective;com_bomb_objective_d;com_plasticcase_beige_big;ch_dinerboothchair;ch_dinercounterchair;ch_dinerboothtable;ch_furniture_couch02;ch_furniture_couch01;ch_washer_01;ch_mattress_boxspring;ch_bedframemetal_gray;ch_russian_table;ch_mattress_2;bc_hesco_barrier_med;foliage_tree_palm_bushy_3_static;foliage_tree_river_birch_xl_a;vehicle_bulldozer;vehicle_bmp_dsty_static;vehicle_80s_sedan1_reddest;vehicle_80s_sedan1_silvdest;vehicle_80s_sedan1_yeldest;vehicle_80s_sedan1_silv_destructible_mp;vehicle_80s_sedan1_yel_destructible_mp;vehicle_80s_wagon1_brn_destructible_mp",";");
	}
	if(level.script == "mp_bloc")
	{
		self.Lang["HNS"]["MODEL_NAME"][level.script] = strTOK("com_bench;com_metalbench;com_cafe_chair2;com_cafe_chair;com_plainchair;com_barrier_tall1;com_folding_table;com_restaurantchair_2;com_locker_open;com_locker_double;com_locker_single;com_barrel_fire;com_office_book_shelf;com_playpen;com_barrel_white_rust;com_dresser_d;com_bookshelves1_d;com_armoire_d;com_stove;com_plasticcase_beige_big;com_bomb_objective;com_bomb_objective_d;ch_baby_carriage;ch_mattress_2;ch_mattress_3;ch_mattress_bent_2;ch_mattress_bent_1;ch_russian_table;ch_radiator01;ch_mattress_boxspring;ch_bedframemetal_gray;ch_furniture_couch01;ch_crate24x24;ch_crate32x48;ch_crate64x64;ch_crate48x64;me_concrete_barrier;me_refrigerator;me_refrigerator_d;mil_sandbag_desert_long;mil_sandbag_desert_curved;foliage_red_pine_lg;foliage_red_pine_med;foliage_red_pine_xxl;foliage_red_pine_xl;vehicle_80s_sedan1_yeldest;vehicle_80s_hatch1_reddest;vehicle_80s_wagon1_tandest;prop_misc_rock_boulder_snow_03;prop_misc_rock_boulder_snow_05",";");
	}
	if(level.script == "mp_bog")
	{
		self.Lang["HNS"]["MODEL_NAME"][level.script] = strTOK("com_barrel_white_rust;com_barrel_black_rust;com_barrel_blue_rust;com_barrel_green;com_barrel_black;com_barrel_fire;com_trashcan_metal_with_trash;com_trashcan_metal;com_water_heater;com_water_tank1;com_cafe_table1;com_cafe_chair;com_restaurantsink_1comp;com_restaurantstove;com_wagon_donkey;com_bomb_objective_d;com_bomb_objective;com_plasticcase_beige_big;ch_crate48x64;ch_dinercounterchair;ch_dinerboothchair;ch_dinerboothtable;ch_washer_01;me_concrete_barrier;me_dumpster_close;me_dumpster;me_market_stand4;me_refrigerator;me_refrigerator2;me_ac_big;me_market_stand1;me_satellitedish;me_corrugated_metal8x8;vehicle_bus_destructable;vehicle_pickup_nodoor_static;vehicle_m1a1_abrams_dmg;vehicle_bulldozer;vehicle_80s_hatch2_yeldest;vehicle_80s_sedan1_silvdest;vehicle_80s_sedan1_tandest;vehicle_80s_hatch1_greendest;vehicle_80s_sedan1_silv_destructible_mp;bc_militarytent_wood_table;foliage_tree_palm_bushy_1_static;foliage_tree_palm_bushy_2_static",";");
	}
	if(level.script == "mp_countdown")
	{
		self.Lang["HNS"]["MODEL_NAME"][level.script] = strTOK("me_ac_big;me_construction_dumpster_close;me_corrugated_metal4x8;com_barrier_tall1;com_restaurantstainlessteelshelf_01;com_barrel_blue_rust;com_barrel_tan_rust;com_barrel_white_rust;com_barrel_green_rust;com_barrel_black_rust;com_pallet_2;com_plasticcase_green_big;com_plasticcase_beige_big;com_plasticcase_green_rifle;com_bomb_objective;com_bomb_objective_d;projectile_sa6_missile_woodland;ch_missle_rack;ch_crate24x24;ch_crate32x48;ch_crate64x64;ch_roadrock_01;ch_roadrock_03;ch_roadrock_04;ch_roadrock_05;ch_roadrock_06;ch_roadrock_07;bc_military_comm_tower;mil_sandbag_desert_curved;foliage_red_pine_stump_sm;foliage_red_pine_med;foliage_red_pine_xxl;foliage_red_pine_xl;foliage_red_pine_sm;foliage_red_pine_lg;vehicle_tanker_truck;vehicle_tanker_truck_d;vehicle_bmp_dsty_static;vehicle_semi_truck_trailer;vehicle_sa6_static_woodland;vehicle_mi24p_hind_desert_destroy;vehicle_pickup_technical_destroyed",";");
	}
	if(level.script == "mp_crash")
	{
		self.Lang["HNS"]["MODEL_NAME"][level.script] = strTOK("me_phonebooth;me_refrigerator;com_cafe_chair;com_cafe_chair2;com_cafe_table2;com_barrel_green;com_barrel_white_rust;com_barrel_biohazard_rust;com_barrel_blue_rust;com_restaurantchair_1;com_restaurantchair_2;com_restaurantstainlessteelshelf_02;com_restaurantstove;com_restaurantstovewithburner;com_restaurantkitchentable_1;com_restaurantkitchentable_4;com_trashcan_metal;com_dresser_d;com_water_tank1;com_water_tower;com_bomb_objective;com_bomb_objective_d;com_pallet_2;com_pallet_stack;com_tv1;com_signal_light_pole;com_plasticcase_beige_big;me_concrete_barrier;me_ac_big;me_ac_window;me_corrugated_metal8x8;me_satellitedish;me_dumpster_close;me_mosque_tower02;ch_dinerboothchair;ch_dinerboothtable;ch_dinerboothtable_2;ch_mattress_2;ch_furniture_couch02;ch_bedframemetal_gray;mil_sandbag_desert_short;mil_sandbag_desert_curved;foliage_tree_palm_bushy_3_static;foliage_tree_river_birch_med_a;foliage_tree_river_birch_lg_b;foliage_tree_river_birch_xl_a;bc_militarytent_wood_table;bc_hesco_barrier_med;vehicle_pickup_technical_destroyed;vehicle_80s_sedan1_greendest;vehicle_ch46e_damaged_rear_piece;vehicle_ch46e_damaged_front_piece;vehicle_80s_sedan1_green_destroyed;vehicle_80s_sedan1_red_destroyed;vehicle_80s_sedan1_brn_destroyed;vehicle_80s_sedan1_red_destructible_mp;vehicle_80s_sedan1_brn_destructible_mp;vehicle_80s_sedan1_green_destructible_mp",";");
	}
	if(level.script == "mp_crossfire")
	{
		self.Lang["HNS"]["MODEL_NAME"][level.script] = strTOK("me_basket_rattan01;me_basket_wicker01;me_refrigerator;me_refrigerator2;me_dumpster_close;me_dumpster;me_ac_big;me_ac_window;me_satellitedish;me_market_stand1;me_corrugated_metal8x8;com_water_heater;com_water_tank1;com_cafe_chair;com_cafe_chair2;com_cafe_table1;com_cafe_table2;com_folding_chair;com_folding_table;com_restaurantstainlessteelshelf_01;com_restaurantstainlessteelshelf_02;com_restaurantstovewithburner;com_restaurantsink_2comps;com_trashcan_metal;com_trashcan_metal_with_trash;com_tv2;com_tv1;com_dresser;com_dresser_d;com_locker_double;com_locker_open;com_bomb_objective_d;com_bomb_objective;com_plasticcase_beige_big;com_barrel_blue_rust;com_barrel_black_rust;com_barrel_black;ch_russian_table;ch_washer_01;ch_dinerboothchair;ch_dinerboothtable;ch_mattress_2;ch_mattress_3;ch_mattress_bent_1;ch_mattress_bent_2;ch_mattress_boxspring;ch_bedframemetal_gray;ch_furniture_couch01;ch_furniture_couch02;bc_militarytent_wood_table;bc_hesco_barrier_med;foliage_tree_palm_bushy_1;foliage_tree_palm_tall_1;vehicle_80s_sedan1_tandest;vehicle_bus_destructable;vehicle_80s_sedan1_green_destroyed;vehicle_80s_sedan1_brn_destroyed;vehicle_80s_sedan1_silv_destroyed;vehicle_80s_sedan1_silv_destructible_mp;vehicle_80s_sedan1_brn_destructible_mp;vehicle_80s_sedan1_green_destructible_mp",";");
	}
	if(level.script == "mp_citystreets")
	{
		self.Lang["HNS"]["MODEL_NAME"][level.script] = strTOK("com_vending_can_new1_lit;com_vending_can_old2_lit;com_restaurantstainlessteelshelf_01;com_restaurantstainlessteelshelf_02;com_restaurantsink_2comps;com_restaurantstovewithburner;com_trashcan_metal;com_wagon_donkey_nohandle;com_water_tank1;com_mannequin1;com_mannequin3;com_cafe_chair;com_cafe_chair2;com_cafe_table2;com_pallet_2;com_pallet_stack;com_pallet_destroyed;com_barrel_benzin;com_barrel_white_rust;com_barrel_corrosive_rust;com_barrel_blue_rust;com_bomb_objective_d;com_bomb_objective;com_plasticcase_beige_big;me_concrete_barrier;me_wood_cage_large;me_satellitedish;me_ac_window;me_ac_big;me_corrugated_metal8x8;me_dumpster_close;me_basket_wicker05;me_basket_wicker07;me_basket_wicker04;me_gas_pump;me_mosque_tower02;me_refrigerator;me_refrigerator2;ch_crate32x48;ch_dinerboothchair;ch_dinerboothtable;ch_dinerboothtable_2;ch_furniture_couch02;ch_mattress_3;ch_bedframemetal_gray;foliage_tree_palm_bushy_1;foliage_tree_palm_med_1;mil_sandbag_desert_long;mil_sandbag_desert_short;bc_militarytent_wood_table;vehicle_delivery_truck;vehicle_80s_wagon1_brndest;vehicle_80s_sedan1_reddest;vehicle_80s_hatch2_tan;vehicle_80s_sedan1_green_destroyed;vehicle_80s_sedan1_silv_destroyed;vehicle_80s_wagon1_brn_destroyed;vehicle_80s_sedan1_red_destroyed;vehicle_80s_sedan1_yel_destroyed;vehicle_80s_sedan1_silv_destructible_mp;vehicle_80s_sedan1_yel_destructible_mp;vehicle_80s_wagon1_brn_destructible_mp;vehicle_80s_sedan1_red_destructible_mp",";");
	}
	if(level.script == "mp_farm")
	{
		self.Lang["HNS"]["MODEL_NAME"][level.script] = strTOK("me_refrigerator;me_dumpster;me_dumpster_close;com_restaurantstainlessteelshelf_02;com_restaurantsink_2comps;com_restaurantsink_1comp;com_barrel_white_rust;com_barrel_blue_rust;com_barrel_biohazard_rust;com_woodlog_16_192_d;com_woodlog_24_96_d;com_woodlog_24_192_d;com_pallet;com_pallet_2;com_pallet_stack;com_pallet_destroyed;com_bomb_objective;com_bomb_objective_d;com_dresser;com_dresser_d;com_stove_d;com_wheelbarrow;com_cafe_chair;com_propane_tank02;com_wall_fan;com_satellite_dish_big;com_plasticcase_beige_big;com_tv2;ch_mattress_3;ch_bedframemetal_gray;ch_washer_01;ch_hayroll_03;ch_wood_fence_128;ch_post_fence_128;ch_lawnmower;ch_mattress_bent_2;ch_mattress_boxspring;ch_russian_table_no_top;ch_russian_table_cloth3;ch_crate64x64;ch_furniture_couch02;me_corrugated_metal8x8;me_construction_dumpster_close;me_market_stand1;bc_militarytent_wood_table;foliage_tree_grey_oak_xl_a;foliage_tree_river_birch_xl_a;foliage_tree_river_birch_med_a;foliage_tree_river_birch_lg_a;foliage_red_pine_stump_sm;foliage_red_pine_stump_xl;foliage_red_pine_stump_lg;foliage_red_pine_log_med;foliage_red_pine_sm;foliage_red_pine_med;foliage_red_pine_lg;foliage_tree_pine_sm_b;foliage_tree_destroyed_fallen_log_a;foliage_tree_destroyed_tree_a;foliage_tree_destroyed_tree_b;foliage_tree_pine_lg_b;foliage_dead_pine_lg;foliage_dead_pine_xl;foliage_dead_pine_sm;foliage_dead_pine_med;vehicle_bm21_mobile_bed_dstry;vehicle_uaz_fabric_dsr;vehicle_bm21_mobile_cover_dstry_static;vehicle_80s_hatch1_silvdest;vehicle_80s_sedan1_tandest;vehicle_80s_hatch2_brndest;vehicle_tractor_plow;vehicle_tractor;vehicle_bulldozer;vehicle_tractor_2",";");
	}
	if(level.script == "mp_overgrown")
	{
		self.Lang["HNS"]["MODEL_NAME"][level.script] = strTOK("com_barrier_tall1;com_restaurantstainlessteelshelf_02;com_restaurantsink_1comp;com_stove_d;com_cafe_chair;com_bookshelves1_d;com_barrel_white_rust;com_barrel_blue_rust;com_barrel_fire;com_dresser_d;com_restaurantstove;com_restaurantstovewithburner;com_armoire_d;com_plasticcase_beige_big;com_bomb_objective_d;com_bomb_objective;com_pallet;com_pallet_2;com_woodlog_16_192_d;com_woodlog_24_96_d;com_woodlog_24_192_d;com_propane_tank02;com_woodlog_24_96_a;com_bookshelveswide;com_bookshelves1;ch_furniture_couch02;ch_mattress_2;ch_russian_table;ch_mattress_boxspring;ch_furniture_couch01;ch_bedframemetal_gray;ch_mattress_3;ch_hayroll_02;ch_crate32x48;ch_crate48x64;ch_crate64x64;ch_crate24x36;ch_crate24x24;ch_post_fence_128;ch_russian_table_no_top;ch_russian_table_cloth2;ch_street_light_01_off;me_gas_pump;me_refrigerator_d;me_dumpster_close;me_corrugated_metal8x8;vehicle_bmp_dsty_static;vehicle_tanker_truck_d;vehicle_uaz_hardtop_dsr;vehicle_tractor;vehicle_80s_sedan1_yeldest;vehicle_80s_wagon1_tandest;vehicle_80s_wagon1_brndest;foliage_red_pine_med;foliage_red_pine_xxl;foliage_tree_river_birch_lg_a;foliage_red_pine_xl;foliage_tree_destroyed_fallen_log_a;foliage_red_pine_stump_xl;foliage_red_pine_stump_sm;foliage_red_pine_lg;foliage_tree_river_birch_xl_a;foliage_tree_grey_oak_xl_a;foliage_red_pine_stump_lg;mil_sandbag_desert_short;mil_sandbag_desert_curved;mil_sandbag_desert_long;prop_misc_rock_boulder_05;prop_misc_rock_boulder_04",";");
	}
	if(level.script == "mp_pipeline")
	{
		self.Lang["HNS"]["MODEL_NAME"][level.script] = strTOK("com_restaurantstainlessteelshelf_02;com_filecabinetblackopen;com_locker_double;com_locker_open;com_locker_single;com_barrel_white_rust;com_barrel_blue_rust;com_pallet_2;com_barrel_green_dirt;com_propane_tank02;com_pallet_stack;com_barrel_biohazard_rust;com_bomb_objective_d;com_bomb_objective;com_plasticcase_beige_big;com_folding_table;com_water_heater;com_electrical_transformer;com_filecabinetblackclosed;com_prop_rail_wheeltrack;com_prop_rail_woodboxcar_open;com_prop_rail_fuelcar;me_concrete_barrier;me_dumpster_close;me_refrigerator;me_ac_big;me_corrugated_metal8x8;ch_gas_pump;ch_furniture_teachers_desk1;ch_crate48x64;ch_mattress_bent_2;ch_crate64x64;ch_crate32x48;bc_militarytent_wood_table;vehicle_80s_sedan1_green_destructible_mp;vehicle_80s_hatch1_red_destructible_mp;vehicle_80s_hatch1_red_destroyed;vehicle_80s_sedan1_green_destroyed;vehicle_pickup_roobars;vehicle_80s_hatch1_tandest;vehicle_80s_hatch1_reddest;vehicle_80s_sedan1_brndest;vehicle_80s_sedan1_greendest;vehicle_delivery_truck;vehicle_bulldozer;foliage_tree_pine_lg_b;foliage_tree_grey_oak_xl_a;foliage_tree_river_birch_med_a;foliage_tree_grey_oak_lg_a;foliage_red_pine_xl;foliage_red_pine_xxl;foliage_red_pine_med;foliage_red_pine_sm;foliage_red_pine_log_med;foliage_red_pine_stump_lg",";");
	}
	if(level.script == "mp_shipment")
	{
		self.Lang["HNS"]["MODEL_NAME"][level.script] = strTOK("com_barrel_blue_rust;com_barrel_green_rust;com_barrel_biohazard_rust;com_pallet_stack;com_folding_chair;com_folding_table;com_trashcan_metal_with_trash;com_trashcan_metal;com_bomb_objective_d;com_bomb_objective;com_plasticcase_beige_big;com_pallet_destroyed;com_tower_crane;com_water_tower;com_cardboardbox01;com_cardboardbox02;com_cardboardbox03;com_cardboardbox04;com_cardboardbox06;me_dumpster_close;me_streetlight;me_dumpster;me_streetlightdual_on;me_docks_tank_03;me_docks_tank_02;me_docks_tank_01;vehicle_80s_sedan1_greendest;vehicle_80s_hatch1_yeldest;vehicle_delivery_truck;vehicle_pickup_roobars;vehicle_pickup_4door_static;vehicle_semi_truck_cargo;vehicle_80s_sedan1_red;vehicle_tanker_truck_civ;vehicle_humvee_camo_50cal_nodoors;vehicle_pickup_nodoor;bc_militarytent_wood_table;foliage_tree_pine_xl_b;ch_crate32x48",";");
	}
	if(level.script == "mp_showdown")
	{
		self.Lang["HNS"]["MODEL_NAME"][level.script] = strTOK("com_wagon_donkey;com_tv2;com_wheelbarrow;com_barrel_white_rust;com_barrel_blue_rust;com_barrel_white_rust;com_trashcan_metal;com_trashcan_metal_with_trash;com_water_tank1;com_tower_crane;com_bomb_objective;com_bomb_objective_d;com_plasticcase_beige_big;com_trashchuteslide;com_filecabinetblackclosed;com_industrialtrashbin;com_cinderblockstack;me_woodcrateclosed;me_wood_cage_small;me_ac_window;me_satellitedish;me_mosque_tower02;me_dumpster;me_construction_dumpster_open;me_dumpster_close;me_basket_wicker03;me_basket_wicker05;me_basket_rattan02;me_basket_wicker08;me_basket_wicker01;me_basket_rattan01;me_statue;ch_crate24x24;ch_crate64x64;vehicle_pickup_4door_static;vehicle_pickup_nodoor_static;vehicle_bulldozer;vehicle_uaz_van;vehicle_80s_sedan1_silv;foliage_tree_palm_bushy_1_static;foliage_tree_palm_bushy_2_static;foliage_tree_palm_bushy_3_static;foliage_tree_palm_tall_3_static;foliage_tree_palm_tall_2_static;foliage_tree_palm_tall_1_static",";");
	}
	if(level.script == "mp_strike")
	{
		self.Lang["HNS"]["MODEL_NAME"][level.script] = strTOK("com_coffee_machine;com_vending_can_old1;com_vending_can_old2;com_cafe_table2;com_cafe_chair2;com_cafe_chair;com_folding_table;com_trashcan_metal;com_dresser;com_water_heater;com_water_tank1;com_restaurantstainlessteelshelf_01;com_restaurantstainlessteelshelf_02;com_restaurantsink_2comps;com_restaurantstovewithburner;com_bomb_objective_d;com_bomb_objective;com_plasticcase_beige_big;me_phonebooth;me_refrigerator;me_concrete_barrier;me_dumpster_close;me_ac_window;me_ac_big;me_satellitedish;me_statue;me_corrugated_metal8x8;me_basket_wicker05;me_mosque_tower02;ch_gas_pump;ch_furniture_couch01;ch_bedframemetal_gray;ch_mattress_2;ch_washer_01;ch_mattress_boxspring;foliage_tree_river_birch_xl_a;foliage_tree_palm_bushy_2;bc_militarytent_wood_table;bc_hesco_barrier_med;vehicle_80s_sedan1_brndest;vehicle_80s_sedan1_brn_destructible_mp;vehicle_80s_sedan1_green_destructible_mp;vehicle_80s_sedan1_greendest;vehicle_80s_sedan1_reddest;vehicle_80s_sedan1_green_destroyed;vehicle_80s_sedan1_brn_destroyed;mil_sandbag_desert_short",";");
	}
	if(level.script == "mp_vacant")
	{
		self.Lang["HNS"]["MODEL_NAME"][level.script] = strTOK("mil_bunker_bed3;com_barrel_white_rust;com_barrel_blue_rust;com_pallet_2;com_conference_table1;com_plasticcase_green_big;com_filecabinetblackopen;com_photocopier;com_filecabinetblackclosed;com_folding_chair;com_locker_double;com_locker_open;com_locker_single;com_restaurantstainlessteelshelf_02;com_water_heater;com_folding_table;com_stove;com_trashcan_metal_with_trash;com_bench;com_coffee_machine;com_vending_can_old2;com_propane_tank02;com_industrialtrashbin;com_bomb_objective_d;com_bomb_objective;com_pallet_destroyed;com_urinal_trough;com_sheet_chair;com_vending_can_old1;com_plasticcase_beige_big;com_computer_case;com_tv2_d;com_office_chair_black;ch_furniture_school_lunch_table;ch_furniture_couch01;ch_crate48x64;ch_furniture_teachers_desk1;ch_mattress_2;ch_crate32x48;ch_mattress_boxspring;me_ac_big;me_refrigerator;me_satellitedish;me_dumpster_close;me_dumpster;me_concrete_barrier;bc_militarytent_wood_table;vehicle_80s_sedan1_yeldest;vehicle_uaz_hardtop_static;vehicle_uaz_van;vehicle_delivery_truck;vehicle_semi_truck_cargo;vehicle_tanker_truck_d;vehicle_80s_sedan1_silv_destructible_mp;vehicle_80s_sedan1_green_destructible_mp;vehicle_80s_sedan1_red_destructible_mp;vehicle_80s_sedan1_yel_destructible_mp;vehicle_80s_sedan1_green_destroyed;vehicle_80s_hatch1_green_destroyed;vehicle_80s_sedan1_silv_destroyed;vehicle_80s_sedan1_yel_destroyed;vehicle_80s_sedan1_red_destroyed;tvs_cubicle_round_half_1;tvs_cubicle_round_1;foliage_tree_river_birch_med_a;foliage_tree_grey_oak_sm_a;foliage_dead_pine_sm;foliage_tree_river_birch_xl_a",";");
	}
	if(level.script == "mp_cargoship")
	{
		self.Lang["HNS"]["MODEL_NAME"][level.script] = strTOK("com_barrel_blue_rust;com_barrel_white_rust;mil_bunker_bed2;com_folding_chair;com_folding_table;com_restaurantchair_2;cs_monitor1;com_restaurantstainlessteelshelf_02;com_restaurantsink_2comps;com_tv1;cs_monitor2;vehicle_uaz_hardtop;com_cardboardbox04;com_plasticcase_beige_big;com_bomb_objective;com_bomb_objective_d;com_barrel_black_rust;me_ac_window;ch_radiator01;com_locker_double;cs_steeringwheel;com_airduct_square;cs_cargoship_door_pull",";");
	}
}















