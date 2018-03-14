
#import "AppDelegate.h"

#import "Globals.h"

#import "CCFileUtils.h"

#import "SimpleAudioEngine.h"

#import "Mobclix.h"

#import "AdsManager.h"
#import "GameplayLayer.h"
#import "PauseScene.h"
#import "MainMenuLayer.h"
#import "InAppPurchaseManager.h"
#import "Flurry.h"
#import "Reachability.h"

#define ITUNES_URL @"https://itunes.apple.com/us/app/harlem-dead-bike-race-through/id626893977";

@implementation AppDelegate

@synthesize window, mainView;


//- (void) applicationDidFinishLaunching:(UIApplication*)application
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    
    
	window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	if( ! [CCDirector setDirectorType:kCCDirectorTypeDisplayLink] )
		[CCDirector setDirectorType:kCCDirectorTypeNSTimer];
	CCDirector *__director = [CCDirector sharedDirector];
	[__director setDeviceOrientation:kCCDeviceOrientationPortrait];
	[__director setAnimationInterval:1.0/60];
	EAGLView *__glView = [EAGLView viewWithFrame:[window bounds]
                                     pixelFormat:kEAGLColorFormatRGB565
                                     depthFormat:0 /* GL_DEPTH_COMPONENT24_OES */
                              preserveBackbuffer:NO
                                      sharegroup:nil
                                   multiSampling:NO
                                 numberOfSamples:0
                          ];
	[__director setOpenGLView:__glView];
	[window addSubview:__glView];															
	[window makeKeyAndVisible];
	
	// Obtain the shared director in order to...
	CCDirector *director = [CCDirector sharedDirector];
	
    [Flurry startSession:@"89HPVPRS3K8VNPFHDTP2"];
    [Flurry logEvent:@"ApplicationLaunched" timed:YES];
    
	// Sets landscape mode
	[director setDeviceOrientation:kCCDeviceOrientationPortrait];
	
    //app default settings
	[window makeKeyAndVisible];
    
    //enables high res mode on iPhone 4 and maintains low resolution for everything else
    //if (! [director enableRetinaDisplay:YES])
    //    CCLOG(@"Retina Display Not Supported");
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        
        [director enableRetinaDisplay:YES];
    }
    
	// Default texture format for PNG/BMP/TIFF/JPEG/GIF images
	// It can be RGBA8888, RGBA4444, RGB5_A1, RGB565
	// You can change anytime.
	[CCTexture2D setDefaultAlphaPixelFormat:kTexture2DPixelFormat_RGBA8888];	
		
    // Register for push (Your provision profile should support it)  
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert];

    [[InAppPurchaseManager sharedInAppManager] loadStore];
    
    //load PLIST VALUES...SHOULD UNCOMMENT IF WE WANT TO WORK
    [[AdsManager sharedAdsManager] loadPLISTValues];
    
    [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"newbgmusic.mp3" loop:YES];
    
    [[CCDirector sharedDirector] runWithScene:[MainMenuLayer scene]];
    
    [self checkForLatestVersion];
    
    [[AdsManager sharedAdsManager] showAdOnLoad];
    return TRUE;
}


- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    if ([challenge previousFailureCount] == 0)
    {
        NSURLCredential *newCredential;
        newCredential=[NSURLCredential credentialWithUser:USERNAME
                                                 password:PASSWORD
                                              persistence:NSURLCredentialPersistenceForSession];
        [[challenge sender] useCredential:newCredential forAuthenticationChallenge:challenge];
    }
    else
    {
        NSLog(@"Authentication failure");
    }
}

- (void) checkForLatestVersion
{    
    if ([[AdsManager sharedAdsManager] needsUpdating])
    {
        //Show popup for new version available.
        
        UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Hey!" 
                                                         message:@"A new version of The Harlem Dead is available. Download Now?"
                                                        delegate:self 
                                               cancelButtonTitle:@"Cancel" 
                                               otherButtonTitles:@"OK", nil] autorelease];
        
        alert.tag = 10;
        [alert show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    // the user clicked one of the OK/Cancel buttons
    
    if(alertView.tag == 10)
    {
        if (buttonIndex == 1)
        {
            [self gotoAppStore];
        }
    }
}

/*- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url 
  sourceApplication:(NSString *)sourceApplication 
         annotation:(id)annotation  
{
    
    return NO;
}*/

- (void) gotoAppStore
{
    NSString *str = ITUNES_URL;
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}


// Once we register to remote notification we should notify Nextpeer about the device token
-(void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    //[pushManager handlePushRegistration:deviceToken];
    [[AdsManager sharedAdsManager] handlePushRegistration: deviceToken];

}

// Remote notification alert handling
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [[AdsManager sharedAdsManager] handlePushReceived:userInfo];
}

// Local notification alert handling
-(void)application:(UIApplication*)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    application.applicationIconBadgeNumber = 0;
}


- (void)applicationWillResignActive:(UIApplication *)application {
	[[CCDirector sharedDirector] pause];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
	[[CCDirector sharedDirector] resume];
}


- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
	[[CCDirector sharedDirector] purgeCachedData];
}

-(void) applicationDidEnterBackground:(UIApplication*)application {
    
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [self scheduleAlarm];
    
    bool isInGame = ([[CCDirector sharedDirector] runningScene].tag == 1);
    if (isInGame)
    {
        //we are playing the game right now, need to show the pause screen
        PauseScene *menuScene = [PauseScene node];
        [[CCDirector sharedDirector] pushScene: menuScene];
    }
	[[CCDirector sharedDirector] stopAnimation];
}

-(void) applicationWillEnterForeground:(UIApplication*)application {
    
	[[CCDirector sharedDirector] startAnimation];
    [[AdsManager sharedAdsManager] showAdOnActive];
}

- (void)applicationWillTerminate:(UIApplication *)application {
	[[CCDirector sharedDirector] end];
}

- (void)applicationSignificantTimeChange:(UIApplication *)application {
	[[CCDirector sharedDirector] setNextDeltaTimeZero:YES];
}

- (void)dealloc {
	[[CCDirector sharedDirector] release];
	[window release];
	[super dealloc];
}

-(void) scheduleAlarm {
    NSLog(@"scheduleAlarm");
    NSCalendar *calendar = [NSCalendar autoupdatingCurrentCalendar];
    // Get the current date
    NSDate *pickerDate = [NSDate date];
    
    // Break the date up into components
    NSDateComponents *dateComponents = [calendar components:( NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit )fromDate:pickerDate];
    NSDateComponents *timeComponents = [calendar components:( NSHourCalendarUnit | NSMinuteCalendarUnit| NSSecondCalendarUnit )fromDate:pickerDate];
    // Set up the fire time
    
    UILocalNotification *localNotif; 
    
    int delay;
    for(int i=0;i<5;i++)
    {
        
        switch (i) {
            case 0:
                delay = 2;
                break;
            case 1:
                delay = 4;
                break;
            case 2:
                delay = 6;
                break;
            case 3:
                delay = 12;
                break;
            case 4:
                delay = 20;
                break;
                
                
            default:
                break;
        }
        
        NSDateComponents *dateComps = [[NSDateComponents alloc] init];
        [dateComps setDay:[dateComponents day] + delay];
        [dateComps setMonth:[dateComponents month]];
        [dateComps setYear:[dateComponents year]];
        [dateComps setHour:[timeComponents hour]];
        [dateComps setMinute:[timeComponents minute] + 0];
        [dateComps setSecond:[timeComponents second] + 0];
        NSDate *itemDate = [calendar dateFromComponents:dateComps];
        [dateComps release];
        
        localNotif = [[UILocalNotification alloc] init];
        if (localNotif == nil)
            return;
        localNotif.fireDate = itemDate;
        localNotif.timeZone = [NSTimeZone defaultTimeZone];
        
        // Notification details
        localNotif.alertBody = [self getRandomLocalPushMessage];
        // Set the action button
        localNotif.alertAction = @"View";
        localNotif.soundName = @"pushsound1.caf";//@"explode.caf";
        localNotif.applicationIconBadgeNumber = 1;
        
        // Specify custom data for the notification
        NSDictionary *infoDict = [NSDictionary dictionaryWithObject:@"someValue" forKey:@"someKey"];
        localNotif.userInfo = infoDict;
        
        // Schedule the notification
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
        [localNotif release];
    }
}

-(NSString*) getRandomLocalPushMessage
{
    int rand = arc4random()%6;
    NSString *message;
    switch (rand) {
        case 0:
            message = @"Run run run ! from the Slenderman!";
            break;
        case 1:
            message = @"And do the Harlem Shake...";
            break;
        case 2:
            message = @"Quick jump in and fire up that Shotgun";
            break;
        case 3:
            message = @"Someone Just Beat Your High Score! Lets Go For A Ride with the Harlem Dead";
            break;
        case 4:
            message = @"Are You Ok? You Haven't Blowed Up Zombies Lately...Wanna Shoot With Me?";
            break;
        case 5:
            message = @"Quick! Zombie Slender invasion! Only You Can Prevent Boredom.";
            break;
        default:
            message = @"";
    }
    return message;
}


@end