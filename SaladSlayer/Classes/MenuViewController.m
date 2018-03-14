//
//  MenuViewController.m
//

#import "MenuViewController.h"

@implementation MenuViewController

#pragma mark Load/FadeIn/FadeOut

-(void) viewDidLoad {
	//RunCounter
	int runCount = [[NSUserDefaults standardUserDefaults] integerForKey: @"RunCount"];
	if (runCount % 5 == 3 && isFullGame == FALSE) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle: nil message: @"The premium version includes:\r\nMultiple game modes\r\nGame Center leaderboards\r\nMultiple swords\r\nDo you want to but it?" delegate:self cancelButtonTitle:@"No way!" otherButtonTitles: @"Yeah!", nil];
		[alert show];
		[alert release];
	}
	runCount++;
	[[NSUserDefaults standardUserDefaults] setInteger: runCount forKey: @"RunCount"];
	[[NSUserDefaults standardUserDefaults] synchronize];

	//Full/Free
	[btnScores setImage: isFullGame ? [UIImage imageNamed: @"btnBuyNow.png"] : [UIImage imageNamed: @"btnBuyNow.png"] forState: UIControlStateNormal];
	[imgLogo setImage: isFullGame ? [UIImage imageNamed: @"imgLogoLite.png"] : [UIImage imageNamed: @"imgLogoLite.png"]];
	
	//Play sound
	[[Audio sharedAudio] playSound: @"tumtum"];
	
	//Reset
	[self resetControls];
    
    bannerView_ = [[GADBannerView alloc]
                   initWithFrame:CGRectMake(85,270,320,50)];
    
    // Specify the ad's "unit identifier." This is your AdMob Publisher ID.
    bannerView_.adUnitID = @"a14c03e582abc4b";
    
    // Let the runtime know which UIViewController to restore after taking
    // the user wherever the ad goes and add it to the view hierarchy.
    bannerView_.rootViewController = self;
    [self.view addSubview:bannerView_];
    
    // Initiate a generic request to load it with an ad.
    [bannerView_ loadRequest:[GADRequest request]];
	[super viewDidLoad];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex == 1)
		[[UIApplication sharedApplication] openURL: [NSURL URLWithString:fullGameURL]];		
}

-(void) viewWillFadeIn {
	//Reset
	[self resetControls];
	[super viewWillFadeIn];
}

-(void) viewDidFadeIn {
	//Animate
	[self animateControlsIn];
	[super viewDidFadeIn];
}

#pragma mark Animations 

-(void) resetControls {
	CGRect frm1 = imgLogo.frame;
	frm1.origin.y = -imgLogo.frame.size.height;
	imgLogo.frame = frm1;

	CGRect frm2 = imgPanel.frame;
	frm2.origin.y = screenHeight;
	imgPanel.frame = frm2;
	
	CGRect frm3 = btnPlay.frame;
	frm3.origin.x = -btnPlay.frame.size.width;
	btnPlay.frame = frm3;
	
	CGRect frm4 = btnOptions.frame;
	frm4.origin.x = screenWidth;
	btnOptions.frame = frm4;
	
	CGRect frm5 = btnScores.frame;
	frm5.origin.x = -btnScores.frame.size.width;
	btnScores.frame = frm5;
	
	CGRect frm6 = btnHelp.frame;
	frm6.origin.y = screenHeight;
	btnHelp.frame = frm6;	

	imgSwords.alpha = 0.0;
}

-(void) animateControlsIn {
	//Animation 1
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:1.50];
	[UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
	
	imgSwords.alpha = 1.0;
	
	[UIView commitAnimations];
	
	//Animation 2
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.25];
	[UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
	
	CGRect frm1 = imgLogo.frame;
	frm1.origin.y = 0;
	imgLogo.frame = frm1;
	
	CGRect frm2 = imgPanel.frame;
	frm2.origin.y = 97;
	imgPanel.frame = frm2;
	
	CGRect frm3 = btnPlay.frame;
	frm3.origin.x = 77;
	btnPlay.frame = frm3;
	
	CGRect frm4 = btnOptions.frame;
	frm4.origin.x = 77;
	btnOptions.frame = frm4;
	
	CGRect frm5 = btnScores.frame;
	frm5.origin.x = 77;
	btnScores.frame = frm5;
	
	CGRect frm6 = btnHelp.frame;
	frm6.origin.y = 278;
	btnHelp.frame = frm6;
	
	[UIView commitAnimations];
	
	[[Audio sharedAudio] playSound: @"whoosh1"];
}

#pragma mark UI Events

-(void) startGame {
	//Play sound
	[[Audio sharedAudio] playSound: @"touch"];
	
	//Present play mode controller
	PlayModeViewController *pmvc = [[[PlayModeViewController alloc] initWithNibName: @"PlayModeViewController" bundle: nil] autorelease];
	[self presentFadingViewController: pmvc];
}

-(void) showOptions {
	//Play sound
	[[Audio sharedAudio] playSound: @"touch"];	

	//Present options controller
	OptionsViewController *ovc = [[[OptionsViewController alloc] initWithNibName: @"OptionsViewController" bundle: nil] autorelease];
	[self presentFadingViewController: ovc];
}

-(void) showAchievements {
	//Play sound
	[[Audio sharedAudio] playSound: @"touch"];
	
	//Full/Free
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://itunes.apple.com/us/app/fruit-slayer!/id492296208?ls=1&mt=8"]];
}

-(void) showHelp {
	//Play sound
	[[Audio sharedAudio] playSound: @"touch"];
	
	//Present help controller
	HelpViewController *hvc = [[[HelpViewController alloc] initWithNibName: @"HelpViewController" bundle: nil] autorelease];
	[self presentFadingViewController: hvc];
}

#pragma mark GKLeaderboardViewControllerDelegate, GKAchievementViewControllerDelegate

-(void)leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController {
	[self dismissModalViewControllerAnimated: YES];
}

-(void) achievementViewControllerDidFinish:(GKAchievementViewController *)viewController {
	[self dismissModalViewControllerAnimated: YES];
}

#pragma mark OS Events

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

#pragma mark Memory management

-(void) dealloc {
	NSLog(@"Menu deallocated");
	
	//Super
	[super dealloc];
}

-(void)viewDidUnload {
    [bannerView_ release];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}

@end