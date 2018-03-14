//
//  FadingViewController.m
//
//  Created by Craig Hockenberry on 9/12/10.
//  Copyright 2010 The Iconfactory, Inc. All rights reserved.
//

#define DEBUG_VIEW_STATES 0

#import "FadingViewController.h"

const float fadeAnimationDuration = 0.20f;

@interface FadingViewController ()

@property (nonatomic, assign) FadingViewController *presentingViewController;
@property (nonatomic, retain) FadingViewController *presentedViewController;
@property (nonatomic, retain) FadingViewController *replacementViewController;
@property (nonatomic, retain) UIView *overlay;

-(void) fadeToBlack;
-(void) fadeToBlackFinished:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context;
-(void) fadeFromBlack;

@end

@implementation FadingViewController

@synthesize presentingViewController;
@synthesize presentedViewController;
@synthesize replacementViewController;
@synthesize overlay;

- (void)setRootFadingViewController {
	self.presentingViewController = nil;
	[self fadeFromBlack];
}

- (void)presentFadingViewController:(FadingViewController *)newViewController {
	if (! self.presentedViewController) {
		self.presentedViewController = newViewController;
		newViewController.presentingViewController = self;
		[self fadeToBlack];
	}
}

- (void)replaceFadingViewControllerWith:(FadingViewController *)newViewController {
	newViewController.presentingViewController = presentingViewController;
	newViewController.presentedViewController = presentedViewController;
	presentingViewController.replacementViewController = newViewController;
	[self dismissFadingViewController];
}

- (void)dismissFadingViewController {
	[self fadeToBlack];
}

#pragma mark Fade to black

- (void)fadeToBlackFinished:(NSString*)animationID finished:(NSNumber*)finished context:(void*)context {
	if (presentingViewController.replacementViewController) {
#if DEBUG_VIEW_STATES
		DebugLog(@"%s %@ replacing %@ on %@", __PRETTY_FUNCTION__, self, presentingViewController.replacementViewController, presentingViewController);
#endif
		
		[self viewWillFadeOut];
		[self.view removeFromSuperview];
		[self viewDidFadeOut];

		[presentingViewController.view addSubview:presentingViewController.replacementViewController.view];
		[presentingViewController.replacementViewController viewWillFadeIn];
		[presentingViewController.replacementViewController fadeFromBlack];
	}
	else {
		if (presentedViewController) {
#if DEBUG_VIEW_STATES
			DebugLog(@"%s presenting %@ on %@", __PRETTY_FUNCTION__, presentedViewController, self);
#endif
			
			[self.view addSubview:presentedViewController.view];

			[presentedViewController viewWillFadeIn];
			[self viewWillFadeOut];

			[presentedViewController fadeFromBlack];
		}
		else {
#if DEBUG_VIEW_STATES
			DebugLog(@"%s dismissing %@ on %@", __PRETTY_FUNCTION__, self, presentingViewController);
#endif
			
			[presentingViewController viewWillFadeIn];
			[self viewWillFadeOut];

			[self.view removeFromSuperview];
			[presentingViewController fadeFromBlack];
		}
	}
}

- (void)fadeToBlack {	
	[self.view bringSubviewToFront:overlay];	

	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:fadeAnimationDuration];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(fadeToBlackFinished:finished:context:)];
	
	[overlay setAlpha:1.0];
	
	[UIView commitAnimations];
}

#pragma mark Fade from black

- (void)fadeFromBlackFinished:(NSString*)animationID finished:(NSNumber*)finished context:(void*)context {
	if (presentingViewController.replacementViewController) {
#if DEBUG_VIEW_STATES
		DebugLog(@"%s replaced %@ on %@", __PRETTY_FUNCTION__, self, presentingViewController);
#endif

		presentingViewController.presentedViewController = self;
		presentingViewController.replacementViewController = nil;

		[self viewDidFadeIn];
	}
	else {
		if (presentedViewController) {
#if DEBUG_VIEW_STATES
			DebugLog(@"%s dismissed %@ on %@", __PRETTY_FUNCTION__, presentedViewController, self);
#endif

			[self viewDidFadeIn];
			[presentedViewController viewDidFadeOut];

			self.presentedViewController = nil;
		}
		else {
#if DEBUG_VIEW_STATES
			DebugLog(@"%s presented %@ on %@", __PRETTY_FUNCTION__, self, presentingViewController);
#endif
			
			[self viewDidFadeIn];
			[presentingViewController viewDidFadeOut];
		}
	}
}

- (void)fadeFromBlack {
	[self.view bringSubviewToFront:overlay];
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:fadeAnimationDuration];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(fadeFromBlackFinished:finished:context:)];
	
	[overlay setAlpha:0.0];
	
	[UIView commitAnimations];
}

#pragma mark Overlay management

- (void)viewDidLoad {
	[super viewDidLoad];
	
	CGRect screenBounds = CGRectMake(0, 0, screenWidth, screenHeight);
	self.overlay = [[[UIView alloc] initWithFrame:screenBounds] autorelease];
	[overlay setBackgroundColor:[UIColor blackColor]];
	[overlay setAlpha:1.0];
	[overlay setUserInteractionEnabled:FALSE];
	[self.view addSubview:overlay];
	
	[self.view bringSubviewToFront:overlay];
}

- (void)viewDidUnload {
	self.overlay = nil;	
	[super viewDidUnload];
}

- (void)dealloc {
	[overlay release];
	overlay = nil;

	[super dealloc];
}

#pragma mark View management overrides


- (void)viewWillFadeIn {
    // called when the view is about to be presented; default does nothing
#if DEBUG_VIEW_STATES
	DebugLog(@"%s %@ view = 0x%08x", __PRETTY_FUNCTION__, self, self.view);
#endif
}

- (void)viewDidFadeIn {
    // called when the view has been presented on screen; default does nothing
#if DEBUG_VIEW_STATES
	DebugLog(@"%s %@ view = 0x%08x", __PRETTY_FUNCTION__, self, self.view);
#endif
}

- (void)viewWillFadeOut {
    // called when the view is about to be dismissed; default does nothing
#if DEBUG_VIEW_STATES
	DebugLog(@"%s %@ view = 0x%08x", __PRETTY_FUNCTION__, self, self.view);
#endif
}

- (void)viewDidFadeOut {
    // called after the view was dismissed from the screen; default does nothing
#if DEBUG_VIEW_STATES
	DebugLog(@"%s %@ view = 0x%08x", __PRETTY_FUNCTION__, self, self.view);
#endif
}

@end

