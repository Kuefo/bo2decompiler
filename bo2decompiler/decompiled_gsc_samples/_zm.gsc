// maps/mp/zombies/_zm.gsc

#include maps\mp\zombies\_zm_game_module;
#include maps\mp\zombies\_zm_ai_basic;
#include maps\mp\gametypes_zm\_weapons;
#include maps\mp\zombies\_zm_pers_upgrades_system;
#include maps\mp\zombies\_zm_ai_dogs;
#include maps\mp\zombies\_zm_melee_weapon;
#include maps\mp\gametypes_zm\_hud_util;
#include maps\mp\zombies\_zm_pers_upgrades_functions;
#include maps\mp\_demo;
#include maps\mp\gametypes_zm\_zm_gametype;
#include maps\mp\zombies\_zm_pers_upgrades;
#include maps\mp\zombies\_zm_stats;
#include maps\mp\zombies\_zm_tombstone;
#include maps\mp\zombies\_zm_weapons;
#include maps\mp\zombies\_zm_traps;
#include maps\mp\zombies\_zm_timer;
#include maps\mp\zombies\_zm_gump;
#include maps\mp\zombies\_zm_spawner;
#include maps\mp\zombies\_zm_score;
#include maps\mp\zombies\_zm_powerups;
#include maps\mp\zombies\_zm_power;
#include maps\mp\zombies\_zm_playerhealth;
#include maps\mp\zombies\_zm_perks;
#include maps\mp\zombies\_zm_magicbox;
#include maps\mp\zombies\_zm_laststand;
#include maps\mp\zombies\_zm_equipment;
#include maps\mp\zombies\_zm_buildables;
#include maps\mp\zombies\_zm_clone;
#include maps\mp\zombies\_zm_bot;
#include maps\mp\zombies\_zm_blockers;
#include maps\mp\zombies\_zm_audio;
#include maps\mp\zombies\_zm_unitrigger;
#include maps\mp\zombies\_zm_zonemgr;
#include maps\mp\zombies\_zm_devgui;
#include maps\mp\_visionset_mgr;
#include maps\mp\zombies\_zm;
#include maps\mp\zombies\_zm_ffotd;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\_utility;
#include common_scripts\utility;


// 0x8178
init()
{
	level.player_out_of_playable_area_monitor = 1;
	level.player_too_many_weapons_monitor = 1;
	level.player_too_many_weapons_monitor_func = ::player_too_many_weapons_monitor;
	level.player_too_many_players_check = 1;
	level.player_too_many_players_check_func = ::player_too_many_players_check;
	level._use_choke_weapon_hints = 1;
	level._use_choke_blockers = 1;
	level.passed_introscreen = 0;
	level.custom_ai_type = [];
	level.custom_ai_spawn_check_funcs = [];
	level.spawn_funcs = [];
	level.spawn_funcs["allies"] = [];
	level.spawn_funcs["axis"] = [];
	level.spawn_funcs["team3"] = [];
	level thread maps/mp/zombies/_zm_ffotd::main_start();
	level.zombiemode = 1;
	level.revivefeature = 0;
	level.swimmingfeature = 0;
	level.calc_closest_player_using_paths = 0;
	level.zombie_melee_in_water = 1;
	level.put_timed_out_zombies_back_in_queue = 1;
	level.use_alternate_poi_positioning = 1;
	level.zmb_laugh_alias = "zmb_laugh_richtofen";
	level.sndannouncerisrich = 1;
	level.scr_zm_ui_gametype = GetDvar( #"0x41651E" );
	level.scr_zm_ui_gametype_group = GetDvar( #"0x6B64B9B4" );
	level.scr_zm_map_start_location = GetDvar( #"0xC955B4CD" );
	level.curr_gametype_affects_rank = 0;
	gametype = tolower( GetDvar( #"0x4F118387" ) );
	level.curr_gametype_affects_rank = 1;
	level.grenade_multiattack_bookmark_count = 1;
	level.rampage_bookmark_kill_times_count = 3;
	level.rampage_bookmark_kill_times_msec = 6000;
	level.rampage_bookmark_kill_times_delay = 6000;
	level thread watch_rampage_bookmark();
	level._zombies_round_spawn_failsafe = ::round_spawn_failsafe;
	level.zombie_visionset = "zombie_neutral";
	level.zombie_anim_intro = 1;
	level.zombie_anim_intro = 0;
	precache_shaders();
	precache_models();
	precacherumble( "explosion_generic" );
	precacherumble( "dtp_rumble" );
	precacherumble( "slide_rumble" );
	precache_zombie_leaderboards();
	level._zombie_gib_piece_index_all = 0;
	level._zombie_gib_piece_index_right_arm = 1;
	level._zombie_gib_piece_index_left_arm = 2;
	level._zombie_gib_piece_index_right_leg = 3;
	level._zombie_gib_piece_index_left_leg = 4;
	level._zombie_gib_piece_index_head = 5;
	level._zombie_gib_piece_index_guts = 6;
	level.zombie_ai_limit = 24;
	level.zombie_actor_limit = 31;
	maps/mp/_visionset_mgr::init();
	init_dvars();
	init_strings();
	init_levelvars();
	init_sounds();
	init_shellshocks();
	init_flags();
	init_client_flags();
	registerclientfield( "world", "zombie_power_on", 1, 1, "int" );
	registerclientfield( "allplayers", "navcard_held", 1, 4, "int" );
	level.navcards = [];
	level.navcards[0] = "navcard_held_zm_transit";
	level.navcards[1] = "navcard_held_zm_highrise";
	level thread setup_player_navcard_hud();
	register_offhand_weapons_for_level_defaults();
	level thread drive_client_connected_notifies();
/#
	maps/mp/zombies/_zm_devgui::init();
#/
	maps/mp/zombies/_zm_zonemgr::init();
	maps/mp/zombies/_zm_unitrigger::init();
	maps/mp/zombies/_zm_audio::init();
	maps/mp/zombies/_zm_blockers::init();
	maps/mp/zombies/_zm_bot::init();
	maps/mp/zombies/_zm_clone::init();
	maps/mp/zombies/_zm_buildables::init();
	maps/mp/zombies/_zm_equipment::init();
	maps/mp/zombies/_zm_laststand::init();
	maps/mp/zombies/_zm_magicbox::init();
	maps/mp/zombies/_zm_perks::init();
	maps/mp/zombies/_zm_playerhealth::init();
	maps/mp/zombies/_zm_power::init();
	maps/mp/zombies/_zm_powerups::init();
	maps/mp/zombies/_zm_score::init();
	maps/mp/zombies/_zm_spawner::init();
	maps/mp/zombies/_zm_gump::init();
	maps/mp/zombies/_zm_timer::init();
	maps/mp/zombies/_zm_traps::init();
	maps/mp/zombies/_zm_weapons::init();
	init_function_overrides();
	level thread last_stand_pistol_rank_init();
	level thread maps/mp/zombies/_zm_tombstone::init();
	level thread post_all_players_connected();
	init_utility();
	maps/mp/_utility::registerclientsys( "lsm" );
	maps/mp/zombies/_zm_stats::init();
	initializestattracking();
	incrementcounter( "global_solo_games", 1 );
	incrementcounter( "global_systemlink_games", 1 );
	incrementcounter( "global_splitscreen_games", 1 );
	incrementcounter( "global_coop_games", 1 );
	onplayerconnect_callback( ::zm_on_player_connect );
	maps/mp/zombies/_zm_pers_upgrades::pers_upgrade_init();
	set_demo_intermission_point();
	level thread maps/mp/zombies/_zm_ffotd::main_end();
	level thread track_players_intersection_tracker();
	level thread onallplayersready();
	level thread startunitriggers();
	level thread maps/mp/gametypes_zm/_zm_gametype::post_init_gametype();
// SP = 0x0 - check OK
}

// 0x8624
post_main()
{
	level thread init_custom_ai_type();
// SP = 0x0 - check OK
}

// 0x8638
startunitriggers()
{
	flag_wait_any( "start_zombie_round_logic", "start_encounters_match_logic" );
	level thread maps/mp/zombies/_zm_unitrigger::main();
// SP = 0x0 - check OK
}

// 0x865C
drive_client_connected_notifies()
{
	level waittill( "connected", player );
	player reset_rampage_bookmark_kill_times();
	player callback( "on_player_connect" );
// SP = 0x0 - check OK
}

// 0x8694
fade_out_intro_screen_zm( hold_black_time, fade_out_time, destroyed_afterwards )
{
	level.introscreen = newhudelem();
	level.introscreen.x = 0;
	level.introscreen.y = 0;
	level.introscreen.horzalign = "fullscreen";
	level.introscreen.vertalign = "fullscreen";
	level.introscreen.foreground = 0;
	level.introscreen setshader( "black", 640, 480 );
	level.introscreen.immunetodemogamehudsettings = 1;
	level.introscreen.immunetodemofreecamera = 1;
	wait 0.05;
	level.introscreen.alpha = 1;
	wait hold_black_time;
	wait 0.2;
	fade_out_time = 1.5;
	level.introscreen fadeovertime( fade_out_time );
	level.introscreen.alpha = 0;
	wait 1.6;
	level.passed_introscreen = 1;
	players = get_players();
	i = 0;
	players[i] setclientuivisibilityflag( "hud_visible", 1 );
	players[i] freezecontrols( level.player_movement_suppressed );
/#
	println( " Unfreeze controls 4" );
#/
	players[i] freezecontrols( 0 );
/#
	println( " Unfreeze controls 5" );
#/
	i++;
	level.introscreen destroy();
	flag_set( "initial_blackscreen_passed" );
// SP = 0x0 - check OK
}

// 0x8854
onallplayersready()
{
	timeout = GetTime() + 5000;
	wait 0.1;
/#
	println( "ZM >> player_count_expected=" + getnumexpectedplayers() );
#/
	player_count_actual = 0;
	players = get_players();
	player_count_actual = 0;
	i = 0;
	players[i] freezecontrols( 1 );
	player_count_actual++;
	i++;
/#
	println( "ZM >> Num Connected =" + getnumconnectedplayers() + " Expected : " + getnumexpectedplayers() );
#/
	wait 0.1;
	setinitialplayersconnected();
/#
	println( "ZM >> We have all players - START ZOMBIE LOGIC" );
#/
	level thread add_bots();
	flag_set( "initial_players_connected" );
	players = get_players();
	flag_set( "solo_game" );
	level.solo_lives_given = 0;
	foreach ( player in players )
	{
		player.lives = 0;
	}
	level maps/mp/zombies/_zm::zombiemode_solo_last_stand_pistol();
	flag_set( "initial_players_connected" );
	wait 0.05;
	thread start_zombie_logic_in_x_sec( 3 );
	fade_out_intro_screen_zm( 5, 1.5, 1 );
// SP = 0x0 - check OK
}

// 0x8A48
start_zombie_logic_in_x_sec( time_to_wait )
{
	wait time_to_wait;
	flag_set( "start_zombie_round_logic" );
// SP = 0x0 - check OK
}

// 0x8A64
getallotherplayers()
{
	aliveplayers = [];
	i = 0;
	player = level.players[i];
	aliveplayers[aliveplayers.size] = player;
	i++;
	return aliveplayers;
// SP = 0x0 - check OK
}

// 0x8ACC
getfreespawnpoint( spawnpoints, player )
{
/#
	iprintlnbold( "ZM >> No free spawn points in map" );
#/
	return undefined;
	game["spawns_randomized"] = 1;
	spawnpoints = array_randomize( spawnpoints );
	random_chance = randomint( 100 );
	set_game_var( "side_selection", 1 );
	set_game_var( "side_selection", 2 );
	side_selection = get_game_var( "side_selection" );
	side_selection = 1;
	side_selection = 2;
	i = 0;
	arrayremovevalue( spawnpoints, spawnpoints[i] );
	i = 0;
	arrayremovevalue( spawnpoints, spawnpoints[i] );
	i = 0;
	i++;
	arrayremovevalue( spawnpoints, spawnpoints[i] );
	i = 0;
	arrayremovevalue( spawnpoints, spawnpoints[i] );
	i = 0;
	i++;
	self.playernum = get_game_var( "_team1_num" );
	set_game_var( "_team1_num", self.playernum + 1 );
	self.playernum = get_game_var( "_team2_num" );
	set_game_var( "_team2_num", self.playernum + 1 );
	j = 0;
	m = 0;
	spawnpoints[m].en_num = m;
	m++;
	return spawnpoints[j];
	j++;
	return spawnpoints[0];
// SP = 0x0 - check OK
}

// 0x8D8C
delete_in_createfx()
{
	exterior_goals = getstructarray( "exterior_goal", "targetname" );
	i = 0;
	targets = getentarray( exterior_goals[i].target, "targetname" );
	j = 0;
	targets[j] self_delete();
	j++;
	i++;
	level thread [[ level.level_createfx_callback_thread ]]();
// SP = 0x0 - check OK
}

// 0x8E1C
add_bots()
{
	host = gethostplayer();
	wait 0.05;
	host = gethostplayer();
	wait 4;
	zbot_spawn();
	setdvar( "bot_AllowMovement", "1" );
	setdvar( "bot_PressAttackBtn", "1" );
	setdvar( "bot_PressMeleeBtn", "1" );
	wait 0.05;
	players = get_players();
	i = 0;
	players[i] freezecontrols( 0 );
/#
	println( " Unfreeze controls 6" );
#/
	i++;
	level.numberbotsadded = 1;
	flag_set( "start_zombie_round_logic" );
// SP = 0x0 - check OK
}

// 0x8F00
zbot_spawn()
{
	player = gethostplayer();
	spawnpoints = getstructarray( "initial_spawn_points", "targetname" );
	spawnpoint = getfreespawnpoint( spawnpoints );
	bot = addtestclient();
/#
	println( "Could not add test client" );
#/
	return;
	bot.pers["isBot"] = 1;
	bot.equipment_enabled = 0;
	yaw = spawnpoint.angles[1];
	bot thread zbot_spawn_think( spawnpoint.origin, yaw );
	return bot;
// SP = 0x0 - check OK
}

// 0x8F98
zbot_spawn_think( origin, yaw )
{
	self endon( "disconnect" );
	self waittill( "spawned_player" );
	self setorigin( origin );
	angles = ( 0, yaw, 0 );
	self setplayerangles( angles );
// SP = 0x0 - check OK
}

// 0x8FD8
post_all_players_connected()
{
	level thread end_game();
	flag_wait( "start_zombie_round_logic" );
/#
	println( "sessions: mapname=", level.script, " gametype zom isserver 1 player_count=", get_players().size );
#/
	level thread clear_mature_blood();
	level thread round_end_monitor();
	level thread [[ level._round_start_func ]]();
	level thread players_playing();
	disablegrenadesuicide();
	level.startinvulnerabletime = GetDvarInt( #"0x4E44E32D" );
	level.music_override = 0;
// SP = 0x0 - check OK
}

// 0x9078
init_custom_ai_type()
{
	i = 0;
	[[ level.custom_ai_type[i] ]]();
	i++;
// SP = 0x0 - check OK
}

// 0x90AC
zombiemode_melee_miss()
{
	self.enemy dodamage( GetDvarInt( #"0x423A0415" ), self.origin, self, self, "none", "melee" );
// SP = 0x0 - check OK
}

// 0x90E4
player_track_ammo_count()
{
	self notify( "stop_ammo_tracking" );
	self endon( "disconnect" );
	self endon( "stop_ammo_tracking" );
	ammolowcount = 0;
	ammooutcount = 0;
	wait 0.5;
	weap = self getcurrentweapon();
	ammooutcount = 0;
	ammolowcount = 0;
	self maps/mp/zombies/_zm_audio::create_and_play_dialog( "general", "ammo_low" );
	ammolowcount++;
	self maps/mp/zombies/_zm_audio::create_and_play_dialog( "general", "ammo_out" );
	ammooutcount++;
	wait 20;
// SP = 0x0 - check OK
}

// 0x91D0
can_track_ammo( weap )
{
	return 0;
	switch ( weap )
	{
		case "alcatraz_shield_zm":
		case "death_throe_zm":
		case "equip_gasmask_zm":
		case "humangun_upgraded_zm":
		case "humangun_zm":
		case "lower_equip_gasmask_zm":
		case "none":
		case "riotshield_zm":
		case "screecher_arms_zm":
		case "tazer_knuckles_upgraded_zm":
		case "tazer_knuckles_zm":
		case "zombie_bowie_flourish":
		case "zombie_builder_zm":
		case "zombie_fists_zm":
		case "zombie_knuckle_crack":
		case "zombie_sickle_flourish":
		case "zombie_tazer_flourish":
			return 0;
		default:
			return 0;
			break;
	}
	return 1;
// SP = 0x0 - check OK
}

// 0x92E4
spawn_vo()
{
	wait 1;
	players = get_players();
	player = random( players );
	index = maps/mp/zombies/_zm_weapons::get_player_index( player );
	player thread spawn_vo_player( index, players.size );
// SP = 0x0 - check OK
}

// 0x9338
spawn_vo_player( index, num )
{
	sound = "plr_" + index + "_vox_" + num + "play";
	self playsoundwithnotify( sound, "sound_done" );
	self waittill( "sound_done" );
// SP = 0x0 - check OK
}

// 0x9370
precache_shaders()
{
	precacheshader( "hud_chalk_1" );
	precacheshader( "hud_chalk_2" );
	precacheshader( "hud_chalk_3" );
	precacheshader( "hud_chalk_4" );
	precacheshader( "hud_chalk_5" );
	precacheshader( "zom_icon_community_pot" );
	precacheshader( "zom_icon_community_pot_strip" );
	precacheshader( "zom_icon_player_life" );
	precacheshader( "waypoint_revive" );
// SP = 0x0 - check OK
}

// 0x93E4
precache_models()
{
	precachemodel( "p_zom_win_bars_01_vert04_bend_180" );
	precachemodel( "p_zom_win_bars_01_vert01_bend_180" );
	precachemodel( "p_zom_win_bars_01_vert04_bend" );
	precachemodel( "p_zom_win_bars_01_vert01_bend" );
	precachemodel( "p_zom_win_cell_bars_01_vert04_bent" );
	precachemodel( "p_zom_win_cell_bars_01_vert01_bent" );
	precachemodel( "tag_origin" );
	precachemodel( "zombie_z_money_icon" );
	self [[ level.precachecustomcharacters ]]();
// SP = 0x0 - check OK
}

// 0x945C
init_shellshocks()
{
	level.player_killed_shellshock = "zombie_death";
	precacheshellshock( level.player_killed_shellshock );
	precacheshellshock( "pain" );
	precacheshellshock( "explosion" );
// SP = 0x0 - check OK
}

// 0x9490
init_strings()
{
	precachestring( &"ZOMBIE_WEAPONCOSTAMMO" );
	precachestring( &"ZOMBIE_ROUND" );
	precachestring( &"SCRIPT_PLUS" );
	precachestring( &"ZOMBIE_GAME_OVER" );
	precachestring( &"ZOMBIE_SURVIVED_ROUND" );
	precachestring( &"ZOMBIE_SURVIVED_ROUNDS" );
	precachestring( &"ZOMBIE_SURVIVED_NOMANS" );
	precachestring( &"ZOMBIE_EXTRA_LIFE" );
	add_zombie_hint( "undefined", &"ZOMBIE_UNDEFINED" );
	add_zombie_hint( "default_treasure_chest_950", &"ZOMBIE_RANDOM_WEAPON_950" );
	add_zombie_hint( "default_buy_barrier_piece_10", &"ZOMBIE_BUTTON_BUY_BACK_BARRIER_10" );
	add_zombie_hint( "default_buy_barrier_piece_20", &"ZOMBIE_BUTTON_BUY_BACK_BARRIER_20" );
	add_zombie_hint( "default_buy_barrier_piece_50", &"ZOMBIE_BUTTON_BUY_BACK_BARRIER_50" );
	add_zombie_hint( "default_buy_barrier_piece_100", &"ZOMBIE_BUTTON_BUY_BACK_BARRIER_100" );
	add_zombie_hint( "default_reward_barrier_piece", &"ZOMBIE_BUTTON_REWARD_BARRIER" );
	add_zombie_hint( "default_reward_barrier_piece_10", &"ZOMBIE_BUTTON_REWARD_BARRIER_10" );
	add_zombie_hint( "default_reward_barrier_piece_20", &"ZOMBIE_BUTTON_REWARD_BARRIER_20" );
	add_zombie_hint( "default_reward_barrier_piece_30", &"ZOMBIE_BUTTON_REWARD_BARRIER_30" );
	add_zombie_hint( "default_reward_barrier_piece_40", &"ZOMBIE_BUTTON_REWARD_BARRIER_40" );
	add_zombie_hint( "default_reward_barrier_piece_50", &"ZOMBIE_BUTTON_REWARD_BARRIER_50" );
	add_zombie_hint( "default_buy_debris_100", &"ZOMBIE_BUTTON_BUY_CLEAR_DEBRIS_100" );
	add_zombie_hint( "default_buy_debris_200", &"ZOMBIE_BUTTON_BUY_CLEAR_DEBRIS_200" );
	add_zombie_hint( "default_buy_debris_250", &"ZOMBIE_BUTTON_BUY_CLEAR_DEBRIS_250" );
	add_zombie_hint( "default_buy_debris_500", &"ZOMBIE_BUTTON_BUY_CLEAR_DEBRIS_500" );
	add_zombie_hint( "default_buy_debris_750", &"ZOMBIE_BUTTON_BUY_CLEAR_DEBRIS_750" );
	add_zombie_hint( "default_buy_debris_1000", &"ZOMBIE_BUTTON_BUY_CLEAR_DEBRIS_1000" );
	add_zombie_hint( "default_buy_debris_1250", &"ZOMBIE_BUTTON_BUY_CLEAR_DEBRIS_1250" );
	add_zombie_hint( "default_buy_debris_1500", &"ZOMBIE_BUTTON_BUY_CLEAR_DEBRIS_1500" );
	add_zombie_hint( "default_buy_debris_1750", &"ZOMBIE_BUTTON_BUY_CLEAR_DEBRIS_1750" );
	add_zombie_hint( "default_buy_debris_2000", &"ZOMBIE_BUTTON_BUY_CLEAR_DEBRIS_2000" );
	add_zombie_hint( "default_buy_debris_3000", &"ZOMBIE_BUTTON_BUY_CLEAR_DEBRIS_3000" );
	add_zombie_hint( "default_buy_door_close", &"ZOMBIE_BUTTON_BUY_CLOSE_DOOR" );
	add_zombie_hint( "default_buy_door_100", &"ZOMBIE_BUTTON_BUY_OPEN_DOOR_100" );
	add_zombie_hint( "default_buy_door_200", &"ZOMBIE_BUTTON_BUY_OPEN_DOOR_200" );
	add_zombie_hint( "default_buy_door_250", &"ZOMBIE_BUTTON_BUY_OPEN_DOOR_250" );
	add_zombie_hint( "default_buy_door_500", &"ZOMBIE_BUTTON_BUY_OPEN_DOOR_500" );
	add_zombie_hint( "default_buy_door_750", &"ZOMBIE_BUTTON_BUY_OPEN_DOOR_750" );
	add_zombie_hint( "default_buy_door_1000", &"ZOMBIE_BUTTON_BUY_OPEN_DOOR_1000" );
	add_zombie_hint( "default_buy_door_1250", &"ZOMBIE_BUTTON_BUY_OPEN_DOOR_1250" );
	add_zombie_hint( "default_buy_door_1500", &"ZOMBIE_BUTTON_BUY_OPEN_DOOR_1500" );
	add_zombie_hint( "default_buy_door_1750", &"ZOMBIE_BUTTON_BUY_OPEN_DOOR_1750" );
	add_zombie_hint( "default_buy_door_2000", &"ZOMBIE_BUTTON_BUY_OPEN_DOOR_2000" );
	add_zombie_hint( "default_buy_door_2500", &"ZOMBIE_BUTTON_BUY_OPEN_DOOR_2500" );
	add_zombie_hint( "default_buy_door_3000", &"ZOMBIE_BUTTON_BUY_OPEN_DOOR_3000" );
	add_zombie_hint( "default_buy_door_4000", &"ZOMBIE_BUTTON_BUY_OPEN_DOOR_4000" );
	add_zombie_hint( "default_buy_door_8000", &"ZOMBIE_BUTTON_BUY_OPEN_DOOR_8000" );
	add_zombie_hint( "default_buy_door_16000", &"ZOMBIE_BUTTON_BUY_OPEN_DOOR_16000" );
	add_zombie_hint( "default_buy_area_100", &"ZOMBIE_BUTTON_BUY_OPEN_AREA_100" );
	add_zombie_hint( "default_buy_area_200", &"ZOMBIE_BUTTON_BUY_OPEN_AREA_200" );
	add_zombie_hint( "default_buy_area_250", &"ZOMBIE_BUTTON_BUY_OPEN_AREA_250" );
	add_zombie_hint( "default_buy_area_500", &"ZOMBIE_BUTTON_BUY_OPEN_AREA_500" );
	add_zombie_hint( "default_buy_area_750", &"ZOMBIE_BUTTON_BUY_OPEN_AREA_750" );
	add_zombie_hint( "default_buy_area_1000", &"ZOMBIE_BUTTON_BUY_OPEN_AREA_1000" );
	add_zombie_hint( "default_buy_area_1250", &"ZOMBIE_BUTTON_BUY_OPEN_AREA_1250" );
	add_zombie_hint( "default_buy_area_1500", &"ZOMBIE_BUTTON_BUY_OPEN_AREA_1500" );
	add_zombie_hint( "default_buy_area_1750", &"ZOMBIE_BUTTON_BUY_OPEN_AREA_1750" );
	add_zombie_hint( "default_buy_area_2000", &"ZOMBIE_BUTTON_BUY_OPEN_AREA_2000" );
	add_zombie_hint( "powerup_fire_sale_cost", &"ZOMBIE_FIRE_SALE_COST" );
// SP = 0x0 - check OK
}

// 0x9818
init_sounds()
{
	add_sound( "end_of_round", "mus_zmb_round_over" );
	add_sound( "end_of_game", "mus_zmb_game_over" );
	add_sound( "chalk_one_up", "mus_zmb_chalk" );
	add_sound( "purchase", "zmb_cha_ching" );
	add_sound( "no_purchase", "zmb_no_cha_ching" );
	add_sound( "playerzombie_usebutton_sound", "zmb_zombie_vocals_attack" );
	add_sound( "playerzombie_attackbutton_sound", "zmb_zombie_vocals_attack" );
	add_sound( "playerzombie_adsbutton_sound", "zmb_zombie_vocals_attack" );
	add_sound( "zombie_head_gib", "zmb_zombie_head_gib" );
	add_sound( "rebuild_barrier_piece", "zmb_repair_boards" );
	add_sound( "rebuild_barrier_metal_piece", "zmb_metal_repair" );
	add_sound( "rebuild_barrier_hover", "zmb_boards_float" );
	add_sound( "debris_hover_loop", "zmb_couch_loop" );
	add_sound( "break_barrier_piece", "zmb_break_boards" );
	add_sound( "grab_metal_bar", "zmb_bar_pull" );
	add_sound( "break_metal_bar", "zmb_bar_break" );
	add_sound( "drop_metal_bar", "zmb_bar_drop" );
	add_sound( "blocker_end_move", "zmb_board_slam" );
	add_sound( "barrier_rebuild_slam", "zmb_board_slam" );
	add_sound( "bar_rebuild_slam", "zmb_bar_repair" );
	add_sound( "zmb_rock_fix", "zmb_break_rock_barrier_fix" );
	add_sound( "zmb_vent_fix", "evt_vent_slat_repair" );
	add_sound( "door_slide_open", "zmb_door_slide_open" );
	add_sound( "door_rotate_open", "zmb_door_slide_open" );
	add_sound( "debris_move", "zmb_weap_wall" );
	add_sound( "open_chest", "zmb_lid_open" );
	add_sound( "music_chest", "zmb_music_box" );
	add_sound( "close_chest", "zmb_lid_close" );
	add_sound( "weapon_show", "zmb_weap_wall" );
	add_sound( "break_stone", "break_stone" );
// SP = 0x0 - check OK
}

// 0x9A00
init_levelvars()
{
	level.is_zombie_level = 1;
	level.laststandpistol = "m1911_zm";
	level.default_laststandpistol = "m1911_zm";
	level.default_solo_laststandpistol = "m1911_upgraded_zm";
	level.start_weapon = "m1911_zm";
	level.first_round = 1;
	level.round_number = getgametypesetting( "startRound" );
	level.enable_magic = getgametypesetting( "magic" );
	level.headshots_only = getgametypesetting( "headshotsonly" );
	level.player_starting_points = level.round_number * 500;
	level.round_start_time = 0;
	level.pro_tips_start_time = 0;
	level.intermission = 0;
	level.dog_intermission = 0;
	level.zombie_total = 0;
	level.total_zombies_killed = 0;
	level.hudelem_count = 0;
	level.zombie_spawn_locations = [];
	level.zombie_rise_spawners = [];
	level.current_zombie_array = [];
	level.current_zombie_count = 0;
	level.zombie_total_subtract = 0;
	level.destructible_callbacks = [];
	level.zombie_vars = [];
	foreach ( team in level.teams )
	{
		level.zombie_vars[team] = [];
	}
	difficulty = 1;
	column = int( difficulty ) + 1;
	set_zombie_var( "zombie_health_increase", 100, 0, column );
	set_zombie_var( "zombie_health_increase_multiplier", 0.1, 1, column );
	set_zombie_var( "zombie_health_start", 150, 0, column );
	set_zombie_var( "zombie_spawn_delay", 2, 1, column );
	set_zombie_var( "zombie_new_runner_interval", 10, 0, column );
	set_zombie_var( "zombie_move_speed_multiplier", 8, 0, column );
	set_zombie_var( "zombie_move_speed_multiplier_easy", 2, 0, column );
	set_zombie_var( "zombie_max_ai", 24, 0, column );
	set_zombie_var( "zombie_ai_per_player", 6, 0, column );
	set_zombie_var( "below_world_check", -1000 );
	set_zombie_var( "spectators_respawn", 1 );
	set_zombie_var( "zombie_use_failsafe", 1 );
	set_zombie_var( "zombie_between_round_time", 10 );
	set_zombie_var( "zombie_intermission_time", 15 );
	set_zombie_var( "game_start_delay", 0, 0, column );
	set_zombie_var( "penalty_no_revive", 0.1, 1, column );
	set_zombie_var( "penalty_died", 0, 1, column );
	set_zombie_var( "penalty_downed", 0.05, 1, column );
	set_zombie_var( "starting_lives", 1, 0, column );
	set_zombie_var( "zombie_score_kill_4player", 50 );
	set_zombie_var( "zombie_score_kill_3player", 50 );
	set_zombie_var( "zombie_score_kill_2player", 50 );
	set_zombie_var( "zombie_score_kill_1player", 50 );
	set_zombie_var( "zombie_score_kill_4p_team", 30 );
	set_zombie_var( "zombie_score_kill_3p_team", 35 );
	set_zombie_var( "zombie_score_kill_2p_team", 45 );
	set_zombie_var( "zombie_score_kill_1p_team", 0 );
	set_zombie_var( "zombie_score_damage_normal", 10 );
	set_zombie_var( "zombie_score_damage_light", 10 );
	set_zombie_var( "zombie_score_bonus_melee", 80 );
	set_zombie_var( "zombie_score_bonus_head", 50 );
	set_zombie_var( "zombie_score_bonus_neck", 20 );
	set_zombie_var( "zombie_score_bonus_torso", 10 );
	set_zombie_var( "zombie_score_bonus_burn", 10 );
	set_zombie_var( "zombie_flame_dmg_point_delay", 500 );
	set_zombie_var( "zombify_player", 0 );
	set_zombie_var( "zombie_timer_offset", 280 );
	level thread init_player_levelvars();
	level.gamedifficulty = getgametypesetting( "zmDifficulty" );
	level.zombie_move_speed = level.round_number * level.zombie_vars["zombie_move_speed_multiplier_easy"];
	level.zombie_move_speed = level.round_number * level.zombie_vars["zombie_move_speed_multiplier"];
	level.zombie_move_speed = 1;
	i = 1;
	timer = level.zombie_vars["zombie_spawn_delay"];
	level.zombie_vars["zombie_spawn_delay"] = timer * 0.95;
	level.zombie_vars["zombie_spawn_delay"] = 0.08;
	i++;
	level.speed_change_max = 0;
	level.speed_change_num = 0;
// SP = 0x0 - check OK
}

// 0x9E7C
init_player_levelvars()
{
	flag_wait( "start_zombie_round_logic" );
	difficulty = 1;
	column = int( difficulty ) + 1;
	i = 0;
	points = 500;
	points = 3000;
	points = set_zombie_var( "zombie_score_start_" + ( i + 1 ) + "p", points, 0, column );
	i++;
// SP = 0x0 - check OK
}

// 0x9EF4
init_dvars()
{
	setdvar( "zombie_debug", "0" );
	setdvar( "scr_zm_enable_bots", "0" );
	setdvar( "zombie_cheat", "0" );
	setdvar( "magic_chest_movable", "1" );
	setdvar( "revive_trigger_radius", "75" );
	setdvar( "player_lastStandBleedoutTime", "45" );
	setdvar( "scr_deleteexplosivesonspawn", "0" );
// SP = 0x0 - check OK
}

// 0x9FA8
init_function_overrides()
{
	level.callbackplayerdamage = ::callback_playerdamage;
	level.overrideplayerdamage = ::player_damage_override;
	level.callbackplayerkilled = ::player_killed_override;
	level.playerlaststand_func = ::player_laststand;
	level.callbackplayerlaststand = ::callback_playerlaststand;
	level.prevent_player_damage = ::player_prevent_damage;
	level.callbackactorkilled = ::actor_killed_override;
	level.callbackactordamage = ::actor_damage_override_wrapper;
	level.custom_introscreen = ::zombie_intro_screen;
	level.custom_intermission = ::player_intermission;
	level.global_damage_func = ::zombie_damage;
	level.global_damage_func_ads = ::zombie_damage_ads;
	level.reset_clientdvars = ::onplayerconnect_clientdvars;
	level.zombie_last_stand = ::last_stand_pistol_swap;
	level.zombie_last_stand_pistol_memory = ::last_stand_save_pistol_ammo;
	level.zombie_last_stand_ammo_return = ::last_stand_restore_pistol_ammo;
	level.player_becomes_zombie = ::zombify_player;
	level.validate_enemy_path_length = ::default_validate_enemy_path_length;
// SP = 0x0 - check OK
}

// 0xA088
callback_playerlaststand( einflictor, eattacker, idamage, smeansofdeath, sweapon, vdir, shitloc, psoffsettime, deathanimduration )
{
	self endon( "disconnect" );
	[[ ::playerlaststand ]]( einflictor, eattacker, idamage, smeansofdeath, sweapon, vdir, shitloc, psoffsettime, deathanimduration );
// SP = 0x0 - check OK
}

// 0xA0C4
codecallback_destructibleevent( event, param1, param2, param3 )
{
	notify_type = param1;
	attacker = param2;
	weapon = param3;
	self thread [[ level.destructible_callbacks[notify_type] ]]( notify_type, attacker );
	self notify( event, notify_type, attacker );
	piece = param1;
	time = param2;
	damage = param3;
	self thread breakafter( time, damage, piece );
// SP = 0x0 - check OK
}

// 0xA14C
breakafter( time, damage, piece )
{
	self notify( "breakafter" );
	self endon( "breakafter" );
	wait time;
	self dodamage( damage, self.origin, undefined, undefined );
// SP = 0x0 - check OK
}

// 0xA17C
callback_playerdamage( einflictor, eattacker, idamage, idflags, smeansofdeath, sweapon, vpoint, vdir, shitloc, psoffsettime, boneindex )
{
/#
	println( "ZM Callback_PlayerDamage" + idamage + "\n" );
#/
/#
	println( "Exiting - players can't hurt each other." );
#/
	return;
/#
	println( "Exiting - damage type verbotten." );
#/
	return;
	self notify( "pers_melee_swipe" );
	level.pers_melee_swipe_zombie_swiper = eattacker;
	idamage = self [[ self.overrideplayerdamage ]]( einflictor, eattacker, idamage, idflags, smeansofdeath, sweapon, vpoint, vdir, shitloc, psoffsettime );
	idamage = self [[ level.overrideplayerdamage ]]( einflictor, eattacker, idamage, idflags, smeansofdeath, sweapon, vpoint, vdir, shitloc, psoffsettime );
/#
	assert( IsDefined( idamage ), "You must return a value from a damage override function." );
#/
	maxhealth = self.maxhealth;
	self.health += idamage;
	self.maxhealth = maxhealth;
	dist = distance2d( vpoint, self.origin );
	dot_product = vectordot( anglestoforward( self.angles ), vdir );
	idamage = int( idamage * 0.5 );
/#
	println( "CB PD" );
#/
	return;
	idflags |= level.idflags_no_knockback;
/#
	println( "Finishplayerdamage wrapper." );
#/
	self finishplayerdamagewrapper( einflictor, eattacker, idamage, idflags, smeansofdeath, sweapon, vpoint, vdir, shitloc, psoffsettime, boneindex );
// SP = 0x0 - check OK
}

// 0xA434
finishplayerdamagewrapper( einflictor, eattacker, idamage, idflags, smeansofdeath, sweapon, vpoint, vdir, shitloc, psoffsettime, boneindex )
{
	self finishplayerdamage( einflictor, eattacker, idamage, idflags, smeansofdeath, sweapon, vpoint, vdir, shitloc, psoffsettime, boneindex );
// SP = 0x0 - check OK
}

// 0xA474
init_flags()
{
	flag_init( "solo_game" );
	flag_init( "start_zombie_round_logic" );
	flag_init( "start_encounters_match_logic" );
	flag_init( "spawn_point_override" );
	flag_init( "power_on" );
	flag_init( "crawler_round" );
	flag_init( "spawn_zombies", 1 );
	flag_init( "dog_round" );
	flag_init( "begin_spawning" );
	flag_init( "end_round_wait" );
	flag_init( "wait_and_revive" );
	flag_init( "instant_revive" );
	flag_init( "initial_blackscreen_passed" );
	flag_init( "initial_players_connected" );
// SP = 0x0 - check OK
}

// 0xA528
init_client_flags()
{
	level._zombie_scriptmover_flag_board_horizontal_fx = 14;
	level._zombie_scriptmover_flag_board_vertical_fx = 13;
	level._zombie_scriptmover_flag_rock_fx = 12;
	level._zombie_player_flag_cloak_weapon = 14;
	registerclientfield( "toplayer", "deadshot_perk", 1, 1, "int" );
	registerclientfield( "actor", "zombie_riser_fx", 1, 1, "int" );
	registerclientfield( "actor", "zombie_riser_fx_water", 1, 1, "int" );
	registerclientfield( "actor", "zombie_riser_fx_lowg", 1, 1, "int" );
// SP = 0x0 - check OK
}

// 0xA5F0
init_fx()
{
	level.createfx_callback_thread = ::delete_in_createfx;
	level._effect["wood_chunk_destory"] = loadfx( "impacts/fx_large_woodhit" );
	level._effect["fx_zombie_bar_break"] = loadfx( "maps/zombie/fx_zombie_bar_break" );
	level._effect["fx_zombie_bar_break_lite"] = loadfx( "maps/zombie/fx_zombie_bar_break_lite" );
	level._effect["edge_fog"] = loadfx( "maps/zombie/fx_fog_zombie_amb" );
	level._effect["chest_light"] = loadfx( "maps/zombie/fx_zmb_tranzit_marker_glow" );
	level._effect["eye_glow"] = loadfx( "misc/fx_zombie_eye_single" );
	level._effect["headshot"] = loadfx( "impacts/fx_flesh_hit" );
	level._effect["headshot_nochunks"] = loadfx( "misc/fx_zombie_bloodsplat" );
	level._effect["bloodspurt"] = loadfx( "misc/fx_zombie_bloodspurt" );
	level._effect["tesla_head_light"] = loadfx( "maps/zombie/fx_zombie_tesla_neck_spurt" );
	level._effect["zombie_guts_explosion"] = loadfx( "maps/zombie/fx_zmb_tranzit_torso_explo" );
	level._effect["rise_burst_water"] = loadfx( "maps/zombie/fx_mp_zombie_hand_dirt_burst" );
	level._effect["rise_billow_water"] = loadfx( "maps/zombie/fx_mp_zombie_body_dirt_billowing" );
	level._effect["rise_dust_water"] = loadfx( "maps/zombie/fx_mp_zombie_body_dust_falling" );
	level._effect["rise_burst"] = loadfx( "maps/zombie/fx_mp_zombie_hand_dirt_burst" );
	level._effect["rise_billow"] = loadfx( "maps/zombie/fx_mp_zombie_body_dirt_billowing" );
	level._effect["rise_dust"] = loadfx( "maps/zombie/fx_mp_zombie_body_dust_falling" );
	level._effect["fall_burst"] = loadfx( "maps/zombie/fx_mp_zombie_hand_dirt_burst" );
	level._effect["fall_billow"] = loadfx( "maps/zombie/fx_mp_zombie_body_dirt_billowing" );
	level._effect["fall_dust"] = loadfx( "maps/zombie/fx_mp_zombie_body_dust_falling" );
	level._effect["character_fire_death_sm"] = loadfx( "env/fire/fx_fire_zombie_md" );
	level._effect["character_fire_death_torso"] = loadfx( "env/fire/fx_fire_zombie_torso" );
	level._effect["def_explosion"] = loadfx( "explosions/fx_default_explosion" );
	level._effect["870mcs_zm_fx"] = loadfx( "maps/zombie/fx_zmb_wall_buy_870mcs" );
	level._effect["ak74u_zm_fx"] = loadfx( "maps/zombie/fx_zmb_wall_buy_ak74u" );
	level._effect["beretta93r_zm_fx"] = loadfx( "maps/zombie/fx_zmb_wall_buy_berreta93r" );
	level._effect["bowie_knife_zm_fx"] = loadfx( "maps/zombie/fx_zmb_wall_buy_bowie" );
	level._effect["claymore_zm_fx"] = loadfx( "maps/zombie/fx_zmb_wall_buy_claymore" );
	level._effect["m14_zm_fx"] = loadfx( "maps/zombie/fx_zmb_wall_buy_m14" );
	level._effect["m16_zm_fx"] = loadfx( "maps/zombie/fx_zmb_wall_buy_m16" );
	level._effect["mp5k_zm_fx"] = loadfx( "maps/zombie/fx_zmb_wall_buy_mp5k" );
	level._effect["rottweil72_zm_fx"] = loadfx( "maps/zombie/fx_zmb_wall_buy_olympia" );
	level._effect["sticky_grenade_zm_fx"] = loadfx( "maps/zombie/fx_zmb_wall_buy_semtex" );
	level._effect["tazer_knuckles_zm_fx"] = loadfx( "maps/zombie/fx_zmb_wall_buy_taseknuck" );
	level._effect["dynamic_wallbuy_fx"] = loadfx( "maps/zombie/fx_zmb_wall_buy_question" );
	level._effect["upgrade_aquired"] = loadfx( "maps/zombie/fx_zmb_tanzit_upgrade" );
// SP = 0x0 - check OK
}

// 0xA90C
zombie_intro_screen( string1, string2, string3, string4, string5 )
{
	flag_wait( "start_zombie_round_logic" );
// SP = 0x0 - check OK
}

// 0xA92C
players_playing()
{
	players = get_players();
	level.players_playing = players.size;
	wait 20;
	players = get_players();
	level.players_playing = players.size;
// SP = 0x0 - check OK
}

// 0xA960
onplayerconnect_clientdvars()
{
	self setclientcompass( 0 );
	self setclientthirdperson( 0 );
	self resetfov();
	self setclientthirdpersonangle( 0 );
	self setclientammocounterhide( 1 );
	self setclientminiscoreboardhide( 1 );
	self setclienthudhardcore( 0 );
	self setclientplayerpushamount( 1 );
	self setdepthoffield( 0, 0, 512, 4000, 4, 0 );
	self setclientaimlockonpitchstrength( 0 );
	self maps/mp/zombies/_zm_laststand::player_getup_setup();
// SP = 0x0 - check OK
}

// 0xA9FC
checkforalldead( excluded_player )
{
	players = get_players();
	count = 0;
	i = 0;
	count++;
	i++;
	level notify( "end_game" );
// SP = 0x0 - check OK
}

// 0xAA90
onplayerspawned()
{
	self endon( "disconnect" );
	self notify( "stop_onPlayerSpawned" );
	self endon( "stop_onPlayerSpawned" );
	self waittill( "spawned_player" );
	self freezecontrols( 0 );
/#
	println( " Unfreeze controls 7" );
#/
	self.hits = 0;
	self init_player_offhand_weapons();
	lethal_grenade = self get_player_lethal_grenade();
	self giveweapon( lethal_grenade );
	self setweaponammoclip( lethal_grenade, 0 );
	self recordplayerrevivezombies( self );
/#
	self enableinvulnerability();
#/
	self setactionslot( 3, "altMode" );
	self playerknockback( 0 );
	self setclientthirdperson( 0 );
	self resetfov();
	self setclientthirdpersonangle( 0 );
	self setdepthoffield( 0, 0, 512, 4000, 4, 0 );
	self cameraactivate( 0 );
	self.num_perks = 0;
	self.on_lander_last_stand = undefined;
	self setblur( 0, 0.1 );
	self.zmbdialogqueue = [];
	self.zmbdialogactive = 0;
	self.zmbdialoggroups = [];
	self.zmbdialoggroup = "";
	self thread player_out_of_playable_area_monitor();
	self thread [[ level.player_too_many_weapons_monitor_func ]]();
	level thread [[ level.player_too_many_players_check_func ]]();
	self.disabled_perks = [];
	self.player_initialized = 1;
	self giveweapon( self get_player_lethal_grenade() );
	self setweaponammoclip( self get_player_lethal_grenade(), 0 );
	self setclientammocounterhide( 0 );
	self setclientminiscoreboardhide( 0 );
	self.is_drinking = 0;
	self thread player_zombie_breadcrumb();
	self thread player_monitor_travel_dist();
	self thread player_monitor_time_played();
	self thread player_track_ammo_count();
	self thread shock_onpain();
	self thread player_grenade_watcher();
	self maps/mp/zombies/_zm_laststand::revive_hud_create();
	self thread [[ level.zm_gamemodule_spawn_func ]]();
	self thread player_spawn_protection();
	self.lives = 0;
// SP = 0x0 - check OK
}

// 0xAD30
player_spawn_protection()
{
	self endon( "disconnect" );
	x = 0;
	self.ignoreme = 1;
	x++;
	wait 0.05;
	self.ignoreme = 0;
// SP = 0x0 - check OK
}

// 0xAD68
spawn_life_brush( origin, radius, height )
{
	life_brush = spawn( "trigger_radius", origin, 0, radius, height );
	life_brush.script_noteworthy = "life_brush";
	return life_brush;
// SP = 0x0 - check OK
}

// 0xAD98
in_life_brush()
{
	life_brushes = getentarray( "life_brush", "script_noteworthy" );
	return 0;
	i = 0;
	return 1;
	i++;
	return 0;
// SP = 0x0 - check OK
}

// 0xADE8
spawn_kill_brush( origin, radius, height )
{
	kill_brush = spawn( "trigger_radius", origin, 0, radius, height );
	kill_brush.script_noteworthy = "kill_brush";
	return kill_brush;
// SP = 0x0 - check OK
}

// 0xAE18
in_kill_brush()
{
	kill_brushes = getentarray( "kill_brush", "script_noteworthy" );
	return 0;
	i = 0;
	return 1;
	i++;
	return 0;
// SP = 0x0 - check OK
}

// 0xAE68
in_enabled_playable_area()
{
	playable_area = getentarray( "player_volume", "script_noteworthy" );
	return 0;
	i = 0;
	return 1;
	i++;
	return 0;
// SP = 0x0 - check OK
}

// 0xAED0
get_player_out_of_playable_area_monitor_wait_time()
{
/#
	return 0.05;
#/
	return 3;
// SP = 0x0 - check OK
}

// 0xAEF4
player_out_of_playable_area_monitor()
{
	self notify( "stop_player_out_of_playable_area_monitor" );
	self endon( "stop_player_out_of_playable_area_monitor" );
	self endon( "disconnect" );
	level endon( "end_game" );
	wait 0.05;
	wait 0.15 * self.characterindex;
	wait get_player_out_of_playable_area_monitor_wait_time();
	wait get_player_out_of_playable_area_monitor_wait_time();
/#
	iprintlnbold( "out of playable" );
	wait get_player_out_of_playable_area_monitor_wait_time();
	wait get_player_out_of_playable_area_monitor_wait_time();
#/
	self maps/mp/zombies/_zm_stats::increment_map_cheat_stat( "cheat_out_of_playable" );
	self maps/mp/zombies/_zm_stats::increment_client_stat( "cheat_out_of_playable", 0 );
	self maps/mp/zombies/_zm_stats::increment_client_stat( "cheat_total", 0 );
	self playlocalsound( level.zmb_laugh_alias );
	wait 0.5;
	level notify( "end_game" );
	self.lives = 0;
	self dodamage( self.health + 1000, self.origin );
	self.bleedout_time = 0;
	wait get_player_out_of_playable_area_monitor_wait_time();
// SP = 0x0 - check OK
}

// 0xB0C4
get_player_too_many_weapons_monitor_wait_time()
{
	return 3;
// SP = 0x0 - check OK
}

// 0xB0CC
player_too_many_weapons_monitor_takeaway_simultaneous( primary_weapons_to_take )
{
	self endon( "player_too_many_weapons_monitor_takeaway_sequence_done" );
	self waittill_any( "player_downed", "replace_weapon_powerup" );
	i = 0;
	self takeweapon( primary_weapons_to_take[i] );
	i++;
	self maps/mp/zombies/_zm_score::minus_to_player_score( self.score );
	self give_start_weapon( 0 );
	self decrement_is_drinking();
	self.score_lost_when_downed = 0;
	self notify( "player_too_many_weapons_monitor_takeaway_sequence_done" );
// SP = 0x0 - check OK
}

// 0xB168
player_too_many_weapons_monitor_takeaway_sequence( primary_weapons_to_take )
{
	self thread player_too_many_weapons_monitor_takeaway_simultaneous( primary_weapons_to_take );
	self endon( "player_downed" );
	self endon( "replace_weapon_powerup" );
	self increment_is_drinking();
	score_decrement = round_up_to_ten( int( self.score / ( primary_weapons_to_take.size + 1 ) ) );
	i = 0;
	self playlocalsound( level.zmb_laugh_alias );
	self switchtoweapon( primary_weapons_to_take[i] );
	self maps/mp/zombies/_zm_score::minus_to_player_score( score_decrement );
	wait 3;
	self takeweapon( primary_weapons_to_take[i] );
	i++;
	self playlocalsound( level.zmb_laugh_alias );
	self maps/mp/zombies/_zm_score::minus_to_player_score( self.score );
	wait 1;
	self give_start_weapon( 1 );
	self decrement_is_drinking();
	self notify( "player_too_many_weapons_monitor_takeaway_sequence_done" );
// SP = 0x0 - check OK
}

// 0xB254
player_too_many_weapons_monitor()
{
	self notify( "stop_player_too_many_weapons_monitor" );
	self endon( "stop_player_too_many_weapons_monitor" );
	self endon( "disconnect" );
	level endon( "end_game" );
	scalar = self.characterindex;
	scalar = self getentitynumber();
	wait 0.15 * scalar;
	wait get_player_too_many_weapons_monitor_wait_time();
/#
	wait get_player_too_many_weapons_monitor_wait_time();
#/
	weapon_limit = 2;
	weapon_limit = 3;
	primaryweapons = self getweaponslistprimaries();
	self maps/mp/zombies/_zm_weapons::take_fallback_weapon();
	primaryweapons = self getweaponslistprimaries();
	primary_weapons_to_take = [];
	i = 0;
	primary_weapons_to_take[primary_weapons_to_take.size] = primaryweapons[i];
	i++;
	self maps/mp/zombies/_zm_stats::increment_map_cheat_stat( "cheat_too_many_weapons" );
	self maps/mp/zombies/_zm_stats::increment_client_stat( "cheat_too_many_weapons", 0 );
	self maps/mp/zombies/_zm_stats::increment_client_stat( "cheat_total", 0 );
	self thread player_too_many_weapons_monitor_takeaway_sequence( primary_weapons_to_take );
	self waittill( "player_too_many_weapons_monitor_takeaway_sequence_done" );
	wait get_player_too_many_weapons_monitor_wait_time();
// SP = 0x0 - check OK
}

// 0xB3F8
player_monitor_travel_dist()
{
	self endon( "disconnect" );
	self notify( "stop_player_monitor_travel_dist" );
	self endon( "stop_player_monitor_travel_dist" );
	prevpos = self.origin;
	wait 0.1;
	self.pers["distance_traveled"] += distance( self.origin, prevpos );
	prevpos = self.origin;
// SP = 0x0 - check OK
}

// 0xB454
player_monitor_time_played()
{
	self endon( "disconnect" );
	self notify( "stop_player_monitor_time_played" );
	self endon( "stop_player_monitor_time_played" );
	flag_wait( "start_zombie_round_logic" );
	wait 1;
	maps/mp/zombies/_zm_stats::increment_client_stat( "time_played_total" );
// SP = 0x0 - check OK
}

// 0xB490
reset_rampage_bookmark_kill_times()
{
	self.rampage_bookmark_kill_times = [];
	self.ignore_rampage_kill_times = 0;
	i = 0;
	self.rampage_bookmark_kill_times[i] = 0;
	i++;
// SP = 0x0 - check OK
}

// 0xB4D0
add_rampage_bookmark_kill_time()
{
	now = GetTime();
	return;
	oldest_index = 0;
	oldest_time = now + 1;
	i = 0;
	oldest_index = i;
	oldest_index = i;
	oldest_time = self.rampage_bookmark_kill_times[i];
	i++;
	self.rampage_bookmark_kill_times[oldest_index] = now;
// SP = 0x0 - check OK
}

// 0xB550
watch_rampage_bookmark()
{
	wait 0.05;
	waittillframeend;
	now = GetTime();
	oldest_allowed = now - level.rampage_bookmark_kill_times_msec;
	players = get_players();
	player_index = 0;
	player = players[player_index];
/#
#/
	time_index = 0;
	player.rampage_bookmark_kill_times[time_index] = 0;
	time_index++;
	maps/mp/_demo::bookmark( "zm_player_rampage", GetTime(), player );
	player reset_rampage_bookmark_kill_times();
	player.ignore_rampage_kill_times = now + level.rampage_bookmark_kill_times_delay;
	player_index++;
// SP = 0x0 - check OK
}

// 0xB654
player_grenade_multiattack_bookmark_watcher( grenade )
{
	self endon( "disconnect" );
	waittillframeend;
	return;
	inflictorentnum = grenade getentitynumber();
	inflictorenttype = grenade getentitytype();
	inflictorbirthtime = 0;
	inflictorbirthtime = grenade.birthtime;
	ret_val = grenade waittill_any_timeout( 15, "explode" );
	return;
	self.grenade_multiattack_count = 0;
	self.grenade_multiattack_ent = undefined;
	waittillframeend;
	return;
	count = level.grenade_multiattack_bookmark_count;
	count = grenade.grenade_multiattack_bookmark_count;
	bookmark_string = "zm_player_grenade_multiattack";
	bookmark_string = "zm_player_grenade_special_long";
	bookmark_string = "zm_player_grenade_special";
	adddemobookmark( level.bookmark[bookmark_string], GetTime(), self getentitynumber(), 255, 0, inflictorentnum, inflictorenttype, inflictorbirthtime, 0, self.grenade_multiattack_ent getentitynumber() );
	self.grenade_multiattack_count = 0;
// SP = 0x0 - check OK
}

// 0xB798
player_grenade_watcher()
{
	self endon( "disconnect" );
	self notify( "stop_player_grenade_watcher" );
	self endon( "stop_player_grenade_watcher" );
	self.grenade_multiattack_count = 0;
	self waittill( "grenade_fire", grenade, weapname );
	grenade.team = self.team;
	self thread player_grenade_multiattack_bookmark_watcher( grenade );
	self [[ level.grenade_watcher ]]( grenade, weapname );
// SP = 0x0 - check OK
}

// 0xB814
player_prevent_damage( einflictor, eattacker, idamage, idflags, smeansofdeath, sweapon, vpoint, vdir, shitloc, psoffsettime )
{
	return 0;
	return 0;
	return 1;
	return 0;
// SP = 0x0 - check OK
}

// 0xB88C
player_revive_monitor()
{
	self endon( "disconnect" );
	self notify( "stop_player_revive_monitor" );
	self endon( "stop_player_revive_monitor" );
	self waittill( "player_revived", reviver );
	self playsoundtoplayer( "zmb_character_revived", self );
	bbprint( "zombie_playerdeaths", "round %d playername %s deathtype %s x %f y %f z %f", level.round_number, self.name, "revived", self.origin );
	self maps/mp/zombies/_zm_audio::create_and_play_dialog( "general", "revive_up" );
	points = self.score_lost_when_downed;
/#
	println( "ZM >> LAST STAND - points = " + points );
#/
	reviver maps/mp/zombies/_zm_score::player_add_points( "reviver", points );
	self.score_lost_when_downed = 0;
// SP = 0x0 - check OK
}

// 0xB94C
laststand_giveback_player_perks()
{
	lost_perk_index = int( -1 );
	lost_perk_index = randomint( self.laststand_perks.size - 1 );
	i = 0;
	maps/mp/zombies/_zm_perks::give_perk( self.laststand_perks[i] );
	i++;
// SP = 0x0 - check OK
}

// 0xB9DC
remote_revive_watch()
{
	self endon( "death" );
	self endon( "player_revived" );
	keep_checking = 1;
	self waittill( "remote_revive", reviver );
	keep_checking = 0;
	self maps/mp/zombies/_zm_laststand::remote_revive( reviver );
// SP = 0x0 - check OK
}

// 0xBA2C
remove_deadshot_bottle()
{
	wait 0.05;
	self.lastactiveweapon = "none";
// SP = 0x0 - check OK
}

// 0xBA58
take_additionalprimaryweapon()
{
	weapon_to_take = undefined;
	return weapon_to_take;
	primary_weapons_that_can_be_taken = [];
	primaryweapons = self getweaponslistprimaries();
	i = 0;
	primary_weapons_that_can_be_taken[primary_weapons_that_can_be_taken.size] = primaryweapons[i];
	i++;
	weapon_to_take = primary_weapons_that_can_be_taken[primary_weapons_that_can_be_taken.size - 1];
	self switchtoweapon( primary_weapons_that_can_be_taken[0] );
	self takeweapon( weapon_to_take );
	return weapon_to_take;
// SP = 0x0 - check OK
}

// 0xBB10
player_laststand( einflictor, attacker, idamage, smeansofdeath, sweapon, vdir, shitloc, psoffsettime, deathanimduration )
{
/#
	println( "ZM >> LAST STAND - player_laststand called" );
#/
	b_alt_visionset = 0;
	self allowjump( 0 );
	currweapon = self getcurrentweapon();
	statweapon = currweapon;
	statweapon = weaponaltweaponname( statweapon );
	self addweaponstat( statweapon, "deathsDuringUse", 1 );
	self.laststand_perks = maps/mp/zombies/_zm_tombstone::tombstone_save_perks( self );
	self maps/mp/zombies/_zm_pers_upgrades_functions::pers_upgrade_perk_lose_save_perks();
	players = get_players();
	self thread wait_and_revive();
	primary_weapons_that_can_be_taken = [];
	primaryweapons = self getweaponslistprimaries();
	i = 0;
	primary_weapons_that_can_be_taken[primary_weapons_that_can_be_taken.size] = primaryweapons[i];
	i++;
	weapon_to_take = primary_weapons_that_can_be_taken[primary_weapons_that_can_be_taken.size - 1];
	self takeweapon( weapon_to_take );
	self.weapon_taken_by_losing_specialty_additionalprimaryweapon = weapon_to_take;
	self [[ level.tombstone_laststand_func ]]();
	self thread [[ level.tombstone_spawn_func ]]();
	self.hasperkspecialtytombstone = undefined;
	self notify( "specialty_scavenger_stop" );
	self clear_is_drinking();
	self thread remove_deadshot_bottle();
	self thread remote_revive_watch();
	self maps/mp/zombies/_zm_score::player_downed_penalty();
	self disableoffhandweapons();
	self thread last_stand_grenade_save_and_return();
	self maps/mp/zombies/_zm_audio::create_and_play_dialog( "general", "revive_down" );
	self maps/mp/zombies/_zm_audio::create_and_play_dialog( "general", "exert_death" );
	bbprint( "zombie_playerdeaths", "round %d playername %s deathtype %s x %f y %f z %f", level.round_number, self.name, "downed", self.origin );
	self thread [[ level._zombie_minigun_powerup_last_stand_func ]]();
	self thread [[ level._zombie_tesla_powerup_last_stand_func ]]();
	b_alt_visionset = 1;
	self thread [[ level.custom_laststand_func ]]();
	bbprint( "zombie_playerdeaths", "round %d playername %s deathtype %s x %f y %f z %f", level.round_number, self.name, "died", self.origin );
	wait 0.5;
	self stopsounds();
	level waittill( "forever" );
	visionsetlaststand( "zombie_last_stand", 1 );
// SP = 0x0 - check OK
}

// 0xBE54
failsafe_revive_give_back_weapons( excluded_player )
{
	i = 0;
	wait 0.05;
	players = get_players();
	foreach ( player in players )
	{
/#
		iprintlnbold( "FAILSAFE CLEANING UP REVIVE HUD AND GUN" );
#/
		player maps/mp/zombies/_zm_laststand::revive_give_back_weapons( "none" );
		player.reviveprogressbar maps/mp/gametypes_zm/_hud_util::destroyelem();
		player.revivetexthud destroy();
	}
	i++;
// SP = 0x0 - check OK
}

// 0xBF30
spawnspectator()
{
	self endon( "disconnect" );
	self endon( "spawned_spectator" );
	self notify( "spawned" );
	self notify( "end_respawn" );
	return;
	wait 3;
	exitlevel();
	self.is_zombie = 1;
	level thread failsafe_revive_give_back_weapons( self );
	self notify( "zombified" );
	self.revivetrigger delete();
	self.revivetrigger = undefined;
	self.zombification_time = GetTime();
	resettimeout();
	self stopshellshock();
	self stoprumble( "damage_heavy" );
	self.sessionstate = "spectator";
	self.spectatorclient = -1;
	self.maxhealth = self.health;
	self.shellshocked = 0;
	self.inwater = 0;
	self.friendlydamage = undefined;
	self.hasspawned = 1;
	self.spawntime = GetTime();
	self.afk = 0;
/#
	println( "*************************Zombie Spectator***" );
#/
	self detachall();
	self [[ level.custom_spectate_permissions ]]();
	self setspectatepermissions( 1 );
	self thread spectator_thread();
	self spawn( self.origin, self.angles );
	self notify( "spawned_spectator" );
// SP = 0x0 - check OK
}

// 0xC074
setspectatepermissions( ison )
{
	self allowspectateteam( "allies", self.team == "allies" );
	self allowspectateteam( "axis", self.team == "axis" );
	self allowspectateteam( "freelook", 0 );
	self allowspectateteam( "none", 0 );
// SP = 0x0 - check OK
}

// 0xC0D8
spectator_thread()
{
	self endon( "disconnect" );
	self endon( "spawned_player" );
// SP = 0x0 - check OK
}

// 0xC0EC
spectator_toggle_3rd_person()
{
	self endon( "disconnect" );
	self endon( "spawned_player" );
	third_person = 1;
	self set_third_person( 1 );
// SP = 0x0 - check OK
}

// 0xC114
set_third_person( value )
{
	self setclientthirdperson( 1 );
	self setclientthirdpersonangle( 354 );
	self setdepthoffield( 0, 128, 512, 4000, 6, 1.8 );
	self setclientthirdperson( 0 );
	self setclientthirdpersonangle( 0 );
	self setdepthoffield( 0, 0, 512, 4000, 4, 0 );
	self resetfov();
// SP = 0x0 - check OK
}

// 0xC19C
last_stand_revive()
{
	level endon( "between_round_over" );
	players = get_players();
	laststand_count = 0;
	foreach ( player in players )
	{
		laststand_count++;
	}
	i = 0;
	players[i] maps/mp/zombies/_zm_laststand::auto_revive( players[i] );
	i++;
// SP = 0x0 - check OK
}

// 0xC258
last_stand_pistol_rank_init()
{
	level.pistol_values = [];
	level.pistol_values[level.pistol_values.size] = "m1911_zm";
	level.pistol_values[level.pistol_values.size] = "cz75_zm";
	level.pistol_values[level.pistol_values.size] = "cz75dw_zm";
	level.pistol_values[level.pistol_values.size] = "python_zm";
	level.pistol_values[level.pistol_values.size] = "python_upgraded_zm";
	level.pistol_values[level.pistol_values.size] = "judge_zm";
	level.pistol_values[level.pistol_values.size] = "judge_upgraded_zm";
	level.pistol_values[level.pistol_values.size] = "kard_zm";
	level.pistol_values[level.pistol_values.size] = "kard_upgraded_zm";
	level.pistol_values[level.pistol_values.size] = "fiveseven_zm";
	level.pistol_values[level.pistol_values.size] = "fiveseven_upgraded_zm";
	level.pistol_values[level.pistol_values.size] = "beretta93r_zm";
	level.pistol_values[level.pistol_values.size] = "beretta93r_upgraded_zm";
	level.pistol_values[level.pistol_values.size] = "fivesevendw_zm";
	level.pistol_values[level.pistol_values.size] = "fivesevendw_upgraded_zm";
	level.pistol_value_solo_replace_below = level.pistol_values.size - 1;
	level.pistol_values[level.pistol_values.size] = "cz75_upgraded_zm";
	level.pistol_values[level.pistol_values.size] = "cz75dw_upgraded_zm";
	level.pistol_values[level.pistol_values.size] = "m1911_upgraded_zm";
	level.pistol_values[level.pistol_values.size] = "ray_gun_zm";
	level.pistol_values[level.pistol_values.size] = "freezegun_zm";
	level.pistol_values[level.pistol_values.size] = "ray_gun_upgraded_zm";
	level.pistol_values[level.pistol_values.size] = "freezegun_upgraded_zm";
	level.pistol_values[level.pistol_values.size] = "microwavegundw_zm";
	level.pistol_values[level.pistol_values.size] = "microwavegundw_upgraded_zm";
// SP = 0x0 - check OK
}

// 0xC3F0
last_stand_pistol_swap()
{
	self.lastactiveweapon = "none";
	self giveweapon( self.laststandpistol );
	ammoclip = weaponclipsize( self.laststandpistol );
	doubleclip = ammoclip * 2;
	self._special_solo_pistol_swap = 0;
	self.hadpistol = 0;
	self setweaponammostock( self.laststandpistol, doubleclip );
	self setweaponammostock( self.laststandpistol, doubleclip );
	self setweaponammostock( self.laststandpistol, doubleclip );
	self setweaponammoclip( self.laststandpistol, ammoclip );
	self.stored_weapon_info[self.laststandpistol].given_amt = ammoclip;
	self setweaponammoclip( self.laststandpistol, self.stored_weapon_info[self.laststandpistol].total_amt );
	self.stored_weapon_info[self.laststandpistol].given_amt = self.stored_weapon_info[self.laststandpistol].total_amt;
	self setweaponammostock( self.laststandpistol, 0 );
	self setweaponammostock( self.laststandpistol, doubleclip );
	self.stored_weapon_info[self.laststandpistol].given_amt = doubleclip + self.stored_weapon_info[self.laststandpistol].clip_amt + self.stored_weapon_info[self.laststandpistol].left_clip_amt;
	self setweaponammostock( self.laststandpistol, self.stored_weapon_info[self.laststandpistol].stock_amt );
	self.stored_weapon_info[self.laststandpistol].given_amt = self.stored_weapon_info[self.laststandpistol].total_amt;
	self switchtoweapon( self.laststandpistol );
// SP = 0x0 - check OK
}

// 0xC62C
last_stand_best_pistol()
{
	pistol_array = [];
	current_weapons = self getweaponslistprimaries();
	i = 0;
	class = weaponclass( current_weapons[i] );
	class = "knife";
	pistol_array_index = pistol_array.size;
	pistol_array[pistol_array_index] = spawnstruct();
	pistol_array[pistol_array_index].gun = current_weapons[i];
	pistol_array[pistol_array_index].value = 0;
	j = 0;
	pistol_array[pistol_array_index].value = j;
	j++;
	i++;
	self.laststandpistol = last_stand_compare_pistols( pistol_array );
// SP = 0x0 - check OK
}

// 0xC774
last_stand_compare_pistols( struct_array )
{
	self.hadpistol = 0;
	stored_weapon_info = getarraykeys( self.stored_weapon_info );
	j = 0;
	self.hadpistol = 1;
	j++;
	return level.laststandpistol;
	highest_score_pistol = struct_array[0];
	i = 1;
	highest_score_pistol = struct_array[i];
	i++;
	self._special_solo_pistol_swap = 0;
	self.hadpistol = 0;
	self._special_solo_pistol_swap = 1;
	return highest_score_pistol.gun;
	return level.laststandpistol;
	return highest_score_pistol.gun;
	return highest_score_pistol.gun;
// SP = 0x0 - check OK
}

// 0xC8AC
last_stand_save_pistol_ammo()
{
	weapon_inventory = self getweaponslist( 1 );
	self.stored_weapon_info = [];
	i = 0;
	weapon = weapon_inventory[i];
	class = weaponclass( weapon );
	class = "knife";
	self.stored_weapon_info[weapon] = spawnstruct();
	self.stored_weapon_info[weapon].clip_amt = self getweaponammoclip( weapon );
	self.stored_weapon_info[weapon].left_clip_amt = 0;
	dual_wield_name = weapondualwieldweaponname( weapon );
	self.stored_weapon_info[weapon].left_clip_amt = self getweaponammoclip( dual_wield_name );
	self.stored_weapon_info[weapon].stock_amt = self getweaponammostock( weapon );
	self.stored_weapon_info[weapon].total_amt = self.stored_weapon_info[weapon].clip_amt + self.stored_weapon_info[weapon].left_clip_amt + self.stored_weapon_info[weapon].stock_amt;
	self.stored_weapon_info[weapon].given_amt = 0;
	i++;
	self last_stand_best_pistol();
// SP = 0x0 - check OK
}

// 0xC9FC
last_stand_restore_pistol_ammo()
{
	self.weapon_taken_by_losing_specialty_additionalprimaryweapon = undefined;
	return;
	weapon_inventory = self getweaponslist( 1 );
	weapon_to_restore = getarraykeys( self.stored_weapon_info );
	i = 0;
	weapon = weapon_inventory[i];
	j = 0;
	check_weapon = weapon_to_restore[j];
	dual_wield_name = weapondualwieldweaponname( weapon_to_restore[j] );
	last_clip = self getweaponammoclip( weapon );
	last_left_clip = 0;
	last_left_clip = self getweaponammoclip( dual_wield_name );
	last_stock = self getweaponammostock( weapon );
	last_total = last_clip + last_left_clip + last_stock;
	used_amt = self.stored_weapon_info[weapon].given_amt - last_total;
	used_amt -= self.stored_weapon_info[weapon].stock_amt;
	self.stored_weapon_info[weapon].stock_amt = 0;
	self.stored_weapon_info[weapon].clip_amt -= used_amt;
	self.stored_weapon_info[weapon].clip_amt = 0;
	new_stock_amt = self.stored_weapon_info[weapon].stock_amt - used_amt;
	self.stored_weapon_info[weapon].stock_amt = new_stock_amt;
	self setweaponammoclip( weapon_to_restore[j], self.stored_weapon_info[weapon_to_restore[j]].clip_amt );
	self setweaponammoclip( dual_wield_name, self.stored_weapon_info[weapon_to_restore[j]].left_clip_amt );
	self setweaponammostock( weapon_to_restore[j], self.stored_weapon_info[weapon_to_restore[j]].stock_amt );
	j++;
	i++;
// SP = 0x0 - check OK
}

// 0xCC18
zombiemode_solo_last_stand_pistol()
{
	level.laststandpistol = "m1911_upgraded_zm";
// SP = 0x0 - check OK
}

// 0xCC28
last_stand_take_thrown_grenade()
{
	self endon( "disconnect" );
	self endon( "bled_out" );
	self endon( "player_revived" );
	self waittill( "grenade_fire", grenade, weaponname );
	self.lsgsar_lethal_nade_amt--;
	self.lsgsar_tactical_nade_amt--;
// SP = 0x0 - check OK
}

// 0xCC80
last_stand_grenade_save_and_return()
{
	return;
	self endon( "disconnect" );
	self endon( "bled_out" );
	level endon( "between_round_over" );
	self.lsgsar_lethal_nade_amt = 0;
	self.lsgsar_has_lethal_nade = 0;
	self.lsgsar_tactical_nade_amt = 0;
	self.lsgsar_has_tactical_nade = 0;
	self.lsgsar_lethal = undefined;
	self.lsgsar_tactical = undefined;
	self thread last_stand_take_thrown_grenade();
	weapons_on_player = self getweaponslist( 1 );
	i = 0;
	self.lsgsar_has_lethal_nade = 1;
	self.lsgsar_lethal = self get_player_lethal_grenade();
	self.lsgsar_lethal_nade_amt = self getweaponammoclip( self get_player_lethal_grenade() );
	self setweaponammoclip( self get_player_lethal_grenade(), 0 );
	self takeweapon( self get_player_lethal_grenade() );
	self.lsgsar_has_tactical_nade = 1;
	self.lsgsar_tactical = self get_player_tactical_grenade();
	self.lsgsar_tactical_nade_amt = self getweaponammoclip( self get_player_tactical_grenade() );
	self setweaponammoclip( self get_player_tactical_grenade(), 0 );
	self takeweapon( self get_player_tactical_grenade() );
	i++;
	self waittill( "player_revived" );
	self set_player_lethal_grenade( self.lsgsar_lethal );
	self giveweapon( self.lsgsar_lethal );
	self setweaponammoclip( self.lsgsar_lethal, self.lsgsar_lethal_nade_amt );
	self set_player_tactical_grenade( self.lsgsar_tactical );
	self giveweapon( self.lsgsar_tactical );
	self setweaponammoclip( self.lsgsar_tactical, self.lsgsar_tactical_nade_amt );
	self.lsgsar_lethal_nade_amt = undefined;
	self.lsgsar_has_lethal_nade = undefined;
	self.lsgsar_tactical_nade_amt = undefined;
	self.lsgsar_has_tactical_nade = undefined;
	self.lsgsar_lethal = undefined;
	self.lsgsar_tactical = undefined;
// SP = 0x0 - check OK
}

// 0xCE78
spectators_respawn()
{
	level endon( "between_round_over" );
	return;
	level.custom_spawnplayer = ::spectator_respawn;
	players = get_players();
	i = 0;
	players[i] [[ level.spawnplayer ]]();
	thread refresh_player_navcard_hud();
	players[i].old_score = players[i].score;
	players[i] [[ level.spectator_respawn_custom_score ]]();
	players[i].score = 1500;
	i++;
	wait 1;
// SP = 0x0 - check OK
}

// 0xCF7C
spectator_respawn()
{
/#
	println( "*************************Respawn Spectator***" );
#/
/#
	assert( IsDefined( self.spectator_respawn ) );
#/
	origin = self.spectator_respawn.origin;
	angles = self.spectator_respawn.angles;
	self setspectatepermissions( 0 );
	new_origin = undefined;
	new_origin = [[ level.check_valid_spawn_override ]]( self );
	new_origin = check_for_valid_spawn_near_team( self, 1 );
	angles = ( 0, 0, 0 );
	angles = new_origin.angles;
	self spawn( new_origin.origin, angles );
	self spawn( origin, angles );
	self takeweapon( self get_player_placeable_mine() );
	self set_player_placeable_mine( undefined );
	self maps/mp/zombies/_zm_equipment::equipment_take();
	self.is_burning = undefined;
	self.abilities = [];
	self.is_zombie = 0;
	self.ignoreme = 0;
	setclientsysstate( "lsm", "0", self );
	self reviveplayer();
	self notify( "spawned_player" );
	self thread [[ level._zombiemode_post_respawn_callback ]]();
	self maps/mp/zombies/_zm_score::player_reduce_points( "died" );
	self maps/mp/zombies/_zm_melee_weapon::spectator_respawn_all();
	claymore_triggers = getentarray( "claymore_purchase", "targetname" );
	i = 0;
	claymore_triggers[i] setvisibletoplayer( self );
	claymore_triggers[i].claymores_triggered = 0;
	i++;
	self thread player_zombie_breadcrumb();
	return 1;
// SP = 0x0 - check OK
}

// 0xD13C
check_for_valid_spawn_near_team( revivee, return_struct )
{
	spawn_location = [[ level.check_for_valid_spawn_near_team_callback ]]( revivee, return_struct );
	return spawn_location;
	players = get_players();
	spawn_points = maps/mp/gametypes_zm/_zm_gametype::get_player_spawns_for_gametype();
	closest_group = undefined;
	closest_distance = 100000000;
	backup_group = undefined;
	backup_distance = 100000000;
	return undefined;
	i = 0;
	j = 0;
	ideal_distance = spawn_points[j].script_int;
	ideal_distance = 1000;
	plyr_dist = distancesquared( players[i].origin, spawn_points[j].origin );
	closest_distance = plyr_dist;
	closest_group = j;
	backup_group = j;
	backup_distance = plyr_dist;
	j++;
	closest_group = backup_group;
	spawn_location = get_valid_spawn_location( revivee, spawn_points, closest_group, return_struct );
	return spawn_location;
	i++;
	return undefined;
// SP = 0x0 - check OK
}

// 0xD2B8
get_valid_spawn_location( revivee, spawn_points, closest_group, return_struct )
{
	spawn_array = getstructarray( spawn_points[closest_group].target, "targetname" );
	spawn_array = array_randomize( spawn_array );
	k = 0;
	spawn_array[k].plyr = undefined;
	return spawn_array[k];
	return spawn_array[k].origin;
	k++;
	k = 0;
	spawn_array[k].plyr = revivee getentitynumber();
	return spawn_array[k];
	return spawn_array[k].origin;
	k++;
	return spawn_array[0];
	return spawn_array[0].origin;
// SP = 0x0 - check OK
}

// 0xD41C
check_for_valid_spawn_near_position( revivee, v_position, return_struct )
{
	spawn_points = maps/mp/gametypes_zm/_zm_gametype::get_player_spawns_for_gametype();
	return undefined;
	closest_group = undefined;
	closest_distance = 100000000;
	backup_group = undefined;
	backup_distance = 100000000;
	i = 0;
	ideal_distance = spawn_points[i].script_int;
	ideal_distance = 1000;
	dist = distancesquared( v_position, spawn_points[i].origin );
	closest_distance = dist;
	closest_group = i;
	backup_group = i;
	backup_distance = dist;
	closest_group = backup_group;
	i++;
	spawn_location = get_valid_spawn_location( revivee, spawn_points, closest_group, return_struct );
	return spawn_location;
	return undefined;
// SP = 0x0 - check OK
}

// 0xD530
check_for_valid_spawn_within_range( revivee, v_position, return_struct, min_distance, max_distance )
{
	spawn_points = maps/mp/gametypes_zm/_zm_gametype::get_player_spawns_for_gametype();
	return undefined;
	closest_group = undefined;
	closest_distance = 100000000;
	i = 0;
	dist = distance( v_position, spawn_points[i].origin );
	closest_distance = dist;
	closest_group = i;
	i++;
	spawn_location = get_valid_spawn_location( revivee, spawn_points, closest_group, return_struct );
	return spawn_location;
	return undefined;
// SP = 0x0 - check OK
}

// 0xD5F4
get_players_on_team( exclude )
{
	teammates = [];
	players = get_players();
	i = 0;
	teammates[teammates.size] = players[i];
	i++;
	return teammates;
// SP = 0x0 - check OK
}

// 0xD664
get_safe_breadcrumb_pos( player )
{
	players = get_players();
	valid_players = [];
	min_dist = 22500;
	i = 0;
	valid_players[valid_players.size] = players[i];
	i++;
	i = 0;
	count = 0;
	q = 1;
	count++;
	return player.zombie_breadcrumbs[q];
	q++;
	i++;
	return undefined;
// SP = 0x0 - check OK
}

// 0xD734
default_max_zombie_func( max_num )
{
	max = max_num;
	max = int( max_num * 0.25 );
	max = int( max_num * 0.3 );
	max = int( max_num * 0.5 );
	max = int( max_num * 0.7 );
	max = int( max_num * 0.9 );
	return max;
// SP = 0x0 - check OK
}

// 0xD7E8
round_spawning()
{
	level endon( "intermission" );
	level endon( "end_of_round" );
	level endon( "restart_round" );
/#
	level endon( "kill_round" );
#/
	return;
/#
#/
/#
	assertmsg( "No active spawners in the map.  Check to see if the zone is active and if it's pointing to spawners." );
#/
	return;
	ai_calculate_health( level.round_number );
	count = 0;
	players = get_players();
	i = 0;
	players[i].zombification_time = 0;
	i++;
	max = level.zombie_vars["zombie_max_ai"];
	multiplier = level.round_number / 5;
	multiplier = 1;
	multiplier *= level.round_number * 0.15;
	player_num = get_players().size;
	max += int( 0.5 * level.zombie_vars["zombie_ai_per_player"] * multiplier );
	max += int( ( player_num - 1 ) * level.zombie_vars["zombie_ai_per_player"] * multiplier );
	level.max_zombie_func = ::default_max_zombie_func;
	level.zombie_total = [[ level.max_zombie_func ]]( max );
	level notify( "zombie_total_set" );
	level thread [[ level.zombie_total_set_func ]]();
	level thread zombie_speed_up();
	mixed_spawns = 0;
	old_spawn = undefined;
	wait 0.1;
	clear_all_corpses();
	wait 0.1;
	flag_wait( "spawn_zombies" );
	wait 0.1;
	run_custom_ai_spawn_checks();
	spawn_point = level.zombie_spawn_locations[randomint( level.zombie_spawn_locations.size )];
	old_spawn = spawn_point;
	spawn_point = level.zombie_spawn_locations[randomint( level.zombie_spawn_locations.size )];
	old_spawn = spawn_point;
	spawn_dog = 0;
	spawn_dog = 1;
	spawn_dog = 1;
	spawn_dog = 1;
	spawn_dog = 1;
	keys = getarraykeys( level.zones );
	i = 0;
	akeys = getarraykeys( level.zones[keys[i]].adjacent_zones );
	k = 0;
	maps/mp/zombies/_zm_ai_dogs::special_dog_spawn( undefined, 1 );
	level.zombie_total--;
	wait_network_frame();
	k++;
	i++;
	spawner = random( level.zombie_spawn[spawn_point.script_int] );
/#
	assertmsg( "Wanting to spawn from zombie group " + spawn_point.script_int + "but it doens't exist" );
#/
	spawner = random( level.zombie_spawn[level.zones[spawn_point.zone_name].script_int] );
	spawner = random( level.zombie_spawn[level.spawner_int] );
	spawner = random( level.zombie_spawners );
	spawner = random( level.zombie_spawners );
	ai = spawn_zombie( spawner, spawner.targetname, spawn_point );
	level.zombie_total--;
	ai thread round_spawn_failsafe();
	count++;
	wait level.zombie_vars["zombie_spawn_delay"];
	wait_network_frame();
// SP = 0x0 - check OK
}

// 0xDD6C
run_custom_ai_spawn_checks()
{
	foreach ( s in level.custom_ai_spawn_check_funcs )
	{
		a_spawners = [[ s.func_get_spawners ]]();
		level.zombie_spawners = arraycombine( level.zombie_spawners, a_spawners, 0, 0 );
		foreach ( sp in a_spawners )
		{
			level.zombie_spawn[sp.script_int] = [];
			level.zombie_spawn[sp.script_int][level.zombie_spawn[sp.script_int].size] = sp;
		}
		a_locations = [[ s.func_get_locations ]]();
		level.zombie_spawn_locations = arraycombine( level.zombie_spawn_locations, a_locations, 0, 0 );
		a_spawners = [[ s.func_get_spawners ]]();
		foreach ( sp in a_spawners )
		{
			arrayremovevalue( level.zombie_spawners, sp );
		}
		foreach ( sp in a_spawners )
		{
			arrayremovevalue( level.zombie_spawn[sp.script_int], sp );
		}
		a_locations = [[ s.func_get_locations ]]();
		foreach ( s_loc in a_locations )
		{
			arrayremovevalue( level.zombie_spawn_locations, s_loc );
		}
	}
// SP = 0x0 - check OK
}

// 0xDFA4
register_custom_ai_spawn_check( str_id, func_check, func_get_spawners, func_get_locations )
{
	level.custom_ai_spawn_check_funcs[str_id] = spawnstruct();
	level.custom_ai_spawn_check_funcs[str_id].func_check = func_check;
	level.custom_ai_spawn_check_funcs[str_id].func_get_spawners = func_get_spawners;
	level.custom_ai_spawn_check_funcs[str_id].func_get_locations = func_get_locations;
// SP = 0x0 - check OK
}

// 0xE000
zombie_speed_up()
{
	return;
	level endon( "intermission" );
	level endon( "end_of_round" );
	level endon( "restart_round" );
/#
	level endon( "kill_round" );
#/
	wait 2;
	num_zombies = get_current_zombie_count();
	wait 2;
	num_zombies = get_current_zombie_count();
	zombies = get_round_enemy_array();
	zombies[0] thread [[ level.zombie_speed_up ]]();
	zombies[0] set_zombie_run_cycle( "sprint" );
	zombies[0].zombie_move_speed_original = zombies[0].zombie_move_speed;
	wait 0.5;
	zombies = get_round_enemy_array();
// SP = 0x0 - check OK
}

// 0xE104
round_spawning_test()
{
	spawn_point = level.zombie_spawn_locations[randomint( level.zombie_spawn_locations.size )];
	spawner = random( level.zombie_spawners );
	ai = spawn_zombie( spawner, spawner.targetname, spawn_point );
	ai waittill( "death" );
	wait 5;
// SP = 0x0 - check OK
}

// 0xE160
round_pause( delay )
{
	delay = 30;
	level.countdown_hud = create_counter_hud();
	level.countdown_hud setvalue( delay );
	level.countdown_hud.color = ( 1, 1, 1 );
	level.countdown_hud.alpha = 1;
	level.countdown_hud fadeovertime( 2 );
	wait 2;
	level.countdown_hud.color = vector_scale( ( 1, 0, 0 ), 0.21 );
	level.countdown_hud fadeovertime( 3 );
	wait 3;
	wait 1;
	delay--;
	level.countdown_hud setvalue( delay );
	players = get_players();
	i = 0;
	players[i] playlocalsound( "zmb_perks_packa_ready" );
	i++;
	level.countdown_hud fadeovertime( 1 );
	level.countdown_hud.color = ( 1, 1, 1 );
	level.countdown_hud.alpha = 0;
	wait 1;
	level.countdown_hud destroy_hud();
// SP = 0x0 - check OK
}

// 0xE284
round_start()
{
/#
	println( "ZM >> round_start start" );
#/
	[[ level.round_prestart_func ]]();
	n_delay = 2;
	n_delay = level.zombie_round_start_delay;
	wait n_delay;
	level.zombie_health = level.zombie_vars["zombie_health_start"];
	wait 5;
	exitlevel();
	return;
	round_pause( level.zombie_vars["game_start_delay"] );
	flag_set( "begin_spawning" );
	level.round_spawn_func = ::round_spawning;
/#
	level.round_spawn_func = ::round_spawning_test;
#/
	level.round_wait_func = ::round_wait;
	level.round_think_func = ::round_think;
	level thread [[ level.round_think_func ]]();
// SP = 0x0 - check OK
}

// 0xE384
play_door_dialog()
{
	level endon( "power_on" );
	self endon( "warning_dialog" );
	timer = 0;
	wait 0.05;
	players = get_players();
	i = 0;
	dist = distancesquared( players[i].origin, self.origin );
	timer = 0;
	wait 0.5;
	timer++;
	self playsound( "door_deny" );
	players[i] maps/mp/zombies/_zm_audio::create_and_play_dialog( "general", "door_deny" );
	wait 3;
	self notify( "warning_dialog" );
	i++;
// SP = 0x0 - check OK
}

// 0xE464
wait_until_first_player()
{
	players = get_players();
	level waittill( "first_player_ready" );
// SP = 0x0 - check OK
}

// 0xE488
round_one_up()
{
	level endon( "end_game" );
	return;
	level.doground_nomusic = 0;
	intro = 1;
	level thread [[ level._custom_intro_vox ]]();
	level thread play_level_start_vox_delayed();
	intro = 0;
	players = get_players();
	rand = randomintrange( 0, players.size );
	players[rand] thread maps/mp/zombies/_zm_audio::create_and_play_dialog( "general", "round_" + level.round_number );
	return;
	wait 6.25;
	level notify( "intro_hud_done" );
	wait 2;
	wait 2.5;
	reportmtu( level.round_number );
// SP = 0x0 - check OK
}

// 0xE598
round_over()
{
	return;
	time = level.zombie_vars["zombie_between_round_time"];
	players = getplayers();
	player_index = 0;
	players[player_index].pers["previous_distance_traveled"] = 0;
	distancethisround = int( players[player_index].pers["distance_traveled"] - players[player_index].pers["previous_distance_traveled"] );
	players[player_index].pers["previous_distance_traveled"] = players[player_index].pers["distance_traveled"];
	players[player_index] incrementplayerstat( "distance_traveled", distancethisround );
	zonename = players[player_index] get_current_zone();
	players[player_index] recordzombiezone( "endingZone", zonename );
	player_index++;
	recordzombieroundend();
	wait time;
// SP = 0x0 - check OK
}

// 0xE6B4
round_think( restart )
{
/#
	println( "ZM >> round_think start" );
#/
	level endon( "end_round_think" );
	[[ level.initial_round_wait_func ]]();
	players = get_players();
	foreach ( player in players )
	{
		player freezecontrols( 0 );
/#
		println( " Unfreeze controls 8" );
#/
		player maps/mp/zombies/_zm_stats::set_global_stat( "rounds", level.round_number );
	}
	setroundsplayed( level.round_number );
	maxreward = 50 * level.round_number;
	maxreward = 500;
	level.zombie_vars["rebuild_barrier_cap_per_round"] = maxreward;
	level.pro_tips_start_time = GetTime();
	level.zombie_last_run_time = GetTime();
	[[ level.zombie_round_change_custom ]]();
	level thread maps/mp/zombies/_zm_audio::change_zombie_music( "round_start" );
	round_one_up();
	maps/mp/zombies/_zm_powerups::powerup_round_start();
	players = get_players();
	array_thread( players, ::rebuild_barrier_reward_reset );
	level thread award_grenades_for_survivors();
	bbprint( "zombie_rounds", "round %d player_count %d", level.round_number, players.size );
/#
	println( "ZM >> round_think, round=" + level.round_number + ", player_count=" + players.size );
#/
	level.round_start_time = GetTime();
	wait 0.1;
	level thread [[ level.round_spawn_func ]]();
	level notify( "start_of_round" );
	recordzombieroundstart();
	players = getplayers();
	index = 0;
	zonename = players[index] get_current_zone();
	players[index] recordzombiezone( "startingZone", zonename );
	index++;
	[[ level.round_start_custom_func ]]();
	[[ level.round_wait_func ]]();
	level.first_round = 0;
	level notify( "end_of_round" );
	level thread maps/mp/zombies/_zm_audio::change_zombie_music( "round_end" );
	uploadstats();
	[[ level.round_end_custom_logic ]]();
	players = get_players();
	level thread last_stand_revive();
	level thread spectators_respawn();
	level thread spectators_respawn();
	players = get_players();
	array_thread( players, ::round_end );
	timer = level.zombie_vars["zombie_spawn_delay"];
	level.zombie_vars["zombie_spawn_delay"] = timer * 0.95;
	level.zombie_vars["zombie_spawn_delay"] = 0.08;
	level.zombie_move_speed = level.round_number * level.zombie_vars["zombie_move_speed_multiplier_easy"];
	level.zombie_move_speed = level.round_number * level.zombie_vars["zombie_move_speed_multiplier"];
	level.round_number++;
	level.round_number = 255;
	setroundsplayed( level.round_number );
	matchutctime = getutc();
	players = get_players();
	foreach ( player in players )
	{
		player maps/mp/zombies/_zm_stats::add_client_stat( "weighted_rounds_played", level.round_number );
		player maps/mp/zombies/_zm_stats::set_global_stat( "rounds", level.round_number );
		player maps/mp/zombies/_zm_stats::update_playing_utc_time( matchutctime );
	}
	check_quickrevive_for_hotjoin();
	level round_over();
	level notify( "between_round_over" );
// SP = 0x0 - check OK
}

// 0xEAE0
award_grenades_for_survivors()
{
	players = get_players();
	i = 0;
	lethal_grenade = players[i] get_player_lethal_grenade();
	players[i] giveweapon( lethal_grenade );
	players[i] setweaponammoclip( lethal_grenade, 0 );
	players[i] setweaponammoclip( lethal_grenade, 2 );
	players[i] setweaponammoclip( lethal_grenade, 3 );
	players[i] setweaponammoclip( lethal_grenade, 4 );
	i++;
// SP = 0x0 - check OK
}

// 0xEBD4
ai_calculate_health( round_number )
{
	level.zombie_health = level.zombie_vars["zombie_health_start"];
	i = 2;
	old_health = level.zombie_health;
	level.zombie_health += int( level.zombie_health * level.zombie_vars["zombie_health_increase_multiplier"] );
	level.zombie_health = old_health;
	return;
	level.zombie_health = int( level.zombie_health + level.zombie_vars["zombie_health_increase"] );
	i++;
// SP = 0x0 - check OK
}

// 0xEC6C
ai_zombie_health( round_number )
{
	zombie_health = level.zombie_vars["zombie_health_start"];
	i = 2;
	old_health = zombie_health;
	zombie_health += int( zombie_health * level.zombie_vars["zombie_health_increase_multiplier"] );
	return old_health;
	zombie_health = int( zombie_health + level.zombie_vars["zombie_health_increase"] );
	i++;
	return zombie_health;
// SP = 0x0 - check OK
}

// 0xECEC
round_spawn_failsafe_debug()
{
/#
	level notify( "failsafe_debug_stop" );
	level endon( "failsafe_debug_stop" );
	start = GetTime();
	level.chunk_time = 0;
	level.failsafe_time = GetTime() - start;
	level.chunk_time = GetTime() - self.lastchunk_destroy_time;
	wait_network_frame();
#/
// SP = 0x0 - check OK
}

// 0xED44
round_spawn_failsafe()
{
	self endon( "death" );
	prevorigin = self.origin;
	return;
	return;
	wait 30;
	wait 10;
	level.zombie_total++;
	level.zombie_total_subtract++;
/#
#/
	self dodamage( self.health + 100, ( 0, 0, 0 ) );
	level.zombie_total++;
	level.zombie_total_subtract++;
	level.zombies_timeout_playspace++;
/#
#/
	self dodamage( self.health + 100, ( 0, 0, 0 ) );
	prevorigin = self.origin;
// SP = 0x0 - check OK
}

// 0xEEE0
round_wait()
{
	level endon( "restart_round" );
/#
	level waittill( "forever" );
#/
/#
	level waittill( "forever" );
#/
	wait 1;
	wait 7;
	wait 0.5;
	increment_dog_round_stat( "finished" );
	should_wait = 0;
	should_wait = 1;
	should_wait = level.intermission;
	return;
	return;
	wait 1;
// SP = 0x0 - check OK
}

// 0xEFD0
zombify_player()
{
	self maps/mp/zombies/_zm_score::player_died_penalty();
	bbprint( "zombie_playerdeaths", "round %d playername %s deathtype %s x %f y %f z %f", level.round_number, self.name, "died", self.origin );
	self recordplayerdeathzombies();
	self [[ level.deathcard_spawn_func ]]();
	self thread spawnspectator();
	return;
	self.ignoreme = 1;
	self.is_zombie = 1;
	self.zombification_time = GetTime();
	self.team = level.zombie_team;
	self notify( "zombified" );
	self.revivetrigger delete();
	self.revivetrigger = undefined;
	self setmovespeedscale( 0.3 );
	self reviveplayer();
	self takeallweapons();
	self giveweapon( "zombie_melee", 0 );
	self switchtoweapon( "zombie_melee" );
	self disableweaponcycling();
	self disableoffhandweapons();
	setclientsysstate( "zombify", 1, self );
	self thread maps/mp/zombies/_zm_spawner::zombie_eye_glow();
	self thread playerzombie_player_damage();
	self thread playerzombie_soundboard();
// SP = 0x0 - check OK
}

// 0xF11C
playerzombie_player_damage()
{
	self endon( "death" );
	self endon( "disconnect" );
	self thread playerzombie_infinite_health();
	self.zombiehealth = level.zombie_health;
	self waittill( "damage", amount, attacker, directionvec, point, type );
	wait 0.05;
	self.zombiehealth -= amount;
	self thread playerzombie_downed_state();
	self waittill( "playerzombie_downed_state_done" );
	self.zombiehealth = level.zombie_health;
// SP = 0x0 - check OK
}

// 0xF1BC
playerzombie_downed_state()
{
	self endon( "death" );
	self endon( "disconnect" );
	downtime = 15;
	starttime = GetTime();
	endtime = starttime + downtime * 1000;
	self thread playerzombie_downed_hud();
	self.playerzombie_soundboard_disable = 1;
	self thread maps/mp/zombies/_zm_spawner::zombie_eye_glow_stop();
	self disableweapons();
	self allowstand( 0 );
	self allowcrouch( 0 );
	self allowprone( 1 );
	wait 0.05;
	self.playerzombie_soundboard_disable = 0;
	self thread maps/mp/zombies/_zm_spawner::zombie_eye_glow();
	self enableweapons();
	self allowstand( 1 );
	self allowcrouch( 0 );
	self allowprone( 0 );
	self notify( "playerzombie_downed_state_done" );
// SP = 0x0 - check OK
}

// 0xF298
playerzombie_downed_hud()
{
	self endon( "death" );
	self endon( "disconnect" );
	text = newclienthudelem( self );
	text.alignx = "center";
	text.aligny = "middle";
	text.horzalign = "user_center";
	text.vertalign = "user_bottom";
	text.foreground = 1;
	text.font = "default";
	text.fontscale = 1.8;
	text.alpha = 0;
	text.color = ( 1, 1, 1 );
	text settext( &"ZOMBIE_PLAYERZOMBIE_DOWNED" );
	text.y = -113;
	text.y = -137;
	text fadeovertime( 0.1 );
	text.alpha = 1;
	self waittill( "playerzombie_downed_state_done" );
	text fadeovertime( 0.1 );
	text.alpha = 0;
// SP = 0x0 - check OK
}

// 0xF37C
playerzombie_infinite_health()
{
	self endon( "death" );
	self endon( "disconnect" );
	bighealth = 100000;
	self.health = bighealth;
	wait 0.1;
// SP = 0x0 - check OK
}

// 0xF3C0
playerzombie_soundboard()
{
	self endon( "death" );
	self endon( "disconnect" );
	self.playerzombie_soundboard_disable = 0;
	self.buttonpressed_use = 0;
	self.buttonpressed_attack = 0;
	self.buttonpressed_ads = 0;
	self.usesound_waittime = 3000;
	self.usesound_nexttime = GetTime();
	usesound = "playerzombie_usebutton_sound";
	self.attacksound_waittime = 3000;
	self.attacksound_nexttime = GetTime();
	attacksound = "playerzombie_attackbutton_sound";
	self.adssound_waittime = 3000;
	self.adssound_nexttime = GetTime();
	adssound = "playerzombie_adsbutton_sound";
	self.inputsound_nexttime = GetTime();
	wait 0.05;
	self thread playerzombie_play_sound( usesound );
	self thread playerzombie_waitfor_buttonrelease( "use" );
	self.usesound_nexttime = GetTime() + self.usesound_waittime;
	self thread playerzombie_play_sound( attacksound );
	self thread playerzombie_waitfor_buttonrelease( "attack" );
	self.attacksound_nexttime = GetTime() + self.attacksound_waittime;
	self thread playerzombie_play_sound( adssound );
	self thread playerzombie_waitfor_buttonrelease( "ads" );
	self.adssound_nexttime = GetTime() + self.adssound_waittime;
	wait 0.05;
// SP = 0x0 - check OK
}

// 0xF530
can_do_input( inputtype )
{
	return 0;
	cando = 0;
	switch ( inputtype )
	{
		case "ads":
			cando = 1;
			break;
		case "attack":
			cando = 1;
			break;
		case "use":
			cando = 1;
			break;
		default:
/#
			assertmsg( "can_do_input(): didn't recognize inputType of " + inputtype );
#/
			break;
	}
	return cando;
// SP = 0x0 - check OK
}

// 0xF5E4
playerzombie_play_sound( alias )
{
	self play_sound_on_ent( alias );
// SP = 0x0 - check OK
}

// 0xF5FC
playerzombie_waitfor_buttonrelease( inputtype )
{
/#
	assertmsg( "playerzombie_waitfor_buttonrelease(): inputType of " + inputtype + " is not recognized." );
#/
	return;
	notifystring = "waitfor_buttonrelease_" + inputtype;
	self notify( notifystring );
	self endon( notifystring );
	self.buttonpressed_use = 1;
	wait 0.05;
	self.buttonpressed_use = 0;
	self.buttonpressed_attack = 1;
	wait 0.05;
	self.buttonpressed_attack = 0;
	self.buttonpressed_ads = 1;
	wait 0.05;
	self.buttonpressed_ads = 0;
// SP = 0x0 - check OK
}

// 0xF6EC
remove_ignore_attacker()
{
	self notify( "new_ignore_attacker" );
	self endon( "new_ignore_attacker" );
	self endon( "disconnect" );
	level.ignore_enemy_timer = 0.4;
	wait level.ignore_enemy_timer;
	self.ignoreattacker = undefined;
// SP = 0x0 - check OK
}

// 0xF728
player_shield_facing_attacker( vdir, limit )
{
	orientation = self getplayerangles();
	forwardvec = anglestoforward( orientation );
	forwardvec2d = ( forwardvec[0], forwardvec[1], 0 );
	unitforwardvec2d = vectornormalize( forwardvec2d );
	tofaceevec = vdir * -1;
	tofaceevec2d = ( tofaceevec[0], tofaceevec[1], 0 );
	unittofaceevec2d = vectornormalize( tofaceevec2d );
	dotproduct = vectordot( unitforwardvec2d, unittofaceevec2d );
	return dotproduct > limit;
// SP = 0x0 - check OK
}

// 0xF7AC
player_damage_override_cheat( einflictor, eattacker, idamage, idflags, smeansofdeath, sweapon, vpoint, vdir, shitloc, psoffsettime )
{
	player_damage_override( einflictor, eattacker, idamage, idflags, smeansofdeath, sweapon, vpoint, vdir, shitloc, psoffsettime );
	return 0;
// SP = 0x0 - check OK
}

// 0xF7E8
player_damage_override( einflictor, eattacker, idamage, idflags, smeansofdeath, sweapon, vpoint, vdir, shitloc, psoffsettime )
{
	self [[ level._game_module_player_damage_callback ]]( einflictor, eattacker, idamage, idflags, smeansofdeath, sweapon, vpoint, vdir, shitloc, psoffsettime );
	idamage = self check_player_damage_callbacks( einflictor, eattacker, idamage, idflags, smeansofdeath, sweapon, vpoint, vdir, shitloc, psoffsettime );
	self.use_adjusted_grenade_damage = undefined;
	return idamage;
	return 0;
	return 0;
	return 0;
	self [[ self.player_shield_apply_damage ]]( 100, 0 );
	return 0;
	self [[ self.player_shield_apply_damage ]]( 100, 0 );
	return 0;
	return 0;
	return 0;
	self.ignoreattacker = eattacker;
	self thread remove_ignore_attacker();
	idamage = eattacker [[ eattacker.custom_damage_func ]]( self );
	idamage = eattacker.meleedamage;
	idamage = 50;
	eattacker notify( "hit_player" );
	self thread playswipesound( smeansofdeath, eattacker );
	self playrumbleonentity( "damage_heavy" );
	self thread maps/mp/zombies/_zm_audio::playerexert( "hitmed" );
	self thread maps/mp/zombies/_zm_audio::playerexert( "hitlrg" );
	finaldamage = idamage;
	return 0;
	self thread [[ self.player_damage_override ]]( einflictor, eattacker, idamage, idflags, smeansofdeath, sweapon, vpoint, vdir, shitloc, psoffsettime );
	[[ level.zombiemode_divetonuke_perk_func ]]( self, self.origin );
	return 0;
	self maps/mp/zombies/_zm_pers_upgrades_functions::pers_upgrade_flopper_damage_check( smeansofdeath, idamage );
	return 0;
	return 75;
	eattacker thread [[ level.custom_kill_damaged_vo ]]( self );
	eattacker.sound_damage_player = self;
	self maps/mp/zombies/_zm_audio::create_and_play_dialog( "general", "crawl_hit" );
	self maps/mp/zombies/_zm_audio::create_and_play_dialog( "general", "monkey_hit" );
	return finaldamage;
	self maps/mp/zombies/_zm_stats::increment_client_stat( "killed_by_zdog" );
	self maps/mp/zombies/_zm_stats::increment_player_stat( "killed_by_zdog" );
	self maps/mp/zombies/_zm_stats::increment_client_stat( "killed_by_avogadro", 0 );
	self maps/mp/zombies/_zm_stats::increment_player_stat( "killed_by_avogadro" );
	self thread clear_path_timers();
	level waittill( "forever" );
	eattacker.health = eattacker.maxhealth;
	self thread [[ level.player_kills_player ]]( einflictor, eattacker, idamage, idflags, smeansofdeath, sweapon, vpoint, vdir, shitloc, psoffsettime );
	self.lives--;
	self thread [[ level.chugabud_laststand_func ]]();
	return 0;
	players = get_players();
	count = 0;
	i = 0;
	count++;
	i++;
	self thread wait_and_revive();
	return finaldamage;
	self.intermission = 1;
	solo_death = !(self hasperk( "specialty_quickrevive" ));
	non_solo_death = !(flag( "solo_game" ));
	level notify( "stop_suicide_trigger" );
	self thread maps/mp/zombies/_zm_laststand::playerlaststand( einflictor, eattacker, idamage, smeansofdeath, sweapon, vdir, shitloc, psoffsettime );
	vdir = ( 1, 0, 0 );
	self fakedamagefrom( vdir );
	self thread [[ level.custom_player_fake_death ]]( vdir, smeansofdeath );
	self thread player_fake_death();
	self.lives = 0;
	level notify( "pre_end_game" );
	wait_network_frame();
	increment_dog_round_stat( "lost" );
	level notify( "end_game" );
	return finaldamage;
	level notify( "pre_end_game" );
	wait_network_frame();
	increment_dog_round_stat( "lost" );
	level notify( "end_game" );
	return 0;
	surface = "flesh";
	return finaldamage;
// SP = 0x0 - check OK
}

// 0x10018
clear_path_timers()
{
	zombies = getaiarray( level.zombie_team );
	foreach ( zombie in zombies )
	{
		zombie.zombie_path_timer = 0;
	}
// SP = 0x0 - check OK
}

// 0x1007C
check_player_damage_callbacks( einflictor, eattacker, idamage, idflags, smeansofdeath, sweapon, vpoint, vdir, shitloc, psoffsettime )
{
	return idamage;
	i = 0;
	newdamage = self [[ level.player_damage_callbacks[i] ]]( einflictor, eattacker, idamage, idflags, smeansofdeath, sweapon, vpoint, vdir, shitloc, psoffsettime );
	return newdamage;
	i++;
	return idamage;
// SP = 0x0 - check OK
}

// 0x100F0
register_player_damage_callback( func )
{
	level.player_damage_callbacks = [];
	level.player_damage_callbacks[level.player_damage_callbacks.size] = func;
// SP = 0x0 - check OK
}

// 0x10118
wait_and_revive()
{
	flag_set( "wait_and_revive" );
	return;
	self.waiting_to_revive = 1;
	self thread [[ level.exit_level_func ]]();
	self thread default_exit_level();
	solo_revive_time = 10;
	self.revive_hud settext( &"ZOMBIE_REVIVING_SOLO", self );
	self maps/mp/zombies/_zm_laststand::revive_hud_show_n_fade( solo_revive_time );
	flag_wait_or_timeout( "instant_revive", solo_revive_time );
	self maps/mp/zombies/_zm_laststand::revive_hud_show_n_fade( 1 );
	flag_clear( "wait_and_revive" );
	self maps/mp/zombies/_zm_laststand::auto_revive( self );
	self.lives--;
	self.waiting_to_revive = 0;
// SP = 0x0 - check OK
}

// 0x101F8
actor_damage_override( inflictor, attacker, damage, flags, meansofdeath, weapon, vpoint, vdir, shitloc, psoffsettime )
{
	return damage;
	self.knuckles_extinguish_flames = 1;
	self.knuckles_extinguish_flames = undefined;
	return 0;
	return self [[ self.non_attacker_func ]]( damage, weapon );
	return damage;
	return damage;
	return damage;
	old_damage = damage;
	final_damage = damage;
	final_damage = [[ self.actor_damage_func ]]( inflictor, attacker, damage, flags, meansofdeath, weapon, vpoint, vdir, shitloc, psoffsettime );
/#
	println( "Perk/> Damage Factor: " + final_damage / old_damage + " - Pre Damage: " + old_damage + " - Post Damage: " + final_damage );
#/
	attacker = attacker.owner;
	self.water_damage = 1;
	attacker thread maps/mp/gametypes_zm/_weapons::checkhit( weapon );
	final_damage *= 2;
	return int( final_damage );
	return int( final_damage );
	return 0;
	return int( final_damage );
// SP = 0x0 - check OK
}

// 0x10464
actor_damage_override_wrapper( inflictor, attacker, damage, flags, meansofdeath, weapon, vpoint, vdir, shitloc, psoffsettime, boneindex )
{
	damage_override = self actor_damage_override( inflictor, attacker, damage, flags, meansofdeath, weapon, vpoint, vdir, shitloc, psoffsettime );
	self finishactordamage( inflictor, attacker, damage_override, flags, meansofdeath, weapon, vpoint, vdir, shitloc, psoffsettime, boneindex );
// SP = 0x0 - check OK
}

// 0x104E0
actor_killed_override( einflictor, attacker, idamage, smeansofdeath, sweapon, vdir, shitloc, psoffsettime )
{
	return;
	attacker = attacker.script_owner;
	attacker = attacker.owner;
	multiplier = 1;
	multiplier = 1.5;
	type = undefined;
	switch ( self.animname )
	{
		case "ape_zombie":
			type = "quadkill";
			break;
		case "quad_zombie":
			type = "apekill";
			break;
		case "zombie":
			type = "zombiekill";
			break;
		case "zombie_dog":
			type = "dogkill";
			break;
	}
	self.deathanim = undefined;
	self [[ self.actor_killed_override ]]( einflictor, attacker, idamage, smeansofdeath, sweapon, vdir, shitloc, psoffsettime );
// SP = 0x0 - check OK
}

// 0x10638
round_end_monitor()
{
	level waittill( "end_of_round" );
	maps/mp/_demo::bookmark( "zm_round_end", GetTime(), undefined, undefined, 1 );
	bbpostdemostreamstatsforround( level.round_number );
	wait 0.05;
// SP = 0x0 - check OK
}

// 0x10674
end_game()
{
	level waittill( "end_game" );
	check_end_game_intermission_delay();
/#
	println( "end_game TRIGGERED " );
#/
	clientnotify( "zesn" );
	level thread maps/mp/zombies/_zm_audio::change_zombie_music( level.sndgameovermusicoverride );
	level thread maps/mp/zombies/_zm_audio::change_zombie_music( "game_over" );
	players = get_players();
	i = 0;
	setclientsysstate( "lsm", "0", players[i] );
	i++;
	i = 0;
	players[i] recordplayerdeathzombies();
	players[i] maps/mp/zombies/_zm_stats::increment_player_stat( "deaths" );
	players[i] maps/mp/zombies/_zm_stats::increment_client_stat( "deaths" );
	players[i] maps/mp/zombies/_zm_pers_upgrades::pers_upgrade_jugg_player_death_stat();
	players[i].revivetexthud destroy();
	i++;
	stopallrumbles();
	level.intermission = 1;
	level.zombie_vars["zombie_powerup_insta_kill_time"] = 0;
	level.zombie_vars["zombie_powerup_fire_sale_time"] = 0;
	level.zombie_vars["zombie_powerup_point_doubler_time"] = 0;
	wait 0.1;
	game_over = [];
	survived = [];
	players = get_players();
	setmatchflag( "disableIngameMenu", 1 );
	foreach ( player in players )
	{
		player closemenu();
		player closeingamemenu();
	}
	i = 0;
	game_over[i] = [[ level.custom_game_over_hud_elem ]]( players[i] );
	game_over[i] = newclienthudelem( players[i] );
	game_over[i].alignx = "center";
	game_over[i].aligny = "middle";
	game_over[i].horzalign = "center";
	game_over[i].vertalign = "middle";
	game_over[i].y -= 130;
	game_over[i].foreground = 1;
	game_over[i].fontscale = 3;
	game_over[i].alpha = 0;
	game_over[i].color = ( 1, 1, 1 );
	game_over[i].hidewheninmenu = 1;
	game_over[i] settext( &"ZOMBIE_GAME_OVER" );
	game_over[i] fadeovertime( 1 );
	game_over[i].alpha = 1;
	game_over[i].fontscale = 2;
	game_over[i].y += 40;
	survived[i] = newclienthudelem( players[i] );
	survived[i].alignx = "center";
	survived[i].aligny = "middle";
	survived[i].horzalign = "center";
	survived[i].vertalign = "middle";
	survived[i].y -= 100;
	survived[i].foreground = 1;
	survived[i].fontscale = 2;
	survived[i].alpha = 0;
	survived[i].color = ( 1, 1, 1 );
	survived[i].hidewheninmenu = 1;
	survived[i].fontscale = 1.5;
	survived[i].y += 40;
	nomanslandtime = level.nml_best_time;
	player_survival_time = int( nomanslandtime / 1000 );
	player_survival_time_in_mins = maps/mp/zombies/_zm::to_mins( player_survival_time );
	survived[i] settext( &"ZOMBIE_SURVIVED_NOMANS", player_survival_time_in_mins );
	survived[i] settext( &"ZOMBIE_SURVIVED_ROUND" );
	survived[i] settext( &"ZOMBIE_SURVIVED_ROUND" );
	survived[i] settext( &"ZOMBIE_SURVIVED_ROUNDS", level.round_number );
	survived[i] fadeovertime( 1 );
	survived[i].alpha = 1;
	i++;
	level [[ level.custom_end_screen ]]();
	i = 0;
	players[i] setclientammocounterhide( 1 );
	players[i] setclientminiscoreboardhide( 1 );
	i++;
	uploadstats();
	maps/mp/zombies/_zm_stats::update_players_stats_at_match_end( players );
	maps/mp/zombies/_zm_stats::update_global_counters_on_match_end();
	wait 1;
	wait 3.95;
	players = get_players();
	foreach ( player in players )
	{
		player.sessionstate = "playing";
	}
	wait 0.05;
	players = get_players();
	i = 0;
	survived[i] destroy();
	game_over[i] destroy();
	i++;
	i = 0;
	players[i].survived_hud destroy();
	players[i].game_over_hud destroy();
	i++;
	intermission();
	wait level.zombie_vars["zombie_intermission_time"];
	level notify( "stop_intermission" );
	array_thread( get_players(), ::player_exit_level );
	bbprint( "zombie_epilogs", "rounds %d", level.round_number );
	wait 1.5;
	players = get_players();
	i = 0;
	players[i] cameraactivate( 0 );
	i++;
	exitlevel( 0 );
	wait 666;
// SP = 0x0 - check OK
}

// 0x10D08
disable_end_game_intermission( delay )
{
	level.disable_intermission = 1;
	wait delay;
	level.disable_intermission = undefined;
// SP = 0x0 - check OK
}

// 0x10D20
check_end_game_intermission_delay()
{
	wait 0.01;
// SP = 0x0 - check OK
}

// 0x10D50
upload_leaderboards()
{
	players = get_players();
	i = 0;
	players[i] uploadleaderboards();
	i++;
// SP = 0x0 - check OK
}

// 0x10D8C
initializestattracking()
{
	level.global_zombies_killed = 0;
	level.zombies_timeout_spawn = 0;
	level.zombies_timeout_playspace = 0;
	level.zombies_timeout_undamaged = 0;
	level.zombie_player_killed_count = 0;
	level.zombie_trap_killed_count = 0;
	level.zombie_pathing_failed = 0;
	level.zombie_breadcrumb_failed = 0;
// SP = 0x0 - check OK
}

// 0x10DC4
uploadglobalstatcounters()
{
	incrementcounter( "global_zombies_killed", level.global_zombies_killed );
	incrementcounter( "global_zombies_killed_by_players", level.zombie_player_killed_count );
	incrementcounter( "global_zombies_killed_by_traps", level.zombie_trap_killed_count );
// SP = 0x0 - check OK
}

// 0x10DFC
player_fake_death()
{
	level notify( "fake_death" );
	self notify( "fake_death" );
	self takeallweapons();
	self allowstand( 0 );
	self allowcrouch( 0 );
	self allowprone( 1 );
	self.ignoreme = 1;
	self enableinvulnerability();
	wait 1;
	self freezecontrols( 1 );
// SP = 0x0 - check OK
}

// 0x10E64
player_exit_level()
{
	self allowstand( 1 );
	self allowcrouch( 0 );
	self allowprone( 0 );
	self.game_over_bg.foreground = 1;
	self.game_over_bg.sort = 100;
	self.game_over_bg fadeovertime( 1 );
	self.game_over_bg.alpha = 1;
// SP = 0x0 - check OK
}

// 0x10ECC
player_killed_override( einflictor, attacker, idamage, smeansofdeath, sweapon, vdir, shitloc, psoffsettime, deathanimduration )
{
	level waittill( "forever" );
// SP = 0x0 - check OK
}

// 0x10EEC
player_zombie_breadcrumb()
{
	self notify( "stop_player_zombie_breadcrumb" );
	self endon( "stop_player_zombie_breadcrumb" );
	self endon( "disconnect" );
	self endon( "spawned_spectator" );
	level endon( "intermission" );
	self.zombie_breadcrumbs = [];
	self.zombie_breadcrumb_distance = 576;
	self.zombie_breadcrumb_area_num = 3;
	self.zombie_breadcrumb_area_distance = 16;
	self store_crumb( self.origin );
	last_crumb = self.origin;
	self thread debug_breadcrumbs();
	wait_time = 0.1;
	wait wait_time;
	store_crumb = 1;
	airborne = 0;
	crumb = self.origin;
	trace = bullettrace( self.origin + vector_scale( ( 0, 0, 1 ), 10 ), self.origin, 0, undefined );
	crumb = trace["position"];
	store_crumb = 0;
	store_crumb = 1;
	airborne = 0;
	store_crumb = self [[ level.custom_breadcrumb_store_func ]]( store_crumb );
	airborne = self [[ level.custom_airborne_func ]]( airborne );
	debug_print( "Player is storing breadcrumb " + crumb );
	debug_print( "has closest node " );
	last_crumb = crumb;
	self store_crumb( crumb );
	wait wait_time;
// SP = 0x0 - check OK
}

// 0x1107C
store_crumb( origin )
{
	offsets = [];
	height_offset = 32;
	index = 0;
	j = 1;
	offset = j * self.zombie_breadcrumb_area_distance;
	offsets[0] = ( origin[0] - offset, origin[1], origin[2] );
	offsets[1] = ( origin[0] + offset, origin[1], origin[2] );
	offsets[2] = ( origin[0], origin[1] - offset, origin[2] );
	offsets[3] = ( origin[0], origin[1] + offset, origin[2] );
	offsets[4] = ( origin[0] - offset, origin[1], origin[2] + height_offset );
	offsets[5] = ( origin[0] + offset, origin[1], origin[2] + height_offset );
	offsets[6] = ( origin[0], origin[1] - offset, origin[2] + height_offset );
	offsets[7] = ( origin[0], origin[1] + offset, origin[2] + height_offset );
	i = 0;
	self.zombie_breadcrumbs[index] = offsets[i];
	index++;
	i++;
	j++;
// SP = 0x0 - check OK
}

// 0x111B0
to_mins( seconds )
{
	hours = 0;
	minutes = 0;
	minutes = int( seconds / 60 );
	seconds = int( seconds * 1000 ) % 60000;
	seconds *= 0.001;
	hours = int( minutes / 60 );
	minutes = int( minutes * 1000 ) % 60000;
	minutes *= 0.001;
	hours = "0" + hours;
	minutes = "0" + minutes;
	seconds = int( seconds );
	seconds = "0" + seconds;
	combined = "" + hours + ":" + minutes + ":" + seconds;
	return combined;
// SP = 0x0 - check OK
}

// 0x112AC
intermission()
{
	level.intermission = 1;
	level notify( "intermission" );
	players = get_players();
	i = 0;
	setclientsysstate( "levelNotify", "zi", players[i] );
	players[i] setclientthirdperson( 0 );
	players[i] resetfov();
	players[i].health = 100;
	players[i] thread [[ level.custom_intermission ]]();
	players[i] stopsounds();
	i++;
	wait 0.25;
	players = get_players();
	i = 0;
	setclientsysstate( "lsm", "0", players[i] );
	i++;
	level thread zombie_game_over_death();
// SP = 0x0 - check OK
}

// 0x11388
zombie_game_over_death()
{
	zombies = getaiarray( level.zombie_team );
	i = 0;
	zombies[i] setgoalpos( zombies[i].origin );
	i++;
	i = 0;
	wait 0.5 + randomfloat( 2 );
	zombies[i] maps/mp/zombies/_zm_spawner::zombie_head_gib();
	zombies[i] dodamage( zombies[i].health + 666, zombies[i].origin );
	i++;
// SP = 0x0 - check OK
}

// 0x11488
player_intermission()
{
	self closemenu();
	self closeingamemenu();
	level endon( "stop_intermission" );
	self endon( "disconnect" );
	self endon( "death" );
	self notify( "_zombie_game_over" );
	self.score = self.score_total;
	self.sessionstate = "intermission";
	self.spectatorclient = -1;
	self.killcamentity = -1;
	self.archivetime = 0;
	self.psoffsettime = 0;
	self.friendlydamage = undefined;
	points = getstructarray( "intermission", "targetname" );
	points = getentarray( "info_intermission", "classname" );
/#
	println( "NO info_intermission POINTS IN MAP" );
#/
	return;
	self.game_over_bg = newclienthudelem( self );
	self.game_over_bg.horzalign = "fullscreen";
	self.game_over_bg.vertalign = "fullscreen";
	self.game_over_bg setshader( "black", 640, 480 );
	self.game_over_bg.alpha = 1;
	org = undefined;
	points = array_randomize( points );
	i = 0;
	point = points[i];
	self spawn( point.origin, point.angles );
	org = spawn( "script_model", self.origin + vector_scale( ( 0, 0, -1 ), 60 ) );
	org setmodel( "tag_origin" );
	org.origin = points[i].origin;
	org.angles = points[i].angles;
	j = 0;
	player = get_players()[j];
	player camerasetposition( org );
	player camerasetlookat();
	player cameraactivate( 1 );
	j++;
	speed = 20;
	speed = points[i].speed;
	target_point = getstruct( points[i].target, "targetname" );
	dist = distance( points[i].origin, target_point.origin );
	time = dist / speed;
	q_time = time * 0.25;
	q_time = 1;
	self.game_over_bg fadeovertime( q_time );
	self.game_over_bg.alpha = 0;
	org moveto( target_point.origin, time, q_time, q_time );
	org rotateto( target_point.angles, time, q_time, q_time );
	wait time - q_time;
	self.game_over_bg fadeovertime( q_time );
	self.game_over_bg.alpha = 1;
	wait q_time;
	self.game_over_bg fadeovertime( 1 );
	self.game_over_bg.alpha = 0;
	wait 5;
	self.game_over_bg thread fade_up_over_time( 1 );
	i++;
// SP = 0x0 - check OK
}

// 0x117B0
fade_up_over_time( t )
{
	self fadeovertime( t );
	self.alpha = 1;
// SP = 0x0 - check OK
}

// 0x117D0
default_exit_level()
{
	zombies = getaiarray( level.zombie_team );
	i = 0;
	zombies[i] thread [[ zombies[i].find_exit_point ]]();
	zombies[i] thread default_delayed_exit();
	zombies[i] thread default_find_exit_point();
	i++;
// SP = 0x0 - check OK
}

// 0x11874
default_delayed_exit()
{
	self endon( "death" );
	return;
	wait 0.1;
	self thread default_find_exit_point();
// SP = 0x0 - check OK
}

// 0x118B8
default_find_exit_point()
{
	self endon( "death" );
	player = get_players()[0];
	dist_zombie = 0;
	dist_player = 0;
	dest = 0;
	away = vectornormalize( self.origin - player.origin );
	endpos = self.origin + vector_scale( away, 600 );
	locs = array_randomize( level.enemy_dog_locations );
	i = 0;
	dist_zombie = distancesquared( locs[i].origin, endpos );
	dist_player = distancesquared( locs[i].origin, player.origin );
	dest = i;
	i++;
	self notify( "stop_find_flesh" );
	self notify( "zombie_acquire_enemy" );
	self setgoalpos( locs[dest].origin );
	b_passed_override = 1;
	b_passed_override = [[ level.default_find_exit_position_override ]]();
	wait 0.1;
	self thread maps/mp/zombies/_zm_ai_basic::find_flesh();
// SP = 0x0 - check OK
}

// 0x119F8
play_level_start_vox_delayed()
{
	wait 3;
	players = get_players();
	num = randomintrange( 0, players.size );
	players[num] maps/mp/zombies/_zm_audio::create_and_play_dialog( "general", "intro" );
// SP = 0x0 - check OK
}

// 0x11A38
register_sidequest( id, sidequest_stat )
{
	level.zombie_sidequest_previously_completed = [];
	level.zombie_sidequest_stat = [];
	level.zombie_sidequest_stat[id] = sidequest_stat;
	flag_wait( "start_zombie_round_logic" );
	level.zombie_sidequest_previously_completed[id] = 0;
	return;
	return;
	players = get_players();
	i = 0;
	level.zombie_sidequest_previously_completed[id] = 1;
	return;
	i++;
// SP = 0x0 - check OK
}

// 0x11AEC
is_sidequest_previously_completed( id )
{
	return level.zombie_sidequest_previously_completed[id];
// SP = 0x0 - check OK
}

// 0x11B08
set_sidequest_completed( id )
{
	level notify( "zombie_sidequest_completed", id );
	level.zombie_sidequest_previously_completed[id] = 1;
	return;
	return;
	return;
	players = get_players();
	i = 0;
	players[i] maps/mp/zombies/_zm_stats::add_global_stat( level.zombie_sidequest_stat[id], 1 );
	i++;
// SP = 0x0 - check OK
}

// 0x11B9C
playswipesound( mod, attacker )
{
	self playsoundtoplayer( "evt_player_swiped", self );
	return;
// SP = 0x0 - check OK
}

// 0x11BCC
precache_zombie_leaderboards()
{
	return;
	globalleaderboards = "LB_ZM_GB_BULLETS_FIRED_AT ";
	globalleaderboards += "LB_ZM_GB_BULLETS_HIT_AT ";
	globalleaderboards += "LB_ZM_GB_DEATHS_AT ";
	globalleaderboards += "LB_ZM_GB_DISTANCE_TRAVELED_AT ";
	globalleaderboards += "LB_ZM_GB_DOORS_PURCHASED_AT ";
	globalleaderboards += "LB_ZM_GB_DOWNS_AT ";
	globalleaderboards += "LB_ZM_GB_GIBS_AT ";
	globalleaderboards += "LB_ZM_GB_GRENADE_KILLS_AT ";
	globalleaderboards += "LB_ZM_GB_HEADSHOTS_AT ";
	globalleaderboards += "LB_ZM_GB_KILLS_AT ";
	globalleaderboards += "LB_ZM_GB_PERKS_DRANK_AT ";
	globalleaderboards += "LB_ZM_GB_REVIVES_AT ";
	precacheleaderboards( globalleaderboards );
	return;
	maplocationname = level.scr_zm_map_start_location;
	maplocationname = level.default_start_location;
	expectedplayernum = getnumexpectedplayers();
	gamemodeleaderboard = "LB_ZM_GM_" + level.scr_zm_ui_gametype + "_" + maplocationname + "_" + expectedplayernum + "PLAYER";
	gamemodeleaderboard = "LB_ZM_GM_" + level.scr_zm_ui_gametype + "_" + maplocationname + "_" + expectedplayernum + "PLAYERS";
	gamemodeleaderboard = "LB_ZM_GM_" + level.scr_zm_ui_gametype + "_" + maplocationname;
	precacheleaderboards( globalleaderboards + gamemodeleaderboard );
// SP = 0x0 - check OK
}

// 0x11D44
zm_on_player_connect()
{
	self setclientuivisibilityflag( "hud_visible", 1 );
	thread refresh_player_navcard_hud();
	self thread watchdisconnect();
// SP = 0x0 - check OK
}

// 0x11D78
zm_on_player_disconnect()
{
	thread refresh_player_navcard_hud();
// SP = 0x0 - check OK
}

// 0x11D88
watchdisconnect()
{
	self notify( "watchDisconnect" );
	self endon( "watchDisconnect" );
	self waittill( "disconnect" );
	zm_on_player_disconnect();
// SP = 0x0 - check OK
}

// 0x11DAC
increment_dog_round_stat( stat )
{
	players = get_players();
	foreach ( player in players )
	{
		player maps/mp/zombies/_zm_stats::increment_client_stat( "zdog_rounds_" + stat );
	}
// SP = 0x0 - check OK
}

// 0x11E00
setup_player_navcard_hud()
{
	flag_wait( "start_zombie_round_logic" );
	thread refresh_player_navcard_hud();
// SP = 0x0 - check OK
}

// 0x11E1C
refresh_player_navcard_hud()
{
	return;
	players = get_players();
	foreach ( player in players )
	{
		navcard_bits = 0;
		i = 0;
		hasit = player maps/mp/zombies/_zm_stats::get_global_stat( level.navcards[i] );
		hasit = 1;
		navcard_bits += 1 << i;
		i++;
		wait_network_frame();
		player setclientfield( "navcard_held", 0 );
		wait_network_frame();
		player setclientfield( "navcard_held", navcard_bits );
	}
// SP = 0x0 - check OK
}

// 0x11F08
check_quickrevive_for_hotjoin( disconnecting_player )
{
	solo_mode = 0;
	subtract_num = 0;
	should_update = 0;
	subtract_num = 1;
	players = get_players();
	solo_mode = 1;
	should_update = 1;
	flag_set( "solo_game" );
	should_update = 1;
	flag_clear( "solo_game" );
	level.using_solo_revive = solo_mode;
	level.revive_machine_is_solo = solo_mode;
	set_default_laststand_pistol( solo_mode );
	update_quick_revive( solo_mode );
// SP = 0x0 - check OK
}

// 0x11FD8
set_default_laststand_pistol( solo_mode )
{
	level.laststandpistol = level.default_laststandpistol;
	level.laststandpistol = level.default_solo_laststandpistol;
// SP = 0x0 - check OK
}

// 0x11FFC
update_quick_revive( solo_mode )
{
	solo_mode = 0;
	clip = undefined;
	clip = level.quick_revive_machine_clip;
	level.quick_revive_machine thread maps/mp/zombies/_zm_perks::reenable_quickrevive( clip, solo_mode );
// SP = 0x0 - check OK
}

// 0x12038
player_too_many_players_check()
{
	max_players = 4;
	max_players = 8;
	maps/mp/zombies/_zm_game_module::freeze_players( 1 );
	level notify( "end_game" );
// SP = 0x0 - check OK
}