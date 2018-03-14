//
//  PageBaseViewController.mm
//  iEngine
//
//  Created by Muhammed Safiul Azam on 9/14/09.
//  Copyright 2009 Home. All rights reserved.
//

#import "PageBaseViewController.h"


@implementation PageBaseViewController


 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil parent:(PageBaseViewController *) parent {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
	
	_parent = parent;
	
	_rotate = 0.0;
	
    return self;
}

-(PageBaseViewController *) getParent {
	
	return _parent;
}

-(CGFloat) getRotate {
	
	return _rotate;
}

-(void) setRotate:(CGFloat) rotate {
	
	self.view.transform = CGAffineTransformRotate(self.view.transform, (rotate - _rotate) * M_PI / 180);
	
	_rotate = rotate;
}

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    
	[super viewDidLoad];
	
	self.wantsFullScreenLayout = YES;
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


- (void)dealloc {
    
	[[LogUtility getInstance] printMessage:@"PageBaseViewController - dealloc"];
	
	[super dealloc];
}


@end
