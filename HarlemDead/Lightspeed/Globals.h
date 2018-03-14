// Values used in positioning the layers
#define	kBackgroundLayerZValue 0
#define kGameplayLayerZValue 5
#define kStarParticleSystemLayerZValue 3

#define PLATFORMS_FILENAME_FORMAT @"platform%d.png"
#define PLATFORMS_NUMBER 2

#define SPACESHIP_FILENAME_FORMAT @"spaceship%d.png"
#define SPACESHIP_MOVES_NUMBER 4
#define SPACESHIP_DEFAULT @"spaceship0.png"

#define ENEMY_1_FILENAME_FORMAT @"enemyship1%d.png"
#define ENEMY_1_MOVES_NUMBER 4
#define ENEMY_1_DEFAULT @"enemyship11.png"

#define ENEMY_2_FILENAME_FORMAT @"enemyship2%d.png"
#define ENEMY_2_MOVES_NUMBER 4
#define ENEMY_2_DEFAULT @"enemyship21.png"

#define MENU_CHANGE_SOUND @"pushsound1.caf"
#define NOTIFICATION_START_SINGLEPLAYER @"startSinglePlayerGame"
#define NOTIFICATION_START_MULTIPLAYER @"startMultiPlayerGame"
#define NOTIFICATION_END_MULTIPLAYER @"endMultiPlayerGame"
#define NOTIFICATION_GOT_BLIND_ATTACK @"gotBlindAttackInGame"

#define tHIGHSCORE @"highscore1"

#define LEADERBOARD_ID @"theharlemdead_lb"

#define FONT_NAME @"Starjedi"

#define FONT_COLOR ccc3(11,76,133)

#define FS_HIGHSCORE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 50 : 30
#define FS_SCORETEXT (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 40 : 20
//#define FS_SCORETEXT 30
static const ccColor3B ccSkyBlue = {176,226,255};

BOOL playerAuthenticated;
BOOL playerAuthenticationAttempted;
BOOL gGameShouldEndAndRetun;
BOOL gGameSuspended;
BOOL gGameShouldRestart;
int gLastHighScore;
void reset_globals (void);