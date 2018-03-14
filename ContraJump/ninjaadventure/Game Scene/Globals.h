// Values used in positioning the layers
#define mapWidthInPixel  320 //Meng added
#define mapHeightInPixel 3200  //Meng added
#define mapWallHeightInPixel 192  //Meng added
#define mapFloorHeightInPixel 128 //Meng added

#define tileWidthMinIndex  0   //Meng added
#define tileWidthMaxIndex  19  //Meng added
#define tileHeightMinIndex 0   //Meng added
#define tileHeightMaxIndex 199 //Meng added

#define tileType_walls      1 //Meng added
#define tileType_floors     2 //Meng added
#define tileType_jumps      3 //Meng added
#define tileType_hazards    4 //Meng added


#define tHIGHSCORE @"highscore1"

#define LEADERBOARD_ID @"ninja_adventure_highscore"

#define FS_HIGHSCORE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 50 : 30
#define FS_SCORETEXT (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 40 : 20

#define kFPS 60 //Meng added

#define HERO_VIEWPOINT_PROPORTION 1/5 


#define  ACCELERATION_BALANCE 0.02

//Meng: weapon
#define WEAPON_SHOOT_COOLDOWNTIME_SHOTGUN 300 //miliseconds
#define BULLET_SPEED 500 //miliseconds

//Meng: health
#define HEALTH_POINTS_HERO_NINJA    100
#define HEALTH_POINTS_RED_NINJA     100

//Meng: damage
#define DAMAGE_POINTS_HERO_NINJA    20
#define DAMAGE_POINTS_RED_NINJA     10

//Meng: walk speed
#define WALKSPEED_HERO_NINJA    120
#define WALKSPEED_RED_NINJA     80
#define SHOOT_DIRECTION_0_DEGREE  1 
#define SHOOT_DIRECTION_45_DEGREE 2
#define SHOOT_DIRECTION_90_DEGREE 3

//Meng: jump speed
#define JUMP_FORCE_HERO     360.0
#define GRAVITY_FORCE_HERO  -450.0
#define JUMP_SPEED_LIMIT    360

//Meng: walk chance
#define WALKCHANCE_RED_NINJA     30

//Meng: attack chance
#define ATTACKCHANCE_RED_NINJA     30

//Meng: monster's points for score
#define MONSTER_POINTS_RED_NINJA    10

//Meng: fruit drop chance
#define FRUIT_DROP_CHANCE_RED_NINJA     0



BOOL gGameSuspended;
BOOL gGameShouldRestart;

BOOL gGamesMusicStatus; //Meng added. This variable indicates if we want to turn on background music.
BOOL gGamesEffectStatus;  //Meng added. This variable indicates if we want to turn off music effects.

unsigned int gNinjaHitPoints_Last;    //Meng added. This variable indicates last ninja hit points.
unsigned int gNinjaHitPoints_Current; //Meng added. This variable indicates current ninja hit points.

unsigned int roundOfBackground_Current; //Meng added. This variable indicates the number of current background images player is in.

long int gGameScore; //Meng added. This variable indicates how much scores does player get.
long int gGameScore_Last; //Meng added. This variable indicates how much scores does player get.

UIWindow *mainWindow;//Meng added. This variable is used for getting the main window

BOOL gGamesMusicStatus;//Meng added
BOOL gGamesEffectStatus;//Meng added

float acceleration_x; //Meng added. This variable is used for recored the acceleration x value.
float acceleration_y; //Meng added. This variable is used for recored the acceleration y value.

void reset_globals (void);