//
//  Constants.mm
//  iEngine
//
//  Created by Muhammed Safiul Azam on 9/17/09.
//  Copyright 2009 Home. All rights reserved.
//

#import "Constants.h"

NSInteger const WINDOW_LEFT = -240;
NSInteger const WINDOW_RIGHT = 240;
NSInteger const WINDOW_WIDTH = 480;

NSInteger const WINDOW_TOP = -160;
NSInteger const WINDOW_BOTTOM = 160;
NSInteger const WINDOW_HEIGHT = 320;

//NSInteger const AREA_WIDTH = 0;
//NSInteger const AREA_HEIGHT = 0;

NSInteger const BACKGROUND_TILE_WIDTH = 512;
NSInteger const BACKGROUND_TILE_HEIGHT = 320;

NSInteger const DOOR_WIDTH = 65;
NSInteger const DOOR_HEIGHT = 65;
NSInteger const DOOR_OFFSET = 128 - 56;
NSInteger const DOOR_PER_BACKGROUNDS = 3;

NSInteger const DOOR_WAIT_TIME = 2000;

NSInteger const STREET_TOP = 27;

NSString *const FRAME_ANIMATION_NONE = @"None";
NSString *const FRAME_ANIMATION_IDLE = @"Idle";
NSString *const FRAME_ANIMATION_WALK = @"Walk";
NSString *const FRAME_ANIMATION_FIRE = @"Fire";
NSString *const FRAME_ANIMATION_HIT = @"Hit";

NSInteger const PLAYER_WALK_SPEED = 6;

//NSInteger const ZOMBIE_MAXIMUM_COUNT = 5;
NSInteger const ZOMBIE_CREATION_TIME_MINIMUM = 500;
NSInteger const ZOMBIE_CREATION_TIME_MAXIMUM = 1500;

NSInteger const ZOMBIE_HURT_TIME = 1000;
NSInteger const ZOMBIE_HIT_TIME = 500;
NSInteger const ZOMBIE_HURT_SPEED = 0;
NSInteger const ZOMBIE_WALK_SPEED_MINIMUM = 1;
NSInteger const ZOMBIE_WALK_SPEED_MAXIMUM = 5;
NSInteger const ZOMBIE_SUPERWALK_SPEED_MINIMUM = 2;
NSInteger const ZOMBIE_SUPERWALK_SPEED_MAXIMUM = 9;
NSInteger const ZOMBIE_HIT_DISTANCE_SPEED = 20;

NSInteger const BUTTON_WIDTH = 60;
NSInteger const BUTTON_HEIGHT = 60;
NSInteger const BUTTON_OFFSET = 10;

NSInteger const ICON_WIDTH = 50;
NSInteger const ICON_HEIGHT = 50;
NSInteger const ICON_OFFSET = 10;

NSInteger const MESSAGE_TIME = 2000;

NSInteger const COIN_TIME = 6000;

NSString *const PLAYER_DEAD_MESSAGE = @"OOPS! YOU ARE DEAD!";
NSString *const PLAYER_EXIT_MESSAGE = @"YES! YOU DID IT!";
NSString *const GAME_COMPLETE_MESSAGE = @"GAME COMPLETE!";
NSString *const NOT_ENOUGH_CURRENCY_MESSAGE = @"You should buy it! Any purchase can remove ads!";
NSString *const ARE_YOU_SURE_MESSAGE = @"Change weapon, are you sure?";

NSString *const KEY_PLAYER_NAME = @"KEY_PLAYER_NAME";
NSString *const KEY_PLAYER_AVATAR = @"KEY_PLAYER_AVATAR";
NSString *const KEY_PLAYER_HIT = @"KEY_PLAYER_HIT";
NSString *const KEY_PLAYER_FIRE = @"KEY_PLAYER_FIRE";
NSString *const KEY_PLAYER_MONEY = @"KEY_PLAYER_MONEY";
NSString *const KEY_PLAYER_LEVEL = @"KEY_PLAYER_LEVEL";
NSString *const KEY_PLAYER_SCORE = @"KEY_PLAYER_SCORE";

NSInteger const MARKET_ROW_HEIGHT = 110;

NSString *const INTERNET_UNAVAILABLE = @"Internet is unavailable.";

NSString *const AMFPHP_GATEWAY = @"http://localhost:8888/goftware_iphone_backend/amfphp_1.9/gateway.php";

NSString *const KEY_LOGO_TIME = @"KEY_LOGO_TIME";

NSString *const KEY_LOAD_TIME = @"KEY_LOAD_TIME";

NSString *const KEY_TITLE_TIME = @"KEY_TITLE_TIME";

NSString *const KEY_ANIMATION_TIME_LONG = @"KEY_ANIMATION_TIME_LONG";

NSString *const KEY_ANIMATION_TIME_MEDIUM = @"KEY_ANIMATION_TIME_MEDIUM";

NSString *const KEY_ANIMATION_TIME_SHORT = @"KEY_ANIMATION_TIME_SHORT";

NSString *const ADMOB_PUBLISHER_ID = @"a14df04f1ca2bda";

NSString *const KEY_RESUME = @"KEY_RESUME";

NSString *const KEY_AVATARS = @"KEY_AVATARS";
NSString *const KEY_FIRES = @"KEY_FIRES";
NSString *const KEY_HITS = @"KEY_HITS";

NSString *const KEY_SOUND = @"KEY_SOUND";

NSString *const SOUND_CLICK = @"Sound_Click.wav";
NSString *const SOUND_COIN = @"Sound_Coin.wav";
NSString *const SOUND_HURT = @"Sound_Hurt.wav";
NSString *const SOUND_DEATH = @"Sound_Death.wav";
NSString *const SOUND_EMPTY = @"Sound_Empty.wav";
NSString *const SOUND_PISTOL = @"Sound_Pistol.wav";
NSString *const SOUND_SHOTGUN = @"Sound_Shotgun.wav";
NSString *const SOUND_BASEBALL_BAT = @"Sound_Baseball_Bat.wav";
NSString *const SOUND_SWORD = @"Sound_Sword.wav";
NSString *const SOUND_WALK = @"Sound_Walk.wav";
NSString *const SOUND_RELOAD = @"Sound_Reload.wav";
NSString *const SOUND_SCREAM_01 = @"Sound_Scream_01.wav";
NSString *const SOUND_SCREAM_02 = @"Sound_Scream_02.wav";
NSString *const SOUND_SCREAM_03 = @"Sound_Scream_03.wav";
NSString *const SOUND_SCREAM_04 = @"Sound_Scream_04.wav";
NSString *const SOUND_SCREAM_05 = @"Sound_Scream_05.wav";
NSString *const SOUND_SCREAM_06 = @"Sound_Scream_06.wav";
NSString *const SOUND_SCREAM_07 = @"Sound_Scream_07.wav";
NSString *const SOUND_SCREAM_08 = @"Sound_Scream_08.wav";
NSString *const SOUND_SCREAM_09 = @"Sound_Scream_09.wav";
NSString *const SOUND_SCREAM_10 = @"Sound_Scream_10.wav";

NSInteger const QUIT_TAG = 1000;
NSInteger const RESUME_TAG = 2000;

NSString *const TEST_FLIGHT_TEAM_TOKEN = @"b0e72a419a79b226a3d685df1632590b_NTE5MDcyMDEyLTAxLTA5IDAyOjE1OjQxLjk5OTE4NA";