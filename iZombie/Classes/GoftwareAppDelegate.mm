//
//  GoftwareAppDelegate.m
//  Goftware
//
//  Created by Muhammed Safiul Azam on 10/9/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "GoftwareAppDelegate.h"
#import "MathUtility.h"
#import "LogUtility.h"
#import "Preferences.h"
#import "Flurry.h"
#import "Chartboost.h"
#import "GameKitHelper.h"
#import "Mobclix.h"
#import "InAppPurchaseManager.h"
#import "Globals.h"

@implementation GoftwareAppDelegate

#define TAPJOY_APP_ID @"a809576c-9cfc-4331-af56-b217429d5975"
#define TAPJOY_SECRET_KEY @"XeTHOvzeEX6XGjzzJwnC"

@synthesize window;
@synthesize pushManager;



#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
	// Override point for customization after application launch
	[window makeKeyAndVisible];
	
	[application setStatusBarHidden:YES];

    [Flurry startSession:@"DB36LRY6FE9LZDSRYPH8"];
	[RevMobAds startSessionWithAppID:@"4fc697174865db008f00001e"];
    [[GameKitHelper sharedGameKitHelper] authenticateLocalPlayer];
 
    

    [[InAppPurchaseManager sharedInAppManager] loadStore_Axe];
    [[InAppPurchaseManager sharedInAppManager] loadStore_Hammer];
    [[InAppPurchaseManager sharedInAppManager] loadStore_Chainsaw];
    [[InAppPurchaseManager sharedInAppManager] loadStore_Machinegun];
    [[InAppPurchaseManager sharedInAppManager] loadStore_Laser];
    [[InAppPurchaseManager sharedInAppManager] loadStore_AllWeapon];
    
    //TapJoy
    [TapjoyConnect requestTapjoyConnect:TAPJOY_APP_ID secretKey:TAPJOY_SECRET_KEY];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tjcConnectSuccess:) name:TJC_CONNECT_SUCCESS object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tjcConnectFail:) name:TJC_CONNECT_FAILED object:nil];
    
    [TapjoyConnect setTransitionEffect:TJCTransitionExpand];
	[TapjoyConnect setUserdefinedColorWithIntValue:0x808080];
    
    //Pushwoosh
    
    pushManager = [[PushNotificationManager alloc] initWithApplicationCode:@"2B5B6-C3F08" appName:@"Zombie Kid" ];
    pushManager.delegate = self;
    
    [pushManager handlePushReceived:launchOptions];
    
    [[Preferences getInstance] setValue:[NSNumber numberWithFloat:2.0] :KEY_LOGO_TIME];
    [[Preferences getInstance] setValue:[NSNumber numberWithFloat:1.0] :KEY_LOAD_TIME];
    
	[[Preferences getInstance] setValue:[NSNumber numberWithFloat:1.5] :KEY_ANIMATION_TIME_LONG];
	[[Preferences getInstance] setValue:[NSNumber numberWithFloat:0.5] :KEY_ANIMATION_TIME_MEDIUM];
	[[Preferences getInstance] setValue:[NSNumber numberWithFloat:0.1] :KEY_ANIMATION_TIME_SHORT];
	
	_pageMainViewController = [[PageMainViewController alloc] initWithNibName:@"Page_Main" bundle:[NSBundle mainBundle]];
	[window addSubview:_pageMainViewController.view];
	[_pageMainViewController.view release];	
	
	[_pageMainViewController gotoPage:PageLogo];
    
    [self onInitialize];
    	
	return YES;
}

-(void) onInitialize
{
    // Avatars.
    if([[Preferences getInstance] getValue:KEY_AVATARS] == nil)
    {
        Avatar *avatarCowboy = [[Avatar alloc] init];
        [avatarCowboy setName:@"Cowboy"];
        [avatarCowboy setThumbFilename:@"Avatar_Cowboy.png"];
        [avatarCowboy setImageFilename:@"Avatar_Cowboy"];
        [avatarCowboy setPrice:0];
        
        /*
        Avatar *avatarGirl = [[Avatar alloc] init];
        [avatarGirl setName:@"Girl"];
        [avatarGirl setThumbFilename:@"Avatar_Girl.png"];
        [avatarGirl setImageFilename:@"Avatar_Girl"];
        [avatarGirl setPrice:0];
        */
         
        NSMutableArray *avatars = [[NSMutableArray alloc] init];
        [avatars addObject:avatarCowboy];
        //[avatars addObject:avatarGirl];
        
        [[Preferences getInstance] setValue:avatars :KEY_AVATARS];
    }
    
    // Hits.
    if([[Preferences getInstance] getValue:KEY_HITS] == nil)
    {
        Hit *hitBaseballBat = [[Hit alloc] init];
        [hitBaseballBat setType:WeaponTypeBaseballBat];
        [hitBaseballBat setName:@"Baseball Bat"];
        [hitBaseballBat setThumbFilename:@"Hit_Baseball_Bat.png"];
        [hitBaseballBat setImageFilename:@"Hit_Baseball_Bat"];
        [hitBaseballBat setActionFirstIndex:11];
        [hitBaseballBat setActionCountFrames:4];
        [hitBaseballBat setPrice:0];
        [hitBaseballBat setPower:10];
    
        Hit *hitSword = [[Hit alloc] init];
        [hitSword setType:WeaponTypeSword];
        [hitSword setName:@"Sword"];
        [hitSword setThumbFilename:@"Hit_Sword.png"];
        [hitSword setImageFilename:@"Hit_Sword"];
        [hitSword setActionFirstIndex:19];
        [hitSword setActionCountFrames:6];
        [hitSword setPrice:0];
        [hitSword setPower:20];
        
        Hit *hitHammer = [[Hit alloc] init];
        [hitHammer setType:WeaponTypeSword];
        [hitHammer setName:@"Hammer"];
        [hitHammer setThumbFilename:@"Hit_Hammer.png"];
        [hitHammer setImageFilename:@"Hit_Hammer"];
        [hitHammer setActionFirstIndex:37];
        [hitHammer setActionCountFrames:4];
        [hitHammer setPrice:0];
        [hitHammer setPower:30];
        
        Hit *hitAxe = [[Hit alloc] init];
        [hitAxe setType:WeaponTypeSword];
        [hitAxe setName:@"Axe"];
        [hitAxe setThumbFilename:@"Hit_Axe.png"];
        [hitAxe setImageFilename:@"Hit_Axe"];
        [hitAxe setActionFirstIndex:41];
        [hitAxe setActionCountFrames:4];
        [hitAxe setPrice:0];
        [hitAxe setPower:40];
        
        Hit *hitChainsaw = [[Hit alloc] init];
        [hitChainsaw setType:WeaponTypeSword];
        [hitChainsaw setName:@"Chainsaw"];
        [hitChainsaw setThumbFilename:@"Hit_Chainsaw.png"];
        [hitChainsaw setImageFilename:@"Hit_Chainsaw"];
        [hitChainsaw setActionFirstIndex:54];
        [hitChainsaw setActionCountFrames:2];
        [hitChainsaw setPrice:0];
        [hitChainsaw setPower:60];
        
        
        NSMutableArray *hits = [[NSMutableArray alloc] init];
        [hits addObject:hitBaseballBat];
        [hits addObject:hitSword];
        [hits addObject:hitHammer];
        [hits addObject:hitAxe];
        [hits addObject:hitChainsaw];
        
        [[Preferences getInstance] setValue:hits :KEY_HITS];
    }
    
    // Fires.
    if([[Preferences getInstance] getValue:KEY_FIRES] == nil)
    {
        Fire *firePistol = [[Fire alloc] init];
        [firePistol setType:WeaponTypePistol];
        [firePistol setName:@"Pistol"];
        [firePistol setThumbFilename:@"Fire_Pistol.png"];
        [firePistol setFlameFilename:@"Flame_Pistol"];
        [firePistol setWalkFirstIndex:25];
        [firePistol setWalkCountFrames:6];
        [firePistol setIdleFirstIndex:28];
        [firePistol setIdleCountFrames:1];
        [firePistol setActionFirstIndex:7];
        [firePistol setActionCountFrames:4];
        [firePistol setPrice:0];
        [firePistol setMaximumAmmo:100];
        [firePistol setPower:25];
    
        Fire *fireShotgun = [[Fire alloc] init];
        [fireShotgun setType:WeaponTypeShotgun];
        [fireShotgun setName:@"Shotgun"];
        [fireShotgun setThumbFilename:@"Fire_Shotgun.png"];
        [fireShotgun setFlameFilename:@"Flame_Shotgun"];
        [fireShotgun setWalkFirstIndex:68];
        [fireShotgun setWalkCountFrames:6];
        [fireShotgun setIdleFirstIndex:68];
        [fireShotgun setIdleCountFrames:1];
        [fireShotgun setActionFirstIndex:64];
        [fireShotgun setActionCountFrames:4];
        [fireShotgun setPrice:0];
        [fireShotgun setMaximumAmmo:75];
        [fireShotgun setPower:35];
        
        Fire *fireMachinegun= [[Fire alloc] init];
        [fireMachinegun setType:WeaponTypeShotgun];
        [fireMachinegun setName:@"Machinegun"];
        [fireMachinegun setThumbFilename:@"Fire_Machinegun.png"];
        [fireMachinegun setFlameFilename:@"Flame_Machinegun"];
        [fireMachinegun setWalkFirstIndex:31];
        [fireMachinegun setWalkCountFrames:6];
        [fireMachinegun setIdleFirstIndex:61];
        [fireMachinegun setIdleCountFrames:3];
        [fireMachinegun setActionFirstIndex:15];
        [fireMachinegun setActionCountFrames:3];
        [fireMachinegun setPrice:0];
        [fireMachinegun setMaximumAmmo:150];
        [fireMachinegun setPower:55];
        
        Fire *fireLasergun= [[Fire alloc] init];
        [fireLasergun setType:WeaponTypeShotgun];
        [fireLasergun setName:@"Lasergun"];
        [fireLasergun setThumbFilename:@"Fire_Lasergun.png"];
        [fireLasergun setFlameFilename:@"Flame_Lasergun"];
        [fireLasergun setWalkFirstIndex:48];
        [fireLasergun setWalkCountFrames:6];
        [fireLasergun setIdleFirstIndex:45];
        [fireLasergun setIdleCountFrames:3];
        [fireLasergun setActionFirstIndex:58];
        [fireLasergun setActionCountFrames:3];
        [fireLasergun setPrice:0];
        [fireLasergun setMaximumAmmo:100];
        [fireLasergun setPower:110];
        
        
        NSMutableArray *fires = [[NSMutableArray alloc] init];
        [fires addObject:firePistol];
        [fires addObject:fireShotgun];
        [fires addObject:fireMachinegun];
        [fires addObject:fireLasergun];
        
        [[Preferences getInstance] setValue:fires :KEY_FIRES];
    }
    
    NSMutableArray *zombies = [NSMutableArray arrayWithObjects: 
                               @"Zombie_Gentleman", 
                               @"Zombie_Lady", 
                               //@"Zombie_Elf_Boy",
                               //@"Zombie_Elf_Girl",
                               @"Zombie_Skull",
                               @"Zombie_Kid_Boy",
                               @"Zombie_Kid_Girl",
                               @"Zombie_Grandma",
                               nil];
    
    // Levels.
    Level *level = [[Level alloc] init];
    [level setName:@"Night Street"];
    [level setTMXFilename:@"Night_Street"];
    [level setZombieFilenames:zombies];
    [level setMaximumCountZombies:3];
    [level setDoorCenter:CGPointMake(136, -DOOR_OFFSET)];
    
    level = [[Level alloc] init];
    [level setName:@"Graveyard"];
    [level setTMXFilename:@"Graveyard"];
    [level setZombieFilenames:zombies];
    [level setMaximumCountZombies:3];
    [level setDoorCenter:CGPointMake(130, -DOOR_OFFSET)];
    
    level = [[Level alloc] init];
    [level setName:@"Sunny Day"];
    [level setTMXFilename:@"Sunny_Day"];
    [level setZombieFilenames:zombies];
    [level setMaximumCountZombies:4];
    [level setDoorCenter:CGPointMake(136, -DOOR_OFFSET)];
    
    level = [[Level alloc] init];
    [level setName:@"Jungle"];
    [level setTMXFilename:@"Jungle"];
    [level setZombieFilenames:zombies];
    [level setMaximumCountZombies:4];
    [level setDoorCenter:CGPointMake(134, -DOOR_OFFSET)];
    
    level = [[Level alloc] init];
    [level setName:@"City Night"];
    [level setTMXFilename:@"City_Night"];
    [level setZombieFilenames:zombies];
    [level setMaximumCountZombies:5];
    [level setDoorCenter:CGPointMake(115, -DOOR_OFFSET)];
    
    level = [[Level alloc] init];
    [level setName:@"Town Hall"];
    [level setTMXFilename:@"Town_Hall"];
    [level setZombieFilenames:zombies];
    [level setMaximumCountZombies:5];
    [level setDoorCenter:CGPointMake(115, -DOOR_OFFSET)];
    
    level = [[Level alloc] init];
    [level setName:@"Christmas"];
    [level setTMXFilename:@"Christmas"];
    [level setZombieFilenames:zombies];
    [level setMaximumCountZombies:7];
    [level setDoorCenter:CGPointMake(142, -DOOR_OFFSET)];
    
    level = [[Level alloc] init];
    [level setName:@"Graveyard Night"];
    [level setTMXFilename:@"Graveyard_Night"];
    [level setZombieFilenames:zombies];
    [level setMaximumCountZombies:7];
    [level setDoorCenter:CGPointMake(128, -DOOR_OFFSET)];
    
    level = [[Level alloc] init];
    [level setName:@"Village"];
    [level setTMXFilename:@"Village"];
    [level setZombieFilenames:zombies];
    [level setMaximumCountZombies:9];
    [level setDoorCenter:CGPointMake(128, -DOOR_OFFSET)];
    
    // Iteration.
    level = [[Level alloc] init];
    [level setName:@"Night Street"];
    [level setTMXFilename:@"Night_Street"];
    [level setZombieFilenames:zombies];
    [level setMaximumCountZombies:9];
    [level setDoorCenter:CGPointMake(136, -DOOR_OFFSET)];
    
    level = [[Level alloc] init];
    [level setName:@"Graveyard"];
    [level setTMXFilename:@"Graveyard"];
    [level setZombieFilenames:zombies];
    [level setMaximumCountZombies:9];
    [level setDoorCenter:CGPointMake(130, -DOOR_OFFSET)];
    
    level = [[Level alloc] init];
    [level setName:@"Sunny Day"];
    [level setTMXFilename:@"Sunny_Day"];
    [level setZombieFilenames:zombies];
    [level setMaximumCountZombies:11];
    [level setDoorCenter:CGPointMake(136, -DOOR_OFFSET)];
    
    level = [[Level alloc] init];
    [level setName:@"Jungle"];
    [level setTMXFilename:@"Jungle"];
    [level setZombieFilenames:zombies];
    [level setMaximumCountZombies:11];
    [level setDoorCenter:CGPointMake(134, -DOOR_OFFSET)];
    
    level = [[Level alloc] init];
    [level setName:@"City Night"];
    [level setTMXFilename:@"City_Night"];
    [level setZombieFilenames:zombies];
    [level setMaximumCountZombies:12];
    [level setDoorCenter:CGPointMake(115, -DOOR_OFFSET)];
    
    level = [[Level alloc] init];
    [level setName:@"Town Hall"];
    [level setTMXFilename:@"Town_Hall"];
    [level setZombieFilenames:zombies];
    [level setMaximumCountZombies:12];
    [level setDoorCenter:CGPointMake(130, -DOOR_OFFSET)];
    
    level = [[Level alloc] init];
    [level setName:@"Christmas"];
    [level setTMXFilename:@"Christmas"];
    [level setZombieFilenames:zombies];
    [level setMaximumCountZombies:13];
    [level setDoorCenter:CGPointMake(142, -DOOR_OFFSET)];
    
    level = [[Level alloc] init];
    [level setName:@"Graveyard Night"];
    [level setTMXFilename:@"Graveyard_Night"];
    [level setZombieFilenames:zombies];
    [level setMaximumCountZombies:13];
    [level setDoorCenter:CGPointMake(128, -DOOR_OFFSET)];
    
    level = [[Level alloc] init];
    [level setName:@"Village"];
    [level setTMXFilename:@"Village"];
    [level setZombieFilenames:zombies];
    [level setMaximumCountZombies:15];
    [level setDoorCenter:CGPointMake(130, -DOOR_OFFSET)];

    if([[Preferences getInstance] getValue:KEY_PLAYER_AVATAR] == nil)
        [[Preferences getInstance] setValue:[NSNumber numberWithInteger:0] :KEY_PLAYER_AVATAR];
    
    if([[Preferences getInstance] getValue:KEY_PLAYER_HIT] == nil)
        [[Preferences getInstance] setValue:[NSNumber numberWithInteger:0] :KEY_PLAYER_HIT];
    
    if([[Preferences getInstance] getValue:KEY_PLAYER_FIRE] == nil)
        [[Preferences getInstance] setValue:[NSNumber numberWithInteger:0] :KEY_PLAYER_FIRE];
    
    if([[Preferences getInstance] getValue:KEY_PLAYER_MONEY] == nil)
        [[Preferences getInstance] setValue:[NSNumber numberWithInteger:0] :KEY_PLAYER_MONEY];
    
    if([[Preferences getInstance] getValue:KEY_PLAYER_LEVEL] == nil)
        [[Preferences getInstance] setValue:[NSNumber numberWithInteger:0] :KEY_PLAYER_LEVEL];
    
    if([[Preferences getInstance] getValue:KEY_PLAYER_SCORE] == nil)
        [[Preferences getInstance] setValue:[NSNumber numberWithInteger:0] :KEY_PLAYER_SCORE];
    
    [[SoundManager getInstance] loadSound:SOUND_CLICK];
    [[SoundManager getInstance] loadSound:SOUND_COIN];
    [[SoundManager getInstance] loadSound:SOUND_HURT];
    [[SoundManager getInstance] loadSound:SOUND_DEATH];
    [[SoundManager getInstance] loadSound:SOUND_EMPTY];
    [[SoundManager getInstance] loadSound:SOUND_PISTOL];
    [[SoundManager getInstance] loadSound:SOUND_SHOTGUN];
    [[SoundManager getInstance] loadSound:SOUND_BASEBALL_BAT];
    [[SoundManager getInstance] loadSound:SOUND_SWORD];
    [[SoundManager getInstance] loadSound:SOUND_WALK];
    [[SoundManager getInstance] loadSound:SOUND_RELOAD];
    [[SoundManager getInstance] loadSound:SOUND_SCREAM_01];
    [[SoundManager getInstance] loadSound:SOUND_SCREAM_02];
    [[SoundManager getInstance] loadSound:SOUND_SCREAM_03];
    [[SoundManager getInstance] loadSound:SOUND_SCREAM_04];
    [[SoundManager getInstance] loadSound:SOUND_SCREAM_05];
    [[SoundManager getInstance] loadSound:SOUND_SCREAM_06];
    [[SoundManager getInstance] loadSound:SOUND_SCREAM_07];
    [[SoundManager getInstance] loadSound:SOUND_SCREAM_08];
    [[SoundManager getInstance] loadSound:SOUND_SCREAM_09];
    [[SoundManager getInstance] loadSound:SOUND_SCREAM_10];
}

-(void)tjcConnectSuccess:(NSNotification*)notifyObj
{
	NSLog(@"Tapjoy connect Succeeded");
}


-(void)tjcConnectFail:(NSNotification*)notifyObj
{
	NSLog(@"Tapjoy connect Failed");
}


-(void) handlePushReceived:(NSDictionary *)userInfo{
    [pushManager handlePushReceived:userInfo];
}

-(void) handlePushRegistration:(NSData *)deviceToken{
    [pushManager handlePushRegistration:deviceToken];
}




- (PageMainViewController *) getPageMainViewController
{
	return _pageMainViewController;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
    
    if([_pageMainViewController getCurrentPage] == PagePlay)
    {
        PagePlayViewController *playViewController = (PagePlayViewController *) [_pageMainViewController getCurrentPageViewController];
        [playViewController pause];
    }
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */

}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
    
    bool axePurchased = [[[NSUserDefaults standardUserDefaults] valueForKey:@"axe purchase"] boolValue];
    bool hammerPurchased = [[[NSUserDefaults standardUserDefaults] valueForKey:@"hammer purchase"] boolValue];
    bool chainsawPurchased = [[[NSUserDefaults standardUserDefaults] valueForKey:@"chainsaw purchase"] boolValue];
    bool machineGunPurchased = [[[NSUserDefaults standardUserDefaults] valueForKey:@"machinegun purchase"] boolValue];
    bool laserGunPurchased = [[[NSUserDefaults standardUserDefaults] valueForKey:@"laser purchase"] boolValue];
    bool everythingPurchased = [[[NSUserDefaults standardUserDefaults] valueForKey:@"everything purchase"] boolValue];
    bool inPurchasepage = [[[NSUserDefaults standardUserDefaults] valueForKey:@"we are in purchase page"] boolValue]; //Meng: we don't want to show ads in purchase page, or it will be too many ads pop up and make people crazy.
    
    if (axePurchased||hammerPurchased||chainsawPurchased||machineGunPurchased||laserGunPurchased||everythingPurchased||inPurchasepage)
    {
        //Meng: if player buys any weapon, then remove ads.
    }
    else
    {
        
        [RevMobAds showPopupWithDelegate:nil];
        
        Chartboost *cb=[Chartboost sharedChartboost];
        cb.appId=@"4fc17872f876599d69000000";
        cb.appSignature=@"9ea11b831b6eedb3b62445329a36bf21c53006aa";
        
        [cb startSession];
        [cb showInterstitial];
    }

    
    if([_pageMainViewController getCurrentPage] == PagePlay)
    {
        PagePlayViewController *playViewController = (PagePlayViewController *) [_pageMainViewController getCurrentPageViewController];
        [playViewController resume];
    }
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
    [Avatar save];
    [Hit save];
    [Fire save];
    
    if([_pageMainViewController getCurrentPage] == PagePlay)
    {
        [[Preferences getInstance] setValue:[NSNumber numberWithInt:1] :KEY_RESUME];
    }
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
    
    [[LogUtility getInstance] printMessage:@"applicationDidReceiveMemoryWarning"];
}

- (void)dealloc {
    
	[window release];   
    
    [[LogUtility getInstance] printMessage:@"AppDelegate - dealloc"];
    
	[super dealloc];
}




@end
