
#import "FruitSlayerAppDelegate.h"

@implementation FruitSlayerAppDelegate

@synthesize window;
@synthesize menuViewController;
@synthesize highPerformance;

-(void)applicationDidFinishLaunching:(UIApplication *)application {
	//Detect device performance
	highPerformance = [self isHighPerformanceSystem];
	
	//Initialize scoring manager
	if (isFullGame)
	//	[GameKitLibrary sharedGameKit];
        NSLog(@"Help");
	//Initiate audio
	Audio *audio = [Audio sharedAudio];
	if (![audio canPlayMusic]) {
		[audio suspendMusic];
	} else {
		[audio playMusic: @"rainforest" Loop: TRUE];
	}
	
	//Setup window with menu view controller
	self.menuViewController = [[MenuViewController	alloc] initWithNibName:@"MenuViewController" bundle:nil];
	[window addSubview: menuViewController.view];
	[window makeKeyAndVisible];
	
	//Fade in first view controller
	[menuViewController setRootFadingViewController];
}

- (void)applicationWillResignActive:(UIApplication *)application {
	[[Audio sharedAudio] suspendMusic];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
	[[Audio sharedAudio] resumeMusic];
}

#pragma mark Memory management

- (void)dealloc {
	[menuViewController release];
    [window release];
    [super dealloc];
}

#pragma mark System capabilities

-(bool) isHighPerformanceSystem {
	size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *answer = malloc(size);
	sysctlbyname("hw.machine", answer, &size, NULL, 0);
	NSString *results = [NSString stringWithCString:answer encoding: NSUTF8StringEncoding];
	free(answer);
	
	if ([results isEqualToString: @"iPod1,1"] || [results isEqualToString: @"iPod2,1"] || [results isEqualToString: @"iPod2,2"] || [results isEqualToString: @"iPhone1,1"]  || [results isEqualToString: @"iPhone1,2"]) 
		return FALSE;
	else
		return TRUE;
}


@end
