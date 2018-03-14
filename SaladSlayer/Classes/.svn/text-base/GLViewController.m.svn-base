//
//  GLAppDelegate.m
//

#import <UIKit/UIKit.h>
#import "GLViewController.h"
#import "GLView.h"
#import <AudioToolbox/AudioToolbox.h>

@implementation GLViewController

#pragma mark Properties

@synthesize wentToSecondaryWindow, mode;

#pragma mark FadeIn/FadeOut

-(void) viewWillFadeIn {
	if (!wentToSecondaryWindow) {
		//Game mode
		((GLView *) self.view).mainGame.mode = mode;
		
		//Loading
		[(GLView *) self.view resetAll];
		[(GLView *) self.view loadTextures];
		[(GLView *) self.view drawFrame];
	}
	
	//Super
	[super viewWillFadeIn];
}

-(void) viewDidFadeIn {
	if (!wentToSecondaryWindow) {
		//Start animation
		[(GLView *) self.view startAnimation];	
	} else {
		self.wentToSecondaryWindow = FALSE;
	}
	
	//Super
	[super viewDidFadeIn];
}

#pragma mark Custom

-(void) quitToMainMenu {
	//Sound
	[[Audio sharedAudio] playSound: @"tumtum"];
	
	//Unloading
	[(GLView *) self.view stopAnimation];
	[(GLView *) self.view unloadTextures];
	
	//Quit to main menu
	[self dismissFadingViewController];
}

#pragma mark GKLeaderboardViewControllerDelegate, GKAchievementViewControllerDelegate

-(void)leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController {
	[self dismissModalViewControllerAnimated: YES];
}

#pragma mark OS Events

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	if ((self=[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
		//Create notifications
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willResignActive:) name:UIApplicationWillResignActiveNotification object:nil];
		
		if (&UIApplicationWillEnterForegroundNotification)
			[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
		
		if (&UIApplicationDidEnterBackgroundNotification)
			[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
		
		//Initialize objects in GLView
		[(GLView *) self.view initializeObjects: self];	
	}
	
	return self;
}

-(void) didBecomeActive:(NSNotification *)notification {	
}

-(void) willResignActive:(NSNotification *)notification {
	[(GLView *) self.view pauseGame];
}

-(void) willEnterForeground:(NSNotification *)notification {
}

-(void) didEnterBackground:(NSNotification *)notification {
}

#pragma mark Memory management

-(void)dealloc {
	//OS Notifications
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	
	//Debug
	NSLog(@"GLViewController deallocated");

	//Super
    [super dealloc];
}

-(void)didReceiveMemoryWarning {
	//Debug
	NSLog(@"Memory warning!");
	
	//Vibrate
	//AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);

	//Super
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	
	//Exit to menu to free up textures
	[self quitToMainMenu];
}

@end
