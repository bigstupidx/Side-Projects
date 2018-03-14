//
//  PlayModeViewController.m
//

#import "PlayModeViewController.h"

@implementation PlayModeViewController

#pragma mark FadeIn/FadeOut

-(void) viewWillFadeIn {
	//Initiate interface
	NSMutableArray *optionButtons;
	
	//Full/Free
	if (isFullGame)
        optionButtons = [[NSMutableArray alloc] initWithObjects: @"btnClassic.png", @"btnArcadeBuyNow.png", @"btnZenBuyNow.png", nil];	
	else
		optionButtons = [[NSMutableArray alloc] initWithObjects: @"btnClassic.png", @"btnArcade.png", @"btnZen.png", nil];
		
	//Add buttons to scroller
	int currentHeight = 0;
	for (int i=0; i<[optionButtons count]; i++) {
		//Load image
		UIImage *currentImage = [UIImage imageNamed: [optionButtons objectAtIndex: i]];
		
		//Create button
		UIButton *newButton = [UIButton buttonWithType: UIButtonTypeCustom];
		newButton.frame = CGRectMake(0, currentHeight, currentImage.size.width, currentImage.size.height);
		[newButton addTarget:self action:@selector(selectOption:) forControlEvents:UIControlEventTouchUpInside];
		[newButton setImage: currentImage forState:UIControlStateNormal];
		newButton.tag = i;
		
		//Add it to scroller
		[scrollView addSubview:newButton];
		
		//Increment current height
		currentHeight += currentImage.size.height + 5;
	}
    
    bannerView_ = [[GADBannerView alloc]
                   initWithFrame:CGRectMake(85,270,320,50)];
    
    // Specify the ad's "unit identifier." This is your AdMob Publisher ID.
    bannerView_.adUnitID = @"a14d56d404ca6be";
    
    // Let the runtime know which UIViewController to restore after taking
    // the user wherever the ad goes and add it to the view hierarchy.
    bannerView_.rootViewController = self;
    [self.view addSubview:bannerView_];
    
    // Initiate a generic request to load it with an ad.
    [bannerView_ loadRequest:[GADRequest request]];
	
	//Set scroller size
	scrollView.contentSize = CGSizeMake(320, currentHeight - 5);
	
	//Release
	[optionButtons removeAllObjects];
	[optionButtons release];
	optionButtons = nil;
	
	//Super
	[super viewWillFadeIn];
}

#pragma mark UI Events

-(void) selectOption: (id) sender {
	//Play sound
	[[Audio sharedAudio] playSound: @"touch"];
	
	//Identify button
	int butID = ((UIButton *) sender).tag;
	
	//Full/Free
    /*
	if (isFullGame || butID == 0)
        [[UIApplication sharedApplication] openURL: [NSURL URLWithString:fullGameURL]];
	else
		[self startGameMode: butID];
     */
    
    if (butID == 0) {
        [self startGameMode: butID];
    }
    
    else {
        [[UIApplication sharedApplication] openURL: [NSURL URLWithString:fullGameURL]];

    }
}

-(void) startGameMode: (int) mode {
	//Stop menu music and play sound
	[[Audio sharedAudio] playSound: @"tumtum"];
	
	//Create OpenGLES controller
	GLViewController *glViewController = [[[GLViewController alloc] initWithNibName:@"GLViewController" bundle:nil] autorelease];
	
	//Set game mode
	glViewController.mode = mode;
	
	//Perform view switch
	[self replaceFadingViewControllerWith: glViewController];
}

-(void) back {
	//Play sound
	[[Audio sharedAudio] playSound: @"touch"];
	
	//Dismiss
	[self dismissFadingViewController];
}

#pragma mark OS Events

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

#pragma mark Memory management

-(void) dealloc {
	//Release outlets
	[imgBackground release];
	[imgSwords release];
	[imgPanel release];
	[scrollView release];
	[btnBack release];
	
	//Debug
	NSLog(@"PlayMode deallocated");
	
	//Super
	[super dealloc];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}

@end