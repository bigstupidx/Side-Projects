//
//  PageLogoViewController.mm
//  iEngine
//
//  Created by Muhammed Safiul Azam on 11/6/09.
//  Copyright 2009 None. All rights reserved.
//

#import "PageLoadViewController.h"


@implementation PageLoadViewController

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
	
	_imageViewLoad.backgroundColor = [UIColor clearColor];
	
	CGFloat time = [(NSNumber *) [[Preferences getInstance] getValue:KEY_LOGO_TIME] floatValue];
	_timerPlay = [NSTimer scheduledTimerWithTimeInterval:time target:self selector:@selector(gotoPlay:) userInfo:nil repeats:NO];	
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

-(void) gotoPlay:(NSTimer *) timer {
	
	[_timerPlay invalidate];
	_timerPlay = nil;
	
	/*[UIView beginAnimations:nil context:nil];
	[UIView setAnimationsEnabled:YES];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDuration:[(NSNumber *) [[Preferences getInstance] getValue:KEY_ANIMATION_TIME_MEDIUM] floatValue]];
	[UIView setAnimationBeginsFromCurrentState:NO];
	[UIView setAnimationDidStopSelector:@selector(fadeAnimationDidStop:finished:context:)];
	
	[UIView commitAnimations];*/
    
    PageMainViewController *pageMainViewController = (PageMainViewController *) [self getParent];
	[pageMainViewController gotoPage:PagePlay parameters:[NSNumber numberWithInt:PageTransitionFadeIn]];	
}

/*-(void) fadeAnimationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
	
	PageMainViewController *pageMainViewController = (PageMainViewController *) [self getParent];
	[pageMainViewController gotoPage:PagePlay parameters:[NSNumber numberWithInt:PageTransitionFadeIn]];	
}*/

- (void)dealloc 
{
	[_timerPlay invalidate];
	_timerPlay = nil;
    
    [[LogUtility getInstance] printMessage:@"PageLoadViewController - dealloc"];
    
    [super dealloc];
}


@end
