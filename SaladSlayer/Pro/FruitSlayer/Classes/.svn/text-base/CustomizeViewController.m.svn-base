//
//  CustomizeViewController.m
//

#import "CustomizeViewController.h"

@implementation CustomizeViewController

#pragma mark FadeIn/FadeOut

-(void) viewWillFadeIn {
	//Initiate interface
	NSMutableArray *optionButtons = [[NSMutableArray alloc] initWithObjects: @"btnSword1.png", @"btnSword2.png", @"btnSword3.png", @"btnSword4", @"btnSword5", nil];
	
	//Add buttons to scroller
	int currentHeight = 0;
	
	//Full/Free
	int iMax = isFullGame ? [optionButtons count] : 3;
	
	for (int i=0; i<iMax; i++) {
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
	
	//Save selected option
	NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
	[def setInteger: butID forKey: @"selectedOption"];
	[def synchronize];
	
	//Dismiss
	[self dismissFadingViewController];
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
	NSLog(@"Customize deallocated");
	
	//Release outlets
	[imgBackground release];
	[imgSwords release];
	[imgPanel release];
	[scrollView release];
	[btnBack release];
	
	//Super
	[super dealloc];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}

@end