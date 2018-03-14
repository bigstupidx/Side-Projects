//
//  PageTitleViewController.mm
//  iEngine
//
//  Created by Muhammed Safiul Azam on 11/6/09.
//  Copyright 2009 None. All rights reserved.
//

#import "PageMenuViewController.h"
#import "Chartboost.h"
#import "GameKitHelper.h"
#import "AppSpecificValues.h"
#import "GameCenterManager.h"
#import "InAppPurchaseManager.h"
#import "Flurry.h"
#import "Globals.h"

@implementation PageMenuViewController

@synthesize currentLeaderBoard;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    
	[super viewDidLoad];
    self.currentLeaderBoard = kLeaderboardID;
    
    _gameCenter.hidden = YES; //Meng: we don't add leaderboard because the game's viewcontroller has problem.
    
    _imageViewSplash.backgroundColor = [UIColor clearColor];
	
    //NSNumber *resume = [[Preferences getInstance] getValue:KEY_RESUME];
    
    //if(resume == nil || [resume integerValue] == 0)
        _buttonResume.hidden = YES;
    
    NSArray *scores = [[Highscore getInstance] getScores];
    
    _labelHighscore.font = [UIFont fontWithName:@"Arial-BoldMT" size:22.0];
    if(scores == nil || [scores count] == 0)
            _labelHighscore.text = @"0";
    else
    {
        Score *score = [scores objectAtIndex:0];
        _labelHighscore.text = [[score getScore] stringValue];
    }
    
    NSNumber *sound = [[Preferences getInstance] getValue:KEY_SOUND];
    if(sound == nil || [sound intValue] == 1)
        [self soundOnTapped:nil];
    else
        [self soundOffTapped:nil];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];    
    [defaults setBool:false forKey:@"we are in purchase page"];
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
    
}

-(IBAction) resumeTapped:(id) sender {
    
    PageMainViewController *pageMainViewController = (PageMainViewController *) [self getParent];
	[pageMainViewController gotoPage:PageMarket parameters:[NSNumber numberWithInt:PageTransitionFadeIn]];
    
    [[SoundManager getInstance] playSound:SOUND_CLICK];
}

- (void) authenticateLocalPlayer
{
    GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
    
    if (localPlayer.isAuthenticated)
        return;
    
    [localPlayer authenticateWithCompletionHandler:^(NSError *error) {
        if (error == nil)
        {
            NSLog(@"Authentication successful");
        }
        else {
            NSLog(@"Authentical failed");
        }
    }];
    
}

-(UIViewController*) getRootViewController {
    return [UIApplication
            sharedApplication].keyWindow.rootViewController;
}

-(IBAction) gameCenterTapped:(id) sender {
    
    
    
    [Flurry logEvent:@"MainMenu_LeaderButton"];
    
    [self authenticateLocalPlayer];
    
 	GKLeaderboardViewController *leaderboardController = [[GKLeaderboardViewController alloc] init];
	if (leaderboardController != NULL)
	{
		leaderboardController.category = self.currentLeaderBoard;
		leaderboardController.timeScope = GKLeaderboardTimeScopeWeek;
		leaderboardController.leaderboardDelegate = self;
        //[self presentModalViewController:leaderboardController animated:YES];
        
        UIViewController* rootVC = [self getRootViewController];
        [rootVC presentViewController:leaderboardController animated:YES
                           completion:nil];
       // [self presentViewController:leaderboardController animated:YES];
        
	}
     
     
}

- (void)leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
{
	[self dismissModalViewControllerAnimated: YES];
	[viewController release];
}

-(IBAction) freeGamesTapped:(id)sender {
    Chartboost *cb=[Chartboost sharedChartboost];
    [cb showMoreApps];
}

-(IBAction) playTapped:(id) sender {
    
    [Avatar reset];
    [Fire reset];
    [Hit reset];
    
    [[Preferences getInstance] setValue:[NSNumber numberWithInt:0] :KEY_RESUME];
    [[Preferences getInstance] setValue:[NSNumber numberWithInt:0] :KEY_PLAYER_AVATAR];
    [[Preferences getInstance] setValue:[NSNumber numberWithInt:0] :KEY_PLAYER_FIRE];
    [[Preferences getInstance] setValue:[NSNumber numberWithInt:0] :KEY_PLAYER_HIT];
    [[Preferences getInstance] setValue:[NSNumber numberWithInt:0] :KEY_PLAYER_LEVEL];
    [[Preferences getInstance] setValue:[NSNumber numberWithInt:0] :KEY_PLAYER_MONEY];
    [[Preferences getInstance] setValue:[NSNumber numberWithInt:0] :KEY_PLAYER_SCORE];
    
    PageMainViewController *pageMainViewController = (PageMainViewController *) [self getParent];
	[pageMainViewController gotoPage:PageMarket parameters:[NSNumber numberWithInt:PageTransitionFadeIn]];
    
    [[SoundManager getInstance] playSound:SOUND_CLICK];
}

-(IBAction) highscoreTapped:(id) sender {
    
    PageMainViewController *pageMainViewController = (PageMainViewController *) [self getParent];
	[pageMainViewController gotoPage:PageHighscore parameters:[NSNumber numberWithInt:PageTransitionFadeIn]];
    
    [[SoundManager getInstance] playSound:SOUND_CLICK];
}

-(IBAction) soundOnTapped:(id) sender
{
    [[Preferences getInstance] setValue:[NSNumber numberWithInt:1] :KEY_SOUND];
    
    [[SoundManager getInstance] setMusic:YES];
    [[SoundManager getInstance] setSound:YES];
    
    _buttonSoundOn.hidden = YES;
    _buttonSoundOff.hidden = NO;
    
    if(sender != nil)
        [[SoundManager getInstance] playSound:SOUND_CLICK];
}

-(IBAction) soundOffTapped:(id) sender
{
    [[Preferences getInstance] setValue:[NSNumber numberWithInt:0] :KEY_SOUND];
    
    [[SoundManager getInstance] setMusic:NO];
    [[SoundManager getInstance] setSound:NO];
    
    _buttonSoundOn.hidden = NO;
    _buttonSoundOff.hidden = YES;
}

- (void)dealloc {

    [[LogUtility getInstance] printMessage:@"PageMenuViewController - dealloc"];
    
    [super dealloc];
}


@end
