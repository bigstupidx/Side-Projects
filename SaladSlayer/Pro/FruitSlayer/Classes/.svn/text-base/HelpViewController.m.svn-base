//
//  HelpViewController.m
//

#import "HelpViewController.h"

@implementation HelpViewController

#pragma mark UI Events

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
	NSLog(@"Help deallocated");
	
	//Release outlets
	[imgBackground release];
	[imgSwords release];
	[imgPanel release];
	[btnBack release];
	
	//Super
	[super dealloc];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}

@end