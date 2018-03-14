//
//  PagePlayViewController.mm
//  iEngine
//
//  Created by Muhammed Safiul Azam on 11/6/09.
//  Copyright 2009 None. All rights reserved.
//

#import "PagePlayViewController.h"


@implementation PagePlayViewController


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
    
    [[PlayWindow alloc] initWithFrame:self.view.frame :self];
    [PlayWindow getInstance].contentMode = UIViewContentModeScaleAspectFit;
	[PlayWindow getInstance].autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin |  UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	[self.view insertSubview:[PlayWindow getInstance] atIndex:0];
    [[PlayWindow getInstance] setRequiredFPS:24];
	[[PlayWindow getInstance] start];
    
    _alertView = NO;
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

-(IBAction) leftTapped:(id) sender
{
    [[PlayWindow getInstance] leftButtonTapped];
}

-(IBAction) leftReleased:(id) sender
{
    [[PlayWindow getInstance] leftButtonReleased];
}

-(IBAction) rightTapped:(id) sender
{
    [[PlayWindow getInstance] rightButtonTapped];
}

-(IBAction) rightReleased:(id) sender
{
    [[PlayWindow getInstance] rightButtonReleased];
}

-(IBAction) fireTapped:(id) sender
{
    [[PlayWindow getInstance] fireButtonTapped];
}

-(IBAction) hitTapped:(id) sender
{
    [[PlayWindow getInstance] hitButtonTapped];
}

-(IBAction) pauseTapped:(id) sender
{
    if(sender != nil)
    {
        if(![[PlayWindow getInstance] isRunning])
            return;
        else if([[PlayWindow getInstance] getMode] == ModeSuccess || [[PlayWindow getInstance] getMode] == ModeFail || [[PlayWindow getInstance] getMode] == ModeMessage)
            return;
    
        [[PlayWindow getInstance] pause];
    }
    
    NSArray *others = [NSArray arrayWithObjects:@"Quit", nil];
    UIAlertView *alertView = [[UIUtility getInstance] showAlert:nil :nil :self :@"Resume" :others];
    alertView.tag = RESUME_TAG;
    [alertView show];
    
    _alertView = YES;
    
    if(sender != nil)
        [[SoundManager getInstance] playSound:SOUND_CLICK];
}

- (void)alertView:(UIAlertView *) alertView didDismissWithButtonIndex:(NSInteger) buttonIndex
{
    if(alertView.tag == RESUME_TAG)
    {
        if(buttonIndex == 0)
        {
            [[PlayWindow getInstance] resume];
        }
        else if(buttonIndex == 1)
        {
            NSArray *others = [NSArray arrayWithObjects:@"Yes", nil];
            UIAlertView *alertView = [[UIUtility getInstance] showAlert:@"Are you sure?" :nil :self :@"No" :others];
            alertView.tag = QUIT_TAG;
            [alertView show];
            
            _alertView = YES;
            return;
        }
    }
    else if(alertView.tag == QUIT_TAG)
    {
        if(buttonIndex == 0)
        {
            [[PlayWindow getInstance] resume];
        }
        else if(buttonIndex == 1)
        {
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
            [pageMainViewController gotoPage:PageMenu parameters:[NSNumber numberWithInt:PageTransitionFadeIn]];
        }
    }
    
    _alertView = NO;
}

-(void) pause
{
    [[PlayWindow getInstance] pause];
}

-(void) resume
{
    if(![[PlayWindow getInstance] isAlertView] && !_alertView)
        [self pauseTapped:nil];
}

- (void) dealloc 
{
    [[PlayWindow getInstance] stop];
    [[PlayWindow getInstance] removeFromSuperview];
    [PlayWindow destroyInstance];
    
    [[TextureManager getInstance] releaseAllTextures];
    
    [[LogUtility getInstance] printMessage:@"PagePlayViewController - dealloc"];
    
	[super dealloc];
}


@end
