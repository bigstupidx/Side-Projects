// Values used in positioning the layers
#define mapWidthInPixel  3200 //Meng added
#define mapHeightInPixel 320  //Meng added
#define mapWallHeightInPixel 192  //Meng added
#define mapFloorHeightInPixel 128 //Meng added

#define tHIGHSCORE @"highscore1"

#define LEADERBOARD_ID @"ninja_adventure_highscore"

#define FS_HIGHSCORE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 50 : 30
#define FS_SCORETEXT (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 40 : 20


//Meng: health
#define HEALTH_POINTS_HERO_NINJA    100
#define HEALTH_POINTS_RED_NINJA     100
#define HEALTH_POINTS_YELLOW_NINJA  160
#define HEALTH_POINTS_BLUE_NINJA    180
#define HEALTH_POINTS_PURPLE_NINJA  300

//Meng: damage
#define DAMAGE_POINTS_HERO_NINJA    20
#define DAMAGE_POINTS_RED_NINJA     10
#define DAMAGE_POINTS_YELLOW_NINJA  20
#define DAMAGE_POINTS_BLUE_NINJA    20
#define DAMAGE_POINTS_PURPLE_NINJA  40

//Meng: walk speed
#define WALKSPEED_HERO_NINJA    70
#define WALKSPEED_RED_NINJA     80
#define WALKSPEED_YELLOW_NINJA  80
#define WALKSPEED_BLUE_NINJA    100
#define WALKSPEED_PURPLE_NINJA  40

//Meng: walk chance
#define WALKCHANCE_RED_NINJA     30
#define WALKCHANCE_YELLOW_NINJA  50
#define WALKCHANCE_BLUE_NINJA    70
#define WALKCHANCE_PURPLE_NINJA  90

//Meng: attack chance
#define ATTACKCHANCE_RED_NINJA     30
#define ATTACKCHANCE_YELLOW_NINJA  30
#define ATTACKCHANCE_BLUE_NINJA    70
#define ATTACKCHANCE_PURPLE_NINJA  50

//Meng: monster's points for score
#define MONSTER_POINTS_RED_NINJA    10
#define MONSTER_POINTS_YELLOW_NINJA 20
#define MONSTER_POINTS_BLUE_NINJA   50
#define MONSTER_POINTS_PURPLE_NINJA 100

//Meng: fruit drop chance
#define FRUIT_DROP_CHANCE_RED_NINJA     0
#define FRUIT_DROP_CHANCE_YELLOW_NINJA  10
#define FRUIT_DROP_CHANCE_BLUE_NINJA    30
#define FRUIT_DROP_CHANCE_PURPLE_NINJA  50


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

void reset_globals (void);